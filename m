Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EBCD5374A8
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 09:23:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232607AbiE3Fhy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 01:37:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230251AbiE3Fhx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 01:37:53 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B9594EDC5;
        Sun, 29 May 2022 22:37:52 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24U4UuxW016744;
        Sun, 29 May 2022 22:37:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=4vWWmqhmGNeuNkdyyzSw1b42Nqa32f3lwkCZRyAhE4Q=;
 b=VZo2L4LUDB1Q3KlVjfgiAh3AtHErq060IhmrRIKDOr8fMHL237ai7IJyk7l1u4hQ3nH1
 DLfcUKBIj+FYzRHCNnqzq6gJEHh78GTJoxlQDQFR7eIW3Xp/usHSCCFZPKGJNrGz89EQ
 JMsMcpqVt5dtnAlfTMhQxCdkhbNXExjLJXg= 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gbf2jeyd4-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 29 May 2022 22:37:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O3uEpMr5Vsl8wZ8FpzQAfxdgIJZkHWno23Mq5kw/JSKAZp008NlMm0gWjqIBQcWvPDqyYJU+fTUW9EXErmlsHZ8PKEaejN3WkcCYx6HVgNJZfZVEjzv5BhPiOaY0PKqwYKjp6EOkq+Rk1zUPYst5+nLBXs9AgNaCyrSMytIv9EgEdHxdzBrftuQnH+BV6oqDJNvHMI9K4e+Q0NNxRfIqOTMXSYS4IePvhq2VjdvxJaDbrP33VbO/yDEylLwTHMoJW+6V4y3xmRm3qPtQUJdn0i1OyuyuMYvc8JHd4vib2/KoYF1uMgiAGocA1iV1/VInxFdaDPcU/O5yJhUGjjM9Rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4vWWmqhmGNeuNkdyyzSw1b42Nqa32f3lwkCZRyAhE4Q=;
 b=cRNND5J7Ee9D89t9lY53KAxTRHGJTIynGXlmoLOJV98KzDanFrwB6dJZC0F+cb8Bdoa6my/JJ+jOhntC8p+ZS9O98ti0y3qf7KwyZzYVYhoROS2OQ08z6DvELX0wwEEEARo3bkusvuNoMzVcRJ0CA+/njRKNhbMSdph9EyOBYMp47EWNmCltFboWL5/mAtRfX7H6MaOyYszlqn15cEOM/XnfRrQThdXktBifFA8F1FTf6qoItoRaYmoc9esSsSyBoOXwk99VSQEpCl85pXZXIhm/sVXjzqD4m4K5K+1AJf7g7p9ipAPCejrJ3mZnAHvvb0fChTI4kauHZFhaXi2z9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA0PR15MB3838.namprd15.prod.outlook.com (2603:10b6:806:88::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.19; Mon, 30 May
 2022 05:37:49 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::3061:40ff:2ad:33aa]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::3061:40ff:2ad:33aa%5]) with mapi id 15.20.5293.019; Mon, 30 May 2022
 05:37:49 +0000
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
Subject: Re: [PATCH bpf-next 2/3] ftrace: Keep address offset in
 ftrace_lookup_symbols
Thread-Topic: [PATCH bpf-next 2/3] ftrace: Keep address offset in
 ftrace_lookup_symbols
Thread-Index: AQHYcgxI2R8NwDKUw0+tEL5R/mSzmq026rOA
Date:   Mon, 30 May 2022 05:37:49 +0000
Message-ID: <6D832064-C22F-46F6-8663-A516E1D02C63@fb.com>
References: <20220527205611.655282-1-jolsa@kernel.org>
 <20220527205611.655282-3-jolsa@kernel.org>
In-Reply-To: <20220527205611.655282-3-jolsa@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.80.82.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a3801bcc-099a-4540-bbb0-08da41fe88a3
x-ms-traffictypediagnostic: SA0PR15MB3838:EE_
x-microsoft-antispam-prvs: <SA0PR15MB38385BB8862F27FC09496F93B3DD9@SA0PR15MB3838.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gUSwfsBkHL9EpMz50ySauPcO5iIYOE8U1pe1XuxpGO63Dnq1gILLGM1OLM2WOxBzw2ZdQfgPxaT11Dq8LPuWTVNMjSoAHAClgVPlzuJOAFzIZZUr0Tgyg5Dp0Ymj/vmcR9XjV3XeHPp7EcahTS41bjJhY+WM7nPGWR1/f0wUtxKEgTATMsIvNLDCy7uptBMG1eocoWfcO7aw9mnwiNRFM3lO98RcauPQ6jfD7wv9c23vMT5F8fh5hLgeLBKUl+J1/xJxAY9I+CEkZ2yZ4LqY2I4Zpnw00C4fm8zH8wAfs1g27mHvUcdnrIKrdtjHhiINkF87ZBzjsE3ZAZUT8ciFypcU978Yk09q2tn9dj7K5fu/InSY24iDd5q4R6aeELLAePPfzFeIdTkPCxwR5Q2Qgm/Z8d9BXVRcVU0X+fx6EKCZYmB2Fp/zVrJkY3oFyV29roCD4KIQnqn40V6cV9uwCQ8aOowSoo5Mfu6T2KG0Rs5o/RD1nNCvQQkydS8N73ix4CCKCbYZZ1+seIDDoSoZFuVV2TEuw0FhCq78quJR0Gq0lN6+ismBkOmRME+7ji9U+ZAGq52FYoG/4ySgSwzaxNQoGmbe3pw03Am0wDjbqfCPO+JctmML5YDpAReS9Lk90x61isqL+g4zZnWZIFLGN/xQEXEZRM5zQZ308X1J4h4NX67UbDr9FQcsiM16UqneB9yEOA+A2qFMr7Wq3C5pbq+p9vpQpKRI8YSsCruXxttf0qzGadTXC421oIz88v8h
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(71200400001)(4744005)(6916009)(53546011)(38070700005)(5660300002)(7416002)(33656002)(54906003)(38100700002)(316002)(122000001)(6486002)(76116006)(4326008)(66476007)(66946007)(91956017)(66556008)(64756008)(66446008)(2906002)(6512007)(2616005)(8936002)(86362001)(36756003)(8676002)(508600001)(6506007)(186003)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?z92+WkmM+ewNLMU121tctacWbqO8LncBy02AgeaVhS/YbR/4WcoKTNqxRnFf?=
 =?us-ascii?Q?W4sawVg3TSlU5toeTFIXeV5YpPyyNj+P/iw2X3C0ORGnj5WSTdpgNlG1DMEp?=
 =?us-ascii?Q?I7QZuc0E4zwH270dJTef/ueukQ5jkQ3LPqj2PsfQMnx4H+27kGBdvFOBsjfY?=
 =?us-ascii?Q?BlJMnZoUOj4jDTpYBys4r5lD3U7KnfcyHz31IBphz5GVloBicCWV5Ya3S3RE?=
 =?us-ascii?Q?11QB7o/Mw2pC3pa/vvjr/Yb9/U2KeRehxUi/yaFs0NDJsGifEnjBJWuRVCTK?=
 =?us-ascii?Q?gCFjlbU38z/RYdT+3wZES/0v8YgBMbjIQhaph7Y3wVmo7cyKN1adCZKSze/T?=
 =?us-ascii?Q?gil+xsmfUa64TkuZ7n/B1uvG60LaArcgT523+/F2Km9VstQ2qqwaCcHXOR/H?=
 =?us-ascii?Q?XHXikp6n7gtiOGU7pDmPo87Yns/mjVOECyzjUYQXtmFUjD9ZhfiHagh75uBK?=
 =?us-ascii?Q?3q8p/FTRscO+JUkwYtlXNlfdSOzWwKcYswnZz7toCRm2M4fjcmcrDRYTJQE8?=
 =?us-ascii?Q?9ud4hCgHqPjW1y6z1P3ZRy+1uzzwK/LH3Jhisb9oAjn3vpBPVIqiR6Q4genB?=
 =?us-ascii?Q?ppFp5F3n9FP6YqW04jNhskyZpnHC4XrKsAUWUrpY9A8BngU1k0w/eEvCKCUT?=
 =?us-ascii?Q?QG2BQ2+eoSpS4dkEd/TCWFyKynfR0QXEQqfTiJ0njCZXdm0QXaQbXVToYrvM?=
 =?us-ascii?Q?5ZlWtK6lhC9SsNAMdX6H1dmZRZCE1dzvjwBQSijmFIhBARf8Wnd8dmSnrqUE?=
 =?us-ascii?Q?GS7IS5O61V5MQXgflQlHgO5dPu89Yc04o/uHQE/ivsGAsUGhZgDgoJIdn/51?=
 =?us-ascii?Q?hpEx8T5Odpuuzg5HsK55a6+gt2+Meu8yygjddhH+AwKM8vU4rioPDTEMiDC6?=
 =?us-ascii?Q?m9ucmfJi4guQ2S+qVk5jCR3iu0CW7KHtPfsGERz4JLzykgNSW0trvwQuyDSE?=
 =?us-ascii?Q?HxUkfF0Uky/fFwgiRAPfmXHffmt4I3eEPS59fHYrnb0a7mJOuqjzF3tBEB3d?=
 =?us-ascii?Q?RJOZEMbfn0cTkNA29IoVsMMaE9xW7KuiV0j6+ZeIjd2064M8Sm/59y2CsUsj?=
 =?us-ascii?Q?212ICYJZRfJVXfSditw44TIQZW1BQNEiJ47PT8KdKL/wGwlRw/PrMvoCfJ/R?=
 =?us-ascii?Q?b0tcoxvrEFbdPUYyWS55lhT1HPCwoTetj9EhfKWbm9eTM4VDnxZHCqYGTD6Y?=
 =?us-ascii?Q?UqpZfMpvRTEG6AxUQNVlaTL4zCzAd/3UJenffnQJyUHlLpjeF3hNYG7NP8HN?=
 =?us-ascii?Q?a3e9eYtYOb7ofYAGpn2NvbYPanaHXheIZA1GuJ8KwLglmS8S3tWgX9ohMbRQ?=
 =?us-ascii?Q?2L6eNDWWY82b0U3GefvTdjdTnibMlRd+7lkwEHkoHPG8it/1TEHJiexqzTz8?=
 =?us-ascii?Q?37ANKvrNNdxaSjMYzxkoz4+5o3KLqoHTKxrkRZtfIUPirS0+jXNuNNIPg9er?=
 =?us-ascii?Q?mIxIJbyT+gZ1sRJekyiwseZkvy8tMbk33hfaOmhczQCJ3B9G9X8KgLi8O753?=
 =?us-ascii?Q?S5ujRRvacFjxhJl0OaqOWoCDr0tuViKuC1Pqa5MQdvhUDcsUisSgexCTGaoh?=
 =?us-ascii?Q?3ahML+QI1pFJk2Jrrsx5ePCmARAaXlFQmm+eQTz7nhQum2CgLBpMHrccq/I5?=
 =?us-ascii?Q?Ck6col5WalU6XLxcrQyKU/7uu6opHfVnn/2wVKqVuaKo0Y3PmiFDLWX5ddxD?=
 =?us-ascii?Q?uR5DBH3mihkTBNN/Jm8LL8uPR5zjUgPVZDjXC/EAj8eu+h4OMDGaJSnaqFay?=
 =?us-ascii?Q?bWiVBX9CoRfgQd5uP0XsvasexgD5juxnu3/VJhyzfGRGgUMjfOVB?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <ECE5CDABE4152543A744007EAB7E85BF@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3801bcc-099a-4540-bbb0-08da41fe88a3
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 May 2022 05:37:49.6120
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TLJlGtNg8oDPcJtd/4JCPVpPsz0lQXcJWjlS/FTbsf8K0wwNKIrujoDWGZHs+E2JzUd5JGLfhbau7OnmCuP9lw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB3838
X-Proofpoint-ORIG-GUID: _fqyGPVSthE_U47oTioERQqkFPuEWOTa
X-Proofpoint-GUID: _fqyGPVSthE_U47oTioERQqkFPuEWOTa
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
> We want to store the resolved address on the same index as
> the symbol string, because that's the user (bpf kprobe link)
> code assumption.
> 
> Also making sure we don't store duplicates that might be
> present in kallsyms.
> 
> Fixes: bed0d9a50dac ("ftrace: Add ftrace_lookup_symbols function")
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>

Acked-by: Song Liu <songliubraving@fb.com>

BTW, I guess this set should apply to bpf tree? 

