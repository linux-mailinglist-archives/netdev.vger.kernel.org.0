Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2A9FADCAA
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 18:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730033AbfIIQF4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 12:05:56 -0400
Received: from dc2-smtprelay2.synopsys.com ([198.182.61.142]:41584 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727495AbfIIQFz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Sep 2019 12:05:55 -0400
Received: from mailhost.synopsys.com (dc2-mailhost1.synopsys.com [10.12.135.161])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 061CAC2B0D;
        Mon,  9 Sep 2019 16:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1568045155; bh=e/UJGjNXRD/MpqfsqtOkseGBHSysp0B3sz09Hashra0=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=HyxVxlaSPP+hfwsQTfmNoOBWmWjHHFPwUw+L5xDEcFkV+ZGxEHWGhIENfWJldaGxf
         WRkL2a0cYr0wv3WWShMhZEhdVKoLM2jArjCJP+65KfPQLlq4uBv9pF4YyekVzOHTKj
         TjTmuOHU2ubxwiimBo0GQYspSEMgxTcBNAvSUFsAsPgDObXzfUFSvip7YjiTJHYIFX
         NvL9LxMX3dOiVt82CvL1CUt+MUUndlTzKf/A5j/tSrahfgnIyr6SHDlQUCFYqflgm5
         qK3CP0o6/kBn6ABSYcAimdEbifUcCyveTm//jLXLDTo2rQz8+dcJ6p/bLki1ttOIA5
         aTo3ZoVZfbWDQ==
Received: from us01wehtc1.internal.synopsys.com (us01wehtc1-vip.internal.synopsys.com [10.12.239.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 8C02DA0094;
        Mon,  9 Sep 2019 16:05:54 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 us01wehtc1.internal.synopsys.com (10.12.239.231) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Mon, 9 Sep 2019 09:05:54 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Mon, 9 Sep 2019 09:05:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QmlNb7Op3oekmVH+hjTmJu6+uLo1+xhwnUHuSiMO0YNFx4OxmfwrpfguBlBWmTPZ/zbxCmfI/FQeeUoirSg+S09luyY32eB1zn+ypu8cYtBPq1VffGSpLeTxikQfOUyXPGEW3Bo7dg60pQ2sgkO+J7RiK4yvzPaKZzdhQ4OdulzjDG3DZONnVp6MBpge9OiRpAll+MiG0BHxZmWmUCyG78F3ayJD5hexVc1/BW2YWGmNIu8wHQWyxN88OE1e0Gy4hoKbNP0lKd81cUDIC+vFZJQ1bqq2X9CH+UIk+rNoiOoKgDWi4fEbJyjpcEbKKGSPFl+ukdmqJLXN12I64TmEvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yUb/aSNvdWfUCnB/v1hB+6oqg2f4gIIYb8vVQjwZsnY=;
 b=OVwBeYYzOKSohPCw0Atq7ngUM65dDSl6J4lxO12ojTVghLNevi2baOMvEkKiOu+IOvMG/HEC45/mVaGGu1b6AE+0XQyayFgGC+BHr16upPVNAKr+WWbUKIIovAPI34z9FhKsk+XzW9NGbJpSrUenvcx9SIKRRPkYc57mop/IUyLVvDotlPSTEA0AWPivqKciYA2O1jPFwCCt2JtZW+9OoEPBHKPfCO0xF0f4wig+t6vxGmUMwTNhS09z8jktIkCi7ZY0ZfOOlVQsRYRTD1tp4t+h9zV878qU2uiPU1cdj7AUsoO+qKncfWm052VTCQrr36NwXU/9q0KADMq9szvWnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yUb/aSNvdWfUCnB/v1hB+6oqg2f4gIIYb8vVQjwZsnY=;
 b=N1KtfPMpKM0DzLwnB2UDvERFU/vIkm2by/69DNYZPeEWdSlJ4GOOqmMbaCiPIEvWWIKSZ/d44+y+rSjQDfX39VK1NXR8QuNiJGcMNeKBoCUAP2rNrZn/APPT8waCSaI973HtC32r7XaKkV/k2wcje3kbj4PwMG2Tam/bVP6N3MU=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.67.145) by
 BN8PR12MB3443.namprd12.prod.outlook.com (20.178.208.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.18; Mon, 9 Sep 2019 16:05:53 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::59fc:d942:487d:15b8]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::59fc:d942:487d:15b8%7]) with mapi id 15.20.2241.018; Mon, 9 Sep 2019
 16:05:53 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Thierry Reding <thierry.reding@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
CC:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Bitan Biswas <bbiswas@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: RE: [PATCH net-next v2 2/2] net: stmmac: Support enhanced addressing
 mode for DWMAC 4.10
Thread-Topic: [PATCH net-next v2 2/2] net: stmmac: Support enhanced addressing
 mode for DWMAC 4.10
Thread-Index: AQHVZyLugLltb0ZW10+a6Fka6Re0xKcjgesw
Date:   Mon, 9 Sep 2019 16:05:52 +0000
Message-ID: <BN8PR12MB3266AAC6FF4819EC25CB087BD3B70@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <20190909152546.383-1-thierry.reding@gmail.com>
 <20190909152546.383-2-thierry.reding@gmail.com>
In-Reply-To: <20190909152546.383-2-thierry.reding@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [148.69.85.38]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1fbde685-66b6-4e45-8d4f-08d7353f9713
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BN8PR12MB3443;
x-ms-traffictypediagnostic: BN8PR12MB3443:
x-microsoft-antispam-prvs: <BN8PR12MB34437E9256AAE2ABE7C7C659D3B70@BN8PR12MB3443.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 01559F388D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(376002)(396003)(366004)(136003)(346002)(199004)(189003)(53936002)(486006)(5660300002)(26005)(478600001)(256004)(52536014)(3846002)(6116002)(76116006)(66446008)(66556008)(229853002)(66476007)(66946007)(9686003)(7696005)(76176011)(6246003)(54906003)(110136005)(14454004)(55016002)(316002)(99286004)(66066001)(2906002)(6436002)(64756008)(4744005)(4326008)(81166006)(81156014)(25786009)(305945005)(7736002)(33656002)(8676002)(71200400001)(74316002)(86362001)(6506007)(71190400001)(186003)(476003)(11346002)(102836004)(446003)(8936002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3443;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: W/R7ULnY4EkC8ZzH2Gq3nILG7v5VdnDg9YGN6IDXtNYG1mMjVOjUp3gZLQo4qO9egwqG6UcpobVbWT0dGjsVUEANam/BApVPOK0fmkUhSPIV9IqUHCKVn2sV1f8KIPP/l8H4bmy3+b8X5TU1Lxee9H9NDr+hs532PxJLkXmy0iOmxFm5IKw4qoOh5X2OsyFL3c11G/D8PnIb0lgkCf9PSk+relmBA2WkJK1V6JJq0GkPUN++0fSpokevMqgeFxkoPoQAQqkWY0zLbwYEuxwQghQQffb5N12ZPtMmWhHZZjg1CILQZTsU81fBGwOyF1Wu/jMD+rMRQUmEioDYMa9B8Yyks9uPO6dKu5e3mCJyUoW7EmTvm8RUsXRq2c3BOIy7pPKhs5V02ps6+gbb9vtc1IT1pNA1Kn7UisIm2Kk2X+M=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fbde685-66b6-4e45-8d4f-08d7353f9713
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2019 16:05:52.8328
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eqkDYnCbbfXfEZt7kyYSbmMcDj7qAdKTsZCs4QFWxZV7WaRiI160rAiIQ2Vb4nRoAGwrMurvUxrU2h4//EzrnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3443
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thierry Reding <thierry.reding@gmail.com>
Date: Sep/09/2019, 16:25:46 (UTC+00:00)

> @@ -79,6 +79,10 @@ static void dwmac4_dma_init_rx_chan(void __iomem *ioad=
dr,
>  	value =3D value | (rxpbl << DMA_BUS_MODE_RPBL_SHIFT);
>  	writel(value, ioaddr + DMA_CHAN_RX_CONTROL(chan));
> =20
> +	if (dma_cfg->eame)

There is no need for this check. If EAME is not enabled then upper 32=20
bits will be zero.

> +		writel(upper_32_bits(dma_rx_phy),
> +		       ioaddr + DMA_CHAN_RX_BASE_ADDR_HI(chan));
> +
>  	writel(lower_32_bits(dma_rx_phy), ioaddr + DMA_CHAN_RX_BASE_ADDR(chan))=
;
>  }

> @@ -97,6 +101,10 @@ static void dwmac4_dma_init_tx_chan(void __iomem *ioa=
ddr,
> =20
>  	writel(value, ioaddr + DMA_CHAN_TX_CONTROL(chan));
> =20
> +	if (dma_cfg->eame)

Same here.

> +		writel(upper_32_bits(dma_tx_phy),
> +		       ioaddr + DMA_CHAN_TX_BASE_ADDR_HI(chan));
> +
>  	writel(lower_32_bits(dma_tx_phy), ioaddr + DMA_CHAN_TX_BASE_ADDR(chan))=
;
>  }

Also, please provide a cover letter in next submission.

---
Thanks,
Jose Miguel Abreu
