Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B66C2222002
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 11:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726201AbgGPJwt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 05:52:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726027AbgGPJws (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 05:52:48 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 737B3C061755
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 02:52:48 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id by13so4286045edb.11
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 02:52:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IDNFH61MgsyQc4A0NihqCrubQBd5FqjGzTiMwsHyeso=;
        b=VKUxwCrZf8OgIJTUNegVFuDaAA6MpR8oVFcDY5vOCnRzH0WCu+lyXC7i53TNJK5pio
         FIQC+2bZyjSAt4gA6+ZSoGR2Nlsc8RNjpxyYYNEqplUFQxTcskrd20yj9Oh64F8F225l
         s0UZcCBXV7hUlDHw7qfTGJ6eZNbpJFm4VKM+p2yfbni114S/Xa2+gox5NnUIdQ+xC0Pg
         ZGi3Da/49kmG39hOLDy8+Jviq/dD5QP0dD0gkTVmWsolYpJD5vGCyAhuKl51gyGZ18fS
         DPmfSxUcnqXXCtxNYRMm5e4WUurekrthNiEye7nsNgnc35ikULwaIUaLpqdUwPKNGF1w
         g7RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IDNFH61MgsyQc4A0NihqCrubQBd5FqjGzTiMwsHyeso=;
        b=Tu7ROSDj5kj31ycUAi4xaSzSzsuEQi6i5+jLoJ0aZcBJ/YoY/8ECTs4GsZgzzgO9qb
         U8sAMGvDEkgRYe9YCwD8BQBQo9p/CGW8znjsJzhSOqa/z80PbBGRWQ1HRVp+Ys5Tpct+
         zZ/fpAeupRNmKBbxE9uX7E1l/DmiycwqTrlkwmLLBq3zL0rzNGkbly7uMqQTXaj4y1bl
         DRNL8jgPLVfT/HrEfRluu1ncrKKvlNibfrJ/QlJw3i7qlQEf347FOddWiM3aMJnel2kX
         AAS6P0qZZaAXA8vsIkTl04mTXVc8xWpKQ4k5GdorInntgwNl2IMTwnOGeAJmHOCn57Fj
         YN5Q==
X-Gm-Message-State: AOAM532bp6N0jokEmVPbpzphV7AGklpRNC0q/WwJlJESUuldTFtaZNx0
        rh5Wk7CeHTIJtXbRazLeX6q9szzY+kM=
X-Google-Smtp-Source: ABdhPJxQi4b5q5o+zT+UyCaW9drGrNuvWkv0GP5PNHZ1+sqUIjkZ/zikrqdF3BsaORl3DuW0/2112w==
X-Received: by 2002:aa7:c3d6:: with SMTP id l22mr3660113edr.148.1594893166901;
        Thu, 16 Jul 2020 02:52:46 -0700 (PDT)
Received: from tsr-lap-08.nix.tessares.net ([79.132.248.22])
        by smtp.gmail.com with ESMTPSA id q17sm4551207ejd.20.2020.07.16.02.52.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jul 2020 02:52:46 -0700 (PDT)
Subject: Re: [PATCH net-next] mptcp: silence warning in subflow_data_ready()
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        mptcp@lists.01.org
References: <87f4954cfd7eacd6e220ab60d61e09f35ed32252.1594844608.git.dcaratti@redhat.com>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Message-ID: <3e97692a-4fa2-9b39-e31a-96deae6f5a57@tessares.net>
Date:   Thu, 16 Jul 2020 11:52:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <87f4954cfd7eacd6e220ab60d61e09f35ed32252.1594844608.git.dcaratti@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Davide,

On 15/07/2020 22:27, Davide Caratti wrote:
> since commit d47a72152097 ("mptcp: fix race in subflow_data_ready()"), it
> is possible to observe a regression in MP_JOIN kselftests. For sockets in
> TCP_CLOSE state, it's not sufficient to just wake up the main socket: we
> also need to ensure that received data are made available to the reader.
> Silence the WARN_ON_ONCE() in these cases: it preserves the syzkaller fix
> and restores kselftests	when they are ran as follows:
> 
>    # while true; do
>    > make KBUILD_OUTPUT=/tmp/kselftest TARGETS=net/mptcp kselftest
>    > done
> 
> Reported-by: Florian Westphal <fw@strlen.de>
> Fixes: d47a72152097 ("mptcp: fix race in subflow_data_ready()")
> Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/47
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>

Thank you for the patch!
It looks good to me and it fixes the kselftests on my side as well!

Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
