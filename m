Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E46835C6B7
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 14:49:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241485AbhDLMuA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 08:50:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:39832 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238534AbhDLMt7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 08:49:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618231780;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9C/cD8P3IrDuK2NZ6oucMLdIewXV7K4I9kOUr8VG5sI=;
        b=J1JfqPG47p1x6ALVBZji1OlyCMpjsGOyK01rKN08PBREy6OhzvOdUuPqomTWk1qK+2D99x
        fnPZiv4oBJUsd0MUT7hwL/jhlhA1OyTmVu4XZ0TBqwbvfhifQyPs25RyqBGO+KKJ/xNemJ
        gdvh4BYU73pC6FR+tSSiT9CAk7qY4cs=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-506-FrS-CHtqO36Ccki8Y045xg-1; Mon, 12 Apr 2021 08:49:39 -0400
X-MC-Unique: FrS-CHtqO36Ccki8Y045xg-1
Received: by mail-ed1-f70.google.com with SMTP id r12so3154155eds.15
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 05:49:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9C/cD8P3IrDuK2NZ6oucMLdIewXV7K4I9kOUr8VG5sI=;
        b=K5bdVRCO8+Kl3ciaLYzeevp5DId6VtUxioHE0X1Ui2KiLWyFn6Xf5SjHgWcbr2MXo5
         mqxUi1Cd82msHhikMqeda+sApUzPAzu+SfL+vBogULMURoewAK5CfZgNRmBLMD7/7QUD
         z6PaiQzg/3/x62MxHmiwTOepGZGeYmiOul+KfQzotY4VMjpMozu4GIm3SOfBkHyedP/c
         w9jqyPpdY5XCVvmDCk7Fc4RD8D2A0QXp1WFzRTyrtWjzg1sVURmubptYRxDz32nxAxgV
         p6BABzYmw13qs2Y29CgIwvmQ91uYpneYaN7m74WguCtkxGYTFVqSkd0fkNBNfgw5p2R+
         1u/g==
X-Gm-Message-State: AOAM530f6z+pnYqhh6Po1nK1D/UrIivvqZ0ThTJFnKoJgb4lO0lgRDt1
        W2PXySd2UbNRc1ADQB5qAamI76kYIivC4CM7/atiwHJsxbaTjmA/3NgUzxCP6cqSMWGac9SP14l
        xTIBzqbauLQg5byZL
X-Received: by 2002:a17:907:2da7:: with SMTP id gt39mr26876323ejc.193.1618231778004;
        Mon, 12 Apr 2021 05:49:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy9TAigsm6UebpwTlyCIPnqI/8fvxuiuivYYglIeM/jT9AIMxLlEwKdWU424VxLaXfSrQdHKQ==
X-Received: by 2002:a17:907:2da7:: with SMTP id gt39mr26876310ejc.193.1618231777810;
        Mon, 12 Apr 2021 05:49:37 -0700 (PDT)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id u19sm6688595edy.23.2021.04.12.05.49.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 05:49:37 -0700 (PDT)
Date:   Mon, 12 Apr 2021 14:49:35 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Eli Cohen <elic@nvidia.com>
Cc:     mst@redhat.com, jasowang@redhat.com, si-wei.liu@oracle.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] vdpa/mlx5: Set err = -ENOMEM in case dma_map_sg_attrs
 fails
Message-ID: <20210412124935.jtguuf7dj74eezcw@steredhat>
References: <20210411083646.910546-1-elic@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210411083646.910546-1-elic@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 11, 2021 at 11:36:46AM +0300, Eli Cohen wrote:
>Set err = -ENOMEM if dma_map_sg_attrs() fails so the function reutrns
>error.
>
>Fixes: 94abbccdf291 ("vdpa/mlx5: Add shared memory registration code")
>Signed-off-by: Eli Cohen <elic@nvidia.com>
>Reported-by: kernel test robot <lkp@intel.com>
>Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
>---
> drivers/vdpa/mlx5/core/mr.c | 4 +++-
> 1 file changed, 3 insertions(+), 1 deletion(-)
>
>diff --git a/drivers/vdpa/mlx5/core/mr.c b/drivers/vdpa/mlx5/core/mr.c
>index 3908ff28eec0..800cfd1967ad 100644
>--- a/drivers/vdpa/mlx5/core/mr.c
>+++ b/drivers/vdpa/mlx5/core/mr.c
>@@ -278,8 +278,10 @@ static int map_direct_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_direct_mr
> 	mr->log_size = log_entity_size;
> 	mr->nsg = nsg;
> 	mr->nent = dma_map_sg_attrs(dma, mr->sg_head.sgl, mr->nsg, DMA_BIDIRECTIONAL, 0);
>-	if (!mr->nent)
>+	if (!mr->nent) {
>+		err = -ENOMEM;
> 		goto err_map;
>+	}
>
> 	err = create_direct_mr(mvdev, mr);
> 	if (err)
>-- 
>2.30.1
>

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

