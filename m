Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 226FC6BE933
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 13:30:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbjCQMa0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 08:30:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbjCQMaZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 08:30:25 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADBBE69CF2;
        Fri, 17 Mar 2023 05:30:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679056223; x=1710592223;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Dcu+SfJwqEMVOxpF4gx5A8y0ttWQQQWkDFj8IuNC5TE=;
  b=bV/9ib5/JYO3hFSzNJS3XqdakY60G2y9nJao5L2sX53IXncfJaXfC81B
   WJgjOn4x31r+HhAM6j6mxH5TzI+IQi64sMIpSkkf5DdTALLTB7Ug34IW2
   tGQTghbtQ6VrPo+pAB3chOaiEb9ze7BjOBOj54jvwT549xccbNzSXglPW
   k8vsND+WzA/b2Kg95eC8h/esE9S9PtcUd+y9l2M0SKF/mW7AFV9nmc/ul
   35LLoz9CjtL5Jxxcd7eucAsy0uD79W+S6Y6Jl6RXy2ooJLMSBtksnghTC
   IPJkxnDQLkBr0DJ3Z6JqqtJt+TgfG4Ro6JYSt1MTYOg4NbUNUCn/hei7C
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="322096897"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="322096897"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2023 05:30:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="657546450"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="657546450"
Received: from unknown (HELO localhost.localdomain) ([10.237.112.144])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2023 05:30:20 -0700
Date:   Fri, 17 Mar 2023 13:30:11 +0100
From:   Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To:     Roger Quadros <rogerq@kernel.org>
Cc:     Siddharth Vadapalli <s-vadapalli@ti.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        jacob.e.keller@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        srk@ti.com
Subject: Re: [PATCH net-next] net: ethernet: ti: am65-cpts: reset pps genf
 adj settings on enable
Message-ID: <ZBRdU8Ij341WCs+f@localhost.localdomain>
References: <20230316095232.2002680-1-s-vadapalli@ti.com>
 <b0dc760d-fb7e-a19b-babc-8cd571b8f74d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b0dc760d-fb7e-a19b-babc-8cd571b8f74d@kernel.org>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 17, 2023 at 01:27:36PM +0200, Roger Quadros wrote:
> 
> 
> On 16/03/2023 11:52, Siddharth Vadapalli wrote:
> > From: Grygorii Strashko <grygorii.strashko@ti.com>
> > 
> > The CPTS PPS GENf adjustment settings are invalid after it has been
> > disabled for a while, so reset them.
> > 
> > Fixes: eb9233ce6751 ("net: ethernet: ti: am65-cpts: adjust pps following ptp changes")
> > Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> > Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
> 
> Reviewed-by: Roger Quadros <rogerq@kernel.org>

Small nit for the future: should be [PATCH net] instead of net-next when
You sending fixes.

Looks fine, thanks
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
