Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8B274C1A05
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 18:42:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243435AbiBWRnW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 12:43:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232539AbiBWRnW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 12:43:22 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0533D4131E
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 09:42:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645638173;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qRjIpFpl+Y8ZaB7CKEGYDkJ5geifVDa7MyqJpWBf+L4=;
        b=HUPm+bE0QDTQhMDELIZs6BnR0/P2kaRMiFQ9wAwPf5mbkOIDpevduxe91h7sT4MV2JfYch
        zsQB1hmKPMvW6KcR7DlsmPrqWKi/V7+KFLb4io+JbRmhXg/YTcp0M33ZRNwFAX4ccTkKVR
        crvzx/0SNpvE9Q2psxE6OlrPhccZADg=
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com
 [209.85.161.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-434-Rwt645YyN3KzbX03QrpILg-1; Wed, 23 Feb 2022 12:42:51 -0500
X-MC-Unique: Rwt645YyN3KzbX03QrpILg-1
Received: by mail-oo1-f69.google.com with SMTP id y77-20020a4a4550000000b0031be0960299so9843679ooa.11
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 09:42:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=qRjIpFpl+Y8ZaB7CKEGYDkJ5geifVDa7MyqJpWBf+L4=;
        b=J5qh7Xwo3LbRZttJoe76xJOpjddZxG+7EmtNrspTUE3pTbgSnvvb77OQaUMPx1C0CM
         pxWjTC/yeQdOga0Q+BDJj7kVbT9a/tXtTsNdUVmcWKrqiBi7N9r15pzuSpU/LP3hsmTA
         3sgnlZdEKwoyAPakTW2tXWSeM+QaHDI5C2jlsc2M3WljSrgjHYLZfPDbXiarbsZBKKfS
         46atNb4PrXvtZ2ez8Vvv1KPH76TmmeKmxyZI3MkShO6uh5zME4+8i5U2sNs3MjA5U/ZZ
         sN6eKt0V9gJTLftwMOzVV3SI6AlAaSYyHw5JHuFrp4p4UPwzbTDXdsKUt1HoaJEEZHhe
         IwMQ==
X-Gm-Message-State: AOAM5339fwnPc4iAhxegYgKYs0N30Hc6CW+2v6Rwaap36rkKGjorp6xq
        SRG4IHb79MttiUgYPEmdBnXRp6vM3kSkMIcXLURfCIl+4SUb6sod44d1/QN6jlOqKs+I7rOZwf7
        i+LIf5o2Kqlq4p0Qy
X-Received: by 2002:a05:6870:6106:b0:d4:473f:7671 with SMTP id s6-20020a056870610600b000d4473f7671mr310496oae.327.1645638170975;
        Wed, 23 Feb 2022 09:42:50 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxq0hTPAXAa/qHrjN+Zp6BCaCXgRevYM49duz7eMMH+DpMmv9okVH5/L0hZhHRf8S2uYX0pUw==
X-Received: by 2002:a05:6870:6106:b0:d4:473f:7671 with SMTP id s6-20020a056870610600b000d4473f7671mr310487oae.327.1645638170742;
        Wed, 23 Feb 2022 09:42:50 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id n11sm125550oal.1.2022.02.23.09.42.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Feb 2022 09:42:50 -0800 (PST)
Date:   Wed, 23 Feb 2022 10:42:48 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     <bhelgaas@google.com>, <jgg@nvidia.com>, <saeedm@nvidia.com>,
        <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>, <ashok.raj@intel.com>, <kevin.tian@intel.com>,
        <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH V8 mlx5-next 10/15] vfio: Extend the device migration
 protocol with RUNNING_P2P
Message-ID: <20220223104248.62b7ad12.alex.williamson@redhat.com>
In-Reply-To: <20220220095716.153757-11-yishaih@nvidia.com>
References: <20220220095716.153757-1-yishaih@nvidia.com>
        <20220220095716.153757-11-yishaih@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 20 Feb 2022 11:57:11 +0200
Yishai Hadas <yishaih@nvidia.com> wrote:
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index 3bbadcdbc9c8..3176cb5d4464 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -33,6 +33,7 @@ struct vfio_device {
>  	struct vfio_group *group;
>  	struct vfio_device_set *dev_set;
>  	struct list_head dev_set_list;
> +	unsigned int migration_flags;

Maybe paranoia, but should we sanity test this in __vfio_register_dev()
to reinforce to driver authors that not all bit combinations are valid?
Thanks,

Alex

