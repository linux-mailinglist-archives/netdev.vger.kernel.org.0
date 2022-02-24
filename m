Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DBF74C2FAF
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 16:31:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236315AbiBXPbU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 10:31:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236287AbiBXPbS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 10:31:18 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2F34B1BE4DE
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 07:30:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645716648;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RJzT5R2+qTnMTOL3dSUfnZD5h7THBicjns5fjqjW5sY=;
        b=el7pADM6wfcCeabf06jAwhivGwNAp64iadaZ9vy3e27zoaxbDlxp/YJEBjrSPRDYd8JDnW
        XcUbQEdALagDldl7axsjoAQp5B3iiAHsYKdBEDdO77LYN+oH5IqMSCaMKD/HWTxyIrihcY
        gvkfM3KlLvp2HOyt7wM4m1MLVDR9GlY=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-601-XSBTbrU_MVGkyuGpNYF78Q-1; Thu, 24 Feb 2022 10:30:46 -0500
X-MC-Unique: XSBTbrU_MVGkyuGpNYF78Q-1
Received: by mail-oi1-f199.google.com with SMTP id ay31-20020a056808301f00b002d06e828c00so1145972oib.2
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 07:30:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=RJzT5R2+qTnMTOL3dSUfnZD5h7THBicjns5fjqjW5sY=;
        b=ZmGpxSe+XAeL5CDDJsDr/Hf/lHraIQkGem9SXT5/ZB9h3DhFzWO/xii3EdsdMUczMt
         5++eRX9hQnX0doBQKyKnU0sgtV9otfdDqndUBwrx4eCUpiT8Jizl1V2ITmLLHGnCVh06
         Sqrr0MdFY9NDymxX9W1zvFzzbyOjaVkT2DZXdfkO7SVeVcy7UKLeGvZanhfqmDS/1AkZ
         4imVzCTc6cxkoi5S5bB0cf5lhQQdWL5d22QlS7+1HdX7iH6SRXAGSyjrZ1pbpV260fjV
         l6KEAXXml9aORr5Idce5qNpJowyhiA4mPlrVDnAAkGcaU6XX15estTdFYnwSZpmaMpYc
         iTFA==
X-Gm-Message-State: AOAM531kJTjxkPW2vd3TKBnpXxVf16bh0EsSHn3QI7Z5Zho+bfwMmwfT
        yhHo8i5Q/3IJ0H0ijdNFP6/1eMkoKhcDWM3+WxmH/gKMJVbKB61iVa5lrBKm9wiR7nsPta3rzPg
        m41HvI1pF8BvzcJxx
X-Received: by 2002:a05:6870:b003:b0:d1:3804:aee2 with SMTP id y3-20020a056870b00300b000d13804aee2mr1344433oae.155.1645716646033;
        Thu, 24 Feb 2022 07:30:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxBicBa9cJ+9uSgbNGbZumW0vECl9F0er2MvXCpgRtdNzkLfhNS/BI1vN3rWb41+5hRT9N5dw==
X-Received: by 2002:a05:6870:b003:b0:d1:3804:aee2 with SMTP id y3-20020a056870b00300b000d13804aee2mr1344428oae.155.1645716645727;
        Thu, 24 Feb 2022 07:30:45 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id f14sm1341562otq.11.2022.02.24.07.30.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Feb 2022 07:30:45 -0800 (PST)
Date:   Thu, 24 Feb 2022 08:30:42 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        jgg@nvidia.com, saeedm@nvidia.com, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, netdev@vger.kernel.org, kuba@kernel.org,
        leonro@nvidia.com, kwankhede@nvidia.com, mgurtovoy@nvidia.com,
        maorg@nvidia.com, ashok.raj@intel.com, kevin.tian@intel.com,
        shameerali.kolothum.thodi@huawei.com
Subject: Re: [PATCH V9 mlx5-next 10/15] vfio: Extend the device migration
 protocol with RUNNING_P2P
Message-ID: <20220224083042.3f5ad059.alex.williamson@redhat.com>
In-Reply-To: <87fso870k8.fsf@redhat.com>
References: <20220224142024.147653-1-yishaih@nvidia.com>
        <20220224142024.147653-11-yishaih@nvidia.com>
        <87fso870k8.fsf@redhat.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 24 Feb 2022 16:21:11 +0100
Cornelia Huck <cohuck@redhat.com> wrote:

> On Thu, Feb 24 2022, Yishai Hadas <yishaih@nvidia.com> wrote:
> 
> > diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> > index 22ed358c04c5..26a66f68371d 100644
> > --- a/include/uapi/linux/vfio.h
> > +++ b/include/uapi/linux/vfio.h
> > @@ -1011,10 +1011,16 @@ struct vfio_device_feature {
> >   *
> >   * VFIO_MIGRATION_STOP_COPY means that STOP, STOP_COPY and
> >   * RESUMING are supported.
> > + *
> > + * VFIO_MIGRATION_STOP_COPY | VFIO_MIGRATION_P2P means that RUNNING_P2P
> > + * is supported in addition to the STOP_COPY states.
> > + *
> > + * Other combinations of flags have behavior to be defined in the future.
> >   */
> >  struct vfio_device_feature_migration {
> >  	__aligned_u64 flags;
> >  #define VFIO_MIGRATION_STOP_COPY	(1 << 0)
> > +#define VFIO_MIGRATION_P2P		(1 << 1)
> >  };  
> 
> Coming back to my argument (for the previous series) that this should
> rather be "at least one of the flags below must be set". If we operate
> under the general assumption that each flag indicates that a certain
> functionality (including some states) is supported, and that flags may
> depend on other flags, we might have a future flag that defines a
> different behaviour, but does not depend on STOP_COPY, but rather
> conflicts with it. We should not create the impression that STOP_COPY
> will neccessarily be mandatory for all time.

This sounds more like an enum than a bitfield.  What happens when
VFIO_MIGRATION_FOO is defined that can be combined with either
STOP_COPY or P2P, do we then add two new enum values, one with, one
without?  Using a bitfield seems cleaner here.  Reporting P2P alone is
invalid because it doesn't provide a sufficient FSM, but we might also
later define STOP_COPYv2 and possibly it might be compatible with the
existing P2P definition.  Thanks,

Alex

