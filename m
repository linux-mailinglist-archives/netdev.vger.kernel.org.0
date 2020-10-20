Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD44293C54
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 14:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406816AbgJTM6z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 08:58:55 -0400
Received: from mail-dm6nam12on2042.outbound.protection.outlook.com ([40.107.243.42]:21473
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2406718AbgJTM6v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 08:58:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AFTt8D+7tkrDX/pPPsDh22AIEwZaqNkXAM+NVxHyzhC2dgDSewtOabP3+Jg6OeHPSH32obvW6TrnEcGNnmSefnlpBDGOepSANHNxb8zK4kvclYJRZ5/7rqzxV/9tPK9BSEFA8LE/3nopV/4rTSGLHimsRBDtEl+E3R7dMpyox8T6xBkoALbsz0BIkTqDhWbRpbbDfvzItUl3GQ6aJc/DoOWg6Dpx2NpJrYlTsdMYcXk9xlZZccmgfs94kUVvKOIi/FkYLpf2zrBvbtpFNj54EvuiF8E69j0lEwJkj5bW1eYzASvGH5HZRtbB6n7crYaUVk1/SK/bIEatsdQ5VvtkYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cgq74Svg2j+DyJGRMumSG/SA0djbHNEWUreSI8ZV05o=;
 b=MU2dU0UFlh0FMqrQ1FVzoOn+ctp+Pnds6bDX+PAnqhPuZ93ORs4aNdDAFOxWK07vzl7oZ1a6SmlloAUPZoCyKWsz0OKDZUnaqTRxL9J3UMonCFV5sPdbG61mFnmTNmMWxQnWfcNewBGV0qVcS+KYJnSOPNwWrXHTznv/OYq5O8arYIPb/4UB2v8hSassgqwPmrVQMqDdh+3M6/+aIL9J7Zv77vQ6/hgCfkFkVhQ1lKQ33DLXgOFPQ7MeMd1BXkouuj1M54bfMNH2EzBd9qoqRW54FFUxXT+F5FabcZ0+Fi+XPYLybZaVs0HVt5iRl3VfeB3IaF7CxYmnkIxuQ8n3QQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cgq74Svg2j+DyJGRMumSG/SA0djbHNEWUreSI8ZV05o=;
 b=RxqI3DPM9dPliTlYHMq4mNSw4dHxR3JlikhbZd+4qNLTMMmrLoUQH4Xt+ETTHckjU2Vw9r1cy2koQgof3O1x08NoNvb844iLNv7VPb3D4ERGzZ1JCRyjatXTNS7BvVDw0M+3O2EX7WCYtFn73sqlt0/n5BHGyjzYda7rdeWmPrI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB2656.namprd11.prod.outlook.com (2603:10b6:805:58::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.28; Tue, 20 Oct
 2020 12:58:46 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::4f5:fbe5:44a7:cb8a]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::4f5:fbe5:44a7:cb8a%5]) with mapi id 15.20.3477.028; Tue, 20 Oct 2020
 12:58:46 +0000
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
Subject: [PATCH v2 02/24] dt-bindings: introduce silabs,wfx.yaml
Date:   Tue, 20 Oct 2020 14:57:55 +0200
Message-Id: <20201020125817.1632995-3-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201020125817.1632995-1-Jerome.Pouiller@silabs.com>
References: <20201020125817.1632995-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Originating-IP: [37.71.187.125]
X-ClientProxiedBy: PR3P192CA0026.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:102:56::31) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (37.71.187.125) by PR3P192CA0026.EURP192.PROD.OUTLOOK.COM (2603:10a6:102:56::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21 via Frontend Transport; Tue, 20 Oct 2020 12:58:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9647eadb-61ce-41c7-6a9e-08d874f7e130
X-MS-TrafficTypeDiagnostic: SN6PR11MB2656:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB2656A5AC271FB13D15F472AF931F0@SN6PR11MB2656.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WWEpzeZ72c1Ehk4dv8YflRJORWI/RuoPOcE5ilMbnX5sF00+0L6UaoPF1ywPd0HcrpkOcrZ6hyy24fB7pnOQ0XU2RSg4PyxZc5CKikIkGYD/DTjsJVF3eyMUuMbH2kRk65lFBrInNW7+jItqlCIlOtqTCT2UXU4vF38la0Uo9l/6g+kaPJhMkZgoJShOvECYhuqKnYwjLVNDq6lzMZyKh3xUNpUqHlnNK9B5nUD2K7lUWSDBZZt+tEfHZ54uUf85skQ/rqKiWVDLCV5f7Yq8lMENDocMtSlz6WXUIhutrFhqOGm2RK4KaNUPZBmWGehpiXRI0mKcuAwoF2HfnICODNkNrDCfiq3ovN1M4UB4fg3QNzshnvw7eCoLDa/xOrpX4VqTmh+Ty1hGIS52U7FrHw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(136003)(39830400003)(346002)(376002)(186003)(316002)(4326008)(107886003)(8676002)(86362001)(26005)(2906002)(7696005)(478600001)(16526019)(956004)(6486002)(966005)(52116002)(36756003)(8936002)(2616005)(54906003)(5660300002)(1076003)(7416002)(6666004)(66556008)(66476007)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: SCiGMU9Wlv7lXSaOy6T0mtAqVV/MBf2H7ybDfpH7jMAz0b0axlN4QCPyisIJZVO3d6PiCk3GXHmwIBg77IPC4/kl1vMjdywRIUPETROJBX0GIMdIFTLK/QLPpkaGymzdeHnqTwvAaW6WJttqWFqz6RnFe6MjA6WTWhGD/GDOm1D11WezHk7Rgi829q6qxZvgQLszCVPJeXjCbabSfpXaaMAc2uQlHozGh0F2X0gH224HVNoHUbZHaVBVIUopQ2XyGr9j+t5n9pvwRuFOgOCrr84RpYzwfaAO236kgIDswKtz2OL0kWzHiZMgGeOOn/7EPrW18OdaTFPyYDYs6nr507p04RlJ8PMcqx/UV7Gpz9jBhvDpqptEv4f/7kE23gLPBuU4yyc/8GghINrH0I0gr0P9pcf7GILrIEh3zSAcTbaAd5Ypv+y8z5sit+cGbWcpBO0npacCJ3+w6GIqgYrIEzBs+8KhNVadP7nWL7hFjDoRwq5zlWjAPjt75XvEo5ZsxAa4UuYWIrfhO/l6GFWC7k4zGXXnMbSTr1lMusUk0gorET33Sjgmau9ic6fBfiGh4P9+qZkpq3+YUTc9g+Y5/RfcyYYoh8f/D2QIx5hwYPzEmrj0XVQtRR2h3gG9Viry8oP5Avd2JOURIVgaX5jl5g==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9647eadb-61ce-41c7-6a9e-08d874f7e130
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2020 12:58:45.8564
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SZgNidQUAmjyqRRTXlNcqWF9Yrk8bVVj19UtEdN2G7jGKkf0Z8HRm2gzO1uNED8I0ZEvCqgkHAkh12F0D+jQdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2656
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
ZmlsZSBtb2RlIDEwMDY0NAppbmRleCAwMDAwMDAwMDAwMDAuLjI2MDVlOWZlZDE4NQotLS0gL2Rl
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
ZmVhdHVyZXMuCisgICAgbWF4SXRlbXM6IDEKKworICBjb25maWctZmlsZToKKyAgICBkZXNjcmlw
dGlvbjogVXNlIGFuIGFsdGVybmF0aXZlIGZpbGUgYXMgUERTLiBEZWZhdWx0IGlzIGB3ZjIwMC5w
ZHNgLgorCisgIGxvY2FsLW1hYy1hZGRyZXNzOgorICAgICRyZWY6IC9uZXQvZXRoZXJuZXQtY29u
dHJvbGxlci55YW1sIy9wcm9wZXJ0aWVzL2xvY2FsLW1hYy1hZGRyZXNzCisKKyAgbWFjLWFkZHJl
c3M6CisgICAgJHJlZjogL25ldC9ldGhlcm5ldC1jb250cm9sbGVyLnlhbWwjL3Byb3BlcnRpZXMv
bWFjLWFkZHJlc3MKKworYWRkaXRpb25hbFByb3BlcnRpZXM6IHRydWUKKworcmVxdWlyZWQ6Cisg
IC0gY29tcGF0aWJsZQorICAtIHJlZworCitleGFtcGxlczoKKyAgLSB8CisgICAgI2luY2x1ZGUg
PGR0LWJpbmRpbmdzL2dwaW8vZ3Bpby5oPgorICAgICNpbmNsdWRlIDxkdC1iaW5kaW5ncy9pbnRl
cnJ1cHQtY29udHJvbGxlci9pcnEuaD4KKworICAgIHNwaTAgeworICAgICAgICAjYWRkcmVzcy1j
ZWxscyA9IDwxPjsKKyAgICAgICAgI3NpemUtY2VsbHMgPSA8MD47CisKKyAgICAgICAgd2Z4QDAg
eworICAgICAgICAgICAgY29tcGF0aWJsZSA9ICJzaWxhYnMsd2YyMDAiOworICAgICAgICAgICAg
cGluY3RybC1uYW1lcyA9ICJkZWZhdWx0IjsKKyAgICAgICAgICAgIHBpbmN0cmwtMCA9IDwmd2Z4
X2lycSAmd2Z4X2dwaW9zPjsKKyAgICAgICAgICAgIHJlZyA9IDwwPjsKKyAgICAgICAgICAgIGlu
dGVycnVwdHMtZXh0ZW5kZWQgPSA8JmdwaW8gMTYgSVJRX1RZUEVfRURHRV9SSVNJTkc+OworICAg
ICAgICAgICAgd2FrZXVwLWdwaW9zID0gPCZncGlvIDEyIEdQSU9fQUNUSVZFX0hJR0g+OworICAg
ICAgICAgICAgcmVzZXQtZ3Bpb3MgPSA8JmdwaW8gMTMgR1BJT19BQ1RJVkVfTE9XPjsKKyAgICAg
ICAgICAgIHNwaS1tYXgtZnJlcXVlbmN5ID0gPDQyMDAwMDAwPjsKKyAgICAgICAgfTsKKyAgICB9
OworCisgIC0gfAorICAgICNpbmNsdWRlIDxkdC1iaW5kaW5ncy9ncGlvL2dwaW8uaD4KKyAgICAj
aW5jbHVkZSA8ZHQtYmluZGluZ3MvaW50ZXJydXB0LWNvbnRyb2xsZXIvaXJxLmg+CisKKyAgICB3
ZnhfcHdyc2VxOiB3ZnhfcHdyc2VxIHsKKyAgICAgICAgY29tcGF0aWJsZSA9ICJtbWMtcHdyc2Vx
LXNpbXBsZSI7CisgICAgICAgIHBpbmN0cmwtbmFtZXMgPSAiZGVmYXVsdCI7CisgICAgICAgIHBp
bmN0cmwtMCA9IDwmd2Z4X3Jlc2V0PjsKKyAgICAgICAgcmVzZXQtZ3Bpb3MgPSA8JmdwaW8gMTMg
R1BJT19BQ1RJVkVfTE9XPjsKKyAgICB9OworCisgICAgbW1jMCB7CisgICAgICAgIG1tYy1wd3Jz
ZXEgPSA8JndmeF9wd3JzZXE+OworICAgICAgICAjYWRkcmVzcy1jZWxscyA9IDwxPjsKKyAgICAg
ICAgI3NpemUtY2VsbHMgPSA8MD47CisKKyAgICAgICAgbW1jQDEgeworICAgICAgICAgICAgY29t
cGF0aWJsZSA9ICJzaWxhYnMsd2YyMDAiOworICAgICAgICAgICAgcGluY3RybC1uYW1lcyA9ICJk
ZWZhdWx0IjsKKyAgICAgICAgICAgIHBpbmN0cmwtMCA9IDwmd2Z4X3dha2V1cD47CisgICAgICAg
ICAgICByZWcgPSA8MT47CisgICAgICAgICAgICB3YWtldXAtZ3Bpb3MgPSA8JmdwaW8gMTIgR1BJ
T19BQ1RJVkVfSElHSD47CisgICAgICAgIH07CisgICAgfTsKKy4uLgotLSAKMi4yOC4wCgo=
