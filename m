Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C337A5026A7
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 10:27:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348516AbiDOI3a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 04:29:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242834AbiDOI31 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 04:29:27 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48AC8B3DFD
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 01:26:59 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id n43so2824735pfv.10
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 01:26:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IouwgSoOU5RLyMJuBmnkWSebHjJ6FolzaVbEFNDsszU=;
        b=gTmvcqVWKjRoSWUlP6fJYRDMffX0KIawj4PuOOu801Wi/7rfmmcSGiH/BqjX+xIriT
         +nq2k+bskAd6ELn0+sBm+a3TTq/DF/RxNvQtcZ2ZYxGWeNbhFrH0w7Xj66Hq6YbSh7Ls
         xOZlEe+aipJWNgpkY2ZaBifeeD0SHr6tqi9VNoi5HKwONCBjHg3nEXJ94Pvr8CeiZfBn
         FVdPLZjKFpJfp7eoNOVHUv5vsm8OVhX1JQuC5S0MyZwPBN1KoZvjFxbSw+ejQd7RBEq2
         MWWeqibVdA1ug9lzdH+DA4fPTlCqRibLRvhX/zBXFTI9oD4bhezridMEKHTigA98IAWc
         B7qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IouwgSoOU5RLyMJuBmnkWSebHjJ6FolzaVbEFNDsszU=;
        b=6H/hpLr5tVBy49mkskrla0suvCuFQy1OufyxYDBgvR9O1rCdBWyKOzVmg8NGd2ZHVQ
         Cayakp265Uk8Kt7/U/nFLcHldEctYdZ8qJYM+aCqCVcos/1t8/q93k5CBzHlNb5CsK+N
         YxW673sh+Lp2LWajl68x5jZuAlpIJWvw7PyJS2M/bIk9xYIZWBfXRNoHpECguw+SS1bg
         kC1jBU+1rEEFy6JlXd7lDig+Fmq8nArALoyTEp2hLYeHDh/oubBikWVt1OEPk7QLMNLv
         +jaqRzhITTw0sdhB4ZXxRUY1c/T1Ekzxw8CpheX8IrR6ca4OgARu9oQsSvhnq/AZr6Qv
         CC2Q==
X-Gm-Message-State: AOAM531Ww2VWFEPaYyZVhYioXiaZf2nDG5idajq4bvXnGfh8Op04SlCd
        pSEeFz8Mru3DRJXErdFNI19m+RyICLL1Rr7ctgwCdQZBl2GR4Q==
X-Google-Smtp-Source: ABdhPJwi7VZhcsJ5DGv660Mg4AHf5r56+3E7RgA5pVgaieMZjLUNyxDVauEwklWTDsyiDy13rPq5P6cpr0CplOR4IGc=
X-Received: by 2002:a63:1557:0:b0:39d:8460:2e07 with SMTP id
 23-20020a631557000000b0039d84602e07mr5680484pgv.344.1650011218652; Fri, 15
 Apr 2022 01:26:58 -0700 (PDT)
MIME-Version: 1.0
References: <20220415054219.38078-1-aajith@arista.com> <4586921d-5fc4-b63f-8264-a6fd63c592b6@gmail.com>
In-Reply-To: <4586921d-5fc4-b63f-8264-a6fd63c592b6@gmail.com>
From:   Arun Ajith S <aajith@arista.com>
Date:   Fri, 15 Apr 2022 13:56:46 +0530
Message-ID: <CAOvjArSb4avVaV25925z+e5eKW89Q6k+AsPSq1yS+kroG_a=ww@mail.gmail.com>
Subject: Re: [PATCH net-next v5] net/ipv6: Introduce accept_unsolicited_na
 knob to implement router-side changes for RFC9131
To:     Bagas Sanjaya <bagasdotme@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        dsahern@kernel.org, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        pabeni@redhat.com, corbet@lwn.net, prestwoj@gmail.com,
        gilligan@arista.com, noureddine@arista.com, gk@arista.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry, it wasn't the mailer.
The rst file in my patch was missing tabs.
I have fixed it and verified the generated HTML is correct.
I'll post v6 with the fix.

On Fri, Apr 15, 2022 at 1:09 PM Bagas Sanjaya <bagasdotme@gmail.com> wrote:
>
> On 4/15/22 12:42, Arun Ajith S wrote:
> > +accept_unsolicited_na - BOOLEAN
> > +     Add a new neighbour cache entry in STALE state for routers on receiving an
> > +     unsolicited neighbour advertisement with target link-layer address option
> > +     specified. This is as per router-side behavior documented in RFC9131.
> > +     This has lower precedence than drop_unsolicited_na.
> > +
> > +   ====   ======  ======  ==============================================
> > +      drop   accept  fwding                   behaviour
> > +      ----   ------  ------  ----------------------------------------------
> > +         1        X       X  Drop NA packet and don't pass up the stack
> > +         0        0       X  Pass NA packet up the stack, don't update NC
> > +         0        1       0  Pass NA packet up the stack, don't update NC
> > +         0        1       1  Pass NA packet up the stack, and add a STALE
> > +                             NC entry
> > +   ====   ======  ======  ==============================================
> > +
>
> Hi,
>
> Building htmldocs with this patch, there are no more warnings from v4, but
> I don't see the table above generated in the output. I guess due to
> whitespace-mangling issues on your mailer, because the table syntax alignment
> (the =-s) don't match the contents/cells.
>
> Thanks.
>
> --
> An old man doll... just what I always wanted! - Clara
