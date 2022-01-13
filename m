Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F14B48D416
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 09:57:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233199AbiAMI43 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 03:56:29 -0500
Received: from mail-dm6nam11on2047.outbound.protection.outlook.com ([40.107.223.47]:10080
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233100AbiAMI4Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jan 2022 03:56:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jdzoOA/0ZmqzJvpuE6PJppbK/OHoUTcKD4+Fqv+5iJnjHTCxKHAa5pmGYgUzPpxPfLvILd5l8L1G2vdbyAdAsGTTEn87t3LQJhPf9QIgeewQbeuFGmh4M8tKMZW2nbOF30xGEo2fgVMLhFOA6IFDUIv968+p3C2xzyh7WtpWsB24MmhjPZQSH0yyKp4g1rhnZT59O6vwy6e8CGXAzR/9UpBS5Xlig02K62HbxdMxMdKF2Jw6IG/Cnx19fNl1+Mee2s6jlA5ItJ5n6fuJXOR/HnkgN+tvPEBVkRa/o3ltMktlj9mzEJTy7M6ZnYPJpo90nuCJKlFoIFWa1NTH7wN1Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QQSaVvzV1eIIDCtdl1lThLOPAXga4ycquPHAuRYACvA=;
 b=YgLXcu+6pVYDeuffJFSJ5aC0czx1obFHMEVR34E/T3NFcZz7ji0gOWrZ8MraI2wPmFICgBRLGDmI9Ea2TLTJmozD3SnBquR6cKt6pPJC59LgK+MToT9PLU3/nPmLpAXWg26sHyvYs45Fn7q8Q/Ra6uL6OSp10qa6aUgViegls0pjOCoAdqnaPunfjWnR/6x3VtSGi7hQySbQ+7eLmFlipbW2L1s1Pz2+A7rd4thk3DQLdAwp7xPb0bdbbZWXDJO8xZ3ZRyfyjxYGzts+qG465W6iuH07QeLP4psv3V9BOCH586m9oaw0oBLc/uFVbnM4N93udw98eYyvzC60V81tlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QQSaVvzV1eIIDCtdl1lThLOPAXga4ycquPHAuRYACvA=;
 b=bxm3zykJbU5v82YNwpqyiQ4XaNuJaBd0GC6ngsOLwKz6iqCtILYb2w6QtIA98DDo8kt2JE4hYt/3QIKs4QbEzdluwst0CbGCudWcVG6j9k7TrkvPaGpQynOXW7Ko3aIqRr5jQVDva0OI7c7ju8IFVaMhdPpUz1uDZdsN3CLQOtU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by CY4PR1101MB2071.namprd11.prod.outlook.com (2603:10b6:910:1a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Thu, 13 Jan
 2022 08:56:11 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::d031:da9e:71a:73e4]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::d031:da9e:71a:73e4%5]) with mapi id 15.20.4888.011; Thu, 13 Jan 2022
 08:56:11 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 17/31] staging: wfx: prefix tx_policy_is_equal() with wfx_
Date:   Thu, 13 Jan 2022 09:55:10 +0100
Message-Id: <20220113085524.1110708-18-Jerome.Pouiller@silabs.com>
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
X-MS-Office365-Filtering-Correlation-Id: e44efd5e-585d-4d12-17f9-08d9d6728c05
X-MS-TrafficTypeDiagnostic: CY4PR1101MB2071:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1101MB20714D54D0E4FB78ED678DC093539@CY4PR1101MB2071.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XnGQAPp8DbjiqJWYUP6dIfWbSJydqnrDageWwfC6Bt0A+GzmaD2t8YNTnrBNl/JOENXTco/5m4cS4ylBEa4Xd0SGdFhXYfQHG9JSj2tPI6w5BzywF8/YqdJE/mfVq/0QpWIZ5qlYUGSmrquRz6jJGuqN1lMdcLtjrHnXu5BQI4RUAXT+4/oH3KlJtzn63duFPMcGjf8A2bqkj07HfqtIDdRqt2AlxwQouoP4onUcDr2bdG4Vjs/opndCJoD6MTBKjceGEVVlh19i0PSqTu+IHxgIuVyvOmOl7bnqQRtEUKpcJzmPvIm5CxAbGlzhZX2HhBu95yfynd8LU4113B+DTOKOG/6eaSnP5mtZZxIRpsEYg5mkDi6MawWxeTuPI4EEtDCDbf3+yXJ3JelwUj5DVnTXzO6z2iD2GfVDRZyNUY6+rk1Ng6I9xYOiBt1iz+jkSCyTMCUqk37kz3FUjCjnNt53zozF8vVNPoadhktRZievH3Nm/MC6Qgj/+ulKDcIZQrRX9VAnxTeO7q6gaZ3gKPfPfH9tx2I6lZqxYGmj/jkh77AWj1nwfSE62bplmB9YDVGBdb9QezVX1TKMaaIhVJSXhmbmfiq+kB+/8zAfa+cEHdpiptC9RJwNe6BE/+E6gkPGcJuY+pR/iDZVOHF6ng==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2616005)(66476007)(52116002)(8676002)(6486002)(4326008)(38100700002)(8936002)(83380400001)(6506007)(107886003)(66556008)(36756003)(508600001)(2906002)(5660300002)(6512007)(1076003)(86362001)(186003)(316002)(66946007)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SGFvZkVHT0I0OEFTUUNNSDFDUEpHa2JzT2dZdUR1M1Z3WkhHd1VIUkxIeHBO?=
 =?utf-8?B?NWpuTFZ2ZU5icExRam9SRmZLNVRPNHJZSmo4N3JXc1hIYmZHU0xNK1BvMUZm?=
 =?utf-8?B?Mm1LSFE2dTJ2TEpob3VhMXZlNHNjU0FuOENLOFhLNjhBZzRIaFRLMEJSWWhl?=
 =?utf-8?B?eDRJK1UySjZDb1lkaTFqRTMvUHNlc2NHMVErbUh3YWl1ekRVcFVaaEV0NmFs?=
 =?utf-8?B?MVBPMzF1Z0lWMEh2WVJDeWYxNVRUTE1GdmVFWThIbzFBYmZCQkpmVUlOZWxS?=
 =?utf-8?B?d3hYQ1ZadC9TdXZJSk91bG5MMTVMbUNtRTdRMWtoc295OVVDYkovTGgwa01I?=
 =?utf-8?B?enMwMUFqQkU1bW83RW83Z0F2WGpBaENTamEzSFBPanQ3akhtU2E2bHJRblFR?=
 =?utf-8?B?bTdGVDBXYTRGa1V3NVk0UXdBVWduTFl5OE05VWxrd1JoUGdHQis1cmUzR05r?=
 =?utf-8?B?RnRORzdXYnVBbEVaMzFhWkNuVXFhRSswSWN3bGFuZlI1aWNJem9DaU03b1hP?=
 =?utf-8?B?eVlvcWdLZ3R4RDVDWDJXNTVZT3BwOFVYNEVuem44RTYrYTBha3BpckhwcmlR?=
 =?utf-8?B?KzBFQ084L0xpQ3AxK0xxem5wNlZlUllIdnBpcVRzWGNxQ0dwV1Z4WERTWWVa?=
 =?utf-8?B?N3hsMkE4OGlzM0Q4cGRLYUxyZjhKdnY4SEoxOHAwaFRWT0EzYjVDdW5MNWxH?=
 =?utf-8?B?RFpScnRIZnhWcFY3ZmQzMk9XcFlHUVN3Y3k2K3M2LzZwbW83OENsNVp3aXU5?=
 =?utf-8?B?R29rU0pYZi8zYnc3Q29sWUtYVzBmc2lhcmRLdWd2R0VHV2hrSDRtOEhBbnVa?=
 =?utf-8?B?ZkNUT0ZUMldHU3ZmRlNpRTB5RE4xZGdncGxlZVF5M0R5Y2lTL2lXN0g2K2Z1?=
 =?utf-8?B?YUJNdk1jcDZIdittWUxMSjY4ZXNkL0V0U3NoeUFPaVZmZWMySUZKZUFCK2dZ?=
 =?utf-8?B?dUFQTWl6N1RObU5sSVpWaUllZEJZSzlQWCtBem05cmU0dTVvQnBYTXdiRTJk?=
 =?utf-8?B?NUVaaDFLYll2ZjJoMElaVm5NUjV3cG9zNEMrZStDdHRUb2RyUUtJdFQ2WGNE?=
 =?utf-8?B?L1F5QnJvSHY2SUFmVFNUYmZDcDc0T1N4a3RsUHBHMnZtQ3Q2OE43MkJKcm00?=
 =?utf-8?B?UnBuRG8vYW80RHdwTjFUdm1KeGVuSFRGbnRjdlpuRnB5UjZqTS84emZsUlhB?=
 =?utf-8?B?VFBVb3V2d1ZuUVY1TzRtZlZtM3BLRTF4amsySXdPRHVEM0xaOWtXRkJGVzNw?=
 =?utf-8?B?MHdSVzdTRGFzY0IrTWgyZi9ndUNLTjBNWGZLQno1QlNGUjdESGRaRkJ2TEg4?=
 =?utf-8?B?YjJwQStKdTQveWJXaFVEZEF6RE1sV2hrTTAxV1pIcTIxOU5IYkFBUlJrNXF1?=
 =?utf-8?B?Q3hOQy8xRGhrSFpxZTJGS0Q2QktiUFlBSVhXSW9NRy9pVFg4dlVsMUhGZ2dX?=
 =?utf-8?B?MHBKYTM2djdzZTFldnBVTHlPS0paNXFoSjdWaC8zWFM4UitpM0pNM1I2TkNQ?=
 =?utf-8?B?a1pnYi84ZlorblpiQ2VVZEdvcHJSczE2U05taUViaSthbXo0MG4reXRXa29p?=
 =?utf-8?B?Wm1qUEhMVWxRMU4ySHBhWVB6N05QaGZDM0xyWnJzcUdBM0JOdFZDQ0FyQXVH?=
 =?utf-8?B?cnBNUXJQU1kzS3poRWduQUI3YVUwc1VRR3h4YVBQVUVPN05rMlgvSU9sWStw?=
 =?utf-8?B?bkhtN3h4eGZ3ZWJtQ2NBbmNBUTBPS1pxYUY4clVvL3MwaTdDY0lIZ2plSGpw?=
 =?utf-8?B?bjIwT2l5cHovYTIzU3FNRFZ5Q2tIeFBZS1YyR0JJM1Rpcmw3eDV0bVI2MjJM?=
 =?utf-8?B?eW9pVFR6TjRHQ2c2ZW1hdGhQeDhnWlpMOWQwaUVmSUdPRElySjRSWU11VHN1?=
 =?utf-8?B?VEdRbll3dFFwWmlXZW94a1F5c2QwQUx0K3M3MUpoMThrdW1BUGR5UmtMNVdZ?=
 =?utf-8?B?NjJhSWlhS1BkazZCblQ5bGY1V2dIeWRqRHMyL0Q3UWU5UXFPWldqaDZoZGc1?=
 =?utf-8?B?UEltOG1KU0NsRVFjSHFrcUZGdUR0dEdlaTNTNW1hem5EVUhpUU9wdk1ReU9F?=
 =?utf-8?B?SU5iNHZYK1k5WnF3V2R1RFJpRU9QYy8wRk9rdG56TXlvZThZWFk0Rnc1UWkr?=
 =?utf-8?B?TG9VTldsSjkvdWRUYTB1MlVEb05INVhZVnhYM2RRYm5mZnBFRHk1a0VBV3Ft?=
 =?utf-8?B?b3NrcXVoQVVMVlVoV2l6NVFjcGE2aTFCK0xLeHVCQUFsQ08yRWlkVDFiM0pM?=
 =?utf-8?Q?9UELoaHA99f5dHLldH7UQPDe/tkl2pQuqiYWjFurZk=3D?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e44efd5e-585d-4d12-17f9-08d9d6728c05
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2022 08:56:11.5594
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gIp8TVxR6Krt7E4Q8IwY/HeFeo8TNv7n7SAt/jY1OVzMsWGv1YH+/fu7BllSmS5+vw21r5Kid8+uxBQMPu/clA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1101MB2071
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKdHhf
cG9saWN5X2lzX2VxdWFsKCkgd2FzIHRoZSBvbmx5IGZ1bmN0aW9uIGZyb20gZGF0YV90eC5jIHdp
dGhvdXQgdGhlCnByZWZpeCB3ZnhfLgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIg
PGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvZGF0
YV90eC5jIHwgOCArKysrLS0tLQogMSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKSwgNCBk
ZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfdHguYyBi
L2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5jCmluZGV4IDU0ZmY5YmNhNzhkNi4uYzNlZmJj
ZGNjOGMzIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfdHguYworKysgYi9k
cml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfdHguYwpAQCAtNjYsOCArNjYsOCBAQCBzdGF0aWMgdm9p
ZCB3ZnhfdHhfcG9saWN5X2J1aWxkKHN0cnVjdCB3ZnhfdmlmICp3dmlmLCBzdHJ1Y3QgdHhfcG9s
aWN5ICpwb2xpY3ksCiAJfQogfQogCi1zdGF0aWMgYm9vbCB0eF9wb2xpY3lfaXNfZXF1YWwoY29u
c3Qgc3RydWN0IHR4X3BvbGljeSAqYSwKLQkJCSAgICAgICBjb25zdCBzdHJ1Y3QgdHhfcG9saWN5
ICpiKQorc3RhdGljIGJvb2wgd2Z4X3R4X3BvbGljeV9pc19lcXVhbChjb25zdCBzdHJ1Y3QgdHhf
cG9saWN5ICphLAorCQkJCSAgIGNvbnN0IHN0cnVjdCB0eF9wb2xpY3kgKmIpCiB7CiAJcmV0dXJu
ICFtZW1jbXAoYS0+cmF0ZXMsIGItPnJhdGVzLCBzaXplb2YoYS0+cmF0ZXMpKTsKIH0KQEAgLTc4
LDEwICs3OCwxMCBAQCBzdGF0aWMgaW50IHdmeF90eF9wb2xpY3lfZmluZChzdHJ1Y3QgdHhfcG9s
aWN5X2NhY2hlICpjYWNoZSwKIAlzdHJ1Y3QgdHhfcG9saWN5ICppdDsKIAogCWxpc3RfZm9yX2Vh
Y2hfZW50cnkoaXQsICZjYWNoZS0+dXNlZCwgbGluaykKLQkJaWYgKHR4X3BvbGljeV9pc19lcXVh
bCh3YW50ZWQsIGl0KSkKKwkJaWYgKHdmeF90eF9wb2xpY3lfaXNfZXF1YWwod2FudGVkLCBpdCkp
CiAJCQlyZXR1cm4gaXQgLSBjYWNoZS0+Y2FjaGU7CiAJbGlzdF9mb3JfZWFjaF9lbnRyeShpdCwg
JmNhY2hlLT5mcmVlLCBsaW5rKQotCQlpZiAodHhfcG9saWN5X2lzX2VxdWFsKHdhbnRlZCwgaXQp
KQorCQlpZiAod2Z4X3R4X3BvbGljeV9pc19lcXVhbCh3YW50ZWQsIGl0KSkKIAkJCXJldHVybiBp
dCAtIGNhY2hlLT5jYWNoZTsKIAlyZXR1cm4gLTE7CiB9Ci0tIAoyLjM0LjEKCg==
