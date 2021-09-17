Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 556F140FC02
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 17:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344784AbhIQPT6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 11:19:58 -0400
Received: from mail-dm6nam10on2057.outbound.protection.outlook.com ([40.107.93.57]:21473
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1344330AbhIQPRo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Sep 2021 11:17:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gvrpYqTXGia41U3EOFiCgfCIwAO2x0ysCgfWbLN5+aH2KzqQhGMzE6t22OjDYkCVCR85tcl0IPeatxYdOAsXJQiRvlEfV1MXhqVjlmYRpOjaxZyjFkFF/x/NuHaAwJn9PpePgP/Q3zNTpVkCPqYnFgpqCSdERrVn+jBzFXyKkKqDtCnnmeu0YI7BWm7zaQlTFy/dplDeKdnLQLdfmWD83GPX1MrzVrd+bjAJzVxdvCQvB9e1zzmAB1JnwLD1G0nhns65Qdf7xTO+CfdQhAq9NBdnKpS4qS0UeV96vyToRuSdck6QVTxnLvNtP0JshzdCSsCzNtUmnvCb7UsSCpHYvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=mUblQj3HYl3up8TQr4oInUGypnja+FbX2pQYP1SXPC0=;
 b=L0LsN0WPX4V36pbcshTd0N8CaNbQgddxWcsZdbCjEDsWVYavyGw1KF4O73zie2668iEdVyVIHXH9fOdUHeHdlShXQy4zBRu4XlguQQ7hdL6FNgGYn/JUK6UYn3TdBJaUzEgAGIbiqmtG/LG2WuGAFn4i7Mwin16h3mElIgHCPk4O2MXBo1NxgITJeTOm8nY0RGcM0WsSlblttLDxBX6yyrhc4b5MPVL85If/MYzvoDG00Y7VDkHJA3AX0uP0boU7931sQpHMHXLmCeKOD6UOMruTSIjkzvFiwLLGThaayRIdWFsb+Ge8C3iILkYK3QRbXk/KSptE6vo+Wo0IYPY4hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mUblQj3HYl3up8TQr4oInUGypnja+FbX2pQYP1SXPC0=;
 b=aeIqb6MqJMY+f5v/mI8PF5CSRc7YhXCDRpb1AZEmTSpz8ooORX0xXuDyBHDx1Sn3E0ixq+FDnhtLnW4EmcpclW1IDwVwAY0r1Xa1MHRrVIukHx3fOZFfHDaDsFqMREwaEBwLEKyEkhhksfpeOuEIEuyyijZ+YsBvP8QXZBgf+Qc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB3360.namprd11.prod.outlook.com (2603:10b6:805:c8::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Fri, 17 Sep
 2021 15:15:20 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Fri, 17 Sep 2021
 15:15:20 +0000
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
Subject: [PATCH v6 24/24] wfx: get out from the staging area
Date:   Fri, 17 Sep 2021 17:14:00 +0200
Message-Id: <20210917151401.2274772-25-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210917151401.2274772-1-Jerome.Pouiller@silabs.com>
References: <20210917151401.2274772-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: SA9PR03CA0029.namprd03.prod.outlook.com
 (2603:10b6:806:20::34) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (2a01:e34:ecb5:66a0:9876:e1d7:65be:d294) by SA9PR03CA0029.namprd03.prod.outlook.com (2603:10b6:806:20::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Fri, 17 Sep 2021 15:15:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ebf79515-482e-4ea5-a8b4-08d979edf6ab
X-MS-TrafficTypeDiagnostic: SN6PR11MB3360:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB3360EAB0DC8EE03273F9BAB493DD9@SN6PR11MB3360.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J7xp4oIgGG8EimNhA2RCQhw3frK0wwIyPNXIZDbUdltNaWBZ3THgToLQSqALldcZvNHvIipd4L/zPYtL0UoE8YDS/PH0CQxffGYzC7lz1GSYGRhIy2bMM4QbDq/8MEB6i83F0XpXqLIZ3ahZpBgN//1j2W22fjyiB9uvCiRIHyR0rHwhx5OPT1mNf0sRp4RoRS/b7z5pxt+uXo5MIq0eg3rDOuXl/DlXurXxyBEeOANt8qbd7nW0zttrnMMCoSIn4izeATGhGzjBZzwvsn5cCuVNET//AnMspxjEiFkn44gC49RtMEUn2DrakHmCSLcSouSaArapMD+zAhz0+A0sjucPtlF0qjVo8A9lS9z0U3sXIRYqJuUT8a1pqLYLmECv08CT8abHdKOsS42kTfIO53T471G8mLfwhVVo7o4eMZ9+aTLR8pXIhu8r+J41TaemWabXmGJkk0NZyDmv8abYSAYpgFlBhvImL0QnlsXg9SApyLPlZVL19kCKB6n/Q4CU6/ElvnRC82arpsHnTRRGFNqkLRWZ0uuiPVy6wLd0Jw/WsHTF0y/0XbTH0wXZ8P2F8iwc/6GVA/Z3Bb07r9XyvpXnHQdMmLvYuHZgV2hqxAzIW8ujQMDHHZ6dgiWuUbV+S9cAGa0os/TBlnDIWSHwQx7Ntwb7hyVb4eybIdHxgoxK5SFZw9sjbLC4CvOEnPZDXFDGb68kK9cVLOHLrrgh/GvC76qALmNLQWMu6rY1NSQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39850400004)(376002)(346002)(396003)(136003)(8936002)(966005)(5660300002)(36756003)(7696005)(86362001)(83380400001)(52116002)(54906003)(66476007)(107886003)(66556008)(8676002)(66946007)(316002)(2616005)(7416002)(6916009)(4326008)(38100700002)(66574015)(6666004)(186003)(478600001)(6486002)(2906002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Rnh3ZnFwTWtXM1YrdEVubmdPeFlhU2Vld3M0ZC9NeHZEOTg1d2xWdUxEWldz?=
 =?utf-8?B?eUJwSU1wQlNHRmIrcCt0SGFsRDdmMEFCckRvMGVWd0NZUWRBUkxNbC9yUDBk?=
 =?utf-8?B?MmhadTNqRnRFOExzeWZYbVNvQ3MrUDMvRkhXTjU3WVNudWJESWZEOWtuWUhC?=
 =?utf-8?B?RGN6OUMwV045Lzkwc3oxQWt5U0l3UUlWRmxoVW4zc0pFUm9aOTNxN0dvTUNL?=
 =?utf-8?B?OXFESnI0R3lDN2pRNTFKT1dIWWcyOC9lMjRhOHdia2IwaWVHQTBZRkZKMWxE?=
 =?utf-8?B?UlYzVWNBenJJbndkQngyMksybUFDNCtObG1Qb3piZHRNRCtPZWNiUnYrYzkv?=
 =?utf-8?B?MWJlNHRWemNrZHBxVHpYOGVjMUMvUGVHOXFFMjVLaU9EVDQ0eloreXpFREVZ?=
 =?utf-8?B?VFBxMlA1MDU5VFl5SHBlK3NnZ3BpZXE0ekY5YVhzVDVIdDQ1L2J2NGdQdUhU?=
 =?utf-8?B?SXVvL3VpMVRzR3ZsZlBjQ2pGMVVOc29CN25RV1FWQVEzSVFxb2NYTWYrUS9W?=
 =?utf-8?B?NmZwNGdaUFB5NFJXTmQ0SjRIaTZLKzh4NmR5Z2l5bzluYWo5Smh0L1cxZGJj?=
 =?utf-8?B?MlA5ZFd5bkIwMm9iNjhsdkFHUi9IVlBxaXNQT0pLZHZhL0VmVTlkZ04zc29K?=
 =?utf-8?B?S0tJYmZrMU1yWVVHNDRYQXBtM2xhS0VYcFhaazdLVjFweXY0NkxGRHRTdnE0?=
 =?utf-8?B?Y1B1M0ZTMm9DQzU3WXFXVElwa2F0aktjTHBJYXh2ZW9Gc2JaNENETEs5TWxT?=
 =?utf-8?B?ejJPM0twaTdickttcmMxWkJCME5HQmpITi9oUkg3eTFpQXlNYU9MS1QrbjZM?=
 =?utf-8?B?cmw4Wk12TmFwbC9VS2xDa3hyUHNydHNxdCtZTXhLcUV4c0hXY3NkblBNNFI4?=
 =?utf-8?B?YzJkTFRnSTJtYVJIZXgzamYzNm5MVmRmUm5XdzNsbGNxR0dlOHNLMUVZRmE2?=
 =?utf-8?B?Sy9KQmZBR0FnT0JwZkFzZHErQnhZaU5yNGdqbDRjYmhlbVpVYit5aGlQUDlM?=
 =?utf-8?B?ZFVsQ1Q3TFRIeHN0VHdCME9vemVweEZYV05FVzBQc2VhRTVOWENXWHAyUkJL?=
 =?utf-8?B?NXJQTzVwcHNNYVpqd3JTbkJKUCthYWJ4QUVHUThUbDFCamtDcFBTYm91UU1P?=
 =?utf-8?B?L2ZhT1N2b1UvT3VkdXNpSzZzdlJLRHVHOWtyeEwyc2hKUkhTTGhCY3dadnlU?=
 =?utf-8?B?L0NlWXVyS25iVnR3UEsrcEtRM0lBNytBMkJSMmJtVGFlN2xwMGVtVXpRVUZM?=
 =?utf-8?B?aTVHM0grV3ZrRW13blo1akdiN3lKN3B1Y3l5aWQwbE84VE1FSVBpUWIyRk5L?=
 =?utf-8?B?bU5kZC9VT1lrbmdpL2VSVkFUL3hieEltT1VRUTZ3S0p4eHpmQksyZGpUTHlS?=
 =?utf-8?B?bEVPblNteE1NbkVTeGY1ellFc1pudUc2ck0xN0ZHbUw5Y0hoRHdiQ3VBQUxY?=
 =?utf-8?B?S05TVngzaU9OSVlFSWk3ZENhaEthY3l1YjY4RUhWVWUwNlllenZreG41eHpX?=
 =?utf-8?B?czdpZk1QK1I0NUc4WCtUT1FrVmx0bkl2NmxBTmF4MzIza1hVT3k0QTJnM2Y0?=
 =?utf-8?B?dGVBTEJEMXJTbzllaW8zZlhGbHFjM0o4bGVaNWpKQVArN2wrUmVvTnY4OFl5?=
 =?utf-8?B?LzFuNTZ1YmcwYzBPWVBOdUhqbm1Kazg5OHI4VVRpZjgzVW1DS0c4ZEJqQjhx?=
 =?utf-8?B?bWpTenNwNGx5NkRNaG5GZ0pveTBicGp4M3M0ajBWZmw5R3dwRDcxMXlVNkhW?=
 =?utf-8?B?citWQk1ma1I4Y0tNUVlyTlc4R0IvaCtNSXJOaWdNTWdZUUNXSlNuQ0VrL0NC?=
 =?utf-8?B?QytleE9EV2hHaElUaDh5WmFOU28vR3hZbHJ6d3ZyZjNjNUwvdGZ4QTFBbGI4?=
 =?utf-8?Q?xa0v4rNUlfJae?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebf79515-482e-4ea5-a8b4-08d979edf6ab
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2021 15:15:20.4699
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mn0v+jp2LUcJm7uatmNVxj9Zgxk4FpLjFGsnx92uAIqlZlGo5XAVJMtvlGb9W4GjKvNfkgT7LD4N/DBSzKrzLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3360
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IHdmeCBkcml2ZXIgaXMgbm93IG1hdHVyZSBlbm91Z2ggdG8gbGVhdmUgdGhlIHN0YWdpbmcgYXJl
YS4KClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2ls
YWJzLmNvbT4KLS0tCiBNQUlOVEFJTkVSUyAgICAgICAgICAgICAgICAgICAgICAgICAgfCAgMyAr
Ky0KIGRyaXZlcnMvbmV0L3dpcmVsZXNzL0tjb25maWcgICAgICAgICB8ICAxICsKIGRyaXZlcnMv
bmV0L3dpcmVsZXNzL01ha2VmaWxlICAgICAgICB8ICAxICsKIGRyaXZlcnMvbmV0L3dpcmVsZXNz
L3NpbGFicy9LY29uZmlnICB8IDE4ICsrKysrKysrKysrKysrKysrKwogZHJpdmVycy9uZXQvd2ly
ZWxlc3Mvc2lsYWJzL01ha2VmaWxlIHwgIDMgKysrCiBkcml2ZXJzL3N0YWdpbmcvS2NvbmZpZyAg
ICAgICAgICAgICAgfCAgMSAtCiBkcml2ZXJzL3N0YWdpbmcvTWFrZWZpbGUgICAgICAgICAgICAg
fCAgMSAtCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L1RPRE8gICAgICAgICAgICAgfCAgNiAtLS0tLS0K
IDggZmlsZXMgY2hhbmdlZCwgMjUgaW5zZXJ0aW9ucygrKSwgOSBkZWxldGlvbnMoLSkKIGNyZWF0
ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL25ldC93aXJlbGVzcy9zaWxhYnMvS2NvbmZpZwogY3JlYXRl
IG1vZGUgMTAwNjQ0IGRyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy9NYWtlZmlsZQogZGVsZXRl
IG1vZGUgMTAwNjQ0IGRyaXZlcnMvc3RhZ2luZy93ZngvVE9ETwoKZGlmZiAtLWdpdCBhL01BSU5U
QUlORVJTIGIvTUFJTlRBSU5FUlMKaW5kZXggZWViNGM3MGIzZDViLi41MTk5M2Y2ODM3OWEgMTAw
NjQ0Ci0tLSBhL01BSU5UQUlORVJTCisrKyBiL01BSU5UQUlORVJTCkBAIC0xNzA5OSw3ICsxNzA5
OSw4IEBAIEY6CWRyaXZlcnMvcGxhdGZvcm0veDg2L3RvdWNoc2NyZWVuX2RtaS5jCiBTSUxJQ09O
IExBQlMgV0lSRUxFU1MgRFJJVkVSUyAoZm9yIFdGeHh4IHNlcmllcykKIE06CUrDqXLDtG1lIFBv
dWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4KIFM6CVN1cHBvcnRlZAotRjoJZHJp
dmVycy9zdGFnaW5nL3dmeC8KK0Y6CURvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9u
ZXQvd2lyZWxlc3Mvc2lsYWJzLHdmeC55YW1sCitGOglkcml2ZXJzL25ldC93aXJlbGVzcy9zaWxh
YnMvd2Z4LwogCiBTSUxJQ09OIE1PVElPTiBTTTcxMiBGUkFNRSBCVUZGRVIgRFJJVkVSCiBNOglT
dWRpcCBNdWtoZXJqZWUgPHN1ZGlwbS5tdWtoZXJqZWVAZ21haWwuY29tPgpkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9uZXQvd2lyZWxlc3MvS2NvbmZpZyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL0tjb25m
aWcKaW5kZXggN2FkZDIwMDJmZjRjLi5lNzhmZjdhZjY1MTcgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMv
bmV0L3dpcmVsZXNzL0tjb25maWcKKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvS2NvbmZpZwpA
QCAtMzEsNiArMzEsNyBAQCBzb3VyY2UgImRyaXZlcnMvbmV0L3dpcmVsZXNzL21pY3JvY2hpcC9L
Y29uZmlnIgogc291cmNlICJkcml2ZXJzL25ldC93aXJlbGVzcy9yYWxpbmsvS2NvbmZpZyIKIHNv
dXJjZSAiZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9LY29uZmlnIgogc291cmNlICJkcml2
ZXJzL25ldC93aXJlbGVzcy9yc2kvS2NvbmZpZyIKK3NvdXJjZSAiZHJpdmVycy9uZXQvd2lyZWxl
c3Mvc2lsYWJzL0tjb25maWciCiBzb3VyY2UgImRyaXZlcnMvbmV0L3dpcmVsZXNzL3N0L0tjb25m
aWciCiBzb3VyY2UgImRyaXZlcnMvbmV0L3dpcmVsZXNzL3RpL0tjb25maWciCiBzb3VyY2UgImRy
aXZlcnMvbmV0L3dpcmVsZXNzL3p5ZGFzL0tjb25maWciCmRpZmYgLS1naXQgYS9kcml2ZXJzL25l
dC93aXJlbGVzcy9NYWtlZmlsZSBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL01ha2VmaWxlCmluZGV4
IDgwYjMyNDQ5OTc4Ni4uNzY4ODVlNWYwZWE3IDEwMDY0NAotLS0gYS9kcml2ZXJzL25ldC93aXJl
bGVzcy9NYWtlZmlsZQorKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9NYWtlZmlsZQpAQCAtMTYs
NiArMTYsNyBAQCBvYmotJChDT05GSUdfV0xBTl9WRU5ET1JfTUlDUk9DSElQKSArPSBtaWNyb2No
aXAvCiBvYmotJChDT05GSUdfV0xBTl9WRU5ET1JfUkFMSU5LKSArPSByYWxpbmsvCiBvYmotJChD
T05GSUdfV0xBTl9WRU5ET1JfUkVBTFRFSykgKz0gcmVhbHRlay8KIG9iai0kKENPTkZJR19XTEFO
X1ZFTkRPUl9SU0kpICs9IHJzaS8KK29iai0kKENPTkZJR19XTEFOX1ZFTkRPUl9TSUxBQlMpICs9
IHNpbGFicy8KIG9iai0kKENPTkZJR19XTEFOX1ZFTkRPUl9TVCkgKz0gc3QvCiBvYmotJChDT05G
SUdfV0xBTl9WRU5ET1JfVEkpICs9IHRpLwogb2JqLSQoQ09ORklHX1dMQU5fVkVORE9SX1pZREFT
KSArPSB6eWRhcy8KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy9LY29u
ZmlnIGIvZHJpdmVycy9uZXQvd2lyZWxlc3Mvc2lsYWJzL0tjb25maWcKbmV3IGZpbGUgbW9kZSAx
MDA2NDQKaW5kZXggMDAwMDAwMDAwMDAwLi42MjYyYTc5OWJmMzYKLS0tIC9kZXYvbnVsbAorKysg
Yi9kcml2ZXJzL25ldC93aXJlbGVzcy9zaWxhYnMvS2NvbmZpZwpAQCAtMCwwICsxLDE4IEBACisj
IFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wCisKK2NvbmZpZyBXTEFOX1ZFTkRPUl9T
SUxBQlMKKwlib29sICJTaWxpY29uIExhYm9yYXRvcmllcyBkZXZpY2VzIgorCWRlZmF1bHQgeQor
CWhlbHAKKwkgIElmIHlvdSBoYXZlIGEgd2lyZWxlc3MgY2FyZCBiZWxvbmdpbmcgdG8gdGhpcyBj
bGFzcywgc2F5IFkuCisKKwkgIE5vdGUgdGhhdCB0aGUgYW5zd2VyIHRvIHRoaXMgcXVlc3Rpb24g
ZG9lc24ndCBkaXJlY3RseSBhZmZlY3QgdGhlCisJICBrZXJuZWw6IHNheWluZyBOIHdpbGwganVz
dCBjYXVzZSB0aGUgY29uZmlndXJhdG9yIHRvIHNraXAgYWxsIHRoZQorCSAgcXVlc3Rpb25zIGFi
b3V0IHRoZXNlIGNhcmRzLiBJZiB5b3Ugc2F5IFksIHlvdSB3aWxsIGJlIGFza2VkIGZvcgorCSAg
eW91ciBzcGVjaWZpYyBjYXJkIGluIHRoZSBmb2xsb3dpbmcgcXVlc3Rpb25zLgorCitpZiBXTEFO
X1ZFTkRPUl9TSUxBQlMKKworc291cmNlICJkcml2ZXJzL25ldC93aXJlbGVzcy9zaWxhYnMvd2Z4
L0tjb25maWciCisKK2VuZGlmICMgV0xBTl9WRU5ET1JfU0lMQUJTCmRpZmYgLS1naXQgYS9kcml2
ZXJzL25ldC93aXJlbGVzcy9zaWxhYnMvTWFrZWZpbGUgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9z
aWxhYnMvTWFrZWZpbGUKbmV3IGZpbGUgbW9kZSAxMDA2NDQKaW5kZXggMDAwMDAwMDAwMDAwLi5j
MjI2M2VlMjEwMDYKLS0tIC9kZXYvbnVsbAorKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9zaWxh
YnMvTWFrZWZpbGUKQEAgLTAsMCArMSwzIEBACisjIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBH
UEwtMi4wCisKK29iai0kKENPTkZJR19XRlgpICAgICAgKz0gd2Z4LwpkaWZmIC0tZ2l0IGEvZHJp
dmVycy9zdGFnaW5nL0tjb25maWcgYi9kcml2ZXJzL3N0YWdpbmcvS2NvbmZpZwppbmRleCBlMDM2
MjdhZDQ0NjAuLjY2NmUyM2EzY2U3ZSAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL0tjb25m
aWcKKysrIGIvZHJpdmVycy9zdGFnaW5nL0tjb25maWcKQEAgLTEwMCw2ICsxMDAsNSBAQCBzb3Vy
Y2UgImRyaXZlcnMvc3RhZ2luZy9maWVsZGJ1cy9LY29uZmlnIgogCiBzb3VyY2UgImRyaXZlcnMv
c3RhZ2luZy9xbGdlL0tjb25maWciCiAKLXNvdXJjZSAiZHJpdmVycy9zdGFnaW5nL3dmeC9LY29u
ZmlnIgogCiBlbmRpZiAjIFNUQUdJTkcKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy9NYWtl
ZmlsZSBiL2RyaXZlcnMvc3RhZ2luZy9NYWtlZmlsZQppbmRleCBjN2Y4ZDhkOGRkMTEuLjUyYTBh
ZTFlMWE1MiAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL01ha2VmaWxlCisrKyBiL2RyaXZl
cnMvc3RhZ2luZy9NYWtlZmlsZQpAQCAtNDAsNCArNDAsMyBAQCBvYmotJChDT05GSUdfU09DX01U
NzYyMSkJKz0gbXQ3NjIxLWR0cy8KIG9iai0kKENPTkZJR19YSUxfQVhJU19GSUZPKQkrPSBheGlz
LWZpZm8vCiBvYmotJChDT05GSUdfRklFTERCVVNfREVWKSAgICAgKz0gZmllbGRidXMvCiBvYmot
JChDT05GSUdfUUxHRSkJCSs9IHFsZ2UvCi1vYmotJChDT05GSUdfV0ZYKQkJKz0gd2Z4LwpkaWZm
IC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9UT0RPIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9U
T0RPCmRlbGV0ZWQgZmlsZSBtb2RlIDEwMDY0NAppbmRleCAxYjRiYzJhZjk0YjYuLjAwMDAwMDAw
MDAwMAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L1RPRE8KKysrIC9kZXYvbnVsbApAQCAtMSw2
ICswLDAgQEAKLVRoaXMgaXMgYSBsaXN0IG9mIHRoaW5ncyB0aGF0IG5lZWQgdG8gYmUgZG9uZSB0
byBnZXQgdGhpcyBkcml2ZXIgb3V0IG9mIHRoZQotc3RhZ2luZyBkaXJlY3RvcnkuCi0KLSAgLSBB
cyBzdWdnZXN0ZWQgYnkgRmVsaXgsIHJhdGUgY29udHJvbCBjb3VsZCBiZSBpbXByb3ZlZCBmb2xs
b3dpbmcgdGhpcyBpZGVhOgotICAgICAgICBodHRwczovL2xvcmUua2VybmVsLm9yZy9sa21sLzMw
OTk1NTkuZ3YzUTc1S25OMUBwYy00Mi8KLQotLSAKMi4zMy4wCgo=
