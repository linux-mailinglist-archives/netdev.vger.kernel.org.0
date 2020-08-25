Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A2A02514C4
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 10:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729083AbgHYI7Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 04:59:16 -0400
Received: from mail-dm6nam12on2052.outbound.protection.outlook.com ([40.107.243.52]:53959
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729510AbgHYI7M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Aug 2020 04:59:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W5oju9XSC/LULpopqARkQKfw2cZ8vgR8ox/9Sb6pQFd0f8b6F60R82T4F07ZGjXhN4gnHvaviPQ7f/CZOS6ZRZ6IxWALm0IiJDxuYCW7al1M0JMXEgQH6gBBeaAkdQhqrx9lSx9yTYl/B1zqFQBNy2CHSxLJ+8qMIfebwYfuO98qDWlZPlNxc0cU5c1w1q1wvm4PC2cCeYROPPLL9hofQqKWlcZZjOxtjuFIy+/c4AAFaaCMWDbw7Rctxy/GujxyA4hl9MpZCoeFFQmDQZJ3jxLnGlhvFpq44W8fdyEsNwJuWgG75CnljomZ3OnKSZCXo17ceJDX0xAp1pNXuZWwBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qvHPU1fTvFig2Ymc0rY03r6D4O5Ye4R48U2j5KKlVVI=;
 b=fADilR4xJrlCYXGnsSZtkOrxBxxLuMjsqfx+46StV+PKunZowa1oCcqhVsIwyFeM2GYrBX6sLEYdSHQpNXFCQn4avBhhQdED+X2wQ+lvkcEfBAuyMZZSt/kVVbqV2bic9TOhjExImbGUcKX/OBvInxAaJ3vKQINnbVAOwqjipvAZgk06RQ20QObqitKOV+PDtB7RptmRusm/4cBNE0Y8Ot93nlhmYEDlPcckUe9lnokcrthZJo3/1xTeaJ6PQw9DWAtPpqBhqu1wPYDP+jXHemYVvp5ZUfjgzB8HlldujdhahR60vB41ne4RBBWZdhVrH9SV9ptAuDgXT7glS+hBxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qvHPU1fTvFig2Ymc0rY03r6D4O5Ye4R48U2j5KKlVVI=;
 b=cnX9shyEuif2xdc16BQuQ9a9jKGXkGdBz9jQlXLIE0KMfr85wyUcSiJWXI5lojAIVKawx3ni/fXEbnMOjDDBgfzfAsUWWYUu09WkwEe2Ihj2Um8tVKHtDFzXUrvii++zC5fgxxls/tcyH7b7NUd/jLfj7UGimx5UptnhFMQbH7A=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB3501.namprd11.prod.outlook.com (2603:10b6:805:d4::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.26; Tue, 25 Aug
 2020 08:59:00 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6%4]) with mapi id 15.20.3305.026; Tue, 25 Aug 2020
 08:59:00 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v2 04/12] staging: wfx: fix spaces around binary operators
Date:   Tue, 25 Aug 2020 10:58:20 +0200
Message-Id: <20200825085828.399505-4-Jerome.Pouiller@silabs.com>
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
Received: from 255.255.255.255 (255.255.255.255) by PR3P192CA0002.EURP192.PROD.OUTLOOK.COM (2603:10a6:102:56::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19 via Frontend Transport; Tue, 25 Aug 2020 08:58:58 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [37.71.187.125]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5abe446b-2fff-4db5-fab3-08d848d51b65
X-MS-TrafficTypeDiagnostic: SN6PR11MB3501:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB3501EF3AE0E0BA032CC1BE8493570@SN6PR11MB3501.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:241;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uCzpSH+v8YoQRlGrfsHWI38Ow0j+UbJmVMoSKCVwU2I6XilW6U+30BvG0WQmW2+MzscdKiX6031vaB0VCZPY43idkj6Q9DMzZidOeO14P/LJSEuBxUrTRIBhjwwXckuSCztoDxDuOw4tkht7sPbCrcUyyW9Weyro2xomrUI/sdgVCOE/L1RO4IF2xfaLWG78Vsg4iEIDZZ4Up5KCTJryCFIJJz0yPDKKkJNMwaPQ3RL3VQn4NJLOmrJDvQvo6kQHz0Mzag8WKdFxn4muLC5590dvK6IisTkXvTsUPJlAzVosXl7fxyjpdmHZWR2C1QfcicT+bApIA9SVOQxBcFG4KQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39830400003)(396003)(346002)(376002)(366004)(316002)(5660300002)(478600001)(107886003)(1076003)(8936002)(83380400001)(16576012)(956004)(66556008)(66476007)(26005)(2616005)(186003)(8676002)(86362001)(66946007)(6486002)(54906003)(6666004)(36756003)(4326008)(2906002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: etOMb8doo3V9UXRT0FNq3nNKBMBnj2/zB0zpS+JmU4xS10GUeTXGeZE3ucVVvc3eoyWJcxUAHQfWfmlvaLGEjX7npz1yWy++9QBnbYZFOU2BV3CSXMAl+VQYyZKL6Rn/6uVNpU+n5NeH/f3kxB+i0WReWCCEo0MtJXmmFlb53wIdEm24tEt3rXPE6jL+6FwamyLEPbjurXDDQd38GMmDs2iKIqAC+80JSsxhTxX4OEmOYGbMsZev+O1r88lXGtrbObClRjNHuEomdfJDZH7wXJ9CvYuwdryCxw9uRqDHwJdn2bNJOOFK6F9NJUGeON1zQaLSvz/2Z/kn42xVgP0ZvDo73qJfNsLCDG93UjpTJK6CFMzApxXnfgaAFa3e5njwLCcoLMLj6xsP33uuwVgiNuGIP2QB3ZEMbBF6kOPrnALSxZenvVIiW5lZGcvRP2qHxIvIldH5IAL+AcdUYVZNpcFMZTgH7WkjZRvEi1LLvjYXF6fbJXHJEzfzuJz68ucy8cSbyNBSfbFsQwuVdOsp6Io1FuqZ5HLkidnaGq88TXIPCYfT0/DNFqdS3+eAPFJK7gtq//z7ax5dJiDmKGPLO0EclId0RAIHym1t5Jb1fmSKF0ZxZ9YbXdkBxH8MiBIXOH/rHEWAJu5BLB88F5gdHA==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5abe446b-2fff-4db5-fab3-08d848d51b65
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2020 08:58:59.9626
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R0lUTv2YSevXcpxhWvp+JjpBLCEApxe7vKtfNEOUQ5h67DF84ZdrFZ9T6JcigSgdgAZO1RuOVvsfOYav9r+R5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3501
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKQSBi
aW5hcnkgb3BlcmF0b3Igc2hvdWxkIGJlIGZvbGxvd2VkIGJ5IGV4YWN0bHkgb25lIHNwYWNlLgoK
U2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMu
Y29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngva2V5LmMgfCA2ICsrKy0tLQogMSBmaWxlIGNo
YW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2
ZXJzL3N0YWdpbmcvd2Z4L2tleS5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9rZXkuYwppbmRleCA1
ZWUyZmZjNWY5MzUuLjYxNjVkZjU5ZWNmOSAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dm
eC9rZXkuYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2tleS5jCkBAIC0xNzEsNyArMTcxLDcg
QEAgc3RhdGljIGludCB3ZnhfYWRkX2tleShzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwgc3RydWN0IGll
ZWU4MDIxMV9zdGEgKnN0YSwKIAlrLmludF9pZCA9IHd2aWYtPmlkOwogCWsuZW50cnlfaW5kZXgg
PSBpZHg7CiAJaWYgKGtleS0+Y2lwaGVyID09IFdMQU5fQ0lQSEVSX1NVSVRFX1dFUDQwIHx8Ci0J
ICAgIGtleS0+Y2lwaGVyID09ICBXTEFOX0NJUEhFUl9TVUlURV9XRVAxMDQpIHsKKwkgICAga2V5
LT5jaXBoZXIgPT0gV0xBTl9DSVBIRVJfU1VJVEVfV0VQMTA0KSB7CiAJCWlmIChwYWlyd2lzZSkK
IAkJCWsudHlwZSA9IGZpbGxfd2VwX3BhaXIoJmsua2V5LndlcF9wYWlyd2lzZV9rZXksIGtleSwK
IAkJCQkJICAgICAgIHN0YS0+YWRkcik7CkBAIC0xOTEsMTMgKzE5MSwxMyBAQCBzdGF0aWMgaW50
IHdmeF9hZGRfa2V5KHN0cnVjdCB3ZnhfdmlmICp3dmlmLCBzdHJ1Y3QgaWVlZTgwMjExX3N0YSAq
c3RhLAogCQllbHNlCiAJCQlrLnR5cGUgPSBmaWxsX2NjbXBfZ3JvdXAoJmsua2V5LmFlc19ncm91
cF9rZXksIGtleSwKIAkJCQkJCSAmc2VxKTsKLQl9IGVsc2UgaWYgKGtleS0+Y2lwaGVyID09ICBX
TEFOX0NJUEhFUl9TVUlURV9TTVM0KSB7CisJfSBlbHNlIGlmIChrZXktPmNpcGhlciA9PSBXTEFO
X0NJUEhFUl9TVUlURV9TTVM0KSB7CiAJCWlmIChwYWlyd2lzZSkKIAkJCWsudHlwZSA9IGZpbGxf
c21zNF9wYWlyKCZrLmtleS53YXBpX3BhaXJ3aXNlX2tleSwga2V5LAogCQkJCQkJc3RhLT5hZGRy
KTsKIAkJZWxzZQogCQkJay50eXBlID0gZmlsbF9zbXM0X2dyb3VwKCZrLmtleS53YXBpX2dyb3Vw
X2tleSwga2V5KTsKLQl9IGVsc2UgaWYgKGtleS0+Y2lwaGVyID09ICBXTEFOX0NJUEhFUl9TVUlU
RV9BRVNfQ01BQykgeworCX0gZWxzZSBpZiAoa2V5LT5jaXBoZXIgPT0gV0xBTl9DSVBIRVJfU1VJ
VEVfQUVTX0NNQUMpIHsKIAkJay50eXBlID0gZmlsbF9hZXNfY21hY19ncm91cCgmay5rZXkuaWd0
a19ncm91cF9rZXksIGtleSwKIAkJCQkJICAgICAmc2VxKTsKIAl9IGVsc2UgewotLSAKMi4yOC4w
Cgo=
