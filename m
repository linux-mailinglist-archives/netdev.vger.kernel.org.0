Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8F3ECEB24
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 19:54:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729392AbfJGRyL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 13:54:11 -0400
Received: from mail-eopbgr770132.outbound.protection.outlook.com ([40.107.77.132]:24134
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728031AbfJGRyJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Oct 2019 13:54:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YKkYAo44WiLoj5h5g+IFj309k81gZTNh7OiO+u/pLO6JLXP2Mmv7HV7LE7596m6tKo9x7GxV/+Aw0zHmONETNgPIXjZTAp9ubOh7W/SXlqUvsU9GVw6hCnfEhAxcKppLsN8IAWyRm/k0kUYxAQ5CgnhVRXS+YEzOp/vUi0ffcR6U3ImXvI2s7FJ3FVRHcih15AW22wxLbR2dKJIUzGoaPmpR3QiqoQfBnmipiInpSwjwkKRWshTokSDOmkhUxXFuJ/uIPfTuwAu555kHo6yNNyLMsDMPe3IuW8XnpA5cjKqMqZCcT2APMfi9go0xcA6gOyK+N/5poHe4kvlm7M/tRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9RvPAO/fqVihpaIP37dSW4pf06JZ5G/EGSv7WbqSfuI=;
 b=BRcMoCGdwayLSQ5Z8Odv2rPWoX91tnCYrrIc1KRjxiYs+YFOq0Ov1IhRtoQ7X4ivwHU6FYW5+tSOu8gXEApRw69aONHyu9PCZn/4ZpFvcMlYThx1SQefO3RYIaTEhOVv4Sia4MEUdRDzIbI8/UvdkvlxbbHu/RIdUyEtXx/OzmLEALkEPocxoVJuUtAGX/9pjq0V2Q96cz/B99UDGcUqw/h0NWSAbfgyWogG0htbfwLgUlt68N8BbP1lyG35FtcVy1JIsp+wIfhNWb+P7neR2/MTkhAvunX6OcVCaMcdmrGKCzVeOm8ReqgdUMPj4Bvb1bF1x5L9lApyI45cBRWwMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wavecomp.com; dmarc=pass action=none header.from=mips.com;
 dkim=pass header.d=mips.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wavecomp.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9RvPAO/fqVihpaIP37dSW4pf06JZ5G/EGSv7WbqSfuI=;
 b=C5rq3Mi1hXMUER2AQutKMCcOUSd5Y2bhWRmeWWBLfKQsOuLaKE/ZFiUbOhpuRDlm7IxNldqXJFuEAazJFQZ0/Vg7lg7m641Ljp+aez5JIQrrI9WZMEm3RQ/6set+XC/V90EU25D+sb7IlQk4hdl1m/aqyojYCXOrJDW/kKTbJEk=
Received: from MWHPR2201MB1277.namprd22.prod.outlook.com (10.172.60.12) by
 MWHPR2201MB1549.namprd22.prod.outlook.com (10.174.170.162) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2327.24; Mon, 7 Oct 2019 17:54:07 +0000
Received: from MWHPR2201MB1277.namprd22.prod.outlook.com
 ([fe80::3050:9a38:9d8e:8033]) by MWHPR2201MB1277.namprd22.prod.outlook.com
 ([fe80::3050:9a38:9d8e:8033%5]) with mapi id 15.20.2327.025; Mon, 7 Oct 2019
 17:54:07 +0000
From:   Paul Burton <paul.burton@mips.com>
To:     Thomas Bogendoerfer <tbogendoerfer@suse.de>
CC:     Jonathan Corbet <corbet@lwn.net>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <pburton@wavecomp.com>,
        James Hogan <jhogan@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rtc@vger.kernel.org" <linux-rtc@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>
Subject: Re: [PATCH v7 2/5] MIPS: PCI: use information from 1-wire PROM for
 IOC3  detection
Thread-Topic: [PATCH v7 2/5] MIPS: PCI: use information from 1-wire PROM for
 IOC3  detection
Thread-Index: AQHVfTg24CyB7s+NSkO/VidtsBLaDA==
Date:   Mon, 7 Oct 2019 17:54:07 +0000
Message-ID: <MWHPR2201MB1277380FCFDEB8F78DD7742AC19B0@MWHPR2201MB1277.namprd22.prod.outlook.com>
References: <20191003095235.5158-3-tbogendoerfer@suse.de>
In-Reply-To: <20191003095235.5158-3-tbogendoerfer@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BY5PR13CA0003.namprd13.prod.outlook.com
 (2603:10b6:a03:180::16) To MWHPR2201MB1277.namprd22.prod.outlook.com
 (2603:10b6:301:18::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pburton@wavecomp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [12.94.197.246]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8d1fdfe8-200a-4efd-6325-08d74b4f5949
x-ms-traffictypediagnostic: MWHPR2201MB1549:
x-ms-exchange-purlcount: 1
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR2201MB15491EDEEBDB34B777A87F54C19B0@MWHPR2201MB1549.namprd22.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 01834E39B7
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(136003)(346002)(396003)(366004)(39840400004)(189003)(199004)(52116002)(99286004)(476003)(7736002)(305945005)(54906003)(76176011)(25786009)(486006)(33656002)(42882007)(478600001)(2906002)(11346002)(446003)(52536014)(5660300002)(6246003)(7696005)(4744005)(71200400001)(71190400001)(66066001)(316002)(14454004)(229853002)(7416002)(102836004)(9686003)(81156014)(6436002)(81166006)(6116002)(55016002)(74316002)(3846002)(44832011)(4326008)(8676002)(186003)(6916009)(26005)(966005)(386003)(8936002)(6506007)(6306002)(5024004)(66946007)(66556008)(64756008)(66446008)(66476007)(256004);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR2201MB1549;H:MWHPR2201MB1277.namprd22.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: wavecomp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Xl27fIRd2kYKARiSFl6U+R4ije02bxmrq1rjAKyEZhdoJ0dT1WOQH98Kgw4YCEOEggrKIzvEdJx4h8VB852vUR3ATOZr9swOnw9AmeE+S6aURLJZRondR41VimF8IyCts9kvy0LRJCLAIUKubT+2R3OgFh8NLyscBdSecJvpo6g+p7e8XiKc8sAdP2+PkIqWRAbjmoJD3G6x5GvDaeehs6kO4irgqSTq3ztn6yuX/fRgNlDCxc/4ts3uPdeU/3exnIaw/Ght45TXAyGZNZ+pq/3mUOVYwgnQIdQPfzbyNt90GFV1vQHhtTS+hX6wqj2EHxOyM+XXUjTvrKKDu5+V0btEejtkQW6dYLrzGXkPLlZKyl5CCGx4TXAFTmn5rhseggTsnXVZwOvw/tgw9SNLTaUgZyjdnr4khuTNp6bW0E2uZIdD/l3Kl17PCTD4yCELm4kH7WNEdwXeEa3X0NUFoA==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: mips.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d1fdfe8-200a-4efd-6325-08d74b4f5949
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Oct 2019 17:54:07.1604
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 463607d3-1db3-40a0-8a29-970c56230104
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z762+tNPLVXaw3/bbHz36e2rHevlxGAyorz+AaFqebpAkUYS8qxO0pLilOpCZqEXasw5CI0hqfMrUf0t1rO3/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR2201MB1549
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Thomas Bogendoerfer wrote:
> IOC3 chips in SGI system are conntected to a bridge ASIC, which has
> a 1-wire prom attached with part number information. This changeset
> uses this information to create PCI subsystem information, which
> the MFD driver uses for further platform device setup.

Applied to mips-next.

> commit 5dc76a96e95a
> https://git.kernel.org/mips/c/5dc76a96e95a
>=20
> Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
> Signed-off-by: Paul Burton <paul.burton@mips.com>

Thanks,
    Paul

[ This message was auto-generated; if you believe anything is incorrect
  then please email paul.burton@mips.com to report it. ]
