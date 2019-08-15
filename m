Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 450728F046
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 18:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729507AbfHOQRT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 12:17:19 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:53238 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbfHOQRT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 12:17:19 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7FGDkNH184539;
        Thu, 15 Aug 2019 16:17:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=NOjRQtueLH+wB0SDJFQ328snNDvG5UALfu5tJlXrNJs=;
 b=RpQ4hzLEqE1RKInxgTXM3z/jq4zF3bE6rhfeI1gtZnl7qlT1s6NhMuRzmmG5XhyV4onX
 EuRx55dTyaZcNtydZnd/Qzuz7+xl0Fbuq68+o/yhwaZYqHxDuGT9bH6y++1G16Oj82ij
 s51Uvsq3fKvRdfDdX6ajStDeKgh1xx853tvzyOe8h90pDA0m8yCbERu40TEHxt7Tc99e
 809wCFWzG4XZ6JLJUyfhgCQ2rmaTO1vPK00FWTgH+lxBu+rkmCwSynlMk838vO89avde
 5zZpMm4rAkEkIqtAMDS6vjwizoKZPx7G1lxiIZ7Ru0UpQ9VvgjTmIMA4v3whBb/RPbEv rA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2u9pjqugkn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Aug 2019 16:17:17 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7FGDCoC094472;
        Thu, 15 Aug 2019 16:17:17 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 2ucgf16s59-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 15 Aug 2019 16:17:17 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x7FGF9aA103708;
        Thu, 15 Aug 2019 16:17:16 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2ucgf16s4w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Aug 2019 16:17:16 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7FGHGwc016818;
        Thu, 15 Aug 2019 16:17:16 GMT
Received: from [10.159.249.63] (/10.159.249.63)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 15 Aug 2019 09:17:15 -0700
Subject: Re: [PATCH net-next v2 2/4] RDS: don't use GFP_ATOMIC for sk_alloc in
 rds_create
To:     Gerd Rausch <gerd.rausch@oracle.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Cc:     David Miller <davem@davemloft.net>
References: <20190814.212525.326606319186601317.davem@davemloft.net>
 <cover.1565879451.git.gerd.rausch@oracle.com>
 <31c65073-0a9a-28b5-eb73-4ec784b0393e@oracle.com>
From:   santosh.shilimkar@oracle.com
Organization: Oracle Corporation
Message-ID: <349c267f-e610-e8b8-22c1-d98fcbf26c86@oracle.com>
Date:   Thu, 15 Aug 2019 09:17:14 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <31c65073-0a9a-28b5-eb73-4ec784b0393e@oracle.com>
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

On 8/15/19 7:42 AM, Gerd Rausch wrote:
> From: Chris Mason <chris.mason@oracle.com>
> Date: Fri, 3 Feb 2012 11:08:51 -0500
> 
> Signed-off-by: Chris Mason <chris.mason@oracle.com>
> Signed-off-by: Bang Nguyen <bang.nguyen@oracle.com>
> Signed-off-by: Gerd Rausch <gerd.rausch@oracle.com>
> Signed-off-by: Somasundaram Krishnasamy <somasundaram.krishnasamy@oracle.com>
> ---
Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
