Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 836A21A7082
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 03:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390730AbgDNBTr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 21:19:47 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:39054 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728066AbgDNBTp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 21:19:45 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03E1JhCF055849;
        Tue, 14 Apr 2020 01:19:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=4EDrHyItOx5LQY1DZik4qSxP4G3bwbP+YcN/xSRvfAs=;
 b=WVsjZQzQ1/saRkAdS27NUajKeNB+4GxX5w8bx8KWUVhEBJ7YqZBPUP84XwHi/StcvcD4
 7j/RwP+dgVgh3CFj6Mi3IgqyVVMGagCtKgxKWCoxBMx1s3ivCGtO3GZLbsUmnxE2IHT6
 sxUeEEQR0Eq2SpysCZSz002s1Q5jC6CHgiMrjIuaa086bYG0p6z6DQ7z9PsC1U5HGtPU
 nEwa67wZetVgcMm5FKrv1S53CJGwxBFEcUYjleclKU8fUKo3I0mtFpX11v8MJAK38EXT
 FysqH4u7VMSleriyuFXjHiBEh8o/g3pmKOizPpMwovGeSJfuzir3rL3Rf8qHE/QBdqWd GQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 30b5ar1m97-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Apr 2020 01:19:43 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03E1HipX196071;
        Tue, 14 Apr 2020 01:19:42 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 30bqcfvs48-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Apr 2020 01:19:42 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03E1Jgmn017687;
        Tue, 14 Apr 2020 01:19:42 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Apr 2020 18:19:40 -0700
To:     Saurav Kashyap <skashyap@marvell.com>
Cc:     <martin.petersen@oracle.com>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        <linux-scsi@vger.kernel.org>, <jhasan@marvell.com>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH v3 1/7] qedf: Keep track of num of pending flogi.
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200403120957.2431-1-skashyap@marvell.com>
        <20200403120957.2431-2-skashyap@marvell.com>
Date:   Mon, 13 Apr 2020 21:19:38 -0400
In-Reply-To: <20200403120957.2431-2-skashyap@marvell.com> (Saurav Kashyap's
        message of "Fri, 3 Apr 2020 05:09:51 -0700")
Message-ID: <yq17dyivp79.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9590 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=874
 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004140008
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9590 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 impostorscore=0
 clxscore=1011 priorityscore=1501 malwarescore=0 phishscore=0 spamscore=0
 mlxlogscore=942 suspectscore=0 adultscore=0 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004140008
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Saurav,

Please, no "." at the end of Subject: lines.

> - Problem: Port not coming up after bringing down the port
>   for longer duration.
> - Bring down the port from the switch
> - wait for fipvlan to exhaust, driver will use
>   default vlan (1002) and call fcoe_ctlr_link_up
> - libfc/fcoe will start sending FLOGI
> - bring back the port and switch discard FLOGI
>   because vlan is different.
> - keep track of pending flogi and if it increases
>   certain number then do ctx reset and it will do
>   fipvlan again.

That doesn't look like a proper commit message.

How about something like:

    If a port is brought down for an extended period of time, the
    fipvlan counter gets exhausted and the driver will fall back to
    default VLAN 1002 and call fcoe_ctlr_link_up to log in. However, the
    switch will discard the FLOGI attempt because the VLAN is now
    different.

    Keep track of the number of FLOGI attempts and if a threshold of
    QEDF_FLOGI_RETRY_CNT is exceeded, perform a context soft reset.

-- 
Martin K. Petersen	Oracle Linux Engineering
