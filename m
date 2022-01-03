Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0EB482F37
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 10:09:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232302AbiACJJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 04:09:09 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:41388 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230515AbiACJJI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 04:09:08 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2037Rxan028830;
        Mon, 3 Jan 2022 09:09:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=glghL1iPQhHGW1OByj7w1LqP5lccxcuTD5PDTNX9yyU=;
 b=pnX9cG6/0swQNPjJG+FldCpuE4GR2sCs0M5Xb39WvH29O6jDRlJ2/OWYNQ7VlccYalYk
 c6FFDqATCGL8GerCyBYya4AzvcPiCfSEMzg0hKjFTMScgWbROhArgwygcHqe3sjtNsrG
 kz+/BktZ5aKrtcQaVGwGIfKra3endhdhHBxjgWXgRy7MhWJzt8lmmTdk8MeP+l05VZXI
 ZtnC3fRkhIWBK7iM2O1YtKOQMt4PLV3ZrToV/M3UdbFxfbdB59BO5cZPuauvIDgUI3Gv
 /yx1yeTWva/h5maRoAIlWvC7VK/v94du2coxvHBRJZ1mDMDmLJl4YXySKnk9ju9/AC/V qw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dbrpxnk8t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Jan 2022 09:09:03 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20398Fsa001783;
        Mon, 3 Jan 2022 09:09:03 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dbrpxnk89-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Jan 2022 09:09:03 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20398Snu022513;
        Mon, 3 Jan 2022 09:09:01 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma05fra.de.ibm.com with ESMTP id 3daek98ka2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Jan 2022 09:09:01 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20390GpU46727588
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 3 Jan 2022 09:00:16 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 03A2D11C05B;
        Mon,  3 Jan 2022 09:08:59 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ABFDD11C04C;
        Mon,  3 Jan 2022 09:08:58 +0000 (GMT)
Received: from [9.145.23.206] (unknown [9.145.23.206])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  3 Jan 2022 09:08:58 +0000 (GMT)
Message-ID: <d08fabaa-88e8-0980-7ca2-896c7f535b88@linux.ibm.com>
Date:   Mon, 3 Jan 2022 10:09:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH net-next] net/smc: Introduce TCP ULP support
Content-Language: en-US
To:     Tony Lu <tonylu@linux.alibaba.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <20211228134435.41774-1-tonylu@linux.alibaba.com>
 <97ea52de-5419-22ee-7f55-b92887dcaada@linux.ibm.com>
 <Yc7JpBuI718bVzW3@TonyMac-Alibaba>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <Yc7JpBuI718bVzW3@TonyMac-Alibaba>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: tAvGpqNbU2ILu_ld-jFezBByO7L-g4jp
X-Proofpoint-ORIG-GUID: 9oYEa_zbgrcpWgdoiv8Rxg_OszzBbS8u
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-03_03,2022-01-01_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 spamscore=0 lowpriorityscore=0 phishscore=0 clxscore=1015
 priorityscore=1501 mlxscore=0 malwarescore=0 mlxlogscore=883
 impostorscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2201030061
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31/12/2021 10:13, Tony Lu wrote:
> On Thu, Dec 30, 2021 at 04:03:19PM +0100, Karsten Graul wrote:
>> On 28/12/2021 14:44, Tony Lu wrote:
>>> This implements TCP ULP for SMC, helps applications to replace TCP with
>>> SMC protocol in place. And we use it to implement transparent
>>> replacement.
>>>
>>> This replaces original TCP sockets with SMC, reuse TCP as clcsock when
>>> calling setsockopt with TCP_ULP option, and without any overhead.
>>
>> This looks very interesting. Can you provide a simple userspace example about 
>> how to use ULP with smc?
> 
> Here is a userspace C/S application:

Thanks for the example, it was very helpful!
