Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 002214D08FC
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 21:54:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245453AbiCGUzY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 15:55:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245411AbiCGUzF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 15:55:05 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCB4F34656;
        Mon,  7 Mar 2022 12:53:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646686419; x=1678222419;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=JcJUkTKZL/93UJ5Ywi8SfyzOjahp0gYVOJlYJUbzoxM=;
  b=H9vHSXVtD8zhoRFzkluKhtqE2Pf6hey6O8TRXIaDNT8qwt8N5kjPOxxO
   1Ak0gEtMYkXZ6qLwc2ZUVohQIf3wYSBS7Jfbnl4//TFhFTUIeL4S2ZUpZ
   maLksrMtsMaUQpoMD2alzuEylHD5nzsW6cuRCWP/2lVOP2htCBbkqY62g
   MPHpmGv0jFieqklTwnNyUZqEmkcnvk//eksasLUlE/EgEOnbzL/0xazjT
   Y2mmGEF4f5wxL2x+ip7RPM9AhuFRJo4wsmGD8VINUkgZd4Jknccqo8g+0
   RoJbsSSCPrJR1XVOM5wQj0uiQFJSPfI3f50wksX1vZIP9j1xvPRRBsirE
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10279"; a="234456350"
X-IronPort-AV: E=Sophos;i="5.90,163,1643702400"; 
   d="scan'208";a="234456350"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2022 12:53:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,163,1643702400"; 
   d="scan'208";a="509844026"
Received: from boxer.igk.intel.com (HELO boxer) ([10.102.20.173])
  by orsmga002.jf.intel.com with ESMTP; 07 Mar 2022 12:53:36 -0800
Date:   Mon, 7 Mar 2022 21:53:35 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        kuba@kernel.org, magnus.karlsson@intel.com
Subject: Re: linux-next: build failure after merge of the net-next tree
Message-ID: <YiZwz+6nRwl9YekK@boxer>
References: <20220307213659.47658125@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220307213659.47658125@canb.auug.org.au>
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 07, 2022 at 09:36:59PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the net-next tree, today's linux-next build (arm64
> allmodconfig) failed like this:
> 
> drivers/net/ethernet/intel/ice/ice_xsk.c: In function 'ice_xmit_pkt_batch':
> drivers/net/ethernet/intel/ice/ice_xsk.c:801:0: error: ignoring #pragma GCC unroll [-Werror=unknown-pragmas]
>   loop_unrolled_for(i = 0; i < PKTS_PER_BATCH; i++) {
>  ^
> cc1: all warnings being treated as errors
> 
> Caused by commit
> 
>   126cdfe1007a ("ice: xsk: Improve AF_XDP ZC Tx and use batching API")
> 
> This build was done with gcc v5.4.

Hey Stephen, thanks for a report, I'll send a fix to net-next immediately.
Maciej

> 
> -- 
> Cheers,
> Stephen Rothwell


