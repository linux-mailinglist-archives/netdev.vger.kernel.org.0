Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDB3812DC75
	for <lists+netdev@lfdr.de>; Wed,  1 Jan 2020 01:57:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727166AbgAAA5t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Dec 2019 19:57:49 -0500
Received: from egyptian.birch.relay.mailchannels.net ([23.83.209.56]:13180
        "EHLO egyptian.birch.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727130AbgAAA5s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Dec 2019 19:57:48 -0500
X-Sender-Id: dreamhost|x-authsender|stevie@qrpff.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id E95D27403C1;
        Wed,  1 Jan 2020 00:49:21 +0000 (UTC)
Received: from pdx1-sub0-mail-a23.g.dreamhost.com (100-96-85-12.trex.outbound.svc.cluster.local [100.96.85.12])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id 7B588740826;
        Wed,  1 Jan 2020 00:49:21 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|stevie@qrpff.net
Received: from pdx1-sub0-mail-a23.g.dreamhost.com ([TEMPUNAVAIL].
 [64.90.62.162])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384)
        by 0.0.0.0:2500 (trex/5.18.5);
        Wed, 01 Jan 2020 00:49:21 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|stevie@qrpff.net
X-MailChannels-Auth-Id: dreamhost
X-Scare-Towering: 37433ba95e9f52fa_1577839761745_1607478431
X-MC-Loop-Signature: 1577839761745:3007572954
X-MC-Ingress-Time: 1577839761745
Received: from pdx1-sub0-mail-a23.g.dreamhost.com (localhost [127.0.0.1])
        by pdx1-sub0-mail-a23.g.dreamhost.com (Postfix) with ESMTP id 6CE197F652;
        Tue, 31 Dec 2019 16:49:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=qrpff.net; h=mime-version
        :from:date:message-id:subject:to:cc:content-type; s=qrpff.net;
         bh=IdDsUeZzxkRY3vzVfF0jYDoTJKs=; b=KdY6uTQrsaT3zFkjw7FyaPIQLf5Y
        qmrObrfRGro5iyOOSYa6mm1itQbhWL3TMfApfGvZ9OL25fvu/8M0yoS25tWPwNhf
        5OZUWt9wwDvKy3JcCSNEoC4uuhB/HQQAmJOyJIiMtqpck866sCtXCh14B/j9GPv5
        Sed+1YmHoQfbQ04=
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: stevie@qrpff.net)
        by pdx1-sub0-mail-a23.g.dreamhost.com (Postfix) with ESMTPSA id 8705C7F651;
        Tue, 31 Dec 2019 16:49:18 -0800 (PST)
Received: by mail-lj1-f173.google.com with SMTP id a13so37481510ljm.10;
        Tue, 31 Dec 2019 16:49:18 -0800 (PST)
X-Gm-Message-State: APjAAAVeQ71tjkq1cLCPHLvfZ+bhtO+8YKSqlDA0sfpiBGtFV+9o3kbf
        rsD/h30v1pC96klDExCqQqCT752AgfqehejR0pk=
X-Google-Smtp-Source: APXvYqyadK0g2j37BFcyuvxwrIM6nKkD733uJxbBxdUGAXsFR4ik/VyIXd9Jw5hsreAHgue9Zrn+LV1NZ9N3SOikrow=
X-Received: by 2002:a2e:9196:: with SMTP id f22mr44373035ljg.18.1577839756557;
 Tue, 31 Dec 2019 16:49:16 -0800 (PST)
MIME-Version: 1.0
X-DH-BACKEND: pdx1-sub0-mail-a23
From:   Stephen Oberholtzer <stevie@qrpff.net>
Date:   Tue, 31 Dec 2019 19:49:04 -0500
X-Gmail-Original-Message-ID: <CAD_xR9eDL+9jzjYxPXJjS7U58ypCPWHYzrk0C3_vt-w26FZeAQ@mail.gmail.com>
Message-ID: <CAD_xR9eDL+9jzjYxPXJjS7U58ypCPWHYzrk0C3_vt-w26FZeAQ@mail.gmail.com>
Subject: PROBLEM: Wireless networking goes down on Acer C720P Chromebook (bisected)
To:     toke@redhat.com
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-VR-OUT-STATUS: OK
X-VR-OUT-SCORE: -100
X-VR-OUT-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedufedrvdefkedgvdeiucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuggftfghnshhusghstghrihgsvgdpffftgfetoffjqffuvfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepggfhfffkuffvtgesthdtredttddtjeenucfhrhhomhepufhtvghphhgvnhcuqfgsvghrhhholhhtiigvrhcuoehsthgvvhhivgesqhhrphhffhdrnhgvtheqnecukfhppedvtdelrdekhedrvddtkedrudejfeenucfrrghrrghmpehmohguvgepshhmthhppdhhvghlohepmhgrihhlqdhljhduqdhfudejfedrghhoohhglhgvrdgtohhmpdhinhgvthepvddtledrkeehrddvtdekrddujeefpdhrvghtuhhrnhdqphgrthhhpefuthgvphhhvghnucfqsggvrhhhohhlthiivghruceoshhtvghvihgvsehqrhhpfhhfrdhnvghtqedpmhgrihhlfhhrohhmpehsthgvvhhivgesqhhrphhffhdrnhgvthdpnhhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wireless networking goes down on Acer C720P Chromebook (bisected)

Culprit: 7a89233a ("mac80211: Use Airtime-based Queue Limits (AQL) on
packet dequeue")

I found that the newest kernel (5.4) displayed a curious issue on my
Acer C720P Chromebook: shortly after bringing networking up, all
connections would suddenly fail.  I discovered that I could
consistently reproduce the issue by ssh'ing into the machine and
running 'dmesg' -- on a non-working kernel; I would get partial
output, and then the connection would completely hang. This was so
consistent, in fact, that I was able to leverage it to automate the
process from 'git bisect run'.

KEYWORDS: c720p, chromebook, wireless, networking, mac80211

KERNEL: any kernel containing commit 7a89233a ("mac80211: Use
Airtime-based Queue Limits (AQL) on packet dequeue")

I find this bit in the offending commit's message suspicious:

> This patch does *not* include any mechanism to wake a throttled TXQ again,
> on the assumption that this will happen anyway as a side effect of whatever
>  freed the skb (most commonly a TX completion).

Methinks this assumption is not a fully valid one.

I'll be happy to test any patches. If you need some printk calls, just
tell me where to put 'em.

This is the card:

01:00.0 Network controller: Qualcomm Atheros AR9462 Wireless Network
Adapter (rev 01)
        Subsystem: Foxconn International, Inc. AR9462 Wireless Network Adapter
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at e0400000 (64-bit, non-prefetchable) [size=512K]
        Expansion ROM at e0480000 [disabled] [size=64K]
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [50] MSI: Enable- Count=1/4 Maskable+ 64bit+
                Address: 0000000000000000  Data: 0000
                Masking: 00000000  Pending: 00000000
        Capabilities: [70] Express (v2) Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
unlimited, L1 <64us
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE+
FLReset- SlotPowerLimit 0.000W
                DevCtl: CorrErr- NonFatalErr- FatalErr- UnsupReq-
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr- NonFatalErr- FatalErr- UnsupReq-
AuxPwr+ TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1,
Exit Latency L0s <4us, L1 <64us
                        ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp-
                LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes Disabled- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s (ok), Width x1 (ok)
                        TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
                DevCap2: Completion Timeout: Not Supported,
TimeoutDis+, LTR-, OBFF Not Supported
                         AtomicOpsCap: 32bit- 64bit- 128bitCAS-
                DevCtl2: Completion Timeout: 50us to 50ms,
TimeoutDis-, LTR-, OBFF Disabled
                         AtomicOpsCtl: ReqEn-
                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
                         Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
                         Compliance De-emphasis: -6dB
                LnkSta2: Current De-emphasis Level: -6dB,
EqualizationComplete-, EqualizationPhase1-
                         EqualizationPhase2-, EqualizationPhase3-,
LinkEqualizationRequest-
        Capabilities: [100 v1] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt-
UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
AdvNonFatalErr-
                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
AdvNonFatalErr+
                AERCap: First Error Pointer: 00, ECRCGenCap-
ECRCGenEn- ECRCChkCap- ECRCChkEn-
                        MultHdrRecCap- MultHdrRecEn- TLPPfxPres- HdrLogCap-
                HeaderLog: 00000000 00000000 00000000 00000000
        Capabilities: [140 v1] Virtual Channel
                Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
                Arb:    Fixed- WRR32- WRR64- WRR128-
                Ctrl:   ArbSelect=Fixed
                Status: InProgress-
                VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                        Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
                        Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
                        Status: NegoPending- InProgress-
        Capabilities: [160 v1] Device Serial Number 00-00-00-00-00-00-00-00
        Kernel driver in use: ath9k
        Kernel modules: ath9k



-- 
-- Stevie-O
Real programmers use COPY CON PROGRAM.EXE
