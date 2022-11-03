Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ACFE617ECC
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 15:03:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231450AbiKCODt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 10:03:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231650AbiKCODV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 10:03:21 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F7ED1788C;
        Thu,  3 Nov 2022 07:02:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1667484179; x=1699020179;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Q8pa2VJwYQhVebG+Mm+uYlVI6azvzeeUfLnrwxety58=;
  b=SJIcl78wkXP6xwRC9DBGevaBUl+E05QdsZLFUmb/2UFlKBm6SwTSlbZz
   h2gM5LWsaswwmvfI8ZQvOIxAX21KBWM2y4UDHkQ8QU67PhW/945248Pij
   Bwhiy6eK7ITyqHXTrGIXzcaGjqEXhr4kWOjJ18hNfafBE8VVjwqilkmRL
   zUU3DCIhgXM69PBqdBUzRaWOc+vFSHQtM3L2M84eW73Ef1GcK4HVF4zyt
   q5vF+t6hyOxFQTuiMf/284xjnrNPK1/Zh0ALkWj73o3tXDJcMMqI1zVA6
   NFXr4jiWnMsWJvWgdayIowms+KR51QOgr6RLUqKb6tal9SQrhE3CADi05
   A==;
X-IronPort-AV: E=Sophos;i="5.96,235,1665471600"; 
   d="scan'208";a="185212833"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 03 Nov 2022 07:02:56 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Thu, 3 Nov 2022 07:02:55 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12 via Frontend Transport; Thu, 3 Nov 2022 07:02:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EkCrFLuuHpHxw9QpE/oRjvmYk934/BwBI7zEY+qP2tB2MuZqeiDvru5YKnPbsm0XRd9mZrY0+CNaIJg1NeOt2QOSvgQh4RhbDoI74gYJIjopKxZvA7mdfY/5pJWYd+Jb1hziVS+PzZHdCaEtrefnd6Dxgu9tA4/8oftPL2A5+MvFNUrlU/UnKk1PMCNPywdgSqd6Ah1rlUHVvYtXpmgGI/vkXBC6XOwKuefCyC8YTv2LTcLoeMbA7bgknmTARIjYC1AIMwW2/MMrBYnOHLjX1Bqu/GFe9UpffDV8y5HGdLnLN9gUm92i6XIJE1RhxBSvX4uzPBvXEjhyuLE9g1P/0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q8pa2VJwYQhVebG+Mm+uYlVI6azvzeeUfLnrwxety58=;
 b=FlDkGby2zdqOvUrLOpDBZi3b7JCaDeZnnWvAdDyg+h0/H5z48dDLqYj5DMmt3XcZkCMYPAXr7XeHqFiKaHtuoCt9WNYsVn73kwyAoiNDZn763mR30XxuAgk3osVI9Mn2ZC+4jVf+yiAkwgxi0pMg8VC44zmYwakNxHfMj0aSYs+HdYAQV7Dm5U1dpsHa0xVKL/dpAr4peGYiX22fQpIibyNu0obnqFZGks7ZtGDC5ff0auwcMK2fbxijH9wpL6Qd5bvGbmQnztbFdl7fn7vwkJme6VWJ/FmWGkZzA677p7LZjv4fujEpBPWgq0r5DPtUA3FSwXb0ff0b13V+UZF/Tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q8pa2VJwYQhVebG+Mm+uYlVI6azvzeeUfLnrwxety58=;
 b=e7Qfw7by5B0+5BISzv41f/eBlrHkFXMZrQodomonFbkV8otitMWh43WvdZziZlijgcHPOnWPdST7ZsbRXn6JLEh7IEr+Q2Naqip3vux3Lz387t+V5huFQEDodgdHY5J566jHiVYpoFegr0GN+3BLcaLntjIuzrmxvgDnfHli9ig=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 MW4PR11MB5910.namprd11.prod.outlook.com (2603:10b6:303:189::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.22; Thu, 3 Nov 2022 14:02:51 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::faca:fe8a:e6fa:2d7]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::faca:fe8a:e6fa:2d7%3]) with mapi id 15.20.5769.021; Thu, 3 Nov 2022
 14:02:51 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <olteanv@gmail.com>, <UNGLinuxDriver@microchip.com>,
        <vivien.didelot@gmail.com>, <andrew@lunn.ch>,
        <f.fainelli@gmail.com>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <o.rempel@pengutronix.de>,
        <Woojung.Huh@microchip.com>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel@pengutronix.de>
Subject: Re: [PATCH net-next v1 1/1] net: dsa: microchip: ksz8: add MTU
 configuration support
Thread-Topic: [PATCH net-next v1 1/1] net: dsa: microchip: ksz8: add MTU
 configuration support
Thread-Index: AQHY72SbCiN+lKAXEE+6MQXpjnQDXq4tBz0AgAAz44A=
Date:   Thu, 3 Nov 2022 14:02:51 +0000
Message-ID: <ab2d4cd5ec4b74d7d2f59e4208dfedcb36e13882.camel@microchip.com>
References: <20221103091302.1693161-1-o.rempel@pengutronix.de>
         <0da58722ba9e451b984f8c10bb3bb04b2725d6a2.camel@microchip.com>
In-Reply-To: <0da58722ba9e451b984f8c10bb3bb04b2725d6a2.camel@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB0076:EE_|MW4PR11MB5910:EE_
x-ms-office365-filtering-correlation-id: 7d5e53df-6acf-482c-9756-08dabda418de
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OGFlwL/i3FXWFQ6mrIgo8lgJ5N3brLP1xHRlWVQxrk58gIkyW/zjXvwFJ70jVm4RGD0Sv+2EtFklCyDTFr6U8Kbo9qfXkSwXQgeKq0Zifs193KHUytovuxM2zfJANs2Sog1DiQ7Rro9YbOeoMvl1Tygd3zT6mDqXRwVZz+LiHPwU29xmCykHPd3AgqCVY7B8AnUPM8m7d4PepHAYyQDESbW/dfDHOMIPVAm4/Si5aA4uEnDRggKynqNOk1XW5jds/q0KSyjddrYneWab8u5/1/XFN9clnBQ+gh/F0yL8K/EiKAJE5FbLC7FOW1IqGTKVFZ4W7j83uJJAwNRpyNdTbSwXwTQ/sPgAM3KpSzkw8MHBSH1uDJhOR4+c+V1aQaV97OwsRjh99LRT4ePnybRufNyu4sRd/ayXniSh7y0SY/Iz3ee1AnLuQ8iO3GBHrN0Q1gcQiXnrrkyts7vEvy8TwHUgJCNMzDpKY9fJoOFB1rMfdapJ1++BDXLOHnxxmf4pW17YvUR4fIBlFFyJIPhYsBkIJAgzmZAoD8UjqgAVEIjJHEdgSoh7BVI6/zWtKY8xsTgDq1oKjt78yBqYPBIqjt4EK5LAmMoqrWoAWo5v+SqAZ7nBO2pXNtHym60NmDU85n7dYPv/VG+haWUGXTbHEZwrfPcDBC8AOvqMNwRtT/IwOq1d5nLt/X7+zreDMNsLKkPAE2Th05c3PzFx0Ee18Cv8EuuAdHBWiMZ7Fce97RdGv2QDCyxvtpt+wgl8B0GiaJmAJGqRyHmCs82aM8w1ZLsfN1K/FBqTfeo6hNu3DbbAGqHgjKE1vYCxEwpGXcpG
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(376002)(39860400002)(136003)(396003)(346002)(451199015)(2906002)(36756003)(122000001)(8936002)(41300700001)(5660300002)(7416002)(8676002)(64756008)(66556008)(66476007)(66446008)(66946007)(38100700002)(91956017)(76116006)(4326008)(316002)(54906003)(110136005)(71200400001)(38070700005)(83380400001)(921005)(478600001)(186003)(6512007)(6506007)(6486002)(86362001)(2616005)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UlN0cTIxWlM1amFKSzhZL2I0ZFJMWHRKVm1rajdxSWNBaGgvVzRza3FXZkp6?=
 =?utf-8?B?VDF1K2svVVFRejhPNFhWeWRnZnJxd0MwQ2VacTYzNWNZN3plWkNlTllJTVRU?=
 =?utf-8?B?bFlYWkxWTERtZjNNeER2MHhSeWJuanBwUjV6b1FwanBwSlIxSlVNM09jalRt?=
 =?utf-8?B?cExaYThTbCtUUXM0V3VaaEhHcWp0dldzOXdENm9tQjFkVmRiSkNMa2VVZnMy?=
 =?utf-8?B?VGdWanJXeFVRMk5NRnAra1RvOHNidEZaekd3MTgvZFJtSzJLQzIxb0xRSHdK?=
 =?utf-8?B?eG1BTjdIa2ZSZ2JIYm10N2krR0ZKQmdRb25aMENRUXk3RTBRZXcza0RaT2E2?=
 =?utf-8?B?cVc2Q1BodkFETU9kMnRyQy9VczlnTlpzUldTSndtZ3hOczc5aEE4RElMcXVQ?=
 =?utf-8?B?TW1zbngxQlJkWkJRZmdycWFaT2s1bXJqdFc3YmZwZDc0a0c5R0dwdHFhRnAw?=
 =?utf-8?B?M0VKaUZheC9Ha0QzTW9SQ0s5ZUVma3A2QW9lMWNld2llQ05yZU1iL3E4R052?=
 =?utf-8?B?ZHFsd1EzdFJPblE3eG5FNE5PQmJESUVyUEUvdUFqTVFaSlJnQmYrQ3pKVzBK?=
 =?utf-8?B?TC80TE4zdzBlbHN3ZG5zU3gydDBUZ0doVmJpT0ZEcDJtSXE2TnNTcmNQZXAw?=
 =?utf-8?B?OEF3MG13WDR5OTBJbUwzV1hLQUFRMWllYkFsK1EzYjhvQ3RrbDVkS21uQ3ky?=
 =?utf-8?B?LzVrUXlvOUwzcVl3T3o3STdtV21QeVp2d2ZCTFcxYi90MnI0NmZkNzFCaXpQ?=
 =?utf-8?B?Um5XWFkyalZWcGpySXJZVitXcm92T0U2dmhXa1o0MUc3K3ZyU2lBMlBrQmZj?=
 =?utf-8?B?WjNvZFA2SVd2d0F2Rit1K2JTWktRN1FUYndlWnhpZzkrQk1WNDJDSzN1V2xU?=
 =?utf-8?B?OUZqaTR5aG91RWx2YkZSMGNDM2QxMVlDOVBURitHRy9Yc3ZBVUxzUUlzaUI2?=
 =?utf-8?B?YVdSWDhDZmZnRTRnM25wMXhvcVg3T1ZjNHRUNStMdkNDc1lHbzI2cG9GSmg1?=
 =?utf-8?B?K3hQNWZpNzFUVFhnZlU3am1Dc3M5UXBvL3FIVjJtelJucGl2UytLT0U5VlYv?=
 =?utf-8?B?L1RKZVBkb3d3OUVtbmlvYVY3OHIxaVh2b0N6RFBNSUZLYVBmaktBN2dlaTJl?=
 =?utf-8?B?cFBBcEJYcEcrYzN1V3BCcjMwcEgyaWhlT0o3Q0R2bnlOaTVvNnpVK1U3UllI?=
 =?utf-8?B?djVOWVhnci9oZnNmL29oeE11OVlRd0VreEthN2x3ZkNFRDcya0pXRk0rSExl?=
 =?utf-8?B?TWV4RnNhTDdubDhwUkdweFlvSUhLRU4xQmx5RDllV2VqazhwcE15S3Azdmh6?=
 =?utf-8?B?K3VrUjFzOWVocC9PMUt1UEY3MUJkK0tOKzNLblE3VFBYYnI1djFOK1gzTldh?=
 =?utf-8?B?ZXRsMzJJS0l5cE1MUThBaUxLREhINTF0elRyZzlFUzRYai9nN3NsVW11ZE5L?=
 =?utf-8?B?VzYwYnJlK1REY3FydGJuS1lQazQ0MGRQZjRHMHBMRkJBS0FWay94TnhFUERJ?=
 =?utf-8?B?VnFnczR4UG0zS090SXcvOTI5Q3RMdXo4ZFZOd1VmWHRpRURQVlZOS2RFU096?=
 =?utf-8?B?VjdZRTk4QmJacjlYTGJTNHBzc3VqZk9uVjJhd0p4ekdqMEI2clQ1cnZ5bkhk?=
 =?utf-8?B?RTdQbk5haFlIU0lTR3FzMEtDV29pbWhqOU1yelo5TC9MNzA4WXYzc3c5c2tw?=
 =?utf-8?B?OGhUV1BHbzNtMlRFWlJmNnc4MWxmT0JuUHlRVm4vU0RRdlVXOWtheE5kcnhp?=
 =?utf-8?B?b0pqb21DS0dKWmhuVS8zT01UMEN5NG1tbVh3OU9wM1FPM1NxZUlKalJqeDZa?=
 =?utf-8?B?ZWh2bWdhSlY2d3d1Y1Bra0pmSmZlcy9iWmpGTnROazBuY2dIb0RjclF4azg1?=
 =?utf-8?B?UUFkNjhUanhDcXVLSFQyY3BVcUhjSkFqWDErZTZKN0hwRVE4Z2VTb0NTTFZG?=
 =?utf-8?B?SFRETWY3bC9kT05TY3V3RktxZjBiZlRya2x6SDlidjZKanZpMkhSVmI1Vngv?=
 =?utf-8?B?QlQ5QkU1VStxZzF4M2EvMzJOU0F6WTVnNDdqWW9wMDhGamNudUJ5aWh2NGw4?=
 =?utf-8?B?cHU5cm0zbC9rOHMwb05adElCOVdFLzVab01HaDZHNDRtVkxYeUhiN0l2cHMz?=
 =?utf-8?B?ejYveHJUZ3FDOTRLWGRPQXdVcllFMFdDVktObVBiN280blRqcmZSbjhrN3h5?=
 =?utf-8?B?MFQ5OWFleGh5MC9pdzVEalQ4KzB1b0EveE5kU0xNcDVhSmVJMlBqczIvQ0dC?=
 =?utf-8?Q?T8zzRE4bbn68UDL5+dVZuL59wvkonQrg89f9QHVanQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <84DB4E33A7FB3C4B8A16BBD033CEC19C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d5e53df-6acf-482c-9756-08dabda418de
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2022 14:02:51.5248
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1VB59tG6fSbGs4i5A3CJKmK/XvPVw7yV2Hz0fW7p8eMO5abC7SH1yXgwyjXtRd8VAFX1eWT/68DcIU6DoPAylQdMHTyZD76EDwpOr2WHeLo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5910
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIyLTExLTAzIGF0IDEwOjU3ICswMDAwLCBBcnVuIFJhbWFkb3NzIC0gSTE3NzY5
IHdyb3RlOg0KPiBIaSBPbGVrc2lqLA0KPiANCj4gT24gVGh1LCAyMDIyLTExLTAzIGF0IDEwOjEz
ICswMTAwLCBPbGVrc2lqIFJlbXBlbCB3cm90ZToNCj4gPiBFWFRFUk5BTCBFTUFJTDogRG8gbm90
IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNzIHlvdQ0KPiA+IGtub3cgdGhl
IGNvbnRlbnQgaXMgc2FmZQ0KPiA+IA0KPiA+IE1ha2UgTVRVIGNvbmZpZ3VyYWJsZSBvbiBLU1o4
N3h4IGFuZCBLU1o4OHh4IHNlcmllcyBvZiBzd2l0Y2hlcy4NCj4gPiANCj4gPiBCZWZvcmUgdGhp
cyBwYXRjaCwgcHJlLWNvbmZpZ3VyZWQgYmVoYXZpb3Igd2FzIGRpZmZlcmVudCBvbg0KPiA+IGRp
ZmZlcmVudA0KPiA+IHN3aXRjaCBzZXJpZXMsIGR1ZSB0byBvcHBvc2l0ZSBtZWFuaW5nIG9mIHRo
ZSBzYW1lIGJpdDoNCj4gPiAtIEtTWjg3eHg6IFJlZyA0LCBCaXQgMSAtIGlmIDEsIG1heCBmcmFt
ZSBzaXplIGlzIDE1MzI7IGlmIDAgLSAxNTE0DQo+ID4gLSBLU1o4OHh4OiBSZWcgNCwgQml0IDEg
LSBpZiAxLCBtYXggZnJhbWUgc2l6ZSBpcyAxNTE0OyBpZiAwIC0gMTUzMg0KPiA+IA0KPiA+IFNp
bmNlIHRoZSBjb2RlIHdhcyB0ZWxsaW5nICIuLi4gU1dfTEVHQUxfUEFDS0VUX0RJU0FCTEUsIHRy
dWUpIiwgSQ0KPiA+IGFzc3VtZSwgdGhlIGlkZWEgd2FzIHRvIHNldCBtYXggZnJhbWUgc2l6ZSB0
byAxNTMyLg0KPiA+IA0KPiA+IFdpdGggdGhpcyBwYXRjaCwgYnkgc2V0dGluZyBNVFUgc2l6ZSAx
NTAwLCBib3RoIHN3aXRjaCBzZXJpZXMgd2lsbA0KPiA+IGJlDQo+ID4gY29uZmlndXJlZCB0byB0
aGUgMTUzMiBmcmFtZSBsaW1pdC4NCj4gPiANCj4gPiBUaGlzIHBhdGNoIHdhcyB0ZXN0ZWQgb24g
S1NaODg3My4NCj4gPiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBPbGVrc2lqIFJlbXBlbCA8by5yZW1w
ZWxAcGVuZ3V0cm9uaXguZGU+DQo+ID4gLS0tDQo+ID4gIGRyaXZlcnMvbmV0L2RzYS9taWNyb2No
aXAva3N6OC5oICAgICAgICB8ICAyICsNCj4gPiAgZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9r
c3o4Nzk1LmMgICAgIHwgNzQNCj4gPiArKysrKysrKysrKysrKysrKysrKysrKystDQo+ID4gIGRy
aXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6ODc5NV9yZWcuaCB8ICA5ICsrKw0KPiA+ICBkcml2
ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzel9jb21tb24uYyAgfCAgMiArDQo+ID4gIDQgZmlsZXMg
Y2hhbmdlZCwgODUgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4gPiANCj4gPiBkaWZm
IC0tZ2l0IGEvZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3o4LmgNCj4gPiBiL2RyaXZlcnMv
bmV0L2RzYS9taWNyb2NoaXAva3N6OC5oDQo+ID4gaW5kZXggODU4MmI0YjY3ZDk4Li4wMjdiOTJm
NWZhNzMgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3o4LmgN
Cj4gPiArKysgYi9kcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzejguaA0KPiA+IEBAIC01Nyw1
ICs1Nyw3IEBAIGludCBrc3o4X3Jlc2V0X3N3aXRjaChzdHJ1Y3Qga3N6X2RldmljZSAqZGV2KTsN
Cj4gPiAgaW50IGtzejhfc3dpdGNoX2RldGVjdChzdHJ1Y3Qga3N6X2RldmljZSAqZGV2KTsNCj4g
PiAgaW50IGtzejhfc3dpdGNoX2luaXQoc3RydWN0IGtzel9kZXZpY2UgKmRldik7DQo+ID4gIHZv
aWQga3N6OF9zd2l0Y2hfZXhpdChzdHJ1Y3Qga3N6X2RldmljZSAqZGV2KTsNCj4gPiAraW50IGtz
ejhfY2hhbmdlX210dShzdHJ1Y3Qga3N6X2RldmljZSAqZGV2LCBpbnQgcG9ydCwgaW50IG10dSk7
DQo+ID4gK2ludCBrc3o4X21heF9tdHUoc3RydWN0IGtzel9kZXZpY2UgKmRldiwgaW50IHBvcnQp
Ow0KPiA+IA0KPiA+ICAjZW5kaWYNCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZHNhL21p
Y3JvY2hpcC9rc3o4Nzk1LmMNCj4gPiBiL2RyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6ODc5
NS5jDQo+ID4gaW5kZXggYmQzYjEzM2U3MDg1Li5mZDI1MzlhYWJiMmMgMTAwNjQ0DQo+ID4gLS0t
IGEvZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3o4Nzk1LmMNCj4gPiArKysgYi9kcml2ZXJz
L25ldC9kc2EvbWljcm9jaGlwL2tzejg3OTUuYw0KPiA+IEBAIC03Niw2ICs3Niw3OCBAQCBpbnQg
a3N6OF9yZXNldF9zd2l0Y2goc3RydWN0IGtzel9kZXZpY2UgKmRldikNCj4gPiAgICAgICAgIHJl
dHVybiAwOw0KPiA+ICB9DQo+ID4gDQo+ID4gK3N0YXRpYyBpbnQga3N6ODg2M19jaGFuZ2VfbXR1
KHN0cnVjdCBrc3pfZGV2aWNlICpkZXYsIGludCBwb3J0LA0KPiA+IGludA0KPiA+IG1heF9mcmFt
ZSkNCj4gPiArew0KPiA+ICsgICAgICAgdTggY3RybDIgPSAwOw0KPiA+ICsNCj4gPiArICAgICAg
IGlmIChtYXhfZnJhbWUgPD0gS1NaODg2M19MRUdBTF9QQUNLRVRfU0laRSkNCj4gPiArICAgICAg
ICAgICAgICAgY3RybDIgfD0gS1NaODg2M19MRUdBTF9QQUNLRVRfRU5BQkxFOw0KPiA+ICsgICAg
ICAgZWxzZSBpZiAobWF4X2ZyYW1lID4gS1NaODg2M19OT1JNQUxfUEFDS0VUX1NJWkUpDQo+ID4g
KyAgICAgICAgICAgICAgIGN0cmwyIHw9IEtTWjg4NjNfSFVHRV9QQUNLRVRfRU5BQkxFOw0KPiA+
ICsNCj4gPiArICAgICAgIHJldHVybiByZWdtYXBfdXBkYXRlX2JpdHMoZGV2LT5yZWdtYXBbMF0s
IFJFR19TV19DVFJMXzIsDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIEtT
Wjg4NjNfTEVHQUxfUEFDS0VUX0VOQUJMRQ0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICB8IEtTWjg4NjNfSFVHRV9QQUNLRVRfRU5BQkxFLA0KPiA+IGN0cmwyKTsNCj4gPiAr
fQ0KPiANCj4gU3VnZ2VzdGlvbjoNCj4gcmVnbWFwX3VwZGF0ZV9iaXRzLCBjYW4geW91IGNyZWF0
ZSBhIG1hY3JvIGxpa2Uga3N6X3Jtdzggc2ltaWxhciB0bw0KPiB3aGF0IHdlIGhhdmUga3N6X3By
bXc4IGluIGtzel9jb21tb24uaC4gU28gdGhhdCBpdCBjYW4gdXNlZCBhY3Jvc3MNCj4gdGhlDQo+
IGtzeiBhbmQgbGFuOTM3eCBzd2l0Y2hlcy4NCj4gDQo+ID4gKw0KPiA+ICtzdGF0aWMgaW50IGtz
ejg3OTVfY2hhbmdlX210dShzdHJ1Y3Qga3N6X2RldmljZSAqZGV2LCBpbnQgcG9ydCwNCj4gPiBp
bnQNCj4gPiBtYXhfZnJhbWUpDQo+ID4gK3sNCj4gPiArICAgICAgIHU4IGN0cmwxID0gMCwgY3Ry
bDIgPSAwOw0KPiA+ICsgICAgICAgaW50IHJldDsNCj4gPiArDQo+ID4gKyAgICAgICBpZiAobWF4
X2ZyYW1lID4gS1NaODg2M19MRUdBTF9QQUNLRVRfU0laRSkNCj4gPiArICAgICAgICAgICAgICAg
Y3RybDIgfD0gU1dfTEVHQUxfUEFDS0VUX0RJU0FCTEU7DQo+ID4gKyAgICAgICBlbHNlIGlmICht
YXhfZnJhbWUgPiBLU1o4ODYzX05PUk1BTF9QQUNLRVRfU0laRSkNCj4gPiArICAgICAgICAgICAg
ICAgY3RybDEgfD0gU1dfSFVHRV9QQUNLRVQ7DQo+ID4gKw0KPiA+ICsgICAgICAgcmV0ID0gcmVn
bWFwX3VwZGF0ZV9iaXRzKGRldi0+cmVnbWFwWzBdLCBSRUdfU1dfQ1RSTF8xLA0KPiA+ICsgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIFNXX0hVR0VfUEFDS0VULCBjdHJsMSk7DQo+ID4g
KyAgICAgICBpZiAocmV0KQ0KPiA+ICsgICAgICAgICAgICAgICByZXR1cm4gcmV0Ow0KPiA+ICsN
Cj4gPiArICAgICAgIHJldHVybiByZWdtYXBfdXBkYXRlX2JpdHMoZGV2LT5yZWdtYXBbMF0sIFJF
R19TV19DVFJMXzIsDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgU1dfTEVH
QUxfUEFDS0VUX0RJU0FCTEUsIGN0cmwyKTsNCj4gPiArfQ0KPiA+ICsNCj4gPiAraW50IGtzejhf
Y2hhbmdlX210dShzdHJ1Y3Qga3N6X2RldmljZSAqZGV2LCBpbnQgcG9ydCwgaW50IG10dSkNCj4g
PiArew0KPiA+ICsgICAgICAgdTE2IGZyYW1lX3NpemUsIG1heF9mcmFtZSA9IDA7DQo+ID4gKyAg
ICAgICBpbnQgaTsNCj4gPiArDQo+ID4gKyAgICAgICBmcmFtZV9zaXplID0gbXR1ICsgVkxBTl9F
VEhfSExFTiArIEVUSF9GQ1NfTEVOOw0KPiA+ICsNCj4gPiArICAgICAgIC8qIENhY2hlIHRoZSBw
ZXItcG9ydCBNVFUgc2V0dGluZyAqLw0KPiA+ICsgICAgICAgZGV2LT5wb3J0c1twb3J0XS5tYXhf
ZnJhbWUgPSBmcmFtZV9zaXplOw0KPiA+ICsNCj4gPiArICAgICAgIGZvciAoaSA9IDA7IGkgPCBk
ZXYtPmluZm8tPnBvcnRfY250OyBpKyspDQo+ID4gKyAgICAgICAgICAgICAgIG1heF9mcmFtZSA9
IG1heChtYXhfZnJhbWUsIGRldi0NCj4gPiA+cG9ydHNbaV0ubWF4X2ZyYW1lKTsNCj4gDQo+IFRo
aXMgcG9ydCBjYWNoaW5nIHNuaXBwZXQgaXMgcHJlc2VudCBpbiBrc3o5NDc3X2NoYW5nZV9tdHUg
ZnVuY3Rpb24NCj4gYWxzby4gSXQgY2FuIGJlIG1vdmVkIHRvIGtzel9jaGFuZ2VfbXR1IGFuZCBy
ZW1vdmUgaXQgaW4NCj4ga3N6OTQ3N19jaGFuZ2VfbXR1LiANCg0KSSBvdmVybG9va2VkIGNvZGUu
IENhY2hpbmcgcG9ydCBtYXggZnJhbWUgaXMgYXBwbGljYWJsZSBvbmx5IGtzejk0NzcNCm5vdCBm
b3IgbGFuOTM3eC4gSW4gbGFuOTM3eCBpdCBoYXMgcGVyIHBvcnQgbXR1IHNldHRpbmdzIHdoZXJl
IGtzeiBoYXMNCnN3aXRjaCB3aWRlIG10dSBzZWV0aW5nLg0KDQo+IA0KPiA+ICsNCj4gPiArICAg
ICAgIHN3aXRjaCAoZGV2LT5jaGlwX2lkKSB7DQo+ID4gKyAgICAgICBjYXNlIEtTWjg3OTVfQ0hJ
UF9JRDoNCj4gPiArICAgICAgIGNhc2UgS1NaODc5NF9DSElQX0lEOg0KPiA+ICsgICAgICAgY2Fz
ZSBLU1o4NzY1X0NISVBfSUQ6DQo+ID4gKyAgICAgICAgICAgICAgIHJldHVybiBrc3o4Nzk1X2No
YW5nZV9tdHUoZGV2LCBwb3J0LCBtYXhfZnJhbWUpOw0KPiA+ICsgICAgICAgY2FzZSBLU1o4ODMw
X0NISVBfSUQ6DQo+ID4gKyAgICAgICAgICAgICAgIHJldHVybiBrc3o4ODYzX2NoYW5nZV9tdHUo
ZGV2LCBwb3J0LCBtYXhfZnJhbWUpOw0KPiA+ICsgICAgICAgfQ0KPiA+ICsNCj4gPiArICAgICAg
IHJldHVybiAtRU9QTk9UU1VQUDsNCj4gPiArfQ0KPiA+ICsNCj4gPiAraW50IGtzejhfbWF4X210
dShzdHJ1Y3Qga3N6X2RldmljZSAqZGV2LCBpbnQgcG9ydCkNCj4gPiArew0KPiA+ICsgICAgICAg
c3dpdGNoIChkZXYtPmNoaXBfaWQpIHsNCj4gPiArICAgICAgIGNhc2UgS1NaODc5NV9DSElQX0lE
Og0KPiA+ICsgICAgICAgY2FzZSBLU1o4Nzk0X0NISVBfSUQ6DQo+ID4gKyAgICAgICBjYXNlIEtT
Wjg3NjVfQ0hJUF9JRDoNCj4gPiArICAgICAgICAgICAgICAgcmV0dXJuIEtTWjg3OTVfSFVHRV9Q
QUNLRVRfU0laRSAtIFZMQU5fRVRIX0hMRU4gLQ0KPiA+IEVUSF9GQ1NfTEVOOw0KPiA+ICsgICAg
ICAgY2FzZSBLU1o4ODMwX0NISVBfSUQ6DQo+ID4gKyAgICAgICAgICAgICAgIHJldHVybiBLU1o4
ODYzX0hVR0VfUEFDS0VUX1NJWkUgLSBWTEFOX0VUSF9ITEVOIC0NCj4gPiBFVEhfRkNTX0xFTjsN
Cj4gPiArICAgICAgIH0NCj4gPiArDQo+ID4gKyAgICAgICByZXR1cm4gLUVPUE5PVFNVUFA7DQo+
ID4gK30NCj4gPiArDQo+IA0KPiBJbnRpYWxseSBLU1o5NDc3IGhhZCB0aGUgbWF4X210dSB3aGlj
aCBJIHVzZWQgZm9yIHRoZSBMQU45Mzd4LiBTaW5jZQ0KPiB0aGVyZSBpcyBubyBtdWNoIHRoaW5n
IHRvIGRvIGluIHRoaXMgZnVuY3Rpb24sIHdoeSBjYW4ndCB3ZSBtb3ZlIGl0DQo+IGtzel9jb21t
b24uYyBhbmQgYWRkIGNoaXAgaWQgZm9yIGtzejkgYW5kIGxhbjkzN3ggJiByZW1vdmUNCj4ga3N6
OTQ3N19tYXhfbXR1LiBJdCB3aWxsIHJlZHVjZSB0aGUgbWF4X210dSBmdW5jdGlvaW4gcG9pbnRl
ciBpbg0KPiBrc3pfZGV2X29wcy4NCj4gDQo+ID4gDQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMv
bmV0L2RzYS9taWNyb2NoaXAva3N6X2NvbW1vbi5jDQo+ID4gYi9kcml2ZXJzL25ldC9kc2EvbWlj
cm9jaGlwL2tzel9jb21tb24uYw0KPiA+IGluZGV4IGQ2MTIxODFiMzIyNi4uNDBmZDc4OTUxYmY4
IDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6X2NvbW1vbi5j
DQo+ID4gKysrIGIvZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3pfY29tbW9uLmMNCj4gPiBA
QCAtMTcxLDYgKzE3MSw4IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3Qga3N6X2Rldl9vcHMga3N6OF9k
ZXZfb3BzID0NCj4gPiB7DQo+ID4gICAgICAgICAucmVzZXQgPSBrc3o4X3Jlc2V0X3N3aXRjaCwN
Cj4gPiAgICAgICAgIC5pbml0ID0ga3N6OF9zd2l0Y2hfaW5pdCwNCj4gPiAgICAgICAgIC5leGl0
ID0ga3N6OF9zd2l0Y2hfZXhpdCwNCj4gPiArICAgICAgIC5jaGFuZ2VfbXR1ID0ga3N6OF9jaGFu
Z2VfbXR1LA0KPiA+ICsgICAgICAgLm1heF9tdHUgPSBrc3o4X21heF9tdHUsDQo+ID4gIH07DQo+
ID4gDQo+ID4gIHN0YXRpYyB2b2lkIGtzejk0NzdfcGh5bGlua19tYWNfbGlua191cChzdHJ1Y3Qg
a3N6X2RldmljZSAqZGV2LA0KPiA+IGludA0KPiA+IHBvcnQsDQo+ID4gLQ0KPiA+IDIuMzAuMg0K
PiA+IA0K
