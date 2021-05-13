Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 538A737F6C1
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 13:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232513AbhEMLbk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 07:31:40 -0400
Received: from mail-dm6nam11on2045.outbound.protection.outlook.com ([40.107.223.45]:7008
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231699AbhEMLbf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 May 2021 07:31:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m+O0UGlDKhLvNFQ8lNO0llbyqlagQdMrCFZvMC7snYq+BiicfZTe8zBsgOR6jk69ii3r/y5wgCSsFCwokeQeeuno/A11loCyokvXQAWArl6jzbeMgiQPgdpvqIr+JrlFB2Pz69+l3F23II0+kIia9Ltto4ut7OotXhIdxw1cio5vLoqPssim9JScdrmWsL4w3YLYl/MwQ/l0dXSsuV+jDKcFwUJ/KBDnII90vnMI+gxdW/jxnRKnQ1PAJf3OVNkVFSriemolpX3xLCZRdx4unfCjNK7cufBsekKb4y7DnmFzX7r3Pl7IR2cqUWJ9C5POAOh9FCIZhnXSk7RdzpdxVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=btjUqxIAIG7LxnFeFiiL/nhBDr1FVrk5voR74V0uMsI=;
 b=RAmyMA0MiAW1CP0CPqizU/nSHbYg26NWKHmoMnS/p8DifdqaP6ExNX4HMMvRmjp1xp2JpUaZyORpgz25J4c8mGWGtvTU6mz4Oikg9nKKdUoaOD+tdj+3JMnRUCK8Qs4Rp6jEnGQVTfTAi49VxjLUAbDrQ+XDO3Lb+NFIryQRwavRHbAi1rjaj7Wwb4tarakPI7mdDXNCd+2FJJmy1DWM/3aakO9J5z7qAx7+d2nt4HaMRZLB4T3d60nO4xhBYdQmLiPzi3/3djl8ej/srMorkPEl89fzzKdrE229aasYRVEUhEbYTdPu0SZOHy/ygq2qoyQRWgf6IWk5JE12yB6cig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=btjUqxIAIG7LxnFeFiiL/nhBDr1FVrk5voR74V0uMsI=;
 b=QsrDBiMHZYA8yw5e1zOFm1kYtKeYMslEUPk+bVDGxj4653j2D4vsRTmGrV3y5xJUVUcMrkwyAygrq0DMBto3gag+Bma2/4KbkK5pmQn4WfVe1MioRS7CY/tdm8A57Ro9mC7RZl+wB2JQJ7RqnC4sBRwCR2Sg3LAiS1QZ9JBcibmo8pmw6vRR1SGQPBXS++qclAMAx8m8owL+IIzydje70THJobRrm0Q17xH6MOAgHI0eYfDE3jHrqQxZ0aHWKNknDlez+aImcijVhPw9LKpgpjDIiToacs98off2/MKb8t/BUy/W1Xzs4hb1WzE1fjCtm3j/+ZRqe4dnzBXQdHq/Rg==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM8PR12MB5399.namprd12.prod.outlook.com (2603:10b6:8:34::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4129.26; Thu, 13 May 2021 11:30:25 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::d556:5155:7243:5f0f]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::d556:5155:7243:5f0f%6]) with mapi id 15.20.4129.026; Thu, 13 May 2021
 11:30:25 +0000
Subject: Re: [net-next v3 03/11] net: bridge: mcast: prepare mdb netlink for
 mcast router split
To:     =?UTF-8?Q?Linus_L=c3=bcssing?= <linus.luessing@c0d3.blue>,
        netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <20210512231941.19211-1-linus.luessing@c0d3.blue>
 <20210512231941.19211-4-linus.luessing@c0d3.blue>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <b1819215-ed94-2777-911c-ba20400f42fa@nvidia.com>
Date:   Thu, 13 May 2021 14:30:18 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <20210512231941.19211-4-linus.luessing@c0d3.blue>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0043.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1d::12) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.170] (213.179.129.39) by ZR0P278CA0043.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1d::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Thu, 13 May 2021 11:30:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 67f187ff-eaf6-4bf9-c098-08d916028049
X-MS-TrafficTypeDiagnostic: DM8PR12MB5399:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM8PR12MB539918A2302676BCC73DE847DF519@DM8PR12MB5399.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TJaBn0HCrPzOWuUty0se7wmgwDUN7F51Tu/W1LIl3Q1qE9idU/9e7fiSYeoBBSJsglHk7LtiilROoKferMlX2g3hND/gaIQxx7RRarHGuTTZsmpswuiOwcS4YMdxaYk/xKgtaNISzqrVEC5YJIEwfD6d75OQcChDLGCtVH3bQo8s2kR3BF0ws/9+6At1h+VV/McNBZ3FxFYduSlCWdrLc1/w+ir7vRxqL/00pm/lN+LNznxIqM+uDqWSnNOwgCHA4NoEuBjj0QrlL0bw7M7KJ/P0ZgBS4pyqMBF78CuQDAUi2ft2ICI2ddbLTSVKWLcub/sdCXCglljAc8HUPlgBZl8WpVaSmaq6E2BGlVrFItkadN+t57gtcWUWJ9kijC7bvGY2zVZEEPP7f+0L/xifWJfqi6DF5uIRMaN2HlinYi9Hc6lKHWgMLfOQoxpO0Fudpibo0X8T3I0Gb5K1k1PdZ15oQG40UMqrF2TZwqAKBaj5OkOjtcN1VGmYxP6epE1iP4oq5BqFE6FptXY11EmYnfXTZqvvB6+8FVFrj1xcfPWJGqspcV/omWjOEE3d9zy6H2r9Ruf9O8UPBWx5CeOWpK472MgfFLbF3W7EYO2q99JW8KQA5UiqiwUhJBTMq/ZkSOqqeAICM3b0mmwj18GNZd6h3fOggwxsERrcKJW3YEtoGI714hPzm0OBF/hN5ccC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(376002)(136003)(346002)(396003)(8676002)(38100700002)(4326008)(26005)(4744005)(6666004)(478600001)(186003)(36756003)(53546011)(2906002)(31686004)(8936002)(6486002)(66946007)(54906003)(16576012)(31696002)(66556008)(83380400001)(86362001)(66574015)(66476007)(316002)(5660300002)(16526019)(956004)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dHN5c3BUa2wzc2Jaa2oxbVhhR3ZwM1hxUjdxVTAxT0dXQ1ZqUERkektORG9x?=
 =?utf-8?B?aytWek9XRTdIWUNQcFdVNThiNUVYWC9MR1ZKS1pJV3JLaHhSbENWK2tmWmE5?=
 =?utf-8?B?cjVlcDVyczhaVlRRMExZWWhLNEQ0L0g1NTZySUpSWWI5ckk5b3J6RGd0YU5h?=
 =?utf-8?B?QUIwM041Zk1MNWxndlhoS0kwTGQ0Rnp6STN1NE53NlhBMWpLcW1NWnBTUjRy?=
 =?utf-8?B?MTVLNDJUQmpzTEhrRmxINHZOWG9kenJJelRxOENSVmF1M095VCsxbjRIaXJN?=
 =?utf-8?B?R0xQazZQQzFSdnpLMDM0VldYYW1oRS82SzE2YW96YW8rdjU5RUFhaDJNWVps?=
 =?utf-8?B?ZTM3TTVrd2pEM2liSWpNSmJ5Y3VXSXlXM01KeGcxU2tHYmJiVzNhVmZxZUQ2?=
 =?utf-8?B?aFdyMzVjckRlRGNtTnVMOXRadWdWNjA3M0R6NFMrSURKNFB0WmlHUmJHK3ZQ?=
 =?utf-8?B?amRoUUhvWnZJcURVVFhiZDRxZ3dtTTNNcTlaRTVJcG1ub0lVZURRVEdsOE9H?=
 =?utf-8?B?b1RPbTJnM2ZWUWVNMytrZU8wQ21Pa3JJa2o5WGdKR25vNDIwdWlqQ0hUTmNQ?=
 =?utf-8?B?UFo4KzVaVnhkcXdFOGZpUE9ZWnhwUUJyODdsRjZXeVFGQjJXVVBDbWRkRVBL?=
 =?utf-8?B?dWl2M1kvamc1Tkg4Q2owY1U3MlNnOWU0UmplY3E3bDhkblVjSDNFektsMmNh?=
 =?utf-8?B?V3hCYm1WV1NBS2V4U0ppK1BWajA4V3BKbFB6QzFZcEpRV1BXd2pIT1dRaTNm?=
 =?utf-8?B?dkswVnllVDVHUytZUUhXKzFPTk1KcnI5anM4YWJFVU56MUF2d0FqSWpRcUtN?=
 =?utf-8?B?cVFlNTBES3JQOWYwaDhwWDI5ZG4rN3RobkNjeHA1bWNOVDZpSHplM2psMXRq?=
 =?utf-8?B?WkJVQ1F4ZkUxK2dMMlFLTnMycWswMjhHajV3aU9CdEFGdEZvUTUzalhwL3hL?=
 =?utf-8?B?MzVyWnlIbmtsRmZpOVNRcGFQckhMZ3N5MjBpS0ZHUHZvTFcwNmJobVE5YXBp?=
 =?utf-8?B?cjJiS2VuSTNIUmQ5SmFXWUlnOTBDdFJSS0MvcXQxNy95RlI0ZDd0ZXZsQ2Nl?=
 =?utf-8?B?d2taSFB0b0xMV2xUNFBMTXpFblczWGxTaEVQS0dsendQbk5BOEtxRTRxYmZP?=
 =?utf-8?B?OStWWTFDSzFiWkFDYkErY3ZYT25CdG1XL0J1Vk0xKytMczB3ZTRlejhBeDdp?=
 =?utf-8?B?cVc3eHd0YkhwTDRnT0JVeGw3OG9nZ21JSjl3MWpYR3gzTXU3K2Z3SlBERm5q?=
 =?utf-8?B?dDBXVlMycFJBSTZLMTFibXZhNXpNZWlvNWI4YldPNjROdTJMMkpuUzAwRmJE?=
 =?utf-8?B?QTZHTzZCNFRla214cCsrQnlRd0wvSi8wM1pXR2E4UVd4VzgxQ1Nqb3F1bUVH?=
 =?utf-8?B?c0QxeVZMT2NDNENjYTkweGJWVFlmRFVHQlJJaEsyd3VPcW5XcE56dS9iQm1Z?=
 =?utf-8?B?RmV2bWpmQ3k4U1gwcTBLYWZ2d2JaL21OYVhscDRoQTJ4NktFaVJ2WlJycENK?=
 =?utf-8?B?bUFjdWwrNVNWc24xNHhKUE50RmVhZ0Z4dGxlWENLQ1ZhKzVhMFlvb0ZwTWw1?=
 =?utf-8?B?eFJ2L2hKV2MyL2hKZXpRWkFjcFNsbVUxeHhZOW85OXNtem9DbkF2VzF0RlNZ?=
 =?utf-8?B?YU14LzFnSW5LWko4Q0NNaUJDbVR5SlU5aXFwZ3I2dFhxaXhGYy81Sm5ybmJr?=
 =?utf-8?B?UkJHNE9LbzU1WDdwN2duNS9NbGpCdGJRRHp2cXFoQVo0NmVmRWhXUC9lQzVi?=
 =?utf-8?Q?K3gNRPV8p9uTHYVmuOkAjBomAWLgivAteLVNYbl?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67f187ff-eaf6-4bf9-c098-08d916028049
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2021 11:30:24.9978
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IanfrPXnIGVz+f4Mo7YL6y4QPGPC+7gc9XLMLwUFW1t0FVYxfQ8+ED98cWV9ysNfIFbROoGo8WX2wul9c1mZUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5399
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/05/2021 02:19, Linus Lüssing wrote:
> In preparation for the upcoming split of multicast router state into
> their IPv4 and IPv6 variants and to avoid IPv6 #ifdef clutter later add
> some inline functions for the protocol specific parts in the mdb router
> netlink code. Also the we need iterate over the port instead of router
> list to be able put one router port entry with both the IPv4 and IPv6
> multicast router info later.
> 
> Signed-off-by: Linus Lüssing <linus.luessing@c0d3.blue>
> ---
>  net/bridge/br_mdb.c | 39 ++++++++++++++++++++++++++++++++++-----
>  1 file changed, 34 insertions(+), 5 deletions(-)
> 

Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>

