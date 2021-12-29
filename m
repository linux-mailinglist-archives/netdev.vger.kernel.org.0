Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B8F94812F4
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 13:56:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236603AbhL2M4v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 07:56:51 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:12640 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236046AbhL2M4u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 07:56:50 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BT9SviV022000;
        Wed, 29 Dec 2021 12:56:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=YVFKm15BQvdtZr8hDamtmtwX6AvBKFv4rDtcubPJ7Eo=;
 b=dGiIPSLg3nOs20YdViBdW/plhFxXIyCFJXOg1nL51mJMoOgZcJ9xF56rRyc6hbQGw4jK
 67C4IjlPjAYhCpXtUwysaG/2/5pNuo4biGiKoJjnqU+kn7kqha1mThLW23Vz0u4xII0y
 YOdizTlTMyz+Kx6Z/dMXeFIrJ22768hveR+cBawDKWuf/km8oRHwE5Ro8trVsXNFzjWV
 XNmxKj4RCFa3C+HUI3OmhIoSD/oraV20DAiOkZPPAaT8+wELD+BcWTWX2ZB4oP84jfwT
 Iz+E0WDtdFJl+s8y7ZwzNeD/K91sB77gggt4K4Q1Rf1DC7K1UnYgt/C7MeT51t5vV0kL +w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3d838gpnma-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Dec 2021 12:56:48 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BTCumUF026064;
        Wed, 29 Dec 2021 12:56:48 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3d838gpnkq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Dec 2021 12:56:48 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BTCqKTi018385;
        Wed, 29 Dec 2021 12:56:45 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3d5txaxkew-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Dec 2021 12:56:45 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BTCuhJk36897258
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Dec 2021 12:56:43 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 168064C04E;
        Wed, 29 Dec 2021 12:56:43 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A32724C046;
        Wed, 29 Dec 2021 12:56:42 +0000 (GMT)
Received: from [9.145.32.240] (unknown [9.145.32.240])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 29 Dec 2021 12:56:42 +0000 (GMT)
Message-ID: <4ec6e460-96d1-fedc-96ff-79a98fd38de8@linux.ibm.com>
Date:   Wed, 29 Dec 2021 13:56:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [RFC PATCH net v2 1/2] net/smc: Resolve the race between link
 group access and termination
Content-Language: en-US
To:     Wen Gu <guwen@linux.alibaba.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dust.li@linux.alibaba.com,
        tonylu@linux.alibaba.com
References: <1640704432-76825-1-git-send-email-guwen@linux.alibaba.com>
 <1640704432-76825-2-git-send-email-guwen@linux.alibaba.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <1640704432-76825-2-git-send-email-guwen@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ZCcrk0ilgLcIPPpw1Or4tnA7Rl5J3VEl
X-Proofpoint-ORIG-GUID: Ohcc_jjJJyu_qyPIPqYWPm3aMSSzwt4F
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-29_04,2021-12-29_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 suspectscore=0
 impostorscore=0 priorityscore=1501 malwarescore=0 spamscore=0 bulkscore=0
 adultscore=0 lowpriorityscore=0 mlxscore=0 mlxlogscore=999 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112290068
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/12/2021 16:13, Wen Gu wrote:
> We encountered some crashes caused by the race between the access
> and the termination of link groups.

While I agree with the problems you found I am not sure if the solution is the right one.
At the moment conn->lgr is checked all over the code as indication if a connection
still has a valid link group. When you change this semantic by leaving conn->lgr set
after the connection was unregistered from its link group then I expect various new problems
to happen.

For me the right solution would be to use correct locking  before conn->lgr is checked and used.

In smc_lgr_unregister_conn() the lgr->conns_lock is used when conn->lgr is unset (note that
it is better to have that "conn->lgr = NULL;" line INSIDE the lock in this function).

And on any places in the code where conn->lgr is used you get the read_lock while lgr is accessed.
This could solve the problem, using existing mechanisms, right? Opinions?
