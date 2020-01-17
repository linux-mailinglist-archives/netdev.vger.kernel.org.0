Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7691140576
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 09:29:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729486AbgAQI3d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 03:29:33 -0500
Received: from sv2-smtprelay2.synopsys.com ([149.117.73.133]:42548 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727002AbgAQI3d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 03:29:33 -0500
Received: from mailhost.synopsys.com (badc-mailhost1.synopsys.com [10.192.0.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 8868E402D3;
        Fri, 17 Jan 2020 08:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1579249772; bh=N3f0RsVpq/nqvT6qidI3JDEC72FMQFjN3qvv6uaci7s=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=D+tgP0k0XDksQld5a9o9u58bF8lYWwUJWrZ9r7XuKC5QmCCGt43SDUKZf44tqcNMu
         ubXWZB/F2nLpaNDKr4/q3NNHNDgigaFaUkELK+bJKM6dFM8uX1Eu4D27cDIFkBgHcb
         8R5T7rbsloHE1rcmu8duUFMGDZdqguuEPc5TyQruzFmQqAJDUwzWUdXSunMXAUyYlF
         LCsZVfTpHvjsRDDlRH4MT4a97TtMBYhxzchZ7KoOI++8ySBTbMOjFmmmMD3IyNvDD5
         fpiXglWJqe5mBFQWljpfgfBpBpXK7iUZADbTovNcZqA4WJwBbCd8Z86FYssCiGe7Oi
         2BxD5mlH4LZ1g==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id AC43FA0091;
        Fri, 17 Jan 2020 08:29:31 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Fri, 17 Jan 2020 00:29:27 -0800
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (10.202.3.67) by
 mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Fri, 17 Jan 2020 00:29:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mpN+IKgX7LYqxB4qgz1+rlkMVcjAwgw/3IT3tDLHAMtGsk3eMCQDmDOaAOOp28wSBSIz0R93Tj9vdst9B7LN1Z6ZRj2fcYfd3TssHvekRyfLa3vd0yePmmTNQJ6p4gfBpjNOQQC3Yxacq6vaemsWZdCO7xRlBRZCHpiITTuyAKYm1Olld7QplY49M0eBRSdNlvrqSkCqCFjXaOoWsL0gG9TqXBHGQxQNaZppSo8WRtICDe16f+y4B8ob7EVN8J/T0Oy2mT297a69hq7slnIvkQYBtfZDnZCb9ejgriZBJsWn5uph2orxrsenUuWyV9BoJ1h8TYMEMYfDqneCWSTkHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N3f0RsVpq/nqvT6qidI3JDEC72FMQFjN3qvv6uaci7s=;
 b=JwVK8pZ8PBukqHJ9feL+onB9Ti8gnrTm+izGG9bvZ6wN4jW/nmxFBBp3325oMRzswrMH1oEGPHaQwb7uzFZhcOxQ33KE1FbfvlEjOxwZQL7yoDcQ9R866HcwJjXCv/gR8G6VO9FKEURmnGnJLrqneN7wBwlpvvjxZEsv3dlbBqMlrTa9lfEK/Vg5pYqhWoChho4EtQEIGXPMjA5ayX2Ji7UNh4EpZQU08J4iEygkGM/InknuIcxubZt95DbLKwY2SS0KrZB9kDxF1yeRR+Q/anb3rMNRARiFOBNk/2eGlsjcg/zKzEdV/yXmoSY7pAUEcOlwrcitASVbYRLjxP112g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N3f0RsVpq/nqvT6qidI3JDEC72FMQFjN3qvv6uaci7s=;
 b=Z07i4WLTsr+gz8n2GzsqcxQ2j3ciajXPpVuGO1mA5xCZnPr5PJDvzyQZxc/OZLMvYRd776cG4ibtqlAo+AwnZzV5HXxUYF6OloE8/Y7PsOJLXQLKzNxds0rURNtsAvDurXTV+oJ7hoOiV6p+w58D2u4ZAM02K/wRYcow6MK3pt4=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.67.145) by
 BN8PR12MB3122.namprd12.prod.outlook.com (20.178.211.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Fri, 17 Jan 2020 08:29:25 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c62:b247:6963:9da2]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c62:b247:6963:9da2%6]) with mapi id 15.20.2644.021; Fri, 17 Jan 2020
 08:29:25 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Ajay Gupta <ajaykuee@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "treding@nvidia.com" <treding@nvidia.com>,
        Ajay Gupta <ajayg@nvidia.com>
Subject: RE: [PATCH] net: stmmac: platform: use generic device api
Thread-Topic: [PATCH] net: stmmac: platform: use generic device api
Thread-Index: AQHVzJnFdMlFXnti00yvqxn0Pb8HWKfuht6Q
Date:   Fri, 17 Jan 2020 08:29:25 +0000
Message-ID: <BN8PR12MB3266A6A6A155AA7F3469CF94D3310@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <20200116005645.14026-1-ajayg@nvidia.com>
In-Reply-To: <20200116005645.14026-1-ajayg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d252bb79-7067-40a2-50a5-08d79b275c91
x-ms-traffictypediagnostic: BN8PR12MB3122:
x-microsoft-antispam-prvs: <BN8PR12MB312225E133DF05B5DEE7A020D3310@BN8PR12MB3122.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-forefront-prvs: 0285201563
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(396003)(136003)(39860400002)(366004)(346002)(199004)(189003)(6506007)(558084003)(26005)(55016002)(2906002)(5660300002)(71200400001)(33656002)(7696005)(64756008)(9686003)(66946007)(66476007)(66556008)(110136005)(54906003)(76116006)(66446008)(81166006)(81156014)(186003)(316002)(8936002)(86362001)(478600001)(52536014)(8676002)(4326008)(41533002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3122;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: elWUHcWhm6pzjpB7dimnvzzVWsErRWvf2YS6MDsCavgvFwOZXvd2vwcDagWpOhtB24Eg7YexxeJuiodxmXTNaZQkEarCvRt1DQg5Izs0KX+BHC2TcGhLujNiUMJUeh/9c83gd9XLXIH9XlV11XMrk/p8mbM3Muimk4vpJUEUH63AyAthZvenSt99MOsoNa0T9DDfQSL4JIY6iCmRscOar57sh+tEnKal+HcTu8InPGhpLAa1MRvjW93kKE644pzmoZNQFiNdhG6TXeEQHpVbRaDUiffX7V+02njfRN0eLIputYsg2BSCGSVNv4cAdUibEndCBebrZPUkZ58Wl7d+BJEdLWk5gi5aQJ8EAAQ1Cb0DQUUh2EkikWHCMGbsncyg7O8ycNKIyAyjBxm8kiJjLDdmp6zq3sSalbjsoWcI1okFv8Rp58rJQ0/C7q7SpDb86H6NkcDu4CcINsV8+zWRwK7IOuy7yi7YBEk53hYh7/HOw7mrxDb4Npo1u/SXt9pA
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d252bb79-7067-40a2-50a5-08d79b275c91
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2020 08:29:25.3412
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7J/oNd2WzpmUouSFYrx2rg+iHlde1RR9FolR7/OtGU9aWmE2Cv+iVbEb7wGJ8Lb99FpOXjBaLSUjp6y16soj1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3122
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please cc' your patches according to "scripts/get_maintainer.pl" output.

---
Thanks,
Jose Miguel Abreu
