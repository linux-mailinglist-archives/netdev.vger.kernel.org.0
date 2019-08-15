Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9888ED72
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 15:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732605AbfHONyq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 09:54:46 -0400
Received: from mail-eopbgr690049.outbound.protection.outlook.com ([40.107.69.49]:8166
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732437AbfHONyq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Aug 2019 09:54:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gtS2mLgsxslqbLipl8yzVWE7P78Yj+zErdbM1G2mBLOAhcBcBPJ+E0VLOP1VLLju76meYIO4KD8Sk/eUoGnSJEDlHv/oMzQ/6oqghlOouoKgtcL2tA+q9Y/7nORJBQ+aiKrrIu7YpHfi7ajbOOCBSvSwrl1aTzLrH8IDeAJsorU3KKyUgPpkAc5k3g/Jwdd9Q/reaDXkkSd5KG+T3Vb6honjQtCJCAgbFjs0XpAetAatPPqK6NBnidut5MvJ+egMyleKHHu2XrcPANnQmj7unZBxeKRmUCadO+X66fPj+O2ZmwMTkIEGakVtUnCE+NZR5AUzA3bb3GVD1u0MQDg5cA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sWnE+v4mbcNGkG+PyzVAOKFIzyzbqNV6lmFpF0+/JEQ=;
 b=Yv9E0QlZmKjb5TLSfb0beVRtVGXybIImfNDjaAZ5UDbXoksQtcMB+erhu2H/4HsYw22QuAChqTNwyJ4wwo0Q8Jcn14Dn22Xq+dZkFcRG+qrUleifl/Ayz134acY0+lUICrI3SxYQKkP7XD81jauCuKUZudPV2erMclZRccK0CvWG4T9Uz3sMeuF816rQtJvqwwLQsHMgqpAM2rxBYCQdAv90ewvzyI8BpJpa0fmaUCbV5+xN7YzfnVCDFC0ctf/laTUw7BCRi/neBEhepgD8YTN7of0Z1PuvaUWYnuK42Bn5KXKwYbsrme852fQxkxhcG197qMse81829BJ8v1KIxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ericsson.com; dmarc=pass action=none header.from=ericsson.com;
 dkim=pass header.d=ericsson.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ericsson.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sWnE+v4mbcNGkG+PyzVAOKFIzyzbqNV6lmFpF0+/JEQ=;
 b=rKtXSvkr07pOjCAgL/rKwPqkpOieO4ZWHgC+cO8udmCFJqR+46VH/SrnHOJ+eGSmYK/mSNK73N3pWzZBjsOxHUxpKxpvZxBfjTdIolMkatZ5CGVV+6E2UFOjBXlJxG0DNBnn1cLdnZ9pm8c8ecCxy1pX1F5Ib7VyAVTFID1tcfA=
Received: from CH2PR15MB3575.namprd15.prod.outlook.com (10.255.156.17) by
 CH2PR15MB3576.namprd15.prod.outlook.com (52.132.228.78) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.18; Thu, 15 Aug 2019 13:54:43 +0000
Received: from CH2PR15MB3575.namprd15.prod.outlook.com
 ([fe80::49b5:cc04:ec33:c7c2]) by CH2PR15MB3575.namprd15.prod.outlook.com
 ([fe80::49b5:cc04:ec33:c7c2%7]) with mapi id 15.20.2157.022; Thu, 15 Aug 2019
 13:54:43 +0000
From:   Jon Maloy <jon.maloy@ericsson.com>
To:     Xin Long <lxin@redhat.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tung Quang Nguyen <tung.q.nguyen@dektech.com.au>,
        Hoang Huu Le <hoang.h.le@dektech.com.au>,
        "shuali@redhat.com" <shuali@redhat.com>,
        ying xue <ying.xue@windriver.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "tipc-discussion@lists.sourceforge.net" 
        <tipc-discussion@lists.sourceforge.net>
Subject: RE: [net-next  1/1] tipc: clean up skb list lock handling on send
 path
Thread-Topic: [net-next  1/1] tipc: clean up skb list lock handling on send
 path
Thread-Index: AQHVUrBeZVmxpnX+zUGeqI7V5VOxVab7t0kAgACFBOA=
Date:   Thu, 15 Aug 2019 13:54:43 +0000
Message-ID: <CH2PR15MB3575D75487B422093AEDBE179AAC0@CH2PR15MB3575.namprd15.prod.outlook.com>
References: <1565794548-15425-1-git-send-email-jon.maloy@ericsson.com>
 <2060574598.8620705.1565848654584.JavaMail.zimbra@redhat.com>
In-Reply-To: <2060574598.8620705.1565848654584.JavaMail.zimbra@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jon.maloy@ericsson.com; 
x-originating-ip: [24.225.233.31]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: adb9146f-0416-46a2-cb60-08d72188203e
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CH2PR15MB3576;
x-ms-traffictypediagnostic: CH2PR15MB3576:
x-ld-processed: 92e84ceb-fbfd-47ab-be52-080c6b87953f,ExtAddr
x-microsoft-antispam-prvs: <CH2PR15MB35769578494D740989B6F8269AAC0@CH2PR15MB3576.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:431;
x-forefront-prvs: 01304918F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(376002)(39850400004)(136003)(396003)(13464003)(189003)(199004)(8936002)(25786009)(66066001)(86362001)(66476007)(478600001)(81156014)(52536014)(44832011)(6116002)(4326008)(3846002)(6246003)(76176011)(26005)(53546011)(6506007)(446003)(8676002)(81166006)(7696005)(476003)(53936002)(102836004)(186003)(66556008)(2906002)(486006)(7736002)(99286004)(64756008)(14444005)(6916009)(66446008)(33656002)(305945005)(11346002)(256004)(55016002)(71200400001)(54906003)(9686003)(71190400001)(229853002)(5660300002)(6436002)(76116006)(74316002)(14454004)(66946007)(4744005)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:CH2PR15MB3576;H:CH2PR15MB3575.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: ericsson.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Z4MCpYiv0lAE9jEbLUWPJE26WTS/6fI6ZBvczPsRvEDR6DH13wjvrGS7EEXwK3oAY91YumOuFFBAS/YlFejcmBbJOZub/xTz7i/AWvjAt4p2PQ7+anOl6lZhd24ORPEr4MS91f+ocEiKI2Q1KO6wMuLrQ2aFQrMHTA5Nw88C42PGDJrN6Vbbj+wkLI2I33XA9ZRePJgbl72H1AMT6GvKEw7A89S7K5bwMGS3ii4VnOi/CTz614UpAYVv531xrBMPh3E2nWU/ykRzokSzld7+fBzxSXSl81LLTIcZKlGq3UIiVQXjYezejgzxB7CWbECfmwxdKEO79fOogI0s1POtdKxK7UfceY12+MnzPpNXiAUBFemWIw+11KcuYPr5CiEMtlL/95yC6TvNjlxbKyfFdQ3fGJftJMdBn8n/MU7lnR0=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: ericsson.com
X-MS-Exchange-CrossTenant-Network-Message-Id: adb9146f-0416-46a2-cb60-08d72188203e
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2019 13:54:43.4830
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 92e84ceb-fbfd-47ab-be52-080c6b87953f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +GwaLCPjjWr9h6308OKq7pkQ4vtZkV3c9JTOLX9jQ2b1loEDjqL34ocAhGIi7YCI4UCoIpZNi1xZHilIjCmowA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR15MB3576
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogbmV0ZGV2LW93bmVyQHZn
ZXIua2VybmVsLm9yZyA8bmV0ZGV2LW93bmVyQHZnZXIua2VybmVsLm9yZz4gT24NCj4gQmVoYWxm
IE9mIFhpbiBMb25nDQo+IFNlbnQ6IDE1LUF1Zy0xOSAwMTo1OA0KPiBUbzogSm9uIE1hbG95IDxq
b24ubWFsb3lAZXJpY3Nzb24uY29tPg0KPiBDYzogZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsgbmV0ZGV2
QHZnZXIua2VybmVsLm9yZzsgVHVuZyBRdWFuZyBOZ3V5ZW4NCj4gPHR1bmcucS5uZ3V5ZW5AZGVr
dGVjaC5jb20uYXU+OyBIb2FuZyBIdXUgTGUNCj4gPGhvYW5nLmgubGVAZGVrdGVjaC5jb20uYXU+
OyBzaHVhbGlAcmVkaGF0LmNvbTsgeWluZyB4dWUNCj4gPHlpbmcueHVlQHdpbmRyaXZlci5jb20+
OyBlZHVtYXpldEBnb29nbGUuY29tOyB0aXBjLQ0KPiBkaXNjdXNzaW9uQGxpc3RzLnNvdXJjZWZv
cmdlLm5ldA0KPiBTdWJqZWN0OiBSZTogW25ldC1uZXh0IDEvMV0gdGlwYzogY2xlYW4gdXAgc2ti
IGxpc3QgbG9jayBoYW5kbGluZyBvbiBzZW5kIHBhdGgNCj4gDQo+IA0KDQpbLi4uXQ0KDQo+ID4g
IAkvKiBUcnkgYWdhaW4gbGF0ZXIgaWYgc29ja2V0IGlzIGJ1c3kgKi8NCj4gPiAtLQ0KPiA+IDIu
MS40DQo+ID4NCj4gPg0KPiBQYXRjaCBsb29rcyBnb29kLCBjYW4geW91IGFsc28gY2hlY2sgdGhv
c2UgdG1wIHR4IHF1ZXVlcyBpbjoNCj4gDQo+ICAgdGlwY19ncm91cF9jb25nKCkNCj4gICB0aXBj
X2dyb3VwX2pvaW4oKQ0KPiAgIHRpcGNfbGlua19jcmVhdGVfZHVtbXlfdG5sX21zZygpDQo+ICAg
dGlwY19saW5rX3RubF9wcmVwYXJlKCkNCj4gDQo+IHdoaWNoIGFyZSB1c2luZyBza2JfcXVldWVf
aGVhZF9pbml0KCkgdG8gaW5pdD8NCj4gDQo+IFRoYW5rcy4NCg0KWW91IGFyZSByaWdodC4gSSBt
aXNzZWQgdGhvc2UuIEknbGwgcG9zdCBhIHYyIG9mIHRoaXMgcGF0Y2guDQovLy9qb24NCg==
