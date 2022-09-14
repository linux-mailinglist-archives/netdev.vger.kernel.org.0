Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07B995B7F95
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 05:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbiINDlT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 23:41:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiINDlQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 23:41:16 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AE8C13F5F;
        Tue, 13 Sep 2022 20:41:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1663126874; x=1694662874;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=I1rQmX+oVE2rrnhT8hjOrNJItYK1uNgdqAPzTaDpG2M=;
  b=d5eFqSAms4g7cDUl2eZ3RSnuD92lK5H1DQuaGWjib3GWE0DaQKm6jvCs
   AA6sl0lGJf0szYAgayBXFzreOcB+SKBGvdeASxB28q97CQw7ZnRzbCvif
   GjGRxdJ9gj3pG3JHety7wa43ge3DRIcZM2bSJiUvBSNEV+kh9azRPYOvf
   CNCNpQzburpwIgtFBFQhjOm97ay8n70ub67uCAmHVjxmR9zcIxbJAG0m/
   3cMRRQKETkcFtYiOdzCKoLNdPL80j6qeWjJcQM51UVeKUaEIIVZnZYiu7
   Ntszjw9QtmJl459CenII6/Sni3eAS5LeLJdAlco2iorSoLMlvkEV5hwUs
   A==;
X-IronPort-AV: E=Sophos;i="5.93,313,1654585200"; 
   d="scan'208";a="173754736"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Sep 2022 20:41:13 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 13 Sep 2022 20:41:11 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12 via Frontend
 Transport; Tue, 13 Sep 2022 20:41:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FX0uQgmw9FzItsbT3nru5ZNfJQVIJzx+9JUUnI6BhkfTPbk88goyU5D+4zyd2gNIBxcLreMsi9tMuLz6vrw/xjdP45R2NDrhUJf7iKmqAzfkDpATEiuZHzg/ag7B5pJqSHj4T2jZWTyhZvTbbS0DivMtGmTu6+et0Slg3PcOvzgd9rENUFHjLRyRQTKj2enHoPSY3fs+HcovH/dX6XRwjOTNqIdk4YnHCJysJDOcBV+hloP9FTCewEwFA6O6sHKXcBFLYGQAGynO9TaGq4JkB1i66d0p3vLMpUCo8DZhv1s3YCx/pGOHZd8qPzOyaEmqDwRJR4Gh4rQI1F//uz19DQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I1rQmX+oVE2rrnhT8hjOrNJItYK1uNgdqAPzTaDpG2M=;
 b=Z9WmZc9lmgVYmU+WOdATm/8wReBTyYG1yWLl1ptPzA/t8HkBhLr/sO1Cdq/FUjKJ1bvhHCW7ZFsGwFd2DQUGo4Kgfj/+z7SiZbw5ZD7ik+mgS4Lzigwk/th+17hyCcXUdsuoR8S/Ou4fq2JAE8xJBwiceiBWZgWEMKK3yoXXDDvbD5gXt2NUk8eM6wLqjpLOfMfjqMOKN52ytqiNTGHaHydNTvwqCk+x9fzFfaZuOQRcRUTxpuws8FjUdcvuhUZSRQdGvIXGCZ3sqPkjcR1YlFDUsYcZvlBbYoKuK1kChL1s+07emDJvk6Ounr0v/yRK5iN5ktGjmHDGuvYJqgoP1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I1rQmX+oVE2rrnhT8hjOrNJItYK1uNgdqAPzTaDpG2M=;
 b=akNSAqCkmc/VG6W+0uu1XrhN+6hQLmQMYxPsOotwIO0lEu65aeY446trjGbJNyF8bDxkaQi8QsygKg0dATlAyK1XU0iT1fXZ8QYgfElfS+W3o/zJ8pGW6FQVqK1Ou7vac29FDGZ5bVQnE/zCMXfup12SIntIWPto9NcYUtMji+c=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 BL1PR11MB5253.namprd11.prod.outlook.com (2603:10b6:208:310::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Wed, 14 Sep
 2022 03:41:09 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::3c5c:46c3:186b:d714]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::3c5c:46c3:186b:d714%3]) with mapi id 15.20.5612.022; Wed, 14 Sep 2022
 03:41:09 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <romain.naour@smile.fr>
CC:     <olteanv@gmail.com>, <UNGLinuxDriver@microchip.com>,
        <vivien.didelot@gmail.com>, <andrew@lunn.ch>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>,
        <f.fainelli@gmail.com>,
        <Prasanna.VengateshanVaradharajan@microchip.com>,
        <kuba@kernel.org>, <edumazet@google.com>, <pabeni@redhat.com>,
        <Woojung.Huh@microchip.com>, <davem@davemloft.net>,
        <hkallweit1@gmail.com>
Subject: Re: [Patch net-next 1/5] net: dsa: microchip: determine number of
 port irq based on switch type
Thread-Topic: [Patch net-next 1/5] net: dsa: microchip: determine number of
 port irq based on switch type
Thread-Index: AQHYx4qoCRSylFLFgECBoDmSE6Qp063dyuqAgAB9pgA=
Date:   Wed, 14 Sep 2022 03:41:09 +0000
Message-ID: <f2f4209ea0807f22359c0aae3197a4a424d2dde1.camel@microchip.com>
References: <20220913160427.12749-1-arun.ramadoss@microchip.com>
         <20220913160427.12749-2-arun.ramadoss@microchip.com>
         <c1a1f948-9d7a-b0cf-3c38-3455c4bd2f4a@smile.fr>
In-Reply-To: <c1a1f948-9d7a-b0cf-3c38-3455c4bd2f4a@smile.fr>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB0076:EE_|BL1PR11MB5253:EE_
x-ms-office365-filtering-correlation-id: 64bd590f-2a51-4649-6674-08da9602f64a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 489L9uIR2nURNtyEM5kgJOrG7UDXqnONSuV5yVyCZgtAkCTdmr7QbIxdrRc9JsLAvP8g5gHVXXw713RGRIe/0QEKxnImTEg3gjt5OtobB4e+XPESJJLcA5B6oO8qrUvD2pEUlJkOpTTeI6z1d9Cro8EZ/sK9+ResTQOc2SJxbE7Qf90wuQNtd2CbNSFKDsM2J27cmCbFWLrRQLrJE5HhuEJdGyrf6R0ztAfHTOnG+c57mVMA+ScxqbkolTDW/e0L8PEeLov/r4k4Kg7hmPa7g+sppy9L0Tyy1IOKK4Y3Nqwl+CDNh7tOE45NCgf/mp9rxnLbfm+TcW6Io1Xbms5H9qs75yf0dfryxwPh9YPiqmvDsH9+LpzTP4cgjbiJlKICdz1yzxA66muuqgqekHc8Q3mhpzWBoYxR7sJnLUb7SnuL/koTomRInYJSOry278P2G9u/KcsHJpQ/1HkMYNOHStfUwCmg6su94lGPwPXCHZIHt5eNzr9tyGWoMIreICA658L8l9IkJ07ign6iUxCkZjFJjh87RLGt2/IKS9gggUFXkNYE41pbeBD70tGj47RtkxHBcn0eXUyjAbBP51YxTv9nlpfe4Ik8Zvcn8JzhNGjAQ7EjATEGSgtSxLsZMXiVlxQUrnJft51qQf716P253bohj6q+HzO5ezBLUFUeSUZDucq+n7e1z3J7VkiUonA/BQ1/MINVWWxXLzVrtzcrzX24skALz4A9Vdnz5jHJhIt/grjIjZPJcccEDsWTctNtjjbLTXk1Up9ON89/hP1r7VJiXDtX02ZE+nHPYYD7A9s=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(136003)(376002)(346002)(396003)(366004)(451199015)(66446008)(186003)(478600001)(2906002)(38070700005)(54906003)(66556008)(66476007)(83380400001)(316002)(91956017)(41300700001)(122000001)(4326008)(2616005)(8676002)(6506007)(8936002)(86362001)(38100700002)(36756003)(6486002)(5660300002)(66574015)(76116006)(7416002)(6512007)(66946007)(71200400001)(26005)(110136005)(64756008)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bnMzZGVaMHk1V25Dc2pITExpelFFSmxoMVF4S2R0Mk9TYjIrQ2tPUEMwMGlk?=
 =?utf-8?B?akxMMVNHVm1RYnBtS0xEd0l4T0NGRnJHUGxsUE5nM2k2UVlocEV6TXdLVmdp?=
 =?utf-8?B?VFF2SWI0YlE2djEyWDErWWFYbjk5dGV1RnVuZDk3QjUzZmJwcHNYR1JjUkFC?=
 =?utf-8?B?NmVOWGxlTDZaZnRBTll3V1BRbWJvYmE4eHFmOVNXb3dLTCtmVDdFY08raDhn?=
 =?utf-8?B?MUJicTl3eWIzYjdPWmxlaVJIUW1MYVVXNzgyVU9oVE54WGwrOUZ2emtJMkQ2?=
 =?utf-8?B?bTF6dWgrNHZxcWtWSjFWVjlEY2MvSCtKUjczeEptTDRjVElMNGpnN1A5eHh2?=
 =?utf-8?B?MTQrQ2tOUFhTSDJCZGtPVXJ4cGFrdUNZSktSQlpCajA5bXhOZjJuTmIwS0NQ?=
 =?utf-8?B?OXgvaU1PWlFqZkdMTldybVV6bi9qdXBNaU45Ull4MSt1blltNURZcWRJNDRp?=
 =?utf-8?B?dUlZK3lLWXNhTEZDUEVwUkU0dnJhYWxydEgxZE9MUzFMMG51MHBpTGhLM0Np?=
 =?utf-8?B?OW5rY3orak9wemxMVHdLY3NleEdKSXNwUCtqK1NrQXM5QWlLeDdXQ3JNU282?=
 =?utf-8?B?RDFnTHpvQkMvRC9mTStSS3IwcjhJZmFOZXpOcE51M1dpalZkeThYbVB5VE5H?=
 =?utf-8?B?M3B2ZWpjazZVK0lFT2Fhc1htdFhINUNDUmlTOVRuTzZxZ2s2R2RJZGRjSmtJ?=
 =?utf-8?B?STUxUVA2c2lsdy9FTkZkaGZGaVNBRkZBZUNpanZzSVd3YnY0TkhYanpYQWFt?=
 =?utf-8?B?NXVUcVJtNG53Y0lCbzBBOCtnRWZyRXZvU3A4Q1FTWTB5YzVROWVrWE9QOVVR?=
 =?utf-8?B?T3lkbGN2QTNvayt5a2NBa2xrNS9BMVRVakRTQkRNL29kT3VObktUSVZRZk1I?=
 =?utf-8?B?NW9COE4ydXZZcnJYcThSMExUcXMzZmR6Qm9hRlhzZ0JiU3RoaGk4dDVqeStp?=
 =?utf-8?B?TE5YTGdLYldZb3h1R0czbWZEN2RpMFVQSzRJbDJaMU9CT2tzelV4SVh6UktG?=
 =?utf-8?B?ak51TnAxMVFzYzBLdVdCemdvMHRGek5SMEhMa3RZMENJWEx6N2d2UDA0eTdL?=
 =?utf-8?B?MEFmR2hZYWRQbFVNbVBwcFZKR3F6SE9PN2s1UUdxc1g4TW56cUpmclpvL2ls?=
 =?utf-8?B?ZUtNcjJjWGpSRXNzQUEraGd3ekRMZzNwMnp1aUE1L2E4VWZUS3BwK21MSkQz?=
 =?utf-8?B?TXVqRDRUcnVwSHRnZjQxNmhDVzZNSGlxSUl6bjlXOFNPRks2Qkxlb0FjSTJv?=
 =?utf-8?B?N1lVY1VuYWR0V3l5Z1gvS082VTBwOU02d2xGTm1GbStscm5JUU1PVzRmMG42?=
 =?utf-8?B?WE0yc1F1K3pOVWF4VFlxbkZaR2I1eUFKS0dKZ0UzN3Q5cHAya0wzaTJIRlJo?=
 =?utf-8?B?Tjk2OWlWYlQraTc0dzM3Q0VZZEZGb1lXcEQ0Nm1maEtnVUo2Vy81UjNmSXJt?=
 =?utf-8?B?WnBidkRGczVIM2FKMUdXd2p5RGVnYzZwdWcyNFREd3hwazZYaVNFTXp6b3Rk?=
 =?utf-8?B?elk2TjdpWFZvUHpsNmV5Nno4UHFDZEN2Q2VDR0JyZjU3cWI3cmZxWlNZcEhH?=
 =?utf-8?B?V0JzUEUyMERBYVMxT1dVSXEzRDQ4cWVTejJCeWl4b3p1UEFmMjFEVnpFSWhp?=
 =?utf-8?B?NGF3bU1mek5BSkMyUGRYN3FINGNTTDVyaUd4aCtQZ3g2MnZkNU5qVU52Q01i?=
 =?utf-8?B?N1U4SFZDWFBPY3RSVFJKN3dwRmtQbS9lQ01jdUtIK1R1T0FaTWxOMnE4NEd3?=
 =?utf-8?B?NCszWndKd1Z3QnFJU1FXL0loVmZSN1BjYTdJYWJndzhaa1FVa2lreGlUUjdX?=
 =?utf-8?B?VzEwTjFmREF4bnV6YVJvSC9LQ2ZuaXRvVkd4NThPM0VZWlQ5ejFIWFo2WjA2?=
 =?utf-8?B?UFJSd1FmekwvWE9WY3FHYUppSElRSlRiOXM3SnRQSWNSSC9tVHJLdjFvQ29r?=
 =?utf-8?B?a0JYOXJlQjFlN2JGL0RhUzBBVWVNbG5xRDVzZnJib0JLVzhqVll4NVlIQjdh?=
 =?utf-8?B?ZFY0RjRVK2daUnFuWjB4R0lDNURuUy9PVFY2RjkrWmNsOURKckRUTjNXa0s4?=
 =?utf-8?B?Sk84Y0tUQTV6RE9SMHBXWjZzcTZQYkpjY2UwUkptUlFZWmxpeDYvSWtUdUQw?=
 =?utf-8?B?MEpXTzhzaE9DOC9IOEdsSVkyTHp0eGJ0R1RIQ2g1YnI0QngyblRvWnRpcERQ?=
 =?utf-8?Q?xJQ1mHK3sQBzYVYhguP7SzA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A60998979AD32C4A9D83075AA80A7BE5@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64bd590f-2a51-4649-6674-08da9602f64a
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Sep 2022 03:41:09.2049
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gR1AdCM57kUxaepj4eUaqWqzuwCT/CBscJoOhBJ7s8jHThAzFBc9YoWeyaOn07jpKN7ImCfdrAZXYa1LA1oNDDwi+cW8Z0xiixxgMmEFiDM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5253
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgUm9tYWluLA0KT24gVHVlLCAyMDIyLTA5LTEzIGF0IDIyOjExICswMjAwLCBSb21haW4gTmFv
dXIgd3JvdGU6DQo+IEVYVEVSTkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBh
dHRhY2htZW50cyB1bmxlc3MgeW91DQo+IGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4g
SGksDQo+IA0KPiBMZSAxMy8wOS8yMDIyIMOgIDE4OjA0LCBBcnVuIFJhbWFkb3NzIGEgw6ljcml0
IDoNCj4gPiBDdXJyZW50bHkgdGhlIG51bWJlciBvZiBwb3J0IGlycXMgaXMgaGFyZCBjb2RlZCBm
b3IgdGhlIGxhbjkzN3gNCj4gPiBzd2l0Y2gNCj4gPiBhcyA2LiBJbiBvcmRlciB0byBtYWtlIHRo
ZSBnZW5lcmljIGludGVycnVwdCBoYW5kbGVyIGZvciBrc3oNCj4gPiBzd2l0Y2hlcywNCj4gPiBu
dW1iZXIgb2YgcG9ydCBpcnEgc3VwcG9ydGVkIGJ5IHRoZSBzd2l0Y2ggaXMgYWRkZWQgdG8gdGhl
DQo+ID4ga3N6X2NoaXBfZGF0YS4gSXQgaXMgNCBmb3Iga3N6OTQ3NywgMiBmb3Iga3N6OTg5NyBh
bmQgMyBmb3INCj4gPiBrc3o5NTY3Lg0KPiANCj4gVGhlIGtzejk4OTYgaGFzIGJlZW4gYWRkZWQg
cmVjZW50bHkgYW5kIGl0J3MgY2xvc2UgdG8gdGhlIGtzejk4OTcuDQo+IFNvIGl0IHNob3VsZCBn
ZXQgIi5wb3J0X25pcnFzID0gMiIgdG9vPw0KPiANCj4gSUlVQywgdG8gZ2V0IHRoZSBudW1iZXIg
b2YgcG9ydCBpcnFzIHlvdSBoYXZlIHRvIGxvb2sgYXQgdGFibGUgIlBvcnQNCj4gSW50ZXJydXB0
DQo+IE1hc2sgUmVnaXN0ZXIiIGluIHRoZSBkYXRhc2hlZXQuDQo+IA0KPiA0IHBvcnQgaXJxcyBm
b3IgdGhlIGtzejk0Nzc6IFNHTUlJLCBQVFAsIFBIWSBhbmQgQUNMLg0KPiAyIHBvcnQgaXJxcyBm
b3IgdGhlIGtzejk4OTcva3N6OTg5NjogUEhZIGFuZCBBQ0wuDQo+IDMgcG9ydCBpcnFzIGZvciB0
aGUga3N6OTU2NzogUFRQLCBQSFkgYW5kIEFDTC4NCg0KVGhhbmtzIGZvciBwb2ludGluZyBpdCBv
dXQuDQpJIHdpbGwgaW5jbHVkZSAucG9ydF9uaXJxcz0yIGZvciBrc3o5ODk2IGFuZCBzZW5kIHRo
ZSB2MiBwYXRjaC4NCg0KPiANCj4gQmVzdCByZWdhcmRzLA0KPiBSb21haW4NCj4gDQo+ID4gDQo+
ID4gU2lnbmVkLW9mZi1ieTogQXJ1biBSYW1hZG9zcyA8YXJ1bi5yYW1hZG9zc0BtaWNyb2NoaXAu
Y29tPg0KPiA+IFJldmlld2VkLWJ5OiBBbmRyZXcgTHVubiA8YW5kcmV3QGx1bm4uY2g+DQo+ID4g
LS0tDQo+ID4gIGRyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6X2NvbW1vbi5jICAgfCA5ICsr
KysrKysrKw0KPiA+ICBkcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzel9jb21tb24uaCAgIHwg
MSArDQo+ID4gIGRyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAvbGFuOTM3eF9tYWluLmMgfCA0ICst
LS0NCj4gPiAgMyBmaWxlcyBjaGFuZ2VkLCAxMSBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygt
KQ0KPiA+IA0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzel9j
b21tb24uYw0KPiA+IGIvZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3pfY29tbW9uLmMNCj4g
PiBpbmRleCBmY2FhNzFmNjYzMjIuLmI5MTA4OWE0ODNlNyAxMDA2NDQNCj4gPiAtLS0gYS9kcml2
ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzel9jb21tb24uYw0KPiA+ICsrKyBiL2RyaXZlcnMvbmV0
L2RzYS9taWNyb2NoaXAva3N6X2NvbW1vbi5jDQo+ID4gQEAgLTExNjgsNiArMTE2OCw3IEBAIGNv
bnN0IHN0cnVjdCBrc3pfY2hpcF9kYXRhIGtzel9zd2l0Y2hfY2hpcHNbXQ0KPiA+ID0gew0KPiA+
ICAgICAgICAgICAgICAgLm51bV9zdGF0aWNzID0gMTYsDQo+ID4gICAgICAgICAgICAgICAuY3B1
X3BvcnRzID0gMHg3RiwgICAgICAvKiBjYW4gYmUgY29uZmlndXJlZCBhcyBjcHUNCj4gPiBwb3J0
ICovDQo+ID4gICAgICAgICAgICAgICAucG9ydF9jbnQgPSA3LCAgICAgICAgICAvKiB0b3RhbCBw
aHlzaWNhbCBwb3J0IGNvdW50DQo+ID4gKi8NCj4gPiArICAgICAgICAgICAgIC5wb3J0X25pcnFz
ID0gNCwNCj4gPiAgICAgICAgICAgICAgIC5vcHMgPSAma3N6OTQ3N19kZXZfb3BzLA0KPiA+ICAg
ICAgICAgICAgICAgLnBoeV9lcnJhdGFfOTQ3NyA9IHRydWUsDQo+ID4gICAgICAgICAgICAgICAu
bWliX25hbWVzID0ga3N6OTQ3N19taWJfbmFtZXMsDQo+ID4gQEAgLTEyMzAsNiArMTIzMSw3IEBA
IGNvbnN0IHN0cnVjdCBrc3pfY2hpcF9kYXRhIGtzel9zd2l0Y2hfY2hpcHNbXQ0KPiA+ID0gew0K
PiA+ICAgICAgICAgICAgICAgLm51bV9zdGF0aWNzID0gMTYsDQo+ID4gICAgICAgICAgICAgICAu
Y3B1X3BvcnRzID0gMHg3RiwgICAgICAvKiBjYW4gYmUgY29uZmlndXJlZCBhcyBjcHUNCj4gPiBw
b3J0ICovDQo+ID4gICAgICAgICAgICAgICAucG9ydF9jbnQgPSA3LCAgICAgICAgICAvKiB0b3Rh
bCBwaHlzaWNhbCBwb3J0IGNvdW50DQo+ID4gKi8NCj4gPiArICAgICAgICAgICAgIC5wb3J0X25p
cnFzID0gMiwNCj4gPiAgICAgICAgICAgICAgIC5vcHMgPSAma3N6OTQ3N19kZXZfb3BzLA0KPiA+
ICAgICAgICAgICAgICAgLnBoeV9lcnJhdGFfOTQ3NyA9IHRydWUsDQo+ID4gICAgICAgICAgICAg
ICAubWliX25hbWVzID0ga3N6OTQ3N19taWJfbmFtZXMsDQo+ID4gQEAgLTEyNTksNiArMTI2MSw3
IEBAIGNvbnN0IHN0cnVjdCBrc3pfY2hpcF9kYXRhIGtzel9zd2l0Y2hfY2hpcHNbXQ0KPiA+ID0g
ew0KPiA+ICAgICAgICAgICAgICAgLm51bV9zdGF0aWNzID0gMTYsDQo+ID4gICAgICAgICAgICAg
ICAuY3B1X3BvcnRzID0gMHgwNywgICAgICAvKiBjYW4gYmUgY29uZmlndXJlZCBhcyBjcHUNCj4g
PiBwb3J0ICovDQo+ID4gICAgICAgICAgICAgICAucG9ydF9jbnQgPSAzLCAgICAgICAgICAvKiB0
b3RhbCBwb3J0IGNvdW50ICovDQo+ID4gKyAgICAgICAgICAgICAucG9ydF9uaXJxcyA9IDIsDQo+
ID4gICAgICAgICAgICAgICAub3BzID0gJmtzejk0NzdfZGV2X29wcywNCj4gPiAgICAgICAgICAg
ICAgIC5taWJfbmFtZXMgPSBrc3o5NDc3X21pYl9uYW1lcywNCj4gPiAgICAgICAgICAgICAgIC5t
aWJfY250ID0gQVJSQVlfU0laRShrc3o5NDc3X21pYl9uYW1lcyksDQo+ID4gQEAgLTEyODMsNiAr
MTI4Niw3IEBAIGNvbnN0IHN0cnVjdCBrc3pfY2hpcF9kYXRhIGtzel9zd2l0Y2hfY2hpcHNbXQ0K
PiA+ID0gew0KPiA+ICAgICAgICAgICAgICAgLm51bV9zdGF0aWNzID0gMTYsDQo+ID4gICAgICAg
ICAgICAgICAuY3B1X3BvcnRzID0gMHg3RiwgICAgICAvKiBjYW4gYmUgY29uZmlndXJlZCBhcyBj
cHUNCj4gPiBwb3J0ICovDQo+ID4gICAgICAgICAgICAgICAucG9ydF9jbnQgPSA3LCAgICAgICAg
ICAvKiB0b3RhbCBwaHlzaWNhbCBwb3J0IGNvdW50DQo+ID4gKi8NCj4gPiArICAgICAgICAgICAg
IC5wb3J0X25pcnFzID0gMywNCj4gPiAgICAgICAgICAgICAgIC5vcHMgPSAma3N6OTQ3N19kZXZf
b3BzLA0KPiA+ICAgICAgICAgICAgICAgLnBoeV9lcnJhdGFfOTQ3NyA9IHRydWUsDQo+ID4gICAg
ICAgICAgICAgICAubWliX25hbWVzID0ga3N6OTQ3N19taWJfbmFtZXMsDQo+ID4gQEAgLTEzMTIs
NiArMTMxNiw3IEBAIGNvbnN0IHN0cnVjdCBrc3pfY2hpcF9kYXRhIGtzel9zd2l0Y2hfY2hpcHNb
XQ0KPiA+ID0gew0KPiA+ICAgICAgICAgICAgICAgLm51bV9zdGF0aWNzID0gMjU2LA0KPiA+ICAg
ICAgICAgICAgICAgLmNwdV9wb3J0cyA9IDB4MTAsICAgICAgLyogY2FuIGJlIGNvbmZpZ3VyZWQg
YXMgY3B1DQo+ID4gcG9ydCAqLw0KPiA+ICAgICAgICAgICAgICAgLnBvcnRfY250ID0gNSwgICAg
ICAgICAgLyogdG90YWwgcGh5c2ljYWwgcG9ydCBjb3VudA0KPiA+ICovDQo+ID4gKyAgICAgICAg
ICAgICAucG9ydF9uaXJxcyA9IDYsDQo+ID4gICAgICAgICAgICAgICAub3BzID0gJmxhbjkzN3hf
ZGV2X29wcywNCj4gPiAgICAgICAgICAgICAgIC5taWJfbmFtZXMgPSBrc3o5NDc3X21pYl9uYW1l
cywNCj4gPiAgICAgICAgICAgICAgIC5taWJfY250ID0gQVJSQVlfU0laRShrc3o5NDc3X21pYl9u
YW1lcyksDQo+ID4gQEAgLTEzMzUsNiArMTM0MCw3IEBAIGNvbnN0IHN0cnVjdCBrc3pfY2hpcF9k
YXRhIGtzel9zd2l0Y2hfY2hpcHNbXQ0KPiA+ID0gew0KPiA+ICAgICAgICAgICAgICAgLm51bV9z
dGF0aWNzID0gMjU2LA0KPiA+ICAgICAgICAgICAgICAgLmNwdV9wb3J0cyA9IDB4MzAsICAgICAg
LyogY2FuIGJlIGNvbmZpZ3VyZWQgYXMgY3B1DQo+ID4gcG9ydCAqLw0KPiA+ICAgICAgICAgICAg
ICAgLnBvcnRfY250ID0gNiwgICAgICAgICAgLyogdG90YWwgcGh5c2ljYWwgcG9ydCBjb3VudA0K
PiA+ICovDQo+ID4gKyAgICAgICAgICAgICAucG9ydF9uaXJxcyA9IDYsDQo+ID4gICAgICAgICAg
ICAgICAub3BzID0gJmxhbjkzN3hfZGV2X29wcywNCj4gPiAgICAgICAgICAgICAgIC5taWJfbmFt
ZXMgPSBrc3o5NDc3X21pYl9uYW1lcywNCj4gPiAgICAgICAgICAgICAgIC5taWJfY250ID0gQVJS
QVlfU0laRShrc3o5NDc3X21pYl9uYW1lcyksDQo+ID4gQEAgLTEzNTgsNiArMTM2NCw3IEBAIGNv
bnN0IHN0cnVjdCBrc3pfY2hpcF9kYXRhIGtzel9zd2l0Y2hfY2hpcHNbXQ0KPiA+ID0gew0KPiA+
ICAgICAgICAgICAgICAgLm51bV9zdGF0aWNzID0gMjU2LA0KPiA+ICAgICAgICAgICAgICAgLmNw
dV9wb3J0cyA9IDB4MzAsICAgICAgLyogY2FuIGJlIGNvbmZpZ3VyZWQgYXMgY3B1DQo+ID4gcG9y
dCAqLw0KPiA+ICAgICAgICAgICAgICAgLnBvcnRfY250ID0gOCwgICAgICAgICAgLyogdG90YWwg
cGh5c2ljYWwgcG9ydCBjb3VudA0KPiA+ICovDQo+ID4gKyAgICAgICAgICAgICAucG9ydF9uaXJx
cyA9IDYsDQo+ID4gICAgICAgICAgICAgICAub3BzID0gJmxhbjkzN3hfZGV2X29wcywNCj4gPiAg
ICAgICAgICAgICAgIC5taWJfbmFtZXMgPSBrc3o5NDc3X21pYl9uYW1lcywNCj4gPiAgICAgICAg
ICAgICAgIC5taWJfY250ID0gQVJSQVlfU0laRShrc3o5NDc3X21pYl9uYW1lcyksDQo+ID4gQEAg
LTEzODUsNiArMTM5Miw3IEBAIGNvbnN0IHN0cnVjdCBrc3pfY2hpcF9kYXRhIGtzel9zd2l0Y2hf
Y2hpcHNbXQ0KPiA+ID0gew0KPiA+ICAgICAgICAgICAgICAgLm51bV9zdGF0aWNzID0gMjU2LA0K
PiA+ICAgICAgICAgICAgICAgLmNwdV9wb3J0cyA9IDB4MzgsICAgICAgLyogY2FuIGJlIGNvbmZp
Z3VyZWQgYXMgY3B1DQo+ID4gcG9ydCAqLw0KPiA+ICAgICAgICAgICAgICAgLnBvcnRfY250ID0g
NSwgICAgICAgICAgLyogdG90YWwgcGh5c2ljYWwgcG9ydCBjb3VudA0KPiA+ICovDQo+ID4gKyAg
ICAgICAgICAgICAucG9ydF9uaXJxcyA9IDYsDQo+ID4gICAgICAgICAgICAgICAub3BzID0gJmxh
bjkzN3hfZGV2X29wcywNCj4gPiAgICAgICAgICAgICAgIC5taWJfbmFtZXMgPSBrc3o5NDc3X21p
Yl9uYW1lcywNCj4gPiAgICAgICAgICAgICAgIC5taWJfY250ID0gQVJSQVlfU0laRShrc3o5NDc3
X21pYl9uYW1lcyksDQo+ID4gQEAgLTE0MTIsNiArMTQyMCw3IEBAIGNvbnN0IHN0cnVjdCBrc3pf
Y2hpcF9kYXRhIGtzel9zd2l0Y2hfY2hpcHNbXQ0KPiA+ID0gew0KPiA+ICAgICAgICAgICAgICAg
Lm51bV9zdGF0aWNzID0gMjU2LA0KPiA+ICAgICAgICAgICAgICAgLmNwdV9wb3J0cyA9IDB4MzAs
ICAgICAgLyogY2FuIGJlIGNvbmZpZ3VyZWQgYXMgY3B1DQo+ID4gcG9ydCAqLw0KPiA+ICAgICAg
ICAgICAgICAgLnBvcnRfY250ID0gOCwgICAgICAgICAgLyogdG90YWwgcGh5c2ljYWwgcG9ydCBj
b3VudA0KPiA+ICovDQo+ID4gKyAgICAgICAgICAgICAucG9ydF9uaXJxcyA9IDYsDQo+ID4gICAg
ICAgICAgICAgICAub3BzID0gJmxhbjkzN3hfZGV2X29wcywNCj4gPiAgICAgICAgICAgICAgIC5t
aWJfbmFtZXMgPSBrc3o5NDc3X21pYl9uYW1lcywNCj4gPiAgICAgICAgICAgICAgIC5taWJfY250
ID0gQVJSQVlfU0laRShrc3o5NDc3X21pYl9uYW1lcyksDQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZl
cnMvbmV0L2RzYS9taWNyb2NoaXAva3N6X2NvbW1vbi5oDQo+ID4gYi9kcml2ZXJzL25ldC9kc2Ev
bWljcm9jaGlwL2tzel9jb21tb24uaA0KPiA+IGluZGV4IDYyMDNkY2Q4YzhmNy4uYmFhMWUxYmMx
YjdjIDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6X2NvbW1v
bi5oDQo+ID4gKysrIGIvZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3pfY29tbW9uLmgNCj4g
PiBAQCAtNDUsNiArNDUsNyBAQCBzdHJ1Y3Qga3N6X2NoaXBfZGF0YSB7DQo+ID4gICAgICAgaW50
IG51bV9zdGF0aWNzOw0KPiA+ICAgICAgIGludCBjcHVfcG9ydHM7DQo+ID4gICAgICAgaW50IHBv
cnRfY250Ow0KPiA+ICsgICAgIHU4IHBvcnRfbmlycXM7DQo+ID4gICAgICAgY29uc3Qgc3RydWN0
IGtzel9kZXZfb3BzICpvcHM7DQo+ID4gICAgICAgYm9vbCBwaHlfZXJyYXRhXzk0Nzc7DQo+ID4g
ICAgICAgYm9vbCBrc3o4N3h4X2VlZV9saW5rX2VycmF0dW07DQo+ID4gZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvbmV0L2RzYS9taWNyb2NoaXAvbGFuOTM3eF9tYWluLmMNCj4gPiBiL2RyaXZlcnMvbmV0
L2RzYS9taWNyb2NoaXAvbGFuOTM3eF9tYWluLmMNCj4gPiBpbmRleCA5YjY3NjBiMWU1NzIuLjcx
MzZkOWM1NTMxNSAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2xh
bjkzN3hfbWFpbi5jDQo+ID4gKysrIGIvZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9sYW45Mzd4
X21haW4uYw0KPiA+IEBAIC0yMCw4ICsyMCw2IEBADQo+ID4gICNpbmNsdWRlICJrc3pfY29tbW9u
LmgiDQo+ID4gICNpbmNsdWRlICJsYW45Mzd4LmgiDQo+ID4gDQo+ID4gLSNkZWZpbmUgTEFOOTM3
eF9QTklSUVMgNg0KPiA+IC0NCj4gPiAgc3RhdGljIGludCBsYW45Mzd4X2NmZyhzdHJ1Y3Qga3N6
X2RldmljZSAqZGV2LCB1MzIgYWRkciwgdTggYml0cywNCj4gPiBib29sIHNldCkNCj4gPiAgew0K
PiA+ICAgICAgIHJldHVybiByZWdtYXBfdXBkYXRlX2JpdHMoZGV2LT5yZWdtYXBbMF0sIGFkZHIs
IGJpdHMsIHNldCA/DQo+ID4gYml0cyA6IDApOw0KPiA+IEBAIC02OTcsNyArNjk1LDcgQEAgc3Rh
dGljIGludCBsYW45Mzd4X3BpcnFfc2V0dXAoc3RydWN0IGtzel9kZXZpY2UNCj4gPiAqZGV2LCB1
OCBwKQ0KPiA+ICAgICAgIGludCByZXQsIGlycTsNCj4gPiAgICAgICBpbnQgaXJxX251bTsNCj4g
PiANCj4gPiAtICAgICBwb3J0LT5waXJxLm5pcnFzID0gTEFOOTM3eF9QTklSUVM7DQo+ID4gKyAg
ICAgcG9ydC0+cGlycS5uaXJxcyA9IGRldi0+aW5mby0+cG9ydF9uaXJxczsNCj4gPiAgICAgICBw
b3J0LT5waXJxLmRvbWFpbiA9IGlycV9kb21haW5fYWRkX3NpbXBsZShkZXYtPmRldi0+b2Zfbm9k
ZSwNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBw
b3J0LT5waXJxLm5pcnFzLA0KPiA+IDAsDQo+ID4gICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgJmxhbjkzN3hfcGlycV9kb21haQ0KPiA+IG5fb3BzLA0KPiAN
Cj4gDQo=
