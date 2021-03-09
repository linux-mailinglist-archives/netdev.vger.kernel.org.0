Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0958332D98
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 18:54:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231645AbhCIRxr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 12:53:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230359AbhCIRxn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 12:53:43 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8881FC06174A;
        Tue,  9 Mar 2021 09:53:43 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id c16so6992164ply.0;
        Tue, 09 Mar 2021 09:53:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O49svl5hJ5oi9Ex6IPLrJLltCuLctoPeu6fqaqxZkyQ=;
        b=kgLVDdWZaA5sXk1CHfRrOMHRBFmCz+nqGzaUIGsSqSzBu25ogoSpTLCxKqm/115qhz
         TOcyrcMryK5H9tN1uJhoPb7OTMFFUO2ob0EjVcTDyd9wOj+kGq9qIdxUD6hdfoJLlEpr
         4K7ZA5Cu++SSGwH1jcJmdX0e0rRjAHTyDreJy9Ld03q8cqRWME6i0UlljwmQmaW6JAFU
         VwJ4NCHZ3OZj9GmBBjUZNqPXdE8QvZ6Nr+yNIZjmQOa6/kzOvhCmXUWyL2OJBrdX/V4z
         bXLlG0eVbnKzuKhtuTouWdeimyO7p7eeKCnQnT0lIKXxg2KLlQvGmi8prsVw7i6m7oMe
         AopQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O49svl5hJ5oi9Ex6IPLrJLltCuLctoPeu6fqaqxZkyQ=;
        b=sWl9HdY8x9vIEDBxdfoy4e+jZR4vKR6uvL5it/jiwT1LikDSMGclPAZI/UDZeq3l72
         O4j3TXG1rQTekziVBLz/zWt+e10BfmTIhbiUFAcJP724oW9HhdNle9J8eQ0yMUS61mf1
         3Y9M4qfvwOQpd3RWLzUx6ubJsIGjhdck1Z7FD57+7LfTuwg5ss11eCaz8sPmLJFxHupb
         GH5B7oQKk+HV0yZo93n4T9iDL76URox7HBHfbPwvSQBSh66YIJR5+IPeVkg2KXqtaW9Q
         wXmztOdBjU6oQv1dbtlW70FRZKpzlsdhvnFZ6bKrt5F9+wtBcMFcjIDB5QRCpzwzXlNe
         d9IQ==
X-Gm-Message-State: AOAM532ITYTELRQ+R1OKtyKvOWySFdnpS3sxACl5bDExQaFfc0Azpy+a
        TqRrrzTC15eOCpe4iw4rzcr+vFqLFDDKXy6+8f8=
X-Google-Smtp-Source: ABdhPJx5yr6ZF9T6MC2DvhYv9EuqFpeOtEYxrDKLG0l1tWVJzRz+KRncWy1+yY17Tp8kHiJ4XiQs6y1Qw3+511+u5H8=
X-Received: by 2002:a17:90a:8b16:: with SMTP id y22mr5676763pjn.191.1615312423130;
 Tue, 09 Mar 2021 09:53:43 -0800 (PST)
MIME-Version: 1.0
References: <20210302023743.24123-1-xiyou.wangcong@gmail.com>
 <20210302023743.24123-3-xiyou.wangcong@gmail.com> <CACAyw9-SjsNn4_J1KDXuFh1nd9Hr-Mo+=7S-kVtooJwdi1fodQ@mail.gmail.com>
 <CAM_iQpXqE9qJ=+zKA6H1Rq=KKgm8LZ=p=ZtvrrH+hfSrTg+zxw@mail.gmail.com>
 <CAM_iQpXXUv1FV8DQ85a2fs08JCfKHHt-fAWYbV0TTWmwUZ-K5Q@mail.gmail.com>
 <6042cc5f4f65a_135da20824@john-XPS-13-9370.notmuch> <CAM_iQpUr7cvuXXdtYN9_MQPYy_Tfi88fBGSo3c8RRpMFBr55Og@mail.gmail.com>
 <6042e114a1c9e_135da20839@john-XPS-13-9370.notmuch>
In-Reply-To: <6042e114a1c9e_135da20839@john-XPS-13-9370.notmuch>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 9 Mar 2021 09:53:31 -0800
Message-ID: <CAM_iQpV5vJn5ORbhodinEYP7vV9tGbXwDN2Nw+TLqUNnp5ENcg@mail.gmail.com>
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

On Fri, Mar 5, 2021 at 5:55 PM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Cong Wang wrote:
> > On Fri, Mar 5, 2021 at 4:27 PM John Fastabend <john.fastabend@gmail.com> wrote:
> > >
> > > Cong Wang wrote:
> > > > On Tue, Mar 2, 2021 at 10:23 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > > > >
> > > > > On Tue, Mar 2, 2021 at 8:22 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
> > > > > >
> > > > > > On Tue, 2 Mar 2021 at 02:37, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > > > > >
> > > > > > ...
> > > > > > >  static inline void sk_psock_restore_proto(struct sock *sk,
> > > > > > >                                           struct sk_psock *psock)
> > > > > > >  {
> > > > > > >         sk->sk_prot->unhash = psock->saved_unhash;
> > > > > >
> > > > > > Not related to your patch set, but why do an extra restore of
> > > > > > sk_prot->unhash here? At this point sk->sk_prot is one of our tcp_bpf
> > > > > > / udp_bpf protos, so overwriting that seems wrong?
> > >
> > > "extra"? restore_proto should only be called when the psock ref count
> > > is zero and we need to transition back to the original socks proto
> > > handlers. To trigger this we can simply delete a sock from the map.
> > > In the case where we are deleting the psock overwriting the tcp_bpf
> > > protos is exactly what we want.?
> >
> > Why do you want to overwrite tcp_bpf_prots->unhash? Overwriting
> > tcp_bpf_prots is correct, but overwriting tcp_bpf_prots->unhash is not.
> > Because once you overwrite it, the next time you use it to replace
> > sk->sk_prot, it would be a different one rather than sock_map_unhash():
> >
> > // tcp_bpf_prots->unhash == sock_map_unhash
> > sk_psock_restore_proto();
> > // Now  tcp_bpf_prots->unhash is inet_unhash
> > ...
> > sk_psock_update_proto();
> > // sk->sk_proto is now tcp_bpf_prots again,
> > // so its ->unhash now is inet_unhash
> > // but it should be sock_map_unhash here
>
> Right, we can fix this on the TLS side. I'll push a fix shortly.

Are you still working on this? If kTLS still needs it, then we can
have something like this:

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index 8edbbf5f2f93..5eb617df7f48 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -349,8 +349,8 @@ static inline void sk_psock_update_proto(struct sock *sk,
 static inline void sk_psock_restore_proto(struct sock *sk,
                                          struct sk_psock *psock)
 {
-       sk->sk_prot->unhash = psock->saved_unhash;
        if (inet_csk_has_ulp(sk)) {
+               sk->sk_prot->unhash = psock->saved_unhash;
                tcp_update_ulp(sk, psock->sk_proto, psock->saved_write_space);
        } else {
                sk->sk_write_space = psock->saved_write_space;


Thanks.
