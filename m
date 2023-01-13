Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6647669B09
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 15:55:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbjAMOzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 09:55:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjAMOy1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 09:54:27 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCAE680AC8;
        Fri, 13 Jan 2023 06:40:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1673620832; x=1705156832;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=wgwnbgCkD7bX4eGtQf+GiY4NJowh7ShVfu/+vjOaIlo=;
  b=V4VU7OxCZrGaW8QzcewyraaSGvraw72WQBJG7m9y78z++vMw5zEgEzD+
   odffpfqx0PpWSzKjVX5odP8r6p3HNf6Yk7dCw4eWNd60iJtehucNa9E2x
   K26FFohrngt36RMyAcDOscnUkx9WA4r48g3VaxiOL2OgwckZ0Ztv5CvAg
   VTRRZzCRy0c4/91nPlH+vQKUJxqEqX7eSY6pfezuZkZIGugdt8b1JXN1+
   0laOz6Fr7BdTKZUwTHqKvH2sGFT8s5VI0ADKT1LTllFyY2hBkrdSZO8tM
   tgpMJ7WNUKMgGjROrjA13Q5eydIMQ0tbAo+AFunh9co67t2pjKOYB2vns
   w==;
X-IronPort-AV: E=Sophos;i="5.97,214,1669100400"; 
   d="scan'208";a="192134471"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Jan 2023 07:40:31 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 13 Jan 2023 07:40:29 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16 via Frontend
 Transport; Fri, 13 Jan 2023 07:40:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bMIGe+RjmkMeb4M5jkZsQxLqTw0/d7N7TdTno5BFONFw7u1pBePMayfhD1wilBPWA0ZBFqz8+h6NX5u2Dj1XyF+EnoC3BeQE6TwnB4sHsR0QH1TXSEcB5OWcLC3B2Ne3dwNFpt61Q5VzdGUbIJTJ9abm/2hHefX6ZBW3LdDXIuCd9tcj9s0bsGo8ZF+RIEUeuyZq/Snf5NbBzP6XxWorNXj9hDHE3qXJVrqb1rdQVqFZKu7101t9Yyf7oVdZdgIYfpNEH/rPQif5pqUHp1h/GQwxqWSLxErq71yQnMkhLuMolXcP6yBKFJW/S8Lxpp46ybMOojYafMzPGpvPcgmmkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wgwnbgCkD7bX4eGtQf+GiY4NJowh7ShVfu/+vjOaIlo=;
 b=ct6gJEKXkbfawWaHe0hSAoDHudUA812fB2DZnQReUX+LdFIFynFBALqLtCwdDycjutwLN5ooRWXKDFjMHdBQdULuXggsnFYOor+xe6a1iIlF0ugUugP3fobJGOJVo4TyQKFaiWPSFCDbQ+ZLan50XGVDfJHMBa2sgjcQEF9HCn8U7NlV4v2qA2oeqZ0ot6c1JcviTiTXHfDePMuS4ucpYcvEaFWRz3N9uwT8dTIllvfDBCaAM2xl9c6OQs+IN0Lf1DspvrKSdwnqwXeMqM3z7P8UGFO3eDOvyGMWXQ5CfP7r7QrXcFOLCehjfYUO5H+jClIDhz9r6QOLkfibDSUElg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wgwnbgCkD7bX4eGtQf+GiY4NJowh7ShVfu/+vjOaIlo=;
 b=evU7t89l+yQP8FxGHbIXXLdKXsyMGxrm6yxANzIGYQ3/RjUBTvatsrFdQviWYxo3tm22C+wUyLKW6Jlz2e1BXa4qDEysIjo+yNFWBlT95PrZ0DQ45SCz9J09dZK1/7xFFXj+QaEsYFTP1V7m8Y9VQv/quYRtZm/f0Tli/oEmXLU=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 SJ0PR11MB5055.namprd11.prod.outlook.com (2603:10b6:a03:2d9::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.19; Fri, 13 Jan
 2023 14:40:26 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::33d3:8fb0:5c42:fac1]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::33d3:8fb0:5c42:fac1%5]) with mapi id 15.20.5986.018; Fri, 13 Jan 2023
 14:40:26 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <olteanv@gmail.com>, <andrew@lunn.ch>, <linux@armlinux.org.uk>,
        <f.fainelli@gmail.com>, <clement.leger@bootlin.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@google.com>,
        <davem@davemloft.net>
CC:     <miquel.raynal@bootlin.com>, <linux-kernel@vger.kernel.org>,
        <linux-renesas-soc@vger.kernel.org>, <jimmy.lalande@se.com>,
        <herve.codina@bootlin.com>, <milan.stevanovic@se.com>,
        <thomas.petazzoni@bootlin.com>, <pascal.eberhard@se.com>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net: dsa: rzn1-a5psw: Add vlan support
Thread-Topic: [PATCH net-next] net: dsa: rzn1-a5psw: Add vlan support
Thread-Index: AQHZJ1p/dgNBhayfQEW5oNc/wA1GC66cazsA
Date:   Fri, 13 Jan 2023 14:40:26 +0000
Message-ID: <be08c48a21623f1ad8165023ebe986138e44be74.camel@microchip.com>
References: <20230111115607.1146502-1-clement.leger@bootlin.com>
In-Reply-To: <20230111115607.1146502-1-clement.leger@bootlin.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB0076:EE_|SJ0PR11MB5055:EE_
x-ms-office365-filtering-correlation-id: cf89d5b0-3acf-4c05-8db6-08daf5741c06
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kf90kU7wnpPHHk6tPuF0jHQNGYGHzFuvvFy+fNe9Le6gu9pV67zK0gPXnjzpEqTYCuAEINt+3cKpHwAVCLG5MjNos7MZcqZJC+kea9Pj4yqNp+SH5Cn7TKN495aaIDx2SmgWwpA2IB9esq6BwJZ4v38WxW82sixaSXJU2wfaTS8sv7lNSLildEEwjJ635WnwPu/snQAvYEvOCbYUPe/pLrmVyOOShzTPvRvJKsME9Z0pz8mrRVRsBObJ5SEwENOp5oFzZ5gvari1fiPnD/sgWyjL7tnhhokWymb08dZGRLilz0X0jLunY6deEQArFh4JnFYM/ZKsTV3KK/zAlQzbhbF3HPpguib7Pc6YtkuFhJnG5Kas80C2/3yOg+FHOm1ItGko50yoiJubyUUhA3sVhB+eBfw/pQ3FrzhthQHT7x0DbmdU2Kf1y3/d4+p06G1KeRuMXa/e6kvjELfuim95BRaSXwpg/riTlVQ3OGQfm4/4+iMRhEleHW+6Ljt052NCuaWYnI/GtTgeW2y9aQzFy0nOwweXNvcKeAYaW8BVJu75KctRG3mn2FzGoxJe5M/50DJ/JLXPcW1n3B5YtnLd0nUY59jdaWTY0ruPpGA/mJLOzB7LVsQEbdChpgF+g+ZnOSdibDyeaYegfy2j4hIzHZn5HSovdof2s7+KZsrjJ6y1MLitBi9QWnwjbdIOCA69/vNbFY0oP5a/UZBX9cavmdNMMMbU6xU79r8MuNsdC9c=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(39860400002)(396003)(376002)(346002)(451199015)(71200400001)(6512007)(186003)(478600001)(110136005)(66446008)(66946007)(76116006)(66556008)(2616005)(54906003)(316002)(6506007)(91956017)(8676002)(4326008)(66476007)(64756008)(6486002)(38100700002)(8936002)(7416002)(5660300002)(41300700001)(86362001)(83380400001)(36756003)(122000001)(66574015)(2906002)(38070700005)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UlQzS2ppc0R6RTN2M3ZVbmM4WTlsbXNKRXY2eDM4bkRJTjJFU29iTFMzMXMv?=
 =?utf-8?B?T3RoTmxGekxnak5jVHVsVXNoNHpUVEtvY3NqYjZ4NUY5SjdpelVaMFdWMVM1?=
 =?utf-8?B?UGswSjhhV21iU281My8vWE9TTkluckxRdkRKMFNOVmUyVlFNa3VIZUx0ZzVo?=
 =?utf-8?B?VFNDMkJrbWpEdFcrUTIrak5yTGc0VDYybjc4NWN4OUROdG92SFh6RWY2OUIx?=
 =?utf-8?B?cnFTc2VEUDcvTDVBaXpzeHRQdEJRN2ZQaDNDYnFHaE5KVUZiUzM2Z09MbXU1?=
 =?utf-8?B?Mzh4Q01WRWRhMW9FVDZuaGE4V1JPWGZidm51RXppVzRzNUJYeGVYZnZGZnZG?=
 =?utf-8?B?R0U5QTFsS3NXekthQWd1RW5SbDgwTDlBazYzdDVnQzdpZzMzTnlLNW01VEtS?=
 =?utf-8?B?VEdRUGZFdm5pN2xMZHphdHhIR1dIYVNnVXhEWFNoSS9ZdXRuS0pzVTdRRStv?=
 =?utf-8?B?VzlsYVJpN09adjQxbnBEQ09NMDlocVNLWnJCR1FqaGlVaC9tZVdoUVBNNUxC?=
 =?utf-8?B?S1RLQ3dNRDlJVWluSWpvQ0FEUDJtdTRTeFc3MXJqQUFmMGNKOVhpZVQxS1Zh?=
 =?utf-8?B?RWdZWVhVbW5CVVNDZzFHVC9ORkdPekFmYlpZdWNVM1BVSFJmMXBhMDJsZytP?=
 =?utf-8?B?VCtnTXhtV3VIVzM2UXQwVVdNbWZEQnU3SnZxa1YzL3htZmNzaDNxb09xQ3ZI?=
 =?utf-8?B?aWdFZmkzWGk0U2IraTMySVBKaDZMQkNITTk3WXJQME1nTHdZYUVvZ3BYWHNG?=
 =?utf-8?B?TENvWXhsWk01aFdyUXowbkRxOWNSZW1yUldXb0lrUVdVb1dGTUpjeDMrblRM?=
 =?utf-8?B?U3lxUnBMSS96RVlqWGR4ck51eE95Sm8yRVR2LzRSVi83TFViM2krZFhpbzJD?=
 =?utf-8?B?cCtWWnVZa3EvSTc5Y0ZBOGNJVjlobkovV2hrd01xZXZKNU11L2VsUEhzWWt3?=
 =?utf-8?B?ZzRsZnRQQldjbG01czFLdmRUN3p1all4M0V0QTdPc3FPbmpqYWl5QmJIVy9S?=
 =?utf-8?B?RTA4bWZhdzlHdTZicy82TVVBaXJQdnRzU0pLRWRXN2wvVXk0SnVCeGJPb3ha?=
 =?utf-8?B?RzdhaXQ4d25UYTJoU2ZEYzVLK0lLN0l1RGtwV3FpU1Q0Y2tRT2QzNlRmdTFJ?=
 =?utf-8?B?YVE3UnJZSWprSU1KWmZ6eFN6UnRCcmFjZjRDMUplZEFibTgrZ2NYOWN5VUtN?=
 =?utf-8?B?aVU3SFpyRkVYTys0TytWdHgxRERtYkVjdjdwRWxYQU15NjBBVHJIU0xibE9k?=
 =?utf-8?B?S25OTHRiZ0xtTWxqK3FRVnR1UjF6U3NRSHRSaU9Ta3F2MHJPM2JSY1d4WUxP?=
 =?utf-8?B?SjlTbkdDcUFFYVFPNTUwbldib3dVaDBaczJSK1dXUmp4eG1xYVR4UWpXcmpp?=
 =?utf-8?B?dXQra0lIR3FqYkszREpVcFNjN0ZETmJ0T0YzUS8rM1JncnVsOUhtTDBQVUY0?=
 =?utf-8?B?M1pwUmIxRy8rc0orbFhmVllMbWZHZ0piOEZKcGZ2ZDZaK21iMTNKTUprUHM2?=
 =?utf-8?B?L0cxSG44U2pqbTlLU0poNWJrOEFiL3hzNGRoREcrL3pDb0JGdUM0RURGUVpZ?=
 =?utf-8?B?OEk0ZG5KK0ZXcDBWR016d0lTaUtsTEhzMWp5c3FHaTRIRXB2aiszeFRmbHVk?=
 =?utf-8?B?UVJaZkxmcWg3V1Z2TUdwb2NXMjlUWXgzdCtQZ0U4bGsrSG5FNTlDbkQ1QjY2?=
 =?utf-8?B?N2xnbGdhYXRkL0dPNFQzcm5MTkIrL25JTW9BRG04U05EN0tOSERrTjF4ZUcv?=
 =?utf-8?B?MWRIeXNTbXV1YVRweG5YRWIvbWs4UmpxY3R5ZzA0STVYSFkxTDRwSHZpd1Ew?=
 =?utf-8?B?NE9WYkRJZi9JTkc0OGVDdlRya1ExTlErb3VrS00zOVFGVnhGUjdTVFFJYm1L?=
 =?utf-8?B?ZHhkNHJDTDIvWU8zdnZuWGZQZ0dxaE9tUHBCWWhYVjUzdGZJdlVvaUNUbkdH?=
 =?utf-8?B?cnZlK3Nlbko4YkY4dXlPemZ0dEhuWWZkYVJuT0p3NHhuU1J0RkYrSmhUelA2?=
 =?utf-8?B?d1ZFbkhKRERYTVZraDNoNDkrdTc5WjlyOWFKVitHMU9KWDdoME5wc0RZQlNa?=
 =?utf-8?B?KzNaWVNkckxBTzhiSVhKNVpmcGdlT3hKNDNFR1FDY3N2ZFRCUlhLZnpIcmc4?=
 =?utf-8?B?L2JDa3pIYml6a3JPaWxuWWxRZ2QxdkwxTFJqRlpjMzdRaDdrRUpOVk1IYURv?=
 =?utf-8?B?Wjg5cVhIV1ZjNjBadGdIOHp6dkUyTEFsTkFIOXNuNGw5WGVzYmxIMWwwZnpE?=
 =?utf-8?Q?8JEQ/bbsEyqVmLLxZJjavqOpbfewTHZ35FQCmh4nMY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DB0491CAF23ACC468EF8BD02BCBCFBFB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf89d5b0-3acf-4c05-8db6-08daf5741c06
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2023 14:40:26.1080
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lG9iQsqXV3qgsUh/p/bhDM4dnmAeAWIVPT6FVquwzbK+1Wv5sMRo4WwOOCijacu8xNdH91dl0Q4QdSdlGtLLgqA/Rjo3gpvK5kMURVEP2l4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5055
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQ2xlbWVudCwNCk9uIFdlZCwgMjAyMy0wMS0xMSBhdCAxMjo1NiArMDEwMCwgQ2zDqW1lbnQg
TMOpZ2VyIHdyb3RlOg0KPiBBZGQgc3VwcG9ydCBmb3IgdmxhbiBvcGVyYXRpb24gKGFkZCwgZGVs
LCBmaWx0ZXJpbmcpIG9uIHRoZSBSWk4xDQo+IGRyaXZlci4gVGhlIGE1cHN3IHN3aXRjaCBzdXBw
b3J0cyB1cCB0byAzMiBWTEFOIElEcyB3aXRoIGZpbHRlcmluZywNCj4gdGFnZ2VkL3VudGFnZ2Vk
IFZMQU5zIGFuZCBQVklEIGZvciBlYWNoIHBvcnRzLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQ2zD
qW1lbnQgTMOpZ2VyIDxjbGVtZW50LmxlZ2VyQGJvb3RsaW4uY29tPg0KPiAtLS0NCj4gIGRyaXZl
cnMvbmV0L2RzYS9yem4xX2E1cHN3LmMgfCAxODINCj4gKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysNCj4gIGRyaXZlcnMvbmV0L2RzYS9yem4xX2E1cHN3LmggfCAgMTAgKy0NCj4g
IDIgZmlsZXMgY2hhbmdlZCwgMTg5IGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pDQo+IA0K
PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZHNhL3J6bjFfYTVwc3cuYw0KPiBiL2RyaXZlcnMv
bmV0L2RzYS9yem4xX2E1cHN3LmMNCj4gaW5kZXggZWQ0MTNkNTU1YmVjLi44ZWNiOTIxNGI1ZTYg
MTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2RzYS9yem4xX2E1cHN3LmMNCj4gKysrIGIvZHJp
dmVycy9uZXQvZHNhL3J6bjFfYTVwc3cuYw0KPiBAQCAtNTQwLDYgKzU0MCwxNjEgQEAgc3RhdGlj
IGludCBhNXBzd19wb3J0X2ZkYl9kdW1wKHN0cnVjdA0KPiBkc2Ffc3dpdGNoICpkcywgaW50IHBv
cnQsDQo+ICAJcmV0dXJuIHJldDsNCj4gIH0NCj4gIA0KPiArc3RhdGljIGludCBhNXBzd19wb3J0
X3ZsYW5fZmlsdGVyaW5nKHN0cnVjdCBkc2Ffc3dpdGNoICpkcywgaW50DQo+IHBvcnQsDQo+ICsJ
CQkJICAgICBib29sIHZsYW5fZmlsdGVyaW5nLA0KPiArCQkJCSAgICAgc3RydWN0IG5ldGxpbmtf
ZXh0X2FjayAqZXh0YWNrKQ0KPiArew0KPiArCXUzMiBtYXNrID0gQklUKHBvcnQgKyBBNVBTV19W
TEFOX1ZFUklfU0hJRlQpDQo+ICsJCSAgIHwgQklUKHBvcnQgKyBBNVBTV19WTEFOX0RJU0NfU0hJ
RlQpOw0KDQpPcGVyYXRvciB8IGF0IHRoZSBlbmQgb2YgbGluZQ0KDQo+ICsJc3RydWN0IGE1cHN3
ICphNXBzdyA9IGRzLT5wcml2Ow0KPiArCXUzMiB2YWwgPSAwOw0KPiArDQo+ICsJaWYgKHZsYW5f
ZmlsdGVyaW5nKQ0KPiArCQl2YWwgPSBCSVQocG9ydCArIEE1UFNXX1ZMQU5fVkVSSV9TSElGVCkN
Cj4gKwkJICAgICAgfCBCSVQocG9ydCArIEE1UFNXX1ZMQU5fRElTQ19TSElGVCk7DQoNCk9wZXJh
dG9yIHwgYXQgdGhlIGVuZCBvZiBsaW5lDQoNCj4gKw0KPiArCWE1cHN3X3JlZ19ybXcoYTVwc3cs
IEE1UFNXX1ZMQU5fVkVSSUZZLCBtYXNrLCB2YWwpOw0KPiArDQo+ICsJcmV0dXJuIDA7DQo+ICt9
DQo+ICsNCj4gK3N0YXRpYyBpbnQgYTVwc3dfcG9ydF92bGFuX2FkZChzdHJ1Y3QgZHNhX3N3aXRj
aCAqZHMsIGludCBwb3J0LA0KPiArCQkJICAgICAgIGNvbnN0IHN0cnVjdCBzd2l0Y2hkZXZfb2Jq
X3BvcnRfdmxhbg0KPiAqdmxhbiwNCj4gKwkJCSAgICAgICBzdHJ1Y3QgbmV0bGlua19leHRfYWNr
ICpleHRhY2spDQo+ICt7DQo+ICsJYm9vbCB0YWdnZWQgPSAhKHZsYW4tPmZsYWdzICYgQlJJREdF
X1ZMQU5fSU5GT19VTlRBR0dFRCk7DQo+ICsJYm9vbCBwdmlkID0gdmxhbi0+ZmxhZ3MgJiBCUklE
R0VfVkxBTl9JTkZPX1BWSUQ7DQo+ICsJc3RydWN0IGE1cHN3ICphNXBzdyA9IGRzLT5wcml2Ow0K
PiArCXUxNiB2aWQgPSB2bGFuLT52aWQ7DQo+ICsJaW50IHJldCA9IC1FSU5WQUw7DQo+ICsJaW50
IHZsYW5fcmVzX2lkOw0KPiArDQo+ICsJZGV2X2RiZyhhNXBzdy0+ZGV2LCAiQWRkIFZMQU4gJWQg
b24gcG9ydCAlZCwgJXMsICVzXG4iLA0KPiArCQl2aWQsIHBvcnQsIHRhZ2dlZCA/ICJ0YWdnZWQi
IDogInVudGFnZ2VkIiwNCj4gKwkJcHZpZCA/ICJQVklEIiA6ICJubyBQVklEIik7DQo+ICsNCj4g
KwltdXRleF9sb2NrKCZhNXBzdy0+dmxhbl9sb2NrKTsNCj4gKw0KPiArCXZsYW5fcmVzX2lkID0g
YTVwc3dfZmluZF92bGFuX2VudHJ5KGE1cHN3LCB2aWQpOw0KPiArCWlmICh2bGFuX3Jlc19pZCA8
IDApIHsNCj4gKwkJdmxhbl9yZXNfaWQgPSBhNXBzd19nZXRfdmxhbl9yZXNfZW50cnkoYTVwc3cs
IHZpZCk7DQo+ICsJCWlmICh2bGFuX3Jlc19pZCA8IDApDQoNCm5pdDogV2UgY2FuIGluaXRpYWxp
emUgcmV0ID0gMCBpbml0aWFsbHksIGFuZCBhc3NpZ24gcmV0ID0gLUVJTlZBTCBoZXJlDQomIHJl
bW92ZSByZXQgPSAwIGF0IGVuZCBvZiBmdW5jdGlvbi4NCg0KPiArCQkJZ290byBvdXQ7DQo+ICsJ
fQ0KPiArDQo+ICsJYTVwc3dfcG9ydF92bGFuX2NmZyhhNXBzdywgdmxhbl9yZXNfaWQsIHBvcnQs
IHRydWUpOw0KPiArCWlmICh0YWdnZWQpDQo+ICsJCWE1cHN3X3BvcnRfdmxhbl90YWdnZWRfY2Zn
KGE1cHN3LCB2bGFuX3Jlc19pZCwgcG9ydCwNCj4gdHJ1ZSk7DQo+ICsNCj4gKwlpZiAocHZpZCkg
ew0KPiArCQlhNXBzd19yZWdfcm13KGE1cHN3LCBBNVBTV19WTEFOX0lOX01PREVfRU5BLCBCSVQo
cG9ydCksDQo+ICsJCQkgICAgICBCSVQocG9ydCkpOw0KPiArCQlhNXBzd19yZWdfd3JpdGVsKGE1
cHN3LCBBNVBTV19TWVNURU1fVEFHSU5GTyhwb3J0KSwNCj4gdmlkKTsNCj4gKwl9DQo+ICsNCj4g
KwlyZXQgPSAwOw0KPiArb3V0Og0KPiArCW11dGV4X3VubG9jaygmYTVwc3ctPnZsYW5fbG9jayk7
DQo+ICsNCj4gKwlyZXR1cm4gcmV0Ow0KPiArfQ0KPiArDQo+ICtzdGF0aWMgaW50IGE1cHN3X3Bv
cnRfdmxhbl9kZWwoc3RydWN0IGRzYV9zd2l0Y2ggKmRzLCBpbnQgcG9ydCwNCj4gKwkJCSAgICAg
ICBjb25zdCBzdHJ1Y3Qgc3dpdGNoZGV2X29ial9wb3J0X3ZsYW4NCj4gKnZsYW4pDQo+ICt7DQo+
ICsJc3RydWN0IGE1cHN3ICphNXBzdyA9IGRzLT5wcml2Ow0KPiArCXUxNiB2aWQgPSB2bGFuLT52
aWQ7DQo+ICsJaW50IHJldCA9IC1FSU5WQUw7DQoNClNpbWlsbGFybHkgaGVyZS4NCg0KPiArCWlu
dCB2bGFuX3Jlc19pZDsNCj4gKw0KPiArCWRldl9kYmcoYTVwc3ctPmRldiwgIlJlbW92aW5nIFZM
QU4gJWQgb24gcG9ydCAlZFxuIiwgdmlkLA0KPiBwb3J0KTsNCj4gKw0KPiArCW11dGV4X2xvY2so
JmE1cHN3LT52bGFuX2xvY2spOw0KPiArDQo+ICsJdmxhbl9yZXNfaWQgPSBhNXBzd19maW5kX3Zs
YW5fZW50cnkoYTVwc3csIHZpZCk7DQo+ICsJaWYgKHZsYW5fcmVzX2lkIDwgMCkNCj4gKwkJZ290
byBvdXQ7DQo+ICsNCj4gKwlhNXBzd19wb3J0X3ZsYW5fY2ZnKGE1cHN3LCB2bGFuX3Jlc19pZCwg
cG9ydCwgZmFsc2UpOw0KPiArCWE1cHN3X3BvcnRfdmxhbl90YWdnZWRfY2ZnKGE1cHN3LCB2bGFu
X3Jlc19pZCwgcG9ydCwgZmFsc2UpOw0KPiArDQo+ICsJLyogRGlzYWJsZSBQVklEIGlmIHRoZSB2
aWQgaXMgbWF0Y2hpbmcgdGhlIHBvcnQgb25lICovDQo+ICsJaWYgKHZpZCA9PSBhNXBzd19yZWdf
cmVhZGwoYTVwc3csIEE1UFNXX1NZU1RFTV9UQUdJTkZPKHBvcnQpKSkNCj4gKwkJYTVwc3dfcmVn
X3JtdyhhNXBzdywgQTVQU1dfVkxBTl9JTl9NT0RFX0VOQSwgQklUKHBvcnQpLA0KPiAwKTsNCj4g
Kw0KPiArCXJldCA9IDA7DQo+ICtvdXQ6DQo+ICsJbXV0ZXhfdW5sb2NrKCZhNXBzdy0+dmxhbl9s
b2NrKTsNCj4gKw0KPiArCXJldHVybiByZXQ7DQo+ICt9DQo+ICsNCj4gDQo=
