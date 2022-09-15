Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2DAF5B98A5
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 12:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbiIOKTz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 06:19:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbiIOKTw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 06:19:52 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2088.outbound.protection.outlook.com [40.107.244.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D97615A2F;
        Thu, 15 Sep 2022 03:19:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cx+47Gf+MNl1QDUurxNZ4NHol7hg6l15m5+UuEcMEAjQALGF34y9Bh1JYr8KI2DSt2sS6c8uPaT57dEX6GzEvOs7X5JPuYZkFvuWIKkDcz22rD0j0ZBihzjqaTrBOymXadXK4nsnqj2QO+LjM2AunwmeVZvs1tycXeAjkNzDMOQMkobnjrJBmACYjv01R1PGZ377ZMFgRs5AtoB3fakJ46EgVJT9hPUo9jKX2nUSmF1lKd+/W0vgh/sy0g619O/88r4eyrK2yr+MR7ujLDjn0gmjtGWtjglExrNrijJ0A0kt981F7bAEzmweH/rSTfuzxPuIMA+WomOkNyH2utnHhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=doBmQmvl0SbbkkrR1yV9espX/cNWX4Zd9wGaORmnSdA=;
 b=CR/mrBG8xZTvPGXBeNuxf6Nz/1MYsq4LWZRD34j+Vf4WKBcgquQ20QK0l4ce12wQbPbT6JCDMO2TQwlVSJx/XOG6nxppuG1ESfGeVpP3QUWtdLuSuPae6CB0uYXrusSJ8fdgAOKfmCgDgIgYgTodrMuO6wdK3W6DFReRiDJ1liLCoHT0YIEqchsKdk54H881yRTwpOw7rDpADraJDaI3Eo3GfmzZYXNl5sK1GZABhtvr5e+8RKwEbEpvwqT808lW6RyzlbLpP0o1e6tXq3yFXa2Atz6/eQmNjG474S580UQuNluZJF7ho7vvYdAlydkiZ3nN7IFmR3OS6Eu6o1FF1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=doBmQmvl0SbbkkrR1yV9espX/cNWX4Zd9wGaORmnSdA=;
 b=N16csAOHmoyJ1ju8KjRO9CKhMbtlAKJLj+8vsg0KkHoY/BV6D6wVTqCvbJCt6VEIdcskyBu+Yf5e9QRfq4xxMxFBLDWwK2hJTvqQ4ParUUdJ9xaYk4NIOTUJG9PnFF5SVVPQ4yxKdXXIfIqU1dq/lYNrEv61GKNnB1ooFv+oEW4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silabs.com;
Received: from DS7PR11MB6038.namprd11.prod.outlook.com (2603:10b6:8:75::8) by
 BL1PR11MB5383.namprd11.prod.outlook.com (2603:10b6:208:318::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.15; Thu, 15 Sep
 2022 10:19:49 +0000
Received: from DS7PR11MB6038.namprd11.prod.outlook.com
 ([fe80::b091:dffc:2522:afcb]) by DS7PR11MB6038.namprd11.prod.outlook.com
 ([fe80::b091:dffc:2522:afcb%5]) with mapi id 15.20.5612.022; Thu, 15 Sep 2022
 10:19:49 +0000
From:   =?ISO-8859-1?Q?J=E9r=F4me?= Pouiller <jerome.pouiller@silabs.com>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        =?utf-8?B?UGF3ZcWC?= Lenkow <pawel.lenkow@camlingroup.com>,
        Lech Perczak <lech.perczak@camlingroup.com>
Cc:     Kalle Valo <kvalo@kernel.org>,
        Krzysztof =?utf-8?B?RHJvYmnFhHNraQ==?= 
        <krzysztof.drobinski@camlingroup.com>,
        Kirill Yatsenko <kirill.yatsenko@camlingroup.com>
Subject: Re: wfx: Memory corruption during high traffic with WFM200 on i.MX6Q platform
Date:   Thu, 15 Sep 2022 12:19:43 +0200
Message-ID: <2646104.mvXUDI8C0e@pc-42>
Organization: Silicon Labs
In-Reply-To: <8bea4eed-5b71-9fd4-c705-926bdad0ee47@camlingroup.com>
References: <16b90f1d-69b4-72ac-7018-66d524f514f9@camlingroup.com> <12e5adcd-8aed-f0f7-70cc-4fb7b656b829@camlingroup.com> <8bea4eed-5b71-9fd4-c705-926bdad0ee47@camlingroup.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
X-ClientProxiedBy: MR2P264CA0090.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:32::30) To DS7PR11MB6038.namprd11.prod.outlook.com
 (2603:10b6:8:75::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB6038:EE_|BL1PR11MB5383:EE_
X-MS-Office365-Filtering-Correlation-Id: dc75a109-bb4e-4953-eb83-08da9703d211
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fN1TV1McS6spF3Mv99w/2bPuuP+7JpuYGRr4nhuhyENLqiJaZrBGKsRvHigFvGwCvAOT9MNpiKp7ZO4QuXQ7VjzSja5ESfLNUJtPFfkP9pXjpGQnkRVxBeke0IC6xSuspH/u5pAqAEzf2Be7MkK/4BIxiDZ9p5e9VQIrBt1FrI7+ZvwhPBZq6ZI4ZWUfbnCWn6boTXjAaThfSWy7HWLVnKmJKr0PRck8y0Be7BZ671QGrrzhW8S5wuWdzAqwguwjWB+ier7dBdfOvAX2RIChuR9PvkpTTJgs6sVsR+CF/ATtBuDuzg+YiD+zLHVr5Gq/UfeBTv64BQfm7SkY3QQWESW38k1AWRj0pywSso38t1TLD5aElL2fM9o3nJaGgsz87YrfxeI0r+VoCXfIIB7eriQMOPXShGtZIKxG871kz0ZgZ0w9H7PKtV4Xu7Ch2KcUK5S65ye1AX1g+doUNX5s5vBmj7eYDoYDQPhzMGIvxBcWYEnFt8Aue9Clod3Na/IFquSpxhN1I7eGp8A1a0Fl8pbh0lY4H0e76EsySJLUlFD1bfMAznClUEPsY0SiXBZo8d6RPnmnOtdh3SIsrc8w4EBSW76uuT5w+impUILlugCXPCS2qR+sDLiGXHLqGLUhxebjcN0UkSNVsFxONTqzG3WjjKTU8eKJXrpLMK/MYZiz7amy6E+im+OxeUu0K35bD8qdjBZztxjoA0qu2Kq3EFAzuK19Xi63Lkj2JBycX7A4lzKUJ47V3qxXY4Ixxq8I1KuWG7zTH4Ce55g57TC4ZIOJ5XL1jwTFWLa97nvgBx0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB6038.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(396003)(136003)(346002)(376002)(366004)(39860400002)(451199015)(86362001)(38350700002)(38100700002)(2906002)(33716001)(4326008)(186003)(8676002)(478600001)(6486002)(8936002)(66556008)(5660300002)(66476007)(66946007)(4744005)(26005)(36916002)(52116002)(6666004)(41300700001)(6506007)(316002)(110136005)(9686003)(6512007)(54906003)(39026012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NEVuL242ZitVbmRHZlN2bTNNaTR4L0N4b3JBSW8vODlaWHRWZWV4bEFyVnlu?=
 =?utf-8?B?ejFOV1NBcHZDOWJLRXE2eUFTaGJEQkIyaGt6Q3lDeFQycVpQM1VMQmtsRDRL?=
 =?utf-8?B?TEFBTURWRDdra3NCU3Y2NGc5ekhheFg5VExudk9BaWZKM2l4cEJHeEYwQ0J3?=
 =?utf-8?B?b1BPYk4wWnBPSFViMXNVSE13dW9ZdmJYWGVQU2dsb3FNZU03c1dpYzIxNXpS?=
 =?utf-8?B?SEJRT1JDV0p2K3VhN1NNSDlZWVlQandtWlRQSURxZ2xiN2dsMmFTQUdkdzN6?=
 =?utf-8?B?bTRMbVlHWjJaWTVaYUprUkdPTnhoUkUzSG1aTXVDcFNpLzdjVGZTeWV3NExW?=
 =?utf-8?B?OHhTUStjNzlHSHhidTRyaVhDanpXSWJVTlg1QisrWHAyUC9uc0k2VGx2cW5E?=
 =?utf-8?B?cHMzRzl5b3oyTVY1SE12YktLa3BaMnNYcmhTM3hhV3g2NTdTRm1uV2ZRWXNH?=
 =?utf-8?B?MUFLNGRhcGJnSkRCQXVHVWtPZks4MjBvY1Z4aVJVSitDdmk3amoxem5BRFJi?=
 =?utf-8?B?RjAvSzIzRVN1clVxVjBub0JXQXpxZDF2Unp3eXFIb2hRTDUwbWM2WHZHMnNJ?=
 =?utf-8?B?UmwrQ2lROVBFVWg1V1k4M1lQQndNTHJacVVzbGlWV01BWFBHTjJaZTg1eWxM?=
 =?utf-8?B?dXY2UnlibzJtampFaG9vQkxNNk9XVWU1NlpxNGRaeHBVTy9KRUFDcS9UK2xU?=
 =?utf-8?B?UU5oOGVSSG02bnVjcE1Kb3RIR0RqVFVDUG50a205Nm9kUjlvUmtOdWdRMHZO?=
 =?utf-8?B?SVk3RkQ5eTU4MzByYTJHR2J3Zm5IQ3o1bmE4dGdaU1JpTmhaRko3dUIrSDJt?=
 =?utf-8?B?WFNUSm1kVXAvemY1bjJKVjRRTTdDb2dhOFg0TUVxQjZTWmsyZkJMdzZBcmZ5?=
 =?utf-8?B?Zi9oM0VSM1QxVW1hTXdQZUIwY3ROQ2tlclBUY014b0x3TTNXbUhwYVpTSDk5?=
 =?utf-8?B?OW1HeDR0Q0dIeGsyQzVtMmdLT2VVZU42cmxrZHRwVDJkMStESW1OMUN2SWk0?=
 =?utf-8?B?YmZ4QjFTZUprcjNNbXQwb0daL1A5aEJuRnpGK2UzLzMwRDUzMkRlQ1g1amxX?=
 =?utf-8?B?T0grQ21FMlYzbzZJdnM0TURyYVJmeGJoSjNBK1ZrMGtwVnZnRDE3dDNxNlIv?=
 =?utf-8?B?UzNZWlBSUGRSMmtuMlFNNFJvdlYzRmFObG54eTUyVFE4Tk1aRWFyNVNVSzZy?=
 =?utf-8?B?bmVQcGNCc0p5U1BSa3lEaXN3UFRSL3h6Q2J2ckpRSVljM2d5UHhGanJPNFgr?=
 =?utf-8?B?dURYa3lzNUZ0QUIyRzVNd1JQdlNSRVl3a0tQYUR2SEpYSEFZMHZIYVRTdzdo?=
 =?utf-8?B?eUhRa1JlZkVmOUxzMkdWMmlaWEJXQUZLb3Q1eklzM2h4cjFjLzEzMnZhN2sv?=
 =?utf-8?B?bTBxZDEwU29RQVB3V3V0QVNmdTNtcUFkODVIb2lwUEYzMTJaWjZBYUIzSCth?=
 =?utf-8?B?am1MYnp6VEpjUU1HZ0krNi9ZRENCQ3NlUTNwT3hseEd3ZitsNnJsMWRlUThn?=
 =?utf-8?B?Z0tySnMrUDFVaW9aT09TVXpwWWtubTQrZTkvOXlhYTRsbHBIdEFSc2daYW5I?=
 =?utf-8?B?aE04SHc5d0RqZXk4RHdBZzArUThaTWZXMjczNXVPRUtwQ2dHUmlQbjk5ZWE2?=
 =?utf-8?B?NkdoSDEzNGZoSGNZdHV0NkZoVE1zeC9oOW5VcDFKWDdTbUxxODRVRm91SVY1?=
 =?utf-8?B?bG1uUzdiV2UyN2Y0a0d6NURpSGtDRWcvNENwTGZVTWVhK3lUS0UrbEEvZ3Bn?=
 =?utf-8?B?K1Y0djF4LzRsVjNWQnNLOVcyNURzcUw3a2hwSHB3M1JJRCtiblB3TzlVYUtW?=
 =?utf-8?B?VUZPYnhadnNLYkx5TTA5YlIyWnZSaU1odHAwOWtiOE5ESFRHVjMvcXM1cTRH?=
 =?utf-8?B?Rm1CZmZjU0QrVGN3RGZyOWVNRzBqUGxEVXVLdXUydk9sUENiYWtkNDBwbXJ3?=
 =?utf-8?B?cnpsWG1rdU9VekJIdE4zeit6Vk1qYzYwZVE4cXRockF1R003N20zZHVPaURM?=
 =?utf-8?B?TU1hSlNicytRR3dPWG9CdlF6MkdOOXZlMjJqYXVXSWFPOEV4MDhSTDNIV2h4?=
 =?utf-8?B?Ny9wNFg0Y2J1UFZNL1hIa0tuTm1BZnh3Vi9jTEZIa2FlZXZUbW5QUDFSOGlS?=
 =?utf-8?Q?myUArWgTRcZlHRAHs53P0LBmK?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc75a109-bb4e-4953-eb83-08da9703d211
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB6038.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2022 10:19:49.3150
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K1wjTb7FvplHYPu/mHc07LzPe3YXH9V/3staCQz7nCSanNWh4hkjrmPoG/D+53d0dMtw3RI6GDhhue2UWp3ZRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5383
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thursday 15 September 2022 11:56:24 CEST Lech Perczak wrote:
> Hi J=C3=A9r=C3=B4me,
>=20
> Just a quick note, so you don't have to redo our work - Pawe=C5=82 found =
the root cause,
> patch is coming very shortly.
>=20
> TL;DR is that hw->max_rates in wfx_init_common was set to 8 initially,
> which is over the maximum of 4 specified by mac80211,
> causing out-of-bounds writes all over the place.

Wow, thank you. I was about to jump deep in your traces. You saved my
day.


--=20
J=C3=A9r=C3=B4me Pouiller


