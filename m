Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA80E119192
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 21:10:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726522AbfLJUKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 15:10:37 -0500
Received: from mail-wm1-f51.google.com ([209.85.128.51]:37998 "EHLO
        mail-wm1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726364AbfLJUKh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 15:10:37 -0500
Received: by mail-wm1-f51.google.com with SMTP id p17so4604240wmi.3
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 12:10:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=O3VF/Bit85Za+22/UiJfAF/ByjYkLV6gxloE05tqeI8=;
        b=G7Ez8mCM2REkbYFr4acRzlRPOYop0D4kgl4p++ctQK5s21DmCHzy3AggmbxJ5EIqA+
         872uh8lUIJSv8tCk34guRgn687eFvRfsj/NwbhLsHmIXaa+V0zL0RdgwGISlb3RhGZeI
         wmbygTE6ZGkz8YlYyaTpohASSJnLtQdfMU78xuJSxCbwfvGxeCLTybK+6z8nvtvii18B
         RMxxLARow7wXekGPRXrrjb5mQECaivOz51G32w6vmd5kCqV52I2I5ipdKcj6iW1803eM
         qD76uNh9PHSu8ssHzu1YQCkm8M6krI78GK8w1do2Mx85gqHV/dgGWh4y5Oy5uo9SV9Nb
         +aMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=O3VF/Bit85Za+22/UiJfAF/ByjYkLV6gxloE05tqeI8=;
        b=toCSIhY5KpwpbGKgiXX20TNq+ghbJ07dswOvpTQSqnOy/4moJ1bUNQ4I+wPDK7ONTg
         guMOZGIblvHW3PJfL7lCxKOyl6yE1Q35zmu0Dba75FWZZp3YBb9PJzJFiRVFEBhpyxSI
         MfCn/2ajkoLYT3/NK6hGLVsWTEY2TDiFQ0JX0NcG/lje+xjK5GuPngcy9Bu4LrfolwGo
         VVOfIKty+e9ASQTFPj+6HR6dCtR6k91nrHkeJSH/BMVpQnc4mHxYhJcCIWDxyYGVoBX3
         rllUTLI2k30FAdMw0P+pqNd3FnxEADbICVLdrTr3B+FeIeOqygAUHzroZ0Ipw3g/BIST
         K20Q==
X-Gm-Message-State: APjAAAU7kjNes9WKiewW3cKhTYfZcEyk2p4hIrEFrsgnEa5DghKnrtvl
        ZCWQ6BSnwoaiStynI2mseN6g1w==
X-Google-Smtp-Source: APXvYqzd0GuRw1r+B+xxNAKCZAh2zbM11UqQxPov8eD6WEYBgniOtZxUr43zSkGb96gnA1y2HbtDlw==
X-Received: by 2002:a1c:4f:: with SMTP id 76mr6913005wma.69.1576008635497;
        Tue, 10 Dec 2019 12:10:35 -0800 (PST)
Received: from apalos.home (athedsl-4476713.home.otenet.gr. [94.71.27.49])
        by smtp.gmail.com with ESMTPSA id s65sm4429795wmf.48.2019.12.10.12.10.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 12:10:35 -0800 (PST)
Date:   Tue, 10 Dec 2019 22:10:32 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Saeed Mahameed <saeedm@dev.mellanox.co.il>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>,
        "linyunsheng@huawei.com" <linyunsheng@huawei.com>,
        Li Rongqing <lirongqing@baidu.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH][v2] page_pool: handle page recycle for NUMA_NO_NODE
 condition
Message-ID: <20191210201032.GA2034@apalos.home>
References: <1575624767-3343-1-git-send-email-lirongqing@baidu.com>
 <9fecbff3518d311ec7c3aee9ae0315a73682a4af.camel@mellanox.com>
 <20191209131416.238d4ae4@carbon>
 <816bc34a7d25881f35e0c3e21dc2283ffeffb093.camel@mellanox.com>
 <20191210150244.GB12702@apalos.home>
 <CALzJLG_m0haciU6AinMvy3MfGGFokfGf+1djRnfsZczgxnuKUg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALzJLG_m0haciU6AinMvy3MfGGFokfGf+1djRnfsZczgxnuKUg@mail.gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Saeed,

On Tue, Dec 10, 2019 at 12:02:12PM -0800, Saeed Mahameed wrote:
> On Tue, Dec 10, 2019 at 7:02 AM Ilias Apalodimas
> <ilias.apalodimas@linaro.org> wrote:
> >
> > Hi Saeed,
> >
> > > >
> > > > The patch description doesn't explain the problem very well.
> > > >
> > > > Lets first establish what the problem is.  After I took at closer
> > > > look,
> > > > I do think we have a real problem here...
> > > >
> > > > If function alloc_pages_node() is called with NUMA_NO_NODE (see below
> > > > signature), then the nid is re-assigned to numa_mem_id().
> > > >
> > > > Our current code checks: page_to_nid(page) == pool->p.nid which seems
> > > > bogus, as pool->p.nid=NUMA_NO_NODE and the page NID will not return
> > > > NUMA_NO_NODE... as it was set to the local detect numa node, right?
> > > >
> > >
> > > right.
> > >
> > > > So, we do need a fix... but the question is that semantics do we
> > > > want?
> > > >
> > >
> > > maybe assume that __page_pool_recycle_direct() is always called from
> > > the right node and change the current bogus check:
> >
> > Is this a typo? pool_page_reusable() is called from __page_pool_put_page().
> >
> > page_pool_put_page and page_pool_recycle_direct() (no underscores) call that.
> 
> Yes a typo :) , thanks for the correction.
> 
> > Can we guarantee that those will always run from the correct cpu?
> No, but we add the tool to correct any discrepancy: page_pool_nid_changed()
> 
> > In the current code base if they are only called under NAPI this might be true.
> > On the page_pool skb recycling patches though (yes we'll eventually send those
> > :)) this is called from kfree_skb().
> > I don't think we can get such a guarantee there, right?
> >
> 
> Yes, but this has nothing to do with page recycling from pool's owner
> level (driver napi)
>  for SKB recycling we can use pool.nid to recycle, and not numa_mem_id().

Right i responded to an email without the proper context!
Let me try again. You suggested  changing the check
from page_to_nid(page) == pool->p.nid to page_to_nid(page) == numa_mem_id().

Since the skb recycling code is using page_pool_put_page() won't that break the
recycling for thatr patchset?

Thanks
/Ilias
