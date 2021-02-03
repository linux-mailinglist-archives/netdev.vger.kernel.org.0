Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C12CC30E46E
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 21:57:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232704AbhBCU5l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 15:57:41 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:32608 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232348AbhBCU5k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 15:57:40 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 113KUBCD130539
        for <netdev@vger.kernel.org>; Wed, 3 Feb 2021 15:56:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=wwsrdoS3Y8nnogrh1GwvUeNzQ4ooLTaYaL3cVzcSgwU=;
 b=Kl2IPFLR5cj0nXdx5grajFV2EY2TJoodWe6jO5PMsMIIOH1H918wCsBmLf3tjMPsVIvi
 FoWF6eHRsCs7ZdGPmjIC+zOrfqEGWCScPKmsVeunSfSdqzsvmssZvVQihS+VSO6ouXWG
 FPJSELhenSj0zDbEHAwllyVa++r9fRMDIntIPHPd/2qD+UWdy4bEdfRrVRF2XTI4Lc6M
 etrobUd/C4HEbVLCkZ3csKiCWSueL54cO2y6zJ1blDdctG9jM2CnOcAE0mv7yMrS8UF2
 F+eYC8sgTqsQNce+TUa6x7itSkVb/XOeuxQlluDsaA6BFXnkSNTm93b2BvIJFpYONTQ+ 0A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36g2f21qy5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 03 Feb 2021 15:56:59 -0500
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 113K6ObG025831
        for <netdev@vger.kernel.org>; Wed, 3 Feb 2021 15:56:59 -0500
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36g2f21qxt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Feb 2021 15:56:59 -0500
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 113KkxTk006290;
        Wed, 3 Feb 2021 20:56:58 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma04wdc.us.ibm.com with ESMTP id 36f0yuw677-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Feb 2021 20:56:58 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 113KutjU22020498
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 3 Feb 2021 20:56:55 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CE9D7BE053;
        Wed,  3 Feb 2021 20:56:55 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A3076BE04F;
        Wed,  3 Feb 2021 20:56:55 +0000 (GMT)
Received: from suka-w540.localdomain (unknown [9.85.134.85])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed,  3 Feb 2021 20:56:55 +0000 (GMT)
Received: by suka-w540.localdomain (Postfix, from userid 1000)
        id AD05D2E1890; Wed,  3 Feb 2021 12:56:52 -0800 (PST)
Date:   Wed, 3 Feb 2021 12:56:52 -0800
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Dany Madden <drt@linux.ibm.com>, Lijun Pan <ljp@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>, abdhalee@in.ibm.com
Subject: Re: [PATCH v2 2/2] ibmvnic: fix race with multiple open/close
Message-ID: <20210203205652.GA700270@us.ibm.com>
References: <20210203050650.680656-1-sukadev@linux.ibm.com>
 <20210203050650.680656-2-sukadev@linux.ibm.com>
 <CA+FuTSdRci4=fAza+L_-kUf9VkZnfUhWZ49-XHY8DiRuroSv3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+FuTSdRci4=fAza+L_-kUf9VkZnfUhWZ49-XHY8DiRuroSv3Q@mail.gmail.com>
X-Operating-System: Linux 2.0.32 on an i486
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-03_08:2021-02-03,2021-02-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 clxscore=1015 mlxscore=0 suspectscore=0
 priorityscore=1501 phishscore=0 impostorscore=0 mlxlogscore=999
 spamscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102030118
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Willem de Bruijn [willemdebruijn.kernel@gmail.com] wrote:
> On Wed, Feb 3, 2021 at 12:10 AM Sukadev Bhattiprolu
> <sukadev@linux.ibm.com> wrote:
> >
> > If two or more instances of 'ip link set' commands race and first one
> > already brings the interface up (or down), the subsequent instances
> > can simply return without redoing the up/down operation.
> >
> > Fixes: ed651a10875f ("ibmvnic: Updated reset handling")
> > Reported-by: Abdul Haleem <abdhalee@in.ibm.com>
> > Tested-by: Abdul Haleem <abdhalee@in.ibm.com>
> > Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
> >
> > ---
> > Changelog[v2] For consistency with ibmvnic_open() use "goto out" and return
> >               from end of function.
> 
> Did you find the code path that triggers this?

Not yet. I need to find time on the system to repro/debug that
> 
> In v1 we discussed how the usual ip link path should not call the
> driver twice based on IFF_UP.

Yes, we can hold this patch for now if necessary. Hopefully Patch 1/2 is
ok.

Sukadev
