Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 528706901F4
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 09:15:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbjBIIPw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 03:15:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBIIPv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 03:15:51 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F55936FFD;
        Thu,  9 Feb 2023 00:15:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1675930549; x=1707466549;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=YqlDRrNJmyB/2YPaRuRc8iAK4KDXwgtlbC8SS6B9yAc=;
  b=N4RCYFlhDTD+olSkgGZZyM3QX0GdA3Z3bOp6Z6iL3k7+bpKOQ8VEC42d
   CL6b6QcwYbFxS3uUAaSmKmqucTJgWAOaiWcWgvbMk904yr+HOX4w/tYEG
   Gm97WLnrV0g6eLg1uzgAlWGzzO1bbFiNPNAQcbxs7CkB2kwIHY41D/cU9
   OEt/f2frXOYkzQ1IMzlyV6A3A5CuQMO75YYjbTnImZfF9X1vKsFeaVcBn
   13Jdz2JjFnDmaxD9KKwGgOZzNwHtnl5Fqx+SxDqSauroG0lnnsmHL5lKX
   WA2WwyIu1Y4n/bLZjBTVtMZZfT+EvbautqdlTgHSKicqbSauGEtqsdLq/
   w==;
X-IronPort-AV: E=Sophos;i="5.97,283,1669100400"; 
   d="scan'208";a="136299948"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Feb 2023 01:15:46 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 9 Feb 2023 01:15:46 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 9 Feb 2023 01:15:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NMTrj3WoxFPgN8oqSd92wuT+Hbl2lyhbDp5zczrRMVz1VWYFRBhbQBbRWeGpMcGaLDDow0yO67JVFjYinTVYTm93rjADJmc98cYegSbr29YPNpJRIj2O1jESU/7nhhn4yGQlQhuhp9EtINKJ+6OiJ3QQFnGBnmBvB/ni8/Qggvbmjx85+mlwNDAgU+5DfaAisX2lOL9KMd9NmoZhlH2oj0w4PwftaxgwqMKK5jirwneYIhFW1rTBMh0TJ4ToojU8SHGP6py9Egl28p24soH1YbiRJwNi6r1kEIzX3hQnVSb8xCKEMFQeZRLOtKCmPDQt6Qv9Z0jadPf+EJzaCP03Wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YqlDRrNJmyB/2YPaRuRc8iAK4KDXwgtlbC8SS6B9yAc=;
 b=L0gxv61bWrdBiQAq/sNdFitalzjO2VO4QywawPTCet4nCCsno+rIq+gKgnfq7xg98yLTeLA0m/FBeC8YTKC/EsMBNNfJ1KQiTNO+rq34ryb6ZMMHVijFaJTSyDnZ7qetJBuPJOD2EFG2HNzAaqvAlPPiZYm2V40QrsExMSxuVBJUwcJM+hvi0GReFAI7Kq1/ZW5i7S94pW47Hr8tQ5f4MlVMKZCcyo6fuF86O9BOZ9VvYy7O0jdmz+8XsRbgx8wLeOuRb/H1iN1AvWrZOHIlt6JZ5pE9UU3wolpUTQgUqWRqeEzpDjYB7a+RbPdDFzjbiQOKfVxyBpbNoRYfiNxa5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YqlDRrNJmyB/2YPaRuRc8iAK4KDXwgtlbC8SS6B9yAc=;
 b=oymAYfU+1veMROwGUCyE7jpE/eLTjbsGi0QWm4NbLVNp8ZgRXJ+Izo4OOs7wqA9DpYcKfva1qor0YvADycpSrly0d2VUMqQHvN34aP5miCOZUefELj7M7zAz8Ic/DcwGxx4nVUp1vPSTW8SEXlCDWCnLuOyC8hORTfvJZcbBh3Y=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 IA1PR11MB7199.namprd11.prod.outlook.com (2603:10b6:208:418::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Thu, 9 Feb
 2023 08:15:43 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::33d3:8fb0:5c42:fac1]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::33d3:8fb0:5c42:fac1%5]) with mapi id 15.20.6064.035; Thu, 9 Feb 2023
 08:15:42 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <olteanv@gmail.com>, <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <clement.leger@bootlin.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <edumazet@google.com>, <davem@davemloft.net>
CC:     <miquel.raynal@bootlin.com>, <linux-renesas-soc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <jimmy.lalande@se.com>,
        <herve.codina@bootlin.com>, <milan.stevanovic@se.com>,
        <thomas.petazzoni@bootlin.com>, <pascal.eberhard@se.com>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v3 3/3] net: dsa: rzn1-a5psw: add vlan support
Thread-Topic: [PATCH net-next v3 3/3] net: dsa: rzn1-a5psw: add vlan support
Thread-Index: AQHZO9ivx7aKD+9XQUittUI27DouUq7GRbUA
Date:   Thu, 9 Feb 2023 08:15:42 +0000
Message-ID: <1ba1499e4e471afaad149cb7d4f87d5f5206aa99.camel@microchip.com>
References: <20230208161749.331965-1-clement.leger@bootlin.com>
         <20230208161749.331965-4-clement.leger@bootlin.com>
In-Reply-To: <20230208161749.331965-4-clement.leger@bootlin.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB0076:EE_|IA1PR11MB7199:EE_
x-ms-office365-filtering-correlation-id: 201c982c-8cd9-4faf-753c-08db0a75d659
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uZMNLZuIyYjvJyIhK/l3i1IKny1AXHnjrJS7XDstjDW0rztv02Z9IvZMEyqrsW7Hvsk9RcOQ54fg9xgd0fleFwJL7/sIRMmNROGa49y6rfFTpOoWmL9XAJwa/qswxsEW9RJou8iyb7tAX2aOZhtCo7nJb17XBKbMhnDPBdpB6ULhB+pox5xVz4AShIIv2kCIRI/liqZEeUWKOfUO4JZbwShgTgmyFIsxR8nMjSOiRwY2XwjmQlY4ON2ynmSpWRIdJlEbVydn+d7S1YI2xqukmhEe+w7La2SwuyH7u2WOrNW2L0yf4WfBm2r2qVhFDfOq8Dm/Iro4/u4Dny2/AFihwjiOGvrzBkCqViYjtOjWzl8xWS+RnGeusxhvO+eXRPQa4PLCUX5gSxzDbRQMZU/BnmqFNEt5k46i0Ho2DAl6kxMDSMw5TYLkBll8SIwLHot2xYjefa7ODKgA9tYb+2g7Z7qSVQx3DwoeI7lcsd91PN4D4w1YkXU92Z14jl4G48tW+SU8jXH5ZqQJ8XDUK6BuCdaQyWot/xy3qtaCpGIej4JE7U+FqXEU8l7FyMf4BGEgmcKk/HELjvHpR8D4EHpX/oC0kg6648YDK6e9CcAgvrj2iipcGu7xZPMWePzXjV45xZi5VcnNYShFavCdzxi3PCNLW2Sl59cP1FyikekTUyri2dxuQfBmyiUwUehMv3R1wpj+aRbYDFQ50katN6bBeg0wAS4EK61KtMoXbMoWHhs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(39860400002)(346002)(366004)(136003)(396003)(451199018)(6506007)(6486002)(2616005)(478600001)(66476007)(4326008)(64756008)(8676002)(76116006)(71200400001)(91956017)(66946007)(66446008)(66556008)(186003)(38070700005)(26005)(86362001)(110136005)(6512007)(66574015)(316002)(54906003)(83380400001)(5660300002)(7416002)(122000001)(38100700002)(41300700001)(36756003)(8936002)(2906002)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V1hxNGplYzcxSkxEVDB4ck52SFV4bTdiSHZEeWdMTllwbEZJK1E4SjNMRm5u?=
 =?utf-8?B?ZVc1MHZJZUhVNURRMXcxRnU3UUJHemZGb2hHMGRFUmZXc2ZPZVdlbm1SOGRo?=
 =?utf-8?B?eFJBekJJWG1VYk5yVjU2RllEQ3pidWlMZ0wzWVdiVkVsOU5HM0p6aEtBVGFV?=
 =?utf-8?B?QWNmSHNEMkVCZTJ4M3dOR25IUDZRZ1lrbzVJRVF1N1dsaWxqNGJVTmJPSXM4?=
 =?utf-8?B?eFJJdElFQmNnNUVZdTNxMUg4MEZmUXBDaDRVWVJSNnYrN2dqdmpUQ1dFRDhZ?=
 =?utf-8?B?d2xROENQb0pWRjhzR3RzNkRNU3ppWVduNW1nRHc4MWRhQkNuNjZDRjBlTWp5?=
 =?utf-8?B?K293dGxsamZZQlE0ampzN0xueGUxcG0vYXJLRWllZWpMNit0WUh5aExVVlFv?=
 =?utf-8?B?N0E4SDY3bzY0Ykx4VDJ0dzdsS2FHa1Z3R0YxSDJVVHFucC9aMnBGR1AwTTVJ?=
 =?utf-8?B?cEVpeG1xSFlXRGJZdklzK3Rab2ZuUzNOYzlJOXRVVU5pY2NyM21BTk9pNGd3?=
 =?utf-8?B?VlRjWDJjcXFRRFRmNWU0OU9NdXZybm42R0ZVNVBjMThsSWI2Z1VzalJNUFIz?=
 =?utf-8?B?U3JrLzJKYjlIT0xMcGtVcmxwcWdweEFqSnRjQlAwbCtic3NzT2o1YXhmYmxo?=
 =?utf-8?B?VkJYby9jTDBRTFR1ZS9pVkI0aXpML25wKzRkZUVBZnRQZG9zckJrNjZHQ3A0?=
 =?utf-8?B?c3hzQzc5TVpLd0dOZ1JoTWJKN1p5VStkQXZINXRzRDJLWnkvZ0tBWUMzbm02?=
 =?utf-8?B?SHhyck1sZUk3YkJDMkQ1SHA5blY4eUhubFZLblpPZUh5Vm5JWWJBTDVXdjBz?=
 =?utf-8?B?Q0owRTVBY2dGY0c3ZUt5MEoyOG5jemJFeGtQL1VmN1FJd3JBMnFDaGNlS1dQ?=
 =?utf-8?B?VVE3MWxDcURaNDJwY3F3Y0dxY2F1N3VNamxTcjV1UmlzcEVpTVFja3VJR2hE?=
 =?utf-8?B?OENmZlNWTmVPVVJrYjVjdmdYc3RPSTZwcFBBdWFVVVZMRytVdjVZdUcrRjZZ?=
 =?utf-8?B?eHh5UHR2NWZjYUIyeThvZ3JiSk1Ud0haUzdBc3RDWnJvRi9QRy9od2lHTlBR?=
 =?utf-8?B?djlJNUxFV2JvTGpRRCswTFY4OUNYdFRKd3BTRTdLSHo0WlN0ajd5K0RtZHdG?=
 =?utf-8?B?L1IzOEFzWWdrcDYwOURieldLWU5ybjN4KzczS3NodWNGOXgyNEJQUGRGVEVx?=
 =?utf-8?B?N2R4Qmp1ZEk1S3dLbTlzTG1QRlk2MkMyMlNZWHNCVnNhL2V5NVF5YndmL1Fu?=
 =?utf-8?B?U3RyODZSbjVKcXl6YTdMbTlDQUZIeUdzNHNmVDNKOTJzZ1V3Qm5pRG82bjBM?=
 =?utf-8?B?WHJYbjdBYWZ5ci9SeHZsQW5kRjRIWGdGVk1LN1FMNHVIenFMU1QwYWJMVGw1?=
 =?utf-8?B?Nk5ncVNqNTNjUll0WmkzUVhjei9NWmxhN3ZFTlpOanM1RkMya0p2eEhkNDAv?=
 =?utf-8?B?NTVhT2xyV2ZnbEFTazhMUHF0MHdEZ2pkYzhtTm44amlRdWdzWks2eHNPWFZP?=
 =?utf-8?B?Z2hFMEc3Ykt2K0s2K0lpZTJKOXFPOVBOa2JMUW55R0xDWGtOYlRVcTlkaFhk?=
 =?utf-8?B?dnA3ZjMzY3ZiR0c2YWMzUDhocmhGWmlMZWpCWXQxaXpDQjVTaXh2VkQwenNX?=
 =?utf-8?B?RTA0bnd5Q0hmWU5yOWh1Z1RhZXpZdWxVMHhyUU42c3BFaGxBRDdYR2xzR25X?=
 =?utf-8?B?M0xYRkZJY1pRd1FKOXpNdG1WK1RQbitWb3NLR0dzZ1RLbFJBdng2TER1YTV4?=
 =?utf-8?B?czFOL0gwWDd0aHdSdUZkTkhhYlMwaDNtUVB1TGpLOEp2R0xDZWtzTE9iVnQ4?=
 =?utf-8?B?bFA4UUhOYjl4SldHYTlmWlJCc3J5WHRxSFMyTHc3dVpTWDRQRE84aGVMajd1?=
 =?utf-8?B?VXpFbm9nMHdBU2tYUjlYQS96VWx3cUJEeEFxbStLMUVva016R2tUT1dIYXhP?=
 =?utf-8?B?aTR6bjA3RU55UlJtcHJTWFJ2UUU0QVE0TnZSUTd4Tk1IVFNucjVUbkVWeElX?=
 =?utf-8?B?SENTN3NVOEZ5OHlpN3hoSEdaRGtXTTFvVjV5UmFyUUVuQjYxVUFia1dxck9O?=
 =?utf-8?B?S2tubkJYcVRIQlNEUk9QdUE2am8reERVMFdESDhYOHJKbWJSd3RMSC8zOGky?=
 =?utf-8?B?T0xqWHE1WXZOcW03cnlOb21TdzJ2U3pxM2Y5VlZ0VUh3bVZvaGpwWDZDRXVp?=
 =?utf-8?Q?LCewYcll+9oAYsDPDt5gKxc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7CD8FC3445F2F8448695BFB1F41EB615@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 201c982c-8cd9-4faf-753c-08db0a75d659
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2023 08:15:42.6539
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zuUB5nY1vEeY1mQKMoYmLOEd4ZaQ2Np6TWpc7pIIvtMJdF/fUBp7ViohOWMEd9dCNXrNiuRCScTjRJhh3kiGIxfuVtbx2bSHTNBEJ3S72OM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7199
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQ2xlbWVudCwNCk9uIFdlZCwgMjAyMy0wMi0wOCBhdCAxNzoxNyArMDEwMCwgQ2zDqW1lbnQg
TMOpZ2VyIHdyb3RlOg0KPiBFWFRFUk5BTCBFTUFJTDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9w
ZW4gYXR0YWNobWVudHMgdW5sZXNzIHlvdQ0KPiBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUNCj4g
DQo+IEFkZCBzdXBwb3J0IGZvciB2bGFuIG9wZXJhdGlvbiAoYWRkLCBkZWwsIGZpbHRlcmluZykg
b24gdGhlIFJaTjENCj4gZHJpdmVyLiBUaGUgYTVwc3cgc3dpdGNoIHN1cHBvcnRzIHVwIHRvIDMy
IFZMQU4gSURzIHdpdGggZmlsdGVyaW5nLA0KPiB0YWdnZWQvdW50YWdnZWQgVkxBTnMgYW5kIFBW
SUQgZm9yIGVhY2ggcG9ydHMuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBDbMOpbWVudCBMw6lnZXIg
PGNsZW1lbnQubGVnZXJAYm9vdGxpbi5jb20+DQo+IC0tLQ0KPiAgZHJpdmVycy9uZXQvZHNhL3J6
bjFfYTVwc3cuYyB8IDE2Nw0KPiArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKw0K
PiAgZHJpdmVycy9uZXQvZHNhL3J6bjFfYTVwc3cuaCB8ICAgOCArLQ0KPiAgMiBmaWxlcyBjaGFu
Z2VkLCAxNzIgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQg
YS9kcml2ZXJzL25ldC9kc2EvcnpuMV9hNXBzdy5jDQo+IGIvZHJpdmVycy9uZXQvZHNhL3J6bjFf
YTVwc3cuYw0KPiBpbmRleCAwY2UzOTQ4OTUyZGIuLmRlNmIxOGVjNjQ3ZCAxMDA2NDQNCj4gLS0t
IGEvZHJpdmVycy9uZXQvZHNhL3J6bjFfYTVwc3cuYw0KPiArKysgYi9kcml2ZXJzL25ldC9kc2Ev
cnpuMV9hNXBzdy5jDQo+IEBAIC01ODMsNiArNTgzLDE0NyBAQCBzdGF0aWMgaW50IGE1cHN3X3Bv
cnRfZmRiX2R1bXAoc3RydWN0DQo+IGRzYV9zd2l0Y2ggKmRzLCBpbnQgcG9ydCwNCj4gICAgICAg
ICByZXR1cm4gcmV0Ow0KPiAgfQ0KPiANCj4gK3N0YXRpYyBpbnQgYTVwc3dfcG9ydF92bGFuX2Zp
bHRlcmluZyhzdHJ1Y3QgZHNhX3N3aXRjaCAqZHMsIGludA0KPiBwb3J0LA0KPiArICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgYm9vbCB2bGFuX2ZpbHRlcmluZywNCj4gKyAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHN0cnVjdCBuZXRsaW5rX2V4dF9hY2sgKmV4
dGFjaykNCj4gK3sNCj4gKyAgICAgICB1MzIgbWFzayA9IEJJVChwb3J0ICsgQTVQU1dfVkxBTl9W
RVJJX1NISUZUKSB8DQo+ICsgICAgICAgICAgICAgICAgICBCSVQocG9ydCArIEE1UFNXX1ZMQU5f
RElTQ19TSElGVCk7DQoNCm5pdDogaWYgaW5pdGlhbGl6YXRpb24gb2YgbWFzayBpcyBzZXBhcmF0
ZWQgZnJvbSBkZWNsYXJhdGlvbiBtYXkNCmluY3JlYXNlIHRoZSByZWFkYWJpbGl0eS4NCg0KPiAr
ICAgICAgIHN0cnVjdCBhNXBzdyAqYTVwc3cgPSBkcy0+cHJpdjsNCj4gKyAgICAgICB1MzIgdmFs
ID0gMDsNCj4gKw0KPiArICAgICAgIGlmICh2bGFuX2ZpbHRlcmluZykNCj4gKyAgICAgICAgICAg
ICAgIHZhbCA9IEJJVChwb3J0ICsgQTVQU1dfVkxBTl9WRVJJX1NISUZUKSB8DQo+ICsgICAgICAg
ICAgICAgICAgICAgICBCSVQocG9ydCArIEE1UFNXX1ZMQU5fRElTQ19TSElGVCk7DQo+ICsNCj4g
KyAgICAgICBhNXBzd19yZWdfcm13KGE1cHN3LCBBNVBTV19WTEFOX1ZFUklGWSwgbWFzaywgdmFs
KTsNCj4gKw0KPiArICAgICAgIHJldHVybiAwOw0KPiArfQ0KPiArDQo+ICsNCj4gK3N0YXRpYyB2
b2lkIGE1cHN3X3BvcnRfdmxhbl90YWdnZWRfY2ZnKHN0cnVjdCBhNXBzdyAqYTVwc3csIGludA0K
PiB2bGFuX3Jlc19pZCwNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
aW50IHBvcnQsIGJvb2wgc2V0KQ0KPiArew0KPiArICAgICAgIHUzMiBtYXNrID0gQTVQU1dfVkxB
Tl9SRVNfV1JfUE9SVE1BU0sgfA0KPiBBNVBTV19WTEFOX1JFU19SRF9UQUdNQVNLIHwNCj4gKyAg
ICAgICAgICAgICAgICAgIEJJVChwb3J0KTsNCg0Kc2FtZSBoZXJlLg0KDQo+ICsgICAgICAgdTMy
IHZsYW5fcmVzX29mZiA9IEE1UFNXX1ZMQU5fUkVTKHZsYW5fcmVzX2lkKTsNCj4gKyAgICAgICB1
MzIgdmFsID0gQTVQU1dfVkxBTl9SRVNfV1JfVEFHTUFTSywgcmVnOw0KPiArDQo+ICsgICAgICAg
aWYgKHNldCkNCj4gKyAgICAgICAgICAgICAgIHZhbCB8PSBCSVQocG9ydCk7DQo+ICsNCj4gKyAg
ICAgICAvKiBUb2dnbGUgdGFnIG1hc2sgcmVhZCAqLw0KPiArICAgICAgIGE1cHN3X3JlZ193cml0
ZWwoYTVwc3csIHZsYW5fcmVzX29mZiwNCj4gQTVQU1dfVkxBTl9SRVNfUkRfVEFHTUFTSyk7DQo+
ICsgICAgICAgcmVnID0gYTVwc3dfcmVnX3JlYWRsKGE1cHN3LCB2bGFuX3Jlc19vZmYpOw0KPiAr
ICAgICAgIGE1cHN3X3JlZ193cml0ZWwoYTVwc3csIHZsYW5fcmVzX29mZiwNCj4gQTVQU1dfVkxB
Tl9SRVNfUkRfVEFHTUFTSytzdGF0aWMgaW50IGE1cHN3X3BvcnRfdmxhbl9hZGQoc3RydWN0DQo+
IGRzYV9zd2l0Y2ggKmRzLCBpbnQgcG9ydCwNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgY29uc3Qgc3RydWN0IHN3aXRjaGRldl9vYmpfcG9ydF92bGFuDQo+ID4gKnZsYW4sDQo+
ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHN0cnVjdCBuZXRsaW5rX2V4dF9hY2sg
KmV4dGFjaykNCj4gPiArew0KPiA+ICsgICAgICAgYm9vbCB0YWdnZWQgPSAhKHZsYW4tPmZsYWdz
ICYgQlJJREdFX1ZMQU5fSU5GT19VTlRBR0dFRCk7DQo+ID4gKyAgICAgICBib29sIHB2aWQgPSB2
bGFuLT5mbGFncyAmIEJSSURHRV9WTEFOX0lORk9fUFZJRDsNCj4gPiArICAgICAgIHN0cnVjdCBh
NXBzdyAqYTVwc3cgPSBkcy0+cHJpdjsNCj4gPiArICAgICAgIHUxNiB2aWQgPSB2bGFuLT52aWQ7
DQo+ID4gKyAgICAgICBpbnQgdmxhbl9yZXNfaWQ7DQo+ID4gKw0KPiA+ICsgICAgICAgZGV2X2Ri
ZyhhNXBzdy0+ZGV2LCAiQWRkIFZMQU4gJWQgb24gcG9ydCAlZCwgJXMsICVzXG4iLA0KPiA+ICsg
ICAgICAgICAgICAgICB2aWQsIHBvcnQsIHRhZ2dlZCA/ICJ0YWdnZWQiIDogInVudGFnZ2VkIiwN
Cj4gPiArICAgICAgICAgICAgICAgcHZpZCA/ICJQVklEIiA6ICJubyBQVklEIik7DQo+ID4gKw0K
PiA+ICsgICAgICAgdmxhbl9yZXNfaWQgPSBhNXBzd19maW5kX3ZsYW5fZW50cnkoYTVwc3csIHZp
ZCk7DQo+ID4gKyAgICAgICBpZiAodmxhbl9yZXNfaWQgPCAwKSB7DQo+ID4gKyAgICAgICAgICAg
ICAgIHZsYW5fcmVzX2lkID0gYTVwc3dfZ2V0X3ZsYW5fcmVzX2VudHJ5KGE1cHN3LCB2aWQpOw0K
PiA+ICsgICAgICAgICAgICAgICBpZiAodmxhbl9yZXNfaWQgPCAwKQ0KPiA+ICsgICAgICAgICAg
ICAgICAgICAgICAgIHJldHVybiAtRUlOVkFMOw0KPiA+ICsgICAgICAgfQ0KPiA+ICsNCj4gPiAr
ICAgICAgIGE1cHN3X3BvcnRfdmxhbl9jZmcoYTVwc3csIHZsYW5fcmVzX2lkLCBwb3J0LCB0cnVl
KTsNCj4gPiArICAgICAgIGlmICh0YWdnZWQpDQo+ID4gKyAgICAgICAgICAgICAgIGE1cHN3X3Bv
cnRfdmxhbl90YWdnZWRfY2ZnKGE1cHN3LCB2bGFuX3Jlc19pZCwNCj4gcG9ydCwNCj4gPiB0cnVl
KTsNCj4gPiArDQo+ID4gKyAgICAgICBpZiAocHZpZCkgew0KPiA+ICsgICAgICAgICAgICAgICBh
NXBzd19yZWdfcm13KGE1cHN3LCBBNVBTV19WTEFOX0lOX01PREVfRU5BLA0KPiA+IEJJVChwb3J0
KSwNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICBCSVQocG9ydCkpOw0KPiA+ICsg
ICAgICAgICAgICAgICBhNXBzd19yZWdfd3JpdGVsKGE1cHN3LCBBNVBTV19TWVNURU1fVEFHSU5G
Tyhwb3J0KSwNCj4gPiB2aWQpOw0KPiA+ICsgICAgICAgfQ0KPiA+ICsNCj4gPiArICAgICAgIHJl
dHVybiAwOw0KPiA+ICt9DQo+ID4gKw0KPiANCg==
