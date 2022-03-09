Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD5E4D389E
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 19:21:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235813AbiCISUB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 13:20:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234859AbiCISUA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 13:20:00 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A44F50478
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 10:19:01 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id m11-20020a17090a7f8b00b001beef6143a8so3033825pjl.4
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 10:19:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=b+36kVZ1eH5PrAKCZPHq/6t1l0kSLjZrSsqHo52p/gc=;
        b=YaAM0kKpKNyog0nOM4LpTWfxvQm7eBvZSmTf372GHlXkpbn5Wfh+vAnoVJ64RDuxqO
         o3ji8HtjLIPYxZyh3iPoWAi0ZHCiIjgaPKxSHS7e4+aFV8bm7fY6XfzGY1MsxTOLlDn4
         d6oLZtBuRYyC/QaCRgw0VjP9vbMFblCt0ZTeIOs11T5PCRs/XH01lfT32h+Fg5MsJACT
         IVWqu+V/cnikT6a6J8wgg6wRbL5MS5wmbwxKOt/BgJpiCfHFG5RFrvZ+ELO253RguktB
         VEaIeuorazetYhtnji7l/TL16TYMuuy2og4r3ur66Guy6lMh40xCGZDTR/54bXtRjWWv
         60Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=b+36kVZ1eH5PrAKCZPHq/6t1l0kSLjZrSsqHo52p/gc=;
        b=TsR4BJ2brMRNBNUweL8rWZYXnuTeVqvdDi9vlJx48TsRpPMu3c6Loy8avSzWr1Kf5B
         1rEoW7HCrp56kj5UuAm5VSfnNfmKnknFjYp+yEFoOfuhqAidB/NKtjkfb+bxtDmQOBhd
         n5C+YkMq5fBd8HVNPi3dY4Hlki2BugVDRn1msolWquyKnXIkKE/XN0wMBXssoVwOhxUp
         ycQ1tsAUh3O85CYdRW84qaqu0UmrCLIVRenh+6HQCqHLoZL/sJY/45F+ORZwzZZ1+2JE
         jIFdefspuRiSalWtcJo8+p75VArdFSlRm8pSnjPhcgve+798IB9xbJlyZUC+tfDd0ZTH
         s1+w==
X-Gm-Message-State: AOAM530OwcAhIL4uIXooHQcdI50qFtFrmq+9Egl3DAZyHCv7KguAjsHi
        rE7RmHJAD8O8mqXSsgnaPUwX6w==
X-Google-Smtp-Source: ABdhPJxUJ6DmW4ZhilNw+HZY2kVwYjGWFeIawYHJDlOcnrsGSJmPBnG2yQNz2rWEiRM35qcfGa3+yQ==
X-Received: by 2002:a17:90a:c68c:b0:1bf:a7c9:957a with SMTP id n12-20020a17090ac68c00b001bfa7c9957amr738367pjt.177.1646849940523;
        Wed, 09 Mar 2022 10:19:00 -0800 (PST)
Received: from p14s (S0106889e681aac74.cg.shawcable.net. [68.147.0.187])
        by smtp.gmail.com with ESMTPSA id d2-20020a056a0010c200b004f102a13040sm3834120pfu.19.2022.03.09.10.18.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 10:18:58 -0800 (PST)
Date:   Wed, 9 Mar 2022 11:18:55 -0700
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Jeff Dike <jdike@addtoit.com>,
        Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        Vadim Pasternak <vadimp@nvidia.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        linux-um@lists.infradead.org, platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH v7 18/26] virtio: find_vqs() add arg sizes
Message-ID: <20220309181855.GA1983245@p14s>
References: <20220308123518.33800-1-xuanzhuo@linux.alibaba.com>
 <20220308123518.33800-19-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220308123518.33800-19-xuanzhuo@linux.alibaba.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 08, 2022 at 08:35:10PM +0800, Xuan Zhuo wrote:
> find_vqs() adds a new parameter sizes to specify the size of each vq
> vring.
> 
> 0 means use the maximum size supported by the backend.
> 
> In the split scenario, the meaning of size is the largest size, because
> it may be limited by memory, the virtio core will try a smaller size.
> And the size is power of 2.
> 
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>  arch/um/drivers/virtio_uml.c             |  2 +-
>  drivers/platform/mellanox/mlxbf-tmfifo.c |  3 ++-
>  drivers/remoteproc/remoteproc_virtio.c   |  2 +-

For the remoteproc changes:

Reviewed-by: Mathieu Poirier <mathieu.poirier@linaro.org>

>  drivers/s390/virtio/virtio_ccw.c         |  2 +-
>  drivers/virtio/virtio_mmio.c             |  2 +-
>  drivers/virtio/virtio_pci_common.c       |  2 +-
>  drivers/virtio/virtio_pci_common.h       |  2 +-
>  drivers/virtio/virtio_pci_modern.c       |  5 +++--
>  drivers/virtio/virtio_vdpa.c             |  2 +-
>  include/linux/virtio_config.h            | 11 +++++++----
>  10 files changed, 19 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/um/drivers/virtio_uml.c b/arch/um/drivers/virtio_uml.c
> index ba562d68dc04..055b91ccbe8a 100644
> --- a/arch/um/drivers/virtio_uml.c
> +++ b/arch/um/drivers/virtio_uml.c
> @@ -998,7 +998,7 @@ static struct virtqueue *vu_setup_vq(struct virtio_device *vdev,
>  static int vu_find_vqs(struct virtio_device *vdev, unsigned nvqs,
>  		       struct virtqueue *vqs[], vq_callback_t *callbacks[],
>  		       const char * const names[], const bool *ctx,
> -		       struct irq_affinity *desc)
> +		       struct irq_affinity *desc, u32 sizes[])
>  {
>  	struct virtio_uml_device *vu_dev = to_virtio_uml_device(vdev);
>  	int i, queue_idx = 0, rc;
> diff --git a/drivers/platform/mellanox/mlxbf-tmfifo.c b/drivers/platform/mellanox/mlxbf-tmfifo.c
> index 38800e86ed8a..aea7aa218b22 100644
> --- a/drivers/platform/mellanox/mlxbf-tmfifo.c
> +++ b/drivers/platform/mellanox/mlxbf-tmfifo.c
> @@ -929,7 +929,8 @@ static int mlxbf_tmfifo_virtio_find_vqs(struct virtio_device *vdev,
>  					vq_callback_t *callbacks[],
>  					const char * const names[],
>  					const bool *ctx,
> -					struct irq_affinity *desc)
> +					struct irq_affinity *desc,
> +					u32 sizes[])
>  {
>  	struct mlxbf_tmfifo_vdev *tm_vdev = mlxbf_vdev_to_tmfifo(vdev);
>  	struct mlxbf_tmfifo_vring *vring;
> diff --git a/drivers/remoteproc/remoteproc_virtio.c b/drivers/remoteproc/remoteproc_virtio.c
> index 70ab496d0431..3a167bec5b09 100644
> --- a/drivers/remoteproc/remoteproc_virtio.c
> +++ b/drivers/remoteproc/remoteproc_virtio.c
> @@ -157,7 +157,7 @@ static int rproc_virtio_find_vqs(struct virtio_device *vdev, unsigned int nvqs,
>  				 vq_callback_t *callbacks[],
>  				 const char * const names[],
>  				 const bool * ctx,
> -				 struct irq_affinity *desc)
> +				 struct irq_affinity *desc, u32 sizes[])
>  {
>  	int i, ret, queue_idx = 0;
>  
> diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
> index d35e7a3f7067..b74e08c71534 100644
> --- a/drivers/s390/virtio/virtio_ccw.c
> +++ b/drivers/s390/virtio/virtio_ccw.c
> @@ -632,7 +632,7 @@ static int virtio_ccw_find_vqs(struct virtio_device *vdev, unsigned nvqs,
>  			       vq_callback_t *callbacks[],
>  			       const char * const names[],
>  			       const bool *ctx,
> -			       struct irq_affinity *desc)
> +			       struct irq_affinity *desc, u32 sizes[])
>  {
>  	struct virtio_ccw_device *vcdev = to_vc_device(vdev);
>  	unsigned long *indicatorp = NULL;
> diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
> index a41abc8051b9..55d575f6ef2d 100644
> --- a/drivers/virtio/virtio_mmio.c
> +++ b/drivers/virtio/virtio_mmio.c
> @@ -462,7 +462,7 @@ static int vm_find_vqs(struct virtio_device *vdev, unsigned nvqs,
>  		       vq_callback_t *callbacks[],
>  		       const char * const names[],
>  		       const bool *ctx,
> -		       struct irq_affinity *desc)
> +		       struct irq_affinity *desc, u32 sizes[])
>  {
>  	struct virtio_mmio_device *vm_dev = to_virtio_mmio_device(vdev);
>  	int irq = platform_get_irq(vm_dev->pdev, 0);
> diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_pci_common.c
> index 863d3a8a0956..8e8fa7e5ad80 100644
> --- a/drivers/virtio/virtio_pci_common.c
> +++ b/drivers/virtio/virtio_pci_common.c
> @@ -428,7 +428,7 @@ static int vp_find_vqs_intx(struct virtio_device *vdev, unsigned nvqs,
>  int vp_find_vqs(struct virtio_device *vdev, unsigned nvqs,
>  		struct virtqueue *vqs[], vq_callback_t *callbacks[],
>  		const char * const names[], const bool *ctx,
> -		struct irq_affinity *desc)
> +		struct irq_affinity *desc, u32 sizes[])
>  {
>  	int err;
>  
> diff --git a/drivers/virtio/virtio_pci_common.h b/drivers/virtio/virtio_pci_common.h
> index 23f6c5c678d5..9dbf1d555dff 100644
> --- a/drivers/virtio/virtio_pci_common.h
> +++ b/drivers/virtio/virtio_pci_common.h
> @@ -114,7 +114,7 @@ void vp_del_vqs(struct virtio_device *vdev);
>  int vp_find_vqs(struct virtio_device *vdev, unsigned nvqs,
>  		struct virtqueue *vqs[], vq_callback_t *callbacks[],
>  		const char * const names[], const bool *ctx,
> -		struct irq_affinity *desc);
> +		struct irq_affinity *desc, u32 sizes[]);
>  const char *vp_bus_name(struct virtio_device *vdev);
>  
>  /* Setup the affinity for a virtqueue:
> diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
> index 3c67d3607802..342795175c29 100644
> --- a/drivers/virtio/virtio_pci_modern.c
> +++ b/drivers/virtio/virtio_pci_modern.c
> @@ -343,11 +343,12 @@ static int vp_modern_find_vqs(struct virtio_device *vdev, unsigned nvqs,
>  			      struct virtqueue *vqs[],
>  			      vq_callback_t *callbacks[],
>  			      const char * const names[], const bool *ctx,
> -			      struct irq_affinity *desc)
> +			      struct irq_affinity *desc, u32 sizes[])
>  {
>  	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
>  	struct virtqueue *vq;
> -	int rc = vp_find_vqs(vdev, nvqs, vqs, callbacks, names, ctx, desc);
> +	int rc = vp_find_vqs(vdev, nvqs, vqs, callbacks, names, ctx, desc,
> +			     sizes);
>  
>  	if (rc)
>  		return rc;
> diff --git a/drivers/virtio/virtio_vdpa.c b/drivers/virtio/virtio_vdpa.c
> index 7767a7f0119b..ee08d01ee8b1 100644
> --- a/drivers/virtio/virtio_vdpa.c
> +++ b/drivers/virtio/virtio_vdpa.c
> @@ -268,7 +268,7 @@ static int virtio_vdpa_find_vqs(struct virtio_device *vdev, unsigned nvqs,
>  				vq_callback_t *callbacks[],
>  				const char * const names[],
>  				const bool *ctx,
> -				struct irq_affinity *desc)
> +				struct irq_affinity *desc, u32 sizes[])
>  {
>  	struct virtio_vdpa_device *vd_dev = to_virtio_vdpa_device(vdev);
>  	struct vdpa_device *vdpa = vd_get_vdpa(vdev);
> diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
> index 0b81fbe17c85..5157524d8036 100644
> --- a/include/linux/virtio_config.h
> +++ b/include/linux/virtio_config.h
> @@ -57,6 +57,7 @@ struct virtio_shm_region {
>   *		include a NULL entry for vqs that do not need a callback
>   *	names: array of virtqueue names (mainly for debugging)
>   *		include a NULL entry for vqs unused by driver
> + *	sizes: array of virtqueue sizes
>   *	Returns 0 on success or error status
>   * @del_vqs: free virtqueues found by find_vqs().
>   * @get_features: get the array of feature bits for this device.
> @@ -98,7 +99,8 @@ struct virtio_config_ops {
>  	int (*find_vqs)(struct virtio_device *, unsigned nvqs,
>  			struct virtqueue *vqs[], vq_callback_t *callbacks[],
>  			const char * const names[], const bool *ctx,
> -			struct irq_affinity *desc);
> +			struct irq_affinity *desc,
> +			u32 sizes[]);
>  	void (*del_vqs)(struct virtio_device *);
>  	u64 (*get_features)(struct virtio_device *vdev);
>  	int (*finalize_features)(struct virtio_device *vdev);
> @@ -205,7 +207,7 @@ struct virtqueue *virtio_find_single_vq(struct virtio_device *vdev,
>  	const char *names[] = { n };
>  	struct virtqueue *vq;
>  	int err = vdev->config->find_vqs(vdev, 1, &vq, callbacks, names, NULL,
> -					 NULL);
> +					 NULL, NULL);
>  	if (err < 0)
>  		return ERR_PTR(err);
>  	return vq;
> @@ -217,7 +219,8 @@ int virtio_find_vqs(struct virtio_device *vdev, unsigned nvqs,
>  			const char * const names[],
>  			struct irq_affinity *desc)
>  {
> -	return vdev->config->find_vqs(vdev, nvqs, vqs, callbacks, names, NULL, desc);
> +	return vdev->config->find_vqs(vdev, nvqs, vqs, callbacks, names, NULL,
> +				      desc, NULL);
>  }
>  
>  static inline
> @@ -227,7 +230,7 @@ int virtio_find_vqs_ctx(struct virtio_device *vdev, unsigned nvqs,
>  			struct irq_affinity *desc)
>  {
>  	return vdev->config->find_vqs(vdev, nvqs, vqs, callbacks, names, ctx,
> -				      desc);
> +				      desc, NULL);
>  }
>  
>  /**
> -- 
> 2.31.0
> 
