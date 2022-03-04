Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAE0D4CD0EC
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 10:19:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235373AbiCDJU3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 04:20:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231883AbiCDJU2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 04:20:28 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC0B474DEA;
        Fri,  4 Mar 2022 01:19:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1646385580; x=1677921580;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=LUEVAdNLw5vW3e1joUJrYcWu5mknCPEiZPYTaja7MuQ=;
  b=U3KowZ86Nsb36SFJHjO2kA/HPhbIuW3Y3duCWR+3ZIX5mM5xpH5faeaU
   XVKVs0YG8dK0xSnb7TTj/1BAaU0y2AHlD/NSKLwbYyn303l9GNF9slfxH
   4cS9y6cz5w0PETHq9TDHYgfTkosif/VA4OWGtosVhqvkBcDj/304ZOC2e
   PkGm+8iNtvJPrfB3+LZwQP0E9Hw26aqrF0FBTEHb32dQYs48OpNDrDAaY
   VLmI0qvUoa56lyRvke7DgyF7WlmhAk9dugScCXryjrmLN+SC2lEK5ThVD
   Pin7VT6pDV0imWPh8PcGfHJXzw/ozpQ/TKTwDipNR/YDcc3ZalLUyzX6A
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,154,1643698800"; 
   d="scan'208";a="148079077"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Mar 2022 02:19:40 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 4 Mar 2022 02:19:38 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Fri, 4 Mar 2022 02:19:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nl2P4vfpvu5Dra9YP1F3vMAvn4teIZUs8ADm+tLptlPgBw76Zi9Tv3V12r5XVnoYXxvnRVNZ1Naa67kGSuElHKWhHzBL5aJ+0ZwFXoIzCZZvt+g+RCgXkpXEEU9d/T537KM7aRznetcbbzKEgYY263eNYpdw/VoqcbSb5QqJDOBBobkEkzSxLJr4drALew6ZNsUBW8/65f5ytYPbEZ60N6qAVtQBaBfbLoEweGFqS0Kz2rh1kXVyMv8U+FB8vhrom6ZvNSgLpuGFMfHVox6qatcjJ9C1jwKDv1mfaJJ5KhgiGaZQkQ2jg6b3hXpaQ0j4pdjIiGD06K2qLNkK+9ejCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LUEVAdNLw5vW3e1joUJrYcWu5mknCPEiZPYTaja7MuQ=;
 b=g559vP+EXeTgalPga3yy81rbyUsFDWLyPaZmqKWQe72rEu96yawpiUzklOCb/Uf3Z0Pi2p/XvHPxo2ugAqnArm9Of/8WX+VFAXnUDTuy33dk8IqeYaUZwdOLlgyFdCLYg8DQtGlniS22sMv08pA6xLOfq0WrJEHhLKicTt+6r4NEtzTR64s5+RhNm7D6ZS67y9gBl9v/DAmaYOLWj53LVk2AGyWa7Tz1PaXltLHf17Qb0i/1qpVw167Behh/YN0IkiiuBVvZ2KExJs8QKAPVNxJxfhg1X0f6RIAbQwaJawxr2gR2gO0uEH0BuNpESQalyaX4QIlAwJMYVvyclrquoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LUEVAdNLw5vW3e1joUJrYcWu5mknCPEiZPYTaja7MuQ=;
 b=m4OnuaWT/4jwfvOM3qut9fqaz/ACcAcb91Xw7SVtAvUkoSGpKs19apODhsTbnn2eeoKk0xuPTelARuoU1I+1YK3p3yw2aTn8twGndLL3a84F9d1FcBFd8qpa94K5eCP4aV4LCXafxkm9u94dbgRM+1v/fkg6C7ZqnxR1HYrC/pc=
Received: from CO1PR11MB4769.namprd11.prod.outlook.com (2603:10b6:303:91::21)
 by BL1PR11MB5254.namprd11.prod.outlook.com (2603:10b6:208:313::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Fri, 4 Mar
 2022 09:19:25 +0000
Received: from CO1PR11MB4769.namprd11.prod.outlook.com
 ([fe80::6d66:3f1d:7b05:660b]) by CO1PR11MB4769.namprd11.prod.outlook.com
 ([fe80::6d66:3f1d:7b05:660b%5]) with mapi id 15.20.5038.017; Fri, 4 Mar 2022
 09:19:25 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <robert.hancock@calian.com>, <netdev@vger.kernel.org>
CC:     <Nicolas.Ferre@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <soren.brinkmann@xilinx.com>,
        <scott.mcnutt@siriusxm.com>, <stable@vger.kernel.org>
Subject: Re: [PATCH net v2] net: macb: Fix lost RX packet wakeup race in NAPI
 receive
Thread-Topic: [PATCH net v2] net: macb: Fix lost RX packet wakeup race in NAPI
 receive
Thread-Index: AQHYL6jxE/xxmezOIkaKB635LDhppA==
Date:   Fri, 4 Mar 2022 09:19:25 +0000
Message-ID: <511cdc4f-d3b2-c1e2-6224-b1691b18f277@microchip.com>
References: <20220303181027.168204-1-robert.hancock@calian.com>
In-Reply-To: <20220303181027.168204-1-robert.hancock@calian.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e9bd0c9c-514f-4e44-f1b2-08d9fdc0139c
x-ms-traffictypediagnostic: BL1PR11MB5254:EE_
x-microsoft-antispam-prvs: <BL1PR11MB52546BD7B3D2572F185BC70C87059@BL1PR11MB5254.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sLH+uR5XnJix86uyEeOqr8J0eifoaSMnDfDHWsjtcLwPY79cCnX1w5Jv69H5TfYfoZY+l8bRhI0lCSHkkYjxK7+8dXrq7zwVGaHMbqQavDquORhbEjidTLZvFngmsk52pSAjiQCkI0mDbNS2mRZCJCReYrjGJzQbfdcM9UbvfqmgbJOzfiQ3Hcl0nQjfuAo9hKaze6IaGQULq+zoiAucLMsvjxrxosxDOA/Kf/zVS1jEkO3qlcTEJLEuFI/r/WX2Gba5sFdGKGKj1ZLgN9/ynTy56jXNKE0eiQOtMrk07bxUbGorzCH6JybxClAhqoYm1MMwRZlgvKnebQvXGmyg5UTMeSnHGWw8zOeC33efAKr7ERKj8UowicWB8Jt0LCbIvnKr7mHVXzJOflja20brelQjA+F557L4z33V2dfZQZ7jZkAG4w6xF8eqPhhpfUy7VvQgViqYnsvuG1RHkBDoh8FTN5AdL5u6yV2F00b8fIGGLc5eKMDq69fhf5X8WKe6LSm10frQo/yI4Fr4pm7Nebh7MuOCuidCYXFD5DE/uLurQNx91S4/d2zfrRvfLW5btx2OcnFL06hWWylf9uKhRqf5BUtYjJgWkYH6ePy9WuRnf70Vx5Fak0Zr9/Xj+f3CGzTEJlGtUFRNqXh7KZONgRDEGAJM9OJNwAddjuxqEpk/51RIRmUChKMMl2ePFHaev1qFTo6BYgPrjbTMPl4SNoBIX75F+LfbepCQ0z2O//sGth9+Zpk3wkZBw4a55dsPGf6fjdBFsgARomNN4nE91w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4769.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6512007)(5660300002)(66476007)(6506007)(4326008)(53546011)(31686004)(8676002)(64756008)(2616005)(36756003)(6486002)(122000001)(66446008)(8936002)(110136005)(38100700002)(54906003)(508600001)(186003)(26005)(71200400001)(76116006)(316002)(83380400001)(91956017)(86362001)(31696002)(66556008)(66946007)(38070700005)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YktyWEpmWUhGZUROQUMrazhJMUxQU0dEajFvTjhxaXZiRGxtTFF0bzhjTXVF?=
 =?utf-8?B?eGgvY1I3WlF3ZW5WS2UyRkRJV3NSNERyekRBS051alpBV21sSzRtM2w4TVhY?=
 =?utf-8?B?ZDRYSjdVZEFaVzhpN2gyWU56QWNDSDBmOVFwU2d0Rmk3UkNDcnh6S0srY3gy?=
 =?utf-8?B?M2NveXFVVkJqcUpMYmRBT2ZQZFZaZk1iTWtvaWhUdEJ1Y2hFaXlSUjVPUExh?=
 =?utf-8?B?R3BlNjRhazFERFd0YUE1ajBWU1pCTW4rTUt1Y09vdXY5UnFOYzE0Q0h6NjE0?=
 =?utf-8?B?K0VWeHpqWkJsditOakUrWDYvK20zdWozSFhoU2VySjM1ZlhMeXdzUk1CZzAy?=
 =?utf-8?B?TjAra0dMWWw5VktSUDdLOHBWdDFDYy8yM2tLaEZxU2htanFrQzhyd3VXWlZF?=
 =?utf-8?B?WFBsdUJJZG1DampRemtRWEljSzlGcnpGQUxPeTM4eVRwdlcyUStxZUtpeVVh?=
 =?utf-8?B?TjM1eXdKRzhKRjNkL05aRlF1T2tmNVIzWTJNYW5rNHB3eFZ5SXNlTkIyb3Bp?=
 =?utf-8?B?U3JibjVRVDBPOEFPbUt2MmJYQ1g1MUZndlljQXNOL1ZrM0R4allvS1dnTHVW?=
 =?utf-8?B?QUVIeWNUY3ZSZUNmN0x1ZHphMFpjZHZQaGVLQVRaT05TNk5jWjRKb1I1RStS?=
 =?utf-8?B?dk9pb2JXNUlucFFGdUQwZWc1bE5BWXNuaWhJRkQ3MGVJMDVKVGozbTM4U2ZI?=
 =?utf-8?B?QW9yeHhhdEFGQ3c5c1FQQWdiNkhCTlhCbnI4N0hZTGpTVHBqV0VlNzE0VVRR?=
 =?utf-8?B?MXp5SEY4Q3U5NTQyMUNSaVFNUkU0OHdVWU8vL3BOMzlqdnlwWWZGdjZLbUM1?=
 =?utf-8?B?dFhDWjhZeTZXcXdBc1RwMDVTZWFTYTE4WlRrdkw2Zi9yQUVDMk1sb01KQXNH?=
 =?utf-8?B?bGRvbXl6dExvelVTQU4zYjJnWGJNRVVzRG0zd3NrRHpJemFMSzVzWHZxaVV3?=
 =?utf-8?B?cGRmYlNzVzlNY1MrZFNBRDkrMzgxbXpHNE9TNEJtU3hSRVo3alpyNm1pY0Zy?=
 =?utf-8?B?eWRSUFJvLzYxQnJRMnhJaXJzbkxLOTFEUlk3N0RnSEhha2VQS1NxMDhQb1VB?=
 =?utf-8?B?dUFidmxRbkdDZnNRek9vMFErSzU3R1lxaXU5aEdFdTU5cFdpVmkyY2wzRmdt?=
 =?utf-8?B?WGEyUS9adFpzanJpZ0g2U2pwT0V4TTlaaGwvU3g3N0IxUmt6S2Z3QUhGNG1j?=
 =?utf-8?B?RG4xU1gycDV1VmIxQVNLZThKWWRaQU9WeXVEa1F2bmlSZDBOSm9OM2hRMFJR?=
 =?utf-8?B?d3h5a1QzM3FpRU8reHpwZTAyUjZ6N01DVm45NEVkSDQwRXlZMVM4WDU3VTBw?=
 =?utf-8?B?QVZmaFh5Zy9xaGZtUk9VRkdQYndsOC9VSlJuSGpoSmtvOGxrZytiTGpuQm94?=
 =?utf-8?B?aVo4ellkKzFzWThndzE4aW5pKzA2SEJLTGxja3FKYlRIZ3BLeFFNYmJrb3lG?=
 =?utf-8?B?QW44NGd3di9aUUpPWElzTXNSbS9BMVlmS3FrR1VFdEJxUmNuSFBaTThmK0hh?=
 =?utf-8?B?dHNNYXUxaXdUbW9pcGM1aVJSM0xROHM2VWtsT3AveENYUVBwWFIza3RXSk9W?=
 =?utf-8?B?NkpvQVNvNUJROWpycEpMRU5Icm5TdGFNRE1ESEU3U3B3ZGRvTmIzZE5HcFp6?=
 =?utf-8?B?azFWYlZOek5vL0ZQdWZPWHkzSVN6RHU0YXB1VGV1aTVuWkg3TXczM0JjNnpj?=
 =?utf-8?B?TXlZa1R2aXhXeDM2WHZwL1hwN0JtWmozY09hcGd0VitsYlAzRmI0T3E5bDhh?=
 =?utf-8?B?RlVPaElUbUpkaEduYUJLZ01qa3dkTzBqMDZ1TjlSSld6SzQ3c09TYmx6cURj?=
 =?utf-8?B?K2pXNkY0MVkwdm0wd0NwajlmZ3Y2R25YSEtJZWIxNVpaVmlKNExIR0h2Q1R4?=
 =?utf-8?B?WjRBdC9IY3FUeWR5Vnk1N3RkTUdSYzRhYmE0aUxFalZCTzhPYmFEeUZZb01E?=
 =?utf-8?B?dXZQNWk2c3V4M2R2QjcxTEpOcWR0dGtLMVdJSGcwVXJUMHR1MG5ZVnIvalhs?=
 =?utf-8?B?U2pobmtxSmdvZlo0VTB0MS9NeHZrZWVpRkRJNjlCNldiUU1ZdUJNSEh5SVJJ?=
 =?utf-8?B?RFppL0wvZ2lYSlh3RkEwQTBFWjZiNTgzUFNJSzJUYXBEVldJVFhFaTV4RVVN?=
 =?utf-8?B?d0xLWk1PSHdzemNzQWJjdVRwM2Z3a3poNjlVMkpYM0VjOUhrRElUM3hySGpm?=
 =?utf-8?B?QmdiM3dFdVVWZmlYL0ZtUmZZVVU1M3FwN29Pak1TVkhwMk9YS3FmeFZSdHh4?=
 =?utf-8?B?ZEdYbXRRa25tS2RqS2pzdzgvOXNnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <92C5E2F69ADA63489A366CEE3EBD5E6E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4769.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9bd0c9c-514f-4e44-f1b2-08d9fdc0139c
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Mar 2022 09:19:25.2674
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4oeE+KSlOc9C2p6yNkL7xC7lyODrduOSa6XVV3mbax+ZnT0biYi+0r0O6sYYYAz2CCYhynrn935COT2GFokVtansvZubVAT4TOaLvpr/spU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5254
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMDMuMDMuMjAyMiAyMDoxMCwgUm9iZXJ0IEhhbmNvY2sgd3JvdGU6DQo+IEVYVEVSTkFMIEVN
QUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91IGtu
b3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4gVGhlcmUgaXMgYW4gb2RkaXR5IGluIHRoZSB3
YXkgdGhlIFJTUiByZWdpc3RlciBmbGFncyBwcm9wYWdhdGUgdG8gdGhlDQo+IElTUiByZWdpc3Rl
ciAoYW5kIHRoZSBhY3R1YWwgaW50ZXJydXB0IG91dHB1dCkgb24gdGhpcyBoYXJkd2FyZTogaXQN
Cj4gYXBwZWFycyB0aGF0IFJTUiByZWdpc3RlciBiaXRzIG9ubHkgcmVzdWx0IGluIElTUiBiZWlu
ZyBhc3NlcnRlZCBpZiB0aGUNCj4gaW50ZXJydXB0IHdhcyBhY3R1YWxseSBlbmFibGVkIGF0IHRo
ZSB0aW1lLCBzbyBlbmFibGluZyBpbnRlcnJ1cHRzIHdpdGgNCj4gUlNSIGJpdHMgYWxyZWFkeSBz
ZXQgZG9lc24ndCB0cmlnZ2VyIGFuIGludGVycnVwdCB0byBiZSByYWlzZWQuIFRoZXJlDQo+IHdh
cyBhbHJlYWR5IGEgcGFydGlhbCBmaXggZm9yIHRoaXMgcmFjZSBpbiB0aGUgbWFjYl9wb2xsIGZ1
bmN0aW9uIHdoZXJlDQo+IGl0IGNoZWNrZWQgZm9yIFJTUiBiaXRzIGJlaW5nIHNldCBhbmQgcmUt
dHJpZ2dlcmVkIE5BUEkgcmVjZWl2ZS4NCj4gSG93ZXZlciwgdGhlcmUgd2FzIGEgc3RpbGwgYSBy
YWNlIHdpbmRvdyBiZXR3ZWVuIGNoZWNraW5nIFJTUiBhbmQNCj4gYWN0dWFsbHkgZW5hYmxpbmcg
aW50ZXJydXB0cywgd2hlcmUgYSBsb3N0IHdha2V1cCBjb3VsZCBoYXBwZW4uIEl0J3MNCj4gbmVj
ZXNzYXJ5IHRvIGNoZWNrIGFnYWluIGFmdGVyIGVuYWJsaW5nIGludGVycnVwdHMgdG8gc2VlIGlm
IFJTUiB3YXMgc2V0DQo+IGp1c3QgcHJpb3IgdG8gdGhlIGludGVycnVwdCBiZWluZyBlbmFibGVk
LCBhbmQgcmUtdHJpZ2dlciByZWNlaXZlIGluIHRoYXQNCj4gY2FzZS4NCj4gDQo+IFRoaXMgaXNz
dWUgd2FzIG5vdGljZWQgaW4gYSBwb2ludC10by1wb2ludCBVRFAgcmVxdWVzdC1yZXNwb25zZSBw
cm90b2NvbA0KPiB3aGljaCBwZXJpb2RpY2FsbHkgc2F3IHRpbWVvdXRzIG9yIGFibm9ybWFsbHkg
aGlnaCByZXNwb25zZSB0aW1lcyBkdWUgdG8NCj4gcmVjZWl2ZWQgcGFja2V0cyBub3QgYmVpbmcg
cHJvY2Vzc2VkIGluIGEgdGltZWx5IGZhc2hpb24uIEluIG1hbnkNCj4gYXBwbGljYXRpb25zLCBt
b3JlIHBhY2tldHMgYXJyaXZpbmcsIGluY2x1ZGluZyBUQ1AgcmV0cmFuc21pc3Npb25zLCB3b3Vs
ZA0KPiBjYXVzZSB0aGUgb3JpZ2luYWwgcGFja2V0IHRvIGJlIHByb2Nlc3NlZCwgdGh1cyBtYXNr
aW5nIHRoZSBpc3N1ZS4NCj4gDQo+IEZpeGVzOiAwMmY3YTM0ZjM0ZTMgKCJuZXQ6IG1hY2I6IFJl
LWVuYWJsZSBSWCBpbnRlcnJ1cHQgb25seSB3aGVuIFJYIGlzIGRvbmUiKQ0KPiBDYzogc3RhYmxl
QHZnZXIua2VybmVsLm9yZw0KPiBDby1kZXZlbG9wZWQtYnk6IFNjb3R0IE1jTnV0dCA8c2NvdHQu
bWNudXR0QHNpcml1c3htLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogU2NvdHQgTWNOdXR0IDxzY290
dC5tY251dHRAc2lyaXVzeG0uY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBSb2JlcnQgSGFuY29jayA8
cm9iZXJ0LmhhbmNvY2tAY2FsaWFuLmNvbT4NCg0KVGVzdGVkIG9uIFNBTUE3RzU6DQpUZXN0ZWQt
Ynk6IENsYXVkaXUgQmV6bmVhIDxjbGF1ZGl1LmJlem5lYUBtaWNyb2NoaXAuY29tPg0KDQo+IC0t
LQ0KPiANCj4gQ2hhbmdlcyBzaW5jZSB2MToNCj4gLXJlbW92ZWQgdW5yZWxhdGVkIGNsZWFudXAN
Cj4gLWFkZGVkIG5vdGVzIG9uIG9ic2VydmVkIGZyZXF1ZW5jeSBvZiBicmFuY2hlcyB0byBjb21t
ZW50cw0KPiANCj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvbWFjYl9tYWluLmMgfCAy
NSArKysrKysrKysrKysrKysrKysrKysrKy0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAyNCBpbnNlcnRp
b25zKCspLCAxIGRlbGV0aW9uKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvY2FkZW5jZS9tYWNiX21haW4uYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2Uv
bWFjYl9tYWluLmMNCj4gaW5kZXggOTg0OThhNzZhZTE2Li5kMTNmMDZjZjAzMDggMTAwNjQ0DQo+
IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvbWFjYl9tYWluLmMNCj4gKysrIGIv
ZHJpdmVycy9uZXQvZXRoZXJuZXQvY2FkZW5jZS9tYWNiX21haW4uYw0KPiBAQCAtMTU3Myw3ICsx
NTczLDE0IEBAIHN0YXRpYyBpbnQgbWFjYl9wb2xsKHN0cnVjdCBuYXBpX3N0cnVjdCAqbmFwaSwg
aW50IGJ1ZGdldCkNCj4gICAgICAgICBpZiAod29ya19kb25lIDwgYnVkZ2V0KSB7DQo+ICAgICAg
ICAgICAgICAgICBuYXBpX2NvbXBsZXRlX2RvbmUobmFwaSwgd29ya19kb25lKTsNCj4gDQo+IC0g
ICAgICAgICAgICAgICAvKiBQYWNrZXRzIHJlY2VpdmVkIHdoaWxlIGludGVycnVwdHMgd2VyZSBk
aXNhYmxlZCAqLw0KPiArICAgICAgICAgICAgICAgLyogUlNSIGJpdHMgb25seSBzZWVtIHRvIHBy
b3BhZ2F0ZSB0byByYWlzZSBpbnRlcnJ1cHRzIHdoZW4NCj4gKyAgICAgICAgICAgICAgICAqIGlu
dGVycnVwdHMgYXJlIGVuYWJsZWQgYXQgdGhlIHRpbWUsIHNvIGlmIGJpdHMgYXJlIGFscmVhZHkN
Cj4gKyAgICAgICAgICAgICAgICAqIHNldCBkdWUgdG8gcGFja2V0cyByZWNlaXZlZCB3aGlsZSBp
bnRlcnJ1cHRzIHdlcmUgZGlzYWJsZWQsDQo+ICsgICAgICAgICAgICAgICAgKiB0aGV5IHdpbGwg
bm90IGNhdXNlIGFub3RoZXIgaW50ZXJydXB0IHRvIGJlIGdlbmVyYXRlZCB3aGVuDQo+ICsgICAg
ICAgICAgICAgICAgKiBpbnRlcnJ1cHRzIGFyZSByZS1lbmFibGVkLg0KPiArICAgICAgICAgICAg
ICAgICogQ2hlY2sgZm9yIHRoaXMgY2FzZSBoZXJlLiBUaGlzIGhhcyBiZWVuIHNlZW4gdG8gaGFw
cGVuDQo+ICsgICAgICAgICAgICAgICAgKiBhcm91bmQgMzAlIG9mIHRoZSB0aW1lIHVuZGVyIGhl
YXZ5IG5ldHdvcmsgbG9hZC4NCj4gKyAgICAgICAgICAgICAgICAqLw0KPiAgICAgICAgICAgICAg
ICAgc3RhdHVzID0gbWFjYl9yZWFkbChicCwgUlNSKTsNCj4gICAgICAgICAgICAgICAgIGlmIChz
dGF0dXMpIHsNCj4gICAgICAgICAgICAgICAgICAgICAgICAgaWYgKGJwLT5jYXBzICYgTUFDQl9D
QVBTX0lTUl9DTEVBUl9PTl9XUklURSkNCj4gQEAgLTE1ODEsNiArMTU4OCwyMiBAQCBzdGF0aWMg
aW50IG1hY2JfcG9sbChzdHJ1Y3QgbmFwaV9zdHJ1Y3QgKm5hcGksIGludCBidWRnZXQpDQo+ICAg
ICAgICAgICAgICAgICAgICAgICAgIG5hcGlfcmVzY2hlZHVsZShuYXBpKTsNCj4gICAgICAgICAg
ICAgICAgIH0gZWxzZSB7DQo+ICAgICAgICAgICAgICAgICAgICAgICAgIHF1ZXVlX3dyaXRlbChx
dWV1ZSwgSUVSLCBicC0+cnhfaW50cl9tYXNrKTsNCj4gKw0KPiArICAgICAgICAgICAgICAgICAg
ICAgICAvKiBJbiByYXJlIGNhc2VzLCBwYWNrZXRzIGNvdWxkIGhhdmUgYmVlbiByZWNlaXZlZCBp
bg0KPiArICAgICAgICAgICAgICAgICAgICAgICAgKiB0aGUgd2luZG93IGJldHdlZW4gdGhlIGNo
ZWNrIGFib3ZlIGFuZCByZS1lbmFibGluZw0KPiArICAgICAgICAgICAgICAgICAgICAgICAgKiBp
bnRlcnJ1cHRzLiBUaGVyZWZvcmUsIGEgZG91YmxlLWNoZWNrIGlzIHJlcXVpcmVkDQo+ICsgICAg
ICAgICAgICAgICAgICAgICAgICAqIHRvIGF2b2lkIGxvc2luZyBhIHdha2V1cC4gVGhpcyBjYW4g
cG90ZW50aWFsbHkgcmFjZQ0KPiArICAgICAgICAgICAgICAgICAgICAgICAgKiB3aXRoIHRoZSBp
bnRlcnJ1cHQgaGFuZGxlciBkb2luZyB0aGUgc2FtZSBhY3Rpb25zDQo+ICsgICAgICAgICAgICAg
ICAgICAgICAgICAqIGlmIGFuIGludGVycnVwdCBpcyByYWlzZWQganVzdCBhZnRlciBlbmFibGlu
ZyB0aGVtLA0KPiArICAgICAgICAgICAgICAgICAgICAgICAgKiBidXQgdGhpcyBzaG91bGQgYmUg
aGFybWxlc3MuDQo+ICsgICAgICAgICAgICAgICAgICAgICAgICAqLw0KPiArICAgICAgICAgICAg
ICAgICAgICAgICBzdGF0dXMgPSBtYWNiX3JlYWRsKGJwLCBSU1IpOw0KPiArICAgICAgICAgICAg
ICAgICAgICAgICBpZiAodW5saWtlbHkoc3RhdHVzKSkgew0KPiArICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgIHF1ZXVlX3dyaXRlbChxdWV1ZSwgSURSLCBicC0+cnhfaW50cl9tYXNrKTsN
Cj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBpZiAoYnAtPmNhcHMgJiBNQUNCX0NB
UFNfSVNSX0NMRUFSX09OX1dSSVRFKQ0KPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgcXVldWVfd3JpdGVsKHF1ZXVlLCBJU1IsIE1BQ0JfQklUKFJDT01QKSk7DQo+ICsg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgbmFwaV9zY2hlZHVsZShuYXBpKTsNCj4gKyAg
ICAgICAgICAgICAgICAgICAgICAgfQ0KPiAgICAgICAgICAgICAgICAgfQ0KPiAgICAgICAgIH0N
Cj4gDQo+IC0tDQo+IDIuMzEuMQ0KPiANCg0K
