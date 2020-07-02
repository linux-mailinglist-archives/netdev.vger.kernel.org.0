Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38E1F21245C
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 15:14:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729156AbgGBNOv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 09:14:51 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:36606 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728253AbgGBNOu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 09:14:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1593695690; x=1625231690;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=D1k8sFFZ6GmcfeJLDNK60SJWjTqLYfivUhKi8BmT+4Q=;
  b=VnZBwPMsnfhzjBUVX+8TXxlYx0uOSIGOc6ybaUVoKftKrr9clF7ggXVR
   /f8VY+nPGdpECzLHuH0SByjNQwgMjb0LZUlYdfb0mXDnBP3/C8cs2PuOm
   iq5/ZQYJm2BH4Zf0hAVdt/tYKiodojsJ+CqxDpOv06B/IUwZLIjVvbtQ8
   OaauNHyPA7rf5whUeLDgqzluPt+ncA6gM3MEvpJG+1xDG7+z/cxJrats9
   ylaZU1Ri6mbnMPuBHVj/Hd0TW3dXecl1B/B3aIhQ9rR2Ts2kVFMdCl7Mr
   91W+B/W1jfL8R9v2iKPGS3pChCpQnua3NrVzWAAhdlrbU28ohRr0UV41m
   g==;
IronPort-SDR: anH1E/wTBctIj2IeitnYX1B7+GUthXLHYh4atVCV5HvB85NTqhA+y2Rf54fL7ARIk6fwnqk0Q9
 bOG1Rajs8+zHuRR9l+Umdny2YNsLcpOMvGDcMDperyJki06gbY+jzIo4vHMgF+PeF2tKFZWtGQ
 l9D0H3V+96x8RBW07x1hauV7cCWhuqmdKB1/f+9u2kDbeT1MycZMFsRjLYl7SUaPriEdnY5zpg
 C88LU72B3spxt7ht9KyFeRhtZNWI5+b15IV+Kh6sNLzdInDW7yeU2f9ipRGGXafueDWrJNd2gK
 Qtw=
X-IronPort-AV: E=Sophos;i="5.75,304,1589266800"; 
   d="scan'208";a="82392420"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Jul 2020 06:14:35 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 2 Jul 2020 06:14:35 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3 via Frontend
 Transport; Thu, 2 Jul 2020 06:14:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZK9Rx5e3SPAhy1OhigwIGzNMGjTckXC51hnYQHEYY/E/XXnLKzhZYb5z39Wt0rsLCEnXIYpUSNQiVx1tpiFhvKBcor1vbDuAAXk6YWBggxY5qB2aDORnXcpEZk4hX/vbzo6dFNMAlkUwP1oyAybSHYnMuXnXUr+V+njc7W8+y/uAYxftBk1ReJ6VxRxx8VwRJVmt6VB3Z0OuMA39LV4JT/lIV5gCikBGCrMCEgxu5heEK6NzSAAJTDFVNmXs+E2O1eHPavjaHWtJSINF1xUwnzF7FTViDh0mHZQTd8k9bTQ0dCV8YhBsvfjL0vVt66iy+2Os6SoZx0+L//073zkHkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D1k8sFFZ6GmcfeJLDNK60SJWjTqLYfivUhKi8BmT+4Q=;
 b=L4KUD3/4xYsjCCIsMhQdN7a8DO+jTmPWEM1GlYUKyeBpSb2N0k97WHNy1OUXhrXpGLKZYMoEy47sNRb3Bzzg/zzB0UkMUd4KCXcFPPJMmgzWamxL3UhzGBfds2oNc0SUGaSYle9KgDGlW0x0NmtIbEMQEtCeZ3BpXwINwylOq8EBczNx5I+stAFp2+jbrdE2fjnMFC+aguRgKvEjG5X9G/atZsrxrZHxoxmpYCl86HbLOhzOq/wzirJItsEc5vE3LYnkImEXCOhZUlDJWkLdxaE/sGrGcgwtWCcMblSZwVzsZXM7dyLcz+wl99vfK/BetH1nH3oauAcWedXSGG9tPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D1k8sFFZ6GmcfeJLDNK60SJWjTqLYfivUhKi8BmT+4Q=;
 b=LIyeb9oWayKqIbbSdVWZU3gKCVo43v6uJ2bAlJbJQzZQsZZuMRCuFmkVCORsMsayOs+Tn/sd7LHI18VW07V/8jbtkZQVvS46gNTjWpSenlOUwI3VJRy1WtWkoBVCPl08bNj+Lbk1t9Nl13jWPYtNdv58oVBk7bIag2niOyQev1k=
Received: from SN6PR11MB3504.namprd11.prod.outlook.com (2603:10b6:805:d0::17)
 by SN6PR11MB2559.namprd11.prod.outlook.com (2603:10b6:805:57::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.20; Thu, 2 Jul
 2020 13:14:33 +0000
Received: from SN6PR11MB3504.namprd11.prod.outlook.com
 ([fe80::851c:67fc:a034:9ea0]) by SN6PR11MB3504.namprd11.prod.outlook.com
 ([fe80::851c:67fc:a034:9ea0%4]) with mapi id 15.20.3153.022; Thu, 2 Jul 2020
 13:14:33 +0000
From:   <Codrin.Ciubotariu@microchip.com>
To:     <linux@armlinux.org.uk>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <Woojung.Huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <davem@davemloft.net>, <kuba@kernel.org>
Subject: Re: [PATCH net-next] net: dsa: microchip: split adjust_link() in
 phylink_mac_link_{up|down}()
Thread-Topic: [PATCH net-next] net: dsa: microchip: split adjust_link() in
 phylink_mac_link_{up|down}()
Thread-Index: AQHWUFbgcw92ywXyck2F/RA2JBTrQqj0E/4AgAAwxYA=
Date:   Thu, 2 Jul 2020 13:14:33 +0000
Message-ID: <35da0b9a-e0aa-7459-a6a5-4aa3904f54cc@microchip.com>
References: <20200702095439.1355119-1-codrin.ciubotariu@microchip.com>
 <20200702101958.GN1551@shell.armlinux.org.uk>
In-Reply-To: <20200702101958.GN1551@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none
 header.from=microchip.com;
x-originating-ip: [84.232.220.208]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 97ced4c0-0455-4f25-efa5-08d81e89dcc5
x-ms-traffictypediagnostic: SN6PR11MB2559:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB255940415B32D6D752114DC5E76D0@SN6PR11MB2559.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0452022BE1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CxTEzegxaC0UJTU7PTfIfrQ2R8NASISybti5GctpeIxZdx89MqfE1O/e4t7qkwxMK54scREMHA+xJAjm/zl8508sYUlbPM35klwbS3ZQp8j2O6M+hnHO3xO8HAWsUPhJDPseMgz3QjzOqo6CU3pGePDgDL20L1TfF+AVq6i7TNDmassFsYz2PLMo+/6wwSDJ6uHtjnYb9TToMHlhBofJ1BWmuoZfiSn8FPVOO8XYI6/hfGM7ht0RxGMQstpiWSOGMcFejcybDSAyGbF29WDobC4nBwISVl7Avd2B7717+CyeQ/CIEQciTvSIq96LlsvMrPOZ1Zhkx3QfDP9Fad2F0NghtjYxPqTgbeEeEN8rbVD2B8kYP708QpjkaDLK/h9Rb5EkN/X306rdVjV0FjrK+Y3g4aIcyPtFWKLXErqu2C+veS4iyHTToeD4+ygFem8VCQsqilqgGU930eaK/x7OUA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3504.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(366004)(376002)(136003)(346002)(39860400002)(6512007)(2616005)(54906003)(316002)(76116006)(186003)(6916009)(26005)(71200400001)(6486002)(5660300002)(8676002)(86362001)(91956017)(478600001)(4326008)(8936002)(83380400001)(66946007)(31696002)(31686004)(66446008)(53546011)(66476007)(64756008)(66556008)(966005)(6506007)(2906002)(36756003)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: GJjj7I2mvLkjU7pz2A8E15Q6SakavtQlwgnA5GG91nYzzpHMAlyv3txIqIsGemTfMGJcKF/83YbKtWkjjUg6kyYANxKp2CpxuohWPRbBID/MD/c0917u/gPIf5G5+1a+fvLTQvAK1iAgmtQTy8Fvd1TQBa4FZCMwZef7+m3eA1GUwMsEY6yPumxzRoEz4uAdTSA35c26Vbk2akyk8L2L27KsC/v63ajDukqJAsCCL2RB8yDVaCsCnZrbX1wRBeLAkNRKIBBZHlNTkD0tBtG3v279ZB4WQUL5nlLKLrSP5oB6e7MN896xjv5pHNq4T79V1KLBPT0xq4TtPrSfv2tmpOejH54kQEt1NT45xrYgYMcCpM7vkUtM1kPyfhSSkfw7ambCoRDqo3ZWXgfcOY6hTh1MAK2DRmeP5nVbR6ALKB0G5IvTbd+jtacGRKSQxELnA7JT289B9iWYTxAIEbAXqFp5S7A0oh6fhsdzYhRgGT+OrJczm1gvQcreev+lGdEl
Content-Type: text/plain; charset="utf-8"
Content-ID: <BE730A2AF821F348848CDBDD7AD57770@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3504.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97ced4c0-0455-4f25-efa5-08d81e89dcc5
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jul 2020 13:14:33.4908
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tI6SeGL9+Kz4kRpi7lNxNoJyoKPTQ6aopOI0o2uXEQRIS4Z55YwU6zxpza9QDtz+D4tGeYxVUGnlw2gHA1I+9F/if9CpN4DGy7qYqDWNwPs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2559
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMDIuMDcuMjAyMCAxMzoxOSwgUnVzc2VsbCBLaW5nIC0gQVJNIExpbnV4IGFkbWluIHdyb3Rl
Og0KPiBFWFRFUk5BTCBFTUFJTDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVu
dHMgdW5sZXNzIHlvdSBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUNCj4gDQo+IE9uIFRodSwgSnVs
IDAyLCAyMDIwIGF0IDEyOjU0OjM5UE0gKzAzMDAsIENvZHJpbiBDaXVib3Rhcml1IHdyb3RlOg0K
Pj4gVGhlIERTQSBzdWJzeXN0ZW0gbW92ZWQgdG8gcGh5bGluayBhbmQgYWRqdXN0X2xpbmsoKSBi
ZWNhbWUgZGVwcmVjYXRlZCBpbg0KPj4gdGhlIHByb2Nlc3MuIFRoaXMgcGF0Y2ggcmVtb3ZlcyBh
ZGp1c3RfbGluayBmcm9tIHRoZSBLU1ogRFNBIHN3aXRjaGVzIGFuZA0KPj4gYWRkcyBwaHlsaW5r
X21hY19saW5rX3VwKCkgYW5kIHBoeWxpbmtfbWFjX2xpbmtfZG93bigpLg0KPj4NCj4+IFNpZ25l
ZC1vZmYtYnk6IENvZHJpbiBDaXVib3Rhcml1IDxjb2RyaW4uY2l1Ym90YXJpdUBtaWNyb2NoaXAu
Y29tPg0KPiANCj4gRm9yIHRoZSBjb2RlIF90cmFuc2Zvcm1hdGlvbl8gdGhhdCB0aGUgcGF0Y2gg
ZG9lczoNCj4gDQo+IFJldmlld2VkLWJ5OiBSdXNzZWxsIEtpbmcgPHJtaytrZXJuZWxAYXJtbGlu
dXgub3JnLnVrPg0KPiANCj4gYXMgaXQgaXMgZXF1aXZhbGVudC4gIEhvd2V2ZXIsIGZvciBhIGRl
ZXBlciByZXZpZXcgb2Ygd2hhdCBpcyBnb2luZw0KPiBvbiBoZXJlLCBJJ3ZlIGEgcXVlc3Rpb246
DQo+IA0KPiAkIGdyZXAgbGl2ZV9wb3J0cyAqDQo+IGtzejg3OTUuYzogICAgICAgICBkZXYtPmxp
dmVfcG9ydHMgPSBkZXYtPmhvc3RfbWFzazsNCj4ga3N6ODc5NS5jOiAgICAgICAgICAgICAgICAg
ZGV2LT5saXZlX3BvcnRzIHw9IEJJVChwb3J0KTsNCj4ga3N6X2NvbW1vbi5oOiAgICAgIHUxNiBs
aXZlX3BvcnRzOw0KPiBrc3pfY29tbW9uLmM6ICAgICAgICAgICAgICBkZXYtPmxpdmVfcG9ydHMg
Jj0gfigxIDw8IHBvcnQpOw0KPiBrc3pfY29tbW9uLmM6ICAgICAgICAgICAgICBkZXYtPmxpdmVf
cG9ydHMgfD0gKDEgPDwgcG9ydCkgJiBkZXYtPm9uX3BvcnRzOw0KPiBrc3pfY29tbW9uLmM6ICAg
ICAgZGV2LT5saXZlX3BvcnRzICY9IH4oMSA8PCBwb3J0KTsNCj4ga3N6OTQ3Ny5jOiAgICAgICAg
IGRldi0+bGl2ZV9wb3J0cyA9IGRldi0+aG9zdF9tYXNrOw0KPiBrc3o5NDc3LmM6ICAgICAgICAg
ICAgICAgICBkZXYtPmxpdmVfcG9ydHMgfD0gKDEgPDwgcG9ydCk7DQo+IA0KPiBUaGVzZSBhcmUg
dGhlIG9ubHkgcmVmZXJlbmNlcyB0byBkZXYtPmxpdmVfcG9ydHMsIHNvIHRoZSBwdXJwb3NlIG9m
DQo+IGRldi0+bGl2ZV9wb3J0cyBzZWVtcyB1bmNsZWFyOyBpdCBzZWVtcyBpdCBpcyBvbmx5IHVw
ZGF0ZWQgYnV0IG5ldmVyDQo+IHJlYWQuICBDYW4gaXQgYmUgcmVtb3ZlZCwgYWxvbmcgd2l0aCB0
aGUgbG9ja2luZyBpbiB5b3VyIG5ldyBmdW5jdGlvbnM/DQoNClN1cmUsIEknbGwgbWFrZSBhIHBh
dGNoIHRvIGNsZWFuIHRoaW5ncyB1cC4gSSB3aWxsIHJlc2VuZCB0aGlzIHBhdGNoIGluIA0KYSBz
ZXJpZXMgdG8gbWFyayB0aGUgZGVwZW5kZW5jeS4NCg0KVGhhbmtzIGFuZCBiZXN0IHJlZ2FyZHMs
DQpDb2RyaW4NCg0KPiANCj4gVGhhbmtzLg0KPiANCj4gLS0NCj4gUk1LJ3MgUGF0Y2ggc3lzdGVt
OiBodHRwczovL3d3dy5hcm1saW51eC5vcmcudWsvZGV2ZWxvcGVyL3BhdGNoZXMvDQo+IEZUVFAg
aXMgaGVyZSEgNDBNYnBzIGRvd24gMTBNYnBzIHVwLiBEZWNlbnQgY29ubmVjdGl2aXR5IGF0IGxh
c3QhDQo+IA0KDQo=
