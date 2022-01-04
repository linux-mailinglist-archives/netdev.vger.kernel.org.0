Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6E2B483F85
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 10:58:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbiADJ6X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 04:58:23 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:37270 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230016AbiADJ6W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 04:58:22 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2048NVoV018413;
        Tue, 4 Jan 2022 09:58:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=7sG+RPwCTh9UvAPVRIW9jSqajYxBOn0s2GgJ4rhaPR8=;
 b=mGiNZh+x8EZrJbK+yNBrAHMjb+Mlircpj/kRbTHFrQtFhNJTdmJ8UltCL873OH7QnbLc
 vDZkCx30VMgxt93cWQkdVIu3dqDObua9eztbxYgjUscOFQzZ2pppi6l8rX1hSxCvk7pP
 sEEY8QRE4sMrjhK9JmON5mH7p+g3+sYpZR9Ave1nT5OvEfK+MF1XHW8haXpsHHHOgsXX
 nNLUywkP5o1WrMAY36TY9j0DBYWRkw+fMklXVBAmT8CSOeuPwGj58NnwLxw6a68CgmjH
 ZPcRTaiEP4EyKuMlji8cI2kXfmqRyyqwEVt0RTk4uSIwpE7NEV54pNim8fvIILGCxDRH Bw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dcen75etq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Jan 2022 09:58:18 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 2049qubS021345;
        Tue, 4 Jan 2022 09:58:17 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dcen75etg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Jan 2022 09:58:17 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2049w1Jt020624;
        Tue, 4 Jan 2022 09:58:15 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06fra.de.ibm.com with ESMTP id 3dae7jfftr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Jan 2022 09:58:15 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2049nS3d14877030
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 4 Jan 2022 09:49:28 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8CF2AAE059;
        Tue,  4 Jan 2022 09:58:12 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 177FBAE058;
        Tue,  4 Jan 2022 09:58:12 +0000 (GMT)
Received: from [9.145.168.225] (unknown [9.145.168.225])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  4 Jan 2022 09:58:11 +0000 (GMT)
Message-ID: <a4b54142-e324-8c08-738b-b89046ccc794@linux.ibm.com>
Date:   Tue, 4 Jan 2022 10:58:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH net v2] net/smc: Reset conn->lgr when link group
 registration fails
Content-Language: en-US
To:     Wen Gu <guwen@linux.alibaba.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dust.li@linux.alibaba.com,
        tonylu@linux.alibaba.com
References: <1641265187-108970-1-git-send-email-guwen@linux.alibaba.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <1641265187-108970-1-git-send-email-guwen@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: yxkiIPRJsYJ8M2t84Nt4rxjjb7jxe8uh
X-Proofpoint-GUID: NOM9vdStgt0VwW0gnU21-sduCvq34cqf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-04_04,2022-01-04_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 impostorscore=0 malwarescore=0 suspectscore=0
 phishscore=0 spamscore=0 mlxscore=0 priorityscore=1501 adultscore=0
 mlxlogscore=999 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2201040063
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/01/2022 03:59, Wen Gu wrote:
> SMC connections might fail to be registered to a link group due to
> things like unable to find a link to assign to in its creation. As
> a result, connection creation will return a failure and most
> resources related to the connection won't be applied or initialized,
> such as conn->abort_work or conn->lnk.

Patch looks good to me, but one more thing to think about:

Would it be better to invoke __smc_lgr_terminate() instead of smc_lgr_schedule_free_work()
when a link group was created but cannot be used now? This would immediately free up all
allocated resources for this unusable link group instead of starting the default 10-minute
timer until the link group is freed.
__smc_lgr_terminate() takes care of completely removing the link group in the context of
its caller. It is also used from within smc_lgr_cleanup_early() that is used when the very
first connection of a link group is aborted.
