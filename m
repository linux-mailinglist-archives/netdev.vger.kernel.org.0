Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E6C233B433
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 14:27:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231334AbhCON0q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 09:26:46 -0400
Received: from mail-dm3nam07on2076.outbound.protection.outlook.com ([40.107.95.76]:48947
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230433AbhCON0I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 09:26:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dl35aLdhWeg7hEK221G7Y17/PMvBBEm8LWTfV8BrQ+9Dp9CKmprcOAMhdVCgTCd0Sl5MHF58NrSnQW3PPm6KMYuH71dM+KBH1obuBz62H6FdCR1l1nmJgnc+Nddico69fGVTK9XinIzoRbrnwIst7R1gEoeLS77aSDkc+GwcTKGQwa1ybz/f2M8bk5/reGpsrtKtGf8fcR9XvhEfus/cycQCZJMhgIbkpf8J9mJ0RM44JhGmhw3m6PhHBL/dTmiWuWM42rKGAruh8175MKJYoyy6bHmXhFueVSJQaNI0I3J4873dO+BO6oLFK7qxxhe81Mt3YxB/JyrvQzDAd3OulA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SW4BtkZL8WRQ60zcsW+NImcmNj6y8xm8RPzeIlkg/0k=;
 b=FyCROBMXQqt8SjqfMKB2Do6fCwfUlv+0G2AiW2NUjKtIGPr5/HB+pRWGutPUw2ALd8LxqSWUlsqvjmAzdHUNzeayOZkigEArGbYby1D+2YoCx7bQ4ax6asjERVEQTFXXkNHFIosuiNBWKISxGEfbRNtE2AfQivOaQhhPXZ/jTXDLaPVC4fsUYJFaItwva6v8omK2iauh1xN3E9gaTIAcdmt5srsvxoOvEwpalR3Qu+kt4Wt+hEy3eqvhjEprN9DDG2K/MopdD2zqom0uVJhiaTg9ONGd6dXUAk/D0DNAcbk35qTwq0+Bc5lzegEo+tG6wDXCkeTutBefrrUxTl0EHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SW4BtkZL8WRQ60zcsW+NImcmNj6y8xm8RPzeIlkg/0k=;
 b=igbMBgfCTus251Lmb3w+UXVvBdy4HuvcuPGdwPhgEecn5N8bQrMhOg5bx3n2FQmeGDAoLkVDhakjQOs07fBQseZm6Z6edYLlg5OZA2WQO609AtP+X1JZjxfyxXWU5EVe3J9VlwMD7nA9y8SyW34UA4hQiFTIbZfEBxVQyiWKRp4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB3117.namprd11.prod.outlook.com (2603:10b6:805:d7::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Mon, 15 Mar
 2021 13:26:07 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::41bc:5ce:dfa0:9701]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::41bc:5ce:dfa0:9701%7]) with mapi id 15.20.3933.032; Mon, 15 Mar 2021
 13:26:07 +0000
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
Subject: [PATCH v5 16/24] wfx: add data_rx.c/data_rx.h
Date:   Mon, 15 Mar 2021 14:24:53 +0100
Message-Id: <20210315132501.441681-17-Jerome.Pouiller@silabs.com>
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
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:544b:f17b:7ae8:fb7) by SN4PR0801CA0014.namprd08.prod.outlook.com (2603:10b6:803:29::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32 via Frontend Transport; Mon, 15 Mar 2021 13:26:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b0a24ef9-2cba-4f54-b915-08d8e7b5e394
X-MS-TrafficTypeDiagnostic: SN6PR11MB3117:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB311786381B23A4A8624F9564936C9@SN6PR11MB3117.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:644;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TxzJtu3pTJy3XDjAEfW93YJNeD6f2ZYWLv5X3WsXkNPBTNIdMDtYfuWswWbbSX+3zzjgjng8EcVcJZjCLJ62Jw+pGiIUiEfn94J1QW26PsQ6e8w8knq7rRNZcNAi9ysznjQIVY/klRhEijfKxh4TeYobsqSqhUKYpF6AXripMcY1rgXTIqCoxSGbCa9fYlH2P7Qa3/MHQraKb0zB7ET7k46LpJ7tKsdxkYsqMSwUU781CxnxeUZxmLmyjOcmIwPuHvSNoOUSN6aZ540Lk0JWCk8csdSubs0wfiNz/KVP9J5Eiipotw91ptzOucPQu3dVxGIiPjVy4V8RZZkxWI4DgqK1vDCsn/Rj4WUUNsEsUyaL+VFjlq1HQpG2SIiBDVLBSF6XythRMkhV7nERPgA6yhc+229pKNVbFfhadvit7hOa+v7QAiNsDJIaL/hwjtAlOC/O+8gDmVJ8P8/MBV6U3phm6A+kRtxM2V67DSpo6lRr/uw/a8hAufSqVDcTOgRcrIJl3Z3V4WZ77K0/RXGRIMMUPyNyu5FiT+o+Xn5M+yYyskbNRjJ20LP+Rbro5onS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(39850400004)(376002)(346002)(366004)(1076003)(7696005)(54906003)(2906002)(66946007)(52116002)(316002)(86362001)(16526019)(107886003)(6666004)(7416002)(66556008)(2616005)(8676002)(478600001)(6486002)(186003)(8936002)(83380400001)(5660300002)(4326008)(36756003)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MXlDRjcvOWFzN3hORm05QkV1RFlRU3ZReTRrMnQwYUZHUHd1eWdQd1VGbVcy?=
 =?utf-8?B?TXBSbVEzSkZzNGpLRnZxQWtjNDVFYUNFUHNzdnkvZk1SU2dsWTJCNloxMEdi?=
 =?utf-8?B?S0l1UDhnYmU4Vk9hTlpQYVRmWGJyWnNWM29SOS9zNVErNVB1elY5TDZBKy9X?=
 =?utf-8?B?RlppZlBqeFVoTFJMcTYyQVpYMmZoNGwvdEhvb3RsTjNSZWg4SkNDc2l5aDNT?=
 =?utf-8?B?SElHME9GdDFOaHFFWnBMUFJJUEY2YzJXcENHVWloblVVOWNrQkd0ckR5cGpo?=
 =?utf-8?B?TzMvenRCL1Y0TkNqU05MVm0rTTduS2kvNEZCYUNoWkdNQXlVY3lpMTI2aFBN?=
 =?utf-8?B?K1cycnVoVWQ0VE5MOHcyVGFwdU10R1UzSHYyR2puUE9QSGdoWFZjb1hiQ0lr?=
 =?utf-8?B?aUNTRjN2NGpmZTJxaEM1V255c2VJSkpNWXNibmJtSkpSak1ZYVcrRkVqV3lr?=
 =?utf-8?B?dWhMNXJ5eitqZlhPaUdEcWN4SC9BTUpNU0t5M2JXNUJkQWQ4Tk1vckVISDRK?=
 =?utf-8?B?RFkrdHM2NkJqQVU0SjFpWW5YcEV0M2dyY2I0YTJDVXZMdzZSTmJJeWZLSXRo?=
 =?utf-8?B?RGd6L3hWNmNESXdTblRHM0I4dzVuZmd1bkNwTUJybXY1d0F2V2gzYkcrNWpa?=
 =?utf-8?B?dll1b1grdkFhZnZGbk9RanM1K2VEVVpRVm0xN2NlMlVENHpSQVRsL1JCNGxk?=
 =?utf-8?B?djBvTVd6U20xMkFFNnU4a1BaTHBOa0dZeDV5ZytUcnBZZFowUE5VR2RzOExX?=
 =?utf-8?B?OG5jcUNKSW4rZnB2TEZVSytUVTludGN2ZEdRZkRSTC9WVjczc3hUR2ZXSWxk?=
 =?utf-8?B?V2w1UnNtUmFMYXRoOW94VTF5djJ0UzFyclR0T0tYVDc1OGVCWWMyZTNlTHha?=
 =?utf-8?B?TDZQSXFOQUgrM1dCcytSajF5c3ZXeXNaaWV5cWFqZkJHVEMvVXVvRDJoQjdw?=
 =?utf-8?B?YlRyZjlRdnpGbSszRlhXY0I2L1dlNDArOEMyT0NGMTNWMENFS005N2R5Wmt6?=
 =?utf-8?B?ak1hclZvTSs0YXZBR3VjT2p4SzhHa2dTdmhSRk1jcm9xS1pjdzJrR0lQSzZW?=
 =?utf-8?B?eUhPMzdRWUx6RDdNZFptd1lQWll4a1JoQjlZSzNtcFFMRWFoVUQ5RE01R2M5?=
 =?utf-8?B?N3dtSi9BVGl5S1ZuYjMwMlRvRDR1NjcycXVLb0RzMnVUa0hUcXQ3ODliczZh?=
 =?utf-8?B?SFVneGVPZjFuSFFlbE1vMHVlVFl3UVRqYXVBOHZ6NVJtaDFZMHFPQWZTY3Fh?=
 =?utf-8?B?S25GMkt6UzRrZVNHWmRGb2JhaHNOSnI4bXhsNlNwaHVnVWlYSFU3eTZVZVg5?=
 =?utf-8?B?UHNDeHloVTZPU0NLT3F2ZW5nYW9ZMHBuR1RyZjFrMTVGc1hZQ1hJc3Zld3kx?=
 =?utf-8?B?Y2hRUzlrMTc5UExJKzU2OVJTdW5DYkFPK0V6TENKVmlQb0o3K2ZwNng4R2VM?=
 =?utf-8?B?Q29vZHhWWXJQVmthVVlPUXhOcGoyOXBwR0FHUGxVZ1BkUTIzOGZIUTEzZDJ0?=
 =?utf-8?B?akdIWHBvclh3MDd6T3pyblhmMmlqOFl3ZDJpZVVnM2YwRlFSbDVLTVAvZFlk?=
 =?utf-8?B?cUxMdW5EcXplZUQ1V2Y1dTZtSjdoeDdHNnlDVC9FdWdiZ0I4M2RmL3A0N2pR?=
 =?utf-8?B?UW1Ga1IwKzIxUXVKM0Yya04rNkNVbDAvZ3grUGtCZUE3WjAwSkI1QS9WVU1G?=
 =?utf-8?B?TVJjalhMcmdYK3Mzc0tvTGYrN1JBOFpJbVVKeXQ1dGdPaGVhQVBwS2thNkY3?=
 =?utf-8?B?OFAyaWNXL0w4cmJzRUpDRVBWRHc4bWtONVhIQTlCbWRWU0VoMmo1Mk9kdXh1?=
 =?utf-8?B?czlJK2hTRjBnMVFoNFhxbjk3N044c2NydVB5NVNqTDc4dWpCdjJuTGU3WEh6?=
 =?utf-8?Q?8GoJFKkHw3w1W?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0a24ef9-2cba-4f54-b915-08d8e7b5e394
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2021 13:26:06.8615
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DSzIA9qx3h/HK4hTyE0t0kUwMSBE9P4r3nfmIqAxvvaoIKXMM0NQSTW3BeQW+xoq8PShkLmL0l1MooTIPCcBpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3117
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKU2ln
bmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29t
PgotLS0KIGRyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93ZngvZGF0YV9yeC5jIHwgOTQgKysr
KysrKysrKysrKysrKysrKysrKysKIGRyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93ZngvZGF0
YV9yeC5oIHwgMTggKysrKysKIDIgZmlsZXMgY2hhbmdlZCwgMTEyIGluc2VydGlvbnMoKykKIGNy
ZWF0ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL25ldC93aXJlbGVzcy9zaWxhYnMvd2Z4L2RhdGFfcngu
YwogY3JlYXRlIG1vZGUgMTAwNjQ0IGRyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93ZngvZGF0
YV9yeC5oCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3Mvc2lsYWJzL3dmeC9kYXRh
X3J4LmMgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9zaWxhYnMvd2Z4L2RhdGFfcnguYwpuZXcgZmls
ZSBtb2RlIDEwMDY0NAppbmRleCAwMDAwMDAwMDAwMDAuLmU2ZDlkODc0NmQ0ZAotLS0gL2Rldi9u
dWxsCisrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93ZngvZGF0YV9yeC5jCkBAIC0w
LDAgKzEsOTQgQEAKKy8vIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wLW9ubHkKKy8q
CisgKiBEYXRhcGF0aCBpbXBsZW1lbnRhdGlvbi4KKyAqCisgKiBDb3B5cmlnaHQgKGMpIDIwMTct
MjAyMCwgU2lsaWNvbiBMYWJvcmF0b3JpZXMsIEluYy4KKyAqIENvcHlyaWdodCAoYykgMjAxMCwg
U1QtRXJpY3Nzb24KKyAqLworI2luY2x1ZGUgPGxpbnV4L2V0aGVyZGV2aWNlLmg+CisjaW5jbHVk
ZSA8bmV0L21hYzgwMjExLmg+CisKKyNpbmNsdWRlICJkYXRhX3J4LmgiCisjaW5jbHVkZSAid2Z4
LmgiCisjaW5jbHVkZSAiYmguaCIKKyNpbmNsdWRlICJzdGEuaCIKKworc3RhdGljIHZvaWQgd2Z4
X3J4X2hhbmRsZV9iYShzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwgc3RydWN0IGllZWU4MDIxMV9tZ210
ICptZ210KQoreworCWludCBwYXJhbXMsIHRpZDsKKworCWlmICh3ZnhfYXBpX29sZGVyX3RoYW4o
d3ZpZi0+d2RldiwgMywgNikpCisJCXJldHVybjsKKworCXN3aXRjaCAobWdtdC0+dS5hY3Rpb24u
dS5hZGRiYV9yZXEuYWN0aW9uX2NvZGUpIHsKKwljYXNlIFdMQU5fQUNUSU9OX0FEREJBX1JFUToK
KwkJcGFyYW1zID0gbGUxNl90b19jcHUobWdtdC0+dS5hY3Rpb24udS5hZGRiYV9yZXEuY2FwYWIp
OworCQl0aWQgPSAocGFyYW1zICYgSUVFRTgwMjExX0FEREJBX1BBUkFNX1RJRF9NQVNLKSA+PiAy
OworCQlpZWVlODAyMTFfc3RhcnRfcnhfYmFfc2Vzc2lvbl9vZmZsKHd2aWYtPnZpZiwgbWdtdC0+
c2EsIHRpZCk7CisJCWJyZWFrOworCWNhc2UgV0xBTl9BQ1RJT05fREVMQkE6CisJCXBhcmFtcyA9
IGxlMTZfdG9fY3B1KG1nbXQtPnUuYWN0aW9uLnUuZGVsYmEucGFyYW1zKTsKKwkJdGlkID0gKHBh
cmFtcyAmICBJRUVFODAyMTFfREVMQkFfUEFSQU1fVElEX01BU0spID4+IDEyOworCQlpZWVlODAy
MTFfc3RvcF9yeF9iYV9zZXNzaW9uX29mZmwod3ZpZi0+dmlmLCBtZ210LT5zYSwgdGlkKTsKKwkJ
YnJlYWs7CisJfQorfQorCit2b2lkIHdmeF9yeF9jYihzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwKKwkg
ICAgICAgY29uc3Qgc3RydWN0IGhpZl9pbmRfcnggKmFyZywgc3RydWN0IHNrX2J1ZmYgKnNrYikK
K3sKKwlzdHJ1Y3QgaWVlZTgwMjExX3J4X3N0YXR1cyAqaGRyID0gSUVFRTgwMjExX1NLQl9SWENC
KHNrYik7CisJc3RydWN0IGllZWU4MDIxMV9oZHIgKmZyYW1lID0gKHN0cnVjdCBpZWVlODAyMTFf
aGRyICopc2tiLT5kYXRhOworCXN0cnVjdCBpZWVlODAyMTFfbWdtdCAqbWdtdCA9IChzdHJ1Y3Qg
aWVlZTgwMjExX21nbXQgKilza2ItPmRhdGE7CisKKwltZW1zZXQoaGRyLCAwLCBzaXplb2YoKmhk
cikpOworCisJaWYgKGFyZy0+c3RhdHVzID09IEhJRl9TVEFUVVNfUlhfRkFJTF9NSUMpCisJCWhk
ci0+ZmxhZyB8PSBSWF9GTEFHX01NSUNfRVJST1IgfCBSWF9GTEFHX0lWX1NUUklQUEVEOworCWVs
c2UgaWYgKGFyZy0+c3RhdHVzKQorCQlnb3RvIGRyb3A7CisKKwlpZiAoc2tiLT5sZW4gPCBzaXpl
b2Yoc3RydWN0IGllZWU4MDIxMV9wc3BvbGwpKSB7CisJCWRldl93YXJuKHd2aWYtPndkZXYtPmRl
diwgIm1hbGZvcm1lZCBTRFUgcmVjZWl2ZWRcbiIpOworCQlnb3RvIGRyb3A7CisJfQorCisJaGRy
LT5iYW5kID0gTkw4MDIxMV9CQU5EXzJHSFo7CisJaGRyLT5mcmVxID0gaWVlZTgwMjExX2NoYW5u
ZWxfdG9fZnJlcXVlbmN5KGFyZy0+Y2hhbm5lbF9udW1iZXIsCisJCQkJCQkgICBoZHItPmJhbmQp
OworCisJaWYgKGFyZy0+cnhlZF9yYXRlID49IDE0KSB7CisJCWhkci0+ZW5jb2RpbmcgPSBSWF9F
TkNfSFQ7CisJCWhkci0+cmF0ZV9pZHggPSBhcmctPnJ4ZWRfcmF0ZSAtIDE0OworCX0gZWxzZSBp
ZiAoYXJnLT5yeGVkX3JhdGUgPj0gNCkgeworCQloZHItPnJhdGVfaWR4ID0gYXJnLT5yeGVkX3Jh
dGUgLSAyOworCX0gZWxzZSB7CisJCWhkci0+cmF0ZV9pZHggPSBhcmctPnJ4ZWRfcmF0ZTsKKwl9
CisKKwlpZiAoIWFyZy0+cmNwaV9yc3NpKSB7CisJCWhkci0+ZmxhZyB8PSBSWF9GTEFHX05PX1NJ
R05BTF9WQUw7CisJCWRldl9pbmZvKHd2aWYtPndkZXYtPmRldiwgInJlY2VpdmVkIGZyYW1lIHdp
dGhvdXQgUlNTSSBkYXRhXG4iKTsKKwl9CisJaGRyLT5zaWduYWwgPSBhcmctPnJjcGlfcnNzaSAv
IDIgLSAxMTA7CisJaGRyLT5hbnRlbm5hID0gMDsKKworCWlmIChhcmctPmVuY3J5cCkKKwkJaGRy
LT5mbGFnIHw9IFJYX0ZMQUdfREVDUllQVEVEOworCisJLyogQmxvY2sgYWNrIG5lZ290aWF0aW9u
IGlzIG9mZmxvYWRlZCBieSB0aGUgZmlybXdhcmUuIEhvd2V2ZXIsCisJICogcmUtb3JkZXJpbmcg
bXVzdCBiZSBkb25lIGJ5IHRoZSBtYWM4MDIxMS4KKwkgKi8KKwlpZiAoaWVlZTgwMjExX2lzX2Fj
dGlvbihmcmFtZS0+ZnJhbWVfY29udHJvbCkgJiYKKwkgICAgbWdtdC0+dS5hY3Rpb24uY2F0ZWdv
cnkgPT0gV0xBTl9DQVRFR09SWV9CQUNLICYmCisJICAgIHNrYi0+bGVuID4gSUVFRTgwMjExX01J
Tl9BQ1RJT05fU0laRSkgeworCQl3ZnhfcnhfaGFuZGxlX2JhKHd2aWYsIG1nbXQpOworCQlnb3Rv
IGRyb3A7CisJfQorCisJaWVlZTgwMjExX3J4X2lycXNhZmUod3ZpZi0+d2Rldi0+aHcsIHNrYik7
CisJcmV0dXJuOworCitkcm9wOgorCWRldl9rZnJlZV9za2Ioc2tiKTsKK30KZGlmZiAtLWdpdCBh
L2RyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93ZngvZGF0YV9yeC5oIGIvZHJpdmVycy9uZXQv
d2lyZWxlc3Mvc2lsYWJzL3dmeC9kYXRhX3J4LmgKbmV3IGZpbGUgbW9kZSAxMDA2NDQKaW5kZXgg
MDAwMDAwMDAwMDAwLi5hMzIwY2Q4NTgyNzMKLS0tIC9kZXYvbnVsbAorKysgYi9kcml2ZXJzL25l
dC93aXJlbGVzcy9zaWxhYnMvd2Z4L2RhdGFfcnguaApAQCAtMCwwICsxLDE4IEBACisvKiBTUERY
LUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMC1vbmx5ICovCisvKgorICogRGF0YXBhdGggaW1w
bGVtZW50YXRpb24uCisgKgorICogQ29weXJpZ2h0IChjKSAyMDE3LTIwMjAsIFNpbGljb24gTGFi
b3JhdG9yaWVzLCBJbmMuCisgKiBDb3B5cmlnaHQgKGMpIDIwMTAsIFNULUVyaWNzc29uCisgKi8K
KyNpZm5kZWYgV0ZYX0RBVEFfUlhfSAorI2RlZmluZSBXRlhfREFUQV9SWF9ICisKK3N0cnVjdCB3
ZnhfdmlmOworc3RydWN0IHNrX2J1ZmY7CitzdHJ1Y3QgaGlmX2luZF9yeDsKKwordm9pZCB3Znhf
cnhfY2Ioc3RydWN0IHdmeF92aWYgKnd2aWYsCisJICAgICAgIGNvbnN0IHN0cnVjdCBoaWZfaW5k
X3J4ICphcmcsIHN0cnVjdCBza19idWZmICpza2IpOworCisjZW5kaWYKLS0gCjIuMzAuMgoK
