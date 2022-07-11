Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74544570722
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 17:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbiGKPbj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 11:31:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbiGKPbh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 11:31:37 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8F2832BB6
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 08:31:36 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id y3so5248967iof.4
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 08:31:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PgjtMKx82Ha0xzGT0joQY6Dgypk3fOXA2ZJySWudeNE=;
        b=f/n6PmV4BJ9hS28+50nbrINjplzp/XEDOzsmaxtcfSeE6W1LKuYtIHfAUrm07lirCf
         UdCpI8YC889sPsv3DGgady302QlvmYI93J6oz5qFlN5iot5tfhEZ0RmmZCwyVvv8xokJ
         JCti32Ie5Sssm+EqAW65GCSL33tMglFJSTiGo0xJsCeotAlEcpyPmW77LKBo2mpxEzA7
         Yr9/UlDReU6B2jirinYTwnDbTFyxPvtNBSR1pqgb1wUn5eNF6FwP/iof4SYfESYQpygI
         lxdfwJKDC884MWnfwckdcLitr4C4XkzvylM4+V+ZbEp7JBh7DjouM096abNkgReiKNhP
         o0zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PgjtMKx82Ha0xzGT0joQY6Dgypk3fOXA2ZJySWudeNE=;
        b=6EnEQAPd1xjs0B2/c9FhZmsjy9jhuopRYWEGblNOhtIO841KXgXl9arKR7/E49A4OM
         QHpclkYnFTPCiBjBdxSIXRc9HwuDpulSuOiZT1m4TwSoBPCEdkqTDUVS8Jk1sHOnDIkS
         rrcUDepqzEKxkCg1FDmPm44HLN6KXJtEBswU4H++uuX2evLFsZEYWlieRI8FPosdifdk
         kezqw/bxYvXFfiPaZbzV3yN6zV8uTgQDat2R/02MjbwORxLiIuu+H724K9+Vvki4hJ58
         aG+dK4DgT8xldPCHjEU0u9jMAIUvSnbvvrZi8bVp1WWxGLkKuINo6kczyhNtsNeRP0Jz
         Lkjg==
X-Gm-Message-State: AJIora+JyFtmDwL50pOVBTPp4SmUh2AxJf91yx7MyfPODZg3rb6Mq0Ep
        mk7V6D0U2FjNwAOyq3Vy6XDLTohHqRdLyMVNtmZNBw==
X-Google-Smtp-Source: AGRyM1vzFAhmqwNiUyjK3PRAfFyHQbSSBthV60rU8JQzh38GVefFuGhR6Ek36qXkTVw47zE1M+JE9eLOm/xgMTEGHi0=
X-Received: by 2002:a05:6638:2614:b0:33f:5bc2:b385 with SMTP id
 m20-20020a056638261400b0033f5bc2b385mr2240731jat.246.1657553495781; Mon, 11
 Jul 2022 08:31:35 -0700 (PDT)
MIME-Version: 1.0
References: <b4d8cb09c913d3e34f853736f3f5628abfd7f4b6.1656699567.git.gnault@redhat.com>
 <CANn89i+=GyHjkrHMZAftB-toEhi9GcAQom1_bpT+S0qMvCz0DQ@mail.gmail.com>
 <429C561E-2F85-4DB5-993C-B2DD4E575BF0@redhat.com> <e8de4a15c934658b06ee1de10fd21975b972f902.camel@hammerspace.com>
 <9ADC95E9-7756-4706-8B45-E1BB65020216@redhat.com>
In-Reply-To: <9ADC95E9-7756-4706-8B45-E1BB65020216@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 11 Jul 2022 17:31:24 +0200
Message-ID: <CANn89i+EKvfthJJbThWoG2fKaY9ACZ_cEZuNfXw7v9WVWGLksQ@mail.gmail.com>
Subject: Re: [RFC net] Should sk_page_frag() also look at the current GFP context?
To:     Benjamin Coddington <bcodding@redhat.com>
Cc:     Trond Myklebust <trondmy@hammerspace.com>,
        Scott Mayhew <smayhew@redhat.com>,
        David Miller <davem@davemloft.net>,
        Chuck Lever <chuck.lever@oracle.com>,
        Steve French <sfrench@samba.org>, Tejun Heo <tj@kernel.org>,
        Anna Schumaker <anna@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jeff Layton <jlayton@kernel.org>,
        Guillaume Nault <gnault@redhat.com>,
        Josef Bacik <josef@toxicpanda.com>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 11, 2022 at 4:07 PM Benjamin Coddington <bcodding@redhat.com> wrote:
>
> On 8 Jul 2022, at 16:04, Trond Myklebust wrote:
>
> > On Fri, 2022-07-08 at 14:10 -0400, Benjamin Coddington wrote:
> >> On 7 Jul 2022, at 12:29, Eric Dumazet wrote:
> >>
> >>> On Fri, Jul 1, 2022 at 8:41 PM Guillaume Nault <gnault@redhat.com>
> >>> wrote:
> >>>>
> >>>> I'm investigating a kernel oops that looks similar to
> >>>> 20eb4f29b602 ("net: fix sk_page_frag() recursion from memory
> >>>> reclaim")
> >>>> and dacb5d8875cc ("tcp: fix page frag corruption on page fault").
> >>>>
> >>>> This time the problem happens on an NFS client, while the
> >>>> previous
> >>>> bzs
> >>>> respectively used NBD and CIFS. While NBD and CIFS clear __GFP_FS
> >>>> in
> >>>> their socket's ->sk_allocation field (using GFP_NOIO or
> >>>> GFP_NOFS),
> >>>> NFS
> >>>> leaves sk_allocation to its default value since commit
> >>>> a1231fda7e94
> >>>> ("SUNRPC: Set memalloc_nofs_save() on all rpciod/xprtiod jobs").
> >>>>
> >>>> To recap the original problems, in commit 20eb4f29b602 and
> >>>> dacb5d8875cc,
> >>>> memory reclaim happened while executing tcp_sendmsg_locked(). The
> >>>> code
> >>>> path entered tcp_sendmsg_locked() recursively as pages to be
> >>>> reclaimed
> >>>> were backed by files on the network. The problem was that both
> >>>> the
> >>>> outer and the inner tcp_sendmsg_locked() calls used
> >>>> current->task_frag,
> >>>> thus leaving it in an inconsistent state. The fix was to use the
> >>>> socket's ->sk_frag instead for the file system socket, so that
> >>>> the
> >>>> inner and outer calls wouln't step on each other's toes.
> >>>>
> >>>> But now that NFS doesn't modify ->sk_allocation anymore,
> >>>> sk_page_frag()
> >>>> sees sunrpc sockets as plain TCP ones and returns ->task_frag in
> >>>> the
> >>>> inner tcp_sendmsg_locked() call.
> >>>>
> >>>> Also it looks like the trend is to avoid GFS_NOFS and GFP_NOIO
> >>>> and
> >>>> use
> >>>> memalloc_no{fs,io}_save() instead. So maybe other network file
> >>>> systems
> >>>> will also stop setting ->sk_allocation in the future and we
> >>>> should
> >>>> teach sk_page_frag() to look at the current GFP flags. Or should
> >>>> we
> >>>> stick to ->sk_allocation and make NFS drop __GFP_FS again?
> >>>>
> >>>> Signed-off-by: Guillaume Nault <gnault@redhat.com>
> >>>
> >>> Can you provide a Fixes: tag ?
> >>>
> >>>> ---
> >>>>  include/net/sock.h | 8 ++++++--
> >>>>  1 file changed, 6 insertions(+), 2 deletions(-)
> >>>>
> >>>> diff --git a/include/net/sock.h b/include/net/sock.h
> >>>> index 72ca97ccb460..b934c9851058 100644
> >>>> --- a/include/net/sock.h
> >>>> +++ b/include/net/sock.h
> >>>> @@ -46,6 +46,7 @@
> >>>>  #include <linux/netdevice.h>
> >>>>  #include <linux/skbuff.h>      /* struct sk_buff */
> >>>>  #include <linux/mm.h>
> >>>> +#include <linux/sched/mm.h>
> >>>>  #include <linux/security.h>
> >>>>  #include <linux/slab.h>
> >>>>  #include <linux/uaccess.h>
> >>>> @@ -2503,14 +2504,17 @@ static inline void
> >>>> sk_stream_moderate_sndbuf(struct sock *sk)
> >>>>   * socket operations and end up recursing into sk_page_frag()
> >>>>   * while it's already in use: explicitly avoid task page_frag
> >>>>   * usage if the caller is potentially doing any of them.
> >>>> - * This assumes that page fault handlers use the GFP_NOFS flags.
> >>>> + * This assumes that page fault handlers use the GFP_NOFS flags
> >>>> + * or run under memalloc_nofs_save() protection.
> >>>>   *
> >>>>   * Return: a per task page_frag if context allows that,
> >>>>   * otherwise a per socket one.
> >>>>   */
> >>>>  static inline struct page_frag *sk_page_frag(struct sock *sk)
> >>>>  {
> >>>> -       if ((sk->sk_allocation & (__GFP_DIRECT_RECLAIM |
> >>>> __GFP_MEMALLOC | __GFP_FS)) ==
> >>>> +       gfp_t gfp_mask = current_gfp_context(sk->sk_allocation);
> >>>
> >>> This is slowing down TCP sendmsg() fast path, reading current-
> >>>> flags,
> >>> possibly cold value.
> >>
> >> True - current->flags is pretty distant from current->task_frag.
> >>
> >>> I would suggest using one bit in sk, close to sk->sk_allocation to
> >>> make the decision,
> >>> instead of testing sk->sk_allocation for various flags.
> >>>
> >>> Not sure if we have available holes.
> >>
> >> Its looking pretty packed on my build.. the nearest hole is 5
> >> cachelines
> >> away.
> >>
> >> It'd be nice to allow network filesystem to use task_frag when
> >> possible.
> >>
> >> If we expect sk_page_frag() to only return task_frag once per call
> >> stack,
> >> then can we simply check it's already in use, perhaps by looking at
> >> the
> >> size field?
> >>
> >> Or maybe can we set sk_allocation early from current_gfp_context()
> >> outside
> >> the fast path?
> >
> > Why not just add a bit to sk->sk_allocation itself, and have
> > __sock_create() default to setting it when the 'kern' parameter is non-
> > zero? NFS is not alone in following the request of the mm team to
> > deprecate use of GFP_NOFS and GFP_NOIO.
>
> Can we overload sk_allocation safely?  There's 28 GFP flags already, I'm
> worried about unintended consequences if sk_allocation gets passed on.
>
> What about a flag in sk_gso_type?  Looks like there's 13 free there, and its
> in the same cacheline as sk_allocation and sk_frag.

I think we could overload GFP_COMP with little risk.
