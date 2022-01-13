Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64C2448D491
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 10:49:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233608AbiAMI6y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 03:58:54 -0500
Received: from mail-dm6nam11on2067.outbound.protection.outlook.com ([40.107.223.67]:58624
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233316AbiAMI6N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jan 2022 03:58:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HzHHX0TBdlgcBX5pY0upSTyWx9O6U44IeQGrIY8cUYgizpDbWrWfOV2j9YMWWQ388u4cQ3bhJVmr0f1Ge3whzD4fZr8BJYX66otC9txV/ZP8ty4NL1Nxl5DWxfkIqqTHrHfE88jpoX9ItzgfC95KPwXGCypO8vA43McNRgPg1KQ4CNi4f+xvR4H5TmoKwp0PgP9xAoctxBw5VaSyg/TPsOLvGFzbh/cDlkS2gZbCt7ZAbBTi5BlyVorJJnDkizVtopPPmZqhxOkXOuKu9WXRA2l7irrpqctCSV5X0V8jdHzDMM4iwrwL48s3VlJ+PgVddfQM/aE8EQzTh0BJ54ZvfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1aK6ov8zRbVG8S/MtvHDM7CeICXT7XcnjPMy+BeWdfc=;
 b=Yanhdu8j9v3YBSxbXohpaUMiu67Fag4PwvC7X6Kemt812mhOX6K8z1TtNy5h5dDP1d5mGrSfAhREZXlBFNRzLp1qPVfJfsYVVqv/AsAD1XBTmjY3tc4GzHVeA9Unb+HPcaKLwtXUDbJ5k6fpTfe1U3723xxeTUSpc0V3NwtMI7nqIS4sm4bPr9QanDRAVjptAiHCLuQww0lWjUqjhD91NS/rOCx4j2B/kVv7X4WIs0y1mmP4RtExy295p1Wj2oHzYLCWMi6y7c198efO1zHjWLLm9xURJKDPwTGhrNcZHcxjuzIEeDecHcu2UsS7Xecxl+1XqHvi/gciFbRhC9OJ8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1aK6ov8zRbVG8S/MtvHDM7CeICXT7XcnjPMy+BeWdfc=;
 b=KmCW71rWmEs5vjH5hcg27mIuBwUuIXrdZ7jf9RiHhJNHZyC7VGQ1Xpf691n5O6ScEeWJ8jJPo83IZmi7efHuDVDjnKEvm0RyEEH+wuFDrpZom7g3OUsZNHk/0Jl3y1Hda82syLAy3OfLkc04gbjI28ijpJFQW456I4MgdWN9Y2Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by CY4PR1101MB2071.namprd11.prod.outlook.com (2603:10b6:910:1a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Thu, 13 Jan
 2022 08:56:34 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::d031:da9e:71a:73e4]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::d031:da9e:71a:73e4%5]) with mapi id 15.20.4888.011; Thu, 13 Jan 2022
 08:56:34 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 28/31] staging: wfx: fix firmware location
Date:   Thu, 13 Jan 2022 09:55:21 +0100
Message-Id: <20220113085524.1110708-29-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220113085524.1110708-1-Jerome.Pouiller@silabs.com>
References: <20220113085524.1110708-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: SA0PR11CA0117.namprd11.prod.outlook.com
 (2603:10b6:806:d1::32) To PH0PR11MB5657.namprd11.prod.outlook.com
 (2603:10b6:510:ee::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d4e8539d-cd57-4abe-b40e-08d9d67299a8
X-MS-TrafficTypeDiagnostic: CY4PR1101MB2071:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1101MB20717D331620A95425F5BD6E93539@CY4PR1101MB2071.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t8jgKQIQxM69nJSHVx7+rtasFF+rzAmx47gj1JQSqj0ku9/qYPuKOPNA8qEMD7dPeU8U9aAekmV0NLysOgOIiOxXTGar/5pwKvs2IuzuhH4XgtApSHqnf98xgok+TbriGcj53Kl5R/yoXC+5zejteMIZQ50pIeEsrfZkGT++oaYciqSkWCqXsUC6kCQIlTuXdmHDregKRVwB/IuKkzfU7nc3MBDe1hjY9GKIShI6nnpNUhIWGoPEni9CFCcQNhwzZqEGbEqx79Vk1qBZYsNzfNinXGEj8ZmZi4PJb8mqPjTxhWV/rKoGamT9xfHOULGRa1cubi4X053qfAUf/2ZRG0CNWH6R1HzX/SO8hrMudpln8UxhZJVkdhTqvUWpbgkLfwHaKifOrtWzBHjgB938jNDPFkxRu5wMqM9tbqPRnJIIt/LtH9IzD3OuTllDAqyPSGFKo3VKm+V/WiI5Nmuosf60Ja9Z95FVnriv74mfsCkDeCoZltnO4zEv8q0LSAhL2YwDLTFA5gqPUDJW8GAYYgGu2Nwsoe2USz+CsOx/pXWYtgqa9rFf7t5vOpJNIYzKTmA2TuONc1hJZ/pwMJKe6eiaT33q02D2cC2cZ42L2SqzesP9VVwCq/soIkBy4X6yZamofItrG6y/0R/TNuJwKA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2616005)(66476007)(52116002)(8676002)(6486002)(4326008)(38100700002)(8936002)(83380400001)(6506007)(107886003)(66556008)(6666004)(36756003)(508600001)(2906002)(5660300002)(6512007)(1076003)(86362001)(186003)(316002)(66946007)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bm83Zm9FQWVOM3VwZk9qZUxVVmNKUDU0SVk2WVhnSitlMk9iTVdpd3pBenJP?=
 =?utf-8?B?OVd5aHd4ZGtOdWFTamovanpaYkpUNkc5ampPVng2dm51OTdvUlg2TmNFZjlL?=
 =?utf-8?B?ZTEweUM3WjVXdC9LSnc1dXY0NjAzb0JBdGE5MEZDRjFhS2tscnVGRzNMdCtN?=
 =?utf-8?B?d3VGQkdua3JmQmtCcTRvNW5qUndURk5FcjJENlFWV3RWczBsK3A1b1JOYzcx?=
 =?utf-8?B?QlBhZTBITU52WlV3VWxGTmU2Vm5rRVBTaVBxUlJkNTZ5ekFzdjdOclIwM2xy?=
 =?utf-8?B?dXdISmtrR1J4b2xqVU5yMDM1TG55ZmZHbWxENzFhRWhpWElpTjkwZ0oyeTBv?=
 =?utf-8?B?VG1NWU43YWtUcmU2bHBqbTc3OUdxVTVmTDNUV0RVT0pBUCs3WDBJaHZJbmxQ?=
 =?utf-8?B?VGhHN3lmWjFrOWhsZm5JZnYrRHNNOWZyQVpTVDlOU0VqRWl1YVdKZ2tXY0FH?=
 =?utf-8?B?dFpzV0NMNWRQdlZ5OEZrU3NZaHBkY1dhVk1MK2x2NHBJNko0OTh1dDNGYjYv?=
 =?utf-8?B?dkhMelBVOVROV0s5bWJ6MW1iejJLYkZCa28zamtqMUZ4SGpwRmg0aG5DSnl6?=
 =?utf-8?B?bTlBYThaWDlPSDB6a1pyMUNUcGVzVThIdzRoODhabVUyUk1ERndxelVJb0NS?=
 =?utf-8?B?Q3pMOXlHeFFZV2t4Qy9hakFDRWFjL01LVlFxK1MzcGtpRVYzbVFPSzJVZWV3?=
 =?utf-8?B?d2JDSmdSK1UvZ0dzcDNwQ21DQUtvODlRL2Vrc0xVYnhNeFR0ZTY4TlhiQ3ZG?=
 =?utf-8?B?cWhBWnJYbDB1aitBK0hObDN5MUlTSit4WGh4VjRKdGllY3B0eklUTTZvYmtk?=
 =?utf-8?B?WHBNWGlQcG9oZzJPUUVha0hWRTJqRWJhVkVNZitKVThRM1J3VGZUQlhucXFo?=
 =?utf-8?B?enV3T2J0eEtqQjhHaytvdHhXaHJ2N1o2aGt3RG42bUIxdkEvZ0svNG5aa3ha?=
 =?utf-8?B?MFk3K00xVnF6RlZPbHdLd1dnbXRBbkMxNUNsUExXQTdMV2NabE42TlB5aTlM?=
 =?utf-8?B?bkMwUkJoUzY3VTlqbyswK09tVWxiSDNaK01wcVBiMlVzTHBIajZWSWRrT2Vy?=
 =?utf-8?B?S3hCY3Z4MHJoc1pHUWNvc1YyelVneDdLYVd3ZHR6TU9LYW5TYWpEeUVxOXU5?=
 =?utf-8?B?Y3dIaUFYVlRyTFBJb1ZIYWNVSDJLZlFSUnI2aTNDbkIxMGhLNkJmU2xheEZj?=
 =?utf-8?B?Q1F5UHA4SWkzQktIUnBSb2RJNExNR2ZjV2g5djUwOGdPQWkvSjN0Y25qWHdo?=
 =?utf-8?B?QXhIMktINDVXS1ZqeE0xaThhVE5NMkhIWVFWMUg3SFBycXRPMlhLV0xYZlJV?=
 =?utf-8?B?bmMwemZ5Y2poUmJTeURNR2s2QnlYeDU5dzNTTWM1Sk1kWkZ4ZUwxMnpndTlr?=
 =?utf-8?B?elNjTlB1ZEpHNGh2eHRnRWZ3YTV2V3lzMzZsajM5eElpNDlSeEFidkcvb1d3?=
 =?utf-8?B?M1E5S0hNZ0huOHZxa3F6SVIxa2FUTWdjV29RTlQxaWxwSnBCUU1QVGRiS29B?=
 =?utf-8?B?bFkwVzBiYkdsbmJCR2R6ampEeGZRdjllK04vSS85QUFzcVVYajFpamNFSUJY?=
 =?utf-8?B?MG1xVXNURm9ob2c5cW9IRlVUWEQ3b1pJd0djcmRkVjl1S21CU2JnTVdkWE1n?=
 =?utf-8?B?dU9zWkxkSmxPRFRLV2h6Z0h3RlVjRDJvOEZhWXRzNzZkNy9LU2JTZXM4UnFD?=
 =?utf-8?B?b0VTTkNrand2WkJIMzRaeXAzRWNzSXZQeXBrNXllRGRDVkhsYWlqTE1kWno5?=
 =?utf-8?B?L2REeDRWdkMwbGxqTll6aEVZQ1hvTjVSTVh0ZENqWlUzRlEzazJKbERPODlu?=
 =?utf-8?B?bm9acXZTTUxZb1Nma21mbDFqQkYwSzd0eW9pSnNEb3Zva08xWURGREx0TFE5?=
 =?utf-8?B?dTlaTjVtOVZ6bjVuaFVqU2x2WWtxNWVXc0Vuc3Y4SWY4ZmlnZXRHeHhncTZq?=
 =?utf-8?B?MzlwNnVIQ3BmNmRpaGpjQzFlSE96djBrQ1lMWWVpb0IwY0lYR1lCTE01YWZi?=
 =?utf-8?B?RmI0alRWRjN1VUdTNFk5UmduNnhTb25yT25odDFIV1I3YzdOQW9GcnVYZHc0?=
 =?utf-8?B?NUw5d2wrN29xSUk4cERPNVlvN1VaY2wzdkllcmNocEtkNm1JVDJjVDV0MXky?=
 =?utf-8?B?bkVUNlJKWGovanVWUjE1SDRQTWgrMFJFTWJyTll0SUNEZ1k5clcraG85bjdL?=
 =?utf-8?B?ZzJpc1RiUi9EKzRQZ0N1STIxbmNpTkc1UThkWXJycGhhbWxXdHc1R2VIME54?=
 =?utf-8?Q?ELAVdc/FmelfpEAzZFiHvgU5WgudB14mXBaLKWuxLg=3D?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4e8539d-cd57-4abe-b40e-08d9d67299a8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2022 08:56:34.8314
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AbSBovG3m7O58PVDX0MS0ZnxqRfwN90SyeEQVCotrNsWSm1prga6u0u5/HY4j5GL7Kyc2fJqK/FdAFLojLpJmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1101MB2071
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
cmUgaXMgY3VycmVudGx5LCBhIG1pc21hdGNoIGJldHdlZW4gdGhlIGxvY2F0aW9uIG9mIHRoZSBm
aXJtd2FyZSBpbgpsaW51eC1maXJtd2FyZSBhbmQgdGhlIHBhdGggd3JpdHRlbiBpbiB0aGUgZHJp
dmVyLgoKV2UgdGFrZSB0aGlzIG9wcG9ydHVuaXR5IHRvIHJlbG9jYXRlIHRoZSBXRjIwMCBmaXJt
d2FyZSBpbiB3ZngvIGluc3RlYWQKb2Ygc2lsYWJzLy4KClNpZ25lZC1vZmYtYnk6IErDqXLDtG1l
IFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdp
bmcvd2Z4L2J1c19zZGlvLmMgfCAxNiArKysrKysrKy0tLS0tLS0tCiBkcml2ZXJzL3N0YWdpbmcv
d2Z4L2J1c19zcGkuYyAgfCAxNiArKysrKysrKy0tLS0tLS0tCiAyIGZpbGVzIGNoYW5nZWQsIDE2
IGluc2VydGlvbnMoKyksIDE2IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3Rh
Z2luZy93ZngvYnVzX3NkaW8uYyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvYnVzX3NkaW8uYwppbmRl
eCAzNjE1ODU3NjNmMzAuLjZlYWQ2OTU3Yjc1MSAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5n
L3dmeC9idXNfc2Rpby5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvYnVzX3NkaW8uYwpAQCAt
MjIsMjMgKzIyLDIzIEBACiAjaW5jbHVkZSAiYmguaCIKIAogc3RhdGljIGNvbnN0IHN0cnVjdCB3
ZnhfcGxhdGZvcm1fZGF0YSBwZGF0YV93ZjIwMCA9IHsKLQkuZmlsZV9mdyA9ICJ3Zm1fd2YyMDAi
LAotCS5maWxlX3BkcyA9ICJ3ZjIwMC5wZHMiLAorCS5maWxlX2Z3ID0gIndmeC93Zm1fd2YyMDAi
LAorCS5maWxlX3BkcyA9ICJ3Zngvd2YyMDAucGRzIiwKIH07CiAKIHN0YXRpYyBjb25zdCBzdHJ1
Y3Qgd2Z4X3BsYXRmb3JtX2RhdGEgcGRhdGFfYnJkNDAwMWEgPSB7Ci0JLmZpbGVfZncgPSAid2Zt
X3dmMjAwIiwKLQkuZmlsZV9wZHMgPSAiYnJkNDAwMWEucGRzIiwKKwkuZmlsZV9mdyA9ICJ3Zngv
d2ZtX3dmMjAwIiwKKwkuZmlsZV9wZHMgPSAid2Z4L2JyZDQwMDFhLnBkcyIsCiB9OwogCiBzdGF0
aWMgY29uc3Qgc3RydWN0IHdmeF9wbGF0Zm9ybV9kYXRhIHBkYXRhX2JyZDgwMjJhID0gewotCS5m
aWxlX2Z3ID0gIndmbV93ZjIwMCIsCi0JLmZpbGVfcGRzID0gImJyZDgwMjJhLnBkcyIsCisJLmZp
bGVfZncgPSAid2Z4L3dmbV93ZjIwMCIsCisJLmZpbGVfcGRzID0gIndmeC9icmQ4MDIyYS5wZHMi
LAogfTsKIAogc3RhdGljIGNvbnN0IHN0cnVjdCB3ZnhfcGxhdGZvcm1fZGF0YSBwZGF0YV9icmQ4
MDIzYSA9IHsKLQkuZmlsZV9mdyA9ICJ3Zm1fd2YyMDAiLAotCS5maWxlX3BkcyA9ICJicmQ4MDIz
YS5wZHMiLAorCS5maWxlX2Z3ID0gIndmeC93Zm1fd2YyMDAiLAorCS5maWxlX3BkcyA9ICJ3Zngv
YnJkODAyM2EucGRzIiwKIH07CiAKIC8qIExlZ2FjeSBEVCBkb24ndCB1c2UgaXQgKi8KZGlmZiAt
LWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvYnVzX3NwaS5jIGIvZHJpdmVycy9zdGFnaW5nL3dm
eC9idXNfc3BpLmMKaW5kZXggOWFhNTJkNzZjZGRhLi42YjRmOWZmZjhiNDQgMTAwNjQ0Ci0tLSBh
L2RyaXZlcnMvc3RhZ2luZy93ZngvYnVzX3NwaS5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93Zngv
YnVzX3NwaS5jCkBAIC0yNCwyNiArMjQsMjYgQEAKICNkZWZpbmUgU0VUX1JFQUQgMHg4MDAwICAg
ICAgICAgLyogdXNhZ2U6IG9yIG9wZXJhdGlvbiAqLwogCiBzdGF0aWMgY29uc3Qgc3RydWN0IHdm
eF9wbGF0Zm9ybV9kYXRhIHBkYXRhX3dmMjAwID0gewotCS5maWxlX2Z3ID0gIndmbV93ZjIwMCIs
Ci0JLmZpbGVfcGRzID0gIndmMjAwLnBkcyIsCisJLmZpbGVfZncgPSAid2Z4L3dmbV93ZjIwMCIs
CisJLmZpbGVfcGRzID0gIndmeC93ZjIwMC5wZHMiLAogCS51c2VfcmlzaW5nX2NsayA9IHRydWUs
CiB9OwogCiBzdGF0aWMgY29uc3Qgc3RydWN0IHdmeF9wbGF0Zm9ybV9kYXRhIHBkYXRhX2JyZDQw
MDFhID0gewotCS5maWxlX2Z3ID0gIndmbV93ZjIwMCIsCi0JLmZpbGVfcGRzID0gImJyZDQwMDFh
LnBkcyIsCisJLmZpbGVfZncgPSAid2Z4L3dmbV93ZjIwMCIsCisJLmZpbGVfcGRzID0gIndmeC9i
cmQ0MDAxYS5wZHMiLAogCS51c2VfcmlzaW5nX2NsayA9IHRydWUsCiB9OwogCiBzdGF0aWMgY29u
c3Qgc3RydWN0IHdmeF9wbGF0Zm9ybV9kYXRhIHBkYXRhX2JyZDgwMjJhID0gewotCS5maWxlX2Z3
ID0gIndmbV93ZjIwMCIsCi0JLmZpbGVfcGRzID0gImJyZDgwMjJhLnBkcyIsCisJLmZpbGVfZncg
PSAid2Z4L3dmbV93ZjIwMCIsCisJLmZpbGVfcGRzID0gIndmeC9icmQ4MDIyYS5wZHMiLAogCS51
c2VfcmlzaW5nX2NsayA9IHRydWUsCiB9OwogCiBzdGF0aWMgY29uc3Qgc3RydWN0IHdmeF9wbGF0
Zm9ybV9kYXRhIHBkYXRhX2JyZDgwMjNhID0gewotCS5maWxlX2Z3ID0gIndmbV93ZjIwMCIsCi0J
LmZpbGVfcGRzID0gImJyZDgwMjNhLnBkcyIsCisJLmZpbGVfZncgPSAid2Z4L3dmbV93ZjIwMCIs
CisJLmZpbGVfcGRzID0gIndmeC9icmQ4MDIzYS5wZHMiLAogCS51c2VfcmlzaW5nX2NsayA9IHRy
dWUsCiB9OwogCi0tIAoyLjM0LjEKCg==
