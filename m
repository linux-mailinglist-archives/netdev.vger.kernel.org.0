Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA529580E63
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 10:02:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232066AbiGZICO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 04:02:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbiGZICN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 04:02:13 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08D892C137;
        Tue, 26 Jul 2022 01:02:11 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26Q7M3Fo026351;
        Tue, 26 Jul 2022 08:02:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=q1o+wp+3H+tiRXndFN/Uezrr/b1aVcwLIgpSwzhNqg8=;
 b=jAj8nxY6/aVRS+/BOTeNg+AynWUBNsxPW3iCSIDP+IIrW8wqyRKQuxhRzDAbe3LzbWTk
 JqWXAZHTQqrde/PjK1/i/EPrGQfEPfgTE7hcdTtC8nGoNL49He3moNtOVPPnpkhJrG58
 nBTH3QUBWq1G5mqXZyDP3iNRNMBI+vw/8ZNYUw2VNbJpccslyHpi5z2ZfVH5//2lwugW
 lWT71jYyQ2ZJ/xHW4IFxTWfKfVHGDuQK7Nne7j7TI2LS26bJPn5Vj71JTEYVzeNas0z4
 ZPXI2JGYmLOVs4haw/uA+BS4rMFkthQwtC/ayV/6WBS4t8eiQ/PdnrKoUbKy24Fdu1lv Sg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3hjbtns5u5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Jul 2022 08:02:07 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26Q7M7Pf026503;
        Tue, 26 Jul 2022 08:02:06 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3hjbtns5tq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Jul 2022 08:02:06 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26Q7pJJL021418;
        Tue, 26 Jul 2022 08:02:05 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma04dal.us.ibm.com with ESMTP id 3hg989nq8c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Jul 2022 08:02:05 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26Q8246v49217948
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Jul 2022 08:02:04 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AFDF0124052;
        Tue, 26 Jul 2022 08:02:04 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B4953124055;
        Tue, 26 Jul 2022 08:02:02 +0000 (GMT)
Received: from [9.211.107.22] (unknown [9.211.107.22])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 26 Jul 2022 08:02:02 +0000 (GMT)
Message-ID: <2d753a9e-a09f-d962-2eca-5bc81b34b0ec@linux.ibm.com>
Date:   Tue, 26 Jul 2022 10:02:01 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH net-next 0/4] net/smc: updates 2022-7-25
To:     Tony Lu <tonylu@linux.alibaba.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>
References: <20220725141000.70347-1-wenjia@linux.ibm.com>
 <Yt9gDrS6Ag0Bd9id@TonyMac-Alibaba>
From:   Wenjia Zhang <wenjia@linux.ibm.com>
In-Reply-To: <Yt9gDrS6Ag0Bd9id@TonyMac-Alibaba>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: u-EzIDB5FjgErbXPF9VNPLenA8Ked4Mg
X-Proofpoint-ORIG-GUID: d-mcD9YrWux2h8FFCB9wXwwbkGV5SLZ2
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-26_02,2022-07-25_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 mlxscore=0 impostorscore=0 spamscore=0 malwarescore=0
 lowpriorityscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207260028
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 26.07.22 05:31, Tony Lu wrote:
> On Mon, Jul 25, 2022 at 04:09:56PM +0200, Wenjia Zhang wrote:
>> Hi Dave & Jakub,
>>
>> please apply the following patches to netdev's net-next tree.
>>
>> These patches do some preparation to make ISM available for uses beyond
>> SMC-D, and a bunch of cleanups.
>>
>> Thanks,
>> Wenjia
> 
> Hello Wenjia,
> 
> Making ISM available for others sounds great. I proposed a RFC [1] last
> week. The RFC brings an ISM-like device to accelerate inter-VM scenario.
> I am wondering the plan about this, which may help us. And hope to hear
> from you about the RFC [1]. Thank you.
> 
> [1] https://lore.kernel.org/all/20220720170048.20806-1-tonylu@linux.alibaba.com/
> 
> Cheers,
> Tony Lu

Hi Tony,

Thank you for the review first of all!

Besides this serie of patches, we are working on some follow-on patches. 
If you need, we can send you an RFC, so that you can adjust code 
according to it.

About the RFC you mentioned, it does look appealing even for us. But 
still some in-house discussions are going on in order to make sure there 
would be no risk for us. We will let you know as soon as we reach a 
consensus.

Best
Wenjia
