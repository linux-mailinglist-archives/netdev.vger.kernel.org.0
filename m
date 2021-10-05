Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49C17422923
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 15:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235900AbhJEN5A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 09:57:00 -0400
Received: from mail-dm3nam07on2066.outbound.protection.outlook.com ([40.107.95.66]:60512
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235485AbhJEN4O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 09:56:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LLeJt8XUQvqSlON1Hma5rGFztaV+zbK/kxKdP6r+rj/GntsObRX9AUobl9FUsPRmJNee5W1Rst8jl3aHwYj9gIULpig3UGba3JOewCMrHmT32t73fjGy5urp6ud327kmQKoJkw61vV/fEzKQrBLfvsp2U35RkJnazRfudKSTa+YB9PCr9dyp4FkB5K542NUdG97zbYmzXc69AnVcKPSsl8SO2fFi7Pqsxs4sNl8hZJZOqLzQ8T5bhxXDxa8EbCFaNIoK46yL1E+TQEwaF5Y7ym4JlLV3WVjSpr+fQMg5cCtsFoyvUdU3zQ9Yp9iFDqFY0O4k3adhcMUF2LqGGX535Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IyY90r6QMFMHTI+VFb7nrT6DVJW15/DHuG0/svc2nKU=;
 b=BAPJlNLTNe5IMm8FSHnRyttP04KnM4jCwtYFJC31rsyivf8IAUFztIznU3BleHepyyfANX0wIY21wl4ZYBJTGHvd3hj+8245wLaRkKN2zZoOmcQJ8C6pLlkqIqZCnDfINFFM38bKY0a6QyymqArLtoL50xcajL6nMmw3x06D3ivERlGqyiKlG/Y93GV044pQ5xTX2+xAQmHYAVhwB9LHAWzP2LJQlWEaJs18mmbStpN/p2yvDgLMVIiJpvWnbIsWHNNcnUykuAC1GZp1zH5Uw6jmDvX0BZgvSwB8tbgaepQwnFFBdjTWCWw+LJtqtO5fawNxwPGsrTNOCbQnnpb/Dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IyY90r6QMFMHTI+VFb7nrT6DVJW15/DHuG0/svc2nKU=;
 b=R01P38XZSBLcVY/65QW1JX2dsN6HPvrXLy5yrCe0agSivILUfrG/IB27W3sV6SpRz1eaRrtho2tbLWQvQpmcOKmrQOB85zDKmCsahdw+sajae1yjvw/ugFaVmhjQWyOdv+wDnQkv/nFRuKkV2yH2eWWW7x8+SQpc9+SuXiNjHk0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by PH0PR11MB5643.namprd11.prod.outlook.com (2603:10b6:510:d5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14; Tue, 5 Oct
 2021 13:54:22 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::31cb:3b13:b0e8:d8f4]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::31cb:3b13:b0e8:d8f4%9]) with mapi id 15.20.4566.022; Tue, 5 Oct 2021
 13:54:22 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-mmc@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v8 01/24] mmc: sdio: add SDIO IDs for Silabs WF200 chip
Date:   Tue,  5 Oct 2021 15:53:37 +0200
Message-Id: <20211005135400.788058-2-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211005135400.788058-1-Jerome.Pouiller@silabs.com>
References: <20211005135400.788058-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR3P189CA0084.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:102:b4::29) To PH0PR11MB5657.namprd11.prod.outlook.com
 (2603:10b6:510:ee::19)
MIME-Version: 1.0
Received: from pc-42.silabs.com (37.71.187.125) by PR3P189CA0084.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:b4::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Tue, 5 Oct 2021 13:54:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bfc93fb3-a266-4aa2-225f-08d98807a23e
X-MS-TrafficTypeDiagnostic: PH0PR11MB5643:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR11MB564398A291BC6D2A46399C2A93AF9@PH0PR11MB5643.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kiMVW1NA41GtfWmADX55QOmxS9nyRnDiW1F7K8S5lvYtsOl8QU3glTDu5G4Se7G0Spb0lgzELtDzYToGtJ0B4CoxhgEqfy6ht/f/LGUmtP/1Pldhbro3a1IWWvw2tV0eyIAP6482pLLvDOvpBABai0943LfBqy4AcGsLVtw6sVpLqQv6Cu7kuYvbwHXcb5nmvDTF85vKJQ2LAAC+LqLq+6Z336QS661ThRasxvUWD5o/+/1BGqiZ2gCq+MqIQTNKLX7MCAwhZa4C595Nn6p6w7WSd4TkSWKwJRdxF4peqB4VuGaNGgnds8RwJlYVlxjkhT6SlYgKA4Xvf+8THx2hS9my3gGJkSj/1Xc7q5xpohKigGOFsDlrTIcZUISk7FgOhbsfLjqqVGxoGxQyfq/+eZOopz90mjrnbn9lo+LK3HbEXNPrsMMDQj9m9Q0PX7krS/Xa50V9Uf26dPOjsahJyEjWfIAU33j15atie6nHxdrx0BB7/5rVqmdMjuevsYXKBq//0qKP0WFfJUXihbzenhG9iEbbfpgcXVVQxnZ5NKmix7NMxIl7yfXoM0kl5KYNXUkd7r90paXA2FcMCLpBFDcZjV8yYwl+l/i9++B6a7RXj7q65pePVFuZekl90cjKm4IG3wiZzAZ+A8RqmpGRwLyAZsLUII9kilOmA1FoRXGoqQsVnq1mjc5xUkDQXUovaujJDqHKoZ6BV3RC11B3hQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(7416002)(2616005)(956004)(54906003)(8936002)(4744005)(36756003)(1076003)(186003)(38100700002)(86362001)(6486002)(6916009)(5660300002)(38350700002)(66946007)(66476007)(66556008)(52116002)(7696005)(508600001)(6666004)(2906002)(316002)(4326008)(26005)(107886003)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TG84THZCZVZGQyswTnVBaFQ0a2lpZllhOFBhdnpWckI4QWNLdkoxYmx5S1U5?=
 =?utf-8?B?dGtBZ1dEUUlZSEx5UjdBYkJ0TnhldEFSOWx6M0RtNkhzNGQ5QWxXUUdITVlu?=
 =?utf-8?B?VW5ZTVZOK0grYldpeWRDUFpia3lJdks0QkFkMUs4MmZ3U2IySGtZRjhIQWMx?=
 =?utf-8?B?anhBNEZTaFEwYVhCOHJqLzFwcy8vY25KVWxjdHF1MVhGSG5nS0dTalFwWEw5?=
 =?utf-8?B?K3BtY08wRUlNZ3dEdERIK3gxY3FVS1ZIUFh2VDZkU1dyNEN4aC9reVRYWkpH?=
 =?utf-8?B?eUlXaWJyK3JGbDlCTXZSUFFaY3RXZi92eWlUTURhdXZBenc4UGU0VHJKelJL?=
 =?utf-8?B?VncwUmhEckJkRFMwTklXbTJBekdXM0VyaTZEZktxSFo3N1M1NnJhN3RibjFs?=
 =?utf-8?B?bEdTemxEY3E2U3kxdkdoanVLdmZQTkR1U0hpN1dhNGtRSzZYcUpaMHZ2R1lZ?=
 =?utf-8?B?VWlnTDZpM2JEbzF4SnF6MHVtUnB3b0RUTnM4OVJYYVg2ckh6VHRyaDdZalZu?=
 =?utf-8?B?bmhFek1zN1RHb3NleVplZWlhakdoRDBhNnFzOE1zTEJhZ1l4UWNTNm56cHRx?=
 =?utf-8?B?bmlVUXlKR0ZHaG5pZTJ5QlNqbTRyUHV1YkVHcDFoZUVmd3pYK1ZramR5Zncx?=
 =?utf-8?B?cHhiTDcwbW1DZi9MR2g3aUw0cERKZi8yUUVGdXUvdklRUTNkaCs4SXNBaWZC?=
 =?utf-8?B?RWduOGFUVkplUnpiT1dBSE8vWmpNdVlXZWdWWWM1dkJSYVZsZlY1bVZKek1x?=
 =?utf-8?B?T09KR2drSHk0QWtUOTNiSCtNMGlvd2RjQTNhQlJkYWZLTm5Rakc5cjQ1bVVG?=
 =?utf-8?B?YnN3WjJrNitXV3pEYmxWZ3pGU2dmQWNaSmpwNnUxWnhhN0FrNUdGZmcxYVFj?=
 =?utf-8?B?MmgrZ1FPYXozMGJHRVYreWVES2xvRnZIdzczL0lnazdtaG0vdCtoMmdCN3Ra?=
 =?utf-8?B?OGJxdlJ0aXZJT1laOUtGdTRaTFczRWsrQ3lNUk83MXBkTnkralY1SGE2NDNM?=
 =?utf-8?B?Vkp2WjNnVDV6bnRoWkszZmtGNzFFNnVlNUtJd09FRlRNZGMxT25XcWVSMzZr?=
 =?utf-8?B?aUJnUDV5WEN2SkFlbVZOUWdjNzdBTUkwN3RUYmphUjAvcFc2M2JISzZyUEw3?=
 =?utf-8?B?WlgvZUk4aitHLy83ZFhxR2xxNzRXbFRYYkx4UnBBZlBPOFhhOTFNOWdFZFJa?=
 =?utf-8?B?ZXh1alhCL3R4WkpqM3hpK0VWSHp1RkhQdmNFdjVxMUowM05DK3BWR1NZQlZ3?=
 =?utf-8?B?VnoyWGhqQ3I5eWFzVWZuN1FOblJlTHhPRHJnVnZsOTd1L25NOU0wVXVkczFo?=
 =?utf-8?B?V3IzWWN5YzA1YVZlRWc5eXlkZlFMUm84SjM2UVM4bzVkQ0JBZUZHWkhFNkNt?=
 =?utf-8?B?c2g2Qm0venJrbHB6cWx3NEUxN3ZXWTVhUnk3QzZDUEJTZ25XbXRyc0NDaHor?=
 =?utf-8?B?TW9hRGdSR25qeVk5ZzVMbGxMM2s0T2JvZUtCRzZlaktqWVlvZEFJSStUZkxO?=
 =?utf-8?B?NFRtRHRCSDNPaHJCNDBPOG1FNDBTSEgvRU5pU1BuR1NRSm1EYWdtOS9OaHMw?=
 =?utf-8?B?ZXRZRk1BRTNNN1VIa1A0ZTRGYmJTT21rUFAwK2VXaXkyaVl1cVVEOXg1QWQ4?=
 =?utf-8?B?eWpRU2tSZGFPLzVJYjdSMHBENmltTDBVdG5yNjRNczhHV3QwdEpULzZKdHIw?=
 =?utf-8?B?TVVkenEvaXZHMmlIQzEwMGZ6YzNhcEovTlhJVmcyVGVESnlZa3oxblRYUFhx?=
 =?utf-8?Q?An2+eg8i7YZ9LhaRWab5WVdW4VZJjisXFR+4+7J?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bfc93fb3-a266-4aa2-225f-08d98807a23e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2021 13:54:22.0553
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wt19S5bBwQYK+loR/03QnJT+FemsDJodLINigxbDjl/nhGBU6i4L61K1R6KYEBb+qHnkg/IaCRQdT0OSaREA4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5643
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
CmluZGV4IGE4NWM5ZjBiZDQ3MC4uNDgzNjkyZjMwMDJhIDEwMDY0NAotLS0gYS9pbmNsdWRlL2xp
bnV4L21tYy9zZGlvX2lkcy5oCisrKyBiL2luY2x1ZGUvbGludXgvbW1jL3NkaW9faWRzLmgKQEAg
LTI1LDYgKzI1LDEzIEBACiAgKiBWZW5kb3JzIGFuZCBkZXZpY2VzLiAgU29ydCBrZXk6IHZlbmRv
ciBmaXJzdCwgZGV2aWNlIG5leHQuCiAgKi8KIAorLyoKKyAqIFNpbGFicyBkb2VzIG5vdCB1c2Ug
YSByZWxpYWJsZSB2ZW5kb3IgSUQuIFRvIGF2b2lkIGNvbmZsaWN0cywgdGhlIGRyaXZlcgorICog
d29uJ3QgcHJvYmUgdGhlIGRldmljZSBpZiBpdCBpcyBub3QgYWxzbyBkZWNsYXJlZCBpbiB0aGUg
RFQuCisgKi8KKyNkZWZpbmUgU0RJT19WRU5ET1JfSURfU0lMQUJTCQkJMHgwMDAwCisjZGVmaW5l
IFNESU9fREVWSUNFX0lEX1NJTEFCU19XRjIwMAkJMHgxMDAwCisKICNkZWZpbmUgU0RJT19WRU5E
T1JfSURfU1RFCQkJMHgwMDIwCiAjZGVmaW5lIFNESU9fREVWSUNFX0lEX1NURV9DVzEyMDAJCTB4
MjI4MAogCi0tIAoyLjMzLjAKCg==
