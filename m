Return-Path: <netdev+bounces-1012-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 114346FBD2A
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 04:29:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 184411C20A98
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 02:29:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C57A9395;
	Tue,  9 May 2023 02:29:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B18F77C
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 02:29:32 +0000 (UTC)
Received: from mo-csw.securemx.jp (mo-csw1515.securemx.jp [210.130.202.154])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 077819EF9
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 19:29:29 -0700 (PDT)
Received: by mo-csw.securemx.jp (mx-mo-csw1515) id 3492SScD004435; Tue, 9 May 2023 11:28:28 +0900
X-Iguazu-Qid: 34trpHMSmOLGSJo0I6
X-Iguazu-QSIG: v=2; s=0; t=1683599308; q=34trpHMSmOLGSJo0I6; m=LC+Yrf9jpYB02kGeIs+oPdW0Q6fe6qNOdjU1qXnRyJ4=
Received: from imx2-a.toshiba.co.jp (imx2-a.toshiba.co.jp [106.186.93.35])
	by relay.securemx.jp (mx-mr1511) id 3492SPEY014645
	(version=TLSv1.2 cipher=AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 9 May 2023 11:28:26 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=borTgn4KgKdRYB1Yn02bgLS0Smo4/3wzGHpkxfEu1h0EBOa77VqYCI7DHEXZY9TMrsv7Tb6dsro0+fqz3l5oBkOiQXOYrTtrr4wxc4S3Bv0iaB+qqMyiKV/qUzQePql6Cd/zaBaHCPNI5vtb5HcikSs7oUIQeubi9E5g4QMUUr3xcITFQL5v9nBCq32MRnwRWMmHySGLQm7Aw2S5eQAewxgWjfsklu7Y9KbiEJtDFEzbvbacqX9d/BGih+9IK1sBqsXSZO2/IeiUbs23X7nniVY3pOX3G9qmmEOPgdp4fDQkiTcOF9PlikU2vu9PUkLXVAR/IvWVOGcRCuSRya9syg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C15R2As9J7RcdX2+2UbdplZLOFN8lddcY2w2oR1XpWg=;
 b=bek1iKxIu/WOZPYNKKdMFYpmMRdp9Ir/ZMEwTO/AicEJxZhgnGjCbHv81A2KgLLdz/0c8/fKtLcLCL5T3Bzri3QCKEeksJneS1IJMEoyC4X+oKT5aUANHobIQsXgoMlCvZz9tIoc7Z4DCiDXcxemLOk8vRd4segNstMi08eYpRc9JGlbR+i4+ujiGhVvqPVNVLlhHZQpcWIOSNjD/giIqxKWHwBrR69UaxYDe3L9pMokCLiznvo7Z1h3nC9IK5xpqiKMb0oBcFzQWJ+V48ZpbcQqCJx4z2/a35V9jGPCISUGmkcTUe+F/Pd6/mkNNzfBKLxWkwW85zZZUBq1wbUn/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=toshiba.co.jp; dmarc=pass action=none
 header.from=toshiba.co.jp; dkim=pass header.d=toshiba.co.jp; arc=none
From: <nobuhiro1.iwamatsu@toshiba.co.jp>
To: <u.kleine-koenig@pengutronix.de>, <peppe.cavallaro@st.com>,
        <alexandre.torgue@foss.st.com>, <joabreu@synopsys.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <mcoquelin.stm32@gmail.com>
CC: <netdev@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-stm32@st-md-mailman.stormreply.com>, <kernel@pengutronix.de>,
        <simon.horman@corigine.com>
Subject: RE: [PATCH net-next v2 04/11] net: stmmac: dwmac-visconti: Convert to
 platform remove callback returning void
Thread-Topic: [PATCH net-next v2 04/11] net: stmmac: dwmac-visconti: Convert
 to platform remove callback returning void
Thread-Index: AQHZgbk2whUeE449vEaeZpzTkJrOqK9ROBZQ
Date: Tue, 9 May 2023 02:28:11 +0000
X-TSB-HOP2: ON
Message-ID: <TYWPR01MB94204DF359A14DDEB5C7748092769@TYWPR01MB9420.jpnprd01.prod.outlook.com>
References: <20230508142637.1449363-1-u.kleine-koenig@pengutronix.de>
 <20230508142637.1449363-5-u.kleine-koenig@pengutronix.de>
In-Reply-To: <20230508142637.1449363-5-u.kleine-koenig@pengutronix.de>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=toshiba.co.jp;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYWPR01MB9420:EE_|TYCPR01MB9432:EE_
x-ms-office365-filtering-correlation-id: 19f4d681-7f3d-498b-ae92-08db503508f6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5fEp1TI6qPn8vhZVorwrMaV4KqTRf+IKZgfAXkrzPL3GE/XakWYJLNuk8/GPbjtKO0Df9RzwTDRtNMH1/m4krVGEzl53oFblIG4fPXl9bTgphZyrgNPtFCIO6zD2YOtsHLrTO6igxyx6XRumWuV3MCYWows3uPouVEa6uIOcadQ/EEkqOKvjE72gc8I6BtiTrAld2pTB6qXnwO7g2dXtkOYUtVvISw+NTvqtBgCveftD7HcxtfhvQL4cTVRT240tIWW026DOBu1uJ35FKeBg2c9Gxh1yZZFAndKnidACV2SVL/vhqg/ndxnNUok6h3I0/p+pEc7H+XRRrK5qOim9QGx8kPPKDy/i3Be7XsDL/y64DLbS0SolicxLIhMgXEQeg4R7yOKpe7TO5tm1MsrHzDM5ft8g+PxT42ucHVvOEQf60f0OEsTdOJECNJ05kBbfk44+XdO4Ie0nyeTu+bUw/1eFxqerERY/IoMQSnyfFFsEyEto8AEdO3FTo784C2W1DBKmdx04huqYChmYx1a8mEKp10HuFCjFnaf4NBlKCJGIYBA6JL4NoVSD204TpZXAdArgW2GQk2hE7t7mtwFjwQhY1wOu76D6kfYcpKXorlYxEeK7UADGbwkVmE+8ujNB
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYWPR01MB9420.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(346002)(39860400002)(376002)(136003)(451199021)(9686003)(186003)(2906002)(26005)(6506007)(53546011)(33656002)(38100700002)(55016003)(83380400001)(122000001)(71200400001)(316002)(41300700001)(4326008)(66556008)(64756008)(76116006)(66476007)(66946007)(7696005)(66446008)(54906003)(86362001)(110136005)(38070700005)(478600001)(7416002)(8676002)(5660300002)(8936002)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bTE5UFR0T2R5eDlaVC95dm1ZcDUreUttSmY4eHZFbjVxRTgyT05XZXlwbCtw?=
 =?utf-8?B?dmU1dDB4ckxWNEF0L0o1a3dObnFDbmwzT21yOCtKdjk2cGh3d2o3RVpsS0pr?=
 =?utf-8?B?dTJJaXM1d0xUblg3U2Y0WHQ5d3doWDhGQ1dxcFV4bEY4VlgrWjBJSWF0S3U3?=
 =?utf-8?B?bjJ4eG1hQmJQeEpoQlhSazR0dVE1ZXp6ZVc5azhONGtPU0xWOEdlZHQ0TTlz?=
 =?utf-8?B?MnNOS0xCVnBPYjV4dklYcVFDKzRveUdUeGd5QStiS1VMTWpEektVczgrNWtl?=
 =?utf-8?B?cENPQlpzUHZpUVBBR0NyNWk1UVBJek1UTW9PTG5aQk1Oc2hqQk9rQjlQUHFJ?=
 =?utf-8?B?VDcwaE9tR20yT2dTQ0RpbHF2ZnVmQ0hiazF4TlBQOUVFQ0NMV1FzYXZENG1X?=
 =?utf-8?B?dWRGempSWEQ1SWFtT0FFVUhFaGxvYjFzTGYyNThtQXdPbXROVkZyQUM3STA3?=
 =?utf-8?B?L05IdXBCQkNVeEFmVTgyOS9Ha3dwSlQ3STNZYjRCbWJtbUtWSTE4ekNTMy94?=
 =?utf-8?B?OWJCYmtzM0ZNS1hMMW9GYytnbW1XY0NVNkFmWU1SVk9EZkZNcm9XdHNqR0RV?=
 =?utf-8?B?KzZwNkdRR2FVMU9WUm02bmx0Ym0xSG5kZnRUZzFYTWg0dE9NaGFNOXlnR0xE?=
 =?utf-8?B?c2NtTlkxS3lpRUs5MWVyMml0U0RJV0I4bk9FZ01XVFY5ZTlpZnRiNmpzdktj?=
 =?utf-8?B?NW5OWXNMWlN1a2RKb1l6UVkvakZmM0k0eGc3Wk1MVWtUa3FidHRDNGw2Tk5y?=
 =?utf-8?B?MXpmaERORGZHcUNaUUdSb0FhbXREMXZyL0dwYlhiZFQ5bXdkZHphbU9jeGRK?=
 =?utf-8?B?VnZiUklmdlJMaEdpVUorbmxOc01iSW9YbGFRTDdYZlIyUEtOSEYxQzcwU1Ev?=
 =?utf-8?B?WlE3M0JVMU1aRE1taFFRbDRJODJNck5jYXFFOXdOUXJTSzRRNW5aUGJRVmgx?=
 =?utf-8?B?cjBaR2hScFdXZThyL3praUpFZmVXRk5Fa2dRWkdzblU1KzJMckdacCsxSjZr?=
 =?utf-8?B?elYwWlVZSWVtcXN4ZjVEVElrQkF1VzQwRFZFTmx6V0hiczRzb1M1MkE1ZTNp?=
 =?utf-8?B?N0poVnE2OVRJNkE5VlBQbTFiQTg2amVhc2UrQktuNWJXeTAvQmJtWnNQSkNE?=
 =?utf-8?B?ZjNvZUpXS2h1RDFyNWFRWks5WnVvSmtsajREY3ZOWTNncVFHd04wWmRsTjFt?=
 =?utf-8?B?d0JpQUtDMTF6cUgrMjR1OGFHUm1FTFVaanhRcCtoL2pSUS9rWUpYRnQ5dHhG?=
 =?utf-8?B?OGE1emdmL0tET3QraWxmZXNETTZNQmRxK1VJbzdsUU5NZ3ZHR3F5aFJYR1Ir?=
 =?utf-8?B?OWhUZjF4bkFMMmVaQ1pWeDE2eWJEMmlhVU1IWFJ5TXBwbEsvbW8vL1lTVkpu?=
 =?utf-8?B?ckZrTk5xaHdGd3BiUkI3Q3o0ZUNKMGFXays3Q3pBOE82VG1sNXM5cktVNG5F?=
 =?utf-8?B?ZzdvSU1XeFpvYUtPTHpJMG1xMVZwYkZEbTNWMXVLUnY4UFFVSkhybWJUWTBG?=
 =?utf-8?B?Tm1PQ2MzTHlhVFd6OFdGWnN6d2x5Nkx3czRkc3N6aHgyUU9pSHc2RnlnSWtO?=
 =?utf-8?B?Z0lFdDNWZVhPbXp1NGFvTVJmTy9IaU8xZGNYWnJoYjdsOWZLZnRnVHdDbkd2?=
 =?utf-8?B?U2FkVVdIRkxZSVpjNHJMeGtMbHFyMEdCUVBlM1QrM0ZrRFJwZ1dzRFZMUjJ3?=
 =?utf-8?B?UXNhTFVPOFE1SURpdllJZzYyVTkyVHNVb2xqWnF6MlN5eWwwUU04T25OeGQ3?=
 =?utf-8?B?a2pvRmFEdVdtUzJmN1M3ckd4NFk4WVgrbkdvZjVXT0JxdjJ4alJsb09ydHZK?=
 =?utf-8?B?N292OXBBTTd1WGVTcHVpSmxoL2kxM3I3ZzkvdFVFOWhsdmcrTjZ1a3RsM29z?=
 =?utf-8?B?emF0Mm1DVS9QaDBFZFlxdlJFSnEyaDhtNFJUMmUvKzlNZ1ZqUzlmZEk4Um8y?=
 =?utf-8?B?OGhITk5mOThiQUVzOFM2T0xNZmRWTkFXd24rZWMzM3FOdHhmZHdsc2lmNFE4?=
 =?utf-8?B?Unhsb1RuN0trWmhtVWdBZzRIT01UYzJkZTA0bE1aYkw0TkxlVnFjZ2ZOT0tu?=
 =?utf-8?B?bmpOYnZsL3ZsMjkyRS9sUG1icWRXTU04OXV5ZkJPZFlxZHIrVERmaWdKbTlj?=
 =?utf-8?B?THZiSUlNTTlmS2tabldiT0F4ZWIrZWRVWVdXRVBScnlhN3VydkJ1K0trcXdU?=
 =?utf-8?B?OWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYWPR01MB9420.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19f4d681-7f3d-498b-ae92-08db503508f6
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 May 2023 02:28:11.6349
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f109924e-fb71-4ba0-b2cc-65dcdf6fbe4f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rCW/giPrfcJgjQIc+ZstzSlqdzxJJHtFmkYFsoYtNIGJ1zNLw843Y1EsAztlGNQpKDo2IHUj1CnNZjL2/m615qvC5zemxt6h9DTlG/cDbKbMOTGsmqaHeWH53FxfrUyh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCPR01MB9432
X-OriginatorOrg: toshiba.co.jp
MSSCP.TransferMailToMossAgent: 103
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

SGkgVXdlLA0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFV3ZSBLbGVp
bmUtS8O2bmlnIDx1LmtsZWluZS1rb2VuaWdAcGVuZ3V0cm9uaXguZGU+DQo+IFNlbnQ6IE1vbmRh
eSwgTWF5IDgsIDIwMjMgMTE6MjcgUE0NCj4gVG86IEdpdXNlcHBlIENhdmFsbGFybyA8cGVwcGUu
Y2F2YWxsYXJvQHN0LmNvbT47IEFsZXhhbmRyZSBUb3JndWUNCj4gPGFsZXhhbmRyZS50b3JndWVA
Zm9zcy5zdC5jb20+OyBKb3NlIEFicmV1IDxqb2FicmV1QHN5bm9wc3lzLmNvbT47DQo+IERhdmlk
IFMuIE1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47IEVyaWMgRHVtYXpldA0KPiA8ZWR1bWF6
ZXRAZ29vZ2xlLmNvbT47IEpha3ViIEtpY2luc2tpIDxrdWJhQGtlcm5lbC5vcmc+OyBQYW9sbyBB
YmVuaQ0KPiA8cGFiZW5pQHJlZGhhdC5jb20+OyBpd2FtYXRzdSBub2J1aGlybyjlsqnmnb4g5L+h
5rSLIOKXi++8pO+8qe+8tO+8o+KWoe+8pO+8qe+8tOKXiw0KPiDvvK/vvLPvvLQpIDxub2J1aGly
bzEuaXdhbWF0c3VAdG9zaGliYS5jby5qcD47IE1heGltZSBDb3F1ZWxpbg0KPiA8bWNvcXVlbGlu
LnN0bTMyQGdtYWlsLmNvbT4NCj4gQ2M6IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWFy
bS1rZXJuZWxAbGlzdHMuaW5mcmFkZWFkLm9yZzsNCj4gbGludXgtc3RtMzJAc3QtbWQtbWFpbG1h
bi5zdG9ybXJlcGx5LmNvbTsga2VybmVsQHBlbmd1dHJvbml4LmRlOyBTaW1vbg0KPiBIb3JtYW4g
PHNpbW9uLmhvcm1hbkBjb3JpZ2luZS5jb20+DQo+IFN1YmplY3Q6IFtQQVRDSCBuZXQtbmV4dCB2
MiAwNC8xMV0gbmV0OiBzdG1tYWM6IGR3bWFjLXZpc2NvbnRpOiBDb252ZXJ0IHRvDQo+IHBsYXRm
b3JtIHJlbW92ZSBjYWxsYmFjayByZXR1cm5pbmcgdm9pZA0KPiANCj4gVGhlIC5yZW1vdmUoKSBj
YWxsYmFjayBmb3IgYSBwbGF0Zm9ybSBkcml2ZXIgcmV0dXJucyBhbiBpbnQgd2hpY2ggbWFrZXMg
bWFueQ0KPiBkcml2ZXIgYXV0aG9ycyB3cm9uZ2x5IGFzc3VtZSBpdCdzIHBvc3NpYmxlIHRvIGRv
IGVycm9yIGhhbmRsaW5nIGJ5IHJldHVybmluZyBhbg0KPiBlcnJvciBjb2RlLiBIb3dldmVyIHRo
ZSB2YWx1ZSByZXR1cm5lZCBpcyAobW9zdGx5KSBpZ25vcmVkIGFuZCB0aGlzIHR5cGljYWxseQ0K
PiByZXN1bHRzIGluIHJlc291cmNlIGxlYWtzLiBUbyBpbXByb3ZlIGhlcmUgdGhlcmUgaXMgYSBx
dWVzdCB0byBtYWtlIHRoZSByZW1vdmUNCj4gY2FsbGJhY2sgcmV0dXJuIHZvaWQuIEluIHRoZSBm
aXJzdCBzdGVwIG9mIHRoaXMgcXVlc3QgYWxsIGRyaXZlcnMgYXJlIGNvbnZlcnRlZA0KPiB0byAu
cmVtb3ZlX25ldygpIHdoaWNoIGFscmVhZHkgcmV0dXJucyB2b2lkLg0KPiANCj4gVHJpdmlhbGx5
IGNvbnZlcnQgdGhpcyBkcml2ZXIgZnJvbSBhbHdheXMgcmV0dXJuaW5nIHplcm8gaW4gdGhlIHJl
bW92ZSBjYWxsYmFjayB0bw0KPiB0aGUgdm9pZCByZXR1cm5pbmcgdmFyaWFudC4NCj4gDQo+IFJl
dmlld2VkLWJ5OiBTaW1vbiBIb3JtYW4gPHNpbW9uLmhvcm1hbkBjb3JpZ2luZS5jb20+DQo+IFNp
Z25lZC1vZmYtYnk6IFV3ZSBLbGVpbmUtS8O2bmlnIDx1LmtsZWluZS1rb2VuaWdAcGVuZ3V0cm9u
aXguZGU+DQo+IC0tLQ0KDQpBY2tlZC1ieTogTm9idWhpcm8gSXdhbWF0c3UgPG5vYnVoaXJvMS5p
d2FtYXRzdUB0b3NoaWJhLmNvLmpwPg0KDQpCZXN0IHJlZ2FyZHMsDQogIE5vYnVoaXJvDQo=


