Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 298D71DA5DF
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 01:56:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727998AbgESXzy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 19:55:54 -0400
Received: from mga03.intel.com ([134.134.136.65]:19135 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726344AbgESXzy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 May 2020 19:55:54 -0400
IronPort-SDR: IqkjsPHywSBnv+h0Uin5G36hl/4SQkPUnCT+IdvPdzU3pZz9JQO/hISkm0JfG5a4wgXuoOH28j
 FBtuQ3TiiIhA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2020 16:55:53 -0700
IronPort-SDR: GzwlCj39Ga2wPI06fcJuVDU75P9xZVTurG0jfCHE7L2ajcnohXpQ20xc356V8GgQAFW5uOg2oI
 WxxTaz5D+1tw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,411,1583222400"; 
   d="scan'208";a="466322470"
Received: from pl-dbox.sh.intel.com (HELO intel.com) ([10.239.159.39])
  by fmsmga006.fm.intel.com with ESMTP; 19 May 2020 16:55:50 -0700
Date:   Wed, 20 May 2020 07:54:33 +0800
From:   Philip Li <philip.li@intel.com>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     kbuild test robot <lkp@intel.com>, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, davem@davemloft.net,
        kbuild-all@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [kbuild-all] Re: [PATCH net-next 2/4] net: phy: dp83869: Set
 opmode from straps
Message-ID: <20200519235433.GA32726@intel.com>
References: <20200519141813.28167-3-dmurphy@ti.com>
 <202005200117.iOd1QuA3%lkp@intel.com>
 <ac286fd2-b77f-9103-d9f2-aa95ad792476@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac286fd2-b77f-9103-d9f2-aa95ad792476@ti.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 19, 2020 at 12:40:37PM -0500, Dan Murphy wrote:
> kbuild
> 
> On 5/19/20 12:19 PM, kbuild test robot wrote:
> > Hi Dan,
> > 
> > I love your patch! Perhaps something to improve:
> > 
> > [auto build test WARNING on net-next/master]
> > [also build test WARNING on robh/for-next sparc-next/master net/master linus/master v5.7-rc6 next-20200518]
> > [if your patch is applied to the wrong git tree, please drop us a note to help
> > improve the system. BTW, we also suggest to use '--base' option to specify the
> > base tree in git format-patch, please see https://stackoverflow.com/a/37406982]
> > 
> > url:    https://github.com/0day-ci/linux/commits/Dan-Murphy/DP83869-Enhancements/20200519-222047
> > base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 5cdfe8306631b2224e3f81fc5a1e2721c7a1948b
> > config: sh-allmodconfig (attached as .config)
> > compiler: sh4-linux-gcc (GCC) 9.3.0
> > reproduce:
> >          wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
> >          chmod +x ~/bin/make.cross
> >          # save the attached .config to linux build tree
> >          COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross ARCH=sh
> > 
> > If you fix the issue, kindly add following tag as appropriate
> > Reported-by: kbuild test robot <lkp@intel.com>
> > 
> > All warnings (new ones prefixed by >>, old ones prefixed by <<):
> > 
> > drivers/net/phy/dp83869.c: In function 'dp83869_set_strapped_mode':
> > > > drivers/net/phy/dp83869.c:171:10: warning: comparison is always false due to limited range of data type [-Wtype-limits]
> > 171 |  if (val < 0)
> 
> This looks to be a false positive.
> 
> phy_read_mmd will return an errno or a value from 0->15
thanks, here because val is defined as "u16 val", the comparison
to < 0 can not work as expected. Any err returned from phy_read_mmd,
which is int, will be converted to u16.

> 
> So if errno is returned then this will be true.
> 
> Unless I have to do IS_ERR.
> 
> Dan
> _______________________________________________
> kbuild-all mailing list -- kbuild-all@lists.01.org
> To unsubscribe send an email to kbuild-all-leave@lists.01.org
