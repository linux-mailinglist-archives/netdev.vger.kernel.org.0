Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11AC032F798
	for <lists+netdev@lfdr.de>; Sat,  6 Mar 2021 02:56:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbhCFBzp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 20:55:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbhCFBzl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 20:55:41 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C34BC06175F;
        Fri,  5 Mar 2021 17:55:41 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id h18so3772057ils.2;
        Fri, 05 Mar 2021 17:55:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=aOVYAb+KXR2Cpa7O8OGF7IMXeWDHtyxHenJJFtNIB2M=;
        b=EfNNpRy9/ld1rADWLV+QcrCUSdUr7fe+oxydmn2pQQFVJEJ29aaw4uf8lAaEltuxEn
         BOfR4fv8g46pPCZDXSbEQSeu5O6fpzkO8Rk+aMPzfy1wWYwZOrMfL6I48+eg9AILIUxa
         C12nXLhzOt0ugmtx4PrAM0oxKQwu+xntbYOUUN97UmuC/VoTOH3wfw5OBnVDW4f6yWL0
         u5wcEsCxji7LOeFTIsxK0wjXgzKNtk8dCZATTzB28VbkNMJC8c9VvpaU2aQCT2ZaghUn
         YhxpO+A6B40PcKICQsO9kU1fTFGd/pMtkYh7TwajPzOBRZVjR6h+z3XgNGDMmeFQ7tcq
         R9qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=aOVYAb+KXR2Cpa7O8OGF7IMXeWDHtyxHenJJFtNIB2M=;
        b=dAEe+C6YrF5p09vwY/907TfEBoPeqfStN4V8yFakNjlJ7MSyVygDHAqPar3Jtrf2T4
         m6suxdxR0x8uf/5bVl+tz9WSL9iqxB0M0ymuMgaqfFQqR18Drt2Ncs58atzSCOJU2qoX
         b7BTKgPWRNxuW+wXs5Rt701UMwqQ3Zf2c5cqvgbhbkCwofPooNIFX2BAd74TUfJPItt/
         sipbucA7Lkju8jZXYxfoVsCD2mkCfezjevecgTKjqEXYRsSHawdFW+IjhvjYYU+u6G1x
         ERZr8tsMlAHS0+NZHKdr4bCgCSpIULAeuPJUyUenR+vOSr0Eq2ctdUJm2jDjnTuZQkOE
         5+2Q==
X-Gm-Message-State: AOAM532MHABekb4B3K5ZoPXsHUaVOKfO8Qcf6z1Udd4pUfyhYvFCANPb
        4OMdGXZFJDsXuqrlxzNQFck=
X-Google-Smtp-Source: ABdhPJyVal7sZUp4vP4/vfKcMnv2JHiZYVTJcNW6FOWZxhWhXn6TJ8G7opwDFpTaJizuwsvb9LmROw==
X-Received: by 2002:a92:b00d:: with SMTP id x13mr11369737ilh.128.1614995740483;
        Fri, 05 Mar 2021 17:55:40 -0800 (PST)
Received: from localhost ([172.243.146.206])
        by smtp.gmail.com with ESMTPSA id k14sm1962998ilv.41.2021.03.05.17.55.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 17:55:39 -0800 (PST)
Date:   Fri, 05 Mar 2021 17:55:32 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Lorenz Bauer <lmb@cloudflare.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        duanxiongchun@bytedance.com,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>
Message-ID: <6042e114a1c9e_135da20839@john-XPS-13-9370.notmuch>
In-Reply-To: <CAM_iQpUr7cvuXXdtYN9_MQPYy_Tfi88fBGSo3c8RRpMFBr55Og@mail.gmail.com>
References: <20210302023743.24123-1-xiyou.wangcong@gmail.com>
 <20210302023743.24123-3-xiyou.wangcong@gmail.com>
 <CACAyw9-SjsNn4_J1KDXuFh1nd9Hr-Mo+=7S-kVtooJwdi1fodQ@mail.gmail.com>
 <CAM_iQpXqE9qJ=+zKA6H1Rq=KKgm8LZ=p=ZtvrrH+hfSrTg+zxw@mail.gmail.com>
 <CAM_iQpXXUv1FV8DQ85a2fs08JCfKHHt-fAWYbV0TTWmwUZ-K5Q@mail.gmail.com>
 <6042cc5f4f65a_135da20824@john-XPS-13-9370.notmuch>
 <CAM_iQpUr7cvuXXdtYN9_MQPYy_Tfi88fBGSo3c8RRpMFBr55Og@mail.gmail.com>
Subject: Re: [Patch bpf-next v2 2/9] sock: introduce sk_prot->update_proto()
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang wrote:
> On Fri, Mar 5, 2021 at 4:27 PM John Fastabend <john.fastabend@gmail.com> wrote:
> >
> > Cong Wang wrote:
> > > On Tue, Mar 2, 2021 at 10:23 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > > >
> > > > On Tue, Mar 2, 2021 at 8:22 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
> > > > >
> > > > > On Tue, 2 Mar 2021 at 02:37, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > > > >
> > > > > ...
> > > > > >  static inline void sk_psock_restore_proto(struct sock *sk,
> > > > > >                                           struct sk_psock *psock)
> > > > > >  {
> > > > > >         sk->sk_prot->unhash = psock->saved_unhash;
> > > > >
> > > > > Not related to your patch set, but why do an extra restore of
> > > > > sk_prot->unhash here? At this point sk->sk_prot is one of our tcp_bpf
> > > > > / udp_bpf protos, so overwriting that seems wrong?
> >
> > "extra"? restore_proto should only be called when the psock ref count
> > is zero and we need to transition back to the original socks proto
> > handlers. To trigger this we can simply delete a sock from the map.
> > In the case where we are deleting the psock overwriting the tcp_bpf
> > protos is exactly what we want.?
> 
> Why do you want to overwrite tcp_bpf_prots->unhash? Overwriting
> tcp_bpf_prots is correct, but overwriting tcp_bpf_prots->unhash is not.
> Because once you overwrite it, the next time you use it to replace
> sk->sk_prot, it would be a different one rather than sock_map_unhash():
> 
> // tcp_bpf_prots->unhash == sock_map_unhash
> sk_psock_restore_proto();
> // Now  tcp_bpf_prots->unhash is inet_unhash
> ...
> sk_psock_update_proto();
> // sk->sk_proto is now tcp_bpf_prots again,
> // so its ->unhash now is inet_unhash
> // but it should be sock_map_unhash here

Right, we can fix this on the TLS side. I'll push a fix shortly.

> 
> Thanks.


