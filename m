Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75AB2549B98
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 20:34:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242600AbiFMSer (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 14:34:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240768AbiFMSeT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 14:34:19 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140059.outbound.protection.outlook.com [40.107.14.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D32B2F648
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 07:54:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S7AH5fAYyL19ORkscuIZZWEHO22QYTeOPgq+3XSiGecwQUIMaXbcfmsj4xmB6EaiSfaUlCf5PaO7BLFWnJylGTBADuCVl3nQCXojzbBHBGDXfYfNdFrACz2Fq3TlujO6khJRWNkCllRy0jAx/q0QagQhk4+qNaDEmzQ8Pu2il6U2X5ZLvl9ogUKtNxkzbi+E4Toa7BcL3G2bxro2jAauqNY1rmhpsdBA0af4oNU1+7IxackQhymb+SctiPCu/zHxje9lX0RP9/gRks85cbT7wn8X3kwbUHzdfqWMS4qtkwGx8rBoNiTzxvLMv7idP1J3Zx2rX35ySIcJ5TkC7lJB8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S6izWlJ/Y/ByMiLwMOFmkgLK4JuXbUlbjNdrjkEdGdY=;
 b=FSTIxNBCFW/RrtQkmjVDpfOCn5BzDA+0YFcCDCjvAZFp2b5hnpXDsdGAJCwhBr244jQqT9/5tAKPurEBXSHDFSVY48JL5zjiV1AuNg3JBf1R3saqbrPi8n/OiEVUVMBEmQ3ALKXYejS0+n71sU9WWyj1sYty+Jjl2aKXhY3UUj/cEr35dXYV06Tds16ArNpWPyR0+Cnskl1JuwQnuX2p2ZLXNm3d1P35O6pJR5mb+uXffXp5O6IPxuZ9AXjW0CqxIHuKoARXLND9QPRcMllT4jqfH8fqa+5CK//RrPvgzxPLQ4iD68qNufWamAWZVU2VNVVuMyp3wAN/LH2YAy213A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S6izWlJ/Y/ByMiLwMOFmkgLK4JuXbUlbjNdrjkEdGdY=;
 b=2Bw7rifz1F4Y1fQmUMqvj7xpx28fVvqmiTGFMq2pD3FduKZTs8lWyl1tgiTdfOrotgEj2OD9MBJte1r8wtM93W3b4BU7bdy8Av4fZQwR+DxAsqPp8nsDrZld4EGo/VtM92/pR2Ak+D5NbZSkSqYVbDFSoXQCIZ0Ag/oicQPg8wjgjwpBXdLu1k/FiBDoI4VkqpEx8HtM1fHaf32+/x4AQioEsV9nQDDoXrKXKbovEwg5RDZuwXDem9h/w1Yw+bDk3dLdE7PUEso8HUaANd2/2HoJzTavdPufdlH3KlEnd0zoAZYibb+IGXDKtIyNvJ6C8m/Lu228s9YRJvDDrxa5Vg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR0401MB2526.eurprd04.prod.outlook.com
 (2603:10a6:800:58::16) by AS8PR04MB8214.eurprd04.prod.outlook.com
 (2603:10a6:20b:3b0::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.20; Mon, 13 Jun
 2022 14:54:19 +0000
Received: from VI1PR0401MB2526.eurprd04.prod.outlook.com
 ([fe80::19e2:fafb:553f:d8c]) by VI1PR0401MB2526.eurprd04.prod.outlook.com
 ([fe80::19e2:fafb:553f:d8c%11]) with mapi id 15.20.5332.020; Mon, 13 Jun 2022
 14:54:19 +0000
Message-ID: <99a069df-6146-a85c-5fed-acffc4c4d2d3@suse.com>
Date:   Mon, 13 Jun 2022 16:54:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 2/2] net/cdc_ncm: Add ntb_max_rx,ntb_max_tx cdc_ncm module
 parameters
Content-Language: en-US
To:     =?UTF-8?Q?=c5=81ukasz_Spintzyk?= <lukasz.spintzyk@synaptics.com>,
        netdev@vger.kernel.org
Cc:     ppd-posix@synaptics.com
References: <20220613080235.15724-1-lukasz.spintzyk@synaptics.com>
 <20220613080235.15724-3-lukasz.spintzyk@synaptics.com>
From:   Oliver Neukum <oneukum@suse.com>
In-Reply-To: <20220613080235.15724-3-lukasz.spintzyk@synaptics.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS9PR04CA0064.eurprd04.prod.outlook.com
 (2603:10a6:20b:48b::17) To VI1PR0401MB2526.eurprd04.prod.outlook.com
 (2603:10a6:800:58::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 64e1b023-1141-46f5-5f2c-08da4d4c97fb
X-MS-TrafficTypeDiagnostic: AS8PR04MB8214:EE_
X-Microsoft-Antispam-PRVS: <AS8PR04MB82143FFAD8869E01E33654AAC7AB9@AS8PR04MB8214.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O+LynJ+gAnANWjHZ8fn8atEw289zzHQIjSgIth2id8UmG9vVb+4ERUqx8I8b3GCOeU7ZnPlQQVg6cWlEfMkxPOahMx/0YW/HIY4/i1JS9eLJkSpRa80Zua6wPgz6m54g+7bBwiWpEpb5eqx2Ev51wEBg8YeyqOxt5kLlZeC0y0x0g2LEVNzCU+fWpiM1LTIkCpz5vjvI4Y1iQDerapNu/vR5XbmJiwYvJten47JvDeYnv7tlEay0W+K6m7i9qmZ5Si4aCf/hAr1mO5jpUNgkUSDZLH0BwbLZLHWMFTV22ICBS3wCYgz2vmfdwSF7uwJ/LZMH8iF9bg6aB23/pEYMhgNiq6mIeC1vYGK3ci3hrtlPkHJaexWnKUfwO3tc2vA29/fOF7guClatfrRtrHLix/SMl3+QcR45aq+S5urDdUmeO3gLLn4UhU4WxMEB/Yade34wvv/PEGeIIiwrS/kdgWravgUul1Gf8H5LQctxQSFa+kgvDdLCUeaVKWWFFMGKFoTqjj391r9+gy++3nMCPYIr8Y+PF5Vmpdf8BsTyW69nLp67aTJ0EMO9Aj5r3oBDV5asDabW/0k64G8dkBk6MfmIinrry0Ee3ox635wmCivHuEFHmbPxM96WYprhOdElKSgCxKzTUSQYg0e12QkxU/k9c3ywYIardhKH10t7hJiLUUg5DQQU+DZ4yaXReaniXBfOwS3RzFoIt6WZHqA7wNT1kyzGMQB4ytfJJJqXPWM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0401MB2526.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(186003)(31696002)(8936002)(83380400001)(6506007)(38100700002)(6512007)(53546011)(66946007)(316002)(6486002)(508600001)(66476007)(4326008)(8676002)(2616005)(66556008)(31686004)(86362001)(36756003)(2906002)(4744005)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V3kwVGtuM2cvQm9PWDFFVjJJeFhSWjR5bXFzaFg3eDhzY1Z1LzlOeXhVUVM4?=
 =?utf-8?B?c1o4eUd3VTBsRVhPRWFvcjV4eGE3Yjd0YXVEVlpXMnJTczJiNFozZEhOSm0w?=
 =?utf-8?B?dXBRVEpUQmZsSzhrNTBabHRwbUdTWDR0V0xkdkZnVUlqOGtuRkJ4RlRjVm1L?=
 =?utf-8?B?NHgwVklTajZueGRHZE9OUXBWWUMwN1NBNG94RzhxVkExRU5iczFGRzNKaURF?=
 =?utf-8?B?c094M09YNFY1OVZubWE4SG1yMXlzZzY0c3hYVFpHY1FGbVRrYzBRS1N6eWwr?=
 =?utf-8?B?WHFNd1RRb25jM1F2Y3M4UC9vMDlTVVpGMGh6aEsyUVN5RVROT2dzMVN3WllB?=
 =?utf-8?B?c2xFdDVmNXB6U3owRkRlb1k1MjYzSUxZNzl1d1hHVU9kYzRvTGU1VEFsbXlW?=
 =?utf-8?B?bFgzNDFGR3R4WHNqdkJWdG15d3gwUVBrOTJuaUhMa09KNWZqS0pJVFI1OVlo?=
 =?utf-8?B?Z1dlSlFhSStlYU1CdjVKSG03Y2lXSjF1U00vSlNHUnhkcXJlNzM1YSs0ZHdv?=
 =?utf-8?B?MnRtalVQL2JDdENmQ2xyVjRRTWgrM0JpS1FZOEZ3ZU9LLzB5OEt0ZzlNY1Ft?=
 =?utf-8?B?THNaV1duanhkRkUrVE9BVUlEaXBLVmxmcURlbkpXaVpmNmUzclRxU3JzR3RG?=
 =?utf-8?B?ekU4MHBVM2tNSE9LYW1QK0kxc2Mya2pILzlCd2tTR01jdzRuVmJUcEdtcUIr?=
 =?utf-8?B?bkkraWFidlk0eFRXbDNLdUJzbkFiOUx5NDRJeWpGTTZxV3JZT2Q5TXhGelhn?=
 =?utf-8?B?TEluZHp6SGFwK29WdW1XZUFsRHpDV1ZxUWh3NFNSeUdnYXJNWkYvREpNQ0Np?=
 =?utf-8?B?allidWsxU2RpdisxM29icmt3WFM3eWRPbXVzQVRENHE0Rkt1dU1TQ0xIM0Zy?=
 =?utf-8?B?N2lHb1prdkQzenNOTmczem1SdjNmSDJxYUxiRm5pdGlveUhOamF3UEVuRkRS?=
 =?utf-8?B?VG9LUXI3aXJkMDc5dVp0eUIwTlNCekVUN1c0cGJEUkFtTnZCVjFwbnNteXJa?=
 =?utf-8?B?TDJRS3Vua2xGdC9qcElTSzdkVTdkTVRtK05TK3ZqOHRJMVRJSUZ6YkFSSWV6?=
 =?utf-8?B?VlMveUJuVHp6aTlWUXFldXdtbGNGNnJCMGI3bzVmL25OOHlQZlV2a2diYjdT?=
 =?utf-8?B?V0djWDdybWNvTDlWckFvclpQVGJlWWUzOXpUYy93M0FMdEUvTjE4MG1ROXRI?=
 =?utf-8?B?SlRXRHJncWlpU0hoYllERjc2T2RlR01xTWh0WkVxN0theVB3VkthWVFHdGY3?=
 =?utf-8?B?Q29IKzZCNXg5Nzk3dE1YTU0rVFpzWGNnWnAwVG51YU9IRzhmZGhNUm0xSWtM?=
 =?utf-8?B?bkR6bUs3Rkd2SHFOdE0rQlJIbUJtRVJ4NHQyY3BwcHJOUEpHMGZkTEZvT1My?=
 =?utf-8?B?Z2VieXJtZ0llYU5PN2hBamZyakFGSVNrNUk2dnhIa01NbEQyZStJcXJtYkwx?=
 =?utf-8?B?b3lGZ1NqeWcxMHMyeDA0TTlQQUUyUXowMzg2a2VGRVdJcUN2RFFJZnFSQjZh?=
 =?utf-8?B?RWJ2ZTlYNjQ3cWJ2Z2p5aVhmYnJOK3l6eGU1WTJUVHNyTksyZVBSSjFsMXI2?=
 =?utf-8?B?R0N3ZzR3RzMxcDc5N3Iya2Q0UmpWaHZOYlp5eUp3Lzh0TElSczM5c1VQeFpn?=
 =?utf-8?B?Nmh3SWYwckEvYnc0TktPejlXMkIrcU8zYmgxd0dUT21PQlNCTWFyMjg5eGlk?=
 =?utf-8?B?Z1dRZmo1WFJqeUd5TE5pK0g3cGhDdGZwYWZkaVJxTnlJYXpMVjZtNXZ5cE1M?=
 =?utf-8?B?cXZKNzMzczdha1prYnkzb2VLMGc0cFZrMko1YmFXb3ZYVy93Q2IyTWdOSW13?=
 =?utf-8?B?OXpHZ0ljU1VwNTF1eExnSWZnRmZLdVZrV09ZM3l6UlFsRWwva2E3TjVCME1S?=
 =?utf-8?B?YXpLUmVKMnZyQ1ZkYS9UdzhzSFZyVGl5TmpjTDgyT3RNWFcyM1hOR21DTnRv?=
 =?utf-8?B?RGdhYzNpcWlJN1dOMUJBVGZ1b3daV2IybXdTR2dTUGdFcHAybG1JWk1hWVJK?=
 =?utf-8?B?dUtaMDBrUDhSL1NFTGlhb0k1NFI2VENPYituRy9iazA2SEtFT24vMUxwYit0?=
 =?utf-8?B?OW9WdVF2VTFVZ2FtRnkzNG82Yk55N0s3c0JkNVVYUUtUT2dxZHIwQUV6TFM4?=
 =?utf-8?B?M0NEeFRrRXdobjJWckNmTjFmbEpaRU1PbVp3aVY4RU9OWTU2T2c1Q3lJS3hr?=
 =?utf-8?B?bmR2QStHcUk1SDJRMUFqZUxqdDFoeHFJUXBHck0vdjRwclpGRnNPQVA3MFJV?=
 =?utf-8?B?cFA4a3V3dytSbWlZTTJ1WkREemJYOE5wNUtEQ09ydmN5T3QySnNQOHlRcSsy?=
 =?utf-8?B?Ni9obUx1NkNleHdjTlovbklHRUxHdmxsYkFDL0Y5UEJBSVJYWnd5SXRURzAr?=
 =?utf-8?Q?Dl4deSL+oQ+zN719bRpppUmABfUEBzDWI52S3neO5YuWL?=
X-MS-Exchange-AntiSpam-MessageData-1: LFmS+F4t3Emfeg==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64e1b023-1141-46f5-5f2c-08da4d4c97fb
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0401MB2526.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2022 14:54:19.3252
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FhyOKeqxdMCacF28dx7I228WGcXfDQoQu8DwA3VGZlDlilmc60UoCa5kp2olFZ+rFRo7RO7xwSIAG0XocHniXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8214
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 13.06.22 10:02, Łukasz Spintzyk wrote:
> This change allows to optionally adjust maximum RX and TX NTB size
> to better match specific device capabilities, leading to
> higher achievable Ethernet bandwidth.
>
Hi,

this is awkward a patch. If some devices need bigger buffers, the
driver should grow its buffers for them without administrative
intervention.

	Regards
		Oliver
