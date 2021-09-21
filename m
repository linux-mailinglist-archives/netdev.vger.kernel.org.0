Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B83B0412FB8
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 09:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbhIUHwo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 03:52:44 -0400
Received: from mout.gmx.net ([212.227.15.18]:38535 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230415AbhIUHwi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Sep 2021 03:52:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1632210630;
        bh=cOgtnwrqtRUZbHwxWyhJ2gKO4mxwfCV4C5Cx3WB2LOY=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=H7ye5TYTQhgbR2iOO/O+dKAwp/U6o/8Q81eU0TaEyenTKrDpDEeDQfNl4RZqJdn//
         28Th/RV20bFN6Bs3EPDfe4z5/qtzGP4AHNPGvS4GvtLIBt7Qat4Zznz6ijEPskHIc/
         sdaGEg4+v3gGGVd46pFWbnPpjy6JbQdqEv4MTdkM=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.1.100] ([79.206.239.34]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1Mkpf3-1n9dwP37B1-00mJPx; Tue, 21
 Sep 2021 09:50:30 +0200
Subject: Re: [PATCH V2] ath10k: don't fail if IRAM write fails
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     ojab // <ojab@ojab.ru>, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, ath10k@lists.infradead.org,
        Linux Wireless <linux-wireless@vger.kernel.org>,
        netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <20210722193459.7474-1-ojab@ojab.ru>
 <CAKzrAgRt0jRFyFNjF-uq=feG-9nhCx=tTztCgCEitj1cpMk_Xg@mail.gmail.com>
 <CAKzrAgQgsN6=Cu4SvjSSFoJOqAkU2t8cjt7sgEsJdNhvM8f7jg@mail.gmail.com>
 <CAKzrAgSEiq-qOgetzryaE3JyBUe3URYjr=Fn0kz9sF7ZryQ5pA@mail.gmail.com>
 <538825a2-82f0-6102-01da-6e0385e53cf5@gmx.de> <87wnnav129.fsf@codeaurora.org>
From:   "sparks71@gmx.de" <sparks71@gmx.de>
Message-ID: <4656706a-a87d-1bf6-d125-b66af57157ca@gmx.de>
Date:   Tue, 21 Sep 2021 09:50:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <87wnnav129.fsf@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Provags-ID: V03:K1:pp1k1nFwD8mCryzJkJtnEVeIctvaJT2FBpX17tUrHoHHD01nD3D
 zXbM9jxPNrRqWSyi2DedaGYi+p6ElRTbm2HofwEvEbdh2yp0QceuusLsN9FLbd/RXDdZ5Rc
 4MEKXXl5G7mdjVbJlXZFgxWttrzudZeV/vCWlmTqFwfSkVuiC59ilTzj97oAn8ZdF3ejyMU
 H+/f1187+Ny8/6fSsSLWw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:wa/9fgfFcN0=:UTh/weiCglGI3KfbirGRgt
 QvfkSwWJPHvipBWVpABrrpArgtwXE8J5F9uMXlmFAisS1YHDfHCbziDRrI9SIF1WDYQtZHnCK
 Om491LrEjN4RsLt239IoKnT3QxMHSPEpwNSrDL/aNwsLWryRFGkuNGT++C54zKIvwQzXUJyJz
 1sGSz4sSMAiI/Hb2NufVBpjCUK/O9jQO3r8t6RKipIAGEGvQBYszIKQE5qZ1wYEGH/c2xobzj
 HyQE95iR2VKuuffKms4wGq6ASeAi+V9tTS/7geJ7Tz0cHpzYZt90S0pzuLgGP4u9J++AvB4qh
 D/7o/GfNRACE+PnIiB/3m8e3R3BFN6uuBXLSJfY2kjhTFiCZafRCU2xbwLsNTEojhZPK2LFkP
 D2QIMGTj32m0UB0U84qZVbhnegIFrZEABTShUTitAqW+nosRTsRnhUaVKsLUmHrQ30zZ93S2i
 tE6mKDXc0JKbZlwthmBHiagPPT6Bc9jNOtU6PyfSesi5ugJ12wOt2uGw3nqMYrZ8cvYrulfyI
 ULGyPhoEuOvPfFY6MfUJP+mHhXDk5Z9GKnx0nubDyHM5i02U9iBVgkG5/lNSbHD1HykkumM3+
 AN6keOMkPfTvlYYKmoIZ8sCkmLlFUEdkp5q2GNnWEDNoi1ugQ6pPmc2XhvagN0OJ6svbpo+Hk
 0DZ3v9ZJaJw2l6sRaecUSTur3RGHOdU2taX8ga4sbbDwReJGKIpcw6/sq6yt/6s18cPL2P3Yk
 MThZ0dKUJTNQoB0YknymTd7kdznMYGLkdZM3nWLGxvdjFZfraog9oZnS5jMVvb6/JM5ZPb4NY
 hxwMAAlD2ugfC7k2+paog1JBmBHZvwuL4AZpCA33BNvtah+4EEY0e63FCgSJ6l+0dJEBQjN2K
 3rfNooz/HSgwc6OsdUR1strr3ZC05i5JuvHDOGhTxScDTWZBc03adNOy0tLdMdrBBziCymF1s
 pPaJFMoX3hJAMX8nAlkCFxu+4GPVpMA096pgZ4Gg7DAXj6N0uPp+cLrDj1UnOj10yvM5WOpMW
 GiCy/1lSkAMh1kPMyXThofFwSifDNlKeSFl6stf+8qP5e6IbOF/qJqxJK+Ujp20a0gQcZypaB
 mifPn6kHUJegZg=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 21.09.21 um 09:29 schrieb Kalle Valo:
> "sparks71@gmx.de" <sparks71@gmx.de> writes:
>
>> Have you seen the new patch?
>>
>> https://www.mail-archive.com/ath10k@lists.infradead.org/msg13784.html
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/commit/?h=
=3Dmaster-pending&id=3D973de582639a1e45276e4e3e2f3c2d82a04ad0a6
>>
>>
>> could probably have been communicated better
> Yeah, apparently there are two different fixes now. I'll review both of
> them and try to choose which one to take.
>
I have tested both fixes (x86_64 2x QCA9984)

For me both of them work.

[PATCH V2] ath10k: don't fail if IRAM write fails:


[18245.610112] ath10k_pci 0000:03:00.0: pci irq msi oper_irq_mode 2
irq_mode 0 reset_mode 0
[18245.674800] ath10k_pci 0000:04:00.0: pci irq msi oper_irq_mode 2
irq_mode 0 reset_mode 0
[18245.731606] ath10k_pci 0000:03:00.0: qca9984/qca9994 hw1.0 target
0x01000000 chip_id 0x00000000 sub 168c:cafe
[18245.731620] ath10k_pci 0000:03:00.0: kconfig debug 0 debugfs 1
tracing 1 dfs 0 testmode 0
[18245.733172] ath10k_pci 0000:03:00.0: firmware ver 10.4-3.9.0.2-00152
api 5 features
no-p2p,mfp,peer-flow-ctrl,btcoex-param,allows-mesh-bcast,no-ps,peer-fixed-=
rate,iram-recovery
crc32 723f9771
[18245.790380] ath10k_pci 0000:04:00.0: qca9984/qca9994 hw1.0 target
0x01000000 chip_id 0x00000000 sub 168c:cafe
[18245.790383] ath10k_pci 0000:04:00.0: kconfig debug 0 debugfs 1
tracing 1 dfs 0 testmode 0
[18245.790703] ath10k_pci 0000:04:00.0: firmware ver 10.4-3.9.0.2-00152
api 5 features
no-p2p,mfp,peer-flow-ctrl,btcoex-param,allows-mesh-bcast,no-ps,peer-fixed-=
rate,iram-recovery
crc32 723f9771
[18246.963760] ath10k_pci 0000:03:00.0: board_file api 2 bmi_id 0:1
crc32 85498734
[18247.019699] ath10k_pci 0000:04:00.0: board_file api 2 bmi_id 0:2
crc32 85498734
[18249.514054] ath10k_pci 0000:03:00.0: No hardware memory
[18249.514057] ath10k_pci 0000:03:00.0: failed to copy target iram
contents: -12
[18249.570423] ath10k_pci 0000:04:00.0: No hardware memory
[18249.570426] ath10k_pci 0000:04:00.0: failed to copy target iram
contents: -12
[18249.620637] ath10k_pci 0000:03:00.0: htt-ver 2.2 wmi-op 6 htt-op 4
cal otp max-sta 512 raw 0 hwcrypto 1
[18249.678035] ath10k_pci 0000:04:00.0: htt-ver 2.2 wmi-op 6 htt-op 4
cal otp max-sta 512 raw 0 hwcrypto 1


ath10k: Fix device boot error:

[=C2=A0=C2=A0=C2=A0 3.318932] ath10k_pci 0000:03:00.0: pci irq msi oper_ir=
q_mode 2
irq_mode 0 reset_mode 0
[=C2=A0=C2=A0=C2=A0 3.377071] ath10k_pci 0000:04:00.0: pci irq msi oper_ir=
q_mode 2
irq_mode 0 reset_mode 0
[=C2=A0=C2=A0=C2=A0 3.434051] ath10k_pci 0000:03:00.0: qca9984/qca9994 hw1=
.0 target
0x01000000 chip_id 0x00000000 sub 168c:cafe
[=C2=A0=C2=A0=C2=A0 3.434054] ath10k_pci 0000:03:00.0: kconfig debug 0 deb=
ugfs 1
tracing 1 dfs 0 testmode 0
[=C2=A0=C2=A0=C2=A0 3.434412] ath10k_pci 0000:03:00.0: firmware ver 10.4-3=
.9.0.2-00152
api 5 features
no-p2p,mfp,peer-flow-ctrl,btcoex-param,allows-mesh-bcast,no-ps,peer-fixed-=
rate,iram-recovery
crc32 723f9771
[=C2=A0=C2=A0=C2=A0 3.487225] ath10k_pci 0000:04:00.0: qca9984/qca9994 hw1=
.0 target
0x01000000 chip_id 0x00000000 sub 168c:cafe
[=C2=A0=C2=A0=C2=A0 3.487229] ath10k_pci 0000:04:00.0: kconfig debug 0 deb=
ugfs 1
tracing 1 dfs 0 testmode 0
[=C2=A0=C2=A0=C2=A0 3.487568] ath10k_pci 0000:04:00.0: firmware ver 10.4-3=
.9.0.2-00152
api 5 features
no-p2p,mfp,peer-flow-ctrl,btcoex-param,allows-mesh-bcast,no-ps,peer-fixed-=
rate,iram-recovery
crc32 723f9771
[=C2=A0=C2=A0=C2=A0 4.665772] ath10k_pci 0000:03:00.0: board_file api 2 bm=
i_id 0:1
crc32 85498734
[=C2=A0=C2=A0=C2=A0 4.716549] ath10k_pci 0000:04:00.0: board_file api 2 bm=
i_id 0:2
crc32 85498734
[=C2=A0=C2=A0=C2=A0 7.423192] ath10k_pci 0000:04:00.0: htt-ver 2.2 wmi-op =
6 htt-op 4
cal otp max-sta 512 raw 0 hwcrypto 1
[=C2=A0=C2=A0=C2=A0 7.443109] ath10k_pci 0000:03:00.0: htt-ver 2.2 wmi-op =
6 htt-op 4
cal otp max-sta 512 raw 0 hwcrypto 1

the second fixes the error message completely and "IRAM recovery" seems
to work

best regards



