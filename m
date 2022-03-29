Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0028A4EB5AB
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 00:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236378AbiC2WNt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 18:13:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236284AbiC2WNs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 18:13:48 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A474182DAF;
        Tue, 29 Mar 2022 15:12:04 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22TKTZpg013121;
        Tue, 29 Mar 2022 15:12:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=9IthlJlje0hIKAU2/Hr+KqsGD6QIn/LBUBYSqkKR1GE=;
 b=JnEItZzFZRXWSoNt+ey16ju4xN1v0toNwRMcS0Abe+9QqlkQ6oQ4lVPGUp0zjZcegr9u
 IHWKz4OBLJmG3X5F8zWB3xT+sxsGK8ZBsYzeM0iC3NkcroSIp16MZ6/lz22MT+jkRkzT
 8JXP0dx5uOjOJun8iDHiLvjb+GIqUf4cot4= 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3f3tc8ehcs-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Mar 2022 15:12:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m4Sv+RmQ9/o/izc/VSqVSgxG1sL3WAAygiftvY0tDa1IckOG4tEIKyLV6BsYOL8cBwwXLtK/Q6b0zuXyXNyrXTdVU2yIGwXkUevsExqzZVnzG2p4Myv78eOrj4X1QUBKyUbVInMJVbwpWbCy6W1RGSzyG3DsaZMZxGP1ipvTIh8YcSbsr9EUnZ5zhtunn3KCB4Xzlu1jjRH5spMZKRvs24P9Y9LKkCfX6uBLlyMkQTU6ecwgRmIFkloxqjkHAlsKbstUuRjfpeHAsLZtZ1wPP/+OtifPjjkVArPdtCur8lPfm+hCdNOp/wJJj+qWyd8cqQ6tI+iiY1CBs3AYxF7h/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9IthlJlje0hIKAU2/Hr+KqsGD6QIn/LBUBYSqkKR1GE=;
 b=MartTMs5UtNSggYp8GRq3Y8XXleuH+l0Spb07l4unSBj77il9Bir4lJzmMUbSym5WDHrZxRvLhkRd0h3sGZx4tNWpyzdRyBdMpgtL6h6+A7qSTo5YElxSRPVICc4EOnwTQqHkSKe2F8MUhI7/PhXsEwovhPHuV/8I0vW+ymP3lrRz67bCEd7YxcXE6YN2ccnE5mGWHKW5P2C1A9e0t9h8FS8vsKcNHnELhWcZrDJ1R9qAbqmHtOJi6aeM10wNvftWOOc4zgNN4EbvR0RTzhg1l4AnLgtSQVQ4A0Jc+R08i4LRs5/qwnaucB6/Qgf7UIXsY2VuIxk62jh926m+mPvSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB5110.namprd15.prod.outlook.com (2603:10b6:806:1dd::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.23; Tue, 29 Mar
 2022 22:12:01 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::58c9:859d:dc03:3bb4]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::58c9:859d:dc03:3bb4%3]) with mapi id 15.20.5102.023; Tue, 29 Mar 2022
 22:12:01 +0000
From:   Song Liu <songliubraving@fb.com>
To:     "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "song@kernel.org" <song@kernel.org>, "hch@lst.de" <hch@lst.de>,
        "pmenzel@molgen.mpg.de" <pmenzel@molgen.mpg.de>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "iii@linux.ibm.com" <iii@linux.ibm.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "urezki@gmail.com" <urezki@gmail.com>,
        "npiggin@gmail.com" <npiggin@gmail.com>
Subject: Re: [PATCH v9 bpf-next 1/9] x86/Kconfig: select
 HAVE_ARCH_HUGE_VMALLOC with HAVE_ARCH_HUGE_VMAP
Thread-Topic: [PATCH v9 bpf-next 1/9] x86/Kconfig: select
 HAVE_ARCH_HUGE_VMALLOC with HAVE_ARCH_HUGE_VMAP
Thread-Index: AQHYGfmQYHpJmCxW+kSTgNf/KlCER6zRFs+AgASr4wCAAA5KgIAAh7mAgACsFYCAAAlnAIAAJ92AgAAKA4A=
Date:   Tue, 29 Mar 2022 22:12:00 +0000
Message-ID: <B96B8719-29B1-4D7F-9E00-E21A51DA148C@fb.com>
References: <20220204185742.271030-1-song@kernel.org>
 <20220204185742.271030-2-song@kernel.org>
 <5bd16e2c06a2df357400556c6ae01bb5d3c5c32a.camel@intel.com>
 <F079AC10-2677-41B4-A4D5-F07BDE512BE1@fb.com>
 <ee754770889c7b6de13d8e4835c7bd8b15d5e538.camel@intel.com>
 <6080EC28-E3FE-4B00-B94A-ED7EBA1F55ED@fb.com>
 <3ecfbf80feff3487cbb26b492375cef5a5fe8ac4.camel@intel.com>
 <C7D9C93E-AD07-4EF7-867F-7E66C630FC83@fb.com>
 <e05d99f4b8b8719f99e1de44dc26e94c9994c34b.camel@intel.com>
In-Reply-To: <e05d99f4b8b8719f99e1de44dc26e94c9994c34b.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.60.0.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f37c9cb5-9d30-4a12-7060-08da11d12606
x-ms-traffictypediagnostic: SA1PR15MB5110:EE_
x-microsoft-antispam-prvs: <SA1PR15MB5110ADFA045DDE924E7E489DB31E9@SA1PR15MB5110.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: I7nXflNDM3cZLKZdWah571N7Y9sd4SBPdnlUEgAwnDJJvF+RXWRP6ozWdicc2WrTHcmIw1dwJ5Fxf5GCEj/cUf6fW1usKvoDDcQsSfcfWqM4xKS6hrCltQ5jIcnn4l9/m8ZQhUkvjzgBY0ug/nLUPj+THKXif/39OcNLCqkRpWga3DLD5kWh6O1iuKWw7Gm0tUvPXCqOOxRFhNh6qrrmBWoePlEdi0s4tn3i7PjUV+Ufa/79cjripuK8joXDxWByzZ4DgxTamwUGSzVLssGpvEYVsAgrocY8MdjrGN9m56MpXCrAjRK5JmZGY8uWNC35TwUwuWTxio3EMqFKLn6IOfbBeUa0SPDUfdeIJ9IXXrpCVE/pI4owfoBB+YW4FV49Tr9uJ/Uqc+Z6Shtm7MYL4R5cD8pq8FiqywwL+66zgBDUkRt114BQchGM7024PVwgJYhc0J97k7hFhms9/pKDZAWpAchxjuC3lBe5mJJ0H4oiAHKuLV/Q4aRA+qvrcBumY0W+Ha++qSxbW1Wf/i8Ikebvu9XLdqRxVm0XHgTe0G3QxcKDimGwpcCBZlG+Kwx+oeVKUQeppOX1V5ojig0PThdVvlVVglYd82XRETFh/kRsAsa9FWPHdnSg0caBXzwEw0amyamfan0AjspsVaFmgKW3YbHRhuqbsOV8sx9A1Sx2VTji165Ur8PkSvk2X8lP3sOU0s0BVRUoH1FRxyYAaoUreJLPZPsuui+mEqPVpbYzinOXkdPwLMGMZ2Ua9kEY2SVfXPLl3K/Q2UxS1Y0uuw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2616005)(186003)(83380400001)(38100700002)(86362001)(122000001)(38070700005)(64756008)(76116006)(5660300002)(66556008)(66476007)(8936002)(36756003)(33656002)(316002)(66946007)(7416002)(8676002)(4326008)(91956017)(2906002)(6916009)(66446008)(53546011)(71200400001)(54906003)(6486002)(6506007)(508600001)(6512007)(14583001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?EQjRElffdbgPTTU8HRNAYdWrfZH+brLWZq4OGF4rPA7/ge8Mfvx1SOl7l8Rz?=
 =?us-ascii?Q?CcPz1ekxDyIlAkbcbfofgRTyyNYsd2FA7iyGxP7doNDP2mz9b3bTiAOkNiXv?=
 =?us-ascii?Q?fyZSXei77gZOsCmmgiwdeAfg9OLUAGGvhBybF4UI76AzdtU22JyImCACcUw3?=
 =?us-ascii?Q?YPZkqIvUq0ZR3ZiwPddT5sS7GmY+oj7cmv64aLPgd2lwRRF2s21F1rIOX3jb?=
 =?us-ascii?Q?umCDxiu8xD5bPz0E3tMPGLBV6pjVjMg3TWWdyDAUja+9tQpT5d/RovDr1bOR?=
 =?us-ascii?Q?9UE4Hy0Sbe/E7eVXD/xxo2H6wFM8vgHQ4JHBgnIi2blEGFTKGydJvGFjo/nV?=
 =?us-ascii?Q?VjzVp1ypk3kz4UpuRJhHzvzHo42LU/nFZcHmlCk9uL2AlcONWPHEsQUPkp+c?=
 =?us-ascii?Q?6FIFG4XOdXpLES2qYu3LkDOdM7SBHqJQ/hOwxbC+4UvkNhIkaunoChj2Rr37?=
 =?us-ascii?Q?qBDT74Yb0KwfNkKQJ+fClOkKfxAd3kww+ZS5g3lA7C/tBHDAFSO8PSU0iTfF?=
 =?us-ascii?Q?eS/8q7FevM1jyVKdIGz+FJmNmgr/vdiu8opG4Drk/AlaoBRy/VE09vwPdxEz?=
 =?us-ascii?Q?F9cOQZvBtyLS6/WrWL6qdhz13Oo/jQ8Rz8QYJqFV7wB53itiv9TMOHIbllHJ?=
 =?us-ascii?Q?KowwgGhb/Jmf6CfAz91KQGx4AH0lpKhW6kvjC9Y6HRZLsW6xsrcp9tiF1Ueu?=
 =?us-ascii?Q?QszvuQ00sWzpCEXMWcdPT3D7IwkSxV/zGOxNldEB1Q46woKoVH/dLim5pmxA?=
 =?us-ascii?Q?0v4p5rOlofp2TYByDIThdGfP5ypuLLaiC3h9cNQ2UpcSV7aZ5b1goUHEWSN+?=
 =?us-ascii?Q?0aTgMqZ43JcWoCit7Z3uhUJ3Arp/nwU2Ssob5yj7dgZmX0BQg6Qj/k8+PjWv?=
 =?us-ascii?Q?z1lV16FRqyGZhHLWe3A2gOo1VsrtnjzooweLG1kEtUwPyU2uALfsNMaj8v9y?=
 =?us-ascii?Q?La5AI1xe1b8InnmjjV8UKLYWpf1Y2wU6nhcJPKszM3rl1Z7hQQ4qZdpvvjA5?=
 =?us-ascii?Q?p6+50x/gahg/mZPyM+YaQ8L9L1BRJ9fRa4mzMDaikVggej2JuOLDmEu52kcV?=
 =?us-ascii?Q?MtxBjK9G/7b/OekZ9jyWqNtXwN/aaQT8g8cmMLCqnV8Y6Pm5em/bDpeDedkj?=
 =?us-ascii?Q?p1FrqnX78kLiCIhGUBrWqboTVnKZ7SWUMidjo9t9zes0MlRr0pbs/Uwazu5i?=
 =?us-ascii?Q?gxdm96vVqGWDPoInAXDamuU8i+sLH9H58G5IdYFjaIegTU/AXYo/vEpPmR1p?=
 =?us-ascii?Q?hUmX8nqvZTWKqAkd/7CaQNshXku41gm4+EJNImoeDCkkbt/RDhiaO7TipD7g?=
 =?us-ascii?Q?q37lsp8t63r6pqkdXbOL09vfC/WZ/fS+RSXL2bDsSzR5Ti4qb8i03syhGFQp?=
 =?us-ascii?Q?8sAjGylOLWdQyXrttlB6EZd1oLRWanqQBX3rERQy2kkLcr6W639+5y4tkFT2?=
 =?us-ascii?Q?am+5b9iS0D5W3hR6N6UMmkUGTJwdLf1tUVzruh1R4piQlnhCdl32lWpsbZKC?=
 =?us-ascii?Q?7KZXIEh7I0wTVkEmv2G66FYV0/tgewqne6smevLrOB5o6tkq1nN9m63nBy23?=
 =?us-ascii?Q?Lm40KJQZR/hoG1jq0f8Jfy5N/3aE77Kdjs03iUX+6c2hOzR0cb4HXBfmhctY?=
 =?us-ascii?Q?AfDDVr06yCfvyJgNC2VVfnw4ZWvA1CFp/imR76eu7shUizHG0XMw7TdRWw7c?=
 =?us-ascii?Q?Iyt2Z7tDd5C62L/1geb/2uRPhtFtXdn3NKTGFv/F3N0sKnEInsYURDKFycYa?=
 =?us-ascii?Q?7i9RHA+tT0eh6ASP7+aWpmOohgK0GpkantPH3SNxaiDE0+6g97zK?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4B66E817B9B3A348B3E8DF032D00097C@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f37c9cb5-9d30-4a12-7060-08da11d12606
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Mar 2022 22:12:00.9202
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 02DB4SG5a1xAFrW5TEFwcxllxdIeVjj28zdzr+Atf0ssntu/UkjVUxJrstTIdixLnJ7G7gTirpoQ+5EiNJHddA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5110
X-Proofpoint-GUID: F8CWms2IfBU6T36RzS5k6afTiGTGE2js
X-Proofpoint-ORIG-GUID: F8CWms2IfBU6T36RzS5k6afTiGTGE2js
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-29_10,2022-03-29_01,2022-02-23_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 29, 2022, at 2:36 PM, Edgecombe, Rick P <rick.p.edgecombe@intel.com> wrote:
> 
> On Tue, 2022-03-29 at 19:13 +0000, Song Liu wrote:
>>> 
>>> I don't think we should tie this to vmap_allow_huge by definition.
>>> Also, what it does is try 2MB pages for allocations larger than
>>> 2MB.
>>> For smaller allocations it doesn't try or "prefer" them.
>> 
>> How about something like:
>> 
>> #define VM_TRY_HUGE_VMAP        0x00001000      /* try PMD_SIZE
>> mapping if size-per-node >= PMD_SIZE */
> 
> Seems reasonable name. I don't know if "size-per-node >= PMD_SIZE" is
> going to be useful information. Maybe something like:
> 
> /* Allow for huge pages on HAVE_ARCH_HUGE_VMALLOC_FLAG arch's */

Sounds great. I updated the version based on this (below). I will split it
into two patches, I guess. 

@Paul, could you please test whether this version fixes the issue you were
seeing?

Thanks,
Song



diff --git a/arch/Kconfig b/arch/Kconfig
index 84bc1de02720..0fb2bd5fd1f8 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -858,6 +858,15 @@ config HAVE_ARCH_HUGE_VMALLOC
 	depends on HAVE_ARCH_HUGE_VMAP
 	bool
 
+#
+# HAVE_ARCH_HUGE_VMALLOC_FLAG allows users of __vmalloc_node_range to allocate
+# huge page without HAVE_ARCH_HUGE_VMALLOC. To allocate huge pages, the user
+# need to call __vmalloc_node_range with VM_TRY_HUGE_VMAP.
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
@@ -45,7 +45,7 @@ config FORCE_DYNAMIC_FTRACE
 	 in order to test the non static function tracing in the
 	 generic code, as other architectures still use it. But we
 	 only need to keep it around for x86_64. No need to keep it
-	 for x86_32. For x86_32, force DYNAMIC_FTRACE. 
+	 for x86_32. For x86_32, force DYNAMIC_FTRACE.
 #
 # Arch settings
 #
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
index 3b1df7da402d..a48d0690b66f 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -35,6 +35,11 @@ struct notifier_block;		/* in notifier.h */
 #define VM_DEFER_KMEMLEAK	0
 #endif
 
+#ifdef CONFIG_HAVE_ARCH_HUGE_VMALLOC_FLAG
+#define VM_TRY_HUGE_VMAP	0x00001000	/* Allow for huge pages on HAVE_ARCH_HUGE_VMALLOC_FLAG arch's */
+#else
+#define VM_TRY_HUGE_VMAP	0
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
index 13e9dbeeedf3..5659677b18f3 100644
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
+				    VM_DEFER_KMEMLEAK | VM_TRY_HUGE_VMAP,
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
index e163372d3967..179200bce285 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -46,7 +46,7 @@
 #include "internal.h"
 #include "pgalloc-track.h"
 
-#ifdef CONFIG_HAVE_ARCH_HUGE_VMAP
+#if (defined(CONFIG_HAVE_ARCH_HUGE_VMALLOC) || defined(CONFIG_HAVE_ARCH_HUGE_VMALLOC_FLAG))
 static unsigned int __ro_after_init ioremap_max_page_shift = BITS_PER_LONG - 1;
 
 static int __init set_nohugeiomap(char *str)
@@ -55,11 +55,11 @@ static int __init set_nohugeiomap(char *str)
 	return 0;
 }
 early_param("nohugeiomap", set_nohugeiomap);
-#else /* CONFIG_HAVE_ARCH_HUGE_VMAP */
+#else /* CONFIG_HAVE_ARCH_HUGE_VMAP || CONFIG_HAVE_ARCH_HUGE_VMALLOC_FLAG */
 static const unsigned int ioremap_max_page_shift = PAGE_SHIFT;
-#endif	/* CONFIG_HAVE_ARCH_HUGE_VMAP */
+#endif	/* CONFIG_HAVE_ARCH_HUGE_VMAP || CONFIG_HAVE_ARCH_HUGE_VMALLOC_FLAG*/
 
-#ifdef CONFIG_HAVE_ARCH_HUGE_VMALLOC
+#if (defined(CONFIG_HAVE_ARCH_HUGE_VMALLOC) || defined(CONFIG_HAVE_ARCH_HUGE_VMALLOC_FLAG))
 static bool __ro_after_init vmap_allow_huge = true;
 
 static int __init set_nohugevmalloc(char *str)
@@ -582,8 +582,9 @@ int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
 
 	WARN_ON(page_shift < PAGE_SHIFT);
 
-	if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC) ||
-			page_shift == PAGE_SHIFT)
+	if ((!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC) &&
+	     !IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC_FLAG)) ||
+	    (page_shift == PAGE_SHIFT))
 		return vmap_small_pages_range_noflush(addr, end, prot, pages);
 
 	for (i = 0; i < nr; i += 1U << (page_shift - PAGE_SHIFT)) {
@@ -2252,7 +2253,7 @@ static struct vm_struct *vmlist __initdata;
 
 static inline unsigned int vm_area_page_order(struct vm_struct *vm)
 {
-#ifdef CONFIG_HAVE_ARCH_HUGE_VMALLOC
+#if (defined(CONFIG_HAVE_ARCH_HUGE_VMALLOC) || defined(CONFIG_HAVE_ARCH_HUGE_VMALLOC_FLAG))
 	return vm->page_order;
 #else
 	return 0;
@@ -2261,7 +2262,7 @@ static inline unsigned int vm_area_page_order(struct vm_struct *vm)
 
 static inline void set_vm_area_page_order(struct vm_struct *vm, unsigned int order)
 {
-#ifdef CONFIG_HAVE_ARCH_HUGE_VMALLOC
+#if (defined(CONFIG_HAVE_ARCH_HUGE_VMALLOC) || defined(CONFIG_HAVE_ARCH_HUGE_VMALLOC_FLAG))
 	vm->page_order = order;
 #else
 	BUG_ON(order != 0);
@@ -3056,6 +3057,15 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 	return NULL;
 }
 
+static bool vmalloc_try_huge_page(unsigned long vm_flags)
+{
+	if (!vmap_allow_huge || (vm_flags & VM_NO_HUGE_VMAP))
+		return false;
+
+	/* VM_TRY_HUGE_VMAP only works for CONFIG_HAVE_ARCH_HUGE_VMALLOC_FLAG */
+	return vm_flags & VM_TRY_HUGE_VMAP;
+}
+
 /**
  * __vmalloc_node_range - allocate virtually contiguous memory
  * @size:		  allocation size
@@ -3106,7 +3116,7 @@ void *__vmalloc_node_range(unsigned long size, unsigned long align,
 		return NULL;
 	}
 
-	if (vmap_allow_huge && !(vm_flags & VM_NO_HUGE_VMAP)) {
+	if (vmalloc_try_huge_page(vm_flags)) {
 		unsigned long size_per_node;
 
 		/*
