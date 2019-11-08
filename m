Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8853F40E0
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 08:06:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728513AbfKHHGW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 02:06:22 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:36728 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725372AbfKHHGW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 02:06:22 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA873aaF030564;
        Thu, 7 Nov 2019 23:06:09 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=UPZFuRNO43Y19IY+aiy2wqOV7PBZy3Dw+rkR2jqi99g=;
 b=Ck+aJLgfSagwY/na1G696R93iNEXieAdwqrjqk6QrpDLeaWiRc8kMhMuS/+9qbS0xcNT
 ZNXRP0PNKrMYgvGFfzSlzZj7LuRBeWp7YpvIJaNa4NwRVvqbxITVS4Z53cLTTBSDUUqB
 1F+wudEXILOwsZ/KfO1M14oOweFLQibXCuI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2w41w6sr09-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 07 Nov 2019 23:06:09 -0800
Received: from ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) by
 ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 7 Nov 2019 23:06:08 -0800
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 7 Nov 2019 23:06:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZMIJegfYRFCj7vLyGWzwcDGqEaKC4ibx6HxFK4VV8ij2/iYLeZ2mS6/UfCsaBx3l/KtSNalWnTPnDCNJtk5OLRq6gGDMkU7TjHB/lPg/gEfZVJb9OrQLhkX/AR5UK609iYXH+i5PQ9m5G1FxfTweQfKsr2oct6Phz/fVEEASIyOYNvq5VrteYpPROY0/PN0qeUMxOmudFxNTVN6YEH8zEjYsbh/lySHKaGre4NEKOIWiU2BNSI/sm/11fGtDcjndhG3SKWOUDfMlGN9Xtd/4+ODWGe+zWvmOEX330VQPJx8KPKSXsvudd3WhnFd7PhSe+XSZxkNtwNhFLcVxUiRGcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UPZFuRNO43Y19IY+aiy2wqOV7PBZy3Dw+rkR2jqi99g=;
 b=O9it7kNO7fOaACmYHj0nvF0vf5RN6QIjntB0iILKW5bX3yRrlcRzchy5plLquCYY0Hh+oxCrGQACoWS7Y183zEOXfpMcDeAXhBwMNdJS8T9SfsIR4b7zvBjAQVPd3frtfIEonxwKxzRI/TA7r/R4Cd51f/neml2EvGyc7V7QSltIi8UHrAchSv3gnJYOemddwVuOf2iQKMHP8+1kfSEPif0+PZ7d1Xjmoj7aT/B4RGqFUt6yG0i3/2I+vnnHYqPgl1/nvkvNthPCsaidlHXJq4OFZoGuCJLw3Vza1KY317LXVgYmfGy0zsQaF768ORO6v3p7aulBUokG4Nh/0IraVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UPZFuRNO43Y19IY+aiy2wqOV7PBZy3Dw+rkR2jqi99g=;
 b=DUmXBFc0hL89j5W/jPf/ALcOWM/NzTUcl/1nyJd6kX1WvUizzkN4JV/2cuMrTmIRwiH1OpAlC0DXPbQPI2r8bFT9GQVwqhOFRT4A4ejx4IK5ldwHaqEjJuZZcCwDD5da7pj81aS+dG9AQepSno5XLp/xjQ5bvCP5DDYzheYLzG4=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1776.namprd15.prod.outlook.com (10.174.96.135) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Fri, 8 Nov 2019 07:05:47 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::fdc8:5546:bace:15f5]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::fdc8:5546:bace:15f5%5]) with mapi id 15.20.2430.020; Fri, 8 Nov 2019
 07:05:47 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     David Miller <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "x86@kernel.org" <x86@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v3 bpf-next 04/18] libbpf: Introduce
 btf__find_by_name_kind()
Thread-Topic: [PATCH v3 bpf-next 04/18] libbpf: Introduce
 btf__find_by_name_kind()
Thread-Index: AQHVlf97q2qL2zxZpkCN2Za6hTXuwaeA2eSA
Date:   Fri, 8 Nov 2019 07:05:47 +0000
Message-ID: <2C6C1C12-A9B6-4030-A1F3-D493191E315B@fb.com>
References: <20191108064039.2041889-1-ast@kernel.org>
 <20191108064039.2041889-5-ast@kernel.org>
In-Reply-To: <20191108064039.2041889-5-ast@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3601.0.10)
x-originating-ip: [2620:10d:c090:180::c4b]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3977cf36-e823-4cd3-7a49-08d7641a14e4
x-ms-traffictypediagnostic: MWHPR15MB1776:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB177649D0F4896DA366439A3FB37B0@MWHPR15MB1776.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1186;
x-forefront-prvs: 0215D7173F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(376002)(396003)(136003)(346002)(366004)(199004)(189003)(2906002)(14454004)(6436002)(6512007)(6116002)(46003)(86362001)(33656002)(478600001)(446003)(476003)(229853002)(71190400001)(71200400001)(6486002)(486006)(2616005)(11346002)(305945005)(7736002)(6506007)(53546011)(5660300002)(99286004)(36756003)(6916009)(76176011)(54906003)(316002)(25786009)(186003)(256004)(102836004)(8936002)(8676002)(81166006)(81156014)(66446008)(558084003)(6246003)(76116006)(66946007)(66476007)(4326008)(50226002)(66556008)(64756008)(101420200001);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1776;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qlo/N6HKM4tReg3iMAtFGFBIHYeqVw3LnbD5eVZ9DFqnnV8qsr8fUbfLFC+/mUEVuGMgcDqgfbs6jxauh3RRM0Z8teAYHhrP8OsIsFu7JcifRIqfkCMiufBCf+5twNv7Rn/n0RSiTHPojYxq71Gl576jM99a9NidHOKWovqzeETc+ULBq/HemINrB3/EMfVO8iPuvlmBqVFH6mWGgnEBiPTJurGWYbVo8Juh/wTzODVFFiSLJeZbmOWlCjsYpnQX8Vcp5Ys0GA6wdEk2K0vgfIm5bNOzhWhxVHQpoCkCDQg9iVnzGS/DlzeRm6T3lsGPYeWf2frPVAbRJveVDW0u2lgADx+aX3ty/U+lF2RrbreQ+F+qn2824kM5HH8PGVF2VQCL1I5xldPhcZtsZ6kjLi3a45n8YD2uSateyB6ZEbUze628hTnIp3QJqJZl9KMH
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6DC3F2C7C7E81146AEF24B0ED4160238@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 3977cf36-e823-4cd3-7a49-08d7641a14e4
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2019 07:05:47.6280
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7nxhr2N2WSHQh8I0799OSN0vUhcxHL8TuOE7LqXqChjyWAsjbHMxxICGDwMdakYkukiJRlOn02LQuIXwwqZSTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1776
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-08_01:2019-11-07,2019-11-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 lowpriorityscore=0 phishscore=0 mlxscore=0 adultscore=0 clxscore=1015
 mlxlogscore=558 suspectscore=0 impostorscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1911080069
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 7, 2019, at 10:40 PM, Alexei Starovoitov <ast@kernel.org> wrote:
>=20
> Introduce btf__find_by_name_kind() helper to search BTF by name and kind,=
 since
> name alone can be ambiguous.
>=20
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

Acked-by: Song Liu <songliubraving@fb.com>

