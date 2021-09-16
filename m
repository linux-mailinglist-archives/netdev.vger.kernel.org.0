Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A74640DD38
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 16:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236153AbhIPOu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 10:50:59 -0400
Received: from mo-csw-fb1115.securemx.jp ([210.130.202.174]:57570 "EHLO
        mo-csw-fb.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbhIPOu6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 10:50:58 -0400
X-Greylist: delayed 3380 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Sep 2021 10:50:58 EDT
Received: by mo-csw-fb.securemx.jp (mx-mo-csw-fb1115) id 18GDraJp032752; Thu, 16 Sep 2021 22:53:36 +0900
Received: by mo-csw.securemx.jp (mx-mo-csw1115) id 18GDqLjq007441; Thu, 16 Sep 2021 22:52:21 +0900
X-Iguazu-Qid: 2wHH6p2Z6DvkHjV78y
X-Iguazu-QSIG: v=2; s=0; t=1631800341; q=2wHH6p2Z6DvkHjV78y; m=nv3SbVhNbykBPw993oR+V5hNkGe0QhCaCumUxMoQ9TQ=
Received: from imx12-a.toshiba.co.jp (imx12-a.toshiba.co.jp [61.202.160.135])
        by relay.securemx.jp (mx-mr1112) id 18GDqIOf017532
        (version=TLSv1.2 cipher=AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 16 Sep 2021 22:52:18 +0900
Received: from enc02.toshiba.co.jp (enc02.toshiba.co.jp [61.202.160.51])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by imx12-a.toshiba.co.jp (Postfix) with ESMTPS id 39DDB10013C;
        Thu, 16 Sep 2021 22:52:18 +0900 (JST)
Received: from hop101.toshiba.co.jp ([133.199.85.107])
        by enc02.toshiba.co.jp  with ESMTP id 18GDqH0v003320;
        Thu, 16 Sep 2021 22:52:17 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ei59+axbxUb1XCSp2yeL3v0DH3Y7rnc+vib7uuljBINiHZauYxZQy4H8Q69YeNW8Z1higVG0JO87aN4B9pYhhDf9CLVYJKaZQ+ee4Td8L1sgwnyPoqTL6zPH9UpweC0hxDHwGfAPb6CavBVnUyuaNBmN+2mnLFeGSbZk8Qx7cLCBPiNkh71VkObntQ4weMQnzyfwkQzF/dF5mqVjeQ5Y1BWGWCkvQSoIF6we4bHR1tfyvO3GejFCN09ph2uxTtaw+q0RSwzFlKEQ4X1V/JV9FFlwIlo9ZWxXQ6cmnGO/pYg0HZarqt2fG3htAUV1RJIMswasPu8rdv+77Ub697o2qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=qQHt1nAuQyPeHEIxoYSc00tMRePz2NFjhC1VnwhDCaI=;
 b=TZFigsSV1Jbtrr9DEb6en08fknJ9O6e+CHV70Q2KWoCn7C6BP5H/rqG7jcPwOlDMYUSa3QGEsPUmT3btG3Q2AX/sM1P2iLDrcxJZpXiKBGYSpm0wqPwXtfTLWtvuS0zBvuAj0ZgXsON94SPjB21afRbU8zLXKD17VirgPGZlDowX+Za1X9OjjCuiC4VmQDc2JO80rHOdD5mHXz2t8k07wctqtMFuZ0On8th5+qi7YIAUDfilmm6/T4mEkjowLlKT2QU79wVSvyZ61ILfhGyo+QREL0W1YeCxVovYhzgSY/BzB8/iwtkZdY4SM8VDb67O3I7hGl4LuGJrmR7w/TeU5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=toshiba.co.jp; dmarc=pass action=none
 header.from=toshiba.co.jp; dkim=pass header.d=toshiba.co.jp; arc=none
From:   <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     <caihuoqing@baidu.com>
CC:     <peppe.cavallaro@st.com>, <alexandre.torgue@foss.st.com>,
        <joabreu@synopsys.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <mcoquelin.stm32@gmail.com>, <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] net: stmmac: dwmac-visconti: Make use of the helper
 function dev_err_probe()
Thread-Topic: [PATCH] net: stmmac: dwmac-visconti: Make use of the helper
 function dev_err_probe()
Thread-Index: AQHXqs3JD6w6hZXFY0C7gq3MGus7vaumrXNQ
Date:   Thu, 16 Sep 2021 13:52:16 +0000
X-TSB-HOP: ON
Message-ID: <TYAPR01MB62523D0B9A811F7DE5AE587D92DC9@TYAPR01MB6252.jpnprd01.prod.outlook.com>
References: <20210916073737.9216-1-caihuoqing@baidu.com>
In-Reply-To: <20210916073737.9216-1-caihuoqing@baidu.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
authentication-results: baidu.com; dkim=none (message not signed)
 header.d=none;baidu.com; dmarc=none action=none header.from=toshiba.co.jp;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 151aeb2d-2b3e-463b-b461-08d979193182
x-ms-traffictypediagnostic: TYAPR01MB5040:
x-microsoft-antispam-prvs: <TYAPR01MB504021B0E1CA0060055571EC92DC9@TYAPR01MB5040.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ggm+gMFY5bYRMvn7oXQlzeSMtiluqJG4WxmXdjsWIUMBRipi1olXlhhtI00GdTicovR22gOtQ48L7SC1ihGO2CDJ5yuFco9O+xaHxuhToOz5dUKc4oZgOiK4T8t84exCsgIPYjXAAsKf8D5ex0sDQj6NolkURXcomN/dy20luQl5zUSRqhjMHZIRuHcYby6QM9OyXIm8ko6xpMz/vTE2o5x7VlTw73+8FfD4XUDR+TRjZvZQoh5DVN+pEO5rHUR5NBJiEs4UVdjk1vUDU7mu97gwUJemTMFmgNa0TF7yl1x5e28VExDaNP93mGVLrWHwXJxhxXtTIwdzcvYzsnc58vS8Su+CFRWxzxLAPA/wAMqQDWqoIqmErVXgmnEh9oJFOyM7GuD9e6HuEn0hhGByf6J/tWx4MFTBJInutOL1hpPI0oqWwhmuezmaXZD4fEwwgQv2fNk42+CWp/GOceMPQdWocfPPFW7Um7D8karfP1odTg5nI5FB7FxhWkbF8AJbw6KlawRVJoPpNQdRTNv4hGHYiPC5otmdkGUGaUISnXdWJqcVzSwl0SYTJh5YiWbHzdAAEV+krv4lITSQfWeH4a4KGr10ZLMXnQ2+nPYQ4BCmDD9LO2I1dl7IhUBtD1o7K2Oac9wHGPqRd93/KoZHfOWSLrdLFHq3GLpEDID0hga+lp53k89+WVJFLZN8FRzgVLPjzujdenJY3vhqhcPZ6w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYAPR01MB6252.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(39860400002)(136003)(396003)(376002)(8936002)(186003)(64756008)(26005)(66946007)(66476007)(7696005)(38070700005)(76116006)(66446008)(7416002)(478600001)(66556008)(9686003)(54906003)(4326008)(5660300002)(83380400001)(33656002)(71200400001)(38100700002)(6916009)(122000001)(52536014)(6506007)(2906002)(55016002)(53546011)(86362001)(8676002)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NUJ1d3NXdENlY2toN051UmNUeUJaRkdpbXRqbkJXVU8xdXJubm8yRldEcGFO?=
 =?utf-8?B?V29zWGlQTjNWNDJpOHE1V2NVS0Rmdk1QUks0blNvSFhhTjRmV2V0cTNJM1lX?=
 =?utf-8?B?UXlqQktoQlpUTnJhY3owYThsZnQ1QmhXZ3J1bDdCUzd5T2hNdmlMRFhhZmdZ?=
 =?utf-8?B?SytRdWR1eWdYU3hsSmZUNDFtSnJ1ZHBqWkFNdnhTUXRIUFI1V2tpRlZZNVpr?=
 =?utf-8?B?MWUyVlVJdEkyckR3NGpCaHM5MzhDNENxZ09GZGFXR05HaU1OdUlSWEZtOXh3?=
 =?utf-8?B?RzFqSHhTUnZnZUp2c293OEdlUE1ta0lOczNEQm54REwyZktZWktqKzZILysw?=
 =?utf-8?B?WEhMUGwyK3F3UDdkTWN5VW5hZ2JVVHgxdCtUSmtlWDdCbmVDc0hSeGdXRHlV?=
 =?utf-8?B?NTZOaEYxbHpaQ3RCcWZTQys0RndYc0NOWmZzcEt0eHdWMDZRMmp2cXhzMWRt?=
 =?utf-8?B?dGFnZnZxQ090NU0vbm83S05EcVZETEduMU5EZ2pYQmZmbE92bFBXemdDcmVv?=
 =?utf-8?B?RmxXSGhPWFNvTlBLOU9OdWxNdkxQTk1nY2d1SFNRRENQWGQyQWhRNTRROU9Y?=
 =?utf-8?B?RVJTcUM2SzlnOEdFV2dNNy9HYnAvSGxXRXNJUUpCeUxOMUNvYTBUVTdzV05I?=
 =?utf-8?B?c0Y5eFFmUEFzNFI2YUNFVGZob1hGcE9JOWFpNVRQeHpiZXVZT1c1ZXl4WDBj?=
 =?utf-8?B?V3Q1YkVOOXFaL1Q5SUVTVDRLdEx3MVdybFk1WjJjOG1GYXhrWjBDOUJQMCtZ?=
 =?utf-8?B?dnVqVnRSRlQ2YWJmcDJmWUNsTmptc0tKSktXdy9WZUJFREJrNW5LWGowTCtU?=
 =?utf-8?B?WGdKcXJvRytXYm1RcFg0eE9rc2d3NzliR3VXWHFWVnpsYjZIU2lXTjNOVVZJ?=
 =?utf-8?B?bVBhTEdTVUFHdXlBZzUreW9PN3ZGRWVCSmFuZkt3d3NXRXlPalNQdXdiZllm?=
 =?utf-8?B?a2ZBbUdGNG5NMHc3Y3lBQjNvRG4xVTk1b09kSEplLzRjSk5BRjRQNmNSR2tt?=
 =?utf-8?B?TFJlamZOTXk5azFFc0NjOGRzY1lVT3I3eHpvcEJUUzJGbEVWTlRQVUIxeURM?=
 =?utf-8?B?MUhkWHFERTlzR1k5UnA2d0VlTlpwV1ZEVXlremdoMURaeks4UnNibXI0RzBT?=
 =?utf-8?B?cTI0NXcxVWhrb21BbFpGZy9kSU9ERTF0SWNzZUp2WkdpRkk5ajFSZ0c3dzgv?=
 =?utf-8?B?SGZ1NFBqdCszaFp3cVB3UDNmNG9ZenlXRWNhUDlYRDdlMk1NTVl0bGE1bG1m?=
 =?utf-8?B?Unh0cHJaMlY4Q2RRSWJyOE0vUTlENUZhQVQzK0FLUDJHSnZqdksvQWVjVkhr?=
 =?utf-8?B?N1VROXZFMlJqaUhqaC9EN0RMeS9wSlNDNDF5dXlDZVVSbGxKZzY5dlk3QVZX?=
 =?utf-8?B?L21uazlHTXFScWJ1bXFoazBGQ2VNOGNnczJlaEJUc29FK3M3SStWTFNjV1dx?=
 =?utf-8?B?MnFCYnJ3TFR0UUthcXdQYnVUeFpUZ05QY3NIK1VqNjNIWjFmU2lvTURod0F1?=
 =?utf-8?B?ek9YTkNZaXN1S2tkaWxBN1JrbkRrNUptRGRsNFpVbzV3VUZMODhoUHRPQlR5?=
 =?utf-8?B?bEduYStWVjJSNkt2dE5NZUtDNGpjRmV3Wk04NyszZjJiT09xQnFaNUtGdThY?=
 =?utf-8?B?MTlsb2swSnljQmFsTzF3TDNaM0dOYkFyaEJJbGhNTjdNR3c2ckU5SFBJNDRn?=
 =?utf-8?B?bHlsZTc2cENkTXNRSGN0a2kyWTVHdHRnQ1BLajEyT3hZc09qMEtuNE91dFZB?=
 =?utf-8?Q?4II8yIPA1PWiexB63klfUcHmSp9NGtljBFI1+gu?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYAPR01MB6252.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 151aeb2d-2b3e-463b-b461-08d979193182
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Sep 2021 13:52:16.0612
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f109924e-fb71-4ba0-b2cc-65dcdf6fbe4f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WYfTgULj+xJXfS3uzj/mKeCbpH4wZBiOstCv10jkgBE3eRz81RPTr1RCuzNmrK1Rc/0topwRmrhy5syB0MZeNX5sWzTX8nS22RXtrHy7+EEieU8UCKOhnek9mUbeJCMD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB5040
X-OriginatorOrg: toshiba.co.jp
MSSCP.TransferMailToMossAgent: 103
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGksDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQ2FpIEh1b3Fpbmcg
W21haWx0bzpjYWlodW9xaW5nQGJhaWR1LmNvbV0NCj4gU2VudDogVGh1cnNkYXksIFNlcHRlbWJl
ciAxNiwgMjAyMSA0OjM4IFBNDQo+IFRvOiBjYWlodW9xaW5nQGJhaWR1LmNvbQ0KPiBDYzogR2l1
c2VwcGUgQ2F2YWxsYXJvIDxwZXBwZS5jYXZhbGxhcm9Ac3QuY29tPjsgQWxleGFuZHJlIFRvcmd1
ZSA8YWxleGFuZHJlLnRvcmd1ZUBmb3NzLnN0LmNvbT47IEpvc2UgQWJyZXUNCj4gPGpvYWJyZXVA
c3lub3BzeXMuY29tPjsgRGF2aWQgUy4gTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0PjsgSmFr
dWIgS2ljaW5za2kgPGt1YmFAa2VybmVsLm9yZz47IE1heGltZSBDb3F1ZWxpbg0KPiA8bWNvcXVl
bGluLnN0bTMyQGdtYWlsLmNvbT47IGl3YW1hdHN1IG5vYnVoaXJvKOWyqeadviDkv6HmtIsg4pah
77yz77y377yj4pev77yh77yj77y0KSA8bm9idWhpcm8xLml3YW1hdHN1QHRvc2hpYmEuY28uanA+
Ow0KPiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBsaW51eC1zdG0zMkBzdC1tZC1tYWlsbWFuLnN0
b3JtcmVwbHkuY29tOyBsaW51eC1hcm0ta2VybmVsQGxpc3RzLmluZnJhZGVhZC5vcmc7DQo+IGxp
bnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogW1BBVENIXSBuZXQ6IHN0bW1h
YzogZHdtYWMtdmlzY29udGk6IE1ha2UgdXNlIG9mIHRoZSBoZWxwZXIgZnVuY3Rpb24gZGV2X2Vy
cl9wcm9iZSgpDQo+IA0KPiBXaGVuIHBvc3NpYmxlIHVzZSBkZXZfZXJyX3Byb2JlIGhlbHAgdG8g
cHJvcGVybHkgZGVhbCB3aXRoIHRoZQ0KPiBQUk9CRV9ERUZFUiBlcnJvciwgdGhlIGJlbmVmaXQg
aXMgdGhhdCBERUZFUiBpc3N1ZSB3aWxsIGJlIGxvZ2dlZA0KPiBpbiB0aGUgZGV2aWNlc19kZWZl
cnJlZCBkZWJ1Z2ZzIGZpbGUuDQo+IEFuZCB1c2luZyBkZXZfZXJyX3Byb2JlKCkgY2FuIHJlZHVj
ZSBjb2RlIHNpemUsIGFuZCB0aGUgZXJyb3IgdmFsdWUNCj4gZ2V0cyBwcmludGVkLg0KPiANCj4g
U2lnbmVkLW9mZi1ieTogQ2FpIEh1b3FpbmcgPGNhaWh1b3FpbmdAYmFpZHUuY29tPg0KPiAtLS0N
Cj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L3N0bWljcm8vc3RtbWFjL2R3bWFjLXZpc2NvbnRpLmMg
fCA3ICsrKy0tLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDQgZGVsZXRp
b25zKC0pDQoNCkFja2VkLWJ5OiBOb2J1aGlybyBJd2FtYXRzdSA8bm9idWhpcm8xLml3YW1hdHN1
QHRvc2hpYmEuY28uanA+DQoNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5l
dC9zdG1pY3JvL3N0bW1hYy9kd21hYy12aXNjb250aS5jDQo+IGIvZHJpdmVycy9uZXQvZXRoZXJu
ZXQvc3RtaWNyby9zdG1tYWMvZHdtYWMtdmlzY29udGkuYw0KPiBpbmRleCBkMDQ2ZTMzYjhhMjku
LjY2ZmM4YmUzNGJiNyAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvc3RtaWNy
by9zdG1tYWMvZHdtYWMtdmlzY29udGkuYw0KPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9z
dG1pY3JvL3N0bW1hYy9kd21hYy12aXNjb250aS5jDQo+IEBAIC0xNzEsMTAgKzE3MSw5IEBAIHN0
YXRpYyBpbnQgdmlzY29udGlfZXRoX2Nsb2NrX3Byb2JlKHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2Ug
KnBkZXYsDQo+ICAJaW50IGVycjsNCj4gDQo+ICAJZHdtYWMtPnBoeV9yZWZfY2xrID0gZGV2bV9j
bGtfZ2V0KCZwZGV2LT5kZXYsICJwaHlfcmVmX2NsayIpOw0KPiAtCWlmIChJU19FUlIoZHdtYWMt
PnBoeV9yZWZfY2xrKSkgew0KPiAtCQlkZXZfZXJyKCZwZGV2LT5kZXYsICJwaHlfcmVmX2NsayBj
bG9jayBub3QgZm91bmQuXG4iKTsNCj4gLQkJcmV0dXJuIFBUUl9FUlIoZHdtYWMtPnBoeV9yZWZf
Y2xrKTsNCj4gLQl9DQo+ICsJaWYgKElTX0VSUihkd21hYy0+cGh5X3JlZl9jbGspKQ0KPiArCQly
ZXR1cm4gZGV2X2Vycl9wcm9iZSgmcGRldi0+ZGV2LCBQVFJfRVJSKGR3bWFjLT5waHlfcmVmX2Ns
ayksDQo+ICsJCQkJICAgICAicGh5X3JlZl9jbGsgY2xvY2sgbm90IGZvdW5kLlxuIik7DQo+IA0K
PiAgCWVyciA9IGNsa19wcmVwYXJlX2VuYWJsZShkd21hYy0+cGh5X3JlZl9jbGspOw0KPiAgCWlm
IChlcnIgPCAwKSB7DQo+IC0tDQo+IDIuMjUuMQ0KDQpCZXN0IHJlZ2FyZHMsDQogIE5vYnVoaXJv
DQo=

