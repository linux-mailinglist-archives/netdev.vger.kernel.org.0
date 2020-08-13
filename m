Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 019A92439D2
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 14:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726244AbgHMMcf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Aug 2020 08:32:35 -0400
Received: from rcdn-iport-1.cisco.com ([173.37.86.72]:42366 "EHLO
        rcdn-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbgHMMce (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Aug 2020 08:32:34 -0400
X-Greylist: delayed 428 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Aug 2020 08:32:33 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=1524; q=dns/txt; s=iport;
  t=1597321953; x=1598531553;
  h=from:to:subject:date:message-id:content-id:
   content-transfer-encoding:mime-version;
  bh=k7AWu6GYss0vxf+Dib6+5mBvoi1wRrxw93rcjCeRLAA=;
  b=Z7pwtYM0hklRtAP4qMnmf/nV6DbQ142qKg3G3SqdAHDvfzbqNwU/kbgL
   vTYLfWSuo+3klg3mxQ8TxK09irI09fpdWO7Q80jpLbwChZ1Ps7/u6WwJS
   p8yL5NCZbvNVqPIrg/V2YivuXlnFkq/uzTeeyfHMY46WLLTKm8D5Q48MF
   8=;
IronPort-PHdr: =?us-ascii?q?9a23=3AqsLfWRMLayKUbNwz6WUl6mtXPHoupqn0MwgJ65?=
 =?us-ascii?q?Eul7NJdOG58o//OFDEvK8z3kHGUJ+d6P9ejefS9af6Vj9I7ZWAtSUEd5pBH1?=
 =?us-ascii?q?8AhN4NlgMtSMiCFQXgLfHsYiB7eaYKVFJs83yhd0QAHsH4ag7MrXCoqz0fAB?=
 =?us-ascii?q?PyMUxyPOumUoLXht68gua1/ZCbag5UhT27NLV1Khj+rQjYusQMx4V4LaNkwR?=
 =?us-ascii?q?rSqXwOcONTlm4=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0DxGQC9MDVf/4kNJK1fHQEBPAEFBQE?=
 =?us-ascii?q?CAQkBFYFMAYE7AgEBAQ9RB3BYLywKgSODCYNGA5J9k0GCUwNVCwEBAQwBASc?=
 =?us-ascii?q?GAgQBAQ+DeV2CKAIkOBMCAwEBCwEBBQEBAQIBBgRthVwBC0MBDAGFORERDAE?=
 =?us-ascii?q?BOBEBIgImAgQwFRIEDQgBAR6DBAGCSwMuAQMLpjsCgTmIYXaBMoMBAQEFgkq?=
 =?us-ascii?q?CYBiCDgMGgQ4oAgEBAQEBgmyCUhI5QoZAGoFBP4ERJ4VsFwQXhF2CYI9ugxG?=
 =?us-ascii?q?SPZBwCoJih2OBAJEtBQcDHqAVhVqMWYo/kFKEJQIEAgQFAg4BAQWBaiOBV3A?=
 =?us-ascii?q?VgyRQFwINkhCFFIVCdAIBCCwCBgoBAQMJfIRGiioBgRABAQ?=
X-IronPort-AV: E=Sophos;i="5.76,308,1592870400"; 
   d="scan'208";a="802034371"
Received: from alln-core-4.cisco.com ([173.36.13.137])
  by rcdn-iport-1.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 13 Aug 2020 12:25:24 +0000
Received: from XCH-RCD-005.cisco.com (xch-rcd-005.cisco.com [173.37.102.15])
        by alln-core-4.cisco.com (8.15.2/8.15.2) with ESMTPS id 07DCPOBm008028
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL)
        for <netdev@vger.kernel.org>; Thu, 13 Aug 2020 12:25:24 GMT
Received: from xhs-aln-002.cisco.com (173.37.135.119) by XCH-RCD-005.cisco.com
 (173.37.102.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 13 Aug
 2020 07:25:24 -0500
Received: from xhs-rcd-003.cisco.com (173.37.227.248) by xhs-aln-002.cisco.com
 (173.37.135.119) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 13 Aug
 2020 07:25:23 -0500
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (72.163.14.9) by
 xhs-rcd-003.cisco.com (173.37.227.248) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 13 Aug 2020 07:25:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BeuOcgatQOoxPUNxGEJ/k/9YUuVMO66zfY2mMXnTGVyBoRYX38OBbMXcuN7bVyVcE6I5oXkPbcj7xmn7DH2DQ7xkd2HQeUdaMnq7iiW4psqeIeDnyIEmwQVNO6d43o2lqrCvJ2VGO5sNOYLuejkVNXEHTa/aXQfLltQf+RGBqrmOaA86rulTtyUXdIGWo7W+Zj5kn9A7FyohAr4/YbXYR9YyHQiTyN73vBZ4iZSXIwqH5rFaPwtqL4P1zxwiL84c61zVsPs60wEAct02wkK7s/EuD/L9OhGSdhErDC5ElpptA9E49oHvdyX51nql7vcShJ+ZwuLKMxkTM0iSa1UuMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k7AWu6GYss0vxf+Dib6+5mBvoi1wRrxw93rcjCeRLAA=;
 b=cigDjfENlLiVkiDvQQzqMQpRm3O4gzfGuCa+9midDvPC+AZigNI8xOO7rhwimR8Vxh2+DDPG34/OkadCyO94OCjMdWNFVbL67+bF9muP0XT5RoLD/QrWGKd2jTtgpMRa/Yg8n6Fotlld9/svWK/XjuGS3SuhSZVRCMSd9nWmElrzMBtmMLHWus0prjxuAxe9TB4+Kcn0CINpxPG8/BwI+TJVo0u7Gy1dnRrJffFsUVgFIZ13h/GrTfUb6pObbl0FBR2rHrh7xdrk9cxRetwD/PpGvfyUb/qC+H60il+KkM00fECANPAJkK9k/u/VSdvY5bjweg/95UXcZ2yIK7OrwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k7AWu6GYss0vxf+Dib6+5mBvoi1wRrxw93rcjCeRLAA=;
 b=U6wDA2SwK3109xv3SEK9cqMtQ0miXen5kywNbqehW6e/CCvqmMwtpPxlXOLvGsdPKB5p1aCtARuL49aCe9Z+1WlkPp3Nwkinl1pV20YQ15y6L52aQTMbPUmpTvcA2bSWv9DNJ3NlDuYMoE6mr88i33MqTct5EgzAiUQp7+65mVM=
Received: from DM6PR11MB3866.namprd11.prod.outlook.com (2603:10b6:5:199::33)
 by DM6PR11MB2812.namprd11.prod.outlook.com (2603:10b6:5:c4::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.18; Thu, 13 Aug
 2020 12:25:22 +0000
Received: from DM6PR11MB3866.namprd11.prod.outlook.com
 ([fe80::585d:bd21:89c5:56a]) by DM6PR11MB3866.namprd11.prod.outlook.com
 ([fe80::585d:bd21:89c5:56a%4]) with mapi id 15.20.3261.026; Thu, 13 Aug 2020
 12:25:22 +0000
From:   "Hans-Christian Egtvedt (hegtvedt)" <hegtvedt@cisco.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: ethtool 5.8 segfaults when changing settings on a device
Thread-Topic: ethtool 5.8 segfaults when changing settings on a device
Thread-Index: AQHWcWzQfIJxZ+04qU6N7Lihfy51JQ==
Date:   Thu, 13 Aug 2020 12:25:22 +0000
Message-ID: <31867b3d-341c-6ed5-c212-bfde37a1059d@cisco.com>
Accept-Language: en-DK, en-US
Content-Language: aa
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=cisco.com;
x-originating-ip: [82.164.109.235]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4d70f2ca-222b-4ed9-8a10-08d83f83f2fa
x-ms-traffictypediagnostic: DM6PR11MB2812:
x-microsoft-antispam-prvs: <DM6PR11MB28122506AD18261A868A1137DD430@DM6PR11MB2812.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:212;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IHAKg7D9BGqgxjJ7330+2ErPd53Ana9g5XrD7SU7gmUxLv0vXCGSTi6HjQjv29IHdmFc6jGiSNk+6KMqzCSo4stpxeXEOWGzOYMi9FoG5W7UN5UQfztYTkFUrmzQjqpEeNYD2NHCWD6K1rHeGIqHb+0VjUCNNx/kqG07peGlCn/RJbFla/5nUB0px+l9ZnOAKXNZ3DcmtWgjqFm55UnV4iP8jn40cMnPppepg9xKvRxpuEgV/VJxM5pDSmYY1DzxmPBBO20ai5Q7FddbnGxlCqTSxr7cX1SmGlO+h1gflUEx+31vZqmYnFkhiiXLA1YM8e+4Va8v0n1S37HEBrYes7e7hPao2jyoABQaCiV5byd8X/no/rQPpn9KgP/zwfwz1B30RtZBXJg2TGT2IEr4QLhhwun8wbo59Qz5AND+SMcBxHzoPvEJqQhyaTEHdWKjkxstP020i/Whmjeae3Gagg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3866.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(136003)(346002)(39860400002)(396003)(376002)(478600001)(966005)(86362001)(6916009)(8936002)(8676002)(6506007)(26005)(2906002)(71200400001)(186003)(31696002)(6486002)(66476007)(36756003)(2616005)(76116006)(91956017)(66946007)(66556008)(316002)(64756008)(31686004)(5660300002)(83380400001)(6512007)(66446008)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: NVbJZqGAm13DOJp3DDSL/jm/JyJMOtTHKhpXVIHRJYRNaMhnums/3MyFEeYkDyMPZ5sf0k+9tnP8YHUi9RfuW4zQ7Bi/gELsNElYejv32YScRGNM//Th3xQln9/IJqYPxYJk6ew/j93wOdt5WPG3WMec79oyuzUYhsRGmndhNuc4i+5dmgKHZCymq9znkjGxZNaxGxuJVMOU44wsAknUl2uI/cDrhEwfXLCM2uRHa1mwC4R2cv8JYP+wTcktEHfxZSuZtdcfN4JDbFB/eRm1yYbfqhABWA1Kc4ckjY+9gIgtDrbKitEeC1aoR9i2SIH7adat8gEuhwVudJUodc2km5z5EJ5Vey9a+1+RQY9GmdoLHdq6R1C2bA91VBTnd2FlQZmKryo3nkMIMJc3BzMBrgXiiimcfqlPfP1gyP4ozaJ1sEnAxSBFNqoE91S8FF/kjERqVT2MDtic1Um+ZdsnkCYLXTCNHel/eeKPK0y4PklBEqWtEDQUezf/6Se4sl9wxHqjgRhXN6WYXuxtcxNFBbi+QzrM4Fj09sCHSevpWetFHmDBPEvuZ1rdNH+BSUbjQpRyrEWRbX8TSuV0NZ7wBBfRVbdVzuiq5dU6iWnvBkm4VSnXFb/f34bGtXidVuVtW0Zakx+ud0hY8yTUty+sWA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <C4BC901BDE57D6429D24B477CDD8DE16@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3866.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d70f2ca-222b-4ed9-8a10-08d83f83f2fa
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Aug 2020 12:25:22.2366
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FjuASug84N2T72+tWkDVnLhhgU0eFEEmj4rut0fVH+coa7qKgMUxgQ6ZQS6CSKEfmgaW7dXv4wuDbe1nPMLqog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2812
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.37.102.15, xch-rcd-005.cisco.com
X-Outbound-Node: alln-core-4.cisco.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8sDQoNCkkgYW0gdGVzdGluZyBldGh0b29sIDUuOCwgYW5kIEkgbm90aWNlZCBpdCBzZWdm
YXVsdGVkIHdpdGggdGhlIGNvbW1hbmQNCiAgIGV0aHRvb2wgLXMgZXRoMCBhdXRvbmVnIG9uDQoN
CkJhY2t0cmFjZSBhcyBmb2xsb3dzOg0KKGdkYikgcnVuIC1zIGV0aDAgYXV0b25lZyBvbg0KU3Rh
cnRpbmcgcHJvZ3JhbTogL3RtcC9ldGh0b29sLTUuOCAtcyBldGgwIGF1dG9uZWcgb24NCg0KUHJv
Z3JhbSByZWNlaXZlZCBzaWduYWwgU0lHU0VHViwgU2VnbWVudGF0aW9uIGZhdWx0Lg0KMHgwMDQw
YmVmOCBpbiBkb19zc2V0ICgpDQooZ2RiKSBidA0KIzAgIDB4MDA0MGJlZjggaW4gZG9fc3NldCAo
KQ0KIzEgIDB4MDA0MDdkOWMgaW4gZG9faW9jdGxfZ2xpbmtzZXR0aW5ncyAoKQ0KIzIgIDB4MDAw
MDAwMDAgaW4gPz8gKCkNCkJhY2t0cmFjZSBzdG9wcGVkOiBwcmV2aW91cyBmcmFtZSBpZGVudGlj
YWwgdG8gdGhpcyBmcmFtZSAoY29ycnVwdCBzdGFjaz8pDQoNCkkgdGhlbiB0ZXN0ZWQgcmV2ZXJ0
aW5nIA0KaHR0cHM6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL25ldHdvcmsvZXRodG9vbC9ldGh0
b29sLmdpdC9jb21taXQvZXRodG9vbC5jP2lkPWJlZjc4MDQ2N2ZhN2FhOTVkY2EzZWQ1Y2MzZWJi
OGJlYzU4ODJmMDgNCg0KQW5kIHRoZSBjb21tYW5kIG5vdyBwYXNzZXMuDQoNCkkgYW0gcnVubmlu
ZyBldGh0b29sIG9uIHRvcCBvZiBMaW51eCA0LjQuMjMyLCBoZW5jZSB0aGVyZSBpcyBubyBzdXBw
b3J0IA0KZm9yIEVUSFRPT0xfeExJTktTRVRUSU5HUy4NCg0KSXMgdGhlIGJlZjc4MDQ2N2ZhN2Fh
OTVkY2EzZWQ1Y2MzZWJiOGJlYzU4ODJmMDggcGF0Y2ggbm90IGNvcnJlY3QsIG9uZSANCnNob3Vs
ZCBjaGVjayBsaW5rX3VzZXR0aW5ncyBwb2ludGVyIGZvciBub24tTlVMTCBiZWZvcmUgbWVtc2V0
J2luZz8NCg0KU2luY2UgZG9faW9jdGxfZ2xpbmtzZXR0aW5ncygpIHdpbGwgcmV0dXJuIE5VTEwg
dXBvbiBmYWlsdXJlLCB3aGljaCANCm1hdGNoZXMgd2VsbCB3aXRoIGtlcm5lbHMgbm90IHN1cHBv
cnRpbmcgRVRIVE9PTF9HTElOS1NFVFRJTkdTIGlvY3RsLg0KDQotLSANCkJlc3QgcmVnYXJkcywg
SGFucy1DaHJpc3RpYW4gTm9yZW4gRWd0dmVkdA0K
