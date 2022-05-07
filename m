Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D752F51E4D8
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 08:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445998AbiEGGyU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 May 2022 02:54:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1445960AbiEGGyP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 May 2022 02:54:15 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5657D98;
        Fri,  6 May 2022 23:50:21 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2476OKLU006148;
        Fri, 6 May 2022 23:50:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=W9I1oNxHheJMPaIiMsyHvgW1DZE1KV1MN8sRBYnulpE=;
 b=Yg75zthi2x6rfMyC8odouYzKMLNze3xM1iw/mbUdjzQh4EX7pASX31RC4jN2eDNgs36l
 7ANL4E+H+6dh2ARZEajbg7rRXhko2UsSsRX7HDuULVLRpAZlCcj+wrWJ7M+ydWg07JsD
 o+7OzCBobru1Z/9v55dbfopup4jKeixexlM= 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fvs4tfm5x-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 May 2022 23:50:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dmPkw3fgaO7D5JIwNoR9gOYl0rWv/u8vTxGRS/P+C+Kk7ZvSM63Qqohagv2P8qk5uXKZtAtPD8yoEb7X/CdydWM1U65JcuohG2ghDs39FFPfPPBhigNFdt45BtAF3X/AGoQuQMCH9/OtlXjvmAxKL7+e6tQ0EgsuvPkifVsTKXSTRIHPskHl6I7mWX6mZeBeMCvBZz66dcuq7py38XW12R6SHiT5ixv1LNl4+vgdXPLlW9epuEpS5I+pXRAVp/5u5BGgplg91q+NkqcJWFGooEfyp8Qeb83roc7BWPnIXnfwO2BSos5CwA5zXJ3awdQos5Bdv2ljpP2dCOPA5LUukg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W9I1oNxHheJMPaIiMsyHvgW1DZE1KV1MN8sRBYnulpE=;
 b=ogOKrZl5FBjBwBFFaFCR/MThYrcqSBu9udZT1okGJIq+qsQMl8c40ePtxRM8/GiGJ9a1tVwESIq9CvFBQAh+cwTOEEPNbjxQEZDx5lbsVBAof1Va0f7vZaHjlfshKC2nTTqMSoOPpXZrUzcKUfYs9/7+0aUTIs2RfgP20+vNZ092hh559Yi1x2LtLqLiGoic2cKTvHGJ2jzx7Ztuq5CiRI/iOsbv01jB9kYcF0iCcHJr1K92TY19WGANgSDLh6RKyVPNLGEPSrk9zr6aW6Z4jxKFDFnshQmjhDANQh7ee84oJmUW1BQJgNqhIKkcc830ewh+69+BshT1gnCLVOF+yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by MW3PR15MB3899.namprd15.prod.outlook.com (2603:10b6:303:45::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.27; Sat, 7 May
 2022 06:50:17 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::4133:c564:79a7:74d5]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::4133:c564:79a7:74d5%6]) with mapi id 15.20.5206.025; Sat, 7 May 2022
 06:50:17 +0000
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
Thread-Index: AQHYWOUphDgBQzjiX0ac6c+Sg/0OBq0EVWkAgAA8D4CAAFTGAIAOJWIA
Date:   Sat, 7 May 2022 06:50:17 +0000
Message-ID: <719D99A4-3100-49EC-A7D6-6F9CDBA053C4@fb.com>
References: <20220425203947.3311308-1-song@kernel.org>
 <FF2E0EC1-F9D6-4196-8887-919207BDC599@fb.com>
 <CAHk-=wgA1Uku=ejwknv11ssNhz2pswhD=mJFBPEMQtCspz0YEQ@mail.gmail.com>
 <57DBEBDB-71AF-4A85-AB8D-8274541E0F3C@fb.com>
In-Reply-To: <57DBEBDB-71AF-4A85-AB8D-8274541E0F3C@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.80.82.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 48dfa491-a105-45b4-b8c9-08da2ff5d8c3
x-ms-traffictypediagnostic: MW3PR15MB3899:EE_
x-microsoft-antispam-prvs: <MW3PR15MB3899599BAA64A388D72DFAC0B3C49@MW3PR15MB3899.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kir110uV3j8vylHKn2Qu+M7PrHkJgqyrQnGp3DHiFiIIeXMR0zEozjjk9x28Cn+VnzaDG5HkaPgvygPB8Xc4+l93p7zFZvOrP2nRzqxCH/xRWkoHw6p4wVPAFF8Jl0HlVQEAsSLM53w27/k3r0oV9tB35e0RLYX6xI7HAKcL/VC+ZW9f7XTgZjh0eNNVfBTT+tnLy97/SaJ8GwJS51Gh3iro1Uf3XPvh7hWdhYEMs8/Ec/U5MSaYwMenpDI+M+eG1ygZ6YDAxkFt3uVAfc3X90Y4b/Gq44qHdS81inxcdRbdOTS02a9bS7d3yaF0bXpoHi/fvYbVXtyN2XVX6fyWKz+uQa9jgxKPnMm+f+sbctRqeogpQ6AsalMhVF7qbcKewUBZy6WpPxgsXRuJdgmiHFCdPnQ+txBrOJ2p6rNvBOTfU7HT+HzkVx1USilmRkY35d9W9uPqVD9zC/Pg7O9KzZeWz2ue5vyNYUYsPfqZkf4HgZVzDWYT4t1DEeX2QeLZvWX3WS7B6R7VjJByyZUlxklCrincXrbksv9zNWGKJfZacmaVRnqUJ2ns7uJeqtEPDiGio/T7Mkgfbvkw13W0KM/oULIyeXarltR+Rc7gs3oz4ZjNE59FgoXx2Uk5ld9Hq862cC0OC1zpROLx8va7C0XMP9pmqZCQW1L14ZUq5I03H8JF/NaU/cVMTrquh35JShYfRwGE1ZtAMou8In1yHW+Yc5KMROeHitAZxCRBNGk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(83380400001)(508600001)(122000001)(2906002)(5660300002)(38100700002)(7416002)(91956017)(66946007)(6506007)(71200400001)(38070700005)(76116006)(53546011)(6486002)(6512007)(316002)(186003)(54906003)(4326008)(64756008)(8936002)(66556008)(66446008)(66476007)(8676002)(86362001)(36756003)(2616005)(33656002)(6916009)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?BX6ck53NmvO4D/7Xp2vkc0IF7Yx3lWYox0FQBBrOptEsrMBKljJyF2b+9ZNW?=
 =?us-ascii?Q?xiLh7T5bC+odZGfRNE5eyKQAmvFmb83q8OtzXWYv4CJp/D3O5pVbkeUA++56?=
 =?us-ascii?Q?gg485WC57m3dWa85dunsFLe2yDIg2ascAiKr/OUadjqMzg10rz1XoH3WFsqs?=
 =?us-ascii?Q?5lg1yzktj+oMIK1Aekmhi3RcncrVUnWXAO9ED/Er88jzrEOCT/vzkPT4Ahmo?=
 =?us-ascii?Q?TfgdWvGHt42wMWc/0F4szAqs+KcJoyTuTibq+gGCWeOnwBIif31NAabKurmd?=
 =?us-ascii?Q?rFVZTC1ELaR9j8DhtsbihGlwsddsp0oqUN9OidqIwaLhNG6rugxmywGJghdQ?=
 =?us-ascii?Q?SWkU+NuNYtjmBpQ6tXSpzD9xHf5CySip3fNF0X16QQ1IVhJVfCRnExV9q5Zm?=
 =?us-ascii?Q?kGRiEK+Q8UZodPGjTsK6I7/OC8aHxUCY1mD+mEveH/lTjV8ZIMnvAPIL5C64?=
 =?us-ascii?Q?EbfplIgTqJdeNcKhLfb0PWMuhFXTM1BKITU2QP145ul83GvLPbC93u9Wan4T?=
 =?us-ascii?Q?9m+1hFOaotu9VYbyPjAWKvXNv48BeuEOLmrmc3izzy8SLx8XsR75WIt+pVOd?=
 =?us-ascii?Q?frpaKDZS/hWKQbDpfBnxojxi5Hyxwh1UribXQqsvwnw1u2aiS5l/Y6ksVs8L?=
 =?us-ascii?Q?T2k7GVZS7v2cUUAy+HGQJnvUSF8Vqg96H4xMva6pa5IJg7943nyw9N5IFB/H?=
 =?us-ascii?Q?XS0zmSxQwS7LqzQWZd1y6e8smjSH9xSmK6yxxaD8zxpTSMKY+WOrzrVidNkb?=
 =?us-ascii?Q?MhqKOGL3+E85Q5jTIfTzR0CFUX2R34iHP1PuFBTICQZNwFs526OSxHElTNg4?=
 =?us-ascii?Q?5k2jVC53F2gv3OKvRIC5jnIr9OMYYvPh9bHDHcmIAr0Ff/xtsm1wXY10hUlG?=
 =?us-ascii?Q?TVV8Er/QIkhm1udjzs/jVt36i71ojeknbq13l5VReNo1KGIxNvIOonCUOnyx?=
 =?us-ascii?Q?zey+vifn7W+8y6MVKi6x/Jc0EhEm9USKe+wtR927dZL6F39BbdK/TZvv8MqJ?=
 =?us-ascii?Q?7lcUrYpUCSuxRBeszOrJntVekDtKfkb1m8ZVsXnO9C2o5cxOYO9YhOk58aCR?=
 =?us-ascii?Q?EmK6g4hrwEuaE6j+gFfKAW21O9HJFhsbcgqQBKdU8/jCVuweZrpo1LC7GhiA?=
 =?us-ascii?Q?myVcVqLaGr1jkAPRDfLQB5OvukQiz1wo7uIuBBKDPCKLW63F1ivBgkTs8jLO?=
 =?us-ascii?Q?whfHKImUI8VEToxUL/PleFm+6u6u0hkiS1/o1ybEMEoiU35pxvGQh/xjv9ni?=
 =?us-ascii?Q?qsVf2GaqMdMwHgrYuKHlE6dajdnTRtA5tCpZL/5PALcgZZkJahypXVejr21I?=
 =?us-ascii?Q?Z0xQdEtnV8ZD2OhjbWbHSTElZuAKwbrBAyOs/85zs+zYPnIVokZKkq7H1wfA?=
 =?us-ascii?Q?6a2Waj7LdTilgTwCtkwkPkiqy21/3KbJYAxExyFv0/IASJF23d1h1lDevUG6?=
 =?us-ascii?Q?czaHaBzxbYvVCqIPLVXxTIPe/twUNcFHSDCxC9rTMKB8W7rC3hOMybFIhxdu?=
 =?us-ascii?Q?worlnc0T5nVzg+qSwlWX1Y+FsEBBURp6KnVnsEa/VLg+CFO0PqDg3Snx/ubw?=
 =?us-ascii?Q?TLjoh6a1GwZAEIYcPkCP0vOBkHV4qP1SWz27P2QZRIqilNNhOy/2OFiw2Emb?=
 =?us-ascii?Q?rKXjxe28fCsQFh/1qogQ0vM46DzE6WZ6TLyNLLlXuoLZZKIP7fD5YWSsgWyn?=
 =?us-ascii?Q?x3JNnnyk8WqlWKCOC8UrujdGzyKLERnT0VFxw/bZssMJ6AjsNLXB8ejhknv+?=
 =?us-ascii?Q?33vo1cfiChJYYY2hb/HMKJoQo97v/qvUqOVaGitqngpNzbx3aVbz?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B7E9BE8D5516A4489D391CE62989F01F@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48dfa491-a105-45b4-b8c9-08da2ff5d8c3
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 May 2022 06:50:17.6232
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: W7EEBmEBBeWJbSyPqANjN/BQOC98mNjYvyDAc3aT5NhoECdg+bAjm3y5Cj5gE6EwHFId9FN3LzQpSbPMO3mPnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3899
X-Proofpoint-GUID: 6-uOja5wENfFAKWzwNgajp_jERFDQnU7
X-Proofpoint-ORIG-GUID: 6-uOja5wENfFAKWzwNgajp_jERFDQnU7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-07_01,2022-05-06_01,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Apr 27, 2022, at 11:48 PM, Song Liu <songliubraving@fb.com> wrote:
> 
> Hi Linus, 
> 
> Thanks for your thorough analysis of the situation, which make a lot of
> sense. 
> 
>> On Apr 27, 2022, at 6:45 PM, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>> 
>> On Wed, Apr 27, 2022 at 3:24 PM Song Liu <songliubraving@fb.com> wrote:
>>> 
>>> Could you please share your suggestions on this set? Shall we ship it
>>> with 5.18?
>> 
>> I'd personally prefer to just not do the prog_pack thing at all, since
>> I don't think it was actually in a "ready to ship" state for this
>> merge window, and the hugepage mapping protection games I'm still
>> leery of.
>> 
>> Yes, the hugepage protection things probably do work from what I saw
>> when I looked through them, but that x86 vmalloc hugepage code was
>> really designed for another use (non-refcounted device pages), so the
>> fact that it all actually seems surprisingly ok certainly wasn't
>> because the code was designed to do that new case.
>> 
>> Does the prog_pack thing work with small pages?
>> 
>> Yes. But that wasn't what it was designed for or its selling point, so
>> it all is a bit suspect to me.
> 
> prog_pack on small pages can also reduce the direct map fragmentation.
> This is because libbpf uses tiny BPF programs to probe kernel features. 
> Before prog_pack, all these BPF programs can fragment the direct map.
> For example, runqslower (tools/bpf/runqslower/) loads total 7 BPF programs 
> (3 actual programs and 4 tiny probe programs). All these programs may 
> cause direct map fragmentation. With prog_pack, OTOH, these BPF programs 
> would fit in a single page (or even share pages with other tools). 

Here are some performance data from our web service production benchmark, 
which is the biggest service in our fleet. We compare 3 kernels:    

  nopack: no bpf_prog_pack; IOW, the same behavior as 5.17
  4kpack: use bpf_prog_pack on 4kB pages (same as 5.18-rc5)
  2mpack: use bpf_prog_pack on 2MB pages

The benchmark measures system throughput under latency constraints. 
4kpack provides 0.5% to 0.7% more throughput than nopack. 
2mpack provides 0.6% to 0.9% more throughput than nopack. 

So the data has confirmed:
1. Direct map fragmentation has non-trivial impact on system performance;
2. While 2MB pages are preferred, bpf_prog_pack on 4kB pages also gives 
   Significant performance improvements.  

Thanks,
Song

