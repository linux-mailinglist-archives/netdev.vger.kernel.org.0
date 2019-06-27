Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32C0658266
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 14:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbfF0MVQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 08:21:16 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:39204 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726431AbfF0MVQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 08:21:16 -0400
Received: from mailhost.synopsys.com (dc8-mailhost2.synopsys.com [10.13.135.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id E47BBC0BF3;
        Thu, 27 Jun 2019 12:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1561638075; bh=1VXyV86FgsHJwwFrgL1rUBPUlssZ+p7EZ8+A4dnJKPU=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=ghSxDRVJlK/wQlVh696LFB5YIO3ofztnWDxDn1wlZEoyoQ0hlpdpwCz2ctLAp5tmB
         9osY5nSJ600TjeYzzqSpCRy7RxDbxXNjcHAnBl4+cqpTa2p0L5ivTMdv6qLUutQw3f
         dAaSzdueCSWxcdvPMlL7jawDDUPAUImS/i0eHzx08J6I5wmT0myo/I7zryG5aQ0AUV
         L5WkCQnJocXDpxj/OvS0mswmFoOQEZiQY99X0ZixF3uO3ogMZSbT6FvcvcvIgR78IV
         ZoOswM4YyRtTxMiGvdhsQsRmlI6quQ+oBnr4V+s4Y5Kd1iaCbt8Bi5Gns8e2bEHSB5
         DpSqEfuE6E9hg==
Received: from us01wehtc1.internal.synopsys.com (us01wehtc1-vip.internal.synopsys.com [10.12.239.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 32447A0065;
        Thu, 27 Jun 2019 12:21:14 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 us01wehtc1.internal.synopsys.com (10.12.239.231) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 27 Jun 2019 05:21:13 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Thu, 27 Jun 2019 05:21:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector1-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZRXagN1vk0EdEW/aB7NmDpXGCkwVxYEqHwmBLJ36cnk=;
 b=RTBRY+TUolhGMAZOt2cAGOYzWPXBxlvim42OoF8Rgkyu42ebVpG5CAfZjT/z+zQTETeHhEl5RKOwjAmOn+Cs/G218wUt/1r+Y3ji7TRV+nbxbCf2u/Iy3GRTxuri9lpRKI2kPhOPlZ1flfy0SsdsiI3zfExxWoLpqYpyLIOlbVg=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.66.159) by
 BN8PR12MB3172.namprd12.prod.outlook.com (20.179.64.83) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Thu, 27 Jun 2019 12:21:12 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c922:4285:22a6:6e]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c922:4285:22a6:6e%5]) with mapi id 15.20.2008.018; Thu, 27 Jun 2019
 12:21:11 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Voon Weifeng <weifeng.voon@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Giuseppe Cavallaro" <peppe.cavallaro@st.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "Florian Fainelli" <f.fainelli@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>
Subject: RE: [RFC net-next 1/5] net: stmmac: introduce IEEE 802.1Qbv
 configuration functionalities
Thread-Topic: [RFC net-next 1/5] net: stmmac: introduce IEEE 802.1Qbv
 configuration functionalities
Thread-Index: AQHVJdrSnKdXMM/880K7fuGYVs8ARaavd29g
Date:   Thu, 27 Jun 2019 12:21:11 +0000
Message-ID: <BN8PR12MB32668CB3930DD0D9565D15B0D3FD0@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <1560893778-6838-1-git-send-email-weifeng.voon@intel.com>
 <1560893778-6838-2-git-send-email-weifeng.voon@intel.com>
In-Reply-To: <1560893778-6838-2-git-send-email-weifeng.voon@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6280d005-c47f-4b8e-eb61-08d6faf9f12d
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BN8PR12MB3172;
x-ms-traffictypediagnostic: BN8PR12MB3172:
x-microsoft-antispam-prvs: <BN8PR12MB31727F7B4B89A9E749392AB6D3FD0@BN8PR12MB3172.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 008184426E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(136003)(39860400002)(366004)(376002)(346002)(189003)(199004)(11346002)(7416002)(9686003)(4744005)(55016002)(68736007)(99286004)(66066001)(53936002)(486006)(76176011)(86362001)(446003)(229853002)(476003)(6506007)(52536014)(5660300002)(7696005)(102836004)(66476007)(66556008)(66946007)(73956011)(66446008)(64756008)(6436002)(26005)(76116006)(186003)(2906002)(256004)(8676002)(110136005)(316002)(8936002)(81156014)(81166006)(54906003)(25786009)(74316002)(305945005)(7736002)(71200400001)(71190400001)(478600001)(3846002)(6116002)(14454004)(4326008)(33656002)(6246003);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3172;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: uXS0xMVDQl0PF8jBxyI4R3aDxIa2Cqp6wwo2kBPz5GtCFckhoQWoVeDzlOuHcF5MxQawV5uKkKCHB3PcMO1T8IbyhxmoWM+hdC8bpekWQGgNYNwCgoFQskZowHd+70/UnHd0xlaZcOXs0tUEidCn7gsDGyCw85Ae7t9vNCH9IvV6+LfDo3j/dA1qwOilo/3qjqgXcjjJJ0tLhhgQ/P1ku21IZKDCo8MhfJf0xRRdosf7kpeSCXUGLUZVHerxA68eJxriJkFvouvfn+CjLIppbdO7eGyzY1aBfhCl530/FGsDZaP+e73Uv+2IKWcwYWjAx16NEGcqpQj9cxrLR+Yjzb5ZiLFyIiB8hSebQTYbuCLteiwzWIxxWkpao9xMjVV84n3lGI/pv7uiUbUDqvjKsuInL5sKbfV/9Pwrk3dB7J4=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 6280d005-c47f-4b8e-eb61-08d6faf9f12d
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2019 12:21:11.8083
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: joabreu@synopsys.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3172
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Voon Weifeng <weifeng.voon@intel.com>

> diff --git a/drivers/net/ethernet/stmicro/stmmac/dw_tsn_lib.c b/drivers/n=
et/ethernet/stmicro/stmmac/dw_tsn_lib.c
> new file mode 100644
> index 000000000000..cba27c604cb1
> --- /dev/null
> +++ b/drivers/net/ethernet/stmicro/stmmac/dw_tsn_lib.c

XGMAC also supports TSN features so I think more abstraction is needed=20
on this because the XGMAC implementation is very similar (only reg=20
offsets and bitfields changes).

I would rather:
	- Implement HW specific handling in dwmac4_core.c / dwmac4_dma.c and=20
add the callbacks in hwif table;
	- Let TSN logic in this file but call it stmmac_tsn.c.

> @@ -3621,6 +3622,8 @@ static int stmmac_set_features(struct net_device *n=
etdev,
>  	 */
>  	stmmac_rx_ipc(priv, priv->hw);
> =20
> +	netdev->features =3D features;

Isn't this a fix ?
