Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 323E350FB0F
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 12:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346173AbiDZKkk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 06:40:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349308AbiDZKiq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 06:38:46 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B827D22B0B;
        Tue, 26 Apr 2022 03:24:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650968642; x=1682504642;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=SUcHxR2at58PVF1YYffGQMoKoxwX9Qu0SIOQdjmPd80=;
  b=NUv6YnlmVAdvjFz7iKDNfgg4X6S+0a/xNE4wciMLWrWXmKNMoi3dVnXE
   OOpSoEBb3xsiE37ZNyR62s1gu7oUtPpStlfz+nT/TVI939fJNdQhPYarf
   EFW4J3V0O9drfQa36QdMsjkGISbTYS2JTX5hHcFrz5ZJ2CZX/5EBJzl5T
   f7GqP6hHth5QGhonaHMfQ8VSkTtTxIOMTrqcacPWf/KIQfl8yADu+8GXp
   Exf8ODWsPPrG8KAZVUfQcohkwNJ9hKvbSD+Y38WR9B1ZEDYcVhuA1kvAy
   /dJSI930XhAeQOWORhEoP6cDbPBociJhGlg80FNborE+t/iUqf6B2r7rM
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10328"; a="290673634"
X-IronPort-AV: E=Sophos;i="5.90,290,1643702400"; 
   d="scan'208";a="290673634"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2022 03:24:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,290,1643702400"; 
   d="scan'208";a="558238295"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
  by orsmga007.jf.intel.com with ESMTP; 26 Apr 2022 03:23:56 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1njIMO-0003QK-3z;
        Tue, 26 Apr 2022 10:23:56 +0000
Date:   Tue, 26 Apr 2022 18:23:14 +0800
From:   kernel test robot <lkp@intel.com>
To:     Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>,
        netdev@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        outreachy@lists.linux.dev, roopa@nvidia.com, jdenham@redhat.com,
        sbrivio@redhat.com, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, shshaikh@marvell.com,
        manishc@marvell.com, razor@blackwall.org,
        intel-wired-lan@lists.osuosl.org, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com, GR-Linux-NIC-Dev@marvell.com,
        bridge@lists.linux-foundation.org,
        eng.alaamohamedsoliman.am@gmail.com
Subject: Re: [PATCH net-next v4 1/2] rtnetlink: add extack support in fdb del
 handlers
Message-ID: <202204261831.S6mBmtgP-lkp@intel.com>
References: <8847c5d670c7ee11890d75f58a4922c5cb542f20.1650896000.git.eng.alaamohamedsoliman.am@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8847c5d670c7ee11890d75f58a4922c5cb542f20.1650896000.git.eng.alaamohamedsoliman.am@gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alaa,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on horms-ipvs/master]
[also build test ERROR on net/master linus/master v5.18-rc4]
[cannot apply to net-next/master next-20220422]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Alaa-Mohamed/propagate-extack-to-vxlan_fdb_delete/20220425-222644
base:   https://git.kernel.org/pub/scm/linux/kernel/git/horms/ipvs.git master
config: riscv-randconfig-r002-20220425 (https://download.01.org/0day-ci/archive/20220426/202204261831.S6mBmtgP-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 1cddcfdc3c683b393df1a5c9063252eb60e52818)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install riscv cross compiling tool for clang build
        # apt-get install binutils-riscv64-linux-gnu
        # https://github.com/intel-lab-lkp/linux/commit/5e9c3e146040a4e37b45ca18c3b42c3dfd6d0a0e
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Alaa-Mohamed/propagate-extack-to-vxlan_fdb_delete/20220425-222644
        git checkout 5e9c3e146040a4e37b45ca18c3b42c3dfd6d0a0e
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=riscv SHELL=/bin/bash drivers/net/ethernet/mscc/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> drivers/net/ethernet/mscc/ocelot_net.c:784:70: error: too many arguments to function call, expected 5, have 6
           return ocelot_fdb_del(ocelot, port, addr, vid, ocelot_port->bridge, extack);
                  ~~~~~~~~~~~~~~                                               ^~~~~~
   include/soc/mscc/ocelot.h:893:5: note: 'ocelot_fdb_del' declared here
   int ocelot_fdb_del(struct ocelot *ocelot, int port, const unsigned char *addr,
       ^
   1 error generated.


vim +784 drivers/net/ethernet/mscc/ocelot_net.c

   774	
   775	static int ocelot_port_fdb_del(struct ndmsg *ndm, struct nlattr *tb[],
   776				       struct net_device *dev,
   777				       const unsigned char *addr, u16 vid, struct netlink_ext_ack *extack)
   778	{
   779		struct ocelot_port_private *priv = netdev_priv(dev);
   780		struct ocelot_port *ocelot_port = &priv->port;
   781		struct ocelot *ocelot = ocelot_port->ocelot;
   782		int port = priv->chip_port;
   783	
 > 784		return ocelot_fdb_del(ocelot, port, addr, vid, ocelot_port->bridge, extack);
   785	}
   786	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
