Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF3C4CDEF5
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 22:00:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbiCDUdk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 15:33:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231295AbiCDUc4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 15:32:56 -0500
Received: from mx0b-002e3701.pphosted.com (mx0b-002e3701.pphosted.com [148.163.143.35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D0231E746D
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 12:31:46 -0800 (PST)
Received: from pps.filterd (m0134423.ppops.net [127.0.0.1])
        by mx0b-002e3701.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 224KVAn1005227;
        Fri, 4 Mar 2022 20:31:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pps0720; bh=SGvfUvGGGFbQL2iyh9wybGHmkLA/Z/ATRA7685J40ZQ=;
 b=bmBlOO89fR+Y+ZfvkSKDmXwJB3THrjqqs/v53Nx2R89sdTSyNyJJxw1YVSEinXzZa93b
 u5q05D+rOJR19vg2xLq/P92diAyfKEbEDUKYP9PA064Ko9uhuuH2+ibTinu/PN2Zq/Qn
 rTeQuA1icvHw5nCZHGZtKBWKddkq6HRIwiQh7uAivLgiXX7iCkPJ4Wmz2fZpuIzxFO5L
 vjuElfhcUDBATktnZRgNuHAXTpvDOQ4udLTPIYWtMkDDY3EEhW1FTpdlJzfjJmBRsqNL
 oinL5BdVo+9nP6wsjyGabAx4HOn+3hv1K8b5LV4VCfJ7bKn9uyA+8as7A3jZ25UycnZB WA== 
Received: from g2t2354.austin.hpe.com (g2t2354.austin.hpe.com [15.233.44.27])
        by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 3eksvk002s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Mar 2022 20:31:32 +0000
Received: from g2t2360.austin.hpecorp.net (g2t2360.austin.hpecorp.net [16.196.225.135])
        by g2t2354.austin.hpe.com (Postfix) with ESMTP id 4114F81;
        Fri,  4 Mar 2022 20:31:31 +0000 (UTC)
Received: from swahl-home.5wahls.com (unknown [10.207.196.34])
        by g2t2360.austin.hpecorp.net (Postfix) with ESMTP id 4E5E436;
        Fri,  4 Mar 2022 20:31:30 +0000 (UTC)
Date:   Fri, 4 Mar 2022 14:31:29 -0600
From:   Steve Wahl <steve.wahl@hpe.com>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Robin Holt <robinmholt@gmail.com>,
        Steve Wahl <steve.wahl@hpe.com>,
        Mike Travis <mike.travis@hpe.com>
Subject: Re: [PATCH net-next 3/9] net: sgi-xp: Use netif_rx().
Message-ID: <YiJ3ITxRaXso5abf@swahl-home.5wahls.com>
References: <20220303171505.1604775-1-bigeasy@linutronix.de>
 <20220303171505.1604775-4-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220303171505.1604775-4-bigeasy@linutronix.de>
X-Proofpoint-GUID: pDuH9nmpfs79y3UZpR0blE_FbOYFc2oG
X-Proofpoint-ORIG-GUID: pDuH9nmpfs79y3UZpR0blE_FbOYFc2oG
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-04_09,2022-03-04_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=999 spamscore=0 impostorscore=0 phishscore=0 suspectscore=0
 mlxscore=0 adultscore=0 bulkscore=0 priorityscore=1501 malwarescore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203040101
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reviewed-by: Steve Wahl <steve.wahl@hpe.com>

On Thu, Mar 03, 2022 at 06:14:59PM +0100, Sebastian Andrzej Siewior wrote:
> Since commit
>    baebdf48c3600 ("net: dev: Makes sure netif_rx() can be invoked in any context.")
> 
> the function netif_rx() can be used in preemptible/thread context as
> well as in interrupt context.
> 
> Use netif_rx().
> 
> Cc: Robin Holt <robinmholt@gmail.com>
> Cc: Steve Wahl <steve.wahl@hpe.com>
> Cc: Mike Travis <mike.travis@hpe.com>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  drivers/misc/sgi-xp/xpnet.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/misc/sgi-xp/xpnet.c b/drivers/misc/sgi-xp/xpnet.c
> index dab7b92db790a..50644f83e78ce 100644
> --- a/drivers/misc/sgi-xp/xpnet.c
> +++ b/drivers/misc/sgi-xp/xpnet.c
> @@ -247,7 +247,7 @@ xpnet_receive(short partid, int channel, struct xpnet_message *msg)
>  	xpnet_device->stats.rx_packets++;
>  	xpnet_device->stats.rx_bytes += skb->len + ETH_HLEN;
>  
> -	netif_rx_ni(skb);
> +	netif_rx(skb);
>  	xpc_received(partid, channel, (void *)msg);
>  }
>  
> -- 
> 2.35.1
> 

-- 
Steve Wahl, Hewlett Packard Enterprise
