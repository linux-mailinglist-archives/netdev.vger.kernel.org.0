Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B704A167CD9
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 12:56:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728167AbgBUL4Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 06:56:25 -0500
Received: from mail-eopbgr760043.outbound.protection.outlook.com ([40.107.76.43]:28579
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726909AbgBUL4X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Feb 2020 06:56:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WlZCVA3IMiAQ+ALQvYxCWKXsy/TAImKDL/3oQ5luAoSUS+1lyVSZ8CNOg6L3ryNeM71MexwWe3S0MjRLlZzHNIt8/r/baPMsrRMGWhOqkGljIRucffzv4t+6/CLty0i1e6J8WbQaPU9Y1mOyO+HaT5qF6u77RYAP/fMU6MKL9/K/JEQnMMv3B8W63AXwBWnIyC9I5Lj6Yy0Du/qZVJTYoBH8gFQH7rR0NbdXXqkJYSlXhv5Wtr93WqZz5xx2ZWkwUWBBRl4oq8e25a9fd/hP+56CferlV6RsRrQQwsQDZzn6MSBT8+5ULuWuJC8yYpL1k8th1sRyPAsqKbuK2WQx5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pLEnjwXZoVoAdWhmJ1clKYImsMJSGE/7M/sQNQ2JmhU=;
 b=aKjrgYlIt2IuKyBaKv90Dr4l91p8EPdzWR1FdFGnejh6p7GiMIk7CidD76QAO9R7UliKNrx5ycVsRZ0lyyFpFfb+s8+eZP3odrUTRQiN9/RhBbe0XVNdCI8F8KQd09KLlfqEsXz9joMlavH3GgsSluyVdQIAJiJzVZyqzFslSxPlZDaneRoX+mqk/9sfjpWch+xYAHoDGVD0koYps83Frs/qC2AMciNOvckqp6vMVKme/ajyXchR9SBYSfB8SOazAEwHIGdoNufJKK1mvAtPFqK3/ypmKdACDL6svgrIomwY6ZmAa9Wk+9Pj9Kxme8VgMWisC3QDlcnxXAcMxgGS7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pLEnjwXZoVoAdWhmJ1clKYImsMJSGE/7M/sQNQ2JmhU=;
 b=RdtMXtPwiiF+qIorWBeAoO+jZW5jLmQeenRV5SXQk//vDLf0M//SgMQbVbMX6RLndTdDKAydg5jj93Pm6aXtLJGGgmhBOMnrS5c84dUmUvUgWC9FvbcorA7x3mZbbZgnEYPDMzsHCtG6NUhZxegwkW74R6IjJuFdqiuAN+Et5Ao=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (2603:10b6:208:13f::22)
 by MN2PR11MB4662.namprd11.prod.outlook.com (2603:10b6:208:263::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.17; Fri, 21 Feb
 2020 11:56:20 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3%7]) with mapi id 15.20.2729.033; Fri, 21 Feb 2020
 11:56:20 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 02/10] cfg80211: drop duplicated documentation of field "privid"
Date:   Fri, 21 Feb 2020 12:55:56 +0100
Message-Id: <20200221115604.594035-2-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200221115604.594035-1-Jerome.Pouiller@silabs.com>
References: <20200221115604.594035-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR0P264CA0137.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1a::29) To MN2PR11MB4063.namprd11.prod.outlook.com
 (2603:10b6:208:13f::22)
MIME-Version: 1.0
Received: from pc-42.silabs.com (37.71.187.125) by PR0P264CA0137.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1a::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.18 via Frontend Transport; Fri, 21 Feb 2020 11:56:19 +0000
X-Mailer: git-send-email 2.25.0
X-Originating-IP: [37.71.187.125]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a23d5ddf-1557-4c07-9530-08d7b6c51102
X-MS-TrafficTypeDiagnostic: MN2PR11MB4662:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR11MB46623241D469E387F305D88393120@MN2PR11MB4662.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2331;
X-Forefront-PRVS: 0320B28BE1
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(396003)(346002)(39860400002)(366004)(136003)(376002)(199004)(189003)(36756003)(86362001)(8676002)(81156014)(478600001)(8936002)(81166006)(7696005)(52116002)(66946007)(2906002)(4326008)(107886003)(6916009)(1076003)(66556008)(6486002)(66476007)(6666004)(5660300002)(956004)(54906003)(316002)(2616005)(186003)(16526019)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4662;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Eu4V+4ZsvCSWnB7QbnkB1PELu5gYyEZlBZwwFE3uVIX0Mu9pOEoy5bN5K2RTpXgZgomfhSd9qzqSSeMKy01F6IyveawLxji/Qo3g+1fbT4dcdlMZkKblfZbwhYghv8iyKUwEtI/G7H4hujtlJI0YhEpfOrl5v2mNV4f2KGB7me2+8KWJFOCo8qvlvhARYq6uL3epPl2ya9zgAjFAV0vScZcEqIzk0x/+cuGTYhMyeU/joiElutvYVFpS6TdKelUJniBwvTgmZ4rT5R+S9fXKRFOGwHYAjAagM7H9/Hr4iRvl1zhs1UOwSWoFlAuM2yOwdT5sWWTRpsk+nNEQVo4rOVo1DzN3mb5aJVyaI6ndP2IH72z2cytJrCDMrv6ww+hvLU/m+O3rumbJ4xcVWK0vtwdAC/GlV83OzMCpziL9QkrcRI1v5SihC9cg2eGPSueK
X-MS-Exchange-AntiSpam-MessageData: z8Dr+ZL7PAGDpsT0hDIS2xnzHd9AH5IVGLg+f+G00yuh8Jt5OayyEBlPWdZYHq3fsnFhl9si3CBo5H3/7G9FbJNfzyScpJw7eGZ+exmIRAVFCsvG4pQKaxUQjbauzD4cc8wKXXjixLZ+A3P0n37NWw==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a23d5ddf-1557-4c07-9530-08d7b6c51102
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2020 11:56:20.8227
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lR5TcrBaGSeWnYEtQqGbYwP8os1CGfvEQf/oMPTjHzt7Zmc/X5Ps6yuAq7bxS9/behLLX2ceCTnD9ZDLwXGJqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4662
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IGZpZWxkICJwcml2aWQiIHdhcyBhbHJlYWR5IGRvY3VtZW50ZWQgYWJvdmUgdGhlIGRlZmluaXRp
b24gb2Ygc3RydWN0CndpcGh5LiBDb21tZW50cyB3ZXJlIG5vdCBpZGVudGljYWwsIGJ1dCB0aGV5
IHNhaWQgbW9yZSBvciBsZXNzIHRoZSBzYW1lCnRoaW5nLgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0
bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGluY2x1ZGUvbmV0
L2NmZzgwMjExLmggfCA1IC0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgNSBkZWxldGlvbnMoLSkKCmRp
ZmYgLS1naXQgYS9pbmNsdWRlL25ldC9jZmc4MDIxMS5oIGIvaW5jbHVkZS9uZXQvY2ZnODAyMTEu
aAppbmRleCAwMmVmZWE1MmEyNzYuLjI5Mjg3MWFlOTgyOCAxMDA2NDQKLS0tIGEvaW5jbHVkZS9u
ZXQvY2ZnODAyMTEuaAorKysgYi9pbmNsdWRlL25ldC9jZmc4MDIxMS5oCkBAIC00NjI0LDExICs0
NjI0LDYgQEAgc3RydWN0IHdpcGh5IHsKIAljb25zdCBzdHJ1Y3Qgd2lwaHlfaWZ0eXBlX2V4dF9j
YXBhYiAqaWZ0eXBlX2V4dF9jYXBhYjsKIAl1bnNpZ25lZCBpbnQgbnVtX2lmdHlwZV9leHRfY2Fw
YWI7CiAKLQkvKiBJZiBtdWx0aXBsZSB3aXBoeXMgYXJlIHJlZ2lzdGVyZWQgYW5kIHlvdSdyZSBo
YW5kZWQgZS5nLgotCSAqIGEgcmVndWxhciBuZXRkZXYgd2l0aCBhc3NpZ25lZCBpZWVlODAyMTFf
cHRyLCB5b3Ugd29uJ3QKLQkgKiBrbm93IHdoZXRoZXIgaXQgcG9pbnRzIHRvIGEgd2lwaHkgeW91
ciBkcml2ZXIgaGFzIHJlZ2lzdGVyZWQKLQkgKiBvciBub3QuIEFzc2lnbiB0aGlzIHRvIHNvbWV0
aGluZyBnbG9iYWwgdG8geW91ciBkcml2ZXIgdG8KLQkgKiBoZWxwIGRldGVybWluZSB3aGV0aGVy
IHlvdSBvd24gdGhpcyB3aXBoeSBvciBub3QuICovCiAJY29uc3Qgdm9pZCAqcHJpdmlkOwogCiAJ
c3RydWN0IGllZWU4MDIxMV9zdXBwb3J0ZWRfYmFuZCAqYmFuZHNbTlVNX05MODAyMTFfQkFORFNd
OwotLSAKMi4yNS4wCgo=
