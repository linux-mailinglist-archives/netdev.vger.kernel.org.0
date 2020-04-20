Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 093CE1B1107
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 18:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729905AbgDTQEs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 12:04:48 -0400
Received: from mail-bn8nam11on2081.outbound.protection.outlook.com ([40.107.236.81]:58834
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729643AbgDTQEQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 12:04:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y7Hd0KyN06YMD8bt8yVekDxaQ/vEW8zXHmVRFG82Ug/Dz3RZnR6uIE7Zjj5FIFPeUOKVxfZtvv6NNObZINGIv+pI2E2otKz/CNEQHVSEnWJEt05PaNoBY5x92lgstiex2jTbmg14eXmQ5DFi+44jE+kFCCa2/B8uHFSbjZpspAulO3QAJIUgk+/+g9VQe2Q5qoLKl7JUHhCZklfEEbrdl1+ljMESgDx7srewifKx0/VAqZEfD01+94c81Vd9TcrijBR8rjIie+YumesS7cTvwyg2GvE0IjW5fF1Giy3DV4BX5D5AYVpO5sm7yO30msTz0u2dcW7xi17fTl6BVok4tQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kk/HpxK0GTj7b/iN2wwOyMcMXOJ8aVE8FEbqA47Wvxk=;
 b=FPmSd24cXPOFJ+wepHJDQv1Px8PubHSNFS5BltsJ0Y+S1o57NJEjKeLsrQ9kHAjycfOMiKcpghpXemaCSRxIbLRTgrxaAlsrFA59lPYlUH9HE26uqFhXmdSFLIcIpsyX6I3cdbAOqhwRoPNackWplPwIu1ZYguyTg6dQek5uyRmj0GUpwug8zjNuLaQhT4xtFLJFBTMdqd1rpCN1PgSv1LiaeJfvB6nWAma6CBOP0RRI63NV8lCcWfMTxgz9jecZHcaRuf6sL6/ZGVeSpVWSNeeab3tVHoF8G9PDO6N/3opH9SSQoLTk6gJNmUbe9WkFJMfFrJ02NTxc1WfgNZd81A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kk/HpxK0GTj7b/iN2wwOyMcMXOJ8aVE8FEbqA47Wvxk=;
 b=O66d837x5T8TAT6CWUzZu1y4D0MlUjyaJkLpIZxq+MB6pH029WP1sU55Kx+fk2dzhZW5uo8L/d9n6ThEf4e1xU28PS6vrJYAvnQNRdOXTSAE0OecoFjzBxjae3RnN+EuptTwR0b3vzAVwIEsHmdNjkgg++UUK6V0PK6mRdVHGb8=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1792.namprd11.prod.outlook.com (2603:10b6:300:10b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Mon, 20 Apr
 2020 16:03:55 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe%10]) with mapi id 15.20.2921.030; Mon, 20 Apr
 2020 16:03:55 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 12/16] staging: wfx: drop protection for asynchronous join during scan
Date:   Mon, 20 Apr 2020 18:03:07 +0200
Message-Id: <20200420160311.57323-13-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420160311.57323-1-Jerome.Pouiller@silabs.com>
References: <20200420160311.57323-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: DM6PR07CA0065.namprd07.prod.outlook.com
 (2603:10b6:5:74::42) To MWHPR11MB1775.namprd11.prod.outlook.com
 (2603:10b6:300:10e::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:544b:f17b:7ae8:fb7) by DM6PR07CA0065.namprd07.prod.outlook.com (2603:10b6:5:74::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.26 via Frontend Transport; Mon, 20 Apr 2020 16:03:53 +0000
X-Mailer: git-send-email 2.26.1
X-Originating-IP: [2a01:e35:2435:66a0:544b:f17b:7ae8:fb7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2a12be56-8fe5-41c6-c817-08d7e5446d08
X-MS-TrafficTypeDiagnostic: MWHPR11MB1792:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB17924CB8421471514FD5EADB93D40@MWHPR11MB1792.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 03793408BA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(39850400004)(346002)(376002)(366004)(396003)(136003)(66476007)(66556008)(186003)(66946007)(4326008)(86362001)(4744005)(16526019)(107886003)(6666004)(81156014)(7696005)(478600001)(52116002)(8676002)(66574012)(54906003)(316002)(6486002)(1076003)(2616005)(36756003)(8936002)(5660300002)(2906002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4Zu+kwzgwpuhIyeNKBw24REyj6JO4wqWR2oVXyPtaX4pNlPVAnAVYph6z5EZYkmdw1V8HG1COaQD6lkf5V36Wifkl8FYlh32nb0XE1OlrGMez2gsuErGhVQyHTQraAxvO90OfwJOKXwU/gsepL6vOnKLzSWliCWxbQgqfl6K095yPrwDjjzXphUdwrjFoIxyeWh/Rvd4NhJN3zsFVM+ieIxtL8OlLWkDEPINhzAZdnVSmPQ+6fbkV7n/jN0FzMtfmxmV4FRCP6VC4W8IZvy8c4aOH+zPffDnS6y3mG1hS61DK2GXrVxlIkzoKmEUpjvqSpBHErpSwLRZ+JWx6H9jx8TPgj6Ds6rdvVmwynyRaOni/DOT3aoFq0fm3uSVNemdgdb1KJJRm6A/vs87n9fZBMQ/VNXQihe4oJ37oigGz+a1hCxP5z2nMKNkRt1gVZ7X
X-MS-Exchange-AntiSpam-MessageData: rINdKNBa022eden3QJGWbFuGxCN3P9qGfwwme5oqHvMnmU94flXL/g0lXdlTnCpAMebqaEGYAZ5XDn1vXZOp2MKbPVbFQQ7RXcCQWGcD/lpITJo4ZU8Qxn4k+T4UGruGSmH3e5tGIKxzk6gv36zivUsgIARQg6eusbilAKu2lBpIsAQeFub/EXLVzGn79+V5JeQPgKNH9zsaDIUK7FwCjte3smydO6CedTTLvO7/4ZNEm7ST3JRIEc8oTLZjXVAZlv/g7p8Y+crfYc+CF6SXPQXixX7S0zhkxBv80tiD92AhaQW+nFlQjDovXjLIi5PcChgAJaCWJIQwqIbuNkvTcI5hXtHXCTMXIktbUMgWYn8azIcB+ioXsD3nAYpj+z8/JT7AzOgQYo4CXfD0O2DGuL6o+HzhW3j1fsgEM77Ez3kyanZzvR3FsB3NlfhwGHdSTM0juT00xxYFhhkntHaainN7Wxct9N85fEw3nyhBgV1E63JEm9+kKc0QCFsTzKwqY3MUbc+JMsYsYX/jIcwd+6snE2Fxe8eRh8IlhpiYaIvIEOyVRprGgzw6Vqpvd39GLY98i9u9WiODEo7AXlG99Vd0tT33bkiHqAa8PgWBd0SIX+g/3boWdTofMzrfTmdAOkc7FBgW64U03KPhCT4KIz1KiR8V11zlgu55SRia06X8X8286Pc+VXS4+eyu5vb5ewMnnobm+jHWsjsSRb+2blmcppkoktiDfwlbRrXZc2vFbnRrnz+1DaDAyZxhLzaXIGKQBDiEcQjI+VnEoO5wkroI+2+hP0gGBQseUBHNeNBx9LhqlngEffwhmUBm+kwLC+whe6cH/+LoNEIxo2Qf0zC1zB3Zo1n7QUx+Prq/DdI=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a12be56-8fe5-41c6-c817-08d7e5446d08
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2020 16:03:54.9461
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f+nuxCNeehYLXg6ze5AIkQrTiuXcNC1/6/iGMEVb6iEmhe1/sMrsz2kVzA8cK0wC3O+A9Lkg57ydDEU/Q+kDiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1792
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKSW4g
Zm9ybWVyIGNvZGUgKGJlZm9yZSB0aGUgaW5jbHVzaW9uIG9mIHRoZSBkcml2ZXIgaW4gbWFpbmxp
bmUga2VybmVsKSwKaGlmX2pvaW4oKSBjb3VsZCBydW4gYXN5bmNocm9ub3VzbHkuIFdoZW4gYSBq
b2luIHJlcXVlc3Qgd2FzIGluCnByb2dyZXNzLCBpdCB3YXMgZm9yYmlkZGVuIHRvIGxhdW5jaCBo
aWZfc2NhbigpLgoKTm93LCBoaWZfam9pbigpIGlzIGFsd2F5cyBydW4gc3luY2hyb25vdXNseS4g
VGhlcmUgaXMgbm8gbW9yZSByZWFzb25zIHRvCmtlZXAgYSBwcm90ZWN0aW9uIGFnYWluc3QgdGhp
cyBjYXNlLgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxl
ckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngvc2Nhbi5jIHwgMyAtLS0KIDEg
ZmlsZSBjaGFuZ2VkLCAzIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2lu
Zy93Zngvc2Nhbi5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zY2FuLmMKaW5kZXggMjc2ZmRhY2Q3
MTQzLi43Njc2MWU0OTYwZGQgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc2Nhbi5j
CisrKyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc2Nhbi5jCkBAIC0xMTAsOSArMTEwLDYgQEAgaW50
IHdmeF9od19zY2FuKHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LCBzdHJ1Y3QgaWVlZTgwMjExX3Zp
ZiAqdmlmLAogCWlmICh2aWYtPnR5cGUgPT0gTkw4MDIxMV9JRlRZUEVfQVApCiAJCXJldHVybiAt
RU9QTk9UU1VQUDsKIAotCWlmICh3dmlmLT5zdGF0ZSA9PSBXRlhfU1RBVEVfUFJFX1NUQSkKLQkJ
cmV0dXJuIC1FQlVTWTsKLQogCXd2aWYtPnNjYW5fcmVxID0gaHdfcmVxOwogCXNjaGVkdWxlX3dv
cmsoJnd2aWYtPnNjYW5fd29yayk7CiAJcmV0dXJuIDA7Ci0tIAoyLjI2LjEKCg==
