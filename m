Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 612204AC83D
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 19:10:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbiBGSGs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 13:06:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357123AbiBGSE2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 13:04:28 -0500
Received: from mxout017.mail.hostpoint.ch (mxout017.mail.hostpoint.ch [IPv6:2a00:d70:0:e::317])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAB2AC0401D9
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 10:04:26 -0800 (PST)
Received: from [10.0.2.44] (helo=asmtp014.mail.hostpoint.ch)
        by mxout017.mail.hostpoint.ch with esmtp (Exim 4.94.2 (FreeBSD))
        (envelope-from <thomas@kupper.org>)
        id 1nH8NE-000JK5-8I; Mon, 07 Feb 2022 19:04:24 +0100
Received: from [2001:1620:50ce:1969:7551:c966:b4bb:22e]
        by asmtp014.mail.hostpoint.ch with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2 (FreeBSD))
        (envelope-from <thomas@kupper.org>)
        id 1nH8NE-000Oio-6C; Mon, 07 Feb 2022 19:04:24 +0100
X-Authenticated-Sender-Id: thomas@kupper.org
Message-ID: <919f6fb5-aef1-5377-4789-082a97574ec6@kupper.org>
Date:   Mon, 7 Feb 2022 19:04:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: AMD XGBE "phy irq request failed" kernel v5.17-rc2 on V1500B
 based board
Content-Language: en-US
To:     Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Cc:     netdev@vger.kernel.org
References: <45b7130e-0f39-cb54-f6a8-3ea2f602d65e@kupper.org>
 <c3e8cbdc-d3f9-d258-fcb6-761a5c6c89ed@amd.com>
 <68185240-9924-a729-7f41-0c2dd22072ce@kupper.org>
 <e1eafc13-4941-dcc8-a2d3-7f35510d0efc@amd.com>
 <06c0ae60-5f84-c749-a485-a52201a1152b@amd.com>
From:   Thomas Kupper <thomas@kupper.org>
In-Reply-To: <06c0ae60-5f84-c749-a485-a52201a1152b@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Am 07.02.22 um 16:19 schrieb Shyam Sundar S K:
>
> On 2/7/2022 8:02 PM, Tom Lendacky wrote:
>> On 2/5/22 12:14, Thomas Kupper wrote:
>>> Am 05.02.22 um 16:51 schrieb Tom Lendacky:
>>>> On 2/5/22 04:06, Thomas Kupper wrote:
>>>> Reloading the module and specify the dyndbg option to get some
>>>> additional debug output.
>>>>
>>>> I'm adding Shyam to the thread, too, as I'm not familiar with the
>>>> configuration for this chip.
>>>>
>>> Right after boot:
>>>
>>> [    5.352977] amd-xgbe 0000:06:00.1 eth0: net device enabled
>>> [    5.354198] amd-xgbe 0000:06:00.2 eth1: net device enabled
>>> ...
>>> [    5.382185] amd-xgbe 0000:06:00.1 enp6s0f1: renamed from eth0
>>> [    5.426931] amd-xgbe 0000:06:00.2 enp6s0f2: renamed from eth1
>>> ...
>>> [    9.701637] amd-xgbe 0000:06:00.2 enp6s0f2: phy powered off
>>> [    9.701679] amd-xgbe 0000:06:00.2 enp6s0f2: CL73 AN disabled
>>> [    9.701715] amd-xgbe 0000:06:00.2 enp6s0f2: CL37 AN disabled
>>> [    9.738191] amd-xgbe 0000:06:00.2 enp6s0f2: starting PHY
>>> [    9.738219] amd-xgbe 0000:06:00.2 enp6s0f2: starting I2C
>>> ...
>>> [   10.742622] amd-xgbe 0000:06:00.2 enp6s0f2: firmware mailbox
>>> command did not complete
>>> [   10.742710] amd-xgbe 0000:06:00.2 enp6s0f2: firmware mailbox reset
>>> performed
>>> [   10.750813] amd-xgbe 0000:06:00.2 enp6s0f2: 10GbE SFI mode set
>>> [   10.768366] amd-xgbe 0000:06:00.2 enp6s0f2: 10GbE SFI mode set
>>> [   10.768371] amd-xgbe 0000:06:00.2 enp6s0f2: fixed PHY configuration
>>>
>>> Then after 'ifconfig enp6s0f2 up':
>>>
>>> [  189.184928] amd-xgbe 0000:06:00.2 enp6s0f2: phy powered off
>>> [  189.191828] amd-xgbe 0000:06:00.2 enp6s0f2: 10GbE SFI mode set
>>> [  189.191863] amd-xgbe 0000:06:00.2 enp6s0f2: CL73 AN disabled
>>> [  189.191894] amd-xgbe 0000:06:00.2 enp6s0f2: CL37 AN disabled
>>> [  189.196338] amd-xgbe 0000:06:00.2 enp6s0f2: starting PHY
>>> [  189.198792] amd-xgbe 0000:06:00.2 enp6s0f2: 10GbE SFI mode set
>>> [  189.212036] genirq: Flags mismatch irq 69. 00000000 (enp6s0f2-pcs)
>>> vs. 00000000 (enp6s0f2-pcs)
>>> [  189.221700] amd-xgbe 0000:06:00.2 enp6s0f2: phy irq request failed
>>> [  189.231051] amd-xgbe 0000:06:00.2 enp6s0f2: phy powered off
>>> [  189.231054] amd-xgbe 0000:06:00.2 enp6s0f2: stopping I2C
>>>
>> Please ensure that the ethtool msglvl is on for drv and probe. I was
>> expecting to see some additional debug messages that I don't see here.
>>
>> Also, if you can provide the lspci output for the device (using -nn and
>> -vv) that might be helpful as well.
>>
>> Shyam will be the best one to understand what is going on here.
> On some other platforms, we have seen similar kind of problems getting
> reported. There is a fix sent for validation.
>
> The root cause is that removal of xgbe driver is causing interrupt storm
> on the MP2 device (Sensor Fusion Hub).
>
> Shall submit a fix soon to upstream once the validation is done, you may
> give it a try with that and see if that helps.
>
> Thanks,
> Shyam
>
>> Thanks,
>> Tom

Sorry, forgot the 'lspci -nn -vv' output. Here it goes:

$ ethtool -i enp6s0f2
driver: amd-xgbe
version: 5.17.0-rc2-tk
firmware-version: 17.118.33
expansion-rom-version:
bus-info: 0000:06:00.2
supports-statistics: yes
supports-test: no
supports-eeprom-access: no
supports-register-dump: no
supports-priv-flags: no

$ lspci -nn -vv -s 0:6:0.2
06:00.2 Ethernet controller [0200]: Advanced Micro Devices, Inc. [AMD] 
Device [1022:1458]
         Subsystem: Advanced Micro Devices, Inc. [AMD] Device [1022:1458]
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx+
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0, Cache Line Size: 64 bytes
         Interrupt: pin C routed to IRQ 69
         Region 0: Memory at d0020000 (32-bit, non-prefetchable) [size=128K]
         Region 1: Memory at d0000000 (32-bit, non-prefetchable) [size=128K]
         Region 2: Memory at d0080000 (64-bit, non-prefetchable) [size=8K]
         Capabilities: [48] Vendor Specific Information: Len=08 <?>
         Capabilities: [50] Power Management version 3
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [64] Express (v2) Endpoint, MSI 00
                 DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s 
<4us, L1 unlimited
                         ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset- 
SlotPowerLimit 0.000W
                 DevCtl: CorrErr- NonFatalErr- FatalErr- UnsupReq-
                         RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
                         MaxPayload 128 bytes, MaxReadReq 512 bytes
                 DevSta: CorrErr+ NonFatalErr- FatalErr- UnsupReq+ 
AuxPwr- TransPend-
                 LnkCap: Port #0, Speed 8GT/s, Width x16, ASPM L0s L1, 
Exit Latency L0s <64ns, L1 <1us
                         ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp+
                 LnkCtl: ASPM Disabled; RCB 64 bytes, Disabled- CommClk+
                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                 LnkSta: Speed 8GT/s (ok), Width x16 (ok)
                         TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
                 DevCap2: Completion Timeout: Not Supported, TimeoutDis- 
NROPrPrP- LTR-
                          10BitTagComp- 10BitTagReq- OBFF Not Supported, 
ExtFmt- EETLPPrefix-
                          EmergencyPowerReduction Not Supported, 
EmergencyPowerReductionInit-
                          FRS- TPHComp- ExtTPHComp-
                          AtomicOpsCap: 32bit- 64bit- 128bitCAS-
                 DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- 
LTR- OBFF Disabled,
                          AtomicOpsCtl: ReqEn-
                 LnkSta2: Current De-emphasis Level: -3.5dB, 
EqualizationComplete- EqualizationPhase1-
                          EqualizationPhase2- EqualizationPhase3- 
LinkEqualizationRequest-
                          Retimer- 2Retimers- CrosslinkRes: unsupported
         Capabilities: [a0] MSI: Enable- Count=1/8 Maskable- 64bit+
                 Address: 0000000000000000  Data: 0000
         Capabilities: [c0] MSI-X: Enable+ Count=7 Masked-
                 Vector table: BAR=2 offset=00000000
                 PBA: BAR=2 offset=00001000
         Capabilities: [100 v1] Vendor Specific Information: ID=0001 
Rev=1 Len=010 <?>
         Capabilities: [150 v2] Advanced Error Reporting
                 UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                 UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                 UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                 CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- 
AdvNonFatalErr+
                 CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- 
AdvNonFatalErr+
                 AERCap: First Error Pointer: 00, ECRCGenCap- ECRCGenEn- 
ECRCChkCap- ECRCChkEn-
                         MultHdrRecCap- MultHdrRecEn- TLPPfxPres- HdrLogCap-
                 HeaderLog: 00000000 00000000 00000000 00000000
         Capabilities: [2a0 v1] Access Control Services
                 ACSCap: SrcValid- TransBlk- ReqRedir- CmpltRedir- 
UpstreamFwd- EgressCtrl- DirectTrans-
                 ACSCtl: SrcValid- TransBlk- ReqRedir- CmpltRedir- 
UpstreamFwd- EgressCtrl- DirectTrans-
         Kernel driver in use: amd-xgbe
         Kernel modules: amd_xgbe

/Thomas

