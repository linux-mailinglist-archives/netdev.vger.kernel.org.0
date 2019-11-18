Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBC6AFFE96
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 07:35:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbfKRGf2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 01:35:28 -0500
Received: from mail-eopbgr20049.outbound.protection.outlook.com ([40.107.2.49]:57815
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726302AbfKRGf2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Nov 2019 01:35:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZCHM4dHZfk3ExGO1tnGQ2x730WSU72594eAKZ93na6bMFBu6zqMfSzJp+PVGKPmEh3+DcIPAtnV3XkgVjsf+0MUM68fvsJRIJ7MQiQ4O9DHH3PKixG6/NVFfUalq70TJ2Xt4wlIlZh0U60Pe46KynApNEvDqmSnKhuhZnYkvajx+EFrlDRZmbt1T1JGj5mQIfotbz7GnIearEkgSk/Lv4lgeEp9mgclaQiJp9LAAwEUk5gzIU6X4qYocJ+w6HDsxPynFIn+yBX0ry9rx+edR8l8wmSoSV8p5XiLjA/akejw6Pjqgr4nDS41ONO2/hwp+EWRhY9fqMs1LbPJEihq3yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jn1xC+AC/0jnBiGu2Gmx3xNyn0mhh3Efqv6bBmBjpTU=;
 b=HhIfNTukI04bEZmNBbyja/0K7j2+nWskvsFoGOhNo4ciQeQiGDbjoKE3GcZLhIpJHyvXFpFdkHm0ktfGV1aOI4FEMtnbQ84WmbySLOjjz3UZeqb1y6iDbCsbKfwOoQBSt6R2e8yAka1CYwtiCo1176VUbf3ue3prf9guDnGT9KAuYCT9h+0EqcB2XtPcfyRRjntSqIK8GjJgHjdIZfZTFHlS7f1BPYApKwn1NjCs5CQdUDxDmve+PsG/CjjgsPpRSqbjdgpzNa3GHfQAjE/ZWk1UggF8vndf192r/wJbycUk7RigkAuS7P2YwoNAI7X9jooItJrOLYDZsIudoaMQYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jn1xC+AC/0jnBiGu2Gmx3xNyn0mhh3Efqv6bBmBjpTU=;
 b=IfZYPlIo5elpW/BB/+pJa5AT4AOBKIFQLEm1U+9VyHM/jaYd/aAPCOxuS4J0XY7qon3whUH66JdbQj+C9KmaTFIgSt7SXtD6bpYsob7ew80KLsZeMRa3/L70kwqrX5Nv8Ga/HGMSdxtI+d9/X6bYEg0IqGImHJI3/wm2okaj5Ps=
Received: from DB7PR04MB4620.eurprd04.prod.outlook.com (52.135.140.28) by
 DB7PR04MB5019.eurprd04.prod.outlook.com (20.176.233.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.22; Mon, 18 Nov 2019 06:35:25 +0000
Received: from DB7PR04MB4620.eurprd04.prod.outlook.com
 ([fe80::7915:7cc9:fee9:b180]) by DB7PR04MB4620.eurprd04.prod.outlook.com
 ([fe80::7915:7cc9:fee9:b180%4]) with mapi id 15.20.2451.029; Mon, 18 Nov 2019
 06:35:24 +0000
From:   Vakul Garg <vakul.garg@nxp.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Required guidance to debug ipsec memory leak
Thread-Topic: Required guidance to debug ipsec memory leak
Thread-Index: AdWd2QXmH/AhltijRLm1Z0DPO4/iVQ==
Date:   Mon, 18 Nov 2019 06:35:24 +0000
Message-ID: <DB7PR04MB4620A7723FAC95C7767573208B4D0@DB7PR04MB4620.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vakul.garg@nxp.com; 
x-originating-ip: [92.120.1.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 47024c26-76cc-4f2c-e735-08d76bf17e7c
x-ms-traffictypediagnostic: DB7PR04MB5019:
x-microsoft-antispam-prvs: <DB7PR04MB501928EBF7989514C8D871078B4D0@DB7PR04MB5019.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0225B0D5BC
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(39860400002)(136003)(396003)(366004)(199004)(189003)(6506007)(316002)(33656002)(66066001)(74316002)(305945005)(52536014)(478600001)(7736002)(99286004)(2906002)(71200400001)(71190400001)(14454004)(6916009)(6116002)(7696005)(3846002)(44832011)(2351001)(486006)(66476007)(5640700003)(4744005)(256004)(476003)(86362001)(186003)(64756008)(76116006)(66446008)(2501003)(8936002)(26005)(66556008)(55016002)(81156014)(1730700003)(81166006)(8676002)(5660300002)(6436002)(25786009)(66946007)(102836004)(9686003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB5019;H:DB7PR04MB4620.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UgQKxKjZqWJdbwbiq6coIMv56lNgA8wd8R0djnzIBzPjBuhBdDsUetC1Lu0tDZhs1oZm2luR35cVEhHPBa7pYrmt2kLglJOUn1axpmr48ZWvWK1b8n0i4BElMLNP4gN9+aHmp39w5HNa3kh8vfCNOqizm00VDI5GI76AQaAQzNZEeMnwmj8zJs3ldOAX0CqvTY7SdIG2O+Rx+FlRY/9JATLLIsClChosHmZLmLcRlqvGNzpfEn1dT/5hdOv8Hn9oOuVEpzvsG5dk3LlVwNXJMyA44UAbLVN8DPAxBIh08G/lJFr4Hu+DnZnifTQHtneaEy6lzCT67OmCtpoCw7aQrRj6PHcVYq8eUTaoj7OOCv0bOD6z1RaQXDPajy3Tn4w3CwYIZqE9NWlofF0El7UfOLXcxXSubWBm9Jzx0M8bSulRZq9bbkTIy0Dr9mvCG2Mt
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47024c26-76cc-4f2c-e735-08d76bf17e7c
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2019 06:35:24.8130
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4Tr340uKquRRABkQzxwcMtRfEpbM+rHAnnWJvmDosn5aIvZeF85XLJRMJxCmh8h0Tket2hGd/FWbkgc0pTRBpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5019
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

I need help to debug a suspected memory leak problem while running kernel i=
psec with rekeying enabled.
I am using strongswan for tunnel creation/maintainence and using kernel 5.4=
 (with e1000 ethernet adapters) on cortex-a72 based quadcore cpu.

My setup uses hub-and-spoke model (1 hub and 2-spokes).
In all there are 4 tunnels.

When traffic is running, the kernel shows that 'used' memory (in ''free'' c=
ommand output) gets incremented steadily.
The system keeps loosing memory and eventually after several hours, OOM kil=
ler gets invoked.

The memory usage does not increase if traffic is not run (and simply rekeyi=
ng is happening).
The memory depletes faster if rekey time is decreased or if number of tunne=
ls in increased.

'Kmemleak' does not show up anything.

I checked that number of states (i.e. net->xfrm.state_num) does not increas=
e much and states are getting freed as expected.

Kindly guide me about what else to check.

Regards

Vakul

