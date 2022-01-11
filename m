Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDC6A48B308
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 18:14:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343920AbiAKROz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 12:14:55 -0500
Received: from mail-mw2nam12on2049.outbound.protection.outlook.com ([40.107.244.49]:36192
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244420AbiAKROw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Jan 2022 12:14:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J9ty2+ahl8MpUQ125PpTHCCBf/KSx74sm0lth0HYtttVl6IanALlQ8reQlWkkYQwzU9LhzImDA2reAUAnM+u8AeMB/0ScHMVu5JqlcahER6EWH77DJd5ANZk2Eit7FgW7E0da6K/rP0fG5cYF3myv9Z75RMrgxeVfBL04A1X2eN/BLg+/W/xMzRCodbMdY6bxUFcu21uyaOQQSTfxfN2DNQo+6hi069VYj/ybiryJ1Lau7jh7V52S0XIow2cknhbC8hooBxgphpi7ggqcL91AqfunLMhp6hAJSEkh16BGSUvbpj2QdpfHd0OLSRDsjy8zY8phfYT3CZ1cZ2CVbsJmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pdhi6vLAeWe2bzUCmXW6Nfs161aFeEl02nlWgRRDz7Q=;
 b=MSmTtoCF5cJ0TL0bdZ1l0jcPKM49nVN3EI/TobryW0bUMP9StGWR6dcRqaSZRMBuQbcFrj9K3a0qliFwgaPS0GbgDmZvbE1G0CUU5llJkGMUrfeA9wEKGV+veQ/0l+hMipwVpUvNcbJ8hNHvah40asVNbzrZVywrqIfBZG1u7kgu+rMmCYDEw50WoSApF89ewR7MHs0FkRgmdiAEJWW8h5+Z0IkTxHJIiRRoOeEipmp8Tv99dGRbtVAu7PDQa9MXCdEgmPtQYiAZwBB80aGdroNEHz2QphMmzwvGpokeiudrP5iPT/Gd5cnYcr2GBTcj/SUrhZZPDl1eGi1QuinkXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pdhi6vLAeWe2bzUCmXW6Nfs161aFeEl02nlWgRRDz7Q=;
 b=F6ZBjfe7YTCF2iIk8l3fcj16fnFwIcSmrx9nIdkZQ5ZEVy4t6ijJxbQuU3tKCLvWDnK1LxO0ob20j0HTJjLD+BB4I4eP6wptPRjjip1ynIYO786vPnaK3mFz9tRkrObTNVPuOPBBBqUc5bN384i9HvttPdJ1Vu2I2ULtF9wCnkY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by PH0PR11MB5595.namprd11.prod.outlook.com (2603:10b6:510:e5::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Tue, 11 Jan
 2022 17:14:48 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::d031:da9e:71a:73e4]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::d031:da9e:71a:73e4%6]) with mapi id 15.20.4867.012; Tue, 11 Jan 2022
 17:14:48 +0000
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
Subject: [PATCH v9 01/24] mmc: sdio: add SDIO IDs for Silabs WF200 chip
Date:   Tue, 11 Jan 2022 18:14:01 +0100
Message-Id: <20220111171424.862764-2-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220111171424.862764-1-Jerome.Pouiller@silabs.com>
References: <20220111171424.862764-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: SN1PR12CA0099.namprd12.prod.outlook.com
 (2603:10b6:802:21::34) To PH0PR11MB5657.namprd11.prod.outlook.com
 (2603:10b6:510:ee::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6aac5540-59f0-4782-bfa2-08d9d525df45
X-MS-TrafficTypeDiagnostic: PH0PR11MB5595:EE_
X-Microsoft-Antispam-PRVS: <PH0PR11MB55958183D3E3D4B333369D4893519@PH0PR11MB5595.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sNisIf/0BvcPVIkXEc96d/M7gPcgH1IC31R+xLcy6Tdo7cErzWnZE7hGLwxIk69LmQCAC5Vo1WrDFoAHuZ73TbFiVXqckIrStDbMlGcU5Ko0J3fF++IUG78LCWDY/Jdlj60L7nx+nrdNvQBoPZgefay2YE2RXmMGI6GTAkxN+1GyAqC3sTLlZ2tfmDQ/wcbLy+oS9AyIg1moemhAIwkXRAimDVfsH4Ilyv2A/CKPXoMTppWUXpJpOGoy4xEpZuaKjfPXad4y6ZhsFvk7/3ljCC5eElqr0uwhoHUcDx6gp3+xrl+6WXZqCUzLNC36ahrRsn8mStcca5KmNYlph4NKRGmPvK5FR520UyuqS800J/7q1lHjGysj57Pi6w2wk6NWovcqaqNKTX7yqXRjXo4H+dlMloBKcO9jE+q03cytuiI1Bh4J6CeUbBR1FFN1J/VgXYLsh03IvpqnC65PyvxIMhOYOcYySVWVrvh8iOAlYJ8JCKHnCO8IvBGGiRymDqt1MaKGvT0ZfzguR3qNxrIr/0HpQidNhD4CwpOcni1PRIXmUztHDmaGUKkB//9kPd28GlDXN8kjVImYLu0uzVXfUY8K+J8NBmb3UTOrY2Y9IhRwanLxKh4vH8PA4ykUHfjJ64LcMcdWS50HgZZVpuc7Ow==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(36756003)(66946007)(6512007)(2906002)(107886003)(8936002)(2616005)(7416002)(6666004)(38100700002)(6506007)(4326008)(66476007)(8676002)(54906003)(6916009)(316002)(66556008)(52116002)(86362001)(186003)(5660300002)(6486002)(508600001)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S214R0tiYnYwc3d6VW9TZ2JiY3A5WGUwQlBtTWhlMFJwbFBZMUdlL2Fkcm41?=
 =?utf-8?B?UzdrRCsvNFMxNmg2RW1NdjhKV29HTlQvZWtLSkFtdGxDNmkvRG9QZXREVzh5?=
 =?utf-8?B?UjFsNUdEUXBKSU5rSTUwVmpoeXRhZGFVaHE0TzZTUDJxaXJWaEFXZVorUW5I?=
 =?utf-8?B?Sit1ekpSaU1GVXNab0F2T3RQbUtNSGZWajhWeHNsRFhhbjFKR1hoeVUyQjVk?=
 =?utf-8?B?V09RZUdncVVSZG5BNXRRMUEyZXN1WFA2MGtjenhnMzlyUGE5MHl3UW8zR0FW?=
 =?utf-8?B?QkxLa3puR2VuS09CU3N1Ukd2Vko4SWxSWDBYYlhCT2FaUDNSRjE5Njdwam9O?=
 =?utf-8?B?US94bjgzQUVtOGd6QVhTWmFnZ1lMTE8xNzBQT3dvM3RtbkIxbkZIY1A5RVhu?=
 =?utf-8?B?NFNoVWdtdUNYSlFIM0pJcjNJUXgrTEFsRU5uRy9sTCtuZ0k1VHpGemI4aG84?=
 =?utf-8?B?c05HQVZDb3NkbS9CZ2preXdjVUJ6QkdyWW9vLzBHTHJFMzdFTnptaTRiVnJv?=
 =?utf-8?B?YndZUTB1aXRMYTJFOUR0U1NWazRwVFJWdWhhT1NKcFY0L1ZhOVUveG1LNzhL?=
 =?utf-8?B?MFpaQ2RFbHMxMDRQMHQ2YUhFUnhZU1ZxMnQ3SFZxK2FWYmNhTnM5TFNkU0U1?=
 =?utf-8?B?VFVLNzZaNmZwVG9kYVQ2TjhTdUNweGhiQi9KREN3MXc2MFV6MHlpM0FMTmJG?=
 =?utf-8?B?dkR6aVA3YWtlMjUyUXJaWnM5SklCc1hGZ3VqYS9vVk1OMDVhMnlPa3p5dkNV?=
 =?utf-8?B?dC9ObEhvelI2NjRtc0c2dXdRSU9rL001NmxEdFBkSjJXYmpGRWJaZy95MGtC?=
 =?utf-8?B?c29mZUsxMFVpK0JQMEk5YmgrZ09LNWJ4TUVZbDVzM24zYk5BUU9uelJ3N3hy?=
 =?utf-8?B?VHlWWGVpWEU4a3NOVzNHdXlRL3QvaXpFSkNtc1pHM0paemFNQnoxcis1Mzkr?=
 =?utf-8?B?VHYrNUt3K3lnVXZJRUwwM3JZbWk0bEk2Um50aE03ZWJHbFZWcVJ2VTVvZ2Rq?=
 =?utf-8?B?RSttTEF3V1hJNE1ReVF1Lzc4R2VoRmIwMTd6L2FvRWhLQzMzeGt1U05oMTdX?=
 =?utf-8?B?bEl2bFRwbVlJNHJreG1tcHlYTytEWmFGMVhBYlN3azI3dGtYZ3ZTMUZnaGFP?=
 =?utf-8?B?ZWFwMWdtSHpoa0loVE1CTS9tbU0vbEVCZ1NWdFh6Y1l4bUEzR243YThFeVR0?=
 =?utf-8?B?bENGaXk3alQ3cVZWODl2eDcvenhOZzNTLzJtdDVmTk1yVEJxTDUvWk0rTDU5?=
 =?utf-8?B?T2xCeFVSaHJMRVpuSExMVmxpcE9KbzR0Y2k0b3B4d2F3TUh4SzZLdmRpb3FR?=
 =?utf-8?B?REVERnhnNXQ2OVY1N3FPaTFGSWlXRXkxeDAzUFNMUm5VN0hPcTMzNDg1ZHpL?=
 =?utf-8?B?RGFkQXdwNUhtTDVaSzBraFRoUWhMZXU5c2o5d296d1IxYVlRdmJ2K3JVTHRY?=
 =?utf-8?B?TFdlUTUydFVicjBhNkVIbEdzVUpmcm8wYlNyK20xSVhDYUM3Qy9oNjNEVE4y?=
 =?utf-8?B?di9VVkgwNXhCWWRJbFIva3RaOUY4clJvN2cyUUZod20yOXE3b1RHRDJFSjg5?=
 =?utf-8?B?b0NCUFp0Qy91L3d5UllCZUZuNWlka2J1Qjd5MWkxM24vbVQ2TG9PUExTdFc3?=
 =?utf-8?B?SWpXQlpFN0tEMlJjQm0reWwrcElRUmEyUEpnM21kMkFGY0lCSWdKVU13MXNv?=
 =?utf-8?B?NnIrbjZSOWgwWUFxUTA0ZWdlS2NhdkF0SGxhNFJ6c1BtODlSS2RuZTd3OEox?=
 =?utf-8?B?NVBkWTMyTmFRaEVObWpJTmo3V1JJbjFlVkhXbVdBK1g5ZnpaTzVVblVPMHE2?=
 =?utf-8?B?UnpUMmVpNCtRU2k2RUViMjdMSE5LcWhNQ1ZscWpXV1B6aFcxbFNwbHJKRDFi?=
 =?utf-8?B?OFhGakFUZC81TXM3K0g3VW50a2FPcFdGcHhoclk2WmdhcnlWbk8vZ0dJWjFC?=
 =?utf-8?B?RmVqK2I4U3dyT3kvajdXdGtPOW1zcFd1bzhENzA5YWhpSUFtOWlDYktRa2RP?=
 =?utf-8?B?OWR6UUxQbEZ5YUdMbTREenFFUHJiM1dLbHhHbXZHeVBGR056clA0cU16MlMy?=
 =?utf-8?B?TTllOTcrOUc1ZTZBTGZHUkpCdlZFRUpGb1lJVHpvRmlhWERCUHpnNHp6Nkg5?=
 =?utf-8?B?QTlmdVlOeGNzb2xwVStuZHgxU0Q2SUY4R3BLWGxueTFLSWl3NW5EdldPNUZa?=
 =?utf-8?B?OXJJcGdqWHFxeE1NQVYvVFQrNE9xQW0ybkNRcDhqbjFMUWViSnoxQSt0Rk1K?=
 =?utf-8?Q?WLvxTTKzHsDSl2DqiVHpRrdAt8t/ZNt2L7KySIxfvY=3D?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6aac5540-59f0-4782-bfa2-08d9d525df45
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2022 17:14:48.8375
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nzo8FkP1UqriSNYZKKoVI5spiZVQLpyVf5lh0WKWA9T8hnF1kl9nQ4xbpZ/NHnUU6pdHilcIEnNUU2WZORb0AA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5595
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKTm90
ZSB0aGF0IHRoZSB2YWx1ZXMgdXNlZCBieSBTaWxhYnMgYXJlIHVuY29tbW9uLiBBIGRyaXZlciBj
YW5ub3QgZnVsbHkKcmVseSBvbiB0aGUgU0RJTyBQblAuIEl0IHNob3VsZCBhbHNvIGNoZWNrIGlm
IHRoZSBkZXZpY2UgaXMgZGVjbGFyZWQgaW4KdGhlIERULgoKU28sIHRvIGFwcGx5IHRoZSBxdWly
a3MgbmVjZXNzYXJ5IGZvciB0aGUgU2lsYWJzIFdGMjAwLCB3ZSByZWx5IG9uIHRoZQpEVCByYXRo
ZXIgdGhhbiBvbiB0aGUgU0RJTyBWSUQvUElELgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91
aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvbW1jL2NvcmUv
cXVpcmtzLmggICAgfCA1ICsrKysrCiBpbmNsdWRlL2xpbnV4L21tYy9zZGlvX2lkcy5oIHwgNyAr
KysrKysrCiAyIGZpbGVzIGNoYW5nZWQsIDEyIGluc2VydGlvbnMoKykKCmRpZmYgLS1naXQgYS9k
cml2ZXJzL21tYy9jb3JlL3F1aXJrcy5oIGIvZHJpdmVycy9tbWMvY29yZS9xdWlya3MuaAppbmRl
eCAyMGY1Njg3MjcyNzcuLmY4NzlkYzYzZDkzNiAxMDA2NDQKLS0tIGEvZHJpdmVycy9tbWMvY29y
ZS9xdWlya3MuaAorKysgYi9kcml2ZXJzL21tYy9jb3JlL3F1aXJrcy5oCkBAIC0xNDksNiArMTQ5
LDExIEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgbW1jX2ZpeHVwIF9fbWF5YmVfdW51c2VkIHNkaW9f
Zml4dXBfbWV0aG9kc1tdID0gewogc3RhdGljIGNvbnN0IHN0cnVjdCBtbWNfZml4dXAgX19tYXli
ZV91bnVzZWQgc2Rpb19jYXJkX2luaXRfbWV0aG9kc1tdID0gewogCVNESU9fRklYVVBfQ09NUEFU
SUJMRSgidGksd2wxMjUxIiwgd2wxMjUxX3F1aXJrLCAwKSwKIAorCVNESU9fRklYVVBfQ09NUEFU
SUJMRSgic2lsYWJzLHdmMjAwIiwgYWRkX3F1aXJrLAorCQkJICAgICAgTU1DX1FVSVJLX0JST0tF
Tl9CWVRFX01PREVfNTEyIHwKKwkJCSAgICAgIE1NQ19RVUlSS19MRU5JRU5UX0ZOMCB8CisJCQkg
ICAgICBNTUNfUVVJUktfQkxLU1pfRk9SX0JZVEVfTU9ERSksCisKIAlFTkRfRklYVVAKIH07CiAK
ZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvbW1jL3NkaW9faWRzLmggYi9pbmNsdWRlL2xpbnV4
L21tYy9zZGlvX2lkcy5oCmluZGV4IGE4NWM5ZjBiZDQ3MC4uNDgzNjkyZjMwMDJhIDEwMDY0NAot
LS0gYS9pbmNsdWRlL2xpbnV4L21tYy9zZGlvX2lkcy5oCisrKyBiL2luY2x1ZGUvbGludXgvbW1j
L3NkaW9faWRzLmgKQEAgLTI1LDYgKzI1LDEzIEBACiAgKiBWZW5kb3JzIGFuZCBkZXZpY2VzLiAg
U29ydCBrZXk6IHZlbmRvciBmaXJzdCwgZGV2aWNlIG5leHQuCiAgKi8KIAorLyoKKyAqIFNpbGFi
cyBkb2VzIG5vdCB1c2UgYSByZWxpYWJsZSB2ZW5kb3IgSUQuIFRvIGF2b2lkIGNvbmZsaWN0cywg
dGhlIGRyaXZlcgorICogd29uJ3QgcHJvYmUgdGhlIGRldmljZSBpZiBpdCBpcyBub3QgYWxzbyBk
ZWNsYXJlZCBpbiB0aGUgRFQuCisgKi8KKyNkZWZpbmUgU0RJT19WRU5ET1JfSURfU0lMQUJTCQkJ
MHgwMDAwCisjZGVmaW5lIFNESU9fREVWSUNFX0lEX1NJTEFCU19XRjIwMAkJMHgxMDAwCisKICNk
ZWZpbmUgU0RJT19WRU5ET1JfSURfU1RFCQkJMHgwMDIwCiAjZGVmaW5lIFNESU9fREVWSUNFX0lE
X1NURV9DVzEyMDAJCTB4MjI4MAogCi0tIAoyLjM0LjEKCg==
