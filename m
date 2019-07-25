Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 157C87567F
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 20:01:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727555AbfGYSBv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 14:01:51 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:41265 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbfGYSBu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 14:01:50 -0400
Received: by mail-qk1-f193.google.com with SMTP id v22so37111216qkj.8
        for <netdev@vger.kernel.org>; Thu, 25 Jul 2019 11:01:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=6v5MkCi4xLD16RtVl5nsDIS0V98YRsKAmGxIsQ/DNno=;
        b=aST9IpqFyabke7MgrdKH8RliPQ4oZDwiJ5rgfBy6fdctbVnt/xHt27f7szngA7K5Rl
         DZgg9LyTtP3+YtWkSkijCbcU22qcN46KPWjrWSc8SjvVNtLW0xlgzq9abDc6Ptat2zHI
         NYJnnR6Sj+JlQnCA8XNy73aPgs10rhHOGmVOw1hx2U3aw4SBHbQA9vZwny+Cp6akZWlL
         aSH3NpCW7UVB/IdbuD5GtXUWKgHtvpcmQu7BLTriIqynUOakbiOwBZid1uvtkWa4pK5K
         rNqtoHdD017zEnPyCgR7tCz1FSgK+YG3+SE8LVkhn3xH8WI0FDVgTx77zMfcePaAKBAJ
         T9ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=6v5MkCi4xLD16RtVl5nsDIS0V98YRsKAmGxIsQ/DNno=;
        b=AjdVtDAhlXDIHjD+nieP1HIJHxxpdfYyO1EwD6pCemU9WB2l9oS/K5RvWl22Zo4DMa
         xtRRyniP0Do8QgaukncfQ7iiAB7XtPkgxSmKBuyP1EtSPIWWkLScxct0AfqHT5AfHRyD
         ySaJvwTDOUOy9vW1A+x55zWpAkwUyuyIADylSA2ZQA2UWatyzzrydnBbE1PHusbVX2zF
         Ke22U+M48uiaVFOqzn/rMWkd1n25XN6hxTY+72mSu7WUQ04meV/XqyE4iCGiTbpWjniX
         gPovRLRw4KMyt82HOmu3YXI4nJZlbGu3Dss+p1j7xkPYpORbw4XuiCne6cLyEDDuIACX
         ljmw==
X-Gm-Message-State: APjAAAWGwFyfSm554Z7S5J/PbHDeKIMySen3DZdkf4OMoZOo7L7P78A9
        mHsRyRQjsmMdzLRU/a1G5DmoVvdlzu5BxA==
X-Google-Smtp-Source: APXvYqwrM1/SQ9ipP5KG64itaIr/bEjL0G6/yZFGmRJ19/HnLHkdSTJKyvRBldqHBv81oAdT5oLFfQ==
X-Received: by 2002:a37:c81:: with SMTP id 123mr61435072qkm.474.1564077709679;
        Thu, 25 Jul 2019 11:01:49 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-55-100.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.55.100])
        by smtp.gmail.com with ESMTPSA id i62sm23320393qke.52.2019.07.25.11.01.49
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 25 Jul 2019 11:01:49 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1hqi3o-0005I8-Ol; Thu, 25 Jul 2019 15:01:48 -0300
Date:   Thu, 25 Jul 2019 15:01:48 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Michal Kalderon <michal.kalderon@marvell.com>
Cc:     ariel.elior@marvell.com, dledford@redhat.com, galpress@amazon.com,
        linux-rdma@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, Bernard Metzler <bmt@zurich.ibm.com>
Subject: Re: [PATCH v6 rdma-next 0/6] RDMA/qedr: Use the doorbell overflow
 recovery mechanism for RDMA
Message-ID: <20190725180148.GA20288@ziepe.ca>
References: <20190709141735.19193-1-michal.kalderon@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190709141735.19193-1-michal.kalderon@marvell.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 09, 2019 at 05:17:29PM +0300, Michal Kalderon wrote:
> This patch series uses the doorbell overflow recovery mechanism
> introduced in
> commit 36907cd5cd72 ("qed: Add doorbell overflow recovery mechanism")
> for rdma ( RoCE and iWARP )
> 
> The first three patches modify the core code to contain helper
> functions for managing mmap_xa inserting, getting and freeing
> entries. The code was taken almost as is from the efa driver.
> There is still an open discussion on whether we should take
> this even further and make the entire mmap generic. Until a
> decision is made, I only created the database API and modified
> the efa and qedr driver to use it. The doorbell recovery code will be based
> on the common code.
> 
> Efa driver was compile tested only.
> 
> rdma-core pull request #493
> 
> Changes from V5:
> - Switch between driver dealloc_ucontext and mmap_entries_remove.
> - No need to verify the key after using the key to load an entry from
>   the mmap_xa.
> - Change mmap_free api to pass an 'entry' object.
> - Add documentation for mmap_free and for newly exported functions.
> - Fix some extra/missing line breaks.

Lets do SIW now as well, it has the same xa scheme copied from EFA

Thanks,
Jason
