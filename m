Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF2E057CF33
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 17:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbiGUPel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 11:34:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231854AbiGUPe2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 11:34:28 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2057.outbound.protection.outlook.com [40.107.21.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0092D820EC;
        Thu, 21 Jul 2022 08:33:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z7l9srlmmhMhyTOM/NpTPgSQtGWigyOPC9LZtlNk1vvVCYjwh4FXuNUgW1gibcVABUhEG0MsK0lkwbA68zmFzwIA7Io2TIXjkAEJbB4ykitpB3dFl89qM3/b9Vcmz46RNZ5E54pVXFVKRk+WTdGWW1BOUk89GM0QCuPqwmxHe61yu86yd4o20h3zYxmYz+jE1mLCYUag8QYoAHYq3Vr0kC9b8HNyh+z/oIluAT6FaHJJU3TxqGS/SIfkJLjRsWcGW7SPK8rkJ4euPLUUQ2Q0gQ8I60FfwXvDmfVIiKA8yaJ3z1cQTqNGD5wiklD7FWgYU3qhHZ0QCPOyM1rYl4+XAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e7tzAyokbxFM72NPtzv0wdvPJ+QW0M7MBE1TuQR7IkY=;
 b=n4s2Hg0YGo7wzkiM6K6egc/eHpL22oaLbN3I+YB2TCYdG6h9ulVKjsoCCteveiAXcsGgR8h4p8hIP7oN3WmoaGGJmCRJvDANevXy+riaqjgcew35FcGpFcYO+yzO673vLUy5X4hfhhlgeJcXqITNE4oPedWY3hsyBMHkXA1Da4gY5LajqhUPRRh82nc53XED/90wszSGMyVM48jHOuCFCw3nlFXGHQ235/KWJcQGFfU9rdPnvstDSg/TZzZfhaFRAGUbV6vRipSzcnZdr2lSQIx8r3k7BNyHV9BHdbDpfi9YsLYhnxQzbeD6frGxSe3J54PDE2y9LzT3yZi7+I4A5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e7tzAyokbxFM72NPtzv0wdvPJ+QW0M7MBE1TuQR7IkY=;
 b=wVGhlNYwlNEdA8rzxNOz+zyeZN0AnRsRYf4JCyjFIgLrWcEhQwS/SNDHcUdsA+tKs5uRxyo0AJxRZV3piqqpGBd0ZRkBy9YkbcA2cI9lXmz/XeXhp8Epn4FHT0GveQf9imTvR74Oq/uI6hHhZAM+u9WaM6fGel5B7Xan6hOttQv8kW4LjgSdYUtj52+l/RZup8rhOgBOwTWL2EzV2ovgSvaREQpIT7nrE7Rka2k8ejCKn3ZeuzIHB/NEj/yC1che+yD4uzp7UfXP8g78UR4ThwjioyI1V94yqGDATfR2KoF4oa+mXjqI73iy9iRUtPdL3UDh5tkmkqYGLotvkQqoMg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB7PR03MB4076.eurprd03.prod.outlook.com (2603:10a6:5:36::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Thu, 21 Jul
 2022 15:33:38 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b%4]) with mapi id 15.20.5458.018; Thu, 21 Jul 2022
 15:33:38 +0000
Subject: Re: [PATCH net-next v3 27/47] net: fman: Inline several functions
 into initialization
To:     Camelia Alexandra Groza <camelia.groza@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@armlinux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
 <20220715215954.1449214-28-sean.anderson@seco.com>
 <VI1PR04MB580732B9CE46E1099C56B2A9F2919@VI1PR04MB5807.eurprd04.prod.outlook.com>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <1f35b2b9-107b-0755-e083-d8988c9fb673@seco.com>
Date:   Thu, 21 Jul 2022 11:33:34 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <VI1PR04MB580732B9CE46E1099C56B2A9F2919@VI1PR04MB5807.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0285.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::20) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3aee0789-823d-4666-875f-08da6b2e61e1
X-MS-TrafficTypeDiagnostic: DB7PR03MB4076:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZIGIQszvrYoEA0VJFWQrjbX21ZO0h+YKL01Mw8aW/NAirC1P/Yi1LaBvSRpQAS5RRZvJMgmr5TMcRRUA0C3hqHb+7/pNIdgqqgOQTrR2Gyep2Y+h0nyGBYyDa4qJx5VCTTeIHzg4Oqd5M36QqA2RDqM2htV9A+bVWRx/Kl5X9CdPDelh6HeteLQDg+36jlfATkEAjVeLTWD45Tg2UEMg+wZhsvU7Kt9vXWlp5FaQBYdSiV4+Nd+ZeanN5sD3Z8hPR4lksLeUbG8U7X8cKMrOjFWhWCnCHddXAAqqIkKrpjvLzr1iv6S+3n95N0MpgVGDajnqfILrFPqKojLlJIL8X8s7MM7gEEOxuZBBPtEDCU9riS64YTICNPGBw1Sff3W3x/UQ6ryzUCZiJx8k9kRD3mww9Rrz7XE/xvBTyGwnfmgSR5gL59K3ikAWLO6LJosnhfGGUPC8UHbOdma4TBsgbzhdkfhkEKSAm+XiFYE3DYAlY6lgtExqm3KpdDDsEiTBh4c9wg9L3CktgkH5MQZhffkLPHmAsBzcLh4+HDQva4oMV7TepELrEjx8mEYIvKY7DD4gaQ/RZo+5HDNcZslkb9U0oYAGDduL+RafT3f24cXVgz8wcbmLswKWufHUoQsMKfUDSTJyDhlP0EnlPokU60dX5V14+jFuJDaDMdnchyZCjXPn93Jr3/HEltOukh6lFufynp1rKzznB15nU50kDg4sh8ui86lDK8HVLCuCP0iGK1EPYjR9BCSts8+aUjjb0hczWy7d3TBWOa46OIBMK+BGi3zpRvo8l5Ci3h4TRINOTvFC8Q2rpLEfYpu4Ab1BDME9QOJO9sGoF9WTof20k61snHwNqhuiYTyOyAiPQz4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(396003)(346002)(376002)(39850400004)(366004)(86362001)(31696002)(83380400001)(38350700002)(38100700002)(4326008)(8676002)(66476007)(66946007)(66556008)(316002)(54906003)(52116002)(6512007)(44832011)(53546011)(5660300002)(26005)(6506007)(6666004)(8936002)(2906002)(36756003)(2616005)(41300700001)(110136005)(186003)(6486002)(31686004)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bzd6a0J4Rk9CdHhuY2NwRmdFcDhUUDVNTlhyNUlqTWkzaGRqQUQvYmlKNEdY?=
 =?utf-8?B?aDFRa1kyVVdoMU5wUWMzOXpGWFNFSVZYWTRVVmJjS3RyS0REaXIzSGNPRkdm?=
 =?utf-8?B?dnlVaDlLbVRsYlNRSzRTOGJIQWlaR3pzOFZubGdyNVZSWlpnWWZJaVNTQ2to?=
 =?utf-8?B?dkNIMWc1b1RZbTZPL20xMFM3RFZBN0xhZ2w5ODBwM2NlRFphQ1Nzdyt5Z1di?=
 =?utf-8?B?eW4yNTYwYWlYV2k4RWxkaFZFbUI3MFBCcXVJS3Z2WnVNWXRpb1NoendFR3Fo?=
 =?utf-8?B?eUt4NkpMRUtONno5dENqNjZOdS8waHhyMzRvUEErb084UDJOUDBKTXh1SG5w?=
 =?utf-8?B?QkRpRCszVGVqcmFXNStjTjQ3Y25LanJGbXQzMmVDQlR1d1NjSW9lT0dIREpV?=
 =?utf-8?B?WHNic1ZEbEdKd3l4VVJOdmgyMFJwZ1JvVlFQL0U1dlNJRlVHOXYybUZjSlpr?=
 =?utf-8?B?Ylo5YTVWeHZRQjR1REk2L2pWTTFUN1FrbmhjcDR3YVExanRoL1ZnRXEzK2NO?=
 =?utf-8?B?cjd2WUFmYnd4RVU3UmFISGorWnB3L3BtaHZNbm5HaUpDMjVmUDh0YkxWMGtI?=
 =?utf-8?B?QTcwS1loblFjNEFrckpGaDVZRE9QamtscXU2R3duLzNBU01CSk1PT2xVcjFn?=
 =?utf-8?B?TDlqeUVKdUlOYkFqTzAyYWhOcVVTaXlOcm9kZmU2STUyNWpQZ3Zud2NPWUx4?=
 =?utf-8?B?MHRMMjFHTXU3Mzl6OEVSUE9iY3M1Tkx4ZG1VdkNQNS96T2ZBQjVISEhxTVZn?=
 =?utf-8?B?Q1BwKzByRkl6b3k1T2ZuK2dzREpHQnM1bGxKNWZSSGhiQVJNenRxN2ttZHA5?=
 =?utf-8?B?d0JBUk9QWXVxYnlrUHRTblpBSmVGbzM0dm5rUUFMMkZUaTllM1ozOVNzcUpN?=
 =?utf-8?B?Mm51RUZCZGhxSG5XNDZPeXF0UnFHaDZBTnRWRjN1L3owUWpPK2VYUExQbndQ?=
 =?utf-8?B?ZXZuZm1kQ3dqdFptRTlzZEZzZ1prTVZTUWhKQncxRkhiNXpNeWpySlBzdExD?=
 =?utf-8?B?eWcvNHpQS1pzamoraDg0aFFGL1orc1RzbDZGbEVCcVdYWEpyLzNIODlyejlm?=
 =?utf-8?B?Qm9MSmN6Mk5QN2JnOHZFVHNaL2FxTVh0RVFiN0JhK0pqSkEyT1VuQ3V3ZHBv?=
 =?utf-8?B?U0hnMXZtTHZlcnNLdnlScFhxTm9WaFdoOHhVZldDU1VNVEp0NVFtQXdYdFNo?=
 =?utf-8?B?V1pENU1IUURPQWZpUGlLZEthUm41QnJjTDRxcFBleFJSeWorRnVVYnp6UnpT?=
 =?utf-8?B?ekVYV1VKY2IyYkJ3cWVpTlEyR1U2OG1COXRMUWFUTUVYelBwVEFrZXJDNzFJ?=
 =?utf-8?B?MmVZTjhZN3Y2Q0Rod1cvejRyZUNRd1hSZWIrdmtCUEZMcE9veEJibVhKV1RS?=
 =?utf-8?B?S2xzcWdjaHFCYnYwZWptbS9RUUR4RnpSWjliU2lKV1E5ZTRjMDBJZnlDak9H?=
 =?utf-8?B?dEpTcUxpd3hqUHFxR004ckFrckpYeEI4MHZ3aSs1aXp0QUE5VllMMUpYbHY1?=
 =?utf-8?B?M0lBMDZhcVRwQk04U3FtYUYvZ2pGQ1M2QmZMS0hKck0rZGRKV093bWdpSUM3?=
 =?utf-8?B?WE1pcC9lNmMzdUV4QkVzc1JTOEtqOTJNUWhPQ2lqYkViSlA5akI5Wm1sZkRL?=
 =?utf-8?B?WXFXNDRVRDZxRUw3d1psZHhXdFdqanJsdk1oSnVpejhodWM4eDV1bG93bDdB?=
 =?utf-8?B?ZW9OZVQ4YTNmMDNYM0R4WTRISW9IMU1aWkFQK0VoMSthYjNNcUZaYkJ4VTJR?=
 =?utf-8?B?K0JJZXd6NEoxelplVW5TSFUyUkhJWFVZaG5oQkUwNVpnN0R5aytKWlF0VVFO?=
 =?utf-8?B?d1JaVFNuRi9hNHB3ZnRjTElxc25QZ0RSZEhMN1U2WFpaZlBZeTdmRFliQzJp?=
 =?utf-8?B?dVBUZmlPUDJ2MDNGRFF1RlZnenVpNGJUbHFNZDlWcWZtbU14OXNTaVFOZDZZ?=
 =?utf-8?B?ektNYmI1MkhZVlp5Ull5SllwRG5jWWR0dnR4amErSDdET0xTZnVlREJBUWdX?=
 =?utf-8?B?N0F2V3VVTmM2bFBtM3QyZjd2L0prWUVHQVV0OUxDTFptT0lrOWd1YnY5eTRG?=
 =?utf-8?B?QnlRbkRDRCtEK3J0a2VOaHhZbEowaWlxbjBRNmIrN1VySURocWJNZXZMYW9p?=
 =?utf-8?B?bWprM1NsRFNZdGJ4UEdhUW1ZWnFBWGdISS9EeVlBcDM1SW5TM3pVN0p4MVZO?=
 =?utf-8?B?OHc9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3aee0789-823d-4666-875f-08da6b2e61e1
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2022 15:33:38.2902
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zxk3J08cIt9MIluU/yJWF+2NycrKySEYRAtNxataxRiZKxiO7SQySgCL86Ggo4yW8+ACWHI9VZq1ux6Zrx9DbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB4076
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/21/22 9:01 AM, Camelia Alexandra Groza wrote:
>> -----Original Message-----
>> From: Sean Anderson <sean.anderson@seco.com>
>> Sent: Saturday, July 16, 2022 1:00
>> To: David S . Miller <davem@davemloft.net>; Jakub Kicinski
>> <kuba@kernel.org>; Madalin Bucur <madalin.bucur@nxp.com>;
>> netdev@vger.kernel.org
>> Cc: Paolo Abeni <pabeni@redhat.com>; Eric Dumazet
>> <edumazet@google.com>; linux-arm-kernel@lists.infradead.org; Russell
>> King <linux@armlinux.org.uk>; linux-kernel@vger.kernel.org; Sean Anderson
>> <sean.anderson@seco.com>
>> Subject: [PATCH net-next v3 27/47] net: fman: Inline several functions into
>> initialization
>> 
>> There are several small functions which weer only necessary because the
> 
> *were* typo.

Hm, I thought commit messages were supposed to be written as if the patch hadn't
yet been applied (e.g. the current state as the patch is reviewed).

--Sean

>> initialization functions didn't have access to the mac private data. Now
>> that they do, just do things directly.
>> 
>> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> 
> Acked-by: Camelia Groza <camelia.groza@nxp.com>
>
