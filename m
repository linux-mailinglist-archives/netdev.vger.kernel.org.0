Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29E19C3EF3
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 19:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730730AbfJARsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 13:48:07 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:57820 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728620AbfJARsG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 13:48:06 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x91HXuwr054313;
        Tue, 1 Oct 2019 17:47:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=9HzbbCzumrTnxYClqOVyxHEU1V1QW0oSv6zzOxbRfHE=;
 b=Frzv0W9dM4h35yiRCZMpczl+OrLEXy87CmYpGBFxuRDgU9I8FE8+lwhXbdss2PTnRsny
 0MSeOWcs1ieS/HgV6BG76XtqSQYPr45PGaOLT08cEpHe0fODGzCXjdjlS0fSzICyUVHb
 D3B2c5JUmFnIklL7lqH03bo+jb56BF7VEAIkh2nnNapBSqhRbksoBkUD5A3K6VESlWVo
 G0ToAN1/hwGLvIXoa4+oM6CmrnoUldGWWU8Qz2finoMQ6yo8RKMgto3pwdMmnNsQrHxW
 hQoJETqs4KVXuXsmVFUtIFFS1RS2zugw32Ffqcx4PFTlXboCel9TcIsFaUdh+GeuEvwJ 1w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2v9yfq7s77-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Oct 2019 17:47:58 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x91HYF2r150082;
        Tue, 1 Oct 2019 17:47:57 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 2vc9dhqh2k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 01 Oct 2019 17:47:57 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x91Hlvq6191014;
        Tue, 1 Oct 2019 17:47:57 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2vc9dhqh24-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Oct 2019 17:47:57 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x91Hlulv003512;
        Tue, 1 Oct 2019 17:47:56 GMT
Received: from [10.209.227.25] (/10.209.227.25)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Oct 2019 10:47:56 -0700
Subject: Re: [PATCH net] net/rds: Fix error handling in rds_ib_add_one()
To:     Sudhakar Dindukurti <sudhakar.dindukurti@oracle.com>,
        netdev@vger.kernel.org, davem@davemloft.net,
        rds-devel@oss.oracle.com
Cc:     Dotan Barak <dotanb@dev.mellanox.co.il>
References: <1569950462-37680-1-git-send-email-sudhakar.dindukurti@oracle.com>
From:   santosh.shilimkar@oracle.com
Organization: Oracle Corporation
Message-ID: <7b8bade4-fc23-6741-452a-23c36f24c57d@oracle.com>
Date:   Tue, 1 Oct 2019 10:47:55 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1569950462-37680-1-git-send-email-sudhakar.dindukurti@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9397 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910010144
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/1/19 10:21 AM, Sudhakar Dindukurti wrote:
> From: Dotan Barak <dotanb@dev.mellanox.co.il>
> 
> rds_ibdev:ipaddr_list and rds_ibdev:conn_list are initialized
> after allocation some resources such as protection domain.
> If allocation of such resources fail, then these uninitialized
> variables are accessed in rds_ib_dev_free() in failure path. This
> can potentially crash the system. The code has been updated to
> initialize these variables very early in the function.
> 
> Signed-off-by: Dotan Barak <dotanb@dev.mellanox.co.il>
> Signed-off-by: Sudhakar Dindukurti <sudhakar.dindukurti@oracle.com>
> ---
Thanks Sudhakar !!

Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
