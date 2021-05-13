Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0033E37F8DE
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 15:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234085AbhEMNhh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 09:37:37 -0400
Received: from mail-bn7nam10on2062.outbound.protection.outlook.com ([40.107.92.62]:13830
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233987AbhEMNhd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 May 2021 09:37:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cWf8sMQvha1WcJbGpJCudee6ZT6nufnVFZb3ylUifRnitcCXiHgM4IN6OwUMFURedVqsHosegmiOej72ghBXsD2pF3CsFv7Z0bBs+Dq6Yur3D3G3k7GO9gILrynn1zLJ6K023l+gg2qxhR8TOJOV2UbQ+s993zXt4KkWJeRxoe1LEUT9TNoRJggLune2L7d7/KE53VFnf5i6lVY+ckXHp9/Opg45XZsifSpci895RlOkXBG1CuDS5dXUDpZrRKhWyWQfJa8r1AjAO6C2Xk21yv1wkMhZYUYYl21Ie0hHTdoXOcwuyxHFlHr7PPH7xCQMnHLzLtafMdHdmAXz8eqyxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8mwNs9sbMiT48/yC3GT4P2Ahj6pFfoxZdiE2CUrDVtA=;
 b=R7lzw8ZqrWU+f/taT0P/BqD+eZ/cMEzgMgahL9M+gbZiGw9dSnovjVEKyQy90WxBbWt1gzdnD9+rDJW4rfr7Z2OXoiRYK1lc8D4nlQWECueFINnnh1kkzxuzIkRjDOA3wvb26TrW63G4cJXROtBRGm+IlYyUA4cyx9gKBy9ooAdc75YYC1El2VzxKuNXtmmHKqQPNSRh+jCWQRSrqXcOmMLUMAbvItM9/k78Nx0hQpuhkGx3DIsN/C5BXY2yOkpuurxeN1MGq1Juxltg6jZlIaAFmyutwqv9kilrRbMe5g1TgG8Qk4M7ZExPwj2LabUcDFOKsJMFjEQct2uuWzhYZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8mwNs9sbMiT48/yC3GT4P2Ahj6pFfoxZdiE2CUrDVtA=;
 b=G9LiHN9YNIb7MAzGh1DyFX8MDFHhCyZs1BIOpnbIley/mBaNbReGa6yVS/d5uuCnzmioRVOeNRDly8BBC/SbCYdc5GUEcjtzq70xmvjZho6BGQ8W6O1LMtwmiiy1KnOA1kG6/tnDh8mMKne2oaxPsTr6CMzOnxotgzzH5NcdWvU5XIWziQ55gOMf57/wYzhykefoKOyATFNjh4wPpDT/MP3D8XDjp3QIc40ePvi9gOmUvZPS8LUHOAsV497LFwsGJ5Fl+jJ0pARDca8YVPYnQYItcvQFlazyIieEWYPgpjXkXeSthXEL8P2PlLazao3Cp4W2bYJMFJjEl2ZSWobacg==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM8PR12MB5463.namprd12.prod.outlook.com (2603:10b6:8:27::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Thu, 13 May
 2021 13:36:22 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::d556:5155:7243:5f0f]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::d556:5155:7243:5f0f%6]) with mapi id 15.20.4129.026; Thu, 13 May 2021
 13:36:22 +0000
Subject: Re: [PATCH net-next v3 00/11] net: bridge: split IPv4/v6 mc router
 state and export for batman-adv
To:     =?UTF-8?Q?Linus_L=c3=bcssing?= <linus.luessing@c0d3.blue>
Cc:     netdev@vger.kernel.org, Roopa Prabhu <roopa@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <20210512231941.19211-1-linus.luessing@c0d3.blue>
 <c5634f19-f9f3-5966-a5b3-a0a64ca4534b@nvidia.com>
 <20210513133423.GB2222@otheros>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <81f96696-67df-798e-ebc6-ba11f5dea3da@nvidia.com>
Date:   Thu, 13 May 2021 16:36:15 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <20210513133423.GB2222@otheros>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0022.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1c::9) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.170] (213.179.129.39) by ZR0P278CA0022.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1c::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Thu, 13 May 2021 13:36:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fe14b179-338a-4849-d959-08d9161418f3
X-MS-TrafficTypeDiagnostic: DM8PR12MB5463:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM8PR12MB5463913784E0892C4F274FD1DF519@DM8PR12MB5463.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vdYTCBF1E21VvYvdZcStnTD7faKzO+G0KKrOVxmXIGhQ5RFs3AuhdOPfs5oynXK4aBFP6trdmN36mAYNqMxI4wfEQqDMCdapUDqhmAninFKvDN0uS2Y0UKOU/XYGIrJLWOpxhwnycym1qwRtI2TdzVn5b+1fBAr/hcv4lhF19dJ97nh/ZqBN1mz9PhiiruTHM/fGgYz7jAyvjzmf/d3bn9MGn4RzmlLZwdlUOPGiaiaif2mg8AohfoAGi2t5f96Hn1fTyJLX0OJvAuvy/z9T8Qs1rlZLWV5VZYTGg4KocekEZQI/Bb08freR+7FV8T/7++HpRFMiymi6F/YRIRGTBjbSx1ugXvs5DJppW5beodD+CEtiKIsc0kzg6LyyNXPFTvTZRI6yLL+NLaHLIEfc+luAqkcXBXGozUKDn7nLsmDGYXUn+S5PiPB4E6OeeHo8pRsCHMB4G+dadqo0qsxEYFhobZzm/Ny2+QRASN/xHrJJkM57n+eQjyeHHRLgXp+FNzoQQwSm13k/d70A75eDhIIdRFMaYuKHLvDd3UPiPbNBUHXg73elXAcxYAMobkcS270zItYafPKaKCObtMCHD4TsY5T+aIfLFqMrkyFaDtWdeimbX98zsaoiKn723QQ6qHxGHlNOCwWozYX5nIZSL81f9OEhsWNplU0P0SU3IGZMpR6KXE00Svsq3N3J4efUWEcH96HZaAi1DAFJwEqnQg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(346002)(366004)(39850400004)(396003)(8936002)(8676002)(53546011)(26005)(4326008)(66574015)(4744005)(86362001)(16526019)(31686004)(186003)(2906002)(66946007)(2616005)(478600001)(38100700002)(66476007)(5660300002)(36756003)(66556008)(956004)(6486002)(316002)(6666004)(16576012)(54906003)(31696002)(6916009)(80283002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?SWx5R3NXTFhKOTlGUXBzWEczOGp6RTdsS0drVmMzQlZSMHRHR3lUNTNtYUhj?=
 =?utf-8?B?TVMrTFBuVG1TZ1JuaDhqbERodDRIOUxod3hGaEE3dkZ6SUJXUHBKUlZTRGdQ?=
 =?utf-8?B?OCtUdE9adkRLeHNzTVl1bFFKenB0UmhUaExoLzdOSXRBV3RCdjJsWGJPVkcy?=
 =?utf-8?B?S0lucjNRRGFHaHltcUZ1OGRpSUxCaVdzSnJPYVZDa0tyZGdQVHJaTktQUXhF?=
 =?utf-8?B?eUJjc3k2QWJrV0M4NldQT3M1SUMxVlJGSGw5Nm5mSVFMKzJIam1iNG9zN2g1?=
 =?utf-8?B?RnhsaFZaMW0weFlydER2Smhsa2owdGhReWNEVms5Sko4RUpjUVdnYlZuVVNh?=
 =?utf-8?B?Sm1GNWJlTjFaQys4QzdSZzQ2cVh0THhtSlBCSjhickU1T0NOMHRqcGRaTkhu?=
 =?utf-8?B?WURRQmxBL01kcUpKbmdPYzNsQWxjOTNnSUt5OFo3UlgrMXh0dndRTUxYVzFP?=
 =?utf-8?B?VEtJOFFYTFJLelIxSmxtL1BKNXQ0Y2kwTmY5ckg4Y2JmSVNBdGJJZDNybWNF?=
 =?utf-8?B?S1JwZThGNGVXc2w3NGdrT1pWVSt2cGlzVFQyQXBHM2FFV3J6M1lwdkR0REhS?=
 =?utf-8?B?UFl5OUl1Z3Z2QkpCY3E2eVA5QmtFQ0FDUFZNKy83VVBWN2FKb3pBdDNRTFQ2?=
 =?utf-8?B?S3k3cXA5RFFHWktjRU1XYjRCTWVJTUNJbXJ1U2plWFJ1OWprV3FQQ3E1Nzhv?=
 =?utf-8?B?U0ZZSFhvTWhMa3A4ZjZJVm1IWlZBTDcxaXVYa05aWU14aVo0UmVEd1pVa2ND?=
 =?utf-8?B?Lzl5ZlllN2lKOWNtV2o2NEJmOFRUUHlTcmtxdEhzYVEvcG50YXdTeGRsRkZG?=
 =?utf-8?B?S3Z3SjhKdytPUFUzb1NCRURKK3pzWWN2S1hYdEdnTUlsbEMvRm9oeTBXV056?=
 =?utf-8?B?S0o4aEltWFB1TzArSnB2V25RY2lNTHI1Tm1VWFFEWlJwT1FqODZsMFVnZmsr?=
 =?utf-8?B?bkd6WU1vQTNwNUNwRUZwb0FaeGtmeitMWDFpTStjK2tqVnRmMmVHUG8xWkRG?=
 =?utf-8?B?UXNSaFBjQ3YzdjUzYnJtZnNlc04vV0lKVnRpNkhTWEpyRzQ5THVaZmJpL0VN?=
 =?utf-8?B?ZVlBcThPYmRvMVIweFJ2c0VnRFIzUFl1cmcxOFkvNVRRNE5wdEVlenpGamQ4?=
 =?utf-8?B?anlmZGFYRmtDcWNhRy9yVTlqV2JYMXNpOXVEaFpYL2RnOEJZYk1ZSlpZNU9o?=
 =?utf-8?B?M1cxMVN5WmRGeXh4N0N1cnp6Z0pWMGlrMVpxaWY3VlNNNXNjRTdETllCcE1t?=
 =?utf-8?B?blQvenRRdXpvR0FwYzNIM0lWMG9vdGZTT1YzT2NhTGpoUFhLcURzWXdoeENU?=
 =?utf-8?B?b0VhS1FtL25LejNrL0U1NFVOYW5xbTFNVmdKN3VpSjNNWVRMT0hQekFFRjd0?=
 =?utf-8?B?MHZWRk9LZXFSVGM1QlNvWDl4U0lvRjN5NExHUkN6OTdjUGtOTzk3NkJoWEhz?=
 =?utf-8?B?b3hDWXdhRkpNamduWTJSR2FiUFBDb3Q4Ym9TYzRlWkZ1SndZdkd5WjZuWlZD?=
 =?utf-8?B?WEhyQTFMY3NxNXNhTnUzTTA3ajlsVHlDajZRVlduaUh3ZWllbkJiMi9acHpM?=
 =?utf-8?B?WW8rdkt5WHBKbHZpNlFLQk9SY0F0eGRSTDgxOEwvSjhsQkE3TDdMZUxDWTZz?=
 =?utf-8?B?bGFNOWY3S2djZWVjUWZjelF4RjNaMUFWeDVFb3l5YXQ3cTl3ZEZqeERLc3l5?=
 =?utf-8?B?YVhhMG9rek9TVUd5Z2M5cWJ2VlMxNm1XRDBrVFo5blFIUFY0bzJVK2ppS3FQ?=
 =?utf-8?Q?5xoPnTNCihOytXqSQIExl9sMd2ZuJ4kv894C0yR?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe14b179-338a-4849-d959-08d9161418f3
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2021 13:36:22.5537
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cNXCDJzPoAepd4cgRViLULZHzf+7Z76p6p3qXz7MDvDBnD6lnDSuaKUQ+peFGabDREIL1x+79wEZa+2D8gHVLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5463
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/05/2021 16:34, Linus Lüssing wrote:
> On Thu, May 13, 2021 at 03:02:13PM +0300, Nikolay Aleksandrov wrote:
>> Nice work overall, thank you. I hope it was tested well. :)
>> It'd be great if later you could add some selftests.
>>
>> Cheers,
>>  Nik
> 
> Hi Nikolay,
> 
> I think I found a way now to better deal with the protocol
> specific hlist_for_each_entry(), by using hlist_for_each()
> and a helper function, to reduce the duplicate code
> with br_{ip4,ip6}_multicast_get_rport_slot() as you suggested
> (and also removing duplicate code with 
> br_{ip4,ip6}_multicast_mark_router()) and reworked patches 7
> and 9 a bit for that...
> 
> Sorry for the inconvience and my bad timing with your reviews. But
> thanks a lot for all your valuable feedback!
> 
> Also netdevbpf patchwork had a few more remarks, they should
> hopefully be fixed now, too.
> 
> Regards, Linus
> 

Awesome, I'll try to review the new set tonight or tomorrow at the latest.

Thanks,
 Nik

