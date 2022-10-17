Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB8AF60165E
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 20:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230208AbiJQSdo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 14:33:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbiJQSdm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 14:33:42 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0928F74E06;
        Mon, 17 Oct 2022 11:33:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1666031618; x=1697567618;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=ZIrtSknquiqvxj6+HsF8sWMLqUOYgaxbvbFOM817yEo=;
  b=G5bmdQ5578uzQ7BuFHzI3MvACOYWQdSzsYEtTpjXUw49HWr/8ACb5sy0
   IFLHtWtmo0lkA7J6c0nZK//rBS9CBK7G23LqU8bPFFQi2a8XDmM4TEHVk
   efb1cL+Ab6WPSPG7cAZEW52dX5oXIg9INtp6wwurO4ijDYnqWlHXmKvfi
   eZVlfI6zp9TfluIGRtawyncdtUG374tplsSGhOhcDwNHtIcOExFANdTWL
   wJAJf3tIm1pLmGTe9aKjRske+qOgzKREjrENC2V+LcD4Mgy0wXklNPM7r
   Liofr9S3Sf8LikXaJd3yEROSr53tvo8mb0DYnZKxSFLE4mJzY1/6C9xTj
   g==;
X-IronPort-AV: E=Sophos;i="5.95,192,1661842800"; 
   d="scan'208";a="185102891"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Oct 2022 11:33:37 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 17 Oct 2022 11:33:37 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12 via Frontend
 Transport; Mon, 17 Oct 2022 11:33:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EntqFjXn8RV5pCM48gj132aZBKDsgFfocMAsvXAX6HCw0jsSBZOrivU3YADmc3ty0A7G0t/Rdf+3X3hhAZTCCL7tit7wyB/HvLUzuUJQPrEe/6Ty9TyeiB2kChtOBVH2VVlUuZlh6cTMmuP+zYrKk8UaEKRLbk7NdmysNTRNK+0qE8iYgMh2Up68Qv6tGWGkqOiw6aF6RnpC4cyzxGwly5zRTjMpNfCN+a7N9VL0LbcYFnVwsWQAu/wManENxLEILZohej6LW5rEQDu+zpNJl56ooyvP0FH0QyO6zuTRH5dCzHW0QvjVS17yYuHmQ2uJALILnr73hiIfrB7rC/yaJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZIrtSknquiqvxj6+HsF8sWMLqUOYgaxbvbFOM817yEo=;
 b=M+AZ8Ad5sG7yi1Yn56Bf3y6HZ9Q0ZFXdirxh1PZ9paVLfP7KDN3B3hvVP6jsLqsPkQfR3FGEEwTK/FMarxCFJQG54xDoFgGY0DQwGA+s5OyDHljvfwtev+1VtI6uGTcMhOUDY7Jr0816eP75E5jbCldWSxD2jdlFJTsQMGjuXs43hAdI74iETzKjbeIi02GdFqYsuPSl+7IyWPbUR9F8ekzuNYPNWiYPia7ixxEQ4bKvxN+mmE5wyk7fG6jySMmmL5VNXDkL2hVO9VOt2AmJZ0FghW9asC9+83uU1TOhHT1Q1yE0ITbE5g9lqYrKsP1UJYyaiU0lDeUXNgn5y/8Eig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZIrtSknquiqvxj6+HsF8sWMLqUOYgaxbvbFOM817yEo=;
 b=ArxbXX22yoeqYC6OWUXrkqOarAa7bg3MvkQE6GijZoSbSDsyDcF+4M8gLXBjH8gpZJAUNoxOMGIbi/bLq219GmlFYiCQwO1NUD+b8JPKJDssgayOHw/yjhFmSvHnVO7wrnGnkGVGOjO8cymuJWrQMl4UMSGyPTONOhYjGxHxP1U=
Received: from MWHPR11MB1693.namprd11.prod.outlook.com (2603:10b6:300:2b::21)
 by SN7PR11MB6945.namprd11.prod.outlook.com (2603:10b6:806:2a8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.30; Mon, 17 Oct
 2022 18:33:32 +0000
Received: from MWHPR11MB1693.namprd11.prod.outlook.com
 ([fe80::6599:7b75:c033:afcd]) by MWHPR11MB1693.namprd11.prod.outlook.com
 ([fe80::6599:7b75:c033:afcd%12]) with mapi id 15.20.5723.033; Mon, 17 Oct
 2022 18:33:31 +0000
From:   <Jerry.Ray@microchip.com>
To:     <krzysztof.kozlowski@linaro.org>, <andrew@lunn.ch>,
        <vivien.didelot@gmail.com>, <f.fainelli@gmail.com>,
        <olteanv@gmail.com>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski+dt@linaro.org>,
        <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: RE: [net-next][PATCH v4] dt-bindings: dsa: Add lan9303 yaml
Thread-Topic: [net-next][PATCH v4] dt-bindings: dsa: Add lan9303 yaml
Thread-Index: AQHY10fB8CyYFFC0ckOeRLuaLwivma388kEAgBYM0MA=
Date:   Mon, 17 Oct 2022 18:33:31 +0000
Message-ID: <MWHPR11MB1693223A91222AEAAA3FC69FEF299@MWHPR11MB1693.namprd11.prod.outlook.com>
References: <20221003164624.4823-1-jerry.ray@microchip.com>
 <c1b64758-219b-9251-cea8-d5301f01ee7f@linaro.org>
In-Reply-To: <c1b64758-219b-9251-cea8-d5301f01ee7f@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MWHPR11MB1693:EE_|SN7PR11MB6945:EE_
x-ms-office365-filtering-correlation-id: 4689300d-2211-471b-f692-08dab06e17ca
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZDiXwvCNcZp8sg5GLNv9ifzdkH2rqgdqQv5fcWBpd4Qzicwpyvq6GiXT4DxtuSALRIav6UmQ9bEpVzMLhn6OVn54RC0tBbqUxVPoLvda17Y6gpelHDGWRNDMgqtyv1B3qNvJURjNxmxcrm2scZBCm7SCuupBoaUeGdtgfvtjx1zxyV5Uk7ABjgyUIBGkTagyy/PTocwGt8OklfGHSmgDYbd56SzTLQ7rP5aAHrPZkMkL4jhoAmLwUCeckHCjOFPwQGGtUBY/K3C9EcPpJ3sA/1YiOCjm1iZmEaMHEQcXPBR8WM2yeJe5poxCDOnYe5vtIBZYwPhzVZqjgLXfATYSaV3GEJR/s2CmIka1FVaX4RWk/tLmaBUs1a9Txo9bhTLad0LnBVsvpySrV19b2yilSIyPlmmyQcw8qpj4CNLiwGORonDeR6RE4ctV2QkZFWrwrh5RYiVBUwDhrIceQv6kISpXltmois0KiD+Rw7KsuI3nzFX7ftnpE13Lm55ymRNqVrnCNSt0Sxw/XYbUWtv9T/ZIF2dAA0eveWwj9y61IgmusuiDFkGwKrwpJwEA2gHxMmM84V5/a68CxQ3n0tYKwrehRaul1tvMjNi9jExS3DbOK7pRqhPZ1nBLpuRwPavRNjdhfRsb8HRf/YVWymMA+PMMBOKe5V++6Z36PukjqSWeM4TWXvdDIuTUACBjvPviO6cUMuck2T8ZiBKK7+m3dMS0g89EMmNy7Ff5Mv+8vd5QhEv92uKJV6G+k7knwW/JhT+byDnewbmGJlWW+zM9O0vEQh3Pj8l1X1/bEAasfsU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1693.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(39860400002)(376002)(136003)(346002)(451199015)(38100700002)(186003)(71200400001)(33656002)(2906002)(921005)(122000001)(478600001)(38070700005)(26005)(66946007)(66446008)(66476007)(8676002)(66556008)(83380400001)(110136005)(64756008)(52536014)(9686003)(86362001)(7416002)(76116006)(8936002)(5660300002)(316002)(7696005)(6506007)(41300700001)(55016003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cWlQaDNNY1ZjdndoV1QwTks5QkdDUmdncHh0a2twLzRhQnhDNEUrVCtBZ1ho?=
 =?utf-8?B?TEY1UmVEM1pTVlBGdXBTRE5HWG9JaE1zTlF0Y0xHSVF6d0R5bElFS29udTll?=
 =?utf-8?B?S1JqRGVXbTh4UE95YnM1MFR0azNIYXh3RHRIMXFlSGRwT2JhdGJyYnB5bHhV?=
 =?utf-8?B?T2dLaDBjSHFvaGlJcHFUbTl3QzUxQkM2V21MRTdJU0JpZzMwVkdjeWFPZWR6?=
 =?utf-8?B?aFVjM1pOMit2ME1aRlh4RUdoZkthRGRDdXJtVVdIZHdFamlENGszWUZiRXUw?=
 =?utf-8?B?cnE1YVJ3L05JYVdvdEVVV3ZyWjlVK1dLS0kxQ0NiMDZvYkR1NWJDVUZBQnFo?=
 =?utf-8?B?UVVkNUNEZzZyK1FacnNUdUlKVWFuY1N0MjhiVjlwUGpDU1VpUU44cldMRnEx?=
 =?utf-8?B?ME9KWndxKytTU01aeDhJNHRKZlB6eTNaZUluemdYMFNSQkEwcmJ5czVRQVdN?=
 =?utf-8?B?QzdHQjFuYXhneHBNbkFRZUdZRUFScFowbVlJcU9mN2pJd25UYitJRExZSHo1?=
 =?utf-8?B?d3hnUThyRXl0c2RHU1pSZHJoV2pzc3V2K05lZ2wzcTVqL1VINUZ2dlFLb1l6?=
 =?utf-8?B?c0owQkNUQ1AyYXhEU3F4VjF2ZEE2WTBsbzl2VC82QWJpL0U0eTZBM1NsbWlF?=
 =?utf-8?B?SldSblk3Q0RBTVRZWHExQzcyYm5vY0YrN0hTZ3p6YkV6RmpCNU1XSENObHRD?=
 =?utf-8?B?a3UzVjBIai9EVFNjNDN5S1EvY3hlbjYvcXRxOExScTZSZUVsR2E4RjdaSGNt?=
 =?utf-8?B?NDJYM05tK00vVHoxUDczQmlNR1NxQkVwMWRXRE45TzVSSG5ZcDEvbXZveUZy?=
 =?utf-8?B?MHBmb1F3QUppVnBtWmlzS3ZYWjhBdjk2UnFYSjlsM1ZRZlQ4R2lyTEgrRTFN?=
 =?utf-8?B?bDc5ekRrUmcyZ1ArSmNheDhnRTRWM3EzVFdFWG5KVWNJWnJZcFdSYzIramFr?=
 =?utf-8?B?NzR1UEpHazB3TmsxR1p6T0FrVitWWEluTTNxTGtGcFdHeUFNM054dFduZDNV?=
 =?utf-8?B?c1dHOGFGcXRMNDdLR0VFRWNSV3o4K2lpYXRsYzZFZHNHLzhmekN3YmN5VUZp?=
 =?utf-8?B?NWFMTkZZRnBqdWJtM2xLbWR1YjJmdENPdDNmY1NUNmRNa2pORGYzQ3lKcGJw?=
 =?utf-8?B?NWtBa3hHbThMWWMwY3hMa05aQUkzOSt0Uno4Y0Jhd3JYSEVZRC9ZTUlSdlEz?=
 =?utf-8?B?UzV5dUFHbnJZTm96KzFTUDM2dS9NbU5MT2hKTWxOSktVUEp0SlkwcHcvcncr?=
 =?utf-8?B?SVZkMi9NSzRWa3pWT3hEdFlDR2dhZWFwMm9FSktBN2M5S0VIekFpVDY4bkww?=
 =?utf-8?B?YXBKcXlNM2ZPYjRWTUUzSW9UN0FRNXQydFJsLzV5U1hFVzdXZm5RTnFTVTl4?=
 =?utf-8?B?b1VtU0J5ZjhXaStXVkdPajFacmtVOTM0Y04vL1dXbmNqd3BWRUwvSWpqNlZV?=
 =?utf-8?B?NDM1alRQbGFVOFNZT2JLbmxoejhjTXNsSlNKR1gxV2NUWGNtbzE4NTNLc2dT?=
 =?utf-8?B?WGhQOWtmYzJ2WjllL1ViQ0pOYWI2VGI3WkpTamNmS1NoSFc3NXcrVXZVMHBk?=
 =?utf-8?B?aDJxQnQxcWprZ3lUbU04UUR6UlhXQlM5Y0IrZmdZanVSeGl6c2gycWF1cE91?=
 =?utf-8?B?QXFha2tOTDNsYUd4RlhnRWFkZXp4M0VPYzN6U3cwdkd5RlNsZ0crd3dxcW0z?=
 =?utf-8?B?czQxbWZiaG80YWdRQ2NJWlI2eHhIb0tLZWM3M2R2YUpVaTMwc0lWZjJVVm1L?=
 =?utf-8?B?Q1RpUHlFWitzQU5MMVRRdE1WaVAwVmJKNVFMaTkzV1MrTkNkMS9CbnVSekVG?=
 =?utf-8?B?R3lxVU9VR3ltRkRaRUJOcHpxZmluLy9FZDdwOTlid2RzQVRxNi9jYzRPVDNN?=
 =?utf-8?B?MUR0OGV0ODd3ZS96NFE1YzhINDdSTkc4Z3JsdHFhcHFpMVNnMG92TFV1bHpu?=
 =?utf-8?B?N2l1UUtSZXFUMHpGVjJjbitxNWdrMHUrenBkbW5xbG15QmRaQVl2Ky8vNVAy?=
 =?utf-8?B?SjE2RnNqNllmNkViQjZKTzRJclNmaU9udkp5Qi9LR2JIbHE4RDN1ellZTlB2?=
 =?utf-8?B?djIyV2ltWmZLY0ljVS9YOGdKTm80YW52UE9kTDlDSnJQbUhsV3h6bUNCRFJo?=
 =?utf-8?Q?O8rQUGdQHMwzgwg/azvTNl9cd?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1693.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4689300d-2211-471b-f692-08dab06e17ca
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2022 18:33:31.7790
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TG+SsQDIZGFrQkzCDdGqyK7b/UVURckKu8rcTpyA75CSCHOkNM5fhNRNmbsUPsW9gwnyy6qsEzzFGTAPCQS82w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6945
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pj4gKw0KPj4gKyAgcmVnOg0KPj4gKyAgICBtYXhJdGVtczogMQ0KPj4gKw0KPj4gKyAgcmVzZXQt
Z3Bpb3M6DQo+PiArICAgIGRlc2NyaXB0aW9uOiBPcHRpb25hbCByZXNldCBsaW5lDQo+PiArICAg
IG1heEl0ZW1zOiAxDQo+PiArDQo+PiArICByZXNldC1kdXJhdGlvbjoNCj4+ICsgICAgZGVzY3Jp
cHRpb246IFJlc2V0IGR1cmF0aW9uIGluIG1pbGxpc2Vjb25kcw0KPj4gKyAgICBkZWZhdWx0OiAy
MDANCj4NCj5UaGlzIGlzIGEgZnJpZW5kbHkgcmVtaW5kZXIgZHVyaW5nIHRoZSByZXZpZXcgcHJv
Y2Vzcy4NCj4NCj5JdCBzZWVtcyBteSBwcmV2aW91cyBjb21tZW50cyB3ZXJlIG5vdCBmdWxseSBh
ZGRyZXNzZWQuIE1heWJlIG15DQo+ZmVlZGJhY2sgZ290IGxvc3QgYmV0d2VlbiB0aGUgcXVvdGVz
LCBtYXliZSB5b3UganVzdCBmb3Jnb3QgdG8gYXBwbHkgaXQuDQo+UGxlYXNlIGdvIGJhY2sgdG8g
dGhlIHByZXZpb3VzIGRpc2N1c3Npb24gYW5kIGVpdGhlciBpbXBsZW1lbnQgYWxsDQo+cmVxdWVz
dGVkIGNoYW5nZXMgb3Iga2VlcCBkaXNjdXNzaW5nIHRoZW0uDQo+DQo+VGhhbmsgeW91Lg0KPg0K
DQpJIGFtIGRvY3VtZW50aW5nICJ3aGF0IGlzIiByYXRoZXIgdGhhbiB3aGF0IEkgdGhpbmsgaXQg
c2hvdWxkIGJlLiBJDQp3b3VsZCBwcmVmZXIgdGhlcmUgYmUgYSAiLW1zIiBzdWZmaXggb24gdGhl
IG5hbWUsIGJ1dCB0aGF0IHdhcyBub3QNCndoYXQgd2FzIGluIHRoZSBwcmUtZXhpc3RpbmcgY29k
ZS4NCg0KSSBhZGRlZCB0aGUgImRlZmF1bHQ6IDIwMCIgbGluZSBhbmQgY2FuIGFkZCBhICJtYXhJ
dGVtczogMSIsIGJ1dCBiZWdpbg0KZ2V0dGluZyBlcnJvcnMgd2hlbiBJIGF0dGVtcHQgdG8gZnVy
dGhlciBkZWZpbmUgdGhpcyBmaWVsZCBhcyBhDQp1aW50MzIgdHlwZSBvciBhbnl0aGluZyBsaWtl
IHRoYXQuDQoNCkFuZCBubywgSSdtIG5vdCBnZXR0aW5nIGFueSB3YXJuaW5ncyBvciBlcnJvcnMg
ZnJvbSB0aGUgZHRfYmluZGluZ3NfY2hlY2suDQoNCkkgcmV2aWV3ZWQgdGhlIHYzIGNvbW1lbnRz
LiAgVGhlIG9ubHkgb3RoZXIgdGhpbmcgSSBtaXNzZWQgaW4gdjQgd2FzIGNoYW5naW5nDQp0aGUg
Y29tbWVudHMgZnJvbSBDKysgc3R5bGUgdG8gQyBzdHlsZSBjb21tZW50cy4NCg0KPj4gKw0KPj4g
K3JlcXVpcmVkOg0KPj4gKyAgLSBjb21wYXRpYmxlDQo+PiArICAtIHJlZw0KPj4gKw0KPkJlc3Qg
cmVnYXJkcywNCj5Lcnp5c3p0b2YNCj4NCg0KUmVnYXJkcywNCkplcnJ5Lg0KDQo=
