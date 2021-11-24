Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C55E545C9EC
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 17:24:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348622AbhKXQ1k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 11:27:40 -0500
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:57020
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348560AbhKXQ1j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 11:27:39 -0500
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id E5BB73F1AC
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 16:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1637771068;
        bh=y0GxaekRxlT1GH7W0x5dhv1FzocYU7kMd3WVl7XoIT0=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=cmemvAWudQ8FX1gWWL7HLlr00K56TFsx2Wm6x5J/OSph4LmmL4W1U1t3h4ULyvriG
         amO38ojcidDSxNjqS7JK97nnw3/ZxeLr89kme3DVug6Yg/DpV6/wKM1iCa1OzIu7Wj
         4m6i+hu2ZcHR8uB2S0yvrbJESj7hNkFCo2LTunyCrDwyC6oP2eWmyowC5tOoYObWA/
         LCxquN4Bg9l6I/y418gKqx9fYGWuRW/sYhmWU9gcwRr11rDpz282DbpBXcmS8iH3NP
         yY7ClaDLdVFhuzwaRvV1Pck0Ad41YzCl7ypV1PuDFoqPJVTP6V4glnbi2iU5bTksfx
         bv6zGUL+777Xw==
Received: by mail-io1-f70.google.com with SMTP id x11-20020a0566022c4b00b005e702603028so2286269iov.2
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 08:24:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=y0GxaekRxlT1GH7W0x5dhv1FzocYU7kMd3WVl7XoIT0=;
        b=wCmOv1NzsQeRRhUK98EsW7W0Uym4yFGQ+ynz9HT26vtp8Ea4FwUCl/6Lrdi1XKMEPj
         lgn01kC/UFiRslWUNL3jHYhHC30wNiB0M2r8c7WlNToWefdFo59a952gP/rEZI51FBiV
         tM+R7yoppNzGK8s/RPoLSR0iJ6cLa3tUJy4DQSZUzOEMcT9IXIje8DT6aaeETzZc/9BB
         CaOQlIZu0CAKeS7HHU42WYBNXKJcPCcUjCWtWj0XW2N47EzodSFi5U3DAHQcU+JbW6Qv
         MZdOhXaD7P+9UY71/nOGJyBb6OYX9TloRkajck6k1I5m1TZo+1xJKspXMqcxR7Alm11W
         YjBA==
X-Gm-Message-State: AOAM531ePfREdV5BlD74Wd2UxgasUPVdLh+93fAQAF7uN4sFLu+vWqLG
        MoIjO5s3Nkv9CxwP+jMVXMLYaR9qO4dxL5cQ5KVzvYff2xKCbZDZeg/THFJwaF0yced57rhtl8O
        rxU40fQjJkTgRht6eM8YQZs2OARaeh3gYVGTbKr5jo8MZ0Hjb5w==
X-Received: by 2002:a92:c268:: with SMTP id h8mr6279682ild.298.1637771067743;
        Wed, 24 Nov 2021 08:24:27 -0800 (PST)
X-Google-Smtp-Source: ABdhPJycYT2GK6632IDlDgkcfV5KjIXe528Ko8euO6xeqOq0rBRJ9RH5L1fbgSwLdQ5ggJfkv3ribt3HgBOj1bJ3mwQ=
X-Received: by 2002:a92:c268:: with SMTP id h8mr6279657ild.298.1637771067521;
 Wed, 24 Nov 2021 08:24:27 -0800 (PST)
MIME-Version: 1.0
References: <20211124081106.1768660-1-frode.nordahl@canonical.com> <20211124062048.48652ea4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211124062048.48652ea4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Frode Nordahl <frode.nordahl@canonical.com>
Date:   Wed, 24 Nov 2021 17:24:16 +0100
Message-ID: <CAKpbOATgFseXtkWoTcs6bNsvP_4WXChv5ffvtd2+8uqTHmr26w@mail.gmail.com>
Subject: Re: [PATCH net] netdevsim: Fix physical port index
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 24, 2021 at 3:20 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 24 Nov 2021 09:11:06 +0100 Frode Nordahl wrote:
> > At present when a netdevsim device is added, the first physical
> > port will have an index of 1.  This behavior differ from what any
> > real hardware driver would do, which would start the index at 0.
> >
> > When using netdevsim to test the devlink-port interface this
> > behavior becomes a problem because the provided data is incorrect.
> >
> > Example:
> > $ sudo modprobe netdevsim
> > $ sudo sh -c 'echo "10 1" > /sys/bus/netdevsim/new_device'
> > $ sudo sh -c 'echo 4 > /sys/class/net/eni10np1/device/sriov_numvfs'
> > $ sudo devlink dev eswitch set netdevsim/netdevsim10 mode switchdev
> > $ devlink port show
> > netdevsim/netdevsim10/0: type eth netdev eni10np1 flavour physical port 1
> > netdevsim/netdevsim10/128: type eth netdev eni10npf0vf0 flavour pcivf pfnum 0 vfnum 0
> > netdevsim/netdevsim10/129: type eth netdev eni10npf0vf1 flavour pcivf pfnum 0 vfnum 1
> > netdevsim/netdevsim10/130: type eth netdev eni10npf0vf2 flavour pcivf pfnum 0 vfnum 2
> > netdevsim/netdevsim10/131: type eth netdev eni10npf0vf3 flavour pcivf pfnum 0 vfnum 3
> >
> > With this patch applied you would instead get:
> > $ sudo modprobe netdevsim
> > $ sudo sh -c 'echo "10 1" > /sys/bus/netdevsim/new_device'
> > $ sudo sh -c 'echo 4 > /sys/class/net/eni10np0/device/sriov_numvfs'
> > $ sudo devlink dev eswitch set netdevsim/netdevsim10 mode switchdev
> > $ devlink port show
> > netdevsim/netdevsim10/0: type eth netdev eni10np0 flavour physical port 0
> > netdevsim/netdevsim10/128: type eth netdev eni10npf0vf0 flavour pcivf pfnum 0 vfnum 0
> > netdevsim/netdevsim10/129: type eth netdev eni10npf0vf1 flavour pcivf pfnum 0 vfnum 1
> > netdevsim/netdevsim10/130: type eth netdev eni10npf0vf2 flavour pcivf pfnum 0 vfnum 2
> > netdevsim/netdevsim10/131: type eth netdev eni10npf0vf3 flavour pcivf pfnum 0 vfnum 3
> >
> > The above more accurately resembles what a real system would look
> > like.
> >
> > Fixes: 8320d1459127 ("netdevsim: implement dev probe/remove skeleton with port initialization")
> > Signed-off-by: Frode Nordahl <frode.nordahl@canonical.com>
>
> Why do you care about the port ID starting at 0? It's not guaranteed.
> The device can use any encoding scheme to assign IDs, user space should
> make no assumptions here.

I don't care too much about the ID itself starting at 0 per se, but I
would expect the ID's provided through devlink-port to match between
the value specified for DEVLINK_ATTR_PORT_PCI_PF_NUMBER on the
simulated PCI_VF flavoured ports, the value specified for
DEVLINK_ATTR_PORT_NUMBER on the simulated physical ports and the value
specified for DEVLINK_ATTR_PORT_PCI_PF_NUMBER  on the simulated PCI_PF
flavoured ports.

For a user space application running on a host with a regular
devlink-enabled NIC (let's say a ConnectX-5), it can figure out the
relationship between the ports with the regular sysfs API.

However, for a user space application running on the Arm cores of a
devlink-enabled SmartNIC with control plane CPUs (let's say a
BlueField2), the relationship between the representor ports is not
exposed in the regular sysfs API. So this is where the devlink-port
interface becomes important. From a PHYSICAL representor I need to
find which PF representors are associated, from there I need to find
VF representors associated, and the other way round.

> Please use get_maintainers to CC all the relevant people.

Thank you for pointing that out. Apologies for skipping that step,
added the missing ones now.

-- 
Frode Nordahl
