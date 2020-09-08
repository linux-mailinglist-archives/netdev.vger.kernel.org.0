Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7EBA26106F
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 13:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729719AbgIHLGc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 07:06:32 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:6786 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729622AbgIHLGF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 07:06:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1599563164; x=1631099164;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Z2LtoIveOxeBFkcaR6hm2VkPlfDoX0tBmp4QNgHK/F0=;
  b=sepTrFnrydQslWkMHjmxhPL/uOQGswv/cWCBwWVwJTPnynf3M/t4EzRh
   xMmeue4UEgsGdUCy5sBr3BU46sl9vyKzf6eSNCWXaJRsaYcnmcsi91UeX
   1GrkKp9VpZZxC50GVNyVlOOEZQOgKZi1tU4R5UQuwwSxVxY6TZp9CCPH4
   fLeGBpmE47D2zyRBDy/nF9syLU2J2fkh46IBwERUUNuXLw+Eljmyg8O9x
   vIG+OEOCygg27717BV5sz+f6AXZaTnvCvw6Chj4SUath8iFQGw/iNFycE
   Vzz9jNMoReBjac1wmLhHHN1gMSOBMmQIEP6MBUZrU3wcWDxHEc7IL4etz
   w==;
IronPort-SDR: X4lfML/R8ZnlQ0b7mFX0Oix3PQDxcPMTXDM5bI3U0gM2rcHKR0wjydiVFrCx8IFOZKo4YnIdnj
 MaRov3wCCe87jiOd3nbnrg9dV0XUzw0xL4CcMrX2PzRyXEAxEdB2HQZIuT/kCl48IO5v6dN+Tv
 eXyjlR3bRcGbCRtE5vR/oPmSuZaiy4UeHqmGUdXZx4hROtnnMh7vFjmzndYgFkKVEP7ef7m28X
 shcx0Rh2gZjNC4tQO7g93qi/Xn1uzxPg4jyWIRtkquJ99L7DdwBfVtdGZt0AHhzU7FJYYhf/5H
 23w=
X-IronPort-AV: E=Sophos;i="5.76,405,1592895600"; 
   d="scan'208";a="86162390"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Sep 2020 04:04:45 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 8 Sep 2020 04:04:13 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3
 via Frontend Transport; Tue, 8 Sep 2020 04:04:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ejF96HT1QiBph2R5wLzyYASuowxanjzjkVlOtZF/hcKkqsoC5HnAELTdR9GVTHzKDDKJbXNbHIrkPXA5tPcjfTvm7d60v5Oc1PZxrQ8yjthRCQILu3pMIzkniUwkmsTHtePpyAZtu5QupFXx3rtmY1CYSLqb8FvbYjcBmPtx3OxrCD2yPmAKuupw6BIm083ZqbsFqemfCBRoavEjndg3zWyR8UvguR32xDhc5xedrXihMrwQTVnLRFy1vOze2Fa7HmFxfeAXw4bhtil0PB/6vw13cq3wjwM+/U2/Mdu5XS3Xm4hQCZmUY4dRi8NHlAqpeYd3XhmpU6hkojoFySc5kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z2LtoIveOxeBFkcaR6hm2VkPlfDoX0tBmp4QNgHK/F0=;
 b=jztm7Y8jgIvQ/iSMm7rsgOf3Ruzw1c2aj+9kfVOLlzzQssACN5rVI+xqwRE6xCFgxW085F9CXztDejVTI7ZdswcrMo7EXggmkuRRNkPGz6q5fZkYAuUBVAJ+gYdICGu+1aP5qvcIeVi380EZ0DiQrw+ZCwV3kd9ra3ZhFPGTdnVlIHZu5p7JyPV2bQGTZkmt7M6RQmMfayw4tF+DUPzwCLsJZ0Qt2XyCMuHaOSYkL9VkfYWHIRNVbWn9bEweoQ/nnDcUJlCrjvsx3KeCJCzm2N2o5gpzfslMe5BVX7TM+8UNaZc8LFYAsqm3/9/MCp9t3pmnC8N6sRugSHuxAOJKAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z2LtoIveOxeBFkcaR6hm2VkPlfDoX0tBmp4QNgHK/F0=;
 b=jqoxBrNFmFWkRcMGXz7BCP67fU9eSjOkyMmP4eWYpBbqq3ModJ5v7TXbK3m7LWeGGEg5DfrzMhsywNlnyuZuY4gikWmydlzGh5HtKQb0KXCt8uH7jR6lMjVr8gIq3UajgB+ZwKml15Cfs8boikhnlmcVPSCgUdNAJFLpaQsR1mM=
Received: from BY5PR11MB3928.namprd11.prod.outlook.com (2603:10b6:a03:188::30)
 by BYAPR11MB3542.namprd11.prod.outlook.com (2603:10b6:a03:b2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15; Tue, 8 Sep
 2020 11:04:41 +0000
Received: from BY5PR11MB3928.namprd11.prod.outlook.com
 ([fe80::796a:5504:f0bc:eb33]) by BY5PR11MB3928.namprd11.prod.outlook.com
 ([fe80::796a:5504:f0bc:eb33%2]) with mapi id 15.20.3348.019; Tue, 8 Sep 2020
 11:04:40 +0000
From:   <Henrik.Bjoernlund@microchip.com>
To:     <nikolay@nvidia.com>, <stephen@networkplumber.org>,
        <Horatiu.Vultur@microchip.com>
CC:     <bridge@lists.linux-foundation.org>, <davem@davemloft.net>,
        <linux-kernel@vger.kernel.org>, <jiri@mellanox.com>,
        <netdev@vger.kernel.org>, <roopa@nvidia.com>,
        <idosch@mellanox.com>, <kuba@kernel.org>,
        <UNGLinuxDriver@microchip.com>
Subject: RE: [PATCH RFC 0/7] net: bridge: cfm: Add support for Connectivity
 Fault Management(CFM)
Thread-Topic: [PATCH RFC 0/7] net: bridge: cfm: Add support for Connectivity
 Fault Management(CFM)
Thread-Index: AQHWgpxpY9d7D3s7akCpMSS0Sx8Ya6lZFJEAgALbSoCAAUg/AIABYPTA
Date:   Tue, 8 Sep 2020 11:04:40 +0000
Message-ID: <BY5PR11MB3928DF9AC75B8AEC2FBD2256ED290@BY5PR11MB3928.namprd11.prod.outlook.com>
References: <20200904091527.669109-1-henrik.bjoernlund@microchip.com>
         <20200904154406.4fe55b9d@hermes.lan>
         <20200906182129.274fimjyo7l52puj@soft-dev3.localdomain>
 <b36a32dbf3b4b315fc4cbfdf06084b75a7c58729.camel@nvidia.com>
In-Reply-To: <b36a32dbf3b4b315fc4cbfdf06084b75a7c58729.camel@nvidia.com>
Accept-Language: da-DK, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [82.163.121.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3b99a6ed-3e0a-467d-b5ce-08d853e6fc0b
x-ms-traffictypediagnostic: BYAPR11MB3542:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB354210D32B30D88279705399ED290@BYAPR11MB3542.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pWuXOlKFbxkZKyGajPUDaZ3KACJ+Ybr6qVkGXo1bWWIrXG10kzC8L3JUGuj0DU3lnWNMoG+9suzRKB9mFWgR/k0lK6SrstWZHK89LyDUkXusoqeaY422mOCCZix4kD2g84umA4Oqx9Ki5WdtZHslxCRAAJU74bmt8/E9rUINNrNTfdeJesJXab8Up4aL69fgkGZqAd1nN8JUu3iAqacp9qx+Ts6KJ+s8Ky1FuXEwoL7IpozwuL7+OM+5zLpev2kcWuGaXNh8Gl8pkbEGotJm9tGdxjp6ADnSj6rzaB8hXyRl0MJ7GY9FPGihFkjdJsZcpUtM0Rj74a4egwyxDu9KqtAwtzjmj7Sjnocjh7hLdkfHUdnOHT90jdZBMMYG8cRtj27JIaycvI+gj6+YQJ52fw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB3928.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(346002)(376002)(366004)(396003)(7696005)(76116006)(9686003)(55016002)(8676002)(966005)(110136005)(107886003)(8936002)(33656002)(478600001)(7416002)(6636002)(66476007)(66556008)(66446008)(186003)(26005)(64756008)(66946007)(2906002)(52536014)(4326008)(71200400001)(54906003)(53546011)(6506007)(86362001)(316002)(83380400001)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: TMZZYP8hjkppApZO/c1B06+hsO3UXyVLBtP9EWL+UB01DYiWA58tuG1EGPHiLjKGoauFpBm9oBHUh+vbhXmvf+wQU6TKtA2pSAWQ4SlSdf6HneC75CcJ/QcPHsuNZrUBnj1bt/fNhEX+89cUu9zWD8KeH87P486xRd/j3HLxypsqwCUCl3DP3btQO2GEzXdm1X5ybNMHaSEDliWTOb06Mud2JLgjCwEW0/5N6+5HaMxGk8GPjGwMyfSfXc1DUyOEbJEm/qdMg0Roi7gFRrhk5KtldA7rz4PqnT1QXe0u77+Of/plvNgpxIcXLtH99XywWa7OGa76uyqzJ4k7dfXDqwivizW4IJvJ4fBgF4V+vLBan2bcetMtl5k42oppnEegQeNUDcaNN4ol/bB8/bFdHUZjY9W3UBEJ/jLhHKEA/ZbrhpuvL7QDNmj0RJDpRf6IPVrhCjnB7l/iCxWNGjazviw8J74MjAto+7DVVbh1vWe+vlhWwx30QfYEsHIVP8Wow+ZpvQNo6CdyuosVQjuhnTXhSyLpBrGphNYveMgV8IZNvpzXUf4W6WF6pqA52eijXcp1kjcN8nOp+MADxdd8sHYU0BsVgsF5ThW+e9Ffpur9bd28QtE/GdeiUE9ckatGtFUYcgRStVWUfZ7driFy1g==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB3928.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b99a6ed-3e0a-467d-b5ce-08d853e6fc0b
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Sep 2020 11:04:40.8045
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jGiOyCGg6z1k+cV1ZO2OmggoYTC5ZAWlKti+SiyFDmLeZwQwxmlb5uVD/5/JhvDYwnvYp7vh+z0d9xcEhcbyYrFp8avI8HJF3hpnJfpuVyw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3542
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgTmlrLA0KDQpUaGFua3MgYSBsb3QgZm9yIHJldmlld2luZy4NCg0KLS0tLS1PcmlnaW5hbCBN
ZXNzYWdlLS0tLS0NCkZyb206IE5pa29sYXkgQWxla3NhbmRyb3YgPG5pa29sYXlAbnZpZGlhLmNv
bT4gDQpTZW50OiA3LiBzZXB0ZW1iZXIgMjAyMCAxNTo1Ng0KVG86IHN0ZXBoZW5AbmV0d29ya3Bs
dW1iZXIub3JnOyBIb3JhdGl1IFZ1bHR1ciAtIE0zMTgzNiA8SG9yYXRpdS5WdWx0dXJAbWljcm9j
aGlwLmNvbT4NCkNjOiBicmlkZ2VAbGlzdHMubGludXgtZm91bmRhdGlvbi5vcmc7IEhlbnJpayBC
am9lcm5sdW5kIC0gTTMxNjc5IDxIZW5yaWsuQmpvZXJubHVuZEBtaWNyb2NoaXAuY29tPjsgZGF2
ZW1AZGF2ZW1sb2Z0Lm5ldDsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgamlyaUBtZWxs
YW5veC5jb207IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IFJvb3BhIFByYWJodSA8cm9vcGFAbnZp
ZGlhLmNvbT47IGlkb3NjaEBtZWxsYW5veC5jb207IGt1YmFAa2VybmVsLm9yZzsgVU5HTGludXhE
cml2ZXIgPFVOR0xpbnV4RHJpdmVyQG1pY3JvY2hpcC5jb20+DQpTdWJqZWN0OiBSZTogW1BBVENI
IFJGQyAwLzddIG5ldDogYnJpZGdlOiBjZm06IEFkZCBzdXBwb3J0IGZvciBDb25uZWN0aXZpdHkg
RmF1bHQgTWFuYWdlbWVudChDRk0pDQoNCkVYVEVSTkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlu
a3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91IGtub3cgdGhlIGNvbnRlbnQgaXMgc2Fm
ZQ0KDQo+T24gU3VuLCAyMDIwLTA5LTA2IGF0IDIwOjIxICswMjAwLCBIb3JhdGl1IFZ1bHR1ciB3
cm90ZToNCj4+IFRoZSAwOS8wNC8yMDIwIDE1OjQ0LCBTdGVwaGVuIEhlbW1pbmdlciB3cm90ZToN
Cj4+ID4gT24gRnJpLCA0IFNlcCAyMDIwIDA5OjE1OjIwICswMDAwDQo+PiA+IEhlbnJpayBCam9l
cm5sdW5kIDxoZW5yaWsuYmpvZXJubHVuZEBtaWNyb2NoaXAuY29tPiB3cm90ZToNCj4+ID4NCj4+
ID4gPiBDb25uZWN0aXZpdHkgRmF1bHQgTWFuYWdlbWVudCAoQ0ZNKSBpcyBkZWZpbmVkIGluIDgw
Mi4xUSBzZWN0aW9uIDEyLjE0Lg0KPj4gPiA+DQo+PiA+ID4NCj5bc25pcF0NCj4+ID4gPiBDdXJy
ZW50bHkgdGhpcyAnY2ZtJyBhbmQgJ2NmbV9zZXJ2ZXInIHByb2dyYW1zIGFyZSBzdGFuZGFsb25l
IA0KPj4gPiA+IHBsYWNlZCBpbiBhIGNmbSByZXBvc2l0b3J5IGh0dHBzOi8vZ2l0aHViLmNvbS9t
aWNyb2NoaXAtdW5nL2NmbSANCj4+ID4gPiBidXQgaXQgaXMgY29uc2lkZXJlZCB0byBpbnRlZ3Jh
dGUgdGhpcyBpbnRvICdpcHJvdXRlMicuDQo+PiA+ID4NCj4+ID4gPiBSZXZpZXdlZC1ieTogSG9y
YXRpdSBWdWx0dXIgIDxob3JhdGl1LnZ1bHR1ckBtaWNyb2NoaXAuY29tPg0KPj4gPiA+IFNpZ25l
ZC1vZmYtYnk6IEhlbnJpayBCam9lcm5sdW5kICANCj4+ID4gPiA8aGVucmlrLmJqb2Vybmx1bmRA
bWljcm9jaGlwLmNvbT4NCj4+DQo+PiBIaSBTdGVwaGVuLA0KPj4NCj4+ID4gQ291bGQgdGhpcyBi
ZSBkb25lIGluIHVzZXJzcGFjZT8gSXQgaXMgYSBjb250cm9sIHBsYW5lIHByb3RvY29sLg0KPj4g
PiBDb3VsZCBpdCBiZSBkb25lIGJ5IHVzaW5nIGVCUEY/DQo+Pg0KPj4gSSBtaWdodCBiZSBhYmxl
IHRvIGFuc3dlciB0aGlzLiBXZSBoYXZlIG5vdCBjb25zaWRlcmVkIHRoaXMgYXBwcm9hY2ggDQo+
PiBvZiB1c2luZyBlQlBGLiBCZWNhdXNlIHdlIHdhbnQgYWN0dWFsbHkgdG8gcHVzaCB0aGlzIGlu
IEhXIGV4dGVuZGluZyANCj4+IHN3aXRjaGRldiBBUEkuIEkga25vdyB0aGF0IHRoaXMgc2VyaWVz
IGRvZXNuJ3QgY292ZXIgdGhlIHN3aXRjaGRldiANCj4+IHBhcnQgYnV0IHdlIHBvc3RlZCBsaWtl
IHRoaXMgYmVjYXVzZSB3ZSB3YW50ZWQgdG8gZ2V0IHNvbWUgZmVlZGJhY2sgDQo+PiBmcm9tIGNv
bW11bml0eS4gV2UgaGFkIGEgc2ltaWxhciBhcHByb2FjaCBmb3IgTVJQLCB3aGVyZSB3ZSBleHRl
bmRlZCANCj4+IHRoZSBicmlkZ2UgYW5kIHN3aXRjaGRldiBBUEksIHNvIHdlIHRvdWdodCB0aGF0
IGlzIHRoZSB3YXkgdG8gZ28gZm9yd2FyZC4NCj4+DQo+PiBSZWdhcmRpbmcgZUJQRiwgSSBjYW4n
dCBzYXkgdGhhdCBpdCB3b3VsZCB3b3JrIG9yIG5vdCBiZWNhdXNlIEkgbGFjayANCj4+IGtub3ds
ZWRnZSBpbiB0aGlzLg0KPj4NCj4+ID4gQWRkaW5nIG1vcmUgY29kZSBpbiBicmlkZ2UgaW1wYWN0
cyBhIGxhcmdlIG51bWJlciBvZiB1c2VycyBvZiBMaW51eCBkaXN0cm9zLg0KPj4gPiBJdCBjcmVh
dGVzIGJsb2F0IGFuZCBwb3RlbnRpYWwgc2VjdXJpdHkgdnVsbmVyYWJpbGl0aWVzLg0KPg0KPkhp
LA0KPkkgYWxzbyBoYWQgdGhlIHNhbWUgaW5pdGlhbCB0aG91Z2h0IC0gdGhpcyByZWFsbHkgZG9l
c24ndCBzZWVtIHRvIGFmZmVjdCB0aGUgYnJpZGdlIGluIGFueSB3YXksIGl0J3Mgb25seSBjb2xs
ZWN0aW5nIGFuZCB0cmFuc21pdHRpbmcgaW5mb3JtYXRpb24uIEkgZ2V0IHRoYXQgeW91J2QgbGlr
ZSB0byB1c2UgdGhlIGJyaWRnZSBhcyBhIHBhc3N0aHJvdWdoIGRldmljZSB0byBzd2l0Y2hkZXYg
dG8gcHJvZ3JhbSB5b3VyIGh3LCBjb3VsZCB5b3Ugc2hhcmUgd2hhdCB3b3VsZCBiZSBvZmZsb2Fk
ZWQgbW9yZSBzcGVjaWZpY2FsbHkgPw0KPg0KDQpZZXMuDQoNClRoZSBIVyB3aWxsIG9mZmxvYWQg
dGhlIHBlcmlvZGljIHNlbmRpbmcgb2YgQ0NNIGZyYW1lcywgYW5kIHRoZSByZWNlcHRpb24uDQoN
CklmIENDTSBmcmFtZXMgYXJlIG5vdCByZWNlaXZlZCBhcyBleHBlY3RlZCwgaXQgd2lsbCByYWlz
ZSBhbiBpbnRlcnJ1cHQuDQoNClRoaXMgbWVhbnMgdGhhdCBhbGwgdGhlIGZ1bmN0aW9uYWxpdHkg
cHJvdmlkZWQgaW4gdGhpcyBzZXJpZXMgd2lsbCBiZSBvZmZsb2FkZWQgdG8gSFcuDQoNClRoZSBv
ZmZsb2FkaW5nIGlzIHZlcnkgaW1wb3J0YW50IG9uIG91ciBIVyB3aGVyZSB3ZSBoYXZlIGEgc21h
bGwgQ1BVLCBzZXJ2aW5nIG1hbnkgcG9ydHMsIHdpdGggYSBoaWdoIGZyZXF1ZW5jeSBvZiBDRk0g
ZnJhbWVzLg0KDQpUaGUgSFcgYWxzbyBzdXBwb3J0IExpbmstVHJhY2UgYW5kIExvb3AtYmFjaywg
d2hpY2ggd2UgbWF5IGNvbWUgYmFjayB0byBsYXRlci4NCg0KPkFsbCB5b3UgZG8gLSBzbm9vcGlu
ZyBhbmQgYmxvY2tpbmcgdGhlc2UgcGFja2V0cyBjYW4gZWFzaWx5IGJlIGRvbmUgZnJvbSB1c2Vy
LSBzcGFjZSB3aXRoIHRoZSBoZWxwIG9mIGVidGFibGVzLCBidXQgc2luY2Ugd2UgbmVlZCB0byBo
YXZlIGEgc29mdHdhcmUgaW1wbGVtZW50YXRpb24vZmFsbGJhY2sgb2YgYW55dGhpbmcgYmVpbmcg
b2ZmbG9hZGVkIHZpYSBzd2l0Y2hkZXYgd2UgbWlnaHQgbmVlZCB0aGlzIGFmdGVyIGFsbCwgSSdk
IGp1c3QgcHJlZmVyIHRvIHB1c2ggYXMgbXVjaCBhcyBwb3NzaWJsZSB0byB1c2VyLXNwYWNlLg0K
Pg0KPkkgcGxhbiB0byByZXZpZXcgdGhlIGluZGl2aWR1YWwgcGF0Y2hlcyB0b21vcnJvdy4NCj4N
Cj5UaGFua3MsDQo+IE5paw0K
