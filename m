Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3FE341B847
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 22:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242722AbhI1UYP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 16:24:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40259 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233437AbhI1UYO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 16:24:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632860554;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Px75PZplZbEMaaLvg/IKZKQmq+Fd+/Xi4N5X7tKeYOU=;
        b=hDRxPRXumIYPR1DK0A9FEGFhwFgxHVce5YYq77E7VEGK4fn+FISgvRanGlsNBmXxoKkyHD
        ow6i7wM8sD1FfzyLAFcIm1GpZgIPZ3k/9aNri6szwh6Pg0p83cCFbC8kRMJ0n/mkKBYCZX
        9lqF1lPCuoMfnjZRf/RqBZE0RBORQvM=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-513-ORRnpxrNOa29ISZ11eWlZQ-1; Tue, 28 Sep 2021 16:22:33 -0400
X-MC-Unique: ORRnpxrNOa29ISZ11eWlZQ-1
Received: by mail-oi1-f197.google.com with SMTP id n26-20020a05680803ba00b002695053b627so33044oie.3
        for <netdev@vger.kernel.org>; Tue, 28 Sep 2021 13:22:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Px75PZplZbEMaaLvg/IKZKQmq+Fd+/Xi4N5X7tKeYOU=;
        b=t1yjrxYCBcevI4EFw7vU4bfnirnGfnlTKU7kUths5VTLAygsCbT3QOSe1cQkUiesCT
         YNGbbGi2JFwTsTbeNrpKXHT7H0IcbH0y+5xtakgzSMRrTHdh2AtZxuyhwhoUsVdor1sZ
         9vEbOTdge8G07hkjr2YigRGJdw2rd8wt1PNS+PtG4Lm3FGWksZWSyEnheKyWY8VICM3f
         aLR+n8L0EJYULMkVFU5DqIL8okNzyh31KWAjel4vebtnm3vAVQvG3fE9Kaem/4OK+QOG
         JPCDOsdeMcxFj5QNL0sgCqfaFLB+vMxrUa5O3R4wUpZpWGs/tlkbCXlTmInpGZDf04Zr
         Eckg==
X-Gm-Message-State: AOAM5324kJz4MA/N7UTiU+tuueMOZp6RekfuHkxqUEWWg1+MMZ5VRPDm
        HL9ZeP4sqi9fxQc1EWOi3s1KWga/B5BFmg4f4A4cbD9qLqjDcZepy0Xq51fviUJPZM1eCnWQeUs
        St6GLeIC4PcrBjwxU
X-Received: by 2002:a05:6830:314e:: with SMTP id c14mr6935950ots.37.1632860552497;
        Tue, 28 Sep 2021 13:22:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzR8N6ivbHyTQeeTuTu5EyUCFoNeJ/uw+Yu3F+JZpS9o76cUotJSm8am7W0TX6GQTPc2NRTNg==
X-Received: by 2002:a05:6830:314e:: with SMTP id c14mr6935926ots.37.1632860552311;
        Tue, 28 Sep 2021 13:22:32 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id 21sm41504oix.1.2021.09.28.13.22.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Sep 2021 13:22:32 -0700 (PDT)
Date:   Tue, 28 Sep 2021 14:22:30 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH mlx5-next 6/7] mlx5_vfio_pci: Expose migration commands
 over mlx5 device
Message-ID: <20210928142230.20b0153a.alex.williamson@redhat.com>
In-Reply-To: <7fc0cf0d76bb6df4679b55974959f5494e48f54d.1632305919.git.leonro@nvidia.com>
References: <cover.1632305919.git.leonro@nvidia.com>
        <7fc0cf0d76bb6df4679b55974959f5494e48f54d.1632305919.git.leonro@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Sep 2021 13:38:55 +0300
Leon Romanovsky <leon@kernel.org> wrote:

> From: Yishai Hadas <yishaih@nvidia.com>
> 
> Expose migration commands over the device, it includes: suspend, resume,
> get vhca id, query/save/load state.
> 
> As part of this adds the APIs and data structure that are needed to
> manage the migration data.
> 
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  drivers/vfio/pci/mlx5_vfio_pci_cmd.c | 358 +++++++++++++++++++++++++++
>  drivers/vfio/pci/mlx5_vfio_pci_cmd.h |  43 ++++
>  2 files changed, 401 insertions(+)
>  create mode 100644 drivers/vfio/pci/mlx5_vfio_pci_cmd.c
>  create mode 100644 drivers/vfio/pci/mlx5_vfio_pci_cmd.h

Should we set the precedent of a vendor sub-directory like we have
elsewhere?  Either way I'd like to see a MAINTAINERS file update for the
new driver.  Thanks,

Alex

