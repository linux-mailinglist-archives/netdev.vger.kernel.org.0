Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B36AC134B65
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 20:18:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728957AbgAHTSY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 14:18:24 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:49010 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726989AbgAHTSX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 14:18:23 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 008JF8vV028808;
        Wed, 8 Jan 2020 11:18:09 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=Ye/BjGH1qzmtfGKeBdOVyMyMuC4tYxr9M7JUZDuBWOk=;
 b=juIqJSa8gP0EwN1BrV3TNVkiki3YyLFl7baM595CMcFD+FHPLxpOGwsVeW28EHSq6FWW
 9FdUlY6+aDepdFaLWNManAaKd18H5cF8aR6KM8QHQRmIsg9IcxA73znE7m7OnoCgy57L
 C1UICpQSxmzZ3C9WTbQIyi2rS7K4/5gOjKo= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2xd5auvhyj-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 08 Jan 2020 11:18:09 -0800
Received: from prn-hub01.TheFacebook.com (2620:10d:c081:35::125) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 8 Jan 2020 11:18:06 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Wed, 8 Jan 2020 11:18:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tzp1JAPpWW+P3VzdAHZUMlee5HuyoYfhMmw245MwzNiB5kDo0ebihx3zfz7u2pPJQnEdpN4tnimHCU98Dk0NKG9Xuv3BGbM/Ts5JfC378Fwh1BbYo3yiOvCbLsbYjwqqD0S2lVWuQUTYEG18lZZckZPIWLiiCsm239JPN8u1M1gfaJnKV5P051eHuBuEU+aH0gN0AznXuKnVwj2T+PwgI14eCn8OmCGNNDRe7niG3LD0jhq0Te96wV5jIBlaBMXU/qyQg+40KhgtyWQRsQEBWRluXt6lW/2wljEP/jDjKiNWjh7vEXlsBdle6egPChnfngiBgTfxh0n7vQ1gP9P9Nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ye/BjGH1qzmtfGKeBdOVyMyMuC4tYxr9M7JUZDuBWOk=;
 b=Vx0HYBkRYVJQFEHcmaVtT6DDgM40dcDVZqaHpVl+srLeduufKdMJlIAvr2mzKamCuM3iP9IEso1TSstn2dgNLNeuuD+LTwOOwPKhqQ7bDpma4NklDv1p8UBupScQPJfw4vWO0S+OtbD2994OzRkPCt05qbWqZqBa2deZqvrs9ClfM8xiWNk2z/jNvoSy7HCf/BHWxQq1MmgTUH1EaLSqyV8tkZzw+N5VJijfWZVS8Y31p5FRA11lL0/4UsV5GTxPjWHcpSyt5YB3HRhZmOxEGWrCal+MPHC//h11+7uXp8ONlt0z40QXMdPbdj7iqUHdz4lmgRYI0qTkS53jFH6HqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ye/BjGH1qzmtfGKeBdOVyMyMuC4tYxr9M7JUZDuBWOk=;
 b=iy9a9WAw/5Hip1uCJSnFZUlPpRKL6nckiqhyERqGwJD4g62lNDoU/wTrvjBjvmQSXVfakXIZVjO0WV1mrQmNL8e1JS9wB81POmVfsEjaP2eVmEY6e5p4VBr1Pn2p6PjyULHFxjKTEzTTAeKj9ttdgOF44Du/D383X1gYx4af9kg=
Received: from BYAPR15MB3029.namprd15.prod.outlook.com (20.178.238.208) by
 BYAPR15MB3333.namprd15.prod.outlook.com (20.179.58.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.10; Wed, 8 Jan 2020 19:18:04 +0000
Received: from BYAPR15MB3029.namprd15.prod.outlook.com
 ([fe80::3541:85d8:c4c8:760d]) by BYAPR15MB3029.namprd15.prod.outlook.com
 ([fe80::3541:85d8:c4c8:760d%3]) with mapi id 15.20.2602.017; Wed, 8 Jan 2020
 19:18:04 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     David Miller <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 6/6] selftests/bpf: Modify a test to check global
 functions
Thread-Topic: [PATCH bpf-next 6/6] selftests/bpf: Modify a test to check
 global functions
Thread-Index: AQHVxfT9NfZKg3K39k2Uj5g4bCBQ6KfhJMiA
Date:   Wed, 8 Jan 2020 19:18:04 +0000
Message-ID: <D216F309-5E41-4BB9-BB39-4F50A77BB166@fb.com>
References: <20200108072538.3359838-1-ast@kernel.org>
 <20200108072538.3359838-7-ast@kernel.org>
In-Reply-To: <20200108072538.3359838-7-ast@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.40.2.2.4)
x-originating-ip: [2620:10d:c090:180::c159]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 515a8749-1faf-42b3-747e-08d7946f7c63
x-ms-traffictypediagnostic: BYAPR15MB3333:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB33336C46148DA7B4F0F81F27B33E0@BYAPR15MB3333.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2399;
x-forefront-prvs: 02760F0D1C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(346002)(376002)(39860400002)(396003)(366004)(199004)(189003)(558084003)(2616005)(54906003)(6916009)(36756003)(71200400001)(2906002)(66476007)(64756008)(66446008)(66556008)(316002)(6512007)(33656002)(6486002)(86362001)(186003)(76116006)(66946007)(91956017)(8676002)(81156014)(8936002)(81166006)(53546011)(6506007)(5660300002)(478600001)(4326008);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3333;H:BYAPR15MB3029.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IzYQltUdmqNZ9k+LH3z4U+4Uvmo2GVsLoPzITJyX0rMJMhAiN4gfWTsfFzLqA+lXwTYWnEJrdxo2FWFxOkH7axhNkNTXJegXpfz9mv+qQrHl0oqD6wzoz0XRTCycKeji3Z1evXbp2Hy0m5bFi+3uqtuhzXahvuvhByB4YtxaGid/43U6Acw/loejAfSoFRNqBI3/e4A+X2JO8wYgiU9O7fEoMrDX9Xxditz+qG4/vv1XzGEXvR3Na+jX5lxV4HGSTVLU2XfiRitsTuasR8M6B9a/NizehaQfkcIgfERShrMh8MoaEGNkcK8o2wtaYP3UOt7ihmFy+oX5z3ZWjJ7jVWw9GVYUkkiVFyanzx0xMCGQCvPbArCs7AsAf8xjfGijaOBEU6VwKrL6lRGxSe9APB/+PKvFkGSynFo1eptYfqula3BX+TiWa7HDzhrjejuc
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5306BB7DF0C90548BFE73C5BB3D85E37@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 515a8749-1faf-42b3-747e-08d7946f7c63
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jan 2020 19:18:04.4168
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eygg6np6kqxMerN5xFhCTnMeC/OEFRTnENbM0obvy5hpXT/q72wN4xQWF3RI2PT7BeMcl/SVtyLQtOaeM7RPxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3333
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-08_05:2020-01-08,2020-01-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=546
 phishscore=0 spamscore=0 malwarescore=0 impostorscore=0 suspectscore=0
 bulkscore=0 mlxscore=0 priorityscore=1501 adultscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001080151
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jan 7, 2020, at 11:25 PM, Alexei Starovoitov <ast@kernel.org> wrote:
>=20
> Make two static functions in test_xdp_noinline.c global:
> before: processed 2790 insns
> after: processed 2598 insns
>=20
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

Acked-by: Song Liu <songliubraving@fb.com>

