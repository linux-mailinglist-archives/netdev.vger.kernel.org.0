Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 884446246D9
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 17:25:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231400AbiKJQZO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 11:25:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231376AbiKJQZK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 11:25:10 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 165181573A;
        Thu, 10 Nov 2022 08:25:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668097510; x=1699633510;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rU0QzIohAyUuYdpoBNuGAGXeXSp1KoJaKFWdIztu+Sc=;
  b=m3FP9UqSgbNDccJ1W9v0iFMu2rJdJ8pv/i+qunA2gbHmbEdwVMZeMJcl
   37nnexhIFwISD0fOlmZJd4PGDP+oV5Am57qhOy/Fl9u17T5o2eRZKCxku
   pPvSyGOvYMcgY+B6bMGdvxgJZ4nBZbRibRq0MQLx8yacF0BYDR4Scgb9R
   muJKN1NfKKm9yK+QkzNVWuDZZU+EFMZB8LhVSp9adqwlpyNropIhHtu2X
   qBtdSRgo/w3vOX3wzL8oVhrFE39dX9UurxXPOAd0+uC99Gv5VxqV0hPhJ
   AbMSppi7adqP9wqgYf82Cwan1Pb0YZeGI26Q7uZw0GWME+chk/L1IZRBG
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="311357396"
X-IronPort-AV: E=Sophos;i="5.96,154,1665471600"; 
   d="scan'208";a="311357396"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2022 08:25:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="631709095"
X-IronPort-AV: E=Sophos;i="5.96,154,1665471600"; 
   d="scan'208";a="631709095"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga007.jf.intel.com with ESMTP; 10 Nov 2022 08:25:06 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 2AAGP4AG017787;
        Thu, 10 Nov 2022 16:25:04 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        linux@armlinux.org.uk, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next v3 0/4] net: lan966x: Add xdp support
Date:   Thu, 10 Nov 2022 17:21:48 +0100
Message-Id: <20221110162148.3533816-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <Y20DT2XTTIlU/wbx@lunn.ch>
References: <20221109204613.3669905-1-horatiu.vultur@microchip.com> <20221110111747.1176760-1-alexandr.lobakin@intel.com> <Y20DT2XTTIlU/wbx@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Thu, 10 Nov 2022 14:57:35 +0100

> > Nice stuff! I hear time to time that XDP is for 10G+ NICs only, but
> > I'm not a fan of such, and this series proves once again XDP fits
> > any hardware ^.^
> 
> The Freescale FEC recently gained XDP support. Many variants of it are
> Fast Ethernet only.
> 
> What i found most interesting about that patchset was that the use of
> the page_ppol API made the driver significantly faster for the general
> case as well as XDP.

The driver didn't have any page recycling or page splitting logics,
while Page Pool recycles even pages from skbs if
skb_mark_for_recycle() is used, which is the case here. So it
significantly reduced the number of new page allocations for Rx, if
there still are any at all.
Plus, Page Pool allocates pages by bulks (of 16 IIRC), not one by
one, that reduces CPU overhead as well.

> 
>      Andrew

Thanks,
Olek
