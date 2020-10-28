Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E01629DCBF
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 01:32:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725940AbgJ2AcD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 20:32:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387804AbgJ1Waz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:30:55 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 309A0C0613CF;
        Wed, 28 Oct 2020 15:30:55 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id d3so734547wma.4;
        Wed, 28 Oct 2020 15:30:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=gSinsdGE53PZSUfpITJI0G/Gp3pGnKuptRZHm83+NWc=;
        b=hPhWjar2E1DbmCivm6BkyxqN4b1jH6FmDKwoAPyqO7O1MJjOZq8dLEgW16C9k49w/U
         +P9Epg6GL0aFChxyMUj/huH8MqStylRiEsZNa4BhJWpAnHtT0VlakjmrFrffwaMI9UvT
         GFoKBXlDrGLxDnqqTF5ALV3EZy+w8A1tNfifwED3QgsScHAetFPcUaf/mjZdKr4W/lm9
         sGcJ0lqyPqL0+P7N63phTngA9qd2ECPzrzltzEszEb6h2rk+7C/nT27rZb6VpGEr492q
         FsUqZckyW6IDk8q3zJjAknHRqBNLMbtN8Qcub92hFywnDAw9EUfTt/9OYjG366gpyIHM
         kaAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=gSinsdGE53PZSUfpITJI0G/Gp3pGnKuptRZHm83+NWc=;
        b=m6rr6n8V+38Z5kB6FOTpucsZe2PILYViCiOcvFqxJuCehHJhe2MIIHVmtm2PWPKIZW
         ece7jSD0ISVqD25Gw4Y5GS35fTCshtO+//ra25+VZNNlTQcZamYcDdXzWOK1/N+XZI1H
         yuhnhFqsvBdCT60DN0DNMj/yxON5jEv1mKqeO0xWftuN4XOJnt0DiOz2ZavVM4wK5xnq
         z8XjaXEjGMoq1/LZj0iskPisKhnq+pARSw7vS5sTTEoStO9YrXXO8dO/hIrfh5DsWNEo
         JSVjTak8nkehk3P3cuwHp5hR8QGbSceLhMryoF27x6irrJlYo82Y+5YwekQ4X8UiUgLq
         Cd8w==
X-Gm-Message-State: AOAM530R38OKVplBzOhCuTQlWX60xGBYwwPkbfsqn6vpOQyLUXX5MwGW
        UH7JHzdSS40D3N14Iv7myWKtKfRXadBfjNOc
X-Google-Smtp-Source: ABdhPJzs79OLsV5qMv3xUW93dQUTDQEI1mMHLJGWKDV9GMjJTQT019Of+rQdfnXHUsurQeFxaEdYDQ==
X-Received: by 2002:a7b:ce8f:: with SMTP id q15mr56820wmj.88.1603900255413;
        Wed, 28 Oct 2020 08:50:55 -0700 (PDT)
Received: from felia ([2001:16b8:2d7a:200:a915:6596:e9b0:4f60])
        by smtp.gmail.com with ESMTPSA id f5sm18509wmh.16.2020.10.28.08.50.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 08:50:54 -0700 (PDT)
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
X-Google-Original-From: Lukas Bulwahn <lukas@gmail.com>
Date:   Wed, 28 Oct 2020 16:50:53 +0100 (CET)
X-X-Sender: lukas@felia
To:     Tom Rix <trix@redhat.com>
cc:     Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        clang-built-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-safety@lists.elisa.tech
Subject: Re: [PATCH] net: cls_api: remove unneeded local variable in
 tc_dump_chain()
In-Reply-To: <d956a5a5-c064-3fd4-5e78-809638ba14ef@redhat.com>
Message-ID: <alpine.DEB.2.21.2010281629030.13040@felia>
References: <20201028113533.26160-1-lukas.bulwahn@gmail.com> <d956a5a5-c064-3fd4-5e78-809638ba14ef@redhat.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On Wed, 28 Oct 2020, Tom Rix wrote:

> 
> On 10/28/20 4:35 AM, Lukas Bulwahn wrote:
> > make clang-analyzer on x86_64 defconfig caught my attention with:
> >
> > net/sched/cls_api.c:2964:3: warning: Value stored to 'parent' is never read
> >   [clang-analyzer-deadcode.DeadStores]
> >                 parent = 0;
> >                 ^
> >
> > net/sched/cls_api.c:2977:4: warning: Value stored to 'parent' is never read
> >   [clang-analyzer-deadcode.DeadStores]
> >                         parent = q->handle;
> >                         ^
> >
> > Commit 32a4f5ecd738 ("net: sched: introduce chain object to uapi")
> > introduced tc_dump_chain() and this initial implementation already
> > contained these unneeded dead stores.
> >
> > Simplify the code to make clang-analyzer happy.
> >
> > As compilers will detect these unneeded assignments and optimize this
> > anyway, the resulting binary is identical before and after this change.
> >
> > No functional change. No change in object code.
> >
> > Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> > ---
> > applies cleanly on current master and next-20201028
> >
> > Jamal, Cong, Jiri, please ack.
> > David, Jakub, please pick this minor non-urgent clean-up patch.
> >
> >  net/sched/cls_api.c | 16 +++-------------
> >  1 file changed, 3 insertions(+), 13 deletions(-)
> >
> > diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> > index faeabff283a2..8ce830ca5f92 100644
> > --- a/net/sched/cls_api.c
> > +++ b/net/sched/cls_api.c
> > @@ -2940,7 +2940,6 @@ static int tc_dump_chain(struct sk_buff *skb, struct netlink_callback *cb)
> >  	struct tcf_chain *chain;
> >  	long index_start;
> >  	long index;
> > -	u32 parent;
> >  	int err;
> >  
> >  	if (nlmsg_len(cb->nlh) < sizeof(*tcm))
> > @@ -2955,13 +2954,6 @@ static int tc_dump_chain(struct sk_buff *skb, struct netlink_callback *cb)
> >  		block = tcf_block_refcnt_get(net, tcm->tcm_block_index);
> >  		if (!block)
> >  			goto out;
> > -		/* If we work with block index, q is NULL and parent value
> > -		 * will never be used in the following code. The check
> > -		 * in tcf_fill_node prevents it. However, compiler does not
> > -		 * see that far, so set parent to zero to silence the warning
> > -		 * about parent being uninitialized.
> > -		 */
> > -		parent = 0;
> >  	} else {
> >  		const struct Qdisc_class_ops *cops;
> >  		struct net_device *dev;
> > @@ -2971,13 +2963,11 @@ static int tc_dump_chain(struct sk_buff *skb, struct netlink_callback *cb)
> >  		if (!dev)
> >  			return skb->len;
> >  
> > -		parent = tcm->tcm_parent;
> > -		if (!parent) {
> > +		if (!tcm->tcm_parent)
> >  			q = dev->qdisc;
> > -			parent = q->handle;
> 
> This looks like a an unused error handler.
> 
> and the later call to
> 
> if (TC_H_MIN(tcm->tcm_parent)
> 
> maybe should be
> 
> if (TC_H_MIN(parent))
> 
> so I am skeptical that this change is ok because the code around it looks buggy.
>

Maybe that is the case.

Certainly the comment above about being uninitialized is outdated as 
parent is not used in tc_chain_fill_node().

I had another look and I noticed a copy of this same pattern (with the 
same comment) in tc_dump_tfilter(), but it seems that the two copies have 
somehow diverged over time. Certainly, something is fishy here.

I guess it needs some more digging in the code...

Lukas

> Tom
> 
> > -		} else {
> > +		else
> >  			q = qdisc_lookup(dev, TC_H_MAJ(tcm->tcm_parent));
> > -		}
> > +
> >  		if (!q)
> >  			goto out;
> >  		cops = q->ops->cl_ops;
> 
> 
