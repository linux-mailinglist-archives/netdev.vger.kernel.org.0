Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB6154EEC4
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 03:26:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379504AbiFQBZR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 21:25:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233157AbiFQBZP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 21:25:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1CC1B62CC3
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 18:25:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655429112;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BQGX/Ix68YfbBp0c+Si8nHbxwT1FQh3eLuEkJNgTbTE=;
        b=IybarG+AMu+UpnqFUU3NnyUjI3tXI+dxyTu8PFVGmOksTxiVJrrav3kbqpp/JGORYDUDJP
        aziVlmeQYR88/0u9pT6npvhBROyl1Wjg7j/rY2s6M8Xoyb0EQ3X2pVpNOlXTmfPzA68SLK
        bqEnv95uZkZ3bLLpMwQ7i4WoJ3jHSPQ=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-664-JQyZ_mrBM-Gn1im58r5JMw-1; Thu, 16 Jun 2022 21:25:10 -0400
X-MC-Unique: JQyZ_mrBM-Gn1im58r5JMw-1
Received: by mail-lf1-f70.google.com with SMTP id j3-20020a05651231c300b0047dbea7b031so1555775lfe.19
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 18:25:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BQGX/Ix68YfbBp0c+Si8nHbxwT1FQh3eLuEkJNgTbTE=;
        b=PvY8i9MyawozXzttplbaq/n2JQ8SA6OGgtiQ6syZ5XZ+bPIsPsiBBQ/PlOBfeQQO65
         7Is/3T4X0Blz7zUajxmLmPbvIqpdMn9SGWGCy4co/omfOJrQvekFeOUjWcZBnLg79y+K
         aGTcIdTR3HezMb1BHF6AkYYnJUh/x1aAMWTMLH5e1lRCwovYoWkpCTNfrWvQu2pyW6FU
         3JBnie1vixAV2a5+bmsU4HM3TvgckKazqqRWt9qTOF+VOV6VLBG+Wy/5DBhFvcQ46FB8
         FJQgv0o+pUrWO6dPQ/86oxu/j7PQsMWi+zXL2uDo2CqIRqqliJ4rJ8iIwbu44uft28/i
         nICw==
X-Gm-Message-State: AJIora8iP8StHfvKKrXsoWCNV4/Jq/6UAiperzbIstDlOETngivycTrG
        l9jAZuYrECtXaZQ1ddgYXlZk4/mNzXSH7MjAYLuzIQ5YaMY6h+rL20KxdHBzqTp4NEBPJn5tO8G
        6sd1AheH/t69n3L6nfUYzmiBXL/5u14Wy
X-Received: by 2002:a05:6512:a8f:b0:479:63e5:d59f with SMTP id m15-20020a0565120a8f00b0047963e5d59fmr4283376lfu.124.1655429108833;
        Thu, 16 Jun 2022 18:25:08 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1udRD+KyfOu2KbeC63nR32f26e2qESbLyjm9RK6JunVIw9AxsvYTn80HQKElFBeyoyYZmnQ4NCdUGHbSXrAzD8=
X-Received: by 2002:a05:6512:a8f:b0:479:63e5:d59f with SMTP id
 m15-20020a0565120a8f00b0047963e5d59fmr4283356lfu.124.1655429108611; Thu, 16
 Jun 2022 18:25:08 -0700 (PDT)
MIME-Version: 1.0
References: <CACGkMEs05ZisiPW+7H6Omp80MzmZWZCpc1mf5Vd99C3H-KUtgA@mail.gmail.com>
 <20220613041416-mutt-send-email-mst@kernel.org> <CACGkMEsT_fWdPxN1cTWOX=vu-ntp3Xo4j46-ZKALeSXr7DmJFQ@mail.gmail.com>
 <20220613045606-mutt-send-email-mst@kernel.org> <CACGkMEtAQck7Nr6SP_pD0MGT3njnwZSyT=xPyYzUU3c5GNNM_w@mail.gmail.com>
 <CACGkMEvUFJkC=mnvL2PSH6-3RMcJUk84f-9X46JVcj2vTAr4SQ@mail.gmail.com>
 <20220613052644-mutt-send-email-mst@kernel.org> <CACGkMEstGvhETXThuwO+tLVBuRgQb8uC_6DdAM8ZxOi5UKBRbg@mail.gmail.com>
 <20220614114839-mutt-send-email-mst@kernel.org> <CACGkMEthExrqFNkOzLGwaffvHw=Tc3MXPtTTiRsnpFDGKPRP=A@mail.gmail.com>
 <20220616130945-mutt-send-email-mst@kernel.org>
In-Reply-To: <20220616130945-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Date:   Fri, 17 Jun 2022 09:24:57 +0800
Message-ID: <CACGkMEuSX-wg-VQzVLRhE_9wmQVpCQo5cxQ-by3N6v7gaBNsrg@mail.gmail.com>
Subject: Re: [PATCH V6 8/9] virtio: harden vring IRQ
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     virtualization <virtualization@lists.linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        Halil Pasic <pasic@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        eperezma <eperezma@redhat.com>, Cindy Lu <lulu@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        linux-s390@vger.kernel.org, conghui.chen@intel.com,
        Viresh Kumar <viresh.kumar@linaro.org>,
        netdev <netdev@vger.kernel.org>, pankaj.gupta.linux@gmail.com,
        Cristian Marussi <cristian.marussi@arm.com>,
        sudeep.holla@arm.com, Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 17, 2022 at 1:11 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Wed, Jun 15, 2022 at 09:38:18AM +0800, Jason Wang wrote:
> > On Tue, Jun 14, 2022 at 11:49 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > >
> > > On Tue, Jun 14, 2022 at 03:40:21PM +0800, Jason Wang wrote:
> > > > On Mon, Jun 13, 2022 at 5:28 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > >
> > > > > On Mon, Jun 13, 2022 at 05:14:59PM +0800, Jason Wang wrote:
> > > > > > On Mon, Jun 13, 2022 at 5:08 PM Jason Wang <jasowang@redhat.com> wrote:
> > > > > > >
> > > > > > > On Mon, Jun 13, 2022 at 4:59 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > > > > >
> > > > > > > > On Mon, Jun 13, 2022 at 04:51:08PM +0800, Jason Wang wrote:
> > > > > > > > > On Mon, Jun 13, 2022 at 4:19 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > > > > > > >
> > > > > > > > > > On Mon, Jun 13, 2022 at 04:07:09PM +0800, Jason Wang wrote:
> > > > > > > > > > > On Mon, Jun 13, 2022 at 3:23 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > > > > > > > > >
> > > > > > > > > > > > On Mon, Jun 13, 2022 at 01:26:59PM +0800, Jason Wang wrote:
> > > > > > > > > > > > > On Sat, Jun 11, 2022 at 1:12 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > > > > > > > > > > >
> > > > > > > > > > > > > > On Fri, May 27, 2022 at 02:01:19PM +0800, Jason Wang wrote:
> > > > > > > > > > > > > > > This is a rework on the previous IRQ hardening that is done for
> > > > > > > > > > > > > > > virtio-pci where several drawbacks were found and were reverted:
> > > > > > > > > > > > > > >
> > > > > > > > > > > > > > > 1) try to use IRQF_NO_AUTOEN which is not friendly to affinity managed IRQ
> > > > > > > > > > > > > > >    that is used by some device such as virtio-blk
> > > > > > > > > > > > > > > 2) done only for PCI transport
> > > > > > > > > > > > > > >
> > > > > > > > > > > > > > > The vq->broken is re-used in this patch for implementing the IRQ
> > > > > > > > > > > > > > > hardening. The vq->broken is set to true during both initialization
> > > > > > > > > > > > > > > and reset. And the vq->broken is set to false in
> > > > > > > > > > > > > > > virtio_device_ready(). Then vring_interrupt() can check and return
> > > > > > > > > > > > > > > when vq->broken is true. And in this case, switch to return IRQ_NONE
> > > > > > > > > > > > > > > to let the interrupt core aware of such invalid interrupt to prevent
> > > > > > > > > > > > > > > IRQ storm.
> > > > > > > > > > > > > > >
> > > > > > > > > > > > > > > The reason of using a per queue variable instead of a per device one
> > > > > > > > > > > > > > > is that we may need it for per queue reset hardening in the future.
> > > > > > > > > > > > > > >
> > > > > > > > > > > > > > > Note that the hardening is only done for vring interrupt since the
> > > > > > > > > > > > > > > config interrupt hardening is already done in commit 22b7050a024d7
> > > > > > > > > > > > > > > ("virtio: defer config changed notifications"). But the method that is
> > > > > > > > > > > > > > > used by config interrupt can't be reused by the vring interrupt
> > > > > > > > > > > > > > > handler because it uses spinlock to do the synchronization which is
> > > > > > > > > > > > > > > expensive.
> > > > > > > > > > > > > > >
> > > > > > > > > > > > > > > Cc: Thomas Gleixner <tglx@linutronix.de>
> > > > > > > > > > > > > > > Cc: Peter Zijlstra <peterz@infradead.org>
> > > > > > > > > > > > > > > Cc: "Paul E. McKenney" <paulmck@kernel.org>
> > > > > > > > > > > > > > > Cc: Marc Zyngier <maz@kernel.org>
> > > > > > > > > > > > > > > Cc: Halil Pasic <pasic@linux.ibm.com>
> > > > > > > > > > > > > > > Cc: Cornelia Huck <cohuck@redhat.com>
> > > > > > > > > > > > > > > Cc: Vineeth Vijayan <vneethv@linux.ibm.com>
> > > > > > > > > > > > > > > Cc: Peter Oberparleiter <oberpar@linux.ibm.com>
> > > > > > > > > > > > > > > Cc: linux-s390@vger.kernel.org
> > > > > > > > > > > > > > > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > > > > > > > > > > > > >
> > > > > > > > > > > > > >
> > > > > > > > > > > > > > Jason, I am really concerned by all the fallout.
> > > > > > > > > > > > > > I propose adding a flag to suppress the hardening -
> > > > > > > > > > > > > > this will be a debugging aid and a work around for
> > > > > > > > > > > > > > users if we find more buggy drivers.
> > > > > > > > > > > > > >
> > > > > > > > > > > > > > suppress_interrupt_hardening ?
> > > > > > > > > > > > >
> > > > > > > > > > > > > I can post a patch but I'm afraid if we disable it by default, it
> > > > > > > > > > > > > won't be used by the users so there's no way for us to receive the bug
> > > > > > > > > > > > > report. Or we need a plan to enable it by default.
> > > > > > > > > > > > >
> > > > > > > > > > > > > It's rc2, how about waiting for 1 and 2 rc? Or it looks better if we
> > > > > > > > > > > > > simply warn instead of disable it by default.
> > > > > > > > > > > > >
> > > > > > > > > > > > > Thanks
> > > > > > > > > > > >
> > > > > > > > > > > > I meant more like a flag in struct virtio_driver.
> > > > > > > > > > > > For now, could you audit all drivers which don't call _ready?
> > > > > > > > > > > > I found 5 of these:
> > > > > > > > > > > >
> > > > > > > > > > > > drivers/bluetooth/virtio_bt.c
> > > > > > > > > > >
> > > > > > > > > > > This driver seems to be fine, it doesn't use the device/vq in its probe().
> > > > > > > > > >
> > > > > > > > > >
> > > > > > > > > > But it calls hci_register_dev and that in turn queues all kind of
> > > > > > > > > > work. Also, can linux start using the device immediately after
> > > > > > > > > > it's registered?
> > > > > > > > >
> > > > > > > > > So I think the driver is allowed to queue before DRIVER_OK.
> > > > > > > >
> > > > > > > > it's not allowed to kick
> > > > > > >
> > > > > > > Yes.
> > > > > > >
> > > > > > > >
> > > > > > > > > If yes,
> > > > > > > > > the only side effect is the delay of the tx interrupt after DRIVER_OK
> > > > > > > > > for a well behaved device.
> > > > > > > >
> > > > > > > > your patches drop the interrupt though, it won't be just delayed.
> > > > > > >
> > > > > > > For a well behaved device, it can only trigger the interrupt after DRIVER_OK.
> > > > > > >
> > > > > > > So for virtio bt, it works like:
> > > > > > >
> > > > > > > 1) driver queue buffer and kick
> > > > > > > 2) driver set DRIVER_OK
> > > > > > > 3) device start to process the buffer
> > > > > > > 4) device send an notification
> > > > > > >
> > > > > > > The only risk is that the virtqueue could be filled before DRIVER_OK,
> > > > > > > or anything I missed?
> > > > > >
> > > > > > btw, hci has an open and close method and we do rx refill in
> > > > > > hdev->open, so we're probably fine here.
> > > > > >
> > > > > > Thanks
> > > > >
> > > > >
> > > > > Sounds good. Now to audit the rest of them from this POV ;)
> > > >
> > > > Adding maintainers.
> > > >
> > > > >
> > > > >  drivers/i2c/busses/i2c-virtio.c
> > > >
> > > > It looks to me the device could be used immediately after
> > > > i2c_add_adapter() return. So we probably need to add
> > > > virtio_device_ready() before that. Fortunately, there's no rx vq in
> > > > i2c and the callback looks safe if the callback is called before the
> > > > i2c registration and after virtio_device_ready().
> > > >
> > > > >  drivers/net/caif/caif_virtio.c
> > > >
> > > > A networking device, RX is backed by vringh so we don't need to
> > > > refill. TX is backed by virtio and is available until ndo_open. So
> > > > it's fine to let the core to set DRIVER_OK after probe().
> > > >
> > > > >  drivers/nvdimm/virtio_pmem.c
> > > >
> > > > It doesn't use interrupt so far, so it has nothing to do with the IRQ hardening.
> > > >
> > > > But the device could be used by the subsystem immediately after
> > > > nvdimm_pmem_region_create(), this means the flush could be issued
> > > > before DRIVER_OK. We need virtio_device_ready() before. We don't have
> > > > a RX virtqueue and the callback looks safe if the callback is called
> > > > after virtio_device_ready() but before the nvdimm region creating.
> > > >
> > > > And it looks to me there's a race between the assignment of
> > > > provider_data and virtio_pmem_flush(). If the flush was issued before
> > > > the assignment we will end up with a NULL pointer dereference. This is
> > > > something we need to fix.
> > > >
> > > > >  arm_scmi
> > > >
> > > > It looks to me the singleton device could be used by SCMI immediately after
> > > >
> > > >         /* Ensure initialized scmi_vdev is visible */
> > > >         smp_store_mb(scmi_vdev, vdev);
> > > >
> > > > So we probably need to do virtio_device_ready() before that. It has an
> > > > optional rx queue but the filling is done after the above assignment,
> > > > so it's safe. And the callback looks safe is a callback is triggered
> > > > after virtio_device_ready() buy before the above assignment.
> > > >
> > > > >  virtio_rpmsg_bus.c
> > > > >
> > > >
> > > > This is somehow more complicated. It has an rx queue, the rx filling
> > > > is done before virtio_device_ready() but the kick is done after. And
> > > > it looks to me the device could be used by subsystem immediately
> > > > rpmsg_virtio_add_ctrl_dev() returns.
> > > >
> > > > This means, if we do virtio_device_ready() after
> > > > rpmsg_virtio_add_ctrl_dev(), we may get kick before DRIVER_OK. If we
> > > > do virtio_device_ready() before rpmsg_virtio_add_ctrl_dev(), there's a
> > > > race between the callbacks and rpmsg_virtio_add_ctrl_dev() that could
> > > > be exploited.
> > > >
> > > > It requires more thoughts.
> > > >
> > > > Thanks
> > >
> > > I think at this point let's do it before so we at least do not
> > > get a regression with your patches, add a big comment and work
> > > on fixing properly in the next Linux version. Do you think you can
> > > commit to a full fix in the next linux version?
> >
> > I think it should be ok.
> >
> > If I understand you correctly, you meant to disable the hardening in
> > this release?
> >
> > (Actually, my understanding is that since we are developing mainline
> > instead of a downstream version with a hardening features, bug reports
> > are somehow expected, especially consider most of the bugs are not
> > related to hardening itself)
>
>
> Absolutely. Question is do you think we can fix everything by the
> release?

Probably not, I'm auditing all the virtio drivers and it seems we have
many issues:

1) race between subsystem registration/use and virtio_device_ready()
2) race between notifications and subsystem registerstiation/use

And it looks to me even virtio-net has this race.

So I think I will post a patch to disable this like below for this release.

> At least for rpmsg we don't seem to have a handle on it yet.

Yes.

>
>
> > Thanks
> >
> > diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> > index 13a7348cedff..7ef3115efbad 100644
> > --- a/drivers/virtio/virtio_ring.c
> > +++ b/drivers/virtio/virtio_ring.c
> > @@ -1688,7 +1688,7 @@ static struct virtqueue *vring_create_virtqueue_packed(
> >         vq->we_own_ring = true;
> >         vq->notify = notify;
> >         vq->weak_barriers = weak_barriers;
> > -       vq->broken = true;
> > +       vq->broken = false;
> >         vq->last_used_idx = 0;
> >         vq->event_triggered = false;
> >         vq->num_added = 0;
>
>
> and drop it on reset?

Right.

Thanks

>
> > >
> > >
> > > > >
> > > > >
> > > > > > >
> > > > > > > >
> > > > > > > > > If not, we need to clarify it in the spec
> > > > > > > > > and call virtio_device_ready() before subsystem registration.
> > > > > > > >
> > > > > > > > hmm, i don't get what we need to clarify
> > > > > > >
> > > > > > > E.g the driver is not allowed to kick or after DRIVER_OK should the
> > > > > > > device only process the buffer after a kick after DRIVER_OK (I think
> > > > > > > no)?
> > > > > > >
> > > > > > > >
> > > > > > > > > >
> > > > > > > > > >
> > > > > > > > > > > > drivers/gpu/drm/virtio/virtgpu_drv.c
> > > > > > > > > > >
> > > > > > > > > > > It calles virtio_device_ready() in virtio_gpu_init(), and it looks to
> > > > > > > > > > > me the code is correct.
> > > > > > > > > >
> > > > > > > > > > OK.
> > > > > > > > > >
> > > > > > > > > > > > drivers/i2c/busses/i2c-virtio.c
> > > > > > > > > > > > drivers/net/caif/caif_virtio.c
> > > > > > > > > > > > drivers/nvdimm/virtio_pmem.c
> > > > > > > > > > >
> > > > > > > > > > > The above looks fine and we have three more:
> > > > > > > > > > >
> > > > > > > > > > > arm_scmi: probe() doesn't use vq
> > > > > > > > > > > mac80211_hwsim.c: doesn't use vq (only fill rx), but it kicks the rx,
> > > > > > > > > > > it looks to me we need a device_ready before the kick.
> > > > > > > > > > > virtio_rpmsg_bus.c: doesn't use vq
> > > > > > > > > > >
> > > > > > > > > > > I will post a patch for mac80211_hwsim.c.
> > > > > > > > > > > Thanks
> > > > > > > > > >
> > > > > > > > > > Same comments for all of the above. Might linux not start using the
> > > > > > > > > > device once it's registered?
> > > > > > > > >
> > > > > > > > > It depends on the specific subsystem.
> > > > > > > > >
> > > > > > > > > For the subsystem that can't use the device immediately, calling
> > > > > > > > > virtio_device_ready() after the subsystem's registration should be
> > > > > > > > > fine. E.g for the networking subsystem, the TX won't happen if
> > > > > > > > > ndo_open() is not called, calling virtio_device_ready() after
> > > > > > > > > netdev_register() seems to be fine.
> > > > > > > >
> > > > > > > > exactly
> > > > > > > >
> > > > > > > > > For the subsystem that can use the device immediately, if the
> > > > > > > > > subsystem does not depend on the result of a request in the probe to
> > > > > > > > > proceed, we are still fine. Since those requests will be proceed after
> > > > > > > > > DRIVER_OK.
> > > > > > > >
> > > > > > > > Well first won't driver code normally kick as well?
> > > > > > >
> > > > > > > Kick itself is not blocked.
> > > > > > >
> > > > > > > > And without kick, won't everything just be blocked?
> > > > > > >
> > > > > > > It depends on the subsystem. E.g driver can choose to use a callback
> > > > > > > instead of polling the used buffer in the probe.
> > > > > > >
> > > > > > > >
> > > > > > > >
> > > > > > > > > For the rest we need to do virtio_device_ready() before registration.
> > > > > > > > >
> > > > > > > > > Thanks
> > > > > > > >
> > > > > > > > Then we can get an interrupt for an unregistered device.
> > > > > > >
> > > > > > > It depends on the device. For the device that doesn't have an rx queue
> > > > > > > (or device to driver queue), we are fine:
> > > > > > >
> > > > > > > E.g in virtio-blk:
> > > > > > >
> > > > > > >         virtio_device_ready(vdev);
> > > > > > >
> > > > > > >         err = device_add_disk(&vdev->dev, vblk->disk, virtblk_attr_groups);
> > > > > > >         if (err)
> > > > > > >                 goto out_cleanup_disk;
> > > > > > >
> > > > > > > Thanks
> > > > > > >
> > > > > > > >
> > > > > > > >
> > > > > > > > > >
> > > > > > > > > > > >
> > > > > > > > > > > >
> > > > > > > > > > > >
> > > > > > > > > > > >
> > > > > > > > > > > > > >
> > > > > > > > > > > > > >
> > > > > > > > > > > > > > > ---
> > > > > > > > > > > > > > >  drivers/s390/virtio/virtio_ccw.c       |  4 ++++
> > > > > > > > > > > > > > >  drivers/virtio/virtio.c                | 15 ++++++++++++---
> > > > > > > > > > > > > > >  drivers/virtio/virtio_mmio.c           |  5 +++++
> > > > > > > > > > > > > > >  drivers/virtio/virtio_pci_modern_dev.c |  5 +++++
> > > > > > > > > > > > > > >  drivers/virtio/virtio_ring.c           | 11 +++++++----
> > > > > > > > > > > > > > >  include/linux/virtio_config.h          | 20 ++++++++++++++++++++
> > > > > > > > > > > > > > >  6 files changed, 53 insertions(+), 7 deletions(-)
> > > > > > > > > > > > > > >
> > > > > > > > > > > > > > > diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
> > > > > > > > > > > > > > > index c188e4f20ca3..97e51c34e6cf 100644
> > > > > > > > > > > > > > > --- a/drivers/s390/virtio/virtio_ccw.c
> > > > > > > > > > > > > > > +++ b/drivers/s390/virtio/virtio_ccw.c
> > > > > > > > > > > > > > > @@ -971,6 +971,10 @@ static void virtio_ccw_set_status(struct virtio_device *vdev, u8 status)
> > > > > > > > > > > > > > >       ccw->flags = 0;
> > > > > > > > > > > > > > >       ccw->count = sizeof(status);
> > > > > > > > > > > > > > >       ccw->cda = (__u32)(unsigned long)&vcdev->dma_area->status;
> > > > > > > > > > > > > > > +     /* We use ssch for setting the status which is a serializing
> > > > > > > > > > > > > > > +      * instruction that guarantees the memory writes have
> > > > > > > > > > > > > > > +      * completed before ssch.
> > > > > > > > > > > > > > > +      */
> > > > > > > > > > > > > > >       ret = ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_WRITE_STATUS);
> > > > > > > > > > > > > > >       /* Write failed? We assume status is unchanged. */
> > > > > > > > > > > > > > >       if (ret)
> > > > > > > > > > > > > > > diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
> > > > > > > > > > > > > > > index aa1eb5132767..95fac4c97c8b 100644
> > > > > > > > > > > > > > > --- a/drivers/virtio/virtio.c
> > > > > > > > > > > > > > > +++ b/drivers/virtio/virtio.c
> > > > > > > > > > > > > > > @@ -220,6 +220,15 @@ static int virtio_features_ok(struct virtio_device *dev)
> > > > > > > > > > > > > > >   * */
> > > > > > > > > > > > > > >  void virtio_reset_device(struct virtio_device *dev)
> > > > > > > > > > > > > > >  {
> > > > > > > > > > > > > > > +     /*
> > > > > > > > > > > > > > > +      * The below virtio_synchronize_cbs() guarantees that any
> > > > > > > > > > > > > > > +      * interrupt for this line arriving after
> > > > > > > > > > > > > > > +      * virtio_synchronize_vqs() has completed is guaranteed to see
> > > > > > > > > > > > > > > +      * vq->broken as true.
> > > > > > > > > > > > > > > +      */
> > > > > > > > > > > > > > > +     virtio_break_device(dev);
> > > > > > > > > > > > > >
> > > > > > > > > > > > > > So make this conditional
> > > > > > > > > > > > > >
> > > > > > > > > > > > > > > +     virtio_synchronize_cbs(dev);
> > > > > > > > > > > > > > > +
> > > > > > > > > > > > > > >       dev->config->reset(dev);
> > > > > > > > > > > > > > >  }
> > > > > > > > > > > > > > >  EXPORT_SYMBOL_GPL(virtio_reset_device);
> > > > > > > > > > > > > > > @@ -428,6 +437,9 @@ int register_virtio_device(struct virtio_device *dev)
> > > > > > > > > > > > > > >       dev->config_enabled = false;
> > > > > > > > > > > > > > >       dev->config_change_pending = false;
> > > > > > > > > > > > > > >
> > > > > > > > > > > > > > > +     INIT_LIST_HEAD(&dev->vqs);
> > > > > > > > > > > > > > > +     spin_lock_init(&dev->vqs_list_lock);
> > > > > > > > > > > > > > > +
> > > > > > > > > > > > > > >       /* We always start by resetting the device, in case a previous
> > > > > > > > > > > > > > >        * driver messed it up.  This also tests that code path a little. */
> > > > > > > > > > > > > > >       virtio_reset_device(dev);
> > > > > > > > > > > > > > > @@ -435,9 +447,6 @@ int register_virtio_device(struct virtio_device *dev)
> > > > > > > > > > > > > > >       /* Acknowledge that we've seen the device. */
> > > > > > > > > > > > > > >       virtio_add_status(dev, VIRTIO_CONFIG_S_ACKNOWLEDGE);
> > > > > > > > > > > > > > >
> > > > > > > > > > > > > > > -     INIT_LIST_HEAD(&dev->vqs);
> > > > > > > > > > > > > > > -     spin_lock_init(&dev->vqs_list_lock);
> > > > > > > > > > > > > > > -
> > > > > > > > > > > > > > >       /*
> > > > > > > > > > > > > > >        * device_add() causes the bus infrastructure to look for a matching
> > > > > > > > > > > > > > >        * driver.
> > > > > > > > > > > > > > > diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
> > > > > > > > > > > > > > > index c9699a59f93c..f9a36bc7ac27 100644
> > > > > > > > > > > > > > > --- a/drivers/virtio/virtio_mmio.c
> > > > > > > > > > > > > > > +++ b/drivers/virtio/virtio_mmio.c
> > > > > > > > > > > > > > > @@ -253,6 +253,11 @@ static void vm_set_status(struct virtio_device *vdev, u8 status)
> > > > > > > > > > > > > > >       /* We should never be setting status to 0. */
> > > > > > > > > > > > > > >       BUG_ON(status == 0);
> > > > > > > > > > > > > > >
> > > > > > > > > > > > > > > +     /*
> > > > > > > > > > > > > > > +      * Per memory-barriers.txt, wmb() is not needed to guarantee
> > > > > > > > > > > > > > > +      * that the the cache coherent memory writes have completed
> > > > > > > > > > > > > > > +      * before writing to the MMIO region.
> > > > > > > > > > > > > > > +      */
> > > > > > > > > > > > > > >       writel(status, vm_dev->base + VIRTIO_MMIO_STATUS);
> > > > > > > > > > > > > > >  }
> > > > > > > > > > > > > > >
> > > > > > > > > > > > > > > diff --git a/drivers/virtio/virtio_pci_modern_dev.c b/drivers/virtio/virtio_pci_modern_dev.c
> > > > > > > > > > > > > > > index 4093f9cca7a6..a0fa14f28a7f 100644
> > > > > > > > > > > > > > > --- a/drivers/virtio/virtio_pci_modern_dev.c
> > > > > > > > > > > > > > > +++ b/drivers/virtio/virtio_pci_modern_dev.c
> > > > > > > > > > > > > > > @@ -467,6 +467,11 @@ void vp_modern_set_status(struct virtio_pci_modern_device *mdev,
> > > > > > > > > > > > > > >  {
> > > > > > > > > > > > > > >       struct virtio_pci_common_cfg __iomem *cfg = mdev->common;
> > > > > > > > > > > > > > >
> > > > > > > > > > > > > > > +     /*
> > > > > > > > > > > > > > > +      * Per memory-barriers.txt, wmb() is not needed to guarantee
> > > > > > > > > > > > > > > +      * that the the cache coherent memory writes have completed
> > > > > > > > > > > > > > > +      * before writing to the MMIO region.
> > > > > > > > > > > > > > > +      */
> > > > > > > > > > > > > > >       vp_iowrite8(status, &cfg->device_status);
> > > > > > > > > > > > > > >  }
> > > > > > > > > > > > > > >  EXPORT_SYMBOL_GPL(vp_modern_set_status);
> > > > > > > > > > > > > > > diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> > > > > > > > > > > > > > > index 9c231e1fded7..13a7348cedff 100644
> > > > > > > > > > > > > > > --- a/drivers/virtio/virtio_ring.c
> > > > > > > > > > > > > > > +++ b/drivers/virtio/virtio_ring.c
> > > > > > > > > > > > > > > @@ -1688,7 +1688,7 @@ static struct virtqueue *vring_create_virtqueue_packed(
> > > > > > > > > > > > > > >       vq->we_own_ring = true;
> > > > > > > > > > > > > > >       vq->notify = notify;
> > > > > > > > > > > > > > >       vq->weak_barriers = weak_barriers;
> > > > > > > > > > > > > > > -     vq->broken = false;
> > > > > > > > > > > > > > > +     vq->broken = true;
> > > > > > > > > > > > > > >       vq->last_used_idx = 0;
> > > > > > > > > > > > > > >       vq->event_triggered = false;
> > > > > > > > > > > > > > >       vq->num_added = 0;
> > > > > > > > > > > > > >
> > > > > > > > > > > > > > and make this conditional
> > > > > > > > > > > > > >
> > > > > > > > > > > > > > > @@ -2134,8 +2134,11 @@ irqreturn_t vring_interrupt(int irq, void *_vq)
> > > > > > > > > > > > > > >               return IRQ_NONE;
> > > > > > > > > > > > > > >       }
> > > > > > > > > > > > > > >
> > > > > > > > > > > > > > > -     if (unlikely(vq->broken))
> > > > > > > > > > > > > > > -             return IRQ_HANDLED;
> > > > > > > > > > > > > > > +     if (unlikely(vq->broken)) {
> > > > > > > > > > > > > > > +             dev_warn_once(&vq->vq.vdev->dev,
> > > > > > > > > > > > > > > +                           "virtio vring IRQ raised before DRIVER_OK");
> > > > > > > > > > > > > > > +             return IRQ_NONE;
> > > > > > > > > > > > > > > +     }
> > > > > > > > > > > > > > >
> > > > > > > > > > > > > > >       /* Just a hint for performance: so it's ok that this can be racy! */
> > > > > > > > > > > > > > >       if (vq->event)
> > > > > > > > > > > > > > > @@ -2177,7 +2180,7 @@ struct virtqueue *__vring_new_virtqueue(unsigned int index,
> > > > > > > > > > > > > > >       vq->we_own_ring = false;
> > > > > > > > > > > > > > >       vq->notify = notify;
> > > > > > > > > > > > > > >       vq->weak_barriers = weak_barriers;
> > > > > > > > > > > > > > > -     vq->broken = false;
> > > > > > > > > > > > > > > +     vq->broken = true;
> > > > > > > > > > > > > > >       vq->last_used_idx = 0;
> > > > > > > > > > > > > > >       vq->event_triggered = false;
> > > > > > > > > > > > > > >       vq->num_added = 0;
> > > > > > > > > > > > > >
> > > > > > > > > > > > > > and make this conditional
> > > > > > > > > > > > > >
> > > > > > > > > > > > > > > diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
> > > > > > > > > > > > > > > index 25be018810a7..d4edfd7d91bb 100644
> > > > > > > > > > > > > > > --- a/include/linux/virtio_config.h
> > > > > > > > > > > > > > > +++ b/include/linux/virtio_config.h
> > > > > > > > > > > > > > > @@ -256,6 +256,26 @@ void virtio_device_ready(struct virtio_device *dev)
> > > > > > > > > > > > > > >       unsigned status = dev->config->get_status(dev);
> > > > > > > > > > > > > > >
> > > > > > > > > > > > > > >       BUG_ON(status & VIRTIO_CONFIG_S_DRIVER_OK);
> > > > > > > > > > > > > > > +
> > > > > > > > > > > > > > > +     /*
> > > > > > > > > > > > > > > +      * The virtio_synchronize_cbs() makes sure vring_interrupt()
> > > > > > > > > > > > > > > +      * will see the driver specific setup if it sees vq->broken
> > > > > > > > > > > > > > > +      * as false (even if the notifications come before DRIVER_OK).
> > > > > > > > > > > > > > > +      */
> > > > > > > > > > > > > > > +     virtio_synchronize_cbs(dev);
> > > > > > > > > > > > > > > +     __virtio_unbreak_device(dev);
> > > > > > > > > > > > > > > +     /*
> > > > > > > > > > > > > > > +      * The transport should ensure the visibility of vq->broken
> > > > > > > > > > > > > > > +      * before setting DRIVER_OK. See the comments for the transport
> > > > > > > > > > > > > > > +      * specific set_status() method.
> > > > > > > > > > > > > > > +      *
> > > > > > > > > > > > > > > +      * A well behaved device will only notify a virtqueue after
> > > > > > > > > > > > > > > +      * DRIVER_OK, this means the device should "see" the coherenct
> > > > > > > > > > > > > > > +      * memory write that set vq->broken as false which is done by
> > > > > > > > > > > > > > > +      * the driver when it sees DRIVER_OK, then the following
> > > > > > > > > > > > > > > +      * driver's vring_interrupt() will see vq->broken as false so
> > > > > > > > > > > > > > > +      * we won't lose any notification.
> > > > > > > > > > > > > > > +      */
> > > > > > > > > > > > > > >       dev->config->set_status(dev, status | VIRTIO_CONFIG_S_DRIVER_OK);
> > > > > > > > > > > > > > >  }
> > > > > > > > > > > > > > >
> > > > > > > > > > > > > > > --
> > > > > > > > > > > > > > > 2.25.1
> > > > > > > > > > > > > >
> > > > > > > > > > > >
> > > > > > > > > >
> > > > > > > >
> > > > >
> > >
>

