Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9A6C58FE37
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 16:26:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235427AbiHKO0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 10:26:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230133AbiHKO02 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 10:26:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3590E67CA0
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 07:26:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660227985;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l4mmMrfN4AS0bqf4TJLR/8UiEMYbyCO+KcHd0Ko/SSk=;
        b=bXelUX00CwulwyhAvAryKtAu14rzyWSurmZabVq+vtfFIg6tPR43o8KHbY+ncz+yHQQSB1
        Y+h4GKzsZp6nShkmEdzK8tR4Fj+Alhbdf6jPGWvHKMe8092WEC04UVpXWlBc+4aabwIC+D
        UKdQLWII4i1XQFRofI9Aqmcsg8H4T1w=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-351-jjw08CuqMKyD_tQLK6r-Ug-1; Thu, 11 Aug 2022 10:26:24 -0400
X-MC-Unique: jjw08CuqMKyD_tQLK6r-Ug-1
Received: by mail-qt1-f199.google.com with SMTP id hj2-20020a05622a620200b0034286e2a191so12864671qtb.2
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 07:26:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=l4mmMrfN4AS0bqf4TJLR/8UiEMYbyCO+KcHd0Ko/SSk=;
        b=NGOLC8c6cLNLkLY4YFL97BinZxwI2BfwNdjNYOP+z2mNEx5o++pKKfbeADuAN/6Fst
         P33OeuAHCbyw+ZRMpHgIKf8UEWV0LP7dty7OBCZg1Pi+JBdpkLmxEBQ5YPIkNrL0HK1d
         2776W4yTq8mEM2Tbab7O5YnIr3kQz/fP4wTXVsPaM0WPAggu1NRAHF+fBUmS1QbzT3+6
         GDXLb5YsoMSIqZ5UTIZbiAKxc4+yxv1VfqA6YD8eVvRbitnNHR5XExifzChC0/HZ0meH
         WithCfKRSyFJ8eifitr9Qv3IJ+rZbZbfP6WX5pCTzbMY/MZM+YVCGjAGn5qcW99US4po
         osbg==
X-Gm-Message-State: ACgBeo1YMWErvLUx+CuirUL2pM+wmaftiOglJ5Faj21G+QTiDew3608/
        qfe1yJUFPE7Z3hc9tTe/L6+EzYbuTShjd58mjFkq2j28fKnbk88y58bhi1ffOXLZF+Q6VFf2vAI
        3lnG8JxiB2lZAAJdgeDzoMi4Eac5qg57q
X-Received: by 2002:a05:622a:15cd:b0:342:47fc:b235 with SMTP id d13-20020a05622a15cd00b0034247fcb235mr27235725qty.370.1660227983974;
        Thu, 11 Aug 2022 07:26:23 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4jjPc13we90v3t2YuuArPQXWrrt4BmvXXoaAziZZ07pRvaKgY76tQNaBA4jJTuCVrxQYRUJLXp6wHhLs8xvZc=
X-Received: by 2002:a05:622a:15cd:b0:342:47fc:b235 with SMTP id
 d13-20020a05622a15cd00b0034247fcb235mr27235694qty.370.1660227983721; Thu, 11
 Aug 2022 07:26:23 -0700 (PDT)
MIME-Version: 1.0
References: <20220811135353.2549658-1-eperezma@redhat.com> <20220811095743-mutt-send-email-mst@kernel.org>
In-Reply-To: <20220811095743-mutt-send-email-mst@kernel.org>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Thu, 11 Aug 2022 16:25:47 +0200
Message-ID: <CAJaqyWeAD_nEag4-LN3zaOTe84V9yvC_noRTGfCAY2VjtvBa1Q@mail.gmail.com>
Subject: Re: [PATCH v8 0/3] Implement vdpasim suspend operation
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     virtualization <virtualization@lists.linux-foundation.org>,
        Jason Wang <jasowang@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, ecree.xilinx@gmail.com,
        "Dawar, Gautam" <gautam.dawar@amd.com>,
        Zhang Min <zhang.min9@zte.com.cn>,
        Pablo Cascon Katchadourian <pabloc@xilinx.com>,
        "Uminski, Piotr" <Piotr.Uminski@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "Kamde, Tanuj" <tanuj.kamde@amd.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Martin Petrus Hubertus Habets <martinh@xilinx.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Laurent Vivier <lvivier@redhat.com>,
        Martin Porter <martinpo@xilinx.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Eli Cohen <elic@nvidia.com>, Cindy Lu <lulu@redhat.com>,
        habetsm.xilinx@gmail.com, Parav Pandit <parav@nvidia.com>,
        Longpeng <longpeng2@huawei.com>,
        Wu Zongyong <wuzongyong@linux.alibaba.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Dinan Gunawardena <dinang@xilinx.com>,
        Xie Yongji <xieyongji@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 11, 2022 at 3:58 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Thu, Aug 11, 2022 at 03:53:50PM +0200, Eugenio P=C3=A9rez wrote:
> > Implement suspend operation for vdpa_sim devices, so vhost-vdpa will of=
fer
> > that backend feature and userspace can effectively suspend the device.
> >
> > This is a must before getting virtqueue indexes (base) for live migrati=
on,
> > since the device could modify them after userland gets them. There are
> > individual ways to perform that action for some devices
> > (VHOST_NET_SET_BACKEND, VHOST_VSOCK_SET_RUNNING, ...) but there was no
> > way to perform it for any vhost device (and, in particular, vhost-vdpa)=
.
> >
> > After a successful return of ioctl the device must not process more vir=
tqueue
> > descriptors. The device can answer to read or writes of config fields a=
s if it
> > were not suspended. In particular, writing to "queue_enable" with a val=
ue of 1
> > will not make the device start processing virtqueue buffers.
> >
> > In the future, we will provide features similar to
> > VHOST_USER_GET_INFLIGHT_FD so the device can save pending operations.
> >
> > Applied on top of vhost branch.
> >
> > Comments are welcome.
> >
> > v8:
> > * v7 but incremental from vhost instead of isolated.
>
> Now I'm lost. incremental to what? Does the vhost branch now
> have the correct bits?
>

This patch is intended to be applied on top of the current vhost
branch. In particular, on the top of commit
6a9720576cd00d30722c5f755bd17d4cfa9df636.

It basically deletes the code, the doc, and the unused ioctl argument.

Did I misunderstand what you meant with "incremental" in previous mail?

> > v7:
> > * Remove ioctl leftover argument and update doc accordingly.
> >
> > v6:
> > * Remove the resume operation, making the ioctl simpler. We can always =
add
> >   another ioctl for VM_STOP/VM_RESUME operation later.
> > * s/stop/suspend/ to differentiate more from reset.
> > * Clarify scope of the suspend operation.
> >
> > v5:
> > * s/not stop/resume/ in doc.
> >
> > v4:
> > * Replace VHOST_STOP to VHOST_VDPA_STOP in vhost ioctl switch case too.
> >
> > v3:
> > * s/VHOST_STOP/VHOST_VDPA_STOP/
> > * Add documentation and requirements of the ioctl above its definition.
> >
> > v2:
> > * Replace raw _F_STOP with BIT_ULL(_F_STOP).
> > * Fix obtaining of stop ioctl arg (it was not obtained but written).
> > * Add stop to vdpa_sim_blk.
> >
> > [1] git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git
> >
> > Eugenio P=C3=A9rez (3):
> >   vdpa: delete unreachable branch on vdpasim_suspend
> >   vdpa: Remove wrong doc of VHOST_VDPA_SUSPEND ioctl
> >   vhost: Remove invalid parameter of VHOST_VDPA_SUSPEND ioctl
> >
> >  drivers/vdpa/vdpa_sim/vdpa_sim.c |  7 -------
> >  include/linux/vdpa.h             |  2 +-
> >  include/uapi/linux/vhost.h       | 17 ++++++-----------
> >  3 files changed, 7 insertions(+), 19 deletions(-)
> >
> > --
> > 2.31.1
> >
>

