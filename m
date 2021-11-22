Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19D33458CE2
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 12:01:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232866AbhKVLFA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 06:05:00 -0500
Received: from mga18.intel.com ([134.134.136.126]:51766 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229542AbhKVLE6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Nov 2021 06:04:58 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10175"; a="221647368"
X-IronPort-AV: E=Sophos;i="5.87,254,1631602800"; 
   d="gz'50?scan'50,208,50";a="221647368"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2021 03:01:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,254,1631602800"; 
   d="gz'50?scan'50,208,50";a="456241507"
Received: from lkp-server02.sh.intel.com (HELO 9e1e9f9b3bcb) ([10.239.97.151])
  by orsmga003.jf.intel.com with ESMTP; 22 Nov 2021 03:01:47 -0800
Received: from kbuild by 9e1e9f9b3bcb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1mp750-000062-LK; Mon, 22 Nov 2021 11:01:46 +0000
Date:   Mon, 22 Nov 2021 19:00:55 +0800
From:   kernel test robot <lkp@intel.com>
To:     Manish Mandlik <mmandlik@google.com>, marcel@holtmann.org,
        luiz.dentz@gmail.com
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        linux-bluetooth@vger.kernel.org,
        chromeos-bluetooth-upstreaming@chromium.org,
        Manish Mandlik <mmandlik@google.com>,
        Miao-chen Chou <mcchou@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v6 2/2] bluetooth: Add MGMT Adv Monitor Device Found/Lost
 events
Message-ID: <202111221858.90k9xMmG-lkp@intel.com>
References: <20211121110853.v6.2.I9eda306e4c542010535dc49b5488946af592795e@changeid>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="bg08WKrSYDhXBjb5"
Content-Disposition: inline
In-Reply-To: <20211121110853.v6.2.I9eda306e4c542010535dc49b5488946af592795e@changeid>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Manish,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on bluetooth-next/master]
[also build test WARNING on next-20211118]
[cannot apply to bluetooth/master v5.16-rc2]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Manish-Mandlik/bluetooth-Handle-MSFT-Monitor-Device-Event/20211122-031347
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git master
config: hexagon-randconfig-r005-20211122 (attached as .config)
compiler: clang version 14.0.0 (https://github.com/llvm/llvm-project c133fb321f7ca6083ce15b6aa5bf89de6600e649)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/b61f97a7820d3965cf6e5bbf719449c667bf1925
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Manish-Mandlik/bluetooth-Handle-MSFT-Monitor-Device-Event/20211122-031347
        git checkout b61f97a7820d3965cf6e5bbf719449c667bf1925
        # save the attached .config to linux build tree
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 ARCH=hexagon 

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> net/bluetooth/mgmt.c:9601:6: warning: stack frame size (1120) exceeds limit (1024) in 'mgmt_device_found' [-Wframe-larger-than]
   void mgmt_device_found(struct hci_dev *hdev, bdaddr_t *bdaddr, u8 link_type,
        ^
   1 warning generated.


vim +/mgmt_device_found +9601 net/bluetooth/mgmt.c

b61f97a7820d39 Manish Mandlik  2021-11-21  9600  
48f86b7f267335 Jakub Pawlowski 2015-03-04 @9601  void mgmt_device_found(struct hci_dev *hdev, bdaddr_t *bdaddr, u8 link_type,
48f86b7f267335 Jakub Pawlowski 2015-03-04  9602  		       u8 addr_type, u8 *dev_class, s8 rssi, u32 flags,
48f86b7f267335 Jakub Pawlowski 2015-03-04  9603  		       u8 *eir, u16 eir_len, u8 *scan_rsp, u8 scan_rsp_len)
48f86b7f267335 Jakub Pawlowski 2015-03-04  9604  {
48f86b7f267335 Jakub Pawlowski 2015-03-04  9605  	char buf[512];
48f86b7f267335 Jakub Pawlowski 2015-03-04  9606  	struct mgmt_ev_device_found *ev = (void *)buf;
48f86b7f267335 Jakub Pawlowski 2015-03-04  9607  	size_t ev_size;
48f86b7f267335 Jakub Pawlowski 2015-03-04  9608  
48f86b7f267335 Jakub Pawlowski 2015-03-04  9609  	/* Don't send events for a non-kernel initiated discovery. With
48f86b7f267335 Jakub Pawlowski 2015-03-04  9610  	 * LE one exception is if we have pend_le_reports > 0 in which
48f86b7f267335 Jakub Pawlowski 2015-03-04  9611  	 * case we're doing passive scanning and want these events.
48f86b7f267335 Jakub Pawlowski 2015-03-04  9612  	 */
48f86b7f267335 Jakub Pawlowski 2015-03-04  9613  	if (!hci_discovery_active(hdev)) {
48f86b7f267335 Jakub Pawlowski 2015-03-04  9614  		if (link_type == ACL_LINK)
48f86b7f267335 Jakub Pawlowski 2015-03-04  9615  			return;
8208f5a9d435e5 Miao-chen Chou  2020-06-17  9616  		if (link_type == LE_LINK &&
8208f5a9d435e5 Miao-chen Chou  2020-06-17  9617  		    list_empty(&hdev->pend_le_reports) &&
8208f5a9d435e5 Miao-chen Chou  2020-06-17  9618  		    !hci_is_adv_monitoring(hdev)) {
48f86b7f267335 Jakub Pawlowski 2015-03-04  9619  			return;
48f86b7f267335 Jakub Pawlowski 2015-03-04  9620  		}
8208f5a9d435e5 Miao-chen Chou  2020-06-17  9621  	}
48f86b7f267335 Jakub Pawlowski 2015-03-04  9622  
82f8b651a94d5c Jakub Pawlowski 2015-03-04  9623  	if (hdev->discovery.result_filtering) {
48f86b7f267335 Jakub Pawlowski 2015-03-04  9624  		/* We are using service discovery */
48f86b7f267335 Jakub Pawlowski 2015-03-04  9625  		if (!is_filter_match(hdev, rssi, eir, eir_len, scan_rsp,
48f86b7f267335 Jakub Pawlowski 2015-03-04  9626  				     scan_rsp_len))
48f86b7f267335 Jakub Pawlowski 2015-03-04  9627  			return;
48f86b7f267335 Jakub Pawlowski 2015-03-04  9628  	}
48f86b7f267335 Jakub Pawlowski 2015-03-04  9629  
78b781ca0d3519 Johan Hedberg   2016-01-05  9630  	if (hdev->discovery.limited) {
78b781ca0d3519 Johan Hedberg   2016-01-05  9631  		/* Check for limited discoverable bit */
78b781ca0d3519 Johan Hedberg   2016-01-05  9632  		if (dev_class) {
78b781ca0d3519 Johan Hedberg   2016-01-05  9633  			if (!(dev_class[1] & 0x20))
78b781ca0d3519 Johan Hedberg   2016-01-05  9634  				return;
78b781ca0d3519 Johan Hedberg   2016-01-05  9635  		} else {
78b781ca0d3519 Johan Hedberg   2016-01-05  9636  			u8 *flags = eir_get_data(eir, eir_len, EIR_FLAGS, NULL);
78b781ca0d3519 Johan Hedberg   2016-01-05  9637  			if (!flags || !(flags[0] & LE_AD_LIMITED))
78b781ca0d3519 Johan Hedberg   2016-01-05  9638  				return;
78b781ca0d3519 Johan Hedberg   2016-01-05  9639  		}
78b781ca0d3519 Johan Hedberg   2016-01-05  9640  	}
78b781ca0d3519 Johan Hedberg   2016-01-05  9641  
48f86b7f267335 Jakub Pawlowski 2015-03-04  9642  	/* Make sure that the buffer is big enough. The 5 extra bytes
48f86b7f267335 Jakub Pawlowski 2015-03-04  9643  	 * are for the potential CoD field.
48f86b7f267335 Jakub Pawlowski 2015-03-04  9644  	 */
48f86b7f267335 Jakub Pawlowski 2015-03-04  9645  	if (sizeof(*ev) + eir_len + scan_rsp_len + 5 > sizeof(buf))
4b0e0ceddf085a Jakub Pawlowski 2015-02-01  9646  		return;
4b0e0ceddf085a Jakub Pawlowski 2015-02-01  9647  
48f86b7f267335 Jakub Pawlowski 2015-03-04  9648  	memset(buf, 0, sizeof(buf));
48f86b7f267335 Jakub Pawlowski 2015-03-04  9649  
48f86b7f267335 Jakub Pawlowski 2015-03-04  9650  	/* In case of device discovery with BR/EDR devices (pre 1.2), the
48f86b7f267335 Jakub Pawlowski 2015-03-04  9651  	 * RSSI value was reported as 0 when not available. This behavior
48f86b7f267335 Jakub Pawlowski 2015-03-04  9652  	 * is kept when using device discovery. This is required for full
48f86b7f267335 Jakub Pawlowski 2015-03-04  9653  	 * backwards compatibility with the API.
48f86b7f267335 Jakub Pawlowski 2015-03-04  9654  	 *
48f86b7f267335 Jakub Pawlowski 2015-03-04  9655  	 * However when using service discovery, the value 127 will be
48f86b7f267335 Jakub Pawlowski 2015-03-04  9656  	 * returned when the RSSI is not available.
48f86b7f267335 Jakub Pawlowski 2015-03-04  9657  	 */
48f86b7f267335 Jakub Pawlowski 2015-03-04  9658  	if (rssi == HCI_RSSI_INVALID && !hdev->discovery.report_invalid_rssi &&
48f86b7f267335 Jakub Pawlowski 2015-03-04  9659  	    link_type == ACL_LINK)
48f86b7f267335 Jakub Pawlowski 2015-03-04  9660  		rssi = 0;
48f86b7f267335 Jakub Pawlowski 2015-03-04  9661  
48f86b7f267335 Jakub Pawlowski 2015-03-04  9662  	bacpy(&ev->addr.bdaddr, bdaddr);
48f86b7f267335 Jakub Pawlowski 2015-03-04  9663  	ev->addr.type = link_to_bdaddr(link_type, addr_type);
48f86b7f267335 Jakub Pawlowski 2015-03-04  9664  	ev->rssi = rssi;
48f86b7f267335 Jakub Pawlowski 2015-03-04  9665  	ev->flags = cpu_to_le32(flags);
48f86b7f267335 Jakub Pawlowski 2015-03-04  9666  
48f86b7f267335 Jakub Pawlowski 2015-03-04  9667  	if (eir_len > 0)
48f86b7f267335 Jakub Pawlowski 2015-03-04  9668  		/* Copy EIR or advertising data into event */
48f86b7f267335 Jakub Pawlowski 2015-03-04  9669  		memcpy(ev->eir, eir, eir_len);
48f86b7f267335 Jakub Pawlowski 2015-03-04  9670  
0d3b7f64c84d53 Johan Hedberg   2016-01-05  9671  	if (dev_class && !eir_get_data(ev->eir, eir_len, EIR_CLASS_OF_DEV,
0d3b7f64c84d53 Johan Hedberg   2016-01-05  9672  				       NULL))
48f86b7f267335 Jakub Pawlowski 2015-03-04  9673  		eir_len = eir_append_data(ev->eir, eir_len, EIR_CLASS_OF_DEV,
48f86b7f267335 Jakub Pawlowski 2015-03-04  9674  					  dev_class, 3);
48f86b7f267335 Jakub Pawlowski 2015-03-04  9675  
48f86b7f267335 Jakub Pawlowski 2015-03-04  9676  	if (scan_rsp_len > 0)
48f86b7f267335 Jakub Pawlowski 2015-03-04  9677  		/* Append scan response data to event */
48f86b7f267335 Jakub Pawlowski 2015-03-04  9678  		memcpy(ev->eir + eir_len, scan_rsp, scan_rsp_len);
48f86b7f267335 Jakub Pawlowski 2015-03-04  9679  
5d2e9fadf43e87 Johan Hedberg   2014-03-25  9680  	ev->eir_len = cpu_to_le16(eir_len + scan_rsp_len);
5d2e9fadf43e87 Johan Hedberg   2014-03-25  9681  	ev_size = sizeof(*ev) + eir_len + scan_rsp_len;
f8523598ee608a Andre Guedes    2011-09-09  9682  
b61f97a7820d39 Manish Mandlik  2021-11-21  9683  	/* We have received the Advertisement Report because:
b61f97a7820d39 Manish Mandlik  2021-11-21  9684  	 * 1. the kernel has initiated active discovery
b61f97a7820d39 Manish Mandlik  2021-11-21  9685  	 * 2. if not, we have pend_le_reports > 0 in which case we are doing
b61f97a7820d39 Manish Mandlik  2021-11-21  9686  	 *    passive scanning
b61f97a7820d39 Manish Mandlik  2021-11-21  9687  	 * 3. if none of the above is true, we have one or more active
b61f97a7820d39 Manish Mandlik  2021-11-21  9688  	 *    Advertisement Monitor
b61f97a7820d39 Manish Mandlik  2021-11-21  9689  	 *
b61f97a7820d39 Manish Mandlik  2021-11-21  9690  	 * For case 1 and 2, report all advertisements via MGMT_EV_DEVICE_FOUND
b61f97a7820d39 Manish Mandlik  2021-11-21  9691  	 * and report ONLY one advertisement per device for the matched Monitor
b61f97a7820d39 Manish Mandlik  2021-11-21  9692  	 * via MGMT_EV_ADV_MONITOR_DEVICE_FOUND event.
b61f97a7820d39 Manish Mandlik  2021-11-21  9693  	 *
b61f97a7820d39 Manish Mandlik  2021-11-21  9694  	 * For case 3, since we are not active scanning and all advertisements
b61f97a7820d39 Manish Mandlik  2021-11-21  9695  	 * received are due to a matched Advertisement Monitor, report all
b61f97a7820d39 Manish Mandlik  2021-11-21  9696  	 * advertisements ONLY via MGMT_EV_ADV_MONITOR_DEVICE_FOUND event.
b61f97a7820d39 Manish Mandlik  2021-11-21  9697  	 */
b61f97a7820d39 Manish Mandlik  2021-11-21  9698  
b61f97a7820d39 Manish Mandlik  2021-11-21  9699  	if (hci_discovery_active(hdev) ||
b61f97a7820d39 Manish Mandlik  2021-11-21  9700  	    (link_type == LE_LINK && !list_empty(&hdev->pend_le_reports))) {
901801b9a420e5 Marcel Holtmann 2013-10-06  9701  		mgmt_event(MGMT_EV_DEVICE_FOUND, hdev, ev, ev_size, NULL);
b61f97a7820d39 Manish Mandlik  2021-11-21  9702  
b61f97a7820d39 Manish Mandlik  2021-11-21  9703  		if (hdev->advmon_pend_notify)
b61f97a7820d39 Manish Mandlik  2021-11-21  9704  			mgmt_adv_monitor_device_found(hdev, ev, ev_size, true);
b61f97a7820d39 Manish Mandlik  2021-11-21  9705  	} else {
b61f97a7820d39 Manish Mandlik  2021-11-21  9706  		mgmt_adv_monitor_device_found(hdev, ev, ev_size, false);
b61f97a7820d39 Manish Mandlik  2021-11-21  9707  	}
e17acd40f6006d Johan Hedberg   2011-03-30  9708  }
a88a9652d25a63 Johan Hedberg   2011-03-30  9709  

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--bg08WKrSYDhXBjb5
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--bg08WKrSYDhXBjb5--
