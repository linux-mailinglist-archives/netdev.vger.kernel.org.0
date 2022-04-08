Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6B734F9F1F
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 23:23:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239748AbiDHVZr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 17:25:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233408AbiDHVZq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 17:25:46 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CBB51929A;
        Fri,  8 Apr 2022 14:23:41 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 238LNdo3014024;
        Fri, 8 Apr 2022 14:23:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=y9YT/TyDa5ygZ5VJS7MlGZa94TQEzRvHFm1tt30RrDs=;
 b=FB5QT5xX24D6IqZMuyFT5OEprhRUWRuereDwV2nlLs+Sxfrhp8njkbJM7E+DxwHw148L
 /bpLUEcfYT47Or9dWtTksH9PM8gJHecP1oZ2zIhiqECVM8Cqq++AacK4ubln+6A5nVYB
 Wgx16QtHrf/VpCJ6ln6nmJ25jZiVvHe0jbQ= 
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2170.outbound.protection.outlook.com [104.47.73.170])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fankkbj6e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Apr 2022 14:23:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f5KGEFdm4x8gkOq1gH8JdqGSXdh9P0+sRWOArBDRdNttk6EOS7zIoqHyLf2BtXbCWQ8umXeGhy/gxOdQ2IXBGOHKBMCUadtjVS7WKuKP8TfMoOmoPPsWPq0TMUtp/7Q/TFwfQnF1q3CKuTs+lM4wtQhpKFGizsFAs6LqOnomSkT9LSMm9ZWxYoUAr10RSBurqul+ICZ0ruyhZ4fpmNc2lWe6SiFqBEPV7uHNHt6LpgJMEMcTlrb0qEPlhc40JOEntN4dyBEZi46o7houwqNNZAUGqIv94UGN1vBTKmWAPbbCqzSbH1SGXDhDyRDCw392fgsw4zvVAAF9j7uhUE4vhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y9YT/TyDa5ygZ5VJS7MlGZa94TQEzRvHFm1tt30RrDs=;
 b=kD4F0LUEX3nZccU9qv9mQwfG98bsIjWp711QDuHm6FVK2zSmi2wuLZtaiXvqrZFFg622KlA0W+eIalQATeIQCIq3pvNXq8CPtD0IVFviB7A0o9oR9GWxs5S7z3a7UbyGM+nLyhytMowgK2FZCKbHBHy/cknhYUJAtb7sGOzP47XLpd8s4mIwu4U6eFKWgZvaPpu9VJLDJFzck8qfXx3+hUP0EsW1scOQty5Q5cvde1fL5TfHqRysRTIRVl1aRqGTQ258SIk0YjpbXAJXhuk0O1oNL/KWK2ouT2q8KrpAzUpr3P6gsrQPhMH2sApIxExucPi6NB9tRNdA/5SB7G8lJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by BN7PR15MB2484.namprd15.prod.outlook.com (2603:10b6:406:91::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.22; Fri, 8 Apr
 2022 21:22:48 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::e150:276a:b882:dda7]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::e150:276a:b882:dda7%8]) with mapi id 15.20.5144.022; Fri, 8 Apr 2022
 21:22:48 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
CC:     Christoph Hellwig <hch@infradead.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        "rick.p.edgecombe@intel.com" <rick.p.edgecombe@intel.com>,
        Song Liu <song@kernel.org>,
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
Thread-Index: AQHYRIo6ffSmNDMip0KdC6K8yX1qc6zY+Z8AgAE0IQCAAXb7AIAFSdYAgAEZXACAAuJiAIAA7c+AgAC8Y4A=
Date:   Fri, 8 Apr 2022 21:22:47 +0000
Message-ID: <3D4CC64A-1852-45B3-BA35-17EAD2504447@fb.com>
References: <20220330225642.1163897-1-song@kernel.org>
 <YkU+ADIeWACbgFNA@infradead.org>
 <F3447905-8D42-46C0-B324-988A0E4E52E7@fb.com>
 <6AA91984-7DF3-4820-91DF-DD6CA251B638@fb.com>
 <YkvqtvNFtzDNkEhy@infradead.org>
 <482D450C-9006-4979-8736-A9F1B47246E4@fb.com>
 <16491AB0-7FFD-40F5-A331-65B68F548A3B@fb.com>
 <20220408120831.69b80310@p-imbrenda>
In-Reply-To: <20220408120831.69b80310@p-imbrenda>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.80.82.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 89681cfb-b2ba-4518-e7b0-08da19a5ee12
x-ms-traffictypediagnostic: BN7PR15MB2484:EE_
x-microsoft-antispam-prvs: <BN7PR15MB248483CF0C9F726AE0FE8587B3E99@BN7PR15MB2484.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pPJyLRjVLj8gy/36sBq/fJSyfxKCOTtjQZsnAWPauvSJCzY716sytvq5FLawzUTpwDIDZlT+Jo3MurLIKz9CNR9bS/m8BaEzZNxC77Br/Lb5EUQ64Bid5bJMCbK2uNUJSL/IutLWndkLaFARxJ1I3OAzZHLvUsYI+whoVfnaBWWyS4SwddbzFDQfa5cEZVbIRqLPOLDPhufa/JEIVgHp6vyMW7RnFzQDYWNIYO6jpmp+9npW56IM0EPjPKLjbKp0tv352JXLXtAnJp0bR+YCIvUDqgy/mbA44dSWjiElbPp5D72/aLNPF6eJe567VRMsnYUFTvZ7MVGeTL6ZLOBediUT5DXuS2a/gdqzu4Vl2DVCxBK27NGH7t0rSAIZ9CgBCQgjF9MZLbmCpbx60X7XPW6BPdvuFRD75V0fr/4OxQW0volTDhPD9Ht+pOy1ol5WpirMVbFVTzxrtFXo+tJVAUWP2ti8iODFhrXcX9soS2Z/wkPfQhI/uAVDVsjqXS5LvsQ6UHouTuTjKueD6PhrN3ntlelpM8akQiEcHSvxQm15CSV7yojZc3unzNvtanuH/RUkCd0SbXKtoggqXP69o3771CvXm5/D5nVta3EQh796bEFJfrLL04c542yL4FSZbrquk7pINChY2wZicpJVvfEP7E7CS/YlZlZfWPrCMtLwqKc011ZNIUsDSOB6SETU+AlLbneSn0RbIXUd1Sm6UjcSXSR+xTqrDYbscvEGeefDGW5o/OHaacvlKkCRMREh7qQVphHyelmJoj2s1/Ad5A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(33656002)(71200400001)(2616005)(36756003)(186003)(7416002)(6916009)(54906003)(508600001)(53546011)(6506007)(6486002)(6512007)(316002)(83380400001)(8936002)(66556008)(38100700002)(122000001)(2906002)(66946007)(76116006)(8676002)(66476007)(66446008)(4326008)(64756008)(86362001)(5660300002)(91956017)(38070700005)(14583001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?J9p6lJ+WvZb25IuYSRsvsmZ6zDx3cc3v+/rqRKPY5ZRuO+a69FVuFcimN+tE?=
 =?us-ascii?Q?9EBHHnErajlpiV07TaIlySWV+/FaA8eyyZ0PFm5S/rGcOdhgEfyGTyj4DWrv?=
 =?us-ascii?Q?oQHSocPzASHrcG3EUEnrFe2Gc7kXqZhLeYufoIH5oQBdDFVfsS36CtPZvEu6?=
 =?us-ascii?Q?ge23oU8+Om27acl5LjAjF2sZfDplSLbwTkYzWBKkwBmTwZ4yNh70ogXgHK6Q?=
 =?us-ascii?Q?nJu1bi5fcnGFtRww2SPa4GutjPOCiXP9rlnBF/o2nnTwCw340gFdhOedo6QW?=
 =?us-ascii?Q?sb5vdTrBOXvFkUmh2xGNjUOt8mg16AxMJGEn6eECiY3i/QqUb/1O1we1roKL?=
 =?us-ascii?Q?PAbvpwVgq/02Bcm7572wSQZ19aBxzcr+Lhgcxw85JyAFZY+aENpJh8KKXf3O?=
 =?us-ascii?Q?mPu5GQhGXtqpygr+kDS9nkgC1RfxS0MlLnlA5HtDsqA3qqD6eIxUvjM0CBBo?=
 =?us-ascii?Q?24VPrWEwJb2vlETlRyYDIlJgeP9xuVEqOlMyu+nXuiwJg+b9dWyBEttGBvDI?=
 =?us-ascii?Q?oSAzSTP/hJ/JHjA1DL752R79xtD+QHVq5SDJOF+W7CYRVpHm3BY7yzcBq2Ak?=
 =?us-ascii?Q?8DAv2t0E2dU8bGyGZ+Mr3ijP+/dZFndupXddcOoXQc1bcOj6zSEgrzzQz2bY?=
 =?us-ascii?Q?/5xvrMEIPwlbsGEWFS3J2FQvKVwFVFzphgXrEH1wYkUA0QTT7ZtCHHZAHEm3?=
 =?us-ascii?Q?Y304XRUC7tomNbRG3i54p4ah54qD+/vTEPPPdNDDIs/V7eUXQRHL/UPYSblG?=
 =?us-ascii?Q?V7xYnk714yhCLTRsVXO/LF7S30hX4YB1sqp8OCrwEXqiGxIqJM8n3w0nsRy/?=
 =?us-ascii?Q?cVkb27QeIkjkw3nLybjDFUJ241uXeL0IJ0k4QEcAOqLdAwCN2LaTI0O3oaZb?=
 =?us-ascii?Q?CSvJHWLjbTJ3fFRpAIrMki2nlVzY2osgzfUE7gynctfv9W2WDD0l1Oie2z3n?=
 =?us-ascii?Q?/T6pLoi66m7bYl1OpwIPySuq2cuCCnfvqPOWoi3q66Cd4zxYlbgDpbnYUu5n?=
 =?us-ascii?Q?CYEWwyZvsB2QIhkC5RQFBhCA1Y96wpjHzIEnKKc1647A9BEO43G/Gy72e4Z+?=
 =?us-ascii?Q?FRxnAD0BBae/LFmeInP082BEAeCmFAiK4vPXduTBRjhTC7AthKly/cTzpdDS?=
 =?us-ascii?Q?g8u8IQLy3jgQjqpeAUJdZT0PnmKETu5Ni4tacTa4dHMqiIocuk0cSkm9frGu?=
 =?us-ascii?Q?66Zl8xe/uSkAW8f63IbKLTexlFuk9O5dyxd4id9H2oUVoDSx1rpeZ+tZY2VF?=
 =?us-ascii?Q?/a9NCrhSIqNCmrb3EhCFW8fix8h+yQKwbA9ZYwuF6iYfc1P/dDU9mL/7IDXg?=
 =?us-ascii?Q?7fHuY7EQe40tDhVYUudh6EIOfvRDFw72vMVjehzpQOuBQWdMgTyI54Sg438r?=
 =?us-ascii?Q?FFCEcBVhNKT6wzwjkmxTr6OnXxhGJDCo0s5qOY6UZISXu1YwpN5vLr4Wj+bs?=
 =?us-ascii?Q?koYiUobrVNLr/tsvqaJ7NzUm6/aqcQtju/+bNSmbEGceDwFBvwl1XjRUDZjn?=
 =?us-ascii?Q?Y9TNOcm34miqKErjHD52uyZ9g+TpGtrT3DedoXdIvBbMZC7SDWBLukHAthDe?=
 =?us-ascii?Q?3hFscD/ZjwdLgNFP9JdSa/+PLeXLOEzgMr2FRnNPCcruoXwIl9aTRsC+Dhq1?=
 =?us-ascii?Q?39d0Q5pxOidd2hLySBw5G1zJ1s/9KLIJGVIcGkLxOwXIdbt2uslU2pcES5eO?=
 =?us-ascii?Q?PAstorq5I08nNO41BqQkJzmeS/I47mamWkJP2hZ71SU5JznE0+6hzD/7iJ+u?=
 =?us-ascii?Q?TlGml3ItHxcXD1uCrFFWhnE1lHTfBXC/OZoWH84exDBZ13RhUxrY?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3E81E0D7EA37F8409C9B918695414843@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89681cfb-b2ba-4518-e7b0-08da19a5ee12
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2022 21:22:48.0080
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4QZrejDQEnpe4wtpeVUlr7Hz9djQvSD+qjgoNGT5zUkqp0BmODUox5sXDuzoxydITNAO8NKBxk18zZWN0cqK/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR15MB2484
X-Proofpoint-ORIG-GUID: F7nVD3wOB-uS7LGP9AVmJ84RyCwwH80h
X-Proofpoint-GUID: F7nVD3wOB-uS7LGP9AVmJ84RyCwwH80h
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-08_08,2022-04-08_01,2022-02-23_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Apr 8, 2022, at 3:08 AM, Claudio Imbrenda <imbrenda@linux.ibm.com> wrote:
> 
> On Thu, 7 Apr 2022 19:57:25 +0000
> Song Liu <songliubraving@fb.com> wrote:
> 
>> Hi Nicholas and Claudio, 
>> 
>>> On Apr 5, 2022, at 4:54 PM, Song Liu <songliubraving@fb.com> wrote:
>>> 
>>>> On Apr 5, 2022, at 12:07 AM, Christoph Hellwig <hch@infradead.org> wrote:
>>>> 
>>>> On Fri, Apr 01, 2022 at 10:22:00PM +0000, Song Liu wrote:  
>>>>>>> Please fix the underlying issues instead of papering over them and
>>>>>>> creating a huge maintainance burden for others.  
>>>>> 
>>>>> After reading the code a little more, I wonder what would be best strategy. 
>>>>> IIUC, most of the kernel is not ready for huge page backed vmalloc memory.
>>>>> For example, all the module_alloc cannot work with huge pages at the moment.
>>>>> And the error Paul Menzel reported in drm_fb_helper.c will probably hit 
>>>>> powerpc with 5.17 kernel as-is? (trace attached below) 
>>>>> 
>>>>> Right now, we have VM_NO_HUGE_VMAP to let a user to opt out of huge pages. 
>>>>> However, given there are so many users of vmalloc, vzalloc, etc., we 
>>>>> probably do need a flag for the user to opt-in? 
>>>>> 
>>>>> Does this make sense? Any recommendations are really appreciated.   
>>>> 
>>>> I think there is multiple aspects here:
>>>> 
>>>> - if we think that the kernel is not ready for hugepage backed vmalloc
>>>> in general we need to disable it in powerpc for now.  
>>> 
>>> Nicholas and Claudio, 
>>> 
>>> What do you think about the status of hugepage backed vmalloc on powerpc? 
>>> I found module_alloc and kvm_s390_pv_alloc_vm() opt-out of huge pages.
>>> But I am not aware of users that benefit from huge pages (except vfs hash,
>>> which was mentioned in 8abddd968a30). Does an opt-in flag (instead of 
>>> current opt-out flag, VM_NO_HUGE_VMAP) make sense to you?   
>> 
>> Could you please share your comments on this? Specifically, does it make 
>> sense to replace VM_NO_HUGE_VMAP with an opt-in flag? If we think current
>> opt-out flag is better approach, what would be the best practice to find 
>> all the cases to opt-out?
> 
> An opt in flag would surely make sense, and it would be more backwards
> compatible with existing code. That way each user can decide whether to
> fix the code to allow for hugepages, if possible at all. For example,
> the case you mentioned for s390 (kvm_s390_pv_alloc_vm) would not be
> fixable, because of a hardware limitation (the whole area _must_ be
> mapped with 4k pages)
> 
> If the consensus were to keep the current opt-put, then I guess each
> user would have to check each usage of vmalloc and similar, and see if
> anything breaks. To be honest, I think an opt-out would only be
> possible after having the opt-in for a (long) while, when most users
> would have fixed their code.
> 
> In short, I fully support opt-in.

Thanks Claudio!

I will prepare patches to replace VM_NO_HUGE_VMAP with an opt-in flag, 
and use the new flag in BPF. Please let me know any comments/suggestions
ont this direction. 

Song

