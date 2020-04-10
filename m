Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC2C1A46DE
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 15:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbgDJNdo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 09:33:44 -0400
Received: from mail-dm6nam12on2082.outbound.protection.outlook.com ([40.107.243.82]:31903
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726940AbgDJNdl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Apr 2020 09:33:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ezix9FY4h//GDKWtH0dsirKOr1CcI6e7tlallMBeulvzktSKRF2ls47HJ+Yhwlo39bPuCHGSM9V/4Ar/MlSW9k/aGoqdDeT9FqCAMgQBIY2RXlcOoTp9t4xnddihG442POrnq0x7OkgzVm+bNEc6BfsTLK+l7EZBYy/Y5us6mHum5dnf/9WlIAQzex35Dfv+ljM81dbe9yh0TRnbqyXk0Jh+R5foCaUvmxXZk+PZZyIGIQkwsQ4WBcvAghITVtKPpqQTBBfVHYJBun8et62tmN5HGigfSTYX+OoRv3i1BzPmEBqT0trY6xYNQuxnmV+CuCOZgnqoe1UJbYUbwqF23Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FGiWzJt4w79BHNd5ktlAX8LfvZgIMAvk8eAdFHMwL7M=;
 b=bNDvzYgkEpt3jLIOqFLPf1ncByYW0ezPH6CQDZKs8hiKfLevi1/hTej0z66RgEQwKpM9UO0zSUzamK7OU2SvFeyVXGL4KgauT5WK8eiKaMcYkyzNpcjLr0YH+d2DzEmI00H1zRhreBXAQ7cmX6ACdLro59bkNIZSGMrDsw2Fs5uQcGJODme0JwbufDpHQ6+SasaC0NMxMRW4tY3xjHAmUsNjdAKEn/s6tbQh6yZ6obqNxL9xcGPOCiGsQQXRJlV7EdrduEm3jm+nwsKqUyG3apATzCwteL9WhWFXLhyTC712HWqf9StKBKN1uqQTS6VkPk1m0zK21q6VxkcCm11BgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FGiWzJt4w79BHNd5ktlAX8LfvZgIMAvk8eAdFHMwL7M=;
 b=KeP/RZijiTCwEsGnE8WwDTSJ/o0J9prFQaSPJhpvXzi4vW0ZMoPwhZZ7WdWZEo433gUf36TW8tQSEg/7ozHNjPsnpBVBsEVmT2yjrgW2bAcjwlf8d5lzf3EDqOb45rKv7NUg5ceVo0rpv5/ium+iZcGwXWlkhUptG7Uspwr3kFw=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (2603:10b6:208:13f::22)
 by MN2PR11MB4398.namprd11.prod.outlook.com (2603:10b6:208:18b::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.20; Fri, 10 Apr
 2020 13:33:33 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::3d0a:d9ac:3df4:8b1]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::3d0a:d9ac:3df4:8b1%6]) with mapi id 15.20.2878.021; Fri, 10 Apr 2020
 13:33:33 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 18/19] staging: wfx: drop unused attribute 'beacon_int'
Date:   Fri, 10 Apr 2020 15:32:38 +0200
Message-Id: <20200410133239.438347-19-Jerome.Pouiller@silabs.com>
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
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:1265:30ff:fefd:6e7f) by DM5PR15CA0056.namprd15.prod.outlook.com (2603:10b6:3:ae::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.15 via Frontend Transport; Fri, 10 Apr 2020 13:33:31 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [2a01:e35:2435:66a0:1265:30ff:fefd:6e7f]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5e66bc86-bed0-4727-f545-08d7dd53c38d
X-MS-TrafficTypeDiagnostic: MN2PR11MB4398:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR11MB4398937CB58AEB80493ED03793DE0@MN2PR11MB4398.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:655;
X-Forefront-PRVS: 0369E8196C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4063.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(366004)(346002)(396003)(136003)(39850400004)(376002)(107886003)(81156014)(54906003)(8676002)(86362001)(1076003)(8936002)(4326008)(52116002)(66574012)(7696005)(316002)(66556008)(66946007)(186003)(478600001)(2906002)(6486002)(2616005)(66476007)(16526019)(5660300002)(36756003);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N+gedMZxHR4FHThGBoS39vF8UGwWk2SzAprAW8XcWx7Duvs6cEDDkU5fw46QI5TCmW31DsASDfTCJrVwNqPkj1XMpy6xP6N8zUxuAsPd4VIPKuIkCGhWmy+rP+ULShx22qOU0sAyxs5TM7TjApd+a0ttTaCFgv33RRb4JuMmfnwr4j8a760ViC3KCTYYgxBIuc2ilNiYT/uxxQ7JWGNPr4LFbaACdvF9bFG9V/xH27h/JuqxZueG1fpdssoklaR2up3L4qFS8IZMvtp+4HHQq1DqCOEz6gb8yAk/k/MW3MY5AzsbPwPQ0iJr8FUspKhtzVmx1LJVe3p/vHjJGO3A79tkq604FRejBhXzFTDSNaaM0k9ZxsH3Yg6u7LwmDpjb67czHE/nv/nY14qVTi1nhqxtHe9qNUOMhinWPaZzTlJg/DUCxmKR4wYbgCr+VC90
X-MS-Exchange-AntiSpam-MessageData: Zt2UFH1iWOGaQinexFS/rvCWwc1QEs6c1bi7R66B146390IPDrqULigD+/velFHPCk7gI6BsSBqkVow23BqI6ZxkdDeWcUqnQbi1o88F+4sesXLlkIdp/Zm444zMeWxkw3m4xI4qDHLsKAVx9m283SF7sNb6hxbHuMTHkEEm8aD5EvgaznpWlWFhYd+i4Pdthp/Iqofcw5zUtsVb8ujimw==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e66bc86-bed0-4727-f545-08d7dd53c38d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2020 13:33:33.1967
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3n29AVaFgJKNwkKAwM5qsYYZwxE7+VmD4fBgMrjdg7+Kl6o1p2Zqd3ebJVBHL3qFBD3vU0pM15v6IxjpCwFg5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4398
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IGZpZWxkIGJlYWNvbl9pbnQgaXMgbmV2ZXIgcmVhZC4gRHJvcCBpdC4KClNpZ25lZC1vZmYtYnk6
IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBkcml2
ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jIHwgNSAtLS0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC93Zngu
aCB8IDEgLQogMiBmaWxlcyBjaGFuZ2VkLCA2IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvc3RhZ2luZy93Zngvc3RhLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCmluZGV4
IDkxYjRjZTk0NTU5OC4uNTNhYjk2NDgxODRhIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcv
d2Z4L3N0YS5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKQEAgLTQ3OCwxMCArNDc4
LDYgQEAgc3RhdGljIHZvaWQgd2Z4X2RvX2pvaW4oc3RydWN0IHdmeF92aWYgKnd2aWYpCiAJCXJl
dHVybjsKIAl9CiAKLQkvKiBTYW5pdHkgY2hlY2sgYmVhY29uIGludGVydmFsICovCi0JaWYgKCF3
dmlmLT5iZWFjb25faW50KQotCQl3dmlmLT5iZWFjb25faW50ID0gMTsKLQogCXJjdV9yZWFkX2xv
Y2soKTsgLy8gcHJvdGVjdCBzc2lkaWUKIAlpZiAoYnNzKQogCQlzc2lkaWUgPSBpZWVlODAyMTFf
YnNzX2dldF9pZShic3MsIFdMQU5fRUlEX1NTSUQpOwpAQCAtNjExLDcgKzYwNyw2IEBAIHN0YXRp
YyB2b2lkIHdmeF9qb2luX2ZpbmFsaXplKHN0cnVjdCB3ZnhfdmlmICp3dmlmLAogewogCXN0cnVj
dCBpZWVlODAyMTFfc3RhICpzdGEgPSBOVUxMOwogCi0Jd3ZpZi0+YmVhY29uX2ludCA9IGluZm8t
PmJlYWNvbl9pbnQ7CiAJcmN1X3JlYWRfbG9jaygpOyAvLyBwcm90ZWN0IHN0YQogCWlmIChpbmZv
LT5ic3NpZCAmJiAhaW5mby0+aWJzc19qb2luZWQpCiAJCXN0YSA9IGllZWU4MDIxMV9maW5kX3N0
YSh3dmlmLT52aWYsIGluZm8tPmJzc2lkKTsKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93
Zngvd2Z4LmggYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3dmeC5oCmluZGV4IDYxOWU2ZjVjMTM0NS4u
NDFkNjdkYzA5MWE2IDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3dmeC5oCisrKyBi
L2RyaXZlcnMvc3RhZ2luZy93Zngvd2Z4LmgKQEAgLTg4LDcgKzg4LDYgQEAgc3RydWN0IHdmeF92
aWYgewogCiAJc3RydWN0IHdvcmtfc3RydWN0CXVwZGF0ZV90aW1fd29yazsKIAotCWludAkJCWJl
YWNvbl9pbnQ7CiAJYm9vbAkJCWZpbHRlcl9ic3NpZDsKIAlib29sCQkJZndkX3Byb2JlX3JlcTsK
IAlib29sCQkJZGlzYWJsZV9iZWFjb25fZmlsdGVyOwotLSAKMi4yNS4xCgo=
