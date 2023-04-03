Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90A256D3F50
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 10:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231796AbjDCIoQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 04:44:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231598AbjDCIoN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 04:44:13 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2048.outbound.protection.outlook.com [40.107.20.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 690B410401;
        Mon,  3 Apr 2023 01:43:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gtwhDPMep4H3b0TpRsp514WXwOIFKLBWtMRES6tNirKtOUT+KiUMyE4jdG+r7JHBpVhWAqi5efUbHIFCTdEFG6fojzX+TZqavPjxNFFZzhNw5quPs08UiutAmM1Qg7iDzn+XcOZjCn9Tehh1QIfz4K7eqgsFVNyVnRM3gNPRbWnyQA29jV4NsBdOykx3URZfuJmRhYnAccVYTEzbEqaXUvjCnnGoQGUpSDcodd3jQxE1Q6Ei2D4nD6Ll/nyn1S+QsYWlrxy70/LSYuFb37Zxtxq89P/kudjXt9HT+Xxzg3TKQcJFWaGuhmT2c5I97bbR7sqPBMDt86TG9DHnX6zbpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LUJyKxK1pNCO50LH14WKJBKIr80qok7vEKZ6VzKF5+U=;
 b=V7B8hgkHFDgW2dMfrpzLsKL47c2QZU+mgR/sCHurRfj8109/wZe2UHFVEDax/ciztTvH/1JTJhAo17bhmJMdMPJMqbdsSmXVB13VGWpdhaKHh4qdygKfCz1BviZMr+0T1Q751k9uCTl9WKFx67QWTfG2FbrAgCToSJ7DZ7OBdQ0NImyQNXYbX13nCnJAf6bm/8SLKEAeVvMg9+24Qpf6K8jmWcofj1blDjt5uSO4T4UznnFt09BwhIsTct4LfyN22TixAq2L8MsS6CFgapff4G94Aeh5l5BWD8vqriZgoi9zsEVAmvU9Ie9wHUIx+X+05hUkVxohVU4cXfzbI49sHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LUJyKxK1pNCO50LH14WKJBKIr80qok7vEKZ6VzKF5+U=;
 b=gdqYfDdDZrrgR/3XiPMddtob0Y0sZMFfPWRWRsR+wPUP3K7u+LG2RdBu8w+h1uk96aVU+/BEuTR5qYd2TO91AO7KpXzNGkmwe9xIKIely+j/iJm5rG75RmomJrGMkdA7ZF75pTpLZGt8K2qm7fsICV47cRT4y2Hseaf5iHWJIGI=
Received: from AM0PR04MB5089.eurprd04.prod.outlook.com (2603:10a6:208:c6::21)
 by DU0PR04MB9276.eurprd04.prod.outlook.com (2603:10a6:10:357::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Mon, 3 Apr
 2023 08:43:54 +0000
Received: from AM0PR04MB5089.eurprd04.prod.outlook.com
 ([fe80::88b3:4064:f8d1:67bb]) by AM0PR04MB5089.eurprd04.prod.outlook.com
 ([fe80::88b3:4064:f8d1:67bb%5]) with mapi id 15.20.6254.033; Mon, 3 Apr 2023
 08:43:54 +0000
From:   Clark Wang <xiaoning.wang@nxp.com>
To:     Ahmad Fatoum <a.fatoum@pengutronix.de>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [Linux-stm32] [PATCH] net: stmmac: remove the limitation of
 adding vlan in promisc mode
Thread-Topic: [Linux-stm32] [PATCH] net: stmmac: remove the limitation of
 adding vlan in promisc mode
Thread-Index: AQHZZgbUn2wNpKWM4EqXkGrUw6ye+68ZRDeAgAAAaQA=
Date:   Mon, 3 Apr 2023 08:43:54 +0000
Message-ID: <AM0PR04MB5089AD62F07221A7FC326E85F3929@AM0PR04MB5089.eurprd04.prod.outlook.com>
References: <20230403081717.2047939-1-xiaoning.wang@nxp.com>
 <33b8501c-f617-3f66-91c4-02f9963e2a2f@pengutronix.de>
In-Reply-To: <33b8501c-f617-3f66-91c4-02f9963e2a2f@pengutronix.de>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM0PR04MB5089:EE_|DU0PR04MB9276:EE_
x-ms-office365-filtering-correlation-id: 44cce7f7-b5a9-465f-86ec-08db341f8e66
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hP4crRc9hl9HvX6eJD49ADXxiPkMCIvNFO41jL7690b4ZtHWS0JzRcJ0WJeVkuArCY03UFdzmuIrgFdSeQf3L/8tGngPVTcdLRnAa9zQE8fx+auq9W1aA9HOKquFfg95uLbOmoiFwyYQ8so7nBIXur93bLElDLZyBwcSdYXsanwiKPaiB1O+VjhY9fNe1MCtFrDOlGeff7kmwukzpiW615LkxhDSrfQYbP35t1kLzjkIHgF5byJCANFiD1uipkPVSaKq3klFy2N5ZeQxnKCqv64clqqaDzxUNghjRanOBCCv9yg8snPerst4USKSqpG0TVNpPWCu9IabnF1tGeeJPpGNFKEBXmaOrSJazeT0S62MnoBTvfHDuAGhVaPj/9evh3IT4Bks2b7QjZfNE1fv192FDfbsRLKXtzSqQEUes4KVjuNyUGIeQVZGzYHsnFn56vN7HFRrwaOPitLe0KcPsic0U4JBSu0dFadE3xSHxWURSOPmJf+AySUb5QTF3OGnNK89X8CdoWfZhli9mqsnLWaX9UldFxmJlbkL+Ec3V0lSl6vayhUOeWC4Oe7BmhItZOeQhgCrRkcrdqgrZDJUcRsy0DftlwIcqMt6yTQmbww=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(136003)(376002)(346002)(39860400002)(451199021)(33656002)(122000001)(52536014)(5660300002)(7416002)(38070700005)(55016003)(38100700002)(66946007)(4326008)(41300700001)(86362001)(8676002)(8936002)(64756008)(66446008)(66476007)(66556008)(76116006)(83380400001)(966005)(53546011)(110136005)(2906002)(9686003)(6506007)(54906003)(26005)(71200400001)(478600001)(7696005)(45080400002)(186003)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?T3dtRWhLYTlCck0vVEVzelpBZTA3UG1vVVk5MndBMU4xcEt4bC9XNFlBaVNt?=
 =?gb2312?B?UkdlenV0LzUycEVTQVp2a1JaTVBKVG1ab2Z3VjFCc0N0YUdLeVJCKzVYY0pU?=
 =?gb2312?B?MExab0xBczhRVW5GQVJUaFRQVTBhS0JQZVlNTjJlUVNTNFZVNlZSUmNHR0xB?=
 =?gb2312?B?bU1KSDNaZ25oUlNCaTJsNFIrKzZzcWtyY2t4ejVVOTloUnR0L2c1VUV6c3Ax?=
 =?gb2312?B?bit4MEVwWkJJWmVNUGVDUXdLS2psZGRiVFBTZGEwZy9iRnZhTGNNOGxoajl5?=
 =?gb2312?B?UU1QZ0VjejdzU0hSTzV5SmdYRW5UbldDT2FqSnlyY2QyRHpuejFKUkJlRTBE?=
 =?gb2312?B?T3ZLZTkwWWVMNGkvNXh6V3Y0WWZxNFRvenNaUmx6Sk9aVldmNTRyOExlNFFN?=
 =?gb2312?B?QTBxeEQzMWJQTlRlWTZyeGwwbnNZZVZCVm94K2VBankzWE5EQ05PUkJpdTJ1?=
 =?gb2312?B?cWRJYURQYXhsYm1kUHlmTlB0Nit5WG1GL2Rnd0NwL0FUZWI3Vzd3K3d3MmR4?=
 =?gb2312?B?Q1RNTVFxYmpWeFMyYVpWK1BlVy9ybHZBdWJJMEx4MzloT25HTFJvNmNQN09p?=
 =?gb2312?B?YXptV3lTK0d0bDExbjgvZHpra25KU2dvaFBtS21nRU9lTUFYMlRPd1pXSUhL?=
 =?gb2312?B?M0lUMXBQODk2TUxtZFRGSUtXeFJjdUMxTHI4eXByQk9mV3A5QVBibVE3bVdh?=
 =?gb2312?B?NTZnbmIrYmtFN2dsM0Zhb2MxUFlONjJmZVZhRVZPK0Y0L3crS0EvQzZBQkpm?=
 =?gb2312?B?NDliRU1KRGN5a2loelNWSVcxWUVEYWZhNTEzMjNuUmkyMDdZQ0kwYldHZVFx?=
 =?gb2312?B?MmZLZDBqam9LcFhzanh3NTIzLzQ1NWNlMUNqeWVSOWExcFFkR2JFWUsxV0gr?=
 =?gb2312?B?c0s1UkYza3FvcXlqelRXcXRwTkEwK1JNQUdadlowRUpNcnpyY3RKWjBLdStD?=
 =?gb2312?B?R0pVNy93U2QwQzE5R0FDeUtxQ0xvQlRXUE9WTEVjbmpvdzdBQXo0d2ZtL0ND?=
 =?gb2312?B?SEJVRTk3UFhTOWM0b20vOFNJWWJEZUpUbGVmN3Y4V0RUMEtHdjVDNjJoU2VG?=
 =?gb2312?B?TGpUenlHRzAyT1Q3Tmt1b3dKalNhd1NrODBzVnNza0dPcTBWUlRUQ01JcWZM?=
 =?gb2312?B?VWhSeHJubngzQTlOVXhxSXVRcVVhRWdDNzZHblhCQ29Oclh6QkN3RlN1Vk9E?=
 =?gb2312?B?c1p5OUt0U1hjenhzWG5VVWYwc0FyUmw2ZWw2WVpsVkZzbmsxQjBQY1k4c1da?=
 =?gb2312?B?ZG5IeHVVODhkQWVnbDNSSEU1Mm9xU2tYT0tCVlJHS0FobnlhV2ZJOFVtdUwr?=
 =?gb2312?B?TTRuTy9rc3BmMk1lQTh1Q055czV5OGxyeEFoRnljLzJDOE1lSTdmWXNiNzJR?=
 =?gb2312?B?cE1FU3dBaTcyY3NYM3c3YnFWWENKM2ZzQit6SXR3ZXpaVVl0aVdrZHlicUw4?=
 =?gb2312?B?OFNFdHBMZEsxS1NxT3pkbzRUQk9sUExJYkUxSmo3a0YzaVdPdUpIYVZGYkJj?=
 =?gb2312?B?U0VmYnBxUnAwZzRUUmc1VUhJUW13SFlmbDhFUHVSYjJuZUFRalhTMitheWNi?=
 =?gb2312?B?cVhSNmNyY0xkNFRyNnFSVFBMRDhQajNzT1RGSTlsWkJ4ZERsR1Y5K2lFayta?=
 =?gb2312?B?ZWpKRmd6dlpoOGllWVdyaGhqbUx5YzJRQURxTmE2S2IvVDJnR2JjVnNWZDFx?=
 =?gb2312?B?eE5VUGFreUE5TEVjdzI4MUxnNnZ0YWtqaVFPUGdyQmJOdGlPS1QvMi80RWZR?=
 =?gb2312?B?akVldFpvc2QzamdNdDZrV2FKUFNPd1RzZTM1R0dFVTlqb2RuVEEwOXo0a1hC?=
 =?gb2312?B?NXhrMFJnTUZBQmhTZGRNeS85NVpqM0N5WkNlMUltT0tNS2dkbnpoZEUyenVu?=
 =?gb2312?B?ZEM4QUZCWDVjcTlML3JPYkdRcWdaZzcyWTRFS21RTlp5WE5VWXBlTUtxQzl6?=
 =?gb2312?B?a2VnYktJeG5GMWhXSzdHNEh6TmlTa29zZnZ0MzF0SDk5c0ZKK0hTTlJPRXZ1?=
 =?gb2312?B?TDB2SDQ5bFAwMk51QlJvQ05mVmJIdVI0ZVdpRmZKOEJFRWtTeUVmbW1RanVt?=
 =?gb2312?B?enB3R0Z2K00rRDlQV1UzMVNTYUptd3BNZC9pQi92VldiOWNwdVNTNVp5U2p5?=
 =?gb2312?Q?rYDTBZrpKKCmQHhyteqS9wR8W?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44cce7f7-b5a9-465f-86ec-08db341f8e66
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Apr 2023 08:43:54.0474
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Rr/mi/qBbEOXSa7i9+B7AAeeJ8SQxXGrYXn5p/pb8FCwxq0aXazNdSs8RJ9J26harl8t1uOhj5k3CVN2YI2FjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR04MB9276
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQWhtYWQsDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQWhtYWQg
RmF0b3VtIDxhLmZhdG91bUBwZW5ndXRyb25peC5kZT4NCj4gU2VudDogMjAyM8TqNNTCM8jVIDE2
OjQyDQo+IFRvOiBDbGFyayBXYW5nIDx4aWFvbmluZy53YW5nQG54cC5jb20+OyBwZXBwZS5jYXZh
bGxhcm9Ac3QuY29tOw0KPiBhbGV4YW5kcmUudG9yZ3VlQGZvc3Muc3QuY29tOyBqb2FicmV1QHN5
bm9wc3lzLmNvbTsNCj4gZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsgZWR1bWF6ZXRAZ29vZ2xlLmNvbTsg
a3ViYUBrZXJuZWwub3JnOw0KPiBwYWJlbmlAcmVkaGF0LmNvbTsgbWNvcXVlbGluLnN0bTMyQGdt
YWlsLmNvbQ0KPiBDYzogbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgbGludXgtc3RtMzJAc3QtbWQt
bWFpbG1hbi5zdG9ybXJlcGx5LmNvbTsNCj4gbGludXgtYXJtLWtlcm5lbEBsaXN0cy5pbmZyYWRl
YWQub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBbTGlu
dXgtc3RtMzJdIFtQQVRDSF0gbmV0OiBzdG1tYWM6IHJlbW92ZSB0aGUgbGltaXRhdGlvbiBvZg0K
PiBhZGRpbmcgdmxhbiBpbiBwcm9taXNjIG1vZGUNCj4gDQo+IEhlbGxvIENsYXJrLA0KPiANCj4g
T24gMDMuMDQuMjMgMTA6MTcsIENsYXJrIFdhbmcgd3JvdGU6DQo+ID4gV2hlbiB1c2luZyBicmN0
bCB0byBhZGQgZXFvcyB0byBhIGJyaWRnZSwgaXQgd2lsbCBmcmlzdCBzZXQgZXFvcyB0bw0KPiA+
IHByb21pc2MgbW9kZSBhbmQgdGhlbiBzZXQgYSBWTEFOIGZvciB0aGlzIGJyaWRnZSB3aXRoIGEg
ZmlsZXIgVklEDQo+ID4gdmFsdWUgb2YgMS4NCj4gPg0KPiA+IFRoZXNlIHR3byBlcnJvciByZXR1
cm5zIGxpbWl0IHRoZSB1c2Ugb2YgYnJjdGwsIHJlc3VsdGluZyBpbiB0aGUNCj4gPiBpbmFiaWxp
dHkgb2YgdGhlIGJyaWRnZSB0byBiZSBlbmFibGVkIG9uIGVxb3MuIFNvIHJlbW92ZSB0aGVtLg0K
PiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogQ2xhcmsgV2FuZyA8eGlhb25pbmcud2FuZ0BueHAuY29t
Pg0KPiANCj4gUGxlYXNlIGFkZCBhIHN1aXRhYmxlIEZpeGVzOiB0YWcgcG9pbnRpbmcgYXQgdGhl
IGNvbW1pdCBpbnRyb2R1Y2luZyB0aGUNCj4gcmVncmVzc2lvbi4NCg0KDQpUaGFua3MuIEkgd2ls
bCBhZGQgaXQgaW4gVjIuDQoNCkJlc3QgUmVnYXJkcywNCkNsYXJrIFdhbmcNCj4gDQo+IFRoYW5r
cywNCj4gQWhtYWQNCj4gDQo+ID4gLS0tDQo+ID4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L3N0bWlj
cm8vc3RtbWFjL2R3bWFjNF9jb3JlLmMgfCAxMiAtLS0tLS0tLS0tLS0NCj4gPiAgMSBmaWxlIGNo
YW5nZWQsIDEyIGRlbGV0aW9ucygtKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0
L2V0aGVybmV0L3N0bWljcm8vc3RtbWFjL2R3bWFjNF9jb3JlLmMNCj4gPiBiL2RyaXZlcnMvbmV0
L2V0aGVybmV0L3N0bWljcm8vc3RtbWFjL2R3bWFjNF9jb3JlLmMNCj4gPiBpbmRleCA4YzdhMGI3
Yzk5NTIuLjY0YmJlMTVhNjk5ZSAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5l
dC9zdG1pY3JvL3N0bW1hYy9kd21hYzRfY29yZS5jDQo+ID4gKysrIGIvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvc3RtaWNyby9zdG1tYWMvZHdtYWM0X2NvcmUuYw0KPiA+IEBAIC00NzIsMTIgKzQ3Miw2
IEBAIHN0YXRpYyBpbnQgZHdtYWM0X2FkZF9od192bGFuX3J4X2ZsdHIoc3RydWN0DQo+IG5ldF9k
ZXZpY2UgKmRldiwNCj4gPiAgCWlmICh2aWQgPiA0MDk1KQ0KPiA+ICAJCXJldHVybiAtRUlOVkFM
Ow0KPiA+DQo+ID4gLQlpZiAoaHctPnByb21pc2MpIHsNCj4gPiAtCQluZXRkZXZfZXJyKGRldiwN
Cj4gPiAtCQkJICAgIkFkZGluZyBWTEFOIGluIHByb21pc2MgbW9kZSBub3Qgc3VwcG9ydGVkXG4i
KTsNCj4gPiAtCQlyZXR1cm4gLUVQRVJNOw0KPiA+IC0JfQ0KPiA+IC0NCj4gPiAgCS8qIFNpbmds
ZSBSeCBWTEFOIEZpbHRlciAqLw0KPiA+ICAJaWYgKGh3LT5udW1fdmxhbiA9PSAxKSB7DQo+ID4g
IAkJLyogRm9yIHNpbmdsZSBWTEFOIGZpbHRlciwgVklEIDAgbWVhbnMgVkxBTiBwcm9taXNjdW91
cyAqLyBAQA0KPiA+IC01MjcsMTIgKzUyMSw2IEBAIHN0YXRpYyBpbnQgZHdtYWM0X2RlbF9od192
bGFuX3J4X2ZsdHIoc3RydWN0DQo+ID4gbmV0X2RldmljZSAqZGV2LCAgew0KPiA+ICAJaW50IGks
IHJldCA9IDA7DQo+ID4NCj4gPiAtCWlmIChody0+cHJvbWlzYykgew0KPiA+IC0JCW5ldGRldl9l
cnIoZGV2LA0KPiA+IC0JCQkgICAiRGVsZXRpbmcgVkxBTiBpbiBwcm9taXNjIG1vZGUgbm90IHN1
cHBvcnRlZFxuIik7DQo+ID4gLQkJcmV0dXJuIC1FUEVSTTsNCj4gPiAtCX0NCj4gPiAtDQo+ID4g
IAkvKiBTaW5nbGUgUnggVkxBTiBGaWx0ZXIgKi8NCj4gPiAgCWlmIChody0+bnVtX3ZsYW4gPT0g
MSkgew0KPiA+ICAJCWlmICgoaHctPnZsYW5fZmlsdGVyWzBdICYgR01BQ19WTEFOX1RBR19WSUQp
ID09IHZpZCkgew0KPiANCj4gLS0NCj4gUGVuZ3V0cm9uaXggZS5LLiAgICAgICAgICAgICAgICAg
ICAgICAgICAgIHwNCj4gfA0KPiBTdGV1ZXJ3YWxkZXIgU3RyLiAyMSAgICAgICAgICAgICAgICAg
ICAgICAgfA0KPiBodHRwczovL2V1cjAxLnNhZmVsaW5rcy5wcm90ZWN0aW9uLm91dGxvb2suY29t
Lz91cmw9aHR0cCUzQSUyRiUyRnd3dy5wZQ0KPiBuZ3V0cm9uaXguZGUlMkYmZGF0YT0wNSU3QzAx
JTdDeGlhb25pbmcud2FuZyU0MG54cC5jb20lN0MzZmNjYjg1Mw0KPiA1ODZkNDkwNDQ4NjkwOGRi
MzQxZjQ4ODIlN0M2ODZlYTFkM2JjMmI0YzZmYTkyY2Q5OWM1YzMwMTYzNSU3QzAlDQo+IDdDMCU3
QzYzODE2MTA4MTE4MjQyMTI3MyU3Q1Vua25vd24lN0NUV0ZwYkdac2IzZDhleUpXSWpvaU1DNHcN
Cj4gTGpBd01EQWlMQ0pRSWpvaVYybHVNeklpTENKQlRpSTZJazFoYVd3aUxDSlhWQ0k2TW4wJTNE
JTdDMzAwMCU3Qw0KPiAlN0MlN0Mmc2RhdGE9VW9NZk02OWQ0WTVPSTdhbnQ1VU5sTkNsODF0bHM0
NU9uNmhzWlFlWlpIOCUzRCZyDQo+IGVzZXJ2ZWQ9MCAgfA0KPiAzMTEzNyBIaWxkZXNoZWltLCBH
ZXJtYW55ICAgICAgICAgICAgICAgICAgfCBQaG9uZTogKzQ5LTUxMjEtMjA2OTE3LTANCj4gfA0K
PiBBbXRzZ2VyaWNodCBIaWxkZXNoZWltLCBIUkEgMjY4NiAgICAgICAgICAgfCBGYXg6DQo+ICs0
OS01MTIxLTIwNjkxNy01NTU1IHwNCg0K
