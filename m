Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69FF055D342
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:12:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343650AbiF1GzV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 02:55:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244756AbiF1GzS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 02:55:18 -0400
Received: from out30-45.freemail.mail.aliyun.com (out30-45.freemail.mail.aliyun.com [115.124.30.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C87F726562;
        Mon, 27 Jun 2022 23:55:14 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=36;SR=0;TI=SMTPD_---0VHfuH4N_1656399306;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VHfuH4N_1656399306)
          by smtp.aliyun-inc.com;
          Tue, 28 Jun 2022 14:55:07 +0800
Message-ID: <1656399270.5965908-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH v10 25/41] virtio_pci: struct virtio_pci_common_cfg add queue_notify_data
Date:   Tue, 28 Jun 2022 14:54:30 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     virtualization <virtualization@lists.linux-foundation.org>,
        Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        Vadim Pasternak <vadimp@nvidia.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        linux-um@lists.infradead.org, netdev <netdev@vger.kernel.org>,
        platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm <kvm@vger.kernel.org>,
        "open list:XDP (eXpress Data Path)" <bpf@vger.kernel.org>,
        kangjie.xu@linux.alibaba.com, "Michael S. Tsirkin" <mst@redhat.com>
References: <20220624025621.128843-1-xuanzhuo@linux.alibaba.com>
 <20220624025621.128843-26-xuanzhuo@linux.alibaba.com>
 <20220624025817-mutt-send-email-mst@kernel.org>
 <CACGkMEseptD=45j3kQr0yciRxR679Jcig=292H07-RYC2vXmFQ@mail.gmail.com>
 <20220627023841-mutt-send-email-mst@kernel.org>
 <CACGkMEvy8xF2T_vubKeUEPC2aroO_fbB0Xe8nnxK4OBUgAS+Gw@mail.gmail.com>
 <20220627034733-mutt-send-email-mst@kernel.org>
 <CACGkMEtpjUBaUML=fEs5hR66rzNTBhBXOmfpzyXV1F-6BqvsGg@mail.gmail.com>
 <20220627074723-mutt-send-email-mst@kernel.org>
 <CACGkMEv0zdgG6SAaxRwkpObEFX_KRB1ovezNiHX+QXsYhE=qaQ@mail.gmail.com>
 <20220628014309-mutt-send-email-mst@kernel.org>
 <CACGkMEuzrmVsM5Xa3N_9n0-XOqyMAz65AON8oxkgmjnXb_bAFg@mail.gmail.com>
 <20220628020832-mutt-send-email-mst@kernel.org>
 <CACGkMEs4Ps6Jnbzrx+4Zju7SUfgu0aTACrLyqpqBcxsZP7YOkQ@mail.gmail.com>
In-Reply-To: <CACGkMEs4Ps6Jnbzrx+4Zju7SUfgu0aTACrLyqpqBcxsZP7YOkQ@mail.gmail.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Jun 2022 14:12:13 +0800, Jason Wang <jasowang@redhat.com> wrote:
> On Tue, Jun 28, 2022 at 2:10 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Tue, Jun 28, 2022 at 02:07:28PM +0800, Jason Wang wrote:
> > > On Tue, Jun 28, 2022 at 1:46 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > >
> > > > On Tue, Jun 28, 2022 at 11:50:37AM +0800, Jason Wang wrote:
> > > > > On Mon, Jun 27, 2022 at 7:53 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > > >
> > > > > > On Mon, Jun 27, 2022 at 04:14:20PM +0800, Jason Wang wrote:
> > > > > > > On Mon, Jun 27, 2022 at 3:58 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > > > > >
> > > > > > > > On Mon, Jun 27, 2022 at 03:45:30PM +0800, Jason Wang wrote:
> > > > > > > > > On Mon, Jun 27, 2022 at 2:39 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > > > > > > >
> > > > > > > > > > On Mon, Jun 27, 2022 at 10:30:42AM +0800, Jason Wang wrote:
> > > > > > > > > > > On Fri, Jun 24, 2022 at 2:59 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > > > > > > > > >
> > > > > > > > > > > > On Fri, Jun 24, 2022 at 10:56:05AM +0800, Xuan Zhuo wrote:
> > > > > > > > > > > > > Add queue_notify_data in struct virtio_pci_common_cfg, which comes from
> > > > > > > > > > > > > here https://github.com/oasis-tcs/virtio-spec/issues/89
> > > > > > > > > > > > >
> > > > > > > > > > > > > For not breaks uABI, add a new struct virtio_pci_common_cfg_notify.
> > > > > > > > > > > >
> > > > > > > > > > > > What exactly is meant by not breaking uABI?
> > > > > > > > > > > > Users are supposed to be prepared for struct size to change ... no?
> > > > > > > > > > >
> > > > > > > > > > > Not sure, any doc for this?
> > > > > > > > > > >
> > > > > > > > > > > Thanks
> > > > > > > > > >
> > > > > > > > > >
> > > > > > > > > > Well we have this:
> > > > > > > > > >
> > > > > > > > > >         The drivers SHOULD only map part of configuration structure
> > > > > > > > > >         large enough for device operation.  The drivers MUST handle
> > > > > > > > > >         an unexpectedly large \field{length}, but MAY check that \field{length}
> > > > > > > > > >         is large enough for device operation.
> > > > > > > > >
> > > > > > > > > Yes, but that's the device/driver interface. What's done here is the
> > > > > > > > > userspace/kernel.
> > > > > > > > >
> > > > > > > > > Userspace may break if it uses e.g sizeof(struct virtio_pci_common_cfg)?
> > > > > > > > >
> > > > > > > > > Thanks
> > > > > > > >
> > > > > > > > Hmm I guess there's risk... but then how are we going to maintain this
> > > > > > > > going forward?  Add a new struct on any change?
> > > > > > >
> > > > > > > This is the way we have used it for the past 5 or more years. I don't
> > > > > > > see why this must be handled in the vq reset feature.
> > > > > > >
> > > > > > > >Can we at least
> > > > > > > > prevent this going forward somehow?
> > > > > > >
> > > > > > > Like have some padding?
> > > > > > >
> > > > > > > Thanks
> > > > > >
> > > > > > Maybe - this is what QEMU does ...
> > > > >
> > > > > Do you want this to be addressed in this series (it's already very huge anyhow)?
> > > > >
> > > > > Thanks
> > > >
> > > > Let's come up with a solution at least. QEMU does not seem to need the struct.
> > >
> > > If we want to implement it in Qemu we need that:
> > >
> > > https://github.com/fengidri/qemu/commit/39b79335cb55144d11a3b01f93d46cc73342c6bb
> > >
> > > > Let's just put
> > > > it in virtio_pci_modern.h for now then?
> > >
> > > Does this mean userspace needs to define the struct by their own
> > > instead of depending on the uapi in the future?
> > >
> > > Thanks
> >
> >
> > $ git grep 'struct virtio_pci_common_cfg'
> > include/standard-headers/linux/virtio_pci.h:struct virtio_pci_common_cfg {
> > tests/qtest/libqos/virtio-pci-modern.c:                   offsetof(struct virtio_pci_common_cfg,
> > tests/qtest/libqos/virtio-pci-modern.c:                       offsetof(struct virtio_pci_common_cfg, device_feature));
> > tests/qtest/libqos/virtio-pci-modern.c:                   offsetof(struct virtio_pci_common_cfg,
> > tests/qtest/libqos/virtio-pci-modern.c:                       offsetof(struct virtio_pci_common_cfg, device_feature));
> > tests/qtest/libqos/virtio-pci-modern.c:                   offsetof(struct virtio_pci_common_cfg,
> > tests/qtest/libqos/virtio-pci-modern.c:                   offsetof(struct virtio_pci_common_cfg,
> > tests/qtest/libqos/virtio-pci-modern.c:                   offsetof(struct virtio_pci_common_cfg,
> > tests/qtest/libqos/virtio-pci-modern.c:                   offsetof(struct virtio_pci_common_cfg,
> > tests/qtest/libqos/virtio-pci-modern.c:                   offsetof(struct virtio_pci_common_cfg,
> > tests/qtest/libqos/virtio-pci-modern.c:                       offsetof(struct virtio_pci_common_cfg, guest_feature));
> > tests/qtest/libqos/virtio-pci-modern.c:                   offsetof(struct virtio_pci_common_cfg,
> > tests/qtest/libqos/virtio-pci-modern.c:                       offsetof(struct virtio_pci_common_cfg, guest_feature));
> > tests/qtest/libqos/virtio-pci-modern.c:                         offsetof(struct virtio_pci_common_cfg,
> > tests/qtest/libqos/virtio-pci-modern.c:                          offsetof(struct virtio_pci_common_cfg,
> > tests/qtest/libqos/virtio-pci-modern.c:                   offsetof(struct virtio_pci_common_cfg, queue_select),
> > tests/qtest/libqos/virtio-pci-modern.c:                         offsetof(struct virtio_pci_common_cfg, queue_size));
> > tests/qtest/libqos/virtio-pci-modern.c:                   offsetof(struct virtio_pci_common_cfg, queue_desc_lo),
> > tests/qtest/libqos/virtio-pci-modern.c:                   offsetof(struct virtio_pci_common_cfg, queue_desc_hi),
> > tests/qtest/libqos/virtio-pci-modern.c:                   offsetof(struct virtio_pci_common_cfg, queue_avail_lo),
> > tests/qtest/libqos/virtio-pci-modern.c:                   offsetof(struct virtio_pci_common_cfg, queue_avail_hi),
> > tests/qtest/libqos/virtio-pci-modern.c:                   offsetof(struct virtio_pci_common_cfg, queue_used_lo),
> > tests/qtest/libqos/virtio-pci-modern.c:                   offsetof(struct virtio_pci_common_cfg, queue_used_hi),
> > tests/qtest/libqos/virtio-pci-modern.c:                               offsetof(struct virtio_pci_common_cfg,
> > tests/qtest/libqos/virtio-pci-modern.c:                   offsetof(struct virtio_pci_common_cfg, queue_enable), 1);
> > tests/qtest/libqos/virtio-pci-modern.c:                   offsetof(struct virtio_pci_common_cfg, msix_config), entry);
> > tests/qtest/libqos/virtio-pci-modern.c:                           offsetof(struct virtio_pci_common_cfg,
> > tests/qtest/libqos/virtio-pci-modern.c:                   offsetof(struct virtio_pci_common_cfg, queue_msix_vector),
> > tests/qtest/libqos/virtio-pci-modern.c:                           offsetof(struct virtio_pci_common_cfg,
> >
> >
> > The only user of the struct is libqos and it just wants
> > the offsets so can use macros just as well.
>
> Yes, so this way should be fine.


OK. I will fix in next version.

Thanks.


>
> Thanks
>
> >
> >
> > > >
> > > > > >
> > > > > > > >
> > > > > > > >
> > > > > > > > > >
> > > > > > > > > >
> > > > > > > > > >
> > > > > > > > > > >
> > > > > > > > > > > >
> > > > > > > > > > > >
> > > > > > > > > > > > > Since I want to add queue_reset after queue_notify_data, I submitted
> > > > > > > > > > > > > this patch first.
> > > > > > > > > > > > >
> > > > > > > > > > > > > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > > > > > > > > > > > > Acked-by: Jason Wang <jasowang@redhat.com>
> > > > > > > > > > > > > ---
> > > > > > > > > > > > >  include/uapi/linux/virtio_pci.h | 7 +++++++
> > > > > > > > > > > > >  1 file changed, 7 insertions(+)
> > > > > > > > > > > > >
> > > > > > > > > > > > > diff --git a/include/uapi/linux/virtio_pci.h b/include/uapi/linux/virtio_pci.h
> > > > > > > > > > > > > index 3a86f36d7e3d..22bec9bd0dfc 100644
> > > > > > > > > > > > > --- a/include/uapi/linux/virtio_pci.h
> > > > > > > > > > > > > +++ b/include/uapi/linux/virtio_pci.h
> > > > > > > > > > > > > @@ -166,6 +166,13 @@ struct virtio_pci_common_cfg {
> > > > > > > > > > > > >       __le32 queue_used_hi;           /* read-write */
> > > > > > > > > > > > >  };
> > > > > > > > > > > > >
> > > > > > > > > > > > > +struct virtio_pci_common_cfg_notify {
> > > > > > > > > > > > > +     struct virtio_pci_common_cfg cfg;
> > > > > > > > > > > > > +
> > > > > > > > > > > > > +     __le16 queue_notify_data;       /* read-write */
> > > > > > > > > > > > > +     __le16 padding;
> > > > > > > > > > > > > +};
> > > > > > > > > > > > > +
> > > > > > > > > > > > >  /* Fields in VIRTIO_PCI_CAP_PCI_CFG: */
> > > > > > > > > > > > >  struct virtio_pci_cfg_cap {
> > > > > > > > > > > > >       struct virtio_pci_cap cap;
> > > > > > > > > > > > > --
> > > > > > > > > > > > > 2.31.0
> > > > > > > > > > > >
> > > > > > > > > >
> > > > > > > >
> > > > > >
> > > >
> >
>
