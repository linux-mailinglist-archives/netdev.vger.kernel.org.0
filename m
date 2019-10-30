Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59A3CE95C0
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 05:24:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727330AbfJ3EYh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 00:24:37 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:49594 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727207AbfJ3EYh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 00:24:37 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9U4OHKk022536;
        Wed, 30 Oct 2019 04:24:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=1OXWi7rMP6CXZjBJkMI2XWT2DPIklyN6mDabCZbYYzU=;
 b=DNpAlHIb8KFuVdOcTIHoOKgwhUqt7z/9zRPcyO8IL5y5qCFdOsiwDicvUtB4C20F5d1g
 fYuPZcOQmz6Iqk3aHt6yF9JDeAhH6IHDs40lrgVeul2O2WPoboFolauMionTD4BLaLpl
 38SuYMtxOHMxQ4km0BD8+IhmLYSNpd+Vw4jlbV98xkNAKOU1BdLwVQOg4ElUDl11qX5P
 fBBH2Jrtym/WqdgRO35czrJsM8Lp8tpbtEi7JVyer5RwiozdXifrOYeWdaWU+HYlX+U0
 wepNZjwG2HmcIuJbMnwixClXjyXF38aEDDbo8m40B3rhiO0dicYwNMDxizxfIPMADh8g tA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2vxwhfh97e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Oct 2019 04:24:32 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9U4OOCD019571;
        Wed, 30 Oct 2019 04:24:32 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2vxwj8g2sb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Oct 2019 04:24:30 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9U4OKQR030179;
        Wed, 30 Oct 2019 04:24:20 GMT
Received: from [10.182.71.192] (/10.182.71.192)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 29 Oct 2019 21:24:20 -0700
Subject: Re: [PATCHv3 1/1] net: forcedeth: add xmit_more support
To:     David Miller <davem@davemloft.net>
Cc:     jakub.kicinski@netronome.com, rain.1986.08.12@gmail.com,
        netdev@vger.kernel.org
References: <1572319812-27196-1-git-send-email-yanjun.zhu@oracle.com>
 <20191029103244.3139a6aa@cakuba.hsd1.ca.comcast.net>
 <068ef3ce-eb72-b5db-1845-1350dfad3019@oracle.com>
 <20191029.211407.790828950610293560.davem@davemloft.net>
From:   Zhu Yanjun <yanjun.zhu@oracle.com>
Organization: Oracle Corporation
Message-ID: <434f2be9-0ab5-4a02-d1ff-5cc969addf49@oracle.com>
Date:   Wed, 30 Oct 2019 12:30:40 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191029.211407.790828950610293560.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9425 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910300044
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9425 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910300044
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/10/30 12:14, David Miller wrote:
> From: Zhu Yanjun <yanjun.zhu@oracle.com>
> Date: Wed, 30 Oct 2019 12:18:43 +0800
>
>> If igb does not handle DMA error, it is not appropriate for us to
>> handle DMA error.
>>
>> After igb fixes this DMA error, I will follow.;-)
> Sorry, this is an invalid and unaceptable argument.
>
> Just because a bug exists in another driver, does not mean you
> can copy that bug into your driver.
>
> Fix the check, do things properly, and resubmit your patch only after

OK. I will follow the advice from you and Jakub.

After this DMA error is handled, I will resubmit the commit again.

Thanks,

Zhu Yanjun

> you've done that.
>
> Thank you.
>
