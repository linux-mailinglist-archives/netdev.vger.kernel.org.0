Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69AAD3E7BBF
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 17:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241713AbhHJPJj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 11:09:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234153AbhHJPJi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 11:09:38 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F30E9C0613C1;
        Tue, 10 Aug 2021 08:09:15 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id by4so11991005edb.0;
        Tue, 10 Aug 2021 08:09:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b0qx+Njy5wjsGCuQs/S8necS9TJBtTm2vQbhGNR/470=;
        b=vBUaA+wBZx7k0zK99Z5M1RUOkgwL5zB4o4VPs3s2zd5aTihdbBbL7ipiJNhBRsRDc2
         kTeamPh8dFG8+jS8xSNDE2dCWTa2VE/7b1s3kTVUGK4haWpMEhLNYlqe6PEIB7DWFd4N
         iTOwwoQ6Gb2/AUgFXDb8DECHgZgpXKneh9mXqScX6sbA5E1VXpnpnpUs9ZSWsmYJdyGw
         Cna26VTRF1OJ1bRXEJI88unNERomiGhthbQE43tZgXc6weSs1UXCStv1YhAxnRUHq+TD
         FfrkdqlFTOKXe5n9ss2iE2h9ekkNYAYv73irROfyntc07hMlUWc+XHiSARgnohDgSX7Q
         +B2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b0qx+Njy5wjsGCuQs/S8necS9TJBtTm2vQbhGNR/470=;
        b=mqnbC9u1Mf2/BnSf+xxfR9VPSqjkLklmBoIYyoh6xnM98b2Y9iRyNFsNnHyC983Im0
         yciiqB6O+wv/9yex4NAfxgWxOlHu2iwqZVpPI3H3yXNnVKFsmnav08aLCNqnpq+9n0Lb
         m//tKsP3BHySD74CJyNd/NZxZikXPPEJIazYgtMm/DQ2emTHCgCttbSUMedXH93F05Gm
         inOKmTyLtCAbOeI3N4WI+9wDrKDwVwqnKmrKJiNRGoQqy0yfl94dKhsnW8Hs6QX3tJ2t
         V4AiOzZqWPHztMBCvFWcWeDh9iI0DrA8cSodizM3Bse9bFRof9BU5vC9Q5seb+1Ligel
         weSQ==
X-Gm-Message-State: AOAM5300GzFzJmUbf9uGXWDHzpdn1Kwksmfpsfd6KAMSMABO4B3uHnYF
        1A9gR5tNefI3EKyJTgTKTsaBuqjfIWr4j2lhuA8=
X-Google-Smtp-Source: ABdhPJydan88txV3yl8ZL1SxjFwwVvw3reqBDkba+sbdJg9uHA5RPvb5fIVMLyZiO1LqS159akkkMYZtKyyX4ZcYoEA=
X-Received: by 2002:a05:6402:5161:: with SMTP id d1mr5505826ede.50.1628608154430;
 Tue, 10 Aug 2021 08:09:14 -0700 (PDT)
MIME-Version: 1.0
References: <1628217982-53533-1-git-send-email-linyunsheng@huawei.com>
 <20210810070159.367e680e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <1eb903a5-a954-e405-6088-9b9209703f5e@redhat.com> <20210810074306.6cbd1a73@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210810074306.6cbd1a73@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 10 Aug 2021 08:09:03 -0700
Message-ID: <CAKgT0Uc7fRGDjQZf_pPNW2AN5yspkqTc8v9Sj8_zbBP_Tq1-gw@mail.gmail.com>
Subject: Re: [PATCH net-next v2 0/4] add frag page support in page pool
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Miller <davem@davemloft.net>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Marcin Wojtas <mw@semihalf.com>, linuxarm@openeuler.org,
        yisen.zhuang@huawei.com, Salil Mehta <salil.mehta@huawei.com>,
        thomas.petazzoni@bootlin.com, hawk@kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>, fenghua.yu@intel.com,
        guro@fb.com, Peter Xu <peterx@redhat.com>,
        Feng Tang <feng.tang@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Matteo Croce <mcroce@microsoft.com>,
        Hugh Dickins <hughd@google.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Willem de Bruijn <willemb@google.com>, wenxu@ucloud.cn,
        Cong Wang <cong.wang@bytedance.com>,
        Kevin Hao <haokexin@gmail.com>, nogikh@google.com,
        Marco Elver <elver@google.com>, Yonghong Song <yhs@fb.com>,
        kpsingh@kernel.org, andrii@kernel.org,
        Martin KaFai Lau <kafai@fb.com>, songliubraving@fb.com,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        chenhao288@hisilicon.com, Linux-MM <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 10, 2021 at 7:43 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 10 Aug 2021 16:23:52 +0200 Jesper Dangaard Brouer wrote:
> > On 10/08/2021 16.01, Jakub Kicinski wrote:
> > > On Fri, 6 Aug 2021 10:46:18 +0800 Yunsheng Lin wrote:
> > >> enable skb's page frag recycling based on page pool in
> > >> hns3 drvier.
> > >
> > > Applied, thanks!
> >
> > I had hoped to see more acks / reviewed-by before this got applied.
> > E.g. from MM-people as this patchset changes struct page and page_pool
> > (that I'm marked as maintainer of).
>
> Sorry, it was on the list for days and there were 7 or so prior
> versions, I thought it was ripe. If possible, a note that review
> will come would be useful.
>
> > And I would have appreciated an reviewed-by credit to/from Alexander
> > as he did a lot of work in the RFC patchset for the split-page tricks.
>
> I asked him off-list, he said something I interpreted as "code is okay,
> but the review tag is not coming".

Yeah, I ran out of feedback a revision or two ago and just haven't had
a chance to go through and add my reviewed by. If you want feel free
to add my reviewed by for the set.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
