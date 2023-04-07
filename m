Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25E686DAF26
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 17:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240205AbjDGPCk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 11:02:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240214AbjDGPCS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 11:02:18 -0400
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E4A1C662
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 08:01:32 -0700 (PDT)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-536af432ee5so801220697b3.0
        for <netdev@vger.kernel.org>; Fri, 07 Apr 2023 08:01:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680879690; x=1683471690;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vnqwNZmtFr/9a1bxscC53xO8jKUkg+SntwjX4FwfO2Y=;
        b=f5toBGM2MAyNUDvtLMocDZO27KFcE3QXYwSHAPPs0eSao0t9/OmqZYqQLelyzj3QHZ
         +PXNMTYatS8NYNSm8iwk6pHqP5mKNElDlVrV4xoxtxcQzk8rQ3ozbJHpEkFW9rR/VKlY
         IrdK7fVnsaopeun4LJ7jJbH2JO0bBdy2IrdNFUGYguaYKNOxhWUS4lAqnZebHXNTPV/f
         TITLfB1HqrKArprslkL7JSpmJpp4DmkefWloQR163OJFhxTt4e0/EuNE0iTShjZkli0p
         4OhDkpZh+r24n0vpH2bnyxYAkaZZBT3iYrNNO6xOuuMWLW9ifkCsOBP+S/6phZ51A3xs
         nvvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680879690; x=1683471690;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vnqwNZmtFr/9a1bxscC53xO8jKUkg+SntwjX4FwfO2Y=;
        b=7oG1kz3XwL/0ZTVBRvgYcFk+JGwJZAPxbKddlOxWzjOiTdWR4n/6cdxVQHL5+mhf74
         4LKvlbIOwDkul57M0XuQhcm1MWc2YlZyzgu/8ncOlxan5GPDmo3jgKrX4ocYOPPqrCH0
         CT0sv+2qQQVjrPHHpx+eJHAtOfuzpMvcuUseNT/1VeUDxtZumt/eSdAWjcTEe7D4woDA
         IrgfmG2P1edXlW1oPLOUQDIalOONwNtlRi8WR3IG/yKigGVVrLc3dJbs9seOGjKz6iaJ
         wE0xuw9/uPKMvGLzPMZKiYM9Xr0iO/TRjRLnX34T6X8/faizL44WZF5bjgM5OuY4vsrD
         EA+g==
X-Gm-Message-State: AAQBX9dsGSaWzYmq2z11K3JanOSmSX0oCDdGWzq/6AbZcRARhXInSwo/
        OutWo2HUB7NPfk9NiY041s/vGU0gs+eHfgzoLC0=
X-Google-Smtp-Source: AKy350bI8jqCDEufPLTs/SFzeBER3Gle3q3LrXhTFqk4KiB9OOpTte4TPPyMqePvp8gMnNFffIAa7hDe9qRsOyOeeZQ=
X-Received: by 2002:a81:af55:0:b0:544:bce8:980f with SMTP id
 x21-20020a81af55000000b00544bce8980fmr1295475ywj.6.1680879689866; Fri, 07 Apr
 2023 08:01:29 -0700 (PDT)
MIME-Version: 1.0
References: <20230406114825.18597-1-liangchen.linux@gmail.com>
 <ed4b1f1bf72ea1234a283a26d88e00658e9e4311.camel@gmail.com> <7e163f24-c469-421c-3f2f-40aec177cee9@huawei.com>
In-Reply-To: <7e163f24-c469-421c-3f2f-40aec177cee9@huawei.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 7 Apr 2023 08:01:14 -0700
Message-ID: <CAKgT0Ud1+OCxYby5Vor34uAT02L9PAh3JS+WJ3AhxSBtZVkUgg@mail.gmail.com>
Subject: Re: [PATCH v2] skbuff: Fix a race between coalescing and releasing SKBs
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Liang Chen <liangchen.linux@gmail.com>, kuba@kernel.org,
        ilias.apalodimas@linaro.org, hawk@kernel.org, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 7, 2023 at 1:06=E2=80=AFAM Yunsheng Lin <linyunsheng@huawei.com=
> wrote:
>
> On 2023/4/6 23:25, Alexander H Duyck wrote:
> > On Thu, 2023-04-06 at 19:48 +0800, Liang Chen wrote:
> >> Commit 1effe8ca4e34 ("skbuff: fix coalescing for page_pool fragment
> >> recycling") allowed coalescing to proceed with non page pool page and
> >> page pool page when @from is cloned, i.e.
> >>
> >> to->pp_recycle    --> false
> >> from->pp_recycle  --> true
> >> skb_cloned(from)  --> true
> >>
> >> However, it actually requires skb_cloned(@from) to hold true until
> >> coalescing finishes in this situation. If the other cloned SKB is
> >> released while the merging is in process, from_shinfo->nr_frags will b=
e
> >> set to 0 towards the end of the function, causing the increment of fra=
g
> >> page _refcount to be unexpectedly skipped resulting in inconsistent
> >> reference counts. Later when SKB(@to) is released, it frees the page
> >> directly even though the page pool page is still in use, leading to
> >> use-after-free or double-free errors.
> >>
> >> So it needs to be specially handled at where the ref count may get los=
t.
> >>
> >> The double-free error message below prompted us to investigate:
> >> BUG: Bad page state in process swapper/1  pfn:0e0d1
> >> page:00000000c6548b28 refcount:-1 mapcount:0 mapping:0000000000000000
> >> index:0x2 pfn:0xe0d1
> >> flags: 0xfffffc0000000(node=3D0|zone=3D1|lastcpupid=3D0x1fffff)
> >> raw: 000fffffc0000000 0000000000000000 ffffffff00000101 00000000000000=
00
> >> raw: 0000000000000002 0000000000000000 ffffffffffffffff 00000000000000=
00
> >> page dumped because: nonzero _refcount
> >>
> >> CPU: 1 PID: 0 Comm: swapper/1 Tainted: G            E      6.2.0+
> >> Call Trace:
> >>  <IRQ>
> >> dump_stack_lvl+0x32/0x50
> >> bad_page+0x69/0xf0
> >> free_pcp_prepare+0x260/0x2f0
> >> free_unref_page+0x20/0x1c0
> >> skb_release_data+0x10b/0x1a0
> >> napi_consume_skb+0x56/0x150
> >> net_rx_action+0xf0/0x350
> >> ? __napi_schedule+0x79/0x90
> >> __do_softirq+0xc8/0x2b1
> >> __irq_exit_rcu+0xb9/0xf0
> >> common_interrupt+0x82/0xa0
> >> </IRQ>
> >> <TASK>
> >> asm_common_interrupt+0x22/0x40
> >> RIP: 0010:default_idle+0xb/0x20
> >>
> >> Signed-off-by: Liang Chen <liangchen.linux@gmail.com>
> >> ---
> >> Changes from v1:
> >> - deal with the ref count problem instead of return back to give more =
opportunities to coalesce skbs.
> >> ---
> >>  net/core/skbuff.c | 22 ++++++++++++++++++++--
> >>  1 file changed, 20 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> >> index 050a875d09c5..77da8ce74a1e 100644
> >> --- a/net/core/skbuff.c
> >> +++ b/net/core/skbuff.c
> >> @@ -5643,7 +5643,19 @@ bool skb_try_coalesce(struct sk_buff *to, struc=
t sk_buff *from,
> >>
> >>              skb_fill_page_desc(to, to_shinfo->nr_frags,
> >>                                 page, offset, skb_headlen(from));
> >> -            *fragstolen =3D true;
> >> +
> >> +            /* When @from is pp_recycle and @to isn't, coalescing is
> >> +             * allowed to proceed if @from is cloned. However if the
> >> +             * execution reaches this point, @from is already transit=
ioned
> >> +             * into non-cloned because the other cloned skb is releas=
ed
> >> +             * somewhere else concurrently. In this case, we need to =
make
> >> +             * sure the ref count is incremented, not directly steali=
ng
> >> +             * from page pool.
> >> +             */
> >> +            if (to->pp_recycle !=3D from->pp_recycle)
> >> +                    get_page(page);
> >> +            else
> >> +                    *fragstolen =3D true;
> >>      } else {
> >>              if (to_shinfo->nr_frags +
> >>                  from_shinfo->nr_frags > MAX_SKB_FRAGS)
> >> @@ -5659,7 +5671,13 @@ bool skb_try_coalesce(struct sk_buff *to, struc=
t sk_buff *from,
> >>             from_shinfo->nr_frags * sizeof(skb_frag_t));
> >>      to_shinfo->nr_frags +=3D from_shinfo->nr_frags;
> >>
> >> -    if (!skb_cloned(from))
> >> +    /* Same situation as above where head data presents. When @from i=
s
> >> +     * pp_recycle and @to isn't, coalescing is allowed to proceed if =
@from
> >> +     * is cloned. However @from can be transitioned into non-cloned
> >> +     * concurrently by this point. If it does happen, we need to make=
 sure
> >> +     * the ref count is properly incremented.
> >> +     */
> >> +    if (to->pp_recycle =3D=3D from->pp_recycle && !skb_cloned(from))
> >>              from_shinfo->nr_frags =3D 0;
> >>
> >>      /* if the skb is not cloned this does nothing
> >
> > So looking this over I believe this should resolve the issue you
> > pointed out while maintaining current functionality.
> >
> > Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
> >
> > One follow-on that we may want to do with this would be to look at
> > consolidating the 3 spots where we are checking for our combination of
> > pp_recycle comparison and skb_cloned and maybe pass one boolean flag
> > indicating that we have to transfer everything by taking page
> > references.
> >
> > Also I think we can actually increase the number of cases where we
> > support coalescing if we were to take apart the skb_head_is_locked call
> > and move the skb_cloned check from it into your recycle check in the
> > portion where we are stealing from the header.
> While at it, as we have already add additional checks to handle the below
> case:
>  to->pp_recycle    --> false
>  from->pp_recycle  --> true
>  skb_cloned(from)  --> false
>
> Does it make sense to relax the checking at the beginning to allow
> the above case to support coalescing from the beginning?
>
> Also, dose moving to a per-page marker make sense if we want to
> remove those additional checking?

Actually based on the comments from v2 it sounds like we may want to
actually go the other way and instead just limit the cases where we
combine frames and see if anyone complains of a performance drop as a
result. The general idea being to avoid having all the extra checks
throughout the code should improve performance in the general case.
