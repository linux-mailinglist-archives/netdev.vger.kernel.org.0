Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66F0D1268C1
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 19:13:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726866AbfLSSNi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 13:13:38 -0500
Received: from mail-dm6nam11on2053.outbound.protection.outlook.com ([40.107.223.53]:37856
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726818AbfLSSNi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Dec 2019 13:13:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NcK6FyBbUCLnxz8fLfIdcJ62lHvs21xZiEulR3iJl7u2h3ZmL7j7gi/zakTfDp3YD3/OUPHguYzt3Qzu43RCLD6HAoceeN5MEOCPeMcx9DPzytA6aOktbkqhtyKF7d7xU3CkFT/IziaJHs5wj04VnOO1JH5KbrNlNtN5WFIicOu210ZvrK8U72wgnTWUheSy4T/cpgj03mQNDLCyla+Q4j1nH7XiPTHr1fm3LjHCmJ1l01EXPK3AbcJ5ewbUDeELcq1ihZpUTWYSGTwUMZzyEtDiATE8pKDexmbANZyZf7Bj0Z8LbgXKExoYUv3l79FYjRY6mjgUIxOap0lHsHHWJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8nGxNncb09GOOpT5pc0HdcsepO9ArrrNeW+RMeIvXVA=;
 b=KbRiBMNZW4TQ2VftBMPmsg36Sg6cDu8S42OaYmqxefdXTw0KqmGj/D2IZU3NPITzJfmXOwaR+yBRVgYztEiiln0f03XJ73hzPr8LT09bG+rZjcuIP9JoJW4Zjw3Slu2D7auUXTgEdN/tTKAk5y6peUBmh8fGvxzlvQSRWjAHqMcHIqE9NgscPxgd7Q/FFGFqcvStjqnY3LrPu2DesQBS4MiDJnfIkBS06riAIUa8FFvgUviCdtaMPdjOvt90vSWMCO+s2vt8oOaFCPTzGNXdQeRyg5wHmCrk0f+riysxYjXJJXzLLK6MJQYmvPoUgojwvBjz8oH67vJ/G05P0TAuVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=xilinx.com; dmarc=pass action=none header.from=xilinx.com;
 dkim=pass header.d=xilinx.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8nGxNncb09GOOpT5pc0HdcsepO9ArrrNeW+RMeIvXVA=;
 b=Uvfy3B8ltIrUE/ec74EjxR5/iTH+VaIct+O88DukIVJR9mVCWoBNI8IF63UlM6WI7xuhFhoRghHazjCKVlQ2/6RSTOdmCf+Q9HHxLASkpI+r8HUOFzCn7XLYeRQZqtYnojfGHMakO2pOTdoQMTsL15EHQAVISUvpNx6XvkNnsyw=
Received: from CH2PR02MB7000.namprd02.prod.outlook.com (20.180.9.216) by
 CH2PR02MB6134.namprd02.prod.outlook.com (52.132.228.86) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.14; Thu, 19 Dec 2019 18:13:35 +0000
Received: from CH2PR02MB7000.namprd02.prod.outlook.com
 ([fe80::969:436f:b4b8:4899]) by CH2PR02MB7000.namprd02.prod.outlook.com
 ([fe80::969:436f:b4b8:4899%7]) with mapi id 15.20.2559.012; Thu, 19 Dec 2019
 18:13:34 +0000
From:   Radhey Shyam Pandey <radheys@xilinx.com>
To:     Richard Cochran <richardcochran@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        David Miller <davem@davemloft.net>,
        Michal Simek <michals@xilinx.com>
Subject: RE: [PATCH net-next 1/3] net: axienet: Propagate registration errors
 during probe.
Thread-Topic: [PATCH net-next 1/3] net: axienet: Propagate registration errors
 during probe.
Thread-Index: AQHVtD8/PHqqoL6sF0eYA6GsnGF+CKe92YtQgAChMQCAA0uZIA==
Date:   Thu, 19 Dec 2019 18:13:34 +0000
Message-ID: <CH2PR02MB700039E0886AE86B9C731A90C7520@CH2PR02MB7000.namprd02.prod.outlook.com>
References: <cover.1576520432.git.richardcochran@gmail.com>
 <42ed0fb7ef99101d6fd8b799bccb6e2d746939c2.1576520432.git.richardcochran@gmail.com>
 <CH2PR02MB70009FEE62CD2AB6B40911E5C7500@CH2PR02MB7000.namprd02.prod.outlook.com>
 <20191217154950.GA8163@localhost>
In-Reply-To: <20191217154950.GA8163@localhost>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=radheys@xilinx.com; 
x-originating-ip: [183.83.137.135]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 44b93b19-b0dc-4930-18d1-08d784af29a0
x-ms-traffictypediagnostic: CH2PR02MB6134:|CH2PR02MB6134:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH2PR02MB61348151A16AEF9A73D9192AC7520@CH2PR02MB6134.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-forefront-prvs: 0256C18696
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(376002)(366004)(346002)(39850400004)(199004)(13464003)(189003)(9686003)(8936002)(478600001)(81166006)(316002)(66476007)(66556008)(76116006)(64756008)(66946007)(5660300002)(66446008)(33656002)(55016002)(6916009)(54906003)(2906002)(7696005)(52536014)(53546011)(6506007)(26005)(186003)(107886003)(86362001)(81156014)(71200400001)(8676002)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:CH2PR02MB6134;H:CH2PR02MB7000.namprd02.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: xilinx.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: h0GhVN64/jBRBLzu1NBKf0J6/4hwY0lI8UTXUhVNgWXD7ghxLAQvovKgec518J3dfekbcEQFrDs4ba3KbqNTUnHFbZTfFFp5uo8RrIPv56BlsG6FmfqRs6u5QI+vRmJ2z9XiB59n8wGyCRW/dHE0r2kgi0Li4BL0fdt7sOn8lJnZ17ncO7snJ98AZuWbVM/cGfFCeMDACDSOD/dw9LZYa06XGjYJFXf9dSuNFfI2cn5bWmIozdHIXKnHuJ0POUpPn1GJp7pv56fat0ua1gt+1q1DGTUuR+U5xp4kr0nQMKVKoG0hATnRhvMhmvN9Q+rfHrsaiUJnolg1B53B5lva1sRMQjRQi1JHJB++1jTO11/yqPrEIIuzLcJL/2z8aGe23zmCVR9Dl/HyjES5AkhiPcSJYFCgeCcWXdqiz0Cwib5fCZTGHZd9mtJviGRFgISQpAEtY2BkPpCSlCq0O9bsUx3ign7E54KkHsDBtSB07CxNv8AM/Zl4A+UJbAfSUD/c
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44b93b19-b0dc-4930-18d1-08d784af29a0
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Dec 2019 18:13:34.7082
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 77Y9cRpSsx3QojgMhClZz0UPJVh804ZQHwEwHXmmZtO7CnHxvVZ/oFA6b3y8sX15GpWUZ5FJOXdIiuFuuNvpVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR02MB6134
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Richard Cochran <richardcochran@gmail.com>
> Sent: Tuesday, December 17, 2019 9:20 PM
> To: Radhey Shyam Pandey <radheys@xilinx.com>
> Cc: netdev@vger.kernel.org; linux-arm-kernel@lists.infradead.org; David
> Miller <davem@davemloft.net>; Michal Simek <michals@xilinx.com>
> Subject: Re: [PATCH net-next 1/3] net: axienet: Propagate registration er=
rors
> during probe.
>=20
> On Tue, Dec 17, 2019 at 06:19:47AM +0000, Radhey Shyam Pandey wrote:
> > > -----Original Message-----
> > > From: Richard Cochran <richardcochran@gmail.com>
> > > Sent: Tuesday, December 17, 2019 12:03 AM
> > > To: netdev@vger.kernel.org
> > > Cc: linux-arm-kernel@lists.infradead.org; David Miller
> > > <davem@davemloft.net>; Michal Simek <michals@xilinx.com>; Radhey
> > > Shyam Pandey <radheys@xilinx.com>
> > > Subject: [PATCH net-next 1/3] net: axienet: Propagate registration er=
rors
> > > during probe.
> > >
> > > The function, axienet_mdio_setup(), calls of_mdiobus_register() which
> > > might return EDEFER_PROBE.  However, this error is not propagated to
> > EPROBE_DEFER.  In which scenario we are hitting probe_defer?
>=20
> Did you see the cover letter?  I am referring to this series:

I mean in which scenario we are hitting of_mdiobus_register defer?=20
The series you mentioned talks about one-step TS.
>=20
>  16.Dec'19  [PATCH V6 net-next 00/11] Peer to Peer One-Step time stamping
>=20
> Thanks,
> Richard
