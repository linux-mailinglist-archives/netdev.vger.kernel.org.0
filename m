Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34082136AC7
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 11:16:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727542AbgAJKQO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 05:16:14 -0500
Received: from mail-eopbgr120073.outbound.protection.outlook.com ([40.107.12.73]:19999
        "EHLO FRA01-PR2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727240AbgAJKQO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jan 2020 05:16:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aRE7Zl5f7Lm34o24x9NnMLeKFUg+FHxtJnk+Krctn90=;
 b=9gTJXiXLl9OK7wSveqze0hj3T9F6vzp2NfQ6jc6KY0yy8I5/ml72TGV+NXgrkdcoWU7MJuUhttCD9ru+SiRqNBXcxbKx8yAvJNfz6d9sZyxPc9O6sD0MRyj6dOAjhZFCPMB/+4jb6Uir5/HJvDmbpcHElpm2914lCOpG3yNBB5o=
Received: from VI1PR08CA0129.eurprd08.prod.outlook.com (2603:10a6:800:d4::31)
 by PR2PR08MB4921.eurprd08.prod.outlook.com (2603:10a6:101:22::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.10; Fri, 10 Jan
 2020 10:16:07 +0000
Received: from VE1EUR03FT021.eop-EUR03.prod.protection.outlook.com
 (2a01:111:f400:7e09::203) by VI1PR08CA0129.outlook.office365.com
 (2603:10a6:800:d4::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.10 via Frontend
 Transport; Fri, 10 Jan 2020 10:16:07 +0000
Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=bestguesspass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT021.mail.protection.outlook.com (10.152.18.117) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.11 via Frontend Transport; Fri, 10 Jan 2020 10:16:06 +0000
Received: ("Tessian outbound ca1df68f3668:v40"); Fri, 10 Jan 2020 10:16:06 +0000
X-CR-MTA-TID: 64aa7808
Received: from e13ea9f64c11.2
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 6A4CD541-862C-4798-AD23-8866AB6F8AE1.1;
        Fri, 10 Jan 2020 10:16:01 +0000
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id e13ea9f64c11.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Fri, 10 Jan 2020 10:16:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PimcnmjlFKqHkQseE7/uWtYpL2qfItDg+oI7ATCrDRx4HdcJWnw7iBbTkhNbrqQzVFhCJJrLao4cu6H6VhgrsRAUvoghSZ20fG2g+QCEQPuluqltMN5BDAMQiw8mLi2/bFtStrGsUfy3wCgBYy6FRkVA1NAI24uBhklKMhbWWiVbYAx8UP+W3LD3cBOFYZbmT4nCqsut9qVnRBSeBIrTuyJgARNoSJUu75pvw6hHRbufWc/hClwau/ErDahzB5Bgiipumpc+QynyGtI2lv2S111yFCMuBlZu2qFYZ0nlMZWzydfvMHTPS4sGQbbCugLsopaDSwV6WwqeuxhIfVbVBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aRE7Zl5f7Lm34o24x9NnMLeKFUg+FHxtJnk+Krctn90=;
 b=YmpkpaioyNZletgdRHITmEP7qnqXTx3DWm/TPjwWE+3DyBJPPArOXshjmPQ6BcSPxgA3GWgLUBPU1Cf1qcdYKYgjzcr448VPsy2d8+KjkZWkL1vQzVm43eCQovtM9x/fQ3aLeOn6xB/DfO5C8V7kITi7j4lx0N/fFaYvT6+9gjWLKvu0SVA2y+Y6uw1pJNsn0lYHoF49uzGa8yo3ldh0ulxaLDsj6y8rE0gkwWg48fwanYv0Cfdfi0Vfj2zoxD2VXmelH0JZyf3x9GNyFnX+no9ZXLF88jBjh04U4+GBCeuNHNfx2pntrwQ7DnvkLqZ9CGZsPdZuHxF+k384BnfLXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aRE7Zl5f7Lm34o24x9NnMLeKFUg+FHxtJnk+Krctn90=;
 b=9gTJXiXLl9OK7wSveqze0hj3T9F6vzp2NfQ6jc6KY0yy8I5/ml72TGV+NXgrkdcoWU7MJuUhttCD9ru+SiRqNBXcxbKx8yAvJNfz6d9sZyxPc9O6sD0MRyj6dOAjhZFCPMB/+4jb6Uir5/HJvDmbpcHElpm2914lCOpG3yNBB5o=
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com (10.168.146.150) by
 HE1PR0801MB1883.eurprd08.prod.outlook.com (10.168.94.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.9; Fri, 10 Jan 2020 10:15:58 +0000
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::49c0:e8df:b9be:724f]) by HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::49c0:e8df:b9be:724f%8]) with mapi id 15.20.2623.013; Fri, 10 Jan 2020
 10:15:58 +0000
From:   Jianyong Wu <Jianyong.Wu@arm.com>
To:     Marc Zyngier <maz@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "yangbo.lu@nxp.com" <yangbo.lu@nxp.com>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "will@kernel.org" <will@kernel.org>,
        Suzuki Poulose <Suzuki.Poulose@arm.com>,
        Steven Price <Steven.Price@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Steve Capper <Steve.Capper@arm.com>,
        Kaly Xin <Kaly.Xin@arm.com>, Justin He <Justin.He@arm.com>,
        nd <nd@arm.com>,
        "kvm-owner@vger.kernel.org" <kvm-owner@vger.kernel.org>
Subject: RE: [RFC PATCH v9 7/8] ptp: arm64: Enable ptp_kvm for arm64
Thread-Topic: [RFC PATCH v9 7/8] ptp: arm64: Enable ptp_kvm for arm64
Thread-Index: AQHVrwu1ZTEnzkrQbEOo/hXDFqaU6affG9SAgALmpVCAADyUAIAABh4AgAGacqA=
Date:   Fri, 10 Jan 2020 10:15:58 +0000
Message-ID: <HE1PR0801MB16762CD153C2D598AD8C8E1BF4380@HE1PR0801MB1676.eurprd08.prod.outlook.com>
References: <20191210034026.45229-1-jianyong.wu@arm.com>
 <20191210034026.45229-8-jianyong.wu@arm.com>
 <ca162efb3a0de530e119f5237c006515@kernel.org>
 <HE1PR0801MB1676EE12CF0DB7C5BB8CC62DF4390@HE1PR0801MB1676.eurprd08.prod.outlook.com>
 <ee801dacbf4143e8d41807d5bfad1409@kernel.org>
 <a5f5fc5bf913c9a22923d1a556f511e6@kernel.org>
In-Reply-To: <a5f5fc5bf913c9a22923d1a556f511e6@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 3da94c0b-a9a0-4647-94ff-272c69f57211.1
x-checkrecipientchecked: true
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
x-originating-ip: [113.29.88.7]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b977c6de-f75e-4985-282a-08d795b61b31
X-MS-TrafficTypeDiagnostic: HE1PR0801MB1883:|HE1PR0801MB1883:|PR2PR08MB4921:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <PR2PR08MB4921C1A244B514E88CB0AF97F4380@PR2PR08MB4921.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: True
x-ms-oob-tlc-oobclassifiers: OLM:3631;OLM:3631;
x-forefront-prvs: 02788FF38E
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(396003)(346002)(39860400002)(376002)(199004)(189003)(13464003)(55016002)(316002)(55236004)(26005)(81156014)(8676002)(6916009)(54906003)(8936002)(81166006)(5660300002)(4326008)(7416002)(64756008)(71200400001)(66946007)(66476007)(66556008)(66446008)(7696005)(2906002)(76116006)(478600001)(52536014)(86362001)(6506007)(9686003)(33656002)(53546011)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR0801MB1883;H:HE1PR0801MB1676.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: KJ4Pb4rCMI33BSd2IvzdCFP+LYurTqxbP5AkGBa1cn3DGW8sS3+tYDSM/a+bw3IhYbedMez1Xl9vSMJhuEdbk48iCCoxMJWwoIyuxt/WTssFBQZaeg7MVsi5pVkhp+idB21QltxqM7jUCG2ZnAT6OpX/YKl6F/CYp2ap3WmYjypEHUJK7ZUNB4CH1DNn1hdru8DIdsLxbiZ0cSNLRG9stKzLpilZm1ilkO92HV3gDNIqJyuGbP631Zr5gk2DeQO5gmnCn8dtspYLuyiNBJ8o3ADl68NLn06fTTOEfFlmfD0GUE98OUYr/JsjzwsjywZic02h2PYlgoCURrechuPM9EQ/+5Pf8gPKMxiSiGMQkk5rfCt3OWpGyly30dhxaPOaBYEFNFvcmt7PYHViuulN3KYH0+OyeLYWPAmKvw0epnO4qZgALLewgM9nTtg9nNSB1Txxnqr26pU0AJ/aOf/BQ2AhnYU4umq9MdVA82GcyBjXC50pTOIDNOyBomXhKCrh
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0801MB1883
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT021.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;IPV:CAL;SCL:-1;CTRY:IE;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(376002)(39860400002)(396003)(199004)(189003)(13464003)(7696005)(9686003)(2906002)(70586007)(6862004)(8676002)(26826003)(86362001)(55016002)(450100002)(4326008)(70206006)(356004)(33656002)(81166006)(26005)(52536014)(5660300002)(81156014)(186003)(316002)(54906003)(336012)(53546011)(6506007)(478600001)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:PR2PR08MB4921;H:64aa7808-outbound-1.mta.getcheckrecipient.com;FPR:;SPF:Pass;LANG:en;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;A:1;MX:1;
X-MS-Office365-Filtering-Correlation-Id-Prvs: 403b40da-4dc9-46dc-347e-08d795b61608
X-Forefront-PRVS: 02788FF38E
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ePmbVp6D/bq1fv8DijzzP11dq3k4G/GzxyRKyjiVPQSTD2yUdyFuSfwhlBYT40FFRqwc3ZBNn0dpQLKTRBuZXrhs7Tx5VJkW2WOiBDqJ/30+QZU7CWUucQDMuEWhsNqpX0yBs3+Q37rTZTUtW3ts6nZXk1CZfIpsKhsyPB9w/GlIEWMsXsxPYCdP0NVSSBtbxqjBlgtLxlCEaQ5fIRnhN4IG5JgHknavMRuno69xO4N8giOpQoYYCiUUrC69G70tdXYPH07pKx3IdRTPfOu6cI7totF7NGYheHJW7Nm6x5Y2wxk7YC1IEhqMfLNnUQ+Ws77Wan5cOVBIDKb8ZqsK+gkBpvHTlyUDUhlB8tVxBcpuR4J6lEH3v26Iw7B9ZLgyNzH3hAs2aOfKIqdn6OHv8278nOrvU5RI39gGCPoYl1/Rob/2HuRTXDwtSEOAVvrDkXESBnqWL0t3cUKWJVlJ4In3RQBS+pNu/P009YWzARAWoVMTQAA1M01ajLIfQIg7
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2020 10:16:06.6475
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b977c6de-f75e-4985-282a-08d795b61b31
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR2PR08MB4921
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

> -----Original Message-----
> From: Marc Zyngier <maz@kernel.org>
> Sent: Thursday, January 9, 2020 5:46 PM
> To: Jianyong Wu <Jianyong.Wu@arm.com>
> Cc: netdev@vger.kernel.org; yangbo.lu@nxp.com; john.stultz@linaro.org;
> tglx@linutronix.de; pbonzini@redhat.com; sean.j.christopherson@intel.com;
> richardcochran@gmail.com; Mark Rutland <Mark.Rutland@arm.com>;
> will@kernel.org; Suzuki Poulose <Suzuki.Poulose@arm.com>; Steven Price
> <Steven.Price@arm.com>; linux-kernel@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; kvmarm@lists.cs.columbia.edu;
> kvm@vger.kernel.org; Steve Capper <Steve.Capper@arm.com>; Kaly Xin
> <Kaly.Xin@arm.com>; Justin He <Justin.He@arm.com>; nd <nd@arm.com>;
> kvm-owner@vger.kernel.org
> Subject: Re: [RFC PATCH v9 7/8] ptp: arm64: Enable ptp_kvm for arm64
>=20
> On 2020-01-09 09:24, Marc Zyngier wrote:
> > On 2020-01-09 05:59, Jianyong Wu wrote:
>=20
> [...]
>=20
> >> So we focus it on arm64. Also I have never tested it on arm32 machine
> >> ( we lack of arm32 machine)
> >
> > I'm sure your employer can provide you with such a box. I can probably
> > even tell you which cupboard they are stored in... ;-)
> >
> >> Do you think it's necessary to enable ptp_kvm on arm32? If so, I can
> >> do that.
> >
> > I can't see why we wouldn't, given that it should be a zero effort
> > task (none of the code here is arch specific).
>=20
> To be clear, what I'm after is support for 32bit *guests*. I don't expect=
 any
> issue with a 32bit host (it's all common code), but you should be able to=
 test
> 32bit guests pretty easily (most ARMv8.0 CPUs support 32bit EL1).
>=20
Get it

Thanks
Jianyong=20

>          M.
> --
> Jazz is not dead. It just smells funny...
