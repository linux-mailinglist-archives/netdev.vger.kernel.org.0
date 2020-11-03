Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7806E2A5A91
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 00:28:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729841AbgKCX2N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 18:28:13 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:33786 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725763AbgKCX2L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 18:28:11 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1ka5ig-0057Nu-FH; Wed, 04 Nov 2020 00:28:06 +0100
Date:   Wed, 4 Nov 2020 00:28:06 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Radhey Shyam Pandey <radheys@xilinx.com>
Cc:     Michal Simek <michals@xilinx.com>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 2/3] drivers: net: xilinx_emaclite: Fix
 -Wpointer-to-int-cast warnings with W=1
Message-ID: <20201103232806.GL1109407@lunn.ch>
References: <20201031174721.1080756-1-andrew@lunn.ch>
 <20201031174721.1080756-3-andrew@lunn.ch>
 <c0553efe-73a1-9e13-21e9-71c15d5099b9@xilinx.com>
 <BYAPR02MB56388293FE47BE39604EB115C7100@BYAPR02MB5638.namprd02.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR02MB56388293FE47BE39604EB115C7100@BYAPR02MB5638.namprd02.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > >  /* BUFFER_ALIGN(adr) calculates the number of bytes to the next
> > > alignment. */ -#define BUFFER_ALIGN(adr) ((ALIGNMENT - ((u32)adr)) %
> > > ALIGNMENT)
> > > +#define BUFFER_ALIGN(adr) ((ALIGNMENT - ((long)adr)) % ALIGNMENT)
> > 
> > I can't see any reason to change unsigned type to signed one.

> Agree. Also, I think we can get rid of this custom BUFFER_ALIGN
> macro and simply calling skb_reserve(skb, NET_IP_ALIGN)
> will make the protocol header to be aligned on at 
> least a 4-byte boundary?

Hi Radhey

I'm just going to replace the long with a uintptr_t. That will fix the
warnings. I don't have this hardware, so don't want to risk anything
more invasive which i cannot test.

Please feel free to add a follow up patch replacing this with 
skb_reserve(skb, NET_IP_ALIGN).

	 Andrew
