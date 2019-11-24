Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDBB6108138
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 01:17:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbfKXAQ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 19:16:57 -0500
Received: from mail-eopbgr690101.outbound.protection.outlook.com ([40.107.69.101]:53742
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726759AbfKXAQ4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 23 Nov 2019 19:16:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eaMb71EuO6CtBsf6FKNT2nHgStql9oxXbwoDnmftg1y3j759e0KHCEdrT12qLnF/LOwdg0+zySO3urST8/SG8c58mrq1JyIofBVdfXBCjV2SSTkVinqMPlTRjtRNMERfW7xyVxBvg4hRgL1N52eBKNl6plFKeUtjVCxP0wRxHxvCPB3QXBpYVizrAwMLhcno0suS/1ESgZUicEPor2XQqkPBXJlFUrkJLyCwd+nQ/higBM4TBpcnP0YPiCn6zzXOZHrREaYgHjFoThgBexybO5eLditQueXbZ7bM3SrT6cWTg+SB1jpBGsgGnJRDTLcz1Sc1ErEGZxwJfzXihIi4Wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=db982NEtJNrJs84iOemWnRBmKdwF1EtguUXaQpBcKBg=;
 b=cvuhKvrUf+GuODzlvti8ENNE3cNxQ1SjrxhzZoD3Se3ovEWRuBC1DAcc2G42WwlesSGMnJqXmUXKKCrPRhTsSd3PaDexmmHNfOXgcFhdOePSx67fG4h/Om2hW7U52dcfecD6E7JEIawFYYGcJ0Y8O3IaIIp+0rGrYsetsRn/znPilJbjpGALOP8svTXnm5ZwBt2r3YY81wDT+p+qaXihxMRK2w5E/UQL+abs5Pw4A9D/SImuEIbt2xQs6i3CVJLpVipZH6SiynCycoGXJufaK4QQBn49GHMqLN/95VVa9Fr4r0sNL+m9POHnTKkrCF4KJl/s9NbCQAk+GlB8GnX21w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=db982NEtJNrJs84iOemWnRBmKdwF1EtguUXaQpBcKBg=;
 b=EIcqNF/SXPjeLOWIbQq1j9f0/YuYwZHTEWGF/QaeGJW6KN9Be+zy4uSnsemSkv8RpL79EZwMCE8MRjgnP2hzb7QZ+4za4/9SVEVODzEoE2JVMhGMCP6T8taDD9GbJP13DFKvzBd6oKFkSY8060p9MFgr71/unl7AaYkSl1hLWIA=
Received: from CY4PR21MB0629.namprd21.prod.outlook.com (10.175.115.19) by
 CY4PR21MB0632.namprd21.prod.outlook.com (10.175.115.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.3; Sun, 24 Nov 2019 00:16:53 +0000
Received: from CY4PR21MB0629.namprd21.prod.outlook.com
 ([fe80::ed94:4b6d:5371:285c]) by CY4PR21MB0629.namprd21.prod.outlook.com
 ([fe80::ed94:4b6d:5371:285c%5]) with mapi id 15.20.2495.010; Sun, 24 Nov 2019
 00:16:53 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     Haiyang Zhang <haiyangz@microsoft.com>,
        "sashal@kernel.org" <sashal@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Haiyang Zhang <haiyangz@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>, vkuznets <vkuznets@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next] hv_netvsc: make recording RSS hash depend on
 feature flag
Thread-Topic: [PATCH net-next] hv_netvsc: make recording RSS hash depend on
 feature flag
Thread-Index: AQHVoljtevpdelkWREeZfsofwEuO66eZcrMQ
Date:   Sun, 24 Nov 2019 00:16:53 +0000
Message-ID: <CY4PR21MB06294681621B2E4895627152D74B0@CY4PR21MB0629.namprd21.prod.outlook.com>
References: <1574553017-87877-1-git-send-email-haiyangz@microsoft.com>
In-Reply-To: <1574553017-87877-1-git-send-email-haiyangz@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=mikelley@ntdev.microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-11-24T00:16:50.8178469Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=2a30fd5d-5916-42dc-adcf-f5faee9f8e2e;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=mikelley@microsoft.com; 
x-originating-ip: [24.22.167.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: aea97c38-e9ad-4bec-0303-08d770739c03
x-ms-traffictypediagnostic: CY4PR21MB0632:|CY4PR21MB0632:|CY4PR21MB0632:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <CY4PR21MB0632D8AC42AF53E60CCF3270D74B0@CY4PR21MB0632.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2512;
x-forefront-prvs: 02318D10FB
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(346002)(396003)(136003)(39860400002)(376002)(199004)(189003)(9686003)(4326008)(6436002)(102836004)(86362001)(99286004)(71190400001)(6246003)(6506007)(2201001)(26005)(6116002)(1511001)(3846002)(22452003)(110136005)(229853002)(76176011)(5660300002)(2906002)(14454004)(66066001)(8936002)(7696005)(52536014)(25786009)(55016002)(7736002)(71200400001)(10290500003)(74316002)(76116006)(256004)(54906003)(316002)(478600001)(66476007)(446003)(10090500001)(2501003)(33656002)(11346002)(66446008)(4744005)(64756008)(66946007)(8676002)(81156014)(8990500004)(66556008)(81166006)(305945005)(186003);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR21MB0632;H:CY4PR21MB0629.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wu8u+uV/oHn6LceztYWKYfV9E6N1pjAQths24CUt1xp6uaJFr2d8e1fMgtWINSrE/V6FA6Z/A0zietJqOUnbAGRvzZyKXV3jn6M4xsD1CmqULLHSkTZReKPSEV+Ulo1vArtJVZAtbozJYqsoA6fBXejHnumddBONgDKh7mjThM4RuICa/RjsEjd6uqYUxZA2nbGrbSsqVp0V4XVaepnCUnXyqg18TdFsXqkQd+Z0QiBOmXZkwtLcwduMR8hb+prhNXKKDjrhr06eWaZnZOYPQYCy1eGba83eq6pVEdSag6CaUwnl5zPfM0gI1kiGlb9iuM+neWO04iz6vvz0vs8YJjPuSZAL0dtdrLaghbGZigzjVxNGgPvXaZQEWLHoXPNFYKKV9qdsG5H1YtUEH3nppYHjeZ8NVDG7mLGuHHqG1O2gcW0wZrACpsM1iguUR+/9
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aea97c38-e9ad-4bec-0303-08d770739c03
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2019 00:16:53.5958
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4qzDZMcWn5aKjeNjC6p+xVyhU8ybBITjGhX6Xh4PZE38f6LcupfqMnGiz1htaZ8b4gvlxWR0j2SmTzmjafnbamt8QmCLoP5sUwMGtswURwI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR21MB0632
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com> Sent: Saturday, November 23, 2=
019 3:50 PM
>=20
> From: Stephen Hemminger <sthemmin@microsoft.com>
>=20
> The recording of RSS hash should be controlled by NETIF_F_RXHASH.
>=20
> Fixes: 1fac7ca4e63b ("hv_netvsc: record hardware hash in skb")
> Suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
> Signed-off-by: Stephen Hemminger <sthemmin@microsoft.com>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
>=20

Reviewed-by: Michael Kelley <mikelley@microsoft.com>


