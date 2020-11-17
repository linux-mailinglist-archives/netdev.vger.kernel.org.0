Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 692252B5CC6
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 11:22:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbgKQKW0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 05:22:26 -0500
Received: from mail-eopbgr50043.outbound.protection.outlook.com ([40.107.5.43]:21062
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725774AbgKQKWZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 05:22:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mwQAueBqqCbpYpADbgH6bFm7n+86t68k+0sCkJapNmVecDfMt+tSerEpx+q9N5zqltDAsuuk/jpZBa47biLlaxpuv6QpnveKNCE3wQk7FQGTbClQZC5OQIo96t5OnxEtkgSaxtIgOM5M+YP4pZ/admL8H6xJ33WEt18Dpp0VhqOTd1TCbzxmlpGep1w4AuR1EHZVApIowgHiXdW1B0q07+Pv0JeAHBTU+an69wN7mdV0h4G25d+3T6l8qV+0IyDYg9TPd3Dkc1O0DWL/W3eJdIRBRq9wJkKsfByDUlSrEEneHe+EArB6IOpRejLZnAq5kUJSMbI53tkbMasRiEVX+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RLknlAtrNt5flfN2YZha8x9LvJig9NaFdbCiLex0upg=;
 b=N/MQpRRpEuFNZHnztCMsDNCJhtr4b+Jk32iu4QMuoGrJqNbHZP2BLo79GhAIjUAJRGzwcNZuIG5EybDzPJ1CwzUMbuNzpyeDZWWH3bILq0WfXfkqkNEqpb6w43Pmibs5jBz6YXASHGFuax4JBxTRAU0/uJNasMJMA6frqjzmnUBKGTWCdDE7E9GRZf2NUjzXlRGmTCwzh0IjdKgbyUsCye1oMBeMDjLwzYXM/Z92+rhJABmEevdLGmEDTDTITJhegAUORNP8MaYHPIOBvAmpUSsGEkvP2/2HWUoGM8cew0fijifNZdreJqItpIPly8y+6S/g0gXQnfYSxxKdRHIUjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RLknlAtrNt5flfN2YZha8x9LvJig9NaFdbCiLex0upg=;
 b=Y/jhiZCFl8LfaJJX7QdmV29WCPnKYjIZP758fCVTErKFX1jZ4LzM7YBaBX8rcKiXF1XBHA5DMlgQtZAfz4Q84qngpIXQ9p/3artvTdDeALAQgjFsw/wvzD3DpBLjFSjYVXM4Jy9fihrdMtlsEfGbvA2Dy3mSPRHNpM2qhic6OoM=
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com (2603:10a6:208:170::28)
 by AM0PR04MB4914.eurprd04.prod.outlook.com (2603:10a6:208:ce::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.28; Tue, 17 Nov
 2020 10:22:20 +0000
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::21b9:fda3:719f:f37b]) by AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::21b9:fda3:719f:f37b%3]) with mapi id 15.20.3564.030; Tue, 17 Nov 2020
 10:22:20 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: RE: [PATCH net] enetc: Workaround for MDIO register access issue
Thread-Topic: [PATCH net] enetc: Workaround for MDIO register access issue
Thread-Index: AQHWuSFXFSkkYIBaN0+iRGfbV9ZtTqnLpPoAgAB6d5A=
Date:   Tue, 17 Nov 2020 10:22:20 +0000
Message-ID: <AM0PR04MB6754D77454B6DA79FB59917896E20@AM0PR04MB6754.eurprd04.prod.outlook.com>
References: <20201112182608.26177-1-claudiu.manoil@nxp.com>
 <20201117024450.GH1752213@lunn.ch>
In-Reply-To: <20201117024450.GH1752213@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.27.120.177]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c31f4fce-01ca-4fd0-85a7-08d88ae2aaa8
x-ms-traffictypediagnostic: AM0PR04MB4914:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR04MB4914BD1EC896C8563470FAEC96E20@AM0PR04MB4914.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AuFgjJ6b62+FkcnBsvvgrFu3ZaAKDSlIBmwGvEn2C10Q9LLTjIv24RZQyOSdCcBOryvJybIZUoi+0BJwmdw4A9LrwjkwGv3/2f+LaRW1G987LCCSkPT2uIGkJAsxXhlrG35FGD1gl2hcHhsjHBa3hMhcn4hii/kcakmjbOleokOlp0lsUSQE8mrri3cf9XtLeUUn53l5G9IUjvmT0V6ZFMkbJvsLTc+qfIrQkwe9/+/+55MwC43JQx1kGVQyVyAsAGphj6LDYZp6HmFu0buz45VFBYKREVmrpODpCyoBN9aFewv5p9j4QTxzCQ91xX0B0E7Kv+uBBCyCrXZmWiSFjA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6754.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(396003)(366004)(346002)(376002)(66446008)(64756008)(66556008)(66476007)(478600001)(76116006)(7696005)(66946007)(83380400001)(6916009)(44832011)(6506007)(8936002)(52536014)(54906003)(2906002)(8676002)(316002)(86362001)(33656002)(55016002)(5660300002)(186003)(71200400001)(4326008)(26005)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 0lk+2AabCZhYVGN02vThEOSIRdtPlRGqyY76se10kV/ySm+9Lltzq+wG4DPXrxJafD0FBOaSvxBgDze7kzd5DdKB2Jh41/iyP7XcisR6qN8255Fz3asgkc9a1KE8Rv+YV+I5xnEhN9PA6mmjq5GgcIIxXyvfLCDbXnG61eBWD9wH3ejRiUApsPdR55dhNvkm1UdhmlLycsZgvHWJ28sjXn8Sybm0CRmHGEmyZHXBc/0Jvay/rXNDVvFrKs3oL7H5zBrj1Gu4CLsgAtTRs3C9jtG/AduieeuybsFS8jpyZH39fHKF4Agn4lV5EJufEPpBhXQuYgaCel93PzPRH4A/ua0Ze7KmPciDUdpf0gphekLFYJ11wWBmbz/n1des7j2IhCU7D3kZOE8oPYOHhdVO4eEPAdJvSj4NiTyhsbBxkOFr/3NL9YbKFtplCRU8UO3hro60WCkLs4unh8N3VxzJCzxmrJPR8aLXqwZ/aTirINcEI4U1k/t9/jbktZeUJdOmUlw/Zeet8xmSximPlNMgFmMYK28JUl1VEgNMLRFw832pLSx7FIML073r3CQbWjCVHU82jiJ0LuKuPvOdFOGJLI+iWX4/ouOWyv8L7vis77CgD3MVHYi7H9JP7M7jmgknxJT/R42Fe9IFqGiyCmDL3w==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6754.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c31f4fce-01ca-4fd0-85a7-08d88ae2aaa8
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Nov 2020 10:22:20.2678
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2ndI6bqAfPUPR02vcTnKoIfaA3SN4FolhmI/wVlpSL7GCtAGORjMtePiWcIND/i+oBctw6BPSxBcOTkzid4R3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4914
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>-----Original Message-----
>From: Andrew Lunn <andrew@lunn.ch>
>Sent: Tuesday, November 17, 2020 4:45 AM
>To: Claudiu Manoil <claudiu.manoil@nxp.com>
>Cc: netdev@vger.kernel.org; Jakub Kicinski <kuba@kernel.org>; David S .
>Miller <davem@davemloft.net>; Alexandru Marginean
><alexandru.marginean@nxp.com>; Vladimir Oltean
><vladimir.oltean@nxp.com>
>Subject: Re: [PATCH net] enetc: Workaround for MDIO register access issue
>
>> +static inline void enetc_lock_mdio(void)
>> +{
>> +	read_lock(&enetc_mdio_lock);
>> +}
>> +
>
>> +static inline u32 _enetc_rd_mdio_reg_wa(void __iomem *reg)
>> +{
>> +	unsigned long flags;
>> +	u32 val;
>> +
>> +	write_lock_irqsave(&enetc_mdio_lock, flags);
>> +	val =3D ioread32(reg);
>> +	write_unlock_irqrestore(&enetc_mdio_lock, flags);
>> +
>> +	return val;
>> +}
>
>Can you mix read_lock() with write_lock_irqsave()?  Normal locks you
>should not mix, so i assume read/writes also cannot be mixed?
>

Not sure I understand your concerns, but this is the readers-writers lockin=
g
scheme. The readers (read_lock) are "lightweight", they get the most calls,
can be taken from any context including interrupt context, and compete only
with the writers (write_lock). The writers can take the lock only when ther=
e are
no readers holding it, and the writer must insure that it doesn't get preem=
pted
(by interrupts etc.) when holding the lock (irqsave). The good part is that=
 mdio
operations are not frequent. Also, we had this code out of the tree for qui=
te some
time, it's well exercised.
