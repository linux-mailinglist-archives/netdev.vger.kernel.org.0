Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B02C644D77F
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 14:46:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233463AbhKKNta (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 08:49:30 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:55973 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233470AbhKKNt3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 08:49:29 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id CDC5C5C017C;
        Thu, 11 Nov 2021 08:46:39 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 11 Nov 2021 08:46:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=5vuzox
        mKOfh0NrkFH48TsfHBHI719fEFG1RzbxWzBUM=; b=c7P9mFxDSz7Dd7/fI/Tp9I
        EbnCXdQ5XxxvLduycgG35IX5Vo6kLSuWwCu83IPnA7ziIrmonQgKIxYt1RyjAy1u
        dH94ums4VaDVw0yvsBwPgTISX78yNwm3pfkw/q5rNgflyyNDlAsQ36JEkQeeVzlQ
        G3yGqHjqQ0iWznMQeXq+YZKQqu89YT+etj2uUpxtyJf96PdS0/AWXZYH9RUw/Gkx
        mJ6Vw2htIj+T65Atefl9fn/fs2xkkp5MwFroXkZHBbI00+OozGQAsCaqEX/uR//C
        X6HY4JMZKbTukwKuD2/jTO6sy747afgl03KYXcEVX0e6878gb7n0h3c559VFUC4g
        ==
X-ME-Sender: <xms:vx6NYYQJqmcsgSSo2OJjvxC8God-YBS4IwixKeaBvnCi9zgQ7yAiNA>
    <xme:vx6NYVzBmG1aRDKC4beUE0o-M9ecaYHXd_A_fmwRcuubzxWeR4xoN8wj6FNIXSDXA
    1JleABks3htt4s>
X-ME-Received: <xmr:vx6NYV1U8-cvfWQmgu7qiDOdvDUdhISA9Zf5OzafPM17HkQZA8yECPeJx9dmpXWOAUleYbIK8L8-VRu2l6Ds9qibNLzVIA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrvddugdehiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:vx6NYcDlBRG3k31hi6wDxeDNVfRpytRc8vB4dSGjXT_iuk81sFllCQ>
    <xmx:vx6NYRgXMRWr9rn3BGQ9I_xwcP5zOCyOEE_QFi2tj4okn3fNDZhJ8A>
    <xmx:vx6NYYoBrbsjx-SMdY8rQdHeVjw27zNUdxZpq5jNd-xLqUdC3-leUQ>
    <xmx:vx6NYfZqZEicLmzmrKFM0MtBI4HiI_w9CVhZvpFEsvoIzsbg2VD89w>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 11 Nov 2021 08:46:38 -0500 (EST)
Date:   Thu, 11 Nov 2021 15:46:35 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: Is it ok for switch TCAMs to depend on the bridge state?
Message-ID: <YY0eu2CatR9DDTQY@shredder>
References: <20211102110352.ac4kqrwqvk37wjg7@skbuf>
 <YYe9jLd5AAurVoLW@shredder>
 <20211111115254.6w64bcvx5iyhnz7e@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211111115254.6w64bcvx5iyhnz7e@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 11, 2021 at 11:52:55AM +0000, Vladimir Oltean wrote:
> On Sun, Nov 07, 2021 at 01:50:36PM +0200, Ido Schimmel wrote:
> > On Tue, Nov 02, 2021 at 11:03:53AM +0000, Vladimir Oltean wrote:
> > > I've been reviewing a patch set which offloads to hardware some
> > > tc-flower filters with some TSN-specific actions (ingress policing).
> > > The keys of those offloaded tc-flower filters are not arbitrary, they
> > > are the destination MAC address and VLAN ID of the frames, which is
> > > relevant because these TSN policers are actually coupled with the
> > > bridging service in hardware. So the premise of that patch set was that
> > > the user would first need to add static FDB entries to the bridge with
> > > the same key as the tc-flower key, before the tc-flower filters would be
> > > accepted for offloading.
> > 
> > [...]
> > 
> > > I don't have a clear picture in my mind about what is wrong. An airplane
> > > viewer might argue that the TCAM should be completely separate from the
> > > bridging service, but I'm not completely sure that this can be achieved
> > > in the aforementioned case with VLAN rewriting on ingress and on egress,
> > > it would seem more natural for these features to operate on the
> > > classified VLAN (which again, depends on VLAN awareness being turned on).
> > > Alternatively, one might argue that the deletion of a bridge interface
> > > should be vetoed, and so should the removal of a port from a bridge.
> > > But that is quite complicated, and doesn't answer questions such as
> > > "what should you do when you reboot".
> > > Alternatively, one might say that letting the user remove TCAM
> > > dependencies from the bridging service is fine, but the driver should
> > > have a way to also unoffload the tc-flower keys as long as the
> > > requirements are not satisfied. I think this is also difficult to
> > > implement.
> > 
> > Regarding the question in the subject ("Is it ok for switch TCAMs to
> > depend on the bridge state?"), I believe the answer is yes because there
> > is no way to avoid it and effectively it is already happening.
> > 
> > To add to your examples and Jakub's, this is also how "ERSPAN" works in
> > mlxsw. User space installs some flower filter with a mirror action
> > towards a gretap netdev, but the HW does not do the forwarding towards
> > the destination.
> 
> I don't understand this part. By "forwarding" you mean "mirroring" here,

Yes

> and the "destination" is the gretap interface which is offloaded?

No. See more below

> 
> > Instead, it relies on the SW to tell it which headers
> > (i.e., Eth, IP, GRE) to put on the mirrored packet and tell it from
> > which port the packet should egress. When we have a bridge in the
> > forwarding path, it means that the offload state of the filter is
> > affected by FDB updates.
> 
> Here you're saying that the gretap interface whose local IP address is
> the IP address of a bridge interface that is offloaded by mlxsw, and the
> precise egress port is determined by the bridge's FDB? But since you
> don't support bridging with foreign interfaces, why would the mirred
> rule ever become unoffloaded?
> 
> I'm afraid that I don't understand this case very well.

In software, when you mirror to a gretap via act_mirred, the packet is
cloned and transmitted through the gretap netdev. This netdev will then
put a GRE header on the packet, specifying that the next protocol is
Ethernet. It will then put an IP header on the packet with the
configured source and destination IPs and route the packet towards its
destination.

It is possible that routing will determine that the encapsulated packet
should be transmitted via a bridge. In which case, the packet will also
do an FDB lookup in the bridge before determining the egress port.

In hardware, we don't have a representation for the gretap device.
Instead, the hardware is kept very simple and requires the driver to
tell it:

a. Via which port to mirror the packet
b. Which headers to encapsulate the packet with

So the "offload-ability" of the filter is conditioned on software being
able to determine the correct path, which can change with time following
FDB/routes/etc updates.
