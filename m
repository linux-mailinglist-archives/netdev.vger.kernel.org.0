Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C70F32F765
	for <lists+netdev@lfdr.de>; Sat,  6 Mar 2021 01:58:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229964AbhCFA6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 19:58:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbhCFA6B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 19:58:01 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6383CC06175F;
        Fri,  5 Mar 2021 16:58:01 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id t9so149972pjl.5;
        Fri, 05 Mar 2021 16:58:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kEB+wkg0VXlo2zJ9VMKwJrG0JtlezJmZdygKl69AD+I=;
        b=Doc9qVn0UogV3W56hb+iDnp3/OyBQwHdTQoy7LTDlplAxNfNnocU+qQ3IkdqnUXP5v
         lkfNGz+Am9fJ8/hjJ8TLLgHZQDNusq+UjFzAPt/Eaq2Ut1y98WIu20C5AT3vXyTwRTlL
         JMhSikGXh0djRA3q0N512fL30yaLx75QFbSMw967PrhFx/q08ZYJV+t+RWO5k/spW/RA
         xqhJSvQ0lYBIfr7ibgnFoF+tXkQyCBIkupU+SA32QUnYMrmyfaJQoOe9ia8e3Optp+xE
         +mjpqdYeLvTT6uv3E2Jl7J8svGQdkAfeKzqTrpr2Oyg7Id11PVFtJgGxl0vUTOIB6bZa
         qesA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kEB+wkg0VXlo2zJ9VMKwJrG0JtlezJmZdygKl69AD+I=;
        b=ZBfAoRgqdVg95tMY0MpwiINlYYd7qMqCUFjW9nAlM71Q3/y0H3Alfl2AIcU0LXM+cl
         ORqSQDk00i0HZuNpk+pwvN4ioXWXAcBnOp7MtQOV3Pb6zZ3xBSptWox/oIp3C9Wu6akO
         bQGrSZB4XP+dWwT80DRZtepoI7cY6yJYJpWcf76ky8t+/5QyQxfmRNkcMeaO0FySRJTG
         fWyCxTAA40wr1sET55Eag65M7gLQpYM3g8n6vZgcNMekEtesRzOvrNHpq8AiXsBU4cE5
         /VQzseW8dz0310pkdQM9zogpCQUNYeAwsc77RRRbxenwE+eVeWbXXdCZrQgXEd8+xSZI
         bmbQ==
X-Gm-Message-State: AOAM532Z9xxlbQn5cu+wmfx3KMpYfNM28DyrDwk1VjvamC42ROSV2NlN
        lPI3qsQ/J9pyAzY7CNrhN51L17fFRmoyH1q90ZCF2rEpe1u0pw==
X-Google-Smtp-Source: ABdhPJwbxFnpZfNws7VuiKzvxh4mG1T4EJ4x0sGRb61EkDmpZw5e4yJed6mgSIVWcC278lMexvUfahJHOrdUTC+QYFY=
X-Received: by 2002:a17:90a:8594:: with SMTP id m20mr12810495pjn.215.1614992280821;
 Fri, 05 Mar 2021 16:58:00 -0800 (PST)
MIME-Version: 1.0
References: <20210302023743.24123-1-xiyou.wangcong@gmail.com>
 <20210302023743.24123-3-xiyou.wangcong@gmail.com> <CACAyw9-SjsNn4_J1KDXuFh1nd9Hr-Mo+=7S-kVtooJwdi1fodQ@mail.gmail.com>
 <CAM_iQpXqE9qJ=+zKA6H1Rq=KKgm8LZ=p=ZtvrrH+hfSrTg+zxw@mail.gmail.com>
 <CAM_iQpXXUv1FV8DQ85a2fs08JCfKHHt-fAWYbV0TTWmwUZ-K5Q@mail.gmail.com> <6042cc5f4f65a_135da20824@john-XPS-13-9370.notmuch>
In-Reply-To: <6042cc5f4f65a_135da20824@john-XPS-13-9370.notmuch>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 5 Mar 2021 16:57:49 -0800
Message-ID: <CAM_iQpUr7cvuXXdtYN9_MQPYy_Tfi88fBGSo3c8RRpMFBr55Og@mail.gmail.com>
Subject: Re: [Patch bpf-next v2 2/9] sock: introduce sk_prot->update_proto()
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Lorenz Bauer <lmb@cloudflare.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        duanxiongchun@bytedance.com,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 5, 2021 at 4:27 PM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Cong Wang wrote:
> > On Tue, Mar 2, 2021 at 10:23 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > >
> > > On Tue, Mar 2, 2021 at 8:22 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
> > > >
> > > > On Tue, 2 Mar 2021 at 02:37, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > > >
> > > > ...
> > > > >  static inline void sk_psock_restore_proto(struct sock *sk,
> > > > >                                           struct sk_psock *psock)
> > > > >  {
> > > > >         sk->sk_prot->unhash = psock->saved_unhash;
> > > >
> > > > Not related to your patch set, but why do an extra restore of
> > > > sk_prot->unhash here? At this point sk->sk_prot is one of our tcp_bpf
> > > > / udp_bpf protos, so overwriting that seems wrong?
>
> "extra"? restore_proto should only be called when the psock ref count
> is zero and we need to transition back to the original socks proto
> handlers. To trigger this we can simply delete a sock from the map.
> In the case where we are deleting the psock overwriting the tcp_bpf
> protos is exactly what we want.?

Why do you want to overwrite tcp_bpf_prots->unhash? Overwriting
tcp_bpf_prots is correct, but overwriting tcp_bpf_prots->unhash is not.
Because once you overwrite it, the next time you use it to replace
sk->sk_prot, it would be a different one rather than sock_map_unhash():

// tcp_bpf_prots->unhash == sock_map_unhash
sk_psock_restore_proto();
// Now  tcp_bpf_prots->unhash is inet_unhash
...
sk_psock_update_proto();
// sk->sk_proto is now tcp_bpf_prots again,
// so its ->unhash now is inet_unhash
// but it should be sock_map_unhash here

Thanks.
