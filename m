Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67DC54AD469
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 10:11:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353078AbiBHJLK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 04:11:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353103AbiBHJLI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 04:11:08 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC4DBC03FEE6;
        Tue,  8 Feb 2022 01:11:06 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2186NgoC023009;
        Tue, 8 Feb 2022 09:11:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=xCHUlRjEw83eqiNlE4+9PV8BubYZQd/8xSz+xmQ5TFU=;
 b=B2luCWi+F0zz8f9vcdIwNhRF+WYXHpapcgDrpl7cAGr9y/jnYCM/WqRzOgnEzQVbXqwl
 J42owCRyxsP9s7XtB3TApuqJyp6e/yXGRCmB+HYwN20xbBnYPfVlzF5DDDo+ri48f/uq
 S+uhrh6DfVcvE6e8fxnS/kBUY8O0pMOyiBo7uWUSf+PydV6CFsV+Pm9VYI+GMo1+f+vI
 bqU3CIV3fTWwLedbm+HUfHb5NGJKTMeOjyTWiptU0Di1zmCCbbjMcSh1b4HEkrDl6rTn
 itkzYdgOxBBsJj82dYcUxGx4bE1lMWpomX69bCHHL1wyERKbpK3y3CjYgi+OVyUwHZyq hw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e22kqm1dp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 09:11:01 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 2188V2nW027560;
        Tue, 8 Feb 2022 09:11:00 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e22kqm1d5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 09:11:00 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2189902F016132;
        Tue, 8 Feb 2022 09:10:59 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma05fra.de.ibm.com with ESMTP id 3e1gva2vfw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 09:10:58 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2189Au7w33817082
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Feb 2022 09:10:56 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 70422AE051;
        Tue,  8 Feb 2022 09:10:56 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 172B3AE045;
        Tue,  8 Feb 2022 09:10:56 +0000 (GMT)
Received: from [9.171.11.11] (unknown [9.171.11.11])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  8 Feb 2022 09:10:56 +0000 (GMT)
Message-ID: <6d88abaa-62b8-c2ae-2b96-ceca6eea28e7@linux.ibm.com>
Date:   Tue, 8 Feb 2022 10:10:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH net-next] net/smc: Allocate pages of SMC-R on ibdev NUMA
 node
Content-Language: en-US
To:     Leon Romanovsky <leon@kernel.org>,
        Tony Lu <tonylu@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, kuba@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        RDMA mailing list <linux-rdma@vger.kernel.org>
References: <20220130190259.94593-1-tonylu@linux.alibaba.com>
 <YfeN1BfPqhVz8mvy@unreal> <YgDtnk8g7y5oRKXB@TonyMac-Alibaba>
 <YgEjZonizb1Ugg2b@unreal>
From:   Stefan Raspl <raspl@linux.ibm.com>
In-Reply-To: <YgEjZonizb1Ugg2b@unreal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: K0cj7u5Of_OXnWPmPZFaonClO747VLOQ
X-Proofpoint-ORIG-GUID: b16vmd38Pse_jCRABD_31E5p6mwcJVkY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-08_02,2022-02-07_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011
 priorityscore=1501 bulkscore=0 spamscore=0 impostorscore=0 suspectscore=0
 mlxlogscore=999 lowpriorityscore=0 adultscore=0 malwarescore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202080051
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/7/22 14:49, Leon Romanovsky wrote:
> On Mon, Feb 07, 2022 at 05:59:58PM +0800, Tony Lu wrote:
>> On Mon, Jan 31, 2022 at 09:20:52AM +0200, Leon Romanovsky wrote:
>>> On Mon, Jan 31, 2022 at 03:03:00AM +0800, Tony Lu wrote:
>>>> Currently, pages are allocated in the process context, for its NUMA node
>>>> isn't equal to ibdev's, which is not the best policy for performance.
>>>>
>>>> Applications will generally perform best when the processes are
>>>> accessing memory on the same NUMA node. When numa_balancing enabled
>>>> (which is enabled by most of OS distributions), it moves tasks closer to
>>>> the memory of sndbuf or rmb and ibdev, meanwhile, the IRQs of ibdev bind
>>>> to the same node usually. This reduces the latency when accessing remote
>>>> memory.
>>>
>>> It is very subjective per-specific test. I would expect that
>>> application will control NUMA memory policies (set_mempolicy(), ...)
>>> by itself without kernel setting NUMA node.
>>>
>>> Various *_alloc_node() APIs are applicable for in-kernel allocations
>>> where user can't control memory policy.
>>>
>>> I don't know SMC-R enough, but if I judge from your description, this
>>> allocation is controlled by the application.
>>
>> The original design of SMC doesn't handle the memory allocation of
>> different NUMA node, and the application can't control the NUMA policy
>> in SMC.
>>
>> It allocates memory according to the NUMA node based on the process
>> context, which is determined by the scheduler. If application process
>> runs on NUMA node 0, SMC allocates on node 0 and so on, it all depends
>> on the scheduler. If RDMA device is attached to node 1, the process runs
>> on node 0, it allocates memory on node 0.
>>
>> This patch tries to allocate memory on the same NUMA node of RDMA
>> device. Applications can't know the current node of RDMA device. The
>> scheduler knows the node of memory, and can let applications run on the
>> same node of memory and RDMA device.
> 
> I don't know, everything explained above is controlled through memory
> policy, where application needs to run on same node as ibdev.

The purpose of SMC-R is to provide a drop-in replacement for existing TCP/IP 
applications. The idea is to avoid almost any modification to the application, 
just switch the address family. So while what you say makes a lot of sense for 
applications that intend to use RDMA, in the case of SMC-R we can safely assume 
that most if not all applications running it assume they get connectivity 
through a non-RDMA NIC. Hence we cannot expect the applications to think about 
aspects such as NUMA, and we should do the right thing within SMC-R.

Ciao,
Stefan
