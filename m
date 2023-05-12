Return-Path: <netdev+bounces-2102-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 62380700442
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 11:50:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 29D521C21127
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 09:50:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5343BE5D;
	Fri, 12 May 2023 09:50:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF944BA4D
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 09:50:16 +0000 (UTC)
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01olkn2109.outbound.protection.outlook.com [40.92.107.109])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E13795255;
	Fri, 12 May 2023 02:50:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GQZKELfY8OKj5ehQ097egqcY4CSzRlah0GpwL4CGUDEcxuSO4AWQYlGA4zXQE5b1wABB4wPrveZm7OaEO2/8mxPzXMfu/I+eH8hQHGvKXmo/rEF+V6+lZer3nZIFhxTQZ5vRb1XI3qy+7dFv1YTLhkD9582ZImGLzJK7SVJW3Myfw3QmObQzzl4MUGERleqQtA+4Fz+8hJ9RQMpb4o/tJSaOpfn4KlKtLqWw1yYWZT2NOlMp7oqUc4fuFX5Q1J8UVpTRh+SICeq37OiKsJJsn/YAHdK23XIhURCxTARFk/OOMMz3GGnfQ6nNhIwGM6OCUGzJStvh6C5aAZxTJaMQxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ssy1hFHMDshgG5P9kzGaPzwK1cSgc4LzI1+yOtQqD0k=;
 b=Yo9kiSqHFNPMVJxRKp96B+YdLJtbtTyH4sszgD1RP8Yl1SFAYIxjTahGP71QDTsDQ2HhoYSptR1yhIjF0Lbu0UXP++UZmRhazFlDPaJ19/iKZyG/QWAUaBhjTKNbkiheoBh4/bqaAmnfRRClGEFWcq/y6SuY3qivdxdmPfv1u+KhVKXB1DheRLx2cEXktaldh8s6bpyHR1boK1eCe9fWnZAbZxdLe8PbR2D4rbCcWInQ3CTnsYiQVSWobBFRqcZF7UWs9iSS9ebYXPrj3sogM59kqloZOgmJoEV/sq50DGBJ3fbWNTX22I2gVVZqLnNeEYjiY/ZWy87DBPiZ57opIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ssy1hFHMDshgG5P9kzGaPzwK1cSgc4LzI1+yOtQqD0k=;
 b=UuSsgEotHats6F4BFKv7/TbwbqPpXDjekAUJVIJBUq/I2nUUvKobeqsEaRZh28rMInBBaSvagOY3LOld3lBiAIhJKCUh8eVXy1uPzZ6JBT5qLWT9YW/FK+VwaLLVYsUn11n3dwt38l2kCSN9ozwiyTfd/i1xviQ5poiIyHDLns+8qJx44g8ojwj98bZOWCaSIOD8isRL7wm4CEKYQrM8XUVygFgLywssOHCVFxvBfEuy7JNu42saviKRQOp/tWPHd0PF05BM6Lcex/xAc7xDykIJbJdcVCST/HBRG+N09mhxFEQDvB3G4W3ByUONfO+4HhIOjHFFJKq561RZnzyvNQ==
Received: from KL1PR01MB5448.apcprd01.prod.exchangelabs.com
 (2603:1096:820:9a::12) by TYUPR01MB5236.apcprd01.prod.exchangelabs.com
 (2603:1096:400:35f::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33; Fri, 12 May
 2023 09:50:10 +0000
Received: from KL1PR01MB5448.apcprd01.prod.exchangelabs.com
 ([fe80::93cb:1631:4c4c:1821]) by KL1PR01MB5448.apcprd01.prod.exchangelabs.com
 ([fe80::93cb:1631:4c4c:1821%4]) with mapi id 15.20.6387.018; Fri, 12 May 2023
 09:50:10 +0000
Message-ID:
 <KL1PR01MB54487B1E3759CF451F06D5D8E6759@KL1PR01MB5448.apcprd01.prod.exchangelabs.com>
Date: Fri, 12 May 2023 17:50:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v5] net: mdiobus: Add a function to deassert reset
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <KL1PR01MB54486A247214CC72CAB5A433E6759@KL1PR01MB5448.apcprd01.prod.exchangelabs.com>
 <ZF4AjX6csKkVJzht@shell.armlinux.org.uk>
 <KL1PR01MB54488021E5650ED8A203057FE6759@KL1PR01MB5448.apcprd01.prod.exchangelabs.com>
 <ZF4J1VqEqbnE6JG9@shell.armlinux.org.uk>
From: Yan Wang <rk.code@outlook.com>
In-Reply-To: <ZF4J1VqEqbnE6JG9@shell.armlinux.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TMN: [YEyoNMlRbsdaRczHA7xgW9Ge+pCLKx9s]
X-ClientProxiedBy: TY2PR0101CA0033.apcprd01.prod.exchangelabs.com
 (2603:1096:404:8000::19) To KL1PR01MB5448.apcprd01.prod.exchangelabs.com
 (2603:1096:820:9a::12)
X-Microsoft-Original-Message-ID:
 <35f118e6-83cb-f771-4bfa-f9c029bc0803@outlook.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR01MB5448:EE_|TYUPR01MB5236:EE_
X-MS-Office365-Filtering-Correlation-Id: d694fe0b-3f29-402d-58ec-08db52ce4693
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	AiPcmNvmFxN6cSRU1vc4TEWeEOP4x0Yperccl/hy5r5fA2JW0dA3nLmqNWEBVJsn0d8H3EKdnAQc5v48eY5JyQKlhP3LdSDmJf4ixsv1x4OleKB+9ns5Ec1Zppn4nlKtzGGNOBhLgh0giSHccuZ2pYZj6TtO1btOX9CQjE847YLZVmmw9IrMwocnOcnBwIBqiTx1LdbA0akHL7QrdbYvX/uYqUxAmha8i+NFS0bgLQcsedgddFns5Ig1micKMEcT0ZlNO2ehyWqPaGE/emMNyKAVm0/SaWdW1yXgNhIa829caC1eyBN4P8euCSc3j/+xKf8PU49d6yEAEBp0xE+wxzc9iAJeHeKu3IujFBVaXP9Nlz12PB9Ls7CLoT0ZMwHy/EytA+4KsSBOVOW92mKbOHfSvFy7DRsE/960qATfyAetoDY5U4No9K33cAkWEI0vzDeW1HpwwConllcemh0vuBEHoDGtgkerKZIkpDzZwY9maFBbtiz8sbCSuNLuX5VVFr4AzlaOUdd7sOkRWmhWEnia45vTDR4aaKWnAxlCnkgZzFkOF0Dw1XgvPa7nqstITiBEqx3KdDG1q8TtRFOiZ9BIWdn7SZ1qNu4oasL8IgCDSCZHuyTlU+TBJkKuMF6w
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YjNlbVplL1RxYjdpcER2QnJxVGRqYXN1ckVnZWlmWE85MHNpZVhLbXUvWFBX?=
 =?utf-8?B?RHVhVFV2UGMrTHdpaDY5UnUveDh6NEMxYmg2NVd5SDNoakRMM2NLTGs4cTNy?=
 =?utf-8?B?dE05L0JHQ3hxUU11Q3IydWpIVUt6WHNHdzVNSkRZOU5ReVlQSk1rQ0pHMVRw?=
 =?utf-8?B?dFU4RE50SWx2NVRKd3ZUUjNFWDc5b2pLMm5uS211aVBtdkFsbmVjMXN4eGQx?=
 =?utf-8?B?UUJnQjN0SFJ0WGtHcm9idmZrZkdyOXRsbDMxdmFqWnBYZGVoTGlPVGduLzRV?=
 =?utf-8?B?Z2pqdkdpYURHZS9NSENBYXJYeHl5eXUyRlVZVXVpVVA4K1BPc3kwTXFBSXRO?=
 =?utf-8?B?RzIyN2Z5Y2NmbThDaEU5cXhGSkhZZG9rOEdobDZ1QWVibW1ieHI1QUkwcUtU?=
 =?utf-8?B?VFVOWUtISHRybXZvYUVzYjJTOFdQK1JjWGlDRUdTSExYZnVJbTJ6VnU5RU9u?=
 =?utf-8?B?ZDg2dmRlMmtOMFZhYnJyUTRtSmxIMTkrQ005ckZLMXFqdWNVTURqRzRzcnVv?=
 =?utf-8?B?enRRTHFiSnBoR1p2eTRtTzhseTBJdTAxb0JQbXBCTnpEU3Q0N004eHVyVVZn?=
 =?utf-8?B?S3ZNdC96OWUyeDRGWXlodTNVc2ttUW1KYnRSSzRJRlhDTEVJQjZUR2lDbzRZ?=
 =?utf-8?B?RW90ek9qVTk3R1dXM0VCMlp5YnVvUVk1Ulo2TFdmZkpQUmdOaXJDQnlCRG5k?=
 =?utf-8?B?REQ4SzZ0TUxLYTErSUZQMGdWZ0VBRFZkMHUwamduU3dHNmgvNGRYQTMxdHBP?=
 =?utf-8?B?eVQ1cVh5OEFIMnRTWFBoN1liK1JueTlkYUhrSGNPejFoRlRKVjZFdXM0WGt4?=
 =?utf-8?B?am5kb0k3ZmJHZW95eUFnUVg0YUVSblg0QUowT2V4VlFuWXI2Qmt4QmUzOHlx?=
 =?utf-8?B?NWlUOGxOb0NwRXg1Wkc0alpabDBwaXBSZTJkaVpiMnlrZTN3dU1iaGppOWl1?=
 =?utf-8?B?UEk5UEhFYzlHczdvN3k1b21ubGVEYkxXZzBYaU9NS0R6eGhCNHVOMFkwYUlW?=
 =?utf-8?B?bEFJR25xSWpBMTlsbWhWM0RscmJ3eFgxTC8wNEU0VjN1UVhTRjVKTnJFaVo5?=
 =?utf-8?B?ZGNJOTZ0TWxUbjVaNWJkbUVnWStqU1VvZEpHRDlZaVJJVlpHUWRWcWw2aGUw?=
 =?utf-8?B?d0NYK2o4RkIxUnZvZU42YjJFNkxIZEJFQWxMZXZnb1JDVFJ6UVFucjQ2WlBK?=
 =?utf-8?B?K1FqTGExRXNoR3Y1UkwvZXNjbUJSWXRzb3FjN2trRnJ6ZWIyNkVzSHdIeEkv?=
 =?utf-8?B?cnpCUWNCSExJakZNQzdiRXByOTZwbFJsRTZkYlBtcXJOYjZ2Q0ZnRi9sMGcy?=
 =?utf-8?B?bmpXaXREdW8yWWdscElnT2h3T01HdmxkMG1vVWZ0aXRXR3lWbWkzdmNDL3F2?=
 =?utf-8?B?VmVtc1YzS3NNZHluL0RHdnl1L0x1OFpFYmJtbG5Rd2dqZUx1dThFM1FaSmRT?=
 =?utf-8?B?czFFQkhOejdPdkJvZHc1SDFmOEsxeXgrQXdkVjZtTHNtMDNTVmhETkFPR0pD?=
 =?utf-8?B?Lzg2Tmo3TTNpNFc3R2FzOGJLTEIxQzJMbENGazlRWG1FR2xDMDM5YmNsWjJP?=
 =?utf-8?B?YXNOQXBpYitOYTBEc0pWNWRCYnA2aE9yZGdVeFVxMThvOE40WEdKUHJ4T3pI?=
 =?utf-8?B?T21TUlRkZXdFdkR2R2lQb2doYUlWdmc9PQ==?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d694fe0b-3f29-402d-58ec-08db52ce4693
X-MS-Exchange-CrossTenant-AuthSource: KL1PR01MB5448.apcprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2023 09:50:10.5925
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYUPR01MB5236
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_MUA_MOZILLA,
	FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 5/12/2023 5:41 PM, Russell King (Oracle) wrote:
> On Fri, May 12, 2023 at 05:28:47PM +0800, Yan Wang wrote:
>>
>> On 5/12/2023 5:02 PM, Russell King (Oracle) wrote:
>>> On Fri, May 12, 2023 at 03:08:53PM +0800, Yan Wang wrote:
>>>> +	gpiod_set_value_cansleep(reset, gpiod_is_active_low(reset));
>>>> +	fsleep(reset_assert_delay);
>>>> +	gpiod_set_value_cansleep(reset, !gpiod_is_active_low(reset));
>>> Andrew, one of the phylib maintainers and thus is responsible for code
>>> in the area you are touching. Andrew has complained about the above
>>> which asserts and then deasserts reset on two occasions now, explained
>>> why it is wrong, but still the code persists in doing this.
>>>
>>> I am going to add my voice as another phylib maintainer to this and say
>>> NO to this code, for the exact same reasons that Andrew has given.
>>>
>>> You now have two people responsible for the code in question telling
>>> you that this is the wrong approach.
>>>
>>> Until this is addressed in some way, it is pointless you posting
>>> another version of this patch.
>>>
>>> Thanks.
>>>
>> I'm very sorry, I didn't have their previous intention.
>> The meaning of the two assertions is reset and reset release.
>> If you believe this is the wrong method, please ignore it.
> As Andrew has told you twice:
>
> We do not want to be resetting the PHY while we are probing the bus,
> and he has given one reason for it.
>
> The reason Andrew gave is that hardware resetting a PHY that was not
> already in reset means that any link is immediately terminated, and
> the PHY has to renegotiate with its link partner when your code
> subsequently releases the reset signal. This is *not* the behaviour
> that phylib maintainers want to see.
>
> The second problem that Andrew didn't mention is that always hardware
> resetting the PHY will clear out any firmware setup that has happened
> before the kernel has been booted. Again, that's a no-no.
>
> The final issue I have is that your patch is described as "add a
> function do *DEASSERT* reset" not "add a function to *ALWAYS* *RESET*"
> which is what you are actually doing here. So the commit message and
> the code disagree with what's going on - the summary line is at best
> misleading.
>
> If your hardware case is that the PHY is already in reset, then of
> course you don't see any of the above as a problem, but that is not
> universally true - and that is exactly why Andrew is bringing this
> up. There are platforms out there where the reset is described in
> the firmware hardware description, *but* when the kernel boots, the
> reset signal is already deasserted. Raising it during kernel boot as
> you are doing will terminate the PHY's link with the remote end,
> and then deasserting it will cause it to renegotiate.
>
> Thanks.
>

Thank you very much for your explanation. I apologize to Andrew
and I will handle it on my bootloader

Best Regards

