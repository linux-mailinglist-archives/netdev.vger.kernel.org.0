Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37307EE530
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 17:52:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729312AbfKDQwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 11:52:42 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:38805 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729006AbfKDQwh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 11:52:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572886356;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6ta56jBRT26o2oAigonInJcC04rruT/2d6fabGOKHyw=;
        b=WSLa2wKrL8g5aDyoDf02O4k+crqcoTXsQ2EKqq2n6FzaTjqceXHOvCayOCIR1bb5K9cevY
        4X65fFvcBOCVsRohJoclItex595rU3tYdNhZDQ5rVUFYp7EKSwdA9oE4gxRYhiG3A8fEqR
        fFQB7XsZgwY/SgZNM9uNmH3+34EtSUE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-285-9yNyzIkfPeqtWSV5Ovvavg-1; Mon, 04 Nov 2019 11:52:32 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8FC0C800C73;
        Mon,  4 Nov 2019 16:52:28 +0000 (UTC)
Received: from redhat.com (unknown [10.20.6.178])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3A10B5C1B2;
        Mon,  4 Nov 2019 16:52:23 +0000 (UTC)
Date:   Mon, 4 Nov 2019 11:52:21 -0500
From:   Jerome Glisse <jglisse@redhat.com>
To:     John Hubbard <jhubbard@nvidia.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alex Williamson <alex.williamson@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dave Chinner <david@fromorbit.com>,
        David Airlie <airlied@linux.ie>,
        "David S . Miller" <davem@davemloft.net>,
        Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        Jonathan Corbet <corbet@lwn.net>,
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
Subject: Re: [PATCH v2 03/18] goldish_pipe: rename local pin_user_pages()
 routine
Message-ID: <20191104165221.GC5134@redhat.com>
References: <20191103211813.213227-1-jhubbard@nvidia.com>
 <20191103211813.213227-4-jhubbard@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <20191103211813.213227-4-jhubbard@nvidia.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: 9yNyzIkfPeqtWSV5Ovvavg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 03, 2019 at 01:17:58PM -0800, John Hubbard wrote:
> 1. Avoid naming conflicts: rename local static function from
> "pin_user_pages()" to "pin_goldfish_pages()".
>=20
> An upcoming patch will introduce a global pin_user_pages()
> function.
>=20
> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>

Reviewed-by: J=E9r=F4me Glisse <jglisse@redhat.com>

> ---
>  drivers/platform/goldfish/goldfish_pipe.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
>=20
> diff --git a/drivers/platform/goldfish/goldfish_pipe.c b/drivers/platform=
/goldfish/goldfish_pipe.c
> index cef0133aa47a..7ed2a21a0bac 100644
> --- a/drivers/platform/goldfish/goldfish_pipe.c
> +++ b/drivers/platform/goldfish/goldfish_pipe.c
> @@ -257,12 +257,12 @@ static int goldfish_pipe_error_convert(int status)
>  =09}
>  }
> =20
> -static int pin_user_pages(unsigned long first_page,
> -=09=09=09  unsigned long last_page,
> -=09=09=09  unsigned int last_page_size,
> -=09=09=09  int is_write,
> -=09=09=09  struct page *pages[MAX_BUFFERS_PER_COMMAND],
> -=09=09=09  unsigned int *iter_last_page_size)
> +static int pin_goldfish_pages(unsigned long first_page,
> +=09=09=09      unsigned long last_page,
> +=09=09=09      unsigned int last_page_size,
> +=09=09=09      int is_write,
> +=09=09=09      struct page *pages[MAX_BUFFERS_PER_COMMAND],
> +=09=09=09      unsigned int *iter_last_page_size)
>  {
>  =09int ret;
>  =09int requested_pages =3D ((last_page - first_page) >> PAGE_SHIFT) + 1;
> @@ -354,9 +354,9 @@ static int transfer_max_buffers(struct goldfish_pipe =
*pipe,
>  =09if (mutex_lock_interruptible(&pipe->lock))
>  =09=09return -ERESTARTSYS;
> =20
> -=09pages_count =3D pin_user_pages(first_page, last_page,
> -=09=09=09=09     last_page_size, is_write,
> -=09=09=09=09     pipe->pages, &iter_last_page_size);
> +=09pages_count =3D pin_goldfish_pages(first_page, last_page,
> +=09=09=09=09=09 last_page_size, is_write,
> +=09=09=09=09=09 pipe->pages, &iter_last_page_size);
>  =09if (pages_count < 0) {
>  =09=09mutex_unlock(&pipe->lock);
>  =09=09return pages_count;
> --=20
> 2.23.0
>=20

