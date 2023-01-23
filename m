Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAE5C677D83
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 15:04:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231485AbjAWOEJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 09:04:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231567AbjAWOEJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 09:04:09 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A138279A0
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 06:03:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674482588;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hi9QfKF/pkHE0TQcTI+lnboZZ4KZTrK1Z51mByX9dZQ=;
        b=LU+EUsNrMsIFAlfo019g4KaaI21OH8JrQDS+VvxXEM1isabPJBHTfOVEpZQDh6Xh/a9Sqb
        FKuPm44exYmJnJVqlc81dFD2VZN4qFqER1Zhqd0Rt4hduXK9DGaxa9MAjkVRTtJEzBhVW8
        BRfpq9EnlT2RXLgBDaEf6itVZqJmH34=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-556-y5u04gjhNHigfqdLTwlcyQ-1; Mon, 23 Jan 2023 09:03:04 -0500
X-MC-Unique: y5u04gjhNHigfqdLTwlcyQ-1
Received: by mail-ej1-f69.google.com with SMTP id nc27-20020a1709071c1b00b0086dae705676so7787449ejc.12
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 06:03:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hi9QfKF/pkHE0TQcTI+lnboZZ4KZTrK1Z51mByX9dZQ=;
        b=LO1yhvZezb/w3cMRVi40RSHdIimdnbVO3ZQDzoASqhrELPLsK2VUn7/XJHSs38DReL
         MQ43gZGiXNMzSvavbsRDJYdZ0s4E5TmQR2d9iuFVX6bhUBB6+HZsvT7E1ctstB3KQpCS
         CP9iHoTXbS8ztFftdlmQ04IalMRj+a9Sn9Mwr1s16151HvwPneSzs24oAhaDpoS9SvZx
         28BtnxiRSNQigsz/y4Oy9d9fWLHRZ8r6AopSrJIEYkfV/gIBjDQTPSy33xEsAcnuroF1
         CkFZB5XXPuKiVFYMkSEzmJoJ66WH8kCh1LM/rTmBCw8KL7J48fwXZ9Yn3qAQok/PKA6P
         7Anw==
X-Gm-Message-State: AFqh2kodEPpqwrd5YSshyRTIw5mCm5TbeTfCKRhvXhMxZiMEx4fa5+P5
        fr5NZnEPNOb8RM+jlyZWZpbiXzq9vTnhkuFpcy0V2279YKAFLfSv2IrF53CPwQ3mOM7/RMAMjWt
        ayikb4Bfbl1k/J8KfxXBZmcNC9VUIf5Vx
X-Received: by 2002:a05:6402:12d2:b0:498:7546:c610 with SMTP id k18-20020a05640212d200b004987546c610mr2711933edx.85.1674482579785;
        Mon, 23 Jan 2023 06:02:59 -0800 (PST)
X-Google-Smtp-Source: AMrXdXs4nTsYKdAqMdsWtKyThyGsu3vyT19czqfeMDwfaltdaoV7HzI8Aj2H0Rc4Py+yofhBCZCL3FMzwPq0fTICDqo=
X-Received: by 2002:a05:6402:12d2:b0:498:7546:c610 with SMTP id
 k18-20020a05640212d200b004987546c610mr2711926edx.85.1674482579477; Mon, 23
 Jan 2023 06:02:59 -0800 (PST)
MIME-Version: 1.0
References: <20230106113129.694750-1-miquel.raynal@bootlin.com>
 <CAK-6q+jNmvtBKKxSp1WepVXbaQ65CghZv3bS2ptjB9jyzOSGTA@mail.gmail.com>
 <20230118102058.3b1f275b@xps-13> <CAK-6q+gwP8P--5e9HKt2iPhjeefMXrXUVy-G+szGdFXZvgYKvg@mail.gmail.com>
In-Reply-To: <CAK-6q+gwP8P--5e9HKt2iPhjeefMXrXUVy-G+szGdFXZvgYKvg@mail.gmail.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Mon, 23 Jan 2023 09:02:48 -0500
Message-ID: <CAK-6q+gn7W9x2+ihSC41RzkhmBn1E44pKtJFHgqRdd8aBpLrVQ@mail.gmail.com>
Subject: Re: [PATCH wpan-next 0/2] ieee802154: Beaconing support
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
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
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, Jan 23, 2023 at 9:01 AM Alexander Aring <aahringo@redhat.com> wrote:
>
> Hi,
>
> On Wed, Jan 18, 2023 at 4:21 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> >
> > Hi Alexander,
> >
> > aahringo@redhat.com wrote on Sun, 15 Jan 2023 20:54:02 -0500:
> >
> > > Hi,
> > >
> > > On Fri, Jan 6, 2023 at 6:33 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > > >
> > > > Scanning being now supported, we can eg. play with hwsim to verify
> > > > everything works as soon as this series including beaconing support gets
> > > > merged.
> > > >
> > >
> > > I am not sure if a beacon send should be handled by an mlme helper
> > > handling as this is a different use-case and the user does not trigger
> > > an mac command and is waiting for some reply and a more complex
> > > handling could be involved. There is also no need for hotpath xmit
> > > handling is disabled during this time. It is just an async messaging
> > > in some interval and just "try" to send it and don't care if it fails,
> > > or? For mac802154 therefore I think we should use the dev_queue_xmit()
> > > function to queue it up to send it through the hotpath?
> > >
> > > I can ack those patches, it will work as well. But I think we should
> > > switch at some point to dev_queue_xmit(). It should be simple to
> > > switch it. Just want to mention there is a difference which will be
> > > there in mac-cmds like association.
> >
> > I see what you mean. That's indeed true, we might just switch to
> > a less constrained transmit path.
> >
>
> I would define the difference in bypass qdisc or not. Whereas the
> qdisc can drop or delay transmitting... For me, the qdisc is currently
> in a "works for now" state.

probably also bypass other hooks like tc, etc. :-/ Not sure if we want that.

- Alex

