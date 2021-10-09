Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A93DE427D3F
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 22:16:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230419AbhJIUSl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 16:18:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230205AbhJIUSk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 16:18:40 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBDE1C061570;
        Sat,  9 Oct 2021 13:16:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=QCahwkB1CqDtILURVeqMuorUmriTCbVy3djEQFfSyiI=; b=FZ/0xfnHz/A7L+ZVNvwuiGfM0y
        uL6tehn83mI4lK5C5+Z0le/6YHz3DicNN8TsgUkOXKSocLrkU6un1Fakb2/A3JKh5GEm1XudzRFwK
        rLsCUHfo9ae4C3eiivJOmpwy4xLQ4JTdUqVDDvS3fHvNH/4lVNU5piqyozccRvNdgdhg0hOBWvV/y
        tFgH1X3fRv3si0Y7RHTlmSBIGece5oa/lw7nl3EDNh3AgGE7rur2H+vFVuciGEr5zo5Ofr/iTVb5b
        RsAVUPdUfXMdTIsEBQuQvh6lM3Mb06SgUf1VOdFmZcc0mo1XrcQa/l/CJZBY1JNfgSfNxBksV7Mvf
        QYA7FWww==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mZIkj-004NjC-8Q; Sat, 09 Oct 2021 20:15:44 +0000
Date:   Sat, 9 Oct 2021 21:15:29 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     John Hubbard <jhubbard@nvidia.com>
Cc:     Yunsheng Lin <linyunsheng@huawei.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@openeuler.org,
        akpm@linux-foundation.org, hawk@kernel.org,
        ilias.apalodimas@linaro.org, peterz@infradead.org,
        yuzhao@google.com, will@kernel.org, jgg@ziepe.ca,
        mcroce@microsoft.com, willemb@google.com, cong.wang@bytedance.com,
        pabeni@redhat.com, haokexin@gmail.com, nogikh@google.com,
        elver@google.com, memxor@gmail.com, vvs@virtuozzo.com,
        linux-mm@kvack.org, edumazet@google.com, alexander.duyck@gmail.com,
        dsahern@gmail.com
Subject: Re: [PATCH net-next -v5 3/4] mm: introduce __get_page() and
 __put_page()
Message-ID: <YWH4YbkC+XtpXTux@casper.infradead.org>
References: <20211009093724.10539-1-linyunsheng@huawei.com>
 <20211009093724.10539-4-linyunsheng@huawei.com>
 <62106771-7d2a-3897-c318-79578360a88a@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62106771-7d2a-3897-c318-79578360a88a@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 09, 2021 at 12:49:29PM -0700, John Hubbard wrote:
> On 10/9/21 02:37, Yunsheng Lin wrote:
> > Introduce __get_page() and __put_page() to operate on the
> > base page or head of a compound page for the cases when a
> > page is known to be a base page or head of a compound page.
> 
> Hi,
> 
> I wonder if you are aware of a much larger, 137-patch seriesto do that:
> folio/pageset [1]?
> 
> The naming you are proposing here does not really improve clarity. There
> is nothing about __get_page() that makes it clear that it's meant only
> for head/base pages, while get_page() tail pages as well. And the
> well-known and widely used get_page() and put_page() get their meaning
> shifted.
> 
> This area is hard to get right, and that's why there have been 15
> versions, and a lot of contention associated with [1]. If you have an
> alternate approach, I think it would be better in its own separate
> series, with a cover letter that, at a minimum, explains how it compares
> to folios/pagesets.

I wasn't initially sure whether network pagepools should be part of
struct folio or should be their own separate type.  At this point, I
think they should be a folio.  But that's all kind of irrelevant until
Linus decides whether he's going to take the folio patchset or not.
Feel free to let him know your opinion when the inevitable argument
blows up again around the next pull request.
