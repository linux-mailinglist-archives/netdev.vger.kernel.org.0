Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 196E169B77C
	for <lists+netdev@lfdr.de>; Sat, 18 Feb 2023 02:27:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbjBRB11 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 20:27:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbjBRB10 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 20:27:26 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2087.outbound.protection.outlook.com [40.107.8.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D07C95649A
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 17:27:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A4Wf8XgZvH75fAmjEpabtQsdJqii8Mviyb1Hfe46IYKFWAzsRfC5QF+wFhU/ecDqpxcuH7H+8SGUtiWJrcypvmbt7n+qgB8/c5TD+vAolPTv8nhDgG02Fq4jdMPZejb5T7SgnYGFB25cNyQb1Z38oJH6Kb9jirIUVMbZit5+QzSntoLUcvCbPYxWbkUYGGPFyKsX1lzEbk+Qa6ZuP8XFL6pXfYmJyMpP8Vyr3P9vvrGZ6ppt/R/IhQWW5IRqe2eIyJ03GwGYpq4a8dWVkJAd6hCwMMXy3z7pknDBXURkRNEbXAl44yf1MF3+TyvmRV8dlst0Y/QWvXo5SmhhzaODVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kcDxCKtlV5TIwqrRzOfW4IZHTie7kJ0Br6//gzF/2A8=;
 b=Ib8jeb0OUBco8L5uET0u4PK3udHAqBrUajjb/G+OOGvqHnTF4DJeosfriMbuIFvxa6xKWw1wFnF+SxeerDFblJlj6D30P3Aj9cYJPJcBOiTcOjlQoM8KJw1T1eHfG77yJ5Nakc0IbAQwdZK4S5Cjp/M2OI/81THXbtGUW7KB3dRRLvQqb88DJA/Ec8L+F8WRD9/RlWVd80kahtFMhwtSpiqwEIIp5se+/CYVaedNwl8pcMzn8jJInzR3Sjq4/cpFg0LcYNy4ROLBSUim+qQVrFtprHm4n5uziV2kjDFjWLqDQ5C3zu3/5Z2f3IXZ9L6hxTat6vlJUzkXSZpvhcuXzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kcDxCKtlV5TIwqrRzOfW4IZHTie7kJ0Br6//gzF/2A8=;
 b=qGWpI9l5IMLDufy3nh40DLTEBqdWfT5bfyMpIF/6GD3e9CegqPFqqnj9/iuBFbEbnIRI03JeE7eA7Qchcw7QXk4PteogtKAYdXmCE771VzN51q944wvUMLtdwSZLQlg1/VzFeFF7FJXvQKwpdMe0JVsNSBuPfxLlwY73Klz4ibw=
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com (2603:10a6:10:24b::13)
 by AM7PR04MB7109.eurprd04.prod.outlook.com (2603:10a6:20b:117::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.13; Sat, 18 Feb
 2023 01:27:21 +0000
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::5b45:16d:5b45:769f]) by DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::5b45:16d:5b45:769f%6]) with mapi id 15.20.6111.017; Sat, 18 Feb 2023
 01:27:21 +0000
From:   Wei Fang <wei.fang@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        David Laight <David.Laight@aculab.com>
CC:     'Richard Weinberger' <richard@nod.at>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: RE: high latency with imx8mm compared to imx6q
Thread-Topic: high latency with imx8mm compared to imx6q
Thread-Index: KX6nItb3xzzXXgLsKrBE7F/dfPfNJbU33POAgABHTYCAAAZaMA==
Date:   Sat, 18 Feb 2023 01:27:21 +0000
Message-ID: <DB9PR04MB81065CC7BD56EBDDC91C7ED288A69@DB9PR04MB8106.eurprd04.prod.outlook.com>
References: <1422776754.146013.1676652774408.JavaMail.zimbra@nod.at>
 <b4fc00958e0249208b5aceecfa527161@AcuMS.aculab.com>
 <Y/AkI7DUYKbToEpj@lunn.ch>
In-Reply-To: <Y/AkI7DUYKbToEpj@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DB9PR04MB8106:EE_|AM7PR04MB7109:EE_
x-ms-office365-filtering-correlation-id: 09d29d1e-fc47-4cc0-52da-08db114f483f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tzB1VXfkWjzKu+eokFxE37O/Q6MKE0LulzNK96/lBFu3gX0ZSofyX+mIOJnCq0MK6FBhYgFvJ3sQg2QSybd4pJJf6gHpQtXE7UDfVKvgo4qsnVYx2MiZl2Xydp+YCEmAGsUthy3B3wtLHwGvYQ6TgMLl/UgDzAvLh7HeIc8VB678heu2HFbCovbpuMGy87YBs0H4PS6RN5y1knwn8gUxKYl0ob7WHJURaRlIAs1YjC5ROWa1bFVgRrZPOg+PB9p2Nl2sKgQSwEsDXHoQn0Ctq/bTuMUiVcLrsRrxfd/Evkum0Y5NwkgDN1havKkGHmCANBzoGViNmQ2HrCx8OxXbIYPlEH48WIakHjay/CDsY4ezlJPzQrHPjMmZ6zLhPfcXl4NXAgeWV/BbJqF7YfJfL5rhXpkg72esVv2uTCs0TSU+jK0qXvfjCQiVWkoUmO8CoLNrnTfctAKzlKPIhXH8ze0C2QZFTpwjTEtnfFEfFb0kL+AsA5kz+vh+QDB1xWS/VwBs1iD8itrlWq0CEuo4E1GcIBXgw0wAJB2zcl9fJkuzo2YqE5EOeuFTMCLAagzkQNwhIq8p60KLSltTs12tt8SDGELoDOn3a9Ww5DVdgqsV5BwGzaRbcEPnGlXy9EKuCclUw0gbz2kl3bvlHSaxJH1ShuP+b5msAQ9ONi6IFmTyawUN47jynkA77TQcK2MijlEXwoRsxMN0wwmiQWeZ0EVwGeQZHycP92hlmyHKmS0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8106.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(136003)(396003)(376002)(39860400002)(451199018)(54906003)(52536014)(55016003)(110136005)(86362001)(38070700005)(5660300002)(41300700001)(316002)(76116006)(8936002)(33656002)(478600001)(64756008)(66446008)(8676002)(4326008)(66476007)(66946007)(66556008)(6506007)(9686003)(2906002)(26005)(53546011)(186003)(122000001)(83380400001)(44832011)(38100700002)(7696005)(71200400001)(32563001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?S1d5ZG4xY3NlVnE3WDFBbm82OFhoYkxOWXBWS1E1S2lvY2t0ZzNMV2VxUExy?=
 =?gb2312?B?WG1MUEdDQndrUS9ObW1mVkN0aEI2QnVoNkd6Q1M3eDlVM0paNXl2ZTZyaDUy?=
 =?gb2312?B?T0dkRW4vVXhqQ1lySTM3cVI3elZ0eHBsQlkzUWI4cFRvWTZiNzdMNnl3SCtN?=
 =?gb2312?B?ckJhNUljc1JtenNpQlg3TytXZzJENzl2UFdVV3hjY3FjRUdPcEUrSjBQNzd6?=
 =?gb2312?B?aUtLRkFaNFkvMG5wSUorZzBLVUNVQTFJUEcrR2YwR2E1dHYzRVROK1dOYlFQ?=
 =?gb2312?B?aThxVjdPZGZtUEFTNnJOVlVJK3haR0JoR1M5ZWNWb0RoTXBabHZsNGJYR0dB?=
 =?gb2312?B?SjN3cENmQnE4T1ZDcFRobXl3QXZpNnM2N2MyZFhVUHoxck1OSFIxandlQmtL?=
 =?gb2312?B?MTl3aHRzTTBQQ2laS0ZZbkpqVkQ0MlBnMWVMTk1XODh5c2xETTNIU0ErRm5Y?=
 =?gb2312?B?N2VxTEU3QXVKVVFZRFZ6OHpGelRtdlUwSnY4MEszUi96M0wyWG1sTStvbjkr?=
 =?gb2312?B?THZTa0wrQ1pmMy9ocFAvNC83ajN5TUZYL1c2aWZ6VEwwV3c2WENydjBmV2xt?=
 =?gb2312?B?bThBZ2ZPcktlSE5rcy9Wb1VmRE1hWU11SkQ4Y1IvWUx2M1pHeEpVdWtBNDVn?=
 =?gb2312?B?QVlidDhQdnpQcWl5ZGxiK01kL0dGS0pPUWw1RDR6ajVmaTlOMUQrVkRyTHVt?=
 =?gb2312?B?Tk1zZ2RmblRpOXdxRzAvSTB1MllIUm1VUytiMXE1cC9BSjZsK1FNVkFuT1lW?=
 =?gb2312?B?RURyTWpxK3pUUEl2YTVDcEpBSDNTWlJGbERrditOd1ppTWpkcENyZC9rWVMv?=
 =?gb2312?B?VXBDQlhhQmhqNGoxTzVkTEZ1ZUYrZlQwZVVhWEtUSWI0d3ludXU0Mng2aXRR?=
 =?gb2312?B?ckpRVDhFTmswVDk3eUV2RFJwV05wMFNISEF1WCt0Yy9jL0t4SC9XVWc4T05Y?=
 =?gb2312?B?ZEphbDhvOTVnTnlmWDVoRmZSa01lb0JsMVdZL0svdGNwYWN6YkwxMTVwbm1K?=
 =?gb2312?B?cGRMbGFHVmJEWlBSanJKaC9PcEFNanJzMW9xNHZpVnFlUlVCNUdURCthMk52?=
 =?gb2312?B?NVczQ0FzNmU5bmhuczZETXNHckVlK29pUE1iUVNPczhsQnFkemYvVGJYbk1O?=
 =?gb2312?B?bnZrbTROM3F5QlN3cmVpYzFZVVpHVWNYSDZweXN5NXkvcXlSZUgzd3I5cmgv?=
 =?gb2312?B?NER5SEpZbjNhbVVCR0EwQTFqTDZ4NlJZeHd1dStzTUVyNGxYSEZpYUkzOVFs?=
 =?gb2312?B?VEp2cjV1c2UvZVQ2VFh3YjVxMTRpZm9aRFVKS29leHNoT2RJaU1DMEpXS2hG?=
 =?gb2312?B?VWI5M0RSOWRYOGNET2ZHU0w4Y000ZUtFV0I3NUIxYVpMb0hkWlBHR2NtWnNO?=
 =?gb2312?B?a29sVU1Hc0kvbU44YllIY1h6TGVvaHdqd2RRWnlFb1dOWWRqUDVwbnlxS1lw?=
 =?gb2312?B?Y2dwK1lSMzNYSFhlMCsvOUY2VWxWVWt5MU1COXZJK2IyZlZGTUgwUng0RkNY?=
 =?gb2312?B?SHVTM3hvVG0xa2pvSERhT0hjRGN2NmJ1dlhzRE1FamRkbWpCNmMxbnVCUHdp?=
 =?gb2312?B?bUt3elRwYmd0Q3ZmS3B0VmY5QlFJa2N1Q25MWUdDd2FZYWtNUWE5Um5oamNQ?=
 =?gb2312?B?MVR0SXg3WDNhdjhaL0pOd0hLdHIzZXJodTFqZElIVjNpOCszU1Uwb2xDV0p6?=
 =?gb2312?B?QnFLN05DMEo0LzljaUFLTGVuN29mdFhZWDdBN2tpZ3FJL0NPUHA5Z2IyZ3Rq?=
 =?gb2312?B?V2hHbTJ0djFtQnc0Ym5saUhBcXVPVHFOZ1BiYnZrNWVSN2pNOWp3K3hqSlR4?=
 =?gb2312?B?aktONHJLb293dkxNdlExU2NENHJnSzVNbW94Tk5PSThWU3pZUXJ4bHpoZmhQ?=
 =?gb2312?B?NnNMVXptampiMWVyaThwajFnRmNrTUMvMXlyajlMZ285ZW1mWWFyQXdab1o1?=
 =?gb2312?B?WWtyaWN4RWUvWm5GNzJuNXB6djBsZzQwd1N2SU13Z1Q1ck8vN3J3NndVOWE5?=
 =?gb2312?B?SkhmT2JrK2xTdXZGZ0pydWlhcE1CR3hRcEFYNk10ZytzLy9wbzZHQTZZbUJu?=
 =?gb2312?B?MUJ4WHZDZGhSOFFhR3poVkk2QWJVdStuM1FsMnk1VUYrek1oZkQ5a1cxUkta?=
 =?gb2312?Q?Ygqx+/iGIDDR1lVwFDaGO6E5+?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8106.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09d29d1e-fc47-4cc0-52da-08db114f483f
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Feb 2023 01:27:21.4629
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 15cPNwuSdG/caCaZXxccumiY5OVojaPQUbpHGamID4nWa+u18uuZ2sPkYj+l23QEOfWKsxB4EXHPoXYLhd8MRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB7109
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQW5kcmV3IEx1bm4gPGFu
ZHJld0BsdW5uLmNoPg0KPiBTZW50OiAyMDIzxOoy1MIxOMjVIDk6MDUNCj4gVG86IERhdmlkIExh
aWdodCA8RGF2aWQuTGFpZ2h0QGFjdWxhYi5jb20+DQo+IENjOiAnUmljaGFyZCBXZWluYmVyZ2Vy
JyA8cmljaGFyZEBub2QuYXQ+OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBXZWkgRmFuZw0KPiA8
d2VpLmZhbmdAbnhwLmNvbT47IFNoZW53ZWkgV2FuZyA8c2hlbndlaS53YW5nQG54cC5jb20+OyBD
bGFyayBXYW5nDQo+IDx4aWFvbmluZy53YW5nQG54cC5jb20+OyBkbC1saW51eC1pbXggPGxpbnV4
LWlteEBueHAuY29tPg0KPiBTdWJqZWN0OiBSZTogaGlnaCBsYXRlbmN5IHdpdGggaW14OG1tIGNv
bXBhcmVkIHRvIGlteDZxDQo+IA0KPiBPbiBGcmksIEZlYiAxNywgMjAyMyBhdCAwODo0OToyM1BN
ICswMDAwLCBEYXZpZCBMYWlnaHQgd3JvdGU6DQo+ID4gRnJvbTogUmljaGFyZCBXZWluYmVyZ2Vy
DQo+ID4gPiBTZW50OiAxNyBGZWJydWFyeSAyMDIzIDE2OjUzDQo+ID4gLi4uDQo+ID4gPiBJJ20g
aW52ZXN0aWdhdGluZyBpbnRvIGxhdGVuY3kgaXNzdWVzIG9uIGFuIGlteDhtbSBzeXN0ZW0gYWZ0
ZXINCj4gPiA+IG1pZ3JhdGluZyBmcm9tIGlteDZxLg0KPiA+ID4gQSByZWdyZXNzaW9uIHRlc3Qg
c2hvd2VkIG1hc3NpdmUgbGF0ZW5jeSBpbmNyZWFzZXMgd2hlbiBzaW5nbGUvc21hbGwNCj4gPiA+
IHBhY2tldHMgYXJlIGV4Y2hhbmdlZC4NCj4gPiA+DQo+ID4gPiBBIHNpbXBsZSB0ZXN0IHVzaW5n
IHBpbmcgZXhoaWJpdHMgdGhlIHByb2JsZW0uDQo+ID4gPiBQaW5naW5nIHRoZSB2ZXJ5IHNhbWUg
aG9zdCBmcm9tIHRoZSBpbXg4bW0gaGFzIGEgd2F5IGhpZ2hlciBSVFQgdGhhbg0KPiBmcm9tIHRo
ZSBpbXg2Lg0KPiA+ID4NCj4gPiA+IFBpbmcsIDEwMCBwYWNrZXRzIGVhY2gsIGZyb20gaW14NnE6
DQo+ID4gPiBydHQgbWluL2F2Zy9tYXgvbWRldiA9IDAuNjg5LzAuODUxLzEuMDI3LzAuMDg4IG1z
DQo+ID4gPg0KPiA+ID4gUGluZywgMTAwIHBhY2tldHMgZWFjaCwgZnJvbSBpbXg4bW06DQo+ID4g
PiBydHQgbWluL2F2Zy9tYXgvbWRldiA9IDEuMDczLzIuMDY0LzIuMTg5LzAuMzMwIG1zDQo+ID4g
Pg0KPiA+ID4gWW91IGNhbiBzZWUgdGhhdCB0aGUgYXZlcmFnZSBSVFQgaGFzIG1vcmUgdGhhbiBk
b3VibGVkLg0KPiA+IC4uLg0KPiA+DQo+ID4gSXMgaXQganVzdCBpbnRlcnJ1cHQgbGF0ZW5jeSBj
YXVzZWQgYnkgaW50ZXJydXB0IGNvYWxlc2NpbmcgdG8gYXZvaWQNCj4gPiBleGNlc3NpdmUgaW50
ZXJydXB0cz8NCj4gDQo+IEp1c3QgYWRkaW5nIHRvIHRoaXMsIGl0IGFwcGVhcnMgaW14NnEgZG9l
cyBub3QgaGF2ZSBzdXBwb3J0IGZvciBjaGFuZ2luZyB0aGUNCj4gaW50ZXJydXB0IGNvYWxlc2Np
bmcuIGlteDhtIGRvZXMgYXBwZWFyIHRvIHN1cHBvcnQgaXQuIFNvIHRyeSBwbGF5aW5nIHdpdGgN
Cj4gZXRodG9vbCAtYy8tQy4NCj4gDQpZZXMsIEkgYWdyZWUgd2l0aCBBbmRyZXcsIHRoZSBpbnRl
cnJ1cHQgY29hbGVzY2VuY2UgZmVhdHVyZSBkZWZhdWx0IHRvIGJlIGVuYWJsZWQNCm9uIGkuTVg4
TU0gcGxhdGZvcm1zLiBUaGUgcHVycG9zZSBvZiB0aGUgaW50ZXJydXB0IGNvYWxlc2NpbmcgaXMg
dG8gcmVkdWNlIHRoZQ0KbnVtYmVyIG9mIGludGVycnVwdHMgZ2VuZXJhdGVkIGJ5IHRoZSBNQUMg
c28gYXMgdG8gcmVkdWNlIHRoZSBDUFUgbG9hZGluZy4gDQpBcyBBbmRyZXcgc2FpZCwgeW91IGNh
biB0dXJuIGRvd24gcngtdXNlY3MgYW5kIHR4LXVzZWNzLCBhbmQgdGhlbiB0cnkgYWdhaW4uDQo=
