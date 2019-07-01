Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D486E5C4CA
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 23:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbfGAVG4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 17:06:56 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:35858 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726658AbfGAVGz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 17:06:55 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x61L3u9h097818;
        Mon, 1 Jul 2019 21:06:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=6X4vdIlZYMauMJrFIKBO03ACwYmAe7Gd2ZFgeyq8mn4=;
 b=HBjTeM04W+Qwn7uafca3oGtrOzZKYGtKBBqPCyEJIZtipxjw1pKA5vLP28CQSag8gcJs
 AnnZumtoZrZGzdCDnTxtgVXtez4/y8QC2QAlbu9k5a6ABG23NTmX3uwq1iRgstO7WmBl
 bOMdbt9y7dSo/1xOTys3i2lGlPgP/T8TCwMkj1c/qbV+y5HrUxmYFiLYim1uKy/48+jA
 gVhgxBq3dAXvDBxp6YObLKSnwC2NcLaiBg/WzddgNJOmmFrbA09pFJgUXq2rI+HGvCsm
 QjeaI4MkZ5GyhlCtlOj7MEDIU0vh/a40DKN6cs44irLYvmZhKYjen+c7MErfYqj0Qi81 Ug== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2te5tbfy47-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Jul 2019 21:06:53 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x61L3IqZ155933;
        Mon, 1 Jul 2019 21:06:52 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2tebqg53nd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Jul 2019 21:06:52 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x61L6pjg032036;
        Mon, 1 Jul 2019 21:06:51 GMT
Received: from [10.211.54.238] (/10.211.54.238)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 01 Jul 2019 14:06:51 -0700
Subject: Re: [PATCH net-next 3/7] net/rds: Wait for the FRMR_IS_FREE (or
 FRMR_IS_STALE) transition after posting IB_WR_LOCAL_INV
To:     santosh.shilimkar@oracle.com, netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>
References: <505e9af7-a0cd-bf75-4a72-5d883ee06bf1@oracle.com>
 <c79821e0-307c-5736-6eb5-e20983097345@oracle.com>
 <01c251f4-c8f8-fcb8-bccc-341d4a3db90a@oracle.com>
 <b5669540-3892-9d79-85ba-79e96ddd3a81@oracle.com>
From:   Gerd Rausch <gerd.rausch@oracle.com>
Message-ID: <14c34ac2-38ed-9d51-f27d-74120ff34c54@oracle.com>
Date:   Mon, 1 Jul 2019 14:06:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <b5669540-3892-9d79-85ba-79e96ddd3a81@oracle.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9305 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907010245
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9305 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907010245
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Santosh,

On 01/07/2019 14.00, santosh.shilimkar@oracle.com wrote:
>>
> Look for command timeout in CX3 sources. 60 second is upper bound in
> CX3. Its not standard in specs(at least not that I know) though
> and may vary from vendor to vendor.
> 

I am not seeing it. Can you point me to the right place?

% grep -ni timeout drivers/net/ethernet/mellanox/mlx4/*.[ch]
drivers/net/ethernet/mellanox/mlx4/cmd.c:116:	GO_BIT_TIMEOUT_MSECS	= 10000
[...]
drivers/net/ethernet/mellanox/mlx4/mlx4_en.h:101:#define MLX4_EN_WATCHDOG_TIMEOUT	(15 * HZ)
drivers/net/ethernet/mellanox/mlx4/mlx4_en.h:155:#define MLX4_EN_TX_POLL_TIMEOUT	(HZ / 4)
drivers/net/ethernet/mellanox/mlx4/mlx4_en.h:171:#define MLX4_EN_LOOPBACK_TIMEOUT	100
[...]
drivers/net/ethernet/mellanox/mlx4/reset.c:61:#define MLX4_SEM_TIMEOUT_JIFFIES	(10 * HZ)
drivers/net/ethernet/mellanox/mlx4/reset.c:62:#define MLX4_RESET_TIMEOUT_JIFFIES	(2 * HZ)


% grep -i timeout drivers/infiniband/hw/mlx4/*.[ch] 
drivers/infiniband/hw/mlx4/cm.c:42:#define CM_CLEANUP_CACHE_TIMEOUT  (30 * HZ)
[...]
drivers/infiniband/hw/mlx4/mcg.c:46:#define MAD_TIMEOUT_MS	2000
[...]
drivers/infiniband/hw/mlx4/qp.c:4358:		while (wait_for_completion_timeout(&sdrain->done, HZ / 10) <= 0)

Thanks,

  Gerd
