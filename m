Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F95B41E984
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 11:20:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352939AbhJAJWd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 05:22:33 -0400
Received: from mail-eopbgr60124.outbound.protection.outlook.com ([40.107.6.124]:39125
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229681AbhJAJWb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 05:22:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GjPPisaK7Ns83UdP1RCzplgVRSZmxtxM7h4yOo6N64v7PWgl/sgWn0Vatf53iV3AQMo95RzOwOVyRQLcO33h8TlapvJ4guzuMJnuChaQde4KYVIZSVWxnCpZcG47cH84WERQT5yJmDExldfh/KxzlMA06yLZpGKRkcPJtp2E4Kczt5ub5lHYAG4DDaXwGSAEwNJjLoiytZmCt7jFUdYehNRP/i6E7mQVA5ktVJwNqC8DGacXvU7pQ+S1USwr5AWURvLC4j6BvCMDoTY5FoK1oozEAiO+YRikrnvgXMuVWFDzXAARmy5SYaCUwYB7g4Axd7e5Xw8L1Jq32FUf/Is5zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8RZhaAD38iXNiylQ0T7FkJ7PgQuKAq92nkknJ+ALJ2M=;
 b=etiorjODzGDkQq2cN2hY+xyNBdP954PdIxIceEPkLqJuRlsZIRgqILT/k5WzduchbJYF3fdP1fz22tHzRF7wmv9ZSqSykOAYD8UQsANWvjXgo59v06eUl30iDVlza3btcyG40zyWxqgGh0Ix5hMg5Wnj593xWeGkKYPC1srjZ487U43aWnILtz1moof6YIRryL8deyVH/j+M1aha1EmQFmacfjfgFwOOeRzSh3RLMZ4k8cUxkeGEgh4QrD1TfSXyDHP5BmOkKHJgXeIcTnIIOXvpehsialqQgPHsftj3kNIvzMiLsSF9/0JpO2K9Jp/cUP/4HKkpGJC6SAYUYuN4Hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kontron.de; dmarc=pass action=none header.from=kontron.de;
 dkim=pass header.d=kontron.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mysnt.onmicrosoft.com;
 s=selector2-mysnt-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8RZhaAD38iXNiylQ0T7FkJ7PgQuKAq92nkknJ+ALJ2M=;
 b=gPdGltB9Kllysl23KFmD2RxtcuPTl8tGpwC06IzEIenTUQ8vLrLGSxYrY01RnwpHUuIqo+IfGsT15E/E+ikcqJfFfwhmO3Rd6GKYP6ZZwVaFrMCDqR86ukaGYoX9R9yjsjCYuXAK7iMpv7MOTKM5tusZnQnU9B4bkZSyp63fhoM=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=kontron.de;
Received: from AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:157::14)
 by AM0PR10MB2865.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:165::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.19; Fri, 1 Oct
 2021 09:20:44 +0000
Received: from AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::216b:62be:3272:2560]) by AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::216b:62be:3272:2560%6]) with mapi id 15.20.4566.015; Fri, 1 Oct 2021
 09:20:43 +0000
Message-ID: <18de5e10-f41f-0790-89c8-3a70d48539be@kontron.de>
Date:   Fri, 1 Oct 2021 11:20:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.1
Subject: Re: [PATCH 1/3] net: phy: mscc: Add possibilty to disable combined
 LED mode
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>, Frieder Schrempf <frieder@fris.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Russell King <linux@armlinux.org.uk>,
        Steen Hegelund <steen.hegelund@microchip.com>,
        =?UTF-8?Q?Marek_Beh=c3=ban?= <marek.behun@nic.cz>
References: <20210930125747.2511954-1-frieder@fris.de>
 <YVZQuIr2poOfWvcO@lunn.ch>
From:   Frieder Schrempf <frieder.schrempf@kontron.de>
In-Reply-To: <YVZQuIr2poOfWvcO@lunn.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM5PR0502CA0007.eurprd05.prod.outlook.com
 (2603:10a6:203:91::17) To AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:157::14)
MIME-Version: 1.0
Received: from [192.168.10.35] (89.244.186.11) by AM5PR0502CA0007.eurprd05.prod.outlook.com (2603:10a6:203:91::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Fri, 1 Oct 2021 09:20:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 96aa0ff7-b5cd-4fb1-bdb5-08d984bcbe66
X-MS-TrafficTypeDiagnostic: AM0PR10MB2865:
X-Microsoft-Antispam-PRVS: <AM0PR10MB28652B05625B3431453E39B4E9AB9@AM0PR10MB2865.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ER1AAQUE+jXOqNJfw5StrhKtLpB6UXdK4lGtEPxm7hAUN3xi43X43DvrQxse8dmIp7I91K0Jgf2TNa29pejpZz1v1vyCdRzqGJmOjk0D4xSZg+qR1l7+VuYJOBC27lpJYfAH7pMg1Pm1hCpzRmxJF2Fj2zeKhKApsvdsz76hQvD7ivFB65vUaWwx1SCWCVcy+FK6s3KX0+CJ2E88n+etWzmbMGXLH5E3lLRIxjLKxQPqgNgEW+TRgBHxOQ+uL5IgpZ3m0+YnvjSAF8s/GRnksLm5QbBigXJtBbZ7ZJoMfFOiiPaVJMwY8W7qq68ThGwWwGP8sZr/r8AZzGyaSaQn3EKGqOCQq2vALdRmyA/UdWUV3fi8Y2is4qqcnJ3uAJSF1NAnI5EsTQmi7tSPvaWajFYyHg5m2pYWtCFrdTWLKc8ffwXBKr0C0NmwCE18PCZ0mNldSe9IrTEfGWLkgx471J/j/UC1eRt11Vnhw/bFzVzn4/js8Ytc3I6z0iRvW6/WkrK7Ht4TLV3Jgk8Me7lnjHDpPnq77Jo+lX51Py+yw/c44m333aDkUYBd8Qri81Sw61B+njvV/w/V70/t1z/d4oWifOaUEOoMiECEL7EZIdSnVbRRf/A4fv1PaPKJfwdcJz1ALD0yJATBR/gDpVTJbKL5U9TsHC7xp7HS2aez4ENnUVhdyxkWNBleu/7087tpiwSQCWugnoKBfADWbdbasdBSkv8Ohspjqx4zP0zES2G6z4WV1RDDvjIWFnFpezWdLkxYn6nUM6GU2/E05vDNwTW3Sz1z16eyMjhS2VL96OSZt05kYZn6UOLTw0x0CWK9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(6666004)(31696002)(83380400001)(966005)(36756003)(956004)(66946007)(8936002)(66476007)(86362001)(2616005)(66556008)(508600001)(6486002)(8676002)(186003)(26005)(16576012)(110136005)(7416002)(53546011)(54906003)(5660300002)(316002)(2906002)(38100700002)(31686004)(4326008)(44832011)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NldnWnJCcmFCSW8yWHBPalQwWUFoblZlMFBKM29vR0w1VVMweStNTlFWYVpM?=
 =?utf-8?B?Z05YYUVpYUlLdFlYZ1lzY2dMcW40UlM4ZUQ2SEFtcXR6WFFpay93NXd4MG5Q?=
 =?utf-8?B?b2pPWWVuQXBET0lvSitTYTNMK3pIck5SM3BuU3kvV0tTL2oyRFVrT3gvWGVJ?=
 =?utf-8?B?OWxPNjhDeERyV0wrcmRtZUM5UkFUVDgxdXFzU3Jwa0NjV3ZkdWUyWjZNWVNP?=
 =?utf-8?B?akRCTkg2bTRPV2FRUVp1NUlGRXpwbCtMcWtaT3BSOFdWOVgvNXhvMDFKelFs?=
 =?utf-8?B?MldCWnAxYlVSMlV3RnVlNEF2LzBRbmVWdVpTU09sMGxiQVpRVjlFSkx1VnYz?=
 =?utf-8?B?RnRtWWJjdjlQNG9VeUFHNHNUZWRYenZ4ZXZ5MmMvZEh5cjU5dEZ2ZUVUVDZt?=
 =?utf-8?B?ZzhKN0tlb2lTdmdHNEpDUVQ3cHF2VmhLcU0vbzBDTGVlYTlSOXJVdm5FWHA3?=
 =?utf-8?B?SlREQm1JVExvRjFGWW5vTzJvb1lVQ2FlNmJIdUk0T2tiSURIRFptRDlwQlRE?=
 =?utf-8?B?anJ1TzFmMWxZZDZwcDl4cjlEdXFZb0dGdDV6T1JJdXVqY0djU1AraWtEamJq?=
 =?utf-8?B?WWZEN2V2ZEUzQXBHeFI1cWM2L1hBUlFPK3pnY3hjUWVvOEp2KzZ4SmpZWWE1?=
 =?utf-8?B?R2VkZFBTbHpDTEZCSWNtUlFmZXRmK2VaODBwKzdMWW1GTm9nV1VVeWdMUXU5?=
 =?utf-8?B?SUJ5OVpuZmIrVW1YR3drQmgvMGIvUitIdXd5aWM4T1M4WjRvR1g1bjhhbXN6?=
 =?utf-8?B?U0hZYzd6d0hiN3RzK3hvZVFWMlllemtiS1k3Q3RDbHpOZC9WUEhPQ2JwKzZN?=
 =?utf-8?B?cjdaVFRtcVJTcVpBSjRJWmJPYW4vNTdFMFRBNVczb1hqSmJMUDRnajhRRU5h?=
 =?utf-8?B?UnFIdU9HYjYrcmJzNjcrckdUWFZKY2x4VW1oQVo2RWptMm5sYThqVGlpSmdK?=
 =?utf-8?B?ZzBxakdqYzNNQ2xZNnV1ZXFOeElFeUJhVHkwbzQ0VFVka2NyZ2ZGM1V0MEkv?=
 =?utf-8?B?bHNlTm5GSnF5eWlhS3krTVR0bEZwVmhFeXh2RXRBa1J4SFM5VkFiMGR1OXZR?=
 =?utf-8?B?Q21lUTZZVGJkRi8zU1U1R3hiM29vekxVaHQ3RTFNbm5qS2dmUjNkYnNQYkJB?=
 =?utf-8?B?SHFDVk5mcWdJV0dDUTUxUkxnWjdBUVR6WlhHRSs3VW42M29OUkZNWGlnWmVy?=
 =?utf-8?B?bXkvRmdjZnZMUG9JL1RRVHNGWFBwb2I4U2lJa1lHemdYcG9ua0FZK2pHV2ZJ?=
 =?utf-8?B?UUNjSlhCWGYrb3ZZbmZFSCs4QTUwc2tkdnAxdFR3clA4M1d5bjZud2REVU9P?=
 =?utf-8?B?K1E4eWRLcUJTQlF6ZVJXdFBrSURVQ21wTVJKeUxpNkFyaGtReC9SRmFxNjBq?=
 =?utf-8?B?SXJlUHR1TVJFdmJQODRVUzhsRDlhcmVDVXhNTUdsZ3VhU1FncHpPV2JhTEo0?=
 =?utf-8?B?TVNwNzg1QjlZanJ1Ung3ZEhWblZ1MTNnTXVvNmtLc2txaktCY2JtRFJWZGJi?=
 =?utf-8?B?aHFaWjIyVjBHRituVitTdDM2d3BxVS9CUG9YQ2M3TC8vOTMzeGk4ZDVhYzJH?=
 =?utf-8?B?YUx1aGlBWVMvaCtxUk5TOEU4S0RwbjYyN1pJdFgwbllEVDA4MHp1RnEzNFpT?=
 =?utf-8?B?eEV5RS8xc05pWUNSNCt0NG05UlUwYitxcGZvaXJuNmFweUZDazI4ajBxVXpX?=
 =?utf-8?B?aDdPKzQvZXoyNDRCNlFZSWhnY2tFalkrNjRwUk1LRTlibFcyVkdNRDc5VEtX?=
 =?utf-8?Q?kMT0ZT9zPva5F6yMTSA/5iWJCZhvVkVU14wZoT3?=
X-OriginatorOrg: kontron.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 96aa0ff7-b5cd-4fb1-bdb5-08d984bcbe66
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2021 09:20:43.4097
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8c9d3c97-3fd9-41c8-a2b1-646f3942daf1
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q2YTdeuE2Pa4Mm6L1ONeWBXNjRKuLB/iG8rwyY8dQfn/TWmptMIB+NuCWr6u4r0QOt/Zq088YLoRUkt2ZDZe8XXQkiZVOmoZ2ChTywjkV6Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB2865
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01.10.21 02:05, Andrew Lunn wrote:
> On Thu, Sep 30, 2021 at 02:57:43PM +0200, Frieder Schrempf wrote:
>> From: Frieder Schrempf <frieder.schrempf@kontron.de>
>>
>> By default the LED modes offer to combine two indicators like speed/link
>> and activity in one LED. In order to use a LED only for the first of the
>> two modes, the combined feature needs to be disabled.
>>
>> In order to do this we introduce a boolean devicetree property
>> 'vsc8531,led-[N]-combine-disable' and wire it up to the matching
>> bits in the LED behavior register.
> 
> Sorry, but no DT property. Each PHY has its own magic combination of
> DT properties, nothing shared, nothing common. This does not scale.
> 
> Please look at the work being done to control PHY LEDs using the Linux
> LED infrastructure. That should give us one uniform interface for all
> PHY LEDs.

+Cc: Marek

I guess you are referring to this: [1]?

If so, the last version I could find is a year old now. Is anyone still
working on this?

I understand, that the generic approach is the one we want to have, but
does this really mean adding PHY led configuration via DT to existing
drivers (that already use DT properties for LED modes) is not accepted
anymore, even if the new API is not yet in place?

If anyone (Marek?) would be willing to revive this series, I could maybe
try to find some spare time to rework the mscc PHY LED configuration on
top of this and do some tests.

[1] https://patches.linaro.org/patch/255422/
