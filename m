Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEF60A9883
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 04:44:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730839AbfIECoE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 22:44:04 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:39072 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727156AbfIECoE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 22:44:04 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x852h8R7003217;
        Thu, 5 Sep 2019 02:43:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=OZ0c+S2P5hj3a3wUlf3McE3RuiDjDhhwiPR/BVKDilA=;
 b=F//oYASla9pMm+dIQMtIMXhNzH9y36u3u6S4XFMjzlTCFe7Lb4Ex42AKQ+3pgCniX4x2
 g2+pytD96yVxDq8FnJ+q2nTr2SyBxkN6PwMlTy6A2fTnfDN9Y2eOeUJJrrztp4Wc2vUr
 gyE3QCwAzIwEtmdKf/ha6neGqH38vQdjwUtoHyhyMWfzCBrThuj0j+PwABngHQd8KzJ3
 U7vY51aV4gqJzdlzzz1ZvHmisuQrRj5MNxg893+hdRiFxgv5JouHG5x7Qjyz46Kz5PC6
 5urMnhHMbPt3172Q9gxtGzRpPVNy0Vh16Er2UfC18JamZrj+369RHhEubbz3H0oILxjV qw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2utsth8068-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Sep 2019 02:43:55 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x852hd5n027322;
        Thu, 5 Sep 2019 02:43:55 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2ut1hpfr6x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Sep 2019 02:43:55 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x852hrU8009531;
        Thu, 5 Sep 2019 02:43:54 GMT
Received: from [10.182.71.192] (/10.182.71.192)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 04 Sep 2019 19:43:53 -0700
Subject: Re: [PATCHv2 1/1] forcedeth: use per cpu to collect xmit/recv
 statistics
To:     David Miller <davem@davemloft.net>
Cc:     eric.dumazet@gmail.com, netdev@vger.kernel.org
References: <1567322773-5183-1-git-send-email-yanjun.zhu@oracle.com>
 <1567322773-5183-2-git-send-email-yanjun.zhu@oracle.com>
 <20190904.152218.250246841354408872.davem@davemloft.net>
From:   Zhu Yanjun <yanjun.zhu@oracle.com>
Organization: Oracle Corporation
Message-ID: <70ae3f79-0c57-97d4-ebec-1378782605c8@oracle.com>
Date:   Thu, 5 Sep 2019 10:48:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190904.152218.250246841354408872.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9370 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=818
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909050029
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9370 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=884 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909050028
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/9/5 6:22, David Miller wrote:
> From: Zhu Yanjun <yanjun.zhu@oracle.com>
> Date: Sun,  1 Sep 2019 03:26:13 -0400
>
>> +static inline void nv_get_stats(int cpu, struct fe_priv *np,
>> +				struct rtnl_link_stats64 *storage)
>   ...
>> +static inline void rx_missing_handler(u32 flags, struct fe_priv *np)
>> +{
> Never use the inline keyword in foo.c files, let the compiler decide.

Thanks a lot for your advice. I will pay attention to the usage of 
inline in the

source code.

If you agree, I will send V3 about this soon.

Zhu Yanjun

>
