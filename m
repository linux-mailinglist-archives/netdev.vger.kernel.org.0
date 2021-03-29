Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D71834D59A
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 18:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230271AbhC2Q6V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 12:58:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231165AbhC2Q5u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 12:57:50 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F178BC061756;
        Mon, 29 Mar 2021 09:57:49 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id w10so5464303pgh.5;
        Mon, 29 Mar 2021 09:57:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yKtD8fWqk2355xw9C9tVZQcNDiJlwXI9InjlBQFl8LU=;
        b=AzTokCLDF0OFb+1zTKqURy9tcJWt442+N5IjCbS3rdzx6Atroii0a5fWeax3J/vcDi
         174clcJ8uYerF082H6vrqeccy8OvyaXEYDej3CgikkYy+iTyg0rbWHLSafQAW+QKlAbv
         3yzs2e56k4Y2laZrKDO8agXZhTp5idIy6A11WK3MG/jHLk3jjw6TxgZhldRY6UUxzz9h
         xRoXCWNdQHJc6lwn2RHCyUNzXeKWmhZoJCOuw34n5tTWMd9EHrL9TFI1x3RM+Sj+VUGF
         fjRfpxfGG+pruHt+UgAMF1YBCyKK92GcU7L4jLmWyxDbRTxOm2mbaxySI8ihCxuGGHEz
         zOSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yKtD8fWqk2355xw9C9tVZQcNDiJlwXI9InjlBQFl8LU=;
        b=Epvq+oRoDVGPY15rkPvkXbcc7knXFF/qTt+4WWBoG0FFAzCBnJnVsSl7dYBL7qeFiZ
         Fmk2ZQm0ZuAKAfuy1D031/e+qoYfVizIiLN4rpkoamOszzbwqnuEjMDOvtvzX5DQ3Awe
         rDMNFOf9nO/bRaIBoiBjwnCiR6/Z5jIUyflp1urmmraISid21mPa5rDLN1jOccBUwKLD
         s22lafL4ZKxgiQeu7OUSqffaGl9YRYphZlnRgBRhMOr7C8OTxC3QJl+gTiXzVVoVfGDm
         zoi2iVgyo+4LNjccy8yBMWQnPG+ANhebBKh5XlPr9V3yN25oOicsT+LTQsl1s7gRxBIC
         kbHg==
X-Gm-Message-State: AOAM533coTOlqQRrZG7BOkNPmXVQEbr0W+pkm9WNTxO86b1gmkTwgIyl
        HTporJtMZrRJ9CRBrdY18MA1sB3J1JEqZHGC6sY=
X-Google-Smtp-Source: ABdhPJwYRtpm4GZ025JNM2SCBJZP2ef2zS/h4460kaZN/ZoWh22bWXVJq/2Jh08ndLfzmusI8nHff/LxdTSjcgv4j3s=
X-Received: by 2002:a63:1c4c:: with SMTP id c12mr24449321pgm.179.1617037069416;
 Mon, 29 Mar 2021 09:57:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210328202013.29223-1-xiyou.wangcong@gmail.com>
 <20210328232759.2ixde3jvudnl3pi6@ast-mbp> <6061ec2bc63e0_3673a20848@john-XPS-13-9370.notmuch>
In-Reply-To: <6061ec2bc63e0_3673a20848@john-XPS-13-9370.notmuch>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 29 Mar 2021 09:57:38 -0700
Message-ID: <CAM_iQpV3d6_RMcuwF6BmR635og0=FUy7siN-0MNchR9_sXz2cg@mail.gmail.com>
Subject: Re: [Patch bpf-next v7 00/13] sockmap: introduce BPF_SK_SKB_VERDICT
 and support UDP
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, duanxiongchun@bytedance.com,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 29, 2021 at 8:03 AM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Alexei Starovoitov wrote:
> > On Sun, Mar 28, 2021 at 01:20:00PM -0700, Cong Wang wrote:
> > > From: Cong Wang <cong.wang@bytedance.com>
> > >
> > > We have thousands of services connected to a daemon on every host
> > > via AF_UNIX dgram sockets, after they are moved into VM, we have to
> > > add a proxy to forward these communications from VM to host, because
> > > rewriting thousands of them is not practical. This proxy uses an
> > > AF_UNIX socket connected to services and a UDP socket to connect to
> > > the host. It is inefficient because data is copied between kernel
> > > space and user space twice, and we can not use splice() which only
> > > supports TCP. Therefore, we want to use sockmap to do the splicing
> > > without going to user-space at all (after the initial setup).
> > >
> > > Currently sockmap only fully supports TCP, UDP is partially supported
> > > as it is only allowed to add into sockmap. This patchset, as the second
> > > part of the original large patchset, extends sockmap with:
> > > 1) cross-protocol support with BPF_SK_SKB_VERDICT; 2) full UDP support.
> > >
> > > On the high level, ->read_sock() is required for each protocol to support
> > > sockmap redirection, and in order to do sock proto update, a new ops
> > > ->psock_update_sk_prot() is introduced, which is also required. And the
> > > BPF ->recvmsg() is also needed to replace the original ->recvmsg() to
> > > retrieve skmsg. To make life easier, we have to get rid of lock_sock()
> > > in sk_psock_handle_skb(), otherwise we would have to implement
> > > ->sendmsg_locked() on top of ->sendmsg(), which is ugly.
> > >
> > > Please see each patch for more details.
> > >
> > > To see the big picture, the original patchset is available here:
> > > https://github.com/congwang/linux/tree/sockmap
> > > this patchset is also available:
> > > https://github.com/congwang/linux/tree/sockmap2
> > >
> > > ---
> > > v7: use work_mutex to protect psock->work
> > >     return err in udp_read_sock()
> > >     add patch 6/13
> > >     clean up test case
> >
> > The feature looks great to me.
> > I think the selftest is a bit light in terms of coverage, but it's acceptable.
>
> +1

Well, the first half of this patchset still focuses on the existing code, which
is already covered by existing test cases. The second half adds
BPF_SK_SKB_VERDICT and UDP support, which are already covered by
my new test case. And apparently UDP will never support other sockmap
programs like TCP, for example, BPF_SK_SKB_STREAM_PARSER, hence
it of course has much less test cases than TCP. Cross-protocol test case
will be added in the next patchset when AF_UNIX comes in.

If I miss anything, please be specific. Just saying the test case is light does
not help me to understand what I need to add.

Thanks.
