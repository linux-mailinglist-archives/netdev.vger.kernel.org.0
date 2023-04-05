Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 571B66D83C8
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 18:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232000AbjDEQf4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 12:35:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbjDEQfz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 12:35:55 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A92F640C9
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 09:35:54 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id iw3so34934868plb.6
        for <netdev@vger.kernel.org>; Wed, 05 Apr 2023 09:35:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680712554;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G5e/Nj4lu5gM2mPm8dxHef3AcMMGUwzDuNEQrZe6y2c=;
        b=opypVFdEe0FjX1F5XQSsGfMGRBAbvsnKs2/CIrOB1EPR9lGLSH4aMu74zkeaQ3OVUB
         Diej/MT1I5ihlbt5ck0C1z5/HysOqzFpI+i0dMVkVE7A+d1jc8Uumuk0VJn5kBSMJy+C
         K14bfPRKa5Mc3v46RVfeWSFDsb3g8IB+UUcB2rbBPtRRiYGQ5GNhkmjvG3F5wa1hGwZs
         ag16DiPlsEcQLLJvMmSZIbGjFhg5Hy3QXdZivnA6LqI4pToFJtUzlj5mP2HGxhY+QYIg
         XppDfZB6Se/XYxqNtMFKZPtmYl4wsPxsOuGG/Q/9ydxiUUMOjWAVnbDd6nT02OP12b0l
         P9uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680712554;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G5e/Nj4lu5gM2mPm8dxHef3AcMMGUwzDuNEQrZe6y2c=;
        b=LZeDQ8hwKcTloVKJoXAO0OfzB/ZNeqMlqXqzYvJiaKUtDYm4bUWSJCDDTxJCcbfdGC
         jPDXkuTaiWGp9ii/Ie1sj+BVCHlRAToejkk/bwbcVJBqzZKwD+2HP0R40m4Ey5XyGye8
         HUG3DOD57E9fLgpUGSpLLJBEzGIKu51Ay5U7krca4bZKDKcv5Fquph6zBzowTIVbGJeu
         67zbqOJ05XvBcvEdgfvFxCnGwiv0Bnltizo9xZ1258do1b4yZIfVohZXzb1w0I1n31SI
         8o8kMkg83vaxrGF3USX/GlZBTOyj//mQRTgsmsmkjVOdnhCWsee/aiOqXXOc0o4QUR9p
         ngJw==
X-Gm-Message-State: AAQBX9cs3mOgKqAH03RLVhknV36GVYeScKToPTareEPTm8Ym8Ty7wBKj
        ffudWDVtjd9Wh3Pz2VA+Igl8fZ/xra54wP580YI=
X-Google-Smtp-Source: AKy350YMc6yiBwVAwcaZ1SDjiNlUTxjgxHGef7KOJhYg7qRKawDZ/oYuEweC1fpaPkJmVFKD1pwZqLZF4SJnUsms12o=
X-Received: by 2002:a17:90b:e09:b0:240:228:95bd with SMTP id
 ge9-20020a17090b0e0900b00240022895bdmr2584273pjb.5.1680712554033; Wed, 05 Apr
 2023 09:35:54 -0700 (PDT)
MIME-Version: 1.0
References: <20230405063330.36287-1-glipus@gmail.com> <20230405121848.yojvkbms4cvfriec@skbuf>
In-Reply-To: <20230405121848.yojvkbms4cvfriec@skbuf>
From:   Max Georgiev <glipus@gmail.com>
Date:   Wed, 5 Apr 2023 10:35:43 -0600
Message-ID: <CAP5jrPHSJv7Bi8r=BzzZgx5vjo1Y9eajZdRbfV7T603ZwEEJfw@mail.gmail.com>
Subject: Re: [RFC PATCH v3 4/5] Convert netdevsim driver to use
 ndo_hwtstamp_get/set for hw timestamp requests
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     kory.maincent@bootlin.com, kuba@kernel.org, netdev@vger.kernel.org,
        maxime.chevallier@bootlin.com, vadim.fedorenko@linux.dev,
        richardcochran@gmail.com, gerhard@engleder-embedded.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 5, 2023 at 6:18=E2=80=AFAM Vladimir Oltean <vladimir.oltean@nxp=
.com> wrote:
>
> On Wed, Apr 05, 2023 at 12:33:30AM -0600, Maxim Georgiev wrote:
> > Changing netdevsim driver to use the newly introduced ndo_hwtstamp_get/=
set
> > callback functions instead of implementing full-blown SIOCGHWTSTAMP/
> > SIOCSHWTSTAMP IOCTLs handling logic.
> >
> > Suggested-by: Jakub Kicinski <kuba@kernel.org>
> > Signed-off-by: Maxim Georgiev <glipus@gmail.com>
> > ---
>
> The commit message describes a conversion, but this isn't a conversion,
> it's new functionality (which to my eyes is also incomplete).

That's true, the commit message is misleading, the patch misses the logic
allowing ethtool to read the timestamp config, and I still don't have test
results for this patch. I didn't get to it yet.
Let me do the right thing and drop patches 4/5 and 5/5 from the stack
temporarily until I get them right.

>
> Also, what happened to:
>
> | I'd vote to split netdevsim out, and it needs a selftest which
> | exercises it under tools/testing/selftests/drivers/net/netdevsim/
> | to get merged...
>
> https://lore.kernel.org/netdev/20230403141918.3257a195@kernel.org/
