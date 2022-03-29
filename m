Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0CE14EA96B
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 10:34:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233327AbiC2IgB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 04:36:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231997AbiC2If7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 04:35:59 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DC6023F3EA;
        Tue, 29 Mar 2022 01:34:17 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22T8LxiL011943;
        Tue, 29 Mar 2022 08:34:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Mh0ICy+oZWZaGxHyhXecfDnN+zHCPRzjb7zty8XhDyI=;
 b=TuYqHdML0GZZFEQ435um9OR6mAMuQ+Pm6Ra1iJKkyt0w65mJTi2KdJgwiQgn7W2FZzlN
 rhr8jua9rz8miWpELEhcyo2c6l4UkooyMygt6spR1P5FwpfqGOlj/A5ORke8sY7VR1gk
 WRmAlRSmozr72eq67e+DKQU7v6a20/WasWE+U6AHq2VIY5vTwPFJLMSyZtpa2UDsKS3L
 lnGoQDONKzCGG7ULS7KoCR5+7g3wulv3jDWKWswKl/eiNYAsSf24a3VE6akZOJDaRnyB
 vJetGhQljxe7o5XHraB5FNC88Lbg0jfc20tt4gDuwapItAFlLTrju+0i78wf1L5o/4tf Ig== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f3xhgg6px-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Mar 2022 08:34:00 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22T8MC0L014978;
        Tue, 29 Mar 2022 08:34:00 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f3xhgg6nm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Mar 2022 08:33:59 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22T8HcQj017704;
        Tue, 29 Mar 2022 08:33:57 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04fra.de.ibm.com with ESMTP id 3f1tf8vu4b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Mar 2022 08:33:56 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22T8XsRD43909526
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Mar 2022 08:33:54 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6F2784C04A;
        Tue, 29 Mar 2022 08:33:54 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F21E94C046;
        Tue, 29 Mar 2022 08:33:53 +0000 (GMT)
Received: from [9.152.224.43] (unknown [9.152.224.43])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 29 Mar 2022 08:33:53 +0000 (GMT)
Message-ID: <52973607-34d4-2cd8-8795-44410ca3233f@linux.ibm.com>
Date:   Tue, 29 Mar 2022 10:33:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH net-next 0/1] veth: Support bonding events
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>
References: <20220328081417.1427666-1-wintera@linux.ibm.com>
 <20220328191422.2acecf5f@kernel.org>
From:   Alexandra Winter <wintera@linux.ibm.com>
In-Reply-To: <20220328191422.2acecf5f@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 7w3wWYhmXfoAQfFmh2kLRNugxYQc3o8o
X-Proofpoint-ORIG-GUID: LAJ95XFvqt5sGohmTR0ZEhBfFB8BkJEK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-29_02,2022-03-28_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 impostorscore=0 mlxscore=0
 clxscore=1015 mlxlogscore=999 adultscore=0 spamscore=0 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203290050
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 29.03.22 04:14, Jakub Kicinski wrote:
> On Mon, 28 Mar 2022 10:14:16 +0200 Alexandra Winter wrote:
>> In case virtual instances are attached to an external network via veth
>> and a bridge, the interface to the external network can be a bond
>> interface. Bonding drivers generate specific events during failover
>> that trigger switch updates.  When a veth device is attached to a
>> bridge with a bond interface, we want external switches to learn about
>> the veth devices as well.
> 
> Can you please add an ASCII diagram of a setup your trying to describe?

	
	| veth_a2   |  veth_b2  |  veth_c2 |
	------o-----------o----------o------
	       \	  |	    /
		o	  o	   o
	      veth_a1  veth_b1  veth_c1
	      -------------------------
	      |        bridge         |
	      -------------------------
			bond0
			/  \
		     eth0  eth1

In case of failover from eth0 to eth1, the netdev_notifier needs to
be propagated, so e.g. veth_a2 can re-announce its MAC address to the
external hardware attached to eth1.

Does that help?
> 
>> Without this patch we have seen cases where recovery after bond
>> failover took an unacceptable amount of time (depending on timeout
>> settings in the network).
>>
>> Due to the symmetric nature of veth special care is required to avoid
>> endless notification loops. Therefore we only notify from a veth
>> bridgeport to a peer that is not a bridgeport.
>>
>> References:
>> Same handling as for macvlan:
>> 4c9912556867 ("macvlan: Support bonding events"
>> and vlan:
>> 4aa5dee4d999 ("net: convert resend IGMP to notifier event")
> 
> When sending a single patch change you can put all the information 
> in the commit message of the patch, the cover letter is only necessary
> for series of multiple patches.
Thank you, I will do so in v2. 
