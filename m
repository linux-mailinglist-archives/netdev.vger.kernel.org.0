Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67D10598A77
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 19:33:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344598AbiHRRcx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 13:32:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344625AbiHRRcr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 13:32:47 -0400
Received: from EUR02-AM5-obe.outbound.protection.outlook.com (mail-eopbgr00055.outbound.protection.outlook.com [40.107.0.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4EBBB775C;
        Thu, 18 Aug 2022 10:32:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RyAmglwF4eCkW+vxaDwf60rpVYc6YA8nJnu44xJNPyOWB9zMCV99wyEyoJxn3eU0mXeKmqN8MZxovby455D/2qyIMl26OHm0OGLWl1SNb5i2eux4LfV5zTzbVCitfS1C74mThwOgwgZ2I00tIf1t3U6hBU5M0FXQnW1qkpfzckrRZjdP/mMKpdOECCVcMa5y2FSyi+bWkzNi8OzhKYvibmXuZovuQK8dgzWtIFDlZF2jx/Wqw8zDisLCMhuZUIQiG2ww2Cx9wgLv3rgpzInaPIMzlu7oN+EjiVj8Jh8tFRWRiYQq+pUcGYdmYY5tYTX8FumpmIa4liphUM3bizwIng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qzAAflF626WDx3wq/osNVkhQie8jsmxlsUueeozBpBg=;
 b=eB7ICuGPoQxx7zACEaax7m7jNNqWIjldwREdpGsKEZxIenFjtNyAIF+idUWMYArImz+n3mDm2tOLTWGvkejyQ4bUC7zWGfgbmQRDsfXSfX4Vw9MecKq1pxdpIY4vYOaVpepuO/ZaCjUl7ksG7YHuzZ1JyYvT3IreVK6kE14iS67vm9TPbSDj1u1GxQtFoXIu2wh1k5qQjEOnEdynmd1FPzLwHpJqtGjK872ETmVlnXo4r/nuigaYX3wMI8Lta9LquID1wKkreGTeE28vrFim/yP5WqC7ycv+nR3N+nF1fdbfTGslanO8Mjv3fpwf+KCBunipiHKQEwfztkCiv455NA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qzAAflF626WDx3wq/osNVkhQie8jsmxlsUueeozBpBg=;
 b=kPIi3+obqaxeRaBZ1erJx+BvxWzfj1ZUB+rmmKIa6XqS29FnAkkBPmComqwC/rigMJyahnvS8U3dqxXLbQ3HP3yasTWAqp0vT89YjUOuCkMefZqty0zUnMcbh0yPw6WPxVWOM2CWNhw1AZyJRMLW5Z3XsWokirDgqFLzSPS/4ym117Yi1A9vwXlqZreVGPw0SnnO0lhV6OpcjieeYMmuwlE0skved8HuC7lJvDtBHxoL+dbhYR/1BwqA7baSLjYYv8uvURa1jJtTfAZjG8eD/PHhihNtd7yH3/iw7romM1VpPxdm1zgZm1YbT3ACs4fWMnuPqqmZeJ9QhCClKlnjnw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by VI1PR0301MB2495.eurprd03.prod.outlook.com (2603:10a6:800:6f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Thu, 18 Aug
 2022 17:32:41 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5504.019; Thu, 18 Aug 2022
 17:32:40 +0000
Subject: Re: [PATCH net] net: phy: Warn if phy is attached when removing
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Vladimir Oltean <olteanv@gmail.com>
References: <20220816163701.1578850-1-sean.anderson@seco.com>
 <20220818102443.4c7c50e8@kernel.org>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <ffc5114e-07c4-7154-b643-01dd86cbc4c2@seco.com>
Date:   Thu, 18 Aug 2022 13:32:36 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20220818102443.4c7c50e8@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0013.namprd13.prod.outlook.com
 (2603:10b6:208:256::18) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 107ac566-da9d-4d36-ab90-08da813fa682
X-MS-TrafficTypeDiagnostic: VI1PR0301MB2495:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AXic9uqTQdgr5rHrOITHL7BCN0H/kw0F1wnRIos/ldwKEao7hyJWnsgsz3tpFTRCZOOB8fpXtig7dgBrlGnfzIeCiMMG3l4YjeXMzD562kgbd4tuBlczflRXAQTv6iP3aeDDLzo5EO0nJ9eHLoqNFW1PCOS2uDTmom8VGO5EmkF15LBmpPLdinW6P/iwtlv2z1ba7XqB/5Qk2AliS+0y0K+qevXXQ2QzLY/MTsnf7u/ybSW4tjO0pQJjcYhnGw7xLnUf14uprQwELRh2GA7lQlVECrwvytP2m0S9v+krFTYXVlhxLRZTq+OJ4LFUwnISqesbIXnKuuLmZh+Pv9ESSFEFZ32w3fulWWimN1kL/fv6cSRRmekgAKhzNfKeuMsttdBI4ViqN1Kd0ymnr2jxTBf+Y1vNdXTQN/2+xoxMyx+6P8V8KcH2xC5Ywd6l0i7qqAJfhzjoWtfA1OwDpTJGnbMfenqsBem7NI7udd+q0cVYk8L6gklQ4fhHVU8Ic3vMx6N8NEgLdqLX6h7By8Tb5hvUm2fKojaXQVtwDoTHYYzEiboSEmESVIWiNjnk5ZNEyi/MMKUxNEgeP1Ij2eIlk5fW+iRuXJ82KGWaZOMA5ZK0lC4a5cQ7QWrEB/wWzP3kcT33vEF20CQJ2P1eGkM3ppLLOQj1dV5dRbkkqgWwlD/q5kIsD13KotjKfR0sSviWwQD1T44hK8hPrDhquN8KAQmVWPJEwNYvwacn7ncthqJE1nkbeGRMdrSUiLTo1F7u/VMr8Pzgu9a1TpJ7blit+qzvyzzC5UfOynmoVlSfuOGXiSolpLH9tp3LecrvrISIYGL0Ut8uS3IdRXATzTOwQg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(376002)(346002)(136003)(39840400004)(366004)(52116002)(54906003)(6486002)(53546011)(6916009)(5660300002)(316002)(31696002)(66476007)(66556008)(31686004)(66946007)(8676002)(7416002)(44832011)(86362001)(8936002)(4326008)(36756003)(478600001)(83380400001)(2616005)(2906002)(41300700001)(6506007)(6512007)(26005)(186003)(6666004)(38100700002)(38350700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TkZBSjg0UnB6d2gvdm8rekwyMGhpeERJSnpLdWNNeVh1bG5CTDVGKzNEM2Nt?=
 =?utf-8?B?MlU2OStRVDAzNXFtN0tmdDRCckFrR0dOVDdrZzZpSFBqMU5Fa3Jwa0c2WXND?=
 =?utf-8?B?ZXc5dXk0MGhSMmZwbSt4ZCt1MXpUUEg3RkN3aU9aRmpia0NWV1RtazNlTFBR?=
 =?utf-8?B?MzZxdDlNc3R5NXNhN1BtMEtldmIvVWU4SFNFYWhMRG1Ia2xGemF0ajNNUVk5?=
 =?utf-8?B?U2pKeE9nOWdKUW9CaVlXbXB3dk00dVJlQnhlaUp5Z3RXSExxT25DMGU3eTNo?=
 =?utf-8?B?Ymg0SUphajB5dUdpN014cHlBWGxycHppQytReTRDK0lmbmUyTllSYUtpVWFj?=
 =?utf-8?B?T0svTjRrRTd0MG13T2FWdHJQQnp3WEV6N2IwRDBwbGc4N0JJSTE5MGJxUkpC?=
 =?utf-8?B?N1hYOVRqcWhuTkxVdllDamYwT1p6M2F1Z2VHNjJ4NHJocnlzSTNiMmJPWmJo?=
 =?utf-8?B?L3UvM3RFei9DNllpNytBekx1N1VZWUFKTWVDUXlmVFlZcWN6ZENPMTJmY2Yr?=
 =?utf-8?B?Y0RhODlHdFhqZEhWWUhDRS9rRlJPc0dUZ1R3TTJJQlhvUGoweTVCbDlrN2lF?=
 =?utf-8?B?UmdsSkZmL2lQMGNmL0MwRWZUZFRKcSsxQXVJeFFLTnlkYUJDdUNMTjA2Wk1K?=
 =?utf-8?B?ZWh2bHNKSUdzNzI0MFUvUVFxWjZkeFdTNFVGS3hpd2k1SDZwSEc2UXU3bkVu?=
 =?utf-8?B?RW1aQ1JTSVZvTE1JZVBkZkE0azVUMklRTFZPc3NNU3hmREx5YUd1Q3pwSHNF?=
 =?utf-8?B?Y0RFMTczMG5zcHQ0UEIya25QcTQ4NnNjeUVsdW5Db1VDVnhRRlc2QjJ1eVAy?=
 =?utf-8?B?cWE3NElwSGJXRXo2dHJjY1Y1SSttQ2VIaVBGU21keVV4OXlSU2tqa3h5Tlgw?=
 =?utf-8?B?ZVJpR0xyaW1FUmoxQ3o2SlYvbHFnTHNXZnh0eGc1eWljalhNam9wNUJEbmxv?=
 =?utf-8?B?bmpyUzFLVkxIQkhlVGdGcUw5eXg3NlBFaDVZdjVPbkYxK1pJZ2lwWDFqNW4y?=
 =?utf-8?B?aFRiVlkzSkJmOVM1Q04xODFXeU1zNmt3NjRBWHRMRDRiSXpGamUrWDFQQk05?=
 =?utf-8?B?eHoyTFZqQWloM0s5elhVRExtbVFTeFJGeEgrb0FQWHpBcCt0Tyt4NUZPWE1a?=
 =?utf-8?B?eXNzMjRjOE5SOUExYzNJOEdLTXRhN1F4Vkx5Vlp1MVlCMVBZTU81V21zbmFM?=
 =?utf-8?B?dHBmLytyKzZ5UlRqalBsVVhvL01GYnQvbE1XdUFuZkdCV29lVlV2NC8ycFph?=
 =?utf-8?B?aWZzNERtMEgvclRqMkJBMzNlZ3BjVkREcVBVSGs1em1ubUc3ZHlsSGhxUXo1?=
 =?utf-8?B?d0xZVDdLSFBlWEppWHJMVzVWR2k0blR6TWw4bWJQaE1jVms5UnljeEt4MmtE?=
 =?utf-8?B?bElydHNRRHg5MW51NStSME9qK2pweXg1SmdUZ1kwRDBoLzUxU1VTcVBOR0Ni?=
 =?utf-8?B?Zmt1M3pLTk1Lcm11QzM3Zno5Q1BuSGxuZUwxekpoRGFYenM2T01Cc1YwNjVR?=
 =?utf-8?B?a0F4MkZhK0Z4NmlFT3BlZjNYckJhbFZrci9zWm85aWEwSWg3WTRVV3FlSXVi?=
 =?utf-8?B?YkdkVGtFVEVWQVFWeDRXZk10cEpDNTZTMXQ4OTQ0MEk3TlNEYnBqRlBVWFV5?=
 =?utf-8?B?MkVva3Q2T3M5WEUvV2dUbjNwY1BYSmRoaUM1UFM2eVVKc09QTjM4QWRWSm5E?=
 =?utf-8?B?NTNtNkhCNVYzekwyQytpVTQ4Wm5zVjA2U0kwRHBqWDRhcVRIZm1vUnNVd2tZ?=
 =?utf-8?B?ZU1CaHQ3dmtTOXFJRlNiWUliMXZSTWFrWVdVZUpSZ09YWnczWjIvNjUvNVNt?=
 =?utf-8?B?Mm0xc3dxTWVPZVA4Yi9uMUpramxvNkhyclBwb0hTV1RKZ2wzWjJvTndqeDhs?=
 =?utf-8?B?dy9HdFZlNEN5ZzAyY24xbVF5cDhUTkJ5eU9TZE1tdllkVDA3bXlLd0w4K1RQ?=
 =?utf-8?B?dDNFakptdTduampEdzFDOUJrdml4TnczOXlCYnlzNnUxZElKSUpmTnNuZWx2?=
 =?utf-8?B?Tm14WWRHR0pnc2I0S3dGUk5HOTBvTnNVaHErd2NhKzcxUS9FTE9JV2VoNWdN?=
 =?utf-8?B?TXo2aXpBWWdyajJVa2laT3haTk9jc2wrNDgrWTVqOFduTENhRFIxYjdBcWFm?=
 =?utf-8?B?V2F4NTdUY1J2a1FxcXBpd2NJZ2JOWjArc2oxZFJENVBiOFNyYzFFY0dkTXFD?=
 =?utf-8?B?Unc9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 107ac566-da9d-4d36-ab90-08da813fa682
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 17:32:40.3788
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ji23bOuJ6NXr4m2gdsGZ1rGE9va53mQOE/lCGQxHsENG6/zVW94vGBnEcECO8ITjhYwv8i2qXqTCszB3toP98A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0301MB2495
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/18/22 1:24 PM, Jakub Kicinski wrote:
> On Tue, 16 Aug 2022 12:37:01 -0400 Sean Anderson wrote:
>> netdevs using phylib can be oopsed from userspace in the following
>> manner:
>> 
>> $ ip link set $iface up
>> $ echo $(basename $(readlink /sys/class/net/$iface/phydev)) > \
>>       /sys/class/net/$iface/phydev/driver/unbind
>> $ ip link set $iface down
>> 
>> However, the traceback provided is a bit too late, since it does not
>> capture the root of the problem (unbinding the driver). It's also
>> possible that the memory has been reallocated if sufficient time passes
>> between when the phy is detached and when the netdev touches the phy
>> (which could result in silent memory corruption). Add a warning at the
>> source of the problem. A future patch could make this more robust by
>> calling dev_close.
> 
> Hm, so we're adding the warning to get more detailed reports "from the
> field"? Guess we've all done that, so fair.

My suspicion is that this case never occurs, since users don't expect to
be able to remove the phy while the interface is running (and so don't
attempt it). If we do end up getting reports of this bug, then we will
need to create a more robust fix. My intention is to take the same
strategy for PCS devices as whatever we do here, since the issue is
analogous.

--Sean
