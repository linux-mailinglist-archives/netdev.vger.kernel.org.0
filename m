Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB1E689C1B
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 15:47:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232636AbjBCOrR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 09:47:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231889AbjBCOrQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 09:47:16 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2043.outbound.protection.outlook.com [40.107.7.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5DAAD7
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 06:47:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CQl7F45m90jzgFbTvJRsUoplI/AAlbhHVwg6NS1+Nzif+ie3PLV/zE3wneeP6WsMoCQS3Wa/EQxVsLMPluvG9daTIAj/pv0Oy6ZsgQKMMGFV5Lox0jj4lrt48OEW0X8xertEX8C3KCpKsV5nxIuKY5tTF0HQUhxC0vE3mXAD3sIlqwEpJBy7xETMtpTVwGQisvg7IiiLzMYNF/NrG0JIo2bsXg2XnIcBIvZ2G5uKwUCqP1h79S7PObc5PlMuFv25FfwZtipDiEHaHVj1Kz97Bhf8XLd1ehLdfhpbyEW+gOjerYEoCR9muUFL/GYBVIjYDsPzd1ao3UQoxaxcgCiAVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7f51elJnJDY5i3/2OEl5vumqXbT2Z7BbHDDyblIzgiI=;
 b=b4l7vPJqa6NCEuusAoQD2pbcWqt4JhYqO9cPJJHAiB3hMkuVMBa6/mBCO68ArqMJuZcvHfhG7rHv/6PxrSakeEBqOkKb6vR6JX5nUmvnUkWA58p4kxr/R4TYQTiEylsuP1iRmfY7nUlUixEHXBB0IBrM/q5ZsUi90B8BTwAV4CZXDvAJhBPQ4cQc+Itd5BwHjKLsO8uEEqN2bpo5QcUB+u/ZnBsdsEDN5C2fyJ1Omxh0C4FrgLViO6q1vPDF40TcDHbbYYbPG3QBvGIE+WPriFA9sdqSSBrtBp1V8paln6Eyg77ktcGEkrM9Rqk3k1T6CT9qeSlbP03zt4rZwM43Ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=siemens.com; dmarc=pass action=none header.from=siemens.com;
 dkim=pass header.d=siemens.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7f51elJnJDY5i3/2OEl5vumqXbT2Z7BbHDDyblIzgiI=;
 b=Z0xtreDKGGv+rNAWi/Pop12dIAiwBsHb8Pxv+QAB/tesr+i3D4JycAXoFDMzU3MaxZyvVUofK7uFVBXgMqJIlBF/hBl1UBdZWZMHuyqgOFQ+Cw2MelQ1PX1Dmgt6AZw5wiD9EBiCF8U7gbNB/YhZWKQ5AlriPnH3neFB/QNwmLDcOjADiiut0LibuYkN6DvWebmZplq6ZG+LopWSsNmpxIE85XGyVTDXgxj55E2wcJfZGHXOb46ZOTvfUVH3gSdzYOY7UEg7Mja9AHMxA2RLCG5xpPKwHA4G1Amn54xuG1vCaFHP+fepCCOi8DEGyQTSYaUsAPLUxkoqlc+9shCc7Q==
Received: from DB8PR10MB3977.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:138::9)
 by DB8PR10MB3941.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:162::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.28; Fri, 3 Feb
 2023 14:47:11 +0000
Received: from DB8PR10MB3977.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8ab5:2969:2854:63f0]) by DB8PR10MB3977.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8ab5:2969:2854:63f0%8]) with mapi id 15.20.6064.029; Fri, 3 Feb 2023
 14:47:11 +0000
From:   "Valek, Andrej" <andrej.valek@siemens.com>
To:     "andrew@lunn.ch" <andrew@lunn.ch>
CC:     "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: DSA mv88e6xxx_probe
Thread-Topic: DSA mv88e6xxx_probe
Thread-Index: AQHZNxmfDlWccw5bT0qZPgjeOkJESa69P8iAgAAOzgA=
Date:   Fri, 3 Feb 2023 14:47:11 +0000
Message-ID: <3669ddc5bead14b0d400c92adb8f95850ef4ec1b.camel@siemens.com>
References: <cf6fb63cdce40105c5247cdbcb64c1729e19d04a.camel@siemens.com>
         <Y9vfLYtio1fbZvfW@lunn.ch>
         <af64afe5fee14cc373511acfa5a9b927516c4d66.camel@siemens.com>
         <Y9v8fBxpO19jr9+9@lunn.ch>
         <05f695cd76ffcc885e6ea70c58d0a07dbc48a341.camel@siemens.com>
         <Y90SA/8RzaRCvna8@lunn.ch>
In-Reply-To: <Y90SA/8RzaRCvna8@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.3 (3.46.3-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=siemens.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DB8PR10MB3977:EE_|DB8PR10MB3941:EE_
x-ms-office365-filtering-correlation-id: a292dfce-b36e-4a76-f6c8-08db05f58859
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: llpA7CJ1lzNvgvnzXUSofiCHcmo4F1ORxVkl5hRl+jSiHQeV+tOTMv7VMIcvcXOkOeb8E7nLvWEzXv7pF0qu//99EYW3tXDSa+kKO4+qWfmK0D2cwyw92eBP1r65kUiXUC6s+SBec/lzZ9HunABZnMlVneb6k8l5oXmFfzLqlb6rn+i/cIY28YklNx362ABPtOKZIV9IeOYe5AwmK91bTJbabFIAlAgjKKzurkRr6oU1iJ6Nqtr6K0sSZ1LNzN669rry+9Z8V4/mneed1UHDeJAUOi2MGM3wzZSDFtE7c04bKlfaUAuN7o5lJ1SlJB+7cjJbEmv3Ez+Vw+vOCygYoKPJOkgqQQPbfC+fHcOFc11Fl7vw83tNLh37Qhz5VtjSxD3wW+gBDn0RuebqrXzqHoDXlaTI2DV98WXzr9OLmB2HDq1GJb7jBC6KnnoUFYKhyXPZTAIfnKrkEUK1cDZMSjvM5/UHrAeGhGAXgdBQSwsDQJ2viSy7tB9Dve4Y3Xz+9+WiZbeIVcMFua9m0NdXx/d6ovxl2W05nB/TldXvkI1AjFxgsiqFA+tLVv0Jn8Nx2/ReBRbwU20fWv8BVjTqI9FfoCO3QNoPQvf4ki5gfSAvoJa8RWGeKvDkU8noYv2gthxIyGK7deK4xwplnW+osDtdEpLAJhPposT3NYB5ynpCHzUhPYki8bFINrqafQY8xnlHEfEY3etjx9gwofKSrJdVh4RjYsZOhYV2ZmK0IKw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR10MB3977.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(136003)(376002)(396003)(39860400002)(451199018)(5660300002)(38070700005)(2616005)(86362001)(122000001)(82960400001)(38100700002)(71200400001)(2906002)(83380400001)(6506007)(186003)(6512007)(26005)(6486002)(966005)(36756003)(478600001)(76116006)(66946007)(66556008)(66476007)(316002)(41300700001)(64756008)(66446008)(91956017)(4326008)(54906003)(6916009)(8676002)(7116003)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZDVzTk1xUGtQaGNMdERKMlFGZUJ3Q0d5SmtzdTBQbThnZGpOZ1M1dDltSmZS?=
 =?utf-8?B?ajY2UFRmUWdXR3pRd3dQM0RkanRXUTJqQTl5cHNoMDJodVl4Y2s5cDgvQVkr?=
 =?utf-8?B?Vi9hQkNvejVTdEVPYVgzT2IvVk04alk4RFdES294R3dqazhjckM5S1lyUGEw?=
 =?utf-8?B?S01VeTlmMVNoMnRHSXZkSWZwVVk4RkM4ZklHWGVpRk4raHBqSnBva2xReXJW?=
 =?utf-8?B?QTBraTlzd2pocVN0d09oMjZ1b0ZvYTJ2Qk5RODZmUS9uMVRldjFLQmNZZXhO?=
 =?utf-8?B?eHlVK0lpOVRZQm9FWWxiTCtBWG5oN1hsb0RBTGZTRW5MdEFaTEEwcHNFcGFt?=
 =?utf-8?B?WXFUZzZQV09hOS8zQ0o0RlBJS2FRbTAyeGphTHdjQkpGN3U2dERWMkpnMzIr?=
 =?utf-8?B?ZmtRenc4RG5ybzBLOXZITmV6ZUxQVDFJWGJzV3hRZ3dqNGREQVNaTW1jSHJB?=
 =?utf-8?B?ZU5MRHdKVjF3TFIvRlNSbDBsbVYweUZmU1pyT0lhNWtuSHhXRERYUmZpUVp0?=
 =?utf-8?B?UkFpYXBlUHU5WFdNMHN2bUxpWjRLYzZLVjVjU3BodTZpT0RQWkdSK05rMHRw?=
 =?utf-8?B?dVpNYVh1cGM2TGxtSkwrNEdEdytUQVo1VjBzajdxLzZPaXkrcVJpbU1BRlJm?=
 =?utf-8?B?cmFGWVBkcVBOV1JWc0FldE5PUVBVL0xyeVd3Ti9tbzVzd0xadzFSUkRObEpD?=
 =?utf-8?B?TXNQYVJzQlk4K2NTVXEwSStOdWd3WldSajBRSzdiVFU2bFRzM3ZNM0grbVk3?=
 =?utf-8?B?cnRBWmR3UEs2WUNrMGZPb0FQZ0tLdTh4RjArOEo1MFo5RGg1cXJkc0N6dlFQ?=
 =?utf-8?B?cy9YQjg3d0ZkWUtsa2RjRDdVSUUrVnNSZUN4SjZCa0JpMUtXRnpvTlkvZllX?=
 =?utf-8?B?VXhRNVp0OVRBRVQ0TnJ1WTJjNllSUUc3amNHM0VjRTIycDJLWktWN2R6Uy9X?=
 =?utf-8?B?K2pwUXZDNkxSa01mYnhBbDlOOVN3VEpZMnlvUEloMnhsNk9GRm9mUzBMQUZJ?=
 =?utf-8?B?Q2VQbUk4TjdYWDVMeDBadTBRTUpzRWNlM1VJcXBPaEZhNFJ2R0s4TXBwSnd3?=
 =?utf-8?B?Zi9Wa1QrV3NUbmdMSGhBbEp1TU4rS3ZhTjZkcnhZRmNSek1uQ21KbTdyU2Nt?=
 =?utf-8?B?RHUvVTZvOUpiVS9sekl4QmppQUtXNUpuNkRTQkx2TVI1OFlVV3ZUMEFGblR4?=
 =?utf-8?B?UmZxS0ZvN1R1RC9mRk9XSlhOMW9WVmlBcy80cDVzMW9ZUE1HWWlvdTFZMzRx?=
 =?utf-8?B?bldEQjBFSjlmUWJydWY2MkFHek5rYUpaME4wRmNlSGZhNHMwQVkvc3psclB0?=
 =?utf-8?B?NGtIWWpQUERsNUo4dmIvZ05wL0orNHZJTkp3c3FPaEpCdTlMSnBudC9kYzlt?=
 =?utf-8?B?QnAwd2NYS0w3Tm84RG5Wek50ZDlSbUczZ1BJSm9KeHBKOWtSOUVmOExPell6?=
 =?utf-8?B?WFFkbzloWW91SWt3Nit1RSt4SDhnRnN3c1Q3UUdEbkkxU0g5TUxXR20rN2k2?=
 =?utf-8?B?RGp4N3ErTFhTVHNweTF4S2VPYkk2dXhvMFRPSHJaMHkyaWFaNFdiajRwS0JX?=
 =?utf-8?B?UWJWK2VTNmFiM1VaSi8xUHE0SHViOVZkb3lJM3N0N29meTdjZnJXeXlFVTFI?=
 =?utf-8?B?Uk5TcEtpTElpdCtjRkR6SE05UVFLK2I0QkE2MHhBblpuT2F6L1ExczA3Rysv?=
 =?utf-8?B?R1J1ZXpwQUtabWlocWFXeXBwWUhLVEZDSnFWZXNhZHpnSGJibDJqemtkb1hq?=
 =?utf-8?B?bGtzSWo0Z0oybmxMMmFwSHdRK1NZZEFrSnYwTmd0Nk5JMmtFYTVLODlwUUoz?=
 =?utf-8?B?OFFpZFIrVDBLN0NXQXlRak1ob1V5WS9ybnhYMjZMWlJLanQvMWhlcFEvR1do?=
 =?utf-8?B?VldOb0dhVCt0NWI0UHNDNGFYOUg0Q3gxY09oQXA1WXpMRVhreFBRcFFBNVc2?=
 =?utf-8?B?V2Q3TTB1VGlHNlR4QndJYjUraC9ITGpLUDZvaTJMUmFTMGRHdk9tZXhwQWVz?=
 =?utf-8?B?SmMyUTMvNnNUZmE4bG5kZ05uYVN2ZzZaZlBTQ3F4YVErZ0tDcmZSVEk2K1Az?=
 =?utf-8?B?TE1QZzl1QlNEN2k2MHVYTWZwM05BeGwxaW1NWlQ4UjUzWUFLWVZabC9PSE9S?=
 =?utf-8?B?cis1SlBvZUlTL2s5L0pPVjV1Z3RmNC8xcTNrNjBobjFQWHR4M3Bab21lNGpQ?=
 =?utf-8?B?Z1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D3E08A7791C89A46A1985971972EFF59@EURPRD10.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR10MB3977.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: a292dfce-b36e-4a76-f6c8-08db05f58859
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2023 14:47:11.5155
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: d05HcjFTczRY4WRAMSNasteOO5BwZ8ktX/kOQcK6VF4NLBTU6LRBJ+ikyRvvp7a957G1NN0Y10orSYeZj3FD/9bGXW8gdADOTc3tpvOvO2A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR10MB3941
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIzLTAyLTAzIGF0IDE0OjU0ICswMTAwLCBBbmRyZXcgTHVubiB3cm90ZToNCj4g
PiA+ID4gVGhpcyBsb29rcyBwcm9taXNpbmcuIFNvIEkgaGF2ZSB0byBqdXN0IG1vdmUgdGhlICJy
ZXNldC1ncGlvcyIgRFRCDQo+ID4gPiA+IGVudHJ5IGZyb20gc3dpdGNoIHRvIG1kaW8gc2VjdGlv
bi4gQnV0IHdoaWNoIGRyaXZlciBoYW5kbGVzIGl0LA0KPiA+ID4gPiBkcml2ZXJzL25ldC9waHkv
bWRpb19idXMuYywNCj4gPiA+IA0KPiA+ID4gWWVzLg0KPiA+ID4gDQo+ID4gPiA+ID4gbWRpbyB7
DQo+ID4gPiA+ID4gwqDCoMKgwqDCoMKgwqDCoCNhZGRyZXNzLWNlbGxzID0gPDE+Ow0KPiA+ID4g
PiA+IMKgwqDCoMKgwqDCoMKgwqAjc2l6ZS1jZWxscyA9IDA+Ow0KPiA+ID4gPiB3aGlsZSBoZXJl
IGlzIG5vIGNvbXBhdGlibGUgcGFydC4uLiAuDQo+ID4gPiANCj4gPiA+IEl0IGRvZXMgbm90IG5l
ZWQgYSBjb21wYXRpYmxlLCBiZWNhdXNlIGl0IGlzIHBhcnQgb2YgdGhlIEZFQywgYW5kIHRoZQ0K
PiA+ID4gRkVDIGhhcyBhIGNvbXBhdGlibGUuIFJlbWVtYmVyIHRoaXMgaXMgZGV2aWNlIHRyZWUs
IHNvbWV0aW1lcyB5b3UgbmVlZA0KPiA+ID4gdG8gZ28gdXAgdGhlIHRyZWUgdG93YXJkcyB0aGUg
cm9vdCB0byBmaW5kIHRoZSBhY3R1YWwgZGV2aWNlIHdpdGggYQ0KPiA+ID4gY29tcGF0aWJsZS4N
Cj4gPiA+IA0KPiA+ID4gwqDCoMKgIEFuZHJldw0KPiA+IEkgdHJpZWQgcHV0IHRoZSAicmVzZXQt
Z3Bpb3MiIGFuZCAicmVzZXQtZGVsYXktdXMiIGludG8gbXVsdGlwbGUgbWRpbyBsb2NhdGlvbnMs
IGJ1dCBub3RoaW5nIGhhcyBiZWVuIHdvcmtpbmcuIERUQiBsb29rcyBsaWtlIHRoYXQ6DQo+ID4g
DQo+ID4gPiAmZmVjMSB7DQo+ID4gPiDCoMKgwqDCoMKgwqDCoMKgcGluY3RybC1uYW1lcyA9ICJk
ZWZhdWx0IjsNCj4gPiA+IMKgwqDCoMKgwqDCoMKgwqBwaW5jdHJsLTAgPSA8JnBpbmN0cmxfZmVj
MT47DQo+ID4gPiDCoMKgwqDCoMKgwqDCoMKgcGh5LW1vZGUgPSAicmdtaWktaWQiOw0KPiA+ID4g
wqDCoMKgwqDCoMKgwqDCoHR4LWludGVybmFsLWRlbGF5LXBzID0gPDIwMDA+Ow0KPiA+ID4gwqDC
oMKgwqDCoMKgwqDCoHJ4LWludGVybmFsLWRlbGF5LXBzID0gPDIwMDA+Ow0KPiA+ID4gwqDCoMKg
wqDCoMKgwqDCoHNsYXZlcyA9IDwxPjvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoC8vIHVzZSBvbmx5IG9uZSBlbWFjIGlmDQo+ID4gPiDCoMKgwqDCoMKgwqDCoMKgc3RhdHVz
ID0gIm9rYXkiOw0KPiA+ID4gwqDCoMKgwqDCoMKgwqDCoG1hYy1hZGRyZXNzID0gWyAwMCAwMCAw
MCAwMCAwMCAwMCBdOyAvLyBGaWxsZWQgaW4gYnkgVS1Cb290DQo+ID4gPiANCj4gPiA+IMKgwqDC
oMKgwqDCoMKgwqAvLyAjIyMjIDMuIHRyeSAjIyMjDQo+ID4gPiDCoMKgwqDCoMKgwqDCoMKgLy9w
aHktcmVzZXQtZ3Bpb3MgPSA8JmxzaW9fZ3BpbzAgMTMgR1BJT19BQ1RJVkVfTE9XPjsNCj4gPiA+
IMKgwqDCoMKgwqDCoMKgwqAvL3Jlc2V0LWRlbGF5LXVzID0gPDEwMDAwPjsNCj4gPiA+IA0KPiA+
ID4gwqDCoMKgwqDCoMKgwqDCoGZpeGVkLWxpbmsgew0KPiA+ID4gwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqBzcGVlZCA9IDwxMDAwPjsNCj4gPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgZnVsbC1kdXBsZXg7DQo+ID4gPiDCoMKgwqDCoMKgwqDCoMKgfTsNCj4gPiA+
IA0KPiA+ID4gwqDCoMKgwqDCoMKgwqDCoG1kaW8gew0KPiA+ID4gwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAjYWRkcmVzcy1jZWxscyA9IDwxPjsNCj4gPiA+IMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgI3NpemUtY2VsbHMgPSA8MD47DQo+ID4gPiANCj4gPiA+IMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgLy8gMS4gdHJ5DQo+ID4gPiDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoHJlc2V0LWdwaW9zID0gPCZsc2lvX2dwaW8wIDEzIEdQSU9fQUNU
SVZFX0xPVz47DQo+ID4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJlc2V0LWRl
bGF5LXVzID0gPDEwMDAwPjsNCj4gDQo+IFRoaXMgbG9va3MgbGlrZSB0aGUgY29ycmVjdCBsb2Nh
dGlvbi4gSGF2ZSB5b3UgcHV0IGEgcHJpbnRrKCkgYWZ0ZXINCj4gaHR0cHM6Ly9lbGl4aXIuYm9v
dGxpbi5jb20vbGludXgvbGF0ZXN0L3NvdXJjZS9kcml2ZXJzL25ldC9waHkvbWRpb19idXMuYyNM
NTY5DQo+IHRvIG1ha2Ugc3VyZSBpdCBoYXMgZm91bmQgaXQ/DQo+IA0KWWVzLCBJIHB1dCB0aGVy
ZSBtdWx0aXBsZSBwcmludGstcy4uLiAuDQo+IAlkZXZfaW5mbygmYnVzLT5kZXYsICJkZXZpY2Ug
cmVnaXN0ZXJlZFxuIik7DQo+DQo+IAltdXRleF9pbml0KCZidXMtPm1kaW9fbG9jayk7DQo+IAlt
dXRleF9pbml0KCZidXMtPnNoYXJlZF9sb2NrKTsNCj4NCj4gCS8qIGFzc2VydCBidXMgbGV2ZWwg
UEhZIEdQSU8gcmVzZXQgKi8NCj4gCWdwaW9kID0gZGV2bV9ncGlvZF9nZXRfb3B0aW9uYWwoJmJ1
cy0+ZGV2LCAicmVzZXQiLCBHUElPRF9PVVRfSElHSCk7DQo+IAlkZXZfaW5mbygmYnVzLT5kZXYs
ICJnZXR0aW5nIGdwaW9kXG4iKTsNCj4NCj4gCWlmIChJU19FUlIoZ3Bpb2QpKSB7DQo+IAkJZXJy
ID0gZGV2X2Vycl9wcm9iZSgmYnVzLT5kZXYsIFBUUl9FUlIoZ3Bpb2QpLA0KPiAJCQkJICAgICJt
aWlfYnVzICVzIGNvdWxkbid0IGdldCByZXNldCBHUElPXG4iLA0KPiAJCQkJICAgIGJ1cy0+aWQp
Ow0KPiAJCWRldmljZV9kZWwoJmJ1cy0+ZGV2KTsNCj4gCQlyZXR1cm4gZXJyOw0KPiAJfSBlbHNl
CWlmIChncGlvZCkgew0KPiAJCWRldl9pbmZvKCZidXMtPmRldiwgImdwaW9kIGZvdW5kXG4iKTsN
Cj4gCQlidXMtPnJlc2V0X2dwaW9kID0gZ3Bpb2Q7DQo+IAkJZnNsZWVwKGJ1cy0+cmVzZXRfZGVs
YXlfdXMpOw0KPiAJCWdwaW9kX3NldF92YWx1ZV9jYW5zbGVlcChncGlvZCwgMCk7DQo+IAkJaWYg
KGJ1cy0+cmVzZXRfcG9zdF9kZWxheV91cyA+IDApDQo+IAkJCWZzbGVlcChidXMtPnJlc2V0X3Bv
c3RfZGVsYXlfdXMpOw0KPiAJfQ0KPg0KPiAJaWYgKGJ1cy0+cmVzZXQpIHsNCj4gCQlkZXZfaW5m
bygmYnVzLT5kZXYsICJyZXNldCBmb3VuZFxuIik7DQo+IAkJZXJyID0gYnVzLT5yZXNldChidXMp
Ow0KDQpBbmQgdGhlIG91dHB1dCBsb2cgbG9va3M6DQo+IFsgICAgMS40NDYwOTVdIG1kaW9fYnVz
IGZpeGVkLTA6IGRldmljZSByZWdpc3RlcmVkDQo+IFsgICAgMS40NTA2OThdIG1kaW9fYnVzIGZp
eGVkLTA6IGdldHRpbmcgZ3Bpb2QNCj4gWyAgICAxLjQ5NDg3MF0gcHBzIHBwczA6IG5ldyBQUFMg
c291cmNlIHB0cDANCj4gWyAgICAxLjUwNTg4OF0gbWRpb19idXMgNWIwNDAwMDAuZXRoZXJuZXQt
MTogZGV2aWNlIHJlZ2lzdGVyZWQNCj4gWyAgICAxLjUxMTU1Ml0gbWRpb19idXMgNWIwNDAwMDAu
ZXRoZXJuZXQtMTogZ2V0dGluZyBncGlvZA0KPiBbICAgIDEuNTUwNzA1XSBwcHMgcHBzMDogbmV3
IFBQUyBzb3VyY2UgcHRwMA0KPiBbICAgIDEuNTYxMjAzXSBtZGlvX2J1cyA1YjA1MDAwMC5ldGhl
cm5ldC0xOiBkZXZpY2UgcmVnaXN0ZXJlZA0KPiBbICAgIDEuNTY2NzkxXSBtZGlvX2J1cyA1YjA1
MDAwMC5ldGhlcm5ldC0xOiBnZXR0aW5nIGdwaW9kDQo+IC4uLg0KPiBbICAgIDIuNTY4MTc0XSBm
ZWMgNWIwNTAwMDAuZXRoZXJuZXQgZXRoMDogcmVnaXN0ZXJlZCBQSEMgZGV2aWNlIDANCg0KU3Ag
dGhlcmUgYXJlIG9ubHkgYSAiZGV2aWNlIHJlZ2lzdGVyZWQiIGFuZCAiZ2V0dGluZyBncGlvZCIg
bWVzc2FnZXMgYW5kIG5vciAiZ3Bpb2QgZm91bmQiIGFuZCAicmVzZWQgZm91bmQiLg0KU28gbm93
IHRoZSBxdWVzdGlvbiBpcyB3aHkgaXQgZGlkbid0IGZpbmQgdGhlIHJlc2V0IGluIGR0Yiwgb3Ig
d2hlcmUgdG8gcGxhY2UgaXQuDQoNCkFuZHJlag0KDQo+IFlvdSBtaWdodCBhbHNvIG5lZWQgYSBw
b3N0IHJlc2V0IGRlbGF5LiBJJ20gbm90IHN1cmUgdGhlIGRldmljZSB3aWxsDQo+IGFuc3dlciBp
ZiBpdCBpcyBzdGlsbCBidXN5IHJlYWRpbmcgdGhlIEVFUFJPTS4gV2hpY2ggaXMgd2h5IHRoZQ0K
PiBtdjg4ZTZ4eHggaGFyZHdhcmUgcmVzZXQgZG9lcyBzb21lIHBvbGxpbmcgYmVmb3JlIGNvbnRp
bnVpbmcuDQo+IA0KPiDCoMKgwqDCoMKgwqDCoMKgwqAgQW5kcmV3DQoNCg==
