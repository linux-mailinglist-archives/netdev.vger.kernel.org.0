Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2142E1EB43D
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 06:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726185AbgFBEWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 00:22:37 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:36894 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725872AbgFBEWg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 00:22:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591071755;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YDfsRlwfRR1nDcp4wd5hK1KujxFVRibBNSbBOaOrz2Q=;
        b=X8FnC/x9SCa5vJY15Os/NgB6nawcFpKJaDXreIB8m84EPDlTy9XHLAWv/Zny3K0FHi4Nb3
        8LdpUU/8m/eOLIxkEiiX9UFoTyhOTFaK/KJFTZMPWNZ3Let1L3FvT3iSJVQSnPTVqcc4R7
        i1c1lgV4k52xxGtwe+/HGiSPJXPtk+c=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-461-pFuGCqgmPKmgHWJT6iELXQ-1; Tue, 02 Jun 2020 00:22:30 -0400
X-MC-Unique: pFuGCqgmPKmgHWJT6iELXQ-1
Received: by mail-wr1-f72.google.com with SMTP id e7so851413wrp.14
        for <netdev@vger.kernel.org>; Mon, 01 Jun 2020 21:22:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YDfsRlwfRR1nDcp4wd5hK1KujxFVRibBNSbBOaOrz2Q=;
        b=gZ22/qTRZKDwRP9WMSjeVofe4MXQgUQXBKbux6Y++kmfd717b2wqeZAFTKoEfD/JAI
         f3XRkeahvX9dHkIXHXnchx635DkSStB8uHMRvdjzuQP90tcwnUW05iQqQtID2YS/atvK
         rLfOTa2i1vA+XFERlbgcdh2R55pywKOSJ5yfu1zgwCo6yddU9uzJsWRRuO3WsD251tsL
         SZm7u2dd9E5L70uBR+9My0lvikarDybKe/V2oyByj1Ictx6AJQEdV11aO0TwH5N2mafa
         tQe/9LjeEVfJ6vQLFwAWzywOmIEDTxSqXZBws3HP3xd7qpqWpgbPlHLTBdXKohGf5XQ1
         G6sg==
X-Gm-Message-State: AOAM530CCnAI42ASDV1vSvPm/vdpGD3QXjULfW7CAya7aTGcIPzLQy8G
        d4sv7HG7W7GLJ2Itu2tipOhMOaKUS723/mWt83y0IRfq6g9AZjbZbVBEsjlo4w7kqyOTGOyplFh
        QI/vNisiz5QsNWDc8
X-Received: by 2002:a05:6000:1083:: with SMTP id y3mr23714184wrw.425.1591071749222;
        Mon, 01 Jun 2020 21:22:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx2SKrCnIib4b4OHp9esqIfnn8bX4FrOHyf8lEFnkhypfH/4sW2rsrN9doierFMkcN8evfSkA==
X-Received: by 2002:a05:6000:1083:: with SMTP id y3mr23714174wrw.425.1591071749030;
        Mon, 01 Jun 2020 21:22:29 -0700 (PDT)
Received: from redhat.com (bzq-109-64-41-91.red.bezeqint.net. [109.64.41.91])
        by smtp.gmail.com with ESMTPSA id z2sm1731263wrs.87.2020.06.01.21.22.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2020 21:22:28 -0700 (PDT)
Date:   Tue, 2 Jun 2020 00:22:25 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     John Hubbard <jhubbard@nvidia.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Jason Wang <jasowang@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
        Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        Souptick Joarder <jrdr.linux@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH 2/2] vhost: convert get_user_pages() --> pin_user_pages()
Message-ID: <20200602002212-mutt-send-email-mst@kernel.org>
References: <20200529234309.484480-1-jhubbard@nvidia.com>
 <20200529234309.484480-3-jhubbard@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200529234309.484480-3-jhubbard@nvidia.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 29, 2020 at 04:43:09PM -0700, John Hubbard wrote:
> This code was using get_user_pages*(), in approximately a "Case 5"
> scenario (accessing the data within a page), using the categorization
> from [1]. That means that it's time to convert the get_user_pages*() +
> put_page() calls to pin_user_pages*() + unpin_user_pages() calls.
> 
> There is some helpful background in [2]: basically, this is a small
> part of fixing a long-standing disconnect between pinning pages, and
> file systems' use of those pages.
> 
> [1] Documentation/core-api/pin_user_pages.rst
> 
> [2] "Explicit pinning of user-space pages":
>     https://lwn.net/Articles/807108/
> 
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: kvm@vger.kernel.org
> Cc: virtualization@lists.linux-foundation.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
>  drivers/vhost/vhost.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 21a59b598ed8..596132a96cd5 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -1762,15 +1762,14 @@ static int set_bit_to_user(int nr, void __user *addr)
>  	int bit = nr + (log % PAGE_SIZE) * 8;
>  	int r;
>  
> -	r = get_user_pages_fast(log, 1, FOLL_WRITE, &page);
> +	r = pin_user_pages_fast(log, 1, FOLL_WRITE, &page);
>  	if (r < 0)
>  		return r;
>  	BUG_ON(r != 1);
>  	base = kmap_atomic(page);
>  	set_bit(bit, base);
>  	kunmap_atomic(base);
> -	set_page_dirty_lock(page);
> -	put_page(page);
> +	unpin_user_pages_dirty_lock(&page, 1, true);
>  	return 0;
>  }
>  
> -- 
> 2.26.2

