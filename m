Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04AC3292AC9
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 17:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730398AbgJSPrZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 11:47:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730284AbgJSPrX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 11:47:23 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40970C0613CE
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 08:47:23 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id qp15so14584520ejb.3
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 08:47:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/7dlTxDiqmcYkSqeqEAM+MSSzQMjAQV5ACnbOJwdXNY=;
        b=GKPSIti2Z/Los0GUsvzfd9b0pNWNRyk+Tp6tSJGWcodh0ZDS5rAPvU9/PP5UueYRae
         LTe0tyMpJZyGoqqmLOhvPZy7dgX7XgwaPENmWQhJzDi6QF5n3X0R7Y7EncbENJsahSSY
         ZFR77cCmsWF4Hc0odVeXoQVhNHFRhLdTFzeO2VpDnVX0zQdA2e6uoOj+nDFJjmMveApN
         IdVippUwlK0s6VWNuDj31K2HTeVxFujFVrJZh6VXowRdg9iptmvk++8Exj3X9Yj3eH1j
         qrqELC1FidYtjTsia++6v1J8QNZ0iNkUqdGzrSXlK9xy3Aul39YiNzJa3CtjIjFCv7qw
         3GSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/7dlTxDiqmcYkSqeqEAM+MSSzQMjAQV5ACnbOJwdXNY=;
        b=KtOwpQ3rIyvroUmjpOCfneBIO6SgVL3eoIVQK6C7G30muFoJ/0lRCf+KetIkq8ZFqt
         Spi+U6lfVSaZxigzIzfTFy5zRmkX7A8lEOJXElz24HFS51fpQaIMvArmtQ8yQWs5ZQTX
         7bdaMRAa4ZqN/e9i2n86RJ013R6svKkdFlRiMDHqS+N5L0+9ujN59K4+j7bNpQHhDIlW
         5YFKFxOEQOkjprnyoTy4nOtpA4bIQmx2vilWfXPukM3ROfyyGfBNPIiWGpxumaFIaNZq
         69srFUrl2UYpvTJTxlCFIojVFEpDmlCNSwOKd/brd5s0MCScnOyG+XxhFO1A+Y3ZMnzw
         1Rdw==
X-Gm-Message-State: AOAM532ge9rUXaX65cKOkMsbRuTos4gA+HXa7g44vys2dSDL4TKlyfPF
        zwu/z0X97XIZfayMl+BG9M1hUA==
X-Google-Smtp-Source: ABdhPJz5DJFN2XyIY0pHmL87n5yVNzMdfSg5FjUwur2ImOFkINOE9kNC92wznoRr9FRqBrJlnjZFAw==
X-Received: by 2002:a17:906:453:: with SMTP id e19mr489674eja.391.1603122441874;
        Mon, 19 Oct 2020 08:47:21 -0700 (PDT)
Received: from tsr-lap-08.nix.tessares.net ([2a02:578:85b0:e00:b49:2ba2:dca5:18d2])
        by smtp.gmail.com with ESMTPSA id i23sm499558eja.66.2020.10.19.08.47.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Oct 2020 08:47:21 -0700 (PDT)
To:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, mptcp@lists.01.org,
        linux-kernel@vger.kernel.org
References: <20201019113240.11516-1-geert@linux-m68k.org>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: Re: [PATCH] mptcp: MPTCP_KUNIT_TESTS should depend on MPTCP instead
 of selecting it
Message-ID: <1968b7a6-a553-c882-c386-4b4fde2d7a87@tessares.net>
Date:   Mon, 19 Oct 2020 17:47:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <20201019113240.11516-1-geert@linux-m68k.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Geert,

Thank you for the patch!

On 19/10/2020 13:32, Geert Uytterhoeven wrote:
> MPTCP_KUNIT_TESTS selects MPTCP, thus enabling an optional feature the
> user may not want to enable.  Fix this by making the test depend on
> MPTCP instead.

I think the initial intension was to select MPTCP to have an easy way to 
enable all KUnit tests. We imitated what was and is still done in 
fs/ext4/Kconfig.

But it probably makes sense to depend on MPTCP instead of selecting it. 
So that's fine for me. But then please also send a patch to ext4 
maintainer to do the same there.

Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
