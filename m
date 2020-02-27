Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9BA617185B
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 14:14:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729088AbgB0NN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 08:13:59 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:24308 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729030AbgB0NN7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 08:13:59 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01RDBpYT016160
        for <netdev@vger.kernel.org>; Thu, 27 Feb 2020 08:13:58 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ydh92b9h2-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 27 Feb 2020 08:13:57 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <kgraul@linux.ibm.com>;
        Thu, 27 Feb 2020 13:13:53 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 27 Feb 2020 13:13:49 -0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01RDDnaR58065142
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Feb 2020 13:13:49 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0DF1C4C040;
        Thu, 27 Feb 2020 13:13:49 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BF78D4C052;
        Thu, 27 Feb 2020 13:13:48 +0000 (GMT)
Received: from [9.145.6.242] (unknown [9.145.6.242])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 27 Feb 2020 13:13:48 +0000 (GMT)
Subject: Re: [RFC net-next] net/smc: update peer ID on device changes
To:     Hans Wippel <ndev@hwipl.net>, ubraun@linux.ibm.com,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org
References: <20200227113902.318060-1-ndev@hwipl.net>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
Date:   Thu, 27 Feb 2020 14:13:48 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200227113902.318060-1-ndev@hwipl.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 20022713-0016-0000-0000-000002EACE4A
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20022713-0017-0000-0000-0000334E0293
Message-Id: <b56d4bbc-2a4e-634f-10d4-17bd0253c033@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-27_03:2020-02-26,2020-02-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 spamscore=0
 malwarescore=0 priorityscore=1501 lowpriorityscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 mlxscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002270104
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/02/2020 12:39, Hans Wippel wrote:
> From: hwipl <ndev@hwipl.net>
> 
> A SMC host's peer ID contains the MAC address of the first active RoCE
> device. However, if this device becomes inactive or is removed, the peer
> ID is not updated. This patch adds peer ID updates on device changes.

The peer ID is used to uniquely identify an SMC host and to check if there
are already established link groups to the peer which can be reused.
In failover scenarios RoCE devices can go down and get active again later,
but this must not change the current peer ID of the host.  
The part of the MAC address that is included in the peer ID is not used for
other purposes than the identification of an SMC host.

> 
> Signed-off-by: hwipl <ndev@hwipl.net>
> ---
>  net/smc/smc_ib.c | 32 ++++++++++++++++++++++++--------
>  1 file changed, 24 insertions(+), 8 deletions(-)
> 
> diff --git a/net/smc/smc_ib.c b/net/smc/smc_ib.c
> index 3444de27fecd..5818636962c6 100644
> --- a/net/smc/smc_ib.c
> +++ b/net/smc/smc_ib.c
> @@ -159,11 +159,29 @@ static int smc_ib_fill_mac(struct smc_ib_device *smcibdev, u8 ibport)
>   * plus a random 2-byte number is used to create this identifier.
>   * This name is delivered to the peer during connection initialization.
>   */
> -static inline void smc_ib_define_local_systemid(struct smc_ib_device *smcibdev,
> -						u8 ibport)
> +static void smc_ib_update_local_systemid(void)
>  {
> -	memcpy(&local_systemid[2], &smcibdev->mac[ibport - 1],
> -	       sizeof(smcibdev->mac[ibport - 1]));
> +	struct smc_ib_device *smcibdev;
> +	u8 ibport;
> +
> +	/* get first ib device with an active port */
> +	spin_lock(&smc_ib_devices.lock);
> +	list_for_each_entry(smcibdev, &smc_ib_devices.list, list) {
> +		for (ibport = 1; ibport <= SMC_MAX_PORTS; ibport++) {
> +			if (smc_ib_port_active(smcibdev, ibport))
> +				goto out;
> +		}
> +	}
> +	smcibdev = NULL;
> +out:
> +	spin_unlock(&smc_ib_devices.lock);
> +
> +	/* set (new) mac address or reset to zero */
> +	if (smcibdev)
> +		ether_addr_copy(&local_systemid[2],
> +				(u8 *)&smcibdev->mac[ibport - 1]);
> +	else
> +		eth_zero_addr(&local_systemid[2]);
>  }
>  
>  bool smc_ib_is_valid_local_systemid(void)
> @@ -229,10 +247,6 @@ static int smc_ib_remember_port_attr(struct smc_ib_device *smcibdev, u8 ibport)
>  	rc = smc_ib_fill_mac(smcibdev, ibport);
>  	if (rc)
>  		goto out;
> -	if (!smc_ib_is_valid_local_systemid() &&
> -	    smc_ib_port_active(smcibdev, ibport))
> -		/* create unique system identifier */
> -		smc_ib_define_local_systemid(smcibdev, ibport);
>  out:
>  	return rc;
>  }
> @@ -254,6 +268,7 @@ static void smc_ib_port_event_work(struct work_struct *work)
>  			clear_bit(port_idx, smcibdev->ports_going_away);
>  		}
>  	}
> +	smc_ib_update_local_systemid();
>  }
>  
>  /* can be called in IRQ context */
> @@ -599,6 +614,7 @@ static void smc_ib_remove_dev(struct ib_device *ibdev, void *client_data)
>  	smc_ib_cleanup_per_ibdev(smcibdev);
>  	ib_unregister_event_handler(&smcibdev->event_handler);
>  	kfree(smcibdev);
> +	smc_ib_update_local_systemid();
>  }
>  
>  static struct ib_client smc_ib_client = {
> 

-- 
Karsten

(I'm a dude)

