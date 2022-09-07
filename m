Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7F7B5B0FE9
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 00:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbiIGWjr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 18:39:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229594AbiIGWjq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 18:39:46 -0400
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2062.outbound.protection.outlook.com [40.107.105.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E84581FCE0;
        Wed,  7 Sep 2022 15:39:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l7uKmQMYdob01NM2MZQCrdw65Juvivmp3480paaU2VGWtrjy8cE6NryQMA7a7rOlGHStnd3fcrAa1GIvyr2ICesdQWqowYC0+qfjBT9fkG/gEz6TteCu0LSJvpcIOaaJ3vbrasTIjRBkyWk0ZKAVbB/Gz5/NjFUFP1OmigGo8EIMvHB829Ijzq3BxS2rsBvXajv689mk2NcShH+uao/3Am3eIvPbcx6rlBE44tF1iWbKgC2GjM568N4ObHJnqggcHpUrpIxtlz1RnesedhvWHa8Y23kn5EZ6WwlkR50BC6pAxcbsUbqDJiWQiR7qZ/g8Dvj4uzLPRJDYnn4C4YIb+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X8R0jmL/8gNgQAbUooXcN92ZMf5ODC/WoohByQ8Gej8=;
 b=TJ4AIAXjGNqEly5qKGrDUYZQjWt5MKIT+XaHTp0R+vXhnc2XPtCuCIRzNi1wftktGtzQwmeMklHlf7qFIDjT0+1TgOJfiLzoDttvTcbcKyqtghq3o51rn/S+nWOgw6yt4JPfc04m6iqbvGy+K87T4JCIFmAaNiWwupYisngjNJv/ZLnxLiouh67wiJq+4M5b4naCCEybyR2CIRz0KAOW1K14UfQXkjkIzpY+A/MreQm8fFDmtMfB7C4YB6H1Lh7CXi3RvhYc0JmiGIc8ZVZaXaO5PLyUth080RFGDYc3/Q5vodVRnQ789CabrT9XszGdcZF8w3t+0b7DkflGTXewug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X8R0jmL/8gNgQAbUooXcN92ZMf5ODC/WoohByQ8Gej8=;
 b=bvTgt6yX84PZTP3CIYd+1vznBOYvtikjNYQDNvlXayHGjqxFkA8clhi8lk6n6CMzue51aUG4yjbQjoNazVoHkK+++QqlVG/B+gahMAX+U42IuzzBykvTRC+GSNcpKkOSS7Tyzdc7Jky9V3CioNfMQCs0/Enf10LLhspglzmkYyhh1WmcG2wpaLGz/C6JhABvfU4ZG8r9jY2cbUnjmntqziAACmSM1XRpPM8cxlXC44FumxDjbnBsGc22lL1I0sFvnxmZ9QFQ2hy5SL/0egZ++0LCLoHmOcADRwH7e9HPG+bAnyou1BQNc7K1a1vxua6SMhZc59w4bGVOUCBxKtnfKw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by VI1PR03MB6368.eurprd03.prod.outlook.com (2603:10a6:800:197::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Wed, 7 Sep
 2022 22:39:38 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5588.018; Wed, 7 Sep 2022
 22:39:38 +0000
Message-ID: <0186263e-bcb6-d144-5e6d-23400179ca38@seco.com>
Date:   Wed, 7 Sep 2022 18:39:34 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
From:   Sean Anderson <sean.anderson@seco.com>
Subject: Re: [PATCH net-next v5 1/8] net: phylink: Document MAC_(A)SYM_PAUSE
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
References: <20220906161852.1538270-1-sean.anderson@seco.com>
 <20220906161852.1538270-2-sean.anderson@seco.com>
 <YxhmnVIB+qT0W/5v@shell.armlinux.org.uk>
 <8cf0a225-31b7-748d-bb9d-ac4bbddd4b6a@seco.com>
 <YxjdQzEFlJPQMkEl@shell.armlinux.org.uk>
 <745dfe6a-8731-02cc-512a-b46ece9169ed@seco.com>
 <YxkGr611ZA1EF58N@shell.armlinux.org.uk>
Content-Language: en-US
In-Reply-To: <YxkGr611ZA1EF58N@shell.armlinux.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR1501CA0004.namprd15.prod.outlook.com
 (2603:10b6:207:17::17) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0a425745-2df0-45bd-72da-08da9121d8e1
X-MS-TrafficTypeDiagnostic: VI1PR03MB6368:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 14TnM9Vj7aCRNGkcJaBpvSjjyWoCY8hN7LEfw1wWYQUnekQeZJT96Moq0iOMQAJClgcAFzziWEqR7fxL+RCVP1wOU/Pp5lc426nLZp6cnJy5wvkSBkZkIeje222kunr8tBbK2pWQqujN2MPbmgwGtPg25qyJcoKYckOwvhHfNQNyHaQT+z7oXl3/WvyittsahZkyGA3PCDw6qtzST0rK52BbOk5R0bA3a5YEfqTIgROo3bbONgq/emqyKYFMRby1gVEmZlWs6h032Wp7GyTViRQc6U/5Tz5vM4zpaPXl/2hk/fFLkrgGypSkQHBJI7n4CjnptyNqGrMhBEwfmS+UxayF9vnxEqOIR+nAH8y9nlsW76Y5jGIX7cAKve/+JccHNzuF6SCpWhTKZv7fOtsphhTrnjBadLDGYbgpvy/BIZhYteE5IqaTsUsbK7HyClW5Y/d8I2auvfZnTthRwTr2eMxbcxCPPEb+qw29GVjZAxdSgJstbOY/x4NYSi3Lx+om0PjB6O6bkN2HxQ7JZN9cZ3k1JHZzZUqLYmzbfJZcMF+cdY5pFvXb2R4SGHBxWQnsFI2DUPO6LDvx7s3YuzJ0cW8trQNA2OZK+Uib9m2ukVYqbd4LF+F1QWsQ7nop2QwMxHX/dHZUQsm5+lZALWXMyxIu/40vfoXt2/wb5NzSYtBu+zle1xjO7g4gjcAGlwnwbXwzSonWjCbETUhHAWNzXhZOeAD7iwiZLZ5eciUJwhgMkdzAo8n8zsed2P5NWJ3TZdhua2GHvhDMLFSfgZPq5/bmp2PU6/b1sLCcRGKKX11nHY1ZXvTe560cvgPtlAORLIIHiclQnAarTaYn7xpwEu8VqU96BMDff3rAx2B8GgI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(136003)(376002)(39850400004)(396003)(346002)(2616005)(83380400001)(31686004)(86362001)(36756003)(316002)(6916009)(186003)(54906003)(7416002)(6666004)(966005)(8936002)(6486002)(5660300002)(478600001)(66556008)(30864003)(66476007)(66946007)(44832011)(41300700001)(8676002)(4326008)(38100700002)(26005)(38350700002)(6512007)(31696002)(2906002)(6506007)(53546011)(52116002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SVRPbE1kLytMYmlPR1dTVVE0UU9IbGhOeHoycW1ya3pXQUMvdmVZcnhFRmFH?=
 =?utf-8?B?S1d0VlpRdG0zbzNVMmp4aEFwMWNKRVVnbnFvSXcwMEZ4akVSTEJ0TlYrN0xN?=
 =?utf-8?B?MXp5dEhXOCt1eGV1bzlGZGpkbTVybHBQS2NXa1AxblM5U3VHaGVNeU1GekNG?=
 =?utf-8?B?aXdPVFYwZi9uQU83R3dFV2plZzZzS0x6S3JtM3JycUFDbVMyK1MwbCtQeDYv?=
 =?utf-8?B?Z1JNdHVsUHBHeDFkbjgvZTBwTFg1NFFYKzh5ZmFRbm1NRUNkOTFTcnJkc0ZH?=
 =?utf-8?B?dWRDTHBoNk10ZWxvNFJ5amY3QkpSd3BBckZQVUNtb29TOXpaWStDc3pwSlNy?=
 =?utf-8?B?OEpJZnN5OGtpNTIxNnR5T0lBYU5KdnFvcDBST3o1d3dOd0UzekZVK3cwTVNB?=
 =?utf-8?B?SnNpdWFKTExJUWRKdUVqWmVuNHRyVkNHaytnTHBha2xYUmJYTlRjZjlHMUk2?=
 =?utf-8?B?VG52aE1wbHZ4dUhOYUxQeDliNmkrTFljNHhlYXczZUxDbGZHNytXeXNGbnhG?=
 =?utf-8?B?S282WlRKU2NYNjRhMVRkRDgxeEhleHAybHlCeXFiQktjUVdnQmpnN3pCMTFj?=
 =?utf-8?B?Qzh1aURmY2wvNkJQa3hvWTJFOSt2WkIxSnlLZTlSU2JLZVlOcFVsSThoMkNY?=
 =?utf-8?B?V0xEK2JJVmNJbjFTQmFyWlRlamJMOTMrbVFta0h0c1oxNFVhWlVKZ0ZPUjBy?=
 =?utf-8?B?Y3NNdGVacVBoaHJKQWNHUkZ1TnVMWjhnYzFnSnphMFFqcEUxL1Y2c0dJUFAx?=
 =?utf-8?B?ZWgySFFYY280WjJhWUFJL0c4b3FZcDAyTUNjRExXQnQxYnh3cUhqcjgxdFJu?=
 =?utf-8?B?dlhRRXVWMWJVbXhuTzZUai9hODVKNW5YM1pseExwUGxWaTBYR0lLbVJqWmRi?=
 =?utf-8?B?Zit3N1dmdjcwUHNwckdYTmVYSW42aUxzelA1dWVGd2d3QVNtSWdwNEhEWk9k?=
 =?utf-8?B?U1Q5SmdORGlOZDMrRHBzQVVaWDJmakVmbHZ0TTB2Um5vS29ZOEwzUWNJcHdI?=
 =?utf-8?B?VndycDFoVkVXaXZUNTJ5dHUvc3cyeUY2NUEwQURMR1Y4MVhIZi9qNklGdkd1?=
 =?utf-8?B?WFRucFJKcjZmc2xXcWk2OUpjcFFKaTRhb01EcHZDOXlIRG9tL2p3SEo4VFhV?=
 =?utf-8?B?QllIcG50MC9nVnZla2ZTQUcyUGdDR2lUaWsvbkY4dkM0YnNaYk5TQ3ZYSmxU?=
 =?utf-8?B?QUVPaGNQUGRCMTRPdmd0ZXhkUzUzL3ovTkVFNCtTNzVTNUNKY2FpdFNycEl0?=
 =?utf-8?B?MXlaV253UGc3a1VtblM5ZHpheVN5M3JEVFdJTldHNTQva1NhTzJRakliUDlO?=
 =?utf-8?B?Y3E3bVFLQyticWs1YSt2RDhiM0twR0ExWmdQa3FWSEdIdU83RFNic0hZU1J5?=
 =?utf-8?B?clNYeDRSc1ZjWnp6NGUrajU2V1ArZE9xcFlpWjFQWjBOM3FxcUYwUXRRQjlR?=
 =?utf-8?B?ZnNXd0lFT1pNeXROa3hyNi9iNFFBMDYzY1hCeHJUdDFFS3N2cVlGVFkySmx4?=
 =?utf-8?B?WFF3UCtpVGZQMm5sRWpIdHdKOWczV1VWeEYxaVRtM1gwcHYwMUdRREZPZFJw?=
 =?utf-8?B?Wm9NaFhnYzNFMk1zaVpPTGtYQ0ZHb0NybncrMEFVSU9pTnlTVXJEWHMwSWk4?=
 =?utf-8?B?WGUyZ2xRNmFBYWkxUm10Ykt0cURnRTIydGpDTnpPRmx5MEZMbWNlN3puTjZH?=
 =?utf-8?B?cExiYUpyQjBIT0l0OWtxM0NRUVBJNHZ3MzBCQWpRemNQV0dQaGovbkQzVCtK?=
 =?utf-8?B?ampFZWNUMWhWYTZLMWJDaHJmdk40VlFzb2ZBOE1KT0ZSMVZjZDBKMC9rYy9V?=
 =?utf-8?B?Q1QyOFJiQWFBdEdWeTBvVVBFaE9wWXArTlEwZWl3dkdmdjF4NnVDY3cxUXdr?=
 =?utf-8?B?dHI1Y3BOODhLTy9XTEtnRUt0dkVEYXpmS016ZGR2K0diZVhsUUNldUhydVZ0?=
 =?utf-8?B?VWtkTHJjS2RhZlJwTnM2U2pMYlFyMm95SUhYTWVhNW85aVJjK2lPQnZtRXBv?=
 =?utf-8?B?WWkvS0pWSERsNHczY0c3aGlZSTBvT2hVV1dtaTlYaEJKN3VtU05NeGM0dEh6?=
 =?utf-8?B?NEk4ZGRLUmV5S2JQUmNIMnJjL2pGTERjMFp1R21POXI5ME1KWWZxazA5Q2pp?=
 =?utf-8?Q?ZT8iqydHrf+29PtOr3nx9WHma?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a425745-2df0-45bd-72da-08da9121d8e1
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2022 22:39:38.6354
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bXhB8MATuUkId5Kp1EmJ823EKK7S1B1JJ9R2uvtRW8hKbTjYFTEheoLKPHdJc/ACs3W060dQebPl40Wa+0s7Kw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR03MB6368
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/7/22 17:01, Russell King (Oracle) wrote:
> On Wed, Sep 07, 2022 at 04:11:14PM -0400, Sean Anderson wrote:
>> On 9/7/22 2:04 PM, Russell King (Oracle) wrote:
>>> MAC_SYM_PAUSE and MAC_ASYM_PAUSE are used when configuring our autonegotiation
>>> advertisement. They correspond to the PAUSE and ASM_DIR bits defined by 802.3,
>>> respectively.
>>
>> My intention here is to clarify the relationship between the terminology. Your
>> proposed modification has "our autonegotiation advertisement" apply to PAUSE/ASM_DIR
>> instead of MAC_*_PAUSE, which is also confusing, since those bits can apply to either
>> party's advertisement.
> 
> Please amend to make it clearer.

Does what I proposed work?

>>>>>> +	 * MAC_SYM_PAUSE MAC_ASYM_PAUSE Valid pause modes
>>>>>> +	 * ============= ============== ==============================
>>>>>> +	 *             0              0 MLO_PAUSE_NONE
>>>>>> +	 *             0              1 MLO_PAUSE_NONE, MLO_PAUSE_TX
>>>>>> +	 *             1              0 MLO_PAUSE_NONE, MLO_PAUSE_TXRX
>>>>>> +	 *             1              1 MLO_PAUSE_NONE, MLO_PAUSE_TXRX,
>>>>>> +	 *                              MLO_PAUSE_RX
>>>>>
>>>>> Any of none, tx, txrx and rx can occur with both bits set in the last
>>>>> case, the tx-only case will be due to user configuration.
>>>>
>>>> What flow did you have in mind? According to the comment on linkmode_set_pause,
>>>> if ethtool requests tx-only, we will use MAC_ASYM_PAUSE for the advertising,
>>>> which is the second row above.
>>>
>>> I think you're missing some points on the ethtool interface. Let me
>>> go through it:
>>>
>>> First, let's go through the man page:
>>>
>>>              autoneg on|off
>>>                     Specifies whether pause autonegotiation should be enabled.
>>>
>>>              rx on|off
>>>                     Specifies whether RX pause should be enabled.
>>>
>>>              tx on|off
>>>                     Specifies whether TX pause should be enabled.
>>>
>>> This is way too vague and doesn't convey very much inforamtion about
>>> the function of these options. One can rightfully claim that it is
>>> actually wrong and misleading, especially the first option, because
>>> there is no way to control whether "pause autonegotiation should be
>>> enabled." Either autonegotiation with the link partner is enabled
>>> or it isn't.
>>> Thankfully, the documentation of the field in struct
>>> ethtool_pauseparam documents this more fully:
>>>
>>>    * If @autoneg is non-zero, the MAC is configured to send and/or
>>>    * receive pause frames according to the result of autonegotiation.
>>>    * Otherwise, it is configured directly based on the @rx_pause and
>>>    * @tx_pause flags.
>>>
>>> So, autoneg controls whether the result of autonegotiation is used, or
>>> we override the result of autonegotiation with the specified transmit
>>> and receive settings.
>>>
>>> The next issue with the man page is that it doesn't specify that tx
>>> and rx control the advertisement of pause modes - and it doesn't
>>> specify how. Again, the documentation of struct ethtool_pauseparam
>>> helps somewhat:
>>>
>>>    * If the link is autonegotiated, drivers should use
>>>    * mii_advertise_flowctrl() or similar code to set the advertised
>>>    * pause frame capabilities based on the @rx_pause and @tx_pause flags,
>>>    * even if @autoneg is zero.  They should also allow the advertised
>>>    * pause frame capabilities to be controlled directly through the
>>>    * advertising field of &struct ethtool_cmd.
>>>
>>> So:
>>>
>>> 1. in the case of autoneg=0:
>>> 1a. local end's enablement of tx and rx pause frames depends solely
>>>       on the capabilities of the network adapter and the tx and rx
>>>       parameters, ignoring the results of any autonegotiation
>>>       resolution.
>>> 1b. the behaviour in mii_advertise_flowctrl() or similar code shall
>>>       be used to derive the advertisement, which results in the
>>>       tx=1 rx=0 case advertising ASYM_DIR only which does not tie up
>>>       with what we actually end up configuring on the local end.
>>>
>>> 2. in the case of autoneg=1, the tx and rx parameters are used to
>>>      derive the advertisement as in 1b and the results of
>>>      autonegotiation resolution are used.
>>>
>>> The full behaviour of mii_advertise_flowctrl() is:
>>>
>>> ethtool  local advertisement	possible autoneg resolutions
>>>    rx  tx  Pause AsymDir
>>>    0   0   0     0		!tx !rx
>>>    1   0   1     1		!tx !rx, !tx rx, tx rx
>>>    0   1   0     1		!tx !rx, tx !rx
>>>    1   1   1     0		!tx !rx, tx rx
>>>
>>> but as I say, the "possible autoneg resolutions" and table 28B-3
>>> is utterly meaningless when ethtool specifies "autoneg off" for
>>> the pause settings.
>>>
>>> So, "ethtool -A autoneg off tx on rx off" will result in an
>>> advertisement with PAUSE=0 ASYM_DIR=1 and we force the local side
>>> to enable transmit pause and disabel receive pause no matter what
>>> the remote side's advertisement is.
>>>
>>> I hope this clears the point up.
>>
>> My intent here is to provide some help for driver authors when they
>> need to fill in their mac capabilities. The driver author probably
>> knows things like "My device supports MLO_PAUSE_TX and MLO_PAUSE_TXRX
>> but not MLO_PAUSE_RX." They have to translate that into the correct
>> values for MAC_*_PAUSE. When the user starts messing with this process,
>> it's no longer the driver author's problem whether the result is sane
>> or not.
> 
> Given that going from tx/rx back to pause/asym_dir bits is not trivial
> (because the translation depends on the remote advertisement) it is
> highly unlikely that the description would frame the support in terms
> of whether the hardware can transmit and/or receive pause frames.

I think it is? Usually if both symmetric and asymmetric pause is
possible then there are two PAUSE_TX and PAUSE_RX fields in a register
somewhere. Similarly, if there is only symmetric pause, then there is a
PAUSE_EN bit in a register. And if only one of TX and RX is possible,
then there will only be one field. There are a few drivers where you
program the advertisement and let the hardware do the rest, but even
then there's usually a manual mode (which should be enabled by the
poorly-documented permit_pause_to_mac parameter).

However, it is not obvious (at least it wasn't to me)

- That MAC_SYM_PAUSE/MAC_ASYM_PAUSE control to the PAUSE and ASYM_DIR
   bits (when MLO_PAUSE_AN is set).
- How MAC_*_PAUSE related to the resolved pause mode in mac_link_up.

> Note from the table above, it is not possible to advertise that you
> do not support transmission of pause frames.

Just don't set either of MAC_*_PAUSE :)

Of course, hardware manufacturers are hopefully aware that only half of
the possible combinations are supported and don't produce hardware with
capabilities that can't be advertised.

>>
>> How about
>>
>>> The following table lists the values of tx_pause and rx_pause which
>>> might be requested in mac_link_up depending on the results of> autonegotiation (when MLO_PAUSE_AN is set):>
>>> MAC_SYM_PAUSE MAC_ASYM_PAUSE tx_pause rx_pause
>>> ============= ============== ======== ========
>>>              0              0        0        0
>>>              0              1        0        0>                                     1        0
>>>              1              0        0        0
>>>                                      1        1>             1              1        0        0
>>>                                      0        1
>>>                                      1        1
>>>
>>> When MLO_PAUSE_AN is not set, any combination of tx_pause and> rx_pause may be requested. This depends on user configuration,
>>> without regard to the values of MAC_SYM_PAUSE and MAC_ASYM_PAUSE.
> 
> The above is how I'm viewing this, and because of the broken formatting,
> it's impossible to make sense of, sorry.

Sorry, my mail client mangled it. Second attempt:

> MAC_SYM_PAUSE MAC_ASYM_PAUSE tx_pause rx_pause
> ============= ============== ======== ========
>             0              0        0        0
>             0              1        0        0
>                                     1        0
>             1              0        0        0
>                                     1        1
>             1              1        0        0
>                                     0        1
>                                     1        1

>> Perhaps there should be a note either here or in mac_link_up documenting
>> what to do if e.g. the user requests just MLO_PAUSE_TX but only symmetric
>> pause is supported. In mvneta_mac_link_up we enable symmetric pause if
>> either tx_pause or rx_pause is requested.
> 
> If the MAC only supports symmetric pause, the logic in phylink ensures
> that the MAC will always be called with tx_pause == rx_pause:
> - it will fail attempts by ethtool to set autoneg off with different rx
>    and tx settings.
> - we will only advertise support for symmetric pause, for which there
>    are only two autonegotiation outcomes, both of which satisfy the
>    requirement that tx_pause == rx_pause.
> 
> So, if a MAC only supports symmetric pause, it can key off either of
> these two flags as it is guaranteed that they will be identical in
> for a MAC that only supports symmetric pause.

OK, so taking that into account then perhaps the post-table explanation
should be reworded to

> When MLO_PAUSE_AN is not set and MAC_ASYM_PAUSE is set, any
> combination of tx_pause and rx_pause may be requested. This depends on
> user configuration, without regard to the value of MAC_SYM_PAUSE. When
> When MLO_PAUSE_AN is not set and MAC_ASYM_PAUSE is also unset, then 
> tx_pause and rx_pause will still depend on user configuration, but
> will always equal each other.

Or maybe the above table should be extended to be

> MLO_PAUSE_AN MAC_SYM_PAUSE MAC_ASYM_PAUSE  tx_pause rx_pause
> ============ ============= ==============  ======== ========
>            0             0              0         0        0
>            0             0              1         0        0
>                                                   1        0
>            0             1              0         0        0
>                                                   1        1
>            0             1              1         0        0
>                                                   0        1
>                                                   1        1
>            1             0              0         0        0
>            1             X              1         X        X
>            1             1              0         0        0
>                                                   1        1

With a note like

> When MLO_PAUSE_AN is not set, the values of tx_pause and rx_pause
> depend on user configuration. When MAC_ASYM_PAUSE is not set, tx_pause
> and rx_pause will be restricted to be either both enabled or both
> disabled. Otherwise, no restrictions are placed on their values,
> allowing configurations which would not be attainable as a result of
> autonegotiation.

IMO we should really switch to something like MAX_RX_PAUSE,
MAC_TX_PAUSE, MAC_RXTX_PAUSE and let phylink handle all the details of
turning that into sane advertisement. This would also let us return
-EINVAL in phylink_ethtool_set_pauseparam when the user requests e.g.
TX-only pause when the MAC only supports RX and RXTX.

> Adding in the issue of rate adaption (sorry, I use "adaption" not
> "adaptation" which I find rather irksome as in my - and apparently
> a subsection of English speakers, the two have slightly different
> meanings)

802.3 calls it "rate adaptation" in clause 49 (10GBASE-R) and "rate
matching" in clause 61 (10PASS-TL and 2BASE-TS). If you are opposed to
the former, then I think the latter could also work. It's also shorter,
which is definitely a plus.

Interestingly, wiktionary (with which I attempted to determine what that
slightly-different meaning was) labels "adaption" as "rare" :)

> brings with it the problem that when using pause frames,
> we need RX pause enabled, but on a MAC which only supports symmetric
> pause, we can't enable RX pause without also transmitting pause frames.
> So I would say such a setup was fundamentally mis-designed, and there's
> little we can do to correct such a stupidity. Should we detect such
> stupidities? Maybe, but what then? Refuse to function?

Previous discussion [1]. Right now we refuse to turn on rate adaptation
if the MAC only supports symmetric pause. The maximally-robust solution
would be to first try and autonegotiate with rate adaptation enabled and
using symmetric pause, and then renegotiate without either enabled. I
think that's significantly more complex, so I propose deferring such an
implementation to whoever first complains about their link not being
rate-adapted.

--Sean

[1] https://lore.kernel.org/netdev/4172fd87-8e51-e67d-bf86-fdc6829fa9b3@seco.com/
