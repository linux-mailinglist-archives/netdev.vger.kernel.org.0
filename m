Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79197542926
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 10:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbiFHIR3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 04:17:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiFHIPg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 04:15:36 -0400
X-Greylist: delayed 473 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 08 Jun 2022 00:44:34 PDT
Received: from mout.web.de (mout.web.de [212.227.17.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25A16258B56
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 00:44:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1654674272;
        bh=Xy7WrHqyx3f/eKlkHyF0ATDh6U5GP4/KbwcY3kyYpgo=;
        h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
        b=F1PIJhgAZs9V5bllX3UqJvTVwMhGizX/8slKhQwo/rAZ9QXZkuH+1ltRlSm1IgC69
         z+wFeNaBN5khgUknyp/jr+dIQqNlqD2RDQScDpU6vWc0kJ7IUPNOMOLg9nKAEngyvV
         SSwaw+WM7RJlQKJwhCEdRtpRxRlpN6dyIyf5alUI=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.178.85] ([95.118.91.155]) by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MYcpt-1oCoef3IY7-00VVth; Wed, 08
 Jun 2022 09:30:58 +0200
Message-ID: <60f4d5b4-804d-dfb3-5810-bacf1e3401cb@web.de>
Date:   Wed, 8 Jun 2022 09:30:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [REGRESSION] r8169: RTL8168h "transmit queue 0 timed out" after
 ASPM L1 enablement
Content-Language: en-US
To:     Bernhard Hampel-Waffenthal <bernhard.hampelw@posteo.at>
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org,
        regressions@lists.linux.dev, Jakub Kicinski <kuba@kernel.org>
References: <9ebb43ee-52a1-c77d-d609-ca447a32f3e6@posteo.at>
From:   Heiner Kallweit <heiner.kallweit@web.de>
In-Reply-To: <9ebb43ee-52a1-c77d-d609-ca447a32f3e6@posteo.at>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:G4dUPJEjI11U3TmuidCr6irm8sdcp7M7qbk2mipTXfuvh3SsyJz
 dhBeeUPy6mc3BNsNkgklSMQJEQH6hYffC5fFMyNOy+XwpDb1ZFK/x3zlZH16pT9OI0RdXKh
 AY2eJ4Dicex+RIDjYz3UwbrUXaB4nldQnd47qfHxgpznu9413AI5DkQ0Ntmbk704nZBdgqY
 hnE9BymHTqNMo9VmF92pA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:lJFXtjtoncY=:SLiedJDbCDJdAQEmihlXUe
 YKG3uLClMA7zXnXuXr+CBvWuoAyrW01j5JZ+2huNiq/zTY1haDPumoMyZ45kvwajoYMiXP0XR
 19/Hwfra+owmyoMMwNdiHtdCJVfuBx134LIYuG4C8+LQr+DkcCRLwudGqB2d0YF++VafTHmGh
 3fULRzbqeraQtmXr3lnvJy4L06s1cqtlKgDVAvceD1ebO4HsjdtqBZ2zJ+HEqYMMuj1R4uZCA
 h/5OreZxT1z7ZJOg/8NrzVwY7wt2js7VaRRuGFs4vqnXRdzmI0/imEt4lkfboqrXiJ+LtBHQd
 ouYfkwGaptJVW1B1F20ub2BAVQdBWyZukJlFqT6z2fVe1ydOEDCHmJW4dkm5+MaMgKRRzZsL+
 y9ttHVAUfJpI+ppvWgOlN5x/KTjySTP9z74jwTR4XI9YHEy2aVvHRByq6SwCLlr2O7hoSB2dp
 uxp4YDQ3mL8xk3H/fOIoCb/S2M0Om923O9pOEG2LtToq29CQeaNLTuP2rPDzgQgxV7mS3211k
 P8fzndBoV6T3rpbetOujQTN2U2nUmmCgnMLqBn1Kn4wuKyBAeecahdeQp8GGXtuAChtjlr20A
 k4xemlOjo2wWph3G1t+dZD7UJivj9RZaAs1Thz9xr6izEjRIayMA+Q+ZTIURvkKgP6oLaAMOz
 X2EoxUt2Sq5kEyVzkVkT9VUqTGq7pDHvsEaMQJtLDJtHKVTvYwnF1xxIh55/JOyKkdv40z7HM
 /0kTdeMP8pw/vuQ4o701W1IgSyJvNZOzNMt5NobU0CiQ85a8u+doBjtBgSGXAOlN5vlUgzvUK
 NB9YeAVDrEPOxGZwI4zch604+XcwtQy6hYgpEwgd98p5lVVxNA64EVnRFfHbe9Htwlgriy/LZ
 oViNcpxBNH8Lr0opDMv852BQDlyBbefVZ8HNfKK40/9wr7F3ZOJk/m619kofg3l/ew6NWjfdB
 GxnUwVlTEWgf+ubKeONNiIy7yxEFYIpTsFSaB3c+aODVcqAZ2aW87xt0PtJM9zy169VnbNXQ1
 aRNi/wuS5WguKEUvVeAGfSIWWDjPegauCNw9pjw1BQOrU91CRU1zPFo58N5ApAPz6fjvfn9PL
 MGeyoDWVrle4CvqoyZQAZ9aUhl+D8reGRmD3DLnWBeB1I1NsYqM9/U7dA==
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08.06.2022 02:44, Bernhard Hampel-Waffenthal wrote:
> #regzbot introduced: 4b5f82f6aaef3fa95cce52deb8510f55ddda6a71
>
> Hi,
>
> since the last major kernel version upgrade to 5.18 on Arch Linux I'm un=
able to get a usable ethernet connection on my desktop PC.
>
> I can see a timeout in the logs
>
> > kernel: NETDEV WATCHDOG: enp37s0 (r8169): transmit queue 0 timed out
>
> and regular very likely related errors after
>
> > kernel: r8169 0000:25:00.0 enp37s0: rtl_rxtx_empty_cond =3D=3D 0 (loop=
: 42, delay: 100).
>
>
> The link does manage to go up at nominal full 1Gbps speed, but there is =
no usable connection to speak of and pings are very bursty and take multip=
le seconds.
>
> I was able to pinpoint that the problems were introduced in commit 4b5f8=
2f6aaef3fa95cce52deb8510f55ddda6a71 with the enablement of ASPM L1/L1.1 fo=
r ">=3D RTL_GIGA_MAC_VER_45", which my chip falls under. Adding pcie_aspm=
=3Doff the kernel command line or changing that check to ">=3D RTL_GIGA_MA=
C_VER_60" for testing purposes and recompiling the kernel fixes my problem=
s.
>
>
> I'm using a MSI B450I GAMING PLUS AC motherboard with a RTL8168h chip as=
 per dmesg:
>
> > r8169 0000:25:00.0 eth0: RTL8168h/8111h, 30:9c:23:de:97:a9, XID 541, I=
RQ 101
>
> lspci says:
>
> > 25:00.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd. RT=
L8111/8168/8411 PCI Express Gigabit Ethernet Controller [10ec:8168] (rev 1=
5)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Subsystem: Micro-Star Interna=
tional Co., Ltd. [MSI] Device [1462:7a40]
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Control: I/O+ Mem+ BusMaster+=
 SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Status: Cap+ 66MHz- UDF- Fast=
B2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Latency: 0, Cache Line Size: =
64 bytes
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Interrupt: pin A routed to IR=
Q 30
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 IOMMU group: 14
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Region 0: I/O ports at f000 [=
size=3D256]
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Region 2: Memory at fcb04000 =
(64-bit, non-prefetchable) [size=3D4K]
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Region 4: Memory at fcb00000 =
(64-bit, non-prefetchable) [size=3D16K]
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Capabilities: <access denied>
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Kernel driver in use: r8169
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Kernel modules: r8169
>
Thanks for the report. On my test systems RTL8168h works fine with ASPM L1=
 and L1.1, so it seems to be
a board-specific issue. Some reports in the past indicated that changing I=
OMMU settings may help,
you can also use the ASPM sysfs link attributes to disable selected ASPM s=
tates for just this link.

>
> If you need more info I'll do my best to provide what I can, hope that h=
elps already.
>
> Regards,
> Bernhard


