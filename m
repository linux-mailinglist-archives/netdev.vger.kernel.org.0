Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22A836EC871
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 11:09:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231445AbjDXJI5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 05:08:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231243AbjDXJIz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 05:08:55 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2061.outbound.protection.outlook.com [40.107.21.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4C5010CC;
        Mon, 24 Apr 2023 02:08:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eKH5ipW8d6zt2k2yj7PpbzPLSBWcX38h2QVSe8AgDqtmDXY/8hswSTubP+M5AcWBjMWsBlsFiBh2Fa+wkjZzyBN2pRRUf64smQDB+gLVPu5+ucWGfStD4bJ4TO0OP2ka4VfjQEEKZbNVX9exE9rvFo1ynCTvlidTFr4CE4wbcfNnE+K6NqGbEdXIJDgZ1bk1zwDSVrnUYsN8rPjWuaDq1KEBxnbg72T7FcAlXq6zSR0c3XzbE/41JNDRGiaHydMRzk1Q1Q9cBW9aDLUnzqH+s5K1C/1wxz5F3fzM7Azj1rUBTgmLMqqwlWjg/vBpT4oqMj/odHVhUQYh0OEgdQopDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=21NYWqkEXlbpbr7MP36GrSSTQG7dc1xB15Tp85wWJgk=;
 b=Vvp+pKWEDdqbDV6+1lcxYKJxmmnpLj+AYakMJyH/e6E1M4Li3RCZbVm4UTIOEoOI4aWpcTiGPHd5q/YD9ilpEnh8wtMPBIJ5mLLiGVWL8G+wCViurqB3CaRuGiQw90lj/sy/oM3Ey2LEqcTzM4BC0Xa8J56rIsUxAgXbLReye4m5m620o6DH74/uAgCuUAILlbZN/TlgaHvamoKj+bNQRW8JXEadfaXzT7Hfk9vePmgI0t6kwYsbBSxUU6huHe2BrLAFNr6HzrammR8FOv83IMjEqb9meyf2NJgUspza4ed6bMmnjq+dkdh+/2Vfgfzvu4M7bF+KMCyKW6CPzvNZfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=21NYWqkEXlbpbr7MP36GrSSTQG7dc1xB15Tp85wWJgk=;
 b=B/dJHbPgfTI9v2orSYI4oQ/wVF+IOnbLnc0i0gB5yGJ15i0NPv9xjK0yp3QXFsegiA1d/Kv1wbj3UxXaepnP0Afa6zVdRHNaaTQG5kuwKNVc7NgpE4Y+iZ5ku0ZOMYZPhv2Ed//Yg9rKzw3uVXUwyRK9gfBWwjoaQEPTviFmVjQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com (2603:10a6:20b:409::7)
 by DBAPR04MB7334.eurprd04.prod.outlook.com (2603:10a6:10:1aa::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33; Mon, 24 Apr
 2023 09:08:50 +0000
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::1d1e:26f6:2cc6:a9be]) by AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::1d1e:26f6:2cc6:a9be%3]) with mapi id 15.20.6319.033; Mon, 24 Apr 2023
 09:08:50 +0000
Message-ID: <36cab8c2-1901-a263-a7db-b7de486bfbeb@oss.nxp.com>
Date:   Mon, 24 Apr 2023 12:08:31 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net] net: phy: nxp-c45-tja11xx: fix the PTP interrupt
 enabling/disabling
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20230410124856.287753-1-radu-nicolae.pirea@oss.nxp.com>
 <20230412204414.72e89e5b@kernel.org>
Content-Language: en-US
From:   "Radu Pirea (OSS)" <radu-nicolae.pirea@oss.nxp.com>
In-Reply-To: <20230412204414.72e89e5b@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: VI1PR08CA0190.eurprd08.prod.outlook.com
 (2603:10a6:800:d2::20) To AM9PR04MB8954.eurprd04.prod.outlook.com
 (2603:10a6:20b:409::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR04MB8954:EE_|DBAPR04MB7334:EE_
X-MS-Office365-Filtering-Correlation-Id: d731e1d4-0649-4872-5cff-08db44a384a8
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vD549C6DiiMCsWkqmSvh4H0uQupJ6Srv7RezD+qNazubvizxuJrdYHqAApmFEBZ04M1GU11DZ7E2757mzQ0uTrO2/BZMz3CRAGR4Xh9UpB/CBPDqjo6NOnWAYOw5NMueJ+YlhAULnOGRFBFIHonsQYvMmDF8nI3IdLFidJxz1/9tkKGosKeSLMXrZ5Ijlos/nYfsiGZpN+BqBpZ2qfVHmcvYuL9Z/ygV5vbGN2sDnuJMuLe3kLAynQV77+BiaoC/zDIz8bh3K5jRSNb8jiShSgjyD0owcjo5j6MIfzTo5NQsMSXGZlShUH9Jsz0t2ZavvxSl7WsrnFNz/eY2tdocpQ5NZSk5UBMgCR3EK0hBS84SMs+JGHYNkaN+9/FOJ7/al+1fmN5UOzFSu5vtFlFvmuyA647DUdPGJvdghdax7GUyNU0HSAu9TqTVESFgjUGKhVEw56mk2TWoBY9RiHSP+PotLntmlszk8QX9IRCStPhSqZBFTotWokc6iw0EUNuUSZPNCMhfBIRDcjhb11pUdqEY0WVNIt3Mj9qmcVCgbC9KHmTc4PD+8E1b9GwJdPzJ4nuwYgMQwF6gwlACSJxZK+qWcudRUEjBJnqdswn2QjPHqYXiuckxrSYxgDqLW9tJ04CqjrVvWMo859xABtWbrw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8954.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(39860400002)(376002)(366004)(346002)(451199021)(53546011)(6506007)(26005)(6512007)(2616005)(83380400001)(186003)(38100700002)(66946007)(31696002)(478600001)(86362001)(6916009)(66556008)(66476007)(31686004)(8936002)(8676002)(7416002)(5660300002)(6486002)(41300700001)(4744005)(2906002)(4326008)(6666004)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a2V4Z1g4dkVPNVlBRk4yd3oweHAyMmwwUWNLUFIzbjYwTzNlWGt3ZlNkVG1m?=
 =?utf-8?B?dGM1THllKzFGRThDTG1TVnFpVmFDZ0xXSElFVlZmd1NwNTRpREEzSnpaelVZ?=
 =?utf-8?B?NmVBelgxS2ExQTFnWEVySjRTWU9HV25FT1hUN3RRK2pHYTA2eTJrRFRma3kr?=
 =?utf-8?B?bGhrK2psTWNkMjBQVFVhSmo2MkhVc0lDSkkxdW43bEpFb0NzSVFxVWFLZHNL?=
 =?utf-8?B?NWdiZUxTVFBDZzZBT1NpQ3BGL1RWN2w5eDB0YmIrSUFYVi9id0NveWNrTmZj?=
 =?utf-8?B?RnhiTGJFa0JJUzNjK3VwQmtoUi9UVVBQUGtvYWJsNkJXS3djWnNYOUlwdDBL?=
 =?utf-8?B?aDFQYUZnVkxHQTJqU2t6d2t6VVpIN3hnUzVobHFqWnk4OG9QNmxhaHRVOG1w?=
 =?utf-8?B?T2pQV0xYTzJEUnFSN3lQL29aZWJqbHhqMHZodkJNbDRvQTdBeDdXL1kvNDdj?=
 =?utf-8?B?UEhnTytwVDkxMGpEQ1owZHoycCt1NjdYSXBteU1leHpvQ0l5SWwvMXduZjNV?=
 =?utf-8?B?MW5RVGNmSTFzWStldStUbUxOWUhKZ3dwZWFqcXozUlA3TTYyMFhzTWtYbDlv?=
 =?utf-8?B?cS9jZ2RUcDZZMy8xVEp4ditweHlKSlQ5R3hjUUtCanlMa0ZCSGRMVG1SZnRN?=
 =?utf-8?B?cWZwWFNFMmJpdUprcVYrdndCUXQzRC9pRVVnemt3Mi9RNll0bXgwTmtwd3dk?=
 =?utf-8?B?RXhubE51ZHNheUQrSHVZZW16SUVjTHFkTGw5M3lUellRYjRsVk0valBlTCs1?=
 =?utf-8?B?cmYwdkRRZEV2MFMrTkxyb0gxcFE5SVYyazhqTU1LdTFqWHk2QmdvNEh1WHAw?=
 =?utf-8?B?RXVKcnJyWU5OSVhxTU9OZlh4U0dKRjJVbWtLQWNZRzJHWHVFZWUvZUFtNUpr?=
 =?utf-8?B?c2JrUWNMVjFhUVpya1pZTTdFbGN4RWhNajFlc3NBdGR4WFFxNUlBejJZZGRX?=
 =?utf-8?B?M1RmbzZlL3haeXBraHNiUmFVcFpYQWFZS251eGtVYzU1YTBRWVhDYzY0Q3lO?=
 =?utf-8?B?Tlp2SFpOdkRpM0w2aUtoWmVZbFV5SjlidHpOVk5LNUlqN1pZVkdxMklwUzdo?=
 =?utf-8?B?VmlnWWJVVUxCYmdVSnRQbHdKWTNubTZRV09lbnFsODl0K1k3WU93VUNIUHZY?=
 =?utf-8?B?M3A4MmgzVFB6MmY1TVR4S3Jkd2E2WWhTVjRmam1sZzhIZC9CYzcrTG5oMXps?=
 =?utf-8?B?N29JeHhWMEhtZ3ZXYnlSWU1kRzhGNUxkVGoxRW1EbUw3ZHdOVVJBVWRNd0Q3?=
 =?utf-8?B?YlVpMEhuWVZSdzRUVjdnQ3l6QlJnRG1xeUR0QXRhSFA1NWh1NWtScU1JS2ZF?=
 =?utf-8?B?TkVNa1VzZVZIcWMrYlVNZGtWNEdzdllKTEhCaTZyaVJJcEhDMzAvNXY5cTJm?=
 =?utf-8?B?ZklmQ1plR0ZXWXVWWEg5Q0VJYk8wYXlpVDFZc0JWUTMwempKN0NTVk0rbm5O?=
 =?utf-8?B?OXh3a3oydkNucmtWY3dYWFc1Uk5IV3dLVFRBZW9WOXU4UUNJOCtUaG9IeDF5?=
 =?utf-8?B?aE5uNVNxSmdQVmxkRUF3bFpJa0RQbFdacEswR3ZkTTM2aVBhbU92RldZbTlh?=
 =?utf-8?B?OGtHcEo3UFF2UTRlVW5xWG1STitDMDR0aFJuRm9RQWFMcDZwN1JScjlrZTBU?=
 =?utf-8?B?VTJkdnBQK3kyOWVTdmNjWEF6QVlrbll0Z2VvT0tDVjgxU2VMYXB4bm9HUXEr?=
 =?utf-8?B?MmlqMlZMTzdNMWZCTnk3Nmd5cTREK1pTQ3VkS3ladmYvdzkvSjZoeGluRkpQ?=
 =?utf-8?B?aEJITjNFbEc3TVlYcVFCUzl0aDZkd3ptVWc0TXdlM3h1K0VQUitLTkphdVVG?=
 =?utf-8?B?QTVmUkx6SWR3UXZzYm51VWNpTnZiUkU1SnhrUHJXR1RvUmxpMEtTOG92TXZq?=
 =?utf-8?B?SmJGdnV6RU9ERHUyNmdLUWJUVXRkUkF0bzJxeGRNTEZyWUZnM3Qvd1d0K1dN?=
 =?utf-8?B?ai9JbGpyZk0yYWxMdU9PWkN6bk1XWURJVHVlbk1qRXZhaWNLMkNaMkZ2S3Q2?=
 =?utf-8?B?UzYwRXN1VlZQd29OZHBiNituUmdrNE5jQWViZXM1L08wSUcrS2hQcjQ0dWk2?=
 =?utf-8?B?U0RJYXlPK2xtSjhqODFxcDhjNVZwRkJuZG1ZSE5TR0svVGZPTFRIeDlNWnIx?=
 =?utf-8?B?TUR1WlBURXQrcmJobHNNWk9KWXlXdWZNbzhoZmFnQVFlSFJXcjJxaDFUbWdJ?=
 =?utf-8?B?Ymc9PQ==?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d731e1d4-0649-4872-5cff-08db44a384a8
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8954.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2023 09:08:50.4118
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y907ANUZdXQ7ov6t6ZzDciTWaNIjMtuiHu5i/EAehi1KxUxmyCsIB2E7cYFVO+hfKarPOXf1X/F7yPWnaNptGxlvQQ/r5vM5aU45XdlWLdc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7334
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13.04.2023 06:44, Jakub Kicinski wrote:
> On Mon, 10 Apr 2023 15:48:56 +0300 Radu Pirea (OSS) wrote:
>> -	if (phydev->interrupts == PHY_INTERRUPT_ENABLED)
>> +	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
>> +		phy_set_bits_mmd(phydev, MDIO_MMD_VEND1, PTP_IRQS, PTP_IRQS);
> 
> Isn't the third argument supposed to be the address?
> Am I missing something or this patch was no tested properly?
Yes, you are right. Thank you for this catch. I discovered this fix 
based on a driver code review and it did not trigger any issues. I just 
wanted to be sure if the PTP irqs are left in an inconsistent state, 
they are disabled from the kill switch.

I will send a v2.

> 
> Also why ignore the return value?
This register might not be present on every PHY, that's why the return 
value is ignored.

Radu P.

[...]
