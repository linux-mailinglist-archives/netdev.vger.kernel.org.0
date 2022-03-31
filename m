Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B53F4EE4F5
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 02:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238402AbiDAABt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 20:01:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbiDAABs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 20:01:48 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 049E855BCD;
        Thu, 31 Mar 2022 16:59:59 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22VNFtBD032076;
        Thu, 31 Mar 2022 16:59:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=sXmJH+EoECg6LSqf1d7p9kNRu1zFVkKvoOIuHzl/y08=;
 b=p7zDfj/TD9uvXUk9lXK7Rwbq1ul7PWp3T009r1A27VJWHw8mzNi6LElzuXiKCR7owEON
 tdAE6ebTLyTFBilvKO/+qyA4k8AgilChWNnKlEt6JFfryB/aEcnHHOoIUrZkTn7dBZPU
 BkIBNcHN+AwaPxtKF2MVVy9BZwQqOyxQZIk= 
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2041.outbound.protection.outlook.com [104.47.51.41])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3f5gpg2v06-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 31 Mar 2022 16:59:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n2N2BHrmjwZkoNcxjLsMCRPsVC9WjevNl59IHgPqI9WmCq/3SsimpyF47nzzI3LIy58HjiJwelSR/qr5UpqOHsoywjxVZk1j4s67KZVgkHjrA9b4Xfz//FGLyimVfJtzgYoZT3aNxVMFQNBeHYBrLuy6ssSF+0oj7pykeUefje9OZuLS59vZD7vqmT1XN7AzkFutQ2WNPX5K/aa1JRu2qhLggq/gS1AViQc+GjWxTlhqFHWaQWJnvAnvZRfeMvCV8gblSJkpM11hmq6xBq8/CMdkBdDSyPHVOZKgmyL4HgtMB7Desql+1SCMRIQ6qdjWuPCuIY980rIV1SY+7wCibw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sXmJH+EoECg6LSqf1d7p9kNRu1zFVkKvoOIuHzl/y08=;
 b=n/PZj66HiYX9u+tcsvNdVlOyRyFbXjivUp2otMf/X7C6aMDQTAdoT0EhHV67W2yY/DZCy4mXzaHYJs5R7Fjog8BlQuysKSBW1VrQkUs8ilvf7bdpQ/y1dHUWq9hKdUF8irGBq3vm6+6wzuqBZfHjCxHE8zQIQdLwRcpTGuSfRuhFAoNwaXDuqZbMW9HNOKvSWmNcDODm6ZHAakBJF27sSHPm2lwyKZzP3V81Lpsv8nixc8mCzexWsMK2miRtoK4TFz27QpmbjYpGo2IbLAeByUsJNAl3u4zARNZQ4SQ05KCh19tsMkz3Ai+GvsJELr3AE7zyzGOlxSrdLLNslBsibA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SJ0PR15MB5129.namprd15.prod.outlook.com (2603:10b6:a03:421::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.18; Thu, 31 Mar
 2022 23:59:56 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::58c9:859d:dc03:3bb4]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::58c9:859d:dc03:3bb4%3]) with mapi id 15.20.5123.021; Thu, 31 Mar 2022
 23:59:56 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Christoph Hellwig <hch@infradead.org>
CC:     Song Liu <song@kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "pmenzel@molgen.mpg.de" <pmenzel@molgen.mpg.de>,
        "rick.p.edgecombe@intel.com" <rick.p.edgecombe@intel.com>
Subject: Re: [PATCH bpf 0/4] introduce HAVE_ARCH_HUGE_VMALLOC_FLAG for
 bpf_prog_pack
Thread-Topic: [PATCH bpf 0/4] introduce HAVE_ARCH_HUGE_VMALLOC_FLAG for
 bpf_prog_pack
Thread-Index: AQHYRIo6ffSmNDMip0KdC6K8yX1qc6zY+Z8AgAE0IQA=
Date:   Thu, 31 Mar 2022 23:59:56 +0000
Message-ID: <F3447905-8D42-46C0-B324-988A0E4E52E7@fb.com>
References: <20220330225642.1163897-1-song@kernel.org>
 <YkU+ADIeWACbgFNA@infradead.org>
In-Reply-To: <YkU+ADIeWACbgFNA@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.60.0.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a1602e79-5090-4387-8467-08da13728e95
x-ms-traffictypediagnostic: SJ0PR15MB5129:EE_
x-microsoft-antispam-prvs: <SJ0PR15MB5129434968B5856801C3F233B3E19@SJ0PR15MB5129.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iBuMkuCVpNA7F9GrT/yfwOLP5gSJ6MJ9n6LXBNbO0wwFVCfxitdayScGa8E8ylf7dCP3B9v5Qs+6bBy3ZsCCa2iepF+xCyTLBJOekLdOWfyi1t0u0yMkW3qAKQ8dDv8D0bedA2b/5Zb8HflcjSuJNL3iUtkMH6mU9xRC56SZzSc0cKqt4cjmZycPhthBRGxCJBMLnJC5p7oePXzcgbd+3yju45/F42OHA6glWGLDXjJMMzDp2tuSiD5iqCa2NzBHt7q8Q1SFEVMBzsSYZ9UJzsQQ2+nbxY2hOzBFtBWjQ1c8QmkLormkDu41PZnahCtq79Y6OOw51mk7IYcayZjiYT8kS5albf6xCCufIdNAozHbmOocSmI3sSGW7AzKWxS4+xzvg7YqCpKeeULeWQbx26fAyUGi7b53RGEi7GcpSnBC6Xk1pUqI/gg8Wvsj/SvzuKZ+OY2jrE/HBWBDlO0Z63Ojh9FtnUcG7zpNbYin4ZFz6+l/gFwYPsSM/2cTaIBzVyOHztjD/5kkVsvADlXO14xagw+IBUHsYn6kUrHp6MRebIAsGNDNiScV+fu/FOf7iS+lSD8Taom1CO9KtPRBg/jpPA2xlDpp8DIbuFkXmr451UDnfWfYWi0ixolev7b7NDI6s4nDgNSG77GyM8t7Su+Lpooiog93+HXsKHZrIaoRUmf5303uBjWu0W87kj2n1VOWhVg+VGr6WCMJ3C0vwPJYupcn3X5jNdYkG7bYD4Rey/fFVBK8Kb/GfM+v9e/x94VW/UeZ4gt4wjqlWCvDOg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(91956017)(7416002)(64756008)(8676002)(66556008)(66476007)(6486002)(76116006)(66446008)(86362001)(33656002)(5660300002)(66946007)(2906002)(8936002)(4326008)(36756003)(6916009)(316002)(38100700002)(53546011)(38070700005)(54906003)(186003)(122000001)(71200400001)(2616005)(6512007)(6506007)(508600001)(83380400001)(14583001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jYbst3F5VKuyJRTby3Ey7QWPtIkaP13I4Cixc4SSn4DvlZEhQXo7VrMWlVSV?=
 =?us-ascii?Q?ApOx/2kNKiojXpt0dvazf/6fXUDUJ7gMZb9bEdx97MPvqstbOZbxoUhJLLOI?=
 =?us-ascii?Q?hjV2s5SFx/qJM3lBVYfZVWc6F4I0x6YQ/m/4tACtMTG8QEQZKO2vArAIdE5+?=
 =?us-ascii?Q?MaY/DPNovSY9rRMrzNDkTvSKVH957hOdxful+/Z/6MBRo3Y2LsLzUIRuUAPt?=
 =?us-ascii?Q?npNNa777CNuXz1lfpJCOa6WcQb2dwL80/Bpkc95jHtS4MjcbtZsE+eue1iDa?=
 =?us-ascii?Q?e75O1SZ1c1eutzAZuQ9s9yj2tCXQA8cquDGJid5yPajikXYJEYDH6leKBySE?=
 =?us-ascii?Q?a5B2JLeBxRxbf4me72w8Q2AlqY44VZF+/BFwZxvHJiHGnJE9TEx7uk/h9dq8?=
 =?us-ascii?Q?Ljj+8jhMb77KkNQXswv+3fPOzdrNBPkJK2HRzLnFCaT1MNlLRuKEW+geqFqu?=
 =?us-ascii?Q?hrqvewaKPLUudvnk/Qc43KCkdhd1xTXALL8jRAFejIgumrgLJgdKuV1OtbjL?=
 =?us-ascii?Q?ZWrmuLC40JX743BRW9gyPGOloM/L5J3ywoZJbO3yf4kRKQh0t4dhOVKBN9k4?=
 =?us-ascii?Q?DHuN1Y9z80HSYkk04nq6u9vx6Ja6yQ9NM+UAy2fHuEOhpLKAkLagQt0qDwDh?=
 =?us-ascii?Q?zDB2NMhXaVWtsCRlozXBdj3RH96UWKcqKT21uaDy7Sm71Vu5C5gB8i9YsL31?=
 =?us-ascii?Q?Z1/P/3ua9xFT1Indl8VHFFKoYHvitJCWaQ6ahHj8aZTpQ4nx5XPgENeqQFqK?=
 =?us-ascii?Q?GENgdl6yem4KD0gALw09jxm+Yt5MBb/FbZrVx9a1II1BjuKvAjZiu7ZhUjNM?=
 =?us-ascii?Q?gtXZ+P0d1bkYXCcG8vDefIAxbtaaxq9AVLJSGZ3/ZPLPwCy/bxIVJDjho4kT?=
 =?us-ascii?Q?R4wFIELIoQ3Ki6MRkvqoCPdSx1U9tp0zz2KGuNGlB/8uwhpfyMDSwfJZaaxA?=
 =?us-ascii?Q?WSP8Dhoc8mhiWfhRcCT5H+VE54zRojhtDf7VbswRt86v22M4l86Ht2h9okXN?=
 =?us-ascii?Q?wi5Wea8uV1p/O0aBk0DQVNOJ2vxJy5i3C1U4fIoHPSPVhddlXCuKtMt3QbHW?=
 =?us-ascii?Q?QT27B+SWlYZIOnrxI9TpGygN0Hytw2T9sYxHY1J+9TzeGJIoxxtBP1JNcj0p?=
 =?us-ascii?Q?QHa5SOKFOktvUNMDQ5Ok7hp7jXM7sWykzWTLNt4wHnwy4xUhxV+au8NJDxno?=
 =?us-ascii?Q?LpmJXZWJIK+P2UNw+iwSjlnd4YI9Z0hd9IqTZb6ftwiLI+LBszIu8EAtWErG?=
 =?us-ascii?Q?uKfAdP5ULTHomgiVF21652ryyfqbli+D1qhvN6t2cjbBrtwta9JyjzZxFM7Q?=
 =?us-ascii?Q?fQbS8X2K5FCCTbRV5snNBu+2wKmk3avv/Ogj33VyQfNyGdLM9TpLhuNpMNtR?=
 =?us-ascii?Q?krjksiG1cF85re77qsVrO2mnKs88zrjiJdr2gvZIFToJID6jCuQD8mQ+I1O0?=
 =?us-ascii?Q?ArP71UM8oi5jElbDAFogWMvOkmSJmLfFaWYz+W+behcgUrzHEhEWhKPPnoZZ?=
 =?us-ascii?Q?gKAzIYeJs2rU0JsQtoeT5ugEpwp8e90xD629B6QpUFvyvYmkZPZ9dVGU8gxV?=
 =?us-ascii?Q?IJU6Y4uvKwK8H7KoYV0WZ3mA3e6H1bD4XrPmkZetO0cQ/8hscGDYPO75WXq2?=
 =?us-ascii?Q?zNGmiYWlRqFHzyP4VW8Y3zs8J74D1ThAByVzFRRLHQInzGkJvcxR2gjak5fX?=
 =?us-ascii?Q?WNqyc7VGsl8GVbeXXROahS+9tg9S/uv0Tv5qLBFL14BwwlXQx7LVeMsx1/Vh?=
 =?us-ascii?Q?GmbtWnwjUNOvyhlMSbOXBd6XsrbefJ5H++K8/zda9k79WFvz2K3K?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D6DC686C4102424BBC25A90F8BF7C258@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1602e79-5090-4387-8467-08da13728e95
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2022 23:59:56.4772
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cw4z1wYsPkiW3Rl0HtASGQAIHAy2p9obZkeWxQh7cK0LL3pzI1kCOd2G1MnQdcCVI4uzVjvAzOlrTvYE86wTrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB5129
X-Proofpoint-ORIG-GUID: Ih9xMOQOCq6u8Lw2TQwATKDW4X6Y9yTv
X-Proofpoint-GUID: Ih9xMOQOCq6u8Lw2TQwATKDW4X6Y9yTv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-31_06,2022-03-31_01,2022-02-23_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Christoph, 

> On Mar 30, 2022, at 10:37 PM, Christoph Hellwig <hch@infradead.org> wrote:
> 
> On Wed, Mar 30, 2022 at 03:56:38PM -0700, Song Liu wrote:
>> We prematurely enabled HAVE_ARCH_HUGE_VMALLOC for x86_64, which could cause
>> issues [1], [2].
>> 
> 
> Please fix the underlying issues instead of papering over them and
> creating a huge maintainance burden for others.

I agree that this set is papering over the issue. And I would like 
your recommendations here. 

The biggest problem to me is that we (or at least myself) don't know 
all the issues HAVE_ARCH_HUGE_VMALLOC will trigger on x86_64. Right 
now we have a bug report from Paul, and the warning from Rick, but
I am afraid there might be some other issues. 

How about we approach it like this:

Since it is still early in the release cycle (pre rc1), we can keep 
HAVE_ARCH_HUGE_VMALLOC on for x86_64 for now and try to fix all the 
reported issues and warnings. If things don't go very well, we can
turn HAVE_ARCH_HUGE_VMALLOC off after rc4 or rc5. 

Does this make sense?

Thanks,
Song


