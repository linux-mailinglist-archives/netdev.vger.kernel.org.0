Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBCE776B82
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 16:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387521AbfGZOYp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 10:24:45 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56218 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387397AbfGZOYo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 10:24:44 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6QEOJvS115049;
        Fri, 26 Jul 2019 14:24:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=Goe8R1MO+kKgjWPnckhRWLHat8tNL3qy3qwaq865LEA=;
 b=nRCJPm/DCLPZFJIlisv6u2dnedD6ckrHi3Mv+bx/gTHbYeEkkuzyRy6paKwjbGF5sAhI
 whparH0QvSMbKqUmj0XIRn57Tgb4i1PqmZfDVRsfYrnLvSEIARQqROWfgFKM4sOOG5+v
 4eyB1Akgy2GxZU0+A61RE7Pezv2MD7okV4VFv/QQ9/PESqgQ9UIVFZC1rcyahwwwRyYz
 Wu/7Er3tDVGEfokuPQx/AC1m1qxgIPnVOHxcGgqMTmQ7vzThCA5I4DP42DLtrvnO1k+E
 CW/W+ilqH2c5DblJ3UXqxRQskZRqagldAAgBxnoOI1z4n3T2jGos02a50jsFnoMDSQzR WA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2tx61cag52-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Jul 2019 14:24:35 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6QEMPqx163406;
        Fri, 26 Jul 2019 14:24:34 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 2tycv808gk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 26 Jul 2019 14:24:34 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x6QEOYpS168353;
        Fri, 26 Jul 2019 14:24:34 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2tycv808gc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Jul 2019 14:24:34 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x6QEOX63019475;
        Fri, 26 Jul 2019 14:24:33 GMT
Received: from [10.159.129.19] (/10.159.129.19)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 26 Jul 2019 07:24:33 -0700
Subject: Re: [PATCH] net: rds: Fix possible null-pointer dereferences in
 rds_rdma_cm_event_handler_cmn()
To:     Jia-Ju Bai <baijiaju1990@gmail.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
References: <20190726141705.9585-1-baijiaju1990@gmail.com>
From:   santosh.shilimkar@oracle.com
Organization: Oracle Corporation
Message-ID: <822b6157-57c5-8313-d487-6a0b3880c66d@oracle.com>
Date:   Fri, 26 Jul 2019 07:24:31 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190726141705.9585-1-baijiaju1990@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9330 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1907260177
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/26/19 7:17 AM, Jia-Ju Bai wrote:
> In rds_rdma_cm_event_handler_cmn(), there are some if statements to
> check whether conn is NULL, such as on lines 65, 96 and 112.
> But conn is not checked before being used on line 108:
>      trans->cm_connect_complete(conn, event);
> and on lines 140-143:
>      rdsdebug("DISCONNECT event - dropping connection "
>              "%pI6c->%pI6c\n", &conn->c_laddr,
>              &conn->c_faddr);
>      rds_conn_drop(conn);
> 
> Thus, possible null-pointer dereferences may occur.
> 
> To fix these bugs, conn is checked before being used.
> 
> These bugs are found by a static analysis tool STCheck written by us.
> 
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
> ---
That's possible. Looks good.

Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>


