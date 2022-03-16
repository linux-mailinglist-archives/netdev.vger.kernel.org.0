Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F05904DB6F4
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 18:14:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346866AbiCPRPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 13:15:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237728AbiCPRPa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 13:15:30 -0400
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A2B95A5B4;
        Wed, 16 Mar 2022 10:14:15 -0700 (PDT)
Received: from [192.168.0.3] (ip5f5aef39.dynamic.kabel-deutschland.de [95.90.239.57])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id BB1DC61EA1930;
        Wed, 16 Mar 2022 18:14:13 +0100 (CET)
Message-ID: <bad00633-e66a-2ae0-dff6-1ef53686cfac@molgen.mpg.de>
Date:   Wed, 16 Mar 2022 18:14:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [EXT] Re: [PATCH v2 net-next 1/2] bnx2x: Utilize firmware
 7.13.21.0
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Manish Chopra <manishc@marvell.com>,
        Donald Buczek <buczek@molgen.mpg.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        netdev@vger.kernel.org, Ariel Elior <aelior@marvell.com>,
        Alok Prasad <palok@marvell.com>,
        Prabhakar Kushwaha <pkushwaha@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        it+netdev@molgen.mpg.de, regressions@lists.linux.dev
References: <20211217165552.746-1-manishc@marvell.com>
 <ea05bcab-fe72-4bc2-3337-460888b2c44e@molgen.mpg.de>
 <BY3PR18MB46129282EBA1F699583134A4AB0A9@BY3PR18MB4612.namprd18.prod.outlook.com>
 <e884cf16-3f98-e9a7-ce96-9028592246cc@molgen.mpg.de>
 <BY3PR18MB4612BC158A048053BAC7A30EAB0A9@BY3PR18MB4612.namprd18.prod.outlook.com>
 <CAHk-=wjN22EeVLviARu=amf1+422U2iswCC6cz7cN8h+S9=-Jg@mail.gmail.com>
 <BY3PR18MB4612C2FFE05879E30BAD91D7AB0A9@BY3PR18MB4612.namprd18.prod.outlook.com>
 <CAHk-=whXCf43ieh79fujcF=u3Ow1byRvWp+Lt5+v3vumA+V0yA@mail.gmail.com>
 <BY3PR18MB46124F3F575F9F7D1980E76BAB0C9@BY3PR18MB4612.namprd18.prod.outlook.com>
 <0dafa9d7-9c79-f367-a343-8ad38f7bde07@molgen.mpg.de>
 <9513e74e-c682-d891-a5de-c9a82c5cf9d3@molgen.mpg.de>
 <20220314195735.6ada196d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20220314195735.6ada196d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Jakub,


Am 15.03.22 um 03:57 schrieb Jakub Kicinski:
> On Mon, 14 Mar 2022 16:07:08 +0100 Paul Menzel wrote:
>>> There might be something more wrong with the patch in the subject: The
>>> usability of the ports from a single card (with older firmware?) now
>>> depends on the order the ports are enabled (first port enabled is
>>> working, second port enabled is not working, driver complaining about a
>>> firmware mismatch).
>>>
>>> In the following examples, the driver was not built-in to the kernel but
>>> loaded from the root filesystem instead, so there is no initramfs
>>> related problem here.
>>>
>>> For the records:
>>>
>>> root@ira:~# dmesg|grep bnx2x
>>> [   18.749871] bnx2x 0000:45:00.0: msix capability found
>>> [   18.766534] bnx2x 0000:45:00.0: part number 394D4342-31373735-31314131-473331
>>> [   18.799198] bnx2x 0000:45:00.0: 32.000 Gb/s available PCIe bandwidth (5.0 GT/s PCIe x8 link)
>>> [   18.807638] bnx2x 0000:45:00.1: msix capability found
>>> [   18.824509] bnx2x 0000:45:00.1: part number 394D4342-31373735-31314131-473331
>>> [   18.857171] bnx2x 0000:45:00.1: 32.000 Gb/s available PCIe bandwidth (5.0 GT/s PCIe x8 link)
>>> [   18.865619] bnx2x 0000:46:00.0: msix capability found
>>> [   18.882636] bnx2x 0000:46:00.0: part number 394D4342-31373735-31314131-473331
>>> [   18.915196] bnx2x 0000:46:00.0: 32.000 Gb/s available PCIe bandwidth (5.0 GT/s PCIe x8 link)
>>> [   18.923636] bnx2x 0000:46:00.1: msix capability found
>>> [   18.940505] bnx2x 0000:46:00.1: part number 394D4342-31373735-31314131-473331
>>> [   18.973167] bnx2x 0000:46:00.1: 32.000 Gb/s available PCIe bandwidth (5.0 GT/s PCIe x8 link)
>>> [   46.480660] bnx2x 0000:45:00.0 net04: renamed from eth4
>>> [   46.494677] bnx2x 0000:45:00.1 net05: renamed from eth5
>>> [   46.508544] bnx2x 0000:46:00.0 net06: renamed from eth6
>>> [   46.524641] bnx2x 0000:46:00.1 net07: renamed from eth7
>>> root@ira:~# ls /lib/firmware/bnx2x/
>>> bnx2x-e1-6.0.34.0.fw   bnx2x-e1-7.13.1.0.fw   bnx2x-e1-7.8.2.0.fw
>>> bnx2x-e1h-7.12.30.0.fw  bnx2x-e1h-7.8.19.0.fw  bnx2x-e2-7.10.51.0.fw  bnx2x-e2-7.8.17.0.fw
>>> bnx2x-e1-6.2.5.0.fw    bnx2x-e1-7.13.11.0.fw  bnx2x-e1h-6.0.34.0.fw
>>> bnx2x-e1h-7.13.1.0.fw   bnx2x-e1h-7.8.2.0.fw   bnx2x-e2-7.12.30.0.fw  bnx2x-e2-7.8.19.0.fw
>>> bnx2x-e1-6.2.9.0.fw    bnx2x-e1-7.13.15.0.fw  bnx2x-e1h-6.2.5.0.fw
>>> bnx2x-e1h-7.13.11.0.fw  bnx2x-e2-6.0.34.0.fw   bnx2x-e2-7.13.1.0.fw   bnx2x-e2-7.8.2.0.fw
>>> bnx2x-e1-7.0.20.0.fw   bnx2x-e1-7.13.21.0.fw  bnx2x-e1h-6.2.9.0.fw
>>> bnx2x-e1h-7.13.15.0.fw  bnx2x-e2-6.2.5.0.fw    bnx2x-e2-7.13.11.0.fw
>>> bnx2x-e1-7.0.23.0.fw   bnx2x-e1-7.2.16.0.fw   bnx2x-e1h-7.0.20.0.fw
>>> bnx2x-e1h-7.13.21.0.fw  bnx2x-e2-6.2.9.0.fw    bnx2x-e2-7.13.15.0.fw
>>> bnx2x-e1-7.0.29.0.fw   bnx2x-e1-7.2.51.0.fw   bnx2x-e1h-7.0.23.0.fw
>>> bnx2x-e1h-7.2.16.0.fw   bnx2x-e2-7.0.20.0.fw   bnx2x-e2-7.13.21.0.fw
>>> bnx2x-e1-7.10.51.0.fw  bnx2x-e1-7.8.17.0.fw   bnx2x-e1h-7.0.29.0.fw
>>> bnx2x-e1h-7.2.51.0.fw   bnx2x-e2-7.0.23.0.fw   bnx2x-e2-7.2.16.0.fw
>>> bnx2x-e1-7.12.30.0.fw  bnx2x-e1-7.8.19.0.fw   bnx2x-e1h-7.10.51.0.fw
>>> bnx2x-e1h-7.8.17.0.fw   bnx2x-e2-7.0.29.0.fw   bnx2x-e2-7.2.51.0.fw
>>>
>>> Now with v5.10.95, the first kernel of the series which includes
>>> fdcfabd0952d ("bnx2x: Utilize firmware 7.13.21.0") and later:
>>>
>>> root@ira:~# dmesg -w &
>>> [...]
>>> root@ira:~# ip link set net04 up
>>> [   88.504536] bnx2x 0000:45:00.0 net04: using MSI-X  IRQs: sp 47  fp[0] 49 ... fp[7] 56
>>> root@ira:~# ip link set net05 up
>>> [   90.825820] bnx2x: [bnx2x_compare_fw_ver:2380(net05)]bnx2x with FW 120d07 was already loaded which mismatches my 150d07 FW. Aborting
>>> RTNETLINK answers: Device or resource busy
>>> root@ira:~# ip link set net04 down
>>> root@ira:~# ip link set net05 down
>>> root@ira:~# ip link set net05 up
>>> [  114.462448] bnx2x 0000:45:00.1 net05: using MSI-X  IRQs: sp 58  fp[0] 60 ... fp[7] 67
>>> root@ira:~# ip link set net04 up
>>> [  117.247763] bnx2x: [bnx2x_compare_fw_ver:2380(net04)]bnx2x with FW 120d07 was already loaded which mismatches my 150d07 FW. Aborting
>>> RTNETLINK answers: Device or resource busy
>>>
>>> With v5.10.94, both ports work fine:
>>>
>>> root@ira:~# dmesg -w &
>>> [...]
>>> root@ira:~# ip link set net04 up
>>> [  133.126647] bnx2x 0000:45:00.0 net04: using MSI-X  IRQs: sp 47  fp[0] 49 ... fp[7] 56
>>> root@ira:~# ip link set net05 up
>>> [  136.215169] bnx2x 0000:45:00.1 net05: using MSI-X  IRQs: sp 58  fp[0] 60 ... fp[7] 67
>>
>> One additional note, that it’s totally unclear to us, where FW version
>> 120d07 in the error message comes from. It maps to 7.13.18.0, which is
>> nowhere to be found and too new to be on the cards EEPROM, which should
>> be from 2013 or so.
> 
> Hrm, any chance an out-of-tree driver or another OS loaded it?

No, no such chance. The system firmware was not touched in the last five 
years, and there is no other OS.

> Does the dmesg indicate that the host loaded the FW at all?

Unfortunately, no such Linux log messages exist (in the code).

> Looks like upstream went from .15 to .21, .18 was never in the picture.

Yes, that is the strange thing. Is there any chance, that the `.18` is 
in the firmware file somehow, and was forgotten to be updated to `.21`?

```
$ md5sum /lib/firmware/bnx2x/*{15,21}*
4137c813f3ff937f01fddf13c309d972  /lib/firmware/bnx2x/bnx2x-e1-7.13.15.0.fw
075539e1072908a0c86ba352c1130f60  /lib/firmware/bnx2x/bnx2x-e1h-7.13.15.0.fw
e59925dedf7ed95679e629dfeeaf5803  /lib/firmware/bnx2x/bnx2x-e2-7.13.15.0.fw
a470a0d77930ef72ac7b725a5ff447fe  /lib/firmware/bnx2x/bnx2x-e1-7.13.21.0.fw
f02012b118664c0579ab58757f276982  /lib/firmware/bnx2x/bnx2x-e1h-7.13.21.0.fw
47667a7bf156d1e531fde42d800e4a66  /lib/firmware/bnx2x/bnx2x-e2-7.13.21.0.fw
```

> Also, will the revert work for you?

I tested reverting the three patches you also listed on top of 5.10.103, 
and that restored the working behavior. Manish’s patch *[RFC net] bnx2x: 
fix built-in kernel driver load failure* also fixes the issue.


Kind regards,

Paul
