Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F889BCBF3
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 17:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390477AbfIXP6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 11:58:20 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:42510 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388572AbfIXP6U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Sep 2019 11:58:20 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8OFmnRj145255;
        Tue, 24 Sep 2019 15:58:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=Bi6yhKEkRPnQu6adPrGafYo0isUF5tahIL8mwIDkCHE=;
 b=RUwj368vzNNc1GO1FiS2l0FdyL+OnxseANXVgD7LHwMf8pXf2eGy1quB9Ac0b7T/PDBa
 Kf3wxKmqWGGNE4xX6PfRhkZTz5cKaNf1yq98I4YGvW9UwtjJ9d/IDhaSGHEZfcnf7MTm
 avNcXuaMw1+vnjQWPds70RSOQYHp4DCwTynqjyb8Axci3Zl4e5YThcSquwPaYit3X1Xz
 nhc+uNSURD/qUwGAKo1WQEbVo+jq6CoWCtnk+a8kLErvrYtR0MhbXdFiMwQVsC+9NNYh
 3JmvrHBoPNi7qxEBZ8GL+jmVoyetHZ8dh9VG88kk0VzFxNgnZIYX0iMMQdoAtJKcTBPx yg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2v5btpy4rf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Sep 2019 15:58:13 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8OFlfQQ018523;
        Tue, 24 Sep 2019 15:58:13 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 2v6yvksq8b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 24 Sep 2019 15:58:13 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x8OFwCNL051205;
        Tue, 24 Sep 2019 15:58:12 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2v6yvksq7a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Sep 2019 15:58:12 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8OFwBum012884;
        Tue, 24 Sep 2019 15:58:11 GMT
Received: from [10.159.211.29] (/10.159.211.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 24 Sep 2019 08:58:11 -0700
Subject: Re: [PATCH net] net/rds: Check laddr_check before calling it
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, santosh.shilimkar@oracle.com,
        davem@davemloft.net, rds-devel@oss.oracle.com
References: <1568734158-18021-1-git-send-email-ka-cheong.poon@oracle.com>
 <20190920180959.7920f2c3@cakuba.netronome.com>
From:   Ka-Cheong Poon <ka-cheong.poon@oracle.com>
Organization: Oracle Corporation
Message-ID: <9f6506cf-87e1-0ef2-f7d6-28291e71c753@oracle.com>
Date:   Tue, 24 Sep 2019 23:58:03 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190920180959.7920f2c3@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9390 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909240147
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/21/19 9:09 AM, Jakub Kicinski wrote:
> On Tue, 17 Sep 2019 08:29:18 -0700, Ka-Cheong Poon wrote:
>> In rds_bind(), laddr_check is called without checking if it is NULL or
>> not.  And rs_transport should be reset if rds_add_bound() fails.
>>
>> Reported-by: syzbot+fae39afd2101a17ec624@syzkaller.appspotmail.com
>> Signed-off-by: Ka-Cheong Poon <ka-cheong.poon@oracle.com>
> 
> Looks good, but could you please provide a fixes tag?


Done.  Thanks.


-- 
K. Poon
ka-cheong.poon@oracle.com


