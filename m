Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08A2E1C559E
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 14:38:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729071AbgEEMie (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 08:38:34 -0400
Received: from mail-eopbgr680041.outbound.protection.outlook.com ([40.107.68.41]:21169
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728905AbgEEMi2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 08:38:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fC06jR/QX7Zem+X+UwYAZGrY8ZvJ+vzArUjXKqK535hr+ZKOjItK4FazQyy47EvNNgn0vAdlxOczZcaKpoBDzqLqFjeFfmd5lGzUq7oVlJmTbJbek6uRa7hVZK775EqqNEJsKxKI5fldRWMKZE1anCvjK1wHB4tXXlYQS2pagWAGgy8k7OoGyy/ygcWIvLeIP+5xXrVmsN99AXpUVNh9xXuiSqHhTaMFPtbDkKOU98c6yVVeZnUBves0Ib6tc/acBB0HtQdeW9L35SpMMWzfxlrHUpiBibdO5MrurFC3utqAz6MuOZaLj15uKGQ7po9cUGIdfFYKTkfxluY3otn9zQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3oLHfgZ0s7fUNykbVNQ7tiAx/HbhMYX0szDllSwRzNw=;
 b=ZnBS4uggX88AiodcH6F0wVAG9TM9HnwWX64GlARE/3JUBxeRCHMNbBYXyj1eXGHB+/VOOq5Gg7l/Cg7kWwBfFwxNlXkHq1PXKHlcwHE80jk7NtIxuPKxsev4aR3T7Jos3lta+l6DgJZNjg0j0Q0hTHOvHBMKsfed61p+Jf2qQz5qCbSnY2tu93oG3dDlBtmR1frmjX725Q9xIs7/APZWC9mbBosr3L82DUFSCQcdyzYswZOlVjyTziInL9QQ+O867bk5otKaa3636cYx+ccuVCBaBbqokVxWYPLv0aPYvlTd3bHISXoV6EbzCufdxUn4G94AmOBIzUfbUsnUiQotlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3oLHfgZ0s7fUNykbVNQ7tiAx/HbhMYX0szDllSwRzNw=;
 b=VM/zsOlJ8zfSoPz4IsbL1zb0SxqeQPtSnHwyiXrustyySWsWL3QdC2rnvAI/vCVI+gKwIuGCdVeQEUflEKT4Uph/xBzi3UgNeclzsW0gr4RdzSowD9LdVeqOOURdIbyONSi0A7zETVAqdk9ONzSqL5xHrFyAOJAesj5QKrPPTIo=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1824.namprd11.prod.outlook.com (2603:10b6:300:110::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19; Tue, 5 May
 2020 12:38:20 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe%10]) with mapi id 15.20.2958.030; Tue, 5 May 2020
 12:38:20 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 04/15] staging: wfx: drop useless check
Date:   Tue,  5 May 2020 14:37:46 +0200
Message-Id: <20200505123757.39506-5-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200505123757.39506-1-Jerome.Pouiller@silabs.com>
References: <20200505123757.39506-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR3P189CA0022.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:102:52::27) To MWHPR11MB1775.namprd11.prod.outlook.com
 (2603:10b6:300:10e::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.home (2a01:e35:2435:66a0:1265:30ff:fefd:6e7f) by PR3P189CA0022.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:52::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Tue, 5 May 2020 12:38:18 +0000
X-Mailer: git-send-email 2.26.1
X-Originating-IP: [2a01:e35:2435:66a0:1265:30ff:fefd:6e7f]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2827726e-73c7-40ec-ef42-08d7f0f1314f
X-MS-TrafficTypeDiagnostic: MWHPR11MB1824:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB18248A2B237ABF2D83F8EAB793A70@MWHPR11MB1824.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:962;
X-Forefront-PRVS: 0394259C80
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YlNl7lGXiBzlPHj/BEFZhFUT1J4i9gdteG3MpXMITbwQAvFM5lbgF9l6j9YorULLyGsuxZxWt0JKlFaBdR+sg3NT2yekD8ITCjdwPmFKPCXjQKsnp7T4boHEoVrvN5JE1/Z4biwzGcU6a9fwQ5oKdz0fJy++Mf9LKbNXmKsF8uAO02ditGUoZklj/9dW/ZsnQqw83APfWn2DKHPTRxosmCBQNiQT/lR2AxqbJj8AdGkYnhqDrVogWKG7+2USBBGDWZfCjpiMSBqbSZoVts8hEar2M/+J6/1ewEofpgh5HhIyZRlZZh2R8+U8Ylyv0L+GZbuiZKZ9SWgIpuPUB7ALeFKkIy9sIIWoSxqLIlE5oYBpNg7LnBTsh+ICjoa2FN1OCOfZeUwOsBtz2r0lSnNSSfT1fiZU3suPzre4NaQ38DFd8cFqw1KmV/bi/cfAoL5ikOJ3Eop2J7CRMSWD44VqHzU4HKgcY+W7mGmx75S2Uunw6lUMKZtuWo5XlYkXlmrR58tpHcnAJIFO+OvfQ6XTug==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(396003)(39850400004)(366004)(376002)(346002)(33430700001)(86362001)(6666004)(107886003)(8886007)(1076003)(6512007)(6486002)(66574012)(36756003)(5660300002)(2906002)(66476007)(6506007)(16526019)(186003)(52116002)(66946007)(66556008)(54906003)(2616005)(4326008)(8936002)(8676002)(316002)(33440700001)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: uE3Uq7n6j7evEqgvMoM5NNg8UNeNHSqCYPnJdVHW+6sicnn7okGrtBzAZqZr8qDXCsBNJBa6BbmiVve59pbDi3uGHqG+WhugaYN4AvM7ERj9C2DTagOgzgKdgWzl+k71U0KUEpIDVVY4JAqdenKL+XMZPUbd+3bQIsE709x2o3Vs1cC5midO9F7FXMPzEcSmxEkopg/d2A4MN+1abbW9i5V79xbPBwuHbfyZeusrSKuEAlPdA6LaCCZ1TS7P7lyGs4/MbGnYYfd9wgzruimZrwP7NdGP6b91tCgy/bABpKGrNf/cbIA41Jlzbzn5nu4XhBhWqzaO7VsUi3yyeZ77GL39qzoDYnv96USPl/mrDLhjTTja98ilC15kVrrI8akOmgBlQnALqOEZWWSytDB1MuUZYd1bCOoy4Mf/jOho16H+dlRNlHqqRAfMwSJKFRzQEh/CBsElk7/HSohTFlRGrFUXqvm8uF8t4vlkqdqAA/M36QDopHRK0TDpeYQY4d0c9JBuif3DrTtCLK+hu4691B4eY52rc8iMwosiIPZk8ISCLcTOlkrLF2z3SoriarTU2A7DbelIOxKtJdpUrrHu1oZbeX3Sqq3rwWEmBs60CCGf4UmdfxueXyOFEtfK9JK7lgl7wKB8J+rLsbt2H8Lxye7smAsa6wy2Fcy9OaQovGp9B1DRC9FiMbGRaoW4VyfijclkyIcLJ3AbyqAe6szjdlwiXQj6ATp/PVRSnPR4lrQqch0My+NndDMMxkTSrtNDb1ETB+Hiyt5o+gCFa+zg5Uq4ZySK/QzutyYQS8BsiRkMhtQS4aBlfkqdr/pf6raMchRz/uM+CZZNIyswBce6LqvFmI0EYpguRv38hG/6sBA=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2827726e-73c7-40ec-ef42-08d7f0f1314f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2020 12:38:20.4120
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0GhKMnM6kWzFVjOJXP6s0inonYtJVQLYTvYbytuovD/rYKbFxB8BodzqRVC3Okx1C5/2GLHO6xZroM0VSxWzZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1824
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKQ3Vy
cmVudGx5LCB0aGUgSVNSIGNoZWNrIGlmIGJ1cy0+Y29yZSBpcyBub3QgTlVMTC4gQnV0LCBpdCBp
cyBhIHVzZWxlc3MKY2hlY2suIGJ1cy0+Y29yZSBpcyBpbml0aWFsaWFzZWQgYmVmb3JlIHRvIHJl
cXVlc3QgSVJRIGFuZCBpdCBpcyBub3QKYXNzaWduZWQgdG8gTlVMTCB3aGVuIGl0IGlzIHJlbGVh
c2VkLgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBz
aWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvYnVzX3NkaW8uYyB8IDkgKy0tLS0t
LS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2J1c19zcGkuYyAgfCA0IC0tLS0KIDIgZmlsZXMgY2hh
bmdlZCwgMSBpbnNlcnRpb24oKyksIDEyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZl
cnMvc3RhZ2luZy93ZngvYnVzX3NkaW8uYyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvYnVzX3NkaW8u
YwppbmRleCBkZWRjM2ZmNThkM2UuLjlhYzg3MTc4MjcwZiAxMDA2NDQKLS0tIGEvZHJpdmVycy9z
dGFnaW5nL3dmeC9idXNfc2Rpby5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvYnVzX3NkaW8u
YwpAQCAtOTEsMjAgKzkxLDEzIEBAIHN0YXRpYyB2b2lkIHdmeF9zZGlvX2lycV9oYW5kbGVyKHN0
cnVjdCBzZGlvX2Z1bmMgKmZ1bmMpCiB7CiAJc3RydWN0IHdmeF9zZGlvX3ByaXYgKmJ1cyA9IHNk
aW9fZ2V0X2RydmRhdGEoZnVuYyk7CiAKLQlpZiAoYnVzLT5jb3JlKQotCQl3ZnhfYmhfcmVxdWVz
dF9yeChidXMtPmNvcmUpOwotCWVsc2UKLQkJV0FSTighYnVzLT5jb3JlLCAicmFjZSBjb25kaXRp
b24gaW4gZHJpdmVyIGluaXQvZGVpbml0Iik7CisJd2Z4X2JoX3JlcXVlc3RfcngoYnVzLT5jb3Jl
KTsKIH0KIAogc3RhdGljIGlycXJldHVybl90IHdmeF9zZGlvX2lycV9oYW5kbGVyX2V4dChpbnQg
aXJxLCB2b2lkICpwcml2KQogewogCXN0cnVjdCB3Znhfc2Rpb19wcml2ICpidXMgPSBwcml2Owog
Ci0JaWYgKCFidXMtPmNvcmUpIHsKLQkJV0FSTighYnVzLT5jb3JlLCAicmFjZSBjb25kaXRpb24g
aW4gZHJpdmVyIGluaXQvZGVpbml0Iik7Ci0JCXJldHVybiBJUlFfTk9ORTsKLQl9CiAJc2Rpb19j
bGFpbV9ob3N0KGJ1cy0+ZnVuYyk7CiAJd2Z4X2JoX3JlcXVlc3RfcngoYnVzLT5jb3JlKTsKIAlz
ZGlvX3JlbGVhc2VfaG9zdChidXMtPmZ1bmMpOwpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5n
L3dmeC9idXNfc3BpLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2J1c19zcGkuYwppbmRleCA2MWU5
OWIwOWRlY2IuLjAzZjk1ZTY1ZDJmOSAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9i
dXNfc3BpLmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9idXNfc3BpLmMKQEAgLTE0MCwxMCAr
MTQwLDYgQEAgc3RhdGljIGlycXJldHVybl90IHdmeF9zcGlfaXJxX2hhbmRsZXIoaW50IGlycSwg
dm9pZCAqcHJpdikKIHsKIAlzdHJ1Y3Qgd2Z4X3NwaV9wcml2ICpidXMgPSBwcml2OwogCi0JaWYg
KCFidXMtPmNvcmUpIHsKLQkJV0FSTighYnVzLT5jb3JlLCAicmFjZSBjb25kaXRpb24gaW4gZHJp
dmVyIGluaXQvZGVpbml0Iik7Ci0JCXJldHVybiBJUlFfTk9ORTsKLQl9CiAJcXVldWVfd29yayhz
eXN0ZW1faGlnaHByaV93cSwgJmJ1cy0+cmVxdWVzdF9yeCk7CiAJcmV0dXJuIElSUV9IQU5ETEVE
OwogfQotLSAKMi4yNi4xCgo=
