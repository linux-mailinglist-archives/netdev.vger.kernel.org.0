Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4C9F56B891
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 13:32:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237215AbiGHL3U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 07:29:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237642AbiGHL3Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 07:29:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 99AE1951C8
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 04:29:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657279751;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pQ8hI7tAToAaGENhoelGGeUPhfdGj6ZA32YUdh4TI7g=;
        b=erkHckSpTKhpr3t0qW94EHRpsmCPPtbrmrsqXpiBthAe4QP/p3E4q/XPrjVYVwx130f7Rc
        2VknINL9mefRysoZWsb1ApWNaGImjNDkdsCSGhITzy3Q68dTfK1w4pRhKg4+Pngo1l/6ql
        MWysHNtCuLjaX2PykKxVSPfTH9uhBHY=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-330-el9q19J_MMGraRXbqvdS6Q-1; Fri, 08 Jul 2022 07:29:04 -0400
X-MC-Unique: el9q19J_MMGraRXbqvdS6Q-1
Received: by mail-qk1-f198.google.com with SMTP id k190-20020a37bac7000000b006af6d953751so20781003qkf.13
        for <netdev@vger.kernel.org>; Fri, 08 Jul 2022 04:29:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=pQ8hI7tAToAaGENhoelGGeUPhfdGj6ZA32YUdh4TI7g=;
        b=f/ka8pVSbU77/08QRCIzTHdT6q2A1RSnnh4rqOTFIhRFepUuGYq+kc/7bi0rWdVbyp
         05MvT68cAyIa3slv3KaE9UH85Lmd/cvKPT0FqGn8lqmfVHVfxTAMggVhFs0zdYr7k8fL
         MeZQAwSlvzZyNUpbPJ4nmsOAK+fm7MK35cGd4FlCW4kuUpDxGgilj+Kp19KC/uuWiJQp
         grCszVIhgd2+ZVLhU3vIBHhIcw1sRMRxUwv6ycuWsI7xLlCzpi6/NfhbirmqhOfLRdj/
         yAxEWjM5+IpLsq1dWDRtl9aK7YC3NS5llqh45hkfYCpDuIYBz9pmB8Hwg4SLXOyjNjEg
         o2Sg==
X-Gm-Message-State: AJIora+BbmUk4Qfh4MSl5OUdU3yTc7Xm3kxkne8C1uV3tzrznM+g0l96
        eLbHJGt/f3HCyGxgFKtyfpiMprlRbpTpmHZRIJqy75ShCRLdhrIf/0ANzRAS1XKzDK3wavI+2sU
        AdD/GXCa+jnL4LQFO3EFvHlAkhkzqlKaJ
X-Received: by 2002:ac8:5dca:0:b0:31e:85b8:8a18 with SMTP id e10-20020ac85dca000000b0031e85b88a18mr2366803qtx.370.1657279744183;
        Fri, 08 Jul 2022 04:29:04 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sentVPmK5WEA4lrN7utaqjkf+t27q8DqhRdkX0cZZhMbHLJdy+uMh1/O3NgdOS4+jT1HeWza8vKer/xm5M1KI=
X-Received: by 2002:ac8:5dca:0:b0:31e:85b8:8a18 with SMTP id
 e10-20020ac85dca000000b0031e85b88a18mr2366771qtx.370.1657279743969; Fri, 08
 Jul 2022 04:29:03 -0700 (PDT)
MIME-Version: 1.0
References: <20220623160738.632852-1-eperezma@redhat.com> <20220623160738.632852-2-eperezma@redhat.com>
 <20220628133955.sj32sfounu4byggl@sgarzare-redhat>
In-Reply-To: <20220628133955.sj32sfounu4byggl@sgarzare-redhat>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Fri, 8 Jul 2022 13:28:27 +0200
Message-ID: <CAJaqyWcHoB6edp3Qq8Df75Si_6aBDN=qp9ggB2D5hsshCxOdjQ@mail.gmail.com>
Subject: Re: [PATCH v6 1/4] vdpa: Add suspend operation
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>, Jason Wang <jasowang@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        kvm list <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Cindy Lu <lulu@redhat.com>,
        "Kamde, Tanuj" <tanuj.kamde@amd.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        "Uminski, Piotr" <Piotr.Uminski@intel.com>,
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 28, 2022 at 3:40 PM Stefano Garzarella <sgarzare@redhat.com> wr=
ote:
>
> On Thu, Jun 23, 2022 at 06:07:35PM +0200, Eugenio P=C3=A9rez wrote:
> >This operation is optional: It it's not implemented, backend feature bit
> >will not be exposed.
> >
> >Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> >---
> > include/linux/vdpa.h | 4 ++++
> > 1 file changed, 4 insertions(+)
> >
> >diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
> >index 7b4a13d3bd91..d282f464d2f1 100644
> >--- a/include/linux/vdpa.h
> >+++ b/include/linux/vdpa.h
> >@@ -218,6 +218,9 @@ struct vdpa_map_file {
> >  * @reset:                    Reset device
> >  *                            @vdev: vdpa device
> >  *                            Returns integer: success (0) or error (< =
0)
> >+ * @suspend:                  Suspend or resume the device (optional)
>                                             ^
> IIUC we removed the resume operation (that should be done with reset),
> so should we update this documentation?
>

Totally, I forgot to update the doc. I'll send a new version with that.

Thanks!


> Thanks,
> Stefano
>
> >+ *                            @vdev: vdpa device
> >+ *                            Returns integer: success (0) or error (< =
0)
> >  * @get_config_size:          Get the size of the configuration space i=
ncludes
> >  *                            fields that are conditional on feature bi=
ts.
> >  *                            @vdev: vdpa device
> >@@ -319,6 +322,7 @@ struct vdpa_config_ops {
> >       u8 (*get_status)(struct vdpa_device *vdev);
> >       void (*set_status)(struct vdpa_device *vdev, u8 status);
> >       int (*reset)(struct vdpa_device *vdev);
> >+      int (*suspend)(struct vdpa_device *vdev);
> >       size_t (*get_config_size)(struct vdpa_device *vdev);
> >       void (*get_config)(struct vdpa_device *vdev, unsigned int offset,
> >                          void *buf, unsigned int len);
> >--
> >2.31.1
> >
>

