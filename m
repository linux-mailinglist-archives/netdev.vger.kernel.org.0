Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 429F264D5BD
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 04:54:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbiLODyc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 22:54:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiLODya (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 22:54:30 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D449A55AA0;
        Wed, 14 Dec 2022 19:54:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1671076467; x=1702612467;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=kQC3xlJPTlu6kEiy3yGYMMQjUQWAYooruh3FStpG4RI=;
  b=iQVa2oqQge1EN26qew56yHH+dCDCxF9VAr4T1zNMAgBKSOkjdAuYEwMc
   gR+ugrUeFh4ylwpJa7sRrG+pKXz8ASbKPxTDWgQwmDtC0fBjC+URWahIC
   dN5lylhxTjNzOAnNOvDaP/t/hdM7PBBb3FxqP+CdARucy7ngJSQIREkET
   Gbxp2ILMkwdoPwf1woe8zJPvNOsJ2zuo+K7i8QdOCc0s+GqWfNfaAhP89
   vkIXHKRASSTjd3SaW4CJu/tPVn15qQc7+9rLcl1Jub7lmfhqQbB8DPpxn
   ntYW9S2EAgNuWL/Ka62Wyzc/Cptgemt/sez7DRWpy8h3aV8cB7ds7ZQOl
   g==;
X-IronPort-AV: E=Sophos;i="5.96,246,1665471600"; 
   d="scan'208";a="191762544"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Dec 2022 20:54:26 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 14 Dec 2022 20:54:26 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 14 Dec 2022 20:54:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cZQHv/kthdg/Wdu/OI65nXhHjb0+UoJ3OcRLlF4VAYqxAUSHZwlygyPJqNOKKldAjYU+CsDUBmhANDEQpJ8jR1WbliIbeZUHLvGLe402hcXTqjVKCGmb7WWOYbgvrJXM7UGkVMJzUWKATzP1gwRbAol8lb3IP1cBaBiyRZtDcgere5XnEE1Be5y2Gs3OvfYx2B9W7lFdRmZ5X0pg/WfONgcODHrpDu8+p523cEqaOSdUz5ykGUCWQvkqZzFFHuVrQvbu+2MIVfMBwANhiWxBFIP81zTTeiWTcpuPJwXgPClpnkVl5/TsLGAK5US3wzGfd4CcjwADaliGbBO3qOuqyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kQC3xlJPTlu6kEiy3yGYMMQjUQWAYooruh3FStpG4RI=;
 b=dIJoIhhX/IPF08qSRs4O5TpEDqgePxi+vu3xU+WVLHE1HDf8xg/4os5LiF2blyM82jZV2Bwm96Bd5PHqYYVCCAX+5XuAiQDRMuwYYseYmQnf/JrORXwsOEOb32z2lQNHyyAEy7l03EvfzZvhdz3AZDXwJVqbY5jWJzQkWsOpOk5rkrDZ2zDff0+KArIwZEHo7NymQ1n2jiHXm/RIqORP90j8dmy7hF/ux0Xa97BxLsH9M4qczdVI2d4bHaB3bC8G3tzF7k+g2/JZiU6jUGtiRGrN+4qLGa3KfCsf26yYjspaUNncSRLrowiVluw8CV79NsYuTAS2pfBMsk1rB05dRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kQC3xlJPTlu6kEiy3yGYMMQjUQWAYooruh3FStpG4RI=;
 b=vFYmyTPRDLB1mQfzo59aCxPevqfRjmB/RBHpIE8B4u63yGm7S9O8qM07hLDr+VC9OtSQF9wtpkNb7u3+cJPhapzt6UFo3oHa3DUcJTqoNyOoNbQvVB3SCyus3MGoL5AGF5J357pwD+fYnkKHYNcbOWme8J/MfIH+teq4lOM5rHk=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 BL1PR11MB6050.namprd11.prod.outlook.com (2603:10b6:208:392::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5924.11; Thu, 15 Dec 2022 03:54:23 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::9b7a:7604:7a30:1953]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::9b7a:7604:7a30:1953%7]) with mapi id 15.20.5880.019; Thu, 15 Dec 2022
 03:54:23 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <olteanv@gmail.com>, <andrew@lunn.ch>, <robh+dt@kernel.org>,
        <corbet@lwn.net>, <linux-kernel@vger.kernel.org>,
        <tharvey@gateworks.com>, <linux-leds@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <john@phrozen.org>,
        <f.fainelli@gmail.com>, <pavel@ucw.cz>,
        <rmk+kernel@armlinux.org.uk>, <kuba@kernel.org>,
        <ansuelsmth@gmail.com>, <pabeni@redhat.com>, <edumazet@google.com>,
        <netdev@vger.kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <davem@davemloft.net>, <linux-doc@vger.kernel.org>,
        <alexander.stein@ew.tq-group.com>, <rasmus.villemoes@prevas.dk>
Subject: Re: [PATCH v7 10/11] net: dsa: qca8k: add LEDs support
Thread-Topic: [PATCH v7 10/11] net: dsa: qca8k: add LEDs support
Thread-Index: AQHZEDcAIu5dpKJOZk6zuC7xX3jd1q5uUWYA
Date:   Thu, 15 Dec 2022 03:54:23 +0000
Message-ID: <8a01a0afc344e9c7d259355aec190af63ea79393.camel@microchip.com>
References: <20221214235438.30271-1-ansuelsmth@gmail.com>
         <20221214235438.30271-11-ansuelsmth@gmail.com>
In-Reply-To: <20221214235438.30271-11-ansuelsmth@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB0076:EE_|BL1PR11MB6050:EE_
x-ms-office365-filtering-correlation-id: 2edf137b-7c37-4ef9-dcda-08dade500dbf
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oAVuih1WD8A1ypwbkPr77OMWCBREDg2Ig/NpqvtWbYK1xDQiG/Uz1JtsBHdUYv+fxSeeNfn2ogI7RnjBu2c3WXa4MRvX1zD0b3i1yRjKaJuaSDSiDA8SS8bHJmOIxrxgvPFRhG0Z5r1hoJPD9CiyYOt4UmUGsIrY71UdtcItjGjY8GjUxVsbm2r3HxXQNSwLzz7M0+6I8p4o8zHg8NhreOVcydCjTzRdYRXcEUO+1PGhJA+r9GCUVDkNc+4XYDTfTQBB3owlZIS07/qbIfWk3zIeqU75orPwbowZWbhOSbxZ+oYegJm8cwQWiwYf4zFBKnjgOtw2gCrudZPM/On9MxTRCuFQvL7Za0ib06l3Fi/GCFWCtgo/LyurS1V5ieg5MEhLlL/XxB3sjzjxGODnYi3fWaHVEyLfdDE2hcs6PdsUic3GvTkgNJUDOXtIx8ER2gcBU5XXFowrwz4Wj9l1BpUuKL/l49x67MZbtVA2Ma6uBDlgr9yV9/E8sxnNnzjTR6q31KEES8MbNwC5e9C/rdVeM7W5QvATV2MWppnDzP5hK7aNwrEWW70PEjmzWCo736A9mfTCyGOBELPFEegAB/hges0Icg/jy4xMPNkgp+4RIS/m5yUwxxB2+N3F8Gu18JA+ZMn6gj7GQkUuJuX9KJu731qKHAZYqbzNr3/zJZmen30Z8irdUTSTHOx9amXl83d4N87HgqSWcb6DgBt902E9xUcU9GuM2jKi0BfHB4IVp3s+JyGq0hhWsK/76+If6ZQoIiTd4yGX2YAm+n5hqQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(376002)(136003)(346002)(39860400002)(451199015)(36756003)(2906002)(4001150100001)(122000001)(5660300002)(7416002)(8936002)(86362001)(38070700005)(2616005)(38100700002)(921005)(83380400001)(110136005)(316002)(186003)(6512007)(6486002)(41300700001)(26005)(66556008)(66476007)(8676002)(64756008)(478600001)(66446008)(6506007)(76116006)(66946007)(71200400001)(91956017)(99106002)(32563001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SHBacVVKRjMwWHhJNzJtejNkQTc0ald3S1lObTVDRHZnVmhvZTRNWlU2bDZ2?=
 =?utf-8?B?K2xGUXlablEwSi8venlhY0EyTCs4SXBLWk1HakNQZGt0cHc0OTFlTXErNWMy?=
 =?utf-8?B?SzNpcDBXdjhCWkh0VmNTUkNqNFVocXUyUGF1UXJwbUJrWmlKazFSdjJWNHpH?=
 =?utf-8?B?MjNuRGI0UDk5YXBpeEZscldWSmNXN1BrSEd2NXpmeXZveFB4N2lTRjJrQlNq?=
 =?utf-8?B?eEk5SXFDUUNrUGhmdkZTS1d2MU1mOGgwWXNZYVFEZlg2S0xMU0pkWDdzRXE1?=
 =?utf-8?B?TE12WjRkbXhrY3ZBNGpoUVJZNFYvZUVXaW1hVDhlQ3JJVUtWYTJ1elIrbmlt?=
 =?utf-8?B?ZTl1ZDcwajI3T3ZkS0ljMkFsaitIbXkyaU82RDkzeEVLMCsyUUVhQUFFb1oy?=
 =?utf-8?B?dFNrQjdWRGErWmltd2d3aDA2Yk4vT2Y4SzluNjNWVndtbitNY3I1K2FWYi93?=
 =?utf-8?B?SGN2ai9SS3ZUb1VrN3MyNC9XVlp6bUthZW5jajliZ2U2cmg2TTFJVjkrcG1J?=
 =?utf-8?B?WVRsd1JIYXVGd2tzRnJZMWRvbHNaaDg0ZGlDblF6K0hSYkZLRzUxSnJRWlk4?=
 =?utf-8?B?QWdxQXAybGgxNU9hQm5YbGRMTDd0VzZJWVBPNE96ajFGUjlpdmx3LzJqK3Zh?=
 =?utf-8?B?RDZkcnRhSXNVVU05emt1TkJwNTE0dXEraHJqZzJPZUYyaC96TXpzTndtNkdw?=
 =?utf-8?B?ZU4yUHpBbFljQzUySEZPSkdKbjFBUytybFNFM1pncWhUcmlqdUtqdGxMN2Jx?=
 =?utf-8?B?S3lqaEV5eXJEdXo0VE15aFYxTlVmZ254eFJMNWdMWFlPYjQyeGNaajc2bE5D?=
 =?utf-8?B?UUFYTmZKWFZXeVZUMnE1ZTlVdE9YU2JSMENNZUVmM3l2dVJ2T0s2NURyS2dS?=
 =?utf-8?B?T0VhK1dCQklQSmJjeEtHKzQ0MFBVVUpraU1TeHU4OWxLdWVxM1lUM1QwV1pn?=
 =?utf-8?B?ZVZ1b211M3orbzZUbFVQd2RJSWJuejlPS1VlYy9Fd3hGRURzWmNiNGJFbFBO?=
 =?utf-8?B?aVRBb0ZpTGJjSnhzeWJKWE5KbW1aOWtqZHp5VXBwZ05ZbVRBWjJFSGhtRlZm?=
 =?utf-8?B?bHJkYktRZytYTGNncjh6NXpGVER0OUVrVXZqYzFuZHkyT0tRZWhBTjM0ZFBq?=
 =?utf-8?B?MlBPb1JEWGlXZEkyUS9kMVdDM0JzNUo5d3VsbXRhc1pScTdOV2VuYzlzNWRX?=
 =?utf-8?B?aG1Hd2h5cFVuQWlYNXdVV2ovV3UxRHA3U00vRW5hMFR6aG94dWkvK1VQQzNI?=
 =?utf-8?B?OEcyMVRCQkVEUTBkKzhpYk5VT2R6SXhaR1Z3ZFV1NmFSS1FSNnhYTGFZR1JV?=
 =?utf-8?B?aUpQT1dkNEJneUhZeVpQTDcwOVpLY3Q0c05jL1lFRDczWnJ1SjRySHlPTUc2?=
 =?utf-8?B?ZmlZclhQUjlmRlh1SGI3NnZGVmUxSFFwR05NYnFzSklrL2hjQ1FOWGhBT0ww?=
 =?utf-8?B?WDFYUDRJUk9MaVhzN25sZEd3aWZUQXVUMnN5UERZZGZ2ZEdGQXg4ZFR1Njlp?=
 =?utf-8?B?OWJXOVNxV2hack9OYnplMFVGL09HdCtWbzdBQVJZOHAwNVlGTnFuM3owVGhK?=
 =?utf-8?B?YjV6aXRMaklYVzNqU1hRb0FYakI3cWNvVUliM29PRFpYZmdQVFk3TTZvMjVx?=
 =?utf-8?B?WTZyRzNJT1pZdmppaTVMclN1RnBadGpZOWNYRlJ5U1YvUCtPMTRwVmdMYkor?=
 =?utf-8?B?Nm1SZ0xoVUsvcDJiZDYxeW1GQ21lWFkwZTFvQTVJelNZNmh3S2NDWEpHeklV?=
 =?utf-8?B?Kzk2a0t5S0lKUFZCZmV4SGlVa0hqV3dicVNuRGQ5RUlzbTh4ZFNNaW05NEkv?=
 =?utf-8?B?cjNGK2dEanBUK0M1WlVmelAvM2dBMVZ0Ni82Mk15eTJIbkNManI3QXA0Q2NL?=
 =?utf-8?B?MUNrSFFCL2MrNStJaUtFbDNmNWd0cjQzTHhLaWdjdkYzSGxXZWk3LzVCaVZW?=
 =?utf-8?B?MnU1OFVMMDNJNVQ0RWQ3ZUl2T2FvVjZvWk9ocEswRUdqZ240elhwMGZKazBK?=
 =?utf-8?B?TTFCYXFvRWdFN0gvQTJuK2ZJUUtXdjJQSXRQV1lBMW9QUEIxdDYyYk1ua1VE?=
 =?utf-8?B?MzdOZ1B6M0pib1JoS0tpTkRza1VhK1B4SDVPV1dZVnp6Yk1ua0NSRkVOYVNp?=
 =?utf-8?B?UDBaN09SeDhMQXJFN0ZDU2pNeFJBbXZ2Q2FlWHBwY0hCOUpoK2dEN2hZaFJK?=
 =?utf-8?B?R0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9A47928EBE25A848817B1EBAB5CAF343@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2edf137b-7c37-4ef9-dcda-08dade500dbf
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2022 03:54:23.5305
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: weAUFDLXEJkJPnvmIYNarW+/CL7UAmIOlML9Z/Dc+UyqqF9FCM+gkW6NhZNHtdZKAd632LyQYDarRyXeFaBQ9rCMxLEe6Uzl0lwwDuQ4LNY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB6050
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQ2hyaXN0aWFuLA0KDQpPbiBUaHUsIDIwMjItMTItMTUgYXQgMDA6NTQgKzAxMDAsIENocmlz
dGlhbiBNYXJhbmdpIHdyb3RlOg0KPiBBZGQgTEVEcyBzdXBwb3J0IGZvciBxY2E4ayBTd2l0Y2gg
RmFtaWx5LiBUaGlzIHdpbGwgcHJvdmlkZSB0aGUgTEVEcw0KPiBoYXJkd2FyZSBBUEkgdG8gcGVy
bWl0IHRoZSBQSFkgTEVEIHRvIHN1cHBvcnQgaGFyZHdhcmUgbW9kZS4NCj4gRWFjaCBwb3J0IGhh
dmUgYXQgbGVhc3QgMyBMRURzIGFuZCB0aGV5IGNhbiBIVyBibGluaywgc2V0IG9uL29mZiBvcg0K
PiBmb2xsb3cgYmxpbmsgbW9kZXMgY29uZmlndXJlZCB3aXRoIHRoZSBMRUQgaW4gaGFyZHdhcmUg
bW9kZS4NCj4gQWRkcyBzdXBwb3J0IGZvciBsZWRzIG5ldGRldiB0cmlnZ2VyIHRvIHN1cHBvcnQg
aGFyZHdhcmUgdHJpZ2dlcnMuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBDaHJpc3RpYW4gTWFyYW5n
aSA8YW5zdWVsc210aEBnbWFpbC5jb20+DQo+IC0tLQ0KPiAgZHJpdmVycy9uZXQvZHNhL3FjYS9L
Y29uZmlnICAgICAgfCAgIDkgKw0KPiAgZHJpdmVycy9uZXQvZHNhL3FjYS9NYWtlZmlsZSAgICAg
fCAgIDEgKw0KPiAgZHJpdmVycy9uZXQvZHNhL3FjYS9xY2E4ay04eHh4LmMgfCAgIDQgKw0KPiAg
ZHJpdmVycy9uZXQvZHNhL3FjYS9xY2E4ay1sZWRzLmMgfCA0MDYNCj4gKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKw0KPiAgZHJpdmVycy9uZXQvZHNhL3FjYS9xY2E4ay5oICAgICAgfCAg
NjIgKysrKysNCj4gIDUgZmlsZXMgY2hhbmdlZCwgNDgyIGluc2VydGlvbnMoKykNCj4gIGNyZWF0
ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL25ldC9kc2EvcWNhL3FjYThrLWxlZHMuYw0KPiANCj4gDQo+
IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9kc2EvcWNhL3FjYThrLWxlZHMuYw0KPiBiL2RyaXZl
cnMvbmV0L2RzYS9xY2EvcWNhOGstbGVkcy5jDQo+IG5ldyBmaWxlIG1vZGUgMTAwNjQ0DQo+IGlu
ZGV4IDAwMDAwMDAwMDAwMC4uYjUxY2RjYWUzMWIyDQo+IC0tLSAvZGV2L251bGwNCj4gKysrIGIv
ZHJpdmVycy9uZXQvZHNhL3FjYS9xY2E4ay1sZWRzLmMNCj4gQEAgLTAsMCArMSw0MDYgQEANCj4g
Ky8vIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wDQo+ICsjaW5jbHVkZSA8bmV0L2Rz
YS5oPg0KPiArI2luY2x1ZGUgPGxpbnV4L3JlZ21hcC5oPg0KDQpBbHBoYWJhdGljYWwgb3JkZXIN
Cg0KPiArDQo+ICsjaW5jbHVkZSAicWNhOGsuaCINCj4gKw0KPiArc3RhdGljIGludA0KPiArcWNh
OGtfZ2V0X2VuYWJsZV9sZWRfcmVnKGludCBwb3J0X251bSwgaW50IGxlZF9udW0sIHN0cnVjdA0K
PiBxY2E4a19sZWRfcGF0dGVybl9lbiAqcmVnX2luZm8pDQo+ICt7DQo+ICsJaW50IHNoaWZ0Ow0K
PiArDQo+ICsJc3dpdGNoIChwb3J0X251bSkgew0KPiArCWNhc2UgMDoNCj4gKwkJcmVnX2luZm8t
PnJlZyA9IFFDQThLX0xFRF9DVFJMX1JFRyhsZWRfbnVtKTsNCj4gKwkJcmVnX2luZm8tPnNoaWZ0
ID0gMTQ7DQoNCkFueSBtYWNyb3Mgb3RoZXIgdGhhbiBtYWdpYyBudW1iZXIgZm9yIDE0LCAzMCAN
Cg0KPiArCQlicmVhazsNCj4gKwljYXNlIDE6DQo+ICsJY2FzZSAyOg0KPiArCWNhc2UgMzoNCj4g
KwkJcmVnX2luZm8tPnJlZyA9IFFDQThLX0xFRF9DVFJMX1JFRygzKTsNCj4gKwkJc2hpZnQgPSAy
ICogbGVkX251bSArICg2ICogKHBvcnRfbnVtIC0gMSkpOw0KPiArDQo+ICsJCXJlZ19pbmZvLT5z
aGlmdCA9IDggKyBzaGlmdDsNCj4gKw0KPiArCQlicmVhazsNCj4gKwljYXNlIDQ6DQo+ICsJCXJl
Z19pbmZvLT5yZWcgPSBRQ0E4S19MRURfQ1RSTF9SRUcobGVkX251bSk7DQo+ICsJCXJlZ19pbmZv
LT5zaGlmdCA9IDMwOw0KPiArCQlicmVhazsNCj4gKwlkZWZhdWx0Og0KPiArCQlyZXR1cm4gLUVJ
TlZBTDsNCj4gKwl9DQo+ICsNCj4gKwlyZXR1cm4gMDsNCj4gK30NCj4gKw0KPiANCj4gKw0KPiAr
c3RhdGljIHZvaWQNCj4gK3FjYThrX2xlZF9icmlnaHRuZXNzX3NldChzdHJ1Y3QgcWNhOGtfbGVk
ICpsZWQsDQo+ICsJCQkgZW51bSBsZWRfYnJpZ2h0bmVzcyBiKQ0KDQp2YXJpYWJsZSBuYW1lIG90
aGVyIHRoYW4gYiB0byBoYXZlIHJlYWRhYmlsaXR5IGluIGNvZGUNCg0KPiArew0KPiArCXN0cnVj
dCBxY2E4a19sZWRfcGF0dGVybl9lbiByZWdfaW5mbzsNCj4gKwlzdHJ1Y3QgcWNhOGtfcHJpdiAq
cHJpdiA9IGxlZC0+cHJpdjsNCj4gKwl1MzIgdmFsID0gUUNBOEtfTEVEX0FMV0FZU19PRkY7DQo+
ICsNCj4gKwlxY2E4a19nZXRfZW5hYmxlX2xlZF9yZWcobGVkLT5wb3J0X251bSwgbGVkLT5sZWRf
bnVtLA0KPiAmcmVnX2luZm8pOw0KPiArDQo+ICsJaWYgKGIpDQo+ICsJCXZhbCA9IFFDQThLX0xF
RF9BTFdBWVNfT047DQo+ICsNCj4gKwlyZWdtYXBfdXBkYXRlX2JpdHMocHJpdi0+cmVnbWFwLCBy
ZWdfaW5mby5yZWcsDQo+ICsJCQkgICBHRU5NQVNLKDEsIDApIDw8IHJlZ19pbmZvLnNoaWZ0LA0K
DQpHRU5NQVNLKDEsIDApIHVzZWQgaW4gbXVsdGlwbGUgcGxhY2UsIHJlcGxhY2Ugd2l0aCBtYWNy
byBmb3INCnJlYWRhYmlsaXR5DQoNCj4gKwkJCSAgIHZhbCA8PCByZWdfaW5mby5zaGlmdCk7DQo+
ICt9DQo+ICsNCj4gDQo+ICsNCj4gK3N0YXRpYyBpbnQNCj4gK3FjYThrX2NsZWRfdHJpZ2dlcl9v
ZmZsb2FkKHN0cnVjdCBsZWRfY2xhc3NkZXYgKmxkZXYsIGJvb2wgZW5hYmxlKQ0KPiArew0KPiAr
CXN0cnVjdCBxY2E4a19sZWQgKmxlZCA9IGNvbnRhaW5lcl9vZihsZGV2LCBzdHJ1Y3QgcWNhOGtf
bGVkLA0KPiBjZGV2KTsNCj4gKw0KDQpCbGFuayBsaW5lDQoNCj4gKwlzdHJ1Y3QgcWNhOGtfbGVk
X3BhdHRlcm5fZW4gcmVnX2luZm87DQo+ICsJc3RydWN0IHFjYThrX3ByaXYgKnByaXYgPSBsZWQt
PnByaXY7DQo+ICsJdTMyIHZhbCA9IFFDQThLX0xFRF9BTFdBWVNfT0ZGOw0KPiArDQo+ICsJcWNh
OGtfZ2V0X2VuYWJsZV9sZWRfcmVnKGxlZC0+cG9ydF9udW0sIGxlZC0+bGVkX251bSwNCj4gJnJl
Z19pbmZvKTsNCj4gKw0KPiArCWlmIChlbmFibGUpDQo+ICsJCXZhbCA9IFFDQThLX0xFRF9SVUxF
X0NPTlRST0xMRUQ7DQo+ICsNCj4gKwlyZXR1cm4gcmVnbWFwX3VwZGF0ZV9iaXRzKHByaXYtPnJl
Z21hcCwgcmVnX2luZm8ucmVnLA0KPiArCQkJCSAgR0VOTUFTSygxLCAwKSA8PCByZWdfaW5mby5z
aGlmdCwNCj4gKwkJCQkgIHZhbCA8PCByZWdfaW5mby5zaGlmdCk7DQo+ICt9DQo+ICsNCj4gDQo+
ICtzdGF0aWMgYm9vbA0KPiArcWNhOGtfY2xlZF9od19jb250cm9sX3N0YXR1cyhzdHJ1Y3QgbGVk
X2NsYXNzZGV2ICpsZGV2KQ0KPiArew0KPiArCXN0cnVjdCBxY2E4a19sZWQgKmxlZCA9IGNvbnRh
aW5lcl9vZihsZGV2LCBzdHJ1Y3QgcWNhOGtfbGVkLA0KPiBjZGV2KTsNCj4gKw0KDQpCbGFuayBs
aW5lDQoNCj4gKwlzdHJ1Y3QgcWNhOGtfbGVkX3BhdHRlcm5fZW4gcmVnX2luZm87DQo+ICsJc3Ry
dWN0IHFjYThrX3ByaXYgKnByaXYgPSBsZWQtPnByaXY7DQo+ICsJdTMyIHZhbDsNCj4gKw0KPiAr
CXFjYThrX2dldF9lbmFibGVfbGVkX3JlZyhsZWQtPnBvcnRfbnVtLCBsZWQtPmxlZF9udW0sDQo+
ICZyZWdfaW5mbyk7DQo+ICsNCj4gKwlyZWdtYXBfcmVhZChwcml2LT5yZWdtYXAsIHJlZ19pbmZv
LnJlZywgJnZhbCk7DQo+ICsNCj4gKwl2YWwgPj49IHJlZ19pbmZvLnNoaWZ0Ow0KPiArCXZhbCAm
PSBHRU5NQVNLKDEsIDApOw0KPiArDQo+ICsJcmV0dXJuIHZhbCA9PSBRQ0E4S19MRURfUlVMRV9D
T05UUk9MTEVEOw0KPiArfQ0KPiArDQo+IA0K
