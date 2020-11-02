Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 948572A2EEE
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 17:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbgKBQDX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 11:03:23 -0500
Received: from z5.mailgun.us ([104.130.96.5]:11009 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726385AbgKBQDS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 11:03:18 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1604332997; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: In-Reply-To: Date: References: Subject: Cc:
 To: From: Sender; bh=xNCnI8IEieWgYDa9EFAGk4BnGJ1SylWmAUPiSZMRsUc=; b=iAowiBRd6mX1OjoSoPPcygYuZ3dahqjPHXBKL93/UnPakz8efbbtusgTJC1G99lJRbgQItad
 v1eCTvDFHn+maE0Dc8l+RR6v2BhAuWPqAIj99/QYiLyW4aQ7FfbKChMRqnHnfZoyNBxWHLjH
 G0dShqt0FvFEwzAtYGKXTFWsaQc=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 5fa02d94d981633da320618b (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 02 Nov 2020 16:02:28
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 83A00C433FE; Mon,  2 Nov 2020 16:02:28 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from x230.qca.qualcomm.com (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8AB5DC433C6;
        Mon,  2 Nov 2020 16:02:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8AB5DC433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Ulf Hansson <ulf.hansson@linaro.org>
Cc:     =?utf-8?B?SsOpcsO0bWU=?= Pouiller <jerome.pouiller@silabs.com>,
        Pali =?utf-8?Q?Roh=C3=A1r?= <pali@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        driverdevel <devel@driverdev.osuosl.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        DTML <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-mmc\@vger.kernel.org" <linux-mmc@vger.kernel.org>
Subject: Re: [PATCH 07/23] wfx: add bus_sdio.c
References: <20201012104648.985256-1-Jerome.Pouiller@silabs.com>
        <2628294.9EgBEFZmRI@pc-42> <20201014124334.lgx53qvtgkmfkepc@pali>
        <2444203.ROLCPKctRj@pc-42>
        <CAPDyKFqCn386r4ecLDnMQmxrAZCvU9r=-eY71UUNpXWNxKOz2g@mail.gmail.com>
Date:   Mon, 02 Nov 2020 18:02:22 +0200
In-Reply-To: <CAPDyKFqCn386r4ecLDnMQmxrAZCvU9r=-eY71UUNpXWNxKOz2g@mail.gmail.com>
        (Ulf Hansson's message of "Fri, 16 Oct 2020 13:54:48 +0200")
Message-ID: <87eelbpx0x.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ulf Hansson <ulf.hansson@linaro.org> writes:

> On Thu, 15 Oct 2020 at 16:03, J=C3=A9r=C3=B4me Pouiller
> <jerome.pouiller@silabs.com> wrote:
>>
>> On Wednesday 14 October 2020 14:43:34 CEST Pali Roh=C3=A1r wrote:
>> > On Wednesday 14 October 2020 13:52:15 J=C3=A9r=C3=B4me Pouiller wrote:
>> > > On Tuesday 13 October 2020 22:11:56 CEST Pali Roh=C3=A1r wrote:
>> > > > On Monday 12 October 2020 12:46:32 Jerome Pouiller wrote:
>> > > > > +#define SDIO_VENDOR_ID_SILABS        0x0000
>> > > > > +#define SDIO_DEVICE_ID_SILABS_WF200  0x1000
>> > > > > +static const struct sdio_device_id wfx_sdio_ids[] =3D {
>> > > > > +     { SDIO_DEVICE(SDIO_VENDOR_ID_SILABS, SDIO_DEVICE_ID_SILABS=
_WF200) },
>> > > >
>> > > > Please move ids into common include file include/linux/mmc/sdio_id=
s.h
>> > > > where are all SDIO ids. Now all drivers have ids defined in that f=
ile.
>> > > >
>> > > > > +     // FIXME: ignore VID/PID and only rely on device tree
>> > > > > +     // { SDIO_DEVICE(SDIO_ANY_ID, SDIO_ANY_ID) },
>> > > >
>> > > > What is the reason for ignoring vendor and device ids?
>> > >
>> > > The device has a particularity, its VID/PID is 0000:1000 (as you can=
 see
>> > > above). This value is weird. The risk of collision with another devi=
ce is
>> > > high.
>> >
>> > Those ids looks strange. You are from Silabs, can you check internally
>> > in Silabs if ids are really correct? And which sdio vendor id you in
>> > Silabs got assigned for your products?
>>
>> I confirm these ids are the ones burned in the WF200. We have to deal wi=
th
>> that :( .
>
> Yep. Unfortunately this isn't so uncommon when targeting the embedded
> types of devices.
>
> The good thing is, that we already have bindings allowing us to specify t=
his.
>
>>
>>
>> > I know that sdio devices with multiple functions may have different sd=
io
>> > vendor/device id particular function and in common CIS (function 0).
>> >
>> > Could not be a problem that on one place is vendor/device id correct a=
nd
>> > on other place is that strange value?
>> >
>> > I have sent following patch (now part of upstream kernel) which exports
>> > these ids to userspace:
>> > https://lore.kernel.org/linux-mmc/20200527110858.17504-2-pali@kernel.o=
rg/T/#u
>> >
>> > Also for debugging ids and information about sdio cards, I sent another
>> > patch which export additional data:
>> > https://lore.kernel.org/linux-mmc/20200727133837.19086-1-pali@kernel.o=
rg/T/#u
>> >
>> > Could you try them and look at /sys/class/mmc_host/ attribute outputs?
>>
>> Here is:
>>
>>     # cd /sys/class/mmc_host/ && grep -r . mmc1/
>>     mmc1/power/runtime_suspended_time:0
>>     grep: mmc1/power/autosuspend_delay_ms: Input/output error
>>     mmc1/power/runtime_active_time:0
>>     mmc1/power/control:auto
>>     mmc1/power/runtime_status:unsupported
>>     mmc1/mmc1:0001/vendor:0x0000
>>     mmc1/mmc1:0001/rca:0x0001
>>     mmc1/mmc1:0001/device:0x1000
>>     mmc1/mmc1:0001/mmc1:0001:1/vendor:0x0000
>>     mmc1/mmc1:0001/mmc1:0001:1/device:0x1000
>>     grep: mmc1/mmc1:0001/mmc1:0001:1/info4: No data available
>>     mmc1/mmc1:0001/mmc1:0001:1/power/runtime_suspended_time:0
>>     grep: mmc1/mmc1:0001/mmc1:0001:1/power/autosuspend_delay_ms: Input/o=
utput error
>>     mmc1/mmc1:0001/mmc1:0001:1/power/runtime_active_time:0
>>     mmc1/mmc1:0001/mmc1:0001:1/power/control:auto
>>     mmc1/mmc1:0001/mmc1:0001:1/power/runtime_status:unsupported
>>     mmc1/mmc1:0001/mmc1:0001:1/class:0x00
>>     grep: mmc1/mmc1:0001/mmc1:0001:1/info2: No data available
>>     mmc1/mmc1:0001/mmc1:0001:1/modalias:sdio:c00v0000d1000
>>     mmc1/mmc1:0001/mmc1:0001:1/revision:0.0
>>     mmc1/mmc1:0001/mmc1:0001:1/uevent:OF_NAME=3Dmmc
>>     mmc1/mmc1:0001/mmc1:0001:1/uevent:OF_FULLNAME=3D/soc/sdhci@7e300000/=
mmc@1
>>     mmc1/mmc1:0001/mmc1:0001:1/uevent:OF_COMPATIBLE_0=3Dsilabs,wfx-sdio
>>     mmc1/mmc1:0001/mmc1:0001:1/uevent:OF_COMPATIBLE_N=3D1
>>     mmc1/mmc1:0001/mmc1:0001:1/uevent:SDIO_CLASS=3D00
>>     mmc1/mmc1:0001/mmc1:0001:1/uevent:SDIO_ID=3D0000:1000
>>     mmc1/mmc1:0001/mmc1:0001:1/uevent:SDIO_REVISION=3D0.0
>>     mmc1/mmc1:0001/mmc1:0001:1/uevent:MODALIAS=3Dsdio:c00v0000d1000
>>     grep: mmc1/mmc1:0001/mmc1:0001:1/info3: No data available
>>     grep: mmc1/mmc1:0001/mmc1:0001:1/info1: No data available
>>     mmc1/mmc1:0001/ocr:0x00200000
>>     grep: mmc1/mmc1:0001/info4: No data available
>>     mmc1/mmc1:0001/power/runtime_suspended_time:0
>>     grep: mmc1/mmc1:0001/power/autosuspend_delay_ms: Input/output error
>>     mmc1/mmc1:0001/power/runtime_active_time:0
>>     mmc1/mmc1:0001/power/control:auto
>>     mmc1/mmc1:0001/power/runtime_status:unsupported
>>     grep: mmc1/mmc1:0001/info2: No data available
>>     mmc1/mmc1:0001/type:SDIO
>>     mmc1/mmc1:0001/revision:0.0
>>     mmc1/mmc1:0001/uevent:MMC_TYPE=3DSDIO
>>     mmc1/mmc1:0001/uevent:SDIO_ID=3D0000:1000
>>     mmc1/mmc1:0001/uevent:SDIO_REVISION=3D0.0
>>     grep: mmc1/mmc1:0001/info3: No data available
>>     grep: mmc1/mmc1:0001/info1: No data available
>>
>>
>
> Please have a look at the
> Documentation/devicetree/bindings/mmc/mmc-controller.yaml, there you
> find that from a child node of the mmc host's node, we can specify an
> embedded SDIO functional device.
>
> In sdio_add_func(), which calls sdio_set_of_node() - we assign the
> func->dev.of_node its corresponding child node for the SDIO func.
> Allowing the sdio functional driver to be matched with the SDIO func
> device.
>
> Perhaps what is missing, is that we may want to avoid probing an
> in-correct sdio driver, based upon buggy SDIO ids. I don't think we
> take some actions in the mmc core to prevent this, but maybe it's not
> a big problem anyway.
>
> When it comes to documenting the buggy SDIO ids, please add some
> information about this in the common SDIO headers. It's nice to have a
> that information, if any issue comes up later on.

And if there's some special setup (DT etc) needed to get the wireless
driver working that should be documented in the driver side as well. The
expectation is that an upstream driver is just plug and play, and if
it's not there should be clear documentation how to enable the driver.

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
