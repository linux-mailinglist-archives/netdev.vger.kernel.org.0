Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17F334D61EB
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 14:00:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243439AbiCKNBc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 08:01:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348697AbiCKNB3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 08:01:29 -0500
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A8431C0256;
        Fri, 11 Mar 2022 05:00:24 -0800 (PST)
Received: from [192.168.0.7] (ip5f5ae8da.dynamic.kabel-deutschland.de [95.90.232.218])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 7C54061EA1927;
        Fri, 11 Mar 2022 14:00:21 +0100 (CET)
Message-ID: <a805fbcd-7246-1fe4-038d-2859ad072c72@molgen.mpg.de>
Date:   Fri, 11 Mar 2022 14:00:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [EXT] Re: [PATCH v2 net-next 1/2] bnx2x: Utilize firmware
 7.13.21.0
Content-Language: en-US
To:     Manish Chopra <manishc@marvell.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
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
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <BY3PR18MB46124F3F575F9F7D1980E76BAB0C9@BY3PR18MB4612.namprd18.prod.outlook.com>
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

Dear Manish,


As a side note, it’d be great if you could use an email client, better 
supporting quoting.


Am 11.03.22 um 13:11 schrieb Manish Chopra:
>> -----Original Message-----
>> From: Linus Torvalds <torvalds@linux-foundation.org>
>> Sent: Thursday, March 10, 2022 3:48 AM

[…]

>> On Wed, Mar 9, 2022 at 11:46 AM Manish Chopra <manishc@marvell.com>
>> wrote:
>>>
>>> This has not changed anything functionally from driver/device perspective,
>>> FW is still being loaded only when device is opened.
>>> bnx2x_init_firmware() [I guess, perhaps the name is misleading] just
>>> request_firmware() to prepare the metadata to be used when device will be
>>> opened.
>>
>> So how do you explain the report by Paul Menzel that things used to work and
>> no longer work now?
> 
> The issue which Paul mentioned had to do with "/lib/firmware/bnx2x/*
> file not found" when driver probes, which was introduced by the patch
> in subject, And the commit e13ad1443684 ("bnx2x: fix driver load from
> initrd") fixes this issue. So things should work as it is with the
> mentioned fixed commit.
No, your statement is incorrect. I already corrected it in a previous 
reply. The commit you mentioned was backported to 5.10.103. As we used 
that version, your commit was present.

> The only discussion led by this problem now is why the
> request_firmware() was moved early on [from open() to probe()] by the
> patch in subject. I explained the intention to do this in my earlier
> emails and let me add more details below -
> 
> Note that we have just moved request_firmware() logic, *not*
> something significant which has to do with actual FW loading or
> device initialization from the FW file data which could cause
> significant functional change for this device/driver, FW load/init
> part still stays in open flow.
> 
> Before the patch in subject, driver used to only work with
> fixed/specific FW version file whose version was statically known to
> the driver function at probe() time to take some decision to fail the
> function probe early in the system if the function is supposed to run
> with a FW version which is not the same version loaded on the device
> by another PF (different ENV). Now when we sent this new FW patch (in
> subject) then we got feedback from community to maintain backward
> compatibility with older FW versions as well and we did it in same v2
> patch legitimately, just that now we can work with both older or
> newer FW file so we need this run time FW version information to
> cache (based on request_firmware() return success value for an old FW
> file or new FW file) which will be used in follow up probe() flows to
> decide the function probe failure early If there could be FW version
> mismatches against the loaded FW on the device by other PFs already
> 
> So we need to understand why we should not call request_firmware() in
> probe or at least what's really harmful in doing that in probe() if
> some of the follow up probe flows needs some of the metadata info
> (like the run time FW versions info in this case which we get based
> on request_firmware() return value), we could avoid this but we don't
> want to add some ugly/unsuitable file APIs checks to know which FW
> version file is available on the file system if there is already an
> API request_firmware() available for this to be used.
Your patches broke loading the driver, and as a result – as seen from 
the pastes I provided – the network devices were not functional.

> Please let us know. Thanks.
> 
>> You can't do request_firmware() early. When you actually then push the
>> firmware to the device is immaterial - but request_firmware() has to be done
>> after the system is up and running.


Kind regards,

Paul
