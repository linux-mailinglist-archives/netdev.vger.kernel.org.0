Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E15235A0C94
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 11:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239950AbiHYJ2M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 05:28:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237349AbiHYJ2C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 05:28:02 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C4E3A4B0A;
        Thu, 25 Aug 2022 02:28:01 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id q18so17833125ljg.12;
        Thu, 25 Aug 2022 02:28:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=bHJbCxqGrMvRJ8HABrOLQY8kdlTtP1fT6llzjdoahEI=;
        b=F6dgYpp2CWa9EjXLyNUb2hkEr++WEmvoD1Es9jHGjD3nl2s+cUcKf5qo2cYDMhDudh
         IMnajyC+ijg09SfazUHsyiO0CJsRSfB0wPEfyb0993Y1r4EIbJi/1LdCi3HDAa2NJJ8x
         +zC5tDOVxxCwf6bf8VbNmzwnczL/SPqiYvkU52CUK7TS4elW2cXs3FEUXudhl83S8u0e
         SrcF8UkWbV35NopLBg8rBAeTUzSBCzzYntRNyOVr8P409yXN8j/WZFl0g97yIgcnKXs1
         p38SZYMTy2HmGrbnncEsoQwuSsGvytdaxcgP4HxRFbYOOD0lP9V8LJKk3fFJvFeIQvoT
         SqiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=bHJbCxqGrMvRJ8HABrOLQY8kdlTtP1fT6llzjdoahEI=;
        b=R70juOU0TZ9gLbX2BipB38LuUSDYFWfiARCxU9idVW5wvqDp4piQ0V+Cc/RAz5MTod
         rUxqbSLs53l9TkzUwAQ/ZGqJL/T+LrQrUgYvIT9xoV2vkIiKdcqMdVm4JW2JjMUuQKr6
         sycDa5QQVuvgbpoqPtIIY3oP9k2Nh9mf0Fj15LE74zx0pkaCaGHNB1GAsvQVhR/Ws0mE
         I+/SJbvM3zsbRPrkF/mE7ztNDQ72iIxh4oEoWwmKMsHovB44Tfd8MEAch6RsHfdzQ00x
         21rzPuN7281bQffBfVX6AY28ce9Dtwf9hASyNCjrhhnpZDS2V/qHQ1cOQ2k0ykj+T6YP
         QPPA==
X-Gm-Message-State: ACgBeo2SEXae4RP46q+6S/Tj+qclO6MOprNmYSv5uIUYTyb5dD+Enpt+
        VpWaM5LLZxHl7VF49ynvtBgcowwCC6RXXpt7AZ8=
X-Google-Smtp-Source: AA6agR450TIsqiag2S5eMHMXUw3UgJhUL8vxaf3i2cYKpNtvBGspRhj5eXNHGG8OC2gIZZGSa5KIZ8mmRqy62CUTnLU=
X-Received: by 2002:a2e:b0ca:0:b0:261:d46a:4672 with SMTP id
 g10-20020a2eb0ca000000b00261d46a4672mr775822ljl.460.1661419679767; Thu, 25
 Aug 2022 02:27:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220719123525.3448926-1-gasmibal@gmail.com> <20220719123525.3448926-3-gasmibal@gmail.com>
 <a3361036446058fe386634a9016c6925146a078e.camel@sipsolutions.net>
In-Reply-To: <a3361036446058fe386634a9016c6925146a078e.camel@sipsolutions.net>
From:   Baligh GASMI <gasmibal@gmail.com>
Date:   Thu, 25 Aug 2022 11:27:48 +0200
Message-ID: <CALxDnQYpA+cpUufxkpyqT=JjZUap-i==bn=r2Z3K2Oayh9QhTQ@mail.gmail.com>
Subject: Re: [RFC/RFT v5 2/4] mac80211: add periodic monitor for channel busy time
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "open list:MAC80211" <linux-wireless@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>,
        Toke Hoiland-Jorgensen <toke@redhat.com>,
        Linus Lussing <linus.luessing@c0d3.blue>,
        Kalle Valo <kvalo@kernel.org>
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

Ok, noted !
I will try to find a way or maybe remove this part, since the busy
time is not trivial to be used in the estimation, as I thought.
Thanks for your reply.


Le jeu. 25 ao=C3=BBt 2022 =C3=A0 10:58, Johannes Berg
<johannes@sipsolutions.net> a =C3=A9crit :
>
> On Tue, 2022-07-19 at 14:35 +0200, Baligh Gasmi wrote:
> > Add a worker scheduled periodicaly to calculate the busy time average o=
f
> > the current channel.
> >
> > This will be used in the estimation for expected throughput.
> >
>
> I really don't think you should/can do this - having a 1-second periodic
> timer (for each interface even!) is going to be really bad for power
> consumption.
>
> Please find a way to inline the recalculation with statistics updates
> and/or queries.
>
> johannes
