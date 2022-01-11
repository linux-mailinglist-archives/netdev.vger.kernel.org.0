Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B67CB48B315
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 18:15:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343978AbiAKRPD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 12:15:03 -0500
Received: from mail-dm3nam07on2065.outbound.protection.outlook.com ([40.107.95.65]:38465
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244420AbiAKRPA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Jan 2022 12:15:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MWfWDxISWtlrfIW0z+D/qWU9WPagvFBtJzO1jmwOCAN8s3EgT6NR/kjnXOrQrC05BQGBM8VieGftRk9AuvbqGwXZuJKYwCiefv4c5XsQt2AMYXjUPzdqD3ilhys5lKp+6oCxt8jdsAG37YQrXpfgfgOgw9d+YG+UuxQAEzaj6RYvQbvYwsslomsP/m8YX7sVUOyFeNIVDBUsL+A3xL2fRKPVb2H7/kd9lNHuu/tToCWHP7fYbynitLai5apUDflZUlaphn0cv+Dr/MV1UswS3pmUaEZarNmHCuSkZWcyO/lCXPv0Z+Ip5yHyf9lTtPwAeDD7shvS05Zy2I4CNVx/1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z0O8ZYm9/LLeMIfjQcqCR+frdbEDBWQSPLLPo26qcg4=;
 b=nisOJkMHlSEMQ+2rJntdtDBUZDWgRYKWtLHCL1+MFT5KTlcereAjQn7Jmd1/I9iiI6uRuJxw+WnIaT5fUeXdDPNvYhzhv614YcRJL97HnQLqelWAJCNh+8rAbO4P66y2jIdUkDRIuTVV71QPEeN/ErjUGvcTUqZpsVXkZE+B2jFTyq8oYNARY9NClluQW7vW+KwMfytKTTBpmg/bva9gDCdwPHqA0cqUW1VxTHcUOtzeEwmED//PcptVWtrBdb6Eg3OSSToXTa1KK+z3JwHIh9htNzLCWUmagYCkC15TeMrS198RK9BPTO7MdKmmibh/fqf2IiqQVG6oaJbAT3KFRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z0O8ZYm9/LLeMIfjQcqCR+frdbEDBWQSPLLPo26qcg4=;
 b=odIyTqr3gz9suLOre1OfJu31osfHEQdGpJls6xNPMfdoorI/ClVzp1pJRKRd/nywUaax9jJAPWrHpXi06fwC32QZIX2Cs/qxw5s+a9odj/saYlDgAFsX77bUen9ktqRIPKEPJt0tYwtt953rcGH2rv4wpyJ4Z3MaX61u9hhMw/U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by PH0PR11MB5674.namprd11.prod.outlook.com (2603:10b6:510:ec::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.11; Tue, 11 Jan
 2022 17:14:56 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::d031:da9e:71a:73e4]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::d031:da9e:71a:73e4%6]) with mapi id 15.20.4867.012; Tue, 11 Jan 2022
 17:14:56 +0000
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
Subject: [PATCH v9 04/24] wfx: add wfx.h
Date:   Tue, 11 Jan 2022 18:14:04 +0100
Message-Id: <20220111171424.862764-5-Jerome.Pouiller@silabs.com>
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
X-MS-Office365-Filtering-Correlation-Id: 5f0fb3d2-8af9-4a3c-4342-08d9d525e3db
X-MS-TrafficTypeDiagnostic: PH0PR11MB5674:EE_
X-Microsoft-Antispam-PRVS: <PH0PR11MB5674E1FCD680CC3014E992E593519@PH0PR11MB5674.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gUjlRX3hZW0ehZstBdtSPAF2wJ6gHfRBBVGlW5goe/nRAs4bQmVDtvfrHYUh/giUvI74ItOVUTrkJQiP/BNShN5sScCQGOLU9MBa7joORMcGItaQxScOWAZkPy+/rpN6mBVnQ/aUf7oDS0X/e7l+6x/jiWn5Em5hXALJjG4txe0xXZIfcwMWrQwCEpOl40gsOmRJ0GPGYeEz6r24PgI2ieUXTrjJCg/XiXzGWJFmEje5hW2sbZi5uiozwxG+DjQSgV2TQEbbzZ/uyQciezUAe5S7FXuRdfxmWyZnmOUErhGRw837bpa8zCwVZv0n7I/po2t9vUHIzfM8UZUmWp95UC4f4RhrNaXoI1p+QA4iy72CfX7GvkHHmgHbjL5XPY16JdGpgo0fxBvbDoSA7iLfWPQP2UdruijaoRNmpmMz/AAXGQmI8mt7TilSfHHaMox1GLWzs1klP6HFv88YLf6JnpI3aHp+hEbvSmlfmhFFMkT0rj0hQLRh3rakdfNgonuZh5JeN3OMO5pBurHYvAFcRng5x1nQt8gTiAmiS6Ck1LzezRR7mFsAaBIRWsXQylEGTSpldUTUgM8rHNWD1prhDrX5fYD0H/wpCgEphQt8eqmO8tvMU8Lm1iWUd4TMd4ruxOt5YIe/OukrqsjOP9rtKw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6506007)(66946007)(66574015)(8936002)(107886003)(4326008)(66476007)(508600001)(36756003)(7416002)(8676002)(86362001)(6916009)(83380400001)(52116002)(316002)(6512007)(2906002)(6666004)(6486002)(1076003)(186003)(66556008)(54906003)(38100700002)(2616005)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?REdCYVBQZ0FjUDM1YzN0RGRvam1rdjlVRCtvZ05jT21meEVheFN0dWtaTWJx?=
 =?utf-8?B?b3RQd1R6NWgwc0JJejRNMlpMSUpwSXNDYzdIVEVMWG1zYnRsNG5VYklPTXlV?=
 =?utf-8?B?TWRtclhMUFdMVTV4TGpkbWl3eEV1Y01LbUUzeDkrZmQrSjBPMzFjbEoxckNT?=
 =?utf-8?B?VzJwKzdRWmRFZ2ZyYnpCanF1S0kyT25pWlpUSStKYUk2VG12dWd6d1FRZkRv?=
 =?utf-8?B?aW96N1FEU001RWlhcURqTUtqNDU4YnF3elpGVmdpbWk2SXhzQXhJNXpKYmpU?=
 =?utf-8?B?VEV3dG9xbUdKZkR6UVh3K3hyUnhSYnRSenhEc2xCbC9MK2N4NjNURlRTWFlx?=
 =?utf-8?B?YUpIc1lGVXM2UG1kcllpUW5GL3ZHR0lpd1d2aVpyMW1PSnFEZlhQNkJmc1JQ?=
 =?utf-8?B?cGlWMFpNR2VmeGZLbUFEZHdBeXJxWnpVRnpYRXl4UXpYNG9NQWdndEJZM1VV?=
 =?utf-8?B?aldsUnN4SlM5cFBUUmVrQ0ZXaDh6QUxmbkowQ21pR2YwaXhxQi82ZHBUYzVk?=
 =?utf-8?B?dVg5UWs5ckMxcDdEUkJubmVFZmNucnZUNE04YkxMRGZ2bWJPRGJiSWRhenhK?=
 =?utf-8?B?VGE2QkZmSThRS0d3Vk83cE42bGJiZFYyL1lOcFN5VUU2RnJkcEEzMldZWElH?=
 =?utf-8?B?RlJKWjludTVnRlM1L1U4emZFN25teURqenhwWEZuZW1QRUZXUVZXRGlZRi80?=
 =?utf-8?B?cHhxUjNYK0V2VjNOZHJ0bFlva1hnU3ErZHJOQitBK1djbE5uRWdPL1FLelZW?=
 =?utf-8?B?aUFyTFFvalc0NXJVSVhLRnl2ZXI2b2pvSmNRSVNoUFpGdTJhTXlQNVpjeE13?=
 =?utf-8?B?K1F3cW9yd0grWXd6blZOOVJ4Q0xBcGFhTENxSUhVMXc4T2FzNmhuTEc4Mmtx?=
 =?utf-8?B?ckFuOVFyK05ZOVV6QmwxclpGc0pJNmZlM3NwY2MxdHdLejl2Z2Y2NWNlbnFw?=
 =?utf-8?B?TEczTk1GTzdtaVNmcTVOMXd2cVg4c0xSWnJ0WG1IN3p5cTJha1A5eEI4N3I3?=
 =?utf-8?B?dnRFbkhjb1I2VGErL2k2NURhdlB4cUF5aUZQK3ZubGcyQmsrTUhXTVY2clpk?=
 =?utf-8?B?aFkwaEJyOE9HaG9vS0RQNXJ5TVExOFRRcWs1clNVUDU2U3c4Tm9uOXJkRUtj?=
 =?utf-8?B?MEpnREVrZURqWXduUm1kdzdZQngwMUU2T2liSjJGYXQzL1VWS1lCN1hBUWlO?=
 =?utf-8?B?Yi81azUzSnJJQU9jVjRJK2hCbUZDOTBzSFpHZGovZkRJT1dwcnB2TGNBZytN?=
 =?utf-8?B?L3lsR1NyWUxCdmdtVU9hdzE5R3BDVVRkdHdqK2hGMmc0MmtVVEVPSWY5K0ta?=
 =?utf-8?B?d0NTWWR3NFVFUGY3WjBQTUN1YmJwcjVrS0lvYzVzRjB6NmFDeG54V2JLQlZ3?=
 =?utf-8?B?T1l1LzJmRmZkMHZ4UnN4VGN4VnhiUVdaWnozQjdvK1pLVEk0Si9xaHQ3Nkth?=
 =?utf-8?B?bDBwellZL29IYS81cU5yeWFpV1RqV24zMGRHNG1KZHN6Q0VFZU1QeFBCOGVX?=
 =?utf-8?B?SXVSR3lydHJZM0ltVnJOMG5tN01SUDlFMVNZTHRlNERmb2xHdFNtNlREdzNS?=
 =?utf-8?B?Z1pEWFRmTjJpYU1WOW5rRkFrTjJLNW9sdTZ1aldFeXNWdG16SkRSNnF2Yi9N?=
 =?utf-8?B?eElWWjJ0a0x3TjdQQjRxdUczcTFRdDZEenZVR2FUTW1qS09WUFUxQUg3dGdI?=
 =?utf-8?B?VVlWU1hmNDFXZlRNUHpkZ21MdVJibzB4ZnNITmgyckoyTW1VLzE5L2FlL2lo?=
 =?utf-8?B?VFcwWmwxOHpIZGVZL09sMVZRK1hNOEljTjd0N0RCS0RvK1YrZWo0cDhyRWI5?=
 =?utf-8?B?ZDVJRlQ1R0krZlVNNlV6UjBxcnpyRDhEZWxBdm5ycSs1TmxVM0h5UnNyZnpQ?=
 =?utf-8?B?dHNCNUZkWVEwNHg2UnQ3eFFmdjhSQ2FUalVKdkxHQjV6MG9lUytBUEJBNGhZ?=
 =?utf-8?B?WTlsNWlrQ2ZJY3ZaODVjdmlNcDBwdFFxbElYZHhqcHhNUXdUUTJNSGxiVlAx?=
 =?utf-8?B?QlNkdkhObk5HVTJyS0txYUZrZCt1dUZlejN0NmRzMU0zeE1FUFhvRVFub2xT?=
 =?utf-8?B?SHpWbXRsbjNsdjhaYmxLaFNLMnR4NFVldmxSWTBHZEk5UjduelVNVWhNdWpP?=
 =?utf-8?B?S2FvYWtoNmlmVnhkYXE1R0pWSm9VVzJHVnFodE5weTBrQ2QvamM1cmVyS2dN?=
 =?utf-8?B?SlRoelJuMWNlamtjdnkxamhnbWl0Z0tweExLL2p5Sld0cUJuL3BpNjI5TGQr?=
 =?utf-8?Q?OWgvwiyaiwUfD+aEwA9oILGmVdHrB2cA59bQiF4FMY=3D?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f0fb3d2-8af9-4a3c-4342-08d9d525e3db
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2022 17:14:56.4970
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9Mv/HOwZaWCtPNw7913LZ+RgqM+I+YxCZeZ9sZ+RIP5TNwELOYqE8b0170OnlnWqB6TMq+2whpWELYgzjOkrQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5674
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKU2ln
bmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29t
PgotLS0KIGRyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93Zngvd2Z4LmggfCAxNjYgKysrKysr
KysrKysrKysrKysrKysrKysrKysKIDEgZmlsZSBjaGFuZ2VkLCAxNjYgaW5zZXJ0aW9ucygrKQog
Y3JlYXRlIG1vZGUgMTAwNjQ0IGRyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93Zngvd2Z4LmgK
CmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9zaWxhYnMvd2Z4L3dmeC5oIGIvZHJp
dmVycy9uZXQvd2lyZWxlc3Mvc2lsYWJzL3dmeC93ZnguaApuZXcgZmlsZSBtb2RlIDEwMDY0NApp
bmRleCAwMDAwMDAwMDAwMDAuLjBlMmNlMTEyZjE2ZgotLS0gL2Rldi9udWxsCisrKyBiL2RyaXZl
cnMvbmV0L3dpcmVsZXNzL3NpbGFicy93Zngvd2Z4LmgKQEAgLTAsMCArMSwxNjYgQEAKKy8qIFNQ
RFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wLW9ubHkgKi8KKy8qCisgKiBDb21tb24gcHJp
dmF0ZSBkYXRhLgorICoKKyAqIENvcHlyaWdodCAoYykgMjAxNy0yMDIwLCBTaWxpY29uIExhYm9y
YXRvcmllcywgSW5jLgorICogQ29weXJpZ2h0IChjKSAyMDEwLCBTVC1Fcmljc3NvbgorICogQ29w
eXJpZ2h0IChjKSAyMDA2LCBNaWNoYWVsIFd1IDxmbGFtaW5naWNlQHNvdXJtaWxrLm5ldD4KKyAq
IENvcHlyaWdodCAyMDA0LTIwMDYgSmVhbi1CYXB0aXN0ZSBOb3RlIDxqYm5vdGVAZ21haWwuY29t
PiwgZXQgYWwuCisgKi8KKyNpZm5kZWYgV0ZYX0gKKyNkZWZpbmUgV0ZYX0gKKworI2luY2x1ZGUg
PGxpbnV4L2NvbXBsZXRpb24uaD4KKyNpbmNsdWRlIDxsaW51eC93b3JrcXVldWUuaD4KKyNpbmNs
dWRlIDxsaW51eC9tdXRleC5oPgorI2luY2x1ZGUgPGxpbnV4L25vc3BlYy5oPgorI2luY2x1ZGUg
PG5ldC9tYWM4MDIxMS5oPgorCisjaW5jbHVkZSAiYmguaCIKKyNpbmNsdWRlICJkYXRhX3R4Lmgi
CisjaW5jbHVkZSAibWFpbi5oIgorI2luY2x1ZGUgInF1ZXVlLmgiCisjaW5jbHVkZSAiaGlmX3R4
LmgiCisKKyNkZWZpbmUgVVNFQ19QRVJfVFhPUCAzMiAvKiBzZWUgc3RydWN0IGllZWU4MDIxMV90
eF9xdWV1ZV9wYXJhbXMgKi8KKyNkZWZpbmUgVVNFQ19QRVJfVFUgMTAyNAorCitzdHJ1Y3Qgd2Z4
X2h3YnVzX29wczsKKworc3RydWN0IHdmeF9kZXYgeworCXN0cnVjdCB3ZnhfcGxhdGZvcm1fZGF0
YSAgIHBkYXRhOworCXN0cnVjdCBkZXZpY2UgICAgICAgICAgICAgICpkZXY7CisJc3RydWN0IGll
ZWU4MDIxMV9odyAgICAgICAgKmh3OworCXN0cnVjdCBpZWVlODAyMTFfdmlmICAgICAgICp2aWZb
Ml07CisJc3RydWN0IG1hY19hZGRyZXNzICAgICAgICAgYWRkcmVzc2VzWzJdOworCWNvbnN0IHN0
cnVjdCB3ZnhfaHdidXNfb3BzICpod2J1c19vcHM7CisJdm9pZCAgICAgICAgICAgICAgICAgICAg
ICAgKmh3YnVzX3ByaXY7CisKKwl1OCAgICAgICAgICAgICAgICAgICAgICAgICBrZXlzZXQ7CisJ
c3RydWN0IGNvbXBsZXRpb24gICAgICAgICAgZmlybXdhcmVfcmVhZHk7CisJc3RydWN0IHdmeF9o
aWZfaW5kX3N0YXJ0dXAgaHdfY2FwczsKKwlzdHJ1Y3Qgd2Z4X2hpZiAgICAgICAgICAgICBoaWY7
CisJc3RydWN0IGRlbGF5ZWRfd29yayAgICAgICAgY29vbGluZ190aW1lb3V0X3dvcms7CisJYm9v
bCAgICAgICAgICAgICAgICAgICAgICAgcG9sbF9pcnE7CisJYm9vbCAgICAgICAgICAgICAgICAg
ICAgICAgY2hpcF9mcm96ZW47CisJLyogcHJvdGVjdCBhbGwgdGhlIG1lbWJlcnMgYWJvdmUgKi8K
KwlzdHJ1Y3QgbXV0ZXggICAgICAgICAgICAgICBjb25mX211dGV4OworCisJc3RydWN0IHdmeF9o
aWZfY21kICAgICAgICAgaGlmX2NtZDsKKwlzdHJ1Y3Qgc2tfYnVmZl9oZWFkICAgICAgICB0eF9w
ZW5kaW5nOworCXdhaXRfcXVldWVfaGVhZF90ICAgICAgICAgIHR4X2RlcXVldWU7CisJYXRvbWlj
X3QgICAgICAgICAgICAgICAgICAgdHhfbG9jazsKKworCWF0b21pY190ICAgICAgICAgICAgICAg
ICAgIHBhY2tldF9pZDsKKwl1MzIgICAgICAgICAgICAgICAgICAgICAgICBrZXlfbWFwOworCisJ
Lyogcnhfc3RhdHMgaXMgYWNjZXNzZWQgZnJvbSBzZXZlcmFsIGNvbnRleHRzICovCisJc3RydWN0
IG11dGV4ICAgICAgICAgICAgICAgcnhfc3RhdHNfbG9jazsKKwlzdHJ1Y3Qgd2Z4X2hpZl9yeF9z
dGF0cyAgICByeF9zdGF0czsKKworCS8qIHR4X3Bvd2VyX2xvb3BfaW5mbyBpcyBhY2Nlc3NlZCBm
cm9tIHNldmVyYWwgY29udGV4dHMgKi8KKwlzdHJ1Y3QgbXV0ZXggICAgICAgICAgICAgICB0eF9w
b3dlcl9sb29wX2luZm9fbG9jazsKKwlzdHJ1Y3Qgd2Z4X2hpZl90eF9wb3dlcl9sb29wX2luZm8g
dHhfcG93ZXJfbG9vcF9pbmZvOworfTsKKworc3RydWN0IHdmeF92aWYgeworCXN0cnVjdCB3Znhf
ZGV2ICAgICAgICAgICAgICp3ZGV2OworCXN0cnVjdCBpZWVlODAyMTFfdmlmICAgICAgICp2aWY7
CisJc3RydWN0IGllZWU4MDIxMV9jaGFubmVsICAgKmNoYW5uZWw7CisJaW50ICAgICAgICAgICAg
ICAgICAgICAgICAgaWQ7CisKKwl1MzIgICAgICAgICAgICAgICAgICAgICAgICBsaW5rX2lkX21h
cDsKKworCWJvb2wgICAgICAgICAgICAgICAgICAgICAgIGFmdGVyX2R0aW1fdHhfYWxsb3dlZDsK
Kwlib29sICAgICAgICAgICAgICAgICAgICAgICBqb2luX2luX3Byb2dyZXNzOworCisJc3RydWN0
IGRlbGF5ZWRfd29yayAgICAgICAgYmVhY29uX2xvc3Nfd29yazsKKworCXN0cnVjdCB3ZnhfcXVl
dWUgICAgICAgICAgIHR4X3F1ZXVlWzRdOworCXN0cnVjdCB3ZnhfdHhfcG9saWN5X2NhY2hlIHR4
X3BvbGljeV9jYWNoZTsKKwlzdHJ1Y3Qgd29ya19zdHJ1Y3QgICAgICAgICB0eF9wb2xpY3lfdXBs
b2FkX3dvcms7CisKKwlzdHJ1Y3Qgd29ya19zdHJ1Y3QgICAgICAgICB1cGRhdGVfdGltX3dvcms7
CisKKwl1bnNpZ25lZCBsb25nICAgICAgICAgICAgICB1YXBzZF9tYXNrOworCisJLyogYXZvaWQg
c29tZSBvcGVyYXRpb25zIGluIHBhcmFsbGVsIHdpdGggc2NhbiAqLworCXN0cnVjdCBtdXRleCAg
ICAgICAgICAgICAgIHNjYW5fbG9jazsKKwlzdHJ1Y3Qgd29ya19zdHJ1Y3QgICAgICAgICBzY2Fu
X3dvcms7CisJc3RydWN0IGNvbXBsZXRpb24gICAgICAgICAgc2Nhbl9jb21wbGV0ZTsKKwlpbnQg
ICAgICAgICAgICAgICAgICAgICAgICBzY2FuX25iX2NoYW5fZG9uZTsKKwlib29sICAgICAgICAg
ICAgICAgICAgICAgICBzY2FuX2Fib3J0OworCXN0cnVjdCBpZWVlODAyMTFfc2Nhbl9yZXF1ZXN0
ICpzY2FuX3JlcTsKKworCXN0cnVjdCBjb21wbGV0aW9uICAgICAgc2V0X3BtX21vZGVfY29tcGxl
dGU7Cit9OworCitzdGF0aWMgaW5saW5lIHN0cnVjdCB3ZnhfdmlmICp3ZGV2X3RvX3d2aWYoc3Ry
dWN0IHdmeF9kZXYgKndkZXYsIGludCB2aWZfaWQpCit7CisJaWYgKHZpZl9pZCA+PSBBUlJBWV9T
SVpFKHdkZXYtPnZpZikpIHsKKwkJZGV2X2RiZyh3ZGV2LT5kZXYsICJyZXF1ZXN0aW5nIG5vbi1l
eGlzdGVudCB2aWY6ICVkXG4iLCB2aWZfaWQpOworCQlyZXR1cm4gTlVMTDsKKwl9CisJdmlmX2lk
ID0gYXJyYXlfaW5kZXhfbm9zcGVjKHZpZl9pZCwgQVJSQVlfU0laRSh3ZGV2LT52aWYpKTsKKwlp
ZiAoIXdkZXYtPnZpZlt2aWZfaWRdKQorCQlyZXR1cm4gTlVMTDsKKwlyZXR1cm4gKHN0cnVjdCB3
ZnhfdmlmICopd2Rldi0+dmlmW3ZpZl9pZF0tPmRydl9wcml2OworfQorCitzdGF0aWMgaW5saW5l
IHN0cnVjdCB3ZnhfdmlmICp3dmlmX2l0ZXJhdGUoc3RydWN0IHdmeF9kZXYgKndkZXYsIHN0cnVj
dCB3ZnhfdmlmICpjdXIpCit7CisJaW50IGk7CisJaW50IG1hcmsgPSAwOworCXN0cnVjdCB3Znhf
dmlmICp0bXA7CisKKwlpZiAoIWN1cikKKwkJbWFyayA9IDE7CisJZm9yIChpID0gMDsgaSA8IEFS
UkFZX1NJWkUod2Rldi0+dmlmKTsgaSsrKSB7CisJCXRtcCA9IHdkZXZfdG9fd3ZpZih3ZGV2LCBp
KTsKKwkJaWYgKG1hcmsgJiYgdG1wKQorCQkJcmV0dXJuIHRtcDsKKwkJaWYgKHRtcCA9PSBjdXIp
CisJCQltYXJrID0gMTsKKwl9CisJcmV0dXJuIE5VTEw7Cit9CisKK3N0YXRpYyBpbmxpbmUgaW50
IHd2aWZfY291bnQoc3RydWN0IHdmeF9kZXYgKndkZXYpCit7CisJaW50IGk7CisJaW50IHJldCA9
IDA7CisJc3RydWN0IHdmeF92aWYgKnd2aWY7CisKKwlmb3IgKGkgPSAwOyBpIDwgQVJSQVlfU0la
RSh3ZGV2LT52aWYpOyBpKyspIHsKKwkJd3ZpZiA9IHdkZXZfdG9fd3ZpZih3ZGV2LCBpKTsKKwkJ
aWYgKHd2aWYpCisJCQlyZXQrKzsKKwl9CisJcmV0dXJuIHJldDsKK30KKworc3RhdGljIGlubGlu
ZSB2b2lkIG1lbXJldmVyc2UodTggKnNyYywgdTggbGVuZ3RoKQoreworCXU4ICpsbyA9IHNyYzsK
Kwl1OCAqaGkgPSBzcmMgKyBsZW5ndGggLSAxOworCXU4IHN3YXA7CisKKwl3aGlsZSAobG8gPCBo
aSkgeworCQlzd2FwID0gKmxvOworCQkqbG8rKyA9ICpoaTsKKwkJKmhpLS0gPSBzd2FwOworCX0K
K30KKworc3RhdGljIGlubGluZSBpbnQgbWVtemNtcCh2b2lkICpzcmMsIHVuc2lnbmVkIGludCBz
aXplKQoreworCXU4ICpidWYgPSBzcmM7CisKKwlpZiAoIXNpemUpCisJCXJldHVybiAwOworCWlm
ICgqYnVmKQorCQlyZXR1cm4gMTsKKwlyZXR1cm4gbWVtY21wKGJ1ZiwgYnVmICsgMSwgc2l6ZSAt
IDEpOworfQorCisjZW5kaWYKLS0gCjIuMzQuMQoK
