Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1257CB5191
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 17:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729646AbfIQPbj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 11:31:39 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:43748 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729417AbfIQPbj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Sep 2019 11:31:39 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8HFOnjm117547;
        Tue, 17 Sep 2019 15:31:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=W4Az2p2dxEJ89GRvi/OjHMK01YSyOZyU6zb2KW+gRy8=;
 b=SXKBHUQi9gFCBnHpAEQdZBKBCDm/Wpl+UWA2gMMPGlD/dNIhKmyQIhmoAmsxGboAr3mF
 INu72iMBPiWhDOKmuCdhoFVkJ+NBzwQeW3yb4QkdzDAZeLOoy2zXHJHF1h4/h3BmkMsa
 wJdTsNrPKqEA6mP4tY8WCU9M6i7OImWTCOaPWuxsk5kB0y7ryt1nzd3FcSJhazYnmnWD
 Cn8Q8pr+u/fuYE/2CtuQ5OKrMPjhMvWGep0nPcP2UpfAR+CHqdEYNWgKFVpx4okTD2y2
 epiOED6GUikA4Kv2td1YlqVY0jOa4ABd67UBCSAF9yVdGCF/9HV+Zs6QDMcUhwbJJlhg kQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2v0r5pfap0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Sep 2019 15:31:35 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8HFOLwA056940;
        Tue, 17 Sep 2019 15:31:34 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 2v2jxhpv4b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 17 Sep 2019 15:31:34 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x8HFVXpO080646;
        Tue, 17 Sep 2019 15:31:33 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2v2jxhpv3p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Sep 2019 15:31:33 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8HFVW83019606;
        Tue, 17 Sep 2019 15:31:32 GMT
Received: from [10.159.231.82] (/10.159.231.82)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 17 Sep 2019 08:31:32 -0700
Subject: Re: [PATCH net] net/rds: Check laddr_check before calling it
To:     Ka-Cheong Poon <ka-cheong.poon@oracle.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        rds-devel@oss.oracle.com
References: <1568734158-18021-1-git-send-email-ka-cheong.poon@oracle.com>
From:   santosh.shilimkar@oracle.com
Organization: Oracle Corporation
Message-ID: <f711ccb8-4f2d-0802-e313-2619ef5d5e56@oracle.com>
Date:   Tue, 17 Sep 2019 08:31:25 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1568734158-18021-1-git-send-email-ka-cheong.poon@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9383 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909170149
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/17/19 8:29 AM, Ka-Cheong Poon wrote:
> In rds_bind(), laddr_check is called without checking if it is NULL or
> not.  And rs_transport should be reset if rds_add_bound() fails.
> 
> Reported-by: syzbot+fae39afd2101a17ec624@syzkaller.appspotmail.com
> Signed-off-by: Ka-Cheong Poon <ka-cheong.poon@oracle.com>
> ---
Thanks Ka-Cheong for getting this out quickly on list.

Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>

