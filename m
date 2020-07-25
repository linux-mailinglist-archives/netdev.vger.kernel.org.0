Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE9622D418
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 05:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726870AbgGYDFS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 23:05:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726591AbgGYDFR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 23:05:17 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B39E5C0619D3
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 20:05:17 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id dd12so11272qvb.0
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 20:05:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PM/QKGDZE22PuDAEWGHkJ+fxtZnUlY53d6xjS9DsZnM=;
        b=HKCPCky2hhFkosG+VnDWvOYtAfm0mGuvAr89Y3OlfW80H+Ux0Z8UpgznSPbVKpjJt2
         cbb1LqgG78NgeIyKVR1JI26ND3SgqfYdT8fp0IYnSTeHS/hsxzAoSplCh5inCsvKWbwT
         098EP7gT1IbcvZHZq9NWTZICU8OEMW3ujQWuqaDwvo2NhNjC1r8D2JkASLwTlfDZsoJ8
         HMABdwP32b4zCc06Hmua4Zze0oFPzKGzF0qCkdba9sX+NBaLGiM+3xXSREGe/L/B/uZE
         qtIUMsyM8kBg+33ykYt8SzVxx9np37gitVq4DS/zGHU63qq0VI82wBPREGUJqyswrvxd
         YOeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PM/QKGDZE22PuDAEWGHkJ+fxtZnUlY53d6xjS9DsZnM=;
        b=S0vNNj4V/Z9nPu2THqJfJSR7fmYtsz7j6IOod4wmZJK4eFQZ+vD7qcQuMHvdvSkL6b
         2qw+J12pkKjXnv62pVVoaD+dehabCKE14QjBQqiVHgGZ2V3tbN91VtvFNMVDZg6eHhY4
         1NVhOY8QNTEwah4lvpupWyq5TwcxQ3AtdfFVaSVt/VzDpY+ebMcSxYp1ZR4/mGawY+ak
         wbv9ycxOxoJ6/zlQ6rUmgXjHt2X08n8nD2/LlV3PnzuLoSJSHmNBz5RjexqxjX7E8cCP
         /LadB1LS3ke1g+qDlt1C3nLOxpHopcDmLByXxMpyfy8lNFvF0j/73pvAihi6HML3hOpf
         Lw/w==
X-Gm-Message-State: AOAM532rrFJFu8bT6/L5wUp3202wdqopvSIUwxTW4j4CTkf88HP/tuRE
        rlGnC7X5mwlNmRiLmMtZNdncH0DS
X-Google-Smtp-Source: ABdhPJxmI7iD6vqBHmxNe3/2ywzZH/kzxEcleI4AP0cz0MhWinW2oa5U8DIcqtMr+u9BTR+8B9BFfw==
X-Received: by 2002:ad4:46f4:: with SMTP id h20mr12004726qvw.85.1595646316033;
        Fri, 24 Jul 2020 20:05:16 -0700 (PDT)
Received: from mail-yb1-f179.google.com (mail-yb1-f179.google.com. [209.85.219.179])
        by smtp.gmail.com with ESMTPSA id h55sm4287976qte.16.2020.07.24.20.05.15
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jul 2020 20:05:15 -0700 (PDT)
Received: by mail-yb1-f179.google.com with SMTP id l19so5708513ybl.1
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 20:05:15 -0700 (PDT)
X-Received: by 2002:a25:3155:: with SMTP id x82mr19768323ybx.492.1595646314604;
 Fri, 24 Jul 2020 20:05:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200723.151051.16194602184853977.davem@davemloft.net>
 <20200724061304.14997-1-kuniyu@amazon.co.jp> <CA+FuTSeyyxxt9AmKo8A3FNtnOxfcdVB-8hOzpitVD=auMMHFDQ@mail.gmail.com>
 <CAADnVQKbW+TpMN5Pzu9LoSJyUeBcmUsVSX5UecGc+qpEkZPk8A@mail.gmail.com>
In-Reply-To: <CAADnVQKbW+TpMN5Pzu9LoSJyUeBcmUsVSX5UecGc+qpEkZPk8A@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 24 Jul 2020 23:04:38 -0400
X-Gmail-Original-Message-ID: <CA+FuTScnVOuiwLQ3wB=ELHzo=APNbET1ENt2Aouq1KdWcHN5cA@mail.gmail.com>
Message-ID: <CA+FuTScnVOuiwLQ3wB=ELHzo=APNbET1ENt2Aouq1KdWcHN5cA@mail.gmail.com>
Subject: Re: [PATCH net] udp: Remove an unnecessary variable in udp[46]_lib_lookup2().
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        David Miller <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 24, 2020 at 3:13 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Fri, Jul 24, 2020 at 6:38 AM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> >
> > On Fri, Jul 24, 2020 at 2:13 AM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
> > >
> > > From:   David Miller <davem@davemloft.net>
> > > Date:   Thu, 23 Jul 2020 15:10:51 -0700 (PDT)
> > > > From: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> > > > Date: Thu, 23 Jul 2020 01:52:27 +0900
> > > >
> > > > > This patch removes an unnecessary variable in udp[46]_lib_lookup2() and
> > > > > makes it easier to resolve a merge conflict with bpf-next reported in
> > > > > the link below.
> > > > >
> > > > > Link: https://lore.kernel.org/linux-next/20200722132143.700a5ccc@canb.auug.org.au/
> > > > > Fixes: efc6b6f6c311 ("udp: Improve load balancing for SO_REUSEPORT.")
> > > > > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> > > > > Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> > > > > Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> > > >
> > > > This doesn't apply to net-next.
> > >
> > > Yes. I think this kind of patch should be submitted to net-next, but this
> > > is for the net tree. Please let me add more description.
> > >
> > > Currently, the net and net-next trees conflict in udp[46]_lib_lookup2()
> > > between
> > >
> > >    efc6b6f6c311 ("udp: Improve load balancing for SO_REUSEPORT.")
> > >
> > > and
> > >
> > >    7629c73a1466 ("udp: Extract helper for selecting socket from reuseport group")
> > >    2a08748cd384 ("udp6: Extract helper for selecting socket from reuseport group")
> > > .
> > >
> > > The conflict is reported in the link[0] and Jakub suggested how to resolve
> > > it[1]. To ease the merge conflict, Jakub and I have to send follow up patches to
> > > the bpf-next and net trees.
> > >
> > > Now, his patchset (7629c73a1466 and 2a08748cd384) to bpf-next is merged
> > > into net-next, and his follow up patch is applied in bpf-next[2].
> > >
> > > I fixed a bug in efc6b6f6c311, but it introduced an unnecessary variable
> > > and made the conflict worse. So I sent this follow up patch to net tree.
> > >
> > > However, I do not know the best way to resolve the conflict, so any comments
> > > are welcome.
> >
> > Perhaps simpler is to apply this change to bpf-next:
>
> I'm fine whichever way.
> Could you please submit an official patch?

http://patchwork.ozlabs.org/project/netdev/patch/20200725025457.1004164-1-willemdebruijn.kernel@gmail.com/

Not sure whether it helps vs doing this as part of the merge conflict
(which remains). Either way after conflict resolution should be

"
static struct sock *udp4_lib_lookup2(struct net *net,
                                     __be32 saddr, __be16 sport,
                                     __be32 daddr, unsigned int hnum,
                                     int dif, int sdif,
                                     struct udp_hslot *hslot2,
                                     struct sk_buff *skb)
{
        struct sock *sk, *result;
        int score, badness;

        result = NULL;
        badness = 0;
        udp_portaddr_for_each_entry_rcu(sk, &hslot2->head) {
                score = compute_score(sk, net, saddr, sport,
                                      daddr, hnum, dif, sdif);
                if (score > badness) {
                        result = lookup_reuseport(net, sk, skb,
                                                  saddr, sport, daddr, hnum);
                        if (result && !reuseport_has_conns(sk, false))
                                return result;

                        badness = score;
                        if (!result)
                                result = sk;
                }
        }
        return result;
}
"
