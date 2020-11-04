Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E90CA2A688F
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 16:56:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730940AbgKDPwp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 10:52:45 -0500
Received: from mail-eopbgr750080.outbound.protection.outlook.com ([40.107.75.80]:6126
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730682AbgKDPwi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 10:52:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AKHLw2c6AkRh9Yj0+z8RXcZAmeQJvAdpXSGRpdE2NrCqTf2Zhd2jQeUv25tjP5pV9O+kb4A98mo9MiTcc7HYeGUQpXC3emVcquU7Etar4SVVJCz/V6IJj8LjeuAwbjhVizTBJUuIt+FY2QHHoUlYlpkWnc2FlsMl2jjT/ZSfzr7jkGdkDygY8Z5CncgRQhIv/O0vvD16nMqYqAl5vftpssZDE/qHD1Hco6vdAxjKj3gRuGbaV4qJLreuyFzBoucZGLTr4I3Z0lfn2dWFdRYPcn7dgYBfeRpDlK2iomjphY4PHE6N4DFcMwI5FfDQ2uUNF0AvkGeEePKpNypEbnHZhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=58XMnNgaUS8bBLHPu9hEGfkhu7DZAV5XWPx13jJWCV0=;
 b=N+1aCmf+YP0MyapvRToWqHyHwKyMnliXHI6ngtUEWt9X53+27Pid5ImdgA49Zf7FPMr8SgRRX7rf3BBJ2Dfjy69NItm+T4he2m4j1ltlGJQM+oevVC7EuD8uzX6r8J48lkbdKdPs2PXyMhKMKmOo/Xt/wo6TFlIKvvO9r3ygz2MKNLEVaGD0wb1LwBTM0QJ1nGM4oN7dkerXerkMRcbw7H8XeHxtLsluSsBtwty0hABDn58GF6Yad9jiQICxytWkgHuT2/bVWRg5jYV/eOQXNBLQUDuBNJzB4JLMrNE/IxMuy6FXibJu2YmuTAx8L/aJhDszo3Ve0XbDK0/tHlTAyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=58XMnNgaUS8bBLHPu9hEGfkhu7DZAV5XWPx13jJWCV0=;
 b=k4z9JRFMMMrznNt6Ae+uNNts6kLwKuP+pIJb5wJAtNYOBP2znCyvMguCqbraP0gZTLevIRPfcwQtWmOWTAuUUs2alAATS+CCIJBHGpHn/Ael0BcYTIEEKe4EzJdc4h3NKCVRKcQffjQRZ9gYSSIdcrz3B87pctbjVxDyQ3fGock=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.32; Wed, 4 Nov
 2020 15:52:28 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::4f5:fbe5:44a7:cb8a]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::4f5:fbe5:44a7:cb8a%5]) with mapi id 15.20.3499.032; Wed, 4 Nov 2020
 15:52:28 +0000
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
Subject: [PATCH v3 03/24] wfx: add Makefile/Kconfig
Date:   Wed,  4 Nov 2020 16:51:46 +0100
Message-Id: <20201104155207.128076-4-Jerome.Pouiller@silabs.com>
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
Received: from pc-42.silabs.com (82.67.86.106) by SN6PR01CA0032.prod.exchangelabs.com (2603:10b6:805:b6::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.19 via Frontend Transport; Wed, 4 Nov 2020 15:52:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4b96683e-9dad-41fd-77a3-08d880d9a1c6
X-MS-TrafficTypeDiagnostic: SN6PR11MB2718:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB27187180C8FAC668E627446693EF0@SN6PR11MB2718.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 29Z6nyaouE0IUsSi69Jbole6ftmQcoHFISOHac+0zj/q42cPevH64blfElB4HzWPMZlSSUcu5yxOWRVqti4C/cY2D1+kiQ9mrb9H2maH2jAvoAJArNbnbVZrj1vGIegLKSE513bfjGMRAj60AGCFwKwtwDNJeRcciXpluNpQ7nQ7S17983w0DaJoQ16Kikwy6mez8Y9Pig195fDRBAORS/U6Xl+Hnj8oQxS/iTPHonCIUNyjZl53XrK4ckXXDZwHCikP3RS3YWx4vUwtYN+GUmpLaRTRLvqQtxd2Z25NNuJ1QFfN3lZbLTAr+5LeFNDx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(376002)(39850400004)(136003)(396003)(8936002)(478600001)(186003)(16526019)(956004)(2616005)(6486002)(8676002)(66574015)(66476007)(66556008)(66946007)(316002)(7696005)(6666004)(26005)(54906003)(107886003)(36756003)(52116002)(7416002)(4326008)(5660300002)(86362001)(1076003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: RSgRNvTUS0ndq/MivqdjErm7zrZocnxzL6iMY21cwnWyvCtfvAGWwRdDSOdRifuQAnZFGHKK5uCiX/qHLPKdmXJuOtE0bTvL2mJAQRRKzahek8yyZn1YX/40YOGB5zFGlqMoJE2X26plHeL61QlCaGhpnf6emV6Y7jMa4xOJqLbLjm+9B2Bk71Ngb9PJlkSNHfuHWkY0I2bzOYo3tKbPnJOuPMN92C4MBcn+24QOYmyyEctqpNN3fHJiD/4lmQOmcwZrtoA4PdmiIvNaqHk5nPnfwDzqh3snVM1CWjiwEq/CPcTcmJtrrLXHiBHYto4Bxi9uAS/6KWAgsNcYp1UT9wEA1uF/bhDner/RdxSocw2yIE4v7/BPbURb7GfQxjFjSAsISZ16nkqmcWHqGCQ9qBwnsDKm5FgN9qM8XjkDE2vbOznEsgVOiXav/hv1SCFNHb2k+Ifpt/Ns42kZeUR8jIpf63duYo7i68bMI9CsVsoKC3nxW4ggBZ4hplxCJiQHPRBqzLOUkxHjx+EKaCbZl+KWruUeNJ8N7/7fUNnlyZfEteXvflQ0Au+xaOJLOQQUfsFOTd9hXyfA+jLEU1/FGfOSjoVmFXzMH+6Yvct/5NiIZd6qHUsZZ5KXYEu7PdW+CH67sw3cgPoJKEbXtc3jmg==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b96683e-9dad-41fd-77a3-08d880d9a1c6
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2020 15:52:28.5411
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Dgx6bin2OEI7w6p4y846ZL47M28aQ9Dwim8htynT1lZy9rG2jcsQNeCcZEKfe4+77KxMxvguyYKpspioTwbCWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2718
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
