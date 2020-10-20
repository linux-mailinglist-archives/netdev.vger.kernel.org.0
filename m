Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCE6E293CCB
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 15:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406835AbgJTM7C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 08:59:02 -0400
Received: from mail-dm6nam12on2042.outbound.protection.outlook.com ([40.107.243.42]:21473
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2406822AbgJTM67 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 08:58:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pva2+FadhiNrQUOx1o9TdaQuK+Ntweu9BT5uZYXOMz5z1XdJuNaASqwuXTCG7qvtuL4t8SQsYc2cU90pfbNLpVYdk56dXKe/eOyHykPtY6GdnjUuS9kUkOZ7PpxpfIBwoSLX+3zLjlv9E+dc658Om/Z/YjBxJ4q0OXbplXTTEH3VMoN15AKBfHn8YCsEZA3hvs9IhEFsv4GoA5FJvfBORukSwBtO3hL4hVthTio2zoA5o1saQq5E6KzXuMUqOVoT4yvT7HTAE8Nd2EWTmTxPZlakZnmgDSpDWZF/LEhhwdGDgSzZOwzUANooSlRevXo/ouBLfsJklYaYlek6FwjKjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RqZzTE5IDNzLeiEeh0gtmEhR+vjHmPP5GDL6eBo8e3g=;
 b=BnaGMEN0rZNsJmDbl/w8vgVr7ECcmhue7n+HB4B/lKMvHSeYM6kgjJd1cZb4doeOZ6M69SebPwfp1OA9onPY6FDWkMVlbdjJ1u5gmGtHRYzH3r8JxZmfK+IoJxVFfc4plEX352QovrkPwkyhsg5L+LS217cQBOgeyVx0hXGXnG50UkoB7RLqjw5wfXJa7iufbz7E7FtMWAffbzF1YWvASsCfTZyW/qCmHT/JAYwRhm98IiHeBmC8m9SkvV2JFicC84CIYSjtJRBNa+se6sxFemM5kWX2iXL/oVFRx/Cq3GRWHA/ALZj4VobVjYSGjG2Eom32Tm7TFGE8Dye9ef7Pow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RqZzTE5IDNzLeiEeh0gtmEhR+vjHmPP5GDL6eBo8e3g=;
 b=bDTFZwNpVv/QiHt0ve0C21pWE+SptVFsNIh0MF9u8vKIM7GkvF3aWFcxematvy7gmQD9IN8vXKpIMG6yS7jN4NtlxpHc0UTz3uB9hSTiasJF+d9lfFAfwGNEPw2xPjj+ccDrL+Z5HkFcZA8Er9y+mlDZ5EZTDEbHsa6qG9+vG8A=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB2656.namprd11.prod.outlook.com (2603:10b6:805:58::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.28; Tue, 20 Oct
 2020 12:58:50 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::4f5:fbe5:44a7:cb8a]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::4f5:fbe5:44a7:cb8a%5]) with mapi id 15.20.3477.028; Tue, 20 Oct 2020
 12:58:50 +0000
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
Subject: [PATCH v2 04/24] wfx: add wfx.h
Date:   Tue, 20 Oct 2020 14:57:57 +0200
Message-Id: <20201020125817.1632995-5-Jerome.Pouiller@silabs.com>
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
Received: from pc-42.silabs.com (37.71.187.125) by PR3P192CA0026.EURP192.PROD.OUTLOOK.COM (2603:10a6:102:56::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21 via Frontend Transport; Tue, 20 Oct 2020 12:58:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: abe8dc02-a827-4651-1ba5-08d874f7e3ea
X-MS-TrafficTypeDiagnostic: SN6PR11MB2656:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB2656B5C399B37EBF2214638D931F0@SN6PR11MB2656.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:773;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F3vWLWBKpVj5+XcIRaD8WXXXWb57A3kJU/uu2W7/AuiUWhWHL+lrBg1UibqKgSp7AgNgYdrHj29uV6t80JhSejp8TOHAGCCLO2Pn0wWthyxeeR72XDtxmzYl8m3NiT3ZAwEM6RIzF2GlJDrTRqGuMygED2ns6obHOqkhkNmxwoZRwZhaQ44i3O/3zNYrSfM5lqF2Cur2I2BbLmUV6oZdOAHXZhc3uXXtBk8gelwc4rKy89y7dqrXoiLhrExeBnWZ2Nn8TvzBybD4HPz3E4nmlSGbsGvCR8LAb5QHPkg7SPZLPSsAmu2qqOVpiWJpH7IZW9BR+yvb8gZxVdSjmZUsEg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(136003)(39830400003)(346002)(376002)(186003)(316002)(4326008)(107886003)(8676002)(86362001)(26005)(2906002)(7696005)(478600001)(16526019)(956004)(6486002)(52116002)(36756003)(8936002)(2616005)(54906003)(5660300002)(1076003)(7416002)(66574015)(6666004)(66556008)(66476007)(66946007)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ZwI5MZRso7cIz/VZtR/e2EZXHND4KI0YColOkD3kO4R6/StN5VVbsRjCeLxUjn2e72E/Ay2fRxd3BlBf4SZmho0uPG0rg6EPHnQNeGDdoP0EoOwQvl08REbmFt589VDbkSnPvSQcfXjc9r7M5+LMRxh86UJrm63nwUNxln2ChezQCg5Jna/dRCgGqbu9tokStkwxmb+1da0koiEi5REIh2c9CyfGRLxmR4eI3dRtcilzaEw7xGTvzwNde4NhSe1js82SmMVsI4BGNyShT220KmHmdTL0+C3dD41JZDkNuJd+VN6jnhdyQftShlw53gC3vEWDmtbvE7ucfBVNzhvQlRjf01aK9Se5vVg++Vwabw+/WGXmwE/7X2zW5EnGDwfJtBP4mDqesq8Nw1VplvTPx0rMqAzklylE8zRg06elXG8TAifS9d3ZVuN9Ml+iQVvwamBV+3pfB6tF9QFqzS7LRQA6h9wgIaZ2fVZgYd/xLPZwjGd3EhMQ/e+CLuZex1w5QPHwnp6EvyLdAebcQ26MpZyB+ZoCqw69KTZHELTno/MnpvKa57nCg+deP9LCMNZtFOgZDwagjucV+DXckL+DHyqDIEjlhIO7SALdxzHTbpAlJWCUhJPKS2sxHOaAUdWug7R9yGz6IkoJw+c7pD529w==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abe8dc02-a827-4651-1ba5-08d874f7e3ea
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2020 12:58:50.3689
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tS8UjGPCak1lMpXt8u2IIgkMU2zEzP/ft9VxbMDDVQC7E9DnEQXxwYQkWXkzgGTXR3xUywREphiMg4EX2c56XQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2656
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKU2ln
bmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29t
PgotLS0KIGRyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93Zngvd2Z4LmggfCAxNjYgKysrKysr
KysrKysrKysrKysrKysrKysrKysKIDEgZmlsZSBjaGFuZ2VkLCAxNjYgaW5zZXJ0aW9ucygrKQog
Y3JlYXRlIG1vZGUgMTAwNjQ0IGRyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93Zngvd2Z4LmgK
CmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9zaWxhYnMvd2Z4L3dmeC5oIGIvZHJp
dmVycy9uZXQvd2lyZWxlc3Mvc2lsYWJzL3dmeC93ZnguaApuZXcgZmlsZSBtb2RlIDEwMDY0NApp
bmRleCAwMDAwMDAwMDAwMDAuLjk0ODk4NjgwY2NkZQotLS0gL2Rldi9udWxsCisrKyBiL2RyaXZl
cnMvbmV0L3dpcmVsZXNzL3NpbGFicy93Zngvd2Z4LmgKQEAgLTAsMCArMSwxNjYgQEAKKy8qIFNQ
RFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wLW9ubHkgKi8KKy8qCisgKiBDb21tb24gcHJp
dmF0ZSBkYXRhIGZvciBTaWxpY29uIExhYnMgV0Z4IGNoaXBzLgorICoKKyAqIENvcHlyaWdodCAo
YykgMjAxNy0yMDIwLCBTaWxpY29uIExhYm9yYXRvcmllcywgSW5jLgorICogQ29weXJpZ2h0IChj
KSAyMDEwLCBTVC1Fcmljc3NvbgorICogQ29weXJpZ2h0IChjKSAyMDA2LCBNaWNoYWVsIFd1IDxm
bGFtaW5naWNlQHNvdXJtaWxrLm5ldD4KKyAqIENvcHlyaWdodCAyMDA0LTIwMDYgSmVhbi1CYXB0
aXN0ZSBOb3RlIDxqYm5vdGVAZ21haWwuY29tPiwgZXQgYWwuCisgKi8KKyNpZm5kZWYgV0ZYX0gK
KyNkZWZpbmUgV0ZYX0gKKworI2luY2x1ZGUgPGxpbnV4L2NvbXBsZXRpb24uaD4KKyNpbmNsdWRl
IDxsaW51eC93b3JrcXVldWUuaD4KKyNpbmNsdWRlIDxsaW51eC9tdXRleC5oPgorI2luY2x1ZGUg
PGxpbnV4L25vc3BlYy5oPgorI2luY2x1ZGUgPG5ldC9tYWM4MDIxMS5oPgorCisjaW5jbHVkZSAi
YmguaCIKKyNpbmNsdWRlICJkYXRhX3R4LmgiCisjaW5jbHVkZSAibWFpbi5oIgorI2luY2x1ZGUg
InF1ZXVlLmgiCisjaW5jbHVkZSAiaGlmX3R4LmgiCisKKyNkZWZpbmUgVVNFQ19QRVJfVFhPUCAz
MiAvLyBzZWUgc3RydWN0IGllZWU4MDIxMV90eF9xdWV1ZV9wYXJhbXMKKyNkZWZpbmUgVVNFQ19Q
RVJfVFUgMTAyNAorCitzdHJ1Y3QgaHdidXNfb3BzOworCitzdHJ1Y3Qgd2Z4X2RldiB7CisJc3Ry
dWN0IHdmeF9wbGF0Zm9ybV9kYXRhIHBkYXRhOworCXN0cnVjdCBkZXZpY2UJCSpkZXY7CisJc3Ry
dWN0IGllZWU4MDIxMV9odwkqaHc7CisJc3RydWN0IGllZWU4MDIxMV92aWYJKnZpZlsyXTsKKwlz
dHJ1Y3QgbWFjX2FkZHJlc3MJYWRkcmVzc2VzWzJdOworCWNvbnN0IHN0cnVjdCBod2J1c19vcHMJ
Kmh3YnVzX29wczsKKwl2b2lkCQkJKmh3YnVzX3ByaXY7CisKKwl1OAkJCWtleXNldDsKKwlzdHJ1
Y3QgY29tcGxldGlvbglmaXJtd2FyZV9yZWFkeTsKKwlzdHJ1Y3QgaGlmX2luZF9zdGFydHVwCWh3
X2NhcHM7CisJc3RydWN0IHdmeF9oaWYJCWhpZjsKKwlzdHJ1Y3QgZGVsYXllZF93b3JrCWNvb2xp
bmdfdGltZW91dF93b3JrOworCWJvb2wJCQlwb2xsX2lycTsKKwlib29sCQkJY2hpcF9mcm96ZW47
CisJc3RydWN0IG11dGV4CQljb25mX211dGV4OworCisJc3RydWN0IHdmeF9oaWZfY21kCWhpZl9j
bWQ7CisJc3RydWN0IHNrX2J1ZmZfaGVhZAl0eF9wZW5kaW5nOworCXdhaXRfcXVldWVfaGVhZF90
CXR4X2RlcXVldWU7CisJYXRvbWljX3QJCXR4X2xvY2s7CisKKwlhdG9taWNfdAkJcGFja2V0X2lk
OworCXUzMgkJCWtleV9tYXA7CisKKwlzdHJ1Y3QgaGlmX3J4X3N0YXRzCXJ4X3N0YXRzOworCXN0
cnVjdCBtdXRleAkJcnhfc3RhdHNfbG9jazsKKwlzdHJ1Y3QgaGlmX3R4X3Bvd2VyX2xvb3BfaW5m
byB0eF9wb3dlcl9sb29wX2luZm87CisJc3RydWN0IG11dGV4CQl0eF9wb3dlcl9sb29wX2luZm9f
bG9jazsKKwlpbnQJCQlmb3JjZV9wc190aW1lb3V0OworfTsKKworc3RydWN0IHdmeF92aWYgewor
CXN0cnVjdCB3ZnhfZGV2CQkqd2RldjsKKwlzdHJ1Y3QgaWVlZTgwMjExX3ZpZgkqdmlmOworCXN0
cnVjdCBpZWVlODAyMTFfY2hhbm5lbCAqY2hhbm5lbDsKKwlpbnQJCQlpZDsKKworCXUzMgkJCWxp
bmtfaWRfbWFwOworCisJYm9vbAkJCWFmdGVyX2R0aW1fdHhfYWxsb3dlZDsKKwlib29sCQkJam9p
bl9pbl9wcm9ncmVzczsKKworCXN0cnVjdCBkZWxheWVkX3dvcmsJYmVhY29uX2xvc3Nfd29yazsK
KworCXN0cnVjdCB3ZnhfcXVldWUJdHhfcXVldWVbNF07CisJc3RydWN0IHR4X3BvbGljeV9jYWNo
ZQl0eF9wb2xpY3lfY2FjaGU7CisJc3RydWN0IHdvcmtfc3RydWN0CXR4X3BvbGljeV91cGxvYWRf
d29yazsKKworCXN0cnVjdCB3b3JrX3N0cnVjdAl1cGRhdGVfdGltX3dvcms7CisKKwl1bnNpZ25l
ZCBsb25nCQl1YXBzZF9tYXNrOworCisJLyogYXZvaWQgc29tZSBvcGVyYXRpb25zIGluIHBhcmFs
bGVsIHdpdGggc2NhbiAqLworCXN0cnVjdCBtdXRleAkJc2Nhbl9sb2NrOworCXN0cnVjdCB3b3Jr
X3N0cnVjdAlzY2FuX3dvcms7CisJc3RydWN0IGNvbXBsZXRpb24Jc2Nhbl9jb21wbGV0ZTsKKwli
b29sCQkJc2Nhbl9hYm9ydDsKKwlzdHJ1Y3QgaWVlZTgwMjExX3NjYW5fcmVxdWVzdCAqc2Nhbl9y
ZXE7CisKKwlzdHJ1Y3QgY29tcGxldGlvbglzZXRfcG1fbW9kZV9jb21wbGV0ZTsKK307CisKK3N0
YXRpYyBpbmxpbmUgc3RydWN0IHdmeF92aWYgKndkZXZfdG9fd3ZpZihzdHJ1Y3Qgd2Z4X2RldiAq
d2RldiwgaW50IHZpZl9pZCkKK3sKKwlpZiAodmlmX2lkID49IEFSUkFZX1NJWkUod2Rldi0+dmlm
KSkgeworCQlkZXZfZGJnKHdkZXYtPmRldiwgInJlcXVlc3Rpbmcgbm9uLWV4aXN0ZW50IHZpZjog
JWRcbiIsIHZpZl9pZCk7CisJCXJldHVybiBOVUxMOworCX0KKwl2aWZfaWQgPSBhcnJheV9pbmRl
eF9ub3NwZWModmlmX2lkLCBBUlJBWV9TSVpFKHdkZXYtPnZpZikpOworCWlmICghd2Rldi0+dmlm
W3ZpZl9pZF0pIHsKKwkJZGV2X2RiZyh3ZGV2LT5kZXYsICJyZXF1ZXN0aW5nIG5vbi1hbGxvY2F0
ZWQgdmlmOiAlZFxuIiwKKwkJCXZpZl9pZCk7CisJCXJldHVybiBOVUxMOworCX0KKwlyZXR1cm4g
KHN0cnVjdCB3ZnhfdmlmICopIHdkZXYtPnZpZlt2aWZfaWRdLT5kcnZfcHJpdjsKK30KKworc3Rh
dGljIGlubGluZSBzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZl9pdGVyYXRlKHN0cnVjdCB3ZnhfZGV2ICp3
ZGV2LAorCQkJCQkgICBzdHJ1Y3Qgd2Z4X3ZpZiAqY3VyKQoreworCWludCBpOworCWludCBtYXJr
ID0gMDsKKwlzdHJ1Y3Qgd2Z4X3ZpZiAqdG1wOworCisJaWYgKCFjdXIpCisJCW1hcmsgPSAxOwor
CWZvciAoaSA9IDA7IGkgPCBBUlJBWV9TSVpFKHdkZXYtPnZpZik7IGkrKykgeworCQl0bXAgPSB3
ZGV2X3RvX3d2aWYod2RldiwgaSk7CisJCWlmIChtYXJrICYmIHRtcCkKKwkJCXJldHVybiB0bXA7
CisJCWlmICh0bXAgPT0gY3VyKQorCQkJbWFyayA9IDE7CisJfQorCXJldHVybiBOVUxMOworfQor
CitzdGF0aWMgaW5saW5lIGludCB3dmlmX2NvdW50KHN0cnVjdCB3ZnhfZGV2ICp3ZGV2KQorewor
CWludCBpOworCWludCByZXQgPSAwOworCXN0cnVjdCB3ZnhfdmlmICp3dmlmOworCisJZm9yIChp
ID0gMDsgaSA8IEFSUkFZX1NJWkUod2Rldi0+dmlmKTsgaSsrKSB7CisJCXd2aWYgPSB3ZGV2X3Rv
X3d2aWYod2RldiwgaSk7CisJCWlmICh3dmlmKQorCQkJcmV0Kys7CisJfQorCXJldHVybiByZXQ7
Cit9CisKK3N0YXRpYyBpbmxpbmUgdm9pZCBtZW1yZXZlcnNlKHU4ICpzcmMsIHU4IGxlbmd0aCkK
K3sKKwl1OCAqbG8gPSBzcmM7CisJdTggKmhpID0gc3JjICsgbGVuZ3RoIC0gMTsKKwl1OCBzd2Fw
OworCisJd2hpbGUgKGxvIDwgaGkpIHsKKwkJc3dhcCA9ICpsbzsKKwkJKmxvKysgPSAqaGk7CisJ
CSpoaS0tID0gc3dhcDsKKwl9Cit9CisKK3N0YXRpYyBpbmxpbmUgaW50IG1lbXpjbXAodm9pZCAq
c3JjLCB1bnNpZ25lZCBpbnQgc2l6ZSkKK3sKKwl1OCAqYnVmID0gc3JjOworCisJaWYgKCFzaXpl
KQorCQlyZXR1cm4gMDsKKwlpZiAoKmJ1ZikKKwkJcmV0dXJuIDE7CisJcmV0dXJuIG1lbWNtcChi
dWYsIGJ1ZiArIDEsIHNpemUgLSAxKTsKK30KKworI2VuZGlmIC8qIFdGWF9IICovCi0tIAoyLjI4
LjAKCg==
