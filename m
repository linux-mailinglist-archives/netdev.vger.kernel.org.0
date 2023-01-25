Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB57867A9F7
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 06:25:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbjAYFZu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 00:25:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbjAYFZt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 00:25:49 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B88D1166D;
        Tue, 24 Jan 2023 21:25:48 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id m11so5535335pji.0;
        Tue, 24 Jan 2023 21:25:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YzUKvlx/l4x5SFk9d2w3bJt/HNHl8Jrjy4nP9COeZE8=;
        b=iwCtXxiP8m7j710I3xBqUNiP/2lquL/SfC5ZWw9iqKVHXL+GpGEXievSOKsDhO0Hub
         Ac1H8mGyejlIPKE1dhMeJqtK5X4BCANjHsH/3ENcx+uM8UWBUqqYzwq5pFuPEK7LrbJD
         m541cYscBTXoZmONd3oKMKH8i27A4ZiiDkbXwhrv/y53NcB1g4vEyacRnG8Nch+eTt10
         JCY9mkPqim4pPN3uMrgeu/sF3GHEj55JXSjLyRETgKP7IIguRBHnk0H0jHJeY5Orv9JJ
         ahdGZ4z+Kyd44Wih7VBf9+54eB7PE6ipsugjpSwL57CxhKAa9+m1B4EqCkBVTsMJQi3S
         DJ/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=YzUKvlx/l4x5SFk9d2w3bJt/HNHl8Jrjy4nP9COeZE8=;
        b=De0TbbGNrvA2Ma/v6w9FEBcYcrVUV1tRu0ND/IrURA5BqUSr4OePmRHg2rUarUg33B
         QKvJmWbWxOvT/QXKirYp1c38fZi+UZ2A6TkJ1HOGm4ZXDigtlUnL3Zl5xjL3+XsW7BwN
         AKQYQGlCoyRTlHh1enT5fNQ42D4kuvb4T5H/chLsofD5W9Y227xL6D5qK24/bPHqf4Pb
         nS2WRH6jok3BfgK5BXEr1Re3gw0wF93fQ03FKbWda+UzhCeQa3kXNSi75QPY3lQiW5G8
         Wj/RaJBsPe3X8lmkEf/I8Gb2VHc5lX/hn1ItC/PxQVq8qVjFBOEIEObP9tHR9W3/esod
         oSgw==
X-Gm-Message-State: AFqh2krRmkDXJGHTc86zJ+EOa9oHQ/88uYF8uqx5AmhEfOErOxQ8xnkb
        LVg6b+iouU9zfgPOLff8sSU=
X-Google-Smtp-Source: AMrXdXsURZ6NSIHpK2AO4jaaLDrqcwuTwEqOGhCh6gImu1l/bOiGG77Fmmal3UY1ijl/zBEpnZvqXw==
X-Received: by 2002:a17:90b:3148:b0:22b:ae0b:ac88 with SMTP id ip8-20020a17090b314800b0022bae0bac88mr19451127pjb.47.1674624347742;
        Tue, 24 Jan 2023 21:25:47 -0800 (PST)
Received: from localhost ([98.97.33.45])
        by smtp.gmail.com with ESMTPSA id mv17-20020a17090b199100b0022be311523dsm515495pjb.35.2023.01.24.21.25.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 21:25:46 -0800 (PST)
Date:   Tue, 24 Jan 2023 21:25:43 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        kernel-team@cloudflare.com,
        syzbot+04c21ed96d861dccc5cd@syzkaller.appspotmail.com
Message-ID: <63d0bd576b61c_641f2086b@john.notmuch>
In-Reply-To: <20230113-sockmap-fix-v2-2-1e0ee7ac2f90@cloudflare.com>
References: <20230113-sockmap-fix-v2-0-1e0ee7ac2f90@cloudflare.com>
 <20230113-sockmap-fix-v2-2-1e0ee7ac2f90@cloudflare.com>
Subject: RE: [PATCH bpf v2 2/4] bpf, sockmap: Check for any of tcp_bpf_prots
 when cloning a listener
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> A listening socket linked to a sockmap has its sk_prot overridden. It
> points to one of the struct proto variants in tcp_bpf_prots. The variant
> depends on the socket's family and which sockmap programs are attached.
> 
> A child socket cloned from a TCP listener initially inherits their sk_prot.
> But before cloning is finished, we restore the child's proto to the
> listener's original non-tcp_bpf_prots one. This happens in
> tcp_create_openreq_child -> tcp_bpf_clone.
> 
> Today, in tcp_bpf_clone we detect if the child's proto should be restored
> by checking only for the TCP_BPF_BASE proto variant. This is not
> correct. The sk_prot of listening socket linked to a sockmap can point to
> to any variant in tcp_bpf_prots.
> 
> If the listeners sk_prot happens to be not the TCP_BPF_BASE variant, then
> the child socket unintentionally is left if the inherited sk_prot by
> tcp_bpf_clone.
> 
> This leads to issues like infinite recursion on close [1], because the
> child state is otherwise not set up for use with tcp_bpf_prot operations.
> 
> Adjust the check in tcp_bpf_clone to detect all of tcp_bpf_prots variants.
> 
> Note that it wouldn't be sufficient to check the socket state when
> overriding the sk_prot in tcp_bpf_update_proto in order to always use the
> TCP_BPF_BASE variant for listening sockets. Since commit
> b8b8315e39ff ("bpf, sockmap: Remove unhash handler for BPF sockmap usage")
> it is possible for a socket to transition to TCP_LISTEN state while already
> linked to a sockmap, e.g. connect() -> insert into map ->
> connect(AF_UNSPEC) -> listen().
> 
> [1]: https://lore.kernel.org/all/00000000000073b14905ef2e7401@google.com/
> 
> Fixes: e80251555f0b ("tcp_bpf: Don't let child socket inherit parent protocol ops on copy")
> Reported-by: syzbot+04c21ed96d861dccc5cd@syzkaller.appspotmail.com
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>
