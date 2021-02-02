Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 977C330B94C
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 09:14:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231420AbhBBIN0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 03:13:26 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:40704 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbhBBINU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 03:13:20 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1128551F176778;
        Tue, 2 Feb 2021 08:12:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=EkFId3LnqSUIZCRZEfLsq8g/NEaDT5HxkdBh5mNoFA0=;
 b=KvIReKLgixr1tRSxPZfvw4ofwH9EhJFRerXsWKHh7AMhB7MnvWUg16j9CWvDT8+f9BbM
 kwYjXX6ne+nFCl76OCh9DKNdq+APyJH4hJkAsygyQMgABiix1vd439Vna6MEQGT6q8Nh
 3/I/64MXROgC6SZQFah9pfIpnIbDoGEgp7SWSGRm8Pz5kF3qfW0dFhyXXRd9fVoh2B9x
 86AhJBaCTmmRRr72sSF0x7iFFatPugm7VsjtMC14Csfxla9d4puti9eDxzeoJbPRiMAV
 fTPpdA6Izn7EyNkrQs7ZsplxrjmTfvJr5HgIJjIt4SNkAFKoRWMinUltLGdOMOCN41hJ 2A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 36cydkscf5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Feb 2021 08:12:26 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11285Shx032944;
        Tue, 2 Feb 2021 08:10:23 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 36dh1nmd2w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Feb 2021 08:10:23 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 1128AJjs006525;
        Tue, 2 Feb 2021 08:10:19 GMT
Received: from kadam (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 02 Feb 2021 00:10:18 -0800
Date:   Tue, 2 Feb 2021 11:10:10 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Hillf Danton <hdanton@sina.com>, Sasha Levin <sashal@kernel.org>,
        Archie Pusaka <apusaka@chromium.org>
Cc:     syzbot <syzbot+3ed6361bf59830ca9138@syzkaller.appspotmail.com>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Miao-chen Chou <mcchou@chromium.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@intel.com>,
        syzkaller-bugs@googlegroups.com
Subject: Re: KASAN: slab-out-of-bounds Read in add_adv_patterns_monitor
Message-ID: <20210202081010.GZ20820@kadam>
References: <00000000000076ecf305b9f8efb1@google.com>
 <20210131100154.14452-1-hdanton@sina.com>
 <20210202075110.GR2696@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210202075110.GR2696@kadam>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9882 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102020055
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9882 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 clxscore=1015
 spamscore=0 lowpriorityscore=0 phishscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102020055
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 36211f7fc1e7 ("Bluetooth: Pause service discovery for suspend")
seems like a bugfix as well but there is no Fixes tag there either.  The
commit message should be more clear what the effect of the bug looks
like to the user.  I like to write something like this:

[PATCH] Bluetooth: Pause service discovery for suspend

Just like MGMT_OP_START_DISCOVERY, we should reject
MGMT_OP_START_SERVICE_DISCOVERY with MGMT_STATUS_BUSY when we are paused
for suspend.  This bug was discovered by auditing the software and no
one has complained about it, but presumably it leads to a hanged process
because the cmd cannot complete.

Sometimes it's hard to know what the affect of a bug is, but since
you're working in the subsystem then you probably have a better guess
than the rest of us so even a guess is useful.

regards,
dan carpenter

