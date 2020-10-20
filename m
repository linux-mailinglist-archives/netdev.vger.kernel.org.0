Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94DF9293C58
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 14:59:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406854AbgJTM7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 08:59:05 -0400
Received: from mail-dm6nam12on2042.outbound.protection.outlook.com ([40.107.243.42]:21473
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2406801AbgJTM6y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 08:58:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H+Uh0799mydbAOWP9oFnB8Hz6dS+fBfBbQz7CHFkLY80yDTRvP4AkcuhjxCtttXK+yY0hmLgPZST1SVobKQXHmQJZfry57BSsDJueD8WsmsTLqlM7GekKjCTaqCt+ypDrMphULeOjZ0TTX+4AvCfqlQzIt3D/8zZ083k910olo4YVvrMyp9pCR4bWgQGPDeZj+9daID6lWV9tgl7vg1Mf3tg2pyjyAmxfo9aK+wdVKO/GQ/Giog/GQNmqIQNyOJY37vP6blV9rxRstNgnDKS/2xy4IXmqZ/BFoKnDC7IMx/15YMi5SjJ+/HmJ7XA/U0P4hUvW/WL3fhZSyv0G7+sFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=58XMnNgaUS8bBLHPu9hEGfkhu7DZAV5XWPx13jJWCV0=;
 b=JjyqiN1or/DHCLABI2OH6dQD7mR+3b2DHhLOLqh9nmqyAQzXO3oqWwvX+WMngHDcdgvdZbOtCyGnyp5UPfT/MVCb1cEEOmveW5daPrcS3dV6FX7RDf6eJVt0yR3cwPgFF0uQDsq1brnqxltYKRkpsnygXF2u4LPfjEuLm5rY2Wpo2Klw8T45JVn5hmJ4jb3vnZPuTl5tSzzDgYJYXiYgHUBK/r0OVkc9nXS6EBRQ20qs4esmzNm7f0VoDMNY91jwAQXESaRmd1hBWZxFyASWpfz4X7/IV31piLM8fsJdDrvX9eOYP7e/Tq6POCoP71a7N81mig+4aPO3ZMP2xB37TA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=58XMnNgaUS8bBLHPu9hEGfkhu7DZAV5XWPx13jJWCV0=;
 b=pTfORq6GoWhExnpeywc3viugL63iwgWCIZeDHTrmpOZKiQ7rLJOknkxEyFYoGqAeEXsRVfAHUGxkW7gN79JIaBSLomfU8ol0r6R9qXFUIlx63bXcP2GS2K/Z4j/LeDi8XBKV8ivXhuzPtBlZ0ZbnVo8Gh6dwcePywWNZtmbt/q8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB2656.namprd11.prod.outlook.com (2603:10b6:805:58::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.28; Tue, 20 Oct
 2020 12:58:48 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::4f5:fbe5:44a7:cb8a]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::4f5:fbe5:44a7:cb8a%5]) with mapi id 15.20.3477.028; Tue, 20 Oct 2020
 12:58:48 +0000
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
Subject: [PATCH v2 03/24] wfx: add Makefile/Kconfig
Date:   Tue, 20 Oct 2020 14:57:56 +0200
Message-Id: <20201020125817.1632995-4-Jerome.Pouiller@silabs.com>
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
Received: from pc-42.silabs.com (37.71.187.125) by PR3P192CA0026.EURP192.PROD.OUTLOOK.COM (2603:10a6:102:56::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21 via Frontend Transport; Tue, 20 Oct 2020 12:58:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 371a7941-2eae-4a8d-26aa-08d874f7e291
X-MS-TrafficTypeDiagnostic: SN6PR11MB2656:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB265615B3486E2ED5C87B0F83931F0@SN6PR11MB2656.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H3CVnf8hlPenLDgXpgiVq3bJIotpH340NckVvHOov6JaugAv8LUy5A5wAMldksjSw2YceONymX9CxBjiq2AwkxEamWNM164M9FUJZzfBz/hg+CYuhj8B9pXT37x3sQSCb6c5dNEWIC9r3GVwvPlaLKLyTitz6qmCKLafb+j+3LmWtOC5QESQ8p2UgLlo3tsvDVHfuf6YFGeNEpvJkVEwS7ytvCbb3y251jOVmXIwqqgRcOoUmvymEwMgnrMG3wEZkvvGBjtWRHTma4BUxddS0Aq0uW4xAMAQrKHZaqEIecVjHVtwejqGUQqnsZQ8QpQo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(136003)(39830400003)(346002)(376002)(186003)(316002)(4326008)(107886003)(8676002)(86362001)(26005)(2906002)(7696005)(478600001)(16526019)(956004)(6486002)(52116002)(36756003)(8936002)(2616005)(54906003)(5660300002)(1076003)(7416002)(66574015)(6666004)(66556008)(66476007)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Uih9tW4mxFxCWUcT5Tar3bD0PsMOiQcO6l0GcM2PG1cIjz9zdU+Kqvq4K+G8358oH6kzCtxEPHylzkJAk1wUV+WhKdSCaOu3FtiR7vpGC8mOG7VddFcoc8HQwHfGJgdlnNBu1fW/Kb6myCcz4yBPgAtIH94berS04zHcV9JlIospFFXGrPSRFVYgYRVHr1Rdlu6WoKdOkXaKmvVlaZ0DbUAKpbGfRO0kJAZXZP6x0O3Eix1Q36RJiv5kYhjo5rQC8F33y62xaQPqJSzER3THJ2llLa7A2rsUd4vfhuQXBJVRdy1VBNZkg0Hz+rc589I3nplbJ33/R/UJMBSAIm7y0LacaFYdVfs7UHxokxedtUGAjaHmtVH1L7oL0zeASysDGnKmr83MJOJWdXzJdthXfoZkcahtuWhWQvAj03E3VB9sP7wCOowV+TTVP4DlnJrmuBadghSJwqHbdxw33rpI5VO5T3F9J8YlLqDaCYCgoB3b2ptA6jO6SLIMxSFztcuJ+Z1mNeX/8vn6sXa84S6/IFK6v1qdH4IN2XdxQ2A1DLR8Bwrc8hwXL5ao6NlDGxDglMjp4pmJJgkeyx6AQhIR151mIsv/NOHbNtkMTWLPbn/elel7pVx0OQy9atIYQfs72RwD443ESWZp9C9fA8RCDw==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 371a7941-2eae-4a8d-26aa-08d874f7e291
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2020 12:58:48.1341
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L+onpPvgcuNRUM1nxwBrVFDntn+QkF7wDm1RWe+OiiSyiYcTCm6iAJI8tSNd1R3oz9jLbKC0wbbKNY83VUgLZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2656
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKU2ln
bmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29t
PgotLS0KIGRyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93ZngvS2NvbmZpZyAgfCAgOCArKysr
KysrKwogZHJpdmVycy9uZXQvd2lyZWxlc3Mvc2lsYWJzL3dmeC9NYWtlZmlsZSB8IDI1ICsrKysr
KysrKysrKysrKysrKysrKysrKwogMiBmaWxlcyBjaGFuZ2VkLCAzMyBpbnNlcnRpb25zKCspCiBj
cmVhdGUgbW9kZSAxMDA2NDQgZHJpdmVycy9uZXQvd2lyZWxlc3Mvc2lsYWJzL3dmeC9LY29uZmln
CiBjcmVhdGUgbW9kZSAxMDA2NDQgZHJpdmVycy9uZXQvd2lyZWxlc3Mvc2lsYWJzL3dmeC9NYWtl
ZmlsZQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93ZngvS2NvbmZp
ZyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93ZngvS2NvbmZpZwpuZXcgZmlsZSBtb2Rl
IDEwMDY0NAppbmRleCAwMDAwMDAwMDAwMDAuLjgzZWU0ZDBjYThjNgotLS0gL2Rldi9udWxsCisr
KyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93ZngvS2NvbmZpZwpAQCAtMCwwICsxLDgg
QEAKK2NvbmZpZyBXRlgKKwl0cmlzdGF0ZSAiU2lsaWNvbiBMYWJzIHdpcmVsZXNzIGNoaXBzIFdG
MjAwIGFuZCBmdXJ0aGVyIgorCWRlcGVuZHMgb24gTUFDODAyMTEKKwlkZXBlbmRzIG9uIE1NQyB8
fCAhTU1DICMgZG8gbm90IGFsbG93IFdGWD15IGlmIE1NQz1tCisJZGVwZW5kcyBvbiAoU1BJIHx8
IE1NQykKKwloZWxwCisJICBUaGlzIGlzIGEgZHJpdmVyIGZvciBTaWxpY29ucyBMYWJzIFdGeHh4
IHNlcmllcyAoV0YyMDAgYW5kIGZ1cnRoZXIpCisJICBjaGlwc2V0cy4gVGhpcyBjaGlwIGNhbiBi
ZSBmb3VuZCBvbiBTUEkgb3IgU0RJTyBidXNlcy4KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dp
cmVsZXNzL3NpbGFicy93ZngvTWFrZWZpbGUgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9zaWxhYnMv
d2Z4L01ha2VmaWxlCm5ldyBmaWxlIG1vZGUgMTAwNjQ0CmluZGV4IDAwMDAwMDAwMDAwMC4uMGUw
Y2M5ODJjZWFiCi0tLSAvZGV2L251bGwKKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3Mvc2lsYWJz
L3dmeC9NYWtlZmlsZQpAQCAtMCwwICsxLDI1IEBACisjIFNQRFgtTGljZW5zZS1JZGVudGlmaWVy
OiBHUEwtMi4wCisKKyMgTmVjZXNzYXJ5IGZvciBDUkVBVEVfVFJBQ0VfUE9JTlRTCitDRkxBR1Nf
ZGVidWcubyA9IC1JJChzcmMpCisKK3dmeC15IDo9IFwKKwliaC5vIFwKKwlod2lvLm8gXAorCWZ3
aW8ubyBcCisJaGlmX3R4X21pYi5vIFwKKwloaWZfdHgubyBcCisJaGlmX3J4Lm8gXAorCXF1ZXVl
Lm8gXAorCWRhdGFfdHgubyBcCisJZGF0YV9yeC5vIFwKKwlzY2FuLm8gXAorCXN0YS5vIFwKKwlr
ZXkubyBcCisJbWFpbi5vIFwKKwlzdGEubyBcCisJZGVidWcubword2Z4LSQoQ09ORklHX1NQSSkg
Kz0gYnVzX3NwaS5vCit3ZngtJChzdWJzdCBtLHksJChDT05GSUdfTU1DKSkgKz0gYnVzX3NkaW8u
bworCitvYmotJChDT05GSUdfV0ZYKSArPSB3ZngubwotLSAKMi4yOC4wCgo=
