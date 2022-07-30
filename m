Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECB38585C0C
	for <lists+netdev@lfdr.de>; Sat, 30 Jul 2022 22:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235831AbiG3UTc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jul 2022 16:19:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235265AbiG3UTa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jul 2022 16:19:30 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F32C313FA7;
        Sat, 30 Jul 2022 13:19:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659212369; x=1690748369;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=HNQscSxVnHtVSMnt9pu3ixHp06vIyPJvEDqvB7lVhS0=;
  b=InghIKHgVtToJENQLj06+w+9IYh2Q91lvLOiL0RsQvWLuNLNnJjpEHo7
   LWRi9kR/mc4GskH0VlsN+zRDcvZL9TouENgZxZh6fzdDncfkqQJ+kiDRk
   V7wuvAmAom7Xy6hz6+NyYvJKqyh24POXnQJvEbO+wdcas9tubyjC8/Iuv
   kYNn2siOeg0o9RPxuAm4mibdFBKj8IDKwHmnnl6EbHOa2g/P8ddbEcS92
   5sLCLARsz17PsbZF7vIF1Fxxoiz9ZC0RULz7TgxPH+q17sMmCJPqug1q4
   ubKNGvEhme/CUzWDQqg2+NT6bq0bFb84CB3kALLCrUzBZsahSoFmqX+1e
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10424"; a="314757945"
X-IronPort-AV: E=Sophos;i="5.93,204,1654585200"; 
   d="scan'208";a="314757945"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2022 13:19:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,204,1654585200"; 
   d="scan'208";a="777848531"
Received: from lkp-server01.sh.intel.com (HELO e0eace57cfef) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 30 Jul 2022 13:19:26 -0700
Received: from kbuild by e0eace57cfef with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oHsvm-000DHb-0O;
        Sat, 30 Jul 2022 20:19:26 +0000
Date:   Sun, 31 Jul 2022 04:18:36 +0800
From:   kernel test robot <lkp@intel.com>
To:     Sevinj Aghayeva <sevinj.aghayeva@gmail.com>, aroulin@nvidia.com
Cc:     kbuild-all@lists.01.org, sbrivio@redhat.com, roopa@nvidia.com,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org,
        Sevinj Aghayeva <sevinj.aghayeva@gmail.com>
Subject: Re: [PATCH net-next 2/3] net: 8021q: fix bridge binding behavior for
 vlan interfaces
Message-ID: <202207310426.rj5ZG7FZ-lkp@intel.com>
References: <2b09fbacde7e8818f4ada4829818fdf015e36b58.1659195179.git.sevinj.aghayeva@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2b09fbacde7e8818f4ada4829818fdf015e36b58.1659195179.git.sevinj.aghayeva@gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sevinj,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Sevinj-Aghayeva/net-vlan-fix-bridge-binding-behavior-and-add-selftests/20220731-000455
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 63757225a93353bc2ce4499af5501eabdbbf23f9
config: x86_64-randconfig-a002 (https://download.01.org/0day-ci/archive/20220731/202207310426.rj5ZG7FZ-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-3) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/993166d2a01876dc92807f74b3d72f63d25c8227
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Sevinj-Aghayeva/net-vlan-fix-bridge-binding-behavior-and-add-selftests/20220731-000455
        git checkout 993166d2a01876dc92807f74b3d72f63d25c8227
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   ld: net/8021q/vlan_dev.o: in function `vlan_dev_change_flags':
>> vlan_dev.c:(.text+0xdb2): undefined reference to `br_vlan_upper_change'

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
