Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B55A262F65
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 15:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730285AbgIINxv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 09:53:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726970AbgIINWO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 09:22:14 -0400
Received: from canardo.mork.no (canardo.mork.no [IPv6:2001:4641::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CFE9C0617A1;
        Wed,  9 Sep 2020 05:50:21 -0700 (PDT)
Received: from miraculix.mork.no (miraculix.mork.no [IPv6:2001:4641:0:2:7627:374e:db74:e353])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 089CnV6b019522
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Wed, 9 Sep 2020 14:49:33 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1599655773; bh=gyZQUFKOvOzRD5d6Mx+YiDunu6byD7irHNEmNRStxpY=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=FisxOlxKtlkGOJN1DvW1fUmDGy7B7E4DClQNfYXa9nfw01xgf1/L8Hid0lOYFtCoH
         m6QC1zJd9KczFwx2d/CQzE8aPHMYfPLf7jwHnUfGrRahCBCmc6zFGCFZBa7GMy9eJX
         GjZMpaXRSYX4X8p15l7snzCzAwAQfjkWwTcRIt2I=
Received: from bjorn by miraculix.mork.no with local (Exim 4.94)
        (envelope-from <bjorn@mork.no>)
        id 1kFzXW-00052h-Qk; Wed, 09 Sep 2020 14:49:30 +0200
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Daniele Palmas <dnlplm@gmail.com>
Cc:     =?utf-8?B?Q2FybCBZaW4o5q635byg5oiQKQ==?= <carl.yin@quectel.com>,
        Kristian Evensen <kristian.evensen@gmail.com>,
        Paul Gildea <paul.gildea@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-usb\@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH net-next 1/1] net: usb: qmi_wwan: add default rx_urb_size
Organization: m
References: <20200909091302.20992-1-dnlplm@gmail.com>
        <HK2PR06MB35077179EE3FDE04A1EB612786260@HK2PR06MB3507.apcprd06.prod.outlook.com>
        <CAGRyCJFuMv5PmLC2iUGOgbBufWUKhmVoYgrK_hXTgqmj1P1Yjw@mail.gmail.com>
Date:   Wed, 09 Sep 2020 14:49:30 +0200
In-Reply-To: <CAGRyCJFuMv5PmLC2iUGOgbBufWUKhmVoYgrK_hXTgqmj1P1Yjw@mail.gmail.com>
        (Daniele Palmas's message of "Wed, 9 Sep 2020 13:57:58 +0200")
Message-ID: <87tuw7dsit.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.102.4 at canardo
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniele Palmas <dnlplm@gmail.com> writes:
> Il giorno mer 9 set 2020 alle ore 13:09 Carl Yin(=E6=AE=B7=E5=BC=A0=E6=88=
=90)
> <carl.yin@quectel.com> ha scritto:
>>
>> Hi Deniele:
>>
>>         I have an idea, by now in order to use QMAP,
>>         must execute shell command 'echo mux_id > /sys/class/net/<iface>=
/add_mux' in user space,
>>         maybe we can expand usage of sys attribute 'add_mux', like next:
>>         'echo mux_id mux_size mux_version > /sys/class/net/<iface>/add_m=
ux'.
>>         Users can set correct 'mux_size and mux_version' according to th=
e response of 'QMI_WDA_SET_DATA_FORMAT '.
>>         If 'mux_size and mux_version' miss, qmi_wwan can use default val=
ues.
>>
>
> not sure this is something acceptable, let's wait for Bj=C3=B8rn to comme=
nt.

This breaks the "one value per file" rule.  Ref
https://www.kernel.org/doc/Documentation/filesystems/sysfs.txt

And I really think this userspace ABI is complicated enough already
without adding yet another variable governed by strict rules.

I'd prefer this to just work, if possible.  I liked the simplicity of
your patch.  If it is necessary to have a different value when QMAP is
disabled, then I'd much rather see two fixed values, depending on
QMI_WWAN_FLAG_MUX.


>>         If fixed set as 32KB, but MDM9x07 chips only support 4KB, or use=
s do not enable QMAP,
>>         Maybe cannot reach max throughput for no enough rx urbs.
>>
>
> I did not test for performance, but you could be right since for
> example, if I'm not wrong, rx_qlen for an high-speed device would be 2
> with the changed rx_urb_size.

That's correct.  But I believe 2 URBs might be enough.  Still, would be
nice if some of you with a fast enough modem could test this.  At least
if throughput issues are going to be an argument for a more complicated
ABI.

> So, we'll probably need to modify also usbnet_update_max_qlen, but not
> sure about the direction (maybe fallback to a default value to
> guarantee a minimum number if rx_qlen is < than a threshold?). And
> this is also a change affecting all the drivers using usbnet, so it
> requires additional care.

I'm not sure we want to do that. We haven't done it for other
aggregating usbnet protocols.  There is a reason we have the hard limit.




Bj=C3=B8rn

>> > -----=E9=82=AE=E4=BB=B6=E5=8E=9F=E4=BB=B6-----
>> > =E5=8F=91=E4=BB=B6=E4=BA=BA: Daniele Palmas [mailto:dnlplm@gmail.com]
>> > =E5=8F=91=E9=80=81=E6=97=B6=E9=97=B4: Wednesday, September 09, 2020 5:=
13 PM
>> > =E6=94=B6=E4=BB=B6=E4=BA=BA: Bj=C3=B8rn Mork <bjorn@mork.no>
>> > =E6=8A=84=E9=80=81: Kristian Evensen <kristian.evensen@gmail.com>; Pau=
l Gildea
>> > <paul.gildea@gmail.com>; Carl Yin(=E6=AE=B7=E5=BC=A0=E6=88=90) <carl.y=
in@quectel.com>; David S .
>> > Miller <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>;
>> > netdev@vger.kernel.org; linux-usb@vger.kernel.org; Daniele Palmas
>> > <dnlplm@gmail.com>
>> > =E4=B8=BB=E9=A2=98: [PATCH net-next 1/1] net: usb: qmi_wwan: add defau=
lt rx_urb_size
>> >
>> > Add default rx_urb_size to support QMAP download data aggregation with=
out
>> > needing additional setup steps in userspace.
>> >
>> > The value chosen is the current highest one seen in available modems.
>> >
>> > The patch has the side-effect of fixing a babble issue in raw-ip mode =
reported by
>> > multiple users.
>> >
>> > Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
>> > ---
>> > Resending with mailing lists added: sorry for the noise.
>> >
>> > Hi Bj=C3=B8rn and all,
>> >
>> > this patch tries to address the issue reported in the following threads
>> >
>> > https://www.spinics.net/lists/netdev/msg635944.html
>> > https://www.spinics.net/lists/linux-usb/msg198846.html
>> > https://www.spinics.net/lists/linux-usb/msg198025.html
>> >
>> > so I'm adding the people involved, maybe you can give it a try to doub=
le check if
>> > this is good for you.
>> >
>> > On my side, I performed tests with different QC chipsets without exper=
iencing
>> > problems.
>> >
>> > Thanks,
>> > Daniele
>> > ---
>> >  drivers/net/usb/qmi_wwan.c | 4 ++++
>> >  1 file changed, 4 insertions(+)
>> >
>> > diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c i=
ndex
>> > 07c42c0719f5..92d568f982b6 100644
>> > --- a/drivers/net/usb/qmi_wwan.c
>> > +++ b/drivers/net/usb/qmi_wwan.c
>> > @@ -815,6 +815,10 @@ static int qmi_wwan_bind(struct usbnet *dev, stru=
ct
>> > usb_interface *intf)
>> >       }
>> >       dev->net->netdev_ops =3D &qmi_wwan_netdev_ops;
>> >       dev->net->sysfs_groups[0] =3D &qmi_wwan_sysfs_attr_group;
>> > +
>> > +     /* Set rx_urb_size to allow QMAP rx data aggregation */
>> > +     dev->rx_urb_size =3D 32768;
>> > +
>> >  err:
>> >       return status;
>> >  }
>> > --
>> > 2.17.1
>>
