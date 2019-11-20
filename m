Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAAD1103F4E
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 16:42:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732218AbfKTPmq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 10:42:46 -0500
Received: from mail-eopbgr130071.outbound.protection.outlook.com ([40.107.13.71]:61934
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732209AbfKTPmn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Nov 2019 10:42:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TZd0JtKYLmEH5YZgmn5WdyS3XoqrqlucTNuQ+bTs6JsWMcmlTgFC6wNYO6+MWIRhObtNNqHBU6XOSyyHXiude3AO3ZaMJCT3somdS3qE7FBfi/QkvLARZ866cmGRor5tEkSWK05r0/WTzCOCnc79jfEj0Kn7RSqhCiEx98L8raLpkm0TauTkPZ/+yYK1uhEjqLPWEgqNn8MYJT/406tQrtiU50GlD5p6xfTVm5aSfxG4PHfKh9hG1nN5Q+ACbysuIW7K60FnvRtCh6OLR8tT+hnuVXxK3Lnr+KGn2ywZojDIP+Vrzo5bZyvcB+MnB9S6Xmdoujdevp7KIsCbzBxJew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ntsxCBqN48Fh87HEKEp36aMae/1Ko20fBUy/IwlWknA=;
 b=UR/b3wC4FyrKIn7Jcujn8HrnwZlC7E7aH4rN5yX1KCaGugxlhRDYWsqiXcLo9lTyBEA+ZZ6FYoY9TnsHLRNDUqbv5BaNL/F8zKRuzDQx9OsIxlAO/WERNZrsaUS9rEjMD5CPmtNiiDaS+N8VP8GaCad3xM9xH2FEZotGs9QKJhxiVjWDQhdPpeO0d4fq7fiocipIa5nwCwnsP5v9VHxu84ikXyw/S1VeuM5HvpsN6lHdls6WyAd98ros0qxEgyc4DmofZzqfH3zTkbBHGVDnh5KYoAh5pbs46YWG8x2y2P0nAoYvIMYohet9ZRZqAn/Ro9pEVeBGtSuWmbjfTd4qJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ntsxCBqN48Fh87HEKEp36aMae/1Ko20fBUy/IwlWknA=;
 b=YhI75TduDG8koThyOsIcTDhvcQWM9kdOaOIcjrbjs6HvCBvL1P0pxU/o8GJKYB6n96HRPye6wF3e/prQSmsidIK571urBlZ6fVm7sW8tCOp+fBUmdJJiqM/wKRn3DfQw35OoB+u4gZ1ooQjK0x6mxZ3ucMvTfdFLtklatPWxODQ=
Received: from DB6PR0502MB3047.eurprd05.prod.outlook.com (10.172.250.135) by
 DB6PR0502MB3077.eurprd05.prod.outlook.com (10.172.247.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.27; Wed, 20 Nov 2019 15:42:40 +0000
Received: from DB6PR0502MB3047.eurprd05.prod.outlook.com
 ([fe80::24d5:3eb9:d96b:c521]) by DB6PR0502MB3047.eurprd05.prod.outlook.com
 ([fe80::24d5:3eb9:d96b:c521%7]) with mapi id 15.20.2451.029; Wed, 20 Nov 2019
 15:42:40 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     Roman Mashak <mrv@mojatatu.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>
Subject: Re: [RFC PATCH 10/10] selftests: qdiscs: Add test coverage for ETS
 Qdisc
Thread-Topic: [RFC PATCH 10/10] selftests: qdiscs: Add test coverage for ETS
 Qdisc
Thread-Index: AQHVn6Mocm4KwGkon0KLnlCM/Wt2taeUK3AngAAHjwA=
Date:   Wed, 20 Nov 2019 15:42:40 +0000
Message-ID: <87o8x6d05t.fsf@mellanox.com>
References: <cover.1574253236.git.petrm@mellanox.com>
 <4c364de6add3e615f1675ddb4d2911491a65bd8a.1574253236.git.petrm@mellanox.com>
 <85h82ybmun.fsf@mojatatu.com>
In-Reply-To: <85h82ybmun.fsf@mojatatu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0163.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9::31) To DB6PR0502MB3047.eurprd05.prod.outlook.com
 (2603:10a6:4:9f::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [78.45.160.211]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1078ef90-c807-4ecc-5c5f-08d76dd046c5
x-ms-traffictypediagnostic: DB6PR0502MB3077:|DB6PR0502MB3077:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0502MB3077874A075B3D034C128FE5DB4F0@DB6PR0502MB3077.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 02272225C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(396003)(366004)(39860400002)(136003)(199004)(189003)(99286004)(36756003)(446003)(6916009)(305945005)(4744005)(86362001)(71190400001)(52116002)(8676002)(81166006)(229853002)(81156014)(6436002)(6486002)(2616005)(66446008)(66556008)(11346002)(8936002)(71200400001)(102836004)(478600001)(7736002)(26005)(6506007)(76176011)(386003)(316002)(186003)(14454004)(5660300002)(64756008)(256004)(2906002)(66476007)(6246003)(66946007)(6512007)(4326008)(3846002)(66066001)(54906003)(476003)(6116002)(25786009)(486006);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0502MB3077;H:DB6PR0502MB3047.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XTQWl317JFt4RLyZhcvzW9q8ql72m4ZAvTGMabESwsB9b+Fn87vlJ5/n6ETJBw/dxNZVMVSqmKlRFzP6NlSKqIXicMGYLIqZH/CIxXG/VYdbx4KNSXm9lKuivguc4MFRdUqgADmgvz+D/+IxsCss0YXskSmWSQVwP8dlQrGHklohW86WWQxRZSYSot4wRGKHQoW1jpc24NgEEExqEFUGisoBT1oIVQH3Z4JS5eC/2lClJ+T1Ge43y9UGAtIIttvC730uupT9l6yhD9zN0NiP+ZfHPPLWIiWGPU9vTIkD/p1SJ90V5KLexhqoXqNT94e1ksNS/f7Hfz+oTrtqxVnz6D1sl7ke7++dvICz/wG0OuFWg26eGHHt1/aJrqzEboWdLEx1m8cuXIHDrZnRLcejVsfy6mfRCbM/620GegbxCgbwW0iI8LWE0eW9FEiEd/mS
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1078ef90-c807-4ecc-5c5f-08d76dd046c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2019 15:42:40.6108
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cZrZ8OmAT7lhNCDFDN+zbeMeusbqrfttZg6DYzABJQ4o+SCtIN/Ag/I1x7cu5/zpMmF6fCAB4cw5h6Lw0WE6/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0502MB3077
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Roman Mashak <mrv@mojatatu.com> writes:

> Petr Machata <petrm@mellanox.com> writes:
>
>> Add TDC coverage for the new ETS Qdisc.
>>
>
> It would be good to have tests for upper bound limits of qdisc
> parameters.

All right. I can think of "bands 16", and then "quantum $(((1 << 32) -
1))", but I'm not sure the latter is very useful. Did you have anything
else in mind?
