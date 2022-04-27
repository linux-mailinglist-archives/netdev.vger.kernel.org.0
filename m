Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE25510DA6
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 03:05:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355022AbiD0BGu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 21:06:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356647AbiD0BGo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 21:06:44 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E633811AA;
        Tue, 26 Apr 2022 18:03:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651021399; x=1682557399;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=5L5B8xawJzDxFfWL5gSqeQsIrvbmj1OcHO/kgxAE10U=;
  b=CB9MaecXXN2lqwtj+kaeURb7iGIXB3J0Zg77tuI4nRcIFyLicWUVXNFy
   kbqzvBDZdZQTQaQ7n/8c3LVZZsCymNMir5F8ZWAnrXC94FIv//8crptiB
   HJn4i86TVc1oZE/caU9Q6qEGvddcRK12erkM3u/P/UiGlAYDXsv/N4DwE
   E9iDDV+N1sakNVfdw1eDiytJj6m15WJY/Qpv/P6EqAXG1KBe/au+Fj8Eo
   o3CJqGXW5oAeyq5reOomRCB8LwxskLohBYZmrtE6n7hzk+BcsDcxkqwdU
   0nPqy5ShFi5vNnt8g3FAMKz0RmgiE4VGlSIkgLBupiQIrxMnD7gDdH++i
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10329"; a="290921833"
X-IronPort-AV: E=Sophos;i="5.90,292,1643702400"; 
   d="scan'208";a="290921833"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2022 18:03:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,292,1643702400"; 
   d="scan'208";a="679551087"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 26 Apr 2022 18:03:15 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1njW5K-00048o-Js;
        Wed, 27 Apr 2022 01:03:14 +0000
Date:   Wed, 27 Apr 2022 09:02:38 +0800
From:   kernel test robot <lkp@intel.com>
To:     Duoming Zhou <duoming@zju.edu.cn>, krzysztof.kozlowski@linaro.org,
        pabeni@redhat.com, linux-kernel@vger.kernel.org
Cc:     kbuild-all@lists.01.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, gregkh@linuxfoundation.org,
        alexander.deucher@amd.com, broonie@kernel.org,
        akpm@linux-foundation.org, linma@zju.edu.cn,
        Duoming Zhou <duoming@zju.edu.cn>
Subject: Re: [PATCH net v3] nfc: nfcmrvl: main: reorder destructive
 operations in nfcmrvl_nci_unregister_dev to avoid bugs
Message-ID: <202204270807.CiWK3t7m-lkp@intel.com>
References: <20220426155911.77761-1-duoming@zju.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220426155911.77761-1-duoming@zju.edu.cn>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Duoming,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Duoming-Zhou/nfc-nfcmrvl-main-reorder-destructive-operations-in-nfcmrvl_nci_unregister_dev-to-avoid-bugs/20220427-000533
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git 24cbdb910bb62b5be3865275e5682be1a7708c0f
config: i386-randconfig-s001-20220425 (https://download.01.org/0day-ci/archive/20220427/202204270807.CiWK3t7m-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.2.0-20) 11.2.0
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.4-dirty
        # https://github.com/intel-lab-lkp/linux/commit/87bb704da970003fb8a7091317e0e5a1b1f2b009
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Duoming-Zhou/nfc-nfcmrvl-main-reorder-destructive-operations-in-nfcmrvl_nci_unregister_dev-to-avoid-bugs/20220427-000533
        git checkout 87bb704da970003fb8a7091317e0e5a1b1f2b009
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=i386 SHELL=/bin/bash net/nfc/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)
>> net/nfc/core.c:28:6: sparse: sparse: symbol 'nfc_download' was not declared. Should it be static?

Please review and possibly fold the followup patch.

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
