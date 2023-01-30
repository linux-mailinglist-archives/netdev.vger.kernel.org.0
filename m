Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D392D6814B3
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 16:19:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238106AbjA3PTt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 10:19:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238160AbjA3PTl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 10:19:41 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D736D3D0B3
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 07:18:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675091891;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=URESPY8B3rO6+zudqQ9a2I8Kc4P4ekxUO74igKr3Ygk=;
        b=GzSUktuLiu6L3PNAaV4XZt75Ws7Dmnv9PQDjfA3x5vkyjSNSii1VtBo4YsjVJCE/jfiHNn
        avwG77EF3Q3sKFyQ8OMzaX0XKVEvlED1sWZpoAKF8JNg3SysxRDcGg+A9PPmntSNjNQS1/
        nFXejVbRyxTXEcwlWRWR+bRA6HYYyS8=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-646-PA5edi2pN4uHliVBNJyfHw-1; Mon, 30 Jan 2023 10:18:07 -0500
X-MC-Unique: PA5edi2pN4uHliVBNJyfHw-1
Received: by mail-wm1-f69.google.com with SMTP id j24-20020a05600c1c1800b003dc4480f7bdso4666383wms.5
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 07:18:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=URESPY8B3rO6+zudqQ9a2I8Kc4P4ekxUO74igKr3Ygk=;
        b=XKiMQW9JjqpblRNZr+8pj+8mlcsxl1hCI7WmQNo1wuCfd8PiuNfTGbeK+Xm9JjUuSR
         ZLB4ZIxTQMFq7jZGKiTPFKhnqjkAbJjZn76SfQPtWbbjyyma2GgPJxMdFDYybgfSMj71
         O98sa9io7PJdbDU3rBZa7vNhBbzEGwNbB5fD5y1q59YKnbdUeD+BUZDBbRk4bxpQs+jc
         ue0/6KVCFKazrt/9CkOJxqyA6cN0sg7DT1ejDeyufT6JAuP9amnqHNqZjX285HfDMCUc
         foW3jroZ+nrwvfdgSg4G0GYdtfmXyLjlPW5dXolJgIKi8EViBV3oH7SyHJkv88g4uYLS
         Vuqg==
X-Gm-Message-State: AO0yUKXmdPI0+aCjQKAVt/P0k67Hna9KKQExxzyNT/iKRKzLt4OSWSzP
        7rs4wUkCuz83eF10hvHSVgNT2QyqCx3kRF4oaFZUU+DxdyBgwDYAuzfsAClMaGGZHyM1QzSl72v
        9LWfkgTHgSPsjZdeT
X-Received: by 2002:a05:6000:1105:b0:2bf:b77c:df72 with SMTP id z5-20020a056000110500b002bfb77cdf72mr16512194wrw.25.1675091885643;
        Mon, 30 Jan 2023 07:18:05 -0800 (PST)
X-Google-Smtp-Source: AK7set9hHGYe0bnBQdwa2LZ/rAVCRbopEtGk+crtv3OHnMIQTfwimU+PtBLrc1/FzlqOKTq9Gtug2w==
X-Received: by 2002:a05:6000:1105:b0:2bf:b77c:df72 with SMTP id z5-20020a056000110500b002bfb77cdf72mr16512171wrw.25.1675091885371;
        Mon, 30 Jan 2023 07:18:05 -0800 (PST)
Received: from redhat.com ([2.52.144.173])
        by smtp.gmail.com with ESMTPSA id p6-20020a5d48c6000000b002bfc0558ecdsm11985935wrs.113.2023.01.30.07.18.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 07:18:04 -0800 (PST)
Date:   Mon, 30 Jan 2023 10:17:58 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Ilya Dryomov <idryomov@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        Minchan Kim <minchan@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        Xiubo Li <xiubli@redhat.com>, Steve French <sfrench@samba.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>,
        Mike Marshall <hubcap@omnibond.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        linux-block@vger.kernel.org, ceph-devel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        devel@lists.orangefs.org, io-uring@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 09/23] virtio_blk: use bvec_set_virt to initialize
 special_vec
Message-ID: <20230130101747-mutt-send-email-mst@kernel.org>
References: <20230130092157.1759539-1-hch@lst.de>
 <20230130092157.1759539-10-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230130092157.1759539-10-hch@lst.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 30, 2023 at 10:21:43AM +0100, Christoph Hellwig wrote:
> Use the bvec_set_virt helper to initialize the special_vec.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Michael S. Tsirkin <mst@redhat.com>


> ---
>  drivers/block/virtio_blk.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> index 6a77fa91742880..dc6e9b989910b0 100644
> --- a/drivers/block/virtio_blk.c
> +++ b/drivers/block/virtio_blk.c
> @@ -170,9 +170,7 @@ static int virtblk_setup_discard_write_zeroes_erase(struct request *req, bool un
>  
>  	WARN_ON_ONCE(n != segments);
>  
> -	req->special_vec.bv_page = virt_to_page(range);
> -	req->special_vec.bv_offset = offset_in_page(range);
> -	req->special_vec.bv_len = sizeof(*range) * segments;
> +	bvec_set_virt(&req->special_vec, range, sizeof(*range) * segments);
>  	req->rq_flags |= RQF_SPECIAL_PAYLOAD;
>  
>  	return 0;
> -- 
> 2.39.0

