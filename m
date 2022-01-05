Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E10F64858E6
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 20:09:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243351AbiAETJh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 14:09:37 -0500
Received: from mail-eopbgr80050.outbound.protection.outlook.com ([40.107.8.50]:20809
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243347AbiAETJ3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jan 2022 14:09:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=isRNZ9Vr4zXNExDoX9B3H5ZIhRV69fxAT95XSpRlJMvFuuPklDRAEU9JMabChmxNFOZLewJu1b5AxcvfMrwYLOFf9VHI4NbUbmpmClP81yzjvuCGBTN2Qd00acUz0eqWwygdRTmRufN6HaVQNa23nA5iMGEePWbPsF5+M/mSGAEOCA6pR6XLz2vkFlTH0HTykTsul1wJHuEE7lUJx6bX2jOIM9zVOktzy7o7Rbn9miDCuzR2RF6rfmS7PiEGb5nSqoNHJRqJ8ducK20z7BS2Ea+QtzusdR2HLGVgdE3oByu7NNshxYnKkkK8NoJkIDX/bpKJZX6DK60P1FlhbG+nAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9sQgvnPutsEFnGdrarIGDwqWhidGofmSkdn7o0YOElU=;
 b=ThBaku1F1jwkjtvziQW53q1YwpZ+tyCvcKYK6GvSW3RuF8qFeVMwHzUxV2hPfEOH67xP2Q+yiNfGPpBj6237562tGnKT5pRhQiU2dVHbZ+E0UBjnZpm819xTeHxFDNfws1U22ZuQ4Pvv+ztz0UZ2qQYMTydtUmo+yfGfl9AVtIZ5LoRwmzz30YBuo4LShV0Gv1636k66RqAKRWFB5JJzJKb0kvdeg8ayH/y0IBWNt5rIJCdw+dO3nutEQIlgITFlh2JUr7ztqTr8XzRrnWTMzmqhCw6EiOZA3gsmCt5rVXmyeFx5uwEqB4vC2oa2FzyjpGObUA8ZFozzcDcPCb/YCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 194.138.21.71) smtp.rcpttodomain=canonical.com smtp.mailfrom=siemens.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=siemens.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9sQgvnPutsEFnGdrarIGDwqWhidGofmSkdn7o0YOElU=;
 b=wtc0bAtFR3nWJlv1LnNdbd9PPePs2x0whUif4AK6De3NOZM/QdZvPHWhQOx0ifIz+9lbU99AO96KTsNcOjo6RsBhoNqdx6YUNebOYrBIkImAsiiCGevbADHXlgiFjSAqjpGiECmNPpdd4nPR/kNYdUzaQYuzHvYNN++ArBJQ//EEGHhV82QQmrXubejBVNuGRQdLN4nLpUNTDj2JLAmRGprbqIfB5YpZ6aF1PFI/dNStKLiu6jAHSd7eu64FqMgRQGeON0FiSNlDzKG/pOyyEPNU3lmWFLZLtqKsRY/wUGk10nRCxuSHe/Z+UVHTNGTE+w5ZujFUjT0fN79HeP/lDg==
Received: from AM6P194CA0067.EURP194.PROD.OUTLOOK.COM (2603:10a6:209:84::44)
 by DB8PR10MB2585.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:a9::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.15; Wed, 5 Jan
 2022 19:09:25 +0000
Received: from VE1EUR01FT016.eop-EUR01.prod.protection.outlook.com
 (2603:10a6:209:84:cafe::e2) by AM6P194CA0067.outlook.office365.com
 (2603:10a6:209:84::44) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7 via Frontend
 Transport; Wed, 5 Jan 2022 19:09:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 194.138.21.71)
 smtp.mailfrom=siemens.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=siemens.com;
Received-SPF: Pass (protection.outlook.com: domain of siemens.com designates
 194.138.21.71 as permitted sender) receiver=protection.outlook.com;
 client-ip=194.138.21.71; helo=hybrid.siemens.com;
Received: from hybrid.siemens.com (194.138.21.71) by
 VE1EUR01FT016.mail.protection.outlook.com (10.152.2.227) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4867.7 via Frontend Transport; Wed, 5 Jan 2022 19:09:25 +0000
Received: from DEMCHDC8A0A.ad011.siemens.net (139.25.226.106) by
 DEMCHDC9SKA.ad011.siemens.net (194.138.21.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 5 Jan 2022 20:09:25 +0100
Received: from md1za8fc.ad001.siemens.net (158.92.8.107) by
 DEMCHDC8A0A.ad011.siemens.net (139.25.226.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 5 Jan 2022 20:09:24 +0100
Date:   Wed, 5 Jan 2022 20:09:20 +0100
From:   Henning Schild <henning.schild@siemens.com>
To:     Aaron Ma <aaron.ma@canonical.com>
CC:     Oliver Neukum <oneukum@suse.com>, <kuba@kernel.org>,
        <linux-usb@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <davem@davemloft.net>,
        <hayeswang@realtek.com>, <tiwai@suse.de>
Subject: Re: [PATCH] Revert "net: usb: r8152: Add MAC passthrough support
 for more Lenovo Docks"
Message-ID: <20220105200920.7362a662@md1za8fc.ad001.siemens.net>
In-Reply-To: <fa192218-4fc8-678f-8b40-95b85e36097e@canonical.com>
References: <20220105155102.8557-1-aaron.ma@canonical.com>
 <394d86b6-bb22-9b44-fa1e-8fdc6366d55e@suse.com>
 <fa192218-4fc8-678f-8b40-95b85e36097e@canonical.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [158.92.8.107]
X-ClientProxiedBy: DEMCHDC8A1A.ad011.siemens.net (139.25.226.107) To
 DEMCHDC8A0A.ad011.siemens.net (139.25.226.106)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7ccbf267-1a29-47a8-39bc-08d9d07ee3c3
X-MS-TrafficTypeDiagnostic: DB8PR10MB2585:EE_
X-Microsoft-Antispam-PRVS: <DB8PR10MB2585BE97005770BC9C7C10D7854B9@DB8PR10MB2585.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:1079;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z7gkBfYMRQ2K4wNNZIr3ieAcJNsKlh9aH7bniRmWa1cOawEaAMebZdKm/oMsmt50UKzIxl14+UtKteFaS+Jr032yoogYN0SYre3GALlKrnJxMGpbENYwafehAezmlKu6QpHgJ/RLeVxWODzzZFcmxThKtsHtKdoEhTjzZ7mgiC/xz0PyaCX/MEP/P9XYwLJ69yym9MaQjT5o52NQGXpV49HdC84dnKCbmxTDYdqZZk1yFePhi7erAfYDwHFxvkF9t6HcKAmrkm9qILviebCNMiDuyQQOHB056UaHV8oyl49KUQiyW/VgWAK76qh9tLLdpOOemwp7DLzBCu4KaMPSN0IwYlu1abW8nftM/rYihoPqJEFVa43O3GYuJf8dg7meusFZA/SvUlpNmjbAlr0d3SCI5Qee+ww3OT58fKqKiuH4VQUGx+tN7zh6mretRo3D5ebXqvrNUHVu0AN5Tt1446PmZ887/rj2I27pRJsWMfBbiYaf7UjGou/1MhhZzQJi/5ugnTnDFFjaPoi7cM4IPpOoAUQOkCT1uVFX3se6JHJ383wmEvJPpc6UeK8P6RbEaXRai9mxZtQMDyFycoC15ejTBFBN1mASl6r1ueyVQNWR19r4yQY8S9lDDwPu3SUObOnD6Ixb3OBpIATzTgnQyqwx2clAfDUKdhvEuFFkZ8dQ+pg4Ghlvk3q3ocWEVDo2XzHduGO+gFJI6xoOUwZ0Z8YonkR8J/6Ud/VsRcqV6gL6EchpEOzQa9Me/palaIPX4+mf9wn6gXeFni0Ffu83SuUCtRhtqlLAdYzrROI6YgQ=
X-Forefront-Antispam-Report: CIP:194.138.21.71;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:hybrid.siemens.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(46966006)(40470700002)(36840700001)(47076005)(356005)(26005)(44832011)(7696005)(82310400004)(6916009)(70586007)(4326008)(16526019)(54906003)(86362001)(81166007)(82960400001)(186003)(9686003)(5660300002)(336012)(956004)(40460700001)(508600001)(53546011)(36860700001)(8936002)(6666004)(70206006)(1076003)(316002)(55016003)(2906002)(8676002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2022 19:09:25.4846
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ccbf267-1a29-47a8-39bc-08d9d07ee3c3
X-MS-Exchange-CrossTenant-Id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=38ae3bcd-9579-4fd4-adda-b42e1495d55a;Ip=[194.138.21.71];Helo=[hybrid.siemens.com]
X-MS-Exchange-CrossTenant-AuthSource: VE1EUR01FT016.eop-EUR01.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR10MB2585
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Thu, 6 Jan 2022 00:05:28 +0800
schrieb Aaron Ma <aaron.ma@canonical.com>:

> On 1/6/22 00:01, Oliver Neukum wrote:
> >=20
> > On 05.01.22 16:51, Aaron Ma wrote: =20
> >> This reverts commit f77b83b5bbab53d2be339184838b19ed2c62c0a5.
> >>
> >> This change breaks multiple usb to ethernet dongles attached on
> >> Lenovo USB hub. =20
> >=20
> > Hi,
> >=20
> > now we should maybe discuss a sensible way to identify device
> > that should use passthrough. Are your reasons to not have a list
> > of devices maintainability or is it impossible?
> >  =20
>=20
> The USB to ethernet ID is 0bda:8153. It's is original Realtek 8153 ID.
> It's impossible.
>=20
> And ocp data are 0.
> No way to identify it's from dock.

Is that revert you giving up on the other one? Maybe these IDs offer a
way after all.

One of my offending devices is a idVendor=3D13b1, idProduct=3D0041 from
Linksys so probably clearly not Lenovo, was just plugged into a Lenovo
hub.

The other one is a idVendor=3D17ef, idProduct=3D7214 so actually a Lenovo
travel hub. And probably rightfully getting a pass-thru ... if we want
to keep that feature in the kernel and not push it out to udev (for all
vendors)

Anyhow, it seems like the revert is coming. And i will disable that
feature in the BIOS to be sure. But i will be happy to test further
patches.
=20
regards,
Henning


> Aaron
>=20
> >  =C2=A0=C2=A0=C2=A0 Regards
> >  =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 Oliver
> >  =20

