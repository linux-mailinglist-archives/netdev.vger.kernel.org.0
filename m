Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 597843AF1D1
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 19:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231284AbhFURZK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 13:25:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230381AbhFURZI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 13:25:08 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3875BC061574
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 10:22:54 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id v11-20020a9d340b0000b0290455f7b8b1dcso5553515otb.7
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 10:22:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8IET/nd3uDx3lGxFdCihAdwaqhyjelNqMa7as7V1DhY=;
        b=IvWiwD6GRp0FQxv0F7eYMAel8aN5YgR60+6K34cr3uM0VZbH5WkhLZSoCy+2O8iMBW
         ioaC/eD2+deKuFceSwys/XtAfcQgbvBsw0/Eq8DhM2/6cORsz3f9Yi7pacJ8GNgEf1wM
         Xr/TE6GTUaFo4hDmoQJEd9RRURHM3V5xISzjavoO8l46A5jxOTidBWeMT1nQ9kXjzGr1
         GOTlwqEF3MVe7OC6eQ5YX35qRhx09/lpJYwCXrTmWsxbu2fxFFLYUS7BlTuZhKgtCuOF
         jSKu3i7JPfluyhAEhmjr2yzpHIBZZ91jhpZ32piZxZJmrBJbzvcvemnJ+qODMywlDtuL
         jzDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8IET/nd3uDx3lGxFdCihAdwaqhyjelNqMa7as7V1DhY=;
        b=t1UM4f/d/lllvRI75QUmwW4IUfvv/FdLdMlulVsfFKlwnBtxmR9zLGPES8TfWk/LW8
         Xsvn6A9yR/aNQncIk0CpnMTGIhQD70JETYKXXeZbGYQd1r5n4TodIRL9MVBQv/IVaDC4
         l7BSn9U4LPOmLT1cetYO8SnonfpEJg9Yei5y//kMs9M0q/VC1SNARlMd2jgHdEZhWsFj
         VeImUqHKRnzcNGuaY+0MqMy6XIhnW8hH671BWiHafY5YvMs71mgA64bwhlWiXkDTTVYr
         3rtJ4mNiyEkaBTXIjWTD4Aa2Awet8RpZx3JEe285X5BI9Ctt9tWv0dqoXmXRI/FC3bvC
         BoOw==
X-Gm-Message-State: AOAM5302gDhGsIlXX1F3FEJJNLn1PkM5b8jaXhFbCtLoNdMPpYmEm33w
        e5irZCW4GZUnodDMEOWdyW24maJmF0x+IgNA9BQ=
X-Google-Smtp-Source: ABdhPJyHgm0flICNd2eJfJnE9v1fs1Y9Jq4w99fYS8utjNXXgK4Q23dozuFJLvIy4Rc14XGRQ+a0t257np8nQ/NDBTg=
X-Received: by 2002:a9d:7748:: with SMTP id t8mr21059445otl.110.1624296173591;
 Mon, 21 Jun 2021 10:22:53 -0700 (PDT)
MIME-Version: 1.0
References: <20210615003016.477-1-ryazanov.s.a@gmail.com> <20210615003016.477-11-ryazanov.s.a@gmail.com>
 <CAMZdPi9mSfaYFnAt5Qux7HtCMkE-4KkkGL8i8T3rtxNXekK+Eg@mail.gmail.com>
 <CAHNKnsQdWWJ1tAHt4LPS=3jWNSCDcUdQDSrkZ9aakYp-4iaKVw@mail.gmail.com> <CAMZdPi_e+ibRQiytAYkjo1A9GzLm6Np6Tma-6KMHuWfFcaFsCg@mail.gmail.com>
In-Reply-To: <CAMZdPi_e+ibRQiytAYkjo1A9GzLm6Np6Tma-6KMHuWfFcaFsCg@mail.gmail.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Mon, 21 Jun 2021 20:22:42 +0300
Message-ID: <CAHNKnsS44SrnWXXkMNX=HvgeMRnZMckE-CWVTK_Z+Nyd3RRcPg@mail.gmail.com>
Subject: Re: [PATCH net-next 10/10] wwan: core: add WWAN common private data
 for netdev
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        Intel Corporation <linuxwwan@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Loic,

On Mon, Jun 21, 2021 at 10:28 AM Loic Poulain <loic.poulain@linaro.org> wrote:
> On Sun, 20 Jun 2021 at 16:39, Sergey Ryazanov <ryazanov.s.a@gmail.com> wrote:
>> On Tue, Jun 15, 2021 at 10:24 AM Loic Poulain <loic.poulain@linaro.org> wrote:
>>> On Tue, 15 Jun 2021 at 02:30, Sergey Ryazanov <ryazanov.s.a@gmail.com> wrote:
>>>> The WWAN core not only multiplex the netdev configuration data, but
>>>> process it too, and needs some space to store its private data
>>>> associated with the netdev. Add a structure to keep common WWAN core
>>>> data. The structure will be stored inside the netdev private data before
>>>> WWAN driver private data and have a field to make it easier to access
>>>> the driver data. Also add a helper function that simplifies drivers
>>>> access to their data.
>>>
>>> Would it be possible to store wwan_netdev_priv at the end of priv data instead?
>>> That would allow drivers to use the standard netdev_priv without any change.
>>> And would also simplify forwarding to rmnet (in mhi_net) since rmnet
>>> uses netdev_priv.
>>
>> I do not think that mimicking something by one subsystem for another
>> is generally a good idea. This could look good in a short term, but
>> finally it will become a headache due to involvement of too many
>> entities.
>>
>> IMHO, a suitable approach to share the rmnet library and data
>> structures among drivers is to make the rmnet interface more generic.
>>
>> E.g. consider such netdev/rtnl specific function:
>>
>> static int rmnet_foo_action(struct net_device *dev, ...)
>> {
>>     struct rmnet_priv *rmdev = netdev_priv(dev);
>>     <do a foo action here>
>> }
>>
>> It could be split into a wrapper and an actual handler:
>>
>> int __rmnet_foo_action(struct rmnet_priv *rmdev, ...)
>> {
>>     <do a foo action here>
>> }
>> EXPORT_GPL(__rmnet_foo_action)
>>
>> static int rmnet_foo_action(struct net_device *dev, ...)
>> {
>>     struct rmnet_priv *rmdev = netdev_priv(dev);
>>     return __rmnet_foo_action(rmdev, ...)
>> }
>>
>> So a call from mhi_net to rmnet could looks like this:
>>
>> static int mhi_net_foo_action(struct net_device *dev, ...)
>> {
>>     struct rmnet_priv *rmdev = wwan_netdev_drvpriv(dev);
>>     return __rmnet_foo_action(rmdev, ...)
>> }
>>
>> In such a way, only the rmnet users know something special, while
>> other wwan core users and the core itself behave without any
>> surprises. E.g. any regular wwan core minidriver can access the
>> link_id field of the wwan common data by calling netdev_priv() without
>> further calculating the common data offset.
>
> Yes, that would work, but it's an important refactoring since rmnet is
> all built around the idea that netdev_priv is rmnet_priv, including rx
> path (netdev_priv(skb->dev)).
> My initial tests were based on this 'simple' change:
> https://git.linaro.org/people/loic.poulain/linux.git/commit/?h=wwan_rmnet&id=6308d49790f10615bd33a38d56bc7f101646558f
>
> Moreover, a driver like mhi_net also supports non WWAN local link
> (called mhi_swip), which is a network link between the host and the
> modem cpu (for modem hosted services...). This link is not managed by
> the WWAN layer and is directly created by mhi_net. I could create a
> different driver or set of handlers for this netdev, but it's
> additional complexity.

Correct me if I am wrong. I just checked the rmnet code and realized
that rmnet should work on top of mhi_net and not vice versa. mhi_net
should provide some kind of transportation for QMAP packets from a HW
device to rmnet. Then rmnet will perform demultiplexing, deaggregation
and decapsulation of QMAP packets to pure IP packets.

rmnet itself receives these QMAP packets via a network device. So any
driver that would like to provide the QMAP transport for rmnet should
create a network device for this task.

The main issue with the integration of mhi_net with the wwan is that
the mhi_net driver should pass its traffic through the rmnet demuxer.
While the network device that will be created by the rmnet demuxer
will not be a child of a MHI device or a wwan device. So to properly
integrate the mhi_net driver with the wwan core netdev capabilities,
you should begin to use rmnet not as an independent demux created on
top of a transport network interface, but as a library. Am I correctly
understanding?

Does the same issue appear when we begin a more tight integration of
the qmi_wwan USB driver with the wwan core?

I would like to say that one way or another, rmnet will be converted
to a quite abstract library that should avoid direct access to the
network device private data.

>>>> At the moment we use the common WWAN private data to store the WWAN data
>>>> link (channel) id at the time the link is created, and report it back to
>>>> user using the .fill_info() RTNL callback. This should help the user to
>>>> be aware which network interface is binded to which WWAN device data
>>>> channel.
>
> I wonder if it would not be simpler to store the link ID into
> netdev->dev_port, it's after all a kind of virtual/logical port.
> That would only postpone the introduction of a wwan_netdev_priv struct though.

I like this idea. This is likely to solve the link id storage problem.
But only if we plan to never extend the wwan core private data.
Otherwise, as you mention, this only postpones the wwan data structure
introduction to a moment when we will need to rework a lot of drivers.

Looks like we have no absolutely good solution. Only a set of
proposals, each which has its own shortcomings :(

-- 
Sergey
