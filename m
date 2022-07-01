Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBD155633A5
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 14:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236427AbiGAMpg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 08:45:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236428AbiGAMpf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 08:45:35 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99CA72B263;
        Fri,  1 Jul 2022 05:45:34 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 261CcQVB025997;
        Fri, 1 Jul 2022 12:45:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=ijW8+X9I6GEhQsMMJAQpxBegezU8N6QyHu3cA/a0ot8=;
 b=OfUuyLktyDHR3zeqUqAk/uIsnnUfm1NRTVXlIDVbg2CsJRzuk+3tJd/72tumuf+1L0cy
 bq4455JBaAUHaIGbIBM6cLWJrQTmZoekZsIkGm4dV/EdNueht35eT44EcCh+kiJtVzZg
 5gzkiwOM3EDV5+wJ2avaHGsfLHNyKAObLG5fxSwAxkaKUn2Gau8zJe9WoQdG5h8at5d2
 ZYVjxtVTTr4rEThPxkmDRH6SP6raUSnp02phokH1itwU4Q3AMHcROA5Q0d49Pms8dFLV
 BIfkNtJjPTWCe+18Zj/lHYrgLx+VD2OsJeZVpklXiQCf0w2D1nuHwM3Ur+YeTq9wqwBr Lg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h20up8rfa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Jul 2022 12:45:26 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 261CciKQ027971;
        Fri, 1 Jul 2022 12:45:26 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h20up8reu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Jul 2022 12:45:26 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 261CaO9C002123;
        Fri, 1 Jul 2022 12:45:25 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma02dal.us.ibm.com with ESMTP id 3gwt0bbgp8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Jul 2022 12:45:25 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 261CjOhq62915008
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 1 Jul 2022 12:45:24 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5382F112061;
        Fri,  1 Jul 2022 12:45:24 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 05BFC112065;
        Fri,  1 Jul 2022 12:45:22 +0000 (GMT)
Received: from [9.163.16.104] (unknown [9.163.16.104])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri,  1 Jul 2022 12:45:21 +0000 (GMT)
Message-ID: <00aeafda-ed23-1066-c0b0-d8fb7f8ec2d2@linux.ibm.com>
Date:   Fri, 1 Jul 2022 14:45:20 +0200
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
 <fcac3b0c-db51-7221-d41a-0207144f131c@linux.ibm.com>
 <3e801eb5-6305-aa87-43a6-98f591d7d55c@linux.alibaba.com>
From:   Wenjia Zhang <wenjia@linux.ibm.com>
In-Reply-To: <3e801eb5-6305-aa87-43a6-98f591d7d55c@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: cu5U6BG5Ne_od5wBs9Jz-jFPB43Ue_um
X-Proofpoint-ORIG-GUID: EOrAQk_hgoVK8TSqrNob6FXGYG36jRSX
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-01_07,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1015
 mlxscore=0 lowpriorityscore=0 spamscore=0 adultscore=0 mlxlogscore=999
 bulkscore=0 phishscore=0 priorityscore=1501 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2207010048
X-Spam-Status: No, score=0.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,
        SCC_BODY_URI_ONLY,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 01.07.22 04:03, Guangguan Wang wrote:
> 
> 
> On 2022/7/1 04:16, Wenjia Zhang wrote:
>>
>>
>> On 30.06.22 16:29, Guangguan Wang wrote:
>>> I'm so sorry I missed the last emails for this discussion.
>>>
>>> Yes, commit (86434744) is the trigger of the problem described in
>>> https://lore.kernel.org/linux-s390/45a19f8b-1b64-3459-c28c-aebab4fd8f1e@linux.alibaba.com/#t  .
>>>
>>> And I have tested just remove the following lines from smc_connection() can solve the above problem.
>>> if (smc->use_fallback)
>>>        goto out;
>>>
>>> I aggree that partly reverting the commit (86434744) is a better solution.
>>>
>>> Thanks,
>>> Guangguan Wang
>> Thank you for your effort!
>> Would you like to revert this patch? We'll revert the commit (86434744) partly.
> 
> Did you mean revert commit (3aba1030)?
> Sorry, I think I led to a misunderstanding. I mean commit (86434744) is the trigger of the problem I replied
> in email https://lore.kernel.org/linux-s390/45a19f8b-1b64-3459-c28c-aebab4fd8f1e@linux.alibaba.com/#t, not
> the problem that commit (3aba1030) resolved for.
> 
> So I think the final solution is to remove the following lines from smc_connection() based on the current code.
> if (smc->use_fallback) {
> 	sock->state = rc ? SS_CONNECTING : SS_CONNECTED;
> 	goto out;
> }
> 
> Thanks,
> Guangguan Wang
That would be also ok for us, thanks!
