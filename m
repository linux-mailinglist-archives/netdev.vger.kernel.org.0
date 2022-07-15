Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6902857596E
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 04:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241224AbiGOCEm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 22:04:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241214AbiGOCEk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 22:04:40 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 274CA74DD7;
        Thu, 14 Jul 2022 19:04:38 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 26ENcXpF017557;
        Thu, 14 Jul 2022 19:04:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=htmxBAHIZvLRUdmvHgGW1xZ6KfpLn1gPm59dzMCJdxk=;
 b=GiA4HR88aHp6WNopSKmnLkdCVcwYcDG0Q2rHLAk4IgAXf54+JaaD32lPlEVJ2VtM6n2C
 +TRi/08766GfMEjLay6DR2SHUqgkgb72gKrQx11ZFFbAsgp2WrYC0zdMKDCfVKzVTNxo
 IBCvrfK00hliRrupS0oPpvgNVCO1Nl2QMm8= 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by m0089730.ppops.net (PPS) with ESMTPS id 3hak154y42-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jul 2022 19:04:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KaJEqWF7EF1jNAxXWZP5wjcHlMoy/RDNkcla/cxOM2RSjyhe0OLM+5qQ0+kOE0betEMvSJlIW1NR5O+C4rANCBHWApLEwtIg+HRFXvPQJR6MneauhCZ/m2RuQIMeHBZC1jVlr+kGn+pheMUsMJAVFhPdKIpOKOXtj2RLkbI+lsgtSHQSDaQQGpNi5xF3hSJ0neVFaJxngkfVCQIErpQO/pbnYG9T8mJYzS5XVj8sGe+4NhKeC+xafb2KqpdfmtCjdYfGji7OJFrRrKY9Cz1Q4qfb5zUydYWIymjeIC2vH1xKxCEGeBR5ssu/9hG5mcY0JxoMtsFVJ+mHhAXGrxgCIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=htmxBAHIZvLRUdmvHgGW1xZ6KfpLn1gPm59dzMCJdxk=;
 b=RUehgxh6ynLL4JKyFgP62RfYSkzfSq0fj1nNMftfG2Ra5nb4pp5N6eIfKPJF06TQoc6k7DoM1dhCspt93hqe4DhXIOLpDqQ6LuvjqA5zRGUn1lw6vNG7NJ7VFB9A9qLLI4REsosbPXyGTiUQgh84ypPnBeLFibv5zO8Pgo68b2bKJh8Mh6dqJCOR8k5gApMVdgJlO4mEtIT5Sj7czzuYhl29D+iRCih4UiB+YDrmoQeQkFyhYpc5ZBCGtRrNFIzJFZUiE/qRT9MrfBOSg6dZiJjgJWD3JHhvJ9AcS1z9AoX0e5kC4+ivEeXNO8FhDz693mqFjyX3tkQlIX4bfVygrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SJ0PR15MB5177.namprd15.prod.outlook.com (2603:10b6:a03:423::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.26; Fri, 15 Jul
 2022 02:04:34 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::5de3:3999:66df:42d1]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::5de3:3999:66df:42d1%4]) with mapi id 15.20.5438.014; Fri, 15 Jul 2022
 02:04:34 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     Song Liu <song@kernel.org>, Networking <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "jolsa@kernel.org" <jolsa@kernel.org>,
        "mhiramat@kernel.org" <mhiramat@kernel.org>
Subject: Re: [PATCH v2 bpf-next 3/5] ftrace: introduce
 FTRACE_OPS_FL_SHARE_IPMODIFY
Thread-Topic: [PATCH v2 bpf-next 3/5] ftrace: introduce
 FTRACE_OPS_FL_SHARE_IPMODIFY
Thread-Index: AQHYdrjyXTiiEgEgK0K1BTZfHuJgSq19RUuAgAGMyICAAAmfgIAAFU+A
Date:   Fri, 15 Jul 2022 02:04:33 +0000
Message-ID: <6A7EF1C7-471B-4652-99C1-87C72C223C59@fb.com>
References: <20220602193706.2607681-1-song@kernel.org>
 <20220602193706.2607681-4-song@kernel.org>
 <20220713203343.4997eb71@rorschach.local.home>
 <AA1D9833-DF67-4AFD-815C-DD89AB57B3A2@fb.com>
 <20220714204817.2889e280@rorschach.local.home>
In-Reply-To: <20220714204817.2889e280@rorschach.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.100.31)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ad8e4c64-b67e-4b8c-b16c-08da66065cde
x-ms-traffictypediagnostic: SJ0PR15MB5177:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qUr5xMCojjA2Du82t4YLT0JqVKpM5vgecXH78Ew5PeyNztMFYOxFwIU1cShdd/vAxn9s9oh5ar9iqAbuMuzCwzawk5qA23ZGI806tJoOzZHfkf4wtgj8IUtmlU9Y0rBHqCtNZKEUssld/j8cgvwo1SbV04y1CCtnaNQD0/HKqiZ87aXxK5RaEKS6GfT/wG7BDTOK06EkFXIsQ1jooWZZW2QAFmPy0dKrhIltVDoy0KrX1A+F4ssOJ6F/wvjGMIZHEn15yGfBwamFqljekUkNrAkeT2FD89HJAb1+7dd2lIdxEm8jcRgh79OjLQXY+Q+CTnr/a1R0f4yHA56EAbND/XgusQBpE75QOmNRuTsKLSS1b5JfkZqprKn7HCIYkZsmfMA97G8atiY4/G6RQm8D6Ty6vMCba0Nb506AuE5/WOr/fq5U59QK7KCaIeJOhYHk1EhP+44EIs/R1BYjnQuXfTZk8jE/K5n0HlWYxtGvN0saHcvFuuWh3jEqJAbpzBmEU6VVSzZcI8/axN7wSJE/pg9X00sTwoEop2Jk1ZsqDVEyTg3mXq0eaLpsdT7JEXcOdGYG7T9qyIQGaYL/It6Z/ra3edxuJRVTeWadmiyvxCuItTM1XIrg5M53TonwjR+quq5rIPqZFkTZSb7pTxCuOAAcZMzlFbqkURlqLRmq73jFDWmsH40mjSPkuUkSvH4MMgEEpA6EfeNmYRPRhZPdGQCsQ5807dkWKtH3xqsix14roASHG3wra5qMlNXx7LDwTc+pwy0OO+z8+M5jCK//c8GAm4dZbtIa1TgovjZg6vLcpr2/sXn8UL1PCdQSVJY1Ewf4r9nI84QOhDyPqKoJ1+OudfDIBmCxpKtF6FHsRH4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(376002)(39860400002)(346002)(396003)(7416002)(76116006)(478600001)(36756003)(8936002)(5660300002)(33656002)(6916009)(6486002)(316002)(38070700005)(122000001)(86362001)(54906003)(66946007)(66556008)(66446008)(91956017)(4326008)(66476007)(64756008)(71200400001)(8676002)(2906002)(83380400001)(186003)(6512007)(2616005)(41300700001)(6506007)(38100700002)(53546011)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?icI3aZT8W2z3pGie8FA9KA3Ys8pnFsGziva1o515rpQE6SocL+PsTJGYyI4l?=
 =?us-ascii?Q?MmawdimQaFY/Y/V0uQ2cVzr7vzZZP6vgpDbY1W6J6gWIZZtLfU7MZy6TCBxm?=
 =?us-ascii?Q?No+nK/XxIN/67oZLzUPnBqEJ1+ulg1r5YR2Yp3pmvozcm35lEf2WZMYKufIB?=
 =?us-ascii?Q?t3HKQlEJV9RGOiCt7XkRg+FknoGSi/bl5W85SeLQaLlUfbLNBm8hz8kns9Cn?=
 =?us-ascii?Q?GxEkyQw5sgCDsf5PYuK6AriVSxouOZPIxlbbCb6X3QpExhTCva0YFqLmolD5?=
 =?us-ascii?Q?Vby2TjBK4dyeGgq9/u1JzJSVVozDlJ80J0dJmPPpTIgFGYYIYocJygkFxGlR?=
 =?us-ascii?Q?FHapDddMfnOcrh2V5egXsLgl97hd11aXny7paNgcoNFE/OsYedH+PjBtRXIa?=
 =?us-ascii?Q?aBDohpuCYd8MK4++umuayG+vDY4tHhH9iBwsuIQYMpfit1uQGiwHg/Pe7dWP?=
 =?us-ascii?Q?9H+3VF1EOqCCh0xy7krBOT5+zJrWbVBlXFUik7rA1/RVdMBs7S5y6gbp4Pfb?=
 =?us-ascii?Q?m5mxWHQquN0ccbBLwOjfKjhggk0mEdFb1K9kJntcedYld2TN4wb2hdIrHb4o?=
 =?us-ascii?Q?YYKY6AhPx4XeYUsFHBOzsosS9/7BcWhjrfP603i8Y21C1InN8X8RLceBFN3D?=
 =?us-ascii?Q?xpQ/6qGGFUVs/7loylypG5W0AeE710G8mcdVALDNfa00Bw01m7/ZF+EeSCH4?=
 =?us-ascii?Q?uVgwtuYXcm4oifbf+rJpKYbA/Wl2jzORT/KGA+6i+kDMNBHhnnvkdSnu48qo?=
 =?us-ascii?Q?/REdDqwUALYZDvjacKO6BK0ybPvR4pMM1px7fT+eFfWdER2ULIkhSedpjCE/?=
 =?us-ascii?Q?KEAesi2DyqgzMFOmxW/VxMupFXxyaB7tnVX24wJUsq2fpz/ZH4jHCnZKp/lw?=
 =?us-ascii?Q?KQvR6tPIKKIbvTc2cve3nr7p/OFR4hRrsmgs+3ujexBixQk9bCBx1+QtAeQi?=
 =?us-ascii?Q?qIEFzbesc3XCqXhg9h+G7BFilEZx2eNyMsEgTc87SZAzw3AsloHTaupz8WNp?=
 =?us-ascii?Q?XGSGqvpL7m9gfYf+sjrmdpyfZZiHuMXAwtcu36KhF+Th7FoER4RHjUPRkvQ2?=
 =?us-ascii?Q?DNg7UNgQlPDQN3s6oxJHl093UqvLybLmPeu6Nq7YmVlhk56zhLSQtuq2xUF2?=
 =?us-ascii?Q?fCoFZs+SV/s5EmQdkmT/5vZsNkFSj9bg5tbkPXK/EHdO+cmbStkTT35c1Ftv?=
 =?us-ascii?Q?hYu+wXFKKdjTgnjRZdwrjiA9bx9PxUdrJZAdnXkZp3L59e+O+YU9NHVAFqzL?=
 =?us-ascii?Q?8P/jM0lrP5uk0BKYQhNTBnD0UgRRGhEL6zaXXjw37fAtovvviWDrRy9RRgZy?=
 =?us-ascii?Q?sVqOWXCvQGMXs408HTYsVW+TqaXTRs6ctwtIeXT5NkWkUFJngelyHqGIa1HO?=
 =?us-ascii?Q?2t3H7EcS9aqUQe9zSKukdTptgg2g4f/NMKyYeMRYRpPo+uNKg5IwPoc859FG?=
 =?us-ascii?Q?tuc7sVH+gHIBC5sIsb24UbCke2f5A1wUD80vU7j8dotHlW7mndc71Z5uoKBP?=
 =?us-ascii?Q?GvqNXucGL3yilaiaUFjPsDOblDgRrRItf9eLVk2USHkarOeolZ0IKFG1k1ES?=
 =?us-ascii?Q?vBlmDz/sqRqZY2cuE5804/OgH21WQxj2tbipb2CBZHXuNld9UYisLWWv+Sio?=
 =?us-ascii?Q?tmlOl7p83D1+msS8Hqnkeiw=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8E0E7B957A64714298BB4964FF5011F0@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad8e4c64-b67e-4b8c-b16c-08da66065cde
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2022 02:04:33.9656
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DzV1OmTPCke8ArA3HddPMQuVo3S9H5ksVvwWprVgZfY0MSxM9ayLjtiT1TKdDHtOylwu8hhHuEgLSVUNSz3lOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB5177
X-Proofpoint-ORIG-GUID: Umc1p4nltM5-TX7FQtfROvvJFNt2ecrs
X-Proofpoint-GUID: Umc1p4nltM5-TX7FQtfROvvJFNt2ecrs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-14_19,2022-07-14_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 14, 2022, at 5:48 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> On Fri, 15 Jul 2022 00:13:51 +0000
> Song Liu <songliubraving@fb.com> wrote:
> 
>> I think there is one more problem here. If we force all direct trampoline
>> set IPMODIFY, and remove the SHARE_IPMODIFY flag. It may cause confusion 
>> and/or extra work here (__ftrace_hash_update_ipmodify). 
> 
> I'm saying that the caller (BPF) does not need to set IPMODIFY. Just
> change the ftrace.c to treat IPMODIFY the same as direct. In fact, the
> two should be mutually exclusive (from a ftrace point of view). That
> is, if DIRECT is set, then IPMODIFY must not be.
> 
> Again, ftrace will take care of the accounting of if a rec has both
> IPMODIFY and DIRECT on it.
> 
>> 
>> Say __ftrace_hash_update_ipmodify() tries to attach an ops with IPMODIFY, 
>> and found the rec already has IPMODIFY. At this point, we have to iterate
>> all ftrace ops (do_for_each_ftrace_op) to confirm whether the IPMODIFY is 
>> from 
> 
> What I'm suggesting is that a DIRECT ops will never set IPMODIFY.

Aha, this the point I misunderstood. I thought DIRECT ops would always
set IPMODIFY (as it does now). 

> Like
> I mentioned before, ftrace doesn't care if the direct trampoline
> modifies IP or not. All ftrace will do is ask the owner of the direct
> ops if it is safe to have an IP modify attached to it or not. And at
> the same time will tell the direct ops owner that it is adding an
> IPMODIFY ops such that it can take the appropriate actions.
> 
> In other words, IPMODIFY on the rec means that it can not attach
> anything else with an IPMODIFY on it.
> 
> The direct ops should only set the DIRECT flag. If an IPMODIFY ops is
> being added, if it already has an IPMODIFY then it will fail right there.
> 
> If direct is set, then a loop for the direct ops will be done and the
> callback is made. If the direct ops is OK with the IPMODIFY then it
> will adjust itself to work with the IPMODIFY and the IPMODIFY will
> continue to be added (and then set the rec IPMODIFY flag).
> 
>> 
>> 1) a direct ops that can share IPMODIFY, or 
>> 2) a direct ops that cannot share IPMODIFY, or 
>> 3) another non-direct ops with IPMODIFY. 
>> 
>> For the 1), this attach works, while for 2) and 3), the attach doesn't work. 
>> 
>> OTOH, with current version (v2), we trust the direct ops to set or clear 
>> IPMODIFY. rec with IPMODIFY makes it clear that it cannot share with another
>> ops with IPMODIFY. Then we don't have to iterate over all ftrace ops here. 
> 
> The only time an iterate should be done is if rec->flags is DIRECT and !IPMODIFY.

Yeah, this makes sense. And this shouldn't be too expensive.

> 
>> 
>> Does this make sense? Did I miss some better solutions?
> 
> Did I fill in the holes? ;-)

You sure did. :)

Thanks,
Song

