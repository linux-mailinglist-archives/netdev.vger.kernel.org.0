Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95BD1328295
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 16:35:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237271AbhCAPe5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 10:34:57 -0500
Received: from wnew1-smtp.messagingengine.com ([64.147.123.26]:33891 "EHLO
        wnew1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237259AbhCAPek (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 10:34:40 -0500
X-Greylist: delayed 632 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Mar 2021 10:34:39 EST
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.west.internal (Postfix) with ESMTP id A6D53750;
        Mon,  1 Mar 2021 10:22:54 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 01 Mar 2021 10:22:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=IauOCt
        8zqU4njIU9F18ywK4S1TDq0EnUPF5VohKD7Ns=; b=Q8BF4wTc2fkqcRhoqTzj3K
        C94pycJkOzebMYsAyraSWKyL9O8NSuI5vmO8WLJUFgat2K7d2SZ5b2FlmF4rR5WK
        WozhY+9KwcKy2B6nkx6G4GT9ILMfQ4aa7OaqDWXyS8m2NYAw8zVUQ2XgVgdCmQzT
        tlDCTmorzCuwm/iRJ//cmpI9/NTL9JXrd5eSG2yLRNhAAn4NUfRxe16xtHB8N0za
        j5AwTpuvLZm6M4MY/wPDWU4hbBtEtrgr+Pb2fK48MMl6FS8S2vcrU+MmF4iiqh1R
        oyWiYQBJArgBd5qYMqTOmKFP/y6IVU5HnExcj4Gbv4/B6mVKiwYF9WmmReD37aKQ
        ==
X-ME-Sender: <xms:zQY9YOpTLwcNHdkxztVnImLfqcDb3Ll3WKcu0jaH-_ABprLVPlDNTA>
    <xme:zQY9YMoSOSQWQxAq5XApal114AJhSbs_W6Qx8FGjEm4pz4X3NB5DPVZcjPRumKJQa
    Xp6kYj2CZv0d8c>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgdejgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necukfhppeekgedrvddvledrudehfedrgeegnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:zQY9YDPUxigybH7eehskHDor213x6Fo2sgRF7iZoYTA4uWK-0dkl2w>
    <xmx:zQY9YN6XNR2sg2qWp1q-00RuIgJQrbeDGrUIiQiB70rX-T06185IBw>
    <xmx:zQY9YN7hLlfRvMNY9Rzpq8BmjW3lLjv2U6vX4aErNPb_9V2LxnY3NQ>
    <xmx:zgY9YHsv72bXZebL4WxFZaUzFFG7qY-hh-0mn8istV9ONGRvw9w13N5cebE>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id BC6311080066;
        Mon,  1 Mar 2021 10:22:52 -0500 (EST)
Date:   Mon, 1 Mar 2021 17:22:48 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        George McCollister <george.mccollister@gmail.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: Re: [RFC PATCH v2 net-next 05/17] net: bridge: implement unicast
 filtering for the bridge device
Message-ID: <YD0GyJfbhqpPjhVd@shredder.lan>
References: <20210224114350.2791260-1-olteanv@gmail.com>
 <20210224114350.2791260-6-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210224114350.2791260-6-olteanv@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 24, 2021 at 01:43:38PM +0200, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The bridge device currently goes into promiscuous mode when it has an
> upper with a different MAC address than itself. But it could do better:
> it could sync the MAC addresses of its uppers to the software FDB, as
> local entries pointing to the bridge itself. This is compatible with
> switchdev, since drivers are now instructed to trap these MAC addresses
> to the CPU.
> 
> Note that the dev_uc_add API does not propagate VLAN ID, so this only
> works for VLAN-unaware bridges.

IOW, it breaks VLAN-aware bridges...

I understand that you do not want to track bridge uppers, but once you
look beyond L2 you will need to do it anyway.

Currently, you only care about getting packets with specific DMACs to
the CPU. With L3 offload you will need to send these packets to your
router block instead and track other attributes of these uppers such as
their MTU so that the hardware will know to generate MTU exceptions. In
addition, the hardware needs to know the MAC addresses of these uppers
so that it will rewrite the SMAC of forwarded packets.
