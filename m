Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 331DF4812E9
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 13:51:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236537AbhL2Mvh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 07:51:37 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:64176 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235818AbhL2Mvg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 07:51:36 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BT9kpZ3024781;
        Wed, 29 Dec 2021 12:51:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=k4acnYW0kzvsH6Vykx+B0VQ8WV8s43pMEfA4cg+beg0=;
 b=XWvblNaEcnUbbYabYcAbt3yO/pnBJNCd4rJ5VI9AMeDtisT59h8b4Hn+fbX9YO8JGsgp
 9X+JMHZhanbN0FFkjTRgB5P2em7pNOPFIaPEHFX2i1vZwSuRcqyBkzbOK0CB6ePN2fRp
 vZUG0IU9xGyItc1V5uqz3CJAvABo5UuEHT63EuRCZilqwcGhk2erDnwXrTBj3FheDV+W
 pxleUQ6grMokHxukVlDTvGmqnlnIBOiBMoaqCctkMFRAphB9ksscFFlGkXDq4xNFAOdy
 X1Z3UZKJ1dTFn6uJO6oPOtukHtBjaaeyB0jwUal5tVkAziQKbcd0npfbgNrZ30hTCm3V Tw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3d7sk32b66-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Dec 2021 12:51:33 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BTCohBV032760;
        Wed, 29 Dec 2021 12:51:33 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3d7sk32b5n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Dec 2021 12:51:32 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BTCgR7w009690;
        Wed, 29 Dec 2021 12:51:30 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma01fra.de.ibm.com with ESMTP id 3d5tx9dafs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Dec 2021 12:51:30 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BTCpSdb46793170
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Dec 2021 12:51:28 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 101924C04A;
        Wed, 29 Dec 2021 12:51:28 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9D8B54C059;
        Wed, 29 Dec 2021 12:51:27 +0000 (GMT)
Received: from [9.145.32.240] (unknown [9.145.32.240])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 29 Dec 2021 12:51:27 +0000 (GMT)
Message-ID: <7311029c-2c56-d9c7-9ed5-87bc6a36511f@linux.ibm.com>
Date:   Wed, 29 Dec 2021 13:51:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [RFC PATCH net v2 2/2] net/smc: Resolve the race between SMC-R
 link access and clear
Content-Language: en-US
To:     Wen Gu <guwen@linux.alibaba.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dust.li@linux.alibaba.com,
        tonylu@linux.alibaba.com
References: <1640704432-76825-1-git-send-email-guwen@linux.alibaba.com>
 <1640704432-76825-3-git-send-email-guwen@linux.alibaba.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <1640704432-76825-3-git-send-email-guwen@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: YnCRxXAKB-KaSbAtLKdIQ83wXB0p5w9P
X-Proofpoint-GUID: qhh3wZIVb0qj0w_PNGfSEcRoYT85Ulun
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-29_04,2021-12-29_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=999 spamscore=0 lowpriorityscore=0 suspectscore=0 phishscore=0
 priorityscore=1501 mlxscore=0 malwarescore=0 clxscore=1011 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112290068
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/12/2021 16:13, Wen Gu wrote:
> We encountered some crashes caused by the race between SMC-R
> link access and link clear triggered by link group termination
> in abnormal case, like port error.

Without to dig deeper into this, there is already a refcount for links, see smc_wr_tx_link_hold().
In smc_wr_free_link() there are waits for the refcounts to become zero.

Why do you need to introduce another refcounting instead of using the existing?
And if you have a good reason, do we still need the existing refcounting with your new
implementation?

Maybe its enough to use the existing refcounting in the other functions like smc_llc_flow_initiate()?

Btw: it is interesting what kind of crashes you see, we never met them in our setup.
Its great to see you evaluating SMC in a cloud environment!

