Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B27C598C68
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 21:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344770AbiHRTOQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 15:14:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbiHRTOO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 15:14:14 -0400
Received: from EUR02-AM5-obe.outbound.protection.outlook.com (mail-eopbgr00054.outbound.protection.outlook.com [40.107.0.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F28779D8E8;
        Thu, 18 Aug 2022 12:14:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AxDjzAvF28C+n61exVktol3pmTp04nDQE/e0U21G+QyCD1pVx+XVNmm3esKFW6olOb7i0oU84YxBcxu5de1FikMkcfCMZwFZ/eF8byNNeUiyAGxD7DOmnnb8tarzqJFhZnBzlPLW1rdEYbc0g67EOJBzNtQmWu52l88FLbEU7iuXRdCoX8SF0azrCEo/cip7jL+RQ5OcHkyDpaTOMAxGfFlHmhvC5AA3KtS1t8xxK9+rID+613b0YlicaB6zXwLx7dNNELoznPasQtxm2hgzSVum5lRsIjhhAocqWu3lGpPS1wY3FIW7BDs4z+kSX9YrXyFkBDsKYk3j+B+emV6NhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vTsJ1qBp7xwJbwWFD/O74p2WjaKdCCHDUR9XtHvG1bg=;
 b=ZBbPom4tnnj7Y+BIrhFhl+9Fs8Pl38pZBdrlMiq44J6OZ6h8lfZRlFz9/DlP5442IsismTK41bETAe2TSNTa8jFQaoh3B/xDTyjhECS2jSo5p3I3MOmZWZdoqZLLLtPweOVneG7u+5vS5y8kIfBLsH4vXA3Mk77LuGWdVoViVFz168SNol/BorFSDvIbElrVEfJoxpNLk66OFbZDV+ID1BXa/vAL1FNC5PHT5S4wOb+eMCqHFGxt5Q3jPsWj1dWIyf/ArMbvfYDkOL3peoo0DAyYSgtG3/N3Alk7izqvdUT6IVN1VxQR6cMge9G/M2HotH5xHCQE3HyPUwql3+BdcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vTsJ1qBp7xwJbwWFD/O74p2WjaKdCCHDUR9XtHvG1bg=;
 b=kMONte6vHl5Zt4wo2wisVBn3YzlkbRl56qDbAL1J0TY1b73zoYBXgAJBXbk3Ym582W57/z2bKGuQ8TiEy0qyGhqre1GfYWxUMo6mj1uPkKDRHkQ4MJN6CUtLtVbzErK5ZRbpk+ulIWSK8w8VUxa5mW8pYSNuc+L4/4DH6GezRzlZ68ul0xKbgKCf7DcyzI1Zny/whQ/vJy0I2MiYzKOB+vYKZQ9PuE+Zxjybi1ygL6H/QAImopA2DzXcIqIQvcpW0RgJVY0CnmYB0XMFTvA1vL11bOWvzPS5BHUeZrwlDtaO/BCMQu8CuebnG5zmWwitLfCC+VGbfkrlnhaHwDP0/g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DBBPR03MB6714.eurprd03.prod.outlook.com (2603:10a6:10:209::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Thu, 18 Aug
 2022 19:14:08 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5504.019; Thu, 18 Aug 2022
 19:14:08 +0000
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
 <f085609c-24c9-a9fb-e714-18ba7f3ef48a@seco.com>
 <20220818115815.72809e33@kernel.org>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <583c7997-fb01-63ad-775e-b6a8a8e93566@seco.com>
Date:   Thu, 18 Aug 2022 15:14:04 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20220818115815.72809e33@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR10CA0014.namprd10.prod.outlook.com
 (2603:10b6:208:120::27) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1218c5aa-946e-4213-4cdd-08da814dd350
X-MS-TrafficTypeDiagnostic: DBBPR03MB6714:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aNGGVtocMUMaOBUKAWh7L4VA8PPRWzOIO/bU3vpEnSAPuq6QlJQ6o1JmHPbuHFZdz5Q+fCkzA1gXcbY9/Or9CXZ7GWV3WNDhwF7jMWC08ssVCRqbtGVtk0ajeOGE7siOmXpKEoseBaAYbCorCMncmnS3v+LduJbHKTsDtMj27YNb1hZ/HYY8iDBXuOeE90rovGtqFixv/LxVXA9Syfs41gcHJs2cO0VAXuco0xraoc3ncwUg/Xt7Lo7LfO3ZpdJya1MzG1P6hsuLATz9QZnFwSInHt+mmsRZpJI6HXo+CqUGGfjUSGvFW4p+GdULMelE8MOO0QXuGAQmuTKKAZDASZ66hNlp4kdpbcPdmGCG9869Yy/ROGB6kRzjPLcCeuUcyVgS+jRuids2enh3SXfebHr4YhGZup2gjBWLi+9fY64pEEFL1nzNEUVpLScAQzg7ShPl4bZamONhNcgQTZlVGuqqUpmDjk2oAvA4Fhs3hxxZEH0U2U4hvy0LBCtA1VtwZ75A2Jg11pftt87tgxFqJ/yDAyH6Tu2xIpH/XQ9/VIRrQ0AZLU8Ajxbmu11KLniXoJJ/R+5fwjfFBPD60nNl6ZGmoLfn70c5ipuuN9c294a5CmekhCc5EoLGjfvqx5dC0d6kKxjLsT0cBlf4pUtebdeJs3J8vFpr9zTNc0WKDlPWL4NVDNARxbbsfmuM1SOE2/Eayblirfb3fM8BWaI1WsA6RU2PzcINcikqSiqgfmYcFUj5DWUEoNEcgksJxDh7LCfft9tPGl2eHnFMBqXxPavuoYXYHllG+ONxZkxnoBhgYA6wpTe8wfjLvWFWGIeJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(39850400004)(396003)(366004)(136003)(346002)(7416002)(52116002)(2906002)(44832011)(4326008)(8936002)(6506007)(31686004)(66556008)(6512007)(83380400001)(66476007)(5660300002)(66946007)(8676002)(36756003)(186003)(2616005)(6486002)(478600001)(53546011)(38100700002)(54906003)(41300700001)(86362001)(6666004)(6916009)(38350700002)(31696002)(26005)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NThGUWswa204b3lOMlNvY2oyejBOZzRBNGFraG4yZ0IrdGFjTnBwMTVuTFhX?=
 =?utf-8?B?STM1WXBzaUsyVzVKa2RiMWFrSFJ4U0ZrMHJHa2FPd3lneWhQa09iYlA2V2hD?=
 =?utf-8?B?cUIzaVlOTkJNbXFDNU02cEJleHN0QUhCQlUxTVdTNitXU3NrcVNRdXkvTktF?=
 =?utf-8?B?VVlKRC81c3ZlM3lyVmFsU1g0aThmOGtKY0FadXRESFkraCs3eHd4V2lRQ1hv?=
 =?utf-8?B?YWZWdmV0QXhTMmYvaXpNa1NDVDQrOHlVVkpoWHZPOFVHSEZVU2EybklSNzFm?=
 =?utf-8?B?azhHZDdxalhhTysyaFp4QXJydmhyMjU2V3hGaktNdDNJenBabHRrWHRHbCsw?=
 =?utf-8?B?SG8vYkw4aXArem5hd3NxWEJicTVyek5BM2c5U1RIVVhpcy9rZmVKSEFGVnhx?=
 =?utf-8?B?d0FqaGMyUmlJdE5zc21QSHdiZXFKS3JVQWd0RVF3cDVCRm01QkpiUGxicGVJ?=
 =?utf-8?B?NlY4eGI5SGdwUG1CWHdvbEVqZ1VoNnRMMDBoaHl5UUZncW9iRk5kdkZvWGsv?=
 =?utf-8?B?OUR6OFBPZjlIQmJheGFBeTAvSllDVm5hbG0wZlZIZWIwelNlZ3MyTWNsV0Jt?=
 =?utf-8?B?cXovSHkycDFRbnBhTWFMMmYxM2hWSEtONVRLNG5NNTdVOFRTQlV0aVVlY0tr?=
 =?utf-8?B?WlV3eC9mS0paVjV5a1ZZSFpmWmtJelVGa2pKV210SXNEN2tCQWo4T1BLQU13?=
 =?utf-8?B?QU0vZFdGOEJPN0tpS2NoNlpSVk9zY2pKUWd0aWR1WGljYzQ1ZkVFYnFEb3RU?=
 =?utf-8?B?UjNwVlRvWkxDZ0ZvUjArVlVrcWp1eTlHbmRyaUhBWklJS0hiRFZGVkgwZTNH?=
 =?utf-8?B?QXUvSmdFRVEzU1VLVDllbWNRaW5wUXNKZkVqYUdwMzUwcTVyY05CZndyd1Fo?=
 =?utf-8?B?NWVUbG5meGprUE51V2d4RzE1YzlEN2pJL2VTVUZkZ2ZGV1lQL2VrWEtGRW5z?=
 =?utf-8?B?UGhhSi9oVzdLdkhJdGwxMi9SY01mb0t5bzdxVmFGczFNV0xWU2V1cEZhb01q?=
 =?utf-8?B?c3cwU2pITFFvRWYycTdwUEtEbGlWZCtCOVQ5Vm5xL3VaZ1F3NEVST2tYS1c5?=
 =?utf-8?B?bG5FZXpuUVdNNWYxV0tnSSt4cUEzZkdGYTUySGRLZzlITkUvdjV3bWxOVUcx?=
 =?utf-8?B?SStmTW5YVVAyNkhGOXZGQkxocGMrOGJkZGVQcFo1K1JZMVd2VTZBOGdubG9Q?=
 =?utf-8?B?SzNueVJBVjZVdGQxZnVTMTJyclVMVFRpcUJJYkFaU1QwNXRuOUN6dVBwdkZR?=
 =?utf-8?B?ZVc1dGZoU2ZIMVh1VXo2c1IrZVpqRHJVQ1FNYVZ2c1N1a0ZPOXpkZkpXQVNC?=
 =?utf-8?B?TzBpcEE1cnBLeFZ5VHg0TlJyTG1KSkNwcVkrWVE5OFFITEsyTVZzY2FkdTdI?=
 =?utf-8?B?VHA3MWUyZzdUQ3ZPQ1dZNGQ4ZEdyNjdRczlYQkE4ZWxUYWQ4UGtieStFS010?=
 =?utf-8?B?QjkrVkM5V2JHdVpuZVp5aUpicUVOSjlrZGltK3VhUUNRQUN0M3YwQ3J4Tklm?=
 =?utf-8?B?R2ZTUG4vOUx5OHhlYmNhbFUveUxmY084RHg5WDR2MVFieDR3NnQ0Ujk1ZGc2?=
 =?utf-8?B?VTAwcVQyTXVXOEJUR1h1RDcxVVo0V2pKR0pGK012QUhBTDV0ZzhJbUloejVi?=
 =?utf-8?B?SUpZNURKTmYrSUpwOTZ3N3VpSVhLNEVEWjBzU3l3ZjdFK0NSeG4wQ2RJT1NH?=
 =?utf-8?B?Qzl2MzAwblUwSHpIWDFleTNqRG5Ja0xjV2RzcFoweVoveW9IWGVucCsyZ1hS?=
 =?utf-8?B?L1RYTHRKTjN6cG9MZUdOKzdOQzZ5ZXZ6UzVGSm1yb2VhQWcyRnp4bi9naEw0?=
 =?utf-8?B?eWpaMlpPYVZLQWVMZkNMOUN1b0xMdFJhOVY4YVhvNHV2dERwdUJRV3BkNFQ2?=
 =?utf-8?B?d0puUlR4SE9TSGdDWjN1eGlpM3NDSkxlQzRQeWQ4ZjR2eUU4dVZTRk80RVRU?=
 =?utf-8?B?OVlpay9uOUwxcTZxQmw4UENVbWlDajUwVndpdmlTQUJ6ampDQ0hUSU85enlX?=
 =?utf-8?B?d3dnSUFydURZd3R0aURocDRQWSs0K1d6ZjUrRjY5UHhDcERNUklYMmt2SWJC?=
 =?utf-8?B?ZzNhWmFTMnVETEtmTldWbWU2MjVkYjAzZ2NnamRZcWRDbzhkenZxWHZuR3BM?=
 =?utf-8?B?amZnQUZRNnNaZGtOazNjNE1PQUhYVUR1cWUwaTRnMmNyTDhmWVhObVZ2UlMw?=
 =?utf-8?B?SkE9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1218c5aa-946e-4213-4cdd-08da814dd350
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 19:14:08.5160
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f2v/i4T+g5AjmB7TFRJIEpp5X69fjam5JVMzZRlLbjhhflWDHEnM8DZFjFy8AO6REciS2WJLzHsqtWMXo573BA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR03MB6714
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/18/22 2:58 PM, Jakub Kicinski wrote:
> On Thu, 18 Aug 2022 14:37:23 -0400 Sean Anderson wrote:
>> On 8/18/22 2:20 PM, Jakub Kicinski wrote:
>> > On Thu, 18 Aug 2022 12:16:24 -0400 Sean Anderson wrote:  
>> >> This series contains several cleanup patches for dpaa/fman. While they
>> >> are intended to prepare for a phylink conversion, they stand on their
>> >> own. This series was originally submitted as part of [1].  
>> > 
>> > Still over the limit of patches in a patch series, and looks pretty
>> > easy to chunk up. We review and apply patches in netdev in 1-3 days,
>> > it really is more efficient to post smaller series.   
>> 
>> Last time I offered to arbitrarily chunk things [1], but I did not receive
>> a response for 3 weeks.
> 
> I sent you the link to the rules. Admittedly not the most polite and
> clear feedback to put it mildly but that was the reason.

It would have helped if you'd clarified; I thought the primary thing was
the missing net-next.

>> > And with the other series you sent to the list we have nearly 50
>> > patches from you queued for review. I don't think this is reasonable,
>> > people reviewing this code are all volunteers trying to get their
>> > work done as well :(  
>> 
>> These patches have been sent to the list in one form or another since
>> I first sent out an RFC for DPAA conversion back in June [2]. I have not
>> substantially modified any of them (although I did add a few more
>> since v2). It's not like I came up with these just now; I have been
>> seeking feedback on these series for 2-3 months so far. The only
>> reviews I have gotten were from Camelia Groza, who has provided some
>> helpful feedback.
> 
> Ack, no question. I'm trying to tell you got to actually get stuff in.
> It's the first week after the merge window and people are dumping code
> the had written over the dead time on the list, while some reviewers
> and maintainers are still on their summer vacation. So being
> considerate is even more important than normally.

OK, so perhaps a nice place to split the series is after patch 11. If
you would like to review/apply a set of <15 patches, that is the place
to break things. I can of course resend again with just those, if that's
what I need to do to get these applied.

That said, I specifically broke this series up into many small patches
to make it easier to review. Each patch does exactly one thing. Had I
known about these limits based on patch size, I would have just squashed
everything into 15 patches. I think an arbitrary limit such as this has
a perverse incentive.

--Sean
