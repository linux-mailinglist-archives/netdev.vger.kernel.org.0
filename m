Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 454292B8F1D
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 10:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726997AbgKSJhW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 04:37:22 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:41694 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726886AbgKSJhV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 04:37:21 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AJ9XUew162139;
        Thu, 19 Nov 2020 04:37:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=mime-version : date :
 from : to : cc : subject : in-reply-to : references : message-id :
 content-type : content-transfer-encoding; s=pp1;
 bh=Xwg4v0z7xNxL+jyX0r3s4tLEh5DDOEAxZ1p7aRMyze4=;
 b=hceZb5cRd2ami9JlkGu3B6Oo74o5czGnXQG9HftTKqXNmFMShC5MzFw678jaNVBmIDZ9
 8TquBqlLPNULbnq+ZdMsypsrBAZED07cuR9chxwHUIYwq+XR7a09MtyqzJ28f3HthX88
 rkk3EtdkVCMcoqsPJWlqeQIUCgUMKm1VRZvMIjbUuN4ifpLM0eH/P72yAES/ppPTjh0O
 mEijF7umQtLTm61rE6a6/s8l22cbRxx9WbhcJ9tOsxElI1XW72WpN2bJ49lPLVkMmdRu
 N2GYj2ZR+B+1NtXpE4T0tUv/PyH2222beTFJEZ4Rrw+wDvXw1Lx94IlPplRNneRuJdW8 4g== 
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34wg5xsjx3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Nov 2020 04:37:15 -0500
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AJ9MedX008747;
        Thu, 19 Nov 2020 09:37:15 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma04wdc.us.ibm.com with ESMTP id 34t6v9cxv5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Nov 2020 09:37:15 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AJ9bDP966126278
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Nov 2020 09:37:13 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 84FE67805C;
        Thu, 19 Nov 2020 09:37:13 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 26B4B7805E;
        Thu, 19 Nov 2020 09:37:13 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.16.170.189])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 19 Nov 2020 09:37:13 +0000 (GMT)
MIME-Version: 1.0
Date:   Thu, 19 Nov 2020 03:37:12 -0600
From:   ljp <ljp@linux.vnet.ibm.com>
To:     Thomas Falcon <tlfalcon@linux.ibm.com>
Cc:     kuba@kernel.org, cforno12@linux.ibm.com, netdev@vger.kernel.org,
        ricklind@linux.ibm.com, dnbanerg@us.ibm.com,
        drt@linux.vnet.ibm.com, brking@linux.vnet.ibm.com,
        sukadev@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org,
        Linuxppc-dev 
        <linuxppc-dev-bounces+ljp=linux.ibm.com@lists.ozlabs.org>
Subject: Re: [PATCH net-next v2 5/9] ibmvnic: Remove send_subcrq function
In-Reply-To: <1605748345-32062-6-git-send-email-tlfalcon@linux.ibm.com>
References: <1605748345-32062-1-git-send-email-tlfalcon@linux.ibm.com>
 <1605748345-32062-6-git-send-email-tlfalcon@linux.ibm.com>
Message-ID: <f68954913fd18fde01c2e8cf0743c59c@linux.vnet.ibm.com>
X-Sender: ljp@linux.vnet.ibm.com
User-Agent: Roundcube Webmail/1.0.1
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-19_05:2020-11-17,2020-11-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 mlxscore=0 adultscore=0 mlxlogscore=835 malwarescore=0 lowpriorityscore=0
 clxscore=1015 spamscore=0 priorityscore=1501 impostorscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011190067
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-11-18 19:12, Thomas Falcon wrote:
> It is not longer used, so remove it.
> 
> Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>

Acked-by: Lijun Pan <ljp@linux.ibm.com>
