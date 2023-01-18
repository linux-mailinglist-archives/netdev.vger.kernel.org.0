Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27E47672A06
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 22:10:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230446AbjARVKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 16:10:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230445AbjARVKB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 16:10:01 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EA3063E12;
        Wed, 18 Jan 2023 13:09:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674076160; x=1705612160;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=aFZmV5/PJ5rjlHfW0M/ptY8pOy0cNbcqOFnEPik/kHM=;
  b=Bb3gpWhzEaJzWTkYUkQCLjRWo17XdKh5k3c7cCwPSOon5H0WNPZrUfk8
   UWJjZtmT/pprBoutod00oIbvJuM+TaIWO8mcBgxwsixKloLemIfQ9iIFJ
   otYZG3sAQrYPpGYGx/iCSNPUE3l6vE+PcAFOOtjdvvY06vXa7zbOzLcXG
   oHY/uZexr/nutbfa1adSGqQwI7+BtHozM//lQf19wmAF1kzRE4kQFuZmE
   HTq222kum88vZ4Iyin89qm80fENNIKI3Dp48tN6jJ52s/Xl9GOwtLElIp
   jFv60eTmPMUoQ5v7mRst/pgEFRxELorYIzzcG+SegNc3Z+CgrCesXWT1C
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="411341456"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="411341456"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2023 13:09:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="783823051"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="783823051"
Received: from lkp-server01.sh.intel.com (HELO 5646d64e7320) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 18 Jan 2023 13:09:14 -0800
Received: from kbuild by 5646d64e7320 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pIFgH-0000iv-2b;
        Wed, 18 Jan 2023 21:09:13 +0000
Date:   Thu, 19 Jan 2023 05:08:47 +0800
From:   kernel test robot <lkp@intel.com>
To:     Francesco Dolcini <francesco@dolcini.it>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     oe-kbuild-all@lists.linux.dev,
        Stefan Eichenberger <stefan.eichenberger@toradex.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Francesco Dolcini <francesco.dolcini@toradex.com>
Subject: Re: [PATCH v1 3/4] Bluetooth: hci_mrvl: Add serdev support for
 88W8997
Message-ID: <202301190442.n6v4c2yc-lkp@intel.com>
References: <20230118122817.42466-4-francesco@dolcini.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230118122817.42466-4-francesco@dolcini.it>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Francesco,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on robh/for-next]
[also build test WARNING on bluetooth-next/master bluetooth/master horms-ipvs/master net/master net-next/master linus/master v6.2-rc4 next-20230118]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Francesco-Dolcini/dt-bindings-bluetooth-marvell-add-88W8997-DT-binding/20230118-210919
base:   https://git.kernel.org/pub/scm/linux/kernel/git/robh/linux.git for-next
patch link:    https://lore.kernel.org/r/20230118122817.42466-4-francesco%40dolcini.it
patch subject: [PATCH v1 3/4] Bluetooth: hci_mrvl: Add serdev support for 88W8997
config: i386-randconfig-s002 (https://download.01.org/0day-ci/archive/20230119/202301190442.n6v4c2yc-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-8) 11.3.0
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.4-39-gce1a6720-dirty
        # https://github.com/intel-lab-lkp/linux/commit/2ae116c8ad209e0bf11559519915e511c44c28be
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Francesco-Dolcini/dt-bindings-bluetooth-marvell-add-88W8997-DT-binding/20230118-210919
        git checkout 2ae116c8ad209e0bf11559519915e511c44c28be
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=i386 olddefconfig
        make W=1 C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=i386 SHELL=/bin/bash drivers/bluetooth/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> drivers/bluetooth/hci_mrvl.c:450:36: warning: 'mrvl_proto_8997' defined but not used [-Wunused-const-variable=]
     450 | static const struct hci_uart_proto mrvl_proto_8997 = {
         |                                    ^~~~~~~~~~~~~~~


vim +/mrvl_proto_8997 +450 drivers/bluetooth/hci_mrvl.c

   449	
 > 450	static const struct hci_uart_proto mrvl_proto_8997 = {
   451		.id		= HCI_UART_MRVL,
   452		.name		= "Marvell 8997",
   453		.init_speed	= 115200,
   454		.oper_speed	= 3000000,
   455		.open		= mrvl_open,
   456		.close		= mrvl_close,
   457		.flush		= mrvl_flush,
   458		.set_baudrate   = mrvl_set_baudrate,
   459		.recv		= mrvl_recv,
   460		.enqueue	= mrvl_enqueue,
   461		.dequeue	= mrvl_dequeue,
   462	};
   463	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
