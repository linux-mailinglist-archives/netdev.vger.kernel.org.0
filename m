Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9771F41CD22
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 22:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345976AbhI2UGu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 16:06:50 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:21770 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343734AbhI2UGt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 16:06:49 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18THeZ1w024139;
        Wed, 29 Sep 2021 13:05:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=LzdZYpjIJmIzwTRsqVfi0x7NICvR7ImaS9pD8QkWRao=;
 b=TDh9bga64fBR8BquYHrxrvGSo/foMCYlUvu0VTwVVGkromTpGxf5J523yKybwGBpfY1U
 cT+5KD+xy9Nxw8GN+rMpsgqGu+1+CzveA2nqiE+nr98GKGKTJYaGksMw/HM38SCd49fX
 Oxp7kBPNSF2p3lHkUQxB0yIgjsVJfwOtChg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3bcvrh93ut-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 29 Sep 2021 13:05:08 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Wed, 29 Sep 2021 13:05:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gg0GbWyzxfT0mEuscZawADnSu4ipSRy11rIHJljL4hK4007Q/xU2yR4lj/VoW+nf2EWx6OxpPk131wVYBkwPoLadFokY1tnt+Oy4l1AhFQ5xCMD5sXe5TVB7clHm59zQuVEfZeA7fI04bcUeZfrYcjj9Scw6dr/6ZIDjfqDkvnqD9Tzow4VGX8D7urjojUs9DY+rr740VcHD8I5A2jmv/2DCIKUNhjW99xdH0o3MfHwwP4lHHP5fDecUBkOpwgqt4vZCJDEv4dIacIKylMJDuELk4zfqhf9211ZbTcn/h/PYpygzZkCQ8g2gX6iywWXRkcMqGGvqICEmm4zTxuSlsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=LzdZYpjIJmIzwTRsqVfi0x7NICvR7ImaS9pD8QkWRao=;
 b=BkyGXurWZ6uu+QpQjYzxxoOKlfNT1IR4viYOsLUH3V66GlX29kfFxSVTed2cy+ufFqhVAroAMxamwVcqKcmPh7SSGPHGLliGdmDB0Pd7UpKwbvnUcdj+q4YZEUS1IHD4ezdXpg2St0H2XsvQL2ELPkIj5TJqY6+OKxQjXzwwKkDkXkkU6bRQNHIzSn5DosW1guEEoYFn0W87XQcgEm1sOzpY89UvjB9/kV9UUX7SZ41+sj00VrNrxhG2nzIPXMON+476AjsHGgDg/bne/C12/OWZ7gi2Wll8CttaKXZgX8k+rouerFCRPy6h3JzUumlJeimVOLrkfqRhHT0zXeSRLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB5094.namprd15.prod.outlook.com (2603:10b6:806:1dd::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14; Wed, 29 Sep
 2021 20:05:05 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::7d66:9b36:b482:af0f]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::7d66:9b36:b482:af0f%8]) with mapi id 15.20.4566.015; Wed, 29 Sep 2021
 20:05:05 +0000
From:   Song Liu <songliubraving@fb.com>
To:     "Liang, Kan" <kan.liang@intel.com>
CC:     Peter Zijlstra <peterz@infradead.org>,
        Like Xu <like.xu.linux@gmail.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "like.xu@linux.intel.com" <like.xu@linux.intel.com>,
        "Andi Kleen" <andi@firstfloor.org>
Subject: Re: bpf_get_branch_snapshot on qemu-kvm
Thread-Topic: bpf_get_branch_snapshot on qemu-kvm
Thread-Index: AQHXtMWNyKWclBi4s0iJww6HNTXDJ6u6n6yAgABLWQCAAAXKgIAAJheAgAAVeoCAAAoigIAAOogA
Date:   Wed, 29 Sep 2021 20:05:05 +0000
Message-ID: <0676194C-3ADF-4FF9-8655-2B15D54E72BE@fb.com>
References: <0E5E6FCA-23ED-4CAA-ADEA-967430C62F6F@fb.com>
 <YVQXT5piFYa/SEY/@hirez.programming.kicks-ass.net>
 <d75f6a9a-dbb3-c725-c001-ec9bdd55173f@gmail.com>
 <YVRbX6vBgz+wYzZK@hirez.programming.kicks-ass.net>
 <C6DF009D-161A-4B17-88AE-3982DD6F22A2@fb.com>
 <YVSNV/1tFRGWIa6c@hirez.programming.kicks-ass.net>
 <SJ0PR11MB4814BBE6651FB9F8F05868FBE8A99@SJ0PR11MB4814.namprd11.prod.outlook.com>
In-Reply-To: <SJ0PR11MB4814BBE6651FB9F8F05868FBE8A99@SJ0PR11MB4814.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=fb.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 483be325-a705-484b-dde6-08d983846de0
x-ms-traffictypediagnostic: SA1PR15MB5094:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA1PR15MB50945CF31894F9D4BD59CC20B3A99@SA1PR15MB5094.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZNTZ97zZS4Gfd564oHU0jYot9Te9Cj3NahydkVvCIQtHDqsa2icPRO4fXoA4C+ONr5PyX1Ia9JsM6ZBHx3oKUH2wiGs92mkWPcnOoiV7721zgvsPIokG1XYiShSpkyBNxjqG0lCjhedW+2zFnQ4CFsjAx5jhGNA4pMwBC9eDsek/SttmuiUrB7TT+pDV0cMSBeakNCDxnchvSzHdyw6eun1YWYiVBgi7O2TBY8cekF9lsWwkexKukU5EMASWGZZ6bGbZTmvSlCz6JEdYqu5kZFln42GKGqmcQ9MRJ5des07ML5XPNEzjg4FD+UPYyN0XPSi0oRIscNiVdzOUXYIs1mAcLsHvF3wBW8QkvWEQ4NrODCPwOIb5gq3oSWgHweZweBHAq64qsYPI2ncWqvIpTxtj+hA/PsmKusYij7Sr7vcuPAo1ZMNfMSXn3sFEk6Esy3EehJDjJFR9E3uFn6vO7duAJd6EaHYajBtDGJ9F2fE7cQewXVBfUdYHbbgioNLpaByPzrC4fb6uRkHspwNbe8Y93V/Da/bwbZf11k4efrGTHl0ctJTGrN3RWAqABH252OuMqa4MXn5xefpOAMSvTROqmfXKb1VtdQLYWeoQk5S8Bv7ImdpyZjxGoTX8jf8hgRoBCWTsEVKdPJJReiCritHSuDdDzYRUdOz12gr346zh6KSwU6UAE6Zg9EzJhAw3nXjGr4YotqE+pGS9GLjtklY256poVjjRVCrh0PuexDU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(76116006)(54906003)(4326008)(6512007)(38070700005)(122000001)(6486002)(38100700002)(8936002)(66446008)(66946007)(64756008)(2906002)(66556008)(66476007)(91956017)(5660300002)(53546011)(8676002)(6506007)(71200400001)(316002)(6916009)(86362001)(2616005)(83380400001)(33656002)(186003)(508600001)(36756003)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Mfg/yTDsw5ohyq81W4yzhSI9fi/ub2neu5BWxXLpfhm5ZG/tLbEjU/vG01ed?=
 =?us-ascii?Q?F/EiEJpvoMBJMDJqtKmsoY9/6Yga2kOIQ1VE+LK6IfxF4TVocAV4VmPoFQxS?=
 =?us-ascii?Q?Qgm+n6HxhiO4FZ6k9LmizGDTpGyQJYvJpDJVsqQrDtk76TvS7xulPrxeK2+C?=
 =?us-ascii?Q?fpegVodmrmrJ9N1F/eGE3bWWs6b5TD1iSAczlovP0PYaQaAIs0MwR0XpDoPB?=
 =?us-ascii?Q?eixnM66Y1CoYiJTl8bougzKe1XigDDZnnE2oJVylZmVLv3PG5Nmd9MxhUKcE?=
 =?us-ascii?Q?BYVTjjSRv/GOHNOkPitv7Fu5i4a3VW7H7hkM98AUvxyru1khZ+QzjKOFJuiv?=
 =?us-ascii?Q?WY/zE+KQJ1zJjYobcb9ZdF2gMcZrwrOZxSU6Bsgytde6BuStdVARWmQZpY7e?=
 =?us-ascii?Q?E1i0E7fRGhTXYerbBY6qnVaYlLAwszmWLz2Rva9sGLx2DptuRa254fce3cBe?=
 =?us-ascii?Q?bDWrkRSKa4MNMgPv2hIM+uEw44eJvtj+oKcfQ1UVvDtwPHkeyHhbDoJKZKPh?=
 =?us-ascii?Q?vfVeYNVF0prd134JmngYFxhoARngTNqYnFCd3YQ2f0Xy2Zecpjs8F4f8Ir93?=
 =?us-ascii?Q?p64SgDSzXG3uSESCDE5UZ8fmi3/iV9ViuDrKmLYC2PWYV/XZsUxWBbva/gVp?=
 =?us-ascii?Q?BExC7Y20TvSJt+WAQKNJiXcMIijhr6t3AGLmURuiZ9Uf+5jK3DOM1oVu/E8t?=
 =?us-ascii?Q?1thqND6702FQ5VNnbt5u8DK1PD7q/jnVZerR2Tw8w8cMcJOCjRX38m63KJ1r?=
 =?us-ascii?Q?9YI5KCuRaIBjZehjDHhm/1KMxf/iKD9oLfuIVGLpkTxHgRtHltTJYZtWyspb?=
 =?us-ascii?Q?dWtpIlmYGgqOxwAqrNsCO0v+uXYVLr5j/vNFYm9PULvTGiT0dTaE7RL04C8R?=
 =?us-ascii?Q?GxtZfwBvEJvFm4xkQ8BXrZFz+ca4eiBF0zrdGqiLY4RqjLg/90cD/wSatiYp?=
 =?us-ascii?Q?Gw1Gx+2sPGG49ReQqw3zhdzNI4DOFtwXDhDy6WEMnZgBXrrqrVRpEA7ycTUn?=
 =?us-ascii?Q?7a8yOqnm/czJVTSzftFGJKE3sd+zikxsFy0D2cLb0RpgaSfTyveE8S9j5Z9U?=
 =?us-ascii?Q?7hTOn/VRzTW4Z30h+UvRw3fFbdqb71sE7DvsTFd5dtFG2c4TWlg25yCVYePp?=
 =?us-ascii?Q?MAgpJmFY7978C9DlpScqJ9ndRgmuvVFxlFnJoKv+dRTQLigDGLykdbzmKffr?=
 =?us-ascii?Q?1PVV57BHkitzOAiT80RLpL3NJCP9gMDoPss55h4MD3ldEcAHsxV/9drBOdOr?=
 =?us-ascii?Q?HamJy7yH1woUdgwsZQwcCaSGuY+Eg6OcZ1aOICc5Ri6BaLemCsvkdBfVkrbL?=
 =?us-ascii?Q?S7Fz6sO1agekJ0hiHdKI7bYteIKDVhimxM0EWiklatPdrfxKGTPzkZo3E80b?=
 =?us-ascii?Q?SxHD6Ic=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <EA91E404CD882E438045581BB0131642@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 483be325-a705-484b-dde6-08d983846de0
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Sep 2021 20:05:05.0846
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: d3q4lqmEduAsTUl0oCXG2ICD0bMXUywW0rNXv10V7Zrb7qAzIfqyXSjxlbL/rkLE9tuOG4g1u/snpHTBaV2auw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5094
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: 0-mVKuSQOE3p3lO2mAvzarOGPu5qMiG6
X-Proofpoint-ORIG-GUID: 0-mVKuSQOE3p3lO2mAvzarOGPu5qMiG6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-29_08,2021-09-29_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 suspectscore=0
 bulkscore=0 priorityscore=1501 malwarescore=0 clxscore=1015
 mlxlogscore=982 phishscore=0 lowpriorityscore=0 impostorscore=0
 spamscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109290117
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kan,

> On Sep 29, 2021, at 9:35 AM, Liang, Kan <kan.liang@intel.com> wrote:
> 
>>>> - get confirmation that clearing GLOBAL_CTRL is suffient to supress
>>>>  PEBS, in which case we can simply remove the PEBS_ENABLE clear.
>>> 
>>> How should we confirm this? Can we run some tests for this? Or do we
>>> need hardware experts' input for this?
>> 
>> I'll put it on the list to ask the hardware people when I talk to them next. But
>> maybe Kan or Andi know without asking.
> 
> If the GLOBAL_CTRL is explicitly disabled, the counters do not count anymore.
> It doesn't matter if PEBS is enabled or not. 
> 
> See 6c1c07b33eb0 ("perf/x86/intel: Avoid unnecessary PEBS_ENABLE MSR
> access in PMI "). We optimized the PMU handler base on it.

Thanks for these information!

IIUC, all we need is the following on top of bpf-next/master:

diff --git i/arch/x86/events/intel/core.c w/arch/x86/events/intel/core.c
index 1248fc1937f82..d0d357e7d6f21 100644
--- i/arch/x86/events/intel/core.c
+++ w/arch/x86/events/intel/core.c
@@ -2209,7 +2209,6 @@ intel_pmu_snapshot_branch_stack(struct perf_branch_entry *entries, unsigned int
        /* must not have branches... */
        local_irq_save(flags);
        __intel_pmu_disable_all(false); /* we don't care about BTS */
-       __intel_pmu_pebs_disable_all();
        __intel_pmu_lbr_disable();
        /*            ... until here */
        return __intel_pmu_snapshot_branch_stack(entries, cnt, flags);
@@ -2223,7 +2222,6 @@ intel_pmu_snapshot_arch_branch_stack(struct perf_branch_entry *entries, unsigned
        /* must not have branches... */
        local_irq_save(flags);
        __intel_pmu_disable_all(false); /* we don't care about BTS */
-       __intel_pmu_pebs_disable_all();
        __intel_pmu_arch_lbr_disable();
        /*            ... until here */
        return __intel_pmu_snapshot_branch_stack(entries, cnt, flags);


In the test, this does eliminate the warning. 

Thanks,
Song
