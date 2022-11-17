Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 507C162E9B0
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 00:40:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235002AbiKQXkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 18:40:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiKQXkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 18:40:13 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2078.outbound.protection.outlook.com [40.107.22.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB2C9769F9;
        Thu, 17 Nov 2022 15:40:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UhROOCUHMVvUVue0ZmGlbVtfmKYVGYxFB0Zw6SfRDowZr3orYBGU15tRT6wvu9bk79f8dEOySYa6rRtsiY4g2VmMZbSs3EtLiwGzgN479f2qbevtE57Smob+sw05QEEXv1gXru+JSgsQicpkzDfrKOXjyXLv/HywLi3QBeZ6ZCUOqAD3UE9LJUUN8iTsmJ9jKmDtZqPEc2bISIZNqCRUJuGRZP7ErwBAl5Oe7xhy8YgcQyPS9nkjK3vvgNjYv6qYAbHCtg96mJ1s4wKHbgkO7aOcPEJxBBdIlSZEt/AXwt/b0PygWv/kIKRoHvZSKt/5SroCqIPZAE2NZSAeauSHsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PiZKtffDsPkvmzlQVz7uSSEblYZ17iUmem+n+/lj/3Q=;
 b=R24ebTBg4t3WHR+6zOx2CNiY6hPz9Gz1qWh4/U+09HPOPz3V0kd12UZjPi+aRJ5rPDDWakERBwZO1iYe4BwO87DDV5LS3QdU85ba5u9hUj12stFFARveGvm0NIgE0rtEbG7gZ2fmTxzVU2WfqqGNn1mo3H8BhbkBEAIBmsa1YTQOITdUkqwl0VTW1i3CvYyF8BpzT7oBye1UxBHjRapFWTeKnS24CCTfgQn5GtinEkOpclbCYSQJstf2/1MNZRgaVgXn5AGM64jWJA5T5RPp3YL2Fj4QefCutcI4bDfP3Y71Dnwph0xVNe5Mk7V2af3M5LV9Ybxn6oZE7mAOxLjDJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PiZKtffDsPkvmzlQVz7uSSEblYZ17iUmem+n+/lj/3Q=;
 b=bQTZwMgNWrv+0oQcaSdJaY6UDpVOWjgQyRNFZPmiQyY8hUXOZVtKIDsBV0JnQDDoImruGg7eDhMbzz805dsQZos2zMh4KVh9BvAHbC92DQ7SvC6Fm+muPpT5I1SzXCiOtr6/2XA/ovgMt3bmZlqmISAxMtAPZ/tNYipkb8387zTgbI6T7TSXFjasObHnVGEL7TSpUaJcpp0ceDAnve7UoE0VLydwIcMmA3oHxleeXpmnzfYebd6ZZ2eXaeRt3octTfuGMBTxg+GvpcTou/NbadKgFCKRZMmlyc7PyvT3Q/qxMbKgq4IIY8IT+U+gMCC2dlFoSXjRTeeC0SydVkmZrg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
 by DB8PR03MB6330.eurprd03.prod.outlook.com (2603:10a6:10:136::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.16; Thu, 17 Nov
 2022 23:40:09 +0000
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb]) by DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb%6]) with mapi id 15.20.5813.019; Thu, 17 Nov 2022
 23:40:08 +0000
Message-ID: <219dc20d-fd2b-16cc-8b96-efdec5f783c9@seco.com>
Date:   Thu, 17 Nov 2022 18:40:02 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH] phy: aquantia: Configure SERDES mode by default
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Tim Harvey <tharvey@gateworks.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
References: <20221114210740.3332937-1-sean.anderson@seco.com>
 <20221114210740.3332937-1-sean.anderson@seco.com>
 <20221115223732.ctvzjbpeaxulnm5l@skbuf>
 <3771f5be-3deb-06f9-d0a0-c3139d098bf0@seco.com>
 <20221115230207.2e77pifwruzkexbr@skbuf>
From:   Sean Anderson <sean.anderson@seco.com>
In-Reply-To: <20221115230207.2e77pifwruzkexbr@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0323.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::28) To DB9PR03MB8847.eurprd03.prod.outlook.com
 (2603:10a6:10:3dd::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR03MB8847:EE_|DB8PR03MB6330:EE_
X-MS-Office365-Filtering-Correlation-Id: 2be505e0-8e12-4221-4752-08dac8f50ecd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ycw1ZB6Y1juuW6u39dglMeykvolq0Y66G+LBUZKfbuECbEhYUz107m8Kq9P6fS0wcZsC1JgK0l0jnlqFu0/8VPgREMc0AaMzGRNGFXz04OzFnPoTbnp9jrZLl2AbKKZtKMGPYp/M+kcvIRJ4nG4v3OE/2o1qbMieg+idCs6L0252rJS8sprnFeQ1oPcQCZ0h6wn9UGUxPnh9iopWuoXKYQrrD2w3vgubZIWjoi3i8dXjFM5P5ywXCYdJvAmDfwUABpdAAufMRPiWgXIF7If0TaZZanruV1hNZMDkSX8Qp2JyNVBP38O2gM12JFV0Y+omYTChN5EXKaEPwZBhSz6QkTOGzCOtzoz4UZcifK0WneJDfJoIakpUM/lzh0MXRmdmrUsF0xiXBgwMdtrpADChCOZvZ+0FFDlL4KXyNzCc3sXkBFitTvAG+a2RVox8n+oNSD158MvXViEvsU8C0e56p3dQopsSjugjii0o6FrMguaqQJlP8gNzcu/r44JHNCyC0gt6olsFLSxtk1TAy18+PiBxBAeNhFBMr29AFziF7Ucphan//icdp4uJq/STDS3A4RtQIwV6A5x/OfAxeLK829VfVbhurRrAFkRmtWtjhOOuyoWxSTe4ddlimF/+oL9FSD96DEGwxraGmbO/O4QVlFZQh/EactC4StBY/tFw4b8Yiy3rUsiC1yif7cR2juIizlaQ8rJBjTr9x/7N2OEGfcETY4OimTVu0CikTcYjC37ouG8xsj93lEzS2rVolZngZsZ73f6DHuX3+4NUUP7Kkw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR03MB8847.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(376002)(366004)(39850400004)(396003)(451199015)(31686004)(36756003)(86362001)(7416002)(2906002)(4326008)(38100700002)(8936002)(38350700002)(83380400001)(66556008)(31696002)(66476007)(41300700001)(6916009)(186003)(478600001)(6486002)(316002)(8676002)(2616005)(54906003)(52116002)(44832011)(6512007)(6666004)(5660300002)(6506007)(53546011)(26005)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aGlId3N2cTNoRGtLZnNZTDgwYjE2T0p5NVd2NXlpbjEvR1N0Y05YV1RzQmtk?=
 =?utf-8?B?MGROcWF2YWtTdG5NaXExN3BvUDJjSEw1SXovczcvYmJlZGZYSnY0V28yMU9G?=
 =?utf-8?B?WGRXVkp2aHhPZ09TVzVtZHZYUXdsaGJEOFZjbXZhbG5PZVVLMUhWd1FZVElS?=
 =?utf-8?B?Rk5Va3Fobm9jdko5aDFxMEVCZ3VONy9wclpxMzVrZE0zRm1DUEpDcnN3a2dN?=
 =?utf-8?B?RTB6MktMMEhuSXlXN015akI0Smdxa2U3Wm9hNHM0YktTU0c4cnBCTUpUQ0xa?=
 =?utf-8?B?OXR3S3hVRzJCNmtDcW1DWmdRRWJ0YlliQXZ2dDVicTFMc2NORU9MSE1NVEFD?=
 =?utf-8?B?dnpsUjJ5WTFJMEVnVm5NdGhGcUlZRnd5WUxYRjFZU0Q2NFpqUjJDRkJVK1lG?=
 =?utf-8?B?SXpRTnlNU3F6SVVXWW05djkvaFZCUUY3OUxtOXRXa28yemI0NUNTcVU4bnV4?=
 =?utf-8?B?RlV5RmtDcGx1akpVQkZuNFRwNkpRYVhMNGRxSmNyVkxxekZXS3hScmc1UVVU?=
 =?utf-8?B?bTF0dndMRUdLN3VPZVFVUURrczNvWjE3dnIzZ3pMZkNmeWc3em1HQ2lkU2xw?=
 =?utf-8?B?SExGRTBlOWxYeGs4c1ZpNGJxWkp4VnpXRGYwdFZ0NTNZK2xza2wyd0Z2NEUz?=
 =?utf-8?B?MHhCN0hTY00vRlF0U1lhcTdqN09ZenlBaVpqMGxUQkIxSlZGcXVNdGs1N3hY?=
 =?utf-8?B?TGxKY05Iem9vb3BpZ0kyelRSMkZkWHBTQ0lPTTdmZUZHS1RTbm5jVXE1VXB6?=
 =?utf-8?B?bnFMMVk2Z0NDODJaSDRodlpaOHFjVXcvRXhXYitzRUpNNmU0M1JUYTIwclVh?=
 =?utf-8?B?UmJubWx4cjNLenhUcXRYWCtSTjhDcHY1bi9ZK0xFc3R2UUZkZDVybURQVUQr?=
 =?utf-8?B?TWQrV0xKYmNQaTAwMnFUOWhFUGc0WThJRTdtVlVxRWxDOFZjVjBtM3pwS0tE?=
 =?utf-8?B?UDNibm1qQTlWdEl5ZThTeFhLdTM5YWpISFVUS0F4Qit5YURxUTR1ZzBwYjdM?=
 =?utf-8?B?b2o3VmxnNnI4WTYweWNWdkhnRDNTWkFvZEw2Q0IrZ0MrZ1VkdVV6d1Y4djB0?=
 =?utf-8?B?d01JTzcxdDZ4UlAwMjZQNCtKL0JGQURmWGFWVFVOM0VIUFpMcjh5MzY4MHpr?=
 =?utf-8?B?eE9oVlZWT3gxOWlLaTg1NVY3ZCsrM0Z1c3dVbkh1WHJ1bGpMbThxZ2drRkVY?=
 =?utf-8?B?ZCt5THIrMnBGemtHWkt1My9LclNPd0M0R2lSTFYybDdVWjFMc2dreUVWTmNJ?=
 =?utf-8?B?Y2hXcGxkSVQrbWNyTGJNSHREc3F2UWFOY2VSTDY4cWNQd1k1dGkvYVhQczdp?=
 =?utf-8?B?TWNMVFlGd0M4NFpCc1hjY2tJaUdURGRENjk2VlpSQW53UXJhV2hFT2ZiUnFr?=
 =?utf-8?B?UzQ1MXo0NG1PT3U0WUt1ZGVBNUY0cGl4UHR5RnNmRzZmOEFoajg5VDV0Uk0r?=
 =?utf-8?B?Y3RzT0I2VFRoWTdjaWhxY0l0K1lZbzl1TWRLZU51VktpcTZZYUFZWDdzMmY1?=
 =?utf-8?B?NEFIMmVNaDdXOWdMa2hFSElQQ2hRNnp5R0hmdU5LYzFlSGpPUTZFY256QUlw?=
 =?utf-8?B?SWJoRUtBbUhHS2NoTlRncklNR1VsL1JvV0hhbUZ2cHRSNzhpd3F5aHE4M1N3?=
 =?utf-8?B?M2d3VXJYcXUwaklWYXI4NFIyeHp0YlliQUczNGxoUGRXYlU5NmZBdGhTZmlB?=
 =?utf-8?B?aE8vWVA5WkJjbEF1NTRwWGk3aTJZQTRJRm14MmpVa0Vlb1k3N00vODI5UlEv?=
 =?utf-8?B?NkN0UXFUa28yRGNGL3RDRDV4YzU5bmxBUGhmYXd5YTQ0MjVUL093cEdPNUY3?=
 =?utf-8?B?OXphNWVMSDRDcHVUcWZ4TjJMRitTUWYxTVc4WjhQM1IwN2k4dkljOC9XYWlw?=
 =?utf-8?B?SGxvUnRYL3AwVnZsY1cyc1hycHFXb0k4bk1haWQ0REMwMDZ2aEY0bnA4M0M0?=
 =?utf-8?B?U05iNmxROERlRzBSbVNEY1dqVzQyc3lVMzBSeHYvdFBOVmVhZDk2VjZnWDlF?=
 =?utf-8?B?UktsMmxRQzl2d3R6aVNycG54RXRZSVJzZWZtSFduU0Y4a3FQL2pPVmdBOWgx?=
 =?utf-8?B?YkRsK1lWL2NBMks4Zko0SXFDRHdiWTJMbXFZQXczS3p3MTBVSFVoVTZ3ZWdK?=
 =?utf-8?B?dHFNZ3JVckJCOCtrWUFlMGxZWnZlRk9NclBhcWxtZCtyTDFSSVpyR2djMHFm?=
 =?utf-8?B?Y0E9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2be505e0-8e12-4221-4752-08dac8f50ecd
X-MS-Exchange-CrossTenant-AuthSource: DB9PR03MB8847.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2022 23:40:08.7544
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: coPhCg6aK4N3LIPT2Y4G5EeopP319U3s+m+Yj2ngt+FahiSeNmexMoCl9zLxFQoTjdQwNd6ugWqvoCsoj19Dnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR03MB6330
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/15/22 18:02, Vladimir Oltean wrote:
> On Tue, Nov 15, 2022 at 05:46:54PM -0500, Sean Anderson wrote:
>> On 11/15/22 17:37, Vladimir Oltean wrote:
>> > Was this patch tested and confirmed to do something sane on any platform
>> > at all?
>> 
>> This was mainly intended for Tim to test and see if it fixed his problem.
> 
> And that is stated where? Does Tim know he should test it?
> If you don't have the certainty that it works, do maintainers know not
> to apply it, as many times unfortunately happens when there is no review
> comment and the change looks innocuous?

Sorry, I should have done a better job communicating this (probably by
marking it RFC).

> Even if the change works, why would it be a good idea to overwrite some
> random registers which are supposed to be configured correctly by the
> firmware provided for the board?

They're not random registers. They happen to be exactly the same registers
we use to determine if rate adaptation is enabled.

> If the Linux fixup works for one board
> with one firmware, how do we know it also works for another board with
> the same PHY, but different firmware?

How do we know if a fix on one board for any hardware works on another board?

> Are you willing to take the risk to break someone's system to find out?

I hope it doesn't come to that. I would much rather get some feedback/testing
so I can be more confident in whatever we end up doing (or not).

Well, part of my goal in sending out this patch is to get some feedback
on the right thing to do here. As I see it, there are three ways of
configuring this phy:

- Always rate adapt to whatever the initial phy interface mode is
- Switch phy interfaces depending on the link speed
- Do whatever the firmware sets up

On my system, the last option happens to be the same as the first.
However, on Tim's system it's not. I had originally considered doing
this kind of configuration in my initial rate adaptation patch. However,
I deferred it since nothing needed to be configured for me.

The problem here is that if we advertise like we are in the first mode,
but we are not actually, then we can end up negotiating a link mode
which we don't support.

I think there are a few ways to address this:

- Always enable rate adaptation, since that's what we tell phylink we
  do. This is what this patch does. It's a bit risky (since it departs
  from "do whatever the firmware does"). It's also a bit rigid (what if 
- We can check all the registers to ensure we are actually going to rate
  adapt. If we aren't, we tell phylink we don't support it. This is the
  least risky, but we can end up not bringing up the link even in
  circumstances where we could if we configured things properly. And we
  generally know the right way to configure things.
- Add a configuration option (devicetree? ethtool?) on which option
  above to pick. This is probably what we will want to do in the long
  term, but I feel like we have enough information to determine the
  right thing to do most of the time (without needing manual
  intervention).

> As long as the Aquantia PHY driver doesn't contain all the necessary
> steps for bringing the PHY up from a clean slate, but works on top of
> what the firmware has done, changes like this make me very uncomfortable
> to add any PHY ID to the Aquantia driver. I'd rather leave them with the
> Generic C45 driver, even if that means I'll lose interrupt support, rate
> matching and things like that.

I think these registers should be viewed as configuration for the phy as
a whole, rather than as guts which should be configure by firmware. At
least for the fields we're working with, it seems clear to me what's
going on.

--Sean
