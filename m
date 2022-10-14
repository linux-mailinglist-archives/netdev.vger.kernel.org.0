Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F31395FED3B
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 13:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbiJNLec (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 07:34:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229594AbiJNLeb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 07:34:31 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 413AF1B8670;
        Fri, 14 Oct 2022 04:34:30 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29EA1m7D016183;
        Fri, 14 Oct 2022 11:34:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=buSuzlHntogVUPFfK4RjBL+S+bw9W06CKCs0MSyl9P8=;
 b=eV59XwaMjiJu303pF/9lf/QwSCe+EXQIJF3oHtMtLh2nKkiLVrhbidNCVVtLOlcofQzq
 /hQlb21uMdveYxDZC9fpTSTi+HhEOyA9EPnxXWLc68zxAtxgCK9oR+Jh5uPfH82hQvm4
 elXVMJB10sx09WwYw/uBHFgRME4GL53Ct25v6SEVyM2Y4NHsYzzcpD+sF8fcUFqTmp7M
 Lp2jOTLqLBZA61w3tqfQ++BobESBobqF5ToVwMl8iu6/4hBvr76M5jdmT0vrzDKxkQMf
 17HpP667OWlYH7B8jfH+sGhHV7Nw/tYaVPExtAStgBIYQHFD9PziSTYGajQuATU6SSrD Gg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k6mvr647f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Oct 2022 11:34:22 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29EBPgA6010304;
        Fri, 14 Oct 2022 11:34:22 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k6mvr646v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Oct 2022 11:34:22 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29EBJv0M011687;
        Fri, 14 Oct 2022 11:34:21 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma05wdc.us.ibm.com with ESMTP id 3k30ub5nya-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Oct 2022 11:34:21 +0000
Received: from smtpav01.dal12v.mail.ibm.com ([9.208.128.133])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29EBYIAF10158618
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Oct 2022 11:34:19 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E3EF55805D;
        Fri, 14 Oct 2022 11:34:19 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 52D9958058;
        Fri, 14 Oct 2022 11:34:18 +0000 (GMT)
Received: from [9.211.93.235] (unknown [9.211.93.235])
        by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 14 Oct 2022 11:34:18 +0000 (GMT)
Message-ID: <28880e7d-c02b-0b34-d1f3-54596ec7f297@linux.ibm.com>
Date:   Fri, 14 Oct 2022 13:34:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.3.2
Subject: Re: [PATCH net] net/smc: Fix an error code in smc_lgr_create()
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Karsten Graul <kgraul@linux.ibm.com>
Cc:     Jan Karcher <jaka@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <Y0ktLDGg0CafxS3d@kili>
From:   Wenjia Zhang <wenjia@linux.ibm.com>
In-Reply-To: <Y0ktLDGg0CafxS3d@kili>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Gj7G9BtQaf6evLdoF3VoeaiNKhjeEn_I
X-Proofpoint-GUID: FT_juMmEEVT1y6dkNnOdPhwOjpctwwxr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-14_06,2022-10-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 impostorscore=0 lowpriorityscore=0 adultscore=0 suspectscore=0 spamscore=0
 clxscore=1011 mlxscore=0 priorityscore=1501 mlxlogscore=999 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210140066
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 14.10.22 11:34, Dan Carpenter wrote:
> If smc_wr_alloc_lgr_mem() fails then return an error code.  Don't return
> success.
> 
> Fixes: 8799e310fb3f ("net/smc: add v2 support to the work request layer")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>   net/smc/smc_core.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
> index e6ee797640b4..c305d8dd23f8 100644
> --- a/net/smc/smc_core.c
> +++ b/net/smc/smc_core.c
> @@ -896,7 +896,8 @@ static int smc_lgr_create(struct smc_sock *smc, struct smc_init_info *ini)
>   		}
>   		memcpy(lgr->pnet_id, ibdev->pnetid[ibport - 1],
>   		       SMC_MAX_PNETID_LEN);
> -		if (smc_wr_alloc_lgr_mem(lgr))
> +		rc = smc_wr_alloc_lgr_mem(lgr);
> +		if (rc)
>   			goto free_wq;
>   		smc_llc_lgr_init(lgr, smc);
>   

Good catch! Thank you for your effort!
Reviewed-by: Wenjia Zhang <wenjia@linux.ibm.com>
