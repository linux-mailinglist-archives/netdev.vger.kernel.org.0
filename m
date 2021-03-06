Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDE7332F747
	for <lists+netdev@lfdr.de>; Sat,  6 Mar 2021 01:28:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbhCFA12 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 19:27:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbhCFA1V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 19:27:21 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CCCBC06175F;
        Fri,  5 Mar 2021 16:27:21 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id 81so3861914iou.11;
        Fri, 05 Mar 2021 16:27:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=Q/HXWttyCz6xiiWFlRnm7r5gpSoAnWK/+zNynBc0D98=;
        b=eDku9/ffHX7O+26PCDHJ8NPdgSm7y1WpHBD1ndWVfp0EFQDFSXVdXInHRwaoM22qDJ
         fFNpzMfup1DD/39ak2z2C6aNu0b9Q3MUg2TAuFNOSH9BC9joKdfRCxDgpTNvkIcLI3B1
         2a5XMN8S6DB133Gwf3oIzDQ9cG7dQDHxO6fk3WsHrS4MSHcQ0egsHk9zpjlMtHgv3/oS
         DvkLNso+XlUCsZaYPYGVlf1HxR/FnteAalMv/c/RfuptRKgkeJA++MDb46SmHthgipo4
         TAjN2aKRapXyY+e6oYabL8cvhoyQ35rBog+xMCFAr19ocEauFe77Bf5csvE8oGnsgiKT
         bfig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=Q/HXWttyCz6xiiWFlRnm7r5gpSoAnWK/+zNynBc0D98=;
        b=SfVCzTTBQTDJSdWTUZuSg/zbOYxEK7WaMCHRp0h32F+5FzhqywtEzDzZYPkUD0NMRX
         +aNGruLPbxE5QA8Iq7BXxgwdFqyQmJ94jZ2zOAdMkSC3pLAZYe95I6XpsowpjdxVTD2y
         Axs3xy+1RYQz27lQErWdeJ4JWSOr+h/hrtYmBeIFDXX3Y1UbC+54azoh20ul4daHZZYQ
         owkDQEwuLazdvdfd1JfsAOLIG1wJa08by988moKVnjP86uJ3UI7lkYuwp5csRMjaifFs
         ybTJ3iqBFr18SjYEEuCc71GzE3pHEQnh/fa1qxuHoUDFf14FekVK/9RMWYrptmmPaTeH
         MkMQ==
X-Gm-Message-State: AOAM533UcFNzIQqWAYBJ7DLzkJ91P+ubQCTfn3r3D6s6zJKoWx2+Lx60
        +H7FvtG7BycXAX7U3j5rSKI=
X-Google-Smtp-Source: ABdhPJxHBZdu5HGV/jxOjtmK6FG3ajWfS10TFUBSwF2RwbfbOtsM/op2T3xFythDej5jKRtB0bpI8A==
X-Received: by 2002:a02:77ca:: with SMTP id g193mr12542831jac.41.1614990440874;
        Fri, 05 Mar 2021 16:27:20 -0800 (PST)
Received: from localhost ([172.243.146.206])
        by smtp.gmail.com with ESMTPSA id q15sm2128045ilt.30.2021.03.05.16.27.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 16:27:20 -0800 (PST)
Date:   Fri, 05 Mar 2021 16:27:11 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        duanxiongchun@bytedance.com,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>
Message-ID: <6042cc5f4f65a_135da20824@john-XPS-13-9370.notmuch>
In-Reply-To: <CAM_iQpXXUv1FV8DQ85a2fs08JCfKHHt-fAWYbV0TTWmwUZ-K5Q@mail.gmail.com>
References: <20210302023743.24123-1-xiyou.wangcong@gmail.com>
 <20210302023743.24123-3-xiyou.wangcong@gmail.com>
 <CACAyw9-SjsNn4_J1KDXuFh1nd9Hr-Mo+=7S-kVtooJwdi1fodQ@mail.gmail.com>
 <CAM_iQpXqE9qJ=+zKA6H1Rq=KKgm8LZ=p=ZtvrrH+hfSrTg+zxw@mail.gmail.com>
 <CAM_iQpXXUv1FV8DQ85a2fs08JCfKHHt-fAWYbV0TTWmwUZ-K5Q@mail.gmail.com>
Subject: Re: [Patch bpf-next v2 2/9] sock: introduce sk_prot->update_proto()
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang wrote:
> On Tue, Mar 2, 2021 at 10:23 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > On Tue, Mar 2, 2021 at 8:22 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
> > >
> > > On Tue, 2 Mar 2021 at 02:37, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > >
> > > ...
> > > >  static inline void sk_psock_restore_proto(struct sock *sk,
> > > >                                           struct sk_psock *psock)
> > > >  {
> > > >         sk->sk_prot->unhash = psock->saved_unhash;
> > >
> > > Not related to your patch set, but why do an extra restore of
> > > sk_prot->unhash here? At this point sk->sk_prot is one of our tcp_bpf
> > > / udp_bpf protos, so overwriting that seems wrong?

"extra"? restore_proto should only be called when the psock ref count
is zero and we need to transition back to the original socks proto
handlers. To trigger this we can simply delete a sock from the map.
In the case where we are deleting the psock overwriting the tcp_bpf
protos is exactly what we want.?

> >
> > Good catch. It seems you are right, but I need a double check. And
> > yes, it is completely unrelated to my patch, as the current code has
> > the same problem.
> 
> Looking at this again. I noticed
> 
> commit 4da6a196f93b1af7612340e8c1ad8ce71e18f955
> Author: John Fastabend <john.fastabend@gmail.com>
> Date:   Sat Jan 11 06:11:59 2020 +0000
> 
>     bpf: Sockmap/tls, during free we may call tcp_bpf_unhash() in loop
> 
> intentionally fixed a bug in kTLS with overwriting this ->unhash.
> 
> I agree with you that it should not be updated for sockmap case,
> however I don't know what to do with kTLS case, it seems the bug the
> above commit fixed still exists if we just revert it.
> 
> Anyway, this should be targeted for -bpf as a bug fix, so it does not
> belong to this patchset.
> 
> Thanks.

Hi,

I'm missing the error case here. The restore logic happens when the refcnt
hits 0 on the psock, indicating its time to garbage collect the psock. 

 sk_psock_put
   if (refcount_dec_and_test(&psock->refcnt))
    sk_psock_drop(sk, psock);
      sk_psock_restore_proto(sk, psock)
         sk->sk_prot->unhash = psock->saved_unhash

When sockets are initialized via sk_psock_init() we opulate the unhash field

 psock->saved_unhash = prot->unhash;

So we need to unwind this otherwise a future unhash() call would not call
the original protos unhash handler.

Care to give me some more context on what the bug is?

Thanks,
John
