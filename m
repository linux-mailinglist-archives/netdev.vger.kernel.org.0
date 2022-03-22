Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B77E4E3C3E
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 11:13:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232805AbiCVKPH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 06:15:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231845AbiCVKPG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 06:15:06 -0400
Received: from new4-smtp.messagingengine.com (new4-smtp.messagingengine.com [66.111.4.230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 908F8240A8;
        Tue, 22 Mar 2022 03:13:39 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 790E058024B;
        Tue, 22 Mar 2022 06:13:36 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 22 Mar 2022 06:13:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=EWmG3jSf1BnvVGbFL
        8jiO1r4X5cFxx3tAO4xA/Ho7MY=; b=KPSyiagqsFsBkQYpqzhD2qFm8ggdQyyJN
        3FTgXIXsOjqqRRxTNNAMRgJFe7I8aY1WusTW6rRgbaMIHRZsmefHFDaqm+daXj1T
        FKnq8teRsj4SLCst0cz2JF0iu2ic9scxQItw+YwuSkyxiXHgeJrlWpdh0goBjcFE
        uzhQ+XKv5/+pUWGAx9okR0WgM/khX4akyqj997ZnWqaJS4iBiCUnKg1wbqpVUk/q
        wImvhSM6IkoBzDMXhXV4McYYlcI9ukLVkNuP+Wava5sd2YgSPy6SxztwuPnwz+JL
        A9HHlzhTkJRjwtMJKh7seVnozZhqbuYA+upcWq4pm6wwSUlD550RQ==
X-ME-Sender: <xms:T6E5YkzhYOV_CPgFx2NHLaSCfOcEtYd2E-0mEC3Y3xz27V5dY3_Pgw>
    <xme:T6E5YoRRsJbLWmSRiV93Oiklf1HwPkJpqAmFNJoDm1GYgeaYqJSXMwAZ_bR06T-Ay
    zUG8lhRuIycf8w>
X-ME-Received: <xmr:T6E5YmWlXycqEed0oO8KCkG94xaCeXhWxRZQfMHaBhaOgOK3glg3cvOw9je2u2U-dtvwVtpF6yL2dZcq3Gq5qzmb_Sk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrudeghedgudduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpeehhfdthfduueehgfekkefhhedutddvveefteehteekleevgfegteevueelheek
    ueenucffohhmrghinhepghhithhhuhgsrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:T6E5YiiWUQakm6lu4H5YeFYXF-P1hkEzdZ78gFSjNCWw_oVEqc0Gbw>
    <xmx:T6E5YmCjyFZja3mZue3lcF5tTpFHDqhvKGvm8_CdfHVJoQVLci9WGg>
    <xmx:T6E5YjJsnJMzVyP2nCu2HAZIZbM7I5ldlFjhhAVzsl9Xsl0_SA2FRg>
    <xmx:UKE5YvufkQCMBCvx_m7PKJEMf-zrPYfiMiSxm6VVpXnIiQyHIxmOxg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 22 Mar 2022 06:13:34 -0400 (EDT)
Date:   Tue, 22 Mar 2022 12:13:31 +0200
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
Message-ID: <YjmhS7mEw7DraXfE@shredder>
References: <20220224102908.5255-1-jianbol@nvidia.com>
 <20220224102908.5255-2-jianbol@nvidia.com>
 <20220315191358.taujzi2kwxlp6iuf@skbuf>
 <YjM2IhX4k5XHnya0@shredder>
 <20220317185249.5mff5u2x624pjewv@skbuf>
 <YjON61Hum0+B4m6y@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YjON61Hum0+B4m6y@shredder>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 17, 2022 at 09:37:22PM +0200, Ido Schimmel wrote:
> On Thu, Mar 17, 2022 at 08:52:49PM +0200, Vladimir Oltean wrote:
> > I'd just like the 'reclassify' action to be propagated in some reasonable
> > way to flow offload, considering that at the moment the error is quite cryptic.
> 
> OK, will check next week. Might be best to simply propagate extack to
> offload_act_setup() and return a meaningful message in
> tcf_police_offload_act_setup(). There are a bunch of other actions whose
> callback simply returns '-EOPNOTSUPP' that can benefit from it.

# tc filter add dev dummy0 ingress protocol ip flower skip_sw ip_proto icmp action police rate 100Mbit burst 10000
Error: act_police: Offload not supported when conform/exceed action is "reclassify".
We have an error talking to the kernel

Available here:
https://github.com/idosch/linux/commits/tc_extack

I plan to submit the patches after net-next reopens.
