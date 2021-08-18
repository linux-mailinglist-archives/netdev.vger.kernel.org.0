Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84EA03F02F1
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 13:42:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235818AbhHRLnY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 07:43:24 -0400
Received: from mail-dm6nam12on2044.outbound.protection.outlook.com ([40.107.243.44]:64416
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233798AbhHRLnW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 07:43:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pcrl3GMOq3hTMr/OKfjOxqvxr55mZ5PovtE4LpMA5WKtZ1K0iNpI+Q4ec82BRzzsGymolPl6hFAY42QR0N93FKnenLu1EAAwfBfeXbYwvgnx0KMUfowKbrCe+hUtb8/tjLAoJCE08VQIv5L+DKsQ1rhsn03gCUcbm3kprI8xv5gqp2kEZTpO0mcXn/Q5LZU+Iw04Rdzk6dNd1C/Gt6xWRed3aNOobPv69Nkp0jeYWLyOJS5tMfrWfg/hn+Z78Orqlp4qXs8WrAOX025hVsniihodEQPqtfTnORrJZu2Zcc1jYugMTVjnZXTzxXb/D2uxW4oI8qaY70X6/uTRltazCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yxqwy0mxZf9gJtsmhVdOc2Kal1+HmRpbtgnF0fwncoI=;
 b=CZsawTHlFV4WIYlijIrzk5kE+DoQQOZtl0dkD+W5mYlWv25dYez0+ch5757zwzTiS3kSlVnSRhX6wdqmJi3or5YGXtfqPc3q9/4jhMsGNkl2EmmuKFhKrk5eouLzgYtgfsSt5FYpirsgDChDixlVjAMlXUlZk7GArD4cr8iX/IOxB10qJOpJHglX0OM5x7dFhdwPNSCGcWJXPoRGok9QKda32Na6KbZ4lxbTgTkW4z1bcGEpR/Hw7Zq9gVmp1ae9f1vAXQCP4XtxZdgVyopJ76Xelu97n2W3P14f6T6APOUFKQRsIUhNFxg7thMVqj0FzDtfo2FGzuq3XmtQfePAXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yxqwy0mxZf9gJtsmhVdOc2Kal1+HmRpbtgnF0fwncoI=;
 b=GwehTpH0ra3wnxicCL8YOLMmS1Ncn7kHENTvCkLCMFl2Zu3wSDCTBIchHY/I3ptdrOQpHih7rYz9ChdAg61IKwBnt6sEMQa1xXXzTPdhTO+sfU++PgOaGeikIQy7uh43TnbWfc8gQT2SK4lc0XDd2tRad8DgPmeq9lvrN0RVY+0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5349.namprd12.prod.outlook.com (2603:10b6:208:31f::7)
 by BL1PR12MB5303.namprd12.prod.outlook.com (2603:10b6:208:317::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.15; Wed, 18 Aug
 2021 11:42:45 +0000
Received: from BL1PR12MB5349.namprd12.prod.outlook.com
 ([fe80::152:9dd3:45a4:eeb6]) by BL1PR12MB5349.namprd12.prod.outlook.com
 ([fe80::152:9dd3:45a4:eeb6%4]) with mapi id 15.20.4415.024; Wed, 18 Aug 2021
 11:42:45 +0000
Subject: Re: [PATCH v2 18/63] drm/amd/pm: Use struct_group() for memcpy()
 region
To:     Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
Cc:     =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>,
        "Pan, Xinhui" <Xinhui.Pan@amd.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Feifei Xu <Feifei.Xu@amd.com>, Likun Gao <Likun.Gao@amd.com>,
        Jiawei Gu <Jiawei.Gu@amd.com>, Evan Quan <evan.quan@amd.com>,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        Alex Deucher <alexander.deucher@amd.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-hardening@vger.kernel.org
References: <20210818060533.3569517-1-keescook@chromium.org>
 <20210818060533.3569517-19-keescook@chromium.org>
From:   "Lazar, Lijo" <lijo.lazar@amd.com>
Message-ID: <753ef2d1-0f7e-c930-c095-ed86e1518395@amd.com>
Date:   Wed, 18 Aug 2021 17:12:28 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20210818060533.3569517-19-keescook@chromium.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN2PR01CA0055.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:22::30) To BL1PR12MB5349.namprd12.prod.outlook.com
 (2603:10b6:208:31f::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [172.31.157.114] (165.204.158.249) by PN2PR01CA0055.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:22::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Wed, 18 Aug 2021 11:42:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 20c8a3ce-7a62-4306-749f-08d9623d4ba8
X-MS-TrafficTypeDiagnostic: BL1PR12MB5303:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5303B5A57FF03755B979BCB997FF9@BL1PR12MB5303.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PxZ8IYTdL3vmlXJOvlFK1xxIc34TqyHhqCq5FpdLi0jMGU3vvCOFhTIJgwBjCowsKuYVyKdG1dDvPGBODhP5vzd5lTMvCO6sLmx1KNSMorSZMgY9YnEGDSE0h+0Sd2QJgaMJQtAK8ge5T6jPYJ1bEPYjakbnGxf81IDZHp9y+x3ApSjcnY7f+dNS7cdLz+u1OO89+P86HW0FGbQEWJfvN6gvnum/MwB1otlI7hCJuGYOSqPlKPD/2F/1MoQrf6bcOAVy2S9LHgn01QIYFxN61FMoohQI8B0/eFqEV1To6H56JhKsNq/He6FvSwdW6dzhBI7a+F3KoZcWQ5if0R9Cr7tHNXuzSY/H+DWxmzPuBrnZRryf/6giZ90/qTqx0UyUd0DwtnBtdFw3WxCDndWM/MFeG2Nsr2pbQ/KkauSh2r9lPWV2+6fE9/7MZuYj+5ybz+B9smROTwJNLGqYP/6UrB+wd3C7VSagpcJD5s5OwH2nq7de+dXV9z9HQXQqImhF2PHWEbC6vikEVkpQRZFs50ywD7ydJkr73z34rfvv/KPVJwA5Br3QCaeA/Uu938teE7YUYAKgz6cp5gAzyehOlR2GZITea2VXMfTjgIjrqQ1IloWCW4YlWqVzTpzoNII75s/daVHFxBQeSKS+Je1+78sFnSL/xZYb13RS6HA11o/bakPw6Mhr2TVPjcnOvtwgAFR82p7/Y7IOPWdDb3Ndr5OePKgSxLq1HZMTyNN+Sl9NQb2/o3x1JNCOPUd6uCYTesvl3O0f04GvN9K0KoRUKyynv/b+oKpFzb7jjF8yg+DMGpk9BtJiAmoNhVloodNa
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5349.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(396003)(346002)(376002)(136003)(31696002)(26005)(86362001)(186003)(30864003)(956004)(31686004)(8936002)(54906003)(8676002)(966005)(83380400001)(36756003)(4326008)(66574015)(66556008)(2906002)(66476007)(2616005)(316002)(53546011)(6666004)(19627235002)(478600001)(66946007)(38100700002)(45080400002)(7416002)(16576012)(5660300002)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?empvU1pjeGRpa0llZVBWOHhlcXY5TUl1KzBCOFFsNUFFM2VhRzVmSEphQkNL?=
 =?utf-8?B?bGR0dHM5TmRTMzZtYjNhbnZqRDZLVUlXQ2VqUTVuM05rWU9UaE9xdjBhTTBG?=
 =?utf-8?B?Wm90UWNiRG9xZTA5SnZTdHBmNFZsZkRlbkRTbnpoSnhmR1ZLbVNPK2o4TlRM?=
 =?utf-8?B?RXh2UmlSMnZoSjZZZjBIZTNIZ3BUTnpQWno4bjd6U0NyRjZhQTVneSs0bHlx?=
 =?utf-8?B?SFFGSk5jUHcrV3B5Mis0aXhmcVJnUXFva2ZWK3M3MTNla3h4ZE5xVzhPUzNW?=
 =?utf-8?B?YjJYbVVQUjc0YUJKY1lMNHRBUVBZMUtpRUg2a2p2SndmSVdwOUtTUFU3QU04?=
 =?utf-8?B?WmJxYlVibW14M1VNWDJYRDlTOG41M2RFTXorUmF6eGtBQWtvSHdJNVVHZTVo?=
 =?utf-8?B?cFgycDNVTUtmaitrUHR5VHAxR1RoZ1pZakp2QXhjMzFWU0YrUHg1U21JMEVT?=
 =?utf-8?B?S0hCRldWdmhPOTdQNU9SWDdPQU1kOVJPbTRZdGR1TDVKUzBXUUNCUkF2MlJ1?=
 =?utf-8?B?UmQ5K055c3R2cGc0UThuTm9sQ1B0ZWQwM3M4N0RBclR3ZDIrV1J0cW0wcDEw?=
 =?utf-8?B?MklQSXZvL2R4Zm13QzJmc0lmRE5wYlBhTHppSmZtdThDNUM5VEExWVU2aytu?=
 =?utf-8?B?NVF3MDV3VEIycDV2WjltRGMxc1FLc3hiZHpoOTc4c1hnbkZ6aWRNS3RxZ1Jx?=
 =?utf-8?B?ZitWQWdSeWF5Y05uWXFpTmd0d0ZTT1NDdUZ1ZWN2UHJJbjU5aW9CcXF6WjBU?=
 =?utf-8?B?ODFJd3dSemF3dDA4RHIyTXdDc1BjcktlVjFtSmZrb01hVjJzbW9Da2xLaGJP?=
 =?utf-8?B?b3JJQ0cra1NUdVhIN0JJNjk1Uk9FL3ppaDRncXpid2ZUMGsyZ2pNTXc1Z3hv?=
 =?utf-8?B?WU5UYSs0djZtald1Rmp0VFNBd0ZGREpSVlA0a1I0ZmJQZnY4MTgzZFNjd0N1?=
 =?utf-8?B?bkdtcWFjdCtPV3BGVkdLYXNqcWxmT3VRUkYvdERGVUw1c1dCVkhJWEt3d1Q0?=
 =?utf-8?B?V1RKYlIrajY4ZlZlaXh0T251U2xtaFVsd1VVY2JxcWxISDJpY0JkSGhIVFcr?=
 =?utf-8?B?V0NUVENrUzk0aThMOUlEWnhsckVtdm9WSVR2Z3JCeTV1dlo0ZWVPRm1GOStr?=
 =?utf-8?B?Um51MWJVYVRnQXh2dktuOFp1dWc4bVdwS3J2cjdUcmpvdHArSkdPWTR6VXRa?=
 =?utf-8?B?dFBHUnVEV1BRQ0JCc3BGK1NXWnhyWm9sSzhmdXNkUGRrVHdVbXNxQjllZ29v?=
 =?utf-8?B?K1JKeFB4SHZLMnQ2dG9ocm5WOUlpOEUyQVk1UDNIaXZFajdzZkl5cXpkaDRL?=
 =?utf-8?B?Zi9QMXFSVnZzc080WnMxY0YySmpHaTBsS0FhSkFjcHV4K1plZWFwWTY0dHJz?=
 =?utf-8?B?Vm5jejlibk45eEp5cU51Z1JkUlpGQVk4L2xTWXVOWjFxZ3BSaXY1d2FkdlI5?=
 =?utf-8?B?emdGeXkwNUhGZUMvS2dpbm9xUmlDM1BrUHR2V3FNdCttT3Q3S0cyeXRMMngx?=
 =?utf-8?B?Yk5mc2l5eFJxVVhCSFpRRCtuQzZtM2k4R3Q4aUpjdGQvWTVtSmwxTVVKdGlM?=
 =?utf-8?B?RE01aDhNNm5QRnNaR0ZRc0IvZFZ3MTl1c2ovTU56U2ljd0FGVXVGSjlubHJ0?=
 =?utf-8?B?SUEzRXNzdC9sU1FtTG5CbEo1VnRBcjAwR09XNHRpVXArTWlDalJxNHFBRnJO?=
 =?utf-8?B?bzNScG9YaFFwZTRMYytwTktEUVNhbzBlcmREbW9sN0NHdDZlMXYvRXNXU3Ft?=
 =?utf-8?Q?p+tQwuXqkFW6+vHb8Davr7ZW5g5CQgK8wI9PCG+?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20c8a3ce-7a62-4306-749f-08d9623d4ba8
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5349.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2021 11:42:45.4351
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZdvTAa1eKZCiW8G3E/O728gMhGWSbd6jtNeRQXe9ncQram6LcsAUj/A1dHd+tUQa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5303
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 8/18/2021 11:34 AM, Kees Cook wrote:
> In preparation for FORTIFY_SOURCE performing compile-time and run-time
> field bounds checking for memcpy(), memmove(), and memset(), avoid
> intentionally writing across neighboring fields.
> 
> Use struct_group() in structs:
> 	struct atom_smc_dpm_info_v4_5
> 	struct atom_smc_dpm_info_v4_6
> 	struct atom_smc_dpm_info_v4_7
> 	struct atom_smc_dpm_info_v4_10
> 	PPTable_t
> so the grouped members can be referenced together. This will allow
> memcpy() and sizeof() to more easily reason about sizes, improve
> readability, and avoid future warnings about writing beyond the end of
> the first member.
> 
> "pahole" shows no size nor member offset changes to any structs.
> "objdump -d" shows no object code changes.
> 
> Cc: "Christian König" <christian.koenig@amd.com>
> Cc: "Pan, Xinhui" <Xinhui.Pan@amd.com>
> Cc: David Airlie <airlied@linux.ie>
> Cc: Daniel Vetter <daniel@ffwll.ch>
> Cc: Hawking Zhang <Hawking.Zhang@amd.com>
> Cc: Feifei Xu <Feifei.Xu@amd.com>
> Cc: Lijo Lazar <lijo.lazar@amd.com>
> Cc: Likun Gao <Likun.Gao@amd.com>
> Cc: Jiawei Gu <Jiawei.Gu@amd.com>
> Cc: Evan Quan <evan.quan@amd.com>
> Cc: amd-gfx@lists.freedesktop.org
> Cc: dri-devel@lists.freedesktop.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Acked-by: Alex Deucher <alexander.deucher@amd.com>
> Link: https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Flkml%2FCADnq5_Npb8uYvd%2BR4UHgf-w8-cQj3JoODjviJR_Y9w9wqJ71mQ%40mail.gmail.com&amp;data=04%7C01%7Clijo.lazar%40amd.com%7C92b8d2f072f0444b9f8508d9620f6971%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637648640625729624%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=rKh5LUXCRUsorYM3kSpG2tkB%2Fczwl9I9EBnWBCtbg6Q%3D&amp;reserved=0
> ---
>   drivers/gpu/drm/amd/include/atomfirmware.h           |  9 ++++++++-
>   .../gpu/drm/amd/pm/inc/smu11_driver_if_arcturus.h    |  3 ++-
>   drivers/gpu/drm/amd/pm/inc/smu11_driver_if_navi10.h  |  3 ++-
>   .../gpu/drm/amd/pm/inc/smu13_driver_if_aldebaran.h   |  3 ++-

Hi Kees,

The headers which define these structs are firmware/VBIOS interfaces and 
are picked directly from those components. There are difficulties in 
grouping them to structs at the original source as that involves other 
component changes.

The driver_if_* files updates are frequent and it is error prone to 
manually group them each time we pick them for any update. Our usage of 
memcpy in this way is restricted only to a very few places.

As another option - is it possible to have a helper function/macro like 
memcpy_fortify() which takes the extra arguments and does the extra 
compile time checks? We will use the helper whenever we have such kind 
of usage.

Thanks,
Lijo

>   drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c    |  6 +++---
>   drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c      | 12 ++++++++----
>   drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c   |  6 +++---
>   7 files changed, 28 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/gpu/drm/amd/include/atomfirmware.h b/drivers/gpu/drm/amd/include/atomfirmware.h
> index 44955458fe38..7bf3edf15410 100644
> --- a/drivers/gpu/drm/amd/include/atomfirmware.h
> +++ b/drivers/gpu/drm/amd/include/atomfirmware.h
> @@ -2081,6 +2081,7 @@ struct atom_smc_dpm_info_v4_5
>   {
>     struct   atom_common_table_header  table_header;
>       // SECTION: BOARD PARAMETERS
> +  struct_group(dpm_info,
>       // I2C Control
>     struct smudpm_i2c_controller_config_v2  I2cControllers[8];
>   
> @@ -2159,7 +2160,7 @@ struct atom_smc_dpm_info_v4_5
>     uint32_t MvddRatio; // This is used for MVDD Vid workaround. It has 16 fractional bits (Q16.16)
>     
>     uint32_t     BoardReserved[9];
> -
> +  );
>   };
>   
>   struct atom_smc_dpm_info_v4_6
> @@ -2168,6 +2169,7 @@ struct atom_smc_dpm_info_v4_6
>     // section: board parameters
>     uint32_t     i2c_padding[3];   // old i2c control are moved to new area
>   
> +  struct_group(dpm_info,
>     uint16_t     maxvoltagestepgfx; // in mv(q2) max voltage step that smu will request. multiple steps are taken if voltage change exceeds this value.
>     uint16_t     maxvoltagestepsoc; // in mv(q2) max voltage step that smu will request. multiple steps are taken if voltage change exceeds this value.
>   
> @@ -2246,12 +2248,14 @@ struct atom_smc_dpm_info_v4_6
>   
>     // reserved
>     uint32_t   boardreserved[10];
> +  );
>   };
>   
>   struct atom_smc_dpm_info_v4_7
>   {
>     struct   atom_common_table_header  table_header;
>       // SECTION: BOARD PARAMETERS
> +  struct_group(dpm_info,
>       // I2C Control
>     struct smudpm_i2c_controller_config_v2  I2cControllers[8];
>   
> @@ -2348,6 +2352,7 @@ struct atom_smc_dpm_info_v4_7
>     uint8_t      Padding8_Psi2;
>   
>     uint32_t     BoardReserved[5];
> +  );
>   };
>   
>   struct smudpm_i2c_controller_config_v3
> @@ -2478,6 +2483,7 @@ struct atom_smc_dpm_info_v4_10
>     struct   atom_common_table_header  table_header;
>   
>     // SECTION: BOARD PARAMETERS
> +  struct_group(dpm_info,
>     // Telemetry Settings
>     uint16_t GfxMaxCurrent; // in Amps
>     uint8_t   GfxOffset;     // in Amps
> @@ -2524,6 +2530,7 @@ struct atom_smc_dpm_info_v4_10
>     uint16_t spare5;
>   
>     uint32_t reserved[16];
> +  );
>   };
>   
>   /*
> diff --git a/drivers/gpu/drm/amd/pm/inc/smu11_driver_if_arcturus.h b/drivers/gpu/drm/amd/pm/inc/smu11_driver_if_arcturus.h
> index 43d43d6addc0..8093a98800c3 100644
> --- a/drivers/gpu/drm/amd/pm/inc/smu11_driver_if_arcturus.h
> +++ b/drivers/gpu/drm/amd/pm/inc/smu11_driver_if_arcturus.h
> @@ -643,6 +643,7 @@ typedef struct {
>     // SECTION: BOARD PARAMETERS
>   
>     // SVI2 Board Parameters
> +  struct_group(v4_6,
>     uint16_t     MaxVoltageStepGfx; // In mV(Q2) Max voltage step that SMU will request. Multiple steps are taken if voltage change exceeds this value.
>     uint16_t     MaxVoltageStepSoc; // In mV(Q2) Max voltage step that SMU will request. Multiple steps are taken if voltage change exceeds this value.
>   
> @@ -728,10 +729,10 @@ typedef struct {
>     uint32_t     BoardVoltageCoeffB;    // decode by /1000
>   
>     uint32_t     BoardReserved[7];
> +  );
>   
>     // Padding for MMHUB - do not modify this
>     uint32_t     MmHubPadding[8]; // SMU internal use
> -
>   } PPTable_t;
>   
>   typedef struct {
> diff --git a/drivers/gpu/drm/amd/pm/inc/smu11_driver_if_navi10.h b/drivers/gpu/drm/amd/pm/inc/smu11_driver_if_navi10.h
> index 04752ade1016..0b4e6e907e95 100644
> --- a/drivers/gpu/drm/amd/pm/inc/smu11_driver_if_navi10.h
> +++ b/drivers/gpu/drm/amd/pm/inc/smu11_driver_if_navi10.h
> @@ -725,6 +725,7 @@ typedef struct {
>     uint32_t     Reserved[8];
>   
>     // SECTION: BOARD PARAMETERS
> +  struct_group(v4,
>     // I2C Control
>     I2cControllerConfig_t  I2cControllers[NUM_I2C_CONTROLLERS];
>   
> @@ -809,10 +810,10 @@ typedef struct {
>     uint8_t      Padding8_Loadline;
>   
>     uint32_t     BoardReserved[8];
> +  );
>   
>     // Padding for MMHUB - do not modify this
>     uint32_t     MmHubPadding[8]; // SMU internal use
> -
>   } PPTable_t;
>   
>   typedef struct {
> diff --git a/drivers/gpu/drm/amd/pm/inc/smu13_driver_if_aldebaran.h b/drivers/gpu/drm/amd/pm/inc/smu13_driver_if_aldebaran.h
> index a017983ff1fa..5056d3728da8 100644
> --- a/drivers/gpu/drm/amd/pm/inc/smu13_driver_if_aldebaran.h
> +++ b/drivers/gpu/drm/amd/pm/inc/smu13_driver_if_aldebaran.h
> @@ -390,6 +390,7 @@ typedef struct {
>     uint32_t spare3[14];
>   
>     // SECTION: BOARD PARAMETERS
> +  struct_group(v4_10,
>     // Telemetry Settings
>     uint16_t GfxMaxCurrent; // in Amps
>     int8_t   GfxOffset;     // in Amps
> @@ -444,7 +445,7 @@ typedef struct {
>   
>     //reserved
>     uint32_t reserved[14];
> -
> +  );
>   } PPTable_t;
>   
>   typedef struct {
> diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c
> index 8ab58781ae13..341adf209240 100644
> --- a/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c
> +++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c
> @@ -463,11 +463,11 @@ static int arcturus_append_powerplay_table(struct smu_context *smu)
>   			smc_dpm_table->table_header.format_revision,
>   			smc_dpm_table->table_header.content_revision);
>   
> +	BUILD_BUG_ON(sizeof(smc_pptable->v4_6) != sizeof(smc_dpm_table->dpm_info));
>   	if ((smc_dpm_table->table_header.format_revision == 4) &&
>   	    (smc_dpm_table->table_header.content_revision == 6))
> -		memcpy(&smc_pptable->MaxVoltageStepGfx,
> -		       &smc_dpm_table->maxvoltagestepgfx,
> -		       sizeof(*smc_dpm_table) - offsetof(struct atom_smc_dpm_info_v4_6, maxvoltagestepgfx));
> +		memcpy(&smc_pptable->v4_6, &smc_dpm_table->dpm_info,
> +		       sizeof(smc_dpm_table->dpm_info));
>   
>   	return 0;
>   }
> diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c
> index 2e5d3669652b..e8b6e25a7815 100644
> --- a/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c
> +++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c
> @@ -431,16 +431,20 @@ static int navi10_append_powerplay_table(struct smu_context *smu)
>   
>   	switch (smc_dpm_table->table_header.content_revision) {
>   	case 5: /* nv10 and nv14 */
> -		memcpy(smc_pptable->I2cControllers, smc_dpm_table->I2cControllers,
> -			sizeof(*smc_dpm_table) - sizeof(smc_dpm_table->table_header));
> +		BUILD_BUG_ON(sizeof(smc_pptable->v4) !=
> +			     sizeof(smc_dpm_table->dpm_info));
> +		memcpy(&smc_pptable->v4, &smc_dpm_table->dpm_info,
> +		       sizeof(smc_dpm_table->dpm_info));
>   		break;
>   	case 7: /* nv12 */
>   		ret = amdgpu_atombios_get_data_table(adev, index, NULL, NULL, NULL,
>   					      (uint8_t **)&smc_dpm_table_v4_7);
>   		if (ret)
>   			return ret;
> -		memcpy(smc_pptable->I2cControllers, smc_dpm_table_v4_7->I2cControllers,
> -			sizeof(*smc_dpm_table_v4_7) - sizeof(smc_dpm_table_v4_7->table_header));
> +		BUILD_BUG_ON(sizeof(smc_pptable->v4) !=
> +			     sizeof(smc_dpm_table_v4_7->dpm_info));
> +		memcpy(&smc_pptable->v4, &smc_dpm_table_v4_7->dpm_info,
> +		       sizeof(smc_dpm_table_v4_7->dpm_info));
>   		break;
>   	default:
>   		dev_err(smu->adev->dev, "smc_dpm_info with unsupported content revision %d!\n",
> diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c
> index c8eefacfdd37..492ba37bc514 100644
> --- a/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c
> +++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c
> @@ -407,11 +407,11 @@ static int aldebaran_append_powerplay_table(struct smu_context *smu)
>   			smc_dpm_table->table_header.format_revision,
>   			smc_dpm_table->table_header.content_revision);
>   
> +	BUILD_BUG_ON(sizeof(smc_pptable->v4_10) != sizeof(smc_dpm_table->dpm_info));
>   	if ((smc_dpm_table->table_header.format_revision == 4) &&
>   	    (smc_dpm_table->table_header.content_revision == 10))
> -		memcpy(&smc_pptable->GfxMaxCurrent,
> -		       &smc_dpm_table->GfxMaxCurrent,
> -		       sizeof(*smc_dpm_table) - offsetof(struct atom_smc_dpm_info_v4_10, GfxMaxCurrent));
> +		memcpy(&smc_pptable->v4_10, &smc_dpm_table->dpm_info,
> +		       sizeof(smc_dpm_table->dpm_info));
>   	return 0;
>   }
>   
> 
