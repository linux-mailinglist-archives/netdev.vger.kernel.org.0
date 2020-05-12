Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5A651CF86E
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 17:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730526AbgELPFS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 11:05:18 -0400
Received: from mail-eopbgr770070.outbound.protection.outlook.com ([40.107.77.70]:42722
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730801AbgELPFL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 May 2020 11:05:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mTQ+VSRA7NCDNemq4TMRRiF2vDQTvVq/HrJz+385vX+hSvsqU1HFAv4W9DJJiRGPYd9myQNpv6JfPoNprzz2f18/wvqfEvVUcUq5FKwTNpilQJmL4UtrhdaWueoQ8moHcDegEIWSsbfISAx39whTmYdfiJQV8bQAHfnr0GpCwDMXj6U6C/o55PMonNnRdq3a2rqo9QAx4AFo0qw5EzEnRAkc9AmA0RyQ4R6ieWjy43d1xdOPj0O5qy+QP77GXthnzbykFQxOM/5cAEPE0+e/+3ICJbEw3rYO3msd/VY36ZHiT49CY7WKy/I4kdx2faJUnWXMP1T54l5OOAMWy9XTQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pFy/vniKhrpxtq/YSZf0zFvIVPUCYROviEhpqdga+Vg=;
 b=S2ZIFcSHdNRAYzmnX/UayItW5Ktj4AVwYI7j5uNlgEjEuJSO1CPIjHg0apoigj5FqBDTSMf2fr4SgBJt5RX8cJmW6CbRyPkHdXVTIl8GeRoYdBKn+JDGajkS9vz17OSdiOuWXEnI7NiUU7tnIrMz0JlyoCRvWhrDAWpmvqoyxJJrgxdPAOyfv+uXpA2uHyqAHG1N2O/RjVdpamIPEBQ6YGQ6xMlKnzKQzj++Fx1YKAqqNudoaeDRU5VxTqr1LJP2CF74iV7VyeSR+0F3Dvtm5Nt7EsIreKTk8ZZuANYk3gSVKly4oio9XaV7aAyObBKpJFFR5m05nGcRNw6Fd7jntw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pFy/vniKhrpxtq/YSZf0zFvIVPUCYROviEhpqdga+Vg=;
 b=GiDa4RAHlN4KvRMYJ7NOhmaXI0faXX+qkrADPxbfvufXSfmnICubywr6GIGxC+tzYJjG8n1J0Hs21+Qj0bIsHW7YO+yRT8YmGYrDTH5TNwbRmWAQDYiPJsV8+M6wGFEWKVu4pQMVgsyLtHgqDrFwf5JxMsc4VMjAQpFNJOLrMt8=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1741.namprd11.prod.outlook.com (2603:10b6:300:10d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.34; Tue, 12 May
 2020 15:05:00 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da%5]) with mapi id 15.20.2979.033; Tue, 12 May 2020
 15:05:00 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v2 15/17] staging: wfx: fix endianness of the field 'num_tx_confs'
Date:   Tue, 12 May 2020 17:04:12 +0200
Message-Id: <20200512150414.267198-16-Jerome.Pouiller@silabs.com>
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
Received: from pc-42.silabs.com (82.67.86.106) by DM5PR1101CA0003.namprd11.prod.outlook.com (2603:10b6:4:4c::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20 via Frontend Transport; Tue, 12 May 2020 15:04:58 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [82.67.86.106]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 864b8fe5-38eb-4b56-8637-08d7f685d720
X-MS-TrafficTypeDiagnostic: MWHPR11MB1741:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB174175499B01A3B16E0C0ACC93BE0@MWHPR11MB1741.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-Forefront-PRVS: 0401647B7F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RzI0REGWeXkaqz72sghLZsSqEeuf7YOhctLA7/iiIXi+HaWX5YKMwinCs8xhte/osk80MSVnij7FqvJvjd5pMGS/K1vjBEV802JDS2PmNI8Ip/lzmjuWoaVq182lAqCJd53NRJRkP71AgI6Wt+Ma9dt3CimGAquLgkq/XP+LzG007tQA6tmLIOH7KlWZERUjJuu42DX4wLODSUDPC4yKc30Fmjuu/H+kj8wg9DwUaBM4dAEFfFhm+EcozIhgA71C+cXj5f3RBeRwOR0NZmsqjtNZl3CdC/8cvc76h3eQK1NnG/K4CaH07o2nBG3YWRDA0JUTkQo4XVfUfgyXWEvoNY/EnS0sEgJqcNg0BXumdZK6CAuv/UNq2sQkcjYnDzyV8fugHqnE4s1s6jjFx7on4HeB036+xzGO/C67J+3/POt1ScTX6VBwsAWZYOQJooiVhngrjxoAwFijebUTuH610E+MP42ShF4Zy9+T7DgwG5+mY+9UNc/D2VqAeck59IzlKhqcoVFOBwUqdU/ObVICGw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(366004)(376002)(39860400002)(346002)(136003)(33430700001)(54906003)(107886003)(478600001)(8676002)(5660300002)(316002)(1076003)(956004)(8936002)(2616005)(186003)(2906002)(7696005)(86362001)(4326008)(52116002)(6666004)(6486002)(66476007)(66574014)(26005)(66946007)(66556008)(33440700001)(16526019)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: YrVOBUfyVjsL+2CdBucnCal0dzs3j2B3YjjtRSNsZRBXrW+q/IT/hVkqfX3UUH2wWITzHgCHpR/Hv3dl8DaMP6GN/wz+/jbt+N57yr1m7oCufw0KgDgZzhtpz/hi+EyfLCKM0CGZWN/DbjhAkYYp6ZD9DDfHyQGkGmsFBigQPpm7w+R3QguJHS3oz8KkjL1t//XVdShDe8FwcAxVL4MEXI4ohj4dsu3df3gKFQDR0d9HqgUkA/kRecfdsLa0In+um8vcisBfnKhhX1o3f+m6YZj0nWB4vHBJrmKwlZMbDqFqc3WFHYpT7Ztesz7oVdz9ZdIOVTUSdHVWlDU8lKpBNzbJtDloByK+AEu45HLZDPS6spX+nBTlkPtgFFjLCV6ssKrUoWS0JZVXJUlxPQ4fHs1VyRk0otOhKkjI3UATbg1DCkW/TVJYD0+MA5K3+Msi/2QZPaxe7B0dR7YviHCUX5hdpWrLvnbQwQa11AqxZTY=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 864b8fe5-38eb-4b56-8637-08d7f685d720
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2020 15:04:59.9009
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OnahC/fjdeh1/HSztBFZovG7+WJuB4sUEFrz3VPJRnDh7pmmv0AlmQZqPqUI/NUWNXq98UN+j4XEe30qI79GXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1741
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IGZpZWxkICdudW1fdHhfY29uZnMnIGZyb20gdGhlIHN0cnVjdCBoaWZfY25mX211bHRpX3RyYW5z
bWl0IGlzIGEKX19sZTMyLiBTcGFyc2UgY29tcGxhaW5zIHRoaXMgZmllbGQgaXMgbm90IGFsd2F5
cyBjb3JyZWN0bHkgYWNjZXNzZWQ6CgogICAgZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfcnguYzo4
Mjo5OiB3YXJuaW5nOiByZXN0cmljdGVkIF9fbGUzMiBkZWdyYWRlcyB0byBpbnRlZ2VyCiAgICBk
cml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9yeC5jOjg3OjI5OiB3YXJuaW5nOiByZXN0cmljdGVkIF9f
bGUzMiBkZWdyYWRlcyB0byBpbnRlZ2VyCgpIb3dldmVyLCB0aGUgdmFsdWUgb2YgbnVtX3R4X2Nv
bmZzIGNhbm5vdCBiZSBncmVhdGVyIHRoYW4gMTUuIFNvLCB3ZQpvbmx5IGhhdmUgdG8gYWNjZXNz
IHRvIHRoZSBsZWFzdCBzaWduaWZpY2FudCBieXRlLiBJdCBpcyBmaW5hbGx5IGVhc2llcgp0byBk
ZWNsYXJlIGl0IGFzIGFuIGFycmF5IG9mIGJ5dGVzIGFuZCBvbmx5IGFjY2VzcyB0byB0aGUgZmly
c3Qgb25lLgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxl
ckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvYmguYyAgICAgICAgICB8IDIg
Ky0KIGRyaXZlcnMvc3RhZ2luZy93ZngvaGlmX2FwaV9jbWQuaCB8IDMgKystCiAyIGZpbGVzIGNo
YW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2
ZXJzL3N0YWdpbmcvd2Z4L2JoLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2JoLmMKaW5kZXggNmM2
ZTI5Y2I3ZGNmLi4xY2JhZjhiYjRmYTMgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93Zngv
YmguYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2JoLmMKQEAgLTEwMiw3ICsxMDIsNyBAQCBz
dGF0aWMgaW50IHJ4X2hlbHBlcihzdHJ1Y3Qgd2Z4X2RldiAqd2Rldiwgc2l6ZV90IHJlYWRfbGVu
LCBpbnQgKmlzX2NuZikKIAlpZiAoIShoaWYtPmlkICYgSElGX0lEX0lTX0lORElDQVRJT04pKSB7
CiAJCSgqaXNfY25mKSsrOwogCQlpZiAoaGlmLT5pZCA9PSBISUZfQ05GX0lEX01VTFRJX1RSQU5T
TUlUKQotCQkJcmVsZWFzZV9jb3VudCA9IGxlMzJfdG9fY3B1KCgoc3RydWN0IGhpZl9jbmZfbXVs
dGlfdHJhbnNtaXQgKiloaWYtPmJvZHkpLT5udW1fdHhfY29uZnMpOworCQkJcmVsZWFzZV9jb3Vu
dCA9ICgoc3RydWN0IGhpZl9jbmZfbXVsdGlfdHJhbnNtaXQgKiloaWYtPmJvZHkpLT5udW1fdHhf
Y29uZnM7CiAJCWVsc2UKIAkJCXJlbGVhc2VfY291bnQgPSAxOwogCQlXQVJOKHdkZXYtPmhpZi50
eF9idWZmZXJzX3VzZWQgPCByZWxlYXNlX2NvdW50LCAiY29ycnVwdGVkIGJ1ZmZlciBjb3VudGVy
Iik7CmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9hcGlfY21kLmggYi9kcml2
ZXJzL3N0YWdpbmcvd2Z4L2hpZl9hcGlfY21kLmgKaW5kZXggZDc2NzIyYmZmN2VlLi44YzQ4NDc3
ZTg3OTcgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX2FwaV9jbWQuaAorKysg
Yi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9hcGlfY21kLmgKQEAgLTI4MCw3ICsyODAsOCBAQCBz
dHJ1Y3QgaGlmX2NuZl90eCB7CiB9IF9fcGFja2VkOwogCiBzdHJ1Y3QgaGlmX2NuZl9tdWx0aV90
cmFuc21pdCB7Ci0JX19sZTMyIG51bV90eF9jb25mczsKKwl1OCAgICAgbnVtX3R4X2NvbmZzOwor
CXU4ICAgICByZXNlcnZlZFszXTsKIAlzdHJ1Y3QgaGlmX2NuZl90eCAgIHR4X2NvbmZfcGF5bG9h
ZFtdOwogfSBfX3BhY2tlZDsKIAotLSAKMi4yNi4yCgo=
