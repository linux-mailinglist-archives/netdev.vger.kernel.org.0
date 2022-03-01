Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2072B4C8F0C
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 16:26:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235807AbiCAP0g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 10:26:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235830AbiCAP02 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 10:26:28 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E8C1AB477;
        Tue,  1 Mar 2022 07:25:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646148329; x=1677684329;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=5ftasERfPWft19zS17zOLUbt1jzgVyJZSI+ggCwhMkc=;
  b=PLppDpAf+4DeQmEUVelEIfDscXRIm5xgBZV2UnEkfXiUUa7S+QTugrZR
   t7YYueV0HpdZzrMZI/X7s+r/SpY6nwkQwGkZi/wB0xOkd3kqBlJrYMhm9
   RBjT/vVpGalXPU+JhgS8FDt5nzij3liGxsqBCnu3hcNI/ooKTfhl4OYT7
   EgU3o5xyRdUrxOR1c5me1PFJgS33ZxYD3ZiqZ837S9BI7Synjqj2eTEKi
   LIRf5q9mQTVR3nYcr2Ii6jkTgOu70O8R5+v+2uEMp+eHqSAkepuP4dJpe
   PjRVAF8a7uY26DidE/oVs9bMrRIpnU9Day7nvnuCwVyMOMadQJn08uCb0
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10272"; a="339585200"
X-IronPort-AV: E=Sophos;i="5.90,146,1643702400"; 
   d="scan'208";a="339585200"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2022 07:25:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,146,1643702400"; 
   d="scan'208";a="507834698"
Received: from lkp-server01.sh.intel.com (HELO 2146afe809fb) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 01 Mar 2022 07:25:25 -0800
Received: from kbuild by 2146afe809fb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nP4NQ-0000c9-6U; Tue, 01 Mar 2022 15:25:24 +0000
Date:   Tue, 1 Mar 2022 23:24:31 +0800
From:   kernel test robot <lkp@intel.com>
To:     Veerasenareddy Burru <vburru@marvell.com>, davem@davemloft.net,
        kuba@kernel.org, corbet@lwn.net, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Abhijit Ayarekar <aayarekar@marvell.com>,
        Satananda Burla <sburla@marvell.com>
Subject: Re: [PATCH v2 1/7] octeon_ep: Add driver framework and device
 initialization
Message-ID: <202203012301.wRb7tB6D-lkp@intel.com>
References: <20220301050359.19374-2-vburru@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220301050359.19374-2-vburru@marvell.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Veerasenareddy,

I love your patch! Yet something to improve:

[auto build test ERROR on linus/master]
[also build test ERROR on v5.17-rc6 next-20220301]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Veerasenareddy-Burru/Add-octeon_ep-driver/20220301-130525
base:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git 719fce7539cd3e186598e2aed36325fe892150cf
reproduce: make htmldocs

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> Documentation/networking/device_drivers/ethernet/marvell/octeon_ep.rst:3: (SEVERE/4) Title overline & underline mismatch.

vim +3 Documentation/networking/device_drivers/ethernet/marvell/octeon_ep.rst

     2	
   > 3	===================================================================
     4	Linux kernel networking driver for Marvell's Octeon PCI Endpoint NIC
     5	====================================================================
     6	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
