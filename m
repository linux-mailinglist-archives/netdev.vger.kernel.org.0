Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8139B512517
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 00:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231571AbiD0WNt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 18:13:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231495AbiD0WNo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 18:13:44 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4504213;
        Wed, 27 Apr 2022 15:10:32 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23RLlPmK012389;
        Wed, 27 Apr 2022 15:10:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=OQ6aM+94mzls77Iq39ePxI760WZ5ir+m0B8pWhjlGpM=;
 b=BsDsNFHsiNsG/5azzjqbMVaHWKkQ+DS0/pZ2iTNwwgY3Iwd4/KfR4Qbf0J9J5WtbYgQJ
 V9iA9vJpVxjzKDjhmgfTkZUd1cTC62kqM77UsRm+tmY4My3070mlwpYqM1gPozUGDyNI
 KmS5ZzftQ5j4lz4tQ3RzeInJCqspqBssy+0= 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fprt8g3md-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Apr 2022 15:10:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QLg+iLfStIm9BlVLdONl/Hz+P2yAh7bePGDSKcQAsoWsQp/n87nVjJo98q+kvUaGleZlsmiiQw4UB1DnTVuLgtmFSE9e+dhEFI8mXGcoZVCzY5RAKM7ee9R4jQbddF2LmxLf19Zjn/a140s9inAkjK6dZhJy+AJWjpQ8R23WDRCmFjx0Py2Z5HnuG+AIUQ6MQC7HNwE7J1uf8JGFlZkO5AZtBpLnIaT+w6cy7E1jdpamnvZxJGNHEkyLFFzKFKFWE+g0uFLx1uTbclBMzzWfhYd1DVX7N5U2B4k3UuSJBPxipTlTMQ1Dxb7gvrN3B8LPwpO9jiFeRrhi6Y8ECARqjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OQ6aM+94mzls77Iq39ePxI760WZ5ir+m0B8pWhjlGpM=;
 b=caC5rTdpHdWEtlGGgqeX3ZTY/cT274cB06iAqIciLf3TKG6Tj35/8a0mDOSlXNs88+4oKOI760Iab3UDGmPJAWk93s5GJ3M6GzQT+lKyyBLTWM8/zGdIsSUiWKA+Koebmt4Tm6WWQFNvv9OMaEJX1b6a2jJg4ZqYMO0BOdNVNBUqMZZl2tpnczvOtci0gZvDc1d1RkHpqRzJ9QtAUWDJiCM9BYyf1aP1ghYJ7HTLI2V0dxrYy/FpA4CsEh5zva6jqN36AEbH00YXNlgCPU9vkaT48wKJbL5nbM4+tYSXW2E4jFAAMlT+2YcZygIV3BVGgSNCAq6eZ6EiDgkDgyo+LA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by BN6PR15MB1266.namprd15.prod.outlook.com (2603:10b6:404:ec::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Wed, 27 Apr
 2022 22:10:29 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::15bd:ee6f:cffa:44d8]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::15bd:ee6f:cffa:44d8%7]) with mapi id 15.20.5206.013; Wed, 27 Apr 2022
 22:10:29 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        Christoph Hellwig <hch@infradead.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Song Liu <song@kernel.org>
Subject: Re: [PATCH bpf v2 0/3] bpf: invalidate unused part of bpf_prog_pack
Thread-Topic: [PATCH bpf v2 0/3] bpf: invalidate unused part of bpf_prog_pack
Thread-Index: AQHYWOUphDgBQzjiX0ac6c+Sg/0OBq0EVWkA
Date:   Wed, 27 Apr 2022 22:10:29 +0000
Message-ID: <FF2E0EC1-F9D6-4196-8887-919207BDC599@fb.com>
References: <20220425203947.3311308-1-song@kernel.org>
In-Reply-To: <20220425203947.3311308-1-song@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.80.82.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cf7e484b-f10c-4e05-94ae-08da289abd8a
x-ms-traffictypediagnostic: BN6PR15MB1266:EE_
x-microsoft-antispam-prvs: <BN6PR15MB12665D2211F77D06798C41C0B3FA9@BN6PR15MB1266.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Y7NtdrYOjp/kOEUVKZW3xw6mzqqIrgqD9t+fKHrhP97grB0o+PAzzhNHvsAT9ZQsRW72tL7UM4N5LkcjT+77Stpi5QgIbAdEIpDJputYsCTXtLZHz6gKMZat38tqFiir8f7OuJvKLl1jN6PZJtGQX9pqZUrLYgsQoiFImAkYOGArWvKrAf/MSzPhYIzS2ie8cEe/NX5kmgBRvZKs0FVb1dzcVfVysCW+w1lL8+Q2FDVoHHb0JM/HejBkhSFrfEP7lrIHJS81zZ3VGft3lP8Yl68Oqq99E7wVR8IS1bIFLwyKPzUzhh9O0vZ81/sYez51UjiaDzsJXmNheKczH9wgve2A80vPFJk+k3bP4Rt6oO7kdS/AJ6WisjKhS5Lpj4ReqP0GT7s0VeYrWow4Xbb/iDoWrV23tBI2cq8tQSf8srztzwrShYgRHBer7PhD6lJm49VIu6nbyTcshSuXQ9vndAJ9S4zihC4LLXZ3YJhlVyNb+C/PbX4jbitzMyV19adwD8SpbW3NIvVPTAzu2xWfTFKwZEDGCmZMTmP/xz+g430bqnewODzfNGCQ0paLqAevxgpuwMmtjmnuwdZROfQex1sKVGerZCMQjdtRW5VtMOVyuE89CWFqRA6iBMz3HSZsVgqUseNcsJ/T+yZIz+0LxvfVt5fHD1twY11yzSn09waCUoGKLgMpo1QcY1qI+GPhvSXixPtXvCSiurL8zfpwY1QsbTSnMAk15Sjqu+lak+Sa2ZB64FBhdia4N3bVgHvHPMNZ7QNJMoS5mSWhDUGTaiWr32dWCyNBx1cg4AUeqYyOyURsbxLDAdvcSQ0tpw2RoOfbsUDVY7GPavybY2Ec7g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(76116006)(91956017)(7416002)(8936002)(4326008)(966005)(508600001)(64756008)(66556008)(6486002)(66446008)(66476007)(66946007)(71200400001)(8676002)(38070700005)(38100700002)(6916009)(54906003)(5660300002)(83380400001)(36756003)(316002)(86362001)(186003)(2616005)(2906002)(6512007)(6506007)(53546011)(4744005)(33656002)(122000001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?eLlAFkpy+R97OtvaXbplECFspHVg6FuKZiglWaSQNZfbGyQvgvRqrXCGl1O0?=
 =?us-ascii?Q?lixs8+1b1VxEqxazd0lw7oH7gjGczw7TwFgDLxu6/J353lWtYfquVmA21iWK?=
 =?us-ascii?Q?HL6jXAerQUMcfKPi9UqOpKjoS1di7LLUniZ35ENf2EZwbWOSTAeqN9JhfC3v?=
 =?us-ascii?Q?gQRfRt8IDEvdCxZNkhZSI/ecifMcFOVMZ/4vvBLhDpuIsg7FufLg/fKc2gws?=
 =?us-ascii?Q?nnglrnpQlU0Um6WyAtAUmhZXCnuge4vKHcoIOYSCkWQ3xDNA9O88Kt4vQUhH?=
 =?us-ascii?Q?rQhO0WriaYMQLrjJIY/nqYqBiK3x1ZDUzdKW66gCFV71PRieIT6w8qKUYyuB?=
 =?us-ascii?Q?MhS54YfQQVhE2Hu8DzsigEifLEc4W8RwwbXBvnFwU7f9cdHznMfmKM3rPnub?=
 =?us-ascii?Q?L8cT//QHFbtuc1lZD6HKed/qnHWKw/ia4DjsQj4vfRtsu3p6ZOtCm+yktLqV?=
 =?us-ascii?Q?xQ0AJGnjP2nxBQc1jaoen37y3erd2cK4m5FQsvaGhGuSTSgh2141MI7M0Rbz?=
 =?us-ascii?Q?G/jgNjoQPsxlTZ4Q+Gc6oDA7y7beFmrnrWKluVOubsv6GQ2JN8tg2RQ3o3uE?=
 =?us-ascii?Q?TfJRoTUcpzHO4UeuVwdNHWdZYkI+h69uVQjnjmf7fppmaFW0LbviFKcgCVz3?=
 =?us-ascii?Q?S4cdVf0wsTCXVmTk9NnfNMMoLgwJ+PEgXmhSt+M8/MJQbkSkrKWQoDuUzMLN?=
 =?us-ascii?Q?8io423LKou/pk1yPFThLk2kb9+wQdovXK0858St9QWX+d3ABmh4GR750rZmN?=
 =?us-ascii?Q?Y7IBgMGJq2FDlHGAX+puc9lHdFRyfZjlPJ4JB7RkHF5INwizAk6SiBqsTmFK?=
 =?us-ascii?Q?+85uSDcExHEloilaICqDp2iA5DEugo8Yi2oG3J1y3zDA8+OEolkQWKSZt3Ae?=
 =?us-ascii?Q?7+7Rw3I/JjrDwRZdrOiFsippLkFcxmTuTTEUDU83W04a4v0oOzRHpfyQSACN?=
 =?us-ascii?Q?+qaAVH/tgxs9PE3ul+1wsPzkS6EWjeY1n5Oe0GIp4qmy73NK3+7qfJH7pGH8?=
 =?us-ascii?Q?wYpEi25wakxQBH7pTBw7W58LDNK9NGbUex8519+gHrRoXekEFSWtqGoFmNpK?=
 =?us-ascii?Q?TuqjVDf6blPVA8x4VeiH/MvOBmZVMtS0PjS9debxLWqw099wljtvvNldqnw/?=
 =?us-ascii?Q?mXmoJN3G6Uy7EWmuXzMZjSMHadmYP87snsYTZQjwQgRg3scD25ZCiXO4JPeg?=
 =?us-ascii?Q?qd0jK0lmjsSPB+/Au2clXwRt+WusHpWxH7Ot6F1pXHNP84MftEJBTIPuqfHX?=
 =?us-ascii?Q?wz0axwDWUJPHDLVrPL7I+NUQoIEJvTlcz6IHdqf/l/R4td/A26uzT6btWuQB?=
 =?us-ascii?Q?tnkKofyV4fzKmDNEV6NQBqiA65nmZGHFIDGNmoYL8BZb2j0NbvOoHnVC++CR?=
 =?us-ascii?Q?6a9ZvLVv936i4rzHSAhHj8mmwZLsY7OlTjuDThoCIEU2wX2As4j3PWHPsIeI?=
 =?us-ascii?Q?uK4/LeYysS7EbsG1cbwJnASsHbBxRmBj5hBl3SWrWVvKKw84E2ImMUweBUxX?=
 =?us-ascii?Q?4oX9zIvQFpBOaVKUnARnzKsZiRtb0jafwjweSSHNwpYR0nvQN9lGTmQFEsWF?=
 =?us-ascii?Q?ghKyNiKa1gMHe2I89O8Biy5NxujNmelc3/JuCyG68eu7rECkdZzrCtqAkXoy?=
 =?us-ascii?Q?eWwKw0N9QLEPmnLwdUQNEq8F07u5B2Lb+wjoiAOkwX7MnlBFB15aw8+spFrL?=
 =?us-ascii?Q?3tzSW32eli2NCA8ToyeXkMePwXrKO3888JjgTvBTclPBp6UvfS1HRsxi4ZX+?=
 =?us-ascii?Q?TRk7QbF4pSPsa/LAlnfv4vpNKWABlp3d1YBKEB0/oV6ia0iyctuZ?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <87A5FEB731A2C14EAE380B04BF2F7D2F@namprd15.prod.outlook.com>
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf7e484b-f10c-4e05-94ae-08da289abd8a
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Apr 2022 22:10:29.6084
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RSBCyeiDDsJF9BsxPL92QpLWxILjDlFI7LfRpfcAfburG1/45ewriV1VOdosPmclHMZyNnifOs/ookp6MBpysg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR15MB1266
X-Proofpoint-GUID: 7GH8w3TO3SD4tjc4GjEAaYVgbhRMi6zV
X-Proofpoint-ORIG-GUID: 7GH8w3TO3SD4tjc4GjEAaYVgbhRMi6zV
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-27_04,2022-04-27_01,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus,

> On Apr 25, 2022, at 1:39 PM, Song Liu <song@kernel.org> wrote:
> 
> Note: while prefixed with "bpf", this set is based on Linus' master branch.
> 
> This is v2 of [1]. It is revised based on Peter's feedback. The patch is
> also split into 3.
> 
> [1] https://lore.kernel.org/linux-mm/20220421072212.608884-1-song@kernel.org/

Could you please share your suggestions on this set? Shall we ship it 
with 5.18?

Thanks,
Song

> 
> Song Liu (3):
>  bpf: fill new bpf_prog_pack with illegal instructions
>  x86/alternative: introduce text_poke_set
>  bpf: introduce bpf_arch_text_invalidate for bpf_prog_pack
> 
> arch/x86/include/asm/text-patching.h |  1 +
> arch/x86/kernel/alternative.c        | 70 ++++++++++++++++++++++++----
> arch/x86/net/bpf_jit_comp.c          |  5 ++
> include/linux/bpf.h                  |  1 +
> kernel/bpf/core.c                    | 18 +++++--
> 5 files changed, 81 insertions(+), 14 deletions(-)
> 
> --
> 2.30.2

