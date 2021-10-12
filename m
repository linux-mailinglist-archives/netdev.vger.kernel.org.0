Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FCCA42A97F
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 18:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbhJLQhC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 12:37:02 -0400
Received: from mail-eopbgr140048.outbound.protection.outlook.com ([40.107.14.48]:57358
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229495AbhJLQhB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 12:37:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LxUO4r/aAETaUTrr7IifpkofdivNRVX8YECjCMeTxs/pB8h4cKye7tpdpashRM2znJPoO9C77YwIqHaX8b4FToAIhmX6ZUI4PnWIjWWRXfxXBMUvgJVAH4XHZaAlAxZsv2GaNW79s+bYITGbu+4s9c0o2qbSUFT23cbcQoftbKeNCapUXYrk4ymY1ysVT7qdNM0GgMXf+7S7jMBYxpJvFxoNxajJwncSbVWOnutMTKfiIDNBfSBN2Y1n+oy10+7sWj3ijuBPCThbF7ejBJraTnY5iGmB4C/WljCJ8QEM86LqHoJ94qLWyJKBLUq2kSrsl9qcKYnHAa5qbKKYuCVZ6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zBAMlAUGwmIPL8YpN6c9rmdQzQVXKhiEA28Y4B7aVEY=;
 b=S7fXHgkH1+dyFDN4PsUY1qe1FKTMPkFkd0qKlR6/049ndqOHPZPqO171fEJFn0NE8hDzUDAuEky0LWEczz3pDVP+5XWdDJDJJ5LYrhif7iN8r8IySYMmZN2YiSEcsplOczHb1AGlR+jbDnyFM7yB7h76+V0UBWTv2H9YWzLEnG9L7e5yu8LLOfqj4chLuSZfhmeB6AdvHTAaXmBMj45C+NK6uAI1P5OB9Oj3yk7MRlF7nBY+FYp97fiIiqpRwYizqS0l8uU14IZcqKaYt/w3LGTTmpmiff8CWfyuJqTGPiW/tbbYs/bVYvAS9jqxsABNKN8GTO7nODHYBVUwJsddWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zBAMlAUGwmIPL8YpN6c9rmdQzQVXKhiEA28Y4B7aVEY=;
 b=RQIornx6gfPV3Kpv+tu/Em9Eu/n8f7rbjGYBkv5aK4MUx5fdNbhzvoiO9+U7gL32gJGoiGlvI2yElPOOV79ZyAw1+r/0BkAsgmDwafPtZ6eZB1pcUMCnJiOmsBVPT4k++f3MDQ7fCHiwk8JyvDcYZ7huMKARAVMV6OAzGZqbX/k=
Authentication-Results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB6PR0301MB2181.eurprd03.prod.outlook.com (2603:10a6:4:46::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.25; Tue, 12 Oct
 2021 16:34:56 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf%6]) with mapi id 15.20.4587.026; Tue, 12 Oct 2021
 16:34:56 +0000
From:   Sean Anderson <sean.anderson@seco.com>
Subject: Re: [PATCH v2 1/2] net: macb: Clean up macb_validate
To:     Antoine Tenart <atenart@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
References: <20211011165517.2857893-1-sean.anderson@seco.com>
 <163402758460.4280.9175185858026827934@kwain>
Message-ID: <419c2d47-4748-8ba4-613c-cc99558eeb48@seco.com>
Date:   Tue, 12 Oct 2021 12:34:50 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <163402758460.4280.9175185858026827934@kwain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BLAPR03CA0013.namprd03.prod.outlook.com
 (2603:10b6:208:32b::18) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from [172.27.1.65] (50.195.82.171) by BLAPR03CA0013.namprd03.prod.outlook.com (2603:10b6:208:32b::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.25 via Frontend Transport; Tue, 12 Oct 2021 16:34:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 294056f7-dfd6-46a1-337b-08d98d9e398c
X-MS-TrafficTypeDiagnostic: DB6PR0301MB2181:
X-Microsoft-Antispam-PRVS: <DB6PR0301MB2181877ABB4AB24635AFCE0896B69@DB6PR0301MB2181.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PG1geAEJrsiwCD1DWtdT1lOcmhJh1d9Y36/1E9VML0S/ajpcyH/QpNhKuFFew7ppULswKt5YXbQF6VR6vZSfyCslhlrwV2sGN75DQYXpL0hmUtQhbvcuqNx746jxZ4m6yxsq3sQUkYTB1dnbSolvbyhXDTeOmLFIHWRar98l1NvOllBTQ85SyD+oxvKGqWv4Za2QntHbt9DYs6+/4lNIqE2sdDbBMjFUWw/saml57gGajtTs/j9vP52iT0M1x7V1PsIkYtpgESoY4Bwa6+uBIFLqkRasny5zSgHvdgtQs7U2bF6zMtjIKnNvwxduSz/40RQ5I/IFPWv+lQmesg3NaXi3ksfs/PxZ099FPnzaK5TlHUsKFaKzi1A8N0EzzTQtHDTR5MF9LIsDBPH+mpMzNxf2Eax6CgDqaij5/epg+SyXJXy60+rDP4qAWkDUjDPjQtMX43MruZRyqZoFejDNPSp2Cx6G0cYGV31m38pqJ+SO3ONW4+/eptovpKlTUqFuYlo4d2RCeKwTb8sJ/3yi5xHvDO0VXT/nry55wYtF3zaqAI/Y1A4NWTnPXNu04PiaXH3nIqQerupd63tV5i+3bFqlEwgDLEPb0+T01ZuO/zQt5awtB2Ua3VuBjkUdtRXi+MNtXIy+BPLpjO5xFAhyXZPYW9CPohYNyAmG1n7fZWaWAaSxR+bEu/jXkjUICO8Ffx5+QfW7UMqyUkPZHDqvxzjaekslBijlTM1HjaG6jT8FCF0G7dF15/UKNsWH92E8D3TC0NLXf5mwj7i/CSRSWg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66946007)(8936002)(5660300002)(66476007)(26005)(44832011)(316002)(8676002)(53546011)(186003)(86362001)(66556008)(54906003)(31696002)(6666004)(110136005)(4326008)(31686004)(2616005)(38350700002)(38100700002)(36756003)(956004)(6486002)(2906002)(4001150100001)(508600001)(16576012)(83380400001)(52116002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NW8vTVlDR054WHRjVTJSY0NnQjdxaHZFRzVwT2VsSDBTbmtHd1BSUEZiVnJ1?=
 =?utf-8?B?Wnc1RTlaQ0drT3JpZGRUYU1VUjZId0Y3QW1lejNucS9XRW5QMUwvekNnUnRD?=
 =?utf-8?B?YnhUMEtFUEhkRGFmL1BFZThKY2dGVnZsUmRKZ0VxMnlnYitBMWxMZU1GTjFi?=
 =?utf-8?B?QlNqeW92UjV6WTJvN3JGTzVab1JwZWhCMVFQOVJmM3FHMFkxVUg5WkR6R09x?=
 =?utf-8?B?ejNicmdYMkFORUZMOXlXaDFxc3Byc0NSVjV3M3g5M1dwODlpWlZGNk0yME5P?=
 =?utf-8?B?dXl3c3U2bHRKUHBoWk9zM2xtaU9OMXJCRFR4YTE0K09mNjNLVGxkSHp4RGt2?=
 =?utf-8?B?bFp1Vkt1ZUZFVFNYVGYwd1R6OFVMRGQxV0xCak9FbzFPeXFZK2NzeUJrbUZi?=
 =?utf-8?B?aG16K3JRL3g1SEUzb0tha250M0xMOWo3Z2xGR2FtWWZNcEh2WXlyV2lUYzlN?=
 =?utf-8?B?V1ppSjdDamJkRlVpWHJrS2VIVzRPdzFNOEVpN2NaM0dISzdBR0psd3VVMzNz?=
 =?utf-8?B?VjZ2aWU0YzJVdzJnQXNBRC9aVmtkY1lJVkltRHJ6elRuTzdySWdiWTFSVHpP?=
 =?utf-8?B?WWpGbk5DM1c1c0VCUTFCak1YOTNCeWM1bnZHM0VEZithQ0xaV0s0RnBrZUVQ?=
 =?utf-8?B?VitXN2xPeFVNd1kzS0krL2E5OEpWU3NUbWI3R2tZRzRPSXFvNDlEQmJnaVpz?=
 =?utf-8?B?T1RNUjdIRnVtT0xidE9UMVdqMDFLc1NaY0xvb1BzTStJTjgydjZNa1ZmOUtT?=
 =?utf-8?B?R3pOWkJDZFJnR2huTW5DMVh6RzNockY3QVp2Y1piS3hWeWo0bEtXK1NDOTNN?=
 =?utf-8?B?MUpoY2VSbnZFSC9hT1ZJRnZvSFJBM0JjQ1lHejAzMUFKK1hDaElSL3QrTE4w?=
 =?utf-8?B?V1Nvc3Z0bHhGRi84OFhkNGdDdjlyWTNMbnRtaEZ0cHVmMldrbUdrVXdxZVhO?=
 =?utf-8?B?eW1hUm82QlozWjVEa3FKTktSVmJXS3ZHcS9meFVqanZvUysyWngrdERsY1Rz?=
 =?utf-8?B?K2FPclhKL1YwblF1WjZkS2cwN1RRSStWdFI3Rnp6ODgxRmxkRVBTZVFscnRx?=
 =?utf-8?B?VVVzSEVpVVNjdDJGSDlvc2FGRmhLMGpCYlU1T0Q2a0F1akZhN0VrdHljbDdK?=
 =?utf-8?B?aDJxVU5kdysvMm41d2RMRzkzVU8zemJxaVpNMGRaSjhXdzZ2d1hUSVVNRWlS?=
 =?utf-8?B?RUUwUSttb29oYjAwQUM0QWM3TFhqcGZWUlFqWm9WeUEwS293U2JBQUdaVXZt?=
 =?utf-8?B?YWhCSWxOTE5INlZPdTdwcnc5VTFDd0R5Q3BseE1pLzlQNE9rMEUvSnhIMkxW?=
 =?utf-8?B?RS9PNFJVOGVaRmtjdDhSaGxLVzJ1UEZzd0daT09Ca01yYjM4VHJpQ1FQOC9S?=
 =?utf-8?B?bkFZSkFncG1tZXNHeXZzMWhleTlsL25VSk5uYkR2TS93M0NnanB1QVRueTZw?=
 =?utf-8?B?SC9CMVRTSkdSNS9VRVVYQ1Q0NnFXMkFJWkNDd3FLeFkxQzZKbXV6VXhSUTAr?=
 =?utf-8?B?QXRjOWNhNjdlR3FVSURsZWNRb0xHZTFUZWR5bXV1ZTJ6cm9LZ0h4NUduWE1I?=
 =?utf-8?B?SHBBcTUzd2ZJVkhKK2N0bEJvVkZReEp3bHNlWTVDT0V1OVMwU2tycjVQNGZZ?=
 =?utf-8?B?RnBQZlBvNytKQzYybUEyVWhXcVJidnFjcVlyNlNTdEZkR0s4cGtENE1EQzUw?=
 =?utf-8?B?dXlmTWJ5Rklab3VmODNYMllmK1RkcGpYb1lpeXdMVmdqODZ2TkRxck5jQktI?=
 =?utf-8?Q?OV0pTlG6TpeM1hJTGnpgNJDtafRR94YwNr5uO4y?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 294056f7-dfd6-46a1-337b-08d98d9e398c
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2021 16:34:56.0274
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FdDDQnuXuIhE5WiLk1/qwlfC88SpH36YLkq8Vq3YqwCBsdjKgIRw3Rie3mVlC52TX/KL5tOQPBa17HJTq+yHHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0301MB2181
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/12/21 4:33 AM, Antoine Tenart wrote:
> Hello Sean,
>
> Quoting Sean Anderson (2021-10-11 18:55:16)
>> As the number of interfaces grows, the number of if statements grows
>> ever more unweildy. Clean everything up a bit by using a switch
>> statement. No functional change intended.
>
> I'm not 100% convinced this makes macb_validate more readable: there are
> lots of conditions, and jumps, in the switch.

The conditions are necessary to determine if the mac actually supports
the mode being requested. The jumps are all forward, and all but one
could be replaced with

	bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
	return;

The idea being that the NA mode goes from top to bottom, and all the
other modes do as well.

> Maybe you could try a mixed approach; keeping the invalid modes checks
> (bitmap_zero) at the beginning and once we know the mode is valid using
> a switch statement. That might make it easier to read as this should
> remove lots of conditionals. (We'll still have the one/_NA checks
> though).

This is actually the issue I wanted to address. The interface checks are
effectively performed twice or sometimes three times. There are also
gotos in the original design to deal with e.g. 10GBASE not having
10/100/1000 modes. This makes it easy to introduce bugs when adding new
modes, such as what happened with SGMII.

> (Also having patch 1 first will improve things).

Yes. Some of the complexity is simply to deal with SGMII being a special
case.

--Sean
