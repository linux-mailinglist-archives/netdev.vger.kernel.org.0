Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B8D61CF856
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 17:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730472AbgELPEl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 11:04:41 -0400
Received: from mail-bn8nam12on2076.outbound.protection.outlook.com ([40.107.237.76]:45896
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726055AbgELPEj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 May 2020 11:04:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O67J/5PVovseDMEpIDi1+twMPHMoekSfSntrC4YMSBrXPAb/u9A03J5yS0P2RsGxXxOt4mmHYZPtt5gCZJ0cKOn4A+nJ6ZvHjGQ/S9EU8pR92wxh7LkxiCUyX7nQGNqzTWaXPTBiOCLTtukaE2iBJNAkHB3c5folgGVqC4CS9rHwIaGBul9RxbJ+mLuTiX317/odwAUFSLH41Ii+f6tY4n8alLBufpCdUQqwxA+pJE5dTrd03Fpc2ce4kBmYu4hb10nfkk8ryLsA2fZHKZ1lUhMotouRZptWEmjYvUXu55RvBFq3ThLt65K8ErUCBR8Roq3fXhUpC74JohcvznPakA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7W9J6xx50RVl9zf/gu8v/A2L1KffHWgqaGOXqplNmJE=;
 b=Sd2H1AJnlCJ9ESr4wLHWKIYH+PebWxYAgAkNwk8TGNohQO7ff5gEd6j5+JnOSNM05iyem4cH7VajU4TuO0QSgroOXIRFRXux4nwdwhwB+YZyuSgf+E12Rk48No/Pr6bu1B52rpfQIYAU0ZamX31MNGVaE0fksFfyRQrVKyY0zivt5fIR6g1fP4rhiUyxyE4SgMJ76BEoI7tS9LAWDwq+FoMbeftL1KAp9PyDtY6xmO4ALeJJJmJBJpvsFcCNu954AoadkqABlUvdI3AXh+ABA7bMUQoi4S4//naRt9kYuthittwA/NxUeC3qDm1jkdZoxzR9pQtKtmlvPugKhI5sdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7W9J6xx50RVl9zf/gu8v/A2L1KffHWgqaGOXqplNmJE=;
 b=jq2coVjQcBwEF5Fih+3ci/V8PE2LnMybfAK8YuZPoSHI2X9YkdXN+DGYIIizbkLTdND8vzUHZ73NsL01CC8kkl0oG2c1e0qzkkX4xaa6CH3J6Qy9zw/FDfhMnUsmSnqhV5XyB+PlBLJ/3NwT4rbkse+1K+8Jmq4FKe6ggQmqRFY=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1741.namprd11.prod.outlook.com (2603:10b6:300:10d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.34; Tue, 12 May
 2020 15:04:34 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da%5]) with mapi id 15.20.2979.033; Tue, 12 May 2020
 15:04:34 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v2 02/17] staging: wfx: take advantage of le32_to_cpup()
Date:   Tue, 12 May 2020 17:03:59 +0200
Message-Id: <20200512150414.267198-3-Jerome.Pouiller@silabs.com>
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
Received: from pc-42.silabs.com (82.67.86.106) by DM5PR1101CA0003.namprd11.prod.outlook.com (2603:10b6:4:4c::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20 via Frontend Transport; Tue, 12 May 2020 15:04:32 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [82.67.86.106]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b0f0e563-af29-4388-8596-08d7f685c7b6
X-MS-TrafficTypeDiagnostic: MWHPR11MB1741:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB1741608559FBE770522BF04F93BE0@MWHPR11MB1741.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-Forefront-PRVS: 0401647B7F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rVGj7UMFNfV9+EVSvOsEs4LTmauQGYCoGk81Yeb6iP2FUXdgrkv0SfTSZh4INz9Gn+cN8uP3JQgRJwC30HqA+MTCD3U9dkjWoEJ7EIU7pEOtBnxnSCr7+358sxTMCVvGR3EXLP+JolRaUSkpdgJexxEX0VqZkZrh2qQGog0SH5Co+/xeKLUJGnlyrz2ZFunbf9BpK3rbnYOZp9ENblR9tYy6+0MHMIU3VhHh5dPAst0n8m8kRQuN3+YabRbj087i4Yg+2t3MsgOAdmEhCDJ/HUQGKZFNG2ikfqBBQ0/J58La4/XTeOcf9WFoAMMfDKfXihCS29UQqmG3CgwH76Iid+EaMp932OnCarkNkRtqlznfaMi2iC5yI1hJZyyXs0XYW8bEFM9XsH06fSoDCRRWNCzTcymXtC1V+h78ZGvUdQ1D2wnzYgde66/YvlXvZETOBwf+R0gB7JxnasSnOi73u2WoRcVE8Z3PZqUVaDHxvEFUCA/JRVuPilvdjP1h0KgiXFf5XcFPVg+7tfOuPbYNBg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(366004)(376002)(39860400002)(346002)(136003)(33430700001)(54906003)(107886003)(4744005)(478600001)(8676002)(5660300002)(316002)(1076003)(956004)(8936002)(2616005)(186003)(2906002)(7696005)(86362001)(4326008)(52116002)(6666004)(6486002)(66476007)(66574014)(26005)(66946007)(66556008)(33440700001)(16526019)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: OIIwmBQNINzITxmMcdq73yJ25L4sYXXYhhhQq8MoYLtY9shuf/fMaLUqYxMdXnjtcQfUz+KIneCrBy8fLArLWE5lOtMWIiOLyDjlfFagfWW/XGndSiC7wEII1PgJlDznBfdO5tu+Jp3BzgQB4zbDBid7QAXHpd1ikSjdp+k+eeRTSK+MAqotKBfhRqM86V5NU/EW/qhw4bBTB8AS60DN6n0WX+3MceewKWsynM+/tqCcnCPC7FeunUJLf4weZKGdE3Rx4AhdirK2hS8TwKrY+k50k8bIuOEEzyUDoMRFl6zy4bHV7z6nKoQ38gMUF7isCTUXFN32uKnPYswWUE/arlSUCaWzxVYOL6LAqOHwjjy2zMDYD0v1Vs8UGjqA9v33VVQsfl/0EQ0nxyHaySCN7uMlmWp0bW7y34tAOgqKDOK+8foyfWCzYYEhTrMfCg1r9HmIruO/WRWfqIaY4+tpiuzLvktuAhPzeJ8vCKgQOkU=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0f0e563-af29-4388-8596-08d7f685c7b6
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2020 15:04:33.9914
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GYsDZ/tQt+bWVgzazm4g3ycsq80OdDNOAHS13O5ON9Ht5JkQ59765udkGjWaKTw7J52HG99jO1eScofHfjiwQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1741
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKbGUz
Ml90b19jcHUoKngpIGNhbiBiZSBhZHZhbnRhZ2VvdXNseSBjb252ZXJ0ZWQgaW4gbGUzMl90b19j
cHVwKHgpLgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxl
ckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3J4LmMgfCAyICstCiAx
IGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQg
YS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9yeC5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZf
cnguYwppbmRleCBhYzRlYzRmMzA0OTYuLjgzYzNmZGJiMTBmYSAxMDA2NDQKLS0tIGEvZHJpdmVy
cy9zdGFnaW5nL3dmeC9oaWZfcnguYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9yeC5j
CkBAIC0yMiw3ICsyMiw3IEBAIHN0YXRpYyBpbnQgaGlmX2dlbmVyaWNfY29uZmlybShzdHJ1Y3Qg
d2Z4X2RldiAqd2RldiwKIAkJCSAgICAgICBjb25zdCBzdHJ1Y3QgaGlmX21zZyAqaGlmLCBjb25z
dCB2b2lkICpidWYpCiB7CiAJLy8gQWxsIGNvbmZpcm0gbWVzc2FnZXMgc3RhcnQgd2l0aCBzdGF0
dXMKLQlpbnQgc3RhdHVzID0gbGUzMl90b19jcHUoKigoX19sZTMyICopIGJ1ZikpOworCWludCBz
dGF0dXMgPSBsZTMyX3RvX2NwdXAoKF9fbGUzMiAqKWJ1Zik7CiAJaW50IGNtZCA9IGhpZi0+aWQ7
CiAJaW50IGxlbiA9IGhpZi0+bGVuIC0gNDsgLy8gZHJvcCBoZWFkZXIKIAotLSAKMi4yNi4yCgo=
