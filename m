Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 966162A68DC
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 16:57:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730884AbgKDPwe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 10:52:34 -0500
Received: from mail-eopbgr750080.outbound.protection.outlook.com ([40.107.75.80]:6126
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730682AbgKDPwc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 10:52:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k0g+lpmtfnW3BYvsDk/02PmIgUpJUqU5c3MvB+TxDP54d8AI/NYcL0YweSvRZw4w3QFjHD/pE4hwsZVRvrNuSlP2wrkPChGWJLzHgebCag5xTe+bHPYDFo3BuRHDd9Y07nV9hjiGIR9Oo8GEUKkeHTkIUnGjESSpK3UQC+tvs01gMcvzDlw8MwybgqpVML0UjUhVXer8gCUuyjV7UmCIKS8KTSved4xYHMEZshtKGybwx7OeHjIJLpoF+N2/br46KoXywrVgFyv+ktxrcDSVh+8GZBsCXzHg3tLebhjtmCZ0+kQyVK2XzABfPxJtpP9eRzzEGu9nins+0/mGhnI3Lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=asTSYqI/0VaupVnUwKr/Op8wQRhoedDfa4ZNrYWJ/VQ=;
 b=Exre3hKClMUSHxTF0IZWi2tQ3pc8UxmiboOJ0uWhoBl9BGyzdggIqKqGtIt6tjtE9k/PWHhhL7ONKI/KckJznXZVKrFWmAqlh3q+FMdAyqtdLIhyXkwCbNU55m60Hymh6IwpqN6abFsW1mQWK+f2hpOFey7dsbwNFnMTB2G3jtO063NOM0W+4nldcMWFNnHkmsUvLJJeTjz1xlIOGtV3UOzFfXd6f6RPoOWH/2CxwHXDZ4i0xbXpX8uuShEpDjfbwenmbvWzOu7ILgvXIhe9dONGIe7P5XZbSUzTg+XZoefQjh0WzWOxLLdTK/Y9S5sf80YltlJLdV/lFVmYLPtU1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=asTSYqI/0VaupVnUwKr/Op8wQRhoedDfa4ZNrYWJ/VQ=;
 b=LZuwBgfr9NyBKM4PRRQ60fqra3uAdBAmGYBxN9gbqllIbHurtyse426veNak4zaC4pYARLPrSsHRT9mfZS9GGYgt+1TfpaN1mo8SxcJzaBEbrrzznoM8OKVEALx0atpAYW2rh6JwL26aVBURe9iP2JDgaPNf5ntu8yV138U2Djc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.32; Wed, 4 Nov
 2020 15:52:24 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::4f5:fbe5:44a7:cb8a]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::4f5:fbe5:44a7:cb8a%5]) with mapi id 15.20.3499.032; Wed, 4 Nov 2020
 15:52:24 +0000
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
Subject: [PATCH v3 01/24] mmc: sdio: add SDIO IDs for Silabs WF200 chip
Date:   Wed,  4 Nov 2020 16:51:44 +0100
Message-Id: <20201104155207.128076-2-Jerome.Pouiller@silabs.com>
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
Received: from pc-42.silabs.com (82.67.86.106) by SN6PR01CA0032.prod.exchangelabs.com (2603:10b6:805:b6::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.19 via Frontend Transport; Wed, 4 Nov 2020 15:52:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 372cd1df-19fa-4ad1-a09b-08d880d99f0c
X-MS-TrafficTypeDiagnostic: SN6PR11MB2718:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB2718326C3396AC86C62830D493EF0@SN6PR11MB2718.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xIKH9IUVTODFAFgh3oelleksdcqQeKo4xQImAyFvFFOzuqz0TKdqrWLYse6kyHMtKumY0b4WNzakhForf/6c/zDNYRVOD8mb5J+D/AaOfQfLxArqHDH1tPaVKtzIRV4Z1Qcskbo91WPalqlg/8JVUjh30d6w5pNnJ8tAq6tU4BSo0bOUgsLZBafzPAPJFwbr954hWltJ1Kg0ijgsQdgthbP7DUNGa9KnAUC6GbUlxXsrbpEExw6VBk7CG9PjRzsN8s4HsF8Swnufihox3sY61Wssiku2DKhdFc5HsVquszyjviWU5Yf/98ykN2W4mrK+ezd3RtWfxfMBSklq3+4khg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(376002)(39850400004)(136003)(396003)(8936002)(478600001)(186003)(16526019)(956004)(2616005)(6486002)(8676002)(66476007)(66556008)(66946007)(316002)(7696005)(6666004)(26005)(54906003)(107886003)(36756003)(52116002)(7416002)(4326008)(5660300002)(4744005)(86362001)(1076003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: E368F0cy8Bkyq1wkFanX6rfCG6GjzJSkJgQVzlTAOnfFEm1FRJA/YO+7UzjoaC+77unmBReNJfCFiLnMxNHk0tm7AsNIgJQ2Ki0CY2DzZKf9tP/YDT/ML6yjFuw3pEF0j05CNW9P2UVB8kntpGDBMeGHOneE+2eq9gx7bZ3rRYnVBM90QJOlZtga+K1OuTJGqznFLcrRUdPvArJ1xrOAdWy2Fo8TW5Mpi+RzGVLsteeTimoJv5hb9HOkVRlwKNijB9tXPZrWxXjsS6G3jsJprdqpmyYwrSrersnDHevNSrQGTvNOndt1I+2j1cERSVexBbojVzAy1YKKn4hWYlCv9u5W93xUsbqGs7s9NZu7JZSmTym9wzwo3WEaAN4yLpEiysTtmBFJegsOy3UJd93NSMVR3N/4zn+vBu5O2ivn3RJ34t0UqFyAahdwW7e6sCt/WWHuqcwX+b2+uMi44oS8jJwbL8wvXJgLwMWmVp2dJ6PwE5TpzB6PI2HtNOopbhgutndNxQnUOU/Ybtt0d510/WPfpHiDXju2d0PNqTY1PwoDVlRqLUifDbqs9+do414vLIcP4VrsqVmh8kFNje2xpzmc+EFaHjdB99g/D4bmmXwBi3xm80QSj/N2th0Ux6ltWueqGBBrlu/7daFUOz49qA==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 372cd1df-19fa-4ad1-a09b-08d880d99f0c
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2020 15:52:24.0197
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sFp/cKO4kuIa6cE7twNI/cHeg4DfOT01kkx1XP/h4SsSWdrxUaW9MNw2JRjVu1loGDTLfxQHrIC7G32NogKuOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2718
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKQWRk
IFNpbGFicyBTRElPIElEIHRvIHNkaW9faWRzLmguCgpOb3RlIHRoYXQgdGhlIHZhbHVlcyB1c2Vk
IGJ5IFNpbGFicyBhcmUgdW5jb21tb24uIEEgZHJpdmVyIGNhbm5vdCBmdWxseQpyZWx5IG9uIHRo
ZSBTRElPIFBuUC4gSXQgc2hvdWxkIGFsc28gY2hlY2sgaWYgdGhlIGRldmljZSBpcyBkZWNsYXJl
ZCBpbgp0aGUgRFQuCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBv
dWlsbGVyQHNpbGFicy5jb20+Ci0tLQogaW5jbHVkZS9saW51eC9tbWMvc2Rpb19pZHMuaCB8IDUg
KysrKysKIDEgZmlsZSBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKykKCmRpZmYgLS1naXQgYS9pbmNs
dWRlL2xpbnV4L21tYy9zZGlvX2lkcy5oIGIvaW5jbHVkZS9saW51eC9tbWMvc2Rpb19pZHMuaApp
bmRleCAxMjAzNjYxOTM0NmMuLjIwYTQ4MTYyZjdmYyAxMDA2NDQKLS0tIGEvaW5jbHVkZS9saW51
eC9tbWMvc2Rpb19pZHMuaAorKysgYi9pbmNsdWRlL2xpbnV4L21tYy9zZGlvX2lkcy5oCkBAIC0y
NSw2ICsyNSwxMSBAQAogICogVmVuZG9ycyBhbmQgZGV2aWNlcy4gIFNvcnQga2V5OiB2ZW5kb3Ig
Zmlyc3QsIGRldmljZSBuZXh0LgogICovCiAKKy8vIFNpbGFicyBkb2VzIG5vdCB1c2UgYSByZWxp
YWJsZSB2ZW5kb3IgSUQuIFRvIGF2b2lkIGNvbmZsaWN0cywgdGhlIGRyaXZlcgorLy8gd29uJ3Qg
cHJvYmUgdGhlIGRldmljZSBpZiBpdCBpcyBub3QgYWxzbyBkZWNsYXJlZCBpbiB0aGUgRFQuCisj
ZGVmaW5lIFNESU9fVkVORE9SX0lEX1NJTEFCUwkJCTB4MDAwMAorI2RlZmluZSBTRElPX0RFVklD
RV9JRF9TSUxBQlNfV0YyMDAJCTB4MTAwMAorCiAjZGVmaW5lIFNESU9fVkVORE9SX0lEX1NURQkJ
CTB4MDAyMAogI2RlZmluZSBTRElPX0RFVklDRV9JRF9TVEVfQ1cxMjAwCQkweDIyODAKIAotLSAK
Mi4yOC4wCgo=
