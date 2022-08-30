Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A8405A5D8E
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 10:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231364AbiH3IAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 04:00:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231329AbiH3IAJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 04:00:09 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9287213F6A;
        Tue, 30 Aug 2022 01:00:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661846405; x=1693382405;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=gj7BG2I75M6eDiqbF3AlhKCmmZofbp2bRV6PEgQpKu8=;
  b=n1fzlxMvX54OgM9QTi7Yi3G9cX5RejlyUC2BiO1GcCUpvG9T4vMSA0xa
   4edS0r83v529yYI0t63s6SWwl9LhajtYQKewPWo9j4h0saC4+gIn69Vq6
   LGv95AsBl2daukQCqFpGB2Ig0Or7eUNn+8NCL89ZeP+pmLOk9p+lHcihc
   qzFljl759T1EdDUdUXaOvdaOwkzwbhIWukPPgeRTS4DUWOgumOWdttZgq
   DZq013xA1IJq3XDirK7Jbk0EWwu79jTn1dCbweH/CJlZjFhbbNeL+TwTP
   seLqZnNWCGcFOiyCKWuEYpCQ/3lUBCEiHWVyJ3IvBVuIFDnfGa3BrRAhG
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10454"; a="278129386"
X-IronPort-AV: E=Sophos;i="5.93,274,1654585200"; 
   d="scan'208";a="278129386"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 01:00:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,274,1654585200"; 
   d="scan'208";a="939920813"
Received: from lkp-server02.sh.intel.com (HELO 77b6d4e16fc5) ([10.239.97.151])
  by fmsmga005.fm.intel.com with ESMTP; 30 Aug 2022 00:59:54 -0700
Received: from kbuild by 77b6d4e16fc5 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oSwA5-00003W-2n;
        Tue, 30 Aug 2022 07:59:53 +0000
Date:   Tue, 30 Aug 2022 15:59:28 +0800
From:   kernel test robot <lkp@intel.com>
To:     Mazin Al Haddad <mazinalhaddad05@gmail.com>, pontus.fuchs@gmail.com
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org, kvalo@kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        skhan@linuxfoundation.org,
        Mazin Al Haddad <mazinalhaddad05@gmail.com>,
        syzbot+1bc2c2afd44f820a669f@syzkaller.appspotmail.com
Subject: Re: [PATCH v3] ar5523: check endpoints type and direction in probe()
Message-ID: <202208301536.yCbVfZ1a-lkp@intel.com>
References: <20220827110148.203104-1-mazinalhaddad05@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220827110148.203104-1-mazinalhaddad05@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Mazin,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on wireless-next/main]
[also build test ERROR on wireless/main linus/master v6.0-rc3 next-20220829]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Mazin-Al-Haddad/ar5523-check-endpoints-type-and-direction-in-probe/20220827-190333
base:   https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git main
config: i386-randconfig-a016-20220829 (https://download.01.org/0day-ci/archive/20220830/202208301536.yCbVfZ1a-lkp@intel.com/config)
compiler: clang version 14.0.6 (https://github.com/llvm/llvm-project f28c006a5895fc0e329fe15fead81e37457cb1d1)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/0c1dd42c9cfa5b58485b12b4f27e1539fcb8b9dd
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Mazin-Al-Haddad/ar5523-check-endpoints-type-and-direction-in-probe/20220827-190333
        git checkout 0c1dd42c9cfa5b58485b12b4f27e1539fcb8b9dd
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash drivers/net/wireless/ath/ar5523/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All error/warnings (new ones prefixed by >>):

>> drivers/net/wireless/ath/ar5523/ar5523.c:1620:41: error: too few arguments provided to function-like macro invocation
                   dev_warn("wrong number of endpoints\n");
                                                         ^
   include/linux/dev_printk.h:145:9: note: macro 'dev_warn' defined here
   #define dev_warn(dev, fmt, ...) \
           ^
>> drivers/net/wireless/ath/ar5523/ar5523.c:1620:3: error: use of undeclared identifier 'dev_warn'; did you mean '_dev_warn'?
                   dev_warn("wrong number of endpoints\n");
                   ^~~~~~~~
                   _dev_warn
   include/linux/dev_printk.h:52:6: note: '_dev_warn' declared here
   void _dev_warn(const struct device *dev, const char *fmt, ...);
        ^
>> drivers/net/wireless/ath/ar5523/ar5523.c:1620:3: warning: expression result unused [-Wunused-value]
                   dev_warn("wrong number of endpoints\n");
                   ^~~~~~~~
   1 warning and 2 errors generated.


vim +1620 drivers/net/wireless/ath/ar5523/ar5523.c

  1577	
  1578	static int ar5523_probe(struct usb_interface *intf,
  1579				const struct usb_device_id *id)
  1580	{
  1581		struct usb_device *dev = interface_to_usbdev(intf);
  1582		struct ieee80211_hw *hw;
  1583		struct ar5523 *ar;
  1584		struct usb_host_interface *host = intf->cur_altsetting;
  1585		struct usb_endpoint_descriptor *cmd_tx, *cmd_rx, *data_tx, *data_rx;
  1586		int error = -ENOMEM;
  1587	
  1588		if (host->desc.bNumEndpoints != 4) {
  1589			dev_err(&dev->dev, "Wrong number of endpoints\n");
  1590			return -ENODEV;
  1591		}
  1592	
  1593		for (int i = 0; i < host->desc.bNumEndpoints; ++i) {
  1594			struct usb_endpoint_descriptor *ep = &host->endpoint[i].desc;
  1595	
  1596			if (usb_endpoint_is_bulk_out(ep)) {
  1597				if (!cmd_tx) {
  1598					if (ep->bEndpointAddress == AR5523_CMD_TX_PIPE)
  1599						cmd_tx = ep;
  1600				}
  1601				if (!data_tx) {
  1602					if (ep->bEndpointAddress == AR5523_DATA_TX_PIPE)
  1603						data_tx = ep;
  1604					}
  1605			}
  1606	
  1607			if (usb_endpoint_is_bulk_in(ep)) {
  1608				if (!cmd_rx) {
  1609					if (ep->bEndpointAddress == AR5523_CMD_RX_PIPE)
  1610						cmd_rx = ep;
  1611				}
  1612				if (!data_rx) {
  1613					if (ep->bEndpointAddress == AR5523_DATA_RX_PIPE)
  1614						data_rx = ep;
  1615				}
  1616			}
  1617		}
  1618	
  1619		if (!cmd_tx || !data_tx || !cmd_rx || !data_rx) {
> 1620			dev_warn("wrong number of endpoints\n");
  1621			return -ENODEV;
  1622		}
  1623	
  1624		/*
  1625		 * Load firmware if the device requires it.  This will return
  1626		 * -ENXIO on success and we'll get called back afer the usb
  1627		 * id changes to indicate that the firmware is present.
  1628		 */
  1629		if (id->driver_info & AR5523_FLAG_PRE_FIRMWARE)
  1630			return ar5523_load_firmware(dev);
  1631	
  1632	
  1633		hw = ieee80211_alloc_hw(sizeof(*ar), &ar5523_ops);
  1634		if (!hw)
  1635			goto out;
  1636		SET_IEEE80211_DEV(hw, &intf->dev);
  1637	
  1638		ar = hw->priv;
  1639		ar->hw = hw;
  1640		ar->dev = dev;
  1641		mutex_init(&ar->mutex);
  1642	
  1643		INIT_DELAYED_WORK(&ar->stat_work, ar5523_stat_work);
  1644		timer_setup(&ar->tx_wd_timer, ar5523_tx_wd_timer, 0);
  1645		INIT_WORK(&ar->tx_wd_work, ar5523_tx_wd_work);
  1646		INIT_WORK(&ar->tx_work, ar5523_tx_work);
  1647		INIT_LIST_HEAD(&ar->tx_queue_pending);
  1648		INIT_LIST_HEAD(&ar->tx_queue_submitted);
  1649		spin_lock_init(&ar->tx_data_list_lock);
  1650		atomic_set(&ar->tx_nr_total, 0);
  1651		atomic_set(&ar->tx_nr_pending, 0);
  1652		init_waitqueue_head(&ar->tx_flush_waitq);
  1653	
  1654		atomic_set(&ar->rx_data_free_cnt, 0);
  1655		INIT_WORK(&ar->rx_refill_work, ar5523_rx_refill_work);
  1656		INIT_LIST_HEAD(&ar->rx_data_free);
  1657		INIT_LIST_HEAD(&ar->rx_data_used);
  1658		spin_lock_init(&ar->rx_data_list_lock);
  1659	
  1660		ar->wq = create_singlethread_workqueue("ar5523");
  1661		if (!ar->wq) {
  1662			ar5523_err(ar, "Could not create wq\n");
  1663			goto out_free_ar;
  1664		}
  1665	
  1666		error = ar5523_alloc_rx_bufs(ar);
  1667		if (error) {
  1668			ar5523_err(ar, "Could not allocate rx buffers\n");
  1669			goto out_free_wq;
  1670		}
  1671	
  1672		error = ar5523_alloc_rx_cmd(ar);
  1673		if (error) {
  1674			ar5523_err(ar, "Could not allocate rx command buffers\n");
  1675			goto out_free_rx_bufs;
  1676		}
  1677	
  1678		error = ar5523_alloc_tx_cmd(ar);
  1679		if (error) {
  1680			ar5523_err(ar, "Could not allocate tx command buffers\n");
  1681			goto out_free_rx_cmd;
  1682		}
  1683	
  1684		error = ar5523_submit_rx_cmd(ar);
  1685		if (error) {
  1686			ar5523_err(ar, "Failed to submit rx cmd\n");
  1687			goto out_free_tx_cmd;
  1688		}
  1689	
  1690		/*
  1691		 * We're now ready to send/receive firmware commands.
  1692		 */
  1693		error = ar5523_host_available(ar);
  1694		if (error) {
  1695			ar5523_err(ar, "could not initialize adapter\n");
  1696			goto out_cancel_rx_cmd;
  1697		}
  1698	
  1699		error = ar5523_get_max_rxsz(ar);
  1700		if (error) {
  1701			ar5523_err(ar, "could not get caps from adapter\n");
  1702			goto out_cancel_rx_cmd;
  1703		}
  1704	
  1705		error = ar5523_get_devcap(ar);
  1706		if (error) {
  1707			ar5523_err(ar, "could not get caps from adapter\n");
  1708			goto out_cancel_rx_cmd;
  1709		}
  1710	
  1711		error = ar5523_get_devstatus(ar);
  1712		if (error != 0) {
  1713			ar5523_err(ar, "could not get device status\n");
  1714			goto out_cancel_rx_cmd;
  1715		}
  1716	
  1717		ar5523_info(ar, "MAC/BBP AR5523, RF AR%c112\n",
  1718				(id->driver_info & AR5523_FLAG_ABG) ? '5' : '2');
  1719	
  1720		ar->vif = NULL;
  1721		ieee80211_hw_set(hw, HAS_RATE_CONTROL);
  1722		ieee80211_hw_set(hw, RX_INCLUDES_FCS);
  1723		ieee80211_hw_set(hw, SIGNAL_DBM);
  1724		hw->extra_tx_headroom = sizeof(struct ar5523_tx_desc) +
  1725					sizeof(struct ar5523_chunk);
  1726		hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
  1727		hw->queues = 1;
  1728	
  1729		error = ar5523_init_modes(ar);
  1730		if (error)
  1731			goto out_cancel_rx_cmd;
  1732	
  1733		wiphy_ext_feature_set(hw->wiphy, NL80211_EXT_FEATURE_CQM_RSSI_LIST);
  1734	
  1735		usb_set_intfdata(intf, hw);
  1736	
  1737		error = ieee80211_register_hw(hw);
  1738		if (error) {
  1739			ar5523_err(ar, "could not register device\n");
  1740			goto out_cancel_rx_cmd;
  1741		}
  1742	
  1743		ar5523_info(ar, "Found and initialized AR5523 device\n");
  1744		return 0;
  1745	
  1746	out_cancel_rx_cmd:
  1747		ar5523_cancel_rx_cmd(ar);
  1748	out_free_tx_cmd:
  1749		ar5523_free_tx_cmd(ar);
  1750	out_free_rx_cmd:
  1751		ar5523_free_rx_cmd(ar);
  1752	out_free_rx_bufs:
  1753		ar5523_free_rx_bufs(ar);
  1754	out_free_wq:
  1755		destroy_workqueue(ar->wq);
  1756	out_free_ar:
  1757		ieee80211_free_hw(hw);
  1758	out:
  1759		return error;
  1760	}
  1761	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
