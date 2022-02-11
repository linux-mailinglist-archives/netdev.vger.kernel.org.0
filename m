Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E30A64B20D9
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 10:00:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348336AbiBKI6Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 03:58:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234134AbiBKI6Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 03:58:24 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34491E62;
        Fri, 11 Feb 2022 00:58:23 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id da4so15354476edb.4;
        Fri, 11 Feb 2022 00:58:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t0SaSiI4ixJP954QSUF/b/uxkkfR3Kxx/Wa5KAVhb8I=;
        b=ALK6NKHcBobueyxzQjYqIHBdYXdtmXhyPKwQBa2NS3xX9rI1543sn5Fe1P4QDpg8mk
         6eH4ryG3YvnTdPEFa/QNNpGkat6PNfUbm8Mnd3Bo01MmnhSMRld1ZRQtGZRV2NqiVesf
         8dMfvPTwgFn1RuVQmGPaWK2358Jes2ClYUbEYezLy/HTDD6EEeTZ7e5nW2z7RmSk/Tzi
         wi/+QbbGPZIiZO8G5toupQuRiAbr5rKW3pwTBz7dC0KyD/1rg6H4uwfIaYOcPFlCFKsS
         ITCZdUgOhXRV5gBh9qlBhYE2WQLv9lCokAE9RdCTW2LwAp+y4wkyJQ4gsPo3byO6SXDt
         qXRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t0SaSiI4ixJP954QSUF/b/uxkkfR3Kxx/Wa5KAVhb8I=;
        b=jvtq8lIU6EIrbw7LiLu05w3VpneGRStWFXgv453XZHr5cQWLGRCB173Lu68jAXm3Vj
         E7ZT9K3AwfGO4Onq/upGzZ0H27cxfPMwhEJc/VSOcG7QzxSYlpt9vxs3mn5glrVIEmtJ
         isLMFLdgcXyyQhIDFO6IX5ccsxER1Cq5iqGTCHpITqgE2Ln2UpYdrlMN+uJZzRyEv9Id
         rCsuJzCqmF0esrdtQeGaHTOkzorakzr4LVUQ5Tg8pmgixRCIzhjA9luE6PsVq8vnBxb1
         vpUNBbALtlo5w2GIkZYtg5YIyyEpsvgtL5hArqbzNteMte5Z0f5yAOcVgV7OzPUnTyqE
         +8MA==
X-Gm-Message-State: AOAM532H4bl7eFnkBK5XFuAE9ZvC1tKUVj3ffrwkkVPCasA+yfZrugQR
        en2aBORWQQlRb8lJFW2BVbK7bGAsBaYGshSylaLnsrAL
X-Google-Smtp-Source: ABdhPJxY9gHp7yK3gCnyKPifEIkGseBjrcIwtGDK1XyM9tpdpVQ8ECjGke1iEYe3L9KC0x5E3ySS+TcIb2gAWheS+ao=
X-Received: by 2002:aa7:d541:: with SMTP id u1mr763824edr.388.1644569901803;
 Fri, 11 Feb 2022 00:58:21 -0800 (PST)
MIME-Version: 1.0
References: <20220128073319.1017084-1-imagedong@tencent.com>
 <20220128073319.1017084-2-imagedong@tencent.com> <0029e650-3f38-989b-74a3-58c512d63f6b@gmail.com>
 <CADxym3akuxC_Cr07Vzvv+BD55XgMEx7nqU4qW8WHowGR0jeoOQ@mail.gmail.com>
 <20220209211202.7cddd337@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CADxym3ZajjCV2EHF6+2xa5ewZuVqxwk6bSqF0KuA+J6sGnShbQ@mail.gmail.com>
 <20220210081322.566488f6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <CANn89iKhkQ_0TbSJnPtMJrC57nz=0iiRXR-XzeZj5q6OPYZnFA@mail.gmail.com>
In-Reply-To: <CANn89iKhkQ_0TbSJnPtMJrC57nz=0iiRXR-XzeZj5q6OPYZnFA@mail.gmail.com>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Fri, 11 Feb 2022 16:53:25 +0800
Message-ID: <CADxym3b0COE3c8J8Qb6B61OZySzyZevrE2WDBWFBHOKuDjJ9hg@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 1/7] net: skb_drop_reason: add document for
 drop reasons
To:     Eric Dumazet <edumazet@google.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, David Ahern <dsahern@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Menglong Dong <imagedong@tencent.com>,
        Alexander Lobakin <alobakin@pm.me>, paulb@nvidia.com,
        Kees Cook <keescook@chromium.org>,
        Talal Ahmad <talalahmad@google.com>,
        Kevin Hao <haokexin@gmail.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, Cong Wang <cong.wang@bytedance.com>
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

On Fri, Feb 11, 2022 at 12:29 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Thu, Feb 10, 2022 at 8:13 AM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Thu, 10 Feb 2022 21:42:14 +0800 Menglong Dong wrote:
> > > How about introducing a field to 'struct sock' for drop reasons? As sk is
> > > locked during the packet process in tcp_v4_do_rcv(), this seems to work.
> >
> > I find adding temporary storage to persistent data structures awkward.
> > You can put a structure on the stack and pass it thru the call chain,
> > that's just my subjective preference, tho, others may have better ideas.
>
> I had a similar TODO item, because stuff like 'waking up task' or free
> one skb (or list of skb) could be performed outside of socket lock.

May I ask what it's like? Is it used to solve this kind of problem?

Thanks!
Menglong Dong
