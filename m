Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21F2D6B5D95
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 16:57:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbjCKP5g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 10:57:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbjCKP5e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 10:57:34 -0500
Received: from IND01-BMX-obe.outbound.protection.outlook.com (mail-bmxind01olkn2070.outbound.protection.outlook.com [40.92.103.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1127C20D37;
        Sat, 11 Mar 2023 07:57:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QsTlqWGU8dmDxj0bYWuZcfXQzNe2uz9R1oRhClDi8mx5BJ9UAw5s5roGZ3XQVZHMN8jop8rKCqMt1euiklMCYHVoJ37gi67DNqRSUH5Sx0o75dzJUF9SdGPQaZVEpOJFi0TC4p+P0L8NQdKl/pisZJVpc8lDHHXJTnh5Xr07fsxfRL9Gj8P598YpmMKq/qgyOyJzGR1op9QHDWZ9ijKDKegjGBmEl4EfWG05QcYhR5EhjWB1YDh6N3HPmWLDwinc856mhZxorP56mr/CZ1vf/KYvJQhObpo/q5z9zZ0C0RIjFOhDYMsD/530c4CQZAAyMuaC8h668mfNjUxyiG38Bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d/hJVQUBAPboOsM0xyv/0yU/dOLUV9nSS3yIfysMMos=;
 b=nVhSypODi4MAVH+VFWGywYH8XeLtaj30IJrNNjCVgufo3bVxzT33WvkQnUYTmlMstifaHJVa8EIIs2fGVH9IdUzj70h7EK8IUnO5a/OaOWKOo6X5XYy5Qslyhus0ZcEL4EDde7lzIdLUr4Aur+PfRu7PgQScBVOjZmb1fr267ywlJV2GgNxTfN5ycToeWrPW2avuMDFZwDLFoVGNIYFfk9IzMQfLi5CN3eFj0YCCK3D5MHxmx7bIShrPftzRtNl4V19noGzCrPmyAijOqeFDH01VPbLubCHhuiSPpVWhqUbVdhvQvybzjUcp4M/0mXfyLwn55PIh5syN67PjnvwjCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d/hJVQUBAPboOsM0xyv/0yU/dOLUV9nSS3yIfysMMos=;
 b=jpnjgWoPbhHbVbWICSodqPNt9FiV9oXkwRs86lzMdxQB+IurSnGs8B0pTnVbGNhQI5gfJTEwJNrqe9IZ6zXUynyiBVifpdd7JaS+dnlJWTf+oc1rmjkXAlD6unT7FZIAjSvRg5QDUES1BWIOGZQNhCS0C72yPbug6l+G7ffewequ1mwBqpOKmUHTDA0lk0NE0NITFguU9bITUYmcIWnlcO7uBXE+tF8iBThMOdvjWl1MfBowoD+6allV4tMUnAAYuafzWLTneqTmgyv2fZGqODomY8R3bQLV01JsuHQMbBSoamD72S4o6YaJ0Kj5xpnovg8tMQTnkMGvKzTBtA34UQ==
Received: from MA0P287MB0217.INDP287.PROD.OUTLOOK.COM (2603:1096:a01:b3::9) by
 MA0P287MB0635.INDP287.PROD.OUTLOOK.COM (2603:1096:a01:113::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.22; Sat, 11 Mar 2023 15:56:53 +0000
Received: from MA0P287MB0217.INDP287.PROD.OUTLOOK.COM
 ([fe80::945f:41d7:1db:1fd3]) by MA0P287MB0217.INDP287.PROD.OUTLOOK.COM
 ([fe80::945f:41d7:1db:1fd3%9]) with mapi id 15.20.6178.021; Sat, 11 Mar 2023
 15:56:53 +0000
From:   Aditya Garg <gargaditya08@live.com>
To:     Hector Martin <marcan@marcan.st>,
        Arend van Spriel <aspriel@gmail.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>,
        Hector Martin <marcan@marcan.st>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Orlando Chamberlain <orlandoch.dev@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [REGRESSION] Unable to connect to Internet since kernel 6.2.3 on T2
 Macs
Thread-Topic: [REGRESSION] Unable to connect to Internet since kernel 6.2.3 on
 T2 Macs
Thread-Index: AQHZVDIZrgKVD5BwUUKnSeJZZ1urjA==
Date:   Sat, 11 Mar 2023 15:56:53 +0000
Message-ID: <MA0P287MB02178C2B6AFC2E96F261FB2CB8BB9@MA0P287MB0217.INDP287.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [0tgWuwl5gpOwYF9KCgv001EWZbjtwBDW]
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MA0P287MB0217:EE_|MA0P287MB0635:EE_
x-ms-office365-filtering-correlation-id: 5fe41282-21c2-4d6a-adc6-08db22493bd6
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7VEDD8wFztSZ3O4l4bib4tW6HOwj/ssE30IYZheTPwMZscva/xYk51Me/sdinpRb1i9qQv60RcezPqsp+wwNSInNlsfSXDq2Kn0y5+Vy+6rBbBVm7MXC7/HJP/pE/9U8OyTB/JIHZHl2jrKveR7g/P+51ZMVn5By6YxmEmbyRllS8l59+hLfnl6geIasYMODkdf0r5Wt6t3oYtrgJ5cPyKL5kjraG7cXcUJqrG1grcoGAa7Sgmz2/2HLc78Az8TBweXLOfepN+tmBZAu79vv8JQynpFlvC3GzFogw0ml7FIvud7IlTnMZVCdypyNm+1k7zOtmoimcJCbIyt1xcbCuaq9ErtODvUUM5lDn8ikBDXOPL5HV9klWCgJIXQYP8SmQpNn+SKsXgBbx0Vg7kb4pGqrMuLdF8ZLK/kdRVtSnGw985IoXKGxBHOGXvpckQ5w8EDzncN93FdtbVu/zdkXCSo72HLBtfnFCwlejKVvYKlXSqJQafD+W0np3kZ/JlEF7/Pp3ll1ixcOiAFrgqaFCblROhdPNrap99O6F848PMXEHNMf5SMpN61qKAvidvx0KgCFT5XhCznkYwm3wUd0AQ==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?b2JSWWV3ekRXeFpKa3Zzek9EUlk2eUR2MTFjbC9jQ0NkY0RISXFmT0V4TTN0?=
 =?utf-8?B?UkpTMmlUaWxpbTRrVFJsMHQ2VzlNQUQ0ZTltd2pKUFZWaFpjSGdqYVc4UzQ2?=
 =?utf-8?B?Y3FCS3dsYURlMTdocFNWOWdDWFNQRVA5VFNzMmtRQkVXYVNUaWUxL0N0MTJM?=
 =?utf-8?B?M2cwVnpnaUVFQnIzamVVTC9ObG13bzBKNVczTnc0dzZWQ0RvREs0ZmpkVUVw?=
 =?utf-8?B?anZRdFVUVExBVWFrMWdYUDk3ZzltcEJLVGM0NWRNM0g4MitYM25BdUJqcWJX?=
 =?utf-8?B?Tnk3MS91aklrZFM1TFNDVXZyR0hnWUdmQ095NEs1c0o2bktxdFlIeXlOMnBL?=
 =?utf-8?B?SWRyOXN3bnh1U2R0WlYxZ3dVNVRjSUdObm1xYUtoQytXYTV1cFNSc3lMSFd3?=
 =?utf-8?B?bUlpWTlaSlM1WjIxYkU4QXJmaHFRdS9aVU1JdTVncXJqTUh6QUdrcFpaQUt1?=
 =?utf-8?B?NG5VWjgvOUlwZXd1MUtOYkdtTXdOcEkrdTlvWjlvNVM2a0RFYXFpNFFRdDlr?=
 =?utf-8?B?TGFINVhtU2Fzczhvb2h1cCsvVVpxQ0hXNlYxbXcrWHZmMVdJZjZzSjJBMW5p?=
 =?utf-8?B?Qm15c1JYRzVtR1JYdVNQV1JhU3BZNzdsL3hJOFRDTmpJYUJzNnlCbnRQd2hN?=
 =?utf-8?B?enNBZXlGOWpjRzR0ekZoVnJoYmxaZlZ2VmRQSFd2bVUrMWREQ1Q4Z3JPOUJX?=
 =?utf-8?B?aEdNazZSalE1L2hoTlRPaEpCK1F6ZTRnZ3pHVlV3aTFybENFSWxNVGQwZEln?=
 =?utf-8?B?TEIzMzFETHUxZ2d3QXUybVlERFJhKzJPb3haZ29EeEJ5cDlSbEhHUXM3UjN4?=
 =?utf-8?B?M3NKQWdxeWNCakQvRXlGVDRiK25SVUhlWTBUcUpDc2JnS1pybzVNVzdzMXdC?=
 =?utf-8?B?MzNiVVFqOW5kcGk1c0M2bDdnUjFEL3JacU95K0FHZml2YnFjazNkWG1CS1k0?=
 =?utf-8?B?bUQ5YkoxZU9vV05IOTZCcWRkK2ZqenNWL091eXJPMkE0TFdQYjZERDRlY2g3?=
 =?utf-8?B?OUsyZW1tT2kyOFllK29ndFNKQkU3VWpUb21TSnN3aW11K2JmWmxLRkM5cmsz?=
 =?utf-8?B?RURDMFJRZUY1cUhPalNrdksxbGUzWHMyUXFybytyL0hsY3NnRzNvYi81R2M5?=
 =?utf-8?B?Q2k1YkdmazU0RWw0MzVLSWkzTjVXNjBCSUhqWDBieDJHbGxuazIrUTdHQ281?=
 =?utf-8?B?ZlFjWm5FTzZia0JycGN2ZGhGMnFNR3p4NzV5cHI5eFJ3N2piUG9YSnNkck5E?=
 =?utf-8?B?NGZQUjBiZHgrS3dNTFJPYkxUTklXVmF1bmltN2hzRVliQW00Q2tZMlJPUCt4?=
 =?utf-8?B?cjBDR3Z2S1dmeVU4dUtjTzcxVmxHWThNQkZWdGh1djZrVk5HaHNuMDZtenB5?=
 =?utf-8?B?OHBEWVE1L2djWXJQcWM1eVRRbHZ3eTM0b3lTL1FXeWFOb2JaTE9PeEcvNmEw?=
 =?utf-8?B?aEVFRHh2MUNlUm1aZXp5NkRqWGdHS28xOXlTdEdSaUhWYURwN1d4TmdRMitG?=
 =?utf-8?B?YzBqN0drMlpPR01pc3MrdElLSlVveDFzRVJJOUJOejhnZDREL3BVN1d5NGdu?=
 =?utf-8?B?YkVZZzE1Z0ZCMWk1NlFNNUt3WTQ0Z0psRExacHJMWXk5RmdIRE00aUdNZnZO?=
 =?utf-8?B?Um4zbWNXOVdTa3BBbk5tY0ZwK1k2OHVJMG1Fci9NRSttSUtkWFdoMW0yVVVS?=
 =?utf-8?B?UGY4WmJFeFdJb3JtZllHanNHZUprSWI3dzQ0dzhBWStrR09pcFN0TkFRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5C0ADF48D6A38B44857A64E962531476@sct-15-20-4755-11-msonline-outlook-bafef.templateTenant>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-bafef.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MA0P287MB0217.INDP287.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fe41282-21c2-4d6a-adc6-08db22493bd6
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Mar 2023 15:56:53.4471
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MA0P287MB0635
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

QSB3ZWlyZCByZWdyZXNzaW9uIGhhcyBiZWVuIGFmZmVjdGluZyB0aGUgVDIgTWFjcyBzaW5jZSBr
ZXJuZWwgNi4yLjMuIFRoZSB1c2VycyBhcmUgdW5hYmxlIHRvIGNvbm5lY3QgdG8gYm90aCB3aXJl
bGVzcyBhcyB3ZWxsIGFzIHdpcmVkIEludGVybmV0LiBBcyBmYXIgYXMgd2lyZWxlc3MgaXMgY29u
Y2VybmVkLCB0aGUgcGF0Y2hlcyBmb3IgVDIgTWFjcyB0aGF0IGhhdmUgYmVlbiB1cHN0cmVhbWVk
IGluIGtlcm5lbCA2LjMgaGF2ZSBiZWVuIHdvcmtpbmcgd2VsbCB0aWxsIDYuMi4yLCBidXQgYWZ0
ZXIgdGhhdCB0aGUgbmV0d29yayBoYXMgc3RvcHBlZCB3b3JraW5nLg0KDQpJbnRlcmVzdGluZywg
dGhlIGRyaXZlciBzaG93cyBubyBlcnJvcnMgaW4gam91cm5hbGN0bC4gVGhlIHdpZmkgZmlybXdh
cmUgbG9hZHMgd2VsbCBhbmQgdGhlIG5ldHdvcmtzIGV2ZW4gYXBwZWFyIG9uIHNjYW4gbGlzdC4g
QnV0LCB0aGUgY29ubmVjdGlvbiB0byBhIG5ldHdvcmsgZmFpbHMuIEV0aGVybmV0L1VTQiB0ZXRo
ZXJpbmcgaGFzIGFsc28gc3RvcHBlZCB3b3JraW5nLg0KDQpJZiBJIHlvdSBuZWVkIHNvbWUgbG9n
cyBmcm9tIG1lLCBwbGVhc2UgZG8gYXNrLg0KDQpBbHNvLCBIZWN0b3IsIEnigJlkIGxpa2UgdG8g
a25vdyB3aGV0aGVyIHRoaXMgYWZmZWN0cyB0aGUgTTEvMiBNYWNzIGFzIHdlbGwgb3Igbm90Lg==
