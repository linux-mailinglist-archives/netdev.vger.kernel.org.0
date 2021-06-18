Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 494293AD23C
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 20:35:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233627AbhFRShS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 14:37:18 -0400
Received: from mail-0201.mail-europe.com ([51.77.79.158]:46170 "EHLO
        mail-0201.mail-europe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233141AbhFRShO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 14:37:14 -0400
Date:   Fri, 18 Jun 2021 18:34:50 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=connolly.tech;
        s=protonmail; t=1624041301;
        bh=gPJStNIBkyU+EiKyKIcmWvO+oVN/hGtsoDaeZGrgtAM=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=Ccq/7+LgItQsJkh0Xxxpd8NbhZbrDXI7N1Xv3NWVjpArRTWpOqEKSmPKYNXjz1ZuJ
         jn4T306aVgOByi+oKKxx8GE/hLOIEHqzl0C1EsmpEPJV3v7Eosw2QIfqlBDTNzjHjc
         VJhJswathmzV+6z5Uz5oUuoKcnZePuKdaboC+rx8=
To:     Kalle Valo <kvalo@codeaurora.org>
From:   Caleb Connolly <caleb@connolly.tech>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        ~postmarketos/upstreaming@lists.sr.ht, phone-devel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Reply-To: Caleb Connolly <caleb@connolly.tech>
Subject: Re: [PATCH] ath10k: demote chan info without scan request warning
Message-ID: <f983af18-6a17-4cf1-a577-a86e4498b212@connolly.tech>
In-Reply-To: <871r96yw6z.fsf@codeaurora.org>
References: <20210522171609.299611-1-caleb@connolly.tech> <20210612103640.2FD93C433F1@smtp.codeaurora.org> <f39034ea-f4da-1564-e22f-398e4a1ae077@connolly.tech> <871r96yw6z.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 13/06/2021 10:01 am, Kalle Valo wrote:
> Caleb Connolly <caleb@connolly.tech> writes:
>
>> Hi Kalle,
>>
>> On 12/06/2021 11:36 am, Kalle Valo wrote:
>>> Caleb Connolly <caleb@connolly.tech> wrote:
>>>
>>>> Some devices/firmwares cause this to be printed every 5-15 seconds,
>>>> though it has no impact on functionality. Demote this to a debug
>>>> message.
>>>>
>>>> Signed-off-by: Caleb Connolly <caleb@connolly.tech>
>>>> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
>>
>> Is this meant to be an Ack?
>
> No, my patchwork script has few quirks and it actually takes the quoted
> text from my pending branch, not from your actual email. That's why you
> see my s-o-b there. I haven't bothered to fix that yet, but hopefully
> one day.
>
>>> On what hardware and firmware version do you see this?
>>
>> I see this on SDM845 and MSM8998 platforms, specifically the OnePlus 6
>> devices, PocoPhone F1 and OnePlus 5.
>> On the OnePlus 6 (SDM845) we are stuck with the following signed vendor =
fw:
>>
>> [    9.339873] ath10k_snoc 18800000.wifi: qmi chip_id 0x30214
>> chip_family 0x4001 board_id 0xff soc_id 0x40030001
>> [    9.339897] ath10k_snoc 18800000.wifi: qmi fw_version 0x20060029
>> fw_build_timestamp 2019-07-12 02:14 fw_build_id
>> QC_IMAGE_VERSION_STRING=3DWLAN.HL.2.0.c8-00041-QCAHLSWMTPLZ-1
>>
>> The OnePlus 5 (MSM8998) is using firmware:
>>
>> [ 6096.956799] ath10k_snoc 18800000.wifi: qmi chip_id 0x30214
>> chip_family 0x4001 board_id 0xff soc_id 0x40010002
>> [ 6096.956824] ath10k_snoc 18800000.wifi: qmi fw_version 0x1007007e
>> fw_build_timestamp 2020-04-14 22:45 fw_build_id
>> QC_IMAGE_VERSION_STRING=3DWLAN.HL.1.0.c6-00126-QCAHLSWMTPLZ-1.211883.1.2=
78648.
>
> Thanks, I'll include this information to the commit log and then apply
> the patch. And I'll assume you have also tested this patch on those
> platforms so that I can add a Tested-on tag?
Yeah, go ahead. Sorry for the late reply!
>
> BTW, ath10k should strip that ugly "QC_IMAGE_VERSION_STRING=3D" string in
> the firmware version. Patches very welcome :)
>
> --
> https://patchwork.kernel.org/project/linux-wireless/list/
>
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpa=
tches
>

--
Kind Regards,
Caleb

