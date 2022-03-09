Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D38E4D35C8
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 18:42:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236329AbiCIQrX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 11:47:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235962AbiCIQpq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 11:45:46 -0500
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6CFFFCB5B
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 08:40:53 -0800 (PST)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-2dbfe58670cso29643467b3.3
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 08:40:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mMGy96gwds/LgOWS0fSGRPSUvKRInK96S8xDcxzTAyc=;
        b=L8FrgFxcd6uTRU9jhfZZIvFYaCqgyU03YZXrrtiJ4ySHKJ4oBmhJj9c6WNImcN9olX
         SK0qHGWVbuQ7QI/pXvorEfwDHp8ApErBV/UsHqh+yPFSUvn8GraYCyyoVt9s9Va2TrmQ
         8zyolC1o625zRyCYHlVbgXV9GKTQZK8iWj78ynS8wJATRyDTI07adNJC+ao0n+5LHIPm
         DDj+XXKgqZUEk3h21PqCCqo4QGUBCBHRloqPAsDw4a3gLTv62y7cw56FkU+MmRTaHXND
         OYJJqi2V4TiYVcS+2B3UZqGHGWTdrIno1nmXY1iH6cbefp4DQfpUBJUAfIzHWCV/ktU5
         YdpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mMGy96gwds/LgOWS0fSGRPSUvKRInK96S8xDcxzTAyc=;
        b=0YmHSpmcZoMAN0yiRaYN/CjMfKmXvYXROdGZS00PGD8l1hjuBZyBK8WC599iMG6DeV
         yMga15+XibBM4tO5CfJ9+6NP7Fh/DX1fOWyw4BU/GDXOBHcVR8/IBq4EZo4rmokwEKXs
         E7Da2z5utHO63ZUSyWNiW1HEgln2PCZziGM4K+dag411fSvpMkQC74S1WF/EWK/hJnyn
         kBdkXfCkoW1DHr10mFqWDPoMYZtR8DPfjBnNqUWZETIddy5mhvqD7SgSt3okMU2FB7Xs
         4BflGDr+lzifAlpRGKGlTp/H+lYf95eJs+VMEAaTrWilnwIuTVyoEVYQ0PuuKv3tQojr
         9Eog==
X-Gm-Message-State: AOAM531NA2RnCERPmwWHsXSXZg+oPoNxkigGgzoAXIVU72evJ7gyi2by
        LhAaXhnQ1hmuOeksLPza5qEdI01mSosGhfK2VNLo8A9AG3pfvw==
X-Google-Smtp-Source: ABdhPJyu+/dKd00qskeXLjccjdLSM6frQ3A8w+yn1MWsPN1TFBiH4C3/7bLPMOT+4UqJcUo0yDHNAPQ8WCqfiEATNAk=
X-Received: by 2002:a81:a743:0:b0:2dc:6eab:469a with SMTP id
 e64-20020a81a743000000b002dc6eab469amr552094ywh.332.1646844052637; Wed, 09
 Mar 2022 08:40:52 -0800 (PST)
MIME-Version: 1.0
References: <20220309162837.407914-1-kuba@kernel.org>
In-Reply-To: <20220309162837.407914-1-kuba@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 9 Mar 2022 08:40:41 -0800
Message-ID: <CANn89iL6gLjLE=1=3ysUwJ3DeTjtCROj5rEvxXkW1xLHGnTf8w@mail.gmail.com>
Subject: Re: [PATCH net-next] tcp: fix build problem in tcp_inbound_md5_hash()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
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

On Wed, Mar 9, 2022 at 8:28 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> Semicolon snuck in, this breaks the build with CONFIG_TCP_MD5SIG=n.
>
> Fixes: 4be98688274d ("skb: make drop reason booleanable")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>

Vladimir Oltean sent the fix earlier this morning.

Thanks.
