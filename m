Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7038D3532DA
	for <lists+netdev@lfdr.de>; Sat,  3 Apr 2021 08:45:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236134AbhDCGpj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Apr 2021 02:45:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232140AbhDCGpi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Apr 2021 02:45:38 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6DD1C0613E6;
        Fri,  2 Apr 2021 23:45:35 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id o10so10225066lfb.9;
        Fri, 02 Apr 2021 23:45:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GEfGTCfkrKkYIhxPCGweey7DAMBSosPp3/p3EwEGYSc=;
        b=lMCJZh9L6wGuFPrk+qTLj4Hhv71c02PMNf//MMFlKrWDjBQAjXmz/Lb9SXmDiTzhSQ
         ryTN8+yMhECtjDZyuPfwptbktIfhv/zpqsuyYpqDSg4cIhLEVcnbCzY7utz1ro6KueZg
         XceLoK/pWb/45iOeBWqNfyu8iAc6yy6uyPvqtoIIRkfizw/bTVp2HlJnngSdblI8o1Jc
         GLgPfKbEKo0i+htLNY7LyS0yTn2YA2rr0CHDh/Wwsd7dGPpGhlek3iYh5uLAksbRIS9W
         vKupoS/g0QnXvRUnW0KJ9Upm7/tHctx++y/Z1CasLFgHPktZ20a6+nNGRlHohJr2oS/A
         Q4eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GEfGTCfkrKkYIhxPCGweey7DAMBSosPp3/p3EwEGYSc=;
        b=r4Rp8JzwJoEgdu99mfdV9CJsZM247SoACvzhPqMeXIvBJQUS37M+0ZjSSKrlrl2nOI
         9/CwZ8P+BkAEPUUyQe5ruGmvddwRLVR/EAm8f396DhlXJB0axv+52Rf2SVG3U5RKN5Ej
         yVsGvWQ5J7w3wn2aknJKR243trjhXtF6ithIIRlNSvXY1mLo8BD2Stp4OEelPQBwKjCt
         lYLcvOSDUHdVYV1aDZBadAG4C3LCll2e6qo5auuDhWqGXMMs3G3Gz3XzNR0uvi6B3CmH
         HMru5WFybmoRYS/+ckXOZ2byFRqu/LfPJOnDu+tnnyqrO8cmbQFObK7oLKWtsGpphSuA
         N3DQ==
X-Gm-Message-State: AOAM533jwzIJRbAQnZrhyWX4+uokvq2aO1dHfK9ojiE//aDOhhCRKVOa
        zPwdskai+44m7rKKXASiNDfpvBA1nGyLXI4ipCBsm56f
X-Google-Smtp-Source: ABdhPJx7O685/ty6GJOb4vOjJH9mvn+0Q8Jecm+iYguMTJBy+Vxj03W3ZpjlM7jZ6yrpf55ybYS6+e1mdrllIQHblaE=
X-Received: by 2002:a19:ed06:: with SMTP id y6mr11382704lfy.539.1617432334144;
 Fri, 02 Apr 2021 23:45:34 -0700 (PDT)
MIME-Version: 1.0
References: <20210331023237.41094-1-xiyou.wangcong@gmail.com>
 <20210331023237.41094-12-xiyou.wangcong@gmail.com> <6065619aa26d1_938bb2085e@john-XPS-13-9370.notmuch>
 <CAM_iQpVG3Sd=jA4jdt6HFRr8rKn7DRdWRyHBd9O3q0DuubMsRg@mail.gmail.com>
In-Reply-To: <CAM_iQpVG3Sd=jA4jdt6HFRr8rKn7DRdWRyHBd9O3q0DuubMsRg@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 2 Apr 2021 23:45:22 -0700
Message-ID: <CAADnVQ+F3GBo_tpbBkB0C2h12VXpzBT4dr2LekxB3NXeWnU=Tg@mail.gmail.com>
Subject: Re: [Patch bpf-next v8 11/16] udp: implement ->read_sock() for sockmap
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, duanxiongchun@bytedance.com,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 2, 2021 at 10:12 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Wed, Mar 31, 2021 at 11:01 PM John Fastabend
> <john.fastabend@gmail.com> wrote:
> > This 'else if' is always true if above is false right? Would be
> > impler and clearer IMO as,
> >
> >                if (used <= 0) {
> >                         if (!copied)
> >                                 copied = used;
> >                         break;
> >                }
> >                copied += used;
> >
> > I don't see anyway for used to be great than  skb->len.
>
> Yes, slightly better. Please feel free to submit a patch by yourself,
> like always your patches are welcome.

Please submit a follow up patch as John requested
or I'm reverting your set.
