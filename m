Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73D8BB30E5
	for <lists+netdev@lfdr.de>; Sun, 15 Sep 2019 18:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731341AbfIOQl0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Sep 2019 12:41:26 -0400
Received: from dc2-smtprelay2.synopsys.com ([198.182.61.142]:43372 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730230AbfIOQl0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Sep 2019 12:41:26 -0400
Received: from mailhost.synopsys.com (badc-mailhost1.synopsys.com [10.192.0.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id B0BB9C0173;
        Sun, 15 Sep 2019 16:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1568565685; bh=41mS5WlZx0/Xtf3QPhTgcPBq6VK6OFyQdXlzcbc8a9E=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=E3DJwCHebgkrN9/cjQoeF457noOO08RoEqxXmipyxfXp2EzCrDicZZl0hQdVv+/In
         8U35pi0Z/NgLO3UN+bF7/F0DVj8oYMgGqtK9fNwfxBx6q1SG4/8pO+Hwog4qNkSQY5
         rPTvDugmOZk9x9jpWmWUs4WT6dfG9JyQyF2eIKMPw2EsSwOCmBjhjS/HAjq1RTLSGT
         aEFon/bMM8cPXP1Ss9St5guddJKHf/wDUgULNKQybXKqHMntEJrV8Q3i6yD2NrxLI5
         ON3udVI/kzVoqJCB1wOA+PXGrOh59qsdDld5hooT1wAAfGE12j1ak2U9p9YvruEnmK
         KpKLswwEge04A==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 793D2A005A;
        Sun, 15 Sep 2019 16:41:17 +0000 (UTC)
Received: from US01WEHTC2.internal.synopsys.com (10.12.239.237) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Sun, 15 Sep 2019 09:41:16 -0700
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC2.internal.synopsys.com (10.12.239.237) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Sun, 15 Sep 2019 09:41:16 -0700
Received: from NAM01-BY2-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Sun, 15 Sep 2019 09:41:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ekyvU87DDr8vOK3chIL622/EX1JNWsgKzGA42QAoJJaRASNnH+1prTh9gYyz/uGTMvyFBwSq0xNMXcuCZqJ0ddC8rsxWPnVr9ew6X2iXFhGcMky8GrJXwPK6dsfuYhLJbOANqv6b8AObQtc1w0USVxx9jlKllhC5nEo9vRSubK1ZG9NCmvBjp+w+QWnTGU06j6+AlVWXKreLB+fZcQhyR1qRpexKCptXvFEmO22s9DQMsI9h5Zqw7FmyzDq3ptT2UnHQIRwdReimeYtmU5/gnHk6/cEM7efW6j409LpNcvoBCHikoN8wM+DDriU8rH4jP+qwh2LT3sh0aJUWB9XDGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=41mS5WlZx0/Xtf3QPhTgcPBq6VK6OFyQdXlzcbc8a9E=;
 b=FUE2KovyOjSuTNvwLQMzxAU0YdiKEEWIezhALhmk+T/OKoMaSpCOsl+PpBimRUhg4SArjK98CZUFojLZJlE9L6K3TEsVK5RN4iKbfa9PdJSoXm2BXTGPJKrieCn7BD1hdD4rzQifZAW+5eCskOP3OERWiriSM3epxlO8KUmt3FGV102PZUjYkOdPRPuyqFw8XRS1giEzbQQEigqgPUTtaNXsyLFgjW89QNHktba72JWL9xVW2KUCGlMIGd/9++LmOU3VHbTsoKqnPUp8jDDUiV9zcVDTRiQoaSyIdKIVFw7S/pFTzgsAmsDO8o/5Qc2RPuSvTIsPuk12SvqtkoIE+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=41mS5WlZx0/Xtf3QPhTgcPBq6VK6OFyQdXlzcbc8a9E=;
 b=fGPVdpICjvcSkE9S98PAe4ANnjSG44MvERrtnxpnRfgOcRavybedzUFjlxiS/5hZdAynBfdjF77ojtvuOFAmFp8Ce3mNA/dO4ng1moYvORZfN8TAN/3As8nyXH9BjAqNUCTNictGMQb6VjC+l1kWvDXkOQbpKuUAQaoB4/+q4kY=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.67.145) by
 BN8PR12MB3393.namprd12.prod.outlook.com (20.178.211.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.13; Sun, 15 Sep 2019 16:41:15 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::59fc:d942:487d:15b8]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::59fc:d942:487d:15b8%7]) with mapi id 15.20.2263.023; Sun, 15 Sep 2019
 16:41:15 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Vladimir Oltean <olteanv@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "vedang.patel@intel.com" <vedang.patel@intel.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>
CC:     "weifeng.voon@intel.com" <weifeng.voon@intel.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "m-karicheri2@ti.com" <m-karicheri2@ti.com>,
        "jose.abreu@synopsys.com" <Jose.Abreu@synopsys.com>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "kurt.kanzenbach@linutronix.de" <kurt.kanzenbach@linutronix.de>,
        "joergen.andreasen@microchip.com" <joergen.andreasen@microchip.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v4 net-next 4/6] net: dsa: sja1105: Advertise the 8 TX
 queues
Thread-Topic: [PATCH v4 net-next 4/6] net: dsa: sja1105: Advertise the 8 TX
 queues
Thread-Index: AQHVa2lt36ZRf2b9okq60WVd9S9XI6cs8LZQ
Date:   Sun, 15 Sep 2019 16:41:15 +0000
Message-ID: <BN8PR12MB326684898CC3CBC27ABEA4E7D38D0@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <20190915020003.27926-1-olteanv@gmail.com>
 <20190915020003.27926-5-olteanv@gmail.com>
In-Reply-To: <20190915020003.27926-5-olteanv@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [188.80.50.127]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3b318b68-17f2-44f4-fcf8-08d739fb8688
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BN8PR12MB3393;
x-ms-traffictypediagnostic: BN8PR12MB3393:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR12MB339354F8EE71C9B92B5C48D2D38D0@BN8PR12MB3393.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01613DFDC8
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(346002)(39850400004)(376002)(366004)(396003)(199004)(189003)(6436002)(76176011)(229853002)(4744005)(86362001)(6506007)(256004)(55016002)(7696005)(74316002)(99286004)(7416002)(102836004)(3846002)(66066001)(2201001)(14454004)(6116002)(7736002)(52536014)(316002)(110136005)(2906002)(305945005)(54906003)(5660300002)(8936002)(476003)(478600001)(26005)(71190400001)(486006)(186003)(11346002)(2501003)(66446008)(66556008)(66476007)(8676002)(71200400001)(66946007)(81166006)(81156014)(64756008)(76116006)(25786009)(446003)(9686003)(4326008)(53936002)(33656002)(6246003);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3393;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: EzqF8pOjyASvIa5FBJAzYz3szULzuA2alpGYInw00gDElTAeYJD4NS8SVQIUzQC2iaQcTQZv1qBGnZotjhQqfkoCLB+nZk6im9mpZBzPymF11GOkxcycUnpdv3i+dYEfl5whANPvB1VzIiERrPDBsRYxgU3CsupGwtljkzvrNr7J81uqGmpdpZgMO6OICv69wsps2Ao9f+9p3lm3LnY+7iZSqk3+Lzfm0kIw46+zvhXRUA5jkv4HODZzFKTeddncmwA8JAdOVaqVMAkR3TR+/O16fzCyZgLsAvabj8nHKDG0fmrUyljwcI23EmT4+xuZuwET69gDwMIudwU3SdiYUzNzihhkl+RMQEZSCpkdBzgua6bfWgosxW0q2xxOe3oGx4jeeXcHGeuwAEx+IVE7Js7c6KltOpxgyyemhZ3dP0w=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b318b68-17f2-44f4-fcf8-08d739fb8688
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Sep 2019 16:41:15.1414
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4VyXoBQQDTmo/P70340bgRti/RGaFfbkYUIc9OZTOlru4wmpT2l8j3uLLKGpB13gKrOmUcehjMRwZmBIj0Kp3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3393
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Sep/15/2019, 03:00:01 (UTC+00:00)

> Instead of looking directly at skb->priority during xmit, let's get the
> netdev queue and the queue-to-traffic-class mapping, and put the
> resulting traffic class into the dsa_8021q PCP field. The switch is
> configured with a 1-to-1 PCP-to-ingress-queue-to-egress-queue mapping
> (see vlan_pmap in sja1105_main.c), so the effect is that we can inject
> into a front-panel's egress traffic class through VLAN tagging from
> Linux, completely transparently.

Wouldn't it be better to just rely on skb queue mapping as per userspace=20
settings ? I mean this way you cant create some complex scenarios=20
without having the VLAN ID need.

I generally use u32 filter and skbedit queue_mapping action to achieve=20
this.

---
Thanks,
Jose Miguel Abreu
