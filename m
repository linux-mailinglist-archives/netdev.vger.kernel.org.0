Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7600145DCBD
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 15:53:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355856AbhKYO4X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 09:56:23 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:12410 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1355859AbhKYOyW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 09:54:22 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1APCHdZb010397;
        Thu, 25 Nov 2021 14:51:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=RDU+6RaMcKi8LsoLVx0PAsUg3gVfUeSXG2cuejBX9uo=;
 b=MwmKsO2si5EoNMChA7yIhCQJAECUO4UilVPpXHbCQnAN2zCIV3CDSSsfFK6oFF8HEfsV
 lfkAhPckorJKRSjPc5ebD3p7x0jgT5nQ3ldVlJ65pAteop5PbHRg1llRhJTQwWG45rfv
 oDyfZDqsxLyawotzm3oPpY5Ao4q1A1YL59z01cVpWflxEp+DGMg/+bjNW7M/E6SgSF1/
 v0wcxg+PHOUfVT46TUQKWPZSMN57T1gncj4/DYZM98PwkexZDaE3z3evMULA8lNQQ4PL
 owv9P8176CcOxkUxfFbSSdaICowhUaaatRAGVcXUANQk8mou+q2xpijR33qb+LgjKaRE tQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cjac5k040-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Nov 2021 14:51:09 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1APEBjRc004920;
        Thu, 25 Nov 2021 14:51:09 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cjac5k03m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Nov 2021 14:51:09 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1APEfO52023771;
        Thu, 25 Nov 2021 14:51:07 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3cer9kc2mr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Nov 2021 14:51:07 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1APEp4Hi16122156
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Nov 2021 14:51:05 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E0C824C05C;
        Thu, 25 Nov 2021 14:51:04 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 825C04C04A;
        Thu, 25 Nov 2021 14:51:04 +0000 (GMT)
Received: from [9.145.172.86] (unknown [9.145.172.86])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 25 Nov 2021 14:51:04 +0000 (GMT)
Message-ID: <1a7b27ec-22fc-f1b0-6b7c-4a61c072ff38@linux.ibm.com>
Date:   Thu, 25 Nov 2021 15:51:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH net v2] net/smc: Don't call clcsock shutdown twice when
 smc shutdown
Content-Language: en-US
To:     Tony Lu <tonylu@linux.alibaba.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <20211125132431.23264-1-tonylu@linux.alibaba.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20211125132431.23264-1-tonylu@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: E_BNAYUOH-O9bz8qV9wY0gMzymq3QSCE
X-Proofpoint-ORIG-GUID: THLGHw5GCmQAC3V3qg5rnwqwEg_EINix
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-25_05,2021-11-25_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 clxscore=1015 priorityscore=1501 lowpriorityscore=0 malwarescore=0
 impostorscore=0 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111250078
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/11/2021 14:24, Tony Lu wrote:
> @@ -2398,7 +2400,12 @@ static int smc_shutdown(struct socket *sock, int how)
>  	}
>  	switch (how) {
>  	case SHUT_RDWR:		/* shutdown in both directions */
> +		old_state = sk->sk_state;
>  		rc = smc_close_active(smc);
> +		if (old_state == SMC_ACTIVE &&
> +		    sk->sk_state == SMC_PEERCLOSEWAIT1)
> +			do_shutdown = false;
> +
>  		break;

Please send a v3 without the extra empty line before the break statement,
and then the patch is fine with me.

Thank you!
