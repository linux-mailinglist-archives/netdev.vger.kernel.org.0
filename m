Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6527C3B3394
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 18:07:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbhFXQJw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 12:09:52 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:57186 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229525AbhFXQJt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 12:09:49 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15OG3bF2175211
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 12:07:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=9E/M3r/2lKZl4MyAjdN7aIaYxxMqw8zJ+pMWTlkMib8=;
 b=UCNIo3D/w/iNjb5tBs32uA1XUPzkfwd/F2lC82fOudHdmajumE2whCBqfvfMNqDHrwE6
 hgfcmCmyNVFVnG6tSFXwigAM8rAaTJKu+vxgKweNqgJrh3ji/fO7LnaVJWOk2ucUbBQY
 7VBK9Fbt9MZ9/pN+1CnOnQ9kxXBu1P0m7GSyd/Acx/DUeCXdGlvCsu2EZ9Gv7vBQWHer
 mKjUDqu6bhCXQQISKLwIDZdKVV7afkW1xTFjxoXGEv007gmar0wsFgGAzBU1gX8iOn/g
 RqhZvPbMYSFO03XZY2E0nx0Bb3RvPtGSFLllzSkkgkMMapAxnfpDo3N7ffVC0uD4S0As pw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39cueqmvp9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 12:07:30 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15OG4okI179102
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 12:07:30 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39cueqmvnr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Jun 2021 12:07:30 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15OG4ZVv003473;
        Thu, 24 Jun 2021 16:07:29 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma02dal.us.ibm.com with ESMTP id 39987acfre-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Jun 2021 16:07:29 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15OG7S0q24445378
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Jun 2021 16:07:28 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ECC9C136055;
        Thu, 24 Jun 2021 16:07:27 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C1FA913604F;
        Thu, 24 Jun 2021 16:07:27 +0000 (GMT)
Received: from suka-w540.localdomain (unknown [9.85.182.79])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 24 Jun 2021 16:07:27 +0000 (GMT)
Received: by suka-w540.localdomain (Postfix, from userid 1000)
        id 232452E188A; Thu, 24 Jun 2021 09:07:25 -0700 (PDT)
Date:   Thu, 24 Jun 2021 09:07:25 -0700
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     Lijun Pan <lijunp213@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>,
        Dany Madden <drt@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>,
        Brian King <brking@linux.ibm.com>,
        Cristobal Forno <cforno12@linux.ibm.com>
Subject: Re: [PATCH net 1/7] Revert "ibmvnic: simplify reset_long_term_buff
 function"
Message-ID: <YNStvWD3gd3E5fgv@us.ibm.com>
References: <20210624041316.567622-1-sukadev@linux.ibm.com>
 <20210624041316.567622-2-sukadev@linux.ibm.com>
 <CAOhMmr7RbBNF8BbRbf3hEdD0cj9OjihuuKmXJogSz=8ewtGWog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOhMmr7RbBNF8BbRbf3hEdD0cj9OjihuuKmXJogSz=8ewtGWog@mail.gmail.com>
X-Operating-System: Linux 2.0.32 on an i486
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: UWGlG_wa1ghrdkaaYeLuMA6KBqkUCGFi
X-Proofpoint-ORIG-GUID: t5mUfbB7_K94QeWERBCznMLqOjXhMWnV
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-24_12:2021-06-24,2021-06-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 phishscore=0
 malwarescore=0 spamscore=0 lowpriorityscore=0 mlxlogscore=999
 impostorscore=0 clxscore=1015 mlxscore=0 bulkscore=0 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106240089
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lijun Pan [lijunp213@gmail.com] wrote:
> On Wed, Jun 23, 2021 at 11:16 PM Sukadev Bhattiprolu
> <sukadev@linux.ibm.com> wrote:
> >
> > This reverts commit 1c7d45e7b2c29080bf6c8cd0e213cc3cbb62a054.
> >
> > We tried to optimize the number of hcalls we send and skipped sending
> > the REQUEST_MAP calls for some maps. However during resets, we need to
> > resend all the maps to the VIOS since the VIOS does not remember the
> > old values. In fact we may have failed over to a new VIOS which will
> > not have any of the mappings.
> >
> > When we send packets with map ids the VIOS does not know about, it
> > triggers a FATAL reset. While the client does recover from the FATAL
> > error reset, we are seeing a large number of such resets. Handling
> > FATAL resets is lot more unnecessary work than issuing a few more
> > hcalls so revert the commit and resend the maps to the VIOS.
> >
> 
> This was not an issue when the original optimization code was committed.
> VIOS changes over time and it is proprietary code, so people don't really know
> what it changes every time.

All the more reason to be careful about ripping out code.

>If you believe the verbose hcall is really necessary,
> you'd better document that in the function/source code.

It was necessary and present until you removed it. I am reverting it
after lot of debugging and with sufficient explanation. Feel free to
submit a new patch.

>This patch may be reverted again
> some time later when the verbose calling isn't needed.

Hopefully not without sufficient testing.

Sukadev

Sukadev
