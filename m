Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 583456024AA
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 08:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbiJRGoL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 02:44:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbiJRGoJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 02:44:09 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3D59A87A2;
        Mon, 17 Oct 2022 23:44:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1666075449; x=1697611449;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=LeczvDQR7VgQIX50rTCP8yNnj7jxMZUemA5huVkCL/g=;
  b=AqQl1Di8ZuzANnXWVGK0oeVdDgkXi4XaSXJW+SMiXX7AgQxdEqXlhC1I
   v6/5TuGJulVPfHKULsXs3hdmHJwAYfxDchPglxue+S74VWCA+93hrz4gc
   LDKHrjnnsJZhCdnIMtKJ96wIvoRZwpNwTLtoAE9ExZMh2z4jiGdQ4DwQg
   TOvBS/hHr0ajyyOMyS9abLPOH+U5Q/YD7Slm/aHFt50XRP7XvbPpNGbsd
   sPAmw776JVlYDp1e7LUfIcsMGQIclYq9ny1Qux22SdC3aMM3zXrJQepUK
   whqCWbD7iHz1YhlO/jYlmKMdY/NKDL5UzdaJjBW0dwC/WLzigZl/lxnJx
   w==;
X-IronPort-AV: E=Sophos;i="5.95,193,1661842800"; 
   d="scan'208";a="179284216"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Oct 2022 23:44:08 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 17 Oct 2022 23:44:06 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12 via Frontend Transport; Mon, 17 Oct 2022 23:44:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ix1jh0LMU/42OsYt4SOTI2dLMB8AeueWKOq4fcSkL8XPZzo3jrn6IR9x/Vy8WZIGkz0iZ5hXB4DRLzfWUdVToSOFoFJHRiZBg/JQaZwMTHS0RoziDU/LJ9eHzmR0rltMEFA96uENj6CwHGoG2cy18Tw1+Zhu1FuXUjiaZFnMtBNTfFAHrUdBN5oxsBYHPXBLTIxh8IEXlirJ3M8YKL8ktDd4qbywfHGgfSs9BlH13UVi0L74eKtG8Aixy3A/b3AMHpz7pTEEfRS4mNzWAIuUhLAAg7YOcPcjIAHXGZGix6EKzI4b7lctQEBXjv99IEagwi8QpzvMfNMeyyQD1yNoiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LeczvDQR7VgQIX50rTCP8yNnj7jxMZUemA5huVkCL/g=;
 b=PWNxlnuPcqx/A9w/Apqmj0vMCUBt+yAwqBKPR/JfcmQtjs71xJxYAeZcmonqP97zuyjEeGIAHSnP9t4jDRiDwylyBoL0KTpJwu/r+67YdyzyuZxBP+eyNVzCDh4rvpM/30HsG5Kj1d4muuVZyOBlm/BmhGj7TRzubgUomhR9/ySmHSrqd8pl6pR3QJigwOaxVTRo4S0vHwow/aKhENaPfb/cx3UF/7O2efZ/eKcFpGWS3S7ZRTYE9JEN3FaeXGwgbVr0646TzHjN0dPiQRT0Vo5TPbYFsuhW1nqnCJ/M+WETsaA6iZmO8sIpNqvXrcYDDSk73+wZJyrzZ7B59DU3Lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LeczvDQR7VgQIX50rTCP8yNnj7jxMZUemA5huVkCL/g=;
 b=dI+vDIz4zBhDYW/Kcraw5v0VSwHG2tb7y4CSq8f/KXOr6jUVCdKIB0jHaBYDkGpjT9BZ3Gt3hw+30fyf/hUsQ+C1kvChx75AOsagHQNa/a5Z4IlxXakHiDoazcOue4OWZ8CMAs4HVVPJCkQxsy8MVEl7y1y3nfIkNSpRFM9Dwdk=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 MN2PR11MB4728.namprd11.prod.outlook.com (2603:10b6:208:261::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.32; Tue, 18 Oct
 2022 06:44:05 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::faca:fe8a:e6fa:2d7]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::faca:fe8a:e6fa:2d7%3]) with mapi id 15.20.5723.033; Tue, 18 Oct 2022
 06:44:05 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <olteanv@gmail.com>
CC:     <andrew@lunn.ch>, <linux-kernel@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <vivien.didelot@gmail.com>,
        <linux@armlinux.org.uk>, <ceggers@arri.de>,
        <Tristram.Ha@microchip.com>, <f.fainelli@gmail.com>,
        <kuba@kernel.org>, <edumazet@google.com>, <pabeni@redhat.com>,
        <richardcochran@gmail.com>, <netdev@vger.kernel.org>,
        <Woojung.Huh@microchip.com>, <davem@davemloft.net>,
        <b.hutchman@gmail.com>
Subject: Re: [RFC Patch net-next 0/6] net: dsa: microchip: add gPTP support
 for LAN937x switch
Thread-Topic: [RFC Patch net-next 0/6] net: dsa: microchip: add gPTP support
 for LAN937x switch
Thread-Index: AQHY3+HGUZklSl35HUmvWc+BxQ194q4S2WcAgADg2oA=
Date:   Tue, 18 Oct 2022 06:44:04 +0000
Message-ID: <77959874a88756045ae13e0efede5e697be44a7b.camel@microchip.com>
References: <20221014152857.32645-1-arun.ramadoss@microchip.com>
         <20221017171916.oszpyxfnblezee6u@skbuf>
In-Reply-To: <20221017171916.oszpyxfnblezee6u@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB0076:EE_|MN2PR11MB4728:EE_
x-ms-office365-filtering-correlation-id: 3ec5277d-19c3-412c-016a-08dab0d42649
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BLUOkr4SiWrDAW2ZkSGbRLTZU8Qx3MEoeSMm+gS4DKxXBPAHL+CL2Kd/mhrbNAmuzqJEyni2DAwMLEXuPs00GslikRT2nv/Z8pL3nehPZ4KrWye9gHxvlsYIbwcaTq78FNqtOFR/TwpjRgR3V1PRfQG2sO8to9E/7ImRK04jWc3WHudfRvmfEpymRuUZH33WQS7G1y4OOU4C8HE4R5OkyDamzf1zQqk4gOHM99yF/xV4+kue8PcklehW3nV+lXWd9+JnMdiSNFTdwArOKZ1V4qnUvep1NIbgfPnkJh23R+Do3zh6PY3DIKH1cRtQOF0cVxiUq0xh6JGHcIjyoJxPDzsVmmlf4aTAe5xF34LLdnJwShnq/+tuC8WvqpU+tJ78VgkDucbIY37j1NlhKtV630CuvIM8mqbkXWMC7K3PB/1aH/c33TPuACOG7v7zPa8e1Muu3lbLBb+z+zZ6sp8nWVk8XgEKbfBPNnsx8eJ+swCfQvlidUaufgUyF4e+mmpENEd+reIzBwrdqk+zDcUwfT89nBXxWomUi7uNpdA6JAHMMjmjLSdMxyIxgztKp+uWQtuXgge7W2i/47fHPKwCZJGnl4d0Cx9oefqxFYRI8tngP1saDefOpZJsrbzPbdNUe6HHL0LnqszSU7OTTn61EGocPWnrVNlBeTRrnUGsqIqb4alI+LUhCUcfwA3RXHmMUDw6E2KJHEYQC3YVd1xdwzcKeogSgQVvr58qJHdgxNg2SPvt8c8rwUgF054upw/ZWxs2oN7MnkILsl0nQDBzwpCEhPsW5Wd39NVUlecEBXPHTci77CTBRGul2LUKU5b1
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(366004)(39860400002)(376002)(396003)(451199015)(54906003)(2616005)(186003)(38070700005)(83380400001)(86362001)(5660300002)(38100700002)(122000001)(7416002)(4001150100001)(2906002)(4326008)(64756008)(41300700001)(8936002)(8676002)(478600001)(6512007)(966005)(26005)(6486002)(6506007)(91956017)(316002)(66476007)(66556008)(66446008)(66946007)(76116006)(71200400001)(6916009)(36756003)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RnRKdklNM1hrdmNSOFJFR2djTW1wOS9jK0Q2dlBpQ0FydXZIR2NvLzQ4U2Fm?=
 =?utf-8?B?Vm5oL09rb3RHb1dTbnpoam9aaE03ZVFVQW9aUWdHcExMT0tZdDdMZW0zTy9W?=
 =?utf-8?B?QXpwSzZjRjdKdk50MVBzZ0FZZ3JnN0FkM1dLWkZYeVAxVVloNzNUeUsvbW1Q?=
 =?utf-8?B?NjRrbVJXaWc4NkpidUxZNDNRaWg0VjZWWXVjSXNOUnN5M1lHWlFzU0pFYkNE?=
 =?utf-8?B?Q3NTYVJuN2hkelZQS2s3b0wxQ3JYVUFkNkx2R013b0lubUtwYnFIV1dYRnIw?=
 =?utf-8?B?NU9GMHNOYXZhVUVodGFpdUNCTG9XLzhuMWNzYWt5R3VaWWhZRXkvNTY1NWUy?=
 =?utf-8?B?cHFNbW1RYlVVcnNHU0NIQW9mWDJTSC9QdlpsajRDbC8wVExYN2gvVUpqb2hQ?=
 =?utf-8?B?MmZ4cVgzcCtsNUhaUGdzWkoyNUN3L3JIbTNtU08rUUk5WmlYU21aSndnWGUw?=
 =?utf-8?B?UXZkd0pqcnl5cWIvcm5ncVQ4OThCaTNEVXJlUDZTYUxiUVBUTjFyak9lNS9h?=
 =?utf-8?B?ekYrekowSUh6dWo1YWZyS2Vrb05mR1RQLysyaWl3SW43bC9iKzFJbHNISG9X?=
 =?utf-8?B?YUVoTGpyaitQK2w1cWkrNXlQQ2ppRktFbmNydXVWazdnZUtWUVNtV2NPRzN3?=
 =?utf-8?B?d1Vpa0VsVHBWOC9Rd3VqcGNKMXJzbW9lVGVhYUVEem84RG5GUWcvNUE4cHhs?=
 =?utf-8?B?N1dFL3Q5Ny9PenJ2OWpZbmhoVnoxRFNiR0JVKzZsNS9CWEI2NkdMdXVCS2Ni?=
 =?utf-8?B?OHRiN2tHYU1Sa09JdHM5ZTRRMWk1Szl5ZmpJRlFXdktTd1V4T25VbktCOTQv?=
 =?utf-8?B?SkxEc0RuK1M0cllhN3ZsdmlLMENPb2dCODAzeXZGeHpFWGJ3eDM0MXVHdmhO?=
 =?utf-8?B?RHhXRnlxeW5VVHVybmEyT0swNkk4V1BYL0REQWpKZ2lEZlBoQlNJRU4wWlpa?=
 =?utf-8?B?SXhxa0JFMlhrMGViV1JGTVJmbUlqSURMd1l0eWZueUFyYzhkNmJiOHp0K2Qz?=
 =?utf-8?B?UHRxWEJiQUk1cG52U1lha1k0enJJazRlZ1R1VnB1MFhNaFgyY0RvVjQ4eVo0?=
 =?utf-8?B?WjlicUxBVXlzQ2JOOWRSWlhBSDJ2MUttKytGS1J4TWp0V1lLRFJIMkFrcWZs?=
 =?utf-8?B?MnRuUGJ3MFRpSmZzekFhdWxGcFZON1ZMcmhIL2pCU0NTblBzakN1ZktISkRF?=
 =?utf-8?B?M3h3Zy9MQTZSNE5EOTJtbCtXMzR0RGw2RlJ5eGtQYk9vVkg2ZGROR05HdGJy?=
 =?utf-8?B?M2s3R3JQY29kN0pobE4xRkVvajVLMDFHcEpGQjdIYTl2Y1BXOTZpbThDTTdT?=
 =?utf-8?B?bWxteVdBZmV0R2JnQjVHOTlva1ptNzhkQk56QUxMU1RiM3BKVktZYUIxakJ1?=
 =?utf-8?B?aU83ZndsN2dlbzRzcHJ2YndUV1o2bnMzRDNsNGhOSWdYdmxuOUF1TEFPbzJn?=
 =?utf-8?B?TktMeHJlQ1FuN2RDaGtZUUEzV1FlYUUxS2R6KzlSRTJ2azFaUTRFLzNYS09o?=
 =?utf-8?B?a2NNTTJYSXA2VElRTy9VbXQ0VXpraUZkcFZpM0RWeWQxYXpZanVNamRQQ28x?=
 =?utf-8?B?YWR1T05oYlBqOFpUZThSL0VaQzFmaHlBYW14cFo0aHFXcy9keHdSUzBiaWU0?=
 =?utf-8?B?Z3g4bnhPTEcySjNMckxqQ1A5L21WQ2hKNitFZEpQbEFpYzVDQUVtZ0ZMeHh4?=
 =?utf-8?B?ZklVSE5sUnhDTWtzNXZXaFZEVjZSaVVqUFRSZko5NWt5d0xLWXM4cUdKSE5x?=
 =?utf-8?B?Yyt1NXlUdHQ2M21OSGdyTzFRdm9wNkFJeitxUndFNVIrRFI3U3JsU2xwVnZw?=
 =?utf-8?B?a1l3MjZhZ3ExMm1YTVdoQjVZK3pMR3VKMTV6N0txZlVjYjNNYmZtZGl4YTgr?=
 =?utf-8?B?UGJxSGRMd2ZXLyszYjdWUmE1bmVVTkpYQW4yeDF1M0Z4Um9HV1B1T1R3cStq?=
 =?utf-8?B?NTUwNENrSzMzYlZidXJQTEk2aC8yVlJZRFEyODI1UHJQell3Tlk1aFpYM1Jl?=
 =?utf-8?B?Vms5a05iRUIySXpCQzRkTXZETUlBNTV2bG1KR3lNNzQyTU9aZ0JzQmNTQUNR?=
 =?utf-8?B?VTA2eStOYzJRb3ovK1FpR2NvZGxwTVJ2ZW04NnhpczZ0TXViaGpCQUFLKzgy?=
 =?utf-8?B?QkxidDhxdS9jN1dNNkMvZXplY0oxT1RYMmxsWFRxRG9KN0lxVDRIdkJneUdU?=
 =?utf-8?Q?P66uv76YqekZlwv6c56ayk0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CA3DCA8FE524474E9631597558730EF9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ec5277d-19c3-412c-016a-08dab0d42649
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2022 06:44:04.7751
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m2vKFoiMTXqT8yz2P7E2YCAnbeKr2uxq7IjgBKI46ks8JeeifXEeOnnKJVp4fBjxGHuzPx4maJY9rtretcOgN8xfvjB2L0Y6dMs6Y0lwNO0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4728
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIyLTEwLTE3IGF0IDIwOjE5ICswMzAwLCBWbGFkaW1pciBPbHRlYW4gd3JvdGU6
DQo+IEVYVEVSTkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50
cyB1bmxlc3MgeW91DQo+IGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCg0KSGkgVmxhZGlt
aXIsDQpUaGFua3MgZm9yIHRoZSBjb21tZW50Lg0KDQo+IEhpIEFydW4sDQo+IA0KPiBPbiBGcmks
IE9jdCAxNCwgMjAyMiBhdCAwODo1ODo1MVBNICswNTMwLCBBcnVuIFJhbWFkb3NzIHdyb3RlOg0K
PiA+IFRoZSBMQU45Mzd4IHN3aXRjaCBoYXMgY2FwYWJsZSBmb3Igc3VwcG9ydGluZyBJRUVFIDE1
ODggUFRQDQo+ID4gcHJvdG9jb2wuIFRoaXMNCj4gPiBwYXRjaCBzZXJpZXMgYWRkIGdQVFAgcHJv
ZmlsZSBzdXBwb3J0IGFuZCB0ZXN0ZWQgdXNpbmcgdGhlIHB0cDRsDQo+ID4gYXBwbGljYXRpb24u
DQo+ID4gTEFOOTM3eCBoYXMgdGhlIHNhbWUgUFRQIHJlZ2lzdGVyIHNldCBzaW1pbGFyIHRvIEtT
Wjk1NjMsIGhlbmNlIHRoZQ0KPiA+IGltcGxlbWVudGF0aW9uIGhhcyBiZWVuIG1hZGUgY29tbW9u
IGZvciB0aGUga3N6IHN3aXRjaGVzLiBCdXQgdGhlDQo+ID4gdGVzdGluZyBpcw0KPiA+IGRvbmUg
b25seSBmb3IgbGFuOTM3eCBzd2l0Y2guDQo+IA0KPiBXb3VsZCBpdCBiZSBwb3NzaWJsZSB0byBh
Y3R1YWxseSB0ZXN0IHRoZXNlIHBhdGNoZXMgb24gS1NaOTU2Mz8NCj4gDQo+IENocmlzdGlhbiBF
Z2dlcnMgdHJpZWQgdG8gYWRkIFBUUCBzdXBwb3J0IGZvciB0aGlzIHN3aXRjaCBhIHdoaWxlDQo+
IGFnbywNCj4gYW5kIGhlIGNsYWltcyB0aGF0IHR3by1zdGVwIFRYIHRpbWVzdGFtcGluZyB3YXMg
ZGUtZmVhdHVyZWQgZm9yDQo+IEtTWjk1eHgNCj4gZHVlIHRvIGhhcmR3YXJlIGVycmF0YS4NCj4g
DQpodHRwczovL3BhdGNod29yay5vemxhYnMub3JnL3Byb2plY3QvbmV0ZGV2L3BhdGNoLzIwMjAx
MDE5MTcyNDM1LjQ0MTYtOC1jZWdnZXJzQGFycmkuZGUvDQoNCkkgaGFkIGRldmVsb3BlZCB0aGlz
IHBhdGNoIHNldCB0byBhZGQgZ1BUUCBzdXBwb3J0IGZvciBMQU45Mzd4IGJhc2VkIG9uDQp0aGUg
Q2hyaXN0aWFuIGVnZ2VycyBwYXRjaCBmb3IgS1NaOTU2My4gSW5pdGlhbGx5IEkgdGhvdWdodCBv
ZiBrZWVwaW5nDQppbXBsZW1lbnRhdGlvbiBzcGVjaWZpYyB0byBMQU45Mzd4IHRocm91Z2ggbGFu
OTM3eF9wdHAuYyBmaWxlcy4gU2luY2UNCnRoZSByZWdpc3RlciBzZXRzIGFyZSBzYW1lIGZvciBM
QU45Mzd4L0tTWjk1NjMsIEkgZGV2ZWxvcGVkIHVzaW5nDQprc3pfcHRwLmMgc28gdGhhdCBpbiBm
dXR1cmUgQ2hyaXN0YWluIGVnZ2VycyBwYXRjaCBjYW4gYmUgbWVyZ2VkIHRvIGl0DQp0byBzdXBw
b3J0IHRoZSAxIHN0ZXAgY2xvY2sgc3VwcG9ydC4NCkkgcmVhZCB0aGUgSGFyZHdhcmUgZXJyYXRh
IG9mIEtTWjk1eHggb24gMiBzdGVwIGNsb2NrIGFuZCBmb3VuZCB0aGF0IGl0DQp3YXMgZml4ZWQg
aW4gTEFOOTM3eCBzd2l0Y2hlcy4gSWYgdGhpcyBpcyBjYXNlLCBEbyBJIG5lZWQgdG8gbW92ZSB0
aGlzDQoyIHN0ZXAgdGltZXN0YW1waW5nIHNwZWNpZmljIHRvIExBTjkzN3ggYXMgTEFOOTM3eF9w
dHAuYyAmIG5vdCBjbGFpbQ0KZm9yIGtzejk1NjMgb3IgY29tbW9uIGltcGxlbWVudGF0aW9uIGlu
IGtzel9wdHAuYyAmIGV4cG9ydCB0aGUNCmZ1bmN0aW9uYWxpdHkgYmFzZWQgb24gY2hpcC1pZCBp
biBnZXRfdHNfaW5mbyBkc2EgaG9va3MuDQoNCi0tDQpBcnVuDQoNCj4gDQo+ID4gDQo+ID4gQXJ1
biBSYW1hZG9zcyAoNik6DQo+ID4gICBuZXQ6IGRzYTogbWljcm9jaGlwOiBhZGRpbmcgdGhlIHBv
c2l4IGNsb2NrIHN1cHBvcnQNCj4gPiAgIG5ldDogZHNhOiBtaWNyb2NoaXA6IEluaXRpYWwgaGFy
ZHdhcmUgdGltZSBzdGFtcGluZyBzdXBwb3J0DQo+ID4gICBuZXQ6IGRzYTogbWljcm9jaGlwOiBN
YW5pcHVsYXRpbmcgYWJzb2x1dGUgdGltZSB1c2luZyBwdHAgaHcNCj4gPiBjbG9jaw0KPiA+ICAg
bmV0OiBkc2E6IG1pY3JvY2hpcDogZW5hYmxlIHRoZSBwdHAgaW50ZXJydXB0IGZvciB0aW1lc3Rh
bXBpbmcNCj4gPiAgIG5ldDogZHNhOiBtaWNyb2NoaXA6IEFkZGluZyB0aGUgcHRwIHBhY2tldCBy
ZWNlcHRpb24gbG9naWMNCj4gPiAgIG5ldDogZHNhOiBtaWNyb2NoaXA6IGFkZCB0aGUgdHJhbnNt
aXNzaW9uIHRzdGFtcCBsb2dpYw0KPiA+IA0KPiA+ICBkcml2ZXJzL25ldC9kc2EvbWljcm9jaGlw
L0tjb25maWcgICAgICAgfCAgMTAgKw0KPiA+ICBkcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL01h
a2VmaWxlICAgICAgfCAgIDEgKw0KPiA+ICBkcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzel9j
b21tb24uYyAgfCAgNDMgKy0NCj4gPiAgZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3pfY29t
bW9uLmggIHwgIDMxICsNCj4gPiAgZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3pfcHRwLmMg
ICAgIHwgNzU1DQo+ID4gKysrKysrKysrKysrKysrKysrKysrKysrDQo+ID4gIGRyaXZlcnMvbmV0
L2RzYS9taWNyb2NoaXAva3N6X3B0cC5oICAgICB8ICA4NCArKysNCj4gPiAgZHJpdmVycy9uZXQv
ZHNhL21pY3JvY2hpcC9rc3pfcHRwX3JlZy5oIHwgIDY4ICsrKw0KPiA+ICBpbmNsdWRlL2xpbnV4
L2RzYS9rc3pfY29tbW9uLmggICAgICAgICAgfCAgNTMgKysNCj4gPiAgbmV0L2RzYS90YWdfa3N6
LmMgICAgICAgICAgICAgICAgICAgICAgIHwgMTU2ICsrKystDQo+ID4gIDkgZmlsZXMgY2hhbmdl
ZCwgMTE5MiBpbnNlcnRpb25zKCspLCA5IGRlbGV0aW9ucygtKQ0KPiA+ICBjcmVhdGUgbW9kZSAx
MDA2NDQgZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3pfcHRwLmMNCj4gPiAgY3JlYXRlIG1v
ZGUgMTAwNjQ0IGRyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6X3B0cC5oDQo+ID4gIGNyZWF0
ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzel9wdHBfcmVnLmgNCj4g
PiAgY3JlYXRlIG1vZGUgMTAwNjQ0IGluY2x1ZGUvbGludXgvZHNhL2tzel9jb21tb24uaA0KPiA+
IA0KPiA+IA0KPiA+IGJhc2UtY29tbWl0OiA2NmFlMDQzNjhlZmJlMjBlYjg5NTFjOWE3NjE1OGY5
OWNlNjcyZjI1DQo+ID4gLS0NCj4gPiAyLjM2LjENCj4gPiANCg==
