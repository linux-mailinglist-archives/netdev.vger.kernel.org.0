Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61513286827
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 21:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728085AbgJGTSo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 15:18:44 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:59764 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728034AbgJGTSo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 15:18:44 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 097J1hHd019060;
        Wed, 7 Oct 2020 15:17:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=7P/5mBZR7aY3ru8bEZ9ozUoe6QXM0JhJIdOb1/L4mG4=;
 b=jxI8xyJckufceGD72CVj0p4ySi7dywye46ijahPEfTSa33SF1OGgLMHLQwBx1j5CQIE2
 GaMZwLKS7knNhI508NASWhMdx45ck29HIBVDAMDi40ZPSVQ1oRVfvMuEx/O13ImR3A6m
 kglVcaeoqIED+4wZvNCGQyAft997ttjWukEu2s4NBtH7dKEsP/jShIAaBTbN5OyHtSrO
 vlF9VtCYDRlhNepNYpsZu7TogYuwAvp+1Xia3KBz1bXNN/GpVEZ73RgqidLmwB94FTes
 v+/EC5GC086K5tkSoS1dEThcNFiNk0kdxhJ18DUKmt+fwAwTJYtuSfOhlSUo5segAkUG iA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 341k8u0qxh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Oct 2020 15:17:53 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 097J1lGn019614;
        Wed, 7 Oct 2020 15:17:52 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 341k8u0qwd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Oct 2020 15:17:52 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 097J9LxK019727;
        Wed, 7 Oct 2020 19:17:50 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03fra.de.ibm.com with ESMTP id 33xgx7tcky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Oct 2020 19:17:49 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 097JHlaJ19399126
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 7 Oct 2020 19:17:47 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6B60FA4053;
        Wed,  7 Oct 2020 19:17:47 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6FCB3A4040;
        Wed,  7 Oct 2020 19:17:46 +0000 (GMT)
Received: from LAPTOP-VCUDA2TK (unknown [9.145.39.190])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Wed,  7 Oct 2020 19:17:46 +0000 (GMT)
Date:   Wed, 7 Oct 2020 21:17:46 +0200
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     Allen Pais <allen.lkml@gmail.com>
Cc:     davem@davemloft.net, gerrit@erg.abdn.ac.uk, kuba@kernel.org,
        edumazet@google.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        johannes@sipsolutions.net, alex.aring@gmail.com,
        stefan@datenfreihafen.org, santosh.shilimkar@oracle.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org, Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: Re: [net-next v2 7/8] net: smc: convert tasklets to use new
 tasklet_setup() API
Message-Id: <20201007211746.721cfa50717c169a90386aa4@linux.ibm.com>
In-Reply-To: <20201007101219.356499-8-allen.lkml@gmail.com>
References: <20201007101219.356499-1-allen.lkml@gmail.com>
        <20201007101219.356499-8-allen.lkml@gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.30; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-07_10:2020-10-07,2020-10-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 priorityscore=1501 malwarescore=0 clxscore=1011 adultscore=0 bulkscore=0
 impostorscore=0 mlxlogscore=804 mlxscore=0 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010070118
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  7 Oct 2020 15:42:18 +0530
Allen Pais <allen.lkml@gmail.com> wrote:

> From: Allen Pais <apais@linux.microsoft.com>
> 
> In preparation for unconditionally passing the
> struct tasklet_struct pointer to all tasklet
> callbacks, switch to using the new tasklet_setup()
> and from_tasklet() to pass the tasklet pointer explicitly.
> 

Acked-by: Karsten Graul <kgraul@linux.ibm.com>

-- 
Karsten
