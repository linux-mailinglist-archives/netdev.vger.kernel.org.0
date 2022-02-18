Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7A804BBCF8
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 17:04:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237193AbiBRQE3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 11:04:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233019AbiBRQE1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 11:04:27 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53AEC48E79;
        Fri, 18 Feb 2022 08:04:10 -0800 (PST)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21IFEhGX004475;
        Fri, 18 Feb 2022 16:04:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=2hopbCZ97CZ85OH0VfOjc6KE5jAmjXLJh7JqAcZEIVY=;
 b=qA9whTFrbaoQMeaHvGPsukqTXs9KiXka7zfpIDHX9SXmOV5pYRhBPR6XRx8xeNwvJVGY
 UGfKmu+P9osY5osK6rsBBF1wAPZUYMyGj5BZZ7/yeBufEuyYGELoLkDmpOi0baZS7vhH
 tPVZ/Wc3AbAeUQ2h6SFjUJTZ1jtTgFFqbQS+66HZBckAU6b2xREATO9eFbWH5uNuetjP
 Ie6k05CbxUH8PwuXSqw35FWB8puNopeUOizZurpsOkUIPdLDAjV24V6HZygQ21c/+X7n
 w8unYFo0ha8WNksPGEFmqfdVSo5DC7VbYKG5hdhD+wN30Q8EUXTTZMe3Tv4h1afT/Djq +w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3eadx297xk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Feb 2022 16:04:01 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21IFmSJs002721;
        Fri, 18 Feb 2022 16:04:00 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3eadx297vw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Feb 2022 16:04:00 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21IG0Ngx007995;
        Fri, 18 Feb 2022 16:03:58 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03fra.de.ibm.com with ESMTP id 3e64harhu1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Feb 2022 16:03:57 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21IG3s3X40894806
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Feb 2022 16:03:54 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2EA1E52057;
        Fri, 18 Feb 2022 16:03:54 +0000 (GMT)
Received: from [9.145.55.33] (unknown [9.145.55.33])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 9FD9952059;
        Fri, 18 Feb 2022 16:03:53 +0000 (GMT)
Message-ID: <d4ce4674-3ced-da34-a8a4-30d74cbe24bb@linux.ibm.com>
Date:   Fri, 18 Feb 2022 17:03:56 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH] net/smc: Add autocork support
Content-Language: en-US
To:     dust.li@linux.alibaba.com,
        Hendrik Brueckner <brueckner@linux.ibm.com>
Cc:     Stefan Raspl <raspl@linux.ibm.com>,
        Tony Lu <tonylu@linux.alibaba.com>, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <20220216034903.20173-1-dust.li@linux.alibaba.com>
 <68e9534b-7ff5-5a65-9017-124dbae0c74b@linux.ibm.com>
 <20220216152721.GB39286@linux.alibaba.com>
 <454b5efd-e611-2dfb-e462-e7ceaee0da4d@linux.ibm.com>
 <20220217132200.GA5443@linux.alibaba.com> <Yg6Q2kIDJrhvNVz7@linux.ibm.com>
 <20220218073327.GB5443@linux.alibaba.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20220218073327.GB5443@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: bnu36bG5hHeXDqt1iP_AokCYWbKlfLKJ
X-Proofpoint-GUID: __R3UhUD0lSkIz8DWgbRFNL_g0kMgLq8
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-18_06,2022-02-18_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 lowpriorityscore=0 suspectscore=0 priorityscore=1501 impostorscore=0
 spamscore=0 adultscore=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 clxscore=1015 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202180104
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/02/2022 08:33, dust.li wrote:
> On Thu, Feb 17, 2022 at 07:15:54PM +0100, Hendrik Brueckner wrote:
>> On Thu, Feb 17, 2022 at 09:22:00PM +0800, dust.li wrote:
>>> On Thu, Feb 17, 2022 at 10:37:28AM +0100, Stefan Raspl wrote:
>>>> On 2/16/22 16:27, dust.li wrote:
>>>>> On Wed, Feb 16, 2022 at 02:58:32PM +0100, Stefan Raspl wrote:
>>>>>> On 2/16/22 04:49, Dust Li wrote:
>>>>>>
>>>
>>>> Now we understand that cloud workloads are a bit different, and the desire to
>>>> be able to modify the environment of a container while leaving the container
>>>> image unmodified is understandable. But then again, enabling the base image
>>>> would be the cloud way to address this. The question to us is: How do other
>>>> parts of the kernel address this?
>>>
>>> I'm not familiar with K8S, but from one of my colleague who has worked
>>> in that area tells me for resources like CPU/MEM and configurations
>>> like sysctl, can be set using K8S configuration:
>>> https://kubernetes.io/docs/tasks/administer-cluster/sysctl-cluster/
>>
>> For K8s, this involves container engines like cri-o, containerd, podman,
>> and others towards the runtimes like runc.  To ensure they operate together,
>> specifications by the Open Container Initiative (OCI) at
>> https://opencontainers.org/release-notices/overview/
>>
>> For container/pod deployments, there is especially the Container Runtime
>> Interface (CRI) that defines the interface, e.g., of K8s to cri-o etc.
>>
>> CRI includes support for (namespaced) sysctl's:
>> https://github.com/opencontainers/runtime-spec/releases/tag/v1.0.2
>>
>> In essence, the CRI spec would allow users to specify/control a specific
>> runtime for the container in a declarative way w/o modifying the (base)
>> container images.
> 
> Thanks a lot for your kind explanation !
> 
> After a quick look at the OCI spec, I saw the support for file based
> configuration (Including sysfs/procfs etc.). And unfortunately, no
> netlink support.
> 
> 
> Hi Karsten & Stefan:
> Back to the patch itself, do you think I need to add the control switch
> now ? Or just leave the switch and fix other issues first ?

Hi, looks like we need more time to evaluate possibilities, so if you have 
additional topics on your desk move on and delay this one.
Right now for me it looks like there is no way to use netlink for container runtime
configuration, which is a pity.
We continue our discussions about this in the team, and also here on the list.

Thank you!


