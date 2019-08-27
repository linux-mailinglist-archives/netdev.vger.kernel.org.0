Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2865A9F1EC
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 19:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729570AbfH0R4a convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 27 Aug 2019 13:56:30 -0400
Received: from mga17.intel.com ([192.55.52.151]:14421 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727683AbfH0R4a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 13:56:30 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Aug 2019 10:56:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,438,1559545200"; 
   d="scan'208";a="185366003"
Received: from orsmsx104.amr.corp.intel.com ([10.22.225.131])
  by orsmga006.jf.intel.com with ESMTP; 27 Aug 2019 10:56:28 -0700
Received: from orsmsx157.amr.corp.intel.com (10.22.240.23) by
 ORSMSX104.amr.corp.intel.com (10.22.225.131) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 27 Aug 2019 10:56:28 -0700
Received: from orsmsx115.amr.corp.intel.com ([169.254.4.103]) by
 ORSMSX157.amr.corp.intel.com ([169.254.9.22]) with mapi id 14.03.0439.000;
 Tue, 27 Aug 2019 10:56:28 -0700
From:   "Fujinaka, Todd" <todd.fujinaka@intel.com>
To:     Jakub Jankowski <shasta@toxcorp.com>,
        "e1000-devel@lists.sourceforge.net" 
        <e1000-devel@lists.sourceforge.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "mhemsley@open-systems.com" <mhemsley@open-systems.com>
Subject: RE: [E1000-devel] SFP+ EEPROM readouts fail on X722 (ethtool -m:
 Invalid argument)
Thread-Topic: [E1000-devel] SFP+ EEPROM readouts fail on X722 (ethtool -m:
 Invalid argument)
Thread-Index: AQHVXP5PwhwpGcHr20eCrPRU65J/y6cPRwGQ
Date:   Tue, 27 Aug 2019 17:56:28 +0000
Message-ID: <9B4A1B1917080E46B64F07F2989DADD69B013DB0@ORSMSX115.amr.corp.intel.com>
References: <ec481f17-cbf4-589d-807f-736421391c71@toxcorp.com>
In-Reply-To: <ec481f17-cbf4-589d-807f-736421391c71@toxcorp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiYmY1NTA0NDgtNzZmZC00ZTZlLWI4N2EtZTQyMGEyYjdjNTJmIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoicHNsNXdUc3QzVG0wNmRCVHNnQkFOK0hOSW5MdXpjN0lGbTZMSGt0QXdEUGhnNjJXcXJ1NGVMQXJSNjR6dUhZNyJ9
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The hints should be:
# ethtool -m eth10
Cannot get module EEPROM information: Invalid argument # dmesg | tail -n 1 [  445.971974] i40e 0000:3d:00.3 eth10: Module EEPROM memory read not supported. Please update the NVM image.

# ethtool -i eth10
driver: i40e
version: 2.9.21
firmware-version: 3.31 0x80000d31 1.1767.0

And the working case:
# ethtool -i eth8
driver: i40e
version: 2.9.21
firmware-version: 6.01 0x800035cf 1.1876.0

If you don't see it, 6.01 > 3.31.

The NVM update tool should be available on downloadcenter.intel.com

Todd Fujinaka
Software Application Engineer
Datacenter Engineering Group
Intel Corporation
todd.fujinaka@intel.com


-----Original Message-----
From: Jakub Jankowski [mailto:shasta@toxcorp.com] 
Sent: Tuesday, August 27, 2019 4:03 AM
To: e1000-devel@lists.sourceforge.net
Cc: netdev@vger.kernel.org; shasta@toxcorp.com; mhemsley@open-systems.com
Subject: [E1000-devel] SFP+ EEPROM readouts fail on X722 (ethtool -m: Invalid argument)

Hi,

We can't get SFP+ EEPROM readouts for X722 to work at all:

# ethtool -m eth10
Cannot get module EEPROM information: Invalid argument # dmesg | tail -n 1 [  445.971974] i40e 0000:3d:00.3 eth10: Module EEPROM memory read not supported. Please update the NVM image.
# lspci | grep 3d:00.3
3d:00.3 Ethernet controller: Intel Corporation Ethernet Connection X722 for 10GbE SFP+ (rev 09)


We're running 4.19.65 kernel at the moment, testing using the newest out-of-tree Intel module

# modinfo -F version i40e
2.9.21

We also tried:
- 4.19.65 with in-tree i40e (2.3.2-k)
- stock Arch Linux (kernel 5.2.5, driver 2.8.20-k) and the results are the same, as shown above.

# ethtool -i eth10
driver: i40e
version: 2.9.21
firmware-version: 3.31 0x80000d31 1.1767.0
expansion-rom-version:
bus-info: 0000:3d:00.3
supports-statistics: yes
supports-test: yes
supports-eeprom-access: yes
supports-register-dump: yes
supports-priv-flags: yes
# dmidecode -s baseboard-manufacturer
Intel Corporation
# dmidecode -s baseboard-product-name
S2600WFT
# dmidecode -s baseboard-version
H48104-853

# lspci -vvv
(...)
3d:00.3 Ethernet controller: Intel Corporation Ethernet Connection X722 for 10GbE SFP+ (rev 09)
	DeviceName: Intel PCH Integrated 10 Gigabit Ethernet Controller
	Subsystem: Intel Corporation Ethernet Connection X722 for 10GbE SFP+
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 112
	NUMA node: 0
	Region 0: Memory at ab000000 (64-bit, prefetchable) [size=16M]
	Region 3: Memory at b0000000 (64-bit, prefetchable) [size=32K]
	Expansion ROM at <ignored> [disabled]
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=1 PME-
	Capabilities: [50] MSI: Enable- Count=1/1 Maskable+ 64bit+
		Address: 0000000000000000  Data: 0000
		Masking: 00000000  Pending: 00000000
	Capabilities: [70] MSI-X: Enable+ Count=129 Masked-
		Vector table: BAR=3 offset=00000000
		PBA: BAR=3 offset=00001000
	Capabilities: [a0] Express (v2) Endpoint, MSI 00
		DevCap:	MaxPayload 512 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset+ SlotPowerLimit 0.000W
		DevCtl:	CorrErr+ NonFatalErr+ FatalErr+ UnsupReq+
			RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop- FLReset-
			MaxPayload 256 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ NonFatalErr- FatalErr- UnsupReq+ AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit Latency L0s <64ns, L1 <1us
			ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp+
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s (ok), Width x1 (ok)
			TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Range AB, TimeoutDis+, LTR-, OBFF Not Supported
			 AtomicOpsCap: 32bit- 64bit- 128bitCAS-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF Disabled
			 AtomicOpsCtl: ReqEn-
		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-, EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [e0] Vital Product Data
		Product Name: Example VPD
		Read-only fields:
			[V0] Vendor specific:
			[RV] Reserved: checksum good, 0 byte(s) reserved
		End
	Capabilities: [100 v2] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
		UESvrt:	DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr+
		AERCap:	First Error Pointer: 00, ECRCGenCap+ ECRCGenEn- ECRCChkCap+ ECRCChkEn-
			MultHdrRecCap- MultHdrRecEn- TLPPfxPres- HdrLogCap-
		HeaderLog: 00000000 00000000 00000000 00000000
	Capabilities: [150 v1] Alternative Routing-ID Interpretation (ARI)
		ARICap:	MFVC- ACS-, Next Function: 0
		ARICtl:	MFVC- ACS-, Function Group: 0
	Capabilities: [160 v1] Single Root I/O Virtualization (SR-IOV)
		IOVCap:	Migration-, Interrupt Message Number: 000
		IOVCtl:	Enable- Migration- Interrupt- MSE- ARIHierarchy-
		IOVSta:	Migration-
		Initial VFs: 32, Total VFs: 32, Number of VFs: 0, Function Dependency Link: 03
		VF offset: 109, stride: 1, Device ID: 37cd
		Supported Page Size: 00000553, System Page Size: 00000001
		Region 0: Memory at 00000000af000000 (64-bit, prefetchable)
		Region 3: Memory at 00000000b0020000 (64-bit, prefetchable)
		VF Migration: offset: 00000000, BIR: 0
	Capabilities: [1a0 v1] Transaction Processing Hints
		Device specific mode supported
		No steering table available
	Capabilities: [1b0 v1] Access Control Services
		ACSCap:	SrcValid- TransBlk- ReqRedir- CmpltRedir- UpstreamFwd- EgressCtrl- DirectTrans-
		ACSCtl:	SrcValid- TransBlk- ReqRedir- CmpltRedir- UpstreamFwd- EgressCtrl- DirectTrans-
	Kernel driver in use: i40e
	Kernel modules: i40e


Same kernel+i40e, same SFP+ module - but on Intel X710, works like a treat:

# lspci | grep X7
81:00.0 Ethernet controller: Intel Corporation Ethernet Controller X710 for 10GbE SFP+ (rev 01)
81:00.1 Ethernet controller: Intel Corporation Ethernet Controller X710 for 10GbE SFP+ (rev 01) # ethtool -m eth8
	Identifier                                : 0x03 (SFP)
	Extended identifier                       : 0x04 (GBIC/SFP defined by 2-wire interface ID)
	Connector                                 : 0x07 (LC)
	Transceiver codes                         : 0x10 0x00 0x00 0x01 0x00 0x00 0x00 0x00 0x00
	Transceiver type                          : 10G Ethernet: 10G Base-SR
	Transceiver type                          : Ethernet: 1000BASE-SX
	Encoding                                  : 0x06 (64B/66B)
	BR, Nominal                               : 10300MBd
         (...)
# ethtool -i eth8
driver: i40e
version: 2.9.21
firmware-version: 6.01 0x800035cf 1.1876.0
expansion-rom-version:
bus-info: 0000:81:00.0
supports-statistics: yes
supports-test: yes
supports-eeprom-access: yes
supports-register-dump: yes
supports-priv-flags: yes
#


Is this a known problem?


Best regards,
  Jakub



_______________________________________________
E1000-devel mailing list
E1000-devel@lists.sourceforge.net
https://lists.sourceforge.net/lists/listinfo/e1000-devel
To learn more about Intel&#174; Ethernet, visit http://communities.intel.com/community/wired
