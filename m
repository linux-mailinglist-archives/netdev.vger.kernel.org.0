Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1AE06A10F3
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 21:00:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbjBWUAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 15:00:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbjBWUAK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 15:00:10 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4C765BBA6
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 12:00:08 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id p3-20020a05600c358300b003e206711347so303479wmq.0
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 12:00:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YBYRd2d8WmG2dl0aGeo9iN4zDz/8NsrntcMf+/KbIwk=;
        b=s7mX+womQoGnlIBQmi+29LjZpnMLCuomgqzvzsW8cxLJfuQj7e4gqgT1VcOLQCDFl1
         QHFY9SjfreVuigm92of0HoG2TyBw7jrXgN21QoG/Mx+aXk7P2zdzfGRejfid6T5D9O1j
         hiao6ykw6kC9loWtvRtB8EsVwRNb4JjmBtWhYQ2Qb9VibN9rjJSCxMfO0jShgly5GIWD
         YHULJdTkzYm7Fw5Iah6otw3C608pQxyElpwwqG+yQTfiaN64Ku8YXjRmQ0lEOTvGF/Xp
         fFYr7+HadlcydbZbphi6sjVznAazuNiapE3S8wZeJz4eCE60dLhb+MrRIKSQxsCA9wHl
         h3TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YBYRd2d8WmG2dl0aGeo9iN4zDz/8NsrntcMf+/KbIwk=;
        b=LOING5t0DIXu7E58Nazzqkgj2T2Ccg+EptN53s/LM81f10jMrWKyae7SJoPoLkeB1F
         3VjxMRTVPsdEJYCROq1KORNUWMr3pcsf6g3BdNsjXWeXWfmzggcjHMsBQtPHdiwOPdz+
         uuNh8VkrZ8xUVz5GNnvnS0tXWTgkYrcUtyTduhTSriOZDX46Rjv1C8l/cQCZL/cDGbtd
         Cj4+rH83W6q2oKMcIw1tBDBRjpwwTX6PNH5GpztOQRHinY+9P8KVTDLXHoP6JJtcCznP
         ic61x6mlkppZazu3vKK7tUwqC6yHIgkczHZoYRDqYJ1TMP/YjzJzKEmeYDdD4Y+S8YDE
         fMZA==
X-Gm-Message-State: AO0yUKU1F2WE0nMIdmaCimVHavh4rb3nFbxsXn9KR8LdwdZeW8mWV49j
        BGQ9/GkPhVrA146BrnkZWKwmp0yVmCUeLyO8A8KP6g==
X-Google-Smtp-Source: AK7set/BfW9ioasE2AZyyonimr1FV/Jr0L24Oq1bxTUpnZNLVBXnWRtdoVIw49jR9WDZ/Mwl6HsKmiB+REDeyASOBtk=
X-Received: by 2002:a05:600c:1d0f:b0:3df:97b0:baba with SMTP id
 l15-20020a05600c1d0f00b003df97b0babamr563268wms.6.1677182407053; Thu, 23 Feb
 2023 12:00:07 -0800 (PST)
MIME-Version: 1.0
References: <2d2ad1e5-8b03-0c59-4cf1-6a5cc85bbd94@cloudflare.com>
 <CANn89iJvOPH9rJ4YjRP-i99beY3g+moLnRQH2ED-CQX7QnDYpA@mail.gmail.com>
 <fd9d9040-1721-b882-885f-71a4aeef9454@cloudflare.com> <CANn89iLMUP8_HnmmstGHxh7iR+EqPdEAUNM7OfyDdHJFNdBu3g@mail.gmail.com>
 <CABEBQimj8Jk659Xb+gNgW_dVub+euLwM6XGrPvkrPaEb=9GH+A@mail.gmail.com>
 <CANn89iJvoqq=X=9Kr7GYf=YtBFBOrOkGboKsd7FLdMqYV0PE=A@mail.gmail.com>
 <CABEBQi=UQn11f7SzeXFSgorQCvj=CU43eNQX_UKcXR4HF-eM-w@mail.gmail.com> <c264614a-ec6b-8793-0513-d0ad8c58f745@cloudflare.com>
In-Reply-To: <c264614a-ec6b-8793-0513-d0ad8c58f745@cloudflare.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 23 Feb 2023 20:59:54 +0100
Message-ID: <CANn89i+gvwaCTmEVdAFSGvbHg+-tFtkm6g9X3OnxfKOft1M44g@mail.gmail.com>
Subject: Re: BUG: using __this_cpu_add() in preemptible in tcp_make_synack()
To:     Frederick Lawler <fred@cloudflare.com>
Cc:     Frank Hofmann <fhofmann@cloudflare.com>, netdev@vger.kernel.org,
        kernel-team@cloudflare.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        pabeni@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 23, 2023 at 8:00=E2=80=AFPM Frederick Lawler <fred@cloudflare.c=
om> wrote:
>
> On 2/15/23 2:25 AM, Frank Hofmann wrote:
> > Hi Eric,
> >
> > On Tue, Feb 14, 2023 at 7:59 PM Eric Dumazet <edumazet@google.com> wrot=
e:
> >>
> >> On Tue, Feb 14, 2023 at 6:14 PM Frank Hofmann <fhofmann@cloudflare.com=
> wrote:
> >>>
> >>> Hi Eric,
> >>>
> > [ ... ]
> >> Thanks for the report.
> >>
> >> I think the following patch should help, please let me know if any
> >> more issues are detected.
> > [ ... ]
> >
> > We'll give this a shot and let you know if we see anything else.
> > Thank you!
> >
> > FrankH.
>
> Hi Eric,
>
> We began rolling out the update on the 14th and haven't seen any more
> messages crop up in our logs. We'd like to check again after another
> week or so, but so far the two patches are promising.
>
> Fred

Thanks for the update, I will submit this formally then.
