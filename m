Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFBAD29DCF1
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 01:33:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729325AbgJ2Adl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 20:33:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732415AbgJ1WU5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:20:57 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A59DC0613CF
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 15:20:57 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id l16so1153410eds.3
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 15:20:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gg/EaFLk9AbLnAJGafga7GK4mhL0MiGRMckcdbCQP44=;
        b=Qr2glRpNJyYB1wEgmcO7j2dDJ0YYTC0HcATnft1fXy5hzdCT9TQV4nCCI5OmohzHYv
         jaZsfV337DR46W0TcI+Ok2P7UbclJCCLHCYsNP0QvCCKLn/V/WvwaUZjw3L5oZL2EjBi
         v4nH/d2otzmLKkyCW2PR8A+POOTuPl8rQfuM6hnRNPWADs/fiO6wnMVUf9vl3Oae0FKV
         h6F0cvRNBGXfGSgq5uMiyeEihAN4ya5qkYIPxEHMIRZJmXEw7wPZ9fxIAEk1gCRDFAd6
         JGrbQOV+P9Hob0cwIJ40R4mhbi+F9uFI7T4au5rVbiVvNe9qrK6UQaqdAQQEf5epN2L2
         ZwTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gg/EaFLk9AbLnAJGafga7GK4mhL0MiGRMckcdbCQP44=;
        b=d+XfEsdsbeCQ5ILj9O2M43zNuVAL+Epel7NTgwNo+U0CFmdxMoP3dkZ+kSfVtcEeCR
         h1LQTNyIzzHxHdj2wG/AiMa/mQ3JMWNuhT0UI/Al38hI52tI6G49B3zf+kU/LFd/b9kg
         DpV6xRn5/aldlULlC63I3dft/CpoDVIA4igCmfshRbSzb4noBmEQJRIsqal7vGBT2nzv
         UDzeN7pbBEdQDNPjkVXY33i05pTBlqs+0Iq5nliIRt5EepT7Pbivj8d5emQZFuXEa4Ft
         V8XBkPY19CQTVwJr/y6AtP6oDdcjyHlEqSfZ7erx1pylCCTUdLXtxumaOPWcE8ZMsM0/
         cNCg==
X-Gm-Message-State: AOAM5301+v87fI22WIyQs6hvHBkaRSaV9sn/+R60+d5Nu5Qg6Et+SlYP
        sY0hqf6QeuE6Jww12b5+WMWnPyckcXj8Tg==
X-Google-Smtp-Source: ABdhPJzOLRnn/gCi+t8WLxcqYMWXmzddvrpIa1d39PECWp4w0aND7XCXyZ2rwAZ+CV3hzmJVN62Okg==
X-Received: by 2002:adf:f643:: with SMTP id x3mr8622889wrp.180.1603882796063;
        Wed, 28 Oct 2020 03:59:56 -0700 (PDT)
Received: from apalos.home (athedsl-246545.home.otenet.gr. [85.73.10.175])
        by smtp.gmail.com with ESMTPSA id b5sm6287867wrs.97.2020.10.28.03.59.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 03:59:55 -0700 (PDT)
Date:   Wed, 28 Oct 2020 12:59:51 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        brouer@redhat.com
Subject: Re: [PATCH net-next 1/4] net: xdp: introduce bulking for xdp tx
 return path
Message-ID: <20201028105951.GA52697@apalos.home>
References: <cover.1603824486.git.lorenzo@kernel.org>
 <7495b5ac96b0fd2bf5ab79b12e01bf0ee0fff803.1603824486.git.lorenzo@kernel.org>
 <20201028092734.GA51291@apalos.home>
 <20201028102304.GA5386@lore-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201028102304.GA5386@lore-desk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 28, 2020 at 11:23:04AM +0100, Lorenzo Bianconi wrote:
> > Hi Lorenzo,
> 
> Hi Ilias,
> 
> thx for the review.
> 
> > 
> > On Tue, Oct 27, 2020 at 08:04:07PM +0100, Lorenzo Bianconi wrote:
> 
> [...]
> 
> > > +void xdp_return_frame_bulk(struct xdp_frame *xdpf,
> > > +			   struct xdp_frame_bulk *bq)
> > > +{
> > > +	struct xdp_mem_info *mem = &xdpf->mem;
> > > +	struct xdp_mem_allocator *xa, *nxa;
> > > +
> > > +	if (mem->type != MEM_TYPE_PAGE_POOL) {
> > > +		__xdp_return(xdpf->data, &xdpf->mem, false);
> > > +		return;
> > > +	}
> > > +
> > > +	rcu_read_lock();
> > > +
> > > +	xa = bq->xa;
> > > +	if (unlikely(!xa || mem->id != xa->mem.id)) {
> > 
> > Why is this marked as unlikely? The driver passes it as NULL. Should unlikely be
> > checked on both xa and the comparison?
> 
> xa is NULL only for the first xdp_frame in the burst while it is set for
> subsequent ones. Do you think it is better to remove it?

Ah correct, missed the general context of the driver this runs in.

> 
> > 
> > > +		nxa = rhashtable_lookup(mem_id_ht, &mem->id, mem_id_rht_params);
> > 
> > Is there a chance nxa can be NULL?
> 
> I do not think so since the page_pool is not destroyed while there are
> in-flight pages, right?

I think so but I am not 100% sure. I'll apply the patch and have a closer look

Cheers
/Ilias
