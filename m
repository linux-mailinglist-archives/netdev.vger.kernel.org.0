Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FB96463B9A
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 17:20:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239039AbhK3QXu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 11:23:50 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:60628 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238935AbhK3QXu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 11:23:50 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AUGFmq8001133;
        Tue, 30 Nov 2021 16:20:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Qk42CDtrcUM2A4btLlkJr7y1lj6c4uq40SLP91nfLjw=;
 b=riwH4Id6CmYS5yS/CwxoIRPynYfseX1tB9necV2Cygjtd7Srn6LMeiIBAiKSbHEK02Zf
 dZpz7ym+Nm5421CBvd+kO6sAAGp1w/HVXBA8SnMrPXLGdfR5Pev3ubzl4vpLJF382/hG
 9y3i+UQ2Dex8usTru9BUs6auFAdx99/1AS/bFghSbQTCun9qtG1iDyjCP/UQ675/Na5A
 TMDcSOHS5JnDXCiAskcqlg7Tec0WxPHkx97jCgA3QZsqetnhDO19e3vqiwC1F1ttbsXp
 3oD5MpGjDWvEpTZx+wXavVFma4U5uqXEPi6t8sAGrMUwzjJM/x93k2M5dyqMZRg48d1h 4g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cnqavr3qs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Nov 2021 16:20:25 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1AUGG7o5001933;
        Tue, 30 Nov 2021 16:20:25 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cnqavr3pv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Nov 2021 16:20:25 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AUG4JJ7008329;
        Tue, 30 Nov 2021 16:20:23 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3ckbxk0v5j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Nov 2021 16:20:22 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AUGKKJV21037526
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Nov 2021 16:20:20 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7D0F411C058;
        Tue, 30 Nov 2021 16:20:20 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1ACDB11C04A;
        Tue, 30 Nov 2021 16:20:20 +0000 (GMT)
Received: from [9.145.172.190] (unknown [9.145.172.190])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 30 Nov 2021 16:20:20 +0000 (GMT)
Message-ID: <7d09ae3d-3715-ecf6-08d5-a9606bd4966d@linux.ibm.com>
Date:   Tue, 30 Nov 2021 17:20:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH net] net/smc: fix wrong list_del in smc_lgr_cleanup_early
Content-Language: en-US
To:     Dust Li <dust.li@linux.alibaba.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Tony Lu <tonylu@linux.alibaba.com>,
        Wen Gu <guwen@linux.alibaba.com>, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org
References: <20211130151731.55951-1-dust.li@linux.alibaba.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20211130151731.55951-1-dust.li@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: -sp9lLt4eF6VU9vlPdZd3sCiEDStMPNZ
X-Proofpoint-GUID: MIYfMH69gYkEeLUaCftV_9RETarbTNlL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-30_09,2021-11-28_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 mlxlogscore=971 bulkscore=0 lowpriorityscore=0 adultscore=0
 impostorscore=0 phishscore=0 priorityscore=1501 suspectscore=0
 malwarescore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111300084
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30/11/2021 16:17, Dust Li wrote:
> smc_lgr_cleanup_early() meant to deleted the link
> group from the link group list, but it deleted
> the list head by mistake.
> 
> This may cause memory corruption since we didn't
> remove the real link group from the list and later
> memseted the link group structure.

Great finding, thank you!

Acked-by: Karsten Graul <kgraul@linux.ibm.com>
