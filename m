Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 495DB2514D8
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 11:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729697AbgHYI7t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 04:59:49 -0400
Received: from mail-dm6nam12on2052.outbound.protection.outlook.com ([40.107.243.52]:53959
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729646AbgHYI7b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Aug 2020 04:59:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XCVwmowTOOdBcrCMXMsAHGnXXJ9Z9PcZmPu2VXiIKbd4FwHqLIh5xooEetipioHhDkDtVIZZkduE//FP2AQPGkUcF3HNzmsnZx84HtDzlSckvw9FUggfk9sS3HnZ6XobNRIsWm+aMPFXDw86zwqj8byWPYqLkurYcVW9qvoJeB+RT59t7H7VVEmE7dMR/EC3FGdkmqMeTCqbaHw6eoSZdeRjbtC6dR5NQsPrCkPnKKzaqRwaJRVenqcTOvF8V3Ok1YDiaXGDA9oNF6gOw/vYh7FdqEDjCvI5sARYj7iZRFPfgzTFMFEdwQUwADe5acxKJg8cYBkdqUEhcg/DmIp81A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vUCfAVxEEjw5fe6klsi9DKE0qPl2IHDqTZNcYCPBzxQ=;
 b=XfI3s2RnNLYEVlNoUiT58SbAsJY7SMLYxpAu08aw54Yy+BfEHSeNxoxAWhPSif8JtX3C9pArUb8tp1DPxvB+zTdVm8USusxueEJ19e49U9YvqwIrnesBnwlZD71Gk3mhG3+/NIk402l1FzhTQYmTp8MXAK1245tqbjL7c9CZweHHdZVYiBPj+SP5EMrBPdJckrYgqhD6p31/SpnDB+mi+xBJ5CYTKtNevJJ5Xh1GLbyJ2Jlne9KnbEfVI8rMwRJVYIOVH3vw4nhCH4g0s1x+2XQWaSY7oq3GtbVG3iPeHrY7oo6xOtE5cqzRwwyv7J2+RDGR9Cp2f5KFjtlIcOOn1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vUCfAVxEEjw5fe6klsi9DKE0qPl2IHDqTZNcYCPBzxQ=;
 b=dCygFhYQ2C/qUcqC8Xhf34BNtyDqieAq6L4DqAy7SAUmOaHZIuM5yRMuH2nilwW1eLp/ZVDGuCbrsbyDFW2DOtY8WEysAMNL3Ce6+SKw2RTsIhqQNMJy8Y3cJH0D2URWo1iRp5JGvEVFdnwk4jhDToPRgHr7bcTJwBEvkCCzRE8=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB3501.namprd11.prod.outlook.com (2603:10b6:805:d4::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.26; Tue, 25 Aug
 2020 08:59:07 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6%4]) with mapi id 15.20.3305.026; Tue, 25 Aug 2020
 08:59:07 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v2 08/12] staging: wfx: fix potential use before init
Date:   Tue, 25 Aug 2020 10:58:24 +0200
Message-Id: <20200825085828.399505-8-Jerome.Pouiller@silabs.com>
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
Received: from 255.255.255.255 (255.255.255.255) by PR3P192CA0002.EURP192.PROD.OUTLOOK.COM (2603:10a6:102:56::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19 via Frontend Transport; Tue, 25 Aug 2020 08:59:05 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [37.71.187.125]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 95f51a34-5838-43f9-974f-08d848d51f81
X-MS-TrafficTypeDiagnostic: SN6PR11MB3501:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB3501D2364BAD1D643710EC9D93570@SN6PR11MB3501.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: snfEWsImJyio9guHSCrMeH3/FFsoJvuwpe5rgKjIJ3DdQ1eNj/XLUus+Xg7+mbJPNtXn/BjZPArv4PmZ2gCzkU3GvezwFZuuaIKqsyO9HvQ7gUTmX4kKR+Xs1/8ifdUKEdp/bbjYJZ/YrRt8lYvCB2q8TZePUMKDdcdSe10R23v8WjD905sBGqFLSFH29fBUtm0YCWSfzezdpobBBXYJwoLfTwp/i+rTEuomFEwuLu4S4ZjJaNgnjY5V+fvU9WR0Rm0bPeJO7swQo+XUVWTWl1YG5rVRD0Spddk+r2csxT1yTD6Gfo66rjZRVvgc90h4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39830400003)(396003)(346002)(376002)(366004)(316002)(5660300002)(478600001)(107886003)(1076003)(8936002)(83380400001)(16576012)(956004)(66556008)(66476007)(26005)(2616005)(186003)(8676002)(86362001)(66946007)(6486002)(54906003)(6666004)(36756003)(4326008)(66574015)(2906002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 0dqNlV+XaIcVSytfSddL+5by+dPs2xeuzAwaGvRp8079faLgCmy22s4AUaverMnIyuaevCsSCnydcB555HtFuD7QcTBEwl04DrDqkRJ27T7pgvoMAcYNgsIuYU46/OuxnpK5hs7np43KSr6+465QxjxVwqJe3dVoe9Dlje8KhUzErUBZw4KY0HhtjX9rsacsFGD/QeRmhKUZWKXDu71jnijxb2MkirROFDaUlmYGpXMGXkv0I+aBXGaYwZtzE/OAEYGUdNfyt8IGlxxA1DUDHqExw9c6TIQ/Fvn+0c8Brto8IylPsZXab+0MpSiC04VJuhFjtaKBJkzS6mEeJ3J7SSl7EP2mOU07vn6nqUrQTbrYHLOmSe++SKJ4S3J17plz8eanDUe7mLfK6VnwbJqLlyDVj9eV0mzq8c5lCskIdMKTG+L1ga/swhSPzMcz8EQ9A6n2/+Dkpotb+cUDQMUvAU4zHxJiIuJqxgqlzXh34Y1gDVBhZdRhMh5oerqlZNPzU48+xzNX9+uoP2N7FlOiualShAxYMltIW4XeehMIhNSZBbztePV4xz1VwiKAR9HZyoOC2I/uI0ScT5kWTWvHN0EcjfM+wld0eZfzW+dYG57Dw6G3Zmoj8toYu8iRpn6CE7NfANmpZQDwxJHV65vRQw==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95f51a34-5838-43f9-974f-08d848d51f81
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2020 08:59:06.9793
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w321RENZLfi7gXx7jtMjs+Q+SLxRsZPM6coviv02wjPJ6aFIFKCzJ5YyQABXLpct06+4XtoEoLue59bvY50Q3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3501
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IHRyYWNlIGJlbG93IGNhbiBhcHBlYXI6CgogICAgWzgzNjEzLjgzMjIwMF0gSU5GTzogdHJ5aW5n
IHRvIHJlZ2lzdGVyIG5vbi1zdGF0aWMga2V5LgogICAgWzgzNjEzLjgzNzI0OF0gdGhlIGNvZGUg
aXMgZmluZSBidXQgbmVlZHMgbG9ja2RlcCBhbm5vdGF0aW9uLgogICAgWzgzNjEzLjg0MjgwOF0g
dHVybmluZyBvZmYgdGhlIGxvY2tpbmcgY29ycmVjdG5lc3MgdmFsaWRhdG9yLgogICAgWzgzNjEz
Ljg0ODM3NV0gQ1BVOiAzIFBJRDogMTQxIENvbW06IGt3b3JrZXIvMzoySCBUYWludGVkOiBHICAg
ICAgICAgICBPICAgICAgNS42LjEzLXNpbGFiczE1ICMyCiAgICBbODM2MTMuODU3MDE5XSBIYXJk
d2FyZSBuYW1lOiBCQ00yODM1CiAgICBbODM2MTMuODYwNjA1XSBXb3JrcXVldWU6IGV2ZW50c19o
aWdocHJpIGJoX3dvcmsgW3dmeF0KICAgIFs4MzYxMy44NjU1NTJdIEJhY2t0cmFjZToKICAgIFs4
MzYxMy44NjgwNDFdIFs8YzAxMGYyY2M+XSAoZHVtcF9iYWNrdHJhY2UpIGZyb20gWzxjMDEwZjdi
OD5dIChzaG93X3N0YWNrKzB4MjAvMHgyNCkKICAgIFs4MzYxMy44ODE0NjNdIFs8YzAxMGY3OTg+
XSAoc2hvd19zdGFjaykgZnJvbSBbPGMwZDgyMTM4Pl0gKGR1bXBfc3RhY2srMHhlOC8weDExNCkK
ICAgIFs4MzYxMy44ODg4ODJdIFs8YzBkODIwNTA+XSAoZHVtcF9zdGFjaykgZnJvbSBbPGMwMWEw
MmVjPl0gKHJlZ2lzdGVyX2xvY2tfY2xhc3MrMHg3NDgvMHg3NjgpCiAgICBbODM2MTMuOTA1MDM1
XSBbPGMwMTlmYmE0Pl0gKHJlZ2lzdGVyX2xvY2tfY2xhc3MpIGZyb20gWzxjMDE5ZGEwND5dIChf
X2xvY2tfYWNxdWlyZSsweDg4LzB4MTNkYykKICAgIFs4MzYxMy45MjQxOTJdIFs8YzAxOWQ5N2M+
XSAoX19sb2NrX2FjcXVpcmUpIGZyb20gWzxjMDE5ZjZhND5dIChsb2NrX2FjcXVpcmUrMHhlOC8w
eDI3NCkKICAgIFs4MzYxMy45NDI2NDRdIFs8YzAxOWY1YmM+XSAobG9ja19hY3F1aXJlKSBmcm9t
IFs8YzBkYWE1ZGM+XSAoX3Jhd19zcGluX2xvY2tfaXJxc2F2ZSsweDU4LzB4NmMpCiAgICBbODM2
MTMuOTYxNzE0XSBbPGMwZGFhNTg0Pl0gKF9yYXdfc3Bpbl9sb2NrX2lycXNhdmUpIGZyb20gWzxj
MGFiMzI0OD5dIChza2JfZGVxdWV1ZSsweDI0LzB4NzgpCiAgICBbODM2MTMuOTc0OTY3XSBbPGMw
YWIzMjI0Pl0gKHNrYl9kZXF1ZXVlKSBmcm9tIFs8YmYzMzBkYjA+XSAod2Z4X3R4X3F1ZXVlc19n
ZXQrMHg5NmMvMHgxMjk0IFt3ZnhdKQogICAgWzgzNjEzLjk4OTcyOF0gWzxiZjMzMDQ0ND5dICh3
ZnhfdHhfcXVldWVzX2dldCBbd2Z4XSkgZnJvbSBbPGJmMzIwNDU0Pl0gKGJoX3dvcmsrMHg0NTQv
MHgyNmQ4IFt3ZnhdKQogICAgWzgzNjE0LjAwOTMzN10gWzxiZjMyMDAwMD5dIChiaF93b3JrIFt3
ZnhdKSBmcm9tIFs8YzAxNGM5MjA+XSAocHJvY2Vzc19vbmVfd29yaysweDIzYy8weDdlYykKICAg
IFs4MzYxNC4wMjgxNDFdIFs8YzAxNGM2ZTQ+XSAocHJvY2Vzc19vbmVfd29yaykgZnJvbSBbPGMw
MTRjZjFjPl0gKHdvcmtlcl90aHJlYWQrMHg0Yy8weDU1YykKICAgIFs4MzYxNC4wNDY4NjFdIFs8
YzAxNGNlZDA+XSAod29ya2VyX3RocmVhZCkgZnJvbSBbPGMwMTU0YzA0Pl0gKGt0aHJlYWQrMHgx
MzgvMHgxNjgpCiAgICBbODM2MTQuMDY0ODc2XSBbPGMwMTU0YWNjPl0gKGt0aHJlYWQpIGZyb20g
WzxjMDEwMTBiND5dIChyZXRfZnJvbV9mb3JrKzB4MTQvMHgyMCkKICAgIFs4MzYxNC4wNzIyMDBd
IEV4Y2VwdGlvbiBzdGFjaygweGVjYWQzZmIwIHRvIDB4ZWNhZDNmZjgpCiAgICBbODM2MTQuMDc3
MzIzXSAzZmEwOiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAwMDAwMDAwMCAw
MDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAwMAogICAgWzgzNjE0LjA4NTYyMF0gM2ZjMDogMDAwMDAw
MDAgMDAwMDAwMDAgMDAwMDAwMDAgMDAwMDAwMDAgMDAwMDAwMDAgMDAwMDAwMDAgMDAwMDAwMDAg
MDAwMDAwMDAKICAgIFs4MzYxNC4wOTM5MTRdIDNmZTA6IDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAw
MDAwIDAwMDAwMDAwIDAwMDAwMDEzIDAwMDAwMDAwCgpJbmRlZWQsIHRoZSBjb2RlIG9mIHdmeF9h
ZGRfaW50ZXJmYWNlKCkgc2hvd3MgdGhhdCB0aGUgaW50ZXJmYWNlIGlzCmVuYWJsZWQgdG8gZWFy
bHkuIFNvLCB0aGUgc3BpbmxvY2sgYXNzb2NpYXRlZCB3aXRoIHNvbWUgc2tiX3F1ZXVlIG1heQpu
b3QgeWV0IGluaXRpYWxpemVkIHdoZW4gd2Z4X3R4X3F1ZXVlc19nZXQoKSBpcyBjYWxsZWQuCgpT
aWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5j
b20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYyB8IDMwICsrKysrKysrKysrKysrKy0t
LS0tLS0tLS0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDE1IGluc2VydGlvbnMoKyksIDE1IGRlbGV0
aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMgYi9kcml2ZXJz
L3N0YWdpbmcvd2Z4L3N0YS5jCmluZGV4IDdhNGM5ZjYzYzRhMi4uYTg5MGZlMzIxNjFjIDEwMDY0
NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93
Zngvc3RhLmMKQEAgLTc1OSwxNyArNzU5LDYgQEAgaW50IHdmeF9hZGRfaW50ZXJmYWNlKHN0cnVj
dCBpZWVlODAyMTFfaHcgKmh3LCBzdHJ1Y3QgaWVlZTgwMjExX3ZpZiAqdmlmKQogCQlyZXR1cm4g
LUVPUE5PVFNVUFA7CiAJfQogCi0JZm9yIChpID0gMDsgaSA8IEFSUkFZX1NJWkUod2Rldi0+dmlm
KTsgaSsrKSB7Ci0JCWlmICghd2Rldi0+dmlmW2ldKSB7Ci0JCQl3ZGV2LT52aWZbaV0gPSB2aWY7
Ci0JCQl3dmlmLT5pZCA9IGk7Ci0JCQlicmVhazsKLQkJfQotCX0KLQlpZiAoaSA9PSBBUlJBWV9T
SVpFKHdkZXYtPnZpZikpIHsKLQkJbXV0ZXhfdW5sb2NrKCZ3ZGV2LT5jb25mX211dGV4KTsKLQkJ
cmV0dXJuIC1FT1BOT1RTVVBQOwotCX0KIAkvLyBGSVhNRTogcHJlZmVyIHVzZSBvZiBjb250YWlu
ZXJfb2YoKSB0byBnZXQgdmlmCiAJd3ZpZi0+dmlmID0gdmlmOwogCXd2aWYtPndkZXYgPSB3ZGV2
OwpAQCAtNzg2LDEyICs3NzUsMjIgQEAgaW50IHdmeF9hZGRfaW50ZXJmYWNlKHN0cnVjdCBpZWVl
ODAyMTFfaHcgKmh3LCBzdHJ1Y3QgaWVlZTgwMjExX3ZpZiAqdmlmKQogCWluaXRfY29tcGxldGlv
bigmd3ZpZi0+c2Nhbl9jb21wbGV0ZSk7CiAJSU5JVF9XT1JLKCZ3dmlmLT5zY2FuX3dvcmssIHdm
eF9od19zY2FuX3dvcmspOwogCi0JbXV0ZXhfdW5sb2NrKCZ3ZGV2LT5jb25mX211dGV4KTsKLQot
CWhpZl9zZXRfbWFjYWRkcih3dmlmLCB2aWYtPmFkZHIpOwotCiAJd2Z4X3R4X3F1ZXVlc19pbml0
KHd2aWYpOwogCXdmeF90eF9wb2xpY3lfaW5pdCh3dmlmKTsKKworCWZvciAoaSA9IDA7IGkgPCBB
UlJBWV9TSVpFKHdkZXYtPnZpZik7IGkrKykgeworCQlpZiAoIXdkZXYtPnZpZltpXSkgeworCQkJ
d2Rldi0+dmlmW2ldID0gdmlmOworCQkJd3ZpZi0+aWQgPSBpOworCQkJYnJlYWs7CisJCX0KKwl9
CisJV0FSTihpID09IEFSUkFZX1NJWkUod2Rldi0+dmlmKSwgInRyeSB0byBpbnN0YW50aWF0ZSBt
b3JlIHZpZiB0aGFuIHN1cHBvcnRlZCIpOworCisJaGlmX3NldF9tYWNhZGRyKHd2aWYsIHZpZi0+
YWRkcik7CisKKwltdXRleF91bmxvY2soJndkZXYtPmNvbmZfbXV0ZXgpOworCiAJd3ZpZiA9IE5V
TEw7CiAJd2hpbGUgKCh3dmlmID0gd3ZpZl9pdGVyYXRlKHdkZXYsIHd2aWYpKSAhPSBOVUxMKSB7
CiAJCS8vIENvbWJvIG1vZGUgZG9lcyBub3Qgc3VwcG9ydCBCbG9jayBBY2tzLiBXZSBjYW4gcmUt
ZW5hYmxlIHRoZW0KQEAgLTgyMyw2ICs4MjIsNyBAQCB2b2lkIHdmeF9yZW1vdmVfaW50ZXJmYWNl
KHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LCBzdHJ1Y3QgaWVlZTgwMjExX3ZpZiAqdmlmKQogCXd2
aWYtPnZpZiA9IE5VTEw7CiAKIAltdXRleF91bmxvY2soJndkZXYtPmNvbmZfbXV0ZXgpOworCiAJ
d3ZpZiA9IE5VTEw7CiAJd2hpbGUgKCh3dmlmID0gd3ZpZl9pdGVyYXRlKHdkZXYsIHd2aWYpKSAh
PSBOVUxMKSB7CiAJCS8vIENvbWJvIG1vZGUgZG9lcyBub3Qgc3VwcG9ydCBCbG9jayBBY2tzLiBX
ZSBjYW4gcmUtZW5hYmxlIHRoZW0KLS0gCjIuMjguMAoK
