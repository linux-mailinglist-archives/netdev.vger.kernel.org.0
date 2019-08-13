Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F2B38C426
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 00:14:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbfHMWOR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 18:14:17 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:49798 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726155AbfHMWOQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 18:14:16 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7DME3bO099553;
        Tue, 13 Aug 2019 22:14:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=1cvZ2M2R/wiS1U0tS0OOPhxFXdN5puJnYpi3g9w1MlA=;
 b=AOEJwTyjxuZ2jQsCIME0GlU2OKwkP4gFSqBAHlDFjQBv5p4SahInWn9BNpOE102zEQ7i
 SlA+Ruos6RsNNopbdsOFigVoC8plEBUYw7UQtmOttSYDxD8A9sgTbD0dsHqeupj4pbBl
 hGiA3Akx5vi/iOF32jx70bkI8GVN+3HCeYfsIBp6+fEgLLyMyJEABAyVjVi14293St+o
 8oxGfgsCRuQDKwJmdLk7NDOMoZrZA3z3PistRUpxO+w2CXVhWn1ePr0u5GowVEaFYIlC
 OkibIG1fJQZuqSHliXk7ZwxrwELeXsZ1sHYbbqew9F6oxCodyzuMJ35tkP5hmnz16ZiO Eg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2u9pjqgyqf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Aug 2019 22:14:14 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7DME4iJ180088;
        Tue, 13 Aug 2019 22:14:14 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 2ubwrrvcnx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 13 Aug 2019 22:14:14 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x7DM9JhW169757;
        Tue, 13 Aug 2019 22:09:19 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2ubwrrv7qn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Aug 2019 22:09:18 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7DM8BjR029783;
        Tue, 13 Aug 2019 22:08:11 GMT
Received: from [10.209.243.59] (/10.209.243.59)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 13 Aug 2019 15:08:11 -0700
Subject: Re: [PATCH net-next 2/5] RDS: limit the number of times we loop in
 rds_send_xmit
To:     Gerd Rausch <gerd.rausch@oracle.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Cc:     David Miller <davem@davemloft.net>
References: <4d04cec6-ef2d-392b-233b-0abf7a57fe44@oracle.com>
From:   santosh.shilimkar@oracle.com
Organization: Oracle Corporation
Message-ID: <d4100262-05d2-6fd2-c947-490e774c5edd@oracle.com>
Date:   Tue, 13 Aug 2019 15:08:11 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <4d04cec6-ef2d-392b-233b-0abf7a57fe44@oracle.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9348 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908130209
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/13/19 11:20 AM, Gerd Rausch wrote:
> From: Chris Mason <chris.mason@oracle.com>
> Date: Fri, 3 Feb 2012 11:07:54 -0500
> 
> This will kick the RDS worker thread if we have been looping
> too long.
> 
> Original commit from 2012 updated to include a change by
> Venkat Venkatsubra <venkat.x.venkatsubra@oracle.com>
> that triggers "must_wake" if "rds_ib_recv_refill_one" fails.
> 
> Signed-off-by: Gerd Rausch <gerd.rausch@oracle.com>
> ---
Acked-by: Santosh Shilimkar<santosh.shilimkar@oracle.com>

