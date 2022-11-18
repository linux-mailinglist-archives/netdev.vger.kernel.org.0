Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3C2162F576
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 14:02:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241579AbiKRNCX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 08:02:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235142AbiKRNCW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 08:02:22 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9819240901;
        Fri, 18 Nov 2022 05:02:21 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id n12so12801629eja.11;
        Fri, 18 Nov 2022 05:02:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0XzTo46uc4vhLZRVTEAEFDaUD0kf6qcsqkjSrRfoIbA=;
        b=TwUVsbnt2xEhjYCMoUsf7S77iuxtaQ1yAaJ5cnUsytNJjRfs9nenmdtUGK2PRxYbIU
         y5ZOTgota4xqzrgRvkZUcEccCNqKgPLg+H3E3gpEUpjFLg6Bc2y/hzAQuapKgnR4q8EJ
         Bmcw9D8J6P5ILzIuIRrQjjO+7YjRENJ/xnD4SNTs3u6AJGcZAcnFFDE8IZW3/PGsSju7
         SE3Njs8q2FEareNEdVA2Wl1x8Jo/Fa4dgSx52c78WwULo54Dp4KhgQYFmB0aKnOqGR8t
         lzZuAYn39eJt9mPrJDP3uQN6LMz/9vrIXIF3nuRs1jJsmOYW/bsjJF0Z5/XXkjPjklgN
         uUVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0XzTo46uc4vhLZRVTEAEFDaUD0kf6qcsqkjSrRfoIbA=;
        b=1yjcKlsPLVvUff8VsjyfcEdrn4MxfF9E03EdiWIFsgPpS6kdmZWgM+QD+CYH5AXZJz
         IuVMpHMs8VKNaWBz1ADla7m5Wewg9NNvP5TIx4+RJpAjx3Poi1t11WR8G++p2Vld6ilO
         F+ux7cNjMR/IRt5pyKNYx0trHq5P8mXlH39Del2ctZH3xARFRWUa3YxwM8Jre29zNev+
         1eAVT94ysZ/v6PEriRHR+45PfQzzHWJW2P2w+o4/iS7YPJtoFDAoPkCqTumpFfek+oSi
         3J9IeWFooAiUjMx9lJreuBMbR2/NJ9f7EI+/iNVYVDu4RIE0HZeASgWCZJZ0KAwaBVDa
         Rqew==
X-Gm-Message-State: ANoB5pnf5bMv2FrUnxohNf09SLchXu2wqkSIxVH/71h6+FUpug/Z/Vj1
        0r2WtqM5fAplAW6zpJxP+BM=
X-Google-Smtp-Source: AA0mqf46l2o1aD0Gl2qBpTraygRLL1r+eFNuy2Ucoq9pie91oPS7S5d3f0mwDMevnI45UhA2MqfOMw==
X-Received: by 2002:a17:906:ce55:b0:7ad:b45c:dd7a with SMTP id se21-20020a170906ce5500b007adb45cdd7amr5994589ejb.292.1668776539756;
        Fri, 18 Nov 2022 05:02:19 -0800 (PST)
Received: from skbuf ([188.27.185.168])
        by smtp.gmail.com with ESMTPSA id o2-20020a170906768200b0077077c62cadsm1672805ejm.31.2022.11.18.05.02.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 05:02:19 -0800 (PST)
Date:   Fri, 18 Nov 2022 15:02:16 +0200
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
Message-ID: <20221118130216.hxes7yucdl6hn2kl@skbuf>
References: <20220923114922.864552-1-thierry.reding@gmail.com>
 <1b50703c-9de0-3331-0517-2691b7005489@gmail.com>
 <LV2PR12MB5727354F4A1EDE7B08FBC5A5AF229@LV2PR12MB5727.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <LV2PR12MB5727354F4A1EDE7B08FBC5A5AF229@LV2PR12MB5727.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Bhadram,

On Wed, Oct 12, 2022 at 04:56:52AM +0000, Bhadram Varka wrote:
> > You should be modeling this as a proper PCS driver and have a 'pcs-handle'
> > property pointing to it in your Device Tree.
> > 
> > The configuration you are doing here is probably working the first time you
> > bring-up the network device but I doubt it works across system
> > suspend/resume states where power to the GMAC and PCS is lost, it also
> > begs the question of which mediums this was tested with and whether
> > dynamic switching of speeds and so on is working?
> > --
> 
> For Tegra234, there is UPHY lanes control logic inside XPCS IP which is memory-mapped IP (not part of the MAC IP).
> mgbe_uphy_lane_bringup performs UPHY lane bring up here. Here MGBE/XPCS works in XFI mode.
> 
> Agree that lane bring down logic is not present interface down/suspend paths. Will update the changes accordingly.
> One more thing is that UPHY lane bring should happen only after the line side link is up. This also will make the changes.
> Please let me know if I miss anything here.

What about the non-UPHY part of the XPCS IP, how does the dwmac-tegra.c
driver control it/see the status it reports?
