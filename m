Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7427DFC4EA
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 11:59:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727075AbfKNK7d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 05:59:33 -0500
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:56388 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725977AbfKNK7c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 05:59:32 -0500
Received: from mailhost.synopsys.com (badc-mailhost2.synopsys.com [10.192.0.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 30019C0BBC;
        Thu, 14 Nov 2019 10:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1573729172; bh=n7govGcjmjTEBRJfYy1NmymioS7SeEzf4CKM7IHTwBs=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=OVS/RTG9HdqovV/qkKTQaubXgqSAXvSNNFAvOCsNAPxtqGuV7fBICeP+VXB8NmoSQ
         DdV7youKb90etwSeSf6NrX3Oh2om0VWc53Dd2YAAFRgVFh1W/Kxx8OVDKNRfGIqV9g
         WaVOhvJddKMyQHhGhF7q3oplJ0PXwbgYQg6KqfGxQtdSrv72Z7u0tD9VwNu3FmBM9w
         rYEXL9oYYsVWQEn0svGlL+b/gJgb6kh7c/iNVGAESy6hlOqY8whSsowigHicORQBUL
         DE4DvwLeJw+S2Pz/t5e+aoMz6qUCYeYvpbSCq/LlcdrVktewfxCPBPxH8CLY1tgW/a
         FQ/YuY69MCFlA==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 6C2E7A006A;
        Thu, 14 Nov 2019 10:59:26 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 14 Nov 2019 02:59:17 -0800
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Thu, 14 Nov 2019 02:59:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PeKwKHsXIbglbWMQij7bqKD+LfRUdveLirU0t6aNkvZJ/lS4jdj/x/R9oKPuV20zBLK60zLzghbr+bBtqBe2zQdm8fF7uTtkf1jlfOfnzVVNmToYWjA6xjkaTzc4pmnH2K1GB1cfQC21VCiDro53c+Z+Dn7Mz/28LICM9c2EZ+1fNnG2RKCJmMfQTBfDMJ5TAQCsGA+JXF35Z6tfFI2wS8rw+7yIVhTQ5jieq4RpGdiOqOZi4GwlyEd7TPTnh0IpwyCnYd6bnWR7dfaQCplZ3fwsXbzd5OE0upbqk4k5qdtHxmlUefmENGKFY94utFB2djLaW2v2s722Rzuyl4RxPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n7govGcjmjTEBRJfYy1NmymioS7SeEzf4CKM7IHTwBs=;
 b=DTK8kx4jjs6GsfDY3Nt8Itpks5O+TQ6JDN7++IgC2qehi43OAC1b49ovOLqqK9rtm1Uh0+bhrIhuecf+hOddbF036QoblMdSmJlKHjaCmb0FQX/U1JsZx+z+Tnd1j/COxaIjlIEeXc8YaxgaGh5pA9KIe7BpG9Py+R1Ra9/t2tYQJJ4HQn0OOkNe7T74mlXNOpzs//mHCP7ctBcpej29SLi0/tWnlFtoDSG/1mkvrbBmulbEZqKCXHr6XST38xz/MhnclPvFeDnknZXsO+BfydNvNR1EXtM1lEBTy81eRSsv0Fueyywtepj/g+QitXPwC+raXhENghtPt27ChbF8SQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n7govGcjmjTEBRJfYy1NmymioS7SeEzf4CKM7IHTwBs=;
 b=P+jZ3NYRh2ktnVUvSD4jvxTwUwYsC/iawcMZRQ1686Vv5X7MncqBMmXw0eWzCH8b9KRSkYKhs3IqHGINDOBeIwB16xEJTkS7VOPyiif+USzBT1Ni0AXaOmFpDGTulHYQKLvTbQHpFKRrX2tdb6y9xt/KRk4PyTftlDGyAPWCRME=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.67.145) by
 BN8PR12MB3586.namprd12.prod.outlook.com (20.178.211.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Thu, 14 Nov 2019 10:59:15 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::f060:9d3a:d971:e9a8]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::f060:9d3a:d971:e9a8%5]) with mapi id 15.20.2451.027; Thu, 14 Nov 2019
 10:59:15 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Jose Abreu <Jose.Abreu@synopsys.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next 0/7] net: stmmac: CPU Performance Improvements
Thread-Topic: [PATCH net-next 0/7] net: stmmac: CPU Performance Improvements
Thread-Index: AQHVmjTVIKy+sjQkskOwmbUoUvU2VqeKgIVQ
Date:   Thu, 14 Nov 2019 10:59:14 +0000
Message-ID: <BN8PR12MB326648DB784332302BD0D7A3D3710@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <cover.1573657592.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1573657592.git.Jose.Abreu@synopsys.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 947b40b9-05a8-42f8-1f7a-08d768f1b046
x-ms-traffictypediagnostic: BN8PR12MB3586:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR12MB358694E78E5FD7B6892C5F88D3710@BN8PR12MB3586.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 02213C82F8
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(136003)(376002)(346002)(39860400002)(366004)(189003)(199004)(7696005)(54906003)(6506007)(110136005)(5660300002)(4744005)(55016002)(86362001)(2501003)(186003)(316002)(6246003)(102836004)(52536014)(26005)(76176011)(33656002)(11346002)(486006)(4326008)(446003)(305945005)(7736002)(81166006)(74316002)(25786009)(8936002)(9686003)(99286004)(71200400001)(71190400001)(8676002)(76116006)(2906002)(66066001)(3846002)(81156014)(6116002)(476003)(14454004)(66446008)(66946007)(6436002)(66556008)(64756008)(66476007)(478600001)(256004)(229853002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3586;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: T08PXLgGj0Jg2w7dwysUVJ/p5CHnoe21vAx47gndIAtiM+xlAFUi/wBuGihqjui7CDRIgtevyPq3n9eSGuNQ7iBoD3yAKQ+njma9iOfERAYKP1EbxxaI//SCQSaIed6RGvRqAoeHmRLfHk2kS4DcmgYS/+x/bTIxO4UL+eNAwquDybAlWIYB/QBuygNqDXF9vJh9SjvpCyZ8ZYjo4oXR6RatBzS5KI0ActM+DOOBWanrKq9wx30NzNXmrITpaBq0dWdF5GM94oPVDPNdFB/kNYM4p57VPGlnPVOqX0zynrgOWyxg3d3M/Y41sf42M1Hs81CmZL/D2vjb9E7JnUZ9UZ5omIIsE4VsKPM5Q+2GwDgEkrJ6xSGsij0GVbBM+daNqHEYNsDYbS7bt8cEFOtPNrS8cXdgg+jX4mUbd4Evzdss0TW3xVDs8V0xwfDba+u2
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 947b40b9-05a8-42f8-1f7a-08d768f1b046
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Nov 2019 10:59:14.8937
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tdOGzvdB9iAQvkm6qhd5zZWL9kkzobNt6r8ULKaLGAxhUh3r/aUSI8HfN/4RvSbRZGThmP2B03rbO2/cEO8c4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3586
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jose Abreu <Jose.Abreu@synopsys.com>
Date: Nov/13/2019, 15:12:01 (UTC+00:00)

> CPU Performance improvements for stmmac. Please check bellow for results
> before and after the series.

Please do not apply this. I found an issue with patch 1/7 and I have=20
some more changes that reduce even more the CPU usage.

---
Thanks,
Jose Miguel Abreu
