Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18C552514E4
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 11:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729114AbgHYJAi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 05:00:38 -0400
Received: from mail-dm6nam12on2052.outbound.protection.outlook.com ([40.107.243.52]:53959
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729648AbgHYI7o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Aug 2020 04:59:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Me4DxsiUxQmHgjT+of1CMTTTsRa1fiqFe0bfsEaHdvyxCjoywtbfTLapY5PLqK+fJVNfSDtiEskKsonWAgSLXFyjjQfZrMOBhQfJtEivzZ8nGmgTZeg2kyQ9MU6/rOFrtsK09UTWYlE8kLXO4vVbHIQiHzuoh/6/1VHb3YL7+K3DIyDlabYxPXeMeC3FuHpNuldcAGYTqN6o07xbhErqMSMDEPPUqfgB0ecTbpEGcimQGgj8OVr0D4OC7YVEyk6or7NCjQwcI+a0aBTam0RMeP3rSMfo2U8TPYmBMnepz8O3hY/kXwUsXFZBu1u3tw/rZrcOcymYu/KDt0Nl670MOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UpyoGU4FzcSEiHvu1sHhSwYfCgw6bHk1zKFXGBQ+uEE=;
 b=HsvL18Srt9jBf/GKDug+aWTPRRAkyJdW1GS1g6AwqKXUiJ5DfkuNq4tqyCBUK2QYqhUSstKbb6oL7HhUd7zT3eshfzv3lFZ2/BKJ61a7sXOs8UoCCKaxFzyUjedKgDQec4MXs1BODyte2AKGCYI3yDuFIRYQlxePjVkpEnrECOJEmcQvg5yawYKSsdT/cWv9KG1f/LnvkU+DRxR5r1R3QkLb8Xr4GKytEkLDKGUrYQH62GooQJOhhSYOVGgrPHKRRju37CahiDveRgPALZvzXhIY0t+BVtjJ0Gxkt+6Fu8UuA/FcMW5FCneM+L9aTBGv9pD6LOi8sJn1qlpUEqnRmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UpyoGU4FzcSEiHvu1sHhSwYfCgw6bHk1zKFXGBQ+uEE=;
 b=I93WFmi1xx5FxS6L9Nmi9K9P2dO9YKG4Lmigb4r/ToQAkorgFbee2uJ+cRZvYjqA1TAU1YsqFyfk1BChzyqy3fk5hdG3e0hei1ayC+ScTYunm7gD1bqolxrM0FD+vmuk55oGI1p/U/LXzbMkSOqrsfQ2ko6Ud0yCR4xG78UKFJU=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB3501.namprd11.prod.outlook.com (2603:10b6:805:d4::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.26; Tue, 25 Aug
 2020 08:59:08 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6%4]) with mapi id 15.20.3305.026; Tue, 25 Aug 2020
 08:59:08 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v2 09/12] staging: wfx: scan while AP is supported
Date:   Tue, 25 Aug 2020 10:58:25 +0200
Message-Id: <20200825085828.399505-9-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200825085828.399505-1-Jerome.Pouiller@silabs.com>
References: <20200825085828.399505-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR3P192CA0002.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:102:56::7) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by PR3P192CA0002.EURP192.PROD.OUTLOOK.COM (2603:10a6:102:56::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19 via Frontend Transport; Tue, 25 Aug 2020 08:59:07 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [37.71.187.125]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bb83dc8e-ebb7-4844-11ac-08d848d5208d
X-MS-TrafficTypeDiagnostic: SN6PR11MB3501:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB3501A08ABBEA725A66CDCB5F93570@SN6PR11MB3501.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:901;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lubL0CajL2PuEkctUBhWb63qwCy1VsAkX7PSl/ipDLHIc6SPhdU4v1TyBBQCl22U6yS81ZV1Yckfnf/K4/omLNpbAkHMPRaWYMNGTOtJBboPMJOLjNmHAAUknq79s7IVVJhKdInxfpoXEzJhzp0V8pPXPR0vZdQ+WqMvlZYlMR+vJdn38Oa2d3o+5l+DhJ//9uhHd3+f7RnQi75BZIcI9tsx6KFRqavZASzvNFKEcS/RAPziC62aojDikcro5JiNh1dQlp8Hr64hq0DZNq7VwT7NLynrKcKoFvaZQ2xyYwetnT1U0LvjwNq/G3K3kA1yrJwhSubdmmU+L2o3a1JczQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39840400004)(396003)(346002)(376002)(366004)(316002)(5660300002)(478600001)(107886003)(1076003)(8936002)(83380400001)(16576012)(956004)(66556008)(66476007)(26005)(2616005)(186003)(8676002)(86362001)(66946007)(6486002)(54906003)(6666004)(36756003)(4326008)(66574015)(2906002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Jmb0Nse3aCxOW+60unnb7Q0FERusZ43oSKAU+3iHk/u93LvrQr5sSvITaeyH9LGhf7EhBF3CdmKJiKESkbTSb+trON8MdBG3+ef1BV5bydp3Me/CJK5vhGn2pJ+8ApoUigwERdccOT8Vk3a+7nT8d/Q+3LHe3f6dSMBKLgOuefluayJsRof0zW0s8gsC1RahnR69Z8Pr8/5oHdX7s8LFWhJIMqAzT+8Ov/oXh1NWc+FiL8HUtdpdBgEqU01ijX6fR5FVFs/GK057sQ3qnzq4Blg0xeKcE4nteqLH01WOkrS3+hBgIGBOi4pegSdcH+VrpmUZrj1cgOP/GbNaVggbltd6EJY6eip1FZV/7SFwQUBkvtn1nzTLnz11tB3Tsti446cNJzYToghrCD1Qz/NdgqVPudbenkOKyrQ9Lz744pJbfZsRt4HW+vMj5Eq5gEP6qH6+URSDAb2AACtbZcd1cu7BoxLFqKdrrJfoTE60Yy1v/kbmLRpjV6wugtIlimsHW/uEA7e55ajDBMzUA40boTMSq+8WNOwCQoxHPQ15rYuNxzdnaaVfr1SusYt1nrrGxTFyn0V2MfdfEb5xtY5n2PpXwx8WUUNp9VTJGN9dXdA5h4GaKd9qyl3c2IefqOQLeSDOOmYAmf5zd6tL5Q1EoA==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb83dc8e-ebb7-4844-11ac-08d848d5208d
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2020 08:59:08.6453
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZjTlLJ1IaaOpITAeQkdLFnpUgvFZWu50ul8DvN4Ewix594RVm96Wr1RgzuTCP999wX200hrlg2XuDNtzdwnfYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3501
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IGRldmljZSBpcyBhYmxlIHRvIHNjYW4gd2hpbGUgcnVubmluZyBhbiBBY2Nlc3MgUG9pbnQuIEp1
c3QgZGVjbGFyZQppdC4KClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUu
cG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L21haW4uYyB8IDEg
KwogZHJpdmVycy9zdGFnaW5nL3dmeC9zY2FuLmMgfCA0IC0tLS0KIDIgZmlsZXMgY2hhbmdlZCwg
MSBpbnNlcnRpb24oKyksIDQgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFn
aW5nL3dmeC9tYWluLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L21haW4uYwppbmRleCA0MjYzZjkx
Mjc2MGIuLjVhMzAxOGUxNDQ0NSAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9tYWlu
LmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9tYWluLmMKQEAgLTI4Miw2ICsyODIsNyBAQCBz
dHJ1Y3Qgd2Z4X2RldiAqd2Z4X2luaXRfY29tbW9uKHN0cnVjdCBkZXZpY2UgKmRldiwKIAkJCQkJ
Tkw4MDIxMV9QUk9CRV9SRVNQX09GRkxPQURfU1VQUE9SVF9XUFMyIHwKIAkJCQkJTkw4MDIxMV9Q
Uk9CRV9SRVNQX09GRkxPQURfU1VQUE9SVF9QMlAgfAogCQkJCQlOTDgwMjExX1BST0JFX1JFU1Bf
T0ZGTE9BRF9TVVBQT1JUXzgwMjExVTsKKwlody0+d2lwaHktPmZlYXR1cmVzIHw9IE5MODAyMTFf
RkVBVFVSRV9BUF9TQ0FOOwogCWh3LT53aXBoeS0+ZmxhZ3MgfD0gV0lQSFlfRkxBR19BUF9QUk9C
RV9SRVNQX09GRkxPQUQ7CiAJaHctPndpcGh5LT5mbGFncyB8PSBXSVBIWV9GTEFHX0FQX1VBUFNE
OwogCWh3LT53aXBoeS0+ZmxhZ3MgJj0gfldJUEhZX0ZMQUdfUFNfT05fQllfREVGQVVMVDsKZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc2Nhbi5jIGIvZHJpdmVycy9zdGFnaW5nL3dm
eC9zY2FuLmMKaW5kZXggZTlkZTE5Nzg0ODY1Li4wMmQ0ZTY1M2Q1OTQgMTAwNjQ0Ci0tLSBhL2Ry
aXZlcnMvc3RhZ2luZy93Zngvc2Nhbi5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc2Nhbi5j
CkBAIC0xMTMsMTAgKzExMyw2IEBAIGludCB3ZnhfaHdfc2NhbihzdHJ1Y3QgaWVlZTgwMjExX2h3
ICpodywgc3RydWN0IGllZWU4MDIxMV92aWYgKnZpZiwKIAlzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiA9
IChzdHJ1Y3Qgd2Z4X3ZpZiAqKXZpZi0+ZHJ2X3ByaXY7CiAKIAlXQVJOX09OKGh3X3JlcS0+cmVx
Lm5fY2hhbm5lbHMgPiBISUZfQVBJX01BWF9OQl9DSEFOTkVMUyk7Ci0KLQlpZiAodmlmLT50eXBl
ID09IE5MODAyMTFfSUZUWVBFX0FQKQotCQlyZXR1cm4gLUVPUE5PVFNVUFA7Ci0KIAl3dmlmLT5z
Y2FuX3JlcSA9IGh3X3JlcTsKIAlzY2hlZHVsZV93b3JrKCZ3dmlmLT5zY2FuX3dvcmspOwogCXJl
dHVybiAwOwotLSAKMi4yOC4wCgo=
