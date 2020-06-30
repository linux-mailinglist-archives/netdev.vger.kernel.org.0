Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BEE820ECC2
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 06:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729360AbgF3El5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 00:41:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729321AbgF3El5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 00:41:57 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A08FC061755;
        Mon, 29 Jun 2020 21:41:57 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id u9so4360248pls.13;
        Mon, 29 Jun 2020 21:41:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=/4EbjWc3OcYBVYlmz6RH6shyF/Bf9W7LIE0MBGcrCAc=;
        b=MzAXhvAodARvduNMO3wJCALgHXwOz8vGXAsrWe4j14bZ2ULzrL+S2QmffOpsHzIEMT
         tn1fyGE5N5lupBTHUVdykDNyFMkcRe4H+JGWXpvAR3qmt7ZMHSrTbn20zTmBrBKkD1Nx
         PuYFnAKh6fq3w0QOex6KtrSpnSYyVda1XZ6lZQ7ez2K3zQW5lrq6QgDdeDtp0cs6xXUl
         /Sgrg9Txp5ac4SGiCK5HeMR3qLjs7+GeoMqsk5aZ6bAlCAGEzHY92STFFdZ77DJ7FG/w
         c1IuS2qkKnZITN74FmVqu3ooHjdQStSUwqqEpODEWSSRp/U5+mM7ksTtPGGxwKLrsf+M
         POKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=/4EbjWc3OcYBVYlmz6RH6shyF/Bf9W7LIE0MBGcrCAc=;
        b=DDM1gecGSu9BCERnMqXdMbRNk2fWA98ZGpg+14Z2vlHjJFz4ktuSEXshlYI26RXYv9
         M6BrndehrDih/kcuhLCsVF5ov6yoaj6EaCDhavdhrSoX395LZ7ec87Or4KCYsLIqGk7J
         51AVBmjbfrNAIwLq+6skuIkqRApj1ak303rtNxD7jVG4QMPDcHo2SIGMND7UFGfVyZFm
         LL4cFoFC56bgoPSySvxvK8ENwzKz+8J8ndMq3iXPVagNvs5VLTbGCLecrc35ehR7i/Bb
         UFf8U/s1ud8wpDZyf2OhQZcFEDzwEy4O2tn7DSdYm9FToL2YJaEGqgxgom0j0rTBio0g
         SReg==
X-Gm-Message-State: AOAM533fls6NKS5eE3DmFIrc8SQPu5gHxWPprSuD2K8zCuN6yWD+5FJz
        g/RB2YDId75iL4jlT0jArCY=
X-Google-Smtp-Source: ABdhPJzKSASVm1LZHs45CVwtA2XbE2R50KOnbmEaHjY91c/pCVPXpQnXpGKdEO4YpUBb/wyvVFxfoA==
X-Received: by 2002:a17:90a:ac05:: with SMTP id o5mr21099604pjq.228.1593492116510;
        Mon, 29 Jun 2020 21:41:56 -0700 (PDT)
Received: from f3 (ae055068.dynamic.ppp.asahi-net.or.jp. [14.3.55.68])
        by smtp.gmail.com with ESMTPSA id nv9sm929621pjb.6.2020.06.29.21.41.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 21:41:55 -0700 (PDT)
Date:   Tue, 30 Jun 2020 13:41:51 +0900
From:   Benjamin Poirier <benjamin.poirier@gmail.com>
To:     Coiby Xu <coiby.xu@gmail.com>
Cc:     devel@driverdev.osuosl.org, joe@perches.com,
        dan.carpenter@oracle.com, gregkh@linuxfoundation.org,
        Manish Chopra <manishc@marvell.com>,
        "supporter:QLOGIC QLGE 10Gb ETHERNET DRIVER" 
        <GR-Linux-NIC-Dev@marvell.com>,
        "open list:QLOGIC QLGE 10Gb ETHERNET DRIVER" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 4/4] staging: qlge: replace pr_err with netdev_err
Message-ID: <20200630044151.GA125790@f3>
References: <20200627145857.15926-1-coiby.xu@gmail.com>
 <20200627145857.15926-5-coiby.xu@gmail.com>
 <20200629053004.GA6165@f3>
 <20200629174352.euw4lckze2k7xtbm@Rk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200629174352.euw4lckze2k7xtbm@Rk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-06-30 01:43 +0800, Coiby Xu wrote:
> On Mon, Jun 29, 2020 at 02:30:04PM +0900, Benjamin Poirier wrote:
> > On 2020-06-27 22:58 +0800, Coiby Xu wrote:
> > [...]
> > >  void ql_dump_qdev(struct ql_adapter *qdev)
> > >  {
> > > @@ -1611,99 +1618,100 @@ void ql_dump_qdev(struct ql_adapter *qdev)
> > >  #ifdef QL_CB_DUMP
> > >  void ql_dump_wqicb(struct wqicb *wqicb)
> > >  {
> > > -	pr_err("Dumping wqicb stuff...\n");
> > > -	pr_err("wqicb->len = 0x%x\n", le16_to_cpu(wqicb->len));
> > > -	pr_err("wqicb->flags = %x\n", le16_to_cpu(wqicb->flags));
> > > -	pr_err("wqicb->cq_id_rss = %d\n",
> > > -	       le16_to_cpu(wqicb->cq_id_rss));
> > > -	pr_err("wqicb->rid = 0x%x\n", le16_to_cpu(wqicb->rid));
> > > -	pr_err("wqicb->wq_addr = 0x%llx\n",
> > > -	       (unsigned long long)le64_to_cpu(wqicb->addr));
> > > -	pr_err("wqicb->wq_cnsmr_idx_addr = 0x%llx\n",
> > > -	       (unsigned long long)le64_to_cpu(wqicb->cnsmr_idx_addr));
> > > +	netdev_err(qdev->ndev, "Dumping wqicb stuff...\n");
> > 
> > drivers/staging/qlge/qlge_dbg.c:1621:13: error: ‘qdev’ undeclared (first use in this function); did you mean ‘cdev’?
> > 1621 |  netdev_err(qdev->ndev, "Dumping wqicb stuff...\n");
> >      |             ^~~~
> >      |             cdev
> > 
> > [...]
> > and many more like that
> > 
> > Anyways, qlge_dbg.h is a dumpster. It has hundreds of lines of code
> > bitrotting away in ifdef land. See this comment from David Miller on the
> > topic of ifdef'ed debugging code:
> > https://lore.kernel.org/netdev/20200303.145916.1506066510928020193.davem@davemloft.net/
> 
> Thank you for spotting this problem! This issue could be fixed by
> passing qdev to ql_dump_wqicb. Or are you suggesting we completely
> remove qlge_dbg since it's only for the purpose of debugging the driver
> by the developer?

At 2000 lines, qlge_dbg.c alone is larger than some entire ethernet
drivers. Most of what it does is dump kernel data structures or pci
memory mapped registers to dmesg. There are better facilities for that.
My thinking is not simply to delete qlge_dbg.c but to replace it, making
sure that most of the same information is still available. For data
structures, crash or drgn can be used; possibly with a script for the
latter which formats the data. For pci registers, they should be
included in the ethtool register dump and a patch added to ethtool to
pretty print them. That's what other drivers like e1000e do. For the
"coredump", devlink health can be used.

The qlge_force_coredump module option should also be removed. At the
moment, calling the ethtool register dump function with that option
enabled does a hexdump of a 176k struct to dmesg. That's shameful.

> 
> Btw, I'm curious how you make this compiling error occur. Do you manually trigger
> it via "QL_CB_DUMP=1 make M=drivers/staging/qlge" or use some automate
> tools?

I just uncommented the defines in qlge.h
