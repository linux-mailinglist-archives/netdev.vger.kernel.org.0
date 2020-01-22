Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1187144C1B
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 07:56:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726083AbgAVG4j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 01:56:39 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:31088 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725836AbgAVG4j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 01:56:39 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 00M6r0oP010251;
        Tue, 21 Jan 2020 22:56:23 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=XF/R3RWS2Qk0Vx5H3/71534FEBz+x8vPByXm5KbSZOs=;
 b=MJ4FrHrTZyIo/FboWHNfAEYCw761SAOr3+Y06KPKIJ+/Y4iNGqAgFfkBaLih/q75UKDd
 eZmW8uPgu92VDxYxpkTfi9DlC+XN7FLZHrMDRG/erMuryQgC7lr4rRWqTJx/jsztZgwu
 /2YJitO1HTE4Xx76Z0WABzovhu1GGKC2mN4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 2xp5vs2wg4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 21 Jan 2020 22:56:23 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Tue, 21 Jan 2020 22:56:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aPVYRJV4MMtUscWRAZBjJTdhax8Gw4NjuBd2kw0NJ5+FmORKFF2vx7PCWarlIXkFwcMnewjyQYgC2kapYtaQxbBiXf2FRcnf/9bvd1krlrRvbEqtxRNPfVS58MYingmCOq7M2Cmnmm8Ae3aC+7XTmb5ZJ1BFicgx746IKwVHtU61douwdqVeBMSLPdCK1kHawAWt1M9uZcIQLe5xqvrm2VoRhxwcwBfCvTYkHso6PCLpSODp+a1xhtrhOYOQTYLAzKD59QCdep0PtbTXwsRye4oq+B8I/ehOBy7Mzubvi0IDoyvBQggqwktik+VxZVbkqEHvj+w2Xhb5F+MFA0+wYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XF/R3RWS2Qk0Vx5H3/71534FEBz+x8vPByXm5KbSZOs=;
 b=oYr1F12LlCqzuIpbgHG8L8fMA8sO8lf3KLTepG3GyJUsbOUVLxQHJS2Dgn5tBXpr46j+Pmia9yQVE03goeG9HCBQ0gfd5cotONCuNRASsW/arUcG36xArqSI2HMIMNwxf3DwyalnC3EJ5DYEKcyF1YpG/3UEBuCMVkV1vgjz1owHLWz5dQvR3FrhPQ7opkxtSAVvw1b1KgL2Ql/PCF6Dqvng7FNnBEB3FzsiQyx3IZulba3IkFi7W9cZruAChdBAWHBs76nn+IDjditfjjaXGr0y8ygxBe+5FR+vIFupMBHXdALmNIzJwqDB7SJFyfL5qOqrLCCX93meEWfggXMOOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XF/R3RWS2Qk0Vx5H3/71534FEBz+x8vPByXm5KbSZOs=;
 b=Ix8qvmw6O7ma0K6OyZeBJegRknzgnqfMtr10EvIiYVC/KV74m08wxNNMrl+tGCcjDgKRuG4igDgh9B79bXtWopQ7ka+4+M+OHMvMBCoZvJ0I265CqoqP+2dE6s42elvudjWnQoxLv6EeSUhMxnE9Zr9adV+i8obUcMz7KBPOXCI=
Received: from BYAPR15MB3029.namprd15.prod.outlook.com (20.178.238.208) by
 BYAPR15MB2888.namprd15.prod.outlook.com (20.178.206.207) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.19; Wed, 22 Jan 2020 06:56:20 +0000
Received: from BYAPR15MB3029.namprd15.prod.outlook.com
 ([fe80::3541:85d8:c4c8:760d]) by BYAPR15MB3029.namprd15.prod.outlook.com
 ([fe80::3541:85d8:c4c8:760d%3]) with mapi id 15.20.2644.027; Wed, 22 Jan 2020
 06:56:20 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Network Development" <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next] bpf: Fix error path under memory pressure
Thread-Topic: [PATCH bpf-next] bpf: Fix error path under memory pressure
Thread-Index: AQHV0M2GROG4xMx9sUistlcFj0TlAKf1+nmAgABGBIA=
Date:   Wed, 22 Jan 2020 06:56:19 +0000
Message-ID: <FD587CC6-F007-4CF9-BECC-6344586EC8A5@fb.com>
References: <20200122024138.3385590-1-ast@kernel.org>
 <CAADnVQ+HdfXVHnEBMkqbtE2fm2drd+4b8otrJR+Qkqb3_3OGdQ@mail.gmail.com>
In-Reply-To: <CAADnVQ+HdfXVHnEBMkqbtE2fm2drd+4b8otrJR+Qkqb3_3OGdQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.40.2.2.4)
x-originating-ip: [2620:10d:c091:480::e38f]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9e9fb9da-15e1-46f6-2478-08d79f082f6c
x-ms-traffictypediagnostic: BYAPR15MB2888:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB28885A674F2219138A5CAB28B30C0@BYAPR15MB2888.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 029097202E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(376002)(396003)(39860400002)(136003)(366004)(189003)(199004)(6486002)(186003)(2616005)(91956017)(4326008)(36756003)(33656002)(66446008)(6506007)(66556008)(66476007)(53546011)(64756008)(66946007)(76116006)(6916009)(6512007)(81156014)(81166006)(316002)(8676002)(54906003)(478600001)(8936002)(2906002)(71200400001)(5660300002)(86362001)(4744005);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2888;H:BYAPR15MB3029.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VJP1IpDENrSeSTIEW/9exSnZZwlmiYwFafNW/N4AfKvZYUYqcF7fF8sWdiaafYw8z8on5o516tfd7nYo0Oo6ttCnuSNHNB7S+ioMVJ8j2wInE6tGdWO0Udh4JxkwIlV1MwvSOWMNYEcrr4Ly3jyVqNstNDYe9ufU+p6dJk74zOz7JWwULkW2n7LiwEIw3420GYGtIQaJO2OHwGbuYo/CT6GRxVPIu9pDO5IA7tgXf1q0WLRcw/zYv+sTXlkvydDaVb3DLkU0D+3mWQoPe+R0cvEQsCYzpM9vwuY3w0GI4optgrKTlDr2PKjn5DKqgN5H0VESB++hVrFr93iSgRQ1rjY9tIYtjBQ1m/oXrIpKICUCmC/fIJzRCqXXKqO1bBpzLJMDi1sk718v1Ya98AvIbZwdC4DCFCyyhlheV9ip6TMelV0Agh0SbrdGRDoMI123
Content-Type: text/plain; charset="us-ascii"
Content-ID: <290A2B67117FD443B5B85A60F2D16475@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e9fb9da-15e1-46f6-2478-08d79f082f6c
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jan 2020 06:56:19.9446
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: F1bI72nCeY1lQxX8Zj2qN9lEygQvFWKNlVz3xrUGVbkabhClW59J4NgaYoiPZ5wdI+idkIap/j3rm0QyW0lm1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2888
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-17_05:2020-01-16,2020-01-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 clxscore=1015 adultscore=0 lowpriorityscore=0 mlxscore=0 mlxlogscore=657
 bulkscore=0 spamscore=0 malwarescore=0 priorityscore=1501 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001220061
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jan 21, 2020, at 6:45 PM, Alexei Starovoitov <alexei.starovoitov@gmail=
.com> wrote:
>=20
> On Tue, Jan 21, 2020 at 6:42 PM Alexei Starovoitov <ast@kernel.org> wrote=
:
>>=20
>> Restore the 'if (env->cur_state)' check that was incorrectly removed dur=
ing
>> code move. Under memory pressure env->cur_state can be freed and zeroed =
inside
>> do_check(). Hence the check is necessary.
>>=20
>> Fixes: 51c39bb1d5d1 ("bpf: Introduce function-by-function verification")
>> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
>=20
> Forgot to add:
> Reported-by: syzbot+b296579ba5015704d9fa@syzkaller.appspotmail.com
>=20
> Daniel, pls add while applying.

Acked-by: Song Liu <songliubraving@fb.com>

Thanks for the fix!=
