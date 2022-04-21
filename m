Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 728F6509DD6
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 12:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388480AbiDUKnG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 06:43:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388506AbiDUKmy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 06:42:54 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 734C4632F;
        Thu, 21 Apr 2022 03:40:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650537604; x=1682073604;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=NddSWJoAozQ1EYJ37VPzzZinpQJPIh7Wk/vDkRTtCkE=;
  b=SqhSbONwGwAjtROqoYblMnOBy+bmGoWnlak6zyQZvORHorV47lqqsEGM
   zBSz6X3zo/lUChlRheiXdxlo2F07WsmUFWh1cdrTs2QUCPGAzfSKw4Jk+
   eYHHFE2hZJ/s9zFFqIz/KLC7TVViyZdiT2Vb6sPFBKgOgiBHgdv5lVYc5
   dCuaFZ2K5CY8rZa82Q8Gok5djCVYid81R8huq8tNHlIGDLCjXzWN2PAjs
   iDVdR5bh/TvyCtRWfYQ8NA54buwttsbADspo3z9SHD0pxBirEZXsrmUlT
   nZcNd+ihOs8+KnkibAqtgka3IaczL6Fm3ulc+DTB56fJ6h4zR6UbWVMHz
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10323"; a="264076423"
X-IronPort-AV: E=Sophos;i="5.90,278,1643702400"; 
   d="scan'208";a="264076423"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2022 03:40:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,278,1643702400"; 
   d="scan'208";a="562520470"
Received: from boxer.igk.intel.com (HELO boxer) ([10.102.20.173])
  by fmsmga007.fm.intel.com with ESMTP; 21 Apr 2022 03:40:01 -0700
Date:   Thu, 21 Apr 2022 12:40:01 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the bpf-next tree
Message-ID: <YmE0geKVcfQtsBmz@boxer>
References: <20220419115620.65580586@canb.auug.org.au>
 <20220421103200.2b4e8424@canb.auug.org.au>
 <ac093b0a-dba7-b8b8-8a70-fccbed8fee76@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac093b0a-dba7-b8b8-8a70-fccbed8fee76@iogearbox.net>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 21, 2022 at 11:45:46AM +0200, Daniel Borkmann wrote:
> On 4/21/22 2:32 AM, Stephen Rothwell wrote:
> > Hi all,
> 
> Maciej, I presume you are already working on a follow-up for the below?

Yikes! I missed that, let's blame easter break for that.
I'm on it.

> 
> > On Tue, 19 Apr 2022 11:56:20 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > > 
> > > After merging the bpf-next tree, today's linux-next build
> > > (x86_64 allmodconfig) failed like this:
> > > 
> > > In file included from include/linux/compiler_types.h:73,
> > >                   from <command-line>:
> > > drivers/net/ethernet/intel/i40e/i40e_xsk.c: In function 'i40e_run_xdp_zc':
> > > include/linux/compiler_attributes.h:222:41: error: attribute 'fallthrough' not preceding a case label or default label [-Werror]
> > >    222 | # define fallthrough                    __attribute__((__fallthrough__))
> > >        |                                         ^~~~~~~~~~~~~
> > > drivers/net/ethernet/intel/i40e/i40e_xsk.c:192:17: note: in expansion of macro 'fallthrough'
> > >    192 |                 fallthrough; /* handle aborts by dropping packet */
> > >        |                 ^~~~~~~~~~~
> > > cc1: all warnings being treated as errors
> > > In file included from include/linux/compiler_types.h:73,
> > >                   from <command-line>:
> > > drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c: In function 'ixgbe_run_xdp_zc':
> > > include/linux/compiler_attributes.h:222:41: error: attribute 'fallthrough' not preceding a case label or default label [-Werror]
> > >    222 | # define fallthrough                    __attribute__((__fallthrough__))
> > >        |                                         ^~~~~~~~~~~~~
> > > drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c:147:17: note: in expansion of macro 'fallthrough'
> > >    147 |                 fallthrough; /* handle aborts by dropping packet */
> > >        |                 ^~~~~~~~~~~
> > > cc1: all warnings being treated as errors
> > > 
> > > Caused by commits
> > > 
> > >    b8aef650e549 ("i40e, xsk: Terminate Rx side of NAPI when XSK Rx queue gets full")
> > >    c7dd09fd4628 ("ixgbe, xsk: Terminate Rx side of NAPI when XSK Rx queue gets full")
> > > 
> > > I have used the bpf-next tree from next-20220414 for today.
> > 
> > I am still getting these failures ...
> > 
> 
