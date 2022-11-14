Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48987628442
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 16:42:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237141AbiKNPmy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 10:42:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235551AbiKNPmx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 10:42:53 -0500
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20085.outbound.protection.outlook.com [40.107.2.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 228CC220C9
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 07:42:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JrGtfOjOSOEzUFVIPGDiIWZsxojXOAnU1OQ+xsGmkkaObcgeBBLhitpkbgp3ZWs0lcODbcElcheqOtrdc2woPB1Li54L2EOE0O6/Y2D1B0dg6Ip3pVGYfraPzpZNIvAq3gm60GRCqbNa136Fmkhf1X80QWbtWr9ANHjdG7nnHNlIT1TJ3ZFqb0R9MoxfEI/Ppscbg7C3NwOEUahd5IOW1UVP2xb/CvXIdkCner6OKhl31F0mpYV8rOKdI/s83pzeMsP021Hzberv13gjJf4hFeziMaKYnjxSgi3b9z4rqD9fhc//zhxHBkzMwg0cYYLcsb0ELqmLpWYhXeG+gDJvjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z9/U7uZ964e4OJag36YLM00IBFpKFwGGgZ6ctyUwrII=;
 b=YogfG2ZDxq3p0QihpqPo4Xbx5WF8jdOhTYhxkQDxHtiLLA8r5zfYZhxvoicvVLpv6PF2fdk7NsmVEY6u5Xu2phEjgf+mup+5NWKHFfPNvV7Umqli4GgBIWDG/pSR+FOowHi0FfSJADZk5iGCyyqrih1TA4KzcbvdLhXfGRYU4ypqAQUHiwZxxWUIJTg5Hsycu1uPvlQqreDGBBGqMR6Efx6civ/rzUUiv2TGqlPEYMsBMgVOwuKlYzcyUS/ofchp9/umOIcGmt+3Jm9E6GpprQU7i5dOkhevhlJ2TG8nd4UoF5LvITOa+BCVid+8VlhunIYJhTEUiyTkX6ghJUz/hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z9/U7uZ964e4OJag36YLM00IBFpKFwGGgZ6ctyUwrII=;
 b=rZFnh90ApIbdzLZTcg6i30JozzJgprHJcjJnjvLZMxTxGABVDUm7u03PnoCFOXx+RUqVyZVhOaM2q/JQypJiZcJj13yitYO6LTaWtR6P0i1w4M5f8iPdD/zfLZDxv1AeZFt0holIa6HF7UClmkyS7PZ/aRpJZ2ca4136/91PCdA=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM9PR04MB8414.eurprd04.prod.outlook.com (2603:10a6:20b:3ef::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Mon, 14 Nov
 2022 15:42:49 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5813.017; Mon, 14 Nov 2022
 15:42:49 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
CC:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Rui Sousa <rui.sousa@nxp.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Richie Pearn <richard.pearn@nxp.com>
Subject: =?big5?B?UmU6IKZezmA6IFtSRkMgUEFUQ0ggbmV0LW5leHQgMi83XSBuZXQ6IGV0aHRvb2w6?=
 =?big5?B?IGFkZCBzdXBwb3J0IGZvciBGcmFtZSBQcmVlbXB0aW9uIGFuZCBNQUMgTWVyZ2Ug?=
 =?big5?Q?layer?=
Thread-Topic: =?big5?B?pl7OYDogW1JGQyBQQVRDSCBuZXQtbmV4dCAyLzddIG5ldDogZXRodG9vbDogYWRk?=
 =?big5?Q?_support_for_Frame_Preemption_and_MAC_Merge_layer?=
Thread-Index: AQHYsb+nXYtt3WXwKU2Qzt72A2WzpK2zuuaAgAKuqwCABtWsgIAXVhCAgANdNoCAARDlgIAFZRuAgAJO34CAV8T2AIAGn6YA
Date:   Mon, 14 Nov 2022 15:42:49 +0000
Message-ID: <20221114154248.57v3gq4g7jwsgfom@skbuf>
References: <20220816222920.1952936-3-vladimir.oltean@nxp.com>
 <87bksi31j4.fsf@intel.com> <20220819161252.62kx5e7lw3rrvf3m@skbuf>
 <87mtbutr5s.fsf@intel.com> <20220907205711.hmvp7nbyyp7c73u5@skbuf>
 <87edwk3wtk.fsf@intel.com> <20220910163619.fchn6kwgtvaszgcb@skbuf>
 <87o7viiru6.fsf@intel.com> <20220915141417.ru2rdxujcgihmmd5@skbuf>
 <DB8PR04MB57855557502DDC669A470E6FF0019@DB8PR04MB5785.eurprd04.prod.outlook.com>
In-Reply-To: <DB8PR04MB57855557502DDC669A470E6FF0019@DB8PR04MB5785.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|AM9PR04MB8414:EE_
x-ms-office365-filtering-correlation-id: 507b1588-ec3e-4226-6a87-08dac656e267
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MOoWFSJDkcZjA1MG88kldhkDm0XNn5A07gxygjMBxz/9ebZWsNARlvsqpiVJSogmMMug15zdYw9iBepU+NZ14MgT/JioCgrvuDx0dZPOYWwByHoGu7zQPL7rRHz6IBN2N0M7C+fTafBBfKkGEK0WnPkvKIIPrrVFK2riAu/swSA9lZ/WPPqmBO+pnOKnWpBwOpWv3siAhMcrDqiDmt7TX/x+bLIQZHjFDHnNfpCZPmHYa6wvsBRelLClKe3Y2tMzo31uGZIbm6SEcAtusbh1EPpwQX12y/aS+khvnotyZq+HIQQ5XIujs93lP9TIecxN1z3dyPt8rKKWDW5ktlezyoc88CIU0IopMs1IpaLUZtnIO8mP2dBP1/0dIY/KwQWOmrZO5TrdpVujS3WbALymdfxROxB3kndEZm1vkiiTa72wuF3q68UzCvepZ/JajUbg41A17IGHao28CnvhdCPZCd0vNvNPojir+XpnPxD8L+tLRln6gLBRPmGHx20ZcH6X2348Ecc5tGmTbFRoDIAtJ7hEreTFFAhzzm27ytaZY+P5DNaEzr2FiAyOfwtv/Fb/3a82PgYA+IV6xwauwogc1jzgQybhj5wOnaJZKqW2U/zbpE/iEMIGL4FaXtLWmlE4+YdrrmY07KyiqnJNN2c+JjeGUiLwGuhOojADcTB/C3A1qHkxzsJ14S+EQgwG58ljCkv3lvHmtVPVQSwwAU3lvRlmGWz6Jfh0J+SZP9O8NzXDQKmzaQj3DpCkNqhYuJGAJz5qY5uJk+5c6StX7p076Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(366004)(136003)(396003)(346002)(376002)(39860400002)(451199015)(186003)(6636002)(478600001)(316002)(54906003)(6486002)(6506007)(33716001)(71200400001)(122000001)(38070700005)(38100700002)(6512007)(1076003)(9686003)(83380400001)(26005)(86362001)(5660300002)(2906002)(44832011)(8936002)(4326008)(66556008)(91956017)(66946007)(64756008)(66476007)(76116006)(224303003)(66446008)(6862004)(41300700001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?big5?B?dGJQYWg5azZRTmtNNUVEak9PejdDeWtXRVN0QjhEaGVReW9SbFRLQXFEWkRuQWVJ?=
 =?big5?B?VlpONC9GaURibWpQNDJuVUlodkwyRmVJZVRIcmYvQklGODFkVzhJYW1DZEsxVk1S?=
 =?big5?B?aWkwOXQwanprcWhGRnpQcFhiZXgrNkY4RE15aVBHdVVWd29uZUQybU04aGhxRkcz?=
 =?big5?B?YnlnWExDeUxXOU02blpaSmo0SExndGVSbzUwYThCelZ2YzJYc0lUbnc0WjVJU0ZW?=
 =?big5?B?ck1hSGpzaFg0aUJpeTNTa3B3NFhscW56Yy9mRzl1L014Ym9tQ0JMeGJUQmQ5ZlF4?=
 =?big5?B?SUtjVnJxd0xaMUZzUFFkcmRPd0wwSlErMkpNbkJrcDFTcmdIU3VsbHk3eFlwVVpM?=
 =?big5?B?N1p4VFkzUDJXUitpRmNuWVpacXBBcVRidmhqbG9TanJSeWdZUllLQ0hKb0wweDR1?=
 =?big5?B?ZXJpNXgwNHE5YW5GT29NbjUvSW1uOGZiSjZETk5Nak9jdGVxWmFnWkFteS91YXNl?=
 =?big5?B?S0pNbkdGbHJlV3VGSHZWK3JoYmgrMXUzbjNyQ3ZuRGVoK3llb1VTaElTYTNCUVM2?=
 =?big5?B?NjhuRzkza01yaHdNaFpJNWl1Z2NVcWxRUGhSeVNrb1lQZ1N1MU00M042SEtmVmEy?=
 =?big5?B?bzRLVTR2OEpQWHZoNklOZ3FiL0U1NDRkcXd6YWZSRjZabXFLMnpDME9VeUFlSEg2?=
 =?big5?B?RVR6eDhINktHTWJBRXBMeFZ6a3F4alhpcUVaUG55UmhXelAyZXBuc0VQeXp5c0k4?=
 =?big5?B?QktmZTFuWjFTZWdzQUYzcm5kbjZPTU9Qdkx5UHAxT2RXd2lyUDl2R1Jud0NaVGdT?=
 =?big5?B?OCtNeXQ3TFZTNHJyMmdsaGtOd3N5Q2JURFVqd1BHMXlRSGNsNFFQNFBabTlLV1NG?=
 =?big5?B?VUpqZ1FSeW05aEVCN2hyVUZzSUdRZUs4M1pKdUlFU2RLUEVYdkNnRzFHNUE1T21G?=
 =?big5?B?NlU1UnZrT3p0UTllVUxVbHBNMEpOMHh3TVAvVHhTQ0dSQ0dodHZiZDMvcjd2S2F4?=
 =?big5?B?TU15NWgvUnhFUnhLSUd1SEdEQTd3QldqcW1KTzEwOWtyaWtuVitoUDN2NHp6Q0hr?=
 =?big5?B?eUsrMDk5V0JieGhzUGJHdzI5MVZ2c3NGeXYyOU15Rm9aZFgxNEpoWkFCV28rSE1U?=
 =?big5?B?L1VJdHpaODdRdDM1a0N0Z2Z4UkpGZE9GTGVRNDA3cW9OUXllOXdpOHhKU1krWlkr?=
 =?big5?B?bG40Rzd3ZnJCWkZvSFhXVVQrNmd2NDdqQnJRbXc2UmowV2dNNkxhUWl4QjlEaXVQ?=
 =?big5?B?WWtTVGVQckw3OXZmT3dMdlFOYVM4a1hkVldydFZsaWlSd1lXWmIrbVMvOWZKanh4?=
 =?big5?B?NkVETjc1M0M5RUhwMzMrRnJmbzJRV2lDc0NEQktUV0R4WVNQSnBDbFJSZVRtb1NB?=
 =?big5?B?R2k5N0t6Qyt1Qk9MZGs1djdXd1UxSHI2ZDFnMDl1MGhaSHNJTDVVdmFiWm5WY2Y3?=
 =?big5?B?WDFJMDExd2tBd3hoNWY5NVRkdTdEWEpzRlh1ZTBrZllEZUtXeEV5NVcrRDNXaURF?=
 =?big5?B?cjV0WmF2NTFzRDBpK1BDbG5Va0NSZDBiZXcxVE5GVG5Wc0tib2t2RzM5ZXpCNFA3?=
 =?big5?B?bitsdE1ZcTErYUoxZnZsZnVGNXVpT1pwelQrMkZhV1RMdk1BdVZzTnFESUk1YzFV?=
 =?big5?B?Sk9TTFJPQUcxRTlQSGhKTWZiTE9PSFV5bzBJNzNsSk91bmFXRlRoUUx0SkMzNFZM?=
 =?big5?B?VVhDUzFZTnZseDhITUsyRkQrbExTck1UTVJvK0gzWjMxQVVybEdZYzBjTWFTa2Jv?=
 =?big5?B?bXlZV096U1ZjSlNYYVhrZ3VrdjBLUmZ2TDhJdWJSV1hobmtqYUsxMWZkRFRRczl2?=
 =?big5?B?N0Q0eFFnSFBEWVk4NGVKSWFnOXZlWktXOElBSTJvMXFZZ1Vsd1RFbTN0UnlQblQr?=
 =?big5?B?ajVmUEhQeEw2ZWd3M2JmNmpjU3Y4amFFY3FCdFI4Sm5XODdqRDdwcUtvRXZtMkgy?=
 =?big5?B?Vm1DQ0lSV2FnOFM5eDhEL3E1aEUxR1hjbHBURlhxVWZmUXgrRVJoeVowckhvNDdr?=
 =?big5?B?WlJmWVZmVStyT2h2L0hPS1BrNDJmYkhFUkd5ZG5VcVFCdldZSnRwUGtocndrME1T?=
 =?big5?B?TXloengrT3JEa1A1akVtSkRUYzhTQnhUZlgrc0JvWUdOcTJRMnc9PQ==?=
Content-Type: text/plain; charset="big5"
Content-ID: <D59274EFBFE40A47BD3D630B8A3C19DD@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 507b1588-ec3e-4226-6a87-08dac656e267
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Nov 2022 15:42:49.4105
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: X/E22zx4JXAnbKml4EmH2LlCc7Rr0/WoJzN/XkjKFOH2SLVgGMvLuS3QHPr9hkc9ejJNLUIRpL5Ko8cGl7Ra9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8414
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgWGlhb2xpYW5nLA0KDQpPbiBUaHUsIE5vdiAxMCwgMjAyMiBhdCAxMDozMzo1MEFNICswMDAw
LCBYaWFvbGlhbmcgWWFuZyB3cm90ZToNCj4gT24gU2VwIDE1LCAyMDIyLCBWbGFkaW1pciB3cm90
ZToNCj4gPiA+IFRoYXQncyBhIGdvb2QgcG9pbnQgKHlvdXIgdW5kZXJzdGFuZGluZyBvZiB0aGUg
ZmxvdyBpcyBzaW1pbGFyIHRvIG1pbmUpLg0KPiA+ID4gVGhpcyBzZWVtcyBhIGdvb2QgaWRlYS4g
QnV0IHdlIG1heSBoYXZlIHRvIHdhaXQgZm9yIGEgYml0IHVudGlsIHdlDQo+ID4gPiBoYXZlIGEg
TExEUCBpbXBsZW1lbnRhdGlvbiB0aGF0IHN1cHBvcnRzIHRoaXMuDQo+ID4gDQo+ID4gVGhpcyBp
cyBjaXJjdWxhcjsgd2UgaGF2ZSBhIGRvd25zdHJlYW0gcGF0Y2ggdG8gb3BlbmxsZHAgdGhhdCBh
ZGRzIHN1cHBvcnQgZm9yDQo+ID4gdGhpcyBUTFYsIGJ1dCBpdCBjYW4ndCBnbyBhbnl3aGVyZSB1
bnRpbCB0aGVyZSBpcyBtYWlubGluZSBrZXJuZWwgc3VwcG9ydC4NCj4gPiANCj4gPiBXaGF0IGFi
b3V0IHNwbGl0dGluZyBvdXQgTUFDIG1lcmdlIHN1cHBvcnQgZnJvbSBGUCBzdXBwb3J0LCBhbmQg
bWUNCj4gPiBjb25jZW50cmF0aW5nIG9uIHRoZSBNQUMgbWVyZ2UgbGF5ZXIgZm9yIG5vdz8gVGhl
eSdyZSBpbmRlcGVuZGVudCB1cCB0byBhDQo+ID4gcHJldHR5IGhpZ2ggbGV2ZWwuIFRoZSBNQUMg
bWVyZ2UgbGF5ZXIgaXMgc3VwcG9zZWQgdG8gYmUgY29udHJvbGxlZCBieSB0aGUNCj4gPiBMTERQ
IGRhZW1vbiBhbmQgYmUgcHJldHR5IG11Y2ggcGx1Zy1hbmQtcGxheSwgd2hpbGUgdGhlIEZQIGFk
bWluU3RhdHVzIGlzDQo+ID4gc3VwcG9zZWQgdG8gYmUgc2V0IGJ5IHNvbWUgaGlnaCBsZXZlbCBh
ZG1pbmlzdHJhdG9yLCBsaWtlIGEgTkVUQ09ORiBjbGllbnQuDQo+IA0KPiBJIGFncmVlIHRoYXQg
c3BsaXR0aW5nIG91dCBNQUMgbWVyZ2Ugc3VwcG9ydCBmcm9tIEZQIHN1cHBvcnQsIHRoZXkgYXJl
IGRlZmluZWQNCj4gYnkgZGlmZmVyZW50IHNwZWMuIEknbSB0cnlpbmcgdG8gYWRkIExMRFAgZXhj
aGFuZ2UgdmVyaWZpY2F0aW9uIHN1cHBvcnQuIFRoZQ0KPiBwcm9jZWR1cmUgaXMgbGlrZSBmb2xs
b3dpbmc6DQo+ICAxLiBlbmFibGUgcHJlZW1wdGlvbiBvbiBsb2NhbCBwb3J0IGJ5IHVzaW5nICJl
dGh0b29sIiwgZG8gbm90IGFjdGl2ZSBwcmVlbXB0aW9uLg0KDQoiRW5hYmxlIiBhbmQgImFjdGl2
YXRlIiBhcmUgZGlmZmVyZW50IHRoaW5ncyBvbmx5IGlmIHZlcmlmaWNhdGlvbiBpcyB1c2VkLg0K
T3RoZXJ3aXNlLCB0aGV5IG1lYW4gdGhlIHNhbWUgdGhpbmcuDQoNCkluIHR1cm4sIExMRFAgZG9l
cyBub3QgY29udHJvbCB3aGV0aGVyIHZlcmlmaWNhdGlvbiBpcyB1c2VkIG9yIG5vdC4gU28sDQpm
cm9tIHRoZSBwZXJzcGVjdGl2ZSBvZiB0aGUgTExEUCBkYWVtb24sIHlvdSBjYW4ndCAiZW5hYmxl
IiBidXQgIm5vdCBhY3RpdmF0ZSINCnByZWVtcHRpb24uDQoNCkFuZCBJIHdvdWxkbid0IGV4cGVj
dCB0aGUgTExEUCBmbG93IHRvIHJlcXVpcmUgdXNlIG9mIGV0aHRvb2wuDQoNCkFuZCBJIHRoaW5r
IHRoYXQgZW5hYmxpbmcgcHJlZW1wdGlvbiBhdCBzdGVwIDEgaXMgdG9vIGVhcmx5LiBXaHkgZW5h
YmxlDQppdCwgaWYgd2UgZG9uJ3Qga25vdyBpZiB0aGUgbGluayBwYXJ0bmVyIHN1cHBvcnRzIGl0
Pw0KDQo+ICAyLiBEZWNvZGUgdGhlIExMRFAgVExWIG9mIHJlbW90ZSBwb3J0IGFuZCBlbnN1cmUg
dGhlIHJlbW90ZSBwb3J0IHN1cHBvcnRzDQo+IGFuZCBlbmFibGVzIHByZWVtcHRpb24uDQo+ICAz
LiBSdW4gU01ELXYvciB2ZXJpZnkgcHJvY2VzcyBvbiBsb2NhbCBwb3J0IG9yIGFjdGl2ZSB0aGUg
cHJlZW1wdGlvbiBkaXJlY3RseS4NCg0KVmVyaWZpY2F0aW9uIGFzIGRlZmluZWQgYnkgODAyLjMg
aXMsIGFzIG1lbnRpb25lZCwgaW5kZXBlbmRlbnQgb2YgdGhlDQpBZGRpdGlvbmFsIEV0aGVybmV0
IENhcGFiaWxpdGllcyBUTFYuDQpXaGljaCBzZWVtcyB0byBiZSBhIGdvb2QgdGhpbmcsIGNvbnNp
ZGVyaW5nIHRoYXQgMiBsaW5rIHBhcnRuZXJzIEEgYW5kIEINCmRvbid0IG5lZWQgdG8gaGF2ZSBj
b29yZGluYXRlZCBzZXR0aW5ncyBmb3IgdmVyaWZpY2F0aW9uICh2ZXJpZnlfZGlzYWJsZQ0KZG9l
c24ndCBuZWVkIHRvIGJlIGluIHN5bmMpLiBBbnkgZGV2aWNlIHdpdGggdGhlIE1BQyBNZXJnZSBs
YXllciB0dXJuZWQgb24gaXMNCnJlcXVpcmVkIHRvIHNlbmQgU01ELVIgKHJlc3BvbnNlKSBmcmFt
ZXMgaW4gcmVzcG9uc2UgdG8gU01ELVYgKHZlcmlmaWNhdGlvbiksDQpyZWdhcmRsZXNzIG9mIHdo
ZXRoZXIgaXQgc2VuZHMgU01ELVYgZnJhbWVzIG9mIGl0cyBvd24uDQoNClNvIHRob3NlIHdobyBl
bmFibGUgdmVyaWZpY2F0aW9uIHNob3VsZCBnZXQgYSByZXNwb25zZSBmcm9tIHRob3NlIHdobw0K
ZG9uJ3QgZW5hYmxlIGl0LCBhbmQgdGhvc2Ugd2hvIGRvbid0IGVuYWJsZSB2ZXJpZmljYXRpb24g
ZG9uJ3QgY2F1c2UgdGhlDQpsaW5rIHBhcnRuZXJzIHdobyBkbyBlbmFibGUgaXQgdG8gZmFpbCB0
aGVpciBvd24gdmVyaWZpY2F0aW9uLg0KDQpUaGUgb25seSB0aGluZyB0byBhZ3JlZSBvbiBpcyB0
aGlzOiBpZiB0aGUgbGluayBwYXJ0bmVyIHN1cHBvcnRzDQpwcmVlbXB0aW9uLCBhbmQgeW91IHN1
cHBvcnQgcHJlZW1wdGlvbiwgdGhlbiBob3cgZG9lcyB0aGUgTExEUCBkYWVtb24NCmRlY2lkZSB3
aGV0aGVyIHRvIGFjdHVhbGx5ICplbmFibGUqIHByZWVtcHRpb24/IE15IGFzc3VtcHRpb24gaXMg
dGhhdA0KaXQncyBmaW5lIHRvIHVuY29uZGl0aW9uYWxseSBlbmFibGUgaXQgYXMgbG9uZyBhcyBp
dCdzIHN1cHBvcnRlZC4NCk5vIGNvbmZpZ3VyYXRpb24gb3IgdXNlciBvdmVycmlkZSBpcyBuZWVk
ZWQuDQoNCkZXSVcsIEkgaGF2ZSBteSBvd24gcGF0Y2ggb24gdGhlIG9wZW5sbGRwIHByb2plY3Qg
KHllcywgbm90IGxsZHBkKSB3aGljaA0KYWRkcyBzdXBwb3J0IGZvciB0aGUgTUFDIE1lcmdlIGxh
eWVyLiBJIGhvcGUgSSBjYW4gd3JhcCBldmVyeXRoaW5nIHVwDQpzb21lIHRpbWUgbmV4dCB3ZWVr
IGFuZCByZXNlbmQgZXZlcnl0aGluZyBpbiBhIHN0YXRlIHRoYXQgcmVmbGVjdHMgd2hhdA0KSSd2
ZSBiZWVuIGNvb2tpbmcgaW4gdGhlIG1lYW50aW1lLiBJIGRvbid0IGhhdmUgYSBzb2x1dGlvbiBm
b3IgdGhlDQphZG1pblN0YXR1cyB5ZXQsIGJ1dCBJIGd1ZXNzIEknbGwgdHJ5IHRvIGFkZCBpdCB2
aWEgdGhlIG5ldGxpbmsgaW50ZXJmYWNlDQpvZiB0Yy10YXByaW8gYW5kIHRjLW1xcHJpby4NCg0K
PiAgNC4gU2VuZCB1cGRhdGVkIExMRFAgVExWIHRvIHJlbW90ZSBwb3J0Lg0KPiAgNS4gRGlzYWJs
ZSBwcmVlbXB0aW9uIG9uIGxvY2FsIHBvcnQgYW5kIHJlcGVhdCBzdGVwIDEtNCB3aGVuIGxpbmsg
ZG93bi91cC4NCj4gDQo+IFRoZSBzdHJ1Y3QgImV0aHRvb2xfbW1fY2ZnIiBzZWVtcyBub3QgZml0
IHRoaXMgcHJvY2VkdXJlLiBJIHVwZGF0ZSBpdDoNCj4gc3RydWN0IGV0aHRvb2xfbW1fY2ZnIHsN
Cj4gCXUzMiB2ZXJpZnlfdGltZTsNCj4gCWJvb2wgdmVyaWZ5X2Rpc2FibGU7DQo+IAlib29sIGVu
YWJsZWQ7DQo+ICsJYm9vbCBhY3RpdmU7IC8vIFVzZWQgdG8gYWN0aXZlIG9yIHN0YXJ0IHZlcmlm
eSBwcmVlbXB0aW9uIGJ5IExMRFAgZGFlbW9uLg0KDQpXaGF0IHNlbnNlIGRvZXMgaXQgbWFrZSB0
byAiZm9yY2UiIHByZWVtcHRpb24gYXMgYWN0aXZlPyBXaGF0IHdvdWxkIHRoaXMNCmRvIGluIHRl
cm1zIG9mIGRyaXZpbmcgdGhlIGludGVybmFsIHN0YXRlIG1hY2hpbmVzIG9mIHRoZSBoYXJkd2Fy
ZSwgaS5lLg0KZm9yY2UgRlAgYWN0aXZlIGluIHdoaWNoIHdheT8gSXQncyBhY3RpdmUgd2hlbiBl
bmFibGVkIGFuZCB2ZXJpZmljYXRpb24NCmlzIGVpdGhlciBkaXNhYmxlZCwgb3IgZW5hYmxlZCBh
bmQgY29tcGxldGUuDQoNCj4gCXU4IGFkZF9mcmFnX3NpemU7DQo+IH07DQo+IElmIHdlIHdhbnQg
dG8gZW5hYmxlL2Rpc2FibGUgdGhlIExMRFAgZXhjaGFuZ2UgdmVyaWZpY2F0aW9uLCBtYXliZSB3
ZSBuZWVkDQo+IHRvIGFkZCBtb3JlIHBhcmFtZXRlcnMgbGlrZSAiYm9vbCBsbGRwX3ZlcmlmeV9l
bmFibGUiDQoNCkNvbnRyb2wgdGhlIExMRFAgZXhjaGFuZ2UgdmlhIGtlcm5lbCBVQVBJPyBCdXQg
d2h5PyBXaGF0IGRpZmZlcmVuY2UgZG9lcw0KaXQgbWFrZSB0byB0aGUga2VybmVsIHdoZXRoZXIg
dGhlcmUgaXMgYW4gTExEUCBkYWVtb24gb3Igbm90PyBMTERQIGZyYW1lcw0KYXJlIG5vcm1hbCBw
YWNrZXRzIHNlbnQgdmlhIFBGX1BBQ0tFVCBzb2NrZXRzLCBubyBzcGVjaWFsIGRyaXZlciBpbnZv
bHZlbWVudA0KbmVlZGVkLiBOb3QgdGhlIHNhbWUgdGhpbmcgYXMgU01ELVYvU01ELVIgaGFyZHdh
cmUgdmVyaWZpY2F0aW9uLg==
