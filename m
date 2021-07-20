Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68E203CFC68
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 16:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239237AbhGTN4N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 09:56:13 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:47961 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239381AbhGTNol (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 09:44:41 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 17D085817C0;
        Tue, 20 Jul 2021 10:25:14 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 20 Jul 2021 10:25:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=oKT1WX
        Jb/HN94UGHcLFzU5g6VlqwSc1m1B9YQun33OY=; b=GQgHzO7TrAUYpGsJLVp0o0
        CwKqVARMvtwiYdLx/oHzRSuyVo0WBe9zpDc1mKSRBHRT+G+z3HBa+t5jeLwOsQMJ
        YjJ5hiiBy2TOKgmDqEUeVabaYOY5lyG4E7i73Us41m8/I3m/M1WTkC8hAd3udrUg
        gHhCKIWPcwcJZsPuZtn4nspNqhIbmvbhQrXX+V33QkvTg77zHrPg8csEGp40LrFX
        YOXLWIwllIJ9LCSO6u+zQUNWEfxaTh5CMBV1JQBmpTG+gpQj6KrvzYkz2QPnK0PW
        p5Vu4M1G9+W9Ixm63q7VwDCgL+HZHnq1va/kIpCrP29aueVJqJgSrpdIBefuiXzQ
        ==
X-ME-Sender: <xms:x9z2YPdS219NtScv6Fu-R1q-_UqJxNpRwcuORoRXewlJbGbq-gToeg>
    <xme:x9z2YFNZltK7SPaWEaUJaih6jR406Kn8SpEL9H83Ql8DIOeOJGDogYQyYyTJN8hIp
    6n-6xXLAPyPXvM>
X-ME-Received: <xmr:x9z2YIjyKAgDzCgp2nja4ObYh9Vy1xS6JTifhqvHFpwNl09f6V9xH1PyrSajck_dJmo7MVRYMdHKEzNJfR0XngSCMQwKWw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrfedvgdejgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtrodttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepgfejvefhvdegiedukeetudevgeeujeefffeffeetkeekueeuheejudeltdejuedu
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:x9z2YA_gmA1DMWTO6HiWKFyTy3UCIhBfUB3UR9kzV0K5A5dcx2uNLg>
    <xmx:x9z2YLukfO8USii_u6H4ySoTdQWsUo1mqMkPzmUebSy5aIWdzvhpSw>
    <xmx:x9z2YPHBXHuASDPZKpC0O3R1Y7i3dkvME1k4bdkbbmsYMujzs7xFgQ>
    <xmx:ytz2YEMvVonEKcl9dS70ERWIERKiB0jfaUbXBvYXG6vCSAoinbqTTg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 20 Jul 2021 10:25:11 -0400 (EDT)
Date:   Tue, 20 Jul 2021 17:25:08 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>
Subject: Re: [PATCH v5 net-next 00/10] Let switchdev drivers offload and
 unoffload bridge ports at their own convenience
Message-ID: <YPbcxPKjbDxChnlK@shredder>
References: <20210720134655.892334-1-vladimir.oltean@nxp.com>
 <YPbXTKj4teQZ1QRi@shredder>
 <20210720141200.xgk3mlipp2mzerjl@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210720141200.xgk3mlipp2mzerjl@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 20, 2021 at 02:12:01PM +0000, Vladimir Oltean wrote:
> On Tue, Jul 20, 2021 at 05:01:48PM +0300, Ido Schimmel wrote:
> > > The patches were split from a larger series for easier review:
> > 
> > This is not what I meant. I specifically suggested to get the TX
> > forwarding offload first and then extending the API with an argument to
> > opt-in for the replay / cleanup:
> 
> Yeah, ok, I did not get that and I had already reposted by the time you
> clarified, sorry.
> 
> Anyway, is it so bad that we cannot look at the patches in the order
> that they are in right now (even if this means that maybe a few more
> days would pass)? To me it makes a bit more sense anyway to first
> consolidate the code that is already in the tree right now, before
> adding new logic. And I don't really want to rebase the patches again to
> change the ordering and risk a build breakage without a good reason.

If you don't want to change the order, then at least make the
replay/cleanup optional and set it to 'false' for mlxsw. This should
mean that the only change in mlxsw should be adding calls to
switchdev_bridge_port_offload() / switchdev_bridge_port_unoffload() in
mlxsw_sp_bridge_port_create() / mlxsw_sp_bridge_port_destroy(),
respectively.
