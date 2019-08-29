Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30D42A2792
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 22:03:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727859AbfH2UC7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 16:02:59 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:56196 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726661AbfH2UC7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 16:02:59 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7TJxHb1018880;
        Thu, 29 Aug 2019 13:02:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=k2TP2JCKm/fxigXu8Kl3tu/gg16wm9N7SOdXhTdAxrs=;
 b=oukvk7vrHFyVAmi95bSbMxxHH7JlcOHyvgyyDgh/DF4DXWwgf9ChGzH5IQ7v0kEsIbwH
 TXeb8R80DQkDx+7hmW0CU8AIXYQWoUDUlXoTq4rgNJtBLsNOyMgfsWqxOj9cHxt5gG14
 iytXE35M/TKx/AW2mpUuWtJpDQIrnRqGQ14= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2uphm7195g-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 29 Aug 2019 13:02:36 -0700
Received: from prn-mbx06.TheFacebook.com (2620:10d:c081:6::20) by
 prn-hub01.TheFacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 29 Aug 2019 13:02:34 -0700
Received: from prn-hub02.TheFacebook.com (2620:10d:c081:35::126) by
 prn-mbx06.TheFacebook.com (2620:10d:c081:6::20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 29 Aug 2019 13:02:34 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 29 Aug 2019 13:02:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=el8HYE09aAjAQ6mfZc4VSlobIUnsVROdurdi/1sASWI9cV8cIRVKR/Yt4zFdUcgRRKf4aAt3L/p09d3ORDVO4NK84OyzFkgbLtUIL72sb+S7SJmOL/8MNj+J8chtWKCQJE9NFgAJDndjtf1fPeQEq+78+7X5dRnN2QYVQgFB7wrabxlEG+fr3NSmd8RLbbCJ4ZWqLPuWHqMzjtdNSUScFI5TL0cYBCeAJz6teZ9aerKAERjwf2UBDI38nwp64NFJOd/nIZdRK5vbkM3BszlI7YYnIxhBB+zR4JUgH/VTeew7Eqn7XW7+pH3um8+kftVUFHcjkpn2UGSgq+0LrhAvIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k2TP2JCKm/fxigXu8Kl3tu/gg16wm9N7SOdXhTdAxrs=;
 b=aS9nsUb9vc0fWXAamrOTBct8o88RAlp6f9GMvM7hQRxJbzfxX/2zapZAowE4E7myf8J9SOGyepQHdiYfh0e/p/EBJ8eYx3Yu6rkJpYM7406rTCnpocQI7yk8hhNxAnZzCIHrz4BwXETHpD0luWWrSq/nCFT/fb6EwDiMA3ZPiZfWajXOMlyHOL+5i3eddzzX0o0FA3mwRMTyp0Fi/piFKVdOiLUg5TosFK2y/hMwaloTNtul0wevKag06NwcAnSYJ/v1fNOI8OuJfTvWsFaU0P847IGb32xBcDyc+vgVwHaqKTOLOiZ6raExjfOXD4SDQY31xufDhujcwe8kgtCZ1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k2TP2JCKm/fxigXu8Kl3tu/gg16wm9N7SOdXhTdAxrs=;
 b=K//Btvv3DwFRTex08sF9jgfF+a7gnMW2ocq1Exgo7Nod7P0Gh2t2ZkTWAKS7QGfTW3zWC7VP+EGFsNxjKnxlC2J+2b+NNJPnM4/XA3JKWs2Em4U5CUmvvRYm3rEMz9eXtKTozezuC5Vr6oG8SMbxouSMrZZSf62KOJqyK+VX68M=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1421.namprd15.prod.outlook.com (10.173.235.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.20; Thu, 29 Aug 2019 20:02:33 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::45ee:bc50:acfa:60a5]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::45ee:bc50:acfa:60a5%3]) with mapi id 15.20.2199.021; Thu, 29 Aug 2019
 20:02:33 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Anton Protopopov <a.s.protopopov@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, "Yonghong Song" <yhs@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH bpf-next] tools: libbpf: update extended attributes
 version of bpf_object__open()
Thread-Topic: [PATCH bpf-next] tools: libbpf: update extended attributes
 version of bpf_object__open()
Thread-Index: AQHVUvz4yT9fypjbn0OKIVyRaBIXqqcSo2gA
Date:   Thu, 29 Aug 2019 20:02:32 +0000
Message-ID: <796E4DA8-4844-4708-866E-A8AE9477E94E@fb.com>
References: <20190815000330.12044-1-a.s.protopopov@gmail.com>
In-Reply-To: <20190815000330.12044-1-a.s.protopopov@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:200::1:3161]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d2a9bcf4-1af7-4ec3-e8cc-08d72cbbd46e
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1421;
x-ms-traffictypediagnostic: MWHPR15MB1421:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB142156B0784DA2CC916FF003B3A20@MWHPR15MB1421.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-forefront-prvs: 0144B30E41
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(346002)(366004)(376002)(136003)(396003)(199004)(189003)(66476007)(36756003)(7736002)(4326008)(305945005)(25786009)(6116002)(446003)(11346002)(2616005)(476003)(486006)(81166006)(256004)(8676002)(50226002)(186003)(81156014)(46003)(76176011)(57306001)(6486002)(6436002)(8936002)(6506007)(53546011)(102836004)(33656002)(53936002)(6246003)(6512007)(66946007)(478600001)(14454004)(99286004)(5660300002)(4744005)(86362001)(54906003)(71200400001)(71190400001)(6916009)(66446008)(66556008)(64756008)(316002)(76116006)(2906002)(229853002)(101420200001);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1421;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: TilntxDhr4RxByXeD5VTG4D9MsPOP+RUgcH82zJlsa6A4WHh3ZeTXA9hkDFe04RdFRO7LQgxThH3tBbq7CaWVa4UgsMOxZnAVA6gb4B+GxDIL9nKZEpsLEy+k/Xg4aELDaJTojM+3MTdHurzm7BHEvLqQHoE5heu2eqJhqJrJ6QaF37SjrAALjdJIq/KUgecQf1nr/cySCR5hlNjJlnyMEiX90wPk8+QPHq6B6k+Y/acAWsIW4oN0GyphW0Oa7ejJNnPCfadEFj6i4GeKgKAeJ28F7OPudS2NuYWDendeks/ZQVMIW+iL1SIpxAqr03U4swpmrbOLjLA3KW2MQQ6RUvYNyZ0CgM9d7vVpuv0A1NgiE3x2XF1jWs/e2tNWN+T01aVj+y/LMIFBq7w6nbLIaWENjCjvGOXS9aAWugvxMc=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <18C5C75756CB7C4E90C79866880BC4A9@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d2a9bcf4-1af7-4ec3-e8cc-08d72cbbd46e
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2019 20:02:32.9689
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rD5T/YyFq/dR3XMcoIyanQkxE3VKPGTBEUbgVCuJE9T8QYARiSGV/37kvSixCLxOjUkFBxKREJ0m5U4M/GEzfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1421
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-08-29_08:2019-08-29,2019-08-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 lowpriorityscore=0 malwarescore=0 spamscore=0 suspectscore=0 phishscore=0
 priorityscore=1501 mlxscore=0 mlxlogscore=999 adultscore=0 impostorscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1908290200
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Aug 14, 2019, at 5:03 PM, Anton Protopopov <a.s.protopopov@gmail.com> =
wrote:
>=20

[...]

>=20
>=20
> int bpf_object__unload(struct bpf_object *obj)
> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index e8f70977d137..634f278578dd 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -63,8 +63,13 @@ LIBBPF_API libbpf_print_fn_t libbpf_set_print(libbpf_p=
rint_fn_t fn);
> struct bpf_object;
>=20
> struct bpf_object_open_attr {
> -	const char *file;
> +	union {
> +		const char *file;
> +		const char *obj_name;
> +	};
> 	enum bpf_prog_type prog_type;
> +	void *obj_buf;
> +	size_t obj_buf_sz;
> };

I think this would break dynamically linked libbpf. No?

Thanks,
Song

