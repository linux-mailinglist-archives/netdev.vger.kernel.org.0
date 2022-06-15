Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28ED354C23E
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 08:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244819AbiFOG5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 02:57:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237644AbiFOG5R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 02:57:17 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A09F537A16;
        Tue, 14 Jun 2022 23:57:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1655276236; x=1686812236;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=yWdkI9kC+Al7cM8Zcqn6h61xV9ZjCa6MyOLiOlAOcvk=;
  b=Mvas0ekUvPUSR/doBf3vRdAQG/mYBpXxIOpaZIqpTExj7PoS329qirJf
   fYSESA/1b+u0pByeOHuhNLx9unznPCIQWMRLZAfHQaOPz3DjtWFniFDcI
   J0vmyxeIVJV2yfgsjyXmxQJ5a5e1bXj2MtYjXqyk7beC1G9cVdxekbZbH
   Geya2+Mj5DJa3MlCtadhhRuWl4s9K2UnPTsQQa+1fhIJli4V+HHL8BHap
   7bLuwKWIWx4nomNO3NriXLl/1hbmckxmxC+Ihb53JCDVMuuGU7mVguQTl
   3GEaR8gl7L6yJGP0z0sOEOVPeOOXWezKa1XKrY8kubgUlrJv2HkJXc+/N
   w==;
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="scan'208";a="163420192"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Jun 2022 23:57:15 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 14 Jun 2022 23:57:13 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17 via Frontend Transport; Tue, 14 Jun 2022 23:57:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dGRDHB0HlRh3NThti7BEfU4jM3mz9kS70ToCZvP8uT9iJmg7Mjba3n1RbNWEPcE8CR9eWKBtOYpTK3J/Rt7X8Ev8TbHGghX/eobLhXQyAAFqbJ2zdxteDP4mDWGnNblbOlWLOi+ukgjHIAy33VfVKhciGSMGXe70u1QoAv9COm4JaOrLxc87zGdXWJLyphQE7JZzsdD0gxd7rA5ceKP9Q2NkuxjttAAWeZ5lvXCzygmTZPJw9WxhKEbH1xVfxo8lNUwEfRWMQiHa73WPmKgAQYnJ/uzlG5yl+ccfW3GfYAyPWdNTDEIrd6v7Xvp83qirhftZQb5O3Vbkb+52uYL6AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yWdkI9kC+Al7cM8Zcqn6h61xV9ZjCa6MyOLiOlAOcvk=;
 b=hZQi4+83BMYBsxjgbizbQJz8V0oIoPWwAXPSZgfF//z0zc5FyD+v9pqYJy87nERHCXwxJnt3wHrBbQljjXGPghRkc7YAy5Buj/LHxFBcn9St+vGd63g+7obyK4s9WNgZ764w+SsT06sKpzFr3wDIk7sKau1YLWntoE0ICs8/MGkKkF21kz97gEHtFFOgKbOFg7+lMBZ9/ZRQw8UuAKAq7BE2vNf34Pf9JoW+q+hLDVDX1ikRn+4A5Lba8kl5m8i4eEALxO7GvlcfaooJ+afSrfm65hYkqroK8x8aDJEfDowzb5h7NSM0wGMR55/Fl5o+PoTrNPO+f1CQzWP5IKz19g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yWdkI9kC+Al7cM8Zcqn6h61xV9ZjCa6MyOLiOlAOcvk=;
 b=J5bb3sO0a4M1ZzYag3977LiNbY8+GUDkWfzMpmWIg+zZYuheOkbzwSFMEcezMOPkPxp66YH0WEpBvWFtKtqtgqSFaMCIQSXIJNsfI9AvmX0/zpA/zmgX9plFTPVNNqpey6IBIicNxSIRKXoY0HSMb4Xqb1YF7otF6afqZ8NAT/c=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 DM5PR11MB1625.namprd11.prod.outlook.com (2603:10b6:4:b::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5353.13; Wed, 15 Jun 2022 06:57:11 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::a4d9:eecb:f93e:7df0]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::a4d9:eecb:f93e:7df0%6]) with mapi id 15.20.5332.020; Wed, 15 Jun 2022
 06:57:11 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <olteanv@gmail.com>
CC:     <andrew@lunn.ch>, <linux-kernel@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <vivien.didelot@gmail.com>,
        <linux@armlinux.org.uk>, <f.fainelli@gmail.com>, <kuba@kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <Woojung.Huh@microchip.com>,
        <davem@davemloft.net>
Subject: Re: [RFC Patch net-next v2 09/15] net: dsa: microchip: update fdb
 add/del/dump in ksz_common
Thread-Topic: [RFC Patch net-next v2 09/15] net: dsa: microchip: update fdb
 add/del/dump in ksz_common
Thread-Index: AQHYdBJEyGe2J8NaSU+pf0TCUxcSNq1NK5qAgAL2jAA=
Date:   Wed, 15 Jun 2022 06:57:11 +0000
Message-ID: <c2b1c91dbfc7a2d33a173c2c016a248de7fe908d.camel@microchip.com>
References: <20220530104257.21485-1-arun.ramadoss@microchip.com>
         <20220530104257.21485-10-arun.ramadoss@microchip.com>
         <20220613094219.zmgbtebf32x42md6@skbuf>
In-Reply-To: <20220613094219.zmgbtebf32x42md6@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9e8c046f-c1ae-4a5a-8ef8-08da4e9c45a3
x-ms-traffictypediagnostic: DM5PR11MB1625:EE_
x-microsoft-antispam-prvs: <DM5PR11MB16254AFEC53E6E8A296C5C8FEFAD9@DM5PR11MB1625.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BHL47ldtTqzhU1xp8yDCvVOS4u30lmG298ZYJQ82vw1/Am8HwSMlS9EvbhPfqeuueihHWpXnBsnitbdTtWj2HDgeNG6rJn394BR46KRHhGAQRwgll8d69U5OGkM4u8IwpJWJx6b1F7lCAaxJEIZayQEsKGhzyaxYJ3ODBSCZNgzBPuzM/2Bl3lbK9bIEamBn5g0zAF1YKcTZCjoqieAywYXlAL2Bg5N5LaLE0EH/mzySn+AtRx1ndxb3puxcW/LEMKCbn6NNB1SeNfIA58RiP9xiMPszIsAj/QQeFEo7ImJFsgkvpEzgUkg3hPUzjTrv3hj4o0TDO3aOpYMtS4rVN/2+3jFyLtbK+HUZCreNaodRZdQUHi2QuEqm5ppCm+RSF0ZmrnrNDpmk4qiuWGpWRXX3HxxPkrt734GThLIIiwNFXQV0MydH45RtU0/83/RQggLPOU8F/laEo3HGfcrdFOFhd20DTsNiqKP8Kogf83asTd7NJhTSB4J+DDcWX9Zv/Bst2Az7wmpTWCHks7625X3o1hz8LwX0JH0FUE2gn8RtY+JoiNbz1EPMrCcQ92/VffLvrud9WuFn0978IqalcgSZU7OMGYWPZoDodagy6vgh3ejm5vedqMLsK0RugbVR4+ZFZ63PySYy1eUzTURI5gadEKX5MElhMPiHVZ/13B3fiuQhbSXHsn4svbxM0UOw2GcIqMKIbO1iSkyiVoivcaXIirjuZxN0i7xdr8ocRuo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(186003)(83380400001)(71200400001)(122000001)(508600001)(7416002)(26005)(6512007)(2616005)(6486002)(8936002)(86362001)(38070700005)(6506007)(5660300002)(36756003)(76116006)(66946007)(66476007)(54906003)(64756008)(8676002)(66556008)(66446008)(2906002)(4326008)(91956017)(6916009)(38100700002)(316002)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?M1J4K3dhUk9jM0k3VXU0MWlQZHRhNWpZYmtGTDNzQ1lhamZPeUcyVi9DSGV5?=
 =?utf-8?B?NytHSnNjZFo2d3RnWS9qTWIvS1NqdmRqWnYzQ2lxUDFlOVRvL1FLK1hoQWNz?=
 =?utf-8?B?S0p4T3FqMzlQQWRvVGdBRlNDcWtuQyt5MkF0QXcxc21QOG9DZUxNbXQrNDgv?=
 =?utf-8?B?b3RkZElmcFpsTWtKanBoVk9Tcm45VXdueVY5U2Q2dENoa3ZvR3RYQ0RzZjdX?=
 =?utf-8?B?RnRQUzhNRkZOdnI3Yy8vVzdHWlI5bUN6VFI1QTJDU0l0dXI1Q0dhZXB2VGYr?=
 =?utf-8?B?K3FhcXBCYk1BVS84RWVvTE9mU2l0SElzSzJXTFhXeVpLaXBLd3p4RWVjcEEv?=
 =?utf-8?B?b0RINHFrWWUzakZpWks0SkU2WWRrMkRWdTg3bE9HTUcydkZZUnBKYW5FVkFy?=
 =?utf-8?B?cXJ5ZklRTjkxWlFlNW45d09Oelp6WUVZdmhmMmxGd3d5dVJsOHF2am1SZ2VD?=
 =?utf-8?B?eFlKS1M3N0VJdXo1ZkJDUFFBWXJiQ3N1Ri81cFNjNi9HL1RZa1FrMGNKRjIw?=
 =?utf-8?B?M2lEUkxYVmJUTlFVekZjTzhwN0t3aDNHcnp6UXRHMkJGT3daaFI4ZWRmZzR5?=
 =?utf-8?B?TktLck9ORDRhaFp4Mm5sTHdxZW1LN1lTSllmVjRxSWtsbUdTQ1FobnBYMHRh?=
 =?utf-8?B?bHlXSlNEYXdPVmoyQ1JoaEE5b0NaOVFtdFJQN1AyNi82Vnp4V1U1d25sMkFJ?=
 =?utf-8?B?ODZydlNERjY5UFZRSXZ4R1p1WDM2dExza3JqblQ5cHZ0VW5qM0lrTER5OXl1?=
 =?utf-8?B?ZnZGdXRkZEM0OHRRb1lVL0hicDM5Sk4ybUN3S1RkRmdTYjVoVEd3Q1BBWlpD?=
 =?utf-8?B?S0lLNmtuS0dnNHFxbHVFWi8vZ2VsMFBDT29NMEFURnQ5c25obGZKeFJEWmVx?=
 =?utf-8?B?dlRPV3lhU0l6MGtMTlAzTldlWEw3SFBVK1VGaDdVb0pKOGs1a0ZOQXZiNFhD?=
 =?utf-8?B?SDRqRm4wUHhZY0pYRnp0VTdXYmNYOHQ2SXplaTZwUkFvcHNvLzJIL0JvVjhY?=
 =?utf-8?B?TEhOSEhVTnk4YVhINEx6VXFVNVlvbkltZmdTR3NZeGUyMmlpWW9hZjBkYkpx?=
 =?utf-8?B?N0VweG1URHJOSVp1SE9OQzIzYzlic1NFcWc5WCt0amxheTJyL1B5QVpuLzRh?=
 =?utf-8?B?Znc1OGI1QTNpMjNJOHJGSzdJYldCVkkrYm9FZkFQZjg0UFRGTUg2dlNjSCtk?=
 =?utf-8?B?WWg5UDlFYjVGM2FFb054VHlrNlpGYUcwU0FkRXpQT3daNUdvTEk1c2JTUnVF?=
 =?utf-8?B?NUlFWGVzRm5LS1JFNXQ2N053cytqeHplZzVLME9CQUg1dmVoUzFRZG1WTWdy?=
 =?utf-8?B?RG8rSDViQnhzMHZUSUsvcHZTa2N6ZkI5VUlQaWZZMUlqUkdESHRoVThRbk80?=
 =?utf-8?B?eGhqNkoxZXpRRFgrdFd1elBmYVh4Vjl1N1lpaXJHVURaSlZPZWovQU8xZytT?=
 =?utf-8?B?Y3RpcEJoQVhjVHJ2eTFmUld6aVVyVkVoOEE4UHV3dE12c2F0U3ROZjFyZW9B?=
 =?utf-8?B?eHhSbFROaDFEYXA5RjZ6TnZsdjBQQisrNHNhQU1EZVU1L2JLMzV0em5KTmRy?=
 =?utf-8?B?MDVrc29KSzZ5ZVc4K2VwNjk2dzdncFVlYk5aaDhIQ3ZGRmxjTzVISnN4OW1y?=
 =?utf-8?B?b0QzZlhOanhhWlpvdXJyeUtpRkVhaG04N1FvKzhqMjFlQXppMFlta1N2R284?=
 =?utf-8?B?VWJReDJPUTZ3SzFsdERNanlSaDcvQzlPTE11VGpBTnAzR2VWMHlQY3dBL2d5?=
 =?utf-8?B?Qk5KYjh5MTBVaXN6SWM3K21kV3JGWmNGaTRTVkFmWEVMamFzazRXdGdCSmwr?=
 =?utf-8?B?QndWT1oxT3dRTzYzYm8wWSswL1ZLYnF3NmpENU1PbHhBeEF1SmNDRGtzaXB1?=
 =?utf-8?B?VFVlUUJZRUFpVWIzSUJsMWZvNkw4UHNiNGpVMkUyZnJBTzc2SVZMTW51Mlc0?=
 =?utf-8?B?eUxjT0xmNXN6SHV2ZnMzTFdjaVgyaDJkcnl0NkYyZ21MYk81dFpQaHppL2pp?=
 =?utf-8?B?NG1SVkNOa0thb3ZwSGpvZDNIaG5zNUNzSVRLNnVCVXl0Yy9wM3JQOFRmSjlv?=
 =?utf-8?B?WHZYb3JVYUhRK0pIRWZWak9yVi9LSHphK3owLy8yaDI2VGEyUlZuZlMrZURK?=
 =?utf-8?B?dE5obC9OaXF5T1phcWwzZmJYa0syNHAwNVZlVG0xaWQ1QnBYQnR1M0xCb1lI?=
 =?utf-8?B?WmZvRUVOTHlOaDBMQ0lVa1ZrMTh4Y1pWZC9KNHlxSHk0TEFtNXhaRnpyc2VN?=
 =?utf-8?B?MmQ2dDQ5NDYxNTkwUEsvT1E1akhwMDRFM0kxLzYvQWtsMCtNQzBhRUhKN1JC?=
 =?utf-8?B?MzdBYVY2Vm1kVnc5VFlsUnV5NnU4ekZmUjMzaUp6cFhUUVREWDVodDdxbi9i?=
 =?utf-8?Q?WnjO/2rH6zLecL+kvZnh9yQBF7Y3kr0Q0UefO?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2CAC3A253905F54D9D7D2A035CC07CD5@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e8c046f-c1ae-4a5a-8ef8-08da4e9c45a3
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2022 06:57:11.6245
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ak924yts+A6LsiSU0hvJz1fOedHNOPGh5zMIrZn10vcPHNoYDBLvGYA7Y3IXVkv6EZE6ukMe6hG4PahitiYr98c8l6mRwWtrabQYmn/Tus4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1625
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIyLTA2LTEzIGF0IDEyOjQyICswMzAwLCBWbGFkaW1pciBPbHRlYW4gd3JvdGU6
DQo+IEVYVEVSTkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50
cyB1bmxlc3MgeW91DQo+IGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4gT24gTW9uLCBN
YXkgMzAsIDIwMjIgYXQgMDQ6MTI6NTFQTSArMDUzMCwgQXJ1biBSYW1hZG9zcyB3cm90ZToNCj4g
PiBUaGlzIHBhdGNoIG1ha2VzIHRoZSBkc2Ffc3dpdGNoX2hvb2sgZm9yIGZkYnMgdG8gdXNlIGtz
el9jb21tb24uYw0KPiA+IGZpbGUuDQo+ID4gQW5kIGZyb20ga3N6X2NvbW1vbiwgaW5kaXZpZHVh
bCBzd2l0Y2hlcyBmZGIgZnVuY3Rpb25zIGFyZSBjYWxsZWQNCj4gPiB1c2luZw0KPiA+IHRoZSBk
ZXYtPmRldl9vcHMuDQo+ID4gDQo+ID4gU2lnbmVkLW9mZi1ieTogQXJ1biBSYW1hZG9zcyA8YXJ1
bi5yYW1hZG9zc0BtaWNyb2NoaXAuY29tPg0KPiA+IC0tLQ0KPiANCj4gSSBoYWQgdG8ganVtcCBh
aGVhZCBhbmQgbG9vayBhdCB0aGUgb3RoZXIgcGF0Y2hlcyB0byBzZWUgaWYgeW91IHBsYW4NCj4g
b24NCj4gZG9pbmcgYW55dGhpbmcgYWJvdXQgdGhlIHJfZHluX21hY190YWJsZSwgcl9zdGFfbWFj
X3RhYmxlLA0KPiB3X3N0YV9tYWNfdGFibGUNCj4gZGV2X29wcyB3aGljaCBhcmUgb25seSBpbXBs
ZW1lbnRlZCBmb3Iga3N6OC4gVGhleSBiZWNvbWUgcmVkdW5kYW50DQo+IHdoZW4NCj4geW91IGlu
dHJvZHVjZSBuZXcgZGV2X29wcyBmb3IgdGhlIGVudGlyZSBGREIgZHVtcCwgYWRkLCBkZWwNCj4g
cHJvY2VkdXJlLg0KPiANCj4gSSBzZWUgdGhvc2UgYXJlbid0IHRvdWNoZWQgLSB3aGF0J3MgdGhl
IHBsYW4gdGhlcmU/DQoNClllcywgc3RhdGljICYgZHluYW1pYyB0YWJsZSBhY2Nlc3MgYmVjb21l
cyByZWR1bnRhbnQgYW5kIHVzZWQgb25seSBmb3INCmtzejguIEkgd2lsbCByZW1vdmUgaXQgZnJv
bSB0aGUga3N6X2Rldl9vcHMgc3RydWN0dXJlLiANCg0KPiA+IA0KPiA+IC1zdGF0aWMgaW50IGtz
ejk0NzdfcG9ydF9mZGJfZHVtcChzdHJ1Y3QgZHNhX3N3aXRjaCAqZHMsIGludCBwb3J0LA0KPiA+
IC0gICAgICAgICAgICAgICAgICAgICAgICAgICAgICBkc2FfZmRiX2R1bXBfY2JfdCAqY2IsIHZv
aWQgKmRhdGEpDQo+ID4gK3N0YXRpYyBpbnQga3N6OTQ3N19mZGJfZHVtcChzdHJ1Y3Qga3N6X2Rl
dmljZSAqZGV2LCBpbnQgcG9ydCwNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgIGRzYV9m
ZGJfZHVtcF9jYl90ICpjYiwgdm9pZCAqZGF0YSkNCj4gPiAgew0KPiA+IC0gICAgIHN0cnVjdCBr
c3pfZGV2aWNlICpkZXYgPSBkcy0+cHJpdjsNCj4gPiAgICAgICBpbnQgcmV0ID0gMDsNCj4gPiAg
ICAgICB1MzIga3N6X2RhdGE7DQo+ID4gICAgICAgdTMyIGFsdV90YWJsZVs0XTsNCj4gPiBAQCAt
MTMxNSw5ICsxMzEyLDkgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBkc2Ffc3dpdGNoX29wcw0KPiA+
IGtzejk0Nzdfc3dpdGNoX29wcyA9IHsNCj4gPiAgICAgICAucG9ydF92bGFuX2ZpbHRlcmluZyAg
ICA9IGtzel9wb3J0X3ZsYW5fZmlsdGVyaW5nLA0KPiA+ICAgICAgIC5wb3J0X3ZsYW5fYWRkICAg
ICAgICAgID0ga3N6X3BvcnRfdmxhbl9hZGQsDQo+ID4gICAgICAgLnBvcnRfdmxhbl9kZWwgICAg
ICAgICAgPSBrc3pfcG9ydF92bGFuX2RlbCwNCj4gPiAtICAgICAucG9ydF9mZGJfZHVtcCAgICAg
ICAgICA9IGtzejk0NzdfcG9ydF9mZGJfZHVtcCwNCj4gPiAtICAgICAucG9ydF9mZGJfYWRkICAg
ICAgICAgICA9IGtzejk0NzdfcG9ydF9mZGJfYWRkLA0KPiA+IC0gICAgIC5wb3J0X2ZkYl9kZWwg
ICAgICAgICAgID0ga3N6OTQ3N19wb3J0X2ZkYl9kZWwsDQo+ID4gKyAgICAgLnBvcnRfZmRiX2R1
bXAgICAgICAgICAgPSBrc3pfcG9ydF9mZGJfZHVtcCwNCj4gPiArICAgICAucG9ydF9mZGJfYWRk
ICAgICAgICAgICA9IGtzel9wb3J0X2ZkYl9hZGQsDQo+ID4gKyAgICAgLnBvcnRfZmRiX2RlbCAg
ICAgICAgICAgPSBrc3pfcG9ydF9mZGJfZGVsLA0KPiA+ICAgICAgIC5wb3J0X21kYl9hZGQgICAg
ICAgICAgID0ga3N6X3BvcnRfbWRiX2FkZCwNCj4gPiAgICAgICAucG9ydF9tZGJfZGVsICAgICAg
ICAgICA9IGtzel9wb3J0X21kYl9kZWwsDQo+ID4gICAgICAgLnBvcnRfbWlycm9yX2FkZCAgICAg
ICAgPSBrc3pfcG9ydF9taXJyb3JfYWRkLA0KPiA+IEBAIC0xNDAzLDYgKzE0MDAsOSBAQCBzdGF0
aWMgY29uc3Qgc3RydWN0IGtzel9kZXZfb3BzDQo+ID4ga3N6OTQ3N19kZXZfb3BzID0gew0KPiA+
ICAgICAgIC5taXJyb3JfZGVsID0ga3N6OTQ3N19wb3J0X21pcnJvcl9kZWwsDQo+ID4gICAgICAg
LmdldF9zdHBfcmVnID0ga3N6OTQ3N19nZXRfc3RwX3JlZywNCj4gPiAgICAgICAuZ2V0X2NhcHMg
PSBrc3o5NDc3X2dldF9jYXBzLA0KPiA+ICsgICAgIC5mZGJfZHVtcCA9IGtzejk0NzdfZmRiX2R1
bXAsDQo+ID4gKyAgICAgLmZkYl9hZGQgPSBrc3o5NDc3X2ZkYl9hZGQsDQo+ID4gKyAgICAgLmZk
Yl9kZWwgPSBrc3o5NDc3X2ZkYl9kZWwsDQo+ID4gICAgICAgLm1kYl9hZGQgPSBrc3o5NDc3X21k
Yl9hZGQsDQo+ID4gICAgICAgLm1kYl9kZWwgPSBrc3o5NDc3X21kYl9kZWwsDQo+ID4gICAgICAg
LnNodXRkb3duID0ga3N6OTQ3N19yZXNldF9zd2l0Y2gsDQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZl
cnMvbmV0L2RzYS9taWNyb2NoaXAva3N6X2NvbW1vbi5jDQo+ID4gYi9kcml2ZXJzL25ldC9kc2Ev
bWljcm9jaGlwL2tzel9jb21tb24uYw0KPiA+IGluZGV4IGI5MDgyOTUyZGIwZi4uOGY3OWZmMWFj
NjQ4IDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6X2NvbW1v
bi5jDQo+ID4gKysrIGIvZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3pfY29tbW9uLmMNCj4g
PiBAQCAtNzY1LDMyICs3NjUsNDAgQEAgdm9pZCBrc3pfcG9ydF9mYXN0X2FnZShzdHJ1Y3QgZHNh
X3N3aXRjaCAqZHMsDQo+ID4gaW50IHBvcnQpDQo+ID4gIH0NCj4gPiAgRVhQT1JUX1NZTUJPTF9H
UEwoa3N6X3BvcnRfZmFzdF9hZ2UpOw0KPiA+IA0KPiA+IA0KPiA+ICBpbnQga3N6X3BvcnRfZmRi
X2R1bXAoc3RydWN0IGRzYV9zd2l0Y2ggKmRzLCBpbnQgcG9ydCwNCj4gPiBkc2FfZmRiX2R1bXBf
Y2JfdCAqY2IsDQo+ID4gICAgICAgICAgICAgICAgICAgICB2b2lkICpkYXRhKQ0KPiA+ICB7DQo+
ID4gICAgICAgc3RydWN0IGtzel9kZXZpY2UgKmRldiA9IGRzLT5wcml2Ow0KPiA+IC0gICAgIGlu
dCByZXQgPSAwOw0KPiA+IC0gICAgIHUxNiBpID0gMDsNCj4gPiAtICAgICB1MTYgZW50cmllcyA9
IDA7DQo+ID4gLSAgICAgdTggdGltZXN0YW1wID0gMDsNCj4gPiAtICAgICB1OCBmaWQ7DQo+ID4g
LSAgICAgdTggbWVtYmVyOw0KPiA+IC0gICAgIHN0cnVjdCBhbHVfc3RydWN0IGFsdTsNCj4gPiAt
DQo+ID4gLSAgICAgZG8gew0KPiA+IC0gICAgICAgICAgICAgYWx1LmlzX3N0YXRpYyA9IGZhbHNl
Ow0KPiA+IC0gICAgICAgICAgICAgcmV0ID0gZGV2LT5kZXZfb3BzLT5yX2R5bl9tYWNfdGFibGUo
ZGV2LCBpLCBhbHUubWFjLA0KPiA+ICZmaWQsDQo+ID4gLSAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAmbWVtYmVyLA0KPiA+ICZ0aW1lc3RhbXAsDQo+ID4g
LSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAmZW50cmll
cyk7DQo+ID4gLSAgICAgICAgICAgICBpZiAoIXJldCAmJiAobWVtYmVyICYgQklUKHBvcnQpKSkg
ew0KPiA+IC0gICAgICAgICAgICAgICAgICAgICByZXQgPSBjYihhbHUubWFjLCBhbHUuZmlkLCBh
bHUuaXNfc3RhdGljLA0KPiA+IGRhdGEpOw0KPiA+IC0gICAgICAgICAgICAgICAgICAgICBpZiAo
cmV0KQ0KPiA+IC0gICAgICAgICAgICAgICAgICAgICAgICAgICAgIGJyZWFrOw0KPiA+IC0gICAg
ICAgICAgICAgfQ0KPiA+IC0gICAgICAgICAgICAgaSsrOw0KPiA+IC0gICAgIH0gd2hpbGUgKGkg
PCBlbnRyaWVzKTsNCj4gPiAtICAgICBpZiAoaSA+PSBlbnRyaWVzKQ0KPiA+IC0gICAgICAgICAg
ICAgcmV0ID0gMDsNCj4gPiArICAgICBpbnQgcmV0ID0gLUVPUE5PVFNVUFA7DQo+ID4gKw0KPiA+
ICsgICAgIGlmIChkZXYtPmRldl9vcHMtPmZkYl9kdW1wKQ0KPiA+ICsgICAgICAgICAgICAgcmV0
ID0gZGV2LT5kZXZfb3BzLT5mZGJfZHVtcChkZXYsIHBvcnQsIGNiLCBkYXRhKTsNCj4gPiANCj4g
PiAgICAgICByZXR1cm4gcmV0Ow0KPiA+ICB9DQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0
L2RzYS9taWNyb2NoaXAva3N6X2NvbW1vbi5oDQo+ID4gYi9kcml2ZXJzL25ldC9kc2EvbWljcm9j
aGlwL2tzel9jb21tb24uaA0KPiA+IGluZGV4IDgxNjU4MWRkN2Y4ZS4uMTMzYjFhMjU3ODY4IDEw
MDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6X2NvbW1vbi5oDQo+
ID4gKysrIGIvZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3pfY29tbW9uLmgNCj4gPiBAQCAt
MTkyLDYgKzE5MiwxMiBAQCBzdHJ1Y3Qga3N6X2Rldl9vcHMgew0KPiA+ICAgICAgICAgICAgICAg
ICAgICAgICAgIGJvb2wgaW5ncmVzcywgc3RydWN0IG5ldGxpbmtfZXh0X2Fjaw0KPiA+ICpleHRh
Y2spOw0KPiA+ICAgICAgIHZvaWQgKCptaXJyb3JfZGVsKShzdHJ1Y3Qga3N6X2RldmljZSAqZGV2
LCBpbnQgcG9ydCwNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgICAgc3RydWN0IGRzYV9tYWxs
X21pcnJvcl90Y19lbnRyeSAqbWlycm9yKTsNCj4gPiArICAgICBpbnQgKCpmZGJfYWRkKShzdHJ1
Y3Qga3N6X2RldmljZSAqZGV2LCBpbnQgcG9ydCwNCj4gPiArICAgICAgICAgICAgICAgICAgICBj
b25zdCB1bnNpZ25lZCBjaGFyICphZGRyLCB1MTYgdmlkLCBzdHJ1Y3QNCj4gPiBkc2FfZGIgZGIp
Ow0KPiA+ICsgICAgIGludCAoKmZkYl9kZWwpKHN0cnVjdCBrc3pfZGV2aWNlICpkZXYsIGludCBw
b3J0LA0KPiA+ICsgICAgICAgICAgICAgICAgICAgIGNvbnN0IHVuc2lnbmVkIGNoYXIgKmFkZHIs
IHUxNiB2aWQsIHN0cnVjdA0KPiA+IGRzYV9kYiBkYik7DQo+ID4gKyAgICAgaW50ICgqZmRiX2R1
bXApKHN0cnVjdCBrc3pfZGV2aWNlICpkZXYsIGludCBwb3J0LA0KPiA+ICsgICAgICAgICAgICAg
ICAgICAgICBkc2FfZmRiX2R1bXBfY2JfdCAqY2IsIHZvaWQgKmRhdGEpOw0KPiA+ICAgICAgIGlu
dCAoKm1kYl9hZGQpKHN0cnVjdCBrc3pfZGV2aWNlICpkZXYsIGludCBwb3J0LA0KPiA+ICAgICAg
ICAgICAgICAgICAgICAgIGNvbnN0IHN0cnVjdCBzd2l0Y2hkZXZfb2JqX3BvcnRfbWRiICptZGIs
DQo+ID4gICAgICAgICAgICAgICAgICAgICAgc3RydWN0IGRzYV9kYiBkYik7DQo+ID4gQEAgLTIz
OSw2ICsyNDUsMTAgQEAgdm9pZCBrc3pfcG9ydF9icmlkZ2VfbGVhdmUoc3RydWN0IGRzYV9zd2l0
Y2gNCj4gPiAqZHMsIGludCBwb3J0LA0KPiA+ICAgICAgICAgICAgICAgICAgICAgICAgICBzdHJ1
Y3QgZHNhX2JyaWRnZSBicmlkZ2UpOw0KPiA+ICB2b2lkIGtzel9wb3J0X3N0cF9zdGF0ZV9zZXQo
c3RydWN0IGRzYV9zd2l0Y2ggKmRzLCBpbnQgcG9ydCwgdTgNCj4gPiBzdGF0ZSk7DQo+ID4gIHZv
aWQga3N6X3BvcnRfZmFzdF9hZ2Uoc3RydWN0IGRzYV9zd2l0Y2ggKmRzLCBpbnQgcG9ydCk7DQo+
ID4gK2ludCBrc3pfcG9ydF9mZGJfYWRkKHN0cnVjdCBkc2Ffc3dpdGNoICpkcywgaW50IHBvcnQs
DQo+ID4gKyAgICAgICAgICAgICAgICAgIGNvbnN0IHVuc2lnbmVkIGNoYXIgKmFkZHIsIHUxNiB2
aWQsIHN0cnVjdA0KPiA+IGRzYV9kYiBkYik7DQo+ID4gK2ludCBrc3pfcG9ydF9mZGJfZGVsKHN0
cnVjdCBkc2Ffc3dpdGNoICpkcywgaW50IHBvcnQsDQo+ID4gKyAgICAgICAgICAgICAgICAgIGNv
bnN0IHVuc2lnbmVkIGNoYXIgKmFkZHIsIHUxNiB2aWQsIHN0cnVjdA0KPiA+IGRzYV9kYiBkYik7
DQo+ID4gIGludCBrc3pfcG9ydF9mZGJfZHVtcChzdHJ1Y3QgZHNhX3N3aXRjaCAqZHMsIGludCBw
b3J0LA0KPiA+IGRzYV9mZGJfZHVtcF9jYl90ICpjYiwNCj4gPiAgICAgICAgICAgICAgICAgICAg
IHZvaWQgKmRhdGEpOw0KPiA+ICBpbnQga3N6X3BvcnRfbWRiX2FkZChzdHJ1Y3QgZHNhX3N3aXRj
aCAqZHMsIGludCBwb3J0LA0KPiA+IC0tDQo+ID4gMi4zNi4xDQo+ID4gDQo=
