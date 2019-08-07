Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA338846CE
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 10:07:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387617AbfHGIHU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 04:07:20 -0400
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:35635 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727413AbfHGIHS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 04:07:18 -0400
Received: from [IPv6:2001:983:e9a7:1:8cc6:9015:1548:23f3] ([IPv6:2001:983:e9a7:1:8cc6:9015:1548:23f3])
        by smtp-cloud9.xs4all.net with ESMTPA
        id vGyNhjeHgAffAvGyOh7CoE; Wed, 07 Aug 2019 10:07:15 +0200
Subject: Re: [PATCH v3 11/41] media/v4l2-core/mm: convert put_page() to
 put_user_page*()
To:     john.hubbard@gmail.com, Andrew Morton <akpm@linux-foundation.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Chinner <david@fromorbit.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        amd-gfx@lists.freedesktop.org, ceph-devel@vger.kernel.org,
        devel@driverdev.osuosl.org, devel@lists.orangefs.org,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-block@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linux-nfs@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org, linux-xfs@vger.kernel.org,
        netdev@vger.kernel.org, rds-devel@oss.oracle.com,
        sparclinux@vger.kernel.org, x86@kernel.org,
        xen-devel@lists.xenproject.org, John Hubbard <jhubbard@nvidia.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Souptick Joarder <jrdr.linux@gmail.com>
References: <20190807013340.9706-1-jhubbard@nvidia.com>
 <20190807013340.9706-12-jhubbard@nvidia.com>
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
Message-ID: <8a02b10a-507b-2eb3-19aa-1cb498c1a4af@xs4all.nl>
Date:   Wed, 7 Aug 2019 10:07:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190807013340.9706-12-jhubbard@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfLtFI4ThDBFuoSwFqT380PxkcC6q3XCYC9HO7bxya62SPesHUoWCzd0ksBMTGkppOn75d+WBKCLiUJL1JCKKzueS8vA20zMfsb357SuvaUy4TtJTFapt
 x/bWCTcScAJNoSAViYa6NSlEx2FKBMG1ub01wuczTnbJurUSOB+vxv+m9yWKJM94dHdvARuWMkXZdmUldHpi22HuFtGEBhfQsDY52cLv9SRNbWMy30DrEJ0t
 IZpNWziFzZ3evJ7mzLCVhbiK2kiOOXAk37J1rrkYGH2YtOIVmpGPTJw+iPQnS41ERf+BCjbaTp9dtSr4qdKvpCtCTPfnpCYMb9QEG7YIv4Bkl6jCBTx7G7/4
 E+/Gcs1gOswCkbsVZkXHiYav454A3NZryrYeXwugbZcaQXzdLwQKX8vixuVBgbqFmyjLnuKfL1+c17HvE7YGvrxNLgEJHTveu7qGFUgiDp8Kxm2qaSU6Ln+T
 ElUIz8bygLmP/ZaLM0W02XHdcvoF3n3t59CNY87n3tR3oXUf8LBXliPMUlUaTsd4sTe3FnbfHAUNwVeklfrjO7mwx/ZtuvdypniGohclf+1bp5fAUTyCCCrQ
 2HyNedUvC2lDdYTRuhJr04fafwrpC9JLhSLKJeMRBVwa4n0gqjUnzFBrEoDnP692PfkgpqcUzLJ3ou9bn9SXymgnoZ/su+Qto3UpDDWJiMsSJM83gtLeDDPU
 2LAMy4jSsugrfD7VC1dmYwzG8OWIPHuvJ7Tu8XU7oActSpAZS3c9skTdMjLehhV+5MHeC8g3tQLGrW2WL0nM2XSwHbo4mwTDcXTASOqE5niPTgs0jd+PPxdD
 6xGBJo3u/QbyQ3ajYSHTR7/iYO7MKvqve0YwbtTNR57pWM38fmVObjBWJ2Qb5+GQ3v2MdIxvVfz42j69SfAzoN+qm5pqDcKBwXhfBdG1NM3xlepenmsR9xg5
 62RVbClfekDh1mdFfuyj4KBmVBX0v1np3JjJ4vNebVx2IyoyHonzCgI/VeK3Xg6+xvyxhVW0lz7O9WmdlxWKcql5t0Yb5f0zsKtS1NvNqjdoMQPPDLlgqBkJ
 zSwzmxMfYBhUca00uKQBlssFsG5QNKIC7fFgqtDFBmNtn6ipJvZKRC79Cw4QS6qRNMXKSaUQOSPYCvM4KmrZVW9w5s8hot0TfDYbj+oHiuzjCO1jmdtzXAbt
 gWocxcFwf55hNfAhTODtYnIcQTTBxC/fmKLTijSmU3lfUSSSsnl8ef0xn1zUtoXXnyzz6mcZVljhvITEJx0jnOlTUGnl6EnAeCVrfPoD4WCRmPS4tIKMb0Sn
 DjxDBO/HszoKfvVJZYTfTvPxU+6WAyaIoLGRNQX6ew6/T19LTZ7M+CVC1zczygV1hOTQJzIdJnWdrI7AWTB8dFsFHEUTylMp921VegrittBprwtssRQSETDt
 w+WAy7sK++9/GONtwbizNl49IwU+D0GMpL0NbybeY6J7lGNNM2UtsFttBraN5pO3M9SU3xDoE5SqJiulL8VfDzJKyah60WIfPdhLbN00mLGEveLuRT0YQNVO
 Ve41rvqKpgWWp9HPZO7QwGGi4muzZFJs6F8sgGua1ktJvh99nm3LVZHEV++X5Bous3oUMbzF6ihXBdgtubshPp+ElhOLvWLff7DQNQVzst9h3eqqPREvSJlB
 0+CfDkY+tvaCm6YXmIbg/FxzMGySzi98TfrQYNsvylv4MWX8pxKCyY/xfBN6o8zPRNMJNc0PX0kAdkxIJbJSRls4hOcOInlZ
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/7/19 3:33 AM, john.hubbard@gmail.com wrote:
> From: John Hubbard <jhubbard@nvidia.com>
> 
> For pages that were retained via get_user_pages*(), release those pages
> via the new put_user_page*() routines, instead of via put_page() or
> release_pages().
> 
> This is part a tree-wide conversion, as described in commit fc1d8e7cca2d
> ("mm: introduce put_user_page*(), placeholder versions").
> 
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Robin Murphy <robin.murphy@arm.com>
> Cc: Souptick Joarder <jrdr.linux@gmail.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: linux-media@vger.kernel.org
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>

Acked-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>

> ---
>  drivers/media/v4l2-core/videobuf-dma-sg.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/videobuf-dma-sg.c b/drivers/media/v4l2-core/videobuf-dma-sg.c
> index 66a6c6c236a7..d6eeb437ec19 100644
> --- a/drivers/media/v4l2-core/videobuf-dma-sg.c
> +++ b/drivers/media/v4l2-core/videobuf-dma-sg.c
> @@ -349,8 +349,7 @@ int videobuf_dma_free(struct videobuf_dmabuf *dma)
>  	BUG_ON(dma->sglen);
>  
>  	if (dma->pages) {
> -		for (i = 0; i < dma->nr_pages; i++)
> -			put_page(dma->pages[i]);
> +		put_user_pages(dma->pages, dma->nr_pages);
>  		kfree(dma->pages);
>  		dma->pages = NULL;
>  	}
> 

