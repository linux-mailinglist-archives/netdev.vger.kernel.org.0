Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52A771BA500
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 15:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728147AbgD0Nlh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 09:41:37 -0400
Received: from mail-mw2nam12on2085.outbound.protection.outlook.com ([40.107.244.85]:27104
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728128AbgD0Nlf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 09:41:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IhiQsi7VNFXJ+qFx0XgmKZSdwgl5ZSzSgnCi1wWx1QeNkDTO+M+CCWp/wusKIfvHhmNnqmkgAJqMWt1rnb+9Oam21a6qv6NT/C6nGG2lLDTtFy5aD6RIKIJJZkRfMz80UkC5ACysyth0zsuJDE6m/xQguOH15C5NV3QlkBluZ0ZhlEHhdsI499eU5Pg80CAx7qw2CKwXvfrUJ8WVTY0qP9syxwItTufKSdvzin5gsyJmv9e5FZZqzNjxp1cGAr5vycM7Ofejg0eDiMN/3pNNVxx9y3NucGCQW9cL9gb0gOE73N9F34WGCh251bZZqcVHK74rdzMAFpnewEGd48tQ2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=egCdpDIyXQUcXWET33IMa8Zq84wxdpYxLexcnAsxUfc=;
 b=ErZpfVkDMpiK/H/E5bMXAoTwiYw0pUi16riP3C7RgCzOHYbKr3YOBsLDFfUZp2VqsQSIQ28J2yjhLDUKw85grzTx7NEp5gnIw5xyqzIUO+C//saGICGQ6QqbsroFCjYoirBFqP0sy320dGDrG3njSKw01jNIdwt9zfIYDM8P7vis7ME5EOyJj2GNLuIorQj49FJZEEhA3jN1CUSojKi045mh9dDW/xGfTyCLn/zbKlMHn0q/Gy9lGuxMP8i5+koZsnIOSCqWWSg6cajH/te0oMFYLkV40TLrC2A0dgvNhT2e3YMzWomOd7nWgLirVCFchF+P7E/WNPwKDsKtxIrdJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=egCdpDIyXQUcXWET33IMa8Zq84wxdpYxLexcnAsxUfc=;
 b=hlQL+Dk36+Fpyf2ITZ1sB99Ho8xFc14WFhr5ZeBnOw33xqXUaUknp2Uc4eE4vl7NV7iE/i0XJ/4hJU81LX0IqGeHjH9uTsONhEDVIdOg2+P1QaQ49uHet6Etx/3nVd6lNTWvUsTMAD5ngdjETnEjbKxF3jIxqgUUEuMXL8vkHto=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1424.namprd11.prod.outlook.com (2603:10b6:300:26::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Mon, 27 Apr
 2020 13:41:31 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe%10]) with mapi id 15.20.2937.023; Mon, 27 Apr
 2020 13:41:31 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 12/17] staging: wfx: show counters of all interfaces
Date:   Mon, 27 Apr 2020 15:40:26 +0200
Message-Id: <20200427134031.323403-13-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200427134031.323403-1-Jerome.Pouiller@silabs.com>
References: <20200427134031.323403-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR0P264CA0232.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1e::28) To MWHPR11MB1775.namprd11.prod.outlook.com
 (2603:10b6:300:10e::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.home (2a01:e35:2435:66a0:544b:f17b:7ae8:fb7) by PR0P264CA0232.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1e::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Mon, 27 Apr 2020 13:41:28 +0000
X-Mailer: git-send-email 2.26.1
X-Originating-IP: [2a01:e35:2435:66a0:544b:f17b:7ae8:fb7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0fb43a34-fd5d-49ea-8b56-08d7eab0b181
X-MS-TrafficTypeDiagnostic: MWHPR11MB1424:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB142488EEBA53FC0FE093EB7793AF0@MWHPR11MB1424.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 0386B406AA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(39850400004)(376002)(346002)(396003)(366004)(8886007)(66476007)(66556008)(4326008)(81156014)(86362001)(8936002)(6486002)(52116002)(6506007)(5660300002)(16526019)(6512007)(1076003)(478600001)(8676002)(36756003)(186003)(2616005)(54906003)(107886003)(66574012)(2906002)(316002)(66946007);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kA7oOVJE6AEvAosobbht3i2EzKpqDC35Wh3Z9qJThFEeQpCRBb2cJElMsMR9MlM9WPkujh8l7bZrEEs/JwWt4wd9NqerwN4hJV8KY4KySstm+5heLFCxnUOM7NAQQci/wsuUJZHiHjhaXegvarjT0zVi11UX4QPYpaarpxdhhY1ipgXTgBCHdz2shGEO7MkB4XDdUb6mRSl9/CiqTHI7lUpF7axCl8w0aTy4jXqvBpmDfdax3BtiRkWJzGozOHqhiqogKpcf869WiixOrw8rd+WhmDiHA7tB6PHzHWU13FnfnUoaVAXRaVaDzkH0W8LB+AVGfuo2l5TYVDzvvz96wGYCzSSZh0/gb7VRF5bF+FzshYSJ69+OD/efSmMfRbVnQ4T/t6oGw2JBQjc1qa0yCR/a+6HHM5UiDclrRYD/iWnJ5U0nc2hZ8G0biEnLEIE0
X-MS-Exchange-AntiSpam-MessageData: +eKH2md+QPmroqBnEeLIhoXcTDFm6Go9kNUixGRJRkQ9kSApTEAXtu3puJZPapi2OpIeAvvxJvCXwdvnu87cul16mDl1slzszjKyyCd1uokcrAbSZAWzZhowrmPMNcRE+QwE0zCzFlmnQkmuEsMaEOG+99JWQcJOColz9vtxpZ6hl8HCyMa7qKqPYSeUMbrCsoReJLOhXPG6IJhdtyKqaYqsNG5xGX6VZakAbWzD0pR9U4SRR4afyDgcQRUCzhVCHU/cBBt2Iklduhkt7TzefemKaZlmW/S+s2GzW/DqFHxX379aL+murJuyqQTXu9Pv9KianEEil8aNMy1vTmHJZ/PO6G9rteN9QZH2Rxi9hPtrjBJmv8xKdKElTUHC8HEuTDr+JCZDtNEBh3RIYgaLgnHzCuDr7FtFHKSdMvCejWx73AO7Vr47ZZ+8YRdt3AVvxjJ1H7sFCkxF+Ka2HQsOw4/kk3xNaEEgzmNvYu9DAfGaXM8u6XVwcXF4M6xObDJHA9ijaNL8bWNgqroDvCU1R90PRaITeSVaudrs1RtYHGW7VD69sIKJfy0zl1unG8vJ0gKKZkrDaY3eJWuzozasc/MjevOjDXRd2//gVL9kpi3hDtxZt/4kmPbW/OGzZbVPXan/w3h2dN5zVKdf1vlYO4aUScEcIqYQkAq8dpkjERBCVF32EUSvmA86BjZl12fKgGS1wx9BAu+VJcPMpXSnVhQtGnXiWh6BMD2CTzf8a11bQfrS/IBo8eCeA/+uraKq6BX0SbjSPYzemzU/3aDbGjbCNRo7LRlOH/4nocdoDRFolGkigXxlDqzq7ZM1SvKaAXsPgf2Loqrb4jWtDAzXx6jdoWSwsgCJIHk7u8RYCA4=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fb43a34-fd5d-49ea-8b56-08d7eab0b181
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2020 13:41:31.1124
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ibBvm+OWguMJS5T1+aVLT3zIJvO77T68PJlWJpR5ShTt1RlYptqyJlF7dZ4sGocrZZ7uwuixnr3aEfje4R7Pxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1424
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IGRldmljZSBrZWVwIHVwIHRvIGRhdGUgdGhyZWUgc2VyaWVzIG9mIHN0YXRzLiBPbmUgZm9yIGVh
Y2gKdmlydHVhbCBpbnRlcmZhY2UgYW5kIG9uZSBmb3IgdGhlIHdob2xlIGRldmljZS4KClVudGls
IHRvIG5vdywgdGhlIHN0YXRzIGZvciB0aGUgd2hvbGUgZGV2aWNlIHdlcmUgdW5hdmFpbGFibGUu
IE1vcmVvdmVyLAppdCBpcyBpbnRlcmVzdGluZyB0byByZXRyaWV2ZSBjb3VudGVycyBmb3IgYWxs
IGludGVyZmFjZXMgZXZlbiBpZiB0aGV5CmFyZSBub3QgYXdha2UuCgpDaGFuZ2UgdGhlIGNvdW50
ZXJzIGF2YWlsYWJsZSBpbiBkZWJ1Z2ZzIGluIG9yZGVyIHRvIHJldHJpZXZlIHN0YXRzCmZyb20g
YWxsIGludGVyZmFjZXMuCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21l
LnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9kZWJ1Zy5jICAg
ICAgfCAyNSArKysrKysrKysrKysrKysrLS0tLS0tLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2hp
Zl90eF9taWIuYyB8ICA2ICsrKy0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHhfbWliLmgg
fCAgMiArLQogMyBmaWxlcyBjaGFuZ2VkLCAyMCBpbnNlcnRpb25zKCspLCAxMyBkZWxldGlvbnMo
LSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2RlYnVnLmMgYi9kcml2ZXJzL3N0
YWdpbmcvd2Z4L2RlYnVnLmMKaW5kZXggMTE2NGFiYTExOGExLi40ZGM0ZjZhMGI5MmIgMTAwNjQ0
Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvZGVidWcuYworKysgYi9kcml2ZXJzL3N0YWdpbmcv
d2Z4L2RlYnVnLmMKQEAgLTYxLDE5ICs2MSwyNiBAQCBjb25zdCBjaGFyICpnZXRfcmVnX25hbWUo
dW5zaWduZWQgbG9uZyBpZCkKIAogc3RhdGljIGludCB3ZnhfY291bnRlcnNfc2hvdyhzdHJ1Y3Qg
c2VxX2ZpbGUgKnNlcSwgdm9pZCAqdikKIHsKLQlpbnQgcmV0OworCWludCByZXQsIGk7CiAJc3Ry
dWN0IHdmeF9kZXYgKndkZXYgPSBzZXEtPnByaXZhdGU7Ci0Jc3RydWN0IGhpZl9taWJfZXh0ZW5k
ZWRfY291bnRfdGFibGUgY291bnRlcnM7CisJc3RydWN0IGhpZl9taWJfZXh0ZW5kZWRfY291bnRf
dGFibGUgY291bnRlcnNbM107CiAKLQlyZXQgPSBoaWZfZ2V0X2NvdW50ZXJzX3RhYmxlKHdkZXYs
ICZjb3VudGVycyk7Ci0JaWYgKHJldCA8IDApCi0JCXJldHVybiByZXQ7Ci0JaWYgKHJldCA+IDAp
Ci0JCXJldHVybiAtRUlPOworCWZvciAoaSA9IDA7IGkgPCBBUlJBWV9TSVpFKGNvdW50ZXJzKTsg
aSsrKSB7CisJCXJldCA9IGhpZl9nZXRfY291bnRlcnNfdGFibGUod2RldiwgaSwgY291bnRlcnMg
KyBpKTsKKwkJaWYgKHJldCA8IDApCisJCQlyZXR1cm4gcmV0OworCQlpZiAocmV0ID4gMCkKKwkJ
CXJldHVybiAtRUlPOworCX0KKworCXNlcV9wcmludGYoc2VxLCAiJS0yNHMgJTEycyAlMTJzICUx
MnNcbiIsCisJCSAgICIiLCAiZ2xvYmFsIiwgImlmYWNlIDAiLCAiaWZhY2UgMSIpOwogCiAjZGVm
aW5lIFBVVF9DT1VOVEVSKG5hbWUpIFwKLQlzZXFfcHJpbnRmKHNlcSwgIiUyNHMgJWRcbiIsICNu
YW1lICI6IixcCi0JCSAgIGxlMzJfdG9fY3B1KGNvdW50ZXJzLmNvdW50XyMjbmFtZSkpCisJc2Vx
X3ByaW50ZihzZXEsICIlLTI0cyAlMTJkICUxMmQgJTEyZFxuIiwgI25hbWUsIFwKKwkJICAgbGUz
Ml90b19jcHUoY291bnRlcnNbMl0uY291bnRfIyNuYW1lKSwgXAorCQkgICBsZTMyX3RvX2NwdShj
b3VudGVyc1swXS5jb3VudF8jI25hbWUpLCBcCisJCSAgIGxlMzJfdG9fY3B1KGNvdW50ZXJzWzFd
LmNvdW50XyMjbmFtZSkpCiAKIAlQVVRfQ09VTlRFUih0eF9wYWNrZXRzKTsKIAlQVVRfQ09VTlRF
Uih0eF9tdWx0aWNhc3RfZnJhbWVzKTsKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93Zngv
aGlmX3R4X21pYi5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHhfbWliLmMKaW5kZXggMTZm
NDkwODA1NWFmLi42ZmRkZTVhNGM5YTEgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93Zngv
aGlmX3R4X21pYi5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4X21pYi5jCkBAIC02
NCwxNiArNjQsMTYgQEAgaW50IGhpZl9zZXRfcmNwaV9yc3NpX3RocmVzaG9sZChzdHJ1Y3Qgd2Z4
X3ZpZiAqd3ZpZiwKIAkJCSAgICAgSElGX01JQl9JRF9SQ1BJX1JTU0lfVEhSRVNIT0xELCAmYXJn
LCBzaXplb2YoYXJnKSk7CiB9CiAKLWludCBoaWZfZ2V0X2NvdW50ZXJzX3RhYmxlKHN0cnVjdCB3
ZnhfZGV2ICp3ZGV2LAoraW50IGhpZl9nZXRfY291bnRlcnNfdGFibGUoc3RydWN0IHdmeF9kZXYg
KndkZXYsIGludCB2aWZfaWQsCiAJCQkgICBzdHJ1Y3QgaGlmX21pYl9leHRlbmRlZF9jb3VudF90
YWJsZSAqYXJnKQogewogCWlmICh3ZnhfYXBpX29sZGVyX3RoYW4od2RldiwgMSwgMykpIHsKIAkJ
Ly8gZXh0ZW5kZWRfY291bnRfdGFibGUgaXMgd2lkZXIgdGhhbiBjb3VudF90YWJsZQogCQltZW1z
ZXQoYXJnLCAweEZGLCBzaXplb2YoKmFyZykpOwotCQlyZXR1cm4gaGlmX3JlYWRfbWliKHdkZXYs
IDAsIEhJRl9NSUJfSURfQ09VTlRFUlNfVEFCTEUsCisJCXJldHVybiBoaWZfcmVhZF9taWIod2Rl
diwgdmlmX2lkLCBISUZfTUlCX0lEX0NPVU5URVJTX1RBQkxFLAogCQkJCSAgICBhcmcsIHNpemVv
ZihzdHJ1Y3QgaGlmX21pYl9jb3VudF90YWJsZSkpOwogCX0gZWxzZSB7Ci0JCXJldHVybiBoaWZf
cmVhZF9taWIod2RldiwgMCwKKwkJcmV0dXJuIGhpZl9yZWFkX21pYih3ZGV2LCB2aWZfaWQsCiAJ
CQkJICAgIEhJRl9NSUJfSURfRVhURU5ERURfQ09VTlRFUlNfVEFCTEUsIGFyZywKIAkJCQlzaXpl
b2Yoc3RydWN0IGhpZl9taWJfZXh0ZW5kZWRfY291bnRfdGFibGUpKTsKIAl9CmRpZmYgLS1naXQg
YS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eF9taWIuaCBiL2RyaXZlcnMvc3RhZ2luZy93Zngv
aGlmX3R4X21pYi5oCmluZGV4IGJiN2MxMDRhMDNkOC4uYjcyNzcwYTRiYTEyIDEwMDY0NAotLS0g
YS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eF9taWIuaAorKysgYi9kcml2ZXJzL3N0YWdpbmcv
d2Z4L2hpZl90eF9taWIuaApAQCAtMjAsNyArMjAsNyBAQCBpbnQgaGlmX3NldF9iZWFjb25fd2Fr
ZXVwX3BlcmlvZChzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwKIAkJCQkgdW5zaWduZWQgaW50IGxpc3Rl
bl9pbnRlcnZhbCk7CiBpbnQgaGlmX3NldF9yY3BpX3Jzc2lfdGhyZXNob2xkKHN0cnVjdCB3Znhf
dmlmICp3dmlmLAogCQkJCWludCByc3NpX3Rob2xkLCBpbnQgcnNzaV9oeXN0KTsKLWludCBoaWZf
Z2V0X2NvdW50ZXJzX3RhYmxlKHN0cnVjdCB3ZnhfZGV2ICp3ZGV2LAoraW50IGhpZl9nZXRfY291
bnRlcnNfdGFibGUoc3RydWN0IHdmeF9kZXYgKndkZXYsIGludCB2aWZfaWQsCiAJCQkgICBzdHJ1
Y3QgaGlmX21pYl9leHRlbmRlZF9jb3VudF90YWJsZSAqYXJnKTsKIGludCBoaWZfc2V0X21hY2Fk
ZHIoc3RydWN0IHdmeF92aWYgKnd2aWYsIHU4ICptYWMpOwogaW50IGhpZl9zZXRfcnhfZmlsdGVy
KHN0cnVjdCB3ZnhfdmlmICp3dmlmLAotLSAKMi4yNi4xCgo=
