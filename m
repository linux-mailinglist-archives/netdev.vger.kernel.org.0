Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C607128D688
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 00:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729087AbgJMWnh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 18:43:37 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:34364 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728931AbgJMWnZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Oct 2020 18:43:25 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09DMYHRI023311;
        Tue, 13 Oct 2020 22:43:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=BPXVhR8Zcz1sWINwPPKI15oRrSSfJmS7Dk7t6k2FBvc=;
 b=X98OMsUEJ6iXi28jlvGzIuUNtCUPCHKr9Y26mlldDvGV1tVg0rW4+z19ERv9nUm05fW2
 7uLfRfkQC87plb6dqK0JgwDllNVeWHEr4KuohBovrquRB4Wp8Fn55mzzRhERGk86b1R8
 IUAHuFALM9P0nzG0SMad9VRc3S4BqwSCpX9uXbI7E8E4JWNs+M489BfaOy69s9tMy36o
 WsDINZk0QvR9KX7AD1uVtYIm858Ec1rCBrQM2cWhu74pWwQ4sERB2XP+p4QlG2a3ov36
 KsDceZW1Gf6MViMvswmWBcHmPujmAKdJrQLwx9ihpq7sGfN7gk8NuWumGIvUgBivX+8I Nw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 3434wkmr7r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 13 Oct 2020 22:43:19 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09DMZeSv129581;
        Tue, 13 Oct 2020 22:43:18 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 343phntsx7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 13 Oct 2020 22:43:18 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 09DMhIGo146795;
        Tue, 13 Oct 2020 22:43:18 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 343phntswf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Oct 2020 22:43:18 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09DMhFrt005717;
        Tue, 13 Oct 2020 22:43:16 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 13 Oct 2020 15:43:15 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-spi@vger.kernel.org, Julia Lawall <Julia.Lawall@inria.fr>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        dmaengine@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-media@vger.kernel.org, target-devel@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
        linux-serial@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-scsi@vger.kernel.org, Yossi Leybovich <sleybo@amazon.com>,
        linux-block@vger.kernel.org, rds-devel@oss.oracle.com
Subject: Re: [PATCH 00/14] drop double zeroing
Date:   Tue, 13 Oct 2020 18:42:52 -0400
Message-Id: <160262862433.3018.13907233755506910409.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <1600601186-7420-1-git-send-email-Julia.Lawall@inria.fr>
References: <1600601186-7420-1-git-send-email-Julia.Lawall@inria.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9773 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 mlxscore=0
 malwarescore=0 phishscore=0 suspectscore=0 impostorscore=0 clxscore=1011
 spamscore=0 priorityscore=1501 bulkscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010130158
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 20 Sep 2020 13:26:12 +0200, Julia Lawall wrote:

> sg_init_table zeroes its first argument, so the allocation of that argument
> doesn't have to.

Applied to 5.10/scsi-queue, thanks!

[02/14] scsi: target: rd: Drop double zeroing
        https://git.kernel.org/mkp/scsi/c/4b217e015b75

-- 
Martin K. Petersen	Oracle Linux Engineering
