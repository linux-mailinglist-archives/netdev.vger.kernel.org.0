Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E93FF31E624
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 07:11:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231360AbhBRFzc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 00:55:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231384AbhBRFvz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Feb 2021 00:51:55 -0500
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B87D2C061786;
        Wed, 17 Feb 2021 21:51:14 -0800 (PST)
Received: by mail-il1-x12b.google.com with SMTP id e2so524070ilu.0;
        Wed, 17 Feb 2021 21:51:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=1MiXI1ghzyDJbbFlIYODMYli9/N2JgiwurFchZ9firo=;
        b=dEBmN7prep6VSAQphqNi5WtJV6Fv9Y0sSG8g+DH+WqFF3soIzqH/sc3anKxEM7hqgF
         oybeCMKfrDFUCehJlWR731HqDZ+AaoF+GSgKRLMvbFjc3ILgnrh9SIqNnEt/gYIck31K
         2ymaCUdFyNORx5Dfw3Xub+LTH9JMqzRlRKoQ+bsOjC90fWtvmB9TdWKVnIDvq/vMIpdZ
         lFtOEJNbyVZj2W6Mr747dHg3aIR+qgKtEly+VdDTZ2DXFJC+fZk0Et5K6UjQMt7VLrV5
         ti7l3VZGFz4Ddwhc3nEyp4yhuBRhQyv+akSh3+KVViFaTs6FtF0QhmZ6xNePtHPnRgPZ
         uyJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=1MiXI1ghzyDJbbFlIYODMYli9/N2JgiwurFchZ9firo=;
        b=eOEf7/cpnpGD+pO3TgYw31zJX0F5Aa0cOVHdLT/XXoeJF5S/ZRzrkENUDrKbI4CJvg
         mj/e1oXr9TS8Jdiul2hsM+s9Lr5a8mXqayzhaZTDhaLKzUMBDBa5S5+XxnM8dUziW89L
         1oD9IetLU4WnEjzZ3P2BW3TWn6v9vKqWOWuAOLnRhHfV4ZMbaWIDpNGg12tp3NIE32su
         tzNFWoGxPzsEnUSnV5HYW9i3k9L1niqOxIMoPUqXHrBVJGcF2NIwNgoXYVeAOSyqOcAi
         HLiBOH1/mGOerqSuAjuGsIoAixwt2XQePsQXXuvk3WcnEOp6L0zIJeVK0F/sc5+47i+B
         t0kQ==
X-Gm-Message-State: AOAM5325gGxDzV9ExCvGmB2IcoZKtZ9AjY9GJe9YnVjlGPqaCvsm/l+f
        RHg2peX47UOZV332Jd8z3FA=
X-Google-Smtp-Source: ABdhPJwf4UBkV7ifcird11DTwA51LcyMnqHR7AdEo+L5paqAu0t48ISl/VVRDyTLTn24RA1B9tvqGw==
X-Received: by 2002:a05:6e02:1a25:: with SMTP id g5mr2470754ile.73.1613627474096;
        Wed, 17 Feb 2021 21:51:14 -0800 (PST)
Received: from localhost ([172.243.146.206])
        by smtp.gmail.com with ESMTPSA id e195sm3795840iof.51.2021.02.17.21.51.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Feb 2021 21:51:13 -0800 (PST)
Date:   Wed, 17 Feb 2021 21:51:07 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Dust Li <dust.li@linux.alibaba.com>,
        Alexander Lobakin <alobakin@pm.me>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        Alexander Lobakin <alobakin@pm.me>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Magnus Karlsson <magnus.karlsson@intel.com>
Message-ID: <602e004b4286_1e7da2082a@john-XPS-13-9370.notmuch>
In-Reply-To: <1613615475.9629707-1-xuanzhuo@linux.alibaba.com>
References: <602db8cc18aaf_fc5420827@john-XPS-13-9370.notmuch>
 <1613615475.9629707-1-xuanzhuo@linux.alibaba.com>
Subject: Re: RE: [PATCH v7 bpf-next 6/6] xsk: build skb by page (aka generic
 zerocopy xmit)
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Xuan Zhuo wrote:
> On Wed, 17 Feb 2021 16:46:04 -0800, John Fastabend <john.fastabend@gmail.com> wrote:
> > Alexander Lobakin wrote:
> > > From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > >
> > > This patch is used to construct skb based on page to save memory copy
> > > overhead.
> > >
> > > This function is implemented based on IFF_TX_SKB_NO_LINEAR. Only the
> > > network card priv_flags supports IFF_TX_SKB_NO_LINEAR will use page to
> > > directly construct skb. If this feature is not supported, it is still
> > > necessary to copy data to construct skb.
> > >
> > > ---------------- Performance Testing ------------
> > >
> > > The test environment is Aliyun ECS server.
> > > Test cmd:
> > > ```
> > > xdpsock -i eth0 -t  -S -s <msg size>
> > > ```
> > >
> > > Test result data:
> > >
> > > size    64      512     1024    1500
> > > copy    1916747 1775988 1600203 1440054
> > > page    1974058 1953655 1945463 1904478
> > > percent 3.0%    10.0%   21.58%  32.3%
> > >
> > > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > > Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
> > > [ alobakin:
> > >  - expand subject to make it clearer;
> > >  - improve skb->truesize calculation;
> > >  - reserve some headroom in skb for drivers;
> > >  - tailroom is not needed as skb is non-linear ]
> > > Signed-off-by: Alexander Lobakin <alobakin@pm.me>
> > > Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
> > > ---
> >
> > [...]
> >
> > > +	buffer = xsk_buff_raw_get_data(pool, addr);
> > > +	offset = offset_in_page(buffer);
> > > +	addr = buffer - pool->addrs;
> > > +
> > > +	for (copied = 0, i = 0; copied < len; i++) {
> > > +		page = pool->umem->pgs[addr >> PAGE_SHIFT];
> >
> > Looks like we could walk off the end of pgs[] if len is larger than
> > the number of pgs? Do we need to guard against a misconfigured socket
> > causing a panic here? AFAIU len here is read from the user space
> > descriptor so is under user control. Or maybe I missed a check somewhere.
> >
> > Thanks,
> > John
> >
> 
> Don't worry about this, the legality of desc has been checked.
> 
> xskq_cons_peek_desc -> xskq_cons_read_desc ->
>                    xskq_cons_is_valid_desc -> xp_validate_desc

Ah OK I didn't dig past the cons_read_desc(). In that case LGTM.

Acked-by: John Fastabend <john.fastabend@gmail.com>
