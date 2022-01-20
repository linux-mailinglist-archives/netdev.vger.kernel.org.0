Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6741849508A
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 15:52:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356361AbiATOud (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 09:50:33 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:60864 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1355513AbiATOuc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 09:50:32 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20KEAVdN024673;
        Thu, 20 Jan 2022 14:50:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=G0GLH3eBIxn3Kw4jl0UpIRAQjkLezR3hyq+r6CC0WfM=;
 b=L79X4a1EC3HXz08vZTE+GX1HMfBsnmyQiIMBHpvSDJ8w8jHbYJD2QfdnwfIU+VP9j+OE
 gC30EHl3CukPghXyrGi3b14lOr7tMGKTtz+lT0B8jjuAip5FhCb5EsS5RBJlKupTwtE5
 IG/anDxA2nomEX5ScaIJXJ0vWhaeARl5RM3w14fziyhWX0NDYoyDLIhHuLvExgpX6sto
 IL2L3v9JtMDSkhQuK0wBL7loZ+pVBXovIekMQDYJKn1qUpvI4D94h0sEW92lprE8EevY
 3kUXAKGIEQVoCes6uTcMU7PiRaoPo2ssp7G+JHFueczfkqEie7loxOQZq2vjOnb0AZ9F Lw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dq7yc2u7p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Jan 2022 14:50:29 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20KEBkdZ000885;
        Thu, 20 Jan 2022 14:50:29 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dq7yc2u6m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Jan 2022 14:50:28 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20KEmBGw006868;
        Thu, 20 Jan 2022 14:50:26 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3dknwaakdj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Jan 2022 14:50:26 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20KEoOjJ44499398
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jan 2022 14:50:24 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 54BEB52065;
        Thu, 20 Jan 2022 14:50:24 +0000 (GMT)
Received: from [9.145.155.19] (unknown [9.145.155.19])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 145A352057;
        Thu, 20 Jan 2022 14:50:24 +0000 (GMT)
Message-ID: <4c600724-3306-0f0e-36dc-52f4f23825bc@linux.ibm.com>
Date:   Thu, 20 Jan 2022 15:50:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next] net/smc: Use kvzalloc for allocating
 smc_link_group
Content-Language: en-US
To:     Tony Lu <tonylu@linux.alibaba.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20220120140928.7137-1-tonylu@linux.alibaba.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20220120140928.7137-1-tonylu@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 4E58KdpiEjPVoyvWrAxK-SP3bbAjV13o
X-Proofpoint-GUID: vO0io9QmNxdihfN5Z0ND_K3LPE2waQdQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-20_04,2022-01-20_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 clxscore=1015 impostorscore=0 adultscore=0 mlxscore=0
 mlxlogscore=999 priorityscore=1501 spamscore=0 suspectscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201200076
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/01/2022 15:09, Tony Lu wrote:
> When analyzed memory usage of SMC, we found that the size of struct
> smc_link_group is 16048 bytes, which is too big for a busy machine to
> allocate contiguous memory. Using kvzalloc instead that falls back to
> vmalloc if there has not enough contiguous memory.

I am wondering where the needed contiguous memory for the required RMB buffers should come from when 
you don't even get enough storage for the initial link group?

The idea is that when the system is so low on contiguous memory then a link group creation should fail 
early, because most of the later buffer allocations will also fail then later.
