Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FCE0485355
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 14:17:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237050AbiAENRv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 08:17:51 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:61778 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236649AbiAENRs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 08:17:48 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 205D11pW019768;
        Wed, 5 Jan 2022 13:17:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=u7glOY0ToYHSLYnAbKYG9m4dFze5avT9cZpp+RSe43A=;
 b=euWVFDQ9bYWjdczY286fYV1fEw+vlhxFNmSv42ivGA/y0c6dSBbL1NVwVuxtjyz0l6R8
 jqstN8Zu9rGBhB8xzgWmJVprvlqtFq7PPRP9dU7yzaW1Lg3IW7JzB7dN16DoluFZT62z
 Ccob1omO5Ik2v/xuSgeK6Xr1SK4nJD7GMbebdWL4qn9RQcVCxWCYGd/cV5DXS2rDjXeD
 8BV3fTi7ueosgAD6ED04CU0gpWsbrI1oIh+fMB1z1y+RctbyvZS8BSubG4jkVZ9zws2v
 YcQHiXf/PREZv7dcHD2RWG7DWYa1BqCQJ0Wf176HQ5WdWzKgZW2HOpbhyc18O6p+Ev47 uA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dck05juvg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Jan 2022 13:17:45 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 205CmDlb008855;
        Wed, 5 Jan 2022 13:17:45 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dck05juum-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Jan 2022 13:17:45 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 205DEmEr009319;
        Wed, 5 Jan 2022 13:17:43 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma02fra.de.ibm.com with ESMTP id 3daek9gg3x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Jan 2022 13:17:43 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 205DHeQ229950426
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 5 Jan 2022 13:17:40 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3D7C442045;
        Wed,  5 Jan 2022 13:17:40 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D0C4142041;
        Wed,  5 Jan 2022 13:17:39 +0000 (GMT)
Received: from [9.145.181.244] (unknown [9.145.181.244])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  5 Jan 2022 13:17:39 +0000 (GMT)
Message-ID: <b98aefce-e425-9501-aacc-8e5a4a12953e@linux.ibm.com>
Date:   Wed, 5 Jan 2022 14:17:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH net-next v2] net/smc: Reduce overflow of smc clcsock
 listen queue
Content-Language: en-US
To:     dust.li@linux.alibaba.com, "D. Wythe" <alibuda@linux.alibaba.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <1641301961-59331-1-git-send-email-alibuda@linux.alibaba.com>
 <8a60dabb-1799-316c-80b5-14c920fe98ab@linux.ibm.com>
 <20220105044049.GA107642@e02h04389.eu6sqa>
 <20220105085748.GD31579@linux.alibaba.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20220105085748.GD31579@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: FLQB7EdiG4mYcuDQxIaeDWeypL36VmXQ
X-Proofpoint-GUID: Qo6dK0PV52P9q8oAXfnKrm03Nj9L3UzX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-05_03,2022-01-04_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 mlxscore=0 phishscore=0 adultscore=0 clxscore=1015
 malwarescore=0 bulkscore=0 mlxlogscore=999 impostorscore=0 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201050088
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/01/2022 09:57, dust.li wrote:
> On Wed, Jan 05, 2022 at 12:40:49PM +0800, D. Wythe wrote:
> I'm thinking maybe we can actively fall back to TCP in this case ? Not
> sure if this is a good idea.

I think its a good decision to switch new connections to use the TCP fallback when the
current queue of connections waiting for a SMC handshake is too large.
With this the application is able to accept all incoming connections and they are not
dropped. The only thing that is be different compared to TCP is that the order of the
accepted connections is changed, connections that came in later might reach the user space 
application earlier than connections that still run the SMC hand shake processing. 
But I think that is semantically okay.
