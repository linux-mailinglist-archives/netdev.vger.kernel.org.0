Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4D9150368F
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 14:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231938AbiDPMXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Apr 2022 08:23:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231932AbiDPMXI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Apr 2022 08:23:08 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F320CCF4BD
        for <netdev@vger.kernel.org>; Sat, 16 Apr 2022 05:20:34 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id s14-20020a17090a880e00b001caaf6d3dd1so13683861pjn.3
        for <netdev@vger.kernel.org>; Sat, 16 Apr 2022 05:20:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=10g5PeA+XaJ6h4fM6nvbGbNybYbukOrQjkFvmHObJsc=;
        b=CgebbriGoAmkr1Rg5xVdZLvCCa309ajlKcDJD/JIiowCsjIx+cXkj7m8JGGVBfcW9r
         wFzsYqQPaVFnDYbPKT+BdF2oE5TLzMdhyWQagqh1hTk55/3Kg1whLMV0OlsDBVPGEa08
         XaVkOARq89nr1JApNWywxLqHflj7ZafQSGntDGnOnXwiH+0pKLKfEmuINxEWWLr2gBmd
         CYdRtYch1N9wCOy/JfpTRLv9Ri4+tnR09/lcaWyPt2ZXYZoXBuKzOhI5XwZAdCEvvtL+
         hDCOGwAfnk+mdI6Br0zfqKb3F5w7TuwFLISTguDvdAY+8JgZCJvJ+c+81e855UBlZlvi
         smIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=10g5PeA+XaJ6h4fM6nvbGbNybYbukOrQjkFvmHObJsc=;
        b=ahOvEwY0RapRAQWakA0JwF9WRhVubGehiw5AwwXMfjRfj2Cw88A0es3nmKY1Q5NEqq
         cltILOB29WlK1NGHDtHZXnJc/Js5upC8joWn7necYqV1HSk8Zg0euvg7Djv/4tvoH66a
         TkU1cZQ7m8PHmrGGObGG6DVGLeHZwiGu8sHw/6EU3rvHszb3jVZswRseT3G0R77FpQBV
         AHjJn6B7kmQIxtlkdnAGCZHBiBTLcfg29j7+e0xn/NjYwZk2DwwgtG19qf/29YOcLe/i
         uEOdBFo66+QhvMBdWN88VyMsJz3vuxnV0Tk2RBqki6F2ersHTb3WT06S1MNgxTGsJWaP
         TxHQ==
X-Gm-Message-State: AOAM533ajupsmCT/6HoJ7OZhfjXk3+n7jzCcXgZQ/UjfKI5Qk1OyzFh9
        LaxOuu8dLt52OaQKihSOkQj7+QXV6GtD14yt9woL/g==
X-Google-Smtp-Source: ABdhPJyEwRorxFq6OT7m+o6QC9Ai2tfvWEY9TKOl8S83xNzbiirkOnUcAtuBGD2k9i6Sa/2MBVAssWO1MK9O/UnsI08=
X-Received: by 2002:a17:903:285:b0:158:d693:c52c with SMTP id
 j5-20020a170903028500b00158d693c52cmr3348830plr.36.1650111634362; Sat, 16 Apr
 2022 05:20:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220415083402.39080-1-aajith@arista.com> <642672cb-8b11-c78f-8975-f287ece9e89e@gmail.com>
In-Reply-To: <642672cb-8b11-c78f-8975-f287ece9e89e@gmail.com>
From:   Arun Ajith S <aajith@arista.com>
Date:   Sat, 16 Apr 2022 17:50:22 +0530
Message-ID: <CAOvjArRX_CXbUdAbfnta9sBad30aV0Q7HSA6rNPTKPbENRsnqQ@mail.gmail.com>
Subject: Re: [PATCH net-next v6] net/ipv6: Introduce accept_unsolicited_na
 knob to implement router-side changes for RFC9131
To:     Bagas Sanjaya <bagasdotme@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        David Ahern <dsahern@kernel.org>, yoshfuji@linux-ipv6.org,
        kuba@kernel.org, pabeni@redhat.com, corbet@lwn.net,
        prestwoj@gmail.com, Bob Gilligan <gilligan@arista.com>,
        Salam Noureddine <noureddine@arista.com>,
        Gautam Kachroo <gk@arista.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 16, 2022 at 11:13 AM Bagas Sanjaya <bagasdotme@gmail.com> wrote:
>
> On 4/15/22 15:34, Arun Ajith S wrote:
> > +accept_unsolicited_na - BOOLEAN
> > +     Add a new neighbour cache entry in STALE state for routers on receiving an
> > +     unsolicited neighbour advertisement with target link-layer address option
> > +     specified. This is as per router-side behavior documented in RFC9131.
> > +     This has lower precedence than drop_unsolicited_na.
> > +
> > +      ====   ======  ======  ==============================================
> > +      drop   accept  fwding                   behaviour
> > +      ----   ------  ------  ----------------------------------------------
> > +         1        X       X  Drop NA packet and don't pass up the stack
> > +         0        0       X  Pass NA packet up the stack, don't update NC
> > +         0        1       0  Pass NA packet up the stack, don't update NC
> > +         0        1       1  Pass NA packet up the stack, and add a STALE
> > +                             NC entry
> > +      ====   ======  ======  ==============================================
> > +
> > +     This will optimize the return path for the initial off-link communication
> > +     that is initiated by a directly connected host, by ensuring that
> > +     the first-hop router which turns on this setting doesn't have to
> > +     buffer the initial return packets to do neighbour-solicitation.
> > +     The prerequisite is that the host is configured to send
> > +     unsolicited neighbour advertisements on interface bringup.
> > +     This setting should be used in conjunction with the ndisc_notify setting
> > +     on the host to satisfy this prerequisite.
> > +
> > +     By default this is turned off.
> > +
>
> Looks good. htmldocs builds successfully and the table displayed properly.
>
> Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>
>
> However, I remind you the following:
>
> - The patch changelogs should be put between the dashes (---) and diffstat.
>   I don't see the changelogs when I hit reply-all because you put them as
>   message signature (at very bottom of patch message).
> - DON'T DO top-posting, DO configure your MUA to make reply text below
>   the quoted text instead.
>
> --
> An old man doll... just what I always wanted! - Clara
Thank you.
I will keep the tips for the Changelog in my mind for my next patch.
