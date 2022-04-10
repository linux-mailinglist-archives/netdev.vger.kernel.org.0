Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21D534FAB6B
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 03:37:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235070AbiDJBi3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Apr 2022 21:38:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234971AbiDJBiX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Apr 2022 21:38:23 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DECF43AFC;
        Sat,  9 Apr 2022 18:36:13 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23A1Seph019902;
        Sat, 9 Apr 2022 18:36:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=1oqTcWSkXMMY+QESE68FXIguYTamoprMXK/LRbyxvHg=;
 b=Qtws657F/0+AlYZWUFmG9Z7v3TOH8HKa+m6LOVPfdqcdhICoBepfPKaV85lbsNJj8cXt
 cmL43cxfDThTK4DiNuGByi0BQvu5/IlTe4bXz9YdQIID6XhYh78y2/ZBo9sm+3JId8e9
 kEe9XhBycGN1Jo9I2tDPReD6Jysro+ericA= 
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2048.outbound.protection.outlook.com [104.47.73.48])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fb78q2hjp-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 09 Apr 2022 18:36:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O7fOhsFwPHn6H1kKbzLKJ5p6leFXfU2MB1/IUOcNPdYSVq91N4qUNjAQdZih9riECtgMlLblqdz/uv5pk8D7zPqasvfapyis2v+s/FCb3TqrNfx7NCFGvWHwPpmazeoIs/IXsd10SstCN4+kJYKvQKXp9dKcxckm+5GamFFlxf2yMOA9E1E52ksEvwKmrnd32cuudwf54kxNogCCDHgCT6lv1xK/LP8KdaTzft/2Eaq8dGwaagtX/UsNRgi85GovxA6fp+zLCRsEm2YGxGcQVsUuXy5xpLvbjAbOpdHMkiPdtOpAb3WnhQg54yHx3DHB34tX1tHS6ijffeyxGFv8Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1oqTcWSkXMMY+QESE68FXIguYTamoprMXK/LRbyxvHg=;
 b=dcSSkAtu5mEsrgj1iao+UhTYjF/gv7gVu18uaKCSr7A4mfhb95Dd3tA76olGSRTYYWjtvNC23P1nA/NGXMvyH1UWHDQ2PHajeDEh1yoE64mpYADtF09U9r4z1w8aojRcIcS03vRYbMC6tjG6Oyrv0fNjO0WbpDGEE27t+mbIPM3gaM5QUJ2hqAhPcR7AR+9dFptzEqQfrH5PDRxwr+LsIw0ZztUIYTl8bZubWmAVJtgIE+iWkATsB8fpCeUWc3+Jvsy07qtep6niBMr1BIHO/OWsGbChbaPQHifQm4rid6LD+npdSaNAuMEuvi3zkTc5O4ejhnANVe6SKMY+hYDB/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA0PR15MB3869.namprd15.prod.outlook.com (2603:10b6:806:8c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.28; Sun, 10 Apr
 2022 01:36:10 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::e150:276a:b882:dda7]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::e150:276a:b882:dda7%8]) with mapi id 15.20.5144.028; Sun, 10 Apr 2022
 01:36:09 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Thorsten Leemhuis <regressions@leemhuis.info>
CC:     Song Liu <song@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "rick.p.edgecombe@intel.com" <rick.p.edgecombe@intel.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "imbrenda@linux.ibm.com" <imbrenda@linux.ibm.com>
Subject: Re: [PATCH bpf 0/2] vmalloc: bpf: introduce VM_ALLOW_HUGE_VMAP
Thread-Topic: [PATCH bpf 0/2] vmalloc: bpf: introduce VM_ALLOW_HUGE_VMAP
Thread-Index: AQHYS5mrbt0Ek+HXYEWMr5jprPTLPKzndvSAgADojYA=
Date:   Sun, 10 Apr 2022 01:36:09 +0000
Message-ID: <FAECBBAA-CF1B-42EB-9077-C655E8FD65E8@fb.com>
References: <20220408223443.3303509-1-song@kernel.org>
 <8665439b-e82e-65b8-ddb6-da6a41d6f6da@leemhuis.info>
In-Reply-To: <8665439b-e82e-65b8-ddb6-da6a41d6f6da@leemhuis.info>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.80.82.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d9c29f4c-fb60-493f-5321-08da1a927d88
x-ms-traffictypediagnostic: SA0PR15MB3869:EE_
x-microsoft-antispam-prvs: <SA0PR15MB3869E60E0144348BF3F11968B3EB9@SA0PR15MB3869.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OQAH7VAU+tdH66SwiSNz741Nyy6rs1gewS9AOIrLKc1ZNYYEK9vMpNCXbv8Tu70WQS8PXxn10GHqWFKYVBswURypsIi/JYX2OB2vPdBd7+RKqAs3peEofenelRcIgf5amUMY+tEykDlwivqwjmh259pf2Lm8OMUgg0/NR87opGobRrggNHKMzWQbssFpz1YBUn166VQ69Y2vJGSlwQ4R+s5I0g6D+wpC3gM8cyt9SHHhOQU6sr6FEHLPT1QfbSLiJDYPJx5i+zSzctEK9Mx/9HngYhjUUVATpGTs1bRg+MIGHQLppqaNFo2JQwWRwP9sLZPhNIise746b/PJMahqzzZ7BDBjcg/poUHmg7ZB12koFHma2O61q0W2ETICjJzHzKlrG/7lPBHikUU0MByZk5eKhUUNiVyi1Mk15OpqcjZdQnEpdIhszAGpFwucjSIrpUHSc+t8ZhB96zJRp86+TeoLnUMlEWMlUUXVwKI0KbBzTsotCnqJzWfRFfxtY3F/obel2UHw170eWG39o/8vh7N7GFJ9jI0h9d9h0yvqEUv6bZk8YZZGCg/3J1hlzZ0zLMxp/41O19i6arNAn7mNLNAg5nQLtyfukAxsqvcigFBw80VgZr/QWKl51xJ+ieH4Rdqct7WR8VxK0kn9bNtIeOl7Pt2RiQB79i4Q3AfQ9oIu3il0qbomU0m1p1vg59rbbw709gvOrlGg28apNbqTVSGtNF93yF+amgv23PBCRWj/Bcep/CaKyPqB3tlmhj2wfZeXik6grdPbWtoxtyhe3TZvvQhNrJFctVdoBhponpeXdzu3lBDflED3cBWekqsLX3I/IJhpc2sN9jtyLsL1DPCmcdk6Ix4/Fo2OwPBSJptZ9iOVhEtjEnFO/5gDH95c
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38070700005)(38100700002)(86362001)(2906002)(122000001)(5660300002)(7416002)(8936002)(53546011)(6506007)(6916009)(2616005)(6512007)(54906003)(71200400001)(36756003)(966005)(6486002)(316002)(64756008)(66946007)(76116006)(66556008)(33656002)(8676002)(4326008)(66446008)(66476007)(186003)(83380400001)(91956017)(508600001)(14583001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?D5k07HHyeHfeb4Cmj8ZP3j5UH9roGR9a1Mob/LEgBumkCXsJcKbwM5CT8GJk?=
 =?us-ascii?Q?x2+Ui5XBcucDQMM7YlKg/kNwjPeaKWYCqIKUfvKoUS6AH+Fa8/XjG0L+1w68?=
 =?us-ascii?Q?20c/kv2eBiCGMw3CrRQCnky6zudL6V3wgqyw34ssnCUhm0cGG4awI/q4E9so?=
 =?us-ascii?Q?Cgy087C7zdw8LJPCUwe42AveoFFzwUIpDBmC+upPxswd3WgyaJH6vIDjTfm9?=
 =?us-ascii?Q?JYjaeu4u4OCb0wF7Bcx9vuQiG3RLipqBvPZl/IiROgjOvinYq8hP2ied8LmS?=
 =?us-ascii?Q?oDZs+qDjLRN7IfTo9vrFCrF48EqkczSd6gD6slbBJzEBVxSmSDuSIkbJHc9I?=
 =?us-ascii?Q?p3YuKXqDJyNlJ6QXgL7fghob6IXp5oHBXUJmcB0yfUcoe3+nwhp8HIdlGSZ0?=
 =?us-ascii?Q?EHCidlNr9i5+Rf8ObAsvT0ncZ8jAKQ8qRZc/i0IqngW6VymgIEdJ4FW9zr90?=
 =?us-ascii?Q?bF+oqGGQilHAfNjh8e14yg7PzII6CU9Je5O5kZHgjD/mXdGFCD5gah1CKsVY?=
 =?us-ascii?Q?9i1bBK4o3cU+igA7ogekCMzusfcon0oKYLan84sY7DCOvQfbOAuF/X8sX7Kh?=
 =?us-ascii?Q?mXl7BJXqy4LEQtUEmvf3WPEDRwnrnuQ8TLRa+kbtPhadCQS9OA2ZcjVxwQd0?=
 =?us-ascii?Q?nZf+TlAJuaS0xhOan7aH6xboNja621K10bB5so/Z7Ir2At7PEkpFBgRLPJvN?=
 =?us-ascii?Q?u1BM3oAGD/7JnJLhSjIyivEZbHt+s5F6TZPdK0mld7MDyG8+9J5mNWfi/kdq?=
 =?us-ascii?Q?5sL49mxAcyZyEk2GqUmTJSYm4oF749svRAJPIAx2oTzIOc1VVGY3om+kfiOA?=
 =?us-ascii?Q?uIMfE7sX8MivpSc2sPrrWPTMWLUtNJkLPqsDoIlsWxpdXEhD3aDH6q8exBFv?=
 =?us-ascii?Q?XLQHL6jlUKWKIwAsk5mJGbZLGK3Y99mTZFsiVGeoMO3V2ka3WVANSux63XcT?=
 =?us-ascii?Q?uHC66BrkaEwhiCEJFQ8nkadRsC717qSrR0vOqQQWt45RiExpygNrLAq5Dela?=
 =?us-ascii?Q?Ga81UJ7tQ3dtjMkkVyrdjEdXK/BR5ywoDF7OYQwr6iyaYlLMBW9nQCHbmDVx?=
 =?us-ascii?Q?hbosgTQnDGoOPaMtoaZOOYZoOBecsHlxyIBNOdQXjcxu/NShWzR8pswmomcb?=
 =?us-ascii?Q?/8btKfEyR33PY2CnGSSOLqsAp8ILsdhrjwqcTwDJfnAhIdDmI5d8iYjn400I?=
 =?us-ascii?Q?TyPLdsm971Au+GdQoBStvgtuIO8OMN4xDjC9N4PqcOi3nHDz0+z6O5Vn9sXM?=
 =?us-ascii?Q?ZZiopPddPwt8T0kTjV0kZopMrOO+hzAP3+sKc9+ge06kvVKIbFsKVtn6XuwZ?=
 =?us-ascii?Q?68NsiBaKz/W9C1PLATXrl5NX0bIoy3zIZr+9ZSFJ34krdL+oRTQ1SpJCIEBk?=
 =?us-ascii?Q?ip2cxq7UnaagzEmJWV9OdYIVK5m9VCDzKE7JsfiAg2QqbtyEQyWj63qwD7Cf?=
 =?us-ascii?Q?62Nkh2qHm/B7pdsmwKS+e3OD7MhK030iuZxcQ9hs+igVqiJQl4ALkEJjCny+?=
 =?us-ascii?Q?RMQRahVljPAFnWxt/d59BS3zgdeXhjtN5tnMwwpOnOxqbVgLS50bcPbDDd8l?=
 =?us-ascii?Q?1TfzW/QEIFizuHzXnVZIdKccF8F7ifLPuRgm9WbybI4IZoN8Uds9sZ6liQQT?=
 =?us-ascii?Q?jUYvS0IveOuBXVr2xBkaCLmt3jjS+ssAqMpEzkuYEpw6xWMRHVCoRzSX8ZGk?=
 =?us-ascii?Q?r1ig3YX2Zccw4Z7LpVPM6JJWWPNJ8gn8rz2UOGSxIzk2KWGlFRrOyxbLaI+0?=
 =?us-ascii?Q?S9LnGLqYMzTRnwejgClgqCdcGDI/DwB22iG+O1BsQPGsDTBN6z7a?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <086798E2C64B524A818F4890E7E6E91E@namprd15.prod.outlook.com>
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9c29f4c-fb60-493f-5321-08da1a927d88
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Apr 2022 01:36:09.9199
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EVyJyMStFRe+zKtwlc634qiaVxcs9lijWcPsg20T+7oEcdDGcMv5Y7Xkb19FdwCkR6E5sp4uxT65UWRK4s6V/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB3869
X-Proofpoint-ORIG-GUID: GHQe0gcyI5eUmclndop92zPHvfWPbx84
X-Proofpoint-GUID: GHQe0gcyI5eUmclndop92zPHvfWPbx84
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-09_25,2022-04-08_01,2022-02-23_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Apr 9, 2022, at 4:43 AM, Thorsten Leemhuis <regressions@leemhuis.info> wrote:
> 
> Hi, this is your Linux kernel regression tracker.
> 
> On 09.04.22 00:34, Song Liu wrote:
>> Enabling HAVE_ARCH_HUGE_VMALLOC on x86_64 and use it for bpf_prog_pack has
>> caused some issues [1], as many users of vmalloc are not yet ready to
>> handle huge pages. To enable a more smooth transition to use huge page
>> backed vmalloc memory, this set replaces VM_NO_HUGE_VMAP flag with an new
>> opt-in flag, VM_ALLOW_HUGE_VMAP. More discussions about this topic can be
>> found at [2].
>> 
>> Patch 1 removes VM_NO_HUGE_VMAP and adds VM_ALLOW_HUGE_VMAP.
>> Patch 2 uses VM_ALLOW_HUGE_VMAP in bpf_prog_pack.
>> 
>> [1] https://lore.kernel.org/lkml/20220204185742.271030-1-song@kernel.org/
>> [2] https://lore.kernel.org/linux-mm/20220330225642.1163897-1-song@kernel.org/
> 
> These patches apparently fix a regression (one that's mentioned in your
> [2]) that I tracked. Hence in the next iteration of your patches could
> you please instead add a 'Link:' tag pointing to the report for anyone
> wanting to look into the backstory in the future, as explained in
> 'Documentation/process/submitting-patches.rst' and
> 'Documentation/process/5.Posting.rst'? E.g. like this:
> 
> "Link:
> https://lore.kernel.org/netdev/14444103-d51b-0fb3-ee63-c3f182f0b546@molgen.mpg.de/"
> 
> Not totally sure, but I guess it needs a Fixes tag as well specifying
> the change that cause this regression (that's "fac54e2bfb5b"). The
> documents mentioned above explain this, too. A "Reported-by" might be
> appropriate as well.
> 
> In anyone wonders why I care: there are internal and publicly used tools
> and scripts out there that reply on proper "Link" tags. I don't known
> how many, but there is at least one public tool I'm running that cares:
> regzbot, my regression tracking bot, which I use to track Linux kernel
> regressions and generate the regression reports sent to Linus. Proper
> "Link:" tags allow the bot to automatically connect regression reports
> with fixes being posted or applied to resolve the particular regression
> -- which makes regression tracking a whole lot easier and feasible for
> the Linux kernel. That's why it's a great help for me if people set
> proper "Link" tags.
> 
> While at it, let me tell regzbot about this thread:
> #regzbot ^backmonitor:
> https://lore.kernel.org/netdev/14444103-d51b-0fb3-ee63-c3f182f0b546@molgen.mpg.de/
> 
> Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
> 
> P.S.: As the Linux kernel's regression tracker I'm getting a lot of
> reports on my table. I can only look briefly into most of them and lack
> knowledge about most of the areas they concern. I thus unfortunately
> will sometimes get things wrong or miss something important. I hope
> that's not the case here; if you think it is, don't hesitate to tell me
> in a public reply, it's in everyone's interest to set the public record
> straight.

Thanks for the reminder. I will add the Fixes tag, and try to work with 
regzbot. 

Song

