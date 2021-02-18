Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C863131EF89
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 20:20:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234143AbhBRTRC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 14:17:02 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:26566 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230119AbhBRSlm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Feb 2021 13:41:42 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11IIXSQV179304;
        Thu, 18 Feb 2021 13:40:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=26iu0Ri9szM48Q0na4vGUFYyvrkaYkvyhlIX68WERkQ=;
 b=lRNicBhGuReJOTx92PTGnoHbDAoXkGhkv+aXYpT18u7LnMHPEHhNrUEP3EGL9dTiPbIl
 LK2Eoq7NTyRqoDPIXAvI66cp/Fxb2wZ02DsUTGmroFKG7CC3yZB4aYNddrg88iZLzck9
 h6PqGup2ka44iqvNALNfmIC8eVrDD1heolDZI1f+VsBj9dxK75j1aj2a5O3mqh/8sJIh
 YFEBBLQa1h0iURbnkT5X1w6cU8uFT/nyVWa9Zf3n0IIysvpJJ2khK7nHorGGXy5y1Fmk
 TyRRP9tRpYDqkU0D/Y1J8E73u23PmES7lsctPkjvobXTSMfHXvKH3pFgzURdv5zFuZRh EA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36sv2kk7ak-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Feb 2021 13:40:54 -0500
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 11IIXihA180049;
        Thu, 18 Feb 2021 13:40:53 -0500
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36sv2kk7a1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Feb 2021 13:40:53 -0500
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11IIRqoA007599;
        Thu, 18 Feb 2021 18:40:52 GMT
Received: from b03cxnp07027.gho.boulder.ibm.com (b03cxnp07027.gho.boulder.ibm.com [9.17.130.14])
        by ppma04wdc.us.ibm.com with ESMTP id 36p6d9g3uw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Feb 2021 18:40:52 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp07027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11IIepO122610334
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Feb 2021 18:40:51 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 83EB1136055;
        Thu, 18 Feb 2021 18:40:51 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5182E136051;
        Thu, 18 Feb 2021 18:40:51 +0000 (GMT)
Received: from suka-w540.localdomain (unknown [9.85.163.18])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 18 Feb 2021 18:40:51 +0000 (GMT)
Received: by suka-w540.localdomain (Postfix, from userid 1000)
        id 52FDA2E1880; Thu, 18 Feb 2021 10:40:48 -0800 (PST)
Date:   Thu, 18 Feb 2021 10:40:48 -0800
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Lijun Pan <lijunp213@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20210218184048.GA1017500@us.ibm.com>
References: <20210217124337.47db7c69@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210217124337.47db7c69@canb.auug.org.au>
X-Operating-System: Linux 2.0.32 on an i486
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-18_09:2021-02-18,2021-02-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 impostorscore=0 clxscore=1011 suspectscore=0 mlxlogscore=999 bulkscore=0
 priorityscore=1501 phishscore=0 mlxscore=0 adultscore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180153
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stephen Rothwell [sfr@canb.auug.org.au] wrote:
> Hi all,
> 
> Today's linux-next merge of the net-next tree got conflicts in:
> 
>   drivers/net/ethernet/ibm/ibmvnic.c
>   drivers/net/ethernet/ibm/ibmvnic.h
> 
> between commit:
> 
>   4a41c421f367 ("ibmvnic: serialize access to work queue on remove")
> 
> from the net tree and commits:
> 
>   bab08bedcdc3 ("ibmvnic: fix block comments")
>   a369d96ca554 ("ibmvnic: add comments for spinlock_t definitions")
> 
> from the net-next tree.
> 
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.

The changes look good to me. Thanks.

Sukadev
