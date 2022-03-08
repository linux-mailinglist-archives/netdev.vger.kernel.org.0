Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 724414D0D96
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 02:39:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344283AbiCHBjz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 20:39:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240124AbiCHBjy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 20:39:54 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D171C1143;
        Mon,  7 Mar 2022 17:38:58 -0800 (PST)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 227NnSto028792;
        Mon, 7 Mar 2022 17:38:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=o8dtsprfHdNplmED9XLdbcNpfUWIjuynRgexPtGU6Uc=;
 b=K8jerWwNnjfGy74i1DhuZBe+OUJlSw2bf2bcSDybNE9gmKjfiS2xkqY4tFoY2qgpXvPs
 J0CxiKXSZHtbDNSTW1PQjwwjj1LuBejHmqynxBIoJFvuWQvZswzbljIrjG6TAypNL1Yt
 XffhGly3KXcSSqYNdNkXAEWfYuDADuiBgbY= 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3em827ptbs-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Mar 2022 17:38:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oAmZvNMKgbPDTtOC/9uTj+gQhSD72obLLiWCncmEFnUDwb1lLXL+QBlNEb6CYsBgIvlfE3nD0WiKrLRUzclRS+6/1uS41oocSqaLHeULa8NVwC5iDsz3Lvan7VthP7L6CdAOppaED9CAQGwvzrBn6NNhNdzwwqYMnImZDzUhaFyFilD7lpGz8KOyNEzj3yDNEvNAnNGMvTinotIui7ga7Pd/wDO58gToN7xwA1Zm/NGbasNvL585CQnemI+vVOjz+Jt1msOfVa5OcfTU2tsGNcBmrY1ku7Bg/+Mv9vl5F3DwAQTZaMRpVEAdEgsuYD6J3iDts/UWtHwOI7QzsgUpgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o8dtsprfHdNplmED9XLdbcNpfUWIjuynRgexPtGU6Uc=;
 b=a6TpLoe2lgN5yvu5VmYwQtkE+KeKR+F9qgAQo8//jwPe9XMerzAq3NkkdbEFk/HoQDGUjBUBBAN1mIJkBsvwZMrF5kA6RbpXO9o10VzoncKlQwLeZO0RHiBha2OeydP5jYyNfL5vhQvpyRJgWAgRlIMECEIl5QeX6taFY2QeLANj45VqmVbDCEyP++zb05nAEk71se+JMSSgj4uzLOu6Xlc53aX9Kpe8lYCJjs5OFkP5OBJTA6nFlVbIXW9mtcLxpuswMlfaW5QEb0d/t6N8SYglu/laHUbQqGP6LmoW2+KcTNeVadnlj5rSS4Mp9TBXWsRz8NY/hBDm29akcEadvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by DS7PR15MB5325.namprd15.prod.outlook.com (2603:10b6:8:70::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.15; Tue, 8 Mar
 2022 01:38:56 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::7da4:795a:91b8:fa54]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::7da4:795a:91b8:fa54%7]) with mapi id 15.20.5038.027; Tue, 8 Mar 2022
 01:38:56 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>,
        Tero Kristo <tero.kristo@linux.intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH bpf-next v2 04/28] libbpf: add HID program type and API
Thread-Topic: [PATCH bpf-next v2 04/28] libbpf: add HID program type and API
Thread-Index: AQHYL+2p75RMy8/7mEKQOl6p6dA9DKy0uGQAgAACTIA=
Date:   Tue, 8 Mar 2022 01:38:55 +0000
Message-ID: <D32CC967-8923-4933-A303-8455F32C6DA0@fb.com>
References: <20220304172852.274126-1-benjamin.tissoires@redhat.com>
 <20220304172852.274126-5-benjamin.tissoires@redhat.com>
 <CAEf4BzZa8sP4QzEgi4T4L1_tz9D8gNNvjeQt3J0hrV6kq8NfUQ@mail.gmail.com>
In-Reply-To: <CAEf4BzZa8sP4QzEgi4T4L1_tz9D8gNNvjeQt3J0hrV6kq8NfUQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.60.0.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5680fb66-b0f8-4bc9-b668-08da00a468d9
x-ms-traffictypediagnostic: DS7PR15MB5325:EE_
x-microsoft-antispam-prvs: <DS7PR15MB5325A153E20D147ED3F3B3ABB3099@DS7PR15MB5325.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QsfeM/2+mNaSBNGp9RJKC6QAjtX4tSzaeAhuKnPf/DkjbwRsLpfiKW2WPBHns6DyjVNZNbrolJjzkLV+Ah19oYB4WIznBm51zhmlmjOiJl71yabhAE12xJu/02sAFtA9wJo5cGH1O5Cs8wPaSLtd4mij4eoxoexXCq/nJ6cZpsQw+IYew6p/FCSXvszdn7X6Jtoq0uicPTKvmx9oE4Uu+xvTuKaFK9y181P9Ykq4wf2NO5AYtrEUaPiOsJBuKoEyaONfASHqn8KgcqydQq3yDqiSiJEQo94ja1bfFQy0VXFQ6Usxz//atOkrYz1DYVagqKpNb9/zORdJPG6ujruOdy6zzKork3savfQdYAWdcl+9uGUilu9dZhsZg7X39dyiAKYRE5JYIXzbA6F0Tk05mPCz4tNxX859Y+GF3RNyXv+krShpR+IuRRsdAheY2VWgaSfD2/gthd5oYWT2s/8K/glmw+DU71Ls8GPMfPfd+lJ0DttLDxI2yahE0iLcI23mvnQ07Ot5qVVubbZ1PXAgKpauxtznUw+rvt3AmU6BFUOoLWJmb5cNq5v1HirlhHJy48SdQ3+qT35kDqlCJ4IPlqHkfT02SctzUaq30TQSMMgCvodUkLolINwXx2pOvxZRSWoDhgj6H1vDdlXjUaOU9mhMMfGW/wriNFEq0/YKEFHfFLTMxnAAD3ebWjUP0BTylcxhs59IPxJWJ1pct9sv8pdCLVr03hzIXVLiBiEJShyWMRn6E16jmuW3gOiwPAM1
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(2616005)(66946007)(8936002)(33656002)(4326008)(8676002)(76116006)(66556008)(508600001)(6486002)(2906002)(66476007)(64756008)(66446008)(91956017)(5660300002)(7416002)(86362001)(36756003)(71200400001)(6512007)(316002)(186003)(122000001)(6506007)(54906003)(6916009)(38070700005)(53546011)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?+TuWKBEfZpvr1Z4RhtNo42588AMzX54HqltmUa7rcXEr+tO8OaMoUY7FmwIz?=
 =?us-ascii?Q?6fzV1qVB5oIxqIaPFCpbpTBM5RCrJdB8RdddsCBenMZ/c7cX6DAp7ban8LUf?=
 =?us-ascii?Q?75nA3PhvciFksEOVNLZemLeb/3e19C0+M/ete/2LSXLOQNWhqEL0Rvt+SpVe?=
 =?us-ascii?Q?GJ9NUg/GShStF2zxFedMcu22jUXKYNsWxTF17Elega+YuK2ZSMeLfOg5tB2J?=
 =?us-ascii?Q?n2XcpAz4VKCQeWrGnFl9ACIIaNgRqbFlizQ0NkLqCmOKnVWkiv0b+XNiUv1Y?=
 =?us-ascii?Q?j9HbBnpV3PmYiDcacot0WNIttqpmaSjZXs6Sr+2W6TyH223PAR59z9bdRChJ?=
 =?us-ascii?Q?H5JsDAT4m2we0m7Y92tp3V0e93xsZQOedcm1akxw5Kk01GFbCuOugfGP/hZV?=
 =?us-ascii?Q?Ob8f0SMbcUjJ1IVmNaKre4B2jUYpJ72WyEiikMjkuIRavQ+eIYz/yYgNsts0?=
 =?us-ascii?Q?VfXqbxgt5VMBPLt+fRy3T9K75uTA/xXkAN0b1ms5rDICD3i+wrhOCdiQLVp9?=
 =?us-ascii?Q?VZL4u5HB5Xbv1lOgknj2ssiNmXThVa9M9197biqCWwjVNeU/tCt0HNGiLosA?=
 =?us-ascii?Q?OoOUK4LiwwbXFL4DJwij2wk28sOUGUjNOjlM31u3L+XKnIKUP7tJVt38666w?=
 =?us-ascii?Q?hr/Qfxz6e+BqxLf2npq3+wPiQ2ENS+U1fyHM4hMOsD+Dq7LZdwbaScYErBjV?=
 =?us-ascii?Q?+KUbahUt0JUd1rmLDT4iQ9mCKaX8Qp+nRnRYXK5hYmT+nieFx3PM26hmWOi8?=
 =?us-ascii?Q?wxl81zevnA/YxxFflwr2rZoKTyyo47MPqdreUbisKQQhnnKzMMtXBDLC1TTN?=
 =?us-ascii?Q?zeq8w8/XdoSDA7rYVWV/X2Oc3MYBaZ0Vkt+ghp+ZonaPBM9O7uQijM6xkI67?=
 =?us-ascii?Q?yrkSmY5pwTlB77xefg0SRGJHmtzDSCRgdMGnNuZ+dP3yOz3+csQYmYlxfpVm?=
 =?us-ascii?Q?CPJ6fUDsztb7htWKhy8uxygQIDXCi2/dpgqNEY1sEhUbHit7Db1sYDlDUrYM?=
 =?us-ascii?Q?+lEWf6Nc6OaYaJd8oMLO6HAU8f8Qz4nfEPItPCG9YcsS2vsI8DTsHjsYZaFF?=
 =?us-ascii?Q?gZIQ3Efk6Rf1R7RZMfWug02MsdkakmL2k7R4Ffin8SDDCSdjlqjd8Whh8OaJ?=
 =?us-ascii?Q?YUjXklbFwSW65MDqPvPvGm4SD98lYyZ1Wnt5D3bx5dJVOc6PWfoHdVPFQxEQ?=
 =?us-ascii?Q?C243d/0npe1xVXBks/8A6JHvhd4XcBWBQdtlD6UxxI/oxvBKXg/PEhvfIuCr?=
 =?us-ascii?Q?WMj7JaNEus/huMJTddPPdu1XVXA0v/1Gl6yDmMdkm0w/mXVIWfqwoi5faXTV?=
 =?us-ascii?Q?amGFHoeJ9sv1tCZ21xPsB2z6mskI6+0hNhranTELymKfmPtQZyIhUJT2Rgrl?=
 =?us-ascii?Q?13C/bkMAH0fogCK7ta2YPUW6vCbGnbIrfprJ6mzTfqTfGfGOomjqSuZs5slA?=
 =?us-ascii?Q?iCVXP2NuARxkY9mxHSsoAsnEA4jmVnUJOvudmbI+X7VAlAq43RygWPG0kMbc?=
 =?us-ascii?Q?nL0yxhzj70/fjxyVlm+62m/07WyYGktxgSPb9qE0cvFf+zqTjWo6s78SOGIg?=
 =?us-ascii?Q?85Sirdqek8Tza9zTvFhPWVMAfcSoU/yr0MG1lSXAkCJ6nzVTGQ3OlqceaM7z?=
 =?us-ascii?Q?jBmIsHPfgrcYhgqTWh0zEoODtK5kamt6Z2ek7nhm5WhRBhiW+KAt3ApAE1At?=
 =?us-ascii?Q?YqHVVw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2E88DD358CD2E2409CEB649402702E8D@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5680fb66-b0f8-4bc9-b668-08da00a468d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Mar 2022 01:38:55.9300
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lwdmKegyyXfqBOfyp8t0z08HSvf8fleUsdj6AtMY6JLkVqiz+Kh+u7CYHf2IGz/oipYBsiFvhz0HQ+3+UTnyNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR15MB5325
X-Proofpoint-GUID: AAj1nQs9yzKKc5P_AxpsTO-4BeBHmKxT
X-Proofpoint-ORIG-GUID: AAj1nQs9yzKKc5P_AxpsTO-4BeBHmKxT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-07_12,2022-03-04_01,2022-02-23_01
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 7, 2022, at 5:30 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> 
> On Fri, Mar 4, 2022 at 9:31 AM Benjamin Tissoires
> <benjamin.tissoires@redhat.com> wrote:
>> 
>> HID-bpf program type are needing a new SEC.
>> To bind a hid-bpf program, we can rely on bpf_program__attach_fd()
>> so export a new function to the API.
>> 
>> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
>> 
>> ---
>> 
>> changes in v2:
>> - split the series by bpf/libbpf/hid/selftests and samples
>> ---
>> tools/lib/bpf/libbpf.c   | 7 +++++++
>> tools/lib/bpf/libbpf.h   | 2 ++
>> tools/lib/bpf/libbpf.map | 1 +
>> 3 files changed, 10 insertions(+)
>> 
>> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
>> index 81bf01d67671..356bbd3ad2c7 100644
>> --- a/tools/lib/bpf/libbpf.c
>> +++ b/tools/lib/bpf/libbpf.c
>> @@ -8680,6 +8680,7 @@ static const struct bpf_sec_def section_defs[] = {
>>        SEC_DEF("cgroup/setsockopt",    CGROUP_SOCKOPT, BPF_CGROUP_SETSOCKOPT, SEC_ATTACHABLE | SEC_SLOPPY_PFX),
>>        SEC_DEF("struct_ops+",          STRUCT_OPS, 0, SEC_NONE),
>>        SEC_DEF("sk_lookup",            SK_LOOKUP, BPF_SK_LOOKUP, SEC_ATTACHABLE | SEC_SLOPPY_PFX),
>> +       SEC_DEF("hid/device_event",     HID, BPF_HID_DEVICE_EVENT, SEC_ATTACHABLE_OPT | SEC_SLOPPY_PFX),
> 
> no SEC_SLOPPY_PFX for any new program type, please
> 
> 
>> };
>> 
>> #define MAX_TYPE_NAME_SIZE 32
>> @@ -10659,6 +10660,12 @@ static struct bpf_link *attach_iter(const struct bpf_program *prog, long cookie)
>>        return bpf_program__attach_iter(prog, NULL);
>> }
>> 
>> +struct bpf_link *
>> +bpf_program__attach_hid(const struct bpf_program *prog, int hid_fd)
>> +{
>> +       return bpf_program__attach_fd(prog, hid_fd, 0, "hid");
>> +}
>> +
>> struct bpf_link *bpf_program__attach(const struct bpf_program *prog)
>> {
>>        if (!prog->sec_def || !prog->sec_def->attach_fn)
>> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
>> index c8d8daad212e..f677ac0a9ede 100644
>> --- a/tools/lib/bpf/libbpf.h
>> +++ b/tools/lib/bpf/libbpf.h
>> @@ -529,6 +529,8 @@ struct bpf_iter_attach_opts {
>> LIBBPF_API struct bpf_link *
>> bpf_program__attach_iter(const struct bpf_program *prog,
>>                         const struct bpf_iter_attach_opts *opts);
>> +LIBBPF_API struct bpf_link *
>> +bpf_program__attach_hid(const struct bpf_program *prog, int hid_fd);
>> 
>> /*
>>  * Libbpf allows callers to adjust BPF programs before being loaded
>> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
>> index 47e70c9058d9..fdc6fa743953 100644
>> --- a/tools/lib/bpf/libbpf.map
>> +++ b/tools/lib/bpf/libbpf.map
>> @@ -424,6 +424,7 @@ LIBBPF_0.6.0 {
>> LIBBPF_0.7.0 {
>>        global:
>>                bpf_btf_load;
>> +               bpf_program__attach_hid;
> 
> should go into 0.8.0

Ah, I missed this one. 

btw, bpf_xdp_attach and buddies should also go into 0.8.0, no? 

> 
>>                bpf_program__expected_attach_type;
>>                bpf_program__log_buf;
>>                bpf_program__log_level;
>> --
>> 2.35.1
>> 

