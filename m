Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12F1B43C78F
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 12:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241386AbhJ0KXz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 06:23:55 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:5040 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241366AbhJ0KXy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 06:23:54 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19RAGk3G032761;
        Wed, 27 Oct 2021 10:21:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=NPGj6GeWeZEDYyBDovsLZJJVPd/jCUkU8Qu7KZeeTyc=;
 b=cJwJ75y0uV3viF2LpQhb0doIEyqqu2G2ACrse01/IZLZ5zrfVB2M4uOHq9dIQ4p1Em1K
 +Y6fhXaBVmG20JsLYTa4Aos3WpsK4Vc3vmVadOVZjmilPl7PimNwA1iOQGrvjeeFdOrM
 9kR7Ar6qayGo9MljNwJn59S3etrwNrC6OnrC1FllIK/rBSifC3zIJUCMxt/7quiNE3Jw
 WQXu0ss59MD35c9d8SZpBFkQ7e1fkiQAAHNcsiYOrbwIBCwFDSQQd129Zl65DdfCucwJ
 ik2bHN9nbDu/Kl/fuKIdSiXtywyRl+vYk+FcOvzvQUg1psqPCGaIAViDcCl9v8nq6ocE lQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3by4vk03k1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Oct 2021 10:21:26 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19RAIB5L008866;
        Wed, 27 Oct 2021 10:21:26 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3by4vk03j5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Oct 2021 10:21:25 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19RAD04P013529;
        Wed, 27 Oct 2021 10:21:24 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 3bx4f1dx6u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Oct 2021 10:21:24 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19RALLOm4522580
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Oct 2021 10:21:21 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B5B7852063;
        Wed, 27 Oct 2021 10:21:21 +0000 (GMT)
Received: from [9.145.41.29] (unknown [9.145.41.29])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 32B425204F;
        Wed, 27 Oct 2021 10:21:21 +0000 (GMT)
Message-ID: <9bbd05ac-5fa5-7d7a-fe69-e7e072ccd1ab@linux.ibm.com>
Date:   Wed, 27 Oct 2021 12:21:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH net 1/4] Revert "net/smc: don't wait for send buffer space
 when data was already sent"
Content-Language: en-US
To:     Tony Lu <tonylu@linux.alibaba.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org, jacob.qi@linux.alibaba.com,
        xuanzhuo@linux.alibaba.com, guwen@linux.alibaba.com,
        dust.li@linux.alibaba.com
References: <20211027085208.16048-1-tonylu@linux.alibaba.com>
 <20211027085208.16048-2-tonylu@linux.alibaba.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20211027085208.16048-2-tonylu@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Kcyctn3wA8Ob1waKbS0LKwy4cYZoWaiX
X-Proofpoint-ORIG-GUID: How5wNOuaxRx9plDTr7zIq0Q3NU9HMnI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-27_03,2021-10-26_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 priorityscore=1501 lowpriorityscore=0 impostorscore=0 mlxscore=0
 suspectscore=0 spamscore=0 malwarescore=0 adultscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2110270062
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/10/2021 10:52, Tony Lu wrote:
> From: Tony Lu <tony.ly@linux.alibaba.com>
> 
> This reverts commit 6889b36da78a21a312d8b462c1fa25a03c2ff192.
> 
> When using SMC to replace TCP, some userspace applications like netperf
> don't check the return code of send syscall correctly, which means how
> many bytes are sent. If rc of send() is smaller than expected, it should
> try to send again, instead of exit directly. It is difficult to change
> the uncorrect behaviors of userspace applications, so choose to revert it.

Your change would restore the old behavior to handle all sockets like they 
are blocking sockets, trying forever to send the provided data bytes.
This is not how it should work.

We encountered the same issue with netperf, but this is the only 'broken'
application that we know of so far which does not implement the socket API
correctly.
