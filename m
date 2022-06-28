Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 822E655E89D
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 18:36:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346797AbiF1NpM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 09:45:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346912AbiF1No5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 09:44:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3A7842CDC9
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 06:44:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656423893;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hTKU2Np09ZtKabep+TfxXVYS1Y9DSz+czzdyoC+zeWM=;
        b=EAGPn7vUKcbB6rfFOvSpssKNBAt9yRZ37cGVBNH2iKbD8MPdiX0VoWsV2Elfejqb98IJ7U
        6JMbOJUR31CkDOsXvAfOII4i/8+XEZvuhkzwQOJY8wETZAIacJXtvSZGODiFnct/tfTSTs
        hx0P55zQPnfdh4LE+UVM9NDfGmGtrvE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-321-TtrMHO3KNLqoZBUYl8vYQQ-1; Tue, 28 Jun 2022 09:44:51 -0400
X-MC-Unique: TtrMHO3KNLqoZBUYl8vYQQ-1
Received: by mail-wm1-f69.google.com with SMTP id j19-20020a05600c191300b003a048196712so3795031wmq.4
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 06:44:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=hTKU2Np09ZtKabep+TfxXVYS1Y9DSz+czzdyoC+zeWM=;
        b=wiYQzRtz3omquxM8/adjAv4xwvDqtSnCybGubUe2JKZoUFwqrp06Ca/TxYF+cYdOZb
         DIXJBCB/PCSH62RQmABiiX3666cUbQP+U8rb2Q5t2DIy8VLO+OS4dB7I33c+soxrKGe2
         7aECkIRNAWTtV2tHW6c6RMB52eoKfS4zdi6ekBgsWRUWW9TIr0E/EcH9hQemt+WB5bc5
         Q8IE6Wj//TMp7GWQxrLQZujcuGbKjAyfKuQMfh5dAPbpMZM4LWNF6lUh2Cz3oHaG5GsY
         m25bXIp0Y1xm3RqRWL4MN2G33nEoiI5CENBOo+6pcDhJ3OiL3ZzpawDRb7Mh9IRpvtVA
         cNgA==
X-Gm-Message-State: AJIora888GzbET6O28TNu3hzfwGcSLpoGt7YLCohuENZt2NEel/VthGf
        Q1Mek3divVk2kaeNK5NFO34jYnDqLVJz21eCTQWJq2dVcfSRK2xplZHtxanqTKyaEPfjva0i2gH
        ZICpol5Mwsy/U6hB2
X-Received: by 2002:a05:6000:79e:b0:21b:bc0a:99d4 with SMTP id bu30-20020a056000079e00b0021bbc0a99d4mr17240173wrb.565.1656423890333;
        Tue, 28 Jun 2022 06:44:50 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sPWXFvUvtzyxCMk9Gd6kxz02V2LWzAokqDn4AqQ5aZX6+OSB5A0LtPAjU3qDMm4YViNyvqeQ==
X-Received: by 2002:a05:6000:79e:b0:21b:bc0a:99d4 with SMTP id bu30-20020a056000079e00b0021bbc0a99d4mr17240143wrb.565.1656423890092;
        Tue, 28 Jun 2022 06:44:50 -0700 (PDT)
Received: from sgarzare-redhat (host-87-11-6-149.retail.telecomitalia.it. [87.11.6.149])
        by smtp.gmail.com with ESMTPSA id g13-20020adffc8d000000b0021b99efceb6sm13809079wrr.22.2022.06.28.06.44.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 06:44:49 -0700 (PDT)
Date:   Tue, 28 Jun 2022 15:44:46 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>, Jason Wang <jasowang@redhat.com>,
        kernel list <linux-kernel@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        kvm <kvm@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Cindy Lu <lulu@redhat.com>,
        "Kamde, Tanuj" <tanuj.kamde@amd.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>, Piotr.Uminski@intel.com,
        habetsm.xilinx@gmail.com, "Dawar, Gautam" <gautam.dawar@amd.com>,
        Pablo Cascon Katchadourian <pabloc@xilinx.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Longpeng <longpeng2@huawei.com>,
        Dinan Gunawardena <dinang@xilinx.com>,
        Martin Petrus Hubertus Habets <martinh@xilinx.com>,
        Martin Porter <martinpo@xilinx.com>,
        Eli Cohen <elic@nvidia.com>, ecree.xilinx@gmail.com,
        Wu Zongyong <wuzongyong@linux.alibaba.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Zhang Min <zhang.min9@zte.com.cn>
Subject: Re: [PATCH v6 3/4] vhost-vdpa: uAPI to suspend the device
Message-ID: <CAGxU2F43+5zsQOR4ReTtQtEF47s6y-XKcevosMOzUdEqpLhAsg@mail.gmail.com>
References: <20220623160738.632852-1-eperezma@redhat.com>
 <20220623160738.632852-4-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220623160738.632852-4-eperezma@redhat.com>
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 23, 2022 at 06:07:37PM +0200, Eugenio Pérez wrote:
>The ioctl adds support for suspending the device from userspace.
>
>This is a must before getting virtqueue indexes (base) for live migration,
>since the device could modify them after userland gets them. There are
>individual ways to perform that action for some devices
>(VHOST_NET_SET_BACKEND, VHOST_VSOCK_SET_RUNNING, ...) but there was no
>way to perform it for any vhost device (and, in particular, vhost-vdpa).
>
>After a successful return of the ioctl call the device must not process
>more virtqueue descriptors. The device can answer to read or writes of
>config fields as if it were not suspended. In particular, writing to
>"queue_enable" with a value of 1 will not make the device start
>processing buffers of the virtqueue.
>
>Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
>---
> drivers/vhost/vdpa.c       | 19 +++++++++++++++++++
> include/uapi/linux/vhost.h | 14 ++++++++++++++
> 2 files changed, 33 insertions(+)
>
>diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
>index 3d636e192061..7fa671ac4bdf 100644
>--- a/drivers/vhost/vdpa.c
>+++ b/drivers/vhost/vdpa.c
>@@ -478,6 +478,22 @@ static long vhost_vdpa_get_vqs_count(struct vhost_vdpa *v, u32 __user *argp)
>       return 0;
> }
>
>+/* After a successful return of ioctl the device must not process more
>+ * virtqueue descriptors. The device can answer to read or writes of config
>+ * fields as if it were not suspended. In particular, writing to "queue_enable"
>+ * with a value of 1 will not make the device start processing buffers.
>+ */
>+static long vhost_vdpa_suspend(struct vhost_vdpa *v)
>+{
>+      struct vdpa_device *vdpa = v->vdpa;
>+      const struct vdpa_config_ops *ops = vdpa->config;
>+
>+      if (!ops->suspend)
>+              return -EOPNOTSUPP;
>+
>+      return ops->suspend(vdpa);
>+}
>+
> static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
>                                  void __user *argp)
> {
>@@ -654,6 +670,9 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
>       case VHOST_VDPA_GET_VQS_COUNT:
>               r = vhost_vdpa_get_vqs_count(v, argp);
>               break;
>+      case VHOST_VDPA_SUSPEND:
>+              r = vhost_vdpa_suspend(v);
>+              break;
>       default:
>               r = vhost_dev_ioctl(&v->vdev, cmd, argp);
>               if (r == -ENOIOCTLCMD)
>diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
>index cab645d4a645..6d9f45163155 100644
>--- a/include/uapi/linux/vhost.h
>+++ b/include/uapi/linux/vhost.h
>@@ -171,4 +171,18 @@
> #define VHOST_VDPA_SET_GROUP_ASID     _IOW(VHOST_VIRTIO, 0x7C, \
>                                            struct vhost_vring_state)
>
>+/* Suspend or resume a device so it does not process virtqueue requests anymore
>+ *
>+ * After the return of ioctl with suspend != 0, the device must finish any
>+ * pending operations like in flight requests. It must also preserve all the
>+ * necessary state (the virtqueue vring base plus the possible device specific
>+ * states) that is required for restoring in the future. The device must not
>+ * change its configuration after that point.
>+ *
>+ * After the return of ioctl with suspend == 0, the device can continue
>+ * processing buffers as long as typical conditions are met (vq is enabled,
>+ * DRIVER_OK status bit is enabled, etc).
>+ */
>+#define VHOST_VDPA_SUSPEND            _IOW(VHOST_VIRTIO, 0x7D, int)
                                         ^
IIUC we are not using the argument anymore, so this should be changed in
_IO(VHOST_VIRTIO, 0x7D).

And we should update a bit the documentation.

Thanks,
Stefano

