Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22E551895E4
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 07:34:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727334AbgCRGeA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 02:34:00 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:59930 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726478AbgCRGd7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 02:33:59 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02I6XffF016248;
        Tue, 17 Mar 2020 23:33:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=qiiDp/bzTvDUpoOTjUkxn3yacAINlD8bPtsVsdGpv7c=;
 b=Ns27WQJ9vn4kQUtB3UaaGaJ0oDpuAHff++HNRqyf6TBye8HkhsESBfEo54dx+dfKH9MG
 JXiKhIuD4w36OsUTFuuinU5l4TLsdS/HfUVD2yN+U/TsYVxrFuREeRDdF+P9h08kA1ah
 xemLFm9GlDiTLy19hlwLFBu7kOjit0KMyIU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2yu9avh2xf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 17 Mar 2020 23:33:41 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 17 Mar 2020 23:33:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SmqKiaWBXgG+NaUK3JUtecntpoPn3R2Ed9fiGMZmDPsiB+ca9r5COuq1J50FXfvqYM0zdB8UHoOc/+Tkj6nliEQx8S9VLPJAhoAfPxzIbQPwoND4+Bd3jvlsEPBjQIROhZ2mDoi4g3tGJu320J6pIvhuguuavOOoiLi2DMsdZlm+kXJlz8iEKk248lmvECkz+29agULa8BkAwMY5pS9th3fq+sKa45ZtG6BsmkqFD8Hz/kwts5eQ7G0Ure0CTc560mCVfMrKWAzF1sQlvjA9vcTd6Gv37A+ucLY7PFGq0al2wX2CPChmJWFz5EvcbAWa8ZE7AL/QddM5KHoVwAYtPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qiiDp/bzTvDUpoOTjUkxn3yacAINlD8bPtsVsdGpv7c=;
 b=ldPivjkum4FRxNNYBVPOfMjtGSJfocNMA6yPeHaK7QdK5I19Wv9Z92jN24IFNP77cbR2NvJAJT9v19ivlI5woxxLl55tCN0Okx/T60ypcRhvGmjuXPav2lWTwAk64XISNJ76zCS4K6mXKW4Tp+dfAKinwW/69PgCKtvD4QWD82kRFWDMpr6H/16TgEW/79yYJbEQ5Uxge55dj8GP2IQqzY5m/A4SXfxyukLzT4jF3njqEBTucAXWXJ3vMv3N1ZGBsTYbpAucwsTUJeFpKH8BnCl0Pn/Rpy13P+vWKLIFlbf8RPCX9IaDgSzy85YGluba3tR38INeXGWOv3qx7grSLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qiiDp/bzTvDUpoOTjUkxn3yacAINlD8bPtsVsdGpv7c=;
 b=LUIxQ8I2LdNpT+mZDmxoDUv5XIKpZfCbuSk84uHdarrNwNUTXSW9xCeUeod55sgrSm1d7nxLHXnbDS1BTyS0PT4AzK5BluyrT0ORBU8UWd6pXHWJIKPSUC9mkjPW7cz76OeCulGzfVjLtv0GLFDou4BAqifKWKFdteyBm5Vpum0=
Received: from MW3PR15MB3882.namprd15.prod.outlook.com (2603:10b6:303:49::11)
 by MW3PR15MB3866.namprd15.prod.outlook.com (2603:10b6:303:50::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.18; Wed, 18 Mar
 2020 06:33:26 +0000
Received: from MW3PR15MB3882.namprd15.prod.outlook.com
 ([fe80::c570:6c46:cc47:5ca5]) by MW3PR15MB3882.namprd15.prod.outlook.com
 ([fe80::c570:6c46:cc47:5ca5%5]) with mapi id 15.20.2814.021; Wed, 18 Mar 2020
 06:33:26 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
CC:     "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "mcgrof@kernel.org" <mcgrof@kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "yzaikin@google.com" <yzaikin@google.com>
Subject: Re: [PATCH v2 bpf-next] bpf: sharing bpf runtime stats with
 /dev/bpf_stats
Thread-Topic: [PATCH v2 bpf-next] bpf: sharing bpf runtime stats with
 /dev/bpf_stats
Thread-Index: AQHV+9Iy3gdyr8P9PUGp5sv3FGMYHqhNLWaAgAAGw4CAAAJXAIAAAvkAgAAaDwCAABahAIAAfHOA
Date:   Wed, 18 Mar 2020 06:33:26 +0000
Message-ID: <6D317BBF-093E-41DC-9838-D685C39F6DAB@fb.com>
References: <20200316203329.2747779-1-songliubraving@fb.com>
 <eb31bed3-3be4-501e-4340-bd558b31ead2@iogearbox.net>
 <920839AF-AC7A-4CD3-975F-111C3C6F75B9@fb.com>
 <a69245f8-c70f-857c-b109-556d1bc267f7@iogearbox.net>
 <C126A009-516F-451A-9A83-31BC8F67AA11@fb.com>
 <53f8973f-4b3e-08fe-2363-2300027c8f9d@iogearbox.net>
 <C624907B-22DB-4505-9C9E-1F8A96013AC7@fb.com>
In-Reply-To: <C624907B-22DB-4505-9C9E-1F8A96013AC7@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.60.0.2.5)
x-originating-ip: [2620:10d:c090:400::5:424]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 71939cc6-a8f0-4f5c-35ef-08d7cb0643c2
x-ms-traffictypediagnostic: MW3PR15MB3866:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR15MB3866CC18154ECFB2F219F1F7B3F70@MW3PR15MB3866.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 03468CBA43
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(199004)(8676002)(498600001)(966005)(81166006)(81156014)(6506007)(4326008)(8936002)(53546011)(54906003)(33656002)(6916009)(36756003)(6486002)(6512007)(5660300002)(2616005)(2906002)(76116006)(71200400001)(186003)(66556008)(66446008)(66946007)(64756008)(66476007)(86362001);DIR:OUT;SFP:1102;SCL:1;SRVR:MW3PR15MB3866;H:MW3PR15MB3882.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7a/U4LbeakrYquNOA0X8zIuSIFZgze2OGwp2oEs04sD3cgxd773oNK6DgcUfeyZn06hh0MaG+52/uhL2/3+1RODJtc3aOLzhGQnYp/4BWKfujVxU4HCj7S39wjtIeYhcufjlYLTm/YiCJPHxfc3LL4nTHi/ltusfRmMbWiZMzIFY7++ZNKGPEtjPwXI+dmNLUXgzyCHNJ3MQRKyASQj2Ppl3Y1ukMF2nh6jBCSkI9aYKQv+/tyKvz6mfO0M52THhldAdyyLc61R2KLchdAeF6AOqaC4TU6AY0sF852faf7ZgQ5qBg9jjb2gaSSGabc1Wf3mJ5xdJvuf5jvfiVKlLevado0Jj0PUuirVq7OZ3jspjGR/jsXSr5Q0vDJVlwTHrWm5n//7n/4Ev3kt3i0vslfQvv0X2Rt2SoIgBlYcBePdLFViuwhtPPGDkh8kFzNrfoJeSxR6nCsyKV9QKo1OWFC1sJS59QAB/QlDuE9PVtY62T9C/tpx6jbVPBD9hc2jqJWesmuEknNVSYa5UHbyJJg==
x-ms-exchange-antispam-messagedata: DSyoYS44zqogubJ6r6l6lgXwoVO/EzED4SNNo+rv+csyGBZdpUpCecw5fffMMTDHt2EgDjOyzq3BdlvHaKQsngCo9A7sqfHXeIndHZsFaEMU/ImfWDOPdGxKQWWdm492TooE9Fw5Ukd34oxSFWZWvva6IU+mk490WQ+e9Zb1wPw9gakuWx3P3dghfA0l7wOi
Content-Type: text/plain; charset="us-ascii"
Content-ID: <169B6318EDFAB14AA6AD6E8F7B9A6F9D@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 71939cc6-a8f0-4f5c-35ef-08d7cb0643c2
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Mar 2020 06:33:26.2023
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rU3ZjXGIiZP/dZLmiDbi3X1637bq8yUmosLedHUUNt1EZD1hFLyPYeB8iqYW6Pqun5r08lF6k7KuUBPRbkhIEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3866
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-18_02:2020-03-17,2020-03-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 bulkscore=0 mlxscore=0 malwarescore=0 clxscore=1015 adultscore=0
 suspectscore=0 impostorscore=0 spamscore=0 priorityscore=1501
 mlxlogscore=801 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2003180032
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 17, 2020, at 4:08 PM, Song Liu <songliubraving@fb.com> wrote:
>=20
>=20
>=20
>> On Mar 17, 2020, at 2:47 PM, Daniel Borkmann <daniel@iogearbox.net> wrot=
e:
>>>>=20
>>>> Hm, true as well. Wouldn't long-term extending "bpftool prog profile" =
fentry/fexit
>>>> programs supersede this old bpf_stats infrastructure? Iow, can't we im=
plement the
>>>> same (or even more elaborate stats aggregation) in BPF via fentry/fexi=
t and then
>>>> potentially deprecate bpf_stats counters?
>>> I think run_time_ns has its own value as a simple monitoring framework.=
 We can
>>> use it in tools like top (and variations). It will be easier for these =
tools to
>>> adopt run_time_ns than using fentry/fexit.
>>=20
>> Agree that this is easier; I presume there is no such official integrati=
on today
>> in tools like top, right, or is there anything planned?
>=20
> Yes, we do want more supports in different tools to increase the visibili=
ty.=20
> Here is the effort for atop: https://github.com/Atoptool/atop/pull/88 .
>=20
> I wasn't pushing push hard on this one mostly because the sysctl interfac=
e requires=20
> a user space "owner".=20
>=20
>>=20
>>> On the other hand, in long term, we may include a few fentry/fexit base=
d programs
>>> in the kernel binary (or the rpm), so that these tools can use them eas=
ily. At
>>> that time, we can fully deprecate run_time_ns. Maybe this is not too fa=
r away?
>>=20
>> Did you check how feasible it is to have something like `bpftool prog pr=
ofile top`
>> which then enables fentry/fexit for /all/ existing BPF programs in the s=
ystem? It
>> could then sort the sample interval by run_cnt, cycles, cache misses, ag=
gregated
>> runtime, etc in a top-like output. Wdyt?
>=20
> I wonder whether we can achieve this with one bpf prog (or a trampoline) =
that covers
> all BPF programs, like a trampoline inside __BPF_PROG_RUN()?=20
>=20
> For long term direction, I think we could compare two different approache=
s: add new=20
> tools (like bpftool prog profile top) vs. add BPF support to existing too=
ls. The=20
> first approach is easier. The latter approach would show BPF information =
to users
> who are not expecting BPF programs in the systems. For many sysadmins, se=
eing BPF
> programs in top/ps, and controlling them via kill is more natural than le=
arning
> bpftool. What's your thought on this?=20

More thoughts on this.=20

If we have a special trampoline that attach to all BPF programs at once, we=
 really=20
don't need the run_time_ns stats anymore. Eventually, tools that monitor BP=
F=20
programs will depend on libbpf, so using fentry/fexit to monitor BPF progra=
ms doesn't
introduce extra dependency. I guess we also need a way to include BPF progr=
am in=20
libbpf.=20

To summarize this plan, we need:

1) A global trampoline that attaches to all BPF programs at once;
2) Embed fentry/fexit program in libbpf, which will be used by tools for mo=
nitoring;
3) BPF helpers to read time, which replaces current run_time_ns.=20

Does this look reasonable?

Thanks,
Song=20

