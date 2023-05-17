Return-Path: <netdev+bounces-3325-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FB987066FC
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 13:43:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C2E291C20B76
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 11:43:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6AE42C741;
	Wed, 17 May 2023 11:43:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B37F6211C
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 11:43:20 +0000 (UTC)
Received: from repost01.tmes.trendmicro.eu (repost01.tmes.trendmicro.eu [18.185.115.117])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AF3E40D5
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 04:43:18 -0700 (PDT)
Received: from 104.47.7.176_.trendmicro.com (unknown [172.21.178.36])
	by repost01.tmes.trendmicro.eu (Postfix) with SMTP id 9D73910001934;
	Wed, 17 May 2023 11:43:16 +0000 (UTC)
X-TM-MAIL-RECEIVED-TIME: 1684323795.580000
X-TM-MAIL-UUID: 43e18823-e96a-4ac1-921f-df65a679380f
Received: from DEU01-BE0-obe.outbound.protection.outlook.com (unknown [104.47.7.176])
	by repre01.tmes.trendmicro.eu (Trend Micro Email Security) with ESMTPS id 8DCC110000411;
	Wed, 17 May 2023 11:43:15 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A115MMsZQ3NmJXV8KZgsW+yfDyOVo/jwHb6T8pE71qwBGjjTI95h2v5FBHNi0PyeSqeVZ7rQhZnEBsq4I88/Gv/X0/8GCL6IGDV3RTjryATJwmCyYZWkzV/3BHDH44lEyHVfGryEO9B5gl52FMjZsTcv+uILMZDlPVgEApFeQ0+IAAR1BWmEEhxpoLc6qU9FQ+9rwqYZE++Z+lMpvidyZ+xl2mVvbrNIw74ZGbYhRtl9e6h/DfcCnsNEB1IhaugFe7iQyb76aCxL1xNeinIM+MCHiVohjD2zYlXElVoGqyDyml3nv4SySwx1RupCuao6HH6tlMm/9SLS59IHWoUnfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ETHlDGDJ9pMTX45FkafU0+hb1doMR1mTLiBsqHKT5Zw=;
 b=Rc9deBOGWJeaqCz7IWnhFEo8IW9DGPcLIiQCyhnm/mfHzGLPynkoIDG09hMSB66nK/bWgE6RRBlnaKPVzivovJLJeSXD+PbSlvEQTMg+VCLRQ658zDXLeZTjUtDOeEXZ/74ZL1eJSp5HYLyg9YesyKLwBl5e/FuC5sziILBg7rED/emwQPyWp4L5JbjFpNUR4nh6UV/eS54mafYbiRqAYKZBhsGUe3smO0R1YpDH/RLqC1pCN8hyNHMH0bvwdV1Np3eGKvhZz0xsiZ0y2JZM1PyXTywoYG9NfzbJKUZYfTl+/bOu9EZSOC4DmVvpfZRIz3gKT+kJP1xGAbjjmcUZ5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=opensynergy.com; dmarc=pass action=none
 header.from=opensynergy.com; dkim=pass header.d=opensynergy.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=opensynergy.com;
Message-ID: <1e281a04-cc9b-fbf1-5171-5b0ddfadefb9@opensynergy.com>
Date: Wed, 17 May 2023 13:43:10 +0200
Subject: Re: [RFC PATCH v2 1/2] can: virtio: Initial virtio CAN driver.
To: Vincent Mailhol <vincent.mailhol@gmail.com>,
 Alexander Stein <alexander.stein@ew.tq-group.com>
Cc: virtio-dev@lists.oasis-open.org, linux-can@vger.kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 Wolfgang Grandegger <wg@grandegger.com>,
 Marc Kleine-Budde <mkl@pengutronix.de>,
 "David S . Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>,
 Dariusz Stojaczyk <Dariusz.Stojaczyk@opensynergy.com>,
 Damir Shaikhutdinov <Damir.Shaikhutdinov@opensynergy.com>
References: <20221104172421.8271-1-Harald.Mommer@opensynergy.com>
 <20221104172421.8271-2-Harald.Mommer@opensynergy.com>
 <4782632.31r3eYUQgx@steina-w>
 <CAMZ6RqLALOYFWQJ4C4HTaRw7y-waUbqOX0WzrWVNiQG51QexHw@mail.gmail.com>
Content-Language: en-US
From: Harald Mommer <harald.mommer@opensynergy.com>
In-Reply-To: <CAMZ6RqLALOYFWQJ4C4HTaRw7y-waUbqOX0WzrWVNiQG51QexHw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM4PR0902CA0021.eurprd09.prod.outlook.com
 (2603:10a6:200:9b::31) To BE1P281MB3400.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:4a::9)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BE1P281MB3400:EE_|FR2P281MB1945:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f8eb59a-7445-4e1c-081e-08db56cbe510
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	iStAIarQr2i4N/apznuOfb3Ue8txBbO2+igVSawL9ERIMtjXEoMB7nNnJsKVI4XudtEh+MTN90aMG1i2VKDf6yzhY13FWssvLj2nrhaIniyJCnHGezIO2vDQuAZAyvQ38McRpHzSQLB0RAcfbO0HhcHUV2HE2/zYbvfgKu78y0UM41n/Z7kNkRWtNye/vFvp/6r96562mP8owi3p/4HRMi+AMrlKCWkbqS+RqnlL4EdewKdbPo3yGiEGCO5eBGRed1r6ETHsgBEdkqK5sLlTlUixLKtQ8FCX28Oh5B4OYPU2pPJgH5uktbd4cOZ37Ro/ynr5AzSSNrKwPrJqJ0EL4J+jAeVy4qCRaCG63EnUG57JhLMA0dfWYPmc9h0SXDC+eo7vzL/WuBtWdBYTTxKSesap3RVA1u2yyOYmp9LXXPNBhiBXwnO99/a63GbDtFbHRBKikNBijR/bkvg+nL3ydHlo6leYbkfUlA+M1nK8fbJweOUBs5gL7kw91jtLBO7NwbeaTdkV2jvBNCUL3dpSDhAUl0Q8ybrQeDl61ql0T6c=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BE1P281MB3400.DEUP281.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230028)(366004)(136003)(39840400004)(346002)(396003)(376002)(451199021)(8676002)(5660300002)(8936002)(41300700001)(66476007)(66556008)(66946007)(2906002)(31686004)(478600001)(54906003)(42186006)(110136005)(316002)(44832011)(7416002)(4326008)(966005)(53546011)(26005)(107886003)(186003)(83380400001)(36756003)(86362001)(2616005)(38100700002)(31696002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U2JYN2ZKaTVZN1NRN0hQdk9NVGl0SlJqcSswdzNHajJnaW9wQjgvZ3dhV0Ni?=
 =?utf-8?B?RUwvT05CU2tFeUpPZUdXNTgwV1hXcW9aNFZLeWVJWTl5Vnp1VUpWbjhPdHF0?=
 =?utf-8?B?a0lXWVdLUm54TGE4ajJkcXUxMngzQkpwTllqcGJCeWJwWGM1NmJCNUVVSzRF?=
 =?utf-8?B?Q1RvZ1JxdkNBb1NreXNkaVNUYmM1Zlk5NEwzeHNDdjdSeW5OQzVQbWhhQjRC?=
 =?utf-8?B?U0VxdGkrdEpkcWtTNCt4WDVTQmZJbnZrT3Q5QTdSc0FEdXRhS2FyV2xlL1hw?=
 =?utf-8?B?eVQrRDI3OVp4aDdUdlNyT2RmbStKbHlNSXNFZXltdENnb0RDTWthN0VORlVH?=
 =?utf-8?B?MU03dWxLbC93VTdrOGUvdVk2R0dPSVJQZDBXWlJKTTBldTk2TE0vSXU2UGh3?=
 =?utf-8?B?bDZIQlZoT1FQZy9NbzBNV0VxZmpoSE10QklOdm1tZDI1UUgrelZFbFdxZWdl?=
 =?utf-8?B?WEhSTkZKNEFpUVhSQWZqMHRXN2tTN28zSHRVbjgxMmZ0OHhEM2NsUk9abURa?=
 =?utf-8?B?SDZQbWplVDg2VnlNUklKTHR1QU1LV1pGT3RWM01nREZxdDlTd2pxcUJoaGpT?=
 =?utf-8?B?TEcrVkdyRkFYOHFHK1BSa2VwNFlPdTc5dDJNUTVidlUwRytmS1Y2UHdzT2k2?=
 =?utf-8?B?VW9iZXp4SU1nNmFCWkpEaE1pR1Z6ZitjT1lEc2NHaXNKVXQ1elRMYmE1NlRi?=
 =?utf-8?B?QUUzR1EyVzJvKzQ3UHVUWG13clpuQ0hHWCt5OVFmZFYvSllnK3lKTGdPSDZj?=
 =?utf-8?B?dlRJOXVjdUFBclFzbnRRY0p4R3BSWDBWRTR6RDBucEh1QlpaRjFkQWhRTU9s?=
 =?utf-8?B?WFRFc2FBMng0KzJtNndvUy9DMDV0NmlKR21yU1d2bGVHeFZUdGRDbGZuUWZP?=
 =?utf-8?B?L1dsMDJScWlXcUxHQUd1NG5ZRFZNcjE1Vm9UR2x6K1NWUC9KbVZ6ZnVld0li?=
 =?utf-8?B?WWdPbm1WT053N21KK3VLaTNkU0ducEtBWnhldmVUUm9DVjlMWkc4K3VQQXFK?=
 =?utf-8?B?Q3JlYm5jclI2MDZQWVFjNHBqTmFaVU9aREU4N2ZaWHcxWGdWcEpnNmtSbWFv?=
 =?utf-8?B?dUd2L2lHcDVpNFhUd0R0Nk53Y3FpWTdIN0IrUVdSKzBqSTFUdlpvakZUbHZt?=
 =?utf-8?B?cCtjZnBpSEZUQm16VjNjQXZGOWlnOURDWHdCYit0S1hpSnFTUnRVMk5uUFla?=
 =?utf-8?B?SURGRVByUk5BbUc5U0QzU3VMTzJtR3V4WGRiUVgvOVdKVFpYQ0RxU2VjRGNX?=
 =?utf-8?B?SmV4ZjZQblRUUGN1WTB1R1VWWCtzN0hRd1dINHVjVkQ2SGlrMlVaSmhZd3lB?=
 =?utf-8?B?VTRHR1R4VWxCVWdFUUNDYW1tRnBGKytUeXNVVUVFRE02bW1aK1RMY1UvVDlD?=
 =?utf-8?B?ait2VW80ZVhiT3ZFNFd0dUhTTG9jNm5UYjhIUHpycTlVMnFrS0tHZjVqZits?=
 =?utf-8?B?b2VkWW82SC9ndytMUFN1WU5DeFBUSUx5djhGZjFBU21TMWloc3R5YjUzZkFZ?=
 =?utf-8?B?WWV4SytmQWd5RXNhMXI0WldMa1VURzVXUUVXbllVcjJvNXBOODV0NC9XRm1Q?=
 =?utf-8?B?RUd4aEN2K3htbG1XaEozU0kvZndObytRck5wNVhTcFB1VWNQbm9DazlheWZ0?=
 =?utf-8?B?STFEMFpLSkJqeHptKzkxVGRBbXJvb0g2bVgyNCtRK1VhTTYzNzdkV2FrYk5C?=
 =?utf-8?B?T1duV2hCQ29jeHBGMlhGb2Z3Nlk0VXRDTEYwbjEweVAySWwwWkVuSHovMXJH?=
 =?utf-8?B?WWh4dUFubzR1N2hmbUVvS01ocEFXWjhHMW1nZTJ5RzFHTzQ3OUZySko4QkRE?=
 =?utf-8?B?dTlERVByVkdnVGVsWk81bE5PUEwya1ZhSXhwSFdLWGdJZmxwaW9Tc0M1Q0Jk?=
 =?utf-8?B?N0ZpRlQ1ZWtkck5nbStaMlFkejRGWTQ0Z2x3QW5INUduek0yc0VDRTQ2cC9j?=
 =?utf-8?B?SFBZa3VOUlhqYW5qbjJzbWZlWE52bnIwUUxOTnNkSXA3WXJ3ZzdZdmxBdVhi?=
 =?utf-8?B?VzJjWFlydXdzK0FsdGN1MC9TSmRncjlFUDRMOUhUVnE3elVhM3lBNDZhZVIx?=
 =?utf-8?B?OEtSTnM1QllVQUVqN1p0TDBGckRWcE5VVjczRTMvMTJMK2Z0dWRBaUpzNnZ1?=
 =?utf-8?Q?aCufW6rRTL1/OSmA/A2XJBd3D?=
X-OriginatorOrg: opensynergy.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f8eb59a-7445-4e1c-081e-08db56cbe510
X-MS-Exchange-CrossTenant-AuthSource: BE1P281MB3400.DEUP281.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2023 11:43:12.6484
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 800fae25-9b1b-4edc-993d-c939c4e84a64
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vzCLyetCOl4dtRrm8W/9j++ZWkjBleYDERg9SkNpyfBjP11zwl+QWaXXOWIBSiZne9c8DH6Hx5WkBG60KU6hXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FR2P281MB1945
X-TM-AS-ERS: 104.47.7.176-0.0.0.0
X-TMASE-Version: StarCloud-1.3-9.1.1007-27630.007
X-TMASE-Result: 10--27.511900-4.000000
X-TMASE-MatchedRID: 0+daXaNUWRUMek0ClnpVp/HkpkyUphL9DjsV28DbRUBN13IiykVObKh3
	A+x4DL0WEHmuEGswNENp1WlPE2PQ0x/jU7DSxFhTfOaYwP8dcX7cAmu1xqeetkbhULSLyKWZgK6
	qCGa1Z9dYYfnBUCWGoVp/hmQLQur5X/FSUb7a2MIZgmFGHqyx6xgff28UuvIT4b5mHdaFMyATYb
	tN3Gng+2VIS2rxH/h9qluH1OCJRON4CGd3XYenFwihQ5NZCXsS+KgiyLtJrSCbxQuIG3ALnkw2O
	HQlqD0CsYDE+XcikC8ZK3NRSavY83HPBvSspzfjNxqr5qtGGJS3rIgsEdTKmSWLxjlrSy8vjFK/
	NcS7G4kPNxz2EvpSIJqojxxRc/YRXtsGnSgA6qr2TS1YFaI5/0fLPdsHmQbn19XEQ+nuD+QuF3q
	ZrtYTywKLbdC06zXfzr6DsroQjMkBCLy2DM9zzkEKdUlUrKmAmdrHMkUHHq/W2YYHslT0I1IRXD
	YxV5uxXHpbb6ZETLRFRIRV4p+pAVe8kVT+4FFlmqdQuKXkmotMVCcj56k8hoe/HO7UUbiRLWTvL
	X2iKNiGlWN2xO9eqGXwxNhkEiC3NSBA5qZwHtTece0aRiX9WudjQ/G9Lk6QioGm93F8ryIjL8WD
	WZGeog5Fd3u9jwov1Mw7ajUKG1uXBXaJoB9JZzl/1fD/GopdWQy9YC5qGvzKU1cWyI3gWn+NTaI
	Mjjw/vECLuM+h4RB+3BndfXUhXQ==
X-TMASE-XGENCLOUD: a3f444ed-85b7-43c5-9a43-a5d4f043f980-0-0-200-0
X-TM-Deliver-Signature: 5677F5372D46191B6D5E84029E36AAAB
X-TM-Addin-Auth: 7Wxlv1E3ZzAYv/x3jDDm9pQsGNdw/S1kUwv09AFWSFwi7Z3qy0vLLvQs376
	q0c58DPVOcb9QIWjScK9hTNvYWZSPUhW+bsuKEx6p15t/oAc21/JfbUIXDG4e8tFH2sEXWP9ntm
	XpoOIwr/xPjHqb5KGL2riT9ORwPfJI8l6nGxKK8yUkcIafqzAsyk21Swusa9gXTq0tN866eCuLm
	9WmrVhIzNnDMQ17Rd+k6On6uApzIbntZ8DiuLtE0baJykvrnAIK0Ain/YWjqeTjDmceRhT0dT8P
	hbub0AkGWwfO75Q=.WJ6yiQpP7M6FQ6OKiRUeVNKGUoO6D+HFRbN9WFtSEfTVJlbh86JJI7uf01
	KWaoArCxlCIq67djTRh2fQ4H85BsxlkNlCb4OqcopNVKcGzKpVgpkParOYb0PEk782PQF99ZreX
	bDnq0VNGDenpBdSD7khaxPaf16HTlEoUFdTMk6d8HHX9eQ3sj6QiC3SAOigqLyAMYrGHdF4k6GR
	gX9WCYjb3lBkwA6nY8WDAJnLM6/kzhUDvxfhfHaRK0OhPnwq/lblHs9qRflYY+ymTpafmOYw2fJ
	nzrHue2IQgy85vkeCaWuI/yQPE/NhjlLcoyEXztolnFxHd4E9wVM+Eof+Sg==
X-TM-Addin-ProductCode: EMS
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=opensynergy.com;
	s=TM-DKIM-20210503141657; t=1684323796;
	bh=XLOh3OU6PDReNaG0DY+jTmdxvGbfygYbVzY9wpwx0uk=; l=7116;
	h=Date:To:From;
	b=mtz+/TOtpHveopnVAv+5ZnAUn8rn0A9ZOHoZSrq9OKvNylj80YemJM/yS0+NgD68l
	 kCYTVV5mqLNcfTr0semuHTt7DxQLsj6GddJ+oLlp2Wdas1Wxzejngbt1YlP3bGZZMM
	 +vJQyLK9VdpKgJMQryIvx3QRFUep2HpFeNxDrOEzHNiMaBEXNHNiogxAcaUWLszeEH
	 V7aSSWZAfP3xJ8SPymO05jy3504GqNT2CLw8vnnC1liP0XZCW8Z8xO6NWxIYgdpKgR
	 R3IqQon9np6tSqo5R27lh0wc+U5gvdF+ZXgsUWEHqU+OF/85w66wW9f7WhKgNk6pIm
	 +vg+wb1/Z5Fng==
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello,

(still sorting my E-Mail mess)

On 07.11.22 08:35, Vincent Mailhol wrote:
> On Mon. 7 Nov. 2022 at 16:15, Alexander Stein
> <alexander.stein@ew.tq-group.com> wrote:
>> Am Freitag, 4. November 2022, 18:24:20 CET schrieb Harald Mommer:
>>> From: Harald Mommer <harald.mommer@opensynergy.com>
>>>
>>> - CAN Control
>>>
>>>    - "ip link set up can0" starts the virtual CAN controller,
>>>    - "ip link set up can0" stops the virtual CAN controller
>>>
>>> - CAN RX
>>>
>>>    Receive CAN frames. CAN frames can be standard or extended, classic or
>>>    CAN FD. Classic CAN RTR frames are supported.
>>>
>>> - CAN TX
>>>
>>>    Send CAN frames. CAN frames can be standard or extended, classic or
>>>    CAN FD. Classic CAN RTR frames are supported.
>>>
>>> - CAN Event indication (BusOff)
>>>
>>>    The bus off handling is considered code complete but until now bus off
>>>    handling is largely untested.
>>>
>>> This is version 2 of the driver after having gotten review comments.
>>>
>>> Signed-off-by: Harald Mommer <Harald.Mommer@opensynergy.com>
>>> Cc: Damir Shaikhutdinov <Damir.Shaikhutdinov@opensynergy.com>
> [...]
>
>>> diff --git a/include/uapi/linux/virtio_can.h
>>> b/include/uapi/linux/virtio_can.h new file mode 100644
>>> index 000000000000..0ca75c7a98ee
>>> --- /dev/null
>>> +++ b/include/uapi/linux/virtio_can.h
>>> @@ -0,0 +1,69 @@
>>> +/* SPDX-License-Identifier: BSD-3-Clause */
>>> +/*
>>> + * Copyright (C) 2021 OpenSynergy GmbH
>>> + */
>>> +#ifndef _LINUX_VIRTIO_VIRTIO_CAN_H
>>> +#define _LINUX_VIRTIO_VIRTIO_CAN_H
>>> +
>>> +#include <linux/types.h>
>>> +#include <linux/virtio_types.h>
>>> +#include <linux/virtio_ids.h>
>>> +#include <linux/virtio_config.h>
>>> +
>>> +/* Feature bit numbers */
>>> +#define VIRTIO_CAN_F_CAN_CLASSIC        0u
>>> +#define VIRTIO_CAN_F_CAN_FD             1u
>>> +#define VIRTIO_CAN_F_LATE_TX_ACK        2u
>>> +#define VIRTIO_CAN_F_RTR_FRAMES         3u
>>> +
>>> +/* CAN Result Types */
>>> +#define VIRTIO_CAN_RESULT_OK            0u
>>> +#define VIRTIO_CAN_RESULT_NOT_OK        1u
>>> +
>>> +/* CAN flags to determine type of CAN Id */
>>> +#define VIRTIO_CAN_FLAGS_EXTENDED       0x8000u
>>> +#define VIRTIO_CAN_FLAGS_FD             0x4000u
>>> +#define VIRTIO_CAN_FLAGS_RTR            0x2000u
>>> +
>>> +/* TX queue message types */
>>> +struct virtio_can_tx_out {
>>> +#define VIRTIO_CAN_TX                   0x0001u
>>> +     __le16 msg_type;
>>> +     __le16 reserved;
>>> +     __le32 flags;
>>> +     __le32 can_id;
>>> +     __u8 sdu[64u];
>> 64u is CANFD_MAX_DLEN, right? Is it sensible to use that define instead?
>> I guess if CAN XL support is to be added at some point, a dedicated struct is
>> needed, to fit for CANXL_MAX_DLEN (2048 [1]).
>>
>> [1] https://ddec1-0-en-ctp.trendmicro.com:443/wis/clicktime/v1/query?url=https%3a%2f%2fgit.kernel.org%2fpub%2fscm%2flinux%2fkernel%2fgit%2ftorvalds%2flinux.git%2f&umid=127a2be7-331e-4823-805f-4578232f5495&auth=53c7c7de28b92dfd96e93d9dd61a23e634d2fbec-52b59e6b756f1b97e14cc9439116d9b7a4ad93da
>> commit/?id=1a3e3034c049503ec6992a4a7d573e7fff31fac4

1.) This is CANFD_MAX_DLEN. It is not sensible to use that define 
instead as this is a Linux define and this header here is not Linux 
specific.

BTW, a microcontroller implementation supporting CAN classic only may 
allocate only 8u bytes (CAN_MAX_DLEN) for the payload if memory usage 
was an issue. However I doubt that very small controllers are an 
audience for virtio.

The data structure has been updated in the meantime in the sources, spec 
still to be sent. The newer structure should be prepared for CAN XL 
later however CAN XL is currently not supported.

> To add to Alexander's comment, what is the reason to have the msg_type
> flag? The struct can_frame, canfd_frame and canxl_frame are done such
> that it is feasible to decide the type (Classic, FD, XL) from the
> content of the structure. Why not just reusing the current structures?

The message type costs 2 bytes, if additional alignment is needed it 
causes a cost of 4 bytes in the worst case.

  * Virtio uses shared memory to transfer those messages which is very
    fast. From the speed perspective it costs almost nothing to have the
    message type. It's not a slow serial line where every byte sent counts.
  * The target machines for Virtio contain usually many megabytes if not
    gigabytes. The additional message identifier plays no role for those
    machines.

So the cost for the message type is relatively small. You may think 
we're always transferring CAN messages on Rxq and Txq so we can save the 
message type anyway. This is true for today and may be totally wrong 
already in a few months.

Those queues are communication channels which can transport any 
information. After the specification has been published some day someone 
may want to extend the specification having to transfer a complete 
different message over Txq or Rxq.

Easy with message type:

 1. Add a feature flag to indicate that the device now also understands
    msg_type FOO_NEW
 2. Define the structure for FOO_NEW having __le_16 msg_type as first
    member. The rest can be defined freely without any restrictions.

Without message type 2. can become ugly. The implementer is forced to 
get into the existing scheme, this may be difficult and the result may 
not look nice.

Better we spend the few bytes now to have better options in the future. 
We don't know what is in 5 years or even next year.

===

The question "why not reusing exactly the existing Linux CAN structure" 
is indeed something which has to be thought about. Cons: Virtio is not 
directly a Linux specification. Pro: It's tempting. After I've learned 
that qemu is also doing exactly this it becomes more and more tempting. 
No conclusion today.

>>> +};
>>> +
>>> +struct virtio_can_tx_in {
>>> +     __u8 result;
>>> +};
>>> +
>>> +/* RX queue message types */
>>> +struct virtio_can_rx {
>>> +#define VIRTIO_CAN_RX                   0x0101u
>>> +     __le16 msg_type;
>>> +     __le16 reserved;
>>> +     __le32 flags;
>>> +     __le32 can_id;
>>> +     __u8 sdu[64u];
>>> +};
>> I have no experience with virtio drivers, but is there a need for dedicated
>> structs for Tx and Rx? They are identical anyway.
True for today. Could be optimized in the specification. Resulting 
object code of the implementation would be the same anyway.
>> Best regards,
>> Alexander
>>
>>> +
>>> +/* Control queue message types */
>>> +struct virtio_can_control_out {
>>> +#define VIRTIO_CAN_SET_CTRL_MODE_START  0x0201u
>>> +#define VIRTIO_CAN_SET_CTRL_MODE_STOP   0x0202u
>>> +     __le16 msg_type;
>>> +};
>>> +
>>> +struct virtio_can_control_in {
>>> +     __u8 result;
>>> +};
>>> +
>>> +/* Indication queue message types */
>>> +struct virtio_can_event_ind {
>>> +#define VIRTIO_CAN_BUSOFF_IND           0x0301u
>>> +     __le16 msg_type;
>>> +};
>>> +
>>> +#endif /* #ifndef _LINUX_VIRTIO_VIRTIO_CAN_H */


