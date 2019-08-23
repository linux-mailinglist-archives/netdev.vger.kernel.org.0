Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 958D39A79E
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 08:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404454AbfHWGc5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 02:32:57 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56598 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404394AbfHWGc5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 02:32:57 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7N6Tft2101077;
        Fri, 23 Aug 2019 06:32:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=+HtSMC0zoFmsedRzEo3yUTRcjYZtx5L6k58x6Xy76Jk=;
 b=Mwuo3DvGpxZsKdWucbFFYc7gJ4o+Lde8r70msySVsgVDFia3QftRg/t2WBOJeb9xDKIF
 MQzL/D70i9WxFCDeUbD/fqRUY/B80Dkg/z2wXXDtJlAJ7/spxTWP5bkdvv0538X7ejW0
 wc1/ZOWOKWMUerfDXOMa0ulkdrGkSvs4D2fW9ZYvBoTCCWBY9/Zu58eb2a4OdNLQF8qA
 g426u0BNMyT7A223x8uhaguXDElCMlrHgx8ixdGavli4fvtK+hR+nmN989YALKEMQZ0l
 Id02W46qOefnoSk/7fkPqr12wyLxrDPTnMQ7rB8q76sYb3U/kppLhvWTG5sJ0c5WpIIG 6g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2ue9hq2gd7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Aug 2019 06:32:50 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7N6SSwu194594;
        Fri, 23 Aug 2019 06:32:49 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 2uj1y051q7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 23 Aug 2019 06:32:49 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x7N6WnhW010482;
        Fri, 23 Aug 2019 06:32:49 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2uj1y051q1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Aug 2019 06:32:49 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7N6Wmue001415;
        Fri, 23 Aug 2019 06:32:48 GMT
Received: from [192.168.86.205] (/69.181.241.203)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 22 Aug 2019 23:32:48 -0700
Subject: Re: [PATCH net-next] net/rds: Fix info leak in rds6_inc_info_copy()
To:     Ka-Cheong Poon <ka-cheong.poon@oracle.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, rds-devel@oss.oracle.com
References: <1566443904-12671-1-git-send-email-ka-cheong.poon@oracle.com>
From:   santosh.shilimkar@oracle.com
Organization: Oracle Corporation
Message-ID: <95538b54-79fa-59f8-77aa-71f3a926f78d@oracle.com>
Date:   Thu, 22 Aug 2019 23:32:45 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1566443904-12671-1-git-send-email-ka-cheong.poon@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9357 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908230069
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/21/19 8:18 PM, Ka-Cheong Poon wrote:
> The rds6_inc_info_copy() function has a couple struct members which
> are leaking stack information.  The ->tos field should hold actual
> information and the ->flags field needs to be zeroed out.
> 
> Fixes: 3eb450367d08 ("rds: add type of service(tos) infrastructure")
> Fixes: b7ff8b1036f0 ("rds: Extend RDS API for IPv6 support")
> Reported-by: 黄ID蝴蝶 <butterflyhuangxx@gmail.com>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Ka-Cheong Poon <ka-cheong.poon@oracle.com>
> ---
Thanks for getting this out of the list.

Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
