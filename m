Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4F3E466168
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 11:28:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350045AbhLBKcO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 05:32:14 -0500
Received: from mail-am6eur05on2082.outbound.protection.outlook.com ([40.107.22.82]:39994
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235880AbhLBKcN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Dec 2021 05:32:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UuQGWu1xyMCOmfAKFlM1VYDBpom1hVBuiPV/dDh7/ZdWbDsqBWNKbyjBX3khCHyxGgRNDyNVL+Knh7xVvVhwW0/efdJLR/8Q626Sq819yGRrBTrL4NHtm61FH6Pv4DXwrmpCEQdUcYKslXy421M5bq5QeLKx5yps2zagAnoMSRn5mks8anyPMq6Y7YCljHt9HrEVFZemWRiRlFRW4VsE/oZsBoS71+VfDE3tAXnX8IK0u6P6qLXBENCruf1GOXwq/EvJg/EHzEuJWbYQ250cPHEi8/RFBFrvrzOO/HraA1JeGul1QJ7pnHIVkPU9zZc/UDjGLasfaABhClsZX8Qwaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uU047PsFD2niL5lc4FSHIDQ+HeK82XnvQuT6f/OtZnc=;
 b=FwDlRw92OB4Sb2QjFzFWR/VapevS635Wn4oNCktyzreknvHFon4Ey6+PzxqkWw1OffhXTZXcjsf9kDuWUyhFzEMFszgDN+PM6E1dBB23psm4JAp5Ce5m0rSFA2uc6d+DFVm9aFiRvwnVFskGt3rfpsZTyQ6BhT0FL2Afwl+PhjxnzMaudiJt5vqo9qT1W+xAc8PkdIyHRTwjISUuWda3uWCsqnVnxczF5Rcwyo8qS6KOZmdfyFEus1Moodo76iiA8Bkah9li0FmVfARUNVIxYglGFWsiXDSI+yunTQ8BcqqdNIfUI1WdWEm7s28oJ8lhAz/DqbnUY3gBbSCQsI5F4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uU047PsFD2niL5lc4FSHIDQ+HeK82XnvQuT6f/OtZnc=;
 b=iE/eApdwIAEWDdfiiqNIOw4k+79cxfgzK95RlYpZPW14/PFR0EaRSDLwQNQQEM4A8pNnoWf+wfjBfS6Ml/t5Y8xPPwMeY8eZgKvRar7wfZtda7lb2uRLFaL562bsFeqpJyBtU5ASixBV2iKAvFFVk1onqw0EP82nYYrAbtpv0CY=
Received: from DB8PR04MB5785.eurprd04.prod.outlook.com (2603:10a6:10:b0::22)
 by DB7PR04MB5498.eurprd04.prod.outlook.com (2603:10a6:10:80::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Thu, 2 Dec
 2021 10:28:48 +0000
Received: from DB8PR04MB5785.eurprd04.prod.outlook.com
 ([fe80::30f6:2b14:3433:c9bf]) by DB8PR04MB5785.eurprd04.prod.outlook.com
 ([fe80::30f6:2b14:3433:c9bf%5]) with mapi id 15.20.4734.024; Thu, 2 Dec 2021
 10:28:48 +0000
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "kuba@kernel.org" <kuba@kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        Yannick Vignon <yannick.vignon@nxp.com>,
        "boon.leong.ong@intel.com" <boon.leong.ong@intel.com>,
        "Jose.Abreu@synopsys.com" <Jose.Abreu@synopsys.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "Joao.Pinto@synopsys.com" <Joao.Pinto@synopsys.com>,
        Mingkai Hu <mingkai.hu@nxp.com>, Leo Li <leoyang.li@nxp.com>
Subject: RE: [EXT] Re: [PATCH net-next 2/2] net: stmmac: make
 stmmac-tx-timeout configurable in Kconfig
Thread-Topic: [EXT] Re: [PATCH net-next 2/2] net: stmmac: make
 stmmac-tx-timeout configurable in Kconfig
Thread-Index: AQHX5lOw+O14fKtNi0KlguahbWtWPqwe/coAgAAAt2A=
Date:   Thu, 2 Dec 2021 10:28:48 +0000
Message-ID: <DB8PR04MB5785293BA211B0FD49EA40AFF0699@DB8PR04MB5785.eurprd04.prod.outlook.com>
References: <20211201014705.6975-1-xiaoliang.yang_1@nxp.com>
 <20211201014705.6975-3-xiaoliang.yang_1@nxp.com>
 <9116dadb-c3a3-1e69-164a-2cffa341b91b@gmail.com>
In-Reply-To: <9116dadb-c3a3-1e69-164a-2cffa341b91b@gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d877063a-4fc4-45b5-b299-08d9b57e86cc
x-ms-traffictypediagnostic: DB7PR04MB5498:
x-microsoft-antispam-prvs: <DB7PR04MB5498B3CE28E028DD6FA62E8BF0699@DB7PR04MB5498.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rfEVVZY9CyjCt++TYCDSm/7velKG0DTZhkXvUzVrqLItiAb9xH6aGVbmMceUkP6Eoee69RXnz9kZazBy/V7YdTYAz35QfFbkC9zCAOxCtWWWBJGLOacuPkWdSHE8tzY0eG/LKRjnC1yywegN8HSRHhBRYH8TEyg25AcQOznS1mGpOiA7WQ2642i00WaKtKIEi34i882pWxSodVt/rvk+Ei3m4AU7d8h2m/r7dpK4fgEkItcyzRlUo5WDWbsO9JXCDbJFAUBA2eHZWTJcZr612p0nhbGX4K0L2rEud77vZn+j5aS0MS55vWDcWf9jag8ZhpbLHeBqFfW3Y4J3QL1AgFzOCenHwp2zuaD4OuUl7pkwzq0PxCIrhMQQHb5BLLzHaPvNhT8fNKBMzNBnIqa0rfbLsuw1Z/HdXZJdhoyakw+yJEhNQ87bw7pg6DlXqY5DlUkfGh0quFU28RIHyTMPdyNX+nF60F6LQr9VWBZynq5sygzZ6mFr5mbKM46wgQpD5/7lp3LyVCN5Zl32Zbc+ngNFle/gNkl67ucwC25IWoEjXGYA9A1lmX6JIpCB8EXGUlf2OiZq9M6HszwwwUehti0CLNGnGF9AhiD49pvBh4CwHMHhmg8dQJouTcd0+vnF8IewqJSRVxuMTwZwlB4E0dtmr8oBKId0EMhzFuZNEjDQEucy+P1VLESuebP/qKHQ1PcdqfRxQb6b8bzLCyfG/A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB5785.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(83380400001)(26005)(38100700002)(71200400001)(8676002)(186003)(33656002)(122000001)(110136005)(66476007)(2906002)(38070700005)(54906003)(316002)(9686003)(66946007)(66446008)(55016003)(4744005)(4326008)(7696005)(6506007)(64756008)(53546011)(66556008)(76116006)(5660300002)(7416002)(86362001)(52536014)(508600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SytjYXZ1QURaUFJkREpPNHFZdTJUWXRhV0c3NlJOVUUxc3N0eDNldkIvRG5n?=
 =?utf-8?B?cXZtbkF6N2VJSVA2VXlnTXowL2xtck1CSzVVQkhTaDUvcnpqYzJQTHB6b3I4?=
 =?utf-8?B?L25TdjAreGxtSzFvRkw3YXNIMHJUNHh2UmtVVTlENGp1UWxzeFA5SmZiVlVh?=
 =?utf-8?B?SEE5bEcyaG9sL01KbTVzQXBIYVozSWJyUE9nNnZGTTljUWxxdTlzUlo5anZW?=
 =?utf-8?B?SENxSnArbCtySElBM3hrVzFML3hlMFJHdXlvbFFPK01RRWhVb255SXo3Mlcy?=
 =?utf-8?B?Ny9WMVVGYTNaM2pMNkdraE40cG5ZWUw0bVFYQVRsZVBIN0Y2cEdzcEZnRUZh?=
 =?utf-8?B?RnFGRVAzK2liWmkxUG1SQjJ3Yk9yaTgrczVRUlppL1lHSnVEVXFNY09RRVBu?=
 =?utf-8?B?cURIV0JVSVh0SVJ4TldwTWZvSlJDTDU5VEV2NCt3cGRKcVh3dVA1dnBBSU5R?=
 =?utf-8?B?LzEwWEc4QkViZmFDdjRiYmN5cUNEZU5QdnJESWtxWGpEd3ZRdmRqSllzYUpW?=
 =?utf-8?B?NXRjOHd1TVZIZFd2eStzQis4ZjdObzhWVVVFdFJkejNBYzE5MENjbzhjenpq?=
 =?utf-8?B?QjZHMEk0bWM1UUlxZDVZdG0zV3BuMTJITTUrOTBib3lhMU5Lb1M0M0VGdUlK?=
 =?utf-8?B?MHE2YUVxZ0h4L01CMTFtZ3VxTGdTWVlwL3czek5JR0FLTXZBSEZSdzY4K1hP?=
 =?utf-8?B?c2crWVk4WU14U0F1R1FOdHFqV1hOTHY2OEJpOGtsQ1RzQ3ZpMExCOU9mejI0?=
 =?utf-8?B?bTJyYmhuWS9Bc2RWWnRTYnNvYUFiTzIwSXNsNlNiZGQ3WU9HN0xvYTVIQ3Rj?=
 =?utf-8?B?TUgvQVp4UkdQd2x5ZU50L1pteFZYNWNCZkEvbGRJNExsK05kSDZVMnE2emtq?=
 =?utf-8?B?R0Jjbmw3WjVpTDNTcW9IYklnekp0dzYxWEZuRDc0dkwxYjJTRlYvaE1XK29D?=
 =?utf-8?B?OUFrOHoxVWN6cmlCRXJ6VmJHK0ZHZnpqS0FYOXZNNFJuSFFhRkNrS2FXOGpE?=
 =?utf-8?B?eS9Ecmxyc3RjUU1tT0FkZVdpd0Y3cUtvREtJNzJXNmdvZDUvZkhHNUpjYW1t?=
 =?utf-8?B?MmtMOS9GUWZEdE1pT3JoTjgxZG5JMVV5eVlSVWIzckpCY04yVzU1WmYvMUtE?=
 =?utf-8?B?UW9OZC9MbkNCcEpUcXdJT29wOXVocWNaOUkrTGYzOFZIN0NPZVl0QjdSYlhp?=
 =?utf-8?B?cU4xQ2ZlUG10T2pBNEdVZUtpOGVPdTNpWnIzS20xZlFnUFRVV2lneWV5TWZL?=
 =?utf-8?B?MTJ3M3BraVZ0dmJOM1Z2TnlGaDNialhBUW1LckdCS0VWY2tMSlBtaHExK0xi?=
 =?utf-8?B?c1RELzVLMDlMVkpkNVJrZ3FTSnRZd3puKzR4cmw1a3FBdm5GdG9CbjM5Qy9w?=
 =?utf-8?B?bjF6Y3JsT2hwZ08yWG53Z2NVSStEUE5uODBaWkUvQmRyNm54QnVqdHhobzI3?=
 =?utf-8?B?emROODN6RlJEWGxxL016TEV5azFqSVREbWhTcEgwYVQybHpER3BXQzRtYk55?=
 =?utf-8?B?b1FBREplUUdYc1pBYmVaVkFJNExvS1Rib2NBZFBLU3RmNGRkMGVSZWJKVWFS?=
 =?utf-8?B?U2YwUm9STWdJaWxNVmRPNk5rejAzWDBGbFc1WVFBci9JWVZrd2tQM1IvdWdP?=
 =?utf-8?B?eVhXVlk5R0dSemFZY2tTbmVnYURmZ2h5dXE1QWl2K1VtNkN5NTFPS0o3MG5X?=
 =?utf-8?B?TzgvOThXc1dFOGMxTnk1RkdsTHlQUnhRNW12TFMxRlFLU0V2ZFR3STZCUTU4?=
 =?utf-8?B?emdQV3d2Z1kzaGNCNXVLUXpQdlRaWVJlVXkzdVZDb1FHK2x1RG8xa2hRSGhN?=
 =?utf-8?B?SkxLcDRHYll6OERtd1hDSFhGbVJURy8rYTM4WFJiYlB1RFpHaTlOR2NNN3dp?=
 =?utf-8?B?M3pmcFZvWUJUM1lTQVFnK3lIL29OVUtLYnhYayt4R3JCUzcwZ1dOMklsZzBp?=
 =?utf-8?B?V0FKcXBjZTdMbDUwd3JvZDBXdWxCZXRZYng2T0pzNUpkV0t3SWE4T2JMS2RH?=
 =?utf-8?B?b3BtbmpLdFlEd0J5QzJhalNSMUpEcXVXRGV0UWxlcGlzeCtqTWIwcVZKeU80?=
 =?utf-8?B?MUIyN2pkL2E2b2RRZEk4ZjBYSmVnU0diNjZVbHNqQ3QySGpaaHFMUlVYd004?=
 =?utf-8?B?eFgrbWxVZWRWSjhHS0F2M1RhMnh2YWpCdFRtRDNualpqb2tEbmdnVko5ckRX?=
 =?utf-8?B?eERWQUs5dWxHY0dLZlBnSElPOTNmRHhjcldLcWJQTWJUYk5YSjdoQStPWnB0?=
 =?utf-8?B?dllpU3U3eUxqYmdaUDZPRjZXeTFRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB5785.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d877063a-4fc4-45b5-b299-08d9b57e86cc
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2021 10:28:48.1114
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: is+KufoVzNF2aAI/qWB2LQO+aRbPJ5hTxeez/ymTVslkADvEWvG2qNPvqjtM3p9wABM6k+wmyqtSdI9OBQExVxVu0ocsltLk50N6d26KZjI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5498
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgSGVpbmVyLA0KDQpPbiBEZWMgMDIsIDIwMjEgYXQgMTY6MTM6MjAsIEhlaW5lciBLYWxsd2Vp
dCB3cm90ZToNCj4gPiBzdG1tYWNfdHhfdGltZW91dCgpIGZ1bmN0aW9uIGlzIGNhbGxlZCB3aGVu
IGEgcXVldWUgdHJhbnNtaXNzaW9uDQo+ID4gdGltZW91dC4gV2hlbiBTdHJpY3QgUHJpb3JpdHkg
aXMgdXNlZCBhcyBzY2hlZHVsaW5nIGFsZ29yaXRobXMsIHRoZQ0KPiA+IGxvd2VyIHByaW9yaXR5
IHF1ZXVlIG1heSBiZSBibG9ja2VkIGJ5IGEgaGlnaGVyIHByb3JpdHkgcXVldWUsIHdoaWNoDQo+
ID4gd2lsbCBsZWFkIHRvIHR4IHRpbWVvdXQuIFdlIGRvbid0IHdhbnQgdG8gZW5hYmxlIHRoZSB0
eCB3YXRjaGRvZw0KPiA+IHRpbWVvdXQgaW4gdGhpcyBjYXNlLiBUaGVyZWZvcmUsIHRoaXMgcGF0
Y2ggbWFrZSBzdG1tYWMtdHgtdGltZW91dA0KPiBjb25maWd1cmFibGUuDQo+ID4NCj4gWW91ciBw
YXRjaCBqdXN0IGRpc2FibGVzIHRoZSB0aW1lb3V0IGhhbmRsZXIsIHRoZSBXQVJOX09OQ0UoKSB3
b3VsZCBzdGlsbCBmaXJlLg0KPiBBbmQgc2hvdWxkbid0IHRoaXMgYmUgYSBydW50aW1lIHNldHRp
bmcgcmF0aGVyIHRoYW4gYSBjb21waWxlLXRpbWUgc2V0dGluZz8NCj4gDQpJIHRyaWVkIHRvIGRp
c2FibGUgaXQgaW4gc3RtbWFjX3R4X3RpbWVvdXQoKSBhdCBydW50aW1lLCB0aGUgV0FSTl9PTkNF
KCkgd2lsbCBzdGlsbCBiZSBjYWxsZWQgZnJvbSBkZXZfd2F0Y2hkb2coKSBpbiBzY2hfZ2VuZXJp
Yy5jLiBJdCBzZWVtcyBvbmx5IHdoZW4gdGhlIHRpbWVvdXQgaGFuZGxlciBpcyBOVUxMIGNhbiBk
aXNhYmxlIHRoZSBuZXRkZXYgd2F0Y2hkb2cgdXAuIFNvIEkgZGlkIHRoaXMgaW4gY29tcGlsZS10
aW1lIHNldHRpbmcuDQoNClJlZ2FyZHMsDQpYaWFvbGlhbmcNCg==
