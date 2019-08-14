Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2A708E01F
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 23:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728670AbfHNVpq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 17:45:46 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51106 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725895AbfHNVpp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 17:45:45 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7ELj51X122453;
        Wed, 14 Aug 2019 21:45:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=B4Da2nkSffajRM7h01NI7kEG5zyn6tasslE+L1S5nWQ=;
 b=QQPrm+wqx00PpiieOnWAW1L7QW40oDLpcIE3Er4FnM1AK8kYhOIblAgQY3708GSDssCW
 tFDfM9UYaXnKLPNoUzZlyLRh+tFJWG9AGD9KgammnIuy5qbi/H37rzCPvdtIQYaqFdv3
 VEJubnWBtRzDeUblZwmYeFipNEyrow6AsXX5fdLlpRSVKPhbT8+NAR9S4xA3xxj29aGc
 cgckhV8Qcer5dFaEfESrsoiMn7hJKW4xjHP0R8sCxrQxlXCcZ4moLvBxQmXF+UwPbeXh
 agA9SeFR2gaxbGe5UWypzdi+ST+0i0qWLwE9lX9P/+qZwlsLDOUIP/NA8mNaWshFL0ZM Ig== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2u9nvpfh62-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Aug 2019 21:45:26 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7ELgmoY159092;
        Wed, 14 Aug 2019 21:45:25 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 2ucmwhxctu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 14 Aug 2019 21:45:25 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x7ELjPuS166195;
        Wed, 14 Aug 2019 21:45:25 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2ucmwhxctq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Aug 2019 21:45:25 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7ELjOqO030679;
        Wed, 14 Aug 2019 21:45:24 GMT
Received: from [10.211.54.53] (/10.211.54.53)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 14 Aug 2019 14:45:24 -0700
Subject: Re: [PATCH net-next 1/5] RDS: Re-add pf/sol access via sysctl
To:     David Miller <davem@davemloft.net>, santosh.shilimkar@oracle.com
Cc:     dledford@redhat.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
References: <a7d09f3a-d01e-7cdb-98ec-8165b6312ffe@oracle.com>
 <20190814.142112.1080694155114782651.davem@davemloft.net>
 <53a6feaf-b48e-aadf-1bd7-4c82ddc36d1e@oracle.com>
 <20190814.143141.178107876214573923.davem@davemloft.net>
From:   Gerd Rausch <gerd.rausch@oracle.com>
Message-ID: <1c6d1f04-96d5-94e5-3140-d3da194e14f3@oracle.com>
Date:   Wed, 14 Aug 2019 14:45:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190814.143141.178107876214573923.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9349 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908140197
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

On 14/08/2019 14.31, David Miller wrote:
> From: santosh.shilimkar@oracle.com
> Date: Wed, 14 Aug 2019 11:36:19 -0700
> 
>> On 8/14/19 11:21 AM, David Miller wrote:
>>> From: santosh.shilimkar@oracle.com
>>> Date: Wed, 14 Aug 2019 11:01:36 -0700
>>>
>>>> Some of the application software was released before 2009 and ended up
>>>> using these proc entries from downstream kernel. The newer lib/app
>>>> using RDS don't use these. Unfortunately lot of customer still use
>>>> Oracle 9, 10, 11 which were released before 2007 and run these apps
>>>> on modern kernels.
>>> So those apps are using proc entries that were never upstream...
>>>
>>> Sorry, this is completely and utterly inappropriate.
>>>
>> Agree. Unfortunately one of the legacy application library didn't
>> get upgraded even after the ports were registered with IANA.
>> Oracle 11 is still very active release and hence this patch.
>>
>> It is fine to drop $subject patch from this series.
> 
> The appropriate procedure is to resubmit the series with the patch
> removed.
> 

For my understanding:
Are you saying that...

a) It is utterly inappropriate to have Oracle applications
   rely on a /proc/sys API that was kept out of Upstream-Linux
   for this long

b) It is utterly inappropriate to include such a /proc/sys API
   that Oracle applications have depended on this late

c) ... something else ...

At first I read your comment as "a)", which would then imply
that this commit shall be included now (albeit late).

If your answer is "not a)", or implies that Oracle ought to continue
to carry this change in our own repository only, please let me know,
and I will re-submit the series without this patch, to follow
appropriate procedure.

Thanks,

  Gerd
