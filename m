Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE3F757A370
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 17:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238561AbiGSPqe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 11:46:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238540AbiGSPqd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 11:46:33 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10049.outbound.protection.outlook.com [40.107.1.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C4B454675;
        Tue, 19 Jul 2022 08:46:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U3m34DLwqLdzuXoHdTAuN/mh3sDG3sxHpSSazDUNPdsFx69PnLWyIP1xFbrOeceLz3K91TInNBPQJrF36dnKY0gAd37BHTL7Y++LQYhZ9egqDbr8GFpoo040OMjA2rgo4yiF7+nCVbWnFbnkaMdyTENijc/RYArUmkfEkWG0jWh0/A2VNVn8ZRq1eTeIW1bQSJ8OOXN34SAe4f2FiXCA9xmqrwmAtje1+eOx3zq1J6WmYao0OA5ZosmDI3OO3f2O4esIZ134iXCjcGQgnsPW8PhGuqDAiEJzOifKWQY8S1g/DOpfgcww+4ISpX/ztzTvtatduIgKbdvmZxtgUrRp9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a8APrUKZwYMl1rqcw/yb33scMyHBQI1nhZMpWU68Npc=;
 b=jOcg+mBiKfoqxIETXOMPgjJvACa3bzvl34brllzGzTTti3kfZswnxTUwscCecrWj2AyucqgiZYHVOOqvdYRn8j6wMgNOdg0Y5BEEOFk4pEBsrPEkFDpInwPOiJzYWUM1J3Sc+MdfaWMGsARpHVid9bH3kbe3nmTiNxzofVXrjfTLLuwhTP+W0ngcqBSKrOByHrBVLuphAaBVN+uJYpk2v88P7liIbrNMWM9jPT88YcTw5XVSYScqc0rRogtWS5dm8ixYspruiGVnZVVqBnCxWbfgPZ8LRCpcZYdEWBrZhPhJ8gaA95La7WCvvhaP1OVQIBrCmt2xf4qAAAzm4EHNOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a8APrUKZwYMl1rqcw/yb33scMyHBQI1nhZMpWU68Npc=;
 b=YXQ4XI6M5Or2oMW3oOqTAUCnDxhDtpTZPLcxdWfWU4OyOZayDRFOgdo7VJ3Rdlrpag2fd1j1W3nH5LWKTz0UGInPjz0kMtqO3pcABowwhUOw3rCmbXiPbURQ1RU6v32f1cUNLqEjVyp9TO6WM6Nyn2WTukWBjjRdrhv7IjnI75vnUFAvUMqGrPgJskyFL7q0ArteomdzCZAvU6hZo/pJtv+5X3jVDvazi1X9lKocVn6GyXVXRfkggmwTb2BW9VQ9kiRnhMy7gIbr0hjP/1ct6TgWoTF1rpDorHVRRAalwB9mq2wkszRxkN3mnCLWbZq8j7H8tZdwgYQUCcTk6x/JFQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB7PR03MB3579.eurprd03.prod.outlook.com (2603:10a6:5:4::26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5438.23; Tue, 19 Jul 2022 15:46:28 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5438.023; Tue, 19 Jul 2022
 15:46:28 +0000
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
References: <20220711160519.741990-1-sean.anderson@seco.com>
 <20220719152539.i43kdp7nolbp2vnp@skbuf>
 <bec4c9c3-e51b-5623-3cae-6df1a8ce898f@seco.com>
 <20220719153811.izue2q7qff7fjyru@skbuf>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <2d028102-dd6a-c9f6-9e18-5abf84eb37a1@seco.com>
Date:   Tue, 19 Jul 2022 11:46:23 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20220719153811.izue2q7qff7fjyru@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR12CA0017.namprd12.prod.outlook.com
 (2603:10b6:208:a8::30) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 26525f3b-cda5-4247-d3c5-08da699dd846
X-MS-TrafficTypeDiagnostic: DB7PR03MB3579:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I3ufqhIaIK9jN/kM6xFWp9k5nL+DK+7be75h45frbr5Dhfc/TJaxdI03nMi/UdA01+cmAtMVjUhX4Inm9n/I/JGHbTLd1XpVoLZJl9U/PdNzrg87ldkJ5NtgKsqf/7taigCTSF7Tcw29SBTICmPeS15dHmKeq7z1abGhnIaRwaXDEaJpkb/5Xpk77W8qmNnZ0bgVEROWUg3eK0G8mowIs9cS06Z5SY3LpsLYtjBt0bzGOwSwua3RSpLBkZt7AWlD5TlQCKeDhBsYqJhhT/kv6Mb6mgCPSLVO4YMdVuHT+TCH+j7QQ9Yn5CXnMjWW9/JB2lPZJLvfDZWAx55Syf6nAlLCn7tqO8YtOkZBK1v8CSQd1UjFqoQWugQIBpSXQ6pcxGkHq/I4HMKz8YzrBfUa801t93WD0xtDKDYhBDniowa8VMOsQXiK23t03aizLD61LLC8vlyVoe0KddFYei2xhfTfxoLwziV1uqKWz8/jgW709gyNdsGN4MnyniY1nu9/guQCjSt3+rOQCV8QHppbCtwrv312oOFypxqwg5WMI1FBNfAEUsNBueAeI+hOj/jZwdeDrM9V96GvJBJcrb1GTXTnTP1cnSRdn9R9jub0gFqH8Ux8xaawxOt/wHfvg4lyjBqavVrXen7cjxpymqv489tb9a1JhSXudZTY2J68+0zPuIaX46XjXMpHhpJG+5YbZ9Bz6uZtfUTq4rbZqkZqngBfbVTKLd/TH2jWioiRAxTFFvaiWJi14zhpDrcWXogP8CvJIJJm4ttqOrXS+iaF8P9Dj5XzB/Pcowz5OxrrNrdnh0fH3TA1k1AMWD01BRC0m318eqZR7O6wn16BlwdUZnLohS8BXZTNKdL6YtI85U57ZOnuaYEjUNsJO4QMV0wYlXZUZ04/SO0SzgJZRiUKXw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(39850400004)(346002)(366004)(396003)(376002)(6916009)(6666004)(41300700001)(31686004)(186003)(2616005)(44832011)(83380400001)(5660300002)(7406005)(6512007)(26005)(2906002)(6486002)(7416002)(31696002)(66556008)(8676002)(316002)(66946007)(4326008)(8936002)(38350700002)(38100700002)(86362001)(53546011)(66476007)(478600001)(52116002)(54906003)(36756003)(6506007)(486264002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VFFZMGQ1RmllSFhHSGNPdktBOHd4U2U2VGdyZFZhUVo2akFFeGpRanRDVTBU?=
 =?utf-8?B?V2xaZE1qeFAwOVJ5NklRakloeGJkcVFMMlV3YUljM1lNaU1wSm5OWnllcjRl?=
 =?utf-8?B?MmgwbU55MmE4RWpSL2t4cGdacWltajdKVjE1RVUyM01ZdXVBeE1yUENLdVBE?=
 =?utf-8?B?R013U2pCSmpDNzFwVlRZb3dFWkFNT0cwS2xLUCtjMzFQTE5DUGd2M1BoWk15?=
 =?utf-8?B?R1RJelA1U0lrWVd4czBwdmZUbFd2ZzA4K2FVV2o0UGVzbkkrbitLM1JlRDll?=
 =?utf-8?B?cDFPdGdJb0l3SmkxeDNZWWlxN054eCtVbktGdEhqVUFDWndKOTlIUTRROTc1?=
 =?utf-8?B?ZmIyTVh6cHJ1R3hwa0F3a0E4UFJXdVBCWlBnMEozdU9hZ3drSEpNUXN3RDNQ?=
 =?utf-8?B?WUFFbDc1QjJoNksza3BGUFlqdWdPZzlaZlFPcDIrc21URFhvR0NBYWFVM0RF?=
 =?utf-8?B?d3dQeHVVSGNDRk8xTHV2NERzWTlXNkdXK0gxYmtGOXRscDJVMEpJbGlqVzM0?=
 =?utf-8?B?QWpFMUNkc01EUG5KK0pCUjlXTUJyMWh5ZFpuemYvU003bzNNTWRPbERxTmFJ?=
 =?utf-8?B?N3V3OU5EUng3TUdPT2plcEJNdVVyUTl6YUNiYzFIYWdkRHQvL0RwdjlQdFVJ?=
 =?utf-8?B?YlIxS3RjcjdPNHUyd1VHNVRvVmNZeWs2WEpRMm8wdVloT0FZOVFmVXFmMXRz?=
 =?utf-8?B?MnFXZWdtYXpmRHVxVlZJYW5uanhpTDlML1FvR240Qk9nSzErY0hLRU5nWVZn?=
 =?utf-8?B?di9ScXRsZkoyTHlGNlF3NFRuVnRCbTMvOUIwNmVkLy9BZCtQaE5meER2WFpm?=
 =?utf-8?B?MkllL0IxbEI3ZlhUVC9kcnJSditjbW1NYjA0ckpsbjAxRU81NzBOSzZMaVJB?=
 =?utf-8?B?TS9DZlU4T3dIU0pKRmVUMkQ5elIyL2pOTVMzYW56WDBQNDUvVGJZM05iZzFS?=
 =?utf-8?B?M0VQWkpNSHlkajcvaGxCU3B1Z0trUHZiWFc4bGJiVGFLcUx4eDBna3lPYUk5?=
 =?utf-8?B?ZFlnQVMyVE5xRDlTOU1WUUlvTWo1ZmZZU0xMZk1oOHdLSmFyem5PYzN5Z256?=
 =?utf-8?B?WUg5eUhjODlwVWRYVlY0K3RzWHluT0N0SWU0WHdaUlpOUU1ZeHZ4b1NydUQz?=
 =?utf-8?B?SWdKM1N6OE9UOFdLd01VQyswcVZYMXpUNHNZTXIzdEQwVFM5MFZLUEhXcFM3?=
 =?utf-8?B?UndPc29MNmNoNXRXbFNyK1hoYzAvcU5PZVZoMTZKZlV6VHdua1pDQkhrM2hy?=
 =?utf-8?B?R1VoR1VWN0lOdDNPTk8zQWU2NVBjNVpvMEFha2ZBdmRmdVpWZkM0K2RnVkFJ?=
 =?utf-8?B?ZWZkL2VyY2FZYkVmaEw0TmtOZGFQNFQ3ckVLcTBRNVU1V0RFaXZtc3ZXdTZw?=
 =?utf-8?B?Sm1YUHJKaC9sYklkTU1zU0dtdEs2VW5pYzlqTytYRlZEY0EwcEdzV1h2ZlJu?=
 =?utf-8?B?S2Y5cVlJanVkalNLYm13NGovUTVYd3IwdGsyYXV2ZEZPTHdxS0FLLytRdHJz?=
 =?utf-8?B?WDBnQ1hKcHlWQ1hJYnI5M1pxL2hxdVZoQ0phTkFxczFNei9tQ3BQSVhSWk4y?=
 =?utf-8?B?TUwxRndJWEt2MEthK1hnVXh3S2RPTVZzeVJuMHFMY21taVhIbS9mNnNKbU11?=
 =?utf-8?B?eENCZ2hwYnkzelJ1cjF5cGpmckswRmJwcjc0cFk3Mm5TbmRaVFhGZmZlQWxW?=
 =?utf-8?B?eFBmSDZ3ZEd3ckJQN0JKYklid0g0dkpQSG1tNnZhNE8rdzYzdnd1OHJDdG9O?=
 =?utf-8?B?MklhcGdIWWtnckNESVhPV2I3WDJMeHNhUVROOURnR2lXSHV1QkpwRFNyVjFa?=
 =?utf-8?B?TytMU0RnWnFxb1NpU3NjS0kweVhzc3drV1N2MitRT1pub2dHN2JoVDVVenFp?=
 =?utf-8?B?b0NLUkt3bVA5WmZmM3k2Z0lSaE9ISmlPWDdLZ1FXZWdPWHpZSXdyeFBVYXl3?=
 =?utf-8?B?UjdqcFNDck1GRzZzR3FCUXJVWGJRaGlSTkFGOW9pWDRrVU1HeGpPTUVmWkVt?=
 =?utf-8?B?Y2pIU2dxeHAyS21UNmQ5UUFUL0ZMaDgwNEhZNEJjTFhTdjZHNjRkOU1nMzRN?=
 =?utf-8?B?T0M5TUxLRC8ySzQrcDBOZlRHdHlkV004RXNJR0JRaFhVUTU1TnYwYVB2cjdj?=
 =?utf-8?B?K2JTQnJmeUkxWm9XTlB4SFFUVGhBSG40aG0vWEJnYlk3Z2paenpKaXhmbVo4?=
 =?utf-8?B?cnc9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26525f3b-cda5-4247-d3c5-08da699dd846
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2022 15:46:28.6898
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HROxokb8xnf4L5ihRhkeSWnShAURQUpkidNQNE5UfLBYJ0eH4LclGYyoQEIYFwqCP1UUfRVLR7wLTcVkT8awfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB3579
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/19/22 11:38 AM, Vladimir Oltean wrote:
> On Tue, Jul 19, 2022 at 11:28:42AM -0400, Sean Anderson wrote:
>> Hi Vladimir,
>> 
>> On 7/19/22 11:25 AM, Vladimir Oltean wrote:
>> > Hi Sean,
>> > 
>> > On Mon, Jul 11, 2022 at 12:05:10PM -0400, Sean Anderson wrote:
>> >> For a long time, PCSs have been tightly coupled with their MACs. For
>> >> this reason, the MAC creates the "phy" or mdio device, and then passes
>> >> it to the PCS to initialize. This has a few disadvantages:
>> >> 
>> >> - Each MAC must re-implement the same steps to look up/create a PCS
>> >> - The PCS cannot use functions tied to device lifetime, such as devm_*.
>> >> - Generally, the PCS does not have easy access to its device tree node
>> >> 
>> >> I'm not sure if these are terribly large disadvantages. In fact, I'm not
>> >> sure if this series provides any benefit which could not be achieved
>> >> with judicious use of helper functions. In any case, here it is.
>> >> 
>> >> NB: Several (later) patches in this series should not be applied. See
>> >> the notes in each commit for details on when they can be applied.
>> > 
>> > Sorry to burst your bubble, but the networking drivers on NXP LS1028A
>> > (device tree at arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi, drivers
>> > at drivers/net/ethernet/freescale/enetc/ and drivers/net/dsa/ocelot/)
>> > do not use the Lynx PCS through a pcs-handle, because the Lynx PCS in
>> > fact has no backing OF node there, nor do the internal MDIO buses of the
>> > ENETC and of the switch.
>> > 
>> > It seems that I need to point this out explicitly: you need to provide
>> > at least a working migration path to your PCS driver model. Currently
>> > there isn't one, and as a result, networking is broken on the LS1028A
>> > with this patch set.
>> > 
>> 
>> Please refer to patches 4, 5, and 6.
> 
> I don't understand, could you be more clear? Are you saying that I
> shouldn't have applied patch 9 while testing? When would be a good
> moment to apply patch 9?

I'm saying that patches 4 and 5 [1] provide "...a working migration
path to [my] PCS driver model." Since enetc/ocelot do not use
devicetree for the PCS, patch 9 should have no effect.

That said, if you've tested this on actual hardware, I'm interested
in your results. I do not have access to enetc/ocelot hardware, so
I was unable to test whether my proposed migration would work.

--Sean

[1] I listed 6 but it seems like it just has some small hunks which should have been in 5 instead
