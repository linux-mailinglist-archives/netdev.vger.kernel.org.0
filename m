Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE9096092D
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 17:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727673AbfGEPVZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 11:21:25 -0400
Received: from dc8-smtprelay2.synopsys.com ([198.182.47.102]:54038 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726302AbfGEPVZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 11:21:25 -0400
Received: from mailhost.synopsys.com (dc2-mailhost1.synopsys.com [10.12.135.161])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 2D403C2989;
        Fri,  5 Jul 2019 15:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1562340084; bh=6FwTzznIm5VxdWt8YvDaLCoruf9DPPYcOfNGobwK6c0=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=YG9T06k7vNSUPcedznjKtYfUtAUCyrYNksPL5ReQ4z1+XvCyESivNGmpSsAJzTNZx
         q3IkbrcEglrmuSwM2rrqJ6tuEqyQCZY4K7KS1Gun9I8EWqeJKqj1ksFrYeGVKUduBE
         C5ltTRSl/SV7NTRy9E9mXq7UiM12Us0QSJHxUiDbam5EhGwWSDAJ8glV2FqXzI00zf
         YNd2d41Riy5yY1cVJ0hZe8A9cdcRCunBbfqoGGkZjJ0beTZfE9odyPAWpseH6M7M/Z
         SfMp/KaPLRL+2Pj37e9DYDdACLkBn6Lfw4Gmqg6RUtkoR8JFQih2mT7f6QUNzjR5mO
         AsDyuergumwPg==
Received: from us01wehtc1.internal.synopsys.com (us01wehtc1-vip.internal.synopsys.com [10.12.239.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 2254BA09BA;
        Fri,  5 Jul 2019 15:21:19 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 us01wehtc1.internal.synopsys.com (10.12.239.235) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Fri, 5 Jul 2019 08:21:19 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Fri, 5 Jul 2019 08:21:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector1-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6FwTzznIm5VxdWt8YvDaLCoruf9DPPYcOfNGobwK6c0=;
 b=nFUkHaBhCqYNATY5U9E7ahyahFCz1FiO/T+QXUP51uaNbOyJ4B0XcvhteXMKDcULW0TX76yECOl1nsUIl1zzmzgkNQaaXM8t2qDizOp8WG6RrNzdSxp8mUh78dqLS2veS8aZzLRd5EQsMof9eYbgCIo4rRqEBmfTK8ZrSB8VEqI=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.66.159) by
 BN8PR12MB2867.namprd12.prod.outlook.com (20.179.66.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.20; Fri, 5 Jul 2019 15:21:17 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::61ef:5598:59e0:fc9d]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::61ef:5598:59e0:fc9d%5]) with mapi id 15.20.2052.019; Fri, 5 Jul 2019
 15:21:17 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jose Abreu <Jose.Abreu@synopsys.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: RE: [PATCH net-next v3 3/3] net: stmmac: Introducing support for Page
 Pool
Thread-Topic: [PATCH net-next v3 3/3] net: stmmac: Introducing support for
 Page Pool
Thread-Index: AQHVMwKNzVmUsJPJMUCkE31Cd4D9oqa8BTaAgAAezsA=
Date:   Fri, 5 Jul 2019 15:21:16 +0000
Message-ID: <BN8PR12MB32666359FABD7D7E55FE4761D3F50@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <cover.1562311299.git.joabreu@synopsys.com>
 <384dab52828c4b65596ef4202562a574eed93b91.1562311299.git.joabreu@synopsys.com>
 <20190705132905.GA15433@apalos>
In-Reply-To: <20190705132905.GA15433@apalos>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9c9c6aa2-e217-4d18-7ea2-08d7015c6cf2
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BN8PR12MB2867;
x-ms-traffictypediagnostic: BN8PR12MB2867:
x-microsoft-antispam-prvs: <BN8PR12MB286730AAC5030FD80D56DE5BD3F50@BN8PR12MB2867.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-forefront-prvs: 008960E8EC
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(39850400004)(396003)(136003)(366004)(376002)(189003)(51914003)(199004)(81166006)(8676002)(305945005)(7736002)(14444005)(256004)(81156014)(8936002)(6116002)(486006)(476003)(73956011)(446003)(4744005)(14454004)(11346002)(52536014)(66946007)(5660300002)(66476007)(76116006)(66556008)(64756008)(3846002)(66446008)(7696005)(99286004)(102836004)(25786009)(229853002)(7416002)(54906003)(2906002)(6506007)(76176011)(66066001)(316002)(86362001)(186003)(110136005)(33656002)(26005)(478600001)(6636002)(53936002)(4326008)(74316002)(6246003)(6436002)(71200400001)(71190400001)(9686003)(68736007)(55016002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB2867;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: vwRtHQPX4tuAtcOOGnjc+YEjQgIWT6FCHQ2QyQoGGZGFNoSgOspzlROo39Pf679N7nhJFdoX4A+GY3c2U9jR6qD+IMpuTeLa3uSrRr3JZ2I1DetGj6tYckfIORQX4vCDpW7v5B+pvCmyH9LY4ZVXLM1euGxz1Ox6vsmtrF5yrwey1imu7MtILLyzRZSz3U0oGHt5UT1i89jurVPsoQFJliEMoiV9gCXyZjhcdyeId+3GY97/aVPnpMKf44elNiznKmmAfi1+z8Ijyy28lk5n3DRwkeM+yH6VSt8vIKoS/p6t0yepCVtoAmnhV5OYiltYKI5GmK9zSumbH37+g9OcGgzQNCTpPdTKDXp/+d1JAz+5XAnQebJb1M2cg/HRWmQSGIuVjP7MquW2s00fap/3E8J/RWwcXPXjEyHiOSl/fK0=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c9c6aa2-e217-4d18-7ea2-08d7015c6cf2
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2019 15:21:17.1455
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: joabreu@synopsys.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB2867
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ilias Apalodimas <ilias.apalodimas@linaro.org>

> I think this look ok for now. One request though, on page_pool_free=20

Thanks for the review!

> A patch currently under review will slightly change that [1] and [2]
> Can you defer this a bit till that one gets merged?
> The only thing you'll have to do is respin this and replace page_pool_fre=
e()
> with page_pool_destroy()

As we are in end of release cycle net-next may close soon so maybe this=20
can be merged and I can send a follow-up patch later if that's okay by=20
you and David ?
