Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67D586AAA7C
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 15:45:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbjCDOpC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Mar 2023 09:45:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjCDOpB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Mar 2023 09:45:01 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BDC212581
        for <netdev@vger.kernel.org>; Sat,  4 Mar 2023 06:44:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677941099; x=1709477099;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ZWtwk+hsrbuV9O0Uq57xu9eEX64afxZg3rDNIoN3JP4=;
  b=XtboCIa4n81gKJjglf/DvRH7jO3CZrjCHkYL0VJFuxWUrIELoygUE46T
   y17DKhe4lSE1+mmO9MQAQJ3jY4am2yZyDDKpSaGMvHxFrUa1/vfHpuud+
   T+MN7LBzCD+8ryryhQinUe/SI2pmh0oc3ZhHMbBy/sVw431AjlYsAf9ct
   dXfgW0QMgylC41wfPw3AeLbVtOP1i6jq3WNqpASi9rBoVz1AQXxM/q5of
   DGOE/6lewNhyQzvSL0qC12xqOiHf13vlU8ihMf7WhIpjK4hMjmVVlTFcN
   cxOCl97qX72DVOWkigSrBhJkb7w+45gvuZ6xr4kJhRjtN6U4IMRTU1CYX
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10639"; a="315660857"
X-IronPort-AV: E=Sophos;i="5.98,233,1673942400"; 
   d="scan'208";a="315660857"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2023 06:44:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10639"; a="708158283"
X-IronPort-AV: E=Sophos;i="5.98,233,1673942400"; 
   d="scan'208";a="708158283"
Received: from lkp-server01.sh.intel.com (HELO 776573491cc5) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 04 Mar 2023 06:44:56 -0800
Received: from kbuild by 776573491cc5 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pYT83-0002Dg-0H;
        Sat, 04 Mar 2023 14:44:55 +0000
Date:   Sat, 4 Mar 2023 22:44:16 +0800
From:   kernel test robot <lkp@intel.com>
To:     Vincenzo Palazzo <vincenzopalazzodev@gmail.com>,
        netdev@vger.kernel.org
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        davem@davemloft.net, intel-wired-lan@lists.osuosl.org,
        jesse.brandeburg@intel.com, khc@pm.waw.pl,
        Vincenzo Palazzo <vincenzopalazzodev@gmail.com>,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v3] netdevice: use ifmap instead of plain fields
Message-ID: <202303042251.hzk9MHP0-lkp@intel.com>
References: <20230304115626.215026-1-vincenzopalazzodev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230304115626.215026-1-vincenzopalazzodev@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vincenzo,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on net/master]
[also build test ERROR on net-next/master horms-ipvs/master linus/master v6.2 next-20230303]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Vincenzo-Palazzo/netdevice-use-ifmap-instead-of-plain-fields/20230304-195731
patch link:    https://lore.kernel.org/r/20230304115626.215026-1-vincenzopalazzodev%40gmail.com
patch subject: [PATCH v3] netdevice: use ifmap instead of plain fields
config: mips-randconfig-r034-20230302 (https://download.01.org/0day-ci/archive/20230304/202303042251.hzk9MHP0-lkp@intel.com/config)
compiler: clang version 17.0.0 (https://github.com/llvm/llvm-project 67409911353323ca5edf2049ef0df54132fa1ca7)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install mips cross compiling tool for clang build
        # apt-get install binutils-mips-linux-gnu
        # https://github.com/intel-lab-lkp/linux/commit/89e04810927e646944e5cdd83fb9bb5a41cc5a3d
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Vincenzo-Palazzo/netdevice-use-ifmap-instead-of-plain-fields/20230304-195731
        git checkout 89e04810927e646944e5cdd83fb9bb5a41cc5a3d
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=mips olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=mips SHELL=/bin/bash drivers/net/hamradio/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303042251.hzk9MHP0-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/net/hamradio/baycom_epp.c:818:53: error: no member named 'base_addr' in 'struct net_device'
           struct parport *pp = parport_find_base(dev->base_addr);
                                                  ~~~  ^
   drivers/net/hamradio/baycom_epp.c:826:84: error: no member named 'base_addr' in 'struct net_device'
                   printk(KERN_ERR "%s: parport at 0x%lx unknown\n", bc_drvname, dev->base_addr);
                                                                                 ~~~  ^
   include/linux/printk.h:455:60: note: expanded from macro 'printk'
   #define printk(fmt, ...) printk_index_wrap(_printk, fmt, ##__VA_ARGS__)
                                                              ^~~~~~~~~~~
   include/linux/printk.h:427:19: note: expanded from macro 'printk_index_wrap'
                   _p_func(_fmt, ##__VA_ARGS__);                           \
                                   ^~~~~~~~~~~
   drivers/net/hamradio/baycom_epp.c:961:26: error: no member named 'base_addr' in 'struct net_device'
                  bc_drvname, dev->base_addr, dev->irq);
                              ~~~  ^
   include/linux/printk.h:455:60: note: expanded from macro 'printk'
   #define printk(fmt, ...) printk_index_wrap(_printk, fmt, ##__VA_ARGS__)
                                                              ^~~~~~~~~~~
   include/linux/printk.h:427:19: note: expanded from macro 'printk_index_wrap'
                   _p_func(_fmt, ##__VA_ARGS__);                           \
                                   ^~~~~~~~~~~
   drivers/net/hamradio/baycom_epp.c:1037:28: error: no member named 'base_addr' in 'struct net_device'
                   hi.data.mp.iobase = dev->base_addr;
                                       ~~~  ^
   drivers/net/hamradio/baycom_epp.c:1049:8: error: no member named 'base_addr' in 'struct net_device'
                   dev->base_addr = hi.data.mp.iobase;
                   ~~~  ^
   drivers/net/hamradio/baycom_epp.c:1242:8: error: no member named 'base_addr' in 'struct net_device'
                   dev->base_addr = iobase[i];
                   ~~~  ^
   6 errors generated.


vim +818 drivers/net/hamradio/baycom_epp.c

^1da177e4c3f41 Linus Torvalds         2005-04-16  805  
^1da177e4c3f41 Linus Torvalds         2005-04-16  806  /*
^1da177e4c3f41 Linus Torvalds         2005-04-16  807   * Open/initialize the board. This is called (in the current kernel)
^1da177e4c3f41 Linus Torvalds         2005-04-16  808   * sometime after booting when the 'ifconfig' program is run.
^1da177e4c3f41 Linus Torvalds         2005-04-16  809   *
^1da177e4c3f41 Linus Torvalds         2005-04-16  810   * This routine should set everything up anew at each open, even
^1da177e4c3f41 Linus Torvalds         2005-04-16  811   * registers that "should" only need to be set once at boot, so that
^1da177e4c3f41 Linus Torvalds         2005-04-16  812   * there is non-reboot way to recover if something goes wrong.
^1da177e4c3f41 Linus Torvalds         2005-04-16  813   */
^1da177e4c3f41 Linus Torvalds         2005-04-16  814  
^1da177e4c3f41 Linus Torvalds         2005-04-16  815  static int epp_open(struct net_device *dev)
^1da177e4c3f41 Linus Torvalds         2005-04-16  816  {
^1da177e4c3f41 Linus Torvalds         2005-04-16  817  	struct baycom_state *bc = netdev_priv(dev);
^1da177e4c3f41 Linus Torvalds         2005-04-16 @818          struct parport *pp = parport_find_base(dev->base_addr);
^1da177e4c3f41 Linus Torvalds         2005-04-16  819  	unsigned int i, j;
^1da177e4c3f41 Linus Torvalds         2005-04-16  820  	unsigned char tmp[128];
^1da177e4c3f41 Linus Torvalds         2005-04-16  821  	unsigned char stat;
^1da177e4c3f41 Linus Torvalds         2005-04-16  822  	unsigned long tstart;
ca444073a2de97 Sudip Mukherjee        2017-09-17  823  	struct pardev_cb par_cb;
^1da177e4c3f41 Linus Torvalds         2005-04-16  824  	
^1da177e4c3f41 Linus Torvalds         2005-04-16  825          if (!pp) {
^1da177e4c3f41 Linus Torvalds         2005-04-16  826                  printk(KERN_ERR "%s: parport at 0x%lx unknown\n", bc_drvname, dev->base_addr);
^1da177e4c3f41 Linus Torvalds         2005-04-16  827                  return -ENXIO;
^1da177e4c3f41 Linus Torvalds         2005-04-16  828          }
^1da177e4c3f41 Linus Torvalds         2005-04-16  829  #if 0
^1da177e4c3f41 Linus Torvalds         2005-04-16  830          if (pp->irq < 0) {
^1da177e4c3f41 Linus Torvalds         2005-04-16  831                  printk(KERN_ERR "%s: parport at 0x%lx has no irq\n", bc_drvname, pp->base);
^1da177e4c3f41 Linus Torvalds         2005-04-16  832  		parport_put_port(pp);
^1da177e4c3f41 Linus Torvalds         2005-04-16  833                  return -ENXIO;
^1da177e4c3f41 Linus Torvalds         2005-04-16  834          }
^1da177e4c3f41 Linus Torvalds         2005-04-16  835  #endif
^1da177e4c3f41 Linus Torvalds         2005-04-16  836  	if ((~pp->modes) & (PARPORT_MODE_TRISTATE | PARPORT_MODE_PCSPP | PARPORT_MODE_SAFEININT)) {
^1da177e4c3f41 Linus Torvalds         2005-04-16  837                  printk(KERN_ERR "%s: parport at 0x%lx cannot be used\n",
^1da177e4c3f41 Linus Torvalds         2005-04-16  838  		       bc_drvname, pp->base);
^1da177e4c3f41 Linus Torvalds         2005-04-16  839  		parport_put_port(pp);
^1da177e4c3f41 Linus Torvalds         2005-04-16  840                  return -EIO;
^1da177e4c3f41 Linus Torvalds         2005-04-16  841  	}
^1da177e4c3f41 Linus Torvalds         2005-04-16  842  	memset(&bc->modem, 0, sizeof(bc->modem));
ca444073a2de97 Sudip Mukherjee        2017-09-17  843  	memset(&par_cb, 0, sizeof(par_cb));
ca444073a2de97 Sudip Mukherjee        2017-09-17  844  	par_cb.wakeup = epp_wakeup;
ca444073a2de97 Sudip Mukherjee        2017-09-17  845  	par_cb.private = (void *)dev;
ca444073a2de97 Sudip Mukherjee        2017-09-17  846  	par_cb.flags = PARPORT_DEV_EXCL;
ca444073a2de97 Sudip Mukherjee        2017-09-17  847  	for (i = 0; i < NR_PORTS; i++)
ca444073a2de97 Sudip Mukherjee        2017-09-17  848  		if (baycom_device[i] == dev)
ca444073a2de97 Sudip Mukherjee        2017-09-17  849  			break;
ca444073a2de97 Sudip Mukherjee        2017-09-17  850  
ca444073a2de97 Sudip Mukherjee        2017-09-17  851  	if (i == NR_PORTS) {
ca444073a2de97 Sudip Mukherjee        2017-09-17  852  		pr_err("%s: no device found\n", bc_drvname);
ca444073a2de97 Sudip Mukherjee        2017-09-17  853  		parport_put_port(pp);
ca444073a2de97 Sudip Mukherjee        2017-09-17  854  		return -ENODEV;
ca444073a2de97 Sudip Mukherjee        2017-09-17  855  	}
ca444073a2de97 Sudip Mukherjee        2017-09-17  856  
ca444073a2de97 Sudip Mukherjee        2017-09-17  857  	bc->pdev = parport_register_dev_model(pp, dev->name, &par_cb, i);
^1da177e4c3f41 Linus Torvalds         2005-04-16  858  	parport_put_port(pp);
^1da177e4c3f41 Linus Torvalds         2005-04-16  859          if (!bc->pdev) {
^1da177e4c3f41 Linus Torvalds         2005-04-16  860                  printk(KERN_ERR "%s: cannot register parport at 0x%lx\n", bc_drvname, pp->base);
^1da177e4c3f41 Linus Torvalds         2005-04-16  861                  return -ENXIO;
^1da177e4c3f41 Linus Torvalds         2005-04-16  862          }
^1da177e4c3f41 Linus Torvalds         2005-04-16  863          if (parport_claim(bc->pdev)) {
^1da177e4c3f41 Linus Torvalds         2005-04-16  864                  printk(KERN_ERR "%s: parport at 0x%lx busy\n", bc_drvname, pp->base);
^1da177e4c3f41 Linus Torvalds         2005-04-16  865                  parport_unregister_device(bc->pdev);
^1da177e4c3f41 Linus Torvalds         2005-04-16  866                  return -EBUSY;
^1da177e4c3f41 Linus Torvalds         2005-04-16  867          }
^1da177e4c3f41 Linus Torvalds         2005-04-16  868          dev->irq = /*pp->irq*/ 0;
c4028958b6ecad David Howells          2006-11-22  869  	INIT_DELAYED_WORK(&bc->run_work, epp_bh);
^1da177e4c3f41 Linus Torvalds         2005-04-16  870  	bc->work_running = 1;
^1da177e4c3f41 Linus Torvalds         2005-04-16  871  	bc->modem = EPP_CONVENTIONAL;
^1da177e4c3f41 Linus Torvalds         2005-04-16  872  	if (eppconfig(bc))
^1da177e4c3f41 Linus Torvalds         2005-04-16  873  		printk(KERN_INFO "%s: no FPGA detected, assuming conventional EPP modem\n", bc_drvname);
^1da177e4c3f41 Linus Torvalds         2005-04-16  874  	else
^1da177e4c3f41 Linus Torvalds         2005-04-16  875  		bc->modem = /*EPP_FPGA*/ EPP_FPGAEXTSTATUS;
^1da177e4c3f41 Linus Torvalds         2005-04-16  876  	parport_write_control(pp, LPTCTRL_PROGRAM); /* prepare EPP mode; we aren't using interrupts */
^1da177e4c3f41 Linus Torvalds         2005-04-16  877  	/* reset the modem */
^1da177e4c3f41 Linus Torvalds         2005-04-16  878  	tmp[0] = 0;
^1da177e4c3f41 Linus Torvalds         2005-04-16  879  	tmp[1] = EPP_TX_FIFO_ENABLE|EPP_RX_FIFO_ENABLE|EPP_MODEM_ENABLE;
^1da177e4c3f41 Linus Torvalds         2005-04-16  880  	if (pp->ops->epp_write_addr(pp, tmp, 2, 0) != 2)
^1da177e4c3f41 Linus Torvalds         2005-04-16  881  		goto epptimeout;
^1da177e4c3f41 Linus Torvalds         2005-04-16  882  	/* autoprobe baud rate */
^1da177e4c3f41 Linus Torvalds         2005-04-16  883  	tstart = jiffies;
^1da177e4c3f41 Linus Torvalds         2005-04-16  884  	i = 0;
ff5688ae1cedfb Marcelo Feitoza Parisi 2006-01-09  885  	while (time_before(jiffies, tstart + HZ/3)) {
^1da177e4c3f41 Linus Torvalds         2005-04-16  886  		if (pp->ops->epp_read_addr(pp, &stat, 1, 0) != 1)
^1da177e4c3f41 Linus Torvalds         2005-04-16  887  			goto epptimeout;
^1da177e4c3f41 Linus Torvalds         2005-04-16  888  		if ((stat & (EPP_NRAEF|EPP_NRHF)) == EPP_NRHF) {
^1da177e4c3f41 Linus Torvalds         2005-04-16  889  			schedule();
^1da177e4c3f41 Linus Torvalds         2005-04-16  890  			continue;
^1da177e4c3f41 Linus Torvalds         2005-04-16  891  		}
^1da177e4c3f41 Linus Torvalds         2005-04-16  892  		if (pp->ops->epp_read_data(pp, tmp, 128, 0) != 128)
^1da177e4c3f41 Linus Torvalds         2005-04-16  893  			goto epptimeout;
^1da177e4c3f41 Linus Torvalds         2005-04-16  894  		if (pp->ops->epp_read_data(pp, tmp, 128, 0) != 128)
^1da177e4c3f41 Linus Torvalds         2005-04-16  895  			goto epptimeout;
^1da177e4c3f41 Linus Torvalds         2005-04-16  896  		i += 256;
^1da177e4c3f41 Linus Torvalds         2005-04-16  897  	}
^1da177e4c3f41 Linus Torvalds         2005-04-16  898  	for (j = 0; j < 256; j++) {
^1da177e4c3f41 Linus Torvalds         2005-04-16  899  		if (pp->ops->epp_read_addr(pp, &stat, 1, 0) != 1)
^1da177e4c3f41 Linus Torvalds         2005-04-16  900  			goto epptimeout;
^1da177e4c3f41 Linus Torvalds         2005-04-16  901  		if (!(stat & EPP_NREF))
^1da177e4c3f41 Linus Torvalds         2005-04-16  902  			break;
^1da177e4c3f41 Linus Torvalds         2005-04-16  903  		if (pp->ops->epp_read_data(pp, tmp, 1, 0) != 1)
^1da177e4c3f41 Linus Torvalds         2005-04-16  904  			goto epptimeout;
^1da177e4c3f41 Linus Torvalds         2005-04-16  905  		i++;
^1da177e4c3f41 Linus Torvalds         2005-04-16  906  	}
^1da177e4c3f41 Linus Torvalds         2005-04-16  907  	tstart = jiffies - tstart;
^1da177e4c3f41 Linus Torvalds         2005-04-16  908  	bc->bitrate = i * (8 * HZ) / tstart;
^1da177e4c3f41 Linus Torvalds         2005-04-16  909  	j = 1;
^1da177e4c3f41 Linus Torvalds         2005-04-16  910  	i = bc->bitrate >> 3;
^1da177e4c3f41 Linus Torvalds         2005-04-16  911  	while (j < 7 && i > 150) {
^1da177e4c3f41 Linus Torvalds         2005-04-16  912  		j++;
^1da177e4c3f41 Linus Torvalds         2005-04-16  913  		i >>= 1;
^1da177e4c3f41 Linus Torvalds         2005-04-16  914  	}
^1da177e4c3f41 Linus Torvalds         2005-04-16  915  	printk(KERN_INFO "%s: autoprobed bitrate: %d  int divider: %d  int rate: %d\n", 
^1da177e4c3f41 Linus Torvalds         2005-04-16  916  	       bc_drvname, bc->bitrate, j, bc->bitrate >> (j+2));
^1da177e4c3f41 Linus Torvalds         2005-04-16  917  	tmp[0] = EPP_TX_FIFO_ENABLE|EPP_RX_FIFO_ENABLE|EPP_MODEM_ENABLE/*|j*/;
^1da177e4c3f41 Linus Torvalds         2005-04-16  918  	if (pp->ops->epp_write_addr(pp, tmp, 1, 0) != 1)
^1da177e4c3f41 Linus Torvalds         2005-04-16  919  		goto epptimeout;
^1da177e4c3f41 Linus Torvalds         2005-04-16  920  	/*
^1da177e4c3f41 Linus Torvalds         2005-04-16  921  	 * initialise hdlc variables
^1da177e4c3f41 Linus Torvalds         2005-04-16  922  	 */
^1da177e4c3f41 Linus Torvalds         2005-04-16  923  	bc->hdlcrx.state = 0;
^1da177e4c3f41 Linus Torvalds         2005-04-16  924  	bc->hdlcrx.numbits = 0;
^1da177e4c3f41 Linus Torvalds         2005-04-16  925  	bc->hdlctx.state = tx_idle;
^1da177e4c3f41 Linus Torvalds         2005-04-16  926  	bc->hdlctx.bufcnt = 0;
^1da177e4c3f41 Linus Torvalds         2005-04-16  927  	bc->hdlctx.slotcnt = bc->ch_params.slottime;
^1da177e4c3f41 Linus Torvalds         2005-04-16  928  	bc->hdlctx.calibrate = 0;
^1da177e4c3f41 Linus Torvalds         2005-04-16  929  	/* start the bottom half stuff */
^1da177e4c3f41 Linus Torvalds         2005-04-16  930  	schedule_delayed_work(&bc->run_work, 1);
^1da177e4c3f41 Linus Torvalds         2005-04-16  931  	netif_start_queue(dev);
^1da177e4c3f41 Linus Torvalds         2005-04-16  932  	return 0;
^1da177e4c3f41 Linus Torvalds         2005-04-16  933  
^1da177e4c3f41 Linus Torvalds         2005-04-16  934   epptimeout:
^1da177e4c3f41 Linus Torvalds         2005-04-16  935  	printk(KERN_ERR "%s: epp timeout during bitrate probe\n", bc_drvname);
^1da177e4c3f41 Linus Torvalds         2005-04-16  936  	parport_write_control(pp, 0); /* reset the adapter */
^1da177e4c3f41 Linus Torvalds         2005-04-16  937          parport_release(bc->pdev);
^1da177e4c3f41 Linus Torvalds         2005-04-16  938          parport_unregister_device(bc->pdev);
^1da177e4c3f41 Linus Torvalds         2005-04-16  939  	return -EIO;
^1da177e4c3f41 Linus Torvalds         2005-04-16  940  }
^1da177e4c3f41 Linus Torvalds         2005-04-16  941  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
