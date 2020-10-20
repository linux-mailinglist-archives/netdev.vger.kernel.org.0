Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3007293CD9
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 15:02:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406794AbgJTM6v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 08:58:51 -0400
Received: from mail-dm6nam12on2042.outbound.protection.outlook.com ([40.107.243.42]:21473
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2406733AbgJTM6r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 08:58:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bttkzqd05M8vB+PMvs3xmJi1Z8BLKRh14SDKH+PyPsng29CVFtfa4zqWoOBjjRZxTp49nwpKbrZNLjI1BphEJejoCxzCkBguHZCARVQ7WJPBW3mTth5aMlcsHA9aDPjogNRxZl4XhOIekC/Qnrvrw1a5TBmZXFN5fpZs/UL90fRYEeXi8woNZ4DFw1rhdO3W6SK+PbI+2iqrpxGq1tLGdCp5FVwJC8OzdqN9N7TK+FyFE/K/EYTedtJtYl41YpCt3l2EI8hbXmaUbttj90y96wGL39PRiAco8LFDVTpdSFBm6hJ0gmnmGx0vjvyKfk6WJY3xZD5paVrIoEqQ/FPF8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=asTSYqI/0VaupVnUwKr/Op8wQRhoedDfa4ZNrYWJ/VQ=;
 b=NYSxOB3XPbRO2eNd6spGqNuw77fX76SHIy0fzrVlr4DqNVMaZFG4qZhRVD82eQZnbkNOEu6WZfAeMzQH8XtG99pQV3jnHIFiYFpACjb0t5vFgOGTEipTpdJ/3bBhpxHwJY/Ee0KfMiMXHSMQvkolp3ht08oK9drTj4/POm195UV43o7zUrbw7n+TepiUdGe7LdbcVjBqEOPZm7ecksDzzPyTx8pSgaMmpgwuyX+OqbDBcotR9hPF2o2/xoXS6K4PGNaJ9UlBOLHAmHCewQZJSvR/lU2NkE9KSwonC1PTYrN0ac1PhL1AckV5k1Nl2V84ut98WM9YQJ9C9lpj1DX69A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=asTSYqI/0VaupVnUwKr/Op8wQRhoedDfa4ZNrYWJ/VQ=;
 b=cpH/KgFk/qU2G9Svkl8auD/LpgQJ8gHZxKph8UVVMdwyDLDwZLpT9zZ+4R8NO/dTJJylfAMd3cc+IJCX8MKEnDXQngSajkPQDkCbPeEzlNRx/WBlma5ju7P6iirwKsbNo6ehFv9G8RIt3SZ3OZNzPa8ksE/ishZ5ZGLVN13N87Q=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB2656.namprd11.prod.outlook.com (2603:10b6:805:58::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.28; Tue, 20 Oct
 2020 12:58:43 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::4f5:fbe5:44a7:cb8a]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::4f5:fbe5:44a7:cb8a%5]) with mapi id 15.20.3477.028; Tue, 20 Oct 2020
 12:58:43 +0000
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
Subject: [PATCH v2 01/24] mmc: sdio: add SDIO IDs for Silabs WF200 chip
Date:   Tue, 20 Oct 2020 14:57:54 +0200
Message-Id: <20201020125817.1632995-2-Jerome.Pouiller@silabs.com>
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
Received: from pc-42.silabs.com (37.71.187.125) by PR3P192CA0026.EURP192.PROD.OUTLOOK.COM (2603:10a6:102:56::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21 via Frontend Transport; Tue, 20 Oct 2020 12:58:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9db324d6-d590-48e7-f2f3-08d874f7df9f
X-MS-TrafficTypeDiagnostic: SN6PR11MB2656:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB2656481D5C0368448268426F931F0@SN6PR11MB2656.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t+m234RaP22nEWPuekUvg8H44YuMwWv+yFmdWb5acmHiSgGXBndLNcl6k0tJzwDzLKqV526W/kNhDWHZqiag7WbrRxgiNI/Pei6uqkzH2wpyKsZ+pTattpuDp8lj5qXzex/dYP88VDPpTcJE0eL7sEvjonEr0bvU0QbEINbfv2RNiOaz9asmx2syY5wYcVlUYbxjIJhHvfPeR7j75tDurI+aoC0VfuUqemYancAR4bKx6hC1ooWstGBqmuQgak/zt22edFkyg7cHk/KOCBhoLEQDKVRBZx5Ip5RmlLuD+a5TA5lwMiOEO/qo1dyc43CjCId0Wc0AskIjLVtWJXxxdw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(136003)(39830400003)(346002)(376002)(186003)(316002)(4326008)(107886003)(8676002)(86362001)(26005)(2906002)(7696005)(478600001)(16526019)(956004)(6486002)(52116002)(36756003)(8936002)(2616005)(54906003)(5660300002)(1076003)(7416002)(6666004)(66556008)(4744005)(66476007)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 7pL7UlaKH/8eiC5LAWI5TcUlMtMu2r/PSvbeBFf6ZkxNpGMIXYkOSourY6wKq1mXaYHGZrsv3iyzfc+4HtsgRNyxa41Y+2yR0PMZM1ge5LbmtIirQLMAZ+Av9kNTKXLOfu7zw5Y880b1s1yR9x51wI90U6iMHKhjwWRSi5D15WeFIr/mb/QlCc2RCLS3yd5XnujbIdh1MSrpBdUzBRk6jWd6NMF+3Y03ocDJpxt+d1hiOBu8ftQONDRO6aKt3xealfPhW1u7B8VH4pV+5tllSRsDI3fDb797zkeh36qOUmHcAFuxpHirhIX5xbXiWbRLVV9GsA6lQHS5cFtokJn1A//Oyvs+q5jyfFHHkrzqVRwjcQUo3hQFDtJNaFEMH2/9FuKG1tBxOm4gbvlecWdLcdfleJXFpC8MdYr9xCRquOQKELgtju9H3GEdO1Efw35kF8d8Aa9OwqSMCW4aMwjzaaY9mvphc6HgrEEOl3x1V+xTdR8K1rY/QwEpdgy4a0Wgnqu1eG0dSbsi9IniHchHH/O+UrqSQF6aayK/lPtNLqNuIjE2KRdBQpEye7bsaYBFe3HWSS626XDVHsNqoRCYyuQG5SccN7jAgP0QW/PXAgid8WM3eLF8i1TUr+2GtEDiiPKaAp7gnIWBvZ8GHNOekg==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9db324d6-d590-48e7-f2f3-08d874f7df9f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2020 12:58:43.4628
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xep0prC2sfwXZceWMtUQfuKRI/vzBHFCJ4UQiuHdG5MJzjwlEEOWAhhzZKcqD71p35lpgnOcHBHc05FK/fCIpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2656
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
