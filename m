Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B93E4BA21B
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 14:58:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241495AbiBQN6M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 08:58:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235260AbiBQN6L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 08:58:11 -0500
Received: from new4-smtp.messagingengine.com (new4-smtp.messagingengine.com [66.111.4.230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E1B82790B5;
        Thu, 17 Feb 2022 05:57:54 -0800 (PST)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 865C0580304;
        Thu, 17 Feb 2022 08:57:52 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 17 Feb 2022 08:57:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=ewexVFaFRMWe+RzWS
        r4kmNRQq7+UUt8s/r9ORkquS7A=; b=mWy9vRgL4CcQbAfN2PiozK+s6kRnRIFzn
        kMqlzD7/kp5oSpykKPxXRmYuqMPS2YZ+IpmJ+42jkocZVRSZJAn79QQkXJmBsUf6
        MkUbrscUZsjdS9z+Z6udOnpNiMhe67ta3lgL1XpymBFF+m1SBOsGb3IyK7gUuq9/
        QIBdNj4S9SFmXBiO3ZMaxi1iXWkpYFmxKJzeS/8RIYHfMD7gVCul/3021HsTndl4
        TlA5MAx78oczzKgjqd9MNzxPhgf5hGGkrOcwc1v9tNOvY8fX+8UHYVAQep6+tdrp
        97LqPyhjRwFWjTbm8cCbz4LQax0+2JTW8Lx9KYbiPlaIlmW+OcHOw==
X-ME-Sender: <xms:X1QOYoavoSBxV5dVcuG5EZ5hGGFYv4qeX7udtY46OWOaMhYzGNZRnw>
    <xme:X1QOYjY8CHRVMYJ1Jygte7TS7wNCc8JTbtvWNm_m47QC-gV2O6TUX6-pwm-gyxxJb
    MbB6MgDEoFkVYk>
X-ME-Received: <xmr:X1QOYi9_whrNVeDXBk9prknD2zWXfeNzohfc-9k7nPUiuRM4tQwBI5FHUsYdjGlcb7TTfAlBlf9OwdUvO0skfYIznRs>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrjeekgdehjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:X1QOYirNS2mcn3VDft-AZY6gdcGd5tdovr5tFUk-mgzYzfBFiG2RFQ>
    <xmx:X1QOYjrblbq3EYP-uMQT4Tsvh4Urd0FiJrSnrC8TE97cxFoitvgCBA>
    <xmx:X1QOYgQQI_u03vVe8Y1h-ZyNJRPUh_QL9hIT_cvkLuaarZ7HElJO-A>
    <xmx:YFQOYmWJfM1psDmUjPC2ibQd_Lqs7T6TnmnqrVVR6OdNDns_NGfFKA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 17 Feb 2022 08:57:50 -0500 (EST)
Date:   Thu, 17 Feb 2022 15:57:47 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jianbo Liu <jianbol@nvidia.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, rajur@chelsio.com,
        claudiu.manoil@nxp.com, sgoutham@marvell.com, gakula@marvell.com,
        sbhatta@marvell.com, hkelam@marvell.com, saeedm@nvidia.com,
        leon@kernel.org, idosch@nvidia.com, petrm@nvidia.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        simon.horman@corigine.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        baowen.zheng@corigine.com, louis.peens@netronome.com,
        peng.zhang@corigine.com, oss-drivers@corigine.com, roid@nvidia.com
Subject: Re: [PATCH net-next v2 2/2] flow_offload: reject offload for all
 drivers with invalid police parameters
Message-ID: <Yg5UW4WzL2NX4st5@shredder>
References: <20220217082803.3881-1-jianbol@nvidia.com>
 <20220217082803.3881-3-jianbol@nvidia.com>
 <20220217124935.p7pbgv2cfmhpshxv@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220217124935.p7pbgv2cfmhpshxv@skbuf>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 17, 2022 at 02:49:35PM +0200, Vladimir Oltean wrote:
> Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Thanks for testing

> 
> But could we cut down on line length a little? Example for sja1105
> (messages were also shortened):

No problem

[...]

> Also, if you create a "validate" function for every driver, you'll
> remove code duplication for those drivers that support both matchall and
> flower policers.

Will do
