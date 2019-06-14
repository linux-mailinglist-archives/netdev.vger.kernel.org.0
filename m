Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA79346162
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 16:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728560AbfFNOq2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 10:46:28 -0400
Received: from dc8-smtprelay2.synopsys.com ([198.182.47.102]:42526 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728300AbfFNOq1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 10:46:27 -0400
Received: from mailhost.synopsys.com (dc8-mailhost1.synopsys.com [10.13.135.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id AE0E8C2389;
        Fri, 14 Jun 2019 14:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1560523587; bh=Np07RrhuY0Vzc3Kr5FRSpQQlgHivQpw1ntSLVF4Th7o=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=EkJYW5e/KlUxsAZLzyQgqLnUE4hH3JUiUmXa+IKHHWfyl4BCCYoVWqU6oOb+NZ4bN
         falrcMNR2/6QhOu7q2zkrRPz4vTNdbwpzpUu9RHI+rp26BX53yK7KDMaYJZncHXnjv
         ONLyCjktsYcAF/d93ULiT//bGLauED61DIn1K7I0hT+7349BemlvM0GJayEZnD4ArH
         j1A3Rq/S3U7g524+g9RDS/uhe2Y/FiJqKZQlFjBhVx0jISQUQj26lJW5IRiatd1wBR
         Nbmp8KOghcAC1QxOTtGVEChSb6R6FKZEAkrEGlsBvLtvtCJwsmSlVujv67hsAHsnHP
         r4jlidIAlcCEQ==
Received: from US01WXQAHTC1.internal.synopsys.com (us01wxqahtc1.internal.synopsys.com [10.12.238.230])
        (using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id BA8D0A006A;
        Fri, 14 Jun 2019 14:46:19 +0000 (UTC)
Received: from DE02WEHTCA.internal.synopsys.com (10.225.19.92) by
 US01WXQAHTC1.internal.synopsys.com (10.12.238.230) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Fri, 14 Jun 2019 07:45:15 -0700
Received: from DE02WEMBXB.internal.synopsys.com ([fe80::95ce:118a:8321:a099])
 by DE02WEHTCA.internal.synopsys.com ([::1]) with mapi id 14.03.0415.000; Fri,
 14 Jun 2019 16:45:13 +0200
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: RE: [PATCH net-next 0/3] net: stmmac: Convert to phylink
Thread-Topic: [PATCH net-next 0/3] net: stmmac: Convert to phylink
Thread-Index: AQHVIGkCReoXsI1ev0mBbW+MAvwZAqabCxsAgAAx03A=
Date:   Fri, 14 Jun 2019 14:45:13 +0000
Message-ID: <78EB27739596EE489E55E81C33FEC33A0B960525@DE02WEMBXB.internal.synopsys.com>
References: <cover.1560266175.git.joabreu@synopsys.com>
 <20190614134028.GB23409@Red>
In-Reply-To: <20190614134028.GB23409@Red>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.107.19.176]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Corentin Labbe <clabbe.montjoie@gmail.com>

> since this patch I hit
> dwmac-sun8i 1c30000.ethernet: ethernet@1c30000 PHY address 29556736 is to=
o large
>=20
> any idea ?

This is because phy_node is no longer pointing to the same place so=20
sun8i_dwmac_set_syscon() fails.

I'm seeing this pattern of using phy_node in other wrappers so I will=20
try to submit a fix for them all.

Thanks for reporting.
