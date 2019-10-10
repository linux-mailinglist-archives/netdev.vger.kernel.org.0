Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A87C3D24FB
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 11:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389453AbfJJIwL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 04:52:11 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:48904 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390209AbfJJIwI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 04:52:08 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9A8hf1M171675;
        Thu, 10 Oct 2019 08:52:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=G0KsV1YxbVFGrkZatR+VCZvWIuzuocCgwD5kF42g0f0=;
 b=M4BS0+tPoSTzkf49boQcsxdnt4/vqXWQQn7l13mMQwFAmohAyMoS/uLFd6f9CGW/4HQF
 cd3TtsyZqi784lsMp3UEVhMiWjC8IP7sEu6N/5DItKA6nH/BlUvqdoJaPzEb7Dl661Hz
 6LDeOGftOpW833nzoBhpGfbh5toOyh77Q/UAgnYXroHuq6I7N+wZ+M8aVdoHs11lK5v5
 9f6Ve86+heFVaXc+iUogC8adP1QkLtzPxu4f5cc7j0jy4aq6MNBcPkIHuXdL6I9DUsR6
 2xIAq+3ob2yvMs7SdDsrnufU7zv90O5GnoYu6bEazghtIIzFFVBR3yH0T+0TMRW47AGQ bA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2vejkustce-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Oct 2019 08:52:01 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9A8m98r066979;
        Thu, 10 Oct 2019 08:52:00 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2vhrxd8f02-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Oct 2019 08:52:00 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9A8pxjN002980;
        Thu, 10 Oct 2019 08:51:59 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 10 Oct 2019 01:51:57 -0700
Date:   Thu, 10 Oct 2019 11:51:49 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Jules Irenge <jbi.octave@gmail.com>
Cc:     outreachy-kernel@googlegroups.com, devel@driverdev.osuosl.org,
        grekh@linuxfoundation.org, GR-Linux-NIC-Dev@marvell.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: qlge: Fix multiple assignments warning by
 splitting the assignement into two each
Message-ID: <20191010085048.GC20470@kadam>
References: <20191009201029.7051-1-jbi.octave@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191009201029.7051-1-jbi.octave@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9405 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=965
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910100081
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9405 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910100081
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 09, 2019 at 09:10:29PM +0100, Jules Irenge wrote:
> Fix multiple assignments warning " check
>  issued by checkpatch.pl tool:
> "CHECK: multiple assignments should be avoided".
> 
> Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
> ---
>  drivers/staging/qlge/qlge_dbg.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/qlge/qlge_dbg.c b/drivers/staging/qlge/qlge_dbg.c
> index 086f067fd899..69bd4710c5ec 100644
> --- a/drivers/staging/qlge/qlge_dbg.c
> +++ b/drivers/staging/qlge/qlge_dbg.c
> @@ -141,8 +141,10 @@ static int ql_get_serdes_regs(struct ql_adapter *qdev,
>  	u32 *direct_ptr, temp;
>  	u32 *indirect_ptr;
>  
> -	xfi_direct_valid = xfi_indirect_valid = 0;
> -	xaui_direct_valid = xaui_indirect_valid = 1;
> +	xfi_indirect_valid = 0;
> +	xfi_direct_valid = xfi_indirect_valid;
> +	xaui_indirect_valid = 1;
> +	xaui_direct_valid = xaui_indirect_valid

The original code is fine here.  Just ignore checkpatch on this.

regards,
dan carpenter

