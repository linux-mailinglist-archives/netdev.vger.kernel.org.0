Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 681272E1E6B
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 16:43:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728802AbgLWPlL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 10:41:11 -0500
Received: from mail-mw2nam12on2078.outbound.protection.outlook.com ([40.107.244.78]:27104
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728107AbgLWPlJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Dec 2020 10:41:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kuVvtTxv3LBSqha7Johdoqx2Hc9ITWSkfXx9aZ9Tuh6waG/e5KstUz1hBUwSrH+BLuRC/ssNqrT8p1lfoKtPo3QyJJGZHbkGUP4mRYZLKj8WQQ8iOnupJz6zrq9Boa9QINIhPPnUNgh1hCfeb59RLKTKbKYiUFV91tffR2YO78r9ED/RW0Jj7IvIwoTBbXpLFiAg4kz9yENp53jYrTp+HdfZINpFyUMXsrUMWhxNYzfoIkJmXAUSImuELiMMjMJlK82epce4/iNXrhjsGsJ3LdvNyqfTj/nNnR6VjCQgfoBgO8j6qVv4/nXH+uXoJQgZKjBut4xCG3jvjTArrvZQ8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QlzCuP+IndPbDwgzU+AEHLhgwFkWwgELq3L3PEPpkKw=;
 b=aGISTRa7DRv6Q+NEjsu6m7ulEK58+lfTgAbY8ZaaJVcPAHgafgnCur4uW6zInRFu98XkqKj278TWMY6R4e+jikeok5lTL86sQS3cSIgmJrg+7JjqUgb4zsWy9gwd0hchgdA4+P43PvUsph5BuTaA8FLVcmtQCLXNYRRQ7QvGs2+li9ZxKLMABZN4bNl2DfvIt34qJs2081GRwHXilOXEQ1kryQx8I1gHp3F6C2thEZY+Qe/vACbwX4iu8yD+cwR7UgbBkfwfi+d2H6n/eZq989Bv/PQhHBbDfHhIojZW/FslEP3DjT4/T5xATTT7h30QP0y1JhRD28CESzRL1uFWyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QlzCuP+IndPbDwgzU+AEHLhgwFkWwgELq3L3PEPpkKw=;
 b=MnIvGsY6/9LJt621TVJR19B7eNTeirkEutIWlIPNsM6QJxtWDnhzmO99XuTHPRp2jmqAKKdrMS7MQH9o2MIaYFh1uuC3I2KO+goCrjxWXLRqBXQoeWAlMLzUS5DtFpm+kjA+G/WRtkUCgZU8mzUw/KbHGWvWU+xl/Jq9X/wPpxU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB2815.namprd11.prod.outlook.com (2603:10b6:805:62::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.25; Wed, 23 Dec
 2020 15:39:47 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::a989:f850:6736:97ca]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::a989:f850:6736:97ca%5]) with mapi id 15.20.3700.026; Wed, 23 Dec 2020
 15:39:47 +0000
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
Subject: [PATCH v4 02/24] dt-bindings: introduce silabs,wfx.yaml
Date:   Wed, 23 Dec 2020 16:39:03 +0100
Message-Id: <20201223153925.73742-3-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201223153925.73742-1-Jerome.Pouiller@silabs.com>
References: <20201223153925.73742-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Originating-IP: [82.67.86.106]
X-ClientProxiedBy: SA0PR12CA0024.namprd12.prod.outlook.com
 (2603:10b6:806:6f::29) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (82.67.86.106) by SA0PR12CA0024.namprd12.prod.outlook.com (2603:10b6:806:6f::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3700.27 via Frontend Transport; Wed, 23 Dec 2020 15:39:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2301d090-828a-40d1-17d4-08d8a758faac
X-MS-TrafficTypeDiagnostic: SN6PR11MB2815:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB28158B5F34D14B283D5499AC93DE0@SN6PR11MB2815.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5h/aKDfvgAnRLdv6vYh5IoDxc3IYv3bhhvUx7cLFOfsuLF/s2Ehjsh5f9Dxtw4tGpwWKLung8UTTdtyo8UGCvPwyMYBhZh5y2kwYzP6FfRxxlza7mu46gteeXlHonyk1AuHJ1dGdQj4ldxtomfbxLJVuyGY9fod9Cj4sirO2ycRy6CUKEV/JITGGYESCSxYxtKk2bM1ZQnMKV6kJXwindpWQn2eO6FxjpB/u5tio7CsPVEKqIXM2wtQK2op2HkIBXq15dHo+jLPB6fr6ILgAfKG39kjZnk+Q5kn6168soDP/3k2S7miZx9TSWaxtF4rLVe7sbdo9PQHMR2WGyvd+4kbsPqtEMW1DPMGqlWg1gfsjXPCmofkDoe1NPrSVTec3XtA/XCwVg8WBNsW9IJwYBf/P0Op/lX5lBwmUVQh25EdbANERt6S66izn900aYXDKWF/OZC9j/l7QQxBFIRJrZA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(366004)(376002)(39850400004)(346002)(478600001)(966005)(8676002)(186003)(2906002)(8936002)(26005)(52116002)(107886003)(16526019)(7696005)(66946007)(7416002)(6486002)(956004)(2616005)(54906003)(66476007)(316002)(4326008)(6666004)(36756003)(5660300002)(1076003)(86362001)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?anA1dzFOekQ4Si9mWEx2TXVreStEWkVnamVNcGlLLzgxaGdPOTYrRzVKNjhV?=
 =?utf-8?B?MWt5VERZZXczWUFicE9rK0ZUWFplbjRIODFabEhNRExoUEJNQzU0R2h5WG9Q?=
 =?utf-8?B?UnRlYVVSWmI2WXZJdGV2enpJNVNBN0VNSlFUOXhmMXJWZEMvNllYQys1VmZY?=
 =?utf-8?B?ZDRIeGYxTmRwZUFOOG9PYy9EYzA0K3h3WGc3R0VJUzREMzcyR2x4emtzWDBN?=
 =?utf-8?B?WUdpSlMzVzBjalR2SVRSTFY3c3EzdWJrVzhmK0VQSzRPN3RJS0F1engwR3hl?=
 =?utf-8?B?dStKbzFBenJOdFFmUXp3NFhwQjJraGVJQ0NuMEdhenM2aHl1ZzMyeTd5RzJo?=
 =?utf-8?B?aFJ2bTJuOXZ3bUc3S1FVcHloMXorNkZZTFRnWEJWc2FjV3pxZVFWMCtqbTRO?=
 =?utf-8?B?YWgxSjArMFh3WlV4Um5UbGNtSmNVYTR5OFBKc05TMXVLSktLQXg2K3lKVTdW?=
 =?utf-8?B?ZFQ5K3d3b1R5eGxjOTN2eXlNMHdsVk5lK1hSZ29nUjNZeHZQZFhXYkpMY1U2?=
 =?utf-8?B?M1R4bndwZVZ1OFpIblNFU3loQW9WaW9vZ2htU1pSL0FHKzBEMGdFbURqQm1x?=
 =?utf-8?B?b3pwY2lXYnpLTzBhek03SVl2STZwQUF3VkFrUkhMRnk0cHpmNWFZTXNMZFhU?=
 =?utf-8?B?NTRqSkVnUjBuUGY1TnUvYUFIYVhYUVR6RTBqLzRIU2V4UmZPaEZMakVCYWxE?=
 =?utf-8?B?eU1xYTNwOXE3M3RzNzhldFNhT3BBQVB3SU85UmhUMGEwYjVSM0JlUFp5U0RN?=
 =?utf-8?B?RThsRkVxQVhtdUp0bmZSUldFTjl5cnVVOUxNbHNEYU10SEpFVzBWOWF2dHJE?=
 =?utf-8?B?MXg4U3VtaVBiWTVUZlVkclQxL0RzbzlZMWt4OXFRVExYb05OOVhOV3Zld3h2?=
 =?utf-8?B?YjZFd2JGT0t3M2x6ZDJmSVZVcFovWWtOMUdZNEhJSy9OTy9FZHg1cHR5WTlB?=
 =?utf-8?B?VkRiVmw5VWFlQjRYS3ZqQ01GRGpCeGpzcWc0UjZYTGZkaVB1VHkreTY2U3BZ?=
 =?utf-8?B?cVh2ODZ2K2hsejF0amVkdG9oSXJUU0lrdmc1UTdabDdlMll0TDVWcGJmY3dQ?=
 =?utf-8?B?eCtJM05YcW1zNGNTa2QzcE95c1lTbkM0NUU5T3JqS21IZkVZa1dPcGFmZVpE?=
 =?utf-8?B?Qzdia04xbzM4OGh5L0dDMGdlNzRqNFZNN0ZBSnJCNlhDRE5pUnVEdjJneG5L?=
 =?utf-8?B?K0d6clBIWXVzQW9zWkNWK2J0RHVTMFJxaGZCUXlScFpXTGVoQnFTOGNsZlNX?=
 =?utf-8?B?N29TYWM0K042eTRyWDZFbHo3K1l5QzZQTS9JcjQyYmRMUGNHMzBTU1VRMlA2?=
 =?utf-8?Q?BV7V5ksmIW6jY=3D?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2020 15:39:47.6808
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-Network-Message-Id: 2301d090-828a-40d1-17d4-08d8a758faac
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cJe4rTls5ADaJu0S/svRBQcfyn2bUMjrG3Fk+3+uv9oDvUZaWQpAS/quK5STcGIULSVSP4aFDVwDuUQFSgKWGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2815
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKU2ln
bmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29t
PgotLS0KIC4uLi9iaW5kaW5ncy9uZXQvd2lyZWxlc3Mvc2lsYWJzLHdmeC55YW1sICAgICB8IDEz
MyArKysrKysrKysrKysrKysrKysKIDEgZmlsZSBjaGFuZ2VkLCAxMzMgaW5zZXJ0aW9ucygrKQog
Y3JlYXRlIG1vZGUgMTAwNjQ0IERvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQv
d2lyZWxlc3Mvc2lsYWJzLHdmeC55YW1sCgpkaWZmIC0tZ2l0IGEvRG9jdW1lbnRhdGlvbi9kZXZp
Y2V0cmVlL2JpbmRpbmdzL25ldC93aXJlbGVzcy9zaWxhYnMsd2Z4LnlhbWwgYi9Eb2N1bWVudGF0
aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L3dpcmVsZXNzL3NpbGFicyx3ZngueWFtbApuZXcg
ZmlsZSBtb2RlIDEwMDY0NAppbmRleCAwMDAwMDAwMDAwMDAuLjQ4N2Q0NmM1ZmRjMAotLS0gL2Rl
di9udWxsCisrKyBiL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvd2lyZWxl
c3Mvc2lsYWJzLHdmeC55YW1sCkBAIC0wLDAgKzEsMTMzIEBACisjIFNQRFgtTGljZW5zZS1JZGVu
dGlmaWVyOiAoR1BMLTIuMC1vbmx5IE9SIEJTRC0yLUNsYXVzZSkKKyMgQ29weXJpZ2h0IChjKSAy
MDIwLCBTaWxpY29uIExhYm9yYXRvcmllcywgSW5jLgorJVlBTUwgMS4yCistLS0KKworJGlkOiBo
dHRwOi8vZGV2aWNldHJlZS5vcmcvc2NoZW1hcy9uZXQvd2lyZWxlc3Mvc2lsYWJzLHdmeC55YW1s
IworJHNjaGVtYTogaHR0cDovL2RldmljZXRyZWUub3JnL21ldGEtc2NoZW1hcy9jb3JlLnlhbWwj
CisKK3RpdGxlOiBTaWxpY29uIExhYnMgV0Z4eHggZGV2aWNldHJlZSBiaW5kaW5ncworCittYWlu
dGFpbmVyczoKKyAgLSBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5j
b20+CisKK2Rlc2NyaXB0aW9uOiA+CisgIFN1cHBvcnQgZm9yIHRoZSBXaWZpIGNoaXAgV0Z4eHgg
ZnJvbSBTaWxpY29uIExhYnMuIEN1cnJlbnRseSwgdGhlIG9ubHkgZGV2aWNlCisgIGZyb20gdGhl
IFdGeHh4IHNlcmllcyBpcyB0aGUgV0YyMDAgZGVzY3JpYmVkIGhlcmU6CisgICAgIGh0dHBzOi8v
d3d3LnNpbGFicy5jb20vZG9jdW1lbnRzL3B1YmxpYy9kYXRhLXNoZWV0cy93ZjIwMC1kYXRhc2hl
ZXQucGRmCisgIAorICBUaGUgV0YyMDAgY2FuIGJlIGNvbm5lY3RlZCB2aWEgU1BJIG9yIHZpYSBT
RElPLgorICAKKyAgRm9yIFNESU86CisgIAorICAgIERlY2xhcmluZyB0aGUgV0Z4eHggY2hpcCBp
biBkZXZpY2UgdHJlZSBpcyBtYW5kYXRvcnkgKHVzdWFsbHksIHRoZSBWSUQvUElEIGlzCisgICAg
c3VmZmljaWVudCBmb3IgdGhlIFNESU8gZGV2aWNlcykuCisgIAorICAgIEl0IGlzIHJlY29tbWVu
ZGVkIHRvIGRlY2xhcmUgYSBtbWMtcHdyc2VxIG9uIFNESU8gaG9zdCBhYm92ZSBXRnguIFdpdGhv
dXQKKyAgICBpdCwgeW91IG1heSBlbmNvdW50ZXIgaXNzdWVzIGR1cmluZyByZWJvb3QuIFRoZSBt
bWMtcHdyc2VxIHNob3VsZCBiZQorICAgIGNvbXBhdGlibGUgd2l0aCBtbWMtcHdyc2VxLXNpbXBs
ZS4gUGxlYXNlIGNvbnN1bHQKKyAgICBEb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3Mv
bW1jL21tYy1wd3JzZXEtc2ltcGxlLnR4dCBmb3IgbW9yZQorICAgIGluZm9ybWF0aW9uLgorICAK
KyAgRm9yIFNQSToKKyAgCisgICAgSW4gYWRkIG9mIHRoZSBwcm9wZXJ0aWVzIGJlbG93LCBwbGVh
c2UgY29uc3VsdAorICAgIERvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9zcGkvc3Bp
LWNvbnRyb2xsZXIueWFtbCBmb3Igb3B0aW9uYWwgU1BJCisgICAgcmVsYXRlZCBwcm9wZXJ0aWVz
LgorCitwcm9wZXJ0aWVzOgorICBjb21wYXRpYmxlOgorICAgIGNvbnN0OiBzaWxhYnMsd2YyMDAK
KworICByZWc6CisgICAgZGVzY3JpcHRpb246CisgICAgICBXaGVuIHVzZWQgb24gU0RJTyBidXMs
IDxyZWc+IG11c3QgYmUgc2V0IHRvIDEuIFdoZW4gdXNlZCBvbiBTUEkgYnVzLCBpdCBpcworICAg
ICAgdGhlIGNoaXAgc2VsZWN0IGFkZHJlc3Mgb2YgdGhlIGRldmljZSBhcyBkZWZpbmVkIGluIHRo
ZSBTUEkgZGV2aWNlcworICAgICAgYmluZGluZ3MuCisgICAgbWF4SXRlbXM6IDEKKworICBzcGkt
bWF4LWZyZXF1ZW5jeTogdHJ1ZQorCisgIGludGVycnVwdHM6CisgICAgZGVzY3JpcHRpb246IFRo
ZSBpbnRlcnJ1cHQgbGluZS4gVHJpZ2dlcnMgSVJRX1RZUEVfTEVWRUxfSElHSCBhbmQKKyAgICAg
IElSUV9UWVBFX0VER0VfUklTSU5HIGFyZSBib3RoIHN1cHBvcnRlZCBieSB0aGUgY2hpcCBhbmQg
dGhlIGRyaXZlci4gV2hlbgorICAgICAgU1BJIGlzIHVzZWQsIHRoaXMgcHJvcGVydHkgaXMgcmVx
dWlyZWQuIFdoZW4gU0RJTyBpcyB1c2VkLCB0aGUgImluLWJhbmQiCisgICAgICBpbnRlcnJ1cHQg
cHJvdmlkZWQgYnkgdGhlIFNESU8gYnVzIGlzIHVzZWQgdW5sZXNzIGFuIGludGVycnVwdCBpcyBk
ZWZpbmVkCisgICAgICBpbiB0aGUgRGV2aWNlIFRyZWUuCisgICAgbWF4SXRlbXM6IDEKKworICBy
ZXNldC1ncGlvczoKKyAgICBkZXNjcmlwdGlvbjogKFNQSSBvbmx5KSBQaGFuZGxlIG9mIGdwaW8g
dGhhdCB3aWxsIGJlIHVzZWQgdG8gcmVzZXQgY2hpcAorICAgICAgZHVyaW5nIHByb2JlLiBXaXRo
b3V0IHRoaXMgcHJvcGVydHksIHlvdSBtYXkgZW5jb3VudGVyIGlzc3VlcyB3aXRoIHdhcm0KKyAg
ICAgIGJvb3QuIChGb3IgbGVnYWN5IHB1cnBvc2UsIHRoZSBncGlvIGluIGludmVydGVkIHdoZW4g
Y29tcGF0aWJsZSA9PQorICAgICAgInNpbGFicyx3Zngtc3BpIikKKworICAgICAgRm9yIFNESU8s
IHRoZSByZXNldCBncGlvIHNob3VsZCBkZWNsYXJlZCB1c2luZyBhIG1tYy1wd3JzZXEuCisgICAg
bWF4SXRlbXM6IDEKKworICB3YWtldXAtZ3Bpb3M6CisgICAgZGVzY3JpcHRpb246IFBoYW5kbGUg
b2YgZ3BpbyB0aGF0IHdpbGwgYmUgdXNlZCB0byB3YWtlLXVwIGNoaXAuIFdpdGhvdXQgdGhpcwor
ICAgICAgcHJvcGVydHksIGRyaXZlciB3aWxsIGRpc2FibGUgbW9zdCBvZiBwb3dlciBzYXZpbmcg
ZmVhdHVyZXMuCisgICAgbWF4SXRlbXM6IDEKKworICBzaWxhYnMsYW50ZW5uYS1jb25maWctZmls
ZToKKyAgICAkcmVmOiAvc2NoZW1hcy90eXBlcy55YW1sIy9kZWZpbml0aW9ucy9zdHJpbmcKKyAg
ICBkZXNjcmlwdGlvbjogVXNlIGFuIGFsdGVybmF0aXZlIGZpbGUgZm9yIGFudGVubmEgY29uZmln
dXJhdGlvbiAoYWthCisgICAgICAiUGxhdGZvcm0gRGF0YSBTZXQiIGluIFNpbGFicyBqYXJnb24p
LiBEZWZhdWx0IGlzICd3ZjIwMC5wZHMnLgorCisgIGxvY2FsLW1hYy1hZGRyZXNzOiB0cnVlCisK
KyAgbWFjLWFkZHJlc3M6IHRydWUKKworYWRkaXRpb25hbFByb3BlcnRpZXM6IGZhbHNlCisKK3Jl
cXVpcmVkOgorICAtIGNvbXBhdGlibGUKKyAgLSByZWcKKworZXhhbXBsZXM6CisgIC0gfAorICAg
ICNpbmNsdWRlIDxkdC1iaW5kaW5ncy9ncGlvL2dwaW8uaD4KKyAgICAjaW5jbHVkZSA8ZHQtYmlu
ZGluZ3MvaW50ZXJydXB0LWNvbnRyb2xsZXIvaXJxLmg+CisKKyAgICBzcGkwIHsKKyAgICAgICAg
I2FkZHJlc3MtY2VsbHMgPSA8MT47CisgICAgICAgICNzaXplLWNlbGxzID0gPDA+OworCisgICAg
ICAgIHdpZmlAMCB7CisgICAgICAgICAgICBjb21wYXRpYmxlID0gInNpbGFicyx3ZjIwMCI7Cisg
ICAgICAgICAgICBwaW5jdHJsLW5hbWVzID0gImRlZmF1bHQiOworICAgICAgICAgICAgcGluY3Ry
bC0wID0gPCZ3ZnhfaXJxICZ3ZnhfZ3Bpb3M+OworICAgICAgICAgICAgcmVnID0gPDA+OworICAg
ICAgICAgICAgaW50ZXJydXB0cy1leHRlbmRlZCA9IDwmZ3BpbyAxNiBJUlFfVFlQRV9FREdFX1JJ
U0lORz47CisgICAgICAgICAgICB3YWtldXAtZ3Bpb3MgPSA8JmdwaW8gMTIgR1BJT19BQ1RJVkVf
SElHSD47CisgICAgICAgICAgICByZXNldC1ncGlvcyA9IDwmZ3BpbyAxMyBHUElPX0FDVElWRV9M
T1c+OworICAgICAgICAgICAgc3BpLW1heC1mcmVxdWVuY3kgPSA8NDIwMDAwMDA+OworICAgICAg
ICB9OworICAgIH07CisKKyAgLSB8CisgICAgI2luY2x1ZGUgPGR0LWJpbmRpbmdzL2dwaW8vZ3Bp
by5oPgorICAgICNpbmNsdWRlIDxkdC1iaW5kaW5ncy9pbnRlcnJ1cHQtY29udHJvbGxlci9pcnEu
aD4KKworICAgIHdmeF9wd3JzZXE6IHdmeF9wd3JzZXEgeworICAgICAgICBjb21wYXRpYmxlID0g
Im1tYy1wd3JzZXEtc2ltcGxlIjsKKyAgICAgICAgcGluY3RybC1uYW1lcyA9ICJkZWZhdWx0IjsK
KyAgICAgICAgcGluY3RybC0wID0gPCZ3ZnhfcmVzZXQ+OworICAgICAgICByZXNldC1ncGlvcyA9
IDwmZ3BpbyAxMyBHUElPX0FDVElWRV9MT1c+OworICAgIH07CisKKyAgICBtbWMwIHsKKyAgICAg
ICAgbW1jLXB3cnNlcSA9IDwmd2Z4X3B3cnNlcT47CisgICAgICAgICNhZGRyZXNzLWNlbGxzID0g
PDE+OworICAgICAgICAjc2l6ZS1jZWxscyA9IDwwPjsKKworICAgICAgICB3aWZpQDEgeworICAg
ICAgICAgICAgY29tcGF0aWJsZSA9ICJzaWxhYnMsd2YyMDAiOworICAgICAgICAgICAgcGluY3Ry
bC1uYW1lcyA9ICJkZWZhdWx0IjsKKyAgICAgICAgICAgIHBpbmN0cmwtMCA9IDwmd2Z4X3dha2V1
cD47CisgICAgICAgICAgICByZWcgPSA8MT47CisgICAgICAgICAgICB3YWtldXAtZ3Bpb3MgPSA8
JmdwaW8gMTIgR1BJT19BQ1RJVkVfSElHSD47CisgICAgICAgIH07CisgICAgfTsKKy4uLgotLSAK
Mi4yOS4yCgo=
