Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97272FE736
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 22:32:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbfKOVcc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 16:32:32 -0500
Received: from mail-yb1-f181.google.com ([209.85.219.181]:39292 "EHLO
        mail-yb1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726598AbfKOVcc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 16:32:32 -0500
Received: by mail-yb1-f181.google.com with SMTP id q18so4608663ybq.6
        for <netdev@vger.kernel.org>; Fri, 15 Nov 2019 13:32:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=Pdn8scXuk7Omj+DAkEHcgK+7zx+C3tUh1qcp+NMgpL4=;
        b=ACwNc5dXFyGK8z6wa465ar67TKr/WAviacwghqkGQnHJuVSzdBZQSYvJ4Wp9ZTxd6j
         UlkS/9P7gQHflzOgxgJNMw27TCqrflhbJ60/7tjFBCbGnIPBMb55lzK3BRuZtu1+lUOt
         pxymAIb8BJ4qJzqvG1nw0QSNUcGgKDhfea3R0yUrvabgiHUh6XQO9tKoqZv0VnLWJfAk
         snnw+NzZ7+Lx0hBgG+dlcriXn/pnzj8746vNcIzz96C5VbRj1XzJOSEzB3YNRiooH3Uv
         Di5Il8plrwTtbDhR3H2ruq+Lbc0qVcQkRttc8xfm/UhJE87XME0/zzYeuBbeOEctK19A
         D7ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=Pdn8scXuk7Omj+DAkEHcgK+7zx+C3tUh1qcp+NMgpL4=;
        b=l7Tw65apkps1KUdzu1b2IlDEvopMFWbzI8yAuinlkyyElMf6ntw+waHXER7djKHYd5
         BH3qsO4mSGJCmHFtXaMkCrAivUpLgX22Xt3J3R11S1oBVrQ+uTNc/lMUlnRAt23WL/Qp
         W5n82SFSzyUAK4rJGN2ZO1bDgTKdxns/CrKMdeiWlk7bHKHNCRNuvhbsg8hed7HdMghU
         TnpUs9OR9C6AaMeokLodnSxmFWCyURVSqTILDU+0uc77jaCBxNMy2VgcwzBdXGtmMCAQ
         9MvZ06sDqpbBU5Kc7fkbzmjwg231k4y5jDmaLYussXxwvQsJnDHnt4wXLwVSQ/L9kV/d
         7Rhg==
X-Gm-Message-State: APjAAAW5Mr5CHOnf9ZBi53CDE25Y1L2P0qXNojM6ECYJ3euSQU0XXmm0
        rOYHBr09bmGYjaf3XaqA/vyoKRZD
X-Google-Smtp-Source: APXvYqygP0HNBMfCQ1zHwR8RnB5RrYxs5mRBTIjC/mlrLTf0eP+eXbZhy3nPeja12Mr9YJAPkT4CJA==
X-Received: by 2002:a25:c881:: with SMTP id y123mr13092268ybf.516.1573853548953;
        Fri, 15 Nov 2019 13:32:28 -0800 (PST)
Received: from mail-yw1-f48.google.com (mail-yw1-f48.google.com. [209.85.161.48])
        by smtp.gmail.com with ESMTPSA id g6sm3715106ywk.14.2019.11.15.13.32.27
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Nov 2019 13:32:27 -0800 (PST)
Received: by mail-yw1-f48.google.com with SMTP id n82so3594709ywc.7
        for <netdev@vger.kernel.org>; Fri, 15 Nov 2019 13:32:27 -0800 (PST)
X-Received: by 2002:a0d:cc90:: with SMTP id o138mr1675764ywd.193.1573853547044;
 Fri, 15 Nov 2019 13:32:27 -0800 (PST)
MIME-Version: 1.0
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 15 Nov 2019 16:31:51 -0500
X-Gmail-Original-Message-ID: <CA+FuTSfTMuKv8s0zdS6YzLC14bNdPQxi2mu7ak6e_sS+qyyrFg@mail.gmail.com>
Message-ID: <CA+FuTSfTMuKv8s0zdS6YzLC14bNdPQxi2mu7ak6e_sS+qyyrFg@mail.gmail.com>
Subject: combining sockmap + ktls
To:     bpf <bpf@vger.kernel.org>
Cc:     Network Development <netdev@vger.kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I've been playing with sockmap and ktls. They're fantastic tools.
Combining them I did run into a few issues. Would like to understand
whether (a) it's just me, else (b) whether these are known issues and
(c) some feedback on an initial hacky patch.

My test [1] sets up an echo request/response between a client and
server, optionally interposed by an "icept" guard process on each side
and optionally enabling ktls between the icept processes.

Without ktls, most variants of interpositioning {iptables, iptables +
splice(), iptables + sockmap splice, sk_msg to icept tx } work.

Only sk_msg redirection to icept ingress with BPF_F_INGRESS does not
if the destination socket has a verdict program. I *think* this is
intentional, judging from commit 552de9106882 ("bpf: sk_msg, fix
socket data_ready events") explicitly ensuring that the process gets
awoken on new data if a socket has a verdict program and another
socket redirects to it, as opposed to passing it to the program.

For this workload, more interesting is sk_msg directly to icept
egress, anyway. This works without ktls. Support for ktls is added in
commit d3b18ad31f93 ("tls: add bpf support to sk_msg handling"). The
relevant callback function tls_sw_sendpage_locked was not immediately
used and subsequently removed in commit cc1dbdfed023 ("Revert
"net/tls: remove unused function tls_sw_sendpage_locked""). It appears
to work once reverting that change, plus registering the function

        @@ -859,6 +861,7 @@ static int __init tls_register(void)

                tls_sw_proto_ops = inet_stream_ops;
                tls_sw_proto_ops.splice_read = tls_sw_splice_read;
        +       tls_sw_proto_ops.sendpage_locked   = tls_sw_sendpage_locked,

and additionally allowing MSG_NO_SHARED_FRAGS:

         int tls_sw_sendpage_locked(struct sock *sk, struct page *page,
                                    int offset, size_t size, int flags)
         {
               if (flags & ~(MSG_MORE | MSG_DONTWAIT | MSG_NOSIGNAL |
        -                     MSG_SENDPAGE_NOTLAST | MSG_SENDPAGE_NOPOLICY))
        +                     MSG_SENDPAGE_NOTLAST |
MSG_SENDPAGE_NOPOLICY | MSG_NO_SHARED_FRAGS))
                         return -ENOTSUPP;

and not registering parser+verdict programs on the destination socket.
Note that without ktls this mode also works with such programs
attached.

Lastly, sockmap splicing from icept ingress to egress (no sk_msg) also
stops working when I enable ktls on the egress socket. I'm taking a
look at that next. But this email is long enough already ;)

Thanks for having a look!

  Willem

[1] https://github.com/wdebruij/kerneltools/tree/icept.2

probably more readable is the stack of commits, one per feature:

  c86c112 icept: initial client/server test
  727a8ae icept: add iptables interception
  60c34b2 icept: add splice interception
  03a516a icept: add sockmap interception
  c9c6103 icept: run client and server in cgroup
  579bcae icept: add skmsg interception
  e1b0d17 icept: add kTLS
