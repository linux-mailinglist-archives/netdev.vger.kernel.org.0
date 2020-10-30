Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8214A29F9CA
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 01:36:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725963AbgJ3Agv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 20:36:51 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:51164 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725372AbgJ3Agu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 20:36:50 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09U0WFUl018013;
        Thu, 29 Oct 2020 17:36:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=jzyTZnMAT7w2i6nbyU83Dx/l0MLq2h10HIJzLwRHhhc=;
 b=hfHfmRzOaFvamLYpEqItaO5A8Shtgbk/eCu1CfcoSUl8yC/3MQWXD1JiXwMt4dF7Dy+e
 avOx2jENWmolWOxnrTHaurcZsJilWB2hoxP5BXee/8hzgtSUhRbioXVyhqHOJoozSzy6
 gbDgfpu1WQyMm3oZLoZGOkXFRQj58dc3Gs8= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34f0qc4863-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 29 Oct 2020 17:36:37 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 29 Oct 2020 17:36:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AM8uU5LO2TMtnix7dMibrba1Id3fyr07Dp7wYQh5aLgRCNggqP2QMCaGUkG/kcjGDd+9qUh52Mbxccc6pKuQWVjCvqD9dRaUd9l9DQf4cZogGB7dq97hd8oH8vgT5CRI9+ZYKNDFxqDI7ZDhcx6sprsuk3sQB8c61YVQ+9dXUCwhgVfv0OcN0InChXDcDUCOc6mXZ1OR2/CqBrhm2wj48jjjy+YGrcTAR5sL1vBrX+HkHkkmzc6VNmb4jKdojYaGQUbTEZb3PzD5bphNhDX80KadfeR4svKiAFo+vP8XuJmxDYtHYqJDXSu5NlXwqGQWDrgaiqzVBca026TUO/2NRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jzyTZnMAT7w2i6nbyU83Dx/l0MLq2h10HIJzLwRHhhc=;
 b=KWbIcNA05w8YOdiWsZWXUX/2xGHL3BTxwZb+BEgcEpBFLt2U3lJZKC2SBvZwv449O5hxBI/jBywsVTCC1trS6m5NUShcnVor9SvMFF5u4uMtDppsoOLQgfjCMEvgMIVFcZ6Fg1wORIflWD+fbTuRGo+v4hKIeO5YMw1TYDJaQ+zt+iLt3W+Rdbv/+S7D0qaFQzjRFMjbwzd/r+xeEgeCOoNDEHzhl6Tr3QwP3evbLnCQ2Lih8tD6ENohGfd1I1j6E8qSRu1tkpHcoGq8vecSvrXsU/2lcm9muQzs2FRZ458SNyXEF7LURYnI6eXf8mEWq5h8xhKuv+mWzzbU7TTUWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jzyTZnMAT7w2i6nbyU83Dx/l0MLq2h10HIJzLwRHhhc=;
 b=bFPzJ3rOk5+1BvNDQ0eXH1D/vHhwjl/xAH57VUZsCdW7VE78r9CmqfBNZOv6ny7sCpQy+CW76JrWTZnPvHffbwaKiuf0HjLCOdItgUcCyg7WNcQgQR52BXQFOh9rercxNSfWXZuoGSzx6oMFmcazCERs2jilnOGNEeJX7QIPxu0=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2408.namprd15.prod.outlook.com (2603:10b6:a02:85::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.24; Fri, 30 Oct
 2020 00:36:33 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::7d77:205b:bbc4:4c70]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::7d77:205b:bbc4:4c70%6]) with mapi id 15.20.3499.027; Fri, 30 Oct 2020
 00:36:33 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andrii@kernel.org>
CC:     bpf <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 01/11] libbpf: factor out common operations in
 BTF writing APIs
Thread-Topic: [PATCH bpf-next 01/11] libbpf: factor out common operations in
 BTF writing APIs
Thread-Index: AQHWrY632D0e3Vuxm0SzGN4yzfdyp6mvTlAA
Date:   Fri, 30 Oct 2020 00:36:33 +0000
Message-ID: <DC2DE38A-1ED0-4CC3-A937-CCBDBA049815@fb.com>
References: <20201029005902.1706310-1-andrii@kernel.org>
 <20201029005902.1706310-2-andrii@kernel.org>
In-Reply-To: <20201029005902.1706310-2-andrii@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:c2a2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 49f96ad1-bec4-4c14-f69a-08d87c6bda14
x-ms-traffictypediagnostic: BYAPR15MB2408:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2408DBD58F38B17FBA41232FB3150@BYAPR15MB2408.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UOVaApgurid6dZ98DKLwhaBaQQDytdS9tC4YGn/Ix1kChD0ektwSyOCM84fy73ywySA3wj6ZBX8euki/wwuey67JVLE650wO2CHZ4LG48OBVZyKm2S6CPSSmyOS+0x/gI5KzAUwzLJZaEmKN7YrXhh21AEb5vn4ZUuPfSqilFKLBBtwRJuLTypYamjdrwCH3g5szRNKBV2gz1heOGt+jh3gFNZtQJHw93clbSAoy2fssngp2EH2a5yClfHZ/DqkdIGmTs+xX50SppTIvAKjhq5dpQmcyxFmvoCFwvZmowu83jgv4DNrqj7MNpAfJcINFtSV1psnK7QyCz9UEaaGTTw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(346002)(136003)(366004)(39860400002)(33656002)(86362001)(2616005)(6486002)(76116006)(36756003)(66946007)(66446008)(64756008)(66556008)(66476007)(2906002)(6506007)(8676002)(4744005)(316002)(53546011)(6916009)(54906003)(5660300002)(8936002)(186003)(478600001)(4326008)(6512007)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: CoMcaTBLYvWe7cqmragJMpVU8kNBRmWaPNW0JyTQ22r3nbaALbCKm9OVOdBih74mD2i30q+dsRvIKqDqF7PSMzS7jVhAnAJGW8ebBxSp8SvcAlNVCOPVf+O2H7S+3Z5M00vqYu2XWBcH6yMJqBtxzsFBmTKhG6fa+DcpPWDmWbky7tSi6ZhVpJ22Gr8azTHGXgyFKTVgbiM+KL7mhgqjk5NQABY0hSs5tqpWH1p5m1QWqJNapXNqnLDA+KVT1f1MwLzC1xlKLD5J1IbhkEuQxK2R/XkHIH27J42JdIQlWHC09K2TTGDKyK0U7wDRUyu+sJmWDmu/osgTrGbeRA3CRbvn7SqhPCPK32ctA9qFZcVNUDBRxzCOB38jDYFK0ouB9faXEOrmR42pgo9UZcLaZvk8s4PBX6y0klTLKXkilj7uVIoO5hteTVhEqixjG0Ssj0Xhx/anrkXuwde4/oHEH4PVhRFD14KRjksH6dzCNqhJpYl7MFO3N4tu1dDgZRyX1PoQurNw/9vXlq87rk/XsB5RmvgpzxKzctQs+HTLkT+82nqQpkU/RMvfmX6UMqqVgQPsCHtGwu5x9Kd67d8h/afkBhoPphMtE6XD2sQrWRkaytIwNjnCfnLTLZzM8RT5PHRzRX0L82Az6aSPmPaKxEnzPGETN6V5Y5lhOmbf2KQHPCNWIyRiD5eTieHQav+Q
Content-Type: text/plain; charset="us-ascii"
Content-ID: <239BF0F2C99DE44082C6FCD78B3C13CD@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49f96ad1-bec4-4c14-f69a-08d87c6bda14
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2020 00:36:33.3747
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YMCFmyBuLO9R5hHdrzX42XSg1JDxEaPmrnPZViB1izc+dxBuwCZEPUR1jtqS7Ba1aJJrIVw1FyQGCFZ8FWOEYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2408
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-10-29_12:2020-10-29,2020-10-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 clxscore=1015 lowpriorityscore=0 mlxscore=0
 suspectscore=0 malwarescore=0 adultscore=0 mlxlogscore=699 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010300001
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Oct 28, 2020, at 5:58 PM, Andrii Nakryiko <andrii@kernel.org> wrote:
>=20
> Factor out commiting of appended type data. Also extract fetching the ver=
y
> last type in the BTF (to append members to). These two operations are com=
mon
> across many APIs and will be easier to refactor with split BTF, if they a=
re
> extracted into a single place.
>=20
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>

Acked-by: Song Liu <songliubraving@fb.com>

[...]=
