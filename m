Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80E803BDFBA
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 01:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbhGFXXE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 19:23:04 -0400
Received: from linux.microsoft.com ([13.77.154.182]:42192 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbhGFXXE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Jul 2021 19:23:04 -0400
Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
        by linux.microsoft.com (Postfix) with ESMTPSA id EEDBB20B8763;
        Tue,  6 Jul 2021 16:20:24 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com EEDBB20B8763
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1625613625;
        bh=+B2RyBYE0y86L8yJkdHeDMZTG4ZuIZ21amffRovnID0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=i8+3otj2+n6kuZyF3CxQ3ICAGTAFbCGsxjhAichRnN5quDMAf7WJMNGGpTj+mFh6W
         XnYk+qVNIWJXayNCBPdx7X0B3L/NVFf8F3OzroPT8pygwnI15nC6/pYEI6ieIS7cC6
         fQw/OEkcRdvTzAtv/fSXOnkuUyC7083HO7zFdgow=
Received: by mail-oi1-f179.google.com with SMTP id h9so1253019oih.4;
        Tue, 06 Jul 2021 16:20:24 -0700 (PDT)
X-Gm-Message-State: AOAM531CYhO4IwMRTEvjQ7SdI0hfu19EALz6XsjBcRqpOCzSwzRdByPs
        mLfT7ALRX+Ub+3WwH6j97uyGFINR7mpSt98vDHs=
X-Google-Smtp-Source: ABdhPJwvODCWG0AeXR+9oECO+x2o6a1FUtOPxOFl78LnDVCsndsRrY7L/qQ1u0pK80Ldg6T8UkI2OFAHz5YoRYK66/Y=
X-Received: by 2002:a17:90a:650b:: with SMTP id i11mr22926182pjj.39.1625613613347;
 Tue, 06 Jul 2021 16:20:13 -0700 (PDT)
MIME-Version: 1.0
References: <1625044676-12441-1-git-send-email-linyunsheng@huawei.com>
 <20210702153947.7b44acdf@linux.microsoft.com> <20210706155131.GS22278@shell.armlinux.org.uk>
In-Reply-To: <20210706155131.GS22278@shell.armlinux.org.uk>
From:   Matteo Croce <mcroce@linux.microsoft.com>
Date:   Wed, 7 Jul 2021 01:19:37 +0200
X-Gmail-Original-Message-ID: <CAFnufp1hM6WRDigAsSfM94yneRhkmxBoGG7NxRUkbfTR2WQvyA@mail.gmail.com>
Message-ID: <CAFnufp1hM6WRDigAsSfM94yneRhkmxBoGG7NxRUkbfTR2WQvyA@mail.gmail.com>
Subject: Re: [PATCH net-next RFC 0/2] add elevated refcnt support for page pool
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Yunsheng Lin <linyunsheng@huawei.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Sven Auhagen <sven.auhagen@voleatech.de>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linuxarm@openeuler.org,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
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
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 6, 2021 at 5:51 PM Russell King (Oracle)
<linux@armlinux.org.uk> wrote:
>
> On Fri, Jul 02, 2021 at 03:39:47PM +0200, Matteo Croce wrote:
> > On Wed, 30 Jun 2021 17:17:54 +0800
> > Yunsheng Lin <linyunsheng@huawei.com> wrote:
> >
> > > This patchset adds elevated refcnt support for page pool
> > > and enable skb's page frag recycling based on page pool
> > > in hns3 drvier.
> > >
> > > Yunsheng Lin (2):
> > >   page_pool: add page recycling support based on elevated refcnt
> > >   net: hns3: support skb's frag page recycling based on page pool
> > >
> > >  drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  79 +++++++-
> > >  drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |   3 +
> > >  drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |   1 +
> > >  drivers/net/ethernet/marvell/mvneta.c              |   6 +-
> > >  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |   2 +-
> > >  include/linux/mm_types.h                           |   2 +-
> > >  include/linux/skbuff.h                             |   4 +-
> > >  include/net/page_pool.h                            |  30 ++-
> > >  net/core/page_pool.c                               | 215
> > > +++++++++++++++++---- 9 files changed, 285 insertions(+), 57
> > > deletions(-)
> > >
> >
> > Interesting!
> > Unfortunately I'll not have access to my macchiatobin anytime soon, can
> > someone test the impact, if any, on mvpp2?
>
> I'll try to test. Please let me know what kind of testing you're
> looking for (I haven't been following these patches, sorry.)
>

A drop test or L2 routing will be enough.
BTW I should have the macchiatobin back on friday.

Regards,
-- 
per aspera ad upstream
