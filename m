Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD622F08ED
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 19:00:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbhAJR6H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 12:58:07 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:60280 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726395AbhAJR6G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jan 2021 12:58:06 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10AHt8fl027031;
        Sun, 10 Jan 2021 09:57:18 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=EE0SPY3YklNZPIwhqE0FZuFMygjCkrX5C8ECZRHvhXs=;
 b=jDa8bcmdgF/ejazNCBVkKGIdAaCkM9po7T1yfXQSS2oChEwOAC9r4mwv9Ahvx2Ut0Rhb
 WOc/fs/DNqJVD5PelzBhN6Zt+sflGLMKYmpkFYCkPAYbjAjWUdyibSa6EPai0N7AFwOA
 8az5qCExE125QfheZ5MCwEPwd9qIW26vlvSxq5a/JhS6xgMRNpjd8apWJzJ5rRROZ2ED
 dmupg8VRFvy5CdEiB7TxfdFSg1kliJIYkQLBDErLgnnAIwho11jbULn2OGSYakQRWgcv
 DPdl4Ar9XpoSJJDtceqVmfmL2uGbADkfXhX12pDVH7kjSr4k5c9AKxrq0d+06T3fTypy 0Q== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 35yaqsjayy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 10 Jan 2021 09:57:17 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 10 Jan
 2021 09:57:16 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 10 Jan
 2021 09:57:16 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.104)
 by DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sun, 10 Jan 2021 09:57:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cs81B4P4c73dpWRTfXOIzQUcReOOKLiupqJFNsGkse8RRBYQhoOWh3QBFNje0YEMqd4CmIIUUo8VuyHE9R2I62co0VMMUZXeW2gAcSTVT2juSyDXPJe/XzhPvpzTkwYOZKIywNUqqmaUMbo43giydI2qZh0cbPpaNk9GI3183p1bOSHmP363vk5WQJEY+0/hNQ23AGovDG8Dgxrl6hNjTl/zsYKpCA20mVXUgOz0i3aDLQydyREgBXC6+//oRk6jdFNLCTQgxXeVU3F2bQU1GaRX7Mh6Wml1ifAFhq2YVtZan1GfN2eVwKwVpiNHL28NdEtOlMlObp6zr0m7lbuoWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EE0SPY3YklNZPIwhqE0FZuFMygjCkrX5C8ECZRHvhXs=;
 b=khppe/47G0YJXf7q5MQK97IO6HUvQ3g6X1vFiH0XMlIXv54HgI5GbAsSRMOmVnvxNtPHwYxmVI8KCpm9yGv35Z0jot5MzOvUGU3UEWGKIKt+Xs3TaT/zc91uA7ctV9d9Fhv8z0Iyd8pXBqStLcjhZkYdynDs37Da6xaYfTCDeF7RJ2jDmhNxYc7I2VM4FMXzXvC2rBh5xggnwDfhXfCbuGGy6+v3Ix83RQzKUiH93ygioViue2TKSeYzNusrlpeCWavyIURTECoYYEouhA5faPA6gOGUxjPsxyAH2GjtZ+7G/nXqtuowoUOgAMEM4GVNvREPfSLoq/NIyNVy7P4e0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EE0SPY3YklNZPIwhqE0FZuFMygjCkrX5C8ECZRHvhXs=;
 b=IxUDogkikKcuQsqLghgl2NHfuIW1Tcw1418zokINCJ0XJrWjKkWzE3zI+bqQxyNhHz+CwXKQ9VJZgLgK45/PMHBtcl9kW+155fXXV4lnJh3SCewluYKbG9aAxTS/sfB4BCEeZlH8mJqLH3Y+BJyMEV/dXSq38Ea4BT1hkt0ZWm4=
Received: from CO6PR18MB3873.namprd18.prod.outlook.com (20.182.164.23) by
 MWHPR1801MB2015.namprd18.prod.outlook.com (10.164.192.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3742.6; Sun, 10 Jan 2021 17:57:15 +0000
Received: from CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::ed55:e9b3:f86c:3e5b]) by CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::ed55:e9b3:f86c:3e5b%7]) with mapi id 15.20.3742.012; Sun, 10 Jan 2021
 17:57:15 +0000
From:   Stefan Chulski <stefanc@marvell.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "atenart@kernel.org" <atenart@kernel.org>
Subject: RE: [EXT] Re: [PATCH RFC net-next  03/19] net: mvpp2: add CM3 SRAM
 memory map
Thread-Topic: [EXT] Re: [PATCH RFC net-next  03/19] net: mvpp2: add CM3 SRAM
 memory map
Thread-Index: AQHW52WtPfi4P1NcGU6aLxAkyBGTaqohJKIAgAAATSA=
Date:   Sun, 10 Jan 2021 17:57:14 +0000
Message-ID: <CO6PR18MB38737188EA6812EE82F99379B0AC9@CO6PR18MB3873.namprd18.prod.outlook.com>
References: <1610292623-15564-1-git-send-email-stefanc@marvell.com>
 <1610292623-15564-4-git-send-email-stefanc@marvell.com>
 <20210110175500.GG1551@shell.armlinux.org.uk>
In-Reply-To: <20210110175500.GG1551@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none
 header.from=marvell.com;
x-originating-ip: [80.230.29.26]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f93fc3be-fbf2-44bd-0800-08d8b5912a27
x-ms-traffictypediagnostic: MWHPR1801MB2015:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR1801MB2015E82893FE34F28C49F947B0AC9@MWHPR1801MB2015.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gOMDmfATHG5ahQg484ZASAoUGFJBsVYmMZh85ULCBdQl5LNVYgANR49H1s+hdGScCBlLFdjoymDZyxN+9HJ3JL0gYOiNtScR8Vd8SAUNDc4mgm/xgDiKmsofe3aVQimf2/8iaWFgM/ktI/sU2cbPC5IAwtoF1WoJEZOa1q62LbXvKqk8OXL2N7SbFvYgrOjlmMYvUmk8AC6Z8NrYcfHKuCFRXtBgTd1Y7tcEoNGTJbe15RRKfMj9on/ev5CNCT1xK5vH4+2gqkIO1dzmTcmtQhbCeLM9ygEnBZLstk1dgmGoECo5advsJfEMA3Mq5qrbBoonoAvKXKKHm8f+8Cr6WuX3zUyX4yZSnpjFQLC3r8C5JoxC1FBXYWKjiZbzh0RoFFiXFkeRWY/0HIY4w9p2zg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB3873.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(39860400002)(366004)(376002)(396003)(478600001)(4744005)(52536014)(7696005)(54906003)(33656002)(186003)(4326008)(316002)(26005)(71200400001)(6506007)(66556008)(76116006)(83380400001)(64756008)(8936002)(8676002)(5660300002)(66476007)(66446008)(2906002)(66946007)(9686003)(6916009)(55016002)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?MqeiqnvryY8HxqBnhdEFvbzd26pHbGvMdiK/H2JRepaGtFq4jKhqeERSiFQJ?=
 =?us-ascii?Q?evH2ocNAolDnQp3f2nM7R4k0A1oIfdygVuTguVhkap6U0KwONBJREFUcrrJd?=
 =?us-ascii?Q?HlGY3K9HJUopdreSuDUlvdJJuxZhCdCXfVxlZLga2SD3+I9BnyuyXdDkSq5v?=
 =?us-ascii?Q?1UAX7WmBJS8RBhoddu32rMyF24yW2rQdOlsKIw4cnkRpXtybpk/x8e6uG0zb?=
 =?us-ascii?Q?4Ettm6xWPSE3+Oy91ArHBZWCks68y114n10/QI3UI4TDcXzXd5r0JcDIC1eQ?=
 =?us-ascii?Q?heJGxWuquYC2FKG9F9bFBkk8I0QZ3Xvc3AXnZjpwkbVqc/lGee/xvaczUzzR?=
 =?us-ascii?Q?HfJStAAxX7ThhqlYddjJm9DCJPpl/aBqAQOaqeli8Q6DiBqD680o/zfXVz/j?=
 =?us-ascii?Q?GKe3rUY81bVy7tEpVlUKpRzwNXY2qaAyNTv5SayuZxoGjZRGcecQ00JUMqk6?=
 =?us-ascii?Q?Do9H6NDIRXWPiRnwTMJWMIUoopd5bwZQjM013JmVrIp0isc20LQco15K6YE0?=
 =?us-ascii?Q?WvObUyk7FstvpzJyvOnqLhmmiRy9UbSaGyEVQZUs9CHQIUlvX9Mc2YSvQuyw?=
 =?us-ascii?Q?0t4wSzPYq39LGtsLBf+UmazOknld93gUhhSN57IYdwdQzQ/8OJjb3esau38c?=
 =?us-ascii?Q?gJf4W4m/yusVYzIyOfB2qU3jNuYjO/72Zo1s/1MqHT+g+IPbWFdTP3Z8yQOw?=
 =?us-ascii?Q?OzeH2ieUpu2QZ2ayYCnMgt++N46JaPMkk+PVju4guyokSeDmEMKRY6C5PWDm?=
 =?us-ascii?Q?19is9cEcnFaUUWpM44buQbfm3UE4da3it/olNafaUyWlMmc51NhCyo/KAjk5?=
 =?us-ascii?Q?KUNNsBNnzEeIAnSCOX2S7rmgrQjXuvw2Cd6CcUVE3WUT1TSJHSgdYC5cet4F?=
 =?us-ascii?Q?daEKZz9+P8euIWE2NuNn58K0pRDJRT2oLXcnBnwOGvyuusOUjpNM9nbsl+Sn?=
 =?us-ascii?Q?1oDn8ieb5/8eiJ25yybP7ymUfSfgmzWGI9aJ8CoNPJI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB3873.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f93fc3be-fbf2-44bd-0800-08d8b5912a27
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2021 17:57:15.0003
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: D+w2qoG88AMGhUFz5RwqesQ/I8Ek4m5jap629Mp+pS3igukBVcuOZuRdNRnYoV+CrJN4xhNNfn63aLrf0XsVmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1801MB2015
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-09_13:2021-01-07,2021-01-09 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +	} else {
> > +		priv->sram_pool =3D of_gen_pool_get(dn, "cm3-mem", 0);
> > +		if (!priv->sram_pool) {
> > +			dev_warn(&pdev->dev, "DT is too old, TX FC
> disabled\n");
>=20
> I don't see anything in this patch that disables TX flow control, which m=
eans
> this warning message is misleading.

OK, I would change to TX FC not supported.

Stefan.
