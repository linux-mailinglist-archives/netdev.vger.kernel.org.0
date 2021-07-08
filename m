Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D35663C1647
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 17:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232024AbhGHPud (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 11:50:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbhGHPub (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 11:50:31 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02ACAC061574
        for <netdev@vger.kernel.org>; Thu,  8 Jul 2021 08:47:49 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id p8so8141805wrr.1
        for <netdev@vger.kernel.org>; Thu, 08 Jul 2021 08:47:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WJZpdcS1MW7Mj0T2TQvKXriF3MrXgDJAl+1qoxtsXRg=;
        b=mHfMB0eAj0cSxvZ60HKwN3+EhKCHtLHT+8luhQ4eY8fRDYpK9CaMIv1ifSd1fYpdy/
         XS6M0+kAJNKbfnba459XmxOqX4Y7EN6z71Q9go4+f1zU5We4FEgis8U+Vn/Ct+RSOPqb
         fkzW7m9HokblG4zTQoDzp8XQoge2BZKTB9UjRlvCtT2BZs2BybA9GaFYRRr2ipw3Vxs8
         thuRsKHak4/x7lfKkC/+0gaSfKTOOT6/RIo/cZXRLmUmKihtR9SFdGJL8N+I2ObgBUO1
         O+qr9cpRMZ0Fx53Le7z3jODSLuCCWE5QhAmp0c4j7kK37z4Axp1aQ2p3pXft/mLpryc7
         bc4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WJZpdcS1MW7Mj0T2TQvKXriF3MrXgDJAl+1qoxtsXRg=;
        b=QOEFxAKL/mOu79xbFEW9RhCXNamSiCT7xcZRp3bWeK9R9tW37hnkbZzNLGsT/2pDBt
         Z9HtpgL701hb4mEBhnlGx7+9Now/GiIoRFksNgIebPMPR1XXb889IGos7GrkDk09VqQO
         BxBiEdDHEREjZgcI3lqyEdNR7RgMrI5g16brJ7d+YmdynE+CNY/lcdvCSyWuhIsr4xcL
         azpb4HezuYrlq49SkYc7se2Kcm/0DVgJrRL8j9QVZxu96gJx7lWh5oH6ctyt63FSl0cI
         frycvn44a02rvdW1C9ZTUzRwE5EDfiBZMEjRkq8M7TNhV2L4Y0sYdrNBbqlxUpd4SL/e
         RmrA==
X-Gm-Message-State: AOAM530hEcun+8N2sGaB/3YCGbd4a2qbssMwdjK3gW74XpSXI/jCtUFq
        jvUpxHJVK/u2/yTbtTLmUNhEAA==
X-Google-Smtp-Source: ABdhPJyDE9/Btnk3TzRVAgkbEJA7gXb+0SPCg1ltU0i0gw0XPQQtP0VO3H33i/Yx5mdMOloXMWS1dg==
X-Received: by 2002:a5d:47a7:: with SMTP id 7mr3990891wrb.150.1625759267621;
        Thu, 08 Jul 2021 08:47:47 -0700 (PDT)
Received: from enceladus (ppp-94-66-242-227.home.otenet.gr. [94.66.242.227])
        by smtp.gmail.com with ESMTPSA id x1sm9535888wmc.0.2021.07.08.08.47.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jul 2021 08:47:47 -0700 (PDT)
Date:   Thu, 8 Jul 2021 18:47:43 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Yunsheng Lin <linyunsheng@huawei.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linuxarm@openeuler.org,
        yisen.zhuang@huawei.com, Salil Mehta <salil.mehta@huawei.com>,
        thomas.petazzoni@bootlin.com, Marcin Wojtas <mw@semihalf.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        hawk@kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>, fenghua.yu@intel.com,
        guro@fb.com, peterx@redhat.com, Feng Tang <feng.tang@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, mcroce@microsoft.com,
        Hugh Dickins <hughd@google.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Willem de Bruijn <willemb@google.com>, wenxu@ucloud.cn,
        cong.wang@bytedance.com, Kevin Hao <haokexin@gmail.com>,
        nogikh@google.com, Marco Elver <elver@google.com>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH net-next RFC 1/2] page_pool: add page recycling support
 based on elevated refcnt
Message-ID: <YOceH0VLXVl6QJEI@enceladus>
References: <CAKgT0UcGDYcuZRXX1MaFAzzBySu3R4_TSdC6S0cyS7Ppt_dNng@mail.gmail.com>
 <YOX6bPEL0cq8CgPG@enceladus>
 <CAKgT0UfPFbAptXMJ4BQyeAadaxyHfkKRfeiwhrVMwafNEM_0cw@mail.gmail.com>
 <YOcKASZ9Bp0/cz1d@enceladus>
 <CAKgT0UfJuvdkccr=SXWNUaGx7y5nUHFL-E9g3qi4sagY_jWUUQ@mail.gmail.com>
 <YOcQyKt6i+UeMzSS@enceladus>
 <YOcXDISpR7Cf+eZG@enceladus>
 <CAKgT0UcoLE=MhG+QxS=up5BH_cK5FBSwyMHDvfUg2g8083UM+w@mail.gmail.com>
 <YOcbgEKqq/cRBxX9@enceladus>
 <CAKgT0Ucnd4Oia8xy2D65O04901+Rh6cepX-d2vK1+0_Of2NwoA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgT0Ucnd4Oia8xy2D65O04901+Rh6cepX-d2vK1+0_Of2NwoA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 08, 2021 at 08:41:08AM -0700, Alexander Duyck wrote:
> On Thu, Jul 8, 2021 at 8:36 AM Ilias Apalodimas
> <ilias.apalodimas@linaro.org> wrote:
> >
> > On Thu, Jul 08, 2021 at 08:29:56AM -0700, Alexander Duyck wrote:
> > > On Thu, Jul 8, 2021 at 8:17 AM Ilias Apalodimas
> > > <ilias.apalodimas@linaro.org> wrote:
> 
> <snip>
> 
> > > > What do you think about resetting pp_recycle bit on pskb_expand_head()?
> > >
> > > I assume you mean specifically in the cloned case?
> > >
> >
> > Yes. Even if we do it unconditionally we'll just loose non-cloned buffers from
> > the recycling.
> > I'll send a patch later today.
> 
> If you do it unconditionally you could leak DMA mappings since in the
> non-cloned case we don't bother with releasing the shared info since
> we just did a memcpy of it without the reference count tweaks. We have
> to be really careful here. The idea is that we have to make exactly
> one call to the __page_pool_put_page function for this page.
> 
> > > > If my memory serves me right Eric wanted that from the beginning. Then the
> > > > cloned/expanded SKB won't trigger the recycling.  If that skb hits the free
> > > > path first, we'll end up recycling the fragments eventually.  If the
> > > > original one goes first, we'll just unmap the page(s) and freeing the cloned
> > > > one will free all the remaining buffers.
> > >
> > > I *think* that should be fine. Effectively what we are doing is making
> > > it so that if the original skb is freed first the pages are released,
> > > and if it is released after the clone/expended skb then it can be
> > > recycled.
> >
> > Exactly
> >
> > >
> > > The issue is we have to maintain it so that there will be exactly one
> > > caller of the recycling function for the pages. So any spot where we
> > > are updating skb->head we will have to see if there is a clone and if
> > > so we have to clear the pp_recycle flag on our skb so that it doesn't
> > > try to recycle the page frags as well.
> >
> > Correct. I'll keep looking around in case there's something less fragile we
> > can do
> 
> That is the risk to this kind of thing. We have to make the call once
> and only once and if we either miss it or call it too many times we
> can introduce some serious issues.

And I fully agree. Let me fix the obvious one now and I'll have a closer
look on the recycling function it self. I can probably pick up the
"changed head"/expanded SKB in the generic recycling code and refuse to recycle
these packets. Then we'll just accept the fact that if those kind of
packets are freed last, we won't recycle.

Thanks, that was a very nice catch
/Ilias
> 
> Thanks.
> 
> - Alex
