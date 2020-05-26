Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADAFC1E284B
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 19:18:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729765AbgEZRSp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 13:18:45 -0400
Received: from mail-bn8nam11on2083.outbound.protection.outlook.com ([40.107.236.83]:48578
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728581AbgEZRSo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 13:18:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jZ7jRKeQIPwDD49H8jJxC0pdiEsuDWBrAPkDWGxMTRzcYuzr+mL+GiRVPlgRIVeIcKuVEAEGSc0QFTigfCvueeq4n217leOSWt8xCYB7Zh6AP+++SLFi/QaTEi/RSkdB66gFKc3SukbCvzhn+pqfdEpHdnsbqzGPjtzzYmJBiP0pskGuxkC9TxWNwvXUbTqefDha3Ur09EMqwddaer4onBGAb4+rNalAoEvVs26NmwEUGns9fdfmN6DnaYX58hdNCbF6LPqWRAb4NkFyDS0xzV82vYb0vihW8puvRB4jbCk+tZL6W24Q18/s5No2WwZDquz1GNrO5XMfJKT1z6XuaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I87+MWHXtycnXkRi2eJFfGUqbFHWv7rsORNkmVr73/Q=;
 b=HFWjlgjogZbz4SYOmPZummaqNkTOitmJEAz4RzcFHHkodbmplrAp7rzZQFKfQHHl9+5qKRwQazycvQy2rkkDWtR/rGuvkWYOyeElob9Z6aO78Y61Yyrm2gDxcLK5vCFNNgR9NS+WiRv28B2HCKTk4HNZ92+y9iRBhES38geu92H5KU4WLeioqVN5rOanoKwV2LondHSCA1BdCWDJbzh6QviQVX8jAlNI8ghDVduHkt9KMd/sq4mDRbFHXt8d2csKzGAWUdgK/dArv2V5B8sRx9ktUBp9QmYHvIcG6EqtHdojhr4TFHs1EaLjzZLQgYq441UgiRCQAppmRX4PlND53w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I87+MWHXtycnXkRi2eJFfGUqbFHWv7rsORNkmVr73/Q=;
 b=MhHidx4sCDNGITPOsNP8jmsVeNhv8SJb/By7R0uWD1EMpPjodJ+EpEUx1DFiSYBxv2tk/MWRLuaaBlxL3BfhlqVKlFikVIhkf87BMv8gc8ke0kE0f1QHOgHLEWgpoH7eYeshq5cJg3TrfbaPD3Mh6s3r2dFTYzkFvhAcJbHQ/pY=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB2750.namprd11.prod.outlook.com (2603:10b6:805:54::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.25; Tue, 26 May
 2020 17:18:40 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::c504:2d66:a8f7:2336]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::c504:2d66:a8f7:2336%7]) with mapi id 15.20.3021.029; Tue, 26 May 2020
 17:18:40 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 00/10] staging: wfx: introduce nl80211 vendor extensions
Date:   Tue, 26 May 2020 19:18:11 +0200
Message-Id: <20200526171821.934581-1-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.26.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR1PR01CA0007.eurprd01.prod.exchangelabs.com
 (2603:10a6:102::20) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.home (2a01:e35:2435:66a0:544b:f17b:7ae8:fb7) by PR1PR01CA0007.eurprd01.prod.exchangelabs.com (2603:10a6:102::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend Transport; Tue, 26 May 2020 17:18:39 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [2a01:e35:2435:66a0:544b:f17b:7ae8:fb7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 654d54cf-7dbd-4bcf-7905-08d80198d595
X-MS-TrafficTypeDiagnostic: SN6PR11MB2750:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB275094D19FACED6781AA92B593B00@SN6PR11MB2750.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-Forefront-PRVS: 041517DFAB
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IXPkD1b1BGLitrC+6p8OJfGsZAgYEZ6sDo5rTJxq9c1GLsHJuZba516WiSilV00gAYIC5IynjwHnfhbS7PBF6c6Y8wwh4L9XC0VZct/pZf5HFvLY7T8RcaCb/A61eSFYYtr7IQ15zrhBD2U9Qc+b+8obQRHsreFiSBnmABo5Kdhk3t5ItUrfG53AHrojwVOOXsxryC7n0bMs0XXsu7OsXGjLWHrySAOr4NEwwjOyNbWcrpcjbJgj9vKOojbhJ5n8tbcfyKz6iNpIszYsVlDQP9qfSNPrt20omBFbwVl3E0RxeWaDvRYYJVeHFfp9RJrw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(376002)(366004)(39860400002)(136003)(346002)(4326008)(6512007)(316002)(8676002)(8936002)(2616005)(6486002)(2906002)(107886003)(1076003)(86362001)(6666004)(186003)(16526019)(5660300002)(66574014)(36756003)(54906003)(66556008)(478600001)(8886007)(6506007)(66946007)(66476007)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: vm7Z/fqHNt8wN8TIfTwI0eCP5nNmDFgy+byB07xGZ/P8horXFPmKWWmuXRGMPbYbn2KZX6aOlt6l1ZpnI4ARkHQOJx+uFb6G69mMGrjOGhHcoQZYFeclLyRH4+xcDZ4XYLUdFN2uN48EnTAJBWESOF18RI2CLcT2sQ0+qHffp66R/T4Is1PF+bYxJUYBEM0WEnCLV6hjedCDQu4+ww2MFzcaf4TRn25sgUsahdyaYSz6CiTFwakXH4/3C7COGTkF5AXax1asH61qgGwNnTCd7Not7mrClvEi4l9hh1/SC3ne+gr7yH1PVsqiH2s+nzfljjkyzVjX1XGIqzD2/0WvN9Y2lDbMTWkwZSQsd8TpnQBJxygN/fpDgrbn7kObo7UywmfCE8wMksh2WKVdsDfu6XmES5eaUkqmYjbv9B2zHk0VE54/JKNBhyYJn6HLtwUMayfNorImNCH1NG/7DRtFKNOSp3ZDmGz5FZInvT/+3xSpP0zY3nZu4Lh1f3/qJFF8DJvKfuqV5S+twQoLfiSu+rqGYnYKSo2zgnWjIft95t8=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 654d54cf-7dbd-4bcf-7905-08d80198d595
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2020 17:18:40.5133
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RL9svmceryRQcPBRyzD9d0NxF90Br9h/xKx+aQkaUDJdlaftQmzhWvdqI4UfvE2qn0XG9xBFXf6rJcgJgR8okA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2750
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKSGVs
bG8sCgpUaGlzIHNlcmllcyBpbnRyb2R1Y2VzIHNvbWUgbmw4MDIxMSB2ZW5kb3IgZXh0ZW5zaW9u
cyB0byB0aGUgd2Z4IGRyaXZlci4KClRoaXMgc2VyaWVzIG1heSBsZWFkIHRvIHNvbWUgZGlzY3Vz
c2lvbnM6CgogIDEuIFBhdGNoIDcgYWxsb3dzIHRvIGNoYW5nZSB0aGUgZHluYW1pYyBQUyB0aW1l
b3V0LiBJIGhhdmUgZm91bmQKICAgICBhbiBBUEkgaW4gd2V4dCAoY2ZnODAyMTFfd2V4dF9zaXdw
b3dlcigpKSB0aGF0IGRvIG1vcmUgb3IgbGVzcyB0aGUKICAgICBzYW1lIHRoaW5nLiBIb3dldmVy
LCBJIGhhdmUgbm90IGZvdW5kIGFueSBlcXVpdmFsZW50IGluIG5sODAyMTEuIElzIGl0CiAgICAg
ZXhwZWN0ZWQgb3IgdGhpcyBBUEkgc2hvdWxkIGJlIHBvcnRlZCB0byBubDgwMjExPwoKICAyLiBU
aGUgZGV2aWNlIFRoZSBkZXZpY2UgYWxsb3dzIHRvIGRvIFBhY2tldCBUcmFmZmljIEFyYml0cmF0
aW9uIChQVEEgb3IKICAgICBhbHNvIENvZXgpLiBUaGlzIGZlYXR1cmUgYWxsb3dzIHRoZSBkZXZp
Y2UgdG8gY29tbXVuaWNhdGUgd2l0aCBhbm90aGVyCiAgICAgUkYgZGV2aWNlIGluIG9yZGVyIHRv
IHNoYXJlIHRoZSBhY2Nlc3MgdG8gdGhlIFJGLiBUaGUgcGF0Y2ggOSBwcm92aWRlcwogICAgIGEg
d2F5IHRvIGNvbmZpZ3VyZSB0aGF0LiBIb3dldmVyLCBJIHRoaW5rIHRoYXQgdGhpcyBjaGlwIGlz
IG5vdCB0aGUKICAgICBvbmx5IG9uZSB0byBwcm92aWRlIHRoaXMgZmVhdHVyZS4gTWF5YmUgYSBz
dGFuZGFyZCB3YXkgdG8gY2hhbmdlCiAgICAgdGhlc2UgcGFyYW1ldGVycyBzaG91bGQgYmUgcHJv
dmlkZWQ/CgogIDMuIEZvciB0aGVzZSB2ZW5kb3IgZXh0ZW5zaW9ucywgSSBoYXZlIHVzZWQgdGhl
IG5ldyBwb2xpY3kgaW50cm9kdWNlZCBieQogICAgIHRoZSBjb21taXQgOTAxYmI5ODkxODU1MTYg
KCJubDgwMjExOiByZXF1aXJlIGFuZCB2YWxpZGF0ZSB2ZW5kb3IKICAgICBjb21tYW5kIHBvbGlj
eSIpLiBIb3dldmVyLCBpdCBzZWVtcyB0aGF0IG15IHZlcnNpb24gb2YgJ2l3JyBpcyBub3QKICAg
ICBhYmxlIHRvIGZvbGxvdyB0aGlzIG5ldyBwb2xpY3kgKGl0IGRvZXMgbm90IHBhY2sgdGhlIG5l
dGxpbmsKICAgICBhdHRyaWJ1dGVzIGludG8gYSBOTEFfTkVTVEVEKS4gSSBjb3VsZCBkZXZlbG9w
IGEgdG9vbCBzcGVjaWZpY2FsbHkgZm9yCiAgICAgdGhhdCBBUEksIGJ1dCBpdCBpcyBub3QgdmVy
eSBoYW5keS4gU28sIGluIHBhdGNoIDEwLCBJIGhhdmUgYWxzbwogICAgIGludHJvZHVjZWQgYW4g
QVBJIGZvciBjb21wYXRpYmlsaXR5IHdpdGggaXcuIEFueSBjb21tZW50cyBhYm91dCB0aGlzPwoK
CkrDqXLDtG1lIFBvdWlsbGVyICgxMCk6CiAgc3RhZ2luZzogd2Z4OiBkcm9wIHVudXNlZCB2YXJp
YWJsZQogIHN0YWdpbmc6IHdmeDogZG8gbm90IGRlY2xhcmUgdmFyaWFibGVzIGluc2lkZSBsb29w
cwogIHN0YWdpbmc6IHdmeDogZHJvcCB1bnVzZWQgZnVuY3Rpb24gd2Z4X3BlbmRpbmdfcmVxdWV1
ZSgpCiAgc3RhZ2luZzogd2Z4OiBhZGQgc3VwcG9ydCBmb3IgdHhfcG93ZXJfbG9vcAogIHN0YWdp
bmc6IHdmeDogcmV0cmlldmUgdGhlIFBTIHN0YXR1cyBmcm9tIHRoZSB2aWYKICBzdGFnaW5nOiB3
Zng6IHNwbGl0IHdmeF9nZXRfcHNfdGltZW91dCgpIGZyb20gd2Z4X3VwZGF0ZV9wbSgpCiAgc3Rh
Z2luZzogd2Z4OiBhZGQgc3VwcG9ydCBmb3Igc2V0L2dldCBwc190aW1lb3V0CiAgc3RhZ2luZzog
d2Z4OiBhbGxvdyB0byBidXJuIHByZXZlbnQgcm9sbGJhY2sgYml0CiAgc3RhZ2luZzogd2Z4OiBh
bGxvdyB0byBzZXQgUFRBIHNldHRpbmdzCiAgc3RhZ2luZzogd2Z4OiBhbGxvdyB0byBydW4gbmw4
MDIxMSB2ZW5kb3IgY29tbWFuZHMgd2l0aCAnaXcnCgogZHJpdmVycy9zdGFnaW5nL3dmeC9NYWtl
ZmlsZSAgICAgICAgICB8ICAgMyArLQogZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3R4LmMgICAg
ICAgICB8ICAxMSArLQogZHJpdmVycy9zdGFnaW5nL3dmeC9kZWJ1Zy5jICAgICAgICAgICB8ICAy
NiArKysrKwogZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfYXBpX2dlbmVyYWwuaCB8ICA2NyArKysr
KysrKysrKy0KIGRyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3J4LmMgICAgICAgICAgfCAgIDcgKysK
IGRyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4LmMgICAgICAgICAgfCAgNjQgKysrKysrKysrKysr
CiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5oICAgICAgICAgIHwgICA2ICsrCiBkcml2ZXJz
L3N0YWdpbmcvd2Z4L21haW4uYyAgICAgICAgICAgIHwgICA2ICsrCiBkcml2ZXJzL3N0YWdpbmcv
d2Z4L25sODAyMTFfdmVuZG9yLmMgIHwgMTQzICsrKysrKysrKysrKysrKysrKysrKysrKysrCiBk
cml2ZXJzL3N0YWdpbmcvd2Z4L25sODAyMTFfdmVuZG9yLmggIHwgIDkzICsrKysrKysrKysrKysr
KysrCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3F1ZXVlLmMgICAgICAgICAgIHwgIDEzIC0tLQogZHJp
dmVycy9zdGFnaW5nL3dmeC9xdWV1ZS5oICAgICAgICAgICB8ICAgMSAtCiBkcml2ZXJzL3N0YWdp
bmcvd2Z4L3N0YS5jICAgICAgICAgICAgIHwgIDU2ICsrKysrKy0tLS0KIGRyaXZlcnMvc3RhZ2lu
Zy93Zngvc3RhLmggICAgICAgICAgICAgfCAgIDIgKwogZHJpdmVycy9zdGFnaW5nL3dmeC93Zngu
aCAgICAgICAgICAgICB8ICAgNyArKwogMTUgZmlsZXMgY2hhbmdlZCwgNDU5IGluc2VydGlvbnMo
KyksIDQ2IGRlbGV0aW9ucygtKQogY3JlYXRlIG1vZGUgMTAwNjQ0IGRyaXZlcnMvc3RhZ2luZy93
Zngvbmw4MDIxMV92ZW5kb3IuYwogY3JlYXRlIG1vZGUgMTAwNjQ0IGRyaXZlcnMvc3RhZ2luZy93
Zngvbmw4MDIxMV92ZW5kb3IuaAoKLS0gCjIuMjYuMgoK
