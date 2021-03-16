Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BBF333D058
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 10:11:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232211AbhCPJLB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 05:11:01 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:45172 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231979AbhCPJKa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 05:10:30 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12G9ACNO162669;
        Tue, 16 Mar 2021 09:10:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=5n3Z4Pl8NfHLesDCmcdXVOo6ZdVwctaPEOzF6XZitW8=;
 b=sDCAsQbEvMmyTmZyFqXujPh3R3HZPKH9dqKbcFXysxFi1CejyTvgW9nLkI6X/iCaUum5
 loS7xYVUwAhR+oNOz+UFScxr5vflPtEYtuv2Y6p9tiysjnS2TMEBIRvQFBaai7ei8a7x
 Txc7EK/lwtSX15S92QfbHmAtEjj8fk78Yes2O7ixKl8JI118lExcv6wgewM1makBYTZ5
 xjVvs3IxFwpSVJM/pMDV5FDHoXemULR0IfcH3RRaF+HANxOGLhJK3it8Hv5fmK+P+zAG
 OBCiB1Ndc/catUjmcPqY2qKFQQEKkzGkqcnS6G3RlKeNVI6pAAjF3Jw5/YWidBqGDJr0 7A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 378p1npwq7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Mar 2021 09:10:15 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12G99gB7186545;
        Tue, 16 Mar 2021 09:10:14 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 3797a0xfyu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Mar 2021 09:10:14 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 12G9A9fc011784;
        Tue, 16 Mar 2021 09:10:09 GMT
Received: from kadam (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 16 Mar 2021 09:10:08 +0000
Date:   Tue, 16 Mar 2021 12:10:00 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     "'w00385741" <weiyongjun1@huawei.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Hulk Robot <hulkci@huawei.com>
Subject: Re: [PATCH net-next] net: dsa: sja1105: fix error return code in
 sja1105_cls_flower_add()
Message-ID: <20210316090959.GS2087@kadam>
References: <20210315144323.4110640-1-weiyongjun1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210315144323.4110640-1-weiyongjun1@huawei.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9924 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103160064
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9924 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 adultscore=0
 spamscore=0 clxscore=1011 phishscore=0 malwarescore=0 priorityscore=1501
 bulkscore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103160064
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 15, 2021 at 02:43:23PM +0000, 'w00385741 wrote:
> From: Wei Yongjun <weiyongjun1@huawei.com>
> 
> The return value 'rc' maybe overwrite to 0 in the flow_action_for_each
> loop, the error code from the offload not support error handling will
> not set. This commit fix it to return -EOPNOTSUPP.
> 
> Fixes: 6a56e19902af ("flow_offload: reject configuration of packet-per-second policing in offload drivers")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> ---
>  drivers/net/dsa/sja1105/sja1105_flower.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/net/dsa/sja1105/sja1105_flower.c b/drivers/net/dsa/sja1105/sja1105_flower.c
> index f78b767f86ee..973761132fc3 100644
> --- a/drivers/net/dsa/sja1105/sja1105_flower.c
> +++ b/drivers/net/dsa/sja1105/sja1105_flower.c
> @@ -317,14 +317,13 @@ int sja1105_cls_flower_add(struct dsa_switch *ds, int port,
>  	if (rc)
>  		return rc;
>  
> -	rc = -EOPNOTSUPP;
> -
>  	flow_action_for_each(i, act, &rule->action) {
>  		switch (act->id) {
>  		case FLOW_ACTION_POLICE:
>  			if (act->police.rate_pkt_ps) {
>  				NL_SET_ERR_MSG_MOD(extack,
>  						   "QoS offload not support packets per second");
> +				rc = -EOPNOTSUPP;
>  				goto out;

Yep.  The goto out is a do nothing goto and "forgot the error code" is
the traditional bug introduced by do nothing gotos.

Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>

regards,
dan carpenter

