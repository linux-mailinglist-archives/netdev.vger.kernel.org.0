Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F5C93BEFFD
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 21:03:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230484AbhGGTF6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 15:05:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230432AbhGGTFz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 15:05:55 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37339C061574
        for <netdev@vger.kernel.org>; Wed,  7 Jul 2021 12:03:14 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id p8so4303378wrr.1
        for <netdev@vger.kernel.org>; Wed, 07 Jul 2021 12:03:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gEyVsUHVabbCcurt1vqr+nKmr7tjD0Zle1ugJOsxNk8=;
        b=uQahgciwZnRHDS26dth70zA8+WBNEzYXuwzc5GVRJBSrJhp07jCDpwzSWiUiptb2xj
         7cdrZCMoJaRDHDN5jl+6M3lZynZVuiOBQkMz4ZFxna6AQ2fmmt3NoX2BtkPno285C5Qw
         02Rsz/SXQFpkQsz5wvsk6J2s8UlXFa3qb6dsebpiSGYpSXMfyI0NScRUnMx3wA5+3Wlc
         CP9d3VQn8Zie43uo08Vg+N4sjAXt4UjVIUwqUSt0L6kfkiHBqSF9XtEn/ueEmIsCh9Xi
         8XFnLAamPMICjrEtTWKoHF0iJRdn1t7BJmVvRBDpJW01CQqYM8C6/WMnpEUZ+9E3RpOY
         fBYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gEyVsUHVabbCcurt1vqr+nKmr7tjD0Zle1ugJOsxNk8=;
        b=TJrOYcuVC59XaDdL4rn+yUo7KL01pKiLLM0Bxq57qM32JRXVSv6/mnAn8+VoXblXf3
         INSyeuzHdvE4mgJUD8pmm1MzQNqibZmxn/+HZMFEqoE6DhZGFY/Hl2GJAZScSUcSzJ6z
         snluICl3LUEogw6ncBAN4HtzJAGmAUcSgoQD4fNsBkwvmVGpzecsc7HpxjEKNTf1w2Za
         ZERLNKajsKulybxxpwKJ1soTpzsm3W/BA82sLX+2adn+vxVaYy28HI6lw3ViXrcewPAw
         PVIy6EM+82qx+6T18+uSFTrFHseDvxI+MznYqnTpNuZ9tsuSIy0xibCXaCC5+vpnUsx9
         +Z7w==
X-Gm-Message-State: AOAM532qojFL5wVZQktY6qsV8b1J3MRla3aEwx1YarDu64ekxupO3rYW
        B6cnUtIrc1ZA00AixVw1AnHI4Q==
X-Google-Smtp-Source: ABdhPJySfCSiQ5cTbbS6d9OTSSfjP3HkNHiqbjLKAzqbl35lVyffDcd81DxCDMSy6xGV26L8R9f8Pg==
X-Received: by 2002:a5d:61d1:: with SMTP id q17mr30439214wrv.162.1625684592806;
        Wed, 07 Jul 2021 12:03:12 -0700 (PDT)
Received: from enceladus (ppp-94-66-242-227.home.otenet.gr. [94.66.242.227])
        by smtp.gmail.com with ESMTPSA id c12sm23742825wrr.90.2021.07.07.12.03.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 12:03:12 -0700 (PDT)
Date:   Wed, 7 Jul 2021 22:03:08 +0300
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
Message-ID: <YOX6bPEL0cq8CgPG@enceladus>
References: <1625044676-12441-1-git-send-email-linyunsheng@huawei.com>
 <1625044676-12441-2-git-send-email-linyunsheng@huawei.com>
 <CAKgT0Ueyc8BqjkdTVC_c-Upn-ghNeahYQrWJtQSqxoqN7VvMWA@mail.gmail.com>
 <29403911-bc26-dd86-83b8-da3c1784d087@huawei.com>
 <CAKgT0UcGDYcuZRXX1MaFAzzBySu3R4_TSdC6S0cyS7Ppt_dNng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgT0UcGDYcuZRXX1MaFAzzBySu3R4_TSdC6S0cyS7Ppt_dNng@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Hi, Alexander
> >
> > Thanks for detailed reviewing.
> >

Likewise!
I'll have a look on the entire conversation in a few days...

> > >
> > > So this isn't going to work with the current recycling logic. The
> > > expectation there is that we can safely unmap the entire page as soon
> > > as the reference count is greater than 1.
> >
> > Yes, the expectation is changed to we can always recycle the page
> > when the last user has dropped the refcnt that has given to it when
> > the page is not pfmemalloced.
> >
> > The above expectation is based on that the last user will always
> > call page_pool_put_full_page() in order to do the recycling or do
> > the resource cleanup(dma unmaping..etc).
> >
> > As the skb_free_head() and skb_release_data() have both checked the
> > skb->pp_recycle to call the page_pool_put_full_page() if needed, I
> > think we are safe for most case, the one case I am not so sure above
> > is the rx zero copy, which seems to also bump up the refcnt before
> > mapping the page to user space, we might need to ensure rx zero copy
> > is not the last user of the page or if it is the last user, make sure
> > it calls page_pool_put_full_page() too.
> 
> Yes, but the skb->pp_recycle value is per skb, not per page. So my
> concern is that carrying around that value can be problematic as there
> are a number of possible cases where the pages might be
> unintentionally recycled. All it would take is for a packet to get
> cloned a few times and then somebody starts using pskb_expand_head and
> you would have multiple cases, possibly simultaneously, of entities
> trying to free the page. I just worry it opens us up to a number of
> possible races.

Maybe I missde something, but I thought the cloned SKBs would never trigger
the recycling path, since they are protected by the atomic dataref check in
skb_release_data(). What am I missing?

[...]

Thanks
/Ilias
