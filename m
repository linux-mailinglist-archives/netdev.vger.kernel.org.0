Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2658F251114
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 06:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728849AbgHYE5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 00:57:20 -0400
Received: from smtprelay0213.hostedemail.com ([216.40.44.213]:33338 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728781AbgHYE5R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 00:57:17 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay06.hostedemail.com (Postfix) with ESMTP id 2A5A018224D8E;
        Tue, 25 Aug 2020 04:57:16 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:2:41:69:355:379:541:800:960:966:973:988:989:1260:1311:1314:1345:1359:1437:1515:1535:1605:1730:1747:1777:1792:2194:2196:2199:2200:2393:2559:2562:3138:3139:3140:3141:3142:3867:3868:3870:3871:3874:4049:4118:4250:4385:4605:5007:6119:6261:7903:7904:8829:9040:10004:10848:11026:11473:11658:11914:12043:12291:12296:12297:12438:12555:12683:12895:13894:14110:14196:14394:21063:21080:21324:21627:21990:30003:30045:30054,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:0,LUA_SUMMARY:none
X-HE-Tag: twig31_370178727059
X-Filterd-Recvd-Size: 7413
Received: from joe-laptop.perches.com (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf08.hostedemail.com (Postfix) with ESMTPA;
        Tue, 25 Aug 2020 04:57:15 +0000 (UTC)
From:   Joe Perches <joe@perches.com>
To:     Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 18/29] wan: sbni: Avoid comma separated statements
Date:   Mon, 24 Aug 2020 21:56:15 -0700
Message-Id: <e79d390c5b492ecbf61fb79d35625f88c57265b6.1598331149.git.joe@perches.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <cover.1598331148.git.joe@perches.com>
References: <cover.1598331148.git.joe@perches.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use semicolons and braces.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/wan/sbni.c | 101 +++++++++++++++++++++++------------------
 1 file changed, 58 insertions(+), 43 deletions(-)

diff --git a/drivers/net/wan/sbni.c b/drivers/net/wan/sbni.c
index 40c04ea1200a..2fde439543fb 100644
--- a/drivers/net/wan/sbni.c
+++ b/drivers/net/wan/sbni.c
@@ -260,11 +260,12 @@ static int __init sbni_init(struct net_device *dev)
 		return  sbni_isa_probe( dev );
 	/* otherwise we have to perform search our adapter */
 
-	if( io[ num ] != -1 )
-		dev->base_addr	= io[ num ],
+	if( io[ num ] != -1 ) {
+		dev->base_addr	= io[ num ];
 		dev->irq	= irq[ num ];
-	else if( scandone  ||  io[ 0 ] != -1 )
+	} else if( scandone  ||  io[ 0 ] != -1 ) {
 		return  -ENODEV;
+	}
 
 	/* if io[ num ] contains non-zero address, then that is on ISA bus */
 	if( dev->base_addr )
@@ -399,12 +400,13 @@ sbni_probe1( struct net_device  *dev,  unsigned long  ioaddr,  int  irq )
 	nl->maxframe  = DEFAULT_FRAME_LEN;
 	nl->csr1.rate = baud[ num ];
 
-	if( (nl->cur_rxl_index = rxl[ num ]) == -1 )
+	if( (nl->cur_rxl_index = rxl[ num ]) == -1 ) {
 		/* autotune rxl */
-		nl->cur_rxl_index = DEF_RXL,
+		nl->cur_rxl_index = DEF_RXL;
 		nl->delta_rxl = DEF_RXL_DELTA;
-	else
+	} else {
 		nl->delta_rxl = 0;
+	}
 	nl->csr1.rxl  = rxl_tab[ nl->cur_rxl_index ];
 	if( inb( ioaddr + CSR0 ) & 0x01 )
 		nl->state |= FL_SLOW_MODE;
@@ -512,13 +514,15 @@ sbni_interrupt( int  irq,  void  *dev_id )
 
 	do {
 		repeat = 0;
-		if( inb( dev->base_addr + CSR0 ) & (RC_RDY | TR_RDY) )
-			handle_channel( dev ),
+		if( inb( dev->base_addr + CSR0 ) & (RC_RDY | TR_RDY) ) {
+			handle_channel( dev );
 			repeat = 1;
+		}
 		if( nl->second  && 	/* second channel present */
-		    (inb( nl->second->base_addr+CSR0 ) & (RC_RDY | TR_RDY)) )
-			handle_channel( nl->second ),
+		    (inb( nl->second->base_addr+CSR0 ) & (RC_RDY | TR_RDY)) ) {
+			handle_channel( nl->second );
 			repeat = 1;
+		}
 	} while( repeat );
 
 	if( nl->second )
@@ -610,11 +614,12 @@ recv_frame( struct net_device  *dev )
 		nl->state |= FL_PREV_OK;
 		if( framelen > 4 )
 			nl->in_stats.all_rx_number++;
-	} else
-		nl->state &= ~FL_PREV_OK,
-		change_level( dev ),
-		nl->in_stats.all_rx_number++,
+	} else {
+		nl->state &= ~FL_PREV_OK;
+		change_level( dev );
+		nl->in_stats.all_rx_number++;
 		nl->in_stats.bad_rx_number++;
+	}
 
 	return  !frame_ok  ||  framelen > 4;
 }
@@ -689,9 +694,10 @@ download_data( struct net_device  *dev,  u32  *crc_p )
 	*crc_p = calc_crc32( *crc_p, skb->data + nl->outpos, len );
 
 	/* if packet too short we should write some more bytes to pad */
-	for( len = nl->framelen - len;  len--; )
-		outb( 0, dev->base_addr + DAT ),
+	for( len = nl->framelen - len;  len--; ) {
+		outb( 0, dev->base_addr + DAT );
 		*crc_p = CRC32( 0, *crc_p );
+	}
 }
 
 
@@ -703,9 +709,10 @@ upload_data( struct net_device  *dev,  unsigned  framelen,  unsigned  frameno,
 
 	int  frame_ok;
 
-	if( is_first )
-		nl->wait_frameno = frameno,
+	if( is_first ) {
+		nl->wait_frameno = frameno;
 		nl->inppos = 0;
+	}
 
 	if( nl->wait_frameno == frameno ) {
 
@@ -717,33 +724,35 @@ upload_data( struct net_device  *dev,  unsigned  framelen,  unsigned  frameno,
 		 * error was occurred... drop entire packet
 		 */
 		else if( (frame_ok = skip_tail( dev->base_addr, framelen, crc ))
-			 != 0 )
-			nl->wait_frameno = 0,
-			nl->inppos = 0,
+			 != 0 ) {
+			nl->wait_frameno = 0;
+			nl->inppos = 0;
 #ifdef CONFIG_SBNI_MULTILINE
-			nl->master->stats.rx_errors++,
+			nl->master->stats.rx_errors++;
 			nl->master->stats.rx_missed_errors++;
 #else
-		        dev->stats.rx_errors++,
+		        dev->stats.rx_errors++;
 			dev->stats.rx_missed_errors++;
 #endif
+		}
 			/* now skip all frames until is_first != 0 */
 	} else
 		frame_ok = skip_tail( dev->base_addr, framelen, crc );
 
-	if( is_first  &&  !frame_ok )
+	if( is_first  &&  !frame_ok ) {
 		/*
 		 * Frame has been broken, but we had already stored
 		 * is_first... Drop entire packet.
 		 */
-		nl->wait_frameno = 0,
+		nl->wait_frameno = 0;
 #ifdef CONFIG_SBNI_MULTILINE
-		nl->master->stats.rx_errors++,
+		nl->master->stats.rx_errors++;
 		nl->master->stats.rx_crc_errors++;
 #else
-		dev->stats.rx_errors++,
+		dev->stats.rx_errors++;
 		dev->stats.rx_crc_errors++;
 #endif
+	}
 
 	return  frame_ok;
 }
@@ -782,17 +791,18 @@ interpret_ack( struct net_device  *dev,  unsigned  ack )
 		if( nl->state & FL_WAIT_ACK ) {
 			nl->outpos += nl->framelen;
 
-			if( --nl->tx_frameno )
+			if( --nl->tx_frameno ) {
 				nl->framelen = min_t(unsigned int,
 						   nl->maxframe,
 						   nl->tx_buf_p->len - nl->outpos);
-			else
-				send_complete( dev ),
+			} else {
+				send_complete( dev );
 #ifdef CONFIG_SBNI_MULTILINE
 				netif_wake_queue( nl->master );
 #else
 				netif_wake_queue( dev );
 #endif
+			}
 		}
 	}
 
@@ -872,16 +882,17 @@ drop_xmit_queue( struct net_device  *dev )
 {
 	struct net_local  *nl = netdev_priv(dev);
 
-	if( nl->tx_buf_p )
-		dev_kfree_skb_any( nl->tx_buf_p ),
-		nl->tx_buf_p = NULL,
+	if( nl->tx_buf_p ) {
+		dev_kfree_skb_any( nl->tx_buf_p );
+		nl->tx_buf_p = NULL;
 #ifdef CONFIG_SBNI_MULTILINE
-		nl->master->stats.tx_errors++,
+		nl->master->stats.tx_errors++;
 		nl->master->stats.tx_carrier_errors++;
 #else
-		dev->stats.tx_errors++,
+		dev->stats.tx_errors++;
 		dev->stats.tx_carrier_errors++;
 #endif
+	}
 
 	nl->tx_frameno	= 0;
 	nl->framelen	= 0;
@@ -1327,12 +1338,13 @@ sbni_ioctl( struct net_device  *dev,  struct ifreq  *ifr,  int  cmd )
 
 		spin_lock( &nl->lock );
 		flags = *(struct sbni_flags*) &ifr->ifr_ifru;
-		if( flags.fixed_rxl )
-			nl->delta_rxl = 0,
+		if( flags.fixed_rxl ) {
+			nl->delta_rxl = 0;
 			nl->cur_rxl_index = flags.rxl;
-		else
-			nl->delta_rxl = DEF_RXL_DELTA,
+		} else {
+			nl->delta_rxl = DEF_RXL_DELTA;
 			nl->cur_rxl_index = DEF_RXL;
+		}
 
 		nl->csr1.rxl = rxl_tab[ nl->cur_rxl_index ];
 		nl->csr1.rate = flags.rate;
@@ -1526,13 +1538,16 @@ sbni_setup( char  *p )
 		(*dest[ parm ])[ n ] = simple_strtol( p, &p, 0 );
 		if( !*p  ||  *p == ')' )
 			return 1;
-		if( *p == ';' )
-			++p, ++n, parm = 0;
-		else if( *p++ != ',' )
+		if( *p == ';' ) {
+			++p;
+			++n;
+			parm = 0;
+		} else if( *p++ != ',' ) {
 			break;
-		else
+		} else {
 			if( ++parm >= 5 )
 				break;
+		}
 	}
 bad_param:
 	pr_err("Error in sbni kernel parameter!\n");
-- 
2.26.0

