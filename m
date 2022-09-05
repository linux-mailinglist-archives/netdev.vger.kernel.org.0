Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9135AC83E
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 02:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232091AbiIEAGC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Sep 2022 20:06:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbiIEAGB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Sep 2022 20:06:01 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE31928E2B;
        Sun,  4 Sep 2022 17:05:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662336360; x=1693872360;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=8KyJqGWwn53Cm6l9LSQlQLSOXBXBeBW5f/YG9DrQ0TU=;
  b=BOZJsyP2whi7ZvMsmsnYof8oWwqWC1xRgT/VZsIBOMOTGIT0iPXJPqRV
   d8PwymlcCy4GWKW6ZUwLbchCsKGb9GvOqPPY3kA6x24q6ICS1j9itvuHY
   NLSqRGCXwPxDsarIL3FNUvjUhZmAIxCsjuc2/x1bWTGwHSnYqYqxqUTPn
   HzYWqiFEJ3ZX1Q+Ql9VrtYE95un1SRPhdKsJmdxPA7F2MrLED9xW0N7pb
   BXgeN0CjPpXh+SbJ06rlNToi7mvuSUN2xk58lVqIJP0zledGJ9x8nrVKp
   OAz3/Np/gW09OXMACG1M8+wMBhsMGmQ6mL5TkRrIaZoTIxITa6goeyfbu
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10460"; a="283271756"
X-IronPort-AV: E=Sophos;i="5.93,290,1654585200"; 
   d="scan'208";a="283271756"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2022 17:05:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,290,1654585200"; 
   d="scan'208";a="681865950"
Received: from lkp-server02.sh.intel.com (HELO 95dfd251caa2) ([10.239.97.151])
  by fmsmga004.fm.intel.com with ESMTP; 04 Sep 2022 17:05:57 -0700
Received: from kbuild by 95dfd251caa2 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oUzci-0003Yg-1g;
        Mon, 05 Sep 2022 00:05:56 +0000
Date:   Mon, 5 Sep 2022 08:05:28 +0800
From:   kernel test robot <lkp@intel.com>
To:     Olliver Schinagl <oliver@schinagl.nl>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>
Cc:     kbuild-all@lists.01.org, inux-kernel@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Olliver Schinagl <oliver@schinagl.nl>
Subject: Re: [PATCH] phy: Add helpers for setting/clearing bits in paged
 registers
Message-ID: <202209050848.JPIiJd7T-lkp@intel.com>
References: <20220904225555.1994290-1-oliver@schinagl.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220904225555.1994290-1-oliver@schinagl.nl>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Olliver,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on linus/master]
[also build test ERROR on v6.0-rc4 next-20220901]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Olliver-Schinagl/phy-Add-helpers-for-setting-clearing-bits-in-paged-registers/20220905-070318
base:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git 7e18e42e4b280c85b76967a9106a13ca61c16179
config: arm-randconfig-r032-20220904 (https://download.01.org/0day-ci/archive/20220905/202209050848.JPIiJd7T-lkp@intel.com/config)
compiler: arm-linux-gnueabi-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/342260cb7603ad567f4799836ad4ed390ccedf2a
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Olliver-Schinagl/phy-Add-helpers-for-setting-clearing-bits-in-paged-registers/20220905-070318
        git checkout 342260cb7603ad567f4799836ad4ed390ccedf2a
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=arm SHELL=/bin/bash drivers/phy/freescale/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from drivers/phy/freescale/phy-fsl-lynx-28g.c:5:
   include/linux/phy.h: In function 'phy_set_bits_paged':
>> include/linux/phy.h:1275:16: error: implicit declaration of function 'phy_modify_paged'; did you mean 'phy_modify_changed'? [-Werror=implicit-function-declaration]
    1275 |         return phy_modify_paged(phydev, page, regnum, 0, val);
         |                ^~~~~~~~~~~~~~~~
         |                phy_modify_changed
   include/linux/phy.h: At top level:
>> include/linux/phy.h:1447:5: error: conflicting types for 'phy_modify_paged'; have 'int(struct phy_device *, int,  u32,  u16,  u16)' {aka 'int(struct phy_device *, int,  unsigned int,  short unsigned int,  short unsigned int)'}
    1447 | int phy_modify_paged(struct phy_device *phydev, int page, u32 regnum,
         |     ^~~~~~~~~~~~~~~~
   include/linux/phy.h:1448:22: note: an argument type that has a default promotion cannot match an empty parameter name list declaration
    1448 |                      u16 mask, u16 set);
         |                      ^~~
   include/linux/phy.h:1275:16: note: previous implicit declaration of 'phy_modify_paged' with type 'int()'
    1275 |         return phy_modify_paged(phydev, page, regnum, 0, val);
         |                ^~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors


vim +1275 include/linux/phy.h

  1264	
  1265	/**
  1266	 * phy_set_bits_paged - Convenience function for setting bits in a paged register
  1267	 * @phydev: the phy_device struct
  1268	 * @page: the page for the phy
  1269	 * @regnum: register number to write
  1270	 * @val: bits to set
  1271	 */
  1272	static inline int phy_set_bits_paged(struct phy_device *phydev, int page,
  1273					     u32 regnum, u16 val)
  1274	{
> 1275		return phy_modify_paged(phydev, page, regnum, 0, val);
  1276	}
  1277	
  1278	/**
  1279	 * phy_clear_bits_paged - Convenience function for clearing bits in a paged register
  1280	 * @phydev: the phy_device struct
  1281	 * @page: the page for the phy
  1282	 * @regnum: register number to write
  1283	 * @val: bits to clear
  1284	 */
  1285	static inline int phy_clear_bits_paged(struct phy_device *phydev, int page,
  1286					       u32 regnum, u16 val)
  1287	{
  1288		return phy_modify_paged(phydev, page, regnum, val, 0);
  1289	}
  1290	
  1291	/**
  1292	 * phy_interrupt_is_valid - Convenience function for testing a given PHY irq
  1293	 * @phydev: the phy_device struct
  1294	 *
  1295	 * NOTE: must be kept in sync with addition/removal of PHY_POLL and
  1296	 * PHY_MAC_INTERRUPT
  1297	 */
  1298	static inline bool phy_interrupt_is_valid(struct phy_device *phydev)
  1299	{
  1300		return phydev->irq != PHY_POLL && phydev->irq != PHY_MAC_INTERRUPT;
  1301	}
  1302	
  1303	/**
  1304	 * phy_polling_mode - Convenience function for testing whether polling is
  1305	 * used to detect PHY status changes
  1306	 * @phydev: the phy_device struct
  1307	 */
  1308	static inline bool phy_polling_mode(struct phy_device *phydev)
  1309	{
  1310		if (phydev->state == PHY_CABLETEST)
  1311			if (phydev->drv->flags & PHY_POLL_CABLE_TEST)
  1312				return true;
  1313	
  1314		return phydev->irq == PHY_POLL;
  1315	}
  1316	
  1317	/**
  1318	 * phy_has_hwtstamp - Tests whether a PHY time stamp configuration.
  1319	 * @phydev: the phy_device struct
  1320	 */
  1321	static inline bool phy_has_hwtstamp(struct phy_device *phydev)
  1322	{
  1323		return phydev && phydev->mii_ts && phydev->mii_ts->hwtstamp;
  1324	}
  1325	
  1326	/**
  1327	 * phy_has_rxtstamp - Tests whether a PHY supports receive time stamping.
  1328	 * @phydev: the phy_device struct
  1329	 */
  1330	static inline bool phy_has_rxtstamp(struct phy_device *phydev)
  1331	{
  1332		return phydev && phydev->mii_ts && phydev->mii_ts->rxtstamp;
  1333	}
  1334	
  1335	/**
  1336	 * phy_has_tsinfo - Tests whether a PHY reports time stamping and/or
  1337	 * PTP hardware clock capabilities.
  1338	 * @phydev: the phy_device struct
  1339	 */
  1340	static inline bool phy_has_tsinfo(struct phy_device *phydev)
  1341	{
  1342		return phydev && phydev->mii_ts && phydev->mii_ts->ts_info;
  1343	}
  1344	
  1345	/**
  1346	 * phy_has_txtstamp - Tests whether a PHY supports transmit time stamping.
  1347	 * @phydev: the phy_device struct
  1348	 */
  1349	static inline bool phy_has_txtstamp(struct phy_device *phydev)
  1350	{
  1351		return phydev && phydev->mii_ts && phydev->mii_ts->txtstamp;
  1352	}
  1353	
  1354	static inline int phy_hwtstamp(struct phy_device *phydev, struct ifreq *ifr)
  1355	{
  1356		return phydev->mii_ts->hwtstamp(phydev->mii_ts, ifr);
  1357	}
  1358	
  1359	static inline bool phy_rxtstamp(struct phy_device *phydev, struct sk_buff *skb,
  1360					int type)
  1361	{
  1362		return phydev->mii_ts->rxtstamp(phydev->mii_ts, skb, type);
  1363	}
  1364	
  1365	static inline int phy_ts_info(struct phy_device *phydev,
  1366				      struct ethtool_ts_info *tsinfo)
  1367	{
  1368		return phydev->mii_ts->ts_info(phydev->mii_ts, tsinfo);
  1369	}
  1370	
  1371	static inline void phy_txtstamp(struct phy_device *phydev, struct sk_buff *skb,
  1372					int type)
  1373	{
  1374		phydev->mii_ts->txtstamp(phydev->mii_ts, skb, type);
  1375	}
  1376	
  1377	/**
  1378	 * phy_is_internal - Convenience function for testing if a PHY is internal
  1379	 * @phydev: the phy_device struct
  1380	 */
  1381	static inline bool phy_is_internal(struct phy_device *phydev)
  1382	{
  1383		return phydev->is_internal;
  1384	}
  1385	
  1386	/**
  1387	 * phy_on_sfp - Convenience function for testing if a PHY is on an SFP module
  1388	 * @phydev: the phy_device struct
  1389	 */
  1390	static inline bool phy_on_sfp(struct phy_device *phydev)
  1391	{
  1392		return phydev->is_on_sfp_module;
  1393	}
  1394	
  1395	/**
  1396	 * phy_interface_mode_is_rgmii - Convenience function for testing if a
  1397	 * PHY interface mode is RGMII (all variants)
  1398	 * @mode: the &phy_interface_t enum
  1399	 */
  1400	static inline bool phy_interface_mode_is_rgmii(phy_interface_t mode)
  1401	{
  1402		return mode >= PHY_INTERFACE_MODE_RGMII &&
  1403			mode <= PHY_INTERFACE_MODE_RGMII_TXID;
  1404	};
  1405	
  1406	/**
  1407	 * phy_interface_mode_is_8023z() - does the PHY interface mode use 802.3z
  1408	 *   negotiation
  1409	 * @mode: one of &enum phy_interface_t
  1410	 *
  1411	 * Returns true if the PHY interface mode uses the 16-bit negotiation
  1412	 * word as defined in 802.3z. (See 802.3-2015 37.2.1 Config_Reg encoding)
  1413	 */
  1414	static inline bool phy_interface_mode_is_8023z(phy_interface_t mode)
  1415	{
  1416		return mode == PHY_INTERFACE_MODE_1000BASEX ||
  1417		       mode == PHY_INTERFACE_MODE_2500BASEX;
  1418	}
  1419	
  1420	/**
  1421	 * phy_interface_is_rgmii - Convenience function for testing if a PHY interface
  1422	 * is RGMII (all variants)
  1423	 * @phydev: the phy_device struct
  1424	 */
  1425	static inline bool phy_interface_is_rgmii(struct phy_device *phydev)
  1426	{
  1427		return phy_interface_mode_is_rgmii(phydev->interface);
  1428	};
  1429	
  1430	/**
  1431	 * phy_is_pseudo_fixed_link - Convenience function for testing if this
  1432	 * PHY is the CPU port facing side of an Ethernet switch, or similar.
  1433	 * @phydev: the phy_device struct
  1434	 */
  1435	static inline bool phy_is_pseudo_fixed_link(struct phy_device *phydev)
  1436	{
  1437		return phydev->is_pseudo_fixed_link;
  1438	}
  1439	
  1440	int phy_save_page(struct phy_device *phydev);
  1441	int phy_select_page(struct phy_device *phydev, int page);
  1442	int phy_restore_page(struct phy_device *phydev, int oldpage, int ret);
  1443	int phy_read_paged(struct phy_device *phydev, int page, u32 regnum);
  1444	int phy_write_paged(struct phy_device *phydev, int page, u32 regnum, u16 val);
  1445	int phy_modify_paged_changed(struct phy_device *phydev, int page, u32 regnum,
  1446				     u16 mask, u16 set);
> 1447	int phy_modify_paged(struct phy_device *phydev, int page, u32 regnum,
  1448			     u16 mask, u16 set);
  1449	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
