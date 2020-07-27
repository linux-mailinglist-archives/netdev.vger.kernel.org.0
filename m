Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20B1E22E484
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 05:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbgG0Dpw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jul 2020 23:45:52 -0400
Received: from mail-am6eur05on2073.outbound.protection.outlook.com ([40.107.22.73]:38048
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726112AbgG0Dpv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Jul 2020 23:45:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LEQ1fmccigd/EKhvUdPNXcLeuhZrdSDq/GbhK88qvm0=;
 b=V5yI0nGhtptQKnsd7IhVC/fo9G9u8OUkcktqIQfTFws+yBU6qZW34aZvBaj1Gx06gkA/3ufQQCBPHpl2w6shgTKf1SV0cPfMf02LV7Q0SDHXXLRbLESS2qRZa5t8UT3CwkbtLybX0DJMQ7x3DaNvOQEGKKL/qNIw4IXCr+KM+ng=
Received: from DB6PR0501CA0036.eurprd05.prod.outlook.com (2603:10a6:4:67::22)
 by AM0PR08MB3875.eurprd08.prod.outlook.com (2603:10a6:208:104::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23; Mon, 27 Jul
 2020 03:45:47 +0000
Received: from DB5EUR03FT011.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:4:67:cafe::6c) by DB6PR0501CA0036.outlook.office365.com
 (2603:10a6:4:67::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.20 via Frontend
 Transport; Mon, 27 Jul 2020 03:45:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=bestguesspass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT011.mail.protection.outlook.com (10.152.20.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3216.10 via Frontend Transport; Mon, 27 Jul 2020 03:45:47 +0000
Received: ("Tessian outbound c4059ed8d7bf:v62"); Mon, 27 Jul 2020 03:45:47 +0000
X-CR-MTA-TID: 64aa7808
Received: from 90e106e78736.3
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 58FE98A4-75EE-402A-A1E7-A4481B6D32D9.1;
        Mon, 27 Jul 2020 03:45:42 +0000
Received: from EUR02-HE1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 90e106e78736.3
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Mon, 27 Jul 2020 03:45:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EbXqfGgRjHggC0xRGeJ6+205PHXLMnppkK7bgWUrTcz+060Zq1VmWXAiylgeWf4qbiRM0jrD6LqXgqfLWZ5k8N8PqiSZ4NcE0xUO/kUWGL411uwxNpkge2w90B0OL7Uk8tWzGOuCugm+ytNR+y94HlDgbpiJtAnq8VuUQrHMCSzVSUMiT3DCO1kBNHlvXBeMFItkacTo/MEcoBwJCDqJg/AdBceH0ysuos/gwEIIGyFRwThxj+XEEC6+MCyeHHOTgvDd7PX9iJGEHV2tdcyyzY+haP79xReHn7Yj0ffYoLtSG+Md+V0vXDP87PrMIW/OmIk24Ng1/tN0GMo8ZTyLog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LEQ1fmccigd/EKhvUdPNXcLeuhZrdSDq/GbhK88qvm0=;
 b=C/i6XOXE02DohjwK+iwKj5XtV3lz9qGMaxvmtJt7APkBXTv+wAwG7TUccuRYcVzMifk1JfGcfBoCZzUEUskygEJHiKnDHFuRbFpOaG4LdCnFzaqDF5x41t0UtOyO6sk5I20aBtCizFgjBdRELG2Q+urVwEgevaZyc9Jo82dFhowM2p4jqhVwguGa1xBQF9/yvxT3SEs3Jr8cm+vtc51yZ4WYw5XermelQQP5pStk0kahJVdArTb0ih6Q5pnf0deZS46fkoBncUo9n2axtrDQ6/u4eI5fApfhNTwbl+merIPL7uETVRhriPqTfYZpht9Jd4uon9A64owjE57T9CPveA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LEQ1fmccigd/EKhvUdPNXcLeuhZrdSDq/GbhK88qvm0=;
 b=V5yI0nGhtptQKnsd7IhVC/fo9G9u8OUkcktqIQfTFws+yBU6qZW34aZvBaj1Gx06gkA/3ufQQCBPHpl2w6shgTKf1SV0cPfMf02LV7Q0SDHXXLRbLESS2qRZa5t8UT3CwkbtLybX0DJMQ7x3DaNvOQEGKKL/qNIw4IXCr+KM+ng=
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com (2603:10a6:3:e0::7)
 by HE1PR08MB2825.eurprd08.prod.outlook.com (2603:10a6:7:35::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.22; Mon, 27 Jul
 2020 03:45:38 +0000
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::9:c111:edc1:d65a]) by HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::9:c111:edc1:d65a%6]) with mapi id 15.20.3216.033; Mon, 27 Jul 2020
 03:45:38 +0000
From:   Jianyong Wu <Jianyong.Wu@arm.com>
To:     Jianyong Wu <Jianyong.Wu@arm.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
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
        Steven Price <Steven.Price@arm.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
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
Thread-Index: AQHWRjnTCp2aKUWCLkK9Y7ZKWPQzQKka//qw
Date:   Mon, 27 Jul 2020 03:45:37 +0000
Message-ID: <HE1PR0802MB255577943C260898A6C686ABF4720@HE1PR0802MB2555.eurprd08.prod.outlook.com>
References: <20200619130120.40556-1-jianyong.wu@arm.com>
 <20200619130120.40556-3-jianyong.wu@arm.com>
In-Reply-To: <20200619130120.40556-3-jianyong.wu@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: d6719f89-de16-48fd-8ed7-b913cb3ead80.1
x-checkrecipientchecked: true
Authentication-Results-Original: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
x-originating-ip: [203.126.0.111]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 51af273b-e195-4a2f-5dbd-08d831df8c4d
x-ms-traffictypediagnostic: HE1PR08MB2825:|AM0PR08MB3875:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <AM0PR08MB3875BE8BA45C838734D8ECF2F4720@AM0PR08MB3875.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:8882;OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: XDqt/J4uIemQjxLaYbQIyK5PMbmTHtTtDFL8gIxg1MmCr7pdMDJO6bSnuWdbgXak+szQg/pAeKSnMvmbzO283Z9JI0rItJJKi/M6uW0EaqTO6MhB4GUoz8YQIs20p+eNN+Cp6aRCJOrDJCyeP/GXNqSRO+wrMnj1tPj67ywUu6vsZ6V7TyoCZNuBl5XAv7BDsa8Qzscm5RczbsQA8tgk2qska6/MmtfgwHKwRW+daU9joUJbF54vEWTmo0UAWdVUob1e66NmfoV0tIu0H06QIU7ri64Y/E1hnNBULiI8CGGId/9W7YU2jwqjhfKzhc44gX4v7QJrBaAAbv5DXymmPB6ZHxvDsciw2O5XDUWptMGgElXfR7KNbqJb8jJIuJNW
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0802MB2555.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(346002)(396003)(39850400004)(376002)(136003)(52536014)(76116006)(6636002)(66946007)(110136005)(54906003)(86362001)(316002)(478600001)(71200400001)(8676002)(26005)(8936002)(186003)(9686003)(2906002)(55016002)(33656002)(83380400001)(7416002)(66476007)(64756008)(66556008)(53546011)(6506007)(66446008)(4326008)(5660300002)(7696005)(921003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 9iLzsfxb0jk16hLiT/+ZMmaDcyB8wTpfEX8jRzneh+kAj06z6iOiwv1jSsK/Uo84eLcIAXgrhYqHsv6DUiUAc5jJ9FtJVNta52+QX+eljqu59Jdu72UnM4kQ+wIi+0bMyBnqbu+wNnLf6Nz6I0lQy2sWH9ntlOz/xDWGERlE3d/eih63XCec47UaGwUYuxMhS7vi45lm6z/VeMnUEFlWDU3e0mK3myXA84TzmzWwCoEYEyYlf1C1tyxe6GN1K8VfZqAppPmV8s+KFq5JkvR+L8KAE4vhQgOpu4OYE2WlqtLZq0BqrHkPISrDzMAHcXP+toM1Q2hcgyrycMk62PvwLD9G6Jd5d3Tu7m/f2GFePJ5KNrLXpLPFsCxuRjOlMISOddIdH6yLy3LN41RaMEwkX0s7m+ObXJs0fFSf37VFxCEcrumK40ty7FASN+srWwgrWxT6tAbstJki/18PA7P6ieiT/LDbUncQ9wVlzQ187jA=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR08MB2825
Original-Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT011.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: 66de0f24-c9e1-465d-a09d-08d831df86b0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Wuu91IOFXMkaNmEgA819t2IghfKsVH59vtQ5ZBeiOG55DZNo6s+05/eZ5cgif6Sbpfm5zPtph6fMnfuFeNAQsXwc8gAioZ9SNirUYIcRKDjNgOY/EWdPtLCllfbifzd222zuSwgFKqHofTOBTHd1Sg3/cPCjetsLwdwtp99lGCfvAvDfiJibqp/PrU5DCTw5Ry6rZlbxBbQdVZZBmeVTIAJXa76DHxKrvbWDvt3yMpdL8e2ypIsFV4DHD10m2kzG5paBXj7ll4076g8BtKpcq/v8ccBvZxZWFb6Rfg9Arhl6av50veeGuzy/KXCFDECy3otN+W7NJpglYrLW7GXhT0JhgQkJFQtj4fT7o01dsD75d9EayQtVIAstnvvsgO13fGHf9gRNT9brUKmPw0xppqr8780rXFQQKHQxtrPRGqU=
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39850400004)(376002)(346002)(396003)(46966005)(316002)(336012)(8676002)(450100002)(478600001)(6636002)(70586007)(4326008)(70206006)(82740400003)(82310400002)(356005)(2906002)(81166007)(9686003)(110136005)(8936002)(52536014)(86362001)(54906003)(33656002)(186003)(47076004)(83380400001)(53546011)(55016002)(6506007)(26005)(5660300002)(7696005)(921003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2020 03:45:47.4153
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 51af273b-e195-4a2f-5dbd-08d831df8c4d
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: DB5EUR03FT011.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB3875
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Will,

> -----Original Message-----
> From: Jianyong Wu <jianyong.wu@arm.com>
> Sent: Friday, June 19, 2020 9:01 PM
> To: netdev@vger.kernel.org; yangbo.lu@nxp.com; john.stultz@linaro.org;
> tglx@linutronix.de; pbonzini@redhat.com; sean.j.christopherson@intel.com;
> maz@kernel.org; richardcochran@gmail.com; Mark Rutland
> <Mark.Rutland@arm.com>; will@kernel.org; Suzuki Poulose
> <Suzuki.Poulose@arm.com>; Steven Price <Steven.Price@arm.com>
> Cc: linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org;
> kvmarm@lists.cs.columbia.edu; kvm@vger.kernel.org; Steve Capper
> <Steve.Capper@arm.com>; Kaly Xin <Kaly.Xin@arm.com>; Justin He
> <Justin.He@arm.com>; Wei Chen <Wei.Chen@arm.com>; Jianyong Wu
> <Jianyong.Wu@arm.com>; nd <nd@arm.com>
> Subject: [PATCH v13 2/9] arm/arm64: KVM: Advertise KVM UID to guests via
> SMCCC
>=20
> From: Will Deacon <will@kernel.org>
>=20
> We can advertise ourselves to guests as KVM and provide a basic features
> bitmap for discoverability of future hypervisor services.
>=20
> Cc: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Will Deacon <will@kernel.org>
> Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
> ---
>  arch/arm64/kvm/hypercalls.c | 29 +++++++++++++++++++----------
>  1 file changed, 19 insertions(+), 10 deletions(-)
>=20
> diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
> index 550dfa3e53cd..db6dce3d0e23 100644
> --- a/arch/arm64/kvm/hypercalls.c
> +++ b/arch/arm64/kvm/hypercalls.c
> @@ -12,13 +12,13 @@
>  int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)  {
>  	u32 func_id =3D smccc_get_function(vcpu);
> -	long val =3D SMCCC_RET_NOT_SUPPORTED;
> +	u32 val[4] =3D {SMCCC_RET_NOT_SUPPORTED};

There is a risk as this u32 value will return here and a u64 value will be =
obtained in guest. For example,
The val[0] is initialized as -1 of 0xffffffff and the guest get 0xffffffff =
then it will be compared with -1 of 0xffffffffffffffff
Also this problem exists for the transfer of address in u64 type. So the fo=
llowing assignment to "val" should be split into
two u32 value and assign to val[0] and val[1] respectively.
WDYT?

Thanks
Jianyong=20

>  	u32 feature;
>  	gpa_t gpa;
>=20
>  	switch (func_id) {
>  	case ARM_SMCCC_VERSION_FUNC_ID:
> -		val =3D ARM_SMCCC_VERSION_1_1;
> +		val[0] =3D ARM_SMCCC_VERSION_1_1;
>  		break;
>  	case ARM_SMCCC_ARCH_FEATURES_FUNC_ID:
>  		feature =3D smccc_get_arg1(vcpu);
> @@ -28,10 +28,10 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
>  			case KVM_BP_HARDEN_UNKNOWN:
>  				break;
>  			case KVM_BP_HARDEN_WA_NEEDED:
> -				val =3D SMCCC_RET_SUCCESS;
> +				val[0] =3D SMCCC_RET_SUCCESS;
>  				break;
>  			case KVM_BP_HARDEN_NOT_REQUIRED:
> -				val =3D SMCCC_RET_NOT_REQUIRED;
> +				val[0] =3D SMCCC_RET_NOT_REQUIRED;
>  				break;
>  			}
>  			break;
> @@ -41,31 +41,40 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
>  			case KVM_SSBD_UNKNOWN:
>  				break;
>  			case KVM_SSBD_KERNEL:
> -				val =3D SMCCC_RET_SUCCESS;
> +				val[0] =3D SMCCC_RET_SUCCESS;
>  				break;
>  			case KVM_SSBD_FORCE_ENABLE:
>  			case KVM_SSBD_MITIGATED:
> -				val =3D SMCCC_RET_NOT_REQUIRED;
> +				val[0] =3D SMCCC_RET_NOT_REQUIRED;
>  				break;
>  			}
>  			break;
>  		case ARM_SMCCC_HV_PV_TIME_FEATURES:
> -			val =3D SMCCC_RET_SUCCESS;
> +			val[0] =3D SMCCC_RET_SUCCESS;
>  			break;
>  		}
>  		break;
>  	case ARM_SMCCC_HV_PV_TIME_FEATURES:
> -		val =3D kvm_hypercall_pv_features(vcpu);
> +		val[0] =3D kvm_hypercall_pv_features(vcpu);
>  		break;
>  	case ARM_SMCCC_HV_PV_TIME_ST:
>  		gpa =3D kvm_init_stolen_time(vcpu);
>  		if (gpa !=3D GPA_INVALID)
> -			val =3D gpa;
> +			val[0] =3D gpa;
> +		break;
> +	case ARM_SMCCC_VENDOR_HYP_CALL_UID_FUNC_ID:
> +		val[0] =3D ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_0;
> +		val[1] =3D ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_1;
> +		val[2] =3D ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_2;
> +		val[3] =3D ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_3;
> +		break;
> +	case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
> +		val[0] =3D BIT(ARM_SMCCC_KVM_FUNC_FEATURES);
>  		break;
>  	default:
>  		return kvm_psci_call(vcpu);
>  	}
>=20
> -	smccc_set_retval(vcpu, val, 0, 0, 0);
> +	smccc_set_retval(vcpu, val[0], val[1], val[2], val[3]);
>  	return 1;
>  }
> --
> 2.17.1

