Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94BF06F0752
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 16:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244030AbjD0O01 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 10:26:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243701AbjD0O0Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 10:26:25 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37F1883
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 07:26:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1682605584; x=1714141584;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=kLx7gLZdEjSis+uOc7mawqBJ/5DjQnq4NjEElQM2Kkg=;
  b=w9s8FiNj7xHHf2KeKVbS308rA5AQDH8R1dGrsKuZMbD0At38/ceaOfW/
   +uUL6hWZsZWqAE7XFZtYHX375YmTp4RZH7Iie3Aud33ti4SiCJ1dFGKyE
   dAFPgBa08xgjz1aCICtQP2eCtfWMd2ZU+8W9s0gQbhXGlj4lt6Wwd1Wy7
   nym9ewQEOaoPd184UDl2V0o3xJoY7qnvGmeAmdxXBbXbvPIXUkpXqzz7r
   gkl6t987F9EThRg9r5bB4QcUFvLs8ONxHnYyzjj2zQ7Yzw6ahstXamRqh
   XuKzIi0Qe1hb1fm0HWt8fuQ7YQwoVfxtMGW2gJv1nRGxpZ3a78smaeuhx
   A==;
X-IronPort-AV: E=Sophos;i="5.99,230,1677567600"; 
   d="scan'208";a="211479912"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Apr 2023 07:26:24 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 27 Apr 2023 07:26:23 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 27 Apr 2023 07:26:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m0+bHaAN4RFCEmF+KR3aJem7tMUKBApzLWyZmdVDSVtYhVKs/ouBiEBLg7tD3dBUW3XO8ITgXGVJQC5ybfr1lcf+xGJAW3U3+4VwbFwfrR/gV5lbjaGJnbXESbEOJtdNHjt8ue9sNOkh806O8vahI12HWjeQonn2IeItCq+IQjI7KqHhfFvk2fiFYhEtQrujErhVtL4d92TpPpsKZzVtfTi2ecKgIRyLpojWxVFZ3tad4sGRxuJSePQm1Hvt6UTNYrU4ftwA9OGZOEkTjv/xbJcEiGaT4UyHIozrNeD0OI0ZkdugZXKJWjpwrQKqBVOoy1QdfY9a4c9ZiV4bond9cA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kLx7gLZdEjSis+uOc7mawqBJ/5DjQnq4NjEElQM2Kkg=;
 b=BtQtMchYu4ApOt4oNUOHKf+SdkeEPNe/CFw6WjPvkgRjU4cemLjpGrnOBeBrQA+KG6aek2xKbezH5/gN2OWsc/oBgESBjPe1QmxoU0VSSP7OgV4gqbNvfgVjtkjtRe7Sq0+SwVT0y/70X3s6yysndWX9eJHwaMccU6vALv9vqQKz6BnnR8QaAr8csauacqWNsRS24m9DEgwQu5eQmmEQ/IZjq9zcVplmdcpTNc3rtMfzPiVOUfEeUWRITxs7UKMc0CbY7sf38Ej3pa+hNlkoA5V4McDO/rX9WRNJln8UCOGDfWjkjrM6+MVCygY3tVb7vSuBSoovcg49p2dJY2ecJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kLx7gLZdEjSis+uOc7mawqBJ/5DjQnq4NjEElQM2Kkg=;
 b=BSE9oFj+fI7n6EPUeeEmaHPRGTVTTGXWqHlXrQ03Gz4BuCGCpi0hBkCMCkF12cO2bTrEWPQNUNFiLmwpKLdunkMZBuLFpn5jmcJ7WeTP2P57HQXAqm3d/Wzwo9DPySrdFTwwYd8UQ4m/UQN0uotZoEv6QFmS2ZC2FWW+oHP4X98=
Received: from DM6PR11MB3532.namprd11.prod.outlook.com (2603:10b6:5:70::25) by
 SJ2PR11MB7599.namprd11.prod.outlook.com (2603:10b6:a03:4c6::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6340.22; Thu, 27 Apr 2023 14:26:21 +0000
Received: from DM6PR11MB3532.namprd11.prod.outlook.com
 ([fe80::1c94:f1ec:9898:11df]) by DM6PR11MB3532.namprd11.prod.outlook.com
 ([fe80::1c94:f1ec:9898:11df%5]) with mapi id 15.20.6340.021; Thu, 27 Apr 2023
 14:26:21 +0000
From:   <Parthiban.Veerasooran@microchip.com>
To:     <Horatiu.Vultur@microchip.com>
CC:     <netdev@vger.kernel.org>, <andrew@lunn.ch>, <davem@davemloft.net>,
        <Jan.Huber@microchip.com>, <Thorsten.Kummermehr@microchip.com>,
        <ramon.nordin.rodriguez@ferroamp.se>
Subject: Re: [PATCH net-next 0/2] add driver support for Microchip LAN865X
 Rev.B0 Internal PHYs
Thread-Topic: [PATCH net-next 0/2] add driver support for Microchip LAN865X
 Rev.B0 Internal PHYs
Thread-Index: AQHZeDS8vqquPNIw80KBvYMfM1OlFq8+ESaAgACsegCAAEeWgIAAMxkA
Date:   Thu, 27 Apr 2023 14:26:21 +0000
Message-ID: <91059053-4a1a-fa88-ed39-b53ca8b24505@microchip.com>
References: <20230426114655.93672-1-Parthiban.Veerasooran@microchip.com>
 <20230426205049.xlfqluzwcvlm6ihh@soft-dev3-1>
 <c1fca21d-00a6-be18-b5b5-4aa5dac94fb3@microchip.com>
 <20230427112421.sqnitutjti3yu2yc@soft-dev3-1>
In-Reply-To: <20230427112421.sqnitutjti3yu2yc@soft-dev3-1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB3532:EE_|SJ2PR11MB7599:EE_
x-ms-office365-filtering-correlation-id: 337f6295-65dc-408f-44c9-08db472b5f50
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ShEYk57r5f0CJSrLma8gzKwHKtf9EKZGfsj1/tFbIu3OZeoBjHJ34aG/gs5yNF2cL6iW3eONO7aTm5AP6p7/EVXBbL9ZzgtmbciM9RV/Q1giUKJjpLrX7if9Apr3uBduSlSR/Ze39O67ZBg7wvI18INX1FcmKlWmPj4aFaFimdOf6EZbdYHXUcuc0Z8OkvKVPIQcHFDl7YF9zWzKImuN+IPZDOOb/hS+cK7gC0mDfHq2yyF6wuyQKJwFKk8j3AbcZbnw8H7jOQamJk9LiZVkDhd82GANSH4qTvxBMGLXRbOs9cr+rPbDWFQJfOpkEebhrolEGQZSRwn9JwxIyFfvvnKThRYFZJl5TEg7ifQtKtD7WRn0mZ/hJnJc7MkYbhZaR9vvzKLZpi/CXidTSAlqMdrhC2VFDKrS8ZHndrN7z4y/EwLXJoXP0/4cH3AaeNhr/V2WfczXYeigPbR4VtBUzgE5LaPICsCzj2CUy2WTC/bBEyOrY4wBY78cVZy5jj2SqX2kE2rs1KewlhgutWc/skrgAeZmxk+HJ1KazLy79kWuWBK6fALmEm2+OnqmpbA8Ewy92LKng4IpAtXXB2YCtEpnbfKCtkIXIi6LYk8+xjESHCgHQr7WuGr9kIxwjfWHbuXcZV7LmcA7j936SGN2Jq66sm17Qf+I1pgERK6X+xevQsYiavVICTL/SHngpohB
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3532.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(136003)(346002)(39860400002)(376002)(366004)(451199021)(5660300002)(71200400001)(122000001)(83380400001)(31686004)(6512007)(6506007)(37006003)(54906003)(8936002)(8676002)(316002)(6862004)(26005)(91956017)(86362001)(66476007)(66446008)(64756008)(66946007)(66556008)(6636002)(2906002)(4326008)(2616005)(4744005)(41300700001)(38100700002)(6486002)(76116006)(36756003)(38070700005)(31696002)(53546011)(478600001)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NGg2L0E2TjljWnRET1kxWmthU0JxMkxXZG5mcVpCZlZKYkpKUklqUmM0eVFa?=
 =?utf-8?B?QlRYMTZMTURYS0haU0MrdXc5eVdtWkdUNnBpL3plNG9Ja0huc0hTTXhBdXha?=
 =?utf-8?B?dHc1djZqMHJRUDFvcWl2TEhpQUQwL1pZL0U5Vi9pb0lBS3FnMW81OU5oeWVD?=
 =?utf-8?B?RUlPVit4OTFDMHovTGwzNEd0blhKazRoVDVvdXY4MWtmYWxRWkE2SUFUb0Vy?=
 =?utf-8?B?ZDg0UldVbXRyUWFzVHJlSitIQWM4SklJRWxQc2I2b2xBTERDRnZnTWdQUm4v?=
 =?utf-8?B?NnMzMnZ5NUV1dHRPL3NoWUViWUx5SlpSYVl5QUkzQ09qQUlQK0lKY2haMnBq?=
 =?utf-8?B?U0dFS29NZlNxTWs1QTBZK0JKa2NsQ0lObGp1MUd1cUQ4VjZtdDI5L2pMNXhn?=
 =?utf-8?B?a2tzbEFCRDM3b05tOEhJRHVpVzc1ZzYzZlJyRTdsSys1Zmh3WUVIZVo1cEp0?=
 =?utf-8?B?T1NoRXQwYTluMk1QTTFaQnF2dVhOVUkrdmNLclhXR3dRRDlTbVZlV3k4Z0Rq?=
 =?utf-8?B?dldadGNoZ1Y4VDNMV1FmaXhiVFdwdCs2UTlsL3NWRk5XT3Ewd0xoZ015VzNO?=
 =?utf-8?B?YS9PbkRxR0hNTENQc05BVjA3UHlDUDd5WW5HU0YrYXlHVHF3QmlWTS9jOU82?=
 =?utf-8?B?dlVpOGVTUVF2TWNZWUNJNG85bStkNFJGQUpDc2VTeDFTd3h4S2YzOU9IUi9j?=
 =?utf-8?B?L1N5RlduV3doQmVoejFJTC9PWDBkME5QRHhPaXNmTkJQYjBzaThoOXUwT3l1?=
 =?utf-8?B?YWJXdGFTR01ia2lyMzRheGt6TnE1ZU1aMk85bHZENXNFMGI3L2Q2S0dQbWxl?=
 =?utf-8?B?NEdLWG1kdVE3aXZIdG1MblZkN0YweWplcEQ4NDVsY1k2a0lxVUpJUDMyczVV?=
 =?utf-8?B?aHdHRk9tSjdtNXZOWUJJMDYxb2FQbWEweVlyKzhRdEVGWFNuS0ROQXAzSmVu?=
 =?utf-8?B?MDJSZGpwRXlIWjNWVS8yZVloTjd1U3JCZ1FWTGdwVmtETk5mUlpHak5wMVZl?=
 =?utf-8?B?cnZ4NkpQbUQwWDgxRWZ4ZEgydzZweUFZRnhrMHh1d0wwZkVzemF6cXJFdENU?=
 =?utf-8?B?d0dpYWZIQmdrYXJGOUF2SzBnZXEySjZVeTNkU2tUWUZZd1ZkdnpiV0ZGdm52?=
 =?utf-8?B?SlI4SllnamdzTWFJdFM3cmtWRFdUc2pEeXMwZFZST1VPTGo3REV1SmFmR3hy?=
 =?utf-8?B?cjJKd0ludUFLcGdIL2Y2ajRCSDhLK0JiL203TC84bCtDS1JrZi9aT2JTdXlH?=
 =?utf-8?B?Ri9mNGY4bzVvc05DOUlwUk9YUjFpN1RaNk43ZDNMcGNqVW5jWndoU0wxd09U?=
 =?utf-8?B?OFU1UmY1WE9KS0hFdHI4My8xTFJpL1hKU0NzZklNR2w2ZmM3V2JmcTM5aytC?=
 =?utf-8?B?d2c1UCtSZ2E2ZWIzMnQvTGFhcVQyQmZwZFJOejBIRzJDNkVpMWVzN3I3YmVU?=
 =?utf-8?B?YjBYbzUxYjhaVUJOL0hoamh6cGFXRklIVTJaR2Yva0RWRjVYQStobFFHUUhQ?=
 =?utf-8?B?MlZWaWw1WlBrSjIwUkM4WUYwNjVvTnJ0L1pwc1VzUEI4R3liamFHVFRKT2Nt?=
 =?utf-8?B?enpSdDgyejRGSHl1di9mREZpSW54bjFMNzkzbmVpVWZNZGdUa01nZUFTQnI4?=
 =?utf-8?B?cmZZSTZKRUJnV05zdExHVGdoaEdEZjR1bTBaeUZJWEJEcE9VOTVhUEtrTVlY?=
 =?utf-8?B?c0lJZ1N5RlR3eThWNG1oSmJyN0lINkhuS2cxM3ZJVStJK2dFWWxrR05YaU44?=
 =?utf-8?B?WXZUeDRJQVpiaytGSkpNeDlaQTBMU0pwekd6MWlsbEZxSldxN1BTQU1NbUpU?=
 =?utf-8?B?aTRiSk1ULzNpTExwT2pPd2dJS1czZHoyRFlqYk5na0JnenhmajhBU3lzNzBK?=
 =?utf-8?B?KzQzRTVZcU1WUHlicmxMeFd3TVhQUE5jRUVXYytrY29RMTFkRkg1MURQd0R0?=
 =?utf-8?B?cmNFNCtwYy9uUm0va1NZUmkzL0FSM3RoU2VoRXJxZkoyVzJ2cU1YbnE3OGxI?=
 =?utf-8?B?TVVhdmZETTN2cmc3aXVaVng3aFgyeEQyVkdzTW12YWV6K1FvR0x5TFV6YkFV?=
 =?utf-8?B?Q0VMVkt0ZE9CMnk5c1E1WHppc1BlOTBpQzVTSmw0UVVHN2N3cmNRdjZUaUh1?=
 =?utf-8?B?RVZwRFI3Wnl4N2djTjBVOUZ5OE1aUGNGbGw5WGVxRmw5RFVtMW4rYUR3SkVH?=
 =?utf-8?Q?3xO6xlaB77bzxRS3VxgvRe4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5129DA476FD6DE4EBD29F0B9993E5501@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3532.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 337f6295-65dc-408f-44c9-08db472b5f50
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Apr 2023 14:26:21.1273
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ar176e0sUOT4EoAvhXutKtwqtUohrcVhhZEp4piwFsyfQ/DArig3Z9B5I75sbFEJCDQ0pY+gw9ergVp9HxTvTll/eg/u8AWM2RTiHIFkqigcoKTtciCDGTauPbkf35Y/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7599
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgSG9yYXRpdSwNCg0KT24gMjcvMDQvMjMgNDo1NCBwbSwgSG9yYXRpdSBWdWx0dXIgLSBNMzE4
MzYgd3JvdGU6DQo+IFRoZSAwNC8yNy8yMDIzIDA3OjA3LCBQYXJ0aGliYW4gVmVlcmFzb29yYW4g
LSBJMTcxNjQgd3JvdGU6DQo+PiBIaSBIb3JhdGl1LA0KPj4NCj4+IE9uIDI3LzA0LzIzIDI6MjAg
YW0sIEhvcmF0aXUgVnVsdHVyIHdyb3RlOg0KPj4+IFRoZSAwNC8yNi8yMDIzIDE3OjE2LCBQYXJ0
aGliYW4gVmVlcmFzb29yYW4gd3JvdGU6DQo+Pj4NCj4+PiBIaSBQYXJ0aGliYW4sDQo+Pj4NCj4+
PiBuZXQtbmV4dCBpcyBjbG9zZWQsIHNvIHBsZWFzZSB3YWl0IHVudGlsIGl0IG9wZW5zIGFnYWlu
IHRvIHNlbmQgdGhpcw0KPj4+IHBhdGNoIHNlcmllcy4NCj4+DQo+PiBBaCBvaywgdGhhbmtzIGZv
ciBsZXR0aW5nIG1lIGtub3cuDQo+Pg0KPj4gRG8gSSBuZWVkIHRvIHdhaXQgdW50aWwgaXQgb3Bl
bnMgYWdhaW4gb3Igc2hhbGwgSSBjb250aW51ZSB0byBmaXggdGhlDQo+PiByZXZpZXcgY29tbWVu
dHMgYW5kIHNlbmRpbmcgdGhlIG5leHQgdmVyc2lvbiBmb3IgdGhlIHJldmlldyBhZ2FpbiB1bnRp
bA0KPj4gdGhlIHdpbmRvdyBvcGVucz8NCj4gDQo+IFllcywgeW91IG5lZWQgdG8gd2FpdCB1bnRp
bCBpdCBvcGVucyBhZ2FpbiB0byBzZW5kIHRoZSBuZXcgdmVyc2lvbi4NCj4gVW50aWwgdGhlbiwg
cGxlYXNlIG1ha2Ugc3VyZSB0byBhbnN3ZWFyIHRvIGFsbCB0aGUgcXVlc3Rpb25zL2NvbW1lbnRz
IHRoYXQNCj4geW91IGhhZCB0byB0aGUgc2VyaWVzIGZyb20gYWxsIHRoZSBvdGhlciBwZW9wbGUu
DQpTdXJlIEkgZG8gdGhhdC4NCg0KQmVzdCBSZWdhcmRzLA0KUGFydGhpYmFuIFYNCj4gDQo+IA0K
Pj4+DQo+Pj4+DQoNCg==
