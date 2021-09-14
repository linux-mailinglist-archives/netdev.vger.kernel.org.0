Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0611D40A8A8
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 09:51:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231660AbhINHwY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 03:52:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231886AbhINHwH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 03:52:07 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B56ECC0613B5
        for <netdev@vger.kernel.org>; Tue, 14 Sep 2021 00:50:12 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id v20-20020a1cf714000000b002e71f4d2026so1377388wmh.1
        for <netdev@vger.kernel.org>; Tue, 14 Sep 2021 00:50:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fQQsBMV/KZRW/W+H2x46A5MmwVr95aBTpydU/d7M2HU=;
        b=AAjpTdBAhVY5A9abSR3cTV0Gdf/FJZyO4h7UFY9WJwTTbhzLUwas+aaaisHVDEj0k+
         ENHa2/XA9Mh2s5Ju3ON8/Lr5RW6LWd3ohSieGKtfbUJ47Vc42IuhCmLZJUmoKwTBFKxb
         +bjPrKYIZkiMEdJdpuEkMzKp73uofCIQ3mFPnmebzxvzF7NnwHurzMaqZNWz8I5lslyt
         MwP9IP4i3ckQpDiU1NsEbEfrIfu+EHbyC4T7IFlehCsRhQlU+a42wNfzrSHEAoZ1ug1a
         Lgg3to8Ga84J1iDwwtOzDEq3E03H69BSe27MxiDm+iRzgoochO9W329XnnM2IUPaSk2/
         2hbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=fQQsBMV/KZRW/W+H2x46A5MmwVr95aBTpydU/d7M2HU=;
        b=njfYYDj6N5/56tYSXhoiM2WDCszl19QudWpxz3a2dPI7om+V6B3jsvJ48jalZeZiaf
         8J1CNT4rId0jw8NfZ+KZ7+vFdK7+OmTcACjKBaM1kBxOHuQBe064TvFmmLXrhrRxn1I+
         5MJaKHAXEr4C4xOFQuABtErOYTxhVcfYk8ZJyPqj1hjfk8iFxqEUWZ3Yg4lQjpZCkrVM
         NfuwIZiHEbcLW8GBJXUh4iPSL2xgfzkHuhcAaT4Zqz7wITygBXj/8eX2E4R643ZLfo6l
         XSLh5wk5qY4DHtp6VkMwQLOpzDl1ODywSo9UihmrFYAZlqwUxMCJQCGKVwD5mgLqRPF4
         zVQQ==
X-Gm-Message-State: AOAM530wIkwWF2r7Tm2BV8OTCyrF/nssq/WcTo+0G+3h8mFqCCQ4Se5x
        gWLNWpWSWxot6/DeVEV5NYWGxQ==
X-Google-Smtp-Source: ABdhPJygFgkHfp5lL4CsS4GMWPjddGH6Owu9/1fa7A2NoDH5ihup042p3PzAjCG2K9U9bJGYvkjbsg==
X-Received: by 2002:a7b:ce06:: with SMTP id m6mr619819wmc.85.1631605811109;
        Tue, 14 Sep 2021 00:50:11 -0700 (PDT)
Received: from [10.16.0.69] (host.78.145.23.62.rev.coltfrance.com. [62.23.145.78])
        by smtp.gmail.com with ESMTPSA id r27sm9531178wrr.70.2021.09.14.00.50.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Sep 2021 00:50:10 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH v2] include/uapi/linux/xfrm.h: Fix XFRM_MSG_MAPPING ABI
 breakage
To:     Eugene Syromiatnikov <esyr@redhat.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Antony Antony <antony.antony@secunet.com>,
        Christian Langrock <christian.langrock@secunet.com>
Cc:     selinux@vger.kernel.org, Paul Moore <paul@paul-moore.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Eric Paris <eparis@parisplace.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Dmitry V. Levin" <ldv@strace.io>,
        linux-api@vger.kernel.org
References: <20210912122234.GA22469@asgard.redhat.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <9ce148b0-7694-83f7-0d04-546e2cae9500@6wind.com>
Date:   Tue, 14 Sep 2021 09:50:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210912122234.GA22469@asgard.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 12/09/2021 à 14:22, Eugene Syromiatnikov a écrit :
> Commit 2d151d39073a ("xfrm: Add possibility to set the default to block
> if we have no policy") broke ABI by changing the value of the XFRM_MSG_MAPPING
> enum item, thus also evading the build-time check
> in security/selinux/nlmsgtab.c:selinux_nlmsg_lookup for presence of proper
> security permission checks in nlmsg_xfrm_perms.  Fix it by placing
> XFRM_MSG_SETDEFAULT/XFRM_MSG_GETDEFAULT to the end of the enum, right before
> __XFRM_MSG_MAX, and updating the nlmsg_xfrm_perms accordingly.
> 
> Fixes: 2d151d39073a ("xfrm: Add possibility to set the default to block if we have no policy")
> References: https://lore.kernel.org/netdev/20210901151402.GA2557@altlinux.org/
> Signed-off-by: Eugene Syromiatnikov <esyr@redhat.com>

Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
