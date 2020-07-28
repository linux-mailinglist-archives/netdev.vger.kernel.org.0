Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD6C22FEB7
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 03:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726315AbgG1BH3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 21:07:29 -0400
Received: from mail-vi1eur05on2063.outbound.protection.outlook.com ([40.107.21.63]:13537
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726139AbgG1BH2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 21:07:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3yGnY3tCA5//GCNAc72cP1ww2KSqx/h6KdDSK9PfS40=;
 b=jwwk/IqUi7ZCRtaRkN/xrY8BklUiLwiaUCYwtB2ygRVgLW01rDTVd7qa3qXCUiissAHViq6ARF/2upSHemJ+uMDOIVqb985xqQqGoN1rI9JhQGOPRfMlDAOez/Si6ziLtevHxxR357zVP8nsY1GxAve2I0Tx5G0CPNT/ax8OYc8=
Received: from AM6P191CA0090.EURP191.PROD.OUTLOOK.COM (2603:10a6:209:8a::31)
 by DBBPR08MB4537.eurprd08.prod.outlook.com (2603:10a6:10:c5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.20; Tue, 28 Jul
 2020 01:07:23 +0000
Received: from AM5EUR03FT038.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:209:8a:cafe::25) by AM6P191CA0090.outlook.office365.com
 (2603:10a6:209:8a::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.21 via Frontend
 Transport; Tue, 28 Jul 2020 01:07:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=bestguesspass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM5EUR03FT038.mail.protection.outlook.com (10.152.17.118) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3216.10 via Frontend Transport; Tue, 28 Jul 2020 01:07:23 +0000
Received: ("Tessian outbound 1c27ecaec3d6:v62"); Tue, 28 Jul 2020 01:07:23 +0000
X-CR-MTA-TID: 64aa7808
Received: from c4811bf5fe9f.2
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 31822CCE-3BBB-4FFE-B661-695E1AE4A30A.1;
        Tue, 28 Jul 2020 01:07:18 +0000
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id c4811bf5fe9f.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Tue, 28 Jul 2020 01:07:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l9ljKl1hsqJ/xMHHkLe0mZHc/2grsuTAhnVny87jN5r/086Imuc8wYqQX1wZKW4wWOKYD39OilPAkUZumfW/HqAiy1qDPnnwAwLKGurlTUZixPDNYIdtD5Wmi7IMVRWgiIcXvdMSjh57anFOkhhNB7SDyNfkFy+BP2x5jL980nSE3AukJV4zrUeeXWw5f33LMOqPycEUWzNxKk3096QXNdkcAL5wacwo8UgDrxexupGykuUmgvh3q4TWx6vzkkvO0USlQOrZSgAd5rggVSOgT0KYLeoMyMStzMpnhljCg9Qzb2Cn1eoouvLziZtSAZO6aV1nRe0n/IBPnH3JS+jQOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3yGnY3tCA5//GCNAc72cP1ww2KSqx/h6KdDSK9PfS40=;
 b=oAd09pOSpUl4ebyEuhlSRyCVoPib+jfPrr2vP8NjN98EnU156/TC1ZtBij8WvqltdQGFNdhhWvIChKLvdF0e2/wKSmHfTTYqCgt7/Vvh53Y0n09y58v9kuXeIeLDuDwazfDtuTfbWNjV6lG0nkioEL2jCeNJgC1FQ7yaT88QbcRV7pMlcrhTC1inrQ9o0aSnhrE9FhSSb0thhXEkxkn3bn+E+ChKf7NhRm6PNHPHdjW9RyjB7SztvXF1WKjQwbC1GAYrSHWAsi9iINstoV+OPjKsV+ldNBeM8ppRebPPLJXYG107S0h5KwYRMEegt2BnT6op+VvJGc2b41grsPLCFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3yGnY3tCA5//GCNAc72cP1ww2KSqx/h6KdDSK9PfS40=;
 b=jwwk/IqUi7ZCRtaRkN/xrY8BklUiLwiaUCYwtB2ygRVgLW01rDTVd7qa3qXCUiissAHViq6ARF/2upSHemJ+uMDOIVqb985xqQqGoN1rI9JhQGOPRfMlDAOez/Si6ziLtevHxxR357zVP8nsY1GxAve2I0Tx5G0CPNT/ax8OYc8=
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com (2603:10a6:3:e0::7)
 by HE1PR0802MB2554.eurprd08.prod.outlook.com (2603:10a6:3:d7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.24; Tue, 28 Jul
 2020 01:07:14 +0000
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::9:c111:edc1:d65a]) by HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::9:c111:edc1:d65a%6]) with mapi id 15.20.3216.033; Tue, 28 Jul 2020
 01:07:14 +0000
From:   Jianyong Wu <Jianyong.Wu@arm.com>
To:     Will Deacon <will@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "yangbo.lu@nxp.com" <yangbo.lu@nxp.com>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Suzuki Poulose <Suzuki.Poulose@arm.com>,
        Steven Price <Steven.Price@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Steve Capper <Steve.Capper@arm.com>,
        Kaly Xin <Kaly.Xin@arm.com>, Justin He <Justin.He@arm.com>,
        Wei Chen <Wei.Chen@arm.com>, nd <nd@arm.com>
Subject: RE: [PATCH v13 2/9] arm/arm64: KVM: Advertise KVM UID to guests via
 SMCCC
Thread-Topic: [PATCH v13 2/9] arm/arm64: KVM: Advertise KVM UID to guests via
 SMCCC
Thread-Index: AQHWRjnTCp2aKUWCLkK9Y7ZKWPQzQKka//qwgACIboCAANxJIA==
Date:   Tue, 28 Jul 2020 01:07:14 +0000
Message-ID: <HE1PR0802MB25551F426910F76E95523383F4730@HE1PR0802MB2555.eurprd08.prod.outlook.com>
References: <20200619130120.40556-1-jianyong.wu@arm.com>
 <20200619130120.40556-3-jianyong.wu@arm.com>
 <HE1PR0802MB255577943C260898A6C686ABF4720@HE1PR0802MB2555.eurprd08.prod.outlook.com>
 <20200727113821.GB20437@willie-the-truck>
In-Reply-To: <20200727113821.GB20437@willie-the-truck>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 2c2709e5-9248-405e-95a3-96a1b63a0504.1
x-checkrecipientchecked: true
Authentication-Results-Original: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
x-originating-ip: [203.126.0.111]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5c25fac9-92a5-4e51-bff9-08d83292960f
x-ms-traffictypediagnostic: HE1PR0802MB2554:|DBBPR08MB4537:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <DBBPR08MB45377165BF55903607F12F23F4730@DBBPR08MB4537.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:6430;OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: AHL81wIJOSyir2m00PCT9y9xNDdjIz51KbLICp9O9BiF/N5ZRflFhwN3N7a7gNpgQDagidwtApFMVVnB97qGTTwmkVo+JAkLd3QnGhxY0h32UE5TUanfrIVzMIbOkjF7Vg2vyiy0lDVdV2Yjg8a2UkohlFrByuYvheH+bp4Zc8IGxIN6x6NqqyhdhtxY00aYy9CpAxVIlWNhIKShhmKfFPtMSoDugiOIrBA/LZDGTo3Z2FGYz3niW/UgC7+eSBzLvhxBlzBhK53ISLUZfGlxpdNdg/FQPcdFlx3zCjZ3wurw9zyW439QWopSgaC/zbbw3feXYae9Q0Mzv+8XahjFow==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0802MB2555.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(376002)(346002)(366004)(39860400002)(396003)(55016002)(9686003)(54906003)(316002)(71200400001)(86362001)(8676002)(6916009)(186003)(7696005)(6506007)(33656002)(83380400001)(26005)(478600001)(2906002)(5660300002)(76116006)(52536014)(53546011)(66476007)(66556008)(64756008)(66446008)(8936002)(4326008)(7416002)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 94HlQIIz6WNdy4B8Lx8VxYdgF4ydylsCuvc6vZP7Van6cZxC9Vg6KBh5p3z+qgpOSB+Q7/2IoUwUtswBlRp4NKRESUhrayTTaLWditzQhgDBbJ7tQ3NYiBOLdVjJWsssGvd7OHT41nTrfcTICVVpyD99uYmGxFMgQluuWSfZrR3c3+f2+minrVvrgMhqzv+iPVNbpbrVTK3MUZrcLb9ELS5lv0/JvaHjZKwON6mOL+c9+XtJ7xnkDqsnoIh5+ZPFq/jFbFeRSZjuzHBHJKeJ6C+Lq+rCcml3f5kupXU8H2VqfpT8wUrJ89de0H0iF2NIDc5o+Xk958hvq+bxMR/iZ0EPzIBih9necqFDxT7Vbji89/24Aq4sVYX9li3bmsE4J11hlBz7IMTa0nZayFKp7AceXfLO0FMi/wMhWNKH1+5WooKjAfU+hIDH1xpsGFcV9tOeS0hxC/951S0O1ex7bGDkWNPBYSoq+sbNxpTie1E=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0802MB2554
Original-Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM5EUR03FT038.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: f87590a5-58f3-4827-72d1-08d8329290c6
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5IVq70FGqxFwk1SNhgYPJlv+/vi8cwQ30BDmVkfw2pKN+FN6+zdSbKORfHd0Nt4xVb6u/ZQDH7WDlXZzzzts69EixV/Wdm3EoQ/Cdo0fe5vvSu46SBBFfVTZrAdITpeoUQjtLg6W7fmR4YRx6DDwcsKhFtT8h5tOCoXB4ohcdllwo1ohUpQCormyZ80peutkwbmfKWreBtMg9QrrjwOjM7qiaY4fX0FfjLcRf3/TeQMN6CeV5cqc81czGEm9FcxMRpxsnL+t1CKvqex8pnFSJ4LcZluYornmuLMzephR8QjpD6YAdzrpyiXAPMGZwUALJ4QRP5IKxydKN35xodiVV59p5hbTvjyEvU3sWLxnERkGTER5Dl38OptiRM7K9il5v8YlXnYy0rMDUGXsreMpcg==
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFTY:;SFS:(4636009)(376002)(136003)(346002)(39860400002)(396003)(46966005)(316002)(36906005)(336012)(8676002)(478600001)(82310400002)(4326008)(82740400003)(70586007)(70206006)(450100002)(356005)(2906002)(81166007)(47076004)(26005)(83380400001)(7696005)(5660300002)(86362001)(54906003)(8936002)(53546011)(6862004)(9686003)(55016002)(6506007)(52536014)(33656002)(186003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2020 01:07:23.5994
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c25fac9-92a5-4e51-bff9-08d83292960f
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: AM5EUR03FT038.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB4537
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Will Deacon <will@kernel.org>
> Sent: Monday, July 27, 2020 7:38 PM
> To: Jianyong Wu <Jianyong.Wu@arm.com>
> Cc: netdev@vger.kernel.org; yangbo.lu@nxp.com; john.stultz@linaro.org;
> tglx@linutronix.de; pbonzini@redhat.com; sean.j.christopherson@intel.com;
> maz@kernel.org; richardcochran@gmail.com; Mark Rutland
> <Mark.Rutland@arm.com>; Suzuki Poulose <Suzuki.Poulose@arm.com>;
> Steven Price <Steven.Price@arm.com>; linux-kernel@vger.kernel.org; linux-
> arm-kernel@lists.infradead.org; kvmarm@lists.cs.columbia.edu;
> kvm@vger.kernel.org; Steve Capper <Steve.Capper@arm.com>; Kaly Xin
> <Kaly.Xin@arm.com>; Justin He <Justin.He@arm.com>; Wei Chen
> <Wei.Chen@arm.com>; nd <nd@arm.com>
> Subject: Re: [PATCH v13 2/9] arm/arm64: KVM: Advertise KVM UID to guests
> via SMCCC
>=20
> On Mon, Jul 27, 2020 at 03:45:37AM +0000, Jianyong Wu wrote:
> > > From: Will Deacon <will@kernel.org>
> > >
> > > We can advertise ourselves to guests as KVM and provide a basic
> > > features bitmap for discoverability of future hypervisor services.
> > >
> > > Cc: Marc Zyngier <maz@kernel.org>
> > > Signed-off-by: Will Deacon <will@kernel.org>
> > > Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
> > > ---
> > >  arch/arm64/kvm/hypercalls.c | 29 +++++++++++++++++++----------
> > >  1 file changed, 19 insertions(+), 10 deletions(-)
> > >
> > > diff --git a/arch/arm64/kvm/hypercalls.c
> > > b/arch/arm64/kvm/hypercalls.c index 550dfa3e53cd..db6dce3d0e23
> > > 100644
> > > --- a/arch/arm64/kvm/hypercalls.c
> > > +++ b/arch/arm64/kvm/hypercalls.c
> > > @@ -12,13 +12,13 @@
> > >  int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)  {
> > >  	u32 func_id =3D smccc_get_function(vcpu);
> > > -	long val =3D SMCCC_RET_NOT_SUPPORTED;
> > > +	u32 val[4] =3D {SMCCC_RET_NOT_SUPPORTED};
> >
> > There is a risk as this u32 value will return here and a u64 value
> > will be obtained in guest. For example, The val[0] is initialized as
> > -1 of 0xffffffff and the guest get 0xffffffff then it will be compared
> > with -1 of 0xffffffffffffffff Also this problem exists for the
> > transfer of address in u64 type. So the following assignment to "val"
> > should be split into two
> > u32 value and assign to val[0] and val[1] respectively.
> > WDYT?
>=20
> Yes, I think you're right that this is a bug, but isn't the solution just=
 to make
> that an array of 'long'?
>=20
> 	long val [4];
>=20
> That will sign-extend the negative error codes as required, while leaving=
 the
> explicitly unsigned UID constants alone.

Ok, that's much better. I will fix it at next version.

By the way, I wonder when will you update this patch set. I see someone lik=
e me
adopt this patch set as code base and need rebase it every time, so expect =
your update.

Thanks
Jianyong=20
>=20
> Will
