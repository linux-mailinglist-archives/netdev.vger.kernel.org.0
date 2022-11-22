Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3489633D9C
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 14:26:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232881AbiKVN0i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 08:26:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232373AbiKVN0f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 08:26:35 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F39517594;
        Tue, 22 Nov 2022 05:26:33 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id vv4so26481729ejc.2;
        Tue, 22 Nov 2022 05:26:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=H5Nb0LMRwCQV7tWs/EMWvOMza7Rw/W2mk9hxaUL4wRo=;
        b=c5sXKAtWFIEDXqT+WUOKhya4fg/LMtnbnST1odWDNP9OU+kDXeGDiKqBERk+4R47C2
         Z5kPVeo0lGXhAJA+HMUoSD6QLU8bgjARomjX4A0glIojTdFf7dA4oUOYBP+eGAuZkWun
         fcnk6pmIR8Z2uhThe5yfrrzOcaibpQJcE21ovUEIgRPe1tTs1cEHvWTZh+un0nToHxHr
         a45LendJsM84BJjYm6cbKY2jDZVrk/KqD9EZyzEzSKzWzcEVSOvkapMHIjvrO23oye7I
         yGWMuSUxNG2LLIVafLCfZ+AJas/clOBJVZ7BXgW2/1R5EWklzDNgqpkthulsiCeNufMa
         9Cdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H5Nb0LMRwCQV7tWs/EMWvOMza7Rw/W2mk9hxaUL4wRo=;
        b=qPaHvYqWxsqDs6ljh+PRrtZAtxUUDnkFgwmzbpC9YaqF0Sz084mGi/CmasqJ+gqsp+
         ougLTEZMQLsHuhmjBXr3eiGls5ExCf6r5uEE4Dha20eNobEY0Kzb19HcLGnchDfeLKjV
         kH6WHAOLxNGbXhWwqA9LmEuaSf7l38fjCddBCtzVsV86eJ1WgYu4tKVk1X50ihevFmSK
         +3RlM0yNM+7WX7AOA795uMxLwi0SKwQOuA7tJ3JEdmjKae1k44g0Oq/l1SzujU45HlU0
         yrK15mIDqibSsj/Y7yrqasjwP1hYF2c6AvLsQkVeTXM7fQr9V9luM0hyNFSSjpKMXyKa
         yR8Q==
X-Gm-Message-State: ANoB5pmMU/ktcbMaM0di9BExoGGPisn73bLlSYQYr6fkVGiuBDAEr+NG
        A5JOxEiXLAsFueP4BFkDIZE=
X-Google-Smtp-Source: AA0mqf7OFzNf3x/5sCMdCKR0UQLfwSzRCZ8I4dVNJrs4AioHINFN1LegI239oExsJpxl0K7s+hUeOA==
X-Received: by 2002:a17:907:2a08:b0:7ae:76a4:e393 with SMTP id fd8-20020a1709072a0800b007ae76a4e393mr20351488ejc.743.1669123591930;
        Tue, 22 Nov 2022 05:26:31 -0800 (PST)
Received: from skbuf ([188.26.57.184])
        by smtp.gmail.com with ESMTPSA id jp8-20020a170906f74800b007adaca75bd0sm6119204ejb.179.2022.11.22.05.26.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 05:26:30 -0800 (PST)
Date:   Tue, 22 Nov 2022 15:26:28 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Bhadram Varka <vbhadram@nvidia.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Revanth Kumar Uppala <ruppala@nvidia.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v4 RESEND] stmmac: tegra: Add MGBE support
Message-ID: <20221122132628.y2mprca4o6hnvtq4@skbuf>
References: <20220923114922.864552-1-thierry.reding@gmail.com>
 <1b50703c-9de0-3331-0517-2691b7005489@gmail.com>
 <LV2PR12MB5727354F4A1EDE7B08FBC5A5AF229@LV2PR12MB5727.namprd12.prod.outlook.com>
 <20221118130216.hxes7yucdl6hn2kl@skbuf>
 <LV2PR12MB57272349F55FC1E971DA64EEAF0D9@LV2PR12MB5727.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <LV2PR12MB57272349F55FC1E971DA64EEAF0D9@LV2PR12MB5727.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 22, 2022 at 07:05:22AM +0000, Bhadram Varka wrote:
> Reset values of XPCS IP take care of configuring the IP in 10G mode.
> No need for extra register programming is required from the driver
> side. The only status that the driver expects from XPCS IP is RLU to
> be up which will be done by serdes_up in recent posted changes. Please
> let me know if any other queries on recent changes [0]
> 
> Thank You!
> 
> [0]: https://patchwork.ozlabs.org/project/linux-tegra/patch/20221118075744.49442-2-ruppala@nvidia.com/

What about link status reporting, if the XPCS is connected to an SFP cage?

What I'm trying to get at is that maybe it would be useful to consider
the pcs-xpcs.c phylink pcs driver, even if your XPCS IP is memory mapped,
that is not a problem. Using mdiobus_register(), you can create your own
"MDIO" controller with custom bus read() and write() operations which
translate C45 accesses as seen by the xpcs driver into proper MMIO
accesses at the right address.

If I understand the hardware model right, the XPCS MDIO bus could be
exported by a common, top-level SERDES driver. In addition to the XPCS
MDIO bus, it would also model the lanes as generic PHY devices, on which
you could call phy_set_mode_ext(serdes, PHY_MODE_ETHERNET, phy_mode),
and phy_power_on()/phy_power_off().

Can your SERDES lanes also operate in PCIe mode? If yes, how is the
selection between PCIe and Ethernet/XPCS done?
