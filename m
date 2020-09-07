Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B511425F769
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 12:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728491AbgIGKLs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 06:11:48 -0400
Received: from mail-am6eur05on2087.outbound.protection.outlook.com ([40.107.22.87]:37760
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728400AbgIGKLr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 06:11:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vvzw5DhaKrGwAtB8KKuKhk66j1wAgDbGFCqeFtR93TA=;
 b=3vyRu4LrPoXZrJXlpJmbtJPVyXa0+B3ovZ586c+D21aXpC0aqNfoJd2AI3d5hIXwzduvr+TL6fCwqNCgGcfqlZ6JtlKh5x6Hh2NaGBZXShKmL4q02GxpZpDoKtCvZEivTcoTqi9mHApcuqBNkeIwpFlHv52LgCuiy5IqufSGusg=
Received: from AM7PR02CA0004.eurprd02.prod.outlook.com (2603:10a6:20b:100::14)
 by HE1PR0802MB2572.eurprd08.prod.outlook.com (2603:10a6:3:db::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15; Mon, 7 Sep
 2020 10:11:41 +0000
Received: from VE1EUR03FT034.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:20b:100:cafe::17) by AM7PR02CA0004.outlook.office365.com
 (2603:10a6:20b:100::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15 via Frontend
 Transport; Mon, 7 Sep 2020 10:11:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=bestguesspass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT034.mail.protection.outlook.com (10.152.18.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3348.16 via Frontend Transport; Mon, 7 Sep 2020 10:11:40 +0000
Received: ("Tessian outbound e8cdb8c6f386:v64"); Mon, 07 Sep 2020 10:11:40 +0000
X-CR-MTA-TID: 64aa7808
Received: from 8898891310c6.2
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id DFF1148A-ECE5-4434-AB08-59DBF40F3874.1;
        Mon, 07 Sep 2020 10:11:35 +0000
Received: from EUR01-VE1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 8898891310c6.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Mon, 07 Sep 2020 10:11:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gb4ZrTmuDaPW7xZoQmi2zDtIEiOTQggZXebilw0U1SvsaJ/HHH8F1e6GrMguokwPdJqJK+/zEwvudUU66/QyulvmqBosK7bsxqJ9zbT5aC+OOTv9Ybrf4zFOnLcQ2jpYrFpgpSMoK/iwFdbhTxB4gMK1Q/QQL7wpgo5PzaGqR44KGcM4686aP0VuE6jLYHNbNeofbWV03gKqVEZeadyWWButfld5F01z+72dtUYruLJLYTuXeLla+ZmzzcssO27YrHvNqBALk5x8mBqEUrno7YVX4EUn4Yu3dNRJ8ipkTukMRQ3XvJ3oOvA0icI1POQdYuUbG48JiHdXeIDshaX8AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vvzw5DhaKrGwAtB8KKuKhk66j1wAgDbGFCqeFtR93TA=;
 b=HNG0r5rjPai/ui7ULeKtwnvKpRza9o9HpGL+oEq3iBGBYcI9kCsDUIOk27OIpH3CXoNm63pW4Rd4LFy88dVCQwaFD47tEmsNE4o/oy6vtYAz893o2ZNah5pU0GNDsEcRq4q5QI4yBkKjvwHkwZltcyZnmo4eu+LHghV/W0aZ8XCK7JIDqUj1Vb9EKVMym0qWyjWylhT027WzHXVV+1Um2uttKCWinfpaSQeJAuIXR8jyb1f3rCMiXOhTwCWFueYfi7i8WU1gewZvpfyMNj0y5qtl/Kj1O3V9iEL06SHHhW48zwnPDCK9sYe33nTD0TSQXz1PpipLybeydRPOiS79pQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vvzw5DhaKrGwAtB8KKuKhk66j1wAgDbGFCqeFtR93TA=;
 b=3vyRu4LrPoXZrJXlpJmbtJPVyXa0+B3ovZ586c+D21aXpC0aqNfoJd2AI3d5hIXwzduvr+TL6fCwqNCgGcfqlZ6JtlKh5x6Hh2NaGBZXShKmL4q02GxpZpDoKtCvZEivTcoTqi9mHApcuqBNkeIwpFlHv52LgCuiy5IqufSGusg=
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com (2603:10a6:3:e0::7)
 by HE1PR0802MB2556.eurprd08.prod.outlook.com (2603:10a6:3:e1::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15; Mon, 7 Sep
 2020 10:11:32 +0000
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::74f7:5759:4e9e:6e00]) by HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::74f7:5759:4e9e:6e00%5]) with mapi id 15.20.3348.019; Mon, 7 Sep 2020
 10:11:32 +0000
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
Subject: RE: [PATCH v14 08/10] ptp: arm64: Enable ptp_kvm for arm64
Thread-Topic: [PATCH v14 08/10] ptp: arm64: Enable ptp_kvm for arm64
Thread-Index: AQHWgp4Q48WtGxJp4kuFSJTL6o01LqlZ4qMAgAL3/tCAAAlCgIAABDCQgAAKXICAAAXbMA==
Date:   Mon, 7 Sep 2020 10:11:31 +0000
Message-ID: <HE1PR0802MB25551E16B77F968412E2D456F4280@HE1PR0802MB2555.eurprd08.prod.outlook.com>
References: <20200904092744.167655-1-jianyong.wu@arm.com>
 <20200904092744.167655-9-jianyong.wu@arm.com> <874kocmqqx.wl-maz@kernel.org>
 <HE1PR0802MB2555CC56351616836A95FB19F4280@HE1PR0802MB2555.eurprd08.prod.outlook.com>
 <366387fa507f9c5d5044549cea958ce1@kernel.org>
 <HE1PR0802MB25551446DC85DB3684D09211F4280@HE1PR0802MB2555.eurprd08.prod.outlook.com>
 <67f3381467d02c8d3f25682cd99898e9@kernel.org>
In-Reply-To: <67f3381467d02c8d3f25682cd99898e9@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: B5C9977602E0B848B1A8C8F7B329373C.0
x-checkrecipientchecked: true
Authentication-Results-Original: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
x-originating-ip: [203.126.0.111]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ece71d9d-5e80-4c94-95ee-08d853166a40
x-ms-traffictypediagnostic: HE1PR0802MB2556:|HE1PR0802MB2572:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <HE1PR0802MB257215EAE6AC21F514D86823F4280@HE1PR0802MB2572.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:97;OLM:97;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: O1Wy0JjDZD1moM4VTdp+QMXxhuOoV/dzGKt2Eue7xzwvnAGesOGlpOuToQ9L5rwaElVfYJKf9+JBtGhMHN1V9r4O3Q4vcz5bXvmy98iKHlmzH/zSo7ibQfRmVGbPtI96aJDRwma4Wt/HQQJ1XURC2Q0GK4tBszv+ZeGy6scWuGtM4eOLin2L00FoNYtV97K0HnlAmHpBs7ISIdxVZq+OOvVBq1r/5IOSUuOCgsem/vxutauuKbeYfBHPpv6ka9yzU3ZhjULf28OnN06okrH9RjA0+2qcAhZFvAQ19dNNpA+sXFYVF7vC3YWdpFVW6oHh6lmVFKZno1kRkvXaVNOJEQ==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0802MB2555.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(366004)(376002)(346002)(136003)(86362001)(66446008)(478600001)(64756008)(66556008)(66946007)(66476007)(52536014)(76116006)(7416002)(6916009)(53546011)(83380400001)(71200400001)(6506007)(5660300002)(8676002)(316002)(54906003)(8936002)(4326008)(55016002)(33656002)(9686003)(186003)(26005)(7696005)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: vP2VINxfpSa+OUVIIK+3tV7saqH8rWvKNYVJ298y8fKZv+fju6VHrxehV26C1DrNHbPTgBkYGvOps6pNI4MUxWFW7ZnigG3uahJI5LZBTuZpLeLwZVdvSFtHkoTMx1SUYNZ5MthkjRhYwBSUfkT03Vce/pULvYXPIW/Rbn9fmjpqyTWsskSpHOREnRvKLgZAHU1VIBnV96tDqaSg0sB5AGGKlktRIIK63d7j8tjnp38r08LlaLwJI4f0FHHp6iE2bZiXvwbFFXWw+LvCSW5Svi5bfbwAO2yN0CgjDHqzvHVO2ppqEJrIkXHB+Zt2SfHabSA3LkZLz/gn+iUMeO+vyqRKv99EEOZYs01wsZ081XtlGyuDGp7VtLLCmW8+9kc8HBi+9O44r6EXKQYrxNseg+Pni8k99drwVwtO1ks+dDWRXb+Z/FtpM6qJ4k6MI79+FYvLuNmF4JfUvKBKFmaVURey9RmnhpEH6WQW23FL8nbzA+GaB1sPFhteY0N6Y2Mr0q8j1f5Uf96ov1SMK5CkrtmGDDyHDjZUsvFS9cq0AneSD5ZzkSwfwEcy5awan/+EOUwYvrVQGHunWIVJjDO/kU8He5aSB+Ae38h/Ef6mx0dvFpvCczRxKnB1l4Sa6dMfwhi/sedDGpamZuQ5MLM4Gg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0802MB2556
Original-Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT034.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: 3c78c92b-c022-4d5a-75df-08d853166509
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YuvB9wnoOIxvutWmudMn37TrmVkCHPQu8HZVpYZGV8l1QQU2GKMqW9NwV+kDslU9fnvEu98J1VDNv+iq1DmzzswvvjzBSzS1y1KGfigl6KIB3YOQ048/HLsfL1UchpjPGPoJiCfZ4xQz+Qjxi0bjDt7DIj1ZW1IU9YCDB3GuITrmuCu2bu2mjbHDyp8kKYP5l/YXx0fNJUAt1+K0XyB6Lkd2GFHARp6jdAA8LIIZBNIzJzeDRofcsyXGptbWDbyufRzhtgLsxIj8u/PibJmcLdIRn/iP9bp9zh2xIO9iKVcdl7Qc9Qvx81IpbjAZHiWWtTQBpqKdlHRWgJ5tvXF56XsTJcOUEOA73Tb8deZRWOfi7Ix1uVthnJFfiJ3+JGq9utKzJBwNbOj3TIaJfQ8BpQ==
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(396003)(39860400002)(46966005)(26005)(5660300002)(47076004)(82740400003)(52536014)(86362001)(478600001)(4326008)(36906005)(450100002)(54906003)(33656002)(6862004)(70206006)(82310400003)(316002)(2906002)(8936002)(55016002)(83380400001)(336012)(7696005)(9686003)(53546011)(186003)(6506007)(8676002)(81166007)(70586007)(356005);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2020 10:11:40.7609
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ece71d9d-5e80-4c94-95ee-08d853166a40
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: VE1EUR03FT034.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0802MB2572
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Marc Zyngier <maz@kernel.org>
> Sent: Monday, September 7, 2020 5:47 PM
> To: Jianyong Wu <Jianyong.Wu@arm.com>
> Cc: netdev@vger.kernel.org; yangbo.lu@nxp.com; john.stultz@linaro.org;
> tglx@linutronix.de; pbonzini@redhat.com; sean.j.christopherson@intel.com;
> richardcochran@gmail.com; Mark Rutland <Mark.Rutland@arm.com>;
> will@kernel.org; Suzuki Poulose <Suzuki.Poulose@arm.com>; Steven Price
> <Steven.Price@arm.com>; linux-kernel@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; kvmarm@lists.cs.columbia.edu;
> kvm@vger.kernel.org; Steve Capper <Steve.Capper@arm.com>; Justin He
> <Justin.He@arm.com>; nd <nd@arm.com>
> Subject: Re: [PATCH v14 08/10] ptp: arm64: Enable ptp_kvm for arm64
>=20
> On 2020-09-07 10:28, Jianyong Wu wrote:
> >> -----Original Message-----
> >> From: Marc Zyngier <maz@kernel.org>
> >> Sent: Monday, September 7, 2020 4:55 PM
> >> To: Jianyong Wu <Jianyong.Wu@arm.com>
>=20
> [...]
>=20
> >> >> 	arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_FEATUR
> >> >> ES_FUNC_ID,
> >> >> > +			     &hvc_res);
> >> >> > +	if (!(hvc_res.a0 | BIT(ARM_SMCCC_KVM_FUNC_KVM_PTP)))
> >> >> > +		return -EOPNOTSUPP;
> >> >> > +
> >> >> > +	return 0;
> >> >>
> >> >> What happens if the
> >> >> ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID function isn't
> >> implemented
> >> >> (on an old kernel or a non-KVM hypervisor)? The expected behaviour
> >> >> is that a0 will contain SMCCC_RET_NOT_SUPPORTED, which is -1.
> >> >> The result is that this function always returns "supported". Not
> >> >> an acceptable behaviour.
> >> >>
> >> > Oh!  it's really a stupid mistake, should be "&" not "|".
> >>
> >> But even then. (-1 & whatever) is always true.
> >
> > Yeah, what about checking if a0 is non-negative first? Like:
> > if (hvc_res.a0 < 0 || !(hvc_res.a0 &
> BIT(ARM_SMCCC_KVM_FUNC_KVM_PTP)))
> > 	return -EOPNOTSUPP;
>=20
> I don't get it. You already carry a patch from Will that gives you a way =
to check
> for a service (kvm_arm_hyp_service_available()).
>=20
> Why do you need to reinvent the wheel?

Sorry, I should have changed this code according to Will's patch. Thanks fo=
r reminder!

Thanks
jianyong
>=20
>          M.
> --
> Jazz is not dead. It just smells funny...
