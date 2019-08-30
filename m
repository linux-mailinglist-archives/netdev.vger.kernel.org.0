Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1F84A2D87
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 05:45:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727826AbfH3DpQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 23:45:16 -0400
Received: from mail-eopbgr780110.outbound.protection.outlook.com ([40.107.78.110]:58752
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727066AbfH3DpP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 23:45:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B0y4A0CQW6zr95sMWlHEoM65A08HECG5DkF2LiQ6COIWNjPvZ9h2WqbxBFTsfrUiW4MBROBGnbShxsuJGfVSFRbAhICQS1JcK6A/b7mxffQ0vmIcBPTQvOnapH5s3u72Vnv1Net4tP8Gy0l3cYaS72qFI4fP/K5pgmnL+v87bBulK6YSKHVhZrjxGs9FT1PBfRG7S/3crlGbRkozSyQVAxDATUB1FUHLb7ulTPWfRbzKknKjwOezxwdf6fF1NFCDhdKZfQdnjzahM54IF+84RRB5CEXniOFN+/NGtRUaub8wHvCfX4ugkds4b1tZtKjJAw0OBkjuS5MLXEfCt76WDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sBc7LhUE5SPHAyUPylzINEdBWXYsyaXFwz+XV+FlD4Y=;
 b=TIehjzLYxZAOUmZfjyZAmJH4CNfJ1oC0jEEMnoHlrVF3DkQVJh+8N5XVaNpDHCuSOSf1sy6BxVVaG8a4JP8HnDHewLjRb/Y29s7Ve2xP07KYo5Vg3duAPju+0cIhe8EQBHBiHLh7wvTe5ov6g6G5MNU7/gxLq+2ZJDsDhsflIS1VTtJBOoOGOz93ltDnRvuKlAWe1nJBCn7UXgpRJdIS9KJdUlD6yFUNHH4q4jUJDd1N8v+Uyb8eEVq7OataTiH/QVi49lW7dQFhbi+rP9ZapBKgj2bVWI+7p4olWsC1z6DlKR/bkKlq6TKGgY0LGQdT7XDukuQH6crWfDRf5rukDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sBc7LhUE5SPHAyUPylzINEdBWXYsyaXFwz+XV+FlD4Y=;
 b=jAsqpwK5LmEzRuW9vgWpLn7qwg3/8r8YfL6YjjOye/Q0n/bJlRnRDicoXyrN9V6/4llhyFSQR6/PdcS2vP1XW1dORo1aFTKku2Pc71CDZ3H7FdMEaHdZrF13qsdtisAZ3n4wjAPd069a8D2N+N2RI8PPPTDNQO6lcLDI3tox84c=
Received: from DM6PR21MB1242.namprd21.prod.outlook.com (20.179.50.86) by
 DM6PR21MB1307.namprd21.prod.outlook.com (20.179.52.96) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.1; Fri, 30 Aug 2019 03:45:12 +0000
Received: from DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::d44f:19d0:c437:5785]) by DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::d44f:19d0:c437:5785%5]) with mapi id 15.20.2241.000; Fri, 30 Aug 2019
 03:45:12 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     "sashal@kernel.org" <sashal@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Haiyang Zhang <haiyangz@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>, vkuznets <vkuznets@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next, 0/2] Enable sg as tunable, sync offload settings to
 VF NIC
Thread-Topic: [PATCH net-next, 0/2] Enable sg as tunable, sync offload
 settings to VF NIC
Thread-Index: AQHVXuVTKcrOPqZvAU6UoB9OQNkO4A==
Date:   Fri, 30 Aug 2019 03:45:12 +0000
Message-ID: <1567136656-49288-1-git-send-email-haiyangz@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR0201CA0015.namprd02.prod.outlook.com
 (2603:10b6:301:74::28) To DM6PR21MB1242.namprd21.prod.outlook.com
 (2603:10b6:5:169::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=lkmlhyz@microsoft.com; 
x-ms-exchange-messagesentrepresentingtype: 2
x-mailer: git-send-email 1.8.3.1
x-originating-ip: [13.77.154.182]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 00ba6e0c-dfd9-43d4-2f87-08d72cfc75fd
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR21MB1307;
x-ms-traffictypediagnostic: DM6PR21MB1307:|DM6PR21MB1307:|DM6PR21MB1307:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <DM6PR21MB13076E7279ABFBAB83A3A48BACBD0@DM6PR21MB1307.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-forefront-prvs: 0145758B1D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(39860400002)(396003)(366004)(376002)(136003)(189003)(199004)(81156014)(8676002)(99286004)(50226002)(7846003)(66446008)(476003)(71200400001)(4326008)(66476007)(102836004)(3846002)(4744005)(14454004)(8936002)(2906002)(81166006)(256004)(478600001)(10090500001)(22452003)(6436002)(26005)(52116002)(316002)(6486002)(2616005)(25786009)(66946007)(64756008)(6116002)(66556008)(2201001)(10290500003)(2501003)(5660300002)(36756003)(7736002)(53936002)(54906003)(6506007)(110136005)(386003)(4720700003)(305945005)(71190400001)(6392003)(6512007)(486006)(186003)(66066001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR21MB1307;H:DM6PR21MB1242.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: nGE67xCBv0TZ+JAK4BXPQVGBoJ7DvTYIzk4pSB8HMJY1Au2/oyHnWAQuLH/4f1Z1c5ZupPE51l5QnPakoyPm/CctFL5YU1/jjK0lWDHu/BJBUiOIHbWpShLJqoxQoKz31Jwm+QubgSIq8SPSn+8PFXja1OH04Xd5+YiYemyreD6hQTSnQSHOatSuNW1kz7mSWPRCK5OBdeIlfr42iG83JhIkyxRzCLTKyVlSBJmHv1tKt9PGA2ynb4S2v04Ype88qQ0VNcMqA1vL3obCXEder8SHryrv2EEf546r2lbzBc+grShmt5wnfOtnXnjyhQDUjfROKCD5sW0SyqJ0fwbpJ0+wccU6mJW2ugHAHSjDCI9T63qjmDzUbIxSpBU7xWUulGK+A60Qg9GSZ+PRz+uzOqccY8xg8uKZVsO4n23Y7Qs=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00ba6e0c-dfd9-43d4-2f87-08d72cfc75fd
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2019 03:45:12.2900
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ydw27wmYFX2QyoVoOecgCAWXjT4WIE19xbB3bDQVmS50Ty+064yCKe9yls9kCoT9Oek6pC3EMYGw3Nav6ariWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1307
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set fixes an issue in SG tuning, and sync
offload settings from synthetic NIC to VF NIC.

Haiyang Zhang (2):
  hv_netvsc: hv_netvsc: Allow scatter-gather feature to be tunable
  hv_netvsc: Sync offloading features to VF NIC

 drivers/net/hyperv/hyperv_net.h   |  2 +-
 drivers/net/hyperv/netvsc_drv.c   | 26 ++++++++++++++++++++++----
 drivers/net/hyperv/rndis_filter.c |  1 +
 3 files changed, 24 insertions(+), 5 deletions(-)

--=20
1.8.3.1

