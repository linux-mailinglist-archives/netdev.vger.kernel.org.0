Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C40E71E0474
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 03:38:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388422AbgEYBiP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 May 2020 21:38:15 -0400
Received: from mail-eopbgr00053.outbound.protection.outlook.com ([40.107.0.53]:33024
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728324AbgEYBiO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 May 2020 21:38:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xKpqPWiXwX1s9oHxaslGI9pPpxzD4WzD+JjXBLEXAPk=;
 b=mPlvlPpsypkcTTy3bE5rLRARa6PKR2zVzdFADqh58TmohK8o9DcaXE1kyN5ZvVFWfieg39PiyRIyCSxMO21gf+bav+Kx+MXWqUa1ja7UUP31rXAxqhZ5X7ZtokpAsH1sfkYO5s58Jhqg+J4bKeu49/z/iJd4ZVowfFYs8dj58YA=
Received: from DB6PR0802CA0045.eurprd08.prod.outlook.com (2603:10a6:4:a3::31)
 by VI1PR08MB5374.eurprd08.prod.outlook.com (2603:10a6:803:12f::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.26; Mon, 25 May
 2020 01:38:07 +0000
Received: from DB5EUR03FT064.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:4:a3:cafe::29) by DB6PR0802CA0045.outlook.office365.com
 (2603:10a6:4:a3::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23 via Frontend
 Transport; Mon, 25 May 2020 01:38:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=bestguesspass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT064.mail.protection.outlook.com (10.152.21.199) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3021.23 via Frontend Transport; Mon, 25 May 2020 01:38:06 +0000
Received: ("Tessian outbound 14e212f6ce41:v57"); Mon, 25 May 2020 01:38:06 +0000
X-CR-MTA-TID: 64aa7808
Received: from c2b5a79ceaa6.3
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 693EC451-4575-4919-98F1-8F17DF37F683.1;
        Mon, 25 May 2020 01:38:01 +0000
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id c2b5a79ceaa6.3
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Mon, 25 May 2020 01:38:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h6jCtbtPIBNyIY40zKtu/lhZsWJPyOGCDI2BTGWq75zPYGVrsU+sVv62vf2lnJW/PgT5yjTN/8fERaLFo8G9noE5D5rmPKCoWCe3EaRmS03RQ2A/rMsAKf2BRkVLieuEAa6TrYFxGkdHlhQlcNKS+XH4wrHuuEow3B40Wl2QsFLZkpgwj7ZdXwJHOKcWrlxfupENOg+30X4qaioBKyiYiesf4moouRQkeaNolZvI0p+7sETVuILxbi0aOT5KdxpnIWhB34HJvLBG3Z0mn7tvdpCEf5IZJFUHnZJxu+fYbVxXMFQrXNpC2yBs5wTC2Fz76Oo9Zc2jo9UsQmTx6Vybww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xKpqPWiXwX1s9oHxaslGI9pPpxzD4WzD+JjXBLEXAPk=;
 b=hmih+ze/ueyMQMevSSm2Sd41Ujcu4RjeiWJt0hEmZRZcvLihyN61eXROvx+PSCY1gZZdIcby6FYDKmhICCf48PNSryvHk67zDuYskxm5jtmEJS+xRPXtesZIY2jCHqlTES7jmke7leYyC9RYCoFaEnyd9pb755hhll/6nXaml5Wi/vE6QUJ0xHDcvHpCcc+3U1ZzmB9O4dwdESmQijdFmOxuUzdMtSONjryYfMllN57vsln1gpQEvVnI1anHNoCkTHOTzKvoRwOKKObbDep/q7up+fHQDjCpY52MdQpSHkdS3xydDtm+177aUfAxQs7Ppl7Ic04SWtywhZxqfJW7ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xKpqPWiXwX1s9oHxaslGI9pPpxzD4WzD+JjXBLEXAPk=;
 b=mPlvlPpsypkcTTy3bE5rLRARa6PKR2zVzdFADqh58TmohK8o9DcaXE1kyN5ZvVFWfieg39PiyRIyCSxMO21gf+bav+Kx+MXWqUa1ja7UUP31rXAxqhZ5X7ZtokpAsH1sfkYO5s58Jhqg+J4bKeu49/z/iJd4ZVowfFYs8dj58YA=
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com (2603:10a6:3:e0::7)
 by HE1PR0802MB2571.eurprd08.prod.outlook.com (2603:10a6:3:e2::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23; Mon, 25 May
 2020 01:37:56 +0000
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::b1eb:9515:4851:8be]) by HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::b1eb:9515:4851:8be%6]) with mapi id 15.20.3021.029; Mon, 25 May 2020
 01:37:56 +0000
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
Thread-Index: AQHWMBRUBAdOXBezXUymOTKynRIElai0FQYAgAP0TiA=
Date:   Mon, 25 May 2020 01:37:56 +0000
Message-ID: <HE1PR0802MB255537CD21C5E7F7F4A899A2F4B30@HE1PR0802MB2555.eurprd08.prod.outlook.com>
References: <20200522083724.38182-1-jianyong.wu@arm.com>
 <20200522083724.38182-4-jianyong.wu@arm.com> <20200522131206.GA15171@bogus>
In-Reply-To: <20200522131206.GA15171@bogus>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: aa67b612-5610-41a8-b27b-75dee5aeebf7.1
x-checkrecipientchecked: true
Authentication-Results-Original: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
x-originating-ip: [203.126.0.111]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e09abb7b-5dd2-4e6b-92d1-08d8004c4649
x-ms-traffictypediagnostic: HE1PR0802MB2571:|VI1PR08MB5374:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <VI1PR08MB53748069697CAB9430528A72F4B30@VI1PR08MB5374.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:8882;OLM:8882;
x-forefront-prvs: 0414DF926F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: He+6Q0V00nxFHrY1xEK0fd8S4PAkqovfrtOloOzV0luMwAELHPf4X6nPfCL9SVzUvdWgvdb3vNTOJzHLHDYwSnKaJKTiwCVVdSZXmo5Dvkrq4sWWXuEyFRxchgXXJLAIojvYiq4EgqSOL8wm+IBhmhyJCj/6adMhpou3Ku2qoLMsoYVRZYD3zav/TiLqwvvn3E5ts/0f8tIjuGPIRVAIFbeAVX0G3OFwDbHRXiBBK48+mGhZV6Mbx6cGH1rZv+k8rcH3k+4sR1IqhPEzeRtnEOrueuuwy/UAObe4RZ0J92RMqA2zxNCZ7V89+poUATqhYs7GWwdO6kzKo8zO+vIrbH1+WCVOunexMFwIx9SFwXOHghxtL1K7LPjvGkHk4uxKAdovr28V3XJ4n3wLuSc7rg==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0802MB2555.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39850400004)(376002)(396003)(366004)(346002)(66946007)(7696005)(186003)(4326008)(6862004)(316002)(26005)(71200400001)(966005)(478600001)(6506007)(66556008)(76116006)(64756008)(66476007)(53546011)(66446008)(2906002)(6636002)(8676002)(52536014)(5660300002)(33656002)(8936002)(86362001)(7416002)(55016002)(9686003)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: IX4exGaJJO0u81zqwTPgVsxsRWpw8zIg7OH2kYV02gHPbNmdRp3/+eqer3cVv0ux1Eyha29s+giRxo2AFA0b2ZkslOygM0Exu+8Mf5om+aREiwzzOm8cUvo9TUeoHbQpQ66TKV5wIG51/bABpbI6TT1cOiwts28uKhc2yRICVUJRhru7K7kYBMYuhsMnFtVFkB+m7zWcFI9rKZdgdY+kHiFN6J9U00OQkhXCjEyRZoCalO5EqD5eOtYNvwchRDBUT1zjMOh0Sids2Dbbun6oqA2lGM/HxZp2umqKimwxJhS2ITT+jcFzoHQs2ng7B84RXI+FMwPjFhVaat0LFVcLlSCdeUCkGjto1cXsYmWXTdD63/z1nqdizl7psZ95qoJhG+yCb57QEzn7dGFqiIK/PS9IWduFADyMuboLdgGvmvaM1VdtPtjcS2qH17LRnSuIbLGK7K/EMQ5rwl76LcQhJwY6KjGXrVYPXGvjtHWzrpw=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0802MB2571
Original-Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT064.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFTY:;SFS:(4636009)(376002)(39850400004)(396003)(346002)(136003)(46966005)(33656002)(86362001)(8676002)(9686003)(54906003)(478600001)(336012)(186003)(8936002)(82310400002)(356005)(52536014)(6636002)(55016002)(107886003)(26005)(81166007)(6862004)(47076004)(4326008)(7696005)(2906002)(82740400003)(5660300002)(70586007)(450100002)(53546011)(316002)(6506007)(966005)(70206006);DIR:OUT;SFP:1101;
X-MS-Office365-Filtering-Correlation-Id-Prvs: d651fffb-09ca-4a5c-058f-08d8004c4036
X-Forefront-PRVS: 0414DF926F
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WTyctWUDk2F9PCS6MYNfoxw5WTalp9lLgHP6ZSs6fAx3O98Ol/KxymDaCN/G7+4tjtjKgQiY29s+9/aLqXuqn5hLqnqLz+yIavbOI0XaeXju/Y+qKcgdJjK6uuH+93VNEKA3lmu+MUteSMqm22vIhXm9nRYmyp1qU6CF4+n1+4dVuWjTsrbl3HjQ3Qjwvx976+FQO5oRhMWXvbZrQEfK05gs2ZG1VufUAz6qOqlugd1AAxHribAu/e9oc30MKVOjbOu0Q23+yRJHIONcgGDBQFX5HM87l0zyXHM0G2JHZhOHhzCI5NxawwxSv5TZbFFSLIQbBpqnK6k0Gg/V8Jtuug6+ZNfO1bj/ERY/ATPNO0crTPPfTOpkTsBip0HhLZJp1zsG13AxW1qrGxexTOmdl9JxoOzK792RfIwaAxHbBuf8J3aILIOrC6yVnDHfBh/zJFI3M2gWmgQkQvi93yQkwvwR4piiwL9IqlnB5CPfEb8=
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2020 01:38:06.9246
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e09abb7b-5dd2-4e6b-92d1-08d8004c4649
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB5374
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sudeep,

> -----Original Message-----
> From: Sudeep Holla <sudeep.holla@arm.com>
> Sent: Friday, May 22, 2020 9:12 PM
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
> On Fri, May 22, 2020 at 04:37:16PM +0800, Jianyong Wu wrote:
> > Export arm_smccc_1_1_get_conduit then modules can use smccc helper
> > which adopts it.
> >
> > Acked-by: Mark Rutland <mark.rutland@arm.com>
> > Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
> > ---
> >  drivers/firmware/psci/psci.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/drivers/firmware/psci/psci.c
> > b/drivers/firmware/psci/psci.c index 2937d44b5df4..fd3c88f21b6a 100644
> > --- a/drivers/firmware/psci/psci.c
> > +++ b/drivers/firmware/psci/psci.c
> > @@ -64,6 +64,7 @@ enum arm_smccc_conduit
> > arm_smccc_1_1_get_conduit(void)
> >
> >  	return psci_ops.conduit;
> >  }
> > +EXPORT_SYMBOL(arm_smccc_1_1_get_conduit);
> >
>=20
> I have moved this into drivers/firmware/smccc/smccc.c [1] Please update
> this accordingly.

Ok, I will remove this patch next version.
>=20
> Also this series is floating on the list for a while now, it is time to d=
rop "RFC"
> unless anyone has strong objection to the idea here.
Yeah.
>=20
Thanks
Jianyong=20
> --
> Regards,
> Sudeep
>=20
> [1] https://git.kernel.org/arm64/c/f2ae97062a48
