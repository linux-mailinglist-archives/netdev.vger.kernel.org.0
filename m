Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6685F49E60C
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 16:28:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234785AbiA0P2l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 10:28:41 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:32018 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233711AbiA0P2k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 10:28:40 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20RFDQS7029501;
        Thu, 27 Jan 2022 15:28:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=1RhGbmelJqGMkcj2NwHS637JdQ29BM/p9rCbPkWpLA0=;
 b=TaNK9Xt31ZbGM5dsSxIIYSOYj2D+0zggCFFXe35ISLH/BpRonhqzBG63UUGdwBOD9ZrK
 v+GXBZdLQS3GhadV/wyhsG9LO1ztYY+pBcOpAgJUOZcU45neO77ll61fdtbGDbp0xWxJ
 IrRNF0ujnWzSNXJGA+SZiEK9Q7lMr8hNMO0M3N1QiTJHgsizxyokmidNdAC5A9vBGL5p
 wB+dkdEGoI7ST0M/os1arg/suj3rKlEjYjRema/Px09ST4gfm00NWP4EvcyPB5PTu2o6
 m8KN97skiHURUHoqV2ALaHYnu4I3T7CtViVspJyin0Y5JA+36fySTIHQi+Wo4WQV1uCl hw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3duwugr9pw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Jan 2022 15:28:37 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20RFDnsX029964;
        Thu, 27 Jan 2022 15:28:36 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3duwugr9p9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Jan 2022 15:28:36 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20RFI8Ph029048;
        Thu, 27 Jan 2022 15:28:35 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3dr9j9sgje-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Jan 2022 15:28:35 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20RFSWES40632746
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jan 2022 15:28:32 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A38E34C04E;
        Thu, 27 Jan 2022 15:28:32 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6D6EC4C044;
        Thu, 27 Jan 2022 15:28:32 +0000 (GMT)
Received: from [9.152.222.35] (unknown [9.152.222.35])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 27 Jan 2022 15:28:32 +0000 (GMT)
Message-ID: <8f56ed63-79b4-2a75-4e95-f4f6a0ad8430@linux.ibm.com>
Date:   Thu, 27 Jan 2022 16:28:38 +0100
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
 <4c600724-3306-0f0e-36dc-52f4f23825bc@linux.ibm.com>
 <YeoncJZoa3ELWyxM@TonyMac-Alibaba>
 <c5873d85-d791-319b-e3a1-86abda204b45@linux.ibm.com>
 <Ye51fyoWrXTevmLa@TonyMac-Alibaba>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <Ye51fyoWrXTevmLa@TonyMac-Alibaba>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: CHtS7XBBw6KD0-u4xujdaEy6gANKcDZX
X-Proofpoint-ORIG-GUID: XNcljYCyM-PHjNy1Wx0I2ApPu4M8Eqqi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-27_03,2022-01-27_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 adultscore=0 clxscore=1015 priorityscore=1501 phishscore=0 mlxlogscore=999
 lowpriorityscore=0 impostorscore=0 malwarescore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201270092
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24/01/2022 10:46, Tony Lu wrote:
> On Fri, Jan 21, 2022 at 12:06:56PM +0100, Karsten Graul wrote:
>> On 21/01/2022 04:24, Tony Lu wrote:
>>> On Thu, Jan 20, 2022 at 03:50:26PM +0100, Karsten Graul wrote:
>>>> On 20/01/2022 15:09, Tony Lu wrote:
>> I am still not fully convinced of this change. It does not harm and the overhead of
>> a vmalloc() is acceptable because a link group is not created so often. But since
>> kvzmalloc() will first try to use normal kmalloc() and if that fails switch to the
>> (more expensive) vmalloc() this will not _save_ any contiguous memory.
>> And for the subsequent required allocations of at least one RMB we need another 16KB.
> I agree with you. kvzmalloc doesn't save contiguous memory for the most
> time, only when high order contiguous memory is used out, or malloc link
> group when another link group just freed its buffer. This race window is
> too small to reach it in real world.

Okay I see we are in sync with that, and we should drop your kvzalloc() patch.
It generates noise and doesn't solve a real problem.

I appreciate your work on this topic, but when I see the numbers then the whole lgr 
WITH all links inside it would occupy less than one 4K page of memory (~3808 bytes).
The vast majority of memory in this struct is needed by the

struct smc_rtoken rtokens[255][3]; /*  3472 12240 */

array. This is where continuous space could be saved, but that needs some effort
to provide an equivalent fast way to store and lookup the RMBs.

Moving out the links from the lgr will not help here.

A link group holds up to 255 connections, so even with your 10000 connection test
we need no more than 40 instances of lgr...I am not sure if it is worth the time that
you need to spend for this particular change (lgr). The other topics you listed also
sound interesting!
