Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB71D4D8706
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 15:36:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238619AbiCNOhg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 10:37:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbiCNOhf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 10:37:35 -0400
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D773A3C72E;
        Mon, 14 Mar 2022 07:36:23 -0700 (PDT)
Received: from theinternet.molgen.mpg.de (theinternet.molgen.mpg.de [141.14.31.7])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: buczek)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 2A29161E6478B;
        Mon, 14 Mar 2022 15:36:20 +0100 (CET)
Subject: Re: [EXT] Re: [PATCH v2 net-next 1/2] bnx2x: Utilize firmware
 7.13.21.0
To:     Manish Chopra <manishc@marvell.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Paul Menzel <pmenzel@molgen.mpg.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        Alok Prasad <palok@marvell.com>,
        Prabhakar Kushwaha <pkushwaha@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "it+netdev@molgen.mpg.de" <it+netdev@molgen.mpg.de>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>
References: <20211217165552.746-1-manishc@marvell.com>
 <ea05bcab-fe72-4bc2-3337-460888b2c44e@molgen.mpg.de>
 <BY3PR18MB46129282EBA1F699583134A4AB0A9@BY3PR18MB4612.namprd18.prod.outlook.com>
 <e884cf16-3f98-e9a7-ce96-9028592246cc@molgen.mpg.de>
 <BY3PR18MB4612BC158A048053BAC7A30EAB0A9@BY3PR18MB4612.namprd18.prod.outlook.com>
 <CAHk-=wjN22EeVLviARu=amf1+422U2iswCC6cz7cN8h+S9=-Jg@mail.gmail.com>
 <BY3PR18MB4612C2FFE05879E30BAD91D7AB0A9@BY3PR18MB4612.namprd18.prod.outlook.com>
 <CAHk-=whXCf43ieh79fujcF=u3Ow1byRvWp+Lt5+v3vumA+V0yA@mail.gmail.com>
 <BY3PR18MB46124F3F575F9F7D1980E76BAB0C9@BY3PR18MB4612.namprd18.prod.outlook.com>
From:   Donald Buczek <buczek@molgen.mpg.de>
Message-ID: <0dafa9d7-9c79-f367-a343-8ad38f7bde07@molgen.mpg.de>
Date:   Mon, 14 Mar 2022 15:36:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <BY3PR18MB46124F3F575F9F7D1980E76BAB0C9@BY3PR18MB4612.namprd18.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Manish,

On 3/11/22 1:11 PM, Manish Chopra wrote:
>> -----Original Message-----
>> From: Linus Torvalds <torvalds@linux-foundation.org>
>> Sent: Thursday, March 10, 2022 3:48 AM
>> To: Manish Chopra <manishc@marvell.com>
>> Cc: Paul Menzel <pmenzel@molgen.mpg.de>; kuba@kernel.org;
>> netdev@vger.kernel.org; Ariel Elior <aelior@marvell.com>; Alok Prasad
>> <palok@marvell.com>; Prabhakar Kushwaha <pkushwaha@marvell.com>;
>> David S. Miller <davem@davemloft.net>; Greg KH
>> <gregkh@linuxfoundation.org>; stable@vger.kernel.org;
>> it+netdev@molgen.mpg.de; regressions@lists.linux.dev
>> Subject: Re: [EXT] Re: [PATCH v2 net-next 1/2] bnx2x: Utilize firmware
>> 7.13.21.0
>>
>> On Wed, Mar 9, 2022 at 11:46 AM Manish Chopra <manishc@marvell.com>
>> wrote:
>>>
>>> This has not changed anything functionally from driver/device perspective,
>> FW is still being loaded only when device is opened.
>>> bnx2x_init_firmware() [I guess, perhaps the name is misleading] just
>> request_firmware() to prepare the metadata to be used when device will be
>> opened.
>>
>> So how do you explain the report by Paul Menzel that things used to work and
>> no longer work now?
>>
> 
> The issue which Paul mentioned had to do with "/lib/firmware/bnx2x/* file not found" when driver probes, which was introduced by the patch in subject,
> And the commit e13ad1443684 ("bnx2x: fix driver load from initrd") fixes this issue. So things should work as it is with the mentioned fixed commit.
> The only discussion led by this problem now is why the request_firmware() was moved early on [from open() to probe()] by the patch in subject.
> I explained the intention to do this in my earlier emails and let me add more details below -
> 
> Note that we have just moved request_firmware() logic, *not* something significant which has to do with actual FW loading or device initialization from the
> FW file data which could cause significant functional change for this device/driver, FW load/init part still stays in open flow.
> 
> Before the patch in subject, driver used to only work with fixed/specific FW version file whose version was statically known to the driver function at probe() time to take
> some decision to fail the function probe early in the system if the function is supposed to run with a FW version which is not the same version loaded on the device by another PF (different ENV).
> Now when we sent this new FW patch (in subject) then we got feedback from community to maintain backward compatibility with older FW versions as well and we did it in same v2 patch legitimately,
> just that now we can work with both older or newer FW file so we need this run time FW version information to cache (based on request_firmware() return success value for an old FW file or new FW file)
> which will be used in follow up probe() flows to decide the function probe failure early If there could be FW version mismatches against the loaded FW on the device by other PFs already

There might be something more wrong with the patch in the subject: The usability of the ports from a single card (with older firmware?) now depends on the order the ports are enabled (first port enabled is working, second port enabled is not working, driver complaining about a firmware mismatch).

In the following examples, the driver was not built-in to the kernel but loaded from the root filesystem instead, so there is no initramfs related problem here.

For the records:

root@ira:~# dmesg|grep bnx2x
[   18.749871] bnx2x 0000:45:00.0: msix capability found
[   18.766534] bnx2x 0000:45:00.0: part number 394D4342-31373735-31314131-473331
[   18.799198] bnx2x 0000:45:00.0: 32.000 Gb/s available PCIe bandwidth (5.0 GT/s PCIe x8 link)
[   18.807638] bnx2x 0000:45:00.1: msix capability found
[   18.824509] bnx2x 0000:45:00.1: part number 394D4342-31373735-31314131-473331
[   18.857171] bnx2x 0000:45:00.1: 32.000 Gb/s available PCIe bandwidth (5.0 GT/s PCIe x8 link)
[   18.865619] bnx2x 0000:46:00.0: msix capability found
[   18.882636] bnx2x 0000:46:00.0: part number 394D4342-31373735-31314131-473331
[   18.915196] bnx2x 0000:46:00.0: 32.000 Gb/s available PCIe bandwidth (5.0 GT/s PCIe x8 link)
[   18.923636] bnx2x 0000:46:00.1: msix capability found
[   18.940505] bnx2x 0000:46:00.1: part number 394D4342-31373735-31314131-473331
[   18.973167] bnx2x 0000:46:00.1: 32.000 Gb/s available PCIe bandwidth (5.0 GT/s PCIe x8 link)
[   46.480660] bnx2x 0000:45:00.0 net04: renamed from eth4
[   46.494677] bnx2x 0000:45:00.1 net05: renamed from eth5
[   46.508544] bnx2x 0000:46:00.0 net06: renamed from eth6
[   46.524641] bnx2x 0000:46:00.1 net07: renamed from eth7
root@ira:~# ls /lib/firmware/bnx2x/
bnx2x-e1-6.0.34.0.fw   bnx2x-e1-7.13.1.0.fw   bnx2x-e1-7.8.2.0.fw     bnx2x-e1h-7.12.30.0.fw  bnx2x-e1h-7.8.19.0.fw  bnx2x-e2-7.10.51.0.fw  bnx2x-e2-7.8.17.0.fw
bnx2x-e1-6.2.5.0.fw    bnx2x-e1-7.13.11.0.fw  bnx2x-e1h-6.0.34.0.fw   bnx2x-e1h-7.13.1.0.fw   bnx2x-e1h-7.8.2.0.fw   bnx2x-e2-7.12.30.0.fw  bnx2x-e2-7.8.19.0.fw
bnx2x-e1-6.2.9.0.fw    bnx2x-e1-7.13.15.0.fw  bnx2x-e1h-6.2.5.0.fw    bnx2x-e1h-7.13.11.0.fw  bnx2x-e2-6.0.34.0.fw   bnx2x-e2-7.13.1.0.fw   bnx2x-e2-7.8.2.0.fw
bnx2x-e1-7.0.20.0.fw   bnx2x-e1-7.13.21.0.fw  bnx2x-e1h-6.2.9.0.fw    bnx2x-e1h-7.13.15.0.fw  bnx2x-e2-6.2.5.0.fw    bnx2x-e2-7.13.11.0.fw
bnx2x-e1-7.0.23.0.fw   bnx2x-e1-7.2.16.0.fw   bnx2x-e1h-7.0.20.0.fw   bnx2x-e1h-7.13.21.0.fw  bnx2x-e2-6.2.9.0.fw    bnx2x-e2-7.13.15.0.fw
bnx2x-e1-7.0.29.0.fw   bnx2x-e1-7.2.51.0.fw   bnx2x-e1h-7.0.23.0.fw   bnx2x-e1h-7.2.16.0.fw   bnx2x-e2-7.0.20.0.fw   bnx2x-e2-7.13.21.0.fw
bnx2x-e1-7.10.51.0.fw  bnx2x-e1-7.8.17.0.fw   bnx2x-e1h-7.0.29.0.fw   bnx2x-e1h-7.2.51.0.fw   bnx2x-e2-7.0.23.0.fw   bnx2x-e2-7.2.16.0.fw
bnx2x-e1-7.12.30.0.fw  bnx2x-e1-7.8.19.0.fw   bnx2x-e1h-7.10.51.0.fw  bnx2x-e1h-7.8.17.0.fw   bnx2x-e2-7.0.29.0.fw   bnx2x-e2-7.2.51.0.fw

Now with v5.10.95, the first kernel of the series which includes fdcfabd0952d ("bnx2x: Utilize firmware 7.13.21.0") and later:

root@ira:~# dmesg -w &
[...]
root@ira:~# ip link set net04 up
[   88.504536] bnx2x 0000:45:00.0 net04: using MSI-X  IRQs: sp 47  fp[0] 49 ... fp[7] 56
root@ira:~# ip link set net05 up
[   90.825820] bnx2x: [bnx2x_compare_fw_ver:2380(net05)]bnx2x with FW 120d07 was already loaded which mismatches my 150d07 FW. Aborting
RTNETLINK answers: Device or resource busy
root@ira:~# ip link set net04 down
root@ira:~# ip link set net05 down
root@ira:~# ip link set net05 up
[  114.462448] bnx2x 0000:45:00.1 net05: using MSI-X  IRQs: sp 58  fp[0] 60 ... fp[7] 67
root@ira:~# ip link set net04 up
[  117.247763] bnx2x: [bnx2x_compare_fw_ver:2380(net04)]bnx2x with FW 120d07 was already loaded which mismatches my 150d07 FW. Aborting
RTNETLINK answers: Device or resource busy

With v5.10.94, both ports work fine:

root@ira:~# dmesg -w &
[...]
root@ira:~# ip link set net04 up
[  133.126647] bnx2x 0000:45:00.0 net04: using MSI-X  IRQs: sp 47  fp[0] 49 ... fp[7] 56
root@ira:~# ip link set net05 up
[  136.215169] bnx2x 0000:45:00.1 net05: using MSI-X  IRQs: sp 58  fp[0] 60 ... fp[7] 67

Best
   Donald


> So we need to understand why we should not call request_firmware() in probe or at least what's really harmful in doing that in probe() if some of the follow up probe flows needs
> some of the metadata info (like the run time FW versions info in this case which we get based on request_firmware() return value), we could avoid this but we don't want
> to add some ugly/unsuitable file APIs checks to know which FW version file is available on the file system if there is already an API request_firmware() available for this to be used.
> 
> Please let us know. Thanks.
> 
>> You can't do request_firmware() early. When you actually then push the
>> firmware to the device is immaterial - but request_firmware() has to be done
>> after the system is up and running.
>>
>>                   Linus
> 


-- 
Donald Buczek
buczek@molgen.mpg.de
Tel: +49 30 8413 1433
