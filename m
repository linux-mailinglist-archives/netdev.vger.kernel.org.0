Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37AE0469F83
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 16:46:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386333AbhLFPqi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 10:46:38 -0500
Received: from mail-eopbgr40116.outbound.protection.outlook.com ([40.107.4.116]:16867
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1389736AbhLFPk4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Dec 2021 10:40:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MlrbCq7P0eA/ugbQrcD1DJ0HTDIgn3q4VoAurYnJY7j42jOigJ3Hye08Q/eMfrIeaRvJ2Xu+GFWIwRFKexmtTVOyy+4AxjqRjzlHTWR7tJs2tTeaAq34pPktAWf1vCg8T3gSLTEqA4a/Wum59vqbitEyqTNxrHz6t/KE2bdGsmOCvIqRRKb1r3FjkwQg55nN0IE3Wip0EZXygXe95yhe+HIhBxNVB5xYZVTytXpUjR5pU7GTtPgN7nas0ce2xB84CZvJcZMTt22sCbiwiw08u6+MME0If/QfDbGKwdxjNt2jv8PQjpXQealQCd2QVad4r/XQryfmci5miiVJ0Pm9Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jzc3aOFUs6f2dJshQ0iWlLX7mHHa7T2zQ79IZjQjVdg=;
 b=JTeLGdAiV3nCiEtiqxcf1Jfe6w+USZBLJYks1UcwXrAO+WagoYVWYMizzlIP6LfDOWvdkKQ8J6hCfboc21wXHNJsNhc1l44bZWYbE62F3caPCmIUBhDqCSA1F/TI+UpA1vMovE5BakoIR/Knx6kCxgMaD6MQprb2CjUSYNQaJY2R0Kwxe/iwKBgdP3iB+IlRQ7M9sCH15qf3JpK5xawtCP4FeqwLbXqRTLJttHupIQ7OE95R8zXIs699f+wbEPrR3oY1tE4TGgLv6jdrh7TO5NYn/ZcaDQbHB67X+PmsLEdoQuHGMWqu+pqGRS2K0yOz5QFAp33fj2CTwre+pTmkCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=eho.link; dmarc=pass action=none header.from=eho.link;
 dkim=pass header.d=eho.link; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=eho.link; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jzc3aOFUs6f2dJshQ0iWlLX7mHHa7T2zQ79IZjQjVdg=;
 b=faaBX/eDPKYmpKmQBpqE5xQmu/DI6lDG+v9jP7fYEOpLdI2aoYf434AKR1/LpUCNn4NyebrqbEjSxStEwLg6yYQNf/qy66CiCnifZSo8rSM2RwAwLpQcWNvrJTaq+MJhhIEpOa1CsjZmfr5Ut4dUttLjeM+qOpeVZefLCNjjLZlRTDYGENOhRatOqUsDRSKrIeYrfNsk1lhIpaEbu3rBPqnaeYBLAPWHzAcFYil/kbjC8Cb1Xji991sF0XTlELLTTW9YmZyv6j9XM4l4C60KYLijcD6JtbJyPTZRdWgKGWyEJ4EwJx+hqsTnAEyokgDA3AJyYfCWg08GwSOOTbNqBQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=eho.link;
Received: from DB9PR06MB8058.eurprd06.prod.outlook.com (2603:10a6:10:26b::20)
 by DB6PR0602MB3319.eurprd06.prod.outlook.com (2603:10a6:6:8::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Mon, 6 Dec
 2021 15:37:22 +0000
Received: from DB9PR06MB8058.eurprd06.prod.outlook.com
 ([fe80::4cbd:de68:6d34:9f5a]) by DB9PR06MB8058.eurprd06.prod.outlook.com
 ([fe80::4cbd:de68:6d34:9f5a%9]) with mapi id 15.20.4755.021; Mon, 6 Dec 2021
 15:37:22 +0000
Message-ID: <bdc1f03c-036f-ee29-e2a1-a80f640adcc4@eho.link>
Date:   Mon, 6 Dec 2021 16:37:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH 1/1] net: mvpp2: fix XDP rx queues registering
Content-Language: en-US
To:     Louis Amas <louis.amas@eho.link>
Cc:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, hawk@kernel.org,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux@armlinux.org.uk, mw@semihalf.com, netdev@vger.kernel.org,
        songliubraving@fb.com, yhs@fb.com
References: <DB9PR06MB8058D71218633CD7024976CAFA929@DB9PR06MB8058.eurprd06.prod.outlook.com>
 <20211110144104.241589-1-louis.amas@eho.link>
From:   Emmanuel Deloget <emmanuel.deloget@eho.link>
In-Reply-To: <20211110144104.241589-1-louis.amas@eho.link>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MR2P264CA0130.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:30::22) To DB9PR06MB8058.eurprd06.prod.outlook.com
 (2603:10a6:10:26b::20)
MIME-Version: 1.0
Received: from [IPV6:2a10:d780:2:103:dc7:bd76:843f:31d7] (2a10:d780:2:103:dc7:bd76:843f:31d7) by MR2P264CA0130.FRAP264.PROD.OUTLOOK.COM (2603:10a6:500:30::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Mon, 6 Dec 2021 15:37:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bef9960e-2a69-4986-22f5-08d9b8ce4be3
X-MS-TrafficTypeDiagnostic: DB6PR0602MB3319:EE_
X-Microsoft-Antispam-PRVS: <DB6PR0602MB3319E506520CE31AC201B09BFA6D9@DB6PR0602MB3319.eurprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +4k2cvJM7K2N6DKENPaveFsgZmSo8MZ24dkdpRc3+VtEa6we6W6sextKLBBHUxsDIUk1442utgQhrWXMGgluKNiEJEDTELviEWWwP0KGznQpxRHWSBoU9xrbk6UsWPkJU+3TS92WzcR4/VeVggekZd39IBIaL66ix8zUS2JyPElCwMMoxpUKIv1QM3kMlR5sJ3fmp0hsfjf0eH2xQQ0gX1Sq6wdQv6x62Znm4EdKC0Jts1IoedEs8aJgmtwwTJG9SOzyIu4/xTum9tLxbdCTwDAlxnioxwLG+DC6v+jHi4aU3qmikKvran5xXmQUl/W71Ny1EALZU8dk3HV1X2KaFDWuYwlix7weGJxPqlj6+Dor2hbBPkiKer/PSiAPI6PS8Gbg3+WYIGzEza9ccB1wMOqYp2bu5DMMnuRCyEnO6EdjMAnUIiMs7G3kwF551Qy+aku4up51PISHC0nSGmEJtmXv5056GEMUW/sJ0eLqWUf32ijBPgVclRBl3ZMAxO1C6NdRaSqjLtE3IRCOs5TM5zi8fvNQUik3mhzJcEjZpM+BSAD/pzTK0ilUVsZxD1u5rPn54V9XRmGqfNv5cKEfcsiOCLJXsTRGmq3N0XhO3Jcs8dGJSu3gesvv7ExFUWvQ47lrbYqWucuuxjZcwDQxKzKq+8uwwE6xWjjYACuGHLVEAFXXVcltGXSKTYe67ZtK1igw29KBr30dXz08u9ivy84RvW2TPKwvfNPStpATsjPbxuoK+yN7Vy9AP+zkopYv8DboezJMR/jPzpdBU4FWOYcgMNWRIZjEspqK1HoRraXKDhmzlce+fxkGtfPsrSZM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR06MB8058.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(53546011)(316002)(36756003)(8936002)(186003)(31686004)(44832011)(31696002)(7416002)(38100700002)(37006003)(8676002)(6636002)(66946007)(66556008)(66476007)(2616005)(6486002)(6862004)(52116002)(83380400001)(4326008)(5660300002)(966005)(86362001)(2906002)(508600001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OUhndFJTRDAvUTMvd1NTTmwyK0pHdi9CVHhHUjV2SHZ5RTVqdytqU3VFZjVi?=
 =?utf-8?B?SE5sWUJMOG1JUEZKSHY3Ujh1alpxN0pmdk9UR1MwcHJnajFNZGF5WS9uY2I1?=
 =?utf-8?B?WmV3SXRTTmxtdXhDTHAyMVNXNXNQTGpNSCtoSWMxREpEbHdVbjdHOGtMb3JB?=
 =?utf-8?B?L0xJcm9yQzZVanZJYUZEdmlmS0VmcVJBRE10NDJrWGlWeE1ldjN1TFJoK1A1?=
 =?utf-8?B?WXdVMS83cWhmdDI3bUZsTjlVRWZLLzhMWXdSNmt5dFZ4eFQyeGJVMGtrQjlU?=
 =?utf-8?B?akc1WFhrbS9vTUNXZXBJV09JOEdxdzdlbFlOQlNHaWtvMXVkMEdmS3lYRXZO?=
 =?utf-8?B?YkZPMVhvMjZuNnRSZDVTc25UaVpjWUJEZzJNbmpWekNOQWppcXh1QnJXZFVN?=
 =?utf-8?B?TE1ZS3p6QlpSOUlSTVA5VmJkak9RVXFTSi9VMGdJOWppdjJzYndFVkZiU3c2?=
 =?utf-8?B?SjVuYkMrT2E1U2tVMW93RU9tSk5SVU9FbWtPbkNZejExRTc0SkpxZzZJN09K?=
 =?utf-8?B?bk9WSGE5YUxrR3Jzc2tVZkYyYjdFN2hSWlpBenJ2TFo3YlI1TG4rVGQxV3JW?=
 =?utf-8?B?aDdzT2lCMmV3QkFWbk9tZjZLdzZwOHAzT21ERlRQbm9vSmd1T3ZJOHljcXA2?=
 =?utf-8?B?VzFPeDRScDRYUGtVVm1jM0xvMFZSZlNDUkd3MFpUZmtTbC9nVVJtWjRKSlBM?=
 =?utf-8?B?c08yNnl0SzRDQlBVcTg3d1F2eFNZbzFzOVA5aVNKSFdIUXduVHpCbWk5cjFQ?=
 =?utf-8?B?NEZIajNkU2pvWXhsWkI2TmlKMFg4WncxNVFBYXEvREp0U1p3R3BFM0ZrTGlV?=
 =?utf-8?B?V2s1NVNEZmxBSzhrM3htMy9id05NWllESVU5cVRpdmZsNjBYN0R2R2FaOTdi?=
 =?utf-8?B?SmFBcVdkbStrNGJKOWxqekZuSm1KYS9sWUJIOG14djU1Q3RkTHkwMGJLWHpM?=
 =?utf-8?B?R0M0WE1xa2FUUDZ0RC8yNlloblowVnQ1YVMydXlpV2xqSzhxd2RkaHEwbmZZ?=
 =?utf-8?B?ejFSWXZBV3pjQzFTa3RBVkxwdTlTQWl2NlFCWjd5TG8zeFAvRTZKRUROWFZk?=
 =?utf-8?B?Rkx1R2JuOUVEdnR5a3p1bDBWbG11WWtmcS9Vc2tmcUNHc25sSGs3blpIZEtn?=
 =?utf-8?B?WUZKM283a0lkOTlqVWM4MHVMK2NPR1h4WG5OTFJCS3J3RTV6anIwOUtwNlFh?=
 =?utf-8?B?MElrS3poTGFER2hjU1ZZUVZ3bUQ2b2hxNGFoRHQ0d1pkUldIZU9iN2VCVWJW?=
 =?utf-8?B?V1pvaEhoK0NSL1N1M1ptVVBYcDZOM0JHOEtwRlpDQjIrVXBldHVSeU44OTR3?=
 =?utf-8?B?eFk1bThzUVdCYU1lb2RGVlhhNDhtQ0FhOEt2NVZIV2NzcXl6cS9OcEUxMXVu?=
 =?utf-8?B?MSt6cVB1RXFpZzVEOXRWcmZjamw1Q2tldm9LSDUra0hNd0dYUlFlZWpyZGty?=
 =?utf-8?B?MEMzbzFLcTM1NU5KeVBhaGpZQTUzN2VsSnQ1SEhRcXFualFseWFJVTg2YzhJ?=
 =?utf-8?B?cE9qS0NqWDE5S1htTytncUhHUjdhSko5MmYxc2M3L3cwbVdqckgzR2wxcWs2?=
 =?utf-8?B?QkRQS3Jkb2Q2bFlNTCtwRzd5MjhlZFg5WFRzOEZKZlF6ekNwb3duNHRleGVx?=
 =?utf-8?B?QUFJeE5aZ1NqaUxaWkJYM003MWtUQVljSWtOSng4bWNCTXZRTWJMcVJDRUZL?=
 =?utf-8?B?SmlZNzMvb1RRWkl4MW82ZmVaMXY4anp3dFoyMmZFeVlSVEJGUmdZUHNmNGly?=
 =?utf-8?B?ajZkTmk5R2Y2T3dzZnZOeHhueGdmQUllRzJZc3dsbWRTclZCRExFY29DaVhZ?=
 =?utf-8?B?RzNGUTRhckNjRVVtZTR1akcyNWNVT3NzTmNydU5PdUtOcU4zSUJNTzZqaUxv?=
 =?utf-8?B?YlJnT1FocXRlYkVWc0V5RlVnTzlNcFZxTFlJY2xGYUhLTUpVcjhWWks1UHlM?=
 =?utf-8?B?RTBOTnBlN1V5Y1ZwenFmUW1ScTBVcXZMTEh3QXR3QXNldHBadzVjVFdRN3lE?=
 =?utf-8?B?eE8wckxKWGRuMGQvclFCdTdQWkxub0JITGRpMnhmUE9zQW5JakZha0JBUCtW?=
 =?utf-8?B?Mmd0UzFucmYxZzJGc1ZldGJDUkJHQzNaL0x1K0hOMjZ6K0dHU1hSQ3lpTTlq?=
 =?utf-8?B?Y09WNzRNWGl5YjFDWlRXbUwreDRzK2lFM0NVYTQ2WUlReHExc0xWM2tyZE1R?=
 =?utf-8?B?c2t0VU9ONkxwZ1ZaRWQyMGVFWUtKZGxUeGhQaTRZVUlEWEJKVURSRS9Daitn?=
 =?utf-8?B?T212M1EvelM2ZjgxYk9nOU9SVGNNbFM3WDE0Qy9DTnY0bFdieDd5NktvNTF1?=
 =?utf-8?B?RG9jQVpxc255YnUxU0Rxc05iQ3dHNnprZmFweDFhRlAyNGtwY3VUQT09?=
X-OriginatorOrg: eho.link
X-MS-Exchange-CrossTenant-Network-Message-Id: bef9960e-2a69-4986-22f5-08d9b8ce4be3
X-MS-Exchange-CrossTenant-AuthSource: DB9PR06MB8058.eurprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2021 15:37:22.7249
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 924d502f-ff7e-4272-8fa5-f920518a3f4c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K99zYd8aIT6Qu75964XUVYK32BtMMw+E+1n8a/OD8spt53qPefHw5Upty5fH0+xCei3S/jwfPHCQ0TVdtSE13dL/7tfwYO9r7eqiefJFuN8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0602MB3319
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On 10/11/2021 15:41, Louis Amas wrote:
> The registration of XDP queue information is incorrect because the
> RX queue id we use is invalid. When port->id == 0 it appears to works
> as expected yet it's no longer the case when port->id != 0.
> 
> When we register the XDP rx queue information (using
> xdp_rxq_info_reg() in function mvpp2_rxq_init()) we tell them to use
> rxq->id as the queue id. This value iscomputed as:
> rxq->id = port->id * max_rxq_count + queue_id
> 
> where max_rxq_count depends on the device version. In the MB case,
> this value is 32, meaning that rx queues on eth2 are numbered from
> 32 to 35 - there are four of them.
> 
> Clearly, this is not the per-port queue id that XDP is expecting:
> it wants a value in the range [0..3]. It shall directly use queue_id
> which is stored in rxq->logic_rxq -- so let's use that value instead.
> 
> This is consistent with the remaining part of the code in
> mvpp2_rxq_init().
> 
> Fixes: b27db2274ba8 ("mvpp2: use page_pool allocator")
> Signed-off-by: Louis Amas <louis.amas@eho.link>
> Signed-off-by: Emmanuel Deloget <emmanuel.deloget@eho.link>
> Reviewed-by: Marcin Wojtas <mw@semihalf.com>
> ---
> This is a repost of [1]. The patch itself is not changed, but the
> commit message has been enhanced using part of the explaination in
> order to make it clearer (hopefully) and to incorporate the
> reviewed-by tag from Marcin.
> 
> v1: original patch
> v2: revamped commit description (no change in the patch itself)
> 
> [1] https://lore.kernel.org/bpf/20211109103101.92382-1-louis.amas@eho.link/
> 
>   drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> index 587def69a6f7..f0ea377341c6 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> @@ -2959,11 +2959,11 @@ static int mvpp2_rxq_init(struct mvpp2_port *port,
>   	mvpp2_rxq_status_update(port, rxq->id, 0, rxq->size);
>   
>   	if (priv->percpu_pools) {
> -		err = xdp_rxq_info_reg(&rxq->xdp_rxq_short, port->dev, rxq->id, 0);
> +		err = xdp_rxq_info_reg(&rxq->xdp_rxq_short, port->dev, rxq->logic_rxq, 0);
>   		if (err < 0)
>   			goto err_free_dma;
>   
> -		err = xdp_rxq_info_reg(&rxq->xdp_rxq_long, port->dev, rxq->id, 0);
> +		err = xdp_rxq_info_reg(&rxq->xdp_rxq_long, port->dev, rxq->logic_rxq, 0);
>   		if (err < 0)
>   			goto err_unregister_rxq_short;
>   
> 

Is there any update on this patch ? Without it, XDP only partially work 
on a MACCHIATOBin (read: it works on some ports, not on others, as 
described in our analysis sent together with the original patch).

Best regards,

-- Emmanuel Deloget
