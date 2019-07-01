Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B96575C42D
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 22:15:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbfGAUPi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 16:15:38 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:36378 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726509AbfGAUPi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 16:15:38 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x61KDcEG160796;
        Mon, 1 Jul 2019 20:15:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=Y07BlaBrGXm3wPUh6lSk9hv5dk5Hhv9Qez9+GxloBDk=;
 b=jURIJNLfmCFcs8IZYqh69c/QOqYTPlrYp+SkYWx1Mtr9Wqscx839W1S3ebhzfWiNQ5L1
 986rxfQxQsuWRgzYHgevvZmpB3mvzmTwnE5pOlU6P1f2ZpeQ9e8bOMXNObkczaCxXJ1M
 T3Up6tagMBiRH4tPTEDwjK8jN6i/pn4r30FUjfUAeNBxN9a7J8f2BdU5dWQV87E3opT0
 wsP98N8zovyUWacnmOSXPFPQmcFVnjAW6XgCiFw/Fe2etlvuClDb2bRnOUv3v1WwfHDj
 bzh/otMfWDeiuKv2nJ9HvgEnX3mYBQky+SIoPECQSXlrNAMh6TAH1VtANKf4HPAaKus5 sg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2te61pqq9x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Jul 2019 20:15:34 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x61KD2px111643;
        Mon, 1 Jul 2019 20:15:34 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2tebbjcpp6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Jul 2019 20:15:34 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x61KFXjd023421;
        Mon, 1 Jul 2019 20:15:33 GMT
Received: from [10.209.242.148] (/10.209.242.148)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 01 Jul 2019 13:15:33 -0700
Subject: Re: [PATCH net-next 6/7] net/rds: Keep track of and wait for FRWR
 segments in use upon shutdown
To:     Gerd Rausch <gerd.rausch@oracle.com>, netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>
References: <ad27abb5-b86a-1942-e2c8-2cba00812849@oracle.com>
From:   santosh.shilimkar@oracle.com
Organization: Oracle Corporation
Message-ID: <a33255c9-9d12-5438-da8a-e2f4f7180bb3@oracle.com>
Date:   Mon, 1 Jul 2019 13:15:32 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <ad27abb5-b86a-1942-e2c8-2cba00812849@oracle.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9305 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907010234
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9305 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907010234
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/1/19 9:40 AM, Gerd Rausch wrote:
> Since "rds_ib_free_frmr" and "rds_ib_free_frmr_list" simply put
> the FRMR memory segments on the "drop_list" or "free_list",
> and it is the job of "rds_ib_flush_mr_pool" to reap those entries
> by ultimately issuing a "IB_WR_LOCAL_INV" work-request,
> we need to trigger and then wait for all those memory segments
> attached to a particular connection to be fully released before
> we can move on to release the QP, CQ, etc.
> 
> So we make "rds_ib_conn_path_shutdown" wait for one more
> atomic_t called "i_fastreg_inuse_count" that keeps track of how
> many FRWR memory segments are out there marked "FRMR_IS_INUSE"
> (and also wake_up rds_ib_ring_empty_wait, as they go away).
> 
> Signed-off-by: Gerd Rausch <gerd.rausch@oracle.com>
> ---
Looks good to me. Will add this to other fixes.

