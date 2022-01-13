Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 096B248D403
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 09:56:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231869AbiAMI4M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 03:56:12 -0500
Received: from mail-mw2nam10on2077.outbound.protection.outlook.com ([40.107.94.77]:35104
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231301AbiAMI4B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jan 2022 03:56:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cX0dkhsSL91imIXRfDCEwMqeEQCAeUMIjde38OMZqJllNAGUmrrOPYbAoytNJYhJT9PZpjxiBY1vm/Wy0ko8yiTsSd4XpYq/j7Hh2PZK3qKxziTqxfydZCu/OT6CoCdyjPFowlsD6dRomfpMhMbj0FJMtk3xBCHYBXXzoNyGe92+Zuf1um8Liw43+FkobkqFDl5MypuP+BvWnSyjPoJCiMTkE/PfYvyTeLtrftj1dKrWjWqBCVwfsSPfym6ozqwnxdY9vYGbXwsn3B0V+ViaYGm5n5pPntM3Gku7naW12yHyRGtWjLg0YdaxADSxLXOKFW65ZNGLLy7Ozx1u/BM7RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=phBDzhaT40l9IgYtXB5/UWs/UEjXEIHwTOFXmYhCtvQ=;
 b=cYyJdjqIYykui3FmQvddHemdaFR3baSAOfiSL8Y7c4bKv7WRoOj32Jq6OPOAbJPFbwcHAkukhOZDHqXs55KBPx3GFGFkK6GjqNLGfaQ1FQWhHBTrUBZ1Xae57YQKY++q7kWXsjGh8fPOlAuw9VciiZKV+sJrUXNkg0b9IBuSJnn3hcpcQ2zcvsvgWSY/zeerqQgPd5j9oS3RvCQqtmXM4aYXUv1qsbm8P8c8YMG6PeS2uwbCEnUr1ITk0XhUmJujf8G0ahwRr50riWbcUpdEMlCPQd4SYgXoRGEiMdhtbcURqbMZHD6/a5hf9apu/X7kz95zv0AAyJ+F5c8r5s/GPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=phBDzhaT40l9IgYtXB5/UWs/UEjXEIHwTOFXmYhCtvQ=;
 b=aaBKQyVYVxMC+ZOptfqhD17cROwKFpMjHutBVnNvC4F5ZN3t6aNTFgzo84YksX2KTSJPspNn6q74suFPC7XyVCXkG79Sp5AjdKAuqbqRTqRNsDtarPWbOWNW0xrTwp4lIevfQgaiPr2OdFye+yP+Z8h5gFrbfaifv6RNf5LEe3Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by BY5PR11MB4040.namprd11.prod.outlook.com (2603:10b6:a03:186::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.10; Thu, 13 Jan
 2022 08:55:51 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::d031:da9e:71a:73e4]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::d031:da9e:71a:73e4%5]) with mapi id 15.20.4888.011; Thu, 13 Jan 2022
 08:55:51 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 07/31] staging: wfx: remove useless #ifdef
Date:   Thu, 13 Jan 2022 09:55:00 +0100
Message-Id: <20220113085524.1110708-8-Jerome.Pouiller@silabs.com>
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
X-MS-Office365-Filtering-Correlation-Id: 3dc276f2-1e3c-46e4-4a9b-08d9d6728033
X-MS-TrafficTypeDiagnostic: BY5PR11MB4040:EE_
X-Microsoft-Antispam-PRVS: <BY5PR11MB4040FC2C7595C86C4ED7AB4293539@BY5PR11MB4040.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /8n5Yfows5VF9WYEEd/UwZFBD5Ndg2/dENjcbUMEfEso/bamjMWPZea+Yofr6N15IwTHjHCqAJJ+Z6eb4B5J3r8Ry49BTbD7r7tdgK91JEdODX6Si8RL/SJjhWgZS87wELxZWjF6xvpZ41nXyb6T7tosvdn72mPdNp2Lmy+xwIPyhTs7YzV3OQAoG2C2IF22iuo7Bk0k3P0hlKgwYy98FL8DyFfF9I4npR3aemabh5OMe+G1BPj6BN6dPm+slacU6dNdvPadDZssCVwf7R3VCgT2vDphDxuhAe0webnErHldeKp8zsNI5Y6csP/ogrWnzAy9DWenxNMvQL12gnZJ+cUiVY4wUSZlc5ORz8R2yWkUlHQBxlzAwCPRg0k1gAR3xxVgc0yeTODc3dUZDdcK4SQXLJ1ACQFiGA/segm/yptYVhxHo+5FDkW/vOmGqMBJljE36uxUHAQOkMy5A+pOqW+wXuMQcHgCYAjxg+jDhiB1ssGgA3uEFHh97xtdTnDamurN9uXJKr+XfpzDJRyWI9e7xXkgXQQXHRakWMcJxieQCzI35vMrT9hXMMGUTYhxUZjeFGudUMkDKu/+XbezyC4/k8Cthr0U4bxMq0CB48WlE1X4R2pMtGYLUGR48j6RU80Gdx50E5LsEGYcxVquSg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6506007)(508600001)(186003)(38100700002)(4744005)(4326008)(8936002)(6512007)(6666004)(66946007)(83380400001)(1076003)(2616005)(54906003)(86362001)(66556008)(2906002)(66476007)(316002)(52116002)(36756003)(5660300002)(8676002)(6486002)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aGhoV3dQMElyNVJEa0JIR3laekdXSkVKTTMvRzZyT2prZXZRYXJUQWRETEJ4?=
 =?utf-8?B?OVpETHBYT2tuaGx2RE5yNW1LaTExbERCcHc1VTAramZpSTlxVlE5Q0hXQndm?=
 =?utf-8?B?UHRSN1VuSUxvMnVGMFNCSlVNem5MTzloZEhhd254VEg5OU1FL3dieDRrTit2?=
 =?utf-8?B?SSsrZzRZdTYxRnY1Smo2UzlGeFByTzc1RVA2TURaL1BsaittRSs4ZS9vdisz?=
 =?utf-8?B?bjUwYkNrMHpKN0JqRkNJUk01V2lNZWhhSDhPU1lRb3VDd0xDZXpSc1Y5SVMw?=
 =?utf-8?B?WksvK2tvNXJxMElBZmpBVmpjZjRCeEVzY3hjUi9tM0JDWmMxZ09DWXExUnVa?=
 =?utf-8?B?eS9sTjdxeFpXRlJHQTBMOXVsZTFPWDdXTXlWNUlrT3VDdDF3cUFRVzdvMHJ1?=
 =?utf-8?B?Yk9veWRxVzh2R1Jubmxjb0RwSFk2WU1OUFFta25zb2lJMXFYenJwdUxqSDBv?=
 =?utf-8?B?Z3BDcDZ6cFY3R2VpM1VqbkdLVjQ2Y1NUL003SkhaZFVwNnVQZ0JVS0RRT21U?=
 =?utf-8?B?Tm02TGJ4eEE3d1YvdzI5N2YzOUFySXRjbmxNakVRaFBQUmtiVE5yb21oL0NL?=
 =?utf-8?B?WHM3L3dJSkdWN0ZPK3hwdjA5V05DeitXQ1ZoS1gvMG1HeTVUb0kvV0JjQ3FW?=
 =?utf-8?B?UkNLSXhjS2gvNEszS2xMOFZIRURtQ3ZlUitkaEJCeEVlU0RPSU1kR1VRMHk4?=
 =?utf-8?B?SFF2QW51ajNzRWZvL2kwYlZ3Z2xsSVRnT0xjZk1ZV3RGem80QnNLQnZubjlC?=
 =?utf-8?B?VE5OM1FrbncxMUlDV0RPRkxqNUFMMng5YWdGS2t3MWFpOGoxNjdqNk5KM0JW?=
 =?utf-8?B?WHFtbXJWUkZjaVJFVlByK3U3MVpCMUtKMlU2MFprU3VYYkhac21EZXBiZXRI?=
 =?utf-8?B?cnFyM0prbEdNSjRYRzVBRkVhT0thUXBhQlNtTFdNZ0VvV0k4QTQ4RVlRT0Zz?=
 =?utf-8?B?ZkFmNFhaNWFhaDJabVUraGdHYURPTkNjSFZEOGRrZGF2NjU2SFJlWGk4MUk1?=
 =?utf-8?B?M0FVQWhNcFRNR0RTOUxabXFyckR6dFFQUENwQmk2UnhnYTMyOWdkNmJtbWdh?=
 =?utf-8?B?ajBlVWpJTDU5ZlJ2UlBlTFowTmZXSWhEZWRYcjliUittbUUyazgzQmc4ZGxh?=
 =?utf-8?B?QU5UQm8zbzVlemNhUnI0WUVxa0lWdEtFazkzQXdzZHBwWmZXUTBOMnkrN1Fz?=
 =?utf-8?B?TWhMUkJldTdUY2o5Y3AzZzFCb1NnVEtpaXZqVllrUzRKRnhKTHRKaWd2Y21E?=
 =?utf-8?B?bmdnNWdQWVBOdzRER2d5cXlRdUovdzVVYmpLdTdlOUl5MDNzbGdNNGFFU2Jw?=
 =?utf-8?B?NnUwREFBRktnbEJ1akR2TmlwY3NXOFlydnRtZXpoQVJkcVQyWFVnQVdGa3pE?=
 =?utf-8?B?OFJXK1NBek9mNTJreGQwejV2SmtyT2JNRkxhb0l4dkNkRDRwUFg1Z3daek9s?=
 =?utf-8?B?dVNoNkp5RGsycVkrSS91OFozbzdsS2txRzRmWkwzR1RaSzI0d3FpbVN5RGk4?=
 =?utf-8?B?blJwUGtseHdMQkR1TXZnVW1kQ05sSzFsZmdsWU5CYkR5ZDNoVjJoRGRKQWl6?=
 =?utf-8?B?bjBKazgxWWVlWCttdVdmelUxQmVvbnFzQUpLTnhwQlhSb0w5ek03TUp5dnln?=
 =?utf-8?B?TXpmdGVIeEpXTlpDNDBxT0hqRUpJdXc3VlF3YVBaTUtDRXJnWXoxV1BIcTNZ?=
 =?utf-8?B?NmpsbUdaNVFvZTNCYjdGN0VZRXh1UVN0ZVBEOVlkdXFFUUlXeGpUQ0ZIby9V?=
 =?utf-8?B?UzZoa0FRbkN3M1RZdGtnOHNSbm0zTE4rNVgweWNpL0UyN0tMVFdiRlhET3Ux?=
 =?utf-8?B?UjFnWVZ6ejQ5Zzl4ZldmdDd0NkRlU0VKRkY2RzR0a0pKMFpCYXp2M0hCbGxP?=
 =?utf-8?B?YW5WbUI5ZzVKMnBHaWp3M1hVS3Mydm56TTR1c2drUHdJNzZNdG1qY0MvWGpj?=
 =?utf-8?B?RDhnL1RzVDFRaUY4ZHZWOHFuRXVNaFFxS01ENkFma2orTkliZ2JiMzdORDc3?=
 =?utf-8?B?bUhlMlpmTm15U2dTU0VRYXVvd2UwWDhIMk1VT1ZmRlNNQktVWS9MK1BhTGZr?=
 =?utf-8?B?M2c2V2VZdTVTTFFKdVNPcGFrbldJRDVoWnBQdWpJcFoxdUhrOUVQaVBrUjU0?=
 =?utf-8?B?eVVoQmFHTERIb2pXVjU1Smx2M2VyMlJxWWVWeVowQmNGb1RzUUltTTFxZldG?=
 =?utf-8?B?MVZjNHBMNUNjMzFiMEVnWWxjMFB1MmRwQUJKbUtIUDlZQlNQL241YjBPUlp3?=
 =?utf-8?Q?5ShNX5ExkPT7N0KqQpfra8PsEB/zzHQfVC8w2m1m+g=3D?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3dc276f2-1e3c-46e4-4a9b-08d9d6728033
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2022 08:55:51.7283
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NSXoh1ySJmWqtqCmtZYKBfzVLfrY5V+m0ZkrW0SSFW9SwhnvJsR+uOSO+inozBvqqnRqnOkihRlsyA1oA7eC2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4040
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKSW4g
dGhlIG9sZCBkYXlzLCB0aGlzIGZpbGUgd2FzIHNoYXJlZCB3aXRoIG90aGVyIHByb2plY3RzLiBP
YnZpb3VzbHksCnRoaXMgIiNpZmRlZiBfX0tFUk5FTF9fIiBoYXZlIG5vIHJlYXNvbnMgdG8gYmUg
aW4gdGhlIGtlcm5lbC4KClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUu
cG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9hcGlfZ2Vu
ZXJhbC5oIHwgNiAtLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCA2IGRlbGV0aW9ucygtKQoKZGlmZiAt
LWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX2FwaV9nZW5lcmFsLmggYi9kcml2ZXJzL3N0
YWdpbmcvd2Z4L2hpZl9hcGlfZ2VuZXJhbC5oCmluZGV4IDNlNWM5MmUxMmQzNS4uODI0NDY3NjEx
MmE1IDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9hcGlfZ2VuZXJhbC5oCisr
KyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX2FwaV9nZW5lcmFsLmgKQEAgLTgsMTQgKzgsOCBA
QAogI2lmbmRlZiBXRlhfSElGX0FQSV9HRU5FUkFMX0gKICNkZWZpbmUgV0ZYX0hJRl9BUElfR0VO
RVJBTF9ICiAKLSNpZmRlZiBfX0tFUk5FTF9fCiAjaW5jbHVkZSA8bGludXgvdHlwZXMuaD4KICNp
bmNsdWRlIDxsaW51eC9pZl9ldGhlci5oPgotI2Vsc2UKLSNpbmNsdWRlIDxuZXQvZXRoZXJuZXQu
aD4KLSNpbmNsdWRlIDxzdGRpbnQuaD4KLSNkZWZpbmUgX19wYWNrZWQgX19hdHRyaWJ1dGVfXygo
X19wYWNrZWRfXykpCi0jZW5kaWYKIAogI2RlZmluZSBISUZfSURfSVNfSU5ESUNBVElPTiAgICAg
IDB4ODAKICNkZWZpbmUgSElGX0NPVU5URVJfTUFYICAgICAgICAgICA3Ci0tIAoyLjM0LjEKCg==
