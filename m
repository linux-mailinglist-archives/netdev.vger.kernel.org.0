Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C3AD48D816
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 13:37:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234541AbiAMMhr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 07:37:47 -0500
Received: from mail-eopbgr00123.outbound.protection.outlook.com ([40.107.0.123]:34574
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233593AbiAMMhq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jan 2022 07:37:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OjyMQZfgTNDzRk/KBep0Rv+f/o0NFYNqN7MmmrjnPxz8HpvUHg+uoW+x9GXMP4M+9zXUjnTBh7r9C2M/BlbUZrK4zKDuQGDEt3Xt9faPgpQRYEzuclrMwkXTOvhOTMQ2YijTCWVI5Vb53N1WrYDhLJrdgT/xHUi1dQgvo9uemWS1y0kTT7SOOPd1OBYR68LcBkPHwy+1Q/r6xkg856ZIIxlA3U6G5q+Tug/fkvGh2i9xdQ9YpGNBDtKcCn8zn19p3HtfC/FSy26VnqItuzvMeZY18kxjUVb9Uzm696+UPxBRjG9aES2fiTq0d1/JY13n1mk+E7UxC3a4KH4n1LZIbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H1X+hJM+BNEH8o2ntW+NKoDvlc5+3jL2f+Ubl4Sd3VA=;
 b=gODf/J0/pcr/tuKCEiO3EDGgHffv3p/lfMg9TxNJ69URpG+IkIay8Mn4S0Hx6fIt+jbdzN942BU1sYDr5ZLCl6Nx6nJXdXITn/Vdv0x1PcixJyElkLKkm9Gzbb1Pk4nENxkYkMAw8lbIvIgIatpYt1A1H7yNQi5vOn+ZZEf6n2Xxl49Bh8VXW2Q080aZQs18YNXiHcsmiUN07y99TVgFgSedmj4pdtkt0nrEEDbRZlKj9wXtdJUjur4QYud+kAVbOKVxT+g3ewRxNT6fY1K+RNWG1Gx4m4+Za58VEKuJ+lXWGvPxt/blEoAWjWMWBlvuIdGUUNeuqnni58ul0x1jZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H1X+hJM+BNEH8o2ntW+NKoDvlc5+3jL2f+Ubl4Sd3VA=;
 b=grmO/ajsFrTlYiFPubxUAQhuW7oySfP0RKkZEaXpsX57vZ+1ymWG31OPFVVmrUy6utQ3FS2zz0crQMLuRGZpKfR1dfTlo38ISenj7pLU9FVyML96UWsQK7cWPpxJE15yOGyGB/CVLbxJ9O39eG1/CU9CBIfQwdbqvD7WX/5bphY=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by AM6PR03MB5894.eurprd03.prod.outlook.com (2603:10a6:20b:ea::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Thu, 13 Jan
 2022 12:37:44 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::dd50:b902:a4d:312f]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::dd50:b902:a4d:312f%5]) with mapi id 15.20.4867.012; Thu, 13 Jan 2022
 12:37:44 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Frank Wunderlich <frank-w@public-files.de>
CC:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>
Subject: Re: Aw: Re:  Re: [PATCH net-next v4 11/11] net: dsa: realtek:
 rtl8365mb: multiple cpu ports, non cpu extint
Thread-Topic: Aw: Re:  Re: [PATCH net-next v4 11/11] net: dsa: realtek:
 rtl8365mb: multiple cpu ports, non cpu extint
Thread-Index: AQHYBxtuyCo/io/2+0eUTaH7pIGIGA==
Date:   Thu, 13 Jan 2022 12:37:43 +0000
Message-ID: <87v8ynbylk.fsf@bang-olufsen.dk>
References: <20220105031515.29276-1-luizluca@gmail.com>
        <20220105031515.29276-12-luizluca@gmail.com>    <87ee5fd80m.fsf@bang-olufsen.dk>
        <trinity-ea8d98eb-9572-426a-a318-48406881dc7e-1641822815591@3c-app-gmx-bs62>
        <87r19e5e8w.fsf@bang-olufsen.dk>
        <trinity-4b35f0dc-6bc6-400a-8d4e-deb26e626391-1641926734521@3c-app-gmx-bap14>
In-Reply-To: <trinity-4b35f0dc-6bc6-400a-8d4e-deb26e626391-1641926734521@3c-app-gmx-bap14>
        (Frank Wunderlich's message of "Tue, 11 Jan 2022 19:45:34 +0100")
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: be088be4-a772-4a9f-232c-08d9d6917f24
x-ms-traffictypediagnostic: AM6PR03MB5894:EE_
x-microsoft-antispam-prvs: <AM6PR03MB58949602F32FF10A432708D483539@AM6PR03MB5894.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1ciqQZkdOnD9+HBbnCYt+Jw3uZm3kikj4ExgnI6pLx9xVq7XDg/7TV2014T+BQb9W/BRn3RTjQfhZd7VgHsAk7vz3oDn330c2feReh8mFlPvVGwO2M6RIxDGLeycMDzlnB05w43u2XU6jZAWTFxWotKECQCIOT0OVkIKAbcyv+M8tF0tCv4gB/BL6nezUXwAXMUHeFkrn0IMitAReDfVPIz8mgg5eRSlIA9DHn4CXwLLnbWBgGFZ01Jq2RucxM0vOoCqiNFTUwh6xhWH9U9gbhV9ryLHA5ERMWaaT12A/zcqEPJFVjU8Fn9dPpmdhy/VrHJe/AycSbJ8V5xJSuc5VmqGNyPosKg0OFLtJID/UhxSfHPOSA71MYNUwP1+GBNYonmxuXFee7CLEXm6dZV3njobcvxk1luPIXufcO+FDVaVkXw4PN2vsg8migeJC9L8uJLgSnE/ikc90wDkH/wKKxsxFyPdMSnFR1jj9oguIS3VeMQXtw/5OJ+zL3DMDYR/n01ZHmdmF8LVedhiNsBqLjUJsSF59x3vwTYvmkWvBUKz65moUHjwDjNmjHvgsPxxxgSKbRdUq72j/OjEiOFSW6G3xkt+zgRxvC6kRbkNb0BsgOe0kSBZKzXts+Y1ztpauKkxmdlFARNBGlv4D6dTnneHkbX9Oy8RDKqYGsGDDCM2w9i9YPze/l4cRWJm8Mm+7mGIjx/XeQqPIfr2ACKltA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2616005)(8676002)(85182001)(316002)(91956017)(508600001)(76116006)(36756003)(6916009)(71200400001)(8936002)(54906003)(38100700002)(66476007)(86362001)(64756008)(66946007)(66556008)(8976002)(5660300002)(66446008)(4326008)(122000001)(6486002)(38070700005)(66574015)(2906002)(186003)(85202003)(26005)(6512007)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aFE3NTViSGNpVEsrWGZBT2M5N0luTE05cmVGUm8wcDZUblNCSTZubkl4UjBt?=
 =?utf-8?B?Q0VJU1Y0d0dSV3Z2eE9nd00xOEt5U2VaNittdTNDbWpxdFY2L1R5MUVtM3pM?=
 =?utf-8?B?Wk8xTThPVDAzQUN5cWQzOThSTXhIVVZsMWFkSlRwaUdkWkIzTk02dFNzZ2Nt?=
 =?utf-8?B?Y0V6eUVmRFlZbzlteVFYMWRuczYxYjJuei9Ua2FzRmRPczV0UkVib05CVGE4?=
 =?utf-8?B?Y3AvR05xREtmdDg3cmxhb25wT1g5eUpKTURaTTkrY3JOeHVsdXlFRTJMd0ZQ?=
 =?utf-8?B?dllqQ3V2eTFSMDE4dzFZbjVYeXdaT1A4QnVmVU94SWZycnBISmwrelJxdWNK?=
 =?utf-8?B?MGg4dWhDY3FoT2JTbVpGWjMrbCtmV3RueGkvaUw0aEczSnhoaHlJQ2Y5Qmhn?=
 =?utf-8?B?R3k0TEFvRHRCOXNxWnpvamN4c2todFpHN0dTNUIzWHNidFp1Y0JtWFBWTnVo?=
 =?utf-8?B?bjNSVUIzdkJQWDkwSG1ZdURSN21CWGlkbDJ5MU1sbmdlOVArUzMzZE1Hc05v?=
 =?utf-8?B?NDQ0eFRERzdjODEraVhtQk9jLzJFYzdTQ0R3c1FCM1Vnd3dpVjZPcUxDUytB?=
 =?utf-8?B?cXptZnllVmR3V3ZiKzRkdEtDMFZDRVhxUDBMN1UzeGRlZTVBd3YrdXJCNVYy?=
 =?utf-8?B?VGVnRld3aC9Rd2dDdVRVcmFxbTlOUmFkWGIzTHpycGxUYWhKTWhnZFpXMFZZ?=
 =?utf-8?B?Vi8xMVlRd2w1aFBQTUZLVklwaFdYYUtQSTBDdlFSdlhsd0N2M2w2YVB1UU9S?=
 =?utf-8?B?L2ZvZGhZdzlRNmI1Z1I4czU3S1lOQmtmL24xSzdvajVYUS9FZmUrTFBVYTdT?=
 =?utf-8?B?dkVOWnRmSXhzMmpVRDVtTkNRNFl0QllTa1dPNUkxcVEzYXhCbEI0OW5qUzZo?=
 =?utf-8?B?aHlobGZCdEdRRFF5L3FTUU9uWjE0TDZBMk5CbDczVTdFQzQ2Zk9DZEFIWnJq?=
 =?utf-8?B?M0ErRk5MbzlNU1JUOHBZeS9jVFRwT0dnYUl0WHhQQTd1am4rclRhdDNsdk8w?=
 =?utf-8?B?ZTNWTzZ6Y3ZBd3NhQldCNnd4QUFwcGZ5cnNvcWlMemRIRFlMdmd6R1NBZm9B?=
 =?utf-8?B?aDlpWVVtVUxnVk0wVWljVUtsQmhZbmRweXFPdFcyMjdOV3JSNFFKYlZndEdY?=
 =?utf-8?B?c3hmSjFDZmMvMllLRmplTldVaVVrcythWm0wVU81eGsweWdXOEZCWGdBTXJ4?=
 =?utf-8?B?ODNzbDlTbmIyRFV6UzVRUXdsRkx5UGN0cjIyOXBLV1pEd01VOEFzNXBUMnRC?=
 =?utf-8?B?aXordkdBUVB1N09aODFGc1JHcmRyRjV0a0E4NzNHOWxYaFU5NE8wQ2tINEgw?=
 =?utf-8?B?Y1hyVlBIa3JjeXR6TzcvVVBlUjFzMDZ2NzVWSytTU1R6MkY4aE9UMGtxYVBr?=
 =?utf-8?B?OTBoZ3hBOWMrNHB5eFV5YWJjUS9telRlM1pVTDFaekN4enJYUndTZyt4Nk1w?=
 =?utf-8?B?dEJSNmcraFUzMVQya1FMYVV3WElWRTBTWis5enE1alVYYWF5eDIrdzJUWXJC?=
 =?utf-8?B?YUN2RVJPTHV4WWY2b200aVBoaDJwcHBMQlhGeDNsZDlRZHFtcEx5T0lReFIv?=
 =?utf-8?B?emRHTDgwOUVjeXlaZHAyRUwrR1dnUUtiUXRsa2F5ZkgrUG15YXYwa3lCZmtL?=
 =?utf-8?B?WXk2c0ZZNzE4UDBaYmRlS1Q4ODQ5cDFiVDRJUDZCWEFFTUYvRmJFTTlVdmd6?=
 =?utf-8?B?Sm9FbDhRRmEzVzhLMGZUL2ozTUZ1NEkyc1ZwdnZxNmpTS0FqTVNURU1rWUsw?=
 =?utf-8?B?Wm1KblhSYlQ3NVJaL0tYa3pMaXZKaG41YjlqcW1pVHc0Z1lrTUpRcS9BMkFn?=
 =?utf-8?B?UFAxSVhyNjRwT3RRSUd6MDZtTzdNZVU3dHl2bjZWTGhBRmRwR2FlNkZaWHZ5?=
 =?utf-8?B?RTVDenE2Nk1MRTRVL3QzU3FLNDA0cU9YeXNVUjBHV0pLUU43ZGFzS0Q2eXo4?=
 =?utf-8?B?MzhXL05BYm1YYWJSdG5XVFc0V2ZjQXJMNmIzRDFhZThXRld0OXU5ODVkTmVF?=
 =?utf-8?B?N0hUR0NIVDhXYm5ieUVvbmJFcDVWeFlIZW8zUHlCV3htOEI0YXZrU1h0Uy9v?=
 =?utf-8?B?Ly9aTGxFb2xxU2NRdUxOTzFqRUJUVTZzVm16MGlJNkxUNFNMeGFlbitVSVJQ?=
 =?utf-8?B?ekZpbmlpMkQ2WWZsL2Uyalk1YWdXNFI0ZUNrMGhZNW9OL09LTnFZeFBDQ1Vi?=
 =?utf-8?Q?m44DQsnrB/F1KCaHjI7qk9k=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <432F39FEAFCBED4194CF1A1F169BEF49@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be088be4-a772-4a9f-232c-08d9d6917f24
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2022 12:37:44.0218
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: a6lDZ8pDUzALy4F+M3zqalPB1jhQOUdzoeUmZgXq9BD0qfxsgf2S/I9sgUEFCpVSRTTa/T22p2F0W2KCw35ZOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR03MB5894
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJhbmsgV3VuZGVybGljaCA8ZnJhbmstd0BwdWJsaWMtZmlsZXMuZGU+IHdyaXRlczoNCg0KPiBI
aSwNCj4NCj4+IEdlc2VuZGV0OiBEaWVuc3RhZywgMTEuIEphbnVhciAyMDIyIHVtIDE5OjE3IFVo
cg0KPj4gVm9uOiAiQWx2aW4gxaBpcHJhZ2EiIDxBTFNJQGJhbmctb2x1ZnNlbi5kaz4NCj4NCj4+
IEx1aXosIGFueSBjb21tZW50cyByZWdhcmRpbmcgdGhpcz8gSSBzdXBwb3NlIGlmIHRoZSBjaGlw
IElEL3JldmlzaW9uIGlzDQo+PiB0aGUgc2FtZSBmb3IgYm90aCA2N1MgYW5kIDY3UkIsIHRoZXkg
c2hvdWxkIHdvcmsgcHJldHR5IG11Y2ggdGhlIHNhbWUsDQo+PiByaWdodD8NCj4NCj4gbXkgcGh5
IGRyaXZlciBpcyBzYW1lIGZvciBib3RoIGRldmljZXMgYW5kIGFmYWlrIG9ubHkgZG8gZGlmZmVy
ZW50DQo+IFJYL1RYIGRlbGF5cy4gV2l0aCB0aGUgY2hpcC1yZXYtcGF0Y2ggMHgwMDIwIGkgY2Fu
IGluaXQgdGhlIHN3aXRjaCwNCj4gYnV0IGhhdmUgbm8gdGVjaG5pY2FsIGRvY3VtZW50YXRpb24g
ZXhjZXB0IHRoZSBwaHkgZHJpdmVyIGNvZGUuDQo+DQo+PiBQaW5nIHdvcmtpbmcgYnV0IFRDUCBu
b3Qgd29ya2luZyBpcyBhIGJpdCBzdHJhbmdlLiBZb3UgY291bGQgY2hlY2sgdGhlDQo+PiBvdXRw
dXQgb2YgZXRodG9vbCAtUyBhbmQgc2VlIGlmIHRoYXQgbWVldHMgeW91ciBleHBlY3RhdGlvbnMu
IElmIHlvdQ0KPj4gaGF2ZSBhIHJlbGF0aXZlbHkgbW9kZXJuIGV0aHRvb2wgeW91IGNhbiBhbHNv
IGFwcGVuZCAtLWFsbC1ncm91cHMgdG8gdGhlDQo+PiBjb21tZW50IHRvIGdldCBhIG1vcmUgc3Rh
bmRhcmQgb3V0cHV0Lg0KPg0KPiBhcyBmYXIgYXMgaSBzZWUgaW4gdGNwZHVtcCAoc3VnZ2VzdGVk
IGJ5IGx1aXopIG9uIHRhcmdldCBpdCBpcyBhIGNoZWNrc3VtIGVycm9yIHdoZXJlIGNoZWNrc3Vt
IGlzIGFsd2F5cyAweDgzODIgKG1heWJlIHNvbWUga2luZCBvZiBmaXhlZCB0YWcpLg0KPg0KPiAx
NjozOTowNy45OTQ4MjUgSVAgKHRvcyAweDEwLCB0dGwgNjQsIGlkIDU0MDAyLCBvZmZzZXQgMCwg
ZmxhZ3MgW0RGXSwgcHJvdG8gVENQICg2KSwgbGVuZ3RoIDYwKQ0KPiAgICAgMTkyLjE2OC4xLjIu
NDMyODQgPiAxOTIuMTY4LjEuMS4yMjogRmxhZ3MgW1NdLCBja3N1bSAweDgzODINCj4gKGluY29y
cmVjdCAtPiAweGE2ZjYpLCBzZXEgMzIzMTI3NTEyMSwgd2luIDY0MjQwLCBvcHRpb25zIFttc3MN
Cj4gMTQ2MCxzYWNrT0ssVFMgdmFsIDE2MTU5MjEyMTQgZWNyIDAsbm9wLHdzY2FsZSA3XSwgbGVu
Z3RoIDANCj4gMTY6Mzk6MTIuMTU0NzkwIElQICh0b3MgMHgxMCwgdHRsIDY0LCBpZCA1NDAwMywg
b2Zmc2V0IDAsIGZsYWdzIFtERl0sIHByb3RvIFRDUCAoNiksIGxlbmd0aCA2MCkNCj4gICAgIDE5
Mi4xNjguMS4yLjQzMjg0ID4gMTkyLjE2OC4xLjEuMjI6IEZsYWdzIFtTXSwgY2tzdW0gMHg4Mzgy
DQo+IChpbmNvcnJlY3QgLT4gMHg5NmI2KSwgc2VxIDMyMzEyNzUxMjEsIHdpbiA2NDI0MCwgb3B0
aW9ucyBbbXNzDQo+IDE0NjAsc2Fja09LLFRTIHZhbCAxNjE1OTI1Mzc0IGVjciAwLG5vcCx3c2Nh
bGUgN10sIGxlbmd0aCAwDQoNClRoYXQncyB3ZWlyZCwgSSBtdXN0IGFkbWl0IEkgZG8gbm90IHJl
Y29nbml6ZSB0aGlzIGlzc3VlIGF0IGFsbC4gVHJ5DQpkdW1waW5nIHRoZSB3aG9sZSBwYWNrZXQg
d2l0aCAteCBhbmQgbWF5YmUgeW91IGNhbiBzZWUgd2hhdCBraW5kIG9mIGRhdGENCnlvdSBhcmUg
Z2V0dGluZy4NCg0KPg0KPj4gWW91IGNhbiBhbHNvIHRyeSBhZGp1c3RpbmcgdGhlIFJHTUlJIFRY
L1JYIGRlbGF5IGFuZCBwYXVzZSBzZXR0aW5ncyAtDQo+PiB0aGF0IG1pZ2h0IGhlbHAgZm9yIHRo
ZSBSMiB3aGVyZSB5b3UgYXJlbid0IGdldHRpbmcgYW55IHBhY2tldHMNCj4+IHRocm91Z2guDQo+
DQo+IHIycHJvIGkgZ290IHdvcmtpbmcgYnkgc2V0dGluZyBib3RoIGRlbGF5cyB0byAwIGFzIHBo
eS1kcml2ZXIgZG9lcyB0aGUgc2FtZSAoYWZ0ZXIgc29tZSBjYWxjdWxhdGlvbikuDQo+DQo+IG9u
IHI2NCB0aGlzIGlzIGEgYml0IG1vcmUgdHJpY2t5LCBiZWNhdXNlIHRoZSBwaHkgZHJpdmVyIHVz
ZXMgIHR4PTEgYW5kIHJ4PTMgd2l0aCB0aGlzIGNhbGN1bGF0aW9uIGZvciByZWctdmFsdWUNCj4N
Cj4gcmVnRGF0YSA9IChyZWdEYXRhICYgMHhGRkYwKSB8ICgodHhEZWxheSA8PCAzKSAmIDB4MDAw
OCkgfCAocnhEZWxheSAmIDB4MDAwNyk7DQo+DQo+IGJ1dCBpbiBkdHMgaSBuZWVkIHRoZSB2YWx1
ZXMgaW4gcGljb3NlbmRzICg/KSBhbmQgaGVyZSBpIGRvIG5vdCBrbm93DQo+IGhvdyB0byBjYWxj
dWxhdGUgdGhlbQ0KDQpUcnk6DQoNCiAgICB0eC1pbnRlcm5hbC1kZWxheS1wcyA9IDwyMDAwPjsN
CiAgICByeC1pbnRlcm5hbC1kZWxheS1wcyA9IDwxMDAwPjsNCg0KVGhpcyBzaG91bGQgY29ycmVz
cG9uZCB0byBpbnRlcm5hbCB2YWx1ZXMgdHg9MSBhbmQgcng9My4NCg0KS2luZCByZWdhcmRzLA0K
QWx2aW4=
