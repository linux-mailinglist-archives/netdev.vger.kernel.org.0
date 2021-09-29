Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 802B241C70C
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 16:42:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344536AbhI2OoN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 10:44:13 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:6224 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244630AbhI2OoL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 10:44:11 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18TAmAtA003068;
        Wed, 29 Sep 2021 07:42:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=c+w7TzhoPwLkrcYExxvOcDKe/0BV3dEsMRcEDJKYXXo=;
 b=X925ZqDAoPlWz1pFXnN5XlcYsls3fM9gUn808tUy/1+UNJs5r/lr+Yz4HO/B23mUd1T1
 EL4kmvVAgaqTakc4UYqwkQaVsR9IlBfgbvRhEUrXl1rBQx3BXStYSHqeKhmnapSeptGw
 k9ENu7KC1KCTSMe5H6zA2U+gQnXqk3aSN6k= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3bcbfm5bhu-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 29 Sep 2021 07:42:29 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Wed, 29 Sep 2021 07:42:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MqiCvAcdiJ4q/E8tUnTuPiTcXWNfBVhryK2ogUgUcV12YlCfnb5FsV9kexXSkDMpdC2VqnCR6G4zBAylDzpZNoaoVZWlkTw1lT6/ghQ+ji205mi9joU+AFuOwddc2iPIZ3NrRSIfMfpOaNMd7NeuIFHBRhsYhAGQCfivGKH7IMy3FpbyGehjm27aUqHf2z656xCD7h1nvxKt1oPI4Qp/xcBCBWnvy1tK2OxP5b2lQ3bIxER+D/LQnqkETkH9E9B3xK9SFtel6Ul4GCoV63g0abe9RZU+RKY68UMsI2q+5xxRav6AR2/X9S6sFwrR9W4V6YU6K+XhGzIOivFpdzwaUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=c+w7TzhoPwLkrcYExxvOcDKe/0BV3dEsMRcEDJKYXXo=;
 b=M/60VCTCGl0hF98FfpkjXEvgYJBc2mN1tNPliijB8yY46l5gO+AsqPKO+xwHtHq4VBrsnllU0566i/k3evdlpaoZsiMdkieZ39YEUy5Bgy+LejFJ5baM44kxZag0Ay8QO/bBdBPb6plVvpI7eioXDyDCuwiKzF/2YKcDMGDPlpNMObOPDis4NhVPGMbD85cnAvmHMXFPhCg2dQVOORV0eUkhh2Sx3IrzwnRX0eQdaHoQe+B+5EmVlu0NW7Tiz7szMvll2yquh93SB1N0Fz0yGuqsATwKg5KHIQOrBYGxS2YBT/teosyufHWrtZC8j5Aiy/sOZv5SbMB49VNB9ThTBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB5061.namprd15.prod.outlook.com (2603:10b6:806:1dc::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15; Wed, 29 Sep
 2021 14:42:27 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::7d66:9b36:b482:af0f]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::7d66:9b36:b482:af0f%8]) with mapi id 15.20.4566.015; Wed, 29 Sep 2021
 14:42:27 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Peter Zijlstra <peterz@infradead.org>
CC:     Like Xu <like.xu.linux@gmail.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "like.xu@linux.intel.com" <like.xu@linux.intel.com>
Subject: Re: bpf_get_branch_snapshot on qemu-kvm
Thread-Topic: bpf_get_branch_snapshot on qemu-kvm
Thread-Index: AQHXtMWNyKWclBi4s0iJww6HNTXDJ6u6n6yAgABLWQCAAAXKgIAAJheA
Date:   Wed, 29 Sep 2021 14:42:27 +0000
Message-ID: <C6DF009D-161A-4B17-88AE-3982DD6F22A2@fb.com>
References: <0E5E6FCA-23ED-4CAA-ADEA-967430C62F6F@fb.com>
 <YVQXT5piFYa/SEY/@hirez.programming.kicks-ass.net>
 <d75f6a9a-dbb3-c725-c001-ec9bdd55173f@gmail.com>
 <YVRbX6vBgz+wYzZK@hirez.programming.kicks-ass.net>
In-Reply-To: <YVRbX6vBgz+wYzZK@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
authentication-results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=fb.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bd153938-06a9-460c-b15f-08d983575bdd
x-ms-traffictypediagnostic: SA1PR15MB5061:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA1PR15MB506167EC7579F7B16F8A7AEAB3A99@SA1PR15MB5061.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gbPwdN9cclIlye8wF+LkMkzAECma068k2y0uGkqysBb0uK5Vc926hFjCI08Vu9zWFPMygzKDQ2ZUxIh14Zwie6swqL2e86tdc08zHwnQcPlePyuJdrDgih16JIFYnF3YgpcugtwspvCHXUDLZILvxfsq9eCSNjUv8c43tQ5UXMo0aTA19uK9V0QnFNYB6kbBo2nenyPeHGC9noWbhZbyeT77M5fpItQcDxMDCyrhiEMJdLfOHG1CEj2H6nVecirq7ypHm0NTjDwGZUEbt0fg7F0Rs0anrkTEBKO0l5VPDrA6QEXrnq2VZOIcZYClVzx6Gyk6YyxTwdRilF0qRIMguBt9IHxYwXYyqeF5DY6Vk65OUi3e3HMa40uhAYZwoygiFqD0Vm0Ayv3O3K8KwYew92KzG51oJT1o5xAKu+pKPjVnKIVuMfLdMD5eNDYhvsMyY5OTdGFmXexJNeWoHLMCPQTMduYra7s51WnA3iFmvG9c5hXLtox76TSxhl8RgF/f9VRcVILHYaJ1UVnx8r0KUbg1nRuaWW9UHM5Z39AUb9l2ZmOvH78b7bLnoNXNdaPCMteo3Xn+go0URqC13FEQbp4ACuA6QBq/VcKZsosrNJkvxfD7gr0+bmUd7MSy0EAzSjw+EaBZHU1ZQqTAkc+U7ZICA/wbKgp3eyVmWe8iB66Ql57nQz/jZtWfX5z6clMRcKJUA9nIXnAd44roO/jNM4W+dd64VF+9OUc53rf2aVLIjYj3/0l8l5a9R+Zgn5tN
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(508600001)(6512007)(186003)(6486002)(33656002)(5660300002)(316002)(2906002)(4326008)(2616005)(54906003)(8676002)(86362001)(64756008)(71200400001)(6916009)(38070700005)(91956017)(38100700002)(83380400001)(76116006)(66476007)(66946007)(66556008)(66446008)(122000001)(36756003)(6506007)(53546011)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?YnsKRF3910Ym8Gt0WHNg4WUCwYvD0ztbEVm8K1be2UgjLvKKgqggaMDBuKtY?=
 =?us-ascii?Q?VhugU79WnLvhs1Wh6RBbAZiz+rvJH75yXyUfZceNZYLTF+wkYVp/SoP0jB73?=
 =?us-ascii?Q?LsC4a04i1bYqIuqz6J1tbZ23Uh/fsmOTuTO9TL3ff+BXyKwAE//6KMlPtYhS?=
 =?us-ascii?Q?utW0hUQa0b15Mk8M1/xuSC/nfFr0GSbpLsIZEc6cTcORJYJ+AqpiJqlneh1t?=
 =?us-ascii?Q?JE7dgKScEflLX4mYEA3/FjpiL/1Hs1Df3uuFTzl4Jms6aQmBxA/RIdVwwwDY?=
 =?us-ascii?Q?3dvD52z8/PE5RhUKuy7PjmkTQzen5bPseUeVoOqc/ggbJtDlPFuOnynKk7wy?=
 =?us-ascii?Q?T8Iszzi3DrU7JVxtG+OIQ+pxNP4z4ebgLNZe9gAWRZIjc8r69pYnFOTLn9lV?=
 =?us-ascii?Q?IVGuFOfN0S5VqortMboyDnPtDDi6vl4JTSNxT68CDpC81NeEikysHtFJuSUl?=
 =?us-ascii?Q?3xj4jI3OrPt6PBBwRZnOlxqcbD/ziolzxsWxPuhJhonGcuEXfKJmmKSYSpAC?=
 =?us-ascii?Q?pIHx7pW9N1DJFgCbMTpz7xW9rJrIWhEcTEdSwgo40yXFOQj6vaOs++eHQhlw?=
 =?us-ascii?Q?qZe6l99cx4Pf+bzqfsyiNJmZx+uMZGPnLI5wNCXaIz1E/86dDkF1b9mEZzVv?=
 =?us-ascii?Q?7bnMNR+XTOo9N6YZfm7TH9Kbspqajh3YF3GopeS7DgZcNOcvh2iJ38TF6MUT?=
 =?us-ascii?Q?6NhlErwU+1UNfKILC7FNpuf6wtFtA+KY26rDfUIllUZFi/A6SoHHAqepRBKp?=
 =?us-ascii?Q?KIbvHwFZ18fZxpTGthsshbpRygyK+eCzRzDLa6+oWxukMf69AdI8EPHqFBMW?=
 =?us-ascii?Q?/17kOeK21LOp25GTvAMYOwz25Wd6LU41nIPT00uEvCeG96oO2hZS5mFY2JdN?=
 =?us-ascii?Q?NobqW3mkLHiFl/cBDpMJCEQLmt/gfLL7J55C86KDAmVlM68i6DEFIfnxaMdy?=
 =?us-ascii?Q?GBBLQsUS6ne+IkfewC66w775qmeZJ6G+lAXflYBtRruRk3kYGeDP+fvd6dvV?=
 =?us-ascii?Q?w/Re3rCZmfHcN+y97ClZ+UD20xa2V9dpDIRStp30lK06sVavS79alcSiHi/Q?=
 =?us-ascii?Q?YeylvMKlBhZUUbeRSsjTGR7MQS86F2JXB8F1gL1qJbQnFX52SvV1ok+LTEde?=
 =?us-ascii?Q?ddL/xqr4f8TkxjO1wry7VT75KdXGypo6ltpKoIUt6ISyUW1+ciriG4gPhujt?=
 =?us-ascii?Q?m/ZDD9exCzFzRRsIv8R340X20xLaytuD5jZbeYvTkK4PFdOzOYT3abUTZXHz?=
 =?us-ascii?Q?cGTCgawpf7fRrekz/sgdObTzYUQuFynzTcgo/Edl9CJgI/6TxlT7md7Rv8qm?=
 =?us-ascii?Q?rYRjwwuc5F1hy50IO8pkmbCoNKJ2EesorcrLNEdVwvq/yZLMq1cwXsJyg4QS?=
 =?us-ascii?Q?KMtfE1o=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <789EDB1D1EFBB24B9A191DA057050A44@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd153938-06a9-460c-b15f-08d983575bdd
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Sep 2021 14:42:27.5816
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: O5bHcQxcZ48k4y4E1lpP8Bzc1rI9XlrVo7s3ZN9BpVZaoUJgUHjoAMuAorEAbMkwoj0GE0Op6yIaH1einiBK/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5061
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: yGQznNW0S90O9Ilhpx6qcsjhKDItNTku
X-Proofpoint-GUID: yGQznNW0S90O9Ilhpx6qcsjhKDItNTku
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-29_06,2021-09-29_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 priorityscore=1501 spamscore=0 clxscore=1015 suspectscore=0
 mlxlogscore=823 mlxscore=0 adultscore=0 malwarescore=0 phishscore=0
 lowpriorityscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2109230001 definitions=main-2109290090
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Peter, 

> On Sep 29, 2021, at 5:26 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> 
> On Wed, Sep 29, 2021 at 08:05:24PM +0800, Like Xu wrote:
>> On 29/9/2021 3:35 pm, Peter Zijlstra wrote:
> 
>>>> [  139.494159] unchecked MSR access error: WRMSR to 0x3f1 (tried to write 0x0000000000000000) at rIP: 0xffffffff81011a8b (intel_pmu_snapshot_branch_stack+0x3b/0xd0)
>> 
>> Uh, it uses a PEBS counter to sample or count, which is not yet upstream but
>> should be soon.
> 
> Ooh that's PEBS_ENABLE
> 
>> Song, can you try to fix bpf_get_branch_snapshot on a normal PMC counter,
>> or where is the src for bpf_get_branch_snapshot? I am more than happy to help.
> 
> Nah, all that code wants to do is disable PEBS... and virt being virt,
> it's all sorts of weird with f/m/s :/
> 
> I so hate all that. So there's two solutions:
> 
> - get confirmation that clearing GLOBAL_CTRL is suffient to supress
>   PEBS, in which case we can simply remove the PEBS_ENABLE clear.

How should we confirm this? Can we run some tests for this? Or do we
need hardware experts' input for this?

Thanks,
Song

> 
> or
> 
> - create another 2 intel_pmu_snapshot_{,arch_}branch_stack() copies
>   that omit the PEBS thing.
> 

