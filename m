Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3605C40FB94
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 17:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243002AbhIQPQy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 11:16:54 -0400
Received: from mail-bn7nam10on2088.outbound.protection.outlook.com ([40.107.92.88]:46465
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S245045AbhIQPQD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Sep 2021 11:16:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lOcuVOiwjtiCqbuZILN6FDm2Jpz5dHLE8y59fYW0cL21PBphKm4Ei0xtLyfjofykF03hutE2QimhZ2Bi1Z0hqz+vveruoOemgSfRvMT6gkq5vWvyh9RtYejfKSeW9zpJLllq629HoOqL8yNcQcX7E5pMhpeNgqoomPftf1ZDT+0W6qOCleE+XnpclIoFMGLtYxzB0uelSa/IQqfCeFchACh2eXT7y/jupccpRnhMXA72Blws8f2u0Qdf2yLfIewnaQXC9TZQupqSbXh19sXxSe0PiCjQAuOtCqGQ1Rmyc2gRqKNiBS1DUnzUg++K/0X9x1SOvE3AxvgDdVgD7T6D/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=YReMQuBIPzwL0X2SQqdaw4bILayGeux92jRvC6HO64U=;
 b=mkb3/A5wTwqxcSQU5ZHNh6sZN9+nxDlgoDBqf1ayG9M9111C14MHp3jK2cXTiuQ14VL01pMfO80DbyflYXBy1Gzk4nmnZ3gh0uyob59ezK8xWOWwWCcGSWVqzOR9Ngq57HSr17EzHvmK0cbWlLNt7///QxtP92pzapTdQddIG7J7urCli7h/QkdA3Eo39bqjsJcNB5L7NKZ1vmncVMu3UVisjmsnATq9naCaJL7WJHXs7fsyxBOs7ywbl6Gs2ABqzvCJlI6Zl22SNkhdgr+vhd7MtexuL+WtntSZUOTNbbSY2qE1VkKO3FyC4QpVIJFycc9kAA5KOIdPGBYEdyx6Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YReMQuBIPzwL0X2SQqdaw4bILayGeux92jRvC6HO64U=;
 b=NsHvOY1HIJ9gMpzeLRPvj0UtsU59YcQanLgkCXYs9TNTokDKGncgnlQIjInirenJrIFQY50xJWUtUdVcl7+kpHh+aak0IXexKiE0edu1sPYD8G1lX9G1ilw0mS+XTwLR7ouJTkre0RBkTp1xqgTFixkDMF/jJainTo3XvO7gu00=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA0PR11MB4574.namprd11.prod.outlook.com (2603:10b6:806:71::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Fri, 17 Sep
 2021 15:14:28 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Fri, 17 Sep 2021
 15:14:28 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-mmc@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v6 04/24] wfx: add wfx.h
Date:   Fri, 17 Sep 2021 17:13:40 +0200
Message-Id: <20210917151401.2274772-5-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210917151401.2274772-1-Jerome.Pouiller@silabs.com>
References: <20210917151401.2274772-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: SA9PR03CA0029.namprd03.prod.outlook.com
 (2603:10b6:806:20::34) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (2a01:e34:ecb5:66a0:9876:e1d7:65be:d294) by SA9PR03CA0029.namprd03.prod.outlook.com (2603:10b6:806:20::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Fri, 17 Sep 2021 15:14:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4391df48-e124-4af0-f603-08d979edd798
X-MS-TrafficTypeDiagnostic: SA0PR11MB4574:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR11MB45748A94CA1313744107BD6593DD9@SA0PR11MB4574.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:773;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DJ2pg5ynumYgttNLk4FrtgduIu/PJzZyN1024eKuKVoBRkt1U2mewg3HG5qeK9dQl7Imr2eCU7KzdXtueyDkSu8vy4nkA/e1eoVLEg6X4V3SnUfxlKgY7pMsc1uDPmCKjSSMTjbOoehl4BI/JMbHLVr8BHXjl03jGgoeW/QtNkg9WX4D5NrQVsVVhm4nCkecjdhna+yH7dvJzZx7bNFvI6W8OdA5ErdmSszcREbcqcfhmC8cZHmZpu4cRH6J9MZW4oTK4WtCVPNjfxuAftiMGkDb97BN7yv5W1wiBJ7R2x/hxApooW7aQ1hHV0M2hqlugU26YdkoNUAQkHLUCOl9x7QDYKjUWGWLJXX6Rud+JoEo+qoi+nvbUSNZpj3UWNmAe8ybBQtWU9jyVfkR0u7/Cq6stdpotI9No2VKi4aeo22HK8g54srtiPgBAn7TO/Bozoz3M7QhS1VZNKoeEPq6fMQVqSRcC7Jn/BXK1uDsP9Y2LkSy/JHwV/DtEFrOQSh6VfRT1mh36FNaOdUCAtQzsMlORnP5oZ5iFmorVgRjQFtSntmmY2ediRzqKOwD+L15SsVM1GXJnsgEtJ+8zq0QxXNIjKEjYRp7DeJk2inWqiKdDGKDwjR8Ccu600qyBWyC1wuAZ21mjhbCFQ0ArAwKiA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(376002)(39850400004)(396003)(366004)(52116002)(6666004)(38100700002)(8936002)(7696005)(478600001)(6486002)(186003)(7416002)(86362001)(5660300002)(54906003)(66556008)(66476007)(4326008)(1076003)(66946007)(2616005)(107886003)(6916009)(316002)(36756003)(8676002)(66574015)(2906002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZTFhd2NHcEg5ZHhZSkVoTCtHc2dYNVdmUktPc09xOU9ITHNaSDA3dFBmL1kr?=
 =?utf-8?B?THkxN2RyQTRINjVYOExHVzBlM2M3V1Z2aGI2bWJIWWYrRzhWZWxtYktjTCs1?=
 =?utf-8?B?enJ3Tzl5U3JHSStFZlVyaVJOQzVsQVc4SW1tM3lXOTV6VjBLLzdqeXpFM24r?=
 =?utf-8?B?QnZDb3dDcm56V0RsaUp2QUd4ajFLZlZiSnN4UFpneVFDN1pscjduaWJQbWRD?=
 =?utf-8?B?eXVRaEpDTHBEMVNuV3pDTTNGYThDc2k2dW9qWWJBV2Vsdk84OW5ZTXZ5RU9m?=
 =?utf-8?B?Z0drbEV3aWlYSU50NUNORGF2a3JrQ0t6UDdRem4vU09SU2RDZ3hENC9hL201?=
 =?utf-8?B?dXZaVGZYVlZOM2hCa3k4dEdReWlEV2UxeDk5ekMzbGRYNGZ0Vkh4aHVXU3BV?=
 =?utf-8?B?MUYyb1BUQUx1dUZ6eUpaQi8ya3JwT2RVTTVUaTVCTnhKd0FNTksvLzFhV0JN?=
 =?utf-8?B?V2ZhNkxMZ1JrZVNKem5XSS94QlZkcXJNOG80OHpYVy9KT3c5bGtHQmxZM3h3?=
 =?utf-8?B?ZDVnc2l4QWVUbklKTVVMMGdTTE5zM3V1K0FHTktvVzFoTEF3a2UrMHZvZHVD?=
 =?utf-8?B?WWlOOUdiOTZjeUpMRkNzQ0VmdkZJenZHVnBSSDhlUCsvcGxOTlFqcng1M1hS?=
 =?utf-8?B?QlNLL2VIbmRLaWxBcjBGeTJVV0Z2VVA2L1pqRDBLdXVQT0VkVE5IQ3lkM0tN?=
 =?utf-8?B?NnM2SG03dEZXd2duNGJVTjJKQUhHWUF3c2xyNHYwM0JDbHF0UlNZSTJ3NHFR?=
 =?utf-8?B?V09nT2l0Q2tSQWZ6TDBycjlIWmp1TkY4SFlueTR1aHUveWY5YmVmNmR1TnJm?=
 =?utf-8?B?NEY3NVFyZWlteGorOTZnT280UDJRaXdlOHI5MVRkcGxyUE51SExteHhOOHhw?=
 =?utf-8?B?dGdORFRHNnBoYWJvSy8vRm5MamJ6WkJBSVFwNys2R2FwZEJHQ3UxblJMdlBm?=
 =?utf-8?B?NEVFREo3UzhqVXhnRzZMQk5vTjl1Y1Q0K3VtZU1xVjZOTVFBdGpOK29Wamdy?=
 =?utf-8?B?SWIyVnZqUHlYaklqMjU1NVpJdHBsVVVCTDFJQWYvUzNldzkrTkhnVE1MZVlC?=
 =?utf-8?B?RU1Zc0NlMjhNTnNnZ0c2cHAvd2RUYm56SCtaaGdzSWppS3laNGlmZVBRMUVn?=
 =?utf-8?B?MDUveXdHVWJ5N3EraUo5WTJxRDBBRDN5VW5BT3FjVmdLUU90Q20zaTJ2NlFz?=
 =?utf-8?B?dFJGbnE1ODMrT0xuandtZ3A2ejJZSkllTVMwcDhUenpWbDNZU2cwd3NjOEcv?=
 =?utf-8?B?NzBrSStGVk9NYjFpOVFMZlJUVkoyNXVGSzUvdWVpY2phODFpR3FTOW1KWmV6?=
 =?utf-8?B?OWtsWnpNWGJ6VWhwSDJpRFVLWDZJTWtsTlVQVzgxSVJIMkIxaGtGeG1Qd3Q1?=
 =?utf-8?B?SW9Xc2tuditoOFRrQTZiWTQ4L3kzdTh1RVluRlhVVU0rMFEzZ2loS25SM0c3?=
 =?utf-8?B?V0IvV0FPQklyZ0VQbjdMcXlaRis5Mm9hQ1hlcFNxZ0drZ2dYdnpNUmdjYk1w?=
 =?utf-8?B?NzNJNTNpYXJyb1VWTytOcE5SZ2NCV3FMbXZWTG04Vmx3THZKMCswTWlSMDIx?=
 =?utf-8?B?UCt1RTFRLy93TnJWV2hhOHdPeXFuTi9HeEtFNGIxanBWSU5pN2krTE51M2p3?=
 =?utf-8?B?NUZvRjJNY3BValNnaXZtRVhERkJNMm4reGc0TkRwT2V2VEF4MWhhdDJaS1Fy?=
 =?utf-8?B?Mm5YcXlGNGRuYU1mei9yNGxEaFRLd2RZTTRVZm1PcDZYdFA4RkJQV1VyZWUr?=
 =?utf-8?B?aDhHckdnZnZSQ2dmOVZsMjlYVXlrTDNoSUljVjhJUm81b0hVc0pZK2NHQ3lT?=
 =?utf-8?B?alFvZ3lSUU1uZzkrMDRoYjQ4dTN0ekRSS0tKa0pkakF4RW0yL2owUmdnM2NH?=
 =?utf-8?Q?lAfsXcEzknxhx?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4391df48-e124-4af0-f603-08d979edd798
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2021 15:14:28.3580
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eZF/A0juVblIkSoPdUu8EDeKXCaWYhZRbFqkuFMqOuIBWMr4KwarRzR4ZnxsNweRkOWOP8tmOtppxOILnU4C8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4574
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKU2ln
bmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29t
PgotLS0KIGRyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93Zngvd2Z4LmggfCAxNjQgKysrKysr
KysrKysrKysrKysrKysrKysrKysKIDEgZmlsZSBjaGFuZ2VkLCAxNjQgaW5zZXJ0aW9ucygrKQog
Y3JlYXRlIG1vZGUgMTAwNjQ0IGRyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93Zngvd2Z4LmgK
CmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9zaWxhYnMvd2Z4L3dmeC5oIGIvZHJp
dmVycy9uZXQvd2lyZWxlc3Mvc2lsYWJzL3dmeC93ZnguaApuZXcgZmlsZSBtb2RlIDEwMDY0NApp
bmRleCAwMDAwMDAwMDAwMDAuLmY4ZGY1OWFkMTYzOQotLS0gL2Rldi9udWxsCisrKyBiL2RyaXZl
cnMvbmV0L3dpcmVsZXNzL3NpbGFicy93Zngvd2Z4LmgKQEAgLTAsMCArMSwxNjQgQEAKKy8qIFNQ
RFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wLW9ubHkgKi8KKy8qCisgKiBDb21tb24gcHJp
dmF0ZSBkYXRhLgorICoKKyAqIENvcHlyaWdodCAoYykgMjAxNy0yMDIwLCBTaWxpY29uIExhYm9y
YXRvcmllcywgSW5jLgorICogQ29weXJpZ2h0IChjKSAyMDEwLCBTVC1Fcmljc3NvbgorICogQ29w
eXJpZ2h0IChjKSAyMDA2LCBNaWNoYWVsIFd1IDxmbGFtaW5naWNlQHNvdXJtaWxrLm5ldD4KKyAq
IENvcHlyaWdodCAyMDA0LTIwMDYgSmVhbi1CYXB0aXN0ZSBOb3RlIDxqYm5vdGVAZ21haWwuY29t
PiwgZXQgYWwuCisgKi8KKyNpZm5kZWYgV0ZYX0gKKyNkZWZpbmUgV0ZYX0gKKworI2luY2x1ZGUg
PGxpbnV4L2NvbXBsZXRpb24uaD4KKyNpbmNsdWRlIDxsaW51eC93b3JrcXVldWUuaD4KKyNpbmNs
dWRlIDxsaW51eC9tdXRleC5oPgorI2luY2x1ZGUgPGxpbnV4L25vc3BlYy5oPgorI2luY2x1ZGUg
PG5ldC9tYWM4MDIxMS5oPgorCisjaW5jbHVkZSAiYmguaCIKKyNpbmNsdWRlICJkYXRhX3R4Lmgi
CisjaW5jbHVkZSAibWFpbi5oIgorI2luY2x1ZGUgInF1ZXVlLmgiCisjaW5jbHVkZSAiaGlmX3R4
LmgiCisKKyNkZWZpbmUgVVNFQ19QRVJfVFhPUCAzMiAvKiBzZWUgc3RydWN0IGllZWU4MDIxMV90
eF9xdWV1ZV9wYXJhbXMgKi8KKyNkZWZpbmUgVVNFQ19QRVJfVFUgMTAyNAorCitzdHJ1Y3QgaHdi
dXNfb3BzOworCitzdHJ1Y3Qgd2Z4X2RldiB7CisJc3RydWN0IHdmeF9wbGF0Zm9ybV9kYXRhIHBk
YXRhOworCXN0cnVjdCBkZXZpY2UJCSpkZXY7CisJc3RydWN0IGllZWU4MDIxMV9odwkqaHc7CisJ
c3RydWN0IGllZWU4MDIxMV92aWYJKnZpZlsyXTsKKwlzdHJ1Y3QgbWFjX2FkZHJlc3MJYWRkcmVz
c2VzWzJdOworCWNvbnN0IHN0cnVjdCBod2J1c19vcHMJKmh3YnVzX29wczsKKwl2b2lkCQkJKmh3
YnVzX3ByaXY7CisKKwl1OAkJCWtleXNldDsKKwlzdHJ1Y3QgY29tcGxldGlvbglmaXJtd2FyZV9y
ZWFkeTsKKwlzdHJ1Y3QgaGlmX2luZF9zdGFydHVwCWh3X2NhcHM7CisJc3RydWN0IHdmeF9oaWYJ
CWhpZjsKKwlzdHJ1Y3QgZGVsYXllZF93b3JrCWNvb2xpbmdfdGltZW91dF93b3JrOworCWJvb2wJ
CQlwb2xsX2lycTsKKwlib29sCQkJY2hpcF9mcm96ZW47CisJc3RydWN0IG11dGV4CQljb25mX211
dGV4OworCisJc3RydWN0IHdmeF9oaWZfY21kCWhpZl9jbWQ7CisJc3RydWN0IHNrX2J1ZmZfaGVh
ZAl0eF9wZW5kaW5nOworCXdhaXRfcXVldWVfaGVhZF90CXR4X2RlcXVldWU7CisJYXRvbWljX3QJ
CXR4X2xvY2s7CisKKwlhdG9taWNfdAkJcGFja2V0X2lkOworCXUzMgkJCWtleV9tYXA7CisKKwlz
dHJ1Y3QgaGlmX3J4X3N0YXRzCXJ4X3N0YXRzOworCXN0cnVjdCBtdXRleAkJcnhfc3RhdHNfbG9j
azsKKwlzdHJ1Y3QgaGlmX3R4X3Bvd2VyX2xvb3BfaW5mbyB0eF9wb3dlcl9sb29wX2luZm87CisJ
c3RydWN0IG11dGV4CQl0eF9wb3dlcl9sb29wX2luZm9fbG9jazsKKwlpbnQJCQlmb3JjZV9wc190
aW1lb3V0OworfTsKKworc3RydWN0IHdmeF92aWYgeworCXN0cnVjdCB3ZnhfZGV2CQkqd2RldjsK
KwlzdHJ1Y3QgaWVlZTgwMjExX3ZpZgkqdmlmOworCXN0cnVjdCBpZWVlODAyMTFfY2hhbm5lbCAq
Y2hhbm5lbDsKKwlpbnQJCQlpZDsKKworCXUzMgkJCWxpbmtfaWRfbWFwOworCisJYm9vbAkJCWFm
dGVyX2R0aW1fdHhfYWxsb3dlZDsKKwlib29sCQkJam9pbl9pbl9wcm9ncmVzczsKKworCXN0cnVj
dCBkZWxheWVkX3dvcmsJYmVhY29uX2xvc3Nfd29yazsKKworCXN0cnVjdCB3ZnhfcXVldWUJdHhf
cXVldWVbNF07CisJc3RydWN0IHR4X3BvbGljeV9jYWNoZQl0eF9wb2xpY3lfY2FjaGU7CisJc3Ry
dWN0IHdvcmtfc3RydWN0CXR4X3BvbGljeV91cGxvYWRfd29yazsKKworCXN0cnVjdCB3b3JrX3N0
cnVjdAl1cGRhdGVfdGltX3dvcms7CisKKwl1bnNpZ25lZCBsb25nCQl1YXBzZF9tYXNrOworCisJ
LyogYXZvaWQgc29tZSBvcGVyYXRpb25zIGluIHBhcmFsbGVsIHdpdGggc2NhbiAqLworCXN0cnVj
dCBtdXRleAkJc2Nhbl9sb2NrOworCXN0cnVjdCB3b3JrX3N0cnVjdAlzY2FuX3dvcms7CisJc3Ry
dWN0IGNvbXBsZXRpb24Jc2Nhbl9jb21wbGV0ZTsKKwlpbnQJCQlzY2FuX25iX2NoYW5fZG9uZTsK
Kwlib29sCQkJc2Nhbl9hYm9ydDsKKwlzdHJ1Y3QgaWVlZTgwMjExX3NjYW5fcmVxdWVzdCAqc2Nh
bl9yZXE7CisKKwlzdHJ1Y3QgY29tcGxldGlvbglzZXRfcG1fbW9kZV9jb21wbGV0ZTsKK307CisK
K3N0YXRpYyBpbmxpbmUgc3RydWN0IHdmeF92aWYgKndkZXZfdG9fd3ZpZihzdHJ1Y3Qgd2Z4X2Rl
diAqd2RldiwgaW50IHZpZl9pZCkKK3sKKwlpZiAodmlmX2lkID49IEFSUkFZX1NJWkUod2Rldi0+
dmlmKSkgeworCQlkZXZfZGJnKHdkZXYtPmRldiwgInJlcXVlc3Rpbmcgbm9uLWV4aXN0ZW50IHZp
ZjogJWRcbiIsIHZpZl9pZCk7CisJCXJldHVybiBOVUxMOworCX0KKwl2aWZfaWQgPSBhcnJheV9p
bmRleF9ub3NwZWModmlmX2lkLCBBUlJBWV9TSVpFKHdkZXYtPnZpZikpOworCWlmICghd2Rldi0+
dmlmW3ZpZl9pZF0pCisJCXJldHVybiBOVUxMOworCXJldHVybiAoc3RydWN0IHdmeF92aWYgKil3
ZGV2LT52aWZbdmlmX2lkXS0+ZHJ2X3ByaXY7Cit9CisKK3N0YXRpYyBpbmxpbmUgc3RydWN0IHdm
eF92aWYgKnd2aWZfaXRlcmF0ZShzdHJ1Y3Qgd2Z4X2RldiAqd2RldiwKKwkJCQkJICAgc3RydWN0
IHdmeF92aWYgKmN1cikKK3sKKwlpbnQgaTsKKwlpbnQgbWFyayA9IDA7CisJc3RydWN0IHdmeF92
aWYgKnRtcDsKKworCWlmICghY3VyKQorCQltYXJrID0gMTsKKwlmb3IgKGkgPSAwOyBpIDwgQVJS
QVlfU0laRSh3ZGV2LT52aWYpOyBpKyspIHsKKwkJdG1wID0gd2Rldl90b193dmlmKHdkZXYsIGkp
OworCQlpZiAobWFyayAmJiB0bXApCisJCQlyZXR1cm4gdG1wOworCQlpZiAodG1wID09IGN1cikK
KwkJCW1hcmsgPSAxOworCX0KKwlyZXR1cm4gTlVMTDsKK30KKworc3RhdGljIGlubGluZSBpbnQg
d3ZpZl9jb3VudChzdHJ1Y3Qgd2Z4X2RldiAqd2RldikKK3sKKwlpbnQgaTsKKwlpbnQgcmV0ID0g
MDsKKwlzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZjsKKworCWZvciAoaSA9IDA7IGkgPCBBUlJBWV9TSVpF
KHdkZXYtPnZpZik7IGkrKykgeworCQl3dmlmID0gd2Rldl90b193dmlmKHdkZXYsIGkpOworCQlp
ZiAod3ZpZikKKwkJCXJldCsrOworCX0KKwlyZXR1cm4gcmV0OworfQorCitzdGF0aWMgaW5saW5l
IHZvaWQgbWVtcmV2ZXJzZSh1OCAqc3JjLCB1OCBsZW5ndGgpCit7CisJdTggKmxvID0gc3JjOwor
CXU4ICpoaSA9IHNyYyArIGxlbmd0aCAtIDE7CisJdTggc3dhcDsKKworCXdoaWxlIChsbyA8IGhp
KSB7CisJCXN3YXAgPSAqbG87CisJCSpsbysrID0gKmhpOworCQkqaGktLSA9IHN3YXA7CisJfQor
fQorCitzdGF0aWMgaW5saW5lIGludCBtZW16Y21wKHZvaWQgKnNyYywgdW5zaWduZWQgaW50IHNp
emUpCit7CisJdTggKmJ1ZiA9IHNyYzsKKworCWlmICghc2l6ZSkKKwkJcmV0dXJuIDA7CisJaWYg
KCpidWYpCisJCXJldHVybiAxOworCXJldHVybiBtZW1jbXAoYnVmLCBidWYgKyAxLCBzaXplIC0g
MSk7Cit9CisKKyNlbmRpZgotLSAKMi4zMy4wCgo=
