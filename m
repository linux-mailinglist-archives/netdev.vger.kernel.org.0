Return-Path: <netdev+bounces-5926-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F3DE7135D5
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 19:05:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 304351C20A05
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 17:05:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B4A5134C1;
	Sat, 27 May 2023 17:05:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1602D11CAE
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 17:05:19 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96136A6
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 10:05:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685207117; x=1716743117;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=yboutVWtpGa0SETiEbDedzkoypL8l9gY6xFMh6Sm3x0=;
  b=nbZIz4GyMBbE8/bFPKx4TY+EcqXAuMg4yD40tZ5fI/ZjEVvHLs6NVDPL
   6HReU0chBffZPuYWd4muL6uWg/5CepgbZK2tOGNIZjjJKuuV2rJVICkWQ
   ROXQ5eQs9kuPjkafPdcz+nggsQXvi5V+HJYRCohpnKzgVVfYGWz/uMv8M
   hvKwRAKIOS9LmyuFwZ12dibusize98JF5qbVDz38v5jqJ+2tFzdGpqeXk
   Hkncwvn3yoeOBCjJrLcGxF11feyFMKeeODxKn6OIvsIi8Blz6HLK1Ip1L
   bVIpcU2NK47WxPpuaFAT3WVxngL2UB6p/oGeeoFs5zXi8aQ5hL47ckYl+
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10723"; a="382674605"
X-IronPort-AV: E=Sophos;i="6.00,197,1681196400"; 
   d="scan'208";a="382674605"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2023 10:05:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10723"; a="770628736"
X-IronPort-AV: E=Sophos;i="6.00,197,1681196400"; 
   d="scan'208";a="770628736"
Received: from lkp-server01.sh.intel.com (HELO dea6d5a4f140) ([10.239.97.150])
  by fmsmga008.fm.intel.com with ESMTP; 27 May 2023 10:05:09 -0700
Received: from kbuild by dea6d5a4f140 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1q2xLp-000K5W-0B;
	Sat, 27 May 2023 17:05:09 +0000
Date: Sun, 28 May 2023 01:04:45 +0800
From: kernel test robot <lkp@intel.com>
To: Tristram.Ha@microchip.com, "David S. Miller" <davem@davemloft.net>,
	Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>
Cc: oe-kbuild-all@lists.linux.dev, netdev@vger.kernel.org,
	UNGLinuxDriver@microchip.com,
	Tristram Ha <Tristram.Ha@microchip.com>
Subject: Re: [PATCH net-next] net: phy: smsc: add WoL support to
 LAN8740/LAN8742 PHYs.
Message-ID: <202305280053.LordyDHm-lkp@intel.com>
References: <1685151574-2752-1-git-send-email-Tristram.Ha@microchip.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1685151574-2752-1-git-send-email-Tristram.Ha@microchip.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi,

kernel test robot noticed the following build errors:

[auto build test ERROR on net-next/main]

url:    https://github.com/intel-lab-lkp/linux/commits/Tristram-Ha-microchip-com/net-phy-smsc-add-WoL-support-to-LAN8740-LAN8742-PHYs/20230527-094102
base:   net-next/main
patch link:    https://lore.kernel.org/r/1685151574-2752-1-git-send-email-Tristram.Ha%40microchip.com
patch subject: [PATCH net-next] net: phy: smsc: add WoL support to LAN8740/LAN8742 PHYs.
config: x86_64-randconfig-x076-20230526 (https://download.01.org/0day-ci/archive/20230528/202305280053.LordyDHm-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-12) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/a1e40c5a7a32445d5ae4541d4e57bbc4b5065057
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Tristram-Ha-microchip-com/net-phy-smsc-add-WoL-support-to-LAN8740-LAN8742-PHYs/20230527-094102
        git checkout a1e40c5a7a32445d5ae4541d4e57bbc4b5065057
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=x86_64 olddefconfig
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202305280053.LordyDHm-lkp@intel.com/

All errors (new ones prefixed by >>):

   ld: drivers/net/phy/smsc.o: in function `smsc_crc16':
>> drivers/net/phy/smsc.c:330: undefined reference to `crc16'


vim +330 drivers/net/phy/smsc.c

   327	
   328	static u16 smsc_crc16(const u8 *buffer, size_t len)
   329	{
 > 330		return bitrev16(crc16(0xFFFF, buffer, len));
   331	}
   332	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

