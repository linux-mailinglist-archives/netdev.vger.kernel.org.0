Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 972CB1D486E
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 10:34:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728128AbgEOIeU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 04:34:20 -0400
Received: from mail-dm6nam11on2086.outbound.protection.outlook.com ([40.107.223.86]:6138
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726694AbgEOIeQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 04:34:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ffGLu70hxTnA5HhcJGRocs5nZGV5r1szLZNuL3USMm+XakJPfkXAzzI3lMy35rgucsZfemni7Gcm6X+v1BS/46IlecXJXCMF6GyjEUSghcgzBU5Ss9I9HFNjO1IPAeVjmBJJOCxWLT1v2dPEfapS9r/QMygYOMZQh4bmkj0udnw7SPyQcBAaMJ9ajiXOUZnLzwTn/yyE2QBY2v7FfW0YEsjCxNO/5XO+dlEVRXDwpu/uE09wlZyrN6/dMA14PD2gjIIHHMRF/avzI5DD5/7FToBCsaC8XC79I0ooYA63IiclVgkkBEUaO5FGVjws4MDZZ6STbECWjq8oo/ohaZ9NGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8jRlFmhUxyj2LOBO/Mc6KTUuxSiZl0gfbJMZcHyEgAY=;
 b=lWw7a6XNqC1YjuyFajHUaE9Jst4SG2r6P3E+0BDZ0wZxJMTd9CLSYsGU2UM0ZOs1uXrqhMUVFbmq3RqZWfOytK1XnzgTsGRKN6+bKhVr6ZHEXBf+5AIamORb20pGDn+gh247NDpQTFswj6JXP5ulEVPZQwSEW/OLKPg0MK2vOrf0Fs4M+IOrHAAGasvaTLLv5bwFxtwoso0jxguP0xNps+a0rF2GmCCqVBmb+eC1irXeFvo/Yz6kRfTdaWY8mv0IcdUhpifuqbwsuTKd64pkryG7UoIeYESPQisiMb/N1ay0twSqZYOngGVwuFdKVAM+nOA2+nYT1tPIzZK4hOCFwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8jRlFmhUxyj2LOBO/Mc6KTUuxSiZl0gfbJMZcHyEgAY=;
 b=mlWmAi1zqZQaxxDuCrgTJtMAHyGNwc2IJwgO4+bSlT1fYFIxvUjY9O9toKfpvJLk/zVQ9nU4phPR5YIV+L22Y/Z0j8kKOkcNOUAhTfYi++EsnGIQiU6Iiawr/5qNRpZRgx2Y4XN0fcwIp9cdP13eYVrSIOiK66yhfO37zUmLJLA=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1310.namprd11.prod.outlook.com (2603:10b6:300:28::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26; Fri, 15 May
 2020 08:33:56 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da%5]) with mapi id 15.20.3000.022; Fri, 15 May 2020
 08:33:56 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 04/19] staging: wfx: fix value of scan timeout
Date:   Fri, 15 May 2020 10:33:10 +0200
Message-Id: <20200515083325.378539-5-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200515083325.378539-1-Jerome.Pouiller@silabs.com>
References: <20200515083325.378539-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR0P264CA0076.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:18::16) To MWHPR11MB1775.namprd11.prod.outlook.com
 (2603:10b6:300:10e::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.home (82.67.86.106) by PR0P264CA0076.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:18::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.24 via Frontend Transport; Fri, 15 May 2020 08:33:54 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [82.67.86.106]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7340fee5-4fe9-4ae1-d6f8-08d7f8aab4d4
X-MS-TrafficTypeDiagnostic: MWHPR11MB1310:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB13104BE486EB17B1EABB535993BD0@MWHPR11MB1310.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-Forefront-PRVS: 04041A2886
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cBKptWlY9Jyf9CA8yDlfINQpmxxVRwdbgixvEdXLwWB6lmF6jopqKhxtgyKyVp7yRQk9fn2qC/jso7qZLAlXimVjIpBgiE048NAtKT+a+cPECfcgjXnC0Ua24AaU/fFOAN/uuQb0vri4fjzRhvTaGsq5VoBTEIqi2aK/jz16Vj9JXy20k9XiABqQIfs6xEcu7+lMZC5gDTu7C+Rn6qx7dn+4qFx6wJw5GY6KL978PQ5QRt+n02YSGd9fTIsA+jQ9hAzF8I9106y3+MhBrH+wgiyIUrxFSlLVlvp35c+DvMC08MpRXDBynxn4DLl4kNQaIwsc95kqstmlDwOCN/WQ1M30QFOCsHzCdnTFGCIDjdkPsnEWT6k3SFsjJyIUUAIa/+fG42a02FMJkFCGekjTpDgLbnyFcsauMhMPssS3dJXTrMzzHCQ5eia0ky+l3TgA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(136003)(376002)(366004)(39850400004)(396003)(8886007)(66556008)(186003)(6512007)(66946007)(6506007)(36756003)(316002)(66476007)(26005)(52116002)(16526019)(6666004)(54906003)(2906002)(2616005)(478600001)(66574014)(107886003)(956004)(8936002)(86362001)(8676002)(6486002)(5660300002)(4326008)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 4H8gx0tcifNjFZDJ2vma6U8k57MWrbO7UUD0f2Dt6y1DkkxJzPc/eqmsoULhY6JIHsRRbZY8yZJSx7FsOlQXPqoUpz2pa99jVw+xicvH/mpf1Z9jLRx6TKQO+MezrPCR98cI8BJQEKIAlZShAMDVxS07MeaxGLd3hfvmrZZjIB4w3w3HottcuQGCUizYTB589EqfxeBUpYUr7dA/BldICe6NWCn+KlbEAnuE+yd9KTnwBH4C+sJB14QITExDvvmoizlEtDeC99DqGk5dagoxachRbIrCigaC6zG28rWb2RU3Ac/HNCeuuk4nv1XFj3q1BttTtnZqrI92U79XHNAiz4Nxtrb9Xbr3DTAAgw6Wk/T8cfA9C8KRJy1YO8V4d/YhBGWf5l0Y/kYMYWkVjlhGpSGOcfUxYr+hrLcUaIRGP7CdbV3Wx+jligKstWNbY8WrJfgvd3LLshSvbFB89Ze4rwTvP7iSLPV1Jw5qZ7w1MB4=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7340fee5-4fe9-4ae1-d6f8-08d7f8aab4d4
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2020 08:33:55.9620
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VCMO2a2uyBueqx+8kC+nh3JGeEVztaBMFcQ1mvqTuxxhT3KILdNnyWXMsCvRMNw6/v3kCY4R1x33mRaNqg2M5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1310
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKQmVm
b3JlIHRvIHN0YXJ0IHRoZSBzY2FuIHJlcXVlc3QsIHRoZSBmaXJtd2FyZSBzaWduYWxzICh3aXRo
IGEgbnVsbApmcmFtZSkgdG8gdGhlIEFQIGl0IHdvbid0IGJlIGFibGUgdG8gcmVjZWl2ZSBkYXRh
LiBUaGlzIGZyYW1lIGNhbiBiZQpsb25nIHRvIHNlbmQ6IHVwIHRvIDUxMlRVLiBUaGUgY3VycmVu
dCBjYWxjdWx1cyBvZiB0aGUgc2NhbiB0aW1lb3V0IGRvZXMKbm90IHRha2UgaW50byBhY2NvdW50
IHRoaXMgZGVsYXkuCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBv
dWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHguYyB8IDIg
Ky0KIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAt
LWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4LmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4
L2hpZl90eC5jCmluZGV4IDFjYjcxZjBhZDgwNC4uODkzYjY3ZjJmNzkyIDEwMDY0NAotLS0gYS9k
cml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlm
X3R4LmMKQEAgLTI4OCw3ICsyODgsNyBAQCBpbnQgaGlmX3NjYW4oc3RydWN0IHdmeF92aWYgKnd2
aWYsIHN0cnVjdCBjZmc4MDIxMV9zY2FuX3JlcXVlc3QgKnJlcSwKIAl0bW9fY2hhbl9iZyA9IGxl
MzJfdG9fY3B1KGJvZHktPm1heF9jaGFubmVsX3RpbWUpICogVVNFQ19QRVJfVFU7CiAJdG1vX2No
YW5fZmcgPSA1MTIgKiBVU0VDX1BFUl9UVSArIGJvZHktPnByb2JlX2RlbGF5OwogCXRtb19jaGFu
X2ZnICo9IGJvZHktPm51bV9vZl9wcm9iZV9yZXF1ZXN0czsKLQl0bW8gPSBjaGFuX251bSAqIG1h
eCh0bW9fY2hhbl9iZywgdG1vX2NoYW5fZmcpOworCXRtbyA9IGNoYW5fbnVtICogbWF4KHRtb19j
aGFuX2JnLCB0bW9fY2hhbl9mZykgKyA1MTIgKiBVU0VDX1BFUl9UVTsKIAogCXdmeF9maWxsX2hl
YWRlcihoaWYsIHd2aWYtPmlkLCBISUZfUkVRX0lEX1NUQVJUX1NDQU4sIGJ1Zl9sZW4pOwogCXJl
dCA9IHdmeF9jbWRfc2VuZCh3dmlmLT53ZGV2LCBoaWYsIE5VTEwsIDAsIGZhbHNlKTsKLS0gCjIu
MjYuMgoK
