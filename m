Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8082040F920
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 15:29:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233990AbhIQNar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 09:30:47 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:46535 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233936AbhIQNaq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 09:30:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1631885364; x=1663421364;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=4PRRCtnsd2N0/QZQuuOnqrgCkoVP/kdjVn3npmjDYHE=;
  b=HkiJJsJo+i4WiT0V6a/gyM+zKmLGSlkTDhy6tOjqJ3zdSrfTbwexdoHs
   99c9jrcjRGMsFP7OJ1e688RQn1AJGzxtw8w1CvQgyUwQ+WGZ46RuqcKNY
   LBS6lOYsnCvOKIcxVjIveyJ4fs3pdiBBYjr3PJoPsONsKq/O4rpez7hXx
   6cHFhP+IoEsoN+EYOzUOJ4s3MEi2BiS7ykIxGsxn4+aWjZNh52327YUnn
   8Q6vev3mp6j7OAwap+su9XeKfxRdt24MJehWVtEWljiKTMtPgRvT+lCuB
   u4Ju2jzHnIrHjO5ilBVrpLvD2CnavXNLUftrUT4Ti01TxqtW9XZHMPLei
   w==;
IronPort-SDR: 3SSzJyW7kHsc3BOohtWzGxH0JSwYt7qYVTPxv2mG9BAMe5ACPN+H1AJ+OaCtNWZw8Ty6xqZbLy
 t/UFqOWV9OzTqalmLjaHhGeAyWcdn9Z7LhgD1YKbkYMoYDWj49spLV10PvzITHKKRjuSMh9xTT
 z+Ctg2SW7IkMrYgF0F+FWTEYsTL+i+NpiPT7r6+27jMpJ8DjI8l6fWNdKU1MGZieTBLZgdow+m
 eMaEIYj1/6XOLUnbs/UuuCjt1V56f80WYg8hbna9EPeXXrwJUC7sAgxfuXkOAzmclska5m/Ali
 zT2h4IbMLZEtW46Ido6oghmC
X-IronPort-AV: E=Sophos;i="5.85,301,1624345200"; 
   d="scan'208";a="144542344"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Sep 2021 06:29:23 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Fri, 17 Sep 2021 06:29:23 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.14 via Frontend
 Transport; Fri, 17 Sep 2021 06:29:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xj+rrv+J0bK/Qx9hz8AqEeAqbwhTQz3cJ+mdnp8FRKIS6OnjqUCOitD+DZjOJUNV6yYTHfD94KECjf1cQjeAgqrSDyBqHqdAbUJWGik2tSBLRV5Up9bMOyfNAyl45Ewh8d4BNvXooacTyWUVSdZdH61Z12ALvL0qMDuzfDyLVSv/0v0X22SPQsOi4HWoX1fTmhdCOhljgFNNdmy60TJMhwU6ekP43r9H59ofaYtyt+7mZa8kuQr77W1B7BLBHrAzzYN/QTciMOzzFviFhNvD0XVxpQV3E3l5SHa3oM4eeR9cuUFILzTpqaH3OQWR0lUwcoDDGmT+VZleW+TZfzpgwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=4PRRCtnsd2N0/QZQuuOnqrgCkoVP/kdjVn3npmjDYHE=;
 b=ZgD189L902nGEGKTtKbifSqM9BZDrJ1l97Icq2rNvzSSRlr72WO0WWYVPs6MNIY7bO9mbF+VS2X+fhBEUvTWb91MEFeevMbfsbqbF/XJPqGJkz9e9/LSD9vv1Wo9fB0qkoNCSDkNbH6FUptoO1hrMVVO2utI0ZgS2QkILTwZ2/IiQK7rfl7GvUq8vArrQ8+4oa3mybvNMO57QrxH83vXpxOrgbk+1m8d50iaX0uheh1Us61jPRBZGr4qRRi4rI0q+IaS8ncyvJKHHkcIZ66ElZjPKBMThR0ieYRGjml3hTIxCS3457rNqbTddyACSoV0H5nVa5yIy7KdEZfYDyLMbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4PRRCtnsd2N0/QZQuuOnqrgCkoVP/kdjVn3npmjDYHE=;
 b=p1Y0Yq5avijwRLR52k8MDidAPoj0nAbrX913MMSvp/HYpaDewGsCkCAF40Szz+AiDC39UKVrFAWBlsh4z37Csu9rayZZPeEW47jWXa8KIs3lExwi/H1X5t7+/b7ZwonOSw9SkMPNsMZcV1ZJjXSQ4ucI6t8gpV4TfXh2SnzrBZ8=
Received: from SN6PR11MB3422.namprd11.prod.outlook.com (2603:10b6:805:da::18)
 by SA0PR11MB4589.namprd11.prod.outlook.com (2603:10b6:806:9a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.16; Fri, 17 Sep
 2021 13:29:21 +0000
Received: from SN6PR11MB3422.namprd11.prod.outlook.com
 ([fe80::e139:9d6a:71c3:99c8]) by SN6PR11MB3422.namprd11.prod.outlook.com
 ([fe80::e139:9d6a:71c3:99c8%6]) with mapi id 15.20.4523.016; Fri, 17 Sep 2021
 13:29:20 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <andrew@lunn.ch>
CC:     <Nicolas.Ferre@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] net: macb: add support for mii on rgmii
Thread-Topic: [PATCH 3/3] net: macb: add support for mii on rgmii
Thread-Index: AQHXq8gFfC4whTgKr02hF/BnpVvgEA==
Date:   Fri, 17 Sep 2021 13:29:20 +0000
Message-ID: <eedae6e6-07d3-23ec-1f15-d928f3506257@microchip.com>
References: <20210915064721.5530-1-claudiu.beznea@microchip.com>
 <20210915064721.5530-4-claudiu.beznea@microchip.com>
 <YUNAqSz3sUPqoGx6@lunn.ch>
In-Reply-To: <YUNAqSz3sUPqoGx6@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e64cb6b1-2c0e-41d6-eba3-08d979df2834
x-ms-traffictypediagnostic: SA0PR11MB4589:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA0PR11MB458949C59B5C2A7EB7679C2987DD9@SA0PR11MB4589.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YzdBLvHMY6obPVZyfx2F84QOhFEDWTAdhbrBfTor5+sp5UFtHqHZHiImGiV2rYp6yONPjnEr88AftQeW/ZnVcpM+L5njHGJ6LZ7GS23sAMqLF2cgA+rTjNZoXTfzZEjy3PyDNjbxZd0t425XyOKTIso2C8C6+IW1t2W/Irg9XfZS6zGWCL0KW2YjYofBErliRJYqN6AuILZzFFORAFdBolNgmt++1wQwYgtTnqGOhqNu7MYjiISqyq4RxO52zRLjOsmLauZfHZUwweZl8q6rm1wXsq1frxJQUdkA3OHwexBOnjL/DgZnkghFB6db3GJ1gi+JtZnRr/etPkr6OTXHuzr7t+Z30lBqWEHAnr+3fkn6ubH/tfuQ9saHld92c9kfjVyhqmFOcpLb7+CB/ONPAm7OUeN7f4cCzxvNc9HmctM/V0QuyijRfi66xOpx7ejVbfGP1PUyGYY8z28rvPV3AC5GvArNax8geQ35fC2Rehp2tMBmhk5i3jLyF2WmifRYbUh2qn7yU/yQEi3Pt7LgaUs5fL3y12BaLsm8o8/vCChyp1vWGxpCmYxMpbCtdcBzmqj2EaLwV/W7Sd2y1TPTBcn6PVy8npJBxgy2oeitonqMy2ZNdyHqYdCvsrG8LQ/ErLznYIiCjOjQSuNPdJ5WcJGIsZA3scESeyCDGmig+yiq2fgUXqaUmkGaDh/4XpltuIQ05g9qaChQbl5cbKXb07rAEYJNy//+lNUQnzOHj5qjaW6+bDJ5DL5MFm1Ehs+kZ/cvwjs/SWhLEqGayZWBaQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3422.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(346002)(376002)(366004)(39860400002)(6506007)(8936002)(83380400001)(54906003)(4744005)(91956017)(76116006)(53546011)(38100700002)(6512007)(71200400001)(5660300002)(31686004)(6486002)(8676002)(6916009)(66946007)(4326008)(316002)(2906002)(31696002)(186003)(64756008)(66556008)(38070700005)(66476007)(26005)(36756003)(122000001)(478600001)(2616005)(86362001)(66446008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WEVlU0l3M2lLTTNBSE1FdEY2L2VOSGhqOGo4eEVZbG9uTWNwREhLR0hZMTN0?=
 =?utf-8?B?Z01xRmE0MUlnVjZ1TUIvaDRqR2Z6elJQajJLVXhja2VIRFhWWGlhcTR0VWZo?=
 =?utf-8?B?V1FpanRNQUFFWlpqTGFTSEkvbmxhSGlOMXhiVTY5WHVNZmdGYW1FL3J1STFS?=
 =?utf-8?B?RzdtUXQxaWgxTVpLczA0V050bzhDMzcrV29sQkExdWFxR3FENFUxakNCL2dD?=
 =?utf-8?B?cnh2ZVBLU2dBTHZYVEZ1SHNSbHRxc000bjRmZDdadzdTV1N0VW1Nckg1aEJB?=
 =?utf-8?B?V2xmWVhwTHJTVmR2RmQyVzk2dTZ0QVBTR1FXTDVJV0dLanlZZTMyRm4vZ293?=
 =?utf-8?B?Y0xUYzNINjluY3RtK1JpdG5qbDk2NDR5QkI0MGh4ejZRRnN3bU1SSGJoUi80?=
 =?utf-8?B?ZGUzQlBYQXVCTHhGZENqdFJRN1A3bFBEa2UxbWhnY1MxdVZ0eEEyY0M1S0VT?=
 =?utf-8?B?SjVPWjBkUnNyZ3ZxQ3A5UmwycnI3Y0lhRXdnS0NzVjhEc3RiQkFzcmJHYXM3?=
 =?utf-8?B?TkhCaEUrUHlJZUk5UFJ1cGtuVHU3N0RuRmlJSlh5clVhSGpoQUFQUmdGYjd4?=
 =?utf-8?B?M0NZckNZSjNLMUFkL0ZuWjMrK3h0MnZ0Y29CL1h5T1V4VW9SNms5RzBDTmRp?=
 =?utf-8?B?OEpBNDNzR0g1YVNucVR3QXVWY05LcnYzSjMwUkF2endVaWZkZWZ3Qko5djVX?=
 =?utf-8?B?Zmlxb010M0UxbnlvVWxhTjcrTFh5WDNrQldvKzhRbFBVdXE3WXdFQXk5TEs4?=
 =?utf-8?B?clh6UmFvc0RDM3kzamlLNzJDYlFjRitqNk1CSFRVMGlselZwOFQwaGhaenVR?=
 =?utf-8?B?c1BlZmVjY3N2dVNXVWxWQjhac08wc01yYzBiemZyK0pDaEFjTExiTytjc2VP?=
 =?utf-8?B?algrMEc5ZVdHMW9tQWR4N0FLeWlnazBjOFNxN0psaTA1TGVOOXZLRXg0T2Ju?=
 =?utf-8?B?ZWJpUmZmQUl4bDNJSjNEQkQ1NFJqbzE3ck5BQ254bG1LWE1PTGd4T2V5Q2tn?=
 =?utf-8?B?Uk9HSkNNL3dxeXR1R2RwaDVGQXZCYWUwdjN2dXNYTmdrSXpkblZCSzQvT281?=
 =?utf-8?B?cDRjOFI0TCtDVUs2cUZvdVNtWG1pbS9XMUY2WjE5b1ZiVkpFRjlDQmJDNmQ3?=
 =?utf-8?B?bGdSbHNtalJHOGdmSWJqekFEQXNEL2NJTkI1aFpTNHBJcXFqNDZMVEYvVG9h?=
 =?utf-8?B?cmFrL1hNWExObVZBaklmRWE0bUYyOTNDZXFiMi9vam5RMnJFSGwwRXY3YmpC?=
 =?utf-8?B?UmlXbnd1SkZ5OVZVMnZvaS9LVzVVVEZpczlrKzdocUo3djdhWXVoUUhUR0t4?=
 =?utf-8?B?Y1hEcDZBUWY5SFkrZ3RiMUVpNW9nMzJaNVFIaXFxOTlRVERaaEo0RjBBVktF?=
 =?utf-8?B?QkRnRHNrUTA5TldSNDlSbDNSc1hsaWk4Ym9HZkZ1RzdGSjdJdmJGaHd3SWdX?=
 =?utf-8?B?TjdyWUh2SGxnSHpJT2hmaitwRFRnMW1XNHllWWVHQ2lkWE5sdU1OSENiY08r?=
 =?utf-8?B?OHFqbldBNmpKY1ErZjgwSExDdWkzdnZxaThzdUpnNmo4ek8yUkdWZkRpVS83?=
 =?utf-8?B?M1hLcWREMXI0OTBzYTl0NW13Z3ZwUGR5UVN2aXR5MWN1YS9LYjJ6RkppVVlX?=
 =?utf-8?B?ckxqbVdxYStoblhpQk1EdFZCWXQwUVBYK09nYnBlSEoxRUtOM2M2SmJ4VUtj?=
 =?utf-8?B?aDFYWXBUK0JpNXJ4UWhwRitLZkFYSzZUcThSdUE5NUhNNnFEU0FWNy95RlRT?=
 =?utf-8?Q?5NG8veY7nJo4I4p6Co=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <037831C43CAC11479C860B32FC92E819@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3422.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e64cb6b1-2c0e-41d6-eba3-08d979df2834
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Sep 2021 13:29:20.7531
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Yi75Zx5pe3wRjTVBvgYRwHpHPLSSm97SiuhpVbLsk9OTn2KvMqfs6zBUfB/giNw81JQB1R7BW0kXKWmqErcY6sjru0xIk+9AaGRMgSSTwPI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4589
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQW5kcmV3LA0KDQpPbiAxNi4wOS4yMDIxIDE2OjAzLCBBbmRyZXcgTHVubiB3cm90ZToNCj4g
RVhURVJOQUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVu
bGVzcyB5b3Uga25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo+IA0KPiBPbiBXZWQsIFNlcCAxNSwg
MjAyMSBhdCAwOTo0NzoyMUFNICswMzAwLCBDbGF1ZGl1IEJlem5lYSB3cm90ZToNCj4+IENhZGVu
Y2UgSVAgaGFzIG9wdGlvbiB0byBlbmFibGUgTUlJIHN1cHBvcnQgb24gUkdNSUkgaW50ZXJmYWNl
LiBUaGlzDQo+PiBjb3VsZCBiZSBzZWxlY3RlZCB0aG91Z2ggYml0IDI4IG9mIG5ldHdvcmsgY29u
dHJvbCByZWdpc3Rlci4gVGhpcyBvcHRpb24NCj4+IGlzIG5vdCBlbmFibGVkIG9uIGFsbCB0aGUg
SVAgdmVyc2lvbnMgdGh1cyBhZGQgYSBzb2Z0d2FyZSBjYXBhYmlsaXR5IHRvDQo+PiBiZSBzZWxl
Y3RlZCBieSB0aGUgcHJvcGVyIGltcGxlbWVudGF0aW9uIG9mIHRoaXMgSVAuDQo+IA0KPiBIaSBD
bGF1ZGl1DQo+IA0KPiBZb3UgYXJlIGFkZGluZyBhIGZlYXR1cmUgd2l0aG91dCBhIHVzZXIuIFRo
YXQgaXMgZ2VuZXJhbGx5IG5vdA0KPiBhY2NlcHRlZC4NCg0KVGhhdCdzIHRydWUuIEZvciB3aGF0
ZXZlciByZWFzb24gSSBoYXZlbid0IGFkZGVkIHByb3BlciBmbGFncyB0bw0KbWFjYl9jb25maWcg
b2JqZWN0cy4gSSd2ZSBzZW5kIGEgbmV3IHZlcnNpb24gd2l0aCB1cGRhdGVzLg0KDQpUaGFuayB5
b3UgZm9yIHlvdXIgcmV2aWV3LA0KQ2xhdWRpdSBCZXpuZWENCg0KPiBDb3VsZCB5b3UgcGxlYXNl
IGFsc28gZXh0ZW5kIG9uZSBvZiB0aGUgbWFjYl9jb25maWcgc3RydWN0cw0KPiB0byBtYWtlIHVz
ZSBvZiB0aGlzPw0KPiANCj4gVGhhbmtzDQo+ICAgICAgICAgQW5kcmV3DQo+IA0KDQo=
