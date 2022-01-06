Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E267485D49
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 01:38:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343871AbiAFAi2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 19:38:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343858AbiAFAiZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 19:38:25 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16757C061245;
        Wed,  5 Jan 2022 16:38:25 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id h23so1584813wrc.1;
        Wed, 05 Jan 2022 16:38:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6oWGncUTdb/LGs3ySkcNJ1+7l0wPkYWMZXRxkONbwWM=;
        b=WOcmcZQ91NLeY8r5Xhe7La5t9fA6IBVHUZjZjWnXFjUybWMbPDrXV5FkANWgkzc+xY
         ErGRAcorpy3a4lkic8lw3HBIYltHiJbGGFTOzM9X8n2mDHW+DvurG6MVBJf4nhyQVEwn
         W2VPWW7Kfp9Qc+9d75nkMhx0fwWVDo/dlzNbbNh2SOgwr4cmZzIhOr5IbFBVe9uQWKoZ
         NXLr0QrU48jggfCxKuubg0aqNcQEIKjdNTvAPwIZn21lw+43aS8rJmqbRs0m1floyPfc
         QRBvHnRMBj92FSD5Fm+xVNiq787IGqrJxZmbGdDHxeaLgn3LwHiT8rqPD5TKOxgR3aA6
         Cbeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6oWGncUTdb/LGs3ySkcNJ1+7l0wPkYWMZXRxkONbwWM=;
        b=xFD4G1Ej9nPVRZolAw7fN4zvWsuXR+8GiggheRmlrM7IO9h8ug6R+3t3+1AzPvFmdl
         6150dDD1Lx/FTrb2j77pElkhKwlkJBvQuZ/f+hQX20atwfdCxmVwJ4gx4ReXEbgue0Nh
         hpzZ0JmWGCFLyUmkje0E/xxjJObFgS7VU+cfZ+5TnD7NkoEF+VaQo4aeJa/skFJm7cpC
         6w6ZKrIVhdkv8OIJ40LzIguHaK1suxyPEyBciMZkO5XTWGef8uqEQoEeQN2jLYtkl7FE
         Wwcu+joqN7g+RsiJg4bv65juk5HCGhazP/KL+LtjZHPEiborUWTbcmV2SlaTBi2nixdG
         PQqw==
X-Gm-Message-State: AOAM5334RWcPaDrTDJzEFR4LgojUOIVKbh7U+9UsiJTI1M+PJ26eTbos
        kzmwiZ0yVSXM5mF3+qO4JaJhJCC8DxPXYRofpZI=
X-Google-Smtp-Source: ABdhPJzYbthJEutPB8xzcTHiFt+sX1/4exTSZodjSsLHUirlJq6K8CsOg/GZBpWxBgw4QPzFTX6wwo1Oq4+v0Pfx93w=
X-Received: by 2002:adf:d1c2:: with SMTP id b2mr49224826wrd.81.1641429503747;
 Wed, 05 Jan 2022 16:38:23 -0800 (PST)
MIME-Version: 1.0
References: <20211222155743.256280-1-miquel.raynal@bootlin.com>
 <20211222155743.256280-13-miquel.raynal@bootlin.com> <CAB_54W6AZ+LGTcFsQjNx7uq=+R5v_kdF0Xm5kwWQ8ONtfOrmAw@mail.gmail.com>
 <Ycx0mwQcFsmVqWVH@ni.fr.eu.org> <CAB_54W41ZEoXzoD2_wadfMTY8anv9D9e2T5wRckdXjs7jKTTCA@mail.gmail.com>
 <CAB_54W6gHE1S9Q+-SVbrnAWPxBxnvf54XVTCmddtj8g-bZzMRA@mail.gmail.com>
 <20220104191802.2323e44a@xps13> <CAB_54W5quZz8rVrbdx+cotTRZZpJ4ouRDZkxeW6S1L775Si=cw@mail.gmail.com>
 <20220105215551.1693eba4@xps13>
In-Reply-To: <20220105215551.1693eba4@xps13>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Wed, 5 Jan 2022 19:38:12 -0500
Message-ID: <CAB_54W7zDXfybMZZo8QPwRCxX8-BbkQdznwEkLEWeW+E3k2dNg@mail.gmail.com>
Subject: Re: [net-next 12/18] net: mac802154: Handle scan requests
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>
Cc:     Nicolas Schodet <nico@ni.fr.eu.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
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


On Wed, 5 Jan 2022 at 15:55, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
...
> > rest in software is a bigger task here...
>
> On the symbol duration side I feel I'm close to a working PoC.
>

oh, ok.

> So there is 'only' this item left in my mind. Could you please clarify
> what you expect from me exactly in terms of support for the promiscuous
> filters we discussed so far?
>

I think for now it's okay to set the device into promiscuous mode and
enable the flag which checks for bad FCS... we can still implement the
filter modes later (and I think it should work on all supported
transceivers (except that SoftMAC/HardMAC thing)).

One point to promiscuous mode, currently we have a checking for if a
phy is in promiscuous mode on ifup and it would forbid to ifup a node
interface if the phy is in promiscuous mode (because of the missing
automatic acknowledgement). I see there is a need to turn the phy into
promiscuous mode during runtime... so we need somehow make sure the
constraints are still valid here. Maybe we even forbid multiple devs
on a phy if the transceiver/driver/firmware is poor and this is
currently all transceivers (except hwsim? But that doesn't use any ack
handling anyway).

> Also, just for the record,
> - should I keep copying the netdev list for v2?

yes, why not.

> - should I monitor if net-next is open before sending or do you have
>   your own set of rules?
>

I need to admit, Stefan is the "Thanks, applied." hero here and he
should answer this question.

- Alex
