Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 429BC54C3F7
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 10:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346619AbiFOIuB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 04:50:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346439AbiFOIuA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 04:50:00 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFF081180E;
        Wed, 15 Jun 2022 01:49:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1655282998; x=1686818998;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=0b4zj7IRSZhzMgV9HLpoakQ1IZP95cxZVxFFT91sNWI=;
  b=r5BZQj1i1I/Q+SkuLxHbF/0S84ZGd+0pBDxRhsrNhQDk8XX7CHZ5QqHU
   3nXyiks/UlFoqbmAFzgW1VB8iGtzZlb7FQYmEv3ozjeqrvGkmyVIg8apy
   N8OF9uClhE9oliLCWzZGuoCDgFvDKeu9cG07SO12nKB+SNJuCe65T1tgh
   ofcB52Z0sveHxZxpYPVsyELiAwE+6XnbPN1SLFeF/O6r4uzew562P5v0p
   D+KH1Tn6jZwOFxWjBINWgajLsXo8rC1Ybq7mW9fm0/E4I4l0efPOfF50v
   pNI9s5x3t891MLUb9wBJpDnUuGwwTvCJjNiMvFhKtTUInJsSXgIDeaPf2
   g==;
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="scan'208";a="163434766"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Jun 2022 01:49:57 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 15 Jun 2022 01:49:57 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Wed, 15 Jun 2022 01:49:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B3U6wyeHaRs5S3g803cHitPtotZllRgICwe8yl06EQwDz1TpieqWfgJMYxsUqbg2bj3T3gPyJcVkfVm8AU9KzUB4M4tTK0xa4a5L9yOoaZ5/KGMMe1/DZCNcTh/faE8tfnboxTd8udOn4MZdD6prD+A+LPS1ev8xgdZo26XVqXXqngBbPvsMnC/1vbhJKLpFlgue8yDbYaa1yUjrjpLvClr3d2b+KXivN5qH3Y2GO4/SknbeYeixvUECXVCcoT0J2b7PLvQ8CE4qVsRWZKHeu6ortqCKiRrXE1/5PyPvpbFkK7XE0wNFW2AJ/fCnnZek48bqAb1cxBX0yYnoDTNYCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0b4zj7IRSZhzMgV9HLpoakQ1IZP95cxZVxFFT91sNWI=;
 b=hB0y5hK1v0bnAU/Y2W1KOvvrMPCqaFreZM2MrrLyQ691yF8TQoE+HH3gtxIVtUhn0yeFg0oA1uImpNX8pab4H0UmcgSl5gx+MIZ59Z/D+4sar+E2h1LyWisVFgwXWnPbMK7whXHKKnNYO0qyl73baqMosALugzDgHZ6W+Ri8B4NwTijcmjfnFrSJcUVH/zkP9wxG7e9BzV+MmEB8ORHRkxxsM50oIROqxL6mTXR+nICgJ7Y/jS+uTISkRA6XOjDkvk55OLpZy/5UQNivwUToTV41bzWjjLZwATuaS2KEzRWm4j2nFtX+0tNnu8whJQFZjaK4XlQM3Kf+gpjIclzsxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0b4zj7IRSZhzMgV9HLpoakQ1IZP95cxZVxFFT91sNWI=;
 b=cQWx6Z+Ws1mNmpN70rcm36Ia/m3Gj+zW7WykpmF+MOz6kVrfmyeejWIX+YySnvIlBf9yYAZZgIOlHp5ZOICBRziZrYa7kIJeq3Uk97lfAtd5uY0qr8OEeEzWUUK4ahPuFinT9tQWrn8gUrZr2EU46NCZdq+zegpkD2mCLn+ZZuA=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 DM6PR11MB2858.namprd11.prod.outlook.com (2603:10b6:5:bd::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5332.19; Wed, 15 Jun 2022 08:49:46 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::a4d9:eecb:f93e:7df0]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::a4d9:eecb:f93e:7df0%6]) with mapi id 15.20.5332.020; Wed, 15 Jun 2022
 08:49:46 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <olteanv@gmail.com>
CC:     <andrew@lunn.ch>, <linux-kernel@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <vivien.didelot@gmail.com>,
        <linux@armlinux.org.uk>, <f.fainelli@gmail.com>, <kuba@kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <Woojung.Huh@microchip.com>,
        <davem@davemloft.net>
Subject: Re: [RFC Patch net-next v2 12/15] net: dsa: microchip: ksz9477:
 separate phylink mode from switch register
Thread-Topic: [RFC Patch net-next v2 12/15] net: dsa: microchip: ksz9477:
 separate phylink mode from switch register
Thread-Index: AQHYdBJrX8JeucUdZEmH/a1bdR0upq1OqDCAgAGZa4A=
Date:   Wed, 15 Jun 2022 08:49:46 +0000
Message-ID: <187a694e61bfda132e512ac1c046d584249e85f1.camel@microchip.com>
References: <20220530104257.21485-1-arun.ramadoss@microchip.com>
         <20220530104257.21485-13-arun.ramadoss@microchip.com>
         <20220614082429.x2ger7aysr4j4zbo@skbuf>
In-Reply-To: <20220614082429.x2ger7aysr4j4zbo@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1ad78531-1ab4-49c9-f6ce-08da4eabffef
x-ms-traffictypediagnostic: DM6PR11MB2858:EE_
x-microsoft-antispam-prvs: <DM6PR11MB28583F497DB4745886F9FFE6EFAD9@DM6PR11MB2858.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1WE8BxJdOhKMcRyOBsYjl0u/FIhMtCa6LTTm0b6nzIOglh7CSDcx7O/ShuQABryNItJv0VtKpXZtF18mjILxBG/t/gp2W+sDHRRc46NthFoxVKcb+Ag6xgmONgskTKtNxCYL2MtVky7g5tpZCkSEPCf7lFc8VXaeitvpKuXEnRLAjD/Xn5O2TeD5jNjxflTg3YqdRCtmV0nqfALSQ797CaJM1CuKKC9W2PBS8tLcLkSaIQaWHnXqbL0j8t1gRTcxQV9Cfhba3D474yfVGPWlUAMZwM2B7wAOzUG4xV3igQvGZuF5hm3eV5c2VfqldVrSdq9/WKuHBSmc4Fqm93sQWB10IRx+bHeo3NpQwIxATY6QerXHwJEuoA++QLWPR2GMgcow5lHWicX5xLreQKw0pi/iq6xctyiPD91NwgLX1KDrPkGjHazYGspj/eFlrR3uj8pZY4t89Mj+ld5ynYkNI4WDZxdHLYG7T0GECD0nWD46h0+sauNhqQEVMZu5iuE8bHP7VYoyUIDfOz8eI8O3+opgqrh5/Z2sSN2tfCQmUlnvA12MhthbhHzEdqkN9c7thvcANEhzQw/HFH867WXQaHEs2tmizZ3XDmOcEamMHk6hnnK7QDbOLzusLuQtnzASdmi9EvPrU8tO6OtwkzFlIrrdZ0+blF2iDhC0sU55qoGkXdIKke1GYQjBQwSbWPETYOJzpijGVd5GwVmLvaSQt83TXbPeedejQF98RL3SQ/0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(6486002)(508600001)(71200400001)(6506007)(2906002)(186003)(86362001)(5660300002)(2616005)(8936002)(6512007)(26005)(7416002)(54906003)(36756003)(66476007)(6916009)(66446008)(76116006)(66946007)(8676002)(66556008)(91956017)(83380400001)(38100700002)(316002)(122000001)(4326008)(38070700005)(64756008)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UloxSkFxQU5oNC9ZT2tDNWYyb1JEZ29nUzdOUVMwT1g2eFVQOVZETlBHNU5R?=
 =?utf-8?B?L3I0clVUN0xuSUU0eWp6OGJCT0NpN0p5WmZkWkZhNDVRUysvUUN3UnFEdGJC?=
 =?utf-8?B?YnQ2VDlqWlRzUk1WNngvK3pkcWJSdExCT3NnbGUxQytVdzVlKzg3SzZuK3c0?=
 =?utf-8?B?Q3JqendMS2tQQ0t3WmJCZGRTdm9OSnpHeFBPSnFrcjlPYzZvVXBCZ1h2K0lH?=
 =?utf-8?B?WlFmVXU5MytoRkpPVUkrSFAwSU50VjluaVlqSFRXVkk4MVJqNHVxeHQrS1NF?=
 =?utf-8?B?MHlQcWJHV2Z4WjUxaVJXcGNpWjJuTjNEbytVaStOK1NRb1hoZm5rNTJzdU9G?=
 =?utf-8?B?MEpQQkRUSVBNN2VKckV5MEUyOHJlcjhOT3FESDBRaFltUTQ4WlVxcDFuYlBo?=
 =?utf-8?B?OUx3YUJ1bmM1WjNSRlVQdVhaTkFNS0xHTlNURmVVaVhHS3ZUQ3BMbElJY0xK?=
 =?utf-8?B?cGFDYThtMkgxSk45T2NQaWU3ZmVzTWcxbU5lZFdscTArdHNOUWpWUDNiYitz?=
 =?utf-8?B?OFhaYm5BQnhBdHhacmZlZE56Z3pRbjU2QUJzSkdiWXVUY2FyQzZBYkJtM09U?=
 =?utf-8?B?KzJtTm94WFFrWVVsYTdUa1QwRWMxczNLZThUbHE3R1RMRHNYa0JHRnVFblFN?=
 =?utf-8?B?VVNYdElMTmZNNUxFM0JSY2E2VFcraENRVXFJTHdUbndCR0h6b1FBbjFBUzJn?=
 =?utf-8?B?cVdEZ3BqSU9oa0xxcjhvS3diTlZORWoyRG5iajJRVSt5YlBydjdqeCtJRkxD?=
 =?utf-8?B?OHlYSjNESjhjYkczN09ZT1JXZnFhQWdIWWFjaTFQSDFRMUdISVVWWGprZGJx?=
 =?utf-8?B?OGNYbjRtbHlHa2I5Rm4xTXk0ODh3bEc1eVdhditTZ05LcEVwc2J4Q1RWNWJI?=
 =?utf-8?B?UlhNK2FJajFFN3F2MlhTbEpMaUZML2dCcHZKbmtIalhNaFV4d2tSK3REaE5p?=
 =?utf-8?B?bHpqQ250V0tKOVBDYTRjN2cvckRDZDlod1dxRTB0clBGNWJxeGsyR1dKZ1Rh?=
 =?utf-8?B?OUZyVU02U3VITVhJMkNQem9uZXY4SXl3dWI3YVdIZkFHYXlJYnJialJSdEtn?=
 =?utf-8?B?ZFZ6S3NzZmM3RVh3WXhwYzZQODBHZ2NsdlR3WUJlVDVxa243MngxQlkwY2ll?=
 =?utf-8?B?dTdRRTAzRUg0QUNzSU9jMFJVWnBvTXhjYkIwNkdIbWRYN1ByQ1dMTTNucmhv?=
 =?utf-8?B?NDV2VXZqTmF0RW0wMVd4VWZJWldrMnVKSDJMaGpWSWxhbkNneG5XenRzQXpC?=
 =?utf-8?B?RzJCUkxwNko1QWVpUlh4TTNrSURmalZROWowWjIwdDJVaG1VOUkxdnBuR084?=
 =?utf-8?B?TmNqNHNqUjBGVEpKZ1loS3FDUFJQVHFmRVplR1BSc1ArNCtPcGJ4dHBUczdY?=
 =?utf-8?B?WTBwV3VPdytGM0ZLNTZqOEhkRkMvMWNXeVhMTjZQTm5oK0t2RStMK0NMSnpl?=
 =?utf-8?B?cTJSTGphSnQzaXVmUXpWMm5mZFV3TlpmZmFuUUxycFpWN2svM3U2Lys1TjRn?=
 =?utf-8?B?bE1Vb3YwQjg2VXJCOFBDQU9rTU0rZXNaeSs2RW90a00vTGRHM3gxc1duV01l?=
 =?utf-8?B?bUNTakpXczFUMWptUnQ5MFhxN1pyNHZXaGtQa0FSZjc0SmhKaWdkVjM0c0lT?=
 =?utf-8?B?V3d1bkVwcFJoQy9iaS8yYUtIM3pad0NQVW9mUkZGaktseTB4REswMEpUeW9K?=
 =?utf-8?B?dm9idjRENEZWTEJGQkdKZ3B4Vzl0MStKMmRkZ1gzWDNkcWY3RC9XeXJsVnRq?=
 =?utf-8?B?b1RrN2ZqVlFtR1ljY2g4RFV0ZVRUU3ZpdVJzeHBkc2x3MHFVZkc1czA1bTdB?=
 =?utf-8?B?cHlva1B0enRPazdMZnhPYm5GOGw0Z0w2d0xZWjB2QitFYzViZFN4S0ZyeU9Z?=
 =?utf-8?B?cG96TE9wZVIzaFJXSU9HOTNsOFR6VGhjNXdldnI0OEF3Yjd3YXhPbGM2SEdR?=
 =?utf-8?B?bUJoSUZ6MThCbGtGM2cxcXFWYzZEbngvSmFRZ0pENEVhSkFpcDVEMzlTcW00?=
 =?utf-8?B?YUFVYWxVVUFpZjhwSU9tQkRhaks0TGdDcjMvbUtlYURRcHBSQVNaOEF3dnBV?=
 =?utf-8?B?SGVha095aVQ3UXFIYzlUTmRhb2x0V3htOGJ1bVgwdkxEcDc4Ri9VL1hINVhK?=
 =?utf-8?B?d0l3UGNFa05DZ28ySkRrOElFaXlwb09za0dUNmtYVnJmTXd5c29vUHhFdGJD?=
 =?utf-8?B?blF1ZXRkQWRIWmorODQxcVhRbW1LV2RmZ24rYld0azlNQUxXYXB6OUVuNDRu?=
 =?utf-8?B?cUpHSzVqMVV3QUE3eGZESnNxN3pFbHVMZ01idDRBak8rWXI4aXNGNC84QlRD?=
 =?utf-8?B?UEIyRUhJVUtoK0RTdjV1cG9TUXExKzNVUlVySzltY1NpTDVnNGI2c3JkVmZv?=
 =?utf-8?Q?pPUbL255lfZ0qtWPAFKoQM7mXhYaLvRRzGlsa?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <68446CB47F02794F8F2A312FB053C4EA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ad78531-1ab4-49c9-f6ce-08da4eabffef
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2022 08:49:46.6012
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yxnGlQJtsi+h9cfTZwi2cc3lX6P2a0Peji2j0Fs9j3nPDYtktaWdPMbOSql1u7aJJZfv5q203puD1XSDtjd8zSAjiI+MPmkPYU3Ey8PLRNM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2858
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIyLTA2LTE0IGF0IDExOjI0ICswMzAwLCBWbGFkaW1pciBPbHRlYW4gd3JvdGU6
DQo+IEVYVEVSTkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50
cyB1bmxlc3MgeW91DQo+IGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4gT24gTW9uLCBN
YXkgMzAsIDIwMjIgYXQgMDQ6MTI6NTRQTSArMDUzMCwgQXJ1biBSYW1hZG9zcyB3cm90ZToNCj4g
PiBBcyBwZXIgJ2NvbW1pdCAzNTA2YjJmNDJkZmYgKCJuZXQ6IGRzYTogbWljcm9jaGlwOiBjYWxs
DQo+ID4gcGh5X3JlbW92ZV9saW5rX21vZGUgZHVyaW5nIHByb2JlIiknIHBoeV9yZW1vdmVfbGlu
a19tb2RlIGlzIGFkZGVkDQo+ID4gaW4NCj4gPiB0aGUgc3dpdGNoX3JlZ2lzdGVyIGZ1bmN0aW9u
IGFmdGVyIGRzYV9zd2l0Y2hfcmVnaXN0ZXIuIEluIG9yZGVyIHRvDQo+ID4gaGF2ZQ0KPiA+IHRo
ZSBjb21tb24gc3dpdGNoIHJlZ2lzdGVyIGZ1bmN0aW9uLCBtb3ZpbmcgdGhpcyBwaHkgaW5pdCBh
ZnRlcg0KPiA+IGRzYV9yZWdpc3Rlcl9zd2l0Y2ggdXNpbmcgdGhlIG5ldyBrc3pfZGV2X29wcy5k
c2FfaW5pdCBob29rLg0KPiA+IA0KPiA+IFNpZ25lZC1vZmYtYnk6IEFydW4gUmFtYWRvc3MgPGFy
dW4ucmFtYWRvc3NAbWljcm9jaGlwLmNvbT4NCj4gPiAtLS0NCj4gPiAgZHJpdmVycy9uZXQvZHNh
L21pY3JvY2hpcC9rc3o5NDc3LmMgICAgfCA0OSArKysrKysrKysrKysrKy0tLS0tLQ0KPiA+IC0t
LS0tLQ0KPiA+ICBkcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzel9jb21tb24uYyB8ICA1ICsr
LQ0KPiA+ICBkcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzel9jb21tb24uaCB8ICAxICsNCj4g
PiAgMyBmaWxlcyBjaGFuZ2VkLCAzMSBpbnNlcnRpb25zKCspLCAyNCBkZWxldGlvbnMoLSkNCj4g
PiANCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3o5NDc3LmMN
Cj4gPiBiL2RyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6OTQ3Ny5jDQo+ID4gaW5kZXggZWNj
ZTk5Yjc3ZWY2Li5jODdjZTBlMmFmZDggMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvZHNh
L21pY3JvY2hpcC9rc3o5NDc3LmMNCj4gPiArKysgYi9kcml2ZXJzL25ldC9kc2EvbWljcm9jaGlw
L2tzejk0NzcuYw0KPiA+IEBAIC0xMzQ5LDYgKzEzNDksMzAgQEAgc3RhdGljIHZvaWQga3N6OTQ3
N19zd2l0Y2hfZXhpdChzdHJ1Y3QNCj4gPiBrc3pfZGV2aWNlICpkZXYpDQo+ID4gICAgICAga3N6
OTQ3N19yZXNldF9zd2l0Y2goZGV2KTsNCj4gPiAgfQ0KPiA+IA0KPiA+ICtzdGF0aWMgaW50IGtz
ejk0NzdfZHNhX2luaXQoc3RydWN0IGtzel9kZXZpY2UgKmRldikNCj4gPiArew0KPiA+ICsgICAg
IHN0cnVjdCBwaHlfZGV2aWNlICpwaHlkZXY7DQo+ID4gKyAgICAgaW50IGk7DQo+ID4gKw0KPiA+
ICsgICAgIGZvciAoaSA9IDA7IGkgPCBkZXYtPnBoeV9wb3J0X2NudDsgKytpKSB7DQo+ID4gKyAg
ICAgICAgICAgICBpZiAoIWRzYV9pc191c2VyX3BvcnQoZGV2LT5kcywgaSkpDQo+ID4gKyAgICAg
ICAgICAgICAgICAgICAgIGNvbnRpbnVlOw0KPiANCj4gSSB1bmRlcnN0YW5kIHRoaXMgaXMganVz
dCBjb2RlIG1vdmVtZW50LCBidXQgdGhpcyBpcyBtb3JlIGVmZmljaWVudDoNCj4gDQo+ICAgICAg
ICAgc3RydWN0IGRzYV9zd2l0Y2ggKmRzID0gZGV2LT5kczsNCj4gICAgICAgICBzdHJ1Y3QgZHNh
X3BvcnQgKmRwOw0KPiANCj4gICAgICAgICBkc2Ffc3dpdGNoX2Zvcl9lYWNoX3VzZXJfcG9ydChk
cCwgZHMpIHsNCj4gICAgICAgICAgICAgICAgIC4uLg0KPiAgICAgICAgIH0NCg0KWWVzLiBJIHdp
bGwgdXNlIHRoZSBtYWNybyB3aGVyZSBldmVyIHBvc3NpYmxlLg0KDQo+IA0KPiA+ICsNCj4gPiAr
ICAgICAgICAgICAgIHBoeWRldiA9IGRzYV90b19wb3J0KGRldi0+ZHMsIGkpLT5zbGF2ZS0+cGh5
ZGV2Ow0KPiA+ICsNCj4gPiArICAgICAgICAgICAgIC8qIFRoZSBNQUMgYWN0dWFsbHkgY2Fubm90
IHJ1biBpbiAxMDAwIGhhbGYtZHVwbGV4DQo+ID4gbW9kZS4gKi8NCj4gPiArICAgICAgICAgICAg
IHBoeV9yZW1vdmVfbGlua19tb2RlKHBoeWRldiwNCj4gPiArICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgIEVUSFRPT0xfTElOS19NT0RFXzEwMDBiYXNlVF9IYWxmDQo+ID4gX0JJVCk7
DQo+ID4gKw0KPiA+ICsgICAgICAgICAgICAgLyogUEhZIGRvZXMgbm90IHN1cHBvcnQgZ2lnYWJp
dC4gKi8NCj4gPiArICAgICAgICAgICAgIGlmICghKGRldi0+ZmVhdHVyZXMgJiBHQklUX1NVUFBP
UlQpKQ0KPiA+ICsgICAgICAgICAgICAgICAgICAgICBwaHlfcmVtb3ZlX2xpbmtfbW9kZShwaHlk
ZXYsDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIEVUSFRP
T0xfTElOS19NT0RFXzEwMDBiYQ0KPiA+IHNlVF9GdWxsX0JJVCk7DQo+ID4gKyAgICAgfQ0KPiAN
Cj4gSSB3b25kZXIgd2h5IHRoZSBkcml2ZXIgZGlkIG5vdCBqdXN0IHJlbW92ZSB0aGVzZSBmcm9t
IHRoZSBzdXBwb3J0ZWQNCj4gbWFzayBpbiB0aGUgcGh5bGluayB2YWxpZGF0aW9uIHByb2NlZHVy
ZSBpbiB0aGUgZmlyc3QgcGxhY2U/DQo+IEFkZGluZyB0aGVzZSBsaW5rIG1vZGUgZml4dXBzIHRv
IGEgZGV2X29wcyBjYWxsYmFjayBuYW1lZCAiZHNhX2luaXQiDQo+IGRvZXMgbm90IHNvdW5kIHF1
aXRlIHJpZ2h0Lg0KDQpTbywgaXQgbWVhbnMgaWYgdGhlIGxpbmsgbW9kZXMgYXJlIHVwZGF0ZWQg
Y29ycmVjdGx5IGluIHRoZQ0KcGh5bGlua19nZXRfY2FwcyB0aGVuIHdlIGRvbid0IG5lZWQgdGhl
c2UgbGluayBtb2RlIHJlbW92YWwuIElzIG15DQp1bmRlcnN0YW5kaW5nIGNvcnJlY3Q/DQoNCj4g
DQo+ID4gKw0KPiA+ICsgICAgIHJldHVybiAwOw0KPiA+ICt9DQo+ID4gKw0KPiA+ICBzdGF0aWMg
Y29uc3Qgc3RydWN0IGtzel9kZXZfb3BzIGtzejk0NzdfZGV2X29wcyA9IHsNCj4gPiAgICAgICAu
c2V0dXAgPSBrc3o5NDc3X3NldHVwLA0KPiA+ICAgICAgIC5nZXRfcG9ydF9hZGRyID0ga3N6OTQ3
N19nZXRfcG9ydF9hZGRyLA0KPiA+IEBAIC0xMzc3LDM1ICsxNDAxLDE0IEBAIHN0YXRpYyBjb25z
dCBzdHJ1Y3Qga3N6X2Rldl9vcHMNCj4gPiBrc3o5NDc3X2Rldl9vcHMgPSB7DQo+ID4gICAgICAg
LmNoYW5nZV9tdHUgPSBrc3o5NDc3X2NoYW5nZV9tdHUsDQo+ID4gICAgICAgLm1heF9tdHUgPSBr
c3o5NDc3X21heF9tdHUsDQo+ID4gICAgICAgLnNodXRkb3duID0ga3N6OTQ3N19yZXNldF9zd2l0
Y2gsDQo+ID4gKyAgICAgLmRzYV9pbml0ID0ga3N6OTQ3N19kc2FfaW5pdCwNCj4gPiAgICAgICAu
aW5pdCA9IGtzejk0Nzdfc3dpdGNoX2luaXQsDQo+ID4gICAgICAgLmV4aXQgPSBrc3o5NDc3X3N3
aXRjaF9leGl0LA0KPiA+ICB9Ow0KPiA+IA0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9k
c2EvbWljcm9jaGlwL2tzel9jb21tb24uaA0KPiA+IGIvZHJpdmVycy9uZXQvZHNhL21pY3JvY2hp
cC9rc3pfY29tbW9uLmgNCj4gPiBpbmRleCA4NzJkMzc4YWM0NWMuLjIzOTYyZjQ3ZGY0NiAxMDA2
NDQNCj4gPiAtLS0gYS9kcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzel9jb21tb24uaA0KPiA+
ICsrKyBiL2RyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6X2NvbW1vbi5oDQo+ID4gQEAgLTIx
Myw2ICsyMTMsNyBAQCBzdHJ1Y3Qga3N6X2Rldl9vcHMgew0KPiA+ICAgICAgIHZvaWQgKCpmcmVl
emVfbWliKShzdHJ1Y3Qga3N6X2RldmljZSAqZGV2LCBpbnQgcG9ydCwgYm9vbA0KPiA+IGZyZWV6
ZSk7DQo+ID4gICAgICAgdm9pZCAoKnBvcnRfaW5pdF9jbnQpKHN0cnVjdCBrc3pfZGV2aWNlICpk
ZXYsIGludCBwb3J0KTsNCj4gPiAgICAgICBpbnQgKCpzaHV0ZG93bikoc3RydWN0IGtzel9kZXZp
Y2UgKmRldik7DQo+ID4gKyAgICAgaW50ICgqZHNhX2luaXQpKHN0cnVjdCBrc3pfZGV2aWNlICpk
ZXYpOw0KPiA+ICAgICAgIGludCAoKmluaXQpKHN0cnVjdCBrc3pfZGV2aWNlICpkZXYpOw0KPiA+
ICAgICAgIHZvaWQgKCpleGl0KShzdHJ1Y3Qga3N6X2RldmljZSAqZGV2KTsNCj4gPiAgfTsNCj4g
PiAtLQ0KPiA+IDIuMzYuMQ0KPiA+IA0KPiANCj4gDQo=
