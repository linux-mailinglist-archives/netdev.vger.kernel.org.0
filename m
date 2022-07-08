Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9A7E56C54B
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 02:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237958AbiGHXTA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 19:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237068AbiGHXS5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 19:18:57 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A1D241980;
        Fri,  8 Jul 2022 16:18:55 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id e12so102135lfr.6;
        Fri, 08 Jul 2022 16:18:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=IUPSBY5O0wPXr4X6QM6WG5+hEBV1b7qpWXP+wxJALT8=;
        b=H+8GUViLpESz1gn4xKCmTS1rrbzwh4TkMEgyRRRy/DBLz+9ECubw4caCgsfAof2keg
         7+NJrnPIClRe6HBv/N2GRlAZOHmwaiMB5mSfIFrEAufm4DuF6wLAvJ4gsfll6eyWuT34
         zH94HzrgXfUEWhHLhU2drLfCCC1c9xU2bsQDtQxr7kjtrUhmIk95d7jlCD/Q72jkBk0x
         l6pDpIOgqGjC7sdAp2KvT2W1rlZZgDMBhVVejTdB0Ac6fLK0LuaZZWofsza44+tmRKyk
         0lRZ500Zn+G2hE//vc1t6eMxTBWvWt9Ziuaqvvqsvm/JqKEhAJs6soIMbHXPdGskKmrv
         NaEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=IUPSBY5O0wPXr4X6QM6WG5+hEBV1b7qpWXP+wxJALT8=;
        b=JbWMTeWluXLv80O5Ksr+FKwayD+A1J+SECGiJjV9jLJJ024EkyVnYYn53DlobFonnK
         eVI/HSqleLqRCbBpNRfgSMLA9p0G9ibJkMpvekTUWzDM76rgUD6yJW65AcgELliJnoZz
         2bH0Ay3F3smuSkYWWcUiSYg8HJKtIOEf2Ci3u5Vxi1sA87Ub5NK+fpNLUpXceMBRk3ZJ
         CYeTjVPY9E6wAUySiM2WehW3U45KAVa7WrHRMb7K7gKZDBscSVuI4GnEBVsFfEPj21Fk
         51MqJcVgAqGU2S/A3n6h7dWYOaAoADJBIV/DTPValyefgyeedObXAs4B8LL9D0ImDF2i
         Bb/g==
X-Gm-Message-State: AJIora+UF/WEq9SV3a9c+6gTd6KgOQhQrmD1Rwx9lt94Ls8+Zu6WoE+L
        j622iJEE4iHLkUDsye4h8frEWNyrh6UzvZh4/mA=
X-Google-Smtp-Source: AGRyM1vhJ6x5TKqFlNd15UxH/VAFJbbWyanOVfQdePMPIvWRgTfZ4Ojz7HuEmztXhj+uc27cMD6ooRlhHBdgTiS8c7U=
X-Received: by 2002:a05:6512:2621:b0:47f:d228:bdeb with SMTP id
 bt33-20020a056512262100b0047fd228bdebmr3672168lfb.121.1657322333638; Fri, 08
 Jul 2022 16:18:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220707151420.v3.1.Iaf638bb9f885f5880ab1b4e7ae2f73dd53a54661@changeid>
 <20220707151420.v3.2.I39885624992dacff236aed268bdaa69107cd1310@changeid>
 <CABBYNZL5oXFsyBN6JRdt1JeD2v5h3MOpCAa4hF0sXfw5F6u3Pg@mail.gmail.com>
 <CAGPPCLDBVwaXNbr6_wsj-M+Lbdbn6CbZippHYS5F-2vREBPHbg@mail.gmail.com>
 <CABBYNZLWTbogiUvs3pxE=JPtVX-bxpBa7dKNUL3jh1-a8axR5A@mail.gmail.com> <CAGPPCLAUjB+K7SV=jv0sD=Gssrw1XSNgfHdj06=DxAUd4O12Fg@mail.gmail.com>
In-Reply-To: <CAGPPCLAUjB+K7SV=jv0sD=Gssrw1XSNgfHdj06=DxAUd4O12Fg@mail.gmail.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Fri, 8 Jul 2022 16:18:42 -0700
Message-ID: <CABBYNZJo3H_grOzHuC+XTuyohFTF56Wkt89gix3fC9=L7Wz29w@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] Bluetooth: Add sysfs entry to enable/disable devcoredump
To:     Manish Mandlik <mmandlik@google.com>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        ChromeOS Bluetooth Upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Manish,

On Fri, Jul 8, 2022 at 3:30 PM Manish Mandlik <mmandlik@google.com> wrote:
>
> Hi Luiz,
>
> On Fri, Jul 8, 2022 at 11:40 AM Luiz Augusto von Dentz <luiz.dentz@gmail.=
com> wrote:
>>
>> Hi Manish,
>>
>> On Fri, Jul 8, 2022 at 11:30 AM Manish Mandlik <mmandlik@google.com> wro=
te:
>> >
>> > Hi Luiz,
>> >
>> > On Fri, Jul 8, 2022 at 10:24 AM Luiz Augusto von Dentz <luiz.dentz@gma=
il.com> wrote:
>> >>
>> >> Hi Manish,
>> >>
>> >> On Thu, Jul 7, 2022 at 3:15 PM Manish Mandlik <mmandlik@google.com> w=
rote:
>> >> >
>> >> > Since device/firmware dump is a debugging feature, we may not need =
it
>> >> > all the time. Add a sysfs attribute to enable/disable bluetooth
>> >> > devcoredump capturing. The default state of this feature would be
>> >> > disabled and it can be enabled by echoing 1 to enable_coredump sysf=
s
>> >> > entry as follow:
>> >> >
>> >> > $ echo 1 > /sys/class/bluetooth/<device>/enable_coredump
>> >> >
>> >> > Signed-off-by: Manish Mandlik <mmandlik@google.com>
>> >> > ---
>> >> >
>> >> > Changes in v3:
>> >> > - New patch in the series to enable/disable feature via sysfs entry
>> >> >
>> >> >  net/bluetooth/hci_sysfs.c | 36 +++++++++++++++++++++++++++++++++++=
+
>> >> >  1 file changed, 36 insertions(+)
>> >> >
>> >> > diff --git a/net/bluetooth/hci_sysfs.c b/net/bluetooth/hci_sysfs.c
>> >> > index 4e3e0451b08c..df0d54a5ae3f 100644
>> >> > --- a/net/bluetooth/hci_sysfs.c
>> >> > +++ b/net/bluetooth/hci_sysfs.c
>> >> > @@ -91,9 +91,45 @@ static void bt_host_release(struct device *dev)
>> >> >         module_put(THIS_MODULE);
>> >> >  }
>> >> >
>> >> > +#ifdef CONFIG_DEV_COREDUMP
>> >> > +static ssize_t enable_coredump_show(struct device *dev,
>> >> > +                                   struct device_attribute *attr,
>> >> > +                                   char *buf)
>> >> > +{
>> >> > +       struct hci_dev *hdev =3D to_hci_dev(dev);
>> >> > +
>> >> > +       return scnprintf(buf, 3, "%d\n", hdev->dump.enabled);
>> >> > +}
>> >> > +
>> >> > +static ssize_t enable_coredump_store(struct device *dev,
>> >> > +                                    struct device_attribute *attr,
>> >> > +                                    const char *buf, size_t count)
>> >> > +{
>> >> > +       struct hci_dev *hdev =3D to_hci_dev(dev);
>> >> > +
>> >> > +       /* Consider any non-zero value as true */
>> >> > +       if (simple_strtol(buf, NULL, 10))
>> >> > +               hdev->dump.enabled =3D true;
>> >> > +       else
>> >> > +               hdev->dump.enabled =3D false;
>> >> > +
>> >> > +       return count;
>> >> > +}
>> >> > +DEVICE_ATTR_RW(enable_coredump);
>> >> > +#endif
>> >> > +
>> >> > +static struct attribute *bt_host_attrs[] =3D {
>> >> > +#ifdef CONFIG_DEV_COREDUMP
>> >> > +       &dev_attr_enable_coredump.attr,
>> >> > +#endif
>> >> > +       NULL,
>> >> > +};
>> >> > +ATTRIBUTE_GROUPS(bt_host);
>> >> > +
>> >> >  static const struct device_type bt_host =3D {
>> >> >         .name    =3D "host",
>> >> >         .release =3D bt_host_release,
>> >> > +       .groups =3D bt_host_groups,
>> >> >  };
>> >> >
>> >> >  void hci_init_sysfs(struct hci_dev *hdev)
>> >> > --
>> >> > 2.37.0.rc0.161.g10f37bed90-goog
>> >>
>> >> It seems devcoredump.c creates its own sysfs entries so perhaps this
>> >> should be included there and documented in sysfs-devices-coredump.
>> >
>> > I deliberately created it here. We need to have this entry/switch per =
hci device, whereas the sysfs entry created by devcoredump.c disables the d=
evcoredump feature entirely for anyone who's using it, so it can act as a g=
lobal switch for the devcoredump.
>>
>> We should probably check if there is a reason why this is not on per
>> device and anyway if seem wrong to each subsystem to come up with its
>> own sysfs entries when it could be easily generalized so the userspace
>> tools using those entries don't have to look into different entries
>> depending on the subsystem the device belongs.
>
> The purpose of the base devcoredump interface is to only provide a genera=
lized mechanism for drivers to dump the firmware data. It is not aware of w=
hich subsystem is using it or what data is being dumped. We want to impleme=
nt something on top of it only for all bluetooth drivers so that they all c=
an generate firmware dumps in a common way and not worry about the synchron=
izations and timeouts. That's why it made more sense to me to have a blueto=
oth specific sysfs entry for enabling/disabling only the bluetooth devcored=
ump interface without affecting the other users of the base devcoredump.

It looks like we are not understanding each other, you are saying
devcoredump only provides a generalized mechanism for the driver to
dump the firmware coredump, yet we are implementing something extra to
generalize it for bluetooth drivers? Making it bluetooth specific sort
of defeat the purpose of a common layer in my opinion and it is not
like the devcoredump.c don't already have entries inside the device
sysfs directory as documented in sysfs-devices-coredump:

What: /sys/devices/.../coredump
Date: December 2017
Contact: Arend van Spriel <aspriel@gmail.com>
Description:
The /sys/devices/.../coredump attribute is only present when the
device is bound to a driver, which provides the .coredump()
callback. The attribute is write only. Anything written to this
file will trigger the .coredump() callback.

Available when CONFIG_DEV_COREDUMP is enabled.

What I'm suggesting is in addition to /sys/devices/.../coredump we
also have /sys/devices/.../enable_coredump, perhaps we should include
in the discussion since he is listed as maintainer of DEV_COREDUMP
nowadays.

> Do you suggest we have this sysfs entry for bluetooth class instead? like=
 "/sys/class/bluetooth/enable_coredump" instead of "/sys/class/bluetooth/<d=
evice>/enable_coredump"? But the problem with this is that if we have more =
than one bluetooth controller on the system, disabling one would disable th=
e other as well. So to have the flexibility of controlling it for each devi=
ce independently I am creating a sysfs entry for each device. IMO, the base=
 devcoredump class sysfs entry is not much of a use anymore as there are al=
ready other systems like wifi using it. Let me know your thoughts.
>
>>
>>
>> >
>> >>
>> >> --
>> >> Luiz Augusto von Dentz
>> >
>> >
>> > Regards,
>> > Manish.
>>
>>
>>
>> --
>> Luiz Augusto von Dentz
>
>
> Regards,
> Manish.



--=20
Luiz Augusto von Dentz
