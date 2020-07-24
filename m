Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D49F22C6D4
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 15:39:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726979AbgGXNiu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 09:38:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726455AbgGXNiu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 09:38:50 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5AE7C0619D3
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 06:38:49 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id e7so6903627qti.1
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 06:38:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/3heQZNEH/SpA+KywRQRZJ6sSbOx46c54wO1K7irlRY=;
        b=TdAuPVXPlXNDnZcyWd0IJxJJvXZu19l1dn0uz1HPSo3/YhWxhLQH7bb3EROMSMsTeq
         ZUMkxU8PztW3QGbijdEDEtJJ/ze2RLrQ8PLz83lNfAml8sX8+QpeLTUWAtpd3tcKx++6
         lS1NPzLLPbmLUrFO4QMHzzN4MYNTLERsW0fPMMzyk9wlSiCkoqOfCnKjU4Z6yOJ2PCQH
         jop+/zJrIgEMnyUBV78OZ0DrYyGsv0HfHQ6APJC56G0kZ5EVqZ3f8SKorctEgj/53tAj
         9Q+jncJ/9R636VgQhNsqlDKj3eUmMJJ5WWIBKKIDc1MpHO3Qq7slMRToekTPkI9T/9d6
         oDrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/3heQZNEH/SpA+KywRQRZJ6sSbOx46c54wO1K7irlRY=;
        b=jK6DCySB2BE36k9DOBNbqBD4pJSniAuhwYc7x/LEMJdBkLqTs1JHvZ6GXCoy60Gcur
         Xw8NoFmj7JBnhsERH4mVUbwS4fZIcMAMJ7HaAb7vkEIMSAfYHYLW6YQIi3a49QkJKhw8
         5OPY5IfBJRkiXcrGogNEc8E+fMT9XRzQeaNqaDVuwiDyHDl6e5NK2PNYZVEHByEp+xSC
         +jzFmg3DRqf1ihLUBv4HrC1OVIDqBtdJB0N3nhpuiZ5jIrX32VWabosAsW6jrnoB8eLU
         /Pm7yhjuBnNSc408rOSfRpJ1lj/8DIMxRD0agQL3DuZ6ViFPiCW1K3HrsOOkhuQP3SLM
         wKOw==
X-Gm-Message-State: AOAM532Y46QR6mSUGdjL7STwhAXC6Evb/8XhpPVy1cQAhvW6G0tRfmzj
        tgaNiHduWgDT64uPhyEQuUJrtEsC
X-Google-Smtp-Source: ABdhPJyWg9I3ddnWWXj2Vojzi/ABCo90MaSl8YcjD1DVcfjVlH+EYQJCH+f+mShO/MasmIJbzNuUdA==
X-Received: by 2002:ac8:4e08:: with SMTP id c8mr9494728qtw.299.1595597928021;
        Fri, 24 Jul 2020 06:38:48 -0700 (PDT)
Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com. [209.85.219.173])
        by smtp.gmail.com with ESMTPSA id r6sm1244195qtt.81.2020.07.24.06.38.46
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jul 2020 06:38:47 -0700 (PDT)
Received: by mail-yb1-f173.google.com with SMTP id d133so2767151ybh.5
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 06:38:46 -0700 (PDT)
X-Received: by 2002:a25:81cf:: with SMTP id n15mr15487289ybm.213.1595597925750;
 Fri, 24 Jul 2020 06:38:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200723.151051.16194602184853977.davem@davemloft.net> <20200724061304.14997-1-kuniyu@amazon.co.jp>
In-Reply-To: <20200724061304.14997-1-kuniyu@amazon.co.jp>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 24 Jul 2020 09:38:08 -0400
X-Gmail-Original-Message-ID: <CA+FuTSeyyxxt9AmKo8A3FNtnOxfcdVB-8hOzpitVD=auMMHFDQ@mail.gmail.com>
Message-ID: <CA+FuTSeyyxxt9AmKo8A3FNtnOxfcdVB-8hOzpitVD=auMMHFDQ@mail.gmail.com>
Subject: Re: [PATCH net] udp: Remove an unnecessary variable in udp[46]_lib_lookup2().
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Cc:     David Miller <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 24, 2020 at 2:13 AM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
>
> From:   David Miller <davem@davemloft.net>
> Date:   Thu, 23 Jul 2020 15:10:51 -0700 (PDT)
> > From: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> > Date: Thu, 23 Jul 2020 01:52:27 +0900
> >
> > > This patch removes an unnecessary variable in udp[46]_lib_lookup2() and
> > > makes it easier to resolve a merge conflict with bpf-next reported in
> > > the link below.
> > >
> > > Link: https://lore.kernel.org/linux-next/20200722132143.700a5ccc@canb.auug.org.au/
> > > Fixes: efc6b6f6c311 ("udp: Improve load balancing for SO_REUSEPORT.")
> > > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> > > Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> > > Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> >
> > This doesn't apply to net-next.
>
> Yes. I think this kind of patch should be submitted to net-next, but this
> is for the net tree. Please let me add more description.
>
> Currently, the net and net-next trees conflict in udp[46]_lib_lookup2()
> between
>
>    efc6b6f6c311 ("udp: Improve load balancing for SO_REUSEPORT.")
>
> and
>
>    7629c73a1466 ("udp: Extract helper for selecting socket from reuseport group")
>    2a08748cd384 ("udp6: Extract helper for selecting socket from reuseport group")
> .
>
> The conflict is reported in the link[0] and Jakub suggested how to resolve
> it[1]. To ease the merge conflict, Jakub and I have to send follow up patches to
> the bpf-next and net trees.
>
> Now, his patchset (7629c73a1466 and 2a08748cd384) to bpf-next is merged
> into net-next, and his follow up patch is applied in bpf-next[2].
>
> I fixed a bug in efc6b6f6c311, but it introduced an unnecessary variable
> and made the conflict worse. So I sent this follow up patch to net tree.
>
> However, I do not know the best way to resolve the conflict, so any comments
> are welcome.

Perhaps simpler is to apply this change to bpf-next:

"
                        badness = score;
-                       result = sk;
+                       if (!result)
+                               result = sk;
"

After which the remaining conflict between bpf-next and net is

"
++<<<<<<< HEAD
 +                      result = lookup_reuseport(net, sk, skb,
 +                                                saddr, sport, daddr, hnum);
 +                      if (result && !reuseport_has_conns(sk, false))
 +                              return result;
 +
 +                      badness = score;
 +                      if (!result)
 +                              result = sk;
++=======
+                       reuseport_result = NULL;
+
+                       if (sk->sk_reuseport &&
+                           sk->sk_state != TCP_ESTABLISHED) {
+                               hash = udp_ehashfn(net, daddr, hnum,
+                                                  saddr, sport);
+                               reuseport_result =
reuseport_select_sock(sk, hash, skb,
+
  sizeof(struct udphdr));
+                               if (reuseport_result &&
!reuseport_has_conns(sk, false))
+                                       return reuseport_result;
+                       }
+
+                       result = reuseport_result ? : sk;
+                       badness = score;
++>>>>>>> netdev-net/master
"

And we can just take bpf-next HEAD. Either that or handle the
corresponding change in the merge fix-up itself.

(note that bpf-next is one patch ahead of netdev-nn)
