Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15E766231D3
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 18:48:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231183AbiKIRsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 12:48:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231133AbiKIRsh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 12:48:37 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D44126119
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 09:47:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668016047;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=t/Kh42tMKfFvo4S/QFU8eolDVeSpitIJIiOT5FWjq3s=;
        b=eQF8ThcYggio4aSmCJfa3bMT85GKto0/9Rjyv5oSYWLvBYGEsplnGILvmXz0i+k7l39ikn
        zgm4WOcfETsVewWUT1Czo25EgTJNpSbdjK2zpq+90X9H8YZ4QkfqBIhhDXjsw0InsZC6gv
        kBlBs25v6GVenjRF7TKsJ/gEYi6Xxso=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-149-H1NEhH-MOWCYbkATSDUuRg-1; Wed, 09 Nov 2022 12:47:26 -0500
X-MC-Unique: H1NEhH-MOWCYbkATSDUuRg-1
Received: by mail-qt1-f199.google.com with SMTP id cm12-20020a05622a250c00b003a521f66e8eso13038625qtb.17
        for <netdev@vger.kernel.org>; Wed, 09 Nov 2022 09:47:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t/Kh42tMKfFvo4S/QFU8eolDVeSpitIJIiOT5FWjq3s=;
        b=E/NT6n5xLsx5nXqRbbjo/wvw+YdQac9eGPFwRb0+gM6hvBFrgrtRdK5aHx5q3mHj90
         ylsX7lEoKXKbMyC4gVhj/WKtW6krGo+X8+huBvGDJXOnvQNAt1tHiXK9WfBrcV/zcQXv
         e3MNpEOzR0+P1HoqKZVnBEqbxcaMYCkLayc5NTKB/udyaVLIF8vom2sVaeyGcIp3k5N/
         bNz2f8KWk1K9xARcuJAcIGbDQjH0ylk37yYojYQPXrDNEJeiN9hgjPUMSK5JmpULshsP
         vcEl/0l/JHMivD8i+U2kFxEygJxZXmm82QcWCgjVitHC25CbaIPrI5wuT+EQyRbFXW8O
         UCoA==
X-Gm-Message-State: ACrzQf3RduIxnBkHFeQfDJ9R9nRWQ04bO5LoMonQ1Om4F4/QP840UEgO
        d3EpjpKRZbl2AUeizeby3wevlhOuh9asA6Pth8GszpzASg09Ywt8k5yEM5r4FvN/RYMtvvbNep7
        n4TDQVMJme3ThFa6X
X-Received: by 2002:a05:6214:19e3:b0:4b6:8a99:3054 with SMTP id q3-20020a05621419e300b004b68a993054mr55096680qvc.108.1668016045398;
        Wed, 09 Nov 2022 09:47:25 -0800 (PST)
X-Google-Smtp-Source: AMsMyM4cIKDmZFid0Kdu9UcncIAXfb+bkR8ZjQnilX9u+j9N1m8IT/D1lrE9WWhovxtcPfHOO2c1+Q==
X-Received: by 2002:a05:6214:19e3:b0:4b6:8a99:3054 with SMTP id q3-20020a05621419e300b004b68a993054mr55096665qvc.108.1668016045154;
        Wed, 09 Nov 2022 09:47:25 -0800 (PST)
Received: from redhat.com ([185.195.59.47])
        by smtp.gmail.com with ESMTPSA id u12-20020a37ab0c000000b006e54251993esm11254690qke.97.2022.11.09.09.47.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 09:47:24 -0800 (PST)
Date:   Wed, 9 Nov 2022 12:47:19 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     virtualization@lists.linux-foundation.org, eperezma@redhat.com,
        netdev@vger.kernel.org, kvm@vger.kernel.org,
        Gautam Dawar <gautam.dawar@xilinx.com>,
        Jason Wang <jasowang@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost-vdpa: fix potential memory leak during the release
Message-ID: <20221109124430-mutt-send-email-mst@kernel.org>
References: <20221109154213.146789-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221109154213.146789-1-sgarzare@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 09, 2022 at 04:42:13PM +0100, Stefano Garzarella wrote:
> Before commit 3d5698793897 ("vhost-vdpa: introduce asid based IOTLB")
> we call vhost_vdpa_iotlb_unmap(v, iotlb, 0ULL, 0ULL - 1) during the
> release to free all the resources allocated when processing user IOTLB
> messages through vhost_vdpa_process_iotlb_update().
> That commit changed the handling of IOTLB a bit, and we accidentally
> removed some code called during the release.
> 
> We partially fixed with commit 037d4305569a ("vhost-vdpa: call
> vhost_vdpa_cleanup during the release") but a potential memory leak is
> still there as showed by kmemleak if the application does not send
> VHOST_IOTLB_INVALIDATE or crashes:
> 
>   unreferenced object 0xffff888007fbaa30 (size 16):
>     comm "blkio-bench", pid 914, jiffies 4294993521 (age 885.500s)
>     hex dump (first 16 bytes):
>       40 73 41 07 80 88 ff ff 00 00 00 00 00 00 00 00  @sA.............
>     backtrace:
>       [<0000000087736d2a>] kmem_cache_alloc_trace+0x142/0x1c0
>       [<0000000060740f50>] vhost_vdpa_process_iotlb_msg+0x68c/0x901 [vhost_vdpa]
>       [<0000000083e8e205>] vhost_chr_write_iter+0xc0/0x4a0 [vhost]
>       [<000000008f2f414a>] vhost_vdpa_chr_write_iter+0x18/0x20 [vhost_vdpa]
>       [<00000000de1cd4a0>] vfs_write+0x216/0x4b0
>       [<00000000a2850200>] ksys_write+0x71/0xf0
>       [<00000000de8e720b>] __x64_sys_write+0x19/0x20
>       [<0000000018b12cbb>] do_syscall_64+0x3f/0x90
>       [<00000000986ec465>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> Let's fix calling vhost_vdpa_iotlb_unmap() on the whole range in
> vhost_vdpa_remove_as(). We move that call before vhost_dev_cleanup()
> since we need a valid v->vdev.mm in vhost_vdpa_pa_unmap().
> vhost_iotlb_reset() call can be removed, since vhost_vdpa_iotlb_unmap()
> on the whole range removes all the entries.
> 
> The kmemleak log reported was observed with a vDPA device that has `use_va`
> set to true (e.g. VDUSE). This patch has been tested with both types of
> devices.
> 
> Fixes: 037d4305569a ("vhost-vdpa: call vhost_vdpa_cleanup during the release")
> Fixes: 3d5698793897 ("vhost-vdpa: introduce asid based IOTLB")
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>

It's fine, just pls don't say "potential" here in the subject, let's
avoid pleonasms - it's a memory leak, yes it triggers under some coditions
but little is unconditional in this world :)

No need to repost.

> ---
>  drivers/vhost/vdpa.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 166044642fd5..b08e07fc7d1f 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -65,6 +65,10 @@ static DEFINE_IDA(vhost_vdpa_ida);
>  
>  static dev_t vhost_vdpa_major;
>  
> +static void vhost_vdpa_iotlb_unmap(struct vhost_vdpa *v,
> +				   struct vhost_iotlb *iotlb,
> +				   u64 start, u64 last);
> +
>  static inline u32 iotlb_to_asid(struct vhost_iotlb *iotlb)
>  {
>  	struct vhost_vdpa_as *as = container_of(iotlb, struct
> @@ -135,7 +139,7 @@ static int vhost_vdpa_remove_as(struct vhost_vdpa *v, u32 asid)
>  		return -EINVAL;
>  
>  	hlist_del(&as->hash_link);
> -	vhost_iotlb_reset(&as->iotlb);
> +	vhost_vdpa_iotlb_unmap(v, &as->iotlb, 0ULL, 0ULL - 1);
>  	kfree(as);
>  
>  	return 0;
> @@ -1162,14 +1166,14 @@ static void vhost_vdpa_cleanup(struct vhost_vdpa *v)
>  	struct vhost_vdpa_as *as;
>  	u32 asid;
>  
> -	vhost_dev_cleanup(&v->vdev);
> -	kfree(v->vdev.vqs);
> -
>  	for (asid = 0; asid < v->vdpa->nas; asid++) {
>  		as = asid_to_as(v, asid);
>  		if (as)
>  			vhost_vdpa_remove_as(v, asid);
>  	}
> +
> +	vhost_dev_cleanup(&v->vdev);
> +	kfree(v->vdev.vqs);
>  }
>  
>  static int vhost_vdpa_open(struct inode *inode, struct file *filep)
> -- 
> 2.38.1

