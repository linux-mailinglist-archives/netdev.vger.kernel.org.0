Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1504F9B0B
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 21:45:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727223AbfKLUow (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 15:44:52 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:38889 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727016AbfKLUov (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 15:44:51 -0500
Received: by mail-qt1-f195.google.com with SMTP id p20so21321022qtq.5
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 12:44:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=XIC1APSxWrFcW1GblyShF0CTBN3WBCz4HlbvzX3i8nA=;
        b=AsvHvDs3axCMUqe+N7mXppqZcG4z4QzjW7DgwuxQQSvowjzw09zSM8n30iqPxyhiVG
         Xh8VyKwma0MzyaZ4I7in3iXleDEuEusIaoOY6nDlenNeAk67Wg5jNcvcitJtB14ouZSU
         jEwtlMvkVKE/9wAQOETCpzIOvdkPz6MUeIKWQaYMSrFJbWX7VcVwtA5CNXlEKm0VsyqY
         ifzvXwANYm60xkTRX8oLmVVhv+FGDqeTm28/AUUM6Qiw102m5SB7HZ3RG7baH2DiI3v+
         pcZdlJkq9BzOBgC+D5ynKGUuwhq6rk47T2j6RjHfuuaJ84S/d0bRcfAl5P4tkZR1pUiM
         WWGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=XIC1APSxWrFcW1GblyShF0CTBN3WBCz4HlbvzX3i8nA=;
        b=YH1ekQ6kDLQ0EX01lST43vge/2CKKraECR547F5P9akG3t72oCHRkGZD6V7WEH0EW+
         NKb1tJuW9EFLJErKWC8NnmGMAznW7Nn0vWXTpOVDyS8fP80tgpYRBIC4/8RTDzFjoUwy
         i20wn3RlsyDJM61BvAyGdP+J2D12nEPDh2Q41NgNmxkw5ke28env08x+nM7GQqB4IZ+p
         o0GCE560kVZZT41Z7BJm+x7J+5ny0EXqqnz7EeW0VfSyV8SXoGQKLdmTIXrmhfIspfcS
         EHCobuDvi7i40a/w5bdHJIRteu5cGrdv3MbYLhlWqvOtPplvhIfzu/MMW0ynphDTCci4
         dREA==
X-Gm-Message-State: APjAAAWyoWsDd8JlExt2alD9jcfgaCwZ+a8rRORFNuCjJPj8NPeePjFB
        xH0ZUO+iPBEZ6NN2trr2dqL0qQ==
X-Google-Smtp-Source: APXvYqxT1AevYU83mBSAAzVL5cKCr9RO3QTTsZEZsQx1j+Xe2+nGL/UnUh0Po7qNt16fHJ031L5RZg==
X-Received: by 2002:ac8:6641:: with SMTP id j1mr34362241qtp.48.1573591490500;
        Tue, 12 Nov 2019 12:44:50 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-113-180.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.180])
        by smtp.gmail.com with ESMTPSA id u67sm4906223qkf.115.2019.11.12.12.44.49
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 12 Nov 2019 12:44:49 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1iUd1t-00047P-Dy; Tue, 12 Nov 2019 16:44:49 -0400
Date:   Tue, 12 Nov 2019 16:44:49 -0400
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
Subject: Re: [PATCH v3 11/23] IB/{core,hw,umem}: set FOLL_PIN, FOLL_LONGTERM
 via pin_longterm_pages*()
Message-ID: <20191112204449.GF5584@ziepe.ca>
References: <20191112000700.3455038-1-jhubbard@nvidia.com>
 <20191112000700.3455038-12-jhubbard@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191112000700.3455038-12-jhubbard@nvidia.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 11, 2019 at 04:06:48PM -0800, John Hubbard wrote:
> @@ -542,7 +541,7 @@ static int ib_umem_odp_map_dma_single_page(
>  	}
>  
>  out:
> -	put_user_page(page);
> +	put_page(page);
>  
>  	if (remove_existing_mapping) {
>  		ib_umem_notifier_start_account(umem_odp);
> @@ -639,13 +638,14 @@ int ib_umem_odp_map_dma_pages(struct ib_umem_odp *umem_odp, u64 user_virt,
>  		/*
>  		 * Note: this might result in redundent page getting. We can
>  		 * avoid this by checking dma_list to be 0 before calling
> -		 * get_user_pages. However, this make the code much more
> -		 * complex (and doesn't gain us much performance in most use
> -		 * cases).
> +		 * get_user_pages. However, this makes the code much
> +		 * more complex (and doesn't gain us much performance in most
> +		 * use cases).
>  		 */
>  		npages = get_user_pages_remote(owning_process, owning_mm,
> -				user_virt, gup_num_pages,
> -				flags, local_page_list, NULL, NULL);
> +					       user_virt, gup_num_pages,
> +					       flags, local_page_list, NULL,
> +					       NULL);
>  		up_read(&owning_mm->mmap_sem);

This is just whitespace churn? Drop it..

Jason
