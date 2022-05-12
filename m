Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 805BE5252C7
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 18:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356579AbiELQkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 12:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356574AbiELQkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 12:40:14 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CDEB25A78B;
        Thu, 12 May 2022 09:40:13 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24CCEJsA022848;
        Thu, 12 May 2022 09:40:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=x+4Sd57FuLX7168+6+24hltmig4ecSBFvlfoKDP2zuk=;
 b=Mw5eGerQWa5KNn3ClSveWPpL/FINph6ApPXUdKFowR4Wwq47JSFJ0/7uUqo7JziQWzSM
 nQb7CnAYYn2o+V90a1fCvtGOgqlJH39uuxurwiz7qXs8e686Ft8iSZaQatpwQUTTwtab
 4EnKpWvE/ubk2P8fZSVxk506/w7Hn35XBOM= 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g055hutu5-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 09:40:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S5R3Xj9BLNn57gOlISEVokmdrw9aRrQQNTeXQan9cQxaEJ/KUzHR3cEGkOlGgeIr1lpanv+mgWW0O21q5TqtMQ2bR3sEpp8xLW+i2tf99FqP9TC75NCJd9KbhKobx9c7yvALZmNNkiEAcT0Z6bOn6fp6pc2IFL1jb9Azrljvu86e9JFqyKJf11A9NugDBM0VhDUyLNTIbxcmdmIBUoLlTWbs0qJ+G4RYK6qXzbnrPN4Jm/tAXjGV3VWGSFmynFbyvJYinQcbhUJdb52c2Vx7Pi6E25g+qhyQqpnF0eAlDDoIHIb1KTcHFFJIPi09LeJAXonY3g6jxqE4ApARGxuzJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qryt685I33NBx554p2iJO9jcO77XX083W+Qu8DFXTIU=;
 b=eeP6uvSQA5z7UsSDaYtqLh+el4ecnTEudfrZb44bm6JYG7atNU06SGmMiPVSJkRaEtsA16aGWadpS/w6y+WuVO9tLCEPaJCHXieF05vSyteq7zOYDyxzkPFEKpgA/pYH3C1lYFe/EHWcGRRFbp1VdlfSp5u141kI+TLEv6lq52x3PA9+a6km8EWvLOi0L3e3k+cwGfCLJRhbWkRpmviAyML2n0UTf+TM9qEuaqTIqwfmGCcbBO6HdraWyaCNM7+QtMD+hQG1MwU54lC4ehw/PMum/aUKkl9hKXSAFCRUERvGMAMJr1r4Hhf51Gtztyt6VyTgVvi6nZPsp11Ko85iCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by DM6PR15MB2345.namprd15.prod.outlook.com (2603:10b6:5:8d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14; Thu, 12 May
 2022 16:40:09 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::3061:40ff:2ad:33aa]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::3061:40ff:2ad:33aa%4]) with mapi id 15.20.5227.023; Thu, 12 May 2022
 16:40:09 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Wan Jiabing <wanjiabing@vivo.com>
CC:     Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] bpf: use 'error_xxx' tags in
 bpf_kprobe_multi_link_attach
Thread-Topic: [PATCH 1/3] bpf: use 'error_xxx' tags in
 bpf_kprobe_multi_link_attach
Thread-Index: AQHYZgsIMIVDG4Y66UCqI47+lLAf5q0bccsA
Date:   Thu, 12 May 2022 16:40:09 +0000
Message-ID: <97736EC2-A393-4E8C-A7D5-7C6D3CD26CEB@fb.com>
References: <20220512141710.116135-1-wanjiabing@vivo.com>
 <20220512141710.116135-2-wanjiabing@vivo.com>
In-Reply-To: <20220512141710.116135-2-wanjiabing@vivo.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.80.82.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 20d52d09-b5f2-4a4e-1b4b-08da3436140e
x-ms-traffictypediagnostic: DM6PR15MB2345:EE_
x-microsoft-antispam-prvs: <DM6PR15MB23454D1CB3F5B91504AE51E3B3CB9@DM6PR15MB2345.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: G5hSqTCmdfCHwGu65UgkFWa5CZsQfdo3I4e/gnjN8Y/f5ZpeA63RZt3E7n4l694Sh7tB3yoHnIWt+qCX1U7iObflKBR17PDXlVsHOp7wv9+82WArukD45q12g2wheXJCfEx7NJnvwx6ZwyAdnTatdBsUYWYTxT/60FqYl+J6hFx2AJwajrS2e0CuIkW0yoNbJdpWzoz0ihzUcUIy4V93gAwQbLuM1WekSnjKauMEwWjuXBpbhtW68Thown9iGD3VigHw8NXWREE6qDdhfdN6Wcxdh1rvQ+k8kYlDiqEOfryZ6UkPoyA8y+CS2+V6XabP8SnBCvqVtRdrOOlMYR6D59u2CjBySbSA8rsKkFVG8GdPSSTHqOpjeR43Y+eyRcu+zK5DISxmewno5wg160Gr4eUA1FhzKEECc9NSwbEz9Ls9y0jKAcgqo+LlgEpnTGjlkDlQRcsZDFZiYtzaPQQwH5gbjt1t5nMhSW6aF0M3CqTH4s2XhBdpDNSEriuOj+80qFWE98FSurj0Jw2Apdmj50TeZde2/YuhnN4NXtbQRhKOSpPeI1LPsjP+aL/xqVDYBDyxScYr+aihkYhPLv7JuLhTbP8qpgZFGmkIhwsZgrO21J+1oMkw0LYR4ehN6IRWNjpMFLdOIFtCaEkaIEVvtSjWKKgWFR6KC8OQnCEjrDu5OJ5pTc0tjmmoUb6W8TFTkEPZbfK4StCdSX6gb3rotVBBobKP274+URCXXHnB+WR0XMLqw31j+blBaOGwNaS+
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(54906003)(76116006)(6916009)(91956017)(38070700005)(2616005)(6506007)(6512007)(508600001)(5660300002)(4744005)(53546011)(66446008)(66946007)(36756003)(4326008)(8676002)(66476007)(66556008)(38100700002)(316002)(64756008)(83380400001)(6486002)(186003)(7416002)(71200400001)(2906002)(33656002)(8936002)(122000001)(86362001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3xWDkRfnJkTuNmLudm+ySepGC7rjv84Dq1S1uuh6DZIMwYbDooUNWMLOsJwC?=
 =?us-ascii?Q?pSyYWhQQJMtiF1kSY29I6vkAZ2S0hJJVCWXnG3LKzY5hgU/24pmxL0hWRIFK?=
 =?us-ascii?Q?5fZwLj/4g/UBwFmnDMLS4NXTtRQ0Rl9EPRtMxAl5VsVK0VSjNRItAnuJlQZt?=
 =?us-ascii?Q?003doIkOE2MmoOy1/k6Z6wqmm35Xc3XUr2iO11sTO8aZ25++KsSOyEBAfLw4?=
 =?us-ascii?Q?IPjvZC53y2p8V7fFMXayuEjwAfGzn/3MQ/k3umhf9mun8r7nhSXAzyvLss6R?=
 =?us-ascii?Q?k8v/gLO8Ixi0xC2ILwA5SROc0uz22q3woEh+guaViFwfSeoXn+KU3rbJilLs?=
 =?us-ascii?Q?2D7bZZKdI26s4k/EjkwTpFmPvuHISgexKI2ogLebBzXu9DaJL2SW+z/udCA7?=
 =?us-ascii?Q?sbZXRzLyQ91mqUhazwPsRY/I2yhwj7yxekHEHPHb/7SuctO+MCTzIQhlDuGl?=
 =?us-ascii?Q?Bnyqt3nD09N1f1bE4jjP8tu+g71yhINLCZjNOJzP7KTmqmLB2RQ6c9ru0Xdl?=
 =?us-ascii?Q?2OY/+8yAVwBeE948y+mHAylRQTw1V5tKjKD8gARfoT18YqnLFU2+fab2F6yG?=
 =?us-ascii?Q?AeRUHyxnPHiFkAj72Wv6mPielkij6YpmiP+KXzYw/MDh+evTiAO4qNIeDuDu?=
 =?us-ascii?Q?Oaz3upC0p45VPZvsAiTEZ74gE9E8vVYPA5jzAMQEjzwxEEH5k4SGIX4JQUGY?=
 =?us-ascii?Q?SBTtNEvuZFPQ0M1Cpm6ZnQtoV5L8BVDveo5gGwiN6+0l5yPG+8Su1ZeeqOAq?=
 =?us-ascii?Q?ZzMrP09ofoOSYWnYYocQZYSMwEUvA0+mBFfYBI97icXmleYYt7tNCTH3921c?=
 =?us-ascii?Q?9BWuAT8MNUdkKwX2lQZaZBTFhQxLhVD5rHAaR8pqRRXY4/4+aBDbedHs1zwd?=
 =?us-ascii?Q?TRRETJp1gMAuv9D6pOqOXO2E0Qzfbdm7eny+TFD+OB5olwCe+5vI+HpxcuPL?=
 =?us-ascii?Q?8tbu1UX/DIOLEIUq7P6lRc5sgq0KFBBt8kivpzEeOazuvk/y37FsXZ3cq9dc?=
 =?us-ascii?Q?iwLyL1KQTPbyZvORJwgZdEa8i6hyhYEmf2gG4EGkV9RSezKRTA3sDafEzYV7?=
 =?us-ascii?Q?uK7gwj2JqMxx2JI2oQATLCzA+26JvRV1zMHT25opEhcVGnMxKv4Oghgk5aYO?=
 =?us-ascii?Q?y+gU9FsQQqC0ZzytIp3toAyxER1cOtshbgco1oM5LMdif3riDArS9AZUrx1A?=
 =?us-ascii?Q?5ugSBb/gX8gVjnrSEJZGe1+XL7Dq4g4gkAQiqFp8W0v/IyCz1is2iq0nOZSq?=
 =?us-ascii?Q?+AGvcjt1UU5JmrRkte58R4s+M6k+r6ZKE/3iWyGPg1eT2wLeZ5ZmpeoG1L7I?=
 =?us-ascii?Q?hbHYCEPYU0grvrdvVPOJpqUPRHdXXU65cDGR/eLYfvRD6QfMGKm6PPYgRJ+m?=
 =?us-ascii?Q?1ww0kc+Sm62JvATAYap02wD9mixa7WPRN/wd+hgVvGbUAZ+9hyTNdMiQCWH3?=
 =?us-ascii?Q?hUbKvkN7AFDXCg8i+3eAtbSuGQ3rA++/Qs2kMHZ0yDmkQ1205q8naBRyB45+?=
 =?us-ascii?Q?bu15MYZlWrrPRdcvDz79IeFcWHoYPLhBi+ZaaXP6YkI3Ci833hVrb99bXhje?=
 =?us-ascii?Q?laGYp7pzZrgCETQ35eoJ6Sm4ZzLhV2C5Mr1Qo0+uZPbMC2EC4MpgfzxqOr6s?=
 =?us-ascii?Q?p9FM2lS2ST2buSxA/PscgiX4JfLXWhiK5b+lq6guj5uUpaNy8Sjug7Vb4gj1?=
 =?us-ascii?Q?lVgSdorq3z1DlGnXlCDbfcwW8XIIb5u1Sz9t04ko4qT/UBjZ/d7nOZ1Uymlp?=
 =?us-ascii?Q?cggBFoXtexO7WYwxZbNjh4gR9TWMv9rAwbuKynRgXBftABnXaGYJ?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DCB5951702674649860595EF9CC188F6@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20d52d09-b5f2-4a4e-1b4b-08da3436140e
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 May 2022 16:40:09.5224
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GHTyz7S1GlcZng61SX8VGIcY/I2iKq5jiSYO33TXVokO8fusGldQdhFwGWWqMsKUZ9ee98BsmeYScXDIB3fuqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB2345
X-Proofpoint-ORIG-GUID: 9v9YAR4acjzkyPFHyz9DayvbKFa8M0Cc
X-Proofpoint-GUID: 9v9YAR4acjzkyPFHyz9DayvbKFa8M0Cc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-12_13,2022-05-12_01,2022-02-23_01
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On May 12, 2022, at 7:17 AM, Wan Jiabing <wanjiabing@vivo.com> wrote:
> 
> Use 'error_addrs', 'error_cookies' and 'error_link' tags to make error
> handling more efficient.
> 
> Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
> ---
> kernel/trace/bpf_trace.c | 20 +++++++++++---------
> 1 file changed, 11 insertions(+), 9 deletions(-)

I seriously think current version is simpler. 

Song
