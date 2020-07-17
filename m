Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC1AE223C2A
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 15:18:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbgGQNSE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 09:18:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726256AbgGQNSD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 09:18:03 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA577C061755
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 06:18:02 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id s9so12557788ljm.11
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 06:18:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=YM/u3gjvM4q2JWx7UhekKDRsr2AbTo4qfrXy3xVIS9k=;
        b=sf/T5sXRhkN8YEk+EOhFcH7el1N/kDRdyYraixUm9LORleyvBRdP8ykec29CpkXDZ0
         XdWo4qDS1Eb3DhdzVwzo3n7xUQVm7CNj//prYhxniDyOhmZgnDxQq2loH/Q1zmNqNpw1
         lB8Qmjes7B8dWb1K+U5rZm9CwsCECVIpnOt3TWQ8DL4f4muqq9Bsc8cf06KfSeuQYX50
         2IbpMhKO+GSpgked7oB5bNy8GmbF/7mxtbN+DMyEhnj92oIcfQPJ53kNUUSYjZMYWn8V
         FX0kTIWd/AuJ37dNa7Ivap7Qnqg8eIGtZoFy5rLiFsUVU4H+aiD9jnatv4aor2jp97pk
         MGKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=YM/u3gjvM4q2JWx7UhekKDRsr2AbTo4qfrXy3xVIS9k=;
        b=h9Ks6ZqtFTswwR7bzphJU6Zy+rIkyYbZtGxfjf9LVU4ORMj00UnLMwSb/+9FqGn/OG
         28mBJAbw3UJW8Z/c9QfB8hV0IYpbB86BgHaGmuoOR4Ne79KYvK3TVap3lDnRBKsfEhaY
         S7GSaZ3YwU96j9nVLuI3//I/9pKFufSv3sy9I2GWpvcMcZrHuHmpkqoaoMg9lm0hsYQ/
         rACdA8Xa6dnh12FWq0XGmvGG2daQB7trFVPAVocpgoR/RgR+h1Rd5J4XG4ipH3sjAwUb
         7YwOnaAtJU9pZOcGwJRhNlDc9wuFxVXF8h21TEpESKckHmphec/p+JmNQG+DGbTJ3aEa
         CAPw==
X-Gm-Message-State: AOAM5324lCyjTbnAT78KWla/7WEiklaF3VbsjpAlZqDl7YO9ZK2UsDJ+
        mjNWjj2HaKumVHVgmM0iF8KDDV4gHdl0MTZrG3XDIw==
X-Google-Smtp-Source: ABdhPJzyiKZ2NKZx86wa+HGnmDvLl67Vrz1HhWzCdoYhwu2nhGboSac3BbZ6dVMwxJ5PgjdsgB9Ac7A5V093fgDDewk=
X-Received: by 2002:a2e:910c:: with SMTP id m12mr4340344ljg.274.1594991881148;
 Fri, 17 Jul 2020 06:18:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200627105437.453053-1-apusaka@google.com> <20200627185320.RFC.v1.1.Icea550bb064a24b89f2217cf19e35b4480a31afd@changeid>
 <91CFE951-262A-4E83-8550-25445AE84B5A@holtmann.org> <CAJQfnxFSfbUbPLVC-be41TqNXzr_6hLq2z=u521HL+BqxLHn_Q@mail.gmail.com>
 <7BBB55E0-FBD9-40C0-80D9-D5E7FC9F80D2@holtmann.org> <CALWDO_Vrn_pXMbkXifKFazha7BYPqLpCthqHOb9ZmVE3wDRMfA@mail.gmail.com>
 <F17D321B-DCD2-4A80-97EE-B4589FBFF406@holtmann.org>
In-Reply-To: <F17D321B-DCD2-4A80-97EE-B4589FBFF406@holtmann.org>
From:   Alain Michaud <alainmichaud@google.com>
Date:   Fri, 17 Jul 2020 09:17:49 -0400
Message-ID: <CALWDO_WHZppfGoUNZbNoH0ACCUfOhwYtNXRpH+pvsAx5bGVNqA@mail.gmail.com>
Subject: Re: [RFC PATCH v1 1/2] Bluetooth: queue ACL packets if no handle is found
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Archie Pusaka <apusaka@google.com>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        chromeos-bluetooth-upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        kernel list <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marcel,

On Fri, Jul 17, 2020 at 2:51 AM Marcel Holtmann <marcel@holtmann.org> wrote=
:
>
> Hi Alain,
>
> > >>> There is a possibility that an ACL packet is received before we
> > >>> receive the HCI connect event for the corresponding handle. If this
> > >>> happens, we discard the ACL packet.
> > >>>
> > >>> Rather than just ignoring them, this patch provides a queue for
> > >>> incoming ACL packet without a handle. The queue is processed when
> > >>> receiving a HCI connection event. If 2 seconds elapsed without
> > >>> receiving the HCI connection event, assume something bad happened
> > >>> and discard the queued packet.
> > >>>
> > >>> Signed-off-by: Archie Pusaka <apusaka@chromium.org>
> > >>> Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> > >>
> > >> so two things up front. I want to hide this behind a HCI_QUIRK_OUT_O=
F_ORDER_ACL that a transport driver has to set first. Frankly if this kind =
of out-of-order happens on UART or SDIO transports, then something is obvio=
usly going wrong. I have no plan to fix up after a fully serialized transpo=
rt.
> > >>
> > >> Secondly, if a transport sets HCI_QUIRK_OUT_OF_ORDER_ACL, then I wan=
t this off by default. You can enable it via an experimental setting. The r=
eason here is that we have to make it really hard and fail as often as poss=
ible so that hardware manufactures and spec writers realize that something =
is fundamentally broken here.
> > I don't have any objection to making this explicit enable to non serial=
ized transports.  However, I do wonder what the intention is around making =
this off by default.  We already know there is a race condition between the=
 interupt and bulk endpoints over USB, so this can and does happen.  Hardwa=
re manufaturers can't relly do much about this other than trying to pull th=
e interupt endpoint more often, but that's only a workaround, it can't avoi=
d it all together.
> >
> > IMO, this seems like a legitimate fix at the host level and I don't see=
 any obvious benefits to hide this fix under an experimental feature and ma=
ke it more difficult for the customers and system integrators to discover.
>
> the problem is that this is not a fix. It is papering over a hole and at =
best a workaround with both eyes closed and hoping for the best. I am not l=
ooking forward for the first security researcher to figure out that they ha=
ve a chance to inject an unencrypted packet since we are waiting 2 seconds =
for the USB transport to get its act together.
I don't think this is the right characterization but I agree, 2
seconds would be too long, it would ideally be no longer than the USB
polling interval diff.

>
> In addition, I think that Luiz attempt to align with the poll intervals i=
nside the USB transport directly is a cleaner and more self-contained appro=
ach. It also reduces the window of opportunity for any attacker since we ac=
tually align the USB transport specific intervals with each other.
I'll have to look at Luiz's patch and think through if this really
eliminates the problem.  If may indeed be a more practical approach to
this problem.

>
> Regards
>
> Marcel
>
