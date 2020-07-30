Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 612B8233A5C
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 23:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730502AbgG3VOI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 17:14:08 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:18006 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730292AbgG3VOH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 17:14:07 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06UL9D2t004637;
        Thu, 30 Jul 2020 14:13:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=NeXPWc5EQ2dlpSXiUknWzNZimjEqy+lXBwRH5Yl4+Yk=;
 b=E5lhP3g3bRPbAV0omLkzTM5w4r5NDbGGM1H6gbeUuNhNONxPgz/gt49xW+dKfTsEUrwO
 NZL9DhSNTwr5qrYRFjlw0PaSq9tBk52jx+rfIDjh/Rhrq1IB1gRnI00qKcdWg9aLDU1e
 BbQ/KRUUGxIvxHuX2m+c7M31GWroIgCpL3Q= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 32k7hw879r-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 30 Jul 2020 14:13:51 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 30 Jul 2020 14:13:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fR/SCSZE/6h8bHVievnH1uM2w3uqIENugo1eNNRcEdjJ7eTIrt3jVWxGrVoOBlOHdNLStbkEAAGPQjOgTkTGTfnr5wL5ve2rf4zh3j05ZjpwPwHVMMDRSU13nnX0y+5nHM/5I6wYDg88KqCy5dLX2ok8++s+JUMEeB3qGsFNyOaIQaopjAN1deyTrhwcw8Kv7LqHo0FJm70E1/XlszibB0g7rKtiuKvNqpUer+e3qTPrbWP5VVZmWtQr1fOLkLK8WD/TSVAv0ZNFCi0lJ/oQTh151ue2vumP07j+Z0zjUplOSUXHrVyrKpUQa/UbwBKG3Ap1oyAopNNkRiTckL73LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NeXPWc5EQ2dlpSXiUknWzNZimjEqy+lXBwRH5Yl4+Yk=;
 b=DG5I0hgIm7RVXXJqwR4UF7C5ZSK7zt6ZOqhD9R27iL1fFWTZOGU4Tg7XvgzoX4wsnoaAr3YOWXW28huz846d4Yy3UQAZrnDEIj9WvUAUyaIIZKz7lp8Kj5SGO3XIAFGRIsFdHwO4KS9KSxyV6ZNYC2u2wV0or8Rc0gIyX1P7FhlbmqXVXMfkkITi7Wz5EikSTqIevhOBk7mE4NykSUsx0SSUucDNd5pXedrMxu4hHRKlID37v2K2eEl41IY30XJxyQ6mBmMWW1QMF+/M16Au7urwbtfmuQdvPK2r1oEHLnGjmpxop43R82xgANoz5qTPtnDPEArmqsQfRyE66GT7aA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NeXPWc5EQ2dlpSXiUknWzNZimjEqy+lXBwRH5Yl4+Yk=;
 b=FulpDj44xKCH7J9tcoVzdUW1WKwaFvlKbOvyS1CY2fE/Zaotjas6xQFGSC/vH/LY5caUXChdK+DL6x+/Vhcamp4N5ihkr2orOFWw5n/wtwDuq8uLszKAlxAt3Pm+HCtfZmvmldXsNCk0I6TuetNZ3H0IHK6RTWVxoP/jAOfOQu4=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2246.namprd15.prod.outlook.com (2603:10b6:a02:8d::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.19; Thu, 30 Jul
 2020 21:13:47 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8%5]) with mapi id 15.20.3239.020; Thu, 30 Jul 2020
 21:13:47 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     bpf <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>,
        =?iso-8859-1?Q?Toke_H=F8iland-J=F8rgensen?= <toke@redhat.com>
Subject: Re: [PATCH bpf-next 5/5] tools/bpftool: add documentation and
 bash-completion for `link detach`
Thread-Topic: [PATCH bpf-next 5/5] tools/bpftool: add documentation and
 bash-completion for `link detach`
Thread-Index: AQHWZfzjf8qCBt0Ndk2N70dqiVdn66kgoKUA
Date:   Thu, 30 Jul 2020 21:13:47 +0000
Message-ID: <770B112E-DBDF-4537-8614-765D19EDF641@fb.com>
References: <20200729230520.693207-1-andriin@fb.com>
 <20200729230520.693207-6-andriin@fb.com>
In-Reply-To: <20200729230520.693207-6-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.80.23.2.2)
x-originating-ip: [2620:10d:c090:400::5:395d]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0cebc91a-39cd-4374-29fd-08d834cd72f7
x-ms-traffictypediagnostic: BYAPR15MB2246:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB224691690577F6FF2E240DCBB3710@BYAPR15MB2246.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: I8vBNfXYIolu14pUBfh3A4fv/0pbFFeES1bQod7sEh2ARQ5VBJul2WhtGeQrGuXS3DkL/kd4DHHr4+VshbBN67tH3mrI1BFZEdN3eq06YkYnPK7jTSK3+jZyGYsuUP1tjhdz8TsEDn6fwA3Txcm7sOOPuGhB9BkyizPT/ipcipxZdQN67adZbYiWEV7qG3L0bWLFxt6RJqowgmgEyU9mcCwKU4GDqhmPhwFync7GaTJXUomQQA6vh8ADnymNiOpg4sqM1RfOEohP7p+Kf9yD1RkuWiUazQ+z6YXX8bcfLvUwHDlX2FKlg06TRfRZVWPMjEXiopnJU7TB1ii9qyml3F4tp+cZOR9Tdy/3tQA8NwbCXJBWJYd2j4qQsRJ7IlQx
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(366004)(39860400002)(396003)(346002)(136003)(186003)(33656002)(8936002)(86362001)(6506007)(2616005)(53546011)(4744005)(6636002)(83380400001)(5660300002)(6862004)(6512007)(66446008)(66946007)(4326008)(316002)(478600001)(71200400001)(54906003)(8676002)(2906002)(64756008)(66476007)(36756003)(37006003)(6486002)(76116006)(66556008)(81973001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: +yVJEpYJpqWvpHL8y56ywUgBkoeBpnYGfPvHIxVbxiDLe+6A2xblWLu1tTSV7XT3BppZPv5x33I6JkdJnaJaq0pG3BuMDzol5nnjqS1thO1ZfjY2n3yLu+yNEyXfnv8LQ7ShEO9xFVClz0V/Ot2V1Vs6ABhxkFF6zHvdmk5h1kVYQ8ynKzQY5izSK0Tn/K2QeqdvuddTxEjtZq5R9sqSZscEw3qbtfJEure3D9jqZo2+7SKTZEP8P0LDmSr9pih+hp5TF+XmCmabPWSAOouy58sbi5qunRK29taQelGYy1LGWiAKpTVMgLwMCOtSl1z9eVcOwqqhKh53qsYthufin1S1L73vOh3u3L3VC1Rystfqx8NGTqozss8m2nc4Ssx90N3bfTqAUw4LddTRFV8WujaW8EMAcrlGsvQ9d5I88JMJEiukeoCQwaWDUVK+oHhzkZ8sylHeoXNQJZ9d+nA7IFjm61K4k3drgzNxnKcOa+JhMVid5YFHa0hUNGrv04qdEUqj1shVrBCDhG2QJ8HK7uYN4xjHb8UXPz0UDBm3FiBhd00HonyHb1Q4MYzSsja560arcEXn7PmqYQXdpqsjeuiHQOemwJC4s7Wq+lfUATAZIVTCZzw3Akawq7yFq0Z2QaNWOOWPqVE/yIj0R2v08WPP/lBtu/SI6XSlDunaG5zaJiB43ekfXnNRlkbfIYeL
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <E193684A0D15964BA8AD89F32752BD9A@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cebc91a-39cd-4374-29fd-08d834cd72f7
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2020 21:13:47.3536
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vTLPiiUQUPI/oP56Xu6DfX+NYu6/YBsDvc2EgHJApIsa9tvTYTFr4w+tdhGTfNnqbETjvKwUc/QNTFwmxosLEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2246
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-30_15:2020-07-30,2020-07-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 priorityscore=1501 mlxlogscore=999 spamscore=0 lowpriorityscore=0
 malwarescore=0 mlxscore=0 bulkscore=0 phishscore=0 impostorscore=0
 adultscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007300149
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 29, 2020, at 4:05 PM, Andrii Nakryiko <andriin@fb.com> wrote:
>=20
> Add info on link detach sub-command to man page. Add detach to bash-compl=
etion
> as well.
>=20
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>

With one nitpick below.=20

> ---

[...]

> @@ -49,6 +50,13 @@ DESCRIPTION
> 		  contain a dot character ('.'), which is reserved for future
> 		  extensions of *bpffs*.
>=20
> +	**bpftool link detach** *LINK*
> +		  Force-detach link *LINK*. BPF link and its underlying BPF
> +		  program will stay valid, but they will be detached from the
> +		  respective BPF hook and BPF link will transition into
> +		  a defunct state until last open file descriptor for that

Shall we say "a defunct state when the last open file descriptor for that..=
."?


> +		  link is closed.
> +
> 	**bpftool link help**
> 		  Print short help message.
>=20

[...]=
