Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B4A225F4C1
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 10:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728018AbgIGINb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 04:13:31 -0400
Received: from mail-eopbgr140051.outbound.protection.outlook.com ([40.107.14.51]:38206
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726978AbgIGIN1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 04:13:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tSge4mAAgzFI1bHPOW+g9AeqGKti0utFFyJoSTaNgHA=;
 b=IU8AWXI48XDtsQuITyZ5Yd51roNfehvKnQ62CUdMEWHTKl6SwTQ9CxXaC3oSoyQNjUWHC0p9kC75VRiMM6Xsx7Ugk0CglOtSLt+nYupG6mENxXjpcijVYNzdlhRxiljEiRh/87YuuVTiYW3341vUgKOVS9aknb2ckFMXG+5qYB4=
Received: from AM6P191CA0006.EURP191.PROD.OUTLOOK.COM (2603:10a6:209:8b::19)
 by VI1PR08MB4175.eurprd08.prod.outlook.com (2603:10a6:803:ea::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15; Mon, 7 Sep
 2020 08:13:20 +0000
Received: from AM5EUR03FT021.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:209:8b:cafe::f1) by AM6P191CA0006.outlook.office365.com
 (2603:10a6:209:8b::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15 via Frontend
 Transport; Mon, 7 Sep 2020 08:13:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=bestguesspass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM5EUR03FT021.mail.protection.outlook.com (10.152.16.105) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3348.16 via Frontend Transport; Mon, 7 Sep 2020 08:13:20 +0000
Received: ("Tessian outbound 7a6fb63c1e64:v64"); Mon, 07 Sep 2020 08:13:20 +0000
X-CR-MTA-TID: 64aa7808
Received: from 4c20561f486f.2
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id C37BF94B-6551-4AC7-A0D1-9B1BEEB2547A.1;
        Mon, 07 Sep 2020 08:13:15 +0000
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 4c20561f486f.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Mon, 07 Sep 2020 08:13:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QqXTjfNtx3caz+Yiir6gblTANVXT5z8IYkKejaqUgYfsO5PNBqnjrNBl9ZUcjh4o07t/v47xKP9aMeE8InBuBFuEobK6cuN5YFQkl8UK77Y5KJ+K4E3wo5g9RWoLAMMzByrdfLIqci036PeFF7+biOFr5UgF+LF+s2HXD/T5pV7qrtmmnTPSRO1dqwAy97pbgO/pn8/568fZZ2SnXjbmsvl59TA8p0lXJxp/VHQRO9cD35vBN4kR7nSsl9zCTsNFygA+i7KngZFtt9cxluWPSWtQp5ghZaXOAnDkIVZE6vehpcu9VpK3eF5R2ka9Lhgq/4fi+ziJBTVN6M2mGk48qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tSge4mAAgzFI1bHPOW+g9AeqGKti0utFFyJoSTaNgHA=;
 b=Lcj27zeynswzJjFTFcSPqtXE4zsDOkxD7cQ8Z4gf9TjiO9mf7iaLlLfCXf3HGxDQqE1hEq6V45RmL5g3yBPn78PffzZALpdJgqtEDNAsjfqgqaFAamtJ3yCsRh7s3ML5hVFCAKvCfAKSewmuUCAUl+WFJ3GVmZliwj5BPNtITDMCqT33b8TfTgw7mLba+IWasCzkhojH0GqiSMzYxzsyhP1BwrpNimx4Sxl+kJH2UmleKYA0B574rFpphKJvr5s87PMDLhiRva6z8ygw2i/ula+/Ztd3xCy6oFrpT4yo14/xu3SWcL1UA6T/51oT2cwKb+aMOvzLdcJrt6PSCw3aig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tSge4mAAgzFI1bHPOW+g9AeqGKti0utFFyJoSTaNgHA=;
 b=IU8AWXI48XDtsQuITyZ5Yd51roNfehvKnQ62CUdMEWHTKl6SwTQ9CxXaC3oSoyQNjUWHC0p9kC75VRiMM6Xsx7Ugk0CglOtSLt+nYupG6mENxXjpcijVYNzdlhRxiljEiRh/87YuuVTiYW3341vUgKOVS9aknb2ckFMXG+5qYB4=
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com (2603:10a6:3:e0::7)
 by HE1PR0801MB2121.eurprd08.prod.outlook.com (2603:10a6:3:80::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.17; Mon, 7 Sep
 2020 08:13:11 +0000
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::74f7:5759:4e9e:6e00]) by HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::74f7:5759:4e9e:6e00%5]) with mapi id 15.20.3348.019; Mon, 7 Sep 2020
 08:13:11 +0000
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
        Justin He <Justin.He@arm.com>, nd <nd@arm.com>
Subject: RE: [PATCH v14 07/10] arm64/kvm: Add hypercall service for kvm ptp.
Thread-Topic: [PATCH v14 07/10] arm64/kvm: Add hypercall service for kvm ptp.
Thread-Index: AQHWgp30ocMxzsQpy0OAzPdSdzfgH6lZ41MAgAL0IWA=
Date:   Mon, 7 Sep 2020 08:13:11 +0000
Message-ID: <HE1PR0802MB25553E713006580825C367ACF4280@HE1PR0802MB2555.eurprd08.prod.outlook.com>
References: <20200904092744.167655-1-jianyong.wu@arm.com>
        <20200904092744.167655-8-jianyong.wu@arm.com> <87363wmqmt.wl-maz@kernel.org>
In-Reply-To: <87363wmqmt.wl-maz@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 544E1C1161343148A170E7A60EE6B09F.0
x-checkrecipientchecked: true
Authentication-Results-Original: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
x-originating-ip: [203.126.0.111]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a837e2f2-e5a6-41a8-c963-08d85305e1e5
x-ms-traffictypediagnostic: HE1PR0801MB2121:|VI1PR08MB4175:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <VI1PR08MB4175BEF8FF36D197DD6022D4F4280@VI1PR08MB4175.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:7219;OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: hyrZcwOLsv5j8KqSAPyjuR1b9XYCLIyrM8mz/Yg9tpJ/Pxh4OaFilNrjjBziSp7WwJuRPFXvK594y/llyU3WWi5gBDO4NhIAY9FMDI9giOKqm7pEAiJX6HI/IqWKvQ4oeNwSZxXQOyN2H0ylKv74dKeXIZUz3YtYsVFKWwvwkUct+M1d3ya2X3+/vuk+rjLi89PTTph/lpqlcdaDUAhF3D+ehB6xVVVuMfSyuDe2AAga+YMqwoddYva3T6HTiqAtVIr2+DOsbIJtZlI1fqvzpiP4JmIXnCHk8TayrGubjTyJ/wibkuVLfoL16jiWUzVl
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0802MB2555.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(136003)(396003)(39860400002)(376002)(66446008)(26005)(33656002)(9686003)(55016002)(54906003)(7696005)(4326008)(8676002)(53546011)(6506007)(316002)(86362001)(83380400001)(186003)(64756008)(66946007)(5660300002)(52536014)(66476007)(66556008)(71200400001)(76116006)(2906002)(7416002)(478600001)(8936002)(6916009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: R1o3yHDgxnEReRa0ICEOfiN+93LDcfk92TE21u3/wiUFwTW4CWvHbV9MX5f8sYqRb61RWVyn3t3BBANdsfsvBfM38z8G03WtTKvim2YzFf6S+p/o4AqCfxHD5BP/+M8twWZP1RXafOdi+iuAUzHwIl99zXUm65NUS7l0MdrnwmgQ813OsbME64Lb9NVdyTAb4JCw4b/SjBwAWl4L+CKAOmosGuFYUboqtW8uAfV560WN8DEUOOQC5ys/KXdAb7llEAF6MseIivCbO6ddQgrpnVvoiVCUX8udLlpEok0yFXDF3SbmOQ//hZFM7Td67aTBh1HndByuuXXr1UDmej8xKIPJNqdPQrZveI9KdIFtN1wyFTZjomOOi06rgqO2v8iaoEfYu+UDsIU+OAkMZIWCLk3TwB2+BR28n+muCstJF9JLylpdF8JQdWFqexp7sCrrQJWyVMY5+4XEBSU3EaJbq/74xw7Tpd0eRpFf2QAQmfFPieTdyoyrBW8jdKDE0iMKI2F9Laxp5HJlsmsjXuWZyq5Ged78WLMHV+0JGYdd+c61yH3rmU/SEn/NzQEkM/f4X6QS66RWVD+jx5FNsmSUS3nqU0O1yPi5GS8oRtGdBWh8pUTC4kYteN3zP1aTZc0j/Y3YA0gRNKa8ZiBJO5Y8cg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0801MB2121
Original-Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM5EUR03FT021.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: dd4525d2-5624-46bd-beac-08d85305dccd
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A2oOcWYmoZb6P41AEEpmHIA24szR2tO0aBQEYx8HlZmagK38zm49BNFOWI1ObV2oQHhLZebfmxJOX3HmBSgT198kl0DcQOgkBEDVBiEyKp87PZga0/37lxNSPvXup+jBcN5WhPwqeK9FwcgLpVav/DeKGrinjEdOVbVvAisf7BxdTa2Pt1316JOZbwI2gSELUeAYpbkvt5UAQjRl0CX8DEN/Zk4X9V2VhNg12TSsdzFuHjPUYjFkpHTaqm3fURKcWwyvJvSxEL3ntZuEwqX860jCk+WHaL4suyWkXmlbe0XKb2mLEZ4qw2uoRBNu6gLrpc9jmb5sXfZ1GzQZn9AJg8IMPJu4+rK6jEBhMJWoZ9QQAsxnUEFWpOu2pIJOgUQmFP7Wri4ba774V6+p/5QV7Q==
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(136003)(39860400002)(346002)(396003)(376002)(46966005)(4326008)(478600001)(83380400001)(47076004)(9686003)(33656002)(7696005)(36906005)(2906002)(6862004)(81166007)(5660300002)(54906003)(82740400003)(316002)(450100002)(356005)(336012)(55016002)(53546011)(186003)(26005)(86362001)(52536014)(6506007)(70206006)(70586007)(82310400003)(8936002)(8676002);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2020 08:13:20.1890
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a837e2f2-e5a6-41a8-c963-08d85305e1e5
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: AM5EUR03FT021.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB4175
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

> -----Original Message-----
> From: Marc Zyngier <maz@kernel.org>
> Sent: Saturday, September 5, 2020 7:04 PM
> To: Jianyong Wu <Jianyong.Wu@arm.com>
> Cc: netdev@vger.kernel.org; yangbo.lu@nxp.com; john.stultz@linaro.org;
> tglx@linutronix.de; pbonzini@redhat.com; sean.j.christopherson@intel.com;
> richardcochran@gmail.com; Mark Rutland <Mark.Rutland@arm.com>;
> will@kernel.org; Suzuki Poulose <Suzuki.Poulose@arm.com>; Steven Price
> <Steven.Price@arm.com>; linux-kernel@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; kvmarm@lists.cs.columbia.edu;
> kvm@vger.kernel.org; Steve Capper <Steve.Capper@arm.com>; Justin He
> <Justin.He@arm.com>; nd <nd@arm.com>
> Subject: Re: [PATCH v14 07/10] arm64/kvm: Add hypercall service for kvm
> ptp.
>=20
> On Fri, 04 Sep 2020 10:27:41 +0100,
> Jianyong Wu <jianyong.wu@arm.com> wrote:
> >
> > ptp_kvm will get this service through smccc call.
> > The service offers wall time and counter cycle of host for guest.
> > caller must explicitly determines which cycle of virtual counter or
> > physical counter to return if it needs counter cycle.
> >
> > Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
> > ---
> >  arch/arm64/kvm/Kconfig       |  6 +++++
> >  arch/arm64/kvm/arch_timer.c  |  2 +-
> >  arch/arm64/kvm/hypercalls.c  | 49
> > ++++++++++++++++++++++++++++++++++++
> >  include/kvm/arm_arch_timer.h |  1 +
> >  include/linux/arm-smccc.h    | 16 ++++++++++++
> >  5 files changed, 73 insertions(+), 1 deletion(-)
> >
>=20
> [...]
>=20
> On top of what I said yesterday:
>=20
> > index 32ba6fbc3814..eb85f6701845 100644
> > --- a/arch/arm64/kvm/arch_timer.c
> > +++ b/arch/arm64/kvm/arch_timer.c
> > @@ -81,7 +81,7 @@ u64 timer_get_cval(struct arch_timer_context *ctxt)
> >  	}
> >  }
> >
> > -static u64 timer_get_offset(struct arch_timer_context *ctxt)
> > +u64 timer_get_offset(struct arch_timer_context *ctxt)
> >  {
> >  	struct kvm_vcpu *vcpu =3D ctxt->vcpu;
> >
>=20
> Why has this become global? I can't see a reason why we would want to
> expose this purely KVM internal helper.
>=20
Sorry to have forgotten remove this change.

Thanks
Jianyong=20
> 	M.
>=20
> --
> Without deviation from the norm, progress is not possible.
