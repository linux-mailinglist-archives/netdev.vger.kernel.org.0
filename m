Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCE3C55C65B
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:52:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238427AbiF0Lxj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 07:53:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239041AbiF0LxF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 07:53:05 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48344BC14
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 04:47:38 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id q132so16236572ybg.10
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 04:47:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sYQeWp+d/TDh1H/J2tAI+oPQ1oT8ub0d1dZxrLNepr0=;
        b=UPzvybY0bUlTHioTVtlg1r6HIBbwwz/d3MemQOdMhEBUDWAYwzK9gjvr7nukp+W3om
         FPunTbjw+RmMAICaPiA5Qz57ge5thTtCBR/RXgKhGqFdnS2/dcRN0ignpFzzLSV/AYbv
         voKglgXJeOIrRcZiCHI7cZVJptRpIBYziO4rzpJD4BGPSBcZlIZhiMT7uq3SJQvODjld
         4a3PRy8QlV22PLYG8eXjiirzDutcbu/Bf6vNTZSqIxn5aGdjig/3TzwSTy3s4pR3kXzS
         4yynoJ1AQD6TUGL1mvfRnyeg7u0psa+mneEmhJIXHIUmP1R7B1bpKs6LitQkd07e5xUF
         qIfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sYQeWp+d/TDh1H/J2tAI+oPQ1oT8ub0d1dZxrLNepr0=;
        b=W5FpLM/icaavwOpF9tXq0Nud6EM8Pea+YDx2iLNEp7iINaXkgJECm9YgrV1vnH6rYm
         G4k4WxLvUUElk6hHlsGlH/dy9xPSZk/1ebx41UBcaSXjing7N92Ka9VM+ksRjcYy3j02
         kEg6K+XYSXqV78RZd82ejkQNBxQ4x519jC1HDJhLzrLo9RELxuXCU96DU11QjL29Sx3r
         cHzl8fkoJ90wid11Q5cFryAKzEiGsaGQtwWzEQ/uXIHm18P+erXQz7HRoYvAlKhsGYEH
         ECYcTQssr7XdXOpap8dpTUSeFDjEc3+mvjMWgxnF4lAK3E2s5BfBFUyRch4V7fMARW2F
         o67A==
X-Gm-Message-State: AJIora8jBB/re9xb2FXwsUmylvuVNLzyhYEWfvp3yf+ZnulDlfbuLH3+
        /Gd9aZWNoe5+b7jEETjsDKUX2wl3NBnKB1LdRkgDTo7QkLo=
X-Google-Smtp-Source: AGRyM1vsb3IWmoRSnGZh3ttsZ3YpojKFr+QijIvG7tlw3HK3Vcfo9jwOLrfH13sj2GW9udIyiw+Gv5kmO2NxafX0bP8=
X-Received: by 2002:a25:d957:0:b0:66c:9476:708f with SMTP id
 q84-20020a25d957000000b0066c9476708fmr9897744ybg.427.1656330457231; Mon, 27
 Jun 2022 04:47:37 -0700 (PDT)
MIME-Version: 1.0
References: <5099dc39-c6d9-115a-855b-6aa98d17eb4b@collabora.com>
 <CANn89i+R9RgmD=AQ4vX1Vb_SQAj4c3fi7-ZtQz-inYY4Sq4CMQ@mail.gmail.com>
 <8eb9b438-7018-4fe3-8be6-bb023df99594@collabora.com> <CANn89iJ1DfmuPz5pGdw=j9o+3O4R9tnTNFKi-ppW1O2sfmnN4g@mail.gmail.com>
 <63316ba7-f612-af5a-3f33-125cf89de754@collabora.com>
In-Reply-To: <63316ba7-f612-af5a-3f33-125cf89de754@collabora.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 27 Jun 2022 13:47:25 +0200
Message-ID: <CANn89iK96naKmc5Ep1PBxvksShQk=WMEoY_V0qZneN_JAEgtRg@mail.gmail.com>
Subject: Re: [RFC] EADDRINUSE from bind() on application restart after killing
To:     Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        open list <linux-kernel@vger.kernel.org>,
        Collabora Kernel ML <kernel@collabora.com>,
        Paul Gofman <pgofman@codeweavers.com>,
        "open list:NETWORKING [TCP]" <netdev@vger.kernel.org>,
        Sami Farin <hvtaifwkbgefbaei@gmail.com>
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

On Mon, Jun 27, 2022 at 12:20 PM Muhammad Usama Anjum
<usama.anjum@collabora.com> wrote:
>
> Hi Eric,
>
> On 5/30/22 8:28 PM, Eric Dumazet wrote:
> >> The following command and patch work for my use case. The socket in
> >> TIME_WAIT_2 or TIME_WAIT state are closed when zapped.
> >>
> >> Can you please upstream this patch?
> > Yes, I will when net-next reopens, thanks for testing it.
> Have you tried upstreaming it?
>
> Tested-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
>

I will do this today, thanks for the heads up.


> >
> >>> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> >>> index 9984d23a7f3e1353d2e1fc9053d98c77268c577e..1b7bde889096aa800b2994c64a3a68edf3b62434
> >>> 100644
> >>> --- a/net/ipv4/tcp.c
> >>> +++ b/net/ipv4/tcp.c
> >>> @@ -4519,6 +4519,15 @@ int tcp_abort(struct sock *sk, int err)
> >>>                         local_bh_enable();
> >>>                         return 0;
> >>>                 }
> >>> +               if (sk->sk_state == TCP_TIME_WAIT) {
> >>> +                       struct inet_timewait_sock *tw = inet_twsk(sk);
> >>> +
> >>> +                       refcount_inc(&tw->tw_refcnt);
> >>> +                       local_bh_disable();
> >>> +                       inet_twsk_deschedule_put(tw);
> >>> +                       local_bh_enable();
> >>> +                       return 0;
> >>> +               }
> >>>                 return -EOPNOTSUPP;
> >>>         }
>
> --
> Muhammad Usama Anjum
