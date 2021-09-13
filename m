Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5439B408BB9
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 15:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240233AbhIMNFc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 09:05:32 -0400
Received: from mail-mw2nam12on2088.outbound.protection.outlook.com ([40.107.244.88]:10209
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240045AbhIMNEp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 09:04:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KsWwEGa2yAZbVvTgQAzgZMnBboqTGTxlMgGfJgD3ByMilKaHBhSOM4oOUDNflRaM5SGAlEnLqFwjXgxvMct3kGjUqksQk25gvSYcvpQplYTx8PHfslUat8PpPRYvrAhRxCTI0mJLdvCSwpcUxiXHomMPIcwYUH6FhbAdDTSz2tx2un24N5RbbtN/cgTTd9lIO93HnxdyKXUvbHYE/UkjR9cQ2snU0XjiIfDCpD8yp2bXhR2tgOUzNduOqZZy7UWQMG25/ZbYh2BOrP8+iOD7rLbb0OfFvROEQF/xnMPoB9S8wiMNjYNWr60SqW/o5UHvk9KV6tX2uSKYiu4D5Gx6kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=qM0FMGZRJjSUIUB43bIkjZdDBC6mBZNDVgLC0UqdvoM=;
 b=XTo8OSQwj6n/DruJZe41UBVoTFawL99/n+dc14yUl+tfE46hSilbSZa+CjH2PV60JI2xuVi5sCCk9F3WEhzqHpfHNUuXQhomTWOWK58Ze4KdcMVzGRUtcPCCJ+JuaxaPdXk5nBRn/fVHLrCzi6xuDYNJS4KXTWn+mZs7M2inuSHR7mulWYNeAOxQoEA1YnFL6FcyS+WANUuhVPtFDGMySjAzVZfOy6dR8l+w8rvSWI8PUj+Rhji0yLBoMJc2Xju4j0csyNBR7gNlq6DPaiedcyZAGSiXiPtXbgSsfydgHePx7qw5clVePAooRg9x4SEQSpkLZRMGxUCi7fTGz9JULA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qM0FMGZRJjSUIUB43bIkjZdDBC6mBZNDVgLC0UqdvoM=;
 b=J9AL14lRduBJJTeR/viMY2qJjZbpYaRN6PeB06jGi8q43KGuCTPIZ0bZTaeV56AoOCuPgGmZz+7UoMQcbTTdXBpirTiW5l/bsH3PU7cIbj5LGBdLASe9KfVtoAf+DITP/+uP+xtrs2/xkJtvDjQDhItztcZnuKJ2pGfqhzbY/34=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA2PR11MB4860.namprd11.prod.outlook.com (2603:10b6:806:11b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Mon, 13 Sep
 2021 13:02:41 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Mon, 13 Sep 2021
 13:02:41 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v3 13/32] staging: wfx: update with the firmware API 3.8
Date:   Mon, 13 Sep 2021 15:01:44 +0200
Message-Id: <20210913130203.1903622-14-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913130203.1903622-1-Jerome.Pouiller@silabs.com>
References: <20210913130203.1903622-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR2P264CA0021.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::33)
 To SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (37.71.187.125) by PR2P264CA0021.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 13:02:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 28f23c10-085b-4ef0-9ee4-08d976b6c521
X-MS-TrafficTypeDiagnostic: SA2PR11MB4860:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA2PR11MB4860ABDA5229C88E12697CA393D99@SA2PR11MB4860.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:288;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 65WuPnQc6gUS/XdD9+EGkznW/ChxzsvqFUcIZq+RQU3fSuJKm1M727iqmktGefl88Y7RHKcdmU8c2rDIF3AzWTeK5pJjGXwDCqbRet8YtT6KkJ2FE1IVwMMU8HQnSvGiOm9mz+ChtCzcAmy05qKFxGUCw1UScc24KmPHXpAkpeWomK4Hcwwqa1EpTtQyOzLeZE+gCLzXQpHUpU+8XGkD5cnpjcGC6NRa+yzC+gyNHEsyTitzpcfbdFiSMSVQvbvMJa52n1mOSE+u8WE45IZ5EF3K3V02NZT2L4TkyNuFFuLHFlemNpYF/ZmADbO9drPSvkEyjHBGz0LxnuZy4MtqreGldeCe+iweTrEhE9sK5PYiipvM+l1dUjX0wmAW1drxg6sxHgb+rhdX9CYqWbFn5D+W+E3daDBMSKkkM8E9mp6VMB8kyeXJOu+jbR8O7AdTs0jIa1kGTxqq3+OZJCiUoFi1HfYF4dMHc/lldovRezhzPxWOPSd1RmXYn6e1sAGPXuxNGHzAPKVC7HESgvlIEJ0TrDdwUIENPwMfmCQMI8WHXJJ3h2ZDmTDqkYNmQj6c+v9PcUyGLQFZe1Mdlyb9FdsHkxDx2mAv0AZm6A6xcbExDT4e346T2oFxxnUP4dxWRXMTryvKj5GMtktTrVuU62rhb/479P+MOtvsCXE5ih8ozpuYhxX0EmasW0457C6q573E5hiWeSOnIwzD+cWQfw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(956004)(66574015)(6666004)(66946007)(2616005)(26005)(36756003)(38100700002)(38350700002)(316002)(4326008)(107886003)(7696005)(54906003)(5660300002)(52116002)(66556008)(1076003)(66476007)(6486002)(508600001)(8936002)(83380400001)(86362001)(2906002)(8676002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YUwxaDJLWWkrQUs0TndWNlZPSHo1N3I3eEtGNDRnUGZOL28zbDRES1BWemIv?=
 =?utf-8?B?Q0RVSFVuNmh6YitkMitELytXYjlYTjdYcnBYMitxUEN5Ynp6M0laM0tKZTVn?=
 =?utf-8?B?ZWd2MHo2QkdIQVlzRjliQS96QUlURElkY3VFRW5Vc1FCRFhHWk8rZUVzRkw4?=
 =?utf-8?B?K1hWaDZwZkFpMEhwQ1ZMU3JJRUpZQTEzWGk0V2RYV2ltRVFBTmFSRWNKNW5C?=
 =?utf-8?B?TGJNZmYxcVNia1ZwUXRiQXNSZWNyU1hPTXRQMkVRWlkxdjJpcWJid1JXQjFI?=
 =?utf-8?B?QkwyVjVvdDV3RXJRMENnUStmTU8xMUVRS3JDS3k3aEo2RHRuN3NIL0czcDBR?=
 =?utf-8?B?WS9NSXc4ZFo0STZOcFI1RFBrZGZzcXBnb3RvNE9GQWVWUnltUW1wYTY3ano4?=
 =?utf-8?B?Z1A3aVM4SVpTU1pmRktvSWowdlB4N3M5T1VDeW1tWitRajRQaisxUG1QaTM0?=
 =?utf-8?B?MEVoN3NKL0pMQjllMWJvWHFjbjlVcVg1VkFXQUNCcU9nRnlyUTRFS0VPSmk0?=
 =?utf-8?B?c2hyb3EwSlBzaWFHeDdTaEhzeCtqWGV2WWc5S0ZpaGRaUE9xbFloNnNBM0Nh?=
 =?utf-8?B?eksxQ21QUXkyWVV3SHh1V3prOUM3MXFHVmFBRUlleXpwS1phNVVZNUpJSHBF?=
 =?utf-8?B?Z0xUTkRrTkJ2Qjh4MGpzYTMvL2pzaCtpendRM3ByT05EZWF4Y3R0a0o2cUl0?=
 =?utf-8?B?K0xuRUZ2SmxvQW5iL25LbTZ5Vy9FRUs4WDI1MUxyeUNoSnVUTjg1Q1dpQ0JM?=
 =?utf-8?B?c2lmTjZUNHYrMThNSkpld1NpcDc1OEtjWnZXcmxteVBYbkVyWXNQQWdZQldM?=
 =?utf-8?B?TnJaRENWTm11Y3M3S0huaDNoMjNLY1RSdWFyNHZSSmxLblZqaTVseDYwUnRH?=
 =?utf-8?B?NXFyNC9UZnIrUTlEM1ZLb3hBMWlBL2llY2dzR2Zray9ZYTdPK2k0bGt1eFlu?=
 =?utf-8?B?TEZaTnNhY0FpT1J0NmxCNG5TbFkyNFp1bDBjVlg2NEl3RDEvVmxiUmJmazVB?=
 =?utf-8?B?MGsvRjFPeGdKMjNBSHoxUFZSUktEdHB0YXZXUXB6WDdiVGNxd2cycWFzWitY?=
 =?utf-8?B?S2FNT3FDdHNISGNScU5TOENjYnZwamo4VzJLdVJqL0UwbG5kOFRwSUxmMUU3?=
 =?utf-8?B?MVlva0d6bVNOWVM4T3FiSHE5ZlR1MXRaYkdWU1ZHbnc1RjI3SFNVOG5mVDlk?=
 =?utf-8?B?SEhQYXFPdndJb3QwbURvZXZCUkh5Sm5lOXR0ZVpmYm0xaUJEc3JuYlpQZDVi?=
 =?utf-8?B?MXp1WmNzbm5BQ0VjTUJmZnFZTDhtV29VNVZ4d2E3TUZjN0dMT2NZdHRPS29B?=
 =?utf-8?B?aGQ0WS9BaGd1M2pkWHEwczkxeDJLZzhYTG5hU1VTalJnQ1MyWlhFa0N6L3Jq?=
 =?utf-8?B?eGlHVVVjc1lrSGFOazFaK2xtWXZiMlFiK2VoSFlzZkpabTBKcW4wNmczNjhj?=
 =?utf-8?B?Rm9kYVBhS1BMcU83eHp1ZGtoK1U4RXl1a0k2YmtvNmNuckxJMndSbjR2d1g1?=
 =?utf-8?B?T2FBZ1UrY0l6MklidGdvQ3pwWkx6LzJjZUM2NmxoWWMzb09FZGFrTEJlSVM4?=
 =?utf-8?B?VTBpbmFHUFJET1phMVdvdXlkbkluUTFOeklLN1QrZ2ltUk1EeDZ4d1ZpbklG?=
 =?utf-8?B?N2J1M3ZGYk4yMXJucXRkOURmV2p5SmJHSDE4SEM2cWhkazJJMHBzQTBzSlRz?=
 =?utf-8?B?MS8xYVdPbDNQOVBhNXpvMmlZV1VobWJrc1hNS2JYM2grUkNpMGFUWk9FWUJT?=
 =?utf-8?Q?vD5oqGngQsb0+OHznFEy1zojYTENx+noK5ym7tb?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28f23c10-085b-4ef0-9ee4-08d976b6c521
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 13:02:41.4445
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vCxurMfJrx9OL8rflIRneND73/5J8LUDBiaZKWwfZTKWcJAvl8rvBAPK60C727WtrSvD5dVP+UNyTKLD2DSmug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4860
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IGZpcm13YXJlIEFQSSAzLjggaW50cm9kdWNlcyBuZXcgc3RhdGlzdGljIGNvdW50ZXJzLiBUaGVz
ZSBjaGFuZ2VzCmFyZSBiYWNrd2FyZCBjb21wYXRpYmxlLgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0
bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3Rh
Z2luZy93ZngvZGVidWcuYyAgICAgICB8IDMgKysrCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9h
cGlfbWliLmggfCA1ICsrKystCiAyIGZpbGVzIGNoYW5nZWQsIDcgaW5zZXJ0aW9ucygrKSwgMSBk
ZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvZGVidWcuYyBiL2Ry
aXZlcnMvc3RhZ2luZy93ZngvZGVidWcuYwppbmRleCBlZWRhZGE3OGMyNWYuLmU2N2NhMGQ4MThi
YSAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9kZWJ1Zy5jCisrKyBiL2RyaXZlcnMv
c3RhZ2luZy93ZngvZGVidWcuYwpAQCAtMTA5LDYgKzEwOSw5IEBAIHN0YXRpYyBpbnQgd2Z4X2Nv
dW50ZXJzX3Nob3coc3RydWN0IHNlcV9maWxlICpzZXEsIHZvaWQgKnYpCiAKIAlQVVRfQ09VTlRF
UihyeF9iZWFjb24pOwogCVBVVF9DT1VOVEVSKG1pc3NfYmVhY29uKTsKKwlQVVRfQ09VTlRFUihy
eF9kdGltKTsKKwlQVVRfQ09VTlRFUihyeF9kdGltX2FpZDBfY2xyKTsKKwlQVVRfQ09VTlRFUihy
eF9kdGltX2FpZDBfc2V0KTsKIAogI3VuZGVmIFBVVF9DT1VOVEVSCiAKZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvc3RhZ2luZy93ZngvaGlmX2FwaV9taWIuaCBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlm
X2FwaV9taWIuaAppbmRleCBhY2U5MjQ3MjBjZTYuLmIyZGM0N2MzMTRjYyAxMDA2NDQKLS0tIGEv
ZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfYXBpX21pYi5oCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93
ZngvaGlmX2FwaV9taWIuaApAQCAtMTU4LDcgKzE1OCwxMCBAQCBzdHJ1Y3QgaGlmX21pYl9leHRl
bmRlZF9jb3VudF90YWJsZSB7CiAJX19sZTMyIGNvdW50X3J4X2JpcG1pY19lcnJvcnM7CiAJX19s
ZTMyIGNvdW50X3J4X2JlYWNvbjsKIAlfX2xlMzIgY291bnRfbWlzc19iZWFjb247Ci0JX19sZTMy
IHJlc2VydmVkWzE1XTsKKwlfX2xlMzIgY291bnRfcnhfZHRpbTsKKwlfX2xlMzIgY291bnRfcnhf
ZHRpbV9haWQwX2NscjsKKwlfX2xlMzIgY291bnRfcnhfZHRpbV9haWQwX3NldDsKKwlfX2xlMzIg
cmVzZXJ2ZWRbMTJdOwogfSBfX3BhY2tlZDsKIAogc3RydWN0IGhpZl9taWJfY291bnRfdGFibGUg
ewotLSAKMi4zMy4wCgo=
