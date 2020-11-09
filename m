Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D47052ABF36
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 15:50:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730900AbgKIOua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 09:50:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730649AbgKIOu3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 09:50:29 -0500
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8230AC0613CF
        for <netdev@vger.kernel.org>; Mon,  9 Nov 2020 06:50:29 -0800 (PST)
Received: by mail-qk1-x742.google.com with SMTP id b18so8082030qkc.9
        for <netdev@vger.kernel.org>; Mon, 09 Nov 2020 06:50:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Vq5/tjWtddiE1aQy8pNnTWXRNtW83R1Nqfx7r08ajzk=;
        b=TKAqXh90YtuPDFHEuaEWAmQ5uTgLHshN3r6/LhOYNf86p938rHLxIbq3puQVQv7NvE
         kW8HOjXGE47heHD5lai0pIMTu9vKW4UXu2TEjGvXtjOvMp0EECV45dk+I1THuQ1HbvBg
         UjtI6T5YhtG0QbG6MOaUKmlyzhopJRfSGv6lOB4HTVZKWpT15S1a2UeQjQ2vV6c1gqYl
         3bab0P+8DxrDXK7kXG8QxTaw5TsJQfWbOUG/Glj2EY6cJgBhJhTq4WYfYpz49Z57SIej
         xRkwowIaBqX+cGG05Awom+M+S0n0DtAV4olhWqxCXcrE20f15jV6tcuU1Y3+TC2QMcj9
         bW7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Vq5/tjWtddiE1aQy8pNnTWXRNtW83R1Nqfx7r08ajzk=;
        b=SjrfdFWRxZhEVmyQpDSnPxVKsZ1QTj2XFkqV3zeLtG4o9OckTaLjyN5HQspJkfRZQQ
         Gg0bTvIW3jckWNnaSLMrM26r1WcL+4oTMJ+meT4rdL/JdjQZMBu5g1+n/j4R7Q+JoThB
         QxcBM3/7KBPGe/GFflOccuzTU/YzqHzE4KKvgZJBGPQAEh4BIZ0iGVE1/mcb+ajwTG1T
         Xz4TaLERRxI0HPE03Q+SCPeZt8B7cnDML0FKonk/aByHZmaF1wMoStp24arcmO7P/KlT
         4y1hmeaMAbyoY5bGmlo2d8eYTvNhteulQTwMUP1KvFbz1De7roxwLGryMTHYaXnCq/SN
         On6g==
X-Gm-Message-State: AOAM5326bvW/A6z245beYnvlKbt4yhHL53XIOYznL4OXvmI3tq+qLh+E
        6HMUjFUq0W6lRZb98ljvXUY=
X-Google-Smtp-Source: ABdhPJyaymI8zfLFKbQyjP6tN7RrasBXogKiB4Nbzcf9lY2zxB3Cpo4tm+fPQ55Ljrm4KrtgzKV3yA==
X-Received: by 2002:a37:63cb:: with SMTP id x194mr14188872qkb.257.1604933428619;
        Mon, 09 Nov 2020 06:50:28 -0800 (PST)
Received: from localhost.localdomain ([2001:1284:f013:f46e:fd51:d129:1f9d:9ebd])
        by smtp.gmail.com with ESMTPSA id d188sm6269366qkb.10.2020.11.09.06.50.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 06:50:27 -0800 (PST)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 349BBC1B7C; Mon,  9 Nov 2020 11:50:25 -0300 (-03)
Date:   Mon, 9 Nov 2020 11:50:25 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     wenxu@ucloud.cn, kuba@kernel.org, dcaratti@redhat.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH v5 net-next 3/3] net/sched: act_frag: add implict packet
 fragment support.
Message-ID: <20201109145025.GB3913@localhost.localdomain>
References: <1604791828-7431-1-git-send-email-wenxu@ucloud.cn>
 <1604791828-7431-4-git-send-email-wenxu@ucloud.cn>
 <ygnhimaewtm2.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ygnhimaewtm2.fsf@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 09, 2020 at 03:24:37PM +0200, Vlad Buslov wrote:
> On Sun 08 Nov 2020 at 01:30, wenxu@ucloud.cn wrote:
...
> > @@ -974,9 +974,22 @@ config NET_ACT_TUNNEL_KEY
> >  	  To compile this code as a module, choose M here: the
> >  	  module will be called act_tunnel_key.
> >  
> > +config NET_ACT_FRAG
> > +	tristate "Packet fragmentation"
> > +	depends on NET_CLS_ACT
> > +	help
> > +         Say Y here to allow fragmenting big packets when outputting
> > +         with the mirred action.
> > +
> > +	  If unsure, say N.
> > +
> > +	  To compile this code as a module, choose M here: the
> > +	  module will be called act_frag.
> > +
> 
> Just wondering, what is the motivation for putting the frag code into
> standalone module? It doesn't implement usual act_* interface and is not
> user-configurable. To me it looks like functionality that belongs to
> act_api. Am I missing something?

It's the way we found so far for not "polluting" mirred/tc with L3
functionality, per Cong's feedbacks on previous attempts. As for why
not act_api, this is not some code that other actions can just re-use
and that file is already quite big, so I thought act_frag would be
better to keep it isolated/contained.

If act_frag is confusing, then maybe act_mirred_frag? It is a mirred
plugin now, after all.

...
> > +int tcf_set_xmit_hook(int (*xmit_hook)(struct sk_buff *skb,
> > +				       int (*xmit)(struct sk_buff *skb)))
> > +{
> > +	if (!tcf_xmit_hook_enabled())
> > +		xchg(&tcf_xmit_hook, xmit_hook);
> 
> Marcelo, why did you suggest to use atomic operations to change
> tcf_xmit_hook variable? It is not obvious to me after reading the code.

I thought as a minimal way to not have problems on module removal, but
your comment below proves it is not right/enough. :-)

> 
> > +	else if (xmit_hook != tcf_xmit_hook)
> > +		return -EBUSY;
> > +
> > +	tcf_inc_xmit_hook();
> > +
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(tcf_set_xmit_hook);
> > +
> > +void tcf_clear_xmit_hook(void)
> > +{
> > +	tcf_dec_xmit_hook();
> > +
> > +	if (!tcf_xmit_hook_enabled())
> > +		xchg(&tcf_xmit_hook, NULL);
> > +}
> > +EXPORT_SYMBOL_GPL(tcf_clear_xmit_hook);
> > +
> > +int tcf_dev_queue_xmit(struct sk_buff *skb, int (*xmit)(struct sk_buff *skb))
> > +{
> > +	if (tcf_xmit_hook_enabled())
> 
> Okay, so what happens here if tcf_xmit_hook is disabled concurrently? If
> we get here from some rule that doesn't involve act_ct but uses
> act_mirred and act_ct is concurrently removed decrementing last
> reference to static branch and setting tcf_xmit_hook to NULL?

Yeah.. good point. Thinking further now, what about using RCU for the
hook? AFAICT it can cover the synchronization needed when clearing the
pointer, tcf_set_xmit_hook() should do a module_get() and
tcf_clear_xmit_hook() can delay a module_put(act_frag) as needed with
call_rcu.

I see tcf_mirred_act is already calling rcu_dereference_bh(), so
it's already protected by rcu read here and calling tcf_xmit_hook()
with xmit pointer should be fine. WDYT?

> 
> > +		return tcf_xmit_hook(skb, xmit);
> > +	else
> > +		return xmit(skb);
> > +}
> > +EXPORT_SYMBOL_GPL(tcf_dev_queue_xmit);
