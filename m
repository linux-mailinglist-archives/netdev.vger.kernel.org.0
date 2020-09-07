Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA8EA25F821
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 12:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728877AbgIGK12 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 06:27:28 -0400
Received: from mail-eopbgr770081.outbound.protection.outlook.com ([40.107.77.81]:21675
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728704AbgIGKQR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 06:16:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aWwd23RDyRJp59GRletsDRKpqIZHnBfSv64T0wOV1ozQmMPHAcUuytfrC9eVjwn7SwH7qVvTvClaLMPY109kDLe3cWePoeN5crg9rtQwMoaQohP9Lp8f1wcXCYofULFa3bzGgHJJms+7WrMJ/U8xc84cG9T6o9oE+FHjqrEqqI/nLtt4SkDnPSTaK7sCzkZQMx9XyJQplxICB9k0NvvDo9HqaVw4VCzI+9LOhxNxsZVwm0cJvJCsnGYOpwnaavtlVXFrZiLpdHOX/kMApc7sx4zzBQIyy2ZbiTGq5hbEvjz4CnCN+xrdO5A0GOkCHwUXqMdzFviMzR9wzJ1oKtqh3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YqztAsbl4nfn21gkjpH4w2DK6L/ANObHzTWyuyTLncI=;
 b=AHRqEnAEKv/WwXstWLnQRTpzBhXByG8I/S5+duYuuLpBRT+8yEoNPUaMIrVyWWtaRkc+/vrN0QpuEzwRrAJ+XnE+cMSb5zHj3BiNmSyU+Y/wQXMhXIYXj0YhAWdpixXIPcWQNxInLOwRguMF9GbDUQbkRK4sMuHNN14BE3196BGCznChoEfhL3iVpYprp9baE1n6uQ1Ko8hsAf9BDRMfu6MyLslU6C+0vycpzQ2TFauSue2Cb4+1VJ+q+xLKtBtCyk8Oqoia60HTa5IyYkY2gcxBnsuazvdbWJF1y9t65FNqGDFXFP6meY7HBNYeDQY0do4h7fA41cH1wQY2/jIQjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YqztAsbl4nfn21gkjpH4w2DK6L/ANObHzTWyuyTLncI=;
 b=jJ4P0e2xV/zEa1jfUGEqDKeGTjb6Xu6q9YrcYDz6G7fbD78mQyyRcH+ciJHrBVHy4aE2B6BtFIONOkKEovxck99nIgomRv2/qetkUDhq+ZgkJvB8kOU85qAP0KL+h0n2c/XmOi6ZSVx4ly3x/TPJnSgjtGapNCYAc6fzLzDWLHM=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB2606.namprd11.prod.outlook.com (2603:10b6:805:55::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.17; Mon, 7 Sep
 2020 10:16:02 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6%4]) with mapi id 15.20.3348.019; Mon, 7 Sep 2020
 10:16:02 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 11/31] staging: wfx: drop useless struct hif_ie_flags
Date:   Mon,  7 Sep 2020 12:15:01 +0200
Message-Id: <20200907101521.66082-12-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200907101521.66082-1-Jerome.Pouiller@silabs.com>
References: <20200907101521.66082-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR0P264CA0109.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:19::25) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (37.71.187.125) by PR0P264CA0109.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:19::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.16 via Frontend Transport; Mon, 7 Sep 2020 10:16:01 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [37.71.187.125]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 34189f51-5d9f-46df-5265-08d853170605
X-MS-TrafficTypeDiagnostic: SN6PR11MB2606:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB260636221D1F5AFF56D0F44993280@SN6PR11MB2606.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YhddmrIK2W2h8B68srIws20AbwPBEtK9MxKIXzfUXH7AMqYAnyS5aBrkUM1OOk6/0aBiX0GmJDc6gfySI5IObaeblANpSz4gADSSMk7oCMxkEGWlOYSvgqdXY/0YYCXpc8wjhuzhyfAIarwcImVevz26zj4linFCLnctS+OMzIK/TiNOYs9AqcQjRdHcGZyJGG3mnWzZFWI3eTuayp8kPDJmyoQL8gbibpXVUVpO72s/9tsBjv1GOvqxSnmu8QUXYyiDuDVYRbDRVj9iTwXMhv1u1L9CTjBLKgOFUex2DmDj5nyvSnWIgI2ppE5P0FzJi1iAz9TyBNa5ahRfHZwZrg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(346002)(366004)(136003)(39850400004)(66946007)(4326008)(5660300002)(2616005)(66476007)(316002)(956004)(478600001)(54906003)(52116002)(2906002)(66556008)(1076003)(36756003)(8676002)(86362001)(6486002)(8936002)(7696005)(66574015)(83380400001)(26005)(107886003)(16526019)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: autAfulsZJ9ISOsEo+aHpnbTL/w/wTOZSNGQWcU+2Gj9QGncF3Q24gTg6zTDIc3i2b2txcgDBmsOVFs/kBnQEcb9mpOr6Z+bxUBm7glGoLb+yJf7wIZS89aD4T0czIYjlvOA0hSmFZ2ybwhz9kd52ze2wYsL3OhXIDaKHeyUS4greeKjXixC3szEwkCtrv1y3SopeCdDcA00aLCPoxZggsTFo4zWkUev8uTA4kiDcaf3COE0A37EtrLzrIw5wyW4ypLTwY3ndXLP7CFs7PDWHfy8EOU3M+G3AM1kZg/VxKcLbCveGHolMsmZUdmvO3Y4l7xxY5f6vIpnF/77kbYLFkkse64fhsafiQZ5pXzNWhctN2T+WvIV/cO+aZ4YgJlnUS0/TYUSuN6OpAetfxvad1esJ9PQIbvIFSV1Cg/ayi3zRVzv0wDEn6t6S4kQSmxzV7wz9ob28YQCZlZX092m8UQopaKIgU/koOKF++fBre1iLxWqijVNS9zLw2sYbAheDVPAPevM0SIw6EXI+yvbQJyxoR7O5J8NVg3fi+2jNHVEf8D7VbWyjazgi5KjftqKOVDVSPMjC+ays3VaPdDnBSaDs1pwBd1VgdpkuOFawpn/hvOtWB3LX5hTD8/dD7ZPZ+CE67iN7cT7sKnln4oC4w==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34189f51-5d9f-46df-5265-08d853170605
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2020 10:16:02.4989
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0yEfgOwSOVwx3Li+CpLmsu/VrNGwtRe98MqKSLdS4T7gwLhxSqzAWBC559KmfEmyH0v8aPwvJsffyCnmSPIzAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2606
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKU3Ry
dWN0IGhpZl9pZV9mbGFncyBoYXMgbm8gcmVhc29uIHRvIGV4aXN0LiBEcm9wIGl0IGFuZCBzaW1w
bGlmeQphY2Nlc3MgdG8gc3RydWN0IGhpZl9yZXFfdXBkYXRlX2llLgoKU2lnbmVkLW9mZi1ieTog
SsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZl
cnMvc3RhZ2luZy93ZngvaGlmX2FwaV9jbWQuaCB8IDE0ICsrKysrLS0tLS0tLS0tCiBkcml2ZXJz
L3N0YWdpbmcvd2Z4L2hpZl90eC5jICAgICAgfCAgMiArLQogMiBmaWxlcyBjaGFuZ2VkLCA2IGlu
c2VydGlvbnMoKyksIDEwIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2lu
Zy93ZngvaGlmX2FwaV9jbWQuaCBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX2FwaV9jbWQuaApp
bmRleCAzZGE3MzZkYmY1MmMuLmIxMDRhYmJjNWIyNSAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFn
aW5nL3dmeC9oaWZfYXBpX2NtZC5oCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX2FwaV9j
bWQuaApAQCAtOTMsMTQgKzkzLDYgQEAgc3RydWN0IGhpZl9jbmZfd3JpdGVfbWliIHsKIAlfX2xl
MzIgc3RhdHVzOwogfSBfX3BhY2tlZDsKIAotc3RydWN0IGhpZl9pZV9mbGFncyB7Ci0JdTggICAg
IGJlYWNvbjoxOwotCXU4ICAgICBwcm9iZV9yZXNwOjE7Ci0JdTggICAgIHByb2JlX3JlcToxOwot
CXU4ICAgICByZXNlcnZlZDE6NTsKLQl1OCAgICAgcmVzZXJ2ZWQyOwotfSBfX3BhY2tlZDsKLQog
c3RydWN0IGhpZl9pZV90bHYgewogCXU4ICAgICB0eXBlOwogCXU4ICAgICBsZW5ndGg7CkBAIC0x
MDgsNyArMTAwLDExIEBAIHN0cnVjdCBoaWZfaWVfdGx2IHsKIH0gX19wYWNrZWQ7CiAKIHN0cnVj
dCBoaWZfcmVxX3VwZGF0ZV9pZSB7Ci0Jc3RydWN0IGhpZl9pZV9mbGFncyBpZV9mbGFnczsKKwl1
OCAgICAgYmVhY29uOjE7CisJdTggICAgIHByb2JlX3Jlc3A6MTsKKwl1OCAgICAgcHJvYmVfcmVx
OjE7CisJdTggICAgIHJlc2VydmVkMTo1OworCXU4ICAgICByZXNlcnZlZDI7CiAJX19sZTE2IG51
bV9pZXM7CiAJc3RydWN0IGhpZl9pZV90bHYgaWVbXTsKIH0gX19wYWNrZWQ7CmRpZmYgLS1naXQg
YS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZf
dHguYwppbmRleCA4NzM2ZWI0ZDVmMTUuLjQ5NTIzZTcwYWY2YyAxMDA2NDQKLS0tIGEvZHJpdmVy
cy9zdGFnaW5nL3dmeC9oaWZfdHguYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5j
CkBAIC01MjAsNyArNTIwLDcgQEAgaW50IGhpZl91cGRhdGVfaWVfYmVhY29uKHN0cnVjdCB3Znhf
dmlmICp3dmlmLCBjb25zdCB1OCAqaWVzLCBzaXplX3QgaWVzX2xlbikKIAogCWlmICghaGlmKQog
CQlyZXR1cm4gLUVOT01FTTsKLQlib2R5LT5pZV9mbGFncy5iZWFjb24gPSAxOworCWJvZHktPmJl
YWNvbiA9IDE7CiAJYm9keS0+bnVtX2llcyA9IGNwdV90b19sZTE2KDEpOwogCW1lbWNweShib2R5
LT5pZSwgaWVzLCBpZXNfbGVuKTsKIAl3ZnhfZmlsbF9oZWFkZXIoaGlmLCB3dmlmLT5pZCwgSElG
X1JFUV9JRF9VUERBVEVfSUUsIGJ1Zl9sZW4pOwotLSAKMi4yOC4wCgo=
