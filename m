Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D9AD623FE4
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 11:34:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbiKJKd6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 05:33:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbiKJKdz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 05:33:55 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2051.outbound.protection.outlook.com [40.107.21.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31E4864A21
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 02:33:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=coHQKIYBZuvUImcgYWBLgnvpByAG9sNnz3aPZ1gqquMDRbNfQ/zoioTg8htnHU0XVeyVdJr1JQuNCAClhmr//l00898Re1P0d2gNSvIQYZ0MCU6f6M3vnbNqGx/teTAw8PI1h6OrsxogSEB2Rprd6s2e2GEuoxp4Bmr1TcI/Ivu0oiizM5zztXCqiQmQRYiPmAQ4XaxlrHbzCTi9jacWWiYvC3UtU9KET0GULpAX+nm91VZZrx/oUNmFjox22T6RJ54RTtX8rXn/18OdIZwrW9KszH+R81dmT0vvaFnSRKYSBmuYQ5qJRDOP7FKNO9sl5PFhAkjQkNLJNGqXRIAX6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mu+ex2NCoQktn5mbnG0sGKNZoSgdZvDAq5zAePjY3NM=;
 b=cqjHI0I0AaDUAk7IiJFhghuv9gNfuWsQxSLK0xOUj9iUe0xCZL3vnoVIytlmz11y8Ded0wfu/vjeKELJiGcoMDAL2RP+1ySk9KkAKWM+DINhYtZO8n0S5fGX8y89irvneuiDAzvlQld/DbGTUYPK04dz7RMYcEbzcJwQhmz584hLck02vAnvKpTjJ67onwur2gMdSYR9jlzT3RG/Lk0KjvySDv/X+7JQgchMy6n2RvDxruumE9b0vdUJ1R7QAMQBGUKjRgQy8wtuv4yiQ3dpKU0NjdIUC0a7kmRpBpYN7FCArB/JiHJWm01iZXDaiQT3FA11m3oym1go0U0zGHoAvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mu+ex2NCoQktn5mbnG0sGKNZoSgdZvDAq5zAePjY3NM=;
 b=hhBJqil5IYxTe7mDfy/Pi3LthTyiCDgFU1RZcnSuiNCYA7qhLD4df2dzaX7Cw6qQn4pFtpuAP5kqLqRr4e54DhRQj/BSojyLC2/obFgrpizrVa7P/Lx1g7rbURLmWOmu6n47LTYK4JopZmtTjyasYP8dhnEqhJppHcLgLDMCiY0=
Received: from DB8PR04MB5785.eurprd04.prod.outlook.com (2603:10a6:10:b0::22)
 by DBBPR04MB7977.eurprd04.prod.outlook.com (2603:10a6:10:1ed::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Thu, 10 Nov
 2022 10:33:50 +0000
Received: from DB8PR04MB5785.eurprd04.prod.outlook.com
 ([fe80::4553:448:b498:4d87]) by DB8PR04MB5785.eurprd04.prod.outlook.com
 ([fe80::4553:448:b498:4d87%6]) with mapi id 15.20.5791.027; Thu, 10 Nov 2022
 10:33:50 +0000
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
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
Subject: =?utf-8?B?5Zue5aSNOiBbUkZDIFBBVENIIG5ldC1uZXh0IDIvN10gbmV0OiBldGh0b29s?=
 =?utf-8?B?OiBhZGQgc3VwcG9ydCBmb3IgRnJhbWUgUHJlZW1wdGlvbiBhbmQgTUFDIE1l?=
 =?utf-8?Q?rge_layer?=
Thread-Topic: [RFC PATCH net-next 2/7] net: ethtool: add support for Frame
 Preemption and MAC Merge layer
Thread-Index: AQHYyQ1y8ELfl9KqykSkoKdem4pQxK44Jm7Q
Date:   Thu, 10 Nov 2022 10:33:50 +0000
Message-ID: <DB8PR04MB57855557502DDC669A470E6FF0019@DB8PR04MB5785.eurprd04.prod.outlook.com>
References: <20220816222920.1952936-1-vladimir.oltean@nxp.com>
 <20220816222920.1952936-3-vladimir.oltean@nxp.com> <87bksi31j4.fsf@intel.com>
 <20220819161252.62kx5e7lw3rrvf3m@skbuf> <87mtbutr5s.fsf@intel.com>
 <20220907205711.hmvp7nbyyp7c73u5@skbuf> <87edwk3wtk.fsf@intel.com>
 <20220910163619.fchn6kwgtvaszgcb@skbuf> <87o7viiru6.fsf@intel.com>
 <20220915141417.ru2rdxujcgihmmd5@skbuf>
In-Reply-To: <20220915141417.ru2rdxujcgihmmd5@skbuf>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DB8PR04MB5785:EE_|DBBPR04MB7977:EE_
x-ms-office365-filtering-correlation-id: 61271e9f-ae2e-4556-2dc4-08dac3070e8d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1hC9ws7Xzbui1IBmNs4JE/ZSYhls7DK2W+r/lqgIthn29HF4Vi25UlHqq5Y9dk2qscXLeLLBUL7mj87w5NWryyo8ox60V8wmQUXxOs/PcrBd6PQQDJ+k3U7sR6vO0syq977h4Vt+ollFLkLoVlwXB4vmG2YohmdenFZSpcG6OMGMlvF9cgCivnURHb5+aJB2I+AEBx+ltBEzc9Zl3B/f6/VOlOcJwIW5JZqJK42arVkjy1BCsaRAeme7g/MEeHPaQzhN86sPPBRlFTh7B13JeZ5l2cKJZ4nn6U99S1lHPzhZ5+WV5GVLQqgpzgVIvAIgbC024p9c/Ak2AY4D7Wjw6aumK99flB/c8XpGocnFgYG8d7VefMMEGohbSiXXKh/KQh1qYuS4BV5r66KENWXLI9MfemxnsewgfmATaWoj8DjcV4Eb0xq0oENXptS6N32oWexIVJ2F7wDCuNm9bXwONtgMe5sEyy4Ewo0GGEYiFpNi1uhK1R8zvIy2PckezOs+/SsXZxClO98VInPzp1LxqgA8rQcNowaCZerhxMiTmTh7jY02gMYhtEZKzuoz444jkyr5oPAIY78n+35CtsUJ3HwriWbHxA0qPweaxBXxG6WCEbK4z5KdVDVH4TvqU5HzhSs7wWo9sAJV9q2UaxQBaSpVsVpJ6sPTVZ5wOAvTZl42ejnCfFG6kra3slDSO5jvbCkXHz6tnz1ucF/WpMaAqEsF0E3S01w+7vHRn1NgjVsiNGlKSopA/1gyVYH8dLWy4aKvVHg3H14qMJvCSgVtSzp3aUqZL11mkEXIj3io3Uk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB5785.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(366004)(39860400002)(346002)(376002)(136003)(451199015)(224303003)(9686003)(26005)(33656002)(38070700005)(38100700002)(122000001)(83380400001)(186003)(110136005)(7696005)(6506007)(2906002)(5660300002)(52536014)(66476007)(41300700001)(64756008)(66446008)(76116006)(66556008)(86362001)(66946007)(4326008)(478600001)(54906003)(966005)(316002)(71200400001)(8936002)(55016003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?clFPUm90OURKZG9IdWNpeUVDU01kK2RqYy93NFZNK1hiemdxbDFkMXh6aUhO?=
 =?utf-8?B?Sk4xV3ZoWFNCLzhKTS9LTWN6NjNMaHVBS3F0QWY4ZndvMVpPY0lQU2NiUzUz?=
 =?utf-8?B?T21aOHUrZmw2Q2psUlIzTlp0NkFETTJKaENoYlFWOXMwdEhvMVhuL3JHSVNT?=
 =?utf-8?B?NnhtSitZczQ0RmJocUdmTldjU2tqUU1NMFZEaVp1ZUQvd1JncEN5M1R2WFZC?=
 =?utf-8?B?QkNKZVdEbjdxazU5YWQ5a3lMcGx5L3V1RWgyTy8vNGJFZEswYTBIeUlucnh5?=
 =?utf-8?B?SVZkd3puc0pUM3QrQXUxQmcyZUtYaEpqSC9xb3ZiMlhpdTNXbWhYZHZZN1RH?=
 =?utf-8?B?SHF4RVVGeUZnUnRHZWVmRkpwaktGbzRDZWxzNndMQVNUaDUrYW82Q3d4dlpj?=
 =?utf-8?B?ampUc0ZQRGZYbHA1TkVHZG1pcWZzWWM4eUU5M29acVRPTFdtMXU0dk1mWTBH?=
 =?utf-8?B?ckp2d3FnMU14WWpUM2VLTnRyQklWam5iUW5mdzlTMmdDZ2hIU2pnTkFjdzBU?=
 =?utf-8?B?bXJSUlRaVnBkL2E0WWJNcGE2TnREYVN3N1BidmxTcENmQ1J5THA3S1RRZTBZ?=
 =?utf-8?B?bUoyUzhCck9ZNXFveEpPelNEQ3ZRVlRObkJvTm5nNkZkYkg2QkdHM1BEU1Q0?=
 =?utf-8?B?NFMzVUQxNkJWRENaN2RNSHRubFRaSGdkZFBRRjBXQVpQSk4rMmpReHNvMWdH?=
 =?utf-8?B?YWtJVHFwQTBVZktVaXF6OVRTb25LOWxLcmN6bGNMczMxdVV4MGpGZEQrV3FO?=
 =?utf-8?B?VVR4RC9RMTE4UUdrMURJYU9hSjltY3pXRlcrS01NSit4QWQ2M21SMTFaTkw0?=
 =?utf-8?B?RlhiVVZEWUdtWTkrL1BiY2llSVFVZCtzUDJWT1hIZ0x2Yk5hN3g3b0xnWm9D?=
 =?utf-8?B?YkNLOWVlaEQvVHRFSVk0Tm00YVBQaFRUWjBkYVM0UUNaVjE0cjlEZ09IbU1x?=
 =?utf-8?B?K2pZcWNRNjdnOFFvUUI0UUNxTU1jMzU4OGNvcnk1NUV6eVB1WVk2VUY2dmdT?=
 =?utf-8?B?cXF6TnRlaVN0YmlTQm55RDB4cXQrVDA4VFVoaFBUeHhuQ1R0SHBLZjQrNDVj?=
 =?utf-8?B?R2g0c2xPdU85REZpblBBMlJaU0lUa2wvMnRxM2VIYzhtTkc2U0xXVmdUd1d4?=
 =?utf-8?B?MGR0OHVvcUtuelNjOTNqN3dqd0paMlR4eXhkdGtvM2pyQklUbUY4dUxFM29G?=
 =?utf-8?B?Ty94cXFsUFc3SEpjMjRHV3YyOWxmMFBQcFpnektDVUUrMHpWTXVtb1haWHVM?=
 =?utf-8?B?eUNOU3RSaVAvTzhRcm81NCszZ1VjckZWM1A2aUJPWWZmN3A5c2NzSTYxWW5U?=
 =?utf-8?B?NXZET3JRaEp3ZzFhMmY2YlZaZWRRK0lqUTdnTStxRXpJWjlWV1ROcm5jVVFT?=
 =?utf-8?B?ZzlWWWxwd3pnL1VUdEZwalkzSjlUbGkzTDZBL2tlSDhaa29INjVjVFljSHVi?=
 =?utf-8?B?Rm1qZURqcEpJeUE3M0p0eTN6NmJaYXp3SEYzVVdhUjk0eWhmMXdXdnRHaUlN?=
 =?utf-8?B?MmFrbk9rK1hqNHZCS3R2U0l0RXNscjA4bkNObHJzVnpjMmcwOStyaVlub2Rw?=
 =?utf-8?B?cklQeHdZR245OCszczlJcmh5SUVkWkVSYkNZbUNPbWVrSjVzbjFhMzdBMlRu?=
 =?utf-8?B?UXJEY2szSGE0WldOdW55aVFJV3VBeERDSUFoWFlNMldob0k0eG5rNW1zSFg1?=
 =?utf-8?B?Qm92UEYyelhJeWJ6RDNkQ3M5TDIrOExtY2lGcEc0emNVZG1zY3BXT1BnckFl?=
 =?utf-8?B?aUt2VzQ0TFQ5L3gwSXd0WFJXQ0FSd0MzK2pkakZzdWRwRWhsaXFnOWVQbk5F?=
 =?utf-8?B?VmdOd05aZ1JLWUo4c2JrS2JoU3grSFhHbFlXYXNCMjNUZitwUGNhZGYwTGpo?=
 =?utf-8?B?alhMRUFXOG90N0F6bnF6ZmJaS3JHRi9rNVZsZ1hyaWxDK0FjM2xBZ1hiTkJH?=
 =?utf-8?B?elJFdDRSRU9wVjdJcCtIdllVTDVUYklPeHljY2U0MzZOVWZUczJObG43dE8v?=
 =?utf-8?B?dHVnUU85cURnaTh1b0h3YkdUUEFoR29PWCtWZ3hBbUl0NXhQazFWNjc1RU1J?=
 =?utf-8?B?akVPSXFFNm1YUW5CNjJBMjdkN1JabVpSRnZ1RWFTSXp4RkV4RFltaVdONGgv?=
 =?utf-8?Q?GCi2eYHzdOw+a0gWfA8qPEFgp?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB5785.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61271e9f-ae2e-4556-2dc4-08dac3070e8d
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2022 10:33:50.2198
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CHQW0gW5Wik2dz7lJ76F+8p4mzMYjBbUavg9TTJYkDttePPtQ7FDaYvdugjkJgXDBTLOGaff3DpppLb8RBFseZkF91ZUNh+vxYv6a3iFYl8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7977
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU2VwIDE1LCAyMDIyLCBWbGFkaW1pciB3cm90ZToNCj4gPiBUaGF0J3MgYSBnb29kIHBvaW50
ICh5b3VyIHVuZGVyc3RhbmRpbmcgb2YgdGhlIGZsb3cgaXMgc2ltaWxhciB0byBtaW5lKS4NCj4g
PiBUaGlzIHNlZW1zIGEgZ29vZCBpZGVhLiBCdXQgd2UgbWF5IGhhdmUgdG8gd2FpdCBmb3IgYSBi
aXQgdW50aWwgd2UNCj4gPiBoYXZlIGEgTExEUCBpbXBsZW1lbnRhdGlvbiB0aGF0IHN1cHBvcnRz
IHRoaXMuDQo+IA0KPiBUaGlzIGlzIGNpcmN1bGFyOyB3ZSBoYXZlIGEgZG93bnN0cmVhbSBwYXRj
aCB0byBvcGVubGxkcCB0aGF0IGFkZHMgc3VwcG9ydCBmb3INCj4gdGhpcyBUTFYsIGJ1dCBpdCBj
YW4ndCBnbyBhbnl3aGVyZSB1bnRpbCB0aGVyZSBpcyBtYWlubGluZSBrZXJuZWwgc3VwcG9ydC4N
Cj4gDQo+IFdoYXQgYWJvdXQgc3BsaXR0aW5nIG91dCBNQUMgbWVyZ2Ugc3VwcG9ydCBmcm9tIEZQ
IHN1cHBvcnQsIGFuZCBtZQ0KPiBjb25jZW50cmF0aW5nIG9uIHRoZSBNQUMgbWVyZ2UgbGF5ZXIg
Zm9yIG5vdz8gVGhleSdyZSBpbmRlcGVuZGVudCB1cCB0byBhDQo+IHByZXR0eSBoaWdoIGxldmVs
LiBUaGUgTUFDIG1lcmdlIGxheWVyIGlzIHN1cHBvc2VkIHRvIGJlIGNvbnRyb2xsZWQgYnkgdGhl
DQo+IExMRFAgZGFlbW9uIGFuZCBiZSBwcmV0dHkgbXVjaCBwbHVnLWFuZC1wbGF5LCB3aGlsZSB0
aGUgRlAgYWRtaW5TdGF0dXMgaXMNCj4gc3VwcG9zZWQgdG8gYmUgc2V0IGJ5IHNvbWUgaGlnaCBs
ZXZlbCBhZG1pbmlzdHJhdG9yLCBsaWtlIGEgTkVUQ09ORiBjbGllbnQuDQpJIGFncmVlIHRoYXQg
c3BsaXR0aW5nIG91dCBNQUMgbWVyZ2Ugc3VwcG9ydCBmcm9tIEZQIHN1cHBvcnQsIHRoZXkgYXJl
IGRlZmluZWQNCmJ5IGRpZmZlcmVudCBzcGVjLiBJJ20gdHJ5aW5nIHRvIGFkZCBMTERQIGV4Y2hh
bmdlIHZlcmlmaWNhdGlvbiBzdXBwb3J0LiBUaGUNCnByb2NlZHVyZSBpcyBsaWtlIGZvbGxvd2lu
ZzoNCiAxLiBlbmFibGUgcHJlZW1wdGlvbiBvbiBsb2NhbCBwb3J0IGJ5IHVzaW5nICJldGh0b29s
IiwgZG8gbm90IGFjdGl2ZSBwcmVlbXB0aW9uLg0KIDIuIERlY29kZSB0aGUgTExEUCBUTFYgb2Yg
cmVtb3RlIHBvcnQgYW5kIGVuc3VyZSB0aGUgcmVtb3RlIHBvcnQgc3VwcG9ydHMNCmFuZCBlbmFi
bGVzIHByZWVtcHRpb24uDQogMy4gUnVuIFNNRC12L3IgdmVyaWZ5IHByb2Nlc3Mgb24gbG9jYWwg
cG9ydCBvciBhY3RpdmUgdGhlIHByZWVtcHRpb24gZGlyZWN0bHkuDQogNC4gU2VuZCB1cGRhdGVk
IExMRFAgVExWIHRvIHJlbW90ZSBwb3J0Lg0KIDUuIERpc2FibGUgcHJlZW1wdGlvbiBvbiBsb2Nh
bCBwb3J0IGFuZCByZXBlYXQgc3RlcCAxLTQgd2hlbiBsaW5rIGRvd24vdXAuDQpUaGUgc3RydWN0
ICJldGh0b29sX21tX2NmZyIgc2VlbXMgbm90IGZpdCB0aGlzIHByb2NlZHVyZS4gSSB1cGRhdGUg
aXQ6DQpzdHJ1Y3QgZXRodG9vbF9tbV9jZmcgew0KCXUzMiB2ZXJpZnlfdGltZTsNCglib29sIHZl
cmlmeV9kaXNhYmxlOw0KCWJvb2wgZW5hYmxlZDsNCisJYm9vbCBhY3RpdmU7IC8vIFVzZWQgdG8g
YWN0aXZlIG9yIHN0YXJ0IHZlcmlmeSBwcmVlbXB0aW9uIGJ5IExMRFAgZGFlbW9uLg0KCXU4IGFk
ZF9mcmFnX3NpemU7DQp9Ow0KSWYgd2Ugd2FudCB0byBlbmFibGUvZGlzYWJsZSB0aGUgTExEUCBl
eGNoYW5nZSB2ZXJpZmljYXRpb24sIG1heWJlIHdlIG5lZWQNCnRvIGFkZCBtb3JlIHBhcmFtZXRl
cnMgbGlrZSAiYm9vbCBsbGRwX3ZlcmlmeV9lbmFibGUiDQoNCj4gDQo+IFdlIGNhbiBhcmd1ZSBz
b21lIG1vcmUgYWJvdXQgaG93IHRvIGJlc3QgZXhwb3NlIHRoZSBGUCBhZG1pblN0YXR1cy4NCj4g
UmlnaHQgbm93LCBJJ20gdGhpbmtpbmcgdGhhdCBmb3IgYWxsIGludGVudHMgYW5kIHB1cnBvc2Vz
LCB0aGUgYWRtaW5TdGF0dXMNCj4gcmVhbGx5IG9ubHkgbWFrZXMgcHJhY3RpY2FsIHNlbnNlIHdo
ZW4gd2UgaGF2ZSBhdCBsZWFzdCAyIHRyYWZmaWMgY2xhc3Nlczogb25lDQo+IG9udG8gd2hpY2gg
d2UgY2FuIG1hcCB0aGUgcHJlZW1wdGFibGUgcHJpb3JpdGllcywgYW5kIG9uZSBvbnRvIHdoaWNo
IHdlDQo+IGNhbiBtYXAgdGhlIGV4cHJlc3Mgb25lcy4gSW4gdHVybiwgaXQgbWVhbnMgdGhhdCB0
aGUgJ3ByaW9yaXRpZXMgY29sbGFwc2luZyBpbnRvDQo+IHRoZSBzYW1lIHRyYWZmaWMgY2xhc3Mn
IHByb2JsZW0gdGhhdCB3ZSBoYXZlIHdoZW4gd2UgZGVsZXRlIHRoZQ0KPiB0YXByaW8vbXFwcmlv
IHFkaXNjIGNhbiBiZSBzb2x2ZWQgaWYgd2UgcHV0IHRoZSBGUCBhZG1pblN0YXR1cyBpbnRvIHRo
ZSBzYW1lDQo+IG5ldGxpbmsgaW50ZXJmYWNlIHRoYXQgYWxzbyBjb25maWd1cmVzIHRoZSBwcmlv
OnRjIG1hcCBhbmQgdGhlIG51bWJlciBvZiB0cmFmZmljDQo+IGNsYXNzZXMgKGkuZS4geWVzLCBp
biB0YykuDQo+IA0KPiBJJ2xsIGxldCBzb21lb25lIG1vcmUga25vd2xlZGdlYWJsZSBvZiBvdXIg
c3lzcmVwby10c24gaW1wbGVtZW50YXRpb24gb2YgYQ0KPiBORVRDT05GIHNlcnZlciAobGlrZSBY
aWFvbGlhbmcsIG1heWJlIGV2ZW4gUnVpIG9yIFJpY2hpZT8pDQo+IGh0dHBzOi8vZ2l0aHViLmNv
bS9yZWFsLXRpbWUtZWRnZS1zdy9yZWFsLXRpbWUtZWRnZS1zeXNyZXBvDQo+IGNvbW1lbnQgb24g
d2hldGhlciB0aGlzIHdvdWxkIGNyZWF0ZSBhbnkgdW5kZXNpcmFibGUgc2lkZSBlZmZlY3QuDQo+
IFRoZSBpbXBsaWNhdGlvbiBpcyB0aGF0IHVzZXIgc3BhY2UsIHdoZW4gYXNrZWQgdG8gY2hhbmdl
IHRoZSBhZG1pblN0YXR1cywgd2lsbA0KPiBoYXZlIHRvIGZpZ3VyZSBvdXQgd2hldGhlciB3ZSBh
cmUgdXNpbmcgYSB0YXByaW8sIG9yIGFuIG1xcHJpbyBxZGlzYywgYW5kDQo+IGNyZWF0ZSBkaWZm
ZXJlbnQgbmV0bGluayBhdHRyaWJ1dGVzIHRvIHRhbGsgdG8gdGhlIGtlcm5lbCB0byByZXF1ZXN0
IHRoYXQNCj4gY29uZmlndXJhdGlvbi4gVXNlciBzcGFjZSB3aWxsIGFsc28gaGF2ZSB0byBzZW5k
IGFuIGVycm9yIHRvd2FyZHMgdGhlIE5FVENPTkYNCj4gY2xpZW50IGlmIG5vIHN1Y2ggcWRpc2Mg
ZXhpc3RzIChtZWFuaW5nIHRoYXQgdGhlIHVzZXIgd2FudHMgdG8gY29tYmluZSBwcmlvcml0aWVz
DQo+IG9mIGRpZmZlcmVudCBleHByZXNzL3ByZWVtcHRhYmxlIHZhbHVlcyBpbiB0aGUgc2FtZSB0
cmFmZmljIGNsYXNzLCBUQzApLiBUaGUNCj4gcWRpc2NzIHdpbGwgYWxzbyBjZW50cmFsbHkgdmFs
aWRhdGUgd2hldGhlciBzdWNoIGludmFsaWQgbWl4ZWQgY29uZmlndXJhdGlvbnMNCj4gYXJlIHJl
cXVlc3RlZC4NClRoZSBOZXRjb25mIHlhbmcgbW9kZWwgaGF2ZW4ndCBkZWZpbmVkIHRoZSBtYWMg
cHJlZW1wdGlvbiBmZWF0dXJlIG9mIDgwMi4zYnIsDQpidXQgaXQgZGVmaW5lcyB0aGUgODAyLjFR
YnUgcHJlZW1wdGlvbi4gSXQgdXNlcyBwcmlvcml0eSB0byBjb25maWd1cmUgdGhlDQphZG1pblN0
YXR1cyBvZiBmcmFtZS1wcmVlbXB0aW9uLXN0YXR1cy10YWJsZS4gVGhlIHByaW9yaXR5IG1hcCB0
cmFmZmljIGNsYXNzIGlzDQppbmRlcGVuZGVudCBpbiBOZXRjb25mLCBzbyB0aGVyZSBpcyBubyBl
ZmZlY3Qgd2hldGhlciB3ZSBjb21iaW5lIEZQIHN0YXR1cw0KY29uZmlndXJhdGlvbiB3aXRoIHRj
LW1xcHJpbyBvciBub3QsIGp1c3QgdHJhbnNsYXRlZCBpdCBpbiBLZXJuZWwgaXMgT0suDQoNCj4g
DQo+IEknbSBtb3N0bHkgT0sgd2l0aCB0aGlzOiBhbiBVQVBJIHdoZXJlIEZQIGFkbWluU3RhdHVz
IGlzIHBlciBwcmlvcml0eSwgYnV0IGl0DQo+IGdldHMgdHJhbnNsYXRlZCBpbnRvIHBlci10YyBi
eSB0aGUgcWRpc2MsIGFuZCBwYXNzZWQgdG8gdGhlIGRyaXZlciB0aHJvdWdoDQo+IG5kb19zZXR1
cF90YygpLiBJIGFtIGNlcnRhaW5seSBzdGlsbCB2ZXJ5IG11Y2ggYWdhaW5zdCB0aGUgInByZWVt
cHRhYmxlIHF1ZXVlDQo+IG1hc2siIHRoYXQgeW91IHByb3Bvc2VkLCBhbmQgSU1PIHlvdSdsbCBo
YXZlIHRvIGRvIHNvbWV0aGluZyBhbmQgY2xhcmlmeQ0KPiB3aGF0IGEgdHJhZmZpYyBjbGFzcyBl
dmVuIG1lYW5zIGZvciBJbnRlbCBoYXJkd2FyZSwgZXNwZWNpYWxseSBpbiByZWxhdGlvbnNoaXAg
dG8NCj4gbXVsdGlwbGUgcXVldWVzIHBlciB0YyAobXFwcmlvIHF1ZXVlcyAyQDEpLg0KPiANCj4g
QW55b25lIGVsc2Ugd2hvIGhhcyBhbiBvcGluaW9uIG9mIGFueSBzb3J0LCBwbGVhc2UgZmVlbCBm
cmVlLg0KSSBkaWRuJ3QgdGhpbmsgYWJvdXQgaXQgdG9vIG11Y2gsIGJ1dCBJIHRoaW5rIGNvbWJp
bmVkIHdpdGggdGMtbXFwcmlvIGNvbW1hbmQNCmlzIG1vcmUgZWFzeSB0byBpbXBsZW1lbnQsIHRo
aXMgZWxpbWluYXRlcyB0aGUgcHJpb3JpdHkgb2YgdHJhbnNsYXRpbmcgdG8gVEMuDQpFeGFtcGxl
Og0KdGMgcWRpc2MgYWRkIGRldiBldGgwIHJvb3QgaGFuZGxlIDE6IG1xcHJpbyBudW1fdGMgOCBt
YXAgMCAxIDIgMyA0IDUgNiA3IFwNCglmcC1wcmlvcyAweGZmDQo=
