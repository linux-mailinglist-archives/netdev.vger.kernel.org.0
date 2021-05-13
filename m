Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1781D37F6E7
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 13:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232442AbhEMLkH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 07:40:07 -0400
Received: from mail-mw2nam12on2070.outbound.protection.outlook.com ([40.107.244.70]:3040
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232449AbhEMLkE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 May 2021 07:40:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GgWj2XFLr9Q9FeRMk9zhM40EGgC7QMoe2cYkFuu1CvEcRKbaIMaPddeiNOQGXYujty9KZUec+rL31SdGxAJWQidQH7mHbSZmqHt2BHq6XuwNEwl7H/uHd99IWG/vCp6GE9yEHYwgs+XjgJmxrxJFaOnh75yp16UikdtCT04N7kSsdiiepM0uUt9FimXugRk7wDaubDPIN5jzPvy3wBopD5+FBZHzHbRT0kJTGssneODguGGBkGlmHwNt+yekjZhmvpKcctaUJaVBWHzqcSFPpFpprdfeAz9nIUzF4cKAAHOUeULLUUPTYmQ/jc6ENMN+4fVOikmL4svqHkOB6xsV7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=821CA3IEsc2LKjYWxGMByAa504fgsyB8kCPnI6BBCg4=;
 b=HeBBZGTPl5AZ8gGtxBZvMuM52q50EtnjUTMC50tLRdVYyeUhgiHxhowc+3hOp+M2VGUPuPlVX84ofjzRiWCSP3dAWAo3FSZX8FdIjSI9V/dK8MsNEt37YsPFIC0wMhul/FAJQD2eVRU0ZlCaojjeGa8brDSFx7rIit39nmsfOTwTxNMSUTP8X6+wCc99AUQpmAmLHJj8SO7z8Vtjm3TDlyYBKcmI/gRtJdxQ4s8OkPVEj8AOplTm3r81bwkoMEg2x4+yJnutB9Bl0k9f2tkmX5nsxuc5UBuUFeyThe34Ly3G6R+k4tYL8e65xHaqtEjsBFMJmfF1/OHVbh9h5RWBaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=821CA3IEsc2LKjYWxGMByAa504fgsyB8kCPnI6BBCg4=;
 b=a/PBizmNf01GU1MUpJy7IBAvw8uuN8+b6OtTB+JvXBE8YrUv141wytRE3HaJMAWx/mJoxti5293GTdfsUJv1zKv+8sKtlM7mZ0UEmv7eVxiQigzrO2m+qyw347E7P8uX5Y9jj0Hp8weOjdbUmZQfi/OvehswGAlTOqZ+xePHDMCajrhN7WipUEF7NH8M6FbsRojmm9oi8wVMrTfBrf3IX5fg1Jr8DPe0wnfHLQVlVotXH2lL+qNzu+v2E4l/N+mBYwijK3WrR5f2i3yQ72YYUWwxFAGS/ffmFI+AOctnoqxqZ+DyMLMxtcTMG8c+/SmHNkftiK7AWqjGEFUasub/8Q==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM4PR12MB5327.namprd12.prod.outlook.com (2603:10b6:5:39e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Thu, 13 May
 2021 11:38:53 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::d556:5155:7243:5f0f]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::d556:5155:7243:5f0f%6]) with mapi id 15.20.4129.026; Thu, 13 May 2021
 11:38:53 +0000
Subject: Re: [net-next v3 10/11] net: bridge: mcast: add ip4+ip6 mcast router
 timers to mdb netlink
To:     =?UTF-8?Q?Linus_L=c3=bcssing?= <linus.luessing@c0d3.blue>,
        netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <20210512231941.19211-1-linus.luessing@c0d3.blue>
 <20210512231941.19211-11-linus.luessing@c0d3.blue>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <c2f37f1c-61d1-726f-a122-844616531763@nvidia.com>
Date:   Thu, 13 May 2021 14:38:45 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <20210512231941.19211-11-linus.luessing@c0d3.blue>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0132.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:40::11) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.170] (213.179.129.39) by ZR0P278CA0132.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:40::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Thu, 13 May 2021 11:38:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bffe28ac-a5fe-4c72-2537-08d91603af18
X-MS-TrafficTypeDiagnostic: DM4PR12MB5327:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM4PR12MB5327EDC2032FF237766F0ABADF519@DM4PR12MB5327.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KYLSiaJROIQACBWAnKTGZ2WAJeGINS1xthLbc3KpyIfPNUm373/h5hMcmfHfeeBHwsC8Ox7qJ/+fa4dfDBnbOydEwUe2Qk8YjDSlrGNSLgUdbkWO8LQrCn02nhB4oiXLvY7GnG61LgPVXqST5Q2/d9OPifx1qvwh/GgI6VGDCDQwIUxhwGPgFj6hXxZrnL1g/RbLivYUAhiGvNBYrSggR+4d01CxXM9hcUsJXk1lfYMyD96VwuEbLjenE0cCF0nwUToJUhAJdSSrrA0QRr0qAiMUMTGwALVpzqaj9q8wrXWpvZAUQ+AevDFBsJNgprgs/lwkpXJlm5vwQCjcr3wwPPhmDn2zQnD1rC0A0F7e7fiaIFq+hpp3jOT/7RRmrAGfbZnAGe3SICRqdihrT7JeHA1OXxKCI5c6pvfe/pYahqfhF1LWVrpPEuNmcDRs1yJwwnEW+BwOjC1gxZXB8dLLSSje887biwekY6WBMr0JhjqDG3r0b6kdB7YOdCRx6JxgPO8zPBtnXSTHWspiFdGc3TP4V7OIMu8dGmghPdvfd5YqILMjqqSjFvPdDPdZl085965bBTpR84JNTwXTkkph2DXHksbYKOnR9Q2NcoxPLoc1a+1MakxtbDQfLQRVXxTJIui926WCgObhQa+MKr1y/1uhb53pXGpZW9sPxLfxo7pAOMG4aCnIF2yHZ4JcvsBr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(396003)(136003)(366004)(346002)(31696002)(36756003)(86362001)(66574015)(38100700002)(83380400001)(66556008)(31686004)(66476007)(66946007)(2616005)(956004)(6666004)(2906002)(4326008)(16576012)(316002)(54906003)(8676002)(6486002)(4744005)(16526019)(186003)(478600001)(26005)(8936002)(53546011)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?NUZaNG53UFFMZGRzVkhsNlJRM0pVRzdDZmJYeTVnZ2hpZi9ueW44RHNrbVdS?=
 =?utf-8?B?UVNGK0RMNU0vVlNMeWRrWDR2d25uTm91SWlaenNhaTRuaDdUWTZCcXdyYzFX?=
 =?utf-8?B?VU8yNXdOMVZ4N2YvTzBBYXBjd2g5MGYrWnJsR1lGTUhXUmpFWW1pK3RETE5N?=
 =?utf-8?B?K1NNcnAwSHRITkhITlJtYnhQa0poejdwOFpJWEV4bmlTQVc5ZmtNdytnYWpP?=
 =?utf-8?B?UWE5eENudWIyZnJGUFR2VVVBRUVMaHBubDVheTNoSE1iL0VyeVVyM0ZYR0pM?=
 =?utf-8?B?NnhSUHlpdzFyM1NpTkswQnJDK1NwMmpaWGFHSk1RcjRZU2VRK3gvVW9wQzhF?=
 =?utf-8?B?aWx6WHk5RTJhRE94WjVjUWpTQ3p1RUxkL3RuYnZLMFUvUTJERlBMV2VyWmZu?=
 =?utf-8?B?M3N0YktVM1kyazJXT0lhMkxVUm05NHJEeXFiUWxIbWhHelc0TDQrSlZQTTVH?=
 =?utf-8?B?ZkRYV3VxM3Q3TnVIajZYOTgrV1pSWDRWbW1NVTBBaGdhVXpFOTArSm5vSXYv?=
 =?utf-8?B?UGhkWDZ0RytZYjhCT2NSek1iQkQ0V3B1d0lCSHlwZG4wU2dzOHdPa1RnMVdM?=
 =?utf-8?B?SzZkeitJdXprc2tqNjB0TEJ1UC9qd0swQm8xbzdvdlJGYmtJZ0ViQUtuNEcx?=
 =?utf-8?B?RVFZbkpnYlV4azEyMEtKOVhZL1p3c0gyQTNkN2EyQWsyT04vWHduVlZ1Nldm?=
 =?utf-8?B?d1JLRlFMa1N4ZkVtUG9UN3BTRkNtL3FKNGozdzU1MnNMMUs3RGRkUDNNTjdo?=
 =?utf-8?B?bjhsUU1XTUJnbTJkY093UDlzUU5RNEtTb21vYzNRTzhDZFoxd0p3QXVEVm4x?=
 =?utf-8?B?RndnMnQ4YlpuWnduV0JWZDl6UUFVdC93UlA2SnEvMFlucHBXa0JuckxsdzY3?=
 =?utf-8?B?UUNIME5nd1Nwa0pqOUhhWWlsUExVb0R1cndDdmk2bEtWQy9vTERHNEsxcm8z?=
 =?utf-8?B?K3lFSFZKRjFobksrdUZUcXUrSlNkVmhHeXNtaGc2OWFlZVorTkpEOElWc0Jo?=
 =?utf-8?B?VWhlNjZQVmFPZHFZTVQ3R0ZVR1Q1UkhmZGtTYWZJZkExYzhiVWxFQUltNHk3?=
 =?utf-8?B?cmJadER5YXE0aW0vakxkNENnanRJRzlWbDFXUjNLWUV2ZUFVRkIxM1VDMzk3?=
 =?utf-8?B?K1YzVkp4M2d1RGd3bDI2Z2JHZjdjTjB2QnRBYTVsd3oxZ09kSWJTMmtLandU?=
 =?utf-8?B?dHlTRWw4STh5c2NaL2gwUFBObTY1UkMzTTJXV0NLY2VKSVBuMWY0cys3K1V3?=
 =?utf-8?B?TnBFQ1dvdVA5Y3lrSUdmRHdraDBPZ3ZjYnFHWklraW4rWnEvZlVUbkFlUkdE?=
 =?utf-8?B?eHVZS2lOTUFISEJCUzhmeXNNM3ZZWWNWbGxyKzd5Sm8waGF0UXpKUllHcnFW?=
 =?utf-8?B?c3JPSlBGMzEzZnpRQTQyVFlpWEJNWHRud3NtSmJuYituQWZUQVkyRFNqM3FB?=
 =?utf-8?B?NlhBWU1IcEdpaEVpRStyM1hrZ09pU3VsSkd3Rkd4eEMyRi9tVG9rTk5XVW9y?=
 =?utf-8?B?T3ZuY3JCNGhOYjhGdlR5M0QxOGRFMjhSeTNaOFpHbERkTm9Rd2gzMnJTVEpO?=
 =?utf-8?B?WUQxNFdPdzNGTm1SWHpyN1pSY3VnaG9NT0FJaVA1b014b1hFZWtRUHZ3d0o2?=
 =?utf-8?B?Z01VaXE2enBWVHBGdVFWWmVoNTBaMnVMZkdNclJJSHNJOXZ3cmJSZ1piZHFT?=
 =?utf-8?B?MHk5OGtHSGJjVitOYjdzOEJoUzdhSnBsclR1SXZJS0plNXErZldOdTZWOGFC?=
 =?utf-8?Q?/xP4V8f9YVyN3LOoRRJ7ZFNCoz5fPpkrs30ROjc?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bffe28ac-a5fe-4c72-2537-08d91603af18
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2021 11:38:52.9188
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: udt70FRDL9wcSS9EqGgFfuj5wGYA8+NLIAWbQl6G6Z8YQTvRuDNiN1Xr8OaEWYO9KzmFSM+nr3QsN2aC8HjvDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5327
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/05/2021 02:19, Linus Lüssing wrote:
> Now that we have split the multicast router state into two, one for IPv4
> and one for IPv6, also add individual timers to the mdb netlink router
> port dump. Leaving the old timer attribute for backwards compatibility.
> 
> Signed-off-by: Linus Lüssing <linus.luessing@c0d3.blue>
> ---
>  include/uapi/linux/if_bridge.h | 2 ++
>  net/bridge/br_mdb.c            | 8 +++++++-
>  2 files changed, 9 insertions(+), 1 deletion(-)
> 

Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>

