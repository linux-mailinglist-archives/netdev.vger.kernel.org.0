Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 824A66244E5
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 15:55:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbiKJOzs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 09:55:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbiKJOzq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 09:55:46 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140077.outbound.protection.outlook.com [40.107.14.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02F7955BB;
        Thu, 10 Nov 2022 06:55:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xp6Xu5njkKvzX4Y8CJplFaZazPIWLN0ib5i1XgeFqJBNbGwcHb9RngTXFEZbxwyq3LH/aP5LTbZfF2hLwVU2kCRk0DMP9bRGkKrgJtv536WDhUJVn2AA1W4oHYbttvyVVML+dPo2xU1O9M0lM9SY1XNlB/2bT1qcqri9haYi7iWvAkt9X0De213Ul7BfkYA9hSApF88jKD/dbT1MiAK3xLhRZQCoDQsNyXrcH0k+DenKCVdwDqt8GrIkgIPc5iqqIqKLpyuc6Rx/xYczvQIBMDwflIfNUTmXkyh4+/L8jdDFdyiVGMKHVvD88fb2q66G/R7TqSFWIaLHb1vjbUXKCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ONNO7+gxGjyLs9EdxaAuxZ4HVuWoqU4cok57uwS47FE=;
 b=IMrUOEWkgde9phCXnG3IO2R4JR4jcXmnD06FvBbjIqeSqzzEmbXtUPBSfkiHTd+MUKiLUWLEkbyDB07x1gWClgmMhD1kVqXBmXSSylGzY4eh/3fuhKj70yBsEYGAChmvrFMqdb02gk2TbekTYZhEJqtDgRxJmwQIV27LuFzSAHqKE+hCdePKWu2a6ZojAUEZ2YrUAmhTQfDD/2jvgNyxN4TuhPzX/KJbbno/OzuzYuWbPtmZ0AAy19LzGKTQpsbDQekQkX83rEeFNk6mJXPPdA73INi2768pGJ5pHjaGLtIROaZNb/9PQn9UXcqCP/oanKMgfOMbgwdAGrGPWsTFoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ONNO7+gxGjyLs9EdxaAuxZ4HVuWoqU4cok57uwS47FE=;
 b=WRqfDB84+oTrHsCGu1PM/NXDY7ktJfkW0/Q5R8xHdSGft0zuQFHUya5CJWe+AeD1NN5Wq3Ni8Mys536GEFn/uMn5/17tZdQlvm/OEaFq9QxEDrdrIAGVU/4BMFb52w4LHpFfzoDiEG5LqN1O2aYM4HSQMSL6gnx6qWBS0VgYE2j4HCFC/HOAFWgwXczhlFmdyr7yZLmChh+CVxU13VVaviFX3oKRXh/oQlT1AmxcA+lppbtKCmlVAJ5fKyNCcwcAPyzguE6abnDUtcN6sjrN+ew/PfOg+O4WYLTSyGm+qNlsH2PJcj6MQVJIGFNtCcQu9wErtMAyD41oTfr5ouMGrQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by GV1PR03MB8662.eurprd03.prod.outlook.com (2603:10a6:150:95::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.25; Thu, 10 Nov
 2022 14:55:40 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::e9d6:22e1:489a:c23d]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::e9d6:22e1:489a:c23d%4]) with mapi id 15.20.5791.022; Thu, 10 Nov 2022
 14:55:39 +0000
Message-ID: <bcb87445-d80d-fea0-82f2-a15b20baaf06@seco.com>
Date:   Thu, 10 Nov 2022 09:55:32 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH net-next v2 00/11] net: pcs: Add support for devices
 probed in the "usual" manner
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
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
References: <20221103210650.2325784-1-sean.anderson@seco.com>
 <20221109224110.erfaftzja4fybdbc@skbuf>
From:   Sean Anderson <sean.anderson@seco.com>
In-Reply-To: <20221109224110.erfaftzja4fybdbc@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0330.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::35) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB7PR03MB4972:EE_|GV1PR03MB8662:EE_
X-MS-Office365-Filtering-Correlation-Id: 927e5b90-edf9-4316-50f9-08dac32ba1d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5PObedpEc1Ao4qFXg5XrsJXKZRoHyosuR6bOHXmsCi7Dr6MyR67KrDXT8/6F8doShUN4smOny0ptfEA5Coc03csJnRxaO22+1adGjxC/ezgLVncYzWWxlJ/WDoIEYHfR+xst3U0JreDyLO6MPqQmlCvG/W0NA2pyBphqNPeXXa99RJtCJWIFfuLAlu5lV24SHydCR/znuWF+G6V83Jb396p8dYal4/dzktvTcyULaVCTOO3H610jkxnA9M+4DyLdshrUXRyntkIIkLK8TxXkm+y6XPbfzk+OU18GQp6gzr9E4H+WexBkICzHejZwkomu6WhMvmnj+w4YcixTqpvorV4IbhYvD0P800Xov5bvnH83NEw87D1PwrUWCCiTAalZwVyh611lr4pPOm5SNO6slsQ7Dg0f4yRZq0OUjJ/1tN11mLQjmlRZg8UJS6RadmKN3LN214sYxBnjQO7t07fdl+oZ4iqsV8jO0GrkEIAE2Uh/y+31NVee1dQibEaVEaoUx60Ojzp3uYITKvbZEY2OCCxs6V5jyJGUOy47mSEZhpJoYcf05oeFMljZwWKeJ18Hu07OtvjdRr/mnoE+1LRyUitVLbY4G6aezGOk0tgqKtGOFkbXRNBmwkVsON/eAhOMAXorq6l14LKeiJ8pEWAFpS9OSOOT4PCfEhNAb0vIViC7dNRI3suVewtEU/EIANu1y0y/T4r1dtaPETsrYipze2jKDhw5jsOwmAVi0hvulISSfMrRUIXywJfkTOqcLWST8+7S6UREUA6M2zrRdOC/XCBPYfSM2DfocT2acfJQNgLYhc9+QsbWuVnJRCP1xw+iK+59g55wYRJZhwp4RTUltoh1vyjKGaR+CypUhhNrq00=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39850400004)(136003)(366004)(346002)(376002)(451199015)(36756003)(31686004)(86362001)(54906003)(38350700002)(966005)(38100700002)(316002)(6486002)(31696002)(6916009)(5660300002)(66556008)(66946007)(478600001)(6506007)(52116002)(6666004)(53546011)(7406005)(6512007)(26005)(8676002)(2906002)(7416002)(44832011)(8936002)(4326008)(186003)(83380400001)(2616005)(66476007)(41300700001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T3lLdHl1Rm51dnFPSmVVeE1ORk53V2hlbmgrN1BCVVZYYWxLM1ErWnVvYXJU?=
 =?utf-8?B?bm0rUFJKY0Vtcld1MkVUdDQ3VWxMUGhITHZVL0NJS0QyRTM5SFF0RHlSUzB4?=
 =?utf-8?B?Mk1HMTRLNFFOZ0d2UHZjYTR4eWVWWGNmdTlxNm8veHlKM01nT0tSRnQzUnZX?=
 =?utf-8?B?L3JWR0oyRjRtN1NYZ055YVhSQU10azRrbi9lektpa2lxd0FESUNHbVRHSmRB?=
 =?utf-8?B?endicXN1MGJxYjZPeGpQczVCN0E4Z0YvWG4ybWorUWFYVUdjUFRpenNqN2Mv?=
 =?utf-8?B?VmJDWTdGMm1VRjhBT1hYUHphYjhJVzM0QXF3SjFhNGZyRmt6MzhTbjZkbnlQ?=
 =?utf-8?B?WHdyQ1doajNqSklhYzEwZ21ROVNjc2Fwc1BtUjZGMkd0SHJ4NmM0L0F2S3dz?=
 =?utf-8?B?di9OVkxQWU8xSHJBVTJMRzJUdnRBdHFwUy9Fdnp3b2JwdEluVytnNEdudkFz?=
 =?utf-8?B?U3BNVWcyRXBGb3M2eUh6ZXhOcUk5bWZPK01XdXNiRmwxSHdzNWdCZU5GbUdO?=
 =?utf-8?B?V1JMMlpNcytVd2syL2xoZEZQSkZ6dE1tVExlZjZHaGtqYmd6UUNFZ1JqZ0l0?=
 =?utf-8?B?VDljVXYwMnA4NGF3bW1mVHluTjhJQWlDSUJaQmRCMmp3aHF1d29ibUw4TUJW?=
 =?utf-8?B?MFVyc0lEZDgzMjNZZ09rM0JENjhWNU4wNmtUK0R1M0FsNDE4OGFxZnhhRHMv?=
 =?utf-8?B?dFQwMWpDZ2ZqWTNhUU1RS2I5Y0lFZU9UM3BUTjRTWnQySzR1MVV0ZkpQby9I?=
 =?utf-8?B?dGorN2RsVzhXYjltdE4yeEl3VmRSVHlwb1BJdUdQSVMvdUQ0TThpMW4rTU54?=
 =?utf-8?B?dnFNMzgxVG1zNE5udmtMSWQ1dGtmMEdKWTZjaTBSWUlWQnJ4bDdGekp2eCsz?=
 =?utf-8?B?QTFicGNHOW5nWnRBb1kvQkYxTENVQ2VQS1dMMTJ1WEd2S1lQak9SV2Q5YWNr?=
 =?utf-8?B?dWpPeUs5NEd5WjFISDRPbFJjZmJpUFlVQi9aRlppZGNqaVNKa2M1dzBMMXho?=
 =?utf-8?B?ZWlVZjJYWDFEMURmS3czUXRXSWNVeEVrY3I1Nnh2TXZ1TDVkdmRnUTBUVmVm?=
 =?utf-8?B?ZkJRaFBHZndoZG1BM1pEQ0JiV2U4blhTb0w3eGord1h5NVJ2aGwxZ1lmdkZQ?=
 =?utf-8?B?OWV3TzRPYU5NNExXMWVrMk9uajVNVm5qSVBtQWU0dTYzR1FTaUloWlFuQ1hi?=
 =?utf-8?B?aXA3NzA2TmFHSHpvUld1dS9Wd2lza2RyYTZKa2p1dkZ0emwxQ1NuakEyVDdR?=
 =?utf-8?B?akVYNFkxWC82ZkF5WVZtNWtxOC94UFpmN0xKSnBybnIyd2RVbUoxVlF6YTJ6?=
 =?utf-8?B?U05VRlg1aWgwOGZrTERMRVhadmFsRVV6OE1wUEZrcVVLanhJV3EwOEc5U2Rx?=
 =?utf-8?B?TCt0OCtSd1RidWtabm5JTDhOS1d4ZE5sU1FEZFFadUprTjdWYUpIN2JTM1kv?=
 =?utf-8?B?Zm52aGFNVjY5eHEzUmZFc1ZER0hKVEFGQ1hKQUhqZG9FNWpYbDJEL05Ybklq?=
 =?utf-8?B?YVhKMUs3SGZySHZvWUVLSU15R0FhdzNUMk9ZVFJVdkRibDVyNE1Ma2pEZzNE?=
 =?utf-8?B?Y1hjS2l1bU1iMVdRUkZtVVRtRFE1YktQYm15Rzd0NXVhWFNuRTl5TGNXWnNj?=
 =?utf-8?B?UzN5QStETVptdzhHYU5mNkgyb1c0cXRVYjg3NjRYUjhjSWphMmh6clh3Njd2?=
 =?utf-8?B?SFA2UVU2NGdzWEY5TWVYQ2FmbmdOaXk4czRwNGRLeDMwQ2ZoSFJxaEhYSjZS?=
 =?utf-8?B?c1U3Z1h6OTVCT0w2YithcUtUUHdsdVkvUHJIeWhoNE9KSHJiTzV5VENLZmJp?=
 =?utf-8?B?OTZTcjZKRHFXNTExQStKYTJERkhBL1BIbStlcTh5WXp5OGg5aUpjNXFLL0Fs?=
 =?utf-8?B?UUhkbDhGWDhWUGNSWXRJd3J5ZTdOYUg3UldEVG40eDNvK01hRjMwM2NWMm1h?=
 =?utf-8?B?K0Jackt5LzNGTms5a0VvQ2FQVDdabGwwbU0wc3pwakJPdG1nbDdpcVZiMHZ3?=
 =?utf-8?B?OFlVeUVKMG1yUTJQV2FuK3NKSE8zNUVaMldpc3ROSkdKYUYxU3c4and0TURQ?=
 =?utf-8?B?ZkpsalhUQThDeVdWRWVzMlAyeWRIb1dXeG5SeHByVjJOWGF6S1dySUFKN294?=
 =?utf-8?B?UEIvUlNkV3lUYXMwUGhobzYydWRvUjlLNFM1SXI3WnJuejZqTnZVY3lTeCti?=
 =?utf-8?B?SGc9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 927e5b90-edf9-4316-50f9-08dac32ba1d7
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2022 14:55:39.5099
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vk1ERIu9ORf8Xt+IdXE1Rs9BT1H03wy+cIli4q24JG1Ayt7I4b5fDVpcq93gAqQ6f1qkOo/3O9enR/ZuUTB51g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR03MB8662
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/9/22 17:41, Vladimir Oltean wrote:
> On Thu, Nov 03, 2022 at 05:06:39PM -0400, Sean Anderson wrote:
>> Several (later) patches in this series cannot be applied until a stable
>> release has occured containing the dts updates.
> 
> New kernels must remain compatible with old device trees.

Well, this binding is not present in older device trees, so it needs to
be added before these patches can be applied. It also could be possible
to manually bind the driver using e.g. a helper function (like what is
done with lynx_pcs_create_on_bus). Of course this would be tricky,
because we would need to unbind any generic phy driver attached, but
avoid unbinding an existing Lynx PCS driver.

As I understand it, kernels must be compatible with device trees from a
few kernels before and after. There is not a permanent guarantee of
backwards compatibility (like userspace has) because otherwise we would
never be able to make internal changes (such as what is done in this
series). I have suggested deferring these patches until after an LTS
release as suggested by Rob last time [1].

--Sean

[1] https://lore.kernel.org/netdev/20220718194444.GA3377770-robh@kernel.org/
