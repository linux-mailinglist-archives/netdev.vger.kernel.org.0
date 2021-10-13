Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66ACB42C65A
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 18:27:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237264AbhJMQ3O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 12:29:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229938AbhJMQ3K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 12:29:10 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B792C061570;
        Wed, 13 Oct 2021 09:27:04 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id p68so349305iof.6;
        Wed, 13 Oct 2021 09:27:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Xrtpz9NXHFWFufGg5SCBWCumluTEAtqRhhWyErbsuT8=;
        b=cm62qW/8bM+RvH6hNwULRssypHbQXgwQh9hAuLuU0Axk90D74llz7ih64+7HGRdbUx
         yEjqXWZvnHRMNxdOSqQfncIsHo9pGNcAbIAt4vtNjtGFGCCfubtEakJ/WK8T5PosJHX7
         SvO/7OaNqlLgZVT5X7OdbzsWgNbeAxl3BlLWjA+6XPiJd8uxlaKGakcjGuVYhPzDjead
         Nf7WBsZ+S0hRvV40PfR9I3um9qpbIfQjoegJkYpHE2unO5pwCaYQXrimbaPTvNxXp95b
         MaGaif9EsmZA3H5yk+M0khVV8DmhTgmKDbCCmhqSMpOho8AZ/8zAOMcW9Hxirq9BxUGJ
         72Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Xrtpz9NXHFWFufGg5SCBWCumluTEAtqRhhWyErbsuT8=;
        b=7Xl4+7ln5zCG78pGopobqg9Iti6z66/g8hLyiKaX6rsAqKJJ/KcT4ZXXxn4d35egG/
         O7DnLLMs1ZkeDDthbN6pLKts03okyRx2B1zA4dgkXHYFLwcdT36dwKl/7/64zC60VMUO
         +/skrlV82WpocdQekMYCtd0lXhPJFH4bVgfmqnwNSkZzCWj8kq8YvXXD6ME01LM1eevd
         JWm/GPuDmxK7/2fO0gxvhR8RjXPeKKfnhbO+FjW7/iamTHMmOLiXFWx9O7WdwlkimveB
         akJlMZan4eG8KI+E3yuCmbrDs/rUNV21O2RfLp5GwPgGoKtsvvNcBceTsZZFHzblgqmn
         neHw==
X-Gm-Message-State: AOAM532eaFzKAtHh4KDk44EYpiUVbiKj7H9wGowM36OZMIkk52llzJPK
        kK5wZugMpJMRbEPvAEXfFGrXHLWGiOyiUFmc5rs=
X-Google-Smtp-Source: ABdhPJyuL03Mu4jCtrDahdjQhnotErC05Ve18e62uQyBilTUwz90riuTyD8fiewVxVGZWLl9N2i8KnFUl44nihqeTWo=
X-Received: by 2002:a5e:a619:: with SMTP id q25mr200218ioi.144.1634142423625;
 Wed, 13 Oct 2021 09:27:03 -0700 (PDT)
MIME-Version: 1.0
References: <20211013105226.20225-1-mst@redhat.com>
In-Reply-To: <20211013105226.20225-1-mst@redhat.com>
From:   Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Date:   Wed, 13 Oct 2021 18:26:51 +0200
Message-ID: <CAM9Jb+j9=JKAaZp5vb82JYErpwkaVbv0zoUJagYLwr5m=Vbptg@mail.gmail.com>
Subject: Re: [PATCH RFC] virtio: wrap config->reset calls
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, Jeff Dike <jdike@addtoit.com>,
        Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jens Axboe <axboe@kernel.dk>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Amit Shah <amit@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gonglei <arei.gonglei@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Cristian Marussi <cristian.marussi@arm.com>,
        "Enrico Weigelt, metux IT consult" <info@metux.net>,
        Viresh Kumar <vireshk@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        David Airlie <airlied@linux.ie>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Daniel Vetter <daniel@ffwll.ch>, Jie Deng <jie.deng@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        David Hildenbrand <david@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Anton Yakovlev <anton.yakovlev@opensynergy.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, linux-um@lists.infradead.org,
        virtualization@lists.linux-foundation.org,
        linux-block@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-gpio@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-i2c@vger.kernel.org, iommu@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Linux NVDIMM <nvdimm@lists.linux.dev>,
        linux-remoteproc@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net, kvm@vger.kernel.org,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> This will enable cleanups down the road.
> The idea is to disable cbs, then add "flush_queued_cbs" callback
> as a parameter, this way drivers can flush any work
> queued after callbacks have been disabled.
>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  arch/um/drivers/virt-pci.c                 | 2 +-
>  drivers/block/virtio_blk.c                 | 4 ++--
>  drivers/bluetooth/virtio_bt.c              | 2 +-
>  drivers/char/hw_random/virtio-rng.c        | 2 +-
>  drivers/char/virtio_console.c              | 4 ++--
>  drivers/crypto/virtio/virtio_crypto_core.c | 8 ++++----
>  drivers/firmware/arm_scmi/virtio.c         | 2 +-
>  drivers/gpio/gpio-virtio.c                 | 2 +-
>  drivers/gpu/drm/virtio/virtgpu_kms.c       | 2 +-
>  drivers/i2c/busses/i2c-virtio.c            | 2 +-
>  drivers/iommu/virtio-iommu.c               | 2 +-
>  drivers/net/caif/caif_virtio.c             | 2 +-
>  drivers/net/virtio_net.c                   | 4 ++--
>  drivers/net/wireless/mac80211_hwsim.c      | 2 +-
>  drivers/nvdimm/virtio_pmem.c               | 2 +-
>  drivers/rpmsg/virtio_rpmsg_bus.c           | 2 +-
>  drivers/scsi/virtio_scsi.c                 | 2 +-
>  drivers/virtio/virtio.c                    | 5 +++++
>  drivers/virtio/virtio_balloon.c            | 2 +-
>  drivers/virtio/virtio_input.c              | 2 +-
>  drivers/virtio/virtio_mem.c                | 2 +-
>  fs/fuse/virtio_fs.c                        | 4 ++--
>  include/linux/virtio.h                     | 1 +
>  net/9p/trans_virtio.c                      | 2 +-
>  net/vmw_vsock/virtio_transport.c           | 4 ++--
>  sound/virtio/virtio_card.c                 | 4 ++--
>  26 files changed, 39 insertions(+), 33 deletions(-)
>
> diff --git a/arch/um/drivers/virt-pci.c b/arch/um/drivers/virt-pci.c
> index c08066633023..22c4d87c9c15 100644
> --- a/arch/um/drivers/virt-pci.c
> +++ b/arch/um/drivers/virt-pci.c
> @@ -616,7 +616,7 @@ static void um_pci_virtio_remove(struct virtio_device *vdev)
>         int i;
>
>          /* Stop all virtqueues */
> -        vdev->config->reset(vdev);
> +        virtio_reset_device(vdev);
>          vdev->config->del_vqs(vdev);
>
>         device_set_wakeup_enable(&vdev->dev, false);
> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> index 303caf2d17d0..83d0af3fbf30 100644
> --- a/drivers/block/virtio_blk.c
> +++ b/drivers/block/virtio_blk.c
> @@ -910,7 +910,7 @@ static void virtblk_remove(struct virtio_device *vdev)
>         mutex_lock(&vblk->vdev_mutex);
>
>         /* Stop all the virtqueues. */
> -       vdev->config->reset(vdev);
> +       virtio_reset_device(vdev);
>
>         /* Virtqueues are stopped, nothing can use vblk->vdev anymore. */
>         vblk->vdev = NULL;
> @@ -929,7 +929,7 @@ static int virtblk_freeze(struct virtio_device *vdev)
>         struct virtio_blk *vblk = vdev->priv;
>
>         /* Ensure we don't receive any more interrupts */
> -       vdev->config->reset(vdev);
> +       virtio_reset_device(vdev);
>
>         /* Make sure no work handler is accessing the device. */
>         flush_work(&vblk->config_work);
> diff --git a/drivers/bluetooth/virtio_bt.c b/drivers/bluetooth/virtio_bt.c
> index 57908ce4fae8..24a9258962fa 100644
> --- a/drivers/bluetooth/virtio_bt.c
> +++ b/drivers/bluetooth/virtio_bt.c
> @@ -364,7 +364,7 @@ static void virtbt_remove(struct virtio_device *vdev)
>         struct hci_dev *hdev = vbt->hdev;
>
>         hci_unregister_dev(hdev);
> -       vdev->config->reset(vdev);
> +       virtio_reset_device(vdev);
>
>         hci_free_dev(hdev);
>         vbt->hdev = NULL;
> diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
> index a90001e02bf7..95980489514b 100644
> --- a/drivers/char/hw_random/virtio-rng.c
> +++ b/drivers/char/hw_random/virtio-rng.c
> @@ -134,7 +134,7 @@ static void remove_common(struct virtio_device *vdev)
>         vi->hwrng_removed = true;
>         vi->data_avail = 0;
>         complete(&vi->have_data);
> -       vdev->config->reset(vdev);
> +       virtio_reset_device(vdev);
>         vi->busy = false;
>         if (vi->hwrng_register_done)
>                 hwrng_unregister(&vi->hwrng);
> diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
> index 7eaf303a7a86..08bbd693436f 100644
> --- a/drivers/char/virtio_console.c
> +++ b/drivers/char/virtio_console.c
> @@ -1957,7 +1957,7 @@ static void virtcons_remove(struct virtio_device *vdev)
>         spin_unlock_irq(&pdrvdata_lock);
>
>         /* Disable interrupts for vqs */
> -       vdev->config->reset(vdev);
> +       virtio_reset_device(vdev);
>         /* Finish up work that's lined up */
>         if (use_multiport(portdev))
>                 cancel_work_sync(&portdev->control_work);
> @@ -2139,7 +2139,7 @@ static int virtcons_freeze(struct virtio_device *vdev)
>
>         portdev = vdev->priv;
>
> -       vdev->config->reset(vdev);
> +       virtio_reset_device(vdev);
>
>         if (use_multiport(portdev))
>                 virtqueue_disable_cb(portdev->c_ivq);
> diff --git a/drivers/crypto/virtio/virtio_crypto_core.c b/drivers/crypto/virtio/virtio_crypto_core.c
> index e2375d992308..8e977b7627cb 100644
> --- a/drivers/crypto/virtio/virtio_crypto_core.c
> +++ b/drivers/crypto/virtio/virtio_crypto_core.c
> @@ -404,7 +404,7 @@ static int virtcrypto_probe(struct virtio_device *vdev)
>  free_engines:
>         virtcrypto_clear_crypto_engines(vcrypto);
>  free_vqs:
> -       vcrypto->vdev->config->reset(vdev);
> +       virtio_reset_device(vdev);
>         virtcrypto_del_vqs(vcrypto);
>  free_dev:
>         virtcrypto_devmgr_rm_dev(vcrypto);
> @@ -436,7 +436,7 @@ static void virtcrypto_remove(struct virtio_device *vdev)
>
>         if (virtcrypto_dev_started(vcrypto))
>                 virtcrypto_dev_stop(vcrypto);
> -       vdev->config->reset(vdev);
> +       virtio_reset_device(vdev);
>         virtcrypto_free_unused_reqs(vcrypto);
>         virtcrypto_clear_crypto_engines(vcrypto);
>         virtcrypto_del_vqs(vcrypto);
> @@ -456,7 +456,7 @@ static int virtcrypto_freeze(struct virtio_device *vdev)
>  {
>         struct virtio_crypto *vcrypto = vdev->priv;
>
> -       vdev->config->reset(vdev);
> +       virtio_reset_device(vdev);
>         virtcrypto_free_unused_reqs(vcrypto);
>         if (virtcrypto_dev_started(vcrypto))
>                 virtcrypto_dev_stop(vcrypto);
> @@ -492,7 +492,7 @@ static int virtcrypto_restore(struct virtio_device *vdev)
>  free_engines:
>         virtcrypto_clear_crypto_engines(vcrypto);
>  free_vqs:
> -       vcrypto->vdev->config->reset(vdev);
> +       virtio_reset_device(vdev);
>         virtcrypto_del_vqs(vcrypto);
>         return err;
>  }
> diff --git a/drivers/firmware/arm_scmi/virtio.c b/drivers/firmware/arm_scmi/virtio.c
> index 11e8efb71375..6b8d93fe8848 100644
> --- a/drivers/firmware/arm_scmi/virtio.c
> +++ b/drivers/firmware/arm_scmi/virtio.c
> @@ -452,7 +452,7 @@ static void scmi_vio_remove(struct virtio_device *vdev)
>          * outstanding message on any vqueue to be ignored by complete_cb: now
>          * we can just stop processing buffers and destroy the vqueues.
>          */
> -       vdev->config->reset(vdev);
> +       virtio_reset_device(vdev);
>         vdev->config->del_vqs(vdev);
>         /* Ensure scmi_vdev is visible as NULL */
>         smp_store_mb(scmi_vdev, NULL);
> diff --git a/drivers/gpio/gpio-virtio.c b/drivers/gpio/gpio-virtio.c
> index d24f1c9264bc..5029f01966f4 100644
> --- a/drivers/gpio/gpio-virtio.c
> +++ b/drivers/gpio/gpio-virtio.c
> @@ -203,7 +203,7 @@ static void virtio_gpio_request_vq(struct virtqueue *vq)
>
>  static void virtio_gpio_free_vqs(struct virtio_device *vdev)
>  {
> -       vdev->config->reset(vdev);
> +       virtio_reset_device(vdev);
>         vdev->config->del_vqs(vdev);
>  }
>
> diff --git a/drivers/gpu/drm/virtio/virtgpu_kms.c b/drivers/gpu/drm/virtio/virtgpu_kms.c
> index f3379059f324..6aa605b8d3a1 100644
> --- a/drivers/gpu/drm/virtio/virtgpu_kms.c
> +++ b/drivers/gpu/drm/virtio/virtgpu_kms.c
> @@ -257,7 +257,7 @@ void virtio_gpu_deinit(struct drm_device *dev)
>         flush_work(&vgdev->ctrlq.dequeue_work);
>         flush_work(&vgdev->cursorq.dequeue_work);
>         flush_work(&vgdev->config_changed_work);
> -       vgdev->vdev->config->reset(vgdev->vdev);
> +       virtio_reset_device(vgdev->vdev);
>         vgdev->vdev->config->del_vqs(vgdev->vdev);
>  }
>
> diff --git a/drivers/i2c/busses/i2c-virtio.c b/drivers/i2c/busses/i2c-virtio.c
> index f10a603b13fb..eb3261ac64dc 100644
> --- a/drivers/i2c/busses/i2c-virtio.c
> +++ b/drivers/i2c/busses/i2c-virtio.c
> @@ -177,7 +177,7 @@ static int virtio_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs,
>
>  static void virtio_i2c_del_vqs(struct virtio_device *vdev)
>  {
> -       vdev->config->reset(vdev);
> +       virtio_reset_device(vdev);
>         vdev->config->del_vqs(vdev);
>  }
>
> diff --git a/drivers/iommu/virtio-iommu.c b/drivers/iommu/virtio-iommu.c
> index 80930ce04a16..1d4e1e7cf175 100644
> --- a/drivers/iommu/virtio-iommu.c
> +++ b/drivers/iommu/virtio-iommu.c
> @@ -1115,7 +1115,7 @@ static void viommu_remove(struct virtio_device *vdev)
>         iommu_device_unregister(&viommu->iommu);
>
>         /* Stop all virtqueues */
> -       vdev->config->reset(vdev);
> +       virtio_reset_device(vdev);
>         vdev->config->del_vqs(vdev);
>
>         dev_info(&vdev->dev, "device removed\n");
> diff --git a/drivers/net/caif/caif_virtio.c b/drivers/net/caif/caif_virtio.c
> index 91230894692d..444ef6a342f6 100644
> --- a/drivers/net/caif/caif_virtio.c
> +++ b/drivers/net/caif/caif_virtio.c
> @@ -754,7 +754,7 @@ static void cfv_remove(struct virtio_device *vdev)
>         debugfs_remove_recursive(cfv->debugfs);
>
>         vringh_kiov_cleanup(&cfv->ctx.riov);
> -       vdev->config->reset(vdev);
> +       virtio_reset_device(vdev);
>         vdev->vringh_config->del_vrhs(cfv->vdev);
>         cfv->vr_rx = NULL;
>         vdev->config->del_vqs(cfv->vdev);
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 79bd2585ec6b..8c10fcad73a4 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -3274,7 +3274,7 @@ static int virtnet_probe(struct virtio_device *vdev)
>         return 0;
>
>  free_unregister_netdev:
> -       vi->vdev->config->reset(vdev);
> +       virtio_reset_device(vdev);
>
>         unregister_netdev(dev);
>  free_failover:
> @@ -3290,7 +3290,7 @@ static int virtnet_probe(struct virtio_device *vdev)
>
>  static void remove_vq_common(struct virtnet_info *vi)
>  {
> -       vi->vdev->config->reset(vi->vdev);
> +       virtio_reset_device(vi->vdev);
>
>         /* Free unused buffers in both send and recv, if any. */
>         free_unused_bufs(vi);
> diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
> index 0adae76eb8df..9ee430c1d4a2 100644
> --- a/drivers/net/wireless/mac80211_hwsim.c
> +++ b/drivers/net/wireless/mac80211_hwsim.c
> @@ -4369,7 +4369,7 @@ static void remove_vqs(struct virtio_device *vdev)
>  {
>         int i;
>
> -       vdev->config->reset(vdev);
> +       virtio_reset_device(vdev);
>
>         for (i = 0; i < ARRAY_SIZE(hwsim_vqs); i++) {
>                 struct virtqueue *vq = hwsim_vqs[i];
> diff --git a/drivers/nvdimm/virtio_pmem.c b/drivers/nvdimm/virtio_pmem.c
> index 726c7354d465..995b6cdc67ed 100644
> --- a/drivers/nvdimm/virtio_pmem.c
> +++ b/drivers/nvdimm/virtio_pmem.c
> @@ -105,7 +105,7 @@ static void virtio_pmem_remove(struct virtio_device *vdev)
>
>         nvdimm_bus_unregister(nvdimm_bus);
>         vdev->config->del_vqs(vdev);
> -       vdev->config->reset(vdev);
> +       virtio_reset_device(vdev);
>  }
>
>  static struct virtio_driver virtio_pmem_driver = {
> diff --git a/drivers/rpmsg/virtio_rpmsg_bus.c b/drivers/rpmsg/virtio_rpmsg_bus.c
> index 8e49a3bacfc7..6a11952822df 100644
> --- a/drivers/rpmsg/virtio_rpmsg_bus.c
> +++ b/drivers/rpmsg/virtio_rpmsg_bus.c
> @@ -1015,7 +1015,7 @@ static void rpmsg_remove(struct virtio_device *vdev)
>         size_t total_buf_space = vrp->num_bufs * vrp->buf_size;
>         int ret;
>
> -       vdev->config->reset(vdev);
> +       virtio_reset_device(vdev);
>
>         ret = device_for_each_child(&vdev->dev, NULL, rpmsg_remove_device);
>         if (ret)
> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index 07d0250f17c3..f2502a8a5213 100644
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c
> @@ -778,7 +778,7 @@ static void virtscsi_init_vq(struct virtio_scsi_vq *virtscsi_vq,
>  static void virtscsi_remove_vqs(struct virtio_device *vdev)
>  {
>         /* Stop all the virtqueues. */
> -       vdev->config->reset(vdev);
> +       virtio_reset_device(vdev);
>         vdev->config->del_vqs(vdev);
>  }
>
> diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
> index 0a5b54034d4b..a67dd0eca578 100644
> --- a/drivers/virtio/virtio.c
> +++ b/drivers/virtio/virtio.c
> @@ -204,6 +204,11 @@ int virtio_finalize_features(struct virtio_device *dev)
>  }
>  EXPORT_SYMBOL_GPL(virtio_finalize_features);
>
> +static void virtio_reset_device(struct virtio_device *dev)
> +{
> +       dev->config->reset(dev);
> +}
> +
>  static int virtio_dev_probe(struct device *_d)
>  {
>         int err, i;
> diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
> index c22ff0117b46..f4c34a2a6b8e 100644
> --- a/drivers/virtio/virtio_balloon.c
> +++ b/drivers/virtio/virtio_balloon.c
> @@ -1056,7 +1056,7 @@ static void remove_common(struct virtio_balloon *vb)
>                 return_free_pages_to_mm(vb, ULONG_MAX);
>
>         /* Now we reset the device so we can clean up the queues. */
> -       vb->vdev->config->reset(vb->vdev);
> +       virtio_reset_device(vb->vdev);
>
>         vb->vdev->config->del_vqs(vb->vdev);
>  }
> diff --git a/drivers/virtio/virtio_input.c b/drivers/virtio/virtio_input.c
> index ce51ae165943..3aa46703872d 100644
> --- a/drivers/virtio/virtio_input.c
> +++ b/drivers/virtio/virtio_input.c
> @@ -347,7 +347,7 @@ static void virtinput_remove(struct virtio_device *vdev)
>         spin_unlock_irqrestore(&vi->lock, flags);
>
>         input_unregister_device(vi->idev);
> -       vdev->config->reset(vdev);
> +       virtio_reset_device(vdev);
>         while ((buf = virtqueue_detach_unused_buf(vi->sts)) != NULL)
>                 kfree(buf);
>         vdev->config->del_vqs(vdev);
> diff --git a/drivers/virtio/virtio_mem.c b/drivers/virtio/virtio_mem.c
> index bef8ad6bf466..3bab0a625a4b 100644
> --- a/drivers/virtio/virtio_mem.c
> +++ b/drivers/virtio/virtio_mem.c
> @@ -2722,7 +2722,7 @@ static void virtio_mem_remove(struct virtio_device *vdev)
>         }
>
>         /* reset the device and cleanup the queues */
> -       vdev->config->reset(vdev);
> +       virtio_reset_device(vdev);
>         vdev->config->del_vqs(vdev);
>
>         kfree(vm);
> diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
> index 0ad89c6629d7..27c3b74070a2 100644
> --- a/fs/fuse/virtio_fs.c
> +++ b/fs/fuse/virtio_fs.c
> @@ -895,7 +895,7 @@ static int virtio_fs_probe(struct virtio_device *vdev)
>         return 0;
>
>  out_vqs:
> -       vdev->config->reset(vdev);
> +       virtio_reset_device(vdev);
>         virtio_fs_cleanup_vqs(vdev, fs);
>         kfree(fs->vqs);
>
> @@ -927,7 +927,7 @@ static void virtio_fs_remove(struct virtio_device *vdev)
>         list_del_init(&fs->list);
>         virtio_fs_stop_all_queues(fs);
>         virtio_fs_drain_all_queues_locked(fs);
> -       vdev->config->reset(vdev);
> +       virtio_reset_device(vdev);
>         virtio_fs_cleanup_vqs(vdev, fs);
>
>         vdev->priv = NULL;
> diff --git a/include/linux/virtio.h b/include/linux/virtio.h
> index 41edbc01ffa4..72292a62cd90 100644
> --- a/include/linux/virtio.h
> +++ b/include/linux/virtio.h
> @@ -138,6 +138,7 @@ int virtio_finalize_features(struct virtio_device *dev);
>  int virtio_device_freeze(struct virtio_device *dev);
>  int virtio_device_restore(struct virtio_device *dev);
>  #endif
> +void virtio_reset_device(struct virtio_device *dev);
>
>  size_t virtio_max_dma_size(struct virtio_device *vdev);
>
> diff --git a/net/9p/trans_virtio.c b/net/9p/trans_virtio.c
> index 490a4c900339..19c69821dd04 100644
> --- a/net/9p/trans_virtio.c
> +++ b/net/9p/trans_virtio.c
> @@ -721,7 +721,7 @@ static void p9_virtio_remove(struct virtio_device *vdev)
>
>         mutex_unlock(&virtio_9p_lock);
>
> -       vdev->config->reset(vdev);
> +       virtio_reset_device(vdev);
>         vdev->config->del_vqs(vdev);
>
>         sysfs_remove_file(&(vdev->dev.kobj), &dev_attr_mount_tag.attr);
> diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
> index 4f7c99dfd16c..fb3302fff627 100644
> --- a/net/vmw_vsock/virtio_transport.c
> +++ b/net/vmw_vsock/virtio_transport.c
> @@ -665,7 +665,7 @@ static void virtio_vsock_remove(struct virtio_device *vdev)
>         vsock_for_each_connected_socket(virtio_vsock_reset_sock);
>
>         /* Stop all work handlers to make sure no one is accessing the device,
> -        * so we can safely call vdev->config->reset().
> +        * so we can safely call virtio_reset_device().
>          */
>         mutex_lock(&vsock->rx_lock);
>         vsock->rx_run = false;
> @@ -682,7 +682,7 @@ static void virtio_vsock_remove(struct virtio_device *vdev)
>         /* Flush all device writes and interrupts, device will not use any
>          * more buffers.
>          */
> -       vdev->config->reset(vdev);
> +       virtio_reset_device(vdev);
>
>         mutex_lock(&vsock->rx_lock);
>         while ((pkt = virtqueue_detach_unused_buf(vsock->vqs[VSOCK_VQ_RX])))
> diff --git a/sound/virtio/virtio_card.c b/sound/virtio/virtio_card.c
> index 150ab3e37013..e2847c040f75 100644
> --- a/sound/virtio/virtio_card.c
> +++ b/sound/virtio/virtio_card.c
> @@ -350,7 +350,7 @@ static void virtsnd_remove(struct virtio_device *vdev)
>                 snd_card_free(snd->card);
>
>         vdev->config->del_vqs(vdev);
> -       vdev->config->reset(vdev);
> +       virtio_reset_device(vdev);
>
>         for (i = 0; snd->substreams && i < snd->nsubstreams; ++i) {
>                 struct virtio_pcm_substream *vss = &snd->substreams[i];
> @@ -379,7 +379,7 @@ static int virtsnd_freeze(struct virtio_device *vdev)
>         virtsnd_ctl_msg_cancel_all(snd);
>
>         vdev->config->del_vqs(vdev);
> -       vdev->config->reset(vdev);
> +       virtio_reset_device(vdev);
>
>         for (i = 0; i < snd->nsubstreams; ++i)
>                 cancel_work_sync(&snd->substreams[i].elapsed_period);

Reviewed-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
