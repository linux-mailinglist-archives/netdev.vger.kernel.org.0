Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27F164563F9
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 21:20:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232082AbhKRUX0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 15:23:26 -0500
Received: from mail-db8eur05on2048.outbound.protection.outlook.com ([40.107.20.48]:42848
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230205AbhKRUXZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 15:23:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PMnifB4lpeOOc6bn+PbBzlQTeVP7QM48sL+B/GjEItGsVP9uRCsyA0mCsyelvXOnSMJp/xJHuSUAcg9AiF7vPQW8lPFwOZPQksU8xT+FXV2f/gcpFTxw+xKMPttI8ctWQJrKS5stTxKfb6TCvBfy/FycLjQsVveY1mz5KixA0jzTM8RMgJtKjicruIcQRXAWLiSUk/EfUSShrDPB9E3+GPcorYUz028k+oe158Oc5mSxli+haprSoDlZn8OQXfvu8i5AgrHSz+z/c3E2wEM51zT+S2Hs9cQFKs9/8o1XiuWRX8jtOWAxdFLnt15GETC7uE9G8ZDhwv/vkq/A3gmxng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/sh9VIExZEzQKVrgm4ge2Fe0AuHHIHeJIYRFdHGzL80=;
 b=HJ4PCj6Gx3pfrSu71rh1j0h56EFOShRwmbg1yvbN/x764p5m+rWGj3qHSej4yv34awADBd4GTsRKnJApV1HCUvIt2wdvHkVZfDzinynZLlqfHB9poel0+U7sBZv0cFGMqbB+jtC5qkavv6GqTiBpDEnDkwuveILsMaJOsINWJMfqdm2ERTlBZuSK6DyrqhJ7+oNGZT7lD7eLeUEfx8f30RmMZHRQ+bUsaWpAEkxeEiv8/7FYwujTdvGLjes7A37sQ/+SuhzSpX56JP5kOJkTjsypga6n7gD2D05PnPb5DdgKNux+Rqe4s0HO7JlOoUvwbX1IXkQxG3y5OJ3U/kko6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/sh9VIExZEzQKVrgm4ge2Fe0AuHHIHeJIYRFdHGzL80=;
 b=ZpIWb24eDEoRHoYy+YGLOeSRo2eZC8rIQy/ODp+66mZtq2gcdG4RmuwDywR7idCpFnMybwD+cvcZS86QvLY7OOI56Z7ozNoSf/JaAtsLcow3uFQJ3mBE/mLXK6NNE1bQwccPTc5lSn6uyY4NTbuv8a5zV0DKoN9vP6jrJ/q8s/I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB7PR03MB4858.eurprd03.prod.outlook.com (2603:10a6:10:7f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27; Thu, 18 Nov
 2021 20:20:23 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::9093:a60b:46b7:32ee]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::9093:a60b:46b7:32ee%4]) with mapi id 15.20.4713.022; Thu, 18 Nov 2021
 20:20:22 +0000
From:   Sean Anderson <sean.anderson@seco.com>
Subject: Re: [net-next PATCH v6] net: macb: Fix several edge cases in validate
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Parshuram Thombare <pthombar@cadence.com>,
        Antoine Tenart <atenart@kernel.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Milind Parab <mparab@cadence.com>
References: <20211112190400.1937855-1-sean.anderson@seco.com>
 <YZKOdibmws3vlMUh@shell.armlinux.org.uk>
 <684f843f-e5a7-e894-d2cc-3a79a22faf36@seco.com>
 <YZRLQqLblRurUd4V@shell.armlinux.org.uk>
 <YZZymBHimAhx8lja@shell.armlinux.org.uk>
Message-ID: <cfcb368f-a785-9ea5-c446-1906eacd8c03@seco.com>
Date:   Thu, 18 Nov 2021 15:20:18 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <YZZymBHimAhx8lja@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR12CA0018.namprd12.prod.outlook.com
 (2603:10b6:208:a8::31) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from [172.27.1.65] (50.195.82.171) by MN2PR12CA0018.namprd12.prod.outlook.com (2603:10b6:208:a8::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.20 via Frontend Transport; Thu, 18 Nov 2021 20:20:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 65ce05cb-1d15-4f61-b070-08d9aad0d964
X-MS-TrafficTypeDiagnostic: DB7PR03MB4858:
X-Microsoft-Antispam-PRVS: <DB7PR03MB4858284BCE5D663BCA107029969B9@DB7PR03MB4858.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kg4H7MwZkjW3Ldcm5nAmEu8UG1UxlTolpfKYJECi68YTNFwujWqNIb6Cr3uyNxMWknPVndbioi32rI9Z6qJXcpsaPIaSXH5wYOek7NaYEwKCFtpaa8qJUe+n7FVNzZr6Zd07Bl5oX4bHAUZt7HL2MX3kbZkpLiL7JcdsPXp+oQs37kQVJmugL10fqJZTqjXBiOkNXCkTc5vJ2wR2A/I3CHUi82Evw5nN8u/6iWBjh7gkmN82xSR6Cld/xPOCvr1vKxD4OXdcKWP11F8f953V+8kV18mQS4ng+f7px7YefQID6G/GO88j/hF8zbk2be0hrHiUkYbdEMo1Tm88CKbhqECOHcDaIDqD1TEbmelC4s4WslaqVE7MxHzW1XrbaQsCHXG8tWIsdWn4iep9Ozk0gaBj79CIF96441X+VWK1vV7slHrXhBvLl5RBu691b3C72rkVVfXtaUDkKd3cOuHdwxraFpnTkNgEmD0C3rZ+dSeJ9qcPW9ojJHSTTfkyMNOcVjPGaM9E1+B0ur1wawbdnGBx17x9rtDLCXF5GOHrbD3C3F0aMkAwAGUjFK6aiIR5K2qyoz3GhhJyBMfLKdX4v6XbhaVPxmFxizSWpuWCuuN1rfqmu1gL0OURS9357mEvRKjB6HslnM/K93mGZv448H73cBRlxSGZ1guZSyhS5SYOGwo6xwVDpSRd+8EwajxTjkmEMRVTbHbso/uPtwVl58g5Z96w4asEDrP4n0Cxd6qvoHBoIyVsK/nN8bJo5LFW6LahqBik3gUoiiXmpnPHbw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(31686004)(2906002)(54906003)(36756003)(2616005)(30864003)(38350700002)(66574015)(4326008)(5660300002)(86362001)(53546011)(15650500001)(956004)(508600001)(8676002)(44832011)(38100700002)(52116002)(83380400001)(31696002)(66556008)(6666004)(26005)(8936002)(66476007)(316002)(66946007)(16576012)(6486002)(6916009)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aER2TnptY21LRjFXQVMwcVVZTE4zOW91VjdQR0xVd2FzbU1meTJkUVlnN3NB?=
 =?utf-8?B?SXZHc2tzaGJqTnNmT2hCUzd6a2cyZ0dJS2d0d0ZBZWZITzA0VGFPYmNpaXFk?=
 =?utf-8?B?VkxVQ0M5Rk1ZYjdiTEhOQVhzMFZjZG0rcTBnNTk4UHk2MXloY3YrMWRXRzNi?=
 =?utf-8?B?QlNKbHNzV21Ka0p5U0JUK2hMZ0NzMXpXTlhKVnJ4NDBVZXdSNGNMSkJXd0hy?=
 =?utf-8?B?a0V3UkY5UnFCZWFyMUxHajJod2Jab1B0cGd3RHIwOHp5aEZKdDN5UjJFTDR6?=
 =?utf-8?B?ZHJBS3Y2bUxBSytCYWhFUGIxc25iUTdVdDRUdXRNZzI1RDFFckVYTVhmQkZU?=
 =?utf-8?B?SE52c1F0eWhXcWpvV0s2cTliRzNKci9pa210VERDc1ZMVmtuMElqbG9tcmpt?=
 =?utf-8?B?TFlMczM3Z3Q2UnRBNFlJYnU5dlUxdlNPZC9oTTE5V1ZGRHpIOUhLRUh3eXZu?=
 =?utf-8?B?Tng3OUhZZEM5TjFnWXB5NHVVd1RxeElUazhpV3lNUnpiZlZjN1IrZlJQNFoy?=
 =?utf-8?B?VnVJM3kycEVVQWtrR3JZRERzeFg2T2hOOG9KMEdoWkh0NklLS3ZTd3pVVG81?=
 =?utf-8?B?UlVWWTlpMENRUlhYbHFxZjNSRC9CdDRkWG45SHdiOHhiWDhyRzVxR2FFRC9X?=
 =?utf-8?B?bUhYNkEvQkFGbk14bEZoNkZtdnpIYzdTOGZzRU9MVHNOeFk5MWxpZVlkeEUv?=
 =?utf-8?B?cXR6N0ZaYzF5TXZyeFpOdXovV3paWHV3UnNHR1Z1ZUFLaU9qaTVkVGhDQy9z?=
 =?utf-8?B?MTEwWHNVVmdNZU94TEdXV0NEbmwzOVNvaWNwNEtpeWVwVU4wczhHRTlwWUZY?=
 =?utf-8?B?MXdKRW1qZVorWVl3WmdKQ1A2eE8yVkFaRmp0VUNaUE1PRk9UZmtpb3o4bXJs?=
 =?utf-8?B?QVhBMHBHbFRXU0dmTjRPT25QSjhjeTlZV3JnYzVuZkozakw1QmxmOXQ5ajBk?=
 =?utf-8?B?T0pwYVZmQXUvNktUSVRuTXRKejZrZkJOSGhKbFl0QUkyOXV2Q20xZjJTUVAz?=
 =?utf-8?B?SndNZ2pvMFp6RjdQeHdSbkU2NWFEUGlDRWNsZFp2K01BUTlheCtsR3RYRkJN?=
 =?utf-8?B?Z0lpY0FIRERncXQwbkNiQnJsZGRUdEIwQTJSV2E1NHQzVzM0bXRZWklaSkp1?=
 =?utf-8?B?ZWdYYThYUkNrL0V1eS9ScUxacEwzSEJHRk00MXlLWElxOFN2empic3Mrck04?=
 =?utf-8?B?d0NoZFJLTTBnSmpsa2UyUUlnM0VsWFdGN1l5bEN4SG9STDl5QVd0YW55NXVv?=
 =?utf-8?B?ejNmWjdpS2ZwL0w0WWtTakk4c0VXdHpHUno5WlhGclhPK0dpbnFCcWxHQXVy?=
 =?utf-8?B?YTJYVU9xWU51SG5Lc0RrUzZMVXljNWttTVlJM3NLOEczeDhNbFRuTXphT2Z4?=
 =?utf-8?B?dEFmaTZ1TnF5elNCQ2xSaUVsOGduUFZUWFlhalpMaG9OMFNmVmpoRFo2WUZB?=
 =?utf-8?B?a295YzRySVp6SFR5dDE5dURzMmhiSktFcDN0ZWRJekpXOFMyOEZ4THhDa25a?=
 =?utf-8?B?NEhvYzNuODFnNnVIRFFxdDFGclV1dFpuenMvMGVKRGVEQ2JYUkRKSHRxc3Fy?=
 =?utf-8?B?WXNiWWF1TmduM3VhWHQrcFdqRVdmRHlFamQxTDhSMjRBNkRLVDBuM2lUZWJm?=
 =?utf-8?B?QnRzMUpmdll2UW1FUTNiT3NUTTVra0J6N3BTWE0wUDFScWprc2RFRnFGWHFJ?=
 =?utf-8?B?TEZ2UUJmaHo3S3E0bm1Ua2g2MXRZRlhqa1UxazdpZkVrRWlSQkJCSGthN1R0?=
 =?utf-8?B?bTdqbFJ6NXkxUE53ZTFtb0ZxelRVWkZmNEV0YWMzblN4TDYwR1VvU1FFa0pZ?=
 =?utf-8?B?SS9LN3hDcStZcWNLNEpOZ1lXSFBwOTdjQXVUeWZLTlNkdU1VeVM5QkVWMjNY?=
 =?utf-8?B?K0hQM1pTTlRQVklhSVZhMXlHN0dZWStWSzZWUk54K0lqSGx2QzY2bWE3RFlD?=
 =?utf-8?B?cDZIWlp6K3I1OFRtZlJqdDZHc3dXYndUMDZEV0JuOWowSU9XajloamlYLzFP?=
 =?utf-8?B?aE1RTVBwUHV0UWJBUnovSXZ3V0RmS25HOVk5QWVFTTh0VEtPUVBuNVdMV2pH?=
 =?utf-8?B?TUtYemdNREdkdWE2YUJ5U2FUVGRCaTlXTmp5cTNBRW1GTVdNVEErdHBhcWJI?=
 =?utf-8?B?ckE4YmRKUDBFV3RoUi9OQ3BiRnVNOXdoek5ldlJLYzJkdS9icmxvT2hsUUg2?=
 =?utf-8?Q?nlUNCdH/gkr7J4OW+so/mqY=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65ce05cb-1d15-4f61-b070-08d9aad0d964
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2021 20:20:22.8558
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sdB7L3tE05/EQ17GhpAc6kGGitp+y2VLvxhWzeGaTemzqqWwFnADa5SRW1SVykdCVizx2DhQ4Tw/feym9y9ukg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB4858
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

On 11/18/21 10:34 AM, Russell King (Oracle) wrote:
> On Wed, Nov 17, 2021 at 12:22:26AM +0000, Russell King (Oracle) wrote:
>> On Tue, Nov 16, 2021 at 05:56:43PM -0500, Sean Anderson wrote:
>> > Hi Russell,
>> >
>> > I have a few questions/comments about your tree (and pl in general).
>> > This is not particularly relevant to the above patch, but this is as
>> > good a place as any to ask.
>> >
>> > What is the intent for the supported link modes in validate()? The docs
>> > say
>>
>> The _link_ modes describe what gets reported to userspace via the
>> ethtool APIs, and therefore what appears in ethtool as the supported
>> and advertised capabilities for the media, whatever the "media" is
>> defined to be.
>>
>> Generally, the "media" is what the user gets to play with to connect
>> two network interfaces together - so twisted pair, fibre, direct-attach
>> cable, etc.
>>
>> > > Note that the PHY may be able to transform from one connection
>> > > technology to another, so, eg, don't clear 1000BaseX just
>> > > because the MAC is unable to BaseX mode. This is more about
>> > > clearing unsupported speeds and duplex settings. The port modes
>> > > should not be cleared; phylink_set_port_modes() will help with this.
>> >
>> > But this is not how validate() has been/is currently implemented in many
>> > drivers. In 34ae2c09d46a ("net: phylink: add generic validate
>> > implementation"), it appears you are hewing closer to the documented
>> > purpose (e.g. MAC_1000FD selects all the full-duplex 1G link modes).
>> > Should new code try to stick to the above documentation?
>>
>> I try to encourage new code to stick to this - and this is one of the
>> motivations behind moving to this new model, so people don't make
>> these kinds of mistakes.
>>
>> In the case of nothing between the MAC and the media performing any
>> kind of speed conversion, the MAC itself doesn't have much to do with
>> which ethtool link modes are supported - and here's why.
>>
>> Take a gigabit capable MAC that is connected via SGMII to a PHY that
>> supports both conventional twisted-pair media and fiber. If the
>> twisted-pair port is in use at 1G speeds, then we're using 1000base-T.
>> If the fiber port is being used, then we're using 1000base-X. The
>> protocol between the PHY and MAC makes no difference to what link
>> modes are supported.
>>
>> A more extreme case could be: a 10G MAC connected to a backplane PHY
>> via 10G BASE-KR which is then connected to a PHY that connects to
>> conventional twisted-pair media.
>>
>> Or a multi-speed PHY where it switches between SGMII, 2500BASE-X,
>> 5GBASE-R, 10GBASE-R depending on the results of negotiation on the
>> twisted-pair media. The MAC supports operating at 10M, 100M, 1G,
>> 2.5G, 5G, and 10G speeds, and can select between PCS that support
>> SGMII, 2500BASE-X, 5GBASE-R and 10GBASE-R. However, ultimately for
>> userspace, what matters is the media capabilities - the base-T*
>> ethtool link modes. 2500base-X in this situation doesn't come up
>> unless the PHY offers 2500base-X on the media.
>>
>> The same PHY might be embedded within a SFP module, and that SFP
>> module might be plugged into a cage where the MAC is unable to
>> support the faster speeds - maybe it is only capable of up to
>> 2.5G speeds. In which case, the system supports up to 2500BASE-T.
>>
>> So you can see, the MAC side has little relevance for link modes
>> except for defining the speeds and duplexes that can be supported.
>> The type of media (-T, -X, -*R) is of no concern at this stage.
>>
>> It is of little concern at the PCS except when the PCS is the
>> endpoint for connecting to the media (like it is in _some_ 802.3z
>> connections.) I say "some" because its entirely possible to use
>> 1000base-X to talk to a PHY that connects to 1000base-T media
>> (and there are SFPs around that will do this by default.)

Of course, since 1000BASE-X is not an electrical specification, this is
really more like using 1000BASE-CX to 1000BASE-T :)

>> > Of course, the above leaves me quite confused about where the best place
>> > is to let the PCS have a say about what things are supported, and (as
>> > discussed below) whether it can support such a thing. The general
>> > perspective taken in existing drivers seems to be that PCSs are
>> > integrated with the MAC. This is in contrast to the IEEE specs, which
>> > take the pespective that the PCS is a part of the PHY. It's unclear to
>> > me what stance the above documentation takes.
>>
>> Things can get quite complex, and I have to say the IEEE specs give
>> a simplified view. When you have a SGMII link to a PHY that then
>> connects to twisted pair media, you actually have multiple PCS:
>>
>>                                  PHY
>>                       /----------------------\
>> MAC -- PCS ---<SGMII>--- PCS --- PCS --- PMA ---- media
>>      (sgmii)           (sgmii)   (1000baseT)
>>
>> This can be seen in PHYs such as Marvell 88E151x, where the fiber
>> interface is re-used for SGMII, and if you read the datasheet and/or
>> read the fiber page registers, you find that this is being used for
>> the fiber side. So the PHY can be thought of two separate PHYs
>> back-to-back. Remember that the PCS for 1000BASE-X (and SGMII) is
>> different from the PCS for 1000BASE-T in IEEE802.3.

Right and this is a bit of the source of the confusion. There are
different levels/layers of PHYs all with their own PCS/PMA/PMD stack.
Depending on what perspective you take at the time, some of these can be
subsumed into each other.

>> The point I'm making here is that the capability of the link between
>> the MAC and the PHY doesn't define what the media link modes are. It
>> may define the speeds and duplexes that can be supported, and that
>> restricts the available link modes, but it doesn't define which
>> media "technologies" can be supported.

Right. IMO there is a lot of conflation of this concept in the current
net subsystem. Realistically, the MAC should only be concerned with the
phy interface mode, and perhaps duplex and speed. But! This should be
the interface mode needed to talk to *the next stage in the signal
path*. That is, if the MAC has GMII output and needs a separate PCS to
talk 1000BASE-X or SGMII, it should only report GMII. And then the PCS
can say what kind of interface it supports. However, the current model
assumes that the PCS is tightly integrated, so these sorts of things are
not modeled well. I don't know whether the above change would be
feasable at all. Ideally, validate() would talk about interfaces modes
and not link modes.

>> Hence, for example, the validate() implementation masking out
>> 1000base-X but leaving 1000base-T on a *GMII link is pretty silly,
>> because whether one or the other is supported depends ultimately
>> what the *GMII link ends up being connected to.
>>
>> > Consider the Xilinx 1G PCS. This PCS supports 1000BASE-X and SGMII, but
>> > only at full duplex. This caveat already rules out a completely
>> > bitmap-based solution (as phylink_get_linkmodes thinks that both of
>> > those interfaces are always full-duplex).
>>
>> I don't see why you say this rules out a bitmap solution. You say that
>> it only supports full-duplex, and that is catered for in the current
>> solution: MAC_10 for example is actually MAC_10HD | MAC_10FD - which
>> allows one to specify that only MAC_10FD is supported and not MAC_10HD
>> in such a scenario.

Say that you are a MAC with an integrated PCS (so you handle everything
in the MAC driver). You support GMII full and half duplex, but your PCS
only supports 1000BASE-X with full duplex. The naïve bitmap is

supported_interfaces = PHY_INTERFACE_GMII | PHY_INTERFACE_1000BASEX;
mac_capabilities = MAC_10 | MAC_100 | MAC_1000;

but this will report 1000BASE-X as supporting both full and half duplex.
So you still need a custom validate() in order to report the correct link
modes.

The tricky part comes in a scenario where the exact MAC is determined at
runtime, such as the MACB+Xilinx PCS configuration.

>> Hmm. Also note that the validate() callback is not going away -
>> phylink_generic_validate() is a generic implementation of this that
>> gets rid of a lot of duplication and variability of implementation
>> that really shouldn't be there.
>>
>> There are cases where the generic implementation will not be suitable,
>> and for this phylink_get_linkmodes() can be called directly, or I'd
>> even consider making phylink_caps_to_linkmodes() available if it is
>> useful. Or one can do it the "old way" that we currently have.
>>
>> > There are also config options
>> > which (either as a feature or a consequence) disable SPEED_10 SGMII or
>> > autonegotiation (although I don't plan on supporting either of those).
>> > The "easiest" solution is simply to provide two callbacks like
>> >
>> > 	void pcs_set_modes(struct phylink_pcs *pcs, ulong *supported,
>> > 			   phy_interface_t interface);
>> > 	bool pcs_mode_supported(struct phylink_pcs *pcs,
>> > 				phy_interface_t interface, int speed,
>> > 				int duplex);
>> >
>> > perhaps with some generic substitutes. The former would need to be
>> > called from mac_validate, and the latter from mac_select_pcs/
>> > mac_prepare. This design is rather averse to genericization, so perhaps
>> > you have some suggestion?
>>
>> I don't have a good answer for you at the moment - the PCS support
>> is something that has been recently added and is still quite young,
>> so these are the kinds of issues I'd expect to crop up.
>>
>> > On the subject of PCS selection, mac_select_pcs should supply the whole
>> > state.
>>
>> That may seem like a good thing to ask for, but not even phylink
>> knows what the full state is when calling the validation function,
>> nor when calling mac_select_pcs.
>>
>> Let's take an example of the Marvell 88X3310 multi-speed PHY, which
>> supports 10G, 5G, 2.5G, 1G, 100M and 10M on copper, and 1G and 100M
>> on fiber, and can do all of that while connected to a single serdes
>> connection back to the MAC. As I've said above, it does this by
>> switching its MAC connection under its internal firmware between
>> 10000Base-R, 5000Base-R, 2500Base-X, and SGMII. This PHY has been
>> found to be used in platforms, and discovered to also be in SFP
>> modules. Beyond programming the overall "host interface" mode, we
>> don't get a choice in which mode the PHY picks - that is determined
>> by the results of which interface comes up and autonegotiation on
>> that interface.
>>
>> So, if the PHY decides to link on copper at 2500BASE-T, then we end
>> up with the MAC link operating at 2500BASE-X, and there's nothing
>> we can do about that.
>>
>> The only way to restrict this is to know ahead of time what the
>> capabilities of the MAC and PCSes are, and to restrict the link
>> modes that phylib gives us in both the "supported" and "advertising"
>> fields, so the PHY will be programmed to e.g. not support 2500BASE-T
>> on copper if 2500BASE-X is not supported by the PCS, or 2.5G speeds
>> are not supported by the MAC.
>>
>> This isn't something one can do when trying to bring the link up,
>> it's something that needs to be done when we are "putting the system
>> together" - in other words, when we are binding the PHY into the
>> link setup.
>>
>> Now, this is quite horrible right now, because for PHYs like this,
>> phylink just asks the MAC's validate function "give me everything
>> you can support" when working this out - which won't be sufficient
>> going forward. With some of the changes you've prompted - making
>> more use of the supported_interfaces bitmap, and with further
>> adaption of phylib to also provide that information, we can start to
>> work out which interface modes the PHY _could_ select, and we can then
>> query the validate() function for what is possible for each of those
>> interface modes, and use that to bound the PHY capabilities. However,
>> at the moment, we just don't have that information available from
>> phylib.
>>
>> > This is because the interface alone is insufficient to determine
>> > which PCS to select. For example, a PCS which supports full duplex but
>> > not half duplex should not be selected if the config specifies half
>> > duplex. Additionally, it should also support a selection of "no pcs".
>>
>> Right now, "no pcs" is really not an option I'm afraid. The presence
>> of a PCS changes the phylink behaviour slightly . This is one of my
>> bug-bears. The evolution of phylink has meant that we need to keep
>> compatibility with how phylink used to work before we split the PCS
>> support - and we detect that by whether there is a PCS to determine
>> whether we need to operate with that compatibility. It probably was
>> a mistake to do that in hind sight.

Of course it's an option :)

Consider the MACB driver. It has two PCSs in some configurations, and
thus is a natural target for implementing the select_pcs callback.
However, in some other configurations, it has no PCSs at all. The only
way to implement select_pcs in the current design is to have two sets of
phylink_mac_ops: one with select_pcs populated, and one with it set to
NULL.

The correct check is probably something like

	if (pl->mac_ops->mac_select_pcs) {
		pcs = pl->mac_ops->mac_select_pcs(pl->config, state->interface);
		if (!pcs && pl->pcs)
			phylink_err(pl, "mac_select_pcs unexpectedly failed\n");
		else if (pcs)
			phylink_set_pcs(pl, pcs);
	}

>> If we can find a way to identify the old vs new drivers that doesn't
>> rely on the presence of a PCS, then we should be able to fix this to
>> allow the PCS to "vanish" in certain modes, but I do question whether
>> there would be any realistic implementations using it. If we have a
>> PHY connected to a serdes lane back to a set of PCS to support
>> different protocols on the serdes, then under what scenario would we
>> select "no pcs" - doesn't "no pcs" in that situation mean "we don't
>> know what protocol to drive the serdes link" ?
>>
>> > Otherwise MACs which (optionally!) have PCSs will fail to configure. We
>> > should not fail when no PCS has yet been selected or when there is no
>> > PCS at all in some hardware configuration.  Further, why do we have this
>> > callback in the first place? Why don't we have drivers just do this in
>> > prepare()?
>>
>> I added mac_select_pcs() because finding out that something isn't
>> supported in mac_prepare() is way too late - as explained above
>> where I talked about binding the PHY into the link setup. E.g. if
>> the "system" as a whole can't operate at 2.5G speeds, then we should
>> not allow the PHY to advertise 2500BASE-T. It is no good advertising
>> 2500BASE-T, then having the PHY negotiate 2500BASE-T, select 2500BASE-X,
>> and then have mac_prepare() decide that can't be supported. The link
>> won't come up, and there's nothing that can be sensibly done. The
>> user sees the PHY indicating link, the link partner indicates link,
>> but the link is non-functional. That isn't a good user experience.
>>
>> Whereas, if we know ahead of time that 2.5G can't be supported, we can
>> remove 2500BASE-T from the advertisement, and the PHY will instead
>> negotiate a slower speed - resulting in a working link, albiet slower.

AIUI it's a bug in the driver to advertise something in validate() which
it can't support. So we don't necessarily need a separate callback.

>> I hope that explains why it is so important not to error out in
>> mac_prepare() because something wasn't properly handled in the
>> validate() step.

Specifically, "I don't need a PCS for this mode" should be a valid
response. I agree that "I can't select a PCS" doesn't make sense.

> What I haven't described in the above (it was rather late when I was
> writing that email!) is where we need to head with a PHY that does
> rate adaption - and yet again an example of such a PHY is the 88X3310.
> This is actually a good example for many of the issues right now.
>
> If the 88X3310 is configured to have a host interface that only
> supports 10GBASE-R, then rate adaption within the PHY is activated,
> meaning the PHY is able to operate at, e.g. 10BASE-T while the host
> MAC operates at 10GBASE-R. There are some provisos to this though:
>
> 1) If the 88X3310 supports MACSEC, then it has internal MACs that
>     are able to generate pause frames, and pause frames will be sent
>     over the 10GBASE-R link as necessary to control the rate at which
>     the MAC sends packets.
>
> 2) If the 88X3310 does not support MACSEC, then it is expected that
>     the MAC is paced according to the link speed to avoid overflowing
>     the 88X3310 internal FIFOs (what happens when the internal FIFOs
>     overflow is not known.) There are no pause frames generated.
>     (This is the case on Macchiatobin boards if we configured the PHY
>     for 10GBASE-R rate-adaption mode.)

Well if it just drops/corrupts packets then it just looks like a
lossy/congested link. And the upper layers of the network stack already
expect that sort of thing (though perhaps not optimally).

> We have no "real" support for rate adaption at either phylib or phylink
> level - phylib has no way to tell us whether rate adaption is enabled
> on the PHY, nor does it have a way to tell us if we either need to pace
> the MAC or whether to expect pause frames from the PHY.
>
> If we have a PHY in rate adaption mode, the current behaviour will be
> that mac_link_up() and pcs_link_up() will be passed the negotiated
> media parameters as "speed", "duplex" and any flow control information,
> which will confuse PCS and MAC drivers at the moment, because it isn't
> something they expect to happen. What I mean is, if we are using
> PHY_INTERFACE_MODE_10GBASER, then most people will expect "speed" to be
> SPEED_10000, but with a rate adapting PHY it may not be.
>
> In order to properly support this, we need to update the documentation
> at the very least to say that what gets passed to mac_link_up() for
> "speed" and "duplex" are the media negotiated parameters. Then we need
> to have a think about how to handle flow control, and this is where
> extending phylib to tell us whether the PHY supports rate adaption
> becomes important. Flow control on the MAC needs to be enabled if (the
> PHY has rate adaption disabled but the media negotiated flow control)
> or (the PHY has rate adaption enabled _and_ the PHY is capable of
> issuing flow control frames - presumably the PHY will respond itself
> to flow control) or (the PHY has rate adaption enabled and the media
> negotiated flow control but the PHY is not capable of issuing flow
> control frames).
>
> Then there's the issue of implementing transmission pacing in any MAC
> driver that wants to be usable with a rate adapting PHY.
>
> Lastly, there's the issue of the "speed" and "duplex" parameters passed
> to pcs_link_up(), which I'm currently thinking should be the interface
> parameters and not the media parameters. In other words, if it's a
> 10GBASE-R connection between the PHY and PCS, we really should not be
> passing the media negotiated speed there.

Right.

> So, to sum up, rate adaption isn't something that is well supported in
> the kernel - it's possible to bodge around phylib and phylink to make
> it work, but this really needs to be handled properly.
>
>
> Rate adaption is fairly low priority at the moment as it is in a
> minority, although it seems we are seeing more systems that have PHYs
> with this feature.
>
> So, I hope these two emails have provides some useful insights.

They have, thanks.

--Sean
