Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CADE9D68AA
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 19:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388592AbfJNRjs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 13:39:48 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:52779 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730046AbfJNRjr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 13:39:47 -0400
Received: by mail-wm1-f65.google.com with SMTP id r19so18138534wmh.2;
        Mon, 14 Oct 2019 10:39:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=lNZVpaEdmaJY1w+xpL+K9ZqQ92uD6Jfe5E6lniBjnvM=;
        b=oY+W6FwfNZXtwQq+WhORdLOdfo+f4fhwM0p+Ers5h6CPfgtbEn9ww93kXBSsw2v60b
         SMIu2UNR6PLQJQdTuB5CZKPD7tjM5zgAWc2F3LP1dYBp/mIWLyzvE+gzbroEFBRI7Dst
         6kA8qKfdBDN33wxGZAOv+JGy3RovTItDZE4cjypr4TRa0AKUIYcxwviSXAuFpdNyQ3Ic
         P5h5NDYnWvzIBkjBiYMxqf/jo1ONlCR+e27uF8WQwLTB2ZtajymWafYs1NlkszKw2+og
         TjPkHU05jpgk0QnsRcXQ7aScuZgRRwSgOc6g7Xs1OdMStDrlfb3Y5KlSoZ09BW/JEGMk
         I4Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=lNZVpaEdmaJY1w+xpL+K9ZqQ92uD6Jfe5E6lniBjnvM=;
        b=D9UR3CoXewCGhtbjhNp34fGFEoYQeY1C08Ur0JPIb9bI9tC0tg0LxwIKVvB4xLKB6e
         0aq4/IBm8QDfn+qcaHpt60v5AtjusUAU2lj0nOK5ZOxOJSKv10+neSU1TZGa8O/O/bqp
         32eWqvoMfQyQUxWBmVxREsemXCJCdtfC/KgQJCJyeJV0HaPjfeOKvRkj1lL9oDkyIVXu
         k97sJogKI5l/K39xei8qd7osC0kPI+Bcn4FL9scjcU0ark+p6iTChbpA8pXCdr35hzxB
         kssXscgxJ5FrqLZ1v2kdpDnlYtvKVy9he1VBJNajjIm+DxtcYd9BGGlf6yHPHTo99VsJ
         TdAA==
X-Gm-Message-State: APjAAAXbTx4aqa4NX5v1jZvpPcd8EV5kecf0r6cREKI2vsnWVybpzwoU
        c7+Yr5nynSeN/Hy+nNA46p4=
X-Google-Smtp-Source: APXvYqxufY2enniRnRIxytq9WOwNI0dKAeSWrxef8cqdYzIseEmMuayKHSwg/1yhpjk+WboQkw4UeQ==
X-Received: by 2002:a1c:bc07:: with SMTP id m7mr16018252wmf.117.1571074784999;
        Mon, 14 Oct 2019 10:39:44 -0700 (PDT)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id p5sm25687450wmi.4.2019.10.14.10.39.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Oct 2019 10:39:44 -0700 (PDT)
Date:   Mon, 14 Oct 2019 18:39:42 +0100
From:   Stefan Hajnoczi <stefanha@gmail.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, kwankhede@nvidia.com,
        alex.williamson@redhat.com, mst@redhat.com, tiwei.bie@intel.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        cohuck@redhat.com, maxime.coquelin@redhat.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        rob.miller@broadcom.com, xiao.w.wang@intel.com,
        haotian.wang@sifive.com, zhenyuw@linux.intel.com,
        zhi.a.wang@intel.com, jani.nikula@linux.intel.com,
        joonas.lahtinen@linux.intel.com, rodrigo.vivi@intel.com,
        airlied@linux.ie, daniel@ffwll.ch, farman@linux.ibm.com,
        pasic@linux.ibm.com, sebott@linux.ibm.com, oberpar@linux.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com,
        borntraeger@de.ibm.com, akrowiak@linux.ibm.com,
        freude@linux.ibm.com, lingshan.zhu@intel.com, idos@mellanox.com,
        eperezma@redhat.com, lulu@redhat.com, parav@mellanox.com,
        christophe.de.dinechin@gmail.com, kevin.tian@intel.com
Subject: Re: [PATCH V3 6/7] virtio: introduce a mdev based transport
Message-ID: <20191014173942.GB5359@stefanha-x1.localdomain>
References: <20191011081557.28302-1-jasowang@redhat.com>
 <20191011081557.28302-7-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ftEhullJWpWg/VHq"
Content-Disposition: inline
In-Reply-To: <20191011081557.28302-7-jasowang@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ftEhullJWpWg/VHq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 11, 2019 at 04:15:56PM +0800, Jason Wang wrote:
> +struct virtio_mdev_device {
> +	struct virtio_device vdev;
> +	struct mdev_device *mdev;
> +	unsigned long version;
> +
> +	struct virtqueue **vqs;
> +	/* The lock to protect virtqueue list */
> +	spinlock_t lock;
> +	struct list_head virtqueues;

Is this a list of struct virtio_mdev_vq_info?  Please document the
actual type in a comment.

> +static int virtio_mdev_find_vqs(struct virtio_device *vdev, unsigned nvqs,
> +				struct virtqueue *vqs[],
> +				vq_callback_t *callbacks[],
> +				const char * const names[],
> +				const bool *ctx,
> +				struct irq_affinity *desc)
> +{
> +	struct virtio_mdev_device *vm_dev = to_virtio_mdev_device(vdev);
> +	struct mdev_device *mdev = vm_get_mdev(vdev);
> +	const struct virtio_mdev_device_ops *ops = mdev_get_dev_ops(mdev);
> +	struct virtio_mdev_callback cb;
> +	int i, err, queue_idx = 0;
> +
> +	vm_dev->vqs = kmalloc_array(queue_idx, sizeof(*vm_dev->vqs),
> +				    GFP_KERNEL);

kmalloc_array(0, ...)?  I would have expected nvqs instead of queue_idx
(0).

What is this the purpose of vm_dev->vqs and does anything ever access it?

--ftEhullJWpWg/VHq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl2kst4ACgkQnKSrs4Gr
c8hQqggAsLqAScuEZRHgMYUxIlc4Hpdh283rOQFgRgPfZqq3hQ/nzKTqbn1k7DnZ
MaXQk/GXc1/mFzEwjGVoMOJ+NiZKpj5xuVN9HqKEuDuBooykO5wKnbwkm6kAs/gG
/10A4I5fkyOUHB+xRkaM/3g9UJgo/yB/oI7yQonKFI3VNQc/Q0vcAWUkUbyoZyZA
WO5IJoOR9nF7g6kkYLT0ik26WZFVsBruKTsifLsCJTCQMWo8dJpvgJpGvo/k07YZ
kWYC8J+K/SRA9gpvDBCfkPRQGMgq7CiE0C+VfoGVo11TuFd6FlkjjYmBIPXYek98
rK1ONn6f4qY+67eRJ77oiNeFsj4eYw==
=7Qm5
-----END PGP SIGNATURE-----

--ftEhullJWpWg/VHq--
