Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2B5315011F
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 06:12:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbgBCFMj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 00:12:39 -0500
Received: from mga09.intel.com ([134.134.136.24]:65101 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726018AbgBCFMi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Feb 2020 00:12:38 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Feb 2020 21:12:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,396,1574150400"; 
   d="scan'208";a="278639647"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 02 Feb 2020 21:12:33 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1iyU2D-00040h-80; Mon, 03 Feb 2020 13:12:33 +0800
Date:   Mon, 3 Feb 2020 13:11:49 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     kbuild-all@lists.01.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ajay Gupta <ajayg@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Iyappan Subramanian <iyappan@os.amperecomputing.com>,
        Keyur Chudgar <keyur@os.amperecomputing.com>,
        Quan Nguyen <quan@os.amperecomputing.com>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] device property: change device_get_phy_mode() to
 prevent signedess bugs
Message-ID: <202002031247.fhmzF9z1%lkp@intel.com>
References: <20200131045953.wbj66jkvijnmf5s2@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200131045953.wbj66jkvijnmf5s2@kili.mountain>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dan,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net/master]
[also build test WARNING on driver-core/driver-core-testing linus/master v5.5 next-20200131]
[cannot apply to sparc-next/master]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Dan-Carpenter/device-property-change-device_get_phy_mode-to-prevent-signedess-bugs/20200203-043126
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git b7c3a17c6062701d97a0959890a2c882bfaac537
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-154-g1dc00f87-dirty
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

   arch/x86/boot/compressed/cmdline.c:5:20: sparse: sparse: multiple definitions for function 'set_fs'
>> arch/x86/include/asm/uaccess.h:29:20: sparse:  the previous one is here
   arch/x86/boot/compressed/../cmdline.c:28:5: sparse: sparse: symbol '__cmdline_find_option' was not declared. Should it be static?
   arch/x86/boot/compressed/../cmdline.c:100:5: sparse: sparse: symbol '__cmdline_find_option_bool' was not declared. Should it be static?

vim +29 arch/x86/include/asm/uaccess.h

ca23386216b9d4 include/asm-x86/uaccess.h      Glauber Costa   2008-06-13  27  
13d4ea097d18b4 arch/x86/include/asm/uaccess.h Andy Lutomirski 2016-07-14  28  #define get_fs()	(current->thread.addr_limit)
5ea0727b163cb5 arch/x86/include/asm/uaccess.h Thomas Garnier  2017-06-14 @29  static inline void set_fs(mm_segment_t fs)
5ea0727b163cb5 arch/x86/include/asm/uaccess.h Thomas Garnier  2017-06-14  30  {
5ea0727b163cb5 arch/x86/include/asm/uaccess.h Thomas Garnier  2017-06-14  31  	current->thread.addr_limit = fs;
5ea0727b163cb5 arch/x86/include/asm/uaccess.h Thomas Garnier  2017-06-14  32  	/* On user-mode return, check fs is correct */
5ea0727b163cb5 arch/x86/include/asm/uaccess.h Thomas Garnier  2017-06-14  33  	set_thread_flag(TIF_FSCHECK);
5ea0727b163cb5 arch/x86/include/asm/uaccess.h Thomas Garnier  2017-06-14  34  }
ca23386216b9d4 include/asm-x86/uaccess.h      Glauber Costa   2008-06-13  35  

:::::: The code at line 29 was first introduced by commit
:::::: 5ea0727b163cb5575e36397a12eade68a1f35f24 x86/syscalls: Check address limit on user-mode return

:::::: TO: Thomas Garnier <thgarnie@google.com>
:::::: CC: Thomas Gleixner <tglx@linutronix.de>

---
0-DAY kernel test infrastructure                 Open Source Technology Center
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org Intel Corporation
