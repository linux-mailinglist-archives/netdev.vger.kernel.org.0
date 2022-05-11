Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3383C523F0A
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 22:44:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347870AbiEKUo1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 16:44:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242188AbiEKUoZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 16:44:25 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ED8416D5EC;
        Wed, 11 May 2022 13:44:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652301863; x=1683837863;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=DhBsQKPFvNppevZbx5OxSYuIu8dvRbDM3tm9jFewAR0=;
  b=YsIQ328MrYzCVK5/fqDIiRpKukkrGDiWTEhxPWixrPqNqr+RirbIKykm
   cPIwUyWKjRx6zfLZIXMn7dpK7u/kRoG/cQ6f+tOxscbqj2/rYsR7GETMh
   qK1dTUVJxKIXVSYjAzAHlLsY9KXebVGmPRE4vbUCn8Vfp3ph/MGPYuQYX
   UXHHznW4nUDLPuIxoi8nCaPdOb3UaeOv+0B52tZfyEzmW8CZDh5AF9dwG
   WLOjrn/TJmMlsHiF7EWmEVl+kFX9KLQUDp6eUHxuydqggJSaSGOrEIs3D
   1gISM5PNps+IqoGk3jyeTP0AwZ8ZAmGgRZtatf1JDcNR3lg6NNXKOfiAK
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10344"; a="257358904"
X-IronPort-AV: E=Sophos;i="5.91,218,1647327600"; 
   d="scan'208";a="257358904"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2022 13:44:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,218,1647327600"; 
   d="scan'208";a="603086242"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 11 May 2022 13:44:19 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1notBz-000JYj-3P;
        Wed, 11 May 2022 20:44:19 +0000
Date:   Thu, 12 May 2022 04:43:49 +0800
From:   kernel test robot <lkp@intel.com>
To:     Bernard Zhao <zhaojunkui2008@126.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Stefan =?iso-8859-1?Q?M=E4tje?= <stefan.maetje@esd.eu>,
        linux-can@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        netdev@vger.kernel.org, bernard@vivo.com
Subject: Re: [PATCH v2] usb/peak_usb: cleanup code
Message-ID: <202205120402.hmn6WJGb-lkp@intel.com>
References: <20220511130240.790771-1-zhaojunkui2008@126.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220511130240.790771-1-zhaojunkui2008@126.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Bernard,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on mkl-can-next/testing]
[also build test ERROR on v5.18-rc6 next-20220511]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Bernard-Zhao/usb-peak_usb-cleanup-code/20220511-210544
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git testing
config: hexagon-randconfig-r023-20220509 (https://download.01.org/0day-ci/archive/20220512/202205120402.hmn6WJGb-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 18dd123c56754edf62c7042dcf23185c3727610f)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/126e94285ae6302c0b5ef6ec5174ebc2685ff220
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Bernard-Zhao/usb-peak_usb-cleanup-code/20220511-210544
        git checkout 126e94285ae6302c0b5ef6ec5174ebc2685ff220
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=hexagon SHELL=/bin/bash drivers/net/can/usb/peak_usb/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> drivers/net/can/usb/peak_usb/pcan_usb_pro.c:914:8: error: use of undeclared identifier 'bi'
           kfree(bi);
                 ^
>> drivers/net/can/usb/peak_usb/pcan_usb_pro.c:915:8: error: use of undeclared identifier 'fi'
           kfree(fi);
                 ^
   2 errors generated.


vim +/bi +914 drivers/net/can/usb/peak_usb/pcan_usb_pro.c

d8a199355f8f8a Stephane Grosjean 2012-03-02  843  
126e94285ae630 Bernard Zhao      2022-05-11  844  static int pcan_usb_pro_init_first_channel(struct peak_usb_device *dev, struct pcan_usb_pro_interface **usb_if)
d8a199355f8f8a Stephane Grosjean 2012-03-02  845  {
126e94285ae630 Bernard Zhao      2022-05-11  846  	struct pcan_usb_pro_interface *pusb_if = NULL;
f14e22435a27ef Marc Kleine-Budde 2013-05-16  847  	int err;
d8a199355f8f8a Stephane Grosjean 2012-03-02  848  
d8a199355f8f8a Stephane Grosjean 2012-03-02  849  	/* do this for 1st channel only */
d8a199355f8f8a Stephane Grosjean 2012-03-02  850  	if (!dev->prev_siblings) {
126e94285ae630 Bernard Zhao      2022-05-11  851  		struct pcan_usb_pro_fwinfo *fi = NULL;
126e94285ae630 Bernard Zhao      2022-05-11  852  		struct pcan_usb_pro_blinfo *bi = NULL;
126e94285ae630 Bernard Zhao      2022-05-11  853  
d8a199355f8f8a Stephane Grosjean 2012-03-02  854  		/* allocate netdevices common structure attached to first one */
126e94285ae630 Bernard Zhao      2022-05-11  855  		pusb_if = kzalloc(sizeof(struct pcan_usb_pro_interface),
d8a199355f8f8a Stephane Grosjean 2012-03-02  856  				 GFP_KERNEL);
f14e22435a27ef Marc Kleine-Budde 2013-05-16  857  		fi = kmalloc(sizeof(struct pcan_usb_pro_fwinfo), GFP_KERNEL);
f14e22435a27ef Marc Kleine-Budde 2013-05-16  858  		bi = kmalloc(sizeof(struct pcan_usb_pro_blinfo), GFP_KERNEL);
126e94285ae630 Bernard Zhao      2022-05-11  859  		if (!pusb_if || !fi || !bi) {
f14e22435a27ef Marc Kleine-Budde 2013-05-16  860  			err = -ENOMEM;
f14e22435a27ef Marc Kleine-Budde 2013-05-16  861  			goto err_out;
f14e22435a27ef Marc Kleine-Budde 2013-05-16  862  		}
d8a199355f8f8a Stephane Grosjean 2012-03-02  863  
d8a199355f8f8a Stephane Grosjean 2012-03-02  864  		/* number of ts msgs to ignore before taking one into account */
126e94285ae630 Bernard Zhao      2022-05-11  865  		pusb_if->cm_ignore_count = 5;
d8a199355f8f8a Stephane Grosjean 2012-03-02  866  
d8a199355f8f8a Stephane Grosjean 2012-03-02  867  		/*
d8a199355f8f8a Stephane Grosjean 2012-03-02  868  		 * explicit use of dev_xxx() instead of netdev_xxx() here:
d8a199355f8f8a Stephane Grosjean 2012-03-02  869  		 * information displayed are related to the device itself, not
d8a199355f8f8a Stephane Grosjean 2012-03-02  870  		 * to the canx netdevices.
d8a199355f8f8a Stephane Grosjean 2012-03-02  871  		 */
d8a199355f8f8a Stephane Grosjean 2012-03-02  872  		err = pcan_usb_pro_send_req(dev, PCAN_USBPRO_REQ_INFO,
d8a199355f8f8a Stephane Grosjean 2012-03-02  873  					    PCAN_USBPRO_INFO_FW,
f14e22435a27ef Marc Kleine-Budde 2013-05-16  874  					    fi, sizeof(*fi));
d8a199355f8f8a Stephane Grosjean 2012-03-02  875  		if (err) {
d8a199355f8f8a Stephane Grosjean 2012-03-02  876  			dev_err(dev->netdev->dev.parent,
d8a199355f8f8a Stephane Grosjean 2012-03-02  877  				"unable to read %s firmware info (err %d)\n",
d8a199355f8f8a Stephane Grosjean 2012-03-02  878  				pcan_usb_pro.name, err);
f14e22435a27ef Marc Kleine-Budde 2013-05-16  879  			goto err_out;
d8a199355f8f8a Stephane Grosjean 2012-03-02  880  		}
d8a199355f8f8a Stephane Grosjean 2012-03-02  881  
d8a199355f8f8a Stephane Grosjean 2012-03-02  882  		err = pcan_usb_pro_send_req(dev, PCAN_USBPRO_REQ_INFO,
d8a199355f8f8a Stephane Grosjean 2012-03-02  883  					    PCAN_USBPRO_INFO_BL,
f14e22435a27ef Marc Kleine-Budde 2013-05-16  884  					    bi, sizeof(*bi));
d8a199355f8f8a Stephane Grosjean 2012-03-02  885  		if (err) {
d8a199355f8f8a Stephane Grosjean 2012-03-02  886  			dev_err(dev->netdev->dev.parent,
d8a199355f8f8a Stephane Grosjean 2012-03-02  887  				"unable to read %s bootloader info (err %d)\n",
d8a199355f8f8a Stephane Grosjean 2012-03-02  888  				pcan_usb_pro.name, err);
f14e22435a27ef Marc Kleine-Budde 2013-05-16  889  			goto err_out;
d8a199355f8f8a Stephane Grosjean 2012-03-02  890  		}
d8a199355f8f8a Stephane Grosjean 2012-03-02  891  
f14e22435a27ef Marc Kleine-Budde 2013-05-16  892  		/* tell the device the can driver is running */
f14e22435a27ef Marc Kleine-Budde 2013-05-16  893  		err = pcan_usb_pro_drv_loaded(dev, 1);
f14e22435a27ef Marc Kleine-Budde 2013-05-16  894  		if (err)
f14e22435a27ef Marc Kleine-Budde 2013-05-16  895  			goto err_out;
f14e22435a27ef Marc Kleine-Budde 2013-05-16  896  
d8a199355f8f8a Stephane Grosjean 2012-03-02  897  		dev_info(dev->netdev->dev.parent,
d8a199355f8f8a Stephane Grosjean 2012-03-02  898  		     "PEAK-System %s hwrev %u serial %08X.%08X (%u channels)\n",
d8a199355f8f8a Stephane Grosjean 2012-03-02  899  		     pcan_usb_pro.name,
f14e22435a27ef Marc Kleine-Budde 2013-05-16  900  		     bi->hw_rev, bi->serial_num_hi, bi->serial_num_lo,
d8a199355f8f8a Stephane Grosjean 2012-03-02  901  		     pcan_usb_pro.ctrl_count);
d8a199355f8f8a Stephane Grosjean 2012-03-02  902  
20fb4eb96fb035 Marc Kleine-Budde 2013-12-14  903  		kfree(bi);
20fb4eb96fb035 Marc Kleine-Budde 2013-12-14  904  		kfree(fi);
126e94285ae630 Bernard Zhao      2022-05-11  905  	} else {
126e94285ae630 Bernard Zhao      2022-05-11  906  		pusb_if = pcan_usb_pro_dev_if(dev->prev_siblings);
126e94285ae630 Bernard Zhao      2022-05-11  907  	}
126e94285ae630 Bernard Zhao      2022-05-11  908  
126e94285ae630 Bernard Zhao      2022-05-11  909  	*usb_if = pusb_if;
20fb4eb96fb035 Marc Kleine-Budde 2013-12-14  910  
d8a199355f8f8a Stephane Grosjean 2012-03-02  911  	return 0;
f14e22435a27ef Marc Kleine-Budde 2013-05-16  912  
f14e22435a27ef Marc Kleine-Budde 2013-05-16  913   err_out:
f14e22435a27ef Marc Kleine-Budde 2013-05-16 @914  	kfree(bi);
f14e22435a27ef Marc Kleine-Budde 2013-05-16 @915  	kfree(fi);
f14e22435a27ef Marc Kleine-Budde 2013-05-16  916  	kfree(usb_if);
f14e22435a27ef Marc Kleine-Budde 2013-05-16  917  
f14e22435a27ef Marc Kleine-Budde 2013-05-16  918  	return err;
d8a199355f8f8a Stephane Grosjean 2012-03-02  919  }
d8a199355f8f8a Stephane Grosjean 2012-03-02  920  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
