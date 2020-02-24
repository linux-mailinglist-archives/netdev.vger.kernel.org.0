Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 397BE16A3C5
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 11:19:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727308AbgBXKTv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 05:19:51 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60154 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726509AbgBXKTv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 05:19:51 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01OAEcj1092274
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 05:19:49 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2yb1ar9rvg-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 05:19:49 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <kgraul@linux.ibm.com>;
        Mon, 24 Feb 2020 10:19:47 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 24 Feb 2020 10:19:46 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01OAJjFs62390388
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Feb 2020 10:19:45 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 43829AE051;
        Mon, 24 Feb 2020 10:19:45 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0D26AAE053;
        Mon, 24 Feb 2020 10:19:45 +0000 (GMT)
Received: from [9.152.222.57] (unknown [9.152.222.57])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 24 Feb 2020 10:19:44 +0000 (GMT)
Subject: Re: [RFC net-next] net/smc: improve peer ID in CLC decline for SMC-R
To:     Hans Wippel <ndev@hwipl.net>, ubraun@linux.ibm.com,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org
References: <20200221130805.5988-1-ndev@hwipl.net>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
Date:   Mon, 24 Feb 2020 11:19:44 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200221130805.5988-1-ndev@hwipl.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 20022410-0028-0000-0000-000003DD712F
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20022410-0029-0000-0000-000024A2859A
Message-Id: <eda1bd7a-daf6-d052-6a79-5d8c816d052b@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-24_02:2020-02-21,2020-02-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 mlxlogscore=999 malwarescore=0 mlxscore=0 adultscore=0
 phishscore=0 bulkscore=0 clxscore=1015 impostorscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240088
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Except for the other review comment: looks good to me. 
I successfully tested a few scenarios involving different SMC implementations.


On 21/02/2020 14:08, Hans Wippel wrote:
> According to RFC 7609, all CLC messages contain a peer ID that consists
> of a unique instance ID and the MAC address of one of the host's RoCE
> devices. But if a SMC-R connection cannot be established, e.g., because
> no matching pnet table entry is found, the current implementation uses a
> zero value in the CLC decline message although the host's peer ID is set
> to a proper value.
> 
> This patch changes the peer ID handling in two ways:
> 
> (1) If no RoCE and no ISM device is usable for a connection, there is no
> LGR and the LGR check in smc_clc_send_decline() prevents that the peer
> ID is copied into the CLC decline message for both SMC-D and SMC-R. So,
> this patch modifies the check to also accept the case of no LGR. Also,
> only a valid peer ID is copied into the decline message.
> 
> (2) The patch initializes the peer ID to a random instance ID and a zero
> MAC address. If a RoCE device is in the host, the MAC address part of
> the peer ID is overwritten with the respective address. Also, a function
> for checking if the peer ID is valid is added. A peer ID is considered
> valid if the MAC address part contains a non-zero MAC address.
> 
> Signed-off-by: Hans Wippel <ndev@hwipl.net>
> ---
>  net/smc/smc_clc.c |  9 ++++++---
>  net/smc/smc_ib.c  | 19 ++++++++++++-------
>  net/smc/smc_ib.h  |  1 +
>  3 files changed, 19 insertions(+), 10 deletions(-)
> 
> diff --git a/net/smc/smc_clc.c b/net/smc/smc_clc.c
> index 3e16b887cfcf..e2d3b5b95632 100644
> --- a/net/smc/smc_clc.c
> +++ b/net/smc/smc_clc.c
> @@ -372,9 +372,12 @@ int smc_clc_send_decline(struct smc_sock *smc, u32 peer_diag_info)
>  	dclc.hdr.length = htons(sizeof(struct smc_clc_msg_decline));
>  	dclc.hdr.version = SMC_CLC_V1;
>  	dclc.hdr.flag = (peer_diag_info == SMC_CLC_DECL_SYNCERR) ? 1 : 0;
> -	if (smc->conn.lgr && !smc->conn.lgr->is_smcd)
> -		memcpy(dclc.id_for_peer, local_systemid,
> -		       sizeof(local_systemid));
> +	if (!smc->conn.lgr || !smc->conn.lgr->is_smcd) {
> +		if (smc_ib_is_valid_local_systemid()) {
> +			memcpy(dclc.id_for_peer, local_systemid,
> +			       sizeof(local_systemid));
> +		}
> +	}
>  	dclc.peer_diagnosis = htonl(peer_diag_info);
>  	memcpy(dclc.trl.eyecatcher, SMC_EYECATCHER, sizeof(SMC_EYECATCHER));
>  
> diff --git a/net/smc/smc_ib.c b/net/smc/smc_ib.c
> index 6756bd5a3fe4..203dd05d7113 100644
> --- a/net/smc/smc_ib.c
> +++ b/net/smc/smc_ib.c
> @@ -37,11 +37,7 @@ struct smc_ib_devices smc_ib_devices = {	/* smc-registered ib devices */
>  	.list = LIST_HEAD_INIT(smc_ib_devices.list),
>  };
>  
> -#define SMC_LOCAL_SYSTEMID_RESET	"%%%%%%%"
> -
> -u8 local_systemid[SMC_SYSTEMID_LEN] = SMC_LOCAL_SYSTEMID_RESET;	/* unique system
> -								 * identifier
> -								 */
> +u8 local_systemid[SMC_SYSTEMID_LEN] = {0};	/* unique system identifier */
>  
>  static int smc_ib_modify_qp_init(struct smc_link *lnk)
>  {
> @@ -168,6 +164,15 @@ static inline void smc_ib_define_local_systemid(struct smc_ib_device *smcibdev,
>  {
>  	memcpy(&local_systemid[2], &smcibdev->mac[ibport - 1],
>  	       sizeof(smcibdev->mac[ibport - 1]));
> +}
> +
> +bool smc_ib_is_valid_local_systemid(void)
> +{
> +	return !is_zero_ether_addr(&local_systemid[2]);
> +}
> +
> +static void smc_ib_init_local_systemid(void)
> +{
>  	get_random_bytes(&local_systemid[0], 2);
>  }
>  
> @@ -224,8 +229,7 @@ static int smc_ib_remember_port_attr(struct smc_ib_device *smcibdev, u8 ibport)
>  	rc = smc_ib_fill_mac(smcibdev, ibport);
>  	if (rc)
>  		goto out;
> -	if (!strncmp(local_systemid, SMC_LOCAL_SYSTEMID_RESET,
> -		     sizeof(local_systemid)) &&
> +	if (!smc_ib_is_valid_local_systemid() &&
>  	    smc_ib_port_active(smcibdev, ibport))
>  		/* create unique system identifier */
>  		smc_ib_define_local_systemid(smcibdev, ibport);
> @@ -605,6 +609,7 @@ static struct ib_client smc_ib_client = {
>  
>  int __init smc_ib_register_client(void)
>  {
> +	smc_ib_init_local_systemid();
>  	return ib_register_client(&smc_ib_client);
>  }
>  
> diff --git a/net/smc/smc_ib.h b/net/smc/smc_ib.h
> index 255db87547d3..5c2b115d36da 100644
> --- a/net/smc/smc_ib.h
> +++ b/net/smc/smc_ib.h
> @@ -84,4 +84,5 @@ void smc_ib_sync_sg_for_device(struct smc_ib_device *smcibdev,
>  			       enum dma_data_direction data_direction);
>  int smc_ib_determine_gid(struct smc_ib_device *smcibdev, u8 ibport,
>  			 unsigned short vlan_id, u8 gid[], u8 *sgid_index);
> +bool smc_ib_is_valid_local_systemid(void);
>  #endif
> 

-- 
Karsten

(I'm a dude)

