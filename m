Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F208CB2A2
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 02:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732375AbfJDAFD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 20:05:03 -0400
Received: from mail-eopbgr1310097.outbound.protection.outlook.com ([40.107.131.97]:22752
        "EHLO APC01-SG2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729684AbfJDAFC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Oct 2019 20:05:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y+p3BP3H0I8zpiOwMU0OV1LhkcOQ2SF5WCfk67dzI6qEHy5XcUaXTCWDqxwPcfQieJmp91vpmeVW5dzJwHm+rbmiM3e9p2cKQdbWHSrNdygVnQ5k9RwT1gbZqhcc8XCtL7VStqr6IZWvyRRnnBT/KdKA6ptY3aVfOcdRW8HxxUNZK9Kg4YiuvzLYTE+IaYseO0ljcBAnkCFRugT3GZk7D5wH4JleJZem01wjAmdM4j/mVMM8roBkkYfb0NkCom67hoUF4lcuQuV8OxoRe7Ul+aTZ9HgUl8fLFCyBvnpaYH9HCJ/9MA/yTzn6oSOdtiLgK1nkA+c5SKW8CFY6Ia14iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rX0V24f2B3f5UdHJ3wJ/Xf3mWITdvriNw4SAM3c2t44=;
 b=htjZed7ycwOrHEkiyD4oYqCa5mgeUsVDa4ny3ADYAUX02DfCmidLnJrcNlcLy3tSBX+WFe8gpZk8jSDEyZij/i9gasUNqHS8mB5Hx4fITuH8LDRKrq+PVys7sdc10lIi6L/f9xZ2B0cd+ppbXg4OgXo2h1JIlMyEDJvbpgWh+KI3jAn/FESnJEprqnFwnAIx6+V8LjFxRB+LIHX4uJamVtATvt1fOEwFU8MR1LfhqsbIv0O1FvIpBfyzrutYjPjzLA2UzFQdcf20k/pI5HRrlAbrIf+jX1sFUiUWoykEGY62oZFJrj1sHW+2dQHygmUNsnC4tARm4BdwWuUbKy3Cpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rX0V24f2B3f5UdHJ3wJ/Xf3mWITdvriNw4SAM3c2t44=;
 b=CeyU2U6uPk4kW71e+OHmesvMIo55bw/s8dfgzzH7k7mb552U8r3wieavj4LsXWe8LPuJeLB68A7bazT61PmaTwOWCay6wuAQRUx1u6HdIcYCucmfNvHQflGOwLQf6nQ9WEGb6lPo4wyaR4pR0b/hRy1Ay6sklXQUqDMVFSIdSeI=
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM (10.170.189.13) by
 PU1P153MB0124.APCP153.PROD.OUTLOOK.COM (10.170.188.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.6; Fri, 4 Oct 2019 00:04:46 +0000
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::fc44:a784:73e6:c1c2]) by PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::fc44:a784:73e6:c1c2%9]) with mapi id 15.20.2347.011; Fri, 4 Oct 2019
 00:04:46 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Stefano Garzarella <sgarzare@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Jorgen Hansen <jhansen@vmware.com>
Subject: RE: [RFC PATCH 00/13] vsock: add multi-transports support
Thread-Topic: [RFC PATCH 00/13] vsock: add multi-transports support
Thread-Index: AQHVdSaH864CZhNQp0+75TF0dHxgwadJn5+g
Date:   Fri, 4 Oct 2019 00:04:46 +0000
Message-ID: <PU1P153MB0169970A7DD4383F06CDAB60BF9E0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
References: <20190927112703.17745-1-sgarzare@redhat.com>
In-Reply-To: <20190927112703.17745-1-sgarzare@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=decui@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-10-04T00:04:44.5644714Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=56687db4-1763-42eb-a64d-0901b0bd148e;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=decui@microsoft.com; 
x-originating-ip: [131.107.174.148]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 52f94434-2fc0-45ce-f561-08d7485e777f
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: PU1P153MB0124:|PU1P153MB0124:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PU1P153MB012446EAABEF25A6DC8C0297BF9E0@PU1P153MB0124.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-forefront-prvs: 018093A9B5
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(376002)(136003)(366004)(39860400002)(346002)(189003)(199004)(6506007)(26005)(33656002)(86362001)(66066001)(76116006)(305945005)(74316002)(66946007)(66556008)(66476007)(54906003)(64756008)(6116002)(66446008)(102836004)(3846002)(71200400001)(110136005)(71190400001)(10290500003)(6246003)(22452003)(478600001)(316002)(7696005)(7736002)(76176011)(14454004)(81166006)(8676002)(4326008)(81156014)(256004)(8936002)(476003)(8990500004)(4744005)(2906002)(486006)(186003)(2501003)(229853002)(11346002)(5660300002)(446003)(10090500001)(55016002)(6436002)(7416002)(25786009)(9686003)(99286004)(52536014);DIR:OUT;SFP:1102;SCL:1;SRVR:PU1P153MB0124;H:PU1P153MB0169.APCP153.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Si3ZLR0WKQIZ9Qd9sVwCX6lgvnp5G6+TitAsRyqyZSTwLkXyf8q6OKFRQ6CabWu97Y8p/MJyqiG+Sd7g/kahtHdPK7BMk6F7U+pY1Fcvyr4pGo7J4cp+yBbkqWkPXMYUL68gFs5SRzPCOuEPAOl05ryO0dC5apYEpxi5h7FNY+Rp0BluYh4LymnPQ4gjoKmPbhcGDOUQ0O0SbyXfIKcUiYG1sKd009NiChxjTzHpmLT4crbLZ+9HMRAbqFdFgGiWS8B6/lhYbqi4StoQT3kcRtKo4AsC+XymPz1DOCD66Lkmvq6VB5R0qy7MPab42kHBJ576Z2T+iux0+FLjgvt1TfrdxjvXo3ADLXNbETiWx2oZN/B/aCdBI/pJCWr6EUuX+eFvaKqhd52j5wXLByjsAY+Vlw4/2dSjX/vg+BGvmkI=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52f94434-2fc0-45ce-f561-08d7485e777f
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Oct 2019 00:04:46.1696
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nZ9xBu5JZzFMpSZk8j34iHM7XsjJVHeoPVcN1tbky+ZVFDlW1ZE8C0e4lMws6NprzU4aCXBuEDxqMiO/lNPDBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PU1P153MB0124
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Stefano Garzarella <sgarzare@redhat.com>
> Sent: Friday, September 27, 2019 4:27 AM
>  ...
> Patch 9 changes the hvs_remote_addr_init(). setting the
> VMADDR_CID_HOST as remote CID instead of VMADDR_CID_ANY to make
> the choice of transport to be used work properly.
> @Dexuan Could this change break anything?

This patch looks good to me.

> @Dexuan please can you test on HyperV that I didn't break anything
> even without nested VMs?

I did some quick tests with the 13 patches in a Linux VM (this is not
a nested VM) on Hyper-V and it looks nothing is broken. :-)

> I'll try to setup a Windows host where to test the nested VMs

I suppose you're going to run a Linux VM on a Hyper-V host,
and the Linux VM itself runs KVM/VmWare so it can create its own child=20
VMs. IMO this is similar to the test "nested KVM ( ..., virtio-transport[L1=
,L2]"
you have done.
.
Thanks!
Dexuan
