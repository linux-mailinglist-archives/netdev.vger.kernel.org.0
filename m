Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 413EE20D4E6
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 21:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730528AbgF2TMe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 15:12:34 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:33144 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729033AbgF2TMa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:12:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1593457951; x=1624993951;
  h=from:to:cc:subject:date:message-id:content-id:
   content-transfer-encoding:mime-version;
  bh=WqqlsqVGUlQFbnB/zA6GJXpqmsxIwhb2IUVWWqpwbb8=;
  b=lo7cstvofprA/IQsgQ7Rqkkdya2Ht7fiXJ4xUnqVTEsNMEWbUCVo3rJK
   HTrTxF6DGtmeHkhmnYBhwNNixSaYAnWlFHHLXxsFQhDj6hHc7FLuKIkHH
   /lH/e+HWjSoKooHqjTaAsmuXcN/ywCY/BVquKU1zC7Vspa4fvZuROLmVI
   NPIdIkAjmPPivPE0Zj/KXLmMCdpOUnqOe/ZgiZb54lwKKEwqOiptStJXB
   hbvJ2g3lsAVRlS3VUHvWM2/zhDqEx8edJ5YdPZgiZBxDIhYfQ9dsw9W1O
   YrRVwnq6LTx4mHNrFm7beDSBUhBPbF4k5c4u+OOPzuvq6cHYTn1qoLvzM
   w==;
IronPort-SDR: C+ny2zeQN3bIipuDlmq2zSXNwaPqfwiXO/InxcXUc5wLS1ZQ1DDl9SJ7PSlCq9XGa2/5xE2vAo
 K7p3tLZcfbXE//dZdwNzkwexrk6NSHeq++cJ2/0fCNZSTBeg/PkX9jrLs6Q0ob5KD/VFkLbax4
 L+kUORhXEsuxxqcGlisOHA8aHbuRHO/GNkx5wIIaQe0/AOtnD+LTvpF0ZtSfLtI0OXCevplAGC
 wHmfg97RkfjkBStzh1SINWhVVGy5gpR6QjXh+DAH2EYjqjudE1p3vMUwgHrbC5xKiRL0MNt/RF
 OB0=
X-IronPort-AV: E=Sophos;i="5.75,294,1589266800"; 
   d="scan'208";a="81221205"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Jun 2020 06:12:49 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 29 Jun 2020 06:12:30 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3
 via Frontend Transport; Mon, 29 Jun 2020 06:12:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HXRhsfkBay8CMBVWHTNDyjg4xR7gyV9hgEdH3glAplg4hi1h4CiVQRyXGsAQYHRbQkSmv3hJcHLDsR0b89dlI5u5JsoVCKApsAVI0ST3Cm77ozEcMcfNx2HurrHxVhoA0ECclE4Czbx2SFHTiI+oHCOdl4W0fJa0KH+Qi6OglM6HR7eEZNG34tn+SGrG2MtjBn56S4yLkF4RsECATBhDjQhyAat27RGHPcFSVPkSKuoFHR9E9F9lJ4lzmfn4Ke70X14gmGVW8sZeV+nxhFTfrF44Nt2oJCZIieaGOpvVDQ2tynjmoThJin9YKqGgoUHNMNLSav992RuF+nlK8PYL4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WqqlsqVGUlQFbnB/zA6GJXpqmsxIwhb2IUVWWqpwbb8=;
 b=fUl3RxmaLvyV8HjnYRqENS/6nVCu1OZN3OMX54ixUflLIp61/wtdMkoocKBdZtzwLznEovnwe3LUgre0vUxlxMicLROfYah7ZFyP+WYaf+CLHoW+HXa10HvDluapqFGbWRiD2LnYgOmirXo86Wp3P/3hx669Cwi8O+WefK2ds2dltze6QPK+WPYs1odWg2o/rBu0Biw4GKgc5XOa4jdjarPFWdvQ6cLTNI/H3XV08V9iuDX++3Bae1DBojtkwfa2cWi9XeBUelyEfEC5+tMv+85vznFP2eihfM6Ji8BboI9bEILSa780auIQ+BFLgVW0CXRYT0lETylQndjZyCHGgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WqqlsqVGUlQFbnB/zA6GJXpqmsxIwhb2IUVWWqpwbb8=;
 b=F3dUU0CwwC7F51lv32dCj+xmyu89hyy8mdqPwcLQp5IMu7nJACCgBcwUZgfmv5ZIU7MQ5LHt+Fpcnkm0JYB8gWBT5xXS4NfmM1gmW3gLTAvy5RsfNtfXXVMgX5mBXoEZGT6hr0oHEvNqU847iZ3t29XfVs1ZZ8NpkENhuBsXB4M=
Received: from BY5PR11MB3927.namprd11.prod.outlook.com (2603:10b6:a03:186::21)
 by BY5PR11MB4434.namprd11.prod.outlook.com (2603:10b6:a03:1c2::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20; Mon, 29 Jun
 2020 13:12:46 +0000
Received: from BY5PR11MB3927.namprd11.prod.outlook.com
 ([fe80::5993:d0ac:9849:d311]) by BY5PR11MB3927.namprd11.prod.outlook.com
 ([fe80::5993:d0ac:9849:d311%7]) with mapi id 15.20.3131.027; Mon, 29 Jun 2020
 13:12:46 +0000
From:   <Andre.Edich@microchip.com>
To:     <netdev@vger.kernel.org>, <UNGLinuxDriver@microchip.com>,
        <steve.glendinning@shawell.net>
CC:     <Parthiban.Veerasooran@microchip.com>
Subject: [PATCH net-next 6/8] smsc95xx: remove redundant function arguments
Thread-Topic: [PATCH net-next 6/8] smsc95xx: remove redundant function
 arguments
Thread-Index: AQHWThb7fjPAL7m+hU2iEbb+aJyzpw==
Date:   Mon, 29 Jun 2020 13:12:46 +0000
Message-ID: <2f887d706ae816eb1b018452cc50001557599825.camel@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.3 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=microchip.com;
x-originating-ip: [93.202.178.57]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9125e6c3-e4c8-40bd-8f18-08d81c2e1da3
x-ms-traffictypediagnostic: BY5PR11MB4434:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR11MB443439DB1DC22DA7DFE6FA09EC6E0@BY5PR11MB4434.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:1013;
x-forefront-prvs: 044968D9E1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ISyfKOBonYsd/1oT47rxm91gs6Awxi+2wem9tD6G0GKQM6HFS9O3SiiQvqAdkZOQHFQsMwXB6ZIMgMTIrA8KUEkQ1vlcrTCbbUH2OUsw+7cehCmi8d5Bw4L0cvHm9uQoyndsudJyfFBiZ1nZu0zkWi65+HsgI7jaLAzH0ju3MmSJg2LXPTJdXsCh0Uua884nC3l2k9SUD/DoGZwmlWnz1XDxPy9aYAcUKlOM5VhDqJBV/a3q5XDhSGj7mN8oh5+kGE4VRnuRG4c1AE+rPWrqPnShkb5FDludXHyPCZonfaj9+r1NhNvxzs06AGZuOjLy
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB3927.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(366004)(136003)(39860400002)(346002)(376002)(83380400001)(6512007)(8676002)(8936002)(5660300002)(36756003)(110136005)(4326008)(316002)(2906002)(6486002)(107886003)(66946007)(6506007)(2616005)(76116006)(91956017)(66476007)(66556008)(64756008)(66446008)(186003)(26005)(478600001)(86362001)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: jdhJisAnqok9YTfaH1TsQPwDv2GKAhISZm3kJDhSw6clt14v2w0UNnCxX53C9dwVhP/FRnRkUcbJeYaw8V83F3kl+VRg8iIkfV765zKcyRBY59+x2dIpUq/lsRnqLPGVjBGbYwF2glWOpVsiOCFcSgtJUQ2+T5iQGDR8dRJ6pS5hwL4GqOz9k1coBj3tcjs7y/I03GTUEAdXHeP5mqL/52yFNcQuCD9iy8N2NaW2ZbOO7XmZF1rcTSnIXowVGJJ1235kvpPBBrX1R4aDFJmSbDhviicwUYPH20BwBvwhG5FkYsim+MM59wuWM869G1ahAeOsJ+0lWaQ9d61CHMvDzmf8SMzYEzBs9ApfFpebqQZNd1Hrb6IJiYNbechuk47ksxcdybU2ZDGTH9bMFTRb0j/WRwMLSBeNEeegYWTM3QoaWRCEkbYhwjLMiD21FaI3k+S6iYWmetBkOKfWRBEIm/sJG2ZT4wovekoExyq5yj9qgXpH9vV9LKabnzDaV2Z7
Content-Type: text/plain; charset="utf-8"
Content-ID: <57C6B2FBCBE3D745BD1E7145800EA962@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB3927.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9125e6c3-e4c8-40bd-8f18-08d81c2e1da3
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2020 13:12:46.2257
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xeBgMGgsF/dVMUJv68zOLm6SHFHFwDs0izYwbru638pUm5XmsrDVv+IHiTDFVocHDZOGT9xNTrquCAE4jqQsqUwQ1ddp96DNeMdVtvBBSQo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4434
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhpcyBwYXRjaCByZW1vdmVzIGFyZ3VtZW50cyBuZXRkZXYgYW5kIHBoeV9pZCBmcm9tIHRoZSBm
dW5jdGlvbnMNCnNtc2M5NXh4X21kaW9fcmVhZF9ub3BtIGFuZCBzbXNjOTV4eF9tZGlvX3dyaXRl
X25vcG0uICBCb3RoIHJlbW92ZWQNCmFyZ3VtZW50cyBhcmUgcmVjb3ZlcmVkIGZyb20gYSBuZXcg
YXJndW1lbnQgYHN0cnVjdCB1c2JuZXQgKmRldmAuDQoNClNpZ25lZC1vZmYtYnk6IEFuZHJlIEVk
aWNoIDxhbmRyZS5lZGljaEBtaWNyb2NoaXAuY29tPg0KLS0tDQogZHJpdmVycy9uZXQvdXNiL3Nt
c2M5NXh4LmMgfCAzNSArKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0tLS0tLQ0KIDEgZmls
ZSBjaGFuZ2VkLCAxNyBpbnNlcnRpb25zKCspLCAxOCBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdp
dCBhL2RyaXZlcnMvbmV0L3VzYi9zbXNjOTV4eC5jIGIvZHJpdmVycy9uZXQvdXNiL3Ntc2M5NXh4
LmMNCmluZGV4IDExYWY1ZDVlY2U2MC4uYmNkZDdlNzI2ZjViIDEwMDY0NA0KLS0tIGEvZHJpdmVy
cy9uZXQvdXNiL3Ntc2M5NXh4LmMNCisrKyBiL2RyaXZlcnMvbmV0L3VzYi9zbXNjOTV4eC5jDQpA
QCAtMjYxLDE2ICsyNjEsMTggQEAgc3RhdGljIHZvaWQgX19zbXNjOTV4eF9tZGlvX3dyaXRlKHN0
cnVjdA0KbmV0X2RldmljZSAqbmV0ZGV2LCBpbnQgcGh5X2lkLA0KIAltdXRleF91bmxvY2soJmRl
di0+cGh5X211dGV4KTsNCiB9DQogDQotc3RhdGljIGludCBzbXNjOTV4eF9tZGlvX3JlYWRfbm9w
bShzdHJ1Y3QgbmV0X2RldmljZSAqbmV0ZGV2LCBpbnQNCnBoeV9pZCwNCi0JCQkJICAgaW50IGlk
eCkNCitzdGF0aWMgaW50IHNtc2M5NXh4X21kaW9fcmVhZF9ub3BtKHN0cnVjdCB1c2JuZXQgKmRl
diwgaW50IGlkeCkNCiB7DQotCXJldHVybiBfX3Ntc2M5NXh4X21kaW9fcmVhZChuZXRkZXYsIHBo
eV9pZCwgaWR4LCAxKTsNCisJc3RydWN0IG1paV9pZl9pbmZvICptaWkgPSAmZGV2LT5taWk7DQor
DQorCXJldHVybiBfX3Ntc2M5NXh4X21kaW9fcmVhZChkZXYtPm5ldCwgbWlpLT5waHlfaWQsIGlk
eCwgMSk7DQogfQ0KIA0KLXN0YXRpYyB2b2lkIHNtc2M5NXh4X21kaW9fd3JpdGVfbm9wbShzdHJ1
Y3QgbmV0X2RldmljZSAqbmV0ZGV2LCBpbnQNCnBoeV9pZCwNCi0JCQkJICAgICBpbnQgaWR4LCBp
bnQgcmVndmFsKQ0KK3N0YXRpYyB2b2lkIHNtc2M5NXh4X21kaW9fd3JpdGVfbm9wbShzdHJ1Y3Qg
dXNibmV0ICpkZXYsIGludCBpZHgsIGludA0KcmVndmFsKQ0KIHsNCi0JX19zbXNjOTV4eF9tZGlv
X3dyaXRlKG5ldGRldiwgcGh5X2lkLCBpZHgsIHJlZ3ZhbCwgMSk7DQorCXN0cnVjdCBtaWlfaWZf
aW5mbyAqbWlpID0gJmRldi0+bWlpOw0KKw0KKwlfX3Ntc2M5NXh4X21kaW9fd3JpdGUoZGV2LT5u
ZXQsIG1paS0+cGh5X2lkLCBpZHgsIHJlZ3ZhbCwgMSk7DQogfQ0KIA0KIHN0YXRpYyBpbnQgc21z
Yzk1eHhfbWRpb19yZWFkKHN0cnVjdCBuZXRfZGV2aWNlICpuZXRkZXYsIGludCBwaHlfaWQsDQpp
bnQgaWR4KQ0KQEAgLTEzNDksMzkgKzEzNTEsMzcgQEAgc3RhdGljIHUzMiBzbXNjX2NyYyhjb25z
dCB1OCAqYnVmZmVyLCBzaXplX3QNCmxlbiwgaW50IGZpbHRlcikNCiANCiBzdGF0aWMgaW50IHNt
c2M5NXh4X2VuYWJsZV9waHlfd2FrZXVwX2ludGVycnVwdHMoc3RydWN0IHVzYm5ldCAqZGV2LA0K
dTE2IG1hc2spDQogew0KLQlzdHJ1Y3QgbWlpX2lmX2luZm8gKm1paSA9ICZkZXYtPm1paTsNCiAJ
aW50IHJldDsNCiANCiAJbmV0ZGV2X2RiZyhkZXYtPm5ldCwgImVuYWJsaW5nIFBIWSB3YWtldXAg
aW50ZXJydXB0c1xuIik7DQogDQogCS8qIHJlYWQgdG8gY2xlYXIgKi8NCi0JcmV0ID0gc21zYzk1
eHhfbWRpb19yZWFkX25vcG0oZGV2LT5uZXQsIG1paS0+cGh5X2lkLA0KUEhZX0lOVF9TUkMpOw0K
KwlyZXQgPSBzbXNjOTV4eF9tZGlvX3JlYWRfbm9wbShkZXYsIFBIWV9JTlRfU1JDKTsNCiAJaWYg
KHJldCA8IDApDQogCQlyZXR1cm4gcmV0Ow0KIA0KIAkvKiBlbmFibGUgaW50ZXJydXB0IHNvdXJj
ZSAqLw0KLQlyZXQgPSBzbXNjOTV4eF9tZGlvX3JlYWRfbm9wbShkZXYtPm5ldCwgbWlpLT5waHlf
aWQsDQpQSFlfSU5UX01BU0spOw0KKwlyZXQgPSBzbXNjOTV4eF9tZGlvX3JlYWRfbm9wbShkZXYs
IFBIWV9JTlRfTUFTSyk7DQogCWlmIChyZXQgPCAwKQ0KIAkJcmV0dXJuIHJldDsNCiANCiAJcmV0
IHw9IG1hc2s7DQogDQotCXNtc2M5NXh4X21kaW9fd3JpdGVfbm9wbShkZXYtPm5ldCwgbWlpLT5w
aHlfaWQsIFBIWV9JTlRfTUFTSywNCnJldCk7DQorCXNtc2M5NXh4X21kaW9fd3JpdGVfbm9wbShk
ZXYsIFBIWV9JTlRfTUFTSywgcmV0KTsNCiANCiAJcmV0dXJuIDA7DQogfQ0KIA0KIHN0YXRpYyBp
bnQgc21zYzk1eHhfbGlua19va19ub3BtKHN0cnVjdCB1c2JuZXQgKmRldikNCiB7DQotCXN0cnVj
dCBtaWlfaWZfaW5mbyAqbWlpID0gJmRldi0+bWlpOw0KIAlpbnQgcmV0Ow0KIA0KIAkvKiBmaXJz
dCwgYSBkdW1teSByZWFkLCBuZWVkZWQgdG8gbGF0Y2ggc29tZSBNSUkgcGh5cyAqLw0KLQlyZXQg
PSBzbXNjOTV4eF9tZGlvX3JlYWRfbm9wbShkZXYtPm5ldCwgbWlpLT5waHlfaWQsIE1JSV9CTVNS
KTsNCisJcmV0ID0gc21zYzk1eHhfbWRpb19yZWFkX25vcG0oZGV2LCBNSUlfQk1TUik7DQogCWlm
IChyZXQgPCAwKQ0KIAkJcmV0dXJuIHJldDsNCiANCi0JcmV0ID0gc21zYzk1eHhfbWRpb19yZWFk
X25vcG0oZGV2LT5uZXQsIG1paS0+cGh5X2lkLCBNSUlfQk1TUik7DQorCXJldCA9IHNtc2M5NXh4
X21kaW9fcmVhZF9ub3BtKGRldiwgTUlJX0JNU1IpOw0KIAlpZiAocmV0IDwgMCkNCiAJCXJldHVy
biByZXQ7DQogDQpAQCAtMTQzMCw3ICsxNDMwLDYgQEAgc3RhdGljIGludCBzbXNjOTV4eF9lbnRl
cl9zdXNwZW5kMChzdHJ1Y3QgdXNibmV0DQoqZGV2KQ0KIHN0YXRpYyBpbnQgc21zYzk1eHhfZW50
ZXJfc3VzcGVuZDEoc3RydWN0IHVzYm5ldCAqZGV2KQ0KIHsNCiAJc3RydWN0IHNtc2M5NXh4X3By
aXYgKnBkYXRhID0gKHN0cnVjdCBzbXNjOTV4eF9wcml2ICopKGRldi0NCj5kYXRhWzBdKTsNCi0J
c3RydWN0IG1paV9pZl9pbmZvICptaWkgPSAmZGV2LT5taWk7DQogCXUzMiB2YWw7DQogCWludCBy
ZXQ7DQogDQpAQCAtMTQzOCwxNyArMTQzNywxNyBAQCBzdGF0aWMgaW50IHNtc2M5NXh4X2VudGVy
X3N1c3BlbmQxKHN0cnVjdA0KdXNibmV0ICpkZXYpDQogCSAqIGNvbXBhdGliaWxpdHkgd2l0aCBu
b24tc3RhbmRhcmQgbGluayBwYXJ0bmVycw0KIAkgKi8NCiAJaWYgKHBkYXRhLT5mZWF0dXJlcyAm
IEZFQVRVUkVfUEhZX05MUF9DUk9TU09WRVIpDQotCQlzbXNjOTV4eF9tZGlvX3dyaXRlX25vcG0o
ZGV2LT5uZXQsIG1paS0+cGh5X2lkLAlQSFlfRURQDQpEX0NPTkZJRywNCi0JCQlQSFlfRURQRF9D
T05GSUdfREVGQVVMVCk7DQorCQlzbXNjOTV4eF9tZGlvX3dyaXRlX25vcG0oZGV2LCBQSFlfRURQ
RF9DT05GSUcsDQorCQkJCQkgUEhZX0VEUERfQ09ORklHX0RFRkFVTFQpOw0KIA0KIAkvKiBlbmFi
bGUgZW5lcmd5IGRldGVjdCBwb3dlci1kb3duIG1vZGUgKi8NCi0JcmV0ID0gc21zYzk1eHhfbWRp
b19yZWFkX25vcG0oZGV2LT5uZXQsIG1paS0+cGh5X2lkLA0KUEhZX01PREVfQ1RSTF9TVFMpOw0K
KwlyZXQgPSBzbXNjOTV4eF9tZGlvX3JlYWRfbm9wbShkZXYsIFBIWV9NT0RFX0NUUkxfU1RTKTsN
CiAJaWYgKHJldCA8IDApDQogCQlyZXR1cm4gcmV0Ow0KIA0KIAlyZXQgfD0gTU9ERV9DVFJMX1NU
U19FRFBXUkRPV05fOw0KIA0KLQlzbXNjOTV4eF9tZGlvX3dyaXRlX25vcG0oZGV2LT5uZXQsIG1p
aS0+cGh5X2lkLA0KUEhZX01PREVfQ1RSTF9TVFMsIHJldCk7DQorCXNtc2M5NXh4X21kaW9fd3Jp
dGVfbm9wbShkZXYsIFBIWV9NT0RFX0NUUkxfU1RTLCByZXQpOw0KIA0KIAkvKiBlbnRlciBTVVNQ
RU5EMSBtb2RlICovDQogCXJldCA9IHNtc2M5NXh4X3JlYWRfcmVnX25vcG0oZGV2LCBQTV9DVFJM
LCAmdmFsKTsNCg==
