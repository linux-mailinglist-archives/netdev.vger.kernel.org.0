Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A5504C8920
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 11:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233620AbiCAKVC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 05:21:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231678AbiCAKVB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 05:21:01 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0144349F1B;
        Tue,  1 Mar 2022 02:20:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646130021; x=1677666021;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=0eY4zn4pc+vtCu2Xj5DMz6jR8t4IQ6TDuDN/OXFaE30=;
  b=CiZ1VpmI8hbbNqQUxrADj5hwnP4+scLVV9n2gWTpxBxjHACFrUvQgDrA
   AVtVHaLFFGnMlcYUKy6nz0NPq3OcpMSB2PLyehDKaZMS5i6F6upa+gc1Z
   uP84jMpe+BmVQmVm57C+aISbOGo1XiXcIUOd7q0wY5qCKp1+f6KJA60bQ
   8Bpi6PTxn4HSMKqmkl0yeltWaHH6lMfa5/NOxk/xqhFumTv8OSs0uF5jK
   vr+6RzJBMjT9LTgszZLoKv00fgx928BwJ4W675G3HPAwlM/8WcA0yjs5+
   l89zK7PLrC5ggfg08bxHcbDB5jpnFGtKXU/n1GMN3A3sa1q8kWVQQFX8W
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10272"; a="253032648"
X-IronPort-AV: E=Sophos;i="5.90,145,1643702400"; 
   d="scan'208";a="253032648"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2022 02:20:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,145,1643702400"; 
   d="scan'208";a="507751717"
Received: from lkp-server01.sh.intel.com (HELO 2146afe809fb) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 01 Mar 2022 02:20:16 -0800
Received: from kbuild by 2146afe809fb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nOzc6-0000Ha-Rz; Tue, 01 Mar 2022 10:20:14 +0000
Date:   Tue, 1 Mar 2022 18:19:11 +0800
From:   kernel test robot <lkp@intel.com>
To:     Veerasenareddy Burru <vburru@marvell.com>, davem@davemloft.net,
        kuba@kernel.org, corbet@lwn.net, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Abhijit Ayarekar <aayarekar@marvell.com>,
        Satananda Burla <sburla@marvell.com>
Subject: Re: [PATCH v2 6/7] octeon_ep: add Tx/Rx processing and interrupt
 support
Message-ID: <202203011844.8vlB6VII-lkp@intel.com>
References: <20220301050359.19374-7-vburru@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220301050359.19374-7-vburru@marvell.com>
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

I love your patch! Perhaps something to improve:

[auto build test WARNING on linus/master]
[also build test WARNING on v5.17-rc6 next-20220228]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Veerasenareddy-Burru/Add-octeon_ep-driver/20220301-130525
base:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git 719fce7539cd3e186598e2aed36325fe892150cf
config: alpha-allyesconfig (https://download.01.org/0day-ci/archive/20220301/202203011844.8vlB6VII-lkp@intel.com/config)
compiler: alpha-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/e0d69d884293634bda9cacbf722024931c0194f2
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Veerasenareddy-Burru/Add-octeon_ep-driver/20220301-130525
        git checkout e0d69d884293634bda9cacbf722024931c0194f2
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=alpha SHELL=/bin/bash drivers/net/ethernet/marvell/octeon_ep/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   drivers/net/ethernet/marvell/octeon_ep/octep_main.c: In function 'octep_alloc_ioq_vectors':
   drivers/net/ethernet/marvell/octeon_ep/octep_main.c:53:38: error: implicit declaration of function 'vzalloc'; did you mean 'kvzalloc'? [-Werror=implicit-function-declaration]
      53 |                 oct->ioq_vector[i] = vzalloc(sizeof(*oct->ioq_vector[i]));
         |                                      ^~~~~~~
         |                                      kvzalloc
>> drivers/net/ethernet/marvell/octeon_ep/octep_main.c:53:36: warning: assignment to 'struct octep_ioq_vector *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
      53 |                 oct->ioq_vector[i] = vzalloc(sizeof(*oct->ioq_vector[i]));
         |                                    ^
   drivers/net/ethernet/marvell/octeon_ep/octep_main.c:69:17: error: implicit declaration of function 'vfree'; did you mean 'kvfree'? [-Werror=implicit-function-declaration]
      69 |                 vfree(oct->ioq_vector[i]);
         |                 ^~~~~
         |                 kvfree
   cc1: some warnings being treated as errors


vim +53 drivers/net/ethernet/marvell/octeon_ep/octep_main.c

    33	
    34	/**
    35	 * octep_alloc_ioq_vectors() - Allocate Tx/Rx Queue interrupt info.
    36	 *
    37	 * @oct: Octeon device private data structure.
    38	 *
    39	 * Allocate resources to hold per Tx/Rx queue interrupt info.
    40	 * This is the information passed to interrupt handler, from which napi poll
    41	 * is scheduled and includes quick access to private data of Tx/Rx queue
    42	 * corresponding to the interrupt being handled.
    43	 *
    44	 * Return: 0, on successful allocation of resources for all queue interrupts.
    45	 *         -1, if failed to allocate any resource.
    46	 */
    47	static int octep_alloc_ioq_vectors(struct octep_device *oct)
    48	{
    49		int i;
    50		struct octep_ioq_vector *ioq_vector;
    51	
    52		for (i = 0; i < oct->num_oqs; i++) {
  > 53			oct->ioq_vector[i] = vzalloc(sizeof(*oct->ioq_vector[i]));
    54			if (!oct->ioq_vector[i])
    55				goto free_ioq_vector;
    56	
    57			ioq_vector = oct->ioq_vector[i];
    58			ioq_vector->iq = oct->iq[i];
    59			ioq_vector->oq = oct->oq[i];
    60			ioq_vector->octep_dev = oct;
    61		}
    62	
    63		dev_info(&oct->pdev->dev, "Allocated %d IOQ vectors\n", oct->num_oqs);
    64		return 0;
    65	
    66	free_ioq_vector:
    67		while (i) {
    68			i--;
    69			vfree(oct->ioq_vector[i]);
    70			oct->ioq_vector[i] = NULL;
    71		}
    72		return -1;
    73	}
    74	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
