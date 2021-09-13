Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F7EA40870E
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 10:36:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238217AbhIMIgl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 04:36:41 -0400
Received: from mail-mw2nam08on2066.outbound.protection.outlook.com ([40.107.101.66]:47168
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238166AbhIMIdh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 04:33:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LhYEvV9zTkLOBDbHJp24P/22X12a3MyV5YAzabNMy5sfu1cG/1DHzmVTK+YKOimdcSlzcmI7+ecEWbso/TqKkMTiXzEJyE5U2Mo1D/l9n2Klzt6UUge+i5aimNJXQEjoPaniRmLerBIo5TWckS2KA7rodnchCqa9PoLEoxNQCGjw4DiFRx9kkFMWCq0cl9svQ3Q00RpF5Hx592t0F5A7mmXJQ6R43gOxqKoUdJOJ13kQqml+mQxRZDO9p/F1V6Uxs5hGTTA5F5Pu9tqc/dQ58cxfAP5hQgS8YqJqzKgclE/4AC/MpNxcYQ4j+4uKAo1aO2nnyvNVW75NEunHE9Ql9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=zepjhr/9IN2TlKMACudigtOtb0JfVXPJtJXaDzy1Q/o=;
 b=bIPqRwJFsy7kbgNrQM7Yv5BC5hRMTa/tubMYp/6xG7Iv/6Y8i4Mrf0oLH7RcATNqoVxiTnWAZYUMy7GERXB2XUXPrY56v8UwWb9IWq5yAlLkQiMaLh3iypZhuzq3WtkqCPOohQCAPgQ/V+FXmQFrxfqH9TJAZnb+Ydi7DJBt0qBn3j665emvrckg9zqqRG/2N5DDX0z9zKo8WtOj50DR1CW/opWOxe4ibuYbJcjRCsPG3RHCV8IpTP257m7hj6FR+D7f6rRf46vQRSSb5y5ySZDfPUL6ptcpY/OoPf1Qfrelinlc//ELJzayPc9hFUN09/1fD4ZwV1lswD6P4eg27g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zepjhr/9IN2TlKMACudigtOtb0JfVXPJtJXaDzy1Q/o=;
 b=B/zYWNxA5yAtz9rVVVvkcfxDEBXmCvjaISXsAgaMWorNmt0vbxo9HoEhAvyp/mlkDqHQ1RLswvMv9sqP44rPaA5l08F5tGeaRRen6vq8OQEgvF6pqhct6IAb4Or+5pY3d+azV3aJP6X3Ov9TSWMQ/Jz6tMoflejxC8dmS0PgHZ4=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB2717.namprd11.prod.outlook.com (2603:10b6:805:60::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.16; Mon, 13 Sep
 2021 08:31:58 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Mon, 13 Sep 2021
 08:31:58 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v2 20/33] staging: wfx: apply naming rules in hif_tx_mib.c
Date:   Mon, 13 Sep 2021 10:30:32 +0200
Message-Id: <20210913083045.1881321-21-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913083045.1881321-1-Jerome.Pouiller@silabs.com>
References: <20210913083045.1881321-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PAZP264CA0067.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:1fd::10) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (37.71.187.125) by PAZP264CA0067.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:1fd::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 08:31:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 812a8717-129c-492b-7668-08d97690e89b
X-MS-TrafficTypeDiagnostic: SN6PR11MB2717:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB27176ACA133D38FE615C4AF993D99@SN6PR11MB2717.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EuyBiNLY0Uh5N3S8FzWzHdCaTgQlknPsmC+6sqTO1WsJw5r7r+QJojYenBVNs0Ti82AxD9I9Wiovwg0LreB+yuVxO4e1PsuGwtF6IEychsy69u9jY5PNIj29oOUixk9p4EBIqU0BzY6myvSVAowRjUeH7IU/ZbWyH2CQckZUYneZ1gr0oh3Yp641IwH+cyAE8VWE0sdOgqJS+Ws8Xo2cCAcus0GLjHyCqAoYZA23Ze0+XEmnPjk8I3nkP1zrQeRhbxfAq2/XuIJSM9PIN2b0JPBqPgIvEDj+ZESNVwb5flyv976fyHR0JQm7w9F5uT2zENI0iNaGZFVHNbF0Z6NPUn7lvByCSwqu65BLKqUzuLfiAjXXnDYPojokwxdX8LknUrhLkTcbpGgaWpAig6jzYiAMqZdoTwcgFJ/fefOssHhr584ni9f6xqR6jQ4uxbF8SamwFXTkkZ4EWmZSqD4Q8OSIXra9GCMF2Asyk2q4Gn7iD9R2PL2m1viW9zGz4lMbCRdVJf9+Pf91p7ku4fnMWCRd8Bg9TeFZGAcZQwwbJWTyqoE4NWoXL71PEWxyqgku/qc70QlQtMOIWDnO9EeeUEdvWr9xtlId6LelhoONozNMNJc5SIlHwyXyDxzq70ebK/bm8HpGEqdf+9htA//5n8SDMaxE0eN4LH2Myjk5gOkRHhGkLCxkGr6j8fG3QvgBC586yQa0J95ts+YcPHGJRg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(2906002)(107886003)(26005)(66946007)(38100700002)(52116002)(7696005)(1076003)(956004)(36756003)(316002)(8676002)(38350700002)(186003)(8936002)(83380400001)(54906003)(66556008)(66476007)(508600001)(6486002)(5660300002)(6666004)(86362001)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q1VTeStQSEYyOXRpaFVMdFFTQW5hU2ZEUmN5OGNUNnFDd0w5TFNISnFrckRn?=
 =?utf-8?B?aGNqNG1OVFdIS0drVllQWS9QeVJvaXBWZ0RGZWdYaXpGQmRLSWFkSkpSU1ZM?=
 =?utf-8?B?eWtVandhVHorQURaL1hoNEJXV0JDdUNOdFhqMjdVMlYzUXVBU2lnazQxdXV6?=
 =?utf-8?B?bVhtci9sV25wZUs1eGowVmlhR0ZXOHdPOGlPUS9yL3VQQmYrc1hGR1ZuMWtz?=
 =?utf-8?B?N1l3bS9keHc3bW9uQmVFY0JjV3JuV1IxVXFlNDZoWFRFUXdoZ3dCcFBGZmdq?=
 =?utf-8?B?UUxPNEFMRWlvUTBJNWdWREp5b0tJV3o3ckpXWVdwNExSMDFOU2NuRmFQaDhN?=
 =?utf-8?B?N2ZwdnVSUDNLSWVPM2ZFT0w4NGQ3S21KZG5qY3AxbE8xYTJjdHdSWnJrbUp5?=
 =?utf-8?B?T0UyT0RlZDd3UWRreEdLckFvUHRNT2g1UVlnelhSYTVxMnE0NkJqd09kSm5Y?=
 =?utf-8?B?cTRSL2pDRTlrOWE2R2JNcWhkQXRLN0dNZTNNTXlJMXU1SkJuV0wyb0ZUaHBH?=
 =?utf-8?B?ZG01d0VHd0hkWlNzOVNML3hsSmpDdEhhekRyZUlZWGI5eTlJWEpTZEtReFdD?=
 =?utf-8?B?YzJzRjBTeEZUWW8vSUdFelV3dEg2MGhYRmhEcjhiN0xXMUkwYzZHRFRMRWM4?=
 =?utf-8?B?QTZOUlI1TEFqZVdUYTRaQllmdjBrWmJuN2Vobm9rTE9jZWtBclh5dFM1cko4?=
 =?utf-8?B?SkZORmgvOGlWRDhjYUcxMXFqbkhjVmJ1amtXeG9iNlVVNXZCOGN5QysxVzhi?=
 =?utf-8?B?STRHV0pyVFNPM2FBcTB1SnIzb2JtbnovbnlyV2VQNXF6NmU2VDFsSjl2MEVx?=
 =?utf-8?B?SlVTM21iN0JOVHNrdm15RURvc2NYWkw3UnNxRzVjVUJXS0xVUDVidjZwTEly?=
 =?utf-8?B?ekNHVkVoRFNiTGNGa0YraTZGM0FlTUM5akswcGc3MTRidVpWaWtseHI1MEZs?=
 =?utf-8?B?V3IvWnlDOVlpUEltckV2TkRieU9RYnEySTFjcHB0R1FWSkxmNElTN0pIay9P?=
 =?utf-8?B?azZPUTdJU2hJdVoxNWp6VVkrN3JNV3AyR20rSWlKd21IQmNKaTFjbFpLdENG?=
 =?utf-8?B?VTBUcjdpc1NRclhISjJXeG90d3h1QUNHRGZ6dzArc0gxcmtwUFkyZW9vTnI2?=
 =?utf-8?B?ZTNqcG9Md2lGQkZPK2lvNHBSNlZsQlA4aHNlT2Radm9HZXh1Y25sZmNremp6?=
 =?utf-8?B?OGFaUnlHQk1VcUJtZGd1Z0JlUW8vV2Q3QUdkK09JRXp4QkpEL2JFdnE1T1NY?=
 =?utf-8?B?Nm9PN0hBZEp3NWhpN2xSWW1hdGwvV2twbW1OdUtzcGV0bGlIRmFYR3FMNzJC?=
 =?utf-8?B?bERENnBpT2dhSFl0b2psZDBlNWszS2h5elJyb250b3ZqZ3ZOVGdTY1h1cDVO?=
 =?utf-8?B?M3BxUW1qT25GdVFSWVpkdnR0RW1NYXRlTEU4UjR3TzRQalVUaW51bFNSRVRi?=
 =?utf-8?B?djgvOXBsL09ZdnJ5ZXhBYkZKR2g5REpaOElWeGdsV0YxTllybnltenNMTFNo?=
 =?utf-8?B?RVdHUmdCYUczdXdOM1NiNVFsMEdVTy8rVHFQekdlRUROem5WUVJLM2R4TGdJ?=
 =?utf-8?B?VFF5RThKbDcza3MzejFUS3hXVDV0N21pUWc5OFU1UUc5akxTa0ViRkFpcVAw?=
 =?utf-8?B?OWNYVk5NN2pkdGtsUnFpR2g1YVpTUmM2ZTNTYko3OUowYllQTGdMYnhRdnE0?=
 =?utf-8?B?bFF1Nkp5YkF5K0pGRm5DMVV4TUJpclFEMFAxUnVyTjZ0NWRGbDdiRUw2U25Y?=
 =?utf-8?Q?cqZCF0KDpwn09lcE+ZOdwtWRLFGWlLLm6etVcT1?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 812a8717-129c-492b-7668-08d97690e89b
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 08:31:40.0545
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zb1ZcbmvDkFdBDDhrbVjb7yGpe4hgKHAOHIiyTD/jftewXjW1TxXr/svm+ggk7uvFMTmxm55vyBpCBgwMxAxoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2717
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKQWxs
IHRoZSBmdW5jdGlvbnMgb2YgaGlmX3R4X21pYi5jIGZvcm1hdCBkYXRhIHRvIGJlIHNlbnQgdG8g
dGhlCmhhcmR3YXJlLiBJbiB0aGlzIGZpbGUsIHRoZSBzdHJ1Y3QgdG8gYmUgc2VudCBpcyBhbHdh
eXMgbmFtZWQgJ2FyZycuCgpBbHNvIGFwcGxpZXMgdGhpcyBydWxlIHRvIGhpZl9zZXRfbWFjYWRk
cigpLgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBz
aWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4X21pYi5jIHwgNiArKyst
LS0KIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pCgpkaWZm
IC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHhfbWliLmMgYi9kcml2ZXJzL3N0YWdp
bmcvd2Z4L2hpZl90eF9taWIuYwppbmRleCAxOTI2Y2YxYjYyYmUuLjE5MDBiN2ZhZmQ5ZSAxMDA2
NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHhfbWliLmMKKysrIGIvZHJpdmVycy9z
dGFnaW5nL3dmeC9oaWZfdHhfbWliLmMKQEAgLTgxLDEyICs4MSwxMiBAQCBpbnQgaGlmX2dldF9j
b3VudGVyc190YWJsZShzdHJ1Y3Qgd2Z4X2RldiAqd2RldiwgaW50IHZpZl9pZCwKIAogaW50IGhp
Zl9zZXRfbWFjYWRkcihzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwgdTggKm1hYykKIHsKLQlzdHJ1Y3Qg
aGlmX21pYl9tYWNfYWRkcmVzcyBtc2cgPSB7IH07CisJc3RydWN0IGhpZl9taWJfbWFjX2FkZHJl
c3MgYXJnID0geyB9OwogCiAJaWYgKG1hYykKLQkJZXRoZXJfYWRkcl9jb3B5KG1zZy5tYWNfYWRk
ciwgbWFjKTsKKwkJZXRoZXJfYWRkcl9jb3B5KGFyZy5tYWNfYWRkciwgbWFjKTsKIAlyZXR1cm4g
aGlmX3dyaXRlX21pYih3dmlmLT53ZGV2LCB3dmlmLT5pZCwgSElGX01JQl9JRF9ET1QxMV9NQUNf
QUREUkVTUywKLQkJCSAgICAgJm1zZywgc2l6ZW9mKG1zZykpOworCQkJICAgICAmYXJnLCBzaXpl
b2YoYXJnKSk7CiB9CiAKIGludCBoaWZfc2V0X3J4X2ZpbHRlcihzdHJ1Y3Qgd2Z4X3ZpZiAqd3Zp
ZiwKLS0gCjIuMzMuMAoK
