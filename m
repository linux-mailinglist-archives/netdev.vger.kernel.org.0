Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAA923991EA
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 19:47:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbhFBRtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 13:49:20 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:36236 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229574AbhFBRtR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 13:49:17 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 152HYQvj152742
        for <netdev@vger.kernel.org>; Wed, 2 Jun 2021 13:47:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=JVLvKAFJc5n4vUKw/MowFjqL5Yt3oEu5k64jYNAhhPo=;
 b=kCMzW1OLAUD+Ar+kAuZ8T02U70i1zBo0fAWL/qL5J3+LSvdTUSW5x0wjP+/CLyxNBZSr
 JyoEEhJN7/PFaeIX5QbDdAjhii18fwIovcZvPHhK4Ks+0m2y8EQ3/tYc/Ds/J103Dt7I
 cqNwVEBlUqT7QAHuoxGAcmpMCYqSWXtTEQsj+2NhQszTguzHXRI2KWxw1g613KphhY1n
 L8PDs7qFOtQMqa/Lee/pRLXSej4C0u8zL/4/vqKL9YNQ1DOFetypRs8lBMF1uwj2nbzd
 82fTKUxfemYK6dDa8cPUP7oZrsJY9JDZqXkHFoUC8piQKw5Rhb5SCDj/LfpMxfzggT5r xQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38xe0498vf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 02 Jun 2021 13:47:32 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 152HYgEs153537
        for <netdev@vger.kernel.org>; Wed, 2 Jun 2021 13:47:31 -0400
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38xe0498ux-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Jun 2021 13:47:31 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 152Hkmrw004292;
        Wed, 2 Jun 2021 17:47:30 GMT
Received: from b03cxnp07027.gho.boulder.ibm.com (b03cxnp07027.gho.boulder.ibm.com [9.17.130.14])
        by ppma02wdc.us.ibm.com with ESMTP id 38ud89sdnt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Jun 2021 17:47:30 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp07027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 152HlTDg30867824
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 2 Jun 2021 17:47:29 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B94B26E04E;
        Wed,  2 Jun 2021 17:47:29 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2ACE86E054;
        Wed,  2 Jun 2021 17:47:29 +0000 (GMT)
Received: from [9.160.41.210] (unknown [9.160.41.210])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed,  2 Jun 2021 17:47:28 +0000 (GMT)
Subject: Re: [PATCH net-next] net: ibm: replenish rx pool and poll less
 frequently
To:     Lijun Pan <lijunp213@gmail.com>, netdev@vger.kernel.org
References: <20210602170156.41643-1-lijunp213@gmail.com>
From:   Rick Lindsley <ricklind@linux.vnet.ibm.com>
Message-ID: <0bddd39e-b6da-2c69-fd37-a08bd5a1e18b@linux.vnet.ibm.com>
Date:   Wed, 2 Jun 2021 10:47:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210602170156.41643-1-lijunp213@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: s0KDrJwDjGB9jsj6RpgQJNqZfXfnO984
X-Proofpoint-GUID: 2QWNajfkHUrifG9VSp8TcfU9nnzr5lMm
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-02_09:2021-06-02,2021-06-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 bulkscore=0 mlxscore=0 clxscore=1011 impostorscore=0 adultscore=0
 priorityscore=1501 suspectscore=0 lowpriorityscore=0 phishscore=0
 mlxlogscore=945 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106020111
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/2/21 10:01 AM, Lijun Pan wrote:
> The old mechanism replenishes rx pool even only one frames is processed in
> the poll function, which causes lots of overheads. The old mechanism
> restarts polling until processed frames reaches the budget, which can
> cause the poll function to loop into restart_poll 63 times at most and to
> call replenish_rx_poll 63 times at most.

Presumably this frequency is to keep ahead of demand.  When you say lots
of overhead - can you attach a number to that?  How much does this change
improve on that number (what workload benefits?)
