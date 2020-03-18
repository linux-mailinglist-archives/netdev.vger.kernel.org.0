Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B84D9189AA7
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 12:31:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727804AbgCRLbr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 07:31:47 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:40611 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727217AbgCRLbr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 07:31:47 -0400
Received: by mail-ot1-f65.google.com with SMTP id e19so4021859otj.7;
        Wed, 18 Mar 2020 04:31:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=NjD2GamyBEc3sKrO1F2PZeSZdHhFZ3Ii1Pkm+OVNywQ=;
        b=Da1jSNe6xlZ/GBGCQJZ7qqQIRteleIHOErt7JIc00/AfTtQzZEK0B6IBoRe3w+p1J0
         GZ5cNqkjGNxzSYjCqwjwvEeiCt9fgX2Q4ulDbn2xrpFAqVOahRi9LJO+n+xUxR4qT3kI
         IV5Ojt0xWxy5OXylEWpRqgbUD2dY70GNJJhgk0aHCK9N2aZI6n5g6XiWhUVmS1IftoRG
         cwHw0sJberSdtUyouOMD2eSP3edYAoUxg0TnK33UPw0thLJxPzb/uTPpm4+u+l6Kw3M4
         p1uBpIhLhtchxOg3LF82qKMVd6bTLPZxD0AGxYmw51iHKC8iiLmRqwhCP5616WJnVSJb
         rKeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=NjD2GamyBEc3sKrO1F2PZeSZdHhFZ3Ii1Pkm+OVNywQ=;
        b=abbMLaFsA1XDEvfeteOiyH+kYR8aKzfR1FQp/baQjMb9J38/Q1wKG+HJw3Lp1exb+M
         1Ps5YbK1K8vp1/OKTWvjSgR0riY2+aHrmyN4/4CvGfs1WPpWhdfsAknfBfS7EPUN60M+
         XKnud2YKuYzmKEstTTFDJwxJljY+DYk3LG7Hu1gUbkCrIb/Uf74dtgJqJN0/zNToSObh
         q6uRJk1eLFoKuj8WIjmwV5gDbCqE8Znh56e1P0bVGXnOGPFhx8AFJp3L2qmOWaprk1m1
         pkHvOvDfz/ur7zhRLpFj3xggemPSYnaegw6RNN8PONXoEBiNd6MUkMh8XVX4L+kBpGH5
         hgZg==
X-Gm-Message-State: ANhLgQ1ZeHU9LheteWAyxviHsUPzYTSh8D5TyC3i6Xa0H/kABhXrI34u
        nFXsW06mcw3B0iAMtCabk0AVIXQNtIKGU42v19I=
X-Google-Smtp-Source: ADFU+vtzJZKy3xkB3VSgaCd/spw1j4x/jxGImWuqnB3Bj4i1qWxwbtcjbyCUDiuoi+1rbybTHgsJkXydu4Q/NCLEdno=
X-Received: by 2002:a05:6830:1195:: with SMTP id u21mr3175391otq.351.1584531105983;
 Wed, 18 Mar 2020 04:31:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200316224023.1.I002569822232363cfbb5af1f33a293ea390c24c7@changeid>
 <4DF7C709-1AD3-42FF-A0C2-EF488D82F083@holtmann.org>
In-Reply-To: <4DF7C709-1AD3-42FF-A0C2-EF488D82F083@holtmann.org>
From:   Emil Lenngren <emil.lenngren@gmail.com>
Date:   Wed, 18 Mar 2020 12:31:35 +0100
Message-ID: <CAO1O6sdfdVavo9U0UKewbS9YAjCVzdXDYms-OJZNEJVzMmkgMg@mail.gmail.com>
Subject: Re: [PATCH] Bluetooth: Do not cancel advertising when starting a scan
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Manish Mandlik <mmandlik@google.com>,
        Yoni Shavit <yshavit@chromium.org>,
        Alain Michaud <alainm@chromium.org>,
        Miao-chen Chou <mcchou@chromium.org>,
        Bluez mailing list <linux-bluetooth@vger.kernel.org>,
        Dmitry Grinberg <dmitrygr@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Den ons 18 mars 2020 kl 12:27 skrev Marcel Holtmann <marcel@holtmann.org>:
>
> Hi Manish,
>
> > BlueZ cancels adv when starting a scan, but does not cancel a scan when
> > starting to adv. Neither is required, so this brings both to a
> > consistent state (of not affecting each other). Some very rare (I've
> > never seen one) BT 4.0 chips will fail to do both at once. Even this is
> > ok since the command that will fail will be the second one, and thus th=
e
> > common sense logic of first-come-first-served is preserved for BLE
> > requests.
> >
> > Signed-off-by: Dmitry Grinberg <dmitrygr@google.com>
> > Signed-off-by: Manish Mandlik <mmandlik@google.com>
> > ---
> >
> > net/bluetooth/hci_request.c | 17 -----------------
> > 1 file changed, 17 deletions(-)
>
> patch has been applied to bluetooth-next tree.
>
> If you know the controller that doesn=E2=80=99t support this, can we blac=
klist that one and just disable advertising (peripheral mode) for that cont=
roller.

Can't the "LE Supported States" be inspected instead to figure out
what simultaneous capabilities are supported? It seems a bit rough to
always assume the worst.

/Emil
