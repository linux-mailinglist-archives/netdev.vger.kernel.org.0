Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD8F9486273
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 10:54:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237608AbiAFJyI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 04:54:08 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:31618 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S237576AbiAFJyH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 04:54:07 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2067jilj025836;
        Thu, 6 Jan 2022 09:54:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=WcgnZrAAp82Km07atNhctup7prsckhZ3oaYDk8Jbx/w=;
 b=N6A3ghHz5IVv3jziGrVp9jCnWk3sN/QyzbRgc7tbfJ+w2MgiBzDEqgIfSMAV8nkdyUC3
 Jn8dRy7NTpb4aP+APmXqpweChySOCaC1GFJyHPRJadsV0PwVFGPWxAH9yIW02PS0TpQC
 vXTZeFjyrhYxUbKYEfuRKSiKK5GnS932XbXR7YnNBXauptffkEJtvx/asVXAK34Y6E/y
 mwDb7KMXR4FQfaZ0AcFoOoDHmrhwAC9CME/yOzb3r8FrMopsj30cKAyFZOYAWfNDYIjC
 UDJ9Acewk1QdLP4NMK4AZRncRzK/6HiPwIWx//wiKraJwFRsXGztebtq4Ve7G4bRlH75 BQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ddnsk8dnv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 06 Jan 2022 09:54:03 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 2069ae6k014448;
        Thu, 6 Jan 2022 09:54:03 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ddnsk8dnf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 06 Jan 2022 09:54:03 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2069qi6r020222;
        Thu, 6 Jan 2022 09:54:01 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma01fra.de.ibm.com with ESMTP id 3ddn5mufw0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 06 Jan 2022 09:54:01 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2069j9nN21627152
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 6 Jan 2022 09:45:09 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D598542049;
        Thu,  6 Jan 2022 09:53:58 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 71E264203F;
        Thu,  6 Jan 2022 09:53:58 +0000 (GMT)
Received: from [9.145.54.64] (unknown [9.145.54.64])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  6 Jan 2022 09:53:58 +0000 (GMT)
Message-ID: <ffe855d4-982b-25e6-a901-747095364bd0@linux.ibm.com>
Date:   Thu, 6 Jan 2022 10:54:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH net-next v2] net/smc: Reduce overflow of smc clcsock
 listen queue
Content-Language: en-US
To:     "D. Wythe" <alibuda@linux.alibaba.com>
Cc:     dust.li@linux.alibaba.com, kuba@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org
References: <1641301961-59331-1-git-send-email-alibuda@linux.alibaba.com>
 <8a60dabb-1799-316c-80b5-14c920fe98ab@linux.ibm.com>
 <20220105044049.GA107642@e02h04389.eu6sqa>
 <20220105085748.GD31579@linux.alibaba.com>
 <b98aefce-e425-9501-aacc-8e5a4a12953e@linux.ibm.com>
 <20220105150612.GA75522@e02h04389.eu6sqa>
 <cdbb6235-34dd-bc65-304d-0f09accad6a3@linux.alibaba.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <cdbb6235-34dd-bc65-304d-0f09accad6a3@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: DTqCa0fGGLUsKHguGxgVVXmXZ411SKxs
X-Proofpoint-ORIG-GUID: fEf-pwJ4NEYKLEH6ryf3K3JQb6ByuaCc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-06_03,2022-01-04_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 impostorscore=0 clxscore=1015 spamscore=0 bulkscore=0 lowpriorityscore=0
 priorityscore=1501 suspectscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2112160000 definitions=main-2201060067
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/01/2022 04:51, D. Wythe wrote:
> 
> One problem for the fallback scenario is that server must actively send decline message to client and wait for the clc proposal message that client may already sent, otherwise the message of SMC handshake may be read by user space application, which will also lead to OOM conditions caused by infinite amount of dangling sockets.
> 
> In that case, we have to make restrictions on 'SMC fallback ing', which makes things more complicated.

Thats a good point, I need to think about this ....
