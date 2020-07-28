Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4926230277
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 08:16:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbgG1GPu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 02:15:50 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:34118 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726746AbgG1GPt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 02:15:49 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06S6CP3D006694;
        Mon, 27 Jul 2020 23:15:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=3CZbFnop+7DKEm9ciQ9SajLhLxTkWRe589f0HZ65xa8=;
 b=lk5wPsUSzFE9FT+AAuMXijwJyRxNatOnS9pmjXDv9qnPktTjm+zm2CGUGD+8e35LfxRA
 dtN3xGSZY4wwJ4tJGlnYa33CrZDsMQQgzIojbjQZsn+ZyTZhEoTMpZiAVtGjT1PY405c
 NYGFF48vZairnI2hyQaSJDGdSxuQFDMRjaM= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32h4k284ww-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 27 Jul 2020 23:15:28 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 27 Jul 2020 23:15:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k2iVQdYs/2Toykdz5ghkVjYVNsirmtko+X2oaPlBBK+VW2O6/fYxGMqRlJSNPYfImwMp5ojE7LWc0aYiNuPU02/DkTdMkAMc9cNr+d2lofLyIOJ1v7ZhewGfv+wixLKAhRL5IlI7K7ZVwyNjmQuOHF91//4QlQpSMsiYFhcuFPqruSqZy1X7753WsM68oAEuFVC8rRZu5KficXvg9NSmGcdRIqq2Jc1hvKfnTcNEgXZK3I63bKLM8PvJqyy5GT6YCt8Y4AZnZjlD5rMBTqQHlgkWmxsyEa3EXM6S0scLudh5eoMGLRcSbP+ma1X2cBY7Ip9r85OcG28rz/wovsSLdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3CZbFnop+7DKEm9ciQ9SajLhLxTkWRe589f0HZ65xa8=;
 b=e+l6TcSPSAWgmfzptBx5lF/0Vr1R4aotg8nMsLblEje6URi5XGMfN+UfdKz+Qxgo+jATsjJKeu6BmEGZFTdFDLK4igSULa9FVWx+lBywHGYYYZSCydT6evQZGDjuIHHQoRcbhAvp0n+7nYii2Ol3f6b7jm9Kr/W5tQ93dGgIZ2VWCBEjII8cNk16lxvcaDIybi631oFVoxtpHqN3c+zhP3U/1GmjJvAv4ie4MqNe0ZLP0SFc51W7vEFRpX31lRW0D2HUq/GqnkM0NaNN+6S9UCijaAhZwNH2WPaBEkhUZw06iyeUYlnaEDkNukuTYz4agHAHD1W6gQYQ3s9n2mMFUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3CZbFnop+7DKEm9ciQ9SajLhLxTkWRe589f0HZ65xa8=;
 b=Y9ffHokUdHCC84j1uzZpwBLYhbj5gwQJ/jxX1H6Rfal3myqF6alZ1nmw7Ey/P5eHGis2dkF+pIUpS1FEc0THiLL6/xc2U0Jz6fn7PGGczaqIvtmxXQoqotq+ZFXBKYksRNjQUk30Y4X+Jtc/THo0o6YJ2Ntnpc5KEkJ9Z6fIWqw=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB3046.namprd15.prod.outlook.com (2603:10b6:a03:fa::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.21; Tue, 28 Jul
 2020 06:15:26 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8%5]) with mapi id 15.20.3216.034; Tue, 28 Jul 2020
 06:15:26 +0000
From:   Song Liu <songliubraving@fb.com>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
CC:     Peilin Ye <yepeilin.cs@gmail.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        "linux-kernel-mentees@lists.linuxfoundation.org" 
        <linux-kernel-mentees@lists.linuxfoundation.org>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Linux-kernel-mentees] [PATCH net v2] xdp: Prevent
 kernel-infoleak in xsk_getsockopt()
Thread-Topic: [Linux-kernel-mentees] [PATCH net v2] xdp: Prevent
 kernel-infoleak in xsk_getsockopt()
Thread-Index: AQHWZKEtuRyFZKlmGkOmEbeVD9lSlakcgw2AgAAApgA=
Date:   Tue, 28 Jul 2020 06:15:26 +0000
Message-ID: <F4F2AD0F-BF6D-4838-83F3-E13FA6AECF49@fb.com>
References: <20200728022859.381819-1-yepeilin.cs@gmail.com>
 <20200728053604.404631-1-yepeilin.cs@gmail.com>
 <CAJ+HfNhvM8+nfvEC2h+hjR5SGHU7_qyFkNxtiM1yjod6yVB0vQ@mail.gmail.com>
In-Reply-To: <CAJ+HfNhvM8+nfvEC2h+hjR5SGHU7_qyFkNxtiM1yjod6yVB0vQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.80.23.2.2)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:395d]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 929344c5-c5bc-469f-d84d-08d832bd9e88
x-ms-traffictypediagnostic: BYAPR15MB3046:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB3046A372A3D23D5B70FC1103B3730@BYAPR15MB3046.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:1051;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: V7a2heZIBsepSCKY6BHOH9IGCo8HJZEI1fmJ00NQkXx0/9/MHGRnUcpUpagoLdZuCWcZwIRTvlfxTLMOUG+5BXYZ2AzfYnFAIuWA4R3LC++NAtBtaiMdj87B5qcRhLhUNkXHVrDFK99SfHsEdAa5q5ooDKIYc156qfFOkz4MWb9/3rDcKkoAqNBBNSf6tCoXORH40PjTVcuS2sOnEBhFgvm5CEE3GyOxx6hyol6zR+ZvANZWl3/QsqEgnlt34qDF14QTYepx2XoDCPI9/BPeundxMHdAGL8HiC21PgO8eaV8om3p5N7ggdHKkdO1LLvVKgSkobBPcKqnwAFYmo89mQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(346002)(396003)(136003)(366004)(376002)(6486002)(86362001)(6506007)(36756003)(53546011)(2616005)(316002)(33656002)(4326008)(54906003)(71200400001)(5660300002)(6916009)(66946007)(66446008)(66476007)(66556008)(64756008)(8936002)(7416002)(4744005)(6512007)(8676002)(478600001)(186003)(2906002)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: PFWaxjt6qzjZTY7tS0OHG+l4xStRseEqXGUa9qkO2QbGxTrWrKgdrdKWsPYcS+rSG9ALX3sp5MN/XdnRGXoaThyHvKCGHePrKQAlpiNkjOqgo6Lz50JIFY1Me0o/4fOtRekwbdC/Be6bsePuVRzf/i+mkVd+vaNpcAczauQhilGYwuT/8jgIpBqDn5BJQ/SPcBPuk/Ccxp/fz+FhzfqxvfoZvVaxz4z0JwH1PoMtTxqmGuXRgipVMLAOkP1acWOnRplxofM1mmC4Lff/CMbpy078lbm0LDOCnNPBl+Vs0s8ncA1S1YntVd6SuIZeOxPkAhMYMxede9A6Vu5vOmb6anDc1FXVehPIfC1Q7ZvEvF1jikVJoF8qd4umTdAi/uzsu9tAUqqWkeQvH5bvok44uLTPMGseTuiIKp4jrFKDlr+PcSgY8awDtwDCVgnxEosYDbntGI4ixy4GXj9eXQLJd0+VNsaUnyUWFaw8Kiqq2eOEtaaHCUuOaNDpUisjvmeZP7WiGPQzZlq/0pKOCFTr6Q==
Content-Type: text/plain; charset="utf-8"
Content-ID: <2342C02BE4594148A3FD5F77939AA00A@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 929344c5-c5bc-469f-d84d-08d832bd9e88
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jul 2020 06:15:26.0432
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iCnXYNDRtn+I+OplGr5johyzec/+8rvQdUsSc5X+MFh5MBRqvvyr1HmkKkiMi6nlc183SHRqqmBOQi1l3vurrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3046
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-28_01:2020-07-27,2020-07-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 clxscore=1011 adultscore=0 malwarescore=0 bulkscore=0 phishscore=0
 priorityscore=1501 mlxlogscore=999 mlxscore=0 spamscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007280048
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gSnVsIDI3LCAyMDIwLCBhdCAxMToxMyBQTSwgQmrDtnJuIFTDtnBlbCA8Ympvcm4u
dG9wZWxAZ21haWwuY29tPiB3cm90ZToNCj4gDQo+IE9uIFR1ZSwgMjggSnVsIDIwMjAgYXQgMDc6
MzcsIFBlaWxpbiBZZSA8eWVwZWlsaW4uY3NAZ21haWwuY29tPiB3cm90ZToNCj4+IA0KPj4geHNr
X2dldHNvY2tvcHQoKSBpcyBjb3B5aW5nIHVuaW5pdGlhbGl6ZWQgc3RhY2sgbWVtb3J5IHRvIHVz
ZXJzcGFjZSB3aGVuDQo+PiBgZXh0cmFfc3RhdHNgIGlzIGBmYWxzZWAuIEZpeCBpdC4NCj4+IA0K
Pj4gRml4ZXM6IDhhYTVhMzM1NzhlOSAoInhzazogQWRkIG5ldyBzdGF0aXN0aWNzIikNCj4+IFN1
Z2dlc3RlZC1ieTogRGFuIENhcnBlbnRlciA8ZGFuLmNhcnBlbnRlckBvcmFjbGUuY29tPg0KPj4g
U2lnbmVkLW9mZi1ieTogUGVpbGluIFllIDx5ZXBlaWxpbi5jc0BnbWFpbC5jb20+DQo+PiAtLS0N
Cj4gDQo+IEFja2VkLWJ5OiBCasO2cm4gVMO2cGVsIDxiam9ybi50b3BlbEBpbnRlbC5jb20+DQoN
CkFja2VkLWJ5OiBTb25nIExpdSA8c29uZ2xpdWJyYXZpbmdAZmIuY29tPg0KDQpbLi4uXQ==
