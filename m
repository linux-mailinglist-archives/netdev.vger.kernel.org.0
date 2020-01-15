Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28F1713CF4F
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 22:44:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729281AbgAOVms (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 16:42:48 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:45630 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729072AbgAOVms (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 16:42:48 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00FLc6ju045653;
        Wed, 15 Jan 2020 21:42:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=X+BdY+ZvXwY4sT2jfUjoNYvr6QN5Xkt/+7r9D8c7/lk=;
 b=DeV0AhSP2798B5tV9r7l6ALIpEFwL2X7OR7TDQpXHHyoRYeRN4zZo7/oMWjnKgcFTvmA
 gf1aMwxgtrVjRdm7TUloFjuvoxzPEkbzN6YBP0uV56gWW5wxyoBmmycWHoefGrB0ImVS
 VQPUxYtezz98xdPR6AWXGIhT3vdSVMx+W1+rk6RDG7cxfHb+icQJrZYh+KEJKSxAarCV
 d9T3V+yE+sIhPaW8M+ty55eiWfQSa/+Mia4lr+2mvEGU9clelZB00ZKCT14lMY5FYyr6
 4n+XdFTno26XTHsRbGB0eVD0DU+t4lhmDutk1TLS25L9WZVJrh46vKJrHrPyWoTX1YW7 1A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2xf73txun8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jan 2020 21:42:28 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00FLcwF3072718;
        Wed, 15 Jan 2020 21:42:28 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2xj61kexgt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jan 2020 21:42:27 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00FLgQhF021025;
        Wed, 15 Jan 2020 21:42:26 GMT
Received: from [10.209.227.41] (/10.209.227.41)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jan 2020 13:42:26 -0800
Subject: Re: [PATCH mlx5-next 08/10] net/rds: Detect need of On-Demand-Paging
 memory registration
To:     Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Hans Westgaard Ry <hans.westgaard.ry@oracle.com>,
        Moni Shoua <monis@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
References: <20200115124340.79108-1-leon@kernel.org>
 <20200115124340.79108-9-leon@kernel.org>
From:   santosh.shilimkar@oracle.com
Organization: Oracle Corporation
Message-ID: <2460ddee-9731-c980-67ed-15b75431724d@oracle.com>
Date:   Wed, 15 Jan 2020 13:42:24 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200115124340.79108-9-leon@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001150163
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001150163
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/15/20 4:43 AM, Leon Romanovsky wrote:
> From: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
> 
> Add code to check if memory intended for RDMA is FS-DAX-memory. RDS
> will fail with error code EOPNOTSUPP if FS-DAX-memory is detected.
> 
> Signed-off-by: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> ---
Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
