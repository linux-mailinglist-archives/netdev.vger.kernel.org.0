Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92BE4C4423
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 01:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728680AbfJAXIP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 19:08:15 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:44320 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726050AbfJAXIP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 19:08:15 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x91N6KVW172360;
        Tue, 1 Oct 2019 23:08:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=6FkKS5R842Tm6bTgavtnY3a9lY3IHAUnk0RAANQBXRI=;
 b=NulLEVCUi1rTH2Pc+48oVhDU9NqsMH66JNt4WHKVNOBfBKqEQmI0lR56yuZCITHYVtXX
 38MuBS8HzMuS+swPI4gDWhuiVa8ZrDAZbvYXmDc7upvl/8Kn3o1VGWdAE+2YELIBPlEq
 EJ6YlvVo/GQN3T3mdmIS/hfMn7TCmmZu6OTHBm7Bjm8yOGB3pCC474Yl0uqN0RV7Be/r
 YD/1IMyE03Sr/CKB78NYf8dbKUKNuVx73z6rNBPObh+kjiumMP73HnQl9O7suGz6i672
 qWQVvJExnyxRkhC1zEmoNqdyRh3qGajLKEDrzzeqTKuWAKpcs+ZQqnrxdkxqC5W6JW6r uQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2v9xxusg00-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Oct 2019 23:08:11 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x91N3pxj183192;
        Tue, 1 Oct 2019 23:08:11 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 2vbqd1p2sk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 01 Oct 2019 23:08:11 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x91N8And195457;
        Tue, 1 Oct 2019 23:08:10 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2vbqd1p2s9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Oct 2019 23:08:10 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x91N890e008065;
        Tue, 1 Oct 2019 23:08:09 GMT
Received: from [10.209.226.111] (/10.209.226.111)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Oct 2019 16:08:09 -0700
Subject: Re: [PATCH net-next] net/rds: Log vendor error if send/recv Work
 requests fail
To:     Sudhakar Dindukurti <sudhakar.dindukurti@oracle.com>,
        netdev@vger.kernel.org, davem@davemloft.net,
        rds-devel@oss.oracle.com
References: <1569969676-46142-1-git-send-email-sudhakar.dindukurti@oracle.com>
From:   santosh.shilimkar@oracle.com
Organization: Oracle Corporation
Message-ID: <9baf7ba8-3b09-f657-d777-deaf325de4f5@oracle.com>
Date:   Tue, 1 Oct 2019 16:08:08 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1569969676-46142-1-git-send-email-sudhakar.dindukurti@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9397 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910010195
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/1/19 3:41 PM, Sudhakar Dindukurti wrote:
> Logs vendor error if work requests fail. Vendor error provides
s/Logs/Log
> more information that is used for debugging the issue.
> 
> Signed-off-by: Sudhakar Dindukurti <sudhakar.dindukurti@oracle.com>
> ---
rds_ib_mr_cqe_handler() is already patched so good to patch these
two messages as well. Thanks !!

Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
