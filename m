Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE1548D3F3
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 09:56:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231408AbiAMIzr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 03:55:47 -0500
Received: from mail-co1nam11on2053.outbound.protection.outlook.com ([40.107.220.53]:51425
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230469AbiAMIzn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jan 2022 03:55:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CJZmzSXFih5otQcyta3uikpOxhSMRNZKdF1jN3MMzDYeF7H929z5U8HTfoHjFJUlRCS+Iub8u1rNXwkb0dXHmCutlLEY/7b0+abK1airlmZCCAbWOpeyU1dukT2mUduvkktNuoYvUKd7+ZtaQ9HBj7LI4fw+apFejq69rMw6CDrwJeoVx3gJv6dADkbX2MPrAr5NdWlorksWNemtG4NAsrBWbRYVz+3CLnbNHTTeAcRBJC9IuZz3q8rORpuHzj4zFQFaLsNaD4/qv/pT5xL6oZg/Z5UYXhqoP2ZquVsoRYz9c/9Fu4jo8u49tcsuXvHh4Jfw8/xr2uekAbikuccHlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=obJleljcDCi1duIjWGP6FLtg1njg46Qb2c/qk7JDLQQ=;
 b=PP4oHAQR0IjcW93ZiPNGNpP6lF838OK+EAjK9BOZs4ODdn7uSxhGTgEx9yLmj6FLQa0i2tqCbQiA6hlM9A9LsOA1DjvOqQpRhLOc0zrV5Jz4sMZSEDKzouuzkH2CVx5MSnsCdlXlkAH/vmj2ngWg3uescRI34T1PKRyYz1wUil7hqQrA+X1Fj/lRLRm0WeZCGod5nd70clJGMEMQtqnIWAhGtvouRsskr6rATZzAQHFKMrg6RJImvR43dwvwtdXmCC0kp+uU1r/fuNvXZrNPvjfrlToN6X20uuWHp9zyW9SPrIAMQqn7RKivyQPK/58/ZYOivZWQPtqB8qJz+7Z9wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=obJleljcDCi1duIjWGP6FLtg1njg46Qb2c/qk7JDLQQ=;
 b=JQBt95km0SRhPTxU5yZvmcpWigK0f3JyUC9s+7WTcZE737OwlndPUh0PjfkrTv9GWwY+wkNtVOENQhAQ6EgnHpJVt0Nvrj9GyCOllTeKPlaSTHTCkSx8VKPsy3ZahcjAV1gnDHk8/7T/YwxfU1f3EpbmajC+L+PPy9VSFSMiv7c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by BY5PR11MB4040.namprd11.prod.outlook.com (2603:10b6:a03:186::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.10; Thu, 13 Jan
 2022 08:55:38 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::d031:da9e:71a:73e4]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::d031:da9e:71a:73e4%5]) with mapi id 15.20.4888.011; Thu, 13 Jan 2022
 08:55:38 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 00/31] staging/wfx: apply suggestions from the linux-wireless review
Date:   Thu, 13 Jan 2022 09:54:53 +0100
Message-Id: <20220113085524.1110708-1-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.34.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: SA0PR11CA0117.namprd11.prod.outlook.com
 (2603:10b6:806:d1::32) To PH0PR11MB5657.namprd11.prod.outlook.com
 (2603:10b6:510:ee::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a734efd0-011a-47fd-2bc2-08d9d672782c
X-MS-TrafficTypeDiagnostic: BY5PR11MB4040:EE_
X-Microsoft-Antispam-PRVS: <BY5PR11MB4040F1591916EC8BA014969B93539@BY5PR11MB4040.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UsDyi/i2dbo/ir3bfDg9K031f5WTCNpP4fRyafEJ8wIG8CxYyuxF7Xs8X+uoThs+X2zB9j/Syty7WN1HIKurUUWexlfDKMbvECU/g73W7rfxx4T6OJfcaAxr0noD4vNUluQq0r9PD4IFt1GDzfaYkt8kuKes5LZOYr7XUYOZYGvaRRsIN4ixOFC088zTySVG45cz7JH0Ha9/ReCwy05lvSoPB5KT5/LpF/EcGmOJS8LAXuonYckrzyhHAV4uRQrbP916TPWaxgXxHgrmNgBjvWgtzNT/hEOiLBqCrXGQoIwNvWZEU8xHkUfA6lZfeVA6F69Xpn8KFTY6Z29kSoVE0sDF2WD87xOqHREvsjaVl7OniicjBxcIGj1jAr6A1Ykztz+lr4FILWKmZFvQrMG4ggk9ToTRJcrWYRH3szrGOyAleb+BUTKGI8GPfJ8JFi7akvDbFQxvGHS4UtA2+CTyW059Qd5pXw96GHWyC44CZ+utllOJuuOFGGvdDc4/F0s7ZlTVQoUKBezwqq0teqn1Ub/3qWx9s6wmXLZZ5qzNSiHpkHeGI+3pHRXk7M7Xv6738wLT4pXctrlbFn2DxorUhLs31w6PoQq55ZAjcyGPSAEyP+q1NHntqJ5+BMtuqJUDDUWsNZV0e2YX5Z6lpGecgSAjmq5ei/E/n4mnC5pp1QnBMATh0ieo/OJsr/wOMaR4TWBwRuBPCj8krgyzBYht4sUjvJr1KsIBcmBphGk4ve8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6506007)(508600001)(186003)(966005)(38100700002)(4326008)(8936002)(6512007)(6666004)(66946007)(83380400001)(1076003)(2616005)(54906003)(86362001)(66556008)(2906002)(66476007)(316002)(52116002)(36756003)(5660300002)(8676002)(6486002)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cnlsODZXT3VadERNcWZsSVN3SlhYZk1ybEsxaUNHd1hMRG4razRrRm1Eb05z?=
 =?utf-8?B?V2s4TUt4Z3daZjdDM1hYN0x5VHBFdmFOVnRIQ0liekw1MHBVSUNZcUIwQk9q?=
 =?utf-8?B?RGNCYm9OZ0U4dzdKanhGaXpBMGg1WXh3VWR5NFlMbW9PSmxubVBhYnMwS1NJ?=
 =?utf-8?B?T0hDUmdPT3ozaHJPb29IVkJlN0k2a24yL29KaVhPNXQyZW1FNkZER1FSQWIv?=
 =?utf-8?B?RmhsaEZ5YTVSc1E1L2RBbkIzRlBmVWJlT3Mxa1ZJd0lGTmlpSmxJSEtFOXNv?=
 =?utf-8?B?YmtPcnBRUmdzbXZoQ0VsVmxpUWwraERQeWkzQkxsR2NXbDR0MGFyUjVUa1J1?=
 =?utf-8?B?NGd5L2pEby9ZSFRkNHRJR3lVajFSckJJbE5PZlVzOWtyTk9ldjJJenlRY3hP?=
 =?utf-8?B?QTE3L1NKc1hVQmxDaExkakVmY3IvOGx6SHdRRjJLSHVRNVl5eE9sS3JzTkNt?=
 =?utf-8?B?SktzUU5wYjhFcnY5UHVTMjFhSE9tbXFobXliVVBaMitJNHBaenY0SlRReSt2?=
 =?utf-8?B?alRMUWhlL2RMd3VrTWx0c1dEcGFvUkV3NStvaVNyeXcwVnRiVlhiMkVnd3Vp?=
 =?utf-8?B?OHR4Nmtlb2F0U0IrSEx3aGwwSk9zU0tMN0pIWmxPdHhKdi9FZ0JJbW5lT3dh?=
 =?utf-8?B?WjlKTmUrWGpSc09RK1dUZFBnQlhQbnNSSTJWK3NCZlJOUWRKZXhDVlBnWWFw?=
 =?utf-8?B?dFBlajE5eFVNMGh5OVlvTVl0R05QN3NwOEk3UG5ISzFQV1R4RWNMSExoaHZY?=
 =?utf-8?B?RjI4WEhSdlplRUhnanpLVmJNaHBtckx5TXh6cjIzMkwzS1BSYWRHTVl6Uzd3?=
 =?utf-8?B?M3JTS1ZVeGN6QUptZEsyMzNqOVhiVTNMOTFXZVhOem41U292eERnc2R4L1BU?=
 =?utf-8?B?eHRQVHlJQnc4L2hLRjYzK0RJalM3TDM3VUFDQzBYV2dCYVViQXdCeldqVndF?=
 =?utf-8?B?TkViWkVXb2ljdlBpVFBFdG5EMStMVm1iRjhpTTJtdnBlWkV3NVVqYjNWeUdq?=
 =?utf-8?B?NDBNRVR1ZStITXZxb0dNbnk0RXpFR0RXcFlYY2JuL285cU5qb3JtZ1ZURlNj?=
 =?utf-8?B?YXFjczJmOEswRm1DNzJWVGE2NzRpYkRWZE1EZ0xDaFdIZUh3dlZrQWNURkhC?=
 =?utf-8?B?VTcwbUI3SW4xTzRMcnBRQmNvaUUrRnd3WGRIdXJVa0I4KzNKcC9SQzFiN2Qy?=
 =?utf-8?B?NHhUS3BNcEVJbTF6YllXZjIvV3JvdG1OSjM4U2NFM1hDMjJoNFRnVThDME9s?=
 =?utf-8?B?MDJ6MEpNeHBNSkc3a3drR0pHRXhLVUZLOGdtWllUMWJnTGFWakRaa3kxNHpr?=
 =?utf-8?B?T1o0Tk14Q3E5b2d0dWNnV0g4a3IxVlQvWURTT2Y1R1JpS1dGR1hDaTZObnl0?=
 =?utf-8?B?NE51QjR3dDl0eFJIYlJOSS9rM0NsZmRCRTBUekV5ZU1DNndzT3Yyd05JRXJT?=
 =?utf-8?B?MERuenk0Vlg4S01jUllmSTdHVGVaMmJtaCt4Sml5WngrT2pmUkNFTmRWY3Bx?=
 =?utf-8?B?c1hib0xWMXdsRVlVaVNFU09RVWJCYkFIMkN4ZWFDSS8yWjF6bG51M3hSU3U0?=
 =?utf-8?B?UzFhZkU3WWJGMEVpVTlQUnkrUWlZRk9KOVV2Rm8zMkxLcm9FOFVSaVFBcm9x?=
 =?utf-8?B?WTVFRDN3MHA5VWxSQXl2eTdXRkRrZ0xtVkRkNzFRcU9naVRTeXVMWFc4RDR6?=
 =?utf-8?B?Wkx6TnVHSGM5NVlpazRxNTB2dmlKRGIyam1sQjBYQ003N20rR04wazAyOS9v?=
 =?utf-8?B?UDZEVmVLR3NEekxBZkpnajRGdkR0bndDWU5JTVcvS1E5OWVFeSs2Q1FranQy?=
 =?utf-8?B?NXlPNFRocmZHamVuVWFxeVFRdllwWGNEdCtuSFZ5ZjFmVGlRQm9ZMzYrV1dG?=
 =?utf-8?B?MS90Qi9yZ0RIc3RnTHdraTA5SlJPYVcyV2tvNWtPRndzeHJ2YXVRRjB3YlZG?=
 =?utf-8?B?MW1WUFZqZzFnM0hoclFEdkNocGxhNndoSnQ4ZTBlNXVGc1BuTlZESGdHZnJ2?=
 =?utf-8?B?VzBLQWR3cTdTOWZIOERwZmhwRTlndldZNVc2YXFIRWZNZ3lOeXBOM082dnpt?=
 =?utf-8?B?Z3lqMFdGQzdkenJSaGd4eU0xME9TVlYxTGJqcmhDeEVmcUlCck00WXJ0QnJV?=
 =?utf-8?B?ZWtoNG4yeno1TnIyV0tEdTR4RGRZUGV4YlhoNlhZMUdSWS9IckxLSXFwZ0VE?=
 =?utf-8?B?RVd1SWxUamg3S0pRMWcrZ1FNV1ZHeEVraTBhYVgwUGxiOVBPbE4zRkMvQ2Vr?=
 =?utf-8?Q?AsuIYGlZzqx7pU7YkCDCl0NdBRUkD/86J9Buc54Yy4=3D?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a734efd0-011a-47fd-2bc2-08d9d672782c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2022 08:55:38.3849
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sOb6NvZpSXKLTojMZDGvD+eYUYtRJ27R4KLaeyeu6POaVUoijli9LG2ojn78EEMIBR4GhOsctVtZuZbEt+/PrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4040
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKTW9z
dCBvZiB0aGUgcGF0Y2hlcyBvZiB0aGlzIHNlcmllcyBhcmUgdGhlIHJlc3VsdCBvZiB0aGUgcmV2
aWV3IHByb2Nlc3Mgb24KbGludXgtd2lyZWxlc3NbMV0uCgpUaGUgcGF0Y2hlcyAxIHRvIDI1IGFy
ZSBjb3NtZXRpY3MuIFRoZSBsYXN0IDMgcGF0Y2hlcyBhcmUgbm90IGZ1bGx5IGJhY2t3YXJkCmNv
bXBhdGlibGUuIEkgYmVsaWV2ZSBpdCBpcyBub3QgYSBwcm9ibGVtIGluIHRoZSBzdGFnaW5nIGFy
ZWEuCgpbMV06IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL25ldGRldi8yMDIyMDExMTE3MTQyNC44
NjI3NjQtMjQtSmVyb21lLlBvdWlsbGVyQHNpbGFicy5jb20vVC8KCgpKw6lyw7RtZSBQb3VpbGxl
ciAoMzEpOgogIHN0YWdpbmc6IHdmeDogZml4IE1ha2VmaWxlIGFuZCBLY29uZmlnIGxpY2Vuc2Vz
CiAgc3RhZ2luZzogd2Z4OiBmaXggSElGIEFQSSBsaWNlbnNlCiAgc3RhZ2luZzogd2Z4OiBmaXgg
bWlzc2luZyBoZWFkZXJzCiAgc3RhZ2luZzogd2Z4OiBmaXggY29tbWVudCBjb3JyZWN0bmVzcwog
IHN0YWdpbmc6IHdmeDogZXhwbGFpbiB1bmNvbW1vbiBNYWtlZmlsZSBzdGF0ZW1lbnQKICBzdGFn
aW5nOiB3Zng6IHJlbW92ZSB1bm5lY2Vzc2FyeSBicmFjZXMKICBzdGFnaW5nOiB3Zng6IHJlbW92
ZSB1c2VsZXNzICNpZmRlZgogIHN0YWdpbmc6IHdmeDogdXNlIElTX0FMSUdORUQoKQogIHN0YWdp
bmc6IHdmeDogcmVwbGFjZSBtYWdpYyB2YWx1ZSBieSBXRlhfSElGX0JVRkZFUl9TSVpFCiAgc3Rh
Z2lnZzogd2Z4OiByZXBsYWNlIG1hZ2ljIG51bWJlciBieSBISUZfSURfSVNfSU5ESUNBVElPTgog
IHN0YWdpbmc6IHdmeDogcHJlc2VydmUgZW5kaWFubmVzcyBvZiBzdHJ1Y3QgaGlmX2luZF9zdGFy
dHVwCiAgc3RhZ2luZzogd2Z4OiBmaXggYW1iaWd1b3VzIGZ1bmN0aW9uIG5hbWUKICBzdGFnaW5n
OiB3Zng6IGZpeCBhbWJpZ3VvdXMgZnVuY3Rpb24gbmFtZQogIHN0YWdpbmc6IHdmeDogcHJlZml4
IGZ1bmN0aW9ucyBmcm9tIGhpZl8qLmggd2l0aCB3ZnhfCiAgc3RhZ2luZzogd2Z4OiBwcmVmaXgg
ZnVuY3Rpb25zIGZyb20gaHdpby5oIHdpdGggd2Z4XwogIHN0YWdpbmc6IHdmeDogcHJlZml4IGZ1
bmN0aW9ucyBmcm9tIGRlYnVnLmggd2l0aCB3ZnhfCiAgc3RhZ2luZzogd2Z4OiBwcmVmaXggdHhf
cG9saWN5X2lzX2VxdWFsKCkgd2l0aCB3ZnhfCiAgc3RhZ2luZzogd2Z4OiBwcmVmaXggc3RydWN0
cyBoaWZfKiB3aXRoIHdmeF8KICBzdGFnaW5nOiB3Zng6IHByZWZpeCBzdHJ1Y3RzIHR4X3BvbGlj
eSBhbmQgaHdidXNfb3BzIHdpdGggd2Z4XwogIHN0YWdpbmc6IHdmeDogcmVmb3JtYXQgY29kZSBv
biAxMDAgY29sdW1ucwogIHN0YWdpbmc6IHdmeDogcmVmb3JtYXQgY29tbWVudHMgb24gMTAwIGNv
bHVtbnMKICBzdGFnaW5nOiB3Zng6IGZpeCBzdHJ1Y3RzIGFsaWdubWVudHMKICBzdGFnaW5nOiB3
Zng6IHVzZSBleHBsaWNpdCBsYWJlbHMgZm9yIGVycm9ycwogIHN0YWdpbmc6IHdmeDogcmVwbGFj
ZSBjb21waWxldGltZV9hc3NlcnQoKSBieSBCVUlMRF9CVUdfT05fTVNHKCkKICBzdGFnaW5nOiB3
Zng6IGRvIG5vdCBkaXNwbGF5IGZ1bmN0aW9ucyBuYW1lcyBpbiBsb2dzCiAgc3RhZ2luZzogd2Z4
OiByZW1vdmUgZm9yY2VfcHNfdGltZW91dAogIHN0YWdpbmc6IHdmeDogbWFwICdjb21wYXRpYmxl
JyBhdHRyaWJ1dGUgd2l0aCBib2FyZCBuYW1lCiAgc3RhZ2luZzogd2Z4OiBmaXggZmlybXdhcmUg
bG9jYXRpb24KICBzdGFnaW5nOiB3Zng6IGRyb3AgbGVnYWN5IGNvbXBhdGlibGUgdmFsdWVzCiAg
c3RhZ2luZzogd2Z4OiByZW5hbWUgImNvbmZpZy1maWxlIiBEVCBhdHRyaWJ1dGUKICBzdGFnaW5n
OiB3Zng6IGRvIG5vdCBwcm9iZSB0aGUgZGV2aWNlIGlmIG5vdCBpbiB0aGUgRFQKCiAuLi4vYmlu
ZGluZ3MvbmV0L3dpcmVsZXNzL3NpbGFicyx3ZngueWFtbCAgICAgfCAgMjMgKy0KIGRyaXZlcnMv
c3RhZ2luZy93ZngvS2NvbmZpZyAgICAgICAgICAgICAgICAgICB8ICAgNSArCiBkcml2ZXJzL3N0
YWdpbmcvd2Z4L01ha2VmaWxlICAgICAgICAgICAgICAgICAgfCAgIDMgKy0KIGRyaXZlcnMvc3Rh
Z2luZy93ZngvYmguYyAgICAgICAgICAgICAgICAgICAgICB8ICA2NyArKystLS0KIGRyaXZlcnMv
c3RhZ2luZy93ZngvYmguaCAgICAgICAgICAgICAgICAgICAgICB8ICAgMSArCiBkcml2ZXJzL3N0
YWdpbmcvd2Z4L2J1cy5oICAgICAgICAgICAgICAgICAgICAgfCAgIDggKy0KIGRyaXZlcnMvc3Rh
Z2luZy93ZngvYnVzX3NkaW8uYyAgICAgICAgICAgICAgICB8ICA5NyArKysrKy0tLS0KIGRyaXZl
cnMvc3RhZ2luZy93ZngvYnVzX3NwaS5jICAgICAgICAgICAgICAgICB8ICA5OCArKysrKy0tLS0K
IGRyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV9yeC5jICAgICAgICAgICAgICAgICB8ICAxMCArLQog
ZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3J4LmggICAgICAgICAgICAgICAgIHwgICA1ICstCiBk
cml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfdHguYyAgICAgICAgICAgICAgICAgfCAxNDQgKysrKysr
LS0tLS0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3R4LmggICAgICAgICAgICAgICAgIHwg
IDIwICstCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2RlYnVnLmMgICAgICAgICAgICAgICAgICAgfCAg
ODAgKystLS0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9kZWJ1Zy5oICAgICAgICAgICAgICAgICAg
IHwgICA2ICstCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2Z3aW8uYyAgICAgICAgICAgICAgICAgICAg
fCAxMTMgKysrKystLS0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfYXBpX2NtZC5oICAgICAg
ICAgICAgIHwgMTUwICsrKysrKy0tLS0tLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvaGlmX2FwaV9n
ZW5lcmFsLmggICAgICAgICB8ICA2NCArKystLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvaGlmX2Fw
aV9taWIuaCAgICAgICAgICAgICB8ICA2OCArKystLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvaGlm
X3J4LmMgICAgICAgICAgICAgICAgICB8IDE2OCArKysrKysrLS0tLS0tLS0KIGRyaXZlcnMvc3Rh
Z2luZy93ZngvaGlmX3R4LmMgICAgICAgICAgICAgICAgICB8IDE5NCArKysrKysrKy0tLS0tLS0t
LQogZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHguaCAgICAgICAgICAgICAgICAgIHwgIDY3ICsr
Ky0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHhfbWliLmMgICAgICAgICAgICAgIHwgMjAy
ICsrKysrKysrLS0tLS0tLS0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHhfbWliLmggICAg
ICAgICAgICAgIHwgIDY3ICsrKy0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9od2lvLmMgICAgICAg
ICAgICAgICAgICAgIHwgMTcxICsrKysrKystLS0tLS0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9o
d2lvLmggICAgICAgICAgICAgICAgICAgIHwgIDM1ICstLQogZHJpdmVycy9zdGFnaW5nL3dmeC9r
ZXkuYyAgICAgICAgICAgICAgICAgICAgIHwgIDg0ICsrKy0tLS0tCiBkcml2ZXJzL3N0YWdpbmcv
d2Z4L2tleS5oICAgICAgICAgICAgICAgICAgICAgfCAgIDUgKy0KIGRyaXZlcnMvc3RhZ2luZy93
ZngvbWFpbi5jICAgICAgICAgICAgICAgICAgICB8IDE4MyArKysrKysrLS0tLS0tLS0tCiBkcml2
ZXJzL3N0YWdpbmcvd2Z4L21haW4uaCAgICAgICAgICAgICAgICAgICAgfCAgMTIgKy0KIGRyaXZl
cnMvc3RhZ2luZy93ZngvcXVldWUuYyAgICAgICAgICAgICAgICAgICB8ICA1MSArKy0tLQogZHJp
dmVycy9zdGFnaW5nL3dmeC9xdWV1ZS5oICAgICAgICAgICAgICAgICAgIHwgIDEzICstCiBkcml2
ZXJzL3N0YWdpbmcvd2Z4L3NjYW4uYyAgICAgICAgICAgICAgICAgICAgfCAgMjcgKy0tCiBkcml2
ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jICAgICAgICAgICAgICAgICAgICAgfCAxOTQgKysrKysrKy0t
LS0tLS0tLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmggICAgICAgICAgICAgICAgICAgICB8
ICAyMiArLQogZHJpdmVycy9zdGFnaW5nL3dmeC90cmFjZXMuaCAgICAgICAgICAgICAgICAgIHwg
IDMzICsrLQogZHJpdmVycy9zdGFnaW5nL3dmeC93ZnguaCAgICAgICAgICAgICAgICAgICAgIHwg
IDk0ICsrKystLS0tCiAzNiBmaWxlcyBjaGFuZ2VkLCAxMTcxIGluc2VydGlvbnMoKyksIDE0MTMg
ZGVsZXRpb25zKC0pCgotLSAKMi4zNC4xCgo=
