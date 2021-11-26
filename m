Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A732545E9FB
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 10:09:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376352AbhKZJKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 04:10:00 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:21642 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344599AbhKZJH4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 04:07:56 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AQ8HTxQ000396;
        Fri, 26 Nov 2021 09:04:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=AX0C+x7PwVAwYbxHAvK8V58sjnhTyprE0A6wcxEmQNk=;
 b=A3WeJ8+tx5d0SxqGaXsnOcjXS1gsu4Kg0YzsRGuZIiagVSqcwDQALss/i38S1nVH7deM
 vul54h+ahjIQjhZLdaNB7Ay3FgNBvGaRi0d80cOIATVy6OT8ambxzbir5VStWjXhR2TA
 vx6uGgi2btXg+MV6IXtCDNlsvFluasoB7kIAHNhlumJsNuWh86rkydAMr5vx6w+2Jg9u
 kBGzAz15qAUPtz6Z0uLF+q6OdFN+9FkOrauVhRlmO/MgZxqFvjertofGBFt1+8sKGY9y
 9FLLl02MAXDOxf36s0goZwAfLw5cjYee5nFX2G0rmoDKgAXuIjgc8C2+rzvXmfKA6+PV Uw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cjuxm8whp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Nov 2021 09:04:34 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1AQ8WNEM019446;
        Fri, 26 Nov 2021 09:04:34 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cjuxm8wh7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Nov 2021 09:04:34 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AQ92lJT024959;
        Fri, 26 Nov 2021 09:04:31 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 3cernaf4m6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Nov 2021 09:04:31 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AQ8vDIZ61735236
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Nov 2021 08:57:13 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 046144C04A;
        Fri, 26 Nov 2021 09:04:29 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AA2024C046;
        Fri, 26 Nov 2021 09:04:28 +0000 (GMT)
Received: from [9.145.82.147] (unknown [9.145.82.147])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 26 Nov 2021 09:04:28 +0000 (GMT)
Message-ID: <3c6804b0-7f3a-0572-42f5-c72ca5dcdc46@linux.ibm.com>
Date:   Fri, 26 Nov 2021 10:04:29 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH net v3] net/smc: Don't call clcsock shutdown twice when
 smc shutdown
Content-Language: en-US
To:     Tony Lu <tonylu@linux.alibaba.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <20211126024134.45693-1-tonylu@linux.alibaba.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20211126024134.45693-1-tonylu@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 5Nz0ltNh5yO5hEkUSTWDE3wWuoe_3sw3
X-Proofpoint-ORIG-GUID: 2mmu5UOZ9Qn2MJxOFAmgaq9nAhzyIai5
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-26_02,2021-11-25_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 mlxscore=0
 bulkscore=0 phishscore=0 impostorscore=0 clxscore=1015 lowpriorityscore=0
 malwarescore=0 mlxlogscore=900 priorityscore=1501 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111260053
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/11/2021 03:41, Tony Lu wrote:
> When applications call shutdown() with SHUT_RDWR in userspace,
> smc_close_active() calls kernel_sock_shutdown(), and it is called
> twice in smc_shutdown().
> 
> This fixes this by checking sk_state before do clcsock shutdown, and
> avoids missing the application's call of smc_shutdown().
> 
> Link: https://lore.kernel.org/linux-s390/1f67548e-cbf6-0dce-82b5-10288a4583bd@linux.ibm.com/
> Fixes: 606a63c9783a ("net/smc: Ensure the active closing peer first closes clcsock")
> Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
> Reviewed-by: Wen Gu <guwen@linux.alibaba.com>
> ---

Acked-by: Karsten Graul <kgraul@linux.ibm.com>

