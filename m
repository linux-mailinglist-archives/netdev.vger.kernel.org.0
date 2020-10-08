Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3913D286E17
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 07:29:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727948AbgJHF3L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 01:29:11 -0400
Received: from mail-vi1eur05on2127.outbound.protection.outlook.com ([40.107.21.127]:40705
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725858AbgJHF3L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Oct 2020 01:29:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LLfd/TSbSbfH0ONlsTB12gPaCtMKT8UEzS+ddS+2EHzjinESlsF3pRPmDKE35/dthIk61o5vcA4Iw8KJ5Zarxm49BqEJTQl5FpqwSHdXFuwcUND6iiPSCAjqaGfdg/+P7EblbLabvykVfa6iyK13cd6vcKiPQOiWvr47fplf4rpyF06b8XD7hC+Yve4kdBkmzfz6ls9+s1zAIckns5u8Vl02cvC0Uzdj7giOXzEP929hQDQQzd03jlC7HhJUSmljJIfIdBNiwKnElds5UGXWE/JmtpXOveeeRq9J3slm0smvSXX5D1O/vxcTyAlr0HlHMyaCETIiDigf/t2RWTjoEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=764X0ieZKSQtAk7H5wVVmovCuWYNsGxcaNsspSru+5g=;
 b=Zxx/Z4vPGo3zDCGNalgo+sfmelvkVKaONEnEe2R1RWfPuKMsJ9Ljda9mEgr5AH3lHGHuZa1tPqj9B20hZBHLq4AF9cTnm/wm4CCtLpG4F0mXdPAwxFeZCdEtsbxplXTb63yYUNSHL62F5YUXvtCJIY04k6zP9sZxZN3yb7jVyFFpU957/IL2sP4L5GyhFg68A+C6ubWs/c7dd/ZjN1BQ8xOoMYPPxmKO2vA18+o9/HJr4frXpgalCkGJlT6sEwQMTfb8xb5WCl/Yf24Zu8kxwz3o5TvR9b6XfjjqVj39eChbaheRE+fhOkswVaOZ9VnLzaQXDoCet/53AzdTx2+u3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=764X0ieZKSQtAk7H5wVVmovCuWYNsGxcaNsspSru+5g=;
 b=TsP++7JGCmmZ+waUikQFmuA3wnf3efulRdxm0mzeFUSXxKzq8uu2YRzgnGsljz6qw9pNOWbOK/GOjvdJ6N4huJfOvYK1M4D7/AXlfcZZGcIoASNTl4GMeMW6VphT3NpFvDn+Jzn6SeyUfIV9IERsFlrkxgAwWE2KIaq2+0Zhql0=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=voleatech.de;
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com (2603:10a6:20b:1d4::23)
 by AM0PR05MB4595.eurprd05.prod.outlook.com (2603:10a6:208:ae::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32; Thu, 8 Oct
 2020 05:29:06 +0000
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::f132:2cc:34f2:5e4]) by AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::f132:2cc:34f2:5e4%7]) with mapi id 15.20.3455.023; Thu, 8 Oct 2020
 05:29:06 +0000
Date:   Thu, 8 Oct 2020 07:29:04 +0200
From:   Sven Auhagen <sven.auhagen@voleatech.de>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     anthony.l.nguyen@intel.com, davem@davemloft.net,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        sandeep.penigalapati@intel.com, brouer@redhat.com
Subject: Re: [PATCH 5/7] igb: use igb_rx_buffer_flip
Message-ID: <20201008052904.uuvp7jomutur6inx@svensmacbookair.sven.lan>
References: <20201007152506.66217-1-sven.auhagen@voleatech.de>
 <20201007152506.66217-6-sven.auhagen@voleatech.de>
 <20201007213257.GD48010@ranger.igk.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201007213257.GD48010@ranger.igk.intel.com>
X-Originating-IP: [109.193.235.168]
X-ClientProxiedBy: AM0PR07CA0007.eurprd07.prod.outlook.com
 (2603:10a6:208:ac::20) To AM8PR05MB7251.eurprd05.prod.outlook.com
 (2603:10a6:20b:1d4::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from svensmacbookair.sven.lan (109.193.235.168) by AM0PR07CA0007.eurprd07.prod.outlook.com (2603:10a6:208:ac::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.11 via Frontend Transport; Thu, 8 Oct 2020 05:29:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ab83840d-8c66-44c3-9aa0-08d86b4b12fa
X-MS-TrafficTypeDiagnostic: AM0PR05MB4595:
X-Microsoft-Antispam-PRVS: <AM0PR05MB4595EC110B410CAAF2E777C5EF0B0@AM0PR05MB4595.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZBymOe+35pS7oIzBREkRCyt0tSAADXk8m0kdJPQGbLGgbRxYLHhjHICSFiEf+QynbVwhKWnd2aEzgt3+qijbg16ieAmweT2s4CjJQTVsZmn6aY2tzQY9bEKrx9JdFVkiEWgYBYLfr99hl7aVnXsWNSHGR7cXqdWGDHDd1xGp7T7ZZbGow4SuTtOysAVQPjhPnvDCzs3KOeSFXy0ZdLEQfe7ax/SUdZEo1yobta+zLYOijY2nO/+X4Fg8p4JZaTmii6R8Eruz7J+YWZjUHfhdULOXBHU0h7A745TV+8urXoNsc8gXXwyampZIs32toxKNnt0nOSNngbYxAtrAuiOOmA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR05MB7251.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(136003)(39830400003)(366004)(346002)(44832011)(66946007)(66556008)(316002)(86362001)(8936002)(6506007)(55016002)(9686003)(7696005)(52116002)(478600001)(2906002)(16526019)(83380400001)(4326008)(66476007)(5660300002)(6916009)(186003)(956004)(26005)(8676002)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: cvlY2T48BhjVllDNCFD8JFfmGaxasZw3AkOgqj5hMIIC2oa5kxhyxazjkD5gubIAV/f1fC0gEPpUhnGpKkfzjuKmCh5ACzZ6ZOw5EXAKIk7RRnD5Kr/jxx0yjh8rltJWox478q87GQ0hF49B/X0EWvnUYQoUTjiBDCtyot2Rrm+Uaa3SnSKXqu4uwBKFWzLGE1oKuxU+xFg5HvnxS5MAODS+rm3CpaPGkJOjc+7H1M3LTDD7MFufrjIX3uEiA4oai8eUVnqxyftfUJG2GlyEGmWUYis+wJnL1Tc3+n4EeBUNKsYFI1pWOQ0RFiaf4sO3Dldpp5RTlb6w/AYFTlKnLFMchITXvXbMwEqL3KtvVLPQDmDAutYLGWFXi8Yj56mA7GhQNkegl/3IvpGgldG95CcavzgH9zeRQzadDGD03JXtw1B+GU/j6gOrVflAe4cBXRbzROA4gAzI6TAqvkfbBlqA2zMHTYXObT5dQHeuPsi1kZuYbJXJ6pQ06Zo/QMjyIcan0c1gEJmf1hKZc4yaX4VC7hv0ANuzhqT9QOUTygOZ9YvEKtyRGhLm9YjqQhsrMmSCyWTz+bUYGPvOHt/uUR8h4yR1HbdPx/kCW0x3RWhu5mbFGeBWNTyhJHl0SrtYvcDOuvvBX6FcOa+5oDzm6g==
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: ab83840d-8c66-44c3-9aa0-08d86b4b12fa
X-MS-Exchange-CrossTenant-AuthSource: AM8PR05MB7251.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2020 05:29:05.9800
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zr5qlGurrr3o7c1ptgV9WORL7OSTkKbAeFswhbb2Ma8GK92E+3qjZzSGAP1p0h/wts26V/FTqbbzEaHdOYNRpZb47SEbTZdi7uoInA3qqjs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4595
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 07, 2020 at 11:32:57PM +0200, Maciej Fijalkowski wrote:
> On Wed, Oct 07, 2020 at 05:25:04PM +0200, sven.auhagen@voleatech.de wrote:
> > From: Sven Auhagen <sven.auhagen@voleatech.de>
> > 
> > Also use the new helper function igb_rx_buffer_flip in
> > igb_build_skb/igb_add_rx_frag.
> > 
> > Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
> > ---
> >  drivers/net/ethernet/intel/igb/igb_main.c | 87 +++++++++--------------
> >  1 file changed, 35 insertions(+), 52 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
> > index 36ff8725fdaf..f34faf24190a 100644
> > --- a/drivers/net/ethernet/intel/igb/igb_main.c
> > +++ b/drivers/net/ethernet/intel/igb/igb_main.c
> > @@ -8255,6 +8255,34 @@ static bool igb_can_reuse_rx_page(struct igb_rx_buffer *rx_buffer)
> >  	return true;
> >  }
> >  
> > +static unsigned int igb_rx_frame_truesize(struct igb_ring *rx_ring,
> > +					  unsigned int size)
> > +{
> > +	unsigned int truesize;
> > +
> > +#if (PAGE_SIZE < 8192)
> > +	truesize = igb_rx_pg_size(rx_ring) / 2; /* Must be power-of-2 */
> > +#else
> > +	truesize = ring_uses_build_skb(rx_ring) ?
> > +		SKB_DATA_ALIGN(IGB_SKB_PAD + size) +
> > +		SKB_DATA_ALIGN(sizeof(struct skb_shared_info)) :
> > +		SKB_DATA_ALIGN(size);
> > +#endif
> > +	return truesize;
> > +}
> > +
> > +static void igb_rx_buffer_flip(struct igb_ring *rx_ring,
> > +			       struct igb_rx_buffer *rx_buffer,
> > +			       unsigned int size)
> > +{
> > +	unsigned int truesize = igb_rx_frame_truesize(rx_ring, size);
> > +#if (PAGE_SIZE < 8192)
> > +	rx_buffer->page_offset ^= truesize;
> > +#else
> > +	rx_buffer->page_offset += truesize;
> > +#endif
> > +}
> > +
> >  /**
> >   *  igb_add_rx_frag - Add contents of Rx buffer to sk_buff
> >   *  @rx_ring: rx descriptor ring to transact packets on
> > @@ -8269,20 +8297,12 @@ static void igb_add_rx_frag(struct igb_ring *rx_ring,
> >  			    struct sk_buff *skb,
> >  			    unsigned int size)
> >  {
> > -#if (PAGE_SIZE < 8192)
> > -	unsigned int truesize = igb_rx_pg_size(rx_ring) / 2;
> > -#else
> > -	unsigned int truesize = ring_uses_build_skb(rx_ring) ?
> > -				SKB_DATA_ALIGN(IGB_SKB_PAD + size) :
> > -				SKB_DATA_ALIGN(size);
> > -#endif
> > +	unsigned int truesize = igb_rx_frame_truesize(rx_ring, size);
> 
> I don't think we need to account the size of skb_shared_info when adding
> another frag as we already have the skb in place with its skb_shared_info.
> 
> Also, please make sure that you list all of the changes that patch
> contains in the commit message, you simply skipped the fact that you're
> making use of igb_rx_frame_truesize on other places.

Do you have a suggestion on how to add the truesize and flip function
at this point? The truesize is not suited here then and returns 
the wrong size for frags.

> 
> > +
> >  	skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags, rx_buffer->page,
> >  			rx_buffer->page_offset, size, truesize);
> > -#if (PAGE_SIZE < 8192)
> > -	rx_buffer->page_offset ^= truesize;
> > -#else
> > -	rx_buffer->page_offset += truesize;
> > -#endif
> > +
> > +	igb_rx_buffer_flip(rx_ring, rx_buffer, size);
> >  }
> >  
> >  static struct sk_buff *igb_construct_skb(struct igb_ring *rx_ring,
> > @@ -8345,14 +8365,9 @@ static struct sk_buff *igb_build_skb(struct igb_ring *rx_ring,
> >  				     struct xdp_buff *xdp,
> >  				     union e1000_adv_rx_desc *rx_desc)
> >  {
> > +	unsigned int size = xdp->data_end - xdp->data_hard_start;
> > +	unsigned int truesize = igb_rx_frame_truesize(rx_ring, size);
> 
> Here you will be counting the IGB_SKB_PAD twice for pages > 4k.
> xdp->data_end - xdp->data_hard_start already includes the IGB_SKB_PAD and
> then igb_rx_frame_truesize will add this IGB_SKB_PAD once again to the
> size you're providing.
> 
> Please drop the additional usage of igb_rx_frame_truesize in this patch.
> 

The igb_rx_buffer_flip will use the wrong truesize though even when I
remove igb_rx_frame_truesize here.
Should I drop the entire patch as the truesize for the flip will be
incorrect in both places?

> >  	unsigned int metasize = xdp->data - xdp->data_meta;
> > -#if (PAGE_SIZE < 8192)
> > -	unsigned int truesize = igb_rx_pg_size(rx_ring) / 2;
> > -#else
> > -	unsigned int truesize = SKB_DATA_ALIGN(sizeof(struct skb_shared_info)) +
> > -				SKB_DATA_ALIGN(xdp->data_end -
> > -					       xdp->data_hard_start);
> > -#endif
> >  	struct sk_buff *skb;
> >  
> >  	/* prefetch first cache line of first page */
> > @@ -8377,11 +8392,7 @@ static struct sk_buff *igb_build_skb(struct igb_ring *rx_ring,
> >  	}
> >  
> >  	/* update buffer offset */
> > -#if (PAGE_SIZE < 8192)
> > -	rx_buffer->page_offset ^= truesize;
> > -#else
> > -	rx_buffer->page_offset += truesize;
> > -#endif
> > +	igb_rx_buffer_flip(rx_ring, rx_buffer, size);
> >  
> >  	return skb;
> >  }
> > @@ -8431,34 +8442,6 @@ static struct sk_buff *igb_run_xdp(struct igb_adapter *adapter,
> >  	return ERR_PTR(-result);
> >  }
> >  
> > -static unsigned int igb_rx_frame_truesize(struct igb_ring *rx_ring,
> > -					  unsigned int size)
> > -{
> > -	unsigned int truesize;
> > -
> > -#if (PAGE_SIZE < 8192)
> > -	truesize = igb_rx_pg_size(rx_ring) / 2; /* Must be power-of-2 */
> > -#else
> > -	truesize = ring_uses_build_skb(rx_ring) ?
> > -		SKB_DATA_ALIGN(IGB_SKB_PAD + size) +
> > -		SKB_DATA_ALIGN(sizeof(struct skb_shared_info)) :
> > -		SKB_DATA_ALIGN(size);
> > -#endif
> > -	return truesize;
> > -}
> > -
> > -static void igb_rx_buffer_flip(struct igb_ring *rx_ring,
> > -			       struct igb_rx_buffer *rx_buffer,
> > -			       unsigned int size)
> > -{
> > -	unsigned int truesize = igb_rx_frame_truesize(rx_ring, size);
> > -#if (PAGE_SIZE < 8192)
> > -	rx_buffer->page_offset ^= truesize;
> > -#else
> > -	rx_buffer->page_offset += truesize;
> > -#endif
> > -}
> > -
> >  static inline void igb_rx_checksum(struct igb_ring *ring,
> >  				   union e1000_adv_rx_desc *rx_desc,
> >  				   struct sk_buff *skb)
> > -- 
> > 2.20.1
> > 
