Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 633BCBED4D
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 10:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727528AbfIZIWd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 04:22:33 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:54538 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726558AbfIZIWd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 04:22:33 -0400
Received: from mailhost.synopsys.com (badc-mailhost2.synopsys.com [10.192.0.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 6A575C0487;
        Thu, 26 Sep 2019 08:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1569486152; bh=fIlfkGsWB7MdK0KAVV7hX2roAUc0zb0oHDHdMIvMkaM=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=iIBFxW/RXIO7caeaKPAa9ibJAIBrx0gI84Uc888rLv34OsCkP7n9nmpoj2iQ9ogJ6
         7OcET9Tz424MwikXepRmcUSgWgvn/kaBxyPRNih7KB/dz4E0hi/jEsAExYiANS4CHR
         R9T4sRcnuqQEpBBJtN58YvpdUjGeUyh0tNnRHGZXg4KtthMr04J6I1om/O+6TfGiQ/
         2xPjKdSLhzQ1dkryPuqaSoCSBUshAmPlX5vqg1FP9szW43GqeVIE8r2ncgeZR7vZhW
         3gM6tVEZ5P6XdmbHVZkIvfqAlXlcw4iPo/bRBgErc36Jgzl90IvZ1S+iX9zc/9rymZ
         LkVy6e+SKqDbg==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id D6262A0069;
        Thu, 26 Sep 2019 08:22:31 +0000 (UTC)
Received: from US01WEHTC2.internal.synopsys.com (10.12.239.237) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 26 Sep 2019 01:22:27 -0700
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC2.internal.synopsys.com (10.12.239.237) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 26 Sep 2019 01:22:27 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Thu, 26 Sep 2019 01:22:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c3RF6+DVh9rfz2wIfjHet7qATlA9RvzgDg9/5OiSlsN0a+b4URqD0E8teKBPIgmxjeUc9L2D7c8KWhEUPAf/HDGWsfDk78EkzPq/q2vTzryc2h08GnXvM6RYOL8jfiv4xdM4hnRPdCReAH4jx7q025TU+LXwMicBYRXvpo2w6680w8d+DC5Uqq2W+V3zFP9Bqt4vNbl19PMNviaoHxxd1KN5+/1r2ZFtW6BKu5e9HOLrnAPYUaOU67mjeidpKhhGLgQCXvisQKq1VNIfsUdLjEjH1Un7NVwTlUlAUUPVxe1liN0zPqD2rRhCmA3g5lsUreLB3uCcTD+X32C50Ro41A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4q5AI4J4o/DM8WQpb5oI7i0pPFmYoSFXiIdc+p4lGEQ=;
 b=dcy1aYGtdKywDd/cNLduNu+RZ+grnxekU38WU1HZdrtR7UulKdZqZsdk+wTZJaTXsTZljOyL50Wa4XsTFHX292NsDZttm9QwlHD0+Rzdjoy6mxICamF9YId+1PLjcPVEubG3hEnioV7uyWnwO5LkLujlQjuOtg1qifAEgJriSu/S0T2lgOlxHyon5+jTYmVXS+vlou6RCMGp4FvB6TOs9C5YYb/2qsz+KiS1Vyhx3rmXCCFY8MG6yYII/DUTGVbqMBJOssvwUvM6XNLngD0a437VDrncq1lKCah9zIEpsXneSSiyA+xJL9j0tos97dNYqAKK7SIekn6lT9cjfyhpmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4q5AI4J4o/DM8WQpb5oI7i0pPFmYoSFXiIdc+p4lGEQ=;
 b=GZqBdCf8oXirZHIbkl90pw2qmh3tRNm/SLR6cLQYj1V3Gl2gG3zWCLeJCfHev1dQoXX/prhEbFk5B7hQPm6XgrYu/uhuf3noGfYVpWKg+XYJFkBTmmWe7p8gk5ITFCj6iwLlZYSIS9Jo8XB84CMeBjLvbh7Dr8tqS3EKwfm0MCY=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.67.145) by
 BN8PR12MB3252.namprd12.prod.outlook.com (20.179.66.83) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.20; Thu, 26 Sep 2019 08:22:25 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::59fc:d942:487d:15b8]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::59fc:d942:487d:15b8%7]) with mapi id 15.20.2305.017; Thu, 26 Sep 2019
 08:22:25 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Thierry Reding <thierry.reding@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
CC:     Jose Abreu <Jose.Abreu@synopsys.com>,
        David Miller <davem@davemloft.net>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "jonathanh@nvidia.com" <jonathanh@nvidia.com>,
        "bbiswas@nvidia.com" <bbiswas@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: RE: [PATCH v3 0/2] net: stmmac: Enhanced addressing mode for DWMAC
 4.10
Thread-Topic: [PATCH v3 0/2] net: stmmac: Enhanced addressing mode for DWMAC
 4.10
Thread-Index: AQHVb9UIZvUBuIRUTEGi7mSYMt4cT6c7QXkAgAD6QdCAAA7TgIAAAZPAgAAAnpCAAGGlgIAAWAsAgACgRRA=
Date:   Thu, 26 Sep 2019 08:22:25 +0000
Message-ID: <BN8PR12MB32669DDC64861CE11CA66474D3860@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <20190920170036.22610-1-thierry.reding@gmail.com>
 <20190924.214508.1949579574079200671.davem@davemloft.net>
 <BN8PR12MB3266F851B071629898BB775AD3870@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20190925.133353.1445361137776125638.davem@davemloft.net>
 <BN8PR12MB3266A2F1F5F3F18F3A80BFC1D3870@BN8PR12MB3266.namprd12.prod.outlook.com>
 <BN8PR12MB32667F9FDDB2161E9B63C1AFD3870@BN8PR12MB3266.namprd12.prod.outlook.com>
 <9f0e2386-c4b1-52b0-6881-e72093eb1b05@gmail.com>
 <20190925224620.GA8115@mithrandir>
In-Reply-To: <20190925224620.GA8115@mithrandir>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3fe9bc3b-32ff-403b-5b59-08d7425aa9af
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600167)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:BN8PR12MB3252;
x-ms-traffictypediagnostic: BN8PR12MB3252:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR12MB325247066F2A6A5585445302D3860@BN8PR12MB3252.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0172F0EF77
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(396003)(136003)(346002)(39860400002)(366004)(199004)(189003)(25786009)(4326008)(81166006)(66066001)(8936002)(66556008)(81156014)(55016002)(52536014)(71190400001)(86362001)(110136005)(71200400001)(256004)(2906002)(186003)(102836004)(54906003)(6116002)(66446008)(3846002)(64756008)(9686003)(6506007)(66476007)(66946007)(7736002)(33656002)(74316002)(305945005)(316002)(476003)(6246003)(486006)(14454004)(478600001)(76116006)(11346002)(5660300002)(8676002)(76176011)(6436002)(7696005)(229853002)(26005)(99286004)(446003);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3252;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: jmzg0qD6rloJqyUBYcQlQISbvKydBGPpFp1NhQ+q2fRtZvEVgnM7IbLBSdPuat7f3tmx73NPiwxoUJpyXkl0g7vInWYVGMZqNE0TGzIXx1VZrJk0Z2ddWftMYCv4yVL5fMGBxlaIr1AD6RkC7oVsOZW9sVdFNReVRyOGR2Bxxl2xjlXjia+ImQRQYYtBIC5ukM0ChYxZLb/5pFzD06ZBJwjystUd1otaJjTsBT6oe9HAd+DknY8xMuk8r6XdlmCnoh60qghWQ/uVi3TU7lB6HePJbShLRGA0wXOFwW/VR2eF0FEFtLKo+Q2WruYmqaBbfK2aG1WiFcSbxkglUj/m6F0Oy0wi9kJKKcaqaybhyDHcicdOyUoB3puFC8xLWw3uXhg9t/EizY4P3OrJVLNpfgZTii4hdWDa1VHcS2nc/58=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fe9bc3b-32ff-403b-5b59-08d7425aa9af
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2019 08:22:25.7256
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m3CsC+Xe4w62BRTUcvrl+y8HkYqKj2lUBQ2ixMCSiPdwvHASL80fS7phjN/F/iMnfOK4LV9WvoFHiS+Yg2sAAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3252
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thierry Reding <thierry.reding@gmail.com>
Date: Sep/25/2019, 23:46:20 (UTC+00:00)

> On Wed, Sep 25, 2019 at 10:31:13AM -0700, Florian Fainelli wrote:
> > The way I would approach it (as done in bcmgenet.c) is that if the
> > platform both has CONFIG_PHYS_ADDR_T_64BIT=3Dy and supports > 32-bits
> > addresses, then you write the upper 32-bits otherwise, you do not. Give=
n
> > you indicate that the registers are safe to write regardless, then mayb=
e
> > just the check on CONFIG_PHYS_ADDR_T_64BIT is enough for your case. The
> > rationale in my case is that register writes to on-chip descriptors are
> > fairly expensive (~200ns per operation) and get in the hot-path.
> >=20
> > The CONFIG_PHYS_ADDR_T_64BIT check addresses both native 64-bit
> > platforms (e.g.: ARM64) and those that do support LPAE (ARM LPAE for
> > instance).
>=20
> I think we actually want CONFIG_DMA_ADDR_T_64BIT here because we're
> dealing with addresses returned from the DMA API here.
>=20
> I can add an additional condition for the upper 32-bit register writes,
> something like:
>=20
> 	if (IS_ENABLED(CONFIG_DMA_ADDR_T_64BIT) && priv->dma_cfg->eame)
> 		...
>=20
> The compiler should be able to eliminate that as dead code on platforms
> that don't support 64-bit DMA addresses, but the code should still be
> compiler regardless of the setting, thus increasing the compile
> coverage.

I'm fine with this. Some notes:
a) Do not try to enable dma_cfg->eame if CONFIG_DMA_ADDR_T_64BIT is not=20
enabled;
b) You can even add a likely() around priv->dma_cfg->eame check because=20
if a given SoC supports 64 bit addressing then its highly probable that=20
the IP will also support EAME.

---
Thanks,
Jose Miguel Abreu
