Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22EB9476771
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 02:32:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232605AbhLPBc0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 20:32:26 -0500
Received: from mail-bn8nam11on2122.outbound.protection.outlook.com ([40.107.236.122]:53984
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229616AbhLPBcZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Dec 2021 20:32:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Oi67YhNkxVaMGi2gSGy6+uBcscJCqKZ5dmtDtfz3/p6hzzSY/iO2naungsnJzadSezElxay0ZEozTarF/weE6InCnm5tWMuCw9Jg7+N70NLlIDwH1rDu4qZGws55uSAwhSGYgZ0ZcQENLXHn+17vyP3KBu/w8fninTUxxy2BP7IVzusbxsENnKBX43LiXjfGruvezxF0ZKEtNh8JYPk0VHbtCHjyAqhKAd1dsOg6UBMTkUNR4bVe46Am2T5RuUo/S85ZGDcofN5hdDnmryHyf86qan8+jPlVzXNNBoP1xPyqHIb8YVJz7GUaRTa1oSQF7ywzQTObp7W2rDnzbn2Afg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yp6wEZyDZLm4qzujszCi2BI5jBJMiz8Ci+zvb/+ALLQ=;
 b=huf19bLvg2p5cOK1TFA/EN9ZLQR7+wiU8ASgeXIBKxs+myD4Lxkums2NxfmTjb5necfbB+nAKUisBS9Vi7w6qC+bjRG6uFODcOAU4Dg3U/Fmki9GmgtNsAkwi/pM21r6PWihVDoBTVfJMY2cmauNWL7GPZNyh0AN9Zb2TCe/4CKpNcGWiowcaEKRq/16/HgDZjaoA0EDlC+Z6fpXGBX4BM+jGzIupyojgHew+wYiRM01w0MIjzSdxFbJEB0ZUOXTelziKFhL81aml+QaaAMo7hplqABwoZpopVEuS2MC1uFsDqa2THvihPcCkc+Wt0L/0BDp5l7BdMm7e6NTEHreAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=purdue.edu; dmarc=pass action=none header.from=purdue.edu;
 dkim=pass header.d=purdue.edu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=purdue0.onmicrosoft.com; s=selector2-purdue0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yp6wEZyDZLm4qzujszCi2BI5jBJMiz8Ci+zvb/+ALLQ=;
 b=SKyXd4TnjjM5yCb3/CTLJBPQ+xDwbmM93AzaHdJeTXNTLUFosA68TzR1V/Y4xZfUq13paNR2sB07HFhoW1SjPRs8MBQlhGqrjP0yytJ/cOVrBmwkR3yQgjUMoeAwOgd3NlyIY++GQpjBQn13hMAjIEgIyb/m4iFPpXTjk8Pc4qI=
Received: from MWHPR2201MB1072.namprd22.prod.outlook.com
 (2603:10b6:301:33::18) by MWHPR2201MB1744.namprd22.prod.outlook.com
 (2603:10b6:301:6c::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.14; Thu, 16 Dec
 2021 01:32:24 +0000
Received: from MWHPR2201MB1072.namprd22.prod.outlook.com
 ([fe80::e866:5253:a64f:a6f4]) by MWHPR2201MB1072.namprd22.prod.outlook.com
 ([fe80::e866:5253:a64f:a6f4%2]) with mapi id 15.20.4801.014; Thu, 16 Dec 2021
 01:32:24 +0000
From:   "Liu, Congyu" <liu3101@purdue.edu>
To:     "rds-devel@oss.oracle.com" <rds-devel@oss.oracle.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "santosh.shilimkar@oracle.com" <santosh.shilimkar@oracle.com>
Subject: RDS: Can RDS sockets from different network namespace bind to the
 same address?
Thread-Topic: RDS: Can RDS sockets from different network namespace bind to
 the same address?
Thread-Index: AQHX8hmak5+wRWxCJkKD7YcR9QouHw==
Date:   Thu, 16 Dec 2021 01:32:24 +0000
Message-ID: <MWHPR2201MB107202E590B041A3B1091FC0D0779@MWHPR2201MB1072.namprd22.prod.outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: bd8fb25e-9db2-34b1-68f9-1fa5bc848adb
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=purdue.edu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 954fd27f-1598-413a-33f4-08d9c033e962
x-ms-traffictypediagnostic: MWHPR2201MB1744:EE_
x-microsoft-antispam-prvs: <MWHPR2201MB1744F7CDE4789A42003D5B40D0779@MWHPR2201MB1744.namprd22.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Dev5pxhWX9jvyn/Bxtd7c+RHmt+72WvJOKJ6nrkvBtXPCWCcg8PZAZI5K1Tss8sncXI3cN576S9YPJkxdGxq4hQoMwVZNA4zeBO9xBnU1+dL3SYylcy0JqvgbYY6Zm/1LgasdHS1i8ZXlLrhoBp57l4IKnZJuarJGdZv1t2im96ehpGEcehraKMuB4/oc70oQSvhis414DC2GibzED9TOWHyDs3iHGEL4CoU0we6egXBV74DsBBNc1/+GoNouRoeSdujEPD4rS7vR2n9Xd/l0MzbNzifJolN5aI0XtT9K4scUFvdmoVIOmrmX6oD3lZtqSOjtlrXmRz1Ux+5DrV7gEVKxE3drlZH9EwOhyx30F+Isr60xUHWlj4PsNZVpxAI+sjEcsrcyeRZY2SRTFsTy9l3h5DhyZ2WNEzTSZbybAbRYRCJd+pUWXPVGhcRp66jJ7oPLwh+3jlh72peBFeLrkH+9eI3E40fDhyco/HuNJNGMymEP5skEGR85eh1UFW9/oYrxk5FAPxu6fBOTGmj1GM85gAaEGrcoN5zQbEWpy5vfaEHOqNpx7KR8bYfzGMZLqLnihh2axZU5M46e8uHt07OdjKrAGPGyiW1qG+R5Bvq+jJiiyrkK1c9SNFxipMM584RaW8p/+/EF2fqsylobp98ExKN2L4sy+DqgaWXZoNXRn2AONOJ1M9BU8nxhBsbJ83jPl84943y+RwYO8oGaQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR2201MB1072.namprd22.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(122000001)(66476007)(66446008)(9686003)(91956017)(64756008)(66556008)(66946007)(508600001)(26005)(38100700002)(86362001)(52536014)(4326008)(786003)(33656002)(55016003)(186003)(76116006)(6506007)(316002)(4744005)(2906002)(8676002)(38070700005)(83380400001)(75432002)(7696005)(110136005)(8936002)(71200400001)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?UoYs6czARwd9QGSkXUV246BvTt94Aq71HqJG12HFzWuvppKY5tAvMBxlWt?=
 =?iso-8859-1?Q?7g08hJ6MwsAKOdSW7q1mBQ72VMAl10mF6SXn62ljU3S0co0wBEonod2fpg?=
 =?iso-8859-1?Q?2nb/lvrc63nxoHlexzNIb+SCDsIIjtdjZfp9u9Qizh+QaIkE54KotX0bW8?=
 =?iso-8859-1?Q?g29zpbUdTX7cFTgvWMEtCdmeA9U9NtlHZpxU1El900z6ztcwBronfjf3iS?=
 =?iso-8859-1?Q?CdpTvIQjQXRw+CCVfOrzrOgL7nRQqk0cKDvNzqLoRWDsFcao1t0CmYzU9t?=
 =?iso-8859-1?Q?fKnCf9Is9pcxlYf+ksppMJA906mGVplFbLRNh+MnPHJ4yYdsZS9cBM0OQG?=
 =?iso-8859-1?Q?WGGDq4OmczncyNDzUUAPfbgBwhBaZoGLPHuarHqinABHucnINfZrCQsbEU?=
 =?iso-8859-1?Q?3VFpOpjnzfFfwt9zKOVGb30IAt9qDmT8bc1VekS88xxn5IKW6qvnfOETt/?=
 =?iso-8859-1?Q?JUTi/S5DVsjOfaxlcXkn0bgzSBVe5LyIL+OdfSbKZGCFiIsacKzQwiBMR1?=
 =?iso-8859-1?Q?ciCvGatlFHOeLQh7ihb++fipissrB2lmUSdvEK8dyyvcJSvOU6EOS/uS1O?=
 =?iso-8859-1?Q?pYZK3TZUKlLjS1WMon64gypjZzLIBvRiLu55wfqFqO6KiKwmhlviUXuapy?=
 =?iso-8859-1?Q?jBmQXO+1148ojA0pAfuZVu4wjj4IfciiS4bplOmZQci3VA37STR/vk70TN?=
 =?iso-8859-1?Q?c2d66D1JmTQ8UtiDkLpPXfzk1sZ0zAvCOH+59+xedqskOIj1nDSqTour+y?=
 =?iso-8859-1?Q?tnhoWoIWGr5bAPoJS7NSmJyPbLXvZQvC+fToFXFh4+57SkeLWkEWWZZnQk?=
 =?iso-8859-1?Q?tE2QI2x/NQUI7WLoAkz4WePlFLOut05pOwEdmCgh5/yadTpOFLiydg5/SO?=
 =?iso-8859-1?Q?mae0iiI/YyEnc0c6y3UI4zGbIzmBaNVBrDIyaebOFWXnggFvzg4LWeIFsM?=
 =?iso-8859-1?Q?FwzpxQkTdp3bC/BmGyWjsEB1UJUz8/D9SMTYPapaxN3aWWIAbjowJ0NTOe?=
 =?iso-8859-1?Q?zIReTqtWrl5mAQ3AT6/GlwnvHKPcIRzTIE+FMp1H4C8oIWkPaAzWY6SbIq?=
 =?iso-8859-1?Q?kc20rVuxGG0YdCjA7apK4iQTfVMJ5EolkUX1sIf/scOkHcs0//2PJtRDdV?=
 =?iso-8859-1?Q?DOl+zjFplCeLTEhQaBPAqFL/4/IY3YTMndkQJfUt1erk0xRYmBYvzs4UIH?=
 =?iso-8859-1?Q?c6gLPZiTpYtLNx7GJqiYyBcEVkBZklPDKZE9qm03cNrNhTLzcdWfkrir8l?=
 =?iso-8859-1?Q?3STGOkT17S+oD30u9heRLy5BlsvOf5JPpvOe4wNrQ+BkkEu/N6BGNhsiH9?=
 =?iso-8859-1?Q?vnHbeVyc9iWcTnCsbXqDkI5ZWoA/8fqDOc35j3Tj/a5Jf6wT6E8WNYGqUg?=
 =?iso-8859-1?Q?J/f0Dgto8FHZEFukoktcYUO86/fosmIc4F8OBKilD3DtAW2Z5yZRdh3/Oj?=
 =?iso-8859-1?Q?FEv72bZqVXO7pPyGJzHFxk4SCKQfUhXplK3bVDPN6TD0T/11RvhRYek3aM?=
 =?iso-8859-1?Q?2nD6NGEQ90CRc3s3qe7zoQIKv0V+dt8IrUQmD1FwuKvtilzAKZ93AM+dwY?=
 =?iso-8859-1?Q?AEPD5tFEacZcfFPneOpZQeCUan4W9OSm8aBBKPnvOb/O3CnsAzANJeiehG?=
 =?iso-8859-1?Q?kMAnng4DQyCbzuF51tJ9FnOkf44lCcPrDBV8+dcDl6p3SEPqIkvjLeFA?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: purdue.edu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR2201MB1072.namprd22.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 954fd27f-1598-413a-33f4-08d9c033e962
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2021 01:32:24.0458
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4130bd39-7c53-419c-b1e5-8758d6d63f21
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: e2Fwv1qBI0XT4LVqRBBN/+sXns2OJRpNMOFhX6QanRu1UAm+bC+AY+bxElp0EP4z1oXro7Fw32fLT7m0NM90fQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR2201MB1744
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,=0A=
=0A=
(Resend this email in plain text in case the previous one was spammed. Sorr=
y for the trouble caused.)=0A=
=0A=
I am writing to ask about if two RDS sockets from different network namespa=
ces can bind to the same address.=0A=
=0A=
I am doing research on container security. Recently our tool produced a sim=
ple test case with confusing test result: there are two network namespaces =
A and B. Both A and B has a tun device, and these two tun devices have the =
same IPv4 address. In namespace A a RDS socket is created and binds it to n=
amespace A's tun device. It works. But then in namespace B the other RDS so=
cket is created and binds it to namespace B's tun device, it fails with err=
or code EADDRINUSE. Is this considered as expected behavior?=A0=0A=
=0A=
=0A=
Thanks,=0A=
Congyu=0A=
