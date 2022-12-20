Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA238652644
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 19:30:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234112AbiLTSae (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 13:30:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234009AbiLTS35 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 13:29:57 -0500
Received: from mail-vs1-xe2d.google.com (mail-vs1-xe2d.google.com [IPv6:2607:f8b0:4864:20::e2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 242D41DF06;
        Tue, 20 Dec 2022 10:29:53 -0800 (PST)
Received: by mail-vs1-xe2d.google.com with SMTP id k185so12620475vsc.2;
        Tue, 20 Dec 2022 10:29:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=rtqqzZnb48SyLZzNizQ2wbW4A0rGVeELO1Mn43Etf/o=;
        b=bchNpIj9zhCRWaJDm0Oyv465Z4NyMbTtHD6sEgkOAkvMfVePw2sTbXCM+3uyutjWJy
         IEjBgg/L67Gwi2qa/XDgHDUNtvmGUzsdyTzzBoygit7ULFTe0t/iwnQDNt+rrboIZG7b
         6LZvp23lv7QtfcxBe3v4p53HBF+biu15uTflIBUw3D0rQfe1h/UisagJbDOp7225LyE4
         yh4wQ9jXVCgQJE8UsY2RFrh3FLTeVBSd728RjLlbxjCuoJXq4lY/sW3MWh4qdcqIsWZb
         H/ZIdhucFOTl2s4wxiTgRFiTkjEbhlgA6APP9Wvcbxe0ZtqHpM3QomcejCPY5Yp61pf3
         dAKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rtqqzZnb48SyLZzNizQ2wbW4A0rGVeELO1Mn43Etf/o=;
        b=ntQGUUmTPZYLp5wTcoAbAlg03vHqdpUNl1Je38vCMP8vz2T964cDVzTWM61rfr86bl
         wsXiLbCqM1JUCbC6nUm+1tzT4XBOw/c9UPKboqfD0l8Epqo/ckWanfx9xO8+OGPwLLzZ
         07wl/cyHkRFo23DHMktApR6heelFpYJRbck7lAskZGKmFFUubccCJmSLXV8oNIpLR0Xd
         qsTNsOJ1w1QJw4f14Sxrrvio29XmNfva3SmQLAPshEwCBNsXxjU9EvlumwB1Jxc/ybt4
         w1x1AMctftUXV6xEZT01OCkT8priXRhWsVzYTluTIYUw2XAfoGIr7EwCr4E2QJu5rbcy
         Ka8w==
X-Gm-Message-State: ANoB5pnbj6FOFBABF0sA6bbsmf3N0w2PXbb7+pKEwdtMka5Swa5weXQP
        nZhTccTCmHTL64H48TNYZ9Ml6LVI3+CoGf7B55BtEYjYwhhfBA==
X-Google-Smtp-Source: AA0mqf6NJ7Cs3feQbWQd29qEM23PqK9LVgqKlYzFffzYNJ9FOtrJhIb89dQaF8idXXfNG1BHy2zCRErc9Z4oWlpLPPY=
X-Received: by 2002:a05:6102:1c6:b0:3b2:eefc:4630 with SMTP id
 s6-20020a05610201c600b003b2eefc4630mr11985831vsq.18.1671560992142; Tue, 20
 Dec 2022 10:29:52 -0800 (PST)
MIME-Version: 1.0
References: <CACsaVZL6ykbsVvEaV2Cv3r6m_jKt04MEUOw5=mSnR5AYTyE7qg@mail.gmail.com>
 <a752422c-4630-e53d-c9cd-cc9ed866f853@intel.com>
In-Reply-To: <a752422c-4630-e53d-c9cd-cc9ed866f853@intel.com>
From:   Kyle Sanderson <kyle.leet@gmail.com>
Date:   Tue, 20 Dec 2022 10:29:40 -0800
Message-ID: <CACsaVZJXqkWGOQhe-GzRKJSfYn-3+dZTyHNZC97npCxzqr+R9g@mail.gmail.com>
Subject: Re: [Intel-wired-lan] igc: 5.10.146 Kernel BUG at 0xffffffff813ce19f
To:     "Neftin, Sasha" <sasha.neftin@intel.com>
Cc:     Linux-Kernal <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        intel-wired-lan@lists.osuosl.org, anthony.l.nguyen@intel.com,
        jesse.brandeburg@intel.com, netdev@vger.kernel.org,
        "Ruinskiy, Dima" <dima.ruinskiy@intel.com>,
        "Lifshits, Vitaly" <vitaly.lifshits@intel.com>,
        "naamax.meir" <naamax.meir@linux.intel.com>,
        "Avivi, Amir" <amir.avivi@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

re-sending as plain text - my apologies.

> On Sun, 18 Dec 2022, 23:31 Neftin, Sasha wrote:
> What is a board in use (LAN on board or NIC)?
> What is lspci, lspci -t and lspci -s 0000:[lan bus:device.function] -vvv output?

It's embedded on the board, could very well be on a bridge though as a
card. The box has 6 ports, 2 were in-use while testing.

00:00.0 Host bridge: Intel Corporation Device 4522 (rev 01)
00:02.0 VGA compatible controller: Intel Corporation Elkhart Lake [UHD
Graphics Gen11 16EU] (rev 01)
00:08.0 System peripheral: Intel Corporation Device 4511 (rev 01)
00:14.0 USB controller: Intel Corporation Device 4b7d (rev 11)
00:14.2 RAM memory: Intel Corporation Device 4b7f (rev 11)
00:16.0 Communication controller: Intel Corporation Device 4b70 (rev 11)
00:17.0 SATA controller: Intel Corporation Device 4b63 (rev 11)
00:1c.0 PCI bridge: Intel Corporation Device 4b38 (rev 11)
00:1c.1 PCI bridge: Intel Corporation Device 4b39 (rev 11)
00:1c.2 PCI bridge: Intel Corporation Device 4b3a (rev 11)
00:1c.3 PCI bridge: Intel Corporation Device 4b3b (rev 11)
00:1c.4 PCI bridge: Intel Corporation Device 4b3c (rev 11)
00:1c.6 PCI bridge: Intel Corporation Device 4b3e (rev 11)
00:1f.0 ISA bridge: Intel Corporation Device 4b00 (rev 11)
00:1f.3 Audio device: Intel Corporation Device 4b58 (rev 11)
00:1f.4 SMBus: Intel Corporation Device 4b23 (rev 11)
00:1f.5 Serial bus controller: Intel Corporation Device 4b24 (rev 11)
01:00.0 Ethernet controller: Intel Corporation Device 125c (rev 04)
02:00.0 Ethernet controller: Intel Corporation Device 125c (rev 04)
03:00.0 Ethernet controller: Intel Corporation Device 125c (rev 04)
04:00.0 Ethernet controller: Intel Corporation Device 125c (rev 04)
05:00.0 Ethernet controller: Intel Corporation Device 125c (rev 04)
06:00.0 Ethernet controller: Intel Corporation Device 125c (rev 04)

-[0000:00]-+-00.0
           +-02.0
           +-08.0
           +-14.0
           +-14.2
           +-16.0
           +-17.0
           +-1c.0-[01]----00.0
           +-1c.1-[02]----00.0
           +-1c.2-[03]----00.0
           +-1c.3-[04]----00.0
           +-1c.4-[05]----00.0
           +-1c.6-[06]----00.0
           +-1f.0
           +-1f.3
           +-1f.4
           \-1f.5


01:00.0 Ethernet controller: Intel Corporation Device 125c (rev 04)
 Subsystem: Intel Corporation Device 0000
 Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
 Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
 Latency: 0
 Interrupt: pin A routed to IRQ 16
 Region 0: Memory at 80600000 (32-bit, non-prefetchable) [size=1M]
 Region 3: Memory at 80700000 (32-bit, non-prefetchable) [size=16K]
 Capabilities: [40] Power Management version 3
  Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
  Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=1 PME-
 Capabilities: [50] MSI: Enable- Count=1/1 Maskable+ 64bit+
  Address: 0000000000000000 Data: 0000
  Masking: 00000000 Pending: 00000000
 Capabilities: [70] MSI-X: Enable+ Count=5 Masked-
  Vector table: BAR=3 offset=00000000
  PBA: BAR=3 offset=00002000
 Capabilities: [a0] Express (v2) Endpoint, MSI 00
  DevCap: MaxPayload 512 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
   ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset+ SlotPowerLimit 0W
  DevCtl: CorrErr+ NonFatalErr+ FatalErr+ UnsupReq+
   RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+ FLReset-
   MaxPayload 128 bytes, MaxReadReq 512 bytes
  DevSta: CorrErr- NonFatalErr- FatalErr- UnsupReq- AuxPwr+ TransPend-
  LnkCap: Port #0, Speed 5GT/s, Width x1, ASPM L1, Exit Latency L1 <4us
   ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp+
  LnkCtl: ASPM Disabled; RCB 64 bytes, Disabled- CommClk+
   ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
  LnkSta: Speed 5GT/s, Width x1
   TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
  DevCap2: Completion Timeout: Range ABCD, TimeoutDis+ NROPrPrP- LTR+
    10BitTagComp- 10BitTagReq- OBFF Not Supported, ExtFmt- EETLPPrefix-
    EmergencyPowerReduction Not Supported, EmergencyPowerReductionInit-
    FRS- TPHComp- ExtTPHComp-
    AtomicOpsCap: 32bit- 64bit- 128bitCAS-
  DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- LTR+
10BitTagReq- OBFF Disabled,
    AtomicOpsCtl: ReqEn-
  LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-
    Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
    Compliance Preset/De-emphasis: -6dB de-emphasis, 0dB preshoot
  LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-
EqualizationPhase1-
    EqualizationPhase2- EqualizationPhase3- LinkEqualizationRequest-
    Retimer- 2Retimers- CrosslinkRes: unsupported
 Capabilities: [100 v2] Advanced Error Reporting
  UESta: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
  UEMsk: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
  UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
MalfTLP+ ECRC- UnsupReq- ACSViol-
  CESta: RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr-
  CEMsk: RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr+
  AERCap: First Error Pointer: 00, ECRCGenCap+ ECRCGenEn- ECRCChkCap+ ECRCChkEn-
   MultHdrRecCap- MultHdrRecEn- TLPPfxPres- HdrLogCap-
  HeaderLog: 00000000 00000000 00000000 00000000
 Capabilities: [140 v1] Device Serial Number e4-3a-6e-ff-ff-5d-bb-54
 Capabilities: [1c0 v1] Latency Tolerance Reporting
  Max snoop latency: 3145728ns
  Max no snoop latency: 3145728ns
 Capabilities: [1f0 v1] Precision Time Measurement
  PTMCap: Requester:+ Responder:- Root:-
  PTMClockGranularity: 4ns
  PTMControl: Enabled:- RootSelected:-
  PTMEffectiveGranularity: Unknown
 Capabilities: [1e0 v1] L1 PM Substates
  L1SubCap: PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2+ ASPM_L1.1+ L1_PM_Substates+
     PortCommonModeRestoreTime=55us PortTPowerOnTime=70us
  L1SubCtl1: PCI-PM_L1.2- PCI-PM_L1.1- ASPM_L1.2- ASPM_L1.1-
      T_CommonMode=0us LTR1.2_Threshold=81920ns
  L1SubCtl2: T_PwrOn=50us
 Kernel driver in use: igc
 Kernel modules: igc

On Sun, Dec 18, 2022 at 10:31 PM Neftin, Sasha <sasha.neftin@intel.com> wrote:
>
> On 12/16/2022 00:28, Kyle Sanderson wrote:
> > (Un)fortunately I can reproduce this bug by simply removing the
> > ethernet cable from the box while there is traffic flowing. kprint
> > below from a console line. Please CC / to me for any additional
> > information I can provide for this panic.
> What is a board in use (LAN on board or NIC)? What is lspci, lspci -t
> and lspci -s 0000:[lan bus:device.function] -vvv output?
> >
> > [  156.707054] igc 0000:01:00.0 eth0: NIC Link is Down
> > [  156.712981] br-lan: port 1(eth0) entered disabled state
> > [  156.719246] igc 0000:01:00.0 eth0: Register Dump
> > [  156.724784] igc 0000:01:00.0 eth0: Register Name   Value
> > [  156.731067] igc 0000:01:00.0 eth0: CTRL            181c0641
> > [  156.737607] igc 0000:01:00.0 eth0: STATUS          00380681
> > [  156.744133] igc 0000:01:00.0 eth0: CTRL_EXT        100000c0
> > [  156.750759] igc 0000:01:00.0 eth0: MDIC            18017949
> > [  156.757258] igc 0000:01:00.0 eth0: ICR             00000001
> > [  156.763785] igc 0000:01:00.0 eth0: RCTL            0440803a
> > [  156.770324] igc 0000:01:00.0 eth0: RDLEN[0-3]      00001000
> > 00001000 00001000 00001000
> > [  156.779457] igc 0000:01:00.0 eth0: RDH[0-3]        000000ef
> > 000000a1 00000092 000000ba
> > [  156.788500] igc 0000:01:00.0 eth0: RDT[0-3]        000000ee
> > 000000a0 00000091 000000b9
> > [  156.797650] igc 0000:01:00.0 eth0: RXDCTL[0-3]     02040808
> > 02040808 02040808 02040808
> > [  156.806688] igc 0000:01:00.0 eth0: RDBAL[0-3]      02f43000
> > 02180000 02e7f000 02278000
> > [  156.815781] igc 0000:01:00.0 eth0: RDBAH[0-3]      00000001
> > 00000001 00000001 00000001
> > [  156.824928] igc 0000:01:00.0 eth0: TCTL            a503f0fa
> > [  156.831587] igc 0000:01:00.0 eth0: TDBAL[0-3]      02f43000
> > 02180000 02e7f000 02278000
> > [  156.840637] igc 0000:01:00.0 eth0: TDBAH[0-3]      00000001
> > 00000001 00000001 00000001
> > [  156.849753] igc 0000:01:00.0 eth0: TDLEN[0-3]      00001000
> > 00001000 00001000 00001000
> > [  156.858760] igc 0000:01:00.0 eth0: TDH[0-3]        000000d4
> > 0000003d 000000af 0000002a
> > [  156.867771] igc 0000:01:00.0 eth0: TDT[0-3]        000000e4
> > 0000005a 000000c8 0000002a
> > [  156.876864] igc 0000:01:00.0 eth0: TXDCTL[0-3]     02100108
> > 02100108 02100108 02100108
> > [  156.885905] igc 0000:01:00.0 eth0: Reset adapter
> > [  160.307195] igc 0000:01:00.0 eth0: NIC Link is Up 1000 Mbps Full
> > Duplex, Flow Control: RX/TX
> > [  160.317974] br-lan: port 1(eth0) entered blocking state
> > [  160.324532] br-lan: port 1(eth0) entered forwarding state
> > [  161.197263] ------------[ cut here ]------------
> > [  161.202669] Kernel BUG at 0xffffffff813ce19f [verbose debug info unavailable]
> > [  161.210769] invalid opcode: 0000 [#1] SMP NOPTI
> > [  161.216022] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.10.146 #0
> > [  161.222980] Hardware name: Default string Default string/Default
> > string, BIOS 5.19 09/23/2022
> > [  161.232546] RIP: 0010:0xffffffff813ce19f
> > [  161.237167] Code: 03 01 4c 89 48 58 e9 2f ff ff ff 85 db 41 0f 95
> > c2 45 39 d9 41 0f 95 c1 45 84 ca 74 05 45 85 e4 78 0a 44 89 c2 e9 10
> > ff ff ff <0f> 0b 01 d2 45 89 c1 41 29 d1 ba 00 00 00 00 44 0f 48 ca eb
> > 80 cc
> > [  161.258651] RSP: 0018:ffffc90000118e88 EFLAGS: 00010283
> > [  161.264736] RAX: ffff888101f8f200 RBX: ffffc900006f9bd0 RCX: 000000000000050e
> > [  161.272837] RDX: ffff888101fec000 RSI: 0000000000000a1c RDI: 0000000000061a10
> > [  161.280942] RBP: ffffc90000118ef8 R08: 0000000000000000 R09: 0000000000061502
> > [  161.289089] R10: 0000000000000000 R11: 0000000000000000 R12: 00000000ffffff3f
> > [  161.297229] R13: ffff888101f8f140 R14: 0000000000000000 R15: ffff888100ad9b00
> > [  161.305345] FS:  0000000000000000(0000) GS:ffff88903fe80000(0000)
> > knlGS:00000 00000000000
> > [  161.314492] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [  161.321139] CR2: 00007f941ad43a9b CR3: 000000000340a000 CR4: 0000000000350ee0
> > [  161.329284] Call Trace:
> > [  161.332373]  <IRQ>
> > [  161.334981]  ? 0xffffffffa0185f78 [igc@00000000f400031b+0x13000]
> > [  161.341949]  0xffffffff8185b047
> > [  161.345797]  0xffffffff8185b2ca
> > [  161.349637]  0xffffffff81e000bb
> > [  161.353465]  0xffffffff81c0109f
> > [  161.357304]  </IRQ>
> > [  161.359988]  0xffffffff8102cdac
> > [  161.363783]  0xffffffff810bfdaf
> > [  161.367584]  0xffffffff81a2e616
> > [  161.371374]  0xffffffff81c00c9e
> > [  161.375192] RIP: 0010:0xffffffff817e331b
> > [  161.379840] Code: 21 90 ff 65 8b 3d 45 23 83 7e e8 80 20 90 ff 31
> > ff 49 89 c6 e8 26 2d 90 ff 80 7d d7 00 0f 85 9e 01 00 00 fb 66 0f 1f
> > 44 00 00 <45> 85 ff 0f 88 cf 00 00 00 49 63 cf 48 8d 04 49 48 8d 14 81
> > 48 c1
> > [  161.401397] RSP: 0018:ffffc900000d3e80 EFLAGS: 00000246
> > [  161.407493] RAX: ffff88903fea5180 RBX: ffff88903feadf00 RCX: 000000000000001f
> > [  161.415648] RDX: 0000000000000000 RSI: 0000000046ec0743 RDI: 0000000000000000
> > [  161.423811] RBP: ffffc900000d3eb8 R08: 00000025881a3b81 R09: ffff888100317340
> > [  161.432003] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000003
> > [  161.440154] R13: ffffffff824c7bc0 R14: 00000025881a3b81 R15: 0000000000000003
> > [  161.448285]  0xffffffff817e357f
> > [  161.452123]  0xffffffff810e6258
> > [  161.455938]  0xffffffff810e63fb
> > [  161.459746]  0xffffffff8104bec0
> > [  161.463526]  0xffffffff810000f5
> > [  161.467290] Modules linked in: pppoe ppp_async nft_fib_inet
> > nf_flow_table_ipv 6 nf_flow_table_ipv4 nf_flow_table_inet wireguard
> > pppox ppp_generic nft_reject_i pv6 nft_reject_ipv4 nft_reject_inet
> > nft_reject nft_redir nft_quota nft_objref nf t_numgen nft_nat nft_masq
> > nft_log nft_limit nft_hash nft_flow_offload nft_fib_ip v6 nft_fib_ipv4
> > nft_fib nft_ct nft_counter nft_chain_nat nf_tables nf_nat nf_flo
> > w_table nf_conntrack libchacha20poly1305 curve25519_x86_64
> > chacha_x86_64 slhc r8 169 poly1305_x86_64 nfnetlink nf_reject_ipv6
> > nf_reject_ipv4 nf_log_ipv6 nf_log_i pv4 nf_log_common nf_defrag_ipv6
> > nf_defrag_ipv4 libcurve25519_generic libcrc32c libchacha igc forcedeth
> > e1000e crc_ccitt bnx2 i2c_dev ixgbe e1000 amd_xgbe ip6_u dp_tunnel
> > udp_tunnel mdio nls_utf8 ena kpp nls_iso8859_1 nls_cp437 vfat fat igb
> > button_hotplug tg3 ptp realtek pps_core mii
> > [  161.550507] ---[ end trace b1cb18ab2d1741bd ]---
> > [  161.555938] RIP: 0010:0xffffffff813ce19f
> > [  161.560634] Code: 03 01 4c 89 48 58 e9 2f ff ff ff 85 db 41 0f 95
> > c2 45 39 d9 41 0f 95 c1 45 84 ca 74 05 45 85 e4 78 0a 44 89 c2 e9 10
> > ff ff ff <0f> 0b 01 d2 45 89 c1 41 29 d1 ba 00 00 00 00 44 0f 48 ca eb
> > 80 cc
> > [  161.582281] RSP: 0018:ffffc90000118e88 EFLAGS: 00010283
> > [  161.588426] RAX: ffff888101f8f200 RBX: ffffc900006f9bd0 RCX: 000000000000050e
> > [  161.596668] RDX: ffff888101fec000 RSI: 0000000000000a1c RDI: 0000000000061a10
> > [  161.604860] RBP: ffffc90000118ef8 R08: 0000000000000000 R09: 0000000000061502
> > [  161.613052] R10: 0000000000000000 R11: 0000000000000000 R12: 00000000ffffff3f
> > [  161.621291] R13: ffff888101f8f140 R14: 0000000000000000 R15: ffff888100ad9b00
> > [  161.629505] FS:  0000000000000000(0000) GS:ffff88903fe80000(0000)
> > knlGS:00000 00000000000
> > [  161.638781] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [  161.645549] CR2: 00007f941ad43a9b CR3: 000000000340a000 CR4: 0000000000350ee0
> > [  161.653841] Kernel panic - not syncing: Fatal exception in interrupt
> > [  161.661287] Kernel Offset: disabled
> > [  161.665644] Rebooting in 3 seconds..
> > [  164.670313] ACPI MEMORY or I/O RESET_REG.
> >
> > Kyle.
> > _______________________________________________
> > Intel-wired-lan mailing list
> > Intel-wired-lan@osuosl.org
> > https://lists.osuosl.org/mailman/listinfo/intel-wired-lan
>
