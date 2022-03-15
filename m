Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CBF14D962E
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 09:30:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345889AbiCOIbR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 04:31:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245292AbiCOIbQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 04:31:16 -0400
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFA624BFF3
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 01:30:04 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id C94EF320209A;
        Tue, 15 Mar 2022 04:30:03 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 15 Mar 2022 04:30:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=N64dxln0YwyYuxH9d
        HDYvWBrAP7mfNb3xKnV0IWa+x8=; b=cCiRhlMNnkkVKzo9JKjqC27jtKY0a3eX+
        SMCmpBhouKDLZ6+9l8Gd3lf7ynn80z/euNPma7Frs2IfGxzRkzbzN2FlP5LDN221
        LOn5X6GlDqbsbH+7zmDkuVxcTpR2Ex7KN0lrEbIx9QY4r+p4+RQ5wRb4jIKFo723
        O0JfACDkAppz2XD4gfA6XjSr8KijAdqVeljBmnRu5D6QyN7Z8pV1akOX8UrL5/0a
        C3SlOPgzyA+z2Oo2RBiMK2VlfIRBZ1vkbFQlvegHX+yw0VRq9zo/eA6EMGqTcuy/
        QMAa0tTe1QDAD/RtrQWir45IVeF/dqaVFezpII8J6zmXwFKSMDICQ==
X-ME-Sender: <xms:i04wYjlfYg8kTW1O4XQ20fzXqZkpjqrpKKRajW-T1AeVLeCcj_QOdQ>
    <xme:i04wYm3d8WxR5SCB5NI7sGCMiHOpDPOMpro8DmxjNbWDNr-Gw6MF4MFxfm8MBglPA
    AK_VfaI70O4_Ko>
X-ME-Received: <xmr:i04wYpqNx01Yvj5k0SWnJ6ZNTi0mwfcCDSLgVhyYHQJRywcF46D9cOfEPRCd1HMt1wNwu4qO44ipkIc75FWBGkEIQ2k>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddruddvledguddukecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepfffhvffukfhfgggtuggjsehttd
    ortddttddvnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpefgjeevhfdvgeeiudekteduveegue
    ejfefffeefteekkeeuueehjeduledtjeeuudenucevlhhushhtvghrufhiiigvpedtnecu
    rfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:i04wYrkSC8KhHspM8HZDk94cRhxky-kUKVURI0VrCvuatPHRipfl5g>
    <xmx:i04wYh3zWH7vsJ-xyvlXYDgBVXt-Ik6Dz7t_LLDaQ-2sX-7ZOVmqFQ>
    <xmx:i04wYqst7nvEycwka_V619zbWq5Rx3WB1OV4beXqKcGj09X-yYOlTQ>
    <xmx:i04wYroE-t0KvEDHYrijJ4yjgGC95s77VahIfi_NzHReTbLKW3sN1g>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 15 Mar 2022 04:30:02 -0400 (EDT)
Date:   Tue, 15 Mar 2022 10:29:58 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, jiri@nvidia.com,
        idosch@nvidia.com, petrm@nvidia.com, simon.horman@corigine.com,
        louis.peens@corigine.com, leon@kernel.org
Subject: Re: [PATCH net-next 4/6] eth: mlxsw: switch to explicit locking for
 port registration
Message-ID: <YjBOhgaqIyzopkVn@shredder>
References: <20220315060009.1028519-1-kuba@kernel.org>
 <20220315060009.1028519-5-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220315060009.1028519-5-kuba@kernel.org>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 14, 2022 at 11:00:07PM -0700, Jakub Kicinski wrote:
> Explicitly lock the devlink instance and use devl_ API.
> 
> This will be used by the subsequent patch to invoke
> .port_split / .port_unsplit callbacks with devlink
> instance lock held.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Tested-by: Ido Schimmel <idosch@nvidia.com>
