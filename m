Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4C04C2A66
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 01:11:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732047AbfI3XIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 19:08:17 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:47656 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731960AbfI3XIR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 19:08:17 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8UIA9le085228;
        Mon, 30 Sep 2019 18:36:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=MUQ9h0J88KE/1ERqRdkiUSTDKIZU6nHEvC7+1LOqj6s=;
 b=oLoS3olg5U8BaJ4wL6dQbjV6kkKycqSckmqjaLh9vTtbe3RkHcEE3/eShAH3S/E9h3vC
 XAZ3t9SImRZDTnS5fyZy4RjDQBk/N1jFtEKTIDsLvtcRpyy5wq6ihxQR//EUkDxOgf1n
 5aN8+wSrxRAH5cpcqcQo4EwFibw8+WnS4IXrr5ihJ/gqjfe4Jzxmji8RAaC6TVfSlgrA
 t31ZnwhFIdENis7a/KVcLj0Kmld2Fl16h5HNkW/Mhd1ERjki/Qu7wx895MLkn93gLyqJ
 d1nx440Hsd3oVWOXwsSHN/b6LROfjb1gjjAa7eyELxwdEt4Ico8HyWYJboyxc2Bu9N1P gg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2v9yfq155b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Sep 2019 18:36:53 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8UIDR5v062627;
        Mon, 30 Sep 2019 18:34:52 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 2vbmpwsdev-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 30 Sep 2019 18:34:52 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x8UIQvxh103964;
        Mon, 30 Sep 2019 18:34:52 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2vbmpwsde4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Sep 2019 18:34:52 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8UIYov8012014;
        Mon, 30 Sep 2019 18:34:50 GMT
Received: from [10.209.226.111] (/10.209.226.111)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 30 Sep 2019 11:34:50 -0700
Subject: Re: [PATCH net-next] net/rds: Use DMA memory pool allocation for
 rds_header
To:     Ka-Cheong Poon <ka-cheong.poon@oracle.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, rds-devel@oss.oracle.com
References: <1569834480-25584-1-git-send-email-ka-cheong.poon@oracle.com>
From:   santosh.shilimkar@oracle.com
Organization: Oracle Corporation
Message-ID: <bb76878a-caae-a06f-c044-0aef22aebc1d@oracle.com>
Date:   Mon, 30 Sep 2019 11:34:49 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1569834480-25584-1-git-send-email-ka-cheong.poon@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9396 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909300165
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/30/19 2:08 AM, Ka-Cheong Poon wrote:
> Currently, RDS calls ib_dma_alloc_coherent() to allocate a large piece
> of contiguous DMA coherent memory to store struct rds_header for
> sending/receiving packets.  The memory allocated is then partitioned
> into struct rds_header.  This is not necessary and can be costly at
> times when memory is fragmented.  Instead, RDS should use the DMA
> memory pool interface to handle this.
> 
> Suggested-by: Håkon Bugge <haakon.bugge@oracle.com>
> Signed-off-by: Ka-Cheong Poon <ka-cheong.poon@oracle.com>
> ---
Thanks for getting this out on the list Ka-Cheong.

Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
