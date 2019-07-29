Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C218578D6C
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 16:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728034AbfG2OGO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 10:06:14 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:39842 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727539AbfG2OGO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 10:06:14 -0400
Received: by mail-qt1-f194.google.com with SMTP id l9so59716881qtu.6
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 07:06:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=e3H10lsD+PF2wWV9MNTgVFwwtVpowxTsxjCMwdaLJ4w=;
        b=YnmRfHm6VgZjh3wG5QbQgCgu8cmyRbTq/jscfgyyCU6isIL3HYFwqdLuoHgSOsBeQi
         9O+NAhaIR4Rnokuxvryu0/v79OVcW9anvmYtei6f1DyeLDPxnHDb1tUWGToXOBTtkRYp
         iSMlm/vc9flZTrHgBkW8tLnRfdL6fOyG0KQKpLlaFsGr9EQuiTU0DlgFXhyh7cL05y89
         64BwyHQMszdmmLmBfVFEHUGVonwH0VVDeLAfUQWN8pTxAEbliq0AjYmKr3OgMgWTt72d
         dA04mQihsz2Q7Z1xhj7NtFhjsZWs+kpMdX3bHjPW+tI32GKO7BUtdvCA2NkzBMaKXNik
         S7Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=e3H10lsD+PF2wWV9MNTgVFwwtVpowxTsxjCMwdaLJ4w=;
        b=dSoA6Wyh80eGsPJ9hlwaLNwLjSSqL/TOAPF8v0FBZ11QqXJT7O4PbsZvfoVGPe/nt4
         znDShXeinKdO+nk1a2O44BaJc6yhKPBU5jYDXwuwtU/7Eh3dnSvaid5IhlXRxgd4UMW/
         t4G4QpaXOCa0hKRTI3IsHBhTPb6Er+x6gKsTIDWprZKBcw0IJx17jzge+gkNyJCk5X+I
         vsgwIAaZmbIhgiDxfKm4U46n4W7BMgb/8mPQx7zmFC0XsjIDR7Ho/cNkmWSPe8h93Gbh
         tWMC4kmcS/aCvuDK0+CklCwd0YN1aMYnqsfmbHiAU7YXUZUOFBWyU2wOY54ZNtaFzPez
         2TAQ==
X-Gm-Message-State: APjAAAUBtP9o53rI5nM43pwWCPBijVlQCRkvxXFijbZI0QZCYGFid2rt
        AF2tzf03YuicLoh8KDlrvwNjPw==
X-Google-Smtp-Source: APXvYqxFicmk8wpRGgSa2+UNcRF/GCwRC3sMCPPhIeu38A9Hzr2Kd2myxNE1Nt8SIX9ajafhrMX9YA==
X-Received: by 2002:ac8:16ac:: with SMTP id r41mr78715680qtj.346.1564409173016;
        Mon, 29 Jul 2019 07:06:13 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-55-100.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.55.100])
        by smtp.gmail.com with ESMTPSA id w19sm24288537qkj.66.2019.07.29.07.06.12
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 29 Jul 2019 07:06:12 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1hs6I0-00072v-3n; Mon, 29 Jul 2019 11:06:12 -0300
Date:   Mon, 29 Jul 2019 11:06:12 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Gal Pressman <galpress@amazon.com>
Cc:     Michal Kalderon <mkalderon@marvell.com>,
        Kamal Heib <kamalheib1@gmail.com>,
        Ariel Elior <aelior@marvell.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v6 rdma-next 1/6] RDMA/core: Create mmap database and
 cookie helper functions
Message-ID: <20190729140612.GC17990@ziepe.ca>
References: <20190709141735.19193-1-michal.kalderon@marvell.com>
 <20190709141735.19193-2-michal.kalderon@marvell.com>
 <20190725175540.GA18757@ziepe.ca>
 <MN2PR18MB3182469DB08CD20B56C9697FA1C10@MN2PR18MB3182.namprd18.prod.outlook.com>
 <20190725195236.GF7467@ziepe.ca>
 <MN2PR18MB3182BFFEA83044C0163F9DCBA1C00@MN2PR18MB3182.namprd18.prod.outlook.com>
 <20190726132316.GA8695@ziepe.ca>
 <1e54c4de-7349-3154-1b98-39774c83899f@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1e54c4de-7349-3154-1b98-39774c83899f@amazon.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 28, 2019 at 11:45:56AM +0300, Gal Pressman wrote:
> On 26/07/2019 16:23, Jason Gunthorpe wrote:
> > On Fri, Jul 26, 2019 at 08:42:07AM +0000, Michal Kalderon wrote:
> > 
> >>>> But we don't free entires from the xa_array ( only when ucontext is
> >>>> destroyed) so how will There be an empty element after we wrap ?
> >>>
> >>> Oh!
> >>>
> >>> That should be fixed up too, in the general case if a user is
> >>> creating/destroying driver objects in loop we don't want memory usage to
> >>> be unbounded.
> >>>
> >>> The rdma_user_mmap stuff has VMA ops that can refcount the xa entry and
> >>> now that this is core code it is easy enough to harmonize the two things and
> >>> track the xa side from the struct rdma_umap_priv
> >>>
> >>> The question is, does EFA or qedr have a use model for this that allows a
> >>> userspace verb to create/destroy in a loop? ie do we need to fix this right
> >>> now?
> > 
> >> The mapping occurs for every qp and cq creation. So yes.
> >>
> >> So do you mean add a ref-cnt to the xarray entry and from umap
> >> decrease the refcnt and free?
> > 
> > Yes, free the entry (release the HW resource) and release the xa_array
> > ID.
> 
> This is a bit tricky for EFA.
> The UAR BAR resources (LLQ for example) aren't cleaned up until the UAR is
> deallocated, so many of the entries won't really be freed when the refcount
> reaches zero (i.e the HW considers these entries as refcounted as long as the
> UAR exists). The best we can do is free the DMA buffers for appropriate entries.

Drivers can still defer HW destruction until the ucontext destroys,
but this gives an option to move it sooner, which looks like the other
drivers do need as they can allocate these things in userspace loops.

Jason
