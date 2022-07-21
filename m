Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5F7C57CF3A
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 17:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231135AbiGUPe6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 11:34:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231394AbiGUPei (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 11:34:38 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2049.outbound.protection.outlook.com [40.107.21.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B99F882135;
        Thu, 21 Jul 2022 08:34:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i6Urz7HgDv+7Qm4YiHkB6FTDrPRMj6gMUitwXiy9snabBpoV/hkcs4YzEwSNcX01jc+hShrYCRskNuR4j7jp8574XgnagJq++MMUb2pyePIbNeHGCgLkNqPdHrouJpXsAazpan0sY7A7YJM99U2/2KIGq7GGuSP0jYsD8GhnfBcsv3iL8e1WawbsrmQbI4OpchaARn2O+6/x2Hh8vp1u2lG2oecA5zK3xtUaPLz2nu9KfZs29GGbdb6ssQbm0nyUAVUHc8waqXY/wUexqRSCJ91c0jQpqnFIbbkZJj7uIafhH4m1DuG8z5BtQ9g2SlWF6eovcYMuY6rkj22DV70SpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ExAIxaDlOg5+y4++MaIEBuAAqTtvPNkG+WkbRzHDR3o=;
 b=jNf5HlPDtJP1aM5IhaQ0a4xdXPQWf/iVy83R4y3V77b3OqD+6bjeGrd8DzFyhmQtqQ2u9TdQnLHFccowIdktJZRt/e2uGAkGTdKb+j0h5LK6qvN0K8MBF7X4vizrthOcgovTrvoQOyB9nK7CZtOktyWJWfkJn7+mpDIGFKJGfSi1vii9P5HfxpQNs8enF+zJcKazDWIMr+Hf5t7y5ax0raqGkrCucksrdbvJ4dpdXn0wSq2P6HHCmIxG6ehir3NVMeOn/p2wFNvymj53k5+6Rht+7FnQyK6XvXWPRdW/5H2SjxtSFUkLHM2IjJ4GltPJVYuxdzB2oD88kOrH+Xd+dA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ExAIxaDlOg5+y4++MaIEBuAAqTtvPNkG+WkbRzHDR3o=;
 b=Sgwo9+ZWhh3lQdG/Y68ADjpTIxLyPIoCbfTNFEkz23vzdF2n3kYw7e2S0cdh+ZzlX2325CqWTnOmW1oubfv1hwXj0/JvAxoMaWGbX3am+q4Jh5xtQm+MM0Mv+PSvIz0QYFuAsq3vNRIFFbwJom8ztS9qOijHlWB7mpoPJuqrC8wdcF50GmnknJeSt877GuTldBdqBcgbcQjaHZXLqb/ZBd8/UQhW0Eap4Tcf6NaFRDa8QOrV/8LhhXWu+zql4m+Zme3LQsqTEK9YtUyZps9TnEsCJKt5RsB47Ele5IOO6Tv2fuQ/kgBRL2cMV8wM0nMzs10R1xaAaRfut1Dl4ThoFQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB7PR03MB4076.eurprd03.prod.outlook.com (2603:10a6:5:36::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Thu, 21 Jul
 2022 15:34:32 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b%4]) with mapi id 15.20.5458.018; Thu, 21 Jul 2022
 15:34:32 +0000
Subject: Re: [PATCH net-next v3 29/47] net: fman: Map the base address once
To:     Camelia Alexandra Groza <camelia.groza@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@armlinux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
 <20220715215954.1449214-30-sean.anderson@seco.com>
 <VI1PR04MB580763F33F7EFB0265DB1C40F2919@VI1PR04MB5807.eurprd04.prod.outlook.com>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <ffe0a1ec-4ff2-ce98-6eba-7d9e5ec8f04d@seco.com>
Date:   Thu, 21 Jul 2022 11:34:29 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <VI1PR04MB580763F33F7EFB0265DB1C40F2919@VI1PR04MB5807.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0287.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::22) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 69d55d5e-ad73-4468-c998-08da6b2e8242
X-MS-TrafficTypeDiagnostic: DB7PR03MB4076:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 67/lhsFB3n1cjqEJjJriysznslHp1yt4ogawN5bDT0R/l0bfdloyddc0Xqam4gM7yDPutzHdC1fO9uLxGdczuhNhZFHXhOljGemJgBJJQybXvxIscJ7XsAfT2lwuu/BJ8WzEwJcGm/ecxGHuyB2z2ezMUZbrX/QZ2og6/zNrYuFTrANs6EkLClPElI4HRweMAXnvQu+7XJYYAYU402MBiLncgSaxZ1semCJcNQaYqjHDRdyV6Wiz9/Gz4iGfMsuFQeh7h6PkCTN7fJbrQp1s50nMPFU6lblu5eqwbXPeZjsq8ZSVQi8UTayMqpZZ4XWbI8PvhuhJKfAjYi+0XHf1aS0jIdn70tCfDE7oFRxyruFFKPA73v7BBx5NBMRW4NmYkuKGYB/pC8r4PSrx1sl5TIDr9LtTc6B4O/K+nAsKVzfy/H9IqPi+FjCxynNjMwWJ2vCO/7BPGj/27ROw0D3LXVproisBllLQ6ZJ+IbvbNR5Qc+QAskq3xHfP9TB6qDpMBFa+2LmJqp1ZYi2qfliNMRdbffE+Y091QGy2TT5n2guaKAh9Ccfxiy9xoe6w81yKBx/IujTPJjSzgFb4V6aDB+UasKFqpVsxA+1MX2rqVSFNapkSgS+cKu/YwpgLAiIeNWbKthBEaNBiLYjsM4Yujdz7vxEbYV5+bYbqoAPL6j9j6XubCg1E/98SjrWHhHZ5p8GWrwaoQbEZAL2jf9GtH4+LUyX+CT3h8YIOgzu3JWXwPfNfUWNezukoOnfrdRBCfASJwCJ/6G32LoJuyw4+kQXg+DDjmog36V4pzZeG3zTS/v6vwGXAbnF+S00xbBQUrWqL9leebhhl9fyWs/3/lu9gsrQxERw5C2X4UG3qkuA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(396003)(346002)(376002)(39850400004)(366004)(86362001)(31696002)(83380400001)(38350700002)(38100700002)(4326008)(8676002)(66476007)(66946007)(66556008)(316002)(54906003)(52116002)(6512007)(44832011)(53546011)(5660300002)(26005)(6506007)(6666004)(8936002)(2906002)(36756003)(2616005)(41300700001)(110136005)(186003)(6486002)(31686004)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M3dtcnhaU0IxV0hKbTE1NUpHRS9IWWZYS1VyTUFSNWNKMSthOE1zRExadUtC?=
 =?utf-8?B?K2d4Y3ZYRlFwa1p2cWF1b3p2V3pMeDJxQVRlZjJvd1E0Um8ybDloazBFM3V3?=
 =?utf-8?B?d3cxeHVPMUVDTFdpQnpEYWJUdTdnUS9IQzBsSlQ1RnZyRVdjSmcrSHJLSEZs?=
 =?utf-8?B?ZEwwU2JLUTFxSFRGa20yWHo2cmNHTEJRZDBUaXpuMkZvNkZuUWFiY2E4Q05V?=
 =?utf-8?B?NStCVVV5NXVNZjExYWduRHJGdTg3Nnp6UzArZFlpank5ZE8vVHBMblhQRXdh?=
 =?utf-8?B?VjRDeE9TV0hrRHoxN3NVWkVQSjFPaDh5N1VGTDF2VFVmRmZZNFJWaGdhdVNB?=
 =?utf-8?B?SnRGYS9udzhtNWwycmR6SjlocUVpTjhodjYxRXFzb1IxaHNtSjlSVmQ4ZXd4?=
 =?utf-8?B?eklGeHBIUGFZVjVIbnRNaGp2d1dVdHp3MFlIcFJnR3k4c2xjSjFKWG1mOS9l?=
 =?utf-8?B?UkN1QStDcW5DcVdVU3IxSng4UDk5TERLREFyeDVGbzdKVlBvbWFpRGlFVGtZ?=
 =?utf-8?B?d2JoK1RvWFNRTnJEdFFlUTVTN0pnOWRvV1UwWGtWMnVDZ1FyUkswTEI2enMy?=
 =?utf-8?B?UGdpdk1naTJJOGdvY2EyYWFzbks3TzdGdmtqSW5CMlVzMUUrcXVyUko0aUJt?=
 =?utf-8?B?S0RsQjVZdThVMmpRYTArdkp4RmJoT3YrOWYvNFU1VFNHSWVHRjl4MkMvMlhO?=
 =?utf-8?B?SlpsS0twbVdsYmI3ZGRnK3RtY1JmNitMMFpVajZDSTlYL1lRNkNkVVZ1Nmpx?=
 =?utf-8?B?bTdSNlFXQUdjaHhOTi9zZVZrM3phbk1GcHJqNmFYZmNYOU03THBFUGhWVnFv?=
 =?utf-8?B?bmNJZ1MzUENvUHh6bmJpQ25UMm14emhYTmgwTEY2dVNFSHJiZ1Y2MUYvRXhW?=
 =?utf-8?B?aDN4VGNqUzN0WkhWamlJMVlHdXE4cTBrMncyakJVNWU3dVZVWndiWThFVm0x?=
 =?utf-8?B?VUZBM20vMWJoZXUyT3d2VFRoQkM4QnJ2UjVVQ2dOaHFaUHJCTWRUUkZVSGUy?=
 =?utf-8?B?ZWFGb0x0andFU2g0cVZKUTNnL3Z2UXg5RnhXNTdkbk5uNGtZVzZaTHByaVBH?=
 =?utf-8?B?SG43MFU2L08zSXE2ai8vNDNtUldqVlh3QkpOOWtGVDd6MmxTVlV0bTl4dTlN?=
 =?utf-8?B?amIyTGRxTVRXQzN6TWJvVUNpait2a1FQMlRMaDdkRFRMeWl6SE1ZM0l3Zzc0?=
 =?utf-8?B?elJSMGJpZ3JHaGk3SUt4SXFqT2t4VHFpTW5xaHF5VDNhV3lwZTg1dkVJTFhR?=
 =?utf-8?B?ZUVhazV5OTdpcGFhdnNsRlNhVFRWcGJ1NXAzNnZ6cjRpL2RobjU3Sm40REFE?=
 =?utf-8?B?d1l3QU1qaGtDejNsZ0xXb1N1bFllbUVMSTNnSlNDdXUrVXN1MWZ1bVMyRHNY?=
 =?utf-8?B?UzBXOERTV3h2Zm56YXB0RnA5RUh2NDZUNkFjRUN5dFY5SkhVcGVJdG0ycFBK?=
 =?utf-8?B?WDR2QStnS1Y3dGFmT0ZIMWRJZUh1Rm03bXRTRzllN2lDYXpKR0ZnQ3Z3VUFm?=
 =?utf-8?B?WDJhcXllQ1JqYVNLMHVIRWcwcENXUGFsZE1jUCtDUUd1ZmxMOVM2TmV2Y1Vx?=
 =?utf-8?B?cXNRR1JBM1dZRFN5RXRNUTlGM1Q1YkpqWDZjc3E0MXJYeFJ0WGF1a3NKcUJj?=
 =?utf-8?B?R3dOQjFNVDM2Z1d1eHdLOW5PVU5QUGhHaEJ3SW9XOG9pQTB1S2JnaEtGcXNT?=
 =?utf-8?B?TGZldytFeEMyTTlRekN2UE5jT0lzdExZUnhITFBSNVFwb2JhR0ZZaTQvNWdy?=
 =?utf-8?B?TDE3bmxlZWQrNUt5elZxV3ZWZytVN2E2SVU1eE9yRC8wUnR4c0ZjaXlleURO?=
 =?utf-8?B?amtvaEIwbXJCZkJYU0k2TjBWZHM0NnlEd1dGQStveFo5cElndnhvc2o1UHhQ?=
 =?utf-8?B?UnpmWkJoNWRONzByUGU5ZHBxZjhqcFFnNzFUT2oyOVZkVDFvTHVsSE94S0lW?=
 =?utf-8?B?bk9YQ0t4SkxvcUVpSDc5c041QkZCRWNiWTBmdmp5QWJPVGtpZzkyaG5jUUww?=
 =?utf-8?B?cmtab1d1M2RWaXE0SmNQVkFHNmp0UW9kYVB2VDJVTUhRVEw4Yi91d2U1ZEI2?=
 =?utf-8?B?eE5YRDg0Zkk5L1NCV1lIL2VUNjkwYzJqL1VIRVFKUjJjZFhrcDE1WGlaaTlD?=
 =?utf-8?B?TEJHTUkwWW9OUW9KdHlUbkRNM2x6dmc1VEMyVm5LcWRUcXE5YndEeGRHdFcx?=
 =?utf-8?B?Tnc9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69d55d5e-ad73-4468-c998-08da6b2e8242
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2022 15:34:32.5522
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uvSyjERQ+ls9jsi60tfZxyK7fGQ6vW1/8ndLpJkXg+mtqPK1hXtbRue9+NGaV2rfPyGNXe2mmaWKUvkxniaZbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB4076
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/21/22 9:04 AM, Camelia Alexandra Groza wrote:
>> -----Original Message-----
>> From: Sean Anderson <sean.anderson@seco.com>
>> Sent: Saturday, July 16, 2022 1:00
>> To: David S . Miller <davem@davemloft.net>; Jakub Kicinski
>> <kuba@kernel.org>; Madalin Bucur <madalin.bucur@nxp.com>;
>> netdev@vger.kernel.org
>> Cc: Paolo Abeni <pabeni@redhat.com>; Eric Dumazet
>> <edumazet@google.com>; linux-arm-kernel@lists.infradead.org; Russell
>> King <linux@armlinux.org.uk>; linux-kernel@vger.kernel.org; Sean Anderson
>> <sean.anderson@seco.com>
>> Subject: [PATCH net-next v3 29/47] net: fman: Map the base address once
>> 
>> We don't need to remap the base address from the resource twice (once in
>> mac_probe() and again in set_fman_mac_params()). We still need the
>> resource to get the end address, but we can use a single function call
>> to get both at once.
>> 
>> While we're at it, use platform_get_mem_or_io and
>> devm_request_resource
>> to map the resource. I think this is the more "correct" way to do things
>> here, since we use the pdev resource, instead of creating a new one.
>> It's still a bit tricy, since we need to ensure that the resource is a
> 
> *tricky* typo

Thanks, will fix.

--Sean

>> child of the fman region when it gets requested.
>> 
>> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> 
> Acked-by: Camelia Groza <camelia.groza@nxp.com>
> 
