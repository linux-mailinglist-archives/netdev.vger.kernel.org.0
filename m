Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A701D6BC0B4
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 00:16:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230504AbjCOXQ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 19:16:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjCOXQY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 19:16:24 -0400
Received: from mail-yw1-x1136.google.com (mail-yw1-x1136.google.com [IPv6:2607:f8b0:4864:20::1136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C725495BCB
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 16:16:23 -0700 (PDT)
Received: by mail-yw1-x1136.google.com with SMTP id 00721157ae682-54195ef155aso219405197b3.9
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 16:16:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678922183;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xCc1a9dsipadDTGSfZXbGsEj4DN+3nKXBHkRg9URAfE=;
        b=BX9Cc3K23pS0dOYG+63WiSzdcCWsFIf7dtPd1KZO4G5WJEefHYFcSrBOmM7zJ4Layd
         wtPxuR54+by+30bFxgqNta9fHKGqMaBeMLZUMu8imicijGuttiypxnGUQpXtVHSkkmav
         EnZKV51cNAA+aImdgWEDPFDRNKV7LxljWnlL8Wq/6jvCp5drYYRrYAtbDhrzRRrndNpz
         wFyCtsmjWPFfLQEecCa7ub09bTBzaBzB5VFg7roKKmXtr9iztsR3QjW59Q2VdmrfW8ji
         oq3st1kkxvpdiJcXrSu1oAz9NI51zWI4yXGe2DEFsv9fkC7LtRBHovw2GRMx7ube9U/7
         i5CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678922183;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xCc1a9dsipadDTGSfZXbGsEj4DN+3nKXBHkRg9URAfE=;
        b=Rv7CiNmvYCGYTJwuDSx2JOrwnz3GS/+Ip2ep9dfPkRbe4Nh69Sz/Xim/Ucf2nRB78B
         aEz75EKmg/nZTyUm3u2Hp5tDQmCLza54r2vlpzUo3os2rMPprqmZFp82tZIjfmN9AGCX
         pVcp6DxY7+h+HGrTdBpG24Ped9J7uZOL8gnfLo6bnrFBKOvNgozyYCEHDmy41TPNXG6f
         OUHFbU2/o27T/3THCo/Va5Nn52OzRuw3Lv9si5JZRaykp3dJqjLUaz2NqPRj0cR7ApHL
         0zJxL6dB22S6cqy6ZQB5UqhuZ9ebnkdota/XnjkZlKJeesv9pWAmPf51GSc8hHojJcJG
         abEQ==
X-Gm-Message-State: AO0yUKWLw8gUjW5iqQlr77rAd/iRI5iCwQw3sjlNqoilW6iCI/yY96hm
        Y9fW5lyFW9CFqRiLL8gLF/ILPBHY2wnvCgFUd+DvIg==
X-Google-Smtp-Source: AK7set/LWU8Sp6VTX4BVJfDAmz+uEScqtEOQBMv5XhvX+3EO6oOx9CGjAYSMmMvMAkbr/MJ7aFyPSu9c4nEAgqNNgX4=
X-Received: by 2002:a81:b247:0:b0:536:4194:e6eb with SMTP id
 q68-20020a81b247000000b005364194e6ebmr991649ywh.0.1678922182770; Wed, 15 Mar
 2023 16:16:22 -0700 (PDT)
MIME-Version: 1.0
References: <20230315154245.3405750-1-edumazet@google.com> <20230315154245.3405750-2-edumazet@google.com>
 <20230315142841.3a2ac99a@kernel.org> <CANn89iLbOqjWVmgZKdGjbdsHw1EwO9d_w+dgKsyzLoq9pOsurQ@mail.gmail.com>
 <20230315160828.00c9cedb@kernel.org>
In-Reply-To: <20230315160828.00c9cedb@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 15 Mar 2023 16:16:11 -0700
Message-ID: <CANn89i+8fCgDZ40S+uawyr0Y+Hhq=rDRULkmo+6neFqozWUZZQ@mail.gmail.com>
Subject: Re: [PATCH net-next 1/8] inet: preserve const qualifier in inet_sk()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
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

On Wed, Mar 15, 2023 at 4:08=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wr=
ote:
>
> On Wed, 15 Mar 2023 15:37:50 -0700 Eric Dumazet wrote:
> > I did see container_of_const() but the default: case was not appealing =
to me.
> >
> > Maybe something like this?
> >
> > diff --git a/include/linux/container_of.h b/include/linux/container_of.=
h
> > index 713890c867bea78804defe1a015e3c362f40f85d..9a24d8db1f4c46166c07589=
bb084eda9b9ede8ba
> > 100644
> > --- a/include/linux/container_of.h
> > +++ b/include/linux/container_of.h
> > @@ -35,4 +35,10 @@
> >                 default: ((type *)container_of(ptr, type, member))     =
 \
> >         )
> >
> > +#define promote_to_type(ptr, oldtype, newtype)                 \
> > +       _Generic(ptr,                                           \
> > +                const oldtype *: ((const newtype *)(ptr)),     \
> > +                oldtype *: ((newtype *)(ptr))                  \
> > +       )
>
> Perfect, I'll defer to you on whether you want to patch it on top
> or repost the series.

I'll post a v2 tomorrow, thank you.
