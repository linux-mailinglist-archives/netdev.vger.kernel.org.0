Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17F06C13DF
	for <lists+netdev@lfdr.de>; Sun, 29 Sep 2019 10:03:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726198AbfI2IDV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Sep 2019 04:03:21 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:36687 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbfI2IDU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Sep 2019 04:03:20 -0400
Received: by mail-lj1-f194.google.com with SMTP id v24so6354216ljj.3;
        Sun, 29 Sep 2019 01:03:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zKN9ciuyM/IZpRio9kcEzRRJ8gdSuXrJxoj91BW+8C8=;
        b=qD52Odw5tQ82h0/myuhcaRe4flxJFcUz4Tda+VItLjcYMOAp9vvxj879Fq+kmlKli4
         QJtPoRQbow4HWSKgt1nG2fbjajRnZkW+Ra++20LyCjLjYiYTbj7p6i1q2DxUYcWoHwjx
         XDD4ge8VsGR7ZmBnpNIP4o5Idb8aSDGrmm6z5HS2oT+57/5PI1sgwi6RdBeZ5ehQmSap
         Qxc9xjhX4GYl9RfpE2/7afI8k1Mz7Wm/fBSykgB1rUlPhXKRSNBq4lAlnctIxApWfoho
         T3xJtMhMVJnpmdiN84j8Zb9NFtyhZ917n4p53Outci/RlLpkl/36zlcV0W/rySxEo3N5
         926w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zKN9ciuyM/IZpRio9kcEzRRJ8gdSuXrJxoj91BW+8C8=;
        b=mM5+ZMbo5PAIvwJXJ5Gn4ey75Wzpxoiup//pm8c4I46YDRI8I/qZ/K/Rh3vrID2EZx
         ab1P5VfV46+GwA88qoBBczUSptK6PUqTSLS8pLtaGDjDqOcG/m1zh/qopIJ6MiPK3Z9j
         GRyADwG6q0kLcDMTWAxKuTCLn77XFYFL2YdG/VU84+d70hYBWIPCMW5pu1nbg4QraSbK
         bdz7Ow8a2jVmx1VoP1BXz9DjfqTHhZOgv8QNu25C8RcyWdZ9q7D5nH8Pxi5KvYKlhWn/
         o2dsisFqmzyDRdZeKRZQI9K/ntWUrwiYnoJ8t8Y4FLsuGRqpb5wUw1+7pDSo1au/6oJ7
         pi/g==
X-Gm-Message-State: APjAAAX4NrR1A2+8pPYZomn6U7OnQRY40+Bi5qj/SeFHPRGr5bndMtXc
        1nQyTPJ0/Ju12Bs7tDY6S+eonNnd4yMS+a+m0MY=
X-Google-Smtp-Source: APXvYqzO3tNascQ8o2NU5O5UN19bujuwwXP/5CyjH6mEu9B2wKHiByY0i9TkOMwnZ4qF6oMpuIzmAoY5+Ous6G3IHPs=
X-Received: by 2002:a2e:7a16:: with SMTP id v22mr8331238ljc.61.1569744198070;
 Sun, 29 Sep 2019 01:03:18 -0700 (PDT)
MIME-Version: 1.0
References: <20190928164843.31800-1-ap420073@gmail.com> <20190928164843.31800-8-ap420073@gmail.com>
 <33adc57c243dccc1dcb478113166fa01add3d49a.camel@sipsolutions.net>
In-Reply-To: <33adc57c243dccc1dcb478113166fa01add3d49a.camel@sipsolutions.net>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Sun, 29 Sep 2019 17:03:06 +0900
Message-ID: <CAMArcTWrMq0qK72VJv=6ATugMSt_b=FiE4d+xOmi2K3FE8aEyA@mail.gmail.com>
Subject: Re: [PATCH net v4 07/12] macvlan: use dynamic lockdep key instead of subclass
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        j.vosburgh@gmail.com, vfalico@gmail.com,
        Andy Gospodarek <andy@greyhouse.net>,
        =?UTF-8?B?SmnFmcOtIFDDrXJrbw==?= <jiri@resnulli.us>,
        sd@queasysnail.net, Roopa Prabhu <roopa@cumulusnetworks.com>,
        saeedm@mellanox.com, manishc@marvell.com, rahulv@marvell.com,
        kys@microsoft.com, haiyangz@microsoft.com,
        Stephen Hemminger <stephen@networkplumber.org>,
        sashal@kernel.org, hare@suse.de, varun@chelsio.com,
        ubraun@linux.ibm.com, kgraul@linux.ibm.com,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        Cody Schuffelen <schuffelen@google.com>, bjorn@mork.no
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 29 Sep 2019 at 04:15, Johannes Berg <johannes@sipsolutions.net> wrote:
>
> Hi,
>

Hi Johannes,
Thank you so much for the detailed reviews!

> I hadn't seen the previous patchsets of this, and looking briefly in the
> archives didn't really seem to say anything about this.
>
>
> However, I'm wondering now: patches 2-7 of this patchset look basically
> all identical in a way:
>  * you set the addr_list_lock's class to a newly registered key inside
>    the netdev (or rather the private struct, but doesn't make a big
>    difference)
>  * you set each TX queue's _xmit_lock's class similarly
>  * you set the qdisc_tx_busylock/qdisc_running_key
>
> The first two of these look pretty much completely identical.
>
> Would it perhaps make sense to just do that for *every* netdev? Many of
> those netdevs won't ever nest so it wouldn't really be useful, but I'm
> not convinced it would put that much more strain on lockdep - if
> anything, people are probably creating more VLANs than regular PF/VF
> netdevs anyway?
>
> I didn't see any discussion on this, but perhaps I missed it? The cost
> would be a bigger netdev struct (when lockdep is enabled), but we
> already have that for all the VLANs etc. it's just in the private data,
> so it's not a _huge_ difference really I'd think, and this is quite a
> bit of code for each device type now.
>

Actually I agree with your opinion.
The benefits of this way are to be able to make common helper functions.
That would reduce duplicate codes and we can maintain this more easily.
But I'm not sure about the overhead of this way. So I would like to ask
maintainers and more reviewers about this.

> Alternatively, maybe there could just be some common helper code:
>
> struct nested_netdev_lockdep {
>         struct lock_class_key xmit_lock_key;
>         struct lock_class_key addr_lock_key;
> };
>
> void netdev_init_nested_lockdep(struct net_device *dev,
>                                 struct netsted_netdev_lockdep *l)
> {
>         /* ... */
> }
>
> so you just have to embed a "struct nested_netdev_lockdep" in your
> private data structure and call the common code.
>
> Or maybe make that
>
> void netdev_init_nested_lockdep(
>         struct net_device *dev,
>         struct
> netsted_netdev_lockdep *l,
>         struct lock_class_key
> *qdisc_tx_busylock_key,
>         struct lock_class_key *qdisc_running_key)
>
> so you can't really get that part wrong either?
>
>
> > @@ -922,6 +938,9 @@ static void macvlan_uninit(struct net_device *dev)
> >       port->count -= 1;
> >       if (!port->count)
> >               macvlan_port_destroy(port->dev);
> > +
> > +     lockdep_unregister_key(&vlan->addr_lock_key);
> > +     lockdep_unregister_key(&vlan->xmit_lock_key);
> >  }
>
> OK, so I guess you need an equivalent "deinit" function too -
> netdev_deinit_nested_lockdep() or so.
>

Using "struct nested_netdev_lockdep" looks really good.
I will make common codes such as "struct nested_netdev_lockdep"
and "netdev_devinit_nested_lockdep" and others in a v5 patch.

>
> What's not really clear to me is why the qdisc locks can actually stay
> the same at all levels? Can they just never nest? But then why are they
> different per device type?

I didn't test about qdisc so I didn't modify code related to qdisc code.
If someone reviews this, I would really appreciate.

Thank you

>
> Thanks,
> johannes
>
