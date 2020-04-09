Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CF141A374F
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 17:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728285AbgDIPia (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 11:38:30 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:58926 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728177AbgDIPia (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 11:38:30 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 039FYHHm154132;
        Thu, 9 Apr 2020 15:38:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=0C0s6uOZwYkvtkt/u7QjPmsNBSVeDqKIpjUjnLRBD1c=;
 b=t37lPKFcg7FyFYPmS3iiukEnUqUdvnCr4zQlnSLPPcjmKf90Tu6I/yEUW7Qmh12OLW5y
 5vKgjiGyis76tQFjtPeARM2Bic9ga8JfjcXlHXMNsDhWyRKLXvapn8JrhU36Q0C/Tdm6
 vMeKnTuAW0rw8AGsvgQQbqxzWNoImoqns4nQImqdJw9c7COkfG8/PM8D/rSVSsJFJ7id
 ojA4PHnbW1I9l8EuupcWFNrZ63YfY9O9SKawEeRdsdoPdiaIzdQNWYfUPg8EkLyLOxmA
 VLDb0FFugNiwXw9Sv12NcbkS3DiLFY9PbgSOegfsl2mRaAk4ceGmtuc8ruM+QFv3e1Ni wg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 3091m3j8mu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Apr 2020 15:38:21 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 039FVdY9161156;
        Thu, 9 Apr 2020 15:36:20 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 3091m8fgvu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 09 Apr 2020 15:36:20 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 039FaJO2177362;
        Thu, 9 Apr 2020 15:36:19 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 3091m8fgtg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Apr 2020 15:36:19 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 039FaIpK028740;
        Thu, 9 Apr 2020 15:36:18 GMT
Received: from [10.159.145.166] (/10.159.145.166)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 09 Apr 2020 08:36:18 -0700
Subject: Re: [PATCH v2 net 1/2] net/rds: Replace struct rds_mr's r_refcount
 with struct kref
To:     Ka-Cheong Poon <ka-cheong.poon@oracle.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, rds-devel@oss.oracle.com,
        sironhide0null@gmail.com
References: <fb149123516920dd5f5bf730a1da3a0cb9f3d25e.1586340235.git.ka-cheong.poon@oracle.com>
From:   santosh.shilimkar@oracle.com
Organization: Oracle Corporation
Message-ID: <e3c016c7-4159-35bc-623a-cf9f68ffa915@oracle.com>
Date:   Thu, 9 Apr 2020 08:36:15 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <fb149123516920dd5f5bf730a1da3a0cb9f3d25e.1586340235.git.ka-cheong.poon@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9586 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 impostorscore=0 malwarescore=0 lowpriorityscore=0 mlxlogscore=956
 priorityscore=1501 clxscore=1015 bulkscore=0 phishscore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004090118
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/8/20 3:21 AM, Ka-Cheong Poon wrote:
> And removed rds_mr_put().
> 
> Signed-off-by: Ka-Cheong Poon <ka-cheong.poon@oracle.com>
> ---
Fine by me.

Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
