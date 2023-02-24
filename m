Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 691996A1DD5
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 15:54:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbjBXOyo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 09:54:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbjBXOyn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 09:54:43 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C21E1514F
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 06:54:38 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id m14-20020a7bce0e000000b003e00c739ce4so1884263wmc.5
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 06:54:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yQ7Am+GWnz8QGRXQmBkVN1ADxLw1p2SLAtS8DFY4DiQ=;
        b=LInwxZVwv2rNqAZyMDKG43EYaACxFQ7EmebZU2raroCSzylGf9wT6NSwWYARjRS+uy
         5X4cyId0xMsqiyiSVzTMu05RV1LpdH0jR8GW50IcX3PhBlUnBKPt3vwOBay+7hCHohup
         Ub2J+uSjzrhvdgFUeniHq/QxhWElP7jMk/uhgg+mwunT1AAkPXzX6Le+fKqrKJUDVbAC
         DoRPER7MTzIMKLggKvaryyFgEr5y01S8E3Xq0P4/9Ia48RLGsEMwrLwLl8re4ErVU6wB
         xjznNudk/UKp+ym0c/YNxfogCoxSibpWPRS4OPhxHsT3WjxzLbZiW1ErMtqOltyWT9Ii
         A0UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yQ7Am+GWnz8QGRXQmBkVN1ADxLw1p2SLAtS8DFY4DiQ=;
        b=on3YxPAe4AKI3BtGY1j8pFjhmddKNYHbSWzh1pI7m10ww77aP/bNHQKwJoOncrj1E/
         +/Dhoz6IEhZBYekWdwibKHPpFXdByf3rfMX55sCCCp1ms68uggVjrc38bXtxyI0ghOEo
         kXs/f0kale2QdHjVtpBeU2zj+lsO85qamsAa5gTkjFIEQkcMLCY/WTvRzes85YqNvNSo
         jHf7d/IPdYK/9bEm8zo+y+W6Rlv8hapWfa76BoCmecQl3Tj+LRUG43NrmQVahCrtgWiK
         33XxWQLjiFmnBQi7OGXyAQIJO6aT1lSXUVQYIKA1NkRUefUQSR02e/Tr3Z5bmTkj/JlN
         EUDA==
X-Gm-Message-State: AO0yUKXfMwUzsF9HaiZ8t0zwtn/gGiGoBgNcYsJDbuzl1JzYGifCi6Qt
        1niOF/7N3NAScWuk530YSasmowTQ1o4Cvn/yznO94Q==
X-Google-Smtp-Source: AK7set99+PwHY3agYgF8AUOy3NeWhLlE4CwJ0hpAt/QaZZrTqBWhjDWuhGJVnomL17cV7m19Rf3hQJw/3FItN++PtPo=
X-Received: by 2002:a05:600c:4f55:b0:3e1:eaca:db25 with SMTP id
 m21-20020a05600c4f5500b003e1eacadb25mr1401305wmq.6.1677250476421; Fri, 24 Feb
 2023 06:54:36 -0800 (PST)
MIME-Version: 1.0
References: <20230224071745.20717-1-equinox@diac24.net> <CANn89iL5EEMwO0cvHkm+V5+qJjmWqmnD_0=G6q7TGW0RC_tkUg@mail.gmail.com>
 <6a4ebf7b-63c9-34b8-cff3-5b2312762972@kernel.dk>
In-Reply-To: <6a4ebf7b-63c9-34b8-cff3-5b2312762972@kernel.dk>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 24 Feb 2023 15:54:24 +0100
Message-ID: <CANn89iJE6SpB2bfXEc=73km6B2xtBSWHj==WsYFnH089WPKtSA@mail.gmail.com>
Subject: Re: [PATCH net-next] packet: allow MSG_NOSIGNAL in recvmsg
To:     Jens Axboe <axboe@kernel.dk>
Cc:     David Lamparter <equinox@diac24.net>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
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

On Fri, Feb 24, 2023 at 3:32=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
>
> This looks fine to me. Do you want to send a "proper" patch for
> this?

Sure, or perhaps David wanted to take care of this.

Thanks.
