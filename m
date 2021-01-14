Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5ABB2F5880
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 04:02:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727102AbhANCgd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 21:36:33 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:38832 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726429AbhANCgc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 21:36:32 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10E2WIC3008284;
        Wed, 13 Jan 2021 21:35:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=lxqLFP37OVSrqJARUgAkBgJGUNDWHML3gYyPHtSOhqw=;
 b=S6Me8VmVrYL8jgR6+cqZsWk1w3wiCUhPRtBxtzLWqXK+vyC7f3KAOziiRgWSVSKzKLgv
 sdpUPecqDXiR90rz6uRL2gX5Q8kvdgTNuZllb66NhTXyxD0JmSyfcBXSfHW9yXDTmb83
 DtrzQOPP/VoMkfyTor3wKzrMwq40CkPxdY2ahEqQPi0pZHwiaFZJ7QUp0cw5IBUCDoA0
 pfK6+lB36xIUNGVsO4M7iOtOqj5rSzdjqXlY5D3yB/C+UPmcFcH8JLiE9lY7FrWwQTpB
 TMrg2/6/oqprPWXzJ8aaLzg1dJ+br/WZQH5KZ6ebr2lO3ed9Xote93uK1mG4DU3AbQpQ Jg== 
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 362c4mhgxt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 21:35:49 -0500
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10E2WG0I014371;
        Thu, 14 Jan 2021 02:35:49 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma05wdc.us.ibm.com with ESMTP id 362cwm842m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jan 2021 02:35:49 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10E2ZmsR10682710
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jan 2021 02:35:48 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 58223136051;
        Thu, 14 Jan 2021 02:35:48 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2631813604F;
        Thu, 14 Jan 2021 02:35:48 +0000 (GMT)
Received: from suka-w540.localdomain (unknown [9.85.136.152])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 14 Jan 2021 02:35:48 +0000 (GMT)
Received: by suka-w540.localdomain (Postfix, from userid 1000)
        id 167FE2E2732; Wed, 13 Jan 2021 18:35:44 -0800 (PST)
Date:   Wed, 13 Jan 2021 18:35:44 -0800
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Dany Madden <drt@linux.ibm.com>,
        Lijun Pan <ljp@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>
Subject: Re: [PATCH net-next v2 0/7] ibmvnic: Use more consistent locking
Message-ID: <20210114023544.GA251151@us.ibm.com>
References: <20210112181441.206545-1-sukadev@linux.ibm.com>
 <20210112180054.28ebcd1a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210112180054.28ebcd1a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Operating-System: Linux 2.0.32 on an i486
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-13_14:2021-01-13,2021-01-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 impostorscore=0 bulkscore=0 clxscore=1015 mlxlogscore=703 mlxscore=0
 adultscore=0 lowpriorityscore=0 priorityscore=1501 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101140007
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

I think the locking bug fixes need the refactoring. So would it be ok to
send the refactoring (patches 2 through 4) first to net-next and when
they are merged send the the bug fixes (1, 5 and 6)? Patch 7 can be
sent to net-next later after that.

Thanks,

Sukadev
