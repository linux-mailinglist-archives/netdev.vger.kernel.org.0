Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98D9E482001
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 20:47:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241887AbhL3TrP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 14:47:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239877AbhL3TrO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 14:47:14 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F935C061574;
        Thu, 30 Dec 2021 11:47:14 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id b186-20020a1c1bc3000000b00345734afe78so13831367wmb.0;
        Thu, 30 Dec 2021 11:47:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9E+zrP7P0+1Gwb0tf7x9dP6PIqa2IWVIGU4XRRxI+K8=;
        b=nLhb1zRShxc4VPk1opTaEpmgiNfCZnBFWtxcwHIzp0NR2SlJ6QlXr32WebM396wIGV
         sokK4zo9kdVxx/bpwdAr7bPTK9F1/7lFmWtGuG5BhyXQAV2TV2qhczVjUY6oIoINUxnq
         Av1jcoM9oFZWCMVix+LvvDSXqz0R/pwY9ZIO4WC3QDEUdhmKDNgjQM3Z9eMFIvyz6ouN
         /aSfNM++948qQyJInB/C2DFwr4EH908rfI2bzZHbyz4UYc0xE7zTn25OLZX5kA0TW6Ld
         bZvEBLOR46YqvmDs6uCHOkqhoR65JPOaOXrpxlVi80hITlKqiJ1BeErX9jtTK7Wtc57c
         0sVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9E+zrP7P0+1Gwb0tf7x9dP6PIqa2IWVIGU4XRRxI+K8=;
        b=eGH9BwJxV0WpdHxCGKcHIoOeTax7BKUzemD4UJ1QnfPz4TNJ65Dd54ldtlIxNnQoGP
         /zhyIYTtaBWXnnL+nh2v58WXwdhSMeOZ8eJxDTLYGIqeyQlTwfQUYwe/z5CH4+M531dT
         EY0BhzAXc1ZErxUVddyqQi0wsZoY8KOpq7OyaBpRFT1JdNTbt/TW1h0NQpAd2Hu3EoBX
         Qf18xu3mfIAb+imcP/CGtkAYx9g5vV9WelpUkOOpqjGEoZBSEQ7Ww897LSIfsag/ESul
         str1m5YjIzjMj6k+K2yIwyf2Xkwu0E2RQMWUxEr0S33ljd2cvGDs2lklrEVYwEEDTOHp
         ELww==
X-Gm-Message-State: AOAM530qr/yfEfWwHDaca8JbTvBgTApRvGVIiXkRSl7Ot7Vq9yVYITtj
        zFGIMs+TAJmJ2Gp0P3uU9NafDWj7HtQpSq+KglmjEMacLhs=
X-Google-Smtp-Source: ABdhPJx0yWCvpglN4lGY0EFCBBRZnSh9/PDBHXXzHMAnxEtRXT3U+eosERo4/dgTGVYzNPIt0qGyh7cwAWODG3t/BeQ=
X-Received: by 2002:a05:600c:3797:: with SMTP id o23mr27101199wmr.178.1640893632296;
 Thu, 30 Dec 2021 11:47:12 -0800 (PST)
MIME-Version: 1.0
References: <20211222155743.256280-1-miquel.raynal@bootlin.com>
 <20211222155743.256280-13-miquel.raynal@bootlin.com> <CAB_54W6AZ+LGTcFsQjNx7uq=+R5v_kdF0Xm5kwWQ8ONtfOrmAw@mail.gmail.com>
 <Ycx0mwQcFsmVqWVH@ni.fr.eu.org>
In-Reply-To: <Ycx0mwQcFsmVqWVH@ni.fr.eu.org>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Thu, 30 Dec 2021 14:47:01 -0500
Message-ID: <CAB_54W41ZEoXzoD2_wadfMTY8anv9D9e2T5wRckdXjs7jKTTCA@mail.gmail.com>
Subject: Re: [net-next 12/18] net: mac802154: Handle scan requests
To:     Nicolas Schodet <nico@ni.fr.eu.org>
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, 29 Dec 2021 at 09:45, Nicolas Schodet <nico@ni.fr.eu.org> wrote:
>
> Hi,
>
> * Alexander Aring <alex.aring@gmail.com> [2021-12-29 09:30]:
> > Hi,
> > On Wed, 22 Dec 2021 at 10:58, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > ...
> > > +{
> > > +       bool promiscuous_on = mac802154_check_promiscuous(local);
> > > +       int ret;
> > > +
> > > +       if ((state && promiscuous_on) || (!state && !promiscuous_on))
> > > +               return 0;
> > > +
> > > +       ret = drv_set_promiscuous_mode(local, state);
> > > +       if (ret)
> > > +               pr_err("Failed to %s promiscuous mode for SW scanning",
> > > +                      state ? "set" : "reset");
> > The semantic of promiscuous mode on the driver layer is to turn off
> > ack response, address filtering and crc checking. Some transceivers
> > don't allow a more fine tuning on what to enable/disable. I think we
> > should at least do the checksum checking per software then?
> > Sure there is a possible tune up for more "powerful" transceivers then...
>
> In this case, the driver could change the (flags &
> IEEE802154_HW_RX_DROP_BAD_CKSUM) bit dynamically to signal it does not
> check the checksum anymore. Would it work?

I think that would work, although the intention of the hw->flags is to
define what the hardware is supposed to support as not changing those
values dynamically during runtime so mac will care about it. However
we don't expose those flags to the userspace, so far I know. We can
still introduce two separated flags if necessary in future.

Why do we need promiscuous mode at all? Why is it necessary for a
scan? What of "ack response, address filtering and crc checking" you
want to disable and why?

I see that beacons are sent out with
"local->beacon.mhr.fc.dest_addr_mode = IEEE802154_NO_ADDRESSING;"
shouldn't that be a broadcast destination?

- Alex
