Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DEDE1CF888
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 17:08:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730711AbgELPFI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 11:05:08 -0400
Received: from mail-eopbgr770072.outbound.protection.outlook.com ([40.107.77.72]:30085
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730725AbgELPFG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 May 2020 11:05:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uh48uiQrLbQZ1Fzr8J4YPUoyiEPdS8ZpSbdmYmLiF8rqdp8EUs8Lw2O3ZQjT9C1HHgL7O2EGmlq8V7ntbOLYyHjc9/Puzu/KitJ70g2Q/hj6UBsqDZUfslczLspYAHoY+NUTtaqcqErUXeIHUQ0QWC6g4zI2dmTBb2Nh+26lMUBe0OE3z1aFb/qqiCgufcbTfhU1kUc2X+lAtnfA/QSr1SRufZioi5C6VMK2YLZDYydfUwKVGOKyVhuDK/PdQMLRxogoPCK6f0XdRzw/RobuwIc4tvn+mkKzr78DULwN3A7hHeQNNHCpORkTx0wonWyo5ueBCTu0FaVkUhxNS9k5jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JQUEM5ca7coakQv72bsNt+k61HBZZbFyi6u61Mxubf8=;
 b=OgPCU+I2uUL8q+EcnZFGnxhrdcqVJUaDfowLVV0SLgjNacYGpyogwcDJBTWRZPySDrWxaQBG3sJrAiFZDKBH5OcPFuS2f/caRM/tg9H0ZwJdL2AhgFHVGqAn24WupXOpPPVmZn9ieEoTgQPtVjZFJunz0OdWL1wXKN2+4kBUV533Bg1mn1p65mM5RLud/oGPDB6uklUF4h1FX3nlgrMiCHnyuRcKyCE5b/iJVlAGcpuISWO+jXeCSNUkjInfkbM1wGAXstCaBSZHjZ62Rva3iPep8h+O//g/wn8qiegHG16xRg9A+fRExNbHNsOmlasJrZRdVnP+ln8GEp7+fc7pSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JQUEM5ca7coakQv72bsNt+k61HBZZbFyi6u61Mxubf8=;
 b=INYK03WZcAy0/bM4cwu3LY6dtMQ+Pw97UY6bEDhGauoXzadCE1cMJ0fLcgTeHpOE/0DS9+zDLmOMW6wHlxXmFu4NOQdvpWXUC+aHKcTu0mMQ4QiiBjJMbBC+jxuFdOQAtVK4ehdz8zodXdNZ5Py0/vPnqrMB8bkjiUJ1W0dSPXk=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1741.namprd11.prod.outlook.com (2603:10b6:300:10d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.34; Tue, 12 May
 2020 15:04:54 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da%5]) with mapi id 15.20.2979.033; Tue, 12 May 2020
 15:04:53 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v2 12/17] staging: wfx: fix endianness of the struct hif_ind_startup
Date:   Tue, 12 May 2020 17:04:09 +0200
Message-Id: <20200512150414.267198-13-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200512150414.267198-1-Jerome.Pouiller@silabs.com>
References: <20200512150414.267198-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: DM5PR1101CA0003.namprd11.prod.outlook.com
 (2603:10b6:4:4c::13) To MWHPR11MB1775.namprd11.prod.outlook.com
 (2603:10b6:300:10e::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (82.67.86.106) by DM5PR1101CA0003.namprd11.prod.outlook.com (2603:10b6:4:4c::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20 via Frontend Transport; Tue, 12 May 2020 15:04:52 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [82.67.86.106]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: edef80a4-18ea-4bb9-081d-08d7f685d383
X-MS-TrafficTypeDiagnostic: MWHPR11MB1741:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB174119EDE40DF298013757C093BE0@MWHPR11MB1741.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:248;
X-Forefront-PRVS: 0401647B7F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9eydh+TMdDIk4hfoUZvbZ+hM+2X7BxRvBsxF6jCSY5+OsD8gVfg+o3+42XfS32SyyQ6fd1Xq8oy1XNre6BRs4R7nGWrYE1TpqSpxQydaNRFS9sYG3T1442pRTJMvYYhytm9OpOsOL6+OGOrtX1qYUD9ChzCqTo1krdj+3dep/sl+oZ2kuX+Sk5prp7jwpn2AkIjzYDK1SE3zKRqBuLA4vyTiFTrM5uxMPdme4JCC+VpKKUEdCto8wb6/3mGh3TF5wC6aW5B8EzX2JsssLkoCmDXwQELhoAekytesfgSGwbrnVV2wC1EANu54mahTbihkd9AoDvBadHNMngvOtwhA4O+vECozWzxhwg/3hBEnYia2zjiQYMIArCoGQ8GRqlBpAFD7YWr252yv4a7vyDeIbPiHBkHiEd0uEnr+sDtvFFYCAQ+5ZTn3kWavYN7rTzKTDNeaPEGrnPwJMKDSvFN+rOPNKwikjtDUtlgULu3FdzTC2plHlFatLxxvxuUHu1N+Pg6Lez3J4ASlhsRj+hEEJQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(366004)(376002)(39860400002)(346002)(136003)(33430700001)(54906003)(107886003)(478600001)(8676002)(5660300002)(316002)(1076003)(956004)(8936002)(2616005)(186003)(2906002)(7696005)(86362001)(4326008)(52116002)(6666004)(6486002)(66476007)(66574014)(26005)(66946007)(66556008)(33440700001)(16526019)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: hB3EAaOvqNDraKH1AeGN6pJwba3Hlk5EvGt9fNrtBh9xNIrXlupDyuVrsQW126slTqFC/kpiX3vzZJ1txhVDGHJE3fhJqxtCSNaxAYShjyPOAvnDIARgSxREtCgl1GpmkMG/2GWa5DE+lD1RrYa4y7knBdB4ijReS9BCN3+D3qjywzzsxSsDBVBlwykQPlE+n4PWoHC6MbNyeWRgMA0DiU/xj4q3V4iNb7v5FifOkcPOyWj5c+i+OzfeKCM1KmsjU3g1zN3bx8v5zXOzrzT0eyT3E8IHvjR18KsRx2LkFxaZvMjASSJW2qMGEPvULMkVQc/Z6hH5D9RxxwaqJhHU98TktUVAKkgqjcFLO5K+fs2bCRcZBGl6qxXibYtWYCmtK5oNT1A46KlRPkwd7nZRtMKOvZZTDIHVjQtLdgdPMgC4E+elGpFIr/pEyqc/Qmo+8GeV9d+6fG5lj975453xyC6Bu6a2VwI2PhBQdWeg0MU=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: edef80a4-18ea-4bb9-081d-08d7f685d383
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2020 15:04:53.8066
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Mz5ey4WyEtTSpxQbmGeh370mE8CjwNKfvyvwwImNB6oDmR3GpN4LA0I/v+gh4pSyOhNWuTexag+ePr/Z4a2Acw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1741
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IHN0cnVjdCBoaWZfaW5kX3N0YXJ0dXAgaXMgcmVjZWl2ZWQgZnJvbSB0aGUgaGFyZHdhcmUuIFNv
IGl0IGlzCmRlY2xhcmVkIGFzIGxpdHRsZSBlbmRpYW4uIEhvd2V2ZXIsIGl0IGlzIGFsc28gc3Rv
cmVkIGluIHRoZSBtYWluIGRyaXZlcgpzdHJ1Y3R1cmUgYW5kIHVzZWQgb24gZGlmZmVyZW50IHBs
YWNlcyBpbiB0aGUgZHJpdmVyLiBTcGFyc2UgY29tcGxhaW5zCmFib3V0IHRoYXQ6CgogICAgZHJp
dmVycy9zdGFnaW5nL3dmeC9kYXRhX3R4LmM6Mzg4OjQzOiB3YXJuaW5nOiByZXN0cmljdGVkIF9f
bGUxNiBkZWdyYWRlcyB0byBpbnRlZ2VyCiAgICBkcml2ZXJzL3N0YWdpbmcvd2Z4L2JoLmM6MTk5
Ojk6IHdhcm5pbmc6IHJlc3RyaWN0ZWQgX19sZTE2IGRlZ3JhZGVzIHRvIGludGVnZXIKICAgIGRy
aXZlcnMvc3RhZ2luZy93ZngvYmguYzoyMjE6NjI6IHdhcm5pbmc6IHJlc3RyaWN0ZWQgX19sZTE2
IGRlZ3JhZGVzIHRvIGludGVnZXIKCkluIG9yZGVyIHRvIG1ha2UgU3BhcnNlIGhhcHB5IGFuZCB0
byBrZWVwIGFjY2VzcyBmcm9tIHRoZSBkcml2ZXIgZWFzeSwKdGhpcyBwYXRjaCBkZWNsYXJlIGhp
Zl9pbmRfc3RhcnR1cCB3aXRoIG5hdGl2ZSBlbmRpYW5uZXNzLgoKT24gcmVjZXB0aW9uIG9mIHRo
aXMgc3RydWN0LCB0aGlzIHBhdGNoIHRha2VzIGNhcmUgdG8gZG8gYnl0ZS1zd2FwIGFuZAprZWVw
IFNwYXJzZSBoYXBweS4KClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUu
cG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9hcGlfZ2Vu
ZXJhbC5oIHwgMTEgKysrKysrKy0tLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3J4LmMgICAg
ICAgICAgfCAgOCArKysrLS0tLQogMiBmaWxlcyBjaGFuZ2VkLCAxMSBpbnNlcnRpb25zKCspLCA4
IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX2FwaV9n
ZW5lcmFsLmggYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9hcGlfZ2VuZXJhbC5oCmluZGV4IGYw
MTM1ZDI3MTIwYy4uOTk1NzUyYjlmMTY4IDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4
L2hpZl9hcGlfZ2VuZXJhbC5oCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX2FwaV9nZW5l
cmFsLmgKQEAgLTEzNiwxMiArMTM2LDE1IEBAIHN0cnVjdCBoaWZfb3RwX3BoeV9pbmZvIHsKIH0g
X19wYWNrZWQ7CiAKIHN0cnVjdCBoaWZfaW5kX3N0YXJ0dXAgeworCS8vIEFzIHRoZSBvdGhlcnMs
IHRoaXMgc3RydWN0IGlzIGludGVycHJldGVkIGFzIGxpdHRsZSBlbmRpYW4gYnkgdGhlCisJLy8g
ZGV2aWNlLiBIb3dldmVyLCB0aGlzIHN0cnVjdCBpcyBhbHNvIHVzZWQgYnkgdGhlIGRyaXZlci4g
V2UgcHJlZmVyIHRvCisJLy8gZGVjbGFyZSBpdCBpbiBuYXRpdmUgb3JkZXIgYW5kIGRvaW5nIGJ5
dGUgc3dhcCBvbiByZWNlcHRpb24uCiAJX19sZTMyIHN0YXR1czsKLQlfX2xlMTYgaGFyZHdhcmVf
aWQ7CisJdTE2ICAgIGhhcmR3YXJlX2lkOwogCXU4ICAgICBvcG5bMTRdOwogCXU4ICAgICB1aWRb
OF07Ci0JX19sZTE2IG51bV9pbnBfY2hfYnVmczsKLQlfX2xlMTYgc2l6ZV9pbnBfY2hfYnVmOwor
CXUxNiAgICBudW1faW5wX2NoX2J1ZnM7CisJdTE2ICAgIHNpemVfaW5wX2NoX2J1ZjsKIAl1OCAg
ICAgbnVtX2xpbmtzX2FwOwogCXU4ICAgICBudW1faW50ZXJmYWNlczsKIAl1OCAgICAgbWFjX2Fk
ZHJbMl1bRVRIX0FMRU5dOwpAQCAtMTU1LDcgKzE1OCw3IEBAIHN0cnVjdCBoaWZfaW5kX3N0YXJ0
dXAgewogCXU4ICAgICBkaXNhYmxlZF9jaGFubmVsX2xpc3RbMl07CiAJc3RydWN0IGhpZl9vdHBf
cmVndWxfc2VsX21vZGVfaW5mbyByZWd1bF9zZWxfbW9kZV9pbmZvOwogCXN0cnVjdCBoaWZfb3Rw
X3BoeV9pbmZvIG90cF9waHlfaW5mbzsKLQlfX2xlMzIgc3VwcG9ydGVkX3JhdGVfbWFzazsKKwl1
MzIgICAgc3VwcG9ydGVkX3JhdGVfbWFzazsKIAl1OCAgICAgZmlybXdhcmVfbGFiZWxbMTI4XTsK
IH0gX19wYWNrZWQ7CiAKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3J4LmMg
Yi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9yeC5jCmluZGV4IGZjYTlkZjYyMGFkOS4uOWI0ZjBj
NGJhNzQ1IDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9yeC5jCisrKyBiL2Ry
aXZlcnMvc3RhZ2luZy93ZngvaGlmX3J4LmMKQEAgLTEwMCwxMCArMTAwLDEwIEBAIHN0YXRpYyBp
bnQgaGlmX3N0YXJ0dXBfaW5kaWNhdGlvbihzdHJ1Y3Qgd2Z4X2RldiAqd2RldiwKIAkJcmV0dXJu
IC1FSU5WQUw7CiAJfQogCW1lbWNweSgmd2Rldi0+aHdfY2FwcywgYm9keSwgc2l6ZW9mKHN0cnVj
dCBoaWZfaW5kX3N0YXJ0dXApKTsKLQlsZTMyX3RvX2NwdXMoJndkZXYtPmh3X2NhcHMuc3RhdHVz
KTsKLQlsZTE2X3RvX2NwdXMoJndkZXYtPmh3X2NhcHMuaGFyZHdhcmVfaWQpOwotCWxlMTZfdG9f
Y3B1cygmd2Rldi0+aHdfY2Fwcy5udW1faW5wX2NoX2J1ZnMpOwotCWxlMTZfdG9fY3B1cygmd2Rl
di0+aHdfY2Fwcy5zaXplX2lucF9jaF9idWYpOworCWxlMTZfdG9fY3B1cygoX19sZTE2ICopJndk
ZXYtPmh3X2NhcHMuaGFyZHdhcmVfaWQpOworCWxlMTZfdG9fY3B1cygoX19sZTE2ICopJndkZXYt
Pmh3X2NhcHMubnVtX2lucF9jaF9idWZzKTsKKwlsZTE2X3RvX2NwdXMoKF9fbGUxNiAqKSZ3ZGV2
LT5od19jYXBzLnNpemVfaW5wX2NoX2J1Zik7CisJbGUzMl90b19jcHVzKChfX2xlMzIgKikmd2Rl
di0+aHdfY2Fwcy5zdXBwb3J0ZWRfcmF0ZV9tYXNrKTsKIAogCWNvbXBsZXRlKCZ3ZGV2LT5maXJt
d2FyZV9yZWFkeSk7CiAJcmV0dXJuIDA7Ci0tIAoyLjI2LjIKCg==
