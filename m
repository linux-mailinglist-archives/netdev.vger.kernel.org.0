Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DB2E69A5A8
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 07:37:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbjBQGhW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 01:37:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbjBQGhV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 01:37:21 -0500
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A95984DE3D
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 22:37:19 -0800 (PST)
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31H4pNlw028886;
        Fri, 17 Feb 2023 06:37:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=8oQ/pIzHzLNSzJqG/bCNkNUm13LoPoZsspqL2yviiGE=;
 b=dt8/0+fFCRiMqO+1vSw0eEB//UR2jxzpbbXvzbkSfPeNzp3Twh2/1XCeSRtm72pWU7S+
 29hWh/32McgpGfQRPOLLdwkQuGNV0jgN+GFFUgsLQwXPqekXNatkyNMnU5br0tW2ReSO
 CsGnr5CnMlcOBKcq6h7oXHhOTvSfkizHRQW3PpMPUFUcaqvw5gG43HdsclANzgKNSAvC
 73tyQNfdXwSYD2bgMoKMS7LR5Bz8TXZM7gN7VmcsEuy1w89ZkjwlENwMLH51+JErddEL
 xo86IUgQrLlsx2mozXksmgtRY9/Xqy7CD51vT3ipv5ms3vzkRgJHKGgbjDLhTff4LHMa GA== 
Received: from nalasppmta05.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3nshe5k0st-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Feb 2023 06:37:12 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA05.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 31H6bBjD020718
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Feb 2023 06:37:11 GMT
Received: from [10.232.65.248] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 16 Feb
 2023 22:37:09 -0800
Message-ID: <545aabc7-ac90-a80a-375a-1f513f2b677a@quicinc.com>
Date:   Fri, 17 Feb 2023 14:36:46 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.3
Subject: Re: [PATCH] net: disable irq in napi_poll
To:     Eric Dumazet <edumazet@google.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>
References: <20230215072046.4000-1-quic_yingangl@quicinc.com>
 <CANn89iJoYenZeBXRkRKLyDHgUW3XqDHNx3Hfg6Q5Lsj6DQ_g_A@mail.gmail.com>
Content-Language: en-US
From:   Kassey Li <quic_yingangl@quicinc.com>
In-Reply-To: <CANn89iJoYenZeBXRkRKLyDHgUW3XqDHNx3Hfg6Q5Lsj6DQ_g_A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: Ge3fTy9YVXzDvtu0strsAdFWIoRKka8N
X-Proofpoint-ORIG-GUID: Ge3fTy9YVXzDvtu0strsAdFWIoRKka8N
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-17_02,2023-02-16_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=2 malwarescore=0 adultscore=0
 phishscore=0 clxscore=1015 priorityscore=1501 bulkscore=0 impostorscore=0
 mlxlogscore=167 spamscore=2 mlxscore=2 lowpriorityscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302170058
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/15/2023 4:32 PM, Eric Dumazet wrote:
> On Wed, Feb 15, 2023 at 8:20 AM Kassey Li <quic_yingangl@quicinc.com> wrote:
>>
>> There is list_del action in napi_poll, fix race condition by
>> disable irq.
>>
>> similar report:
>> https://syzkaller.appspot.com/bug?id=309955e7f02812d7bfb828c22b517349d9f068
>> bc
>>
>> list_del corruption. next->prev should be ffffff88ea0bd4c0, but was
>> ffffff8a787099c0
>> ------------[ cut here ]------------
>> kernel BUG at lib/list_debug.c:56!
>>
>> pstate: 62400005 (nZCv daif +PAN -UAO +TCO -DIT -SSBS BTYPE=--)
>> pc : __list_del_entry_valid+0xa8/0xac
>> lr : __list_del_entry_valid+0xa8/0xac
>> sp : ffffffc0081bbce0
>> x29: ffffffc0081bbce0 x28: 0000000000000018 x27: 0000000000000059
>> x26: ffffffef130c6040 x25: ffffffc0081bbcf0 x24: ffffffc0081bbd00
>> x23: 000000010003d37f x22: 000000000000012c x21: ffffffef130c9000
>> x20: ffffff8a786cf9c0 x19: ffffff88ea0bd4c0 x18: ffffffc00816d030
>> x17: ffffffffffffffff x16: 0000000000000004 x15: 0000000000000004
>> x14: ffffffef131bae30 x13: 0000000000002b84 x12: 0000000000000003
>> x11: 0000000100002b84 x10: c000000100002b84 x9 : 1f2ede939758e700
>> x8 : 1f2ede939758e700 x7 : 205b5d3330383232 x6 : 302e33303331205b
>> x5 : ffffffef13750358 x4 : ffffffc0081bb9df x3 : 0000000000000000
>> x2 : ffffff8a786be9c8 x1 : 0000000000000000 x0 : 000000000000007c
>>
>> Call trace:
>> __list_del_entry_valid+0xa8/0xac
>> net_rx_action+0xfc/0x3a0
>> _stext+0x174/0x5f4
>> run_ksoftirqd+0x34/0x74
>> smpboot_thread_fn+0x1d8/0x464
>> kthread+0x168/0x1dc
>> ret_from_fork+0x10/0x20
>> Code: d4210000 f000cbc0 91161000 97de537a (d4210000)
>> ---[ end trace 8b3858d55ee59b7c ]---
>> Kernel panic - not syncing: Oops - BUG: Fatal exception in interrupt
>>
>> Signed-off-by: Kassey Li <quic_yingangl@quicinc.com>
> 
> No tags ?
   hi Eric, can you share a example of "tags" ?  sorry I'm not aware of 
this.
> 
>> ---
>>   net/core/dev.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/net/core/dev.c b/net/core/dev.c
>> index b76fb37b381e..0c677a563232 100644
>> --- a/net/core/dev.c
>> +++ b/net/core/dev.c
>> @@ -6660,7 +6660,9 @@ static __latent_entropy void net_rx_action(struct softirq_action *h)
>>                  }
>>
>>                  n = list_first_entry(&list, struct napi_struct, poll_list);
>> +               local_irq_disable();
>>                  budget -= napi_poll(n, &repoll);
>> +               local_irq_enable();
>>
>>                  /* If softirq window is exhausted then punt.
>>                   * Allow this to run for 2 jiffies since which will allow
>> --
>> 2.17.1
>>
> 
> Absolutely not.
> 
> NAPI runs in softirq mode, not hard irq.
> 
> You will have to spend more time finding the real bug.

   without this patch, issue is easy to reproduced when do phone clone( 
a new phone and old phone to clone data/app).
   with this path, issue is not seen.

   in the function of net_rx_action, list init/add is go with 
local_irq_disable/enable, however, napi_poll will call into list_del.
  there is no such local_irq_disable/enable.

   may you give some suggest on this to further narrow down ?

