Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38A0CE6F47
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 10:45:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388020AbfJ1JpH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 05:45:07 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:23080 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732446AbfJ1JpG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 05:45:06 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9S9ee8g024516;
        Mon, 28 Oct 2019 02:45:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=+/GuAyQvudInGX/E2fX3ufLQAtzJVlBmi8F8JHpLBU8=;
 b=y2G+W9O9pfEY8rX3mGPFufbyF53HAApQl1tmpkJoQ1hJdNx3DQMIZPB5KsRr/AjxLCWZ
 Vmka9C3VQQELB/KoAhhkpJnyPjpo9n2/wsdqcJy/0tnZipJb7w9k8+00s7eshX8THGSg
 ghCpnXU8JpPKtG/ljpXlNyaYOc6zoXdBIQEUcAQx8PeQcLYq6iq+K0bwp5PBWPfls7N3
 +5yo+ZUAmq3Ijid6H9BnLnRR+rj3iYT0qyVnj2g27FVi6a4rxcpaDFqOBy/6mpLzcB2l
 TK5VNKItUpw+xfJk2jHrX2uOBVXJxi5WbKBwmX9RJCxDikEZz1eJ0ZzeJUfrUsQVdk6P Jw== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 2vvkgq5ey1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 28 Oct 2019 02:45:02 -0700
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Mon, 28 Oct
 2019 02:45:00 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (104.47.38.51) by
 SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Mon, 28 Oct 2019 02:45:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O4nsQuQWfxUNEaSDSmIWNyHkzwI1qanlnjH0LoppTzyNOf7/3y8lYLf3O/zbAtw9XSUdPkOLayvagvFeGo/XSFXVRy8tTkThh8a6utnLjPhcl2kM/ncrFeveIoohbxY5J+OQVJIvUxzC4mIqg2bjQUioAWUHSwANo2kSFhDiBJY2lYxJFfnpn+NN6XqqT5sHlma4z54nW4E52+LqZ8EOw+2hRAdwkkuPYKnJz8fqJT5g4X6Kk1RbwI6lsYlgE5jN6/kW2PeKpXzGfMBjneMRpyBtOcRgpoTFO1BciGt1UkMqHQQAm+FZsv/qgTGm9Pb4JHSNKbRwE0JJCcBsqGQMYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+/GuAyQvudInGX/E2fX3ufLQAtzJVlBmi8F8JHpLBU8=;
 b=h3UlkjJ2+b9dRa7IWmLo+V9RNkVFPJg9RjcO2RNRBel3kULzowfCJote/FgdBC+Wa595QSpiX/UBpxyheSsUIZWWZ1MEzHI1HdMXvPAoCmYojbj1b/BmSVH5oX/QIV/l/BW+elSGCTlKSSER2aFbcNZOy1EmaPOomPcImMbn0gSajR0RsainVYWg9slVpYKtEsgSfiNaYCt4/ABO4seM4ougAGyaNcdGd2TCieMT/q33wc595TkWiechc/GOFSMQsDSE8hr8hcnLVvYA6FTCymwTcZnqwftymKePFNZA4Riu0r56UDzccrpZJi5XpI43b9eYyYEzhpRMoWyBBTW32A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+/GuAyQvudInGX/E2fX3ufLQAtzJVlBmi8F8JHpLBU8=;
 b=Gj1k6EQK570N91NRjsgUmJMMQ/EF9YaJ9GvQtLpEzSO6axHwkxw0CDvtpJm3n6tf8LUNGFniD2QVzoML8Us6TppjO4MsZbotaeFO8RYa4XPz5KMuyVu7fDcK66xtlSF0yWLNCcHZySBYy9V8qtLIpRzcx15cUEbLVS7w8Nfn5AM=
Received: from BL0PR18MB2275.namprd18.prod.outlook.com (52.132.30.141) by
 BL0PR18MB2130.namprd18.prod.outlook.com (52.132.8.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.22; Mon, 28 Oct 2019 09:44:58 +0000
Received: from BL0PR18MB2275.namprd18.prod.outlook.com
 ([fe80::4152:b5a9:45c2:a981]) by BL0PR18MB2275.namprd18.prod.outlook.com
 ([fe80::4152:b5a9:45c2:a981%3]) with mapi id 15.20.2387.025; Mon, 28 Oct 2019
 09:44:58 +0000
From:   Igor Russkikh <irusskikh@marvell.com>
To:     Colin King <colin.king@canonical.com>,
        Egor Pomozov <epomozov@marvell.com>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>,
        "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [EXT] [PATCH][next] net: aquantia: fix spelling mistake: tx_queus
 -> tx_queues
Thread-Topic: [EXT] [PATCH][next] net: aquantia: fix spelling mistake:
 tx_queus -> tx_queues
Thread-Index: AQHVjXRcyIz//jz5UECSA8Tzdh7sew==
Date:   Mon, 28 Oct 2019 09:44:58 +0000
Message-ID: <c66134a5-c943-de24-a64b-a96a73d81a98@marvell.com>
References: <20191025113828.19710-1-colin.king@canonical.com>
In-Reply-To: <20191025113828.19710-1-colin.king@canonical.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0138.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1a::30) To BL0PR18MB2275.namprd18.prod.outlook.com
 (2603:10b6:207:44::13)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f3a43d90-571d-4d59-ae78-08d75b8b7ec0
x-ms-traffictypediagnostic: BL0PR18MB2130:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR18MB2130C117367457106085E4A3B7660@BL0PR18MB2130.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2582;
x-forefront-prvs: 0204F0BDE2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(346002)(396003)(366004)(39850400004)(189003)(199004)(81156014)(6486002)(6116002)(3846002)(6246003)(76176011)(52116002)(102836004)(71200400001)(71190400001)(86362001)(2906002)(305945005)(14454004)(386003)(31696002)(53546011)(6506007)(229853002)(486006)(26005)(31686004)(99286004)(186003)(446003)(11346002)(476003)(2616005)(4326008)(5660300002)(66946007)(66476007)(36756003)(66446008)(6436002)(66556008)(64756008)(256004)(66066001)(558084003)(81166006)(8676002)(8936002)(25786009)(110136005)(478600001)(316002)(54906003)(6512007)(2501003)(7736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR18MB2130;H:BL0PR18MB2275.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: V/PiYCeRm7T1xLilvX9FNIpeBnqmSQPU1PL5UypKP27xEQwAO0BhOPKnutDsLnON9d8uWW9iMT4eTG0fbon8y1RlLgNZrXJIabZ2nFJv7TRo1IWgSJZXQGnyoyZgVoo17yKS9xLrwXsH6zOJkVvTm0HBJYC/sZAjsyfThYexAX2AmD9GQtk0eOsHkdpUIL4dlu/I5Zmuh5r+rQ4WSytGG7I4S/EViDlzBF2rngL+/RBqJzFhFPgg7ETBsuNhpkuga6oj45V9G0Qy13eteT8HQhzdgENKoKyR00xjPEMhsTyO1GUkIta0sH6GOTWCcw1k6VK9QXRbxl2hiEtJAOW6i28vkO+chxPCJiQ4j8na88tLmYA8Vety4Pzzt0T/WVthqgrXN6690Ts92gKr6SDL9wkhPjwmUBJBcx1RQgDzbHEhQfIflyElcdQIMAmMI+r+
Content-Type: text/plain; charset="utf-8"
Content-ID: <B2696F5AB502894B8DEE3C82ADE2F35D@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: f3a43d90-571d-4d59-ae78-08d75b8b7ec0
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2019 09:44:58.3022
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UVlYwhGl3WlxqNWE0Vz8p7Bd8l6WqrSbdYsw3TX5WYSM/ZdtscssfI+YFVQp23rf1QKh05Kx///8xiwwUyXSag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR18MB2130
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-28_04:2019-10-25,2019-10-28 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhhbmtzLCBDb2xpbiENCg0KT24gMjUuMTAuMjAxOSAxNDozOCwgQ29saW4gS2luZyB3cm90ZToN
Cg0KPiBGcm9tOiBDb2xpbiBJYW4gS2luZyA8Y29saW4ua2luZ0BjYW5vbmljYWwuY29tPg0KPiAN
Cj4gVGhlcmUgaXMgYSBzcGVsbGluZyBtaXN0YWtlIGluIGEgbmV0ZGV2X2VyciBlcnJvciBtZXNz
YWdlLiBGaXggaXQuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBDb2xpbiBJYW4gS2luZyA8Y29saW4u
a2luZ0BjYW5vbmljYWwuY29tPg0KDQpSZXZpZXdlZC1ieTogSWdvciBSdXNza2lraCA8aXJ1c3Nr
aWtoQG1hcnZlbGwuY29tPg0KDQo=
