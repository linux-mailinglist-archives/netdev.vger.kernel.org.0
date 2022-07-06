Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B489568ADF
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 16:07:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231311AbiGFOHd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 10:07:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbiGFOHc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 10:07:32 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EC8D13D54
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 07:07:31 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id e69so20926663ybh.2
        for <netdev@vger.kernel.org>; Wed, 06 Jul 2022 07:07:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=j0ENyPdPKZXwGz5eJQ3ds5ewITLKdJ4nBN8Y+yiBJOE=;
        b=bHoiH/K7Nv+Lr1LUtMhPBAfCZ7pnMjY5jEwpN7wVceagFH/hwyUWe7KFlAcDXXJd5J
         g3SE8YWRZ1y/FPxHWROzxgNaIvz3ueXg1nAAuhjFPnkngy6eXj5CytcXmW0fxS3MdnVL
         x01hWFppktJpbgaQdbfotgG8oJId1/tBAnnLhkLwQ+6JhmWHx7Ji7qeTxksRleBpLqRK
         rJ13nAveaaPavJIXmol4d5CegkWB7zuc49XbyAFu7ECSE7odQs/0+8IQD9NAaitWzkEP
         hkPRMNi5GHTSzKMpnEBHdrqKXROK94NdF+POkstkQunqEY3xUzgD8UPvKn3Mm9t8NzvT
         VvFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=j0ENyPdPKZXwGz5eJQ3ds5ewITLKdJ4nBN8Y+yiBJOE=;
        b=rizvRvQrlqu+H+7kxIUqlGnke3cKTITuzH/ltgTOv9IwZONuWTvKrHNZp+5tdsmzK9
         xUqkxHLpDdI1vWZf9I48YYhgAqD9KEaX3Uqz4rmg7i+DmYGdnaMRtvLGCPGwkD0tYcZ5
         RVP83U0UsD2TjIaLoGzL6nIkIRry33jGzC5Y1NNXXDWmhZlC1amZBDpxHkLMR71gKevm
         7zj/mMx29n0l+toL6ZrbxEp1zAXom8SUW7ecqrX9PjmQUfJXedF6XRBl31zJomdSWYBT
         5aQD5sPjZ1P0twbuz7M2gnSSqmm049IkpZ+2eljqsFkAWO/zkHPKmuDGEFeIk1JkyWxt
         MR+g==
X-Gm-Message-State: AJIora9VY0NC4THxV4wR31Qkr5upXnTwCjMPIg1Xy+djajtEHMOL/ATt
        80fl6LfVFAb8mAV98WlsI8FQvpiPmga9Hrgsp7u6Zomw4urzVQ==
X-Google-Smtp-Source: AGRyM1u2irXR8287sy9xI2iDlMtIEXP2RFys3kkdSjKn0I3DKoab1wNcrMCuPSiuV9H1EyzTU9uh62quAnuh+9DCq8c=
X-Received: by 2002:a25:7455:0:b0:66e:2daf:8924 with SMTP id
 p82-20020a257455000000b0066e2daf8924mr24222994ybc.427.1657116450413; Wed, 06
 Jul 2022 07:07:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220621202240.4182683-1-ssewook@gmail.com> <20220701154413.868096-1-ssewook@gmail.com>
 <7dc20590ff5ab471a6cd94a6cc63bb2459782706.camel@redhat.com>
 <CAM2q-ny=r-U-6n6F+02QON1B8NHJ5TZrrOa7x3CAfkrUtRWnwQ@mail.gmail.com> <2c4816a4f5fbd5c8f4f6ad194114d567830de72d.camel@redhat.com>
In-Reply-To: <2c4816a4f5fbd5c8f4f6ad194114d567830de72d.camel@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 6 Jul 2022 16:07:19 +0200
Message-ID: <CANn89iLfvNVW=x27HXawWYVXy2rjtRXYEtaRdP41WvSoQ4LrLA@mail.gmail.com>
Subject: Re: [PATCH v2] net-tcp: Find dst with sk's xfrm policy not ctl_sk
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     =?UTF-8?B?7ISc7IS47Jqx?= <ssewook@gmail.com>,
        Sewook Seo <sewookseo@google.com>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sehee Lee <seheele@google.com>
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

On Wed, Jul 6, 2022 at 4:02 PM Paolo Abeni <pabeni@redhat.com> wrote:
>
>
> Hello,
> On Wed, 2022-07-06 at 03:10 +0000, =EC=84=9C=EC=84=B8=EC=9A=B1 wrote:
> > On Tue, Jul 5, 2022 at 5:25 PM Paolo Abeni <pabeni@redhat.com> wrote:
> > > If you are targting net, please add a suitable Fixes: tag.
> > I'm targeting net-next, and will update the subject.
> >
> > > It looks like the cloned policy will be overwrited by later resets an=
d
> > > possibly leaked? nobody calls xfrm_sk_free_policy() on the old policy
>
> > Is it possible that a later reset overwrites sk_ctl's sk_policy? I
> > thought ctl_sk is a percpu variable and it's preempted. Maybe I might
> > miss something, please let me know if my understanding is wrong.
>
> I mean: what happesn when there are 2 tcp_v4_send_reset() on the same
> CPU (with different sk argument)?

This is not possible, because we block BH

local_bh_disable();
ctl_sk =3D this_cpu_read(ipv4_tcp_sk);
...
<write over tcl_sk>
local_bh_enable();


>
> It looks like that after the first call to xfrm_sk_clone_policy(),
> sk_ctl->sk_policy will be set to the newly allocated (cloned) policy.
>
> The next call will first clear the sk_ctl->sk_policy - without freeing
> the old value - and later set it again.
>
> It looks like a memory leak. Am I missing something?
>
> Thanks!
>
> Paolo
>
