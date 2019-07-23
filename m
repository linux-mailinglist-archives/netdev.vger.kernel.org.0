Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C71A71C72
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 18:07:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731531AbfGWQHl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 12:07:41 -0400
Received: from mail-eopbgr50089.outbound.protection.outlook.com ([40.107.5.89]:64053
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727363AbfGWQHl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jul 2019 12:07:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jqflaOwclKjmxraha4HdakRY0a3JXqzXwsH4Q5ZrF9SyuiddoJ+W996AmAy4Z4SH+veDNY2aHjN/OnSZtEeVht0M+aekBwKO5keoFUFLyOQDIrneiPmVMHlqlm98U1zDLk7jvWPEmDPRmJiNbdZf1R+J7kA5+Q3RH45iHoa8Dz4B0fJxJVLuKqjuqOYi9cquy7r/NI8fHqKzjaAIKOlOf82H0VwVU2ufhYxKpOlcaGWipmNtXxLpyw5SRVlSmlf7C1cBBi7tpcbDWZgiVoNORD0GpUx56+84BDHRSYt12gBdKRGL7dOs0RbNk/QOG1GEaGpuGlqcMTNQ2Meohu7RRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RyZmvzHTTkNeiEfRvJbR7iSP3KFfckogv1hhDS7BCmg=;
 b=a50Vv1Y8qBq3zTVEH144W7IsglVt9GB/31b4fc+K5a6HmMiIyrLmVGpni2a15bS9Q2bxfMN7yzuY8I0QdZ1b4ddEyP54ezSkg958myP737cwK7Y0R8hj9QCLoT+VNYfMwSXnYAbz2zN2gQh1mmgnJpl/PZBLj05y1bj2VfD7qStFpFx2WJSKOET1+8oZiDltN/xLbpjL0RMIGSMV9AP4Ze4w0AS4WtKBnLdbSLuttyr6dC95Vqt9j//08WZUfw1frNc+9eERFCu3CT6ue9mqgzziGS7KjCSWtib4GAPIh95vuwjHkck/RZY+bqjEdGxsam4BGlqjjJfTnB5aFr7ssw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RyZmvzHTTkNeiEfRvJbR7iSP3KFfckogv1hhDS7BCmg=;
 b=WjdXI8Q2eDH7rRafs3kIcrm5D4m1dYEaCMISvTi2eHucCOoCTQAzC8gDr014e2fBUa3+t39CTgOTTIZlsIJRtoxaSeRqkRrLXQsf8+6NhAnGnuzks2KORopamabEOl11F7d681my7t2pUc4Gld5k9dDE2mMzIkK0ZlJM1qrR83U=
Received: from VI1PR04MB4880.eurprd04.prod.outlook.com (20.177.49.153) by
 VI1PR04MB6861.eurprd04.prod.outlook.com (52.133.244.213) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Tue, 23 Jul 2019 16:07:35 +0000
Received: from VI1PR04MB4880.eurprd04.prod.outlook.com
 ([fe80::e401:6546:3729:47c0]) by VI1PR04MB4880.eurprd04.prod.outlook.com
 ([fe80::e401:6546:3729:47c0%6]) with mapi id 15.20.2094.013; Tue, 23 Jul 2019
 16:07:35 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     Arseny Solokha <asolokha@kb.kras.ru>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [RFC PATCH 1/2] gianfar: convert to phylink
Thread-Topic: [RFC PATCH 1/2] gianfar: convert to phylink
Thread-Index: AQHVQWm144xMJEx7N0WP2ngZb6HgeabYWstA
Date:   Tue, 23 Jul 2019 16:07:34 +0000
Message-ID: <VI1PR04MB48809AFBB9DF01001AA5E2CA96C70@VI1PR04MB4880.eurprd04.prod.outlook.com>
References: <20190723151702.14430-1-asolokha@kb.kras.ru>
 <20190723151702.14430-2-asolokha@kb.kras.ru>
In-Reply-To: <20190723151702.14430-2-asolokha@kb.kras.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=claudiu.manoil@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 071a1cf6-cdd3-4e03-b681-08d70f87e016
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR04MB6861;
x-ms-traffictypediagnostic: VI1PR04MB6861:
x-microsoft-antispam-prvs: <VI1PR04MB6861DA51ECF165B6B5E3588D96C70@VI1PR04MB6861.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0107098B6C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(346002)(376002)(366004)(39860400002)(13464003)(189003)(199004)(486006)(316002)(14454004)(8676002)(8936002)(102836004)(305945005)(74316002)(3846002)(81156014)(76176011)(44832011)(6506007)(476003)(6116002)(7696005)(110136005)(478600001)(256004)(26005)(446003)(2906002)(186003)(33656002)(5660300002)(4326008)(11346002)(68736007)(53936002)(66066001)(6246003)(52536014)(71190400001)(71200400001)(66476007)(64756008)(66946007)(66446008)(66556008)(76116006)(99286004)(86362001)(6436002)(81166006)(25786009)(9686003)(7736002)(55016002)(229853002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB6861;H:VI1PR04MB4880.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 98FSZSrcOGOgi+PB+skgd9U0eJ93ZbJkFpjeoBAZniUzmJYGG0Mr9/ghP2itJmkQyRWNA9I3x2QUAgVrT0PxBM4DkzZdtn4Px9FB5EVORbb804WzsXEPd51fo3Z1YVtXLzz3Q+j1G/qU7Tvs23u22RJREAdF7Amez11XDZRnBY8tD5R/uiEIFqIaWOBG7AklQsn9aLaTt/yQpkEJPTHDrAW5rXX/p/yRJPeJNac7llRIoRWl2SKgTV1x007Vc5nlAz3R7noyZ31ktMgVC3crCqezUwIXlT5me57F7g6w84zgrI1lvUOMlgcGBQEjUxUzC1w5+SQx9bdtaWzA/Hf0mQXOKDXwPgi9vEb9TC1YOHeE/ZrT6XyBN3MsCaPMn+EHqOQ8BlYryeexCGq878oqF36wU+gIV16KmKBPRhHmhvI=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 071a1cf6-cdd3-4e03-b681-08d70f87e016
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2019 16:07:34.8862
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: claudiu.manoil@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6861
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>-----Original Message-----
>From: Arseny Solokha <asolokha@kb.kras.ru>
>Sent: Tuesday, July 23, 2019 6:17 PM
>To: Claudiu Manoil <claudiu.manoil@nxp.com>; Ioana Ciornei
><ioana.ciornei@nxp.com>; Russell King <linux@armlinux.org.uk>; Andrew Lunn
><andrew@lunn.ch>
>Cc: netdev@vger.kernel.org; Arseny Solokha <asolokha@kb.kras.ru>
>Subject: [RFC PATCH 1/2] gianfar: convert to phylink
>
>Convert gianfar to use the phylink API for better SFP modules support.
>
>The driver still uses phylib for serdes configuration over the TBI
>interface, as there seems to be no functionally equivalent API present
>in phylink (yet). phylib usage is basically confined in two functions.
>

Thanks for your patch.  Phylink in gianfar... that would be something!
At first glance a lot of code has changed with this patch or got relocated.
To make it easier to swallow, I think a few cleanup patches could be
separated before migrating to phylink.  Like for instance getting rid of th=
e
old* link state variables, which I think are an artifact from early phylib =
usage.
Nonetheless good to see this implemented, I'll have a closer look asap.

Thanks
Claudiu
