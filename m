Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 513CD8C41B
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 00:09:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727176AbfHMWJ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 18:09:29 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:58922 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726260AbfHMWJ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 18:09:29 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7DM9HqV083248;
        Tue, 13 Aug 2019 22:09:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=tC9u5qJHtFhf0lf45slTxk0dLmE4KSIP48d+58wN1PU=;
 b=DsIlBPFyyWXprO8BtTWEsXPr8jc/BxbWqPbJrLy79dGVohHITpDgeVBXgTLPZeFuUqOj
 7XzNDVgkLL5uX/eVG7q73sWz2zpE3wbKxp5XlcOGj1qjowcSkHHiwskpcYdIrTdOewhe
 7kvJuTZ3C6uCQ/e4wjohU5sDMw10Wz7SrgBLQVuWidob5UCB5j6cRusIHe6XGnU9dwWD
 zOP2sfTaVaPoGRWRgtVHekIKv72wUA1QSfok9wO3EWkGkNmfXIRPB+RyPI6z4E40eoNh
 MNK4kCPaAF7QqZFdckJbU1VUKxU+fGm3lNCOjEW6DC7Fpf5AXSX1JPIIIJUA1k20jrvr PQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2u9nbth3jb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Aug 2019 22:09:26 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7DM9HYn169467;
        Tue, 13 Aug 2019 22:09:26 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 2ubwrrv8e7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 13 Aug 2019 22:09:26 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x7DM9QfS170572;
        Tue, 13 Aug 2019 22:09:26 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2ubwrrv8ct-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Aug 2019 22:09:26 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7DM8imr029957;
        Tue, 13 Aug 2019 22:08:44 GMT
Received: from [10.209.243.59] (/10.209.243.59)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 13 Aug 2019 15:08:44 -0700
Subject: Re: [PATCH net-next 3/5] RDS: don't use GFP_ATOMIC for sk_alloc in
 rds_create
To:     Gerd Rausch <gerd.rausch@oracle.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Cc:     David Miller <davem@davemloft.net>
References: <14aa4df7-3b7d-157d-1e9a-9c49ff5feb3b@oracle.com>
From:   santosh.shilimkar@oracle.com
Organization: Oracle Corporation
Message-ID: <2d29482f-4263-2106-5faa-c60e36b181fc@oracle.com>
Date:   Tue, 13 Aug 2019 15:08:44 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <14aa4df7-3b7d-157d-1e9a-9c49ff5feb3b@oracle.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9348 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908130208
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/13/19 11:21 AM, Gerd Rausch wrote:
> From: Chris Mason <chris.mason@oracle.com>
> Date: Fri, 3 Feb 2012 11:08:51 -0500
> 
> Signed-off-by: Chris Mason <chris.mason@oracle.com>
> Signed-off-by: Bang Nguyen <bang.nguyen@oracle.com>
> Signed-off-by: Gerd Rausch <gerd.rausch@oracle.com>
> Signed-off-by: Somasundaram Krishnasamy <somasundaram.krishnasamy@oracle.com>
> ---Acked-by: Santosh Shilimkar<santosh.shilimkar@oracle.com>

