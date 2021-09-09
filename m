Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8044C405BBF
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 19:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240323AbhIIRI4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 13:08:56 -0400
Received: from mout.gmx.net ([212.227.17.22]:33729 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238789AbhIIRIz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 13:08:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1631207255;
        bh=7tXlIisQeGNb3a+69zq/jRitSlcukCYGi6bCofviy1o=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=g9zG+taUK/r7/cYzokBzKdknjeiw8C3OKjsryHwJFCp/G3gruDN8Utpghty9TyLK0
         GXljhlMRbrZA2HWxBDcgLS9Tb1FlvEiKRSAd1cywAnQft1mibshlKTElwFMSahKdEd
         ibAboirmduLh6fn0cAVa23cdZHQRuKpyJTvOeTwQ=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.178.51] ([46.223.119.124]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MgNh1-1mruFE0I1P-00hwys; Thu, 09
 Sep 2021 19:07:35 +0200
Subject: Re: [PATCH 0/3] Fix for KSZ DSA switch shutdown
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     p.rosenberger@kunbus.com, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210909095324.12978-1-LinoSanfilippo@gmx.de>
 <20210909101451.jhfk45gitpxzblap@skbuf>
 <81c1a19f-c5dc-ab4a-76ff-59704ea95849@gmx.de>
 <20210909114248.aijujvl7xypkh7qe@skbuf>
 <20210909125606.giiqvil56jse4bjk@skbuf>
 <trinity-85ae3f9c-38f9-4442-98d3-bdc01279c7a8-1631193592256@3c-app-gmx-bs01>
 <20210909154734.ujfnzu6omcjuch2a@skbuf>
 <8498b0ce-99bb-aef9-05e1-d359f1cad6cf@gmx.de>
 <2b316d9f-1249-9008-2901-4ab3128eed81@gmail.com>
From:   Lino Sanfilippo <LinoSanfilippo@gmx.de>
Message-ID: <5b899bb3-ed37-19ae-8856-3dabce534cc6@gmx.de>
Date:   Thu, 9 Sep 2021 19:07:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <2b316d9f-1249-9008-2901-4ab3128eed81@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:AZqe644msIQ2+yFCv6yfolpB6piEgSat8/S6IXCnjN5BEGYYGE+
 XeE9/5zLpg0tIQNRTIRz8OGaEiUShW+wow871ohkyQ18C+USwdqI5MgeM4ffw/tTws0Il/e
 KlQPTn4lRkP9278/MPmYgQKgU0l6AE6KvtFu1xwsLSjBjTG6KWZ7nxemg2F33tV0P0iSabh
 63ITVXpOTGV0WOCLNwSQw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:9y+zwzAVR+o=:gy1pR7V38xfzPfobWMGPq7
 sdXcD6FKToLGtmw2DIOtH3WWzTi7gF3Eoh4fvJRqqKdwxUYJX7chbqi9zfMUbrvViawC+mQtD
 AGwPn+wgrhViaUl1Ii0XcxYBg0LcxOrwxK7lFfpbwZoNMAm3vt3HG8aLEtoh3j5XPEuvgbsbE
 lr1lNOTD4GOARbg/MmahqQJo6sWFBSqNZk8u+7Oe6AgXZM4E1kmarZ667cxHSuRZ/M5X0PL2E
 WOCTqOOQU1e8kMwx2NggqP5xj59dislgc/kaL5WH6L7nrTDv0kiGyVicj/5heIIj+6/eshEAa
 8O0uqY3pj54b4DyCts0NUvOwgKJhvzTCsK4n0cK6kvt1amtI+BkyUhj//EbtG0eb68dB+VBIz
 Uk2dCJoyGbTzKajKiEpEJhpa+ADephaH68/ImDklC3s3VwDA1uCS5T8/xj+4ud73gAzR5mIre
 cdMXxRgEhhID+qobwNvdL9pQz2PXfONYQMiLXIRWVVAK0kuHzS1UVAvPBImdl+F8JDFPif4zp
 4Phgtq3u75muYWknvWxuQayFHbbCpEhtQn5HLknz2nOBlo2eQRwN3RFAATTojmihBKZsoBWSt
 MD9JHYrc5CB1/W9VyQq/qOgISkd09vTXYWbTgAvBvZ4RFTCXS3ddY1BP+KeT843QygvAb9AyU
 oHTORUPkHoTkB5/Y7QbC4MzuUdjWKyEp0ug0AJptfJXFDJXHi+oh9Mo7AOT3lZU513prbwKwc
 YiEptxIatIf6j2mg+TPaYT5nkzXFB7SD4UXxrW5y11UUKRXhv1YxfecFEWbTSgDk7LElLUSlx
 Oz7bdISFVfHPPXo2Zjbs4o/TyA8nyO8GtwYv57Juo/HoQk+4HG2dBdmTjClCF62aA7bqH4Xyi
 wC+yqbp79OaHhtW7PzpI2Nb7EIOcm8UFbINnQVDJNX0cRj9II8sVHCh7TPlHCyI3LpoZFs3DW
 U0d+LIx9ENn8nJjtlrgm4JO84O1hLtSnX1GbFbklI2JwYeIRoceU0gT8hiBbgXYy9Qc14oS8l
 UpIw/a4sJWbRX4zGaGVm7FrUIkrI9hfuw/4LdunaGS7KU2PC+5mZihu6VrVvzF4EVHR0HQCsW
 apZcvfgGNG9yII=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09.09.21 at 18:44, Florian Fainelli wrote:
>
>
> On 9/9/2021 9:37 AM, Lino Sanfilippo wrote:
>> On 09.09.21 at 17:47, Vladimir Oltean wrote:
>>> On Thu, Sep 09, 2021 at 03:19:52PM +0200, Lino Sanfilippo wrote:
>>>>> Do you see similar things on your 5.10 kernel?
>>>>
>>>> For the master device is see
>>>>
>>>> lrwxrwxrwx 1 root root 0 Sep=C2=A0 9 14:10 /sys/class/net/eth0/device=
/consumer:spi:spi3.0 -> ../../../virtual/devlink/platform:fd580000.etherne=
t--spi:spi3.0
>>>
>>> So this is the worst of the worst, we have a device link but it doesn'=
t help.
>>>
>>> Where the device link helps is here:
>>>
>>> __device_release_driver
>>> =C2=A0=C2=A0=C2=A0=C2=A0while (device_links_busy(dev))
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 device_links_unbind_consume=
rs(dev);
>>>
>>> but during dev_shutdown, device_links_unbind_consumers does not get ca=
lled
>>> (actually I am not even sure whether it should).
>>>
>>> I've reproduced your issue by making this very simple change:
>>>
>>> diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers=
/net/ethernet/freescale/enetc/enetc_pf.c
>>> index 60d94e0a07d6..ec00f34cac47 100644
>>> --- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
>>> +++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
>>> @@ -1372,6 +1372,7 @@ static struct pci_driver enetc_pf_driver =3D {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .id_table =3D enetc_pf_id_table,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .probe =3D enetc_pf_probe,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .remove =3D enetc_pf_remove,
>>> +=C2=A0=C2=A0=C2=A0 .shutdown =3D enetc_pf_remove,
>>> =C2=A0 #ifdef CONFIG_PCI_IOV
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .sriov_configure =3D enetc_sriov_config=
ure,
>>> =C2=A0 #endif
>>>
>>> on my DSA master driver. This is what the genet driver has "special".
>>>
>>
>> Ah, that is interesting.
>>
>>> I was led into grave error by Documentation/driver-api/device_link.rst=
,
>>> which I've based my patch on, where it clearly says that device links
>>> are supposed to help with shutdown ordering (how?!).
>>>
>>> So the question is, why did my DSA trees get torn down on shutdown?
>>> Basically the short answer is that my SPI controller driver does
>>> implement .shutdown, and calls the same code path as the .remove code,
>>> which calls spi_unregister_controller which removes all SPI children..
>>>
>>> When I added this device link, one of the main objectives was to not
>>> modify all DSA drivers. I was certain based on the documentation that
>>> device links would help, now I'm not so sure anymore.
>>>
>>> So what happens is that the DSA master attempts to unregister its net
>>> device on .shutdown, but DSA does not implement .shutdown, so it just
>>> sits there holding a reference (supposedly via dev_hold, but where fro=
m?!)
>>> to the master, which makes netdev_wait_allrefs to wait and wait.
>>>
>>
>> Right, that was also my conclusion.
>>
>>> I need more time for the denial phase to pass, and to understand what
>>> can actually be done. I will also be away from the keyboard for the ne=
xt
>>> few days, so it might take a while. Your patches obviously offer a
>>> solution only for KSZ switches, we need something more general. If I
>>> understand your solution, it works not by virtue of there being any
>>> shutdown ordering guarantee at all, but simply due to the fact that
>>> DSA's .shutdown hook gets called eventually, and the reference to the
>>> master gets freed eventually, which unblocks the unregister_netdevice
>>> call from the master.
>>
>> Well actually the SPI shutdown hook gets called which then calls ksz947=
7_shutdown
>> (formerly ksz9477_reset_switch) which then shuts down the switch by
>> stopping the worker thread and tearing down the DSA tree (via dsa_tree_=
shutdown()).
>>
>> While it is right that the patch series only fixes the KSZ case for now=
, the idea was that
>> other drivers could use a similar approach in by calling the new functi=
on dsa_tree_shutdown()
>> in their shutdown handler to make sure that all refs to the master devi=
ce are released.
> It does not scale really well to have individual drivers call dsa_tree_s=
hutdown() in their respective .shutdown callback, and in a multi-switch co=
nfiguration, I am not sure what the results would look like.
>
> In premise, each driver ought to be able to call dsa_unregister_switch()=
, along with all of the driver specific shutdown and eventually, given pro=
per device ordering the DSA tree would get automatically torn down, and th=
en the DSA master's .shutdown() callback would be called.
>
> FWIW, the reason why we call .shutdown() in bcmgenet is to turn off DMA =
and clocks, which matters for kexec (DMA) as well as power savings (S5 mod=
e).

I agree with the scalability. Concerning the multi-switch case I dont know=
 about the possible issues (I am quite new to working with DSA).
So lets wait for Vladimirs solution.

Regards,
Lino
