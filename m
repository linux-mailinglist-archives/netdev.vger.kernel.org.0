Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15A955F97F6
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 07:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231360AbiJJFzg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 01:55:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230447AbiJJFze (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 01:55:34 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2106.outbound.protection.outlook.com [40.107.93.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E39CE1C932
        for <netdev@vger.kernel.org>; Sun,  9 Oct 2022 22:55:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LBtTdAdaIfGPOIdGgvBRN1fznDg1ep3+71GSY+QCUf0etsEpo/FhC6JHc8JcFqPlezAVkrolOWjwKC34MKac/SqMsvVx1cxIHmDW2El+1STET/gGdfpIICn6hVo8kWtKLNsVcOw6IEAcbScLfFc4x9jYomAVfqGRPWmf5NnlbGAtTJMHjJxvIErth2FiVRzVyrYS6uRCupTw0QPe49uzJuRPAYlVu3ZMFl2YSYXPKn1v4TRo82x6gQCaI9UjwL6LWU4HwNaOYfgBCXMgo15FMIl2hDEb69Qn3AZFMIVVB89CscwHcS/1337JWL7XaffKFXtDvkZz1AxBhcGX9WwEXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yZAWpJ3pJh3xmhPr1A+I4r1FKVB0Rh+BXSN8M0XIZkA=;
 b=Tj/Q9dOxBqVA42ZhWxXU2Jz1wJ0VrXTYHws1NYSGPaeona6GUY6QSB1BENmu27swXrySca2MAYL/scABaE7u01LChrimoAkx481jNp/UPpfFirKMkkp5Fqaj1yfJHZSaGgBGdKgWPGg99T60BfuUh4H8+PNWsbwtkiRXqInbU9LuflVD4lf+G0P8Oz7Tx+0YuH1jwQDlMnCL16V755AV3A4eqsee/9ISzE3queQ6BUatJpL19tdEP/nwtSB1CHCrwnS+Y9MZ75bcgZegq3USTR26bsN/KP41dBi5IrS3x4GPUrf/BHIIq+78+xqJMRD3c2S5/VSySRUCbemKQbs80A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yZAWpJ3pJh3xmhPr1A+I4r1FKVB0Rh+BXSN8M0XIZkA=;
 b=Z4RfejXVrI0fxBSt37iZ33l7dscVTVh2JQ/su5H3ke1md11weRIjsXrdOb0LtfUs3/xLN01c057XAaa0E5Qmtdf8uZ2KkrhdzWYFBCwsScCGZYs2TJkqGhCDWpKAdgTKTPg2vZXMiubrCMPaJCgvVOAwcoilDUhUQHujV5YwszE=
Received: from PH0PR13MB4793.namprd13.prod.outlook.com (2603:10b6:510:7a::12)
 by DM8PR13MB5125.namprd13.prod.outlook.com (2603:10b6:8:30::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.16; Mon, 10 Oct
 2022 05:55:30 +0000
Received: from PH0PR13MB4793.namprd13.prod.outlook.com
 ([fe80::7898:4120:ce3e:ebca]) by PH0PR13MB4793.namprd13.prod.outlook.com
 ([fe80::7898:4120:ce3e:ebca%4]) with mapi id 15.20.5723.009; Mon, 10 Oct 2022
 05:55:30 +0000
From:   Tianyu Yuan <tianyu.yuan@corigine.com>
To:     Eelco Chaudron <echaudro@redhat.com>,
        Davide Caratti <dcaratti@redhat.com>
CC:     Marcelo Leitner <mleitner@redhat.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Simon Horman <simon.horman@corigine.com>,
        "dev@openvswitch.org" <dev@openvswitch.org>,
        oss-drivers <oss-drivers@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Oz Shlomo <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>
Subject: RE: [ovs-dev] [PATCH] tests: fix reference output for meter offload
 stats
Thread-Topic: [ovs-dev] [PATCH] tests: fix reference output for meter offload
 stats
Thread-Index: AQHYyEUGFPUOQEXU1kGl/roHEuXMU63fCpuAgAFRGqCAAAgrgIAAAeKAgCKMI4CAABI2AIAACqSAgAAV6ICAAAalAIAEGYrQ
Date:   Mon, 10 Oct 2022 05:55:30 +0000
Message-ID: <PH0PR13MB47935AAADFA3F91D8F574C9F94209@PH0PR13MB4793.namprd13.prod.outlook.com>
References: <20220914141923.1725821-1-simon.horman@corigine.com>
 <eeb0c590-7364-a00e-69fc-2326678d6bdf@ovn.org>
 <PH0PR13MB4793A85169BB60B8609B192194499@PH0PR13MB4793.namprd13.prod.outlook.com>
 <0aac2127-0b14-187e-0adb-7d6b8fe8cfb1@ovn.org>
 <e71b2bf2-cfd5-52f4-5fd4-1c852f2a8c6c@ovn.org>
 <00D45065-3D74-4C4C-8988-BFE0CEB3BE2F@redhat.com>
 <fe0cd650-0d4a-d871-5c0b-b1c831c8d0cc@ovn.org>
 <CALnP8ZYcGvtP_BV=2gy0v3TtSfD=3nO-uzbG8E1UvjoDYD2+7A@mail.gmail.com>
 <CAKa-r6sn1oZNn0vrnrthzq_XsxpdHGWyxw_T9b9ND0=DJk64yQ@mail.gmail.com>
 <7C59A1FE-1005-499A-A87C-4639D896F6D7@redhat.com>
In-Reply-To: <7C59A1FE-1005-499A-A87C-4639D896F6D7@redhat.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR13MB4793:EE_|DM8PR13MB5125:EE_
x-ms-office365-filtering-correlation-id: 8ba27122-409c-4979-ff21-08daaa8409af
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: g7pMcTlXJFneI36wUq0frbuStBoF9bvPA6BF0N2T0aGmSTg1ePDec/kFzN/0mAVrUAojFwKU4H3LwxcM3NYCVECwZC/gcUbEIPuKwAUB/D1788Da6nl9PbPPp3d/ycKDsiVr1TG/PnEj2+81pZTPmGbxnOr7ge1dQ9O2VHe6+TlUaj+DBOzHdp19gECR0O6osmjq4eYPWJxkeLGKuc8No+20KiA/FvR48qXZ+q9nL3xTh9Jg6MVLflqC7zAwxuXD2bfbrTOiOUm7FMaVInRV7WOL+97KCqAEjVH4sznA6ea/D95QEB8WawjPCmyTQOwU+gSfbE9Jmz0YKDI0dEk1g+vX5N2uxj8+RVF+bqeQwGEvRtqMSiLWR9Yqh10I+3lMyYWIoulSEj5qLPmgu+clC7znEWk/+otKcGH/3xd8VZSfCcAYGuKLnIfV3xf+pfuUDXLFvdO9wzUmVfjR3EWxWwOUTWUMIyz6mVk0CaT77wPvZOkoYqFLtyatFEpNUET/IJ1CBZi/H+u+c37yFYmhoJMfie09XNAoj26lGctExqh2MaROTOnFvc8UgYs0snAgwDxykEVqvW++xQGvzJVjcfP0fMuMXLr14E/5gyBBQqnZUlJbxtnBtMMynAO4jqhm6YCudq6Uit3CAv1RA1n9z5mzqWUCJ2snRKB5kFiAV5cyEr6Y0f4d/nwIDUXbY1GseWS7IT/AxA7MPieUSvpnv/pYLGdSGsLR7Cxwl2O4JanF2HgmcKdvOIW6MEd2kgXE
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4793.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39830400003)(136003)(396003)(366004)(346002)(376002)(451199015)(38100700002)(26005)(9686003)(53546011)(5660300002)(55016003)(7416002)(7696005)(6506007)(66556008)(38070700005)(86362001)(44832011)(66446008)(8676002)(64756008)(4326008)(122000001)(66476007)(2906002)(41300700001)(52536014)(8936002)(71200400001)(316002)(478600001)(186003)(83380400001)(66946007)(76116006)(33656002)(54906003)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?WqXi3Cc/hOtZNECCgqQokXD+9mZqMp3i2dhH/hpxjbvPufadI30bsgLpoP4r?=
 =?us-ascii?Q?Rg7OU8GvahMjukCBmvwQjc+L7y2VV55ciYrrOnU2CfRa4A58AnbVW5YhBPtu?=
 =?us-ascii?Q?BGj09bzf8oMSQ1NV+HUckQmQKOxZEkYOiI5Rl+/wVFWegj7qUC+aoKU4u7Zs?=
 =?us-ascii?Q?3yCD0xZ5hOKbKRNTjDvuMMtQCfzbXM2NJcWMMFVSFxoZOFp+Qd4GA0dNNB5i?=
 =?us-ascii?Q?etJxYNrEiOHuqJuzih2a/APHPOAFOFW2cnGk8M9d3SGXT9pz5BP/CfTxidxx?=
 =?us-ascii?Q?cfkrpaiF6ERmqHqyQFsASFcTv7qmd3l+dfi6n6tlUIY+n61gSo74nnm1IckV?=
 =?us-ascii?Q?wC8OLuklqgt6tMlWAp8QUCXzPhQWjZXlAYl70w+g8UexckgwWDIhJFmrWkxV?=
 =?us-ascii?Q?un2Dn/ZnlpY4+mUc6JCPiOclk3GDnYiw2vqqe4uagF7JCnKAGvLvgOvYPFYk?=
 =?us-ascii?Q?y3HJdbe8M7wzTXGencvKIk7nquWH0QwnBFpEu5YPNHVfa9Tu4UT4i8/i3w8D?=
 =?us-ascii?Q?lgYNgy3pUGAg+wmuBm9GMg5+zp3ht5ZQvDagxA7O2ngH0AjTbSn79VwPxonG?=
 =?us-ascii?Q?aRH8LePA/cOc3JQ0BBeAiPbam/P94T/xicPQaMeNUa6OZT74sT9ZBK9tbezu?=
 =?us-ascii?Q?4zECM2mWlqz9Dm5mZ8OwmH9bAQlJILPi3bcHbcc9Zwo6tHDJk3cLTgQpqxYm?=
 =?us-ascii?Q?vZnYKJ9PXZRPU3IYqWeiL5XC7AIuNUY6AV56EUOvYzmH7VAKbYw95p6X+d2G?=
 =?us-ascii?Q?c03Avt3p54Ocl0H8oI/ByGHFsP/ECeEJRayIirYHFL6mwm4kUlCbd1GCYpvj?=
 =?us-ascii?Q?+FqZWzkbBQkMopIk5IHXqM7h3wJ+O1iUz3JyG1Qxa978Gh+Ztk/HeNBpUKv6?=
 =?us-ascii?Q?jixiBEKQr0ILN63cpy+AUdGMSYiJoIW8Flx5hrpaQwjEd6TxW/6Yhw+51Zaw?=
 =?us-ascii?Q?g4NMLMo7uGeL717asLgsQ4gs0ZA7DJyhun0+9b38yAcq5pnZqtfXJC1FakN3?=
 =?us-ascii?Q?ei2DmuG6SxS1H2eUyroAlD/17KHsDEYllwDUCraXuc/2SFGacOsPfTA2AwnF?=
 =?us-ascii?Q?7K3JVxYYTqBIBPKBAxdCtFT66RqEVc1oF//cZFPil2TyROeLVrwIKi6FLTq0?=
 =?us-ascii?Q?Qq42PcsK5pwUjuatSGE9/ivxWmPug02uvO24+Mr5/05aR4452cbPXkaIOce2?=
 =?us-ascii?Q?dZaq5tSEyBUK5K6f//ssRpyZJ6Bkr4pb1zeS6TWhNgvJ5bek3OIXuP38DVKq?=
 =?us-ascii?Q?+GVEs/mdn6eSujKSr7UWIBIpxLiuCIf6u+qm/MkHfVBbQB0jywgGxBGpFYe7?=
 =?us-ascii?Q?lrLbj115H5T81EcfjmDlGDigkiQavUMIcjMP3KMkik1qLzuuoMQxIbF0GaNk?=
 =?us-ascii?Q?f0hVecMlnwtXpkJv5AGhUxdwK9FDFmDWOolwYkdvxepXmo6eHpKMxAvDHuUQ?=
 =?us-ascii?Q?PvrAIELxFsL8NDMKjrg8WOCW3KBGWyRvnuFw5DA+kCwjD8vPAlcwvKdKrnvX?=
 =?us-ascii?Q?mpyaXYGkBT86fdBc+oVewMGEbtYjI5kPBAy1x9dlWAy+mWd3cpVA7bpIAPaB?=
 =?us-ascii?Q?AS25WaCLU/8hIEwnzWKSY+VOMhj6Zsy5jTeYob67?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4793.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ba27122-409c-4979-ff21-08daaa8409af
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Oct 2022 05:55:30.0655
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pFrpR1crRA/YNqTD1MkU6uQdfidMuuCUDonYPRg1E4BqEHSISFYrNuT2DNSB1OFeR/vWMr5qkeUsrS5UXc0PFRd5TE0RPEi1Z8EjcxfULWE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR13MB5125
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10 Oct 2022, at 13:40m, Eclco Chaudron wrote:
> On 7 Oct 2022, at 16:39, Davide Caratti wrote:
>=20
> > On Fri, Oct 7, 2022 at 3:21 PM Marcelo Leitner <mleitner@redhat.com>
> wrote:
> >>
> >> (+TC folks and netdev@)
> >>
> >> On Fri, Oct 07, 2022 at 02:42:56PM +0200, Ilya Maximets wrote:
> >>> On 10/7/22 13:37, Eelco Chaudron wrote:
> >
> > [...]
> >
> >> I don't see how we could achieve this without breaking much of the
> >> user experience.
> >>
> >>>
> >>> - or create something like act_count - a dummy action that only
> >>>   counts packets, and put it in every datapath action from OVS.
> >>
> >> This seems the easiest and best way forward IMHO. It's actually the
> >> 3rd option below but "on demand", considering that tc will already
> >> use the stats of the first action as the flow stats (in
> >> tcf_exts_dump_stats()), then we can patch ovs to add such action if a
> >> meter is also being used (or perhaps even always, because other
> >> actions may also drop packets, and for OVS we would really be at the
> >> 3rd option below).
>=20
> Guess we have to add this extra action to each datapath flow offloaded du=
e
> to the way flows back and forth translations are handled. Maybe we can do=
 it
> selectively, but the code might become messier than it already is :(
>=20
Thanks for your and others' comments. According to your comments, I made
a test by adding a gact with PIPE at the first place of each filter. It see=
ms this
gact will successfully record the stats hitting this rule in sw TC datapath=
. But
this approach doesn't work for hw tc offload since the nic may not support
offloading this action.

In current OVS implementation, the flow stats is updated by action stats. I=
s
that possible to collect filter stats in kernel TC when dumping actions sta=
ts
and use this filter stats to update the flow stats in OVS. The filter stats=
 could
also be transmitted by flower option netlink messeage.

I'm now trying to look if this will work.

Best regards,
Tianyu
> > Correct me if I'm wrong, but actually act_gact action with "pipe"
> > control action should already do this counting job.
>=20
> I think we could use that, as we only use TC_ACT_GOTO_CHAIN and
> TC_ACT_SHOT. And it looks like TC_ACT_SHOT is not decoded correctly :(

