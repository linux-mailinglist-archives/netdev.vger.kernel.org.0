Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 355E1292B1B
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 18:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730606AbgJSQGb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 12:06:31 -0400
Received: from mail-bn8nam11on2051.outbound.protection.outlook.com ([40.107.236.51]:30081
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730190AbgJSQGa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 12:06:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vtu/45nKEnYXNC8dL7MYWMtkvw1aNwn5AxMg+3eWP7LERcIGwvKQeAVIYM8+Az2sxxSPdnjQGeUSCb3GdmKjs31WFO3wy9ZEk8VjNAejPd6v0mjsW9Cd3LCy1tGqplxaBIgu+nHpF/J6iwleyooavHpVSfxlanarMeEmkPTKLdxGEMZedKWywlnWuek9VFXYd36kRNd7NFGi9tSJzrmian7xCPK2oTotm+aqDoa0Idl9lbH1hmJiYewRZv1KIhUGebzeR6USE3P014O+7MEix+E8rrqU7O6SJJ6HohUB9BNgYhtpNxKZPYFtWaA04UZycY6c0dphNMtALguxG44PxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OrVmGnYd1sTf5Jfe5yYrsZWrEGpwvZpR3asYJu/1aNE=;
 b=CWvz7/Xp8uHldkTN/kSp4uFQcqCANDO2lOkz8sstl0w5ALr92r7tDqzRBUVtWQcGc6b3m+yeK6vEgMxm/u/uTWL+IiyAOPgYuh/cCa+5mg1LmEzlLjB0iQiX0f3nL9AO/F/Arz89hoJJyNvz6UWwaiNKVLRho2WiQJ+DOFUzjKtWmejiSdg06XmDNXzrdvVkDzPFEBjffs1ov/446tW5BOlPKCmMlWQnUdhctmgrgFr8+Md1DFwF/uoITZsEuiV2wlEvam63w1xbz0gqQowkzGnO8Txa+kxZBHyE56ls2Od2r2s9M8zyKdlhdqn9LEBjNQ7UnklrezewiuY7/6hDQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OrVmGnYd1sTf5Jfe5yYrsZWrEGpwvZpR3asYJu/1aNE=;
 b=kES9jFkFWLjZLl1mA1+gznyL1yA9Zq5DMPTyBlyCZv8wg9S+z7gM8+xAym/gUAhZEvd6jX7Y6tnA8mfCNz5l4DTFzAVSldk2t9dUlFdU8ECh5XmtkJEluav3PAnjYZ8zxmf1lqJm/rDNfpI8wXV8xPyiBsKKIgLwdVy8PHVYhuM=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA2PR11MB5129.namprd11.prod.outlook.com (2603:10b6:806:11f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.27; Mon, 19 Oct
 2020 16:06:26 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::4f5:fbe5:44a7:cb8a]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::4f5:fbe5:44a7:cb8a%5]) with mapi id 15.20.3477.028; Mon, 19 Oct 2020
 16:06:26 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 2/2] staging: wfx: fix test on return value of gpiod_get_value()
Date:   Mon, 19 Oct 2020 18:06:04 +0200
Message-Id: <20201019160604.1609180-2-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201019160604.1609180-1-Jerome.Pouiller@silabs.com>
References: <20201019160604.1609180-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Originating-IP: [37.71.187.125]
X-ClientProxiedBy: PR0P264CA0225.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1e::21) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (37.71.187.125) by PR0P264CA0225.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1e::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21 via Frontend Transport; Mon, 19 Oct 2020 16:06:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 686f16c5-60c3-4945-cf2d-08d87448ee87
X-MS-TrafficTypeDiagnostic: SA2PR11MB5129:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA2PR11MB512979DCE30A9789CF881E98931E0@SA2PR11MB5129.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:206;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RakpDgJU9cOwW+mx2NQWfz5tCigeUJklOEK0FhYQEsdrxSv45StUjgQHHJqvafQQVCO2EP3qPodSd+8fLz09OnU+BGtsb3o7wZeWlDTHjVZFTU8C67wAjT8mpqhHHNC1+Y7fOA0Lm8PIH29HU9jNcI4e9tuByG0AC1xiX9b0ePqgHCVJ5qfgD/ZfJedaaLqC8+diWBgprfGJijSOqt+NaX8lbmpBdIT0FUVNeS3ZbGt8bnTKDkhpXmtLqXJKGKaIy8oh7MLUGsGhvn7kGkAuXlb9SadSYEcXZrm6kvrYVdDWK59ULOOzD3hOKgXJknmQ8ocnA1ykP/SOefxnAFTR5g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(136003)(396003)(39850400004)(366004)(107886003)(26005)(8936002)(54906003)(186003)(6486002)(16526019)(316002)(478600001)(8676002)(52116002)(7696005)(6666004)(2906002)(4326008)(1076003)(36756003)(66574015)(956004)(66946007)(66476007)(4744005)(86362001)(2616005)(66556008)(5660300002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Uj5FAja5K/gFPmFDRj9Kt4H5zfOLaKp+JONmpobPUoXSEAeIX5RfdKoLbVqcGq1YJb5w27j11tnpJXcvBJWLJ7GzZ9vA+qF9W0x/fHijVUl+u7q2VirXaBuQz9C2GM8oN7n267rKeRCLoj2KV2EQD2imU+C+VFyiMz/S+ELxgUuSFi6E0s6kuANXL/1BH7Feyz/Z/KSznUi6w1CFPb8KlmVMpKh0LjnKVRnADUI4HG6kIUSOPaJW04MkwWfl6wm9ipEGpxO22Q68btZGOodZbuFDT+7wWwUY9wEc7VKutW98+XsgcTKtIzBsr8gJ2MG/Y4H0C52FYvc5ikUyJeYcCamAQaQRFXn3z65bjPOoIyBehqfKLnlcNcSHNXTABeMv5wUE4xdDHHzII50GHK9jfnEmlK1t20Rwe23j/2rfC/Mzq/AkZ416HeuwycYkDNn3LEJpboeZzJ0pB1ujccnvo2mDr+Y8pX6P+lbDoIc7R43vVaFirO4cB0pLK2xy7V+7544qFAvwQcar8IjpTD2MGzR2/dZwvGyY9thamZy4V62WQeYU3p5hA6p1X2YNICo9rdCwYit9fZeonMS8NyTW5TuBM/NxUVcok/T7S4daJvewscgyHc++5/VpdcASswiUy8gGFAufdyHABRBzRrtIdA==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 686f16c5-60c3-4945-cf2d-08d87448ee87
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2020 16:06:26.5158
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w9LV7wHm6DXIYACLpaOKRGFqSHCiEs4rFeFq7mbddphZuI6m3r1jdLGwVJCJMoZNDrO2R8HdDpOjLt8U53w2Gw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5129
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IGNvbW1pdCA4NTIyZDYyZTZiY2EgKCJzdGFnaW5nOiB3Zng6IGdwaW9kX2dldF92YWx1ZSgpIGNh
biByZXR1cm4gYW4KZXJyb3IiKSBoYXMgY2hhbmdlZCB0aGUgd2F5IHRoZSBkcml2ZXIgdGVzdCB0
aGUgdmFsdWUgcmV0dXJuZWQgYnkKZ3Bpb2RfZ2V0X3ZhbHVlKCkuIFRoZSBuZXcgY29kZSB3YXMg
d3JvbmcuCgpGaXhlczogODUyMmQ2MmU2YmNhICgic3RhZ2luZzogd2Z4OiBncGlvZF9nZXRfdmFs
dWUoKSBjYW4gcmV0dXJuIGFuIGVycm9yIikKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxs
ZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngv
YmguYyB8IDIgKy0KIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigt
KQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvYmguYyBiL2RyaXZlcnMvc3RhZ2lu
Zy93ZngvYmguYwppbmRleCAyZmZhNTg3YWVmYWEuLmVkNTNkMGI0NTU5MiAxMDA2NDQKLS0tIGEv
ZHJpdmVycy9zdGFnaW5nL3dmeC9iaC5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvYmguYwpA
QCAtMjEsNyArMjEsNyBAQCBzdGF0aWMgdm9pZCBkZXZpY2Vfd2FrZXVwKHN0cnVjdCB3ZnhfZGV2
ICp3ZGV2KQogCiAJaWYgKCF3ZGV2LT5wZGF0YS5ncGlvX3dha2V1cCkKIAkJcmV0dXJuOwotCWlm
IChncGlvZF9nZXRfdmFsdWVfY2Fuc2xlZXAod2Rldi0+cGRhdGEuZ3Bpb193YWtldXApID49IDAp
CisJaWYgKGdwaW9kX2dldF92YWx1ZV9jYW5zbGVlcCh3ZGV2LT5wZGF0YS5ncGlvX3dha2V1cCkg
PiAwKQogCQlyZXR1cm47CiAKIAlpZiAod2Z4X2FwaV9vbGRlcl90aGFuKHdkZXYsIDEsIDQpKSB7
Ci0tIAoyLjI4LjAKCg==
