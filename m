Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83F3E67A8CA
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 03:31:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231563AbjAYCby (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 21:31:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232876AbjAYCbw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 21:31:52 -0500
Received: from mail-oa1-x2e.google.com (mail-oa1-x2e.google.com [IPv6:2001:4860:4864:20::2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5001F4FC3F;
        Tue, 24 Jan 2023 18:31:45 -0800 (PST)
Received: by mail-oa1-x2e.google.com with SMTP id 586e51a60fabf-1442977d77dso19911145fac.6;
        Tue, 24 Jan 2023 18:31:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=8kCsukhVDS/c7tuRdeCrUX7U/E2xZNP5HI/GGFAaFiE=;
        b=FEVbXRpHzyHt2qh1mEGig45KpGvRwYaEWRia/Wk2VYc4n02CR2HbqxXxWspb8tJt+z
         LUAYWjdfxnC3HYGGKABdPjzeIUKHbESXeqQJzH0KNvGCqQyB/ZCJkkMtatHS+22PGyoW
         8yBXFjXhM4QYbam8U4nUZKOgefWJ5PuJ6YnkqJEla+fEFrJAY3DYvuZjKE+vvxxfdyAx
         OTYi2UB9EQhmzzaugLCfDNbYXfoZzcpc6oOyT93xHgt272deRCEF6eoGAqVNT8QXVmZH
         2STj/eIiN5KNAe4D1jitEa0Fa+QsixMlUBtYVZdu4Xh7WnYvap5tOEukPTz7tK59ZOOX
         Kdaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8kCsukhVDS/c7tuRdeCrUX7U/E2xZNP5HI/GGFAaFiE=;
        b=bArhI+/wCkwIf4En2c95uRcnKEO0AOqEMs4i/NGqH8teVEk+txDAFHvdjbi0x35Rq2
         mmCb419bk7471YuyhNeLwnbEcR5ZDrTlJe6fAeHfzNAZXt07UQghnjeLZr+QVzUNOkz1
         1nt9FbWN26OVOUYHrpSI/BveP+FdvQeqGKp1jluCy35PHTmRIUNMisXFRl85R0BcSuU7
         XtpG/k+cAALEOXXC4ZUrdvpgbiN3kN1dOhpPLQu2TVVArScPuAvg4rZy/mJu8XAxMxj3
         mi+2seTSkTNrl3P71ocmuSOgcnwBzmxAWR/0k7TOne2u8Wubk03jYvccpbqrii9UM797
         00yg==
X-Gm-Message-State: AFqh2kre0spF/o5NWrQo323JXdwNc7mkvM0R9Pv19WQ1e5nIn+lKifid
        To+TnCAIcZAeRetXu/7N2ET+FHpR0YE9xrUHicE=
X-Google-Smtp-Source: AMrXdXsv/wYPwDlp2qCLvItL6QPtD2iv1rwhJgyk3VyrRoJE5hng6Qe0F6mF5pEESMydu87TUrmxgRP4o/kHb5eRV1c=
X-Received: by 2002:a05:6870:2b18:b0:15f:4b09:ce85 with SMTP id
 ld24-20020a0568702b1800b0015f4b09ce85mr2124174oab.24.1674613904618; Tue, 24
 Jan 2023 18:31:44 -0800 (PST)
MIME-Version: 1.0
References: <20230106113129.694750-1-miquel.raynal@bootlin.com>
 <CAK-6q+jNmvtBKKxSp1WepVXbaQ65CghZv3bS2ptjB9jyzOSGTA@mail.gmail.com>
 <20230118102058.3b1f275b@xps-13> <CAK-6q+gwP8P--5e9HKt2iPhjeefMXrXUVy-G+szGdFXZvgYKvg@mail.gmail.com>
 <CAK-6q+gn7W9x2+ihSC41RzkhmBn1E44pKtJFHgqRdd8aBpLrVQ@mail.gmail.com> <20230124110814.6096ecbe@xps-13>
In-Reply-To: <20230124110814.6096ecbe@xps-13>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Tue, 24 Jan 2023 21:31:33 -0500
Message-ID: <CAB_54W69KcM0UJjf8py-VyRXx2iEUvcAKspXiAkykkQoF6ccDA@mail.gmail.com>
Subject: Re: [PATCH wpan-next 0/2] ieee802154: Beaconing support
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Guilhem Imberton <guilhem.imberton@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, Jan 24, 2023 at 5:08 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> Hi Alexander,
>
> aahringo@redhat.com wrote on Mon, 23 Jan 2023 09:02:48 -0500:
>
> > Hi,
> >
> > On Mon, Jan 23, 2023 at 9:01 AM Alexander Aring <aahringo@redhat.com> wrote:
> > >
> > > Hi,
> > >
> > > On Wed, Jan 18, 2023 at 4:21 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > > >
> > > > Hi Alexander,
> > > >
> > > > aahringo@redhat.com wrote on Sun, 15 Jan 2023 20:54:02 -0500:
> > > >
> > > > > Hi,
> > > > >
> > > > > On Fri, Jan 6, 2023 at 6:33 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > > > > >
> > > > > > Scanning being now supported, we can eg. play with hwsim to verify
> > > > > > everything works as soon as this series including beaconing support gets
> > > > > > merged.
> > > > > >
> > > > >
> > > > > I am not sure if a beacon send should be handled by an mlme helper
> > > > > handling as this is a different use-case and the user does not trigger
> > > > > an mac command and is waiting for some reply and a more complex
> > > > > handling could be involved. There is also no need for hotpath xmit
> > > > > handling is disabled during this time. It is just an async messaging
> > > > > in some interval and just "try" to send it and don't care if it fails,
> > > > > or? For mac802154 therefore I think we should use the dev_queue_xmit()
> > > > > function to queue it up to send it through the hotpath?
> > > > >
> > > > > I can ack those patches, it will work as well. But I think we should
> > > > > switch at some point to dev_queue_xmit(). It should be simple to
> > > > > switch it. Just want to mention there is a difference which will be
> > > > > there in mac-cmds like association.
> > > >
> > > > I see what you mean. That's indeed true, we might just switch to
> > > > a less constrained transmit path.
> > > >
> > >
> > > I would define the difference in bypass qdisc or not. Whereas the
> > > qdisc can drop or delay transmitting... For me, the qdisc is currently
> > > in a "works for now" state.
> >
> > probably also bypass other hooks like tc, etc. :-/ Not sure if we want that.
>
> Actually, IIUC, we no longer want to go through the entire net stack.
> We still want to bypass it but without stopping/flushing the full
> queue like with an mlme transmission, so what about using
> ieee802154_subif_start_xmit() instead of dev_queue_xmit()? I think it
> is more appropriate.

I do not understand, what do we currently do with mlme ops via the
ieee802154_subif_start_xmit() function, or? So we bypass everything
from dev_queue_xmit() until do_xmit() netdev callback.

I think it is fine, also I think "mostly" only dataframes should go
through dev_queue_xmit(). With a HardMAC transceiver we would have
control about "mostly" other frames than data either. So we should do
everything with mlme-ops do what the spec says (to match up with
HardMAC behaviour?) and don't allow common net hooks/etc. to change
this behaviour?

- Alex
