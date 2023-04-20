Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A28C06E9D9D
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 23:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232322AbjDTVBx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 17:01:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232324AbjDTVBu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 17:01:50 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AB9A4691
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 14:01:24 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id 3f1490d57ef6-b95c3b869dcso1337843276.1
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 14:01:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682024483; x=1684616483;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dePTgJobju6AfQ+CHovsx3bs8VAEwW8KdaWJ4nAJj+I=;
        b=35MwXhkrrxt+crK8gcS7Id6Q1CEOfmNL1K3wt02EtdPhS8S2FMy+1FrnzJoVDoYlKB
         iNxUUDCXCatASfU83MskVzatb3gHO+E4dEHCs6PQmE+DBPZWVX2fHm8B02uVfS6X2qnZ
         tTydwIvQ3Fs9DDW4C66G5M0hNNLFiItN+FHQQoFn82I5f747MG79fo1p1CYJsfs8A7hP
         /4jrgSSjA1wcRQPXCy0GGQXZBWZdQx3MSy98As8k9877Hv1eksSloFxjPVgf1YsQDlog
         kI8e98+29xCIkbkhJwsKea9XIcz5tUe2M2ck5anVTnN/MJbM7BZTVOKc7jMmwMLqZtR+
         DLog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682024483; x=1684616483;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dePTgJobju6AfQ+CHovsx3bs8VAEwW8KdaWJ4nAJj+I=;
        b=XC8bTyZYwowByBzq2a53oDBHIbFmqkWFPCBVpNSrpvH+kdF94lTb+VJ0TfR+LEPHWY
         7qUbhKqDpb8mMmX3aAc6lvwvQEG8dFu3Z1olY4zTcaXosr18sO3z4YXRaBb6CurBlCIX
         LCsX2UPaZCtgZ/WB1K3rJVpLcNxXlwFRqEQRjF2IFcIImv953KXT5AMhgi8vdnVXqKqG
         AsPMNneWEVWbMdspNRR9BgfuZp2jaR9cdfEZKjrHWaC40Yott/d3Zq3tTuE06VDPmidB
         qLZpuAAFowHA036ZfYPApUzPIrdI8nfREDYQtzutKTJJ+10D60yv8q+cFJvlmdoJ3yI7
         ySeQ==
X-Gm-Message-State: AAQBX9cAnQgem6aDA/ElJ8hqcUdTwvd0kTcAGZn/lztDKLrd5+wqh/nL
        V8owxxBUx7KDwRJtRd50Nfnt8Ai+5vdBX44tTAZtrQ==
X-Google-Smtp-Source: AKy350aodWvqe/UjUphsSuyYG8nj66TjGcmC3orhLTU8jOgYg1H+RrBXvpKfK5OhpvuwfQvThhbYSSkS0RoRMr4sAHU=
X-Received: by 2002:a25:26c7:0:b0:b92:40f8:a46f with SMTP id
 m190-20020a2526c7000000b00b9240f8a46fmr247206ybm.2.1682024483279; Thu, 20 Apr
 2023 14:01:23 -0700 (PDT)
MIME-Version: 1.0
References: <20230419013238.2691167-1-maheshb@google.com> <0097c9fc-2047-fce3-7fc1-b045f58226d8@kernel.org>
 <CANP3RGc1+XGjh3b=hT0qZHiJfLwoLctVgbEBd3f-9CYe9od6EQ@mail.gmail.com>
In-Reply-To: <CANP3RGc1+XGjh3b=hT0qZHiJfLwoLctVgbEBd3f-9CYe9od6EQ@mail.gmail.com>
From:   =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS14KS+4KSwKQ==?= 
        <maheshb@google.com>
Date:   Thu, 20 Apr 2023 14:00:56 -0700
Message-ID: <CAF2d9jjBTGsS7HFY=Twg09DhvZrq6vA6ap9bOyDvKM+tXb-B9w@mail.gmail.com>
Subject: Re: [PATCHv2 next] ipv6: add icmpv6_error_anycast_as_unicast for ICMPv6
To:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Cc:     David Ahern <dsahern@kernel.org>, Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Mahesh Bandewar <mahesh@bandewar.net>,
        Kuniyuki Iwashima <kuniyu@amazon.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 20, 2023 at 12:12=E2=80=AFPM Maciej =C5=BBenczykowski <maze@goo=
gle.com> wrote:
>
> Reviewed-by: Maciej =C5=BBenczykowski <maze@google.com>
>
> Though I am wondering if it would make more sense to put the check
> inside ipv6_anycast_destination()
> 'treat_anycast_as_unicast' or something.
>
I prefer the current form as it maintains the current semantics of
'ipv6_anycast_destination' which is used at other places as well.

> On Thu, Apr 20, 2023 at 8:55=E2=80=AFPM David Ahern <dsahern@kernel.org> =
wrote:
> >
> > On 4/18/23 7:32 PM, Mahesh Bandewar wrote:
> > > ICMPv6 error packets are not sent to the anycast destinations and thi=
s
> > > prevents things like traceroute from working. So create a setting sim=
ilar
> > > to ECHO when dealing with Anycast sources (icmpv6_echo_ignore_anycast=
).
> > >
> > > Signed-off-by: Mahesh Bandewar <maheshb@google.com>
> > > CC: Maciej =C5=BBenczykowski <maze@google.com>
> > > ---
> > >  Documentation/networking/ip-sysctl.rst |  7 +++++++
> > >  include/net/netns/ipv6.h               |  1 +
> > >  net/ipv6/af_inet6.c                    |  1 +
> > >  net/ipv6/icmp.c                        | 15 +++++++++++++--
> > >  4 files changed, 22 insertions(+), 2 deletions(-)
> > >
> >
> >
> > Reviewed-by: David Ahern <dsahern@kernel.org>
> >
