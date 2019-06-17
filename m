Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71C1947FE0
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 12:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726898AbfFQKks (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 06:40:48 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:35586 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726427AbfFQKks (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 06:40:48 -0400
Received: by mail-lj1-f195.google.com with SMTP id x25so8818099ljh.2
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 03:40:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qjyOm5jUlTHrm3VcdpTzvNXJzoC5FF0ZBV+AJFqfwy8=;
        b=gy5kjwRSDGUmg+loUcjvpvKLKPjh8DRZE092YszFWVPKk36tVOMTs3TvbNA+0dsR91
         WIJqH6O9/9sAJonxuI1Bo9pqATokUYLTsE1xdKNrqKtwtSTXwCgpvj3D8O1DiTtBa3OY
         7xZj8JVm4zw7NsxAfSMv8gX5XE/N8Pv+2B//BpaRBjwYD/V+pD2KBQL9EJtpdJJJVRYL
         kJ8RyTd6iaFhRuRtxAHlUP0QKB81uQQochdQfknajVs8eplC+0XzPhRvBq7uNQTewY69
         guVmNzppj2Bst0zPUgPbjO0Eu3gjErwfwbcJnGaIMYQB9AmjG1hKKz01MiNje2MoOaMG
         QOtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qjyOm5jUlTHrm3VcdpTzvNXJzoC5FF0ZBV+AJFqfwy8=;
        b=o3yYxvJUVY9kXfhPd2TQ5pcLtTDSwXP9FcrzmeCq8TpG2zPhaRoSnMomZo5st6qgrL
         RdxIQLLvXM/Kig3rfbPmnCPoIsq7vwQQChs1Jv2aVHxxqz8/NjPGowiHBCdDRwjvZL4t
         nq3U0hcsnbDssHzWjCeY2L+xl7EM0bJbxkt8awWgemELOFe+8dtnNxQhtR8scfRvlo+W
         yThg9wYayh0L7FX8jbehyGyEMywmVEO7mRvZeWKszGAOzzzmEDMAaJVG0dyOGf3Mm+sU
         FJ8kl1Giiwi5yyBV5K5HS4qj8Lo2Ej0b9+kKTLz6BnbR3vI+eCh71IYNhzSwhkRP+NeU
         IZqA==
X-Gm-Message-State: APjAAAXcrRD+ZTgmkCwOGUmMIH055ztUEVXCZ7RhHD/CHta7MmXYHthx
        98aczKGOmKWE7RgCVuiC+FyKD2p+WnhIKBETWVOV3Q==
X-Google-Smtp-Source: APXvYqyJ/4NlVGen9mEDEJFgUwywW3Ugc4Zau5rMZozFcJhZbBt5k0iq0dveVQb3h5/rYoTvJhHb9pQlQGGet7oAI54=
X-Received: by 2002:a2e:6c14:: with SMTP id h20mr1705967ljc.38.1560768045802;
 Mon, 17 Jun 2019 03:40:45 -0700 (PDT)
MIME-Version: 1.0
References: <20190617073320.69015-1-lifei.shirley@bytedance.com>
 <28bef625-ce70-20a1-7d8b-296cd43015c4@redhat.com> <2d05dce3-e19a-2f0f-8b74-8defae38640d@redhat.com>
 <CA+=e4K6_EGK+r4RXWpK2wZ5OW9JNQS9NfGpZtG3grjhApAFCEw@mail.gmail.com>
In-Reply-To: <CA+=e4K6_EGK+r4RXWpK2wZ5OW9JNQS9NfGpZtG3grjhApAFCEw@mail.gmail.com>
From:   =?UTF-8?B?5p2O6I+y?= <lifei.shirley@bytedance.com>
Date:   Mon, 17 Jun 2019 18:40:34 +0800
Message-ID: <CA+=e4K7VCqJD_g_a3GHpjqAKhJxs3T+88tBjyabRTh2SzB=cOw@mail.gmail.com>
Subject: Re: [External Email] Re: [PATCH] Fix tun: wake up waitqueues after
 IFF_UP is set
To:     Jason Wang <jasowang@redhat.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     zhengfeiran@bytedance.com, duanxiongchun@bytedance.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

On Mon, Jun 17, 2019 at 5:32 PM =E6=9D=8E=E8=8F=B2 <lifei.shirley@bytedance=
.com> wrote:
>
> Ok, thanks for detail suggestion! :)
>
> On Mon, Jun 17, 2019 at 4:16 PM Jason Wang <jasowang@redhat.com> wrote:
>>
>>
>> On 2019/6/17 =E4=B8=8B=E5=8D=884:10, Jason Wang wrote:
>> >
>> > On 2019/6/17 =E4=B8=8B=E5=8D=883:33, Fei Li wrote:
>> >> Currently after setting tap0 link up, the tun code wakes tx/rx waited
>> >> queues up in tun_net_open() when .ndo_open() is called, however the
>> >> IFF_UP flag has not been set yet. If there's already a wait queue, it
>> >> would fail to transmit when checking the IFF_UP flag in tun_sendmsg()=
.
>> >> Then the saving vhost_poll_start() will add the wq into wqh until it
>> >> is waken up again. Although this works when IFF_UP flag has been set
>> >> when tun_chr_poll detects; this is not true if IFF_UP flag has not
>> >> been set at that time. Sadly the latter case is a fatal error, as
>> >> the wq will never be waken up in future unless later manually
>> >> setting link up on purpose.
>> >>
>> >> Fix this by moving the wakeup process into the NETDEV_UP event
>> >> notifying process, this makes sure IFF_UP has been set before all
>> >> waited queues been waken up.
>>
>>
>> Btw, the title needs some tweak. E.g you need use "net" as prefix since
>> it's a fix for net.git and "Fix" could be removed like:
>>
>> [PATCH net] tun: wake up waitqueues after IFF_UP is set.
>>
>> Thanks
>>
>>
>> >>
>> >> Signed-off-by: Fei Li <lifei.shirley@bytedance.com>
>> >> ---
>> >>   drivers/net/tun.c | 17 +++++++++--------
>> >>   1 file changed, 9 insertions(+), 8 deletions(-)
>> >>
>> >> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
>> >> index c452d6d831dd..a3c9cab5a4d0 100644
>> >> --- a/drivers/net/tun.c
>> >> +++ b/drivers/net/tun.c
>> >> @@ -1015,17 +1015,9 @@ static void tun_net_uninit(struct net_device
>> >> *dev)
>> >>   static int tun_net_open(struct net_device *dev)
>> >>   {
>> >>       struct tun_struct *tun =3D netdev_priv(dev);
Will remove the above unused struct in next version.
Sorry for the negligence!

Have a nice day, thanks
Fei


>> >> -    int i;
>> >>         netif_tx_start_all_queues(dev);
>> >>   -    for (i =3D 0; i < tun->numqueues; i++) {
>> >> -        struct tun_file *tfile;
>> >> -
>> >> -        tfile =3D rtnl_dereference(tun->tfiles[i]);
>> >> - tfile->socket.sk->sk_write_space(tfile->socket.sk);
>> >> -    }
>> >> -
>> >>       return 0;
>> >>   }
>> >>   @@ -3634,6 +3626,7 @@ static int tun_device_event(struct
>> >> notifier_block *unused,
>> >>   {
>> >>       struct net_device *dev =3D netdev_notifier_info_to_dev(ptr);
>> >>       struct tun_struct *tun =3D netdev_priv(dev);
>> >> +    int i;
>> >>         if (dev->rtnl_link_ops !=3D &tun_link_ops)
>> >>           return NOTIFY_DONE;
>> >> @@ -3643,6 +3636,14 @@ static int tun_device_event(struct
>> >> notifier_block *unused,
>> >>           if (tun_queue_resize(tun))
>> >>               return NOTIFY_BAD;
>> >>           break;
>> >> +    case NETDEV_UP:
>> >> +        for (i =3D 0; i < tun->numqueues; i++) {
>> >> +            struct tun_file *tfile;
>> >> +
>> >> +            tfile =3D rtnl_dereference(tun->tfiles[i]);
>> >> + tfile->socket.sk->sk_write_space(tfile->socket.sk);
>> >> +        }
>> >> +        break;
>> >>       default:
>> >>           break;
>> >>       }
>> >
>> >
>> > Acked-by: Jason Wang <jasowang@redhat.com)
>> >
