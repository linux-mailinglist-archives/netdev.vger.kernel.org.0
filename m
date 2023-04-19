Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 981846E774C
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 12:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232406AbjDSKUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 06:20:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230327AbjDSKUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 06:20:18 -0400
Received: from mail-oa1-x2b.google.com (mail-oa1-x2b.google.com [IPv6:2001:4860:4864:20::2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9E644215
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 03:20:17 -0700 (PDT)
Received: by mail-oa1-x2b.google.com with SMTP id 586e51a60fabf-18777914805so8806666fac.1
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 03:20:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681899617; x=1684491617;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=veyUflwB7EJoqM/28xla7lPnPkRZ8RdCeVwU9yKVDyc=;
        b=YTVyTuKCU9vjEY4MwTctu83rd5TiYpP6EdQqBULLE9QpDbbSwOfyR1RDRrM5WrWp07
         FhpoXDi0HCvUcZj7ojdfSXBHOHB+J9/Qyzh3FwLzJ65CVgg0ENQiKXSP+W5hKQ6GDqKH
         cAahEeIf+hhlPpNU9Jirb+lxrdpa3xclh534Vow2OwBLToSKNroDP0RV3tyzM1vybLQ1
         LhmuHh9xjDh2u/cD7pOhZ6hj5Jw/F+GpHJqb0fUpHVML0X25/EjYJZu4XLQ8iLb6rM0v
         ZJEGhParr3oXuT0cUI5GVvkoVaVSYVBZl/RiSBvzCMAtdY6ZkEJaCcGwZA7eawb2aPlP
         R2ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681899617; x=1684491617;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=veyUflwB7EJoqM/28xla7lPnPkRZ8RdCeVwU9yKVDyc=;
        b=dH2ar2lQ+fGnPtk0h/Bv44FM8tpJCLN/8wScQwnYjbrI/lH0UHY4muvvEE2FeZvQqV
         8P98iliDCb74OzzZzj0SgUMjN1io0IeuII5Tb917kosa3/mApaULrLYv+2sANQZ7duW6
         Iu4HALZBMrPHR6Y1O5+i4Mh9Nfkg6nHRjURp69gCgY1hYz7KI4eFCIsgmlEDAVImecbo
         gtdyM3cQrdHOBv8OlFPcaGdYaQxi543CXKLN23DjqY11qg2W/mM5GTP1mlj/4vFR1iZD
         r9sHg/uGRq5mBdjAdognrgIusP0GWU5Zfdzf0mYkpz2axw08wZCa2AMmDHH1xz369k7k
         uWKA==
X-Gm-Message-State: AAQBX9e+peeY3uzbqX/A53an6UzhqU641krixQolsCPKsdqXT5XB7nXt
        c36GL2z/3sSowArN/7x1jvvpVPzWfdufJGfCe+/FqJKJNYg=
X-Google-Smtp-Source: AKy350ZYGC12KiFn/PVE547lEHafu3D0jGbftuBq7GNN/0CMXmK2B1XK6qULEcF8vhtouFrPmTWAR6gUgYYaIcCKJpo=
X-Received: by 2002:aca:db56:0:b0:38e:4e96:1292 with SMTP id
 s83-20020acadb56000000b0038e4e961292mr834932oig.3.1681899617193; Wed, 19 Apr
 2023 03:20:17 -0700 (PDT)
MIME-Version: 1.0
References: <CAPzBOBNKPYFwm5Fq9hvEPPVk7RHjzPOO5gpnVXeT-2dgk_f69Q@mail.gmail.com>
 <878reourmq.fsf@toke.dk>
In-Reply-To: <878reourmq.fsf@toke.dk>
From:   Robert Landers <landers.robert@gmail.com>
Date:   Wed, 19 Apr 2023 12:20:06 +0200
Message-ID: <CAPzBOBOaTJ8y+CEL6Mvy1qORWRWVVeKnATA=fxeG+=+gFMNC3w@mail.gmail.com>
Subject: Re: Maybe a bug with adding default routes?
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@kernel.org>
Cc:     netdev@vger.kernel.org
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

On Wed, Apr 19, 2023 at 11:51=E2=80=AFAM Toke H=C3=B8iland-J=C3=B8rgensen <=
toke@kernel.org> wrote:
>
> Robert Landers <landers.robert@gmail.com> writes:
>
> > Hello netdev,
> >
> > I believe I either found a bug, or I'm doing something wrong (probably
> > the latter, or both!). I was experimenting with getting a "floating
> > IP" for my home lab, and eventually, I got it to work, but it requires
> > some voodoo, which intrigued me and I think I found some strange
> > behavior that smells like a bug. I'm on Ubuntu 22.04 (and Pop OS! on
> > my desktop), so it is also possible that this is fixed upstream (in
> > which case, I'll email that list next).
> >
> > To reproduce is quite simple:
> >
> > echo "1234 test" >> /etc/iproute2/rt_tables
> > ip route add default via 167.235.212.73 dev enp9s0 table test
> >
> > This will fail with the error:
> >
> > Error: Nexthop has invalid gateway.
> >
> > Now, I think this makes sense, however, the routing table shouldn't
> > need to know about hops, Right? Maybe I'm wrong, but this voodoo
> > results in a correct routing table:
> >
> > ip addr add 167.235.212.72/29 dev enp9s0
> > ip route add default via 167.235.212.73 dev enp9s0 table test
> > ip addr del 167.235.212.72/29 dev enp9s0
> >
> > I'm not sure if this is a bug or working as designed. It smells like a
> > bug, but I could just as easily be doing something wrong. I grew up in
> > "simpler" times and am not nearly as familiar with iproute2 as I was
> > with the old stuff.
>
> Try the 'onlink' flag:
>
> ip route add default via 167.235.212.73 dev enp9s0 onlink table test
>
> -Toke

Hello Toke,

I tried onlink but it did not work; packets appeared to never leave the dev=
ice.
