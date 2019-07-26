Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 282B276740
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 15:23:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727171AbfGZNXT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 09:23:19 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:35037 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726491AbfGZNXT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 09:23:19 -0400
Received: by mail-qk1-f195.google.com with SMTP id r21so39038808qke.2
        for <netdev@vger.kernel.org>; Fri, 26 Jul 2019 06:23:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=vRRbO5Ly4feSqORGvyHTD+nUIz4sPUrpxD23Z/PcZIs=;
        b=lnoLpfhGnR68/ijYAsFSARa9PAiR9DurOgCVXltbgSRWnKcaEbztFF1WbVh36AWWkf
         4FvNFQAFqBjE+TjBL5w7nzBQn2sOOIuk+Bd5FIyo8QhMLE8Hu3q5o3qa4fcIidBfVzZm
         RYhD+vSQQI5Ck+SL4KqnCd81vzXPXuhiiGLyfdmtSNp1KktghjaJ2WvvDzpdagovDtY+
         tWieeikirYGqiB3vBbOB9rruzOZ0hXBzqK6qfQEpeoGwIhd+YKU1AsNsB4aZghAGuUGm
         BKteSVtyoWYGHfbzEgMpfXHr6+wAKoHIMasQ1pE60xSEPuujQVqeFzJ1l0ZRWWhHVfZB
         wZFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=vRRbO5Ly4feSqORGvyHTD+nUIz4sPUrpxD23Z/PcZIs=;
        b=YKqSXSZ8DrVrGHnB08HhPvfEpR20qfEo8pshteLYkUPCryWAtwq3ypmotZ3QO0CDSN
         YWbrhw5aMBvTFFrDWZClRHrH8dElWcFB+3/jhiQf5Jrwx7f2JsI50xGaR3lvfy6iiKpr
         q+D4F8/TyGllxfdgzOygXlGtl6ADcXqiszz/yWpj3HWTC2uAqaow+WlnVJu459NBBXjJ
         wxPxjg/ysCU/EznXyA6FW/i8oWE9SmDZhlS9omrj0ZBLEm8DOBog+dnUEJ3AgV8YSb7T
         iuunUk3o1wFPWrYL2maqXqkL1AXQIy7qCQyJFRb/qIj2GOhvgvuS4IVWNjAtrhzoyB+f
         d1pQ==
X-Gm-Message-State: APjAAAUExvF87bTKU+KeFMi8RHz82BPuvQb5R09GpjzszOnjgUM/l+dQ
        uGAY/40A+uFtw3ucehxr9qgrAA==
X-Google-Smtp-Source: APXvYqxxJ3XLAwxhUmusgh+3CwAODLUZgB4GLlIST9k3xfUL6ZJU+aAvuIf5HdnLE8FWqtKGN98/Eg==
X-Received: by 2002:ae9:c106:: with SMTP id z6mr65624136qki.285.1564147398170;
        Fri, 26 Jul 2019 06:23:18 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-55-100.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.55.100])
        by smtp.gmail.com with ESMTPSA id t2sm30286532qth.33.2019.07.26.06.23.17
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 26 Jul 2019 06:23:17 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1hr0Bp-0002qo-0n; Fri, 26 Jul 2019 10:23:17 -0300
Date:   Fri, 26 Jul 2019 10:23:17 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Michal Kalderon <mkalderon@marvell.com>
Cc:     Kamal Heib <kamalheib1@gmail.com>,
        Ariel Elior <aelior@marvell.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "galpress@amazon.com" <galpress@amazon.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v6 rdma-next 1/6] RDMA/core: Create mmap database and
 cookie helper functions
Message-ID: <20190726132316.GA8695@ziepe.ca>
References: <20190709141735.19193-1-michal.kalderon@marvell.com>
 <20190709141735.19193-2-michal.kalderon@marvell.com>
 <20190725175540.GA18757@ziepe.ca>
 <MN2PR18MB3182469DB08CD20B56C9697FA1C10@MN2PR18MB3182.namprd18.prod.outlook.com>
 <20190725195236.GF7467@ziepe.ca>
 <MN2PR18MB3182BFFEA83044C0163F9DCBA1C00@MN2PR18MB3182.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN2PR18MB3182BFFEA83044C0163F9DCBA1C00@MN2PR18MB3182.namprd18.prod.outlook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 26, 2019 at 08:42:07AM +0000, Michal Kalderon wrote:

> > > But we don't free entires from the xa_array ( only when ucontext is
> > > destroyed) so how will There be an empty element after we wrap ?
> > 
> > Oh!
> > 
> > That should be fixed up too, in the general case if a user is
> > creating/destroying driver objects in loop we don't want memory usage to
> > be unbounded.
> > 
> > The rdma_user_mmap stuff has VMA ops that can refcount the xa entry and
> > now that this is core code it is easy enough to harmonize the two things and
> > track the xa side from the struct rdma_umap_priv
> > 
> > The question is, does EFA or qedr have a use model for this that allows a
> > userspace verb to create/destroy in a loop? ie do we need to fix this right
> > now?

> The mapping occurs for every qp and cq creation. So yes.
>
> So do you mean add a ref-cnt to the xarray entry and from umap
> decrease the refcnt and free?

Yes, free the entry (release the HW resource) and release the xa_array
ID.

Then, may as well don't use cyclic allocation for the xa, just the
algorithm above would be OK.

The zap should also clear the refs, and then when the ucontext is
destroyed we can just WARN_ON the xarray is empty. Either all the vmas
were destroyed or all were zapped.

Jason
