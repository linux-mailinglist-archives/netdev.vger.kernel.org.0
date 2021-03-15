Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CC5A33B3DB
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 14:26:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbhCONZl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 09:25:41 -0400
Received: from mail-mw2nam10on2055.outbound.protection.outlook.com ([40.107.94.55]:40192
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229681AbhCONZ0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 09:25:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mKCu+4cy4YL9wWR/kuI0gCmc6GlIFpMN8XsjBl3Z4dhlLWXBVr/2O/iBilGT8mScPR5UQ+hEJ6KmF0vT9iGW/XfXFFLPkSMxshSd+UkmSjFEg4d4ooecO7q3HvA6zFk8EM1PVy0PhRvVy14VBCeJ3ZcG7dUypNOWzWgvEC74DOOFQRt4O4E+7UjbK2YHGS6MAQcpZDfB5qQZ8SZwCxpdd3DBXP6bnnEJwK6yNNLEnOki+mV4ajn5RexSbejqjI0ZpJKVEVZztr8NPY2q1Pq2vbtG2+JfFEDOB+j+sylJWw+eAFs3yQuTBN1yt6MAADIAn9Q0MM1YPqzRzypH301Nsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nV3jltoOon206S1xr98YuiDX9F2vm9+bMCiJ3DHCI7U=;
 b=Nx4uYr6EWn3G6OLVD+JBEm+oMpWz5qGAUkYPq2oHJVyczajU5+nOpFaspsCL5cY1w0MBugaTV38sdrur+18F/drI2YFEwdsZL9uRWQl5GqHruQqDhEattV8jk+P9jFsZnL7Eh34T/M3KM5Q3AzBbqhyxVVPsxyw2fPrUjYXSOZC2uAffoevjvUaITJPPgX7q/bWMNnwUNJaGBi/lveUcWTJpIeC6jQMxjGtetapMF6vDRqZAL7U3Eo1RRMLpHqKdi9xz+tMgBPB+RnC9LnbcFL5eAjDPPavrdd0Ap623uKJ2M1EygblkDa78Nm4Z2Yyr+/w8YaMylWVYhW6AIiIWHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nV3jltoOon206S1xr98YuiDX9F2vm9+bMCiJ3DHCI7U=;
 b=W1LEzCHa6qtQK214WVhtfnsyAvpcACTeNEdRVQbl/fqJY2K2fRqV74S144elx8QdoGe3UoRjkxW37N/VT6XkMj8YsTFs+JpemzOYjaRJfz0N0c46gSzVkMykyHiLave2MP0XWzTHKnBIVvlxFnThhZJ3Pxn9UievpaoRsv5QHgQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA2PR11MB5099.namprd11.prod.outlook.com (2603:10b6:806:f9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Mon, 15 Mar
 2021 13:25:25 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::41bc:5ce:dfa0:9701]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::41bc:5ce:dfa0:9701%7]) with mapi id 15.20.3933.032; Mon, 15 Mar 2021
 13:25:25 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-mmc@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v5 01/24] mmc: sdio: add SDIO IDs for Silabs WF200 chip
Date:   Mon, 15 Mar 2021 14:24:38 +0100
Message-Id: <20210315132501.441681-2-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315132501.441681-1-Jerome.Pouiller@silabs.com>
References: <20210315132501.441681-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Originating-IP: [2a01:e35:2435:66a0:544b:f17b:7ae8:fb7]
X-ClientProxiedBy: SN4PR0801CA0014.namprd08.prod.outlook.com
 (2603:10b6:803:29::24) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:544b:f17b:7ae8:fb7) by SN4PR0801CA0014.namprd08.prod.outlook.com (2603:10b6:803:29::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32 via Frontend Transport; Mon, 15 Mar 2021 13:25:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4d221047-6ab2-4f7f-78af-08d8e7b5caad
X-MS-TrafficTypeDiagnostic: SA2PR11MB5099:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA2PR11MB509962C4346A9BB8493BE0BB936C9@SA2PR11MB5099.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vZJegVMugcXRBK0Gvcn0yu/ij3axBUL6JUU1ElUDPFHpzGISNnqyrA3y1znLjueAFrYCgKofWbm7NmW6zSUczRUrWsHcVvBQcJsIQGur6lPjUxR4X/LNhzy5SfpNqQdgJbHQJhwLrJyHOjS1/MBRrMBt5OX9wL7We07j6XQRlkFvfiRBDNi+rp1pxMOvjfvLpos4OvLAr4THrQHWmy5cRUy0V+EGGmeaQAQWDW91N0LclB4nDuPt9WGZJ2ZoZkpdY5v3pvEHwPXwqskqjMT6LDifcc6wPPXo3y72XLu8I3Rlxa81ktRwSCa2dI3JHbdAQNejkJWonnajyuIVKyDo1RfrmC2NkvcU5yO8Vu2YdrxDLwbsDH64IVR7yqD66BztQ+TUY/lgnzxcp2ue+OVKqYnAbMEimXyx4YZvdO3tBIqUcAFHeVCYGiFBVBlwTZSVIpb6VE+zVNNk9PDMqzpzfSmCz0SdzzPGGwzTtmaDIf16kHNoMJo/2FEJqshsiODZAxITnr+2naby/JShhnX+LUtfHHWm99/kt/5I7GHnhJdZWK1pekGLs+RmlAnRGN1i
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(396003)(39850400004)(376002)(366004)(186003)(7416002)(2616005)(107886003)(4326008)(478600001)(16526019)(66476007)(86362001)(66946007)(54906003)(66556008)(4744005)(8936002)(316002)(5660300002)(8676002)(1076003)(52116002)(7696005)(6666004)(36756003)(2906002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UGJxK3M5YURWdXdNbnA0ajdkUEQvZ1VKU3R3RG5YMk04UVdId0dXeDRkVFhU?=
 =?utf-8?B?bDBEU2RBWmtMTjZ2d25mOFR2TnVwVzcycFoxdXgvS3JaZGIzSGpES0lHdSs5?=
 =?utf-8?B?MkJIM0FsblN5WHFTdzVJV3VHZW9uclZsVXZjaHJpTmhFRXJIWEhXN1EyN01G?=
 =?utf-8?B?d2lMUEpUZHN4a1pETEJkek56TGRvVkhLWEZ6ekplTzM4eTFQUm1YbTRoUUNS?=
 =?utf-8?B?WFRTdWlNRjFQbG56WVZoMExyb0VSSXB0Z3o5eE5HRXFlMEhmWWdEOEd3K1lq?=
 =?utf-8?B?UTZrQmczRVdiNTQ4d1hPS0dkTGF5UW52MzNUeFhCVWxsZ1k1YWRJSHJEOVMr?=
 =?utf-8?B?d20rZi9CUUh3MG1mUzVsUEd3aVRCVS9udlRUU1R0M1pua3JRMDBjRUlBbE9p?=
 =?utf-8?B?VEh5d3F1ZmJ3SW5mOGhvSVZvN1FaQ0FJUTZ4NWJ0ZENjcjVtb3BHSEN0WWRQ?=
 =?utf-8?B?VUcrUVAvdklkMGRlK1BLSHUwNFpzUFpKOUNFeEdjSGNQdTlSVEwrTWdHOWlw?=
 =?utf-8?B?VHJqa2QzVkVEajNlMmExcCtqa0s4YXdMajB1MzRYOCtYaDFsam81YmpNTWZ4?=
 =?utf-8?B?QjZkNEl2NW5aZDhpeWdOTmdZeU9FYlNRemNKV0hMam5ydU80NTU0a21oN1FY?=
 =?utf-8?B?Wm8yMUovVW95TkdDOEU0NUlack9YWDNNZlN1YjRIc3RyZmdRcm9MeEtlNFhy?=
 =?utf-8?B?aE8rWndmUWFzRXV5bVcyR3VUb0NpYWVEQ08vZC9IbFlXeEloaDRrc2VvZ2Nr?=
 =?utf-8?B?RUpHUWNIMmZFMkliQ0RRQ3lkMmNOdi9aa0dpQzdUd09XTmNoUEx5NndWNHBM?=
 =?utf-8?B?eUttUDBwdVYrUFc1cFZ0Y3ozcnFPZjhZbUhlYk94OEZlWS9JTDhKZEREazUw?=
 =?utf-8?B?dWttNXJEeUQ3a29VWUhid2s3RVVEd2c0NWQyVWpHSE1nZ0huOGNqclQvUFVH?=
 =?utf-8?B?YXc0S0FqUlBNdUk5UGhyMXhZTHJaZ2tBMmZUN1NFVjVITVJTTnRKVndOTytz?=
 =?utf-8?B?ODdLRGttQzlyV0hLVVprSS9Eb25DM0ZwOXFzZ1c4UGNFbVhVbmY5SVdLVzVT?=
 =?utf-8?B?QWRJcU5NRnZteVU3dXF2eVEwUDVzSTVGSVl6MlRPR2s5emF1Sm1peE8yaXhV?=
 =?utf-8?B?alkrYkp4eWw4d244WjlzUjF4azI2N2h0SXRWWC9IRE02b0ZVUzVTQTNSVjNw?=
 =?utf-8?B?dFQ4R3lRTGRZNjVwd1cvaW1EWEYvUW1WeTRZZEptT094cERhbVo2UllEcWU3?=
 =?utf-8?B?VHAvc3lGSHExUEhBNFcybUhhZWpENERLcGhsNTQyQ1NvcDl6VytzR3FvUC96?=
 =?utf-8?B?bDFueU9mQ2FQL25iT1o2MU05U2U2RHFoekcxNVNmSFpuc2hjd1lUK2FyMkJO?=
 =?utf-8?B?WnVUTjBsaWxld2dYQTNRaTVqQks3ZGx4Uy92WGlXUHhzaXZCakliRUR4cHZn?=
 =?utf-8?B?R0NCNWN2ZUF0RnpGRFBhR3dnQkpQdVAxRlJrRThab24xNGZHalYwQ3Mwd0Zm?=
 =?utf-8?B?Y2ZDcG9KblgyUHBzdVF5VmRoVTAwOUxBTTgxV0Qvc3V6SGdoWncxSnZ3ak9t?=
 =?utf-8?B?SnlIU01DZ2ZzbTd5c2hYc3VEaXBwZzIwOWZaekhnNlN0OUUzRFd6V05XMlFa?=
 =?utf-8?B?VkZnL2wwdEJQOElZSy9tcEpOOER1Q3laWlpVamhodDlsRUFlUG50bCtkOE5J?=
 =?utf-8?B?Z0EvU0xQYTFZa01Bampicm5zdjZRZWh0TEtrM1luWmZuNm1EMFE4Mm5hU0p5?=
 =?utf-8?B?a1h1Ymx6ZVFHYzZzbzR1OWVvbEFveUFxYjArMjV3MWlNS0FlNFRFb0pJSWU3?=
 =?utf-8?B?V3QySWkySktwSEZZQ3J5Q2hOL1hZUUg0bjRNaU0vVElUZTZNL2lURUp2N0pI?=
 =?utf-8?Q?CGGHEXzZZfwBC?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d221047-6ab2-4f7f-78af-08d8e7b5caad
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2021 13:25:25.0816
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1/0GnTfVN5P0DoYkYmLWjKQa17QvmxltPr6F471GL1Ckd1A1jYrrLtpUQd7Ct+kv+VoDsVb/ltTWyNV9mowm4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5099
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKQWRk
IFNpbGFicyBTRElPIElEIHRvIHNkaW9faWRzLmguCgpOb3RlIHRoYXQgdGhlIHZhbHVlcyB1c2Vk
IGJ5IFNpbGFicyBhcmUgdW5jb21tb24uIEEgZHJpdmVyIGNhbm5vdCBmdWxseQpyZWx5IG9uIHRo
ZSBTRElPIFBuUC4gSXQgc2hvdWxkIGFsc28gY2hlY2sgaWYgdGhlIGRldmljZSBpcyBkZWNsYXJl
ZCBpbgp0aGUgRFQuCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBv
dWlsbGVyQHNpbGFicy5jb20+Ci0tLQogaW5jbHVkZS9saW51eC9tbWMvc2Rpb19pZHMuaCB8IDcg
KysrKysrKwogMSBmaWxlIGNoYW5nZWQsIDcgaW5zZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBhL2lu
Y2x1ZGUvbGludXgvbW1jL3NkaW9faWRzLmggYi9pbmNsdWRlL2xpbnV4L21tYy9zZGlvX2lkcy5o
CmluZGV4IDEyMDM2NjE5MzQ2Yy4uNzM0OTE4ZmJmMTY0IDEwMDY0NAotLS0gYS9pbmNsdWRlL2xp
bnV4L21tYy9zZGlvX2lkcy5oCisrKyBiL2luY2x1ZGUvbGludXgvbW1jL3NkaW9faWRzLmgKQEAg
LTI1LDYgKzI1LDEzIEBACiAgKiBWZW5kb3JzIGFuZCBkZXZpY2VzLiAgU29ydCBrZXk6IHZlbmRv
ciBmaXJzdCwgZGV2aWNlIG5leHQuCiAgKi8KIAorLyoKKyAqIFNpbGFicyBkb2VzIG5vdCB1c2Ug
YSByZWxpYWJsZSB2ZW5kb3IgSUQuIFRvIGF2b2lkIGNvbmZsaWN0cywgdGhlIGRyaXZlcgorICog
d29uJ3QgcHJvYmUgdGhlIGRldmljZSBpZiBpdCBpcyBub3QgYWxzbyBkZWNsYXJlZCBpbiB0aGUg
RFQuCisgKi8KKyNkZWZpbmUgU0RJT19WRU5ET1JfSURfU0lMQUJTCQkJMHgwMDAwCisjZGVmaW5l
IFNESU9fREVWSUNFX0lEX1NJTEFCU19XRjIwMAkJMHgxMDAwCisKICNkZWZpbmUgU0RJT19WRU5E
T1JfSURfU1RFCQkJMHgwMDIwCiAjZGVmaW5lIFNESU9fREVWSUNFX0lEX1NURV9DVzEyMDAJCTB4
MjI4MAogCi0tIAoyLjMwLjIKCg==
