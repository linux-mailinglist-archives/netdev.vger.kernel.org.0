Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3E964EA920
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 10:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233847AbiC2IZo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 04:25:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232707AbiC2IZn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 04:25:43 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 741F8996B1;
        Tue, 29 Mar 2022 01:24:01 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22T3Y80u021672;
        Tue, 29 Mar 2022 01:24:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=LodP60T38MjjVZ8xYukd30Tn0UrQFcalOFsx4ifwEvo=;
 b=FLlrUJmhT6u2FN9WE8i3izRiqPbeWxhDRPOwa2D0PwYQHqW60PgMe/U5pXmW8rFXC/3c
 G+uYW/45RnErPlaL1tP0Ij1GohS9s/3ez50r/W8gmR0YvRNEZ36a3L3bqNywkwUOQ5Vo
 mjoenwaotkZ6XmrF4hVPkZa+/2AnOhe6do0= 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3f3tak13sb-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Mar 2022 01:24:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A0yKkYz5oqGTnCGFYIchZOPI4HT/p9qwM4jvr8FxHw1YvgEDoDlCBLqf1VOuxnhWeXF1dZALJZqh1X/eWT3MVtP0/c/eOXgBwMgUFHIwOsv+nttqk3ym/NzQbNtLwC6z1Mm19zd/n55Mcp7gh9aYpOURNkMMWSwSRHm7eYPuE7zjknViD2F1SbgeUp8oOT67fiUZvYrJn6gopAneLnLSLe4dtzA+bNECGFbmmo6V++c68jApcmOxt1TzamISenEWypsMCq88ds4x7r7siY9mkpE+plNDa+cF/AyZUOSnH3aboGsz+Cz/MPvCYE01zTDx/HLfP5hyfWbw0KTYNbu98w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LodP60T38MjjVZ8xYukd30Tn0UrQFcalOFsx4ifwEvo=;
 b=HWYp+HHmm3OOt6dsr77gFPmt/VRm7oqQcy7wOtJquNX9836zcsni/AXuo/8GZ9tG2JBvUvIYV3NzWeV9by/6KJ7z86ls+SQ6Lc1IIW31yUv1NA7qCWcA4VdWmRUxrkfddi2ir6xsgMPl7IwbDqZniUzmdugPb69Mce8l0VW6izKn88DfH4IMCK2up5aX+mLobzvRQK+9nd3nccfR2EXj36Ftb7FBfHQFU4Kwzsg9eztt5dnrUi6UOmNydoEWsDC2fINpqEcO6t9Ak8Nyp3Hdd81F8j5WdPkfCz0C6DCBL3dRQ0a3IHdorPwawaIiKpcHvQdMEi6ANPjkyRxHCYnzdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by DM5PR15MB1913.namprd15.prod.outlook.com (2603:10b6:4:52::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.23; Tue, 29 Mar
 2022 08:23:57 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::58c9:859d:dc03:3bb4]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::58c9:859d:dc03:3bb4%3]) with mapi id 15.20.5102.023; Tue, 29 Mar 2022
 08:23:57 +0000
From:   Song Liu <songliubraving@fb.com>
To:     "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC:     "pmenzel@molgen.mpg.de" <pmenzel@molgen.mpg.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "song@kernel.org" <song@kernel.org>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "iii@linux.ibm.com" <iii@linux.ibm.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v9 bpf-next 1/9] x86/Kconfig: select
 HAVE_ARCH_HUGE_VMALLOC with HAVE_ARCH_HUGE_VMAP
Thread-Topic: [PATCH v9 bpf-next 1/9] x86/Kconfig: select
 HAVE_ARCH_HUGE_VMALLOC with HAVE_ARCH_HUGE_VMAP
Thread-Index: AQHYGfmQYHpJmCxW+kSTgNf/KlCER6zRFs+AgASr4wCAAA5KgIAAh7mA
Date:   Tue, 29 Mar 2022 08:23:57 +0000
Message-ID: <6080EC28-E3FE-4B00-B94A-ED7EBA1F55ED@fb.com>
References: <20220204185742.271030-1-song@kernel.org>
 <20220204185742.271030-2-song@kernel.org>
 <5bd16e2c06a2df357400556c6ae01bb5d3c5c32a.camel@intel.com>
 <F079AC10-2677-41B4-A4D5-F07BDE512BE1@fb.com>
 <ee754770889c7b6de13d8e4835c7bd8b15d5e538.camel@intel.com>
In-Reply-To: <ee754770889c7b6de13d8e4835c7bd8b15d5e538.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.60.0.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7a7aedf3-c53c-4800-78cc-08da115d7861
x-ms-traffictypediagnostic: DM5PR15MB1913:EE_
x-microsoft-antispam-prvs: <DM5PR15MB1913C92FBCB7AE4B44C39281B31E9@DM5PR15MB1913.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RoMRU0HPPQNsvq0evYqFILsRCdRjuPlDLttU/jLJM44jiPuIbp2C393abXBtwFO0Kz4+2TNvqczIikpU/7WB1Y8yzEqRHyJ/2GvgkHtP2CC7xcDrJsLemX/Oq3sxjJtEoQUBQaDzlqQi5Xx1p1B92Mzz/JtkeRlwt9lRnD3Fs7Bfx1busMxg2T+j2KwFzvP8HBzSY1dbBD932rYRDSF0B9dfZBt+gEO0DqFt6orTzKVP1c9aGGkrQQMaW37FuMTJu7qfrtnaSaB5iUptnb5c8uyG5Sv1rDt/nAHPS/HkAbCZ/VUESg0yDDhKUHcNlS7mWckCX/UhpImazKZZx0L6cMQbhDyMPDRGGAi80Jm0BgJEp51LW/O2FsJtwlPcxoZFJcfYGW9SLVLFPWbIPwChEtzcWAbeVuMQH4uFM3gLa5WmP+QcJRc+LVxCs6oUlBh+ZLRiP0EuGxO2DOUo10iUwxJYeek90pjHroTxOsI3ueNy3KwK864mmxVE+6Fz3D99/tnpF95/w5RBDxVy+9yOofgJgLcWyTPTtXkAVb4cUI/8rKr2khthdjQmRyAEJGcjQvzRnCP4M81OvEbqJFQayWp16w3141dw5r7gktb5aKVZo7kVfKTzPAAQKrofbmUQvhhFg1fbyERhJJGd2iMWdklG36bBwIkYvgjzn/3gIs0wV3vzejd61UbUfffeRr53GM4YZNqFuXigI4WYR7VzeX9gFbfXsNQ6WOqmXy2iOIYsINmf8MczGsIZZ6mhds+U8C3luoc/ETswcHTz/sp4iA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(122000001)(186003)(8936002)(7416002)(83380400001)(38070700005)(66446008)(64756008)(66476007)(38100700002)(66556008)(5660300002)(4326008)(66946007)(2906002)(316002)(76116006)(6506007)(6512007)(2616005)(508600001)(53546011)(91956017)(8676002)(6486002)(6916009)(36756003)(71200400001)(86362001)(33656002)(54906003)(14583001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?GmomoeH0c2PqDwckMEtGmfybSta8m29yRBLLDb8Va8Pxd4phYi0qr23xCeyV?=
 =?us-ascii?Q?oiiTvxf9H9nUz8j7ZuozCK3+zD4FXQtouvthSdEE/aRTM0aarZ/W0wPo3x5/?=
 =?us-ascii?Q?2EpldDuy+VwuO++MU346Ny79JoU24HtqW12+eSFPFVmHD0l59h4tmn87XfGd?=
 =?us-ascii?Q?s1JLaeTBm4UEl/BW3B4Kq532lWLmKZ5OKWHQt4BGbBI/SK81IevvwNKP9qX1?=
 =?us-ascii?Q?NVDdMfUwo2Bij6b3Z/v4X0INbeSwXbYDpPOWTw6Jv6wxri8Fp/7kx3MfLW+F?=
 =?us-ascii?Q?1K8E+Z7QqHvbPW6TB4Kvka8wXr/EXtV6tZCuEparLSpCpUjYHuqUju+LM/+r?=
 =?us-ascii?Q?5/DIrpHIN4I5IghX5uSl+qggeSB9AUlYgi4F0aiaqitL+l0157rCIjt+5TsZ?=
 =?us-ascii?Q?m7eLBxIZbVrOkFbybZ2bnjJQ9pj0R688npdZuHb0w+0av8P1DaaE3As4m3+E?=
 =?us-ascii?Q?UIKVGdXGdIle5GDhTdrrE0YyHTf+vJ6bB93uz1L5YXkorqpPmms+mdorR9Xy?=
 =?us-ascii?Q?89+/MFZpjZ6fDmUgqRcFR6vC/M3hpQLBe/+nuyy5kQ7lMIp94OjrZZ1JRSwk?=
 =?us-ascii?Q?JqIh6QAjLHA4ukZkv/KxxKjbDhECMDSImM1cIjbhs6F5aGwdtOWgX+AXIsUY?=
 =?us-ascii?Q?4njWFDq65n+y+XDtILMhv8lpaVepMURuglm2JHiWJ51nv6YPbdcPGe3JHCf8?=
 =?us-ascii?Q?PxD0dN9NKfWJGoc5GqFEXSzZiTbmnI8oas2SuKHqRhMIm8bgv6Z6dh/S7wwW?=
 =?us-ascii?Q?641ulNMAiFCEWQX8oZvU2/Q49E+A7MgieITSOwBcCtrYHcokPo8P9iJo5bNx?=
 =?us-ascii?Q?7hRTi+GsIvnqOTqbI2TcZbCzBf9QYEaesrTroEcVN8Lnr/xsLMDefawr13GT?=
 =?us-ascii?Q?4tiT4Gmq9GrfelDNsmb4IIdnbdsWrG5HgH+ZcYqop5cJnVokdOtnEln6D8Fk?=
 =?us-ascii?Q?swEPLr9B7a1ZhKD+U5od05lPkaen59kLe4jSgthydGlmr3HTUvRpQ51rLKEP?=
 =?us-ascii?Q?pjfWS3xW4xSNWRq+9qx/D7FrOQqgtKhaUgVToKCMdgeRRHDhfushagB7uoMy?=
 =?us-ascii?Q?2SQPk3QzdQKxr4L/6vpYg4YJLWbUCIIJO9Na2BI3WHcbDAPr7BxO1RROzsuu?=
 =?us-ascii?Q?KTP/T6cuhDxdy0oMQ6YLmU21ISFTXKXyR/C/r3+3ytCbyEVKQlRbGVkgAuf/?=
 =?us-ascii?Q?+uoWWS9d3Pje/IRxeWa7cPrRLws1vRmuNYZj0wDc3eNQzpzJ5Edlig1dP9Cj?=
 =?us-ascii?Q?ffKvTaezqqPz2ZUnZ87CmwHuBQkCXu52vB8fuVN/NcwdO/0k73cpgqTKj4wo?=
 =?us-ascii?Q?6vSje1FNKqMxHIl9VHnc7D2vDtvG76500QNxz0jjKRNsZikTasv8A3sMS/5H?=
 =?us-ascii?Q?jKJVMs+jqrurxoHw6k1i/c61WBoL01aVKx1gLiipvtsom4MlJymOPzKomO+Y?=
 =?us-ascii?Q?yhlOU1I3emvZ3WhP98qdCWuP2pclxbOpW5JfWufG+/Khoyabu1nqnQfHKdAx?=
 =?us-ascii?Q?cwTL+6aMtNACGB79vHLw430ocs6MExIjEjU0/0K90qZn/GaaQRc0cdXMI5ee?=
 =?us-ascii?Q?de2dZIGoQVoDyYZGHnk/qqWNypmEV4S2ePzjXl2c+YVd6VG8guyLe5PXzKSA?=
 =?us-ascii?Q?E2vXs9YK7ZiBrmggazF/Vgx1ZXBOAHvHQRFGi0jjeky6xeuEVfyH9U7e/Z3f?=
 =?us-ascii?Q?Evs+patRApLH9WuqOcUcsLeu+hir02I+Znjfs2HD5S+DuLbTA320829uAv9F?=
 =?us-ascii?Q?teiy27TS7otjTTvMsdMHmeyS5+1wVy9+6ALDXHJGSQZ6+RtLl4a1?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D53ABAA418785049BF48BABC1D26BCF6@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a7aedf3-c53c-4800-78cc-08da115d7861
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Mar 2022 08:23:57.4850
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ox9hummnV+ZyX0UWeJlh0SB761fl4sUbsgXO6AgxEHrXIE77sz9nlRTDxsFWOnm/6QIcZs79YgjpKU1ndHjlAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1913
X-Proofpoint-GUID: tFBIXKnFx4b8_QdQjuT8KlWrFRqreWLc
X-Proofpoint-ORIG-GUID: tFBIXKnFx4b8_QdQjuT8KlWrFRqreWLc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-29_02,2022-03-28_01,2022-02-23_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 28, 2022, at 5:18 PM, Edgecombe, Rick P <rick.p.edgecombe@intel.com> wrote:
> 
> On Mon, 2022-03-28 at 23:27 +0000, Song Liu wrote:
>> I like this direction. But I am afraid this is not enough. Using
>> VM_NO_HUGE_VMAP in module_alloc() will make sure we don't allocate 
>> huge pages for modules. But other users of __vmalloc_node_range(), 
>> such as vzalloc in Paul's report, may still hit the issue. 
>> 
>> Maybe we need another flag VM_FORCE_HUGE_VMAP that bypasses 
>> vmap_allow_huge check. Something like the diff below.
>> 
>> Would this work?
> 
> Yea, that looks like a safer direction. It's too bad we can't have
> automatic large pages, but it doesn't seem ready to just turn on for
> the whole x86 kernel.
> 
> I'm not sure about this implementation though. It would let large pages
> get enabled without HAVE_ARCH_HUGE_VMALLOC and also despite the disable
> kernel parameter.
> 
> Apparently some architectures can handle large pages automatically and
> it has benefits for them, so maybe vmalloc should support both
> behaviors based on config. Like there should a
> ARCH_HUGE_VMALLOC_REQUIRE_FLAG config. If configured it requires
> VM_HUGE_VMAP (or some name). I don't think FORCE fits, because the
> current logic would not always give huge pages.
> 
> But yea, seems risky to leave it on generally, even if you could fix
> Paul's specific issue.
> 


How about something like the following? (I still need to fix something, but
would like some feedbacks on the API).

Thanks,
Song


diff --git a/arch/Kconfig b/arch/Kconfig
index 84bc1de02720..defef50ff527 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -858,6 +858,15 @@ config HAVE_ARCH_HUGE_VMALLOC
 	depends on HAVE_ARCH_HUGE_VMAP
 	bool
 
+#
+# HAVE_ARCH_HUGE_VMALLOC_FLAG allows users of __vmalloc_node_range to allocate
+# huge page without HAVE_ARCH_HUGE_VMALLOC. To allocate huge pages,, the user
+# need to call __vmalloc_node_range with VM_PREFER_HUGE_VMAP.
+#
+config HAVE_ARCH_HUGE_VMALLOC_FLAG
+	depends on HAVE_ARCH_HUGE_VMAP
+	bool
+
 config ARCH_WANT_HUGE_PMD_SHARE
 	bool
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 7340d9f01b62..e64f00415575 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -161,7 +161,7 @@ config X86
 	select HAVE_ALIGNED_STRUCT_PAGE		if SLUB
 	select HAVE_ARCH_AUDITSYSCALL
 	select HAVE_ARCH_HUGE_VMAP		if X86_64 || X86_PAE
-	select HAVE_ARCH_HUGE_VMALLOC		if X86_64
+	select HAVE_ARCH_HUGE_VMALLOC_FLAG	if X86_64
 	select HAVE_ARCH_JUMP_LABEL
 	select HAVE_ARCH_JUMP_LABEL_RELATIVE
 	select HAVE_ARCH_KASAN			if X86_64
diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index 3b1df7da402d..98f8a93fcfd4 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -35,6 +35,11 @@ struct notifier_block;		/* in notifier.h */
 #define VM_DEFER_KMEMLEAK	0
 #endif
 
+#ifdef CONFIG_HAVE_ARCH_HUGE_VMALLOC_FLAG
+#define VM_PREFER_HUGE_VMAP	0x00001000	/* prefer PMD_SIZE mapping (bypass vmap_allow_huge check) */
+#else
+#define VM_PREFER_HUGE_VMAP	0
+#endif
 /* bits [20..32] reserved for arch specific ioremap internals */
 
 /*
@@ -51,7 +56,7 @@ struct vm_struct {
 	unsigned long		size;
 	unsigned long		flags;
 	struct page		**pages;
-#ifdef CONFIG_HAVE_ARCH_HUGE_VMALLOC
+#if (defined(CONFIG_HAVE_ARCH_HUGE_VMALLOC) || defined(CONFIG_HAVE_ARCH_HUGE_VMALLOC_FLAG))
 	unsigned int		page_order;
 #endif
 	unsigned int		nr_pages;
@@ -225,7 +230,7 @@ static inline bool is_vm_area_hugepages(const void *addr)
 	 * prevents that. This only indicates the size of the physical page
 	 * allocated in the vmalloc layer.
 	 */
-#ifdef CONFIG_HAVE_ARCH_HUGE_VMALLOC
+#if (defined(CONFIG_HAVE_ARCH_HUGE_VMALLOC) || defined(CONFIG_HAVE_ARCH_HUGE_VMALLOC_FLAG))
 	return find_vm_area(addr)->page_order > 0;
 #else
 	return false;
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 13e9dbeeedf3..fc9dae095079 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -851,13 +851,28 @@ static LIST_HEAD(pack_list);
 #define BPF_HPAGE_MASK PAGE_MASK
 #endif
 
+static void *bpf_prog_pack_vmalloc(unsigned long size)
+{
+#if defined(MODULES_VADDR)
+	unsigned long start = MODULES_VADDR;
+	unsigned long end = MODULES_END;
+#else
+	unsigned long start = VMALLOC_START;
+	unsigned long end = VMALLOC_END;
+#endif
+
+	return __vmalloc_node_range(size, PAGE_SIZE, start, end, GFP_KERNEL, PAGE_KERNEL,
+				    VM_DEFER_KMEMLEAK | VM_PREFER_HUGE_VMAP,
+				    NUMA_NO_NODE, __builtin_return_address(0));
+}
+
 static size_t select_bpf_prog_pack_size(void)
 {
 	size_t size;
 	void *ptr;
 
 	size = BPF_HPAGE_SIZE * num_online_nodes();
-	ptr = module_alloc(size);
+	ptr = bpf_prog_pack_vmalloc(size);
 
 	/* Test whether we can get huge pages. If not just use PAGE_SIZE
 	 * packs.
@@ -881,7 +896,7 @@ static struct bpf_prog_pack *alloc_new_pack(void)
 		       GFP_KERNEL);
 	if (!pack)
 		return NULL;
-	pack->ptr = module_alloc(bpf_prog_pack_size);
+	pack->ptr = bpf_prog_pack_vmalloc(bpf_prog_pack_size);
 	if (!pack->ptr) {
 		kfree(pack);
 		return NULL;
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index e163372d3967..9d3c1ab8bdf1 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2261,7 +2261,7 @@ static inline unsigned int vm_area_page_order(struct vm_struct *vm)
 
 static inline void set_vm_area_page_order(struct vm_struct *vm, unsigned int order)
 {
-#ifdef CONFIG_HAVE_ARCH_HUGE_VMALLOC
+#if (defined(CONFIG_HAVE_ARCH_HUGE_VMALLOC) || defined(CONFIG_HAVE_ARCH_HUGE_VMALLOC_FLAG))
 	vm->page_order = order;
 #else
 	BUG_ON(order != 0);
@@ -3106,7 +3106,8 @@ void *__vmalloc_node_range(unsigned long size, unsigned long align,
 		return NULL;
 	}
 
-	if (vmap_allow_huge && !(vm_flags & VM_NO_HUGE_VMAP)) {
+	if ((vmap_allow_huge && !(vm_flags & VM_NO_HUGE_VMAP)) ||
+	    (IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC_FLAG) && (vm_flags & VM_PREFER_HUGE_VMAP))) {
 		unsigned long size_per_node;
 
 		/*
