Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A8B717DC97
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 10:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbgCIJkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 05:40:25 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:40756 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726402AbgCIJkZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 05:40:25 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0299d6HI124649
        for <netdev@vger.kernel.org>; Mon, 9 Mar 2020 05:40:24 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ym91dp8g2-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 09 Mar 2020 05:40:24 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <kgraul@linux.ibm.com>;
        Mon, 9 Mar 2020 09:40:21 -0000
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 9 Mar 2020 09:40:18 -0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0299eHPK36438224
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 Mar 2020 09:40:17 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1C1834C064;
        Mon,  9 Mar 2020 09:40:17 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B27B54C052;
        Mon,  9 Mar 2020 09:40:16 +0000 (GMT)
Received: from [9.145.22.88] (unknown [9.145.22.88])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  9 Mar 2020 09:40:16 +0000 (GMT)
Subject: Re: [PATCH net] net/smc: cancel event worker during device removal
To:     Leon Romanovsky <leon@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, heiko.carstens@de.ibm.com,
        raspl@linux.ibm.com, ubraun@linux.ibm.com
References: <20200306134518.84416-1-kgraul@linux.ibm.com>
 <20200308150107.GC11496@unreal>
 <0b5d992d-2447-1606-f8ce-73801643160a@linux.ibm.com>
 <20200309080439.GJ11496@unreal>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
Date:   Mon, 9 Mar 2020 10:40:16 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200309080439.GJ11496@unreal>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 20030909-0016-0000-0000-000002EE8613
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20030909-0017-0000-0000-00003351E4B2
Message-Id: <49a3e4fc-66c3-e658-c95f-6651c4336510@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-09_02:2020-03-06,2020-03-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 clxscore=1015 phishscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0
 adultscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003090069
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/03/2020 09:04, Leon Romanovsky wrote:
> On Sun, Mar 08, 2020 at 08:59:33PM +0100, Karsten Graul wrote:
>> On 08/03/2020 16:01, Leon Romanovsky wrote:
>>> On Fri, Mar 06, 2020 at 02:45:18PM +0100, Karsten Graul wrote:
>>>> During IB device removal, cancel the event worker before the device
>>>> structure is freed. In the worker, check if the device is being
>>>> terminated and do not proceed with the event work in that case.
>>>>
>>>> Fixes: a4cf0443c414 ("smc: introduce SMC as an IB-client")
>>>> Reported-by: syzbot+b297c6825752e7a07272@syzkaller.appspotmail.com
>>>> Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
>>>> Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
>>>> ---
>>>>  net/smc/smc_ib.c | 4 ++++
>>>>  1 file changed, 4 insertions(+)
>>>>
>>>> diff --git a/net/smc/smc_ib.c b/net/smc/smc_ib.c
>>>> index d6ba186f67e2..5e4e64a9aa4b 100644
>>>> --- a/net/smc/smc_ib.c
>>>> +++ b/net/smc/smc_ib.c
>>>> @@ -240,6 +240,9 @@ static void smc_ib_port_event_work(struct work_struct *work)
>>>>  		work, struct smc_ib_device, port_event_work);
>>>>  	u8 port_idx;
>>>>
>>>> +	if (list_empty(&smcibdev->list))
>>>> +		return;
>>>> +
>>>
>>> How can it be true if you are not holding "smc_ib_devices.lock" during
>>> execution of smc_ib_port_event_work()?
>>>
>>
>> It is true when smc_ib_remove_dev() runs before the work actually started.
>> Other than that its only a shortcut to return earlier, when the item is
>> removed from the list after the check then the processing just takes a
>> little bit longer...its still save.
> 
> The check itself maybe safe, but it can't fix syzkaller bug reported above.
> As you said, the smc_ib_remove_dev() can be called immediately after
> your list_empty() check and we return to original behavior.
> 
> The correct design will be to ensure that smc_ib_port_event_work() is
> executed only smcibdev->list is not empty.
> 
> Thanks
> 

The fix I had in mind was the

	cancel_work_sync(&smcibdev->port_event_work);

to wait for a running port_event_work to finish before smcibdev is freed.
I can remove the list_empty() check if that is too confusing.

>>
>>>>  	for_each_set_bit(port_idx, &smcibdev->port_event_mask, SMC_MAX_PORTS) {
>>>>  		smc_ib_remember_port_attr(smcibdev, port_idx + 1);
>>>>  		clear_bit(port_idx, &smcibdev->port_event_mask);
>>>> @@ -582,6 +585,7 @@ static void smc_ib_remove_dev(struct ib_device *ibdev, void *client_data)
>>>>  	smc_smcr_terminate_all(smcibdev);
>>>>  	smc_ib_cleanup_per_ibdev(smcibdev);
>>>>  	ib_unregister_event_handler(&smcibdev->event_handler);
>>>> +	cancel_work_sync(&smcibdev->port_event_work);
>>>>  	kfree(smcibdev);
>>>>  }
>>>>
>>>> --
>>>> 2.17.1
>>>>
>>
>> --
>> Karsten
>>
>> (I'm a dude)
>>

-- 
Karsten

(I'm a dude)

