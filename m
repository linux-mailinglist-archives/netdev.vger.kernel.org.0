Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03A82547D8F
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 04:09:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235664AbiFMCJt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jun 2022 22:09:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231376AbiFMCJs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jun 2022 22:09:48 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DCBC21250;
        Sun, 12 Jun 2022 19:09:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655086188; x=1686622188;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=+fem5FyudAz01p+w/Af/9mmPzXNj8Wp0IAnkI0tnZHI=;
  b=UuZBV9GPahHME/ZhZLAoX/3R0Qmgi9pphWTMAe1Jke9hd7wLXC+9Zdgm
   B76F/osL4vRXkqnBY2ma3dc/WK8qOabL2pSjSPLzEMY0Qu6FjAvFw2Ch2
   dW+EI/AOiLzEIGrwnOmlK53qk/zO5l9seS4TFND1T8lY5q+z61aqWFMjs
   /PTAd2yOOWzKi/PRL74SPjVRvZLayD1YAMO/VBdw7QTpwJ0AqeifTQilv
   1DDyDlkYcG4XOua70QDWH2wLlZRq8kAcOfN4ZI/a+0zMSKtRAbaTD4blX
   kFx1fN71ZD1pZlObBULmCQC/+G/d9SwYIl202WfBXHMUDPy1CUgIvvGIe
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10376"; a="303526704"
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="303526704"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2022 19:09:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="587525050"
Received: from shbuild999.sh.intel.com (HELO localhost) ([10.239.146.138])
  by fmsmga007.fm.intel.com with ESMTP; 12 Jun 2022 19:09:43 -0700
Date:   Mon, 13 Jun 2022 10:09:43 +0800
From:   Feng Tang <feng.tang@intel.com>
To:     Willy Tarreau <w@1wt.eu>, Moshe Kol <moshe.kol@mail.huji.ac.il>,
        fengwei.yin@intel.com
Cc:     Moshe Kol <moshe.kol@mail.huji.ac.il>,
        kernel test robot <oliver.sang@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Yossi Gilad <yossi.gilad@mail.huji.ac.il>,
        Amit Klein <aksecurity@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        lkp@lists.01.org, lkp@intel.com, ying.huang@intel.com,
        zhengjun.xing@linux.intel.com, fengwei.yin@intel.com
Subject: Re: [tcp] e926147618: stress-ng.icmp-flood.ops_per_sec -8.7%
 regression
Message-ID: <20220613020943.GD75244@shbuild999.sh.intel.com>
References: <20220608060802.GA22428@xsang-OptiPlex-9020>
 <20220608064822.GC7547@1wt.eu>
 <CACi_AuAr70bDB79zg9aAF1rD7e1qGgFwCGCAPYtS-zCp_zA0iw@mail.gmail.com>
 <20220608073441.GE7547@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220608073441.GE7547@1wt.eu>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, Jun 08, 2022 at 09:34:41AM +0200, Willy Tarreau wrote:
> On Wed, Jun 08, 2022 at 10:26:12AM +0300, Moshe Kol wrote:
> > Hmm, How is the ICMP flood stress test related to TCP connections?
> 
> To me it's not directly related, unless the test pre-establishes many
> connections, or is affected in a way or another by a larger memory
> allocation of this part.

Fengwei and I discussed and thought this could be a data alignment
related case, that one module's data alignment change affects other
modules' alignment, and we had a patch for detecting similar cases [1]

After some debugging, this could be related with the bss section
alignment changes, that if we forced all module's bss section to be
4KB aligned, then the stress-ng icmp-flood case will have almost no
performance difference for the 2 commits: 

10025135            +0.8%   10105711 ±  2%  stress-ng.icmp-flood.ops_per_sec

The debug patch is:

diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 7fda7f27e7620..7eb626b98620c 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -378,7 +378,9 @@ SECTIONS
 
 	/* BSS */
 	. = ALIGN(PAGE_SIZE);
-	.bss : AT(ADDR(.bss) - LOAD_OFFSET) {
+	.bss : AT(ADDR(.bss) - LOAD_OFFSET)
+	SUBALIGN(PAGE_SIZE)
+	{
 		__bss_start = .;
 		*(.bss..page_aligned)
 		. = ALIGN(PAGE_SIZE);

The 'table_perturb[]' used to be in bss section, and with the commit
of moving it to runtime allocation, other data structures following it
in the .bss section will get affected accordingly.

Thanks,
Feng


> Willy
