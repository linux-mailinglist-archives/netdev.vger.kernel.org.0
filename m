Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FF025899DE
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 11:24:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237862AbiHDJY2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 05:24:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbiHDJY1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 05:24:27 -0400
Received: from EUR03-VE1-obe.outbound.protection.outlook.com (mail-eopbgr50076.outbound.protection.outlook.com [40.107.5.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 603B467159
        for <netdev@vger.kernel.org>; Thu,  4 Aug 2022 02:24:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZzzZsphF/DmHyUu3jU+QvktUhI0/aB0fyMS12t0CHsBimNyIU0/CEKQKuIYfuex6uUIiKKqkVkNMHFRFnGfaH859msTgR940yJUuO0ZwyzzsV3gZF1P63YhO+rj1doQxe7bmOsolkLtbcXJWS3hRo9P7XJ0Gjf1tdXrgj+WXLjhhZvh+3npHslmAvbasKZdlUS8ngqBGvz8HypDltXFx1O/Snqf9aKSibarDecdoOp/b3qj3vad+IywrN27MktlvEXOWIzPiGgJggOKfKVkaErQRWcngP9yHcTypfJ11cQK3AAWJ7secS91Xx46Yk/aYXvhHZNCgO8PS1wFHMdJwvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uM7Km2CSnITfT3BbNpHA17sqRvlyBzYd0DelvzTF/UY=;
 b=oAMNYFLXcX/o6mKjdRHz5bF7znPVezyM3Z6+rmYlyPyicGyiV9ETD82pn9Ye9LfBmNFHLUHGA/UR4WWjJYaACcieiMY6ZUJgMsS5akygflzv1riFooWEYY1+LhiGuGmLilrcYsYA14YvAdlvrLbf9oYgLue0RInH18Omjc3e+SDDuie29f+psmGr2e4yyZF15KO5MM+AgpbOWYblH06QLjmzqpfUDjqfR5KyShfOxZsTCE4Rum8Trygo4qRIhc3+4FiEhZNT4gsqjY1TCAiDjn23QbjDU/vtXfj9wDFhbQyA5h6htNRDlb5QoPxszFrLvFDaj/3GxtdfaM48auKs9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uM7Km2CSnITfT3BbNpHA17sqRvlyBzYd0DelvzTF/UY=;
 b=AfNjBZ1jQpMelkQ1Y6f0UzlkHmVNoGPYgKDIqrB6q4khRXCwSxZEUHnj1yaQGVvhZ89TOgdFYznRlfREfhmMZdcPK0gyX9BvliOLjqQd1jOJMahvF15KQrmgvrvdP32KHlNyyoMgsNU8RoxXxjTcIIfAwIC4tUO9viLuHSCTM9bucDE38onzAr58XEF2jlU55sqUlg7P5NuHzqIUL+b4Ts1oBQyZInnp3xWi9i2pAtxdKBAcFfrLPRqbJ9CsdayaLSrMEZTxN5VxR4sUlg/3reNzJ0PyvVWjdpcI4AF6+wI3damiXIn389xIRGEwlrT7mYy/7O23s/HcWkItrgi6pA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR0401MB2526.eurprd04.prod.outlook.com
 (2603:10a6:800:58::16) by PA4PR04MB9247.eurprd04.prod.outlook.com
 (2603:10a6:102:2a2::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.15; Thu, 4 Aug
 2022 09:24:23 +0000
Received: from VI1PR0401MB2526.eurprd04.prod.outlook.com
 ([fe80::9cc6:7688:607e:a3b6]) by VI1PR0401MB2526.eurprd04.prod.outlook.com
 ([fe80::9cc6:7688:607e:a3b6%9]) with mapi id 15.20.5504.015; Thu, 4 Aug 2022
 09:24:23 +0000
Message-ID: <d8e45a94-e16a-1152-afad-2ebb15b48d67@suse.com>
Date:   Thu, 4 Aug 2022 11:24:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [RFC] r8152: pass through needs to be singular
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>, Oliver Neukum <oneukum@suse.com>
Cc:     hayeswang@realtek.com, netdev@vger.kernel.org
References: <20220728191851.30402-1-oneukum@suse.com>
 <YuMJhAuZVVZtl9VZ@lunn.ch> <34f7cb15-91e8-e92c-7dcd-f5b28724df92@suse.com>
 <YuknNESeYxCjcPrD@lunn.ch>
From:   Oliver Neukum <oneukum@suse.com>
In-Reply-To: <YuknNESeYxCjcPrD@lunn.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS9PR06CA0165.eurprd06.prod.outlook.com
 (2603:10a6:20b:45c::12) To VI1PR0401MB2526.eurprd04.prod.outlook.com
 (2603:10a6:800:58::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4e265406-f5de-41ab-2ac6-08da75fb1e1b
X-MS-TrafficTypeDiagnostic: PA4PR04MB9247:EE_
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iK5aD9m5V0caVBjAfDbfmkpr6FgOP2WotxLuUQNl2u10u0uRndunzPYBkHbO94QB/OVcxTxsDiupcUqq770gmhIM+aFWSZ68BQei6Xl4S9Idgpfx0lqgyyl2j0OWOB8CqTIJpp1vhdRhJ28+UjqAal5i6XnymL/UYviGEeYvD3spOFeYQ7giXjoX60csWQeMro+fTAsmAxz1InqkhnaFuprQLWUVKWWcKtyDgs0YZ79sFrHYEDTqmo9iXoeh78JZKg9xDelfkT/WdE67bgv/eYm9Sv09VrVQ92StMXccDwudw/QbilHMHgUO4U1kJZMW6kwQPx69+jadVDIRP1B6KsGsvm/Q6bGPj7pE6rkWjEHDxaIdKxhTLEEBqpOuQiMmuDykvoSsVfsZPKJ1gTVIGHAIqiKncI57xrYXJm0aikLLyJsOgD/2UxhIfhliQl0WgH8QPsKNJmsrkZLJXK3SAK1hz0fcq9i0FggP55oaKX5fll3rXxloF6K+Jnvi9GHW/T7bhMVIXErWyFol+AHhW1oz0HT2Xx03FNf/bkXbUwNCPM5qUpmr1f+BiE0u8kzFFQgGP2d0v0BPwfb+Zr5ku0SDlc+IF1IqO1/6xmoBqtsNG87izdqxUgY56+/VSODjP2Tt4/vZNxg7zWJTkE/Zf/fBmx1bLiIUCrpHQYHhDlNtSE4mwJuFkA6RvtWxb0JirRVUusurQC+6u3gZJvfRStSExFJ26LjPsMywAf4wUvZhKd16/xH7i82Aa9Y1QcOy6kUUKtI8AGeAwnqiRAZMIyfpo23om9mvhx0ew/8xsTl0g5DEzu5pPQgLpzd5pZ0SD0pqjic+mtwbJA2iQtDMTA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0401MB2526.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(136003)(366004)(39860400002)(396003)(376002)(86362001)(316002)(110136005)(8936002)(31696002)(66946007)(66556008)(66476007)(4326008)(8676002)(53546011)(6506007)(6512007)(41300700001)(186003)(83380400001)(2616005)(38100700002)(478600001)(6486002)(31686004)(36756003)(2906002)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aStkdUJHRnNZbXBYNE9VSytQTmgrMHEwMjBPRzg1SjllQklVWlJhWkZEeXBQ?=
 =?utf-8?B?N0xHaktlWERaRTFJd0FldXhPTUxUMWhzSTg2U0VCOXlxdVVQUXJlS252VUFj?=
 =?utf-8?B?YXlJWlZuOHMrRjgxNHc0NXk1cWM5U1dETXk3cGxBUEthZnpyMDdicHI1bGt4?=
 =?utf-8?B?KzNNZ0xvUk5TbnFGL213SkhFclZqZUZIQlFZajJUUW83NFNtNUxvdXpVc1ZW?=
 =?utf-8?B?eFcxbUtucTZrUENVdU1lS3Zsc1BjWVl1RmJaUkJDMFY4OVVkWEF4MVhpUndL?=
 =?utf-8?B?cEVMNDRwUGdMYWpTdmN4c0JuR0ZiMHd2bGJ0WlBwZ3pmWWdHR2F2b3FTTVlE?=
 =?utf-8?B?clNPNUprUnI4QTVzSURFZCtCVC9IMEpwTUJWTmsxMnJYcll2c3IzUlFSUHBt?=
 =?utf-8?B?dkJyVk1ld3A3QmZlY3UxNllRTTRhaUV3Mk1PME1hMGNnQzdpeUxuK3QrMTBZ?=
 =?utf-8?B?bUIxT1BvOVdLQ01ZSGtvaDFmMXZacWJ4MVhiQ2o5anFnZnhaejZBK0RWWFdC?=
 =?utf-8?B?UDhNWVdnbUhWMC9ST1RZaUhhVzdKUTNzVGhraUtxYmNmdG0zS3JnWnl1a0dU?=
 =?utf-8?B?Y2EzR0pnMVN4eVp3bWNIa3daMlZzeFNKdUJ2TnJtVGhJbXhzMFpJZVFCSDg3?=
 =?utf-8?B?UTltcU8vWVJ6dGxYMXNhdzVyRjJlTXFGWkJFWW45QStPVEw2cytFOWQ0amVx?=
 =?utf-8?B?bHd4UjNvLzBjOVJEUThxazM5dTJaYVpRTUliTXV0ckRSbzVuUVpvREF2S0kr?=
 =?utf-8?B?VWxlcno2K3VVMXE5amtPWkhmOEJmNGtVSkxkL0FaQ1BPY3RUNUFOSjkrd0lk?=
 =?utf-8?B?TFdpbXIwNHlNZXMxWHpLWDh6SStleFhUMWZDVUVMQm9aNXJ6NDdFUkthQlFh?=
 =?utf-8?B?L3VhL3VjbXduTFZ0R25samZQTkRmSkw3VlAwL1VyN3phVTRxM2ljVU9iWEpS?=
 =?utf-8?B?M3dERHk1VE54VHNMTEpLNHF2K1JSejJzV0RLcW9mbVJFbnY5TjFVcUZUQ25J?=
 =?utf-8?B?QmFhV0orRFc0YmRvZWxrMSt3OWxWUk5kajBCOTBFa0JDc1hUb0ZySGFIcHdx?=
 =?utf-8?B?REdidkl6V0hlOFBZV3Y2ZmluUWxDS0dWNE5pUkhVNTVOeGhKVWVMUExSMk03?=
 =?utf-8?B?NGljdTdkbFFFSmdHWWxlT2dCSTd1aFRaRll2Yi9GWWtKNkE0dkxGL2F0SzJZ?=
 =?utf-8?B?UUxaZkNaZCthTEkzMjBaenNHMzZ5ZUt2dzYxNHQvMUJBdkZQV2ZpcHRJQnRw?=
 =?utf-8?B?MlFUWjl0YmZwa0Q1RDRUUzhIV1dxZlFDN0krcEwzdzdsVzRabUhid3JqWjJS?=
 =?utf-8?B?MWpsQzF0azdYSHVOdUpFZjV6U0JoWDFtSGl0RlRidFE1eGpHZ3lXK3dNUjhi?=
 =?utf-8?B?MEF0SVZwb1E3ZEVDY1VZZThTNHUwQWdXWHRQdERqVlp1dTRCeS9YdkJXRkRP?=
 =?utf-8?B?djg2UDJNR2J5YTY3SXBabzJLbXJpS0tKb25ESGlET1dJMVJ6VVJvM3JUNHlt?=
 =?utf-8?B?U3Z1L1g2N0FDMFgraXdGT2MrY3VMSEFnR3p1cGhNVGhkNjZKMXlJdytSU1Av?=
 =?utf-8?B?M1JqcGlFclYwODlkZnE3L0phM2twdmJva2tHTU9HV2FpT0RGOUFQQTV1MU55?=
 =?utf-8?B?bHAwenpsU2NuRFE3QWZscmZlVUFpNEZMZWRaOTk5VCt3TU9wQWxaNWJzNzRa?=
 =?utf-8?B?YVdkSUV6YVNEZ2h5cFNMOHQ1d0xCRDhHMVNxdlY4cmtYcWdXU2lsNHV0L2Y3?=
 =?utf-8?B?Z2c3cXl3UjlXRUdVZDAxUXpaMFFMc3NIbGVlcmJNbHBBc1JXdHNhK1h3WU5r?=
 =?utf-8?B?R1QwazdTMmFnQUNsLzNWYVgrOUxSa3FqYlhHbHNtbmJCTTFxb2JYblMvY0U2?=
 =?utf-8?B?eE5haXRaZTl3T0s4eHNPYXFvWXJjQjlpVW9UbXdzU1ZySXNRRDJrOFRuRWEx?=
 =?utf-8?B?RnBTZW9HaXQ1TUpWUjhiMWVlcnpsWDM0dHRrdHZzWDZ6RndONms5ZFZUMkxC?=
 =?utf-8?B?QnB6WG9vMjgvRFgreXhsN1pyekdXbmI3M1hKdnRGT3V5SzJia0IzRUQ2MHBl?=
 =?utf-8?B?NVViSzIyVzEyUmVxZHpjMFJFT3V5eC8yNlhnd2llTmdRRjFsY2VTQktRUkll?=
 =?utf-8?B?dU9UVXozZXUvWnp3QVJEMzlJMC9aSlFoS2lVTmNDcTVka1J5RzRUaHh6Q1c0?=
 =?utf-8?Q?v5uVjy3cPcG7dxRQGXwAI1xW8jE52zKJoix4EWU41Z1V?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e265406-f5de-41ab-2ac6-08da75fb1e1b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0401MB2526.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2022 09:24:23.0246
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aO7kxk1NMGRYYcJvOqN0uITu1a9i7rz5Ydy6I5bl5JkKTHUQ7ckLYH9nVL2uYtszkSfvhnTv5hkWL0AufBL8oA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB9247
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 02.08.22 15:31, Andrew Lunn wrote:
>> True. Nevertheless, do we really want to say that we dislike a design
>> so much that we are not fixing bugs?
> 
> I'm not sure we can fix it. Part of that long thread about why this
> whole concept is broken is that we have no idea which interface is the
> one which should give the MAC address to. If we change it to only give
> out the MAC address once, all we really do is change it from one bug
> to another bug.

I am afraid I have to beg to differ.

We have a couple of related issues here. Obviously whoever designed
MAC pass-through did not consider the case of somebody using two
docking stations at the same time. While pass-through is used I agree
that this is unsolvable.

Yet connecting two (or even more) docking stations to a host is
within spec. They are USB devices (partially) and if they contain
a NIC it is clear what we have to do.
We would operate them with
1. a MAC contained on the device
2. if the device contains no MAC, we'd use a random MAC, but a
different one per device. User space can assign any MAC it wants to,
but we are talking defaults here.

Now, the question arises whether we let another feature interfere
with that. And then I must say, if we do that and we have decided
to take a feature that does so, we'll have to do it in a way that
stays within spec. Yet I am sorry, you cannot give out the same
MAC to two devices at the same time, if you want to do so.

So while the bug in the driver derives from a stupid design,
it nevertheless is a bug and my patch fixes it. Optimally?
No, of course not, the design is broken.

>>> What exactly is your problem which you are trying to fix? 
>> Adressing the comment Hayes made when reset_resume() was fixed
>> from a deadlock, that it still assigns wrong MACs. I feel that
>> before I fix keeping the correct address I better make sure the
>> MAC is sane in the first place.
> 
> I would say that reset_resume() should restore whatever the MAC
> address was before the suspend.

The problem is that these devices reread the passed through MAC
at post_reset(). Do you want reset_resume() to act differently?

> It does not matter if the MAC address
> is not unique. As far as i know, the kernel never prevents the user
> assigning the same MAC address on multiple interfaces via ip link set.
> So it could actually be a user choice.

Iff the user does so. Until then it is a kernel bug.

	Regards
		Oliver

