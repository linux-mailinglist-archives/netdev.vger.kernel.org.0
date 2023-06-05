Return-Path: <netdev+bounces-8085-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 11827722A50
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 17:08:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 43E921C20BB2
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 15:08:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 113A71F931;
	Mon,  5 Jun 2023 15:08:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3EE71F169
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 15:08:42 +0000 (UTC)
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20494D2;
	Mon,  5 Jun 2023 08:08:41 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id 98e67ed59e1d1-256931ec244so4199110a91.3;
        Mon, 05 Jun 2023 08:08:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685977720; x=1688569720;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qfcSNUYUmDUgquuvvHEXrBXWzd6JH10uE8W/bdq1wnA=;
        b=ICpze0AqwuFmYOgDUEmRa3QpzXBKVAHqOA7og3EWW3qA/8JQgi/DpJHQJzGLnLn2cy
         CVxWwhuD1ZnTc7OGnm5sUi+LGYm7mI+dQ2pc6TPOs0jbi4z49sMsvaLE17Xjo7HV4IWj
         ZOe+uk+zE+90pmq1dFz3xoD6/ogL27QXJF9FsZ7at25pr0ITI88jLCxdG78Urz3c7keo
         Pblf9c5JVMVfpDjyKCOFjUPQXsP2wOsyF69EvXM5nkDOaWrOYtkvgDj2FTk/J21nyobB
         01iohAuw4Ld9viaX8DP1q1gMOLIDMR6zlMrbMTPOv8nDhhw6QEJQ91jiNNjr49V4gqQJ
         ksgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685977720; x=1688569720;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qfcSNUYUmDUgquuvvHEXrBXWzd6JH10uE8W/bdq1wnA=;
        b=MF9SKHXZLUuvCCDckNASH+ct0C2zM7EkRCGUlKY9o864rgQ714NlGRplMhf9+VuDtL
         t7GGQo7xglOGiVqW2CdK8+UXM8CEpr914hBv5djRiqO+S1Nkc9Rem14gPYywhTSr6xcv
         bme4nn/2ebRA0aqJDnnRoSZd2D0UFJtAatnyo+LofT3H5BQRLVICTKe39fS8s8v8nKl8
         QUxjMjnG2J3q4udgZbyCLJvISAjd7ogCDxyacxaIN8zzHqUeI0WuSuHqRlqdGy6P3b5B
         inejNFxpkIYEDj1BVGRitLRo4Y2NOUTOXEl3F5GH++pKeta+NdFVEvzXsNicH9CW9Jej
         G5pA==
X-Gm-Message-State: AC+VfDySGEfxV2VHQhDBnrltcF0BXv/2wJtSZYG2RcJ1gZXNl7/dnaR6
	QmNNoGysiT5cOy/e+RttfkmDQ0WrmehdCciD3F0=
X-Google-Smtp-Source: ACHHUZ6pXV8q1rJ5RRvcqIO8cB26hqFAIJ997bObF4oXwe9sUn8cQs/9VJj/X0hq8+T7qn8Sl7uchaEnqD/6IhCswr8=
X-Received: by 2002:a17:90a:9201:b0:255:cddf:a0c8 with SMTP id
 m1-20020a17090a920100b00255cddfa0c8mr7152108pjo.41.1685977720251; Mon, 05 Jun
 2023 08:08:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230529092840.40413-1-linyunsheng@huawei.com>
 <20230529092840.40413-3-linyunsheng@huawei.com> <977d55210bfcb4f454b9d740fcbe6c451079a086.camel@gmail.com>
 <2e4f0359-151a-5cff-6d31-0ea0f014ef9a@huawei.com> <CAKgT0UcGYXstFP_H8VQtUooYEaYgDpG_crkodYOEyX4q0D58LQ@mail.gmail.com>
 <8c9d5dd8-b654-2d50-039d-9b7732e7746f@huawei.com> <CAKgT0UchHBO+kyPZMYJR7JHfqYsk+qSeuvXzA-H9w3VH-9Tfrg@mail.gmail.com>
 <f5e372ca-e637-4873-0bea-b1b19c623124@gmail.com>
In-Reply-To: <f5e372ca-e637-4873-0bea-b1b19c623124@gmail.com>
From: Alexander Duyck <alexander.duyck@gmail.com>
Date: Mon, 5 Jun 2023 08:08:04 -0700
Message-ID: <CAKgT0UfsKzaQT3NffKTcuWXGup595Z-sXiqX5vtvjypXJ4QHkA@mail.gmail.com>
Subject: Re: [PATCH net-next v2 2/3] page_pool: support non-frag page for page_pool_alloc_frag()
To: Yunsheng Lin <yunshenglin0825@gmail.com>
Cc: Yunsheng Lin <linyunsheng@huawei.com>, davem@davemloft.net, kuba@kernel.org, 
	pabeni@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Lorenzo Bianconi <lorenzo@kernel.org>, Jesper Dangaard Brouer <hawk@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 2, 2023 at 9:20=E2=80=AFPM Yunsheng Lin <yunshenglin0825@gmail.=
com> wrote:
>
> On 2023/6/2 23:57, Alexander Duyck wrote:
> > On Fri, Jun 2, 2023 at 5:23=E2=80=AFAM Yunsheng Lin <linyunsheng@huawei=
.com> wrote:
>
> ...
>
> >>
> >> According to my defination in this patchset:
> >> frag page: page alloced from page_pool_alloc_frag() with page->pp_frag=
_count
> >>            being greater than one.
> >> non-frag page:page alloced return from both page_pool_alloc_frag() and
> >>               page_pool_alloc_pages() with page->pp_frag_count being o=
ne.
> >>
> >> I assume the above 'non-page pool pages' refer to what I call as 'non-=
frag
> >> page' alloced return from both page_pool_alloc_frag(), right? And it i=
s
> >> still about doing the (size << 1 > max_size)' checking at the begin in=
stead
> >> of at the middle right now to avoid extra steps for 'non-frag page' ca=
se?
> >
> > Yeah, the non-page I was referring to were you mono-frag pages.
>
> I was using 'frag page' and 'non-frag page' per the defination above,
> and you were using 'mono-frag' mostly and 'non-page' sometimes.
> I am really confused by them as I felt like I got what they meant and
> then I was lost when you used them in the next comment. I really hope
> that you could describe what do you mean in more detailed by using
> 'mono-frag pages' and 'non-page', so that we can choose the right
> naming to continue the discussion without further misunderstanding
> and confusion.

I will try to be consistent about this going forward:
non-fragmented - legacy page pool w/o page frags
mono-frag - after this page page pool w/o frags
fragmented - before/after this patch w/ frags

> >
> >>>
> >>>>>
> >>>>>> -    if (page && *offset + size > max_size) {
> >>>>>> +    if (page) {
> >>>>>> +            *offset =3D pool->frag_offset;
> >>>>>> +
> >>>>>> +            if (*offset + size <=3D max_size) {
> >>>>>> +                    pool->frag_users++;
> >>>>>> +                    pool->frag_offset =3D *offset + size;
> >>>>>> +                    alloc_stat_inc(pool, fast);
> >>>>>> +                    return page;
> >>>>
> >>>> Note that we still allow frag page here when '(size << 1 > max_size)=
'.
> >>
> >> This is the optimization I was taking about: suppose we start
> >> from a clean state with 64K page size, if page_pool_alloc_frag()
> >> is called with size being 2K and then 34K, we only need one page
> >> to satisfy caller's need as we do the '*offset + size > max_size'
> >> checking before the '(size << 1 > max_size)' checking.
> >
> > The issue is the unaccounted for waste. We are supposed to know the
> > general size of the frags being used so we can compute truesize. If
>
> Note, for case of veth and virtio_net, the driver may only know the
> current frag size when calling page_pool_alloc_frag(), it does not
> konw what is the size of the frags will be used next time, how exactly
> are we going to compute the truesize for cases with different frag
> size?  As far as I can tell, we may only do something like virtio_net
> is doing with 'page_frag' for the last frag as below, for other frags,
> the truesize may need to take accounting to the aligning requirement:
> https://elixir.bootlin.com/linux/v6.3.5/source/drivers/net/virtio_net.c#L=
1638

Yeah, that is more-or-less what I am getting at. This is why drivers
will tend to want to allocate a mono-frag themselves and then take
care of adding additional fragmentation as needed. If you are
abstracting that away from the driver then it makes it much harder to
track that truesize.

> > for example you are using an order 3 page and you are splitting it
> > between a 2K and a 17K fragment the 2K fragments will have a massive
> > truesize underestimate that can lead to memory issues if those smaller
> > fragments end up holding onto the pages.
> >
> > As such we should try to keep the small fragments away from anything
> > larger than half of the page.
>
> IMHO, doing the above only alleviate the problem. How is above splitting
> different from splitting it evently with 16 2K fragments, and when 15 fra=
g
> is released, we still have the last 2K fragment holding onto 32K memory,
> doesn't that also cause massive truesize underestimate? Not to mention th=
at
> for system with 64K page size.

Yes, that is a known issue. That is why I am not wanting us to further
exacerbate the issue.

> In RFC patch below, 'page_pool_frag' is used to report the truesize, but
> I was thinking both 'page_frag' and 'page_frag_cache' both have a similia=
r
> problem, so I dropped it in V1 and left that as a future improvement.
>
> I can pick it up again if 'truesize' is really the concern, but we have t=
o
> align on how to compute the truesize here first.
>
> https://patchwork.kernel.org/project/netdevbpf/patch/20230516124801.2465-=
4-linyunsheng@huawei.com/

I am assuming this is the same one you mentioned in the other patch.
As I said the problem is the remainder is being ignored. The logic
should be pushed to the drivers to handle the truesize and is one of
the reasons why the expectation is that either the driver will use
something like a fixed constant size if it is using the raw page pool
fragments, or if it is going to do random sized chunks then it will
track the size of the chunks of the page is it using and assign the
remainders to the last fragment used in a given page.

