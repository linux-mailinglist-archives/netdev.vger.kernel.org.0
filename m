Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB638585EB2
	for <lists+netdev@lfdr.de>; Sun, 31 Jul 2022 13:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236551AbiGaLrM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jul 2022 07:47:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236651AbiGaLrL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jul 2022 07:47:11 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 267DD10562;
        Sun, 31 Jul 2022 04:47:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659268030; x=1690804030;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=PceATeTzyNmg/eKUrq2HdOx40gjDDIi3f7uO6V4HerM=;
  b=deot1T5IN7TKEArQ62L8VghBB2z+LoQi2YmU5ZY8SrVPOUAJgq8fY5Dq
   QD/JAYqPVWV+fBnzMtXdEGiSBcO+7i8QT7ByaqQbOSQx1H25M4otb9V+Q
   M/NRCTxGB1P3vfwbL10UfRmB+0MEXhVflctOsizXjabjM4I6p9xaOotoG
   dr83SdNh6Xr8uaHpT+u4ixQdQHKevlcOtTXhyLABxt5A6tLEvSYSxcCCX
   dIyOn8g1SyjAkik1ecK7ILi30G200jsfl6tcWEp2Aq6Y0AxjcHYM7NqcU
   oAeNsn9+MSBPAIOM3D5HFZaMGLgFbFhOPwh+t6n0fBG5EpR0h7APZ7FUk
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10424"; a="375292586"
X-IronPort-AV: E=Sophos;i="5.93,206,1654585200"; 
   d="scan'208";a="375292586"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2022 04:47:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,206,1654585200"; 
   d="scan'208";a="634596382"
Received: from lkp-server01.sh.intel.com (HELO e0eace57cfef) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 31 Jul 2022 04:47:06 -0700
Received: from kbuild by e0eace57cfef with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oI7PV-000E5I-2w;
        Sun, 31 Jul 2022 11:47:05 +0000
Date:   Sun, 31 Jul 2022 19:46:27 +0800
From:   kernel test robot <lkp@intel.com>
To:     Michael Walle <michael@walle.cc>,
        Ajay Singh <ajay.kathat@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Cc:     kbuild-all@lists.01.org, Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michael Walle <mwalle@kernel.org>
Subject: Re: [PATCH] wilc1000: fix DMA on stack objects
Message-ID: <202207311900.lzckeJZU-lkp@intel.com>
References: <20220728152037.386543-1-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220728152037.386543-1-michael@walle.cc>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michael,

I love your patch! Yet something to improve:

[auto build test ERROR on wireless/main]
[also build test ERROR on linus/master v5.19-rc8 next-20220728]
[cannot apply to wireless-next/main]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Michael-Walle/wilc1000-fix-DMA-on-stack-objects/20220728-232309
base:   https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless.git main
config: nios2-allyesconfig (https://download.01.org/0day-ci/archive/20220731/202207311900.lzckeJZU-lkp@intel.com/config)
compiler: nios2-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/c04b2e109aebded7849c37f13a3ab7b76b4c0496
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Michael-Walle/wilc1000-fix-DMA-on-stack-objects/20220728-232309
        git checkout c04b2e109aebded7849c37f13a3ab7b76b4c0496
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=nios2 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   drivers/net/wireless/microchip/wilc1000/sdio.c: In function 'wilc_sdio_cmd53':
>> drivers/net/wireless/microchip/wilc1000/sdio.c:107:39: error: implicit declaration of function 'object_is_on_stack' [-Werror=implicit-function-declaration]
     107 |         if ((!virt_addr_valid(buf) || object_is_on_stack(buf)) &&
         |                                       ^~~~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors


vim +/object_is_on_stack +107 drivers/net/wireless/microchip/wilc1000/sdio.c

    89	
    90	static int wilc_sdio_cmd53(struct wilc *wilc, struct sdio_cmd53 *cmd)
    91	{
    92		struct sdio_func *func = container_of(wilc->dev, struct sdio_func, dev);
    93		struct wilc_sdio *sdio_priv = wilc->bus_data;
    94		bool need_bounce_buf = false;
    95		u8 *buf = cmd->buffer;
    96		int size, ret;
    97	
    98		sdio_claim_host(func);
    99	
   100		func->num = cmd->function;
   101		func->cur_blksize = cmd->block_size;
   102		if (cmd->block_mode)
   103			size = cmd->count * cmd->block_size;
   104		else
   105			size = cmd->count;
   106	
 > 107		if ((!virt_addr_valid(buf) || object_is_on_stack(buf)) &&
   108		    !WARN_ON_ONCE(size > WILC_SDIO_BLOCK_SIZE)) {
   109			need_bounce_buf = true;
   110			buf = sdio_priv->dma_buffer;
   111		}
   112	
   113		if (cmd->read_write) {  /* write */
   114			if (need_bounce_buf)
   115				memcpy(buf, cmd->buffer, size);
   116			ret = sdio_memcpy_toio(func, cmd->address, buf, size);
   117		} else {        /* read */
   118			ret = sdio_memcpy_fromio(func, buf, cmd->address, size);
   119			if (need_bounce_buf)
   120				memcpy(cmd->buffer, buf, size);
   121		}
   122	
   123		sdio_release_host(func);
   124	
   125		if (ret)
   126			dev_err(&func->dev, "%s..failed, err(%d)\n", __func__,  ret);
   127	
   128		return ret;
   129	}
   130	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
