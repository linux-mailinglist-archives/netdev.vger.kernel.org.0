Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4FD7C8B33
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 16:28:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728095AbfJBO2e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 10:28:34 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:32462 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725747AbfJBO2d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 10:28:33 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x92EOY2A027674;
        Wed, 2 Oct 2019 07:28:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=7lEcq8X6h8BqFqYDBc5c5rxVb0PeJZkJoyUrE/bhX9U=;
 b=OPYh/tCwMF05041ZUoSJ/B6EGxGdvWy6p+e4AyKqdno7uDI25i0M13V75bmdGR2ZkVRG
 vVxXRHcKJp2lRLzleHcrPEkaNWp1bOtGBlXJYqbMiWull6fjVR/DLmANQe8I/3c//9Sj
 7wUIhfMFBpZGKfAhmlPb0zX+r1+gkN35oxxpx29XLSTLPI4Knd5gGQIZAgHQyVGlL/++
 2fWMacy+gtVKFGHhgUJ4/HBWttkOqBg//yI6zUjW0Q0L8saGyG/d24MDwp9Sq0yv1CvI
 dMkzkExCxaDptGAALF1Ft35dNc/H2Fmqn0pCBH0zyQxf/F93k637Pk5t2NPpLP7TR59O gg== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 2vcjbn2986-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 02 Oct 2019 07:28:24 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Wed, 2 Oct
 2019 07:28:23 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (104.47.45.50) by
 SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Wed, 2 Oct 2019 07:28:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k2sVooPNdKAYag3zk7d4whNO7atDq1gzomhV8fwszX6Mde90rcZjF03TJQjEoXEDAQfbHX4YgndlRnlnPina2BFs+nWAmS9BNgWmEA+bsx5IWGH8aDil7nUjY4UGux2otKObSUQwKtT+pIUxXzwCA5yyoJn+b2dznmnPgMel6B6pre4CBzL20XWaaoTlLugO7LIH7NBRfXEEIOtC+ssIFC7rCnQChxz3c5JX5o0UgoHxtv/4E7DTh1CbFInxF6bJqhJzpHFAkisLzSsCfkL+2QxffJR4jRuprA/khNeQPl/7PBMfwe2/qWdi2vt00GuqfKz+FSkElzdmXwAceMPeXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7lEcq8X6h8BqFqYDBc5c5rxVb0PeJZkJoyUrE/bhX9U=;
 b=SohHzWzWwE4RC/oK1KOQWcvEtlaAI3OVpxLLlHNDCnbLaJYVjromnO74PXpoyV01JxEJUFfQDQIbKXLaEoqfSpXbr1ptBMsl3Plu/ML9f59xSOwK2I8yTf+DHagmWjvabL9oj8NUaiBZ9Yz+iB9Iz+oXNjuFMYnyNPSdOdfB7nGUXCmZLaTmf89ywuNFBxLy5ouv/PC4XL8uu1Jg9yRylLcYlNUKj7eeVfAY3PpnYW2RBzxmU87M03ahnfS8YZ2hPwPhxPHwlDzgurpJXHuZymvBqQevDMDQxdiyT4Lzd1ixsI42H+IXtU46+6lSAn5bUf8wzAVkY2zqA+fSNjZutQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7lEcq8X6h8BqFqYDBc5c5rxVb0PeJZkJoyUrE/bhX9U=;
 b=ZBn0m6PsYfRUWNk2n0czcPRW1o/l1QG1ITsFDHt8WZm+tJHMvDfnFf/GJKshwtaTzexfycU0/nClbuuQI2YnlKW4nUI+gSmHMPjFnptTcnLrFBBAI+e+sP5+EJ7dFqHRhjoPcFwGuZofSHYCWAlEXuXwuKTRnNEN5iTvhMds9mg=
Received: from MN2PR18MB2637.namprd18.prod.outlook.com (20.179.80.147) by
 MN2PR18MB2720.namprd18.prod.outlook.com (20.179.20.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.20; Wed, 2 Oct 2019 14:28:21 +0000
Received: from MN2PR18MB2637.namprd18.prod.outlook.com
 ([fe80::cf1:1b59:ac77:5828]) by MN2PR18MB2637.namprd18.prod.outlook.com
 ([fe80::cf1:1b59:ac77:5828%7]) with mapi id 15.20.2305.017; Wed, 2 Oct 2019
 14:28:21 +0000
From:   Ganapathi Bhat <gbhat@marvell.com>
To:     Andrey Konovalov <andreyknvl@google.com>
CC:     Kalle Valo <kvalo@codeaurora.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        syzbot <syzbot+dc4127f950da51639216@syzkaller.appspotmail.com>,
        "amitkarwar@gmail.com" <amitkarwar@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "huxinming820@gmail.com" <huxinming820@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nishants@marvell.com" <nishants@marvell.com>,
        "syzkaller-bugs@googlegroups.com" <syzkaller-bugs@googlegroups.com>
Subject: RE: [EXT] INFO: trying to register non-static key in del_timer_sync
 (2)
Thread-Topic: [EXT] INFO: trying to register non-static key in del_timer_sync
 (2)
Thread-Index: AQHU8UKXrSaZj3qnvU6hFZ7GfmsosaaHYqxQgAJS84CAADevwIAOoBJwgGFIWICAAAY3D4ABlLnwgEuazYCAAW0AkA==
Date:   Wed, 2 Oct 2019 14:28:20 +0000
Message-ID: <MN2PR18MB2637D7C742BC235FE38367F0A09C0@MN2PR18MB2637.namprd18.prod.outlook.com>
References: <000000000000927a7b0586561537@google.com>
 <MN2PR18MB263783F52CAD4A335FD8BB34A01A0@MN2PR18MB2637.namprd18.prod.outlook.com>
 <CACT4Y+aQzBkAq86Hx4jNFnAUzjXnq8cS2NZKfeCaFrZa__g-cg@mail.gmail.com>
 <MN2PR18MB26372D98386D79736A7947EEA0140@MN2PR18MB2637.namprd18.prod.outlook.com>
 <MN2PR18MB263710E8F1F8FFA06B2EDB3CA0EC0@MN2PR18MB2637.namprd18.prod.outlook.com>
 <CAAeHK+z8MBNikw_x50Crf8ZhOhcF=uvPHakvBx44K77xHRUNfg@mail.gmail.com>
 <87k1bhb20j.fsf@kamboji.qca.qualcomm.com>
 <MN2PR18MB263724E4791927DF1AE009B1A0AD0@MN2PR18MB2637.namprd18.prod.outlook.com>
 <CAAeHK+w6Po=8cYRDXZBHY6ZpFLc_ysmxsuGmxGzpvfdZw6ySrw@mail.gmail.com>
In-Reply-To: <CAAeHK+w6Po=8cYRDXZBHY6ZpFLc_ysmxsuGmxGzpvfdZw6ySrw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [182.72.17.59]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0299c272-a5b6-4840-d267-08d74744c698
x-ms-traffictypediagnostic: MN2PR18MB2720:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR18MB272075F6CA30AA6C18F29577A09C0@MN2PR18MB2720.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0178184651
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(346002)(376002)(136003)(396003)(199004)(189003)(9686003)(14454004)(55016002)(25786009)(6116002)(478600001)(476003)(446003)(11346002)(4326008)(6246003)(486006)(3846002)(86362001)(6916009)(74316002)(558084003)(305945005)(7736002)(229853002)(8676002)(81166006)(6436002)(66946007)(81156014)(66476007)(66556008)(76116006)(66446008)(64756008)(186003)(7416002)(8936002)(256004)(7696005)(76176011)(33656002)(5660300002)(6506007)(55236004)(102836004)(52536014)(71200400001)(66066001)(99286004)(2906002)(316002)(26005)(54906003)(71190400001);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB2720;H:MN2PR18MB2637.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Sft6Z2w+1sE7kQMJdaJBUD0yXZz8fpzAU/3J06wIoumiHnVU5AFxGxM96K6qbs8CSNem38hRAV5tEeY2lHEFGBeOSdzlJNlR4ywmnjArQxX85d1aIIJ596jSCPL9DY1JwEynW8nLp2yBYhH6orYbaT21uSby4GrsvxLtT8srwt8phB00hreXRin0Q9jtXi5ullAbxUdQuNesTBWyVW+CW8HoeserFNI/ohp1k6lDEwkjpmc8arYsTLWdzmJrOe44v6T4h07E3IrJzITNY691D+5St3PfOrtuirkRBRLpupgB/qofpjOc/wS65kz+mJV7G9HHVgWvNMVSnmC+2n1LCLVJXEKLmXly0YW2YPUfCRUV8vall0zCuA5I7qZG3mmsP+yb1xfjr9jMR6McOaCKrHQXzO2FpVOvwT3q/MfR3Mo=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 0299c272-a5b6-4840-d267-08d74744c698
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Oct 2019 14:28:21.0097
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: w1BBJ2yY7vwPv6pGpwQin6zpIsP2UqbDNf1V4TTqBMydgCxbNTf+aI/g2VDnhz8MSrKHBFU8iLpVYvv38joIpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2720
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-02_06:2019-10-01,2019-10-02 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQW5keSwNCg0KPiBJIHdhcyB3b25kZXJpbmcgaWYgeW91J3ZlIHBvc3RlZCB0aGUgdXBkYXRl
ZCB2ZXJzaW9uIG9mIHRoZSBmaXg/DQoNClNvcnJ5IGZvciB0aGUgZGVsYXk7IEkgaGF2ZSBzdGFy
dGVkIGFkZHJlc3NpbmcgdGhlIGNvbW1lbnQgZnJvbSBjb21tdW5pdHk7IEl0IHNob3VsZCBiZSBk
b25lIGluIGNvdXBsZSBvZiBkYXlzOw0KUmVnYXJkcywNCkdhbmFwYXRoaQ0K
