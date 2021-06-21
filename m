Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7843D3AE694
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 11:55:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230384AbhFUJ5T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 05:57:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbhFUJ5S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 05:57:18 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67600C061574
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 02:55:04 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id f3-20020a0568301c23b029044ce5da4794so10528355ote.11
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 02:55:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9jRYxRF7l0ebEmzgmjZ4vOOY1PxIkCQ3c7rdjrzUlgQ=;
        b=qluFhd+jUM8Xvz5k2bbfDkjigslJLoL/aPok/CcN09S6why+QVAzHRQtjQJSCO6HM3
         zXPaGEqco452ssJs9EyFdn8v05itT1Rj7GZJhKq4SSqTsZ/KOKC7iJxG8ZS0JNo1aqys
         pQHYmiIZhitiW4SDl8uSQLOA9ckdn9vEpPwra+EZhilkUphT52hW1ZNOccKDQSv1WUq2
         x6GGylh6lLOkc6AbglDTtK+LOAsAyyE0+Bmcn9OQigb6sJ4+ubP+3ez6ZMRElgackrop
         qcgaLSpT8D+FZ5G53GkISEfDehs7yhy+77PuV1rn+GkjWmsA5UxL1VgfLCyJsRoV+JdL
         KyqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9jRYxRF7l0ebEmzgmjZ4vOOY1PxIkCQ3c7rdjrzUlgQ=;
        b=Z2myIjngEHzim6FjisDbl5DkpWmQFAbeKJjoPy+O7rhAp7D+yhmmufHUm2VhdEy/p0
         +ADro1P/Reu6S5Vy5KQOdhU3j4wFnOI5KmdSXaq2Pf5+7XDsjNWj0CJES/3gdsR3/ipA
         dgErrvXNHLj8a9pUKjEWG/7YZmi38qaSENJi+fLmis2dw7vN2pIv1LHUGTNIfKYtbxpW
         y3FKcxppHvdRPxvcpcLr3ucC96u/Ww8nY07rIkvckCYOFRYHGfSYRqHiMTVZqmrZIq3q
         vnMvgwmotJ5s2fyUBejJqH8Soo9AGHWCumxWVoLopzCANy9N+/xF+vAOooi3s2/dhxwF
         YvaA==
X-Gm-Message-State: AOAM530PeR9w4w12Q4mqqxj0sOo4gAo3skbHdTEmYAt2uwX1KR6K2eWz
        AcMr1H/CIELmWP2Cq2n4K0lyz0NBAy89+oYMTYw=
X-Google-Smtp-Source: ABdhPJwJoC1OpgnVlaayiZsreKIhI00KAy3Os1i6uv+67shcUMy2TybmKQS+GHEDoWD+ffBHha/8apZMaFi6S8L36+8=
X-Received: by 2002:a05:6830:1f0a:: with SMTP id u10mr20308607otg.181.1624269303816;
 Mon, 21 Jun 2021 02:55:03 -0700 (PDT)
MIME-Version: 1.0
References: <20210615003016.477-1-ryazanov.s.a@gmail.com> <20210615003016.477-10-ryazanov.s.a@gmail.com>
 <CAMZdPi-C+Yhf27+-7Ct-1pkp0htrr6Qbt=Om2KQk+5aVVFPRMQ@mail.gmail.com>
 <CAHNKnsRDuf=zuqeAMJgZ5kW6Kd1GsOd6-v5AX4ScCt7_muJp6g@mail.gmail.com> <CAMZdPi_-4tWfo-adLPJvbR5deAD1HsO6XYKSpdHOSs9t-6X1CQ@mail.gmail.com>
In-Reply-To: <CAMZdPi_-4tWfo-adLPJvbR5deAD1HsO6XYKSpdHOSs9t-6X1CQ@mail.gmail.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Mon, 21 Jun 2021 12:54:56 +0300
Message-ID: <CAHNKnsQ8ciMMD-8oGaRgJ-WjQYvc7hNU2Zt2AyMF72qzJ9Qf3A@mail.gmail.com>
Subject: Re: [PATCH net-next 09/10] net: mhi_net: create default link via WWAN core
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        Aleksander Morgado <aleksander@aleksander.es>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Loic,

On Mon, Jun 21, 2021 at 9:44 AM Loic Poulain <loic.poulain@linaro.org> wrote:
> On Sun, 20 Jun 2021 at 15:51, Sergey Ryazanov <ryazanov.s.a@gmail.com> wrote:
>> On Tue, Jun 15, 2021 at 10:08 AM Loic Poulain <loic.poulain@linaro.org> wrote:
>>> On Tue, 15 Jun 2021 at 02:30, Sergey Ryazanov <ryazanov.s.a@gmail.com> wrote:
>>>> Utilize the just introduced WWAN core feature to create a default netdev
>>>> for the default data channel. Since the netdev is now created via the
>>>> WWAN core, rely on it ability to destroy all child netdevs on ops
>>>> unregistering.
>>>>
>>>> While at it, remove the RTNL lock acquiring hacks that were earlier used
>>>> to call addlink/dellink without holding the RTNL lock. Also make the
>>>> WWAN netdev ops structure static to make sparse happy.
>>>>
>>>> Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
>>>> ---
>>>>  drivers/net/mhi/net.c | 54 +++++--------------------------------------
>>>>  1 file changed, 6 insertions(+), 48 deletions(-)
>>>>
>>>> diff --git a/drivers/net/mhi/net.c b/drivers/net/mhi/net.c
>>>> index b003003cbd42..06253acecaa2 100644
>>>> --- a/drivers/net/mhi/net.c
>>>> +++ b/drivers/net/mhi/net.c
>>>> @@ -342,10 +342,7 @@ static int mhi_net_newlink(void *ctxt, struct net_device *ndev, u32 if_id,
>>>>         /* Number of transfer descriptors determines size of the queue */
>>>>         mhi_netdev->rx_queue_sz = mhi_get_free_desc_count(mhi_dev, DMA_FROM_DEVICE);
>>>>
>>>> -       if (extack)
>>>> -               err = register_netdevice(ndev);
>>>> -       else
>>>> -               err = register_netdev(ndev);
>>>> +       err = register_netdevice(ndev);
>>>>         if (err)
>>>>                 goto out_err;
>>>>
>>>> @@ -370,10 +367,7 @@ static void mhi_net_dellink(void *ctxt, struct net_device *ndev,
>>>>         struct mhi_net_dev *mhi_netdev = netdev_priv(ndev);
>>>>         struct mhi_device *mhi_dev = ctxt;
>>>>
>>>> -       if (head)
>>>> -               unregister_netdevice_queue(ndev, head);
>>>> -       else
>>>> -               unregister_netdev(ndev);
>>>> +       unregister_netdevice_queue(ndev, head);
>>>>
>>>>         mhi_unprepare_from_transfer(mhi_dev);
>>>>
>>>> @@ -382,7 +376,7 @@ static void mhi_net_dellink(void *ctxt, struct net_device *ndev,
>>>>         dev_set_drvdata(&mhi_dev->dev, NULL);
>>>>  }
>>>>
>>>> -const struct wwan_ops mhi_wwan_ops = {
>>>> +static const struct wwan_ops mhi_wwan_ops = {
>>>>         .priv_size = sizeof(struct mhi_net_dev),
>>>>         .setup = mhi_net_setup,
>>>>         .newlink = mhi_net_newlink,
>>>> @@ -392,55 +386,19 @@ const struct wwan_ops mhi_wwan_ops = {
>>>>  static int mhi_net_probe(struct mhi_device *mhi_dev,
>>>>                          const struct mhi_device_id *id)
>>>>  {
>>>> -       const struct mhi_device_info *info = (struct mhi_device_info *)id->driver_data;
>>>>         struct mhi_controller *cntrl = mhi_dev->mhi_cntrl;
>>>> -       struct net_device *ndev;
>>>> -       int err;
>>>> -
>>>> -       err = wwan_register_ops(&cntrl->mhi_dev->dev, &mhi_wwan_ops, mhi_dev,
>>>> -                               WWAN_NO_DEFAULT_LINK);
>>>> -       if (err)
>>>> -               return err;
>>>> -
>>>> -       if (!create_default_iface)
>>>> -               return 0;
>>>> -
>>>> -       /* Create a default interface which is used as either RMNET real-dev,
>>>> -        * MBIM link 0 or ip link 0)
>>>> -        */
>>>> -       ndev = alloc_netdev(sizeof(struct mhi_net_dev), info->netname,
>>>> -                           NET_NAME_PREDICTABLE, mhi_net_setup);
>>>
>>> I like the idea of the default link, but here we need to create the
>>> netdev manually for several reasons:
>>> - In case of QMAP/rmnet, this link is the lower netdev (transport
>>> layer) and is not associated with any link id.
>>> - In case of MBIM, it changes the netdev parent device from the MHI
>>> dev to the WWAN dev, which (currently) breaks how ModemManager groups
>>> ports/netdevs (based on bus).
>>>
>>> For the last one, I don't think device hierarchy is considered as
>>> UAPI, so we probably just need to add this new wwan link support to
>>> user tools like MM. For the first one, I plan to split the mhi_net
>>> driver into two different ones (mhi_net_qmap, mhi_net_mbim), and in
>>> the case of qmap(rmnet) forward newlink/dellink call to rmnet
>>> rtnetlink ops.
>>
>> Looks like I missed the complexity of WWAN devices handling. Thank you
>> for pointing that out. Now I will drop this patch from the series.
>>
>> Just curious, am I right to say that any network interface created
>> with wwan-core is not usable with ModemManager at the moment? AFAIU,
>> ModemManager is unable to bundle a control port and a netdev into a
>> common "modem" object, even if they both have the same parent Linux
>> device, just because that device is not a physical USB device.
>
> Right, there is an ongoing discussion about supporting iosm:
> https://gitlab.freedesktop.org/mobile-broadband/ModemManager/-/issues/385#note_958408
>
> So once we have it working for iosm, it should work for any WWAN
> device using WWAN framework.

Thank you for the clarification, I will keep in mind.

-- 
Sergey
