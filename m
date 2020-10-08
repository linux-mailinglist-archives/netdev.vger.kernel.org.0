Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3E3428725B
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 12:18:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729387AbgJHKSL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 06:18:11 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:14859 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729210AbgJHKSL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 06:18:11 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f7ee72a0002>; Thu, 08 Oct 2020 03:17:14 -0700
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 8 Oct
 2020 10:18:10 +0000
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by HQMAIL101.nvidia.com (172.20.187.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Thu, 8 Oct 2020 10:18:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NKg3UlXJBdgX7r02udMRDRshhTjhP08gXgmkrU5s18uBLPupZn7VYt7t87E/Do0v9tmrCJ1x88gBX/B4PJCwbBXrJIe9/tXttcQC1mIcuaDPJWdEmfjuWSubX7ZS6NtjZD7FNdKgT4aHInjwaga86gIDHlfIIYtmJeogqwWg+DLBGk0y9lWXI9CEOawz3RFnk8PCdqyhqZ1SPWkJDzfN7oHEff5hht+Qu9RoHZdsD/BngmYY9nYyCch3kNXBffZcW0ZHF3h8pqZ1IHGBYZmb5szf4ykirPujesfgdY13abRVp4asLKXb0Eo9eTbDCwjo/wfSumgF2Z5P+2F9aThIHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v7QK+x48Nahz9E245zPp0yBfsIPiIH5jtK/dW+p4mzo=;
 b=OWo6LoLlyBr8fkjsvZyI+4leOl2CKbkCBm5WFCHYq9xdprYnRPEV/SRigyTBA+JTpngaGg4jkcTt6LOMc7Er9486PUs8HCsmP8euvbJ092XSh0M+p4GieIkUXmlFgO7ciQdpA0G0Jm7vOgggF0XuFX3BNzjcDIUANXVqDEUOTAlGsA62+sbKSutlofdAe6Ny0yL8bUBmpYSg62vmzkEWIBmEcnSZBFfyuCfrDiDgqH+pctG1sx/npYWrrykZivUcWcHWN0IpmNSyGJRg6PS/jGhWbx5DVmPD7b5Wg0O7irLGGbK7bQ7chiVj+TQZJjzm0d+qZn0K0kHMRSi7RsoQng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM5PR1201MB0010.namprd12.prod.outlook.com (2603:10b6:3:e3::23)
 by DM6PR12MB3004.namprd12.prod.outlook.com (2603:10b6:5:11b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.21; Thu, 8 Oct
 2020 10:18:09 +0000
Received: from DM5PR1201MB0010.namprd12.prod.outlook.com
 ([fe80::4517:3a8d:9dff:3b62]) by DM5PR1201MB0010.namprd12.prod.outlook.com
 ([fe80::4517:3a8d:9dff:3b62%9]) with mapi id 15.20.3455.024; Thu, 8 Oct 2020
 10:18:09 +0000
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
To:     "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        "henrik.bjoernlund@microchip.com" <henrik.bjoernlund@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Roopa Prabhu <roopa@nvidia.com>
CC:     "horatiu.vultur@microchip.com" <horatiu.vultur@microchip.com>
Subject: Re: [PATCH net] bridge: Netlink interface fix.
Thread-Topic: [PATCH net] bridge: Netlink interface fix.
Thread-Index: AQHWnKKpyTxrd+oPIUur9lgPN8/sf6mMOMkAgAFGlAA=
Date:   Thu, 8 Oct 2020 10:18:09 +0000
Message-ID: <585c251204d3c09150e9fcb60f560c599567688a.camel@nvidia.com>
References: <20201007120700.2152699-1-henrik.bjoernlund@microchip.com>
         <32183f25a3d7ee8c148db42fbed9dd2a6e0a1f92.camel@nvidia.com>
In-Reply-To: <32183f25a3d7ee8c148db42fbed9dd2a6e0a1f92.camel@nvidia.com>
Reply-To: Nikolay Aleksandrov <nikolay@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: lists.linux-foundation.org; dkim=none (message not
 signed) header.d=none;lists.linux-foundation.org; dmarc=none action=none
 header.from=nvidia.com;
x-originating-ip: [84.238.136.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ec8a3db8-7b77-4e75-241d-08d86b7374a2
x-ms-traffictypediagnostic: DM6PR12MB3004:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB3004D580F59A01F1B3FE38F0DF0B0@DM6PR12MB3004.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lTC2woOBFmGBtEcJ3gOVnTti5JuH8xwmjfq3bIqH/GTgH+FP7psLzHFlyEMe2gwjGZDgtiX+4zes4Wfq/3gIkBqwhYUmJe1X7KF6ilqvEMB2QHC01546u+Re4MIL0r0MiOHlefBoJERRj+iarMSTmgxf0gfEsnyJ5Us2NrCSRG3Su8j09euJ6BQo4HJFLZ0kO8ZMDyUz2zHOkT9mN1T3mWmC1YQ+yy8VUkvHsyjJ9/IglJdLu0u/qjHAEBKYinNPekSVsu/3HKIdLq6yx2AsTUKuPoaYn0QsAvSZwgz4N5TXb8+fx9NdFdIx7sCxyQ6m7rDg1PtItpD77NBO11PBEg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1201MB0010.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(376002)(136003)(396003)(39860400002)(8676002)(2906002)(8936002)(6506007)(26005)(3450700001)(71200400001)(6636002)(6512007)(36756003)(186003)(5660300002)(86362001)(83380400001)(4326008)(64756008)(66556008)(2616005)(6486002)(66476007)(66946007)(66446008)(110136005)(316002)(91956017)(478600001)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 2u4ZNxeK5sV6WUBhM3NE7eQZ3EZOAPGVTcLMNotgJzej8DTZDxhBiz7v3a76ePPMyswtSBcfE364tN/TlwGN+FiDoIYo6pnCfNRWNANpse4dQuLm5GlRF058Rvk6lo7gN3yPeEVhtLXI4QsCFrz1UvRMZVXAetZOvU06HLvxiQhYPVf4BI64LQoNwQ59ADCG70/HrGVZyDm3R0p9hEA7jXu+3JGWxFcNfNnnv/3vFQQe4eaFlnjvOjYt2RX0c8vddoRLkGWhszJ4QlURYsTWvzL187YQPWyDAwgRvGPPiTy6cEE3O69EV4j1/YOwjCQ80Z0bdwT0tvO7gquycfNMtXuxRLIs0ssbb1kTV7jt1o8bRh9vou6d2of7F49FA6f15d+U4zWb72GvgIb9S2WJS6gBgBFWZfFtwk2oMxRGjxeHs+/4uieFu9iHYYZukaRPwY9oBDuuAjBuIZjbUeCBZU4tpYAEF3xQro1+EnQ0aMPkT9Va1f2U2VuQ14TDu7UC7f30PBi0q6tS4xMjiKsBwdOh0DU10QzliqrjJP9K+4+iPIn9RohKm21XIdIUQHzkmDREDF+Vsspqys70jGMVTouOed4aRi5MRix1vmlSVNpgZSG6wyX82X8P4Y1qQ3bec5IzIREdBgnKiVJpmarM6A==
Content-Type: text/plain; charset="utf-8"
Content-ID: <A6370466707DB64D8F28135E50738949@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1201MB0010.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec8a3db8-7b77-4e75-241d-08d86b7374a2
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2020 10:18:09.3580
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IAY1haTGAlBCA3kG+w0TJQQYhWL5mNfrssxueAu7rHNYFfCIVfcAXhvnQ+rQecKePbz4q07PAlMenfMxyp1cvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3004
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1602152234; bh=v7QK+x48Nahz9E245zPp0yBfsIPiIH5jtK/dW+p4mzo=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
         In-Reply-To:Reply-To:Accept-Language:Content-Language:
         X-MS-Has-Attach:X-MS-TNEF-Correlator:user-agent:
         authentication-results:x-originating-ip:x-ms-publictraffictype:
         x-ms-office365-filtering-correlation-id:x-ms-traffictypediagnostic:
         x-ms-exchange-transport-forked:x-microsoft-antispam-prvs:
         x-ms-oob-tlc-oobclassifiers:x-ms-exchange-senderadcheck:
         x-microsoft-antispam:x-microsoft-antispam-message-info:
         x-forefront-antispam-report:x-ms-exchange-antispam-messagedata:
         Content-Type:Content-ID:Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=A4VKAk8H+SgDUJT0Ag1lSF++LbohS7xZBjsBpalvPjJ6Bg0yUOn+fD8Pm/YvC0sO0
         7UcXsT7SEaf6xN3c/M3sYLJJQwOJEB/wo/ztmBDX2CTG9ouvm4hDzwDsLwuTZZGqWD
         NiodIHLhsCP53+Xw+1V6m1x/IVwrcSpNt0hF7lGAlw0B0u5Eqz/5C+IxpgyungGcfm
         FEpKabBuDCAgnAwsEqFlMm+hfCdzm4UnAcCi88hSfgZYsDIyIA7tA4WlinWdd2MUaQ
         ZqZg55VoEzzouZO2yPxr4i1evw0IzEiiaJChD/UJTMg+46u9k3RyfHJIcqP5G30OR+
         dOEetmiUAIbSg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIwLTEwLTA3IGF0IDE0OjQ5ICswMDAwLCBOaWtvbGF5IEFsZWtzYW5kcm92IHdy
b3RlOg0KPiBPbiBXZWQsIDIwMjAtMTAtMDcgYXQgMTI6MDcgKzAwMDAsIEhlbnJpayBCam9lcm5s
dW5kIHdyb3RlOg0KPiA+IFRoaXMgY29tbWl0IGlzIGNvcnJlY3RpbmcgTkVUTElOSyBicl9maWxs
X2lmaW5mbygpIHRvIGJlIGFibGUgdG8NCj4gPiBoYW5kbGUgJ2ZpbHRlcl9tYXNrJyB3aXRoIG11
bHRpcGxlIGZsYWdzIGFzc2VydGVkLg0KPiA+IA0KPiA+IEZpeGVzOiAzNmE4ZThlMjY1NDIwICgi
YnJpZGdlOiBFeHRlbmQgYnJfZmlsbF9pZmluZm8gdG8gcmV0dXJuIE1QUiBzdGF0dXMiKQ0KPiA+
IA0KPiA+IFNpZ25lZC1vZmYtYnk6IEhlbnJpayBCam9lcm5sdW5kIDxoZW5yaWsuYmpvZXJubHVu
ZEBtaWNyb2NoaXAuY29tPg0KPiA+IFJldmlld2VkLWJ5OiBIb3JhdGl1IFZ1bHR1ciA8aG9yYXRp
dS52dWx0dXJAbWljcm9jaGlwLmNvbT4NCj4gPiBTdWdnZXN0ZWQtYnk6IE5pa29sYXkgQWxla3Nh
bmRyb3YgPG5pa29sYXlAbnZpZGlhLmNvbT4NCj4gPiBUZXN0ZWQtYnk6IEhvcmF0aXUgVnVsdHVy
IDxob3JhdGl1LnZ1bHR1ckBtaWNyb2NoaXAuY29tPg0KPiA+IC0tLQ0KPiA+ICBuZXQvYnJpZGdl
L2JyX25ldGxpbmsuYyB8IDI2ICsrKysrKysrKysrLS0tLS0tLS0tLS0tLS0tDQo+ID4gIDEgZmls
ZSBjaGFuZ2VkLCAxMSBpbnNlcnRpb25zKCspLCAxNSBkZWxldGlvbnMoLSkNCj4gPiANCj4gDQo+
IFRoZSBwYXRjaCBsb29rcyBnb29kLCBwbGVhc2UgZG9uJ3Qgc2VwYXJhdGUgdGhlIEZpeGVzIHRh
ZyBmcm9tIHRoZSBvdGhlcnMuDQo+IEFja2VkLWJ5OiBOaWtvbGF5IEFsZWtzYW5kcm92IDxuaWtv
bGF5QG52aWRpYS5jb20+DQo+IA0KDQpUQkgsIHRoaXMgZG9lcyBjaGFuZ2UgYSB1c2VyIGZhY2lu
ZyBhcGkgKHRoZSBhdHRyaWJ1dGUgbmVzdGluZyksIGJ1dCBJIHRoaW5rDQppbiB0aGlzIGNhc2Ug
aXQncyBhY2NlcHRhYmxlIGR1ZSB0byB0aGUgZm9ybWF0IGJlaW5nIHdyb25nIGFuZCBNUlAgYmVp
bmcgbmV3LCBzbw0KSSBkb3VidCBhbnlvbmUgaXMgeWV0IGR1bXBpbmcgaXQgbWl4ZWQgd2l0aCB2
bGFuIGZpbHRlcl9tYXNrIGFuZCBjaGVja2luZyBmb3INCnR3byBpZGVudGljYWwgYXR0cmlidXRl
cywgaS5lLiBpbiB0aGUgb2xkL2Jyb2tlbiBjYXNlIHBhcnNpbmcgdGhlIGF0dHJpYnV0ZXMNCmlu
dG8gYSB0YWJsZSB3b3VsZCBoaWRlIG9uZSBvZiB0aGVtIGFuZCB5b3UnZCBoYXZlIHRvIHdhbGsg
b3ZlciBhbGwgYXR0cmlidXRlcw0KdG8gY2F0Y2ggdGhhdC4NCg0KDQo=
