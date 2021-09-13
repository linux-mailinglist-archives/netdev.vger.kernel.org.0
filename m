Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1EF408BF4
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 15:06:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240441AbhIMNHg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 09:07:36 -0400
Received: from mail-mw2nam12on2045.outbound.protection.outlook.com ([40.107.244.45]:7936
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239855AbhIMNGB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 09:06:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QBFY77E3PTHGZOrwOItHHlhc5Y9UjVIPIxKQp3L7ZAaA7+yGnxuH0y6GiPCQm2vmvZpFPHv/nOsQHANbgZTI2CdK4c5uCL4x2widT8+QjAgpbEESIqarM79ICA8dm5eHVkPdp5EDA/htZ8GU6zOzdAkNLzFL13GP+smqRHUjJfBL/sLIGXAvebQvPZDwre9rcg30gGPuWmbRrrNHXgdGQ4Apbz/PjJvla9OhCIJ7gAFDR+2vlB9X0cx91nXCuirJw5WAZbB0sh8BblbRuzc39G0FsVuYCUtu9EQ152atoDCDOnf0YQmZHwsx9TmmxPKT+AqtMm5cgDH4Oi9Pi9eQSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=D2RF/Y6vM+Lj63470xCmRdZGPoY4c0kiDfF+JTD4zDA=;
 b=dXVHTZ/0ZvO8ySZ+1RZq0yHU/NxRdAI7w7MfAxNiaLTxkDkWCINpk99FbGJmhD7PGqPv3D+vUlHLGIgD8ID6cwxfIErf+uxkmfWBMDaGKXBLbjWEeRyuslHgyVUf3B2yvrkiBLz1VbsFom5ewAgQEgbWAlin4la3JuYD/00mrkF8cwJzFWTawLCDtOg46jaZPMz4OAR5GYjGzhJiFJE5MCL3+aEVHQRsI5dbnjB/abOHmfgT3Tkk/gn9ivpISVsiSEcNRfzS8+Qh/31rFgalh1s2TzVWqnb2ktoVzeMQXaI5iY4/31QaNSm7HGePHNSL++BkM4Yf/4boSkq5FzrMxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D2RF/Y6vM+Lj63470xCmRdZGPoY4c0kiDfF+JTD4zDA=;
 b=XwfVVd/I9pCJllhxQI1CEiQy09Zs84aDDfpcqhXx8Bife2UNyxLplUDCOJwGfDQtK2l40BavfUMDAShbY2LD0EzBm+vK/Hna+j+pkb5lsYK+RjQPAM2SpqKMbuHDNYH9wmyGZtOwAhfYDAa+hrGcoheEQrqcehhh1HA1a/EeOjU=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA2PR11MB4860.namprd11.prod.outlook.com (2603:10b6:806:11b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Mon, 13 Sep
 2021 13:02:50 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Mon, 13 Sep 2021
 13:02:50 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v3 18/32] staging: wfx: reorder function for slightly better eye candy
Date:   Mon, 13 Sep 2021 15:01:49 +0200
Message-Id: <20210913130203.1903622-19-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913130203.1903622-1-Jerome.Pouiller@silabs.com>
References: <20210913130203.1903622-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR2P264CA0021.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::33)
 To SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (37.71.187.125) by PR2P264CA0021.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 13:02:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7ec4e442-4351-4801-5ccb-08d976b6caa8
X-MS-TrafficTypeDiagnostic: SA2PR11MB4860:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA2PR11MB4860BD4317AC5BEF95A8DFE293D99@SA2PR11MB4860.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:483;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R0ghX04hdSNcbVuHVzoBC/p994LQc1dN7Z8++WYx+UOoMmWEXeFK1zPWfvJXndJ/SWlFMicxgCsZEs7I6UrE+blcC+n7n2pakNwLqEJxpKPZN8y1P5+zXSNlipFspjQufcJ7afJ7QAXRRlDuZ0isqz5naMnTXfPOu6POPweBHogsN5vF7FssmQUK6dDEP33Ibkcf9HvWhdDaY81KlSLnz1yDkdH1xYduOBiWztrefbcDRgOdA0mNIYskvkEfwIoJWyB6R7MnEnWB1SiqPspVIG6rsy9LizcFMHzsoyX3eTLZq0OjgpMBpS4BtX+eu3AWIgG/J0Cho7i6iRmbD5pGwUCJlvpkmMqnBbH7HEIxtsHvHbyTczH73ah5+pGfRBinpaTwSw1Pf7GiQ4GvXMINj5vNjRaqE6zAI0rQ3dbj9JAsP2GLV48rrTTGQn2T2kg/slTqo5yZc5yZOejRvCGYpuXfAON5z4m8RY/mapVy330Ug/uBs+l0pCVI/XSZHN8AP9LSHBG2eZJ2Z3yVPITP+60Q5ev9dDADjWAf520YaGcLyFkYfkUDq+7oIK9h60Wq4yCEOmbxvwNwggUjaFIhhRL3F/euyKEVJT9nNjFSIblUCyDjex0GIr+GHGIN0R0hDidMukCQQKW9UgkDHF+zo+2E1QbbTJJN0vR06FYF6Km/f6wHeD4X1JdCAmh5vQH1b5fcWaTET7qwt7kBsOQSYA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(956004)(66946007)(2616005)(26005)(36756003)(38100700002)(38350700002)(316002)(4326008)(107886003)(7696005)(54906003)(5660300002)(52116002)(66556008)(1076003)(66476007)(6486002)(508600001)(8936002)(83380400001)(86362001)(2906002)(8676002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UVp1Nk5xeW9XMDlCclVLS2RRaS82RjBMOXNJdk8zOUt0UVoxK3R4eTIvTFBx?=
 =?utf-8?B?ZGRaNWthNkRJYmI2U1ZVelZueURxZmRDYUdUNThkRHh2YWFDUTZQdmYrSUJS?=
 =?utf-8?B?TmFrRTRQOTBzZUZESyt3cytGM2xXTUgxM3RFVjhveS9RelhUSlZ1T01kNmhK?=
 =?utf-8?B?Y0oxYkROSWFxNklBYjlSU3VtalVrbE9IZUs5V1FhVWpvN1lkdkRYZUdxM1Vw?=
 =?utf-8?B?Sm1iaVdHVVhUbU9pT1crU3hMK0pJSnY4aVhJeFhyb0dMZjFEU2VZSzYrc3lu?=
 =?utf-8?B?UXhxaG1VSzgwNnMva28zMGNuU2xteXNheWxpRmpkNGlrRC9sOUxWcS9MMWdO?=
 =?utf-8?B?LzhYU2RFSDlyeitoWGh2ZmxBTXFIWGgxQ292OGpjdUJSRDhKZkZjZTRmd3Bu?=
 =?utf-8?B?R1JqUXVFZkdPcmVWVmpORldKZnlaUHFtZk4vbXQzU0k0aUxML0tBd2hiRDFD?=
 =?utf-8?B?Wjl2RGIxOEsvcmc4OVNpUGl0aVpKcGNyVXlqQ29HZ1dGYlR2aEk5QndOQ2Rm?=
 =?utf-8?B?cFBlQngzaVBjY2tWTTlIWDJOU05ySkFmR3BnNVFMNytCMTJheWJha1d5NFpN?=
 =?utf-8?B?RGErYWwycE5zeWxNSFZxYUdqbjNCUkFORys2YStDYWNhTGxZT0lVVEJCVEdE?=
 =?utf-8?B?SjRkamlSbDZlNUdxWm1xbERadUFnUUlCTnBWT0VaZ0d5czgreGZRdCtYNWhI?=
 =?utf-8?B?RVZocUNBOTI5M2g0ZmpBN0VTMm41OHEwVzBCU1J0OUhqZGdZWFBiUVhZeVVF?=
 =?utf-8?B?dEpKTXlWMlovUXdGMG5PZXIwaCt1NU5XTGJvT0s4cSt6by9PK2lzQjFMWmdU?=
 =?utf-8?B?dElrdS9JRjVrcG9CL2JhdjVGcmpKVEtFcmp1c29FZGRCQU9sSHRCNjlFR0x4?=
 =?utf-8?B?RHl0aXVxVnJ0RnAwazFhcWlWdkNIb3dXUjlUQ2ZBTmd4Zi82a1lGNHNNWjlX?=
 =?utf-8?B?VXVrTThLYUM1dXNnWDg4WHFjaU0zaGVJZkV6cTNjYk1UbzJrTHhUTGJVMTZH?=
 =?utf-8?B?eHhiSUtxYWRzQ2FDcVhKUWJ1V05ob1lLSmNzMDBYREZHSUt4OUZEZnlTc0Vi?=
 =?utf-8?B?T3dkMXZLZkVsRHNNNFMvSWFraFZGR0FINjZuQjN4NkMxemEzdzI2bGdPNUNq?=
 =?utf-8?B?SWkzYktNcnI1Qzd2TmR4T2l2WkZNR1BXZWRvUldpSEJlREtZekFESXR1MmtI?=
 =?utf-8?B?YnVjZThlUVlnUmF0NzBGY0FRNlZCVzd5WmtiL2c0MG92eDUvNmY0VzZwVEpx?=
 =?utf-8?B?RHQ4a0Y4eTZrNld5dG9nMDdCbmpiRlNYRTVESzJKa0xnVzBZa1N6SUowSWF5?=
 =?utf-8?B?YXhuNm91clJOcS9lVlhOYTljdTl3SFBLcldjdmtFTDFUL0NIZ2lTZlBydHB2?=
 =?utf-8?B?bHRZblVPeWE4QzlReWJWb3kvd3dPTGRvNzBxbVFDajg5cGJaRzkxR3hxSjl4?=
 =?utf-8?B?akN2QVMwQmhHOVFaMkl3d3JrTEF3N2NJTFIwZDc4ZVAvNjZpNUpMbEIyamE0?=
 =?utf-8?B?aytvMDRIUXcxZ1p1NS96cG1janJsY0R4N243ZjRjL3NHR0hraGVBcHRXMXM2?=
 =?utf-8?B?dTUwbWh0eDhtWTNUbjlKL1I2QjVIaUhzZE1KUVNycElzOWxxUE1wenhYMitx?=
 =?utf-8?B?a1I2NWVYOTVtNnJZZjc5VTNETDRMcDlYcXFKZkNYWkNIVWZJTFVOTThhVDQ4?=
 =?utf-8?B?OFVnSHNLT0o3R0xDNzRoN1NvdjFWcDI2U2VGZEo3dTRhL3F0eFpRQXR1Tm0x?=
 =?utf-8?Q?yxWAUrj6dfVTZZq8Cnuu3duI6Stfv2YSL4Gyh2J?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ec4e442-4351-4801-5ccb-08d976b6caa8
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 13:02:50.7071
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r3sds/xBb3D8DWpImO4sz8aiBCfYQTqUhNz7l/+mHeE4Lxf3b3P56Gn7O+q4mu1uCUmy8zeY/PxPD60T2plqlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4860
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKRm9y
IGEgY29kZSBtb3JlIGV5ZSBjYW5keSwgZ3JvdXAgYWxsIHRoZSB1bmNvbmRpdGlvbmFsIGFzc2ln
bm1lbnRzCnRvZ2V0aGVyLgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9t
ZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5j
IHwgNiArKystLS0KIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25z
KC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3R4LmMgYi9kcml2ZXJz
L3N0YWdpbmcvd2Z4L2RhdGFfdHguYwppbmRleCAwMGMzMDVmMTkyYmIuLjc3ZDY5ZWQ3M2UyOCAx
MDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3R4LmMKKysrIGIvZHJpdmVycy9z
dGFnaW5nL3dmeC9kYXRhX3R4LmMKQEAgLTM3NiwxNSArMzc2LDE1IEBAIHN0YXRpYyBpbnQgd2Z4
X3R4X2lubmVyKHN0cnVjdCB3ZnhfdmlmICp3dmlmLCBzdHJ1Y3QgaWVlZTgwMjExX3N0YSAqc3Rh
LAogCXJlcS0+cGFja2V0X2lkIHw9IHF1ZXVlX2lkIDw8IDI4OwogCiAJcmVxLT5mY19vZmZzZXQg
PSBvZmZzZXQ7Ci0JaWYgKHR4X2luZm8tPmZsYWdzICYgSUVFRTgwMjExX1RYX0NUTF9TRU5EX0FG
VEVSX0RUSU0pCi0JCXJlcS0+YWZ0ZXJfZHRpbSA9IDE7Ci0JcmVxLT5wZWVyX3N0YV9pZCA9IHdm
eF90eF9nZXRfbGlua19pZCh3dmlmLCBzdGEsIGhkcik7CiAJLy8gUXVldWUgaW5kZXggYXJlIGlu
dmVydGVkIGJldHdlZW4gZmlybXdhcmUgYW5kIExpbnV4CiAJcmVxLT5xdWV1ZV9pZCA9IDMgLSBx
dWV1ZV9pZDsKKwlyZXEtPnBlZXJfc3RhX2lkID0gd2Z4X3R4X2dldF9saW5rX2lkKHd2aWYsIHN0
YSwgaGRyKTsKIAlyZXEtPnJldHJ5X3BvbGljeV9pbmRleCA9IHdmeF90eF9nZXRfcmV0cnlfcG9s
aWN5X2lkKHd2aWYsIHR4X2luZm8pOwogCXJlcS0+ZnJhbWVfZm9ybWF0ID0gd2Z4X3R4X2dldF9m
cmFtZV9mb3JtYXQodHhfaW5mbyk7CiAJaWYgKHR4X2luZm8tPmRyaXZlcl9yYXRlc1swXS5mbGFn
cyAmIElFRUU4MDIxMV9UWF9SQ19TSE9SVF9HSSkKIAkJcmVxLT5zaG9ydF9naSA9IDE7CisJaWYg
KHR4X2luZm8tPmZsYWdzICYgSUVFRTgwMjExX1RYX0NUTF9TRU5EX0FGVEVSX0RUSU0pCisJCXJl
cS0+YWZ0ZXJfZHRpbSA9IDE7CiAKIAkvLyBBdXhpbGlhcnkgb3BlcmF0aW9ucwogCXdmeF90eF9x
dWV1ZXNfcHV0KHd2aWYsIHNrYik7Ci0tIAoyLjMzLjAKCg==
