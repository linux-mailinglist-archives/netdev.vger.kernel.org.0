Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88CD2562403
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 22:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237212AbiF3UQf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 16:16:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236609AbiF3UQe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 16:16:34 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9F5F443E9;
        Thu, 30 Jun 2022 13:16:33 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25UJIOxk032478;
        Thu, 30 Jun 2022 20:16:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=M6h9rCysIve6/4MDaHJHBceL6zoUVpld+iy6duPPzP0=;
 b=jX9iLG/g2sitZSwByO685IZ4yIqR6tfDHbHifOtPDSiHAnsvvrM7k2xAgTp6mUepWObK
 OvkCGIUXRwj2+J9SuAjJN92y1qms59OkItRG3stD/QRvTxYL4wMEASYD9XJwSlkak3FX
 9w670aVFElkjeaJbpLG3Zenc7Wa/iRl/6ZR1W/FxHP2KBJy82igWoyB5M1GhtrUBAlx/
 NU0dPSi2ydkYdLeILm6bxHxPuSIQ4pFwvDgnIBrDb/qKl4yYuWOjMcKnmTzLrc1rQIjY
 WhzaNChqBsoAfjcpvrTVVv3EXwGTyMR7JENvysTtEztOq+5ZTpHmP3hxeE9qvG02Y+67 8A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h1hvf9xhu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Jun 2022 20:16:20 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25UJTGv7015427;
        Thu, 30 Jun 2022 20:16:19 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h1hvf9xgk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Jun 2022 20:16:19 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25UK5wN8020235;
        Thu, 30 Jun 2022 20:16:18 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma05wdc.us.ibm.com with ESMTP id 3gwt0anab1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Jun 2022 20:16:18 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25UKGH3C56361320
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Jun 2022 20:16:17 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C9C98112062;
        Thu, 30 Jun 2022 20:16:17 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C3C37112061;
        Thu, 30 Jun 2022 20:16:15 +0000 (GMT)
Received: from [9.211.159.19] (unknown [9.211.159.19])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 30 Jun 2022 20:16:15 +0000 (GMT)
Message-ID: <fcac3b0c-db51-7221-d41a-0207144f131c@linux.ibm.com>
Date:   Thu, 30 Jun 2022 22:16:14 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Subject: Re: [PATCH net-next v2] net/smc: align the connect behaviour with TCP
To:     Guangguan Wang <guangguan.wang@linux.alibaba.com>
Cc:     davem@davemloft.net, Karsten Graul <kgraul@linux.ibm.com>,
        liuyacan@corp.netease.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com
References: <26d43c65-1f23-5b83-6377-3327854387c4@linux.ibm.com>
 <20220524125725.951315-1-liuyacan@corp.netease.com>
 <3bb9366d-f271-a603-a280-b70ae2d59c00@linux.ibm.com>
 <8a15e288-4534-501c-8b3d-c235ae93238f@linux.ibm.com>
 <d2195919-1cae-b667-c137-8398848fa43b@linux.alibaba.com>
From:   Wenjia Zhang <wenjia@linux.ibm.com>
In-Reply-To: <d2195919-1cae-b667-c137-8398848fa43b@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: CMcqm8_cUXiFbKypbQ8ENzzB_-f_ZRuU
X-Proofpoint-GUID: HYvWA50vrtk3KRUVBO-AnEw9-n12uWtq
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-30_14,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 impostorscore=0 mlxscore=0 phishscore=0 clxscore=1015 bulkscore=0
 mlxlogscore=933 priorityscore=1501 lowpriorityscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206300073
X-Spam-Status: No, score=0.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,
        SCC_BODY_URI_ONLY,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 30.06.22 16:29, Guangguan Wang wrote:
> I'm so sorry I missed the last emails for this discussion.
> 
> Yes, commit (86434744) is the trigger of the problem described in
> https://lore.kernel.org/linux-s390/45a19f8b-1b64-3459-c28c-aebab4fd8f1e@linux.alibaba.com/#t  .
> 
> And I have tested just remove the following lines from smc_connection() can solve the above problem.
> if (smc->use_fallback)
>       goto out;
> 
> I aggree that partly reverting the commit (86434744) is a better solution.
> 
> Thanks,
> Guangguan Wang
Thank you for your effort!
Would you like to revert this patch? We'll revert the commit (86434744) 
partly.
