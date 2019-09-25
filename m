Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBDD3BDC2D
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 12:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389863AbfIYK2X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 06:28:23 -0400
Received: from mail-eopbgr50081.outbound.protection.outlook.com ([40.107.5.81]:61821
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729862AbfIYK2W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Sep 2019 06:28:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KAjTpao5+0Hp/Juoc9CQrR6WLEqdnvSOeoD9jc22Qyc=;
 b=y9UYUhhLb8DtBCHt1wkA8aYxaxwpHM3tlEKppNDExJ6h/d8q9DGXczDGurqNzSf1gKBnDgsMrph5+f50+rQ3QJrIzx2cJfA+GDS0WpnxNgOERtLRIf8pfC1O7cB5HYX42pLrZP76qhnSFh9bkJCKPZjlHR04C1zugZgPYUwtyMA=
Received: from DB7PR08CA0039.eurprd08.prod.outlook.com (2603:10a6:10:26::16)
 by AM0PR08MB3570.eurprd08.prod.outlook.com (2603:10a6:208:e0::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2284.26; Wed, 25 Sep
 2019 10:28:11 +0000
Received: from AM5EUR03FT018.eop-EUR03.prod.protection.outlook.com
 (2a01:111:f400:7e08::201) by DB7PR08CA0039.outlook.office365.com
 (2603:10a6:10:26::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2284.20 via Frontend
 Transport; Wed, 25 Sep 2019 10:28:11 +0000
Authentication-Results: spf=temperror (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=none action=none
 header.from=arm.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of arm.com: DNS Timeout)
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM5EUR03FT018.mail.protection.outlook.com (10.152.16.114) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.25 via Frontend Transport; Wed, 25 Sep 2019 10:28:10 +0000
Received: ("Tessian outbound 927f2cdd66cc:v33"); Wed, 25 Sep 2019 10:28:07 +0000
X-CR-MTA-TID: 64aa7808
Received: from 4e352b48b49a.2 (ip-172-16-0-2.eu-west-1.compute.internal [104.47.8.57])
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 59D1CCE6-F83D-4F1C-960C-F7CCB0E36958.1;
        Wed, 25 Sep 2019 10:28:02 +0000
Received: from EUR03-AM5-obe.outbound.protection.outlook.com (mail-am5eur03lp2057.outbound.protection.outlook.com [104.47.8.57])
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 4e352b48b49a.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Wed, 25 Sep 2019 10:28:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a2IL33rmRiC4srH3uBFua9Pi2/Vb2Y0Hu8JZ/i9U6Hnq4RsoEQMRnXz0SXRF3vhuAUU8Q/RWl0GSpDYG+CBpU9RLZoaPUanPaUfSlwZ9sNiLCE5W9decYIMrKb39+Rzw+n97u5ITv159MUME9tyoECrWPClB6PYNB5+i3ab/iD+kIpabshE10XX3N6BYZNhsXFEKlHGxA61edyvVmzK0t5XxG8itVUIiPCLhymv1kd590VBoFIg8GNoI+s9ZDCQV/s59xY6en0crp1NG7mdv++E4pppKFfDAodxLUVR2ePyd9o5BZwbhvvYyPk1fqgGxEr0xoqz9jLRqI/QCioC5gA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KAjTpao5+0Hp/Juoc9CQrR6WLEqdnvSOeoD9jc22Qyc=;
 b=RjqOMSZoJ2/U+oqONSYXc9yrchvDRk52Ln4pY4VhnEq6P6FjsXQm21KtauSZ+9eWGaizC4SbaaR5nAl2nXUNo3UURgNd7hTJSiiXx81l+teE8T2IMtntdYVPNtdTlfKSGRQfdPjC8XjhO4VeL0K6XOBarZpo8Ff9E+jZW8dkZ7oPi86Ps062EMt9VNAVO47tD1iIZaVGMThIrOvmj08TbNdZY+vAif+y9Krg2yB9npQXBxgTJDlYSlv0A4m48e7YYVTkQXBNc6q6kTIjwWDWVqluJi3uvh1GKBAkPrpmrsrOAlZdQAhyHWvNGN6tP/OiSj46HEl3SwsAC8Ul27stXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KAjTpao5+0Hp/Juoc9CQrR6WLEqdnvSOeoD9jc22Qyc=;
 b=y9UYUhhLb8DtBCHt1wkA8aYxaxwpHM3tlEKppNDExJ6h/d8q9DGXczDGurqNzSf1gKBnDgsMrph5+f50+rQ3QJrIzx2cJfA+GDS0WpnxNgOERtLRIf8pfC1O7cB5HYX42pLrZP76qhnSFh9bkJCKPZjlHR04C1zugZgPYUwtyMA=
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com (10.168.146.150) by
 HE1PR0801MB1932.eurprd08.prod.outlook.com (10.168.94.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.25; Wed, 25 Sep 2019 10:27:59 +0000
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::4d35:2b8f:1786:84cd]) by HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::4d35:2b8f:1786:84cd%3]) with mapi id 15.20.2284.023; Wed, 25 Sep 2019
 10:27:58 +0000
From:   "Jianyong Wu (Arm Technology China)" <Jianyong.Wu@arm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "yangbo.lu@nxp.com" <yangbo.lu@nxp.com>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Suzuki Poulose <Suzuki.Poulose@arm.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Steve Capper <Steve.Capper@arm.com>,
        "Kaly Xin (Arm Technology China)" <Kaly.Xin@arm.com>,
        "Justin He (Arm Technology China)" <Justin.He@arm.com>,
        nd <nd@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: RE: [RFC PATCH v3 4/6] psci: Add hvc call service for ptp_kvm.
Thread-Topic: [RFC PATCH v3 4/6] psci: Add hvc call service for ptp_kvm.
Thread-Index: AQHVbfg5HjMQ+p5UhEyfzqBy9sDEZacxGVuAgAAQMICAABDUgIABdZhAgAAo7ACABcbzoIACSpYAgAFMRoA=
Date:   Wed, 25 Sep 2019 10:27:58 +0000
Message-ID: <HE1PR0801MB1676F76AE58C379A9E9006C0F4870@HE1PR0801MB1676.eurprd08.prod.outlook.com>
References: <20190918080716.64242-1-jianyong.wu@arm.com>
 <20190918080716.64242-5-jianyong.wu@arm.com>
 <83ed7fac-277f-a31e-af37-8ec134f39d26@redhat.com>
 <HE1PR0801MB1676F57B317AE85E3B934B32F48E0@HE1PR0801MB1676.eurprd08.prod.outlook.com>
 <629538ea-13fb-e666-8df6-8ad23f114755@redhat.com>
 <HE1PR0801MB167639E2F025998058A77F86F4890@HE1PR0801MB1676.eurprd08.prod.outlook.com>
 <ef6ab8bd-41ad-88f8-9cfd-dc749ca65310@redhat.com>
 <HE1PR0801MB1676A9D4A58118144F5C7B54F4850@HE1PR0801MB1676.eurprd08.prod.outlook.com>
 <06264d8a-b9c0-5f19-db2c-6190976a2a05@redhat.com>
In-Reply-To: <06264d8a-b9c0-5f19-db2c-6190976a2a05@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: fb9f5950-c99b-469f-90d3-cec3667f6fbc.1
x-checkrecipientchecked: true
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
x-originating-ip: [113.29.88.7]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-Correlation-Id: 7cca2eda-4769-490c-b4bc-08d741a31012
X-MS-Office365-Filtering-HT: Tenant
X-Microsoft-Antispam-Untrusted: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600167)(711020)(4605104)(1401327)(4618075)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:HE1PR0801MB1932;
X-MS-TrafficTypeDiagnostic: HE1PR0801MB1932:|HE1PR0801MB1932:|AM0PR08MB3570:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <AM0PR08MB35708CD6E77E2C51D70B841EF4870@AM0PR08MB3570.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
x-ms-oob-tlc-oobclassifiers: OLM:10000;OLM:10000;
x-forefront-prvs: 01713B2841
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(396003)(136003)(366004)(346002)(199004)(13464003)(189003)(64756008)(74316002)(9686003)(3846002)(2201001)(81156014)(81166006)(7416002)(8676002)(6436002)(446003)(2906002)(71200400001)(71190400001)(54906003)(11346002)(66066001)(6116002)(6506007)(55016002)(316002)(26005)(186003)(66476007)(33656002)(66446008)(305945005)(476003)(2501003)(102836004)(86362001)(52536014)(76116006)(55236004)(4326008)(110136005)(76176011)(5660300002)(256004)(7696005)(14454004)(486006)(66946007)(14444005)(6636002)(99286004)(53546011)(7736002)(8936002)(25786009)(6246003)(229853002)(66556008)(478600001)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR0801MB1932;H:HE1PR0801MB1676.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info-Original: MO+cEpXAsLLWMbJxuzjFb0IPGLpGXoEJEskpAne7HzjeBylFCISZyglD+HVOspPPxjbp53e4URBKyem8c+CTXI+b1xUCbPXESljcXmaeZOvqJI/PXj3C7sCGH8+E1dtM0qNYD+c6yWS5UVRg6+R94bRB26Qd3lifbioOdaNNzqQ/1dHN31jXmT1qcqysJ0QkMds1O4VIM92QysY3Po0Clt4MIRFnYWlHGcWp7NfAcOSjV3kUq/j64iTiov1h91ZEvce86hFEcNAqIQkbDSnXS+KsCR41GUQ4T+pCp+u5y3ITEBZ65IZl++AfkPPZTT5FIS0HtHjs8m1khVlVDhmHQw27CIx/vLTY0AWEEE5ZysG8pTmzRDVpxr8/xZcaEolbSBaXSf9nmO9zAxpDBDYAFULMrtX3gyTBjvvUOJeuBL4=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0801MB1932
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM5EUR03FT018.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;IPV:CAL;SCL:-1;CTRY:IE;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(39860400002)(346002)(376002)(13464003)(199004)(189003)(2201001)(2501003)(23676004)(99286004)(7696005)(33656002)(5660300002)(6506007)(76176011)(86362001)(102836004)(6116002)(3846002)(2486003)(186003)(81156014)(26005)(70206006)(81166006)(8676002)(70586007)(53546011)(76130400001)(2906002)(446003)(52536014)(486006)(336012)(9686003)(6246003)(63350400001)(436003)(126002)(476003)(26826003)(36906005)(4326008)(74316002)(110136005)(14454004)(6636002)(54906003)(8936002)(11346002)(55016002)(7736002)(316002)(450100002)(25786009)(305945005)(356004)(22756006)(47776003)(478600001)(14444005)(50466002)(66066001)(229853002)(107886003)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR08MB3570;H:64aa7808-outbound-1.mta.getcheckrecipient.com;FPR:;SPF:TempError;LANG:en;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;A:1;MX:1;
X-MS-Office365-Filtering-Correlation-Id-Prvs: d424805f-e3ea-42f8-026e-08d741a30969
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600167)(710020)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM0PR08MB3570;
NoDisclaimer: True
X-Forefront-PRVS: 01713B2841
X-Microsoft-Antispam-Message-Info: Agysp7Wy13GMV585muGwuu+AhLtzOvLlMR+/8TfipbqOdjVds6hkJadZXxkWKajCPz7zX16W9n/zSqlMJ42nmsDy+KqPAD6r0rxBfMEnO+1LvRoJ8gnSfuJnjHv8h5RzRzpWPUdthunHr80UCDS4A5GmNCCV7cxoBNh10JSrQDMQscdHYrilQWAsXFh0RcodnZo6Y+GPnGOGc+8UT3IuBKzSgFzkOKKZ016Wph8m0y52wlUnhltl1Xl6S45Zj4p/8Xh7ETomGocv3hoZ482lCI4Ks3328eJczC2fjvVGqTS7Bi+Ap6/+c2cxL6mpJAPdJ2gPTKw3d+vq4irkuBzY/3RvX27f6jsmQLj/FSzI04CTX5UjY6HfGKBPJvbvdK/VpvMDxf2EgZj7Dv/8jN/ihRsQuyobI+bYs41BrJkS+cg=
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2019 10:28:10.0429
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cca2eda-4769-490c-b4bc-08d741a31012
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB3570
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgUGFvbG8sDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogUGFvbG8g
Qm9uemluaSA8cGJvbnppbmlAcmVkaGF0LmNvbT4NCj4gU2VudDogVHVlc2RheSwgU2VwdGVtYmVy
IDI0LCAyMDE5IDEwOjIwIFBNDQo+IFRvOiBKaWFueW9uZyBXdSAoQXJtIFRlY2hub2xvZ3kgQ2hp
bmEpIDxKaWFueW9uZy5XdUBhcm0uY29tPjsNCj4gbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgeWFu
Z2JvLmx1QG54cC5jb207IGpvaG4uc3R1bHR6QGxpbmFyby5vcmc7DQo+IHRnbHhAbGludXRyb25p
eC5kZTsgc2Vhbi5qLmNocmlzdG9waGVyc29uQGludGVsLmNvbTsgbWF6QGtlcm5lbC5vcmc7DQo+
IHJpY2hhcmRjb2NocmFuQGdtYWlsLmNvbTsgTWFyayBSdXRsYW5kIDxNYXJrLlJ1dGxhbmRAYXJt
LmNvbT47IFdpbGwNCj4gRGVhY29uIDxXaWxsLkRlYWNvbkBhcm0uY29tPjsgU3V6dWtpIFBvdWxv
c2UNCj4gPFN1enVraS5Qb3Vsb3NlQGFybS5jb20+DQo+IENjOiBsaW51eC1rZXJuZWxAdmdlci5r
ZXJuZWwub3JnOyBrdm1Admdlci5rZXJuZWwub3JnOyBTdGV2ZSBDYXBwZXINCj4gPFN0ZXZlLkNh
cHBlckBhcm0uY29tPjsgS2FseSBYaW4gKEFybSBUZWNobm9sb2d5IENoaW5hKQ0KPiA8S2FseS5Y
aW5AYXJtLmNvbT47IEp1c3RpbiBIZSAoQXJtIFRlY2hub2xvZ3kgQ2hpbmEpDQo+IDxKdXN0aW4u
SGVAYXJtLmNvbT47IG5kIDxuZEBhcm0uY29tPjsgbGludXgtYXJtLQ0KPiBrZXJuZWxAbGlzdHMu
aW5mcmFkZWFkLm9yZw0KPiBTdWJqZWN0OiBSZTogW1JGQyBQQVRDSCB2MyA0LzZdIHBzY2k6IEFk
ZCBodmMgY2FsbCBzZXJ2aWNlIGZvciBwdHBfa3ZtLg0KPiANCj4gT24gMjMvMDkvMTkgMDY6NTcs
IEppYW55b25nIFd1IChBcm0gVGVjaG5vbG9neSBDaGluYSkgd3JvdGU6DQo+ID4+IE9uIDE5LzA5
LzE5IDExOjQ2LCBKaWFueW9uZyBXdSAoQXJtIFRlY2hub2xvZ3kgQ2hpbmEpIHdyb3RlOg0KPiA+
Pj4+IE9uIDE4LzA5LzE5IDExOjU3LCBKaWFueW9uZyBXdSAoQXJtIFRlY2hub2xvZ3kgQ2hpbmEp
IHdyb3RlOg0KPiA+Pj4+PiBQYW9sbyBCb256aW5pIHdyb3RlOg0KPiA+Pj4+Pj4gVGhpcyBpcyBu
b3QgWTIwMzgtc2FmZS4gIFBsZWFzZSB1c2Uga3RpbWVfZ2V0X3JlYWxfdHM2NCBpbnN0ZWFkLA0K
PiA+Pj4+Pj4gYW5kIHNwbGl0IHRoZSA2NC1iaXQgc2Vjb25kcyB2YWx1ZSBiZXR3ZWVuIHZhbFsw
XSBhbmQgdmFsWzFdLg0KPiA+Pj4NCj4gPj4+IFZhbFtdIHNob3VsZCBiZSBsb25nIG5vdCB1MzIg
SSB0aGluaywgc28gaW4gYXJtNjQgSSBjYW4gYXZvaWQgdGhhdA0KPiA+Pj4gWTIwMzhfc2FmZSwg
YnV0IGFsc28gbmVlZCByZXdyaXRlIGZvciBhcm0zMi4NCj4gPj4NCj4gPj4gSSBkb24ndCB0aGlu
ayB0aGVyZSdzIGFueXRoaW5nIGluaGVyZW50bHkgd3Jvbmcgd2l0aCB1MzIgdmFsW10sIGFuZA0K
PiA+PiBhcyB5b3Ugbm90aWNlIGl0IGxldHMgeW91IHJldXNlIGNvZGUgYmV0d2VlbiBhcm0gYW5k
IGFybTY0LiAgSXQncyB1cA0KPiA+PiB0byB5b3UgYW5kIE1hcmMgdG8gZGVjaWRlLg0KPiA+Pg0K
PiA+IFRvIGNvbXBhdGlibGUgMzItYml0LCBJbnRlZ3JhdGVzIHNlY29uZCB2YWx1ZSBhbmQgbmFu
b3NlY29uZCB2YWx1ZSBhcw0KPiA+IGEgbmFub3NlY29uZCB2YWx1ZSB0aGVuIHNwbGl0IGl0IGlu
dG8gdmFsWzBdIGFuZCB2YWxbMV0gYW5kIHNwbGl0IGN5Y2xlIHZhbHVlDQo+IGludG8gdmFsWzJd
IGFuZCB2YWxbM10sICBJbiB0aGlzIHdheSwgdGltZSB3aWxsIG92ZXJmbG93IGF0IFkyMjYyLg0K
PiA+IFdEWVQ/DQo+IA0KPiBTbyBpZiBJIHVuZGVyc3RhbmQgY29ycmVjdGx5IHlvdSdkIG11bHRp
cGx5IGJ5IDEwXjkgKG9yIGJldHRlciBzaGlmdCBieQ0KPiAzMCkgdGhlIG5hbm9zZWNvbmRzLg0K
PiANClllYWgsIA0KPiBUaGF0IHdvcmtzLCBidXQgd2h5IG5vdCBwcm92aWRlIDUgb3V0cHV0IHJl
Z2lzdGVycz8gIEFsdGVybmF0aXZlbHksIHRha2UgYW4NCj4gYWRkcmVzcyBhcyBpbnB1dCBhbmQg
d3JpdGUgdGhlcmUuDQoNCkl0IHdpbGwgYmUgZWFzeSwgIGlmIEkgY291bGQgaGF2ZSBleHBhbmRl
ZCB0aGUgc3RvcmUgcm9vbS4gQnV0IHRoZXNlIGNvZGUgaXMgdGhlIGluZnJhc3RydWN0dXJlIGZv
ciBoeXBlcmNhbGwsIEkgY2FuJ3QgY2hhbmdlIHRoZW0gYXQgbXkgd2lsbC4NCkkgdGhpbmsgb25s
eSB2YWx1ZSBidXQgcG9pbnRlciBjYW4gZGVsaXZlcmVkIGJ5IHNtY2NjX3NldF9yZXR2YWwgY2Fs
bC4NCg0KPiANCj4gRmluYWxseSwgb24geDg2IHdlIGFkZGVkIGFuIGFyZ3VtZW50IGZvciB0aGUg
Q0xPQ0tfKiB0aGF0IGlzIGJlaW5nIHJlYWQNCj4gKGN1cnJlbnRseSBvbmx5IENMT0NLX1JFQUxU
SU1FLCBidXQgaGF2aW5nIHJvb20gZm9yIGV4dGVuc2liaWxpdHkgaW4gdGhlIEFQSQ0KPiBpcyBh
bHdheXMgbmljZSkuDQo+IA0KSU1PLCBJIHdpbGwgYmUgbGltaXRlZCBieSB0aGUgZGVzaWduIG9m
IGh5cGVyY2FsbCBvbiBhcm02NCwgSSBjYW4gb25seSBkZXNpZ24gbXkgY29kZSB1bmRlciBpdC4g
bWF5YmUgaXQgd2lsbCBiZSBiZXR0ZXIgc29tZXRpbWUgYnV0IGZvciBub3cgSSBjb3VsZCBqdXN0
IG9iZXkgaXQuDQoNClRoYW5rcw0KSmlhbnlvbmcgIFd1DQoNCj4gUGFvbG8NCg0K
