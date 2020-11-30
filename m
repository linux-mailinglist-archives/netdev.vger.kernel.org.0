Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 598092C8463
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 13:53:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726069AbgK3Mwu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 07:52:50 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:50934 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbgK3Mwt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 07:52:49 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AUCT8MP161013;
        Mon, 30 Nov 2020 12:51:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=iOSOzG9McZzuR7elPCodrNp8EvMHOEUV9ZwrGMMBHTc=;
 b=oQBOeWMrw8UceHrB/Wbw9Wdu1egQkl9bwNgFn489dVu4gBLcwMbNCxConO5X18gEzuSR
 En9Xgh3beCIufoft2mmjTEdXCkXG48K8iU6vZ6QhxQiru0S/wkwUW/kLvSRGCoZ1YDFi
 zXFMtfnFBZ+H3K7wizffM7KWjQjZRIO//LGVkprjZScpKS1XJw43dPPhI0U9jeOBaOpJ
 ihs/kNOvZmXaKeNCIStfv9bxQcD2UUBAFaQOSgv2BS8tokAeSLppr7/OHo9hGzLUjzDc
 PhtsjHl+TXP9CGsmDl1ZkNZlr44WsVNG9gHu8S1WhBjqJJpPUBzRtqSwcj3ZX4kV8gYi 1g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 353dyqcv4e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 30 Nov 2020 12:51:53 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AUCo0BT054569;
        Mon, 30 Nov 2020 12:51:52 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 3540ewhm03-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Nov 2020 12:51:52 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AUCpmA1017759;
        Mon, 30 Nov 2020 12:51:51 GMT
Received: from kadam (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 30 Nov 2020 04:51:47 -0800
Date:   Mon, 30 Nov 2020 15:51:37 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Ralf Baechle <ralf@linux-mips.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-hams@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH 109/141] net: netrom: Fix fall-through warnings for Clang
Message-ID: <20201130125137.GE2767@kadam>
References: <cover.1605896059.git.gustavoars@kernel.org>
 <c9a262ebaebd704e66c264fb68462bd8b9664d38.1605896060.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c9a262ebaebd704e66c264fb68462bd8b9664d38.1605896060.git.gustavoars@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9820 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 suspectscore=0 bulkscore=0 spamscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011300082
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9820 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 clxscore=1011 mlxscore=0 spamscore=0 priorityscore=1501 mlxlogscore=999
 suspectscore=0 lowpriorityscore=0 phishscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011300081
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 20, 2020 at 12:38:15PM -0600, Gustavo A. R. Silva wrote:
> In preparation to enable -Wimplicit-fallthrough for Clang, fix multiple
> warnings by explicitly adding multiple break statements instead of
> letting the code fall through to the next case.
> 
> Link: https://github.com/KSPP/linux/issues/115
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
>  net/netrom/nr_route.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/net/netrom/nr_route.c b/net/netrom/nr_route.c
> index 78da5eab252a..de0456073dc0 100644
> --- a/net/netrom/nr_route.c
> +++ b/net/netrom/nr_route.c
> @@ -266,6 +266,7 @@ static int __must_check nr_add_node(ax25_address *nr, const char *mnemonic,
>  		fallthrough;
>  	case 2:
>  		re_sort_routes(nr_node, 0, 1);
> +		break;
>  	case 1:
>  		break;
>  	}
> @@ -359,6 +360,7 @@ static int nr_del_node(ax25_address *callsign, ax25_address *neighbour, struct n
>  					fallthrough;
>  				case 1:
>  					nr_node->routes[1] = nr_node->routes[2];
> +					fallthrough;

Make this one a break like the others.

>  				case 2:
>  					break;
>  				}
> @@ -482,6 +484,7 @@ static int nr_dec_obs(void)
>  					fallthrough;
>  				case 1:
>  					s->routes[1] = s->routes[2];
> +					break;
>  				case 2:
>  					break;
>  				}
> @@ -529,6 +532,7 @@ void nr_rt_device_down(struct net_device *dev)
>  							fallthrough;
>  						case 1:
>  							t->routes[1] = t->routes[2];
> +							break;
>  						case 2:
>  							break;
>  						}

regards,
dan carpenter
