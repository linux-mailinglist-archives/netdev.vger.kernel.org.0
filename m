Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BDC15711C2
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 07:15:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231289AbiGLFPc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 01:15:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbiGLFPa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 01:15:30 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE4D18238E;
        Mon, 11 Jul 2022 22:15:29 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26BNCNxN009483;
        Mon, 11 Jul 2022 22:15:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=y3Da/pjKg7oVB7RthE1K+wRqmdA/jS/CL15VJkSclJc=;
 b=mB2a11ox4hUuh/48jkZUlCrg/XJ603a02VZtqDdJqqfIh6bwS8MV0H21DqnIH3C5axDs
 d3uViMXY1trcP0QOBYYCI1pSWjNdxXXlPPyUIGfMqSPmaJWuQ5fLj/zjXNFJyqBhxcP9
 y0WxyIwI+jhXoGP2IxlEjJ/Io6UTHTquUck= 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3h79045h5v-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Jul 2022 22:15:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ua+EGZInU3XYRX1FiDhwscioGgxAwh/rkDjREDt8rf6Dbkk9YBGA57Z7lPGNpoxuIrTS95GFk/G1swglXdTEZaCibr+gItSkhe0kkdPbq6bisXXJe0QMgxyfd6r6xhhNTlFz80kyU42Y1YyulIKEyNIoCSNvyVYR/o7s2juP2rTpA+AqWhzFb1grD/NvQ3dg/3d8TXqLk0r9GKO8Yb9ohGeGcRmMtZ/hX51DyaOW70QO2SnoG4iYKCqAno5/yPnqEll3ZZRJoTNe6kji0ysaY00B03LGXC99OK7TkJ67VGo2koXs9MUxLukdf+mnm+PeCo+y3z+K2RH03CYWK9FNZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y3Da/pjKg7oVB7RthE1K+wRqmdA/jS/CL15VJkSclJc=;
 b=iJ/QWh59Irm9YCXrsNfXY327F6EFfZNn6WBZWTVqp7vhjhhczq0kYeweg4oNGAjkEwRIHIZkgV/RJtszGXMXfTpu9FsITI7i6hoZ0/Ga2neuNTVKZpXqZVV/ImYanR1ea3jsMdf1p6ClaRwyeXfmRlhdIshS7D39361sYDtRus6j8hS8PaUnlkLQ77r2KUlPzXdOinIHfMUEtgYyHESW8rM94yETpTQ9VlfFqQP49qFeuppqdoKMJbe6kvVX/+BkEH4aYw6Y1C9wvTALFAksdGo1hZ5W/cTZhlaYLulLU+J4ZlxdEhZ7eJ2dIJhiHkkdFXtuaJzVK7LibzhdRFZiYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB4966.namprd15.prod.outlook.com (2603:10b6:806:1d5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.26; Tue, 12 Jul
 2022 05:15:26 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::e8cd:89e9:95b6:e19a]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::e8cd:89e9:95b6:e19a%8]) with mapi id 15.20.5417.026; Tue, 12 Jul 2022
 05:15:26 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     Song Liu <song@kernel.org>, Networking <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>, Jiri Olsa <jolsa@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>
Subject: Re: [PATCH v2 bpf-next 0/5] ftrace: host klp and bpf trampoline
 together
Thread-Topic: [PATCH v2 bpf-next 0/5] ftrace: host klp and bpf trampoline
 together
Thread-Index: AQHYdrnMgR7UbO/WnEm8o1uHxIdxmK16Fg0AgABZSIA=
Date:   Tue, 12 Jul 2022 05:15:26 +0000
Message-ID: <8B0FCB44-6241-4220-A1AE-CF91AAA25777@fb.com>
References: <20220602193706.2607681-1-song@kernel.org>
 <20220711195552.22c3a4be@gandalf.local.home>
In-Reply-To: <20220711195552.22c3a4be@gandalf.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.100.31)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 12e7159b-2eba-4a4b-8733-08da63c587d8
x-ms-traffictypediagnostic: SA1PR15MB4966:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xl0sx3gTs2lIHabOjrGMvDvX9Yy9dul2d51doQE6M827MjCMxlmOmBjO9WFgpuOc72ScGA1nyJZ+Y+fY8aWJRqrn6r7j6UAVnOQPHgnfsPOdoCxu+vbDgzgSvJsmDhpJ6ukM+5aWDAp66qBAWsSnxhyFFo2KYWlKVgWtJYBJggfPcw4luI91xAK+zHF0CjD17FoD7sxEKzTe89XdC8j3prRhyyiuNY4dHlRewTndLH897xlPy28DdKQj+zwIGHMHX2DnqhVMkuT3G4xNtsS9OzHiZNZOrcnZuIr2QQc0dico5PUQd0vWfugOKGVgJLjDS8NreT518jWoLy3SUuwhNvzEEVdort5tB5Y1cmdtbYY0oPYEYQrBhaWgcq4nRV6CKwE0ibbzWBx+LjHObruj1sjJmPYi8NW7pDHgZJEudwHGqZJWDMJxEziNkz9Q7jUDJBqSLok4OF0NI2CF3WMeJlsnowWLONC4LiiEtBgBsruTzuS+4aKegPC4fYzXBG8gYL7QeigLkK+IgJpU8uLg3LkCu66DvLd+0BPN2WaaJnMgi4hm8fx/UwPKXXe9stxnmpuHb3QPl/PCJ9egcY0YWazkYtUCWWpNrtAp5j8Of2VF/0RWzJh3E3ubWxZde3wlUZG/gzunZWUbq5iCcbp5O1YggoxPvLtKZ7XL9LromlVFx56DnRrRmqegHytOhkfiFYwrObh8XyxjV9SXOwAO/wUtNJYOB7UqNfHyrz5oCzlteE1GaM+WwbOOLoVphureBTH3xR9y3KMBdF63hf2pe9LKv9tqpgFMKcs4YLdCZWAqp4HCZ3o61sUG5bXsg6Lg+px6gjJvKlzHGrl1Z505UjecLybt7ghwkQRSSjnIsFk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(346002)(376002)(39860400002)(366004)(396003)(71200400001)(91956017)(6486002)(6512007)(6916009)(8676002)(54906003)(2906002)(41300700001)(4326008)(64756008)(53546011)(5660300002)(8936002)(316002)(33656002)(6506007)(7416002)(83380400001)(36756003)(66556008)(186003)(86362001)(38070700005)(2616005)(76116006)(122000001)(478600001)(38100700002)(66946007)(66476007)(66446008)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?SwCYPs07m/wAnE5qhyY3M/W77aDD0O3hODk2VQghJ0KaUmhWxy7VK11fr5iW?=
 =?us-ascii?Q?BUFUAoFH+YluDJSv/hHcQKDiCveJBFsu9Ldt0yJd6tOqv9LKo+8zTyzJvjmr?=
 =?us-ascii?Q?Q3i9mFnht/Gwb/n5RzOXQyjJvXXMt31Q7PP3DOa19o7xKaqvx+cXb+lOgl+b?=
 =?us-ascii?Q?8XvvCqqnPgnUi5xTRXd8/VelD9Dqs/DUfiJ/OMUfFVwozB1A5inP6Y5q/I3G?=
 =?us-ascii?Q?WnDWp3TkmjhvQXlrCoQaUgqQkPIoq57u2GefeWpTSlVhnXZkwRIdLK8mCmoD?=
 =?us-ascii?Q?qtvapvpBXXd2uaI0zfKz0SbvC156cegs9+xybMPJbGQ/ADu8bY6ArgLz94+9?=
 =?us-ascii?Q?DCD7gJ9VumeMh9uodZHQ8lLGjZKvdJB+KfpXLC8iFA7U7IDr73FvHzEqNdhq?=
 =?us-ascii?Q?/PWZ5SGFjwJdedL82RohuaATYwX9mhj4xHZrjH77BgQ7hHaUpV2uIFo2m5j0?=
 =?us-ascii?Q?tvScstfzQRNAkoXH2gIAJ2o50r1H9pv9WSKv6H49l3/79Hgkv2TCobjPE9Y0?=
 =?us-ascii?Q?JXnT5Ioz/byISDHbd4zTY3RPINs88WeU5XWMU+McKKHmWAy3HiRWLio8r2Zb?=
 =?us-ascii?Q?UMPwzr4gtSVyZTbaL7iIPnVbjSc60NOlNDaJjC8PdaExGWH5NtTn20AxXX+J?=
 =?us-ascii?Q?LhvqMXlgbjFiqVWIZ31w4JxSTiVxBgUa6xITv7Th8vjYgU13wzhvOejlbAKU?=
 =?us-ascii?Q?KOKzFddPc/3Q+MMGwdJz2NgOupZXx83KuSD4JZZe9hVu3fvEWie6wTUdQH4P?=
 =?us-ascii?Q?AP49QyoCPwD7bHjlhcQJxD/fuFPPDQlhWrJi+2Sx6eADTgTHVyPmqkBaRO8g?=
 =?us-ascii?Q?+TCxPSoAdGxbAXLerfz9RLdIhhHgJ37y7l4cqsPCrXuN7bXEmHK5j+1pG6Nf?=
 =?us-ascii?Q?kCknQXQzjY4WcsINT+ntRt34KYDSj9wkdc+C/rEm0mBuUVTbFFs7FL4YTEtL?=
 =?us-ascii?Q?AIHcgZcbNjpsgM9VzUzA0hzJ9nAndwLJZ/P4rOgCO7GCJwLJ80pucrKPTwKv?=
 =?us-ascii?Q?aXp+dlS73MNIBC9GxDQsvDf5WVI8Va4DuXAUWK8+U+zVQYlJl1TOThuqOYvG?=
 =?us-ascii?Q?EI24h9VcMeM8quE1cEKNmVzWYMLkC9OgHYLrpfnmgK+eV6k3DM41A1JltXFZ?=
 =?us-ascii?Q?9HrV8HAXLHKiV9ZsSKEls+ZwzFnb2MZByE0vI+h0M7Yh/ERaqb4JqQnfZm3V?=
 =?us-ascii?Q?LDhe6dJmntLy9P25fguWSWoBfgxdBo9R2/aEi5mDxYbfvslSYl5PDriwl02b?=
 =?us-ascii?Q?7T1LyHkNrkWXbmYrtbaK4vsos6sR0Cpl+vukpEEO0MN0BBkQshxmGpWHnvfe?=
 =?us-ascii?Q?aoVXy/e0RFXJSdzxm9ptCzyyu7dhuO92eQiuHveKRtKZzstVA2BTWPtu+mfN?=
 =?us-ascii?Q?nHc1/TMWJLhrv/RVr7DyNR5jDv8HeMte1+jec0uYIyW+IsGbLKs8tfsbc5ZA?=
 =?us-ascii?Q?ad4j/wSfUZqoQr1MqP2ZxGeg8o4NW6gqOwEgs/3dfyzbwT04xO+xIjsRrrS4?=
 =?us-ascii?Q?esv6FDDpxSJUD9wFU/L2hmtA8bHI5E/pgkhRRZxZ+f6WAeVPCp5ztoATiLy1?=
 =?us-ascii?Q?KN/rLEJWczvVvFVMwes3j55RSrCc91BAS1GEc+d567vsije09v8cGZit8za7?=
 =?us-ascii?Q?FGKy/B0g6QoAQOBLvNeQ7ko=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0A964BC18D363A4F97E8D7CB3D832762@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12e7159b-2eba-4a4b-8733-08da63c587d8
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jul 2022 05:15:26.4856
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Lk4+5bvLngiyK9Fg0LTMgm7paGEt8GdMCr5VjQPctq5uHGPqnuUEAErVvRrurHuXLYDaW+YeizMLP1KQUTm9XQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4966
X-Proofpoint-ORIG-GUID: M6n4Pgt7f76FeOGH5MJdPvnfBtsJT8kj
X-Proofpoint-GUID: M6n4Pgt7f76FeOGH5MJdPvnfBtsJT8kj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-12_03,2022-07-08_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 11, 2022, at 4:55 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> I just realized that none of the live kernel patching folks are Cc'd on
> this thread. I think they will care much more about this than I do.

vger.kernel.org often drops my email when the CC list is too long. So I
try to keep the list short. In this case, since we are not changing live
patch code, and there isn't any negative impact for live patch side, I 
didn't CC live patch folks. 

I will at least CC live-patching@ in the next version. 

Thanks,
Song

PS: I am the live patch guy at Meta. :)


> 
> -- Steve
> 
> 
> On Thu, 2 Jun 2022 12:37:01 -0700
> Song Liu <song@kernel.org> wrote:
> 
>> Changes v1 => v2:
>> 1. Fix build errors for different config. (kernel test robot)
>> 
>> Kernel Live Patch (livepatch, or klp) and bpf trampoline are important
>> features for modern systems. This set allows the two to work on the same
>> kernel function as the same time.
>> 
>> live patch uses ftrace with IPMODIFY, while bpf trampoline use direct
>> ftrace. Existing policy does not allow the two to attach to the same kernel
>> function. This is changed by fine tuning ftrace IPMODIFY policy, and allows
>> one non-DIRECT IPMODIFY ftrace_ops and one non-IPMODIFY DIRECT ftrace_ops
>> on the same kernel function at the same time. Please see 3/5 for more
>> details on this.
>> 
>> Note that, one of the constraint here is to let bpf trampoline use direct
>> call when it is not working on the same function as live patch. This is
>> achieved by allowing ftrace code to ask bpf trampoline to make changes.
>> 
>> Jiri Olsa (1):
>>  bpf, x64: Allow to use caller address from stack
>> 
>> Song Liu (4):
>>  ftrace: allow customized flags for ftrace_direct_multi ftrace_ops
>>  ftrace: add modify_ftrace_direct_multi_nolock
>>  ftrace: introduce FTRACE_OPS_FL_SHARE_IPMODIFY
>>  bpf: trampoline: support FTRACE_OPS_FL_SHARE_IPMODIFY
>> 
>> arch/x86/net/bpf_jit_comp.c |  13 +-
>> include/linux/bpf.h         |   8 ++
>> include/linux/ftrace.h      |  79 +++++++++++
>> kernel/bpf/trampoline.c     | 109 +++++++++++++--
>> kernel/trace/ftrace.c       | 269 +++++++++++++++++++++++++++++++-----
>> 5 files changed, 424 insertions(+), 54 deletions(-)
>> 
>> --
>> 2.30.2
> 

