Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6716D2AEFDA
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 12:43:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726470AbgKKLn0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 06:43:26 -0500
Received: from mail-vi1eur05on2041.outbound.protection.outlook.com ([40.107.21.41]:57185
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726376AbgKKLmQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Nov 2020 06:42:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AYgUA5rYfjdwdcPacwJ7xAG8B/Vdc6ZkC2Gy8qoGTIcBHYkf8ys1jU5QIepXHXAXgCXWh2hsU0wMGH5pPNt6q9b9xcychTiKehiy9iyfLqlCm4nLD2oNVsRqfcfN+ldAoiM2r3se3A8NLDem18J5AXMvOQkXu9UmOTkySTZz1RZtAACrI0xYJeMg+VAIMEgOyYMWZt7o5JTlGZnM6I/9qR88R7IT1+blwax1J7nzPPS5GFhbTgjfZ0ZQmRO7jQ/9ACbHKrtdj4dbZmiID8lltfogpSeqlhnL//oqj/seHwcCxk09EkShLpgyyIRjoI144nu7iHiZ7FKup1yZWcVDzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OVcL8z9aun3V6Liz1m51rJrt3lv2NLoHY0xRG4nF8JY=;
 b=oYScmDYSQdnDmi82tglVLCA79MrStqvSFC1XrEpEyjj506au56DRLbcJXxx2bmglkY8HGtLSLB2XFdg4cu5jNpyS/PjPn4xns7QzXsDxCxsPYgyGqancDqDO5ouknMroOKEb17YgxSFWcm3jESdVh/bNeQaOU0gcHF3k8n7FVjp82+Vs42xZftv8RrYU9Ye9ZCsLwbQQe/qA8/vIX5bV8PoBrYWTtKMx5hrrrLX+LCwpGqltbqdMPVg8QUhzNm47/WFJCWYf5mr/VvcHSELVrAovUp4jjixfzXQbrCzY7fZX4Mv60sva2f8rWOerH5V054HJdqA9kQKW9FEuapiZHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OVcL8z9aun3V6Liz1m51rJrt3lv2NLoHY0xRG4nF8JY=;
 b=g2AuE9pUkrGsdZJZ+VRKu2r3eoIxxyhJ6m0TQ80NsUaCmJtpLSnXGR4kwOjQ8W9J9ofE3ISwwFmiD5clEykLWV3U8MaOVvorSJQfMLiFoZt6xToOyquBBCijTxV5O4FJUuuvpnVud4jYxUvDTqbLCQ7/Yjd35wLj4esqF+CKRsg=
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com (2603:10a6:208:170::28)
 by AM0PR04MB4914.eurprd04.prod.outlook.com (2603:10a6:208:ce::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21; Wed, 11 Nov
 2020 11:42:12 +0000
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::21b9:fda3:719f:f37b]) by AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::21b9:fda3:719f:f37b%3]) with mapi id 15.20.3541.025; Wed, 11 Nov 2020
 11:42:12 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: RE: [PATCH net-next] enetc: Workaround for MDIO register access issue
Thread-Topic: [PATCH net-next] enetc: Workaround for MDIO register access
 issue
Thread-Index: AQHWt3g5LdPswlGN4kqnYf25WlFReKnCAogAgADMbtA=
Date:   Wed, 11 Nov 2020 11:42:11 +0000
Message-ID: <AM0PR04MB67540CD8A93D347066CB05A596E80@AM0PR04MB6754.eurprd04.prod.outlook.com>
References: <20201110154304.30871-1-claudiu.manoil@nxp.com>
 <441a1a9f-1d4b-5ca6-41ce-148e48211e75@gmail.com>
In-Reply-To: <441a1a9f-1d4b-5ca6-41ce-148e48211e75@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.27.120.177]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6da69bd2-af6a-4c8e-6fb7-08d88636d454
x-ms-traffictypediagnostic: AM0PR04MB4914:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR04MB4914F61B19520F373076675196E80@AM0PR04MB4914.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Lf4Jfmf7CXgWkQ6Ioebyb4WjngpFD5DyFIHAAvOiwFwZFsQ04YXfQjVmBvV2s36AxW3Od7MzzOTIYi4pvrsivv33DQddZEOLJJbBfnQda6aUmQ0JfNfHbJ9AhOEnldBhnFSbrxo5qCNm1kWH98d0HYn5LXOxxLLbnsqHIBGACt8GA/E9fSEwLdCtjlCzS1JUzR/OLsUgCe3P/2L11tvhllNrwe1iDbjqcf5PL1i9gdQn6olbGDcSXrcniDQnsrRUxImRMaIqepRC3HZYBSGLbT2+AbJKgAeM/PZEGAEUrLLqab1fx20it1ClHkip8C7d
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6754.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(396003)(376002)(39860400002)(346002)(76116006)(86362001)(316002)(6506007)(110136005)(54906003)(9686003)(33656002)(8676002)(186003)(83380400001)(66556008)(64756008)(66446008)(4326008)(55016002)(7696005)(5660300002)(66946007)(26005)(52536014)(66476007)(478600001)(2906002)(71200400001)(8936002)(44832011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: h3PKvdohKeS3FkmCNH9kegfMh2gyMeuVxjwm9uCBc4JR8d6XNcuxmJ/+aboG6GXx3iWiPTjjuRbsXzZiEeoyiRpNGVs9bOyIgR9Tc3rtak01uAeiIBkNHrD4IrXmJqmXNRSkoOFqpIfT8hSW8xokdLjmh4CDLkENVGi3MLFs2gzKv6Np77wuMymxqfDkKsZ+bG7aDa8BezSyvdTLOzbg2FM46j7c0FNPtq+Jjs098jto79lzfn31FrRIiQXc0iGeDDW5/A3vQD8Edbj/t21gB2Qs/ClAXkHiO9k45nQpDCAMg1TMRfrf3ONzyk3VF2Hjy7ZPjyOwQSaRbur/lBfhUqrTV8x4/Y5Su0EE61fUPkRdUvvqcgYiNzF0ka1z929mzyUz7lqmov6ukrwRCe3Ae3fVQtQyUzBC3Xj0Mr1HizM/CTCWyho7ad2xzD8xBMb/v4mejigFKjdQJkp04u6Q/FHUINCGnA4MROwtaBdq03j81P87LZxD2jDsx8jhuSTMOxkMzHu/oaAqZG0dFJeKGNi9tfK6bqvkKJz10/IqWTNiZVRmeiswvcVMwZSOTYqTZ5eemv5PIrM0drIUb+hSLMFILaexXfO9m8O1/FFPi7Jcz+6KthtprwKK9zFkPZgLZrDVX6vF1YBGE7+WdFQUnw==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6754.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6da69bd2-af6a-4c8e-6fb7-08d88636d454
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2020 11:42:11.5208
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cda2LHOqEIV4swUR53hdiGpSJXGR2df+9lKA3egqUyepWby0KlTfRGIrHBuQ0j7GblSo9QobfefGNo8uq4OxGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4914
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pi0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+RnJvbTogRmxvcmlhbiBGYWluZWxsaSA8Zi5m
YWluZWxsaUBnbWFpbC5jb20+DQo+U2VudDogV2VkbmVzZGF5LCBOb3ZlbWJlciAxMSwgMjAyMCAx
OjI1IEFNDQo+VG86IENsYXVkaXUgTWFub2lsIDxjbGF1ZGl1Lm1hbm9pbEBueHAuY29tPjsgbmV0
ZGV2QHZnZXIua2VybmVsLm9yZw0KPkNjOiBKYWt1YiBLaWNpbnNraSA8a3ViYUBrZXJuZWwub3Jn
PjsgRGF2aWQgUyAuIE1pbGxlcg0KPjxkYXZlbUBkYXZlbWxvZnQubmV0PjsgQWxleGFuZHJ1IE1h
cmdpbmVhbg0KPjxhbGV4YW5kcnUubWFyZ2luZWFuQG54cC5jb20+OyBWbGFkaW1pciBPbHRlYW4N
Cj48dmxhZGltaXIub2x0ZWFuQG54cC5jb20+DQo+U3ViamVjdDogUmU6IFtQQVRDSCBuZXQtbmV4
dF0gZW5ldGM6IFdvcmthcm91bmQgZm9yIE1ESU8gcmVnaXN0ZXIgYWNjZXNzDQo+aXNzdWUNCj4N
Cj5PbiAxMS8xMC8yMCA3OjQzIEFNLCBDbGF1ZGl1IE1hbm9pbCB3cm90ZToNCj4+IEZyb206IEFs
ZXggTWFyZ2luZWFuIDxhbGV4YW5kcnUubWFyZ2luZWFuQG54cC5jb20+DQo+Pg0KPj4gRHVlIHRv
IGEgaGFyZHdhcmUgaXNzdWUsIGFuIGFjY2VzcyB0byBNRElPIHJlZ2lzdGVycw0KPj4gdGhhdCBp
cyBjb25jdXJyZW50IHdpdGggb3RoZXIgRU5FVEMgcmVnaXN0ZXIgYWNjZXNzZXMNCj4+IG1heSBs
ZWFkIHRvIHRoZSBNRElPIGFjY2VzcyBiZWluZyBkcm9wcGVkIG9yIGNvcnJ1cHRlZC4NCj4+IFRo
ZSB3b3JrYXJvdW5kIGludHJvZHVjZXMgbG9ja2luZyBmb3IgYWxsIHJlZ2lzdGVyIGFjY2Vzc2Vz
DQo+PiB0byB0aGUgRU5FVEMgcmVnaXN0ZXIgc3BhY2UuICBUbyByZWR1Y2UgcGVyZm9ybWFuY2Ug
aW1wYWN0LA0KPj4gYSByZWFkZXJzLXdyaXRlcnMgbG9ja2luZyBzY2hlbWUgaGFzIGJlZW4gaW1w
bGVtZW50ZWQuDQo+PiBUaGUgd3JpdGVyIGluIHRoaXMgY2FzZSBpcyB0aGUgTURJTyBhY2Nlc3Mg
Y29kZSAoaXJyZWxldmFudA0KPj4gd2hldGhlciB0aGF0IE1ESU8gYWNjZXNzIGlzIGEgcmVnaXN0
ZXIgcmVhZCBvciB3cml0ZSksIGFuZA0KPj4gdGhlIHJlYWRlciBpcyBhbnkgYWNjZXNzIGNvZGUg
dG8gbm9uLU1ESU8gRU5FVEMgcmVnaXN0ZXJzLg0KPj4gQWxzbywgdGhlIGRhdGFwYXRoIGZ1bmN0
aW9ucyBhY3F1aXJlIHRoZSByZWFkIGxvY2sgZmV3ZXIgdGltZXMNCj4+IGFuZCB1c2UgX2hvdCBh
Y2Nlc3NvcnMuICBBbGwgdGhlIHJlc3Qgb2YgdGhlIGNvZGUgdXNlcyB0aGUgX3dhDQo+PiBhY2Nl
c3NvcnMgd2hpY2ggbG9jayBldmVyeSByZWdpc3RlciBhY2Nlc3MuDQo+DQo+SSBzdXBwb3NlIHRo
aXMgaXMgdGhlIGJlc3QgeW91IGNhbiBkbyBnaXZlbiB0aGUgbmF0dXJlIG9mIHRoZSBidWcsIG15
DQo+b25seSBjb25jZXJuIGlzIHRoYXQgaXQgaXMgZXJyb3IgcHJvbmUgYW5kIG1heSBub3QgcmVh
bGx5IHNjYWxlIG92ZXINCj50aW1lIGFzIHlvdSBzdGFydCBhZGRpbmcgbW9yZSBmZWF0dXJlcy9i
dWcgZml4ZXMgdGhhdCByZXF1aXJlIG1ha2luZw0KPnJlZ2lzdGVyIGFjY2Vzc2VzIGFuZCB1c2Ug
aW5jb3JyZWN0bHkgX2hvdCBpbiBhIGNvbnRleHQgd2hlcmUgdGhlDQo+cmVhZGVyJ3MgbG9jayBp
cyBub3QgYWNxdWlyZWQuDQoNCkFic29sdXRlbHksIG1heWJlIEkgY2FuIHVzZSBsb2NrZGVwIHRv
IGluc3VyZSBjb3JyZWN0bmVzcy4gSSBzdGFydGVkDQpsb29raW5nIGludG8gdGhpcy4gVGhhbmtz
Lg0K
