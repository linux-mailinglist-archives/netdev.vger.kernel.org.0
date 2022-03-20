Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB31A4E1BE3
	for <lists+netdev@lfdr.de>; Sun, 20 Mar 2022 14:28:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245163AbiCTN3a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Mar 2022 09:29:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232852AbiCTN33 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Mar 2022 09:29:29 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD2723616E;
        Sun, 20 Mar 2022 06:28:05 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id bg10so25215272ejb.4;
        Sun, 20 Mar 2022 06:28:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uiBW7PV/e0GMuTNf+xkw95IZotR/0iKHdVHb0o8XkmA=;
        b=kKVxjroK3JDqnoUjmvhKFWRth7Fh8vLmM1kvG9dkEKBWJuaBEvSefvupl7IzEpG+BO
         +e9gLlbNmAk/FtnbcEC70KxQvgTi5MUcf0QbsJXW8e85mgjpIVu9GJ8LQBDmSi5jn4Bp
         OU7xuEqMNhQT7kbmlWdnDPlNaXuUFm44JZ64zd0fPPoLpQ4VNqXvCo1Doaq7kkUqCaEr
         lNJrRULOPgI7Q3NJ7NrSgg7MzO1lnzV01e5v8A2+HC5N+dWYWFiyBQKiOyVzYZr4fHSv
         xi9zc7fM796zTPsfd2G7loXUGPr0kgU2TMBpkeRIK+l/uwrzOSK5op5CmOm3p+v0veBA
         ca0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uiBW7PV/e0GMuTNf+xkw95IZotR/0iKHdVHb0o8XkmA=;
        b=CuX1BankhI14M2KQWAaozlBxMMOuP9KVsN676zhwvZe5YEM9sevkzg0QUFg5YUBd1M
         R3rOQYUGqmjkz4vfvbLOB1oNtYebq7BZNaOfgOPgeO7eLiVtytN8UeZW8c8mWzwgmwBd
         elchat35eJ6eWiRDNREY2ks6rU5GUdIgxX4UJZeVqTX7Owan2h/bfn43y629gK0sIuCk
         gcL+kF7r3xIDQnxdlnX75LwsDZlI/yZwzSxFBBTtNTFenPirGDU2BSvwotBzVnc4y41C
         5q5XC+5oJsdjYVoxwOvrOXqv6ywxxDFun4PvLnzHOsQuNBQcN98/Cl6PFfvC97MfP8Aa
         8RuQ==
X-Gm-Message-State: AOAM5317s8B/LpHhJA6Y+YfOap0q6hy7tTqSBYENUCKQ2Zqd/Aq8EDcF
        dr+cH5zkOQxATqjWMWKXxCAgwoPzskhYRfRx3H8=
X-Google-Smtp-Source: ABdhPJzRx2NHqcntJ0YMCadTXJqTHTeHPyzN3XiUyK8h2Iws9qkBf49h+jncHtTvXrlKOi07jdqydYsgFR/dnVijaPk=
X-Received: by 2002:a17:907:3f8f:b0:6df:c340:f91 with SMTP id
 hr15-20020a1709073f8f00b006dfc3400f91mr9150629ejc.765.1647782884230; Sun, 20
 Mar 2022 06:28:04 -0700 (PDT)
MIME-Version: 1.0
References: <20220316063148.700769-1-imagedong@tencent.com>
 <20220316063148.700769-4-imagedong@tencent.com> <20220316201853.0734280f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <4315b50e-9077-cc4b-010b-b38a2fbb7168@kernel.org> <20220316210534.06b6cfe0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <f787c35b-0984-ecaf-ad97-c7580fcdbbad@kernel.org> <CADxym3YM9FMFrTirxWQF7aDOpoEGq5bC4-xm2p0mF8shP+Q0Hw@mail.gmail.com>
 <a4032cff-0d48-2690-3c1f-a2ec6c54ffb4@kernel.org> <CADxym3bGVebdCTCXxg3xEcPwdfSQADLyPbLTJnPnwn+phqGp3A@mail.gmail.com>
 <98450e8a-b3e1-22d7-86fb-3c8456a36018@kernel.org>
In-Reply-To: <98450e8a-b3e1-22d7-86fb-3c8456a36018@kernel.org>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Sun, 20 Mar 2022 21:27:52 +0800
Message-ID: <CADxym3b3T0V0zHkN36vusvSNL=Tk+b_Ahy9Tj8=kKm_gmuRS3A@mail.gmail.com>
Subject: Re: [PATCH net-next v3 3/3] net: icmp: add reasons of the skb drops
 to icmp protocol
To:     David Ahern <dsahern@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, xeb@mail.ru,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Menglong Dong <imagedong@tencent.com>,
        Eric Dumazet <edumazet@google.com>, Martin Lau <kafai@fb.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kees Cook <keescook@chromium.org>,
        Alexander Lobakin <alobakin@pm.me>,
        Hao Peng <flyingpeng@tencent.com>,
        Mengen Sun <mengensun@tencent.com>, dongli.zhang@oracle.com,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Biao Jiang <benbjiang@tencent.com>
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

On Sat, Mar 19, 2022 at 6:33 AM David Ahern <dsahern@kernel.org> wrote:
>
> On 3/18/22 1:26 AM, Menglong Dong wrote:
> > Yeah, PTYPE seems not suitable. I mean that replace SKB_DROP_REASON_PTYPE_ABSENT
> > that is used in __netif_receive_skb_core() with L3_PROTO, which means no L3
> > protocol handler (or other device handler) is not found for the
> > packet. This seems more
> > friendly and not code based.
> >
> >>> And use SKB_DROP_REASON_L4_PROTO for the L4 protocol problem,
> >>> such as GRE version not supported, ICMP type not supported, etc.
> > Is this L4_PROTO followed by anyone?
>
> how about just a generic
>         SKB_DROP_REASON_UNHANDLED_PROTO  /* protocol not implemented
>                                           * or not supported
>                                           */
>
> in place of current PTYPE_ABSENT (so a rename to remove a Linux code
> reference), and then use it for no L3 protocol handler, no L4 protocol
> handler, version extensions etc. The instruction pointer to symbol gives
> the context of the unsupported protocol.

Yeah, I think it's a good idea :)

Thanks!
Menglong Dong
