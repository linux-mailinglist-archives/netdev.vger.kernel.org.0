Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D250C6A21A0
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 19:38:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbjBXSiR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 13:38:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbjBXSiQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 13:38:16 -0500
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5B1E1E9FE
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 10:38:12 -0800 (PST)
Received: by mail-qt1-x831.google.com with SMTP id z6so465370qtv.0
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 10:38:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3bT71763zGk8upLDESIAVtEeaoivOwH9sPQLW+fswyw=;
        b=BG4uS2UNohoNaih9+k6A8c+Z7AQ8Y1lTJhWR+y1qBOdxwh6Bqlrs+Nc6vX4DS15rAb
         CFnWqugFbQ3+ql/jKpDfuNi9hVUs01JtFCTFpL8+2kh4yENI90EBj1u3DuxHgZFOknKi
         MaleJ/NBsflJQFtzpuDIGrywEe9GMnjU6TtANVUijYlhoQVLoyxUi0nWFEM82/fVXkhu
         NCebnMocp3S8p8VllRxzQ2mjMB+EkKH/CVqvb2Evh/S8+6ZjUcmmJZqLRZiB4FGFWDxg
         iwhcCj3B6mCXW+0gzTEVRDl/4YeHofJAaKcZsFUMNMMDJ6l/+fm/qrW0HRsa7IBDE/Mh
         YkhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3bT71763zGk8upLDESIAVtEeaoivOwH9sPQLW+fswyw=;
        b=xrAf8mHQTf3cV7nP/oYcfmWmX92MXI+NPUKS4HcyJnQ1AR0A20w2qQ4rLVGPx0Q4ou
         qvIBfC+tCYroKOR2N434TYSkcQjS20/lWRKIMrKxjQvCC++qRjOIU3Ipd7PV4W7vOSn+
         HKCLl6buAue2GKO2FfhBkzYin0RHaimqRLIi1wnTgBvIQ0HKyVznZirTsiCRW+iqmLBc
         DOL/HVFNBgL0j8qLpkoo5os9J0W5Gv1gcK38tOgmGPg9a/QfEC66/Zs7S4Vx97dM5Q9o
         Oli4XaMqhRV/E1bfMIeoX2GFYNhBAwpIEEA0SXcdXRPtHPcv/HEjkVMeNsvl3GscgXRW
         jltg==
X-Gm-Message-State: AO0yUKURtvZWu/yP7OHZmQDsXgb7lF9vB0et7/uyjbSZEyGCxqTVpaWt
        XtjrgGTBNG7Zax0GX6aFxbE=
X-Google-Smtp-Source: AK7set9SsVFCuPVeJwDCXbojgemoPoEZKRXpWVrNWVdRdBP9wfY33HFjDCbE5g8/Dzusk+d5EhQayA==
X-Received: by 2002:ac8:574a:0:b0:3b9:b70c:9697 with SMTP id 10-20020ac8574a000000b003b9b70c9697mr16244497qtx.5.1677263891543;
        Fri, 24 Feb 2023 10:38:11 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id j9-20020a05620a146900b007423e52f9d2sm4357174qkl.71.2023.02.24.10.38.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Feb 2023 10:38:10 -0800 (PST)
Message-ID: <97bcd183-0df3-5461-e796-f13add3eabb0@gmail.com>
Date:   Fri, 24 Feb 2023 10:38:08 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net 3/3] net: mscc: ocelot: fix duplicate driver name
 error
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Colin Foster <colin.foster@in-advantage.com>,
        Lee Jones <lee@kernel.org>,
        Maksim Kiselev <bigunclemax@gmail.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
References: <20230224155235.512695-1-vladimir.oltean@nxp.com>
 <20230224155235.512695-4-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230224155235.512695-4-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/24/23 07:52, Vladimir Oltean wrote:
> When compiling a kernel which has both CONFIG_NET_DSA_MSCC_OCELOT_EXT
> and CONFIG_MSCC_OCELOT_SWITCH enabled, the following error message will
> be printed:
> 
> [    5.266588] Error: Driver 'ocelot-switch' is already registered, aborting...
> 
> Rename the ocelot_ext.c driver to "ocelot-ext-switch" to avoid the name
> duplication, and update the mfd_cell entry for its resources.
> 
> Fixes: 3d7316ac81ac ("net: dsa: ocelot: add external ocelot switch control")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

