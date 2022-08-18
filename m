Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6A3F598A0E
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 19:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345523AbiHRRMn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 13:12:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345524AbiHRRMW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 13:12:22 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on20620.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe1a::620])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 599DECC31D;
        Thu, 18 Aug 2022 10:05:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CbQcA+3UpBPIsum23RiulRKZ2WUEJR+kCZODylQJ0bJC0rTDuNNqEQk2E7qE74y3301tvyRzb1FM1r2XNCbKUjdv8hHTPYU58XcDnOxPxNo9N2YzcKe3yiJyTAoccj74x/MWmYaXdgsgpalj5fooeqduv+sdLX0OngD2eZMmd1ArK0xWCkyZ0/C84i6S9DkjqR/SYCCKq8U1QWND9RtYeEH+JIQrGkakymmZzSPJwBZ0TlXN4DaC4EyXPl1RjhBOEG98v+nYUQfyY+fD0h4oP3+XfbI9H7aJkMgskHV/Qdfscbgf4GQYLNlpryzcJDa4FFrnoe1yycOvP3166kDqNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xuloVDYD/zTPVu2C1W8oQwNDbprA4ghwG5rCxVXPnRU=;
 b=deSM39cjap/U63c8yxaZk7xZZuAE/2C1jY1oH2APPWDAONkaOL7q/m2akuSuDHXm/sBLHA02aqBJUNhDFCFWKmg5B2UR3qRLPMBkcP+vQwULymCgf4wCtkcNmJxuf4DTrHU2vMovOZzXAOXIdj4av+EJeLA6AmOF5X54SoAJ86te9Cdi1+IFGJ9IIY94ToVbJ6x+mkbKNWC57uiCD2VbI4JqfTQKSZQTnB4wMf/H4mFEPtXT2mVJK1jW4Mr7Hjgut0JpRTuZNa4bICutcLPXI5yEjCPEobkwIrw56wnNFFTHz/tc6XLR7GCHQyt5355THvz1Yi/7Llb+m4D9c4CG3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xuloVDYD/zTPVu2C1W8oQwNDbprA4ghwG5rCxVXPnRU=;
 b=uyKUF7hZkBPxQXbdbDA0cplcAvbJWZjxSgyvK5PX53C+wnHUVACf8Jm05VqdTEPvMlFzecS1idqJcdcoSnfzVtaTh0pfwqL4QfVKw6WJ6t9Ifrznxp4hqj2U0aEbg5z6sX6b8P2zfHdhNxQF/MZWIEYFidK1EwNn9WZmAcILAsyOOCJSYpR+WtAsmxw5d+eG+8FlxpiH2issUZRP+HWWEQj95Lc6cOnbOM4xq76Ts/26m/vX4GG9jqjOUIY+p5+jT+EEon1Uh5+V7pWOYz6vYccxvjd5pkDFp01FuCJyhcAXTISYPoQ7GD8mShHhJYoTBsrG4Cjisxi1InKphHK6ZQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AM6PR03MB4263.eurprd03.prod.outlook.com (2603:10a6:20b:4::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Thu, 18 Aug
 2022 17:03:57 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5504.019; Thu, 18 Aug 2022
 17:03:57 +0000
Subject: Re: [PATCH v3 02/11] net: phy: Add 1000BASE-KX interface mode
From:   Sean Anderson <sean.anderson@seco.com>
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
Message-ID: <35779736-8787-f4cb-4160-4ff35946666d@seco.com>
Date:   Thu, 18 Aug 2022 13:03:54 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <8a7ee3c9-3bf9-cfd1-67ab-bb11c1a0c82a@seco.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR06CA0022.namprd06.prod.outlook.com
 (2603:10b6:208:23d::27) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d6bdaa43-d860-4306-2358-08da813ba399
X-MS-TrafficTypeDiagnostic: AM6PR03MB4263:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IlgwJFW9yLpgby9liRBWb/UZFqz22f8YBphHhy2C0o2/MEnrkLM58HSuR8EW67st1ZkMrbuHeoTa8oopcFFZUkMJUMxn9sbo/dku9x+uFUmbtwOOLYaD5k30BRZzMFP2wvaf64Q8mKyszkDNjl2x/qGXtsW+X44CMYNRPv0TNkVbzKr3C+Fbp5bXUToIxJ4kK/o8uSfZfrTkQXr2Y+p9OKgCK8C5ZE0NYY0yBPLu+YsklVFDTfu23wLBIJuhBtBf8ka4H6QdyFDnCV6npTlz0dAtrCvixuPvoWJAhrm6Yurfpi7WEIMXtO8egP7N/ix6bqgPTgsWQmKXrTWEWyvEEE2OqyqQS6/PfSSOS3OuYvUA2ev6fUxqGUPjuXyhUTqz8gE5obAB8FcSCHqpKU0Q4/DL1ruyjovRSygcPLo+fFl7+n/s91TG7tJOO+InC1vPavxdV10ioFd9PLbguYtQDT5LBb59jZVn/t5Pp9pDjdUPtROLDEcbJprABFQPv2dfbglAEaIY2v9jg7r4rBmBYliWnt1jhWBhAsc2Tdv327L1qb4m5RLfTCRXQiq5DTN2A6jRj1Mg/+Ry824A9nW2foC6IMA+GnvBng3/0EN8l1DclszNTyiyL+c0zpj+TvxTfBL28IucSuw7TiLu8Gf73V/YTYrVSbs7dxokH+funSZo1oFT1zqHC3CL5mrwvoAYh/goSxjXxVfE6U4FT5hodO7+n33enGc38BMqnE06f8/qlTSEEFE0crWJbiKhtMd5d/hokOwWEG3Q3GcDL7QaGvIaVWfpIHxg2/1RYZ5w8G3ifDqEKo3gYLBu7A6Kouu2Y47Whey9h3579he2ibUEJy2DeaM+A4lzReTXrNrcS0Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(366004)(39850400004)(136003)(396003)(346002)(8936002)(54906003)(6666004)(7416002)(4326008)(66556008)(2906002)(6506007)(26005)(53546011)(44832011)(8676002)(5660300002)(41300700001)(52116002)(31696002)(86362001)(6512007)(6916009)(478600001)(66946007)(2616005)(66476007)(6486002)(966005)(38100700002)(38350700002)(186003)(316002)(36756003)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MEVLRnpaNTFNY2RJcXFlVkY3dHpkdW1ZYXFqTERuandPK0JIbHZ5OXVnMGhX?=
 =?utf-8?B?U0duRHprUWVCY3lUWGNJU0JmM2hBeUdEcExVa3FMMExrZWgxMlhqaXVGQkox?=
 =?utf-8?B?Vm9CalM0ODBjdGJVam0zUktKZlFqUmh6VjZNRTBDbHFkYzVpRUVJd3hLcHVQ?=
 =?utf-8?B?M3NDSU9ZdE1zaTJnVUZ6VS9hZWRzMkJpT0ZnV1lqMWtQb0xKNTN5TU9tS1ZT?=
 =?utf-8?B?NXpzVWtSd3VlU1g3WTBQc094a2xmWjBFL1dSNzBCbmpibUxHYWVQalZ0ckxM?=
 =?utf-8?B?a05ZQUEreDVxYjRzckhDT1c0dDhaQjI1d1Ixa0w4dlJMOXBYamxWc1lyRWtZ?=
 =?utf-8?B?SmFNN3NpZ0NxNjJIbUVWdzdHZXVlQkhqbkhzcE9rdWY5NFB1OG4vZ0dycHdm?=
 =?utf-8?B?NjlGT1BHOTJSNW0vd1JENlZsclB5ZzFjUFNRSnhWUE9CZFpqZkt2U2FCeExV?=
 =?utf-8?B?Smo1QXhZZmhmQVYyby9sS21JQ0p6TjdBT3Q3Z0ltT1BuT05Ycmw4OEMxaHRI?=
 =?utf-8?B?eDJEenBYY0IzeVhvZmdGY1dubC92OGZ0V1FGb2xTbW9JV0kvUVBQOCtVUVZo?=
 =?utf-8?B?U2w2dDBWWWNCRGZSSEtKcjA4TjNIdzB0SDVPTXNWSysrL05zOVhEVEFtd28y?=
 =?utf-8?B?OG9XUlkyL1A2TC91QldyaEZYNE1OZXRrd3M2RkliMlNPNlZTZ2NkZlE1Sm5F?=
 =?utf-8?B?bzl1OWxCenc3LzhkTVlBZFFpcTd5a2VtN3RneUNtRG9zYnJ6TUYxSVIwdTVr?=
 =?utf-8?B?TmxFZnFsRks2emI1SkZGeE0xQWc1QWgvdDdkSituWThpKzhMajlzM3ZtVGQr?=
 =?utf-8?B?UUx0MlpVV0tiRXdFQkRLdlV0NzlCZmRMM2hpSWFHRi9LdFFmY3laMEFnZE1t?=
 =?utf-8?B?YVFGWWVzVUpzU2ZhaDhhQnd6ZkFobzRjUnhWRVJMY0dJMmc3T3Q3Nnd3NHd0?=
 =?utf-8?B?MFh5TUxINDlOWno1Z3doa3BhVDNLQ2dxYkRkNzdka3hNTldOalB0NzRzbmJV?=
 =?utf-8?B?NkI3Zmt0TVNKeG9ORElML3d0WlFHYnQ3OXo2SDI5Mnkya0FzZEUxQ2hSUXNM?=
 =?utf-8?B?TTNqSFZYVFlmQ1g2ZHk4aXlRelZRS2hHb3h4VXk1QTNPRDZCTXlMd2YyL25G?=
 =?utf-8?B?S0VNVnIzdm9jeWJqTm9GUWFVdWJWZm9UNmJKVnhTbUhHcjNncUtpZnNMcVZN?=
 =?utf-8?B?VXNjcFh1YUhaS1FkUVYxWUtlcElicEhlNXBTb21KeWphMHhpL2VUeGdneGJj?=
 =?utf-8?B?Qk9MTjZxTlVjWm8zMTkrd2JEdVdQVk1iaDhVSysySWpuL0FzSEQ2SlVlOThK?=
 =?utf-8?B?ZHdLVHU3YW1LUWNHVkM4VW03VkdoaENDT0NwanZOTVluWmRLdkgvb2JaNUdD?=
 =?utf-8?B?K25OYm54c3A4cmxudHBXNkIxWGZweXhObVZTS0gxWGdUaVluQWprVThlNlBN?=
 =?utf-8?B?VzZhRFpVRjA0ZXFuWnFtcEJWK1YxenFQZExJQ2tVY2ZtK0hSU3Z4OEdkY3FM?=
 =?utf-8?B?WjRXWEpTQ2lwekUwZUNBVjBSNjNCTGFram1qcExxeDBYR3p3cEczUC9FNmcv?=
 =?utf-8?B?Qm1nbWJBQmV6R1dFa0lHc2ovcHJpUnhaM1FTZTVNNDB4QWdFVWtZOTh2NVIr?=
 =?utf-8?B?UkRsZThvWFhyb1Jwdk9LMWdZdTNEckZteC9VemFJTCtHUHlzNjEzR0dIeU9W?=
 =?utf-8?B?bENhM2ovMFJ2MHM1ZHY4K0JFeDhNcHkzWmRNQlczWk5JanA0NzQ1NysxdnRn?=
 =?utf-8?B?bHVoSTk0bElvUVR0bXFHWTdUZ3BESnkxWW03cU13anJ1UkpNanF3TlF5TXlt?=
 =?utf-8?B?a05LWDdpa085R0RadU5PUVVlcmk1d2hoZlN1Y21mUVZIS0RLMEFDbjZyVG1u?=
 =?utf-8?B?OC85QWJ0dStUeHNLK2gySTlpdnVzQ2JvK3dhSUMrQWZGcHRLR1pGUVRuai9h?=
 =?utf-8?B?M1puRXhiaWMzM05mblNZV2NBVnFQL0w2dTRhTjcwQTh0QkNDRHhCa1lqd0h6?=
 =?utf-8?B?ZFYrc3hNRW5Oa3RGR21TaG85REEvV1VVVjA0bERONDIvUG5IRzJkOFdhK0V1?=
 =?utf-8?B?NkRVZXl6OU90NWI3ZnY3RE5zalRmZTVPamtvMmJVMFJxaldtdHhyenduc0da?=
 =?utf-8?B?RXA1bjh6UG5ZcngzWHdlLzRRcm1WRmV0NE9uUW5OaGZUdnh5SG54SFFwWlNU?=
 =?utf-8?B?MUE9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6bdaa43-d860-4306-2358-08da813ba399
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 17:03:57.5059
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xLs+EyBRmaeGt/IYy8xwZSAOUxxrFiWiy1O3FOaCNYnTU+MOvNdhpXkeNZcI7kzFUr42YJpnenKuSLZ7Aje7gw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR03MB4263
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/18/22 12:57 PM, Sean Anderson wrote:
> 
> 
> On 8/18/22 12:53 PM, Vladimir Oltean wrote:
>> On Mon, Jul 25, 2022 at 11:37:20AM -0400, Sean Anderson wrote:
>>> Add 1000BASE-KX interface mode. This 1G backplane ethernet as described in
>>> clause 70. Clause 73 autonegotiation is mandatory, and only full duplex
>>> operation is supported.
>>> 
>>> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
>>> ---
>> 
>> What does 1000BASE-KX have to do with anything?
>> 
> 
> It doesn't, really. This should have been part of [1], but it looks like I
> put it in the wrong series.
> 
> --Sean
> 
> [1] https://lore.kernel.org/linux-phy/20220804220602.477589-1-sean.anderson@seco.com/
> 

Well, I suppose the real reason is that this will cause a merge conflict
(or lack of one), since this series introduces phylink_interface_max_speed
in patch 7, which is supposed to contain all the phy modes. So depending on
what gets merged first, the other series will have to be modified and resent.

To be honest, I had expected that trivial patches like that would have been
applied and merged already.

--Sean
