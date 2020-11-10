Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB4972AE09F
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 21:24:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730749AbgKJUYu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 15:24:50 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:55752 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726179AbgKJUYt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 15:24:49 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AAKGwBt022840;
        Tue, 10 Nov 2020 12:24:34 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=Z5TmubdzaqVf/LtMvfL3OTQmUiaMJV+cPOYn/bbDcMU=;
 b=hqTEGaBroe610o6hEHCK2S5d1FWOQ/6hajidET5YcEkXYfMsQCOPkzlRNzyBaBLvHbp2
 SYsALZOp8MfCcaqfKpMb7Bk/xdEXFAnDmWFGtCVDNlfFo/RcXlMvV0gaR5T7WX+TiPLv
 sRpUwNuG28dnagbMMZ2IgMrBCnFCIo/KWUg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34pch9vtpg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 10 Nov 2020 12:24:34 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 10 Nov 2020 12:24:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RJiamgU9Vjp8uMkHwYlT/HfEGL95MUPfPdFakE0SlDhhSFX93Zn+1sAOkv09yvzckC6moOUjYT9+NvzMKpL2ne5/afArBHSKtNVKP9iHN9fmYWjRv/6WSOkVIX7cJJQNuremdf6C6NVngzkxkA6VC0PmEPWkHl3huNEiHxJmMdK1OPle4mdCX0zAwaXfi14FYwlia1KpSrL7QnZ84qBLo2CMqdDZvFwEA/XNfyp3x87gYWMf3Xb5wEzRZdAhNWMLDUxoCFGeqE2IEB33+2yfFqLLPSCZ0CkfYc7g5CeCz5CpELPpPInGSItDzLZD0rS+UJw6QbaAVQvDdqKVQbKuCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z5TmubdzaqVf/LtMvfL3OTQmUiaMJV+cPOYn/bbDcMU=;
 b=PlD8aiJr3toQgV0nJLjSNa5aNzsLPWxOUa0PsruKNcE0Smu7ZNBBbWA/IzgDipkiTb5951/yFOKf/omOLtSMoL1BQfSnZzIx4KJXf+TgvRmxsmnfBdPUYXP/RVnGAtXB6TJhWpB61MLkA+ENNWscrxabktXnuHwWB16wMX47Fn+PmLS3/R/JftDOd0O+zTW4mqpSjVUBc6bUQFIAo8eRnnxcRkD5xH7v1ZqCF6rJC+mdCYv7SinDL8Sg/nGEnCu9Kl8nfN67EqHD7dBiAHaBOvR7VnPAk6hmzGeR5i8KXzJEm3fgL+J2mJS0p0PfxyNd/NqnHutxAgqylGVJU/Ka0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z5TmubdzaqVf/LtMvfL3OTQmUiaMJV+cPOYn/bbDcMU=;
 b=GEkmmE/a8bZzgocNkhy3Xo0moX4S/3rCZAher23hS6+/OXKN/kV7K6Lf4TpIR31wZ3ZHFSQ13SB3+4yRi5YXEZSh8zouXWyTmEBusV/lPewYcmUeDLGptG35etqd7GkdGaOxPG47af7VJT+poRbviX4CtCr2byZiyF6tfueeyow=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2197.namprd15.prod.outlook.com (2603:10b6:a02:8e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.25; Tue, 10 Nov
 2020 20:24:32 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::f49e:bdbb:8cd7:bf6b]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::f49e:bdbb:8cd7:bf6b%7]) with mapi id 15.20.3541.025; Tue, 10 Nov 2020
 20:24:32 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andrii@kernel.org>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        "Alexei Starovoitov" <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "jeyu@kernel.org" <jeyu@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v4 bpf-next 2/5] bpf: assign ID to vmlinux BTF and return
 extra info for BTF in GET_OBJ_INFO
Thread-Topic: [PATCH v4 bpf-next 2/5] bpf: assign ID to vmlinux BTF and return
 extra info for BTF in GET_OBJ_INFO
Thread-Index: AQHWtwAGZmszHy7p70yAdAMsxZarMKnB0P2A
Date:   Tue, 10 Nov 2020 20:24:32 +0000
Message-ID: <AD242C68-00CA-4775-896F-257A11872164@fb.com>
References: <20201110011932.3201430-1-andrii@kernel.org>
 <20201110011932.3201430-3-andrii@kernel.org>
In-Reply-To: <20201110011932.3201430-3-andrii@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:1f7d]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9a98e30a-526e-468e-f760-08d885b6a214
x-ms-traffictypediagnostic: BYAPR15MB2197:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB21971F7D2D37FB730710B6ECB3E90@BYAPR15MB2197.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iHJXpVLJ+uoJEwn5f9qcYW48sfqzH9flBgodr0CvNHOCPy/zuJ6y3+R5C85RZ0VHeGIlAAxRUN1H+sDXtJvvHWWge64r/+YkyuMDm2qdtadZ//FZXb+czB/5B6hFXFfvkX00mXkXaxnZjfL8EQ83/lHc/h4H6R1QCJ4l4IR3yvVmA2XAdUPMus/URm2s0CokMSjLrfhk7K9IF5Qkl8Px6ig2WV8L3L1wWUOI1+2jU1Bu+AMwZQ5aY0EU6ConpD4cE8M6LBBG2+kfIqCWQZAkEom2YOGN9PYUCsDDbeenpxxTtumuwfqbMW/dgMg0prTtmD6nunO3A4s7J/lBOVzEhQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(39850400004)(366004)(346002)(136003)(33656002)(71200400001)(66556008)(66476007)(91956017)(64756008)(76116006)(66946007)(66446008)(2616005)(6506007)(53546011)(6512007)(4326008)(4744005)(8676002)(5660300002)(8936002)(36756003)(2906002)(186003)(54906003)(6916009)(478600001)(316002)(86362001)(6486002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: UEIN2Dfzel089COogmMc3rw0Q5ydBEXT9C1NNpj8iYy2zpj/0naF0pUEYHIxcF1Sp93/F+cuiSsZg/XO99LBTnUPO8RcwAwgUrQKH5/NXt90lvNF8JZw+Chh8KPaUY6jMCbylaXkwrO07L743+J2B2ZcMEXHviU+efo4mzbIgkfCwWeNrjRsOUGUXe+VT7XpygIzkJAcIrAYp4CHnQDagQsgJdavxDFT0wY5KV/kuvXm8xGYDzewsWMiqMcP2sVPi3iJkRDHhKkW1W2LYUSNoeDnFdI1ixm/d7lIJi45gGMp6S6K7DPAkLaPu9oaTxK9xsYsG66dV1yt0N6Jn/E5iRE7250uXCmIR/9bKSKsooSEHDrtVh6LCx2HcD0evaUrrfmr7PCCFY0JZL7v27v8k/nqIyieDKZWeaOD124WWWRVt5i7kUBjtJO6Z1mkv9vXUlAWpf9mqk5Tkcv1g5PhK7sXcscnbqgHmPOwGAQeekceLFVN0+mt06NH9HYQy+CEc1DS5rh1Gj6iwDBJj23k8EikCKweoFWfyIoeQYYSTuNFxdmXzmAQe7LARE+XPvDTDsze69rR4/F2jivO4bxwzK6L6ryngNrC77+Bhf2FKBvj2MaSQyA3Ml92KWEGG7ni1jqvFzIAESDfKKyFgfE/mC5seFhRITMMm1qAFbXAW5c2WoOvjAF1XCH7Saf5XqC+GnOf2j5weiPOiD10ngjqIE45pOuQ9zDJ/mXaBtmhUinJH8HxwVDNr4VHZ9fQyM8C2NU+hrT6T5q8MtOlmZYoPv5lseJMkfqZv0+v4v4RnAEQq7SO95FxfL7RDQE9vWOcIqyhExkDON8izMTHEOUL6PMgWh/JpzXYURsxBbpusHb+fKe7H0Hw7kBnKth0HHrWFvc57XrtcZ6LZaWcwkzAVt/yyIfHLHVP/KdVpmMGwIY=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5D3C524128F06645BFD6F6AAE598AFB3@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a98e30a-526e-468e-f760-08d885b6a214
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2020 20:24:32.2170
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mp+6uVuEIDbqn+dH8Jr2vFko714jRkWuEyBrmiuWHlenM9VaFWpxHCiINuLcNUO3uIhdafCx3okvCaOsd0zNLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2197
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-10_07:2020-11-10,2020-11-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 clxscore=1015
 suspectscore=0 lowpriorityscore=0 malwarescore=0 adultscore=0 phishscore=0
 bulkscore=0 mlxscore=0 priorityscore=1501 impostorscore=0 mlxlogscore=695
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011100138
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 9, 2020, at 5:19 PM, Andrii Nakryiko <andrii@kernel.org> wrote:
>=20
> Allocate ID for vmlinux BTF. This makes it visible when iterating over al=
l BTF
> objects in the system. To allow distinguishing vmlinux BTF (and later ker=
nel
> module BTF) from user-provided BTFs, expose extra kernel_btf flag, as wel=
l as
> BTF name ("vmlinux" for vmlinux BTF, will equal to module's name for modu=
le
> BTF).  We might want to later allow specifying BTF name for user-provided=
 BTFs
> as well, if that makes sense. But currently this is reserved only for
> in-kernel BTFs.
>=20
> Having in-kernel BTFs exposed IDs will allow to extend BPF APIs that requ=
ire
> in-kernel BTF type with ability to specify BTF types from kernel modules,=
 not
> just vmlinux BTF. This will be implemented in a follow up patch set for
> fentry/fexit/fmod_ret/lsm/etc.
>=20
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>

Acked-by: Song Liu <songliubraving@fb.com>

