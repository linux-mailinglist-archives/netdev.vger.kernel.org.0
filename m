Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17636598B50
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 20:37:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242720AbiHRShd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 14:37:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230492AbiHRShc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 14:37:32 -0400
Received: from EUR02-AM5-obe.outbound.protection.outlook.com (mail-eopbgr00060.outbound.protection.outlook.com [40.107.0.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CDA6CD51F;
        Thu, 18 Aug 2022 11:37:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J4cxCdH5hV2l0toTXJeyFWoa8dp08BskIz5goW5rGGpb6+uitzNqHEMuJZSjsM6oprotxLktashaEsVhdo2Tiu8PAPjmN46ThqtiHKuHGdtMTcGXraL4dL8EE5CMVte7mdaFzuNmXhKFUdj1E7BNWZ8z223EyB6739KlJOdFA8iNQCNnzOYodOMkCavSe4o0gsONXeB8N+C4cB4tEQr7K/6gvd6kh+DHqSOhaF+D4Pi16LAHqsPiQrIzjEQMwAiKqHGP6LhROJ4yu1VhI5i/bNSE2Jp/yneitoDEnflfzQeFK5DPEUkEkUKOj8mFXVXlcANJ7fsKQs8sM9OmZAMN9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B1EFixfy1IOhIVo0/lqU0dWmEHlSnAI+9ryc3zWq+p4=;
 b=PRzLYqkMhNQKshtVBZyZIsPNfd3wHt/RnwLyAo5gpQhb0aSkPuVO4NUJSo4cILC7vQrxryt5COnYr5GAAbYblkWJ6sGKetav/55fBCL8q7TtkqkY5vC7uheq2YOxbs3bv+xJSCYOaAaFDfNuB8+ZhkaIm6a7GSKdOiUUnxJ/gnlAxKhT9/lmlUvrVuvIC4WQOlXXl/bfvrxaEZsOO0GvaSxSb12sJ/iNH9FVOlZ/3yBj1YtXfDwYSp1D2ytbDVSm4wjM3OkgjNfzc8kDOWVKl8jMKR2qwkCyfMWUEPdw50VNhvmrOW1MyE7PzQHmDbCW2cCNz9fd4RlwTQA6wy4Gfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B1EFixfy1IOhIVo0/lqU0dWmEHlSnAI+9ryc3zWq+p4=;
 b=S2/T+5OzRFwW0XbHocd8B1JpPB2UVm0eh+rNyqcopYMv05IGuLtGoWVuhM4/HcCMrM2YvCGu16qqQ91h/y7LjDLpq1gGCK5+265LKkfVfTPWmqydMCWfm0uvRjMJvCJeT/r2gg44f2OZpstwb1UuEWKidN+P0Fk+LqXXjhCQnngEoR2vuHJeMv2ZMiSF78Q9db0Ab5HhW8pJUiYMaxERUnnm2pnpweFSrfPS/qCl89mZxdHVEnwWY0q1lfALSSogo9CI3Babyc/pICPrb0SfzAjb3rUJofXGqH3ecOG2gIKJrxfNPSCCGsyTz02DS1+Qt/TZbz3Oim93Wp/ap82RRA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by VI1PR03MB3600.eurprd03.prod.outlook.com (2603:10a6:803:2c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Thu, 18 Aug
 2022 18:37:26 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5504.019; Thu, 18 Aug 2022
 18:37:26 +0000
Subject: Re: [RESEND PATCH net-next v4 00/25] net: dpaa: Cleanups in
 preparation for phylink conversion
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Camelia Groza <camelia.groza@nxp.com>,
        open list <linux-kernel@vger.kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Li Yang <leoyang.li@nxp.com>, Rob Herring <robh+dt@kernel.org>,
        devicetree@vger.kernel.org
References: <20220818161649.2058728-1-sean.anderson@seco.com>
 <20220818112054.29cd77fb@kernel.org>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <f085609c-24c9-a9fb-e714-18ba7f3ef48a@seco.com>
Date:   Thu, 18 Aug 2022 14:37:23 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20220818112054.29cd77fb@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR20CA0005.namprd20.prod.outlook.com
 (2603:10b6:208:e8::18) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 32d9379b-8058-4dd3-dba1-08da8148b2d6
X-MS-TrafficTypeDiagnostic: VI1PR03MB3600:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2QcYFtLIcXzIjFYGv2htmFyHx5Im+1nZLEylGhF//iw8G/1J53XKfmtRkufGZEFoK4E6OMe9LqoA13dzwfEbyMG2xTq6oEeezoLs6Yj0+DhTp1xWedZJgKZ3hzmIxsDpzWWS7ImCJ4W6crf/JVnsDqjTv2i7FSfZUOGdvOVg+mP69HEsQjzNSrpDMGhAPnGSgqzeJd3v/Rw2I2QYefjwhUM6nQSXxuU6yDEwpToLXqVk3KNM9IyFErodzLrTDTaEZLs+dVjCcwyEJwuZbOh6gqtQlip0FwQTISY/gIiiZcNttidDvCLSLX8F2J7UO7xLCydEy6JPePsoZJHwyxcXHoNb/isUYuIPOkz3NoJn/stSp9nmfCxGRU5BhB9lSBT1+z3JETnfPyKbc2DltE7qGE5iKbhgTrDZTsRitkBNm1KJM45sYZQlxc/hVjUgrRvUI5j7684on74As+Mdu74fL2k949x9G1Mi1pKDEg696fJUeewiiBxCoyYnxKa9KH+QAKnbHamAYud9E0ByXOrTISEEPJ1o0eX3R7kodgkyCKEljw6B9TilIv+tpIFqhOkyT1KCT7mvlIPH2SWy+4y+1jYL/1IhJ3yiwekkq6k0C31yjreO51LidFoL2zyNs/YKj2MiMXWyGzBNRtwWyFNHlTyBkqRdi2R0TNmK0JSuCebTVZEtpiKhNcX9r3CMnhuBoed5+6Hea+DTbReD/a570bIPa+TnknR0VfQfADJtp9i6GE/HdSEt1lqT/Y83iH2LXOmRK2aLBP5d5cuOAGYyjbpwE8umku5tTY7fbBoF4ehyY/lxavsbWu8JA/T71Enu1ix0Fu7AwN13nPIYLI7pevUVeUmk+Bo7606QuzAYBrw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(136003)(376002)(39840400004)(396003)(346002)(316002)(8936002)(66476007)(6916009)(54906003)(31696002)(66556008)(4326008)(8676002)(66946007)(26005)(6512007)(6666004)(83380400001)(2616005)(53546011)(186003)(38100700002)(6486002)(478600001)(38350700002)(52116002)(6506007)(36756003)(41300700001)(966005)(2906002)(86362001)(5660300002)(7416002)(31686004)(44832011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S0NzNks4SEhibHZDaUZPZzZ1QXczU04zNmFJMzFDakk3akkzQU56cG5oYXpq?=
 =?utf-8?B?V2RXL2NGT3huZ0IxUDU5MmJic2tDQ1hvMmo5UFh6NGQvRHZDWXNpelVhS09p?=
 =?utf-8?B?YkxONjJsSDE0WXVLZmh2QVAwSy9IRmkycms2ZGF5NlVQQTdDTFZuTzFqT2xE?=
 =?utf-8?B?V3M4d1lybHVwNGxYaTcxbVpmNWl3MU0wTmEzbXhUZjZ2Z3pOd1k5MVBRRGZH?=
 =?utf-8?B?SWtoVHJTQ0N2UVJjWEdlNDByQ1BWblBJK0lkNFovQ1VLa2dHSGg3QkJwc3JR?=
 =?utf-8?B?NkdsdDluU1dzWUU1TllFVGk5enpUWTljMXBOOVZFalNUbTQzOEJaZEtXdElD?=
 =?utf-8?B?Q2ZSVzRzV1JtRDdDVWZodmc3MmZhVE5GVmFXRTRPK3EwemlkWmd1WlhLc2ow?=
 =?utf-8?B?VStoWHYrL0RSWCtTSG1yNCtHWllsbzV3aHJlOWRtanhVeTRpeTE0NVZvdVNY?=
 =?utf-8?B?VktZcWhHRHZocFlUd08vRzhKSTdkb2FJWk0rOGlxdWtqd2tvNWt1UjNPbjRI?=
 =?utf-8?B?RnlyYWhueGtEMzFCTi9lM292dHVBSGFyZEp6M3U2aTlubVp0NWU0MWVYVkRt?=
 =?utf-8?B?QlUzRnZCMEpyMTV0em9oc0d3YUtuZ2F1MTU1V21TYnV3b3hmZEtDZlVtWlFa?=
 =?utf-8?B?YjNTYUN0bzhFUndKNHVkcnhqY2lGd2J2NHN1UWYxTzhsazg4RzJYNEcwMnRr?=
 =?utf-8?B?dnJ5U2pEdWtYZGhaTHpGb1FrWVpIWGVXK3pkQXZRTE9oem5vOFhJY2ltRG5a?=
 =?utf-8?B?N3BtUnNaaS8wY0hZNFh0TDA4NnJTZm16d3pOMWExL3ozeUxjcE8rY2NtVHRI?=
 =?utf-8?B?cGpQNzZXeWlyakk4RjdTL1Q4QjZiK09ubHEyU0cyWENtU1hTTkdlNnEzYytR?=
 =?utf-8?B?UmIyU2VXNGVnSDl2VlExTHJLZUE3T2gyRExDdlk3VnZWMEZBTzY4K0RqQ0N5?=
 =?utf-8?B?d01jazA3NXNFUzJ4bWQ1ZHZseEtYSUtpMXZabEY3anBkUmQrVU5Mek9CcVZw?=
 =?utf-8?B?MVpOcnFjbS9NKzBoYmVUeXFHeDVPN2plT1g1WHQ4bzR4U0V3QVVYL0ZKeTRp?=
 =?utf-8?B?YVdsZFhMcytaZkR4cGxzeFBaRnR1NExWQlNZUEQrUStTTUhmNk1uWnVCL3hW?=
 =?utf-8?B?T3ZEVDJMbFgyelYrcFhOcmtXV0lqdENkVERERUowOFhvSGdydDZ5L3BackQv?=
 =?utf-8?B?QzFMZ2dNdnNpelZKUXZOSFEwVWliV0ZBL2s3ckZHMzhnUEFSNEFtVjRKSmho?=
 =?utf-8?B?Qm0zQ0hlY1VSSUxEbDBmWmx3eW94Wnd2YlRVWnBTKzI3MEJvUFNLdnRSK2pD?=
 =?utf-8?B?ZmQzTnZZM29zbG9uQS8xOC9oQlVrSHMrSXB1WUlFaFVzdHRpenowVDZKMk5i?=
 =?utf-8?B?LzdQTXJ3N1VtZ0oyYzcvNENQR1Z3UWEyakZFTm16NExUcmFwM0dSQ3NySHJl?=
 =?utf-8?B?SmJFYkgzU0lkWTJTZUJUaU9HYUdTNGUxZDZJU1ltaXVLWkh3WlhwTjRXaEhz?=
 =?utf-8?B?SjZQU2R5RWVHdGpPYTZJSHVkQytHSHFlUjdSb1dlR2doVTdoQUV1VzJ3VTRS?=
 =?utf-8?B?R1ozcGtsbEdJZXNDKzhuTDJyN2lsQjdlQTMvU2hBRDJjMlQvZStVRW9KM0hn?=
 =?utf-8?B?RnBBQ1JETHBDTitJeGZ4TDNMbWx5TWRvQzNadzdVaWh6em9BRlh3MjBkRlFM?=
 =?utf-8?B?bkM3d2JuSTZBQVFISGl4MjFIMkNucmRMUUtoZTJiT3BodTJodTRJZC9MZmR3?=
 =?utf-8?B?UjRPa051eWEzNnFEZWlTZVFwUjJJUkRXZlJuZFZiVVN5OXk1K2lIOVU4SmxQ?=
 =?utf-8?B?c2hiUTR5dVo0MGtYUTUrWCtuYURLTXd1bzBBRDRDbmpmWEZFelBFZGNDT3Y0?=
 =?utf-8?B?SnBnU3NiTEp2NElZSUY0cy9vUEVOcEN2UEhkaEc2YTJCSHkzMXQwNHdoVWFH?=
 =?utf-8?B?ajI3cndCd056RkpORWlJNS9hUDYxSEo0WFRWSDd3czF5SVdMdUxSMUZ5cUxW?=
 =?utf-8?B?WXZSbWVVUG4zTWlGNnB3Y3ZDUndFZUNBam1qKzVVeWJNL2RHNFkxR2E4ZGJD?=
 =?utf-8?B?SkJGUXRJLzlVMDVmM3JjSGZHUHl2STZWdTNtNHJtREVzNjEwVkV3UTRvbC9s?=
 =?utf-8?B?RTh2M0lvdC9adFNlRjRlZG9GSGhpK2JmVWhmK0MxRzRwMG9ZNFp1OTNPM0Zz?=
 =?utf-8?B?Y1E9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32d9379b-8058-4dd3-dba1-08da8148b2d6
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 18:37:26.5494
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Kduk6WBz3Ssn6k22LgmsiUZpEOU2xZApFgwexHerdHu/Nz/EifhJhZHzwvig58mewbMpgK2PIrUOkKi55mIs2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR03MB3600
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On 8/18/22 2:20 PM, Jakub Kicinski wrote:
> On Thu, 18 Aug 2022 12:16:24 -0400 Sean Anderson wrote:
>> This series contains several cleanup patches for dpaa/fman. While they
>> are intended to prepare for a phylink conversion, they stand on their
>> own. This series was originally submitted as part of [1].
> 
> Still over the limit of patches in a patch series, and looks pretty
> easy to chunk up. We review and apply patches in netdev in 1-3 days,
> it really is more efficient to post smaller series. 

Last time I offered to arbitrarily chunk things [1], but I did not receive
a response for 3 weeks.

> And with the other series you sent to the list we have nearly 50
> patches from you queued for review. I don't think this is reasonable,
> people reviewing this code are all volunteers trying to get their
> work done as well :(

These patches have been sent to the list in one form or another since
I first sent out an RFC for DPAA conversion back in June [2]. I have not
substantially modified any of them (although I did add a few more
since v2). It's not like I came up with these just now; I have been
seeking feedback on these series for 2-3 months so far. The only
reviews I have gotten were from Camelia Groza, who has provided some
helpful feedback.

--Sean

[1] https://lore.kernel.org/netdev/51c26e19-e4ea-7596-1147-7d95eec9e6a9@seco.com/
[2] https://lore.kernel.org/netdev/20220617203312.3799646-1-sean.anderson@seco.com/
