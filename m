Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B84EBD8705
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 05:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391111AbfJPDyj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 23:54:39 -0400
Received: from mail-eopbgr20048.outbound.protection.outlook.com ([40.107.2.48]:60597
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728710AbfJPDyj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Oct 2019 23:54:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PE9KpLY8iAabt3/UAFMFGsIzXD9Fd3FEumMHjeaXtFc=;
 b=CYw85NRNmaXNyuda4ro1ywoz9SV+DivpSPfnMXYanST190X4r+t4dk3g6L4MFex3VkSAwI+glCJ/kKcwzQ1Q9Dzrix2UmLxGfYhtseNl7IgzbtZjOsGLTLAeu85T7AK7xTHxSFi76wLMajlQrmPc9D/tXi2XizrMBFmmarDgZMo=
Received: from VI1PR08CA0128.eurprd08.prod.outlook.com (2603:10a6:800:d4::30)
 by DBBPR08MB4871.eurprd08.prod.outlook.com (2603:10a6:10:da::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2347.22; Wed, 16 Oct
 2019 03:54:27 +0000
Received: from VE1EUR03FT040.eop-EUR03.prod.protection.outlook.com
 (2a01:111:f400:7e09::206) by VI1PR08CA0128.outlook.office365.com
 (2603:10a6:800:d4::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2347.16 via Frontend
 Transport; Wed, 16 Oct 2019 03:54:25 +0000
Authentication-Results: spf=temperror (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=none action=none
 header.from=arm.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of arm.com: DNS Timeout)
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT040.mail.protection.outlook.com (10.152.18.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.2305.15 via Frontend Transport; Wed, 16 Oct 2019 03:54:24 +0000
Received: ("Tessian outbound 081de437afc7:v33"); Wed, 16 Oct 2019 03:54:20 +0000
X-CR-MTA-TID: 64aa7808
Received: from 087f0afb0663.3 (ip-172-16-0-2.eu-west-1.compute.internal [104.47.2.52])
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 0BA5B422-A7B6-40B6-8CF8-3DB3893C63F3.1;
        Wed, 16 Oct 2019 03:54:15 +0000
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01lp2052.outbound.protection.outlook.com [104.47.2.52])
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 087f0afb0663.3
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Wed, 16 Oct 2019 03:54:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b9mrZi5STR5Z8Z0ArQbJPkpU3r9hlbxkEmMC+fSU6myjdIv8CFpj/whAFDgYliIvp9xnFK5OVpJU2+4uj2uc8PdVeE846CT0McX0FTsDs8f80vdARli6NojUhx6YkpImIbHqBQNprLOMcmPWR4aaPOBcHE7PAidlON80TQxWGra9LaXti6haXb7+ZMj9qxlXluglHTDVnDY2P+bPdMYshBwNclYF7pfChhJcO4421Haee7s3q1xTy36a/9tAmNsdeN2egx5WB3SUTXtmkcH1teJ4KhzDewJWxAz91lHqlDrQaoHjHLToxScva/E+TCea/MHw+8ZIlvhmJto8vYw0JQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PE9KpLY8iAabt3/UAFMFGsIzXD9Fd3FEumMHjeaXtFc=;
 b=Bek2r4xBk/zcqdMUga0B6qAFTEtSb3RIf+5bl4kGiKWmwladiA7GcI4RzyoHEEHlQTwt5V+nra0O90+zNDfua4vvKNm1q70S6RaXXyiQ6dO7hmFy3b/Am6xC2PL0L3ctPlgN8NzcpbL3HimJcbjgMHcJrN40k7/rQr9lraPYwLd0keOSYrP1R99w7dzMVgkRGLu//+lQDHrHnuLIF7kjv+RTcCGnjt91NpXjb2H3MESOTwxHC65ECbVLzLwtZjFruPnXWffaKG7Bu7Np+aljIm1uxupiaeFh3CHj5uICN9U5fx5PqyEN8l6q1cnvwagqdsxSDW9SjnHU27+UMLYLXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PE9KpLY8iAabt3/UAFMFGsIzXD9Fd3FEumMHjeaXtFc=;
 b=CYw85NRNmaXNyuda4ro1ywoz9SV+DivpSPfnMXYanST190X4r+t4dk3g6L4MFex3VkSAwI+glCJ/kKcwzQ1Q9Dzrix2UmLxGfYhtseNl7IgzbtZjOsGLTLAeu85T7AK7xTHxSFi76wLMajlQrmPc9D/tXi2XizrMBFmmarDgZMo=
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com (10.168.146.150) by
 HE1PR0801MB1945.eurprd08.prod.outlook.com (10.168.94.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.21; Wed, 16 Oct 2019 03:54:12 +0000
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::b056:4113:e0bd:110d]) by HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::b056:4113:e0bd:110d%6]) with mapi id 15.20.2347.023; Wed, 16 Oct 2019
 03:54:11 +0000
From:   "Jianyong Wu (Arm Technology China)" <Jianyong.Wu@arm.com>
To:     Mark Rutland <Mark.Rutland@arm.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "yangbo.lu@nxp.com" <yangbo.lu@nxp.com>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "will@kernel.org" <will@kernel.org>,
        Suzuki Poulose <Suzuki.Poulose@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Steve Capper <Steve.Capper@arm.com>,
        "Kaly Xin (Arm Technology China)" <Kaly.Xin@arm.com>,
        "Justin He (Arm Technology China)" <Justin.He@arm.com>,
        nd <nd@arm.com>
Subject: RE: [PATCH v5 1/6] psci: Export psci_ops.conduit symbol as modules
 will use it.
Thread-Topic: [PATCH v5 1/6] psci: Export psci_ops.conduit symbol as modules
 will use it.
Thread-Index: AQHVg0YvYzzWm5D4UkuNpSkRp5s31Kdb9F2AgACvT8A=
Date:   Wed, 16 Oct 2019 03:54:11 +0000
Message-ID: <HE1PR0801MB1676A17D66AE91F7E0792877F4920@HE1PR0801MB1676.eurprd08.prod.outlook.com>
References: <20191015104822.13890-1-jianyong.wu@arm.com>
 <20191015104822.13890-2-jianyong.wu@arm.com>
 <20191015172453.GE24604@lakrids.cambridge.arm.com>
In-Reply-To: <20191015172453.GE24604@lakrids.cambridge.arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: fdc2e4b7-610c-412b-9e9c-427993879c74.1
x-checkrecipientchecked: true
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
x-originating-ip: [113.29.88.7]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-Correlation-Id: 4d3fe8a3-477b-4ffd-056c-08d751ec88de
X-MS-Office365-Filtering-HT: Tenant
X-MS-TrafficTypeDiagnostic: HE1PR0801MB1945:|HE1PR0801MB1945:|DBBPR08MB4871:
X-MS-Exchange-PUrlCount: 1
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <DBBPR08MB487167802188A9CE285E90C2F4920@DBBPR08MB4871.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
x-ms-oob-tlc-oobclassifiers: OLM:862;OLM:862;
x-forefront-prvs: 0192E812EC
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(10009020)(4636009)(376002)(39860400002)(366004)(346002)(396003)(136003)(13464003)(189003)(199004)(102836004)(55016002)(6246003)(81166006)(229853002)(7696005)(81156014)(53546011)(6306002)(8936002)(6506007)(86362001)(14444005)(478600001)(6862004)(6116002)(256004)(6636002)(5660300002)(76176011)(9686003)(186003)(26005)(52536014)(486006)(6436002)(66066001)(55236004)(446003)(8676002)(11346002)(476003)(316002)(3846002)(14454004)(71190400001)(71200400001)(7416002)(7736002)(25786009)(54906003)(74316002)(966005)(305945005)(99286004)(2906002)(66946007)(33656002)(4326008)(66476007)(64756008)(66446008)(76116006)(66556008);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR0801MB1945;H:HE1PR0801MB1676.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: gZc36TzA4pOPtQ/n+KbDvf/sYvv2PdXcXgjX5d4rztmaSTkhTw/Y3u/UtztCrMGqCoLRk9ue5AwlZODp15z8+81BaTWY4P0USBUKDEcbWZDLX8mdVeCrS7wuHxt6JhrgPxBzqiJIkKdCWKRfKu6Mel+iYN6Yj4l2w5axevVROn45EL+2AeW1+26NaK5M6IAZKp6B7rWSOm++Ci45LfOlSqYaDb3Y+u4Gk5qg/oWVsHEomU/ePYZvuwGssKgRE/f6l62BDAEczEQYzyFsKXTLcJi3Jnc2LSY73TgI6kl0A/MJYVo4dWYz/dQU3IEphRFu34uhINWxTbbUCU5OQ5qDIS/klfibsC4ytjdabTINVO/ovNCrZqWVt0nvztpeETJclIprszrF5/vQUC8NlmpcO/Uhi0Bj56I7BpwTA8de5KhY8nVXv9TqPAf6x7WkF8sCRz+d+hp/Ml7K91CZ4IFyBA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0801MB1945
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT040.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;IPV:CAL;SCL:-1;CTRY:IE;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(376002)(346002)(136003)(13464003)(189003)(199004)(102836004)(22756006)(53546011)(76176011)(450100002)(46406003)(86362001)(9686003)(33656002)(97756001)(316002)(63350400001)(446003)(229853002)(36906005)(6506007)(99286004)(8746002)(54906003)(66066001)(5660300002)(26005)(26826003)(478600001)(7696005)(8936002)(47776003)(186003)(23726003)(81166006)(81156014)(55016002)(6636002)(6116002)(6246003)(76130400001)(6306002)(476003)(14444005)(966005)(3846002)(52536014)(14454004)(8676002)(486006)(356004)(336012)(2906002)(70586007)(4326008)(25786009)(74316002)(50466002)(11346002)(126002)(6862004)(305945005)(70206006)(7736002);DIR:OUT;SFP:1101;SCL:1;SRVR:DBBPR08MB4871;H:64aa7808-outbound-1.mta.getcheckrecipient.com;FPR:;SPF:TempError;LANG:en;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;MX:1;A:1;
X-MS-Office365-Filtering-Correlation-Id-Prvs: b96f3795-012e-474d-870d-08d751ec814b
NoDisclaimer: True
X-Forefront-PRVS: 0192E812EC
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cxWWC8UiwXyvwJ5MS9bAAqM4BFFpVx9IX4dR/srS3vXfwt1GdI25B2vjU8iysKddiKfLNnlcoVN+IsAqv1GDGodvLFXzEXnFuDJUktVahJviMXGVDzrxXVZTRBCOs7aEaTJT41LYJo7F4Lgr9pe4ZQRZyiqdTLWB3t47LQELVr79rZXy86pAzH6FsyQbzWiHuebxWf1RIBwparKNqITZwj3U/1aEKyFuCMt6ppzKrNLMY3hrFelJU7wKhZDSkJVi9y7ROVxE5heE/ke2PGW9+2XsDE+RLtpP0Kg2Z+VHCM1T4yQBvv57pYGmBMTNqxjw98HwiHPB7OICEHC2ddMd6+oaTS53i2wgOjPBD5EuoKczkgQaR1yQntmlNFgOdGUlxnQSix9SmlABinPIKLGAln9Ef8dEWFm6+ol2ufJ1G+cBKDzvjka/fb6sLw2djDK4fSdV6Ryin5n13QMwDfG55Q==
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2019 03:54:24.4866
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d3fe8a3-477b-4ffd-056c-08d751ec88de
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB4871
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Mark,

> -----Original Message-----
> From: Mark Rutland <mark.rutland@arm.com>
> Sent: Wednesday, October 16, 2019 1:25 AM
> To: Jianyong Wu (Arm Technology China) <Jianyong.Wu@arm.com>
> Cc: netdev@vger.kernel.org; yangbo.lu@nxp.com; john.stultz@linaro.org;
> tglx@linutronix.de; pbonzini@redhat.com; sean.j.christopherson@intel.com;
> maz@kernel.org; richardcochran@gmail.com; will@kernel.org; Suzuki
> Poulose <Suzuki.Poulose@arm.com>; linux-kernel@vger.kernel.org; linux-
> arm-kernel@lists.infradead.org; kvmarm@lists.cs.columbia.edu;
> kvm@vger.kernel.org; Steve Capper <Steve.Capper@arm.com>; Kaly Xin
> (Arm Technology China) <Kaly.Xin@arm.com>; Justin He (Arm Technology
> China) <Justin.He@arm.com>; nd <nd@arm.com>
> Subject: Re: [PATCH v5 1/6] psci: Export psci_ops.conduit symbol as modul=
es
> will use it.
>=20
> On Tue, Oct 15, 2019 at 06:48:17PM +0800, Jianyong Wu wrote:
> > If arm_smccc_1_1_invoke used in modules, psci_ops.conduit should be
> > export.
> >
> > Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
>=20
> I have a patch queued [1] in the arm64 tree which adds
> arm_smccc_1_1_get_conduit() for this purpose.
>=20
> Please use that, adding an EXPORT_SYMBOL() if necessary.
>=20

Great, I will apply it next version.

Thanks
Jianyong Wu

> Thanks,
> Mark.
>=20
> [1]
> https://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git/commit/?h=
=3D
> for-next/smccc-conduit-
> cleanup&id=3D6b7fe77c334ae59fed9500140e08f4f896b36871
>=20
> > ---
> >  drivers/firmware/psci/psci.c | 6 ++++++
> >  include/linux/arm-smccc.h    | 2 +-
> >  include/linux/psci.h         | 1 +
> >  3 files changed, 8 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/firmware/psci/psci.c
> > b/drivers/firmware/psci/psci.c index f82ccd39a913..35c4eaab1451 100644
> > --- a/drivers/firmware/psci/psci.c
> > +++ b/drivers/firmware/psci/psci.c
> > @@ -212,6 +212,12 @@ static unsigned long
> psci_migrate_info_up_cpu(void)
> >  			      0, 0, 0);
> >  }
> >
> > +enum psci_conduit psci_get_conduit(void) {
> > +	return psci_ops.conduit;
> > +}
> > +EXPORT_SYMBOL(psci_get_conduit);
> > +
> >  static void set_conduit(enum psci_conduit conduit)  {
> >  	switch (conduit) {
> > diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
> > index 552cbd49abe8..a6e4d3e3d10a 100644
> > --- a/include/linux/arm-smccc.h
> > +++ b/include/linux/arm-smccc.h
> > @@ -357,7 +357,7 @@ asmlinkage void __arm_smccc_hvc(unsigned long
> a0, unsigned long a1,
> >   * The return value also provides the conduit that was used.
> >   */
> >  #define arm_smccc_1_1_invoke(...) ({
> 	\
> > -		int method =3D psci_ops.conduit;				\
> > +		int method =3D psci_get_conduit();			\
> >  		switch (method) {					\
> >  		case PSCI_CONDUIT_HVC:
> 	\
> >  			arm_smccc_1_1_hvc(__VA_ARGS__);
> 	\
> > diff --git a/include/linux/psci.h b/include/linux/psci.h index
> > a8a15613c157..e5cedc986049 100644
> > --- a/include/linux/psci.h
> > +++ b/include/linux/psci.h
> > @@ -42,6 +42,7 @@ struct psci_operations {
> >  	enum smccc_version smccc_version;
> >  };
> >
> > +extern enum psci_conduit psci_get_conduit(void);
> >  extern struct psci_operations psci_ops;
> >
> >  #if defined(CONFIG_ARM_PSCI_FW)
> > --
> > 2.17.1
> >
