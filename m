Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C752A8C41D
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 00:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727038AbfHMWJ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 18:09:58 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:44048 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbfHMWJ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 18:09:58 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7DM9Jwp095375;
        Tue, 13 Aug 2019 22:09:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=9NU5DO/VglS7CRWCb9hpCu+wAPF5mhv8jDQZ7zt45VA=;
 b=OgIagNpDA5Iul+WHWZOfJ4JFPzMMC7zpj7oI8lFXADI2RtwwOGpij6269fk3O5bJiG7w
 lCUCJ2qs3jQzvSmPNiihGouj/dxRe9Wb9UCGuXHuRPdp1cak3fa0aL+dQUmVyu+y8JbZ
 f9FunpK8WoJtrYqB81hfP44bHgwaz+3jygyyHEcddbghZSNKVsUMmGTBYuEgHnKr8vAP
 AWGszhQx2I4no9vtjoEMI4620syc5ns9HKKrYspxP9lnCjtVEDH3FJUo/A8rxAK+3y1c
 O+JOZ4mqxkyFh+Z4QUEoovzb7MkMr8wJMdX5Z8XuH2E/lUGgmqyf61PhDziYHCtcTsmo Pg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2u9pjqgy9d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Aug 2019 22:09:56 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7DM8Fhq053850;
        Tue, 13 Aug 2019 22:09:55 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 2ubwcx9upa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 13 Aug 2019 22:09:55 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x7DM9tak056567;
        Tue, 13 Aug 2019 22:09:55 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2ubwcx9up6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Aug 2019 22:09:55 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7DM9sdL002559;
        Tue, 13 Aug 2019 22:09:54 GMT
Received: from [10.209.243.59] (/10.209.243.59)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 13 Aug 2019 15:09:54 -0700
Subject: Re: [PATCH net-next 5/5] rds: check for excessive looping in
 rds_send_xmit
To:     Gerd Rausch <gerd.rausch@oracle.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Cc:     David Miller <davem@davemloft.net>
References: <333232d5-311d-ba38-c906-540ef792ab77@oracle.com>
From:   santosh.shilimkar@oracle.com
Organization: Oracle Corporation
Message-ID: <2025f346-c44a-619d-cc69-b09744b4603d@oracle.com>
Date:   Tue, 13 Aug 2019 15:09:54 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <333232d5-311d-ba38-c906-540ef792ab77@oracle.com>
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
> From: Andy Grover <andy.grover@oracle.com>
> Date: Thu, 13 Jan 2011 11:40:31 -0800
> 
> Original commit from 2011 updated to include a change by
> Yuval Shaia <yuval.shaia@oracle.com>
> that adds a new statistic counter "send_stuck_rm"
> to capture the messages looping exessively
> in the send path.
>
You need Andy's SOB as well.

> Signed-off-by: Gerd Rausch <gerd.rausch@oracle.com>
Other than that,
Acked-by: Santosh Shilimkar<santosh.shilimkar@oracle.com>

