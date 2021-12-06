Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8834046A1B3
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 17:46:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237638AbhLFQtZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 11:49:25 -0500
Received: from mail-eopbgr60112.outbound.protection.outlook.com ([40.107.6.112]:61479
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236400AbhLFQtT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Dec 2021 11:49:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XBIPA2CWvG8AvDOtlSGBYlOn3s+TEd//0a3307d3cR5WpwyrJvTIXhWSC2GaF/+sLIHn7v8+DJwViF5DCD7WU0IJiyqBqQjG+OZkUIs7aTwBTkxYsMUYl8j/IXtZh0q5TxZatpuxQcwezN/sxHmqTdhRj9xRx45h3hgDFAkjD+yp1y5KhOfR4LC3R1wk2aH9RkjGyp8RfyYddL3vJDzZGQmr8WHV+2l9arWXqFEorogUBLHERdvObDfUOc80nTzTpsmWDuKf19hOblUx5Drra5mxWl1OfN+OreY9eGxL9kO5ftKHfQnltf/HGJ8AXBMk39ZaJKKrUaIYSIFr7iuSXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bNhs/DbT6igdY2B7zuIMHHhkukV1zn9A6TiKIlaDpKU=;
 b=cwvrvum3eGHB+4cTu5xpbHDH896lcafxfquLnNWdmrNbQLityiSNt5frXLEInRGNVhagEfC4PPZS3/qMM0ADNsO2xMg30CV9K3SvO1i+M1MjWwG5duhOxqiAKiCgkmGBEL1v2hDQlc2uoGIf8yFwIO0R3UDMDRwQfnXlBPLvTHnZ/VyTkT+xjcq9gDBiwz9Q6mpxOgmWDYMZGJnLH7trUG32kD4SPo3+UPVNaj9Y/zT4LUb3D6yY8CC2lPtvHN9WMfB70JgJxrjoyJ8kg2+4ktlv1HEw8FnPnDD1I1sxVOoVTNkydA/o7TEsz8vVJr4dWuKDwsa8SsIq9peOFcEJtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=eho.link; dmarc=pass action=none header.from=eho.link;
 dkim=pass header.d=eho.link; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=eho.link; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bNhs/DbT6igdY2B7zuIMHHhkukV1zn9A6TiKIlaDpKU=;
 b=aDPblChOfggfrb0SpGZwu8QGiC3bC7GsRyqZUY9sPVt89kYICy1z7Uo2+1KsogaPZHhlJa7WBJ6mzwV2GWLu84+BX4tvH2YeavnMWFE04naEUzsSfnJcs109LIiWI2/SQSu/+r9aZMSHh3nAj1jnRQbPnCmdCUgAsPSew0OE9QXm2ZlIJUNJoh/oVsTDcoXEeuoarBaWhCSBVnCBzR0VXOP5JpmrUbYEWr+Zq0gPFUZiT80CE/4NYx5eSclacubO2A++O+QN3x/RUSryCHDkBjqAH7IgyfLQJ3rWRCe5lxHaDs3Y1vYoLO5cSGaJf3RrwRcQzapWYs6eQmPw/ZAvPw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=eho.link;
Received: from DB9PR06MB8058.eurprd06.prod.outlook.com (2603:10a6:10:26b::20)
 by DB7PR06MB5403.eurprd06.prod.outlook.com (2603:10a6:10:76::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Mon, 6 Dec
 2021 16:45:48 +0000
Received: from DB9PR06MB8058.eurprd06.prod.outlook.com
 ([fe80::4cbd:de68:6d34:9f5a]) by DB9PR06MB8058.eurprd06.prod.outlook.com
 ([fe80::4cbd:de68:6d34:9f5a%9]) with mapi id 15.20.4755.021; Mon, 6 Dec 2021
 16:45:48 +0000
Message-ID: <a636a5a0-237b-2500-a37e-c9f77b030c06@eho.link>
Date:   Mon, 6 Dec 2021 17:45:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH 1/1] net: mvpp2: fix XDP rx queues registering
Content-Language: en-US
To:     John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Louis Amas <louis.amas@eho.link>, andrii@kernel.org,
        ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, hawk@kernel.org, kafai@fb.com,
        kpsingh@kernel.org, linux-kernel@vger.kernel.org, mw@semihalf.com,
        netdev@vger.kernel.org, songliubraving@fb.com, yhs@fb.com
References: <DB9PR06MB8058D71218633CD7024976CAFA929@DB9PR06MB8058.eurprd06.prod.outlook.com>
 <20211110144104.241589-1-louis.amas@eho.link>
 <bdc1f03c-036f-ee29-e2a1-a80f640adcc4@eho.link>
 <Ya4vd9+pBbVJML+K@shell.armlinux.org.uk>
 <20211206080337.13fc9ae7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <61ae3746df2f9_88182085b@john.notmuch>
From:   Emmanuel Deloget <emmanuel.deloget@eho.link>
In-Reply-To: <61ae3746df2f9_88182085b@john.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MR1P264CA0110.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:50::19) To DB9PR06MB8058.eurprd06.prod.outlook.com
 (2603:10a6:10:26b::20)
MIME-Version: 1.0
Received: from [IPV6:2a10:d780:2:103:dc7:bd76:843f:31d7] (2a10:d780:2:103:dc7:bd76:843f:31d7) by MR1P264CA0110.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:50::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.16 via Frontend Transport; Mon, 6 Dec 2021 16:45:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 007d83dc-141d-43c8-849e-08d9b8d7db1e
X-MS-TrafficTypeDiagnostic: DB7PR06MB5403:EE_
X-Microsoft-Antispam-PRVS: <DB7PR06MB54030AC089FF65023B2EB717FA6D9@DB7PR06MB5403.eurprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fTzchCij9LhwOYcKo/y3unR2sIqEpVtddXP1od3xXSgp4SQakZHOhW3YUw/kjwMCotKiU2IzLpwEMD/iyoX40LfSJYmUKC2tqbq7BIUy3jfOgIrT864p5T4/kIFWf1qFY6UaC92g23At9l8JVnd5UlWUp3fQOKD5f65+1h8IsDV8B7V5y7lRQ9TDYvMYsGAtT7hobQ0kZidxJI2X6oXZupWyMeA3L58zpNkfU/gcdDQ4x2p/PjY+MghOpBb8ASAMmZND7lFeI5nVRBWlDoaJWbJmYEgujiIb5zJvbC/eTRDfnuTOuYZf54CMQwArJzzk4KHZYrUNorQFMCHlLvXmvI4K5mQrRHiZiIGj7N+9rtJKv6UoEqCAiTZ2EC3TS8xFxaCgKsyPQkZCh0K6yF9n9IcsN97BB96RcspGHrVoPv8gNjpTmp+ZNXwx/601M1BeWp1FREtVrfeVWeaafP/gfUb+Z/mfYL917s/Dc1U7q/BCbi5YCiqZWURXz+d/PW6FAGH9eDZmfI1kxvPsaxI8duWSP8VbiNNrv80QtzGc3jSvjmODy4pKj2dWYmJR86AzHm7puDbnWnDnk5ex2w3HeAG/LlDamYhzbOpj3Q7pQy2+1KJlVsVgQLPUEFo4pf6MJbBAeDqFuAakJqHO6F1vUbwPcnw+5+fAHIsGQddLmuJhTR6D5/NmBk+BSHp4m+zjPFhQM+kBfnx8nkEV1kLx6EOv4pixzlgnIuDFGpdS+K8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR06MB8058.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(366004)(136003)(376002)(39830400003)(44832011)(86362001)(38100700002)(66946007)(66476007)(5660300002)(186003)(53546011)(8676002)(66556008)(36756003)(31686004)(2616005)(508600001)(4326008)(2906002)(110136005)(6486002)(316002)(8936002)(83380400001)(31696002)(52116002)(7416002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eWU0VkRZTFBTVHI0TDZ4OWY5YUlqa010NHljdENia0cwTDJDSnkxSTVBcjVG?=
 =?utf-8?B?dVVlemw4L0pBbk1KcGVtc3liejVISVQwK1Vadmt4dVNia0YrWUFSS2RjVUd2?=
 =?utf-8?B?ZGg0NzYyaVRhdjFROWpSUVhOL3ExY2JNNW0rSnhOYzlIUzkyTkNRZ2x2WUZi?=
 =?utf-8?B?aXNBMzB3cTRvSHFsMUxWT3ZRQWt4bGs4b1U0d0xwRzJlOHlwYTMxYWtDMVBk?=
 =?utf-8?B?Sk9mUTRtZklFam1sVm1aakQxN1lrNEQ4bkFUV1U1UVVyQWlhWVRrTjBoTG52?=
 =?utf-8?B?akJrTUY4RUhBOVoxUTNJNXhXelRMY0hiQnBMd1pVbTFxMUpIR2xkNjV4TGFo?=
 =?utf-8?B?R0xjMVFSWnRjTHczQWtPYndLMTJ3RlNFV2ZsakVhYndOTitRd1FPZEgvRDJJ?=
 =?utf-8?B?OHZzenV0ajhtbUhYWHBFQzU5NXVickw2YkFuY3Z4RkJnWEFveE85TEtoVWZH?=
 =?utf-8?B?eU1lMFMzK2tzN1lyQ0dNNU1pRlpoL1RZbTI4VFBacktYU0xZUUxHOU8zUm9B?=
 =?utf-8?B?UEVZYkVQZXFJcEdTbVVzTXR1TElOTnp3OHlldzVUMW5JL2NZV2Q1QnF5MkFv?=
 =?utf-8?B?YWJwV2RwZ3BLSC9kcDUycURjbExCOUtQdGNCbWp0L2RFLytBS09ab3IraTNa?=
 =?utf-8?B?cEp0eGQ1QWtmb0JsK0NCSkd4djJIQTR3Q0pWVDFNSUN6M1l6ZmlPOTVtSVh1?=
 =?utf-8?B?QVdId0VFa2lhNUt3UkRCVnF0Tk5OWHVWc003YXBkRDQ2aU9MOVRaWm1nWGdX?=
 =?utf-8?B?c3lBTXVnYzg2eGt6MENrTHEwNVBuZ0V0ajkyRG5pcFZheWtBWUtZSFJIVnh6?=
 =?utf-8?B?RTYyY1VuVk5Cc1k2OHRVNERHZ0FSbGhMMFJvQk14bDVTNk1mT0xTVVN5Uzc5?=
 =?utf-8?B?REFidlFkOUZoM3FCZWo2cHFhWnhIR0NZVEF6cHdza0JqbWwvcHJMUmZtcFA1?=
 =?utf-8?B?Q012T2F5UkhVdVUwL1NQWm05Mm1ab1VUNE95NkFIVVBRdTNGRXErS3kxTjRS?=
 =?utf-8?B?bFJBMGoxZG9vYVIzSk4ySkpoRTE4SnlCU2FIZEkxSkZuMzdrRXBrTS9WQkRG?=
 =?utf-8?B?cCtKbm1Vc0k5UUk1NEpCbDhTQXpVcTFrc1ltMUxRc1lxVWxHa09rSE9iMGFx?=
 =?utf-8?B?M1k2TlZXck9CYmRjNzVoMDI5WTc1RzVNWFJvQVV2OGNPaEFMdDl2OVlDSGVJ?=
 =?utf-8?B?a254ZDE0MlhiR05KNjhaSlA1NUVnbk1MQmlQWXprb2VHYm9SN0NsS0tRcTVV?=
 =?utf-8?B?ekk4aDVvSG9rTXM5KzFqM2o4QzJyN2t4cnIxTkR6L1dJNEdiKzFNOXlCOXFn?=
 =?utf-8?B?clBzRDB4Y004RlF1a0VKS2tXeS9xZVZVbHJkc1E0YnBJYzhRcGVGSFAzMk1r?=
 =?utf-8?B?ZnpVWlRkNFVSVXVlUHpBTWY5d0F2UElwTVk1UDRMRER5aldKMFZFdFlKYVgy?=
 =?utf-8?B?UTN4VWFqb2IvYXlxRUtseEVJL0g4Z2ZmN0tsZlFaSlhwS1pPZjZVWk1WdVJr?=
 =?utf-8?B?dm9PcmVXd2FCVjl1SldZcUNrUGExSzYwQTdVZ2hTN0F2RHBpa1FGajRYVktE?=
 =?utf-8?B?U1VNdWpWN0FremsvMDEzZVcwRGNJVWh4RzlPSlFlZ0tSTW00MnIxc1BUSHQ0?=
 =?utf-8?B?cjNKbGhWcEJXZGh1Z21DbnRZUEY5VWZBd05FazJVQlQ4WDhoczQ2czRORXV6?=
 =?utf-8?B?a0tCT25RSkZIZk1raHdqdm5xMGxpQlg0ZitLbHpzNFl1cDFvbFBZelVOTHE2?=
 =?utf-8?B?cUt0TVlhOUpFU1ZUYjRLZE51UUowT09kSkRKZUM1aGhwK2dCd0lvd0U2cnZr?=
 =?utf-8?B?K1c4am9WUGRSL3A3OWZmWXRQZXVIZEprNmozSzhQSkV3b3BDU3pkMS9vRjBv?=
 =?utf-8?B?SUtlYUNIeTIyR2VvSVJ6WmFiSTlwNWlkcU1iWlI0L3FoOVg5S2VoZlNPQngw?=
 =?utf-8?B?ZER1R1dObTIxTTNrLzJ4cjRva3NLeCs0KzlxQkQxWjNtbStHRWJ1encwb1lQ?=
 =?utf-8?B?NDN0T2ZjSm5STEZOSEw1NGZUZ0Y3Nmk5TUFGM0VCUHd4c2ROTFVieENNcW9J?=
 =?utf-8?B?eTFYVzlLWWM1b3pUZDRxUHFhb3A3T25WVUtkRTJWMkw5Mm9jbE9MbUdyN2V5?=
 =?utf-8?B?REhhSmI5aFpvRXcwSjl1djAreWt2YUt0QXZnZTFvbHFWWUVzZFAzWTlXdW1P?=
 =?utf-8?B?OWxuRkxINDFIeTl4UHNHaFBLeTRvbmJ6RWZNeHFDSW9HSGlpYkpJelFKdFQw?=
 =?utf-8?B?eUorc1BqTkVxYUFsOS9CcnIrY093YTl2c2xWRDBodVNUTUE2UE5GcHM1UzUv?=
 =?utf-8?B?anpTYjU1TkI4K1Q1ZCtLK0w3MTdnT2R1L0YvK2ZNanM1UXJzcHo3Zz09?=
X-OriginatorOrg: eho.link
X-MS-Exchange-CrossTenant-Network-Message-Id: 007d83dc-141d-43c8-849e-08d9b8d7db1e
X-MS-Exchange-CrossTenant-AuthSource: DB9PR06MB8058.eurprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2021 16:45:48.5008
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 924d502f-ff7e-4272-8fa5-f920518a3f4c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f85Hv0kBntYvAN5Yz8c/GnWvQfshoyuX36HWRqcD0wxhwf6E3E3WqyGxpt/zVyPRnH9TrLzRmahiRWt9VOQC7a1lsygdbNi00QdDmKDHa7o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR06MB5403
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

John,

On 06/12/2021 17:16, John Fastabend wrote:
> Jakub Kicinski wrote:
>> On Mon, 6 Dec 2021 15:42:47 +0000 Russell King (Oracle) wrote:
>>> On Mon, Dec 06, 2021 at 04:37:20PM +0100, Emmanuel Deloget wrote:
>>>> On 10/11/2021 15:41, Louis Amas wrote:
>>>>> The registration of XDP queue information is incorrect because the
>>>>> RX queue id we use is invalid. When port->id == 0 it appears to works
>>>>> as expected yet it's no longer the case when port->id != 0.
>>>>>
>>>>> When we register the XDP rx queue information (using
>>>>> xdp_rxq_info_reg() in function mvpp2_rxq_init()) we tell them to use
>>>>> rxq->id as the queue id. This value iscomputed as:
>>>>> rxq->id = port->id * max_rxq_count + queue_id
>>>>>
>>>>> where max_rxq_count depends on the device version. In the MB case,
>>>>> this value is 32, meaning that rx queues on eth2 are numbered from
>>>>> 32 to 35 - there are four of them.
>>>>>
>>>>> Clearly, this is not the per-port queue id that XDP is expecting:
>>>>> it wants a value in the range [0..3]. It shall directly use queue_id
>>>>> which is stored in rxq->logic_rxq -- so let's use that value instead.
>>>>>
>>>>> This is consistent with the remaining part of the code in
>>>>> mvpp2_rxq_init().
>>
>>>> Is there any update on this patch ? Without it, XDP only partially work on a
>>>> MACCHIATOBin (read: it works on some ports, not on others, as described in
>>>> our analysis sent together with the original patch).
>>>
>>> I suspect if you *didn't* thread your updated patch to your previous
>>> submission, then it would end up with a separate entry in
>>> patchwork.kernel.org,
>>
>> Indeed, it's easier to keep track of patches which weren't posted
>> as a reply in a thread, at least for me.
>>
>>> and the netdev maintainers will notice that the
>>> patch is ready for inclusion, having been reviewed by Marcin.
>>
>> In this case I _think_ it was dropped because it didn't apply.
>>
>> Please rebase on top of net/master and repost if the changes is still
>> needed.
> 
> Also I would add the detailed description to the actual commit not below
> the "--" lines. Capturing that in the log will be useful for future
> reference if we ever hit similar issue here or elsewhere.
> 
> Otherwise for patch,
> 
> Acked-by: John Fastabend <john.fastabend@gmail.com>
> 

Ouch. We failed to get this email before resending the patch.

My bad - and sorry for the inconvenience.

I'll see with Louis to change again the commit message and add your 
Acked-by.

Best regards,

-- Emmanuel Deloget
