Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEDF36645C6
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 17:16:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232560AbjAJQQu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 11:16:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234097AbjAJQQs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 11:16:48 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2069.outbound.protection.outlook.com [40.107.223.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7412243D89
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 08:16:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZtugDCxVFyqqnxIJXp9+OK3Ap6qDAj2o5/czqJcvpgsy95TALcLJNcUZaEDUYgnW8d9skE3Pzt/uk4n8ZizAHoYvbIAEkM9RZTKt+njlhcOTn4sPLSRyna6vIMqobhEuKZTHJKrDQi8PomiGjK9IZaZ/pqquNEAFtIyQQbeVKbZ6PZEWHJ6MtTRxiLcqKjiHgeJOq3BGfvBWkFdwMpMa/Q5c5LtI7sUjwEXph8mQ17PSpKicjlvj1C0ASu7kPwYhLU37G9ebM9xGqVFILG/C4k5R6edjyTvfptgggQGLOHkHWauMhpFtpR2mgvUE/C78/CG9PJVxGfOernn8FvIKLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CkeH3OKgOTWiK5puu7r814u95IMT/mfUtXTohKPaDaQ=;
 b=nPbZONxqz4FzqwKRuzcFwuI8iAtyAD+xqbJp0vk/6G38KaRZH6NixGvhtPGy3iIzmEB9KsrP/1RgWadg+MrWEpNUeCz9WKj4ACApNWOBlT4Z56uOLOSIRcgNECgW1pvlI/w+flnJuh/C28XSjzyalDmrADPTIYG3DuiceFvtzq9OdGuZ7NNZxVpnZEY3YaZXegYfF0onKY+onWrLlIFH4CcVJvUsnDF64LILvYdWcJoZCLON3KqtuaMnvpvGfWZnvKYHifXxviqeURkuv1luxgwTH+KYCEk5omKgPvfnoO46d60cVohSFPUCwFWSgXn3OiUUcnYyG9XvUCTuUTO6Dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CkeH3OKgOTWiK5puu7r814u95IMT/mfUtXTohKPaDaQ=;
 b=HzwquWuMRCpDVEIK8Bfi7D9PTkQ8UpIoliAvVFtYVVynlcv7/IIrt9ZmtU4LDX0uJkrtSWEptgIw9zpmp5p+3vQUqgcqPD1TCiDowLtF+c+htlQND4gxHfeQUhNUHSW99LCYVU63noQcpBbPUvvyFjN9iZwmaPBDG4zcwlq4tqrvCkSlBBDGla78tC3xRLup1wZRK8PSvG34nX3a3pwPPht810ECFjxzAheUTxcS59bpJzOBTMXxHE+ojszYvAEwPwQGFUFIKURiDxvZO0CdOWttXMbzOFK/m8sDpISFthyVdbaGRFJEGEfLfmXg+Og/SuT8fX/ouLkJ4bTDavsWCQ==
Received: from IA1PR12MB6353.namprd12.prod.outlook.com (2603:10b6:208:3e3::9)
 by PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Tue, 10 Jan
 2023 16:16:43 +0000
Received: from IA1PR12MB6353.namprd12.prod.outlook.com
 ([fe80::9d53:4213:d937:514e]) by IA1PR12MB6353.namprd12.prod.outlook.com
 ([fe80::9d53:4213:d937:514e%7]) with mapi id 15.20.5986.018; Tue, 10 Jan 2023
 16:16:43 +0000
From:   Emeel Hakim <ehakim@nvidia.com>
To:     Antoine Tenart <atenart@kernel.org>,
        Sabrina Dubroca <sd@queasysnail.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>
Subject: RE: [PATCH net-next v7 1/2] macsec: add support for
 IFLA_MACSEC_OFFLOAD in macsec_changelink
Thread-Topic: [PATCH net-next v7 1/2] macsec: add support for
 IFLA_MACSEC_OFFLOAD in macsec_changelink
Thread-Index: AQHZJAhJyueBLm2iTkmPls9erLR5/66WMhYAgAElHICAACGygIAANViAgAAnILA=
Date:   Tue, 10 Jan 2023 16:16:43 +0000
Message-ID: <IA1PR12MB635353E467A1BE267076D269ABFF9@IA1PR12MB6353.namprd12.prod.outlook.com>
References: <20230109085557.10633-1-ehakim@nvidia.com>
 <20230109085557.10633-2-ehakim@nvidia.com> <Y7wvWOZYL1t7duV/@hog>
 <167334021775.17820.2386827809582589477@kwain.local> <Y71BfSFAtZJoker5@hog>
 <167335890996.17820.293620523946399247@kwain.local>
In-Reply-To: <167335890996.17820.293620523946399247@kwain.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA1PR12MB6353:EE_|PH0PR12MB5481:EE_
x-ms-office365-filtering-correlation-id: 39b9898b-c361-4616-4259-08daf3261025
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: V5YIGUGtZweVVpB9mN/xf/J39ackJ5gaqj6b+OLT/cOuoG0/4DPDaSAS7MQW2WJMRa+Zuj67oQ+pFYAWPgl1gkJQUHSEzOyYNmwoc7sFEtXZrZNAEMNqROci8YB7I5C9sy6CH31MtSEmsqSylZqMnfBJYIL+bIyXuaoHsxJeFXC0ryoBNXxHP+AzjKpf0zpB6k5Ni1bzyNZlAtnvX41tLVR2jOWid9afdbyglMZ2ekJwv5Wu9/H/WCEMnDyx7KXYDEFCxqE5PYQ/wQ++f9qW/7zoWe7ksDymlCFDEBCoUH7My0BS7u0i/ai/1cHS2AIhzNRcG+7xVRCimd7xszrpAq3+Q+6D+FLTFEg/lHDZuYEdW3H0pG4rcMZeM7jZjuR79MmbSxOOe6JMX3tVQaRa9HdwlPkB9kI+BERicfb2lbLJZwwwtTiL6Xl5INtCd1ySBz1hJSVz9uORnGQz6CMLQ7GDKuC2K2fXV+7ZxwL0ltj9b0MdeMcOt51ge4zPY2Rij8dirFjCunftS41UvYiBSqH9wf2w08crqhYY7YOHVZYXH3y1MIkpPJLZBd6rB0JQILdhgD69xquM1pT44kbVEzp50Z584AHDUCmHRpnbdlxzyMAV9SLqcAkXyolrzjl2sbLbRy6i5H7MnKvkSnYrLcj97iFsAXahyZZHNaET9f82/l4cleT0/VGKc+WAT6tQ5IJqHpFVOtECA/3NHXGYSg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6353.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(396003)(346002)(376002)(366004)(451199015)(52536014)(66946007)(41300700001)(2906002)(8936002)(5660300002)(8676002)(66476007)(66446008)(76116006)(66556008)(64756008)(316002)(7696005)(71200400001)(54906003)(110136005)(478600001)(53546011)(6506007)(33656002)(186003)(4326008)(55016003)(26005)(9686003)(83380400001)(86362001)(38100700002)(122000001)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aFY1QTZ3Z0JZRUdNa1JESitmQjRScldpTFp5QkhiL3N2MWNkOVNJdURQSEk4?=
 =?utf-8?B?TndvcnBsYWk1UGh5aXVLcXlEcG5tZGdIVTJLckd6ZVgvMFZveE1kcVFwSy9k?=
 =?utf-8?B?cS9ocE9QM25uY0FaY29MRDN4a3BuN09vRndRcmlNeGlreEVTVDM4U2Y2eDY0?=
 =?utf-8?B?bFNKczF3ejQ1MjVGbkdmS0w0MStWTDJnTGVFSk10RnUySXdQNTRoOXZyM1Z0?=
 =?utf-8?B?QkRqK25KNHlRUnl2b0xCcUUzb3FKOWdHVHhHSW0xZnluNGhsRlZwN1B3dHp0?=
 =?utf-8?B?ZmFTZDdWNFI2TXplMzRjUnM0Sk8rWFZqQkZYZGxDb3dMMTZOVXlzQ3YrcnlK?=
 =?utf-8?B?eEx2YjJKT3VMVW5IR0g0elNCZjk4LzBSSjBPMENYMC9EKzJUVjN3NjhHaTBP?=
 =?utf-8?B?TkcwZmtpNVgzSElRdFQydGFXOEwxVVFxYXN6ZnBEczMwQ3gwck1WcndrTEQx?=
 =?utf-8?B?VVlLSWpVT3l1eEh2OFgrbUo0NXR4N0NMbUtSWFJzTi83bkRuY05tSTBPUlJr?=
 =?utf-8?B?MHJ2UDJUSFkxRnBhVkw4VWJ3dzAwMjFGd21nWmg1aHhncGF2YkJDTXI3MGNN?=
 =?utf-8?B?ZHVyMmZ1VkloQks3WG5zc0k3TUFITUVMQTJTZjBac2lRRjlaK1ZXMVZUSDlO?=
 =?utf-8?B?WDZrU1IrU0htWW1EWWF0NVJLQUZ5QVA0TTJ6M3JwWHdPMHBEV3NqbGhqRXor?=
 =?utf-8?B?dHJlRHRzalVZRUpxNFJUTlRtZFNsSmFFcjcyZmhLL3pGd0kzMllDdC82VUh3?=
 =?utf-8?B?czRzNnQzVHhzTXhtazgvU05laFVldnJIV3dDaVF6V2ZnbnBUM1FvSG0zdmV4?=
 =?utf-8?B?TStlRXFnbmR0SFh2NWdudXZLdnFMaFZCcElRbXEyc3o5VDNsVCt0Y3g4em9Y?=
 =?utf-8?B?aUJuMmZvY2ZsY3FhN08xeUtLVklDN3JweVQ0blpNcUZlajBXbVltRSt4dTJC?=
 =?utf-8?B?T2VNRU04MDhLYlEzVTFlK1pJcjhFcXdNTnltVGtQQm80NXJlRk5NVzY4M3By?=
 =?utf-8?B?UEozLzU5RmpNYUlCSzBBM0VqSTNpeVh4clR2THU5NTJWSlRMQU9lWkk4bm1u?=
 =?utf-8?B?SUkvZDRZYjBOSzFIalk4cjllUzJWS0lZOEVMVU9XNzUvRHNMaHpUMWR0NFhJ?=
 =?utf-8?B?K2VsM0tGWmNHSlJTWWlTK1J5UTczUm9HUm5hSkdPM2ljRWhRT29oR05nWlM3?=
 =?utf-8?B?YlJ2cFhGYW1kYitlcS9BOEhvVmR0a1RuWmtQWHVHNWZZa2FiNDBka0RhRWVw?=
 =?utf-8?B?RTVQZEhpbWdYZklpaVd1REZNV2dWd0JkWWxHc1huY3dsdmlSbG1PSmdZcThK?=
 =?utf-8?B?T3FXTW14R2FuNXpQTmVkVDJEVFQyWmU3aWluRUgwLzRsaFpOVTNYdFQwdHls?=
 =?utf-8?B?MGg2MW5YSkJqeUNaakFHZDR2SFQxeHZWUmJVNzI4UEs1STZIMi8yV1ljQ2V6?=
 =?utf-8?B?cmFjZzZFdGFpelZENlh4bG1BSFIxeDMvYXpnekJOTE8vVUtnRTRoTFlHemlZ?=
 =?utf-8?B?U1VzWDlSalFCZmpkdEowYTdmS2JWL0MveFljN3I3RWtZVlhOei94RW5EQ2NI?=
 =?utf-8?B?dkZhREdMMU91WFppNklxZk1LZmFtQy9FR0Z0QmlkMjJ0dFliZHNzaDk3SVVZ?=
 =?utf-8?B?WkZrNTVqMUNMRCtGQVJpYyt4djFYdWM2L0Q5dTM1enJkV0thSnJSVUN2emhE?=
 =?utf-8?B?MTNIOVFtTm00WFE0YVFZcGZsdTRUVGcrTXJham5Hd2lFU3NUSjIzdExIaHdr?=
 =?utf-8?B?cm1oYVNQUDZOektVc2IrSmExeWlFKy9tUWZWWG55WWVSWVc3MEs1MisrdjlO?=
 =?utf-8?B?aTByemVmanpFbGRqR0NYL3lDVEVMU2FKMkxUUHk2MFlWUEdzKzRQVlYxVGl2?=
 =?utf-8?B?SkF3emh1NzVaeEh1WFFFWVhTdXhUaC9XRFdjcXdDaHk1S3dERCtkazJWTzM1?=
 =?utf-8?B?d3Q1NmVFT1A5bmhRcVY5QjlKWnNCTitVcm96V00rM2NoOVNBWGh2amJzTUl4?=
 =?utf-8?B?WjVXU0d2ZitTNkZ4NHN1aVEwWTUvREpKN25WM3FsaDBWM0VkOXdHdmVwa3Vu?=
 =?utf-8?B?MytIaE1lbWI2RHRrQUF3Qm1xR0Y0amFpbExPc0VHVTdGYkx0RDZDMko0TTdU?=
 =?utf-8?Q?gSYDOLHO4dlS/p3gP27PK1FM3?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6353.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39b9898b-c361-4616-4259-08daf3261025
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2023 16:16:43.0905
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: G9hgpAVbx8hX4+p0T2GgJjCXb8rMVBqAyPH0ZNQu66CjBNOeWB8id7qlRRo/MTBSiELxsVYGQsy9loE1VMKRUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5481
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQW50b2luZSBUZW5hcnQg
PGF0ZW5hcnRAa2VybmVsLm9yZz4NCj4gU2VudDogVHVlc2RheSwgMTAgSmFudWFyeSAyMDIzIDE1
OjU1DQo+IFRvOiBTYWJyaW5hIER1YnJvY2EgPHNkQHF1ZWFzeXNuYWlsLm5ldD4NCj4gQ2M6IEVt
ZWVsIEhha2ltIDxlaGFraW1AbnZpZGlhLmNvbT47IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IFJh
ZWQgU2FsZW0NCj4gPHJhZWRzQG52aWRpYS5jb20+OyBkYXZlbUBkYXZlbWxvZnQubmV0OyBlZHVt
YXpldEBnb29nbGUuY29tOw0KPiBrdWJhQGtlcm5lbC5vcmc7IHBhYmVuaUByZWRoYXQuY29tDQo+
IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0LW5leHQgdjcgMS8yXSBtYWNzZWM6IGFkZCBzdXBwb3J0
IGZvcg0KPiBJRkxBX01BQ1NFQ19PRkZMT0FEIGluIG1hY3NlY19jaGFuZ2VsaW5rDQo+IA0KPiBF
eHRlcm5hbCBlbWFpbDogVXNlIGNhdXRpb24gb3BlbmluZyBsaW5rcyBvciBhdHRhY2htZW50cw0K
PiANCj4gDQo+IFF1b3RpbmcgU2FicmluYSBEdWJyb2NhICgyMDIzLTAxLTEwIDExOjQ0OjEzKQ0K
PiA+IDIwMjMtMDEtMTAsIDA5OjQzOjM3ICswMTAwLCBBbnRvaW5lIFRlbmFydCB3cm90ZToNCj4g
PiA+IFF1b3RpbmcgU2FicmluYSBEdWJyb2NhICgyMDIzLTAxLTA5IDE2OjE0OjMyKQ0KPiA+ID4g
PiAyMDIzLTAxLTA5LCAxMDo1NTo1NiArMDIwMCwgZWhha2ltQG52aWRpYS5jb20gd3JvdGU6DQo+
ID4gPiA+ID4gQEAgLTM4NDAsNiArMzgzNSwxMiBAQCBzdGF0aWMgaW50IG1hY3NlY19jaGFuZ2Vs
aW5rKHN0cnVjdCBuZXRfZGV2aWNlDQo+ICpkZXYsIHN0cnVjdCBubGF0dHIgKnRiW10sDQo+ID4g
PiA+ID4gICAgICAgaWYgKHJldCkNCj4gPiA+ID4gPiAgICAgICAgICAgICAgIGdvdG8gY2xlYW51
cDsNCj4gPiA+ID4gPg0KPiA+ID4gPiA+ICsgICAgIGlmIChkYXRhW0lGTEFfTUFDU0VDX09GRkxP
QURdKSB7DQo+ID4gPiA+ID4gKyAgICAgICAgICAgICByZXQgPSBtYWNzZWNfdXBkYXRlX29mZmxv
YWQoZGV2LA0KPiBubGFfZ2V0X3U4KGRhdGFbSUZMQV9NQUNTRUNfT0ZGTE9BRF0pKTsNCj4gPiA+
ID4gPiArICAgICAgICAgICAgIGlmIChyZXQpDQo+ID4gPiA+ID4gKyAgICAgICAgICAgICAgICAg
ICAgIGdvdG8gY2xlYW51cDsNCj4gPiA+ID4gPiArICAgICB9DQo+ID4gPiA+ID4gKw0KPiA+ID4g
PiA+ICAgICAgIC8qIElmIGgvdyBvZmZsb2FkaW5nIGlzIGF2YWlsYWJsZSwgcHJvcGFnYXRlIHRv
IHRoZSBkZXZpY2UgKi8NCj4gPiA+ID4gPiAgICAgICBpZiAobWFjc2VjX2lzX29mZmxvYWRlZCht
YWNzZWMpKSB7DQo+ID4gPiA+ID4gICAgICAgICAgICAgICBjb25zdCBzdHJ1Y3QgbWFjc2VjX29w
cyAqb3BzOw0KPiA+ID4gPg0KPiA+ID4gPiBUaGVyZSdzIGEgbWlzc2luZyByb2xsYmFjayBvZiB0
aGUgb2ZmbG9hZGluZyBzdGF0dXMgaW4gdGhlDQo+ID4gPiA+IChwcm9iYWJseSBxdWl0ZSB1bmxp
a2VseSkgY2FzZSB0aGF0IG1kb191cGRfc2VjeSBmYWlscywgbm8/IFdlDQo+ID4gPiA+IGNhbid0
IGZhaWwgbWFjc2VjX2dldF9vcHMgYmVjYXVzZSBtYWNzZWNfdXBkYXRlX29mZmxvYWQgd291bGQg
aGF2ZQ0KPiA+ID4gPiBmYWlsZWQgYWxyZWFkeSwgYnV0IEkgZ3Vlc3MgdGhlIGRyaXZlciBjb3Vs
ZCBmYWlsIGluIG1kb191cGRfc2VjeSwNCj4gPiA+ID4gYW5kIHRoZW4gImdvdG8gY2xlYW51cCIg
ZG9lc24ndCByZXN0b3JlIHRoZSBvZmZsb2FkaW5nIHN0YXRlLg0KPiA+ID4gPiBTb3JyeSBJIGRp
ZG4ndCBub3RpY2UgdGhpcyBlYXJsaWVyLg0KPiA+ID4gPg0KPiA+ID4gPiBJbiBjYXNlIHRoZSBJ
RkxBX01BQ1NFQ19PRkZMT0FEIGF0dHJpYnV0ZSBpcyBwcm92aWRlZCBhbmQgd2UncmUNCj4gPiA+
ID4gZW5hYmxpbmcgb2ZmbG9hZCwgd2UgYWxzbyBlbmQgdXAgY2FsbGluZyB0aGUgZHJpdmVyJ3MN
Cj4gPiA+ID4gbWRvX2FkZF9zZWN5LCBhbmQgdGhlbiBpbW1lZGlhdGVseSBhZnRlcndhcmRzIG1k
b191cGRfc2VjeSwgd2hpY2gNCj4gPiA+ID4gcHJvYmFibHkgZG9lc24ndCBtYWtlIG11Y2ggc2Vu
c2UuDQo+ID4gPiA+DQo+ID4gPiA+IE1heWJlIHdlIGNvdWxkIHR1cm4gdGhhdCBpbnRvOg0KPiA+
ID4gPg0KPiA+ID4gPiAgICAgaWYgKGRhdGFbSUZMQV9NQUNTRUNfT0ZGTE9BRF0pIHsNCj4gPiA+
DQo+ID4gPiBJZiBkYXRhW0lGTEFfTUFDU0VDX09GRkxPQURdIGlzIHByb3ZpZGVkIGJ1dCBkb2Vz
bid0IGNoYW5nZSB0aGUNCj4gPiA+IG9mZmxvYWRpbmcgc3RhdGUsIHRoZW4gbWFjc2VjX3VwZGF0
ZV9vZmZsb2FkIHdpbGwgcmV0dXJuIGVhcmx5IGFuZA0KPiA+ID4gbWRvX3VwZF9zZWN5IHdvbid0
IGJlIGNhbGxlZC4NCj4gPg0KPiA+IE91Y2gsIHRoYW5rcyBmb3IgY2F0Y2hpbmcgdGhpcy4NCj4g
Pg0KPiA+ID4NCj4gPiA+ID4gICAgICAgICAuLi4gbWFjc2VjX3VwZGF0ZV9vZmZsb2FkDQo+ID4g
PiA+ICAgICB9IGVsc2UgaWYgKG1hY3NlY19pc19vZmZsb2FkZWQobWFjc2VjKSkgew0KPiA+ID4g
PiAgICAgICAgIC8qIElmIGgvdyBvZmZsb2FkaW5nIGlzIGF2YWlsYWJsZSwgcHJvcGFnYXRlIHRv
IHRoZSBkZXZpY2UgKi8NCj4gPiA+ID4gICAgICAgICAuLi4gbWRvX3VwZF9zZWN5DQo+ID4gPiA+
ICAgICB9DQo+ID4gPiA+DQo+ID4gPiA+IEFudG9pbmUsIGRvZXMgdGhhdCBsb29rIHJlYXNvbmFi
bGUgdG8geW91Pw0KPiA+ID4NCj4gPiA+IEJ1dCB5ZXMgSSBhZ3JlZSB3ZSBjYW4gaW1wcm92ZSB0
aGUgbG9naWMuIE1heWJlIHNvbWV0aGluZyBsaWtlOg0KPiA+ID4NCj4gPiA+ICAgcHJldl9vZmZs
b2FkID0gbWFjc2VjLT5vZmZsb2FkOw0KPiA+ID4gICBvZmZsb2FkID0gZGF0YVtJRkxBX01BQ1NF
Q19PRkZMT0FEXTsNCj4gPg0KPiA+IFRoYXQgbmVlZHMgdG8gYmUgdW5kZXIgaWYgKGRhdGFbSUZM
QV9NQUNTRUNfT0ZGTE9BRF0pIGFuZCB0aGVuIHRoZQ0KPiA+IHJlc3QgZ2V0cyBhIGJpdCBtZXNz
eS4NCj4gPg0KPiA+ID4NCj4gPiA+ICAgaWYgKHByZXZfb2ZmbG9hZCAhPSBvZmZsb2FkKSB7DQo+
ID4gPiAgICAgICBtYWNzZWNfdXBkYXRlX29mZmxvYWQoLi4uKQ0KPiA+ID4gICB9IGVsc2UgaWYg
KG1hY3NlY19pc19vZmZsb2FkZWQobWFjc2VjKSkgew0KPiA+ID4gICAgICAgLi4uDQo+ID4gPiAg
ICAgICBwcmV2X29mZmxvYWQgY2FuIGJlIHVzZWQgdG8gcmVzdG9yZSB0aGUgb2ZmbG9hZGluZyBz
dGF0ZSBvbg0KPiA+ID4gICAgICAgZmFpbHVyZSBoZXJlLg0KPiA+ID4gICB9DQo+ID4NCj4gPiBX
ZSBhbHNvIGhhdmUgYSBwcmV2ICE9IG5ldyB0ZXN0IGF0IHRoZSBzdGFydCBvZiBtYWNzZWNfdXBk
YXRlX29mZmxvYWQsDQo+ID4gdGhlIGR1cGxpY2F0aW9uIGlzIGEgYml0IHVnbHkuIFdlIGNvdWxk
IG1vdmUgaXQgb3V0IGFuZCB0aGVuIG9ubHkgY2FsbA0KPiA+IG1hY3NlY191cGRhdGVfb2ZmbG9h
ZCB3aGVuIHRoZXJlIGlzIGEgY2hhbmdlIHRvIGRvLCBib3RoIGZyb20NCj4gPiBtYWNzZWNfY2hh
bmdlbGluayBhbmQgbWFjc2VjX3VwZF9vZmZsb2FkLg0KPiANCj4gQWdyZWVkLg0KPiANCj4gPiBT
aW5jZSB3ZSBkb24ndCBuZWVkIHRvIHJlc3RvcmUgaW4gdGhlIHNlY29uZCBicmFuY2gsIGFuZCB3
ZSBjYW4gb25seQ0KPiA+IGZldGNoIElGTEFfTUFDU0VDX09GRkxPQUQgd2hlbiBpdCdzIHByZXNl
bnQsIG1heWJlOg0KPiA+DQo+ID4gICAgIGNoYW5nZSA9IGZhbHNlOw0KPiA+ICAgICBpZiAoZGF0
YVtJRkxBX01BQ1NFQ19PRkZMT0FEXSkgew0KPiA+ICAgICAgICAgb2ZmbG9hZCA9IG5sYV9nZXRf
dTgoZGF0YVtJRkxBX01BQ1NFQ19PRkZMT0FEXSk7DQo+ID4gICAgICAgICBpZiAobWFjc2VjLT5v
ZmZsb2FkICE9IG9mZmxvYWQpIHsNCj4gPiAgICAgICAgICAgICBjaGFuZ2UgPSB0cnVlOw0KPiA+
ICAgICAgICAgICAgIG1hY3NlY191cGRhdGVfb2ZmbG9hZCAuLi5jbGVhbnVwDQo+ID4gICAgICAg
ICB9DQo+ID4gICAgIH0NCj4gPg0KPiA+ICAgICBpZiAoIWNoYW5nZSAmJiBtYWNzZWNfaXNfb2Zm
bG9hZGVkKG1hY3NlYykpIHsNCj4gPiAgICAgICAgIC4uLg0KPiA+ICAgICB9DQo+ID4NCj4gPiBP
ciBsZXQgbWFjc2VjX3VwZGF0ZV9vZmZsb2FkIGRvIHRoZSBtYWNzZWMtPm9mZmxvYWQgIT0gb2Zm
bG9hZCB0ZXN0DQo+ID4gYW5kIHBhc3MgJmNoYW5nZSBzbyB0aGF0IGNoYW5nZWxpbmsgY2FuIGtu
b3cgd2hhdCB0byBkbyBuZXh0Lg0KPiANCj4gRWl0aGVyIHNvbHV0aW9ucyB3b3JrIGZvciBtZS4N
Cg0KQWNrLCBJIHdpbGwgc2VuZCBhIHY4IHdpdGggU2FicmluYSdzIGFwcHJvYWNoIG9mIGNoYW5n
ZSA9IGZhbHNlIC4uLg0KDQo+IFRoYW5rcyENCj4gQW50b2luZQ0KDQpUaGFua3MsDQpFbWVlbA0K
