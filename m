Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F025571866
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 13:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbiGLLU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 07:20:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbiGLLU0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 07:20:26 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D044D2AC5D;
        Tue, 12 Jul 2022 04:20:24 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26CA8xCS022656;
        Tue, 12 Jul 2022 11:20:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : references : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2021-07-09;
 bh=FxfuCCEAH/Nj0KVF9vu6R/Spc8Ca2Iq7Tz/3/2a6tn4=;
 b=J2xGjMY2Ed0LRCH4AjkGOlofaeOAsP85Zc9E3NgTg5UXlBfRvVtEhIi8ANCu8E+AWEvn
 H0AIehwOLyQ4QJHYVQcvNw3ko3hYQSIXJMc9fNOHdV/psxzGtVxJttNBxtfACGm96kiL
 y5m/miwohaEI8gG1PrvUeyq+t5VESl+INPdyznJ5/W1bJS4vkcfl/joyLtOBfNDkJHni
 DEZRa2xAMSg5bYMSWnpMFgafagwi0Y2Va3loO4yQO2o4GGUgmVII+wkc/h7LNC87BSpb
 rRsQIQRz+Q2/9cIhh0jBsny3Od3nxtG/N6L+RodZCR1WjnkQQFeyUQApIfIqH6VRS/i8 iw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h71r16b0j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jul 2022 11:20:00 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 26CBAZX1003207;
        Tue, 12 Jul 2022 11:19:59 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2045.outbound.protection.outlook.com [104.47.73.45])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3h7042tx8f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jul 2022 11:19:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZXUBcZjRuR5ud6GClcfz5gcwBuxrYfHIBsrjdokPoAxgMD3zULZ8JLV96OJV3FzxnHhsp0juT6SIOT3f3SY599I7/6zSznA7RyS9+hE5kNIKV66f3qfXD4QQkTvi8NZLBoNUtHsWkAVW3itHZS4YqiEp5gCQxb3Jm3Be1nGB0zMK+U0VVLUm5mgt/oI+XWd33AYkjT3VRqf8xdQZGc29kwr3yFIPTbZwOiWcQI7Vc+gxnAg/eovZkLaQ1eTjyNrY/ffapy/mZ3iv4rwEY1A/uLqmvkiN3NcxoCzZBYZvoeiUCE4TErjX+9mpMpUnlCuKZ9/c3Pm93Z8kKuOSEGJoSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FxfuCCEAH/Nj0KVF9vu6R/Spc8Ca2Iq7Tz/3/2a6tn4=;
 b=KZBej9wYnDASBH4TMk0ZDMTihnEznzTjXRHUPpUr0BC2LfKmh6Q2TtQYvO7uRlD9IMTngEkEscOfYbLgXfTu1ZnGCaXV+WV8/aicYjsqsQNewvcgwDIwsvOWyo7gEZqzA3UWEoUbdePFKkIlPJmrN/EsCzBXQPHd3SCgg9144co4CoGVr0Df4jMclcgwnzBpWx44iPuzV84UoylCD4dbrzu1Hb+/0iTZi2TlCBvGNJ5Ek0Wl1XivYEKV4FWapgCMEz1Rc4fv3OKmZ/MYJPoONvHTC4rnEZG5Qg2apBI+n6y+SDR6pqX2atUpg+Edr/ISck+gUNw/BSGpy/8U8y6jAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FxfuCCEAH/Nj0KVF9vu6R/Spc8Ca2Iq7Tz/3/2a6tn4=;
 b=0Q6heMIigdjdwD1guZm+kFVinOgG2o+ple5BPLHBRBAtfyz8XCh4zm+PvCQgN0fNeDLr9orHW/B9k9f0rEfS+x1euptHl00kESRyYmm1VTLT50BOBKuIdDJF8bG2kuMajDLAT3T6jiR2uf85E0Nd0wLh9Kxgq4R4dDmW1aX+rvs=
Received: from BYAPR10MB2888.namprd10.prod.outlook.com (2603:10b6:a03:88::32)
 by BYAPR10MB3494.namprd10.prod.outlook.com (2603:10b6:a03:11d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.23; Tue, 12 Jul
 2022 11:19:57 +0000
Received: from BYAPR10MB2888.namprd10.prod.outlook.com
 ([fe80::b5ee:262a:b151:2fdd]) by BYAPR10MB2888.namprd10.prod.outlook.com
 ([fe80::b5ee:262a:b151:2fdd%4]) with mapi id 15.20.5417.026; Tue, 12 Jul 2022
 11:19:56 +0000
From:   "Jose E. Marchesi" <jose.marchesi@oracle.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     James Hilliard <james.hilliard1@gmail.com>,
        Quentin Monnet <quentin@isovalent.com>,
        Yonghong Song <yhs@fb.com>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        llvm@lists.linux.dev
Subject: Re: [PATCH v2] bpf/scripts: Generate GCC compatible helpers
References: <20220706172814.169274-1-james.hilliard1@gmail.com>
        <a0bddf0b-e8c4-46ce-b7c6-a22809af1677@fb.com>
        <CADvTj4ovwExtM-bWUpJELy-OqsT=J9stmqbAXto8ds2n+G8mfw@mail.gmail.com>
        <CAEf4BzYwRyXG1zE5BK1ZXmxLh+ZPU0=yQhNhpqr0JmfNA30tdQ@mail.gmail.com>
Date:   Tue, 12 Jul 2022 13:19:46 +0200
In-Reply-To: <CAEf4BzYwRyXG1zE5BK1ZXmxLh+ZPU0=yQhNhpqr0JmfNA30tdQ@mail.gmail.com>
        (Andrii Nakryiko's message of "Mon, 11 Jul 2022 21:40:34 -0700")
Message-ID: <87v8s260j1.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.0.50 (gnu/linux)
Content-Type: text/plain
X-ClientProxiedBy: AS9PR06CA0179.eurprd06.prod.outlook.com
 (2603:10a6:20b:45c::9) To BYAPR10MB2888.namprd10.prod.outlook.com
 (2603:10b6:a03:88::32)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e6de6edc-ddba-4c82-99ff-08da63f8737a
X-MS-TrafficTypeDiagnostic: BYAPR10MB3494:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9SM7YNv7gDBmsVgptxnhQmx7yLGBQ5K3yEwDf/6XEdB2d6EBrB6d/lqqS6NGdvkshVaKCkKbyHXlWqYnY4Kn8UIMyoRbpCZVtM+i4WGNLqg7d2ZSn9wAPzh0zs3W2NKRJ0YVtGIYSBEWjjgLTVu9K4j3h1OxAfM7M/0O+xPAKmzObT/TJSQyT+UAcQ/XJ1kKdI0kg8LIhcN+YiMc9keWuPiMyhTtrMR3+5wr2/y3h2CPYp0UTVeCiE0keeZ+3D5Hsz1X4yHgIn4o/G7pPrCQtyTPKvqU/H7Z8AJQElJg9D/jtfPry0RvTStSicG8BwjAMPjAtjx18H000okNvC55BPQOtjTMQ9JARmKdQtdKtovyhXsPd4gMZiM+UDMNoqKdyzUMfCX/l9UtVoS+wStBCX5YB1CuZwIj8l7Gj1bg1PgOcJX1z+fX0T8OCDhs6LXmXaNQ9V6VpOUBYTUaBiCj7bszCGnpUnjE9XnTl2V9Yu4fp3qauMWHsiJlZWAwBFTCcfjaX6x5Ea9Gq/xMm5ej/Bdtw22TY7KzF6Er2g1nrFT0QrUflFiXE5GBxkf1W507Iubo8Rv37DjJVmlyZEneDNb9Kfz9TE3HPHlVGadmb07XknQwUQoGDJ5YuKnItGG34EkDRW0k2h0wwtLPRKkZIpR6hz3KIDANbH2hCttbCV39eVWIj5fr1kG62bx2GzKYeKr7E2Nm0BHgRZ+74Eac8SeAhGgV5O3swnoXhgCxOrWGm8tuDUHacI+WPLCidP3GVUNb+jUOX7rsREIJLNjgyM7uanweGkgK0HSZ4I/xu6Ux6bMWwoEm/7jrFMc3q8UH5UEFfTmHc/qEIGp5NW6IDw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2888.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(366004)(346002)(136003)(376002)(39860400002)(6512007)(26005)(53546011)(2616005)(41300700001)(5660300002)(52116002)(7416002)(2906002)(8936002)(478600001)(6506007)(86362001)(6666004)(38350700002)(186003)(83380400001)(38100700002)(36756003)(54906003)(66556008)(4326008)(66946007)(6486002)(66476007)(6916009)(316002)(8676002)(966005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?I31rnxksP7OCjoC/9xf+KtfA5VoO5QNIoGC8g5sRnvhTDxns/RJC81K8Yksb?=
 =?us-ascii?Q?h6Zb+3W/oSLRoMHRbfI8QTPKl7cTe0ywfM7gcy2oUtIUhAOW5IY2N+KvFhoM?=
 =?us-ascii?Q?miobuTQe6oipXAix0ONfFo8e74HIRBqZr8iuNi1qQwOhMW0eIMqo7FJdWxCN?=
 =?us-ascii?Q?R2RLRppINk7s+i4ujhW3WOib6mV5iIdPbL8qjY34j/0T8GWt9Bk1tpnrZaNI?=
 =?us-ascii?Q?im6qWsz2oC0jpiSfBi1ptaXcSlmHcvjWQwSISGrgnPJuwnBpEvL76wu33k5q?=
 =?us-ascii?Q?6bgZDHPV05Q/b9q8X7qXQPfkPK+97T6IpibVUg7Tjq4tBtRx0lpyUPSdt5F9?=
 =?us-ascii?Q?PczuDhaIJQ1j5F8MMa65tLd/LY1eCKeCqW0NzlO8HzcihwHbODs2+wqn9Yuj?=
 =?us-ascii?Q?8ymN+jJH+aO3HbWw7kzgmpoB2hsxElCJGusH4Dk5XWwY+yrSWIVFh9cSDpl8?=
 =?us-ascii?Q?W6ZRipaS3j3Y2oAnEPTSRM3P+HjuiDfk9frXVUhciOllLci19aHCdFzwtx3q?=
 =?us-ascii?Q?ebkjdF/7Jyygwt1UZcuKJbt7+stvX/Z7armKxltT6ZP8LqPmmrlcmW3AE2+M?=
 =?us-ascii?Q?uSe0jobok/Mf59XwcB9zr4TSivwIp4lICJbzTOkBRmgekAw3rpPA2H4cHdfR?=
 =?us-ascii?Q?6jtGW/KzQwEyOc6k5aQzJ9vEaKA+jInsXWurBGt9mxV551lM325EaNJ8Crqy?=
 =?us-ascii?Q?3rLtcDTYzlCOpSIl/uYDvEdaZrXprnV7r5kY/ZMfagU69eY1wqARcaXdb5Dx?=
 =?us-ascii?Q?pF1MshCBpj/azdl3MnSYWO30FpW+1nGO3vb1hzAStQB+oCSERyKUxPmBG1C3?=
 =?us-ascii?Q?uXVE8j4F/qNq80g4r8KrMzrDOeE0VW23rVqkZV2DXSrT8BgFIaWz6jjRsmHH?=
 =?us-ascii?Q?LWnYaA1qB1uXhJ1vPgFi6lYP9NbRXbRa1ph8YFKwe0heFyPVK6ZC/W3TyyN0?=
 =?us-ascii?Q?B1JjROn2hNywFB9r42mf3dnUIr4L2ZNq3nrVRyxy5AwTxKbqe/3dVqZmq1YF?=
 =?us-ascii?Q?GTS+103M0b3Akh3B2PCjwjbq3lquNISFFEjL0S4puKqmy+EVNBuZ4uVe46WO?=
 =?us-ascii?Q?HyxdejB9J/oe9uyPguKFnGnugwLKDW/gIZXfWWCnUOtBaD58/zpZmqjxnDz0?=
 =?us-ascii?Q?1eOrZyebf8tbC4JQ26fzbzCGcD8yctldM2wKjHk9ZHB7QYwe4IYPkrij/J/u?=
 =?us-ascii?Q?ZrPnOb2Ut8T6cLGEGoKeU+LSGB+ac51jEt/Dqt9YcBrmFxl4d3iHBfYR3dVh?=
 =?us-ascii?Q?gnr9OxyAEn+eK982uqhEcvfyJYSp0f96fbqm5p5puaZ8v8iIj+iVsxGI90F0?=
 =?us-ascii?Q?LNkxfIuLQAy6VTl+CPyJg3bdyleT2YyPaHUgFdQFq8tzW1p3eZyfP8efKWJA?=
 =?us-ascii?Q?Fy4oYS+tyniLNqmzN9/F/3oun5fy0ORzgDNTfWwr5q9m569Ktxl0vTYYYYG2?=
 =?us-ascii?Q?pNmxLiOKOd2doJHHtSCyaWduUOJerAR7W0sFujWoz5GqX9mOuMJf5vkmiRXy?=
 =?us-ascii?Q?R5oIiPZHvG7HIR4h9r9i/j21TYzI/XCTaw0k6rnLPZCZSLDljHIO+BzhJPIh?=
 =?us-ascii?Q?zACdoOHYRLmn2/Gv2mbdnqQD9TLU/4+nplOjFYw3jOZEsRcr8fjHw8Lqqv+0?=
 =?us-ascii?Q?Cw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6de6edc-ddba-4c82-99ff-08da63f8737a
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2888.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2022 11:19:56.7894
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e6WFakCJqtJYse3IllAJz42DibG6I5aMLQTtz+LHCrUJX53hCsYgQ1ELrEMIQ1quzGc/L+zj3QIBj8Vy1CcUEAd5Nn4HxXzu/2yk+cK+cRs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3494
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-07-12_08:2022-07-12,2022-07-12 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207120043
X-Proofpoint-ORIG-GUID: HC91BmZVTIwqh7wDJkUiB-SFWfGn6Zrl
X-Proofpoint-GUID: HC91BmZVTIwqh7wDJkUiB-SFWfGn6Zrl
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> CC Quentin as well
>
> On Mon, Jul 11, 2022 at 5:11 PM James Hilliard
> <james.hilliard1@gmail.com> wrote:
>>
>> On Mon, Jul 11, 2022 at 5:36 PM Yonghong Song <yhs@fb.com> wrote:
>> >
>> >
>> >
>> > On 7/6/22 10:28 AM, James Hilliard wrote:
>> > > The current bpf_helper_defs.h helpers are llvm specific and don't work
>> > > correctly with gcc.
>> > >
>> > > GCC appears to required kernel helper funcs to have the following
>> > > attribute set: __attribute__((kernel_helper(NUM)))
>> > >
>> > > Generate gcc compatible headers based on the format in bpf-helpers.h.
>> > >
>> > > This adds conditional blocks for GCC while leaving clang codepaths
>> > > unchanged, for example:
>> > >       #if __GNUC__ && !__clang__
>> > >       void *bpf_map_lookup_elem(void *map, const void *key)
>> > > __attribute__((kernel_helper(1)));
>> > >       #else
>> > >       static void *(*bpf_map_lookup_elem)(void *map, const void *key) = (void *) 1;
>> > >       #endif
>> >
>> > It does look like that gcc kernel_helper attribute is better than
>> > '(void *) 1' style. The original clang uses '(void *) 1' style is
>> > just for simplicity.
>>
>> Isn't the original style going to be needed for backwards compatibility with
>> older clang versions for a while?
>
> I'm curious, is there any added benefit to having this special
> kernel_helper attribute vs what we did in Clang for a long time?
> Did GCC do it just to be different and require workarounds like this
> or there was some technical benefit to this?

We did it that way so we could make trouble and piss you off.

Nah :)

We did it that way because technically speaking the clang construction
works relying on particular optimizations to happen to get correct
compiled programs, which is not guaranteed to happen and _may_ break in
the future.

In fact, if you compile a call to such a function prototype with clang
with -O0 the compiler will try to load the function's address in a
register and then emit an invalid BPF instruction:

  28:   8d 00 00 00 03 00 00 00         *unknown*

On the other hand the kernel_helper attribute is bullet-proof: will work
with any optimization level, with any version of the compiler, and in
our opinion it is also more readable, more tidy and more correct.

Note I'm not saying what you do in clang is not reasonable; it may be,
obviously it works well enough for you in practice.  Only that we have
good reasons for doing it differently in GCC.

> This duplication of definitions with #if for each one looks really
> awful, IMO. I'd rather have a macro invocation like below (or
> something along those lines) for each helper:
>
> BPF_HELPER_DEF(2, void *, bpf_map_update_elem, void *map, const void
> *key, const void *value, __u64 flags);
>
> And then define BPF_HELPER_DEF() once based on whether it's Clang or GCC.
>
>>
>> >
>> > Do you mind to help implement similar attribute in clang so we
>> > don't need "#if" here?
>>
>> That's well outside my area of expertise unfortunately.
>>
>> >
>> > >
>> > >       #if __GNUC__ && !__clang__
>> > >       long bpf_map_update_elem(void *map, const void *key, const void *value, __u64 flags) __attribute__((kernel_helper(2)));
>> > >       #else
>> > >       static long (*bpf_map_update_elem)(void *map, const void *key, const void *value, __u64 flags) = (void *) 2;
>> > >       #endif
>> > >
>> > > See:
>> > > https://github.com/gcc-mirror/gcc/blob/releases/gcc-12.1.0/gcc/config/bpf/bpf-helpers.h#L24-L27
>> > >
>> > > This fixes the following build error:
>> > > error: indirect call in function, which are not supported by eBPF
>> > >
>> > > Signed-off-by: James Hilliard <james.hilliard1@gmail.com>
>> > > ---
>> > > Changes v1 -> v2:
>> > >    - more details in commit log
>> > > ---
>> > >   scripts/bpf_doc.py | 43 ++++++++++++++++++++++++++-----------------
>> > >   1 file changed, 26 insertions(+), 17 deletions(-)
>> > >
>> > [...]
