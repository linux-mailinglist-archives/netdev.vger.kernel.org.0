Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED78D242C38
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 17:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726529AbgHLPez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Aug 2020 11:34:55 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:12434 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726226AbgHLPey (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Aug 2020 11:34:54 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07CFSiOE031529;
        Wed, 12 Aug 2020 08:34:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=XE49WUTt7OZodHfBZFdd3qoR+lQv+zClDNKUe5bcdW4=;
 b=CX4/oBXDDYzXmRAMFBBPjKBXldOzCLL+qsYQfzSNOTqT9YczlkSjiNc8q1RU4wGKZ/L5
 FbGTTQ3fxEXYrbng2mnPy5lTwhZ0uxMeJ2oYIO4AWAXTigoxOq7S+WxbIZEOmMsPDjZa
 vIl5UA+Wd9sAm4bafaZt21TxNuGbWbgIMmM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 32v0kfct9m-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 12 Aug 2020 08:34:42 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 12 Aug 2020 08:34:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PojFZPk3SFbdj1+IhP/lKxIWEIqQb3YqbinOrO053Zn36+KtO+J7QhZe0xPyL9tbn5nCCGwtom9J/rAUUS7UB1lQO29l/x+eRn/086n0uuLA05jsaMwSNhKcElnEMVV2th4WaXIrsKrIxlQ+yOqLreXTK2RVbrLd9kTwgRNOhjDYzWsI7dMRKq1Inzp3PwwYJwhrym0wya8S6F9CkfDEfgf6VrTm1tB64OZ1AIY6unPrO/5xtKrLdtGpR4AzxlLz6YptwB9hPrR10V+mI4FNYicvLi4+HKFHy/TuT5dD/ujEZ23rPTa6/7gq7cY+n9FCryppZeobWFGb3wV4X9r/+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XE49WUTt7OZodHfBZFdd3qoR+lQv+zClDNKUe5bcdW4=;
 b=ST5uxCRe7eI5953OWR352G0m/2u32Tch6dyWiC/BuAnuuud/agfbc9zOjmFn9twdiX66+irFQlHyUy70ciliL9gh4aG946zb/X1zHRBI8dTt0fw8ieEk4HqB+MfMEyqyGaiLgfBe+PAsN20v7iCBs/mCvboHEHhpMM38W6fv09uiqktElyO+wPho3ZTCW5e8tgvkCFjPkEAHYhK82abapFhNU19UY55LUq1GY+1fFzqTxQZyLVDeWRBndwwvkffXNxztpwtUsWeaY0UekuA6nLAicg74jGllLkStyGA/LtW5HPQv2SfcKpJBazRFwdWqAfcHnsEPFrf+QpMpnOjsVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XE49WUTt7OZodHfBZFdd3qoR+lQv+zClDNKUe5bcdW4=;
 b=ZbaQ6vHxLWyAnOgxKB795PVEr4Xbg0tFODAw3mlSwg7NsELuSK94WLfbsEh0ud55evNx7kxNMwhl/06+B+n7Ic3VIz96PAi27mfZ2OiTaGIyu/hcjSci5bS0AlektK3nSoXio9I59gv7AZVeXSgaY2F0UlTnt+SHOMaaVHe0nPY=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2693.namprd15.prod.outlook.com (2603:10b6:a03:155::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.20; Wed, 12 Aug
 2020 15:34:37 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::119c:968d:fb22:66e]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::119c:968d:fb22:66e%4]) with mapi id 15.20.3261.026; Wed, 12 Aug 2020
 15:34:37 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     bpf <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf] tools/bpftool: make skeleton code C++17-friendly by
 dropping typeof()
Thread-Topic: [PATCH bpf] tools/bpftool: make skeleton code C++17-friendly by
 dropping typeof()
Thread-Index: AQHWcFSYbSduV+lA6Eio30dNrdrxlqk0m38A
Date:   Wed, 12 Aug 2020 15:34:37 +0000
Message-ID: <510B2A6E-60EA-459D-A40D-9C21182C166A@fb.com>
References: <20200812025907.1371956-1-andriin@fb.com>
In-Reply-To: <20200812025907.1371956-1-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.80.23.2.2)
x-originating-ip: [2620:10d:c090:400::5:8f7]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cc111688-7092-4797-9e50-08d83ed538ce
x-ms-traffictypediagnostic: BYAPR15MB2693:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB269393FD3AA3E68E83DEB0B1B3420@BYAPR15MB2693.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jqxVQ3bJElZvOEDCDJNoZ5UNlTwQ13jcU63QxHX4JyqpPe7GpXuBUiugVZyvwGje9TiQU6ogoYeMCKNxeY/EbBc/ihhHP93a27Bw3CWSTNDwTw3d38jc3X+GW4tX6WwvXQ61X/OXLqOKhLV0zqWlBKa57LMjZKnFqugnQX6kkyApVjQkCLAaf55k1qWd3RS1RymaUQNHg2gKEBH/eZvDiFQ1VkJj5fVycP+CAhkhcbk0ml3GLauTUcIQQtcJTGrP0GSJ+rVQMx7XOLDnHha/n/woR6OjvmYsIRwHu8UilVaPxN42PinH1Sp1dBWdlUa75yu2Ib/9iNJaqm9wdhjQ3g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(376002)(136003)(346002)(39860400002)(396003)(2906002)(71200400001)(6486002)(6862004)(8936002)(6636002)(4326008)(53546011)(33656002)(6506007)(36756003)(8676002)(316002)(66946007)(5660300002)(186003)(4744005)(66446008)(76116006)(2616005)(6512007)(478600001)(37006003)(86362001)(66556008)(66476007)(64756008)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: dxap1JZJVAKg1HG+VCAD0Qjx662J+PGp5WkxPP6C6hbsLnKQGxjf/piCEST5LUPK5UsvoZRHWFXB2aJykm2Fh8ZXWjNCUQ0PwkfQTIQi/3XcWBLe0othzZ5bhM06Z61DvKaF4oQgFFt8WXGviHM0UzXY+m7G43Sab99n9Y09UTeHE3tjxW6U5PIf0RbbKxsBgGBkJrLct5UdL50nPR8bv72kd21ctS61FJS4BXjeedfCECr1M22lyOEPhREqpJy7tpxp/CcR5eGcdKB/othSXAA3hZfhf8mmmgwpWGvzwLV31DTMSQ+LVCpb1ff6ZeXbU+LiJzXFLOfMEnGMOiO9ygxtrCbDMGRIqYho9HKXwDSs34Mmsi2NzAw5rbZFxJHFqzKaf8oIGrsYEga2uAlhkUMaWxB7Ty77Z/PWb8ozyGtFbZ38CgohlhZGf5XiDLEtA2jHZb0saaudZ7bg65GEaMxTAWRMJ+asqQcPxEiPrEwFd13UHzVFGQ7cLDHkbdMhwDwCg4TyLjHZ3lT6JOuGso0fPw/a9ZqIHS/cJGe47PeORMR1EbKp7FbLZkCEzQTj7HkHIuHP9AmCShZFfmEUQ+JVcuJLmNAW5aZwCq5VNjoNhB8Zvx62K7iShJxKt/RR245XNBVwJM2oqtbyhGLfNGjVGWv7PO40jZZyTovVwp8=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <51BF1B3E6FD3894BABF013296B3E3689@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc111688-7092-4797-9e50-08d83ed538ce
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Aug 2020 15:34:37.3926
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: foOPabxrqzAJzLWzS1h6fMoprLxwmitHdA1X2EYxqblFfgT7Pxhbp4CE4AaWjRRdwwpnAUFpIc21u5qOdUwksQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2693
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-12_09:2020-08-11,2020-08-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 adultscore=0 mlxscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 mlxlogscore=751 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2008120108
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Aug 11, 2020, at 7:59 PM, Andrii Nakryiko <andriin@fb.com> wrote:
>=20
> Seems like C++17 standard mode doesn't recognize typeof() anymore. This c=
an
> be tested by compiling test_cpp test with -std=3Dc++17 or -std=3Dc++1z op=
tions.
> The use of typeof in skeleton generated code is unnecessary, all types ar=
e
> well-known at the time of code generation, so remove all typeof()'s to ma=
ke
> skeleton code more future-proof when interacting with C++ compilers.
>=20
> Fixes: 985ead416df3 ("bpftool: Add skeleton codegen command")
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>

Cc: <stable@vger.kernel.org> # v5.7+
