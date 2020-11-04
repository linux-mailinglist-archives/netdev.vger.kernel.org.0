Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB8B82A6840
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 16:54:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730903AbgKDPwj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 10:52:39 -0500
Received: from mail-eopbgr750080.outbound.protection.outlook.com ([40.107.75.80]:6126
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730871AbgKDPwf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 10:52:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bUPnn/Sb+BKkya436/dEQknP2hszssHZ5+IMoSgKWsQkZdtjMJgq93GQVzui+IyG6zDir6y2gllB5Ffa1EKV0UqeWR4qyHWt1teNrNgagjy08OgG75x8ibfQHbA7hwHNUfBpYdR4JjdTCpTbCHchomZEOZD+6NJvs6nWCcOi9ID2KVvjQaGsoTLsOa6qYqW3QWoRd3VrRkZqxqkbTI1PPGd6lzZZrglxwpxFkT+L2dnAi+izy5eVVBqMcFK7dSHMJCBc4iht1NjMjRsgZuaUY29djFFCxuSwEu3wmhLmFQdIYARhVCmmohWKK5x7cazEMpth+Mwfqn+a4wYnURu9gA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YekLf7amXYKq9twfWKvoXTRecyL+hvQncbuTAVKuyHg=;
 b=CV5z5i7qS00KalbbdDr6BcF3JXMdj6TlvxWBNcPR4czyecyMDmE0NUUL5Pxg34eEfbWAxYdOtlTbje5s8T0teRmnsMz36wRH9FwP88834fLtZEaGHPRSFskrtZ/HGxBM1uotTwzBPwvtAu+HNTHWQmMUGaIkFc8iSxNMgssFzTGCSccPf1rNEIXZtELy4Rrok1C2CkE3DNVXHh4faLzPuzGAdlTcBbEFrK8fRJOEQ7flXZykKsBn4/G37/S4ED13yEmqvZaXoWAfn/NnoiMbrqK1wgk6RPST6uiFp0Ac3CyzdDZ7MhnFfEC9u1RE2xC5Mn5stBI+QkNBqYFS/9GQMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YekLf7amXYKq9twfWKvoXTRecyL+hvQncbuTAVKuyHg=;
 b=UJxetc53+vxdJTO2mnlWQFfdwmQiImM/NzIwWNilXHpCwcCBEBMh1QT/YlFH9J3BYoHOu6csn9FrFeSHskERO3ckHzYWmJFYZw7AmJmwxhbGMqjwiKvngReU6jggmoxjZxEMjRketHrFKCQd0GgOR6YND38z8eFd15wCtc3hUq8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.32; Wed, 4 Nov
 2020 15:52:26 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::4f5:fbe5:44a7:cb8a]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::4f5:fbe5:44a7:cb8a%5]) with mapi id 15.20.3499.032; Wed, 4 Nov 2020
 15:52:26 +0000
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
Subject: [PATCH v3 02/24] dt-bindings: introduce silabs,wfx.yaml
Date:   Wed,  4 Nov 2020 16:51:45 +0100
Message-Id: <20201104155207.128076-3-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201104155207.128076-1-Jerome.Pouiller@silabs.com>
References: <20201104155207.128076-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Originating-IP: [82.67.86.106]
X-ClientProxiedBy: SN6PR01CA0032.prod.exchangelabs.com (2603:10b6:805:b6::45)
 To SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (82.67.86.106) by SN6PR01CA0032.prod.exchangelabs.com (2603:10b6:805:b6::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.19 via Frontend Transport; Wed, 4 Nov 2020 15:52:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 89e1f47b-a8f3-4942-e701-08d880d9a06c
X-MS-TrafficTypeDiagnostic: SN6PR11MB2718:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB271856AB330ADDAE9953362793EF0@SN6PR11MB2718.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UT27EFOp4QjKziqbHJecGGwQwemfpCvH+r9UZS6qp8z8DEnArUicsRZFksm74peIurrdX6CfkHstG3U4Iigsry4Nc8MGC1ZGx+7J04UFqAlf1g0lmZYn30dIDwOA/hq3FXYos7oNlHeJ9FeuQG7C6Bl4bZzgsBvty8OUeoIFj4lqcgcqJSssiwBLKxPCU2l91UT+Uq2yIt1gpToZj7+R7+/frumUxW3qVBZJUsrOQFb75gOdpTqvwmPz9qzXNrZXsFLo0c/cFP43aDnR/ad8UnKh+M5Eai6ugiswZ8bA9SGa6f4A0MWR47yB1YKCerZv20Rom2WDDzKph3Qmawz9icz45RqQ3bWmu1Z8fB4kNh6zVtMNpUZ7+5SSAZS55o0N55o43SIfKKTV+FPw/lZPog==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(376002)(39850400004)(136003)(396003)(8936002)(966005)(478600001)(186003)(16526019)(956004)(2616005)(6486002)(8676002)(66476007)(66556008)(66946007)(316002)(7696005)(6666004)(26005)(54906003)(107886003)(36756003)(52116002)(7416002)(4326008)(5660300002)(86362001)(1076003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 3KGAH1cqGm1oJJ+S+ZoThEr8QJN4o/UAxZIa7GXx1pRRmC/2tS4AOnYXPMyQz42ftIUwJkEv0sGgdi2q4ljsJuEtY88MSFqgf4JzmOMg1FT9MwXPjYuXfdQd2E8N6cXXrxTTfHGIhrY5o8YLFeB3LfLZhgWkrjy7JTiCDdgk7vy/4eRsci5s3DZAzN/iPg9UoyU/YtD6eRyV8C/l/jfrzki/Dnw/ebTjcIJG0nRGc2/csph5UFq9bXCPoi900S68sNZScreuAIvZgJBLdoT8rJLzJfORRjN2tuksDJO7/aw8oIESoJLw50GO7HtKmjmA6hGF47GEWrdTZvLUp9s0C2ZTku6gNqtP72lMHhimXQpk+5z3ScIvIstIozGvgJJesk5ds5CkqRYmDykwnelpRZtQCDIUrwus6B0JgEGqtYzGbhX8ExTRaLmQ/bXislhEfbcZ7JSFjVJ2FWtVVTNgnqTddrc4uXtidKyW/WVgF80vhhz4gpc2K3ISpMD+94l9jPQNXPJsCAlAVyME1s8GhxPxD8i4NfWWPjQMOWjIFzdMU9is5zBHOKQVbxelZkyB85s1u7n3mbR5rvFm/pt7eeDMokigwS2dpQTmtey0VKAYVSFUyXf71bMzUll67c0+5KAcT1nsR95QqvSqy/2vNg==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89e1f47b-a8f3-4942-e701-08d880d9a06c
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2020 15:52:26.2934
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1Mb09NbqQpHybMDi0QWdVFj3dAJUDEh0GZFU6x373AoehaFvMbYsDnHNDgKW+iru02V3QH7htcqtL5+wOuTe0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2718
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKU2ln
bmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29t
PgotLS0KIC4uLi9iaW5kaW5ncy9uZXQvd2lyZWxlc3Mvc2lsYWJzLHdmeC55YW1sICAgICB8IDEz
MSArKysrKysrKysrKysrKysrKysKIDEgZmlsZSBjaGFuZ2VkLCAxMzEgaW5zZXJ0aW9ucygrKQog
Y3JlYXRlIG1vZGUgMTAwNjQ0IERvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQv
d2lyZWxlc3Mvc2lsYWJzLHdmeC55YW1sCgpkaWZmIC0tZ2l0IGEvRG9jdW1lbnRhdGlvbi9kZXZp
Y2V0cmVlL2JpbmRpbmdzL25ldC93aXJlbGVzcy9zaWxhYnMsd2Z4LnlhbWwgYi9Eb2N1bWVudGF0
aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L3dpcmVsZXNzL3NpbGFicyx3ZngueWFtbApuZXcg
ZmlsZSBtb2RlIDEwMDY0NAppbmRleCAwMDAwMDAwMDAwMDAuLmM5ZmM1ZmY5NWI1OAotLS0gL2Rl
di9udWxsCisrKyBiL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvd2lyZWxl
c3Mvc2lsYWJzLHdmeC55YW1sCkBAIC0wLDAgKzEsMTMxIEBACisjIFNQRFgtTGljZW5zZS1JZGVu
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
KyAgbWFjLWFkZHJlc3M6IHRydWUKKworcmVxdWlyZWQ6CisgIC0gY29tcGF0aWJsZQorICAtIHJl
ZworCitleGFtcGxlczoKKyAgLSB8CisgICAgI2luY2x1ZGUgPGR0LWJpbmRpbmdzL2dwaW8vZ3Bp
by5oPgorICAgICNpbmNsdWRlIDxkdC1iaW5kaW5ncy9pbnRlcnJ1cHQtY29udHJvbGxlci9pcnEu
aD4KKworICAgIHNwaTAgeworICAgICAgICAjYWRkcmVzcy1jZWxscyA9IDwxPjsKKyAgICAgICAg
I3NpemUtY2VsbHMgPSA8MD47CisKKyAgICAgICAgd2lmaUAwIHsKKyAgICAgICAgICAgIGNvbXBh
dGlibGUgPSAic2lsYWJzLHdmMjAwIjsKKyAgICAgICAgICAgIHBpbmN0cmwtbmFtZXMgPSAiZGVm
YXVsdCI7CisgICAgICAgICAgICBwaW5jdHJsLTAgPSA8JndmeF9pcnEgJndmeF9ncGlvcz47Cisg
ICAgICAgICAgICByZWcgPSA8MD47CisgICAgICAgICAgICBpbnRlcnJ1cHRzLWV4dGVuZGVkID0g
PCZncGlvIDE2IElSUV9UWVBFX0VER0VfUklTSU5HPjsKKyAgICAgICAgICAgIHdha2V1cC1ncGlv
cyA9IDwmZ3BpbyAxMiBHUElPX0FDVElWRV9ISUdIPjsKKyAgICAgICAgICAgIHJlc2V0LWdwaW9z
ID0gPCZncGlvIDEzIEdQSU9fQUNUSVZFX0xPVz47CisgICAgICAgICAgICBzcGktbWF4LWZyZXF1
ZW5jeSA9IDw0MjAwMDAwMD47CisgICAgICAgIH07CisgICAgfTsKKworICAtIHwKKyAgICAjaW5j
bHVkZSA8ZHQtYmluZGluZ3MvZ3Bpby9ncGlvLmg+CisgICAgI2luY2x1ZGUgPGR0LWJpbmRpbmdz
L2ludGVycnVwdC1jb250cm9sbGVyL2lycS5oPgorCisgICAgd2Z4X3B3cnNlcTogd2Z4X3B3cnNl
cSB7CisgICAgICAgIGNvbXBhdGlibGUgPSAibW1jLXB3cnNlcS1zaW1wbGUiOworICAgICAgICBw
aW5jdHJsLW5hbWVzID0gImRlZmF1bHQiOworICAgICAgICBwaW5jdHJsLTAgPSA8JndmeF9yZXNl
dD47CisgICAgICAgIHJlc2V0LWdwaW9zID0gPCZncGlvIDEzIEdQSU9fQUNUSVZFX0xPVz47Cisg
ICAgfTsKKworICAgIG1tYzAgeworICAgICAgICBtbWMtcHdyc2VxID0gPCZ3ZnhfcHdyc2VxPjsK
KyAgICAgICAgI2FkZHJlc3MtY2VsbHMgPSA8MT47CisgICAgICAgICNzaXplLWNlbGxzID0gPDA+
OworCisgICAgICAgIHdpZmlAMSB7CisgICAgICAgICAgICBjb21wYXRpYmxlID0gInNpbGFicyx3
ZjIwMCI7CisgICAgICAgICAgICBwaW5jdHJsLW5hbWVzID0gImRlZmF1bHQiOworICAgICAgICAg
ICAgcGluY3RybC0wID0gPCZ3Znhfd2FrZXVwPjsKKyAgICAgICAgICAgIHJlZyA9IDwxPjsKKyAg
ICAgICAgICAgIHdha2V1cC1ncGlvcyA9IDwmZ3BpbyAxMiBHUElPX0FDVElWRV9ISUdIPjsKKyAg
ICAgICAgfTsKKyAgICB9OworLi4uCi0tIAoyLjI4LjAKCg==
