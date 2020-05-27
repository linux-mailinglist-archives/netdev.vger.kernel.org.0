Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD88A1E349A
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 03:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728305AbgE0BSy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 21:18:54 -0400
Received: from mail-eopbgr60050.outbound.protection.outlook.com ([40.107.6.50]:17070
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727937AbgE0BSx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 21:18:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hfxlsc3jX6USfxfAnzzXVN3AoMrcSJjKZKV0rSuw6sI=;
 b=P65Bcm9/+FRMs9516UlTcneX7e2VdQM04wuFukBZP83zETB33erCTffn3/uP1WXnaglHWkL+QhwC3rTt1PnGF3/XCDs05A3PMNPjjR2HEsAOl0zBGmv6aZMMifbe654PoEl25h5gOPvTRBfYDhA53vs2MMNE8gFP7tQ+L9+3kt8=
Received: from AM7PR03CA0015.eurprd03.prod.outlook.com (2603:10a6:20b:130::25)
 by VI1PR0802MB2191.eurprd08.prod.outlook.com (2603:10a6:800:a1::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Wed, 27 May
 2020 01:18:47 +0000
Received: from AM5EUR03FT008.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:20b:130:cafe::85) by AM7PR03CA0015.outlook.office365.com
 (2603:10a6:20b:130::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.25 via Frontend
 Transport; Wed, 27 May 2020 01:18:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=bestguesspass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM5EUR03FT008.mail.protection.outlook.com (10.152.16.123) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3021.23 via Frontend Transport; Wed, 27 May 2020 01:18:47 +0000
Received: ("Tessian outbound b157666c5529:v57"); Wed, 27 May 2020 01:18:46 +0000
X-CR-MTA-TID: 64aa7808
Received: from b8f23aa01c1f.3
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 8779F77F-481B-4AC6-A5AD-892AE1A4A799.1;
        Wed, 27 May 2020 01:18:41 +0000
Received: from EUR03-AM5-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id b8f23aa01c1f.3
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Wed, 27 May 2020 01:18:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nrtw4VeQFHL2X6wTzDHuIOHRHfiXW4uQoyI0+Ui7pMUtBu5DQ0aZ3RH4K/fDKOIuljxhWW5V+OYz6q7ycTKdpbfMuyrqnLtrqlti+zEEjU3bicCzGMbyHGTpbP44YADmCHB8T1PxTlOn+MsQsWvDZWloATkFSk1lAqxIUBjexRSV6SdjYXNOzjySGexC9iqUHYJNu3q2XrCaLEvd/j5vxiDHtZiZmrBiqyCmHRZkq6zNU89V2IEU1Jnz0SWAHsuTxG2iD6oSFvYIR3yPWiiWjMyxptImpbKRZDB2g2OIoac7JfN86Hx8y3rkpH0ax4DdHVjd5oRrm3XjwjBShiRhQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hfxlsc3jX6USfxfAnzzXVN3AoMrcSJjKZKV0rSuw6sI=;
 b=cjZ3HCJcwYTawCnYOEIFz9nPz4B9U/iX9PyB3LVIDQSnulm1a1aTOU1/dG5QqpoLMySgAgwNsT80YEFn4fQPYmkAGP6scYgS7eASFkD2s3Av9qi8DMjL2kTMgxBqUlpHjbzhVljW87siQVi7BCzFPpYKpWSqAYVWJy3n/fJPssKNR/CVMZ8EJfP8sVCFcOzjlbX8GhIy7PkA1aK7eBSNT4n4Z/u9tWkvtnLpLkDjTlPdLFtpvFGyAQaFlujCpwvG3eDdWoCqpGIgVvtMhd3SZecnu96AAD8kYH70xB7nX1GIGaRrRAXAeC40mv91RdTji8meMHyXjoCwnVwxvTasIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hfxlsc3jX6USfxfAnzzXVN3AoMrcSJjKZKV0rSuw6sI=;
 b=P65Bcm9/+FRMs9516UlTcneX7e2VdQM04wuFukBZP83zETB33erCTffn3/uP1WXnaglHWkL+QhwC3rTt1PnGF3/XCDs05A3PMNPjjR2HEsAOl0zBGmv6aZMMifbe654PoEl25h5gOPvTRBfYDhA53vs2MMNE8gFP7tQ+L9+3kt8=
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com (2603:10a6:3:e0::7)
 by HE1PR0802MB2572.eurprd08.prod.outlook.com (2603:10a6:3:db::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23; Wed, 27 May
 2020 01:18:39 +0000
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::b1eb:9515:4851:8be]) by HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::b1eb:9515:4851:8be%6]) with mapi id 15.20.3021.029; Wed, 27 May 2020
 01:18:39 +0000
From:   Jianyong Wu <Jianyong.Wu@arm.com>
To:     Sudeep Holla <Sudeep.Holla@arm.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "yangbo.lu@nxp.com" <yangbo.lu@nxp.com>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "will@kernel.org" <will@kernel.org>,
        Suzuki Poulose <Suzuki.Poulose@arm.com>,
        Steven Price <Steven.Price@arm.com>,
        Justin He <Justin.He@arm.com>, Wei Chen <Wei.Chen@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Steve Capper <Steve.Capper@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kaly Xin <Kaly.Xin@arm.com>, nd <nd@arm.com>,
        Sudeep Holla <Sudeep.Holla@arm.com>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: RE: [RFC PATCH v12 03/11] psci: export smccc conduit get helper.
Thread-Topic: [RFC PATCH v12 03/11] psci: export smccc conduit get helper.
Thread-Index: AQHWMBRUBAdOXBezXUymOTKynRIElai0FQYAgAP0TiCAAiI7gIAA/S6w
Date:   Wed, 27 May 2020 01:18:38 +0000
Message-ID: <HE1PR0802MB255517F7BD5E3E78ACC99F35F4B10@HE1PR0802MB2555.eurprd08.prod.outlook.com>
References: <20200522083724.38182-1-jianyong.wu@arm.com>
 <20200522083724.38182-4-jianyong.wu@arm.com> <20200522131206.GA15171@bogus>
 <HE1PR0802MB255537CD21C5E7F7F4A899A2F4B30@HE1PR0802MB2555.eurprd08.prod.outlook.com>
 <20200526101019.GB11414@bogus>
In-Reply-To: <20200526101019.GB11414@bogus>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: a2136aa6-da3a-4747-aa72-cc10e4192b6a.1
x-checkrecipientchecked: true
Authentication-Results-Original: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
x-originating-ip: [203.126.0.111]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1dbf6bd0-51af-48ff-ad37-08d801dbe7cc
x-ms-traffictypediagnostic: HE1PR0802MB2572:|VI1PR0802MB2191:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0802MB2191DA6F30B4794AD32741CAF4B10@VI1PR0802MB2191.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:3826;OLM:3826;
x-forefront-prvs: 04163EF38A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: DRizxo7Q5GpNNuUh0+p4MhFOUl0nsBEIdtU8FRwxBrGBTxYQCin0tnkJf6nyEpSFr2RX3eK5xMKHqlh9VEDJE/4CdZC/W1Fa4RzpXb27vVt/DDrd1jJIZ55ewkwR3SzWGDBQI9w2v+u+MIvreuimZccUPun/Fgcbx2EqB20W9qGECQBqi8WAgX3RfJbnBKsZqLCBJoaVu9Z4vdhfwCe0FqZwNTU3/tzesXcVkxuMpsTzoJEZ4og8c4SSPhnQ/0YlyrPHp/bG+VGMBlR1B2f8uO1dIYVEahExQVycqHU1Mo4X/O6KqfbMefvtSEk1TYhuBZ79nmCnpziqH5f5Lmx9TA==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0802MB2555.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(39860400002)(396003)(136003)(366004)(71200400001)(55016002)(33656002)(9686003)(316002)(6636002)(5660300002)(54906003)(64756008)(2906002)(7416002)(66446008)(478600001)(52536014)(53546011)(86362001)(66476007)(186003)(8676002)(6862004)(66946007)(8936002)(76116006)(26005)(4326008)(66556008)(6506007)(7696005)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 55/ZCLMvFOTmC6yxUT23hxqJEMqgWKDCQCcUXLiAzUYs6sRbEECEaJeehv9HKUl2aBzMgP5z0/811qo1ZVKcUQCzxOkaQGtZ2NqG9fn/62CQR5EWA2clEq4zTI95WnqC5jdtTMVoYNDujambgUAfTvBb2ahbzBHpoP5RMSqro32jJne17uhVJO8nR3YrBLfotekN+oYo7D0aIgslzazxoiGZxPwRnBB25v7Wpwv04uWjeT+682XsCQrL5/G/b6HpTj7/ZDjoezS37TxKkm8PiX2dkBrsnGHEJLXEM7449W7dGtLQMPbssVqMuiV++d43IlFjRRC/k4VWlnb7qdpAzXjVc7BqxUVhdjZOlcn8cEq9jmVswZ48vRDy6BxdOkYHUw+tgcb+VvGWipu5e8cjrIrWdV4aHmQqO6fEa7NsIahFrKiNruu8e+y5RoHuuTLDSfc81nRpUWqCmYiMYc6tTaQ23lKnhq2v5hjNsAptDYY=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0802MB2572
Original-Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM5EUR03FT008.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(136003)(396003)(39850400004)(46966005)(316002)(36906005)(356005)(9686003)(55016002)(33656002)(5660300002)(54906003)(52536014)(6636002)(82310400002)(450100002)(4326008)(8936002)(8676002)(86362001)(47076004)(6506007)(6862004)(107886003)(53546011)(336012)(82740400003)(186003)(26005)(81166007)(7696005)(478600001)(70206006)(2906002)(83380400001)(70586007);DIR:OUT;SFP:1101;
X-MS-Office365-Filtering-Correlation-Id-Prvs: 94192dc5-2fe9-4701-ba9c-08d801dbe2fe
X-Forefront-PRVS: 04163EF38A
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pvAyKtOfW6y6/iMdZl3583R6nCEZlgZkIXUzM1qaAgkQVENQBIBsO7BP7c8qCuwLkx4FWM47I2IST40wrOObeLibKPV4n6Pj6eWbWWauJXXlsUBy7KzGmFKoJ5SKALPpkQo5LJpZZ4Uh/SHDGDWchpP4paCX2RPIyz2zgENRLclYg3gnH59an8KbO/CwGA2/G1cTn/tq62ore+5YEqdG7j7/nd7TD0Cd03pn9XQtn7R2yZWhyX1kG1ciGfnbxtlv0JNaG7/5Y6N79ud7ZoDSz/NdvfCE1ZFDHn6ABPBpzPCkBP0DTCaiyt3970fUrqbZZkggo5037X3yiCTv8molEsgWoESgLsiveHfZkgntbJpe/LBZUnRM7SC5sREjFApWDE3zE4zxGYNH8FVc9epG8w==
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2020 01:18:47.0311
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1dbf6bd0-51af-48ff-ad37-08d801dbe7cc
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0802MB2191
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sudeep,

> -----Original Message-----
> From: Sudeep Holla <sudeep.holla@arm.com>
> Sent: Tuesday, May 26, 2020 6:10 PM
> To: Jianyong Wu <Jianyong.Wu@arm.com>
> Cc: netdev@vger.kernel.org; yangbo.lu@nxp.com; john.stultz@linaro.org;
> tglx@linutronix.de; pbonzini@redhat.com; sean.j.christopherson@intel.com;
> maz@kernel.org; richardcochran@gmail.com; Mark Rutland
> <Mark.Rutland@arm.com>; will@kernel.org; Suzuki Poulose
> <Suzuki.Poulose@arm.com>; Steven Price <Steven.Price@arm.com>; Justin
> He <Justin.He@arm.com>; Wei Chen <Wei.Chen@arm.com>;
> kvm@vger.kernel.org; Steve Capper <Steve.Capper@arm.com>; linux-
> kernel@vger.kernel.org; Kaly Xin <Kaly.Xin@arm.com>; nd <nd@arm.com>;
> Sudeep Holla <Sudeep.Holla@arm.com>; kvmarm@lists.cs.columbia.edu;
> linux-arm-kernel@lists.infradead.org
> Subject: Re: [RFC PATCH v12 03/11] psci: export smccc conduit get helper.
>=20
> On Mon, May 25, 2020 at 01:37:56AM +0000, Jianyong Wu wrote:
> > Hi Sudeep,
> >
> > > -----Original Message-----
> > > From: Sudeep Holla <sudeep.holla@arm.com>
> > > Sent: Friday, May 22, 2020 9:12 PM
> > > To: Jianyong Wu <Jianyong.Wu@arm.com>
> > > Cc: netdev@vger.kernel.org; yangbo.lu@nxp.com;
> > > john.stultz@linaro.org; tglx@linutronix.de; pbonzini@redhat.com;
> > > sean.j.christopherson@intel.com; maz@kernel.org;
> > > richardcochran@gmail.com; Mark Rutland <Mark.Rutland@arm.com>;
> > > will@kernel.org; Suzuki Poulose <Suzuki.Poulose@arm.com>; Steven
> > > Price <Steven.Price@arm.com>; Justin He <Justin.He@arm.com>; Wei
> > > Chen <Wei.Chen@arm.com>; kvm@vger.kernel.org; Steve Capper
> > > <Steve.Capper@arm.com>; linux- kernel@vger.kernel.org; Kaly Xin
> > > <Kaly.Xin@arm.com>; nd <nd@arm.com>; Sudeep Holla
> > > <Sudeep.Holla@arm.com>; kvmarm@lists.cs.columbia.edu;
> > > linux-arm-kernel@lists.infradead.org
> > > Subject: Re: [RFC PATCH v12 03/11] psci: export smccc conduit get hel=
per.
> > >
> > > On Fri, May 22, 2020 at 04:37:16PM +0800, Jianyong Wu wrote:
> > > > Export arm_smccc_1_1_get_conduit then modules can use smccc
> helper
> > > > which adopts it.
> > > >
> > > > Acked-by: Mark Rutland <mark.rutland@arm.com>
> > > > Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
> > > > ---
> > > >  drivers/firmware/psci/psci.c | 1 +
> > > >  1 file changed, 1 insertion(+)
> > > >
> > > > diff --git a/drivers/firmware/psci/psci.c
> > > > b/drivers/firmware/psci/psci.c index 2937d44b5df4..fd3c88f21b6a
> > > > 100644
> > > > --- a/drivers/firmware/psci/psci.c
> > > > +++ b/drivers/firmware/psci/psci.c
> > > > @@ -64,6 +64,7 @@ enum arm_smccc_conduit
> > > > arm_smccc_1_1_get_conduit(void)
> > > >
> > > >  	return psci_ops.conduit;
> > > >  }
> > > > +EXPORT_SYMBOL(arm_smccc_1_1_get_conduit);
> > > >
> > >
> > > I have moved this into drivers/firmware/smccc/smccc.c [1] Please
> > > update this accordingly.
> >
> > Ok, I will remove this patch next version.
>=20
> You may need it still, just that this patch won't apply as the function i=
s moved
> to a new file.
>=20
Yeah, Thanks for remainder!

Thanks
Jianyong=20

> --
> Regards,
> Sudeep
