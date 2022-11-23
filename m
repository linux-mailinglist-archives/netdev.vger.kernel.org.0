Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E10B66360FC
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 15:03:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238424AbiKWODV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 09:03:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237822AbiKWODC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 09:03:02 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1699259156;
        Wed, 23 Nov 2022 05:57:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669211891; x=1700747891;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=2WsOys/D1S16ocoYt/KyC+26LWgqmktVZieLOJwn2bk=;
  b=aZYIkPwq4qBlhuJNF5/2lmvwrPjaoQpjb9NZeYjZ0TljPARptzBbw/Rs
   LsT4mpcIvKIcCJRUdTCKJ5rVjE+rD80hmn1/cHLImQROAPJC6POY36BHd
   h+hx1RRPatF4B1wNRcOtMFzM7brUnxYwGgm+zIgrfBZJ/kVnubpOH90nf
   HlWTulUhRKDTTw9wv6dWCM3tzwDlA2fTX4YpreGjkZ+cFxar8yf0D2aIm
   E3REwhQaayClrdS0sRhBPACnlbaDqcDR/+FX/364GeRvt4sIHETm8gB7A
   FkMaKjQNsGGRaiTVZY7mvoxXf4KWyDzq542k7BQWROBl8OGXkwgNKmVRg
   g==;
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="184862492"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Nov 2022 06:57:55 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 23 Nov 2022 06:57:52 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12 via Frontend Transport; Wed, 23 Nov 2022 06:57:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JTV96yioj8JmrLs3cd8NjcFOmFRE/7+wzuNFMN0DO/O7PZOzj8nQHiZ6aw15ieKRkd02Ukqy0Qycoj0Ox7+QaJlIFdKMMD/YxUaiI2wMe05w6+Th2BTaE50v4yKwZkPAoHYBvD8QmrPAxg6kROLcniD4P39cqpeSGnyEaroh0vQmCaC9mv20z3YrKxh4wm3V+Fkgwx8FTdZkMGXL3wHIXIkbaBY12Lov0H7sJoa1gQZtW7yOg20SF0m7wQ7UvN6I5LS/G0dhE8YtifUJhbIACslz9DyPdBbRjhXWVBPW1IsGe1IGliN24lPbawwo+Ncm7ruxcpxIbm+qbHwxypw3IQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2WsOys/D1S16ocoYt/KyC+26LWgqmktVZieLOJwn2bk=;
 b=h/aUiAxoGW2//PlCYwS9Vfu7x83cl9wUDnnY7K4n4Fu8WTZ8LEvfHpGr8c8iZdFh3wWWwlJLly3XF5rdS2a5eHSQaFp8W/w3QN3YWYQ54UCq2oL/4PLBwAFFx09XehLV7rainv6VBPfctEppBFqTbWfSyia53nNoSMafv+uUIjywMer/utH+6Q4O/VwKrAUC+AUSsEr+AhDbfl5K15B4xJwBAoZ2BymS8wvMUOk5yua8jiEDCqM1MY1kdYw4DsA1a1w+1Jz2Tiyd++qqBuQdvy2bqQMc4oDHK1buincClfOb3uDyPD7BYQjyhqebIG4W+VbHpri5hUCl4UmK96Fpmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2WsOys/D1S16ocoYt/KyC+26LWgqmktVZieLOJwn2bk=;
 b=TQWFZ2vY5Nbg/Vaww+pohq6qaYc9b9L+Da1iLZjPsgw4Nksr1Nu4pw6+mDSt4ZE3y68xVnYk4+VFSJg6ESdj7ESYtDVpu5zyqEsRf2olmMf+MMnyLsPkM0cH6VWDqLrtPopqiUYaCsQNSYabe5o+2IerXvzCAMEcZEB0sDT0MHQ=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 SN7PR11MB7511.namprd11.prod.outlook.com (2603:10b6:806:347::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.17; Wed, 23 Nov
 2022 13:57:49 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::9b7a:7604:7a30:1953]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::9b7a:7604:7a30:1953%7]) with mapi id 15.20.5857.018; Wed, 23 Nov 2022
 13:57:47 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <olteanv@gmail.com>
CC:     <andrew@lunn.ch>, <linux-kernel@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <vivien.didelot@gmail.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>,
        <f.fainelli@gmail.com>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <richardcochran@gmail.com>,
        <netdev@vger.kernel.org>, <Woojung.Huh@microchip.com>,
        <davem@davemloft.net>
Subject: Re: [RFC Patch net-next v2 3/8] net: dsa: microchip: Initial hardware
 time stamping support
Thread-Topic: [RFC Patch net-next v2 3/8] net: dsa: microchip: Initial
 hardware time stamping support
Thread-Index: AQHY/b/imAgaAgzTi0Cq9JpLcCQfmK5KAikAgAKJeAA=
Date:   Wed, 23 Nov 2022 13:57:47 +0000
Message-ID: <298f4117872301da3e4fe4fed221f51e9faab5d0.camel@microchip.com>
References: <20221121154150.9573-1-arun.ramadoss@microchip.com>
         <20221121154150.9573-4-arun.ramadoss@microchip.com>
         <20221121231314.kabhej6ae6bl3qtj@skbuf>
In-Reply-To: <20221121231314.kabhej6ae6bl3qtj@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB0076:EE_|SN7PR11MB7511:EE_
x-ms-office365-filtering-correlation-id: 093b73c4-5111-445d-2e7f-08dacd5ab3a9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rxwbq61d1/nfrZnHhPvauIXRoT/E7f5SVwaPtVrL2dUpeXyGe5ebBTUQmDlCbzHZ2yJOgDwLUT4xrcjPeC5ZlIvC/ssMUb1lEcLT/h8VQhFwTBXtfq+8c6TkTWSK5+Pcu0WElqcBAPH1lDwqwA+zrI2AWytVhCPcn8RRVStob8Ue8F2cV1QoZ2olqdjAqFvLXHDZe+EoJg7fx0MIp2zelRzOGcorzMj4j75rqgqM/jYBXiPL8yH4cV9vP+/HkZBumQSj2CSf9xFhIVXe+PU2lxYq/z2oOlsjE5eleZCxRhje6Bl6HVfPKoQG9JTeMCBsWAhDIckIuiBniMyLSx5AjyHNxb0+LKoxk8rMrhkw5gcLg/nzmgQTX3d9xqoJnfzNrl34M02E5bVmcXeY4rfUBn+GbTFtDDy9at9yPZ0JEjgDpAZSguz0lPMxBNTm990eR5uuoAtUVPMPtdQ4wMfGNAnAzCGjyAz1ioFtKjuO+3EMECUIw51Ni8TcGjLb/iWCw4dC9uxaC8nZfoIBj9Z4XlCVs7xdX0Q9pahJ0UHEzpiT0+va68N1C7ygasnslJIFjI8LDQF6R/aNXKJ1uV/iE7+QtNw2zn/wkcZ9piXMq+BqbgVE2JypiNYqmNjs4iVVKujvRJdrxC+lpsmTiaW/HWEEnCOlOjE6aIQ3oiWTpLwaUtGpamPL1sb10t36rIQ7+81FnaAgEJPwMPf/xKprAlFg+2VR5fZPe5mm2GJCQ9s=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(136003)(366004)(346002)(39860400002)(451199015)(38100700002)(64756008)(8676002)(4326008)(122000001)(66476007)(66556008)(83380400001)(66446008)(66946007)(91956017)(76116006)(5660300002)(41300700001)(38070700005)(8936002)(4001150100001)(2906002)(86362001)(7416002)(36756003)(478600001)(6486002)(71200400001)(54906003)(6916009)(316002)(186003)(2616005)(6506007)(6512007)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bFYzNndxY09KNkcrK2hoZUF3U1ErZHJaQi9IZEc2UzJRTjFyT3VvZldmSzlZ?=
 =?utf-8?B?VkFPMmllejFsUGhpdCtIL0c2V1dlN2hkeHduc0tjT2MzVjdkQ3VPS2ZkbDVN?=
 =?utf-8?B?dkNFUG1Qb0tDV3M1MUs0V3BGUjRkalZjZ1JORnJ5WGhzVmJjZHlVU0NlUFlx?=
 =?utf-8?B?ZkJxWHluUUZ1NDdVTGF2amUyVWtmdEhEYk9YT2FoTFl2bk1zYWJuZUdCMW9U?=
 =?utf-8?B?UklOM3RDcHZjZWJUZ25kK0puKy9nc2hSWnBqU2J1N1dadGd1M2M5Z0FOUGhS?=
 =?utf-8?B?ZTFHU0REMys2Rm41OTY0NUcwOXN4bXBXQUJ5V1pEQ2E3V0QxSmhJc29LUllP?=
 =?utf-8?B?VkpzVW5FeDRHVlB5NkZCUE55WUhSSmtVcE83Uk1nSjQxeU1WQ3Y5OUtlcHJw?=
 =?utf-8?B?TUtReVNCNlpMeDRZN2FxdDl2RWxxV0l5VDJhY1BEWktSS2U5NTNVbUxrRWJz?=
 =?utf-8?B?NS9xQVk1L1k5QitZWDNOcnFQWHpGWUlLMWNEODhweDZkRGdBbEVLbU5JSnMx?=
 =?utf-8?B?NVRDVjJyS0dyQ0NqRG4yZ24zQ2NxblNkZVRsYU91aVZacFoxemxKK2dCMnky?=
 =?utf-8?B?UGw3YVBnRWlISWJ3R3IyK3BLUlkvZDhMQlR3WHJkV1g3cG5BMEhsQ0RVWkZi?=
 =?utf-8?B?aVI3ODZUN25VZUxKMVJKQ2NHeDJMcGZ6cC9UWDdibGlvQ2QzQkNRRmM3UDQz?=
 =?utf-8?B?Nk5HSkdZUzBzNTg1RFN6L1ZzMkp5MU8vdmFtcVZTcS9oQUlmZDJzQmloT1BI?=
 =?utf-8?B?M2ZIN0RLak8vVTA5ZjhnMGJoK3NxZFhnM1FqakZieERMTiswV0NBZU9TSkZu?=
 =?utf-8?B?ZjhhcjZwcVpkd25zTmtZMi9NOWFNcjJMQi9MaG1xN0JhdnNKQWdwK3g1ZG1m?=
 =?utf-8?B?aHRMdXMvRG12YnFtMlp0Tkd3Y3dFcklFSXZ0bFJFWXdjRnkzdUp3cjM4eWxs?=
 =?utf-8?B?TEFDNnRFdlRZUDl1S2xjRFlMNk5IT2szTDU5cjR4RDlzcGM2SWJvV0dFNWhU?=
 =?utf-8?B?Z28zT2srMXdlT01ZNEptZ1ZqbytYTE9WYWhzZXpWc2I2c1djMnV6S0ZNaTBn?=
 =?utf-8?B?Q25EYTY5cWg1REF5TGJ0emNlNUdGcEFQKzVVWitQS3B1d2ptcCs3ZEEzY1M0?=
 =?utf-8?B?UnB5SnJ0T0xkcEpidlc3a2xPVGE2cUJtYVJNV0VrUUIzbFJIM3l5WGlRSktQ?=
 =?utf-8?B?eGJDODM4M1dXdTdZUHZFSFJqY1hEOTNXbHdGSnF6d3hrNU5ZQ0xyT3ZIejR6?=
 =?utf-8?B?VjRzbzJzQlhUajV0R0drSE8ycDNmTWRWUG92eVBqSUo1dmRlYkcyQXlXVjFV?=
 =?utf-8?B?MXdWaVNQeWlrUTdkZ0daUCtUTWxHS0lnMDVFMWNEaFBlUnlvaU1xV0lLdjNY?=
 =?utf-8?B?YnYySHoxa28waUFWcEZWVFB4VjEwU2wySEtEVW5lU3piMkxjemg1Z2xaa0N3?=
 =?utf-8?B?VEFHTnBIdERidnduUHNGdFNBckxPcis5OWI3Vkg3VVlzeVIwRlh1U0VtZkV2?=
 =?utf-8?B?dkZLcVNRZ3RVeDd1OC9oeFU2ZmwwaE1UNzhQR01ocTN3U1laMHZTWXZ4cE44?=
 =?utf-8?B?aTJFckNLSXFvUG1paVQyN1ZBeG1LTkt1UldjNFRMUDRGNy9ISkttRnVLQlYr?=
 =?utf-8?B?eGNiR0dGZ3RaRlNlUURpNmowNFRPaGorNUwzaWRhS2ZVUy9FUXRHcDhoMVFo?=
 =?utf-8?B?MnI1ZUdHOFRxQk54SjNlbnNFbkh3cktDcjRVUGpnYzNmSTUzdExxeXJ5VXR4?=
 =?utf-8?B?M0xtN2xzd2FPTUlqWUFDZ0lVMmdaNkdIcEphall5REFoRDFSNHhJTDI2UEI0?=
 =?utf-8?B?WDRkU1pXUnJqaWgwZENHNTAvbnBRV1pTVTh2bE1YTHNKNHJZRm9MMEY2Tm54?=
 =?utf-8?B?eEZYUmticHJMV3ZLWXpXa2R6bXBjUVgrQ293TW41MDJuTVRHOHZtQWx5cjFR?=
 =?utf-8?B?TkE3QjdHL3lxWUM4YUM2T2VBZFV4SjBqclFsUC9ISExIbk9aeDFKWXF2UFF0?=
 =?utf-8?B?ZW16UThWOU91M3hhcThzaXNsUnhxNjdWa1hCUFBRR0N2cTFjRmVCaXdGZDU4?=
 =?utf-8?B?R3N3Q2tVZE5lcU5kTGZXOTdwYytFTDl4d0VZakZJQ0w1UWx5NjJwcTVXd1I0?=
 =?utf-8?B?aFJjRkMrTnJmYnVscFJ5OEJtaTZrWXlZSGNaWDc5VzN4WEkwYzN5VHlYVnRR?=
 =?utf-8?B?WUswTlh4S3JzOHBHTkNicnJNcVNMVkhJdTliSXZnSnZOeEJXazJ4czNjSklC?=
 =?utf-8?Q?3kh+aRVRZ58GsITjvOiaKgRjDDny4mHPTH9V+ebfDg=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D588D61F9715D449ADA8C8E390ADD668@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 093b73c4-5111-445d-2e7f-08dacd5ab3a9
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2022 13:57:47.0993
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QCuQvz4xWeeMiqtOhuLQblxV5PbDUzhNh/7r3hCiApF/OlOAy5rj/isuSc73OBIkYZOenznReXmJXXsqnl+Rk2bzXRz0uzFuMwivZg/29OY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7511
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        T_SPF_TEMPERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgVmxhZGltaXIsDQpUaGFua3MgZm9yIHRoZSBjb21tZW50Lg0KDQpPbiBUdWUsIDIwMjItMTEt
MjIgYXQgMDE6MTMgKzAyMDAsIFZsYWRpbWlyIE9sdGVhbiB3cm90ZToNCj4gRVhURVJOQUwgRU1B
SUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3UNCj4g
a25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo+IA0KPiBPbiBNb24sIE5vdiAyMSwgMjAyMiBhdCAw
OToxMTo0NVBNICswNTMwLCBBcnVuIFJhbWFkb3NzIHdyb3RlOg0KPiA+ICtzdGF0aWMgaW50IGtz
el9zZXRfaHd0c3RhbXBfY29uZmlnKHN0cnVjdCBrc3pfZGV2aWNlICpkZXYsIGludA0KPiA+IHBv
cnQsDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgc3RydWN0IGh3dHN0YW1w
X2NvbmZpZyAqY29uZmlnKQ0KPiA+ICt7DQo+ID4gKyAgICAgc3RydWN0IGtzel90YWdnZXJfZGF0
YSAqdGFnZ2VyX2RhdGEgPSBrc3pfdGFnZ2VyX2RhdGEoZGV2LQ0KPiA+ID5kcyk7DQo+ID4gKyAg
ICAgc3RydWN0IGtzel9wb3J0ICpwcnQgPSAmZGV2LT5wb3J0c1twb3J0XTsNCj4gPiArICAgICBi
b29sIHJ4X29uOw0KPiA+ICsNCj4gPiArICAgICAvKiByZXNlcnZlZCBmb3IgZnV0dXJlIGV4dGVu
c2lvbnMgKi8NCj4gPiArICAgICBpZiAoY29uZmlnLT5mbGFncykNCj4gPiArICAgICAgICAgICAg
IHJldHVybiAtRUlOVkFMOw0KPiA+ICsNCj4gPiArICAgICBzd2l0Y2ggKGNvbmZpZy0+dHhfdHlw
ZSkgew0KPiA+ICsgICAgIGNhc2UgSFdUU1RBTVBfVFhfT0ZGOg0KPiA+ICsgICAgIGNhc2UgSFdU
U1RBTVBfVFhfT05FU1RFUF9QMlA6DQo+ID4gKyAgICAgICAgICAgICBwcnQtPmh3dHNfdHhfZW4g
PSBjb25maWctPnR4X3R5cGU7DQo+ID4gKyAgICAgICAgICAgICBicmVhazsNCj4gPiArICAgICBj
YXNlIEhXVFNUQU1QX1RYX09OOg0KPiA+ICsgICAgICAgICAgICAgaWYgKCFpc19sYW45Mzd4KGRl
dikpDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgIHJldHVybiAtRVJBTkdFOw0KPiA+ICsNCj4g
PiArICAgICAgICAgICAgIHBydC0+aHd0c190eF9lbiA9IGNvbmZpZy0+dHhfdHlwZTsNCj4gPiAr
ICAgICAgICAgICAgIGJyZWFrOw0KPiA+ICsgICAgIGRlZmF1bHQ6DQo+ID4gKyAgICAgICAgICAg
ICByZXR1cm4gLUVSQU5HRTsNCj4gPiArICAgICB9DQo+ID4gKw0KPiA+ICsgICAgIHN3aXRjaCAo
Y29uZmlnLT5yeF9maWx0ZXIpIHsNCj4gPiArICAgICBjYXNlIEhXVFNUQU1QX0ZJTFRFUl9OT05F
Og0KPiA+ICsgICAgICAgICAgICAgcnhfb24gPSBmYWxzZTsNCj4gPiArICAgICAgICAgICAgIGJy
ZWFrOw0KPiA+ICsgICAgIGRlZmF1bHQ6DQo+ID4gKyAgICAgICAgICAgICByeF9vbiA9IHRydWU7
DQo+ID4gKyAgICAgICAgICAgICBicmVhazsNCj4gPiArICAgICB9DQo+ID4gKw0KPiA+ICsgICAg
IGlmIChyeF9vbiAhPSB0YWdnZXJfZGF0YS0+aHd0c3RhbXBfZ2V0X3N0YXRlKGRldi0+ZHMpKSB7
DQo+ID4gKyAgICAgICAgICAgICBpbnQgcmV0Ow0KPiA+ICsNCj4gPiArICAgICAgICAgICAgIHRh
Z2dlcl9kYXRhLT5od3RzdGFtcF9zZXRfc3RhdGUoZGV2LT5kcywgZmFsc2UpOw0KPiA+ICsNCj4g
PiArICAgICAgICAgICAgIHJldCA9IGtzel9wdHBfZW5hYmxlX21vZGUoZGV2LCByeF9vbik7DQo+
ID4gKyAgICAgICAgICAgICBpZiAocmV0KQ0KPiA+ICsgICAgICAgICAgICAgICAgICAgICByZXR1
cm4gcmV0Ow0KPiA+ICsNCj4gPiArICAgICAgICAgICAgIGlmIChyeF9vbikNCj4gPiArICAgICAg
ICAgICAgICAgICAgICAgdGFnZ2VyX2RhdGEtPmh3dHN0YW1wX3NldF9zdGF0ZShkZXYtPmRzLA0K
PiA+IHRydWUpOw0KPiA+ICsgICAgIH0NCj4gDQo+IFdoYXQncyB5b3VyIGV4Y3VzZSB3aGljaCBz
dWNoIGEgaG9ycmlibGUgY29kZSBwYXR0ZXJuPyBXaGF0IHdpbGwNCj4gaGFwcGVuDQo+IHNvIGJh
ZCB3aXRoIHRoZSBwYWNrZXQgaWYgaXQncyBmbGFnZ2VkIHdpdGggYSBUWCB0aW1lc3RhbXAgcmVx
dWVzdCBpbg0KPiBLU1pfU0tCX0NCKHNrYikgYXQgdGhlIHNhbWUgdGltZSBhcyBSRUdfUFRQX01T
R19DT05GMSBpcyB3cml0dGVuIHRvPw0KPiANCj4gQWxzbywgZG9lc24ndCBkZXYtPnBvcnRzW3Bv
cnRdLmh3dHNfdHhfZW4gc2VydmUgYXMgYSBndWFyZCBhZ2FpbnN0DQo+IGZsYWdnaW5nIHBhY2tl
dHMgZm9yIFRYIHRpbWVzdGFtcHMgd2hlbiB5b3Ugc2hvdWxkbid0Pw0KPiANCg0KSSB0b29rIHRo
aXMgY29uZmlndXJhdGlvbiB0ZW1wbGF0ZSByb3V0aW5lIGZyb20gb3RoZXIgZHJpdmVyLiBDYW4g
SQ0KcmVwbGFjZSBhYm92ZSBzbmlwcGV0IHdpdGgNCg0KdGFnZ2VyX2RhdGEtPmh3dHN0YW1wX3Nl
dF9zdGF0ZShkZXYtPmRzLCByeF9vbik7DQpyZXQgPSBrc3pfcHRwX2VuYWJsZV9tb2RlKGRldiwg
cnhfb24pOw0KaWYgKHJldCkNCiAgICByZXR1cm4gcmV0Ow0KDQo+IGRpZmYgLS1naXQgYS9uZXQv
ZHNhL3RhZ19rc3ouYyBiL25ldC9kc2EvdGFnX2tzei5jDQo+ID4gaW5kZXggMzdkYjUxNTZmOWEz
Li42YTkwOWEzMDBjMTMgMTAwNjQ0DQo+ID4gLS0tIGEvbmV0L2RzYS90YWdfa3N6LmMNCj4gPiAr
KysgYi9uZXQvZHNhL3RhZ19rc3ouYw0KPiA+IEBAIC00LDYgKzQsNyBAQA0KPiA+ICAgKiBDb3B5
cmlnaHQgKGMpIDIwMTcgTWljcm9jaGlwIFRlY2hub2xvZ3kNCj4gPiAgICovDQo+ID4gDQo+ID4g
KyNpbmNsdWRlIDxsaW51eC9kc2Eva3N6X2NvbW1vbi5oPg0KPiA+ICAjaW5jbHVkZSA8bGludXgv
ZXRoZXJkZXZpY2UuaD4NCj4gPiAgI2luY2x1ZGUgPGxpbnV4L2xpc3QuaD4NCj4gPiAgI2luY2x1
ZGUgPG5ldC9kc2EuaD4NCj4gPiBAQCAtMTgsNiArMTksNjIgQEANCj4gPiAgI2RlZmluZSBLU1pf
RUdSRVNTX1RBR19MRU4gICAgICAgICAgIDENCj4gPiAgI2RlZmluZSBLU1pfSU5HUkVTU19UQUdf
TEVOICAgICAgICAgIDENCj4gPiANCj4gPiArI2RlZmluZSBLU1pfSFdUU19FTiAgMA0KPiA+ICsN
Cj4gPiArc3RydWN0IGtzel90YWdnZXJfcHJpdmF0ZSB7DQo+ID4gKyAgICAgc3RydWN0IGtzel90
YWdnZXJfZGF0YSBkYXRhOyAvKiBNdXN0IGJlIGZpcnN0ICovDQo+ID4gKyAgICAgdW5zaWduZWQg
bG9uZyBzdGF0ZTsNCj4gPiArfTsNCj4gPiArDQo+ID4gDQo=
