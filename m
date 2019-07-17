Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 096C26B2CD
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 02:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728848AbfGQA0l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 20:26:41 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:57656 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728235AbfGQA0k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 20:26:40 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6H0OvVY001172;
        Wed, 17 Jul 2019 00:26:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=Ei2qpDLg+dvmu2H5S4s7rzcBwuluQ4lZu9ql1yOT3N0=;
 b=FMWV2ltCw0aBCb6ZWdQLRLfWTyXCBN9W+OMtT598Js9jVBn19tAusdrJiWi29gMJLTys
 kAnkp4JGriFrzkIr8wkZYdlfToKyBetiRH8npBXST1aAw9tcsFVbiQbb2eGsY2vIlxvO
 +zc25qBaDqmyScY8y9fBcjojH7KzaymjtwfsbXQE26DL8Yp0pNgs0A6ZCpyx5e4wwCgt
 8b6M3aGl8xdRIVmF3d3TmO4V4+rxy3rbgpj5V+VTWdD0eQ57k6kjgcWYsz2TdZ0Uogek
 oZWKZRYThDAUK0CyJDS8gUEIw4XO0xTUF5lHv2rdQYVSBgCGzoItNz5s7WrJa8f3CgMr vw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2tq7xqye3p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Jul 2019 00:26:38 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6H0MxD8110023;
        Wed, 17 Jul 2019 00:26:37 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 2tq5bcq126-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 17 Jul 2019 00:26:37 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x6H0QbVO115018;
        Wed, 17 Jul 2019 00:26:37 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2tq5bcq122-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Jul 2019 00:26:37 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x6H0Qara029066;
        Wed, 17 Jul 2019 00:26:36 GMT
Received: from [192.168.86.192] (/69.181.241.203)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 17 Jul 2019 00:26:36 +0000
Subject: Re: [PATCH net v3 2/7] net/rds: Get rid of "wait_clean_list_grace"
 and add locking
To:     Gerd Rausch <gerd.rausch@oracle.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Cc:     David Miller <davem@davemloft.net>
References: <3e608430-4b96-4c25-6593-4479131bb904@oracle.com>
From:   santosh.shilimkar@oracle.com
Organization: Oracle Corporation
Message-ID: <cce4093b-ed64-19e3-1ad9-15df65a109ff@oracle.com>
Date:   Tue, 16 Jul 2019 17:26:35 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <3e608430-4b96-4c25-6593-4479131bb904@oracle.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9320 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907170003
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/16/19 3:28 PM, Gerd Rausch wrote:
> Waiting for activity on the "clean_list" to quiesce is no substitute
> for proper locking.
> 
> We can have multiple threads competing for "llist_del_first"
> via "rds_ib_reuse_mr", and a single thread competing
> for "llist_del_all" and "llist_del_first" via "rds_ib_flush_mr_pool".
> 
> Since "llist_del_first" depends on "list->first->next" not to change
> in the midst of the operation, simply waiting for all current calls
> to "rds_ib_reuse_mr" to quiesce across all CPUs is woefully inadequate:
> 
> By the time "wait_clean_list_grace" is done iterating over all CPUs to see
> that there is no concurrent caller to "rds_ib_reuse_mr", a new caller may
> have just shown up on the first CPU.
> 
> Furthermore, <linux/llist.h> explicitly calls out the need for locking:
>   * Cases where locking is needed:
>   * If we have multiple consumers with llist_del_first used in one consumer,
>   * and llist_del_first or llist_del_all used in other consumers,
>   * then a lock is needed.
> 
> Also, while at it, drop the unused "pool" parameter
> from "list_to_llist_nodes".
> 
> Signed-off-by: Gerd Rausch <gerd.rausch@oracle.com>
> ---
Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
