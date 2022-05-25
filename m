Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83D105339AB
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 11:13:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241102AbiEYJNu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 05:13:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241336AbiEYJNU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 05:13:20 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC5927B9E0;
        Wed, 25 May 2022 02:11:04 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24P92cDU010682;
        Wed, 25 May 2022 09:10:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=KmDnEpmAKlwDvh66i6W0q85Z+HrzyMRUjYZXy8tL/5I=;
 b=YWtTkV76EeaiL9yCfbjcNogPNOHAHoEP5xcbXwNN+z+akEOsIFI8M7C62KVgboE95KgR
 0Q8eJjdcbxD8ai3Dwj0sdWBIjMDspWXdvWloHYwq78QTKUHrKQ0OaXAyOYf8uU8uHyrR
 Y3mpH45wskA409v83d8dt4/IKzo8QZqHZnvsV6QeRKSueNQTqenFKppRouKQBG0KzHas
 rJflYv18Oi22UIny9xNVwxu/9tt1NDgEo4BgvwGU7iDE+pJLUnjK19HqIq1XhsVpbfxd
 eGhJgFvrbk/tKr3eDXGyuCS+h4Mj5QaGtngAnkW1qLc8mU8GEN/90S2zpYSHt5HdrxcD fg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g9hfnr5sg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 May 2022 09:10:57 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24P96sUE028023;
        Wed, 25 May 2022 09:10:57 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g9hfnr5rc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 May 2022 09:10:56 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24P97Lvx026762;
        Wed, 25 May 2022 09:10:55 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma01fra.de.ibm.com with ESMTP id 3g93vc0wpd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 May 2022 09:10:55 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24P9AqFn20185344
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 May 2022 09:10:53 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DEBB05204F;
        Wed, 25 May 2022 09:10:52 +0000 (GMT)
Received: from [9.171.70.153] (unknown [9.171.70.153])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 6141B5204E;
        Wed, 25 May 2022 09:10:52 +0000 (GMT)
Message-ID: <29c0ef74-27d9-b8a4-623d-770b36e488b6@linux.ibm.com>
Date:   Wed, 25 May 2022 11:10:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH net] net/smc: set ini->smcrv2.ib_dev_v2 to NULL if SMC-Rv2
 is unavailable
Content-Language: en-US
To:     liuyacan@corp.netease.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ubraun@linux.ibm.com
References: <20220525085408.812273-1-liuyacan@corp.netease.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20220525085408.812273-1-liuyacan@corp.netease.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: taSopZVY4RJmXrxq4FQi_L_0SWf8o9zH
X-Proofpoint-ORIG-GUID: rQiV8w1cm2U6SER2KgO_ADADsFTE5pc9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-25_02,2022-05-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 impostorscore=0 phishscore=0 suspectscore=0 priorityscore=1501
 lowpriorityscore=0 mlxscore=0 mlxlogscore=999 spamscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2205250043
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/05/2022 10:54, liuyacan@corp.netease.com wrote:
> From: liuyacan <liuyacan@corp.netease.com>
> 
> In the process of checking whether RDMAv2 is available, the current
> implementation first sets ini->smcrv2.ib_dev_v2, and then allocates
> smc buf desc and register rmb, but the latter may fail. In this case,
> the pointer should be reset.
> 
> Fixes: e49300a6bf62 ("net/smc: add listen processing for SMC-Rv2")
> Signed-off-by: liuyacan <liuyacan@corp.netease.com>
> ---
>  net/smc/af_smc.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
> index 45a24d242..540b32d86 100644
> --- a/net/smc/af_smc.c
> +++ b/net/smc/af_smc.c
> @@ -2136,6 +2136,7 @@ static void smc_find_rdma_v2_device_serv(struct smc_sock *new_smc,
>  
>  not_found:
>  	ini->smcr_version &= ~SMC_V2;
> +	ini->smcrv2.ib_dev_v2 = NULL;
>  	ini->check_smcrv2 = false;
>  }
>  

Thank you!

Reviewed-by: Karsten Graul <kgraul@linux.ibm.com>
