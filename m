Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53B923B0893
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 17:19:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232139AbhFVPVV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 11:21:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231248AbhFVPVU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 11:21:20 -0400
Received: from mail-oo1-xc30.google.com (mail-oo1-xc30.google.com [IPv6:2607:f8b0:4864:20::c30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EB53C061574
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 08:19:05 -0700 (PDT)
Received: by mail-oo1-xc30.google.com with SMTP id k1-20020a0568200161b029024bef8a628bso137452ood.7
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 08:19:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=iwJTxV0afnVJFb1kIB6o0sjs7DgH5Se+BUzGObjav6A=;
        b=guMM7aKj6tz8IX3ZyqrELtsv0IMEUmR/hn525m/MWPthSkm/nZjJZGzY/RedOiQ0kI
         xk4I6/VGrx9LSTT8EUbzb0+vBN2tf6jZfj/Qtm5QVDBE/DwqcVn0jglrimWrCKx5Wbwq
         a3kUOvZFYsVNQzRsDmGkrrAzmJFX/po/i/D1OlK820vk+q22CZYQgmNmvaifzyXgYHvh
         ni6+ji8NyfiQAXcBCyepbOU6K+Y6qR5OCvTE038dtrUUpvX1F3v66WOBWxq5c2Xc7iZc
         kbqbPWYXwwTuQ47P3CBXhCi9DuWTm+QVgBK1wTRZz3Xz4mVXJOnMfLbB7kjLl3vo+1vx
         84TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=iwJTxV0afnVJFb1kIB6o0sjs7DgH5Se+BUzGObjav6A=;
        b=Ga9eraoQiaVBYDWPWb/m/S1exTmDG62TL9Q1jrpDFsJ3Yuqxib5Hmp0UYY9KgzTvBR
         bS1akMZRFmCIFQ1Frfn47o2W3QbzcvEetsj9XiVQ8MfE3yS+K4PLiePm/6OCqNAvAUdB
         60/G2aHE7xeGK2dr0Oozux55nT11ZduMrCv0UqxBSyMVyD1lfg5aq7o5ncjUsOIG1mVH
         0oBSSZ9uvER3aeK3JZj4rEiLRN8CIaUnWsMOxsT0gRcAJ2UZc4l+s9e552n8XZQO7nDU
         tgbnk+YyZzNKud7qSucG3NFZKQffKu7UBRrvsbrAnzOHoib84bsw1VFXQ5oNTxxfqEhT
         q/Zg==
X-Gm-Message-State: AOAM533cP7wrjY0YSrYWuSBwyPFFbyTtnFpt+fhvOXi8EWU2XCMJYPqn
        xrmepknKxKLIjEJNDpH/sBGcx+H2wGXSdgpTPCU=
X-Google-Smtp-Source: ABdhPJzP4dfP/V9+Mrsr8DJs3MLWueiBTmBiIRzR1iQjdH2dj9sVo/lkBso7kT7umZ0XgkAtnCkBcpEGf33W8kJBwBE=
X-Received: by 2002:a4a:98b0:: with SMTP id a45mr3815263ooj.22.1624375144345;
 Tue, 22 Jun 2021 08:19:04 -0700 (PDT)
MIME-Version: 1.0
References: <20210621225100.21005-1-ryazanov.s.a@gmail.com>
 <20210621225100.21005-9-ryazanov.s.a@gmail.com> <CAMZdPi-6Fpft80Vis-NR4grfcyfdH9DTs9BHfE-J+-6_c+2dJw@mail.gmail.com>
In-Reply-To: <CAMZdPi-6Fpft80Vis-NR4grfcyfdH9DTs9BHfE-J+-6_c+2dJw@mail.gmail.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Tue, 22 Jun 2021 18:18:53 +0300
Message-ID: <CAHNKnsRsfkjiN0VDPRmipXFe_OaSnM=xdF17BPEsuf+J+LAO2w@mail.gmail.com>
Subject: Re: [PATCH net-next v2 08/10] wwan: core: support default netdev creation
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        Intel Corporation <linuxwwan@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Loic,

On Tue, Jun 22, 2021 at 4:55 PM Loic Poulain <loic.poulain@linaro.org> wrot=
e:
> On Tue, 22 Jun 2021 at 00:51, Sergey Ryazanov <ryazanov.s.a@gmail.com> wr=
ote:
>> Most, if not each WWAN device driver will create a netdev for the
>> default data channel. Therefore, add an option for the WWAN netdev ops
>> registration function to create a default netdev for the WWAN device.
>>
>> A WWAN device driver should pass a default data channel link id to the
>> ops registering function to request the creation of a default netdev, or
>> a special value WWAN_NO_DEFAULT_LINK to inform the WWAN core that the
>> default netdev should not be created.
>>
>> For now, only wwan_hwsim utilize the default link creation option. Other
>> drivers will be reworked next.
>>
>> Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
>> CC: M Chetan Kumar <m.chetan.kumar@intel.com>
>> CC: Intel Corporation <linuxwwan@intel.com>
>> ---
>>
>> v1 -> v2:
>>  * fix a comment style '/**' -> '/*' to avoid confusion with kernel-doc
>>
>>  drivers/net/mhi/net.c                 |  3 +-
>>  drivers/net/wwan/iosm/iosm_ipc_wwan.c |  3 +-
>>  drivers/net/wwan/wwan_core.c          | 75 ++++++++++++++++++++++++++-
>>  drivers/net/wwan/wwan_hwsim.c         |  2 +-
>>  include/linux/wwan.h                  |  8 ++-
>>  5 files changed, 86 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/net/mhi/net.c b/drivers/net/mhi/net.c
>> index ffd1c01b3f35..f36ca5c0dfe9 100644
>> --- a/drivers/net/mhi/net.c
>> +++ b/drivers/net/mhi/net.c
>> @@ -397,7 +397,8 @@ static int mhi_net_probe(struct mhi_device *mhi_dev,
>>         struct net_device *ndev;
>>         int err;
>>
>> -       err =3D wwan_register_ops(&cntrl->mhi_dev->dev, &mhi_wwan_ops, m=
hi_dev);
>> +       err =3D wwan_register_ops(&cntrl->mhi_dev->dev, &mhi_wwan_ops, m=
hi_dev,
>> +                               WWAN_NO_DEFAULT_LINK);
>>         if (err)
>>                 return err;
>>
>> diff --git a/drivers/net/wwan/iosm/iosm_ipc_wwan.c b/drivers/net/wwan/io=
sm/iosm_ipc_wwan.c
>> index bee9b278223d..adb2bd40a404 100644
>> --- a/drivers/net/wwan/iosm/iosm_ipc_wwan.c
>> +++ b/drivers/net/wwan/iosm/iosm_ipc_wwan.c
>> @@ -317,7 +317,8 @@ struct iosm_wwan *ipc_wwan_init(struct iosm_imem *ip=
c_imem, struct device *dev)
>>         ipc_wwan->dev =3D dev;
>>         ipc_wwan->ipc_imem =3D ipc_imem;
>>
>> -       if (wwan_register_ops(ipc_wwan->dev, &iosm_wwan_ops, ipc_wwan)) =
{
>> +       if (wwan_register_ops(ipc_wwan->dev, &iosm_wwan_ops, ipc_wwan,
>> +                             WWAN_NO_DEFAULT_LINK)) {
>>                 kfree(ipc_wwan);
>>                 return NULL;
>>         }
>> diff --git a/drivers/net/wwan/wwan_core.c b/drivers/net/wwan/wwan_core.c
>> index b634a0ba1196..ef6ec641d877 100644
>> --- a/drivers/net/wwan/wwan_core.c
>> +++ b/drivers/net/wwan/wwan_core.c
>> @@ -903,17 +903,81 @@ static struct rtnl_link_ops wwan_rtnl_link_ops __r=
ead_mostly =3D {
>>         .policy =3D wwan_rtnl_policy,
>>  };
>>
>> +static void wwan_create_default_link(struct wwan_device *wwandev,
>> +                                    u32 def_link_id)
>> +{
>> +       struct nlattr *tb[IFLA_MAX + 1], *linkinfo[IFLA_INFO_MAX + 1];
>> +       struct nlattr *data[IFLA_WWAN_MAX + 1];
>> +       struct net_device *dev;
>> +       struct nlmsghdr *nlh;
>> +       struct sk_buff *msg;
>> +
>> +       /* Forge attributes required to create a WWAN netdev. We first
>> +        * build a netlink message and then parse it. This looks
>> +        * odd, but such approach is less error prone.
>> +        */
>> +       msg =3D nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
>> +       if (WARN_ON(!msg))
>> +               return;
>> +       nlh =3D nlmsg_put(msg, 0, 0, RTM_NEWLINK, 0, 0);
>> +       if (WARN_ON(!nlh))
>> +               goto free_attrs;
>> +
>> +       if (nla_put_string(msg, IFLA_PARENT_DEV_NAME, dev_name(&wwandev-=
>dev)))
>> +               goto free_attrs;
>> +       tb[IFLA_LINKINFO] =3D nla_nest_start(msg, IFLA_LINKINFO);
>> +       if (!tb[IFLA_LINKINFO])
>> +               goto free_attrs;
>> +       linkinfo[IFLA_INFO_DATA] =3D nla_nest_start(msg, IFLA_INFO_DATA)=
;
>> +       if (!linkinfo[IFLA_INFO_DATA])
>> +               goto free_attrs;
>> +       if (nla_put_u32(msg, IFLA_WWAN_LINK_ID, def_link_id))
>> +               goto free_attrs;
>> +       nla_nest_end(msg, linkinfo[IFLA_INFO_DATA]);
>> +       nla_nest_end(msg, tb[IFLA_LINKINFO]);
>> +
>> +       nlmsg_end(msg, nlh);
>> +
>> +       /* The next three parsing calls can not fail */
>> +       nlmsg_parse_deprecated(nlh, 0, tb, IFLA_MAX, NULL, NULL);
>> +       nla_parse_nested_deprecated(linkinfo, IFLA_INFO_MAX, tb[IFLA_LIN=
KINFO],
>> +                                   NULL, NULL);
>> +       nla_parse_nested_deprecated(data, IFLA_WWAN_MAX,
>> +                                   linkinfo[IFLA_INFO_DATA], NULL, NULL=
);
>> +
>> +       rtnl_lock();
>> +
>> +       dev =3D rtnl_create_link(&init_net, "wwan%d", NET_NAME_ENUM,
>> +                              &wwan_rtnl_link_ops, tb, NULL);
>
> That can be a bit confusing since the same naming convention as for
> the WWAN devices is used, so you can end with something like a wwan0
> netdev being a link of wwan1 dev. Maybe something like ('%s.%d',
> dev_name(&wwandev->dev), link_id) to have e.g. wwan1.0 for link 0 of
> the wwan1 device. Or alternatively, the specific wwan driver to
> specify the default name to use.

Yeah. Having wwan1 netdev for wwan0 device with control port
/dev/wwan0mbim0 could be =D0=B9uite confusing for a _user_. While the
ModemManager daemon will keep track of parent<->child relations
without considering device names.

It is a permanent pain to manually find the right modem control port.
Even if you only have one modem, but have a UART-USB converter
attached before the modem, then /dev/ttyUSB0, which previously
belonged to a first modem AT-port, can become the UART-USB device, and
the first modem AT-port can become /dev/ttyUSB1. We never have
guarantees for consistent naming, and user space software should take
care of the matching and predictable names :(

wwanX.Y names look attractive. But how many users will actually use
multiple data channels and create wwanX.2, wwanX.3, etc. netdevs?
Moreover, some cellular modems do not support multiple data channels
and will never do so.

I assume that a typical usage scenario for an average user is a single
modem connected to a laptop with a single data channel for Internet
access. In this case, the user will not have a chance to see the wwan1
netdev. And no confusion is possible in practice. Even more, seeing a
wwan0.1 netdev when you have a single modem with a single data channel
will be a more confusing case. Those who will use a more complex setup
should be ready for some complexity. In fact, for a more complex setup
(e.g. if you have a pair of modems) you will need some sort of
management software (or udev scripts) since you can never be sure that
a USB modem connected to a first USB port, will always be wwan0.

Even if you have a couple of modems of different models (one works
as-is and the other uses the WWAN core), it will be a big surprise for
the user to find that the wwan0.1 netdev is not a second connection
via the first modem, but it is a main connection of the second modem
:)

And finally, I assume that in the mid-term, we will switch all WWAN
device drivers to the WWAN core usage, and the WWAN core will be the
only producer of wwanX devices. As well as all Wi-Fi device drivers
have been migrated to cfg80211/mac80211 usage. In that context,
introducing the wwanX.Y naming scheme now and changing it back to the
wwanX later will be some kind of API breakage.

With all this in mind, I chose the wwanX as the naming template for
the default data channel netdev.

--=20
Sergey
