Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4A1A3FE9EF
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 09:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243359AbhIBHXM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 03:23:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233163AbhIBHXL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 03:23:11 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E381C061575
        for <netdev@vger.kernel.org>; Thu,  2 Sep 2021 00:22:13 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id q11so1265652wrr.9
        for <netdev@vger.kernel.org>; Thu, 02 Sep 2021 00:22:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2Sr4JglvdWDBQ2wOTZW6ElZD1OAh7p+s3FJK89qhgiM=;
        b=FS94AIis1HaeP4YWFLvWShRs7pOBIvYRjx0VLv6hM9zDKmreAzv5G5CfG8A6iX29W2
         01ozlnfm6paVlRWetFTsY9E/v+GNNLRVtSwNwt1mJymNKqlW8N7jcS7fMQauEzG2D16y
         +KgcW68JBohppxrdZB/0JOBdxCrW37YMLzm5SjbdSM5R/I3Zo92O9HGMlOA4+ncodUog
         Q884MiVIxhIPuj45jbj554K1MyQkbm4SWLhGU6/7FLQ48yZJbASmWaXZLNCl4VST96iD
         Dcjumy9O6saBzIuzqZIjRA60ReyVtHuT5NtvxMHmzpJ1x39HljOu3SzB7h3BI0Dqto89
         Pf4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=2Sr4JglvdWDBQ2wOTZW6ElZD1OAh7p+s3FJK89qhgiM=;
        b=cidLbCag4CL9Ryimm2joxFAplUHSSKbPa29tORNIEDDv/nGEwUSyY2cp2wBw/WPMUu
         a48qPapTRtW8mDU/FyFHzF4sR1ryU6tesAE8rZBonklCOQqx4xUbDqwgkWTuKNL9WPFk
         ffHDzM2dUU9uhjj2NCwaK/HhKeZanNnViA/CF9iqVOvq2lynLdh/qCMLjB9DrQkybS7o
         NI84UWXlJJRrLIFwtKauSyEu6FHJySswzz92nxtpGRlVjIIJZl4RD7aUwXVcakQf7Uew
         HndMyFgYGiJwhruVp6KdI19s6lsRdRN44Amg7OoBJfC/a4s0ALE4xmuurY2CRe6oMNEe
         hEcg==
X-Gm-Message-State: AOAM530QDR2hHYu4eWkIEJKidx7t9uPsckA80koKhSxAdmjtPWtpfKUs
        Fw9R5opyBotTN+SWyLy2RcA6U8nRYc7b3w==
X-Google-Smtp-Source: ABdhPJx1rtSdVuiiyy5iVOmwPt+Um0lx4nMkwJpGQD/JuUD1FLEgHSpCgTfxVv0hcA4cMAUz7kzYFA==
X-Received: by 2002:adf:fb44:: with SMTP id c4mr1892372wrs.179.1630567332137;
        Thu, 02 Sep 2021 00:22:12 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:410:bb00:ad0b:57f0:790e:61f9? ([2a01:e0a:410:bb00:ad0b:57f0:790e:61f9])
        by smtp.gmail.com with ESMTPSA id y11sm1166719wru.0.2021.09.02.00.22.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Sep 2021 00:22:11 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH] include/uapi/linux/xfrm.h: Fix XFRM_MSG_MAPPING ABI
 breakage
To:     Eugene Syromiatnikov <esyr@redhat.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Antony Antony <antony.antony@secunet.com>,
        Christian Langrock <christian.langrock@secunet.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Dmitry V. Levin" <ldv@strace.io>, linux-api@vger.kernel.org
References: <20210901153407.GA20446@asgard.redhat.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <ef57d76e-358b-4868-aa31-ac45f67bc813@6wind.com>
Date:   Thu, 2 Sep 2021 09:22:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210901153407.GA20446@asgard.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 01/09/2021 à 17:34, Eugene Syromiatnikov a écrit :
> Commit 2d151d39073a ("xfrm: Add possibility to set the default to block
> if we have no policy") broke ABI by changing the value of the XFRM_MSG_MAPPING
> enum item.  Fix it by placing XFRM_MSG_SETDEFAULT/XFRM_MSG_GETDEFAULT
> to the end of the enum, right before __XFRM_MSG_MAX.
> 
> Fixes: 2d151d39073a ("xfrm: Add possibility to set the default to block if we have no policy")
> Signed-off-by: Eugene Syromiatnikov <esyr@redhat.com>

Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
