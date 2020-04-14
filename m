Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7131A8E33
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 00:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407852AbgDNWGY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 18:06:24 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:64474 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729934AbgDNWGT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 18:06:19 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03ELslYS020084;
        Tue, 14 Apr 2020 15:05:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=V4R40Mll6F/xkP093C622+wH/QC3+c3rpIumWhtrvSE=;
 b=Buj43EDE6OBJtN6W279FPtjG2+JQfeIJEUw+GrB/eoeQnCLPtwSQWOrkkbxZlWQ6TH5s
 Jc7LaqBW2cJBe//a5mqpefBVkX08BkPYxnczzZJR5n55VwrjdFAlG53B6wYz1LdJywzq
 AlgIWdW7AEdzyC8TdK9hFHyjVVGaFMGkgts= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30dn7q86bu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 14 Apr 2020 15:05:15 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 14 Apr 2020 15:05:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jkqd5nbYqmGDH1kHQprLzlEjKF5CFe46lgfM5g3p+rb7HA2ZJhDvz72ZCXCxyHHLy3o4dEcpSdhBKFKueeh+BzHr4ULoZikW3wUhITP7p5N1iDv3n0oURSVFo9Brj8Yg5Q3jhrDMQd+0jy6JFqM4cjFFrEsAA9f1+c747boRyOnnTIUyI6nH5BjGYmXnhdYgYvQUOEkEccBzm5HBAfchvJWLk2+SAYjILUQKGaOSOVbYOWZxmSCzrCyzv1Bq0yZ9CYo9qU0XDHf98QwyXY4DDejsfTkhOx/7T/nkuRSF1tncqi5ihjDRIoT5yLUfa9YwLVTJi1gQOSXPSVgPlMmsLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V4R40Mll6F/xkP093C622+wH/QC3+c3rpIumWhtrvSE=;
 b=AnQTlr2p3AS5F3F8pP+c0WmuaVqb/gBJPIA2OpA+KMRkTFtfA3IMaT4WPPziZcZZwy5eL7G4jD4aUzI8ILFbl8+uZehilIVkjKt41Ylvatm8FO0ESR85X8PlrAhHjgyyOezo8aJkU/vu8s2qwhFkYgnwUo7DYmtnXasaTQW/xDw0AHpzrH+H4WR5uXlac15hakb5hBfYeO8Da+Z+SG69/Lz6ZBSxPEs5mw+SlD8flj4rmnKt5vQxKTgpJcT0oOQuwMFeD1xu39i4QGzcPKGfwljg6WZMcGKrlBDo7+LTGJqe8Jcz+KPwdC3hW5I8DIjWb/qi31H8Dtzb3rbxVfkIbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V4R40Mll6F/xkP093C622+wH/QC3+c3rpIumWhtrvSE=;
 b=S4Rj+ZY5gdst/QQoPuRNnoW6SO53Txqd7NKm5aKGwfEnKPZCj+3ltvWM33q9uMmx8E4vYJ8XSFOJXyeUhdzqX+GIhYuVWUi/c+f+xAq7c0pooCJ11j0mSbO99spCe6mcLIxziLs2H5BKQQ1NPQgmrqunskH4NIHONB+KsX+kunQ=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2455.namprd15.prod.outlook.com (2603:10b6:a02:90::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.26; Tue, 14 Apr
 2020 22:05:12 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::bdf1:da56:867d:f8a2]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::bdf1:da56:867d:f8a2%7]) with mapi id 15.20.2900.028; Tue, 14 Apr 2020
 22:05:12 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Mao Wenan <maowenan@huawei.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@chromium.org" <kpsingh@chromium.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH -next] bpf: remove set but not used variable 'dst_known'
Thread-Topic: [PATCH -next] bpf: remove set but not used variable 'dst_known'
Thread-Index: AQHWEYedD4qyQaRcJ0KQTxqzapbMNqh5LnoA
Date:   Tue, 14 Apr 2020 22:05:12 +0000
Message-ID: <C75FACD4-8549-4AD1-BDE6-1F5B47095E4C@fb.com>
References: <20200413113703.194287-1-maowenan@huawei.com>
In-Reply-To: <20200413113703.194287-1-maowenan@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.60.0.2.5)
x-originating-ip: [2620:10d:c090:400::5:ba33]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 03948f60-e2b6-4b6f-2202-08d7e0bfe7bd
x-ms-traffictypediagnostic: BYAPR15MB2455:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB24559EDD5BEE2CB2781EE7A4B3DA0@BYAPR15MB2455.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:117;
x-forefront-prvs: 0373D94D15
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(376002)(346002)(366004)(136003)(396003)(39860400002)(86362001)(2906002)(66476007)(66556008)(64756008)(66446008)(478600001)(316002)(71200400001)(36756003)(4744005)(76116006)(5660300002)(8676002)(8936002)(6512007)(66946007)(186003)(6486002)(6506007)(53546011)(81156014)(2616005)(4326008)(33656002)(6916009)(91956017)(54906003);DIR:OUT;SFP:1102;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YGz+7FhgwD3SpCOFWrhOaroUMM3mgzqpBCzgPw2ygMNMspQtkC0Eba0src+0zCCTLKuuxRFkd9A/olhB6UBkZFLgS9YUdEeoRQ1aYVBOWoVO4jJkVNF5FiI1GihNeA1nC66rAYazEOaKIbwru0Tjfb+79POvVufCApdsQhWgmuv/t8NlipmTiX8qiWiKK31Ka9jItB466lRnrqednPwePzTAOomznuUnDQWGHfrbONtx7xJOwMqQfFNtnNvjOO57sbdSge/sj49QB/5/3t9Wb0aeatpX1bwXoOj/i9kiv+Udh/hiVlBD4WfjLHmRhPGA3jfP1qYIhRn03vZIwyFDiatQwXHAlB/Zx89Z61AlTydZGumpcW4bcnBGRssJrsvwVm0Rw8Gj6em4LMafltY3KLszRqE+8HwDCd40Ss1hlpnF4bJiHxbpHUARxN+k4JjR
x-ms-exchange-antispam-messagedata: tE/zIW2qgYAKL880XiVWvLNfkQ7CV/0PEhVCCtZnmMpavM01bXqBGuvh1yKaNw0TfHaxeRylfTs3GI87o+Z+iVrJz4FUq1JShxLTQvJLUVfH5txyeEvfFrmsRmICG1XyGv7gfmtN4PnmbhpL27xHfnN2m++hpagRDbp41PQQq0q0hIdPHWhPg1q8JSxc0wWc
Content-Type: text/plain; charset="utf-8"
Content-ID: <C499F44E3CC90F48BEA227A1FA9B2CF7@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 03948f60-e2b6-4b6f-2202-08d7e0bfe7bd
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2020 22:05:12.5702
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yMb3J5CrKs38Y9NKbGsc5uNaqDd1J8xU/YoFJc2b+9R1tGagAbLM2FlWo3VpcrqfWr9ChSK9RXzKNJ8gellTfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2455
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-14_11:2020-04-14,2020-04-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 priorityscore=1501 spamscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0
 suspectscore=0 clxscore=1011 adultscore=0 malwarescore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004140156
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gQXByIDEzLCAyMDIwLCBhdCA0OjM3IEFNLCBNYW8gV2VuYW4gPG1hb3dlbmFuQGh1
YXdlaS5jb20+IHdyb3RlOg0KPiANCj4gRml4ZXMgZ2NjICctV3VudXNlZC1idXQtc2V0LXZhcmlh
YmxlJyB3YXJuaW5nOg0KPiANCj4ga2VybmVsL2JwZi92ZXJpZmllci5jOjU2MDM6MTg6IHdhcm5p
bmc6IHZhcmlhYmxlIOKAmGRzdF9rbm93buKAmQ0KPiBzZXQgYnV0IG5vdCB1c2VkIFstV3VudXNl
ZC1idXQtc2V0LXZhcmlhYmxlXQ0KPiANCj4gSXQgaXMgbm90IHVzZWQgc2luY2UgY29tbWl0IGYx
MTc0Zjc3YjUwYyAoImJwZi92ZXJpZmllcjoNCj4gcmV3b3JrIHZhbHVlIHRyYWNraW5nIikNCg0K
VGhlIGZpeCBtYWtlcyBzZW5zZS4gQnV0IEkgdGhpbmsgZjExNzRmNzdiNTBjIGludHJvZHVjZWQg
ZHN0X2tub3duLCANCnNvIHRoaXMgc3RhdGVtZW50IGlzIG5vdCBhY2N1cmF0ZS4gDQoNCj4gDQo+
IFNpZ25lZC1vZmYtYnk6IE1hbyBXZW5hbiA8bWFvd2VuYW5AaHVhd2VpLmNvbT4NCg0K
