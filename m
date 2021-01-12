Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CA322F38F6
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 19:37:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392006AbhALSgb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 13:36:31 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:28904 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728889AbhALSgb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 13:36:31 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10CIW1rY065520
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 13:35:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=mime-version :
 content-type : content-transfer-encoding : date : from : to : cc : subject
 : in-reply-to : references : message-id; s=pp1;
 bh=gRAtOj77a8+L5xTlcvuCJMuY6nvtOIePjdulwKSt6Ho=;
 b=tfTAkc+7ZEPX9XQk2EUhXR4LW8Z6Hfra1z2hTkOYPE12IR5AX/1CoN+SgiLk4KpPF+YP
 Sezs0sGiJsd2iJ2MYzzM/3Egeir+zMmSFtiK5P6eRdFWfdPSl1ty5YYWU/7Cmn/eB/0J
 A/ZgYRCK3TEzZu9dGeZMbbaAVN7MVA6C/mK9Bi7eSxSHHr5TbErfwH9wMiIhg9pjO7wE
 K7pn1kRjfJ0DWXD7OvSCa+NrpsDSGMLDVjzKguscN+42HfHjMxlyjJOnjojDCV2jF0ar
 yFI22D9Uy2XK2KrbWbShsiz84o1evGfjQA6HTvzOkfLXOppp6RWk3nY81gw6D8PZyq5y Tg== 
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0b-001b2d01.pphosted.com with ESMTP id 361gue8knn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 13:35:50 -0500
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10CIHI48012029
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 18:35:49 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma04wdc.us.ibm.com with ESMTP id 35y44900x3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 18:35:49 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10CIZm5e25559448
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jan 2021 18:35:48 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 09CF6136059;
        Tue, 12 Jan 2021 18:35:48 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D032F13605D;
        Tue, 12 Jan 2021 18:35:47 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.10.229.42])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 12 Jan 2021 18:35:47 +0000 (GMT)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 12 Jan 2021 10:35:47 -0800
From:   Dany Madden <drt@linux.ibm.com>
To:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc:     netdev@vger.kernel.org, Lijun Pan <ljp@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>
Subject: Re: [PATCH net-next v2 1/7] ibmvnic: restore state in change-param
 reset
In-Reply-To: <20210112181441.206545-2-sukadev@linux.ibm.com>
References: <20210112181441.206545-1-sukadev@linux.ibm.com>
 <20210112181441.206545-2-sukadev@linux.ibm.com>
Message-ID: <6bb3682f009ea189182ae1307f237130@imap.linux.ibm.com>
X-Sender: drt@linux.ibm.com
User-Agent: Roundcube Webmail/1.1.12
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-12_15:2021-01-12,2021-01-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 adultscore=0 mlxlogscore=999 clxscore=1015 impostorscore=0
 bulkscore=0 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101120106
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-01-12 10:14, Sukadev Bhattiprolu wrote:
> Restore adapter state before returning from change-param reset.
> In case of errors, caller will try a hard-reset anyway.
> 
> Fixes: 0cb4bc66ba5e ("ibmvnic: restore adapter state on failed reset")
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Reviewed-by: Dany Madden <drt@linux.ibm.com>

> ---
>  drivers/net/ethernet/ibm/ibmvnic.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/ibm/ibmvnic.c
> b/drivers/net/ethernet/ibm/ibmvnic.c
> index f302504faa8a..d548779561fd 100644
> --- a/drivers/net/ethernet/ibm/ibmvnic.c
> +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> @@ -1960,7 +1960,7 @@ static int do_change_param_reset(struct
> ibmvnic_adapter *adapter,
>  	if (rc) {
>  		netdev_err(adapter->netdev,
>  			   "Couldn't initialize crq. rc=%d\n", rc);
> -		return rc;
> +		goto out;
>  	}
> 
>  	rc = ibmvnic_reset_init(adapter, true);
