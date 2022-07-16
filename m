Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12144577204
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 00:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232017AbiGPWpK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 18:45:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbiGPWpJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 18:45:09 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70059.outbound.protection.outlook.com [40.107.7.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3759E183A4;
        Sat, 16 Jul 2022 15:45:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RMGZAoS5v74SAjNjqOQ0mVIAEWpVqDWS3FNrkIvwhfDBt+29RgwZP3DupCqB74vRrTBtJF7ZAqrAKEMzxebPxEdn6x+TSROOdyHDJiFTt1TrJik4hShOEav0PyD664sT8wzl7ts6hcZQy58e7nANPseMHxU8DkXSxwbLiSldLPCvjITZbs2DRFoKLvkCxV31QXfbUMOt+2BTYdnfjVklZHlpdTbylKOgC8G9aKedCuylGjAmkQ0/7D/fH0BhcPRIVbtOPMKlUErHG/oj+REXTloTTNTUcopuA+RU3cnu6jIPME352OGAahKeaYr7KAbVoOwwsbPBmZgQQj8AF0Xzvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aptsZaqiKOYH4yxZPl+TnTgIC+O8pInOG/P6Rza7lxo=;
 b=ieyWsoRXwBfhgN2KV0LY3oEzM5qYl9Bp9VDm6OGOKK9ni0wK0j0ly8DskINPKBB3g5dzS3J+ZQ/y3Qq5ev8iYdg66x3hjVPMZKzw5nBC8mB3UPqOqv39Rf45V5kRooDxCER2RmEj//zROtPjJP/NDsrcWTUvc7CHrAv32RkSh2ahNFRpKQjz0ag0816Af5HWtHpDOtwbGpvZVaR9/krj4kgYs6i5u0WjSkubiOMrIe2+yal5QCZWTIBaq/5VT2xvixrWfPl/g5yuBvvitPvaxNmRbKNXS4DsuN8/676Oh97f/cnrvaXDqhmirJrw6B5eMdlYT4tdPyCSPBvgXh+NdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aptsZaqiKOYH4yxZPl+TnTgIC+O8pInOG/P6Rza7lxo=;
 b=KOUkk0xsAaRWOxUYea9xmiO1bj6UNMdEBq8lJH30NWkd27DrWEojGqwE0fdVFdnwTsfe0OsbEVdXEp+Ij/DB/oQfmdkhynSnlz9xgZCkwhXDMkoprm3gZJt9pZTPysYrlfJEXtR9FHwt6Xt9E2HQBdzg3HyQXpDsbeHlwgF4bdYfKRD07/yaoVoPh6hdo4GE81G1rdGoRm2xyF8OYTL3qQ+4AhYcSl8ytQo2XqowKUfvvYWC1VDvuR+qqjuLTwpfkX1g5/ZYMtDE0i9Qv9htT+CMVIkFY7c2HmxaR80dY9d4tgIYHDRwYgcIaZO2W1oxyMyRYjJKUo4iV0rrfFDk4g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AM6PR03MB5541.eurprd03.prod.outlook.com (2603:10a6:20b:d9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.14; Sat, 16 Jul
 2022 22:45:05 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5438.022; Sat, 16 Jul 2022
 22:45:05 +0000
Subject: Re: [PATCH net-next v3 14/47] net: phy: aquantia: Add support for
 rate adaptation
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
 <20220715215954.1449214-15-sean.anderson@seco.com> <YtMFljr/I7UtSr+y@lunn.ch>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <55276de5-85dc-d668-e9db-b0b8248dd47d@seco.com>
Date:   Sat, 16 Jul 2022 18:45:01 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <YtMFljr/I7UtSr+y@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR15CA0030.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::43) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 959012f7-89d6-48ca-4b45-08da677cd3f7
X-MS-TrafficTypeDiagnostic: AM6PR03MB5541:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y/pHvhTmaKlTnDfzF/pb0ZOQePJvZ9jOE//9Vh3x8J0lB/KJxHh3PMuEUJGmam1PCjGn8h5geTRKqX934QdLHJI78igLpegRl1B68Dq8Rqab3Pw2uZYXFSODYvJNJ7jg/S9fNqBFQJqjfN0vkDgVU++ms16lB7vN9DKJjIakv9sibYJhdC6VWJcbVurtNJZM4YIrjOJb4OsWisT24mkc9cvTU1kev11wd1k37clDbyO8CDXAutS64QZD/xsKX7f0XhxRER0KNaL9ijA3s37+SrstYP9kB9FWtICpEzMG5pKacg3NkekzdUNBURmrR+2s58fDIKMO+32IPA72aBXGwshzSEaQ8m5WCOQWzSDqeNmVr1nktw0ktUGjWNAMmt1Kooxj3m86uRIpwYb7wFk5oGhJnLJQHDT1JkbAjWUPwSrZb661TnLrQHDr9QAJT4iYyoVOzOVlUslOaPYnh/ik0IaAibiPzKpXCr/UjQtnqM2qphD+N+KRrkWlmpHYvEibn/pcyWYQTmRcK4ijs/9m39zWAI8bQMVQGeycwNXyD67nzfM5B/BjPfTz4zRWZM0M0VODRcsueeAULrLSoLM7zPs42OYDwV4RsMUDgq5iRQlSFphTA3KHJxfvTIzbAXC6LnAdGDqjUhTBdFE3KV1okZerQIXEhVmuiDOMm1FWoRJ+UGgzzkzQGvavTy2KcOte09quge9JleoLbo7EAdkMlEISo9AxGvfVic9U81SCpo4yt1veIjy+bknPctAjtWtpuMonwzZ+Fa9fFj5vE6MCzvcbEi2EfEgh3bhq02LyEnfkHPTWJ+G952Q+NFcgDIYSECyy67U669rFkHG3HyIT6RNepI90ZvNis0tRhf5qA7vEa7ASI4GQWZixk7ac5YsM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(366004)(396003)(136003)(376002)(39840400004)(2616005)(26005)(6512007)(41300700001)(6486002)(8676002)(2906002)(6666004)(31696002)(86362001)(66556008)(66476007)(478600001)(53546011)(52116002)(6506007)(38100700002)(54906003)(6916009)(36756003)(4326008)(31686004)(316002)(66946007)(8936002)(44832011)(186003)(5660300002)(38350700002)(7416002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bnFIM2NFWDZxOTdFV2hvQWc2N002a0lOaElFTG5IaURyV1RBNkwwaGt4SVJ0?=
 =?utf-8?B?YUxhV1pjb000WnNLa25MaGhPSzFDRngxUVJ2YVZQNnQzQUZ2M3NtYzJzWjEv?=
 =?utf-8?B?QTF6ZjhnQ0hBY3B6ZWlobmxhUkZCMXBqZHVYWWtkT0VJaHFOZW5sWG9nelhG?=
 =?utf-8?B?ZlBIdkdWK2ltZXc2TVpkSTdlQ3c0RFV3Tk5PcmRjYUxVQWFJNWZJQXo4ZjZB?=
 =?utf-8?B?YXE0TWdBZlpxQ1pxeFB2U2NWejBwYU4rZzJrNW5UenV0dW1vWDRoL2lNVE9I?=
 =?utf-8?B?WFlFUHNxTEliZ0wwUSs0UCtXdGxrVndyVE9tUy9VMVMrR1YyakRiK1NvWnor?=
 =?utf-8?B?S0JqbmE2YlJ3ODhydnE2T2FtbW5IUXhWbnRnWjEzcTFqVk1DVXlhU215Q0Yw?=
 =?utf-8?B?L3orVmpmc2N4aUNBQUhiV3ZON2pjcitpa0JmVkhUckFrV0ZvWHQrUnE4Q0pX?=
 =?utf-8?B?czJoNDljNU5nVW41UlBmejlJanFmTXBiVmNEb3lpRmMwVkZtNHkxdkRwNzVN?=
 =?utf-8?B?NjVjd2cxSHVZUkRTb3BaWEt0ZDZRRzZDdzA0cUdzcm5ycE1BWU5iQmFjSG9H?=
 =?utf-8?B?RHI5UlN0ZXcrUExBVW5Oa0RUSkt2a2FpL09TWFdZVHFRTnIvbytOdWp0Y2Y4?=
 =?utf-8?B?VSszM0xBR0prOFd4MWNHV1B2bXRpdUlaZVFQNHZJRFRBc3R5WDk0ZElKOHpE?=
 =?utf-8?B?L3VrNUovRHQ2bC9HYmNCZFJqWElWL3kydWVUeHFWcXFNMlB5QVB4MmtJcnR5?=
 =?utf-8?B?VFJaS09mNGE2L1BqaVlYMTB2K2pmMUt6Z2EvRlVpTS8zRWU1MDZPQzNmQlB2?=
 =?utf-8?B?bkJiQjc0bFRQTmJ4WWxDTlhQcEZ3clk4RVlNa0I1V2tCUm5RdW9XRTVFS2xy?=
 =?utf-8?B?ZklwZVcyTWtpUHErN01lbnl4dk8reTNod1pCdUR2bytRNHBYbWEwNXpuMmxB?=
 =?utf-8?B?UVRZQnRFL0Y1bjhyTjdnaUJNZEl3RXVxYVF3MWRzbG1VbmRuL2xjYkZBZ0pG?=
 =?utf-8?B?S0lkWU93MzVGVGVXQjBDQTl6Q01uTnViRmlwcGx4Z05BMEVkTyt4MEhkanVR?=
 =?utf-8?B?Qk1sbkREQU9oYUVzVjlhLzRCTmZNbm9ULzlLSVc3eVZkOUlRQ0hWRjB6SVcr?=
 =?utf-8?B?d1U5YlFDQld6SURWT3ZGYkZPUXNldHkxU1NqT0Fqc2ttNEQ3NXUxQXkwSDI5?=
 =?utf-8?B?b3ptRGFsRk1jN2RCVFNQcndqRTNodGdyVHNLeUo0Z1NrNFpYdSszVFg4UWpk?=
 =?utf-8?B?VHh5eHRiaGxQMDUxU01OU00vS3JBY01CNjNGR0d5Q1VVRFJKVUl0b0hiMVgz?=
 =?utf-8?B?RG4xd3ZjaHRlZFN6dXVqbFl6TkZYSDNpSjVLNCs1dzBZME5TcS9DT25UbTR3?=
 =?utf-8?B?NEV4RFZtalJCNHV0R252SjB2cnptNlZkemhXZXNkcThjdlAxRHlJdkV2YlRw?=
 =?utf-8?B?WkZvcUlYeklNeDAxRkpPQ1hOYk5kM090RWZJNkFqZXVrWWZEMllMVCtUQ2Rz?=
 =?utf-8?B?Yzd0UEVxTU9hVENWMzhuT08zOXlvSm5RV3Zsd1Nxc1V5dzY2L2lpNms3Q3pw?=
 =?utf-8?B?SVQxK09YUDdPN3BSTTdPUDhBNUE4NEJRbVJ1SEhVV3ZINmw1Uk05Z3gxU3RW?=
 =?utf-8?B?cUFLbWM0ajU3M09JUTJIMjBJVXE4Y3dodGVoR21Db1Q2RWIvSHd1RDJCQlhB?=
 =?utf-8?B?amhjSHVPbEpzT0ZGZm5idFJTdnpSR3JSNTZvRGJGNnJYempkTzF6dVVHeU5E?=
 =?utf-8?B?NUZuSDFFUzNaSTZtbHJKK2hzM2xyNDk2RXBtOXh6aG5FbGhGZ1RFRlBvUFdl?=
 =?utf-8?B?cUxmQlNzbUNlWFhHTnlRWWg3K2ZhQ0lMRGE3OFZrVGlaMFRpWVRDcnllT2Nw?=
 =?utf-8?B?WkdudTdkS2srQlpYQnAxSlBYeHRCUG5JSUFGZExDWWltRjNPcmVjRHF2NzA3?=
 =?utf-8?B?c0NCVUtBRHFsUVI5Zm9nSy95Yk8yVU41UWxJdDdKRkg4bHVLLzlYMVJaM1Vo?=
 =?utf-8?B?Zytob0o0UVB6WW01Y3BmbjJqTW0wNWw5STlqZEJ1bm9aUlp5ODZHMmZCWkpo?=
 =?utf-8?B?NVZMeGxBV0RwVEo3M1p4RUp5amJ4R0IwMUdhelNFendWcDNObTh5bjFhTEZJ?=
 =?utf-8?Q?I7iVL9lQqBxXNaiWdDPtetASl?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 959012f7-89d6-48ca-4b45-08da677cd3f7
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2022 22:45:05.8182
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gCEkbwLDNYNauln10Gk5brMrF8DOOCK7onXnVwjEjc2RbyCb0mQpL2y5W3yYU8ICCU8o5QNgDg6zpue8ax4SUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR03MB5541
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/16/22 2:38 PM, Andrew Lunn wrote:
>> +#define VEND1_GLOBAL_CFG_10M			0x0310
>> +#define VEND1_GLOBAL_CFG_100M			0x031b
>> +#define VEND1_GLOBAL_CFG_1G			0x031c
>> +#define VEND1_GLOBAL_CFG_2_5G			0x031d
>> +#define VEND1_GLOBAL_CFG_5G			0x031e
>> +#define VEND1_GLOBAL_CFG_10G			0x031f
> 
> I completely read this wrong the first time... The common meaning of
> #defines line this is
> 
> VEND1_GLOBAL_CFG_ is the register and what follows indicates some bits
> in the register.
> 
> However, this is not true here, these are all registers. Maybe add
> _REG to the end? It makes them different to other defines for
> registers, but if i parsed it wrong, probably other will as well?

How about a comment like

/* The following registers all have similar layouts; first the registers... */
#define VEND1_GLOBAL_CFG_10M				0x0310
...
/* ... and now the fields */
#define VEND1_GLOBAL_CFG_RATE_ADAPT			GENMASK(8, 7)

>>   static int aqr107_read_rate(struct phy_device *phydev)
>>   {
>>   	int val;
>> +	u32 config_reg;
> 
> Revere Christmass tree. config_reg should be first.

OK

--Sean

