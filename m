Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 596E86E312A
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 13:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbjDOLyK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Apr 2023 07:54:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjDOLyJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Apr 2023 07:54:09 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBEEF4C26
        for <netdev@vger.kernel.org>; Sat, 15 Apr 2023 04:54:07 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id h10so654636ioz.10
        for <netdev@vger.kernel.org>; Sat, 15 Apr 2023 04:54:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681559647; x=1684151647;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FkjcrkevaHRZu0RSR3d/4wmIPFePEY/n+PajfUzR8hA=;
        b=a+3liXDdANha2pi65UTL2eRLwhC8MvMMyPScbngaPMsBx57Boc7ptIPKci93d9KF0A
         dGE5iQYpoaq3Q5teMtTZvcFF4F+Q78R2/+WtJfiNTJ9qTq2sOgzR0K0LZDvXdIYBKrfG
         e1jVU6JanANYa72hZm+HvXDJ3EZJ/xF7rJp3i+5ktXygd04fqmUKsWg8smvM7BC+lBxY
         C5DUQHK6zCkvfYZl8f+hebxN8U3bqzyzsw1cCmAhUlGpluAOylzJXGvju8gE22tSxNJ9
         5u0Qj55LIgNpQAS/NtZwQE1B61w3eOhsci9u0OfGZY5nKqQfXfhCXW2ENGdI4pzuRH0l
         GdzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681559647; x=1684151647;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FkjcrkevaHRZu0RSR3d/4wmIPFePEY/n+PajfUzR8hA=;
        b=QacAT2T3KigNCzHk1j8Rp5f0Gl2A/QGUh5oqN4Y0upLCnbkP42uUG6MIZh4V4dKaRV
         E5q0jfSaXSdZ1GnxspSyjXJdhmZADED6kdEGXMFJ2dNSYkqrs4DG++bYTD0cIKuvHTqT
         Ukbb7NB4if9e31kzJHhTtEwHeadi/ftRuc5jwt4a/Lk3D/uC60hUGdP9sqEz1ETv2VX4
         rDoy5G9p/LLljJVGmWRjNkaA0EmMt4wtdeU70bPbJ1G8LZuhUZoSBZ1X0RHrcxl9SJos
         B5+pJDKF1kgtRSz/68F73SE/AsYGj6+eIt/vxOjibT8I2gUJTNc3RoB46EJY6ApqemF7
         kXHw==
X-Gm-Message-State: AAQBX9ejKzBM0D5Wd9Ow3ZVUkE5jyXF5xSTULzL4Du8hWVgpZUBIjBWV
        iml0y/wyFHGU80nFzSILBXpLDNnhNydc+l6CQgBosQ==
X-Google-Smtp-Source: AKy350aqJiiACegF2I2EYPGKMleX+1Rzm2N81NkjKp/2z2L+BBwfVQ1levvKsUW4YqbAAPeNNIONgZnBj7uE6DBFfeI=
X-Received: by 2002:a02:7a5c:0:b0:40f:8d6f:748f with SMTP id
 z28-20020a027a5c000000b0040f8d6f748fmr1363092jad.1.1681559646875; Sat, 15 Apr
 2023 04:54:06 -0700 (PDT)
MIME-Version: 1.0
References: <20230414160105.172125-1-kuba@kernel.org>
In-Reply-To: <20230414160105.172125-1-kuba@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sat, 15 Apr 2023 13:53:55 +0200
Message-ID: <CANn89iKD-PUp0gGVBs=WwR_w5OCYMVJM43L3azP-2iBqXYKFjg@mail.gmail.com>
Subject: Re: [PATCH net-next 0/5] net: skbuff: hide some bitfield members
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, pabeni@redhat.com
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

On Fri, Apr 14, 2023 at 6:04=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wr=
ote:
>
> There is a number of protocol or subsystem specific fields
> in struct sk_buff which are only accessed by one subsystem.
> We can wrap them in ifdefs with minimal code impact.
>
> This gives us a better chance to save a 2B and a 4B holes
> resulting with the following savings (assuming a lucky
> kernel config):
>

Reviewed-by: Eric Dumazet <edumazet@google.com>
