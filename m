Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA9EB1A7088
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 03:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390753AbgDNBY5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 21:24:57 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:49976 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390741AbgDNBY4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 21:24:56 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03E1JIrj095309;
        Tue, 14 Apr 2020 01:24:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=8Dzc/Rdxg9baUsL+8G2kiH09PeA7zFg8dzOcM3LFkfw=;
 b=JU4xcHeMbobiL0q91tdu9sl/z9XCFjLkxgfS0any7Dfvp8kXUcNCPXA7eBap8DclT5x7
 q22bugngmKLof4cAmI3mXhA3IGnrHLbRVe6gBRSz7yMbi6tBhTanRiNhNpyKut4ae+sF
 gaEYBBWmuZE5hO/8P4/KxlqMZ2WovIZDi4+An/sVburRoMebTlMvpU1rC2O8I68bjzrJ
 Nu2se1tYGqwsEcS/KJ8J9Aowf/wMAgcJDZQN856tvXx3wFUVP7dGV7sf1OuuoNQhP6VI
 9VSfQvWxlU8td3psML6MytLx4DpzUg1THtcnm3SUlWLb1e2UaKB9DBNV5CpQH5g4uRa5 lQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 30b6hphkf8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Apr 2020 01:24:53 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03E1GuM4030175;
        Tue, 14 Apr 2020 01:22:53 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 30bqm01fmk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Apr 2020 01:22:53 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03E1MqMp007616;
        Tue, 14 Apr 2020 01:22:52 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Apr 2020 18:22:51 -0700
To:     Saurav Kashyap <skashyap@marvell.com>
Cc:     <martin.petersen@oracle.com>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        <linux-scsi@vger.kernel.org>, <jhasan@marvell.com>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH v3 2/7] qedf: Fix for the deviations from the SAM-4 spec.
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200403120957.2431-1-skashyap@marvell.com>
        <20200403120957.2431-3-skashyap@marvell.com>
Date:   Mon, 13 Apr 2020 21:22:49 -0400
In-Reply-To: <20200403120957.2431-3-skashyap@marvell.com> (Saurav Kashyap's
        message of "Fri, 3 Apr 2020 05:09:52 -0700")
Message-ID: <yq13696vp1y.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9590 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=846
 adultscore=0 mlxscore=0 phishscore=0 malwarescore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004140008
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9590 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 mlxlogscore=906 clxscore=1015 mlxscore=0 phishscore=0 suspectscore=0
 lowpriorityscore=0 bulkscore=0 malwarescore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004140008
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Saurav,

This should be 3 patches since there are 3 different functional
changes.

> - Upper limit for retry delay(QEDF_RETRY_DELAY_MAX)
>   increased from 20 sec to 1 min.

> - Log an event/message indicating throttling of I/O
>   for the target and include scope and retry delay
>   time returned by the target and the driver enforced delay.

> - Synchronizing the update of the fcport->retry_delay_timestamp
>   between qedf_queuecommand() and qedf_scsi_completion().

"Synchronize".

Please describe why this needs to be synchronized.

-- 
Martin K. Petersen	Oracle Linux Engineering
