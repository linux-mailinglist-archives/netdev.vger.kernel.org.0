Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 482E545CC04
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 19:25:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233061AbhKXS2e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 13:28:34 -0500
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:33916
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231941AbhKXS2d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 13:28:33 -0500
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 4BBF140008
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 18:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1637778322;
        bh=FiBsbg3rNgv9RBgRSftE/+knj8L2RF9VUFKzrpkjlWE=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=Yx9zl5f5OjrHztFzknF6WNe/prp2a5EviuyEISZRBYrMQPYq8uD04QEL9SPpo9HLh
         suSxUI4+dV3yZZxNku41ZDVSkkRQNDkGaT0Fvt98wbdb+nC6fRBrafVHsvzgmDx2jo
         G51gFhqOLNYiOEosrhccA5qqxQANpKx2Y0KmKQyPchIono8BD9tmUnKHs2MuVR4JOT
         e+y8y2S/3vsKIaPSD1+WDiPgRhWFqgvJAqxY2p9gRToag1+UaW2VSK5IX5wYQaRvmu
         EMLlF42jGjT3HtPIBrLUCRiKVAHjRa0dLJ8jNdCKD+uStTU9fGZbF0a2RCmtF4yPAF
         fVxj+zfzpId6w==
Received: by mail-io1-f72.google.com with SMTP id w8-20020a0566022c0800b005dc06acea8dso2602737iov.4
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 10:25:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FiBsbg3rNgv9RBgRSftE/+knj8L2RF9VUFKzrpkjlWE=;
        b=GNJC5g5UF6/VJe7fdE02AHx1wXY0oTMzxAJ4EyhiG+WwStx5hdAfxtChavQFtFlgrX
         oKi5wUHdVH111oNxaVpPTR6yR7snnsNveJDuweguCC8ipW31EshnuvIuZwrgN/ojyoik
         j4lk5zN6tb6mRB/7YjLsP45QR/9MkEbu6QYhSp5dFM9ZT0khTKe3NK1DK2KM/4joJrm6
         4QtgRyzHiRqmDlOb10rh4K2Gc2ab9Ca5eE2a+vR+HxsAybsv1dONf14ZbwnEpL9xjR20
         VhJvGUAe4qAEqVABCZkurmKpmnq+NHOnUYoRp+uxENoDvFSKkNh2oknpfpdXreue97P0
         NKSA==
X-Gm-Message-State: AOAM532YVP4+JFc6d4jIilfRVtfw3wQq325WEfXcCoTi/E6bCHG47Psw
        t0q0H6wdoCuxCZg/rura1M5BULoYloP8Up3qPNupXKMLZAvO8e2CNQ27hyHWYD84L/jgGLUzauT
        uQf8CgSo+Q2MqExclkx/s14hc9kvq5xj8HvNyKcHcI+A7zvLWqg==
X-Received: by 2002:a6b:c403:: with SMTP id y3mr16736933ioa.21.1637778321038;
        Wed, 24 Nov 2021 10:25:21 -0800 (PST)
X-Google-Smtp-Source: ABdhPJytRoRpi7QmkJDbKjDDp7gP2+/hd0unHeK1KiJUK/UItYMEDzmoXSFYim8rZopTbG72KNa7tYipGaS9UPoS6wo=
X-Received: by 2002:a6b:c403:: with SMTP id y3mr16736896ioa.21.1637778320830;
 Wed, 24 Nov 2021 10:25:20 -0800 (PST)
MIME-Version: 1.0
References: <20211124081106.1768660-1-frode.nordahl@canonical.com>
 <20211124062048.48652ea4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAKpbOATgFseXtkWoTcs6bNsvP_4WXChv5ffvtd2+8uqTHmr26w@mail.gmail.com> <20211124094023.68010e87@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211124094023.68010e87@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Frode Nordahl <frode.nordahl@canonical.com>
Date:   Wed, 24 Nov 2021 19:25:10 +0100
Message-ID: <CAKpbOASJBgx74VFFhMe_+MNMd0OjwjcdKRfVuiFQyBmP4ao0dw@mail.gmail.com>
Subject: Re: [PATCH net] netdevsim: Fix physical port index
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(Apologies for any duplicates, my mailer somehow introduced HTML parts
which the ML does not like, resending to fix that).

On Wed, Nov 24, 2021 at 6:40 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 24 Nov 2021 17:24:16 +0100 Frode Nordahl wrote:
> > I don't care too much about the ID itself starting at 0 per se, but I
> > would expect the ID's provided through devlink-port to match between
> > the value specified for DEVLINK_ATTR_PORT_PCI_PF_NUMBER on the
> > simulated PCI_VF flavoured ports, the value specified for
> > DEVLINK_ATTR_PORT_NUMBER on the simulated physical ports and the value
> > specified for DEVLINK_ATTR_PORT_PCI_PF_NUMBER  on the simulated PCI_PF
> > flavoured ports.
> >
> > For a user space application running on a host with a regular
> > devlink-enabled NIC (let's say a ConnectX-5), it can figure out the
> > relationship between the ports with the regular sysfs API.
> >
> > However, for a user space application running on the Arm cores of a
> > devlink-enabled SmartNIC with control plane CPUs (let's say a
> > BlueField2), the relationship between the representor ports is not
> > exposed in the regular sysfs API. So this is where the devlink-port
> > interface becomes important. From a PHYSICAL representor I need to
> > find which PF representors are associated, from there I need to find
> > VF representors associated, and the other way round.
>
> I see, thanks for this explanation.
>
> There is no fundamental association between physical port and PF in
> NICs in switchdev mode. Neither does the bare metal host have any
> business knowing anything about physical ports (including the number
> of them).

For systems where the NICs are connected to multiple CPUs I have not
seen information about the physical ports exposed to the bare metal
host.

I assume there is an association between the PF and VF ports from devlink POV?

> Obviously that's the theory, vendors like to abuse the APIs and cause
> all sort of.. fun.

The need to associate PF with physical comes from this kind of thing.

In recent kernels the bare metal host PF MAC is exposed through
devlink to the SmartNIC CPU PF representor. However for SmartNIC CPUs
running older kernels this is not available, and some vendors have
provided an interim sysfs interface relative to the physical port
netdev.

So to deal with this the fallback support would need to guess the
association, and we'll just have to hope for recent kernels getting
into the wild sooner.

-- 
Frode Nordahl
