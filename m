Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F17674F5382
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 06:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2359751AbiDFEYq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 00:24:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353893AbiDEWMt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 18:12:49 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D04555E149;
        Tue,  5 Apr 2022 13:44:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649191477; x=1680727477;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=OETAEwMX1mECn/WD55uIFHzLIrtTa1ZqX2+Ou6+jPuU=;
  b=QA5WjDB3quCHEkLgtzegYzEscWxs7z2cGVab9M0tqZfhYsYZkDZPgR+0
   27oiFNEaWodGhDdrbTQzAyDyhzB3tEod/4bIzc31nWBYfLBTMYx0Hnd1S
   sYTaTNux7PY5xXCivQdB677IEtl3MEmnwxLi3hXEC4b1iziIE/daKIlsH
   /0n6abv+lijHpIsewjGipwxovXJDOEsbJE5XNUFc00IxxUxHBBd26zLHG
   flR2JBxLckUN/GOY+4KvkK3vrMG7oRGb6oRIl3lU4FTirAinguD18+EeN
   6VL/isI9Tlk+QuA8sVHKx7PfiArQOSdn3jyBsk+Lfq58inNDuatdRWhY1
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10308"; a="241446639"
X-IronPort-AV: E=Sophos;i="5.90,238,1643702400"; 
   d="scan'208";a="241446639"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 13:44:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,238,1643702400"; 
   d="scan'208";a="588087907"
Received: from lkp-server02.sh.intel.com (HELO a44fdfb70b94) ([10.239.97.151])
  by orsmga001.jf.intel.com with ESMTP; 05 Apr 2022 13:44:34 -0700
Received: from kbuild by a44fdfb70b94 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nbq2T-0003jy-47;
        Tue, 05 Apr 2022 20:44:33 +0000
Date:   Wed, 6 Apr 2022 04:44:25 +0800
From:   kernel test robot <lkp@intel.com>
To:     David Kahurani <k.kahurani@gmail.com>, netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org,
        syzbot+d3dbdf31fbe9d8f5f311@syzkaller.appspotmail.com,
        davem@davemloft.net, jgg@ziepe.ca, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        phil@philpotter.co.uk, syzkaller-bugs@googlegroups.com,
        arnd@arndb.de, paskripkin@gmail.com,
        David Kahurani <k.kahurani@gmail.com>
Subject: Re: [PATCH] net: ax88179: add proper error handling of usb read
 errors
Message-ID: <202204060410.mWlznHB9-lkp@intel.com>
References: <20220404151036.265901-1-k.kahurani@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220404151036.265901-1-k.kahurani@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net/master]
[also build test WARNING on net-next/master horms-ipvs/master linus/master v5.18-rc1 next-20220405]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/David-Kahurani/net-ax88179-add-proper-error-handling-of-usb-read-errors/20220404-231226
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git 692930cc435099580a4b9e32fa781b0688c18439
config: i386-randconfig-m021-20220404 (https://download.01.org/0day-ci/archive/20220406/202204060410.mWlznHB9-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.2.0-19) 11.2.0

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

smatch warnings:
drivers/net/usb/ax88179_178a.c:1164 ax88179_check_eeprom() warn: inconsistent indenting

vim +1164 drivers/net/usb/ax88179_178a.c

e2ca90c276e1fc4 Freddy Xin     2013-03-02  1132  
e2ca90c276e1fc4 Freddy Xin     2013-03-02  1133  static int ax88179_check_eeprom(struct usbnet *dev)
e2ca90c276e1fc4 Freddy Xin     2013-03-02  1134  {
e2ca90c276e1fc4 Freddy Xin     2013-03-02  1135  	u8 i, buf, eeprom[20];
e2ca90c276e1fc4 Freddy Xin     2013-03-02  1136  	u16 csum, delay = HZ / 10;
e2ca90c276e1fc4 Freddy Xin     2013-03-02  1137  	unsigned long jtimeout;
c006257c3aa36f6 David Kahurani 2022-04-04  1138  	int ret;
e2ca90c276e1fc4 Freddy Xin     2013-03-02  1139  
e2ca90c276e1fc4 Freddy Xin     2013-03-02  1140  	/* Read EEPROM content */
e2ca90c276e1fc4 Freddy Xin     2013-03-02  1141  	for (i = 0; i < 6; i++) {
e2ca90c276e1fc4 Freddy Xin     2013-03-02  1142  		buf = i;
e2ca90c276e1fc4 Freddy Xin     2013-03-02  1143  		if (ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_SROM_ADDR,
e2ca90c276e1fc4 Freddy Xin     2013-03-02  1144  				      1, 1, &buf) < 0)
e2ca90c276e1fc4 Freddy Xin     2013-03-02  1145  			return -EINVAL;
e2ca90c276e1fc4 Freddy Xin     2013-03-02  1146  
e2ca90c276e1fc4 Freddy Xin     2013-03-02  1147  		buf = EEP_RD;
e2ca90c276e1fc4 Freddy Xin     2013-03-02  1148  		if (ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_SROM_CMD,
e2ca90c276e1fc4 Freddy Xin     2013-03-02  1149  				      1, 1, &buf) < 0)
e2ca90c276e1fc4 Freddy Xin     2013-03-02  1150  			return -EINVAL;
e2ca90c276e1fc4 Freddy Xin     2013-03-02  1151  
e2ca90c276e1fc4 Freddy Xin     2013-03-02  1152  		jtimeout = jiffies + delay;
e2ca90c276e1fc4 Freddy Xin     2013-03-02  1153  		do {
c006257c3aa36f6 David Kahurani 2022-04-04  1154  		    ret = ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_SROM_CMD,
e2ca90c276e1fc4 Freddy Xin     2013-03-02  1155  					   1, 1, &buf);
e2ca90c276e1fc4 Freddy Xin     2013-03-02  1156  
c006257c3aa36f6 David Kahurani 2022-04-04  1157  		    if (ret < 0) {
c006257c3aa36f6 David Kahurani 2022-04-04  1158  			    netdev_dbg(dev->net,
c006257c3aa36f6 David Kahurani 2022-04-04  1159  				       "Failed to read SROM_CMD: %d\n",
c006257c3aa36f6 David Kahurani 2022-04-04  1160  			               ret);
c006257c3aa36f6 David Kahurani 2022-04-04  1161  			    return ret;
c006257c3aa36f6 David Kahurani 2022-04-04  1162  		    }
c006257c3aa36f6 David Kahurani 2022-04-04  1163  
e2ca90c276e1fc4 Freddy Xin     2013-03-02 @1164  			if (time_after(jiffies, jtimeout))
e2ca90c276e1fc4 Freddy Xin     2013-03-02  1165  				return -EINVAL;
e2ca90c276e1fc4 Freddy Xin     2013-03-02  1166  
e2ca90c276e1fc4 Freddy Xin     2013-03-02  1167  		} while (buf & EEP_BUSY);
e2ca90c276e1fc4 Freddy Xin     2013-03-02  1168  
c006257c3aa36f6 David Kahurani 2022-04-04  1169  		ret = __ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_SROM_DATA_LOW,
e2ca90c276e1fc4 Freddy Xin     2013-03-02  1170  				         2, 2, &eeprom[i * 2], 0);
e2ca90c276e1fc4 Freddy Xin     2013-03-02  1171  
c006257c3aa36f6 David Kahurani 2022-04-04  1172  		if (ret < 0) {
c006257c3aa36f6 David Kahurani 2022-04-04  1173  			netdev_dbg(dev->net,
c006257c3aa36f6 David Kahurani 2022-04-04  1174  				   "Failed to read SROM_DATA_LOW: %d\n",
c006257c3aa36f6 David Kahurani 2022-04-04  1175  			           ret);
c006257c3aa36f6 David Kahurani 2022-04-04  1176  			return ret;
c006257c3aa36f6 David Kahurani 2022-04-04  1177  		}
c006257c3aa36f6 David Kahurani 2022-04-04  1178  
e2ca90c276e1fc4 Freddy Xin     2013-03-02  1179  		if ((i == 0) && (eeprom[0] == 0xFF))
e2ca90c276e1fc4 Freddy Xin     2013-03-02  1180  			return -EINVAL;
e2ca90c276e1fc4 Freddy Xin     2013-03-02  1181  	}
e2ca90c276e1fc4 Freddy Xin     2013-03-02  1182  
e2ca90c276e1fc4 Freddy Xin     2013-03-02  1183  	csum = eeprom[6] + eeprom[7] + eeprom[8] + eeprom[9];
e2ca90c276e1fc4 Freddy Xin     2013-03-02  1184  	csum = (csum >> 8) + (csum & 0xff);
e2ca90c276e1fc4 Freddy Xin     2013-03-02  1185  	if ((csum + eeprom[10]) != 0xff)
e2ca90c276e1fc4 Freddy Xin     2013-03-02  1186  		return -EINVAL;
e2ca90c276e1fc4 Freddy Xin     2013-03-02  1187  
e2ca90c276e1fc4 Freddy Xin     2013-03-02  1188  	return 0;
e2ca90c276e1fc4 Freddy Xin     2013-03-02  1189  }
e2ca90c276e1fc4 Freddy Xin     2013-03-02  1190  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
