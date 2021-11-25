Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB9E45D876
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 11:53:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354430AbhKYK5D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 05:57:03 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54880 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236759AbhKYKzC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 05:55:02 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AP8Gct7000595;
        Thu, 25 Nov 2021 10:51:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=jfummewWDX53IVD+qsueEb9phtn+g6FvhRUHzaey1W4=;
 b=dVWd/SD8LmTWFnxYK+dBdcLqRxbxQTqQJ1dGqmTKBRZbZqtrp8cTLo4caqCkx9YdONt9
 cmyj+0GAecByDE7zxj7utjZB43drpDnjNOlI8VpV/ec8UirNE8MRipuahpvfJNiFFsuM
 hJ+H2nsLi3WUQ2uU4tBij/AK5LHGF11fFXh9I6lSp03nYpY9kxV0jyZOE5eaMXK6sYtD
 U0Fqu8hLJrfxmTp2aiRNPb7ko40WyTq2QBIhVV2TSskmHkozsmunG9pvcDYGZ3ntAV6w
 XuAfcuFyuZ37RIn3WLIgvoI/YoJ3A+AbPWdioeCzNB77V6qHfg/8GgjTSdrGmjyi3D60 XA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cj6u8tuxa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Nov 2021 10:51:50 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1AP9fv3q014848;
        Thu, 25 Nov 2021 10:51:49 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cj6u8tuwu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Nov 2021 10:51:49 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1APAlQ1n011274;
        Thu, 25 Nov 2021 10:51:47 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3cer9ka436-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Nov 2021 10:51:47 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1APAiTAg59113902
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Nov 2021 10:44:29 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E1D124C040;
        Thu, 25 Nov 2021 10:51:44 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 92B564C05C;
        Thu, 25 Nov 2021 10:51:44 +0000 (GMT)
Received: from [9.145.172.86] (unknown [9.145.172.86])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 25 Nov 2021 10:51:44 +0000 (GMT)
Message-ID: <48002af6-63ca-edd3-dd71-b66032baeeb3@linux.ibm.com>
Date:   Thu, 25 Nov 2021 11:51:46 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH net 1/2] net/smc: Keep smc_close_final rc during active
 close
Content-Language: en-US
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org, Tony Lu <tonylu@linux.alibaba.com>
References: <20211125061932.74874-1-tonylu@linux.alibaba.com>
 <20211125061932.74874-2-tonylu@linux.alibaba.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20211125061932.74874-2-tonylu@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: tTNMQ5AkNCps9och1ZFtOkY1l7MBlgT-
X-Proofpoint-ORIG-GUID: kmOt4ams0sSxNN-HmbRo2Yy6xqqwId4i
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-25_04,2021-11-25_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=991
 impostorscore=0 mlxscore=0 adultscore=0 lowpriorityscore=0
 priorityscore=1501 spamscore=0 clxscore=1015 phishscore=0 malwarescore=0
 bulkscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111250055
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/11/2021 07:19, Tony Lu wrote:
> When smc_close_final() returns error, the return code overwrites by
> kernel_sock_shutdown() in smc_close_active(). The return code of
> smc_close_final() is more important than kernel_sock_shutdown(), and it
> will pass to userspace directly.
> 
> Fix it by keeping both return codes, if smc_close_final() raises an
> error, return it or kernel_sock_shutdown()'s.
> 
> Link: https://lore.kernel.org/linux-s390/1f67548e-cbf6-0dce-82b5-10288a4583bd@linux.ibm.com/
> Fixes: 606a63c9783a ("net/smc: Ensure the active closing peer first closes clcsock")
> Suggested-by: Karsten Graul <kgraul@linux.ibm.com>
> Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
> Reviewed-by: Wen Gu <guwen@linux.alibaba.com>
> ---

Acked-by: Karsten Graul <kgraul@linux.ibm.com>
