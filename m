Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 522F94B6DD9
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 14:42:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236994AbiBONmv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 08:42:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234225AbiBONmv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 08:42:51 -0500
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3443B1A8E
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 05:42:41 -0800 (PST)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id DE1735C02FF;
        Tue, 15 Feb 2022 08:42:40 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 15 Feb 2022 08:42:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=bmWs7vtYOdjuvvwPg
        cD4aK6GMKdAvyGQEW7yX9afD9o=; b=YaUAy0qmrRlAlVwxIfaMFCMJbOzuRyekE
        9i5CLlSU371jzIUMvM1Vlu2AdwGGBaUGzM/jLdnJ8a9k2wyfaRxnHp1txJwdBqnh
        ztv4lbGgc7vV+WqcAprik4l4TO1mlK8SgnZvA6iKSa8ZEQJQMYOzP9ugf/dp4TSB
        sKvbyy8AKcUwuANrarSjtvGeUziNv8SsHgch6Pb6C8KJ+irSMxBCSnEuRfIh7PLg
        3BaWOpiLol1tehmajD/98VFw9Oe1efcMN1430dzGbeXJRmgF6X+OIMPk8vz4U79z
        5zcf3gZnMBpJjZIMlQsNeuNSUvCJ1W/A9nwi3veP+us/UqL/q+j1w==
X-ME-Sender: <xms:0K0LYjWgzPv_Ybsj9NeB-dWYiYp3yHuG5vR4jNBnxTmDf8A-_TN82A>
    <xme:0K0LYrnw4fx5BXywncc_u56j7we7w93HHjDJPUVAwAVynGyYi5ICq4ISFAv1frYjs
    qNAoYydCnUhBIE>
X-ME-Received: <xmr:0K0LYvYMZvr_TdTloAPIno8_q3PKFp79vFqAt9y87vfimfEKqu49XtbeNqlKNWIeDN3su5oK4xKr7EzPVhSunuDyM8Y>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrjeeggdehfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtrodttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepkedvffdvueelgfekkeehgefftdegkeekhfefleegiedtudevgeeuheejudekiedu
    necuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:0K0LYuX0w9gEjaxaxg45ysh2skmROeioaQ5G-huJYPg5yt9U4EEstA>
    <xmx:0K0LYtnH1O5OUIH21Al_pIsHrlGbm5_2I_xnFJ5FfaRroKgSbPBzMg>
    <xmx:0K0LYrepGMcjnXV6-Meo85M7MV7kDoIgwyTpTZgjx-NhIUPTkcg_zA>
    <xmx:0K0LYgthK1hC6a2XkeefXPMXb2-HaxrWhR88aI9__7kRdFd4DFAn1g>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 15 Feb 2022 08:42:39 -0500 (EST)
Date:   Tue, 15 Feb 2022 15:42:36 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        netdev@vger.kernel.org, Roopa Prabhu <roopa@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH] net: bridge: multicast: notify switchdev driver whenever
 MC processing gets disabled
Message-ID: <YgutzPtNjTIbovHM@shredder>
References: <20220211131426.5433-1-oleksandr.mazur@plvision.eu>
 <20220214211309.261bd9d6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <9429cc71-1b0f-7fe3-c9dc-12246a397e96@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9429cc71-1b0f-7fe3-c9dc-12246a397e96@nvidia.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 15, 2022 at 10:31:41AM +0200, Nikolay Aleksandrov wrote:
> (+CC Ido)
> On 15/02/2022 07:13, Jakub Kicinski wrote:
> > On Fri, 11 Feb 2022 15:14:26 +0200 Oleksandr Mazur wrote:
> >> Whenever bridge driver hits the max capacity of MDBs, it disables
> >> the MC processing (by setting corresponding bridge option), but never
> >> notifies switchdev about such change (the notifiers are called only upon
> >> explicit setting of this option, through the registered netlink interface).
> >>
> >> This could lead to situation when Software MDB processing gets disabled,
> >> but this event never gets offloaded to the underlying Hardware.
> >>
> >> Fix this by adding a notify message in such case.
> > 
> > Any comments on this one?
> > 
> > We have drivers offloading mdb so presumably this should have a Fixes
> > tag and go to net, right?
> 
> The change looks ok, but it'd be nice to get switchdev folks comment as well.
> About the tree, -net should be targeted. I think the issue has existed
> since mdb disabled could be offloaded, so the tag should be:
> 
> Fixes: 147c1e9b902c ("switchdev: bridge: Offload multicast disabled")

LGTM

Oleksandr, please mark future patches as net/net-next:
https://docs.kernel.org/networking/netdev-FAQ.html#how-do-i-indicate-which-tree-net-vs-net-next-my-patch-should-be-in
