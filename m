Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E93D9F1CBA
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 18:46:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729400AbfKFRqK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 12:46:10 -0500
Received: from rcdn-iport-3.cisco.com ([173.37.86.74]:40575 "EHLO
        rcdn-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728539AbfKFRqJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 12:46:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=1489; q=dns/txt; s=iport;
  t=1573062369; x=1574271969;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=9LWdUWFwz+0nguJkEnlwOwG8B5lAe20QbOKg7mn/Puw=;
  b=HsxudzhpllSSNe7+0sDmvsEGE/LLaIuYC7p9+Qbx5hKn6vomfRwiBz6R
   FWQubN9poyG8iyY8Ptxw1HuPiE4TsQw07notF+O4m+a9tgrAxW3p0NwNk
   AwPvYPBJRcEds8teFdOybqQcGJsNlCKTDEBc8CIYt8iY80f0qimMAMlPv
   4=;
X-IronPort-AV: E=Sophos;i="5.68,275,1569283200"; 
   d="scan'208";a="646600509"
Received: from alln-core-10.cisco.com ([173.36.13.132])
  by rcdn-iport-3.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 06 Nov 2019 17:46:08 +0000
Received: from zorba ([10.154.200.26])
        by alln-core-10.cisco.com (8.15.2/8.15.2) with ESMTPS id xA6Hk55r004590
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Wed, 6 Nov 2019 17:46:07 GMT
Date:   Wed, 6 Nov 2019 09:46:02 -0800
From:   Daniel Walker <danielwa@cisco.com>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     Sathish Jarugumalli <sjarugum@cisco.com>,
        "xe-linux-external@cisco.com" <xe-linux-external@cisco.com>,
        Daniel Walker <dwalker@fifo99.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers: net: gianfar: Shortest frame drops at Ethernet
 port
Message-ID: <20191106174602.GV18744@zorba>
References: <20191106170320.27662-1-danielwa@cisco.com>
 <VI1PR04MB4880B060847C1CD175B998DF96790@VI1PR04MB4880.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR04MB4880B060847C1CD175B998DF96790@VI1PR04MB4880.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Auto-Response-Suppress: DR, OOF, AutoReply
X-Outbound-SMTP-Client: 10.154.200.26, [10.154.200.26]
X-Outbound-Node: alln-core-10.cisco.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 06, 2019 at 05:38:06PM +0000, Claudiu Manoil wrote:
> >-----Original Message-----
> >From: Daniel Walker <danielwa@cisco.com>
> >Sent: Wednesday, November 6, 2019 7:03 PM
> >To: Claudiu Manoil <claudiu.manoil@nxp.com>
> >Cc: Sathish Jarugumalli <sjarugum@cisco.com>; xe-linux-external@cisco.com;
> >Daniel Walker <dwalker@fifo99.com>; David S. Miller
> ><davem@davemloft.net>; netdev@vger.kernel.org; linux-
> >kernel@vger.kernel.org
> >Subject: [PATCH] drivers: net: gianfar: Shortest frame drops at Ethernet port
> >
> >NXP has provided the patch for packet drops  at ethernet port
> >Frames shorter than 60bytes are getting dropped at ethernetport
> >need to add padding for the shorter range frames to be transmit
> >the function "eth_skb_pad(skb" provides padding (and CRC) for
> >packets under 60 bytes
> >
> >Signed-off-by: Sathish Jarugumalli <sjarugum@cisco.com>
> >Cc: xe-linux-external@cisco.com
> >Signed-off-by: Daniel Walker <dwalker@fifo99.com>
> 
> Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
> 
> Normally padding is done by the hardware, and it works at least on my
> test cases and boards.
> But cisco seems to have hit a case where h/w padding gets
> unexpectedly disabled (concurrency issue writing the config register?).
> This patch should go as a workaround, until root cause found.


Where would this hardware setup normally happen? Does it happen in the
bootloader or inside the kernel someplace ?

Daniel
