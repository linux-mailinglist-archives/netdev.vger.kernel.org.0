Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 769594A51E6
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 22:52:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355717AbiAaVwo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 16:52:44 -0500
Received: from pop31.abv.bg ([194.153.145.221]:52612 "EHLO pop31.abv.bg"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1376500AbiAaVwo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Jan 2022 16:52:44 -0500
X-Greylist: delayed 514 seconds by postgrey-1.27 at vger.kernel.org; Mon, 31 Jan 2022 16:52:42 EST
Received: from smtp.abv.bg (localhost [127.0.0.1])
        by pop31.abv.bg (Postfix) with ESMTP id 698A3180AA91;
        Mon, 31 Jan 2022 23:43:58 +0200 (EET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=abv.bg; s=smtp-out;
        t=1643665438; bh=iWjdHNIDwdz1nE3eZyu9fh57i4nneBCZfkedFsbdT+w=;
        h=Subject:From:In-Reply-To:Date:Cc:References:To:From;
        b=R2VKrYYtGHF5MBJ0WVuFEY2D3T94n180PVbGEOfvGkBFfz1KZb7Bp5EKbjept1XSo
         t+iP1ccWRlHWkZkWf8kmIHuzmJkzkt2i0DLZIaJ2/Rk6+U2lB6eGf/8rWv3HmeM7de
         oSCn2EQAWStyRxZHge4JZBAd2hsll1GeL3F3eDo0=
X-HELO: smtpclient.apple
Authentication-Results: smtp.abv.bg; auth=pass (plain) smtp.auth=gvalkov@abv.bg
Received: from 212-39-89-254.ip.btc-net.bg (HELO smtpclient.apple) (212.39.89.254)
 by smtp.abv.bg (qpsmtpd/0.96) with ESMTPSA (ECDHE-RSA-AES256-GCM-SHA384 encrypted); Mon, 31 Jan 2022 23:43:58 +0200
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: ipheth: fix EOVERFLOW in ipheth_rcvbulk_callback
From:   Georgi Valkov <gvalkov@abv.bg>
In-Reply-To: <6108f260-36bf-0059-ccb9-8189f4a2d0c1@siemens.com>
Date:   Mon, 31 Jan 2022 23:43:52 +0200
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, davem@davemloft.net,
        mhabets@solarflare.com, luc.vanoostenryck@gmail.com,
        snelson@pensando.io, mst@redhat.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        corsac@corsac.net, matti.vuorela@bitfactor.fi,
        stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <FF6FFC1F-0AE9-4253-B55E-755BB90C4DBA@abv.bg>
References: <B60B8A4B-92A0-49B3-805D-809A2433B46C@abv.bg>
 <20210720122215.54abaf53@cakuba>
 <5D0CFF83-439B-4A10-A276-D2D17B037704@abv.bg> <YPa4ZelG2k8Z826E@kroah.com>
 <C6AA954F-8382-461D-835F-E5CA03363D84@abv.bg> <YPbHoScEo8ZJyox6@kroah.com>
 <AEC79E3B-FA7F-4A36-95CE-B6D0F3063DF8@abv.bg>
 <80a13e9b-e026-1238-39ed-32deb5ff17b0@siemens.com>
 <20220131092726.3864b19f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <6108f260-36bf-0059-ccb9-8189f4a2d0c1@siemens.com>
To:     Jan Kiszka <jan.kiszka@siemens.com>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On 2022-01-31, at 7:35 PM, Jan Kiszka <jan.kiszka@siemens.com> wrote:
>=20
> On 31.01.22 18:27, Jakub Kicinski wrote:
>> On Mon, 31 Jan 2022 10:45:23 +0100 Jan Kiszka wrote:
>>> On 20.07.21 15:12, Georgi Valkov wrote:
>>>> Thank you, Greg!
>>>>=20
>>>> git send-email =
drivers/net/0001-ipheth-fix-EOVERFLOW-in-ipheth_rcvbulk_callback.patch
>>>> ...
>>>> Result: OK
>>>>=20
>>>> I hope I got right. I added most of the e-mail addresses, and also =
tried adding Message-Id.
>>>> I have not received the e-mail yet, so I cannot confirm if it =
worked or not.
>>>>  =20
>>>=20
>>> What happened here afterwards?
>>>=20
>>> I just found out the hard way that this patch is still not in =
mainline
>>> but really needed.
>> I have not seen the repost :(
>=20
> Would it help if I do that on behalf of Georgi? Meanwhile, I can add a =
tested-by to it, after almost a full working day with it applied.

Yes, please do it! The faster it gets mainline, the more people will =
benefit from the fix. As far as I recall, some months ago someone asked =
me to submit the patch using git mail or something like that, which I =
did for the first time. It command reported success, but I did not get =
any replays since then from anyone. I intended to resubmit it the =
following week, but got overwhelmed by tasks, and the time passed. =
Meanwhile I still keep the patch in GitHub/httpstorm/openwrt, brach =
gvalkov. No changes are required since the original e-mail, so it can be =
submitted to mainline.

There is another issue with my iPhone 7 Plus, which is unrelated to this =
patch:
If an iPhone is tethered to a MacBook, the next time it gets connected =
to an OpenWRT router the USB Ethernet interface appears, but there is no =
communication. Hence I would assume this unrelated issue also has to be =
fixed in another patch. I can confirm that in this state macOS and =
Windows are able to use USB tethering, only OpenWRT is affected. So far =
I found the following workarounds:
* reboot the phone or run:
* usbreset 002/002 && /etc/init.d/usbmuxd restart

The same happens if the phone reboots due to extreme cold temperatures =
while tethered. Finally there is also a bug or possible =
hardware/baseband fault in my phone where every few days the modem =
reboots: the LTE icon disappears for a few seconds, and tethering is =
turned off. Either way, running the commands mentioned above re-enable =
tethering and restore the communication instantly. It would be nice if a =
watchdog is integrated in ipheth to trigger recovery automatically.

Georgi Valkov


> Jan
>=20
> --=20
> Siemens AG, Technology
> Competence Center Embedded Linux
>=20

