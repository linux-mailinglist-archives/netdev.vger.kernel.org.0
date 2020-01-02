Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDAD112E9B1
	for <lists+netdev@lfdr.de>; Thu,  2 Jan 2020 19:05:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727890AbgABSFF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 13:05:05 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:6702 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727829AbgABSFF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 13:05:05 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 002I46FD004308;
        Thu, 2 Jan 2020 10:04:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=SYORyHnpACPCy7bk3qFc3TJY+/bv4fpaug6dzuTbIfo=;
 b=gd0ubtr+N82FLJllaGDrBAHL6XYujcrI8Cark8VGJJQyJgQLgu7JiGPoUlUkKtple/lV
 zwICZES2g41EcqW7w1wQAjf3OmOAPPcli8kr5kQg1i7xLNQ+riPp4IebvgIoMMaOLK2A
 VwOvzZtqSL7NGDFdkAKnqAKTrpu/TzujLwY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2x6qn088c4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 02 Jan 2020 10:04:51 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 2 Jan 2020 10:04:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XVgbM/E8zUNj8nMdgC5o2iZR4Vd4IKuRpp8LPnBmYLnBGhM2/dFHq4RbOTbB9NPo2YKu3Y6JFLFW/h6XgeorynUzlxe//8NbCVWDw9FAp5bOe/47MUIvwZ2KW3MZ8Cb3O51LdihZTK7xKgnftMzKteuCnOK8ESz1vsddVXY8/SUM05Jl9MAK2cdjP8DB+7Ebn+F6Gct7m1iKtREYp5sNihcUlJkgwlDt2yPtATr2FoJnZ9vBCGftYDYgJY0YdFs/tkWkxy9BGq0NK5+H+aF2VWeknmcGVp+PYu/5iHK4Wup7faxscfN+ozM70USAGBZWCcP8y9eexFkCx+kgvDoFkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SYORyHnpACPCy7bk3qFc3TJY+/bv4fpaug6dzuTbIfo=;
 b=BXQlRgPVe3XqflK1K/RhiMod+QHnSUjJYHIgy0aKKmaocx1tbM1E4PSRIXncLDyIiYMuPiWRsDQyH5y+WL0ocscG60MMeW1Dn413nc36mYS1PhG8qVsY8yQhjX+tPQhTjGLhPGwcdk6z+XMNZ39G4k5NwaCBPJppXPEl2fcpjaO1axg6Lh2Tx5A52NOLh1hNwee/uXHQ5NhVjUPUFd4QoBXb3HJ+2jg5Da4mxPQe2EbKrX5rZIZfV/vRzAnXTFFo7DjBKX4Uuwq9duJuduRyJDdMvuEJZRUGbAac91Fzh7bL7wwEDPD9NRNC8ClnqEXVfq89LVzuZnSY1hQxK45/DQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SYORyHnpACPCy7bk3qFc3TJY+/bv4fpaug6dzuTbIfo=;
 b=aHFFy77TNUzNA7ZqYIfuF2dq56osyoILp70HF9kN/ZxN/IfuJZYjn2AH2sa6UmACF8CMKwGR8kvHvS0wNTmP8jktAQINJIHBrIqsuZ5DumxEJb2NEOPxCRgmNm6J60TArgdDT1+IkFw9Eo1TYJBCAVOjtKn9+e/Yb+Auug3bStE=
Received: from DM5PR15MB1675.namprd15.prod.outlook.com (10.175.107.145) by
 DM5PR15MB1610.namprd15.prod.outlook.com (10.175.111.136) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.11; Thu, 2 Jan 2020 18:04:48 +0000
Received: from DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::1cbf:c518:3a4d:291b]) by DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::1cbf:c518:3a4d:291b%11]) with mapi id 15.20.2581.014; Thu, 2 Jan 2020
 18:04:48 +0000
Received: from MacBook-Pro-52.local (2620:10d:c090:200::89dc) by CO2PR18CA0066.namprd18.prod.outlook.com (2603:10b6:104:2::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2602.10 via Frontend Transport; Thu, 2 Jan 2020 18:04:47 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Martin Lau <kafai@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <Kernel-team@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v3 04/11] bpf: Support bitfield read access in
 btf_struct_access
Thread-Topic: [PATCH bpf-next v3 04/11] bpf: Support bitfield read access in
 btf_struct_access
Thread-Index: AQHVv6Jz68VM098+YU+rGKHyi/FvFqfXruoA
Date:   Thu, 2 Jan 2020 18:04:48 +0000
Message-ID: <cd17fa0c-3139-3031-4750-62f7f05949bb@fb.com>
References: <20191231062037.280596-1-kafai@fb.com>
 <20191231062046.281300-1-kafai@fb.com>
In-Reply-To: <20191231062046.281300-1-kafai@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR18CA0066.namprd18.prod.outlook.com
 (2603:10b6:104:2::34) To DM5PR15MB1675.namprd15.prod.outlook.com
 (2603:10b6:3:11f::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::89dc]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5fdb84aa-31b6-4fc0-2722-08d78fae416f
x-ms-traffictypediagnostic: DM5PR15MB1610:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR15MB161060A8E44DE8E956F9C56AD3200@DM5PR15MB1610.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2657;
x-forefront-prvs: 0270ED2845
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(396003)(39860400002)(346002)(376002)(136003)(189003)(199004)(6512007)(110136005)(81156014)(81166006)(4326008)(8936002)(8676002)(5660300002)(6486002)(31696002)(186003)(2906002)(16526019)(316002)(54906003)(2616005)(86362001)(66556008)(4744005)(66946007)(6506007)(71200400001)(478600001)(31686004)(66476007)(64756008)(66446008)(36756003)(52116002)(53546011);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1610;H:DM5PR15MB1675.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0h69TiJSC0bp9bCA86UV46BrCQzWxeZ2ELqE6CA/4n0Fu+YxzNmruB5ut0h+7i81Xh48qBjpecfAJYOxGeIprS7dwYkec7FuJV8nI9g582dYnRFa60qUoocdr3YyAKdyzyjFNj5lD3QQJSQb9ZDx00yP3i7qxfsaZaDUGBK25oVWWwa6mMwcbfTydsM3zkyYTtA/5S5tgldvYYcdIcudCQ52y6QWq65OwMs9g3/pLQqPvNnQoiBmjsH8nUdihILMUV7QaxmygN72k1QD/4CddUndL52FWW4J4m1pb11ir0P0mGgW2k7783rLVKjojrWzrPs1zu+/Mc+CEeOKfe8yxQ10mBe8sSNEAHKBgGuq0JlA7dj46OCu4EkAhjRnkfzbdbd4wtfpB31Q9xJjbEToNpadEoN1B4vJXNKUUXrT7NUWxpdskyHdZg/0eGue5oMm
Content-Type: text/plain; charset="utf-8"
Content-ID: <DB66BEC498913C439067F20E1B2141D4@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fdb84aa-31b6-4fc0-2722-08d78fae416f
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jan 2020 18:04:48.4837
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: i/hxSkSXtx2iFfsPU+Lqo0yML74a49j4zB1BkLrTjR87nFdusXYmoLic1BDiklmG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1610
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2020-01-02_05:2020-01-02,2020-01-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 clxscore=1015 bulkscore=0 suspectscore=0
 impostorscore=0 priorityscore=1501 malwarescore=0 adultscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001020151
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEyLzMwLzE5IDEwOjIwIFBNLCBNYXJ0aW4gS2FGYWkgTGF1IHdyb3RlOg0KPiBUaGlz
IHBhdGNoIGFsbG93cyBiaXRmaWVsZCBhY2Nlc3MgYXMgYSBzY2FsYXIuDQo+IA0KPiBJdCBjaGVj
a3MgIm9mZiArIHNpemUgPiB0LT5zaXplIiB0byBhdm9pZCBhY2Nlc3NpbmcgYml0ZmllbGQNCj4g
ZW5kIHVwIGFjY2Vzc2luZyBiZXlvbmQgdGhlIHN0cnVjdC4gIFRoaXMgY2hlY2sgaXMgZG9uZQ0K
PiBvdXRzaWRlIG9mIHRoZSBsb29wIHNpbmNlIGl0IGlzIGFwcGxpY2FibGUgdG8gYWxsIGFjY2Vz
cy4NCj4gDQo+IEl0IGFsc28gdGFrZXMgdGhpcyBjaGFuY2UgdG8gYnJlYWsgZWFybHkgb24gdGhl
ICJvZmYgPCBtb2ZmIiBjYXNlLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogTWFydGluIEthRmFpIExh
dSA8a2FmYWlAZmIuY29tPg0KDQpBY2tlZC1ieTogWW9uZ2hvbmcgU29uZyA8eWhzQGZiLmNvbT4N
Cg==
