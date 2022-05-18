Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83F8E52BF2E
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 18:13:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239840AbiERQBv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 12:01:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239718AbiERQBu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 12:01:50 -0400
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3101F149AA0;
        Wed, 18 May 2022 09:01:49 -0700 (PDT)
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-2ec42eae76bso29306507b3.10;
        Wed, 18 May 2022 09:01:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=exZDVy0fXYEUjJOxnnEOEY7L5w0sPe9Rc4hUPUbdQGk=;
        b=sa9JJ91Drnl/h/V6aFyJaghUpVrkHHilaVs8lqLifbeZtMuIRau+S0JLzQd8qcLFsQ
         WA/7/M836dhgu8bFIb9YIuLVHONKkay0njTTWDdSiiMs0cnA2hRqev3tn0NGUXLam2aM
         gB/TtHvq+6ch2PorgvIKvTu5eVgn2PLrcCGveDbc1GiGl4EKeJ32rao0OLRN1+uh9IBG
         biebRNp8uQ04OH/by6sROMIrnb0GDTZK7rPoSKfEiYGdrU5Fg6GkuUmfqWd3QSoG3HSN
         jsR7uED6iEfRccCWpIVd1GZqAzRg2xPUGAeKPqpNbkctoCII6xbaRqIKt9XTyBiLAWm8
         lzGA==
X-Gm-Message-State: AOAM533cwyvfr4XiyRgaaljGjGU8N8yd5dtIButz0BhMgPisocbr6Gs8
        qhXBAQ5b9mdNxD/T1/xHjB308FIyq706QzbSc1FgpZzgW8Xlig==
X-Google-Smtp-Source: ABdhPJwTRLxPjlziJXAcADX0e0mcHrERe93V6DdVLqohRvtfXMxTR2hhhAnek8Ds9RpGjME0IHcem5bgFmCogVvrlAQ=
X-Received: by 2002:a81:140e:0:b0:2fe:c3a3:5b19 with SMTP id
 14-20020a81140e000000b002fec3a35b19mr91778ywu.392.1652889708371; Wed, 18 May
 2022 09:01:48 -0700 (PDT)
MIME-Version: 1.0
References: <e054f6d4-7ed1-98ac-8364-425f4ef0f760@hartkopp.net>
 <20220517141404.578d188a.max@enpas.org> <20220517122153.4r6n6kkbdslsa2hv@pengutronix.de>
 <20220517143921.08458f2c.max@enpas.org> <0b505b1f-1ee4-5a2c-3bbf-6e9822f78817@hartkopp.net>
 <CAMZ6RqJ0iCsHT-D5VuYQ9fk42ZEjHStU1yW0RfX1zuJpk5rVtQ@mail.gmail.com>
 <43768ff7-71f8-a6c3-18f8-28609e49eedd@hartkopp.net> <20220518132811.xfmwms2cu3bfxgrp@pengutronix.de>
 <CAMZ6RqJqeNjAtoDWADHsWocgbSXqQixcebJBhiBFS8BVeKCb3g@mail.gmail.com>
 <3dbe135e-d13c-5c5d-e7e4-b9c13b820fb8@hartkopp.net> <20220518143613.2a7alnw6vtkw7ct2@pengutronix.de>
 <482fd87a-df5a-08f7-522b-898d68c3b04a@hartkopp.net> <899706c6-0aac-b039-4b67-4e509ff0930d@hartkopp.net>
 <CAMZ6RqJ5hXwE5skJLxRVAH4-RB8UkXmQdZWW_z=jj+bXzJZY=Q@mail.gmail.com> <20220518174803.010db67d.max@enpas.org>
In-Reply-To: <20220518174803.010db67d.max@enpas.org>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Thu, 19 May 2022 01:01:36 +0900
Message-ID: <CAMZ6RqJzNQfS1YAEWWPmXLpTu_hKVKxswWsjmWsPU7jaUVmJGw@mail.gmail.com>
Subject: Re: [PATCH v3 3/4] can: skb:: move can_dropped_invalid_skb and
 can_skb_headroom_valid to skb.c
To:     Max Staudt <max@enpas.org>
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu. 19 May 2022 at 00:52, Max Staudt <max@enpas.org> wrote:
> On Thu, 19 May 2022 00:38:51 +0900
> Vincent MAILHOL <mailhol.vincent@wanadoo.fr> wrote:
>
> > On Wed. 18 May 2022 at 23:59, Oliver Hartkopp
> > <socketcan@hartkopp.net> wrote:
> > > I can send a patch for this removal too. That's an easy step which
> > > might get into 5.19 then.
> >
> > OK, go ahead. On my side, I will start to work on the other changes
> > either next week or next next week, depending on my mood.
>
> Any wishes for the next version of can327/elmcan?

The only thing I guess would be to remove the check against
CAN_CTRLMODE_LISTENONLY in your xmit() function. The other things, I
already commented :)

> Should I wait until your changes are in?

I do not think you have to wait. There are no real dependencies. You
might just want to add a note after the --- scissors in the patch that
there is a weak dependencies on
https://lore.kernel.org/linux-can/20220514141650.1109542-5-mailhol.vincent@wanadoo.fr/


Yours sincerely,
Vincent Mailhol
