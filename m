Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2772A293CC0
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 15:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406880AbgJTM7L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 08:59:11 -0400
Received: from mail-dm6nam12on2042.outbound.protection.outlook.com ([40.107.243.42]:21473
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2406822AbgJTM7G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 08:59:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EUdoOqYor5Hl+P7LqXNOqQbOQM+LRIc8/cwliAHRvjeqbjJUmXvVwNFpUUyYyHtkb9BtBqhlFyK+os7zexED8y28XFHR+xGeAlqHJVJf7lq3CEsR/VON+py/MCRoIwHrHTDoXZMpKkXKx0b5jtyRtB3I80SOR2u20bHqAAdIIb6bFCIBSH6+Lm+7+phMpBC2hH/K9xdp1yaJ55quRZYyxXCxAhfm4QNLptp8P5rWm9knQbnFJl3DVr+54EVQpTY56kH0Z+4aglAJSAcoJM0mIQwjJaXEWKuK4Xdy+8RJtF+iikX4WGoMVIGeiNvRlC+8n5xjqBFkYUuSKIfWYVSXlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sj+FvaSzNUL70rljsFsFSy63ayCemnk7bCXXALwJfCM=;
 b=WaVxIclEl4dKr2WOrP9GQz4mRc5mbHG8E9h3VQg7E45yHcTqFggibUh3pExhAJhXs2tBMgBUDdDPjgMruITUyTAxfvvtsBAjft3Qt9Q0HoatXYveTmDfgqbDsBQBZ/XXf0YNAOAMhqCQHoEUe6KcQY/SPApworUDr6UCjt0d/GRK6QBdZElqyn/QppfJEyqE9TYH5cY80Nf1Ka1l+pzB9gejMux0zCuWVDfpl+QhiGSnljUTFupZN1BgBX0XBALhX2su2++Zq7MsEvV+u61h9D8SVm2WmlSaTsB1IzRKeotiyMy8CDZTrtUhOpOpBwfgwnfiHCenMiUT8xifpTW0CQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sj+FvaSzNUL70rljsFsFSy63ayCemnk7bCXXALwJfCM=;
 b=LropplEPzZ+t9iSMS/Q+2gja/V3xXQEqXP6gc82432n4VsZZuPf4UPOzxtSsuDpuGUDJ/84SoKD/mhaMieD6X+eHB976qthiIc2WmgJ/e88jJ2VTMhpbjitT4hVmB3Rfqv314pgmLsaACMRunXeEgkC7tOC6AMahOttXTcDcPxU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB2656.namprd11.prod.outlook.com (2603:10b6:805:58::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.28; Tue, 20 Oct
 2020 12:58:55 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::4f5:fbe5:44a7:cb8a]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::4f5:fbe5:44a7:cb8a%5]) with mapi id 15.20.3477.028; Tue, 20 Oct 2020
 12:58:55 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-mmc@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v2 06/24] wfx: add bus.h
Date:   Tue, 20 Oct 2020 14:57:59 +0200
Message-Id: <20201020125817.1632995-7-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201020125817.1632995-1-Jerome.Pouiller@silabs.com>
References: <20201020125817.1632995-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Originating-IP: [37.71.187.125]
X-ClientProxiedBy: PR3P192CA0026.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:102:56::31) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (37.71.187.125) by PR3P192CA0026.EURP192.PROD.OUTLOOK.COM (2603:10a6:102:56::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21 via Frontend Transport; Tue, 20 Oct 2020 12:58:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 74aedc56-9e8e-4bc0-278e-08d874f7e6a7
X-MS-TrafficTypeDiagnostic: SN6PR11MB2656:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB2656B0830D3FC1D093D74993931F0@SN6PR11MB2656.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:421;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l6j+YohVet8MKUpXfHlAiFdQ3jnmB8q3dAz2xBWiuJVBr4BUwsSoeuliy1BqimDolvAvnRB8aa63yy3xrnukKYwmya0gpPC4c61+XbpXdY8MTkT0OdSUlrUiNr5QsOln+hJv0B5dYWQjzva1+QXqe93YqNN3frQKyepTCwihkFbKa47XYLSsg2ME+2rdflyv0mUdeVRziB9yWMuiOwrhq8yXVefy3xs7OCq1RP76eBOig53bsw/vfSRmCWo/gvmUbkNzhQbTMstPouBsF1sDf8QxK8Ph2heSj806leMBDfvqOZv1E1SguCaZa5QCowhb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(136003)(39830400003)(346002)(376002)(186003)(316002)(4326008)(107886003)(8676002)(86362001)(26005)(2906002)(7696005)(478600001)(16526019)(956004)(6486002)(52116002)(36756003)(8936002)(2616005)(54906003)(5660300002)(1076003)(7416002)(66574015)(66556008)(66476007)(66946007)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 6G9sEpBjfdj/Bl6OTZ5BvOzLRV6JY5bEAcYmurZxwrd506h0e79nQfmeuNsFHNKpOCfy1IzQAMnAaIqVA8iUbn8UMjgqwJPseEcBXfZX3VSXHvKS3S5dsmqcgRn2VXCVfdDxm9eFzurFlcqrv/kG4Jgp6NHZo7cHJnVpA5zLXkDiWJ8ZHn4145JNcFeRidnV5mLF7azUsTr/2DKxQrkj4ZxxT9p2gAG4mcmUgehEbr+TPTkOZo0RZ3BCdsBfPmV6kTqlw9ACd4Ov5zhZcodIU/5oYhm4f1Kaw3qvAWihb3HDwrfV7QGICKHvGyPZUxxrhuDQwgHJdGlYSWPLc0TBzchjMSotIU1fmlCH1d5fccrHlyXJYp9ih1PMbg9NLM7pIYB7mntAYSPmC1HjE5hJ7ICWb1hoom2xYBqvSQcxwsycSedPiiDRi+00N8YauGcCruJXdr5Sg49K5kXwwHeYkC16HC+p8EL6hsKiK18Zb5/rdq2wy8du8I25F0tzPS5+0xu/gWhBvDySqkvpV1IDZdS1UmmD87IUgUjBQgTdxE73ucKjl5mvwbVGm95lbAcJzWaW/GrKQoHQGrxfUQIwNrjSb+CYsrb+zxtyfBsD0XHiXoZ9kZ6BBgKxei1JCzgIYFYb4I5QNPth1iz7epnw3w==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74aedc56-9e8e-4bc0-278e-08d874f7e6a7
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2020 12:58:54.9592
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GDIysAXmgASqv4SR/gGOR3ukkvgAhy9LIm6o9L/h27UtQCuCTdN2P37ScYn6LqXLUQtC/DNoMRdzlOIfrvK2ww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2656
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKU2ln
bmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29t
PgotLS0KIGRyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93ZngvYnVzLmggfCAzOCArKysrKysr
KysrKysrKysrKysrKysrKysrKysKIDEgZmlsZSBjaGFuZ2VkLCAzOCBpbnNlcnRpb25zKCspCiBj
cmVhdGUgbW9kZSAxMDA2NDQgZHJpdmVycy9uZXQvd2lyZWxlc3Mvc2lsYWJzL3dmeC9idXMuaAoK
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93ZngvYnVzLmggYi9kcml2
ZXJzL25ldC93aXJlbGVzcy9zaWxhYnMvd2Z4L2J1cy5oCm5ldyBmaWxlIG1vZGUgMTAwNjQ0Cmlu
ZGV4IDAwMDAwMDAwMDAwMC4uY2EwNGIzZGE2MjA0Ci0tLSAvZGV2L251bGwKKysrIGIvZHJpdmVy
cy9uZXQvd2lyZWxlc3Mvc2lsYWJzL3dmeC9idXMuaApAQCAtMCwwICsxLDM4IEBACisvKiBTUERY
LUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMC1vbmx5ICovCisvKgorICogQ29tbW9uIGJ1cyBh
YnN0cmFjdGlvbiBsYXllci4KKyAqCisgKiBDb3B5cmlnaHQgKGMpIDIwMTctMjAyMCwgU2lsaWNv
biBMYWJvcmF0b3JpZXMsIEluYy4KKyAqIENvcHlyaWdodCAoYykgMjAxMCwgU1QtRXJpY3Nzb24K
KyAqLworI2lmbmRlZiBXRlhfQlVTX0gKKyNkZWZpbmUgV0ZYX0JVU19ICisKKyNpbmNsdWRlIDxs
aW51eC9tbWMvc2Rpb19mdW5jLmg+CisjaW5jbHVkZSA8bGludXgvc3BpL3NwaS5oPgorCisjZGVm
aW5lIFdGWF9SRUdfQ09ORklHICAgICAgICAweDAKKyNkZWZpbmUgV0ZYX1JFR19DT05UUk9MICAg
ICAgIDB4MQorI2RlZmluZSBXRlhfUkVHX0lOX09VVF9RVUVVRSAgMHgyCisjZGVmaW5lIFdGWF9S
RUdfQUhCX0RQT1JUICAgICAweDMKKyNkZWZpbmUgV0ZYX1JFR19CQVNFX0FERFIgICAgIDB4NAor
I2RlZmluZSBXRlhfUkVHX1NSQU1fRFBPUlQgICAgMHg1CisjZGVmaW5lIFdGWF9SRUdfU0VUX0dF
Tl9SX1cgICAweDYKKyNkZWZpbmUgV0ZYX1JFR19GUkFNRV9PVVQgICAgIDB4NworCitzdHJ1Y3Qg
aHdidXNfb3BzIHsKKwlpbnQgKCpjb3B5X2Zyb21faW8pKHZvaWQgKmJ1c19wcml2LCB1bnNpZ25l
ZCBpbnQgYWRkciwKKwkJCSAgICB2b2lkICpkc3QsIHNpemVfdCBjb3VudCk7CisJaW50ICgqY29w
eV90b19pbykodm9pZCAqYnVzX3ByaXYsIHVuc2lnbmVkIGludCBhZGRyLAorCQkJICBjb25zdCB2
b2lkICpzcmMsIHNpemVfdCBjb3VudCk7CisJaW50ICgqaXJxX3N1YnNjcmliZSkodm9pZCAqYnVz
X3ByaXYpOworCWludCAoKmlycV91bnN1YnNjcmliZSkodm9pZCAqYnVzX3ByaXYpOworCXZvaWQg
KCpsb2NrKSh2b2lkICpidXNfcHJpdik7CisJdm9pZCAoKnVubG9jaykodm9pZCAqYnVzX3ByaXYp
OworCXNpemVfdCAoKmFsaWduX3NpemUpKHZvaWQgKmJ1c19wcml2LCBzaXplX3Qgc2l6ZSk7Cit9
OworCitleHRlcm4gc3RydWN0IHNkaW9fZHJpdmVyIHdmeF9zZGlvX2RyaXZlcjsKK2V4dGVybiBz
dHJ1Y3Qgc3BpX2RyaXZlciB3Znhfc3BpX2RyaXZlcjsKKworI2VuZGlmCi0tIAoyLjI4LjAKCg==
