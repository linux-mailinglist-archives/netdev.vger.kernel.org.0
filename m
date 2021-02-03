Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CFD230D2C5
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 06:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbhBCFJr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 00:09:47 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:21992 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229540AbhBCFJn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 00:09:43 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11353B8o162466;
        Wed, 3 Feb 2021 00:09:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=kQBMknEa0llkKdR+YO/Yf4YSGpgHJ0QyOANCS5pH/FU=;
 b=l+V4qTqg85gnOwg2MztZUlu6pDpnrDxjLpwG6tw3vocEVKs4d8Pookqcl2Rap3yQ310P
 NfYcrSfm/3pbpHjmKmhmTpFh44/v5j+CHwP0IRFizwiIMNjsJsIpHy9PbVIHylnOjpzk
 sDedpLjZ/LZ1mh7u78IPKvdqvjf+X6Wsl8Vk5uzwrnbNwTO/rAhuUx8QbJBerP0NNmDn
 Zm+XdMTjCQXjOEUmiXAyRw4XLZeh+DXPEF33vYlgtJjLQTzs3OQPUGkEU6++JAEzWGQv
 gsNcdD9xgeIDWOLCBHMwJbaOoIq8KJX2Q11pdtQnT4tIgBEiexEKiPUC2NfbONJKc7FR xA== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36fm83hmwj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Feb 2021 00:09:02 -0500
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 113520H4012329;
        Wed, 3 Feb 2021 05:09:01 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma02dal.us.ibm.com with ESMTP id 36f5t4ye3y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Feb 2021 05:09:01 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11358xvB28311940
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 3 Feb 2021 05:08:59 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 951F2B2064;
        Wed,  3 Feb 2021 05:08:59 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 68839B205F;
        Wed,  3 Feb 2021 05:08:59 +0000 (GMT)
Received: from suka-w540.localdomain (unknown [9.85.202.29])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed,  3 Feb 2021 05:08:59 +0000 (GMT)
Received: by suka-w540.localdomain (Postfix, from userid 1000)
        id 33BAE2E188D; Tue,  2 Feb 2021 21:08:56 -0800 (PST)
Date:   Tue, 2 Feb 2021 21:08:56 -0800
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Dany Madden <drt@linux.ibm.com>,
        Lijun Pan <ljp@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>, abdhalee@in.ibm.com
Subject: Re: [PATCH net 1/2] ibmvnic: fix a race between open and reset
Message-ID: <20210203050856.GA680834@us.ibm.com>
References: <20210129034711.518250-1-sukadev@linux.ibm.com>
 <20210201183824.21fcb74b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210201183824.21fcb74b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Operating-System: Linux 2.0.32 on an i486
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-03_01:2021-02-02,2021-02-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 suspectscore=0 adultscore=0 bulkscore=0 priorityscore=1501
 phishscore=0 mlxlogscore=908 lowpriorityscore=0 spamscore=0 clxscore=1015
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102030028
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski [kuba@kernel.org] wrote:
> On Thu, 28 Jan 2021 19:47:10 -0800 Sukadev Bhattiprolu wrote:
> > +	WARN_ON_ONCE(!rtnl_is_locked());
> 
> ASSERT_RTNL() should do nicely here

Yes, Fixed in v2.

Thanks,

Sukadev
