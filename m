Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09F4418673E
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 10:01:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730288AbgCPJAz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 05:00:55 -0400
Received: from mail-eopbgr70087.outbound.protection.outlook.com ([40.107.7.87]:63236
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730152AbgCPJAy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Mar 2020 05:00:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dTpJjL2CmiAdM3mvFbMusmqJ79caoQb2mas6fRqNhscdR2oMHcqCjwqR6wrccUgv2VY5KWLogjDZByBTUakG7TuiRrByWDBMfsisk0p4SNRfgzlAAUVsHXYQX+E7y/nSoD3uEt31qFs3QoiHV54Lvac2LBBFKXjumZ6K9Bd1yPMrnygPVqsZSZ5L8hUtaDt+dXuyNhJu0DsK70TgpOEEZcJZXmdg1m95UmRIq6bFQkiqIogPIUnn4XkZc34eBwSxvBNPjNeexNeb2EyNoCX+tJRZrCS4HdPavel0JhGJVMsQL7Y77LN0SLdCnY8VRiC4Wb7kpnyl95bcJ17S/kreMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zHVsVN94SSCHIVyOQVaVytdm9yDfTmajA/AjeITELOk=;
 b=TxJ3uMm6zbflDKottPFC5iccZFk821NQ/poTnJSB3q9Bn7yKCZyrsNKqdQ9fGBAModVFDiarkaL1fphwMhtV517fcNcd7kXhOfoJ3YppM4/ESDroI9NNH+adH3ze5AahJ3H+YggNLmmkUJz6CYaO9vlrsKZAJgHSeqp3rz/rk3zBx0O8fUqyQpnj187/s8CQ5zoAepJWMGTEUE1WnmIyJgHrINQBaTpND5ZGLw4BRSjbz8eGNcnnIH+Z0jhGcVF5wm53acqsOtHJAX9FvL/tpI8kyKhXia1jeZ0cWnPk3vZ3fMdp3ZvrdN5ft0f09XuRaqGHa5I2oQfBuNhQXarH6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zHVsVN94SSCHIVyOQVaVytdm9yDfTmajA/AjeITELOk=;
 b=ZwMjfMIjmJ9i+pvvSw2JD1bxLs5HePVrf63Dshvnk7rxGQsF6SNY7FuB1MX1PcuNzOXMhFpKkiDVAMn+ywFnXQKqwSAY04l+loqwrxUQi0tm7bQqTw1Ec6Rcoa9xIsD3KsX2KQ2FbnugaWOQBGmY+t168jbIXaCwqGsdkR9wL3M=
Received: from DB8PR04MB6985.eurprd04.prod.outlook.com (52.133.243.85) by
 DB8PR04MB5851.eurprd04.prod.outlook.com (20.179.12.77) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.16; Mon, 16 Mar 2020 09:00:49 +0000
Received: from DB8PR04MB6985.eurprd04.prod.outlook.com
 ([fe80::a523:58cc:b584:2c2]) by DB8PR04MB6985.eurprd04.prod.outlook.com
 ([fe80::a523:58cc:b584:2c2%6]) with mapi id 15.20.2814.021; Mon, 16 Mar 2020
 09:00:49 +0000
From:   "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        Leo Li <leoyang.li@nxp.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net 1/3] net: fsl/fman: treat all RGMII modes in
 memac_adjust_link()
Thread-Topic: [PATCH net 1/3] net: fsl/fman: treat all RGMII modes in
 memac_adjust_link()
Thread-Index: AQHV+S+S+wpsiCwtU0+eT3Hbq+n4/6hImSeAgAJDFLCAAA4jgIAABdtA
Date:   Mon, 16 Mar 2020 09:00:49 +0000
Message-ID: <DB8PR04MB69859B6027FCF8DFAF896F49ECF90@DB8PR04MB6985.eurprd04.prod.outlook.com>
References: <1584101065-3482-1-git-send-email-madalin.bucur@oss.nxp.com>
 <1584101065-3482-2-git-send-email-madalin.bucur@oss.nxp.com>
 <20200314211601.GA8622@lunn.ch>
 <DB8PR04MB69859D7B209FEA972409FEEBECF90@DB8PR04MB6985.eurprd04.prod.outlook.com>
 <20200316083913.GC8524@lunn.ch>
In-Reply-To: <20200316083913.GC8524@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=madalin.bucur@oss.nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [86.120.221.86]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: aa586f9d-687c-4514-b782-08d7c9888617
x-ms-traffictypediagnostic: DB8PR04MB5851:|DB8PR04MB5851:
x-ms-exchange-sharedmailbox-routingagent-processed: True
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR04MB5851D372F7CC5FA6A7691961ADF90@DB8PR04MB5851.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 03449D5DD1
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(39860400002)(396003)(346002)(366004)(199004)(52536014)(5660300002)(4326008)(53546011)(6506007)(478600001)(86362001)(2906002)(81156014)(33656002)(81166006)(26005)(186003)(8936002)(8676002)(66446008)(66556008)(55016002)(66946007)(66476007)(76116006)(9686003)(64756008)(54906003)(110136005)(4744005)(7696005)(316002)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR04MB5851;H:DB8PR04MB6985.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:0;
received-spf: None (protection.outlook.com: oss.nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YjRbpuU2tfWwRG8eRVdliPcsK375cDvCel4b10XIgf2v2t12iFJp++CI4fOrIdDt4SGukbvmxW+htzKoQeXfrq9bSRPYpt81RUqSdTMt77oRw9WDQqwggwXfo++nPxaV3kmR9kK4RDGWLjF2KDUFCk8reLcDYe9csYVLsTLFlRX0PhAYAh18OFvIb/mBSMHo0sT92CP3+Tz9HLbwdHllCsdvqInYuFJM94Pxpm0bpdwbFTJ1Mcp1GeP+ndX+1EkWcXwcdV4QG9+meNJb1QmnsQ4I92/CVLP2YUII921C8tkfjlag5Up3yNxdNL7JT/O874SlgM8vIRe0/5aJxftMIk7sPfTHwLuBPf235wjitLSAaMlViamUNBBZ/OJpSD4N8+aBPeryCkZMqJWLntMD6atdFTuOJ0fg4Agr7YGqPKpqLOCsfbbfoEZelxsyz4+G
x-ms-exchange-antispam-messagedata: 3mvDcOOBmr47vocuM1gu0BIOKpDrVyNyKprlSbYfTgjbJZOKrU8cai8n2sQTh6FL8IXRsSO4wW2SzNrr2j2CVEi3jvHBX26TyH8o4UOiA5y1jrFGH5NnGFtn9hFj2Qf00UqKOCcxjhyPcuVYN3XXzg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa586f9d-687c-4514-b782-08d7c9888617
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2020 09:00:49.7127
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jqu/2xNquolmWAuVhV0il7vZo8gzMBq3mww8JuTLPDOmyaroqIHJrQuZCCjLeopslZbDMVaUFDzc9LFyfqwOtQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB5851
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Monday, March 16, 2020 10:39 AM
> To: Madalin Bucur (OSS) <madalin.bucur@oss.nxp.com>
> Cc: davem@davemloft.net; netdev@vger.kernel.org;
> devicetree@vger.kernel.org; shawnguo@kernel.org; Leo Li
> <leoyang.li@nxp.com>; robh+dt@kernel.org; mark.rutland@arm.com; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH net 1/3] net: fsl/fman: treat all RGMII modes in
> memac_adjust_link()
>=20
> > > Hi Madalin
> > >
> > > You can use phy_interface_mode_is_rgmii()
> > >
> > >     Andrew
> >
> > I have that on the todo list for all the places in the code, but that's
> > net-next material.
>=20
> I don't see why it cannot be used here, for this case, now.
>=20
>   Andrew

I'll send a v2 with this, I was referring to the rest of them.
