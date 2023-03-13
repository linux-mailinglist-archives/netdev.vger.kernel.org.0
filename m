Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB5686B7742
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 13:13:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbjCMMNH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 08:13:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbjCMMNC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 08:13:02 -0400
Received: from wnew4-smtp.messagingengine.com (wnew4-smtp.messagingengine.com [64.147.123.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B33F63C01;
        Mon, 13 Mar 2023 05:12:57 -0700 (PDT)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailnew.west.internal (Postfix) with ESMTP id 23BFD2B065EF;
        Mon, 13 Mar 2023 08:12:51 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 13 Mar 2023 08:12:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:content-type:date:date:feedback-id:feedback-id
        :from:from:in-reply-to:in-reply-to:message-id:mime-version
        :references:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
        1678709570; x=1678716770; bh=9ui9bmvE5i4u3m/ARdGTj1kwQVPleXj0Y6d
        rKORRRdE=; b=WUMIR8yT/f22HAwm5Aovj8/OD54RFZFtg8maPs6wmZCp79zQwk2
        KXXos4GzGqFt9BvscL4OqD1szAu52+4XSWc70eThQIbOjMYwZktDXpc6sewkt1Kt
        IQuP4iYISi11UCu5EGR4vK5yWqNX2bodRIrhiIzD8dN8e71kC3/T2BSIfwW08q6w
        sOm3bg2DJDrZhG+CaHwhggasxpIKKspowN8iOVbGD4wmr4U7d7yXFVs0egsFMhvn
        UsjuDboWzqQ2sXYU5zIgUDAHiJdHRUHwGuGMtE45ml6QdWmA9inGrWaPjlIGdGG0
        U0zNusFrFDr6WwzqNo4fbbk7d4LWnEmsQdw==
X-ME-Sender: <xms:QBMPZAGuXJ6KHpEM2zLBqBMUhtupMv-AYvRIxQsCT9c2WXj_KrL9yw>
    <xme:QBMPZJUYrUCR9v9niZxHAtNQXDXMuRJOeUTfDrNQL5AMpWp5_gRyUgARVG6AJt5MB
    8V-REv7A00LtEU>
X-ME-Received: <xmr:QBMPZKKtheRiAdEM52XhXs5g2XlATNLs-UmEZDpDXOxzcEYr2b_RExlVS0qy>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvddvgedgfeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggugfgjsehtkeertddttddunecuhfhrohhmpefkugho
    ucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrg
    htthgvrhhnpeegheekuddvueejvddtvdfgtddvgfevudektddtteevuddvkeetveeftdev
    ueejveenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:QBMPZCHmJTlQSPmNn5mFwF98VfTp58Lr3edQLA0SKWtFi27UqxeHjg>
    <xmx:QBMPZGVmlGLnYUi0bAWfEBuENurj0LmBoTEnwljNdphwsJYoJ_5spg>
    <xmx:QBMPZFPzMMmiZLpPDr-Ymi2cASyz9VcV8XLgDOWfjhFRevVEG5aPmw>
    <xmx:QhMPZBQ3z4tvEYR1IPnmOsVCvIChQHU9DB0qKJv1fRScLdvuwmt2Jm_iXJ0>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 13 Mar 2023 08:12:47 -0400 (EDT)
Date:   Mon, 13 Mar 2023 14:12:44 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Daniel Lezcano <daniel.lezcano@linaro.org>
Cc:     rafael@kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, rui.zhang@intel.com,
        Raju Rangoju <rajur@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Peter Kaestle <peter@piie.net>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Amit Kucheria <amitk@kernel.org>,
        Nicolas Saenz Julienne <nsaenz@kernel.org>,
        Broadcom Kernel Team <bcm-kernel-feedback-list@broadcom.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Support Opensource <support.opensource@diasemi.com>,
        Lukasz Luba <lukasz.luba@arm.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Thara Gopinath <thara.gopinath@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund@ragnatech.se>,
        Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Eduardo Valentin <edubezval@gmail.com>,
        Keerthy <j-keerthy@ti.com>,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Antoine Tenart <atenart@kernel.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Dmitry Osipenko <digetx@gmail.com>, netdev@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-omap@vger.kernel.org,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        danieller@nvidia.com, vadimp@nvidia.com, petrm@nvidia.com
Subject: Re: [PATCH v8 01/29] thermal/core: Add a generic
 thermal_zone_get_trip() function
Message-ID: <ZA8TPDpEVanOpjEp@shredder>
References: <20221003092602.1323944-1-daniel.lezcano@linaro.org>
 <20221003092602.1323944-2-daniel.lezcano@linaro.org>
 <ZA3CFNhU4AbtsP4G@shredder>
 <f78e6b70-a963-c0ca-a4b2-0d4c6aeef1fb@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f78e6b70-a963-c0ca-a4b2-0d4c6aeef1fb@linaro.org>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 13, 2023 at 11:45:41AM +0100, Daniel Lezcano wrote:
> Thanks for reporting this, I think the fix you are proposing is correct
> regarding the previous behavior.
> 
> However, I disagree with the commit 81ad4276b505, because it defines the
> zero as an invalid trip point. But some platforms have warming devices, when
> the temperature is too cold, eg 0°C, we enable the warming device in order
> to stay in the functioning temperature range.
> 
> Other devices can do the same with negative temperature values.
> 
> This feature is not yet upstream and the rework of the trip point should
> allow proper handling of cold trip points.
> 
> If you can send the change to fix the regression that would be great.

Thanks for the reply. Will send you the fix later this week. I want to
test it across all of our systems.

> 
> But keep in mind, the driver is assuming an internal thermal framework
> behavior. The trips_disabled is only to overcome a trip point description
> bug and you should not rely on it as well as not changing the trip points on
> the fly after they are registered.
> 
> Actually, the mlxsw driver should just build a valid array of trip points
> without 0°C trip point and pass it to
> thermal_zone_device_register_with_trips(). That would be a proper change
> without relying on a side effect of the thermal trip bug 0°C workaround.

Understood. Will check with Vadim what we can do in order not to rely on
this behavior.
