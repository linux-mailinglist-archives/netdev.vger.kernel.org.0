Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC7C1160B5
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 11:20:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbfEGJUo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 05:20:44 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:42108 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726340AbfEGJUo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 May 2019 05:20:44 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x479IokU168106;
        Tue, 7 May 2019 09:20:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=qbFEsJg/nIhTtjMlz/VATRzBrxKNJiG2UvySEgqTcVk=;
 b=zw74HRlLkATCn0QV/mxGuvztFHZV5X+uVB0J4W+i2UZIE3LybvupffeEh8ykRdBTMibk
 vtb3CwAVckfgr1sb/rC+/5ReBrqDCdBF6qlfWlR6EGabdnSoWrdespq5pMjx+Ct9GewZ
 LGDEzLYLsy2hepdpD6fkzYhOmLjZm7UuGQHjuPNLH7T8oi6IcWCxYIe0IdkvOc2WyqkG
 eAfgvEyF+pM5NEHtMSL4FbFlMixrwv1jAKeXFx3mHrJdvFui5+VFru8TrXvlvPalb5zh
 JgPE+pC/X3f4E/Y1tBXyz4GMvbfnVpNZFoZaurmvIte8ljDa94JwhjEJ2ZIA4fgCpQcv iw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2s94b0kure-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 May 2019 09:20:31 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x479Jqmm007090;
        Tue, 7 May 2019 09:20:30 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2sagyttxwr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 May 2019 09:20:30 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x479KPwO021159;
        Tue, 7 May 2019 09:20:25 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 May 2019 02:20:25 -0700
Date:   Tue, 7 May 2019 12:20:12 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH][next] net: dsa: sja1105: fix comparisons against
 uninitialized status fields
Message-ID: <20190507092012.GL2269@kadam>
References: <20190507084458.22520-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190507084458.22520-1-colin.king@canonical.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9249 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905070061
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9249 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905070061
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 07, 2019 at 09:44:58AM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The call to sja1105_status_get to set various fields in the status
> structure can potentially be skipped in a while-loop because of a couple
> of prior continuation jump paths. This can potientially lead to checking
> be checking against an uninitialized fields in the structure which may
> lead to unexpected results.  Fix this by ensuring all the fields in status
> are initialized to zero to be safe.
> 
> Addresses-Coverity: ("Uninitialized scalar variable")
> Fixes: 8aa9ebccae87 ("net: dsa: Introduce driver for NXP SJA1105 5-port L2 switch")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/net/dsa/sja1105/sja1105_spi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
> index 244a94ccfc18..76f6a51e10d9 100644
> --- a/drivers/net/dsa/sja1105/sja1105_spi.c
> +++ b/drivers/net/dsa/sja1105/sja1105_spi.c
> @@ -394,7 +394,7 @@ int sja1105_static_config_upload(struct sja1105_private *priv)
>  	struct sja1105_static_config *config = &priv->static_config;
>  	const struct sja1105_regs *regs = priv->info->regs;
>  	struct device *dev = &priv->spidev->dev;
> -	struct sja1105_status status;
> +	struct sja1105_status status = {};

The exit condition isn't right.  It should continue if ret is negative
or the CRC stuff is invalid but right now it's ignoring ret.  It would
be better could just add a break statement at the very end and remove
the status checks.  Like so:

diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index 244a94ccfc18..3af3b0f3cc44 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -466,8 +466,9 @@ int sja1105_static_config_upload(struct sja1105_private *priv)
 				"invalid, retrying...\n");
 			continue;
 		}
-	} while (--retries && (status.crcchkl == 1 || status.crcchkg == 1 ||
-		 status.configs == 0 || status.ids == 1));
+		/* Success! */
+		break;
+	} while (--retries);
 
 	if (!retries) {
 		rc = -EIO;
