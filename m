Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 128F032F2FB
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 19:42:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbhCESm1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 13:42:27 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:51216 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230148AbhCESmE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 13:42:04 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 125IXDDe081720;
        Fri, 5 Mar 2021 13:42:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=RDR7SdN+nkzOKyC4zcNAY2PUho1ERz4wPH2sn6x5sLs=;
 b=pAJMd4rSgCNSZnQkkLgFEZbXrJyvegnyqKWJFjNiC941iB/pjoSB9qIbj2aH89sRVlwS
 JUBm5zJs4uizVDJ6Kil7B8OC8uFsly72h5SE76VK9bmjgKanz2fCU7wS5R/vpoMQvxi2
 vUdiuQBsrocEh3F2u/4ntDGVKjhPw6fGm4528vJu91DOSHEbVXZ94Ac/lnvku09Ilhfk
 kEncoUEoA+UFPKEczA3PEFIMS1yS0wXqran6jbYp++34WlbX2FC40dxFAxZaA/OAr4JE
 uNDwpbA6ByKryDkrff8KQ5hgR6I4bO0Q3/omGpafJuTaOurYYPFwNhA87mGJ2fHXDEtU Fg== 
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 373t14r6vk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Mar 2021 13:42:02 -0500
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 125IfACo023849;
        Fri, 5 Mar 2021 18:42:01 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma01wdc.us.ibm.com with ESMTP id 36ydq9sbuj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Mar 2021 18:42:01 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 125Ig0Ui20906250
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 5 Mar 2021 18:42:00 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BF2D7AE062;
        Fri,  5 Mar 2021 18:42:00 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9E3DAAE064;
        Fri,  5 Mar 2021 18:42:00 +0000 (GMT)
Received: from suka-w540.localdomain (unknown [9.85.156.62])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri,  5 Mar 2021 18:42:00 +0000 (GMT)
Received: by suka-w540.localdomain (Postfix, from userid 1000)
        id 1A9762E284E; Fri,  5 Mar 2021 10:41:57 -0800 (PST)
Date:   Fri, 5 Mar 2021 10:41:57 -0800
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     Lijun Pan <ljp@linux.ibm.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        drt@linux.ibm.com, tlfalcon@linux.ibm.com
Subject: Re: [RFC PATCH net] ibmvnic: complete dev->poll nicely during
 adapter reset
Message-ID: <20210305184157.GA1411314@us.ibm.com>
References: <20210305074456.88015-1-ljp@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305074456.88015-1-ljp@linux.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-05_13:2021-03-03,2021-03-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 mlxlogscore=970 spamscore=0 mlxscore=0 phishscore=0 bulkscore=0
 malwarescore=0 adultscore=0 lowpriorityscore=0 priorityscore=1501
 clxscore=1015 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2103050095
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lijun Pan [ljp@linux.ibm.com] wrote:
> The reset path will call ibmvnic_cleanup->ibmvnic_napi_disable
> ->napi_disable(). This is supposed to stop the polling.
> Commit 21ecba6c48f9 ("ibmvnic: Exit polling routine correctly
> during adapter reset") reported that the during device reset,
> polling routine never completed and napi_disable slept indefinitely.
> In order to solve that problem, resetting bit was checked and
> napi_complete_done was called before dev->poll::ibmvnic_poll exited.
> 
> Checking for resetting bit in dev->poll is racy because resetting
> bit may be false while being checked, but turns true immediately
> afterwards.

Yes, have been testing a fix for that.
> 
> Hence we call napi_complete in ibmvnic_napi_disable, which avoids
> the racing with resetting, and makes sure dev->poll and napi_disalbe

napi_complete() will prevent a new call to ibmvnic_poll() but what if
ibmvnic_poll() is already executing and attempting to access the scrqs
while the reset path is freeing them?

Sukadev
