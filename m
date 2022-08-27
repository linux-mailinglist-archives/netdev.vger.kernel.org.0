Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A35555A32FC
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 02:14:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345096AbiH0AOB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 20:14:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239871AbiH0AOA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 20:14:00 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31B1AE97CE;
        Fri, 26 Aug 2022 17:13:58 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id d5so1574039wms.5;
        Fri, 26 Aug 2022 17:13:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=f/BKNi28MeHiGsO1YWlqYB+icVTefgwm2tbmFgLqM1Q=;
        b=Oj3j9dQUlMNgeH2k/rL22lGM8DkVVNgexDSaeKIUjqqSCULZzkcMZIugC5J1BD42Qa
         zCv7oJHlQ+NkAikAm+1Q1NZmIG7XXBQtXhnQDlluJ2NpEs6xIWOWeG/cdyGrKTnL8nWg
         vfRG7VH7bEusdtUrVvUV07La951rCj9HhUPcpX9UxOOl6OYLAO5WAPzTAK1TSPcVmITU
         0+GTXTtIdiQGbehJGcE9RIvOqyOH1hVGAOA0b0L2/O2YhwCAJ2h6Qo5AG8ok0H+ZAzJj
         PyiO0s+pdXI2z1Pjs2T258eokicN91aL2jZlQnvG6LCNKyTLJvmwZP5nl3SmQusdyqIK
         yMWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=f/BKNi28MeHiGsO1YWlqYB+icVTefgwm2tbmFgLqM1Q=;
        b=Qpw4FzjQOdKsmsNArxIIdr0PUZc3WzVzA+S4q2igizJ41JUgS+2qeGjHrsT5f4gEph
         cP7qx+9h36FQ7Asha7t2n1KTw8SYN0P2rtSLAS7OmH2ZUg2gYXUb+hgnley40ivVFmIh
         vJwmksNlB2oAmeE6fobdRBhv+GjR2WdzWdvPgjji+VB3LQ/GA6XNE11ml0ufqU5t9zLu
         DWmiD5bQUxyiQKvBJ/+EsjMUsQF3qdxjyWGwvXW/giE3FFTyd+SsXHgK4fj8OmrSYXmg
         pEx1pHQ1iHWW0KU3i9JE0vbWEOR8rqKDF8spGKGb6pnzTJHDuJrggpPTxaO+2iKmbRj9
         IYfg==
X-Gm-Message-State: ACgBeo1IhqOjWkV0+5vEuc4Sv531x/vCzdE2AfKMrvWg5clfyxv2SBRE
        y1w88Xwxlblg5dcJBRKUo0Tkv9lCkdGeGJ1oLYg=
X-Google-Smtp-Source: AA6agR7LoxmVfEvUWWbxgAC8hQQdag9gDqeasV0HbGKcSV8te0Ew7cOhPoVWJybM/gLj6E2hU/e2p+3k372ITA5DJFg=
X-Received: by 2002:a05:600c:ace:b0:3a5:b495:854d with SMTP id
 c14-20020a05600c0ace00b003a5b495854dmr947501wmr.86.1661559236717; Fri, 26 Aug
 2022 17:13:56 -0700 (PDT)
MIME-Version: 1.0
References: <117aa7ded81af97c7440a9bfdcdf287de095c44f.camel@sipsolutions.net>
 <20220824191500.6f4e3fb7@kernel.org> <87k06uk65f.fsf@intel.com> <20220826170005.79392041@kernel.org>
In-Reply-To: <20220826170005.79392041@kernel.org>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Fri, 26 Aug 2022 17:13:44 -0700
Message-ID: <CAA93jw5M_ewwhQedshYBwk=SrJSK_61rV-w_H7OXgArrndXXAw@mail.gmail.com>
Subject: Re: taprio vs. wireless/mac80211
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>,
        Avi Stern <avraham.stern@intel.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 26, 2022 at 5:05 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 26 Aug 2022 15:10:36 -0700 Vinicius Costa Gomes wrote:
> > Jakub Kicinski <kuba@kernel.org> writes:
> >
> > > On Wed, 24 Aug 2022 23:50:18 +0200 Johannes Berg wrote:
> > >> Anyone have recommendations what we should do?
> > >
> > > Likely lack of sleep or intelligence on my side but I could not grok
> > > from the email what the stacking is, and what the goal is.
> > >
> > > Are you putting taprio inside mac80211, or leaving it at the netdev
> > > layer but taking the fq/codel out?
> >
> > My read was that they want to do something with taprio with wireless
> > devices and were hit by the current limitation that taprio only support=
s
> > multiqueue interfaces.
> >
> > The fq/codel part is that, as far as I know, there's already a fq/codel
> > implementation inside mac80211.
> >
> > The stacking seems to be that packets would be scheduled by taprio and
> > then by the scheduler inside mac80211 (fq/codel based?).
>
> Doesn't adding another layer of non-time-aware queuing after taprio
> completely defeat its purpose?  Perhaps I'm revealing my lack of
> understanding too much..
>

A pre wifi-7 mac itself is incapable of doing time aware queuing. It
has to listen before talk, and
wait til the media is free. Even if wifi-7 bears out, it's still dicy.

So even if you only had one taprio'd packet in the sysem and no other
packets, submitting that packet only starts an election to gain the
media.

--=20
FQ World Domination pending: https://blog.cerowrt.org/post/state_of_fq_code=
l/
Dave T=C3=A4ht CEO, TekLibre, LLC
