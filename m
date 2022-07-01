Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D336562D2A
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 09:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235685AbiGAHzU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 03:55:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235375AbiGAHzR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 03:55:17 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC8F86D56C;
        Fri,  1 Jul 2022 00:55:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1656662116; x=1688198116;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=8ip44PujCQtjjKyHRtI/nt5ehGL9Ou9pZeQKSiNN3ME=;
  b=owRBlQwJpQ6QH/Ih+pS8gjNOuoXjCXZ2ha7Sg4F+b8Yw4nK23jzrcdmL
   m6MAkWQJUwE/qd7pz+2xsZBI7KKSgsreY4UJ9oU/NEkCxSceHvg7rkvuA
   D9unFIP74J6Mui1h6Io4RNTGLWoaeP3oZnQYMWttw5atrwcDaZEA6D9kK
   Z4mStLmMvlN8gXx9VwHc2KD59R7sERJ0M4c1sYFalYkgmj/vWQyscEhqi
   qBUlKaEsEzs77EtVbK8/EA31KA6iL+XVXdrfdB9QL4cEgCajGxz0hzdcM
   15uJa2C6jRQIqi6mA4tnUT+/QHM2BNjGHTSAoDNmJOj2FOoS4d9k9psR6
   g==;
X-IronPort-AV: E=Sophos;i="5.92,236,1650956400"; 
   d="scan'208";a="180329621"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Jul 2022 00:55:16 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 1 Jul 2022 00:55:15 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Fri, 1 Jul 2022 00:55:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lTVcepf7tGVyzMECg8nkbzBcP4I1lhlthHqRZyw3sr9m0BGWl4d2V9Du5N1E72oGUKV20lGQR+eCuf8187J8tqPUYPb4U087K76wV82zXmXvV169O0RdFhEX9BhzyEr1P1/KVng29Yqw81tBMxdHVZl3izK6Eh0xPYrl1pNNre56PwjYauV1r2BcXs66DdaghZxqSlZDFAcCfxMbfKdUCPzKK3cL/9zMjJRiFWh45mokE/D+ev5bfemEwkf8LgTsIoV5O6UGtleAWHbqD5GDQiiRrjBl+MXCWPoLG/X0ON9NIGKTOoAlGd8psRYLNz7e5zDAcJyBm7fTmvYjfKmZvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8ip44PujCQtjjKyHRtI/nt5ehGL9Ou9pZeQKSiNN3ME=;
 b=CQWDaMoPHUdixwcbnoXuwDPEruMnkE2fVSesW1Pu5W3NEBLA4VSw+rgaLUkddxMG8/XQnmEVRp91zBTZHdAHQTOBEGrAVCv3CYeK4gJAbo3qN+lbqx688r6VKkmjrkCPydrrU6z0j2K5mwPBugoGP0+SBU+3ZMTHCtM/bKoyrEpooMDS4Lm9yXkOL+khTRJlhdQFb1HYh2MnEkQkDkwgZ5dtNy2ovfrM/uGGY88+POJII+muiiJ5xhTlICZpZsnvb3on556OqYxbT374DXsN7oYtw4fRvk8NU4kbctzJUonUnQNMvuBrJ7pQws5g+cszmj+OvU7tN5cwsFhsVCnNyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8ip44PujCQtjjKyHRtI/nt5ehGL9Ou9pZeQKSiNN3ME=;
 b=N2/VLA64tcheV1ptHBgLyAp35gX/8OZ8ggDqdbPqsiYvA3+pA5zyMNInMSUdLWeaFOx5p/1y9P+wh4ht1r70yCharJnpgXdzx/4HzgJ8AWFNJ/Y6Khuzy/KxCRfyGc95yZV3axg2yJdFB+Ds5xT+u5tNnqEQN/GtJHDJ/U1WEyw=
Received: from CO1PR11MB5154.namprd11.prod.outlook.com (2603:10b6:303:99::15)
 by BYAPR11MB2726.namprd11.prod.outlook.com (2603:10b6:a02:be::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Fri, 1 Jul
 2022 07:55:10 +0000
Received: from CO1PR11MB5154.namprd11.prod.outlook.com
 ([fe80::699b:5c23:de4f:2bfa]) by CO1PR11MB5154.namprd11.prod.outlook.com
 ([fe80::699b:5c23:de4f:2bfa%4]) with mapi id 15.20.5395.015; Fri, 1 Jul 2022
 07:55:10 +0000
From:   <Conor.Dooley@microchip.com>
To:     <Claudiu.Beznea@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <Nicolas.Ferre@microchip.com>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [net-next PATCH RESEND 2/2] net: macb: add polarfire soc reset
 support
Thread-Topic: [net-next PATCH RESEND 2/2] net: macb: add polarfire soc reset
 support
Thread-Index: AQHYjRgQ3x7EmTGw/U+0JO50iJROM61pI3YAgAACHIA=
Date:   Fri, 1 Jul 2022 07:55:10 +0000
Message-ID: <0d52afa2-6065-25c5-2010-46aaa0129b59@microchip.com>
References: <20220701065831.632785-1-conor.dooley@microchip.com>
 <20220701065831.632785-3-conor.dooley@microchip.com>
 <25230de4-4923-94b3-dcdb-e08efb733850@microchip.com>
In-Reply-To: <25230de4-4923-94b3-dcdb-e08efb733850@microchip.com>
Accept-Language: en-IE, en-US
Content-Language: en-IE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fe2f8980-a9f5-4e9b-626e-08da5b3705d8
x-ms-traffictypediagnostic: BYAPR11MB2726:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iexakNk3UPsk8dgcGrdcM28zAmKGCI79/K0gTHXfwEVcBACiXijZvckM5wcQLSPoZjONrybhxYPyeaKewXgWfo4RY4R/JhJCbCCq5bj9/i5MoXas6kGehE5YKF8YcJCj/CPRGwcO9QagO3s8BHays3SaIrXHOvDNhTv1sbWwlxQ5L8j6BOeaM9uEPmZHmx4YdeJzJft3nMtts7qkRsiW7tALLL/xFDgHcvrCj6r3sAgoki6LTDuPwppuDM0+INdG5dj3qxzouT50KGMwIhchak5rVQG3cICqMaIQxhCiBwerIDJIxfHjGHx/XrQwtpp/7vWoh1XpDFDfz5dzKKmhKHdszWexMxYSu0s4hbRWriU6Ev8I0nBv3JNon06IdV/qdQg1xPdRdWDANOgC/YkXdVoLxlktcIpC0BfFLHPgQCa1dTEY96k7FWJVV6ak/hDc8SEBBrmfM1M0f3S/jyAyhmR72adKHeS42ivlEI67X0m4VWOXT9Ste3SP0rPs2TIFZ2eqCp6e/hfyn4f1Q3DyTJBCRhaKmfso5Ywi1SlIRKNraSCCH5DiKrxFe214O3WOWCabi909zRKzyzFOKVL3YlpypljnN1cSP2D1h0z14bk7M3QcNz/6E8AUPWQI8Xe0PjcTAlhq9Dc5vCXXyfLPd3knx365zyG0KVMMuRSZjgduaSqun3D+Xbx8zvbibXeSwOUMPpcVQmj1O1Ng7OdZkMbKhDYdoMafEJ0g6fmfcvmXFMCRTjq1XqPOBMY54oMqyMhzxkI0GhGjFKKfhXAxWUTtAkEMUj2feAsB2Q94vGKLeDdZCUXgNxVhdUC7ielyHg03SPK55N3GrFhoWr8sVEoEYjb+QMO7GlmYf8qDVPsQQZYHVht8LcPz4e1sOnri
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5154.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(376002)(366004)(136003)(396003)(39860400002)(186003)(6506007)(2616005)(53546011)(7416002)(8936002)(122000001)(4326008)(83380400001)(54906003)(8676002)(31696002)(6512007)(41300700001)(26005)(91956017)(66446008)(86362001)(66556008)(66946007)(38100700002)(36756003)(64756008)(5660300002)(2906002)(110136005)(76116006)(316002)(66476007)(478600001)(38070700005)(6636002)(31686004)(71200400001)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bzVPVHpDcWlMSUxIaWxYRUJacVhnWUgyMjJrVzZ5dDRzNmlJMTZvYzcxUEs1?=
 =?utf-8?B?V21xR2psOWRLbkVyWmNGTk12enNGMHlMK0U4cGE1ZUVBYmJQM3NPWGU3b2VF?=
 =?utf-8?B?NVZGZFlrOHZIdWZrQnpWYkxRQVhKemhPK2tYZXFlTW10SFhWcUxndFUvNE0w?=
 =?utf-8?B?UDVBa1V4ZFNsclpFM1ROWlAyaHNHSnY1SlRQQ2RZQ2JDR0Q4VHpJNUt3bWdq?=
 =?utf-8?B?c2RMYmxiVjB3RGZNc2JwZGlmaTRFbDBKN3ljcWRzNjcwUDV0dHdnUVlBMW5i?=
 =?utf-8?B?VUFTTjFGU2Z2bzRzWHEzNVUxRVJxQmh3RytldlExNjV5QUNBMEplMmpvREI5?=
 =?utf-8?B?NGgvRU96Z2FMT2VBc3J3aEtJRU5OMjZZZHZ6MUlRS2pjRktBUU55NDh1TDhh?=
 =?utf-8?B?K21rUC9WeThDOHEwOU04c2FGbmdzK1hsRWdwZUVXOWJOL0pSVmdzVHdHVldZ?=
 =?utf-8?B?S1RrdHJtUVVPSXlEbXN4cHg3SHh6V3VUb1kwQXRyTnlMZXJnSE1Lbm5RcWxk?=
 =?utf-8?B?QUpKYm9TU3E3WFJmcHdUL1YzaHdweDJrMEg3L3FFb1dacE1wbk50MWNVYzgx?=
 =?utf-8?B?MkhMQmRlZHFsSHlyRjlrVnBOQVV5UVdIZFNsc2tyTjJQOGFRTlM4MWdCaWY3?=
 =?utf-8?B?NUs0dkJFM2RoemZMRXI4WlRxVlpwMGVsb1k2NjRVc2w1TmdwTmdra2IvU0do?=
 =?utf-8?B?b3dTazRvdWJhZmtRMjdtSTFWZFBxMXpmQ0pJaUl4WHV1bGFJQ3VGWHJEeUs3?=
 =?utf-8?B?dDU0Mnd2SVN2MEtKbGd3SlFRdHZYMkkxc3NSMkJlMDhBc0pRUHd1M2FDMFFO?=
 =?utf-8?B?OGdQOThqSmJSRHlpZitaQzlVVmR5NG9KQnZCQTlJeU5kajdPcTkxeUxYS0NP?=
 =?utf-8?B?dTIrWlozWlJIV3BVdTBaL1dTbEZ3c1JRamFTVitUUEtnM1k1YnNyVkJzVlV3?=
 =?utf-8?B?QlkreEY0UERoV3o2RXIxbHMrK0oySlFsczFrN2k0WjQ3czRCcEEzNFllY0tF?=
 =?utf-8?B?SlcrTkVoRzdqZDdnYXpVZkQrUnBXRmU0UGxlQzJxUTlsOE16S0tHTkFYWUtZ?=
 =?utf-8?B?NlRlK2IvUXNrTDdtYmlLL1k3SE1KNEhBYkhvVU14T1QzNjdXaHRsdHI0Z2g1?=
 =?utf-8?B?T1E1bVlYY3JZTFZEZWdUMDdyOXRXMjNCN1VTM3lKTVBwalFib1owVU5qZExN?=
 =?utf-8?B?WlBTQ2pic0lKeDYxWENCelZ3RU5lNlpCbUVNWFdOUGVxdkJ6Y0hCSWo3OVNH?=
 =?utf-8?B?NjlIZWdCd3kvNzg5d2dxcnV3NW9rQ1p2YnFFNVBldUNSSEhONVRhZFliUXlN?=
 =?utf-8?B?OEVHWDg2RkFJU3pQNjNlalN2L0RKNWJuUnFRU3FKUmRtd3VvOTB6c2t5LzBQ?=
 =?utf-8?B?K0FNWnBNNk85ZE5pNWxqdzdLTnhwM3l2bnJhY2VDOU5aUDYrWXdQenh2Tng0?=
 =?utf-8?B?aGFSclg2VXJXcy8xRkFtNHJTYXgxMlhnb0liRlVGM2JMeHMrTFZocXZHc2ho?=
 =?utf-8?B?NkEza1pKc2p6cG1ZaFoyckJBY0U0THVFTE5rNm9BSDIxa1lQK1dKUHp0dzd2?=
 =?utf-8?B?L0VGdzEyaS9qa1hvWHAxWnFUVzRkUzRyMzNtVFBkNklsZXFZTEpLeWROd2Vz?=
 =?utf-8?B?UW9Beml0TENaTmlBM1VsMUpSaVdkVmhjZ2ZsYkhjdTlJcHdmN0NnTXBCajUz?=
 =?utf-8?B?YXpFN2lUakd0NFZ4TlBBQmpOOCs1SHpTenNJcjMrRjBTTzczSzNqVlpHVEFp?=
 =?utf-8?B?RnVnNWVWNTNQM0g1ZEJrcHpBOVJEMEMvdWJ1bk1nRmhDUnZiWDFpdEJxTlZH?=
 =?utf-8?B?T2wxM2RqamVOejdqQ1dlMDlpQ25iUHdjeXBNa3VFTTlyR0F0TCsraFBxN0ow?=
 =?utf-8?B?TGlLQS9kdzR3WGsrclE2S2xZR1RLVUJTR0I5TVN6d3QxYzUzZ1Uva0RVbmlE?=
 =?utf-8?B?bkRoNUlHeXJZaW8zMEwrUlhVYndESmxoQUlIUHU0a0N1VGR5NUFHdHd0bzFD?=
 =?utf-8?B?NDdnYW8yTHAweXJHRENNcllpTndRSzNoL0xJdC9jbG9NL3pGcktkSFNoVkUr?=
 =?utf-8?B?eG9BaDEySkxtQkh3U3ZvN1N1SXFzRWRndXVpV1dvUDByZ05jdmJQc1g1dXNl?=
 =?utf-8?Q?3YoGrTmfHtA/yXYTEcHnmoKRB?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <33AB4E8BC619EE41BDAA909ADFAF26A3@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5154.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe2f8980-a9f5-4e9b-626e-08da5b3705d8
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jul 2022 07:55:10.5117
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RwajyDNq+5GIOjlS/5L3tBaBKbp9Dk6YQQPChfPfBowquZMSkPkwwfU0SvE12mr2amcrfnsrcFvkwRJuuQ0AnV/EbQBt0TUE9W8XzCQq9BY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2726
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMDEvMDcvMjAyMiAwODo0NywgQ2xhdWRpdSBCZXpuZWEgLSBNMTgwNjMgd3JvdGU6DQo+IE9u
IDAxLjA3LjIwMjIgMDk6NTgsIENvbm9yIERvb2xleSB3cm90ZToNCj4+IFRvIGRhdGUsIHRoZSBN
aWNyb2NoaXAgUG9sYXJGaXJlIFNvQyAoTVBGUykgaGFzIGJlZW4gdXNpbmcgdGhlDQo+PiBjZG5z
LG1hY2IgY29tcGF0aWJsZSwgaG93ZXZlciB0aGUgZ2VuZXJpYyBkZXZpY2UgZG9lcyBub3QgaGF2
ZSByZXNldA0KPj4gc3VwcG9ydC4gQWRkIGEgbmV3IGNvbXBhdGlibGUgJiAuZGF0YSBmb3IgTVBG
UyB0byBob29rIGludG8gdGhlIHJlc2V0DQo+PiBmdW5jdGlvbmFsaXR5IGFkZGVkIGZvciB6eW5x
bXAgc3VwcG9ydCAoYW5kIG1ha2UgdGhlIHp5bnFtcCBpbml0DQo+PiBmdW5jdGlvbiBnZW5lcmlj
IGluIHRoZSBwcm9jZXNzKS4NCj4+DQo+PiBTaWduZWQtb2ZmLWJ5OiBDb25vciBEb29sZXkgPGNv
bm9yLmRvb2xleUBtaWNyb2NoaXAuY29tPg0KPj4gLS0tDQo+PiAgIGRyaXZlcnMvbmV0L2V0aGVy
bmV0L2NhZGVuY2UvbWFjYl9tYWluLmMgfCAyNSArKysrKysrKysrKysrKysrKy0tLS0tLS0NCj4+
ICAgMSBmaWxlIGNoYW5nZWQsIDE4IGluc2VydGlvbnMoKyksIDcgZGVsZXRpb25zKC0pDQo+Pg0K
Pj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvbWFjYl9tYWluLmMg
Yi9kcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNlL21hY2JfbWFpbi5jDQo+PiBpbmRleCBkODkw
OThmNGVkZTguLjMyNWYwNDYzZmQ0MiAxMDA2NDQNCj4+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L2NhZGVuY2UvbWFjYl9tYWluLmMNCj4+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2Nh
ZGVuY2UvbWFjYl9tYWluLmMNCj4+IEBAIC00Njg5LDMzICs0Njg5LDMyIEBAIHN0YXRpYyBjb25z
dCBzdHJ1Y3QgbWFjYl9jb25maWcgbnA0X2NvbmZpZyA9IHsNCj4+ICAgCS51c3JpbyA9ICZtYWNi
X2RlZmF1bHRfdXNyaW8sDQo+PiAgIH07DQo+PiAgIA0KPj4gLXN0YXRpYyBpbnQgenlucW1wX2lu
aXQoc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldikNCj4+ICtzdGF0aWMgaW50IGluaXRfcmVz
ZXRfb3B0aW9uYWwoc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldikNCj4gDQo+IEl0IGRvZXNu
J3Qgc291bmQgbGlrZSBhIGdvb2QgbmFtZSBmb3IgdGhpcyBmdW5jdGlvbiBidXQgSSBkb24ndCBo
YXZlDQo+IHNvbWV0aGluZyBiZXR0ZXIgdG8gcHJvcG9zZS4NCg0KSXQncyBiZXR0ZXIgdGhhbiB6
eW5xbXBfaW5pdCwgYnV0IHllYWguLi4NCg0KPiANCj4+ICAgew0KPj4gICAJc3RydWN0IG5ldF9k
ZXZpY2UgKmRldiA9IHBsYXRmb3JtX2dldF9kcnZkYXRhKHBkZXYpOw0KPj4gICAJc3RydWN0IG1h
Y2IgKmJwID0gbmV0ZGV2X3ByaXYoZGV2KTsNCj4+ICAgCWludCByZXQ7DQo+PiAgIA0KPj4gICAJ
aWYgKGJwLT5waHlfaW50ZXJmYWNlID09IFBIWV9JTlRFUkZBQ0VfTU9ERV9TR01JSSkgew0KPj4g
LQkJLyogRW5zdXJlIFBTLUdUUiBQSFkgZGV2aWNlIHVzZWQgaW4gU0dNSUkgbW9kZSBpcyByZWFk
eSAqLw0KPj4gKwkJLyogRW5zdXJlIFBIWSBkZXZpY2UgdXNlZCBpbiBTR01JSSBtb2RlIGlzIHJl
YWR5ICovDQo+PiAgIAkJYnAtPnNnbWlpX3BoeSA9IGRldm1fcGh5X29wdGlvbmFsX2dldCgmcGRl
di0+ZGV2LCBOVUxMKTsNCj4+ICAgDQo+PiAgIAkJaWYgKElTX0VSUihicC0+c2dtaWlfcGh5KSkg
ew0KPj4gICAJCQlyZXQgPSBQVFJfRVJSKGJwLT5zZ21paV9waHkpOw0KPj4gICAJCQlkZXZfZXJy
X3Byb2JlKCZwZGV2LT5kZXYsIHJldCwNCj4+IC0JCQkJICAgICAgImZhaWxlZCB0byBnZXQgUFMt
R1RSIFBIWVxuIik7DQo+PiArCQkJCSAgICAgICJmYWlsZWQgdG8gZ2V0IFNHTUlJIFBIWVxuIik7
DQo+PiAgIAkJCXJldHVybiByZXQ7DQo+PiAgIAkJfQ0KPj4gICANCj4+ICAgCQlyZXQgPSBwaHlf
aW5pdChicC0+c2dtaWlfcGh5KTsNCj4+ICAgCQlpZiAocmV0KSB7DQo+PiAtCQkJZGV2X2Vycigm
cGRldi0+ZGV2LCAiZmFpbGVkIHRvIGluaXQgUFMtR1RSIFBIWTogJWRcbiIsDQo+PiArCQkJZGV2
X2VycigmcGRldi0+ZGV2LCAiZmFpbGVkIHRvIGluaXQgU0dNSUkgUEhZOiAlZFxuIiwNCj4+ICAg
CQkJCXJldCk7DQo+PiAgIAkJCXJldHVybiByZXQ7DQo+PiAgIAkJfQ0KPj4gICAJfQ0KPj4gICAN
Cj4+IC0JLyogRnVsbHkgcmVzZXQgR0VNIGNvbnRyb2xsZXIgYXQgaGFyZHdhcmUgbGV2ZWwgdXNp
bmcgenlucW1wLXJlc2V0IGRyaXZlciwNCj4+IC0JICogaWYgbWFwcGVkIGluIGRldmljZSB0cmVl
Lg0KPj4gKwkvKiBGdWxseSByZXNldCBjb250cm9sbGVyIGF0IGhhcmR3YXJlIGxldmVsIGlmIG1h
cHBlZCBpbiBkZXZpY2UgdHJlZQ0KPj4gICAJICovDQo+IA0KPiBUaGUgbmV3IGNvbW1lbnQgY2Fu
IGZpdCBvbiBhIHNpbmdsZSBsaW5lLg0KPiANCj4+ICAgCXJldCA9IGRldmljZV9yZXNldF9vcHRp
b25hbCgmcGRldi0+ZGV2KTsNCj4+ICAgCWlmIChyZXQpIHsNCj4+IEBAIC00NzM3LDcgKzQ3MzYs
NyBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IG1hY2JfY29uZmlnIHp5bnFtcF9jb25maWcgPSB7DQo+
PiAgIAkJCU1BQ0JfQ0FQU19HRU1fSEFTX1BUUCB8IE1BQ0JfQ0FQU19CRF9SRF9QUkVGRVRDSCwN
Cj4+ICAgCS5kbWFfYnVyc3RfbGVuZ3RoID0gMTYsDQo+PiAgIAkuY2xrX2luaXQgPSBtYWNiX2Ns
a19pbml0LA0KPj4gLQkuaW5pdCA9IHp5bnFtcF9pbml0LA0KPj4gKwkuaW5pdCA9IGluaXRfcmVz
ZXRfb3B0aW9uYWwsDQo+PiAgIAkuanVtYm9fbWF4X2xlbiA9IDEwMjQwLA0KPj4gICAJLnVzcmlv
ID0gJm1hY2JfZGVmYXVsdF91c3JpbywNCj4+ICAgfTsNCj4+IEBAIC00NzUxLDYgKzQ3NTAsMTcg
QEAgc3RhdGljIGNvbnN0IHN0cnVjdCBtYWNiX2NvbmZpZyB6eW5xX2NvbmZpZyA9IHsNCj4+ICAg
CS51c3JpbyA9ICZtYWNiX2RlZmF1bHRfdXNyaW8sDQo+PiAgIH07DQo+PiAgIA0KPj4gK3N0YXRp
YyBjb25zdCBzdHJ1Y3QgbWFjYl9jb25maWcgbXBmc19jb25maWcgPSB7DQo+PiArCS5jYXBzID0g
TUFDQl9DQVBTX0dJR0FCSVRfTU9ERV9BVkFJTEFCTEUgfA0KPj4gKwkJCU1BQ0JfQ0FQU19KVU1C
TyB8DQo+PiArCQkJTUFDQl9DQVBTX0dFTV9IQVNfUFRQLA0KPiANCj4gRXhjZXB0IGZvciB6eW5x
bXAgYW5kIGRlZmF1bHRfZ2VtX2NvbmZpZyB0aGUgcmVzdCBvZiB0aGUgY2FwYWJpbGl0aWVzIGZv
cg0KPiBvdGhlciBTb0NzIGFyZSBhbGlnbmVkIHNvbWV0aGluZyBsaWtlIHRoaXM6DQo+IA0KPiAr
CS5jYXBzID0gTUFDQl9DQVBTX0dJR0FCSVRfTU9ERV9BVkFJTEFCTEUgfA0KPiArCQlNQUNCX0NB
UFNfSlVNQk8gfA0KPiArCQlNQUNCX0NBUFNfR0VNX0hBU19QVFAsDQo+IA0KPiBUbyBtZSBpdCBs
b29rcyBiZXR0ZXIgdG8gaGF2ZSB5b3UgY2FwcyBhbGlnbmVkIHRoaXMgd2F5Lg0KDQpZZWFoLCBJ
IHBpY2tlZCB0aGF0IGIvYyBJIGNvcGllZCBzdHJhaWdodCBmcm9tIHRoZSBkZWZhdWx0IGNvbmZp
Zy4NCkkgaGF2ZSBubyBwcmVmZXJlbmNlLCBidXQgaWYgeW91J3JlIG5vdCBhIGZhbiBvZiB0aGUg
ZGVmYXVsdC4uLg0K
