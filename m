Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C43E44EFCC1
	for <lists+netdev@lfdr.de>; Sat,  2 Apr 2022 00:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352797AbiDAWX7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 18:23:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236004AbiDAWX5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 18:23:57 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95C8D1FD2D1;
        Fri,  1 Apr 2022 15:22:06 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 231LiNWZ008939;
        Fri, 1 Apr 2022 15:22:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=CSwGuyNlOfVhx3oR45AF+Ns/BVmACswQhOICLzHAzAs=;
 b=QFk80XA3m0B70o4SxTysPuaq4jHnDiP6jBYvH6nQH+j0uNJCUsnvEL4fi/JfxUkvonqo
 ytBxSaNOf7PM3wNzjS8WEZTeQnvGDZuAdZG8/ttVRb2Y4j8E/B4j++dqcmKMGhy5T6FJ
 XIRaoQUW8fF8AcOlWSSUxz9rTSgvQtCMvDs= 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3f5gpf22t8-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Apr 2022 15:22:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WFOALSiaCP7BJN/jiFSEO+N1maDnBF3K56V3SyqrXwnRK4QrPmXLCpaT0cURMMyTVYw4/PpIAeD0sLslMmV3eTgKEVQ3xsf9OtKgVjoWawJaOmqgYt6xzsSnPW6kbYto7+Alc2oyl/McdVc3QGRb/ZaQ8zvXjergRiBt7HVqsu4pKanOKRRo3C+CdcSYqZtNhe+YDJXrQuqy/nk+/gl52x4UtkgpqBktyU0sFGFtMzuobSXuuVGhhtGo2DC/UD/XsG8MSw4RDh3qW2Sm0TRdlg2AIyutEaEvYbNdDEBOaKHY+IlI1oxpi2YuDHwyCkmMwzZOgat6Ph9vqbI4KEtKLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CSwGuyNlOfVhx3oR45AF+Ns/BVmACswQhOICLzHAzAs=;
 b=iR7w8m+mSSJOKCT3l7quHPY/hQ68LxirP3GZ8V1ztA+yv4OUVh4NeBp6nBoQKDRBVkKTTRr/sTLyYJmSJo3Zr2BZ7ORYqc2QRx25jCAuAHit4B4IDeI7Qi/h8BDBtyfAcCfcDytfV7QP/yfrTN9XULlsvC1XMldfs7YzzT0w8U+vLqlxkthPvDgORduBFUzi2EWNJL+SrLrvNelGY0QxTAXNVOaRopQTLTxvla9WgVLDPs6B5Uu+AsfWLaTEgolrRf/z6meJIwatRWIdD00QHm5MBPg1L5+84MMX9nAXsszxDntgyvWcMXRBbZevnrJ7yRpnv7deZVIkjdDDYVnyow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from PH0PR15MB5117.namprd15.prod.outlook.com (2603:10b6:510:c4::8)
 by BYAPR15MB3078.namprd15.prod.outlook.com (2603:10b6:a03:fe::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.29; Fri, 1 Apr
 2022 22:22:02 +0000
Received: from PH0PR15MB5117.namprd15.prod.outlook.com
 ([fe80::e487:483c:b214:c999]) by PH0PR15MB5117.namprd15.prod.outlook.com
 ([fe80::e487:483c:b214:c999%3]) with mapi id 15.20.5123.026; Fri, 1 Apr 2022
 22:22:00 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Christoph Hellwig <hch@infradead.org>,
        "rick.p.edgecombe@intel.com" <rick.p.edgecombe@intel.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
CC:     Song Liu <song@kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "pmenzel@molgen.mpg.de" <pmenzel@molgen.mpg.de>
Subject: Re: [PATCH bpf 0/4] introduce HAVE_ARCH_HUGE_VMALLOC_FLAG for
 bpf_prog_pack
Thread-Topic: [PATCH bpf 0/4] introduce HAVE_ARCH_HUGE_VMALLOC_FLAG for
 bpf_prog_pack
Thread-Index: AQHYRIo6ffSmNDMip0KdC6K8yX1qc6zY+Z8AgAE0IQCAAXb7AA==
Date:   Fri, 1 Apr 2022 22:22:00 +0000
Message-ID: <6AA91984-7DF3-4820-91DF-DD6CA251B638@fb.com>
References: <20220330225642.1163897-1-song@kernel.org>
 <YkU+ADIeWACbgFNA@infradead.org>
 <F3447905-8D42-46C0-B324-988A0E4E52E7@fb.com>
In-Reply-To: <F3447905-8D42-46C0-B324-988A0E4E52E7@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.80.82.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7487b96b-0b9d-40dd-e58c-08da142e0acb
x-ms-traffictypediagnostic: BYAPR15MB3078:EE_
x-microsoft-antispam-prvs: <BYAPR15MB3078EFDA407B6B1CCB64AB37B3E09@BYAPR15MB3078.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KP8do39+gGHB+TNqOgbbDhSipNfnPekOgSg0HXIlA6LsjVL0VHiqvGTGiR/xO/MI3ErFeEZzgISxsbSnC2kGcrhFwWucGI0kNvD38rafaBck6EUlZWbxwJD6OKbR+xNtlzxocWRjsAQ0IO2z/hQ4eBTcYOv162dwAcE6lqaVFUfRsyAEJptn7bTDFP9hGrS7RpjCLnMiLtekL/2G+awofG98uvr/G9VerDjcce5NFl1zK2l3dJWV6Q0FJU8hz6ZG+9UBiZtm5yA+oUrONVJvj1lX/cfkWpR/soo9txJMoig2NQWXApX6ZADRNUpdDenRWU0tizGbiS3TMfrrj9AcYRrzoIkHCaNzLuNm95jCYQ2ZW0NRDGIgOXQqQn2RjILtGlMjwfgi+N+IDlXtyS6a8t8333jyjmlTzXAZvy8PLMXgxt2ihORMj0aK93hHxCP2jcAm9tk/xA1e9mNMa66UM6qOQgn2FzZIsf85m9x3kOcjtnI6PjCjY+RNA/mcCSfnKDmxkdxlLPhvz65MYKK96zNT/sXOwD13x+TIbKMuXRHbhqH4czfNxKRZlmFsjTWWkcZDOjIxfJcLXgiMXFVu1Tz3hPpqcMzSr61igW+5qEaEwN9mlG8e89a8GG02n9KFa628CsMUKxe3FndRH+tHWHcyJx5S462HoK9fH12pTgquA75QC6fx5FJEyDpr9VyIETc2mS0Nx/gCJQL+mDL7MP0vbQOvVXwUcUHFQPFHNSvh2E9CA2kAtPOOGrNLalCijbzoM9cVbCF6KHEuYpl1dA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR15MB5117.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(71200400001)(38100700002)(508600001)(45080400002)(2906002)(6486002)(122000001)(86362001)(110136005)(4326008)(76116006)(66476007)(8676002)(66556008)(66446008)(64756008)(66946007)(8936002)(38070700005)(54906003)(5660300002)(83380400001)(7416002)(316002)(33656002)(36756003)(6512007)(2616005)(6506007)(53546011)(186003)(14583001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?g8/q9cMnyK6vfBt7FKWUcRRl3vybOyZF/h3OD47scsKKoCMl/04fmsmvOovg?=
 =?us-ascii?Q?pwVq2XJ/F5rq6mT7SAIg2bbBbaRiknue0AaG+6qn2dbXMn8KXK+cDz+R/Vzi?=
 =?us-ascii?Q?kgOs+KlJUWjE/nIJgvljIlQcHuuiqMvAFqWAQILAM4sMTB/fOh8NGhn1PmHJ?=
 =?us-ascii?Q?hsq2FwoIwqkI8eeWA3nCzt4ncWvC5YJBxFRbk9xIOtygn0VOoHx9RV+D/EG/?=
 =?us-ascii?Q?IJK8xaJz2B3vfs2XIM8zkOu1TL4R4WHlBCIxo252O5pDTe9I4aYNA6IvWjtC?=
 =?us-ascii?Q?ePXjsXbCzWNf5Cbral08icP/Gt5Z+9WvewGT66h3TxCuX1vC+KUFS3fzUske?=
 =?us-ascii?Q?N+o+n7Xm3DKriQy/Su1n825iS/R65t5e43Y8s8DXB9bzlcikULjrcerZc7LP?=
 =?us-ascii?Q?duut1/wWOGg6zteWKf/hoPC1LXfDIAAYtGAm8+36BKg99F0/Hzn0wnA77wpx?=
 =?us-ascii?Q?reCVbMkyEqK7eNSzSpabt48BwM6ncYiCRZ+dQf8ZRdh05T8TsTHtEFLyrdgh?=
 =?us-ascii?Q?UsLOkYWDIqZ7PGJG9xydYWQl2RPU7zYuxKXkJMw/fDGA2Z9rGmFA5GbMKSFC?=
 =?us-ascii?Q?mqj52RweZ1+nGhrfV9tIcch636QtGGN4wInULzfCSVovK/gfcKhpgl/usIXh?=
 =?us-ascii?Q?G+COl0o6w9+hefKNYeGQU9bug6xgpQ1BXxtMzwYHr7e9BxWdHjubSd4+9LXP?=
 =?us-ascii?Q?QDfREV9SM4oOeWrzsAM+d1WYTsWDvMz0MUBe+qfvWSJRy6gkN624C0l3eXMZ?=
 =?us-ascii?Q?IV7uZsGRk3gvPWRdW/ti1a5LI3rVOeAnxfrths/YGVeyTKgQpOqfxyuCgDpW?=
 =?us-ascii?Q?Rkr77jJoN/s3L9nWybTgw1mN7pHW6wr86fTcZJ/+BKesqTLeP2uSEndojf8s?=
 =?us-ascii?Q?bbWMc/IPb3nP7k6hR36tC1tM9uyndfJWBptMZtiYTcFRA5A/5Q8QyodvZWbF?=
 =?us-ascii?Q?QDaCuKV8cG2t6PB/BK2Hr7AhPc88bfzhu0awgmcWbuB/p+d8vmbN6C00lQ7c?=
 =?us-ascii?Q?F0Qa0pnLWKKKPDqSKYYRtDcR9ne3EzNqCW4c77tHcJdiG5xLkJnKASta6l3B?=
 =?us-ascii?Q?yEJ86cFTXfkEass9XE23n2uxJYOqILey3kDpxlROcUv46EC32oRRpApjuJC7?=
 =?us-ascii?Q?eFFAdoN4tAG3jLA78M6ydaPGh8ZK/Tgy3BC70biQkvyduTJmT2Laop/hw9Ed?=
 =?us-ascii?Q?mUfiemWfMSIiTF7Y5GEuVE1wRiyRdQx4ff69dIqOFI33BnAAJ/S7yquFcHWT?=
 =?us-ascii?Q?DDrc8XiPNwdyWoIa134vBykXr2M4QPa8GHB2mOZO/EFE0NVXvLhZ/zsTLFto?=
 =?us-ascii?Q?sFRb24+E7AO+Ipnv35hlpOBwUFiYGC3gZAowF66khtp/Pur7y3XpUeNAnSut?=
 =?us-ascii?Q?Py9mIrgiDQ3MlsL777RwPZlY7eFjpSq/WLLb48ME9r7snfm7ZZK+H+BDE110?=
 =?us-ascii?Q?DAYB+Fa/3QHAkqkVP5uTEEK+Rm1PCUeUe1i0xIgusn/osxl6XPVNc83Qnsb+?=
 =?us-ascii?Q?HYiDpTdCsj7lRe/MR0srjVjA2Pdu/x3xFuTYj5hZ+Jsg+t1u55fRW3faN0fC?=
 =?us-ascii?Q?ckqYMvOcqq1o2jPKU+RiSt/q+nGCEJFHibp664ZxgWQqeUirFCZyI/W4XezV?=
 =?us-ascii?Q?e/2wAdQIumgBayUzQvabS7ekjyzOFQ1MqYOMi9knIlAXSgWU0/uIr84AIXPh?=
 =?us-ascii?Q?i6Fj7XBmb8mJWsXoOqIobrLOWL1ZqpNdf2tm3yZG88giTucTZviz6K+DW4y3?=
 =?us-ascii?Q?DMwq36ajZNqBPQCpA0kyvOtjZD8XbV1WH1BuVpbi4fLp7j1XGRIV?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A9801FFB5D2C874BB22819CCF286EFCD@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR15MB5117.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7487b96b-0b9d-40dd-e58c-08da142e0acb
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Apr 2022 22:22:00.7751
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zGFC4es0bva4tVEmqkdpML3mc0V/a2huzPlj4cH8DncULIT7k2Mnmjn6R1P6Y9lCYhIooAxZtkICdfU27DkbPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3078
X-Proofpoint-ORIG-GUID: OcV5bG9FMVYMJrHMFujyMiiIA3lx4BIu
X-Proofpoint-GUID: OcV5bG9FMVYMJrHMFujyMiiIA3lx4BIu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-01_07,2022-03-31_01,2022-02-23_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+ Nicholas and Claudio,


> On Mar 31, 2022, at 4:59 PM, Song Liu <songliubraving@fb.com> wrote:
> 
> Hi Christoph, 
> 
>> On Mar 30, 2022, at 10:37 PM, Christoph Hellwig <hch@infradead.org> wrote:
>> 
>> On Wed, Mar 30, 2022 at 03:56:38PM -0700, Song Liu wrote:
>>> We prematurely enabled HAVE_ARCH_HUGE_VMALLOC for x86_64, which could cause
>>> issues [1], [2].
>>> 
>> 
>> Please fix the underlying issues instead of papering over them and
>> creating a huge maintainance burden for others.

After reading the code a little more, I wonder what would be best strategy. 
IIUC, most of the kernel is not ready for huge page backed vmalloc memory.
For example, all the module_alloc cannot work with huge pages at the moment.
And the error Paul Menzel reported in drm_fb_helper.c will probably hit 
powerpc with 5.17 kernel as-is? (trace attached below) 

Right now, we have VM_NO_HUGE_VMAP to let a user to opt out of huge pages. 
However, given there are so many users of vmalloc, vzalloc, etc., we 
probably do need a flag for the user to opt-in? 

Does this make sense? Any recommendations are really appreciated. 

Thanks,
Song 




[    1.687983] BUG: Bad page state in process systemd-udevd  pfn:102e03
[    1.687992] fbcon: Taking over console
[    1.688007] page:(____ptrval____) refcount:0 mapcount:0 mapping:0000000000000000 index:0x3 pfn:0x102e03
[    1.688011] head:(____ptrval____) order:9 compound_mapcount:0 compound_pincount:0
[    1.688013] flags: 0x2fffc000010000(head|node=0|zone=2|lastcpupid=0x3fff)
[    1.688018] raw: 002fffc000000000 ffffe815040b8001 ffffe815040b80c8 0000000000000000
[    1.688020] raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
[    1.688022] head: 002fffc000010000 0000000000000000 dead000000000122 0000000000000000
[    1.688023] head: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
[    1.688024] page dumped because: corrupted mapping in tail page
[    1.688025] Modules linked in: r8169(+) k10temp snd_pcm(+) xhci_hcd snd_timer realtek ohci_hcd ehci_pci(+) i2c_piix4 ehci_hcd radeon(+) snd sg drm_ttm_helper ttm soundcore coreboot_table acpi_cpufreq fuse ipv6 autofs4
[    1.688045] CPU: 1 PID: 151 Comm: systemd-udevd Not tainted 5.16.0-11615-gfac54e2bfb5b #319
[    1.688048] Hardware name: ASUS F2A85-M_PRO/F2A85-M_PRO, BIOS 4.16-337-gb87986e67b 03/25/2022
[    1.688050] Call Trace:
[    1.688051]  <TASK>
[    1.688053]  dump_stack_lvl+0x34/0x44
[    1.688059]  bad_page.cold+0x63/0x94
[    1.688063]  free_tail_pages_check+0xd1/0x110
[    1.688067]  ? _raw_spin_lock+0x13/0x30
[    1.688071]  free_pcp_prepare+0x251/0x2e0
[    1.688075]  free_unref_page+0x1d/0x110
[    1.688078]  __vunmap+0x28a/0x380
[    1.688082]  drm_fbdev_cleanup+0x5f/0xb0
[    1.688085]  drm_fbdev_fb_destroy+0x15/0x30
[    1.688087]  unregister_framebuffer+0x1d/0x30
[    1.688091]  drm_client_dev_unregister+0x69/0xe0
[    1.688095]  drm_dev_unregister+0x2e/0x80
[    1.688098]  drm_dev_unplug+0x21/0x40
[    1.688100]  simpledrm_remove+0x11/0x20
[    1.688103]  platform_remove+0x1f/0x40
[    1.688106]  __device_release_driver+0x17a/0x240
[    1.688109]  device_release_driver+0x24/0x30
[    1.688112]  bus_remove_device+0xd8/0x140
[    1.688115]  device_del+0x18b/0x3f0
[    1.688118]  ? _raw_spin_unlock_irqrestore+0x1b/0x30
[    1.688121]  ? try_to_wake_up+0x94/0x5b0
[    1.688124]  platform_device_del.part.0+0x13/0x70
[    1.688127]  platform_device_unregister+0x1c/0x30
[    1.688130]  drm_aperture_detach_drivers+0xa1/0xd0
[    1.688134]  drm_aperture_remove_conflicting_pci_framebuffers+0x3f/0x60
[    1.688137]  radeon_pci_probe+0x54/0xf0 [radeon]
[    1.688212]  local_pci_probe+0x45/0x80
[    1.688216]  ? pci_match_device+0xd7/0x130
[    1.688219]  pci_device_probe+0xc2/0x1d0
[    1.688223]  really_probe+0x1f5/0x3d0
[    1.688226]  __driver_probe_device+0xfe/0x180
[    1.688229]  driver_probe_device+0x1e/0x90
[    1.688232]  __driver_attach+0xc0/0x1c0
[    1.688235]  ? __device_attach_driver+0xe0/0xe0
[    1.688237]  ? __device_attach_driver+0xe0/0xe0
[    1.688239]  bus_for_each_dev+0x78/0xc0
[    1.688242]  bus_add_driver+0x149/0x1e0
[    1.688245]  driver_register+0x8f/0xe0
[    1.688248]  ? 0xffffffffc051d000
[    1.688250]  do_one_initcall+0x44/0x200
[    1.688254]  ? kmem_cache_alloc_trace+0x170/0x2c0
[    1.688257]  do_init_module+0x5c/0x260
[    1.688262]  __do_sys_finit_module+0xb4/0x120
[    1.688266]  __do_fast_syscall_32+0x6b/0xe0
[    1.688270]  do_fast_syscall_32+0x2f/0x70
[    1.688272]  entry_SYSCALL_compat_after_hwframe+0x45/0x4d
[    1.688275] RIP: 0023:0xf7e51549
[    1.688278] Code: 03 74 c0 01 10 05 03 74 b8 01 10 06 03 74 b4 01 10 07 03 74 b0 01 10 08 03 74 d8 01 00 00 00 00 00 51 52 55 89 cd 0f 05 cd 80 <5d> 5a 59 c3 90 90 90 90 8d b4 26 00 00 00 00 8d b4 26 00 00 00 00
[    1.688281] RSP: 002b:00000000ffa1666c EFLAGS: 00200292 ORIG_RAX: 000000000000015e
[    1.688285] RAX: ffffffffffffffda RBX: 0000000000000010 RCX: 00000000f7e30e09
[    1.688287] RDX: 0000000000000000 RSI: 00000000f9a705d0 RDI: 00000000f9a6f6a0
[    1.688288] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
[    1.688290] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[    1.688291] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[    1.688294]  </TASK>
[    1.688355] Disabling lock debugging due to kernel taint
