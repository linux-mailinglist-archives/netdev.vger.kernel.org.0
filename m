Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC297467287
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 08:23:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378851AbhLCH1R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 02:27:17 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:27468 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1378847AbhLCH1Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 02:27:16 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B35mtNJ014385;
        Fri, 3 Dec 2021 07:23:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=7jK/DqTPoidVaJEX18uzm+IrGyjBANRXRpCuB5Lwwro=;
 b=tgwzXiiajNwAVBdUFEhoV+i0eCynkCBO5pSgeT6UIH8EW3ZGXkl20HJdVhWXw33zwC0q
 +gcfrBJtMfrGPJ9bMuSzNBBIemU/pbaRmXiV3n8I1d7ob3Zs5qyG+/U+VvIDFpSHhpBd
 x01YHUHbMsFPxMgKnCsLKwUnBPtC3WFWSid3xfdHDbsdW0PR1/auo6fe/h96Ar7OgMHB
 4c1/sgASugeC88I3u09UpA0CmXZJTdK/Z/d9QWxti+AWhY2947s89A2w6hCEvMWMbaVB
 Bt0cvD9HyDjIpAQRRqIuGM7gjVa1r1ViS+6/t2JaSdBGgLIjHwyx83JANqLTdjnVMGLw Zg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cqd1khxu6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Dec 2021 07:23:50 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B37NeGI002902;
        Fri, 3 Dec 2021 07:23:50 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cqd1khxtq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Dec 2021 07:23:50 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B37LSP6012587;
        Fri, 3 Dec 2021 07:23:48 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma05fra.de.ibm.com with ESMTP id 3ckcaa8knd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Dec 2021 07:23:47 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B37NjZk32637258
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 3 Dec 2021 07:23:45 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7AF4511C093;
        Fri,  3 Dec 2021 07:23:45 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2994D11C097;
        Fri,  3 Dec 2021 07:23:45 +0000 (GMT)
Received: from [9.145.87.55] (unknown [9.145.87.55])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  3 Dec 2021 07:23:45 +0000 (GMT)
Message-ID: <d74219b7-79b4-7286-1dcd-8cbd9b93408b@linux.ibm.com>
Date:   Fri, 3 Dec 2021 08:23:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH net] net/smc: Clear memory when release and reuse buffer
Content-Language: en-US
To:     Tony Lu <tonylu@linux.alibaba.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org
References: <20211125122858.90726-1-tonylu@linux.alibaba.com>
 <20211126112855.37274cb7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YaWR6zXoYKrqtznt@TonyMac-Alibaba>
 <a98a49d9-a7e9-4dbc-8e3d-8ff4d917546b@linux.ibm.com>
 <YamPi+seNs4yhlaV@TonyMac-Alibaba>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <YamPi+seNs4yhlaV@TonyMac-Alibaba>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: sRLAGiD8T25GMtzDikTi07te54AOedkl
X-Proofpoint-GUID: KE5RjdCQPbN3n6dDyPrkS9Anj9Sn24Yc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-03_04,2021-12-02_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 malwarescore=0 phishscore=0 impostorscore=0 mlxscore=0 priorityscore=1501
 lowpriorityscore=0 spamscore=0 bulkscore=0 mlxlogscore=901 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112030044
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03/12/2021 04:31, Tony Lu wrote:
> On Thu, Dec 02, 2021 at 03:23:07PM +0100, Karsten Graul wrote:
>> On 30/11/2021 03:52, Tony Lu wrote:
>>> Sorry for the unclear tag. This patch introduces a performance
>>> improvement. It should be with net-next.
>>>
>>> I will fix it and send v2. Thank you.
>>
>> Will you now send a v2 to net-next, or should I pick your v1 and 
>> submit it via our tree?
> 
> Sorry about my unclear reply in the previous mail. It's nice to pick v1
> to your tree. If v2 is needed, I will send it out soon. Thank you.
> 
> Thanks,
> Tony Lu
> 

Okay, I pick it up now. Thank you.
