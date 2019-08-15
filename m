Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7EDB8F04B
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 18:18:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730563AbfHOQSY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 12:18:24 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:53962 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728979AbfHOQSX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 12:18:23 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7FGDW5c173133;
        Thu, 15 Aug 2019 16:18:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=VlFlXc2shqrc6EJz2QxoOsKsvpnK4nSqABUqUlGj5xA=;
 b=VhzUPnzyzMGq0Db5HUilNqCi1ub/SXjUztLHL8z1F9GExKN7eFPQv7ztUkuvq6ccuO05
 lGd14kBJbrbps/FfcDD7kyK9LfzVs/J7Hm04SkZB9I9jA0ouysgLR2Qq64w96ceQ+QoD
 kz5dqHrJ1u9+V337wCJFh6++ZdaXzgir5fhyw79nuybKAo1bSxg6W09EBbGKarFfJkde
 2RrS1DFW25Wfx69BG+JXZUfTCKnl2M2Qgg5dFWCpFVdBYGAI837+eTwgZXE7dlP2j3yC
 IDA6Wdxi2BGOdlvysIGT9RfUbPy1BPS8JKg9sQUuX/HpNB0r0MFPfXVCJEZcjmQM7GWf lQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2u9nbtunc4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Aug 2019 16:18:22 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7FGCmgI093762;
        Thu, 15 Aug 2019 16:18:21 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 2ucpysgn9x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 15 Aug 2019 16:18:21 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x7FGCpJe094188;
        Thu, 15 Aug 2019 16:18:21 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2ucpysgn9m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Aug 2019 16:18:21 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7FGIKug017456;
        Thu, 15 Aug 2019 16:18:20 GMT
Received: from [10.159.249.63] (/10.159.249.63)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 15 Aug 2019 09:18:20 -0700
Subject: Re: [PATCH net-next v2 4/4] rds: check for excessive looping in
 rds_send_xmit
To:     Gerd Rausch <gerd.rausch@oracle.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Cc:     David Miller <davem@davemloft.net>
References: <20190814.212525.326606319186601317.davem@davemloft.net>
 <cover.1565879451.git.gerd.rausch@oracle.com>
 <d91e3273-48bb-13bf-af65-40472890f975@oracle.com>
From:   santosh.shilimkar@oracle.com
Organization: Oracle Corporation
Message-ID: <320355a6-b137-04a2-1a37-52f4df4806fc@oracle.com>
Date:   Thu, 15 Aug 2019 09:18:19 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <d91e3273-48bb-13bf-af65-40472890f975@oracle.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9350 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908150159
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/15/19 7:43 AM, Gerd Rausch wrote:
> From: Andy Grover <andy.grover@oracle.com>
> Date: Thu, 13 Jan 2011 11:40:31 -0800
> 
> Original commit from 2011 updated to include a change by
> Yuval Shaia <yuval.shaia@oracle.com>
> that adds a new statistic counter "send_stuck_rm"
> to capture the messages looping exessively
> in the send path.
> 
> Signed-off-by: Gerd Rausch <gerd.rausch@oracle.com>
> ---
Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
