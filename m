Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F34BC583A16
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 10:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235071AbiG1INS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 04:13:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235041AbiG1INP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 04:13:15 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B438C61DAF;
        Thu, 28 Jul 2022 01:13:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658995991; x=1690531991;
  h=subject:references:in-reply-to:to:cc:from:message-id:
   date:mime-version:content-transfer-encoding;
  bh=KZjOuzWpHbuXrEiOJb9P9m2y8CKe15WoIUaQ7tp/7GE=;
  b=l6DqQ0/GKLlSyV+/ZfDGZJrUuavw9p9ZKjH2BA1kfqv48iqEbhKhiYx/
   mEa7qivpktJyyAFlfzHplrN4fTchgNCF9+O7yNOY2boC0khXoa4oc3arr
   SkSANLgxHN6ubdB4Y66qiIKXj6cQbe+0LdSXtQHAAqQCG+S4x9+UF6IRN
   HaGvYyh8b3n5Fi9kONUY5hHDIyO2tCjpu2OIM1Npxbo7jvTcgJzm2Z5ll
   Tlf4CdHbi2VSpDW4WvTaEhgSXrqoxhjSL6YWkl/w8HmXO49dGZUzYpgTv
   GN2r5+G2/WDKnLhRGyWF3PsVS1JZe4nl0bSE+m2ET4D5S8GePy/jrfy2I
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10421"; a="289648499"
X-IronPort-AV: E=Sophos;i="5.93,196,1654585200"; 
   d="scan'208";a="289648499"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2022 01:13:11 -0700
X-IronPort-AV: E=Sophos;i="5.93,196,1654585200"; 
   d="scan'208";a="576355385"
Received: from rongch2-mobl.ccr.corp.intel.com (HELO [10.249.173.222]) ([10.249.173.222])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2022 01:13:04 -0700
Subject: Re: [net-next: PATCH v3 3/8] net: dsa: switch to device_/fwnode_ APIs
References: <202207281516.7lNRXIgu-lkp@intel.com>
In-Reply-To: <202207281516.7lNRXIgu-lkp@intel.com>
To:     Marcin Wojtas <mw@semihalf.com>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, netdev@vger.kernel.org
Cc:     rafael@kernel.org, andriy.shevchenko@linux.intel.com,
        sean.wang@mediatek.com, Landen.Chao@mediatek.com,
        linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux@armlinux.org.uk, hkallweit1@gmail.com, gjb@semihalf.com,
        mw@semihalf.com, jaz@semihalf.com, tn@semihalf.com,
        Samer.El-Haj-Mahmoud@arm.com, upstream@semihalf.com,
        "kbuild-all@lists.01.org" <kbuild-all@lists.01.org>
From:   kernel test robot <rong.a.chen@intel.com>
X-Forwarded-Message-Id: <202207281516.7lNRXIgu-lkp@intel.com>
Message-ID: <3ad81233-cf1a-99aa-eca9-6abe428e2703@intel.com>
Date:   Thu, 28 Jul 2022 16:13:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.12.0
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marcin,

I love your patch! Yet something to improve:

[auto build test ERROR on next-20220726]
[cannot apply to driver-core/driver-core-testing robh/for-next 
horms-ipvs/master linus/master v5.19-rc8 v5.19-rc7 v5.19-rc6 v5.19-rc8]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url: 
https://github.com/intel-lab-lkp/linux/commits/Marcin-Wojtas/DSA-switch-to-fwnode_-device_/20220727-144515
base:    058affafc65a74cf54499fb578b66ad0b18f939b
:::::: branch date: 24 hours ago
:::::: commit date: 24 hours ago
config: i386-allyesconfig 
(https://download.01.org/0day-ci/archive/20220728/202207281516.7lNRXIgu-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-3) 11.3.0
reproduce (this is a W=1 build):
         # 
https://github.com/intel-lab-lkp/linux/commit/0cd0cba4df268433a47eb7d7e6c4b657dac14cbc
         git remote add linux-review https://github.com/intel-lab-lkp/linux
         git fetch --no-tags linux-review 
Marcin-Wojtas/DSA-switch-to-fwnode_-device_/20220727-144515
         git checkout 0cd0cba4df268433a47eb7d7e6c4b657dac14cbc
         # save the config file
         mkdir build_dir && cp config build_dir/.config
         make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

    drivers/net/dsa/mt7530.c: In function 'mt7530_setup':
>> drivers/net/dsa/mt7530.c:2254:63: error: passing argument 2 of 'of_get_phy_mode' from incompatible pointer type [-Werror=incompatible-pointer-types]
     2254 |                                 ret = 
of_get_phy_mode(mac_np, &interface);
          | 
   ^~~~~~~~~~
          |                                                               |
          | 
   int *
    In file included from drivers/net/dsa/mt7530.c:15:
    include/linux/of_net.h:15:69: note: expected 'phy_interface_t *' but 
argument is of type 'int *'
       15 | extern int of_get_phy_mode(struct device_node *np, 
phy_interface_t *interface);
          | 
~~~~~~~~~~~~~~~~~^~~~~~~~~
    cc1: some warnings being treated as errors


vim +/of_get_phy_mode +2254 drivers/net/dsa/mt7530.c

ba751e28d442557 DENG Qingfang       2021-05-19  2103  b8f126a8d54318b 
Sean Wang           2017-04-07  2104  static int
b8f126a8d54318b Sean Wang           2017-04-07  2105 
mt7530_setup(struct dsa_switch *ds)
b8f126a8d54318b Sean Wang           2017-04-07  2106  {
b8f126a8d54318b Sean Wang           2017-04-07  2107  	struct 
mt7530_priv *priv = ds->priv;
6e19bc26cccdd34 Frank Wunderlich    2022-06-10  2108  	struct 
device_node *dn = NULL;
38f790a805609b2 René van Dorst      2019-09-02  2109  	struct 
device_node *phy_node;
38f790a805609b2 René van Dorst      2019-09-02  2110  	struct 
device_node *mac_np;
b8f126a8d54318b Sean Wang           2017-04-07  2111  	struct 
mt7530_dummy_poll p;
6e19bc26cccdd34 Frank Wunderlich    2022-06-10  2112  	struct dsa_port 
*cpu_dp;
0cd0cba4df26843 Marcin Wojtas       2022-07-27  2113  	int interface;
ca366d6c889b5d3 René van Dorst      2019-09-02  2114  	u32 id, val;
ca366d6c889b5d3 René van Dorst      2019-09-02  2115  	int ret, i;
b8f126a8d54318b Sean Wang           2017-04-07  2116  0abfd494deefdba 
Vivien Didelot      2017-09-20  2117  	/* The parent node of master 
netdev which holds the common system
b8f126a8d54318b Sean Wang           2017-04-07  2118  	 * controller 
also is the container for two GMACs nodes representing
b8f126a8d54318b Sean Wang           2017-04-07  2119  	 * as two netdev 
instances.
b8f126a8d54318b Sean Wang           2017-04-07  2120  	 */
6e19bc26cccdd34 Frank Wunderlich    2022-06-10  2121 
dsa_switch_for_each_cpu_port(cpu_dp, ds) {
6e19bc26cccdd34 Frank Wunderlich    2022-06-10  2122  		dn = 
cpu_dp->master->dev.of_node->parent;
6e19bc26cccdd34 Frank Wunderlich    2022-06-10  2123  		/* It doesn't 
matter which CPU port is found first,
6e19bc26cccdd34 Frank Wunderlich    2022-06-10  2124  		 * their masters 
should share the same parent OF node
6e19bc26cccdd34 Frank Wunderlich    2022-06-10  2125  		 */
6e19bc26cccdd34 Frank Wunderlich    2022-06-10  2126  		break;
6e19bc26cccdd34 Frank Wunderlich    2022-06-10  2127  	}
6e19bc26cccdd34 Frank Wunderlich    2022-06-10  2128  6e19bc26cccdd34 
Frank Wunderlich    2022-06-10  2129  	if (!dn) {
6e19bc26cccdd34 Frank Wunderlich    2022-06-10  2130  		dev_err(ds->dev, 
"parent OF node of DSA master not found");
6e19bc26cccdd34 Frank Wunderlich    2022-06-10  2131  		return -EINVAL;
6e19bc26cccdd34 Frank Wunderlich    2022-06-10  2132  	}
6e19bc26cccdd34 Frank Wunderlich    2022-06-10  2133  0b69c54c74bcb60 
DENG Qingfang       2021-08-04  2134  	ds->assisted_learning_on_cpu_port 
= true;
771c8901568dd87 DENG Qingfang       2020-12-11  2135 
ds->mtu_enforcement_ingress = true;
ddda1ac116c852b Greg Ungerer        2019-01-30  2136  ddda1ac116c852b 
Greg Ungerer        2019-01-30  2137  	if (priv->id == ID_MT7530) {
b8f126a8d54318b Sean Wang           2017-04-07  2138  	 
regulator_set_voltage(priv->core_pwr, 1000000, 1000000);
b8f126a8d54318b Sean Wang           2017-04-07  2139  		ret = 
regulator_enable(priv->core_pwr);
b8f126a8d54318b Sean Wang           2017-04-07  2140  		if (ret < 0) {
b8f126a8d54318b Sean Wang           2017-04-07  2141  			dev_err(priv->dev,
b8f126a8d54318b Sean Wang           2017-04-07  2142  				"Failed to 
enable core power: %d\n", ret);
b8f126a8d54318b Sean Wang           2017-04-07  2143  			return ret;
b8f126a8d54318b Sean Wang           2017-04-07  2144  		}
b8f126a8d54318b Sean Wang           2017-04-07  2145  b8f126a8d54318b 
Sean Wang           2017-04-07  2146  	 
regulator_set_voltage(priv->io_pwr, 3300000, 3300000);
b8f126a8d54318b Sean Wang           2017-04-07  2147  		ret = 
regulator_enable(priv->io_pwr);
b8f126a8d54318b Sean Wang           2017-04-07  2148  		if (ret < 0) {
b8f126a8d54318b Sean Wang           2017-04-07  2149  		 
dev_err(priv->dev, "Failed to enable io pwr: %d\n",
b8f126a8d54318b Sean Wang           2017-04-07  2150  				ret);
b8f126a8d54318b Sean Wang           2017-04-07  2151  			return ret;
b8f126a8d54318b Sean Wang           2017-04-07  2152  		}
ddda1ac116c852b Greg Ungerer        2019-01-30  2153  	}
b8f126a8d54318b Sean Wang           2017-04-07  2154  b8f126a8d54318b 
Sean Wang           2017-04-07  2155  	/* Reset whole chip through gpio 
pin or memory-mapped registers for
b8f126a8d54318b Sean Wang           2017-04-07  2156  	 * different type 
of hardware
b8f126a8d54318b Sean Wang           2017-04-07  2157  	 */
b8f126a8d54318b Sean Wang           2017-04-07  2158  	if (priv->mcm) {
b8f126a8d54318b Sean Wang           2017-04-07  2159  	 
reset_control_assert(priv->rstc);
b8f126a8d54318b Sean Wang           2017-04-07  2160  	 
usleep_range(1000, 1100);
b8f126a8d54318b Sean Wang           2017-04-07  2161  	 
reset_control_deassert(priv->rstc);
b8f126a8d54318b Sean Wang           2017-04-07  2162  	} else {
b8f126a8d54318b Sean Wang           2017-04-07  2163  	 
gpiod_set_value_cansleep(priv->reset, 0);
b8f126a8d54318b Sean Wang           2017-04-07  2164  	 
usleep_range(1000, 1100);
b8f126a8d54318b Sean Wang           2017-04-07  2165  	 
gpiod_set_value_cansleep(priv->reset, 1);
b8f126a8d54318b Sean Wang           2017-04-07  2166  	}
b8f126a8d54318b Sean Wang           2017-04-07  2167  b8f126a8d54318b 
Sean Wang           2017-04-07  2168  	/* Waiting for MT7530 got to 
stable */
b8f126a8d54318b Sean Wang           2017-04-07  2169 
INIT_MT7530_DUMMY_POLL(&p, priv, MT7530_HWTRAP);
b8f126a8d54318b Sean Wang           2017-04-07  2170  	ret = 
readx_poll_timeout(_mt7530_read, &p, val, val != 0,
b8f126a8d54318b Sean Wang           2017-04-07  2171  				 20, 1000000);
b8f126a8d54318b Sean Wang           2017-04-07  2172  	if (ret < 0) {
b8f126a8d54318b Sean Wang           2017-04-07  2173  	 
dev_err(priv->dev, "reset timeout\n");
b8f126a8d54318b Sean Wang           2017-04-07  2174  		return ret;
b8f126a8d54318b Sean Wang           2017-04-07  2175  	}
b8f126a8d54318b Sean Wang           2017-04-07  2176  b8f126a8d54318b 
Sean Wang           2017-04-07  2177  	id = mt7530_read(priv, MT7530_CREV);
b8f126a8d54318b Sean Wang           2017-04-07  2178  	id >>= 
CHIP_NAME_SHIFT;
b8f126a8d54318b Sean Wang           2017-04-07  2179  	if (id != 
MT7530_ID) {
b8f126a8d54318b Sean Wang           2017-04-07  2180  	 
dev_err(priv->dev, "chip %x can't be supported\n", id);
b8f126a8d54318b Sean Wang           2017-04-07  2181  		return -ENODEV;
b8f126a8d54318b Sean Wang           2017-04-07  2182  	}
b8f126a8d54318b Sean Wang           2017-04-07  2183  b8f126a8d54318b 
Sean Wang           2017-04-07  2184  	/* Reset the switch through 
internal reset */
b8f126a8d54318b Sean Wang           2017-04-07  2185 
mt7530_write(priv, MT7530_SYS_CTRL,
b8f126a8d54318b Sean Wang           2017-04-07  2186  		 
SYS_CTRL_PHY_RST | SYS_CTRL_SW_RST |
b8f126a8d54318b Sean Wang           2017-04-07  2187  		 
SYS_CTRL_REG_RST);
b8f126a8d54318b Sean Wang           2017-04-07  2188  b8f126a8d54318b 
Sean Wang           2017-04-07  2189  	/* Enable Port 6 only; P5 as 
GMAC5 which currently is not supported */
b8f126a8d54318b Sean Wang           2017-04-07  2190  	val = 
mt7530_read(priv, MT7530_MHWTRAP);
b8f126a8d54318b Sean Wang           2017-04-07  2191  	val &= 
~MHWTRAP_P6_DIS & ~MHWTRAP_PHY_ACCESS;
b8f126a8d54318b Sean Wang           2017-04-07  2192  	val |= 
MHWTRAP_MANUAL;
b8f126a8d54318b Sean Wang           2017-04-07  2193 
mt7530_write(priv, MT7530_MHWTRAP, val);
b8f126a8d54318b Sean Wang           2017-04-07  2194  ca366d6c889b5d3 
René van Dorst      2019-09-02  2195  	priv->p6_interface = 
PHY_INTERFACE_MODE_NA;
ca366d6c889b5d3 René van Dorst      2019-09-02  2196  b8f126a8d54318b 
Sean Wang           2017-04-07  2197  	/* Enable and reset MIB counters */
b8f126a8d54318b Sean Wang           2017-04-07  2198  	mt7530_mib_reset(ds);
b8f126a8d54318b Sean Wang           2017-04-07  2199  b8f126a8d54318b 
Sean Wang           2017-04-07  2200  	for (i = 0; i < MT7530_NUM_PORTS; 
i++) {
b8f126a8d54318b Sean Wang           2017-04-07  2201  		/* Disable 
forwarding by default on all ports */
b8f126a8d54318b Sean Wang           2017-04-07  2202  		mt7530_rmw(priv, 
MT7530_PCR_P(i), PCR_MATRIX_MASK,
b8f126a8d54318b Sean Wang           2017-04-07  2203  			   PCR_MATRIX_CLR);
b8f126a8d54318b Sean Wang           2017-04-07  2204  0b69c54c74bcb60 
DENG Qingfang       2021-08-04  2205  		/* Disable learning by default 
on all ports */
0b69c54c74bcb60 DENG Qingfang       2021-08-04  2206  		mt7530_set(priv, 
MT7530_PSC_P(i), SA_DIS);
0b69c54c74bcb60 DENG Qingfang       2021-08-04  2207  0ce0c3cd2239502 
Alex Dewar          2020-09-19  2208  		if (dsa_is_cpu_port(ds, i)) {
0ce0c3cd2239502 Alex Dewar          2020-09-19  2209  			ret = 
mt753x_cpu_port_enable(ds, i);
0ce0c3cd2239502 Alex Dewar          2020-09-19  2210  			if (ret)
0ce0c3cd2239502 Alex Dewar          2020-09-19  2211  				return ret;
5a30833b9a16f8d DENG Qingfang       2021-03-16  2212  		} else {
75104db0cb353ec Andrew Lunn         2019-02-24  2213  		 
mt7530_port_disable(ds, i);
6087175b7991a90 DENG Qingfang       2021-08-04  2214  6087175b7991a90 
DENG Qingfang       2021-08-04  2215  			/* Set default PVID to 0 on all 
user ports */
6087175b7991a90 DENG Qingfang       2021-08-04  2216  		 
mt7530_rmw(priv, MT7530_PPBV1_P(i), G0_PORT_VID_MASK,
6087175b7991a90 DENG Qingfang       2021-08-04  2217  				 
G0_PORT_VID_DEF);
5a30833b9a16f8d DENG Qingfang       2021-03-16  2218  		}
e045124e93995fe DENG Qingfang       2020-04-14  2219  		/* Enable 
consistent egress tag */
e045124e93995fe DENG Qingfang       2020-04-14  2220  		mt7530_rmw(priv, 
MT7530_PVC_P(i), PVC_EG_TAG_MASK,
e045124e93995fe DENG Qingfang       2020-04-14  2221  			 
PVC_EG_TAG(MT7530_VLAN_EG_CONSISTENT));
b8f126a8d54318b Sean Wang           2017-04-07  2222  	}
b8f126a8d54318b Sean Wang           2017-04-07  2223  1ca8a193cade7f4 
DENG Qingfang       2021-08-25  2224  	/* Setup VLAN ID 0 for 
VLAN-unaware bridges */
1ca8a193cade7f4 DENG Qingfang       2021-08-25  2225  	ret = 
mt7530_setup_vlan0(priv);
1ca8a193cade7f4 DENG Qingfang       2021-08-25  2226  	if (ret)
1ca8a193cade7f4 DENG Qingfang       2021-08-25  2227  		return ret;
1ca8a193cade7f4 DENG Qingfang       2021-08-25  2228  38f790a805609b2 
René van Dorst      2019-09-02  2229  	/* Setup port 5 */
38f790a805609b2 René van Dorst      2019-09-02  2230  	priv->p5_intf_sel 
= P5_DISABLED;
38f790a805609b2 René van Dorst      2019-09-02  2231  	interface = 
PHY_INTERFACE_MODE_NA;
38f790a805609b2 René van Dorst      2019-09-02  2232  38f790a805609b2 
René van Dorst      2019-09-02  2233  	if (!dsa_is_unused_port(ds, 5)) {
38f790a805609b2 René van Dorst      2019-09-02  2234  	 
priv->p5_intf_sel = P5_INTF_SEL_GMAC5;
0cd0cba4df26843 Marcin Wojtas       2022-07-27  2235  		interface = 
fwnode_get_phy_mode(dsa_to_port(ds, 5)->fwnode);
0cd0cba4df26843 Marcin Wojtas       2022-07-27  2236  		if (interface < 0)
0c65b2b90d13c1d Andrew Lunn         2019-11-04  2237  			return ret;
38f790a805609b2 René van Dorst      2019-09-02  2238  	} else {
38f790a805609b2 René van Dorst      2019-09-02  2239  		/* Scan the 
ethernet nodes. look for GMAC1, lookup used phy */
38f790a805609b2 René van Dorst      2019-09-02  2240  	 
for_each_child_of_node(dn, mac_np) {
38f790a805609b2 René van Dorst      2019-09-02  2241  			if 
(!of_device_is_compatible(mac_np,
38f790a805609b2 René van Dorst      2019-09-02  2242  						 
"mediatek,eth-mac"))
38f790a805609b2 René van Dorst      2019-09-02  2243  				continue;
38f790a805609b2 René van Dorst      2019-09-02  2244  38f790a805609b2 
René van Dorst      2019-09-02  2245  			ret = 
of_property_read_u32(mac_np, "reg", &id);
38f790a805609b2 René van Dorst      2019-09-02  2246  			if (ret < 0 || 
id != 1)
38f790a805609b2 René van Dorst      2019-09-02  2247  				continue;
38f790a805609b2 René van Dorst      2019-09-02  2248  38f790a805609b2 
René van Dorst      2019-09-02  2249  			phy_node = 
of_parse_phandle(mac_np, "phy-handle", 0);
0452800f6db4ed0 Chuanhong Guo       2020-04-03  2250  			if (!phy_node)
0452800f6db4ed0 Chuanhong Guo       2020-04-03  2251  				continue;
0452800f6db4ed0 Chuanhong Guo       2020-04-03  2252  38f790a805609b2 
René van Dorst      2019-09-02  2253  			if (phy_node->parent == 
priv->dev->of_node->parent) {
0c65b2b90d13c1d Andrew Lunn         2019-11-04 @2254  				ret = 
of_get_phy_mode(mac_np, &interface);
8e4efd4706f77d7 Sumera Priyadarsini 2020-08-25  2255  				if (ret && ret 
!= -ENODEV) {
8e4efd4706f77d7 Sumera Priyadarsini 2020-08-25  2256  				 
of_node_put(mac_np);
a9e9b091a1c14ec Yang Yingliang      2022-04-28  2257  				 
of_node_put(phy_node);
0c65b2b90d13c1d Andrew Lunn         2019-11-04  2258  					return ret;
8e4efd4706f77d7 Sumera Priyadarsini 2020-08-25  2259  				}
38f790a805609b2 René van Dorst      2019-09-02  2260  				id = 
of_mdio_parse_addr(ds->dev, phy_node);
38f790a805609b2 René van Dorst      2019-09-02  2261  				if (id == 0)
38f790a805609b2 René van Dorst      2019-09-02  2262  				 
priv->p5_intf_sel = P5_INTF_SEL_PHY_P0;
38f790a805609b2 René van Dorst      2019-09-02  2263  				if (id == 4)
38f790a805609b2 René van Dorst      2019-09-02  2264  				 
priv->p5_intf_sel = P5_INTF_SEL_PHY_P4;
38f790a805609b2 René van Dorst      2019-09-02  2265  			}
8e4efd4706f77d7 Sumera Priyadarsini 2020-08-25  2266  		 
of_node_put(mac_np);
38f790a805609b2 René van Dorst      2019-09-02  2267  		 
of_node_put(phy_node);
38f790a805609b2 René van Dorst      2019-09-02  2268  			break;
38f790a805609b2 René van Dorst      2019-09-02  2269  		}
38f790a805609b2 René van Dorst      2019-09-02  2270  	}
38f790a805609b2 René van Dorst      2019-09-02  2271
-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
