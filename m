Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17B20FE465
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 18:55:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbfKORzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 12:55:15 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:45626 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726131AbfKORzP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 12:55:15 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAFHs3VU028335;
        Fri, 15 Nov 2019 17:55:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=uKUzoLj65QkfhvCcyDqEvnvlkFIUUfxU44sJC9nbIH0=;
 b=KUkTVEAdRNwinw7XKGZuPaGRddbVwcfl13ZQo08f8pRl7q/7gihbRJO4hiVXqoGBbe9R
 UDhPkOKlCCIOoFClDTDCjFMkdhE2RAg+3qGAb2LcleFifI1YVoYkqs7AzRcJ4jaLqasF
 6ZWYSl5lhg9VJkaX0Y3Dwtx6EBrTKbSZ7OJ1uGYw6h5cmUPxlGMJYFVGC2Nvj5ZHJ3K5
 a+Wi+bpGMEKEqp+ia64etJN98xXZWEeoTy1xYR8PR6wITpQg0C0aI/QiUKMIZQxUAiiC
 Hd4Htk0zXUDGOEPEiLNPXqFnwy25LGaXdWE6yPHibS9kX2smUfO9wEOJ94EAdk+anKK6 TQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2w9gxpmppy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Nov 2019 17:55:08 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAFHnDLF118279;
        Fri, 15 Nov 2019 17:55:07 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 2w9h14wgun-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 15 Nov 2019 17:55:07 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id xAFHq9Fj126400;
        Fri, 15 Nov 2019 17:55:07 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2w9h14wguf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Nov 2019 17:55:06 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xAFHt6E8017156;
        Fri, 15 Nov 2019 17:55:06 GMT
Received: from [10.209.227.41] (/10.209.227.41)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 15 Nov 2019 09:55:05 -0800
Subject: Re: [net] rds: ib: update WR sizes when bringing up connection
To:     Dag Moxnes <dag.moxnes@oracle.com>
Cc:     netdev@vger.kernel.org, rds-devel@oss.oracle.com,
        davem@davemloft.net
References: <1573808161-331-1-git-send-email-dag.moxnes@oracle.com>
From:   santosh.shilimkar@oracle.com
Organization: Oracle Corporation
Message-ID: <f13469d5-02c7-d1b4-bf2c-c26d427554aa@oracle.com>
Date:   Fri, 15 Nov 2019 09:55:05 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1573808161-331-1-git-send-email-dag.moxnes@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9442 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911150160
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/15/19 12:56 AM, Dag Moxnes wrote:
> Currently WR sizes are updated from rds_ib_sysctl_max_send_wr and
> rds_ib_sysctl_max_recv_wr when a connection is shut down. As a result,
> a connection being down while rds_ib_sysctl_max_send_wr or
> rds_ib_sysctl_max_recv_wr are updated, will not update the sizes when
> it comes back up.
> 
> Move resizing of WRs to rds_ib_setup_qp so that connections will be setup
> with the most current WR sizes.
> 
> Signed-off-by: Dag Moxnes <dag.moxnes@oracle.com>
> ---
Looks correct to me. Thanks Dag.

Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
