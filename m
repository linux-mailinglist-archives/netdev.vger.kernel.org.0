Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 139C84D88EB
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 17:17:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240811AbiCNQSV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 12:18:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234282AbiCNQSU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 12:18:20 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2069.outbound.protection.outlook.com [40.107.20.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 084164132D
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 09:17:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zub+dmsA8nJc2Oi5EJqI7UF0Y+vjYxL5Q1TMxXhNVxmwk5hUEM/pYitaXs/k+FuWl2jl6EargXgOhSVKx6XZ1n4BoLDW1RG/0hZ+xEcZS0IGesfibApC6dds/bUXY7L6vm3LTIBnnRP33Vr/quTn4ADdal2TQAn+qao7HCqTrSbeAIWB4ZJOuy2bEnQnJpLtiQ6Sy4f+VlLYhLiWK0/wto+jDwW6m04qVYr8DJHnUnBKxnnoEjuxlyVKLRldUo/Rcfy1RGuz1nV8IdwyLKioKH14G05Am2s9iEQjrgDIZ7qFNmhl4HNv+98idPAosvb+RzoL9NJDlVjUoubEGKigVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MsLeLH0GpkaygjSkdVzJs+MV3h0JBrh3MeOeSwSSr7M=;
 b=MUDu1CINfdJJctGiCTEWHJJ98R23ReSvkFqay/Am8Vr5BAKhmd7lB9U8ozvL4/RVXRfWOekuXQZUony/aUl95puiBOGOS6xJosusdkbbqmuMXfCvAjBCgPRCnVH9kqccwf4sv/McMw0/HqXU24Xb/R4Dav0d2OkhBgAwDMj3SAT+h9mntrKz15qeS4xLj19OoRlCjE+oJ/n89VaSJ++yZ55wKwsRi4THmLCC61COLvwtDqxIzlTFGTZQVBTSC6i0IT1bs+2n0gspreXawxOpSNLBUkZ//t1DaEWVgzB5BDX2A8Ch9qgqYacjxJCcTy3FZRCP5IEhE2lPIWHUG0g8qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MsLeLH0GpkaygjSkdVzJs+MV3h0JBrh3MeOeSwSSr7M=;
 b=Vzb6jbLWyzD2z+pgWPb1aNVqX8c4VtvPf9hhPNPxIBySdwYKN7LkFXZX/cYvJkfjwcNnZMkezsbD5nXNbp+J2HqWhtA/YO1mBk3viCB7w2XvwNuQFCLps/f05PRKrFnmquOQ9j9PW2QJUU4cv+4EFmsfjpiibmjo/eNOI6ytnAs=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM6PR04MB4262.eurprd04.prod.outlook.com (2603:10a6:209:4a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.28; Mon, 14 Mar
 2022 16:17:07 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36%5]) with mapi id 15.20.5061.026; Mon, 14 Mar 2022
 16:17:06 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     =?utf-8?B?TWFyZWsgQmVow7pu?= <kabel@kernel.org>
CC:     Tobias Waldekranz <tobias@waldekranz.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        =?utf-8?B?SmFuIELEm3TDrWs=?= <hagrid@svine.us>
Subject: Re: [PATCH net] net: dsa: fix panic when port leaves a bridge
Thread-Topic: [PATCH net] net: dsa: fix panic when port leaves a bridge
Thread-Index: AQHYN7j4R52Ve+kGyEmg11EfqSyjH6y/BomAgAAEq4CAAAM/AA==
Date:   Mon, 14 Mar 2022 16:17:06 +0000
Message-ID: <20220314161706.mo3ph3aadzdqwdag@skbuf>
References: <20220314153410.31744-1-kabel@kernel.org>
 <87tuc0lelc.fsf@waldekranz.com> <20220314170529.2b71978d@dellmb>
In-Reply-To: <20220314170529.2b71978d@dellmb>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ceeeb04c-3cce-44f2-b19f-08da05d61582
x-ms-traffictypediagnostic: AM6PR04MB4262:EE_
x-microsoft-antispam-prvs: <AM6PR04MB42625CC43AF222CEC945EAF2E00F9@AM6PR04MB4262.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: g9B8qrr7/Ermy6kk2qLCVs/tjoflQ61uAHf/goPBBbb+9Zy8G9EsGAvkQElVsXalH4c6yJz4CnEgPjf3mvNE2xzey6/bcwh+rZJ0AxMRhpKbf9gvERopTU1eA0ruyqBgdSfTDTqHgkx68/zS44Un+ePO0DpMhRCMpZyFtuxX4CEpNOg1t5XTbDT9QX2EFudCgOP/ca67KOln4JLLgqu/gd0kVbWTAVjmHRcfq8Zc+Fiv4UIXypQlCpfuoIJMB+t9d2QdnlwGxKktevSkKsHD358p/VdW5ak68m6ugTU5PWFl6z/aYhVlzmOXhXZDdPOwr1fa3YNU3DogSDLRc3oHXN2pMZvmSXbFEATvxv6nxssYOdOjGC7v9STFZdr/GU/IgAjIcr1vc0xRSUMlv+CFw2aR2Mrh67qxf78NaHsrOLxoEcmDTqlnQX7uVI27PCDjph4KmkKLNp5QGuka/g2o6zS7cFOQTpqMvXsMR9HysGOWRatw3KG/1oVHTNuDeTVloAB+KCGNjb7ps6cYXub2awETPstch/1JHAgxz2b/FOlTPvAy2borTMdYMROw4gkeCRra/jJapiX4zR5uZOjvv+1k8rSIMLDPJC5fG+vH8dHsFtwJ+N+AZk6WMicO5TsoDPY1ANWu7p1Y27PFRoCohKJv6SH0RdLnlSbzkW3aSznt6rNPKzuPdWe3Nqn2fpfNdFFIqITPXy18ddEZnLogiA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(53546011)(9686003)(6512007)(6506007)(86362001)(38070700005)(76116006)(54906003)(1076003)(71200400001)(33716001)(6916009)(186003)(26005)(5660300002)(8936002)(122000001)(44832011)(4326008)(8676002)(66476007)(66446008)(66556008)(64756008)(498600001)(66946007)(38100700002)(2906002)(6486002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cEFzenhyS05yUDJjbjFTY3VHR296bkZnY1EyZ1JqeWQwT2dUR2l0U01FZjls?=
 =?utf-8?B?UUthalBBL3hxaHBybTNmZStkNnQwQTYzNjJoUmp6cys5NENZc1hSRFFyK2Fx?=
 =?utf-8?B?QVU4OFh2YU9oS1Fva29XeDZsT1RoOElaeDcxVDRYczR4Y1hzZUtaaGl2MWtM?=
 =?utf-8?B?SU8xbVNyaERiZnVzYVVOQUZ5VFQxSjlodkhOZktrR0tITS9Sa00vdkt3TkpI?=
 =?utf-8?B?dXNzeUk4WDBZOGQwbjlXaHc5MTJoYzVHN2t1MG83N0cyWSt5L2Y4SU8zb29x?=
 =?utf-8?B?U1FOd0xoM1dHNmdGdSsvUmNZNjM5bFVGMzN3enVTUUVOOFB5YjF3RGJlQlM1?=
 =?utf-8?B?ZTZ4V1FCbHVwaWdvRlNvdnRnUW5lRjZjQkREOVZ1RG1sc1VSUXZNenBIN0lV?=
 =?utf-8?B?dEtFc0dWeXJrM214L2MvWWtBN3d6RWJBbytSa3hsUHZZWG9DVlR4UUx6Ym9a?=
 =?utf-8?B?dWlYeUdsa3lXelRJVi9HOGVyWmZ5L3ljOHAyUUc2YTVSQUNiMVRJLzdCeHN0?=
 =?utf-8?B?T1pBMmtTTGMyeEZLaE9jSVFnWmlISmR2MzV0ZFZXNmNydURtZEs5T0ZiMzJF?=
 =?utf-8?B?eU00RzY0ZEFFL1pJc3pPUWlVNXZrNnE3U21weVEzQ2d6NTUzb0Z4U3pyVFRS?=
 =?utf-8?B?MFZBMkUxOTFSNk1uTzBFVkVWTTBNK2w3dVZxMkhlUjhyWURSZk9yQVB6OVNy?=
 =?utf-8?B?MzhvQklCNVl5K2pWdWZ5RVltc215R2JVczd3ZC9INmltNlgwR2R5UHpQSFND?=
 =?utf-8?B?d0thNGEzQ2xaYlJ6TmtRQ0RvN0JlQnV6c2RmbGJLQUtUaWNPTk5palJlZW82?=
 =?utf-8?B?ZmNOdjJHNWpIbXZaR28wdzhwdU5DQ1krWDlFU0RCQnNOcW1aYit6TXBGdDBp?=
 =?utf-8?B?M2N3VmJjQU9sS3Azc3ZZUUxyblJNNTU0cnVXaXpUMS9qL3Q4L21lOERzMXZF?=
 =?utf-8?B?ZzBYaStyYlVjU1Y0MUw3ci9mejB3NkMzVGRYTUhvUHJiSHI0Tkdlb3lyd2tU?=
 =?utf-8?B?UUYySHlGT08rZUJpaHhNQnYxTjZFSWhvQytpNHpXemlUUGgrQjcwcWlNdXdi?=
 =?utf-8?B?YmN2L3g2aVB4Z216MWxWWFY3Rzh0NVY3Y2ozNEJ4bFJHSU9LcFhCbkR0UEwy?=
 =?utf-8?B?Zm5TZUNvRVorZ2tYdW42dWQ3S3VLaGVXOVNWZkI2aFJUdi92WkYyUjBCOHNl?=
 =?utf-8?B?a2FHRVMyNGFyeGhWdmhORlBSdk8wZmwvaHV1QmdVbDlmQjRxMWlvdTQrcUg3?=
 =?utf-8?B?bHRTaWtyYTY4TTZObkFvdVM1a2lEZERLWjBOVmJMSEl6RDA5RWJnTCt1WDM5?=
 =?utf-8?B?YW9QTStHU2gzaDh1cTRqU0pta2doaGZldWtYVXRoRkMrUmpvc1R0S1JVbVBQ?=
 =?utf-8?B?UDdta0pTc2ttd3pXbmwzdDVxVERpL1N1NjhHdDA4MDBQb09LNjUxRkpza1VU?=
 =?utf-8?B?SWJCbTRyVWNldnRYMjZ2ZDZQODNLRnQ1MFJFR0RaZEhuc0kyRXUya3hXS0RO?=
 =?utf-8?B?QzJSZnVGUGFyYTRQR0xxcTcxWU5aaDFHTlUvM2tvc1JZcmRUT3ZRODRlN1I3?=
 =?utf-8?B?OWo2M2xoSHV1THdxOW5xTGQ4QlZsOWROUWpxdVpHOEFJVHFpS0sxTUdFajN0?=
 =?utf-8?B?d1lTZ1U3MVZiSG1DV3NsMTh4Q2hEYVVtcUVrTGV6blc4aEJ4cjJ3eWFyejFs?=
 =?utf-8?B?MS93S3pHTDJ1RDM5SUR6bUh0ZFY4S2Q2SGpnRUJsL2t6UlFUNlNxclQ2Q3BP?=
 =?utf-8?B?TG95dkRNNUZ1NXgwTzRQWEw1L211U3FjYWxHeFBFdlcrQWNUTDlpK1Nqc1M2?=
 =?utf-8?B?cTMrTFEyYWplaWhrRmNSSlkwZEpUd0drcVpsa2swY2hwcXQ4bWtDaUdWb2ZO?=
 =?utf-8?B?a1BHbzZNSDRrUS9EbzVzZUhDcGdJNFVMNmRvSEJTbXI0Y25rd2FCeXJZVnFW?=
 =?utf-8?B?THhPRzUrLzFnYmg4aGwrQk9UUkpTQy9JRkNWTUltRnNLb0tKeHo2UXRLZFpj?=
 =?utf-8?B?cS9pTHBTR1J3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E79739179D9F364A8F2893A2DC8D8555@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ceeeb04c-3cce-44f2-b19f-08da05d61582
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Mar 2022 16:17:06.7435
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CrZShEZS9PNZd0ahTyMtJuitH12IET7GI6KklkJ5OT1REBEbKK+UILviO2txuotbLm1nd82M+aZgqIAsFHh2HQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4262
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCBNYXIgMTQsIDIwMjIgYXQgMDU6MDU6MjlQTSArMDEwMCwgTWFyZWsgQmVow7puIHdy
b3RlOg0KPiBPbiBNb24sIDE0IE1hciAyMDIyIDE2OjQ4OjQ3ICswMTAwDQo+IFRvYmlhcyBXYWxk
ZWtyYW56IDx0b2JpYXNAd2FsZGVrcmFuei5jb20+IHdyb3RlOg0KPiANCj4gPiBPbiBNb24sIE1h
ciAxNCwgMjAyMiBhdCAxNjozNCwgTWFyZWsgQmVow7puIDxrYWJlbEBrZXJuZWwub3JnPiB3cm90
ZToNCj4gPiA+IEZpeCBhIGRhdGEgc3RydWN0dXJlIGJyZWFraW5nIC8gTlVMTC1wb2ludGVyIGRl
cmVmZXJlbmNlIGluDQo+ID4gPiBkc2Ffc3dpdGNoX2JyaWRnZV9sZWF2ZSgpLg0KPiA+ID4NCj4g
PiA+IFdoZW4gYSBEU0EgcG9ydCBsZWF2ZXMgYSBicmlkZ2UsIGRzYV9zd2l0Y2hfYnJpZGdlX2xl
YXZlKCkgaXMgY2FsbGVkIGJ5DQo+ID4gPiBub3RpZmllciBmb3IgZXZlcnkgRFNBIHN3aXRjaCB0
aGF0IGNvbnRhaW5zIHBvcnRzIHRoYXQgYXJlIGluIHRoZQ0KPiA+ID4gYnJpZGdlLg0KPiA+ID4N
Cj4gPiA+IEJ1dCB0aGUgcGFydCBvZiB0aGUgY29kZSB0aGF0IHVuc2V0cyB2bGFuX2ZpbHRlcmlu
ZyBleHBlY3RzIHRoYXQgdGhlIGRzDQo+ID4gPiBhcmd1bWVudCByZWZlcnMgdG8gdGhlIHNhbWUg
c3dpdGNoIHRoYXQgY29udGFpbnMgdGhlIGxlYXZpbmcgcG9ydC4NCj4gPiA+DQo+ID4gPiBUaGlz
IGxlYWRzIHRvIHZhcmlvdXMgcHJvYmxlbXMsIGluY2x1ZGluZyBhIE5VTEwgcG9pbnRlciBkZXJl
ZmVyZW5jZSwNCj4gPiA+IHdoaWNoIHdhcyBvYnNlcnZlZCBvbiBUdXJyaXMgTU9YIHdpdGggMiBz
d2l0Y2hlcyAob25lIHdpdGggOCB1c2VyIHBvcnRzDQo+ID4gPiBhbmQgYW5vdGhlciB3aXRoIDQg
dXNlciBwb3J0cykuDQo+ID4gPg0KPiA+ID4gVGh1cyB3ZSBuZWVkIHRvIG1vdmUgdGhlIHZsYW5f
ZmlsdGVyaW5nIGNoYW5nZSBjb2RlIHRvIHRoZSBub24tY3Jvc3NjaGlwDQo+ID4gPiBicmFuY2gu
DQo+ID4gPg0KPiA+ID4gRml4ZXM6IGQzNzFiN2M5MmQxOTAgKCJuZXQ6IGRzYTogVW5zZXQgdmxh
bl9maWx0ZXJpbmcgd2hlbiBwb3J0cyBsZWF2ZSB0aGUgYnJpZGdlIikNCj4gPiA+IFJlcG9ydGVk
LWJ5OiBKYW4gQsSbdMOtayA8aGFncmlkQHN2aW5lLnVzPg0KPiA+ID4gU2lnbmVkLW9mZi1ieTog
TWFyZWsgQmVow7puIDxrYWJlbEBrZXJuZWwub3JnPg0KPiA+ID4gLS0tICANCj4gPiANCj4gPiBI
aSBNYXJlaywNCj4gPiANCj4gPiBJIHJhbiBpbnRvIHRoZSBzYW1lIGlzc3VlIGEgd2hpbGUgYmFj
ayBhbmQgZml4ZWQgaXQgKG9yIGF0IGxlYXN0IHRob3VnaHQNCj4gPiBJIGRpZCkgaW4gMTA4ZGM4
NzQxYzIwLiBIYXMgdGhhdCBiZWVuIGFwcGxpZWQgdG8geW91ciB0cmVlPyBNYXliZSBJDQo+ID4g
bWlzc2VkIHNvbWUgdGFnIHRoYXQgY2F1c2VkIGl0IHRvIG5vdCBiZSBiYWNrLXBvcnRlZD8NCj4g
DQo+IEl0IHdhc24ndCBhcHBsaWVkIGJlY2F1c2UgSSB3YXMgd29ya2luZyB3aXRoIG5ldCwgbm90
IG5ldC1uZXh0Lg0KPiANCj4gVmVyeSB3ZWxsLiBXZSB3aWxsIG5lZWQgdG8gZ2V0IHRoaXMgYmFj
a3BvcnRlZCB0byBzdGFibGUsIHRob3VnaC4NCj4gDQo+IE1hcmVrDQoNCldobyBjYW4gc2VuZCBU
b2JpYXMncyAyIHBhdGNoZXMgdG8gbGludXgtc3RhYmxlIGJyYW5jaGVzIGZvciA1LjQgYW5kIGhp
Z2hlcj8=
