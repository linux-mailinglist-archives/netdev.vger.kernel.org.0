Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE9366D5BE
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 06:54:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235491AbjAQFyf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 00:54:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235534AbjAQFy3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 00:54:29 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2044.outbound.protection.outlook.com [40.107.21.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8633C227BF;
        Mon, 16 Jan 2023 21:54:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l7TBgdCQEuvEjPKI6tHxWnsU6ftDC4dDPVw5HRR6Y/4Uj7Fm/GdtdL1YyjW9XLRk80jue8B2/eS3jKqw6LtkORzqSO3VrunblvOL59B+yZ3i9QgnFh3GWlOwioPzsyMdWTtW+U9czkBGmmoIJy2SzKu6I+iWgXr+EsH1wEc1/HkOWX4MAsi6b9LzH2KvHWyoKLIlI9LuVbVW5VW7QlK7iXO6z8cvxl5LKR5b9ZM3Rvo5Y9ytAAeu5lUOQ7rtNy8PFqUqLmAk0dvOnw29WrAmHeZvTA4xYqeWWH5a33nEwxhWUY8WDpNPO63/mxUI2G3MzQo8KlbWrMUDRn/a2kbq+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ciz1Mc2uFU7oVfNkfpFtCRQ5Ud3p1cvgW4JT1b9CSdA=;
 b=QvG957nUUL764DnN/LMu2V2+l95K8FZZ5hjMaFCsrmwIzeC6M9WTIy5jcyMLqhF4/g1m2Mhq+hFLq6J6Gdtgtm97lRldQ5NW5MW4CHGFU0r1hNm+dPKVafAjy0x9E9b8rleG+08l6yFw+N3G20AERPI4hcDYsk3STOzGlOaSAAE9gaeSqMtaIOjLrieGZlArk4n1NmseaQlNAiA80F+PYehzqI3CTNmeBMRUQpWZtKBPEt208OVmQ8mKHSpdJyeFrM2Akt1NT8pdX6szuDqYrb/gqzEf23vyCaBlWPDRgYIbb9Y/BY2gWADjBARixigHwmFsWFeha1jzNZi/PfEQUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ciz1Mc2uFU7oVfNkfpFtCRQ5Ud3p1cvgW4JT1b9CSdA=;
 b=TqDPCIxL7Tji/KMwzuKNaNza7gyi5uJDrQf9/Uv2sXYZvoSTHWCYP8CGcpqEwfnhOqgBN8ZkFZnX3U5kqP8pYny0eaYc+PGGeJ190jxULAeAj+5TT5tKGNdu5dT3PF1wD+9Yl4KcRq2ASBBvlFSOyLzLT5OhmySse0++iWHlW80=
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com (2603:10a6:10:24b::13)
 by PAXPR04MB8428.eurprd04.prod.outlook.com (2603:10a6:102:1ce::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Tue, 17 Jan
 2023 05:54:21 +0000
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::5b45:16d:5b45:769f]) by DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::5b45:16d:5b45:769f%5]) with mapi id 15.20.5986.023; Tue, 17 Jan 2023
 05:54:21 +0000
From:   Wei Fang <wei.fang@nxp.com>
To:     Pierluigi Passaro <pierluigi.p@variscite.com>,
        Andrew Lunn <andrew@lunn.ch>
CC:     Pierluigi Passaro <pierluigi.passaro@gmail.com>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "eran.m@variscite.com" <eran.m@variscite.com>,
        Nate Drude <Nate.D@variscite.com>,
        Francesco Ferraro <francesco.f@variscite.com>
Subject: RE: [PATCH v2] net: fec: manage corner deferred probe condition
Thread-Topic: [PATCH v2] net: fec: manage corner deferred probe condition
Thread-Index: AQHZKSmth/GaxUjULU+HlYnwAPdOW66gBiKAgAAHoYCAABs7gIAAlDMAgABv7oCAAFFXgIAAkZzw
Date:   Tue, 17 Jan 2023 05:54:21 +0000
Message-ID: <DB9PR04MB810698A50D6B7FD205E69B1B88C69@DB9PR04MB8106.eurprd04.prod.outlook.com>
References: <20230115213804.26650-1-pierluigi.p@variscite.com>
 <Y8R2kQMwgdgE6Qlp@lunn.ch>
 <CAJ=UCjXvcpV9gAfXv8An-pp=CK8J=sGE_adAoKeNFG1C-sMgJA@mail.gmail.com>
 <Y8STz5eOoSPfkMbU@lunn.ch>
 <AM6PR08MB43761CFA825A9B4A2E68D29EFFC19@AM6PR08MB4376.eurprd08.prod.outlook.com>
 <Y8VuBbINetkFwQzY@lunn.ch>
 <AM6PR08MB437621FD8AE1B6BEDF192958FFC19@AM6PR08MB4376.eurprd08.prod.outlook.com>
In-Reply-To: <AM6PR08MB437621FD8AE1B6BEDF192958FFC19@AM6PR08MB4376.eurprd08.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DB9PR04MB8106:EE_|PAXPR04MB8428:EE_
x-ms-office365-filtering-correlation-id: 588659aa-7e4c-4bdd-068d-08daf84f47a1
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: F4YFxkfq6d64VKwmURHMyi88F1QY5FYtI1U4/ACOx9YjZ15M2wI+udM6PcbxnaIqtFMNBrvRkzJhygp9ynarnSIq8X0jFfhuhWdBIbasHKvElxsGmcfTsRenxAn2diZke4U7BrCV6UiSyj18FSBw8vLqRMGUz9nJV47/jGe4FtvmK0k8Byv3pKqqRvNjaO240CGp8CcgK/Tpr86nOOhKzhfheIRTRU8IhK6TOBheAZI2wC+zI29MnC37W+q6EEiN8vvieKoWV0Vw1pH0VAApaj94nh068ucQbSheO+m8mFWA+pGOd8PsKZWKcB/s3AQLzLDB/sKp8613XUDte36KPeej861ULOuf1gfSymKy1IDwBk95Yzh0mZdwJ0RhikVIKuRa4j448Uj35eFNznI/udP4EpiiJ9qBbwFW5PXD2JL6ol3oEYBDnM/E9FbXXBBx3HdHvBQwTtB9DvjjfvSP+3hIxZlLAqqMAhTQ8rFGTvmM4z7IXWBiM1az6858HjHIOXNhFNMMXeSuYostyqFfmFiMEjx84L0xixAR2iaLK9TwWdr5+O04Vo1XgsHHGPyipng72Gw7dOmwvW7o1gTyow4YyP6CRO/Kups7FE14sZ6iCRPlQyYBEmhmAuPVq/MxiDdo7TYibMAjPIo9Rz/wH8kbRNlHa5ROn86kxq8YqOyNQZqIYt/YQtbUcmfHviqP7zVXFFK61bXTz4/ueG6UwA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8106.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(366004)(346002)(136003)(396003)(451199015)(8676002)(38100700002)(86362001)(38070700005)(64756008)(8936002)(44832011)(66556008)(66476007)(66446008)(66946007)(76116006)(52536014)(55016003)(5660300002)(2906002)(7416002)(4326008)(83380400001)(122000001)(33656002)(478600001)(7696005)(110136005)(54906003)(71200400001)(316002)(41300700001)(53546011)(9686003)(26005)(186003)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Tmk1bVdvcE5OaTNuTFo5WnRjd2xueHM0WmI0WFM3dy9DUVVNZHdsakRvYlNJ?=
 =?utf-8?B?WGkxSzdZYTRsZ05mU29GL3JoKzU4UTFWMjFzdFhZenJWakdHckdaYkt3WnBw?=
 =?utf-8?B?VTF0MnJwaDloTnFqZFlwWWtsQWh4TDFmUXNvMDl4NjNzUURsalBUZDVoczRK?=
 =?utf-8?B?dkFlRHhPYnV4RmdCdlNqRmNxMElwalhENWJDeGl1WFFQc0NyS25SSm1aeFp5?=
 =?utf-8?B?M29TSDFCQkIySjVxSE42ZS9Ib2lFemQ1TDN0U09ra0d5LzlsZGVHQnVmUGxv?=
 =?utf-8?B?SFhZeUdTMnpld1lXRWtFSC9JRURxS1RtY01nd2MwcDQzL3Qrb1FYR3NLT2JJ?=
 =?utf-8?B?cmFTRVhjL1hJVloraWtkTEdSTU9yYi9seVVaUytKRVpDdGw4b3R2Qi9BU25R?=
 =?utf-8?B?N3cyOWFyc2pGckh0cU1CSlNSL3VwUnhhSnFNRE5rcHV0U0VVdDhhVDBaSlAr?=
 =?utf-8?B?SDVyTnMxZTBNOU0zKzlCQlFPRFh1M2N4VlhnT210S3hwSXV0RjVlTlBuTUlu?=
 =?utf-8?B?QitLc2tZcTJuTTRSNnU3MFhrUW5aYUVhMHlkaEhEOTIxUFRqVGhzM2pxci9U?=
 =?utf-8?B?blNwd2R5UTFqSDZqZDlSeGJoT2xhWmhqdHA5SnFib1FZZnVjVHB0UFpUVHFJ?=
 =?utf-8?B?VnFEQXVUOVRsc3dxNG1NODUzNXg4NFh0S0M0clZnRGFCOEtBcDhldlVwanZ5?=
 =?utf-8?B?K0VMUXJtQTJHZ1RQcmhoVjlUbEErRjg3cGxVT2duSTY3SWJ5a1FpbUtVRVJR?=
 =?utf-8?B?Vm44eXl0c3dtWHoxM1J5UWJTaXp4NFlsQmd3TkJxNEtCTCtuUVdkZmM1T1Rj?=
 =?utf-8?B?WUNxamM5WXlaVmVMWEljM0R3dGhRSGlFa0c3WUQ3K3dsWDVJRy9BbFdsMyt4?=
 =?utf-8?B?anlCNFdiU0MrZXpwKzZQblR0bFU4a0YwNUdaQURvZ0J0S3pRZ0lzcUZFazdI?=
 =?utf-8?B?eHRyREdRR3dNd0lxMHQ2TGpaT2htWHNVRDBUbFNCSDlKMkJkQ1psZnFhcEZQ?=
 =?utf-8?B?eGRkYXBNZ2tlN0I1T0JVb1lhMnpxMUlUOGpzOVpFZWVSV2JhMXB4SnBtdEY2?=
 =?utf-8?B?Qnh4MHlKRnM2bHpXSUs1ZVlWUEdnSGRhS1pSTVhKNVk2U3kwdDNaaEVjRmdC?=
 =?utf-8?B?U2I1U0VJc0xvS3VDWDY5WDRKank4M0dmSmFxUXAxZjdwYUc2TTRObW9HWGpj?=
 =?utf-8?B?ZktQZ3FpUFZZekQ1S3U0QVJDMkxLbnZwdTB1OGJWdlAwS2F2TEhKN0ZwSm5N?=
 =?utf-8?B?V1IzdXcveENFdjBmVDQ3VmQzV3JoeTRRc3NITXBqN3RUZGk3OEhzWWxhTDNK?=
 =?utf-8?B?RythcFFGWG9YM0M5TUVTWmdwQmpvaTdBNHlXa3ZNYnRhTFRoQ08yRXBnS0lk?=
 =?utf-8?B?Y3ZKNHpUS0xxRTNWVGlpQTRuaFdRSnBHRWthOW9YUVJFVzhMNGRvTEkwQUdx?=
 =?utf-8?B?L3lib2ZEc042T2ZvVzVBckhvU2V2RWRzVzM5MURiL1VjbktaTCs0dkhZdEpX?=
 =?utf-8?B?OEJZZDJ4emZ0akN3ZHJxMHI0eEJNbCtia0l6TGtGdFhuWERWRllaRTR2enJJ?=
 =?utf-8?B?TE1TNERFN1hTNy9TREE5dmdPSW0xZkxCaUhtVnkzcmtlU3ZSWVEzSGwva3FK?=
 =?utf-8?B?WEJNbDhVZUgwVDd6azduT0hLc25aVmZpYU05ZDNtcGtTYnhMaTdOQ3ZIY2Fr?=
 =?utf-8?B?RzZGOE5Yam5KcWZqVEc1VUdXOUZaTjRqbzBjcWF0aXp2ZnBMdmZvaE1mbnlK?=
 =?utf-8?B?eVg2STBhRDZjaExQOGYzR2tVZmZpOVB4WnMxR1RmSHFCLzVKUGovM3gzTGM0?=
 =?utf-8?B?RE5VYmR5L0hsQktYTTVtbFcwbWZtZzg5RXlZckJ3alhLZXVFZmVrWDJRd3kx?=
 =?utf-8?B?MTc5RHFZMm5DVC81ZFpTTnVGbUVad05HQWJvZVJhLzZidUk1MjF0WGVuVjN0?=
 =?utf-8?B?SGtpTndXNTZFNmRJR1JRZmpmRVF3WkRURkxtTmVjT25yRnpnUWg5VHBpbWQ1?=
 =?utf-8?B?ZlhaU1grMS91VEhwS1VMZlF6dFR3NCtOektLR1dVL0V1RHNPSXJ5dzVhMTVH?=
 =?utf-8?B?YUYrd0V5WGc0M0Q4M1JrN0NaNlZGdy9pQ0FqanNzc01QQmY5QVlBUmUzOGx5?=
 =?utf-8?Q?tnyc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8106.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 588659aa-7e4c-4bdd-068d-08daf84f47a1
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2023 05:54:21.3717
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MO0kIbIKOvx49heTv3PQZwFMTWtRvd7vHiQyyrID791xR5UzT43WyuKX0z7OgsSvizYK+TgVDR8Aj2E945cDNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8428
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBQaWVybHVpZ2kgUGFzc2FybyA8
cGllcmx1aWdpLnBAdmFyaXNjaXRlLmNvbT4NCj4gU2VudDogMjAyM+W5tDHmnIgxN+aXpSA0OjIz
DQo+IFRvOiBBbmRyZXcgTHVubiA8YW5kcmV3QGx1bm4uY2g+DQo+IENjOiBQaWVybHVpZ2kgUGFz
c2FybyA8cGllcmx1aWdpLnBhc3Nhcm9AZ21haWwuY29tPjsgV2VpIEZhbmcNCj4gPHdlaS5mYW5n
QG54cC5jb20+OyBTaGVud2VpIFdhbmcgPHNoZW53ZWkud2FuZ0BueHAuY29tPjsgQ2xhcmsgV2Fu
Zw0KPiA8eGlhb25pbmcud2FuZ0BueHAuY29tPjsgZGwtbGludXgtaW14IDxsaW51eC1pbXhAbnhw
LmNvbT47DQo+IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGVkdW1hemV0QGdvb2dsZS5jb207IGt1YmFA
a2VybmVsLm9yZzsNCj4gcGFiZW5pQHJlZGhhdC5jb207IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7
IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7DQo+IGVyYW4ubUB2YXJpc2NpdGUuY29tOyBO
YXRlIERydWRlIDxOYXRlLkRAdmFyaXNjaXRlLmNvbT47IEZyYW5jZXNjbw0KPiBGZXJyYXJvIDxm
cmFuY2VzY28uZkB2YXJpc2NpdGUuY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIHYyXSBuZXQ6
IGZlYzogbWFuYWdlIGNvcm5lciBkZWZlcnJlZCBwcm9iZSBjb25kaXRpb24NCj4gDQo+IE9uIE1v
biwgSmFuIDE2LCAyMDIzIGF0IDQ6MzIgUE0gQW5kcmV3IEx1bm4gPGFuZHJld0BsdW5uLmNoPiB3
cm90ZToNCj4gPiA+IFRoaXMgaXMgdGhlIHNldHVwIG9mIHRoZSBjb3JuZXIgY2FzZToNCj4gPiA+
IC0gRkVDMCBpcyB0aGUgb3duZXIgb2YgTURJTyBidXMsIGJ1dCBpdHMgb3duIFBIWSByZWx5IG9u
IGEgImRlbGF5ZWQiDQo+ID4gPiBHUElPDQo+ID4gPiAtIEZFQzEgcmVseSBvbiBGRUMwIGZvciBN
RElPIGNvbW11bmljYXRpb25zIFRoZSBzZXF1ZW5jZSBpcw0KPiA+ID4gc29tZXRoaW5nIGxpa2Ug
dGhpcw0KPiA+ID4gLSBGRUMwIHByb2JlIHN0YXJ0LCBidXQgYmVpbmcgdGhlIHJlc2V0IEdQSU8g
ImRlbGF5ZWQiIGl0IHJldHVybg0KPiA+ID4gRVBST0JFX0RFRkVSUkVEDQo+ID4gPiAtIEZFQzEg
aXMgc3VjY2Vzc2Z1bGx5IHByb2JlZDogYmVpbmcgdGhlIE1ESU8gYnVzIHN0aWxsIG5vdCBvd25l
ZCwNCj4gPiA+IHRoZSBkcml2ZXIgYXNzdW1lDQo+ID4gPiDCoCB0aGF0IHRoZSBvd25lcnNoaXAg
bXVzdCBiZSBhc3NpZ25lZCB0byB0aGUgMXN0IG9uZSBzdWNjZXNzZnVsbHkNCj4gPiA+IHByb2Jl
ZCwgYnV0IG5vDQo+ID4gPiDCoCBNRElPIG5vZGUgaXMgYWN0dWFsbHkgcHJlc2VudCBhbmQgbm8g
Y29tbXVuaWNhdGlvbiB0YWtlcyBwbGFjZS4NCj4gPg0KPiA+IFNvIHNlbWFudGljcyBvZiBhIHBo
YW5kbGUgaXMgdGhhdCB5b3UgZXhwZWN0IHdoYXQgaXQgcG9pbnRzIHRvLCB0bw0KPiA+IGV4aXN0
cy4gU28gaWYgcGh5LWhhbmRsZSBwb2ludHMgdG8gYSBQSFksIHdoZW4geW91IGZvbGxvdyB0aGF0
IHBvaW50ZXINCj4gPiBhbmQgZmluZCBpdCBtaXNzaW5nLCB5b3Ugc2hvdWxkIGRlZmVyIHRoZSBw
cm9iZS4gU28gdGhpcyBzdGVwIHNob3VsZA0KPiA+IG5vdCBzdWNjZWVkLg0KPiA+DQo+IEkgYWdy
ZWUgd2l0aCB5b3U6IHRoZSBjaGVjayBpcyBwcmVzZW50LCBidXQgdGhlIGN1cnJlbnQgbG9naWMg
aXMgbm90IGNvbnNpc3RlbnQuDQo+IFdoZW5ldmVyIHRoZSBub2RlIG93bmluZyB0aGUgTURJTyBm
YWlscyB0aGUgcHJvYmUgZHVlIHRvDQo+IEVQUk9CRV9ERUZFUlJFRCwgYWxzbyB0aGUgc2Vjb25k
IG5vZGUgbXVzdCBkZWZlciB0aGUgcHJvYmUsIG90aGVyd2lzZSBubw0KPiBNRElPIGNvbW11bmlj
YXRpb24gaXMgcG9zc2libGUuDQo+IFRoYXQncyB3aHkgdGhlIHBhdGNoIHNldCB0aGUgc3RhdGlj
IHZhcmlhYmxlIHdhaXRfZm9yX21kaW9fYnVzwqB0byB0cmFjayB0aGUNCj4gc3RhdHVzLg0KPiA+
ID4gLSBGRUMwIGlzIHN1Y2Nlc3NmdWxseSBwcm9iZWQsIGJ1dCBNRElPIGJ1cyBpcyBub3cgYXNz
aWduZWQgdG8gRkVDMQ0KPiA+ID4gwqAgYW5kIGNhbm5vdCDCoGFuZCBubyBjb21tdW5pY2F0aW9u
IHRha2VzIHBsYWNlDQo+ID4NCg0KSGF2ZSB5b3UgdGVzdGVkIHRoYXQgdGhpcyBpc3N1ZSBhbHNv
IGV4aXN0cyBvbiB0aGUgbmV0IHRyZWU/IEFjY29yZGluZyB0byB5b3VyDQpkZXNjcmlwdGlvbiwg
SSBzaW11bGF0ZWQgeW91ciBzaXR1YXRpb24gb24gdGhlIG5ldCB0cmVlIGFuZCB0ZXN0ZWQgaXQg
d2l0aCBpbXg2dWwsDQpidXQgdGhlIHByb2JsZW0geW91IG1lbnRpb25lZCBkb2VzIG5vdCBleGlz
dC4gQmVsb3cgaXMgaXMgbXkgdGVzdCBwYXRjaC4NCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0
L2V0aGVybmV0L2ZyZWVzY2FsZS9mZWNfbWFpbi5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJl
ZXNjYWxlL2ZlY19tYWluLmMNCmluZGV4IDY0NGYzYzk2MzczMC4uZTRmNjkzN2NkYzNlIDEwMDY0
NA0KLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2ZlY19tYWluLmMNCisrKyBi
L2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9mZWNfbWFpbi5jDQpAQCAtMjI4NCw2ICsy
Mjg0LDcgQEAgc3RhdGljIGludCBmZWNfZW5ldF9taWlfaW5pdChzdHJ1Y3QgcGxhdGZvcm1fZGV2
aWNlICpwZGV2KQ0KICAgICAgICBpbnQgZXJyID0gLUVOWElPOw0KICAgICAgICB1MzIgbWlpX3Nw
ZWVkLCBob2xkdGltZTsNCiAgICAgICAgdTMyIGJ1c19mcmVxOw0KKyAgICAgICBzdGF0aWMgYm9v
bCB0ZXN0X2ZsYWc7DQoNCiAgICAgICAgLyoNCiAgICAgICAgICogVGhlIGkuTVgyOCBkdWFsIGZl
YyBpbnRlcmZhY2VzIGFyZSBub3QgZXF1YWwuDQpAQCAtMjM4OCw3ICsyMzg5LDEyIEBAIHN0YXRp
YyBpbnQgZmVjX2VuZXRfbWlpX2luaXQoc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldikNCiAg
ICAgICAgZmVwLT5taWlfYnVzLT5wcml2ID0gZmVwOw0KICAgICAgICBmZXAtPm1paV9idXMtPnBh
cmVudCA9ICZwZGV2LT5kZXY7DQoNCi0gICAgICAgZXJyID0gb2ZfbWRpb2J1c19yZWdpc3Rlcihm
ZXAtPm1paV9idXMsIG5vZGUpOw0KKyAgICAgICBpZiAobm9kZSAmJiAhdGVzdF9mbGFnKSB7DQor
ICAgICAgICAgICAgICAgZXJyID0gLUVQUk9CRV9ERUZFUjsNCisgICAgICAgICAgICAgICB0ZXN0
X2ZsYWcgPSB0cnVlOw0KKyAgICAgICB9IGVsc2Ugew0KKyAgICAgICAgICAgICAgIGVyciA9IG9m
X21kaW9idXNfcmVnaXN0ZXIoZmVwLT5taWlfYnVzLCBub2RlKTsNCisgICAgICAgfQ0KICAgICAg
ICBpZiAoZXJyKQ0KICAgICAgICAgICAgICAgIGdvdG8gZXJyX291dF9mcmVlX21kaW9idXM7DQog
ICAgICAgIG9mX25vZGVfcHV0KG5vZGUpOw0KQEAgLTQzNDksOCArNDM1NSw5IEBAIGZlY19wcm9i
ZShzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2KQ0KDQogICAgICAgIC8qIERlY2lkZSB3aGlj
aCBpbnRlcnJ1cHQgbGluZSBpcyB3YWtldXAgY2FwYWJsZSAqLw0KICAgICAgICBmZWNfZW5ldF9n
ZXRfd2FrZXVwX2lycShwZGV2KTsNCi0NCisgICAgICAgZGV2X2luZm8oJnBkZXYtPmRldiwgIltG
RUMgRGVidWddID4+IFN0YXJ0IHJlZ2lzdGVyaW5nIG1paSBidXMhXG4iKTsNCiAgICAgICAgcmV0
ID0gZmVjX2VuZXRfbWlpX2luaXQocGRldik7DQorICAgICAgIGRldl9pbmZvKCZwZGV2LT5kZXYs
ICJbRkVDIERlYnVnXSA+PiBGaW5pc2ggcmVnaXN0ZXJpbmcgbWlpIGJ1cyEgcmV0OiVkXG4iLCBy
ZXQpOw0KICAgICAgICBpZiAocmV0KQ0KICAgICAgICAgICAgICAgIGdvdG8gZmFpbGVkX21paV9p
bml0Ow0KDQpPbiB0aGUgaW14NnVsIHBsYXRmb3JtLCBmZWMxIChldGhlcm5ldEAyMTg4MDAwKSBh
bmQgZmVjMiAoZmVjMjogZXRoZXJuZXRAMjBiNDAwMCkgc2hhcmUNCnRoZSBzYW1lIE1ESU8gYnVz
IGFuZCBleHRlcm5hbCBQSFlzIGNhbiBvbmx5IGJlIGNvbmZpZ3VyZWQgYnkgZmVjMi4gQWZ0ZXIg
YXBwbHlpbmcgdGhlIHRlc3QNCnBhdGNoLCB0aGUgZmVjMiB3aWxsIGJlIGRlbGF5ZWQgdG8gcHJv
YmUsIHRoZSBkZWJ1ZyBsb2cgc2hvd3MgYXMgZm9sbG93cy4NCg0KWyAgICA3LjEwMTU2OV0gZmVj
IDIwYjQwMDAuZXRoZXJuZXQ6IFtGRUMgRGVidWddID4+IFN0YXJ0IHJlZ2lzdGVyaW5nIG1paSBi
dXMhDQpbICAgIDcuMTA5Mzg2XSBmZWMgMjBiNDAwMC5ldGhlcm5ldDogW0ZFQyBEZWJ1Z10gPj4g
RmluaXNoIHJlZ2lzdGVyaW5nIG1paSBidXMhIHJldDotNTE3DQpbICAgIDcuMTUzMDQ1XSBmZWMg
MjE4ODAwMC5ldGhlcm5ldDogW0ZFQyBEZWJ1Z10gPj4gU3RhcnQgcmVnaXN0ZXJpbmcgbWlpIGJ1
cyENClsgICAgNy4zNDMzNzRdIGZlYyAyMTg4MDAwLmV0aGVybmV0OiBbRkVDIERlYnVnXSA+PiBG
aW5pc2ggcmVnaXN0ZXJpbmcgbWlpIGJ1cyEgcmV0OjANClsgICAgOC43NDI5MDldIGZlYyAyMGI0
MDAwLmV0aGVybmV0OiBbRkVDIERlYnVnXSA+PiBTdGFydCByZWdpc3RlcmluZyBtaWkgYnVzIQ0K
WyAgICA4Ljc2OTY1N10gZmVjIDIwYjQwMDAuZXRoZXJuZXQ6IFtGRUMgRGVidWddID4+IEZpbmlz
aCByZWdpc3RlcmluZyBtaWkgYnVzISByZXQ6MA0KDQpBbmQgdGhlIE1ESU8gYnVzIGFsc28gY2Fu
IGJlIGFjY2Vzc2VkLCBwbGVhc2UgcmVmZXIgdG8gdGhlIGZvbGxvd2luZyBsb2cuDQoNCnJvb3RA
aW14NnVsN2Q6fiMgLi9tZGlvIGV0aDAgMQ0KcmVhZCBwaHkgYWRkcjogMHgyICByZWc6IDB4MSAg
IHZhbHVlIDogMHg3ODZkDQoNCnJvb3RAaW14NnVsN2Q6fiMgLi9tZGlvIGV0aDEgMQ0KcmVhZCBw
aHkgYWRkcjogMHgxICByZWc6IDB4MSAgIHZhbHVlIDogMHg3ODZkDQoNClRoZSBvbmx5IGNoYW5n
ZSBpcyB0aGF0IGFmdGVyIGFwcGx5aW5nIHRoZSB0ZXN0IHBhdGNoLCB0aGUgZmVjMSBhbmQgZmVj
MiBleGNoYW5nZSB0aGUgZXRoZXJuZXQNCnBvcnQgbmFtZXMgKGJlZm9yZSBmZWMxOiBldGgxIGZl
YzI6IGV0aDAsIGFmdGVyIGZlYzE6IGV0aDAsIGZlYzI6IGV0aDEpIGJlY2F1c2Ugb2YgdGhlIHNl
cXVlbmNlDQpvZiBwcm9iZS4gT2YgY291cnNlLCB0aGlzIGlzIGp1c3QgYSBzaW11bGF0ZWQgc2l0
dWF0aW9uIG9uIG15IHNpZGUsIG1heWJlIHRoZSBhY3R1YWwgc2l0dWF0aW9uIG9uDQp5b3VyIHNp
ZGUgaXMgZGlmZmVyZW50IGZyb20gdGhpcyB3aGljaCBsZWFkcyB0byBkaWZmZXJlbnQgYmVoYXZp
b3JzLg0KDQpCVFcsIHlvdSdkIGJldHRlciB1c2UgdGhlIC4vc2NyaXB0L2NoZWNrcGF0Y2gucGwg
dG8gY2hlY2sgdGhlIHBhdGNoIGJlZm9yZSBzZW5kaW5nIHRoZSBwYXRjaC4NClRoZXJlIHdlcmUg
c29tZSB3YXJuaW5ncyBhbmQgZXJyb3JzIGluIHRoZSBwYXRjaCBhcyBmb2xsb3dzLg0KDQpXQVJO
SU5HOiAnc3VjY2VzZnVsbHknIG1heSBiZSBtaXNzcGVsbGVkIC0gcGVyaGFwcyAnc3VjY2Vzc2Z1
bGx5Jz8NCiMxNDoNCnN1Y2Nlc2Z1bGx5Lg0KXl5eXl5eXl5eXl4NCg0KRVJST1I6IGRvIG5vdCBp
bml0aWFsaXNlIHN0YXRpY3MgdG8gZmFsc2UNCiMyOTogRklMRTogZHJpdmVycy9uZXQvZXRoZXJu
ZXQvZnJlZXNjYWxlL2ZlY19tYWluLmM6MjI4NzoNCisgICAgICAgc3RhdGljIGJvb2wgd2FpdF9m
b3JfbWRpb19idXMgPSBmYWxzZTsNCg0KdG90YWw6IDEgZXJyb3JzLCAxIHdhcm5pbmdzLCAwIGNo
ZWNrcywgNDAgbGluZXMgY2hlY2tlZA0K
