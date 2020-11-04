Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C359A2A6899
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 16:56:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731016AbgKDPwx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 10:52:53 -0500
Received: from mail-dm6nam11on2049.outbound.protection.outlook.com ([40.107.223.49]:54240
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730968AbgKDPwu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 10:52:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JfWtwCOj2zowsK7OAdtjdinK+3UYpuphK1yRgzZbjvDTBkwbioM8ksItootBOIjtCG46i6cDAH6rulJ5mYVBDwYKnZtKy4rW3qYnPo6MSSE2aJRXyXczo7FYYEUxuQfxD4xZl1cPQeyVCO9U5WA6GWQ4/IBqGPdfUZSfDZHotsNCJAwIocK28pyNUp0Z/rLG6CqB+YEZHp2N3OZdsEhEMc9L2Bh0t+wlAdRKsEEtgGmlDUy4bkTFk5b2UbNrCcS1C27k01u1VhhAbFMlxLGosjiMCruimXdvOutTd2TEZaboneRkyYjfgZgZujFnztQR5fqtZ/65/ZhmUhxutwrBCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sj+FvaSzNUL70rljsFsFSy63ayCemnk7bCXXALwJfCM=;
 b=A08+8mPSB7gt6qLgBzL41XN4HiY26PE3e1sIdDR3goyajd5o9ZebNfo+HXzdOeUlxwXdtkkn7tzUfwLBtyc5hku26UIgFeI1tse8TRmH0N0z4efNHkIP+LBfmgWDc7447ddTuuj6dyeByX7Ui543W1e/KVuloLezQbXFXXh0fK0OX7mWz9LmcQ/6fOp1CmtiodEolaHr3E291YIRVs+whg8SeEDfRq8vy0biiRj3aT2oVrMbIUFLefk2GhPPYL0vJmJ0IXIpkWD0JMABWB0jWgkodlZyOVwvQ0sMkAhnEqIMN75TAIvBA8TtFEvibtkmAAmSWg1+5LFJnS6aOn7mow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sj+FvaSzNUL70rljsFsFSy63ayCemnk7bCXXALwJfCM=;
 b=S9QWxj1XaV4kZsTR3MT8jyaTRhx5FHsHIEUZYPQmHPCTDT8VOeguncloqakcYnqSQWB5gIU4GVrAD/g5FP4mKlxyl5XXMI7qLoDLiGE4N0jNotB6Xv4UVqhnzlC+sKn7Gel7LUikCR3FycrQtG6pr+h6rxloiwyfg+GIpFms2q4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.32; Wed, 4 Nov
 2020 15:52:35 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::4f5:fbe5:44a7:cb8a]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::4f5:fbe5:44a7:cb8a%5]) with mapi id 15.20.3499.032; Wed, 4 Nov 2020
 15:52:35 +0000
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
Subject: [PATCH v3 06/24] wfx: add bus.h
Date:   Wed,  4 Nov 2020 16:51:49 +0100
Message-Id: <20201104155207.128076-7-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201104155207.128076-1-Jerome.Pouiller@silabs.com>
References: <20201104155207.128076-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Originating-IP: [82.67.86.106]
X-ClientProxiedBy: SN6PR01CA0032.prod.exchangelabs.com (2603:10b6:805:b6::45)
 To SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (82.67.86.106) by SN6PR01CA0032.prod.exchangelabs.com (2603:10b6:805:b6::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.19 via Frontend Transport; Wed, 4 Nov 2020 15:52:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 21f4aa8b-acf7-4b94-28e2-08d880d9a5dc
X-MS-TrafficTypeDiagnostic: SN6PR11MB2718:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB2718A364FE6C3D6EA727061C93EF0@SN6PR11MB2718.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:421;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: guQPnc13TVkt1jEH8uZDxPqh0uQCjDoLRnd98SFgUAyLOhZICYvveyBKrPpsELsoafaTSvD2Ot1Rq6pbhBZ8UyKWKB3ArgW27/CM2EqAq8/maiUatpS4O17Y+Jowlh37BCDLnQriyvPX2DG4TmR8IQU18D12pmNeJEcSLLxpduBiB8ADt1nWXmwSqZVIV0bWINsfgwEI9yS4fULw8ZWiUwxRuHoj0bbW3JfRK/24DT3+n0U4u7+bLemNv0CNj+gCAgV5vJrXtsIbMvuSePBoCjaJsGD3xMZ2nxr9009GTJMwACZZsbW57JqS5dTEt9R8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(376002)(39850400004)(136003)(396003)(8936002)(478600001)(186003)(16526019)(956004)(2616005)(6486002)(8676002)(66574015)(66476007)(66556008)(66946007)(316002)(7696005)(6666004)(83380400001)(26005)(54906003)(107886003)(36756003)(52116002)(7416002)(4326008)(5660300002)(86362001)(1076003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: NzWtIhBtHBMXCr0DfxFFvVTI0jhdmyICA+vacrOKByjlxxu1zY/KGXCg4HI4wxxqpd/qEEDcCW9g0nNWzECySTUnGvWDFk+9jjvQzqKQkibFrcJbgQViOgn8imp/FBCSbO+LYd65calIytdvzM1Yorm3Hv29Jzua6dvQaQPrSBdW3uE4+k4zGU+/FQLMNFLyMuvSb4v5DMGEg7l0JLttn3O94FMTlPaVnLU99YHFybFs5g9x1EIy1zRAoiQiscYc0+jnALuVxhnEYqFR8Ud5zKlhIqKz94G9Pf3gBdpH+uRh+3EekQed/ZfGHh0Qvj8I3MKjf8xmmq57rlOOeLpu819p41ONYpWB/ZgJRnlsiegDH+y/YGfr96DlLX7X/OWzFqW59s23tXT/yZmDdnDRyiTe03/1fgw3N7bJUMysBs5Q9KY1wXCvbOPHcig3CEZfxAK9nWXPKGYR1ZpO91QbtqK55FQQxecLuNzknHoMcJzPlxDPv9F9qtpAZ/tDm4snuZD7lEDzlCCnFQl9OdilTdcjgmVw62z0ydLLzjmTgPyY9E3zJqtnvmb+pXZ0KVhxCdnsgpafX7QUfcqL+DBkKKJPHwIBYP0fz0iJFuSrNda956ob++0Ln+OnXCZAttz9N40MRPxLePtNQmQofvxJPg==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21f4aa8b-acf7-4b94-28e2-08d880d9a5dc
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2020 15:52:35.4621
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eA55/wyzM/SiyRMkEHFf2y+h2t/AFJQ3iz7LVAy28+2Uu/a2rVfXPheo61i4CuJO+UW4CtMuMYgekUB5rhbwrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2718
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
