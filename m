Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27FDD360AFE
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 15:48:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233194AbhDONtQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 09:49:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28774 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233234AbhDONtI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 09:49:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618494525;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QwQaOKgb78JkHs6ad6W1DSo80pvudYA+6ShjnGRvp3I=;
        b=hA8EwXySYbWglOJaesyraxkJamd8LH/Rw1zUkykC/S7i28pe6kGsgRlIffgB8f6OA2AR5y
        1/ZQLSxObrVZ2n4FZUjL6t7F++zkq4r0N2XSXgwzOoM/0GxmIrrkViUVjQLXYblG4VOj5R
        dMIoxQYmZvF5I8SrDHJ+LFfZUukzHyg=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-189-HiO_eUeUM3-0xWVqGDYl3A-1; Thu, 15 Apr 2021 09:48:43 -0400
X-MC-Unique: HiO_eUeUM3-0xWVqGDYl3A-1
Received: by mail-ed1-f71.google.com with SMTP id ay2-20020a0564022022b02903824b52f2d8so5231862edb.22
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 06:48:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QwQaOKgb78JkHs6ad6W1DSo80pvudYA+6ShjnGRvp3I=;
        b=ORoHfiwGmhBdqXRDOijzi40Y166bm8b1BxXGnCOSgW1IaluimJ1A6i6OqeUdwPggKY
         2yqEB7KFfsKTDuhZL+WCLCDWhpsHOOimixh8e4HdnnWSY3RlEs8tidNuuEQ6WhtA1jac
         FxOytx2LR3OwsbprN7wqu4x4iuPGjS/pgA3Cv+exMlO9hn7MLCpuvkc2405pLs+PeYFS
         FyJKF2VdPEjkX7vHzrKOY/8Pn/917xnwkTmo5kDgzL2oOb1sTy/3QdBM9epiVf1898b1
         n2HUuuRmbJqEO7sAmmN2pOAxfP6pAqvMxOecmrzozmXMky8LcMu11W0Bltqq4LOOYmia
         JrHw==
X-Gm-Message-State: AOAM531jo/q0k+JsgsR0vwwiSaLRb92LOFxuyxNPoRiw/4jpHEb1pW6m
        lKA0GqmEZUWhR4oOrMQk4iiIGZoJMS+x/g6cowZjof8bg2N7Ki+roNNSvaCzG+KmkvvPk+Vpt6Z
        QdTcJxCiUdBmrTxF/
X-Received: by 2002:a05:6402:270e:: with SMTP id y14mr4333834edd.283.1618494522352;
        Thu, 15 Apr 2021 06:48:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxOtgD4WdYc2KT9f0JKG73xwBG/uagcBhRoEFoQdUeQykyoHKeWJx+aqlCXoC29Ap77HRT5+Q==
X-Received: by 2002:a05:6402:270e:: with SMTP id y14mr4333823edd.283.1618494522219;
        Thu, 15 Apr 2021 06:48:42 -0700 (PDT)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id df8sm2608432edb.4.2021.04.15.06.48.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 06:48:41 -0700 (PDT)
Date:   Thu, 15 Apr 2021 15:48:38 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     jasowang@redhat.com, mst@redhat.com, lulu@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 3/3] vDPA/ifcvf: get_config_size should return dev
 specific config size
Message-ID: <20210415134838.3hn33estolycag4p@steredhat>
References: <20210415095336.4792-1-lingshan.zhu@intel.com>
 <20210415095336.4792-4-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210415095336.4792-4-lingshan.zhu@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 15, 2021 at 05:53:36PM +0800, Zhu Lingshan wrote:
>get_config_size() should return the size based on the decected
>device type.
>
>Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>---
> drivers/vdpa/ifcvf/ifcvf_main.c | 18 +++++++++++++++++-
> 1 file changed, 17 insertions(+), 1 deletion(-)
>
>diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
>index cea1313b1a3f..6844c49fe1de 100644
>--- a/drivers/vdpa/ifcvf/ifcvf_main.c
>+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
>@@ -347,7 +347,23 @@ static u32 ifcvf_vdpa_get_vq_align(struct vdpa_device *vdpa_dev)
>
> static size_t ifcvf_vdpa_get_config_size(struct vdpa_device *vdpa_dev)
> {
>-	return sizeof(struct virtio_net_config);
>+	struct ifcvf_adapter *adapter = vdpa_to_adapter(vdpa_dev);
>+	struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
>+	struct pci_dev *pdev = adapter->pdev;
>+	size_t size;
>+
>+	if (vf->dev_type == VIRTIO_ID_NET)
>+		size = sizeof(struct virtio_net_config);
>+
>+	else if (vf->dev_type == VIRTIO_ID_BLOCK)
>+		size = sizeof(struct virtio_blk_config);
>+
>+	else {
>+		size = 0;
>+		IFCVF_ERR(pdev, "VIRTIO ID %u not supported\n", vf->dev_type);
>+	}

I slightly prefer the switch, but I don't have a strong opinion.

However, if we want to use if/else, we should follow 
`Documentation/process/coding-style.rst` line 166:
     Note that the closing brace is empty on a line of its own, **except** in
     the cases where it is followed by a continuation of the same statement,
     ie a ``while`` in a do-statement or an ``else`` in an if-statement, like

also `scripts/checkpatch.pl --strict` complains:

     CHECK: braces {} should be used on all arms of this statement
     #209: FILE: drivers/vdpa/ifcvf/ifcvf_main.c:355:
     +	if (vf->dev_type == VIRTIO_ID_NET)
     [...]
     +	else if (vf->dev_type == VIRTIO_ID_BLOCK)
     [...]
     +	else {
     [...]

     CHECK: Unbalanced braces around else statement
     #215: FILE: drivers/vdpa/ifcvf/ifcvf_main.c:361:
     +	else {

Thanks,
Stefano

