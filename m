Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2E63B88F6
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 21:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233573AbhF3THe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 15:07:34 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:28832 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233085AbhF3THc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 15:07:32 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15UJ2fJE160541
        for <netdev@vger.kernel.org>; Wed, 30 Jun 2021 15:05:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=mime-version :
 content-type : content-transfer-encoding : date : from : to : cc : subject
 : in-reply-to : references : message-id; s=pp1;
 bh=n1qysGKFJycpnO8ZWvWjjajWf9yE9gK3KISNfb8/V8M=;
 b=XokeFjeab4/5mgwpqE5DRPq/FsEUjIyqUFCxBqPej2GZ+t3o994F6+Yv8fg33zvSrZ6/
 ENk+3anMQbykC/sXuKIqryv0WNcveI4o8hbsokyoEMq+ftI+mWDhykzweF+wH5IGvFQh
 VkG1l/qtqz8pNYgp4j9B1ILUlwaxmnIlFNdujv8vRq1gyJSeg6FtUkrLIOADa3QZd6Z8
 03Okl84A51waLqA3XcmmHeyQHSoyEN1Y6F7569z4QTZ5Js0+AIAQwVglzyALSXxaOCJ4
 nW3xCKJYakJyZL4MbL7CCFGmsPxB8LARWcIYR5XP5nTJKWzOpJdDdS3dRaMq43jxVijW rA== 
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39gr824bnb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 30 Jun 2021 15:05:03 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15UIpfUU006372
        for <netdev@vger.kernel.org>; Wed, 30 Jun 2021 19:05:01 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma02wdc.us.ibm.com with ESMTP id 39duvd8mvb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 30 Jun 2021 19:05:01 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15UJ51gM30474628
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Jun 2021 19:05:01 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 515AAB206B;
        Wed, 30 Jun 2021 19:05:01 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1414CB205F;
        Wed, 30 Jun 2021 19:04:59 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.10.229.42])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 30 Jun 2021 19:04:59 +0000 (GMT)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 30 Jun 2021 12:04:59 -0700
From:   Dany Madden <drt@linux.ibm.com>
To:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc:     netdev@vger.kernel.org, brking@linux.vnet.ibm.com,
        ricklind@linux.vnet.ibm.com
Subject: Re: [PATCH 1/1] ibmvnic: retry reset if there are no other resets
In-Reply-To: <20210630183617.3093690-1-sukadev@linux.ibm.com>
References: <20210630183617.3093690-1-sukadev@linux.ibm.com>
Message-ID: <22a8ba0ae3f41f484de48a92171538d1@imap.linux.ibm.com>
X-Sender: drt@linux.ibm.com
User-Agent: Roundcube Webmail/1.1.12
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: gDM1YqRoXv4GVWk5VPBN-wk6vW8UlNDJ
X-Proofpoint-GUID: gDM1YqRoXv4GVWk5VPBN-wk6vW8UlNDJ
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-30_08:2021-06-30,2021-06-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 adultscore=0 mlxlogscore=999 malwarescore=0 clxscore=1015
 impostorscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106300106
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-06-30 11:36, Sukadev Bhattiprolu wrote:
> Normally, if a reset fails due to failover or other communication error
> there is another reset (eg: FAILOVER) in the queue and we would process
> that reset. But if we are unable to communicate with PHYP or VIOS after
> H_FREE_CRQ, there would be no other resets in the queue and the adapter
> would be in an undefined state even though it was in the OPEN state
> earlier. While starting the reset we set the carrier to off state so
> we won't even get the timeout resets.
> 
> If the last queued reset fails, retry it as a hard reset (after the
> usual 60 second settling time).
> 
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>

Reviewed-by: Dany Madden <drt@linux.ibm.com>

> ---
