Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44C1E65E726
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 09:57:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231609AbjAEI50 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 03:57:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231230AbjAEI5Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 03:57:24 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCF85643A
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 00:57:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672909043; x=1704445043;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ZPTrR+PjrZgnO/1D4IXm16LdgOv/6D8NV5bBgaWnMkU=;
  b=K16KL8u4kAcQ/qO1oeaqyJOuYgTfinIKCXvDbCu3xPmO9bv0zvh9h5vx
   j9Wzot1vcYF/3rOxLdp6TatnSQNqnHfr+lwgZ5TBvNs9easGtzvJQBYoz
   YCHyWl2ookqSNE24+7PPaE2r4RGnY4JBgaCviMSYmVCcxv+1q6p8FfTSW
   aD61v9rtLJZJ2v+ANUSiW12bqVUP4De8Nwp1VRhbbCe7Fpa2LSzMzItHV
   Beqa2kGU1LbvdUSsaF03szIb+MODQtI2Tw8jInVF6ZyklY+1OLmgy0ON7
   fE3mEtGDsfW9EdyveV1KeFAWFRSfBIQS6Eh1nivff3EEdck3p/CfwAoqe
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10580"; a="305655899"
X-IronPort-AV: E=Sophos;i="5.96,302,1665471600"; 
   d="scan'208";a="305655899"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2023 00:57:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10580"; a="687841292"
X-IronPort-AV: E=Sophos;i="5.96,302,1665471600"; 
   d="scan'208";a="687841292"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga001.jf.intel.com with ESMTP; 05 Jan 2023 00:57:21 -0800
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id 825F8162; Thu,  5 Jan 2023 10:57:53 +0200 (EET)
Date:   Thu, 5 Jan 2023 10:57:53 +0200
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Jamet <michael.jamet@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 3/3] net: thunderbolt: Add tracepoints
Message-ID: <Y7aREZD2r4/PH2lA@black.fi.intel.com>
References: <20230104081731.45928-1-mika.westerberg@linux.intel.com>
 <20230104081731.45928-4-mika.westerberg@linux.intel.com>
 <20230104205017.3e3cff38@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230104205017.3e3cff38@kernel.org>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, Jan 04, 2023 at 08:50:17PM -0800, Jakub Kicinski wrote:
> On Wed,  4 Jan 2023 10:17:31 +0200 Mika Westerberg wrote:
> > +DECLARE_EVENT_CLASS(tbnet_ip_frame,
> > +	TP_PROTO(u32 size, u32 id, u32 index, u32 count),
> > +	TP_ARGS(size, id, index, count),
> > +	TP_STRUCT__entry(
> > +		__field(u32, size)
> > +		__field(u32, id)
> > +		__field(u32, index)
> > +		__field(u32, count)
> > +	),
> > +	TP_fast_assign(
> > +		__entry->size = le32_to_cpu(size);
> > +		__entry->id = le32_to_cpu(id);
> > +		__entry->index = le32_to_cpu(index);
> > +		__entry->count = le32_to_cpu(count);
> 
> Looks like sparse is not happy with the byte swaps, perhaps PROTO
> can also use the __le32 type?
> 
> Could you make sure there are no new warnings when building with
> 
>   make drivers/net/thunderbolt/ C=1 W=1
> 
> ?

Sure, I will fix then in v2.
