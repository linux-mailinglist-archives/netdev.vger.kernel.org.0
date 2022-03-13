Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37A824D7836
	for <lists+netdev@lfdr.de>; Sun, 13 Mar 2022 21:44:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235574AbiCMUpP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Mar 2022 16:45:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbiCMUpO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Mar 2022 16:45:14 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A301A17061;
        Sun, 13 Mar 2022 13:44:05 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id h14so23809126lfk.11;
        Sun, 13 Mar 2022 13:44:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=10NJX5WEPZhAbw38QlaBhRLwrw0zlgt8u1rSp6vim3c=;
        b=hIqFsjMZ7GAYY0cKldKhaMwlr68shtyELE9Nw15HAcr4D9wW3B3CzCVtx/FHBLG1DZ
         Cx+4pyV7tXqH/46vP7wzOWut2JP9PvA0DvmhZ0q5kxkjgCD8jXQeq1EPGtybntQeuRgz
         MPqGzo1gvQiWcLd3gqfzFGdym4v4EiUwX20liLDkRAoQKxMfhOzw8M2ysODuE/gIMPPj
         +oJUEP6hwaXDLO3TSUDZSgAQj0jPMT7IDsH/5MrLtMjGpcKy6pGADCNsFSv1xiioNtBM
         C8dT+V/kVAP8AuMOSxfenuRSXvhAez8FMQZIVbUoiFg2akPaSfJRhtTvdVGgJW0C1vG8
         Y3mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=10NJX5WEPZhAbw38QlaBhRLwrw0zlgt8u1rSp6vim3c=;
        b=potcgTD2X1KFhTEfh/QWP2r0QDZFzk1UJ6N/Jo4gvKM65W3a24SMInRZmTDztVdvLX
         nQ0Sl4ly99smXmb3t6i3ZzALKcnz9EAqRzHH4hT/PZV9UsS9klk7n8e1/rYk3jdDus04
         64yBdpjSc//ZzQtAc8SmMPodaleVfcivDuzXZ3QgaNsyps6BgWffhBiMwDr/92/qfp/v
         QxRg9NHqH92yepIoLp5Xa3fjhtviNaoMK+qi6yIuHm+FKofb9BQ03loZp1XyPItKajPC
         Ah3gL2/azv2DLhBSnijPYG5BhVrsm80MtaTyWGnna1U6+E8Me+5Q7+R6XVAp8ztRg3Kq
         p5aQ==
X-Gm-Message-State: AOAM530jP40yePjxgUqKK7gM5ptx6JPGn9XRlOURPZbWfFecadDFD3FV
        ZOz0XSJHzc4ZA+eHGpwbzMY0TmWgYjk2qd78tnk=
X-Google-Smtp-Source: ABdhPJz3f4DsSflyf7bXBTZPpPzDvIkAx9i2kIjmDti/zE3sTnArKFPU4uBfwp8C9/kMPcSZ7WsSiw+4IQi/YdD1FPs=
X-Received: by 2002:ac2:4241:0:b0:448:4b83:8372 with SMTP id
 m1-20020ac24241000000b004484b838372mr11558232lfl.463.1647204243861; Sun, 13
 Mar 2022 13:44:03 -0700 (PDT)
MIME-Version: 1.0
References: <20220207144804.708118-1-miquel.raynal@bootlin.com>
 <20220207144804.708118-14-miquel.raynal@bootlin.com> <CAB_54W5ao0b6QE7E_uXFeorbn6UjB6NV4emtibqswL4iXYEfng@mail.gmail.com>
 <20220303191723.39b87766@xps13> <20220304115432.7913f2ef@xps13>
In-Reply-To: <20220304115432.7913f2ef@xps13>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Sun, 13 Mar 2022 16:43:52 -0400
Message-ID: <CAB_54W4A6-Jgpr2WX3y3OPo-3=BJJDz+M5XPfWwpgCx1sXWAGQ@mail.gmail.com>
Subject: Re: [PATCH wpan-next v2 13/14] net: mac802154: Introduce a tx queue
 flushing mechanism
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, Mar 4, 2022 at 5:54 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:

> I had a second look at it and it appears to me that the issue was
> already there and is structural. We just did not really cared about it
> because we didn't bother with synchronization issues.
>

I am not sure if I understand correctly. We stop the queue at some
specific moment and we need to make sure that xmit_do() is not called
or can't be called anymore.

I was thinking about:

void ieee802154_disable_queue(struct ieee802154_hw *hw)
{
        struct ieee802154_local *local = hw_to_local(hw);
        struct ieee802154_sub_if_data *sdata;

        rcu_read_lock();
        list_for_each_entry_rcu(sdata, &local->interfaces, list) {
                if (!sdata->dev)
                        continue;

               netif_tx_disable(sdata->dev);
        }
        rcu_read_unlock();
}
EXPORT_SYMBOL(ieee802154_stop_queue);

From my quick view is that "netif_tx_disable()" ensures by holding
locks and other things and doing netif_tx_stop_queue() it we can be
sure there will be no xmit_do() going on while it's called and
afterwards. It can be that there are still transmissions on the
transceiver that are on the way, but then your atomic counter and
wait_event() will come in place.
We need to be sure there will be nothing queued anymore for
transmission what (in my opinion) tx_disable() does. from any context.

We might need to review some netif callbacks... I have in my mind for
example stop(), maybe netif_tx_stop_queue() is enough (because the
context is like netif_tx_disable(), helding similar locks, etc.) but
we might want to be sure that nothing is going on anymore by using
your wait_event() with counter.

Is there any problem which I don't see?

- Alex
