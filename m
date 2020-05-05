Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 161E21C4E0D
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 08:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728114AbgEEGHg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 02:07:36 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:45300 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725320AbgEEGHf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 02:07:35 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04563f2W106378;
        Tue, 5 May 2020 06:07:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Hd7te6S50m+hUOHmKAL5qGjVQoqJ2ucNIjBwUVXEubA=;
 b=Av0Il68pcCYb/s6AmtrY4iUdwi6medwv7gkQA256Fs9RKlSSiHkMYyOhNzcdGolbAfM9
 GGmzAbs2FS1p6XPXJxrDIKSg35U1UhbYZ55tZRogPjCzMEKWzDsrHoMlQAhkBFknK9Ng
 6wbnUKteuFCMd7q/84UUs6rKVxqQIP0Sk1Z8uJbpbbxg5yeP1FRC2lZRy7wcYEGmPa6B
 b0DUCIfxs7KbfkY19GNn84Zr0ohr1cWWphxy9sskl8ZhqTCgGRA2W+MYDgpeGF1xZQ4G
 l0x3I0y61xpbdQl4fX7PSZajErxLbQgzqeqjTLHoASnYxAFmHx5fT4SG5Q0oBsY0oaNI Mg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 30s1gn2h50-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 May 2020 06:07:26 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04566dqx079123;
        Tue, 5 May 2020 06:07:25 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 30sjjxt8t0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 May 2020 06:07:25 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04567OBE030156;
        Tue, 5 May 2020 06:07:24 GMT
Received: from [10.191.203.202] (/10.191.203.202)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 May 2020 23:07:24 -0700
Subject: Re: [PATCH net] net: dsa: Do not leave DSA master with NULL
 netdev_ops
To:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20200504201806.27192-1-f.fainelli@gmail.com>
From:   Allen <allen.pais@oracle.com>
Message-ID: <905b0b48-5184-3b11-2f78-e99834dbc38a@oracle.com>
Date:   Tue, 5 May 2020 11:37:12 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20200504201806.27192-1-f.fainelli@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 phishscore=0
 bulkscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005050050
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 mlxscore=0
 spamscore=0 clxscore=1011 priorityscore=1501 bulkscore=0 phishscore=0
 impostorscore=0 malwarescore=0 lowpriorityscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005050050
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> When ndo_get_phys_port_name() for the CPU port was added we introduced
> an early check for when the DSA master network device in
> dsa_master_ndo_setup() already implements ndo_get_phys_port_name(). When
> we perform the teardown operation in dsa_master_ndo_teardown() we would
> not be checking that cpu_dp->orig_ndo_ops was successfully allocated and
> non-NULL initialized.
> 
> With network device drivers such as virtio_net, this leads to a NPD as
> soon as the DSA switch hanging off of it gets torn down because we are
> now assigning the virtio_net device's netdev_ops a NULL pointer.
> 
> Fixes: da7b9e9b00d4 ("net: dsa: Add ndo_get_phys_port_name() for CPU port")
> Reported-by: Allen Pais <allen.pais@oracle.com>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Tested-by: Allen Pais <allen.pais@oracle.com>

Thank you Florain.
> ---
>   net/dsa/master.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/dsa/master.c b/net/dsa/master.c
> index b5c535af63a3..a621367c6e8c 100644
> --- a/net/dsa/master.c
> +++ b/net/dsa/master.c
> @@ -289,7 +289,8 @@ static void dsa_master_ndo_teardown(struct net_device *dev)
>   {
>   	struct dsa_port *cpu_dp = dev->dsa_ptr;
>   
> -	dev->netdev_ops = cpu_dp->orig_ndo_ops;
> +	if (cpu_dp->orig_ndo_ops)
> +		dev->netdev_ops = cpu_dp->orig_ndo_ops;
>   	cpu_dp->orig_ndo_ops = NULL;
>   }
>   
> 
