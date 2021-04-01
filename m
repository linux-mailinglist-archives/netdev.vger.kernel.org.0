Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76EBE351F5F
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 21:13:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234550AbhDATNF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 15:13:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234326AbhDATMe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 15:12:34 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04261C02FEA2;
        Thu,  1 Apr 2021 11:03:15 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id 184so3169633ljf.9;
        Thu, 01 Apr 2021 11:03:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5j2wGNIifPE9DtC+i6h/LtepDO3gR15cYtvvyMQ28/U=;
        b=oBhXLAryHgdavgOFDKjAdEEQzuPceFFXRQEKJnryrnFiyJH3+NvTPdmlT3ka+E75Ky
         2GGyGGfaM1HeTORchAhAL+ID5cQ66pp+gqYBeSOJxViKDf5sVKlZWMraaUyTd6JVAuz/
         UDaZGJIywBfzqW/VHohhL3NTl1l+PjAaK9gaeVD1beWxWGH9byY+MPZ4WZZb7Zghi2ND
         clZC64HExAl2F4Ot9mHfVxbxVEkZFSrdFVfI3kmlfW+TaWVf56JaVSvgwaRf2ccT+qDH
         GvAfRel7S+u5Msn4hKawitEA68iaLFR9sPk9WEL3K9F5FlWzcOtqmfzosXvvHPeFjaGp
         PO5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5j2wGNIifPE9DtC+i6h/LtepDO3gR15cYtvvyMQ28/U=;
        b=cI32w4ZDSzvMlWFZ8rabDHSWeEqPtQmKyfx8uAH4tTgEelsDH2OvNNTcVvCEKlkcjL
         spslJe+duEzllgijFt3FmZSycyY5dJ5ZVv4EQ084Qr+9rRbI/p61ntFeIizlbN2ewy8y
         xeGQBA/+ANUYcTaq+tioALmgkB5WKGenhGUzjCs2mAe9imJJe6vqxQhCnJpGRJBKzAFS
         /5LZqCfvDOAmHQWY53MjWKS+uyqQOBDdBx8OlPWlwfQTVCU7YloJ2pPV5XU9aB1Rz9pW
         bEpRogXo8Pec43y+EQ1ge44PwTYkr4pTvQ54s25sqYydGxwYEdewc2694cwD43SN4zAu
         LiJg==
X-Gm-Message-State: AOAM532hz4Vc/SAcAD7cu0iAxmZUPk1XjKrbTwpRIZMDV3JqBfrBFb1h
        c7R2vQFXryC9d3VIEH2gULn75haZG1OU7aqf72vpTPc4
X-Google-Smtp-Source: ABdhPJxMeAkRSh/QhjsbprT+ZINUC9UiSXuyyNvDFfVrVlxS1LiwX81cTGzomh1B923wkeLS80bbLZlc/GK8N+pLNSc=
X-Received: by 2002:a2e:981a:: with SMTP id a26mr6123992ljj.204.1617300193470;
 Thu, 01 Apr 2021 11:03:13 -0700 (PDT)
MIME-Version: 1.0
References: <20210331023237.41094-1-xiyou.wangcong@gmail.com> <6065fa04de8a2_4ff9208b1@john-XPS-13-9370.notmuch>
In-Reply-To: <6065fa04de8a2_4ff9208b1@john-XPS-13-9370.notmuch>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 1 Apr 2021 11:03:01 -0700
Message-ID: <CAADnVQKj__ZSDnCdZDuRzFAp9E8TBkLrX_3WWccT=UxVzk86aA@mail.gmail.com>
Subject: Re: [Patch bpf-next v8 00/16] sockmap: introduce BPF_SK_SKB_VERDICT
 and support UDP
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, duanxiongchun@bytedance.com,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        jiang.wang@bytedance.com, Cong Wang <cong.wang@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 1, 2021 at 10:52 AM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Cong Wang wrote:
> > From: Cong Wang <cong.wang@bytedance.com>
> >
> > We have thousands of services connected to a daemon on every host
> > via AF_UNIX dgram sockets, after they are moved into VM, we have to
> > add a proxy to forward these communications from VM to host, because
> > rewriting thousands of them is not practical. This proxy uses an
> > AF_UNIX socket connected to services and a UDP socket to connect to
> > the host. It is inefficient because data is copied between kernel
> > space and user space twice, and we can not use splice() which only
> > supports TCP. Therefore, we want to use sockmap to do the splicing
> > without going to user-space at all (after the initial setup).
> >
> > Currently sockmap only fully supports TCP, UDP is partially supported
> > as it is only allowed to add into sockmap. This patchset, as the second
> > part of the original large patchset, extends sockmap with:
> > 1) cross-protocol support with BPF_SK_SKB_VERDICT; 2) full UDP support.
> >
> > On the high level, ->read_sock() is required for each protocol to support
> > sockmap redirection, and in order to do sock proto update, a new ops
> > ->psock_update_sk_prot() is introduced, which is also required. And the
> > BPF ->recvmsg() is also needed to replace the original ->recvmsg() to
> > retrieve skmsg. To make life easier, we have to get rid of lock_sock()
> > in sk_psock_handle_skb(), otherwise we would have to implement
> > ->sendmsg_locked() on top of ->sendmsg(), which is ugly.
> >
> > Please see each patch for more details.
> >
> > To see the big picture, the original patchset is available here:
> > https://github.com/congwang/linux/tree/sockmap
> > this patchset is also available:
> > https://github.com/congwang/linux/tree/sockmap2
> >
> > ---
>
> This LGTM, thanks for doing this Cong.

Applied. Thanks everyone.
Cong, please follow up with minor cleanup that John requested.
