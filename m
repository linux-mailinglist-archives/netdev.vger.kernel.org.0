Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B828B17F4B9
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 11:14:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbgCJKOQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 06:14:16 -0400
Received: from mail-bn8nam12on2076.outbound.protection.outlook.com ([40.107.237.76]:6032
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726244AbgCJKOQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Mar 2020 06:14:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ezesZafEhAbkkhZ6Tlcpo4npnOvaW6OWQykOC03Cio4HRl5kJpswFUEo8nYovDys5jRRXhc2KKsdKjyevEKkQJEVf9l/ezbrquNcHdjCMV8bqxEetMc/J+9XBFVfCPTRfyf3MCPhaTT6mTq84pwxrObN6LpHk64S++PNbK/blz7qNRYRiqM1nk8703c1qidS74R3NLxli7ld27p2VtyQgirOnb7l2QvBSFlWFvnB5DmiiPaQWbQoGv3O8qq8L9GMWsoFnfpZcpD3tMeiZgJKN4b/D4IFRFJD3YX1S6UoU/Bjn45aiXVc+Q06+K13RDvG2dYUlsk7AgIXfBjTA9qUhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=juYTxEEp0l2bOgyQgYBor8ImI7ZTATLjVOtctxwSA4E=;
 b=nYk3Oku1KlsO/x+M4lKY8yKf4syED5D5plruj2jm4SH15DzEPfPeAHTGP+ozE5s+DNrMydU8D/rvvl15B+I2YD3foC6/46WIm9MC+Bwx8XzjUZ52rNuVTSGFnBO34z5BS5wdgRtjejgGmafjqR/WjD+PUhNVxkmG0ONuXKc/9pv097pnA43Taq3goXZH65r4qGuxJxqeTdUK6hhpcEBLRcPg/buzXpclG10h/uMslPwPL3w9HyNrQLr1264eHxggD6Oo8br/Bw5veLLIA+q+exES/G8xBH1gEzR/M74mw6NSp5apJo3PQVd1quuD/H579/Bk/71hi50VYJY5BO4G7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=juYTxEEp0l2bOgyQgYBor8ImI7ZTATLjVOtctxwSA4E=;
 b=c3JzZ7IQT8c5/KseYpdjkpn13/mIrjQ/+TPfVED+4PD7Mpl6SkF/Mz+o0nd/hsdyxSvE/n+iWzmEgU35rnxfl8SMHag9M9wfEAtQ5CHIxhN3RU/+kl8fd/rOyxiQ44NSvWVcolURE1Lc/4SVl+75abYswBVpOKbVktzwB+YAsYU=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (2603:10b6:208:13f::22)
 by MN2PR11MB3615.namprd11.prod.outlook.com (2603:10b6:208:ec::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.17; Tue, 10 Mar
 2020 10:14:13 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3%7]) with mapi id 15.20.2793.013; Tue, 10 Mar 2020
 10:14:13 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 0/5] staging: wfx: late fixes
Date:   Tue, 10 Mar 2020 11:13:51 +0100
Message-Id: <20200310101356.182818-1-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.25.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR0P264CA0180.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1c::24) To MN2PR11MB4063.namprd11.prod.outlook.com
 (2603:10b6:208:13f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (37.71.187.125) by PR0P264CA0180.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1c::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.14 via Frontend Transport; Tue, 10 Mar 2020 10:14:12 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [37.71.187.125]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 19d38bc4-2181-49c6-e096-08d7c4dbc81d
X-MS-TrafficTypeDiagnostic: MN2PR11MB3615:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR11MB3615AD4E8B49507ECEAEE94B93FF0@MN2PR11MB3615.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-Forefront-PRVS: 033857D0BD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(39850400004)(136003)(366004)(376002)(396003)(346002)(189003)(199004)(6666004)(52116002)(5660300002)(2616005)(86362001)(316002)(956004)(36756003)(478600001)(4744005)(7696005)(8936002)(54906003)(4326008)(16526019)(186003)(26005)(6486002)(66574012)(66946007)(8676002)(1076003)(81166006)(2906002)(66476007)(81156014)(66556008)(107886003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3615;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KxNtqmcZcBj1RKInZPd8eo5Fn+UhFoIQ/radbCDslRRfIBAuEZDGnYpv9MNCSfiLLOrK5bNzg9hXaTXj7yPHJhgjPoHYiKpxRNaLxz6gh+bSICBBiLn33RYf6hh1i7G1cA4VNe7rg6eDOsRRxTeB5q41x5oWkjgdEyqf8l56jC1FyHXJBafU2UAWkjOkX+LfFwwEsTppctpNwUlcW0fuMTDV4Iih41NPBEgCEK51zNxBesKcY7tDFkmi1SWpoxQRfOSZjjuiT7SV1tJc2Z4ex+AqfjW1WCMG/Q0BrpmK9+67NcANPmaeOVKIwwBdScHBLmvaxp8+2LZ7iASTLZmAGhSYGqNQYkXXaaxr8QnjnImADR8VwWLMcLd7PHxv0T26nu+wwO9aVLeLfBt0ZzTUKAtalXzvlWdgu9EH4SPKjQCn4yFGdYnYeAqIAaFaEadQ
X-MS-Exchange-AntiSpam-MessageData: jUqCGpVMHlDc1VC0B2wBWWaEjBfcMJo50SiOn9a9bJEbBzLTv5W/DXoUwIl8NeNQ2Lbj1Z6/WoXvqdqGTAaoW2vPrQS23mFeKC1+fx0BLR14zE936OmCXzGNyirCoc9vlbWPaEpv7eu5mfTF5QM5Wg==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19d38bc4-2181-49c6-e096-08d7c4dbc81d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2020 10:14:13.3595
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d9NU8hHOk7wy/maVvcMazfAYyiDF0AHrdQGm2cmjy6b9Dybg+pA1PEpt7SetfSJllejnDXAxZxt3RBHRF/74Fw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3615
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhp
cyBzZXJpZXMgZml4ZXMgc29tZSBpc3N1ZXMgZm9yIDUuNi4gVGhlIHR3byBsYXN0IHBhdGNoZXMg
Zml4IG1pc3VzZQpvZiBSQ1UuIFRoZXkgYXJlIHByb2JhYmx5IHRoZSBtb3N0IGltcG9ydGFudCBv
ZiB0aGUgc2VyaWVzLgoKSsOpcsO0bWUgUG91aWxsZXIgKDUpOgogIHN0YWdpbmc6IHdmeDogZml4
IHdhcm5pbmcgYWJvdXQgZnJlZWluZyBpbi11c2UgbXV0ZXggZHVyaW5nIGRldmljZQogICAgdW5y
ZWdpc3RlcgogIHN0YWdpbmc6IHdmeDogZml4IGxpbmVzIGVuZGluZyB3aXRoIGEgY29tbWEgaW5z
dGVhZCBvZiBhIHNlbWljb2xvbgogIHN0YWdpbmc6IHdmeDogbWFrZSB3YXJuaW5nIGFib3V0IHBl
bmRpbmcgZnJhbWUgbGVzcyBzY2FyeQogIHN0YWdpbmc6IHdmeDogZml4IFJDVSB1c2FnZSBpbiB3
Znhfam9pbl9maW5hbGl6ZSgpCiAgc3RhZ2luZzogd2Z4OiBmaXggUkNVIHVzYWdlIGJldHdlZW4g
aGlmX2pvaW4oKSBhbmQKICAgIGllZWU4MDIxMV9ic3NfZ2V0X2llKCkKCiBkcml2ZXJzL3N0YWdp
bmcvd2Z4L2hpZl90eC5jICAgICB8IDE1ICsrKysrKysrLS0tLS0tLQogZHJpdmVycy9zdGFnaW5n
L3dmeC9oaWZfdHguaCAgICAgfCAgMiArLQogZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHhfbWli
LmggfCAxNSArKysrKysrKysrLS0tLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMgICAgICAg
IHwgMjUgKysrKysrKysrKysrKysrLS0tLS0tLS0tLQogNCBmaWxlcyBjaGFuZ2VkLCAzNCBpbnNl
cnRpb25zKCspLCAyMyBkZWxldGlvbnMoLSkKCi0tIAoyLjI1LjEKCg==
