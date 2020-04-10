Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C24761A46DF
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 15:33:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbgDJNdm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 09:33:42 -0400
Received: from mail-dm6nam12on2089.outbound.protection.outlook.com ([40.107.243.89]:6130
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727004AbgDJNdl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Apr 2020 09:33:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YRtfLAK9MF604L0ULh5B1GidV5Vt2CeEP/WQfHQ6iw1L6wlRKds6HsNgCH9GE9sGMKCuB2l+2J4pD0obzTGBCCGiBKDm7kPhAcKz+x/PndnYo2IUyoKjTsffAGlMLzhyei7apofnjC+AbY1ix8YzFQt7LNoIXGfUFoiTsJFBOPEo1lilHv8Auh+ttVY1LwVK4RHQc0YTAkPG3NDEmD1SsPXryzvUDJ1jfRrLlGyVz6o6qRN/GIfdN2vYwxmB5xpSkQbaih3WGmrfIBgw5ueOJqQyHjgEaPemh5+BTwvZT84VJ1n3Mi/7ek4m0ObxtIpJyy0i+uBND7/9aVzLoAlthg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BaGk8gCExtKTCjraJxOhIJhwABtKx5Qf8bQqk9FYAl8=;
 b=fNdWHiCksIhjYudsRakuwrY7ORvBqxoXmUIizLVBsgJwdURG+0iIYkIVaxkS98aH0vX23FDj+g71d4bA7U3JjlwA7P22XKlvQCTCC2t1/AybP3jhWzMM42oAlWgz8mcHA3DtXRqVBhsYHIwaM99rx+Sol/Z5D3xF+0eU0MwUOBojI7Y0Jvxg/Jct+dv/8saMrW1EhKND9wxDHsBrowvOm7ctOVl3joJAAULEQEkRuzWKVhgQxFkZgp8CaHKNCdCPMEBY/0kmSJAt7WXJsipe1t2wzU7Y5mlwZqGmowDMlRbMOE1J5FBkX++1jFfaNM8eiUusiGTEmJWgM4yZ2yT8qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BaGk8gCExtKTCjraJxOhIJhwABtKx5Qf8bQqk9FYAl8=;
 b=Qlu8cYo1PB89IL4/2Jrw6nzS+ultyPZzlDYgqma49Ix5MoxmtyPUnpFIqNBxdX5s0Wy3bHfzR/YirYaJw6fwahXiejPCMwR8bhue8t06oMmX/M/knNMWvVKOp0piAgPKmHyit7ctE26BOouMKOf91ZtUxHbZH1l6VC0VWub15u0=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (2603:10b6:208:13f::22)
 by MN2PR11MB4398.namprd11.prod.outlook.com (2603:10b6:208:18b::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.20; Fri, 10 Apr
 2020 13:33:35 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::3d0a:d9ac:3df4:8b1]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::3d0a:d9ac:3df4:8b1%6]) with mapi id 15.20.2878.021; Fri, 10 Apr 2020
 13:33:35 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 19/19] staging: wfx: drop useless update of macaddr
Date:   Fri, 10 Apr 2020 15:32:39 +0200
Message-Id: <20200410133239.438347-20-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200410133239.438347-1-Jerome.Pouiller@silabs.com>
References: <20200410133239.438347-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: DM5PR15CA0056.namprd15.prod.outlook.com
 (2603:10b6:3:ae::18) To MN2PR11MB4063.namprd11.prod.outlook.com
 (2603:10b6:208:13f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:1265:30ff:fefd:6e7f) by DM5PR15CA0056.namprd15.prod.outlook.com (2603:10b6:3:ae::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.15 via Frontend Transport; Fri, 10 Apr 2020 13:33:33 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [2a01:e35:2435:66a0:1265:30ff:fefd:6e7f]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 898d1396-568a-4c2c-8deb-08d7dd53c4af
X-MS-TrafficTypeDiagnostic: MN2PR11MB4398:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR11MB43988C717200E613E9C9798D93DE0@MN2PR11MB4398.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-Forefront-PRVS: 0369E8196C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4063.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(366004)(346002)(396003)(136003)(39850400004)(376002)(107886003)(81156014)(54906003)(8676002)(86362001)(1076003)(4744005)(8936002)(4326008)(52116002)(66574012)(7696005)(316002)(66556008)(66946007)(186003)(478600001)(2906002)(6486002)(2616005)(66476007)(16526019)(15650500001)(5660300002)(36756003);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o+wbhnzrBwOxY/RhEdWm7H+P1RELqU/JSenBl6tiQ0V8vz51knFIMhLt80lP3Y4wXVg8+7I8uqy9XYwyn8wvZjF8OrXNYX3xvvMG5dJuHX0i8o9fyhTk2wUggxzjyLUKWXhAdm5mprU8FAob49ZwFal/VqTO7ygqen9sfrEkYpFNQtUrWbYnj9brZBu/LqDsC8z7tr7Qcj7XWZJTMUG5I2QazdoddF+IRPk9pp49xT+9aDo9JHBJ8WT+OtZQV6fF8DWX0bZiQK+EQJZ5ku4nJr0Zse1nIuN54PXNJI7I7nwUrYv+b+QzzQUmmOmip8MaCWbtpMZZU3Mp4jGvNpHdHg2EM2jzsBT/FMvFQE1vc4swy2t+AdoQTHJDG03naoP8I31aJkT/04iMeELZppy4ltDHKgzALUM86wf+BMYS+ZRI18k0syklBiJYD/Tlkxhe
X-MS-Exchange-AntiSpam-MessageData: 7cTXXVfPulDKbHkDf4fAls7b6LoqnjftCttoP60O9nxLNlC6DBD1EYTl0BmQcm+6e5y8lAAqyp7K28PSao+tqmXulGTiE4hcf3Hr9+ndJHQKr384en4UVYqheLOnqEOv6TqBSTKlVUu22qExsMo18Eg6W8YHOOLSmHuGXijPBRN3NfbsO5Qu6/C8dX7bsTLqhMHQW6+X+aQ4C1v5FWu5NA==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 898d1396-568a-4c2c-8deb-08d7dd53c4af
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2020 13:33:35.1296
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UGyz/TjxRt16Ov6FedBfQdnCPNySsSLrtJuefnPCfMgEDTOW0n0em90IGbOPvp6JA6BxizJj7lQXDRZcBtXFSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4398
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKTWFj
IGFkZHJlc3MgaXMgc2V0IGluIHdmeF9hZGRfaW50ZXJmYWNlKCkgYW5kIHJlbW92ZWQgaW4Kd2Z4
X3JlbW92ZV9pbnRlcmZhY2UoKS4KCkN1cnJlbnRseSwgdGhlcmUgaXMgYWxzbyBhbiBhZGRpdGlv
bmFsIHVwZGF0ZSBvZiBtYWMgYWRkcmVzcyBpbgp3ZnhfZG9fdW5qb2luKCkuIEl0IGhhcyBubyBy
YXRpb25hbGUuIE1hYyBhZGRyZXNzIGlzIGFscmVhZHkgcHJlc2VudAphbmQgbm90aGluZyBoYXMg
Y2hhbmdlZCBpdC4gVGhlcmVmb3JlLCB3ZSBjYW4gZHJvcCBpdC4KClNpZ25lZC1vZmYtYnk6IErD
qXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJz
L3N0YWdpbmcvd2Z4L3N0YS5jIHwgMSAtCiAxIGZpbGUgY2hhbmdlZCwgMSBkZWxldGlvbigtKQoK
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMgYi9kcml2ZXJzL3N0YWdpbmcv
d2Z4L3N0YS5jCmluZGV4IDUzYWI5NjQ4MTg0YS4uZjFkZjc3MTdkNWY0IDEwMDY0NAotLS0gYS9k
cml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMK
QEAgLTQxNSw3ICs0MTUsNiBAQCBzdGF0aWMgdm9pZCB3ZnhfZG9fdW5qb2luKHN0cnVjdCB3Znhf
dmlmICp3dmlmKQogCXdmeF90eF9sb2NrX2ZsdXNoKHd2aWYtPndkZXYpOwogCWhpZl9yZXNldCh3
dmlmLCBmYWxzZSk7CiAJd2Z4X3R4X3BvbGljeV9pbml0KHd2aWYpOwotCWhpZl9zZXRfbWFjYWRk
cih3dmlmLCB3dmlmLT52aWYtPmFkZHIpOwogCWlmICh3dmlmX2NvdW50KHd2aWYtPndkZXYpIDw9
IDEpCiAJCWhpZl9zZXRfYmxvY2tfYWNrX3BvbGljeSh3dmlmLCAweEZGLCAweEZGKTsKIAl3Znhf
ZnJlZV9ldmVudF9xdWV1ZSh3dmlmKTsKLS0gCjIuMjUuMQoK
