Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 554FC6D7739
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 10:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237609AbjDEIpx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 04:45:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237575AbjDEIpw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 04:45:52 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4D675264
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 01:45:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680684348; x=1712220348;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=3ehf2CGmr+OGQ8Pc20RDRCV5GfEU4triEARKE6suZhM=;
  b=UU8aeyjVwCtj3t5Pr/fQutQ4KOBgP9KCRbb+CZwX0LyCyURT5rjV9jgP
   qKXrIRaDx8oG153cegbh8My/CojZgWQljrJCgy2Y6m/xmlkURzoB2MeXz
   LZAouNdmk0D2chMOYS7HDSK7MGt8vykzk3HZa+f106eD+4fhn7Wkj3e5d
   ycYnlwnwTONqF35y8Ez0K/huC5rcXiVP8J5R78zKw5x/lqRJhNLV76YwO
   YLcsJArUwLuXXYX5oUchjvzTv85DQxMGdMvEmxr2Z2mCagYHryR2KtRVv
   UXL20vmYZy9UDFJlLiwPpyPSiWQEuhbxeNsQqrA/guQBpsiDJuvjvHXNR
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="341126947"
X-IronPort-AV: E=Sophos;i="5.98,319,1673942400"; 
   d="scan'208";a="341126947"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2023 01:45:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="719233446"
X-IronPort-AV: E=Sophos;i="5.98,319,1673942400"; 
   d="scan'208";a="719233446"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga001.jf.intel.com with ESMTP; 05 Apr 2023 01:45:45 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1pjylz-00CktN-2v;
        Wed, 05 Apr 2023 11:45:43 +0300
Date:   Wed, 5 Apr 2023 11:45:43 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Mika Westerberg <mika.westerberg@linux.intel.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Jamet <michael.jamet@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] net: thunderbolt: Fix sparse warnings
Message-ID: <ZC01N8tU9SN70GDh@smile.fi.intel.com>
References: <20230404053636.51597-1-mika.westerberg@linux.intel.com>
 <20230404053636.51597-2-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230404053636.51597-2-mika.westerberg@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 04, 2023 at 08:36:35AM +0300, Mika Westerberg wrote:
> Fixes the following warnings when the driver is built with sparse
> checks enabled:

> drivers/net/thunderbolt/main.c:767:47: warning: restricted __le32 degrades to integer
> drivers/net/thunderbolt/main.c:775:47: warning: restricted __le16 degrades to integer
> drivers/net/thunderbolt/main.c:776:44: warning: restricted __le16 degrades to integer
> drivers/net/thunderbolt/main.c:876:40: warning: incorrect type in assignment (different base types)
> drivers/net/thunderbolt/main.c:876:40:    expected restricted __le32 [usertype] frame_size
> drivers/net/thunderbolt/main.c:876:40:    got unsigned int [assigned] [usertype] frame_size
> drivers/net/thunderbolt/main.c:877:41: warning: incorrect type in assignment (different base types)
> drivers/net/thunderbolt/main.c:877:41:    expected restricted __le32 [usertype] frame_count
> drivers/net/thunderbolt/main.c:877:41:    got unsigned int [usertype]
> drivers/net/thunderbolt/main.c:878:41: warning: incorrect type in assignment (different base types)
> drivers/net/thunderbolt/main.c:878:41:    expected restricted __le16 [usertype] frame_index
> drivers/net/thunderbolt/main.c:878:41:    got unsigned short [usertype]
> drivers/net/thunderbolt/main.c:879:38: warning: incorrect type in assignment (different base types)
> drivers/net/thunderbolt/main.c:879:38:    expected restricted __le16 [usertype] frame_id
> drivers/net/thunderbolt/main.c:879:38:    got unsigned short [usertype]
> drivers/net/thunderbolt/main.c:880:62: warning: restricted __le32 degrades to integer
> drivers/net/thunderbolt/main.c:880:35: warning: restricted __le16 degrades to integer
> drivers/net/thunderbolt/main.c:993:23: warning: incorrect type in initializer (different base types)
> drivers/net/thunderbolt/main.c:993:23:    expected restricted __wsum [usertype] wsum
> drivers/net/thunderbolt/main.c:993:23:    got restricted __be32 [usertype]

You can drop the whole part with file name and line numbers to make the above
neater.

> No functional changes intended.
> 
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> ---
>  drivers/net/thunderbolt/main.c | 21 ++++++++++++---------
>  1 file changed, 12 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/thunderbolt/main.c b/drivers/net/thunderbolt/main.c
> index 26ef3706445e..6a43ced74881 100644
> --- a/drivers/net/thunderbolt/main.c
> +++ b/drivers/net/thunderbolt/main.c
> @@ -764,7 +764,7 @@ static bool tbnet_check_frame(struct tbnet *net, const struct tbnet_frame *tf,
>  	 */
>  	if (net->skb && net->rx_hdr.frame_count) {
>  		/* Check the frame count fits the count field */
> -		if (frame_count != net->rx_hdr.frame_count) {
> +		if (frame_count != le32_to_cpu(net->rx_hdr.frame_count)) {
>  			net->stats.rx_length_errors++;
>  			return false;
>  		}
> @@ -772,8 +772,8 @@ static bool tbnet_check_frame(struct tbnet *net, const struct tbnet_frame *tf,
>  		/* Check the frame identifiers are incremented correctly,
>  		 * and id is matching.
>  		 */
> -		if (frame_index != net->rx_hdr.frame_index + 1 ||
> -		    frame_id != net->rx_hdr.frame_id) {
> +		if (frame_index != le16_to_cpu(net->rx_hdr.frame_index) + 1 ||
> +		    frame_id != le16_to_cpu(net->rx_hdr.frame_id)) {
>  			net->stats.rx_missed_errors++;
>  			return false;
>  		}
> @@ -873,11 +873,12 @@ static int tbnet_poll(struct napi_struct *napi, int budget)
>  					TBNET_RX_PAGE_SIZE - hdr_size);
>  		}
>  
> -		net->rx_hdr.frame_size = frame_size;
> -		net->rx_hdr.frame_count = le32_to_cpu(hdr->frame_count);
> -		net->rx_hdr.frame_index = le16_to_cpu(hdr->frame_index);
> -		net->rx_hdr.frame_id = le16_to_cpu(hdr->frame_id);
> -		last = net->rx_hdr.frame_index == net->rx_hdr.frame_count - 1;
> +		net->rx_hdr.frame_size = hdr->frame_size;
> +		net->rx_hdr.frame_count = hdr->frame_count;
> +		net->rx_hdr.frame_index = hdr->frame_index;
> +		net->rx_hdr.frame_id = hdr->frame_id;
> +		last = le16_to_cpu(net->rx_hdr.frame_index) ==
> +		       le32_to_cpu(net->rx_hdr.frame_count) - 1;
>  
>  		rx_packets++;
>  		net->stats.rx_bytes += frame_size;
> @@ -990,8 +991,10 @@ static bool tbnet_xmit_csum_and_map(struct tbnet *net, struct sk_buff *skb,
>  {
>  	struct thunderbolt_ip_frame_header *hdr = page_address(frames[0]->page);
>  	struct device *dma_dev = tb_ring_dma_device(net->tx_ring.ring);
> -	__wsum wsum = htonl(skb->len - skb_transport_offset(skb));
>  	unsigned int i, len, offset = skb_transport_offset(skb);
> +	/* Remove payload length from checksum */
> +	u32 paylen = skb->len - skb_transport_offset(skb);
> +	__wsum wsum = (__force __wsum)htonl(paylen);
>  	__be16 protocol = skb->protocol;
>  	void *data = skb->data;
>  	void *dest = hdr + 1;

I would split wsum fix from the above as they are of different nature.

-- 
With Best Regards,
Andy Shevchenko


