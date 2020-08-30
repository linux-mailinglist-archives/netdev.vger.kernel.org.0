Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 067DD256CB3
	for <lists+netdev@lfdr.de>; Sun, 30 Aug 2020 09:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728623AbgH3H6X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Aug 2020 03:58:23 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:5992 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726201AbgH3H6P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Aug 2020 03:58:15 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07U7vS6c020180;
        Sun, 30 Aug 2020 00:58:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pfpt0220;
 bh=I3A0KA1wyS7iHQUoKaA7YtWH+cpiDkhdBB2gjle8NUE=;
 b=lZL51OkAx9qHvRcGVFFD1caG/vcO5hE6g52FCcCdOjQIIQer/qDTCZ0lXJiJeY+VrCPj
 FNXx8Q9nTZFwUiAVF06nDJEnLJJAJYns5SiwKnf4fxrXQHORaoa58tFXOorZd6syi6MU
 BhKTC9tet0Ms+cbKacf8Ip2FO2CHeR/IoLxUlI7lzsSav9iTPutfNePpDfeQlqtiWgh4
 Q7ZXawGFsnWEoZQ1GZMZQiLnnMbk9jJlgL0nkB8HrxCUf7SaGH5o6pQ6c9n2KyLRzVqf
 Eh69H7DJY4SzM9zf5fUl4FbzOYwVFChGWwzOUPOxOvzbM9sNy3nPDyso0BKeLJd0c72y Dw== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 337phpk5e4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 30 Aug 2020 00:58:08 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 30 Aug
 2020 00:58:07 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 30 Aug
 2020 00:58:05 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 30 Aug 2020 00:58:05 -0700
Received: from [10.193.39.7] (NN-LT0019.marvell.com [10.193.39.7])
        by maili.marvell.com (Postfix) with ESMTP id DF0693F704A;
        Sun, 30 Aug 2020 00:58:02 -0700 (PDT)
Subject: Re: [EXT] [PATCH] bnx2x: correct a mistake when show error code
To:     Yi Li <yili@winhong.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     <yilikernel@gmail.com>, <kuba@kernel.org>, <davem@davemloft.net>,
        GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>,
        "Sudarsana Reddy Kalluru" <skalluru@marvell.com>,
        Ariel Elior <aelior@marvell.com>
References: <20200829103637.1730050-1-yili@winhong.com>
From:   Igor Russkikh <irusskikh@marvell.com>
Message-ID: <3f42d243-dd35-f787-f123-9a2fcb5a9bc8@marvell.com>
Date:   Sun, 30 Aug 2020 10:58:01 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:80.0) Gecko/20100101
 Thunderbird/80.0
MIME-Version: 1.0
In-Reply-To: <20200829103637.1730050-1-yili@winhong.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-29_15:2020-08-28,2020-08-29 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


>  drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c 
> b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c
> index 1426c691c7c4..0346771396ce 100644
> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c
> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c
> @@ -13562,9 +13560,8 @@ static int bnx2x_ext_phy_common_init(struct bnx2x 
> *bp, u32 shmem_base_path[],
>  	}
> 
>  	if (rc)
> -		netdev_err(bp->dev,  "Warning: PHY was not initialized,"
> -				      " Port %d\n",
> -			 0);
> +		netdev_err(bp->dev, "Warning: PHY was not initialized, Port %d\n",
> +			   rc);
>  	return rc;

Hi Yi,

Thanks, but if you want to report rc in this trace - then state "rc = %d"
explicitly in the string. Because now its "Port %d" but you put error code in
there...

Thanks,
   Igor
