Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 008D56208D8
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 06:16:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230152AbiKHFQB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 00:16:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiKHFP7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 00:15:59 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 373F2186EF;
        Mon,  7 Nov 2022 21:15:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1667884559; x=1699420559;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=gA30X9aJGNmLvHLfzfGTOZfH5wzns9xCoonWo1xiKbQ=;
  b=S64oswIST5yyZH7fOyDOlcnuAZwmARDDczXDRksJbAiUCRFTPDbYFzoH
   dHnUHnvoTxgESFwNtyUPDw7+mVu78hfNb48JW7+/P9zUD393Mj2FCud4e
   QP4crbUUZ2M7oi5pM6XjSDo2l/jU+2iR3eEqO0xSsauOw8Lt1WIyyKHaV
   waxM/1YBbKaROizsd6uR029E4ub2749swur/nq3lSpZOr+q0TqK5IDbEv
   iO8mJIW8zIsYNAzcK1QvbbKy6NyEl2fsB2ApaS9PL3XpJYpj8UEd1zRQ9
   /ehngt7jKNPCtkEjwRmHFCy3qBBQzPNrTrFexzolcRGQFN1np3prC3A5G
   g==;
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="188044061"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Nov 2022 22:15:58 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 7 Nov 2022 22:15:57 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12 via Frontend Transport; Mon, 7 Nov 2022 22:15:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IBxgjo1V5niTDN+FT02HJ59pV2tnfUiDc1yOZlzzbKEyuOnck0nDmES0G1VNDUGlwmHVYJLluatktkWvq/VNnEG7UWuXt+DZwRIJvyx8Iv2eVb3W0iaseyKlXs3K937kcrG4zQbcQ00Y1S//0TR+uQXBh+zLKnLafH1ts0wnn6dygmexKKvsnNtaWq01RtkshupQ0JxeyPS6GtrXOku2KtUEcFPSsojlUgU2O7gzehAbfOe2l3JXUBKQhhPsJnK9l+KypdWPL2n4CI/jUaFN/gzv8diVB1xRr2y3ouu7o1CO+Ym7enSg+L1PZ2KfAtr3Yhr8JsmVukmtMnA5fsD1jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gA30X9aJGNmLvHLfzfGTOZfH5wzns9xCoonWo1xiKbQ=;
 b=Ljt252ewbPKzVCdoz8FCrcRQjJ5x3nIay/mJKvWI/KRplSMXurnWXf3dlq7RNobRM/bjCUMyXZjtj7T7fRMBsUJ5QLv397pi5+rTA5Mhph2d9jFqQ/1SYVJtw967wf3Z2CaJPOtthm5d+q1wxZETgQYUKAMzgyPD+o4tJrtd+TZFBxWakRPqCcQVWsVxAbt60IC7m9kHc5oBD/YH/ujaJqQAiu7dbRr/V4ZVotsoIYzLQOpb7p/0cBcWflqnzdB4PW907ajRQCaYU+gUpq9I/hcUre3bZ8wCl3jmladNEQikVC8uVi3iUdG1RPM+DTeZlZk/OzRl3mTVAW4lcercqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gA30X9aJGNmLvHLfzfGTOZfH5wzns9xCoonWo1xiKbQ=;
 b=vh9RaCSYcgPonCGZeufApVcfIMnVCZ5r5TVOlZVzF7Wnov0lF4z/XnR/zH6ndfsVOz88rqx9pc4j/OUmuQbEBjh/RfppX/xCJzxu3eQ0vnzRzxjpe4QbKPOlfOBzE8bCRHTq+VyMDoxnU6fjVuHY+jsC/YyQP5JIwvt6tTiAVu8=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 MW4PR11MB7104.namprd11.prod.outlook.com (2603:10b6:303:22b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.24; Tue, 8 Nov
 2022 05:15:49 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::faca:fe8a:e6fa:2d7]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::faca:fe8a:e6fa:2d7%3]) with mapi id 15.20.5769.021; Tue, 8 Nov 2022
 05:15:49 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <olteanv@gmail.com>, <UNGLinuxDriver@microchip.com>,
        <vivien.didelot@gmail.com>, <andrew@lunn.ch>,
        <f.fainelli@gmail.com>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <o.rempel@pengutronix.de>,
        <Woojung.Huh@microchip.com>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel@pengutronix.de>
Subject: Re: [PATCH net-next v2 1/3] net: dsa: microchip: move max mtu to one
 location
Thread-Topic: [PATCH net-next v2 1/3] net: dsa: microchip: move max mtu to one
 location
Thread-Index: AQHY8rEPw/TX/UCjAk2vh6ZvouoP8q40fO+A
Date:   Tue, 8 Nov 2022 05:15:48 +0000
Message-ID: <746c5de43eecdf34ffff5c16a9f1bf4bb505bb43.camel@microchip.com>
References: <20221107135755.2664997-1-o.rempel@pengutronix.de>
         <20221107135755.2664997-2-o.rempel@pengutronix.de>
In-Reply-To: <20221107135755.2664997-2-o.rempel@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB0076:EE_|MW4PR11MB7104:EE_
x-ms-office365-filtering-correlation-id: 37215669-f404-49f5-dcee-08dac1484c71
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /HHUGYIE0rECQ/qKzBOtUO4vXUmuV4/RHG2ivxXjlueBgE04UzLz81K+wAb3/WwPQs3fxN1fyQYjejq3ELf+Aul3NHw3N2ExH8vfwsWt2SPWC1W8PAduBDrOQoWmOiehikGviQvB0yNgPJ9OSPX9GTW9cR38MAH751XDumeFd8tcUArEitAqqc4bZUWwt6IigO0pTzBuPYMKN4MIQ1OrbLsjXoBBz0j2ZC7vda95ogkPuMquGTpZjs2LqkaIu9oVx7XkkufGQUFm4FeFkj6p8LXhWDzqtaswvsR0efSUEqg2azAgHRe/vghWTv395BP8g1S8Pi7A6CK2dQLIhbLawznFaFPPG3rfBv0VC+jPeTqonVRo+41vRWFeMz689wCHNZfMJEE8X1fQPfYFlycG74sKwp1BCPIP4xM+JHEIE6o6i4tROJsX0lvhptGi5rDQkWn4G72H0yLu3rWJhAv2+po2z+oG6qh42FDquxiAKP5l7KzWrr+y6lKryuA1qJhKITrPyop2hCQXQ11o0l5xEKHA4jucgN7GskXQHjuPb7h3mA1P4xOZsMwEdwi1hjNpf39rFMv64W9X4wK04c+wsYTkFgQwDpv9Di2EyirnF/gX/UVyaif6t27tIdrJJndoSvQh90bJkDpcC9NYaT0IgjQNOIdtEzBa4NlKf0DvCOTa0W+xHRk9w3+ZxI+LODaait5RJTRKzKaK8vBSSzjPJ6JDGwziZQjYp3bzF4QNW21X8QYYQ2lPlPrzYxdRv2GFEb2lM0PXiIGcMwPI2GjTcKJQtRzI5SoRrGbf2Dr7uHqeeJdDSndGaYPngR6tSlIR
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(376002)(366004)(346002)(396003)(136003)(451199015)(4326008)(110136005)(54906003)(316002)(2906002)(8936002)(5660300002)(41300700001)(36756003)(186003)(2616005)(7416002)(91956017)(64756008)(66476007)(76116006)(66946007)(66446008)(66556008)(6512007)(26005)(83380400001)(8676002)(6506007)(6486002)(478600001)(921005)(38070700005)(86362001)(122000001)(71200400001)(38100700002)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bTF5WGVCcUM5RkMyUFVDeWNGTzBreEtjaDE0OERnTGt3eXhIN0t4K2tETDBa?=
 =?utf-8?B?WDIxRzNWZ0dWc2dmZi92UlZCRmhZSzY3SjRPRkhveEpId1AxWWRVL1IzVDNZ?=
 =?utf-8?B?T2VzdjZjMzlJSkltUWxHRkRMLzVNSWZmT3FwQkN5OXUzajZKT0FpNnE3VDBT?=
 =?utf-8?B?Qy95VTZFSXdrckZPZVNiVWQyYWlmM3czZzEyNXFBQzA5V1NyMXNLZXVPM3Rv?=
 =?utf-8?B?ZHRxZFFXMzFyOENuN1hmWTNRVm5WVUFza2N3Q0syS0tvZUF5dEhQNDhKbWV4?=
 =?utf-8?B?UFJQL1BnNzhKelJ5Y0dPUzZvVyt4UjhaMUc5ZE0vYWF6UTRzYnNwdG94ZjBn?=
 =?utf-8?B?R1lNMEJJc0poNmlhOThsbXhYV1pxcEVRU2h6c01VODZ1WGJGS0ZLYWRDUkhC?=
 =?utf-8?B?RFFVdkVjWkxRa1VQaHIxNVdnS092NExUUmFuYmYrRDhrRjZUMVZ5RW9ONWY2?=
 =?utf-8?B?SzZnZk1LQkoreHJRc0EvWHlZL3VVckhqYzllZURNZW5ac1FDdjRNbjY3UTRP?=
 =?utf-8?B?d1Q0dDhSaEtpMittcVRtWGorUGtIc3pVejdxWXA5RUJacHh5U1ZFL0I3dU82?=
 =?utf-8?B?MSt0TFhsNTF1a2JRaHc1SWRyTlY4dDR1c1hpQ2xlaWVLTUN3WU5qWVoyanQv?=
 =?utf-8?B?L3VPWGFGbU5FVDhtN0tBVDN2K0dUTnJRSEN2OEI1Z1V1MGV0d0ZKUTk0b2g4?=
 =?utf-8?B?Q2Vacmorb0pkWHhvOE5yVTNIMmQvMWtFZnd3Q1FkeksrM3ZNQ3NncnAwWE9X?=
 =?utf-8?B?RFVVQnlGZmdvTWNkU1MxVmVVRVdVWW5acll2UzRVdmpHTnF5QzZZakZvS3Ez?=
 =?utf-8?B?dmpNMlZMSG84Zyt4bXo2TkN3QUFzQVJlc2ZndmJqck85Q3ZWNmtWdFB5VUtz?=
 =?utf-8?B?ekJScGw1bk1hOE5tYlBJVXdScDQrbGR1ZDNZOUF4Yk5XWTMvc0tmWVFkTklh?=
 =?utf-8?B?VjlYWmRZS2hkMGZxTFJESTFJYnZDN2gwS2E3ZDI4WkJTbDhKY3lHUHdCZ2Vm?=
 =?utf-8?B?OXZQR2wwaEI0Uk5SS2RqaGJ2RG5DMmJic29wZzBmSWhkTWZ1alR2U044YWda?=
 =?utf-8?B?aWtkZkY4MlBXdXp4N1MwZ1BPbktJaVd2V3EzYjhKd0hFK0NSeVRNdWx5eHJH?=
 =?utf-8?B?MDlHbmh0OVAzUGZpaWxqOU5yaCtjdmlscXZtM3FCNE1pcjlCVVd6NWxlOU1D?=
 =?utf-8?B?K1dPVzZ4bzd6N3ZPcytiWXo3ZEkyMCt0ZjFZSWY4R1g4NUQvNjVhY0tZODBu?=
 =?utf-8?B?a2xWVk5DTFVEeGpVV2NLQlEvdFhhS3hUOUl2bDVXWWxqRC9GTlF0TGNjM0lU?=
 =?utf-8?B?MzBXdnFmQ3FJOUY1clcvdVJJMHBjMTlLamdsU2xnUkI5aW04VVRxajZyQjdP?=
 =?utf-8?B?OXEyMUc5dE9vQjRjWENQMkxUQnpoektiWXhXbElsTWNyd0o2SUp6MDN5Y2wy?=
 =?utf-8?B?ck1QWVZJaEtzUVV0RDBVL3NEWUR1L3BsYkUrMnQzUGxFYy9PbU8yb1E2OUU3?=
 =?utf-8?B?V1ZGL2h0RTMvMk40NlBHeDNWbWt2REx3V2dsdjgxOU13Nld3bDRTc3F2L09I?=
 =?utf-8?B?ZE5pUFNiQzZ6dTMyc1pNOXFzZG1PMzBVR0dlQXpzeTA5V1JOc1RvRlJGUGk1?=
 =?utf-8?B?OWVSRlAyYTBCcG1kd2dkbHJSczRpL1ZHcjBkT3NaVFhBZWdZUkdXU3owN3BW?=
 =?utf-8?B?U0VzWFZiOC9VN3AyWEw0T0Vud3lWdkM1eHhDWWtka2ZwcndFMGRqWWRxTkRh?=
 =?utf-8?B?dlYzaGlicUFtN2tacFFiOVM0QWFVMGVlSnNOSVB0Q2ZUc2xhbDZrRmx1N0sz?=
 =?utf-8?B?VWZ5LzVOZ3RUM1Z2Tm5GRjJNaGhja3ozMUZFcmxYeVFIV3ZzQjQ1M3UyYkxP?=
 =?utf-8?B?OVhiVFRoVnJubTZ3dWpJRkM1NG9TS252UVREQ2dEa2NOc3lLaUk5Qk0wK1Y5?=
 =?utf-8?B?UHF1Vkxic1lqU1pPZnc0ZElGdEhvUzdGa1ErVEtHTGwzOSswL3NtODhpVitt?=
 =?utf-8?B?M0ZiVU1GN2RlNXFKaUxMeWprS2I4VnNodmtNT0E2Wk5qTjE1QS9QZkhvZmNw?=
 =?utf-8?B?dVhXbmNHaXB2ZmVOTE8yTUZRa3ZFcDMveXFrQ2VuakJIb2xoRm1jcllyN0Fk?=
 =?utf-8?B?ZnQwaERJNUppaGpaQm9GMjV6N3JjUHI3bXBJUWt5MjFxNjJTcDJYN3BabE5p?=
 =?utf-8?Q?eWDhjkQkOPyFqOIXVcftRwc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <56357A2D7CDA954B9091A800C84C0B80@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37215669-f404-49f5-dcee-08dac1484c71
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2022 05:15:49.0214
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Bv4DCopLHpgczZTnzY9hFgWoYA1dQ0w12tPVsSMdEhvte9DSy55uZqtalp4Hb5cp7DHZRn18LlAaomNu9saVIEjEkPc74C99MVRrTM1L0JQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7104
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIyLTExLTA3IGF0IDE0OjU3ICswMTAwLCBPbGVrc2lqIFJlbXBlbCB3cm90ZToN
Cj4gRVhURVJOQUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRz
IHVubGVzcyB5b3UNCj4ga25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo+IA0KPiBUaGVyZSBhcmUg
bm8gSFcgc3BlY2lmaWMgcmVnaXN0ZXJzLCBzbyB3ZSBjYW4gcHJvY2VzcyBhbGwgb2YgdGhlbQ0K
PiBpbiBvbmUgbG9jYXRpb24uDQoNClRlc3RlZCBpbiBLU1o5ODkzIGFuZCBMQU45Mzd4IGJ5IGNo
YW5naW5nIHRoZSBtdHUgdG8gbWF4X210dSB1c2luZw0KaWZjb25maWcuIEl0IHdvcmtzIGZpbmUu
DQoNCj4gDQo+IFNpZ25lZC1vZmYtYnk6IE9sZWtzaWogUmVtcGVsIDxvLnJlbXBlbEBwZW5ndXRy
b25peC5kZT4NCj4gLS0tDQo+ICBkcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzejk0NzcuYyAg
ICAgfCAgNSAtLS0tLQ0KPiAgZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3o5NDc3LmggICAg
IHwgIDEgLQ0KPiAgZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3o5NDc3X3JlZy5oIHwgIDIg
LS0NCj4gIGRyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6X2NvbW1vbi5jICB8IDIxICsrKysr
KysrKysrKysrKystLS0tLQ0KPiAgZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3pfY29tbW9u
LmggIHwgIDMgKystDQo+ICA1IGZpbGVzIGNoYW5nZWQsIDE4IGluc2VydGlvbnMoKyksIDE0IGRl
bGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAv
a3N6OTQ3Ny5jDQo+IGIvZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3o5NDc3LmMNCj4gaW5k
ZXggYTZhMDMyMWE4OTMxLi5lM2FkYjEyNmZkZmYgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0
L2RzYS9taWNyb2NoaXAva3N6OTQ3Ny5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2RzYS9taWNyb2No
aXAva3N6OTQ3Ny5jDQo+IEBAIC02MCwxMSArNjAsNiBAQCBpbnQga3N6OTQ3N19jaGFuZ2VfbXR1
KHN0cnVjdCBrc3pfZGV2aWNlICpkZXYsIGludA0KPiBwb3J0LCBpbnQgbXR1KQ0KPiAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgUkVHX1NXX01UVV9NQVNLLCBtYXhfZnJhbWUpOw0K
PiAgfQ0KPiANCj4gLWludCBrc3o5NDc3X21heF9tdHUoc3RydWN0IGtzel9kZXZpY2UgKmRldiwg
aW50IHBvcnQpDQo+IC17DQo+IC0gICAgICAgcmV0dXJuIEtTWjk0NzdfTUFYX0ZSQU1FX1NJWkUg
LSBWTEFOX0VUSF9ITEVOIC0gRVRIX0ZDU19MRU47DQo+IC19DQo+IC0NCj4gIHN0YXRpYyBpbnQg
a3N6OTQ3N193YWl0X3ZsYW5fY3RybF9yZWFkeShzdHJ1Y3Qga3N6X2RldmljZSAqZGV2KQ0KPiAg
ew0KPiAgICAgICAgIHVuc2lnbmVkIGludCB2YWw7DQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25l
dC9kc2EvbWljcm9jaGlwL2tzejk0NzcuaA0KPiBiL2RyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAv
a3N6OTQ3Ny5oDQo+IGluZGV4IDAwODYyYzRjZmI3Zi4uN2M1YmIzMDMyNzcyIDEwMDY0NA0KPiAt
LS0gYS9kcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzejk0NzcuaA0KPiArKysgYi9kcml2ZXJz
L25ldC9kc2EvbWljcm9jaGlwL2tzejk0NzcuaA0KPiBAQCAtNTAsNyArNTAsNiBAQCBpbnQga3N6
OTQ3N19tZGJfYWRkKHN0cnVjdCBrc3pfZGV2aWNlICpkZXYsIGludA0KPiBwb3J0LA0KPiAgaW50
IGtzejk0NzdfbWRiX2RlbChzdHJ1Y3Qga3N6X2RldmljZSAqZGV2LCBpbnQgcG9ydCwNCj4gICAg
ICAgICAgICAgICAgICAgICBjb25zdCBzdHJ1Y3Qgc3dpdGNoZGV2X29ial9wb3J0X21kYiAqbWRi
LCBzdHJ1Y3QNCj4gZHNhX2RiIGRiKTsNCj4gIGludCBrc3o5NDc3X2NoYW5nZV9tdHUoc3RydWN0
IGtzel9kZXZpY2UgKmRldiwgaW50IHBvcnQsIGludCBtdHUpOw0KPiAtaW50IGtzejk0NzdfbWF4
X210dShzdHJ1Y3Qga3N6X2RldmljZSAqZGV2LCBpbnQgcG9ydCk7DQo+ICB2b2lkIGtzejk0Nzdf
Y29uZmlnX2NwdV9wb3J0KHN0cnVjdCBkc2Ffc3dpdGNoICpkcyk7DQo+ICBpbnQga3N6OTQ3N19l
bmFibGVfc3RwX2FkZHIoc3RydWN0IGtzel9kZXZpY2UgKmRldik7DQo+ICBpbnQga3N6OTQ3N19y
ZXNldF9zd2l0Y2goc3RydWN0IGtzel9kZXZpY2UgKmRldik7DQo+IGRpZmYgLS1naXQgYS9kcml2
ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzejk0NzdfcmVnLmgNCj4gYi9kcml2ZXJzL25ldC9kc2Ev
bWljcm9jaGlwL2tzejk0NzdfcmVnLmgNCj4gaW5kZXggNTNjNjhkMjg2ZGQzLi5jYzQ1N2ZhNjQ5
MzkgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6OTQ3N19yZWcu
aA0KPiArKysgYi9kcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzejk0NzdfcmVnLmgNCj4gQEAg
LTE2MTUsNiArMTYxNSw0IEBADQo+ICAjZGVmaW5lIFBUUF9UUklHX1VOSVRfTSAgICAgICAgICAg
ICAgICAgICAgICAgIChCSVQoTUFYX1RSSUdfVU5JVCkgLQ0KPiAxKQ0KPiAgI2RlZmluZSBQVFBf
VFNfVU5JVF9NICAgICAgICAgICAgICAgICAgKEJJVChNQVhfVElNRVNUQU1QX1VOSVQpIC0gMSkN
Cj4gDQo+IC0jZGVmaW5lIEtTWjk0NzdfTUFYX0ZSQU1FX1NJWkUgICAgICAgICA5MDAwDQo+IC0N
Cj4gICNlbmRpZiAvKiBLU1o5NDc3X1JFR1NfSCAqLw0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9u
ZXQvZHNhL21pY3JvY2hpcC9rc3pfY29tbW9uLmMNCj4gYi9kcml2ZXJzL25ldC9kc2EvbWljcm9j
aGlwL2tzel9jb21tb24uYw0KPiBpbmRleCBkNjEyMTgxYjMyMjYuLjQ4NmFkMDNkMGFjZiAxMDA2
NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3pfY29tbW9uLmMNCj4gKysr
IGIvZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3pfY29tbW9uLmMNCj4gQEAgLTE0LDYgKzE0
LDcgQEANCj4gICNpbmNsdWRlIDxsaW51eC9waHkuaD4NCj4gICNpbmNsdWRlIDxsaW51eC9ldGhl
cmRldmljZS5oPg0KPiAgI2luY2x1ZGUgPGxpbnV4L2lmX2JyaWRnZS5oPg0KPiArI2luY2x1ZGUg
PGxpbnV4L2lmX3ZsYW4uaD4NCj4gICNpbmNsdWRlIDxsaW51eC9pcnEuaD4NCj4gICNpbmNsdWRl
IDxsaW51eC9pcnFkb21haW4uaD4NCj4gICNpbmNsdWRlIDxsaW51eC9vZl9tZGlvLmg+DQo+IEBA
IC0yMDYsNyArMjA3LDYgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBrc3pfZGV2X29wcyBrc3o5NDc3
X2Rldl9vcHMgPQ0KPiB7DQo+ICAgICAgICAgLm1kYl9hZGQgPSBrc3o5NDc3X21kYl9hZGQsDQo+
ICAgICAgICAgLm1kYl9kZWwgPSBrc3o5NDc3X21kYl9kZWwsDQo+ICAgICAgICAgLmNoYW5nZV9t
dHUgPSBrc3o5NDc3X2NoYW5nZV9tdHUsDQo+IC0gICAgICAgLm1heF9tdHUgPSBrc3o5NDc3X21h
eF9tdHUsDQo+ICAgICAgICAgLnBoeWxpbmtfbWFjX2xpbmtfdXAgPSBrc3o5NDc3X3BoeWxpbmtf
bWFjX2xpbmtfdXAsDQo+ICAgICAgICAgLmNvbmZpZ19jcHVfcG9ydCA9IGtzejk0NzdfY29uZmln
X2NwdV9wb3J0LA0KPiAgICAgICAgIC5lbmFibGVfc3RwX2FkZHIgPSBrc3o5NDc3X2VuYWJsZV9z
dHBfYWRkciwNCj4gQEAgLTI0Myw3ICsyNDMsNiBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IGtzel9k
ZXZfb3BzIGxhbjkzN3hfZGV2X29wcyA9DQo+IHsNCj4gICAgICAgICAubWRiX2FkZCA9IGtzejk0
NzdfbWRiX2FkZCwNCj4gICAgICAgICAubWRiX2RlbCA9IGtzejk0NzdfbWRiX2RlbCwNCj4gICAg
ICAgICAuY2hhbmdlX210dSA9IGxhbjkzN3hfY2hhbmdlX210dSwNCj4gLSAgICAgICAubWF4X210
dSA9IGtzejk0NzdfbWF4X210dSwNCj4gICAgICAgICAucGh5bGlua19tYWNfbGlua191cCA9IGtz
ejk0NzdfcGh5bGlua19tYWNfbGlua191cCwNCj4gICAgICAgICAuY29uZmlnX2NwdV9wb3J0ID0g
bGFuOTM3eF9jb25maWdfY3B1X3BvcnQsDQo+ICAgICAgICAgLmVuYWJsZV9zdHBfYWRkciA9IGtz
ejk0NzdfZW5hYmxlX3N0cF9hZGRyLA0KPiBAQCAtMjQ3MywxMCArMjQ3MiwyMiBAQCBzdGF0aWMg
aW50IGtzel9tYXhfbXR1KHN0cnVjdCBkc2Ffc3dpdGNoICpkcywNCj4gaW50IHBvcnQpDQo+ICB7
DQo+ICAgICAgICAgc3RydWN0IGtzel9kZXZpY2UgKmRldiA9IGRzLT5wcml2Ow0KPiANCj4gLSAg
ICAgICBpZiAoIWRldi0+ZGV2X29wcy0+bWF4X210dSkNCj4gLSAgICAgICAgICAgICAgIHJldHVy
biAtRU9QTk9UU1VQUDsNCj4gKyAgICAgICBzd2l0Y2ggKGRldi0+Y2hpcF9pZCkgew0KPiArICAg
ICAgIGNhc2UgS1NaODU2M19DSElQX0lEOg0KPiArICAgICAgIGNhc2UgS1NaOTQ3N19DSElQX0lE
Og0KPiArICAgICAgIGNhc2UgS1NaOTU2N19DSElQX0lEOg0KPiArICAgICAgIGNhc2UgS1NaOTg5
M19DSElQX0lEOg0KPiArICAgICAgIGNhc2UgS1NaOTg5Nl9DSElQX0lEOg0KPiArICAgICAgIGNh
c2UgS1NaOTg5N19DSElQX0lEOg0KPiArICAgICAgIGNhc2UgTEFOOTM3MF9DSElQX0lEOg0KPiAr
ICAgICAgIGNhc2UgTEFOOTM3MV9DSElQX0lEOg0KPiArICAgICAgIGNhc2UgTEFOOTM3Ml9DSElQ
X0lEOg0KPiArICAgICAgIGNhc2UgTEFOOTM3M19DSElQX0lEOg0KPiArICAgICAgIGNhc2UgTEFO
OTM3NF9DSElQX0lEOg0KPiArICAgICAgICAgICAgICAgcmV0dXJuIEtTWjk0NzdfTUFYX0ZSQU1F
X1NJWkUgLSBWTEFOX0VUSF9ITEVOIC0NCj4gRVRIX0ZDU19MRU47DQo+ICsgICAgICAgfQ0KPiAN
Cj4gLSAgICAgICByZXR1cm4gZGV2LT5kZXZfb3BzLT5tYXhfbXR1KGRldiwgcG9ydCk7DQo+ICsg
ICAgICAgcmV0dXJuIC1FT1BOT1RTVVBQOw0KPiAgfQ0KPiANCj4gIHN0YXRpYyB2b2lkIGtzel9z
ZXRfeG1paShzdHJ1Y3Qga3N6X2RldmljZSAqZGV2LCBpbnQgcG9ydCwNCj4gZGlmZiAtLWdpdCBh
L2RyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6X2NvbW1vbi5oDQo+IGIvZHJpdmVycy9uZXQv
ZHNhL21pY3JvY2hpcC9rc3pfY29tbW9uLmgNCj4gaW5kZXggOWNmYTE3OTU3NWNlLi43ZGU1MDcw
NjM3ZWMgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6X2NvbW1v
bi5oDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6X2NvbW1vbi5oDQo+IEBA
IC0zMjAsNyArMzIwLDYgQEAgc3RydWN0IGtzel9kZXZfb3BzIHsNCj4gICAgICAgICB2b2lkICgq
Z2V0X2NhcHMpKHN0cnVjdCBrc3pfZGV2aWNlICpkZXYsIGludCBwb3J0LA0KPiAgICAgICAgICAg
ICAgICAgICAgICAgICAgc3RydWN0IHBoeWxpbmtfY29uZmlnICpjb25maWcpOw0KPiAgICAgICAg
IGludCAoKmNoYW5nZV9tdHUpKHN0cnVjdCBrc3pfZGV2aWNlICpkZXYsIGludCBwb3J0LCBpbnQg
bXR1KTsNCj4gLSAgICAgICBpbnQgKCptYXhfbXR1KShzdHJ1Y3Qga3N6X2RldmljZSAqZGV2LCBp
bnQgcG9ydCk7DQo+ICAgICAgICAgdm9pZCAoKmZyZWV6ZV9taWIpKHN0cnVjdCBrc3pfZGV2aWNl
ICpkZXYsIGludCBwb3J0LCBib29sDQo+IGZyZWV6ZSk7DQo+ICAgICAgICAgdm9pZCAoKnBvcnRf
aW5pdF9jbnQpKHN0cnVjdCBrc3pfZGV2aWNlICpkZXYsIGludCBwb3J0KTsNCj4gICAgICAgICB2
b2lkICgqcGh5bGlua19tYWNfY29uZmlnKShzdHJ1Y3Qga3N6X2RldmljZSAqZGV2LCBpbnQgcG9y
dCwNCj4gQEAgLTU4NSw2ICs1ODQsOCBAQCBzdGF0aWMgaW5saW5lIGludCBpc19sYW45Mzd4KHN0
cnVjdCBrc3pfZGV2aWNlDQo+ICpkZXYpDQo+IA0KPiAgI2RlZmluZSBQT1JUX1NSQ19QSFlfSU5U
ICAgICAgICAgICAgICAgMQ0KPiANCj4gKyNkZWZpbmUgS1NaOTQ3N19NQVhfRlJBTUVfU0laRSAg
ICAgICAgIDkwMDANCj4gKw0KPiAgLyogUmVnbWFwIHRhYmxlcyBnZW5lcmF0aW9uICovDQo+ICAj
ZGVmaW5lIEtTWl9TUElfT1BfUkQgICAgICAgICAgMw0KPiAgI2RlZmluZSBLU1pfU1BJX09QX1dS
ICAgICAgICAgIDINCj4gLS0NCj4gMi4zMC4yDQo+IA0K
