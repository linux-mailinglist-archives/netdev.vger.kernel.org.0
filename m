Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40A5B53DC19
	for <lists+netdev@lfdr.de>; Sun,  5 Jun 2022 16:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242021AbiFEOCs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jun 2022 10:02:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351113AbiFEN7c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jun 2022 09:59:32 -0400
Received: from mail-yb1-f170.google.com (mail-yb1-f170.google.com [209.85.219.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1C78BC90;
        Sun,  5 Jun 2022 06:57:15 -0700 (PDT)
Received: by mail-yb1-f170.google.com with SMTP id g24so1154407ybe.9;
        Sun, 05 Jun 2022 06:57:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4GY0BloMw09FbZ8FykETwDy9g2/m4JZ+8VicGnsv2IY=;
        b=KFgMJdZEzTxtZqW60pgwOdShowrcMNTzFVIx7A9WyMXd08rdhutT5Ja06Ch1stRuUg
         q2E7NNJtP20B3i2Z8PgIBT/58ce2/I3QFYHvaotlqkZkcnesononHTclg6EhMIIQ5ZR3
         /0AlRtgFO5WTyS6w9vQKppAVPFPqnFHs5LnrXk8Bb+PN3ILIH3yYSjRbht/UnKzWc1cG
         zsXgNuxZV4BK3TmeC7jC+fo2cE4dI+jptuesJrkM4d61hkuELPoscCzJU502Codo7q+F
         579PfOlFkqC/gAhBurop3ble2A501BF4E85tb5zVrWhZwX72wPs9wXJMiOHcdicBZ0Ne
         ZFGw==
X-Gm-Message-State: AOAM533KmlCOyVn/2rfg3A5u9AxtioAlLgH3adHOg19xHJyOXWyIp6Gp
        axVknne1QZqltOCl/oxlWYUS3rqu9EraW9UZEDE=
X-Google-Smtp-Source: ABdhPJxVm/HIlx4E5bICJq+vrL0X+/qbuU/ravo1RAyves82+K7SSWiS70+0dOakalbz/rGgxDp+Qt+2gnstkFqgCkI=
X-Received: by 2002:a25:6588:0:b0:65d:57b9:c470 with SMTP id
 z130-20020a256588000000b0065d57b9c470mr20564533ybb.142.1654437434856; Sun, 05
 Jun 2022 06:57:14 -0700 (PDT)
MIME-Version: 1.0
References: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
 <20220603102848.17907-1-mailhol.vincent@wanadoo.fr> <20220604114603.hi4klmu2hwrvf75x@pengutronix.de>
 <CAMZ6RqJpJCAudv89YqFFQH80ei7WiAshyk1RtbEv=aXSyxo3hQ@mail.gmail.com>
 <20220604135541.2ki2eskyc7gsmrlu@pengutronix.de> <CAMZ6RqJ7qvXyxNVUK-=oJnK_oq7N94WABOb3pqeYf9Fw3G6J9A@mail.gmail.com>
 <20220604151859.hyywffrni4vo6gdl@pengutronix.de> <CAMZ6RqK45r-cqXvorUzRV-LA_C+mk6hNSA1b+0kLs7C-oTcDCA@mail.gmail.com>
 <20220605103909.5on3ep7lzorc35th@pengutronix.de>
In-Reply-To: <20220605103909.5on3ep7lzorc35th@pengutronix.de>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Sun, 5 Jun 2022 22:57:03 +0900
Message-ID: <CAMZ6RqLfJ8v+=HcSU8yprXeR8q8aSOsg4i379D9rZgE9ZmC=fg@mail.gmail.com>
Subject: Re: [PATCH v4 0/7] can: refactoring of can-dev module and of Kbuild
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        Max Staudt <max@enpas.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun. 5 juin 2022 at 19:39, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> On 05.06.2022 01:32:15, Vincent MAILHOL wrote:
> > On Sun. 5 juin 2022 at 00:18, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> > > On 04.06.2022 23:59:48, Vincent MAILHOL wrote:
> > > > > > Fine, but I need a bit of guidance here. To provide a tag, I need to
> > > > > > have my own git repository hosted online, right?
> > > > >
> > > > > That is one option.
> > > >
> > > > This suggests that there are other options? What would be those other
> > > > options?
> > >
> > > 2. git.kernel.org (most preferred)
> > > 3. github.com (have to ask Davem/Jakub)
> > >
> > > > > > Is GitHub OK or should I create one on https://git.kernel.org/?
> > > > >
> > > > > Some maintainers don't like github, let's wait what Davem and Jakub say.
> > > > > I think for git.kernel.org you need a GPG key with signatures of 3 users
> > > > > of git.kernel.org.
> > > >
> > > > Personally, I would also prefer getting my own git.kernel.org account.
> > >
> > > See https://korg.docs.kernel.org/accounts.html
> >
> > Thanks for the link. I will have a look at it tomorrow (or the day
> > after tomorrow in the worst case).
> >
> > Meanwhile, I will send the v5 which should address all your comments.
>
> /me just realized that merged are independent of pull requests. I can
> create a local branch and merge it, as Davem and Jakub do it. I've added
> your v5 to can-next/master as a merge and I'll include this in my next
> PR to net-next if Davem and Jakub are OK with merges in my branch.

So my dreams of getting my kernel.org account swag just evaporated
(just kidding :))
I think I will prepare a GPG key just to be ready in the opportunity
to get it signed pop-up one day.

Happy to see that this is reaching an end. Honestly speaking, the
menuconfig cleanup was not my most exciting contribution (euphemism)
but was still a necessity. Glad that this is nearly over after more
than 80 messages in the full thread (including all five versions). If
I recall correctly, this is the longest thread we had in the last two
years. And thanks again to Max, Oliver and you for animating the
debate!


Yours sincerely,
Vincent Mailhol
