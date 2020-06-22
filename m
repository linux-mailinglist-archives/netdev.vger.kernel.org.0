Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6FE9203628
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 13:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727940AbgFVLuD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 07:50:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727048AbgFVLuC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 07:50:02 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5DFBC061794
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 04:50:02 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id k11so17685014ejr.9
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 04:50:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fH4rNdOd/0DtPCmm7DTynSkeo7LxPbR8dmKw5LybOyU=;
        b=VAmdyUsdN2ivud7I3BUybzNsHUoWtcliplXD1llq7mJ8rXj6Yo00x/zDCgoW7dvJeV
         bhrmghsAG/kmbv4PKQNP/hIEvYBKYjzOlcxtFTHzuS3ulJEruyYSfW1tK/X6fno65QdL
         qnfg0dy/L76P/M9ECK0zlhiG8aheuE+2YUtCMJTyr3n5plQwKFuw3oWCZYwcnuuqxsgL
         7q32ZjqiNBAVsBojvHKsSkHZ7gAs6Pqa8lhXxbjphHS0h//reFYJvRb03tU6hsUe8HqA
         YVrWpKm4Kms6Vt9bS6CbNfD9kNhp4T1vii7iuR0sP9gbCfcvSwHb0lSkH/j2kbiQK3Dk
         uhQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fH4rNdOd/0DtPCmm7DTynSkeo7LxPbR8dmKw5LybOyU=;
        b=L6+fsmsvzPut2qKYHW9Ep3kEyHObH/WGSgjMbSqouAkgQb0zYNYSXQ4q9h/WiNEowf
         7GlMTy+KHk+UHeohDLsn12ZnQMBqzng9xHob8vmgIXNp/h/hRFkwsyPq1RvmlQsQAiAp
         bSx0+9QkT3EQWTJ5zZDqzUJve3XuqAXEzbl8+hRoZmPRPSx1Uegvb5fTvzkmqqAkkYSk
         wFPdPLv83G+tKTaNT19GquLhW2GOWroURlArzQ4+JBNH9ZUHSJfek9IjN8v2SWuaAa/S
         qc04FUjj/c4dKJoWwsk25PwcGqwN/5Q+fgShWreFefNJmkwhaUlRn3HilWQ9ekiH/kjy
         zlnw==
X-Gm-Message-State: AOAM532E0oaWjb7LZ0UWpqAz8CrWKEBuYtBVAmMS4ACZE7/fN5OJ9Eo5
        JTBarwjuRyvwupOReIIGBbMZMA==
X-Google-Smtp-Source: ABdhPJwefaK1G+I1piFrT60Nt4bNSd1j4DovkLJsQ35G8yRg+d4lYAxcsGgWRNP18Z9VzsqIeGXryg==
X-Received: by 2002:a17:906:3c10:: with SMTP id h16mr9735413ejg.87.1592826601230;
        Mon, 22 Jun 2020 04:50:01 -0700 (PDT)
Received: from tsr-lap-08.nix.tessares.net ([81.246.10.41])
        by smtp.gmail.com with ESMTPSA id s2sm12389468edu.39.2020.06.22.04.50.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Jun 2020 04:50:00 -0700 (PDT)
Subject: Re: [PATCH net v2] mptcp: drop sndr_key in mptcp_syn_options
To:     Geliang Tang <geliangtang@gmail.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, mptcp@lists.01.org,
        linux-kernel@vger.kernel.org
References: <60f8315d6ae7b62d175c573f75cee50f14ce988b.1592826171.git.geliangtang@gmail.com>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Message-ID: <1c0f6f37-ede8-b341-f274-2b65b17dc141@tessares.net>
Date:   Mon, 22 Jun 2020 13:50:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <60f8315d6ae7b62d175c573f75cee50f14ce988b.1592826171.git.geliangtang@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Geliang,

On 22/06/2020 13:45, Geliang Tang wrote:
> In RFC 8684, we don't need to send sndr_key in SYN package anymore, so drop

Please next time try to have max 72 chars per line in your commit message ;)

> it.
> 
> Fixes: cc7972ea1932 ("mptcp: parse and emit MP_CAPABLE option according to v1 spec")
> Signed-off-by: Geliang Tang <geliangtang@gmail.com>

Thank you for this v2. It looks good to me!

Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>

Cheers,
Matt
--
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
