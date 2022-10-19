Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 241F9604B9D
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 17:36:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231395AbiJSPfy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 11:35:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231405AbiJSPfa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 11:35:30 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2489193EED;
        Wed, 19 Oct 2022 08:31:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666193469; x=1697729469;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mKPPAUZJv+IZYK4asgMzkdmo8Kaf+oJ5gsZS8jlapio=;
  b=NZ7rGa0T8+/7q4l1So8m6x0pGaxKm2cTCgkIaCMY5fPZJAMvpF2FXxL6
   QhZBDaCYX9jA5V4oBvwpA9vw9snKHgblyNqSWVvc/WEw+nLWOpdaOU2zu
   piYKyxi3o8eTqfuLRkCJOXrvxJAa4lqMK5MivMRG41W7mVn9mC0ItX1X2
   duuVKxkCO5Dj25hJRpyT3wjHm6Y2cR+1j91z0xn+KgVqoid9xWjcjutAD
   NAUhCaSwKCRwoLFuWsUWSjaKcRC2s6Q0mmoWyp9aWZJ6xxH+3oQrK5pqo
   vSnoqHm4P2Y5WB9gwi4+esGid0CSZ4/3/Wp1eTjH/zrWRI9dXJ9+zi3Wl
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10505"; a="370660669"
X-IronPort-AV: E=Sophos;i="5.95,196,1661842800"; 
   d="scan'208";a="370660669"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2022 08:28:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10505"; a="804351938"
X-IronPort-AV: E=Sophos;i="5.95,196,1661842800"; 
   d="scan'208";a="804351938"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga005.jf.intel.com with ESMTP; 19 Oct 2022 08:28:36 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 29JFSYTv032173;
        Wed, 19 Oct 2022 16:28:34 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Yury Norov <yury.norov@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next 5/6] bitops: make BYTES_TO_BITS() treewide-available
Date:   Wed, 19 Oct 2022 17:26:42 +0200
Message-Id: <20221019152642.2679350-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221018125520.37eb9cda@kernel.org>
References: <20221018140027.48086-1-alexandr.lobakin@intel.com> <20221018140027.48086-6-alexandr.lobakin@intel.com> <20221018125520.37eb9cda@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Tue, 18 Oct 2022 12:55:20 -0700

> On Tue, 18 Oct 2022 16:00:26 +0200 Alexander Lobakin wrote:
> > Avoid open-coding that simple expression each time by moving
> > BYTES_TO_BITS() from the probes code to <linux/bitops.h> to export
> > it to the rest of the kernel.
> > Do the same for the tools ecosystem as well (incl. its version of
> > bitops.h).
> 
> This needs to be before patch 4?

Indeed :s Thanks for catching.

Olek
