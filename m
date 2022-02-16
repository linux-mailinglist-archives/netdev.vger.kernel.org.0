Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D85B4B8381
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 10:03:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231802AbiBPIzd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 03:55:33 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:52222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231821AbiBPIzc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 03:55:32 -0500
Received: from EUR03-AM5-obe.outbound.protection.outlook.com (mail-eopbgr30054.outbound.protection.outlook.com [40.107.3.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D21218B17C
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 00:55:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kd26E98FoJMbjrYtAKqqwwaiK/vZWvlP4XpwKpoWbJoVVpFwcLjEwGSSuPRfR+6/+dTBxLHZFKqEMMYAKJhxxcUrx33j+1LpX00xa/gu7Fl+X+DmfspRQPqpmjQVYbm+ZF30xejsLo3YUgbppbTrHXkeeTCNW9DEP2B85fpGecqUjml9BLiou9nVkectD3N2UCbLMswEiDSqot0hHvs4jgwvJ/zIlAXPMEIb1iVVOh+IlQ7G0nC/lsoa+v4+JqMnWmYQAL60shGa61C68q9Laq9NIPux2aiyR/nH4/0ow8auvnmM9a+d3jtYOMROPJpxWkO4WpxQOSB81DbVFiJXJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k5PdBSrrObfJWNUwGP05bW3KkBqhlvKsGT0V51HGUJQ=;
 b=iqLYg0cLKxe4zYFcRijyIlL7DDbUtOx6ntWU5wT5jmnRmmrNMN76eKqpu3rfWi7pJvyiISxrFIUDHJqFzRZTtvW5CRzLBIC0gWVPUKQFSh1JABAxPQtB/xD2QKvmdVahmnrkpLpuBndp5lLTeUNnNeBqiPCOrvQtrqf3Mgnfu5851CKidgNe4Ek8cqXsrQ+hnWSWTM7fOrAwcjiiMK2khgyzfAneo5H7YQzn/jUZAzeVb6jsyjHHUd3bBDsdKVHhm7qv++zNiJWwoAsxs4whzUTQg9AnwwK42znaGPgvZSkHMrVu2oJiKRAHFCyYbcks7e4irABO3NT29A50uBwfsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=siemens.com; dmarc=pass action=none header.from=siemens.com;
 dkim=pass header.d=siemens.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k5PdBSrrObfJWNUwGP05bW3KkBqhlvKsGT0V51HGUJQ=;
 b=Jy4Epc1VuzALGzkODG772/C0MgE91yMEa9yDmmgvomupInr0kv5FBHA8Mqaz4qbXp/10SOPwMbnX5KdrOFRQ+apVfRiyUs6XgEKMwB7RGosuYaRZ6IokDawyMRwsBbSw41kdcOlZcSVm6F5edoOfvo2XVOJKGUYQBRJu1EiXIzLLxAAWIz24CLyzPprXT3CY8Ja/0ejKmbDHpUllGBsEY0eXMBeLjfLeqMiyM1XZ9OmHMmUkra5NyRg2KE1XQWDP47Prr0azvvb0mDzjvEsRiK7a/Wuc8R8KUtiH61LX7z8yUAKZUoeUrtymiaAgA1918M70YyeJ2u6AzHXX5mA2kw==
Received: from PA4PR10MB4606.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:102:103::11)
 by AM0PR10MB2612.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:124::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14; Wed, 16 Feb
 2022 08:55:17 +0000
Received: from PA4PR10MB4606.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::604a:5ac3:d7b0:d8bb]) by PA4PR10MB4606.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::604a:5ac3:d7b0:d8bb%5]) with mapi id 15.20.4975.018; Wed, 16 Feb 2022
 08:55:17 +0000
From:   "Moltmann, Tobias" <Tobias.Moltmann@siemens.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: DSA and Marvell Switch Drivers
Thread-Topic: DSA and Marvell Switch Drivers
Thread-Index: AdgjEa+wvdEYdkdHSua+umGaGG18Vg==
Date:   Wed, 16 Feb 2022 08:55:17 +0000
Message-ID: <PA4PR10MB46060AD14E4D15C2F50CA3AAE5359@PA4PR10MB4606.EURPRD10.PROD.OUTLOOK.COM>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_a59b6cd5-d141-4a33-8bf1-0ca04484304f_Enabled=true;
 MSIP_Label_a59b6cd5-d141-4a33-8bf1-0ca04484304f_SetDate=2022-02-16T08:55:16Z;
 MSIP_Label_a59b6cd5-d141-4a33-8bf1-0ca04484304f_Method=Standard;
 MSIP_Label_a59b6cd5-d141-4a33-8bf1-0ca04484304f_Name=restricted-default;
 MSIP_Label_a59b6cd5-d141-4a33-8bf1-0ca04484304f_SiteId=38ae3bcd-9579-4fd4-adda-b42e1495d55a;
 MSIP_Label_a59b6cd5-d141-4a33-8bf1-0ca04484304f_ActionId=0e006ec7-7af8-46e6-950d-1e42ec345886;
 MSIP_Label_a59b6cd5-d141-4a33-8bf1-0ca04484304f_ContentBits=0
document_confidentiality: Restricted
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=siemens.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5198dde2-1e28-4b50-b06f-08d9f12a0e2a
x-ms-traffictypediagnostic: AM0PR10MB2612:EE_
x-microsoft-antispam-prvs: <AM0PR10MB26127285F81073CB3E141EFDE5359@AM0PR10MB2612.EURPRD10.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XsEbv/qTkjlx7Wf/n5QGDLjiCoLr4MOCIX77Uh/aj+6krZ97EvN2kpH7bEWv2qdIMucNgmMkv4ezWoh7MmwhvAyzVpKrHZSlUwGb1t3y4f3XoY8adgoAbYJBNTIlIrho/Ou6eQM41s2rxtHXSbaK/KMOJ/uzvqUQu+O/SxBhGQuXErHYCkoJL84ptPyaP57Tu/BrMlTkoKiqJQ7dE6k6gn0k5Of0a6a+TvG5Gkzxr2SLnhqsFmUpTQ7vP46OzQYdoYEqCUooHSArS5xXAoi2xLuDkgz1x0W/EpKJRpdPL5KS6oQknsKPgOo/w3eKAk2SSHTfbrLelQnO/vx7UewlcRTagQsiUbQcusGIougBJ8/Y1EvHfp0cV21Jgdo81OaINatgQxHXANWULTP7OdUmR5k/O7+5z65czVIMe3F17Rt5rz42qyrF2Z6jb6xpVzYYnZhjX0uNxL2W3FWSy3niIVm+KuY8YvDLSQI1DjYtSIGMG/F0Z9ppx1m0bs9xa3YznFa4KcnDXeJsSP14eGAq4LoKlKSGFnEEgHEDkh2c7np8v6RaZFHokIEYDHATlkE9EzWa4JrvQ+EWeSDjsgXc+G9tRR/TNUXJnTmPVOR9tC9Ee+rXIsJfakUsRvJnh6637Nup9+BYdDZg8SrauiiBljAoDXUAsOO5GJzxFLjfAMtpJ9hgjqPD0BieeRyyRj2KcoX4M0bnfgchaNugcwyPXRLU8yXoqyTSvy318nV1zf8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR10MB4606.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(7696005)(26005)(6916009)(316002)(83380400001)(8936002)(5660300002)(186003)(9686003)(52536014)(55236004)(55016003)(38070700005)(66946007)(38100700002)(82960400001)(4326008)(86362001)(66556008)(64756008)(66446008)(66476007)(8676002)(71200400001)(122000001)(76116006)(33656002)(508600001)(6506007)(2906002)(21314003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NVVSS3R2eHlTZjVYSjloR0p2cmFNaFlDTEx2aWo4b0lHZHc0NE1hdFFpeXUr?=
 =?utf-8?B?NVB2c1NqOVFaWHlGNld3M2FRSzVUc1dlT3c2K3hoejJTRnM5MEgveWpQSDlV?=
 =?utf-8?B?K0FBTTNncitWY3dOdG1HbkxTWHpLM1Qrc0hLZ1RMejB1UWEyRFBpd1VkQVJZ?=
 =?utf-8?B?YmFlc2NNbHc5Y1hPQWlUb1ZuSThHVk9tRUt3UjNRaVU0YmxDc3hDSVFUdFlp?=
 =?utf-8?B?Yk1mekYwQ3FBcmlsQW1NOXVGQ3UvcmNqNlJNK0h2dHBGWkswenpTMFVvam5s?=
 =?utf-8?B?cW9TWjU4cVpuejNDckd0UTNzcUpYdkx1bjVNL2FZcWxmeDNSVm5nZitjU2xH?=
 =?utf-8?B?Wll1VU1FWEVWdWlMK3RYdnJneHY2MzlMT1hwM2hrejJ2MDIyaVFUNDFtcHZQ?=
 =?utf-8?B?Tyt5M2JEdmV4Q2lDMDUvUEtESUhORlNEVkNnUmovMHFsR2orUnRJVHhsZ0p2?=
 =?utf-8?B?bUR6ZzlhdyticDBDMXY2eCttU0tJVEJySDBmbVo0YUJUZVp1aXhzTXJseXJB?=
 =?utf-8?B?aHljbXlFR2hVd0pVbkdrekttRWZRTTZpZlc1YWNZa1ozcERjbG9MRG9ydkhK?=
 =?utf-8?B?RUZpdkp3dTNBS2RqL0NrYUZXalloOGlwL2RveTRmRkthT3JQWUJnbEFIM3cr?=
 =?utf-8?B?OXM1ODVIOVN1TC9zVlI0TXQ1NjMxK3pnc2J0SmZVNVpXQkRrbzQ3NlRvVXdh?=
 =?utf-8?B?TklIdU9SZTVMV2NnTWFVNFJ3N3lqN1hKbVEzSlV4S3pja2x4eUV2YzUxRkhm?=
 =?utf-8?B?djVNc0hiOWhNanRKR3VBY3R0ZjBoenVudGdCMVBSS1o1d1dvcTVJQTlXdFlE?=
 =?utf-8?B?cjlwRTFxN0M2T3d5U2Vxd1JnUUJuZlZSU0ZDaHRKT1pkbEdpWVF6dkNsREF4?=
 =?utf-8?B?aGdWb0tWVUlZMlZkbk9oRm1vMzZ2MWlUaytRQ2lOVDNadkxDdzNJcW5wYTMx?=
 =?utf-8?B?MHBDdUtnZSszR3M2OFhHeFc2SjJFN2JWZ3U5MkZSVjM3eStJV0hRN3QxaktD?=
 =?utf-8?B?c0UzdDJ1V2dhRGRadU1hd2M3THQzVGJWWHBmNkJZY2VsM1hRVEZkWVJ6dk5i?=
 =?utf-8?B?UGRYZHlxdURZUEM4NGE0Z25sK0pCWk8yYTQ4eE5PclhXVVppd1B3Nk50bmlX?=
 =?utf-8?B?SnNkNlozKys5RDNCaHNEektrR2dRUjVXL2cyMXcwb0cwbjVyR3kxWDJmTmwr?=
 =?utf-8?B?U1c3c0lmN1Vqb1hqRi9xeUNLaGV2Z1k4RzVOaEIrNXJDT01VUGt2VUNhcFZO?=
 =?utf-8?B?MHZ5NzFzRkZ5WFlkR01DZnBrNU5JUjhGUDNSWWtxWFF2ZHNoc2ZCU3VWdVI2?=
 =?utf-8?B?UG1vZCtNdENuUGVGWm5TeWwvY0NqMnJITjViZ1Q5MndrUFRJeEtxQk1sWURi?=
 =?utf-8?B?Uk9WUzQydjlFYzhEUllxbGxLNlJ2MHR2WXBUUTJXMXZwbGV2U2c1M0NhQ3Q0?=
 =?utf-8?B?cmZGaUtuTzRncDBobWdMQTJFSXcxTWhqeXZxb2Uwd2lLZVFTVnk3bElVUThX?=
 =?utf-8?B?NXFFMmJ6Y3BaUElNS0hYaWcvQ2dvWVR3bXlISDhnQVUzZnV3Y1VZR1AvRGN1?=
 =?utf-8?B?REtNNUcyeGRVK2t6cStWN3JPSWN0V0JWcytWaGhmUW00N2REOUVldjJmNnR0?=
 =?utf-8?B?NlpPenI0c0JpeVdGVDhzRXc0TlBCN1JSajI4L0prM0kvODYxL3p2OVBodzND?=
 =?utf-8?B?cUJrd29TMlRpaVE4NzlyQ2RIbFIrMXVTQk5nZmhFTkZTRGpLY3hLS280RUJS?=
 =?utf-8?B?SGIxYS9FVitsdldEb1FiZWI4T0xLU1ZER2dkcWhGRG0yQ3VmdmYwazhWcEVn?=
 =?utf-8?B?T1FFTG9DeHo5V3NDeDVDUVZ4cjdiSmdBWEJBVUNNT0YrUk9pbXhUbHJYTzFM?=
 =?utf-8?B?WUZGYjduMVBubktER05WODMrRThDS2lLNllmT3hvSldsa1ZxK3ZPREFpb2NH?=
 =?utf-8?B?aG4xeUZCSnlRVCtkOUFveFVQTE5tc3hJQXg1b3dOL05mbWZIVWxBYVZ3Um81?=
 =?utf-8?B?SEJ6bm9wNjRmMFQ0aHhsMnp3NmovVXpodi9CMDZieG1yUkVhVTI1Z1BxY25O?=
 =?utf-8?B?MTd6c2NOTHcyR0pVQ1VER3VXR1J1R1ZUNHpVMzltNXdwK2dpdDJpbWU4U0l4?=
 =?utf-8?B?bHc3WmxNV0VqL2kyWmlENTNLZmY2dEw2b1d3WnBRNkg0OGlRREN0bVRIU0JV?=
 =?utf-8?B?OHBTQnBwbFVZNmFseDJNQk9jQUsrV0pCSUJxM2JTeTkvemJsSFZkUmZOV2ty?=
 =?utf-8?B?aHJERmZORWJKNGs1bS9FV0Q2MkhBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PA4PR10MB4606.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 5198dde2-1e28-4b50-b06f-08d9f12a0e2a
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Feb 2022 08:55:17.7141
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SPFEcANJY4aVtNHf500Q/jA0877Ut1e9Cty+xLBCvxKGA9Cg7AIyK1/mmk6HXFPOsYC+lAa+LLK6tFsmdTlDptHGL6hk/ENtskXeqFrW7Xk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB2612
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8sDQoNCkkgd291bGQgZmlyc3QgcmV3cml0ZSBteSBxdWVzdGlvbnMgYW5kIHByb3ZpZGUg
c29tZSBpbmZvcm1hdGlvbidzIGFuZCBhZGQgc29tZSBvZiBBbmRyZXdzIGFuc3dlciB0byBpdCBh
cyB3ZWxsLg0KQXMgSSBsZWFybmVkIGl0IHdvdWxkIGJlIGhlbHBmdWwgdG8gYWRkcmVzcyB0aGUg
Im5ldGRldiBsaXN0IiB0byBnZXQgKGhvcGVmdWxseSkgZXZlbiBtb3JlIGhlbHAuIA0KU28gcGxl
YXNlIGZlZWwgZnJlZSB0byBwcm92aWRlIHNvbWUgZmVlZGJhY2ssIHRoYW5rIHlvdSENCg0KVGhl
IGlzc3VlIHdlIGZhY2UgY29tZXMgYWxvbmcgd2l0aCBhbiBLZXJuZWwgdXBncmFkZSBmcm9tIDQu
NC54eHggdG8gbm93IDUuMTAueHguIEl0IGlzIGFsbCBpbmR1c3RyaWFsLWJhc2VkIGhhcmR3YXJl
LCBzbyANCm5vIGNsYXNzaWNhbCBQQyBvciBzb21ldGhpbmcuIE9uIHRoZSBoYXJkd2FyZSB3ZSBo
YXZlIGFuIHg4NiBDUFUsIGFuIElHQiAtPiBNYXJ2ZWxsIFN3aXRjaCAoTWFydmVsbCA4OEU2MTc2
KSAtPg0KYW5kIHR3byBQSFkncyBjb25uZWN0ZWQgdGhlcmUuDQoNClZlcnkgcm91Z2hseSB0aGUg
d2F5IGl0IHdvcmtlZC9ydW4gd2l0aCB0aGUgNC40IEtlcm5lbDoNCg0KLSBtdjg4ZTZ4eHhfaW5p
dCgpIGNhbGxlZCAtIHJlZ2lzdGVyZWQgdGhlIGRyaXZlcg0KLSBJR0IgZHJpdmVyIGxvYWRlZCwg
c3RhcnRlZCBwcm9iaW5nDQotIHdpdGhpbiB0aGUgcHJvYmluZyB3ZSBzZXQgdXAgYW4gTURJTyBi
dXMgKG5hbWU6IGlnYiBNRElPLCBpZDogMDAwMDowMTowMC4wX21paSkNCi0gdGhlIGxpYnBoeSBk
b2VzIGEgZmlyc3Qgc2NhbiB3aXRoIG5vIHJlc3VsdCBkdWUgdG8gc29tZSBvdGhlciBtaXNzaW5n
IHN0dWZmIC0gYXQgdGhpcyBwb2ludCBpdCBpcyBvaw0KLSBhbHNvIHdpdGhpbiB0aGUgaWdiIHBy
b2Jpbmcgd2Ugc2V0IHVwIGFuIGRzYV9wbGF0Zm9ybV9kYXRhIHN0cnVjdCBhbmQgcnVuIGEgcGxh
dGZvcm1fZGV2aWNlX3JlZ2lzdGVyKCkNCi0gdGhpcyB0cmlnZ2VycyB0aGUgRFNBIGRyaXZlcg0K
LSBtdjg4ZTYzNTJfcHJvYmUoKSBpcyBjYWxsZWQgb3VyIE1hcnZlbGwgc3dpdGNoIGlzIGRldGVj
dGVkDQotIGEgbmV3IERTQSBzbGF2ZSBNRElPIGJ1cyBpcyBiZWVuIGJyb3VnaHQgdXAgYXV0b21h
dGljYWxseQ0KLSBtZGlvYnVzX3NjYW4oKSB0aGVyZSByZWdpc3RlciBvdXIgdHdvIFBIWSBkZXZp
Y2VzIA0KLSBldmVyeXRoaW5nIGlzIHdvcmtpbmcgOikNCg0KDQpOb3cgaW4gdGhlIDUuMTAgS2Vy
bmVsLCBhcyB0aGVyZSBhcmUgdGhlIHJld3JpdHRlbiBEU0EvTWFydmVsbCBkcml2ZXJzIGluY2x1
ZGVkLCB0aGUgdXBwZXIgInN0dWZmIiBpcyBub3Qgd29ya2luZyBhbnltb3JlLg0KU28gZmFyIHNv
IGdvb2QuLi4gRHVlIHRvIHRoZSBmYWN0LCB0aGF0IHRoZSBEU0EvTWFydmVsbCBkcml2ZXJzIGFy
ZW4ndCBwbGF0Zm9ybSBkcml2ZXIgYW55bW9yZSB0aGUgdHJpZ2dlciB3aXRoIHRoZSBwbGF0Zm9y
bV9kZXZpY2VfcmVnaXN0ZXIoKQ0KaGFzIG5vIGVmZmVjdCBhbnkgbW9yZS4gSSBzdWdnZXN0IHdl
IG5lZWQgdG8gZW5kIHVwIGluIHRoZSBuZXcgbXY4OGU2eHh4X3Byb2JlKCkgZnVuY3Rpb24gaW4g
ZHJpdmVycy9uZXQvZHNhL212ODhlNnh4eC9jaGlwLmMuDQpBcyB0aGVyZSBpcyBhbGwgdGhlIHBy
b2JpbmcsIHJlZ2lzdGVyIG9mIERTQSBzdHVmZiBpbmNsdWRlZC4gDQpJIGFkZGVkIHNvbWUgInBy
aW50ZiIgaW4gdGhlIG1vZHVsZSBpbml0IHBhcnRzIGluIHRoZSBjaGlwLmMgZmlsZSBhcyB3ZWxs
IGFzIGluIHRoZSAvbmV0L2RzYS9kc2EuYyAtIGFuZCBJIGRvIHNlZSB0aGVtIGluIHRoZQ0KS2Vy
bmVsIGxvZ2ZpbGUgYWZ0ZXIgc3RhcnR1cC4gRXZlcnl0aGluZyBlbHNlIEkgYWRkZWQgYXMgb3V0
cHV0LCBkb2VzIG5vdCBzaG93IHVwLg0KDQpBbmRyZXcgYWxyZWFkeSBwb2ludGVkIG91dCwgdGhh
dCB5b3Ugbm93IGhhdmUgdG8gc2V0IHVwIChhcyBleGFtcGxlKSB0aGUgZm9sbG93aW5nOg0KDQpz
dGF0aWMgc3RydWN0IGRzYV9tdjg4ZTZ4eHhfcGRhdGEgZHNhX212ODhlNnh4eF9wZGF0YSA9IHsN
CiAgICAgICAgLmNkID0gew0KICAgICAgICAgICAgICAgIC5wb3J0X25hbWVzWzBdID0gTlVMTCwN
CiAgICAgICAgICAgICAgICAucG9ydF9uYW1lc1sxXSA9ICJjcHUiLA0KICAgICAgICAgICAgICAg
IC5wb3J0X25hbWVzWzJdID0gInJlZCIsDQogICAgICAgICAgICAgICAgLnBvcnRfbmFtZXNbM10g
PSAiYmx1ZSIsDQogICAgICAgICAgICAgICAgLnBvcnRfbmFtZXNbNF0gPSAiZ3JlZW4iLA0KICAg
ICAgICAgICAgICAgIC5wb3J0X25hbWVzWzVdID0gTlVMTCwNCiAgICAgICAgICAgICAgICAucG9y
dF9uYW1lc1s2XSA9IE5VTEwsDQogICAgICAgICAgICAgICAgLnBvcnRfbmFtZXNbN10gPSBOVUxM
LA0KICAgICAgICAgICAgICAgIC5wb3J0X25hbWVzWzhdID0gIndhaWMwIiwNCiAgICAgICAgfSwN
CiAgICAgICAgLmNvbXBhdGlibGUgPSAibWFydmVsbCxtdjg4ZTYxOTAiLA0KICAgICAgICAuZW5h
YmxlZF9wb3J0cyA9IEJJVCgxKSB8IEJJVCgyKSB8IEJJVCgzKSB8IEJJVCg0KSB8IEJJVCg4KSwN
CiAgICAgICAgLmVlcHJvbV9sZW4gPSA2NTUzNiwNCn07DQoNCnN0YXRpYyBjb25zdCBzdHJ1Y3Qg
bWRpb19ib2FyZF9pbmZvIGJkaW5mbyA9IHsNCiAgICAgICAgLmJ1c19pZCA9ICJncGlvLTAiLA0K
ICAgICAgICAubW9kYWxpYXMgPSAibXY4OGU2MDg1IiwNCiAgICAgICAgLm1kaW9fYWRkciA9IDAs
DQogICAgICAgIC5wbGF0Zm9ybV9kYXRhID0gJmRzYV9tdjg4ZTZ4eHhfcGRhdGEsIH07DQoNCiAg
ICAgICAgZHNhX212ODhlNnh4eF9wZGF0YS5uZXRkZXYgPSBkZXZfZ2V0X2J5X25hbWUoJmluaXRf
bmV0LCAiZXRoMCIpOw0KICAgICAgICBpZiAoIWRzYV9tdjg4ZTZ4eHhfcGRhdGEubmV0ZGV2KSB7
DQogICAgICAgICAgICAgICAgZGV2X2VycihkZXYsICJFcnJvciBmaW5kaW5nIEV0aGVybmV0IGRl
dmljZVxuIik7DQogICAgICAgICAgICAgICAgcmV0dXJuIC1FTk9ERVY7DQogICAgICAgIH0NCg0K
ICAgICAgICBlcnIgPSBtZGlvYnVzX3JlZ2lzdGVyX2JvYXJkX2luZm8oJmJkaW5mbywgMSk7DQog
ICAgICAgIGlmIChlcnIpIHsNCiAgICAgICAgICAgICAgICBkZXZfZXJyKGRldiwgIkVycm9yIHNl
dHRpbmcgdXAgTURJTyBib2FyZCBpbmZvXG4iKTsNCiAgICAgICAgICAgICAgICBnb3RvIG91dDsN
CiAgICAgICAgfQ0KDQpJIGRpZCBhIGJ1bmNoIG9mIHRyaWVzIHdpdGggdGhpcyBpbmZvcm1hdGlv
bidzLCBwdXQgaW4gb3VyIC5idXNfaWQsIGNoYW5nZWQgdGhlIHBvcnRfbmFtZXMgYWNjb3JkaW5n
bHksIHN3aXRjaGVkIHRoZSBib2FyZCByZWdpc3RlciB1cCBhbmQgZG93biBldGMuIA0KYnV0IGl0
IHN0aWxsIGRvZXMgbm90IHN1Y2NlZWQg4pi5IA0KQXMgQW5kcmV3IGFsc28gbWVudGlvbmVkIHRo
ZXJlIGlzIG5vIG1haW5saW5lIGV4YW1wbGUgYW5kIEknbSBhbHNvIGEgYml0IGNvbmZ1c2VkIHRo
YXQgSSBoYXZlbid0IGZvdW5kIChtaWdodCBiZSBsaW1pdGF0ZWQgdG8gbXkgcGVyc29uKQ0KYW55
IGV4YW1wbGUgc29tZXdoZXJlIG91dCB0aGVyZSB3aGljaCB3aWxsIHB1dCBzb21lIGxpZ2h0IGlu
IG91ciBkYXJrbmVzcy4uLg0KDQpTbyBJIHdvdWxkIGFwcHJlY2lhdGUgYW55IGhlbHAgZnJvbSB5
b3UgZ3V5cy4NCllvdSBjYW4gYWxzbyBjb250YWN0IG1lIGRpcmVjdGx5IC0gZmVlbCBmcmVlIGlm
IHlvdSB0aGluayBpdCBhIG1vcmUgb3B0aW1pemVkIHdheS4gDQpJJ2xsIHNoYXJlIG15IHNvbHV0
aW9uL2luZm9ybWF0aW9uJ3MgaWYgaXQgd29ya3Mgc29tZWRheSAuLi4NCg0KS2luZCByZWdhcmRz
LA0KVG9iaWFzDQo=
