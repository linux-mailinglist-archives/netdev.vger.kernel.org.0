Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D375A118BDE
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 16:02:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727480AbfLJPCt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 10:02:49 -0500
Received: from mail-wr1-f45.google.com ([209.85.221.45]:36571 "EHLO
        mail-wr1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727272AbfLJPCt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 10:02:49 -0500
Received: by mail-wr1-f45.google.com with SMTP id z3so20504562wru.3
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 07:02:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Embng0ehlRpQgOyJThRi0bZwmGHoUksbsKrG3YADG6A=;
        b=cU/+JuW/cuQrhE5d/oYvJhPeFCPc9ZPO8Vqj9JukmckYaSHyNbt75aY2iZu21JzsUc
         0XJ0vDud2OcJ34NXEGVLwiGF5pxRM2lqECDltTAjAvZ8XG6rlNhkNQCfnRhJo4jZNeeC
         8drYWlFypy3iGYbzCrJgUhP+a4vHgp+GbD0uEcpH+DO2yV9Kq3aZ6jt6wJICz3R3/Fjx
         wD+LIm3InTPAWayqYEQA5MC8DazFYreblx8iHmMP5OuhbK5VPIddTNP60OwLZKKhKujj
         tLlQeoKzn1nVTzzAlS6jCrLzcNEJ6poRdn900fhyCBsxLKqGyEUpoL00RWBcQGTSDVPz
         Yg1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Embng0ehlRpQgOyJThRi0bZwmGHoUksbsKrG3YADG6A=;
        b=eJLPW6drVj3GnRlijmthAmNO1+cfRuT7UYIA5GS1kiTvR7cuP1Auh8pQBFCZNJnyoi
         3ehdJ3jGxyX8jJL0BQYf16dVWyYyDbcEMqTLW1oGlkXhVsQo+DpdGgq1Wi2smG/AXVdk
         OxlM2lLCJWNj58dZlaeAa4ZaAVfUAV8ilxzcAXuNAnTkQmV4xPvmjBNmUyelBU10DUN0
         Jl5YDy4ItMmNxf6dp5pxMK+fRSHu4/lPsniZKR3xqzWPWAZq8XVkmivapvx0HCW6CxGG
         qdhRfRm21ngFKVw4Efz0gDlEjRGVwFgHcQWqdx2U0iOgo4b/GOEr7IlYbnTdScG6KAon
         SqlQ==
X-Gm-Message-State: APjAAAUN1m61y0Dac6g1QLw+OAD6Bni5xcsjKm8fIvLPSeHE4bsHYX82
        p23EAy+v9ZuTPBo8Ym59jROx8g==
X-Google-Smtp-Source: APXvYqwMRGc+RuedEuanSRBG88G1cmns8VDxHtvOcauyevfu5rZf0gMJclU01VqUKVUEd67rbadChQ==
X-Received: by 2002:adf:f091:: with SMTP id n17mr3846791wro.387.1575990166946;
        Tue, 10 Dec 2019 07:02:46 -0800 (PST)
Received: from apalos.home (athedsl-4476713.home.otenet.gr. [94.71.27.49])
        by smtp.gmail.com with ESMTPSA id d8sm3489005wrx.71.2019.12.10.07.02.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 07:02:46 -0800 (PST)
Date:   Tue, 10 Dec 2019 17:02:44 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "brouer@redhat.com" <brouer@redhat.com>,
        "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>,
        "linyunsheng@huawei.com" <linyunsheng@huawei.com>,
        Li Rongqing <lirongqing@baidu.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH][v2] page_pool: handle page recycle for NUMA_NO_NODE
 condition
Message-ID: <20191210150244.GB12702@apalos.home>
References: <1575624767-3343-1-git-send-email-lirongqing@baidu.com>
 <9fecbff3518d311ec7c3aee9ae0315a73682a4af.camel@mellanox.com>
 <20191209131416.238d4ae4@carbon>
 <816bc34a7d25881f35e0c3e21dc2283ffeffb093.camel@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <816bc34a7d25881f35e0c3e21dc2283ffeffb093.camel@mellanox.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Saeed,

> > 
> > The patch description doesn't explain the problem very well.
> > 
> > Lets first establish what the problem is.  After I took at closer
> > look,
> > I do think we have a real problem here...
> > 
> > If function alloc_pages_node() is called with NUMA_NO_NODE (see below
> > signature), then the nid is re-assigned to numa_mem_id().
> > 
> > Our current code checks: page_to_nid(page) == pool->p.nid which seems
> > bogus, as pool->p.nid=NUMA_NO_NODE and the page NID will not return
> > NUMA_NO_NODE... as it was set to the local detect numa node, right?
> > 
> 
> right.
> 
> > So, we do need a fix... but the question is that semantics do we
> > want?
> > 
> 
> maybe assume that __page_pool_recycle_direct() is always called from
> the right node and change the current bogus check:

Is this a typo? pool_page_reusable() is called from __page_pool_put_page().

page_pool_put_page and page_pool_recycle_direct() (no underscores) call that.
Can we guarantee that those will always run from the correct cpu?
In the current code base if they are only called under NAPI this might be true.
On the page_pool skb recycling patches though (yes we'll eventually send those
:)) this is called from kfree_skb().
I don't think we can get such a guarantee there, right?

Regards
/Ilias
