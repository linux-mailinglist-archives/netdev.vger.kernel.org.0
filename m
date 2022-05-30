Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 341A853754C
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 09:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232531AbiE3FkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 01:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231211AbiE3FkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 01:40:15 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1845060AA0;
        Sun, 29 May 2022 22:40:14 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 24U1RhPA020067;
        Sun, 29 May 2022 22:40:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=3lb3dEaVcahd4zN+F7VZ081zZCGfKJ9dBDRTyi4F6hw=;
 b=DIPPX64TRfaW0YLFtADxq2rG8yZJVszwZPvNJNbRdncNE8Qm1vDaRbTKr6QCkWaMjRd6
 CUJByHmguGUagixFc7j/78f/ulJLUEHzJwPeilLUyaK36YUfTK465NFtuvdJ3WmlyZsr
 XG0yOycQIF5pYpKZ6fY3SNo8r4HtPkfl2r8= 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by m0001303.ppops.net (PPS) with ESMTPS id 3gbfdt6v9p-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 29 May 2022 22:40:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J/cP2ItyHKSkw6WIoblBsjOm3aSZHYBomfX9pi9JbRwMN8CLNGNc3rangAfdzMsryf9Kzyf51iaQrXV5KWgDKhnNM1s9r55xlyej/N469Ru4vHjeVvdqlg257a58SsgM/mj479ZfnNTulvhU0ytTdgOSQ8Zij+hV9dR0JFUPi+xtQlsPZf1uYyzoD+DhgdhfHgbOUvOrQ1ZWIeXJ/n5N5GhW6LohMS9SZ+H/pZgwTSsxcxqB97SwtcXA8E7V/tOCDTa6za9RfXxlhVC/7sPs03YNKg3gBEdP6Uf6/Uc+SFs9rQeTQ2L7ZKLg9JgNYoP/G35q3KsP/IHvN2vcR6ooQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3lb3dEaVcahd4zN+F7VZ081zZCGfKJ9dBDRTyi4F6hw=;
 b=lzqEhOoiBXrNYYL7splO6FY/PJg7qM3BeldOpQkDBOpTuGUVgHiso7demwW7iwaVHPcblKRDVFyBTN8yCjug6oVvi2Q7o92H0xb+EJ6NfqxPpr97lY1bEnt4QW7w1AXiN+VAK2tbeWDw/WIvVwX+XPOP9BUZQT63YhuIegiNtQNQ5Sgn2HlSgUq7DfpJNWrgv6TLHi24S4NCs34ge1OjFTsv59+qNXzif+z7SORkrvs4MTjQTyJ/3gls5YpiuhilDIoqPi2Bap+mi4dhivRCcAJ5Nk0djdymohcecCyhFKyB3rWLpvNZWsuEnTxKweffOQrplkhuVX8Yp7lfzVHM7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA0PR15MB3838.namprd15.prod.outlook.com (2603:10b6:806:88::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.19; Mon, 30 May
 2022 05:40:11 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::3061:40ff:2ad:33aa]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::3061:40ff:2ad:33aa%5]) with mapi id 15.20.5293.019; Mon, 30 May 2022
 05:40:11 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Jiri Olsa <jolsa@kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>
Subject: Re: [PATCH bpf-next 3/3] bpf: Force cookies array to follow symbols
 sorting
Thread-Topic: [PATCH bpf-next 3/3] bpf: Force cookies array to follow symbols
 sorting
Thread-Index: AQHYcgxSVBWsVySjlUSr8uYpYc7Mn60261yA
Date:   Mon, 30 May 2022 05:40:11 +0000
Message-ID: <A562FD5D-AB25-4659-B5C6-A403374AECD0@fb.com>
References: <20220527205611.655282-1-jolsa@kernel.org>
 <20220527205611.655282-4-jolsa@kernel.org>
In-Reply-To: <20220527205611.655282-4-jolsa@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.80.82.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c26d798e-3e82-4de7-78bc-08da41fedd20
x-ms-traffictypediagnostic: SA0PR15MB3838:EE_
x-microsoft-antispam-prvs: <SA0PR15MB38387146DDD2CECB2B16D3CDB3DD9@SA0PR15MB3838.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: x6+t4SSLdpkLMikZigiUMy8r0TMfznMZxSTSYJxerT2+Vvk5+59I0LL+/TvcxCFsGvhMeah19/pPctGFi/6UFC+GwHPKqpgq80I8tx96jxfrfwv8+D2gnnCTeaUMcQL1gqTKhnp0LXXXWT72k4NrX0+iw86x+Ld8wy9s6tIG0h74uiXu/GNXxepTx+MKnfB2CmPi0UAzZnxq7QjGigArzQIQlCBbqJsId7AIXPu9bMH69LyJXBkeC3Zmx0MNVK4C+EGUn4rp7px47LffBv8XPk17RGWLgWuxKsBoVbtWV6fdBHu3PzBvUnINLRptnuVDK2LoNeMeeXowQizPx1rGgUkfsKfMarZa2dLkcP8nFekYGMMEIRQJU69EMkI1h9S4JHmEXCHXCipzmP8YUzn3NWDx7ToyzLpNzBQ+K9KhpznfjYnt4mQECdvlUaV65S0cKqupypX458ipnQriGdT9Sc3H7ZGVni36JF2jCINUt3736HqZ6fkTpibG69y6mVPAhwPG73r7DHTvGkfi/mcGiQPxcQBtnN/1yf4BDRk1hsqi8Skvg23Tx/Y78i0FhG+xZbSGpbv4VqeE5leBSxHDxwc2Y/TWlc+CkLJ86+JI7PPSXABaeI19pr0zMAQcsYel7nHYpDEgQ3s1Q4fVh3yNlIfajn5FCBT0x+WRVJnlJmsM0mTTdApnshb/8DiJMaqEvirgIb2hk8sJH6biaA5YIseBZsEfLl3WknnobZ3cZdVrWfi2d6ZTDajVVwMThWh5
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(71200400001)(4744005)(6916009)(53546011)(38070700005)(5660300002)(7416002)(33656002)(54906003)(38100700002)(316002)(122000001)(6486002)(76116006)(4326008)(66476007)(66946007)(91956017)(66556008)(64756008)(66446008)(2906002)(6512007)(2616005)(8936002)(86362001)(36756003)(8676002)(508600001)(6506007)(186003)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?s1FI+72klZt1aD8ZAwml4Ij725qs3aQpHwQwFANYHHcCMuP3Jt0KljHOwad3?=
 =?us-ascii?Q?13HAa7MjqndB+A0iS+ezdTeCVojinwsuJk/MeeaQjmwoQa4WqgbxY97iJooU?=
 =?us-ascii?Q?943/cXyerKnN+ljnfNXnjyz+KwUhx/vBTELXho4+0dvXt5WN+gCMzLh07eCn?=
 =?us-ascii?Q?vH5wdt2gcKVSq/4YePQyukDRu3Ia0y2R6iBhcwqK0bYDzs3hfAXZCjRTFbNS?=
 =?us-ascii?Q?zsyD5pPN+/PudP/19hEYCvX01P9dFmJMfww8jq+7iEwnMYU+CSZGFu5scz7L?=
 =?us-ascii?Q?jy6YIGFxV2WCQA+9hcKCCwN2gjegutk4Lp4rtIIcL7dIeZCEHSsRx7ovBiyt?=
 =?us-ascii?Q?6PjbkQwKKcOy7sQUd6sDXSAoRxvDkZJg2D5x/nXCKqOYIeyqpMqCTkeLxI3W?=
 =?us-ascii?Q?XabIDo+eDkfA+2GbflDO80hrUh7eiK5QN2nL79FCVG+OSIqijiDnlPw+dNDM?=
 =?us-ascii?Q?WiUVo3wo8GCXqidOE7oRGYdY2X/UJSNZa7C/yBzXHuoin7LUfa7shIPD39EQ?=
 =?us-ascii?Q?js3R524AI8avxBjC3SQsx2FOJfGevmPmMXGB1Q17+I5gtsro4amWoTdEYAZJ?=
 =?us-ascii?Q?15NFE+vdP8heoyrJDB9R38xTtygHIptrYM1R2er5c/Vfr5PTY12Vx3gSgsGF?=
 =?us-ascii?Q?eSy7j4NVjL7aUU0Ybr/1Bf5Cq427smph6DJR/LwUl+1wglhopUGuBNCNdjDO?=
 =?us-ascii?Q?rAn73V/3P4zfQ36BhZWg1nLBhIUtRPnbGUh6EPk10awYvYMLziPmcDt5V/Uj?=
 =?us-ascii?Q?NJqFkMKh5allKvxGURA3p+c+CigS9umy33zVfozWI6gu6RbRv3v4zrhMb7vx?=
 =?us-ascii?Q?h+oHLlk66D5UJAWTJ1TuJtcaQi0RfOXxnFlr/eN3KQHVEnul2pv5jQFik9U/?=
 =?us-ascii?Q?xs3jC7usStIH+nH8fK4ojHfnr1+eYS+mhFyqrioRpUUuWFw4c8+jBqbWOHZ/?=
 =?us-ascii?Q?PD18rvjyzVZcyFKG49j44fcUTM27S4PtTv6MjxyvtNAxEZu7fN9NihHfHcya?=
 =?us-ascii?Q?HK3Y/dTCOyuiyrhIxGQgtQdP7d1Yk/foc+o0hDJ+1WnE5tlLvN+qvRvdQp8x?=
 =?us-ascii?Q?kkHkfre9P4SQ1w69tpzHReKe7DRIFKI4etHewRCWdXU4VY7ql5kZ94HFKEyS?=
 =?us-ascii?Q?pp12f/XSsr/Hk2XNhJ2f8o7qF8cAC21ImS+RA0/jW7cOML2knNqIjY2VjHO4?=
 =?us-ascii?Q?DF8nZ6Hiw03xZHDDzfZtLkKgO+wWvC7yk+RYRuoeKRDz/Lf5KabuX7lG1h6U?=
 =?us-ascii?Q?1dEBeGH5scVXWnIKg1GdygaWfk61biyk0brQCnshMRSiExO2IUmVlf2iOtc3?=
 =?us-ascii?Q?easylV/+0gzhjxyDyjpazX2Dt1dLFx9IJzE8ekXM7IJcTkhVvQVD1RP8l9X+?=
 =?us-ascii?Q?TR953J2hJ69hBh0pWo4MDO1J+bWrNtGa0HD+yPgk/q1z50ftJyVSYVVHfTF4?=
 =?us-ascii?Q?7JRhl1tWxD+YXqo2QgmTq2b+bNK+UKgdYly8DqgHOFTc/dUSfy/AjD7kChtf?=
 =?us-ascii?Q?tS1QX4xWEFCuNsMkn078VTO4ZuPgGFU3DEIL9m8KkUtDttXgvg4zpPFKET9M?=
 =?us-ascii?Q?Ff1w16MGgWgKUvwUpTT7E9/jp+5qs8N98dyd42XlWjWwKyvtRtD9xnya3rry?=
 =?us-ascii?Q?GoUX+ShLZKtm2vzfMtijK/1fEmLipkWvZT3E3So3NJsRDelDGc91/NI2mpk0?=
 =?us-ascii?Q?NuMgxLLrZnsE0mTBLT2PnN5qMFtK7UGNluVnMywH/Gty9tG9k1kXEJnEEusf?=
 =?us-ascii?Q?lrIdXL3JWtXYiCP5p+BBI9qXQ5Q9VLJZxDtopW5obWpp/DPAn2qR?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <02E738643A63724FA82CBE3C43F0AB93@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c26d798e-3e82-4de7-78bc-08da41fedd20
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 May 2022 05:40:11.3580
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zVExeV/loRFiKmDU+j02bthh50ESyHB/yMuvIaz7Nom64os7N/tHcVRl5O7kW6fL3YUZt/InAbvh1D1tOgv5Uw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB3838
X-Proofpoint-ORIG-GUID: HEkuBvT6355fHo_6U9hH3jQKvKuW3i2i
X-Proofpoint-GUID: HEkuBvT6355fHo_6U9hH3jQKvKuW3i2i
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-30_01,2022-05-27_01,2022-02-23_01
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On May 27, 2022, at 1:56 PM, Jiri Olsa <jolsa@kernel.org> wrote:
> 
> When user specifies symbols and cookies for kprobe_multi link
> interface it's very likely the cookies will be misplaced and
> returned to wrong functions (via get_attach_cookie helper).
> 
> The reason is that to resolve the provided functions we sort
> them before passing them to ftrace_lookup_symbols, but we do
> not do the same sort on the cookie values.
> 
> Fixing this by using sort_r function with custom swap callback
> that swaps cookie values as well.
> 
> Fixes: 0236fec57a15 ("bpf: Resolve symbols with ftrace_lookup_symbols for kprobe multi link")
> Signed-off-by: Jiri Olsa <jolsa@kernel.org

Acked-by: Song Liu <songliubraving@fb.com>

