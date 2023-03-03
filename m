Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F5986A9482
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 10:53:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230303AbjCCJx1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 04:53:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230112AbjCCJx0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 04:53:26 -0500
Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on2065.outbound.protection.outlook.com [40.107.249.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1DE710417;
        Fri,  3 Mar 2023 01:53:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cy3u6W1uH6FJ8bcAKebm6Z8mKcBnH8xFtmmrUUVZGF/WehrXvHF7SwOO0e/GzLxXXWuLZE2dVpt08BuN2m1zNuxNjqUpQlK8Y2C3v0GmXCygnE1QiGJ2iZUD4bevxcJ8srv0JrTcQMA3a0AA1IMx1pkNutFsx3mMipQKwuSIeAJ7ZI/BUsDYg7EABeO/2wBzZ8Vw52jeaEvlw18cRWNH8/+LbQwpYa7gKFW3LDh6HOfA0HkeasuaSdHbqy0Kj2P0yfcsMPTXJqfQF10ufSXZYG94MVVogklt692iu3EEkKCWeJJDf1usFBh1kMEWqcN+sPgDdcmLFiTaIhqZQpZTjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eatOTa5IWFAUFiA/CAGDdVSFh1tecknz1A2yXJvNjwc=;
 b=iaUeduHJKDCxiq7z+eAlJmAfRhGy/scX8KlyZGjHRlAPv4/am/E7rvU04JVlV3oc+b/Dc6Z/wvqroKDGUjc3eRo35UhIQjnCfr5QwatPIIm7meXKf3//ht99LG/62IXwd15oSOhiQ1cNT6VqEA4+QgUrlP5VQ5cQv2x9lAYOR+MwMrBqR9thmQpk1wDMaS+Gq2MQX4BVsjcS1ADVZXhT6Z2kDrp4CJJf6QRPjOk2SQQdbpT/Gj6Sld97RGad2tQYhTEO4kxsMVYWG5oZT9XBq9Esz4KCAVcimpQDvY1T4njTSAiztUM+vEsHxF1WRSwsn7jrDS59k+pPTQJ1tFrkEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eatOTa5IWFAUFiA/CAGDdVSFh1tecknz1A2yXJvNjwc=;
 b=g4aQDU9gJcLo0FIChZOZRVoYlRcjVL8HE2LCnWC4MyhVyyX9kHySTVY3OvRWixg08NrHus/bASnmfG2a+CV3X5JtP5W7PT9y2KdnACJ3UYX9D7vsV69qoWn0a24U+Gg3OGS+aiJCZMsoSNE6g4ll6vCAi8v98G90JiVnRwtbav4=
Received: from DB9PR04MB9648.eurprd04.prod.outlook.com (2603:10a6:10:30c::10)
 by PAWPR04MB9743.eurprd04.prod.outlook.com (2603:10a6:102:384::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.18; Fri, 3 Mar
 2023 09:53:20 +0000
Received: from DB9PR04MB9648.eurprd04.prod.outlook.com
 ([fe80::c1c1:4646:4635:547d]) by DB9PR04MB9648.eurprd04.prod.outlook.com
 ([fe80::c1c1:4646:4635:547d%4]) with mapi id 15.20.6156.018; Fri, 3 Mar 2023
 09:53:20 +0000
From:   Madhu Koriginja <madhu.koriginja@nxp.com>
To:     Paolo Abeni <pabeni@redhat.com>,
        "gerrit@erg.abdn.ac.uk" <gerrit@erg.abdn.ac.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuznet@ms2.inr.ac.ru" <kuznet@ms2.inr.ac.ru>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "dccp@vger.kernel.org" <dccp@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Vani Namala <vani.namala@nxp.com>
Subject: RE: [EXT] Re: [PATCH] [net:netfilter]: Keep conntrack reference until
 IPsecv6 policy checks are done
Thread-Topic: [EXT] Re: [PATCH] [net:netfilter]: Keep conntrack reference
 until IPsecv6 policy checks are done
Thread-Index: AQHZTPlwZ/TDa2CkN0WefPEV2O4Tu67njFKAgAFD41A=
Date:   Fri, 3 Mar 2023 09:53:20 +0000
Message-ID: <DB9PR04MB964835E3C87393525F85096FFCB39@DB9PR04MB9648.eurprd04.prod.outlook.com>
References: <20230302112324.906365-1-madhu.koriginja@nxp.com>
 <3dc0b4652c04c508b21f2028a20b7f81387c7fd4.camel@redhat.com>
In-Reply-To: <3dc0b4652c04c508b21f2028a20b7f81387c7fd4.camel@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DB9PR04MB9648:EE_|PAWPR04MB9743:EE_
x-ms-office365-filtering-correlation-id: 7ffe287d-7ef7-4908-8add-08db1bcd1f14
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +6GjWPD00tsGH7dVwzPhOQHw8nM2wcapEjKs6VeNg+Wvf9iyX9oI2koGYQOE0rq+BHvOU5RbUMxTeFLLzVSFxMZX4IGMnXx6l7da/pEWmLsMKu8mLMAiVxQZXH3ALByqg8ppiXpQL/URS59gWQryhvIBTRsGblfCqCaHevzo9s31qE/Y6zoiufkpBsYhjJJWQ21vWQWql57DRzk7CXtkM8bZZFf1Wo/peYhatPQJMrCViWOTgChd72qfF9aKwdDi+kPdxNaGi1q29KFszMFYaWaKj+2Ob/8vA2vPGvyA9xEWqQXT7SeOXzKpms/r83vW0ZnFwHci+Kb3QYBuGg+BZPWsPgS2xzR0hHHmcNlxIDJkEqk5DB58BaWU7Y4NZW1rNVa6jkrPAvOsvEnSG0kc74dYrMlU3oltAW42HQFxPhTdqJueWGIs4tEVYisFCuaaN7UARa0sxkphgPf7JYIRf+D+g8ocN474MW4T05MGJHsBiZDus2bBCcLHOczZ6Wqlu9zzEVRZtVRtvyg7M5qY9hBQHOiBX/dMWkkXGDBG0M5ZZs8WK1YmHCQXxfVdteX7hFlkHu15wNDLDtqJaNLV1qSi7tDBLqSbyCTH79efmyNDIdQOhRPkfmzszgrmx45QtrgA+p4cRZSXJ/3nF9B5hY7WlW0zgufFUeiMJsV4kSkEN2dCtSRL+7Pvdt2P8rkmHEGC1JZYv8DlwBMYTtGqMg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB9648.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(376002)(39860400002)(396003)(366004)(451199018)(38070700005)(86362001)(33656002)(41300700001)(8936002)(55016003)(5660300002)(4326008)(8676002)(64756008)(66476007)(66946007)(44832011)(66556008)(66446008)(122000001)(38100700002)(2906002)(478600001)(52536014)(316002)(76116006)(7696005)(110136005)(83380400001)(71200400001)(9686003)(186003)(6506007)(53546011)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U3Z0Q1VMSjY3RDVNS0M1M0h1WmFTV3pOTUEvTldQeUoraldDZ3ZoTlNVR1Vv?=
 =?utf-8?B?WGRLTTFoZk9UYk9TSDhaWmdUOTVSTmIrUElZOHRnWWJJZjNObytHSTJBSTlO?=
 =?utf-8?B?dVhXdWd3dkRUcDN4ME1meFdLdXJXQ0o3MGIwREZMalVnMElRMGpnSnJFNlB5?=
 =?utf-8?B?aUVZdHhMN0RmSzBKUDVOVDAzaXRwQkdyMXFwRFpmUHpHaUwrdjViVG9HY0Uz?=
 =?utf-8?B?WkR0RzVMQSsyMEwvdHRVcUdhYW9SSWtoSzJvRjZmdlNRM0kyVGE2M3Zhdk9w?=
 =?utf-8?B?T2ZoL3NMZGZNNDJ0TDFxbkx6QjJyS01NdGZEaDY3WnhLVWJGRUZHWDIrQWVE?=
 =?utf-8?B?c2xSMlNzMlJLRFhsRTVobmo2eGhUWUY5SmZEbDhkekVVNTR1ZURmMGpHZlhr?=
 =?utf-8?B?VCtzM1UyVjVqekJXYlNLUmdDYnVCdTFIem90Vjg3WGNqMTFJZDhZU1JVU0d0?=
 =?utf-8?B?UUlGbVV1K1E3T1A1ZU45MEd4UllpMkJrOENaRUNTQmtWTDJtSDJDdzh1SGJY?=
 =?utf-8?B?NGVteUlTMVM5REtueW1EdFE3dzlHUWNub2xVR3JVSWZackpQdWc3OWlOaldW?=
 =?utf-8?B?bStabDhyT0NOdWpuOHVWQWRMS1Roc2tVREZmU25zdnRQT2ZxWDQwcDZDdlFa?=
 =?utf-8?B?UEtLTFZYaEtKc1h3MndjS2xYWmxybkJsSzhEaGxxb24xU2RZdGRPM2hvbk0w?=
 =?utf-8?B?QTgyRDJNSVQ0cUJESmxxUkU3NWZCT3FnSmdZeC9WTlZTZmpDQVJYQkNRM0Nn?=
 =?utf-8?B?OTVzRDlGZHhMbHRwU1Z0VkR3bGFLTGswbXZIdkJHblErSkY2NFlPUXREdUlR?=
 =?utf-8?B?UVE5WjJUd1lwMHNHOUJOOVdycWJCZGhTUnZmSjQ1Y21QKy9sbTE0ZmlaR2J4?=
 =?utf-8?B?Mit4enduamkySVlKNVFHTWZTbkRSdjZVRUpWZ0VGb1lWalNMK3k3MkZ4ck5D?=
 =?utf-8?B?OWtLWjk3R2RPVHhvUkROQWJNQkdWY3haQVZRMStFcTB3V3gvdUdkUCtQZjlK?=
 =?utf-8?B?VGUzZ3lLL21rVE1hN2xQci96Smp0cjYzSU1IQVRCVkNJVXBKSFl6RDlWUGFx?=
 =?utf-8?B?N252UFhzQjlPSFgyK1pOK1RLdWFScFJOb202WTZHcW5oU3JWTkQxTFBaUHVj?=
 =?utf-8?B?RVB2cTh3MFowZ2JiTWRid1RUSWRyaGNTTytyeHZ0bVVOSVdwUTVtSnhJSjNv?=
 =?utf-8?B?bFJwamNCcnd3OUxGMjlkRldPeUQrenliSDdJWFIvcVFuL1FaaFRoM3Y3UTkv?=
 =?utf-8?B?VnlvNnVGQWlNa3pOK2xJUjhKanF4bDFVUE1idjYvMHYwbnRaSmNqVmlrK1Bl?=
 =?utf-8?B?MkdwelpSSU9Yb1FXcVlodXd0WXpNZXhZYjJpdEpjVHpoTHJObzVGZ0RrZG5S?=
 =?utf-8?B?a1hDVnFOb2pRaE1rMHhRZXRwd0drZFVyd3A0VFQxQ2JKbnhQTHFuZXdKM24w?=
 =?utf-8?B?anc4MTlFTVB2a3lOQnBLRkEweUVFSFdPSFIvVkhmb2M3SmdIRlQ5Snk4UUVn?=
 =?utf-8?B?b1ZpajRkVzFxTFFubWxJMFNjZUdGUVI5NU1TTTlBelVwTlVWdUg4WFhpQmpi?=
 =?utf-8?B?U0ZOUVFvUFA3c0QwN0krMmYzNVVMQ2pHWUI4Q0Y2VU9xY3ByTUE3SVduaUEz?=
 =?utf-8?B?blVua3k3bGtiSkd6WkFXWEFHQWw1eVhKNWhLSWtGZm0xVENpVGRhRkVKeVFC?=
 =?utf-8?B?S0hsMzU1bkh6MFhnZG5JUW01eXFub0xXMFVuMWpmTXZYWDIyR0YwRFdGaEpt?=
 =?utf-8?B?VkZBTjRTcUw0aGtLbEFndTliR2pHU2phRUhRRkJGdjAreC9ncnp5SVlheGpD?=
 =?utf-8?B?Y3pvWHNvcmFYRkhOM2N5Sko5cU16ZjFYNzVoNGQ3VmxieVlhenlEdEljK090?=
 =?utf-8?B?U012NUJQNUtGQkxwSWtHWFFVb2ptSE5UNzNCVFdVN1lqUG1lODcyQzJDM0lT?=
 =?utf-8?B?TWYwWjJRTGRQejlsMTFhUXR6Zm9UdkhzT3M0M3JUT0pUTXZ2QUFvRHNKYmh5?=
 =?utf-8?B?R2EzUjhoQ1VxVmt1NWE0R1ZodEdjU29MY2x0NnB4a3I0RjQ5OUFvYklpSFUz?=
 =?utf-8?B?NHExOVlqayswVDNhSmUyTVppOS9WeXlVOEhLMnl2c3pTVWlqQkhKTS81NXFl?=
 =?utf-8?Q?ZuJ3J4RpCiWZ2ggtUMOjA3b1P?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB9648.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ffe287d-7ef7-4908-8add-08db1bcd1f14
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Mar 2023 09:53:20.6274
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NOwfW6HgnV88YR9VOQWcdY5LH+dC3MlpeLBg+qTzrQbntgNAblUCywqLewlDLedycwUp44+BLKNF9IirwXKY3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR04MB9743
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgUGFvbG8sDQogSSB1cGRhdGVkIHRoZSBwYXRjaCB3aXRoIG5mX3Jlc2V0X2N0IGNoYW5nZSAo
bmZfcmVzZXQoKSByZXBsYWNlZCB3aXRoIG5mX3Jlc2V0X2N0KSB0byBhbGlnbiB3aXRoIHRoZSBs
YXRlc3Qga2VybmVsIGNvZGUuIA0KDQpIaSBBbGwsDQpJIGFsc28gd2FudCB0byBwdXNoIHRoaXMg
Y2hhbmdlICh3aXRoIG5mX3Jlc2V0KSBpbiA0LjE5IExUUyBrZXJuZWwsIHBsZWFzZSBjYW4geW91
IHRlbGwgbWUgaG93IGNhbiBJIHB1c2ggdG8gdGhhdCB2ZXJzaW9uPyBUaGFua3MgaW4gYWR2YW5j
ZS4NCg0KIEhpIEZsb3JpYW4sDQpJbiBwYXRjaHYzIHVwZGF0ZWQgdGhlIHN1YmplY3QgbGluZSBh
cyB5b3Ugc3VnZ2VzdGVkLg0KDQpUaGFua3MgJiBSZWdhcmRzLA0KTWFkaHUgSyAgDQoNCi0tLS0t
T3JpZ2luYWwgTWVzc2FnZS0tLS0tDQpGcm9tOiBQYW9sbyBBYmVuaSA8cGFiZW5pQHJlZGhhdC5j
b20+IA0KU2VudDogVGh1cnNkYXksIE1hcmNoIDIsIDIwMjMgNzo1OCBQTQ0KVG86IE1hZGh1IEtv
cmlnaW5qYSA8bWFkaHUua29yaWdpbmphQG54cC5jb20+OyBnZXJyaXRAZXJnLmFiZG4uYWMudWs7
IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGt1em5ldEBtczIuaW5yLmFjLnJ1OyB5b3NoZnVqaUBsaW51
eC1pcHY2Lm9yZzsgZWR1bWF6ZXRAZ29vZ2xlLmNvbTsgZGNjcEB2Z2VyLmtlcm5lbC5vcmc7IG5l
dGRldkB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNCkNjOiBW
YW5pIE5hbWFsYSA8dmFuaS5uYW1hbGFAbnhwLmNvbT4NClN1YmplY3Q6IFtFWFRdIFJlOiBbUEFU
Q0hdIFtuZXQ6bmV0ZmlsdGVyXTogS2VlcCBjb25udHJhY2sgcmVmZXJlbmNlIHVudGlsIElQc2Vj
djYgcG9saWN5IGNoZWNrcyBhcmUgZG9uZQ0KDQpDYXV0aW9uOiBFWFQgRW1haWwNCg0KT24gVGh1
LCAyMDIzLTAzLTAyIGF0IDE2OjUzICswNTMwLCBNYWRodSBLb3JpZ2luamEgd3JvdGU6DQo+IEtl
ZXAgdGhlIGNvbm50cmFjayByZWZlcmVuY2UgdW50aWwgcG9saWN5IGNoZWNrcyBoYXZlIGJlZW4g
cGVyZm9ybWVkIA0KPiBmb3IgSVBzZWMgVjYgTkFUIHN1cHBvcnQuIFRoZSByZWZlcmVuY2UgbmVl
ZHMgdG8gYmUgZHJvcHBlZCBiZWZvcmUgYSANCj4gcGFja2V0IGlzIHF1ZXVlZCB0byBhdm9pZCBo
YXZpbmcgdGhlIGNvbm50cmFjayBtb2R1bGUgdW5sb2FkYWJsZS4NCj4NCj4gU2lnbmVkLW9mZi1i
eTogTWFkaHUgS29yaWdpbmphIDxtYWRodS5rb3JpZ2luamFAbnhwLmNvbT4NCj4gICAgICAgVjEt
VjI6IGFkZGVkIG1pc3NpbmcgKCkgaW4gaXA2X2lucHV0LmMgaW4gYmVsb3cgY29uZGl0aW9uDQo+
ICAgICAgIGlmICghKGlwcHJvdC0+ZmxhZ3MgJiBJTkVUNl9QUk9UT19OT1BPTElDWSkpDQo+IC0t
LQ0KPiAgbmV0L2RjY3AvaXB2Ni5jICAgICAgfCAgMSArDQo+ICBuZXQvaXB2Ni9pcDZfaW5wdXQu
YyB8IDE0ICsrKysrKystLS0tLS0tDQo+ICBuZXQvaXB2Ni9yYXcuYyAgICAgICB8ICAyICstDQo+
ICBuZXQvaXB2Ni90Y3BfaXB2Ni5jICB8ICAyICsrDQo+ICBuZXQvaXB2Ni91ZHAuYyAgICAgICB8
ICAyICsrDQo+ICA1IGZpbGVzIGNoYW5nZWQsIDEzIGluc2VydGlvbnMoKyksIDggZGVsZXRpb25z
KC0pDQo+DQo+IGRpZmYgLS1naXQgYS9uZXQvZGNjcC9pcHY2LmMgYi9uZXQvZGNjcC9pcHY2LmMg
aW5kZXggDQo+IDU4YTQwMWU5Y2YwOS4uZWI1MDMwOTZkYjZjIDEwMDY0NA0KPiAtLS0gYS9uZXQv
ZGNjcC9pcHY2LmMNCj4gKysrIGIvbmV0L2RjY3AvaXB2Ni5jDQo+IEBAIC03NzEsNiArNzcxLDcg
QEAgc3RhdGljIGludCBkY2NwX3Y2X3JjdihzdHJ1Y3Qgc2tfYnVmZiAqc2tiKQ0KPg0KPiAgICAg
ICBpZiAoIXhmcm02X3BvbGljeV9jaGVjayhzaywgWEZSTV9QT0xJQ1lfSU4sIHNrYikpDQo+ICAg
ICAgICAgICAgICAgZ290byBkaXNjYXJkX2FuZF9yZWxzZTsNCj4gKyAgICAgbmZfcmVzZXQoc2ti
KTsNCg0KbmZfcmVzZXQoKSBpcyBnb25lIHNpbmNlIGNvbW1pdCA4OTViNWM5ZjIwNmUgKCJuZXRm
aWx0ZXI6IGRyb3AgYnJpZGdlIG5mIHJlc2V0IGZyb20gbmZfcmVzZXQiKSwgeW91IHNob3VsZCB1
c2UgaW5zdGVhZCBuZl9yZXNldF9jdCgpOiBpbiB0aGUgY3VycmVudCBmb3JtIHRoZSBwYXRjaCBk
b2VzIG5vdCBhcHBseSBjbGVhbmx5IChub3IgYnVpbGQgYWZ0ZXIgbWFudWFsIGVkaXQpLg0KDQoN
CkNoZWVycywNCg0KUGFvbG8NCg0K
