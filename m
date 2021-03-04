Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E023132DAB6
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 20:59:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237009AbhCDT7Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 14:59:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236228AbhCDT7N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 14:59:13 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79F2BC061756;
        Thu,  4 Mar 2021 11:58:33 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id u125so10843007wmg.4;
        Thu, 04 Mar 2021 11:58:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ufO59/K3ib2osgQjLy4qf9rcrYtYFA8DbgdmA9HSULY=;
        b=LKbzn1c08HAvcPo24SBUhPtBSfAAsG1CJNYoXuZUdp2+xtnXl4pjNE/rpFRyExt6FC
         cnLiwu5s3AEzZ32fU9q5pLyzMMId0b90TuTMcdO/Ldb3mO3zDNcW+wlohUScoxf0qEY8
         Xxb6kYy9NGrvUbU+23o8BpaAb6unEcgXvVir6UdS1GeS2HCy4wWmB1ROw2KLW3rsK8LY
         lp8VvFspCsWder+pUMCFeGF0J23Ltkxco+tBX6AHKkuE0prfO9i8r8omKsdbYjHmi4vg
         JvE1ImD/mm5qPOzpTAcmpciJnT413Znpxu4Ytrv7f7riR8zHlCOguC+slcF0qTrWBXw4
         BlkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ufO59/K3ib2osgQjLy4qf9rcrYtYFA8DbgdmA9HSULY=;
        b=XSHumuzoax8THHQ1NzSzyilvReVRRL5WlceoUomPFSlxldbbVayybttkQ/LbB8Nex7
         NIGOi7Fy3rK9yyYfM4wAkgcTBPkPvu6pIwDIpO5MVO+9nopDDGLzxSekX2pDo0txsm6X
         JDsE8zj85t3Bq2BOQeXf7d37/GBuTFnrjunUroRTwVALH3wngPVtpOOJaE/kiozbZHBp
         aeX0nvJ587zmSDH31oegbejYgsiACf4Ka7SdYo1kkHEQ7Sv4w7mmYwcAsnqJCzp1neX9
         j2O7JuFQXm7YWl/sXGCP+ERZOFK3Wsu6t/tPFwCz2bjgyQgh8qXE9ujRuIb/IbEKSXRh
         /gkw==
X-Gm-Message-State: AOAM530yWMfvH2bLBdTu1z3HC+cZ7wgyJgYdWSTj1OwUZ+NHPzIE42fW
        X/XxuT80GioxNW33Z401OFBHXe0HunV1zA==
X-Google-Smtp-Source: ABdhPJwAERYGeI7ldiKI+/ZMbOlbRXBPJZPsgnfu/H+Fy60UEDvzWdTpT6MlRXS1pu9emJ03pOR8bw==
X-Received: by 2002:a05:600c:2215:: with SMTP id z21mr5000708wml.86.1614887911924;
        Thu, 04 Mar 2021 11:58:31 -0800 (PST)
Received: from ?IPv6:2003:ea:8f1f:bb00:f14c:f8a9:e599:34af? (p200300ea8f1fbb00f14cf8a9e59934af.dip0.t-ipconnect.de. [2003:ea:8f1f:bb00:f14c:f8a9:e599:34af])
        by smtp.googlemail.com with ESMTPSA id j125sm716630wmb.44.2021.03.04.11.58.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Mar 2021 11:58:31 -0800 (PST)
Subject: Re: [PATCH] net: mellanox: mlx5: fix error return code in
 mlx5_fpga_device_start()
To:     Jia-Ju Bai <baijiaju1990@gmail.com>, borisp@nvidia.com,
        saeedm@nvidia.com, leon@kernel.org, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210304141814.8508-1-baijiaju1990@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <cac36164-c8d3-415e-ca43-20b16b57b3fc@gmail.com>
Date:   Thu, 4 Mar 2021 20:58:24 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210304141814.8508-1-baijiaju1990@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04.03.2021 15:18, Jia-Ju Bai wrote:
> When mlx5_is_fpga_lookaside() returns a non-zero value, no error 
> return code is assigned.
> To fix this bug, err is assigned with -EINVAL as error return code.
> 
To me it looks like the current behavior is intentional.
Did you verify that it's actually an error condition if the
function returns true? Please don't blindly trust such code checkers.

> Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/fpga/core.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/core.c b/drivers/net/ethernet/mellanox/mlx5/core/fpga/core.c
> index 2ce4241459ce..c9e6da97126f 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/core.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/core.c
> @@ -198,8 +198,10 @@ int mlx5_fpga_device_start(struct mlx5_core_dev *mdev)
>  	mlx5_fpga_info(fdev, "FPGA card %s:%u\n", mlx5_fpga_name(fpga_id), fpga_id);
>  
>  	/* No QPs if FPGA does not participate in net processing */
> -	if (mlx5_is_fpga_lookaside(fpga_id))
> +	if (mlx5_is_fpga_lookaside(fpga_id)) {
> +		err = -EINVAL;
>  		goto out;
> +	}
>  
>  	mlx5_fpga_info(fdev, "%s(%d): image, version %u; SBU %06x:%04x version %d\n",
>  		       mlx5_fpga_image_name(fdev->last_oper_image),
> 

