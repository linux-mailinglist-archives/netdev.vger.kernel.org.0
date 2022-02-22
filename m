Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62EEC4BFE97
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 17:31:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233038AbiBVQb7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 11:31:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232197AbiBVQbv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 11:31:51 -0500
Received: from new2-smtp.messagingengine.com (new2-smtp.messagingengine.com [66.111.4.224])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84657167F91;
        Tue, 22 Feb 2022 08:31:25 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 50AB35802CB;
        Tue, 22 Feb 2022 11:31:22 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Tue, 22 Feb 2022 11:31:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=4ss1OyObCw6S1k0Bd
        D49Bd/baqeCBEC7bJc1jbF4kQ8=; b=Zr/jral3v63ownQ139f6+E1aDV9q8GCHc
        KcTQMkkm41zRVwqqeRw+mE0twRJb8xNBgaoDzK4OW7As70ult9xz7UFXuMDlqGTN
        Vin2dmDadlbFkZtCZcMg7Qepi5DEEWurHkkfkgtR5WYoMS2ccaj6VTUjUyjxTR+J
        Dco1PWhrY+HXa+WRv6BHHjj5ly3XiQH5KOEDii3t6MfowBddgHK2Zr+hJuq3q9tp
        WnLprQCI2WxP5fcFvqyN/aq+YsCIhlGOp87G9/UVpt7NPAM2qQ8bqGv3L/0eFeXE
        RbqiQ50evYv7FFDIJddcPlUwjhkDWNalKUFtkBsq2EAXVwz/WGQog==
X-ME-Sender: <xms:2A8VYlizXRrpm-lof6juTHVPTX1wdlyGcFJyJO-e04ClbWBT2p0iww>
    <xme:2A8VYqCIHFYedOOfl_LLu6kgSn_yve2Yv8nV4WsMVQZBM-sbFcoteoLXVm_dnu03r
    SuIfjaUenoA-Ow>
X-ME-Received: <xmr:2A8VYlFExvdFaBqqXvIBd-LpuqQF-6srEFT3vuEshY_PPg82dWeH1Rp-aPqXuVPm6CFRPErT7Gv3oV16eZ4as_h6awI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrkeekgdekkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:2A8VYqRIWx5dxUGGtzepG7eWrUSMcjCBLDsqggKFU8COb1rXcMYuyg>
    <xmx:2A8VYiwKlVsG-o6frmym9pzzrfLIfO5B5JP2SxOpinJMGQbwg_r3Fg>
    <xmx:2A8VYg55D-9rXrFLrexJEzc2_fsRt3GfRhQ8HXMmKDnGobmrAvanFg>
    <xmx:2g8VYsqmbIT4gyC0pp00XkrHZtXN9KfiWMtZSAajG9LDBUInFMKZWQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 22 Feb 2022 11:31:19 -0500 (EST)
Date:   Tue, 22 Feb 2022 18:31:14 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Baowen Zheng <baowen.zheng@corigine.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jianbo Liu <jianbol@nvidia.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        Petr Machata <petrm@nvidia.com>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        oss-drivers <oss-drivers@corigine.com>,
        "hkelam@marvell.com" <hkelam@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "leon@kernel.org" <leon@kernel.org>,
        Nole Zhang <peng.zhang@corigine.com>,
        "louis.peens@netronome.com" <louis.peens@netronome.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "rajur@chelsio.com" <rajur@chelsio.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>,
        "sbhatta@marvell.com" <sbhatta@marvell.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        Roi Dayan <roid@nvidia.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        Saeed Mahameed <saeedm@nvidia.com>,
        "sgoutham@marvell.com" <sgoutham@marvell.com>,
        "gakula@marvell.com" <gakula@marvell.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2 2/2] flow_offload: reject offload for all
 drivers with invalid police parameters
Message-ID: <YhUP0lVaq+M/mwdY@shredder>
References: <20220217082803.3881-1-jianbol@nvidia.com>
 <20220217082803.3881-3-jianbol@nvidia.com>
 <20220217124935.p7pbgv2cfmhpshxv@skbuf>
 <6291dabcca7dd2d95b4961f660ec8b0226b8fbce.camel@nvidia.com>
 <20220222100929.gj2my4maclyrwz35@skbuf>
 <DM5PR1301MB21724BB2B0FF7C7A57BD1631E73B9@DM5PR1301MB2172.namprd13.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM5PR1301MB21724BB2B0FF7C7A57BD1631E73B9@DM5PR1301MB2172.namprd13.prod.outlook.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 22, 2022 at 10:29:57AM +0000, Baowen Zheng wrote:
> Since almost all the drivers that support to offload police action make the similar validation, if it make sense to add the validation in the file of flow_offload.h or flow_offload.c?
> Then the other drivers do not need to make the similar validation.
> WDYT?

But not all the drivers need the same validation. For example, nfp is
one of the few drivers that supports policing based on packet rate. The
octeontx2 driver has different restrictions based on whether the policer
is attached to matchall or flower.

We can put the restrictions that are common between all the drivers
somewhere, but it's not that much and it will also change over time,
resulting in needless churn where checks are moved to individual
drivers.
