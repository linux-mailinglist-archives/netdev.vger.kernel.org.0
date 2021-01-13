Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C73C32F434D
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 05:44:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725901AbhAMEng (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 23:43:36 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:23614 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725781AbhAMEnf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 23:43:35 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10D4Vcnt158268;
        Tue, 12 Jan 2021 23:42:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=5gesdfeO3wGVRWVUEdNtDV4M8EMMBvu088Ojs4q6vKs=;
 b=I4DaOGu77bPjuroEQL5GtHe3Txvn0VBkEpqeGmdc5uZlvN2a1SHkLUfqeGc3d1mmpVrX
 +Dg8Ah8yaeG672+zgkOobjVqhRNojtisksYX4Xi2PEwQkPIMGFTSHOcGWzYDY6ZgcjvN
 +gdA5uXETmLj2pm6x+6Y9zPUiEgwq+oc7ubg7VwWIjuE7odUWKIQfYgL9qFgb+gQRM9P
 t9TH8nr/cvVcC/6vdFgLIwAMjtevbo1k1pvNQdAdabC9y1+8KWBwYCwJLuzJpSKUkifh
 5DkP9pdwdVw3Jmb2Tb9WgZR+PUOroS86X16KxKK3bIJYlW3VXlUgYYvFszAg78mZZzex Ew== 
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 361sw907gx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 23:42:53 -0500
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10D4bHbu010427;
        Wed, 13 Jan 2021 04:42:52 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma04wdc.us.ibm.com with ESMTP id 35y4493120-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 04:42:52 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10D4gpsW22937986
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 04:42:51 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8318378066;
        Wed, 13 Jan 2021 04:42:51 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 572D078060;
        Wed, 13 Jan 2021 04:42:51 +0000 (GMT)
Received: from suka-w540.localdomain (unknown [9.85.207.168])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 13 Jan 2021 04:42:51 +0000 (GMT)
Received: by suka-w540.localdomain (Postfix, from userid 1000)
        id 710342E2879; Tue, 12 Jan 2021 20:42:47 -0800 (PST)
Date:   Tue, 12 Jan 2021 20:42:47 -0800
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Dany Madden <drt@linux.ibm.com>,
        Lijun Pan <ljp@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>
Subject: Re: [PATCH net-next v2 0/7] ibmvnic: Use more consistent locking
Message-ID: <20210113044247.GA224486@us.ibm.com>
References: <20210112181441.206545-1-sukadev@linux.ibm.com>
 <20210112180054.28ebcd1a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210112180054.28ebcd1a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Operating-System: Linux 2.0.32 on an i486
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-13_02:2021-01-12,2021-01-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 malwarescore=0 clxscore=1015 bulkscore=0 suspectscore=0 mlxlogscore=782
 lowpriorityscore=0 adultscore=0 priorityscore=1501 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101130021
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski [kuba@kernel.org] wrote:
> On Tue, 12 Jan 2021 10:14:34 -0800 Sukadev Bhattiprolu wrote:
> > Use more consistent locking when reading/writing the adapter->state
> > field. This patch set fixes a race condition during ibmvnic_open()
> > where the adapter could be left in the PROBED state if a reset occurs
> > at the wrong time. This can cause networking to not come up during
> > boot and potentially require manual intervention in bringing up
> > applications that depend on the network.
> 
> Apologies for not having enough time to suggest details, but let me
> state this again - the patches which fix bugs need to go into net with
> Fixes tags, the refactoring needs to go to net-next without Fixes tags.
> If there are dependencies, patches go to net first, then within a week
> or so the reset can be posted for net-next, after net -> net-next merge.

Well, the patch set fixes a set of bugs - main one is a locking bug fixed
in patch 6. Other bugs are more minor or corner cases. Fixing the locking
bug requires some refactoring/simplifying/reordering checks so lock can be
properly acquired.

Because of the size/cleanup, should we treat it as "next" material? i.e
should I just drop the Fixes tag and resend to net-next?

Or can we ignore the size of patchset and treat it all as bug fixes?

Appreciate your input.

Thanks,

Sukadev
