Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 010702F53B6
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 20:56:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728792AbhAMTzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 14:55:50 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:53204 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726599AbhAMTzt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 14:55:49 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10DJYgdw162743;
        Wed, 13 Jan 2021 14:55:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=u4yqQOLfhMeSSLYiZMaRyx1VpaEwLgYlqJlbRgjjZZQ=;
 b=eotytf2b18zo0CfHOK5bnbgO/eTNEE7LOvq1S012pCe+/Uhpl0buIEEZA7hHI9ADS7j0
 HU811FlbNnQL44R6Ut3IQ20JWmBGYcZisgIcCt+FuQf2rHg28RaNAlEbxw9m2O2JsxiD
 hFEwPG8bLqqHouNeVhm0cBtqB3ixEon119wBKEW2YGrdhoMw27no3r8lL+zNC5fsjrl/
 q8fn0OeFs0XQW3Ysz0Kh+q7zrOTggrWJSoCGUi4nCI5qYw7oNf6PUoMSkXWglXwF46mG
 QiDS4vd4KEBB2KELPhqBbvSuN44+uxaqIqNFKt72Tf9ajWUN2eBrGSsysSmBI8NPxDLP dQ== 
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3625smb26a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 14:55:07 -0500
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10DJsatI022998;
        Wed, 13 Jan 2021 19:55:06 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma01wdc.us.ibm.com with ESMTP id 35y4497ytm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 19:55:06 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10DJt61930212566
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 19:55:06 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 28D8CB206E;
        Wed, 13 Jan 2021 19:55:06 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 062C6B2064;
        Wed, 13 Jan 2021 19:55:05 +0000 (GMT)
Received: from suka-w540.localdomain (unknown [9.85.167.168])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 13 Jan 2021 19:55:05 +0000 (GMT)
Received: by suka-w540.localdomain (Postfix, from userid 1000)
        id 579FE2E2856; Wed, 13 Jan 2021 11:55:03 -0800 (PST)
Date:   Wed, 13 Jan 2021 11:55:03 -0800
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Dany Madden <drt@linux.ibm.com>,
        Lijun Pan <ljp@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>
Subject: Re: [PATCH net-next v2 0/7] ibmvnic: Use more consistent locking
Message-ID: <20210113195503.GA236972@us.ibm.com>
References: <20210112181441.206545-1-sukadev@linux.ibm.com>
 <20210112180054.28ebcd1a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210113044247.GA224486@us.ibm.com>
 <20210113105735.20853d1f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210113105735.20853d1f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Operating-System: Linux 2.0.32 on an i486
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-13_11:2021-01-13,2021-01-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 impostorscore=0 mlxscore=0 phishscore=0 bulkscore=0
 adultscore=0 priorityscore=1501 mlxlogscore=999 clxscore=1015 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101130117
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski [kuba@kernel.org] wrote:
> On Tue, 12 Jan 2021 20:42:47 -0800 Sukadev Bhattiprolu wrote:
> > Jakub Kicinski [kuba@kernel.org] wrote:
> > > On Tue, 12 Jan 2021 10:14:34 -0800 Sukadev Bhattiprolu wrote:  
> > > > Use more consistent locking when reading/writing the adapter->state
> > > > field. This patch set fixes a race condition during ibmvnic_open()
> > > > where the adapter could be left in the PROBED state if a reset occurs
> > > > at the wrong time. This can cause networking to not come up during
> > > > boot and potentially require manual intervention in bringing up
> > > > applications that depend on the network.  
> > > 
> > > Apologies for not having enough time to suggest details, but let me
> > > state this again - the patches which fix bugs need to go into net with
> > > Fixes tags, the refactoring needs to go to net-next without Fixes tags.
> > > If there are dependencies, patches go to net first, then within a week
> > > or so the reset can be posted for net-next, after net -> net-next merge.  
> > 
> > Well, the patch set fixes a set of bugs - main one is a locking bug fixed
> > in patch 6. Other bugs are more minor or corner cases. Fixing the locking
> > bug requires some refactoring/simplifying/reordering checks so lock can be
> > properly acquired.
> > 
> > Because of the size/cleanup, should we treat it as "next" material? i.e
> > should I just drop the Fixes tag and resend to net-next?
> > 
> > Or can we ignore the size of patchset and treat it all as bug fixes?
> 
> No, focus on doing this right rather than trying to justify why your
> patches deserve special treatment.

I am not asking for special treatment. I just don't get the rationale
for saying that a bug fix cannot have some amount of refactoring.
Specially a bug fix like this locking one which clearly touches various
parts of the code. To take the lock properly we do have to move code
around.
> 
> Throw this entire series out and start over with the goal of fixing 
> the bugs with minimal patches.

Fixing corner case bugs that have been around for a while in code that
we are going to throw away feels like spinning wheels just to comply
with the "process".

Other than the optimization for the spin lock, there have been no
reported technical issues with the patch set. Throwing away the
patch set and starting over - I would be focusing not on the bugs
or making the driver better but somehow complying with the process.

The tiny memory leak issues I mention for completeness are just rare
corner cases and a distraction. The main issue that people actually
hit is the locking one. Fixing the locking issue touches lot of code.

I to throw away the list implementation and add a couple of simple
interfaces because if the allocation fails we call ibmvnic_close() -
that messes with the locking I am trying to fix.

Sukadev
