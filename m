Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD0C813BAA9
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 09:02:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728949AbgAOICH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 03:02:07 -0500
Received: from mail-eopbgr130083.outbound.protection.outlook.com ([40.107.13.83]:29415
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726132AbgAOICH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 03:02:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VZoSP8bW1woIJA9h7/k4ZJmYCiVOnJUF4qAV6x8AxTzSOgBReVg+Ha8m5kXdf4H5ifN7L/0mkGnZcc12L7J0rpCjxPPVdbMpXC4sXx4MxrrbHKpTp5fbeTxvVE44wekK4djgFqnYjzI0heTvVnDEw/9aI9E3H+onSe/8VkQsBZ1epxgc8t+1oMK+6TawuFCtSWIC/YS8bZiDTo2xmU4MYkhXDMCpo6NH61vL9FNvKJb+zoed891CbaSDDEtcU+A4fWuaGV9biAJ53zvxOq95UYHQ3xNGW1qbzmeb8jhIcax5qvKLBx0p5pXFVT5B8lkCI3c9+MOqtXyj+RgPSyXLCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mRWczO5XamKYk9xyLYcULwe4dvNu8C65P7vvGoeMRsk=;
 b=CSZEf1fsb1++0rEh4BUg6Yxl8wbj/1ckhngxijWSTrsGW+i8pYnw2RUVDoFD2noJ9jkczQ/wQIgIsDI3YuSfRrTkl3aYgA6iJ1EbQeKptTlWRZFgz+HkLFJk6s1EJ54K3LAemOKpANQVoEAyjJaZtXna+9EJgtqvqHW9RRPrmnJEvdqN/1YnVIB2X1co5CDYpL6EHT1T6SAfTzak43QVnBIdC3V50L2qanFHPOySgyD9CuCTPzLuRrtGQn+vFwGJWJfvZtpl/khXcvH7PLepyMwKGpUU4IE/hWPfJxQ6FBjLevJiogUVJEPyGJN0vkP9lvyK5AQQzgVANCbZF01Vrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mRWczO5XamKYk9xyLYcULwe4dvNu8C65P7vvGoeMRsk=;
 b=Qgp+NUszcE41IsaLGqCSqOtIpCeGueNZp2bEL+Rh0ZMX6jYC+LK6JMc8IR0Rb6BP8wFAFQQFwfL2eBncK3ej7fiempfPvGRExfhtKjnDhVhUH06yz/uOPqncaz2XW5SmZJqpZPZ9xhfIHikRHmmFPQzbTjbMKR0pWbdbqjIPklU=
Received: from AM0PR05MB5873.eurprd05.prod.outlook.com (20.178.117.153) by
 AM0PR05MB6194.eurprd05.prod.outlook.com (20.178.112.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.19; Wed, 15 Jan 2020 08:01:43 +0000
Received: from AM0PR05MB5873.eurprd05.prod.outlook.com
 ([fe80::a556:1de2:ef6c:9192]) by AM0PR05MB5873.eurprd05.prod.outlook.com
 ([fe80::a556:1de2:ef6c:9192%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 08:01:43 +0000
Received: from [10.80.3.21] (193.47.165.251) by ZR0P278CA0044.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1d::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 08:01:42 +0000
From:   Maor Gottlieb <maorg@mellanox.com>
To:     "j.vosburgh@gmail.com" <j.vosburgh@gmail.com>,
        "vfalico@gmail.com" <vfalico@gmail.com>,
        "andy@greyhouse.net" <andy@greyhouse.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Saeed Mahameed <saeedm@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Alex Rosenbaum <alexr@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Mark Zhang <markz@mellanox.com>
Subject: Expose bond_xmit_hash function
Thread-Topic: Expose bond_xmit_hash function
Thread-Index: AQHVy3oGgIF7KBJViUaUTiVJMTGSkw==
Date:   Wed, 15 Jan 2020 08:01:43 +0000
Message-ID: <03a6dcfc-f3c7-925d-8ed8-3c42777fd03c@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [193.47.165.251]
x-clientproxiedby: ZR0P278CA0044.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1d::13) To AM0PR05MB5873.eurprd05.prod.outlook.com
 (2603:10a6:208:125::25)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=maorg@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 2fe91b9a-f0f3-485e-89fe-08d799912917
x-ms-traffictypediagnostic: AM0PR05MB6194:|AM0PR05MB6194:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB6194371C42CC857EB01A20DAD3370@AM0PR05MB6194.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(376002)(346002)(366004)(39860400002)(199004)(189003)(4744005)(8676002)(81166006)(71200400001)(5660300002)(66446008)(478600001)(66556008)(81156014)(66946007)(64756008)(66476007)(8936002)(52116002)(31696002)(6486002)(186003)(2906002)(16526019)(54906003)(110136005)(956004)(26005)(2616005)(36756003)(7116003)(107886003)(4326008)(86362001)(316002)(31686004)(16576012);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB6194;H:AM0PR05MB5873.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vP7xkV0/jbT58r4Lcx/IDwaXYfHQSVAjQnu9Y/QZC4i66PG4QA/TQ0bLa8XdtnOCg4SHySWcScy2WpUsDu3pnh6n4iVOYyFjLOjng1YGc91IQmdoUxj3j7HGuNB+6LCWAJCbyH4DmTs0pbETVMxDGqwkmN19IkEzd4247qGNf0bxRhS9e9Sgbo+zF4iMz/cP3oG3F9o+fXLPNktU657vMn2R20F2qWgM0VgMMSL7ikRYC1eIUOzK56UW9hGUrRaswStmeCxh+6A+OLw3BfvZ3KO7LNfJ3vbYV2DmkNNeoL4SOtEb9UhclDOdCSxNB+wLoro8qpBAs4g4e/kiAgAtKqIV0ajxLUjJgnrcI2zNeczWPrNwuY+9GAR3PwR2T2KR96y38XZ/TCYviClyEnv8iHfevOl81kbswK51jCgXdMVxfsRhKvY0Bc4PjG1j9jiF
Content-Type: text/plain; charset="utf-8"
Content-ID: <76E2AC6C92E99A4E9799A0877E9640D2@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fe91b9a-f0f3-485e-89fe-08d799912917
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 08:01:43.6130
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2WrFdCL/m7a7UKbBiK1wTq92ELVMecQajbEbLl+wuDwXhWhO2MXDqMJql644Dx+/8WBB7AEl3fz6kNBNSut/rQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6194
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

UkRNQSBvdmVyIENvbnZlcmdlZCBFdGhlcm5ldCAoUm9DRSkgaXMgYSBzdGFuZGFyZCBwcm90b2Nv
bCB3aGljaCBlbmFibGVzIA0KUkRNQeKAmXMgZWZmaWNpZW50IGRhdGEgdHJhbnNmZXIgb3ZlciBF
dGhlcm5ldCBuZXR3b3JrcyBhbGxvd2luZyB0cmFuc3BvcnQgDQpvZmZsb2FkIHdpdGggaGFyZHdh
cmUgUkRNQSBlbmdpbmUgaW1wbGVtZW50YXRpb24uDQpUaGUgUm9DRSB2MiBwcm90b2NvbCBleGlz
dHMgb24gdG9wIG9mIGVpdGhlciB0aGUgVURQL0lQdjQgb3IgdGhlIA0KVURQL0lQdjYgcHJvdG9j
b2w6DQoNCi0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tDQp8IEwyIHwgTDMgfCBVRFAgfElCIEJUSCB8IFBheWxvYWR8IElDUkMgfCBG
Q1MgfA0KLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0NCg0KV2hlbiBhIGJvbmQgTEFHIG5ldGRldiBpcyBpbiB1c2UsIHdlIHdvdWxk
IGxpa2UgdG8gaGF2ZSB0aGUgc2FtZSBoYXNoIA0KcmVzdWx0IGZvciBSb0NFIHBhY2tldHMgYXMg
YW55IG90aGVyIFVEUCBwYWNrZXRzLCBmb3IgdGhpcyBwdXJwb3NlIHdlIA0KbmVlZCB0byBleHBv
c2UgdGhlIGJvbmRfeG1pdF9oYXNoIGZ1bmN0aW9uIHRvIGV4dGVybmFsIG1vZHVsZXMuDQpJZiBu
byBvYmplY3Rpb24sIEkgd2lsbCBwdXNoIGEgcGF0Y2ggdGhhdCBleHBvcnQgdGhpcyBzeW1ib2wu
DQoNClRoYW5rcw0KDQo=
