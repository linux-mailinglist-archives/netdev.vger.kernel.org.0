Return-Path: <netdev+bounces-7042-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B1A8571967A
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 11:11:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6BF972816F9
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 09:11:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 469F213AFB;
	Thu,  1 Jun 2023 09:11:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34A925231
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 09:11:09 +0000 (UTC)
Received: from smtp2.axis.com (smtp2.axis.com [195.60.68.18])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F1CD11F;
	Thu,  1 Jun 2023 02:11:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; q=dns/txt; s=axis-central1; t=1685610665;
  x=1717146665;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=bFy/la0AIELkaEjHQ9d2yI/gomWKucwWx1/+S5jzTxE=;
  b=GY2YYS3dlB9UKHk4V/E0vsGHBhDEKlr55d+npz4bTcJGro5jPg3We3mj
   P7616F2U4c3N2Ytkdg4D6SFXBdzN+yQnVf2hVHZ82HLW6QtKprNpP/otX
   RSipGH0aWThJbVRDeQ1MwbRAZtl8NfNdEvLbtkHCqqi75PhBRdeFcWY7j
   R/mAXeZ23Eqln2UgP2/yrDKTKTeDoj+JR6bMG6kN5lWYiRSptek7aegci
   b3RryAGeK2QsTf8lPC5nS83Kgm3EfbsDf52jkIF+u5LfF/U1SNh/4vjLC
   8aw2cZEc/1eLA4Krc5wX/clg9kyLDNVz57zR56YYx0r9RzF9tTfMrpbk2
   w==;
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MhSRZihVgJt+hh1sVfzfusRPDzJWs6vMrUJUf1nQZSnOTYXMz9gpav7gKGwYLU8UCdW7LdGdVm+Esu3kMnfV2wVufIXjLbkW0a2aTTrq6hyEf9smwfK2mOcziXhQOVq2KyiTR9Qf+vTaxBiEWBEggR4ci9BsxiT5vu8z1s9prTH8Zh915CdlJyarJv0Q+swuarA3VmjQjnPuhNSLJMnYHca4eBKUZWR87Ic7KZSxIQv8wRWsu7jkyhYk9Wopy//zI2LUEIgT3e9qlYTajtYZVYxX1lZk0H8oH4zQvE5bR0kXri3YIj6cjMFKLOaZBWSRvgVJ6VKg0UAsP7wSwtFwMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bFy/la0AIELkaEjHQ9d2yI/gomWKucwWx1/+S5jzTxE=;
 b=Iut+7AUs9Xvg9cPgvgDIBc4oiC6QxIq0l/mcozTLzAfSIcHaWDYEze4RGFCRpI0cPZtJ67A/PDtoB8a2jLyvMyPbOtQr+MqzZMeMcEafWcyQnvW27jM1XNWGX9gVqgs7fcB8v/dxbKO9qnVDD9b+SDrHAPmfqLm103/SBGClf28U25q9XazBV2A+NuMWJNk/A2QV3F1oWEfhKDyhfC65Qqwih1ehQoE1W+aNMZSR1DsMR1J8pYQVRwTgrGQT93k9DIUnYwjuZVdJWvqtxWvepNB5mIL36Pp7t++f8V4NP4oEJcz2dL3prmhtvBPnW3VTzDdwlZlr/TasvBkMGqT+Kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=axis.com; dmarc=pass action=none header.from=axis.com;
 dkim=pass header.d=axis.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=axis365.onmicrosoft.com; s=selector2-axis365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bFy/la0AIELkaEjHQ9d2yI/gomWKucwWx1/+S5jzTxE=;
 b=ec5UPD5ivC6kpNWR4GL1H0mCgyuSiKeReLDhMACqcFvarQD6ZBuJLacC9vpJxx+BGRH/0PoTARKiRzj9cmJWZx6ZT/7mptd7s8IR73RDrfnVN8pvOtxZqWKIQU4tRjKfLBtENi9oQIiRnoQz86E21Kn6rYX6mtFwvf3ahFAsCxw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=axis.com;
Message-ID: <f89e203a-af77-9661-1003-0e9370ff6fab@axis.com>
Date: Thu, 1 Jun 2023 11:10:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH net] net: dsa: mv88e6xxx: Increase wait after reset
 deactivation
Content-Language: en-US
To: Andrew Lunn <andrew@lunn.ch>
CC: Florian Fainelli <f.fainelli@gmail.com>, Vladimir Oltean
	<olteanv@gmail.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, <kernel@axis.com>, Baruch Siach <baruch@tkos.co.il>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20230530145223.1223993-1-andreas.svensson@axis.com>
 <be44dfe3-b4cb-4fd5-b4bd-23eec4bd401c@lunn.ch>
From: Andreas Svensson <andreas.svensson@axis.com>
In-Reply-To: <be44dfe3-b4cb-4fd5-b4bd-23eec4bd401c@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MM0P280CA0053.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:b::32) To AS8PR02MB9651.eurprd02.prod.outlook.com
 (2603:10a6:20b:5aa::7)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8PR02MB9651:EE_|PR3PR02MB6025:EE_
X-MS-Office365-Filtering-Correlation-Id: 0002ef93-5fa6-4258-9143-08db62801e43
X-LD-Processed: 78703d3c-b907-432f-b066-88f7af9ca3af,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9jnlimNIbN6I6CTVjN+n/eEoc2k1GRdql1xzJyflJSNjoKBRnn5Gk6uquQmaNHj7AIsy03aI54MNB351czQhsZbtgOPX5dw/fP3tBe2pKNkPvJr6x+0VT4uEzDYZDQD73XbrwH9cS1dQwDqra3vS7cbKwgjfOyptu2jZO/kna6MgYdr30Xuo/sMb9lgJ7P1Qy6y3ZPqohEuBPg4Yer36wPu9+Iy8/Kswmy3gFKxxrynehI9kuH6QfOhgwW1DwLoGjCa/pP7kMucPUrRFURa39hJAbeM1M0g8NmBS4mt3K2ZgmbU/65/mWyH7p/cm2byqsl9Z61JNvjAMgXqSCS2ffI0Ovk9AcUT4fqTkCekpq5N/zA5EXgyz/tBWuffz1PpLjwHVUMwkemrMVg9/ytEYPH1ONxKDDlzZ5cnZQ/JD7XZ8B4Hjzy5KEMFyvVlNoN09Bw+0jV/+A8alLSdSQL+OnR0xGJT4bJgoHXUKHcfbPz0mCXfJJiFQLo6HY1HOlgb2Z4GEBARtjj4jgNtk1ZRuw5+/2WQ3tY0wexTb4tk2dzdAIVkbcig7/wfG4p9u6SzmC8n9UoTKBuXzps9athNNlpVBgrFyGWqz1j+422dOVbWsVVBfZ/Nl+YXSUbsKNx0mnKgDFfw/dyYqlFV1Yri8AA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR02MB9651.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(136003)(346002)(396003)(376002)(39860400002)(451199021)(44832011)(66476007)(6916009)(66946007)(66556008)(7416002)(31686004)(316002)(4326008)(41300700001)(54906003)(2906002)(8676002)(8936002)(5660300002)(6486002)(478600001)(26005)(53546011)(36756003)(6512007)(186003)(83380400001)(2616005)(31696002)(86362001)(38100700002)(6506007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ME9UUFR4SmlSWU9pb2FvWHRwYXJMOXltcU5BbWVmU0lBakh2VWdYVGE5V21w?=
 =?utf-8?B?QkRlYUY0VXdUWVNTdHFyWWdsS2ZmcjNGK2xxWjJqOXpWaGdVbkhCellESUkv?=
 =?utf-8?B?bDc1K3RDcW82enJhR2xzMit2OVlvZ1pmcE5QQWNYWWZZYW81MGxjSmhqMjgy?=
 =?utf-8?B?M2x4N0w0UlJMMVRrMkJUeFhmbnBxaEZwRGJxQjZDQUpVMnkxZWppbVVhMkg5?=
 =?utf-8?B?YU14S3EyeVB5UVF3SCs5VkRUQ1JLSTVGb0xzdlNaUldEemw5QXUzOVdpNWVQ?=
 =?utf-8?B?aktVT05wenUrZU9GUEl1aEJUZXh6NllpZldMcTduUnBZSkJMbXBNTEtGVHNs?=
 =?utf-8?B?ZFMwRFJXTkZzVzJlWk04a2ltZDhlNVhiSm9NTzdNQ0tNOFJweTRMU0gyQWgv?=
 =?utf-8?B?QXBabUx5LzViL2hLYXBMcTM4bmtiTVF3b2MxMTBDOEV5RStQUS9LdmJZRXQr?=
 =?utf-8?B?M0pUWTMvZXE5VzZMTVlheVM3UUE2Sjd5WjQzRFNKd0d3N014Q3ZXS1FVWHJM?=
 =?utf-8?B?ZG5TeUFnaDhnV2dLTnUzWkRrY2xhck5RUGs2TitCUjNTbFBUWVRra2Z3cVNS?=
 =?utf-8?B?OFd3QUVyRytTNjc3R2ZQTW5IMlRzL1FlRzNjaW5kUitSSlFuNHJXMjRVcitG?=
 =?utf-8?B?aFBDZHJvbzl0S0dkTUw0WVBnYlkvdnBtZHJOa1U2a3l1VU13TnRWTGZZaGpW?=
 =?utf-8?B?TXJqY2lmWG5WMC9ndldhTEt3eXNkb1cwNU1zajZvVUxQT1FCd0VTci8wZEIv?=
 =?utf-8?B?OXBMWDB2aGowdnl6anE3aENmUXhqbytRSDJlSDh3dGRTNEdJRXEzSWptcE5I?=
 =?utf-8?B?MDRaMHZSc0ViTEVkOXVmeVNhdlhleWljSHRvMjN4dTQzVkVCTTQvZGQvTGVp?=
 =?utf-8?B?b1JPYlRxV2FkS2d1YjM0aHV1Q1BsaWQ0RE5rWEJ1eXljZmZHMG1hSitsVHRX?=
 =?utf-8?B?OTk3Zit0dnFiMDlzOG1UNkJyRVl5cGV1aHZWeEpseE5VeUZnejNSbTJPSDhD?=
 =?utf-8?B?RDFDYVpyRDkvMHVua1p1R1c3SEtoelQ5aUJDUXo5ditBWFFjQzQwMUV2VzM5?=
 =?utf-8?B?a1YxUDlXR3BUV1VrM25OMElrV1dGbjRVYWVQaTd3YzEySWdCV2R2anplclZB?=
 =?utf-8?B?MFUxaTZCVFBKSFh1TFcxbktacldSaWJHL1diYzJTRTBiTWxJQktjOXI1Ung0?=
 =?utf-8?B?Z3VJMENrSVIrVUZZcGg2SGNiL1JHS2VMNGNpSzBHL1pUdnRKUHdlSTNreEdw?=
 =?utf-8?B?SW9oTTdUdG56MjRMRThXUU8zNFJQWFdqNklXSFNvNG1Sazl3V0pQdVZuUGRH?=
 =?utf-8?B?OXB5MzdVRTNrKzltTHNEYjBGYzRsVUlCb0N5dHNsQXBsQzhQUjJuN01OZWx2?=
 =?utf-8?B?cTJnUEM5UjNTUmxRVndNNmxidERnVkdtcy8rN3BPSVBOMjdkUldJMFVHWEUv?=
 =?utf-8?B?QnRUVVkzV1U5MFZNRGc4ZkIzeTFadDZnVnFXTTZsbVVwanRQSTE4ZHUzZXBK?=
 =?utf-8?B?YmdpSENxdHkrTm1UaFlvOGVTRVpKU01iWmtsdlJFZklCZGNsakhpK1V0T0N6?=
 =?utf-8?B?QmpVc3pMc0t6WmdyVWhLQjNrZ3drMXpaZDJSY3pxT3YxTk42NVRvYkhITzYz?=
 =?utf-8?B?UEF2MGNodHBTTlpqVmRLdWVHeTUrK1plcTBuUFlKUnNiSnRuWDRlUSthV3M1?=
 =?utf-8?B?amhLbHJ3Wk9kUDBMTkxXbzJsWHdjdWRoR29LSzJ0K3VGdlY3cllvbDFaQW1v?=
 =?utf-8?B?TWNHTDVGZHR6UVJFcDZjQm1pcVdmZnAzN0VabVJ2YzBiUTBZK1dSY1pNK2lm?=
 =?utf-8?B?b3ZHQWhiQnRRQTNKNjRodEU5Z3pLUzVaME5GcGJCZEdPK0hLKy85OC9vc0dC?=
 =?utf-8?B?ME5Yd0w5aE4vK0pKdTFNYmliaHFPRDhYZHZvZHlvTzVuTE9Fb1NQNGZndVZY?=
 =?utf-8?B?MVFoMVdtelRoRE1mUGxhT1ZlaW9Ya0t2UDdOakw2czlLV1p4V05BMHV1QXRQ?=
 =?utf-8?B?VDFRNDlvVXZQVU11V1h4WkgzK0JGMjZodWNlTExaWGZ2OUswOUJkTEZiUHVn?=
 =?utf-8?B?UXI5U1Qvb3RrUzFVSkR6S091NjVBWG5TcFBBeTczZ3N6K0VvN1ZwUFZDYUpG?=
 =?utf-8?Q?MGw9j3WBL2z00Zy0ip7vUhE2A?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0002ef93-5fa6-4258-9143-08db62801e43
X-MS-Exchange-CrossTenant-AuthSource: AS8PR02MB9651.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2023 09:11:00.7505
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 78703d3c-b907-432f-b066-88f7af9ca3af
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8CYJiarhT8uw1mbnG1NMjnxPMYpOu67ZxgWe2is9UtlnSTUtGa2lKgZX7VnIjtPwsp3Jpz3XgV/NnabowK8F2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR02MB6025
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/30/23 19:28, Andrew Lunn wrote:
> On Tue, May 30, 2023 at 04:52:23PM +0200, Andreas Svensson wrote:
>> A switch held in reset by default needs to wait longer until we can
>> reliably detect it.
>>
>> An issue was observed when testing on the Marvell 88E6393X (Link Street).
>> The driver failed to detect the switch on some upstarts. Increasing the
>> wait time after reset deactivation solves this issue.
>>
>> The updated wait time is now also the same as the wait time in the
>> mv88e6xxx_hardware_reset function.
> 
> Do you have an EEPROM attached and content in it?

There's no EEPROM attached to the switch in our design.

> 
> It is not necessarily the reset itself which is the problem, but how
> long it takes after the reset to read the contents of the
> EEPROM. While it is doing that, is does not respond on the MDIO
> bus. Which is why mv88e6xxx_hardware_reset() polls for that to
> complete.

Ok, yes that makes sense. I could add the mv88e6xxx_g1_wait_eeprom_done
function after the reset deactivation.

> 
> I know there are some users who want the switch to boot as fast as
> possible, and don't really want the additional 9ms delay. But this is
> also a legitimate change. I'm just wondering if we need to consider a
> DT property here for those with EEPROM content. Or, if there is an
> interrupt line, wait for the EEPROM complete interrupt. We just have
> tricky chicken and egg problems. At this point in time, we don't
> actually know if the devices exists or not.
> 
> 	  Andrew

It just seems like we need to wait longer for the switch 88E6393X
until it responds reliably on the MDIO bus. But I'm open to adding
a new DT property if that's needed.

The datasheet for 88E6393X also states that it needs at least 10ms
before it's ready. But I suppose this varies from switch to switch.

Best Regards,
Andreas Svensson

