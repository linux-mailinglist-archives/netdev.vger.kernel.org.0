Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCE27F9E47
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 00:42:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbfKLXmy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 18:42:54 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:33417 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727041AbfKLXmx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 18:42:53 -0500
Received: by mail-qt1-f194.google.com with SMTP id y39so522701qty.0
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 15:42:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=vZiC7XI6w4qmcJhiszw5fcLLfKl81FBqJhCu/q1OZew=;
        b=it8jHl8Aeod0zYq+Skrwrg8GwHh9Iu8Lk4aklL2UU1A7NrkgqGz5TacHTvuZENKCSO
         zX5vQsxL6WoNuMWNKkEQjxDubFJia3lLQ6vtybpi5bU815x8TqvUIIt9Kr2Uo5cBSRzI
         2VZYj93gQX0itc+geQUWbcwpbx7dsR+jspiqHjxUKDMEHdunGEQMz6R4qhshIz6xtcbf
         Zhwk9IxmoxlDCj68H/K3Yi1WAV8gDwI3vnoSzzJ5OjxNZ+oTEONNaXk9owbEXpdua0Ac
         Ytg9ljas4ej2TjoNx1nr1x9pd15vss2zsUb9mCqXq0UcPC7FIXHufZoDuL/IWSFTzLDE
         UAww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=vZiC7XI6w4qmcJhiszw5fcLLfKl81FBqJhCu/q1OZew=;
        b=Sy/ip84VykTfXGCdiKUjNOMPq+EwIWB0rp0lUzLzbEtymDHCl92fF7G2P6YBQOP/n0
         jbOXtmGEpBajnpb/1wwH6EUs3kBlntVXKwQYFI1Sf4YL02BTwzg1wpQzkCocm9Ki7THo
         7adcRlXOcwd6sTSnbFv+kdBByZEy66zdbVZGWNGsR0kGWBbxDdZIAsegK9PU83HQri1f
         IUB4187G0a77OmvxEcl+VWxagbkTcuGPUpx6TM3vMwjqzfrAkurN+4ixMnorpJDo4/GU
         MVOkgCCOhA/RYFnDJP+EQUGef6fZjreKR7ZIAo8wpDHJ3aQDx5PgjjqWZ40DLrVEJXVv
         JNBA==
X-Gm-Message-State: APjAAAUVyxJHFFrtMNTQSob+9gjg2/XhqqRr6ufNK30ZMVPL7MFF81tO
        Kxeszhdaog1oh42Tqdzp0y8E2w==
X-Google-Smtp-Source: APXvYqz3aftIVfOw8Wxd6a6UdmY0tmO8rvvaAb/aUmwkho+fgsveWFsBhLgURBNyxpICpzEXHNU+vQ==
X-Received: by 2002:aed:26e2:: with SMTP id q89mr18576100qtd.391.1573602171951;
        Tue, 12 Nov 2019 15:42:51 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-113-180.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.180])
        by smtp.gmail.com with ESMTPSA id u11sm212203qtg.11.2019.11.12.15.42.51
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 12 Nov 2019 15:42:51 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1iUfoA-0005Um-OB; Tue, 12 Nov 2019 19:42:50 -0400
Date:   Tue, 12 Nov 2019 19:42:50 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     John Hubbard <jhubbard@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alex Williamson <alex.williamson@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
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
        Maling list - DRI developers 
        <dri-devel@lists.freedesktop.org>, KVM list <kvm@vger.kernel.org>,
        linux-block@vger.kernel.org,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kselftest@vger.kernel.org,
        "Linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Netdev <netdev@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 08/23] vfio, mm: fix get_user_pages_remote() and
 FOLL_LONGTERM
Message-ID: <20191112234250.GA19615@ziepe.ca>
References: <20191112000700.3455038-1-jhubbard@nvidia.com>
 <20191112000700.3455038-9-jhubbard@nvidia.com>
 <20191112204338.GE5584@ziepe.ca>
 <0db36e86-b779-01af-77e7-469af2a2e19c@nvidia.com>
 <CAPcyv4hAEgw6ySNS+EFRS4yNRVGz9A3Fu1vOk=XtpjYC64kQJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4hAEgw6ySNS+EFRS4yNRVGz9A3Fu1vOk=XtpjYC64kQJw@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 12, 2019 at 02:45:51PM -0800, Dan Williams wrote:
> On Tue, Nov 12, 2019 at 2:43 PM John Hubbard <jhubbard@nvidia.com> wrote:
> >
> > On 11/12/19 12:43 PM, Jason Gunthorpe wrote:
> > ...
> > >> -            }
> > >> +    ret = get_user_pages_remote(NULL, mm, vaddr, 1, flags | FOLL_LONGTERM,
> > >> +                                page, vmas, NULL);
> > >> +    /*
> > >> +     * The lifetime of a vaddr_get_pfn() page pin is
> > >> +     * userspace-controlled. In the fs-dax case this could
> > >> +     * lead to indefinite stalls in filesystem operations.
> > >> +     * Disallow attempts to pin fs-dax pages via this
> > >> +     * interface.
> > >> +     */
> > >> +    if (ret > 0 && vma_is_fsdax(vmas[0])) {
> > >> +            ret = -EOPNOTSUPP;
> > >> +            put_page(page[0]);
> > >>      }
> > >
> > > AFAIK this chunk is redundant now as it is some hack to emulate
> > > FOLL_LONGTERM? So vmas can be deleted too.
> >
> > Let me first make sure I understand what Dan has in mind for the vma
> > checking, in the other thread...
> 
> It's not redundant relative to upstream which does not do anything the
> FOLL_LONGTERM in the gup-slow path... but I have not looked at patches
> 1-7 to see if something there made it redundant.

Oh, the hunk John had below for get_user_pages_remote() also needs to
call __gup_longterm_locked() when FOLL_LONGTERM is specified, then
that calls check_dax_vmas() which duplicates the vma_is_fsdax() check
above.

Certainly no caller of FOLL_LONGTERM should have to do dax specific
VMA checking.

Jason
