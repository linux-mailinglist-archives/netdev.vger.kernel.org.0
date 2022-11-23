Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 032F3634FCB
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 06:51:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235405AbiKWFvW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 00:51:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiKWFvV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 00:51:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F21FAF240B
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 21:50:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669182625;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JMYYiLCaB4GLtGxeCjzuDietMKLoY1I6jUe2ofSKrOo=;
        b=elUT7esQ7gat9NqRO20eXE+pUm92SbeHujAPS216ya1tydquDIxurVKiH7GVU10p6IHDM6
        y8AsU2oUgOL6Dz836NCI2n7ex1gkxXs4IBRenSIbPw0lQMAjD8kYmgRFc0Vjw3iA1LGMzP
        YbJQhWZPQotHSLWgbrSbggdNIfgkrSs=
Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com
 [209.85.160.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-299-fQona7rPPUmYyYyMBlfjlQ-1; Wed, 23 Nov 2022 00:50:21 -0500
X-MC-Unique: fQona7rPPUmYyYyMBlfjlQ-1
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-143248a54e5so993804fac.3
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 21:50:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JMYYiLCaB4GLtGxeCjzuDietMKLoY1I6jUe2ofSKrOo=;
        b=LBA4inY+4GbfLW0QXOu9/Dg29MxlehjMvwBJpT4DEuYp+hBat0tux10tGO9Nkh5MgW
         zVzIranMfEsxp+Xm1wUc50rdD84Yf161IWlHTE0JG8/OFHaaTpxK7nWcXSmukSg27EFX
         UAZ+gLaOZf+F/k5aFOdxbBTvdU2Ir1vOEXXXIfFBRy0befXj/nmCqPOVNOvp5X49KNbQ
         ZkC3QUTPezRu8VxsLBhQM4xRnCtn0RtFRp2o1ydDuleE6cEAIrplkfbEXt9Df40Rb4u6
         hThU3chBWzfCkmSRz1Wx3Mmn7gmSrOo+JLEVaLRekSQLF1pL3aG64XFFp5bTDOzOnpwH
         wRQA==
X-Gm-Message-State: ANoB5pmYBH4G8ZUz5YOesWiAGe1Q6Dgcfsjb9qSCuA31SUnvDIqAfU29
        9SvKoftxNdtQdk6zmkwCzqdOpv1/Z3ZkrfiKiDAK2Y2OVc5hGWDG8vgH04XL6TSO7bgVkgvQKLC
        kqKVun5PaoSRW+GCdNJWwsEvyPZHPN37+
X-Received: by 2002:a05:6808:220b:b0:359:f5eb:82ec with SMTP id bd11-20020a056808220b00b00359f5eb82ecmr3268509oib.280.1669182620983;
        Tue, 22 Nov 2022 21:50:20 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4vUhvThjDXaYE0H+SpEJoxdmzmzDcZ/Xy2YPmdtfAXLakXiJ77qJrY4aA4PeK9ennZJJLXUGcaAYCvf5J5/sc=
X-Received: by 2002:a05:6808:220b:b0:359:f5eb:82ec with SMTP id
 bd11-20020a056808220b00b00359f5eb82ecmr3268502oib.280.1669182620811; Tue, 22
 Nov 2022 21:50:20 -0800 (PST)
MIME-Version: 1.0
References: <20221117033303.16870-1-jasowang@redhat.com> <f9b35219-ba26-1251-5c78-d96ac91b0995@kernel.org>
In-Reply-To: <f9b35219-ba26-1251-5c78-d96ac91b0995@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 23 Nov 2022 13:50:09 +0800
Message-ID: <CACGkMEv+LiT_pH9Km5_OW3EpdOoh7ifM85KwLog570hPAQBsqQ@mail.gmail.com>
Subject: Re: [PATCH V2] vdpa: allow provisioning device features
To:     David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        si-wei.liu@oracle.com, mst@redhat.com, eperezma@redhat.com,
        lingshan.zhu@intel.com, elic@nvidia.com
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

On Wed, Nov 23, 2022 at 3:53 AM David Ahern <dsahern@kernel.org> wrote:
>
> On 11/16/22 8:33 PM, Jason Wang wrote:
> > diff --git a/vdpa/include/uapi/linux/vdpa.h b/vdpa/include/uapi/linux/vdpa.h
> > index 94e4dad1..7c961991 100644
> > --- a/vdpa/include/uapi/linux/vdpa.h
> > +++ b/vdpa/include/uapi/linux/vdpa.h
> > @@ -51,6 +51,7 @@ enum vdpa_attr {
> >       VDPA_ATTR_DEV_QUEUE_INDEX,              /* u32 */
> >       VDPA_ATTR_DEV_VENDOR_ATTR_NAME,         /* string */
> >       VDPA_ATTR_DEV_VENDOR_ATTR_VALUE,        /* u64 */
> > +     VDPA_ATTR_DEV_FEATURES,                 /* u64 */
> >
> >       /* new attributes must be added above here */
> >       VDPA_ATTR_MAX,
>
> this header file already has:
>         ...
>         VDPA_ATTR_DEV_QUEUE_INDEX,              /* u32 */
>         VDPA_ATTR_DEV_VENDOR_ATTR_NAME,         /* string */
>         VDPA_ATTR_DEV_VENDOR_ATTR_VALUE,        /* u64 */
>
>         VDPA_ATTR_DEV_FEATURES,                 /* u64 */
>
>         /* virtio features that are supported by the vDPA device */
>         VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES,  /* u64 */
>
>         /* new attributes must be added above here */
>         VDPA_ATTR_MAX,
>
> in which case your diff is not needed. More importantly it raises
> questions about the status of the uapi file (is it correct as is or is
> an update needed) and which tree you are creating patches against?

I'm using git://git.kernel.org/pub/scm/network/iproute2/iproute2 main.
But I don't pull the new codes before sending the patches. Will fix
this.

>
> > @@ -615,8 +640,9 @@ static int cmd_mgmtdev(struct vdpa *vdpa, int argc, char **argv)
> >  static void cmd_dev_help(void)
> >  {
> >       fprintf(stderr, "Usage: vdpa dev show [ DEV ]\n");
> > -     fprintf(stderr, "       vdpa dev add name NAME mgmtdev MANAGEMENTDEV [ mac MACADDR ] [ mtu MTU ]\n");
> > -     fprintf(stderr, "                                                    [ max_vqp MAX_VQ_PAIRS ]\n");
> > +     fprintf(stderr, "       vdpa dev add name NAME mgmtdevMANAGEMENTDEV [ device_features DEVICE_FEATURES]\n");
>
> lost the space between mgmtdev and MANAGEMENTDEV

Will fix it.

Thanks

>
>
> > +     fprintf(stderr, "                                                   [ mac MACADDR ] [ mtu MTU ]\n");
> > +     fprintf(stderr, "                                                   [ max_vqp MAX_VQ_PAIRS ]\n");
> >       fprintf(stderr, "       vdpa dev del DEV\n");
> >       fprintf(stderr, "Usage: vdpa dev config COMMAND [ OPTIONS ]\n");
> >       fprintf(stderr, "Usage: vdpa dev vstats COMMAND\n");
>

