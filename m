Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFCF34C8E46
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 15:52:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235416AbiCAOxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 09:53:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233998AbiCAOxF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 09:53:05 -0500
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 818D949930
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 06:52:24 -0800 (PST)
Received: by mail-qv1-xf35.google.com with SMTP id fc19so16767709qvb.7
        for <netdev@vger.kernel.org>; Tue, 01 Mar 2022 06:52:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E4qIR0gbcynkMM7ipUNgXxHtJnS+/1BP2qbABctPj58=;
        b=T3YPMIJe1af7lUTVV3bFe73oGWTJnD/WaKm7NT6U3TLybc38VVyUhFY/ZZk0vAUhv3
         NWZ3Fi28dMn7x3xi0UIXfGe9GXBY9OMv/TJ/itZNQSgmkVHk1a2b1hT/mU/SVXNcvrw4
         gY4FhSkdV9LQYeQjCjr+gZncH7wNtx1zQFNSjJcVZeiakOfpHAdqwKYivbHa9iavDZ7g
         EaYSyuli2AlRgvzr1kWd6PqOx5J4djFmV+JWk35M5myDqLV8IdWPIZrvE5hTIClcoFw1
         V0fr2p2ycUkvrZ4SKlaQBQzFCtiGK87NOfUjN5zZGhUqwi25A0dNMjz5AAMbqj6Dr7T7
         RS3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E4qIR0gbcynkMM7ipUNgXxHtJnS+/1BP2qbABctPj58=;
        b=xql9mSyPTkhKssJlfeoDJMu+SPuKDQBUnP4AvRMZ7bwsVid4pdj16z9vINwJg3VwBZ
         6FbaZenpUsmYHMEcBI+9+adRRw/lEDQwc1od8qQ1DmyeDldWXfFuPY7dIaycAEXdytt6
         QnJouuniWsCL/tqM373re5cQSCEXUFYmj86zwVf5dykuis/N5xPuavfvhUJFLPd0LiiN
         3pFCLTQIcF86ckYNo2sXVyx7G9Hev6czvVt62aC2c+tcIrlRtdweClxvjbhJb8rvPE9y
         r3HgBDQcirIteUfYQ/pXdVMjDvdyeoI7Kt+xpa3VGuxWBsmALZEWm+evjKf/wLQ7C6MF
         pORg==
X-Gm-Message-State: AOAM533UykKy+X9M5f9I6gtJIOWJCe7GsBZduBD3YfBZW/8YYzWeKQx/
        1OD7ftkD/bEgFi7S4ouV9wy4qVifN+Y=
X-Google-Smtp-Source: ABdhPJxH9+k2ZuVhCxUfw7eXSuLPimN0jVfR8DBqOD7xVDryjs3WVF1AUa/hsOQbb7/QkNlspJeQTA==
X-Received: by 2002:a05:6214:19ed:b0:42c:3b5f:cda6 with SMTP id q13-20020a05621419ed00b0042c3b5fcda6mr17562211qvc.70.1646146343688;
        Tue, 01 Mar 2022 06:52:23 -0800 (PST)
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com. [209.85.128.174])
        by smtp.gmail.com with ESMTPSA id v9-20020a05622a144900b002dfedb4dccasm8162330qtx.66.2022.03.01.06.52.23
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Mar 2022 06:52:23 -0800 (PST)
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-2dbd97f9bfcso29217847b3.9
        for <netdev@vger.kernel.org>; Tue, 01 Mar 2022 06:52:23 -0800 (PST)
X-Received: by 2002:a81:6603:0:b0:2d6:d166:8c31 with SMTP id
 a3-20020a816603000000b002d6d1668c31mr24731960ywc.351.1646146342611; Tue, 01
 Mar 2022 06:52:22 -0800 (PST)
MIME-Version: 1.0
References: <20220301144453.snstwdjy3kmpi4zf@begin>
In-Reply-To: <20220301144453.snstwdjy3kmpi4zf@begin>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 1 Mar 2022 09:51:45 -0500
X-Gmail-Original-Message-ID: <CA+FuTSfi1aXiBr-fOQ+8XJPjCCTnqTicW2A3OUVfNHurfDL3jA@mail.gmail.com>
Message-ID: <CA+FuTSfi1aXiBr-fOQ+8XJPjCCTnqTicW2A3OUVfNHurfDL3jA@mail.gmail.com>
Subject: Re: [PATCH] SO_ZEROCOPY should rather return -ENOPROTOOPT
To:     Samuel Thibault <samuel.thibault@labri.fr>, willemb@google.com,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org
Cc:     Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 1, 2022 at 9:44 AM Samuel Thibault <samuel.thibault@labri.fr> wrote:
>
> ENOTSUPP is documented as "should never be seen by user programs", and
> is not exposed in <errno.h>, so applications cannot safely check against
> it. We should rather return the well-known -ENOPROTOOPT.
>
> Signed-off-by: Samuel Thibault <samuel.thibault@labri.fr>
>
> diff --git a/net/core/sock.c b/net/core/sock.c
> index 4ff806d71921..6e5b84194d56 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -1377,9 +1377,9 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
>                         if (!(sk_is_tcp(sk) ||
>                               (sk->sk_type == SOCK_DGRAM &&
>                                sk->sk_protocol == IPPROTO_UDP)))
> -                               ret = -ENOTSUPP;
> +                               ret = -ENOPROTOOPT;
>                 } else if (sk->sk_family != PF_RDS) {
> -                       ret = -ENOTSUPP;
> +                       ret = -ENOPROTOOPT;
>                 }
>                 if (!ret) {
>                         if (val < 0 || val > 1)

That should have been a public error code. Perhaps rather EOPNOTSUPP.

The problem with a change now is that it will confuse existing
applications that check for -524 (ENOTSUPP).
