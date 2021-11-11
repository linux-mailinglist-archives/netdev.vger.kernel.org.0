Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA9C744DCB6
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 21:51:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233975AbhKKUxr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 15:53:47 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:25070 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233760AbhKKUxp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 15:53:45 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1ABJCoE0030010;
        Thu, 11 Nov 2021 20:50:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=pp1; bh=KZbTfpuDSfBqbBmG9zuTADj8i2wtTcK7hKWWH9b+zbY=;
 b=I7WAcec0KyOoM09SRRXlQPAThwDHooI35yljKBY1AuQ49265CauKQ8R5a5PzXz+8MqCd
 yX8FuoaElFTf0FMDQIniq7GIKJ1ns1GS3JSvCnSOCNhLUPAG3Y+7R14a5i4sueEllMvP
 lDJW4tIUmUY6sitPBU8vy8asVN+xqC0I6TgbglvOczHvtfcKePHDLARZbZ0f6ZFiCIDG
 t9OSkJSd4VCFDLC1+X6dw8WLzApTI5OE33jBXF9IU7vd+bbINY1HdJPWtnY5eBDhy5Kv
 idEsZwZ/p2+Lae7KHRlHmMOO5x7xNnWgcvrLv2dWbbz+xC8RTtDUqCwnN8l9vNWCb+V7 fg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c994thpxb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Nov 2021 20:50:52 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1ABJDDTE031123;
        Thu, 11 Nov 2021 20:50:52 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c994thpx5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Nov 2021 20:50:52 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1ABKbKmS007987;
        Thu, 11 Nov 2021 20:50:51 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma02dal.us.ibm.com with ESMTP id 3c5hbdgp18-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Nov 2021 20:50:51 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1ABKooFR14745924
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Nov 2021 20:50:50 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3DA9278063;
        Thu, 11 Nov 2021 20:50:50 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 959DB78068;
        Thu, 11 Nov 2021 20:50:47 +0000 (GMT)
Received: from suka-w540.localdomain (unknown [9.160.78.229])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with SMTP;
        Thu, 11 Nov 2021 20:50:47 +0000 (GMT)
Received: by suka-w540.localdomain (Postfix, from userid 1000)
        id 345772E1E5C; Thu, 11 Nov 2021 12:50:44 -0800 (PST)
Date:   Thu, 11 Nov 2021 12:50:44 -0800
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@intel.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Antoine Tenart <atenart@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Wei Wang <weiwan@google.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net] net: fix premature exit from NAPI state polling
 in napi_disable()
Message-ID: <YY2CJL+dQ3fgK82Y@us.ibm.com>
References: <20211110195605.1304-1-alexandr.lobakin@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211110195605.1304-1-alexandr.lobakin@intel.com>
X-Operating-System: Linux 2.0.32 on an i486
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ABTT92JMZpj6q-USdF0kwCWgmJS-M3vh
X-Proofpoint-GUID: SPtuaT3vg1_2F167KnSBSfyZmFTYlbZ8
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-11_07,2021-11-11_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 mlxlogscore=703 bulkscore=0 malwarescore=0 mlxscore=0 priorityscore=1501
 adultscore=0 clxscore=1011 suspectscore=0 lowpriorityscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111110107
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexander Lobakin [alexandr.lobakin@intel.com] wrote:
> Commit 719c57197010 ("net: make napi_disable() symmetric with
> enable") accidentally introduced a bug sometimes leading to a kernel
> BUG when bringing an iface up/down under heavy traffic load.
> 
> Prior to this commit, napi_disable() was polling n->state until
> none of (NAPIF_STATE_SCHED | NAPIF_STATE_NPSVC) is set and then
> always flip them. Now there's a possibility to get away with the
> NAPIF_STATE_SCHE unset as 'continue' drops us to the cmpxchg()
> call with an unitialized variable, rather than straight to
> another round of the state check.

Thanks. Tested v1 and it fixes the problem discussed at:

https://lore.kernel.org/netdev/dc6902364a8f91c4292fe1c5e01b24be@imap.linux.ibm.com/

Sukadev
