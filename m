Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 229F19FB4B
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 09:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726272AbfH1HSe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 03:18:34 -0400
Received: from smark.slackware.pl ([88.198.48.135]:52688 "EHLO
        smark.slackware.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726232AbfH1HSd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 03:18:33 -0400
Received: from dirac.toxcorp.com (unknown [172.22.22.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: shasta@toxcorp.com)
        by smark.slackware.pl (Postfix) with ESMTPSA id ADD95200A7;
        Wed, 28 Aug 2019 09:18:30 +0200 (CEST)
Subject: Re: [E1000-devel] SFP+ EEPROM readouts fail on X722 (ethtool -m:
 Invalid argument)
To:     "Fujinaka, Todd" <todd.fujinaka@intel.com>,
        "e1000-devel@lists.sourceforge.net" 
        <e1000-devel@lists.sourceforge.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "mhemsley@open-systems.com" <mhemsley@open-systems.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Lihong Yang <lihong.yang@intel.com>
References: <ec481f17-cbf4-589d-807f-736421391c71@toxcorp.com>
 <9B4A1B1917080E46B64F07F2989DADD69B013DB0@ORSMSX115.amr.corp.intel.com>
 <34ba28aa-44a5-8a6c-c8c4-b92a16f952ad@toxcorp.com>
 <9B4A1B1917080E46B64F07F2989DADD69B01402F@ORSMSX115.amr.corp.intel.com>
From:   Jakub Jankowski <shasta@toxcorp.com>
Message-ID: <1277a516-78ac-8bcd-64ac-d97a260451bc@toxcorp.com>
Date:   Wed, 28 Aug 2019 09:18:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <9B4A1B1917080E46B64F07F2989DADD69B01402F@ORSMSX115.amr.corp.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit suggests that it should be possible: 
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=c271dd6c391b535226cf1a81aaad9f33cb5899d3
(It has been in upstream kernel since v4.12, so my test kernel does have 
it, and so does the out-of-tree driver I'm testing with)

On 8/28/19 2:53 AM, Fujinaka, Todd wrote:
> Sorry about the top posting, but if I don't do it this way I can't read anything in Outlook (not my preferred MUA).
>
> I think I may have been wrong about things. I'm not as familiar with the x722, and the NVM versions are completely different than the x710 and I was confused.
>
> Even worse, I'm not sure if the x722 is able to read the data from the SFP/SFP+ EEPROM. I remembered that was a feature we requested internally but I don't remember what the progress was.
>
> I'm asking around to see if I can get clarification. I haven't heard anything yet.
>
> Todd Fujinaka
> Software Application Engineer
> Datacenter Engineering Group
> Intel Corporation
> todd.fujinaka@intel.com
>
>
> -----Original Message-----
> From: Jakub Jankowski [mailto:shasta@toxcorp.com]
> Sent: Tuesday, August 27, 2019 4:01 PM
> To: Fujinaka, Todd <todd.fujinaka@intel.com>; e1000-devel@lists.sourceforge.net
> Cc: netdev@vger.kernel.org; mhemsley@open-systems.com
> Subject: Re: [E1000-devel] SFP+ EEPROM readouts fail on X722 (ethtool -m: Invalid argument)
>
> Hi,
>
> On 8/27/19 7:56 PM, Fujinaka, Todd wrote:
>> The hints should be:
>> # ethtool -m eth10
>> Cannot get module EEPROM information: Invalid argument # dmesg | tail -n 1 [  445.971974] i40e 0000:3d:00.3 eth10: Module EEPROM memory read not supported. Please update the NVM image.
>>
>> # ethtool -i eth10
>> driver: i40e
>> version: 2.9.21
>> firmware-version: 3.31 0x80000d31 1.1767.0
>>
>> And the working case:
>> # ethtool -i eth8
>> driver: i40e
>> version: 2.9.21
>> firmware-version: 6.01 0x800035cf 1.1876.0
>>
>> If you don't see it, 6.01 > 3.31.
> The reason why firmware between the two is (that much) different is because the non-working case is from X722 NIC, while the working one is from X710.
>
>> The NVM update tool should be available on downloadcenter.intel.com
> Thanks for the pointer to NVM updater. I'd like to offer some additional comments about my experience with the newest one (v4.00):
>
> a) running ./nvmupdate64e (from X722_NVMUpdate_Linux_x64 subdir) errors out without really saying what's wrong:
>
>     # ./nvmupdate64e
>
>     Intel(R) Ethernet NVM Update Tool
>     NVMUpdate version 1.30.2.11
>     Copyright (C) 2013 - 2017 Intel Corporation.
>
>
>     WARNING: To avoid damage to your device, do not stop the update or reboot or power off the system during this update.
>     Inventory in progress. Please wait [+.........]
>     Tool execution completed with the following status: The configuration file could not be opened/read, or a syntax error was discovered in the file
>     Press any key to exit.
>
> after enabling logging (-l out.log) a bit more is revealed:
>
>     # tail -n 2 out.log
>     Error:   Config file line 2: Not supported config file version.
>     Error:   Missing CONFIG VERSION parameter in configuration file.
>
> but that's not entirely true, CONFIG VERSION is set in the default configuration file:
>
>     # head -n 2 nvmupdate.cfg
>     CURRENT FAMILY: 1.0.0
>     CONFIG VERSION: 1.14.0
>
> so why isn't this understood?
> Manually editing nvmupdate.cfg and setting CONFIG VERSION: 1.11.0 seems to make this particular problem go away.
>
> b) Re-doing this with downgraded config version exposes another problem:
>
>     Config file read.
>     Error:   Can't open NVM map file [Immediate_offset_2.txt]
>
> and indeed, there is no Immediate_offset_2.txt in NVMUpdatePackage_WFT_WFQ&WF0_v4.00/X722_NVMUpdate_Linux_x64/
> There is one, however, in
> NVMUpdatePackage_WFT_WFQ&WF0_v4.00/X722_NVMUpdate_EFIx64/ subdir.
> Copying it over to the _Linux_x64 resolves this particular problem
>
> c) Re-doing this with Immediate_offset_2.txt in place exposes third problem:
>
>     Error:   Can't open NVM image file
> [LBG_B2_Wolf_Pass_WFT_X557_P01_PHY_Auto_Detect_P23_NCSI_v3.31_800016DB.bin]
>
> and once again - same story. It exists in NVMUpdatePackage_WFT_WFQ&WF0_v4.00/X722_NVMUpdate_EFIx64/ but not NVMUpdatePackage_WFT_WFQ&WF0_v4.00/X722_NVMUpdate_Linux_x64/ - had to copy it over.
>
>
> Once I managed to get all these out of the way, the tool finally ran:
>
>     Num Description                               Ver. DevId S:B Status
>     === ======================================== ===== ===== ====== ===============
>     01) Intel(R) Ethernet Server Adapter I350-T4  1.99  1521 00:024 Update not available
>     02) Intel(R) Ethernet Connection X722 for     3.49  37D2 00:061 Update
>         10GBASE-T available
>     03) Intel(R) Ethernet Server Adapter I350-T4  1.99  1521 00:175 Update not available
>
>
> The initial starting point was:
>
> 0) firmware-version: 3.31 0x80000d31 1.1767.0
>
> After first update+reboot, this was bumped to:
>
> 1) firmware-version: 3.1d 0x800016db 1.1767.0    (but ethtool -m ethX still doesn't work)
>
> So I ran the tool the second time, it said 'Update available' again, but this time:
>
>     Num Description                               Ver. DevId S:B Status
>     === ======================================== ===== ===== ====== ===============
>     01) Intel(R) Ethernet Server Adapter I350-T4  1.99  1521 00:024 Update not available
>     02) Intel(R) Ethernet Connection X722 for     3.29  37D2 00:061 Update
>         10GBASE-T available
>     03) Intel(R) Ethernet Server Adapter I350-T4  1.99  1521 00:175 Update not available
>
>     Options: Adapter Index List (comma-separated), [A]ll, e[X]it
>     Enter selection:02
>     Would you like to back up the NVM images? [Y]es/[N]o: Y
>     Update in progress. This operation may take several minutes.
>     [*******+..]
>     Tool execution completed with the following status: <---------- why is there no status printed?
>     Press any key to exit.
>
>
> Checking output log:
>
>     # cat out3.log
>     Intel(R) Ethernet NVM Update Tool
>     NVMUpdate version 1.30.2.11
>     Copyright (C) 2013 - 2017 Intel Corporation.
>
>     ./nvmupdate64e -c nvmupdate.cfg -l out3.log
>
>     Config file read.
>     Inventory
>     [00:061:00:00]: Intel(R) Ethernet Connection X722 for 10GBASE-T
>         Flash inventory started
>         Shadow RAM inventory started
>     Alternate MAC address is not set
>         Shadow RAM inventory finished
>         Flash inventory finished
>         OROM inventory started
>         OROM inventory finished
>         PHY NVM inventory started
>         PHY NVM inventory finished
>     [00:061:00:01]: Intel(R) Ethernet Connection X722 for 10GBASE-T
>         Device already inventoried.
>     [00:061:00:02]: Intel(R) Ethernet Connection X722 for 10GbE SFP+
>         Device already inventoried.
>         PHY NVM inventory started
>         PHY NVM inventory finished
>     [00:061:00:03]: Intel(R) Ethernet Connection X722 for 10GbE SFP+
>         Device already inventoried.
>     Update
>     [00:061:00:00]: Intel(R) Ethernet Connection X722 for 10GBASE-T
>         Creating backup images in directory: A4BF0164884A
>         Backup images created.
>         Flash update started
>         NVM image verification started
>         Shadow RAM image verification started
>
>     Image differences found at offset 0x3AE [Device=0xF, Buffer=0x0] -
> update required.
>     Error:   Flash update failed
>     [00:061:00:02]: Intel(R) Ethernet Connection X722 for 10GbE SFP+
>     #
>
> However, ethtool -i suggests that firmware was updated to:
>
> 2) firmware-version: 4.00 0x80001577 1.1580.0    <------- so it did
> _something_ after all?
>
> At this point, every subsequent attempt to run the NVM updater yields
> the same results: an update is available, but attempting to apply it
> fails with the same message in log.
>
> And my initial issue still persists - ethtool -m <iface> still returns
> "invalid argument" with "Module EEPROM memory read not supported. Please
> update the NVM image" logged in dmesg.
>
> How can I resolve this?
>
> Cheers,
>    Jakub.
>
>> Todd Fujinaka
>> Software Application Engineer
>> Datacenter Engineering Group
>> Intel Corporation
>> todd.fujinaka@intel.com
>>
>>
>> -----Original Message-----
>> From: Jakub Jankowski [mailto:shasta@toxcorp.com]
>> Sent: Tuesday, August 27, 2019 4:03 AM
>> To: e1000-devel@lists.sourceforge.net
>> Cc: netdev@vger.kernel.org; shasta@toxcorp.com; mhemsley@open-systems.com
>> Subject: [E1000-devel] SFP+ EEPROM readouts fail on X722 (ethtool -m: Invalid argument)
>>
>> Hi,
>>
>> We can't get SFP+ EEPROM readouts for X722 to work at all:
>>
>> # ethtool -m eth10
>> Cannot get module EEPROM information: Invalid argument # dmesg | tail -n 1 [  445.971974] i40e 0000:3d:00.3 eth10: Module EEPROM memory read not supported. Please update the NVM image.
>> # lspci | grep 3d:00.3
>> 3d:00.3 Ethernet controller: Intel Corporation Ethernet Connection X722 for 10GbE SFP+ (rev 09)
>>
>>
>> We're running 4.19.65 kernel at the moment, testing using the newest out-of-tree Intel module
>>
>> # modinfo -F version i40e
>> 2.9.21
>>
>> We also tried:
>> - 4.19.65 with in-tree i40e (2.3.2-k)
>> - stock Arch Linux (kernel 5.2.5, driver 2.8.20-k) and the results are the same, as shown above.
>>
>> # ethtool -i eth10
>> driver: i40e
>> version: 2.9.21
>> firmware-version: 3.31 0x80000d31 1.1767.0
>> expansion-rom-version:
>> bus-info: 0000:3d:00.3
>> supports-statistics: yes
>> supports-test: yes
>> supports-eeprom-access: yes
>> supports-register-dump: yes
>> supports-priv-flags: yes
>> # dmidecode -s baseboard-manufacturer
>> Intel Corporation
>> # dmidecode -s baseboard-product-name
>> S2600WFT
>> # dmidecode -s baseboard-version
>> H48104-853
>>
>> # lspci -vvv
>> (...)
>> 3d:00.3 Ethernet controller: Intel Corporation Ethernet Connection X722 for 10GbE SFP+ (rev 09)
>> 	DeviceName: Intel PCH Integrated 10 Gigabit Ethernet Controller
>> 	Subsystem: Intel Corporation Ethernet Connection X722 for 10GbE SFP+
>> 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx+
>> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>> 	Latency: 0, Cache Line Size: 32 bytes
>> 	Interrupt: pin A routed to IRQ 112
>> 	NUMA node: 0
>> 	Region 0: Memory at ab000000 (64-bit, prefetchable) [size=16M]
>> 	Region 3: Memory at b0000000 (64-bit, prefetchable) [size=32K]
>> 	Expansion ROM at <ignored> [disabled]
>> 	Capabilities: [40] Power Management version 3
>> 		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
>> 		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=1 PME-
>> 	Capabilities: [50] MSI: Enable- Count=1/1 Maskable+ 64bit+
>> 		Address: 0000000000000000  Data: 0000
>> 		Masking: 00000000  Pending: 00000000
>> 	Capabilities: [70] MSI-X: Enable+ Count=129 Masked-
>> 		Vector table: BAR=3 offset=00000000
>> 		PBA: BAR=3 offset=00001000
>> 	Capabilities: [a0] Express (v2) Endpoint, MSI 00
>> 		DevCap:	MaxPayload 512 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
>> 			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset+ SlotPowerLimit 0.000W
>> 		DevCtl:	CorrErr+ NonFatalErr+ FatalErr+ UnsupReq+
>> 			RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop- FLReset-
>> 			MaxPayload 256 bytes, MaxReadReq 512 bytes
>> 		DevSta:	CorrErr+ NonFatalErr- FatalErr- UnsupReq+ AuxPwr+ TransPend-
>> 		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit Latency L0s <64ns, L1 <1us
>> 			ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp+
>> 		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- CommClk+
>> 			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>> 		LnkSta:	Speed 2.5GT/s (ok), Width x1 (ok)
>> 			TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
>> 		DevCap2: Completion Timeout: Range AB, TimeoutDis+, LTR-, OBFF Not Supported
>> 			 AtomicOpsCap: 32bit- 64bit- 128bitCAS-
>> 		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF Disabled
>> 			 AtomicOpsCtl: ReqEn-
>> 		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-, EqualizationPhase1-
>> 			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
>> 	Capabilities: [e0] Vital Product Data
>> 		Product Name: Example VPD
>> 		Read-only fields:
>> 			[V0] Vendor specific:
>> 			[RV] Reserved: checksum good, 0 byte(s) reserved
>> 		End
>> 	Capabilities: [100 v2] Advanced Error Reporting
>> 		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
>> 		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
>> 		UESvrt:	DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
>> 		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr+
>> 		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr+
>> 		AERCap:	First Error Pointer: 00, ECRCGenCap+ ECRCGenEn- ECRCChkCap+ ECRCChkEn-
>> 			MultHdrRecCap- MultHdrRecEn- TLPPfxPres- HdrLogCap-
>> 		HeaderLog: 00000000 00000000 00000000 00000000
>> 	Capabilities: [150 v1] Alternative Routing-ID Interpretation (ARI)
>> 		ARICap:	MFVC- ACS-, Next Function: 0
>> 		ARICtl:	MFVC- ACS-, Function Group: 0
>> 	Capabilities: [160 v1] Single Root I/O Virtualization (SR-IOV)
>> 		IOVCap:	Migration-, Interrupt Message Number: 000
>> 		IOVCtl:	Enable- Migration- Interrupt- MSE- ARIHierarchy-
>> 		IOVSta:	Migration-
>> 		Initial VFs: 32, Total VFs: 32, Number of VFs: 0, Function Dependency Link: 03
>> 		VF offset: 109, stride: 1, Device ID: 37cd
>> 		Supported Page Size: 00000553, System Page Size: 00000001
>> 		Region 0: Memory at 00000000af000000 (64-bit, prefetchable)
>> 		Region 3: Memory at 00000000b0020000 (64-bit, prefetchable)
>> 		VF Migration: offset: 00000000, BIR: 0
>> 	Capabilities: [1a0 v1] Transaction Processing Hints
>> 		Device specific mode supported
>> 		No steering table available
>> 	Capabilities: [1b0 v1] Access Control Services
>> 		ACSCap:	SrcValid- TransBlk- ReqRedir- CmpltRedir- UpstreamFwd- EgressCtrl- DirectTrans-
>> 		ACSCtl:	SrcValid- TransBlk- ReqRedir- CmpltRedir- UpstreamFwd- EgressCtrl- DirectTrans-
>> 	Kernel driver in use: i40e
>> 	Kernel modules: i40e
>>
>>
>> Same kernel+i40e, same SFP+ module - but on Intel X710, works like a treat:
>>
>> # lspci | grep X7
>> 81:00.0 Ethernet controller: Intel Corporation Ethernet Controller X710 for 10GbE SFP+ (rev 01)
>> 81:00.1 Ethernet controller: Intel Corporation Ethernet Controller X710 for 10GbE SFP+ (rev 01) # ethtool -m eth8
>> 	Identifier                                : 0x03 (SFP)
>> 	Extended identifier                       : 0x04 (GBIC/SFP defined by 2-wire interface ID)
>> 	Connector                                 : 0x07 (LC)
>> 	Transceiver codes                         : 0x10 0x00 0x00 0x01 0x00 0x00 0x00 0x00 0x00
>> 	Transceiver type                          : 10G Ethernet: 10G Base-SR
>> 	Transceiver type                          : Ethernet: 1000BASE-SX
>> 	Encoding                                  : 0x06 (64B/66B)
>> 	BR, Nominal                               : 10300MBd
>>            (...)
>> # ethtool -i eth8
>> driver: i40e
>> version: 2.9.21
>> firmware-version: 6.01 0x800035cf 1.1876.0
>> expansion-rom-version:
>> bus-info: 0000:81:00.0
>> supports-statistics: yes
>> supports-test: yes
>> supports-eeprom-access: yes
>> supports-register-dump: yes
>> supports-priv-flags: yes
>> #
>>
>>
>> Is this a known problem?
>>
>>
>> Best regards,
>>     Jakub
>>
>>
>>
>> _______________________________________________
>> E1000-devel mailing list
>> E1000-devel@lists.sourceforge.net
>> https://lists.sourceforge.net/lists/listinfo/e1000-devel
>> To learn more about Intel&#174; Ethernet, visit http://communities.intel.com/community/wired


-- 
Jakub Jankowski|shasta@toxcorp.com|http://toxcorp.com/
GPG: FCBF F03D 9ADB B768 8B92 BB52 0341 9037 A875 942D

