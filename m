Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD6A3406EF7
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 18:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230353AbhIJQJX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 12:09:23 -0400
Received: from mail-mw2nam10on2056.outbound.protection.outlook.com ([40.107.94.56]:59105
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230259AbhIJQIV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Sep 2021 12:08:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jj+KvVsjyXBTfPTVZ6cWqFxrAixWuhnC2j65TxnDpDB/MT7c6NNM68BUhAhL7tIvxm7Gz6NXiC2FeZlUyRLTWq1tdwoCr4NZtGWz0oEz8HsrRMlU4sLhKBIhkdd/40Zxe2WtZdss0KW/0llCT/oUgY36I95k38lgUmYpkMX18jIyNvpKm1BJtyB3n5pOUCKHvMp6rOmNjoN8Wu1CDw1rC3b3AM/a2p+k4EBVN+sGAFXyMYnVJH+BJY0vGDR4E2GjIihjRmq6EgxB7mDYW9x3rm5OEuxLiUSgOoCqyUuJSeYErIKpzokdWWYo4SiYz8zvTPoFm7fkxzlovw6kEfRyeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=irK1qzipT3QHIWJf6rEuMgUX9uURfiAS1g+yt6uFeLc=;
 b=TqbLDIG6rzYx5XHAanvjuc3rPZX2b1pdwgjI+OqB0f48v7mLN2WqLVn84AQh0sEFvQe3pNiWXrG6eNE1WyCrhEam+NYNEI5krej265i7NV389ao1XEGkBWIky/tzZ9u1TcsL/MafNy9NSWmwBdHfbMDdk2ZP/NtCY+MHPTZLS9XHgqXT6pkVSRAqabdR9LMqRKqNEsqxlehIc7tf2SwL35wESSK5dPunaWOsq4gnk87X3CK9N6Wi3ZOH20YlCgnofBzi6FLFSeRzcFbAxdsefrNErZXwv5sx8tyqmMy0ZNwcFYrPFdoPKJrvOwPwIBfx94d7v75ii2Frjj4YF2qF6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=irK1qzipT3QHIWJf6rEuMgUX9uURfiAS1g+yt6uFeLc=;
 b=TjTrz5CVjtnBhSe1q3IYAHYq7WmoQdbeUdUnlel0x3yAKvQLAoxdgoXcKowCiATvMj9nEZDp1ZAWbtejTMSFSYRiXD+cGzmN/uTWRnrYxfnn1h9K8Fi+5A72AubpjTDb+jND4ZEKjar2wJrI5+jqyAMUHoapdHHMNc/xdYtubFI=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB3118.namprd11.prod.outlook.com (2603:10b6:805:dc::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Fri, 10 Sep
 2021 16:05:54 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Fri, 10 Sep 2021
 16:05:54 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 11/31] staging: wfx: relax the PDS existence constraint
Date:   Fri, 10 Sep 2021 18:04:44 +0200
Message-Id: <20210910160504.1794332-12-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210910160504.1794332-1-Jerome.Pouiller@silabs.com>
References: <20210910160504.1794332-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: SN4PR0601CA0006.namprd06.prod.outlook.com
 (2603:10b6:803:2f::16) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (2a01:e34:ecb5:66a0:9876:e1d7:65be:d294) by SN4PR0601CA0006.namprd06.prod.outlook.com (2603:10b6:803:2f::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.15 via Frontend Transport; Fri, 10 Sep 2021 16:05:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2579bc4a-ef9d-4a39-7791-08d97474ddca
X-MS-TrafficTypeDiagnostic: SN6PR11MB3118:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB3118DC36DA1E7F52D7E35B7993D69@SN6PR11MB3118.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6qJLRuUDGoLqK8fkPW3jrNPnyHfBD6B82R3LDP5T8oEbY5lYfzYx1vV6ske0gMP/3cblWG9iV+gbG4oUFiTnh5sWkm7uD55sb7248sQUEa6ijKKp6ePOWeGLgF+ISGy9GE+aQzN8dWaRKGhO/5VFirYztXGYK02QSC7b80JiDAvc4foIU1V7J01FLI1E4Ew536yfCzhlHxaiHA3bZZyOTRvwJ0jg6JpTMOI16mIYXBSd1DHdpsfbI78wXa7Y9AWUet5MGpc/sX+xhle7zkqOPrQfC3G7RDAuhnBSzBso6aeXTQ3NXQTFc5PnShD4CxK2VpWVI12ZgfbxsAdgLMiqYnnoUZTJi+dfhmbTawMR2DinWJ2rd4h9kDGjyzxreMaWm0yDbIBqCW8GuJVs5g1ItW55H8SWCP0QkETz3BhPT9pMAlgIFrbeDFyEV+wSK3Q42ig/VG1Z2UBEy3TpyRt07oooapv3JhCMrgGiBCvL62zBm6KAuZnRoyZTBU2UjzEbfxyraQ0UT+x9nRrVb6/f5Hd20J5rbAKnnkIekLSwwVrBIshCvvpMuXZ74AmMmj4VkKNiuilCErPCVkhAr4HshhTZaNTmpEadzodUlHN7yn3PGsFSxq4cUeiU8l2xPxtN+6SUl09Oolw9JJxvShogHw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(376002)(346002)(39850400004)(396003)(4326008)(66476007)(107886003)(36756003)(186003)(316002)(6486002)(66556008)(8676002)(6666004)(86362001)(2906002)(54906003)(38100700002)(83380400001)(8936002)(66574015)(5660300002)(66946007)(1076003)(2616005)(52116002)(7696005)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bUVtWUtMaXF0R1d4M21iREpWaTgzeUNaYWF1RXZzanZpQ0FKVEIxcWFTMVZu?=
 =?utf-8?B?dDhzYW5ZeEJ2b0pWSER0d1FwQjRmd0Q4ZkdZbXcySVlEc01jYnJvcnVxT0tH?=
 =?utf-8?B?NVFiMlZyWmdzQkVOS1JPK3dUU1NvSkhRbkV2TDR1MjAwdHVGZVZWWnlqYWw3?=
 =?utf-8?B?eWw3SXBHdlovZ2F5RzhuS0p4UUQrYjI0ZmJDcGxmVVVNS29NU05KRFNWYzVu?=
 =?utf-8?B?K2R4eXMySkhOR3lnYXlWMDRILyszREgwaWR6N29PNUZLbWhYMXFjRFlGY1lV?=
 =?utf-8?B?cUU5NHI0Y0F1YkFHYTNONHBuTUtVTHB4K1NPT2w3LzRuMXVxRm55Ulhrbk5k?=
 =?utf-8?B?QUFxZTh3ODN1RDJialhkL3BxUU44eERmdlllbUZFM3JSTW8yYTE5S0lhZzln?=
 =?utf-8?B?WVpjRFA5bkZYOXVFZVJZMHg1UkVjSC9CdkhxTXIrMkwva2hpQmJwUkJUY2Yv?=
 =?utf-8?B?QUhON2I2K1gwSUlUZWkxNmxtOXlraDF0VDhpK1RZZUdSSlFiakdMdjk0VGlV?=
 =?utf-8?B?NWpsRzgwczJRYktVVDNlSUZSSFBUeWx3WElPMnJIZVEwVEROWlVFVkZSemZ2?=
 =?utf-8?B?NUR2WE44TFNzb1lMbTFqZmFjL0QzL2FGTUVrWko0MlkxODRIMEhEbU9CVkcw?=
 =?utf-8?B?NTYxS1laU3JYOWxtRUlQZDNJb2FiY2Rva1ZOaFl5RmxkWnBPeXl2bnVhRHp0?=
 =?utf-8?B?WEF3QXFLYnIvMzFWbW53Ui9DQVFreG5kLy9oZExXejVFKzJQVFhucTdmcC9h?=
 =?utf-8?B?UDdvbXRDdGVkaDJHN2VIRmdZcFhaNnpIU0RleFM1R2djK2FoN1hPSmt3OGZ0?=
 =?utf-8?B?dWhxTXEyRUY3RFZuSzN1QzBnQld5ZGFHYVAxd2MvKyttbnIyQm1oaWlwTEds?=
 =?utf-8?B?b0IvN3BGSkNuVU5rTytYSFBacWJ2VkxGMkk1RHdYNEp3MHJDbUgzYjlONnZi?=
 =?utf-8?B?YnUvSHozNXhWT3QwTjRIdTNpek03c0ZYM0ZUV1d3QlNFVDlEVklmT1FBcnZ2?=
 =?utf-8?B?WHB4SkVOZC9sTnFGK0J6dFZFYVhyT0NCU2Z5OTJIcTNWVXc0ek1tVDJmc1gr?=
 =?utf-8?B?SmMxYU5pdjNEV2R1U1pPWjh1YzlnQVRLNmpJV0dOWExTQytLd3RzQis2MUkw?=
 =?utf-8?B?djRURjJ2dXRyV1lzZUxHVjFJQlRoS2tPU200VWs4a2JHNHdxU0JIbHJHWkdT?=
 =?utf-8?B?VDJRS0RuMmhJUklWaWViK2RjUUc2Qmo0Mk5tUlJDTVBhenVmT1JZZERrQThm?=
 =?utf-8?B?RG9Nd3RpZXVjREpUYkFqMFQvYTBhcUdGZmlqMGRGTWhyeGtDU2w5WEQrTklN?=
 =?utf-8?B?a0NDSVlmZFprTVJOMndvdGxzS05CV3dheVRMOUlveFVjcGI0UGwzUFI0cVdw?=
 =?utf-8?B?ZjQrQzU1ZzBGS05TT0ZkSm9QNC9nV3lXYmhlbmllNGdHRlRtbGtXbktVaFgr?=
 =?utf-8?B?THNxVzlZVDZycXBnVk5mblpYVVhpTjFEajNZTlhzZzJYdHovWVJESzE3RnZl?=
 =?utf-8?B?VGd0QTJrK3FmMXdtOHNnMjZ6MWF6T3c5OTMzWlQrNzlSeUJQZjRwQk5mTEJm?=
 =?utf-8?B?UlFjKzZmd0E0VkE2Wkh2eDhnS29uWW01dGE4bGErc0N3aEt1RnhrUEFjb0My?=
 =?utf-8?B?ZkFId2VoS2lONTBHaXExQlMxemM3bTk0bEpVcGtjK3NYSmFuR0N0TmVIbHlZ?=
 =?utf-8?B?M2t1VkhFZnh3MkdWcFdXVWU2YjFDNlRCeUZFM2xYTjRZOW9KYXp0Mko1cTAy?=
 =?utf-8?B?OXlTb25wNWZjOUJZck5EejIyaVBnZU55dHFDWGc4NDhOMHBRMy9SQVJYZHAy?=
 =?utf-8?B?S2xuUjhrQVFVaEFTYkJVZmtGUnh5Ui9ncHFEKzYxNXhSM1BqejlKejhQbHBR?=
 =?utf-8?Q?N8JNp1qRkUq5R?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2579bc4a-ef9d-4a39-7791-08d97474ddca
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2021 16:05:53.9035
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KnuyreqUmevajPS8eNekTSpUaOH4nw0FFROJ0NuOmYdW+isAuJwmod4nC3BBRAdSliPn0zGFfrDCWqZuf296HA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3118
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IFBEUyBmaWxlIGNvbnRhaW5zIGFudGVubmEgcGFyYW1ldGVycy4gVGhlIGZpbGUgaXMgc3BlY2lm
aWMgdG8gZWFjaApoYXJkd2FyZSBkZXNpZ24uIE5vcm1hbGx5LCB0aGUgYm9hcmQgZGVzaWduZXIg
c2hvdWxkIGFkZCBhIGxpbmUgaW4gdGhlCm9mX2RldmljZV9pZCB0YWJsZSB3aXRoIGhpcyBvd24g
YW50ZW5uYSBwYXJhbWV0ZXJzLgoKVW50aWwsIG5vdyB0aGUgYWJzZW5jZSBvZiBQRFMgZmlsZSBp
cyBhIGhhcmQgZmF0YWwgZXJyb3IuIEhvd2V2ZXIsCmR1cmluZyB0aGUgZGV2ZWxvcG1lbnQsIGlu
IG1vc3Qgb2YgdGhlIGNhc2VzLCBhbiBlbXB0eSBQRFMgZmlsZSBpcwpzdWZmaWNpZW50IHRvIHN0
YXJ0IFdpRmkgY29tbXVuaWNhdGlvbi4KClRoaXMgcGF0Y2gga2VlcCBhbiBlcnJvciwgYnV0IGFs
bG93IHRoZSB1c2VyIHRvIHBsYXkgd2l0aCB0aGUgZGV2aWNlLgoKU2lnbmVkLW9mZi1ieTogSsOp
csO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMv
c3RhZ2luZy93ZngvbWFpbi5jIHwgNiArKy0tLS0KIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlv
bnMoKyksIDQgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9t
YWluLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L21haW4uYwppbmRleCAwYTlkMDJkMWFmMmYuLmI3
OTBkODU3M2RlNiAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9tYWluLmMKKysrIGIv
ZHJpdmVycy9zdGFnaW5nL3dmeC9tYWluLmMKQEAgLTIyMCw3ICsyMjAsNyBAQCBzdGF0aWMgaW50
IHdmeF9zZW5kX3BkYXRhX3BkcyhzdHJ1Y3Qgd2Z4X2RldiAqd2RldikKIAogCXJldCA9IHJlcXVl
c3RfZmlybXdhcmUoJnBkcywgd2Rldi0+cGRhdGEuZmlsZV9wZHMsIHdkZXYtPmRldik7CiAJaWYg
KHJldCkgewotCQlkZXZfZXJyKHdkZXYtPmRldiwgImNhbid0IGxvYWQgUERTIGZpbGUgJXNcbiIs
CisJCWRldl9lcnIod2Rldi0+ZGV2LCAiY2FuJ3QgbG9hZCBhbnRlbm5hIHBhcmFtZXRlcnMgKFBE
UyBmaWxlICVzKS4gVGhlIGRldmljZSBtYXkgYmUgdW5zdGFibGUuXG4iLAogCQkJd2Rldi0+cGRh
dGEuZmlsZV9wZHMpOwogCQlnb3RvIGVycjE7CiAJfQpAQCAtMzk1LDkgKzM5NSw3IEBAIGludCB3
ZnhfcHJvYmUoc3RydWN0IHdmeF9kZXYgKndkZXYpCiAKIAlkZXZfZGJnKHdkZXYtPmRldiwgInNl
bmRpbmcgY29uZmlndXJhdGlvbiBmaWxlICVzXG4iLAogCQl3ZGV2LT5wZGF0YS5maWxlX3Bkcyk7
Ci0JZXJyID0gd2Z4X3NlbmRfcGRhdGFfcGRzKHdkZXYpOwotCWlmIChlcnIgPCAwKQotCQlnb3Rv
IGVycjA7CisJd2Z4X3NlbmRfcGRhdGFfcGRzKHdkZXYpOwogCiAJd2Rldi0+cG9sbF9pcnEgPSBm
YWxzZTsKIAllcnIgPSB3ZGV2LT5od2J1c19vcHMtPmlycV9zdWJzY3JpYmUod2Rldi0+aHdidXNf
cHJpdik7Ci0tIAoyLjMzLjAKCg==
