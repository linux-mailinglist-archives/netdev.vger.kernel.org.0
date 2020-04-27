Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F41541BA528
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 15:42:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728088AbgD0Nl1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 09:41:27 -0400
Received: from mail-mw2nam12on2085.outbound.protection.outlook.com ([40.107.244.85]:27104
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728039AbgD0NlW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 09:41:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WKEbyalUu3uCswzX3SyS9H9CwFiTZPf32suLvOvIm55iOvb69Q6KZa3BlIqstLtFgdpQjGMyBIcs1PjX0tJI1jjUcDiK05btlE0i4XnYy97sxwZAYQG9NfZf9glFcNBXA6q0VBSI8vOCz/kz6LUJOUetNwoo7+RudAYUCwEK1BTQrvk+1+xrPkXH+dfZzNesR37o/VPPEWA9SSkERb9+6Fqh7a0HgnedcfOtqn2ALnmwnolYSOiq8MxbIA1DBgqrYfMmMT44txuyrtz3s+j6Y3WXhX0l8khcL0fBlM4TTFHyc8TKpCRLW8DfG+6XIlV4+8iXrQv3YaILAqYD3JiXtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ArHefbqV21SB9u1u11bvJ2ldj7JfEtPQEMPuhZ4pQ5g=;
 b=I56hOfbq4TrBDzeUhsvWIxUabhqJo6wprRGXXV+UOcPMXRWyi/NqPRp1Rf0upKMxzhIIQ4Ncx+GXaJldmhHBtXQ7Y5xOcYpuYitG6k/l5WMU6PcM9JYvatDQJGU83B+FHfJVsOs/cbvOeCXyt8Aj+yHGX34Ui+s75d/ik2sVyJju3PsIydos0zndBzqQVIw1FOspauxNBXQkBj9VYFxOpJjs+4QivD/gI+bABg/5QLV4oVIyg0V8c2rxYzY+r476/hfZUEgs5ayHMjeR+Wn27m/q0rLGAwy9W/4A4kkYlj3f3P2Hlzr9y4pMnc6BKd1Hcm8wj2f2pAt38LdlBKCKrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ArHefbqV21SB9u1u11bvJ2ldj7JfEtPQEMPuhZ4pQ5g=;
 b=ce5Ohdhf7qaqf1df7or0N+cFDReMdZbOsXErFJQaaMi5U4URbiBrv0hIGhak8drqOYnNq+cQG2jK1E9GiVVKeaKA4bn+zGDE6vIJQqqnTegtV/ucMNRRTMdcLb+3mYFaOFLAe6dEtOQPXx1fuRnkNPwhrh+AzxioFT+bY6dWjqs=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1424.namprd11.prod.outlook.com (2603:10b6:300:26::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Mon, 27 Apr
 2020 13:41:20 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe%10]) with mapi id 15.20.2937.023; Mon, 27 Apr
 2020 13:41:20 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 08/17] staging: wfx: fix highest Rx value declared in ieee80211_supported_band
Date:   Mon, 27 Apr 2020 15:40:22 +0200
Message-Id: <20200427134031.323403-9-Jerome.Pouiller@silabs.com>
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
Received: from pc-42.home (2a01:e35:2435:66a0:544b:f17b:7ae8:fb7) by PR0P264CA0232.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1e::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Mon, 27 Apr 2020 13:41:17 +0000
X-Mailer: git-send-email 2.26.1
X-Originating-IP: [2a01:e35:2435:66a0:544b:f17b:7ae8:fb7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3383b784-e967-481b-15d3-08d7eab0ab25
X-MS-TrafficTypeDiagnostic: MWHPR11MB1424:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB142420E7315BF30C6793ACA493AF0@MWHPR11MB1424.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-Forefront-PRVS: 0386B406AA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(39850400004)(376002)(346002)(396003)(366004)(8886007)(66476007)(66556008)(4744005)(4326008)(81156014)(86362001)(8936002)(6486002)(52116002)(6666004)(6506007)(5660300002)(16526019)(6512007)(1076003)(478600001)(8676002)(36756003)(186003)(2616005)(54906003)(107886003)(66574012)(2906002)(316002)(66946007);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q/1XJupTjPYq0sCCH0R44mnao4/5sG1nGuuechHGjbPeLF4rNE50gMz4Zg8MXsPXweFj7e7pBDdbCfyL5RIUkgZBLI+4rhdDbY9+9ZYhvp0GxQ8SIOrleE+WSuhPFY+4zCiNQL5+47eS2mIN6bkvdkAwE7MuEY5i7TVTDm05LDErbaIEdtWfUwwH+QkiyRla1Yn7t2Pl24dAXFfti0Ba4LO4y56/hoMRExF39XWLd+o1AwBduejGR//Qd452I8Wzps64ZcTnQXypAmvhi6aF3Xo2H4xRv5JXflkPGt2OnLz9O8lwhNeH2AShTqDEs5iD9d9wI9349HovU/vU3isDLKYfGOwaEvylCdc6qF58A9of3gLQPbKBjhq1jcX36m+76ylAbiSCkGYVxDH0niKNnPR3CiQ61rWAdYv5KUiIzn2W4GNMWHpYEXQiyCuIyBhM
X-MS-Exchange-AntiSpam-MessageData: hbqOdKH4fSxR0R8Csou9gs1K8E5bRbnHedGm+rB446MzJuuMtLt9Z7DRosxE83acHqouh14xl+oWej6OIU+NT3gqT9Pm9+m7dvqSJb51fMIvTADzVH5yDF/R9hqF3/GgeoocOMy+TCOTHz1pxyONckXLLe6cWEoBuPFtoCoF8Dj2pnxzbiNWbxH49vCG0L3J9jBL26MPTfkko1bBC+L1y6FBkPwLoJaR82Z8MIJjc5AOwkR1zkukN/j7DiJZhmMaNCc65LQNFVL+2QDHaF5TwEzVHDU1iQ1vGoqfsmjkoOjRpdIyP3hvi4KBl4ZOhbdbFi+FSrCUPcYusjQL+/EqnuHyHXx15FMkEKWM6hagYz51GR1AESNyKWrtqT9RZQqQuU/lIk+8aMR1RRSNqo9uNyG0R62u494wpvnYQUv+7hFqcqYlXzi/kB8QG5NNuHnVgLK1wIeHFL66Xt77r8ReQ34k0R6rR1fkSMCxxip+barbDxDGNtQeVeEIhKqQT4H7VEbHTPY+DoJcENt3rShvR/3eE1a5odlOzDn5MKZyMfJJesXPMGJ24QLsuHNuifM8DJ8f9lnKyP5zSPnVAEBp8vQ0fmL7HAYGUCG7IAVm6tLPcxBuuYIt8v6EMhNb5VE2KQlTfaj1cYyqoPrPj77tx7F4IfRk2XAbyLfxoK8cwBYSojnMAlyYLa1ng3LhC6fyRTGh5IC9Bfuf2YJIcWpoUrX5qavOcMACDUjFUCQdB8r4q6oT3QWWn3MG2L3yJE37nkKpkfvy6wI5HuyokoqGwnM0DTjRlaMlfXdpMjKM0ZHg0xOVJxjV2Fn7ZvfqjnJ8c/1tIkRzyPCHOsxHWpw8d+MysDeHrTWz7PVUFcyBYrU=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3383b784-e967-481b-15d3-08d7eab0ab25
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2020 13:41:20.6990
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AZ/HkmTCTFLt27RL1TbCOaOKQpv+jsnkJSnveze61ptkiqn+gkRLiQyLwiu89goJUdF0GHbkkS6JzV2+cRsJ0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1424
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IGhpZ2hlc3QgUnggdmFsdWUgZGVjbGFyZWQgaW4gaWVlZTgwMjExX3N1cHBvcnRlZF9iYW5kIGhh
ZCB0d28KcHJvYmxlbXM6CiAgICAxLiBUaGUgdmFsdWUgc2hvdWxkIGJlIGxpdHRsZSBlbmRpYW4K
ICAgIDIuIFNob3J0R0kgd2FzIG5vdCB0YWtlbiBpbnRvIGFjY291bnQuIFNvIHZhbHVlIHNob3Vs
ZCBiZSA3MiBpbnN0ZWFkCiAgICAgICBvZiA2NS4KClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBv
dWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcv
d2Z4L21haW4uYyB8IDIgKy0KIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxl
dGlvbigtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvbWFpbi5jIGIvZHJpdmVy
cy9zdGFnaW5nL3dmeC9tYWluLmMKaW5kZXggMTA5MzU4NDM3M2FkLi43NDJhMjg2YzkyMDcgMTAw
NjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvbWFpbi5jCisrKyBiL2RyaXZlcnMvc3RhZ2lu
Zy93ZngvbWFpbi5jCkBAIC0xMDYsNyArMTA2LDcgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBpZWVl
ODAyMTFfc3VwcG9ydGVkX2JhbmQgd2Z4X2JhbmRfMmdoeiA9IHsKIAkJLmFtcGR1X2RlbnNpdHkg
PSBJRUVFODAyMTFfSFRfTVBEVV9ERU5TSVRZX05PTkUsCiAJCS5tY3MgPSB7CiAJCQkucnhfbWFz
ayA9IHsgMHhGRiB9LCAvLyBNQ1MwIHRvIE1DUzcKLQkJCS5yeF9oaWdoZXN0ID0gNjUsCisJCQku
cnhfaGlnaGVzdCA9IGNwdV90b19sZTE2KDcyKSwKIAkJCS50eF9wYXJhbXMgPSBJRUVFODAyMTFf
SFRfTUNTX1RYX0RFRklORUQsCiAJCX0sCiAJfSwKLS0gCjIuMjYuMQoK
