Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93B8CC4920
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 10:04:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727482AbfJBIEO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 04:04:14 -0400
Received: from us03-smtprelay2.synopsys.com ([149.117.87.133]:38744 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726162AbfJBIEN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 04:04:13 -0400
X-Greylist: delayed 644 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Oct 2019 04:04:13 EDT
Received: from mailhost.synopsys.com (badc-mailhost1.synopsys.com [10.192.0.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id E49C2C0505;
        Wed,  2 Oct 2019 07:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1570002809; bh=ZwchJV/hwBcbtxRPC9nW0ViWeKZEfdyL4rfZRkOLwvU=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=cm5wq/VNeiLKa3+zvzp3I4ZaZLkm0GgmNBZpzf2iffrvxfh/Yvr+RTP6VgjNz9bBk
         BJNmIqMaJCLux7ezZCLVQqWX8c8/5J8e4dd6kRhWF3YCgjidgawaLnnfqdThsnR3qi
         4gOY2SnAOO/+bG5LxFE4o1VFVZjsFSDjp+b5zaEZ/XK0XR9dW4+qZj1G75cYFOwte8
         /4ArvXpvrgQJqziQra6YrpVKuawwrBtMPEcMrUCRZ5bLGOFgWswGEFMYkpmXaipB1z
         yGWYUb5VSanslGe6TWq6NpwgwQD9OolxSC7iea8/KF2kPFIj88Kyv0AplgTN8hKSlB
         pr6bX7GuB2UsA==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 64018A0079;
        Wed,  2 Oct 2019 07:53:13 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 2 Oct 2019 00:52:15 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Wed, 2 Oct 2019 00:52:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=He7nF96q2ceA3bU6DVkhVPdSeN0/auZnRNAMR7TQMd13NX3ePbE2+nPqcQJMuQ668r3FjpObSxHeM9B1H4P5utE5DGjGY+YKeRo2gOhA+2+hZNzZW1GIMEkSAOLMImROIngFp02Fs3K0xCZkv1+MEWCxDTtIJNl/Sw6Q5xFTrs5coySmgNkigkdmdo/mWsa1yQ5kvBLuZSWxu4mwdYfH0N5g5IMdiCpL0UY2FHbx3BmMY3SptZRfEPHAvFNkPkKi65jzlLEmUXVB9Kg1dG4obNXFpKGhH7CWY/6qL+Lvp3S1mRDcpOWmSbPewCsiG6PjOB0p91soVL4s6hHp0eALkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZwchJV/hwBcbtxRPC9nW0ViWeKZEfdyL4rfZRkOLwvU=;
 b=fa1JqiEwCO2br70t+DJAejtIOq0qt2+PRs7k8GRiE/bHSH0djLvqKptPg9UqXBW7ci7dW5jV6LobJJYYxKRfo/jtIO9sLmgzAVmA2//prdCKZgpACzObcwFLLSixLQmX6TawaDrCyX+Ia3dh9gXvGbamLUcfisKGycUSQvHNJwO6uFi/4sWQRGvH1b5Z37LBPs5xuewhO6VW5uLPC1+nhhvM4nedT2z2bv+E1c25ePh3WohVe+dxcc/OTkLRUBo9zMpl6CEGOCJQPvI668CaxYPUeqcC3dwKKRNu7YHmXbhTBSClIo4JF5U1UwCgVbgAZsFVQqJrQpEoY+vYEWEgqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZwchJV/hwBcbtxRPC9nW0ViWeKZEfdyL4rfZRkOLwvU=;
 b=Aj2N/BXsvkmw9amUQsehbBdvJvX7ns/hDqseLBwbnKV3iXMcUqgR73Jc5/w2k4N3c4CtuugDC0hZwcFHlbkTbaIQwURYcDaFoCfYXKZK3q1ZPHmt6UCanmkiuZA27pjgo65jDX+qCg8b1KyNz58ui1NCMyUUcsObQa26Xa5lfPY=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.67.145) by
 BN8PR12MB3363.namprd12.prod.outlook.com (20.178.212.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.17; Wed, 2 Oct 2019 07:52:13 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::59fc:d942:487d:15b8]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::59fc:d942:487d:15b8%7]) with mapi id 15.20.2305.023; Wed, 2 Oct 2019
 07:52:13 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Hans Andersson <haan@cellavision.se>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>
CC:     "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hans Andersson <hans.andersson@cellavision.se>
Subject: RE: [PATCH] net: stmmac: Read user ID muliple times if needed.
Thread-Topic: [PATCH] net: stmmac: Read user ID muliple times if needed.
Thread-Index: AQHVePAsjhS3U+43VE+DGhKYpgL3F6dG8LMA
Date:   Wed, 2 Oct 2019 07:52:13 +0000
Message-ID: <BN8PR12MB3266ED591171A79825090BE0D39C0@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <20191002070721.9916-1-haan@cellavision.se>
In-Reply-To: <20191002070721.9916-1-haan@cellavision.se>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 53c8e645-0ba6-4d3b-3f69-08d7470d703c
x-ms-traffictypediagnostic: BN8PR12MB3363:
x-microsoft-antispam-prvs: <BN8PR12MB3363F6A0E9D29D5551EE3E20D39C0@BN8PR12MB3363.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0178184651
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(366004)(346002)(376002)(396003)(39860400002)(199004)(189003)(25786009)(66946007)(256004)(7696005)(86362001)(71200400001)(71190400001)(99286004)(2501003)(7736002)(305945005)(76176011)(478600001)(6246003)(4326008)(33656002)(186003)(26005)(102836004)(476003)(14454004)(446003)(486006)(6506007)(11346002)(558084003)(8676002)(3846002)(6116002)(81156014)(81166006)(8936002)(229853002)(2906002)(52536014)(9686003)(55016002)(54906003)(5660300002)(316002)(6436002)(66066001)(66446008)(66556008)(7416002)(110136005)(64756008)(74316002)(66476007)(76116006);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3363;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0oGFrpG1H59KoEraUJBtFJt0hGb0eThNrJzBcD1F04XMHg+GSyNgFZM/j4w/7BXjzJYFNL17U6Z9R300x4MFg9dVWiU9No8BgP7WTiLA8KIGxnuYG0B+WaokUeD60g/RkY7cIqNf3++2eSXIBkDvj7mkEcpJs7hUJxnloYvXNX6+0S4U62IO4l7pbilBdvlC6zMme2CQBEX+sbPiRkXV5lZGscnsvlg8hUFkn7WfEOIHPgRaAitWoCQ12Oju5Vkz3hRGB0futoc22Micfh7qITFxIqUHRX7bVuMObHYQhR9uid+RVqfDKIBb46WV97XJe8hTp2PLhVijMoYpuKRRo4kIfgY6yVLGGiX/1LUkglKJNKJnCuH6LT2AYcTzEuyuZCxJXIA8iTos06oxLMLjfBPOE0X7Lwjg0VwnJY5Cfps=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 53c8e645-0ba6-4d3b-3f69-08d7470d703c
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Oct 2019 07:52:13.8558
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Zuwc/pVJylVfdRupVgidR9eaK49YIX4lEN6QPZSueniE7w4eOSN8PkfWgjWQH3SJu4eef/OSeX3eSIF+l4uKXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3363
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hans Andersson <haan@cellavision.se>
Date: Oct/02/2019, 08:07:21 (UTC+00:00)

> When we read user ID / Synopsys ID we might still be in reset,
> so read muliple times if needed.

We shouldn't even try to read it if IP is in reset ...=20

---
Thanks,
Jose Miguel Abreu
