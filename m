Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 766273A2A3
	for <lists+netdev@lfdr.de>; Sun,  9 Jun 2019 02:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727696AbfFIAO1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 20:14:27 -0400
Received: from pb-smtp20.pobox.com ([173.228.157.52]:62852 "EHLO
        pb-smtp20.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727612AbfFIAO0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jun 2019 20:14:26 -0400
Received: from pb-smtp20.pobox.com (unknown [127.0.0.1])
        by pb-smtp20.pobox.com (Postfix) with ESMTP id 779597BD70;
        Sat,  8 Jun 2019 20:14:18 -0400 (EDT)
        (envelope-from daniel.santos@pobox.com)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=pobox.com; h=subject:to:cc
        :references:from:message-id:date:mime-version:in-reply-to
        :content-type:content-transfer-encoding; s=sasl; bh=+hCIgWf2gGnv
        N1U5hkkWGBSChbE=; b=aeYHrYvdTdR1C/CiYJpgXMe/sBBO4cYk+Xom48ybbj4m
        m1jH0jnhXy1UXqktHQWtdqG0hwUoU1XWgGql86pwsfBghcDFbeUiqXobYZrJ2jiJ
        iqadRXKWY/OjDHNkJBEnaMT+mD9ZKOadJ3cUrnfHKF4qW6CuaKdaENZ+kfjGNX4=
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=subject:to:cc
        :references:from:message-id:date:mime-version:in-reply-to
        :content-type:content-transfer-encoding; q=dns; s=sasl; b=tGcmYL
        fLKm0ypsjrcZRJn8fWcEyuTf6pINxrMtDMl4/eAbCMlC4aeaTpQePF0mmbOpmzAJ
        UeAhfJxIEpy23AvX+d3gCaaIesTPYW9hwylr87HGKIbkoWKJ4uXdXSP3TioaBusm
        tkp0db/zNC1O4vVM7FdOF7NN0nsT+SCtIm1QM=
Received: from pb-smtp20.sea.icgroup.com (unknown [127.0.0.1])
        by pb-smtp20.pobox.com (Postfix) with ESMTP id 6FEB37BD6F;
        Sat,  8 Jun 2019 20:14:18 -0400 (EDT)
        (envelope-from daniel.santos@pobox.com)
Received: from [192.168.2.4] (unknown [70.142.57.80])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by pb-smtp20.pobox.com (Postfix) with ESMTPSA id 5F9587BD6C;
        Sat,  8 Jun 2019 20:14:15 -0400 (EDT)
        (envelope-from daniel.santos@pobox.com)
Subject: Re: [OpenWrt-Devel] Using ethtool or swconfig to change link settings
 for mt7620a?
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     Felix Fietkau <nbd@nbd.name>,
        openwrt-devel <openwrt-devel@lists.openwrt.org>,
        netdev@vger.kernel.org, Vitaly Chekryzhev <13hakta@gmail.com>,
        Luis Soltero <lsoltero@globalmarinenet.com>
References: <5316c6da-1966-4896-6f4d-8120d9f1ff6e@pobox.com>
 <20190608115159.GA1559@makrotopia.org>
From:   Daniel Santos <daniel.santos@pobox.com>
Message-ID: <42094a87-09e6-1278-97c5-b6faaaca0a95@pobox.com>
Date:   Sat, 8 Jun 2019 19:12:41 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190608115159.GA1559@makrotopia.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Pobox-Relay-ID: 844A6420-8A4B-11E9-A518-B0405B776F7B-06139138!pb-smtp20.pobox.com
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Daniel,

Thanks for your help!

On 6/8/19 6:51 AM, Daniel Golle wrote:
> Hi Daniel,
>
> On Sat, Jun 08, 2019 at 04:06:54AM -0500, Daniel Santos wrote:
>> Hello,
>>
>> I need to change auto-negotiate, speed and duplex for a port on my
>> mt7620a-based device, but I'm not quite certain that I understand the
>> structure here.=C2=A0 When using ethtool on eth0 I always get ENODEV,
>> apparently because priv->phy_dev is always NULL in fe_get_link_ksettin=
gs
>> of drivers/net/ethernet/mtk/ethtool.c.=C2=A0 But I'm being told that e=
th0 is
>> only an internal device between the =C2=B5C and the switch hardware, s=
o it
>> isn't even the one I need to change.
> That's correct.

It always helps when my idea about what I'm doing matches reality.

>> If this is true, then it looks like I will need to implement a
>> get_port_link function for struct switch_dev_ops?=C2=A0 Can anybody co=
nfirm
>> this to be the case?=C2=A0 Also, are there any examples aside from the
>> Broadcom drivers?=C2=A0 I have the mt7620 programmer's guide and it sp=
ecifies
>> the registers I need to change.
> Currently MT7620 still uses our legacy swconfig switch driver, which
> also doesn't support setting autoneg, speed and duplex. However, rather
> than implementing it there, it'd be great to add support for the FE-
> version of the MT7530 swtich found in the MT7620(A/N) WiSoC to the now
> upstream DSA driver[1].

Ok, this makes much more sense now.=C2=A0 So swconfig is on its way out i=
n
favor of DSA (which I've never heard of until now)?=C2=A0 I presume this =
will
also abstract away changes of ethtool to netlink-based instead of ioctl
on a random socket as well?

> While this driver was originally intended for
> use with standalone MT7530 GE switch chip or the ARM-based MT7623 SoC,
> the same switch fabric is also implemented in MT7621 and support for
> that chip was added to the driver recently[2]. MT7620 basically also
> features the same switch internally, however, it comes with only one
> CPU port, supports only FastEthernet and lacks some of the management
> counters.
>
> Assuming your MT7620 datasheet includes the decription of the MT7530
> switch registers, it'd be great if you can help working on supporting
> MT7620 in the DSA driver as well -- gaining per-port ethtool support
> as a reward :)

Wonderful!=C2=A0 So if I understand correctly, this is the same switch
hardware (internally at least), so has all of the same MAC and MII
registers on 7530, 7621, 7620, etc?=C2=A0 For now I have to get a fix for=
 a
customer on a 3.18 kernel, so I'll be doing the swconfig first and then
see how much time we can put into the DSA implementation.

>
> Cheers
>
>
> Daniel
>
>
> [1]: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git=
/tree/drivers/net/dsa/mt7530.c
> [2]: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git=
/commit/?id=3Dddda1ac116c852bb969541ed53cffef7255c4961
>

Also, would you happen to know why the mt7620 mdio driver is using a
32-bit read for MII registers that are 32-bit?=C2=A0 For example, in
_mt7620_mii_read.=C2=A0 It looks like some of this can use some improved
error management, since return codes are being ignored in a few places.

From what I can tell thus far, it looks like these MII registers are
standardized, so the "generic" version might do most or all of what I
need in some cases.=C2=A0 But as far as implementing DSA, I guess I'll ha=
ve
to examine the mainlined driver and see how it works.=C2=A0 I just didn't
have a struct phy_device to work with when trying to get it to work.

Thanks,
Daniel


