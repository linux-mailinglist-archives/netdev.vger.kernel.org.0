Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44F952E1E6F
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 16:43:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729031AbgLWPlU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 10:41:20 -0500
Received: from mail-mw2nam12on2073.outbound.protection.outlook.com ([40.107.244.73]:3743
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728987AbgLWPlS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Dec 2020 10:41:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=It1vcXUwlVJmsOQFMELfVB4MVcPV806DrEcggpEpTYPBRatPGgiD648a0L4tv15O5PCn+8csEClwJSsrLm9C6X2Kruw35672VYYfVTWMF4LY87R3matPdNAVjGlMPCEHZgHVTgvHnRvkzOP/jC+s3Sme5m4DhOv0pmDBMURzZ0eLyrqlJ2ZuMh07aY0z/Hlp8I/rBHULsgDNVspDvLNUZ/dS+E5mVBFGODlEA3IwKsVnUrnmWcVq6a0iJh81XULU6ibLJ509ZuvCfYse5iOz5Xp0OOo3jF7+4Nz2yuv17+jWkBl/hXWrsUnK2saG0D1zFSEBoIIZYqVtiJ24bvfYGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pWX8mQ0DDWqlFWPCuqFYYmRcolwxsRRG4ddQkA96Rec=;
 b=FdqK2htX+hbGe8SMPk1ljXIoyGWWAjjDoY3loWMEff4QFhtmQ8gCnT2JuJeJl8cdm9skvhmQiEjQZroBcwBFDYfcll8S/r9+bAf1LrSBrcu4U2SU3ZyNKF3RMQFxSAMJPdL1ruvTKcrKd/u5z7pNWvrMzflYe6qeAWCBEBrCKVJK8vRaZRgnAncdYOd98rxkj//gNgQWwMXNyqijq3QY+K8j3Y90qNtNsNSjyrpGTYF9jzvIJzK25ZbsVQYrNEpcaFuL1K8+oON6Pnti5u1PCmNIeDRksgR4Oc/f37yNLradNh3GJ+E2NdeVKjtHAcmSEytWYfZrW/sOjsFLOVy89A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pWX8mQ0DDWqlFWPCuqFYYmRcolwxsRRG4ddQkA96Rec=;
 b=akHMVElWHAs8TtSe/kEIKOnr3A7AdgAnOZ2Cj2sW73AtKnw9oPeFDsI5mE7/nap3bivVr79vmvNMqE3fSDaYgaydYwrQNGqnMBbTagq5oJp2Htca969o78++iHFN8n9chJo2AighapcDXUBzjd+XXYKiKu5k3g0pvnxRkjAuk00=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB2815.namprd11.prod.outlook.com (2603:10b6:805:62::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.25; Wed, 23 Dec
 2020 15:39:50 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::a989:f850:6736:97ca]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::a989:f850:6736:97ca%5]) with mapi id 15.20.3700.026; Wed, 23 Dec 2020
 15:39:49 +0000
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
Subject: [PATCH v4 03/24] wfx: add Makefile/Kconfig
Date:   Wed, 23 Dec 2020 16:39:04 +0100
Message-Id: <20201223153925.73742-4-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201223153925.73742-1-Jerome.Pouiller@silabs.com>
References: <20201223153925.73742-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Originating-IP: [82.67.86.106]
X-ClientProxiedBy: SA0PR12CA0024.namprd12.prod.outlook.com
 (2603:10b6:806:6f::29) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (82.67.86.106) by SA0PR12CA0024.namprd12.prod.outlook.com (2603:10b6:806:6f::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3700.27 via Frontend Transport; Wed, 23 Dec 2020 15:39:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f7566b0b-3c26-4d24-ff53-08d8a758fc01
X-MS-TrafficTypeDiagnostic: SN6PR11MB2815:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB2815BE109EC48BF9B362E3F293DE0@SN6PR11MB2815.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pszfXfGRBvPMFm9f4ZOIzkvFsMxc+b6fKsfN2y+kV726HZO2G1B7+XNrPmW5/wKGi84759MPYftgt5iNhJedT+WALGsgDgzkF6xPomcmnuE7NqDo3vmPbPt5EBhg0QTAL0F4ccFw+foRCt1cvQDrL+p4l33nbZKuLxMQHKXtHic9J1fTk8vx2McpfvM41DtCzi/4zBevS7wBHYjy/8vSG+6XbF25GtuqvhSlZSQpEXdjQRIcpMtc+m04RE7P9LOKgz58FOmZY2gUElI5ebJfVoeDRsQ9PFLPJIX0fBP1fpoiPBkNyJvkgAmJGtJja4hNPXXM207qCKwZs5ad0ba7hn3dQQpQ//PKCK6/d+07ONT7eeAJoGQQEEME9Rrfx9I3QR26AkddbZdOZES1sEn9rw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(366004)(376002)(39850400004)(346002)(66574015)(478600001)(8676002)(186003)(2906002)(8936002)(26005)(52116002)(107886003)(16526019)(7696005)(66946007)(7416002)(6486002)(956004)(2616005)(54906003)(66476007)(316002)(4326008)(6666004)(36756003)(5660300002)(1076003)(86362001)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?WDFBZS9aRVNiZndtWFpMNDFQa2xqM2NqQ2pFWUxVc28zZWRxeFpERFh3d2NV?=
 =?utf-8?B?R2tVL3dJWkhCMkR3MlJOWERtM3hUZDRQUDJuK2tMcDhYbzFxN1VEeUlpNG1p?=
 =?utf-8?B?c0xncElmVUpzazdLcFAxdFFVUERHUGJPbysrSzUrbHFxRjhxeUdBY2srN1hz?=
 =?utf-8?B?VHNIQjcxRGowbVhiTmdWOWhqWndSWTZvRmtNTnkwUFhIRmw0dnAvbDRXbTg0?=
 =?utf-8?B?dFRkcFhZZ0ttbUFZVnhJSHdWQVNnd0laRXREbFFYeHVTU1Q2TVVYNi8wY0Vy?=
 =?utf-8?B?R1UxRys4T3FnSzd0THJmOUVmMDlIVndDaGh0UHNGTG9BcjNQYjJCSHhOUkZT?=
 =?utf-8?B?UFYxanhha01MN1Zka2VSN1c4WUFQbWVYLzloNEh2dGF2WjFUU3RaN0dOWmJj?=
 =?utf-8?B?TU1SdXhHOWRYTXRTVk5JMk5NMFZRemx6elJOMUVYS3NKRDZDS2dMK2xiaHZy?=
 =?utf-8?B?Ykhra0MyWTJCaTRiV0dxTCtnUDlNZ3lOeEVObzI1Ukl5N1lvYXBDcmRoVFZT?=
 =?utf-8?B?cktFakJrOTc0V1RSbnQvdEJudjhyZWd3WmNHWFVUY0tTcS9acmVUR1FCc0JQ?=
 =?utf-8?B?SGhHV3RYS3lNZ2M5bnl5RE1wTGNHSEg4SEF3Mjh2NkZoMjRySmwyYkNySWtF?=
 =?utf-8?B?REpwdSt0VHBwNkF4alFxY3BsNzJmNjdTcG9mMENHb29yNmNlM3FjNHBkcGFD?=
 =?utf-8?B?Vk81YnVsWHo5TFBBUjhLWktQRTZaTnJEbHZGbmVIdVBNclpTdnAvRENrMzZP?=
 =?utf-8?B?WlFKYmRuS1JQeE1OcUNDNFo4UkM2OW9EL2lKV1hodUpUQWI4VkNCeko5T0F1?=
 =?utf-8?B?RXhiaDVQSU1MR1hoc2J4ci95OTdUMzA5eE5RdE85aGZyRU9pTStQRDFPeFA4?=
 =?utf-8?B?cTMwQVI3UlJSNHdGMFVsdUE5UDNQY2NSRTE4aTZnTmllTmp5cjhtUCtkZHgv?=
 =?utf-8?B?b0JlNlhTdytRZk1tVEFwTUZGRTZQUTUvRXB1ZWlsTzBTd2dhWTYzRmF4dVVV?=
 =?utf-8?B?REVBV2dXejlqYWVwMHlWcVM0bmZUN3FGcWpjUlRXYWc1MUhWRmRoR1o4SllW?=
 =?utf-8?B?SGZSeHhFa1RZTjQyMnVTSEJvU1M3MWR5UW1wcDAvdzhwdW9kc3FHb1RBeGRx?=
 =?utf-8?B?d3ZCaW5Vc2QyQkhhUWpLMXJ4Yk5FQk5rSW53QzFkUTlibENtQ0E0aHlHV3Ay?=
 =?utf-8?B?UlFEREJjSHVleVBRc2VkbFh4UzFhT256d1lRQm9LU09kZHZqcnRRUUJneXB0?=
 =?utf-8?B?YXllU1ZrVUxCNG5GVGxzbVB5RDdjaDhuOFArdGRsQnFtczh6ZjQ1WDRFZ2JZ?=
 =?utf-8?Q?haWgFJmGF1jxY802rQYmClMsQgPYVgBR++?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2020 15:39:49.8975
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-Network-Message-Id: f7566b0b-3c26-4d24-ff53-08d8a758fc01
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JlZYGdumzQwLcmrkiZsuBwKBYjbJ6oZTT/hb6quZ8HPkPPIhkc4j2ng3QxX/rvdTknjQoDnrGn+XqFXEA8B0Ig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2815
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKU2ln
bmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29t
PgotLS0KIGRyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93ZngvS2NvbmZpZyAgfCAxMiArKysr
KysrKysrKwogZHJpdmVycy9uZXQvd2lyZWxlc3Mvc2lsYWJzL3dmeC9NYWtlZmlsZSB8IDI2ICsr
KysrKysrKysrKysrKysrKysrKysrKwogMiBmaWxlcyBjaGFuZ2VkLCAzOCBpbnNlcnRpb25zKCsp
CiBjcmVhdGUgbW9kZSAxMDA2NDQgZHJpdmVycy9uZXQvd2lyZWxlc3Mvc2lsYWJzL3dmeC9LY29u
ZmlnCiBjcmVhdGUgbW9kZSAxMDA2NDQgZHJpdmVycy9uZXQvd2lyZWxlc3Mvc2lsYWJzL3dmeC9N
YWtlZmlsZQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93ZngvS2Nv
bmZpZyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93ZngvS2NvbmZpZwpuZXcgZmlsZSBt
b2RlIDEwMDY0NAppbmRleCAwMDAwMDAwMDAwMDAuLjNiZTRiMWU3MzVlMQotLS0gL2Rldi9udWxs
CisrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93ZngvS2NvbmZpZwpAQCAtMCwwICsx
LDEyIEBACitjb25maWcgV0ZYCisJdHJpc3RhdGUgIlNpbGljb24gTGFicyB3aXJlbGVzcyBjaGlw
cyBXRjIwMCBhbmQgZnVydGhlciIKKwlkZXBlbmRzIG9uIE1BQzgwMjExCisJZGVwZW5kcyBvbiBN
TUMgfHwgIU1NQyAjIGRvIG5vdCBhbGxvdyBXRlg9eSBpZiBNTUM9bQorCWRlcGVuZHMgb24gKFNQ
SSB8fCBNTUMpCisJaGVscAorCSAgVGhpcyBpcyBhIGRyaXZlciBmb3IgU2lsaWNvbnMgTGFicyBX
Rnh4eCBzZXJpZXMgKFdGMjAwIGFuZCBmdXJ0aGVyKQorCSAgY2hpcHNldHMuIFRoaXMgY2hpcCBj
YW4gYmUgZm91bmQgb24gU1BJIG9yIFNESU8gYnVzZXMuCisKKwkgIFNpbGFicyBkb2VzIG5vdCB1
c2UgYSByZWxpYWJsZSBTRElPIHZlbmRvciBJRC4gU28sIHRvIGF2b2lkIGNvbmZsaWN0cywKKwkg
IHRoZSBkcml2ZXIgd29uJ3QgcHJvYmUgdGhlIGRldmljZSBpZiBpdCBpcyBub3QgYWxzbyBkZWNs
YXJlZCBpbiB0aGUKKwkgIERldmljZSBUcmVlLgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2ly
ZWxlc3Mvc2lsYWJzL3dmeC9NYWtlZmlsZSBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93
ZngvTWFrZWZpbGUKbmV3IGZpbGUgbW9kZSAxMDA2NDQKaW5kZXggMDAwMDAwMDAwMDAwLi5mMzk5
OTYyYzg2MTkKLS0tIC9kZXYvbnVsbAorKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9zaWxhYnMv
d2Z4L01ha2VmaWxlCkBAIC0wLDAgKzEsMjYgQEAKKyMgU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6
IEdQTC0yLjAKKworIyBOZWNlc3NhcnkgZm9yIENSRUFURV9UUkFDRV9QT0lOVFMKK0NGTEFHU19k
ZWJ1Zy5vID0gLUkkKHNyYykKKword2Z4LXkgOj0gXAorCWJoLm8gXAorCWh3aW8ubyBcCisJZndp
by5vIFwKKwloaWZfdHhfbWliLm8gXAorCWhpZl90eC5vIFwKKwloaWZfcngubyBcCisJcXVldWUu
byBcCisJZGF0YV90eC5vIFwKKwlkYXRhX3J4Lm8gXAorCXNjYW4ubyBcCisJc3RhLm8gXAorCWtl
eS5vIFwKKwltYWluLm8gXAorCXN0YS5vIFwKKwlkZWJ1Zy5vCit3ZngtJChDT05GSUdfU1BJKSAr
PSBidXNfc3BpLm8KKyMgV2hlbiBDT05GSUdfTU1DID09IG0sIGFwcGVuZCB0byAnd2Z4LXknIChh
bmQgbm90IHRvICd3ZngtbScpCit3ZngtJChzdWJzdCBtLHksJChDT05GSUdfTU1DKSkgKz0gYnVz
X3NkaW8ubworCitvYmotJChDT05GSUdfV0ZYKSArPSB3ZngubwotLSAKMi4yOS4yCgo=
