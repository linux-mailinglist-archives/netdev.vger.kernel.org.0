Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 852F1202E15
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 03:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731001AbgFVB3T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 21:29:19 -0400
Received: from mail-eopbgr60080.outbound.protection.outlook.com ([40.107.6.80]:44515
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726529AbgFVB3S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Jun 2020 21:29:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7gakpibcmM1A6Z+y+LYAOXvkHa7C3zW96kd1mPW6FAk=;
 b=mkzOtE+CefvWgst6+zITplTyHL9vy60/vyh9i/bnuy8WTb1L24xZKkKkvXWwMs88TOlOVCQxV7FYEIVI+LPETwgznI6CBTl2FQ9DXBbSyw16XZ9mrhwGAOt/8t8xgQNES916zOqRv5TeSnV1WbSwX0mfO0wkCimxHf8UxlBdoXc=
Received: from AM5PR0601CA0068.eurprd06.prod.outlook.com (2603:10a6:206::33)
 by AM6PR08MB5029.eurprd08.prod.outlook.com (2603:10a6:20b:e7::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Mon, 22 Jun
 2020 01:29:12 +0000
Received: from VE1EUR03FT064.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:206:0:cafe::57) by AM5PR0601CA0068.outlook.office365.com
 (2603:10a6:206::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend
 Transport; Mon, 22 Jun 2020 01:29:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=bestguesspass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT064.mail.protection.outlook.com (10.152.19.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3109.22 via Frontend Transport; Mon, 22 Jun 2020 01:29:12 +0000
Received: ("Tessian outbound 022d32fb9a40:v59"); Mon, 22 Jun 2020 01:29:11 +0000
X-CR-MTA-TID: 64aa7808
Received: from e0c85193323d.2
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 59CB9F53-E507-4DCF-B6E8-F3A93FE3B859.1;
        Mon, 22 Jun 2020 01:29:06 +0000
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id e0c85193323d.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Mon, 22 Jun 2020 01:29:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MD8pEoe7PYsU6Uq7Z6dUSUToKc5dx3ZT5Xl9EOR6Y1j39z2nNgq3ghLc85beDXTLZgp7gIYEFkos+Ln54jxLDAK6A8vEMpBiU802iU4mh/YUw/GS8yRv4H2V8YQlxmRxXLanelzywf1dm6S5o49Jf0hyBBMW8qeHR97o71kVPJCl2jeeI+t5mg7FXXqinp0I6JNvWCt7u42T/H4ZtzyKrSxsdVtZAIH+RfM5Piagj6ipD8iNCMvboo6lYmdo32jJvuQsvXmuqVC+mSzjFbGPBPDsFvmh2Fl+ydOmpi6Hhf70KUiOWF6kr0Z9gfRITkju5s1fooqm9Qgk+UFPh3qodw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7gakpibcmM1A6Z+y+LYAOXvkHa7C3zW96kd1mPW6FAk=;
 b=ZQ11lcEokei5wxzZPOyCD4QMI5ksgSGIabXadEamkzEminJakiRHlmez/SEXBvE88sbESaV0WQFaRHZMdf2/WUkUvV31/LxEslSsOtDmOFLpQiILB7KM7m27QlEIlfDKU88CH6bAiCaIZPjRaZY6RFcHB8hYE0mf3qQwFpUngt/ZZbVcXvoOfK7d8nJuMqhueuL98qxNG4WPS2zywRguQWsHeXUrktvNym0Vzmsjafu/jOrjG+fJlcsOb4AaEOIUNqgg9y0/yBTxsmAS+6zHHA8UVZ9fiaa3PtDZENBEjYOwxh4MFztRGwHxJbseHfdERkgF8pq3PY84VP7qMHXypw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7gakpibcmM1A6Z+y+LYAOXvkHa7C3zW96kd1mPW6FAk=;
 b=mkzOtE+CefvWgst6+zITplTyHL9vy60/vyh9i/bnuy8WTb1L24xZKkKkvXWwMs88TOlOVCQxV7FYEIVI+LPETwgznI6CBTl2FQ9DXBbSyw16XZ9mrhwGAOt/8t8xgQNES916zOqRv5TeSnV1WbSwX0mfO0wkCimxHf8UxlBdoXc=
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com (2603:10a6:3:e0::7)
 by HE1PR0802MB2441.eurprd08.prod.outlook.com (2603:10a6:3:de::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Mon, 22 Jun
 2020 01:29:04 +0000
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::9:c111:edc1:d65a]) by HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::9:c111:edc1:d65a%6]) with mapi id 15.20.3109.027; Mon, 22 Jun 2020
 01:29:04 +0000
From:   Jianyong Wu <Jianyong.Wu@arm.com>
To:     Christoph Hellwig <hch@infradead.org>
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
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH v13 3/9] smccc: Export smccc conduit get helper.
Thread-Topic: [PATCH v13 3/9] smccc: Export smccc conduit get helper.
Thread-Index: AQHWRjnWZm9cCgyKw0Oi8fsDZXPjUajf9qAAgAPlsPA=
Date:   Mon, 22 Jun 2020 01:29:04 +0000
Message-ID: <HE1PR0802MB25556C4CA5F4A49AED6795F4F4970@HE1PR0802MB2555.eurprd08.prod.outlook.com>
References: <20200619130120.40556-1-jianyong.wu@arm.com>
 <20200619130120.40556-4-jianyong.wu@arm.com>
 <20200619135716.GA14308@infradead.org>
In-Reply-To: <20200619135716.GA14308@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 63f8f2c2-a11f-469a-9765-782abfe82fbc.1
x-checkrecipientchecked: true
Authentication-Results-Original: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=arm.com;
x-originating-ip: [203.126.0.111]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 13c69b34-d18d-4258-0729-08d8164bab40
x-ms-traffictypediagnostic: HE1PR0802MB2441:|AM6PR08MB5029:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <AM6PR08MB502989C37CCCD05E089BE132F4970@AM6PR08MB5029.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:1388;OLM:1388;
x-forefront-prvs: 0442E569BC
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: zoS5szs5n+3VpC5T2Xy1l7CzOCdMfWSqhwW4pkx0+yl3/CrkzTANj2YZgTz1RrgjiOVklckMPGtRtP1H1QbDpf9uZlDRIVw5Bn4h7vNd92nu3YUWUINWP5pDzLJuOLC7YCp2jWILy23TKsa77BzMLFtMgO/Z+MuxDVBWfCirmTW4CXMclgq+6HYebkl1cbnhoyBZI1sPyUQMIOO3zd+odjSO9ORO+JvJWj7hqixNcHYfEkPFi8Q2ZZgIsDA1PbbIyurSunDh5bsc3NCVEOAYdjMX0l6lGZd/YX8L6EP08gbxgCMBOO2hzFmwvSob5VrE+syITgSjER7C0xwUgEvx7w==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0802MB2555.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(366004)(396003)(136003)(39850400004)(8936002)(64756008)(83380400001)(66556008)(66476007)(71200400001)(66446008)(55016002)(5660300002)(8676002)(7416002)(54906003)(7696005)(9686003)(76116006)(6506007)(6916009)(66946007)(53546011)(52536014)(86362001)(316002)(478600001)(2906002)(4326008)(186003)(26005)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: tdjvzkf1H1Bd/MhKMgfFnpkWZG+ruSgJx4e3JZEnI3mE5MQNXYD/FAnkHAFaH4U1lOL1wxuxlLye7as22DmhOh2Lya+S6GHtjjA0qbkTjewhZ6hwfcZUWgXOrd13Tu43iuRdXBxI+7eBKLB9HieUykzH0uURBW9OMN8zo2KyBmp6bLyfumi+VbpkZS4ouExqB7ics6/b8skfi7rz4pZZ3+BiVYfd9R99FVAKkvz2SNQyruGULVdWCP0FUXs4YnlVa9Bzh8x0g2iVZrFXd+Vdb1PtGdOoF4WsuIWOEdXfZ6rWr3k0ePxERVXPZ3zkg12spcZ2gPxv6qKGjmCs/YXx2cpT0ZcDqUA5rWZ0rRTOyU3D2KCvsg3Vt5oJqTils5ikZh8zh4BVBrckYLsJ8QAPGov1NNmvpkr0DKLxpXEoRULW42joGAJjkHSQP0bCOcacKvQXUATr+KjvNbHMxKOSdi/L9yrI3cYV3G/kY/BUE18=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0802MB2441
Original-Authentication-Results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT064.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(396003)(136003)(39850400004)(46966005)(70206006)(33656002)(86362001)(82310400002)(478600001)(186003)(107886003)(316002)(6506007)(53546011)(36906005)(7696005)(52536014)(26005)(356005)(54906003)(81166007)(82740400003)(8936002)(5660300002)(55016002)(9686003)(450100002)(47076004)(336012)(83380400001)(70586007)(2906002)(8676002)(6862004)(4326008);DIR:OUT;SFP:1101;
X-MS-Office365-Filtering-Correlation-Id-Prvs: 41ca700a-8451-4c16-2c68-08d8164ba6a7
X-Forefront-PRVS: 0442E569BC
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mQbuW8he/cRron+n+SZR7Y/m3VSk2rglBo3Nd+cvjjXIhMPo6pVxMAUmqKjSGw1T2UbP48jXyPO3rFaTrgRuWN94ZQ0c0Eiwtx+4HtCjLlgWlu3cfz8lgG6mlR6UjGnAEVwhfivik36+Jx13BKPbVBWTAd4k+6f9V2yHHuTUjODa5ZDuW2rCE7kkyLjNw/jO/Pjy9QoRv/Fj4uJRfBEA8GyjGMms65i1juCXxSPSmrLuF9gE2EilHwpYxpJgiHKwV350EOUdfcTU10PcKn04LyezyaV7fZFbcZWjmgOr5oratFww3BN4tgCQb5DI6cObXRoY7ZZWvexJ50BnzVX6l52/KxHrTkCL9OlevomHDvpq68smUM2Bt6m/Yko3tPUn/MGdc2xFXCE2ZsE1NWIxBw==
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2020 01:29:12.2094
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 13c69b34-d18d-4258-0729-08d8164bab40
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB5029
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Christoph,

> -----Original Message-----
> From: Christoph Hellwig <hch@infradead.org>
> Sent: Friday, June 19, 2020 9:57 PM
> To: Jianyong Wu <Jianyong.Wu@arm.com>
> Cc: netdev@vger.kernel.org; yangbo.lu@nxp.com; john.stultz@linaro.org;
> tglx@linutronix.de; pbonzini@redhat.com; sean.j.christopherson@intel.com;
> maz@kernel.org; richardcochran@gmail.com; Mark Rutland
> <Mark.Rutland@arm.com>; will@kernel.org; Suzuki Poulose
> <Suzuki.Poulose@arm.com>; Steven Price <Steven.Price@arm.com>; Justin
> He <Justin.He@arm.com>; Wei Chen <Wei.Chen@arm.com>;
> kvm@vger.kernel.org; Steve Capper <Steve.Capper@arm.com>; linux-
> kernel@vger.kernel.org; Kaly Xin <Kaly.Xin@arm.com>; nd <nd@arm.com>;
> kvmarm@lists.cs.columbia.edu; linux-arm-kernel@lists.infradead.org
> Subject: Re: [PATCH v13 3/9] smccc: Export smccc conduit get helper.
>=20
> On Fri, Jun 19, 2020 at 09:01:14PM +0800, Jianyong Wu wrote:
> > Export arm_smccc_1_1_get_conduit then modules can use smccc helper
> > which adopts it.
> >
> > Acked-by: Mark Rutland <mark.rutland@arm.com>
> > Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
> > ---
> >  drivers/firmware/smccc/smccc.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/drivers/firmware/smccc/smccc.c
> > b/drivers/firmware/smccc/smccc.c index 4e80921ee212..b855fe7b5c90
> > 100644
> > --- a/drivers/firmware/smccc/smccc.c
> > +++ b/drivers/firmware/smccc/smccc.c
> > @@ -24,6 +24,7 @@ enum arm_smccc_conduit
> > arm_smccc_1_1_get_conduit(void)
> >
> >  	return smccc_conduit;
> >  }
> > +EXPORT_SYMBOL(arm_smccc_1_1_get_conduit);
>=20
> EXPORT_SYMBOL_GPL, please.

Ok, thanks.

Thanks
Jianyong=20

