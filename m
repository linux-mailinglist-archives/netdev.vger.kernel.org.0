Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87D9A561E95
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 17:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235587AbiF3O76 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 10:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235130AbiF3O7x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 10:59:53 -0400
Received: from mx07-001d1705.pphosted.com (mx07-001d1705.pphosted.com [185.132.183.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB88E1EC61;
        Thu, 30 Jun 2022 07:59:39 -0700 (PDT)
Received: from pps.filterd (m0209324.ppops.net [127.0.0.1])
        by mx08-001d1705.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25UCJ6Mi028151;
        Thu, 30 Jun 2022 14:59:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sony.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=S1;
 bh=MWDSqWhdkRdC9Bv/mLovPeFmYTKwSLU8f5bdd3x7GyE=;
 b=LsCnuAv4bOl4MI7J6/3qESYG9zBKkZa89NjfUaTT1hJKFf5kUrW5VrVO0tL/Ndn1D85Y
 ka7h5Q8CIRMzzTnFFOLqtRF/721MyyooeUHYNtUrbcolL24aWTZhpK8iBDc0+sGneO6I
 uHpjKwCzIfkWrBqkaEec9h6XbbT4Y6Z89lVAysni7q0RKHBEdg0Z4RrTY7agtXA4KFer
 Tq6i4W9m3JeLAXcvbLN/ute/+iSo+UaIVt8quy8UfxY5GfH9f7PLJ+gXnAyiWo0v2sxr
 qSLqsX1wUsR01JgkwQtHkjRyuPtXMAsXzOUXloNKN8Rduni/zpcbcGsiWNJVMTDo7TQg Ig== 
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2047.outbound.protection.outlook.com [104.47.74.47])
        by mx08-001d1705.pphosted.com (PPS) with ESMTPS id 3gwqh65p0y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Jun 2022 14:59:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BOmorv5kBV9R206ViSeoukfGEPwd68+Hzka11pj2EIZHI+lf+vvI1v723BsB/xLIt76B7smzVlwaBvWNbN2m2U1Ky3GICKN9sLPtDR28ViZdxs5FooIX0529soTleb2cPXua71PfRp6nVa9uJ0gtdNt5YzJSnfX90L7Z3XWGbK/HCH8EQs6d6qX0Sr/xajjXDU1aeEUE4PP1dBjZJQUnOwl/E4o6hZLyDSPhlqZzYiLB4m5xoXZc8RPsQ3XBC/G6ZlK2TrQGmhHZ7raH0Xta00yoBbJfufOuY4A4Jz7vlkMYWTUHxGRuYL6sgbvOje5JF5EIU8EKH0bGUICo7qzFPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MWDSqWhdkRdC9Bv/mLovPeFmYTKwSLU8f5bdd3x7GyE=;
 b=IsmXGlXG9gt8fIfEdanRVm68jdpKL62w82kHoGeISfFfHZMhgK3FGF5yC98N0oviyhQP8sFbVeSIPU23vJtxoGBA82OTKNo+1/wsBr/T/PD0am/O9Q3YHT3qzrsUIbSqTvSoh0gSFQWGWce8ChlHvbePROi25jzTKlJuUidgKDQS++H4z7Dn6wcPrL4stNSosxjGadPkC0xUHLmzy7hW/ama7tcQU88+3kNoyRXG1vvcv8jBvzihjzFoeAgT9M98Hb14Y7Xc+qK0/Eax/jVsRVbWXiqRJ8TR9vT5XR1aKy+cBqDcexU+hT+96JIUU2yzbL+Ybor3T5lYZs6OG819GQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sony.com; dmarc=pass action=none header.from=sony.com;
 dkim=pass header.d=sony.com; arc=none
Received: from DM6PR13MB3098.namprd13.prod.outlook.com (2603:10b6:5:196::11)
 by MW4PR13MB5838.namprd13.prod.outlook.com (2603:10b6:303:1a6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.11; Thu, 30 Jun
 2022 14:59:14 +0000
Received: from DM6PR13MB3098.namprd13.prod.outlook.com
 ([fe80::f879:1f68:a013:c06]) by DM6PR13MB3098.namprd13.prod.outlook.com
 ([fe80::f879:1f68:a013:c06%7]) with mapi id 15.20.5395.014; Thu, 30 Jun 2022
 14:59:14 +0000
From:   "U'ren, Aaron" <Aaron.U'ren@sony.com>
To:     Thorsten Leemhuis <regressions@leemhuis.info>
CC:     "McLean, Patrick" <Patrick.Mclean@sony.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "Brown, Russell" <Russell.Brown@sony.com>,
        "Rueger, Manuel" <manuel.rueger@sony.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        Florian Westphal <fw@strlen.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>
Subject: Re: Intermittent performance regression related to ipset between 5.10
 and 5.15
Thread-Topic: Intermittent performance regression related to ipset between
 5.10 and 5.15
Thread-Index: AQHYOMGW67qKpuT7dk2J1ij1Ec0M9azBu8uAgCjylwCAABPlAIAkPh0AgABqshCAKHvIgIABK1GAgB9noQCAEDSYyA==
Date:   Thu, 30 Jun 2022 14:59:14 +0000
Message-ID: <DM6PR13MB309846DD4673636DF440000EC8BA9@DM6PR13MB3098.namprd13.prod.outlook.com>
References: <BY5PR13MB3604D24C813A042A114B639DEE109@BY5PR13MB3604.namprd13.prod.outlook.com>
 <5e56c644-2311-c094-e099-cfe0d574703b@leemhuis.info>
 <c28ed507-168e-e725-dddd-b81fadaf6aa5@leemhuis.info>
 <b1bfbc2f-2a91-9d20-434d-395491994de@netfilter.org>
 <96e12c14-eb6d-ae07-916b-7785f9558c67@leemhuis.info>
 <DM6PR13MB3098E6B746264B4F96D9F743C8C39@DM6PR13MB3098.namprd13.prod.outlook.com>
 <2d9479bd-93bd-0cf1-9bc9-591ab3b2bdec@leemhuis.info>
 <6f6070ff-b50-1488-7e9-322be08f35b9@netfilter.org>
 <871bc2cb-ae4b-bc2a-1bd8-1315288957c3@leemhuis.info>
In-Reply-To: <871bc2cb-ae4b-bc2a-1bd8-1315288957c3@leemhuis.info>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 69f609e1-c6e8-4f32-807b-08da5aa9194c
x-ms-traffictypediagnostic: MW4PR13MB5838:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8c+76o/LYOGIR0+StV+4vaEvCl9ozN6zEqJ+f48TQ9Aec1HstQcB1XpRDbEYfi7/f3LUcyvMiUY6R+yPLkp65RPAny9oEWrw1+eaczl2vrC84TgY6+4RWCvA4fLSyPnZlurOUr4p3B7+ELKamrE+nB201jih5b26Uh6J9Pi1KGytyy5SznejgPap/pPCPhwS4PHumxJYsU8M3BQxq16cNZrxueteTKNP+mW0/WYscTn9NYC8KPy3llaPMHMZy5kkOYhyyFDpQQCNBuzOsxxmJJnH2qrYgj7R9pkR5THgNwkr3kQTQCTE6quuEdz37HQ0qpDzn+p/H2a6Y+vwc04Ij1Wytr46r5pE34pPDnG2M7JFXzxrD6kJL3lKFxtgDjHVOoC81WoS+brOH2r+KQYWpRG05j00lEU5OURpw3ijTuPIeBULdEwAtI+JXSXkEhQNQiE2MGO7lA6v4sLgFufadtD4FauiNkHQ7EUaTauyyIx0fG/43q9kpC8SpLTEwm/kQMiHiq7pTfHQ1FaG762KjSRBPvS9iZsb+VS9S8rBX/hCrNAQs/rxFI7mPz3FHF1Qrys1LGNfCZM/Tfy+EsYLgXmNl6TTQSzpononWv3KOA2tPRuMV6cWkURvl3kibSdJqCPytd9TocCPvQA6W3KLVsgRgN2n2/5Ks5yapclZMiE8vfVVvvF2pTNS2ZUSdyEF1gWGs2MMVjqCD5BT1m9YdmgIb1iBR3tN1iPw50a4FnZk/OieGy+v1Qr8qh2E1jMgTkPFf3cp236kPsvQrGrSCT3vSS9HuhGb8y8mrJuqcHQpPtPquVNeSPrZthe5u8WVbeH6LOiuXiogPwkkJus6mXbA0OAaMzA4Yyc0w9gdpDtTMupwvSUI60aLVj3PTM5k
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB3098.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(366004)(396003)(346002)(39860400002)(966005)(6506007)(41300700001)(122000001)(7696005)(8936002)(55016003)(38070700005)(4326008)(186003)(82960400001)(66946007)(66446008)(76116006)(83380400001)(91956017)(84970400001)(53546011)(38100700002)(66476007)(86362001)(66574015)(478600001)(66556008)(5660300002)(9686003)(33656002)(52536014)(6916009)(54906003)(71200400001)(2906002)(64756008)(26005)(8676002)(316002)(30864003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?Windows-1252?Q?vn3PgQ+43QbDTV0WhLSaomh9GX+dhpC7mJKaDVPQjBt2pESjIhaQX0We?=
 =?Windows-1252?Q?Yh0d/e0f01nOhPwpU3DFmX+qtgt4Mk1oZG/vkPjIGnwB+ggoW9Si6Lb+?=
 =?Windows-1252?Q?R9IWHlOTCCC9gaIVEXuyqg1/7hJXfwg7ZH4h7hFvQxyJ+ZPoqZ5Fff1w?=
 =?Windows-1252?Q?qEmn2NE1V3goS63/S46M2y7PVdw2nmgVregK3K+wEKfIeelnMvGzFxFq?=
 =?Windows-1252?Q?JGl9YOobpbPs6o7WmGxWk5bvRtJyYPa5V8uRjVA3XVHhFWOrfv/+P05d?=
 =?Windows-1252?Q?pGkPY3JlvXOMxcVMV0YkuanfoZkMnXuhKCqlFdZQJAnTjT1+Er1lWTD3?=
 =?Windows-1252?Q?FWI1OS11j6VGirzMtLC1M3jX/u5b2Qhzx9eDnjD8gAeqaooIDz1yeFZ3?=
 =?Windows-1252?Q?do2qkOr9PDLn+v8D+9aXuMOpGopj5DeXqmTfn/R2iZHu+bM1cbHpJnCF?=
 =?Windows-1252?Q?Ewpk4BcONm/JJceAqWJmqs771vVEjC6wh45PfR7Ghb4XJaRHrXuMUrH/?=
 =?Windows-1252?Q?8+HxozX1on99X0KAd/dzgv9mYzAtwwpHijDi8+BmhoelzfwdGQTOlmou?=
 =?Windows-1252?Q?5zKBZ260zFYH2MjAvNtH4xZatD83MjyhQpWjpVGAO6WIssM3uRF5dd69?=
 =?Windows-1252?Q?fb+GUgVBqdG6rjkSAyDKNbvDh6Y6dz1I5z0W4rIdR+ByElWs+bA32tgz?=
 =?Windows-1252?Q?yXWT3njdHTZ2fDubNdPV8vTeLWUrWJ5HNUul81zOxJpskPKuK+3LfR8c?=
 =?Windows-1252?Q?mlnYYkmSWbneOCedtAJng8Ddomk3dUGO8SIUIc/Ca59vCSvp6I5B69RO?=
 =?Windows-1252?Q?939VLmJfoVlhw7dGlR0vHVeNFNBP4EAN41qNwYuxc9e7zq0eOFfSO+oG?=
 =?Windows-1252?Q?oypbjBk/OQLTpif+YsCy7fOCYGm/OGB3+/TZXP0lW2eZOZ3o+6IP6FG/?=
 =?Windows-1252?Q?+5yKraC2CETARgTHcZ3wHtnVyUpdxkERvqP/q0RMUHsLWcN3OGhdfaEZ?=
 =?Windows-1252?Q?vzA9a39/vG48s/fLP6qliOsD0tm8+9w8s8fesxz0pMAhIS6V+Gs3Nrs3?=
 =?Windows-1252?Q?uXrK8CKC6tlZv/2KOWInI7fm5lV+hqrerKNkdvUWEUdFrh6mKS1Y55sS?=
 =?Windows-1252?Q?mfAF+NJvXgw+GGuxiXE2D7ssiIWdUUklwCMa8dxYxK8W0Kz7KAPRzT9F?=
 =?Windows-1252?Q?gidcRRnPZFw9x186p3C+rv4CrPyZstTAiJvaSRvggpIkWy2/z9VkrG7M?=
 =?Windows-1252?Q?hJwTPTLzCkfr+fgOnzNJs6P4DmI5iOFNy1oIOzovZj242YIIT/07is2P?=
 =?Windows-1252?Q?MD5ruxHs8KX987VT6LvjCZx5v7Nv1LNIO3Ii3cljZTMkhLToKHFVOytO?=
 =?Windows-1252?Q?ZIaZAHkaYtqRmTkpioXdz5vGOAXr0qYjGhjpQxXJHQB3drQaZB88wogR?=
 =?Windows-1252?Q?bHOJHdpy/oOo6u8daWP4jl3kmnUb0fHq4QM+80dKedJ7jA+VLlOxLP6s?=
 =?Windows-1252?Q?sg06TOedEIqwaW8XscNC+lJ8iE4291yAidUOuqGLNLdhth7aE3pAlh+4?=
 =?Windows-1252?Q?zohvm9opTw947oXiPXbn0HHssVI3K72r+QGbVyIIu5T9TLziQsEVtj73?=
 =?Windows-1252?Q?tm6LYm2X2ImfpowRFLdQL74N5HbMkuU7FdgMDdFkgVo/sso7KYA3MKwz?=
 =?Windows-1252?Q?7OBlLzEfdGdY0Xov8aHAM6acE0agrQIr40Ds1000d6dtMxQFpvzBXw?=
 =?Windows-1252?Q?=3D=3D?=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sony.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB3098.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69f609e1-c6e8-4f32-807b-08da5aa9194c
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jun 2022 14:59:14.6294
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 66c65d8a-9158-4521-a2d8-664963db48e4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: A4VZUtST2kd+vjToJOOveTdg9Jc2EeR9xuduoTik+H5+zf0AlMZaApifluHyjUckVPFIQFGoZzygn7OzUXfzsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR13MB5838
X-Proofpoint-ORIG-GUID: -YR8vdRsVggys5F9QF4oMwGbaQ9N-eJ1
X-Proofpoint-GUID: -YR8vdRsVggys5F9QF4oMwGbaQ9N-eJ1
X-Sony-Outbound-GUID: -YR8vdRsVggys5F9QF4oMwGbaQ9N-eJ1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-30_09,2022-06-28_01,2022-06-22_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=APOSTROPHE_FROM,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thorsten / Jozsef -

Thanks for continuing to follow up! I'm sorry that this has moved so slow, =
it has taken us a bit to find the time to fully track this issue down, howe=
ver, I think that we have figured out enough to make some more forward prog=
ress on this issue.

Jozsef, thanks for your insight into what is happening between those system=
 calls. In regards to your question about wait/wound mutex debugging possib=
ly being enabled, I can tell you that we definitely don't have that enabled=
 on any of our regular machines. While we were debugging we did turn on qui=
te a few debug options to help us try and track this issue down and it is v=
ery possible that the strace that was taken that started off this email was=
 taken on a machine that did have that debug option enabled. Either way tho=
ugh, the root issue occurs on hosts that definitely do not have wait/wound =
mutex debugging enabled.

The good news is that we finally got one of our development environments in=
to a state where we could reliably reproduce the performance issue across r=
eboots. This was a win because it meant that we were able to do a full bise=
ct of the kernel and were able to tell relatively quickly whether or not th=
e issue was present in the test kernels.

After bisecting for 3 days, I have been able to narrow it down to a single =
commit: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/=
commit/?id=3D3976ca101990ca11ddf51f38bec7b86c19d0ca6f (netfilter: ipset: Ex=
pose the initval hash parameter to userspace)

I'm at a bit of a loss as to why this would cause such severe performance r=
egressions, but I've proved it out multiple times now. I've even checked ou=
t a fresh version of the 5.15 kernel that we've been deploying with just th=
is single commit reverted and found that the performance problems are compl=
etely resolved.

I'm hoping that maybe Jozsef will have some more insight into why this seem=
ingly innocuous commit causes such larger performance issues for us? If you=
 have any additional patches or other things that you would like us to test=
 I will try to leave our environment in its current state for the next coup=
le of days so that we can do so.

-Aaron

From: Thorsten Leemhuis <regressions@leemhuis.info>
Date: Monday, June 20, 2022 at 2:16 AM
To: U'ren, Aaron <Aaron.U'ren@sony.com>
Cc: McLean, Patrick <Patrick.Mclean@sony.com>, Pablo Neira Ayuso <pablo@net=
filter.org>, netfilter-devel@vger.kernel.org <netfilter-devel@vger.kernel.o=
rg>, Brown, Russell <Russell.Brown@sony.com>, Rueger, Manuel <manuel.rueger=
@sony.com>, linux-kernel@vger.kernel.org <linux-kernel@vger.kernel.org>, re=
gressions@lists.linux.dev <regressions@lists.linux.dev>, Florian Westphal <=
fw@strlen.de>, netdev@vger.kernel.org <netdev@vger.kernel.org>, Jozsef Kadl=
ecsik <kadlec@netfilter.org>
Subject: Re: Intermittent performance regression related to ipset between 5=
.10 and 5.15
On 31.05.22 09:41, Jozsef Kadlecsik wrote:
> On Mon, 30 May 2022, Thorsten Leemhuis wrote:
>> On 04.05.22 21:37, U'ren, Aaron wrote:
>>>=A0 It=92s good to have the confirmation about why iptables list/save=20
>>> perform so many getsockopt() calls.
>=20
> Every set lookups behind "iptables" needs two getsockopt() calls: you can=
=20
> see them in the strace logs. The first one check the internal protocol=20
> number of ipset and the second one verifies/gets the processed set (it's=
=20
> an extension to iptables and therefore there's no internal state to save=
=20
> the protocol version number).

Hi Aaron! Did any of the suggestions from Jozsef help to track down the
root case? I have this issue on the list of tracked regressions and
wonder what the status is. Or can I mark this as resolved?

Side note: this is not a "something breaks" regressions and it seems to
progress slowly, so I'm putting it on the backburner:

#regzbot backburner: performance regression where the culprit is hard to
track down

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)

P.S.: As the Linux kernel's regression tracker I deal with a lot of
reports and sometimes miss something important when writing mails like
this. If that's the case here, don't hesitate to tell me in a public
reply, it's in everyone's interest to set the public record straight.

>>>=A0 In terms of providing more information to locate the source of the=20
>>> slowdown, do you have any recommendations on what information would be=
=20
>>> helpful?
>>>=A0 The only thing that I was able to think of was doing a git bisect on=
=20
>>> it, but that=92s a pretty large range, and the problem isn=92t always 1=
00%=20
>>> reproducible. It seems like something about the state of the system=20
>>> needs to trigger the issue. So that approach seemed non-optimal.
>>>=A0 I=92m reasonably certain that if we took enough of our machines back=
 to=20
>>> 5.15.16 we could get some of them to evidence the problem again. If we=
=20
>>> reproduced the problem, what types of diagnostics or debug could we=20
>>> give you to help further track down this issue?
>=20
> In your strace log
>=20
> 0.000024 getsockopt(4, SOL_IP, 0x53 /* IP_??? */, "\0\1\0\0\7\0\0\0", [8]=
) =3D 0 <0.000024>
> 0.000046 getsockopt(4, SOL_IP, 0x53 /* IP_??? */, "\7\0\0\0\7\0\0\0KUBE-D=
ST-VBH27M7NWLDOZIE"..., [40]) =3D 0 <0.1$
> 0.109456 close(4)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =3D =
0 <0.000022>
>=20
> the only things which happen in the second sockopt function are to lock=20
> the NFNL_SUBSYS_IPSET mutex, walk the array of the sets, compare the=20
> setname, save the result in the case of a match and unlock the mutex.=20
> Nothing complicated, no deep, multi-level function calls. Just a few line=
=20
> of codes which haven't changed.
>=20
> The only thing which can slow down the processing is the mutex handling.=
=20
> Don't you have accidentally wait/wound mutex debugging enabled in the=20
> kernel? If not, then bisecting the mutex related patches might help.
>=20
> You wrote that flushing tables or ipsets didn't seem to help. That=20
> literally meant flushing i.e. the sets were emptied but not destroyed? Di=
d=20
> you try both destroying or flushing?
>=20
>> Jozsef, I still have this issue on my list of tracked regressions and it
>> looks like nothing happens since above mail (or did I miss it?). Could
>> you maybe provide some guidance to Aaron to get us all closer to the
>> root of the problem?
>=20
> I really hope it's an accidentally enabled debugging option in the kernel=
.=20
> Otherwise bisecting could help to uncover the issue.
>=20
> Best regards,
> Jozsef
>=20
>> P.S.: As the Linux kernel's regression tracker I deal with a lot of
>> reports and sometimes miss something important when writing mails like
>> this. If that's the case here, don't hesitate to tell me in a public
>> reply, it's in everyone's interest to set the public record straight.
>>
>>
>>> From: Thorsten Leemhuis <regressions@leemhuis.info>
>>> Date: Wednesday, May 4, 2022 at 8:15 AM
>>> To: McLean, Patrick <Patrick.Mclean@sony.com>
>>> Cc: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kerne=
l.org <netfilter-devel@vger.kernel.org>, U'ren, Aaron <Aaron.U'ren@sony.com=
>, Brown, Russell <Russell.Brown@sony.com>, Rueger, Manuel <manuel.rueger@s=
ony.com>, linux-kernel@vger.kernel.org <linux-kernel@vger.kernel.org>, regr=
essions@lists.linux.dev <regressions@lists.linux.dev>, Florian Westphal <fw=
@strlen.de>, netdev@vger.kernel.org <netdev@vger.kernel.org>, Jozsef Kadlec=
sik <kadlec@netfilter.org>
>>> Subject: Re: Intermittent performance regression related to ipset betwe=
en 5.10 and 5.15
>>> Hi, this is your Linux kernel regression tracker. Top-posting for once,
>>> to make this easily accessible to everyone.
>>>
>>> Patrick, did you see the comment from Jozsef? Are you having trouble
>>> providing additional data or what's the status here from your side? Or
>>> is that something we can forget?
>>>
>>> Ciao, Thorsten
>>>
>>> #regzbot poke
>>>
>>> On 11.04.22 13:47, Jozsef Kadlecsik wrote:
>>>> Hi,
>>>>
>>>> On Mon, 11 Apr 2022, Thorsten Leemhuis wrote:
>>>>
>>>>> On 16.03.22 10:17, Thorsten Leemhuis wrote:
>>>>>> [TLDR: I'm adding the regression report below to regzbot, the Linux
>>>>>> kernel regression tracking bot; all text you find below is compiled =
from
>>>>>> a few templates paragraphs you might have encountered already alread=
y
>>>>>> from similar mails.]
>>>>>>
>>>>>> On 16.03.22 00:15, McLean, Patrick wrote:
>>>>>
>>>>>>> When we upgraded from the 5.10 (5.10.61) series to the 5.15 (5.15.1=
6)=20
>>>>>>> series, we encountered an intermittent performance regression that=
=20
>>>>>>> appears to be related to iptables / ipset. This regression was=20
>>>>>>> noticed on Kubernetes hosts that run kube-router and experience a=20
>>>>>>> high amount of churn to both iptables and ipsets. Specifically, whe=
n=20
>>>>>>> we run the nftables (iptables-1.8.7 / nftables-1.0.0) iptables=20
>>>>>>> wrapper xtables-nft-multi on the 5.15 series kernel, we end up=20
>>>>>>> getting extremely laggy response times when iptables attempts to=20
>>>>>>> lookup information on the ipsets that are used in the iptables=20
>>>>>>> definition. This issue isn=92t reproducible on all hosts. However, =
our=20
>>>>>>> experience has been that across a fleet of ~50 hosts we experienced=
=20
>>>>>>> this issue on ~40% of the hosts. When the problem evidences, the ti=
me=20
>>>>>>> that it takes to run unrestricted iptables list commands like=20
>>>>>>> iptables -L or iptables-save gradually increases over the course of=
=20
>>>>>>> about 1 - 2 hours. Growing from less than a second to run, to takin
>>>>> =A0 g sometimes over 2 minutes to run. After that 2 hour mark it seem=
s to=20
>>>>> =A0 plateau and not grow any longer. Flushing tables or ipsets doesn=
=92t seem=20
>>>>> =A0 to have any affect on the issue. However, rebooting the host does=
 reset=20
>>>>> =A0 the issue. Occasionally, a machine that was evidencing the proble=
m may=20
>>>>> =A0 no longer evidence it after being rebooted.
>>>>>>>
>>>>>>> We did try to debug this to find a root cause, but ultimately ran=20
>>>>>>> short on time. We were not able to perform a set of bisects to=20
>>>>>>> hopefully narrow down the issue as the problem isn=92t consistently=
=20
>>>>>>> reproducible. We were able to get some straces where it appears tha=
t=20
>>>>>>> most of the time is spent on getsockopt() operations. It appears th=
at=20
>>>>>>> during iptables operations, it attempts to do some work to resolve=
=20
>>>>>>> the ipsets that are linked to the iptables definitions (perhaps=20
>>>>>>> getting the names of the ipsets themselves?). Slowly that getsockop=
t=20
>>>>>>> request takes more and more time on affected hosts. Here is an=20
>>>>>>> example strace of the operation in question:
>>>>
>>>> Yes, iptables list/save have to get the names of the referenced sets a=
nd=20
>>>> that is performed via getsockopt() calls.
>>>>
>>>> I went through all of the ipset related patches between 5.10.6 (copy&p=
aste=20
>>>> error but just the range is larger) and 5.15.16 and as far as I see no=
ne=20
>>>> of them can be responsible for the regression. More data is required t=
o=20
>>>> locate the source of the slowdown.
>>>>
>>>> Best regards,
>>>> Jozsef
>>>>
>>>>>>>
>>>>>>> 0.000074 newfstatat(AT_FDCWD, "/etc/nsswitch.conf", {st_mode=3DS_IF=
REG|0644, st_size=3D539, ...}, 0) =3D 0 <0.000017>
>>>>>>> 0.000064 openat(AT_FDCWD, "/var/db/protocols.db", O_RDONLY|O_CLOEXE=
C) =3D -1 ENOENT (No such file or directory) <0.000017>
>>>>>>> 0.000057 openat(AT_FDCWD, "/etc/protocols", O_RDONLY|O_CLOEXEC) =3D=
 4 <0.000013>
>>>>>>> 0.000034 newfstatat(4, "", {st_mode=3DS_IFREG|0644, st_size=3D6108,=
 ...}, AT_EMPTY_PATH) =3D 0 <0.000009>
>>>>>>> 0.000032 lseek(4, 0, SEEK_SET)=A0=A0=A0=A0 =3D 0 <0.000008>
>>>>>>> 0.000025 read(4, "# /etc/protocols\n#\n# Internet (I"..., 4096) =3D=
 4096 <0.000010>
>>>>>>> 0.000036 close(4)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 =3D 0 <0.000008>
>>>>>>> 0.000028 write(1, "ANGME7BF25 - [0:0]\n:KUBE-POD-FW-"..., 4096) =3D=
 4096 <0.000028>
>>>>>>> 0.000049 socket(AF_INET, SOCK_RAW, IPPROTO_RAW) =3D 4 <0.000015>
>>>>>>> 0.000032 fcntl(4, F_SETFD, FD_CLOEXEC) =3D 0 <0.000008>
>>>>>>> 0.000024 getsockopt(4, SOL_IP, 0x53 /* IP_??? */, "\0\1\0\0\7\0\0\0=
", [8]) =3D 0 <0.000024>
>>>>>>> 0.000046 getsockopt(4, SOL_IP, 0x53 /* IP_??? */, "\7\0\0\0\7\0\0\0=
KUBE-DST-VBH27M7NWLDOZIE"..., [40]) =3D 0 <0.109384>
>>>>>>> 0.109456 close(4)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 =3D 0 <0.000022>
>>>>>>>
>>>>>>> On a host that is not evidencing the performance regression we=20
>>>>>>> normally see that operation take ~ 0.00001 as opposed to=20
>>>>>>> 0.109384.Additionally, hosts that were evidencing the problem we al=
so=20
>>>>>>> saw high lock times with `klockstat` (unfortunately at the time we=
=20
>>>>>>> did not know about or run echo "0" > /proc/sys/kernel/kptr_restrict=
=20
>>>>>>> to get the callers of the below commands).
>>>>>>>
>>>>>>> klockstat -i 5 -n 10 (on a host experiencing the problem)
>>>>>>> Caller=A0=A0 Avg Hold=A0 Count=A0=A0 Max hold Total hold
>>>>>>> b'[unknown]'=A0 118490772=A0=A0=A0=A0 83=A0 179899470 9834734132
>>>>>>> b'[unknown]'=A0 118416941=A0=A0=A0=A0 83=A0 179850047 9828606138
>>>>>>> # or somewhere later while iptables -vnL was running:
>>>>>>> Caller=A0=A0 Avg Hold=A0 Count=A0=A0 Max hold Total hold
>>>>>>> b'[unknown]'=A0 496466236=A0=A0=A0=A0 46 17919955720 22837446860
>>>>>>> b'[unknown]'=A0 496391064=A0=A0=A0=A0 46 17919893843 22833988950
>>>>>>>
>>>>>>> klockstat -i 5 -n 10 (on a host not experiencing the problem)
>>>>>>> Caller=A0=A0 Avg Hold=A0 Count=A0=A0 Max hold Total hold
>>>>>>> b'[unknown]'=A0=A0=A0=A0 120316=A0=A0 1510=A0=A0 85537797=A0 181677=
885
>>>>>>> b'[unknown]'=A0=A0=A0 7119070=A0=A0=A0=A0 24=A0=A0 85527251=A0 1708=
57690
>>>>>>
>>>>>> Hi, this is your Linux kernel regression tracker.
>>>>>>
>>>>>> Thanks for the report.
>>>>>>
>>>>>> CCing the regression mailing list, as it should be in the loop for a=
ll
>>>>>> regressions, as explained here:
>>>>>> https://urldefense.com/v3/__https:/www.kernel.org/doc/html/latest/ad=
min-guide/reporting-issues.html__;!!JmoZiZGBv3RvKRSx!9uRzPn01pFuoHMQj2ZsxlS=
eY6NoNdYH6BxvEi_JHC4sZoqDTp8X2ZYrIRtIOhN7RM0PtxYLq4NIe9g0hJqZVpZdwVIY5$=20
>>>>>>
>>>>>> To be sure below issue doesn't fall through the cracks unnoticed, I'=
m
>>>>>> adding it to regzbot, my Linux kernel regression tracking bot:
>>>>>>
>>>>>> #regzbot ^introduced v5.10..v5.15
>>>>>> #regzbot title net: netfilter: Intermittent performance regression
>>>>>> related to ipset
>>>>>> #regzbot ignore-activity
>>>>>>
>>>>>> If it turns out this isn't a regression, free free to remove it from=
 the
>>>>>> tracking by sending a reply to this thread containing a paragraph li=
ke
>>>>>> "#regzbot invalid: reason why this is invalid" (without the quotes).
>>>>>>
>>>>>> Reminder for developers: when fixing the issue, please add a 'Link:'
>>>>>> tags pointing to the report (the mail quoted above) using
>>>>>> lore.kernel.org/r/, as explained in
>>>>>> 'Documentation/process/submitting-patches.rst' and
>>>>>> 'Documentation/process/5.Posting.rst'. Regzbot needs them to
>>>>>> automatically connect reports with fixes, but they are useful in
>>>>>> general, too.
>>>>>>
>>>>>> I'm sending this to everyone that got the initial report, to make
>>>>>> everyone aware of the tracking. I also hope that messages like this
>>>>>> motivate people to directly get at least the regression mailing list=
 and
>>>>>> ideally even regzbot involved when dealing with regressions, as mess=
ages
>>>>>> like this wouldn't be needed then. And don't worry, if I need to sen=
d
>>>>>> other mails regarding this regression only relevant for regzbot I'll
>>>>>> send them to the regressions lists only (with a tag in the subject s=
o
>>>>>> people can filter them away). With a bit of luck no such messages wi=
ll
>>>>>> be needed anyway.
>>>>>>
>>>>>> Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' =
hat)
>>>>>>
>>>>>> P.S.: As the Linux kernel's regression tracker I'm getting a lot of
>>>>>> reports on my table. I can only look briefly into most of them and l=
ack
>>>>>> knowledge about most of the areas they concern. I thus unfortunately
>>>>>> will sometimes get things wrong or miss something important. I hope
>>>>>> that's not the case here; if you think it is, don't hesitate to tell=
 me
>>>>>> in a public reply, it's in everyone's interest to set the public rec=
ord
>>>>>> straight.
>>>>>>
>>>>>
>>>>
>>>> -
>>>> E-mail=A0 : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
>>>> PGP key : https://urldefense.com/v3/__https:/wigner.hu/*kadlec/pgp_pub=
lic_key.txt__;fg!!JmoZiZGBv3RvKRSx!9uRzPn01pFuoHMQj2ZsxlSeY6NoNdYH6BxvEi_JH=
C4sZoqDTp8X2ZYrIRtIOhN7RM0PtxYLq4NIe9g0hJqZVpRHTvk29$=20
>>>> Address : Wigner Research Centre for Physics
>>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 H-1525 Budapest 114, POB. 49, Hungary
>>>
>>>
>>
>=20
> -
> E-mail=A0 : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
> PGP key : https://urldefense.com/v3/__https:/wigner.hu/*kadlec/pgp_public=
_key.txt__;fg!!JmoZiZGBv3RvKRSx!4YE_vzTwH11tLmht_mqRbx-shqc9cGCmFtFWueoKCMt=
0uJaqWdFzheT3KdEC-7cAqnf0Gnu82USHlLemKtf5x5I6KaHM$=20
> Address : Wigner Research Centre for Physics
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 H-1525 Budapest 114, POB. 49, Hungary
