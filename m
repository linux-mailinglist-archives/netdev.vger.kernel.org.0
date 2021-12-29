Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A637F481306
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 14:07:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239103AbhL2NHV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 08:07:21 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:54970 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238590AbhL2NHV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 08:07:21 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BT8iv6w023028;
        Wed, 29 Dec 2021 13:07:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=cR5jg6gyUrCOgfSj1QR1VXXuy/jfo6NlT02kdC0wAW4=;
 b=bUTx2Hqv0h2lPwCo046c7NTr7R201IwLiZy8ZIsS6DMikdN3szLYloaGXQ23YKvN4mBn
 BgaHQMLaZ4uYorgmAiPERH7kwlkBFhmGXUmvzovpsIS0PxsslbhrbCPkF4BaITDN/Rni
 Y4dr9FWfmpEphv0Nla7s+E3kGxz72Ojat/gi59p/LKt0VRr/FO09GcHE7CRLhZ2x+ZNp
 PU/yeyqx0zPzQZW0+KCDdfy1i30W/H+5QV4+G+CHinLeWeG2TlhQ+XJSGS84mHIaLtpa
 jGg7oO0fCW4a2Xopo7SSyqCSEGpGLdCrbvei/GS4wo4bstbWhmVmEaNZ4f7Y1umbm/RE rA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3d83pe6dak-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Dec 2021 13:07:17 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BTD7GW4013167;
        Wed, 29 Dec 2021 13:07:16 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3d83pe6da4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Dec 2021 13:07:16 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BTD3YTQ002282;
        Wed, 29 Dec 2021 13:07:15 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma05fra.de.ibm.com with ESMTP id 3d5tx9c3gk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Dec 2021 13:07:14 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BTD7C8g33620270
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Dec 2021 13:07:12 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 639194C046;
        Wed, 29 Dec 2021 13:07:12 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0FB574C052;
        Wed, 29 Dec 2021 13:07:12 +0000 (GMT)
Received: from [9.145.32.240] (unknown [9.145.32.240])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 29 Dec 2021 13:07:11 +0000 (GMT)
Message-ID: <07930fec-4109-0dfd-7df4-286cb56ec75b@linux.ibm.com>
Date:   Wed, 29 Dec 2021 14:07:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [RFC PATCH net] net/smc: Reset conn->lgr when link group
 registration fails
Content-Language: en-US
To:     Wen Gu <guwen@linux.alibaba.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1640677770-112053-1-git-send-email-guwen@linux.alibaba.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <1640677770-112053-1-git-send-email-guwen@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: -FInu5gqCYLkw_DG8bF5wp3X9ReHs0Iq
X-Proofpoint-GUID: Zw8V3W5fPc9vQMgGTe_W513h_eG4sBgy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-29_05,2021-12-29_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 phishscore=0 adultscore=0 malwarescore=0
 mlxlogscore=999 clxscore=1015 mlxscore=0 impostorscore=0
 priorityscore=1501 spamscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112290071
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/12/2021 08:49, Wen Gu wrote:
> SMC connections might fail to be registered to a link group due to
> things like unable to find a link to assign to in its creation. As
> a result, connection creation will return a failure and most
> resources related to the connection won't be applied or initialized,
> such as conn->abort_work or conn->lnk.

I agree with your fix to set conn->lgr to NULL when smc_lgr_register_conn() fails.

It would probably be better to have smc_lgr_register_conn() set conn->lgr instead to set
it before in smc_conn_create(). So it would not be set at all then the registration failes.


What I do not understand is the extra step after the new label out_unreg: that 
may invoke smc_lgr_schedule_free_work(). You did not talk about that one.
Is the idea to have a new link group get freed() when a connection could not
be registered on it? In that case I would expect this code after label create:
in smc_lgr_create(), when the rc from smc_lgr_register_conn() is not zero.
Thoughts?
