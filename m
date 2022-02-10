Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96B3A4B03E3
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 04:25:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232629AbiBJDYp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 22:24:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232605AbiBJDYo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 22:24:44 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 625C02B27F;
        Wed,  9 Feb 2022 19:24:46 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id y22so151981eju.9;
        Wed, 09 Feb 2022 19:24:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8pZN4DKwzIL/vsNTyWGBRg7+4GOFZTsnam6jrFgGSac=;
        b=CP+ZImXkJa4dnNW29dehJvfYpo29KOxS/0Z1Ayi2MfU9XfNff+EytHLBMieyj1kw33
         76Q7KT6S9JLTGfQmH1tKlstF+B/k2V0hO1UO9H18zRIScLMl2TQy1GBDeBBdIQ/eGqND
         Ikv5eFk4QeadS4WMZJe5FyAEY76UTmqhBSTlOK5mjxCqUir4oRlhjGtZKPW/tW+z4cNz
         6nQw0NavpiDNqJaG44g0Q/ZGXzaxIgXUR5AIAo0xWolLsbW92xWVGhYHNVFlxCRKFUVA
         5mBKfKWdkeazGKPnkZmXTA0x/jU+KbxUpWVehaQr5Hm7gc13nLy+d/b8TAe8n8DZVDsD
         mnuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8pZN4DKwzIL/vsNTyWGBRg7+4GOFZTsnam6jrFgGSac=;
        b=BH7U+fnwgcHUNZcZrkBizEZdvSaeNjIx6tU9q2nVKzdTzvQIHMK3mTUe2lTpOy/mPv
         9/HA24B2DHycqysVjCQE3sKc5S1nbEz4fRoxl0EnIlYTiZdBMNOdyT13EpEGjVczFimq
         f0O0xRjn87QpAM7UQ5NrM+5u8tCRouz1zEVhaTc9KU5Q/7DouRSCpEHjRP7Nzqpgg/UP
         eKCsf1OLd54XijKkHj2Bfr5e3iXlHklGnoDid0UMFrYF74nVo9mLtU7A5ZZ9dsisg7wt
         /vmiZt5dmzeKz+HgXGWucKNvyqPK+t6K5qw1/53QAeIAfoUlXkAN+xGtK2ru7rfAxFBZ
         SspQ==
X-Gm-Message-State: AOAM5332NpgqqNs4zz0vVmR1nlzfaB5FIGnD9g0jwIPwQVwzhpH6n03f
        qJKskULib0SfqgkhAZVLUTGbo/N8lpHIEZAco0c=
X-Google-Smtp-Source: ABdhPJyoQrFv1MHN2JoA2tvuMcSFD1F8wM7Z0pUUQTc7Ht4hhXWzG183OHGASMAlj/xEQvic9YB2WEH0rgRclDyxO1Q=
X-Received: by 2002:a17:907:76fc:: with SMTP id kg28mr4689942ejc.765.1644463484940;
 Wed, 09 Feb 2022 19:24:44 -0800 (PST)
MIME-Version: 1.0
References: <20220128073319.1017084-1-imagedong@tencent.com>
 <20220128073319.1017084-2-imagedong@tencent.com> <0029e650-3f38-989b-74a3-58c512d63f6b@gmail.com>
In-Reply-To: <0029e650-3f38-989b-74a3-58c512d63f6b@gmail.com>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Thu, 10 Feb 2022 11:19:49 +0800
Message-ID: <CADxym3akuxC_Cr07Vzvv+BD55XgMEx7nqU4qW8WHowGR0jeoOQ@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 1/7] net: skb_drop_reason: add document for
 drop reasons
To:     David Ahern <dsahern@gmail.com>
Cc:     David Ahern <dsahern@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, mingo@redhat.com,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        pablo@netfilter.org, kadlec@netfilter.org,
        Florian Westphal <fw@strlen.de>,
        Menglong Dong <imagedong@tencent.com>,
        Eric Dumazet <edumazet@google.com>, alobakin@pm.me,
        paulb@nvidia.com, Kees Cook <keescook@chromium.org>,
        talalahmad@google.com, haokexin@gmail.com, memxor@gmail.com,
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

Hello!

On Tue, Feb 1, 2022 at 1:14 AM David Ahern <dsahern@gmail.com> wrote:
>
> On 1/28/22 12:33 AM, menglong8.dong@gmail.com wrote:
> > From: Menglong Dong <imagedong@tencent.com>
> >
> > Add document for following existing drop reasons:
> >
> > SKB_DROP_REASON_NOT_SPECIFIED
> > SKB_DROP_REASON_NO_SOCKET
> > SKB_DROP_REASON_PKT_TOO_SMALL
> > SKB_DROP_REASON_TCP_CSUM
> > SKB_DROP_REASON_SOCKET_FILTER
> > SKB_DROP_REASON_UDP_CSUM
> >
> > Signed-off-by: Menglong Dong <imagedong@tencent.com>
> > ---
> >  include/linux/skbuff.h | 12 ++++++------
> >  1 file changed, 6 insertions(+), 6 deletions(-)
> >
>
> Reviewed-by: David Ahern <dsahern@kernel.org>
>
>

I'm doing the job of using kfree_skb_reason() for the TCP layer,
and I have some puzzles.

When collecting drop reason for tcp_v4_inbound_md5_hash() in
tcp_v4_rcv(), I come up with 2 ways:

First way: pass the address of reason to tcp_v4_inbound_md5_hash()
like this:

 static bool tcp_v4_inbound_md5_hash(const struct sock *sk,
                      const struct sk_buff *skb,
-                    int dif, int sdif)
+                    int dif, int sdif,
+                    enum skb_drop_reason *reason)

This can work, but many functions like tcp_v4_inbound_md5_hash()
need to do such a change.

Second way: introduce a 'drop_reason' field to 'struct sk_buff'. Therefore,
drop reason can be set by 'skb->drop_reason = SKB_DROP_REASON_XXX'
anywhere.

For TCP, there are many cases where you can't get a drop reason in
the place where skb is freed, so I think there needs to be a way to
deeply collect drop reasons. The second can resolve this problem
easily, but extra fields may have performance problems.

Do you have some better ideas?

Thanks!
Menglong Dong
