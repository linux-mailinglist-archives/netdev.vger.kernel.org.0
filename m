Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DBE33ADF10
	for <lists+netdev@lfdr.de>; Sun, 20 Jun 2021 16:39:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbhFTOla (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Jun 2021 10:41:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbhFTOl3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Jun 2021 10:41:29 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2D71C061574
        for <netdev@vger.kernel.org>; Sun, 20 Jun 2021 07:39:16 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id u11so17017307oiv.1
        for <netdev@vger.kernel.org>; Sun, 20 Jun 2021 07:39:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IwNqnyd/Ykh6bOiDT0CXdy40Q9aqk/z9iSiOr4BH19I=;
        b=qQOXCKE4F4TZ9ItguT1qnSZ6RtHV/ewvNLU3LnBV4ukEmFL+e/O52BELHX6dymaU+r
         wE8bPepT9IaGOFmgLs1K3MLZr4UhdiHXf8/3FcHKO9ztRBizDHDwFUf7oGx4vaDOcC4L
         PDHC/kbTugbr29WHv2Z5sK73n0CfT+ybMd0trVAaG2Bqaq6ugkBTTVDT8VseTTNJa0iT
         1ogsFp0POstEUSyEmNkWV7/WR/fR+ieUaquCjNdpmZHTL38qtk5HsIv0qDUYxVgT4jY9
         ePddGDklSucC4zqYXMlVs4z/FX4ssbfqNpHfX4K4X4Tn0obKUgxt8P/h3P+UAE8dbiUy
         4fwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IwNqnyd/Ykh6bOiDT0CXdy40Q9aqk/z9iSiOr4BH19I=;
        b=cEMhqKdb6OTTpJLfufqoMESM9ZdziXOpOz6LUUqozJ7I3MPsg3wKLX8VnP45v1xIDJ
         If9XULEHj9k3UG5pktAc5Q4+LbgVC9mYzpmbGYeRsAv7LilODCxPwIArP6FCyUjFATfj
         0Ke/feoaUnD/yHF9YHeCJsLoAXRR6KM+yLI0Bigf+MoowAY1jL3pXu0YpWZTZkOkqfHy
         gUKwUe2YOMPzkEdFOCym+UwqisWoSekZ494DlUdKjJgAcrBVg0p2GVabkC1W6vIXhmRB
         WOiCLoSInbiLLYE+rJFTCwXcyKlAvfvd9XH2Mt2a2r5i4hwZY6DaTWTyB3mpvg7AMYHX
         Og/g==
X-Gm-Message-State: AOAM530eIf+JXVLdcHdC4hS/SdO+pLlgwuI1vy5OI/2ISXMxt3eRlF9N
        7HznU8ykoDbNdttP57sW2YEF/fsxfbFei7FgRU8=
X-Google-Smtp-Source: ABdhPJy26VOZ3tbiU7rklq2NMQOZ6OFYTxah6imo0zja6bCYntwNrk77Y6oehh+IYXPePK0NCEG8OPj0vkVU8E+lI6c=
X-Received: by 2002:aca:4a17:: with SMTP id x23mr13885281oia.146.1624199955353;
 Sun, 20 Jun 2021 07:39:15 -0700 (PDT)
MIME-Version: 1.0
References: <20210615003016.477-1-ryazanov.s.a@gmail.com> <20210615003016.477-11-ryazanov.s.a@gmail.com>
 <CAMZdPi9mSfaYFnAt5Qux7HtCMkE-4KkkGL8i8T3rtxNXekK+Eg@mail.gmail.com>
In-Reply-To: <CAMZdPi9mSfaYFnAt5Qux7HtCMkE-4KkkGL8i8T3rtxNXekK+Eg@mail.gmail.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Sun, 20 Jun 2021 17:39:07 +0300
Message-ID: <CAHNKnsQdWWJ1tAHt4LPS=3jWNSCDcUdQDSrkZ9aakYp-4iaKVw@mail.gmail.com>
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

On Tue, Jun 15, 2021 at 10:24 AM Loic Poulain <loic.poulain@linaro.org> wrote:
> On Tue, 15 Jun 2021 at 02:30, Sergey Ryazanov <ryazanov.s.a@gmail.com> wrote:
>> The WWAN core not only multiplex the netdev configuration data, but
>> process it too, and needs some space to store its private data
>> associated with the netdev. Add a structure to keep common WWAN core
>> data. The structure will be stored inside the netdev private data before
>> WWAN driver private data and have a field to make it easier to access
>> the driver data. Also add a helper function that simplifies drivers
>> access to their data.
>
> Would it be possible to store wwan_netdev_priv at the end of priv data instead?
> That would allow drivers to use the standard netdev_priv without any change.
> And would also simplify forwarding to rmnet (in mhi_net) since rmnet
> uses netdev_priv.

I do not think that mimicking something by one subsystem for another
is generally a good idea. This could look good in a short term, but
finally it will become a headache due to involvement of too many
entities.

IMHO, a suitable approach to share the rmnet library and data
structures among drivers is to make the rmnet interface more generic.

E.g. consider such netdev/rtnl specific function:

static int rmnet_foo_action(struct net_device *dev, ...)
{
    struct rmnet_priv *rmdev = netdev_priv(dev);
    <do a foo action here>
}

It could be split into a wrapper and an actual handler:

int __rmnet_foo_action(struct rmnet_priv *rmdev, ...)
{
    <do a foo action here>
}
EXPORT_GPL(__rmnet_foo_action)

static int rmnet_foo_action(struct net_device *dev, ...)
{
    struct rmnet_priv *rmdev = netdev_priv(dev);
    return __rmnet_foo_action(rmdev, ...)
}

So a call from mhi_net to rmnet could looks like this:

static int mhi_net_foo_action(struct net_device *dev, ...)
{
    struct rmnet_priv *rmdev = wwan_netdev_drvpriv(dev);
    return __rmnet_foo_action(rmdev, ...)
}

In such a way, only the rmnet users know something special, while
other wwan core users and the core itself behave without any
surprises. E.g. any regular wwan core minidriver can access the
link_id field of the wwan common data by calling netdev_priv() without
further calculating the common data offset.

>> At the moment we use the common WWAN private data to store the WWAN data
>> link (channel) id at the time the link is created, and report it back to
>> user using the .fill_info() RTNL callback. This should help the user to
>> be aware which network interface is binded to which WWAN device data
>> channel.
>>
>> Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
>> CC: M Chetan Kumar <m.chetan.kumar@intel.com>
>> CC: Intel Corporation <linuxwwan@intel.com>
>> ---
>>  drivers/net/mhi/net.c                 | 12 +++++------
>>  drivers/net/mhi/proto_mbim.c          |  5 +++--
>>  drivers/net/wwan/iosm/iosm_ipc_wwan.c | 12 +++++------
>>  drivers/net/wwan/wwan_core.c          | 29 ++++++++++++++++++++++++++-
>>  include/linux/wwan.h                  | 18 +++++++++++++++++
>>  5 files changed, 61 insertions(+), 15 deletions(-)

-- 
Sergey
