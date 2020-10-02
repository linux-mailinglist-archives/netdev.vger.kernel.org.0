Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2C1D281CB1
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 22:12:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725798AbgJBUMl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 16:12:41 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:54642 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbgJBUMl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 16:12:41 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 092K9pWt018166;
        Fri, 2 Oct 2020 20:12:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=HKB+kU+dguBITomYx+Y4bu3BrXYOYdiFjQsXwdUDTDI=;
 b=uhBbStB1Tqc9xOD+5oSYoYx+Qula0RhRLRbFuv8nXnK8iDxficIm+CfY7zaFUlNwWe1L
 ySuiRc5N7o3ZLPjJmG9xjO6rLC5LQJBWgicp/SXj6a5Bl+lqUGsuuay8tWTvZTS2HrRg
 Nlg79uCteqbpwpVZRlKZgVRJOGflAFoPtAWh2QYoyIX/nHh3Mdt993RDhkORF11xxIC8
 MJVZKrmCkFwAuqxUDS/LM/jXq3RvKeCcEpPmH5rvUws00p5pIEEHyBN29OXxNRtqVRNS
 9BTa/bqFZPftMGvu9oLRYH0dvQd7jliXuOsyBs/P9jW22U7naxFvrN0TINsKFa0qOXvr 8w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 33swkmcr66-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 02 Oct 2020 20:12:40 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 092K5B3i158530;
        Fri, 2 Oct 2020 20:10:39 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 33tfdy39rc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Oct 2020 20:10:39 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 092KAchB008950;
        Fri, 2 Oct 2020 20:10:38 GMT
Received: from [10.74.106.170] (/10.74.106.170)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 02 Oct 2020 13:10:38 -0700
Subject: Re: [PATCH 1/1] net/rds: suppress page allocation failure error in
 recv buffer refill
To:     Manjunath Patil <manjunath.b.patil@oracle.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        aruna.ramakrishna@oracle.com, rama.nichanamatlu@oracle.com
References: <1601669145-13604-1-git-send-email-manjunath.b.patil@oracle.com>
From:   santosh.shilimkar@oracle.com
Organization: Oracle Corporation
Message-ID: <733882f3-9bd5-8fe4-5d70-ec197455257e@oracle.com>
Date:   Fri, 2 Oct 2020 13:10:36 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <1601669145-13604-1-git-send-email-manjunath.b.patil@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9762 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 malwarescore=0 spamscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010020145
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9762 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 clxscore=1015 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010020146
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/2/20 1:05 PM, Manjunath Patil wrote:
> RDS/IB tries to refill the recv buffer in softirq context using
> GFP_NOWAIT flag. However alloc failure is handled by queueing a work to
> refill the recv buffer with GFP_KERNEL flag. This means failure to
> allocate with GFP_NOWAIT isn't fatal. Do not print the PAF warnings if
> softirq context fails to refill the recv buffer, instead print rate
> limited warnings.
> 
> Signed-off-by: Manjunath Patil <manjunath.b.patil@oracle.com>
> Reviewed-by: Aruna Ramakrishna <aruna.ramakrishna@oracle.com>
> ---
Thanks for the updated version. Whenever you send updated patch,
you should add version so that it helps for archiving as well as
review.

Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
