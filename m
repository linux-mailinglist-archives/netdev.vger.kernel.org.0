Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1EA865F40B
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 20:01:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235207AbjAETA6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 14:00:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235265AbjAETAe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 14:00:34 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2043.outbound.protection.outlook.com [40.107.22.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33DF65F4BF;
        Thu,  5 Jan 2023 11:00:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MlUw3G9pzl5d4g4y5ZupaasQv/mo+WBhxwF+HBXfekqgo5EM78takazO7chYaAVztzIk7XEbpGMRKhSo9LzOnvsr8BjJGw/UoIG6omCy3soaRPxDXDoZQrYr5u8XxOnORcmADfBFfOYH7eTIZGB5M8nkmTJFT91wplpdOtCjnIS3yKFIUMhCHRm1vmc4/rbP9su9QQwE8xnTnB5iXmSUp/u45abhUAyfA/uE21xojF5uBxMkjTc3sLHXXDpXPA71ei/WW3AGhJHKOUne8bFQxVVoWyEBKQZruarePRkm5Ik1T+BU7KX4/z+JmkQIzzK6g7kUimgXC/yFbxqV3vGMdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q2ujxqMS4SPh9jESZePqqmhmsE574bCtV/Nm4g1wOmw=;
 b=b08wbpftemvvWugd3C8agkyxFTMRUCLlu3Yxk+vHQN6Xkq+6Nu9LmOgiR4QMb2xhR5Jc5RCAUmG2OWpgnZjcifSaPROe+U/RXQArBxZAFsOA+7LAxnlb21c6+3gPbEkcfkx9+Z43BTQTJm/rGK855gd+EjwfIRKi6O2H799I2BtdArl7b00VGXTJuhKedNnpvqS9d33hW1Vp21ev6rT5OTCdxz0uj/kSAzDApEIaYTxnFyh0dHo17kd9MKq/nXaAoP3Uzs2evq9JiGdmMNf24Pz6/WmYTvkTiK9eOnhMgIW51ErT9EF1hNVASOgkawvHTtIs1awRFuIoRFsYVFHM9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q2ujxqMS4SPh9jESZePqqmhmsE574bCtV/Nm4g1wOmw=;
 b=H0Z4KOoyZGP/2HzobnOos9WlYV3mHtqDfJ+2k5tKt+GX3N2bO05hCtE8QOPLl8yUe4xSLCS6bkDvHWPaKQhlA1MGGVkMxBviLAOhdckvPf+PQIjROeh2rLKZtrqDPb/Zf13ziSPs/VFZCCjhTH+6m1xrFeeAtz495wGwW9Qp4KSUPkaerH3HZ+7/VhwG8wgeBfgo43hTXwPo5c4htJ8KPELTUfwuffzljPismAteKfguEi3LmQJfAi1zlkyeXC+wznWnRpz/AtqjR33OrspNt9KFhJrD9ZgrlRzjhwZQcDVhXWeDE8gPe3IGVvQ6JDqLFQFVv19mk4FzCm/iWH4qgQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
 by AM9PR03MB7712.eurprd03.prod.outlook.com (2603:10a6:20b:3dd::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Thu, 5 Jan
 2023 19:00:31 +0000
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb]) by DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb%8]) with mapi id 15.20.5944.019; Thu, 5 Jan 2023
 19:00:31 +0000
Message-ID: <f777e276-d26e-22f7-f737-c07f49b20bd9@seco.com>
Date:   Thu, 5 Jan 2023 14:00:23 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH net-next v5 4/4] phy: aquantia: Determine rate adaptation
 support from registers
Content-Language: en-US
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Tim Harvey <tharvey@gateworks.com>
References: <20230103220511.3378316-1-sean.anderson@seco.com>
 <20230103220511.3378316-5-sean.anderson@seco.com>
 <20230105140421.bqd2aed6du5mtxn4@skbuf>
 <6ffe6719-648c-36aa-74be-467c8db40531@seco.com>
 <20230105173445.72rvdt4etvteageq@skbuf>
 <3919acb9-04bb-0ca0-07b9-45e96c4dad10@seco.com>
 <20230105175206.h3nmvccnzml2xa5d@skbuf>
 <20230105175542.ozqn67o3qmadnaph@skbuf>
 <39660d10-69b9-fa52-5a49-67d5f7e1acaf@seco.com>
 <Y7cd3DrnKxNmHVcp@shell.armlinux.org.uk>
From:   Sean Anderson <sean.anderson@seco.com>
In-Reply-To: <Y7cd3DrnKxNmHVcp@shell.armlinux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR07CA0009.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::19) To DB9PR03MB8847.eurprd03.prod.outlook.com
 (2603:10a6:10:3dd::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR03MB8847:EE_|AM9PR03MB7712:EE_
X-MS-Office365-Filtering-Correlation-Id: 27badda1-c534-4f55-64a3-08daef4f1de4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qPQirTryUDDxNR3B2bzB0pskuZ7d1MyCjvyYPpybyjaHSSweB2US2ATVb8K+kvt0nok+uNU20iCLqUnGOf30aIGa6jNMPoXaCyijyomnJ48101Egbf9zq2Sxb/1ug/SVOmlGsi2rPP6hN3rDmclktuE1TRhSdi4NnKH8U6dstlQJ7aLpyLvLEwy9ZAniOPJq7lg0AiAuT7m/cI3p4skwkOUFJoBDEbF5XxlqVEeBlU4o1z2bXCUcQwTCNEUsm/PqWNW9jjedx5WZC1SiDpU7Gu9x5pGUp4v9zzqXwa2Lr/7p2oBY4y9YB8bwKGKNLvn1OZnlt3jJMldSFeEaMLZcaPrhrq1+cSaII8XSa5UNumaUcxTyXy8Vb+WrRLak7uawJ5qxswEGkx0qAhmLOGIsZqB1guFF36CcNz+fjFK3tqhA0hO8bgJV1YnZrFLJHV5dsvE9fTQX5EL6AbnrswNGg6/Wt8s4orZZK3uxx/ytQyQuSpQfTk6Kc8DXh8zfPfW8Tg5y2v5/ivSxZOJTPLiX0ycwDLIso2BI6LKGn1Zb2HaxLIbgA50ZqTOm2rGREL8zkORGgGviTrRqIYDtYWX1mNZsHI6zOEDqqp0npNRhYYWIwaNQMPXgF342RIxq2eeuF5H5wN6OEQ8KB4MfrjMq7HUnPko1TIugOagxNtq6soXjxA7Ahoq0W1f6NaZpFV7PI8PMyR32wTIY5Dn9RBN+dVDcXeysebIl6Zx4CIYmNFsY+FUFgzJCrkeqRQn0m/FwmQs6ewEV3rxlQId/vrOzBw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR03MB8847.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(366004)(396003)(376002)(39850400004)(451199015)(7416002)(6666004)(8676002)(5660300002)(316002)(66476007)(66946007)(66556008)(4326008)(54906003)(41300700001)(8936002)(6486002)(6916009)(52116002)(2906002)(478600001)(6506007)(38100700002)(38350700002)(53546011)(6512007)(186003)(2616005)(26005)(31696002)(86362001)(44832011)(31686004)(36756003)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ekh3QWo3UjFYTUFGcFY0NHZUT04zOGFoOHZHMldaa25meFcvR1RYRmJyeHlN?=
 =?utf-8?B?Wm9LMVFVaFhNUWZpbDI1dG1ZZDZnRFJaaENyQjZjSytUQVNNRFdEMHdpaVdX?=
 =?utf-8?B?SmhodWlqeGc4Z2Z0Mjl3Ym45Zk9adkN1NTdIaStPaXU2aitSbFB4NWV6ZWND?=
 =?utf-8?B?MFpPMTJuNEY3eWV1Mm4yYVpMWSsydmlaZ3NNUUp0K3VwVkx3NVVWYjVNZmdk?=
 =?utf-8?B?UzJtM0dVczE0MU1kSVpBQ1lablNsYjR3eWN6N2VPVkJVWW8xTnBIRVBwdmhv?=
 =?utf-8?B?UGJ6NE9sYlkweTRQRVh1YzMzc1plN1piaExnWHlRT2dDNDdON2ZwcnBGSXpR?=
 =?utf-8?B?S1JrWEpZRDBsV2I5Q211cU50ampTMk5xU3FPaHh6QVJPeDdsVFc4TjhqdmNK?=
 =?utf-8?B?b1Vka1lIY2ptUnd4WVRwbzh2bXg1WE1pWEExeU9sWHZJME5WR0VCT2VZRVJz?=
 =?utf-8?B?QVplRUtqQ3B2NzZwNDhvSzdlcS9SZHMzZVNUVk5WZHB0T0w3OWFFVGlSalUx?=
 =?utf-8?B?aS96RWRwQW5MdlJ4MUtCNTJEbTRIUXpGTGN0azJGNk1vVVpyNXFZZWJ5aVFr?=
 =?utf-8?B?a0g0b2VoQitrb2U4Y3p3dU15OCt1cW9wWFdhbkpSZG5HVzJLbEhMQnQ1bGs4?=
 =?utf-8?B?a0JHY09laGlTcnZzY0lRMXAzdkFMZEI4QnNOQWkxalRCNlJTV1I0R1BjZ1lj?=
 =?utf-8?B?OXNlUDFNS0tBYmd1NmJINE5MZUo1NnBrRSs4Y0Nyd1ZRdS90Rks2R1RDcDln?=
 =?utf-8?B?WWhMcS9SK3o2dTVsWjFubWJJcDBVcXRFL0tJS0F0YjhGcXlJQjA0QlgxK25B?=
 =?utf-8?B?Q29ucm0wRnF2OFlPa0FnVVVOTVBockpvU21ESkRRRVNiQ2h4NzBPV1UzbjBM?=
 =?utf-8?B?dTV2Q0I1R3BkVXlGaDZKYWVVR2lNRXdOUThqRncvVjRram0vNVM1Y0JKRkQr?=
 =?utf-8?B?UU5wWHo5bDVYSXFpcHl0dGdqL1l4NC9WRmFoVUpFR203Nkdka0RmbDBiVzM0?=
 =?utf-8?B?OXJUVUFnMjlPdC95YkZydmtVb2dhS3lkZTFtdHc2dVJOWmUvajI0czJQRlh2?=
 =?utf-8?B?SExJQXVRU2EyNkNUV1R2bXdVdFFxdE5EdCt3S1R1c1VMblg3Mk5PMHowWk9I?=
 =?utf-8?B?ejR5b09rZUVuNEVyTDFNVG9tcWNjNDVSRGtxRWFsUWdWVVVyb2JsdlB6MzdZ?=
 =?utf-8?B?NnR5Z0tDOG5FVG5CTGFDalk1NDN0UXhRZk1SakNvRmhJM2xYcTJvTFNFSHM3?=
 =?utf-8?B?dWcrNDJrdFhBazVxaE4weXJhcHlzR3grZDkwd0FFRGs3YnVtUmRGQ0NudWZX?=
 =?utf-8?B?VUZ3NTBQOE0xODFiUS92bkxTejdxRHZ2dkd5VXZlVkw2UDhCeXk0U2tRVFI0?=
 =?utf-8?B?UU9RZFY5MmVBVlZMT2Fnc0Fqem9ERE54ZHhQZjc3ZFNub3ZBa3QwNWdEVGkw?=
 =?utf-8?B?S3N0VHczblZpTnNFZVhiRm1QeXZjSjNMSGFjcHdDOTdKeWp0V2NTTjg4V0lz?=
 =?utf-8?B?MW50djdtQkVueWFCbEdEcjZSU21kaUdDc2tpQlk1NXE0d1c0TWN6Yk9yMlgx?=
 =?utf-8?B?WWVKREM0SUc3M1FJRE40dHhzdjNmRldBNTErcjRaTHF6NDhQVjNXYTBLaFZH?=
 =?utf-8?B?cXQxeXVNOGdGRUMrVXZUU0MrZSs3a01pNWxRa2ZObFNYT0Q2Y28yNWZtTTdZ?=
 =?utf-8?B?ODdaMEZFbGVKeUpyRVBCL3RWZjB5KzNZdHc5MVlISUhmL1lKaUdpdW1PdUJR?=
 =?utf-8?B?SHJmcEJWTkkwcm1QM3h2eERJdmJlRmpRb2RFU2pEY24ySVI0Q2szTWJOTThY?=
 =?utf-8?B?eFRnT2xWZHRTV1loaEhaaGIyN0ovakxqQkJmekdEOHYvaHhodkVlWm5TZGdN?=
 =?utf-8?B?MmQrTUUrdTdWb0t0c2JqbytFQWhPYVRTdm85TWNiVWVrRHFUMGhzZ2tUclNW?=
 =?utf-8?B?MWVEMVEyS1huSHJEcEloRW5zcEplZ21JNHp1cXh0Q1hhcWdUazdiWXNZR0c1?=
 =?utf-8?B?bVk0YXFDZkFmNittQVB0WmhmWnJhZnh5VHRuUG9oUkE4djlRemhpVlVsN2tp?=
 =?utf-8?B?aXNFYXlYUk5VZFdHUzNLTUpFYmZEOHd2YkZTZzEzdTk5RWhsb215YlJuY3FP?=
 =?utf-8?B?S1Z3YldWek55VHlxNkhETXRhMktQSzJoa0w3MitDRjBRRGhkZnM3ODVxKzJn?=
 =?utf-8?B?Unc9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27badda1-c534-4f55-64a3-08daef4f1de4
X-MS-Exchange-CrossTenant-AuthSource: DB9PR03MB8847.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2023 19:00:31.0870
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L91SpSB+aJFGxcHeHS+B708OyPlVuwNIxcQUOL9FQ7eoUnmZMh5icopmNh4yMGfdReyoUKKfto0peKyBj9QFiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR03MB7712
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/5/23 13:58, Russell King (Oracle) wrote:
> On Thu, Jan 05, 2023 at 01:03:49PM -0500, Sean Anderson wrote:
>> On 1/5/23 12:55, Vladimir Oltean wrote:
>> > On Thu, Jan 05, 2023 at 07:52:06PM +0200, Vladimir Oltean wrote:
>> >> On Thu, Jan 05, 2023 at 12:43:47PM -0500, Sean Anderson wrote:
>> >> > Again, this is to comply with the existing API assumptions. The current
>> >> > code is buggy. Of course, another way around this is to modify the API.
>> >> > I have chosen this route because I don't have a situation like you
>> >> > described. But if support for that is important to you, I encourage you
>> >> > to refactor things.
>> >> 
>> >> I don't think I'm aware of a practical situation like that either.
>> >> I remember seeing some S32G boards with Aquantia PHYs which use 2500BASE-X
>> >> for 2.5G and SGMII for <=1G, but that's about it in terms of protocol switching.
>> >> As for Layerscape boards, SERDES protocol switching is a very new concept there,
>> >> so they're all going to be provisioned for PAUSE all the way down
>> >> (or USXGMII, where that is available).
>> >> 
>> >> I just pointed this out because it jumped out to me. I don't have
>> >> something against this patch getting accepted as it is.
>> > 
>> > A real-life (albeit niche) scenario where someone might have an Aquantia
>> > firmware provisioned like this would be a 10G capable port that also
>> > wants to support half duplex at 10/100 speeds. Although I'm not quite
>> > sure who cares about half duplex all that much these days.
>> 
>> IMO if we really want to support this, the easier way would be to teach
>> the phy driver how to change the rate adaptation mode. That way we could
>> always advertise rate adaptation, but if someone came along and
>> requested 10HD we could reconfigure the phy to support it. However, this
>> was deemed too risky in the discussion for v1, since we don't really
>> know how the firmware interacts with the registers.
> 
> I'm not sure about "someone came along and requested 10HD". Don't you
> mean "if someone plugged the RJ45 into a 10bT hub which only supports
> 10HD" ? Or are you suggesting that we shouldn't advertise 10HD and
> 100HD along with everything else, and then switch into this special
> mode if someone wants to advertise these and disable all other link
> modes?
> 

The former. "someone" being userspace or the remote end.

--Sean
