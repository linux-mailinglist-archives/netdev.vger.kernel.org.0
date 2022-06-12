Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E692547C66
	for <lists+netdev@lfdr.de>; Sun, 12 Jun 2022 23:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234394AbiFLVUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jun 2022 17:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232057AbiFLVUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jun 2022 17:20:16 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F10FE0C5
        for <netdev@vger.kernel.org>; Sun, 12 Jun 2022 14:20:14 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id h23so6118203lfe.4
        for <netdev@vger.kernel.org>; Sun, 12 Jun 2022 14:20:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VAh12BAJ2Y3B+nB2oJ2V7WD57RZgiUFZsN9mmdJrTLw=;
        b=X8Y5pq4aGuSp91WJBgrowdekEmfZyCNbVDGIKpghHQ3ZjVDCHlIOCxB37dvAPsZ0Gn
         uRZ5mlEjaP94YKJZqJuUzIvlqTa8Vra3N3HUj6aI2QEWYMcy5mzeKg1lr5CpyxnJXIuy
         FaZsaY5HsaOQ9eZJOCsy0enGukg7/KyVc8rW4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VAh12BAJ2Y3B+nB2oJ2V7WD57RZgiUFZsN9mmdJrTLw=;
        b=QqtMIPOzDCoXmz/uQ0ayJZarU2qY2Qtlsyh1SOFloMVksaDm5h6iqTe86CpYTogjKP
         lA3F62ZXDidAKpRVROCS2sL5/1yN0GiS0NBbTEXrrVn25fT28gI1FwBL9iXL7J9eCRMa
         1kIrzrgUZUeHKYt8E7DBrc/q8PF31+7DreDp7en35Ge3w2cqki6TT7zKtgCi+bMsNB0H
         kS5LDsXyM2A0WZ1867UVbYKLCcl9zHp9yKHCzK2kW+xo9Fst+K2R5fgaDpbyYJk7otN1
         mbqjw7/nXH5mLCHEJLD0U5hbqoM+5yqs4Pz14YQQ6vstQJAva9E3SH3LZc+K18Gj85Ka
         Tdfg==
X-Gm-Message-State: AOAM530wkC5YR7Y/rVrQd7ZkP8lnQypEFirPGheBqTjfuqY3a/maTibI
        UFsCar0ZDsfKmq/sT9QxzgYOq6hYSKRMohiVSFZaaw==
X-Google-Smtp-Source: ABdhPJwJHDgTqA5mpG8eKyVbsazoVrxrj6vaAa8kuQKHE5VEdeiCKzTdWX/OU/zm03VQ1RJbP/eVbZ9Z5euM/otCmug=
X-Received: by 2002:a05:6512:3a89:b0:479:52fc:f80a with SMTP id
 q9-20020a0565123a8900b0047952fcf80amr20862792lfu.120.1655068812754; Sun, 12
 Jun 2022 14:20:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220608165116.1575390-1-dario.binacchi@amarulasolutions.com>
 <20220608165116.1575390-6-dario.binacchi@amarulasolutions.com>
 <eae65531-bf9f-4e2e-97ca-a79a8aa833fc@hartkopp.net> <CABGWkvroJG16AOu8BODhVu068jacjHWbkkY9TCF4PQ7rgANVXA@mail.gmail.com>
 <20220612182302.36bdd9b9.max@enpas.org> <aee0c161-5418-ad56-ab33-66e34a4f2a0d@hartkopp.net>
In-Reply-To: <aee0c161-5418-ad56-ab33-66e34a4f2a0d@hartkopp.net>
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
Date:   Sun, 12 Jun 2022 23:20:01 +0200
Message-ID: <CABGWkvqpn0XiYJPDKm-0ynetKLS2CrBb+-DH8Pw_7Z5wwP4vnA@mail.gmail.com>
Subject: Re: [PATCH v2 05/13] can: slcan: simplify the device de-allocation
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Max Staudt <max@enpas.org>, linux-kernel@vger.kernel.org,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        michael@amarulasolutions.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 12, 2022 at 7:13 PM Oliver Hartkopp <socketcan@hartkopp.net> wrote:
>
>
>
> On 12.06.22 18:23, Max Staudt wrote:
> > On Sat, 11 Jun 2022 12:46:04 +0200
> > Dario Binacchi <dario.binacchi@amarulasolutions.com> wrote:
> >
> >>> As written before I would like to discuss this change out of your
> >>> patch series "can: slcan: extend supported features" as it is no
> >>> slcan feature extension AND has to be synchronized with the
> >>> drivers/net/slip/slip.c implementation.
> >>
> >> Why do you need to synchronize it with  drivers/net/slip/slip.c
> >> implementation ?
> >
> > Because slcan.c is a derivative of slip.c and the code still looks
> > *very* similar, so improvements in one file should be ported to the
> > other and vice versa. This has happened several times now.
> >
> >
> >>> When it has not real benefit and introduces more code and may create
> >>> side effects, this beautification should probably be omitted at all.
> >>>
> >>
> >> I totally agree with you. I would have already dropped it if this
> >> patch didn't make sense. But since I seem to have understood that
> >> this is not the case, I do not understand why it cannot be improved
> >> in this series.
> >
> > This series is mostly about adding netlink support. If there is a point
> > of contention about a beautification, it may be easier to discuss that
> > separately, so the netlink code can be merged while the beautification
> > is still being discussed.
> >
> >
> > On another note, the global array of slcan_devs is really unnecessary
> > and maintaining it is a mess - as seen in some of your patches, that
> > have to account for it in tons of places and get complicated because of
> > it.
> >
> > slcan_devs is probably grandfathered from a very old kernel, since
> > slip.c is about 30 years old, so I suggest to remove it entirely. In
> > fact, it may be easier to patch slcan_devs away first, and that will
> > simplify your open/close patches - your decision :)
> >
> >
> > If you wish to implement the slcan_devs removal, here are some hints:
> >
> > The private struct can just be allocated as part of struct can_priv in
> > slcan_open(), like so:
> >
> >    struct net_device *dev;
> >    dev = alloc_candev(sizeof(struct slcan), 0);
> >
> > And then accessed like so:
> >
> >    struct slcan *sl = netdev_priv(dev);
> >
> > Make sure to add struct can_priv as the first member of struct slcan:
> >
> >    /* This must be the first member when using alloc_candev() */
> >    struct can_priv can;
> >
> >
> >> The cover letter highlighted positive reactions to the series because
> >> the module had been requiring these kinds of changes for quite
> >> some time. So, why not take the opportunity to finalize this patch in
> >> this series even if it doesn't extend the supported features ?
> >
> > Because... I can only speak for myself, but I'd merge all the
> > unambiguous stuff first and discuss the difficult stuff later, if there
> > are no interdependencies :)
> >
> >
> >
> > Max
> >
>
> Thanks for stepping in Max!
>
> Couldn't have summarized it better ;-)
>
> When I created slcan.c from slip.c this line discipline driver was just
> oriented at the SLIP idea including the user space tools to attach the
> network device to the serial tty.
>
> Therefore the driver took most of the mechanics (like the slcan_devs
> array) and did *only* the 'struct canframe' to ASCII conversion (and
> vice versa).
>
> @Dario: Implementing the CAN netlink API with open/close/bitrate-setting
> is a nice improvement. Especially as you wrote that you took care about
> the former/old API with slcan_attach/slcand.
>
> Best regards,
> Oliver

Thanks to both of you for the explanations.
best regards,
Dario

-- 

Dario Binacchi

Embedded Linux Developer

dario.binacchi@amarulasolutions.com

__________________________________


Amarula Solutions SRL

Via Le Canevare 30, 31100 Treviso, Veneto, IT

T. +39 042 243 5310
info@amarulasolutions.com

www.amarulasolutions.com
