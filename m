Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D6C63DBE3B
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 20:16:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230449AbhG3SQ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 14:16:57 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:34586 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229921AbhG3SQ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 14:16:56 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16UI3vac158050;
        Fri, 30 Jul 2021 14:16:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=47G+jOd9ft2urcdZVKEMDZ0W/umlhqgBNQoiaG8/OGA=;
 b=MmozcAgtOxadFvhaSECQH4KmhgbRBg6VyWpLGX3FBtuagYmylENTaCuWR82/lNNfbPpb
 QJfiSQgTNSifUbi1oVVndx/rCdy1H/7S36oM4XhiUuN6IJWZ4ET3XDtCHkLDrST4RH2Q
 tfqKq/UxjHBu283tFp8IYQLePZmishK2Pp7/eqmxo/jF+F6+zIgYh5gToNqnRQvrrJqB
 NdbqtuiUus2teB5vKekm+w2HUPdFxhIKsaFDV0GC/ahvpW0zOlV8wJK3W/evsEIJdfgA
 qNLn333UfVsJWG6qEWqW49xmDlQ0rue3LB9jgqXzYZOC9Y7WOKP6EQ15gy09U5EidObu ag== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a4p568pj3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Jul 2021 14:16:34 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16UI75qd019316;
        Fri, 30 Jul 2021 18:16:33 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma03dal.us.ibm.com with ESMTP id 3a235u95p7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Jul 2021 18:16:33 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16UIGWiZ34472428
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Jul 2021 18:16:32 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 75B7D28060;
        Fri, 30 Jul 2021 18:16:32 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6A40028059;
        Fri, 30 Jul 2021 18:16:29 +0000 (GMT)
Received: from oc6857751186.ibm.com (unknown [9.160.21.31])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 30 Jul 2021 18:16:29 +0000 (GMT)
Subject: Re: [PATCH 36/64] scsi: ibmvscsi: Avoid multi-field memset() overflow
 by aiming at srp
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Kees Cook <keescook@chromium.org>
Cc:     linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Keith Packard <keithpac@amazon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com,
        Brian King <brking@linux.vnet.ibm.com>
References: <20210727205855.411487-1-keescook@chromium.org>
 <20210727205855.411487-37-keescook@chromium.org>
 <yq135rzp79c.fsf@ca-mkp.ca.oracle.com>
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
Message-ID: <6eae8434-e9a7-aa74-628b-b515b3695359@linux.ibm.com>
Date:   Fri, 30 Jul 2021 11:16:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <yq135rzp79c.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: gc5JE-Gvwp4LjpvIX5-GdEcqjSPid7w2
X-Proofpoint-GUID: gc5JE-Gvwp4LjpvIX5-GdEcqjSPid7w2
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-30_11:2021-07-30,2021-07-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 priorityscore=1501 spamscore=0 malwarescore=0
 impostorscore=0 mlxscore=0 clxscore=1011 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2107140000 definitions=main-2107300121
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/27/21 6:39 PM, Martin K. Petersen wrote:
> 
> Kees,
> 
>> In preparation for FORTIFY_SOURCE performing compile-time and run-time
>> field bounds checking for memset(), avoid intentionally writing across
>> neighboring fields.
>>
>> Instead of writing beyond the end of evt_struct->iu.srp.cmd, target the
>> upper union (evt_struct->iu.srp) instead, as that's what is being wiped.
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
> 
> Orthogonal to your change, it wasn't immediately obvious to me that
> SRP_MAX_IU_LEN was the correct length to use for an srp_cmd. However, I
> traversed the nested unions and it does look OK.
> 
> For good measure I copied Tyrel and Brian.

LGTM

Acked-by: Tyrel Datwyler <tyreld@linux.ibm.com>

> 
> Acked-by: Martin K. Petersen <martin.petersen@oracle.com>
> 
>> ---
>>  drivers/scsi/ibmvscsi/ibmvscsi.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
>> index e6a3eaaa57d9..7e8beb42d2d3 100644
>> --- a/drivers/scsi/ibmvscsi/ibmvscsi.c
>> +++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
>> @@ -1055,8 +1055,8 @@ static int ibmvscsi_queuecommand_lck(struct scsi_cmnd *cmnd,
>>  		return SCSI_MLQUEUE_HOST_BUSY;
>>  
>>  	/* Set up the actual SRP IU */
>> +	memset(&evt_struct->iu.srp, 0x00, SRP_MAX_IU_LEN);
>>  	srp_cmd = &evt_struct->iu.srp.cmd;
>> -	memset(srp_cmd, 0x00, SRP_MAX_IU_LEN);
>>  	srp_cmd->opcode = SRP_CMD;
>>  	memcpy(srp_cmd->cdb, cmnd->cmnd, sizeof(srp_cmd->cdb));
>>  	int_to_scsilun(lun, &srp_cmd->lun);
> 

