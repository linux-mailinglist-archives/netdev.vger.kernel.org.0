Return-Path: <netdev+bounces-10094-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CA12972C2FC
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 13:38:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 75953280F4B
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 11:38:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B0D8182CD;
	Mon, 12 Jun 2023 11:37:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C433AD3C
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 11:37:58 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B865270B;
	Mon, 12 Jun 2023 04:37:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
	Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=/iA4btMNQ666w27H/vVH0XMK2MgQdtFUAmoPFQeEmrU=; b=bWv8hDkCPDAviJkaD7hd+Ydzsz
	05NKeqrYgHwdqiVB90GntptD9u3C6+RSzTX2cSmxFetcr5wpb9VjLBNn3O4YZEQg94kPEoSQ39D8o
	0Y4pbcyAU9U/J+tKMU1b8KqpUUOhUVs5jGOiMivzji54KkvCKz+QottfRav3l2r8ZNt9aJtIlkXqN
	HwZ8rGDMpqSLHJHWQbEuHK3mIr4xUv9+Mo2ySn0/EO8acPtTBB7d++eSaAxtYI45x/JhlpiFymWwJ
	2y7O+tL9+gn0HXQFUSIau3yIFWaCVBXEak5FA4/g7ZVJ64DETAsRYe7khufGsnL6m0+5muAVlQk6G
	/p59vGcQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:46252)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q8frX-0005gW-L3; Mon, 12 Jun 2023 12:37:31 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q8frV-0004vi-FN; Mon, 12 Jun 2023 12:37:29 +0100
Date: Mon, 12 Jun 2023 12:37:29 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: arinc9.unal@gmail.com
Cc: =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
	Daniel Golle <daniel@makrotopia.org>,
	Landen Chao <Landen.Chao@mediatek.com>,
	DENG Qingfang <dqfext@gmail.com>,
	Sean Wang <sean.wang@mediatek.com>, Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Frank Wunderlich <frank-w@public-files.de>,
	Bartel Eerdekens <bartel.eerdekens@constell8.be>,
	mithat.guner@xeront.com, erkin.bozoglu@xeront.com,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: Re: [PATCH net v4 0/7] net: dsa: mt7530: fix multiple CPU ports,
 BPDU and LLDP handling
Message-ID: <ZIcDee2+Lz7nJ3j6@shell.armlinux.org.uk>
References: <20230612075945.16330-1-arinc.unal@arinc9.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230612075945.16330-1-arinc.unal@arinc9.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi,

Please slow down your rate of patch submission - I haven't had a chance
to review the other patches yet (and I suspect no one else has.) Always
allow a bit of time for discussion.

Just because you receive one comment doesn't mean you need to rush to
get a new series out. Give it at least a few days because there may be
further discussion of the points raised.

Sending new versions quickly after previous comments significantly
increases reviewer workload.

Thanks.

On Mon, Jun 12, 2023 at 10:59:38AM +0300, arinc9.unal@gmail.com wrote:
> Hi.
> 
> This patch series fixes hopefully all issues regarding multiple CPU ports
> and the handling of LLDP frames and BPDUs.
> 
> I am adding me as a maintainer, I've got some code improvements on the way.
> I will keep an eye on this driver and the patches submitted for it in the
> future.
> 
> Arınç
> 
> v4: Make the patch logs and my comments in the code easier to understand.
> v3: Fix the from header on the patches. Write a cover letter.
> v2: Add patches to fix the handling of LLDP frames and BPDUs.
> 
> Arınç ÜNAL (7):
>   net: dsa: mt7530: fix trapping frames with multiple CPU ports on MT7531
>   net: dsa: mt7530: fix trapping frames with multiple CPU ports on MT7530
>   net: dsa: mt7530: fix trapping frames on non-MT7621 SoC MT7530 switch
>   net: dsa: mt7530: fix handling of BPDUs on MT7530 switch
>   net: dsa: mt7530: fix handling of LLDP frames
>   net: dsa: introduce preferred_default_local_cpu_port and use on MT7530
>   MAINTAINERS: add me as maintainer of MEDIATEK SWITCH DRIVER
> 
>  MAINTAINERS              |  5 +--
>  drivers/net/dsa/mt7530.c | 75 ++++++++++++++++++++++++++++++++++++-------
>  drivers/net/dsa/mt7530.h | 26 +++++++++------
>  include/net/dsa.h        |  8 +++++
>  net/dsa/dsa.c            | 24 +++++++++++++-
>  5 files changed, 115 insertions(+), 23 deletions(-)
> 
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

