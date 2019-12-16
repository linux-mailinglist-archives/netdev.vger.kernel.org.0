Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91930121AF4
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 21:35:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbfLPUew (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 15:34:52 -0500
Received: from mx0b-00190b01.pphosted.com ([67.231.157.127]:18972 "EHLO
        mx0b-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726180AbfLPUew (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 15:34:52 -0500
Received: from pps.filterd (m0122330.ppops.net [127.0.0.1])
        by mx0b-00190b01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBGKWeUI011015;
        Mon, 16 Dec 2019 20:34:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=jan2016.eng;
 bh=fjxMblIMgaWpoTNZu7RDDqenQq8ReyxHTqBqSHCdl3M=;
 b=kkqZJ7KFRanbwXUVBh8f6ue6jQMcWwBd4/0DiQAjFVjxXO8FH9RVFY+b74yDKowHxxSf
 xoNqGbwAKCTxe5vlolCUx2vKIUXiHY3WQp/+vSX3yV+Icz5NefB27mbFtIvvMQcxdjZ1
 Bbyym/paY+GA3InkaffsmuzW/SYdQ5gUJN0g1NePHL/xBvAJv6eTuc0926/NlbZZcOQs
 1g4OQjND6tpjJnkKhkuQwpdVHosE+p0UsdYYNd1MEQLzDCoFsj8zJPYUG7nRsw7ytifu
 ug/GiK4tXDedanO9sAtgk/hi3qsmnvERC2RmlIuw5FB7m5A7S6plM4jDi+y5dd1i7qS4 AQ== 
Received: from prod-mail-ppoint3 (prod-mail-ppoint3.akamai.com [96.6.114.86] (may be forged))
        by mx0b-00190b01.pphosted.com with ESMTP id 2wvr918twx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Dec 2019 20:34:33 +0000
Received: from pps.filterd (prod-mail-ppoint3.akamai.com [127.0.0.1])
        by prod-mail-ppoint3.akamai.com (8.16.0.27/8.16.0.27) with SMTP id xBGKWNuC000455;
        Mon, 16 Dec 2019 15:34:32 -0500
Received: from prod-mail-relay15.akamai.com ([172.27.17.40])
        by prod-mail-ppoint3.akamai.com with ESMTP id 2wvuy0pmur-8;
        Mon, 16 Dec 2019 15:34:32 -0500
Received: from [0.0.0.0] (prod-ssh-gw02.sanmateo.corp.akamai.com [172.22.187.166])
        by prod-mail-relay15.akamai.com (Postfix) with ESMTP id 249AD20067;
        Mon, 16 Dec 2019 20:34:31 +0000 (GMT)
Subject: Re: crash in __xfrm_state_lookup on 4.19 LTS
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        Florian Westphal <fw@strlen.de>
Cc:     herbert@gondor.apana.org.au, David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
References: <0b3ab776-2b8b-1725-d36e-70af66c138da@akamai.com>
 <20191212132132.GL8621@gauss3.secunet.de>
 <c328f835-6eb7-3ab9-1f7c-dc565634f8bd@akamai.com>
 <20191213072144.GC26283@gauss3.secunet.de>
 <20191213102512.GP795@breakpoint.cc>
 <20191213111322.GE26283@gauss3.secunet.de>
From:   Josh Hunt <johunt@akamai.com>
Message-ID: <70a8c07d-effc-012d-5513-656e172e882e@akamai.com>
Date:   Mon, 16 Dec 2019 12:34:30 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191213111322.GE26283@gauss3.secunet.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-12-16_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912160172
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-16_07:2019-12-16,2019-12-16 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1011 mlxscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 spamscore=0 impostorscore=0
 bulkscore=0 lowpriorityscore=0 adultscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912160171
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/13/19 3:13 AM, Steffen Klassert wrote:
> On Fri, Dec 13, 2019 at 11:25:12AM +0100, Florian Westphal wrote:
>> Steffen Klassert <steffen.klassert@secunet.com> wrote:
>>>
>>> We destroy the states with a workqueue by doing schedule_work().
>>> I think we should better use call_rcu to make sure that a
>>> rcu grace period has elapsed before the states are destroyed.
>>
>> xfrm_state_gc_task calls synchronize_rcu after stealing the gc list and
>> before destroying those states, so I don't think this is a problem.
> 
> That's true, I've missed this. In that case, I don't
> have an idea what is the root cause of these crashes.
> We need to find a way to reproduce it.
> 

Thanks. I will try reproducing. Please let me know if you have any 
suggestions on how I may be able to trigger this behavior.

Josh
