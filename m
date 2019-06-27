Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 349D157D84
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 09:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726500AbfF0Hyu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 03:54:50 -0400
Received: from dc8-smtprelay2.synopsys.com ([198.182.47.102]:58800 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725787AbfF0Hyu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 03:54:50 -0400
Received: from mailhost.synopsys.com (badc-mailhost2.synopsys.com [10.192.0.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id B3131C01E6;
        Thu, 27 Jun 2019 07:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1561622089; bh=B7ne3IbXGZ/TKfJzqW2GtX1uN0dR02oaVMruRSk6E7E=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=VvhBW6WfHOO0UXn1/59+5dpUJESUH5YAPnNuIDXQRMBq6hUrQKMk1L7n7VtjWK4Ke
         XSbxLq/AwNS48JIQQGIo/cQ7rfbVve2l0FM12vX/bm2zBDaTg/USOF3ZatFGE3womv
         bESbXgjpxInntlIZvj/acteKMWU38szhfSGKGXOhPfCT9hjVwgsFf8UDBqfyzf+3qg
         x8jLE+tkU2QGgXh0v0tTTRVDQTnm9a/n+9WU7b89lVKiL39if6lNbekYOzqNmcSsCv
         hjEz6VXFJ9AqoAR35Pyk/CGyqeWMQ0T80/GmrgpmDrEp4m+VuMEhR752r6WqqTF2qJ
         Cozzzw4NrNtOw==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id DE0F9A0067;
        Thu, 27 Jun 2019 07:54:47 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 27 Jun 2019 00:54:47 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Thu, 27 Jun 2019 00:54:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector1-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nh5w54gthCZrzu7mT4aXxxGGVEuj7VNsVqsemS6cxQs=;
 b=AxAnptVDRnwl1TbRsT5+a7SfjO94/d6UTtq9EwXMXkml1kqrOl1bGExIzCu6rtU7PWDbwYX0NSHouOf5vtVsOKtVoV5GvihNfUIm5Z81q84u8Fu/wjWLz9qon0tbHjJVKW+kAxjR4flfmEwcoHrQVAlxGKAEtpHuGZTYowA/VNk=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.66.159) by
 BN8PR12MB3154.namprd12.prod.outlook.com (20.178.223.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Thu, 27 Jun 2019 07:54:45 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c922:4285:22a6:6e]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c922:4285:22a6:6e%5]) with mapi id 15.20.2008.017; Thu, 27 Jun 2019
 07:54:45 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Andrew Lunn <andrew@lunn.ch>, Jose Abreu <Jose.Abreu@synopsys.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
Subject: RE: [PATCH net-next 07/10] net: stmmac: Enable support for > 32 Bits
 addressing in XGMAC
Thread-Topic: [PATCH net-next 07/10] net: stmmac: Enable support for > 32 Bits
 addressing in XGMAC
Thread-Index: AQHVLCXEW9tZEUL+kU+32ccf84jBXKauPzSAgADjjFA=
Date:   Thu, 27 Jun 2019 07:54:45 +0000
Message-ID: <BN8PR12MB32669F715CFC897D72F193AFD3FD0@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <cover.1561556555.git.joabreu@synopsys.com>
 <64b73591f981b3a280ea61d21a0dc7362a25348a.1561556556.git.joabreu@synopsys.com>
 <20190626201953.GI27733@lunn.ch>
In-Reply-To: <20190626201953.GI27733@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f96484a9-f187-4eb9-d5ad-08d6fad4b885
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:BN8PR12MB3154;
x-ms-traffictypediagnostic: BN8PR12MB3154:
x-microsoft-antispam-prvs: <BN8PR12MB3154DEC0FDCC97DB3D189C40D3FD0@BN8PR12MB3154.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2150;
x-forefront-prvs: 008184426E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(39850400004)(396003)(346002)(366004)(136003)(199004)(189003)(6636002)(81156014)(5660300002)(52536014)(6116002)(478600001)(66556008)(64756008)(66066001)(66446008)(3846002)(486006)(256004)(71190400001)(71200400001)(6246003)(25786009)(9686003)(8676002)(55016002)(81166006)(8936002)(11346002)(446003)(476003)(6506007)(74316002)(2906002)(99286004)(14454004)(102836004)(26005)(76176011)(4326008)(76116006)(66946007)(73956011)(66476007)(186003)(86362001)(4744005)(53936002)(7736002)(7696005)(229853002)(305945005)(316002)(54906003)(33656002)(6436002)(68736007)(110136005);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3154;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: RBQsxu9Ar5p9d7t+lkCp1ggJxJM0qzF+tkzP1N1i8i2OgzCZGkRYCtnbXPscxkwYec6Gs5Y4YBg8MJQ8wgWu79qzOGlITFhf5VI9ob2USZiqsAedqMVMup62NvUHrmf2+4FzeQPSI00zFdTOxjcVLSUQOITF2fR4edM7xxKTbjZ9PLC4OHuYIfIvxaHuUQs/buFcK84HyququGp6H+StVCt2LPpbGzBufYeZbzbamC0hWbc+nhWQ5IpcSVxetEU+g3M4uYqbxJ4OdxVzELF+e+H7PqTTOrJVnAOdNZIlDvyOuTxkL1o7qIf3ZF+2cLJf6BbsFK5K1+cmy91GSXcc+3HMMqM/s9W4PRbT+keVC8dMf3lPQ5uzfqEK3ul9EsmtiyjOWwdpJehkhIKmMHYCK40iAduJ5dgmyKDEk8cQNTw=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: f96484a9-f187-4eb9-d5ad-08d6fad4b885
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2019 07:54:45.4703
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: joabreu@synopsys.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3154
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>

> > +
> > +	if (priv->dma_cap.addr64) {
> > +		ret =3D dma_set_mask_and_coherent(device,
> > +				DMA_BIT_MASK(priv->dma_cap.addr64));
> > +		if (!ret)
> > +			dev_info(priv->device, "Using %d bits DMA width\n",
> > +				 priv->dma_cap.addr64);
> > +	}
>=20
> Hi Jose
>=20
> If dma_set_mask_and_coherent() fails, i think you are supposed to fall
> back to 32 bits. So you might want to clear priv->dma_cap.addr64.

Yeah, seems right. Thanks for pointing!
