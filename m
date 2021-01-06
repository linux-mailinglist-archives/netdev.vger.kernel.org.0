Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D15C92EC1C9
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 18:09:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727485AbhAFRJN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 12:09:13 -0500
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:54221 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727226AbhAFRJM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 12:09:12 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailnew.nyi.internal (Postfix) with ESMTP id 4850D58048F;
        Wed,  6 Jan 2021 12:08:26 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Wed, 06 Jan 2021 12:08:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=6QXKLf
        NS1szqKmB7r4aA3lByGUvyaS0zLILl/X004oc=; b=B56hUbRgC/Xb+LKKjC5XDA
        vJJ12Y7V2lYGAbdr3+jLp7/xWPwTbO4onjGqhjTDtAoi9VWsQ+3WHmmMAAeKkfag
        kFW2UEZZJuAYWBIS0yrP+1+x8zeUZFvJjldMGskYzcABqf+y/5ChK8DBPJL7bCKJ
        tMKQ3p7Mq20fhMVuOYCrzF7VakQmWC1hEna6KPqwndOvSB9zXPaoY3gC64H0Iqgw
        FHDCsPI6C1EglcqkxK2dSsebxqypiSQ5NcfWgL6Jz1j/dAJaWEHW0gXScgM/+SxE
        ME74nYJmI3aPLVlX/Z6bMdiX21su5neS8cpfutMIPtH7j3SDkWLh2mExCT1xFV3g
        ==
X-ME-Sender: <xms:he71X3c5wxiGfSlzoNi-Mo9KPvmULqhMJRSGGYdyiZN5WH9RZDouwg>
    <xme:he71X12lwhOHD5nmmwx9bcx0WgmGc4dUn6jv6GN9XwGxKinG6uVx3TKyv22epaNIt
    bOZ5ghd_A-26ZY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdegtddgtdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucfkphepkeegrddvvdelrdduheefrdeggeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:he71X3_JElm-jtxBPTg4oOinTB3e8ZBSyh-rWhOZDM1IqIRHrVJ_Kw>
    <xmx:he71Xy4A54Cpo07hrmbbKrdIu7OUENvkYgpzGb2CIuKaMy1mxmW1uA>
    <xmx:he71X3vSHTiTy5VCTj9dpEip2AzGlTK0jqzMte44XToUI2rnI-Uo1Q>
    <xmx:iu71X4K5Ifv1c_HBqjLpi3oNaFmj7ors6enIDZZekzXhtZ4gJOd5Yw>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3F7311080057;
        Wed,  6 Jan 2021 12:08:21 -0500 (EST)
Date:   Wed, 6 Jan 2021 19:08:18 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>
Subject: Re: [PATCH v2 net-next 01/10] net: switchdev: remove vid_begin ->
 vid_end range from VLAN objects
Message-ID: <20210106170818.GA1080217@shredder.lan>
References: <20210106131006.577312-1-olteanv@gmail.com>
 <20210106131006.577312-2-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210106131006.577312-2-olteanv@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 06, 2021 at 03:09:57PM +0200, Vladimir Oltean wrote:
> Let's go off and finish the job of commit 29ab586c3d83 by deleting the
> bogus iteration through the VLAN ranges from the drivers. Some aspects
> of this feature never made too much sense in the first place. For
> example, what is a range of VLANs all having the BRIDGE_VLAN_INFO_PVID
> flag supposed to mean, when a port can obviously have a single pvid? The
> switchdev drivers have so far interpreted this to mean that the last
> VLAN in the range should be the only one which should get programmed
> with that attribute.

See commit 6623c60dc28e ("bridge: vlan: enforce no pvid flag in vlan
ranges")

> Of the existing switchdev pieces of hardware, it appears that only
> Mellanox Spectrum supports offloading more than one VLAN at a time.
> I have kept that code internal to the driver, because there is some more
> bookkeeping that makes use of it, but I deleted it from the switchdev
> API. But since the switchdev support for ranges has already been de
> facto deleted by a Mellanox employee and nobody noticed for 4 years, I'm
> going to assume it's not a biggie.

Which code are you referring to?

> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

For the switchdev and mlxsw parts:

Reviewed-by: Ido Schimmel <idosch@nvidia.com>

I applied the series to our queue, so I should have regression results
tomorrow
