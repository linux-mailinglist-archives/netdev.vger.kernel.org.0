Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F02E128AA00
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 21:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbgJKTyX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 15:54:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726456AbgJKTyX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 15:54:23 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A87B6C0613D2
        for <netdev@vger.kernel.org>; Sun, 11 Oct 2020 12:54:21 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id a200so11454318pfa.10
        for <netdev@vger.kernel.org>; Sun, 11 Oct 2020 12:54:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ce5PmEqmv1YSWMDHRt7GbAyKG6KhkYzK8oKJ+L0ajJU=;
        b=NecgSIK6HUp8mfsj4UInLUpOx0FhmYVbOiqvrr2fvZ5TYkrQUuEXkLPTzx5tcFBsEz
         Nq5+JltEQ91NdKRQV2G4Iq1a+xepvbeY+DfJKI4gN+xMLpM7ffxRD/Vy8ael2SRXmk1R
         zyFNBrWANYpGkvC0C9FQlDI7o+XgrW96Kn/50uUMwFceO/cPDsQ5nMCNredRM1yohFiF
         WCfcxk5DLRJtocYCPu/Q2rJDAWygrt7fEniMPlOpK2C7WdbS9Qof9pGftoU6zVWTgefu
         A0B22SdP73LR4NQuzphqUkQ+dMI1GkQXsNYI0Dl/JKScaU4MYP2jBBnNoIji5e1DpelC
         TCTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ce5PmEqmv1YSWMDHRt7GbAyKG6KhkYzK8oKJ+L0ajJU=;
        b=lMLb414KHqAAgSA3utveBm8yxZ8GqfC28JluvOZmtDDkgFm+v+g8+k7ltoTkRgbhte
         RipvRgFYMWzvPs6PjfpPOGPKmvrdQXhKDwg5rkKw1qzmXQyLzWICrexA9wWVnCYKUTrk
         CHWaIfXuoVkzVjrJUrg+Al7BeW+SbT77zKzoZ4H9GOs62p3yOGN0+GMlvFc7uRf3k/in
         jUIhlAmCJfmyz0T/ueZ4JTsD22xS3C7fdhGfp9S1FvqO7aOwT6MGA+R77WTJx+FxZTBp
         8KxWtNvjQbm2JMcrhpg61QlJo7S2yxGTFQp6vQljkdesYRTuvygbWWDqjX7wqYWCrr8b
         2VWA==
X-Gm-Message-State: AOAM530gVqiCG3M2lI/7ulRP78K5ymH44CRmH87IQ01S0NrG7HQexlvv
        obJ8+KCfpmT8O8Qzu9Mn0Wlwag==
X-Google-Smtp-Source: ABdhPJyvpHbR55UUKFuI4uBzl5Pqj28b0PIKd/Oy+gbrycGDnCsZJfFifJORg9kf7WymGLQ6QTDtfQ==
X-Received: by 2002:aa7:8216:0:b029:142:2501:3968 with SMTP id k22-20020aa782160000b029014225013968mr20639458pfi.45.1602446061008;
        Sun, 11 Oct 2020 12:54:21 -0700 (PDT)
Received: from hermes.local (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id a185sm17241288pgc.46.2020.10.11.12.54.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Oct 2020 12:54:20 -0700 (PDT)
Date:   Sun, 11 Oct 2020 12:54:12 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?B?QmrDuHJu?= Mork <bjorn@mork.no>,
        Oliver Neukum <oneukum@suse.com>,
        Igor Mitsyanko <imitsyanko@quantenna.com>,
        Sergey Matyukevich <geomatsi@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Pravin B Shelar <pshelar@ovn.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-rdma@vger.kernel.org,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH net-next 01/12] net: core: add function
 dev_fetch_sw_netstats for fetching pcpu_sw_netstats
Message-ID: <20201011125412.3719926a@hermes.local>
In-Reply-To: <5bb71143-0dac-c413-7e97-50eed8a57862@gmail.com>
References: <a46f539e-a54d-7e92-0372-cd96bb280729@gmail.com>
        <5bb71143-0dac-c413-7e97-50eed8a57862@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 11 Oct 2020 21:36:43 +0200
Heiner Kallweit <hkallweit1@gmail.com> wrote:

> +void dev_fetch_sw_netstats(struct rtnl_link_stats64 *s,
> +			   struct pcpu_sw_netstats __percpu *netstats)

netstats is unmodified, should it be const?

> +{
> +	int cpu;
> +
> +	if (IS_ERR_OR_NULL(netstats))
> +		return;

Any code calling this with a null pointer is broken/buggy, please don't
ignore that.
