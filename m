Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65328632D5
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 10:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbfGII1l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 04:27:41 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60338 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbfGII1l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 04:27:41 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x698NmVK027149;
        Tue, 9 Jul 2019 08:27:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=fH/kzJediWod/dQwr/fa5lFv7kcC+eV/vzioh80goZQ=;
 b=Ed2wH3fE0FJm/s6rj9gaiU0AGNoM2fILLifBsbxqlsasnf69ZJSeE+DAi/vShlv7XbeX
 BYPPm/R0BxFLRpE1mvweqzzqPv4rXqaoJ4Notimha0U6flDecUcpQv540dOkFE1jDNRP
 W/6qCbcNYkqyTO3i72XjwHeQ8YF+4DcaaHY5WaXa/9aBmkUA/tWr4IEhSIBTjncver5/
 bhDZBGC24h1fyroVjZH0f6REBm+WXzqerNufeEbPMrQqVDQ2VC+jJPEUBUehA4p79LC/
 hWdpdL1LIhff8ODaqfmUooEc3ldYaSvdLtCLdKtxXUaddUhu6zaACGaMU+8e+mIkAO4H WA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2tjk2tju46-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Jul 2019 08:27:33 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x698RXtA129391;
        Tue, 9 Jul 2019 08:27:33 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2tjjyknyk1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Jul 2019 08:27:32 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x698RVEP000985;
        Tue, 9 Jul 2019 08:27:31 GMT
Received: from [10.182.69.170] (/10.182.69.170)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 09 Jul 2019 01:27:31 -0700
Subject: Re: [PATCH 0/2] forcedeth: recv cache support
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
References: <1562307568-21549-1-git-send-email-yanjun.zhu@oracle.com>
 <20190708.152352.710464914281100209.davem@davemloft.net>
From:   Yanjun Zhu <yanjun.zhu@oracle.com>
Organization: Oracle Corporation
Message-ID: <6d0ef8b7-82c0-50db-913e-c021ae376c47@oracle.com>
Date:   Tue, 9 Jul 2019 16:28:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190708.152352.710464914281100209.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9312 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907090103
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9312 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907090102
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/7/9 6:23, David Miller wrote:
> From: Zhu Yanjun <yanjun.zhu@oracle.com>
> Date: Fri,  5 Jul 2019 02:19:26 -0400
>
>> This recv cache is to make NIC work steadily when the system memory is
>> not enough.
> The system is supposed to hold onto enough atomic memory to absorb all
> reasonable situations like this.
>
> If anything a solution to this problem belongs generically somewhere,
> not in a driver.  And furthermore looping over an allocation attempt
> with a delay is strongly discouraged.

Thanks a lot for your suggestions. Now a user is testing this patch in 
LAB and production hosts.

After this patch can pass tests, I will send V2 based on your suggestions.

Thanks,

Zhu Yanjun

