Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8A2D4BCDF1
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 11:21:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243543AbiBTJTf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 04:19:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241708AbiBTJTe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 04:19:34 -0500
Received: from new2-smtp.messagingengine.com (new2-smtp.messagingengine.com [66.111.4.224])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 916373465A;
        Sun, 20 Feb 2022 01:19:14 -0800 (PST)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.nyi.internal (Postfix) with ESMTP id EC1475805C1;
        Sun, 20 Feb 2022 04:19:13 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Sun, 20 Feb 2022 04:19:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Yvnr3v2tgrcuFJVW9
        1DwvZDH1eh06TJONAa+U9Dt9oM=; b=jYUR6Uwyn9IQKJVxk8c8PSCCe5ycjH2gF
        4BDpzfBCYkD0yJLcPaUPP1nq7ovA1nhkCehFsPz9EhUrqsDf5EqMTlW1VfxmR7H9
        OHG/6bG1RZdgxiKDz9o++kPAEySVeKDu+W9ZWVsQqiaLhG6utgiL8OuRrnFUX4H3
        MA7fRHcK2GMSRxQ2Kqkire8ff2/r3Ra14zK4NR7pfejyQmQv5L1g3p7Jwdrz5tCU
        wRc8zd3to8GQ1NRWEIyYVT2+8HNSYxnDG6SL8lFOt5bVTpr/Mxn3N0y+Rf3OXSym
        k8Pyg12rEK6wwMq32kNIMiRNkHuTQ2nEz1FqD2Nmqj85X9ZMzmkFg==
X-ME-Sender: <xms:kQcSYjJa9hNeobv9nVnAe7Bb-n0NCifhPBFHHJhHgEqdUAGQLopIZg>
    <xme:kQcSYnJv-570fkySvdnY8U4csCnYzEskCgE3Lh6ezFaTwn9uKJ-16G8G7T6Vc3dfh
    2CqVVx8V9eyafA>
X-ME-Received: <xmr:kQcSYrs3pyeqTwxEK-7uqDTdSRLmIHxpXZ3Kg_3Ldtf5Ldb7lz8ySfsVDc9EUWv5zDp58mGBKNzLD-fV5n4sLF_inJ0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrkeeggddtvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtrodttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepgfejvefhvdegiedukeetudevgeeujeefffeffeetkeekueeuheejudeltdejuedu
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:kQcSYsYojO1XbCMBPWUtNoOPFHktHZpQH3KDtU8rWYVb86CTSFMN1A>
    <xmx:kQcSYqYEG5inCOD_vbIw9wPGdipYWjuemIeiOsA8sdPgZocpb57TlQ>
    <xmx:kQcSYgC7nMfkRAk3lay31XG856K-TprBcQW2MgNfBVxm_pItuvFcVA>
    <xmx:kQcSYiNX7OoFwhouAusYJ2yfeL0rHCkO8D5PAIAvij6yduuzCpoBPQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 20 Feb 2022 04:19:12 -0500 (EST)
Date:   Sun, 20 Feb 2022 11:19:10 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Hans Schultz <schultz.hans@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Hans Schultz <schultz.hans+netdev@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Shuah Khan <shuah@kernel.org>,
        Stephen Suryaputra <ssuryaextr@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Amit Cohen <amcohen@nvidia.com>,
        Po-Hsu Lin <po-hsu.lin@canonical.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH net-next v3 2/5] net: bridge: Add support for offloading
 of locked port flag
Message-ID: <YhIHjprGjuRLsSRE@shredder>
References: <20220218155148.2329797-1-schultz.hans+netdev@gmail.com>
 <20220218155148.2329797-3-schultz.hans+netdev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220218155148.2329797-3-schultz.hans+netdev@gmail.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 18, 2022 at 04:51:45PM +0100, Hans Schultz wrote:
> Various switchcores support setting ports in locked mode, so that
> clients behind locked ports cannot send traffic through the port
> unless a fdb entry is added with the clients MAC address.
> 
> Signed-off-by: Hans Schultz <schultz.hans+netdev@gmail.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
