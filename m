Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BE076C7688
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 05:20:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230430AbjCXEUw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 00:20:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjCXEUu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 00:20:50 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D882123A72;
        Thu, 23 Mar 2023 21:20:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1679631650; x=1711167650;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=AzbHE4A/jDYgzZSs4AqsjFAtOrug3PM2zbGtXy+LmYs=;
  b=LH/bLOF81GQoIwInNY/JddW0UWINqu7mUuFfFglBbtt5Kuf1so9dpMfV
   gWhgi28cGGAzYJCCgBGxYBGhwQILx9sRR/O261dn5TQY/nbB7dMrlGShi
   +O26i1T7FDU8o73IT0cONSmO8XXLM46NBKA+3Q1I9tzLL1yRurcYDivTB
   PFhZKxWKJ7l5ig/rPJ3d4GakP9jJ0VqqqniUuJ1kgd2yhsiCtl+eQrOXb
   rtbfQe/kzYzarPZeQboZxb8j200xWTfj0ByZqghUlI6y9WaNSlO2Jrk4V
   1s44BsHXBazh5jIaxz1H+CW6rSaOyjtnfo/nbtf7U4MQX1qYTOsshU0wb
   g==;
X-IronPort-AV: E=Sophos;i="5.98,286,1673938800"; 
   d="scan'208";a="206522763"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Mar 2023 21:20:49 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 23 Mar 2023 21:20:48 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Thu, 23 Mar 2023 21:20:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cqDTc/W0WDCwLYT736rauMlpZ3RaqZM8UqZqAII2bmGAl9nWjWJPhlMDhrBRBkfdJEuZHuuDOXxZIafnyJ/OC2AVtHZ8kz4B079rUF4QWk4z+N2EwOKV+pnoV6K5xm1dQCQXZwuKaP3a0IGiFcIAjcaGQPDDSoY4cQPc/4Giqg0E0be3UZTEcNp/63AlYVrJPhgQKCfsf3tgnyhOMzNKME/mDgESd5LZ2Q5pbgxGmxXa9cP+AloTnM/zEy3ynDcJkAviL+GvRHlJYiNKfuAi4WvpnA34XiFgRTbu9JuV/tCPRwW/qhFLbIdAMcdRjcrszIfp/qPw9cY2VEWwPiJ5fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AzbHE4A/jDYgzZSs4AqsjFAtOrug3PM2zbGtXy+LmYs=;
 b=nZvIUQXRBlnwqnEGeHumJzT6qUdG5yg5Y8G1c1q5Urs/ym5drt/uNogE0X9ZLRs0WoLAt8mgtee6s9IJAJPrrdDIF6w4M2gqVOLbpKyUNxIAaViYo27A5kcZ8t03JNUEelPV6JV9lYnRaSve1OWSSvpcaJmqfbzJQTCdNTHCjqvJ7HaU0wFPvvW31lE+i4VuhqGaxceyhxZhTGxRRubFDokboYWhY8YnF2msjw5gvoslwTsBxho1puE3IzJHeLAgUuhOxw7bLj6ltxjOLN+SIQ7a4zwCgDOJE39QZ9QWapCDPUAuDZze7apxX/U9SKNUBy+W63KDfT5tmGSpJ2N5pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AzbHE4A/jDYgzZSs4AqsjFAtOrug3PM2zbGtXy+LmYs=;
 b=r9ZOBA7JPK/TsaG4+JU4E+187e/PNPA6pDNIcO4BmRuNhxarBqNkiiu5L/b4RFDLGifl5ceVINzkJnCZ4O/U8iJfAMUmH3yQ2uMIDB1ijICHxPQPrdYOAbsr8pxkpyyXEZTzrXYw1cKgyhPaghAuQf6XRUhK96n/Lxaykbb4Kyg=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 PH8PR11MB7047.namprd11.prod.outlook.com (2603:10b6:510:215::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.38; Fri, 24 Mar 2023 04:20:47 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::cbd2:3e6c:cad1:1a00]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::cbd2:3e6c:cad1:1a00%3]) with mapi id 15.20.6178.037; Fri, 24 Mar 2023
 04:20:46 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <olteanv@gmail.com>, <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <kuba@kernel.org>, <edumazet@google.com>, <pabeni@redhat.com>,
        <o.rempel@pengutronix.de>, <Woojung.Huh@microchip.com>,
        <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <kernel@pengutronix.de>
Subject: Re: [PATCH net v1 1/6] net: dsa: microchip: ksz8: fix ksz8_fdb_dump()
Thread-Topic: [PATCH net v1 1/6] net: dsa: microchip: ksz8: fix
 ksz8_fdb_dump()
Thread-Index: AQHZXMtIQ2LJiMYnsU+11b6LpyHTYK8JVmwA
Date:   Fri, 24 Mar 2023 04:20:46 +0000
Message-ID: <9136556f659339dafcaa5a648aabb930bc37887d.camel@microchip.com>
References: <20230322143130.1432106-1-o.rempel@pengutronix.de>
         <20230322143130.1432106-2-o.rempel@pengutronix.de>
In-Reply-To: <20230322143130.1432106-2-o.rempel@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB0076:EE_|PH8PR11MB7047:EE_
x-ms-office365-filtering-correlation-id: ba341aff-5862-45b4-e9a5-08db2c1f245e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8xI8cBrTxBlJuQ/3zNCFb/Qt03AfFY6UVHb4pLlX85KrOaE9lclqnWqvtM63NbRpzzBzFvGTDFhKlyPZYqu+vMjnKDlb11DtuEeR4FCt2bd4IizfYM6tGqemObFY6kBXYHgkXo3BwgMzbQ0dRtbZU+dDN1VxUgWRTUD9FrzqYiQKMco/YwmY0JmuZafbeLyiR848kSskbzunNyvnYpzf0nes16hPB8tFbkQiclcPWs16oyjDq8vMlo8gtj7ianVWT7wBFhGZCONh5/RNRqY9+pztQFrDreZmWXtsRoYuY4vtnDxN+AdA976L/p6LLTbleJxTZTROj8oZ2bzwWzZeLJUrtcHCwNuPCMhL7VeBRJZsu3cpLZhL3jYB59lbAFjZifUhGBYtES7MkULMNx2qqiiuWh7nfGc+9/01HWerH0YqWBlwGTIuQRsLmsonYdCPVvMsCdLUCN9qk2wtSbbG4+L0O71Eu/fDiHmGu4ixzw0qcecKC7cFmVa3lwY34i/eMtXEq/eKxobPfXAr6o8TUJFwNoUijCZPau03uJZtAW24MJ1FXI8yr+lc04OMTCWo2QUpAPmeiXvC60Amtyv92LDdpYHiORLwD6WlAqs8VoDbgZsSCD+PPJA3JZGzWWxIzRyp6lWMMtZ+KNUyEYxBUBbjv1QNnand5lA5pp6qAsJRu0LgXz//elaob8NlqnQ/XONCVqiBuPxLobj76z9fycy+kdJGJzDgg4HFKEi8jhY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(39860400002)(396003)(366004)(346002)(136003)(451199018)(38100700002)(122000001)(36756003)(91956017)(76116006)(110136005)(86362001)(66446008)(66476007)(66556008)(66946007)(64756008)(316002)(54906003)(71200400001)(478600001)(38070700005)(6486002)(83380400001)(6506007)(2616005)(26005)(6512007)(186003)(8676002)(2906002)(7416002)(5660300002)(8936002)(41300700001)(4326008)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cHJQejlmSDJuc1l3c0VtcTQ4ZDRGcGFUeEQyVjBQaE54NFg3OVlnaVh0L3RC?=
 =?utf-8?B?ck1YT3dRWUtTaUtsSjlqcmZTcmsvMXI5UXd6Z0lVN1kyaDZ2bXk2azFCYjhY?=
 =?utf-8?B?Z3YxZUJPd0d0cUNSekpSR2U5cjlCK0pLaG01MWRPQVdweVJQSUZCWnF1bGpt?=
 =?utf-8?B?K2FWUnhWL0V0dFZpR29mb2pwWU9kVE9oMExhN25PaDhXSXE5K2hCVGVDd0tS?=
 =?utf-8?B?MGVJRFpNeE5BVzRsNzVaSktNeEZMVzF4MUJiRGhuQUFtVndtdm9SN0I0YUtP?=
 =?utf-8?B?NEJJQjU1c2ViMlBhOTJyTGZkM2w0ekJNRnY0M1B4czZnckxzTkZYM2YwK2p2?=
 =?utf-8?B?MmwwMVAvMGJ6SW4vWXM4SUhlZ0dKTUZNNTF3YWtwbjM3bTFpOEtTWFp1VlFt?=
 =?utf-8?B?RzdMQ2hWL0QwM2laMDdSd0o0YWRKdXdWdk4yWGFJK2g5US9wNGplV2FnWTAv?=
 =?utf-8?B?bE1YbnpST3prM1UrRmU2NlFMWUhRV2I1VlpQajA4UlVYdmcvQVlPQS94dkFo?=
 =?utf-8?B?eTQ0OHdXUlc1Q1dSdWdhdlpNcXdYTVd4RG9KQzJacFVrUlhESWl0MG1uZmYr?=
 =?utf-8?B?YVBNRlhyZjRBbTNiMWo1ZTJ0OXJBU1FqS2pCRFdSUCtSRm8xemo4bkhmR3pH?=
 =?utf-8?B?ZmxYRWIxNzRnWUxaQ2JDdTZKSWQxaDh5cldNek1TTlJ3bzFLSUxKVldxekUz?=
 =?utf-8?B?a3ZLK1JyVUx0ZGZTWWFINVR6TlB4UEhlSDEvaXlicGVSRGVMMXFSekJXZnEx?=
 =?utf-8?B?U0xFWTVHYjVGRHN2cHNZVkREbW1Namk2NVBLd0E5OE5yOXZaczdTa0tVRzZy?=
 =?utf-8?B?ZXBoRGNuT2dWaEVIK3BCc1NmMWhCVi9WSmdCbmdoUmx2WCs2L0hQYUJHN0hK?=
 =?utf-8?B?akFWZnRVbGViK1pRbGlQUFQ4RkJZenF6Q2lHa0pPY01IcVV2SmhENkVZbGkr?=
 =?utf-8?B?RlE1UnNPeDI2RGl6VG95Yk94aEpvc0Z6YUsrZWI2S2F2d1dRb2UyMXlIM3Uw?=
 =?utf-8?B?NFRaazFhNU1TUlQ2QlpzOXZaS3Ewd05sc2NHVkJIUytJWmE0NXpIVXZXYW9K?=
 =?utf-8?B?VlJQRkk0ZlNYOVNJMDVydUVLWXVWdFhhMU5Dcm9DM2Q2TjFTRFA5aGhZa1Vp?=
 =?utf-8?B?Vkduam5xYUd3NVZWYmw2NEM4dzRQU1BrRGZwSDlJV0RGNU5ucyszMWtBSGVD?=
 =?utf-8?B?V254Wk12WDhWQnIrOEdNUzBJcFQzQktuSHJFMzJCVElRNTMxcTAzdlpuZzVX?=
 =?utf-8?B?SFU1bTd1Kzl4Kzc5b1FobkJoY2lHY2V1VEJpU2QwSnE1ejAweWpRKzlJbVJi?=
 =?utf-8?B?N3lSMUNubCt0a0tHb3UybEN0SDNBcUVWNi9FRm9MZElDaE4wbmQ0MFFKRzFt?=
 =?utf-8?B?ZGJpUHAvb1BBTU0vbzBEVURLcEhzK3FYbGxWMjFBSVBxdW1lMEN1WDlDYmt5?=
 =?utf-8?B?aVZNaDJNcFhKUko5bUhNZFhHbldHSlY1OWFGRm9YSWRjbjhSeVpHM1hic0k0?=
 =?utf-8?B?TjZCMVg2aWQrU2I0VDlVN0pNSEVKRmJkRkZBd3pwTzJJU0hzdVFqVnlqWFFp?=
 =?utf-8?B?UTJpWVZiaWd5Zy9lbEloMXBOYUY3M2tFRWszb2dCY1ZnZS94UmQ5SEs4Nit5?=
 =?utf-8?B?N3NncU50aHZIOUk2OTZuQ3E2NjhRbXl3akM1dkg3bU1nTDZPQWt2R3BPQ0V3?=
 =?utf-8?B?bzBPL090ak51WEpvdyszSVRJK0hhVGRZd2hLQTVTTTh0akdHNi9GbFBmdEVI?=
 =?utf-8?B?elZ6S2h5TlpIcnBxSjFnWG9xVFFVZ3ExM2ltM1cwWk4yZnFlb2dYMUhIRzdv?=
 =?utf-8?B?QVhOSmMwRG93ZW5JWlNMcjZIZHV0QnVUOVVsMFlXUklscTA2VEx2UFJqSzQw?=
 =?utf-8?B?MVJPRkxlMFgxbmdjRHc3cStiekQzQm1CVjNDQUxhWWRPdGhCSEJNQWk3UjNh?=
 =?utf-8?B?UEZNYWdTSVpIbm9pRmpRVW5mMkZ2RlpuRnY1bld2MHZERWNLc3QzSnBEeGk0?=
 =?utf-8?B?Znl5M0piQWo2MERZMjQ0T2x3b3krNUJyei9xRTJQRzN0RDRmZE81bnI1Rk01?=
 =?utf-8?B?bTVlV05CaWJmdmtxRUJaVjUxZ1VkMjZ1aGoyQWlGazUveVArWnJraWxhOHdh?=
 =?utf-8?B?ci94VUJYL0JGZXVjU2ZjamRpSC8wNXI3WU8rV1ZQZWV5UWFqVDN1TTNaMXlv?=
 =?utf-8?Q?xgV/ywRVIA1Ga/iPQyG8uhY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <744394DE54D6BF4EA73614C73A20558B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba341aff-5862-45b4-e9a5-08db2c1f245e
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Mar 2023 04:20:46.8240
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1vZ0GywnlRxqzberXMv5L5Rqo5t5tJYnnjgp5XWDu2vrqLFhOjoJFXWFB35p8qRSG/fOh9BK1GWA06eZSVPCImRv2IU8dWmM3kZDItuB6ZY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7047
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgT2xla3NpaiwNCg0KT24gV2VkLCAyMDIzLTAzLTIyIGF0IDE1OjMxICswMTAwLCBPbGVrc2lq
IFJlbXBlbCB3cm90ZToNCj4gRVhURVJOQUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBv
cGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3UNCj4ga25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo+
IA0KPiBCZWZvcmUgdGhpcyBwYXRjaCwgdGhlIGtzejhfZmRiX2R1bXAoKSBmdW5jdGlvbiBoYWQg
c2V2ZXJhbCBpc3N1ZXMsDQo+IHN1Y2gNCj4gYXMgdW5pbml0aWFsaXplZCB2YXJpYWJsZXMgYW5k
IGluY29ycmVjdCB1c2FnZSBvZiBzb3VyY2UgcG9ydCBhcyBhDQo+IGJpdA0KPiBtYXNrLiBUaGVz
ZSBwcm9ibGVtcyBjYXVzZWQgaW5hY2N1cmF0ZSByZXBvcnRpbmcgb2YgdmlkIGluZm9ybWF0aW9u
DQo+IGFuZA0KPiBwb3J0IGFzc2lnbm1lbnQgaW4gdGhlIGJyaWRnZSBmZGIuDQo+IA0KPiBGaXhl
czogZTU4N2JlNzU5ZTZlICgibmV0OiBkc2E6IG1pY3JvY2hpcDogdXBkYXRlIGZkYiBhZGQvZGVs
L2R1bXAgaW4NCj4ga3N6X2NvbW1vbiIpDQo+IFNpZ25lZC1vZmYtYnk6IE9sZWtzaWogUmVtcGVs
IDxvLnJlbXBlbEBwZW5ndXRyb25peC5kZT4NCj4gLS0tDQo+ICBkcml2ZXJzL25ldC9kc2EvbWlj
cm9jaGlwL2tzejg3OTUuYyB8IDExICsrKysrLS0tLS0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgNSBp
bnNlcnRpb25zKCspLCA2IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMv
bmV0L2RzYS9taWNyb2NoaXAva3N6ODc5NS5jDQo+IGIvZHJpdmVycy9uZXQvZHNhL21pY3JvY2hp
cC9rc3o4Nzk1LmMNCj4gaW5kZXggMDAzYjBhYzI4NTRjLi4zZmZmZDVkYThkM2IgMTAwNjQ0DQo+
IC0tLSBhL2RyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6ODc5NS5jDQo+ICsrKyBiL2RyaXZl
cnMvbmV0L2RzYS9taWNyb2NoaXAva3N6ODc5NS5jDQo+IEBAIC05NTgsMTUgKzk1OCwxNCBAQCBp
bnQga3N6OF9mZGJfZHVtcChzdHJ1Y3Qga3N6X2RldmljZSAqZGV2LCBpbnQNCj4gcG9ydCwNCj4g
ICAgICAgICB1MTYgZW50cmllcyA9IDA7DQo+ICAgICAgICAgdTggdGltZXN0YW1wID0gMDsNCj4g
ICAgICAgICB1OCBmaWQ7DQo+IC0gICAgICAgdTggbWVtYmVyOw0KPiAtICAgICAgIHN0cnVjdCBh
bHVfc3RydWN0IGFsdTsNCj4gKyAgICAgICB1OCBzcmNfcG9ydDsNCj4gKyAgICAgICB1OCBtYWNb
RVRIX0FMRU5dOw0KPiANCj4gICAgICAgICBkbyB7DQo+IC0gICAgICAgICAgICAgICBhbHUuaXNf
c3RhdGljID0gZmFsc2U7DQo+IC0gICAgICAgICAgICAgICByZXQgPSBrc3o4X3JfZHluX21hY190
YWJsZShkZXYsIGksIGFsdS5tYWMsICZmaWQsDQo+ICZtZW1iZXIsDQo+ICsgICAgICAgICAgICAg
ICByZXQgPSBrc3o4X3JfZHluX21hY190YWJsZShkZXYsIGksIG1hYywgJmZpZCwNCj4gJnNyY19w
b3J0LA0KPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgJnRpbWVz
dGFtcCwgJmVudHJpZXMpOw0KPiAtICAgICAgICAgICAgICAgaWYgKCFyZXQgJiYgKG1lbWJlciAm
IEJJVChwb3J0KSkpIHsNCj4gLSAgICAgICAgICAgICAgICAgICAgICAgcmV0ID0gY2IoYWx1Lm1h
YywgYWx1LmZpZCwgYWx1LmlzX3N0YXRpYywNCj4gZGF0YSk7DQo+ICsgICAgICAgICAgICAgICBp
ZiAoIXJldCAmJiBwb3J0ID09IHNyY19wb3J0KSB7DQoNCk9ubHkgaW4gS1NaOTQ3NyBzZXJpZXMs
IGl0IGlzIEJJVChwb3J0KS4gRm9yIHRoZSBLU1o4N3h4IGFuZCBLU1o4OHh4LA0KaXQgaXMgbGlr
ZSBsb2dpYyB0YWJsZS4gaS5lIA0KMDAgPSBwb3J0IDANCjAxID0gcG9ydCAxDQowMiA9IHBvcnQg
Mg0KDQpDcm9zcyBWZXJpZmllZCB3aXRoIHRoZSBEYXRhc2hlZXQuDQoNCkFja2VkLWJ5OiBBcnVu
IFJhbWFkb3NzIDxhcnVuLnJhbWFkb3NzQG1pY3JvY2hpcC5jb20+DQoNCg0KPiArICAgICAgICAg
ICAgICAgICAgICAgICByZXQgPSBjYihtYWMsIGZpZCwgZmFsc2UsIGRhdGEpOw0KPiAgICAgICAg
ICAgICAgICAgICAgICAgICBpZiAocmV0KQ0KPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIGJyZWFrOw0KPiAgICAgICAgICAgICAgICAgfQ0KPiAtLQ0KPiAyLjMwLjINCj4gDQo=
