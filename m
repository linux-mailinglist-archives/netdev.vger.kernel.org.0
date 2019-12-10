Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9E6011916D
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 21:02:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726522AbfLJUCZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 15:02:25 -0500
Received: from mail-lj1-f173.google.com ([209.85.208.173]:36430 "EHLO
        mail-lj1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726062AbfLJUCZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 15:02:25 -0500
Received: by mail-lj1-f173.google.com with SMTP id r19so21342601ljg.3
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 12:02:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dev-mellanox-co-il.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9ZYclKpP4jyyryWq+kzkCBY1iMTu2OfnAQ/Q1iOaCSc=;
        b=BeFsyYbr8G0yJ4qRAzrgtavEuzD4XmUKwPTDYfW/EnRUDv6hfN8ClFGYwtTGZiEEwh
         vcusHhjAT2Re3cmAuW8iDek4CTgF6pBhYrw0ol9Mh9CHt2sfaO+CHd0tcI1iJ4yJ6WCf
         kkhYLj0OeM1f1hTJs0vs9caKk180Qps2ZP3doY4xcF8it1RT9YWqporSmrQqU6AdOhW7
         USfPIrWHDmhQ33wltkPTiipo2Ms5swjN0+Zs/2uk1fay+KY77RmOrlx1LrETE8Y7Hg9G
         WujQ3B0pXqv+SK2EhnG8yoNctFD9t7np9bRVrW82F5VxNPtFokqY7gvx1kqO0V054bJM
         uEFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9ZYclKpP4jyyryWq+kzkCBY1iMTu2OfnAQ/Q1iOaCSc=;
        b=RraGZeRd3lRj9OgMVnCNYn7RV+NB4nOO7bJHVWVLL0+QcPEX4H9NR8ukUL8IA34Xqv
         KJTeU5SdUy/Oa2OoviaxK2EWrSJ+3h0WXHKMxhR+oUmgeLEQE2OSuvSxYOwNqPsGmPYV
         5Cjp9Btd6iqSFDtn+f6h35pRE1ZwWmdlfiWt3AzQSBBclhD+L55VLeRuunTh5LYTTY3E
         m/ZFIP5TF7h3S83+wWD+LR2z7Vgq2g82cqxfZeXhYtwhExOWy+oHzBShJeob/cmoAHik
         b+ZHPkIOx+rumTX7iOgyktq5t/+tjIyIxOSEHOBDPrCdBWJxfIHo8P4lEZzWataSg73q
         SPpA==
X-Gm-Message-State: APjAAAVccmBWfifRkZ6vwvINyEkMfPGEwggmMwyC6uyAkZwbmZEWj2TG
        4FpVxAOHt8XSaBvDh2YYGAwMk89duq1dyIXQ4Wza8Q==
X-Google-Smtp-Source: APXvYqxhHRb9dfhLqw+xg5goWfInptZhvg3+vt8yVQVDP04XG1AQkxBGxlAgz59l68MaQeO8IxUT8ZNuqE4sJTilj90=
X-Received: by 2002:a2e:2417:: with SMTP id k23mr6885881ljk.29.1576008143103;
 Tue, 10 Dec 2019 12:02:23 -0800 (PST)
MIME-Version: 1.0
References: <1575624767-3343-1-git-send-email-lirongqing@baidu.com>
 <9fecbff3518d311ec7c3aee9ae0315a73682a4af.camel@mellanox.com>
 <20191209131416.238d4ae4@carbon> <816bc34a7d25881f35e0c3e21dc2283ffeffb093.camel@mellanox.com>
 <20191210150244.GB12702@apalos.home>
In-Reply-To: <20191210150244.GB12702@apalos.home>
From:   Saeed Mahameed <saeedm@dev.mellanox.co.il>
Date:   Tue, 10 Dec 2019 12:02:12 -0800
Message-ID: <CALzJLG_m0haciU6AinMvy3MfGGFokfGf+1djRnfsZczgxnuKUg@mail.gmail.com>
Subject: Re: [PATCH][v2] page_pool: handle page recycle for NUMA_NO_NODE condition
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>,
        "linyunsheng@huawei.com" <linyunsheng@huawei.com>,
        Li Rongqing <lirongqing@baidu.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 10, 2019 at 7:02 AM Ilias Apalodimas
<ilias.apalodimas@linaro.org> wrote:
>
> Hi Saeed,
>
> > >
> > > The patch description doesn't explain the problem very well.
> > >
> > > Lets first establish what the problem is.  After I took at closer
> > > look,
> > > I do think we have a real problem here...
> > >
> > > If function alloc_pages_node() is called with NUMA_NO_NODE (see below
> > > signature), then the nid is re-assigned to numa_mem_id().
> > >
> > > Our current code checks: page_to_nid(page) == pool->p.nid which seems
> > > bogus, as pool->p.nid=NUMA_NO_NODE and the page NID will not return
> > > NUMA_NO_NODE... as it was set to the local detect numa node, right?
> > >
> >
> > right.
> >
> > > So, we do need a fix... but the question is that semantics do we
> > > want?
> > >
> >
> > maybe assume that __page_pool_recycle_direct() is always called from
> > the right node and change the current bogus check:
>
> Is this a typo? pool_page_reusable() is called from __page_pool_put_page().
>
> page_pool_put_page and page_pool_recycle_direct() (no underscores) call that.

Yes a typo :) , thanks for the correction.

> Can we guarantee that those will always run from the correct cpu?
No, but we add the tool to correct any discrepancy: page_pool_nid_changed()

> In the current code base if they are only called under NAPI this might be true.
> On the page_pool skb recycling patches though (yes we'll eventually send those
> :)) this is called from kfree_skb().
> I don't think we can get such a guarantee there, right?
>

Yes, but this has nothing to do with page recycling from pool's owner
level (driver napi)
 for SKB recycling we can use pool.nid to recycle, and not numa_mem_id().

> Regards
> /Ilias
