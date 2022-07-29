Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 046BA5856C9
	for <lists+netdev@lfdr.de>; Sat, 30 Jul 2022 00:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239533AbiG2WPr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 18:15:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbiG2WPq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 18:15:46 -0400
Received: from EUR03-AM5-obe.outbound.protection.outlook.com (mail-eopbgr30084.outbound.protection.outlook.com [40.107.3.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA2934A80F;
        Fri, 29 Jul 2022 15:15:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SzFBlUIyZlFtmGWzvcmttYKvC2iM1dVrSTKdHk/WHLNO5lpvOrCITeqEZt9sZ++QxTl0vd0ITLMSRaiv5FVKi51nfFL0d3g8M42ofLJzZkjvfNdKk0aiK0ZFSlpsbq4VzT4rQyQqfWZRZG3B8ZRBBvXhqWIsdkdZG9ACH+YsPlHjdCcaeS/S4XAV7YxEg8ozWCNDNvnaqFoXvTsoGFTahTeaAqDvXW4R+r+aHnDpf2BkvcuXRD4BLdK/mcsnD5FAOA4X4uEuVqjdcQJvNz5SMOVchIhBVXSF+Bc7IDCrUdMG6AdOwIlzkRtkuEDnHW/ftClKvy8lmLatf8yN+WmTpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mOH0YKAKtvWv1dheocDHDngOmwFPArjMNuPYs+fAa7g=;
 b=UplDLT9nqWO9/4qHThBVQzO16doYbpo2XJRoAHKyOre20VQVr/fBDDONH9TpL4sDO0K6ES8WnXPJ7QjVz4vPdv1Pk7vjqj336oE5RRpKhkdIqf3BL9sGD7O14SMbuPuuHKfNdwOzhTdqekcDfBDIlOBTBmmcL6hZnhJKnKdnh2ZLcRs2+mTtk7XSXIQMmoBWyNKxRftrxw/Ahvqz/HJVT5vHILyrPtYZ4ShF6zABbUU2Z141KQ2TH5P0XGeHy7w2lQ7B+hObPKIXjB51Qc0OvoRk/cQ2ZC0CBJnYgW5l+9/8cYJqmVhKQ4qXmdhUQxLAMy9ajyKhf27+xCoYCdMdYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mOH0YKAKtvWv1dheocDHDngOmwFPArjMNuPYs+fAa7g=;
 b=jBFxOYolDfGiZiPi3jtHVPJfjyOU9zqCI4QV0HDCvMGCDmfGfa/V15OjK4RuhD5EPwKXjv65eSyRI7GktvJ93FMtA0nwaBtYsrhj0fylRnGGg3q4DUPN1SoGvoHQaY0Iqv8nOjuCoI21xKm9Jj0bdT4EHKJu+ucv9OfzB0QA5RZ44by+4+zlyfpjufQlqjNupquS9e65Lm2JVHF5sK64L54w6iwjLkxYOjFsjfzTTavIeXVFI0hIlNYK6GQGiRP2fSPLm/WiHNnhId/873sfkS83LBCh1HG85Wcd8VGMIVzCxbNrjglroWiZntth35Q0V/EC5fA9N9f23z+Vti7jYA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AM6PR03MB6005.eurprd03.prod.outlook.com (2603:10a6:20b:e2::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.25; Fri, 29 Jul
 2022 22:15:39 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::7d32:560f:9dd0:c36]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::7d32:560f:9dd0:c36%4]) with mapi id 15.20.5482.011; Fri, 29 Jul 2022
 22:15:39 +0000
From:   Sean Anderson <sean.anderson@seco.com>
Subject: Re: [RFC PATCH net-next 0/9] net: pcs: Add support for devices probed
 in the "usual" manner
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Li Yang <leoyang.li@nxp.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Rob Herring <robh+dt@kernel.org>,
        Saravana Kannan <saravanak@google.com>,
        Shawn Guo <shawnguo@kernel.org>, UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org
References: <2d028102-dd6a-c9f6-9e18-5abf84eb37a1@seco.com>
 <20220719181113.q5jf7mpr7ygeioqw@skbuf>
 <20220711160519.741990-1-sean.anderson@seco.com>
 <20220719152539.i43kdp7nolbp2vnp@skbuf>
 <bec4c9c3-e51b-5623-3cae-6df1a8ce898f@seco.com>
 <20220719153811.izue2q7qff7fjyru@skbuf>
 <2d028102-dd6a-c9f6-9e18-5abf84eb37a1@seco.com>
 <20220719181113.q5jf7mpr7ygeioqw@skbuf>
 <c0a11900-5a31-ca90-220f-74e3380cef8c@seco.com>
 <c0a11900-5a31-ca90-220f-74e3380cef8c@seco.com>
 <20220720135314.5cjxiifrq5ig4vjb@skbuf>
 <8622e12e-66c9-e338-27a1-07e53390881e@seco.com>
Message-ID: <9747f8ef-66b3-0870-cbc0-c1783896b30d@seco.com>
Date:   Fri, 29 Jul 2022 18:15:33 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <8622e12e-66c9-e338-27a1-07e53390881e@seco.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0004.namprd13.prod.outlook.com
 (2603:10b6:208:256::9) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bb9f1722-a288-49fb-5b00-08da71afde22
X-MS-TrafficTypeDiagnostic: AM6PR03MB6005:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lsUrRhb86xcmmZXQXk2Bonf0BAvyNa4Mw3x+foO2GCeNFloHr+OFP/fFPLa0ZuPZZsLvZ/2luLWqAE7ZOk1D9l42asBsSnTauItV+N7riyZ3zCPPOb02QkxS5ctjIcBM+qdKOzpYbgaEks4B0HfnOfpoZJDpbCuhbGVP4jqufHQLASOVzFcYHEShh2Clb6eFom/0yc1KqpvB3/Vnb6RPHcN6ptb+crIhsJUoZCOppZS4Zt12XyPgJySz6fT1zub7a46FaSgaY/78FwrZ27mrkFGBefPeAT4lDSzZAmhFcOjSQ4CZqrd8tYoH0AOM/3RJjCXMi+m4/em7RrWw/M1BF0klD57JrTgd+PZydrF4h2oMZzJ80HQ3KRZPN6BmOXlsnDAO9oFbttfVSFY9xwfLvGHJsAkti7PPjfutYDXY08V2tiNTLcW7sV8nJEh3laPoLQK/+TOtMJLZPuxJ0lX/pbXzdGE9/i86pX0bfTZk7Ll2WwvHDUqgj+zE+20TfE5P6s6VTC2LmIvizAOAj8gx8fhwFQ8Hf6IOsjqSH/73xviycLJKbDz5EK3aHW/xRW+QvMupM7XVzcvKQnZhD3LskOtPIvmJOqKNfIgfVRdDgVuv2j5uFKC25hO8HvrZ4vCt3vX1PFxF12VOWlXAwAY8O6ZNvFIj6dIvuleur+7/f6u/0jvEm1b6FhHRPtYlz4WmjwfR9uULmmqV25m4+koB7jzVSP//wb3hgyW+8ES+Heq69f/tJnuPrkVIuGOBvYKqmCuwu+SNeTSE8l9iSaCZAt46MPQ0B1bcbCe6YDj8oMwgB1ObwMyU7hlU779BkHbXn6/6UEw0TFI6H2+gIJXivHMUTXiGKLf36/9tVO0AIDw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(39850400004)(346002)(136003)(396003)(366004)(31696002)(52116002)(478600001)(6512007)(6486002)(26005)(41300700001)(86362001)(6506007)(6666004)(38100700002)(38350700002)(2616005)(53546011)(186003)(8676002)(83380400001)(7406005)(8936002)(7416002)(2906002)(5660300002)(31686004)(44832011)(66946007)(36756003)(316002)(6916009)(54906003)(4326008)(66556008)(66476007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?enlXVVM1b0NrQTNGU20zUnY5YUtxZVQzRys2L3dOT0dIczUwQVR4SDR0dFFq?=
 =?utf-8?B?TThvbVVHbVZnRk9KQlpmNzFDNE1NWjNZZXhWc2tkQzYwRHZBZzlPbG1qYU5k?=
 =?utf-8?B?TFhva2hWd1RVKytYZmlQVGo5cWFBMWtrd0J1ZE9wTURtYkdMejJEU0hGZ3g5?=
 =?utf-8?B?SlRENzhmRUFiY0lYaVhFZnU5NG96RnI0N3J3NllSQ3ppNnhNRFlaMlRGOTUr?=
 =?utf-8?B?UUNQS1NaLzExQTZlK0JENmRpaVh3bFZJbmtSekloaWR6ZkFnV01oMmNZeThN?=
 =?utf-8?B?MjYxVlVTNVlJUjl6SG4vbnB6WUtvbXZ0cUJLbldLMGtXRFZRREJsOHZHVFI2?=
 =?utf-8?B?anViMEZpKzJaRTB6bWEyc2laYjlNTWR4SzZjdFoxc09XT1lCNmhDVFN4MFdj?=
 =?utf-8?B?QThWSy9iVEhCY2pVdHFEZ1NQMWNLMXlNN0dwUEpobmFEempHcjcyc0d6M1Aw?=
 =?utf-8?B?RGxFZWgxTUdIUWpKanpLNXhVQVRmYXpPNmhQWEpFVDlHYVJ1SGR3TmUzN1BQ?=
 =?utf-8?B?T0Z2MUFUV3ZjRXZVdDZqeVBMNzNzbHM4V051TlJ2djRjQytlc2NwN0dqcWN0?=
 =?utf-8?B?NDdBd1l4QzN1RERzSWd2eC9teGRQT3kxZ20vTDZZOTlYbTcyL1d2aEFkWjF6?=
 =?utf-8?B?ZFNtU0JIK2VoZkxwZnEwSUQ0M3dIRjB1djFrZ0pub25kTzlXMkszejhPWTRi?=
 =?utf-8?B?UndheStnaUFOaG9DNC9TZWpwcHJ3QVRZem5KRjl4QmpWQ1ZBcHIzL290ekVX?=
 =?utf-8?B?aFQ5OSswcWREQWNNQm5lY2hMeDA5OXFPR3RiSXk2bVc1THlLdWJTR0w1a1Js?=
 =?utf-8?B?cFNmZFdTVVRjaWVCLy9RRnZVbkFLYjR0b0JOSzJFRFRZMzRZRTBWZW93dlZ0?=
 =?utf-8?B?MjEySXEwNjQ4ZjR3THZJUk5wRHcxSm9mSjZHVjRPc0FMd2k3bkR1UFUwOHRy?=
 =?utf-8?B?RWxqajhOQVc5U3dxejNYWU9maFlZTTZkZkxqQko0ZDdVZ09ReG5XenVxTzB6?=
 =?utf-8?B?Y21CRzJ5K1gwWi9hYW9XNTlHek1BWTJjcWtwa0RJY1NBNzAwVStINml1Y0NS?=
 =?utf-8?B?d3VQUUV4RElsTEJNMVc5czBPVWZUQkNNWGpENnJhbFBKVXJjbUhKd1NDQ2Rk?=
 =?utf-8?B?MmZVdzFhNkF5U0pKUG1GMGt1enBNRE8rTzI1SXEzeVM3R0Rqd1dPVzlUdE8w?=
 =?utf-8?B?T0NibCt2RDdyZG1ZT0U5U08zbWNpck5mUEJiR1cwVlJSekQxcThlcEp6MjBR?=
 =?utf-8?B?ZmlJdytGbm92MWkyc2lSNWtIWjZzMmVJK2JmZ3NkV1N1TGxLTGZXUllMc0dq?=
 =?utf-8?B?Mi9SdTg5K2pRMmt5T3l1K3E0NVRkZ0pYdGhDNDlvZjE3ZzQ2ZWF4UGRRS2Mw?=
 =?utf-8?B?UUUyT1ZUU2N6SnlaN004emplUmczVXVOUitONGVNclJsbFRSdVFVWW9sNzg4?=
 =?utf-8?B?ZWxQUkJCZnd0ditySEdReXQ3UUlLWUMxdkREdC9BNE55MUQ3czc1ZWtDVUdC?=
 =?utf-8?B?ZHpBbW1xbWY3Ri81QU83YktjVW9ZMHVVa01PL2tPR2U5NDJWS2NpWHRLV2dq?=
 =?utf-8?B?Ynl0bVpLK0pGVFhEak9TK2xDRzV0UEdkTFFTQ0E3cGd3V3pQVXlUNnFtd3Qx?=
 =?utf-8?B?ckZna2JvenpmdEdlcDlGTk1HYTBGYURRUmFNNm04MnlWd0NPdThISVhLMG44?=
 =?utf-8?B?TWl6Qit6ME8zR0RZMUlzR0Z4b2pIWDcrbWdqRy94ZUlrUFZJRkVNVzZhQlla?=
 =?utf-8?B?N3NHUUdwRkNzUTNERThZRUxaYWRhZi9YYUF6bXcrMlhOdUR2Ym9wc0hHdkpv?=
 =?utf-8?B?Zmw1WmxNKzVud1dyeXJpSG5JR3Q0aWh3Q3JGOW51RVNKSU94Z09QakFaNVFI?=
 =?utf-8?B?L3hhdEUzYktWRkJYeGtsMHZsWkQ5Sk1uSHJtOU5kWVBIODh4WkJ1UmZ0N0FU?=
 =?utf-8?B?RzJ1TXNpWVIvUnJSQkFvVnhtR0MxaVlNTHZ1QXpZSTJ0a1lDcWVzQndPRUU3?=
 =?utf-8?B?TUFCc20zMklmTG9kMk1icXdnaWZlN2d0RUloV2l2M3JldHhQS1FwYVhnVyt5?=
 =?utf-8?B?Wk1sbEpqWkhFUHNyM1hLcmtUalRhSVFYTnRPRzZTWStlN3o1VmJjQkRrQ1ps?=
 =?utf-8?B?WEJCT0g4ZnVMaTZlSldibHVMWEZ4SDMvMnUzSXJqeVdRMVBQRHpQL0Q5L3NI?=
 =?utf-8?B?aGc9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb9f1722-a288-49fb-5b00-08da71afde22
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2022 22:15:38.8542
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1LgFnzlCVyknS92fG6rUOXyD/qkYtK1ydGd5Kpp+ZjwEWAFcM18bmJkd3vDi1WKXufFybHDNxmwQSDQAMItyww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR03MB6005
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/21/22 5:41 PM, Sean Anderson wrote:
> On 7/20/22 9:53 AM, Vladimir Oltean wrote:
>> On Tue, Jul 19, 2022 at 03:34:45PM -0400, Sean Anderson wrote:
>>> We could do it, but it'd be a pretty big hack. Something like the
>>> following. Phylink would need to be modified to grab the lock before
>>> every op and check if the PCS is dead or not. This is of course still
>>> not optimal, since there's no way to re-attach a PCS once it goes away.
>> 
>> You assume it's just phylink who operates on a PCS structure, but if you
>> include your search pool to also cover include/linux/pcs/pcs-xpcs.h,
>> you'll see a bunch of exported functions which are called directly by
>> the client drivers (stmmac, sja1105). At this stage it gets pretty hard
>> to validate that drivers won't attempt from any code path to do
>> something stupid with a dead PCS. All in all it creates an environment
>> with insanely weak guarantees; that's pretty hard to get behind IMO.
> 
> Right. To do this properly, we'd need wrapper functions for all the PCS
> operations. And the super-weak guarantees is why I referred to this as a
> "hack". But we could certainly make it so that removing a PCS might not
> bring down the MAC.
> 
>>> IMO a better solution is to use devlink and submit a patch to add
>>> notifications which the MAC driver can register for. That way it can
>>> find out when the PCS goes away and potentially do something about it
>>> (or just let itself get removed).
>> 
>> Not sure I understand what connection there is between devlink (device
>> links) and PCS {de}registration notifications. 
> 
> The default action when a supplier is going to be removed is to remove
> the consumers. However, it'd be nice to notify the consumer beforehand.
> If we used device links, this would need to be integrated (since otherwise
> we'd only find out that a PCS was gone after the MAC was gone too).
> 
>> We could probably add those
>> notifications without any intervention from the device core: we would
>> just need to make this new PCS "core" to register an blocking_notifier_call_chain
>> to which interested drivers could add their notifier blocks. How a> certain phylink user is going to determine that "hey, this PCS is
>> definitely mine and I can use it" is an open question. In any case, my
>> expectation is that we have a notifier chain, we can at least continue
>> operating (avoid unbinding the struct device), but essentially move our
>> phylink_create/phylink_destroy calls to within those notifier blocks.
>> Again, retrofitting this model to existing drivers, phylink API (and
>> maybe even its internal structure) is something that's hard to hop on
>> board of; I think it's a solution waiting for a problem, and I don't
>> have an interest to develop or even review it.
> 
> I don't either. I'd much rather just bring down the whole MAC when any
> PCS gets removed. Whatever we decide on doing here should also be done
> for (serdes) phys as well, since they have all the same pitfalls. For
> that reason I'd rather use a generic, non-intrusive solution like device
> links. I know Russell mentioned composite devices, but I think those
> would have similar advantages/drawbacks as a device-link-based solution
> (unbinding of one device unbinds the rest).

OK, I've thought about this a bit more. Right now, you can crash the
kernel by unbinding a phy (either serdes or networking) and waiting for
a state change. The serdes problem could probably be solved by
strengthening the existing device_link_add calls. This will of course
unbind the netdev if you unbind the serdes. I think this is not a common
use case; if a user does this they probably know what they're doing (or
not).

The problem with ethernet phys is a bit worse. It's very common to have
something like

	+ netdev
	|
	+-+ mdiobus
	  |
	  +-- phy

which poses a problem for device links. The phy is a child of the
netdev, so it should be unbound first. device_link_add will see this and
refuse to create a link, since such a link implies that netdev should be
unbound before phy.

One solution might be something like:

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index a74b320f5b27..05894e1c3e59 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -27,6 +27,7 @@
 #include <linux/phy.h>
 #include <linux/phy_led_triggers.h>
 #include <linux/property.h>
+#include <linux/rtnetlink.h>
 #include <linux/sfp.h>
 #include <linux/skbuff.h>
 #include <linux/slab.h>
@@ -3111,6 +3112,13 @@ static int phy_remove(struct device *dev)
 {
        struct phy_device *phydev = to_phy_device(dev);
 
+	// I'm pretty sure this races with multiple unbinds...
+       rtnl_lock();
+       device_unlock(dev);
+       dev_close(phydev->attached_dev);
+       device_lock(dev);
+       rtnl_unlock();
+       WARN_ON(phydev->attached_dev);
+
        cancel_delayed_work_sync(&phydev->state_queue);
 
        mutex_lock(&phydev->lock);

which is probably the least intrusive we can get. But this isn't very
nice for PCSs.

First, PCSs are not always used by netdevs. So there's no generic way to
ask the user "please clean up this PCS." Additionally, most PCS users
expect the PCS to be around for the lifetime of the driver (or at least
until they're done using it).

Maybe the best solution is to provide some helper functions to use with
bus_register_notifier and just let the drivers fend for themselves. Or
possibly default to a devlink, but allow registering a notifier instead.

--Sean
