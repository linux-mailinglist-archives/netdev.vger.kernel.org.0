Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECC8D3EE7D1
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 09:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234893AbhHQHyZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 03:54:25 -0400
Received: from mail-bn8nam11on2077.outbound.protection.outlook.com ([40.107.236.77]:31474
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234581AbhHQHyT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Aug 2021 03:54:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MEilYeWmadnrE7uQCrrPoTOlX+qLFjQp2XZwyaMMDkvtvUKC9NR2REp9loAuoS74bXgruC9KQXnkoJHLsRUqNznwSdJfTYLJaCdMOu49nXx1Stz9h7cvt1hgGUlACOXo//nsWs5yTwBSm/Wz/2rk5/RQIPUiutp7LQwEEN8H34Ka8ZqQJ+JIEucsxw5SWovX7S2CNI3FeBEqQpz5e2lhKXfMSDCsfw1aIGE88etYinmoLbmdnZ3WBlgplyIWZ9ZwUNVZjOPxITwYcTAYS4qjRwju2hYufbfssywwDKwAZrw0rfAofEc6DSFvisGiBP1rQ/RrCd2VDBm5b6KYgIMh5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GOUtESKYGRfEUgQr4gVWjwTs0tYlEsoXyizj8Os5r1o=;
 b=L62SphbeLF+kB35tTKeyDsF3fUaflbWBkD69P4S5lFBZvzkEeynwwtVu/mLxYp+q5V9OVutPOvKoiHsK9lfuCGx7PLI7/w12YNsMtcFVxZsbhjJaeuu6Mhi80bQFTRZMilnJmzcAFSvuqU5PSg2N8px3UHgtujZGWJOqL06eL3IgfsRDV84ndUaeXwHdriybl5YrmTLhdRk58V2bOUxZyn2xHlLUisAPjwRSQgqxzAgHIFl3Yz8Lsc9AYEdC/wcyBMDsxVgy7xdenmsV4Qyke/u25+8tUoT6ayDQTSIDKwzRsq0P+KzuxtpC5veWFpyfGKMfT8/idm51WOyC61a+7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GOUtESKYGRfEUgQr4gVWjwTs0tYlEsoXyizj8Os5r1o=;
 b=lETnTYZFP8a628KJDiLqS+PcR9Wb98m5AA5tB98IQLnlbu+PqLXNQBBOs9Lx0de0CfmaHeQ5RQeey9iYlLzqNWfPKyisB6fxUcmNlVdfzBqDjnbU6EdaYhA5doJ0MheCjKG4AN6TSpdgIfeEir4+C/dKLKmn+yxdVzRd0SKq6EIVn6iE32umm8UWyzFeeNIKboSyCKM9m9u37q/+lJRjgOggzxrLvjwjnXwI1WFE0Ad1roVpXYOIKx+0vGQdYmWYZA1VJrM3AT2S24/YiWd5U72znoRl/ylHhIwt//QsKxM9mf74xTGOE9mIrW/zbnGVoyPSzNKxnph+Ek+VRIiBfw==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM4PR12MB5312.namprd12.prod.outlook.com (2603:10b6:5:39d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14; Tue, 17 Aug
 2021 07:53:45 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::c170:83a0:720d:6287]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::c170:83a0:720d:6287%6]) with mapi id 15.20.4415.024; Tue, 17 Aug 2021
 07:53:45 +0000
Subject: Re: linux-next: Fixes tag needs some work in the net-next tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Juhee Kang <claudiajkang@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
References: <20210817080448.3bc182c0@canb.auug.org.au>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <b604341d-24cb-8425-c03b-4f8c754b3941@nvidia.com>
Date:   Tue, 17 Aug 2021 10:53:37 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210817080448.3bc182c0@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0153.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:41::20) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.240.22] (213.179.129.39) by ZR0P278CA0153.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:41::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17 via Frontend Transport; Tue, 17 Aug 2021 07:53:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6c2a615f-5c87-4cd1-4df7-08d9615423ba
X-MS-TrafficTypeDiagnostic: DM4PR12MB5312:
X-Microsoft-Antispam-PRVS: <DM4PR12MB5312C23C10985E2228617CB7DFFE9@DM4PR12MB5312.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:167;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6c0jygG6zX+Jct+Smw54r/IpCL7Es8z/0/iFINOSOG1CbMlsMHAFcGZXx+Hh1sLwk94f4Z1tqH1sBfMY0DAGf48q54ZHPRBYOW6/U8QhzrJ7y+d6mBf7gvnYB0n4AKOpz5Q3VpRhrMzbyBysNIDan5J9OJLlb633kfyXOSJokZsm6MTI5QFZqftW5Z+X2uzO1/CXutxdbTJzv3Ub9hJn7irUdrJ7c62g16hGy4PKU5Xzn2jLtn4Whphg0UWkYqY+q+XoPILyZI0+7OL7GrooDKz+G1bTsG8uVGBkLEhRCZoFdUptiub4I2I2JajqRAiTV3RQqUHWzyd0lJKxB0MQ/FnG4Ky4CB+snBN4Lm5rubRW6au2NjxKRy2F7Q+z0PcjyWB5BzhuN7NM55T8lA25dTPHnlZ/ztA6sOLvKit836il1YsIGJXeU+JZrhnQYePVWGijaB8kHJkoD4zAmQrd9+iFG/ClnvUs/jJvBSdq/NUeYeugNWGzNFwOjXT+dCGt3nJ7o0yi1XhJKlctS3i6vnsjuM4rzW93tJS7b4KG6IgjHG+HC+2kTuKy9SR4P/RSrWSMc4dgN1Xc7QNtXuphYOFDYBS5sXgWidGXrTbYugJFWaDeQ1ruOb/cQ0wzIYqBv1S64HU320OOIetQqjYUOHSR4d2VEQZUOrO+W8H8vqm6Ndub66Mr+Umy0FNDegwjHP4nWeROVdUNazjin2kk4uIyluo85bQQNSYjbfn21Fg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(376002)(136003)(396003)(366004)(83380400001)(4326008)(316002)(956004)(5660300002)(53546011)(38100700002)(4744005)(186003)(31686004)(6666004)(6486002)(8676002)(16576012)(66946007)(31696002)(36756003)(8936002)(54906003)(26005)(66556008)(86362001)(2616005)(66476007)(2906002)(110136005)(478600001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?Windows-1252?Q?Pe84tVH/YkZSou7EoIBIrAmg+yS5GDzGC4Rz0EbL5HSFEA6Oj57t+Je4?=
 =?Windows-1252?Q?Sk33KCFXyxHFfkNVptGVXbjLxdRdLtr6GrdSx4nY2aGB3iPUaff76bIZ?=
 =?Windows-1252?Q?nlBu6yul5qozlKpqUsP1mN3EKWPRuV4zGdaLWOzxEcZ1i1xUqVkkubaC?=
 =?Windows-1252?Q?NIRzZbNsRAyfp+jUYzrXVBEl1glq9GCgkxAflj6HQBnp6021ddF2rp5b?=
 =?Windows-1252?Q?lzKhUbskA8qB/IZ1v2+/9hKmaFersWLolhKkEMUeYd3D2VytAkQDmYaC?=
 =?Windows-1252?Q?lY3DIFV2zgh08tb1oU52y4WkrGdw0s2e9mJH4JvrJWXrItS2g6jtr2m8?=
 =?Windows-1252?Q?0TopxD9mqSxETWSL9o/wKwjDTcGz8V4Q+/ejglhfmA/LUM2JxK7fyNyD?=
 =?Windows-1252?Q?/rZ2xGLQhXqf/7LdMDB6U38pPW6ZluaI2fOY6Izrry2er5MNYmGuMU4Y?=
 =?Windows-1252?Q?P30oe6RFKPrSvvLu/YEvU70QmFEj1WRw+XZa8HOxqbr7tZ+T0GNNbNsB?=
 =?Windows-1252?Q?BTZfLDKgHaPpu11AyHGohYOz6LL3qIGgSGIty0gf55DKxjWGl6YbiN22?=
 =?Windows-1252?Q?ZfP0ogIGfTBV0kinGzoDhMYu0yRmF2hBZ/9NjeVWlauYTz581CMGnySP?=
 =?Windows-1252?Q?EpVTrv4084dfUNAJoz7apYRrT02RQ1vv8Qg/7MXk33gkyb1x0Xzyte53?=
 =?Windows-1252?Q?IV3tszf4+718oOvGjAcWHssO1GA7mEhGJl9sHsOng4aYLqCzC9Q/zK8z?=
 =?Windows-1252?Q?M2y5ovJ2uLjaHHBpGqF3XTaSJQsIV3BxFIR307dFSbU5R6h3vSZPaaw6?=
 =?Windows-1252?Q?xBEVkugJjKyxHrKgq99szroPzjToMESaeUi+jL6qMQ9zmHDeZW5JvhHE?=
 =?Windows-1252?Q?NDbA6dBvdQDXFooHao4li2N3RPZ9zpV4C4fbOonOJVEwcg18jlzcVbqB?=
 =?Windows-1252?Q?XVM5BtznrskPBz+MLViVnBnK66NYLx0gd6i78hrZrAI45ASfdwA1o7x6?=
 =?Windows-1252?Q?RUMd2KH11fhw15prslDo6GEcFB5LM2D/jb0V38bTNvEiQLpnTnuYZ4Ik?=
 =?Windows-1252?Q?CnqaZHYRtjQ+OpukSp5tINgYaxjoTuCm5yfoQLe6NsyPFsYeYq7c4Vx0?=
 =?Windows-1252?Q?4Piox1+0W9UH3yRO4XPu/UevJsFNA++/FFERS5TkGyNEbXcYGHdLB53p?=
 =?Windows-1252?Q?gIGMJQKL6zhp36vzR1jQqLgCUnL8wJeVFiwGtfCyuQXY4rOKpkppar5X?=
 =?Windows-1252?Q?NSUBrqrL3jEPbv/TMmbxaSLNVBAr1RhhFLMzvmL7IeYKUUn+gaHY81z+?=
 =?Windows-1252?Q?iGPeggeiNFiQXYhmRFPyOc5QVUhTbvTZ+qUKaKGPEEZa+MU3tYz6zjDx?=
 =?Windows-1252?Q?0vIcJaDe++8qQqYVDgtr7ophq767CKrKr7dnSF6poWXv8tDBmNPxN73N?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c2a615f-5c87-4cd1-4df7-08d9615423ba
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2021 07:53:45.5579
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: djaArh0V9GZB2Fi9iDIuQjnreplqQYkdjeqQlGeZQqholZIB6KudgB+xrQ4pDcc26N3AQxhw7PzQXRmLfgaDxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5312
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17/08/2021 01:04, Stephen Rothwell wrote:
> Hi all,
> 
> In commit
> 
>   175e66924719 ("net: bridge: mcast: account for ipv6 size when dumping querier state")
> 
> Fixes tag
> 
>   Fixes: 5e924fe6ccfd ("net: bridge: mcast: dump ipv6 querier state")
> 
> has these problem(s):
> 
>   - Target SHA1 does not exist
> 
> Maybe you meant
> 
> Fixes: 85b410821174 ("net: bridge: mcast: dump ipv6 querier state")
> 
> In commit
> 
>   cdda378bd8d9 ("net: bridge: mcast: drop sizeof for nest attribute's zero size")
> 
> Fixes tag
> 
>   Fixes: 606433fe3e11 ("net: bridge: mcast: dump ipv4 querier state")
> 
> has these problem(s):
> 
>   - Target SHA1 does not exist
> 
> Maybe you meant
> 
> Fixes: c7fa1d9b1fb1 ("net: bridge: mcast: dump ipv4 querier state")

Hi,
Indeed that's what I meant, apologies for the mix up. I was working on my
querier state branch where I made the feature and forgot to rebase it before
doing the fixes on top.

Thanks,
 Nik

