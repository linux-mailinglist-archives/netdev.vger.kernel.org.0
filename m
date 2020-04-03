Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4EC219D294
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 10:46:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390550AbgDCIqn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 04:46:43 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:34716 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389876AbgDCIqm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 04:46:42 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0338gkWC034758;
        Fri, 3 Apr 2020 08:46:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=Y+AET8seX8nUTZtaySySO6dBKVo+n069jzDC0TqS70E=;
 b=aD9/vhMSvr1C0Kz4MwF28gntBMT7zrGIcQKq20E3JeVbvbz7MP+wNSlu/hxx8hJAe+R+
 eDAFDeehbf8zyoc5g20ogFRkfmdbBgRgA/s7Q99atUMK0CvAqY/WAYLBTwPbRXF6ofFQ
 CR4pjHq+mehouvAIUQwr3EOiClDQ1lB9zSY3Av03B76nSwoJVuFFGwgxL6N+ajnFk9kj
 KFO0MxC6WOraOzjy/FAlxKGvVDO7DGrvQmo6OKOvnZsmDgJJjMhk2UKsNmgi5Jm4wsrr
 Ic9pabNXnRc/HXR0HKgSwxAelIAwKgCjZpzfp3EwPCsbI5U4w1+ocujINAIyx5z3myMo 1Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 303aqj09u3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Apr 2020 08:46:35 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0338hAXs146992;
        Fri, 3 Apr 2020 08:46:34 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 304sjs57xp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Apr 2020 08:46:34 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0338kWXX014173;
        Fri, 3 Apr 2020 08:46:32 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 Apr 2020 01:46:32 -0700
Date:   Fri, 3 Apr 2020 11:46:24 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Jiri Pirko <jiri@mellanox.com>, Ido Schimmel <idosch@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] mlxsw: spectrum_trap: fix unintention integer
 overflow on left shift
Message-ID: <20200403084624.GA2001@kadam>
References: <20200402144851.565983-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200402144851.565983-1-colin.king@canonical.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9579 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 phishscore=0 suspectscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004030074
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9579 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 clxscore=1011
 malwarescore=0 impostorscore=0 mlxlogscore=999 spamscore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004030074
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 02, 2020 at 03:48:51PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Shifting the integer value 1 is evaluated using 32-bit
> arithmetic and then used in an expression that expects a 64-bit
> value, so there is potentially an integer overflow. Fix this
> by using the BIT_ULL macro to perform the shift and avoid the
> overflow.
> 
> Addresses-Coverity: ("Unintentional integer overflow")
> Fixes: 13f2e64b94ea ("mlxsw: spectrum_trap: Add devlink-trap policer support")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
> index 9096ffd89e50..fbf714d027d8 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
> +++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
> @@ -643,7 +643,7 @@ static int mlxsw_sp_trap_policer_bs(u64 burst, u8 *p_burst_size,
>  {
>  	int bs = fls64(burst) - 1;
>  
> -	if (burst != (1 << bs)) {
> +	if (burst != (BIT_ULL(bs))) {

Please delete the extra parentheses.

	if (burst != BIT_ULL(bs)) {

regards,
dan carpenter

