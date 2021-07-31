Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 864113DC7A2
	for <lists+netdev@lfdr.de>; Sat, 31 Jul 2021 20:23:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbhGaSXt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Jul 2021 14:23:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbhGaSXs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Jul 2021 14:23:48 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2311C06175F;
        Sat, 31 Jul 2021 11:23:40 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id c16so14930113plh.7;
        Sat, 31 Jul 2021 11:23:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s31dvzlOndczyqC7I9ua7q3/6A0z0TwToQuOswH2isQ=;
        b=jfXx968p6L/Tp5dMoOb3/2H/WRRX1RVg/x0eGyG21Ybk48N3mzQN0lo9S6jrLS/M2B
         zD4iiGl9zkmYkgL4oeFEfjjS6jTgZLjIlj7N2cOOSxy9ci249K2fVJN/FxRzmqEBxOAK
         CDdy4NBde6QIwTPae453YaJKbG5E89/dxfXeFDgv+tT2iGKVxM+oNXPUBSqO4/Eiri+m
         MoeCKKAYTI3EhNKa8xJ7alGEZPdqnoEOJpOHYTJIht0g2lcGaBXevUMghdhFv8nRdiLp
         FRfn2tFvL+8cLaaVMZLHCCqNzVM+rOg9rvvuicgQTbtEqXrpDBjVzm+doBfhq6VIrHus
         fgdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s31dvzlOndczyqC7I9ua7q3/6A0z0TwToQuOswH2isQ=;
        b=pUvm6CfnccJYqF94tiAU9UnCMqMfaiKA+sE7LC3MkdwKYse/0tPlQNfZ85IQsEFdld
         cdu4M0IuCQGEbkm5kPJnuermbMNc1VJ/6SrEtG4U5yqPEj+1qzugPY0FtMCLWnPjZwog
         j4ZIUjJxFRlYArNqoptwwZPlSytcdTQYEoHzD4BOWCiTi8XsMyhu5bw6Dn43h0H1XvP4
         z0JX5Podpx08Foz442tvHxKuci3T0BHF5HNQjKaxUBiAI8dDhTeZCMtRIk397FDWBwyo
         s0+frSIH4OggG628+oY2ffeKZMLy15ckx92ln5q5j4tFl7Fbb4rf4uX8T0laQCe7fAs3
         Q9WQ==
X-Gm-Message-State: AOAM532xYPiLCkrFfjCte/pkr3XYmW1wOlrBC9+4IMyIEOe6mYqxe3uO
        NRAwYQWNmV8EE/Dva8QfCU89iX8NHn8OQkh43m0=
X-Google-Smtp-Source: ABdhPJyd5uYWYM/6Oz2qkfLgA/j5vxV90do1bGZRYow+nnjOUsHZ5VBXPnyGoWpRioxiWQRCbkvZK2lkPE/LpOQdeGI=
X-Received: by 2002:a17:90a:e647:: with SMTP id ep7mr9407589pjb.145.1627755820271;
 Sat, 31 Jul 2021 11:23:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210729212402.1043211-1-jiang.wang@bytedance.com>
 <20210729212402.1043211-3-jiang.wang@bytedance.com> <875ywropno.fsf@cloudflare.com>
In-Reply-To: <875ywropno.fsf@cloudflare.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sat, 31 Jul 2021 11:23:30 -0700
Message-ID: <CAM_iQpVepKnEr_89XFiwH_8NBm12OUwT=H-AH8tbaESTpwaqMw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 2/5] af_unix: add unix_stream_proto for sockmap
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     Jiang Wang <jiang.wang@bytedance.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "Cong Wang ." <cong.wang@bytedance.com>,
        Xiongchun Duan <duanxiongchun@bytedance.com>,
        xieyongji@bytedance.com, chaiwen.cc@bytedance.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 30, 2021 at 7:14 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> On Thu, Jul 29, 2021 at 11:23 PM CEST, Jiang Wang wrote:
> > Previously, sockmap for AF_UNIX protocol only supports
> > dgram type. This patch add unix stream type support, which
> > is similar to unix_dgram_proto. To support sockmap, dgram
> > and stream cannot share the same unix_proto anymore, because
> > they have different implementations, such as unhash for stream
> > type (which will remove closed or disconnected sockets from the map),
> > so rename unix_proto to unix_dgram_proto and add a new
> > unix_stream_proto.
> >
> > Also implement stream related sockmap functions.
> > And add dgram key words to those dgram specific functions.
> >
> > Signed-off-by: Jiang Wang <jiang.wang@bytedance.com>
> > Reviewed-by: Cong Wang <cong.wang@bytedance.com>
> > ---
>
> It seems that with commit c63829182c37 ("af_unix: Implement
> ->psock_update_sk_prot()") we have enabled inserting dgram, stream, and
> seqpacket UNIX sockets into sockmap.
>
> After all, in ->map_update_elem we only check if
> sk->sk_prot->psock_update_sk_prot is set (sock_map_sk_is_suitable).

Excellent point. I should check the sock type in unix_bpf_update_proto(),
and will send a fix.

>
> Socket can be in listening, established or disconnected (TCP_CLOSE)
> state, that is before bind+listen/connect, or after connect(AF_UNSPEC).
>
> For connection-oriented socket types (stream, seqpacket) there's not
> much you can do with disconnected sockets. I think we should limit the
> allowed states to listening and established for UNIX domain, as we do
> for TCP.

I think we should use ->unhash() to remove those connection-oriented
sockets, like TCP.

>
> AFAIU we also seem to be already allowing redirect to connected stream
> (and dgram, and seqpacket) UNIX sockets. sock_map_redirect_allowed()
> checks only if a socket is in TCP_ESTABLISHED state for anything else
> than TCP. Not sure what it leads to, though.

The goal is to keep all stream sockets like TCP, which only allows
established ones to stay in sockmap. For dgram, any socket state is
allowed to add to map but only established ones are allowed to redirect.

BTW, we do not have any intention to support Unix seqpacket socket
or any seqpacket.

Thanks.
