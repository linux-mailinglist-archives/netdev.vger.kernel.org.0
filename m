Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEEE1474F0D
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 01:23:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238421AbhLOAXi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 19:23:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232228AbhLOAXi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 19:23:38 -0500
Received: from mail-ua1-x931.google.com (mail-ua1-x931.google.com [IPv6:2607:f8b0:4864:20::931])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17219C061574;
        Tue, 14 Dec 2021 16:23:38 -0800 (PST)
Received: by mail-ua1-x931.google.com with SMTP id i6so37894353uae.6;
        Tue, 14 Dec 2021 16:23:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0JKc9PAD26kXoepjJUR+P8qecRLoOY8+4P0m+zClgn4=;
        b=ayk5kQZm5ugA+VzApd8WhDdXBTuyrtiAvgZuvkMqGdfgS3Yjd0gy/VOB44Q1yhgaSS
         PjnFcX50Z85F30+YkmtrwG974C5zIGvUUDRf9yPStrSKRR6Fduuw35hfbsNfkwNQxCL0
         FGlmJ5loYGqdTtL6ZBUw5T6aI1yRdUE4k5VEQ9Q0++F+kzx7uw+h2wIFI9Irat67CRV8
         YI8OKmg5rqW9C2KB/BOEwSXrNgWYTiLxVazWVAG8kcFn4GpgCEI//+TtPaLZYkfHgnw7
         Qx+/sMbzMARPsb4lhnetxe9Ms5imHDK8iaRu1E7uZekJizWWsr4OZ/Su5AOEsPhtH7eK
         m8cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0JKc9PAD26kXoepjJUR+P8qecRLoOY8+4P0m+zClgn4=;
        b=AjKcSiYE/3aVtje4uuv0Be2epdHrZ3mnNkhmMMS4undDfXf1emvWF48wIatVI3dafh
         zlps6bLvzQnF5iqeZsL3bYVVl86UBd1KuSOxf163S5xXjxix/dJwXZ3JlTAzj6BLSRRn
         sVwUQPoATKYU+lb5NWOyOEBbQwig8s0/Zgnb0atTEqEzt8lGTm4+96ocaPUJln9QffrG
         NqS7i+20qZxhW8Tm9sPP3qzCLLzYLy9qnjn+GqPE8/9DizEYGrgEuaWZbMkWnc8Zamzb
         CIUxJg12cjGb0fixpQBV/yI30w1YcL+AyGEUT3Cbl4thuLEM6HP9B9yVEP7YvLT/rzbQ
         xNVw==
X-Gm-Message-State: AOAM533K+3xn7XhO4Nq2FPyqcNHwJorysMcB6NMfbjacSC2i6v1i+qoT
        7Y/84TifC+1atJNo8I5VXz15lyo3enAnZIDBvEg=
X-Google-Smtp-Source: ABdhPJxtQ6JNBvuRrv1uViR4vf3z4MmjQ9pOIp4wghat9QvMKS2ot1bg2Bzq6ht2NYd2T4l8z68gU7t9mvzk1jzkxwo=
X-Received: by 2002:a05:6102:c4e:: with SMTP id y14mr1866950vss.61.1639527817027;
 Tue, 14 Dec 2021 16:23:37 -0800 (PST)
MIME-Version: 1.0
References: <20211208040414.151960-1-xiayu.zhang@mediatek.com>
 <CAHNKnsRZpYsiWORgAejYwQqP5P=PSt-V7_i73G1yfh-UR2zFjw@mail.gmail.com> <6f4ae1d8b1b53cf998eaa14260d93fd3f4c8d5ad.camel@mediatek.com>
In-Reply-To: <6f4ae1d8b1b53cf998eaa14260d93fd3f4c8d5ad.camel@mediatek.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Wed, 15 Dec 2021 03:23:28 +0300
Message-ID: <CAHNKnsQ6qLcUTiTiPEAp+rmoVtrGOjoY98nQFsrwSWUu-v7wYQ@mail.gmail.com>
Subject: Re: [PATCH] Add Multiple TX/RX Queues Support for WWAN Network Device
To:     Xiayu Zhang <xiayu.zhang@mediatek.com>
Cc:     Loic Poulain <loic.poulain@linaro.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        netdev@vger.kernel.org, open list <linux-kernel@vger.kernel.org>,
        haijun.liu@mediatek.com, zhaoping.shu@mediatek.com,
        hw.he@mediatek.com, srv_heupstream@mediatek.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Xiayu,

On Mon, Dec 13, 2021 at 9:06 AM Xiayu Zhang <xiayu.zhang@mediatek.com> wrote:
> Thanks for your constructive inputs, and sorry for late response.
>
> On Fri, 2021-12-10 at 02:11 +0300, Sergey Ryazanov wrote:
>> On Wed, Dec 8, 2021 at 7:04 AM <xiayu.zhang@mediatek.com> wrote:
>>> This patch adds 2 callback functions get_num_tx_queues() and
>>> get_num_rx_queues() to let WWAN network device driver customize its
>>> own
>>> TX and RX queue numbers. It gives WWAN driver a chance to implement
>>> its
>>> own software strategies, such as TX Qos.
>>>
>>> Currently, if WWAN device driver creates default bearer interface
>>> when
>>> calling wwan_register_ops(), there will be only 1 TX queue and 1 RX
>>> queue
>>> for the WWAN network device. In this case, driver is not able to
>>> enlarge
>>> the queue numbers by calling netif_set_real_num_tx_queues() or
>>> netif_set_real_num_rx_queues() to take advantage of the network
>>> device's
>>> capability of supporting multiple TX/RX queues.
>>>
>>> As for additional interfaces of secondary bearers, if userspace
>>> service
>>> doesn't specify the num_tx_queues or num_rx_queues in netlink
>>> message or
>>> iproute2 command, there also will be only 1 TX queue and 1 RX queue
>>> for
>>> each additional interface. If userspace service specifies the
>>> num_tx_queues
>>> and num_rx_queues, however, these numbers could be not able to
>>> match the
>>> capabilities of network device.
>>>
>>> Besides, userspace service is hard to learn every WWAN network
>>> device's
>>> TX/RX queue numbers.
>>>
>>> In order to let WWAN driver determine the queue numbers, this patch
>>> adds
>>> below callback functions in wwan_ops:
>>>     struct wwan_ops {
>>>         unsigned int priv_size;
>>>         ...
>>>         unsigned int (*get_num_tx_queues)(unsigned int hint_num);
>>>         unsigned int (*get_num_rx_queues)(unsigned int hint_num);
>>>     };
>>>
>>> WWAN subsystem uses the input parameters num_tx_queues and
>>> num_rx_queues of
>>> wwan_rtnl_alloc() as hint values, and passes the 2 values to the
>>> two
>>> callback functions. WWAN device driver should determine the actual
>>> numbers
>>> of network device's TX and RX queues according to the hint value
>>> and
>>> device's capabilities.
>>
>> As already stated by Jakub, it is hard to understand a new API
>> suitability without an API user. I will try to describe possible
>> issues with the proposed API as far as I understand its usage and
>> possible solutions. Correct me if I am wrong.
>>
>> There are actually two tasks related to the queues number selection:
>> 1) default queues number selection if the userspace provides no
>> information about a wishful number of queues;
>> 2) rejecting the new netdev (bearer) creation if a requested number
>> of queues seems to be invalid.
>>
>> Your proposal tries to solve both of these tasks with a single hook
>> that silently increases or decreases the requested number of queues.
>> This is creative, but seems contradictory to regular RTNL behavior.
>> RTNL usually selects a correct default value if no value was
>> requested, or performs what is requested, or explicitly rejects
>> requested configuration.
>>
>> You could handle an invalid queues configuration in the .newlink
>> callback. This callback is even able to return a string error
>> representation via the extack argument.
>>
>> As for the default queues number selection it seems better to
>> implement the RTNL .get_num_rx_queues callback in the WWAN core and
>> call optional driver specific callback through it. Something like
>> this:
>>
>> static unsigned int wwan_rtnl_get_num_tx_queues(struct nlattr *tb[])
>> {
>>     const char *devname = nla_data(tb[IFLA_PARENT_DEV_NAME]);
>>     struct wwan_device *wwandev = wwan_dev_get_by_name(devname);
>>
>>     return wwandev && wwandev->ops && wwandev->ops->get_num_tx_queues
>> ?
>>               wwandev->ops->get_num_tx_queues() : 1;
>> }
>>
>> static struct rtnl_link_ops wwan_rtnl_link_ops __read_mostly = {
>>     ...
>>     .get_num_tx_queues = wwan_rtnl_get_num_tx_queues,
>> };
>>
>> This way the default queues number selection will be implemented in a
>> less surprising way.
>>
>> But to be able to implement this we need to modify the RTNL ops
>> .get_num_tx_queues/.get_num_rx_queues callback definitions to make
>> them able to accept the RTM_NEWLINK message attributes. This is not
>> difficult since the callbacks are implemented only by a few virtual
>> devices, but can be assumed too intrusive to implement a one feature
>> for a single subsystem.
>
> Indeed, I had considered this solution provided by you as well:
>
>    static unsigned int wwan_rtnl_get_num_tx_queues(struct nlattr *tb[])
>
>    static struct rtnl_link_ops wwan_rtnl_link_ops __read_mostly = {
>       ...
>       .get_num_tx_queues = wwan_rtnl_get_num_tx_queues,
>    };
>
> I totally agree that it follows the design of RTNL better.
>
> There are some reasons that let me not apply the solution above, I want
> to share them with you. Please correct me if I'm wrong.
>
>    1) in rtnl_create_link, RTNL always prefers to use the number
>    provided by userspace service rather than the number returned by
>    get_num_tx/rx_queues() of WWAN Core:
>
>       if (tb[IFLA_NUM_TX_QUEUES])
>          num_tx_queues = nla_get_u32(tb[IFLA_NUM_TX_QUEUES]);
>       else if (ops->get_num_tx_queues)
>          num_tx_queues = ops->get_num_tx_queues();
>
>    Although WWAN driver could reject the number selected by userspace
>    service in newlink function, this will require userspace service to
>    learn this error and implement its retry machanisms. Of course, even
>    so, that's not bad.

Why do you assume that a userspace service must provide the
IFLA_NUM_TX_QUEUES attribute?

This attribute is optional, see below.

>    I think it's probably better to let WWAN device driver determine
>    its default queue number.

Exactly! If we provide RTNL with a .get_num_tx_queues() callback, then
in case of missed IFLA_NUM_TX_QUEUES attribute, RTNL will select the
number of queues according to the driver decision. And only if
userspace forces the driver to use a particular number of queues using
the IFLA_NUM_TX_QUEUES attribute, then RTNL will try to use a
non-default queues number. In that case, the driver may reject the
creation of such a bearer.

So, with the .get_num_tx_queues() callback we will have a simple
scheme. Either, userspace does not specify the IFLA_NUM_TX_QUEUES
attribute and allows the driver to select an appropriate number of
queues. Or, userspace would like to force a specific number of queues
using the IFLA_NUM_TX_QUEUES attribute, but in that case, the
userspace application should be ready to receive a rejection.

>    2) As you described, above solution will modify the definition and
>    usage of get_num_tx_queues() and get_num_rx_queues() in
>    rtnl_link_ops. Userspace service also needs to add new NETLINK
>    attributes.

What new attributes did you mean?

IFLA_NUM_TX_QUEUES is optional as shown above. The
IFLA_PARENT_DEV_NAME attribute must be provided anyway, otherwise the
WWAN subsystem will not be able to locate a particular driver and the
interface (bearer) creation request will be rejected. Attributes
already are passed to the WWAN subsystem via the .rtnl_alloc()
callback. I suggest to pass the same attributes to the
.get_num_tx_queues() callback that will be called against the same
RTM_NEWLINK message, just slightly earlier.

>    3) WWAN subsystem implements the rtnl_link_ops and plays a role of
>    the bridge between RTNL and WWAN device driver. As a separate
>    subsystem, I think it could be able to supply its own callback
>    functions to WWAN device driver in wwan_ops just as shown in this
>    patch.

Yep, we need a callback to be able to support multi-queue modems. I am
just not happy with a callback that silently tries to improve a user's
choice. And I would like to find a more straightforward solution for
multi-queue support.

>    In addition to these reasons, I also agree with your points:
>       "can be assumed too intrusive to implement a one feature for
>       a single subsystem."

But it looks like we have no choice here other than extending the
.get_num_tx_queues() prototype.

Is there any RTNL guru here who could explain whether it is acceptable
to extend the internal API for a single subsystem?

> Please review my thoughts and give me some inputs at your convenience.
>
>>> Signed-off-by: Xiayu Zhang <Xiayu.Zhang@mediatek.com>
>>> ---
>>>  drivers/net/wwan/wwan_core.c | 25 ++++++++++++++++++++++++-
>>>  include/linux/wwan.h         |  6 ++++++
>>>  2 files changed, 30 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/net/wwan/wwan_core.c
>>> b/drivers/net/wwan/wwan_core.c
>>> index d293ab688044..00095c6987be 100644
>>> --- a/drivers/net/wwan/wwan_core.c
>>> +++ b/drivers/net/wwan/wwan_core.c
>>> @@ -823,6 +823,7 @@ static struct net_device
>>> *wwan_rtnl_alloc(struct nlattr *tb[],
>>>         struct wwan_device *wwandev =
>>> wwan_dev_get_by_name(devname);
>>>         struct net_device *dev;
>>>         unsigned int priv_size;
>>> +       unsigned int num_txqs, num_rxqs;
>>>
>>>         if (IS_ERR(wwandev))
>>>                 return ERR_CAST(wwandev);
>>> @@ -833,9 +834,31 @@ static struct net_device
>>> *wwan_rtnl_alloc(struct nlattr *tb[],
>>>                 goto out;
>>>         }
>>>
>>> +       /* let wwan device driver determine TX queue number if it
>>> wants */
>>> +       if (wwandev->ops->get_num_tx_queues) {
>>> +               num_txqs = wwandev->ops-
>>> >get_num_tx_queues(num_tx_queues);
>>> +               if (num_txqs < 1 || num_txqs > 4096) {
>>> +                       dev = ERR_PTR(-EINVAL);
>>> +                       goto out;
>>> +               }
>>> +       } else {
>>> +               num_txqs = num_tx_queues;
>>> +       }
>>> +
>>> +       /* let wwan device driver determine RX queue number if it
>>> wants */
>>> +       if (wwandev->ops->get_num_rx_queues) {
>>> +               num_rxqs = wwandev->ops-
>>> >get_num_rx_queues(num_rx_queues);
>>> +               if (num_rxqs < 1 || num_rxqs > 4096) {
>>> +                       dev = ERR_PTR(-EINVAL);
>>> +                       goto out;
>>> +               }
>>> +       } else {
>>> +               num_rxqs = num_rx_queues;
>>> +       }
>>> +
>>>         priv_size = sizeof(struct wwan_netdev_priv) + wwandev->ops-
>>> >priv_size;
>>>         dev = alloc_netdev_mqs(priv_size, ifname, name_assign_type,
>>> -                              wwandev->ops->setup, num_tx_queues,
>>> num_rx_queues);
>>> +                              wwandev->ops->setup, num_txqs,
>>> num_rxqs);
>>>
>>>         if (dev) {
>>>                 SET_NETDEV_DEV(dev, &wwandev->dev);
>>> diff --git a/include/linux/wwan.h b/include/linux/wwan.h
>>> index 9fac819f92e3..69c0af7ab6af 100644
>>> --- a/include/linux/wwan.h
>>> +++ b/include/linux/wwan.h
>>> @@ -156,6 +156,10 @@ static inline void *wwan_netdev_drvpriv(struct
>>> net_device *dev)
>>>   * @setup: set up a new netdev
>>>   * @newlink: register the new netdev
>>>   * @dellink: remove the given netdev
>>> + * @get_num_tx_queues: determine number of transmit queues
>>> + *                     to create when creating a new device.
>>> + * @get_num_rx_queues: determine number of receive queues
>>> + *                     to create when creating a new device.
>>>   */
>>>  struct wwan_ops {
>>>         unsigned int priv_size;
>>> @@ -164,6 +168,8 @@ struct wwan_ops {
>>>                        u32 if_id, struct netlink_ext_ack *extack);
>>>         void (*dellink)(void *ctxt, struct net_device *dev,
>>>                         struct list_head *head);
>>> +       unsigned int (*get_num_tx_queues)(unsigned int hint_num);
>>> +       unsigned int (*get_num_rx_queues)(unsigned int hint_num);
>>>  };
>>>
>>>  int wwan_register_ops(struct device *parent, const struct wwan_ops
>>> *ops,

-- 
Sergey
