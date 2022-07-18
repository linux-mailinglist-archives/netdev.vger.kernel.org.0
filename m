Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2B715786BB
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 17:49:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234938AbiGRPto (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 11:49:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235192AbiGRPti (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 11:49:38 -0400
Received: from EUR02-AM5-obe.outbound.protection.outlook.com (mail-eopbgr00078.outbound.protection.outlook.com [40.107.0.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A51011473;
        Mon, 18 Jul 2022 08:49:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K4zLA0l8VDjkfjpwUFyo+IaHJxoB2rRRx5PaBIdQzJwVg1iewUqPUljDaoyF3nlZJMpY11Z3xvQ6mFnP+Rs81Gmk9SZr5uOtWtmnRnSnrhTxSSSvygdzo7N2k9ERm+Q+6M+IebvSQdq+xHFhaYpA44bdZJkT5twXkyBIvsywgO6HP0PFQcu/pH1uUcHgxm6u35eIqHCflGb+Q3RkeqxzRGEltsfOFqJX7KTJi/ldZ60tRrI6dS9N8eWE6br4CECTgveJ+uMNpuxQaYRBkI25Mbu4qiPFjisQw5gX1Dc6ewFA+PrPBRwkDZH4LO9+/56jwTaO8/9H2toXcQ8nfJpYsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7vPdVf7NkMjEn1Dw68n07dVL7Uqc6PqkL+5R6Tp4K1c=;
 b=fm9Vqv6yq9etdiSIiCWe+UKz2k8/MoRa+KWvA0C7KwyyYzZJIUK8czRiqZZUvhYQl6QciifABXB/VBiKLIJ3f8EVPn4clPz3+vbAtyjr+m0Z+NmV5EMP/myVkkqi9SdUcAa9INq9ijIKpOO9WaI+u8IxzOzflfeFe4obcgWP2lrv4k3l7rQ+pFBxJtx6L63af0/g9uJ5dSIUDF9/yqdyHNzSKeFzG1rI/RhxrVgctoZPizR9U+1vJpq6PkcIieRslzR7DLZ8hm9yjP+0bXFmrHPSPCuXatLYTB8TDFc7OZWJ1gYdm8dXY7aFIEdCR8JFoqvMRB7WP8OBxfh5LOaqPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7vPdVf7NkMjEn1Dw68n07dVL7Uqc6PqkL+5R6Tp4K1c=;
 b=Vmy75OiOrEEmO++y8wGvLuJvvQGshNSVbWhXIVbJEyTAE/P9a4RwYAc4wfjqu9C+WeMoln4Zv/9QtAAbFaRiGJTUrnUCwlaDP6Y+knqgbnCNXzinS6K9AByG1qco7iy4+7oDsa/HHd5MhQlMoxvW++QMAELFney6ce+kyPQh311kuqpkoEs2Mx0F2yk9E1XYB/4Z7F1u0mmuxKCi4bumG4hYtQdCpI4/ihIvD2plNJRNliS/vKsKu5BN2PBUEYFmkeL6rYOw3FHeoGCQ9NjnBE8pEtOjzHZKlHJzOoiPcCGrc1pES7RouBmAgF/vxpchqaRAi+MGrQCEC2xEwbf2Uw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AM5PR03MB2898.eurprd03.prod.outlook.com (2603:10a6:206:19::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Mon, 18 Jul
 2022 15:49:31 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5438.023; Mon, 18 Jul 2022
 15:49:31 +0000
Subject: Re: [PATCH net-next v3 08/47] net: phylink: Support differing link
 speeds and interface speeds
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
 <20220715215954.1449214-9-sean.anderson@seco.com> <YtMaKWZyC/lgAQ0i@lunn.ch>
 <984fec49-4c08-9d5a-d62f-c59f106f8fe5@seco.com> <YtNlXA4lBeG+gRXH@lunn.ch>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <918b1c8d-1794-3ae9-a68f-0e0c24421169@seco.com>
Date:   Mon, 18 Jul 2022 11:49:25 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <YtNlXA4lBeG+gRXH@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR11CA0027.namprd11.prod.outlook.com
 (2603:10b6:610:54::37) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bcadace4-aea0-4745-0252-08da68d51ad2
X-MS-TrafficTypeDiagnostic: AM5PR03MB2898:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YCgmqrabnu+q6fhOZQJ98BIUzNv50+da3DJ3QwoUhuCU79ZPg6dfYfh1ZDUi/y3V1IWUw1/nQWGZJJlgv482+hj7/iycz8dVEKOzUrcZl4BDlr+uWqWDS2dZLZmepMo9+7E0oFGteM6omQp4BtoqWE02gHP4FDpJ38qnctUdTmqAkyIdWLnKuteMSQZlBXE+Hd2hK62/D2aJv4fDuNEbhtQxUXlhhXvzo2Z02lgxBPuvxWi+W6l1+VsVc9Hs2c1REWI6tj9hYVS4caaYRVu9BrW5cn9UI+9itLKTQSrKP7c0KndZZMMhDkiov+y3LF+fyLmXnOgqPZ8viNPLR4NEVyOVX7mYaSvcTHzAys0tVtJzrBBcUHUIo/VU3MShlj/SaFgsesB75tW3IqF/3jiffyFRKk5k9RcmQXQeEhT/qYjIbtasb4WXyX3bO9vINuo2CcDNoG/WrODGk8Saqk5smcaqKBLD/gxzgSto6HjbOr6xSJ4d8/V2qcruYscG3h6TuWMWVEGCUHGgyObRP81tTLQ+4wHgf3oSHCy22ztVVz28JX2BiZ3iZFpJY/y+Ve7hTxmkDp2QnQwdiySeArNJxdjzKT2m+iOgKWFppjShWXu/ubXuZnGj22dnLz2qjgZDLEWNs72Ch+QaXve1Xa3tBw0bgr+vzUMC6p8t7w8Q/pFm5NffqrF6Ti/Ohl8gFV7rvE73rJa6NRUEzkPs14/oqqTJ0TeU3uBVERAhi+pKz2oi1gzilmGXT8dlPCyQN+denTZRuLzqruJBKQWL+0BMafK2MWJNmxzvOczyzhZNTedyJBnkbRLZofIVjnEYxzbry2VqGGS/CQzJEhffjttCyeIVmy88Y5HiRYJsgsmaU4jnvePDblokFHk7DKAe0KoX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(346002)(39850400004)(376002)(136003)(366004)(2616005)(83380400001)(38350700002)(6486002)(52116002)(478600001)(186003)(53546011)(6506007)(6512007)(38100700002)(41300700001)(26005)(66946007)(6666004)(7416002)(44832011)(2906002)(31686004)(5660300002)(36756003)(8936002)(8676002)(316002)(4326008)(31696002)(54906003)(6916009)(86362001)(66556008)(66476007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Ukw5S0hUSjUvbERIVHBmNlNLYlVESithbDMvcFMyTUFsWHNrSUpVRnpmMHV1?=
 =?utf-8?B?NkhlWkhRaXlXVGJYR0hoNU9aenJCUVo1cjY5dUNidGVTY1RQMG05Y2NZYjd1?=
 =?utf-8?B?N3F6ajNkOHZtdDVoZDg1dG50VTlQd3loUlg3OWhsY1dsZ25CVWlwYlRqYkhj?=
 =?utf-8?B?U1Z3MUZZT3Q5KzA5dDYrUGtQSHNGdlZDelRMQ01DRFZxdGd1cnBiUjZHNFBW?=
 =?utf-8?B?aENHN2U4RzFCSEowc2xpYWpvdjFrUExuOWt2ZCtEZXQ1dUFobTJudHZhN3pY?=
 =?utf-8?B?cUxFWUo4Q1NPeVZUWitSZ3QrZkV4MFB2clJDY2trWVN0Q2ZCak4wUHBaeFh4?=
 =?utf-8?B?N0NnTHNHOHRXa3I2Vi9mWXJrdDR2MHkra0FOMU8rWTE3NmhCbG1RMmNkSlVV?=
 =?utf-8?B?SHlhOUsveURuRjBaR0dFOEx1ajZEY1JkMC9lNjZWZ0dTS3JHejFFbnNnWXlN?=
 =?utf-8?B?M1lKK0JXa1NNWTE5M2tNZm1aZTdPTDQwamRYMEp5cWo1dTZpRzlyUnllYlcx?=
 =?utf-8?B?NkRxMzBvMmtHcWNyRXZBYnNDWGErdVQ3bEIwVktvOHZ6cmRHdmJ1OHR3UXcr?=
 =?utf-8?B?eHNUdEVxdU93cnV6KzRnZUp2UFhsNEZJNUpxa09vNWhnM1FqVmxRbDRZaUdS?=
 =?utf-8?B?WlBqRXFtVzZYUk1UZFJhRzhiKyszbklpN1ZSekRRZzVnQlAxOEhwelRWUm8x?=
 =?utf-8?B?dFdKUnh5OGN5V3lta0pESDQ2UDBPdlc0bmJxNW9WOVdmWlJaMU1UOGRlMVA4?=
 =?utf-8?B?VU9tU3BvQmZ3aUZWTXJGVDBPQXN3NldOR2FKbVd1V0tRdjR1QVp4c1ZOYkMx?=
 =?utf-8?B?aC9zdTJIditSQXBoTXFTeWU0T1l0QlJ6dHdHVnBkYnU5MEdrbTdzK2taK0xz?=
 =?utf-8?B?NFY4OVlIYisyRVlrQVBzaVlmRFNPVEl5ZFIzRWFvYjBMZ0xGUmdvN3dJUUZI?=
 =?utf-8?B?QUhBMzYwU3FzQ0Z1OHRQZlpSSE00R1NINUV3R3N0aTRQdnZKWjNxSXQ1VUdN?=
 =?utf-8?B?azhiOXhsRG0wVHVUQ0hyL3BpMFpCUklNUGRkWmFiaFBJOW4zSXVabzdydlBz?=
 =?utf-8?B?TWlYNkYxQmV4RVpUU3BJOGQ2NFg3WlBCRFE3SHl5em5qbzdIUTlUYlR2NTNm?=
 =?utf-8?B?emlxelk3bTduZFhlQ09tdVh2R2ZySHBTSDd2N1MxbDNtMks0dmxEUnduNmxN?=
 =?utf-8?B?N1FENkVrWjI2ekxCSzdHS0xCN3ZuK0g1Wjl5a2FTM2pSdkVNZFFqWGY1Z3NT?=
 =?utf-8?B?TlJJWnBaZllLTkNaT0p6OHZRWXFQRVZsYzM0SW43NGtPSGVQSk5qMDk4eG0r?=
 =?utf-8?B?TWpnZHlzRnRHK3dKbmZ1VC9randFUjN0Mzh3R2kzVmNNYXUvMFcvWWRUclFY?=
 =?utf-8?B?QzRRcUFEbUNtcDk4K2lyeWRCWDYxMDc0cFVFUzNSK2pxYVByNTJXUHE4NFho?=
 =?utf-8?B?eDFnWWtPMnBqVnFVQ1BtWkR5RkN6SThEN1hlSXFnT1JDUlFMQkkrcEVVSHd4?=
 =?utf-8?B?djNmMXVRak1DZy9zWmtpcnprTTV1S3hmekI4bm44cmZwUTFGcHNhUnk2WGtW?=
 =?utf-8?B?Y21NZ3libElvak85SXlzM1VITDErOUhJR0pqVXBqU1NFWUNUMTI4eFFtVVZo?=
 =?utf-8?B?RTgrNHRpMHhSS0lUUWFkZmkyenRUOWdEdTRRUEZzU3c4ZVhtMFMxc1ljajRT?=
 =?utf-8?B?ZWJ1WjBwdS9ZQ2x5ZjBHOElFZFZTdnRjb2xQcVRFVUozeklvdENjdVhPcldN?=
 =?utf-8?B?cnIrb0IwdDNtdWFtbThUZTVhdmxCZTI2QTFTalFvUUJjL2NQS2JlZTE1ZXNz?=
 =?utf-8?B?QkFkVXF4QXFlbGU5WlBRMzFURjVzQlR3VGxuL2duL0hJSU1UMXlLWGxqQnB5?=
 =?utf-8?B?c3o5b3hGTUpwcThnZXhVR2Erd2VadXNaRGViMWZvbEtkS3kwSlVWRDZLSlV2?=
 =?utf-8?B?c3phMU1aVkliM2FtRkFFd0Q5YWlYVGN0d2JlamZMc1pubmhqaStGNnRUK01W?=
 =?utf-8?B?clpZc3ZmMFNKYzN5YWNnUnVLeTRCeGFRenJwR2FuaVYwUVhmWW9RRkQxNkpp?=
 =?utf-8?B?eU55dHlrSEpkTVNVUFk3dmdqL25hRW1IUG01YXM5RmNSSHRJMnlNeWV6MHFF?=
 =?utf-8?B?NHhEaGFrRXAzbzdPaSs0VU5DWWNxWEU4RHhlYlBwcTFaRjlGdDN5cnVPYTNM?=
 =?utf-8?B?M0E9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bcadace4-aea0-4745-0252-08da68d51ad2
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2022 15:49:31.5671
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /Km0cNlcwIT+tVl0Jki/S78Qesn0lRnrbHR6l8tr3/bLahEp5BdfM8cZf+snfZZOl0OyyCx4VAzNtoTKjG9roQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR03MB2898
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/16/22 9:26 PM, Andrew Lunn wrote:
>> > This seem error prone when new PHY_INTERFACE_MODES are added. I would
>> > prefer a WARN_ON_ONCE() in the default: so we get to know about such
>> > problems.
>> 
>> Actually, this is the reason I did not add a default: clause to the
>> switch (and instead listed everything out). If a new interface mode is
>> added, there will be a warning (as I discovered when preparing this
>> patch).
> 
> Ah, the compiler produces a warning. O.K. that is good. Better than an
> WARN_ON_ONCE at runtime.
> 
>> > Bike shedding a bit, but would it be better to use host_side_speed and
>> > line_side_speed? When you say link_speed, which link are your
>> > referring to? Since we are talking about the different sides of the
>> > PHY doing different speeds, the naming does need to be clear.
>> When I say "link" I mean the thing that the PMD speaks. That is, one of
>> the ethtool link mode bits. I am thinking of a topology like
>> 
>> 
>> MAC (+PCS) <-- phy interface mode (MII) --> phy <-- link mode --> far-end phy
>> 
>> The way it has been done up to now, the phy interface mode and the link
>> mode have the same speed. For some MIIs, (such as MII or GMII) this is
>> actually the case, since the data clock changes depending on the data
>> speed. For others (SGMII/USXGMII) the data is repeated, but the clock
>> rate stays the same. In particular, the MAC doesn't care what the actual
>> link speed is, just what configuration it has to use (so it selects the
>> right clock etc).
>> 
>> The exception to the above is when you have no phy (such as for
>> 1000BASE-X):
>> 
>> MAC (+PCS) <-- MDI --> PMD <-- link mode --> far-end PMD
>> 
>> All of the phy interface modes which can be used this way are
>> "non-adaptive." That is, in the above case they have a fixed speed.
>> 
>> That said, I would like to keep the "phy interface mode speed" named
>> "speed" so I don't have to write up a semantic patch to rename it in all
>> the drivers.
> 
> So you want phydev->speed to be the host side speed. That leaves the
> line side speed as a new variable, so it can be called line_side_speed?
> 
> I just find link_speed ambiguous, and line_side_speed less so.

I would rather use something with "link" to match up with
ETHTOOL_LINK_MODE_*. Ideally "speed" would be something like
"interface_speed" to match up with PHY_INTERFACE_MODE_*.

> The documentation for phydev->speed needs updating to make it clear it
> is the host side speed.

OK

--Sean
