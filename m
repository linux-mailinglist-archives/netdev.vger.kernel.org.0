Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0E55129295
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 08:57:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726096AbfLWH5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 02:57:07 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38432 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725867AbfLWH5H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 02:57:07 -0500
Received: by mail-wr1-f67.google.com with SMTP id y17so15679520wrh.5
        for <netdev@vger.kernel.org>; Sun, 22 Dec 2019 23:57:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bg1/C0FBfpsYbVCcdELzCzuxgeOHpBsqUdC0p4SEaVk=;
        b=rsxcB/XKNw9eEz59/fORjQWKH9LfBX00gfcmc+31qAsubCgk/Zcbq556JMbSI7PRA2
         tG8h3x6mwmc0emwjejjW5CFAHt/DuKlzKGJNCZzFXoqza4E8Nird6s2mS+Focy0RPMKv
         JdbS+up3knCZs7OE29Mdjb+jkFb4pxtJgiqsZf4rfGTij8fDs+uBa2s/GCZqtOpnBT8S
         Ow4TEf5NUG0s9asJK+0apDV9/F8kHDoHQC7AW9jT4K3h3rswf+JQ0wjwdpozeK719hCO
         HWAZqquv+7PLPArLI5FopXarq9ce+xbnyorb5uvjfJPUeeJjmc9f8Gs7egIitiK/PkE+
         /jQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bg1/C0FBfpsYbVCcdELzCzuxgeOHpBsqUdC0p4SEaVk=;
        b=netc7gYRMoUZ3+6hSplelPKY/pTHw9jEwzIidw5Ev0OJQo6SSLEFiNqUrA5DuBOMNR
         Cg9AZ55cFjFq8rO/YonkHKfkDceR6qqRdIH5kwIgiANPiyPvmo9TpaUi5DyuiJ1eAdMk
         JDUgHQ+QUcXUt1+92VBEbds6l0P/Eh8kLaU5CSQDuGKPkJGSomO9eN7qeuBOo56v8reG
         61zp+WLIlCGbhCMHVa06YcYb7bHfk2MZKcQ2aycBlnNQbNan7VIJIsBQihmg6hozjeNy
         WGCFPbc+daHHCRmmuXCXKJ9Hm2lBFFG1lLQtvYYiho5/ZAIYrXp09mY2MHyWCtnf5EY8
         IGWQ==
X-Gm-Message-State: APjAAAUNozNWcMTo7GfVY3iHuHEbtYwuCGBvYwoqHv24red6IK1/A2xF
        guWQYBF6PHHg+mEiexDhDF8s6Q==
X-Google-Smtp-Source: APXvYqyySskoNLAqHlSO1XfNJQH8tD3pMr2iAriZoxqLR/VIZdi1THAAnYb0t8eZZLdYP8C5BhVXTQ==
X-Received: by 2002:a5d:608a:: with SMTP id w10mr26851102wrt.136.1577087824205;
        Sun, 22 Dec 2019 23:57:04 -0800 (PST)
Received: from apalos.home (ppp-94-64-118-170.home.otenet.gr. [94.64.118.170])
        by smtp.gmail.com with ESMTPSA id o4sm19108803wrx.25.2019.12.22.23.57.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Dec 2019 23:57:03 -0800 (PST)
Date:   Mon, 23 Dec 2019 09:57:00 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org, lirongqing@baidu.com,
        linyunsheng@huawei.com, Saeed Mahameed <saeedm@mellanox.com>,
        mhocko@kernel.org, peterz@infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next v5 PATCH] page_pool: handle page recycle for
 NUMA_NO_NODE condition
Message-ID: <20191223075700.GA5333@apalos.home>
References: <20191218084437.6db92d32@carbon>
 <157676523108.200893.4571988797174399927.stgit@firesoul>
 <20191220102314.GB14269@apalos.home>
 <20191220114116.59d86ff6@carbon>
 <20191220104937.GA15487@apalos.home>
 <20191220162254.0138263e@carbon>
 <20191220160649.GA26788@apalos.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191220160649.GA26788@apalos.home>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jesper,

Looking at the overall path again, i still need we need to reconsider 
pool->p.nid semantics.

As i said i like the patch and the whole functionality and code seems fine,
but here's the current situation.
If a user sets pool->p.nid == NUMA_NO_NODE and wants to use
page_pool_update_nid() the whole behavior feels a liitle odd.
page_pool_update_nid() first check will always be true since .nid =
NUMA_NO_NODE). Then we'll update this to a real nid. So we end up overwriting
what the user initially coded in. 
This is close to what i proposed in the previous mails on this thread. Always
store a real nid even if the user explicitly requests NUMA_NO_NODE.

So  semantics is still a problem. I'll stick to what we initially suggested.
1. We either *always* store a real nid
or 
2. If NUMA_NO_NODE is present ignore every other check and recycle the memory
blindly. 

Regards
/Ilias

On Fri, Dec 20, 2019 at 06:06:49PM +0200, Ilias Apalodimas wrote:
> On Fri, Dec 20, 2019 at 04:22:54PM +0100, Jesper Dangaard Brouer wrote:
> > On Fri, 20 Dec 2019 12:49:37 +0200
> > Ilias Apalodimas <ilias.apalodimas@linaro.org> wrote:
> > 
> > > On Fri, Dec 20, 2019 at 11:41:16AM +0100, Jesper Dangaard Brouer wrote:
> > > > On Fri, 20 Dec 2019 12:23:14 +0200
> > > > Ilias Apalodimas <ilias.apalodimas@linaro.org> wrote:
> > > >   
> > > > > Hi Jesper, 
> > > > > 
> > > > > I like the overall approach since this moves the check out of  the hotpath. 
> > > > > @Saeed, since i got no hardware to test this on, would it be possible to check
> > > > > that it still works fine for mlx5?
> > > > > 
> > > > > [...]  
> > > > > > +	struct ptr_ring *r = &pool->ring;
> > > > > > +	struct page *page;
> > > > > > +	int pref_nid; /* preferred NUMA node */
> > > > > > +
> > > > > > +	/* Quicker fallback, avoid locks when ring is empty */
> > > > > > +	if (__ptr_ring_empty(r))
> > > > > > +		return NULL;
> > > > > > +
> > > > > > +	/* Softirq guarantee CPU and thus NUMA node is stable. This,
> > > > > > +	 * assumes CPU refilling driver RX-ring will also run RX-NAPI.
> > > > > > +	 */
> > > > > > +	pref_nid = (pool->p.nid == NUMA_NO_NODE) ? numa_mem_id() : pool->p.nid;    
> > > > > 
> > > > > One of the use cases for this is that during the allocation we are not
> > > > > guaranteed to pick up the correct NUMA node. 
> > > > > This will get automatically fixed once the driver starts recycling packets. 
> > > > > 
> > > > > I don't feel strongly about this, since i don't usually like hiding value
> > > > > changes from the user but, would it make sense to move this into 
> > > > > __page_pool_alloc_pages_slow() and change the pool->p.nid?
> > > > > 
> > > > > Since alloc_pages_node() will replace NUMA_NO_NODE with numa_mem_id()
> > > > > regardless, why not store the actual node in our page pool information?
> > > > > You can then skip this and check pool->p.nid == numa_mem_id(), regardless of
> > > > > what's configured.   
> > > > 
> > > > This single code line helps support that drivers can control the nid
> > > > themselves.  This is a feature that is only used my mlx5 AFAIK.
> > > > 
> > > > I do think that is useful to allow the driver to "control" the nid, as
> > > > pinning/preferring the pages to come from the NUMA node that matches
> > > > the PCI-e controller hardware is installed in does have benefits.  
> > > 
> > > Sure you can keep the if statement as-is, it won't break anything. 
> > > Would we want to store the actual numa id in pool->p.nid if the user
> > > selects 'NUMA_NO_NODE'?
> >  
> > No. pool->p.nid should stay as NUMA_NO_NODE, because that makes it
> > dynamic.  If someone moves an RX IRQ to another CPU on another NUMA
> > node, then this 'NUMA_NO_NODE' setting makes pages transitioned
> > automatically.
> Ok this assumed that drivers were going to use page_pool_nid_changed(), but with
> the current code we don't have to force them to do that. Let's keep this as-is.
> 
> I'll be running a few more tests  and wait in case Saeed gets a chance to test
> it and send my reviewed-by
> 
> Cheers
> /Ilias
> > 
> > -- 
> > Best regards,
> >   Jesper Dangaard Brouer
> >   MSc.CS, Principal Kernel Engineer at Red Hat
> >   LinkedIn: http://www.linkedin.com/in/brouer
> > 
