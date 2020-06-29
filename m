Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15E4520E528
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 00:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728866AbgF2VdZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 17:33:25 -0400
Received: from mail-bn8nam11on2123.outbound.protection.outlook.com ([40.107.236.123]:57921
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727104AbgF2VdS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 17:33:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wzz5qr+ho1e7m8icAD9m9QxXCY2d2aT2NQPbdNkhEOFPJ0Cv+Wy4SLhdCcOB3afYexD6H4jizmN8qUusvxZqlw1Av2zCAs+Ow1dSBaKfWGcCZS9nlKHraKmz0QWcNlHHvHbgvCzjzP2OycGK6lDF+fVQJJiJDqktk6i2dOT7wXVQADpx6UAEpouCtWNU5LwNAduFlzkXCORIHJUreocqsWljNWhhFr2Jf9LCTeE6UEb1N4K4Hg4tnmYJDBRm8osVI0W8ktLUN5cNF7TBGVNc1FL2cPYGpsjDetgWH4+SyorZoOF89NAo7SqtzIAv/AINH29QXRxQ4H7ChV2zsc9nUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nYrnzxJcU8btIwH52PEAVCH0DUAGG2ywYc0GpEvYX+A=;
 b=IN6/e3uvV7AdO/rXYgyeqFH7QRDc1bp3B0zOflawR7udRNrfzq8dX0e0rssmcMxUa2wcX9x6cHZSa8axQmLuiXNzFw6JKOs3sj0uDHG2iH1pdbENcE9B/TutS76dRyMVkgIchgyI6XSxwTyL0htitE+EZLZPcbwk+CdiDfnHja0fG8SgqyeBPiyQ3YJDm3QysZngy2kL6WyDd3l8NyT98lojGTz9vO9VavI326Gdb45leEVPi7zFj+lU2bnPW+lU41o44arJviZNXnsyreO2JvpYZQ12jGZB2vI6NcA1qmZStpAVyGOwoj/Hd1yrbmN/ZT0ET+v/KHKtxf56T/xCMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nYrnzxJcU8btIwH52PEAVCH0DUAGG2ywYc0GpEvYX+A=;
 b=XyCXBNdvjlMo2vYcVgWLCRu17EEWyhbaVldDNbEpZgQUetlbKCCvnH/xT0tqclfcdGKtHScMqhhNQyDDCDshdTPXyh9ooDrjoTWUoBn3tXLRq5Ys02qFz+tmU9A3DO3+pLmRpa7JV+naY0UmwlvQHyw+hFs5W4rd6NARVuahnOI=
Received: from BL0PR2101MB0930.namprd21.prod.outlook.com
 (2603:10b6:207:30::18) by MN2PR21MB1502.namprd21.prod.outlook.com
 (2603:10b6:208:20b::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.1; Mon, 29 Jun
 2020 21:33:16 +0000
Received: from BL0PR2101MB0930.namprd21.prod.outlook.com
 ([fe80::421:be5d:ef2e:26d2]) by BL0PR2101MB0930.namprd21.prod.outlook.com
 ([fe80::421:be5d:ef2e:26d2%3]) with mapi id 15.20.3174.001; Mon, 29 Jun 2020
 21:33:15 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Andres Beltran <t-mabelt@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Kelley <mikelley@microsoft.com>,
        "parri.andrea@gmail.com" <parri.andrea@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v2 3/3] hv_netvsc: Use vmbus_requestor to generate
 transaction IDs for VMBus hardening
Thread-Topic: [PATCH v2 3/3] hv_netvsc: Use vmbus_requestor to generate
 transaction IDs for VMBus hardening
Thread-Index: AQHWTlBOt5wFAhylskCGZqmzM/7PA6jwHLwg
Date:   Mon, 29 Jun 2020 21:33:15 +0000
Message-ID: <BL0PR2101MB0930DB73E3B5A89DD3E55481CA6E0@BL0PR2101MB0930.namprd21.prod.outlook.com>
References: <20200629200227.1518784-1-lkmlabelt@gmail.com>
 <20200629200227.1518784-4-lkmlabelt@gmail.com>
In-Reply-To: <20200629200227.1518784-4-lkmlabelt@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-06-29T21:33:14Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=9edf559a-a80f-4927-b0c3-955bfc01ee57;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0
authentication-results: microsoft.com; dkim=none (message not signed)
 header.d=none;microsoft.com; dmarc=none action=none
 header.from=microsoft.com;
x-originating-ip: [96.61.83.132]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: cce00089-f3d2-4439-d2b8-08d81c7408a2
x-ms-traffictypediagnostic: MN2PR21MB1502:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR21MB1502B797D725F0B00A3CAE75CA6E0@MN2PR21MB1502.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1upvecUw1LzG7CfIDxqgy15QxscDOxGbbMef1tN4ZPLxtsiFoGSmBtfCWwL5RhwFAoN/FWMcvXdozGBvRzUv3jWVzE5X1HlE5UQHMOhU9sDVfJKh2xXtObNsp1T9SbqmaGSHJYvf8GxU5/UWzcphG/6ZLqftFJ40Iue6fTHS+03ekt0CyIr8QEyVHUp3kMImsbexUKsOuOliE0OKClsyyf6NqnhuK79+/YCc68AKuAKBYzGErft6S5ENZycslrdzLVQn5oKnjRN4wdu8S/o/aebCso5vZWdwol3Z7KPS3I8p+OsWgCIVKQ50LsjtYu98K7cuMbieXQUFcZbt/o/Mmw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR2101MB0930.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(346002)(366004)(396003)(376002)(39860400002)(66946007)(9686003)(4326008)(76116006)(5660300002)(316002)(54906003)(110136005)(33656002)(4744005)(55016002)(66476007)(71200400001)(2906002)(66556008)(66446008)(64756008)(7696005)(26005)(6506007)(52536014)(8990500004)(478600001)(82960400001)(53546011)(186003)(86362001)(8676002)(10290500003)(83380400001)(8936002)(82950400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: YAUupRnuA5XO6E10eFCnln9xT/C8uPFk/9qoJPemZDK2Y4AFGJjLLO02HO/tR8VuTQGcY16FYvs9X64aDLqF8w7gKXvLb39A2ELDKDvopaNPiZd3jLq3lgJQerMXKjfREFuXXRqbMlQRnpXLMmNWXfWctTzTlwvKgS5zZs/ctUNslCJmUHBaol+Ov/bmqWRONI4F5aeaTrczYrc0RoVyJAzGSdAJcWCPkug6SwRDXVEmEr0F4GQ7eAqBRJTwpC4wEWj3DwiG4z3qdBQCIcdTPOpPvBMMlZlBtbZu8bJWhoDx95rhqneriOxDc55OA+VRaxvO/hQOKpAvtB4irTnMlsdwUJUZtXhxiwxsYXoqNPhX1V9PNwqsHXH6uthIVRe5x6XcSWTcSSo3gZ327BVTm1qDDMPHtdE7enDr6Um5OGnFEL33ZK4XUla1WxZtoR/qVUls3NCVDw3berkZCxD573TkE5uXQe/5agLUhDaSGkw=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR2101MB0930.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cce00089-f3d2-4439-d2b8-08d81c7408a2
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2020 21:33:15.9078
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rYZmrx28L4ya1nj0K1AmyIN3Cp0iul/FFEmzx1n0uR4lxwdP/EUsuJqIHP6fQBnDuX0mRtQnwcpqqFuhlRXicg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR21MB1502
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Andres Beltran <lkmlabelt@gmail.com>
> Sent: Monday, June 29, 2020 4:02 PM
> To: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> <haiyangz@microsoft.com>; Stephen Hemminger <sthemmin@microsoft.com>;
> wei.liu@kernel.org
> Cc: linux-hyperv@vger.kernel.org; linux-kernel@vger.kernel.org; Michael
> Kelley <mikelley@microsoft.com>; parri.andrea@gmail.com; Andres Beltran
> <lkmlabelt@gmail.com>; David S . Miller <davem@davemloft.net>; Jakub
> Kicinski <kuba@kernel.org>; netdev@vger.kernel.org
> Subject: [PATCH v2 3/3] hv_netvsc: Use vmbus_requestor to generate
> transaction IDs for VMBus hardening
>=20
> Currently, pointers to guest memory are passed to Hyper-V as
> transaction IDs in netvsc. In the face of errors or malicious
> behavior in Hyper-V, netvsc should not expose or trust the transaction
> IDs returned by Hyper-V to be valid guest memory addresses. Instead,
> use small integers generated by vmbus_requestor as requests
> (transaction) IDs.
>=20
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Andres Beltran <lkmlabelt@gmail.com>

Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>


