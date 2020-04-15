Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55BCF1AAD88
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 18:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1415434AbgDOQOo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 12:14:44 -0400
Received: from mail-eopbgr700077.outbound.protection.outlook.com ([40.107.70.77]:38433
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2410247AbgDOQMo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Apr 2020 12:12:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aw89wFnFiXyOy1NTj6jt5YzNU+gCB4eia3BTPbQ0i/2EQFNkq4H8cQvtwVoTa9t557hrFly+mD6G57GCJpTc+bN3TihWh3dVtxLQsdo5/w2x/kHFDM2/7LGm22nHIHTzK8ZpOumR1BoJqmWIGQwfH1gja5BQsY5VFk1s6SuA+snLjARBttl4in7WeYx8H71Ej5FFHXQz4dLQ9z7/S2cXqQVH+Gsrb/vaWGjdjUEehEKIwHsz47EPNwbbrNwqH3+PJ053TJuGvmi7S5o3x8+8w+U+x9ugTv5AAlojtuGXV4r8t3uHA3yx3bHnCJUBdLYmHlFXZGa8HzRj6mXho+B8/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JXSkXJdfqePl8P54mePNIrqH+SgdP2ay3f4f2zGGER4=;
 b=dNnDeljbJeSdPSX9FO7yPaXUwiY537POpyzVQNg0Y/AcN5dtFJVBRPU+nhvq49F1xhpKo5UJHcYUyriXyFgfqteTbBqjvTtrKwNi1pifogrVOs57HJCEoo45/sW5BzZG8ZJ1/mQNyyogfLnQHKIk6SZE8bH8LcmtHNynLoLOI/OyZOXRgnLx1dnJo7mjd60KcbZlgc51xp6UVMXnoVeKsdzWoHEGQgt+OkbTFfHuCPGguhv+FZz6y5NU8+ci/3KtfIuXMSkp1idU/MxqWEC3bwU+J06eekOqBylVBHwVre3yZdZy1KZ/ON5Sf2SnjTEY/f343WT4+nQcZQxatltQ1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JXSkXJdfqePl8P54mePNIrqH+SgdP2ay3f4f2zGGER4=;
 b=JZSI3B4bVPLdVy2L86wpoI+JMtvtR0d9eFhJFnoZiyRn0BRhEZIjegImUFWw79zxliLPrm8H9xkgMnhzfNI0cHKfIpF82uVkaclZ6WwJ0sJYl8fZqAy/vGsyD5anLflmlpqnF1BtMAGE9l26fsQ68MHOBG8nZ0jOpfroRLGfmaU=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1408.namprd11.prod.outlook.com (2603:10b6:300:24::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.25; Wed, 15 Apr
 2020 16:12:32 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe%10]) with mapi id 15.20.2921.024; Wed, 15 Apr
 2020 16:12:32 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 08/20] staging: wfx: do not use built-in AUTO_ERP feature
Date:   Wed, 15 Apr 2020 18:11:35 +0200
Message-Id: <20200415161147.69738-9-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200415161147.69738-1-Jerome.Pouiller@silabs.com>
References: <20200415161147.69738-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR1PR01CA0027.eurprd01.prod.exchangelabs.com
 (2603:10a6:102::40) To MWHPR11MB1775.namprd11.prod.outlook.com
 (2603:10b6:300:10e::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.home (2a01:e35:2435:66a0:544b:f17b:7ae8:fb7) by PR1PR01CA0027.eurprd01.prod.exchangelabs.com (2603:10a6:102::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.25 via Frontend Transport; Wed, 15 Apr 2020 16:12:30 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [2a01:e35:2435:66a0:544b:f17b:7ae8:fb7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4c617be1-2dc5-48f5-0932-08d7e157cda5
X-MS-TrafficTypeDiagnostic: MWHPR11MB1408:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB140825B5E2884040ED7F290193DB0@MWHPR11MB1408.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 0374433C81
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(136003)(396003)(376002)(346002)(39850400004)(366004)(8886007)(8936002)(5660300002)(2906002)(86362001)(8676002)(478600001)(81156014)(66574012)(1076003)(4326008)(52116002)(316002)(54906003)(107886003)(186003)(16526019)(66556008)(66476007)(36756003)(2616005)(6512007)(6486002)(6506007)(66946007);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5Sr7LbRYOVPIULkgTdBv7PPqL+HT9eyOZ03P0Bdqd0LwnI0NpkVe1BuFENrgCivzcdTFuwtnRk8zAhIJGHCjW/PnON2TEHX7OwRMjSLoa4fMYwmYTpSJJ0LWHfQjaIpFG4fP9BC+Xi7IDw7keW5+pqHYMnPiWfbNWq8RnpGC1Gvz4q36g0xGyoXm6iIgRWWclzU44DOvvuhf10cLkshmvJANd6qCghOsZtjM2mqv7cJByTtwxWsB23QJuoDxIL13Q9Wb1jxV/3FI9hAyDzN9SfBbCO0IAnYCrcw5D6/U7ZxIC/4zPyuy2c2HAPnNx9azT5xUBvJDYiPi3j9wX/XdHFAhx2nEXvpcSqRChVnUJQsoeo79MTFFwIhtBxkInGzNCcARSA52elTOtGWQGvSHXcVSV927qTPxSsCphD7wBSCiiUBquj4+cBN3VbKXvB/d
X-MS-Exchange-AntiSpam-MessageData: NKo+Jo58MEvUvJcCeI9YtH/V9C3ZbeVmILLFz7IatnV/51eMNVy4/1Qur67KLEsWdAnI/GKhr84VR5Qg7uSAI0E7Op/+WCaMOwQR70fu1HJSRwN7zNP6wLRQyaiDPpBKFGSnbhcd29tVZhgMwCyiQx3v6jE4wL6G0kDrVd8ES1vSd6Au4uv+mf4BogmsGlL89aBGhqUGRuNVbIv9wZM2ig==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c617be1-2dc5-48f5-0932-08d7e157cda5
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2020 16:12:32.6693
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A3DVQMQ1DLeYTQAIAg+/wIQCaA0L7XvHQNcDnQ3HknUDColZ95+Iu3J5cwcry1xnhikYstW5uVfu83/6q+orKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1408
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKRmly
bXdhcmUgaXMgYWJsZSB0byBkZXRlY3QgZGV0ZWN0IGNoYW5nZXMgYWJvdXQgRVJQIHByb3RlY3Rp
b24gaW4KYmVhY29ucyBhbmQgYXV0b21hdGljYWxseSBlbmFibGUvZGlzYWJsZSBFUlAgcHJvdGVj
dGlvbi4gSG93ZXZlciwgaXQgbm90CmJyaW5nIHBlcmZvcm1hbmNlIGltcHJvdmVtZW50cyBhbmQg
d2UgYXJlIG1vcmUgY29uZmlkZW50IGluIHRoZSBFUlAKaGFuZGxpbmcgb2YgbWFjODAyMTEuIFNv
LCB0aGUgcGF0Y2ggZGlzYWJsZSB0aGlzIGZlYXR1cmUuCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7Rt
ZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFn
aW5nL3dmeC9zdGEuYyB8IDQgLS0tLQogMSBmaWxlIGNoYW5nZWQsIDQgZGVsZXRpb25zKC0pCgpk
aWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYyBiL2RyaXZlcnMvc3RhZ2luZy93
Zngvc3RhLmMKaW5kZXggN2M4ZWJkNzYxMTRlLi4wYjJlZjJkMzAyM2IgMTAwNjQ0Ci0tLSBhL2Ry
aXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwpA
QCAtMTQ3LDEwICsxNDcsNiBAQCB2b2lkIHdmeF91cGRhdGVfZmlsdGVyaW5nKHN0cnVjdCB3Znhf
dmlmICp3dmlmKQogCWlmICh3dmlmLT5kaXNhYmxlX2JlYWNvbl9maWx0ZXIpIHsKIAkJaGlmX3Nl
dF9iZWFjb25fZmlsdGVyX3RhYmxlKHd2aWYsIDAsIE5VTEwpOwogCQloaWZfYmVhY29uX2ZpbHRl
cl9jb250cm9sKHd2aWYsIDAsIDEpOwotCX0gZWxzZSBpZiAod3ZpZi0+dmlmLT50eXBlICE9IE5M
ODAyMTFfSUZUWVBFX1NUQVRJT04pIHsKLQkJaGlmX3NldF9iZWFjb25fZmlsdGVyX3RhYmxlKHd2
aWYsIDIsIGZpbHRlcl9pZXMpOwotCQloaWZfYmVhY29uX2ZpbHRlcl9jb250cm9sKHd2aWYsIEhJ
Rl9CRUFDT05fRklMVEVSX0VOQUJMRSB8Ci0JCQkJCQlISUZfQkVBQ09OX0ZJTFRFUl9BVVRPX0VS
UCwgMCk7CiAJfSBlbHNlIHsKIAkJaGlmX3NldF9iZWFjb25fZmlsdGVyX3RhYmxlKHd2aWYsIDMs
IGZpbHRlcl9pZXMpOwogCQloaWZfYmVhY29uX2ZpbHRlcl9jb250cm9sKHd2aWYsIEhJRl9CRUFD
T05fRklMVEVSX0VOQUJMRSwgMCk7Ci0tIAoyLjI1LjEKCg==
