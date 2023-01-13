Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 580B8668AE0
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 05:31:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234380AbjAMEbG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 23:31:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232182AbjAMEaE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 23:30:04 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5E0259537
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 20:29:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673584152;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tYOigAT8FjBJnRmlBY/evrJwd/jrK0Pfejo/7V3NboI=;
        b=DemNQ4duBLS8JIbCWx8JYILjKPw8vLeQAfdRM1xkmwns/HCtrkzBrflTCXsd41ocWgRkRY
        aFWjjZAwZTosgY8Vw0UThSLH0M8BJrXjp0OHtEKE+OJVJsu+WZVWUx2i7NdMhO4eyh3/mc
        uydGi7cUPM2sJmbPHvV+ePqJd18hB24=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-173-k4nEAcgyMAWYoQcNM84tAQ-1; Thu, 12 Jan 2023 23:29:11 -0500
X-MC-Unique: k4nEAcgyMAWYoQcNM84tAQ-1
Received: by mail-ot1-f69.google.com with SMTP id u11-20020a9d4d8b000000b006782ebb9bf5so10106657otk.11
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 20:29:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tYOigAT8FjBJnRmlBY/evrJwd/jrK0Pfejo/7V3NboI=;
        b=0joLsKyQKYpD07JGP5m3wecHB74Mj/drk9bEnJkFz9+ImiTrV0y4DZ1yO5z7Z/TR6u
         2iBBCp2yVfGk30LyusqX90+LU4RIKGgDYc2GpijI+bIlLGuTBh9uJAkP+3zC5fnIhgU4
         eQL8mzZ2fhKmEB9Eb/yaXysDYIoJcRrLvpui4Xcqqvvg92vBlLHqg8G7TCtO2fiQrG3x
         iq0yMix0xY+8hHXbY94ZtdMMruq38K2z2sgmel2uk4VKfjDcy+IxVT+6XUvO9f6yxJ08
         4W0P9tkRUTS9j88gQ4EKR3WWbajf3sCVGqiArONQ+aeNRY0XS9xMzUReEAyvZXG7VfXj
         GDNg==
X-Gm-Message-State: AFqh2kp3JFeLxIGotUjDKWcJsY8rh4h+0VXKLpkKrTYZPEasc9eMAAF1
        jhCoCxlsUA+gaei3TPDpocm1xK3BfsSi1A2OTqWdpuFdZwB3S7xCbRZ6GnOxqEzY95EP3LgTlnN
        NufLhrdPwPZZuKvEl8xpTGjuZv/c8RePw
X-Received: by 2002:a05:6870:4413:b0:144:a97b:1ae2 with SMTP id u19-20020a056870441300b00144a97b1ae2mr4417816oah.35.1673584149806;
        Thu, 12 Jan 2023 20:29:09 -0800 (PST)
X-Google-Smtp-Source: AMrXdXueI5dEpZs3SyUxTopzSdtNcLMOl/v3xz8U0F03S5pkbRIUurouj0WCLCZdePAxz4dHmtlzzHNeNlFs+WHS+to=
X-Received: by 2002:a05:6870:4413:b0:144:a97b:1ae2 with SMTP id
 u19-20020a056870441300b00144a97b1ae2mr4417807oah.35.1673584149519; Thu, 12
 Jan 2023 20:29:09 -0800 (PST)
MIME-Version: 1.0
References: <20221207145428.31544-1-gautam.dawar@amd.com> <20221207145428.31544-9-gautam.dawar@amd.com>
 <CACGkMEtGCbUBZRFh7EUJyymuWZ9uxiAOeJHA6h-dGa9Y3pDZGw@mail.gmail.com>
 <c5956679-82c1-336b-3190-de32db1c0926@amd.com> <CACGkMEvVnAQ2t4piV3U-hACELvUozRKJOiCCcQLp5ch2TQ9r4w@mail.gmail.com>
In-Reply-To: <CACGkMEvVnAQ2t4piV3U-hACELvUozRKJOiCCcQLp5ch2TQ9r4w@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Fri, 13 Jan 2023 12:28:58 +0800
Message-ID: <CACGkMEt866q9CR_4JNUX+35gyV4ykYPiviLHeYfgqKCmrqXZ4A@mail.gmail.com>
Subject: Re: [PATCH net-next 08/11] sfc: implement device status related vdpa
 config operations
To:     Gautam Dawar <gdawar@amd.com>
Cc:     Gautam Dawar <gautam.dawar@amd.com>, linux-net-drivers@amd.com,
        netdev@vger.kernel.org, eperezma@redhat.com, tanuj.kamde@amd.com,
        Koushik.Dutta@amd.com, harpreet.anand@amd.com,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 11, 2023 at 2:36 PM Jason Wang <jasowang@redhat.com> wrote:
>
> On Mon, Jan 9, 2023 at 6:21 PM Gautam Dawar <gdawar@amd.com> wrote:
> >
> >
> > On 12/14/22 12:15, Jason Wang wrote:
> > > Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> > >
> > >
> > > On Wed, Dec 7, 2022 at 10:57 PM Gautam Dawar <gautam.dawar@amd.com> wrote:
> > >> vDPA config opertions to handle get/set device status and device
> > >> reset have been implemented.
> > >>
> > >> Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>
> > >> ---
> > >>   drivers/net/ethernet/sfc/ef100_vdpa.c     |   7 +-
> > >>   drivers/net/ethernet/sfc/ef100_vdpa.h     |   1 +
> > >>   drivers/net/ethernet/sfc/ef100_vdpa_ops.c | 133 ++++++++++++++++++++++
> > >>   3 files changed, 140 insertions(+), 1 deletion(-)
> > >>
> > >> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.c b/drivers/net/ethernet/sfc/ef100_vdpa.c
> > >> index 04d64bfe3c93..80bca281a748 100644
> > >> --- a/drivers/net/ethernet/sfc/ef100_vdpa.c
> > >> +++ b/drivers/net/ethernet/sfc/ef100_vdpa.c
> > >> @@ -225,9 +225,14 @@ static int vdpa_allocate_vis(struct efx_nic *efx, unsigned int *allocated_vis)
> > >>
> > >>   static void ef100_vdpa_delete(struct efx_nic *efx)
> > >>   {
> > >> +       struct vdpa_device *vdpa_dev;
> > >> +
> > >>          if (efx->vdpa_nic) {
> > >> +               vdpa_dev = &efx->vdpa_nic->vdpa_dev;
> > >> +               ef100_vdpa_reset(vdpa_dev);
> > > Any reason we need to reset during delete?
> > ef100_reset_vdpa_device() does the necessary clean-up including freeing
> > irqs, deleting filters and deleting the vrings which is required while
> > removing the vdpa device or unloading the driver.
>
> That's fine but the name might be a little bit confusing since vDPA
> reset is not necessary here.
>
> > >
> > >> +
> > >>                  /* replace with _vdpa_unregister_device later */
> > >> -               put_device(&efx->vdpa_nic->vdpa_dev.dev);
> > >> +               put_device(&vdpa_dev->dev);
> > >>                  efx->vdpa_nic = NULL;
> > >>          }
> > >>          efx_mcdi_free_vis(efx);
> > >> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.h b/drivers/net/ethernet/sfc/ef100_vdpa.h
> > >> index a33edd6dda12..1b0bbba88154 100644
> > >> --- a/drivers/net/ethernet/sfc/ef100_vdpa.h
> > >> +++ b/drivers/net/ethernet/sfc/ef100_vdpa.h
> > >> @@ -186,6 +186,7 @@ int ef100_vdpa_add_filter(struct ef100_vdpa_nic *vdpa_nic,
> > >>                            enum ef100_vdpa_mac_filter_type type);
> > >>   int ef100_vdpa_irq_vectors_alloc(struct pci_dev *pci_dev, u16 nvqs);
> > >>   void ef100_vdpa_irq_vectors_free(void *data);
> > >> +int ef100_vdpa_reset(struct vdpa_device *vdev);
> > >>
> > >>   static inline bool efx_vdpa_is_little_endian(struct ef100_vdpa_nic *vdpa_nic)
> > >>   {
> > >> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
> > >> index 132ddb4a647b..718b67f6da90 100644
> > >> --- a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
> > >> +++ b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
> > >> @@ -251,6 +251,62 @@ static bool is_qid_invalid(struct ef100_vdpa_nic *vdpa_nic, u16 idx,
> > >>          return false;
> > >>   }
> > >>
> > >> +static void ef100_reset_vdpa_device(struct ef100_vdpa_nic *vdpa_nic)
> > >> +{
> > >> +       int i;
> > >> +
> > >> +       WARN_ON(!mutex_is_locked(&vdpa_nic->lock));
> > >> +
> > >> +       if (!vdpa_nic->status)
> > >> +               return;
> > >> +
> > >> +       vdpa_nic->vdpa_state = EF100_VDPA_STATE_INITIALIZED;
> > >> +       vdpa_nic->status = 0;
> > >> +       vdpa_nic->features = 0;
> > >> +       for (i = 0; i < (vdpa_nic->max_queue_pairs * 2); i++)
> > >> +               reset_vring(vdpa_nic, i);
> > >> +}
> > >> +
> > >> +/* May be called under the rtnl lock */
> > >> +int ef100_vdpa_reset(struct vdpa_device *vdev)
> > >> +{
> > >> +       struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
> > >> +
> > >> +       /* vdpa device can be deleted anytime but the bar_config
> > >> +        * could still be vdpa and hence efx->state would be STATE_VDPA.
> > >> +        * Accordingly, ensure vdpa device exists before reset handling
> > >> +        */
> > >> +       if (!vdpa_nic)
> > >> +               return -ENODEV;
> > >> +
> > >> +       mutex_lock(&vdpa_nic->lock);
> > >> +       ef100_reset_vdpa_device(vdpa_nic);
> > >> +       mutex_unlock(&vdpa_nic->lock);
> > >> +       return 0;
> > >> +}
> > >> +
> > >> +static int start_vdpa_device(struct ef100_vdpa_nic *vdpa_nic)
> > >> +{
> > >> +       int rc = 0;
> > >> +       int i, j;
> > >> +
> > >> +       for (i = 0; i < (vdpa_nic->max_queue_pairs * 2); i++) {
> > >> +               if (can_create_vring(vdpa_nic, i)) {
> > >> +                       rc = create_vring(vdpa_nic, i);
> > > So I think we can safely remove the create_vring() in set_vq_ready()
> > > since it's undefined behaviour if set_vq_ready() is called after
> > > DRIVER_OK.
> > Is this (undefined) behavior documented in the virtio spec?
>
> This part is kind of tricky:
>
> PCI transport has a queue_enable field. And recently,
> VIRTIO_F_RING_RESET was introduced. Let's start without that first:
>
> In
>
> 4.1.4.3.2 Driver Requirements: Common configuration structure layout
>
> It said:
>
> "The driver MUST configure the other virtqueue fields before enabling
> the virtqueue with queue_enable."
>
> and
>
> "The driver MUST NOT write a 0 to queue_enable."
>
> My understanding is that:
>
> 1) Write 0 is forbidden
> 2) Write 1 after DRIVER_OK is undefined behaviour (or need to clarify)
>
> With VIRTIO_F_RING_RESET is negotiated:
>
> "
> If VIRTIO_F_RING_RESET has been negotiated, after the driver writes 1
> to queue_reset to reset the queue, the driver MUST NOT consider queue
> reset to be complete until it reads back 0 in queue_reset. The driver
> MAY re-enable the queue by writing 1 to queue_enable after ensuring
> that other virtqueue fields have been set up correctly. The driver MAY
> set driver-writeable queue configuration values to different values
> than those that were used before the queue reset. (see 2.6.1).
> "
>
> Write 1 to queue_enable after DRIVER_OK and after the queue is reset is allowed.
>
> Thanks

Btw, I just realized that we need to stick to the current behaviour,
that is to say, to allow set_vq_ready() to be called after DRIVER_OK.

It is needed for the cvq trap and migration for control virtqueue:

https://www.mail-archive.com/qemu-devel@nongnu.org/msg931491.html

Thanks


>
>
> > If so, can
> > you please point me to the section of virtio spec that calls this order
> > (set_vq_ready() after setting DRIVER_OK) undefined? Is it just that the
> > queue can't be enabled after DRIVER_OK or the reverse (disabling the
> > queue) after DRIVER_OK is not allowed?
> > >
> > >> +                       if (rc)
> > >> +                               goto clear_vring;
> > >> +               }
> > >> +       }
> > >> +       vdpa_nic->vdpa_state = EF100_VDPA_STATE_STARTED;
> > >> +       return rc;
> > >> +
> > >> +clear_vring:
> > >> +       for (j = 0; j < i; j++)
> > >> +               if (vdpa_nic->vring[j].vring_created)
> > >> +                       delete_vring(vdpa_nic, j);
> > >> +       return rc;
> > >> +}
> > >> +
> > >>   static int ef100_vdpa_set_vq_address(struct vdpa_device *vdev,
> > >>                                       u16 idx, u64 desc_area, u64 driver_area,
> > >>                                       u64 device_area)
> > >> @@ -568,6 +624,80 @@ static u32 ef100_vdpa_get_vendor_id(struct vdpa_device *vdev)
> > >>          return EF100_VDPA_VENDOR_ID;
> > >>   }
> > >>
> > >> +static u8 ef100_vdpa_get_status(struct vdpa_device *vdev)
> > >> +{
> > >> +       struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
> > >> +       u8 status;
> > >> +
> > >> +       mutex_lock(&vdpa_nic->lock);
> > >> +       status = vdpa_nic->status;
> > >> +       mutex_unlock(&vdpa_nic->lock);
> > >> +       return status;
> > >> +}
> > >> +
> > >> +static void ef100_vdpa_set_status(struct vdpa_device *vdev, u8 status)
> > >> +{
> > >> +       struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
> > >> +       u8 new_status;
> > >> +       int rc;
> > >> +
> > >> +       mutex_lock(&vdpa_nic->lock);
> > >> +       if (!status) {
> > >> +               dev_info(&vdev->dev,
> > >> +                        "%s: Status received is 0. Device reset being done\n",
> > >> +                        __func__);
> > >> +               ef100_reset_vdpa_device(vdpa_nic);
> > >> +               goto unlock_return;
> > >> +       }
> > >> +       new_status = status & ~vdpa_nic->status;
> > >> +       if (new_status == 0) {
> > >> +               dev_info(&vdev->dev,
> > >> +                        "%s: New status same as current status\n", __func__);
> > >> +               goto unlock_return;
> > >> +       }
> > >> +       if (new_status & VIRTIO_CONFIG_S_FAILED) {
> > >> +               ef100_reset_vdpa_device(vdpa_nic);
> > >> +               goto unlock_return;
> > >> +       }
> > >> +
> > >> +       if (new_status & VIRTIO_CONFIG_S_ACKNOWLEDGE &&
> > >> +           vdpa_nic->vdpa_state == EF100_VDPA_STATE_INITIALIZED) {
> > > As replied before, I think there's no need to check
> > > EF100_VDPA_STATE_INITIALIZED, otherwise it could be a bug somewhere.
> > Ok. Will remove the check against EF100_VDPA_STATE_INITIALIZED.
> > >> +               vdpa_nic->status |= VIRTIO_CONFIG_S_ACKNOWLEDGE;
> > >> +               new_status &= ~VIRTIO_CONFIG_S_ACKNOWLEDGE;
> > >> +       }
> > >> +       if (new_status & VIRTIO_CONFIG_S_DRIVER &&
> > >> +           vdpa_nic->vdpa_state == EF100_VDPA_STATE_INITIALIZED) {
> > >> +               vdpa_nic->status |= VIRTIO_CONFIG_S_DRIVER;
> > >> +               new_status &= ~VIRTIO_CONFIG_S_DRIVER;
> > >> +       }
> > >> +       if (new_status & VIRTIO_CONFIG_S_FEATURES_OK &&
> > >> +           vdpa_nic->vdpa_state == EF100_VDPA_STATE_INITIALIZED) {
> > >> +               vdpa_nic->status |= VIRTIO_CONFIG_S_FEATURES_OK;
> > >> +               vdpa_nic->vdpa_state = EF100_VDPA_STATE_NEGOTIATED;
> > > I think we can simply map EF100_VDPA_STATE_NEGOTIATED to
> > > VIRTIO_CONFIG_S_FEATURES_OK.
> > >
> > > E.g the code doesn't fail the feature negotiation by clearing the
> > > VIRTIO_CONFIG_S_FEATURES_OK when ef100_vdpa_set_driver_feature fails?
> > Ok.
> > >
> > > Thanks
> >
> > Regards,
> >
> > Gautam
> >

