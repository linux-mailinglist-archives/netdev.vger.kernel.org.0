Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E67CE6CEBE4
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 16:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbjC2OmD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 10:42:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbjC2Olm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 10:41:42 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2070.outbound.protection.outlook.com [40.107.21.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96E3B902C
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 07:38:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NZOvEkh3E/Wfve1Dd2hBBrvBYnW2IaeZCgmdL6OUdUSUULZ4E3/DZSTeibbZMbOp7yLkEqhC+ITNOJf0raRHich90pOXOnDrkznaUMNsiDIhSr9DDNo6Vn2fm9Ri09HkjyMsbDXQPLsXN8fVPkvc21AVgohNFEbFpp0F1RN/PAL2GiIhYdFx1dlulQPA4q+7SgGlwgc+Pm8ED7isWObFy+upW2pYZNmcYbpCbzQG4Kok4qK98U5D1ArdBFQ/aeEcAUsrc0hiFmNzbf5vUQ6iTFilBCEIwjGr1fT/0TD9SniDWcmpAKES/cJBJp+pfOPT3Nko9au86prClX3eMLdL2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W+ce0eG1s4n+kmfizUGJlVKPKWShaVlohzDGUQ4oOGM=;
 b=ay7iJ6YK86KxkNWn33Bhf9OEgwwExs2N5ytjL+9QZyjKJSLMlOQ+ntCCP56MI40w6qRbKIlK3p7u/scUUM407I+P+muOfWE87DwbNeZTSR+r/sr6VAf+l6TRMQ0/Xu9v4tK6QhayE2rHhdYdQtIDDX3OBld4voB9j6B27HHjNx0cJ5bJwpkusGl0z+MV8oBMf3L8zTH+KwXprGZ3gt4akVs7BDOHiM/fx8LecgWKxg+HmoQoWyeKIIVlX3Jb5mMKPrhB9JGC2cnZzvwz0bvyv2s/78er9//ZVIJm/KvHqONWR3TpIdcvMBP3wZ9giafD2MhT10Y9x2IVq6DFm2f2Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W+ce0eG1s4n+kmfizUGJlVKPKWShaVlohzDGUQ4oOGM=;
 b=Kc2vTq8+8p3MwWJSnfYWwVyb6/xEe6XrhgVzUaM7l2Q2U+bZgi9SflSPSu7im42Ws4kFEXptHgqV4xxRQxEloWRgcRWp+bBeb/DjPZ58/2FVw2oouWMBsnl0AHnDn5U5wOOP8HXO8+CzA6IRGgL96dA/uX/p+STYg/UUbE7Vvftw2tdAFXHTAOnUXa7qro/OZLOw+qugylWwi/DVvRuA2Q6gwPFApXojWoHR3z0oAUfKz9s10VN4TBSDGfgeF8yS7pcjE8YU0SDXLaM4pOF6v3E9dzFQT61eVyFsRF1vaRQZ1KxrNgARg+IQVOjGp1B5zC2BJHw7c976k8SuprdYog==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR04MB7104.eurprd04.prod.outlook.com (2603:10a6:800:126::9)
 by AM9PR04MB8212.eurprd04.prod.outlook.com (2603:10a6:20b:3b7::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.35; Wed, 29 Mar
 2023 14:38:47 +0000
Received: from VI1PR04MB7104.eurprd04.prod.outlook.com ([fe80::2ea:4a86:9ab7])
 by VI1PR04MB7104.eurprd04.prod.outlook.com ([fe80::2ea:4a86:9ab7%4]) with
 mapi id 15.20.6178.041; Wed, 29 Mar 2023 14:38:47 +0000
Message-ID: <e998a290-6a0b-3eb9-01c8-ad6beb716d13@suse.com>
Date:   Wed, 29 Mar 2023 16:38:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Content-Language: en-US
To:     Grant Grundler <grundler@chromium.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Oliver Neukum <oneukum@suse.com>
Subject: devm_* allocations and your fix net: asix: fix modprobe "sysfs:
 cannot create duplicate filename"
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0081.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9a::8) To VI1PR04MB7104.eurprd04.prod.outlook.com
 (2603:10a6:800:126::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB7104:EE_|AM9PR04MB8212:EE_
X-MS-Office365-Filtering-Correlation-Id: e6d93d42-ebf9-4694-2b0a-08db30634e10
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gt24+E9+qp3Qxz0+VGps/LJt7lc26aCKzTfWLDx2IWL9CR8nr2n+tP4fcHLaDzq+tdKJfi7rjdVuUaipA9kGSPV0OKn5LZGp5Yq2tGjPvckJ/iS+hFVlHn1drrfBQAqvR8I7bpkYlRCesX+GREnWI6ZJwdc6V5PVe3/3bNNEFAQBN77cpwXZwZFvwNy3oXyXpH7BJIfiIdmlwlabXfeBY3OERscGob6boupNe/ek42fokDRbCdPng06Kv4T6XoOtvGWNttb3tvp8AQsnwB350M9MU2aOVLlUOx9SKvn6WZbudzQbyhnn3QQlC5SkbpTRhrqUb9BVaIkOz0iyR07keKR6kl5Kd4PCGaFlvmBsHbTdQZL0nnMgLffeNt3cS3YpSBPie2o1NuS2PoFa+FqIo+qhop7Reo9qJYeW3lvceIxwZkoRd2+ZD4gjcbKcB8DlbVoDsXFmo7cqDMYLmdln6hMnpsEjzIUWiprhFBRGpDiLFq/rJVIvKnq4HD9RGx5JVSxu6vaVwFZkE+fOKcAYSWAmfG0U92qtXaiMG9dtaitM6JECJroAq3rcdeTs6D46fJgv0apkldnGFBdKTrivliZIx13ffbM6s8u0fV5YGF40iPZy5qHntkqD6vDhL9OlS6jM/6SybFKmHw7nPGK3Bw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB7104.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(136003)(376002)(366004)(346002)(39860400002)(451199021)(31686004)(6486002)(6666004)(38100700002)(316002)(2616005)(86362001)(2906002)(5660300002)(31696002)(8936002)(4744005)(66476007)(8676002)(66556008)(41300700001)(66946007)(6512007)(6506007)(4326008)(186003)(6916009)(478600001)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L1lsTzVoUFc4cGkyd0gyOG9Fa2lMSWluaVNMaC95NStSdTF2d1ZUNnArL1RN?=
 =?utf-8?B?RjZDUWpXVzlzQjQvK0FYQnMveHNVdGZiU2c0Z1JsdEF5Y0ZzeGxPQVRCdnRB?=
 =?utf-8?B?TEh1QVllTEpVeU1BTkhWR2pwWHdiQkhhYTVHb1phWlNXMmZPL0xVbFVCRnFl?=
 =?utf-8?B?d0ZuMEpGQXRab2ZCSWNtS04zNE9vWG5IeFVic2Z4SWlENWRQd3hUamhXRnlT?=
 =?utf-8?B?amp0UTFJeTZCOUVqdEpMM2ZsWGdYRTRyeTMxY21mUjk4bFYyQ3YwbHJpcVJs?=
 =?utf-8?B?VmJ1Q3BzQWNVaHFML2doaWVWTGtSSE8vYlhwaS8wZjNxdCs5alRYbERZeUFL?=
 =?utf-8?B?S1VGWTI2bXhHNml5SGdPRG40VkhhOWVSYllWeVdieGY2dHV0aFh6NzFrNjcw?=
 =?utf-8?B?eVBQMHZLZ0tWK1hTL25kbVFxRHVHT2pUdGFqVWg5RHVjS0wwNGxiOGpLSUZ0?=
 =?utf-8?B?YWVGSldKNmo5QjJnd3NOZHM1NUVOS2xVR0xXUkxCOFhvWjI5UE5ldVZuTGZ1?=
 =?utf-8?B?M01LVWpNaXM1bEVtNHhhVzJNTm9ETEVBajhQd2VRbTZLcEkrdTdMWU53dGYw?=
 =?utf-8?B?RUxIaHg5TUxUUnU2UHpta1pnS3h6NkhKV3dSblVYUE1xaXg5R0hxRnJsMHIv?=
 =?utf-8?B?ZExHT2o2ZXVqUjAwQnhaTHRjZ21qUjllaHFzdU1uWHQrOEFTMTRCcUNZZHlm?=
 =?utf-8?B?WlBvQXMxU0NtYjV4VVVxUTRUUTJpeVh4M1hVeExzUlpENGNrMjhuZjdQOEdH?=
 =?utf-8?B?NnFlNTZmK3lkQlVUOGhid2tpb3pPVHF3STltdzd6R0xKdHY3Q2dBUXpDRlJ2?=
 =?utf-8?B?cXMrQzJNSStqZGdnVUVGbWFZODVTaHgxdlI3NUl4Y3J6dGNpMVpNR2dWeW5M?=
 =?utf-8?B?YU1RYVRuR2luMDBMV0VXbnlhWDJTWDdsN0pLM0NaNTNHVi9tOHJyMmQ4ZGc1?=
 =?utf-8?B?SjhoOCtTb1gyMXczaVZENTJXT1Vod1VVR2FWVEFuYW9abFErd0JMS250WWxU?=
 =?utf-8?B?RHJybnhrL3F0REZPam5CZUp2Q3lKQXErWmhZSWpXemxoWFdQUVdCdGs5VFVE?=
 =?utf-8?B?RDdJbzlxampjZTg2NVRKNGRtSWNCU0swSUh0ZENnaFlsSllVOXoxZDNaWWZ6?=
 =?utf-8?B?T1E5TVFQdnUyelc3dEJvVHhwTlQrSHRwL0t4THBqZVprb0sra2RWUTJHeWoz?=
 =?utf-8?B?VTRUL0YyRTNrRDRGRkRncWZuUjRqcmY3Vjk3OENxTzNYd2ZTZlg3NjdyYVNk?=
 =?utf-8?B?OGZlNFQyV3pNZlNFWFlnMEUrY1kyU2djTlBWTm5IVEN0VzRSSTdPQVJicTVp?=
 =?utf-8?B?ZkdOS1FuQTRmb3Exc3NQT1gxUVNXSkFvYmdSY0xXemhwQkUvbjZWSFpHMlZT?=
 =?utf-8?B?Z3NORWM4ZG5vOUtmSGhiWjMwU0NxTTRrL2VEVnRMR2RlMXQ5bG1LNkVjUWJh?=
 =?utf-8?B?ajdTNXZnWWJFK2xieXdCMmtHRGl0L2d2MXhmcHRYR2xncWtyNjVGUmNzMjdR?=
 =?utf-8?B?U1pSOG9KN2ZFOUxsY2EvNWVwMFFzWFhibUxkMzM3L2cyMUR1QWl2UVRPK29U?=
 =?utf-8?B?eGxxNG1UUkdLZ1VZSVFvRnJSdjdtbGg3Vlc3VGNrekg0bXpJdDRaOWNLM1VP?=
 =?utf-8?B?dWhZMXVBNlRvaHhBRnY2T1JhUmphUEZhTUxkR1hoWXJ2L2hNZ2tCUEEvekVz?=
 =?utf-8?B?WGtjRDFTNDB0cytDMncwbUZ6M2J5M1BaRjVvcUgrdGwxV2xhd2tKazZvNWJS?=
 =?utf-8?B?L1JFVGZHc000bkNlYng0OWZ3dnNhWTFIdmtvL3FKejdZMUNRNG0zM3pvbmVp?=
 =?utf-8?B?ZkN6R3JNNlJLVXg5VnVVaHVXc3l2RWtqd2NhcmxidnFjeXo2OE5WUjZkMjVu?=
 =?utf-8?B?L2dBUXZRNW9Pc2VuUENtcmJKT285NzFrVjZvRCt3Y3ZUc0ZkVWFCbEVteVgw?=
 =?utf-8?B?ampCejZLNWp5aW1XV295ZE5YdTNqMjZQNDR1V2d3UUtnQThsU1kySHdsWitm?=
 =?utf-8?B?MnE4a3JsODRpV0NXNkZRZU9ySklFQTFkVDBjMnI2MndYRHJYQ1ByYnl6V0M5?=
 =?utf-8?B?bmtIS3J6MmNIR2tCQlRTcUx0QThubGtxSE4vWklqUkJ0RTlwemljVytScitR?=
 =?utf-8?B?UXhvUjFBUTAyUVhFYUNNcENVUkpCUFdxZ3prbnF5WDBWcTJ2V3FBMjY0M3g2?=
 =?utf-8?Q?UDZYK9KQdLddlKMAfUzLfmiILAfA2oWbIPs4MXiUtvA9?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6d93d42-ebf9-4694-2b0a-08db30634e10
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB7104.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2023 14:38:47.5290
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dlXFS8I/H8TRJJGKJEZWLt45pOPS2rCS1FfT2jWa/Z/pi1bhw3V2A/lgNF/dLHMYAiwQd0JWSul3Oi62bFdaeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8212
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

the fix solves the issue. I have no issues wit it at all.
But it raises two questions

1) why is devm_mdiobus_alloc() different in this issue from other devm_* allocations?
They seem to use the same mechanism.

2) why do you think that this has anything to do with usbnet? That issue should
arise with any usb device.

	Regards
		Oliver
