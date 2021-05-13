Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E22B537F6D6
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 13:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232733AbhEMLgk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 07:36:40 -0400
Received: from mail-bn1nam07on2060.outbound.protection.outlook.com ([40.107.212.60]:40103
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232031AbhEMLgg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 May 2021 07:36:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oSzbI8hxMtkcP/6sgNkCEt0Wk64KXotbCTBXPIFfe0RHaWQOUgoYzXSkJ4/pkDQz6bRt8G1JGhL8uwGPgIsApAJky+NICIhSaQKMChHxPGsaL0ZdCuHz4SmLdrUFif/VdAi7BuHm4yoj09mrFzSjjvtMMEczqfqlawwzAikasAi3VMrsb7jCMJocjA3PIJlAodQ8NpqHfpFJh1V79MDASvtgTi4nzjl8KrElHAeQ5c72Qf7ns9lGkZYfWurGmvxdwjrmwB08nlYDNiLKCZ7w3hb51RdRe7KeqwO4NaVGfef/5fRSVjLofpj7pdB1FfDlzgawGvxTHCHcu4ipyD8gew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Om6Xdu6efzJkvDii/Uho6oEszK60ztBViYxGce2kdbc=;
 b=nPA4Icm6bVUTz850upGxZ5EF6uLRrLJ8kub2P4S+/ZfgASMltSyS8XXtrNk3qEXSPmU/Smt+U2ba7eLlHPdT4F7LWBUwZFwx5pHR4pPUER5lijMESQL0QU1TWKsvEATp02wAwZTJLGKc3BoTyRXp2IBsGiaAbYU1rZ5Tc4nadw/tF7iEexMY9G9bvEF+/HyIqRu89mnr1woDPtQXej4EL9ImHlRxRnrqU89GImGbd1idih7nDx6bMV8GZoe38dA6Cbt0uExSOjX/bjO6GrZYOUrAqNPP/+Pl0fxDTeh/QrklJOwz8bIaJIW73+M2Pw6h2+WDMtA2fL4L5ITNU4CESQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Om6Xdu6efzJkvDii/Uho6oEszK60ztBViYxGce2kdbc=;
 b=q8mOAXEiZUgX7ehN/fY0MLU0niCLiCrpmK100N+SgX5irM42Jz3aa60dACR9v6TxZ0N1uTzOnZ25qV2VjQ8EWgQoy9gCeZSyFd6rTSj1cKYQN0CEu4cUJW0WNzwhZ9fbwZew8iqy1NtF3dkviR1Hq44IBpprDYcLLE81GO50TpbrrmVr2auLK/0FhTv+lYAN//MsT1tj/+8TAbRxA6nGwqJMdUVfBtu7v11p60y3OdY5B4dBMP3Xa4fv/T4XHlYZtINshctIoylM5mq//Pb1S4gYoqYmGjk503NnQiYojGaWM6j7kYQ33hYruSehuaU+FI1LUGEiUhMD0hAMlZnPlA==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM6PR12MB5566.namprd12.prod.outlook.com (2603:10b6:5:20d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.27; Thu, 13 May
 2021 11:35:26 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::d556:5155:7243:5f0f]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::d556:5155:7243:5f0f%6]) with mapi id 15.20.4129.026; Thu, 13 May 2021
 11:35:26 +0000
Subject: Re: [net-next v3 07/11] net: bridge: mcast: prepare add-router
 function for mcast router split
To:     =?UTF-8?Q?Linus_L=c3=bcssing?= <linus.luessing@c0d3.blue>,
        netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <20210512231941.19211-1-linus.luessing@c0d3.blue>
 <20210512231941.19211-8-linus.luessing@c0d3.blue>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <a75668ae-ad62-81e1-217f-76e9bbc6fa96@nvidia.com>
Date:   Thu, 13 May 2021 14:35:19 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <20210512231941.19211-8-linus.luessing@c0d3.blue>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0069.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:21::20) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.170] (213.179.129.39) by ZR0P278CA0069.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:21::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Thu, 13 May 2021 11:35:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7e7cc386-c039-4680-7bd4-08d9160333d5
X-MS-TrafficTypeDiagnostic: DM6PR12MB5566:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB5566A182B9001DE5554549F6DF519@DM6PR12MB5566.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U5FpxlEpjUtJkLIMahLDpixkdYYyURBQm4UPytKVny5vDEmdZC7pC9XQT3ftEamOUim6+LXaG6saJo3Lh0NNUjI0Jz5Wlrou3hKvHr15nK+XZchOFK8INsBG2kzgrgfVqLpTelPODtuROBdWL+3dnUxsADydcgNQaDzcs8KjexnEY5At+06rorq68K2ur5tIgSujbM0EnLyhhV0zc6VXtcfX+JfQukx5NghNQF2MUSZd4FW/7bL6hPsGVAaN/lA2XT4vxhNRSEB+aNI2M61fpzSszfnN9TSS8+PdgNgp4hpUIqxPN5aRLHtrU6Fu7Rn+5dM0X7UspmKhFoY/Xpy8totgXRSXRGP7YO1OFpArEXKQKZ2wWLIAaVaPFMcQLYlkr3c8FHPcJ91zg0hA28KA9A5v6lYpA+UoxxtQMxAixwuiyGpEqG++8+0DimEJPrLh0ONUcOKeUMtePGJOZSarI1yYGkZ5ORVWCID4aTUu5QTJA9vvKR4jNKGn/bBex8j4qSF8CVQ0VgR6mGByYK+ZS8gxi9v/TUJwPjLgjM/W2HMf9m/bGMAXcHKqaFe0TEXm81+QRq/Ipp2WNQXgi0qwxas6YAxRW4qNvO8vMekiffZd/k7a9Ig1tkjMF0zQO+CK6S5r6K3u9P0wsnDJR1AsjHt/TxIYpdY/OULmIsaE3c+bTNpCAiqG0xFnRM4TZhgn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(136003)(39860400002)(366004)(346002)(53546011)(26005)(4326008)(16526019)(186003)(36756003)(2906002)(38100700002)(2616005)(956004)(16576012)(83380400001)(31686004)(316002)(54906003)(4744005)(86362001)(5660300002)(66556008)(66476007)(66946007)(31696002)(66574015)(478600001)(8936002)(6666004)(8676002)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Z3VRTVkwVy9aQWFLM1ZIbW1hTlUxR25HMEpITFpLS0kwNXQrb0VzNk5kOFNO?=
 =?utf-8?B?NVZxelhvMHlzZVlRa25lOXJtUjB5dlRTRWkxeW9mYVdoS2tZdHZYM1ZtU0pJ?=
 =?utf-8?B?NjJEdmpvSll0SW44cXhpblpJSXJzYnM0Ny8rSGVVc01NODVici84RmZkaFAw?=
 =?utf-8?B?V21rcFNBamZmbU0zYjFxaHk5bUg1cXFEbGNnNjNjbmRZb3ZQWDl0SFN3Y3hT?=
 =?utf-8?B?RDgxQ2xoTnAzOWN4enZKbGZBVS9FbmVidzMyTElJMnBSdCtmNlFFSDJDU0Rq?=
 =?utf-8?B?NjcvTW13NG5LZ1FpVDd3ai9rRFBJOEJxVmE4Wi9lbWt4RExiMExOYVA0Q2Vj?=
 =?utf-8?B?UXl5K3J2eGZUUHFqWnc5ZHdXeUdwY0oreWJiM0k5KzlBWVZsT29nTmxGZXlZ?=
 =?utf-8?B?M2tLMUp5aUNPLzBtZWZsMXhJTzROZmkzd0o1NWEyNGhqUUZDM0tIVUp3Y2pj?=
 =?utf-8?B?ajFkbGU1T3VWV3lrZFY5VUpQWGp2Y1gzSTBzSzcxeWIrL2FmUDBjQWVTVFZu?=
 =?utf-8?B?VDZUNGZKL3I4OHo4T3J1UGFhcUwxVVNYMlJ1MGFEcjYxeGEyblhnYmF6QUxX?=
 =?utf-8?B?RDE3OVZjK1RvYzB3NzVnZmJVSkREMjNQdEovelVWTENBT1NNTFZkQ3pJYVN0?=
 =?utf-8?B?U2lhd01PcEkxMDREUndtQmR0Nm1PQm55eVluWlZwRE0zeVhzWU1VRUM3Q1F0?=
 =?utf-8?B?RlY1aW5aSnRPd1FPbVlhaUZDYzRmNzhpQVcxNm13S0FpWE9Sc3ozcmhKdldo?=
 =?utf-8?B?M3JxTmhDbUZBQ3Z3T1FlOUl0YjUvbWhsbGlQUTArWmJRVTZnNThIbjdMbFVm?=
 =?utf-8?B?N2RON00zQkxMWEwyZ3hET1lrR1dIdWRwdWFqVmFnRTBjUFA5L000QlJ3bWRn?=
 =?utf-8?B?L3BiMlZmWWVrZnZseHF3MFRQcFFjRXJaWjVaWkkzK1FpdnJ4MGlTVFp1Qjh0?=
 =?utf-8?B?SGNabnU1VSs4V2phUmRraXVRZlVNYnMyaG9aZUVXc0l6clA5aDZVcHJNNysv?=
 =?utf-8?B?NXI4Zk5jZUFGaStOZ2pyVDlWeEJTWGhUQkZlNGRIaGdJYm84b29WMVFqYlVo?=
 =?utf-8?B?UXBEcFk1aUEvamQrcjFkUnhjRElIUDJOc3VJS1pPWjJMOGwyVnlKUlNtYzJm?=
 =?utf-8?B?bWdrMy9WTjNzUEpjZTR3cU9PK05FZ3U0eitTQVlTYlBxMWF2TitmcWxsR3lK?=
 =?utf-8?B?NWttSHJkRjArdG1uZ04vL0VuQlM1Y1p4eDRkOWFqcEJJSE9kTkp4VWR1Q0NE?=
 =?utf-8?B?bzZSMC9wYWxseTZQbC9TekxXbDA1Z3JPR3FzY3V1akN0dTZ5cnF3MFM2bVln?=
 =?utf-8?B?TGhBYldEdTgvaHFkSjFvdlYwQms2Ry95WlUrcjJnSWRWLzdJRDNYUFhONkhR?=
 =?utf-8?B?bUhOeU9WZy9xSU5xYm05OXYxRENtZ2RGcGVDOVJWTU8xcXJLcSt5NUZ6Qy9q?=
 =?utf-8?B?TCtyWGh3VkFWZ1VXdDFnSm9ISm5DcU9ieFJHS3VIZTF1dUtIbGt4cXJPMHV2?=
 =?utf-8?B?NmRJeGIwMnYzWncvVTNyYVE4THlpYUoybGt2cEpmL1BYNzFhTG45bkZzN1gr?=
 =?utf-8?B?REN3UW5wL0pIanZjQWdXVis0dHJXYnVKd0tnb0liQUVubzlqaFZTbU9vcmN3?=
 =?utf-8?B?cjBxbEhTRk9yVjIyWWdkM2N5cjFqQ3pZUXBoMVFkYjhNaDJQbkg0ZmNhSHJ3?=
 =?utf-8?B?ZXBsTFBscjh2eFFXZzZZTU83YzFZMXF5U3VSWkI5MCt1djA3RFFwVG4zdkdw?=
 =?utf-8?Q?XXW90fhWBo95cPcwoKJEoG1vmLWpau3sdzQLcex?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e7cc386-c039-4680-7bd4-08d9160333d5
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2021 11:35:26.1311
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rtcvIgXK/eL0l3otxWpebrGa9nJqMKfSOjXk9EAlQAk6qan1DSVe6B5LyMIKU2DAJ7ITsAR8XkYkQjJ/CUQpUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5566
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/05/2021 02:19, Linus Lüssing wrote:
> In preparation for the upcoming split of multicast router state into
> their IPv4 and IPv6 variants move the protocol specific router list
> access to an ip4 wrapper function.
> 
> Signed-off-by: Linus Lüssing <linus.luessing@c0d3.blue>
> ---
>  net/bridge/br_multicast.c | 59 +++++++++++++++++++++++++++------------
>  1 file changed, 41 insertions(+), 18 deletions(-)
> 

Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>

