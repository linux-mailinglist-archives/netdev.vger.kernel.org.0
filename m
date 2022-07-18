Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A7AD578792
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 18:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235076AbiGRQjK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 12:39:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235280AbiGRQit (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 12:38:49 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130053.outbound.protection.outlook.com [40.107.13.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CECA2B18A;
        Mon, 18 Jul 2022 09:38:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fcisCrPuGpQ3UhxNJNTxrxZNaZofwx+Etspl7GCdjwV1r0arP9Ec8jwkwXmFztl7YbWUEpfpUrEdktvyPhqsCaWvikw8GZ9J1D9Q73NivzJBF5T6kpcunkIjPBNYJgxyc5K4dRLOBv7gERybVnrMGsoV3kuAHHW7fDTt2PouEOp2V5jO3JbRqVtcca99pmBs0iHR9IyfvlSF5RI9mhQOMmSFhVubwVrNNNf5NCcfZaAmz6266sfltsCqjz88pVTq05iARIVm+hY7H5AFGNX+UuA5OCwvh9OakFX2CHF7SISeHTvcwL1qQ9KngxURp7YPO7SpY++33Mv2c+4S+ZTJcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sSxk4yJrulyjlz72KdnbcoERE/D359KUvTgaxMSGGpE=;
 b=J9QMkZ1A+D99d0grYwAlsBbEj+1dFG+uyuoXLV5LDA7vGaSzi67vuQMOGOAScdevUD5VZ0taoMJ1q8NCknRa/gUwbyHDSMvQvAUDQR0JEbrCOWxXdT+kqXiP7DNQREYcU0Qi7gOvB/2gD9tzfSUyPh7mIKSsgBlORUEZaR73J798Ki241YVIPB9gDY4VJb4+NkzKO3ITpoTq5IDxYd3u5yoeSNCTuk6/O2ldWXyj+kmQjIEcXT0ie98z1dLKjyDja+Ee2hgbCK3tqZPkJyvyD85fMeU7Xm88iEberdj/7YZBh9cXnjUdrI7uVjN9fapc/agpca7rrbs5dUKdinjvBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sSxk4yJrulyjlz72KdnbcoERE/D359KUvTgaxMSGGpE=;
 b=2y+4vrryrxnMC5lY7RkmfM/qPZJ0SnwB3GdrRWys6YGJOsh426N69DD+ciy2PibKAm6I5lwHnhtqqw0dhKzjziZFiKPh1AOicXRkulsYARPZzbGHFBQigCZbBT82vCYr0NQDnYZWoBGaGVXA/UvRJTug6g3kfd5FwBus1IggAy1rTj6iqtDkGVShGmlGes8mtJ+3ggVOACYSBqRis+x/vBcgZ2YkkllsJlL+DyGdBXiCziyZrHyt6Gjm0hnLv9tjKqdAWBpTfvoyauX2Pe4fMEP/e094sN/BvhnQ6HNUa3o/UsY5aBbj/2e7FBe2aTe2BT1vS+Ow0vcIqvan7ZIvZQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB7PR03MB5097.eurprd03.prod.outlook.com (2603:10a6:10:33::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Mon, 18 Jul
 2022 16:38:43 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5438.023; Mon, 18 Jul 2022
 16:38:43 +0000
Subject: Re: [PATCH net-next v3 08/47] net: phylink: Support differing link
 speeds and interface speeds
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
 <20220715215954.1449214-9-sean.anderson@seco.com> <YtMaKWZyC/lgAQ0i@lunn.ch>
 <YtWFAfu1nSE6vCfx@shell.armlinux.org.uk>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <b1c3fc9f-71af-6610-6f58-64a0297347dd@seco.com>
Date:   Mon, 18 Jul 2022 12:38:37 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <YtWFAfu1nSE6vCfx@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR05CA0025.namprd05.prod.outlook.com (2603:10b6:610::38)
 To DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e0cb81e4-7882-4b64-bf36-08da68dbfa32
X-MS-TrafficTypeDiagnostic: DB7PR03MB5097:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 43cAHl90F49MCmpfSzzoGS0gyj7agw1aIhRQoCtD4t++RVG7sp5Jdy8u5SEOMgJ8PvjKuOtse0ohvq4t33gSPDExslDQ3b54tbUXPTgd6jZeBcDD+IfILYtY2LKYURVHsU5ivLiradCOhm9aajNgVOwMoBS0Bv1mRDqSpSfRmRFCBhxwrOa7xXfQugHIyq6M+gjyAC3w4kEoGFiFTg+sqcI3Y5TBzWMnb3H1VAqtuxaIjQni7BcW97LiSYJLq0BXiPuYrtx/6FrYu0Sq+w6/XZ+gbCwDvqackFPEXPKnchOajQK1yt7JMlh5hQg+M+idfKQlH1l/BUFRyTIR8DR/9MIdfRx05UukSkb/5yVBx2/S6ZzKvaWYwmCFf3aYuqq07VumylwRc3MecPAcGvHcbEyhY5kHOanBZdA56eeCsxyjXnsnp2BKmCd97J+bzP49qutIYcYzvTOMrFasfSKL/TB6bNQu0gPf4IkB8pzNlwRUN+XNNEj7wej2lPYED+SplSJiMD9WFJ4/yEN8gXB1r1SDdb4eiKFQrdywuJ24Dl9H09MUGzdc7gBVczduRUqBKCv1iiZ4Gj9SWeg54baaF8wbvGpg+SQbXL0q8INe1y7sEa1hGN1Ec3LJ7kneSORlKHIYc6QnnB1anmCuLXwwHmRpSLRfiuG1dD3hsAtuIZDXjAUNkpHQkg4j0huHIkVUC8IXspIOQ0Y6ECLRQCD80lWOG6vofi92wTqiwkD2PloApUf+b5CpqlUEtXwoF48Utlq3QRR6NZBM+MFgBwMIvhvyMe8UHc2Tq80DcGpZTdrhwq8W4zPSzzrvQo9GUgn164hfL5ZCcgLLpx5zgsdT/sgupmJ+mU5y6u17zVB1k0vMuPiChgRCHqXMSKPApE4h
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(136003)(39850400004)(346002)(366004)(396003)(66476007)(66556008)(66946007)(8676002)(4326008)(8936002)(86362001)(316002)(110136005)(54906003)(31696002)(7416002)(2906002)(31686004)(38350700002)(38100700002)(36756003)(5660300002)(83380400001)(478600001)(26005)(53546011)(41300700001)(6666004)(6506007)(52116002)(6486002)(6512007)(44832011)(2616005)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RTAyVUwreXQwVUJVcTZwUkZDTkMrRitwSnlvTFpVemR2TXdyZ1JETkVzazR2?=
 =?utf-8?B?Q29YeDl0SEo4bVhtOXJYRXRWQmo5TVRUOGRPZlBPbXpXUkZWMlhUeGFSdVFi?=
 =?utf-8?B?dlh3MUFGazBLWS9qVGJDUlI0dEdTQXU0cmxGSVNhaTdPQ0FVejh3UUI5ZlYr?=
 =?utf-8?B?a0RQYWs1SXE1dElSaG0wU3hGQWEvSVlrZzUzNUcwUVhwQmk1a1dTdDNKaFor?=
 =?utf-8?B?Q05nR1dzbXdFNE1Tc2FFZk9IdloyaXFJbHh3TGs5S1FMMVUyOURPcjNwbWg3?=
 =?utf-8?B?dUdXS2JndHQ1K1pHRHRQUGVaZStFYk1nRFlYbURscThZWkprQmhJbGhDTG1E?=
 =?utf-8?B?RGNSdVdUSVBGZ1VlN0Zla2QzMmZVVTM5YW4wWTI4VnZmVGtaR2xySmVYblU5?=
 =?utf-8?B?VmJPTnNIZ2Z4eUhWUkl6czFwZ0tvQlI5SlE3NnJKQUtERkF1RVhCUG16RFhF?=
 =?utf-8?B?YVROSUxsN0lLWVFDaWNpOWVCMkcvNnpVclp3TTVRY05RS213c0JHQWxKbE1k?=
 =?utf-8?B?YjQ3NDBjZm1MTEZXcnNYekRwd3BwSElJUkNNK1VxbWdIL1NOUlFMcnZLdFV1?=
 =?utf-8?B?RVgxOGQ1NjJRU1FKWGZ1aWwyZ29rNisrYTU1L2lZSFBJWVZsQU5UeUxmVFBL?=
 =?utf-8?B?QVFmOTJhVjZ1UHBDOGNDRDNuVXdEYTA3c1pzZnNzNThidkdhM2dQaUpnZWpG?=
 =?utf-8?B?N2JtcnlENjZxTUEyeFVsMjB2aFRDUFNrVk55NEFvUlFBUmhnV2lpVW9Vcld3?=
 =?utf-8?B?TFZGbGduK25ZLzB3UDVtdS90SlQ0dHhJNXlPWEg5RTN4WGhMeC9aalV2MEw0?=
 =?utf-8?B?cHRLaXRGRTU1dllwUlk3ZTdrQUJoZmREbERsZktSTVhDSnFlWkh0dzhBdWhP?=
 =?utf-8?B?YkErRWYrYUZ0Tk84TE5hSVpzci9xV2xYVDVtZi9uTk00b1M4WVVnQ3kwZzBN?=
 =?utf-8?B?Y0RVZHdXOHoxam94U2FwS3RFbkpIQU5FdUcwU3M3dDkrb1ZzZitwN1hkL25z?=
 =?utf-8?B?a0F1ZzBmcUEwcFhXeTZKOVNTMG8vR2xXU0g5TzkxY0M1K1IvWDQwQjhmOTFO?=
 =?utf-8?B?RDRxYWZxUGZmd1dvOE9Yb1A4YlI5bm1WUS9aTzUyaUpGZVBaTlp0RmlxZEZO?=
 =?utf-8?B?UkZyNFVuYk9QNHI0SlRvS1FKbTIzMTlVZWJqbGRYU1FUaUVNRUVFVmtGWUdq?=
 =?utf-8?B?SnFuZkc4YzlaUWxsakVvYUhMM3k3NUhPNVMxWlM4UkFMRWsyb0h0b0FEUnY1?=
 =?utf-8?B?b1I0ZzUxdEkyVTZ0cGp5ZVpWekxBZmJnK2M5WXArL1UzNVVXVTR6S0ZOYzBh?=
 =?utf-8?B?YlAyNFUzR3M3Ri95SmRWZU1YaGRyR3BPWm5lZDNhTnpEeFhteTZzMnVSRkZ3?=
 =?utf-8?B?WnlQMW9KNFpMYkpMK1U2Qy9uZE1XYnFNbDhkSnJwTER1RmRRM1JpRUQvdDBm?=
 =?utf-8?B?WnV3VlZJOVZ6RER4WGFOWm1KRDBTNnhOLzhZUk5Sdng2bllHOXRQWkE4VG1P?=
 =?utf-8?B?bG1abzBtdkNmZ24xT0Uvdjdjd2RNVW9sS2cydWlpd2NIekZ1QVg5aHVSeWZy?=
 =?utf-8?B?M2lpT2tRUWVWM3VzNmtRVUdRZmlXT1dvelNZRXljanR3dW9DYUhHMWlQK21D?=
 =?utf-8?B?czZuTWlSNlhvQUJCWWVHQ25wM1FoUDR6clNWSFVjZzlNcUNUNG1UL2hHTUxK?=
 =?utf-8?B?L1BBbHhhSGpscDEwNjArampsbHhNMFc1UFdZSXlmd050eGMwS29aVXFuTjJO?=
 =?utf-8?B?bFROOWdRMlcwdk5Id2l1T3phNG1LOVJtc0R4U0dRVGg2c05CSEZYb3gzdk90?=
 =?utf-8?B?RkYvWk11Qlp3b2YzS1UyNStjMVU3dGtuSWNELzRHalVqeGF6bTdUYmg2QnR0?=
 =?utf-8?B?WElyend5S2kyeE1nWXd3dlc2V2VOSy9VYTUwWUlZdm1penAxN1dlbkJrV2l0?=
 =?utf-8?B?N1Z6QmpaRWdueHNIQkFJdXRuVlpWQzNEQnBrNFJqQlo3YlVkbkFPeTlJaG16?=
 =?utf-8?B?QWZPSytTd1pqdXlPOWFMWVo1TXBjQVBtai9wUmRnTkM4UUZFdGQycExiRG1J?=
 =?utf-8?B?bXpUYlpRTlJseHFtSWZaRW8vaFVINmtSY2p6WmhWRyswby9YM0NnZlVyMEVm?=
 =?utf-8?B?bTlGMVlDZGtPV2doWUQzZ1pKckxwdy9ZbjhSbDVUeVV2V1U2WkhjNFZiT0to?=
 =?utf-8?B?OXc9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0cb81e4-7882-4b64-bf36-08da68dbfa32
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2022 16:38:43.2198
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mYK1UzzTElTT3VzXz1ggOjoxrF2pv8wEq6ST06g0K6HOZnF2C0EOI1xb1mtJ19Shzujglbfg3bt5agmFIvZi6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB5097
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/18/22 12:06 PM, Russell King (Oracle) wrote:
> On Sat, Jul 16, 2022 at 10:06:01PM +0200, Andrew Lunn wrote:
>> This seem error prone when new PHY_INTERFACE_MODES are added. I would
>> prefer a WARN_ON_ONCE() in the default: so we get to know about such
>> problems.
>> 
>> I'm also wondering if we need a sanity check here. I've seen quite a
>> few boards a Fast Ethernet MAC, but a 1G PHY because they are
>> cheap. In such cases, the MAC is supposed to call phy_set_max_speed()
>> to indicate it can only do 100Mbs. PHY_INTERFACE_MODE_MII but a
>> link_speed of 1G is clearly wrong. Are there other cases where we
>> could have a link speed faster than what the interface mode allows?
> 
> Currently, phylink will deal with that situation - the MAC will report
> that it only supports 10/100, and when the PHY is brought up, the
> supported/advertisement masks will be restricted to those speeds.
> 
>> Bike shedding a bit, but would it be better to use host_side_speed and
>> line_side_speed? When you say link_speed, which link are your
>> referring to? Since we are talking about the different sides of the
>> PHY doing different speeds, the naming does need to be clear.
> 
> Yes, we definitely need that clarification.
> 
> I am rather worried that we have drivers using ->speed today in their
> mac_config and we're redefining what that means in this patch.

Well, kind of. Previously, interface speed was defined to be link speed,
and both were just "speed". The MAC driver doesn't really care what the
link speed is if there is a phy, just how fast the phy interface mode
speed is.

> Also,
> the value that we pass to the *_link_up() calls appears to be the
> phy <-> (pcs|mac) speed not the media speed.

This is by design, to avoid breaking existing drivers.

> It's also ->speed and
> ->duplex that we report to the user in the "Link is Up" message,
> which will be confusing if it always says 10G despite the media link
> being e.g. 100M.
> 

Ah, I should probably change that message as well. The ethtool stuff
is already updated by this patch to report the link speed.

--Sean
