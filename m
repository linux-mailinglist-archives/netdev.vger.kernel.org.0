Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BDF040FB7B
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 17:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240455AbhIQPPq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 11:15:46 -0400
Received: from mail-bn7nam10on2080.outbound.protection.outlook.com ([40.107.92.80]:7236
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239752AbhIQPPn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Sep 2021 11:15:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A3HI8gj3jpWHUn/23jZRP/8Dl7QaYyaw2qX75h4gkkCR5OHlD/Kva2oIYR1i+iQnbfyfpW+cWgFCWomHfzo4oqpZ7TAm2kH/qO1VOpop8PTNg4qmJWBtTWCL9BkAShjUSRiueuRZyA6CnSUreT9gHHjAyWC/YC4bWdso40sxHWgeRa3dYv5d44V+2qSdsL1VL+KD1pBaEbZ1UIe/Li0/ZGpm9oogx6HgpguE4fiSsjXcXrHj4E+HrI1IDLPNInsLK1So30I3yoTsTTt1yfvLErm3iKlsW0zmcrBRFTusUFvddR/bftH3ZqYoS7euLAQMMVejE1J8vPWI0vF+KfvJbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=IyY90r6QMFMHTI+VFb7nrT6DVJW15/DHuG0/svc2nKU=;
 b=oa5yX/JTR6Rd3SUru1cljjqcRKDzvttKAVDfvRE5VcZlgTAz4Nz7t9jRx3WuOq1qiltIXpKHyCUH9OASx2tPqutQ6wS8v24ThJCOnhn/5j56TVB8JRzkahZI5Dhoi6XGCxID+kzKM1BfXObZU4KUCM1XXuMzu35m/TuzQMcptqNUb+Bj4AXNry+NfDCya36lx7F+d04KvyruCZAIq+xPV+wsj1lXyYVll9xx6Ew8Z62fzIkHAPcNe5gdPRgy4hbzx8xU1KBDPuoNVueGoSwO/Z0ET+k+W+dnmkXPclaewIKzH2gFKcAV54Eflmrl8scgTx3KEpwAS7nCiH5W3uHyWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IyY90r6QMFMHTI+VFb7nrT6DVJW15/DHuG0/svc2nKU=;
 b=C1Ns9MYywu2jIrBM6k+YEfRynt2tcTdZ/65TEMpC+e+/qhlUrW4W+ycOhY59wtNxnYJBtxFs1oib+xcIZgkLbLGbuFjLWct9YUHv+YTQxR5yglyuvGeIOfuEy3yUkmS87JGxitQpACw/Mgs6P77Y0XMdW89NQNqjQfdNcVnacws=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA0PR11MB4574.namprd11.prod.outlook.com (2603:10b6:806:71::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Fri, 17 Sep
 2021 15:14:20 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Fri, 17 Sep 2021
 15:14:20 +0000
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
Subject: [PATCH v6 01/24] mmc: sdio: add SDIO IDs for Silabs WF200 chip
Date:   Fri, 17 Sep 2021 17:13:37 +0200
Message-Id: <20210917151401.2274772-2-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210917151401.2274772-1-Jerome.Pouiller@silabs.com>
References: <20210917151401.2274772-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: SA9PR03CA0029.namprd03.prod.outlook.com
 (2603:10b6:806:20::34) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (2a01:e34:ecb5:66a0:9876:e1d7:65be:d294) by SA9PR03CA0029.namprd03.prod.outlook.com (2603:10b6:806:20::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Fri, 17 Sep 2021 15:14:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d36e416b-c293-4736-b508-08d979edd2d7
X-MS-TrafficTypeDiagnostic: SA0PR11MB4574:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR11MB4574D26F89E048B57D5F976293DD9@SA0PR11MB4574.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OAqXbcb+ojDT6ibvTKQdiZYhKkig7AaTxfGuDKeJihBD2//9zW/FAf5HZQmPM1KIoOps/zs4xRx9sJdQ/3GjcBCgxp5liYPJ/2qOBOTRDrixzFcnYVu3jZy+h9wk+h195QkjjeNq07SJv2nVHJZ6M8bg9tnzAidamDGc87vVDAcBMdTKM29wHiz07aNtNMd0I3LNQ1Dl6NJVFpBq0fzxqHWlbGJjowA3HCRCnCcODa+325PWkFTbK9Lr96ioyd3GMPJJdKv4hOQaEwi+3eWJ4UedNL2F7qdaPhxv/RDG/dZ3TDC/Moisp6rYSfeIDG2bxoCccKRaHovqeoiDwj1wirVcC1LCLGbXj+qs0/NibAN8ej+eTwT5cn++VrMl/EcNXYQ55LRJndbwNq4pPRNpWzDBoi1IwtDutdu8e6tiTiQD0/DGH6UL4vGXTVB20uw20ziZg2MsWioB8BCY+7HGW+PSPAvwszhKgrbGdGKlsMc3nAOe9xKxpEIPzROA/42Us0jS4B3mgfDT3cmN9ocDFnqDSZVzucFMZ1HiTetwIoqgYPC1S6GUo6fPXOolrG/tGSIgUMKwgjITFf4cdREF65A9sKy/CsttUcVfT28ySn2imi9vIna6uPEq94WKVD6VclOD9Udj7hfaOde+S1ZnFQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(376002)(39850400004)(396003)(366004)(52116002)(6666004)(38100700002)(8936002)(7696005)(478600001)(6486002)(186003)(7416002)(86362001)(5660300002)(54906003)(66556008)(66476007)(4326008)(1076003)(66946007)(4744005)(2616005)(107886003)(6916009)(316002)(36756003)(8676002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q2hod2krVlp0dGREZm1zTkt3T3Nrb1ZNd3ZObVBZRWVqRnRDZjVPeFhUYjJi?=
 =?utf-8?B?TlNqRTllcWM1V05aeUtoNm9WN0FDSWRWUWhTUEwrNFFmNFNTMUp4eDdxV1VB?=
 =?utf-8?B?OE50VTlwMWMyQ0NJQ1ZYMDNVYjQzaGFudDRYRVdoaFhraGtsQ0pqQTlwQlkw?=
 =?utf-8?B?M2ZDWTZCcFJodmx6ajN1MVdSRnpvVjlsemdKMy81QUg2b2FNUGRPUlFtbmlY?=
 =?utf-8?B?SGovaFlrcWQ3TkFLMzlWV3IrRTFoYVpXM0x3TjZldlNVaW1jdUVWVCt2aXBo?=
 =?utf-8?B?eW1FelJiZUEzM2k0VW52aldLdDdjV2FNaU9NdG5MY0VDYjd1ZUdDZE9LUm9I?=
 =?utf-8?B?N2Y0ZDhHNmVTbEQ4U2xGdU9icWJxWENiSGpUd2M3K3Bva1J1ckhyZmxiQzNx?=
 =?utf-8?B?ek9TTFIyS0xQbkUzcWRnVERtblhJZUp4dzRlZ3FZbENoM0xsZEhvSnh3UVdI?=
 =?utf-8?B?NUFuY3JnN2VHQ2JkeklaTGFTZjI4ajlZUTZpOUsyclpxQ3NJS0UwZ25JNUdB?=
 =?utf-8?B?UE9kSFpQSFNSQmVNejNVK2tiZ0wwNDlobHl0bXdsWkhyU1oreUlVUEtjdyti?=
 =?utf-8?B?dXdNejQyQXZuV3lIemVSaFdYeDY5T0lIWGZzV0Z2VWtRZ2lJc3BWZWxPR1Ba?=
 =?utf-8?B?b0JxbEd4MVB0Zkk1Z0NOZ1Z6VFZVOFpQWG52ZURCZDBveDZBMVlobEwrM1pI?=
 =?utf-8?B?MzdUNjNLakFNVVJVbUtHa2o1eW5GeVVBcGNqUFhuSUdnZXp0cWx4c3VON0cy?=
 =?utf-8?B?ZHQ4ZkViY1E2SnBvZmdFY0tUNHZUZE9CTFlMaWJueCtPN2oyVFFPZFk3TEc5?=
 =?utf-8?B?WWZTQ0RPZWw3UlJRbHNQbnVsRG11L2dVeW9UeUJmWW92cGZXTk1FeFpvYyth?=
 =?utf-8?B?SCtXQU56T3FYNU5lV1o2NDdWZDJKM1YzenBLRWp4K2lqMHpkN3BHUTlzVDh2?=
 =?utf-8?B?SllVMjlCWHdKYTZzemN3a2pHTzRtTi95akY0WWhTQ0FBUG1xTm5SZXVUbUZV?=
 =?utf-8?B?QjNzQ2toaitwaU1JSHdQS0k1cDQ3aDYvb0dFRmtibWFuRVBIaW1FRzkxOGIz?=
 =?utf-8?B?ek5mcXl3emhGTG4zV003TExPSFR6SVlvalJBTVZIaktVSzdaUEs5THI2WE5T?=
 =?utf-8?B?ZUdKTkhNVUtJQXh6OHJMd2RrWTBKaFltTGFRK0NtZGZkZ0tRQStlVGJadkhz?=
 =?utf-8?B?YzJyYzE1R3ZkQWRLTVBrQ3dTZzhXbVBVUkNwSXdrcEFMWlZVWXhzNEljOEh2?=
 =?utf-8?B?WmpPVWkwYTJCQXRhYzlIVlNLRU5ZOENuMFArZ0p4eVhxdkVobTF1Nm4wWHVx?=
 =?utf-8?B?ano5d0lRblpkL3JlcTJBVHV6TFYvTmdBdS9seG9JcGg5aW8wTUhadmF6eGZh?=
 =?utf-8?B?OVZFeHBoY2NWTHNzNWZEUFpnb3NSemdEUnROM1U0bTV5Z1BZYnFRWWZEdlFU?=
 =?utf-8?B?dVA2d0hoKzVWeEUwRU1uSUVVbXRNckJFK0l4SmFoLytJTHFySE9KbjVvNXcv?=
 =?utf-8?B?Rmt6TE0wVW9XZWpEZitIWG94cjBnUlVmYXBPWWlLWndqVTY5bE1vWnBJU011?=
 =?utf-8?B?LzBpZWY5bXkvQmIzTU9WTy9sbFovWWllVjBrYVJTUTltRkR0V1lPeHpZaUN5?=
 =?utf-8?B?cnNJLzJ2WnNMOC9lR0VFdVJGcmVQazNqQVlwT0ZGNXRJY2RsRXUrMHVFRG1h?=
 =?utf-8?B?N3JwRlJyYmtLUXJnYjdxRERnWUV3SGo4RUQxVGdXTUR0WkhYZ3NiWElMVVJw?=
 =?utf-8?B?a3RoeU4yOG4vYmRobGdMUjJKSGVBMi9tWjE0diszRkxhOStFNWVQL3RaL1pC?=
 =?utf-8?B?Q1pZa3JudCtsQjVleE1WSHlzQjFheDNkZXBza2NNajFuR3NQZTRFU2hBekt5?=
 =?utf-8?Q?0/pITehkCh9Xk?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d36e416b-c293-4736-b508-08d979edd2d7
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2021 15:14:20.4405
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: InzAz1yELfrw2LlXFXv8TtKszzB7/i5rbm5ye3yA5DTbFaBLvJa+xXU9JEN6SffdNHnvEPTREMC6LyCgmBDTlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4574
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
