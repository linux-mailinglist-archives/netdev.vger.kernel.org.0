Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A49041F9E0A
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 19:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731162AbgFOREq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 13:04:46 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:38178 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729682AbgFOREq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 13:04:46 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05FGffsm068552;
        Mon, 15 Jun 2020 17:04:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=RorxhkmOKCsfsY01NeFt6tadNz59t9lYpIJNAneHnEk=;
 b=tIWzSLG9ClA+L+yVU2TzNQejva2un6mptJOOLG+LLJO9dJ6oXeqfZhsRk81TOE4U8h7v
 kkj4MRxUrDQoDrRumJGlUSMsoxagSdNU7b6yyLKhXzTqxso3RmgalQf8C0ktCxTvlpAo
 CFEP8DEprpNA402f7R5bPcOMlKhcqofOJallzHxdI67PMUifXHmjHQluosT2qjSt51p/
 S4mLwB9U6opcnL83e4iImPymSq5lKn0HTGxXQ93Pt7a3tm3/oPeonV7SUfHP232SaDuK
 tBBEkLP9U5MeC+F2baZ20+PABLK8fPQwVuiEH/3rn/LXqCeNtiMFSBPWTB8RfAS0YTxb 1A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 31p6s223qp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 15 Jun 2020 17:04:40 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05FGi435112454;
        Mon, 15 Jun 2020 17:04:40 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 31p6s5q5qw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Jun 2020 17:04:40 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05FH4d2P015098;
        Mon, 15 Jun 2020 17:04:39 GMT
Received: from [10.74.110.250] (/10.74.110.250)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 15 Jun 2020 10:04:39 -0700
Subject: Re: [PATCH net] net/rds: NULL pointer de-reference in
 rds_ib_add_one()
To:     Ka-Cheong Poon <ka-cheong.poon@oracle.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net
References: <1592206825-3303-1-git-send-email-ka-cheong.poon@oracle.com>
From:   santosh.shilimkar@oracle.com
Organization: Oracle Corporation
Message-ID: <8a5afede-6499-8a8d-f5bf-6ba9d0b74801@oracle.com>
Date:   Mon, 15 Jun 2020 10:04:38 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <1592206825-3303-1-git-send-email-ka-cheong.poon@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9653 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 bulkscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006150128
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9653 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 clxscore=1015 mlxscore=0 mlxlogscore=999 priorityscore=1501 phishscore=0
 malwarescore=0 suspectscore=0 spamscore=0 cotscore=-2147483648 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006150128
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/15/20 12:40 AM, Ka-Cheong Poon wrote:
> The parent field of a struct device may be NULL.  The macro
> ibdev_to_node() should check for that.
> 
> Signed-off-by: Ka-Cheong Poon <ka-cheong.poon@oracle.com>
> ---
Looks good.
Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
