Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 081A53C1F79
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 08:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230312AbhGIGpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 02:45:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbhGIGpT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 02:45:19 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09CADC0613DD
        for <netdev@vger.kernel.org>; Thu,  8 Jul 2021 23:42:36 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id i94so10626231wri.4
        for <netdev@vger.kernel.org>; Thu, 08 Jul 2021 23:42:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qHTJW5H6d8k1HLBDdIQvlDQXDDtk1CFz9cW6t5rpE/8=;
        b=IK9aCN5uHz9KtOTLg7kb2t0QBUHcIAFh8YomVEodFtnIIwpUnREF3l0BptA3PHC3oL
         TObNSVCoFPH3aAU/H7OZu0tffSMn7GsoxLpvXfeHX4jomEibMItEHuOyU0vYRRIRnXCl
         nSusf0VqBDq5QeA7RPwIDLiwqLmtbCddCvcy1ID/hdUW6hF3Kq1ccgNXTP35IoVzkKc8
         YLSdDgwYW/+EwWILNtKFzGQZ0yOjsBrR1f6hmQxU+T+0+E8nDwCN2WBOuoX1ZTUOc0CD
         m9KdD8A4KcRLX/IFqm9rtg+fziNjoLVeOo4j2YL49RBQprUhMMRjQ6iMRm0H5FX77dHi
         M+Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qHTJW5H6d8k1HLBDdIQvlDQXDDtk1CFz9cW6t5rpE/8=;
        b=Tl252d0FNI9JbsWFus2ZTSoYlrlcGIi7wZVYrg/qP88HuGW+TGmnH5OpDblA2ZaNYC
         +F8xPAdrcgSAmgOCIkgysUAoJ59LS19cNeoDPJ0bNBPI0F+zyLyyHo1wwrvELYU1ZxGj
         rGmZDIJTgflkQsaGg4RtEBfNEKdDorsUjggxq7Fum9qNKBu/nK45M2JjdPVDAdYgjGmG
         Y0G/7ohbvxfJj2y6SPp0b5gNtBmetyw56FzZdaSEd+wpSMW9qHSfJ0b6JWFjBB0lSva3
         r6YhEVqqpvWKkENskWnCIkb2DDBTgHxJAnYGPzsDMKAUW5vtEy1afLyXYcpeAYTDdCae
         L/hg==
X-Gm-Message-State: AOAM533a/p4YSLUwPfBiYNnyuiREZElEVQVcsPDjzC3k30H/WnDSQjEM
        u6C9dZ/D6ALAnpugBQ+bUjEh9A==
X-Google-Smtp-Source: ABdhPJyKEIo3G0BYLSLpp46ldKF1ju300cAigaG5ONCI4bb6N2wbBQHOaZMHiAtN1lc5eYDd1qsW3w==
X-Received: by 2002:a05:6000:1104:: with SMTP id z4mr40349565wrw.164.1625812954610;
        Thu, 08 Jul 2021 23:42:34 -0700 (PDT)
Received: from enceladus (ppp-94-66-242-227.home.otenet.gr. [94.66.242.227])
        by smtp.gmail.com with ESMTPSA id p5sm4458335wrd.25.2021.07.08.23.42.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jul 2021 23:42:34 -0700 (PDT)
Date:   Fri, 9 Jul 2021 09:42:30 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Matteo Croce <mcroce@linux.microsoft.com>,
        Marcin Wojtas <mw@semihalf.com>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Sven Auhagen <sven.auhagen@voleatech.de>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linuxarm@openeuler.org,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Roman Gushchin <guro@fb.com>, Peter Xu <peterx@redhat.com>,
        feng.tang@intel.com, Jason Gunthorpe <jgg@ziepe.ca>,
        Matteo Croce <mcroce@microsoft.com>,
        Hugh Dickins <hughd@google.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Willem de Bruijn <willemb@google.com>,
        wenxu <wenxu@ucloud.cn>, Cong Wang <cong.wang@bytedance.com>,
        Kevin Hao <haokexin@gmail.com>,
        Aleksandr Nogikh <nogikh@google.com>,
        Marco Elver <elver@google.com>, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        bpf@vger.kernel.org
Subject: Re: [PATCH net-next RFC 0/2] add elevated refcnt support for page
 pool
Message-ID: <YOfv1vHcZPBvyfaN@enceladus>
References: <1625044676-12441-1-git-send-email-linyunsheng@huawei.com>
 <20210702153947.7b44acdf@linux.microsoft.com>
 <20210706155131.GS22278@shell.armlinux.org.uk>
 <CAFnufp1hM6WRDigAsSfM94yneRhkmxBoGG7NxRUkbfTR2WQvyA@mail.gmail.com>
 <CAPv3WKdQ5jYtMyZuiKshXhLjcf9b+7Dm2Lt2cjE=ATDe+n9A5g@mail.gmail.com>
 <CAFnufp0NaPSkMQC-3ne49FL3Ak+UV0a7QoXELvVuMzBR4+GZ_g@mail.gmail.com>
 <14a92860-67cc-b2ac-efba-dd482f03204b@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14a92860-67cc-b2ac-efba-dd482f03204b@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 09, 2021 at 02:40:02PM +0800, Yunsheng Lin wrote:
> On 2021/7/9 12:15, Matteo Croce wrote:
> > On Wed, Jul 7, 2021 at 6:50 PM Marcin Wojtas <mw@semihalf.com> wrote:
> >>
> >> Hi,
> >>
> >>
> >> ??r., 7 lip 2021 o 01:20 Matteo Croce <mcroce@linux.microsoft.com> napisa??(a):
> >>>
> >>> On Tue, Jul 6, 2021 at 5:51 PM Russell King (Oracle)
> >>> <linux@armlinux.org.uk> wrote:
> >>>>
> >>>> On Fri, Jul 02, 2021 at 03:39:47PM +0200, Matteo Croce wrote:
> >>>>> On Wed, 30 Jun 2021 17:17:54 +0800
> >>>>> Yunsheng Lin <linyunsheng@huawei.com> wrote:
> >>>>>
> >>>>>> This patchset adds elevated refcnt support for page pool
> >>>>>> and enable skb's page frag recycling based on page pool
> >>>>>> in hns3 drvier.
> >>>>>>
> >>>>>> Yunsheng Lin (2):
> >>>>>>   page_pool: add page recycling support based on elevated refcnt
> >>>>>>   net: hns3: support skb's frag page recycling based on page pool
> >>>>>>
> >>>>>>  drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  79 +++++++-
> >>>>>>  drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |   3 +
> >>>>>>  drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |   1 +
> >>>>>>  drivers/net/ethernet/marvell/mvneta.c              |   6 +-
> >>>>>>  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |   2 +-
> >>>>>>  include/linux/mm_types.h                           |   2 +-
> >>>>>>  include/linux/skbuff.h                             |   4 +-
> >>>>>>  include/net/page_pool.h                            |  30 ++-
> >>>>>>  net/core/page_pool.c                               | 215
> >>>>>> +++++++++++++++++---- 9 files changed, 285 insertions(+), 57
> >>>>>> deletions(-)
> >>>>>>
> >>>>>
> >>>>> Interesting!
> >>>>> Unfortunately I'll not have access to my macchiatobin anytime soon, can
> >>>>> someone test the impact, if any, on mvpp2?
> >>>>
> >>>> I'll try to test. Please let me know what kind of testing you're
> >>>> looking for (I haven't been following these patches, sorry.)
> >>>>
> >>>
> >>> A drop test or L2 routing will be enough.
> >>> BTW I should have the macchiatobin back on friday.
> >>
> >> I have a 10G packet generator connected to 10G ports of CN913x-DB - I
> >> will stress mvpp2 in l2 forwarding early next week (I'm mostly AFK
> >> this until Monday).
> >>
> > 
> > I managed to to a drop test on mvpp2. Maybe there is a slowdown but
> > it's below the measurement uncertainty.
> > 
> > Perf top before:
> > 
> > Overhead  Shared O  Symbol
> >    8.48%  [kernel]  [k] page_pool_put_page
> >    2.57%  [kernel]  [k] page_pool_refill_alloc_cache
> >    1.58%  [kernel]  [k] page_pool_alloc_pages
> >    0.75%  [kernel]  [k] page_pool_return_skb_page
> > 
> > after:
> > 
> > Overhead  Shared O  Symbol
> >    8.34%  [kernel]  [k] page_pool_put_page
> >    4.52%  [kernel]  [k] page_pool_return_skb_page
> >    4.42%  [kernel]  [k] page_pool_sub_bias
> >    3.16%  [kernel]  [k] page_pool_alloc_pages
> >    2.43%  [kernel]  [k] page_pool_refill_alloc_cache
> 
> Hi, Matteo
> Thanks for the testing.
> it seems you have adapted the mvpp2 driver to use the new frag
> API for page pool, There is one missing optimization for XDP case,
> the page is always returned to the pool->ring regardless of the
> context of page_pool_put_page() for elevated refcnt case.
> 
> Maybe adding back that optimization will close some gap of the above
> performance difference if the drop is happening in softirq context.
> 

I think what Matteo did was a pure netstack test.  We'll need testing on
both XDP and normal network cases to be able to figure out the exact
impact.

Thanks
/Ilias
> > 
> > Regards,
> > 
