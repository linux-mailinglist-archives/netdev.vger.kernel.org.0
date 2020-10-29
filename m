Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 242FC29F8BE
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 23:58:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725950AbgJ2W6D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 18:58:03 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:3098 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725379AbgJ2W6C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 18:58:02 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09TMraTJ031147;
        Thu, 29 Oct 2020 15:57:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=N1QMs2Z+6gUU+hn6xK3so9SFJxytUgzDK0FQqZYvxjw=;
 b=k+uOfaZU/Wz6W112/4eC4DECCpyAkzwygM70/DgqbI/KLzmVnLMTw+LNJhW7kcrojfnU
 LBAdHdl2oz4/600gS42bxIWT2eW/4mSDAOabauVu/eZdICFcTkZdJrR3sRfGx6PlttX8
 WwaUqcIZF0iqc96DWFiPjZhJDmE0hosN4wA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 34f7pjjebh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 29 Oct 2020 15:57:44 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 29 Oct 2020 15:57:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j2uxp9kmis8RWZlqbMOSVMr14DzvHAEWQ+14AssUYEEv+hekdMYKUQtMYs/Jm+plVSfdgJK/ygCXHWpw09gx7QE3GSsph8gTXl97Tq2O5jkX312TeYW0l9hnmdZF8buKQqPaQ/zrALqxuwP+6SHb8rAySjMA0APG6WCUiPg5wxH1Jf9ffJ+vsfjUzb+j6Zu5Yha50JmjniT+VBe6tNLfrCRIaeSJj1HLgH7b2eU0UO6y6uTzI4rYrdmCgXMJi8TJ5p0Y0QozoRhs6Vu8BvJQdxFehcCNyCfD/jsTwxJ6N2TZq2qgt7/+1zViewSTszO2zUHkeHnrvhJC13/UILt0Gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N1QMs2Z+6gUU+hn6xK3so9SFJxytUgzDK0FQqZYvxjw=;
 b=RILkg0MpELaGlRhiaaGC3LVFRIKa+jVBqrzy7+0DwetGPs1pXBjk+D0h7HyIPd/cNiqbvLK84F/QzI6w1+n1nxuMlpQ5zS6M8paY0PVaSW9xtBN6VUNyxFBuWoU9cRIuWVNkwk6trtFM0G+iCjnYCIMlVLajZlcDE5kq9UKhrWxfjTs1USyfNgCatx4UzHwvdp/88Y4xL+2BbyeVYiFlwx2Vza5WJPTaJVVVgKXIt8jT+59ds7MaHd5Skqj3ToZu+xccdt3BhV7FrWTJ6xlvDQlOMnxBEJ0/tc6/zH87vyLJObQZPyrBgXJGcbCsxW4HCmfITeDa8gFoIgLsVpfMWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N1QMs2Z+6gUU+hn6xK3so9SFJxytUgzDK0FQqZYvxjw=;
 b=kf39UsIG2SZxfxTG/tE1WsMQULckIgkTs+StqK/CsJ8/LzxwEWrvYp+D09733DzelarZtvKaTgGWapU1lfZA3hTxLHb02uCnC+mfO0n89JzUWHfwFw70MZ7CDhe8w3y0AAsiN+fI/oHWyObf6igYzAQ3xsaC75jwphSp1gU2tWg=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB3254.namprd15.prod.outlook.com (2603:10b6:a03:110::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.27; Thu, 29 Oct
 2020 22:57:42 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::7d77:205b:bbc4:4c70]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::7d77:205b:bbc4:4c70%6]) with mapi id 15.20.3499.027; Thu, 29 Oct 2020
 22:57:42 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Ian Rogers <irogers@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, "Yonghong Song" <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] libbpf hashmap: Fix undefined behavior in hash_bits
Thread-Topic: [PATCH v2] libbpf hashmap: Fix undefined behavior in hash_bits
Thread-Index: AQHWrkQcbGvCsMR2DkaqEAjiMgI9kamvLAUAgAAFQYA=
Date:   Thu, 29 Oct 2020 22:57:42 +0000
Message-ID: <8A7F0E86-9A11-4ED9-AE8A-881A5A260DB7@fb.com>
References: <20201029223707.494059-1-irogers@google.com>
 <CAEf4BzaX4KT5tOn9gSR24OtrX8MT3yW2yfTq244ewnRouWDJdA@mail.gmail.com>
In-Reply-To: <CAEf4BzaX4KT5tOn9gSR24OtrX8MT3yW2yfTq244ewnRouWDJdA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:c2a2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 978ceea4-109c-4e05-3d17-08d87c5e0ae1
x-ms-traffictypediagnostic: BYAPR15MB3254:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB32549BDAE88850F58EBABF6BB3140@BYAPR15MB3254.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4vALZQ+Aeyg/sPxzbkgHSd/FHLeHwGBE+zYeaKkzf625/ZRDGSnjZXCFJ5nZT2F4yCuUvpIXQMFUiBTxmNJcKKNjIoRD+HsSMBZkA/LOdyGCWYgNL9ZNVFH5ciVQimieEIOtXvwBDq1M1rhtC+MOUswyKcFosqVLsqiTe0cTpD1ygVIlayFTmupEcqaewSMcqr1Ntm6Znj/2bovcks/3OhWig3qkQTdXZ4/S8naeOFxtx77/KA+QwroRpbKDMkTAa4KjIurxYb8FzPPDgFhpp1jNktOmJ6J9TLQV+S7P0C6Ftg62OhG4FC6WM9QfjNwE
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(376002)(346002)(39860400002)(366004)(478600001)(6512007)(86362001)(6486002)(186003)(316002)(4326008)(6916009)(54906003)(8936002)(8676002)(36756003)(71200400001)(6506007)(53546011)(2616005)(2906002)(66946007)(66476007)(66556008)(64756008)(66446008)(76116006)(91956017)(5660300002)(33656002)(4744005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: QiwUnjFyg5SUPO5MpI3TI2PLRAa0jDWhSA8qMGsIpaAkLBQLn3I0r7mBQ0XITK0/yeCy9qjFrHAB0eTdRqj6uxNZl3hLJMANdy4fptGSPPupLqgxVzMXBxc/eG+iY2nnKx8tsBPbdaoEx+RJmqnKxv92s9qGM7vTcPM2bSlpWFKzBvP621GwM2prtLdHGvGB11AUWWJaO2QR/zUfteOIpp3ZRsgyIv1rbBd4QripCWaiLQ2yWoCmuBxVFI32MDhN3OmXqAosEX6I/pexI5PkcsXQ6UqTPWWo0CrnnKA3Wbl1GLE69X7uuylZvxaE1G5SDyBtBx8dzz1Tkm17flcnpVHgLTXRrTy/vjp8UskWp1NFE5rCZGyqvMCWeWjL5vVy+HNYnRNWRuUPgvUXB8GzAbffqcLP/ZkSdQeoPro53OCUY3MmuE+kC6avz1cganQtcK8Oc8w8+PdvlJuF2L472zTzGPycNWBykHxsWsgJRlO/KKiEubJ/IH/D9Pw8cOEZzyc4EG8glfG5Jr/3i/ER2+IHhKL9TFWDofmLy5tb7wYeiWt3NrZxHeIw16DxvI0vvOZrtFgTYsrOyUIkN6I2q4TvQvgosfpECc+MkpmTD9mI58XPZTUt8sIBERAzN+ylSB1e94VtEBVI8AK28hnVJIitXJwe4puHHwiY+H6zZQQ97Zr5kMqz67qgbPguTkA6
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1214202F9591934F803C75400C4E3847@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 978ceea4-109c-4e05-3d17-08d87c5e0ae1
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Oct 2020 22:57:42.3129
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Oe/4pG8GJpFcRZhTYTFGCqmeVyzAu5geCZ8Q8AQIIqBosT+oNWwYEsm9EE5Urjo6lYQNDBiHHimQmuYaZszFQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3254
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-10-29_12:2020-10-29,2020-10-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 adultscore=0 impostorscore=0 phishscore=0 priorityscore=1501
 suspectscore=0 spamscore=0 malwarescore=0 mlxlogscore=969 mlxscore=0
 bulkscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2010290158
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Oct 29, 2020, at 3:38 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> =
wrote:
>=20
> On Thu, Oct 29, 2020 at 3:38 PM Ian Rogers <irogers@google.com> wrote:
>>=20
>> If bits is 0, the case when the map is empty, then the >> is the size of
>> the register which is undefined behavior - on x86 it is the same as a
>> shift by 0. Fix by handling the 0 case explicitly and guarding calls to
>> hash_bits for empty maps in hashmap__for_each_key_entry and
>> hashmap__for_each_entry_safe.
>>=20
>> Suggested-by: Andrii Nakryiko <andriin@fb.com>,
>> Signed-off-by: Ian Rogers <irogers@google.com>
>> ---
>=20
> Looks good. Thanks and sorry for unnecessary iterations.
>=20
> Acked-by: Andrii Nakryiko <andrii@kernel.org>

Acked-by: Song Liu <songliubraving@fb.com>=
