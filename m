Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5088496F43
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 01:37:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231921AbiAWAhR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jan 2022 19:37:17 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:20068 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229542AbiAWAhP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jan 2022 19:37:15 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20N05uYC027390
        for <netdev@vger.kernel.org>; Sun, 23 Jan 2022 00:37:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=mime-version :
 content-type : content-transfer-encoding : date : from : to : cc : subject
 : in-reply-to : references : message-id; s=pp1;
 bh=rNPUUedg2jN47ZKgJACC7ABIkI5iftFVG8PQ/rs8L0A=;
 b=S0svExL+AvF56uEtUXPzgi1+Me7hZyomP86zEJlNqXFhJhwosGvO0+V8F3VbOhoiFObq
 P5NyKXMldy6uE03W2kwjgJZC8xMGfjRIIppJ29xFc1X9yp4vne9mdgxmY173JFBgn+t5
 RO7V4SrYbAdbToqb9vYYPMyfukmEgdAMzYb/kxxP5nyVNwRwbSRmCryjtKkTfKqfD3W3
 VnnGLR1ohhAxjW+FzzOAce1JvrU848R3lkhc9X3yNLTSuN6ulkkPSrL4V4I/zjEjZutj
 hY5LCqLF0JgKmGW58cMnvzSWKgSRP8h9VgBPBBo7gly4u5k8AFFYsmO7z+xI/g1qXLr9 EQ== 
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3druw2gem3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 23 Jan 2022 00:37:15 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20N0CMG4004895
        for <netdev@vger.kernel.org>; Sun, 23 Jan 2022 00:32:14 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma01dal.us.ibm.com with ESMTP id 3dr9j9460a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 23 Jan 2022 00:32:14 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20N0WDDm36897250
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Jan 2022 00:32:13 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5F868124058;
        Sun, 23 Jan 2022 00:32:13 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1AC6D124053;
        Sun, 23 Jan 2022 00:32:13 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.10.229.42])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Sun, 23 Jan 2022 00:32:13 +0000 (GMT)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sat, 22 Jan 2022 16:32:12 -0800
From:   Dany Madden <drt@linux.ibm.com>
To:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc:     netdev@vger.kernel.org, Brian King <brking@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>
Subject: Re: [PATCH net 3/4] ibmvnic: don't spin in tasklet
In-Reply-To: <20220122025921.199446-3-sukadev@linux.ibm.com>
References: <20220122025921.199446-1-sukadev@linux.ibm.com>
 <20220122025921.199446-3-sukadev@linux.ibm.com>
Message-ID: <4e01179845cb17e38786a3af00744db2@imap.linux.ibm.com>
X-Sender: drt@linux.ibm.com
User-Agent: Roundcube Webmail/1.1.12
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: JglnvEsjyRTm9pXmxFSsXiMm4jUdrLUo
X-Proofpoint-ORIG-GUID: JglnvEsjyRTm9pXmxFSsXiMm4jUdrLUo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-22_10,2022-01-21_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 bulkscore=0
 adultscore=0 mlxscore=0 clxscore=1015 suspectscore=0 mlxlogscore=999
 impostorscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2201230001
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-01-21 18:59, Sukadev Bhattiprolu wrote:
> ibmvnic_tasklet() continuously spins waiting for responses to all
> capability requests. It does this to avoid encountering an error
> during initialization of the vnic. However if there is a bug in the
> VIOS and we do not receive a response to one or more queries the
> tasklet ends up spinning continuously leading to hard lock ups.
> 
> If we fail to receive a message from the VIOS it is reasonable to
> timeout the login attempt rather than spin indefinitely in the tasklet.
> 
> Fixes: 249168ad07cd ("ibmvnic: Make CRQ interrupt tasklet wait for all
> capabilities crqs")
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Reviewed-by: Dany Madden <drt@linux.ibm.com>

> ---
>  drivers/net/ethernet/ibm/ibmvnic.c | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/drivers/net/ethernet/ibm/ibmvnic.c
> b/drivers/net/ethernet/ibm/ibmvnic.c
> index acd488310bbc..682a440151a8 100644
> --- a/drivers/net/ethernet/ibm/ibmvnic.c
> +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> @@ -5491,12 +5491,6 @@ static void ibmvnic_tasklet(struct 
> tasklet_struct *t)
>  			ibmvnic_handle_crq(crq, adapter);
>  			crq->generic.first = 0;
>  		}
> -
> -		/* remain in tasklet until all
> -		 * capabilities responses are received
> -		 */
> -		if (!adapter->wait_capability)
> -			done = true;
>  	}
>  	/* if capabilities CRQ's were sent in this tasklet, the following
>  	 * tasklet must wait until all responses are received
