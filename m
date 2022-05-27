Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6E06535F43
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 13:31:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351289AbiE0LbD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 07:31:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351276AbiE0LbB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 07:31:01 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69D965BE7A
        for <netdev@vger.kernel.org>; Fri, 27 May 2022 04:31:00 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id j21so3687628pga.13
        for <netdev@vger.kernel.org>; Fri, 27 May 2022 04:31:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4E04CxCdVI/MP/+iazhHDXvfGTIP9PStXJYRvfIEhjI=;
        b=YnlYyxCzqR7xfKb3VRR2mNSXpgVuyOSTuSlkdqYkxcxcFvxLT+O/FwUjqzbBfKhP/e
         ovagfSSkYPyFOvO5iqne2Fd+y1mirPQMZp+NMNFG7FsxCK5staW24K4uwNN+srfWSXfj
         PzfdgrcY9jSci8uCXt8QnM8PeRsDzBOUF+xjfhhJreydGBLPVctleiba3iQf3AiGjAdI
         WvPs/I/Y4dyN8xiG4kcgs7M7bG4Pql17cz/VjgXBkGl5Y9CUk5ArYZsGzZydngj6t5OR
         vNjuaaa8JAl+sbQqvX2Q6aEBhVBSiWIcTc6NMDiYZs7qtEnX+YiHSjj6JCduYc6m7Q5Q
         z7mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4E04CxCdVI/MP/+iazhHDXvfGTIP9PStXJYRvfIEhjI=;
        b=Ok5uKN8oYeL4rF7rGiPRuegDrJ71fXKTyvTvUKJzasGCjAiRauBx76W1e1dlVOPt1n
         jol6NPd0uv28nMfzm7dUuma70wNt1EAJDMMg8TrEq0xW1Urm51iJ+E37TPVqyFQ++RXo
         SO2DS/zTDL0u4oYq553aXi0T4tWMwrIgEZj4b6oMWaVMSHvzeIfSCO10956iu42sF3/8
         VZ8EYNaLErxtNxEKyStsmRo+2EBWPso29+iLhLFpd1UisH+IC60BsKyE11P7ZgGmIP0p
         ukb/sMBfycphLrv/J6xENGTzBTvgVBB7//89z8IA/Ytj2X3d240i/Tjj52o/v3DnGflk
         ILRQ==
X-Gm-Message-State: AOAM532+s/9zZAm4WFu9nFqvE94MIyIYJScXU08Fbht3bXVJg0BzFvZz
        +H6Y8ggvJgjyg7J9gUoPPwuQ+9eYLzU7pmRF9/462g==
X-Google-Smtp-Source: ABdhPJzW0axHx0xUVC7lrXuhPEy1Kjiuu5xYWgplY0TOS/xjkBkio5x/Uq8QTBCG3MxicRbC/lbfYbxEJAWAPq6IgcI=
X-Received: by 2002:a63:2601:0:b0:3fa:3b85:11a6 with SMTP id
 m1-20020a632601000000b003fa3b8511a6mr22577729pgm.99.1653651059864; Fri, 27
 May 2022 04:30:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220527073111.14336-1-aajith@arista.com> <4ef24dae-bad0-9641-7eb9-7d8207d198be@gmail.com>
In-Reply-To: <4ef24dae-bad0-9641-7eb9-7d8207d198be@gmail.com>
From:   Arun Ajith S <aajith@arista.com>
Date:   Fri, 27 May 2022 17:00:48 +0530
Message-ID: <CAOvjArSHVV81nhzK=4PVps47v5==kXOZ8OxTS+kxh93fwJYH1w@mail.gmail.com>
Subject: Re: [PATCH net] net/ipv6: Change accept_unsolicited_na to accept_untracked_na
To:     Bagas Sanjaya <bagasdotme@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        dsahern@kernel.org, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        pabeni@redhat.com, gilligan@arista.com, noureddine@arista.com,
        gk@arista.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 27, 2022 at 3:00 PM Bagas Sanjaya <bagasdotme@gmail.com> wrote:
>
> On 5/27/22 14:31, Arun Ajith S wrote:
> > This change expands the current implementation to match the RFC. The
> > sysctl knob is also renamed to accept_untracked_na to better reflect the
> > implementation.
> >
>
> Say in imperative, "Expand and rename accept_unsolicited na to
> accept_untracked_na" in both commit/patch subject and message.
>
Okay, I will fix this.

> > -accept_unsolicited_na - BOOLEAN
> > +accept_untracked_na - BOOLEAN
> >       Add a new neighbour cache entry in STALE state for routers on receiving an
> > -     unsolicited neighbour advertisement with target link-layer address option
> > -     specified. This is as per router-side behavior documented in RFC9131.
> > -     This has lower precedence than drop_unsolicited_na.
> > +     neighbour advertisement with target link-layer address option specified
> > +     if a corresponding entry is not already present.
> > +     This is as per router-side behavior documented in RFC9131.
> >
> > -      ====   ======  ======  ==============================================
> > -      drop   accept  fwding                   behaviour
> > -      ----   ------  ------  ----------------------------------------------
> > -         1        X       X  Drop NA packet and don't pass up the stack
> > -         0        0       X  Pass NA packet up the stack, don't update NC
> > -         0        1       0  Pass NA packet up the stack, don't update NC
> > -         0        1       1  Pass NA packet up the stack, and add a STALE
> > -                             NC entry
> > -      ====   ======  ======  ==============================================
> > +     This has lower precedence than drop_unsolicited_na.
> >
>
> I think you should have made similar logical expansion of drop_unsolicited_na to
> drop_untracked_na. Otherwise, ...
>
drop_unsolicited_na is a separate feature which is pre-existing in linux-5.18.

> >       /* RFC 9131 updates original Neighbour Discovery RFC 4861.
> > -      * An unsolicited NA can now create a neighbour cache entry
> > -      * on routers if it has Target LL Address option.
> > +      * NAs with Target LL Address option without a corresponding
> > +      * entry in the neighbour cache can now create a STALE neighbour
> > +      * cache entry on routers.
> >        *
> > -      * drop   accept  fwding                   behaviour
> > -      * ----   ------  ------  ----------------------------------------------
> > -      *    1        X       X  Drop NA packet and don't pass up the stack
> > -      *    0        0       X  Pass NA packet up the stack, don't update NC
> > -      *    0        1       0  Pass NA packet up the stack, don't update NC
> > -      *    0        1       1  Pass NA packet up the stack, and add a STALE
> > -      *                          NC entry
> > -      * Note that we don't do a (daddr == all-routers-mcast) check.
> > +      *   entry accept  fwding  solicited        behaviour
> > +      * ------- ------  ------  ---------    ----------------------
> > +      * present      X       X         0     Set state to STALE
> > +      * present      X       X         1     Set state to REACHABLE
> > +      *  absent      0       X         X     Do nothing
> > +      *  absent      1       0         X     Do nothing
> > +      *  absent      1       1         X     Add a new STALE entry
> >        */
>
> The Documentation/ diff above drops behavior table but in the code comment
> it is updated. Why didn't update in Documentation/ instead?
>

In the documentation, I skipped the table and mentioned the behavior in words.
1. drop_unsolicited_na takes precedence over accept_untracked_na.
2. The feature applies only for routers (fwding=1) and when target
link-layer address
     option is specified.

Some of the behavior mentioned in the table is existing behavior and
didn't want to
document under this feature. I thought it best to skip the table in
Documentation as
it is more for code-readability.

> And my nitpick: for consistency, prefer en-US words over en-UK or mixed
> varieties when writing (s/behaviour/behavior/gc, s/neighbour/neighbor/gc).
>
Sure, I tried to use UK-en since the code uses that, but I might have mixed
it up unintentionally.  I'll make it uniform in the next version of the patch.

> --
> An old man doll... just what I always wanted! - Clara

I accidentally replied in HTML earlier. Fixing it to be plaintext.
