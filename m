Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E36623F3146
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 18:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233479AbhHTQMM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 12:12:12 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:43365 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232191AbhHTQME (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 12:12:04 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 681EC580B2C;
        Fri, 20 Aug 2021 12:11:26 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Fri, 20 Aug 2021 12:11:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=2E5gdo
        EF6QrlL7F8ylK1rXT/69p82PiHW1YUnttvd3k=; b=gmWevCmJo2ZRGtrtBI6RxE
        +P3Hm/qtw6DoT/nsulN1Bh2YKvZvDHIXP9zB8Yav6SqKGTLZ3GVk81BmbUwEQaC4
        tfXqp/cxDoQkxGkdxqijelRWuwcbiG4Fu+1GCe58snvKVATgLcj3yI1EvCPA8j7W
        MfEtmP6+8xGT8w/IkMHnB+ZBjCQD/g6LN2VACbOdw4KRDx0clr8LRi2QGwwfK2yy
        yYmKXxrISy0FGA7wVRopVL1TvoWh1ioFzDEX64HEI3YKxsNQ8UBexHMIvEFsjBH8
        8DSvcr/80JS37ogjeayp1WKWFQqgIY4UXE1nvD7/7YechMDo2lwqht9Mh5quIO0w
        ==
X-ME-Sender: <xms:KdQfYcUppXbxbSBYIL1JKdXtaOCKozYtFtk4_7P0G932Sn-VdgLUfw>
    <xme:KdQfYQnja4cWTw1MDuhlDWnfJpReVzdpdYxMC6iyp4MPiJXB3C_Nj1-ULK3qDhtlB
    aLDP6F3_CDsNVY>
X-ME-Received: <xmr:KdQfYQYZlqjHJms1_RsFT02WECRtSr031L-0SjtLnr1auGaYJPMoKyPaN3fhbDY6GjxuyOWDOG149JYUxYY1F44xO-wlZQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrleelgdeliecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:KdQfYbV3zyyalPos5paYhnlzkq4vbxErD7vY7T8cPUU8SIzYLN9P3w>
    <xmx:KdQfYWlaAgc0QL_n_O0rgsGuwRE_jkkkiRBen59kzcQCMtZc5Ai-lg>
    <xmx:KdQfYQdx7QCsswj3JBQM8wb15HvtDN9YGpa1EB8c7z-GLCpRYLSGJg>
    <xmx:LtQfYdWYvQutw5wPN7Zja-H7KctWt10Rw3HKMmmTo2CV0RXDobrn4Q>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 20 Aug 2021 12:11:20 -0400 (EDT)
Date:   Fri, 20 Aug 2021 19:11:15 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        UNGLinuxDriver@microchip.com,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: Re: [PATCH v2 net-next 0/5] Make SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE
 blocking
Message-ID: <YR/UI/SrR9R/8TAt@shredder>
References: <20210819160723.2186424-1-vladimir.oltean@nxp.com>
 <YR9y2nwQWtGTumIS@shredder>
 <20210820104948.vcnomur33fhvcmas@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210820104948.vcnomur33fhvcmas@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 20, 2021 at 01:49:48PM +0300, Vladimir Oltean wrote:
> On Fri, Aug 20, 2021 at 12:16:10PM +0300, Ido Schimmel wrote:
> > On Thu, Aug 19, 2021 at 07:07:18PM +0300, Vladimir Oltean wrote:
> > > Problem statement:
> > >
> > > Any time a driver needs to create a private association between a bridge
> > > upper interface and use that association within its
> > > SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE handler, we have an issue with FDB
> > > entries deleted by the bridge when the port leaves. The issue is that
> > > all switchdev drivers schedule a work item to have sleepable context,
> > > and that work item can be actually scheduled after the port has left the
> > > bridge, which means the association might have already been broken by
> > > the time the scheduled FDB work item attempts to use it.
> >
> > This is handled in mlxsw by telling the device to flush the FDB entries
> > pointing to the {port, FID} when the VLAN is deleted (synchronously).
> 
> If you have FDB entries pointing to bridge ports that are foreign
> interfaces and you offload them, do you catch the VLAN deletion on the
> foreign port and flush your entries towards it at that time?

Yes, that's how VXLAN offload works. VLAN addition is used to determine
the mapping between VNI and VLAN.
