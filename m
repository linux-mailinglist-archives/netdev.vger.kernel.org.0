Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BFB737F6D3
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 13:33:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233422AbhEMLfD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 07:35:03 -0400
Received: from mail-bn1nam07on2041.outbound.protection.outlook.com ([40.107.212.41]:43318
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233437AbhEMLee (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 May 2021 07:34:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UJBe2FdXZMqu+nIWePqkUFh5gSekOtH5OK3nWdPM3SBLbY66coF+98Nt1VZDug0NhIWPa5zyeIBmRrKYVFmf0DxV2A5bg1IlawEYEU/MU7rSK7xiK5FP5icCUX7RoHfHrYbnLZPvogUXBiDiOTUaR/oovWfHcjENoTMotPO2QuOkJOU88EGPsYeCP+sKoZAgWJknTf+WhU8qLxgsMhLhIlgs9x8CP1PY3tHWTbVk0rYokOvMNGtzPIxFG4RryaBoA98mPSpR2rVezExevM0rQhWP5lprCwEHTiqC2sHm/iJ7D1Nf0KHLQm08IjDSWo1EogvBubFy2J9oKCaB6/WkxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qj+idjaX0Iz73ZO0iuV16GW98NGx46EosyA5C19uKeY=;
 b=TgBFwy2xV3v+u6bOyV6bn08ie9KjEx3vHJOjBb1QJyEe/k6l/m0+frchQdkiP+LT8BO6d/f1ptn4xycPc/EL+V/x0GmzBDP84sPqgSvVrUJZVCJ9WoQQgZlpNkxRfrzRT7UWyxy+pk4gnMup1y5vH+euH4x48u6POeVcvxUK4hecylFHZe+Ky1J+p1FsYA27hrsksimFvdNqsrxXbBvCvv/VSVTck5pO9SQ3zpE92iz/THZkWyv6pj4IFHmxJwX6Rsa9jy14jMMRfjd7U1PsKMCgU8O1nH9RtLsMM2Dt9BCsQPZj7ZK39E82D9kGSLEgRc6LWmtAAcun2fG97TZGlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qj+idjaX0Iz73ZO0iuV16GW98NGx46EosyA5C19uKeY=;
 b=XZNwF+iczITK5TcGksNCsH4HrJncIpHS5+R1VBSK1YAB5c6bz5MssA9OWiRDOAmSXYi8uOdxZdZPWK+52r6rgADdXD7XIgaURPQNMcp7g461qCB9AkZAx4vR+guybLvcqgaDx24seO5g52qM2pkEJIHE2F+CI8R218h/c6JVQqs73FgZ70dVgMK8b2zfP4qoPKRlgHbjishrcEkeGwc2TedlVnfcLf9a5QAg+Dy1c/czaUDMQr0QOjGdiWeLRR4lWev0tQfSe2Dhc6CPeT6WrOmpYqfDzV4v7VSkgGi4mDe2XuMCwyweK700W4sWOP/Czhe9yDQmHaAXflDBzlRpkg==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM6PR12MB5566.namprd12.prod.outlook.com (2603:10b6:5:20d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.27; Thu, 13 May
 2021 11:33:21 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::d556:5155:7243:5f0f]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::d556:5155:7243:5f0f%6]) with mapi id 15.20.4129.026; Thu, 13 May 2021
 11:33:21 +0000
Subject: Re: [net-next v3 06/11] net: bridge: mcast: prepare expiry functions
 for mcast router split
To:     =?UTF-8?Q?Linus_L=c3=bcssing?= <linus.luessing@c0d3.blue>,
        netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <20210512231941.19211-1-linus.luessing@c0d3.blue>
 <20210512231941.19211-7-linus.luessing@c0d3.blue>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <7b47a9d8-104a-ca57-6550-df0105c72993@nvidia.com>
Date:   Thu, 13 May 2021 14:33:14 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <20210512231941.19211-7-linus.luessing@c0d3.blue>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZRAP278CA0011.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::21) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.170] (213.179.129.39) by ZRAP278CA0011.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:10::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Thu, 13 May 2021 11:33:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7bbca84b-e68f-4e74-3d9f-08d91602e944
X-MS-TrafficTypeDiagnostic: DM6PR12MB5566:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB5566851173D7F41AC71A6770DF519@DM6PR12MB5566.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IeM6MygHb9A+IAjQNj/3yaciI6gp2mZuaejEsiRr7YlUMXr3xzpn0LcxMJfoovbr4b4hi6HsvTeHGUSyms2Eod8i+Tlbv1vHrrVSOVGbgCev7YDHK267VXeLP+rWy3PVkSD6JTO7ILvO74YuEpH3fVG0FyNipC8CRBjMEVAohFbCxLabWU2+DtSgtrpYAaQ2vHR5Fc3MQEQ9z9DG8FRRTtYXKTP70uUTdcrSlQQsAR3wMwPefweIq4mFYUToKmezeKogghIPSFxPBU9iBoJklNoRvk7V66ZEegYBUfXA5GyJbdBCd1dguRZ9OF6B0e5W5ozP68Jv7w6HZxQTu+05b2vL9H8KMG0nJy+006KkDzpVojZPVcRVOwJ47qAT4AXhQHLsvoJJkpAgyLy6OYe7K1k4SX24bHCBbkvd/qsgD/rsyA2RVqof/si3ETnmo5Hk5rTC7bFej911ELDCz2WjM3g7X97xGisx6y0I/i1miErRWXiLgwOUuLdrMAU3YERnW/+JB8Y9nL4CQfZiztzAyyIbF/lITazKbtfMnclqOZogYREhVsRTTqidQ7ua8uEZeOs86kjM/E2U/vXTlyx90nYXeEiwDNexVXzxLknd+om91kSB86DGotagg4+N9yg/4AzbDmHiksRZLQR2C/w9DaR6dOPgn0lt2p0/sU2NZnUo2HQRUlqVGlIl4g8nKLf5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(136003)(39860400002)(366004)(346002)(53546011)(26005)(4326008)(16526019)(186003)(36756003)(2906002)(38100700002)(2616005)(956004)(16576012)(83380400001)(31686004)(316002)(54906003)(4744005)(86362001)(5660300002)(66556008)(66476007)(66946007)(31696002)(66574015)(478600001)(8936002)(6666004)(8676002)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?T2k0ZlJ2bmpsam5tL3NqMTE2Q1VWVy9HRkhnZXJMZ2crbE9WR2NyTVd0VHZm?=
 =?utf-8?B?bGxLamFieklMaUllNEZDclc2WlI4NVZ2LzA0ZVVEQzlCM1RRNkpTRUFmaCtH?=
 =?utf-8?B?ckpGeCtITmlkcldwMTlIRUFaaTN4VkI3ZExjaEF1L0krUXpFUm4wVk9yTS9T?=
 =?utf-8?B?bWc1blBXbTFTeTZtN21DWGkxQ1VEREZ6bUdpZjk3S0RyTzhQUDl1T25XYTJx?=
 =?utf-8?B?dEYxamdadWQwWnVNcnY2UHVaWGtpWWlTcmhxZUdVb2RkK2NDa0V2alYxaUE3?=
 =?utf-8?B?VnhSWVU0WWFZVEFLYSt3U1Z3NHlQK0k2RmdNV1VUUS9rSWJOMFIwYmtBclVD?=
 =?utf-8?B?K3V1V3dUZE5NL3F4VEpxblNCaDF2YndiTXJwVUpwU3NMZzV0WTJaWkpNdkdm?=
 =?utf-8?B?S0tpc1BaalpnYzFRUnY4Nm02ZkE5M3pMMUdEZUZseGhUTUc4MVJSY1hqVld2?=
 =?utf-8?B?RVNaS25qUVA2UkdhVU1QVjBkeXFCc3hBc1pHYXZILzZCWkRXSUF6ZTI0Sm5V?=
 =?utf-8?B?Q3VON3UrN004NWNVZStMVWVXckw4QlNLcGI4OWNJMCtQUkZrYkx3c1JoK2Fx?=
 =?utf-8?B?YS93cmRheStoQUVDRUltTkdPcE4wQW9aU2U0VnpYeEdnZEdpMWRsUzgvYXUv?=
 =?utf-8?B?cXNFOVFKN2YwWmh0eTJXRzh5K1hPdWpPUFVqZEUwWFF0WHBSUTJZajZtRWxM?=
 =?utf-8?B?N3V5OXF2bk9oTEU5NXdKa25FOTFwSFcrOGVuSGNqNWNabzR3MHFBUmhoZDkv?=
 =?utf-8?B?UGpFcFJDRHVnSFdKZFdNeHRIcGRqWnJqVVg4K2dsbEoydkxmNHh3NHpiNVlL?=
 =?utf-8?B?UWlvK0lnUXZib0tzcVpuclhWTXh2UmNZdWc0RmxJeEZVUGJOV1g4WDBIK3BF?=
 =?utf-8?B?MTdicjRvNGtGck5samZBaHZMOVF2dXV6TmxxWFJWWlFqRGJiMXNKOWpqaklF?=
 =?utf-8?B?dkVYNldveHUweDEySnA3Z200aXJTMEo0L1lhQWVjQ1M5aFJaSHgxQlBidHZE?=
 =?utf-8?B?OTJQbzB5OTR2UW00dDFnaDR2M2E5YWYzRmNwbHNRNDhWcHpCRjNlUlVnMmgx?=
 =?utf-8?B?MTFKQzJMVytSZk1ic3RMUXgrN3VyUVN1VHplUU9NMkNrRUFreHh3dkVPYTZD?=
 =?utf-8?B?VnQ3bFE0VWdLekVxcmJ0ZXRkSlozTk5JbG0rcmpuZHRtV3FpeGxqQU96SmlV?=
 =?utf-8?B?eERWeDdrOXQ3M0tVNFE5MS9KR0RMeTA4eTltS0d4ZmRVZ0dGSml3UjFiVWdK?=
 =?utf-8?B?Q09wZ25jYThlTk1tc0hoaldhSEcyT2VmMUZFQW9IY1ZZOVQ5YWNtVE1WSytX?=
 =?utf-8?B?YVorRm5JNlRkT0VmUUd2RUZWWkNwdXJ4UnJOSHVuOGJRa0hFcUhFS1lmZFR3?=
 =?utf-8?B?MWh3MkhXTVNEaFJwRUxkcVp5N1pyZzhrQjRqRUZ4dTNudjQ1eEViK0JRbUN3?=
 =?utf-8?B?YVNnblVzTjNlMGVlMHZEanlYQzJiQXgySjJIbVYxcTIxZEt2Q0V6NVYzczlk?=
 =?utf-8?B?SkxiWXJWMUN5NXpSNjM3WGlROHU3S2c5QnM2WmVYN0RKYnNyN2I1dnRBVzJE?=
 =?utf-8?B?WTlYK3YzL2lxS2RTMEk5cGthZWVUbDlhcHFvQ2F3eEJ0ek9KTTJzQ0pnWDY4?=
 =?utf-8?B?V3BHVzNmZEV4aml3M3JwUERad3UxdVVjN1VzYzlmS2ZJMGhNZElaWEVVYTZM?=
 =?utf-8?B?OGsrUE1QSURjWnFEVytzRkxpT3JKQ3pXZ3RXZVRwYzQrM1BSSHpJdnRyTU5G?=
 =?utf-8?Q?LIdbdVqP1l9yU8tgEUTzrbgzVyztYOvE5AQb1ES?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bbca84b-e68f-4e74-3d9f-08d91602e944
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2021 11:33:21.1872
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6E1RCHL5R7fHzTkY9aS0d3pgQs5z2oQpNXYPNRqT53s6jeuL9bMoj9ktkl70eF1D3gUkQqrVIBvl4jj5z8pyaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5566
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/05/2021 02:19, Linus Lüssing wrote:
> In preparation for the upcoming split of multicast router state into
> their IPv4 and IPv6 variants move the protocol specific timer access to
> an ip4 wrapper function.
> 
> Signed-off-by: Linus Lüssing <linus.luessing@c0d3.blue>
> ---
>  net/bridge/br_multicast.c | 31 ++++++++++++++++++++++---------
>  1 file changed, 22 insertions(+), 9 deletions(-)
> 

Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>

