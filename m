Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E66B150A765
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 19:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390920AbiDURwB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 13:52:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390907AbiDURwA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 13:52:00 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 821D64A3F5;
        Thu, 21 Apr 2022 10:49:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650563350; x=1682099350;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=mA55YQhjLIsfXwlrMTErhiZKJ7+sd5wb1DTEqU6nP0c=;
  b=Tp0j6QYRcdOMOxxYkkvo9nleMLUru6vo1WDTH9wTD3DnU57VDlNZfepP
   qK6AkQHMBRpfmbKCTQZ61yKLESAT+/Fj+nnSxUOf/BJ4sZAqmpXb41G94
   Y2RK9oCGT7sBR825yjGeXpN8vq4r5BflVL8LB1i31CVHnDECk4XprG6DO
   ONTdH8uNzw75DvQENcgTPHj3C6SfAJW0k/t112UhaValt1K2mjJFKuo/Q
   YoJhnsR9aBtWFGenWu6xiVDcknON76OvhTORLw/uW842DgXMYL0LK4QIX
   6iH/DkJ8N++ir5RAyvEXaI+VUiUmohZQfVaG8iE4YkGfvMhXBfI0yPi+u
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10324"; a="289547871"
X-IronPort-AV: E=Sophos;i="5.90,279,1643702400"; 
   d="scan'208";a="289547871"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2022 10:49:10 -0700
X-IronPort-AV: E=Sophos;i="5.90,279,1643702400"; 
   d="scan'208";a="562674802"
Received: from ssaladi-mobl1.amr.corp.intel.com (HELO localhost) ([10.213.165.163])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2022 10:49:09 -0700
Date:   Thu, 21 Apr 2022 10:49:09 -0700
From:   Ira Weiny <ira.weiny@intel.com>
To:     Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>
Cc:     outreachy@lists.linux.dev, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] igb: Convert kmap() to kmap_local_page()
Message-ID: <YmGZFfcY/Yz6Iv1Y@iweiny-desk3>
References: <20220419234313.10324-1-eng.alaamohamedsoliman.am@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220419234313.10324-1-eng.alaamohamedsoliman.am@gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 20, 2022 at 01:43:13AM +0200, Alaa Mohamed wrote:
> kmap() is being deprecated and these usages are all local to the thread
> so there is no reason kmap_local_page() can't be used.
> 
> Replace kmap() calls with kmap_local_page().
> 
> Signed-off-by: Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

> ---
> changes in V2:
> 	fix kunmap_local path value to take address of the mapped page.
> ---
> changes in V3:
> 	edit commit message to be clearer
> ---
> changes in V4:
> 	edit the commit message
> ---
> changes in V5:
> 	-edit commit subject
> 	-edit commit message
> ---
>  drivers/net/ethernet/intel/igb/igb_ethtool.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/igb/igb_ethtool.c b/drivers/net/ethernet/intel/igb/igb_ethtool.c
> index 2a5782063f4c..c14fc871dd41 100644
> --- a/drivers/net/ethernet/intel/igb/igb_ethtool.c
> +++ b/drivers/net/ethernet/intel/igb/igb_ethtool.c
> @@ -1798,14 +1798,14 @@ static int igb_check_lbtest_frame(struct igb_rx_buffer *rx_buffer,
>  
>  	frame_size >>= 1;
>  
> -	data = kmap(rx_buffer->page);
> +	data = kmap_local_page(rx_buffer->page);
>  
>  	if (data[3] != 0xFF ||
>  	    data[frame_size + 10] != 0xBE ||
>  	    data[frame_size + 12] != 0xAF)
>  		match = false;
>  
> -	kunmap(rx_buffer->page);
> +	kunmap_local(data);
>  
>  	return match;
>  }
> -- 
> 2.35.2
> 
