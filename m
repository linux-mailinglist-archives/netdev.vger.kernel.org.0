Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4DBA80394
	for <lists+netdev@lfdr.de>; Sat,  3 Aug 2019 02:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387993AbfHCAte (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 20:49:34 -0400
Received: from mail-eopbgr1320110.outbound.protection.outlook.com ([40.107.132.110]:31824
        "EHLO APC01-PU1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387829AbfHCAte (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Aug 2019 20:49:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lPjaWNyJuI+REJsiHXhz8tOH1URf4MQj04LNUnu1qUJFr6+nAXFe6D06fSY1haXwa8nHBGJv4eDHgLczH13c8PAq4jAEazC8xGjGb51nL4aUxCKxgGCPWxgxUniylqSPTSxwHigRiav5yJhX8cM+Sqmiz/f5sZszyCAbgkpEmebouPadjJx0MJzUYpeqnKPNH4BU9m6nzpcqpyNppD2kj3KPye9eLDQJWWy8WFmZraeu9dsL1UMl22mW5aEQ4sf0rB5IMAt2FBcKeX22DeDP1Gw8IPEQ0O912nktamsPwZUjpt7lE6dgjmLhAHDlnwObbqXvQasRQcgBwQz6X1qiZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ql61G2A40Y+EmB0DIC9iiOc63uH2G5u5JDZy7f98Jvw=;
 b=ezjKFEG/Eqwqm4Iamas8rXGUDuVy7iw9pTom0XBRzacrtYvQ4SnOuXk1waIRNnPzpPb7few+pyYF4wVF+4O31wJhqOcaDL6cRu09qwFv0mR1LXwGfUe3IJMTIpYpAx0xT/5fInEsT3OrvESNvkGGWB10hLD5THvS/+QREPArG9Jb0RQO1FpeEnCxKtPRBa6ZqiwY5FBrQS0Eq9sJH3p9SuyoTiiugGYk02KpitYOJh7Ixha9HwOJVykaSIcSwkSAP5xoyOBw9aSwBD8tNN5nfm3/V4U96EyygAuAmkqgpC4Sl9tdz8SkRZJJ5uAlod4O6Q2VWgYVbE6253HA6Frk/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ql61G2A40Y+EmB0DIC9iiOc63uH2G5u5JDZy7f98Jvw=;
 b=O4KgGjLt49B8jkY4AbWNg/0tVgB82i5VzIbLH6qFRI3AP/QZmNYBuj8Nf4fd9K8tnZdSex1IptZtr4laEgznIgvgUmbvZn725e/f59VjlokUA3iRQI8yeB8r5MobEfo+2AFm0aOS34xJeN+rYxFbNkj3ZDTssuKEUaGBcCmeLuA=
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM (10.170.189.13) by
 PU1P153MB0186.APCP153.PROD.OUTLOOK.COM (10.170.187.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.2; Sat, 3 Aug 2019 00:49:10 +0000
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::d44e:57b7:d8fc:e91c]) by PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::d44e:57b7:d8fc:e91c%7]) with mapi id 15.20.2157.001; Sat, 3 Aug 2019
 00:49:10 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     David Miller <davem@davemloft.net>
CC:     Sunil Muthuswamy <sunilmut@microsoft.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "sashal@kernel.org" <sashal@kernel.org>,
        Michael Kelley <mikelley@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        vkuznets <vkuznets@redhat.com>,
        "marcelo.cerri@canonical.com" <marcelo.cerri@canonical.com>
Subject: RE: [PATCH v2 net] hv_sock: Fix hang when a connection is closed
Thread-Topic: [PATCH v2 net] hv_sock: Fix hang when a connection is closed
Thread-Index: AdVHPmu2nCw89Ds2Tx6HccJLUcFnXgCU8/SAAACnvcA=
Date:   Sat, 3 Aug 2019 00:49:10 +0000
Message-ID: <PU1P153MB0169BE2A2E4EAD2AF1D7CA66BFD80@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
References: <PU1P153MB01696DDD3A3F601370701DD2BFDF0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
 <20190802.172729.1656276508211556851.davem@davemloft.net>
In-Reply-To: <20190802.172729.1656276508211556851.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=decui@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-08-03T00:49:07.3776738Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=47561fa4-db4d-420d-ae70-f9252915535a;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=decui@microsoft.com; 
x-originating-ip: [2601:600:a280:1760:71c8:ee0a:27d:d7aa]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ebbaf1db-4954-479f-3865-08d717ac65ed
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:PU1P153MB0186;
x-ms-traffictypediagnostic: PU1P153MB0186:|PU1P153MB0186:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <PU1P153MB01866716B75B20F3FC1F6EC2BFD80@PU1P153MB0186.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0118CD8765
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(376002)(136003)(39860400002)(396003)(366004)(199004)(189003)(71190400001)(256004)(229853002)(486006)(54906003)(4326008)(9686003)(8990500004)(558084003)(6116002)(102836004)(22452003)(33656002)(10290500003)(66946007)(10090500001)(74316002)(316002)(7416002)(6246003)(52536014)(66556008)(66446008)(64756008)(76116006)(6916009)(66476007)(478600001)(25786009)(71200400001)(76176011)(446003)(186003)(305945005)(5660300002)(81166006)(81156014)(7696005)(2906002)(8936002)(86362001)(53936002)(46003)(99286004)(6506007)(55016002)(68736007)(6436002)(14454004)(8676002)(476003)(11346002)(7736002);DIR:OUT;SFP:1102;SCL:1;SRVR:PU1P153MB0186;H:PU1P153MB0169.APCP153.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: BBm+fM8ojWTpepvAa3xolZ6DC6IGqmo3Tic9hm/Nhw1p4lSbQuYkhGHb0u8CSckiP5s4wr2628KPLVamsi9/jdzZ3GNEYhm7GNb3CkSr+Ok4umBjKp3QBEz1exFSPTq56Wjpx1MkDbAzDJxF5tOdY0MZVX8WqL6LAf+ZJa2f69qINi8wmyFMeIW44AvsIoB9cq0nfugbEo1WLsZqU7kfZ5m4TU58SBYYnfXTinRGGrxrhSAqlmVFjy0d6nUPVQVCfGVhtPQbQAL/II6sdq4A90k4txwGFaVSLVPY37gsBtSRMg6p2hiD3GJEDUIHKACtodNe+BZvHdMV2amQ0Y+DhPv3SkiZmIt15+C2bKi6rIaAty4Nb7uOxl2DWtX2KLd4/eiEKnlxCEcMUVsfQGAKkbBdFTOQGrt2I8IyfsWuu3I=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebbaf1db-4954-479f-3865-08d717ac65ed
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Aug 2019 00:49:10.3566
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7FQ1fYYfaqwAwnRpcE4r5R40bwP/rxb0F+nakqQqFHE99ZPtm0O02PYqSaDL/SfK0YF7IasHVfSvmqGCAlnsdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PU1P153MB0186
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: linux-hyperv-owner@vger.kernel.org
> Sent: Friday, August 2, 2019 5:27 PM
> ...
> Applied and queued up for -stable.
>=20
> Do not ever CC: stable for networking patches, we submit to -stable manua=
lly.
=20
Thanks, David!
I'll remember to not add the stable tag for network patches.

Thanks,
-- Dexuan
