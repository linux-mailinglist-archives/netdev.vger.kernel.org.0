Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46D341A7086
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 03:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390747AbgDNBYz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 21:24:55 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:44770 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728066AbgDNBYz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 21:24:55 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03E1IexW084609;
        Tue, 14 Apr 2020 01:24:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=D1vTQT+MpnWQHu89Syr4amQ96xVbD7o2JPPzXXDBvXw=;
 b=dKkmmfjTpUxjJri74UHqa0/lawEQ3Hr05NqZ9ssIxr9P0H+ZxkANt41SJn0oUYd/sm9i
 mgZ9OVjzmuni0+xss3uYZNntov9bDBTzoLyn7thBqR8kJz8rZMeWuocmKatInyqBlaQd
 v+7mBPjRwthU6y3QMtdhhoBWVJH3ozmCFpn0gYWXHYYpL6cC3OTJtWCeKwWEGEoFrqSt
 NhFbTScXir9ra2qvxHWuVYFr4rDC9eCd+om6S9M2qb86AyOpNggk/kfk0lDnEh6vKzE+
 /PyaKcdHqa6pRIuQG/8lEEUo1Ln52SIxE5HPDPSOuaZ21dEU8ddM3faxGN2nHvxlNlsD 0g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 30b5um1mkf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Apr 2020 01:24:52 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03E1Hwtf054271;
        Tue, 14 Apr 2020 01:24:51 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 30bqpe6n72-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Apr 2020 01:24:51 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03E1Oo2R003997;
        Tue, 14 Apr 2020 01:24:50 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Apr 2020 18:24:50 -0700
To:     Saurav Kashyap <skashyap@marvell.com>
Cc:     <martin.petersen@oracle.com>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        <linux-scsi@vger.kernel.org>, <jhasan@marvell.com>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH v3 4/7] qedf: Implement callback for bw_update.
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200403120957.2431-1-skashyap@marvell.com>
        <20200403120957.2431-5-skashyap@marvell.com>
Date:   Mon, 13 Apr 2020 21:24:48 -0400
In-Reply-To: <20200403120957.2431-5-skashyap@marvell.com> (Saurav Kashyap's
        message of "Fri, 3 Apr 2020 05:09:54 -0700")
Message-ID: <yq1v9m2uae7.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9590 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=843 malwarescore=0
 adultscore=0 bulkscore=0 spamscore=0 suspectscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004140008
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9590 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 bulkscore=0 mlxscore=0
 mlxlogscore=918 lowpriorityscore=0 impostorscore=0 adultscore=0
 phishscore=0 spamscore=0 suspectscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004140008
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Saurav,

> This is extension of bw common callback provided by qed.
> This is called whenever there is a change in the BW.

    Add support for the common qed bw_update callback to qedf.  This
    function is called whenever there is a reported change in the
    bandwidth. It is required because...

-- 
Martin K. Petersen	Oracle Linux Engineering
