Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9223A598E3A
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 22:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242809AbiHRUkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 16:40:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346239AbiHRUkq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 16:40:46 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2083.outbound.protection.outlook.com [40.107.21.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4FF9CB5D5;
        Thu, 18 Aug 2022 13:40:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VPC30nE7jWLHxP0wpTKrPp2W/z4qbSK9QsLvDae9AlKCptVSB655jN8vwMPr9RPnpR26kOUTGGV2TYjsDF+XJMiCyYj0HcQq9YMPd/Ov/CHSkZnwbOdvid6dCG1b1OlZV1PfXXuef5MJbhCx5CjeBSFVgmeyURm5w823Ts2Lw1u+FaocHFKTKisr15APGbK01XNjn06hIhVHZ+xLaJl56VUlyxTw1iNy5gIqp7Q230c1OeQo7fiUEkFHQ6hnu2a6zij3GZGKnlNIvqZUaRH89yEvJcul/EMWOy+jT/V5nSALpQogox+lNovplV12TyeNrEAkkYI2yGQGhWoVGYdDOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mC74gXdkhaqKAA6B38omz6GIwNzeQkUuxLGfZjZCgrs=;
 b=eMQcPccbzH+T86f2KVEFDbYPgKCEeizvpLIA6fPP9YDG8v277QRu97muaPxeCoO9t9lhNETZbTm1vQu2AfG9QQ5dUpHd5+1/MFnAKdVFWK7CSHswNXxoz1W+qSmAE7iL1Qf8JcyvI8Bs9I+Jcw8Xh9gLl7E+4cA80sh3hrBaqtmvY9JdmbgwU+DEakrxE//NVjfFuToWxaifweOHUxZlZ2hY2c1Hm7h5+Txnukd2HSmANx8Y7hY/r/TLZ/uIBDhomMdC8fBHC5JhmY6LSI5kx9jg44ptlOFfPgUrMTtmcNsZ0iUgTWJU2QNfahgkE+CitdHJo8/v4AAK28g4PGAowg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mC74gXdkhaqKAA6B38omz6GIwNzeQkUuxLGfZjZCgrs=;
 b=atE3WPH9Y1jVkKScy8DkGde1QD9Z3+Fh4xxO2NW/7v83Bs7nKnZmEZtbnE5WJMaIA9mSP4u1ll75rA7jS3rOfrXTabOgiuxJDL+AUihlX8GmkhhUIdgIyEiip5Dz2S+fl9g9PyIeQ+1yhGRGEdjRw4bjnb5PvI0vMbONSCrb9SFuNKcb4teJQX7LzahVY6zbBJP16povmmx1YhZqMGSIIAoiZUn1WJlEtR71bMCL2lV3hFNB89MzY0koKssWiPjB5+nuyFC+S4vjT6qDks9TwkqMdDTYd/++hoAJZTT+WrRnsfLiTIY0Pw6uIYc435zf7AEsB1uwPB3PPIr7JhhPkQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AS4PR03MB8436.eurprd03.prod.outlook.com (2603:10a6:20b:51b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Thu, 18 Aug
 2022 20:40:41 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5504.019; Thu, 18 Aug 2022
 20:40:41 +0000
From:   Sean Anderson <sean.anderson@seco.com>
Subject: Re: [PATCH v3 02/11] net: phy: Add 1000BASE-KX interface mode
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
References: <20220725153730.2604096-1-sean.anderson@seco.com>
 <20220725153730.2604096-3-sean.anderson@seco.com>
 <20220818165303.zzp57kd7wfjyytza@skbuf>
 <8a7ee3c9-3bf9-cfd1-67ab-bb11c1a0c82a@seco.com>
 <35779736-8787-f4cb-4160-4ff35946666d@seco.com>
 <20220818171255.ntfdxasulitkzinx@skbuf>
 <cfe3d910-adee-a3bf-96e2-ce1c10109e58@seco.com>
 <20220818195151.3aeaib54xjdhk3ch@skbuf>
Message-ID: <b858932a-3e34-7365-f64b-63decfe83b41@seco.com>
Date:   Thu, 18 Aug 2022 16:40:37 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20220818195151.3aeaib54xjdhk3ch@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0342.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::17) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3d9be306-e350-4f40-b3d7-08da8159ea71
X-MS-TrafficTypeDiagnostic: AS4PR03MB8436:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nKa10a/X5hj+1hAQqFzI+mNLDJcXxT5ckUYzEhVPAoN44RfeLG+hRuLS3Jebjn1vfjoO8mX+zMi/PYnYatcEUVPsWbYJBVvmb6qE066qHHsy1NKuAvw0uFtQWzFmE9kBLzvxIp3DhB4LhpRkB6EP6DL1mnyu2QHTDODGkyWyrMzh0RDkw9GIXThAljuk6ELz5fD42q1La5HpbQjEMjIngxUkUNrLRsPpGPCt64RA1MozZIycsDh7w/O4aaSqGtn3ymbuTJ1482jdlIQDGqVM7qatSkGyOhMwIzWRNdH4p8mV9xKu/CldcCaWDqcWA+Ovq03PZrh1WKX1Wh8MU30Y3+vmDCjsPT8nK2PK7p4rkeMke26penuXsq10gOx9PAoiKSEmCw4bbI3j/96srt/c0JIwj1/WCp7HY0kMtMLK7d8XTh56z0T1MHnzOc4kd7E4orTCtD1L5n4BNDRjBRlerFI9e2ZZ6rkWdMvP4rcBp4CisOzVIOlvEJ7Af3Lc71e6FvE3v+hyMo1BGMWgRji/HV/Br3bAP/7dSGnnno1ySH7YTuDnn/g0N2W0V7/TWoWvw9+Y540/f2N2QkASMfUHxT95AaZpPuiyeA0Sp7fMfPWF408E6DwzFN9uxS5MSlD8ul5YgNdcBhJV2FLfJ9TFeCTPc+7AS49ZDCXIi99PAVMQaYgtE2WrJBgikYnkXSkYIFM4BYLp6AXApmErKYxujter7ljKbbUpwCIRo4U8s/MnTKgSXs+ruD2v7HjAwBewYtagHrxOITB60lztZwUrKHSl8W4rNI/oFvn6d6u6LnGMFVuwvBeDVI0silzzUJ5kcHK+aAn/AoIM4tOKZ/hHmA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(346002)(136003)(376002)(39850400004)(366004)(66476007)(66946007)(66556008)(6916009)(316002)(54906003)(8676002)(4326008)(5660300002)(7416002)(8936002)(2906002)(44832011)(38100700002)(38350700002)(478600001)(36756003)(86362001)(41300700001)(53546011)(6666004)(31696002)(52116002)(26005)(6506007)(6512007)(186003)(6486002)(2616005)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TEJ3aEd2Nm0waGdBSHhCbW1tUjNtNmhIbTJLRURveExRZVhTejNoWFBya3Vl?=
 =?utf-8?B?eW5qa1d1SCtJV1RQWVZmVUtzUnhwQS9sbWRkZHE0dkRnWWpNdHFMMlBxeG5t?=
 =?utf-8?B?ekZXSWJFdks5Yi91TTc5UExWZ25GVVFjWWJjQ3JkbGxkQS9TeDROZkMrYVF1?=
 =?utf-8?B?NWVGVjRGZVhVR0k0dUFXTXNoVzExWTUvVUw5STZJTG9BcE9lYTZLR3F5Ui9W?=
 =?utf-8?B?cVFjSStkeVplTVZKMm1CTk5rd21nVHNuTTcwTWJmdGtRMEVCTm9DVDBmRElz?=
 =?utf-8?B?eTNsSkF3U2F3NjBvbHFmN1RLVUVVWjNQU1RNemx6VWJycjU4M2hNVlRqN0Jn?=
 =?utf-8?B?NkVSOXAzckVQNEFmcGxRSGRvZjNYTjJYeml1NzFibDRaeVlrTG5aVDhLMUZi?=
 =?utf-8?B?aFlLOGZmSnVGcFVSMDVhLzdDMGZkMTV6REttSkpGT3pESksxbHdMTmRETTY4?=
 =?utf-8?B?T1JWOHBxMW1LSE0vTW1lUjFIdy9hY2xuZXZBY0VqeDVBK3k1WTgzcGpEK3RJ?=
 =?utf-8?B?Q2I0VHN6YW5xbTM4ZWE1dU05QVJ6ekRmSTJ5WXJWNlZYTmhnY3hUNTNYRFVz?=
 =?utf-8?B?QWswUC8xUjE4clZBT3dVdy83TE0zRDg4aEZxdmVXdzltcmRwNGpZVlV2WHBa?=
 =?utf-8?B?RDhLa29ZMitrRXlheFB0UzJacC8yRzBWdFFnOGVjam11SkhSbWlhOFcreGhC?=
 =?utf-8?B?R3ZLb1B1cGdlZHlpekhDNmtjcFBaMGRnWnIyamM1U0dmcWV5M1h3a1FZNkRD?=
 =?utf-8?B?aGxsbUtpUW9QUTd3TTlQUytBaGZmZmU3MVFjSGxCKzlkQkVQeUJxZjdwMkt5?=
 =?utf-8?B?WGRkVFF1M0lyY1dlNmNsbTYxVWRkM1JXc1Vldjl4MU13K1VCckVaUnp5S1Zx?=
 =?utf-8?B?L0hCNWZtK1NIazJQcElrWno3dzRSQ3FpZU1rWnJLOEkxSXNmTnhqS3hvbStL?=
 =?utf-8?B?aHM3S3RpUC9sUzEvdmo2QnhYZjJsMWxINDY3Ti90R2pPeDNMZCtZNjhOenFS?=
 =?utf-8?B?QlZpTC9RTm1ueDRqbXFLYnA0cFFQV0laQ016a2NxTGlpWVpDb3N1NnhJdDcy?=
 =?utf-8?B?QlNXQnF5TDVlZVMrT0Z0MTJmZzc4aDVEUTRJbC9raExodUxQUEw5Y2Rrbisz?=
 =?utf-8?B?T0pibk9kMDg1TnUybEhsWmFNY1JZSm1nZmZyRGpoUnp2ZVFvV0g3a1psM1Yx?=
 =?utf-8?B?MnhmZG5sYm5VTm80K2Z5TFU3SW1BYllTWnBhdzY2Ky9QeDQ2MkJGRERRQU9p?=
 =?utf-8?B?dFJseDVBYlBVb052MzREMVppVk91Vlp5WUNzaXJLMjU0RFVHL25RWHdOdm1T?=
 =?utf-8?B?YUZOS2RzRVRRMGVndG1pZHp0M3F1RXNtWS9ZQTIvSVpWL1g4VHNRU2FKenZR?=
 =?utf-8?B?cHl2NzU4SXQybnhOWGpKVWVocDlLOWdnNHVwbUtQdFFndG9FUGJ4aENHdjVS?=
 =?utf-8?B?NGM4NEpOTTViQTJhbjZkeWpkZ0JvbmczcGZsbGljN3BuRzdCZ0RqVjEwUXJO?=
 =?utf-8?B?eEM4M3RYMzVPcEpxT0ZPMElUTFQyVnd5dmI3bTQzS1VGVEljN0ZHRjVzS2Ix?=
 =?utf-8?B?U0lmQzBBVHBrQm9naVJKZHVPUE9VY2JWRlY3SnRaOFhQc3dnRU5PcW1FQS80?=
 =?utf-8?B?K2xmblRtT21xYW41b3RJRmRacjB6S3ZhMEJZb0JWdVlSUEtOMjl2a2l4NTBO?=
 =?utf-8?B?YnFkRDZ2SXVnLzZsT29HOGlOQlNNZGxFcmkxbVF3Y1lqVDJxU3lnQlVDMW5Z?=
 =?utf-8?B?Q0pycFF3c05xV1lxdy9relFFcUYzeERaY2k1cVJEajg5RmFtK3FRVGFabUhC?=
 =?utf-8?B?dS90Q2dvUzE0OFBYamJpdDVtZ29uZDRNMlZiVm5ucmxva0FiMkQ0cFAwMjVE?=
 =?utf-8?B?Vm5OMndNL3lORXhFc0ZjSm5RL0lGT0NXR3JDVFRMWDZ1VnZUMFJsc3d0MkZq?=
 =?utf-8?B?L0lxRTR5c0NmK2FtZXZoSkxTdnZJbDlpRUFKR0krU0s4SXNaWWM2SHg1OUhG?=
 =?utf-8?B?ckNVaGZQcnBXLzdYVXVLdHZ6bE9XTUNBUEhoQjNZMnpHNTNUYzYyNHNBVTZB?=
 =?utf-8?B?RmVJcmpFbTFLM0xUQWg1TmtwVTFJblIvMmpFZTFDNTRxVDNKSGswQ1pWazhX?=
 =?utf-8?B?NTJNdUZHZkdxemU5bXM3cjl2d3B3WHVLZ29hYW93ZWJ0UTQyM09tYlpadHNs?=
 =?utf-8?B?MkE9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d9be306-e350-4f40-b3d7-08da8159ea71
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 20:40:41.2676
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hbZboET9fed3PDB38sWXFfC6O/ao3UIC1OnJ8//FYJk4ExPRqV9JxHF2w1X2drMv7eBVpH1Xnamsf0Z8p3Gg6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR03MB8436
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/18/22 3:51 PM, Vladimir Oltean wrote:
> On Thu, Aug 18, 2022 at 01:28:19PM -0400, Sean Anderson wrote:
>> That's not what's documented:
>> 
>> > ``PHY_INTERFACE_MODE_10GBASER``
>> >     This is the IEEE 802.3 Clause 49 defined 10GBASE-R protocol used with
>> >     various different mediums. Please refer to the IEEE standard for a
>> >     definition of this.
>> > 
>> >     Note: 10GBASE-R is just one protocol that can be used with XFI and SFI.
>> >     XFI and SFI permit multiple protocols over a single SERDES lane, and
>> >     also defines the electrical characteristics of the signals with a host
>> >     compliance board plugged into the host XFP/SFP connector. Therefore,
>> >     XFI and SFI are not PHY interface types in their own right.
>> > 
>> > ``PHY_INTERFACE_MODE_10GKR``
>> >     This is the IEEE 802.3 Clause 49 defined 10GBASE-R with Clause 73
>> >     autonegotiation. Please refer to the IEEE standard for further
>> >     information.
>> > 
>> >     Note: due to legacy usage, some 10GBASE-R usage incorrectly makes
>> >     use of this definition.
>> 
>> so indeed you get a new phy interface mode when you add c73 AN. The
>> clarification only applies to *incorrect* usage.
> 
> I challenge you to the following thought experiment. Open clause 73 from
> IEEE 802.3, and see what is actually exchanged through auto-negotiation.
> You'll discover that the *use* of the 10GBase-KR operating mode is
> *established* through clause 73 AN (the Technology Ability field).
> 
> So what sense does it make to define 10GBase-KR as "10Base-R with clause 73 AN"
> as the document you've quoted does?None whatsoever. The K in KR stands
> for bacKplane, and typical of this type of PMD are the signaling and
> link training procedures described in the previous clause, 72.
> Clause 73 AN is not something that is a property of 10GBase-KR, but
> something that exists outside of it.

You should send a patch; this document is Documentation/networking/phy.rst

> So if clause 73 *establishes* the use of 10GBase-KR (or 1000Base-KX or
> others) through autonegotiation, then what sense does it have to put
> phy-mode = "1000base-kx" in the device tree? Does it mean "use C73 AN",
> or "don't use it, I already know what operating mode I want to use"?
> 
> If it means "use C73 AN", then what advertisement do you use for the
> Technology Ability field? There's a priority resolution function for
> C73, just like there is one for C28/C40 for the twisted pair medium (aka
> that thing that allows you to fall back to the highest supported common
> link speed). So why would you populate just one bit in Technology
> Ability based on DT, if you can potentially support multiple operating
> modes? And why would you even create your advertisement based on the
> device tree, for that matter? Twisted pair PHYs don't do this.

The problem is that our current model looks something like

1. MAC <--               A              --> phy (ethernet) --> B <-- far end
2. MAC <-> "PCS" <-> phy (serdes) --> C <-- phy (ethernet) --> B <-- far end
3.                                --> C <-- transciever    --> B <-- far end
4.                                -->           D                <-- far end

Where 1 is the traditional MAC+phy architecture, 2 is a MAC connected to
a phy over a serial link, 3 is a MAC connected to an optical
transcievber, and 4 is a backplane connection. A is the phy interface
mode, and B is the ethtool link mode. C is also the "phy interface
mode", except that sometimes it is highly-dependent on the link mode
(e.g. 1000BASE-X) and sometimes it is not (SGMII). The problem is case
4. Here, there isn't really a phy interface mode; just a link mode.

Consider the serdes driver. It has to know how to configure itself.
Sometimes this will be the phy mode (cases 2 and 3), and sometimes it
will be the link mode (case 4). In particular, for a link mode like
1000BASE-SX, it should be configured for 1000BASE-X. But for
1000BASE-KX, it has to be configured for 1000BASE-KX. I suppose the
right thing to do here is rework the phy subsystem to use link modes and
not phy modes for phy_mode_ext, since it seems like there is a
1000BASE-X link mode. But what should be passed to mac_prepare and
mac_select_pcs?

As another example, consider the AQR113C. It supports the following
(abbreviated) interfaces on the MAC side:

- 10GBASE-KR
- 1000BASE-KX
- 10GBASE-R
- 1000BASE-X
- USXGMII
- SGMII

This example of what phy-mode = "1000base-kx" would imply. I would
expect that selecting -KX over -X would change the electrical settings
to comply with clause 70 (instead of the SFP spec).

--Sean
