Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55EEE4538BA
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 18:43:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239032AbhKPRqU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 12:46:20 -0500
Received: from mx0b-002c1b01.pphosted.com ([148.163.155.12]:2544 "EHLO
        mx0b-002c1b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238976AbhKPRqR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 12:46:17 -0500
Received: from pps.filterd (m0127843.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1AGE0Uon030966;
        Tue, 16 Nov 2021 09:43:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=HYKUDdDBB/xPW4EDOQy2x2qk0wvESY2IWLDINJ5AtmE=;
 b=mXs1NfCiHp/sEoeUteAxm3gIh9L7aSwUDqyfqi77cFCIlfRS5k0lVx6PWXf8f68k91tq
 yGkZM79BYiMNJYVKeEephzAemLd0pYLrjOTKDP1IV10iS7aC7RfnnU9j/gkXTEszF699
 t/2N2lJLHJEBRuwhZP+pCDT5iuRa6b/rPEDz+yRRMs05YU4UdbmcVboX+9fKPLQpiKTA
 dY/z9ViM4gUx8uQhT1wzwLWvfxjIkQ07HiFEiJJexInasyoTcaqIe+TTlXJk6v9ovJ1g
 mtYxiEsBofTzDCsdNdJZVM+rwGi1MJyAinweCOxiE32cgW1PaAw8vSrGFWnxPrkEiGtq Ow== 
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2041.outbound.protection.outlook.com [104.47.57.41])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3cc6wr9kj1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Nov 2021 09:43:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gc5Qcjqe8NHyArCdrAwXpwEXCrlKsg6SQlOWReMfPX6bzqiHF9FSqmCoWTVE2gI8qYOedKEB9CxSgyYhHzcypt2fhBZR1qbgPBW8gViOwyoKwRnMcU0FGdbGy4u8Rzz9F7Iq7ZK3bZS7kpsi10C91Ps4EzkPVLjLHe1D9jUFTRqCh5CXEcIRFOWzRGJZ+FWOlDpiVNNz78allFBMaccU3ecvEWDNfXZ7BhlZeFEWK1B5P/6rOmqO1BZVf6ukafm2TSVikVuoOMnIQOV4UIuXkEV1ssKsj5J00bDMeAq4FvVAZ5r1TAgF+HJg3imCjiEItirjZ59LOqROXGFY++GHGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HYKUDdDBB/xPW4EDOQy2x2qk0wvESY2IWLDINJ5AtmE=;
 b=VY4t+APUlBclOs6x40R7dknbqkEwjuntOGYpXUyFLFcuvxoq8NdqQTzNHXamq1nPCu/Ha3H0ssVHOWk7ryBbNtaZuxC2WYEP/7jwe/z/YWa0mEQGyPpn1Qj85AFe1MQa0b4gDFashXuqqr4jutParg0M7JIkoSIaDiK5Z8FJ2kvlzUo1X1/btA6saIIfxhCPqWH+gqrMclc7WPhbVdd/EnrFuO+M5Ou0Q8mOhtaWqL79cwa+PjwVyc5kVMxfvV0KLX1SdAP0Grs1MCnK5hg1JgFFP0rQE5W0CmccleYYsUBQqtwrCMfedU3EOqt3jszwNCHZmzJ27KhjHaftCfT4AQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from CH0PR02MB7964.namprd02.prod.outlook.com (2603:10b6:610:105::16)
 by CH2PR02MB6808.namprd02.prod.outlook.com (2603:10b6:610:79::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26; Tue, 16 Nov
 2021 17:43:14 +0000
Received: from CH0PR02MB7964.namprd02.prod.outlook.com
 ([fe80::cbb:e155:fd25:4b52]) by CH0PR02MB7964.namprd02.prod.outlook.com
 ([fe80::cbb:e155:fd25:4b52%5]) with mapi id 15.20.4690.027; Tue, 16 Nov 2021
 17:43:14 +0000
Subject: Re: [PATCH net] net: virtio_net_hdr_to_skb: count transport header in
 UFO
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     netdev@vger.kernel.org, Florian Schmidt <flosch@nutanix.com>,
        Thilak Raj Surendra Babu <thilakraj.sb@nutanix.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
References: <20211115151618.126875-1-jonathan.davies@nutanix.com>
 <CA+FuTScqWToamoOqAWkf1VbzYnjoM-y+-rQe_wEkPmBsOZbsLA@mail.gmail.com>
From:   Jonathan Davies <jonathan.davies@nutanix.com>
Message-ID: <180bcfc1-a66f-1ecd-7b96-85eb871448d7@nutanix.com>
Date:   Tue, 16 Nov 2021 17:43:05 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <CA+FuTScqWToamoOqAWkf1VbzYnjoM-y+-rQe_wEkPmBsOZbsLA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM9P193CA0023.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:20b:21e::28) To CH0PR02MB7964.namprd02.prod.outlook.com
 (2603:10b6:610:105::16)
MIME-Version: 1.0
Received: from [10.10.20.228] (46.17.161.146) by AM9P193CA0023.EURP193.PROD.OUTLOOK.COM (2603:10a6:20b:21e::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26 via Frontend Transport; Tue, 16 Nov 2021 17:43:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 89a1747c-e9b7-4e28-6768-08d9a9289098
X-MS-TrafficTypeDiagnostic: CH2PR02MB6808:
X-Microsoft-Antispam-PRVS: <CH2PR02MB680809D8A0D98220084F56CBCB999@CH2PR02MB6808.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D4riAiFmLJepVACAAyC7P/rMnc1V48/3wvbah/echx5UvUozB5LVwuRqZyumNVS83CvhX1q2XIZ4zbl210LEDuwX1dD5Wf3RDC9F6g2aQXcpdtWoEruhw4ny5LKlNwbdkObg4VmbzwaUNvPV5oWuE8irqoRLGNqmbSjUvqNNZwcfUXCr5AzvJzqHLOE9THQUHmZIpyiwiuzgzLc8RRxiJEXqi3yHVL3mq45nx8i8n83kVLP2H/2i2+R0U7U/t3s+6AVQEYx/GLzman4Eel2ETC++UVT/SWduggKj88RV+ngmkvCBaID8UzxrmO3CwYmydEbhJbcEq3Iyqm2CIIusTgWEeXjTYFtHJpJh/1nk6kQIhk8RXIbmMvGvx4EMfU/9rMNRd8ZoHkpCLnQkin5cRjUxX8VbhTWmozJOelEinACJH3A4DELrylt2svObASC7001fs6izk1fD5+Rivdrn4yRJAY6eZUkoFlpWat4QUcBJbB5yaYCriWCumu78fZlajGTUZXN4f6pBrY98sjmE1c6g9k10Mv/Xt84s2zpAupyn7lxHlZjAlh/zfcPa9Z5cRyXDX0/RHn7JMS74LhaDFyYHYyZwmUrM0K4NlPQ5Y6uhctf3FUrRfOSlfCP1sKAlkYtuIjeRZCSuBnxVZhphboNuAp2rCFlwOSnpumLo9g2A3iCuHDI4MBrGJZ1RA7A6WqxpDaiF3fWktGLAaXBomqjTR4xDifd1XRndLVZbo/bHZg0VIXhsL+/LQeYAXrngtuoPKgJyH7PM3YKgz6FQMg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR02MB7964.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(44832011)(186003)(36756003)(31696002)(31686004)(4326008)(8676002)(5660300002)(2906002)(956004)(2616005)(38100700002)(52116002)(6666004)(38350700002)(16576012)(26005)(316002)(6916009)(6486002)(66946007)(66476007)(54906003)(8936002)(53546011)(66556008)(508600001)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dTZEdFVnZDZKMEF4OG8wUTcvN1pYblUyRG9VYlZGM0htbHlwc3NmV2dMaEdM?=
 =?utf-8?B?NXBVK1N5OThXSVJOTjhVb3NYbVpiSktEMGJ1UVlpY0c5cEtvUWVlR3lnQzZ0?=
 =?utf-8?B?a01PZUplTWg5ZE5jZ292Y2thTkpWYSt1MTNkaldJNVdreWVYbE1oRHo2VTF4?=
 =?utf-8?B?TnBXRE9oa2ZlS20zU3craFVsRVJXZTNmU0Y2SzM2aHZ3aTE2Sk0vR204bitL?=
 =?utf-8?B?a21hdWpiK1AvOXRQWHRlMjRrNVRsOHdGZFNyVWliS1J0UHMvdEkxd2lLSWdr?=
 =?utf-8?B?S3BkdEI5SC9zbHdkWnhpQ05Fd2F5aHdIeVExOG40L1dPbW9jakJJOHlNT0hO?=
 =?utf-8?B?M045N2J1bWFCVmlSTWRoZVJaRzJHRjhzSmxkUjRDRXBQTzMzeVJ6MzJmajhK?=
 =?utf-8?B?UGtocTY0ZXA2aThiT08rNWRVT3EwV1FJU2VWbWhYdjZ5TUdKVVQrVkxzSGk0?=
 =?utf-8?B?TWdVcStER2dNVklnZGhHSEh0WWNGZENVdWZsV3JPVTVEa1FuUVl4NllkRnlI?=
 =?utf-8?B?MWNSWnN5YTIzcWJmcWx6Wlk0TnNTdjZkd3pUMWhWZ0ZKdEs2USsyZkRUNmRO?=
 =?utf-8?B?R3Qxd05zMnFGbUhqdzhmYTFBYk1xbTVsa0tLKy9XakthZkdCRGV3T0h1Yk1V?=
 =?utf-8?B?VUt3amRTNjY3bUo2MDlMdzN4ODkxTmkrcXRrVDJOOEFyekxUU3o2aE1oR255?=
 =?utf-8?B?VTBVQXh5T2lvcHhaK3E5R2FaWmFuT0dDMXQ5VnQwMU9lb29xVkJNaG9xa05x?=
 =?utf-8?B?bGJLYlljQ1FoVThER0hPZ3JlMDNiazlZUVBxc3FmeFNhd0VPZ0t5L0dmSWdm?=
 =?utf-8?B?VjFiY2VRTHlwc3kvOWExOG1WMFZoa0NMZG9RUnI4RTZHOHI4dkM0SEMzN0tP?=
 =?utf-8?B?aUdDNTZ0YWRxVHd6M3JjdzVUZGJ3Z1ZrQ21kSjlzUzVxVmxUTERLS3JNcVd6?=
 =?utf-8?B?cHpJZVRpV3k1L2M3Ymp1WkJGaGk3S1hkTGZhdjlqSWxHNWpSeTZEQWZ3TW11?=
 =?utf-8?B?bGFRaCtUdlo1N3pVTDVTR0JKQmd1NzdGM0htZXFEZEk4eVEyYjBlbXhMYTFx?=
 =?utf-8?B?dWZZeHhDY09TR1c3a3A2UmE2bDBYYlMzWkZyRmV5a0lwZmFuWldLclNlcFg0?=
 =?utf-8?B?bkFWZ3dJZUIvZEhTMHlZZys2OVFMUy9hYkJxdWRPY0pqSGRiZ3NLcVJXS1hL?=
 =?utf-8?B?ODE0VUlDbXlaSk9xQWYwMkVrTlBtYWY5aVhqYmtxTTBOQ1ppQzEyVW9vVnNI?=
 =?utf-8?B?QnlvVVlhaUdTSzNndnZibjhKMzBHKzM3Rk14UE51OGxYcjNmNTdiYU82ZGJP?=
 =?utf-8?B?U2EyYUJTMDdVNDJIWUx2MVhaVWlJZklQS1JuNkw3V2NXVmV5eG9GMVR4S204?=
 =?utf-8?B?V2RRakw3MktlTW4rY2VrMmw1OG5ZbUgvQXk0OVhkdXFWM2krMDVuLzd6MVNH?=
 =?utf-8?B?RTFPWklYQzBhdU44Q0F1ekhIaEdSVkZIYm9oU3k4dllIS2hBRS9BTUZqM3U5?=
 =?utf-8?B?Zjg0ODRDeTBsYXNjR0tEWjR0WXp2TW05VHQwNnlHbFV2ZUVDcm9vVUV1aEp4?=
 =?utf-8?B?dGdqSWtQNUJnd0JrNk14QUM0Njl2Y2czSWIvWlYzcEliT0U3QTZLNEdLUlVX?=
 =?utf-8?B?U0VXM1daUS94NUNTeHprSUtUUlFEN29VRjVMc3hvOGwwMVJWZSs5eXI1czhX?=
 =?utf-8?B?SzVadzdZWHhPYzFjdWVwbmdUd2podThFdXNiSlFZZnM2a1ZDWm15aGd0Z3M5?=
 =?utf-8?B?SFZRaWlFYjQxS2ZXaWJuc1lmb2ZPSzlPVGJiSjNFNitJaW1sWkRycHJmaDl5?=
 =?utf-8?B?SlBwd1lRSHZIdnlORTlUWkI5eGNWYkVnRGZPaG9XNHZ4a2k0U3pRbHBjM3VE?=
 =?utf-8?B?aFZoTXc2QlJrMFVQc2FhMkI5VUNHVXBDQ3g1ZVk4eVp5c0w0ektWblIydlEy?=
 =?utf-8?B?Y201L1YyVzhIeVpWNElOQy9JSnJlamprOStSV0FyTFlJalNiaUFUZWNaQUFQ?=
 =?utf-8?B?R2ppaGVhVlBlQVVxV04rYmVHNXJmUXNCR0Q0b3lUd0srdGhBWkVjZzJQMlZQ?=
 =?utf-8?B?ckZUY1Y0TStCZDZkSi9hdEhKMW1oR1cvOEdya3F1OWtaVWl4OHhoUzNaSlVm?=
 =?utf-8?B?aWNMZThMRjZCZHZJSGU0K3M2N25udnp6SFZQZXlzS3NUU2loWGwwVnBiSVc2?=
 =?utf-8?B?aHZydXd0UmpJSitQckJmbzdNcGRqK2duVkNiMjU0cU5oSDhVY0ZsOFJnMU9p?=
 =?utf-8?B?NDVDYUdUYUxaQXRWb0NPQjR5RkdBPT0=?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89a1747c-e9b7-4e28-6768-08d9a9289098
X-MS-Exchange-CrossTenant-AuthSource: CH0PR02MB7964.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2021 17:43:14.1170
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e5QWWleYsgjsuM+jvyRtZxz8pe3ArNTS/+gqTsOxbDiegDKWDokmzWbJLw+zOtJpGUXo1P4PoRvIx23qW/PbM6ObAzmqr9iUuA7ro0OdIp4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR02MB6808
X-Proofpoint-GUID: uZQF3fJxW3nzpCiB9jqw5rCKZVunC8S1
X-Proofpoint-ORIG-GUID: uZQF3fJxW3nzpCiB9jqw5rCKZVunC8S1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-16_04,2021-11-16_01,2020-04-07_01
X-Proofpoint-Spam-Reason: safe
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/11/2021 16:34, Willem de Bruijn wrote:
> On Mon, Nov 15, 2021 at 4:16 PM Jonathan Davies
> <jonathan.davies@nutanix.com> wrote:
>>
>> virtio_net_hdr_to_skb does not set the skb's gso_size and gso_type
>> correctly for UFO packets received via virtio-net that are a little over
>> the GSO size. This can lead to problems elsewhere in the networking
>> stack, e.g. ovs_vport_send dropping over-sized packets if gso_size is
>> not set.
>>
>> This is due to the comparison
>>
>>    if (skb->len - p_off > gso_size)
>>
>> not properly accounting for the transport layer header.
>>
>> p_off includes the size of the transport layer header (thlen), so
>> skb->len - p_off is the size of the TCP/UDP payload.
>>
>> gso_size is read from the virtio-net header. For UFO, fragmentation
>> happens at the IP level so does not need to include the UDP header.
>>
>> Hence the calculation could be comparing a TCP/UDP payload length with
>> an IP payload length, causing legitimate virtio-net packets to have
>> lack gso_type/gso_size information.
>>
>> Example: a UDP packet with payload size 1473 has IP payload size 1481.
>> If the guest used UFO, it is not fragmented and the virtio-net header's
>> flags indicate that it is a GSO frame (VIRTIO_NET_HDR_GSO_UDP), with
>> gso_size = 1480 for an MTU of 1500.  skb->len will be 1515 and p_off
>> will be 42, so skb->len - p_off = 1473.  Hence the comparison fails, and
>> shinfo->gso_size and gso_type are not set as they should be.
>>
>> Instead, add the UDP header length before comparing to gso_size when
>> using UFO. In this way, it is the size of the IP payload that is
>> compared to gso_size.
>>
>> Fixes: 6dd912f8 ("net: check untrusted gso_size at kernel entry")
>> Signed-off-by: Jonathan Davies <jonathan.davies@nutanix.com>
> 
> Thanks for the fix, and the detailed explanation of the bug.
> 
> Reviewed-by: Willem de Bruijn <willemb@google.com>
> 
>> ---
>>   include/linux/virtio_net.h | 7 +++++--
>>   1 file changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
>> index b465f8f..bea56af 100644
>> --- a/include/linux/virtio_net.h
>> +++ b/include/linux/virtio_net.h
>> @@ -122,8 +122,11 @@ static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
>>                  u16 gso_size = __virtio16_to_cpu(little_endian, hdr->gso_size);
>>                  struct skb_shared_info *shinfo = skb_shinfo(skb);
>>
>> -               /* Too small packets are not really GSO ones. */
>> -               if (skb->len - p_off > gso_size) {
>> +               /* Too small packets are not really GSO ones.
>> +                * UFO may not include transport header in gso_size.
>> +                */
>> +               if (gso_type & SKB_GSO_UDP && skb->len - p_off + thlen > gso_size ||
>> +                   skb->len - p_off > gso_size) {
> 
> Perhaps for readability instead something like
> 
>    unsigned int nh_off = p_off;
> 
>    if (gso_type & SKB_GSO_UDP)
>      nh_off -= thlen;

Thanks for the suggestion. I agree that improves readability. v2 posted.

Jonathan

> 
> 
> 
> 
>>                          shinfo->gso_size = gso_size;
>>                          shinfo->gso_type = gso_type;
>>
>> --
>> 2.9.3
>>
