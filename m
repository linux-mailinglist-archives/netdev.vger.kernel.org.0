Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F7011A7089
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 03:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390760AbgDNBZl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 21:25:41 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:42908 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727867AbgDNBZk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 21:25:40 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03E1J58N055408;
        Tue, 14 Apr 2020 01:25:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=mA8T8OG3kQrnzP//i7BX5ZFjCIlb/JLeD02D+srqzN4=;
 b=JAPuCP4pes4P21i/qanWBLU5/iiOnQ+xsfSK0+6fHSZHzkb/35xqzc5couiKbmaVTGhc
 15db9gL9ti+YuoC0vycUuF3gHbgZf1moW2Oi1AaQGAim5gP/QRS286WS7uwADcXy2XjH
 xeN8CA4toJhqAHVm6/Yh/RgXQw46Q1TLxh66grA6ocI+razixNWurjKc51kkPCNXs41X
 jH8eV30VFR3rcuXwL3sHgh6KWvtt1QRpPi323gSr6W/Kh8h3/MDzj5Tjcb7z88nwa9S7
 Q5rnmtos3VP1ewmDwCfrlPVdPp+YYxBu3t2hfUh5JbkSfXr0BbPMc5kbjGAbd8O3QQV7 fA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 30b5ar1mmp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Apr 2020 01:25:38 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03E1GtLj030101;
        Tue, 14 Apr 2020 01:25:38 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 30bqm01q59-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Apr 2020 01:25:37 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03E1PbGV008813;
        Tue, 14 Apr 2020 01:25:37 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Apr 2020 18:25:35 -0700
To:     Saurav Kashyap <skashyap@marvell.com>
Cc:     <martin.petersen@oracle.com>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        <linux-scsi@vger.kernel.org>, <jhasan@marvell.com>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH v3 5/7] qedf: Add schedule recovery handler.
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200403120957.2431-1-skashyap@marvell.com>
        <20200403120957.2431-6-skashyap@marvell.com>
Date:   Mon, 13 Apr 2020 21:25:30 -0400
In-Reply-To: <20200403120957.2431-6-skashyap@marvell.com> (Saurav Kashyap's
        message of "Fri, 3 Apr 2020 05:09:55 -0700")
Message-ID: <yq1r1wquad1.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9590 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=687
 adultscore=0 mlxscore=0 phishscore=0 malwarescore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004140008
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9590 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 impostorscore=0
 clxscore=1015 priorityscore=1501 malwarescore=0 phishscore=0 spamscore=0
 mlxlogscore=763 suspectscore=0 adultscore=0 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004140008
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Saurav,

> - Add recovery handler, this will be triggered by QED.

What does it do? Why is it needed?

-- 
Martin K. Petersen	Oracle Linux Engineering
