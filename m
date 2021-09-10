Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6F19406EAA
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 18:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230346AbhIJQG6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 12:06:58 -0400
Received: from mail-co1nam11on2067.outbound.protection.outlook.com ([40.107.220.67]:25696
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229451AbhIJQGq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Sep 2021 12:06:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HpblC7YtiFdT1xEjIkzD0L77ll287DKZYDLINgOZKEXQK6+mt7ZfAMXLcC6mZGPQKIZXa0cCb2OAVo17e2iguPRMkhqBsuU0UIlg5iN6OJBXsub7YZW8F/RsJ5JuYGmZeah5kEOXyxpPvBQBtZoSln+7k5/p7yWCX5Ek8SGgD8JeIobQZBXkbUVemy+3GyYpmcNKzl4Xutbgz8We3G7M0z825sxzlevmQOL5M57SrnaLS9mIJiep8v4ig28UrhWwEEFl272kzxnBQaLfbH6xmDIbfrdOhej4uokjVsmao9EE5ahudRSn5TDbMPoYum5CJtwNePBZ9wl0HUBxTMW0rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=Fib8Y8j+Fw/sN2NX69u9T+P9uNpyVHksmDfyGgxLK4M=;
 b=PZ/CuwMOMpYpxBA1JkidjrnisZj5F691XAZU8hFiC8InzCy1qz3P+yd+ORiZ3XgrRBjymeoCnXWkukRLjlX6Xrng+VkmJzFxipW5T4O9MtWyf0ZF8cXqXb1xydRFCXSTucbZ/uJJJewi29HCTl+iz7YU0gCOTVAGlzvbPsEwykJaxhonTRH5XNn3xXrYFWLfmFl2wE2+HoWVnL55aN+uzZLA68hvSJzgMPyiaGGk5C5Umi+d1L5YWTM3j9nLjgfo4MZiDued/a2s0nTqWaq4euSZ2ar+S4wwx1fTi98ILUZnga+EN7Tjr4uAyW8xNy0yPq4unC8ALhVH90AdxCfpTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fib8Y8j+Fw/sN2NX69u9T+P9uNpyVHksmDfyGgxLK4M=;
 b=RZ3LmnX+F3GuvRCuJ5ac1Yjsjby2ooolA0MwRHRS/aaSmcaKkJdEwW+7yiXluFOcYQDoLbqrBwQuCIAXvyET/B+I7zn9h2LShoPXeKU7pDjS4fQazliifUKSA2n9s6MBKsxYi2i0pEr1OHKw/xsaUzm6dGh7s3BuKV5UTzfqiug=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA0PR11MB4592.namprd11.prod.outlook.com (2603:10b6:806:98::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.17; Fri, 10 Sep
 2021 16:05:33 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Fri, 10 Sep 2021
 16:05:33 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 01/31] staging: wfx: use abbreviated message for "incorrect sequence"
Date:   Fri, 10 Sep 2021 18:04:34 +0200
Message-Id: <20210910160504.1794332-2-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210910160504.1794332-1-Jerome.Pouiller@silabs.com>
References: <20210910160504.1794332-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: SN4PR0601CA0006.namprd06.prod.outlook.com
 (2603:10b6:803:2f::16) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (2a01:e34:ecb5:66a0:9876:e1d7:65be:d294) by SN4PR0601CA0006.namprd06.prod.outlook.com (2603:10b6:803:2f::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.15 via Frontend Transport; Fri, 10 Sep 2021 16:05:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3c400d46-7ec7-4b36-dcf7-08d97474d190
X-MS-TrafficTypeDiagnostic: SA0PR11MB4592:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR11MB4592F47D477C9B6507EA2F1193D69@SA0PR11MB4592.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DkUjH7DWdYbciEtKdegbBTHDuM0ThY4NiKyTUEHBYGzviWajPiC7GVcL2RfD4vM6zegxop4ibZJ3Q0uvi2jQflpQWubsHeQ3nDABF3xGHmIl7e3QM+DVZye1ycrTCgOR/xENcH803OraTfSrJ6VyCaXLAwlzfWDP4Ml/kFu0733RziDFpgJ9uyy4MUnu9wdT+XMitzyfPqThXcd9D83XZ9gEIbFGekc+kvEFSsKI9k2JN47F3di6vwRtBqs020r7NSPSD6HOpkkqhE3XD/6derpV0WEidkqPHF8y0367eQMW7v3cygtz1ZB1cAqII/yreJ/+MeStwZGJGVd9ZHkN43T4MtrDALYI4qZGdiDPfeLajq8nLJrKsI9u0H5blKx12kMy/Sj4Bg4lC0Yqw4BkzD0fmen+6yN5n/E53selhL2L+E7ULEzZFNRpNKIafMBtTMuqnNvR06tiDjhrHnMoRL8lPPcU2fN2T3kcfH8/LuK2UMKp1GSgGu1HUwmneJpQtd3O/HJtp5MuDgNBbGa1OSzATCtLLb7d9Lwv4An2R5x6/o4oTcvLMEwjAC5mzg1p87oPAdGium7c4zYiAAgaoxPR8Ke2FMRmRzV0O1pOzjqfmFVRgQfcaHzC8qLOj7R6lm9eMYqeYMvFiVj6l2Z8dg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(508600001)(2906002)(66556008)(66476007)(316002)(66946007)(83380400001)(66574015)(8676002)(8936002)(36756003)(15650500001)(86362001)(6486002)(107886003)(7696005)(52116002)(54906003)(2616005)(5660300002)(4326008)(38100700002)(1076003)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WmxwZFNQMThtSUZUUDZCTHliVjJ3cGQwV2tTR0w2K3VNNTNvOHh1a2VOQUNY?=
 =?utf-8?B?YnlOUTQvYkRPQnNxek13d1BzRWJyRXFrOWw3Vnc2UmxSSmlSL0VZb1FvNUtr?=
 =?utf-8?B?M3lXVTdjcUhOdFlnQTBHZzUvcWtFbTBHL1Axb1prVHlsUW9xa1JqZVpEVXY5?=
 =?utf-8?B?YjlGL2VDeVp6OHltVEJaekFjMThCNi9Fb0hZWGgycFhNVjIrMzNFR3pnWnBX?=
 =?utf-8?B?QXEyeW1iTDJWVldnOHdBN2R5cWx4NHAvMUNJS01kY01JRk40K2JINGxYTHpQ?=
 =?utf-8?B?OXJ6Vk1peE9hQU1vMVpmZS9rVVpidWtQUDgvNS9GNy8yMHhaNGc2bk80dEdM?=
 =?utf-8?B?WHd6SjJYY1BhN0ZxSkIrNFlUQzk4SHVQVkM1eVF0cWhpbXJQZU82ZEZSd0Fj?=
 =?utf-8?B?dzhFZ3I0SEJ2NUgxWlI2QzAyQm9wcEZGUHVNRzlLQzBSV3JrcHhnb1VuZU1y?=
 =?utf-8?B?TE56c21MTmhVeDVIOWhycWxaZEFFMjNNMUFSTWY0OXdUU2ZXdVo5S1JkeHJu?=
 =?utf-8?B?SDdmbkxrQlh1UE8wOC9CVmt6ditSTDZGcTJ4bytEQU8ycFJQZXlseUF3b3dL?=
 =?utf-8?B?dnQvVWZvck96NGRiTEhnMmJnWmdCTXZ6OW1SYjJhN2RIMjgwV2hrZDdWVVRW?=
 =?utf-8?B?UVM0WlE1Wk0rT3BzUUdxQ09ZRVJQN283MjJLL2xWdmwxY3ZlaXRaQlZQWTlt?=
 =?utf-8?B?WXFFWW1jUHhjSk1yeVpiVkZ6elMvQW9zb1FHZ0o3N2tzbEJZTnhHVHpaVjR2?=
 =?utf-8?B?d0Q5VHFvZlJPdENRVi81Qmt6NHgvV2hyUjRCSFBpWThjRmxCU21pYVRTSUI5?=
 =?utf-8?B?NnBjOXF5TUhUVlZyelZvK2JpN0RTcG1LMlhUTkd2V2ZxS2FVWkxBQnQxY1lY?=
 =?utf-8?B?ckNMMkFKclB3Q1hDS0hES3Fia0VrMEdxU1ZVYmI0T0tKaDJPMGwxaXpPZjJW?=
 =?utf-8?B?VTFvYW84UGM2eWZzcFpleWdud0xVVjRXeEk0dGlXR0ZrbGtXM1NoWU5RUXlS?=
 =?utf-8?B?NXJ2R3hJekxtSzFGbEFsSGpPSEtnSmRHT1p2Sm1wNWtJWHRKK25wTXBDQWgz?=
 =?utf-8?B?VDdjRnRLM1dLUENnY0pVSGhENExYUGd6c2FacHVheUJrTDdOMkE1eHNCS2VB?=
 =?utf-8?B?bVVIRU1ONTRiVXRwendwR1hXT3BGbXY4UmlNV3g2MFRuZ05hSWhyejJ6NmNa?=
 =?utf-8?B?MlR0SFhDdTQ5cFNMUUZnZm95TEtFaGRldEVkUzMxbzRTR3dqOE1ERGVPaHcx?=
 =?utf-8?B?cDBJTnBMejhDb0RDb0ttUGE2a1NjMy9KOGdWVGVLbnhOWWF1ME5KeGMzN3Zj?=
 =?utf-8?B?Z1dUa2czVjlZckdFeDN4NnlpTHNOeUVhdlRqVlN5eS9SZmUrUUJnNEREZnRy?=
 =?utf-8?B?b3ZVUTYra3E5OWw1YXlyVTNmdllDV21qam9BdmxrMmxmWnVvNmIxcW83N0Zz?=
 =?utf-8?B?d2J1Q3EzSUNkVEVBMGRJS21HV2NMc0ZpWjZtaEkvSW81UXBERDJwb0Eza3FY?=
 =?utf-8?B?UC9VdG0yYkg5M2lEU3dhYUFKU3BKc0s3WjI3ZVlsZTBnNGIvQkpUVTVGUjUw?=
 =?utf-8?B?VHlMZnQ5RGlJTFhIaG42V3JaUXpacFp3dm1pZmcrNkFzTUtHQXQrUW5WVXR1?=
 =?utf-8?B?UFUzbERPc0J0S0ZMSHYvc3hyUGh1S0hoUlY0QW5yc1Zka2JHbWFMY0pQNEJk?=
 =?utf-8?B?RmdwU3NZMmJ5S2NER1FwRFdDeEFOQko2Y2JEdWZkN1BwSVFyU09iNTRzQk1n?=
 =?utf-8?B?VmlYRUQwdGtka2NLNWRDOVhId1dLYjM4d0kyWGYyMllCMVZUL2g2VVUzRVFt?=
 =?utf-8?B?NG56TDBVdWhueWZUanZ0cmlad3h1cEZCc0ZDOWwyK0dVV3I4aFNYY293a1pn?=
 =?utf-8?Q?4BSAnYXxhT4rW?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c400d46-7ec7-4b36-dcf7-08d97474d190
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2021 16:05:33.3314
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 58QN90y1o+PcHxaEc74BzhVXvJzFcB/LEHjCOrb/yO3hSmsLhDlQdCiayjnXJ9Mcmh22URrXky3mkMWwmmgKjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4592
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IHdmeCBkcml2ZXIgY2hlY2tzIGNhcmVmdWxseSB0aGUgY29oZXJlbmN5IG9mIG9mIHRoZSBEVElN
Cm5vdGlmaWNhdGlvbnMuIFdlIGhhdmUgbm90aWNlZCBzZXZlcmFsIHRpbWVzIHNvbWUgc21hbGwg
aW5jb25zaXN0ZW5jaWVzCmZyb20gdGhlIGZpcm13YXJlIG9uIHRoZXNlIG5vdGlmaWNhdGlvbi4g
VGhleSBoYXZlIG5ldmVyIGJlZW4gY3JpdGljYWwuCgpIb3dldmVyIG9uIHRoZSBkcml2ZXIgc2lk
ZSB0aGV5IGxlYWQgdG8gYmlnIGZhdCB3YXJuaW5ncy4gV29yc2UsIGlmCnRoZXNlIHdhcm5pbmcg
YXJlIGRpc3BsYXllZCBvbiBVQVJUIGNvbnNvbGUsIHRoZXkgY2FuIGJlIGxvbmcgdG8gZGlzcGxh
eQooc2V2ZXJhbCBodW5kcmVkcyBvZiBtaWxsaXNlY3MpLiBTaW5jZSwgdGhpcyB3YXJuaW5nIGlz
IGdlbmVyYXRlZCBmcm9tIGEKd29yayBxdWV1ZSwgaXQgY2FuIGRlbGF5IGFsbCB0aGUgd29ya3F1
ZXVlIHVzZXJzLiBFc3BlY2lhbGx5LCBpdCBjYW4KZHJhc3RpY2FsbHkgc2xvdyBkb3duIHRoZSBm
cmFtZSBtYW5hZ2VtZW50IG9mIHRoZSBkcml2ZXIgYW5kIHRoZW4KZ2VuZXJhdGUgZXJyb3JzIHRo
YXQgYXJlIHNlcmlvdXMgdGhpcyB0aW1lIChlZy4gYW4gb3ZlcmZsb3cgb2YgdGhlCmluZGljYXRp
b24gcXVldWUgb2YgdGhlIGRldmljZSkuCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxl
ciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9z
dGEuYyB8IDUgKysrLS0KIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDIgZGVsZXRp
b25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYyBiL2RyaXZlcnMv
c3RhZ2luZy93Zngvc3RhLmMKaW5kZXggY2I3ZThhYmRmNDNjLi5hMjM2ZTViYjY5MTQgMTAwNjQ0
Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dm
eC9zdGEuYwpAQCAtNjMxLDggKzYzMSw5IEBAIHZvaWQgd2Z4X3N1c3BlbmRfcmVzdW1lX21jKHN0
cnVjdCB3ZnhfdmlmICp3dmlmLCBlbnVtIHN0YV9ub3RpZnlfY21kIG5vdGlmeV9jbWQpCiB7CiAJ
aWYgKG5vdGlmeV9jbWQgIT0gU1RBX05PVElGWV9BV0FLRSkKIAkJcmV0dXJuOwotCVdBUk4oIXdm
eF90eF9xdWV1ZXNfaGFzX2NhYih3dmlmKSwgImluY29ycmVjdCBzZXF1ZW5jZSIpOwotCVdBUk4o
d3ZpZi0+YWZ0ZXJfZHRpbV90eF9hbGxvd2VkLCAiaW5jb3JyZWN0IHNlcXVlbmNlIik7CisJaWYg
KCF3ZnhfdHhfcXVldWVzX2hhc19jYWIod3ZpZikgfHwgd3ZpZi0+YWZ0ZXJfZHRpbV90eF9hbGxv
d2VkKQorCQlkZXZfd2Fybih3dmlmLT53ZGV2LT5kZXYsICJpbmNvcnJlY3Qgc2VxdWVuY2UgKCVk
IENBQiBpbiBxdWV1ZSkiLAorCQkJIHdmeF90eF9xdWV1ZXNfaGFzX2NhYih3dmlmKSk7CiAJd3Zp
Zi0+YWZ0ZXJfZHRpbV90eF9hbGxvd2VkID0gdHJ1ZTsKIAl3ZnhfYmhfcmVxdWVzdF90eCh3dmlm
LT53ZGV2KTsKIH0KLS0gCjIuMzMuMAoK
