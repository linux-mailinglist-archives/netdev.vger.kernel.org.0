Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B85CB6B2CB
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 02:26:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730493AbfGQA0R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 20:26:17 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:57356 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728699AbfGQA0R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 20:26:17 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6H0OvvK001163;
        Wed, 17 Jul 2019 00:26:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=fHEoOqqR2/nWXFYbhP+3p4B7SA93U5PxyaUELIp60so=;
 b=w60fmZYvc0+JGEdFbJTC0RG848u2LMPxkWiKSmMZqqj3lO84wJS77uth9vi9i2LaEJxz
 qa2nj1ZWhxlRcW9gYzJI8xW41kqdgbWJBbAd+KArtpnYb7i2e1C2mSk2LW/LqEIXOhEe
 KUc3sZJUtsO4r/FXts9Sb593ehu0R1v+ZXPhHb/gK86hOUr140KWikQF2QKB3GeyjB+1
 6FoJ3OuPTVn2ULYBHAT5yW2MTeaHlrzjIktkkz7uWTfS2hJKVnw7DViU7jdMmV85yxVA
 KAL8xVpz4v08terunH86v1NiTaL42lC6MpuThaPVZcHNoF27NFLM1ExGiV8RFoZ9lmO/ bA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2tq7xqye35-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Jul 2019 00:26:07 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6H0MxTK110046;
        Wed, 17 Jul 2019 00:26:06 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 2tq5bcq0xr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 17 Jul 2019 00:26:06 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x6H0Q6bA114555;
        Wed, 17 Jul 2019 00:26:06 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2tq5bcq0xn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Jul 2019 00:26:06 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x6H0Q5XX001141;
        Wed, 17 Jul 2019 00:26:05 GMT
Received: from [192.168.86.192] (/69.181.241.203)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 17 Jul 2019 00:26:05 +0000
Subject: Re: [PATCH net v3 1/7] net/rds: Give fr_state a chance to transition
 to FRMR_IS_FREE
To:     Gerd Rausch <gerd.rausch@oracle.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Cc:     David Miller <davem@davemloft.net>
References: <491db13c-3843-b57a-c9c5-9c7e7c18381a@oracle.com>
From:   santosh.shilimkar@oracle.com
Organization: Oracle Corporation
Message-ID: <88c45c78-13fb-9774-6397-397b5d08c78e@oracle.com>
Date:   Tue, 16 Jul 2019 17:26:04 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <491db13c-3843-b57a-c9c5-9c7e7c18381a@oracle.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9320 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907170003
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/16/19 3:28 PM, Gerd Rausch wrote:
> In the context of FRMR (ib_frmr.c):
> 
> Memory regions make it onto the "clean_list" via "rds_ib_flush_mr_pool",
> after the memory region has been posted for invalidation via
> "rds_ib_post_inv".
> 
> At that point in time, "fr_state" may still be in state "FRMR_IS_INUSE",
> since the only place where "fr_state" transitions to "FRMR_IS_FREE"
> is in "rds_ib_mr_cqe_handler", which is triggered by a tasklet.
> 
> So in case we notice that "fr_state != FRMR_IS_FREE" (see below),
> we wait for "fr_inv_done" to trigger with a maximum of 10msec.
> Then we check again, and only put the memory region onto the drop_list
> (via "rds_ib_free_frmr") in case the situation remains unchanged.
> 
> This avoids the problem of memory-regions bouncing between "clean_list"
> and "drop_list" before they even have a chance to be properly invalidated.
> 
> Signed-off-by: Gerd Rausch <gerd.rausch@oracle.com>
> ---
Thanks for the update.

Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
