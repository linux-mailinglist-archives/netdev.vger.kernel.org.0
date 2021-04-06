Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E815C354C17
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 07:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242749AbhDFFKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 01:10:17 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:54240 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230073AbhDFFKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 01:10:16 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13654GEX165262;
        Tue, 6 Apr 2021 01:10:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=2Z6yFg+IB/LQ/bk5GCuePZ+aDUr2YsWVutBwNj65EBA=;
 b=i+8ANsnp2fEQmcKHhR9901pXeT5tEoA1i10GXf+ncmTdPmgn3v36k8I7cO+4ueN/QTdn
 rYoM5REUFAvyHCC1KiGf8qDTIc8sNNRsQSjFq4YN7bbd51wKFtZ4kTI2K4NRDfc5QUZl
 Ke+8lzH5s+sj6wabOg1I10fC1aP9ezf1YCSlsA6IYyl2G0PDjh8eSLx2BrEH3TfHmOEL
 LOYLrFrum5u/ZeDmHAogFoAvQ6F71pg+58ayfZQMs3ZgCItUb/7ewxR59moezfpn8oxy
 Aa1RyO3r8DZccdGtbVINkjaMmL2uCx1Kh/+5lSXCJ316+clTs/+ycsm0O5UoOOSLPQ2y 5A== 
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37q604xkhb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Apr 2021 01:10:07 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13657xcO009139;
        Tue, 6 Apr 2021 05:10:06 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma01wdc.us.ibm.com with ESMTP id 37q2q8wghr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Apr 2021 05:10:06 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1365A6su19005780
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Apr 2021 05:10:06 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 43241112069;
        Tue,  6 Apr 2021 05:10:06 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C1CE1112064;
        Tue,  6 Apr 2021 05:10:03 +0000 (GMT)
Received: from [9.160.44.144] (unknown [9.160.44.144])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  6 Apr 2021 05:10:03 +0000 (GMT)
Subject: Re: [PATCH] ibmvnic: Continue with reset if set link down failed
To:     Dany Madden <drt@linux.ibm.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, sukadev@linux.ibm.com, ljp@linux.ibm.com,
        ricklind@linux.ibm.com
References: <20210406034752.12840-1-drt@linux.ibm.com>
From:   Rick Lindsley <ricklind@linux.vnet.ibm.com>
Message-ID: <6db4a1bd-adbe-52d3-6fa2-be71be12eb7b@linux.vnet.ibm.com>
Date:   Mon, 5 Apr 2021 22:10:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210406034752.12840-1-drt@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: INtPiDdNN5LOH5cDGIFcxqejPx3EG5fH
X-Proofpoint-GUID: INtPiDdNN5LOH5cDGIFcxqejPx3EG5fH
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-04-06_01:2021-04-01,2021-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 adultscore=0 suspectscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 impostorscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104030000 definitions=main-2104060033
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/5/21 8:47 PM, Dany Madden wrote:
> When an adapter is going thru a reset, it maybe in an unstable state that
> makes a request to set link down fail. In such a case, the adapter needs
> to continue on with reset to bring itself back to a stable state.
> 
> Fixes: ed651a10875f ("ibmvnic: Updated reset handling")
> Signed-off-by: Dany Madden <drt@linux.ibm.com>

Reviewed-by: Rick Lindsley <ricklind@linux.ibm.com>
