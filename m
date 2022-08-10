Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 468D658E907
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 10:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231450AbiHJItG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 04:49:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230476AbiHJItF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 04:49:05 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60085.outbound.protection.outlook.com [40.107.6.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F6AC6C775
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 01:49:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MdGL5dtutvzbzbofsy/bB1qk5KeT6Dscxl6ikAZSl/E7p3ORM6hnfSOZTbiLhTsRYlNVB721f+hGPCtiIROIOvouQ1buJg+QAHg+pDHIeDM2GKM+R6dpITn5gobniDH5R17yGD/o+wUOsuYarb5a4XbAYNCO/VwAwHLfLaD6TkeZ6G1QzsOFJgFIDkP++NEHrykKZyTBAcVJebKFEl+BamOcqb2E1CqKRwwcWwpaDC2ZHkwKCm2ERXFWd1uu+kfIa53c0wDDV+Gf5EgG6sm4qzXtZORuJzUWRSb2UcS1+JgArD+1dHlbKOmZ7vCa36z7fMjUeqy5v9aDBiOEdAgKCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RgwZVCpdORXY6qBbIMhfbX1G2v0OIkxr3Jx+zjLTXi4=;
 b=JzCYKEsEODvnYvL2CEw5uAIhj4Gg1SPndlR3NYRw8FLwsKRr69kmI9ExeTbgclVWLee6uQgcKAdZHVwzmkXiqcZyid9jKymGoUMCnKdpTPKIfRCLQqxl5TZTKlOpoeK+2Uc0iRQkStr9RJ9SlPpuZ9djDA5yNPtCkxk4Ki4Fkop0vicEUBsrPgbEJ0elVyPrsNAAJTAXelmxx6R7gupETnF7VxmAt3hE2j6CNKpQ8+JhGV7WbXK7IngaQ1V7nEc12ef4+Oyhn6Wo1VWuZ7OhHzvDLdFAwcZa1faB9yorbUwPquYtV+X6Asbqa2hACrL0EroEuQLlVCim62fJsC2M0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RgwZVCpdORXY6qBbIMhfbX1G2v0OIkxr3Jx+zjLTXi4=;
 b=PN+iSeM9B0pNmM7lpvSE/kMsx4/8kJ7iLapGx/cWeI4wLuKR7HdHlknJ4zw+7BV3pCAkq9YBnFZU+ePxyVhJHWfEVmIi+E/rF/1/6r8YOeHMtD4xJ2nii9tFay1mIE8SlN+yreMdIDpln8mG3/ivRwloilv7uvz2u9grKmQrYyQ=
Received: from DB9PR04MB8477.eurprd04.prod.outlook.com (2603:10a6:10:2c3::11)
 by AM0PR04MB4083.eurprd04.prod.outlook.com (2603:10a6:208:64::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Wed, 10 Aug
 2022 08:49:01 +0000
Received: from DB9PR04MB8477.eurprd04.prod.outlook.com
 ([fe80::8948:3ca3:ca1:1baa]) by DB9PR04MB8477.eurprd04.prod.outlook.com
 ([fe80::8948:3ca3:ca1:1baa%4]) with mapi id 15.20.5525.010; Wed, 10 Aug 2022
 08:49:01 +0000
From:   Aisheng Dong <aisheng.dong@nxp.com>
To:     Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "embed3d@gmail.com" <embed3d@gmail.com>,
        Viorel Suman <viorel.suman@nxp.com>,
        Frank Li <frank.li@nxp.com>, Clark Wang <xiaoning.wang@nxp.com>
CC:     "philipp.rossak@formulastudent.de" <philipp.rossak@formulastudent.de>,
        "G.N. Zhou" <guoniu.zhou@nxp.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: RE: Question: Ethernet Phy issues on Colibri IMX8X (imx8qxp) - kernel
 5.19
Thread-Topic: Question: Ethernet Phy issues on Colibri IMX8X (imx8qxp) -
 kernel 5.19
Thread-Index: AQHYrI/+0vnMKpTjW0iEfU3dAn0M562n0o1g
Date:   Wed, 10 Aug 2022 08:49:01 +0000
Message-ID: <DB9PR04MB847744EAA39A13635CDBA73180659@DB9PR04MB8477.eurprd04.prod.outlook.com>
References: <90d979b7-7457-34b0-5142-fe288c4206d8@gmail.com>
 <7d541e1dfa1e93abf901f96c60be54b01c78371c.camel@toradex.com>
In-Reply-To: <7d541e1dfa1e93abf901f96c60be54b01c78371c.camel@toradex.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d39a7e69-65dc-4411-a964-08da7aad2c08
x-ms-traffictypediagnostic: AM0PR04MB4083:EE_
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HScccHeppad5RpqXSPePG8lKwcPM0kf39SVtdGdgxZu13KjeJ1+Zw27TL4Dk+Pz7nRS2ibqYViNd77i5Tfyt7Pmu6nkRCz0dzhWzil2Xa/y7175YZUMgl1bhlUlkL9EKQYGok+w3Z+im7Bj5mlEQiJRlRitQZlzAdsWL16o5fdqJFNbtCqcfR++XEDN6Fl8c9Pf15VHTJAHRKXPrLYCdLKnTO9+pQ60bT8PPOeH3LHH/pc8aeBi8R1gIsH6kow7nDPCtckjg6nW3yoRWs6EUM3MSlOy3AoAj+eoskYSOk1yDcFlVUm7zSz+/qPt+irWf2LUYxtl3M3vZnUKeKErDKM5lzrppKtv3cI6XDNxh2DIK576LX0XJJ6H1Eeg7aeJamVd9/nPURKyaCFroN+YRgQKd7Q7lsaP1v1z7ldqdw1cOxQvwpHuJ5VtKMKpPH6liCMNw4xLQbsic0zDyHjy0PlNaI0s6EGcNrLSldJbCsOoyuycR9qj6M+qpO8VTOdMJ04+YW8Bam44P+YaKdq56rlz7wowRb+2VMBTVS0yOTdyyEo1aSL/4A9Z+5ZZQRHIfb1opO6pX2cU/i9S9P0KCzlrHRfEOZjuZR8QMWlB3DtWR4Px0APIY1sq6YUsUeG0Wx+S0CF9VHvZ01Jivyi4/6fGP1u181wfBjdNjafQZDPmaOZJRijEpkSWZL+wWu/n5FgG3/lGe+qE6/Z+McVQOJQ1QigucJ8z0ezkj6QIwxX4xALEruIDpkfr2qd1QfK5ZD9Sb2E3AfSGthdWus9y0PxcoQaE4UsbnGo8PW7TPyq0fV2jF1AtAhzrlRdONoh7dkWeBpXd1leL7UwrxB3kkOxI2TU8/4ef3x6aF34pKCE8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8477.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(376002)(346002)(396003)(366004)(39860400002)(45080400002)(110136005)(54906003)(6636002)(316002)(71200400001)(966005)(8936002)(86362001)(478600001)(38070700005)(5660300002)(52536014)(44832011)(2906002)(122000001)(83380400001)(6506007)(38100700002)(41300700001)(53546011)(7696005)(66946007)(66476007)(76116006)(64756008)(8676002)(66446008)(66556008)(4326008)(55016003)(186003)(9686003)(26005)(33656002)(32563001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?aHowazJkaHlQYzhHQmp3a2ZOWjhQNkFOK0Roak9DYUlnYS9VVjN4ZnByeE90?=
 =?gb2312?B?WTNpVDl3TnFWcjQ4ZVFtTEhjRzlLTjY1emJUTE0rT3F2TEUzRm85THVHSzN5?=
 =?gb2312?B?ZDNxbUlMcGdUTTZYM3VNd3BpMTBBSHhMOTRwcGZ0RWNQaXpGNElRSU5GRG9P?=
 =?gb2312?B?alV1RjB1TDFDcmlBN0NBcUlhMWNndCtBQ1hSWmxISnd2UDJNNlU3SkU1alVj?=
 =?gb2312?B?Q2xjTk42UHdGUDJpTmVvRzU2TXVjakJkcG9SVW44NUJkUTJRZjhzQnBWYWwv?=
 =?gb2312?B?SHFSMUlrbDVoQVI2MlVKL1YveWNNaWdzTmVwSWdLaW9vczdIM3pKRVJJbVJo?=
 =?gb2312?B?T3UxeFB6bTZEU3MyazU1Rm0vU0ZhNU5tYVZzVndsVDNuRDE3VUVBNXZPd2pH?=
 =?gb2312?B?cEZMWk1xSU1tMktLRHgwQlpScUg2OGJtbW9HOFc1UEZralJjWG1POXZLT0lY?=
 =?gb2312?B?bnJLaVIwSjBoMHZKSEVQdVhBeHFtMnlrTGlmNVJtZmFyNExyNU1Gcmp3SUIr?=
 =?gb2312?B?WkcxTXZYNWEvcEh3U254TUpUYnp2L0t6SnRYemFoeEF1dThnMHcxbDhFSGtX?=
 =?gb2312?B?TnNOVXkyUkxKSUI5bkVHSit3dVJ6bXFITVM4bGViMEZKdFdVVjhPSkRFczJz?=
 =?gb2312?B?LzlmNjBPSUlSNS9ndVlEaHpydkhCZU94ZU14QmppL0x1Q2xERG5aOVl3bXpp?=
 =?gb2312?B?ODRCMWJzR1puRXNFb3Q0cGNOM205N3dPY2JCa2V0eFFWNUNLYlM0QTBmMFA1?=
 =?gb2312?B?Nm4zRVYySUpKZXdqVkdXRXlyYjhCYlZGWGUzamRNSDF0Rzk4VVJ1Z291bkov?=
 =?gb2312?B?YVNVdmhYdkZkb2RlQkozWEtiV2RhT0dZNEVXOFlJeEtJZVpRMGRScHhybjBv?=
 =?gb2312?B?SWNvTThnYXVoZnBvTll1anN5NUZ1YndISzdCekhaREFLNld3Z2dwZjRWL3Vj?=
 =?gb2312?B?WWxvYXlUYXZUcWVxcUtNQUJZTHhGa0dVbzlqNTBySXBrK1NhTWtNem5FM05i?=
 =?gb2312?B?dDNucEhzeC9kcHNwYm9oNzdBTHREYmRQZy9SdC9VaFFORzhpWVZxMk9ieTZ1?=
 =?gb2312?B?dlRaYWN6UkdRY294Um9peURpM01DMjVTanlSazlZNVhiZGQrK2J2TFQxTHpt?=
 =?gb2312?B?T3pqVGFhY1d1YlNtMGVkaWxHanBSb1NIYUFPcFF4U2FUNW8xb1dJa3ptTHMz?=
 =?gb2312?B?UCtoVSs3aWU0RU9iWjNHUmdDSmdOVmhLT3o0Q0YzUW0welFBM2lYVmYvUWZN?=
 =?gb2312?B?US9JSjl2dW54dncxZmMwTDZmVERQS05PbVdJRUFialVhRSszSDRQbUJFbXh3?=
 =?gb2312?B?dnByT1IxT0I2RjZWMENUdDZ1MVdxYjBzTkMyRWU2Mi9YWWI0ZXk2M0NmRzU4?=
 =?gb2312?B?dnoya3drbHdxZ0dFdUtlWm1vTFBxd3U4ZnNMYjlIRGNhMXlUbjRYMkJ1Z1lk?=
 =?gb2312?B?QkV4bmJZNHVPbmE1eENVelpXM3liaXM4Y2pSUjMyOVFtYXFNUHZyYkhlalJj?=
 =?gb2312?B?RTRkaURMUHdoZmdkKzFPWU5tcGdhWHVkZFltZ3dqdlB3ZHRIOUR6c2RuRDYv?=
 =?gb2312?B?ZHdzZFd4SkV2NlcxUEMyWTJ6Y28rNXhMUGxqeU16eTZkVUtaaXlTOXBzZzg5?=
 =?gb2312?B?VXBDdlV6SFlMTEtmcEV4Qk9TMEJmQUljUkE2dzhFRHN1Q21BREhqcVhRVXVX?=
 =?gb2312?B?TDBWK2k2b3ZDa3dOb2kyaXFJd25yUVppajNBZUltOWRmdGpIQ2ZoRC9jdnNL?=
 =?gb2312?B?eC9oeUMzeWJKTGNmYjMyVEFtZjR2WnNOOHpta3JXZVNBREY4MWo0cFc4eEVo?=
 =?gb2312?B?OC9ad3VzR2tSbUZzTUN0T28wYjJkM2dGQmNjejE1NW1JQWlYSERCeW8rbTg0?=
 =?gb2312?B?WWV1ODVsN1kvMXV3NVVWYW5Fc2xxazVPY1RwYS9FWDhxYnozdkFRcmtCSFRF?=
 =?gb2312?B?cVJtMi83ZEpHYWs4eTNmYkE0T2dXbUR0SFhjTy9JWTNORk1CNHVrVklDZ1M5?=
 =?gb2312?B?bFFLYVZwN3BzQlJFd1VXUjRzZWZHQWZOZk1KYkQyck1Obk5vYlRlMDlzTEZI?=
 =?gb2312?B?T2hBRmJpcm1KYnlMeXFDWDROSlBuTDFGUXlFN0c4N3RaK0g1Vk9ST1FyTkc4?=
 =?gb2312?Q?pEIqCB8zmn2KgqST+0aIQIfM3?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8477.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d39a7e69-65dc-4411-a964-08da7aad2c08
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Aug 2022 08:49:01.2105
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fZWtWMc/e9uxq3kRyQV8W7JnvYp8kU0Mu1XqrKHI//Z58MhKrcGCtXOFN5Sy+l+Wj35w8Tjn8j7FoRuoRmmocw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4083
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBGcm9tOiBNYXJjZWwgWmlzd2lsZXIgPG1hcmNlbC56aXN3aWxlckB0b3JhZGV4LmNvbT4NCj4g
U2VudDogMjAyMsTqONTCMTDI1SAxNjowNg0KPiBTdWJqZWN0OiBSZTogUXVlc3Rpb246IEV0aGVy
bmV0IFBoeSBpc3N1ZXMgb24gQ29saWJyaSBJTVg4WCAoaW14OHF4cCkgLSBrZXJuZWwNCj4gNS4x
OQ0KPiANCj4gU2FsaSBQaGlsaXBwDQo+IA0KPiBPbiBXZWQsIDIwMjItMDgtMTAgYXQgMDA6NTUg
KzAyMDAsIFBoaWxpcHAgUm9zc2FrIHdyb3RlOg0KPiA+IEhpLA0KPiA+DQo+ID4gSSBjdXJyZW50
bHkgaGF2ZSBhIHByb2plY3Qgd2l0aCBhIFRvcmFkZXggQ29saWJyaSBJTVg4WCBTT00gYm9hcmQN
Cj4gPiB3aGl0aCBhbiBvbmJvYXJkIE1pY3JlbCBLU1o4MDQxTkwgRXRoZXJuZXQgUEhZLg0KPiA+
DQo+ID4gVGhlIGhhcmR3YXJlIGlzIGRlc2NyaWJlZCBpbiB0aGUgZGV2aWN0cmVlIHByb3Blcmx5
IHNvIEkgZXhwZWN0ZWQgdGhhdA0KPiA+IHRoZSBvbmJvYXJkIEV0aGVybmV0IHdpdGggdGhlIHBo
eSBpcyB3b3JraW5nLg0KPiA+DQo+ID4gQ3VycmVudGx5IEknbSBub3QgYWJsZSB0byBnZXQgdGhl
IGxpbmsgdXAuDQo+ID4NCj4gPiBJIGFscmVhZHkgY29tcGFyZWQgaXQgdG8gdGhlIEJTUCBrZXJu
ZWwsIGJ1dCBJIGRpZG4ndCBmb3VuZCBhbnl0aGluZw0KPiA+IGhlbHBmdWwuIFRoZSBCU1Aga2Vy
bmVsIGlzIHdvcmtpbmcuDQo+ID4NCj4gPiBEbyB5b3Uga25vdyBpZiB0aGVyZSBpcyBzb21ldGhp
bmcgaW4gdGhlIGtlcm5lbCBtaXNzaW5nIGFuZCBnb3QgaXQgcnVubmluZz8NCj4gDQo+IFllcywg
eW91IG1heSBqdXN0IHJldmVydCB0aGUgZm9sbG93aW5nIGNvbW1pdCBiYWJmYWE5NTU2ZDcgKCJj
bGs6IGlteDogc2N1Og0KPiBhZGQgbW9yZSBzY3UgY2xvY2tzIikNCj4gDQo+IEFsdGVybmF0aXZl
bHksIGp1c3QgY29tbWVudGluZyBvdXQgdGhlIGZvbGxvd2luZyBzaW5nbGUgbGluZSBhbHNvIGhl
bHBzOg0KPiANCj4gaHR0cHM6Ly9ldXIwMS5zYWZlbGlua3MucHJvdGVjdGlvbi5vdXRsb29rLmNv
bS8/dXJsPWh0dHBzJTNBJTJGJTJGZ2l0Lmtlcm4NCj4gZWwub3JnJTJGcHViJTJGc2NtJTJGbGlu
dXglMkZrZXJuZWwlMkZnaXQlMkZ0b3J2YWxkcyUyRmxpbnV4LmdpdCUyRnRyDQo+IGVlJTJGZHJp
dmVycyUyRmNsayUyRmlteCUyRmNsay1pbXg4cXhwLmMlM0ZoJTNEdjUuMTklMjNuMTcyJmFtcDtk
DQo+IGF0YT0wNSU3QzAxJTdDYWlzaGVuZy5kb25nJTQwbnhwLmNvbSU3Q2Y4NzUxOWNkZjczZjQ2
YjM4NzMyMDhkYTcNCj4gYWE3MjJmYyU3QzY4NmVhMWQzYmMyYjRjNmZhOTJjZDk5YzVjMzAxNjM1
JTdDMCU3QzElN0M2Mzc5NTcxNTUNCj4gNTE1NzMzODQ4JTdDVW5rbm93biU3Q1RXRnBiR1pzYjNk
OGV5SldJam9pTUM0d0xqQXdNREFpTENKUUlqbw0KPiBpVjJsdU16SWlMQ0pCVGlJNklrMWhhV3dp
TENKWFZDSTZNbjAlM0QlN0MzMDAwJTdDJTdDJTdDJmFtcDtzZGENCj4gdGE9ZjRialdhZGZqM3lN
RndwTGMwbmxhaVNkVVhFUE12azZyaVJtJTJCeGxoeFBvJTNEJmFtcDtyZXNlcnZlZD0NCj4gMA0K
PiANCj4gSSBqdXN0IGZvdW5kIHRoaXMgb3V0IGFib3V0IHR3byB3ZWVrcyBhZ28gYmVmb3JlIEkg
d2VudCB0byB2YWNhdGlvbiBhbmQgc2luY2UNCj4gaGF2ZSB0byBmaW5kIG91dCB3aXRoIE5YUCB3
aGF0IGV4YWN0bHkgdGhlIGlkZWEgb2YgdGhpcyBjbG9ja2luZy9TQ0ZXIHN0dWZmIGlzDQo+IHJl
bGF0ZWQgdG8gb3VyIGhhcmR3YXJlLg0KPiANCj4gQE5YUDogSWYgYW55IG9mIHlvdSBndXlzIGNv
dWxkIHNoZWQgc29tZSBsaWdodCB0aGF0IHdvdWxkIGJlIG11Y2gNCj4gYXBwcmVjaWF0ZWQuIFRo
YW5rcyENCj4gDQoNCkNvcHkgVmlvcmVsLCBGcmFuayBMaSwgQ2xhcmsgdG8gY29tbWVudC4NCg0K
UmVnYXJkcw0KQWlzaGVuZw0K
