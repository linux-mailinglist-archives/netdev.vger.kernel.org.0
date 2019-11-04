Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE0D5EEA92
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 21:57:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729567AbfKDU5m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 15:57:42 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:46524 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729548AbfKDU5l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 15:57:41 -0500
Received: by mail-qt1-f193.google.com with SMTP id u22so26047238qtq.13
        for <netdev@vger.kernel.org>; Mon, 04 Nov 2019 12:57:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=DHyq0HiLvr2oRZ7fsWKuvfiy0KSCrmJQP2N7wxll3ck=;
        b=GqKdo8q3EQ1hr6qek+daVbq7asYL8vgosOUNPq/TbaKVNw+fSwsVZvMXYAXCf0AJyJ
         u82hnz0QILmabMP4l0QBspnNgDON3wCBCl2euZ2xUfz4wbz1CJOCkCDLlOnh4i58Oaj/
         S3gq/Jh9sfa4MobfNbFXPlzU8wQ8qlAiWQ9QDx9r++NF1VyZNacvaIxbfl+Dz9q/YaK7
         LJZ1bbR858MSdLa9WbMS13d/j0HGbePzEAUYRTf3vNGneWwIu7V1pWB8dhbOd6RohsWw
         Lzscw767cSCt9xjt6Uiuin4I08CfE7g1YZRaK11NZ5fT7S0HH+Tq61iyMWJYbr4RPL29
         XI3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=DHyq0HiLvr2oRZ7fsWKuvfiy0KSCrmJQP2N7wxll3ck=;
        b=prrARWlU11JxGgEnq+MOFzBoO1hrNAPmiDeKXHtpDoqtAcrb92lUywiwcwBY4hepf0
         atNh+OrcBsjXjQ1+tt03G82Qtgdy825NEZCPPziD/aPjOOte97A2z5LZHvuGFQZCHWTk
         kO5tM5j4Lg0R/3uCnCO/vtDBsi0KikOBPpv7lVzu7NPaHkwO5O3nAvo7EPbnKdmozw7U
         bqUiRyvggZ4iNDxAQmB3X3/NkTWSsKLJLEGgQ3EwHXLp242ce3zvAw5Rv4Twzv3NloUa
         3qMdMnoHPMLAMutDBAUpsOqNSTQsN7FWQPcvBE7rhe9Un7rv2gjhqDvr5WJ8wnLdk+45
         lzaA==
X-Gm-Message-State: APjAAAV+jUCkdgBswm/iqLgKaDcIuIb/QMhT7Rks4cai9GSmcO7N8B/Q
        FKYPLhsonZFxpiT8S0Aj4Q9Dvg==
X-Google-Smtp-Source: APXvYqzcbzV98q5L3IoWgV1btJnfFj6kw4clhQUw4ORkigswFo+IphwlhQMZSa6Hl6m/W3Z9gLas4A==
X-Received: by 2002:ad4:4092:: with SMTP id l18mr462915qvp.114.1572901059500;
        Mon, 04 Nov 2019 12:57:39 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-113-180.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.180])
        by smtp.gmail.com with ESMTPSA id l20sm5226323qtq.78.2019.11.04.12.57.38
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 04 Nov 2019 12:57:38 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1iRjPu-0000Zj-4J; Mon, 04 Nov 2019 16:57:38 -0400
Date:   Mon, 4 Nov 2019 16:57:38 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     John Hubbard <jhubbard@nvidia.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alex Williamson <alex.williamson@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dave Chinner <david@fromorbit.com>,
        David Airlie <airlied@linux.ie>,
        "David S . Miller" <davem@davemloft.net>,
        Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>,
        Jens Axboe <axboe@kernel.dk>, Jonathan Corbet <corbet@lwn.net>,
        =?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Michal Hocko <mhocko@suse.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Paul Mackerras <paulus@samba.org>,
        Shuah Khan <shuah@kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>, bpf@vger.kernel.org,
        dri-devel@lists.freedesktop.org, kvm@vger.kernel.org,
        linux-block@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-media@vger.kernel.org, linux-rdma@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 07/18] infiniband: set FOLL_PIN, FOLL_LONGTERM via
 pin_longterm_pages*()
Message-ID: <20191104205738.GH30938@ziepe.ca>
References: <20191103211813.213227-1-jhubbard@nvidia.com>
 <20191103211813.213227-8-jhubbard@nvidia.com>
 <20191104203346.GF30938@ziepe.ca>
 <578c1760-7221-4961-9f7d-c07c22e5c259@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <578c1760-7221-4961-9f7d-c07c22e5c259@nvidia.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 04, 2019 at 12:48:13PM -0800, John Hubbard wrote:
> On 11/4/19 12:33 PM, Jason Gunthorpe wrote:
> ...
> >> diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
> >> index 24244a2f68cc..c5a78d3e674b 100644
> >> +++ b/drivers/infiniband/core/umem.c
> >> @@ -272,11 +272,10 @@ struct ib_umem *ib_umem_get(struct ib_udata *udata, unsigned long addr,
> >>  
> >>  	while (npages) {
> >>  		down_read(&mm->mmap_sem);
> >> -		ret = get_user_pages(cur_base,
> >> +		ret = pin_longterm_pages(cur_base,
> >>  				     min_t(unsigned long, npages,
> >>  					   PAGE_SIZE / sizeof (struct page *)),
> >> -				     gup_flags | FOLL_LONGTERM,
> >> -				     page_list, NULL);
> >> +				     gup_flags, page_list, NULL);
> > 
> > FWIW, this one should be converted to fast as well, I think we finally
> > got rid of all the blockers for that?
> > 
> 
> I'm not aware of any blockers on the gup.c end, anyway. The only broken thing we
> have there is "gup remote + FOLL_LONGTERM". But we can do "gup fast + LONGTERM". 

I mean the use of the mmap_sem here is finally in a way where we can
just delete the mmap_sem and use _fast
 
ie, AFAIK there is no need for the mmap_sem to be held during
ib_umem_add_sg_table()

This should probably be a standalone patch however

Jason
