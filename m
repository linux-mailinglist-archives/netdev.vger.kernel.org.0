Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE104DCEE9
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 20:37:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbiCQTiq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 15:38:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230511AbiCQTio (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 15:38:44 -0400
Received: from new4-smtp.messagingengine.com (new4-smtp.messagingengine.com [66.111.4.230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0440022C8EB;
        Thu, 17 Mar 2022 12:37:24 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.nyi.internal (Postfix) with ESMTP id 6CE6F580118;
        Thu, 17 Mar 2022 15:37:22 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Thu, 17 Mar 2022 15:37:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=ecemDGKnnBa5cVr1w
        YmFWwjSaNN3bHFjxej6wbuHiHw=; b=cyCH9Rgha4F/UAg7rrVWRHqyL2PVtF0K6
        Pl760BlIXMdb5jYFTuCKuUDmGe/itXLz92Q56VeiYNp/K3qxKnv8mbWy49KS7z1P
        QHMl/pi5YIqIog4ctJ8G/DxzDdBEIqZeDB3ROpV+ZwaJxtlStGAqB5NLCNOtzbg6
        gyXNchQkGwRCimQ4dFpvl52Qm5HUmp8dzvHQn+Bj+yHSazoza9fnp//GfOQdPL/A
        KDb/IkJ10yxnSS07nTOnVRrWVF78WphRV2EHdIIjwAXkADDE1tu1v4GD9y4LOXqs
        rLUgy0+asZ3k8dQBh06BuoleaKu8UxUOKw2c4GlM+rNw0ZR3PMkHA==
X-ME-Sender: <xms:8Y0zYkvNmzVtdD_Mg9D0BOPxhknU00Qhzau0VkrdBUSwNkmH6V0UeQ>
    <xme:8Y0zYhfn4WBX-dXvMB5MvAv6CcJiJZr6Ix5jC0NqDEsSsjXMegBe-xryGP4jwwr88
    00RqA6PAMMoH1k>
X-ME-Received: <xmr:8Y0zYvxmYigNrElxe3yOmVKTK4oV0WjMtJgN0rcoHacC6v_PTIYpB5yjkL3bSTtmd7b9Sfsavy2lEtu3RkuerusNfQs>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrudefgedguddvhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudeh
    leetnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:8Y0zYnOtn1fwVbCAtSOUpL00BiTCAY_gesSZKhaEA4G_Wm18QcItjA>
    <xmx:8Y0zYk_wGaEv3WGlZKLo4RHm7UThwnkAXljtDFccioBukjbkgwe6og>
    <xmx:8Y0zYvXnrHEEBQVQWwU5_0km4Hwqs14YlLg-y0CInq_STi7Pf-qOGg>
    <xmx:8o0zYoITybH0xFaXWb2p_x0DwmHlYkg6WnT86RJuJMRaRsJG4P56Lw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 17 Mar 2022 15:37:20 -0400 (EDT)
Date:   Thu, 17 Mar 2022 21:37:15 +0200
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
Subject: Re: [PATCH net-next v3 1/2] net: flow_offload: add tc police action
 parameters
Message-ID: <YjON61Hum0+B4m6y@shredder>
References: <20220224102908.5255-1-jianbol@nvidia.com>
 <20220224102908.5255-2-jianbol@nvidia.com>
 <20220315191358.taujzi2kwxlp6iuf@skbuf>
 <YjM2IhX4k5XHnya0@shredder>
 <20220317185249.5mff5u2x624pjewv@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220317185249.5mff5u2x624pjewv@skbuf>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 17, 2022 at 08:52:49PM +0200, Vladimir Oltean wrote:
> I'd just like the 'reclassify' action to be propagated in some reasonable
> way to flow offload, considering that at the moment the error is quite cryptic.

OK, will check next week. Might be best to simply propagate extack to
offload_act_setup() and return a meaningful message in
tcf_police_offload_act_setup(). There are a bunch of other actions whose
callback simply returns '-EOPNOTSUPP' that can benefit from it.
