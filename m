Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E0716C85A2
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 20:10:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231411AbjCXTKj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 15:10:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbjCXTKi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 15:10:38 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15B0A90
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 12:10:38 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id l9-20020a17090a3f0900b0023d32684e7fso6141747pjc.1
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 12:10:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679685037;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oDWVSQhmN+CQdxlSyfs8CJTkztQqHKuzsx5cw3YQBvI=;
        b=c43RrcuJ396PQNf3Hj/+GvQedDVXUsVtpf09iw50+YOYFz+E4s1G2RTFxPhmUig6DJ
         hxKu+ZjVsRmWIXVeoNe+YgsANCIdW5uBn8LuLSvxfG670Hm5x29R3AGaS12Bh06zidAY
         0l6B1eTVItl3FIWia8sVSaQeEbKWbYfYqJal7xtc9wAiumewCnbClbRWcAt+1JtJFEeA
         L1i1R2p7VLh7lAJj5SnajNknZTHs6ass8QPXCY/0WXH5ik/QVSOduguSrbw4qZVd8bT1
         eNALdGDXamPD+wIocdZKoFcAwifyoYvYcFbzpGWqeMyB5iHD48jN4Z/KtC3nVAyTlccI
         kEyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679685037;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oDWVSQhmN+CQdxlSyfs8CJTkztQqHKuzsx5cw3YQBvI=;
        b=t/1iseWfOM1bG4rwm+WHng09KUikpyEk+axrxd/pjsiQ3625YZkHQZE19Wl9v17yLS
         i9yi/PRWk0jX95WCGSPbNXMGsxWVg7T1/y5GJDgB+NWsdIofXkiJ485vgUf/cZ549tzV
         W4j1/8BKRuHGPQHj5y7lKiNqMLeRU0SGkphCEKRWbAAh64IezziVCChEgLr5/qKjZ2rO
         vPZlRv/vxPz6Lue4fyunFqjIKKEULrW/hNKxyYuDZwjvwT0crf8qLG0WNO8Zb01KdTEk
         G9bCjeUVuOHcOwWvuZjLnPMqe9DuirS8jX5XfcqxzISdlVg5ri1bsWSey+DzCaF7QpNp
         1gxw==
X-Gm-Message-State: AAQBX9cnIVGT5Orbx/A2lx4q0aEPVP/V6PSsJjPZ9kr9vdDKwR+CKL8D
        inXylSg2QVj9zBIe4dOiLhY=
X-Google-Smtp-Source: AKy350bxQL7qMViA9udmyQtKSsFpJaEY+jYsMIu9u4mT8WmTpTewGv2CTN7KyIRfrf4ecF88Ca7jkw==
X-Received: by 2002:a17:90b:4c8b:b0:240:c25:210 with SMTP id my11-20020a17090b4c8b00b002400c250210mr3913689pjb.44.1679685037509;
        Fri, 24 Mar 2023 12:10:37 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id z3-20020a17090ad78300b0020b21019086sm8065647pju.3.2023.03.24.12.10.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Mar 2023 12:10:37 -0700 (PDT)
Message-ID: <e39a20a2-c01e-343a-15e8-e917e9451dbe@gmail.com>
Date:   Fri, 24 Mar 2023 12:10:29 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next 1/4] net: phylib: add getting reference clock
Content-Language: en-US
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <0c529488-0fd8-19e1-c5a9-9cf1fab78ed3@gmail.com>
 <97e1f180-ae4e-7314-a736-748bb6746d82@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <97e1f180-ae4e-7314-a736-748bb6746d82@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/24/23 11:03, Heiner Kallweit wrote:
> Few PHY drivers (smsc, bcm7xxx, micrel) get and enable the (R)MII
> reference clock in their probe() callback. Move this common
> functionality to phylib, this allows to remove it from the drivers
> in a follow-up.
> 
> Note that we now enable the reference clock before deasserting the
> PHY reset signal. Maybe this even allows us to get rid of
> phy_reset_after_clk_enable().
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>   drivers/net/phy/phy_device.c | 6 ++++++
>   include/linux/phy.h          | 5 +++++
>   2 files changed, 11 insertions(+)
> 
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index c0760cbf5..6668487e2 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -3096,6 +3096,12 @@ static int phy_probe(struct device *dev)
>   	if (phydrv->flags & PHY_IS_INTERNAL)
>   		phydev->is_internal = true;
>   
> +	phydev->refclk = devm_clk_get_optional_enabled(dev, NULL);
> +	if (IS_ERR(phydev->refclk)) {
> +		err = PTR_ERR(phydev->refclk);
> +		goto out;
> +	}

My comment in patch 2 should have been there, I would add a flag that 
the PHY driver can set that tells the core that it is OK to fetch the 
clock. In the case of bcm7xxx.c is it not the reference clock, so while 
we can use phydev->refclk for the same purpose, it could be a tad confusing.
-- 
Florian

