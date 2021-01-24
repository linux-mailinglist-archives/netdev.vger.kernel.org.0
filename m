Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A105A301AAE
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 09:43:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbhAXIm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 03:42:57 -0500
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:47883 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726038AbhAXImz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jan 2021 03:42:55 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 7D3A230B;
        Sun, 24 Jan 2021 03:42:09 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 24 Jan 2021 03:42:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=FeSEp6
        J9St6hJzK2tbyw6ZPC6ttp33cCSOnw4pvZpo4=; b=jnOFToZ9kSrRxwv8tTFjF1
        QkDQhkqmpuT7fzXgZ+hrbNcE/vhE5rQApn+s0/mAhaOyK75pMWZCb0zxUJwVeVtg
        5qGOZ5jsw2Zg6ZHiyw4nvNGEV65KpmI9MLZ71lHhtB5Hlz+drxE9jAffzo4mv/yg
        /7JU3rtuJN8Sy5g6/iuFjJ+g05wX8C9SCrTVmegx5vs3K5j8CvFfVnxcznTrUZyf
        n35K9h2Cdc+FoXjLuVkNykkF8vcX8rvuaIegASSdQ6lD9kitSvdl4tGwL1QcjxYU
        LPYDrgGcdSnYGVemTtVboQPFpVzXFAdGRBXm0Vn9hBW8QdAEDknIPfIA8mOAilhg
        ==
X-ME-Sender: <xms:4DINYEospCRfQjPpfeKuCkYNNES-V2J0RrswdJDNVKZ_0-o4Fm8G6A>
    <xme:4DINYKpz32FeBGNQIi9o_KCiT4fNcyIfWMM-CfY5RfFAwT8M5DIfBun09scEjChN2
    A5wWYG1cSC95E0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvddtgddvfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepfffhvffukfhfgggtuggjsehttdertd
    dttddvnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpedtffekkeefudffveegueejffejhfetgf
    euuefgvedtieehudeuueekhfduheelteenucfkphepkeegrddvvdelrdduheefrdeggeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:4DINYJNTJ3J2xH1h-wdUdE_Y8DINRsKBQJfwGwZe3FvO-mJCeLRuoA>
    <xmx:4DINYL4TPLqjMh4fUzDMF0N51IsvokmIRAXXnrrtZrwkuj5KwI_hlQ>
    <xmx:4DINYD7gvHhsQbdT1q2EYT_lNGHovRTbSQLkvoIv6PZR_59loA0CBw>
    <xmx:4TINYG3emBX_sIXyZD44lFV-vQqIDPMZ1QJmqM5VxAPicl2lLNGrqw>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7A36224005A;
        Sun, 24 Jan 2021 03:42:08 -0500 (EST)
Date:   Sun, 24 Jan 2021 10:42:05 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, petrm@nvidia.com,
        jiri@nvidia.com, amcohen@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next 0/5] mlxsw: Add support for RED qevent "mark"
Message-ID: <20210124084205.GA2819717@shredder.lan>
References: <20210117080223.2107288-1-idosch@idosch.org>
 <20210119142255.1caca7fb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210120091437.GA2591869@shredder.lan>
 <20210120164508.6009dbbd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210121102318.GA2637214@shredder.lan>
 <20210121091940.5101388a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210123152802.GA2799851@shredder.lan>
 <20210123115527.58d0f04c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210123115527.58d0f04c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 23, 2021 at 11:55:27AM -0800, Jakub Kicinski wrote:
> On Sat, 23 Jan 2021 17:28:02 +0200 Ido Schimmel wrote:
> > > Thanks for the explanation. I feel more and more convinced now that
> > > we should have TC_ACT_TRAP_MIRROR and the devlink trap should only 
> > > be on/off :S Current model of "if ACT_TRAP consult devlink for trap
> > > configuration" is impossible to model in SW since it doesn't have a
> > > equivalent of devlink traps. Or we need that equivalent..  
> > 
> > Wait, the current model is not "if ACT_TRAP consult devlink for trap
> > configuration". 'ecn_mark' action is always 'trap' ('mirror' in v2) and
> > can't be changed. Such packets can always be sent to the CPU, but the
> > decision of whether to send them or not is based on the presence of tc
> > filters attached to RED's 'mark' qevent with TC_ACT_TRAP
> > (TC_ACT_TRAP_MIRROR in v2).
> 
> I see, missed that, but I think my point conceptually stands, right?
> Part of forwarding behavior was (in v1) only expressed in control 
> plane (devlink) not dataplane (tc).

I don't think so? The action was set to 'trap' in both devlink and tc.

>  
> > I believe that with the proposed changes in v2 it should be perfectly
> > clear that ECN marked packets are forwarded in hardware and a copy is
> > sent to the CPU.
> 
> Yup, sounds good.

Thanks!
