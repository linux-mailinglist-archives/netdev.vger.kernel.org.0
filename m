Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 661686A5979
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 13:52:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231393AbjB1Mwb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 07:52:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbjB1Mw3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 07:52:29 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5687E301BA;
        Tue, 28 Feb 2023 04:52:28 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31SClJOF022908;
        Tue, 28 Feb 2023 12:52:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=y1p6F/CJ518kYLZkFaSzDgF34ZKZzZv0KqTatFnWR0M=;
 b=n37g6FcDCSOFTVQ6m0u2cU8LOPOLmFQpP9U3X+oEz6JuZZTX0HhFfML/LbLkwKC7kv6M
 KLUz/kjmJ5NmnbjqTfGE5z7dMLHl+oXeNu+ovx71reqKesxDI+2ODMhStEEKgzaVc0ol
 iuFgP8H9Io24096Mx2jRtPUKi5XScuVw7HGQoo9q87MWEpt6OM1k+j0KiKzCoHtVmH8u
 7XFES5SqMVjZss4Wqr+XbTb6AznYP4tZ03E6zQ8HgpKNE8tFO+gOnqv+IpNNCRZQVG8e
 lPW1+UMIruvomaWT9cFIKoDPBG0OpzAnwbrpMseG92qytrvBj4lQWu4mt0KyBOu2lUJz Pw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p1hx5g2tw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Feb 2023 12:52:25 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31SCnKwT027111;
        Tue, 28 Feb 2023 12:52:24 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p1hx5g2t6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Feb 2023 12:52:24 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31SC8u91017424;
        Tue, 28 Feb 2023 12:52:23 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([9.208.130.99])
        by ppma01dal.us.ibm.com (PPS) with ESMTPS id 3nybchd6t3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Feb 2023 12:52:23 +0000
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
        by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31SCqL5E31130346
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Feb 2023 12:52:21 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3DBA058053;
        Tue, 28 Feb 2023 12:52:21 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 88C3B58043;
        Tue, 28 Feb 2023 12:52:19 +0000 (GMT)
Received: from [9.211.152.15] (unknown [9.211.152.15])
        by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 28 Feb 2023 12:52:19 +0000 (GMT)
Message-ID: <d1b06606-f01c-918e-0921-5d6c697f9c89@linux.ibm.com>
Date:   Tue, 28 Feb 2023 13:52:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
Subject: Re: [PATCH net-next v2] net/smc: Use percpu ref for wr tx reference
To:     Guangguan Wang <guangguan.wang@linux.alibaba.com>,
        Kai <KaiShen@linux.alibaba.com>, kgraul@linux.ibm.com,
        jaka@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <20230227121616.448-1-KaiShen@linux.alibaba.com>
 <b869713b-7f1d-4093-432c-9f958f5bd719@linux.ibm.com>
 <e10d76c4-3b2c-b906-07c3-9a42b1c485bb@linux.alibaba.com>
 <b0669898-f7b3-fa88-7365-e7e05a587d86@linux.alibaba.com>
From:   Wenjia Zhang <wenjia@linux.ibm.com>
In-Reply-To: <b0669898-f7b3-fa88-7365-e7e05a587d86@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: VO6XmPbSJ4DgcY25mJR-90bHsGE0I4j-
X-Proofpoint-GUID: J1sVcHuvNGSYXAC95IfV2Egh_Vqqy9DI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-02-28_08,2023-02-28_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 bulkscore=0 clxscore=1015 malwarescore=0 priorityscore=1501
 lowpriorityscore=0 spamscore=0 mlxlogscore=950 phishscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302280101
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 28.02.23 13:15, Guangguan Wang wrote:
> 
> On 2023/2/28 19:34, Kai wrote:
>>
>>
>> On 2023/2/28 6:55 下午, Wenjia Zhang wrote:
>>
>>> @Kai, the performance improvement seems not so giant, but the method looks good, indeed. However, to keep the consistency of the code, I'm wondering why you only use the perf_ref for wr_tx_wait, but not for wr_reg_refcnt?
>> Didn't check the similar refcnt, my bad.
>> On the other hand, Our work is inspired by performance analysis, it seems wr_reg_refcnt is not on the IO path. It may not contribute to performance improvement.
>> And inspired by your comment, it seems we can also make the refcnt cdc_pend_tx_wr a perfcpu one. I will look into this.
>>
>> Thanks
> 
> cdc_pend_tx_wr needs to be zero value tested every time it decreases in smc_cdc_tx_handler.
> I don't think this is the right scenario for percpu_ref.

I agree, that's why I didn't mention it;)

But could you please check about wr_reg_refcnt? Because we do need to 
find the right balance between the code consistency and improvement
