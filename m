Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C437346675C
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 16:58:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359291AbhLBQCG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 11:02:06 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:46783 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359285AbhLBQCE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 11:02:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1638460722; x=1669996722;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=znNNwo4a5FOcoF30/x31/TE/POoFET880DnSFl7pxrQ=;
  b=EW9h2ryApBDug9gzOoNuZACJY5N5BPJ/cm2d7dalzj+OLJEkf3VOzVPq
   YzBwI8gaZR61dynt83qEYmR1Jj4bKi8FxVSFx5yMaBO/X6ompzULFSzyz
   3kalyYzAS01k5dSsTZ1AvTNRK3nGHR0PAONJZ1iC6K7oloBKQHoiax6ip
   yNHOI4HFnA6Zn5wU5p8f1N0L4GJ8iR2X1iKBnCnXCuCJQWSXj1thlmoOA
   dhjfelSOyJh7G88xl2NwbISlORESn0Vzxx26X0slAxrqan9G4/DoX3UR7
   XUtFGQJWxfq8mx6vDuJ08CNA/X5PwKhaQh2umvVN3pVpFmmKpEMqhjsNg
   g==;
IronPort-SDR: lAOFMiDSPICiWRlWoGALqAgQxheZ9D64CQEc+aHkYCzbPN+ETpymHgj0tMbHnHQ8U9DZ8K0CNk
 3ypbGw/a3W3Uvfcd+DW6maaxqSyp43Va+v2EasCd9BdSlnCOVE2bY8WP+4sWxxNHhXvyXs1EfD
 7Vys3DS23UIewifWBcngXSXYa72NZrhASje8el2l46XD1c8E+awPsVythtyoIKi0g4yNQRxwdv
 kGKmbTdbK6LT+6h+qGIDMPhb7E/piXD/lzkWkG9zjp+oLb2TANC6iO1g70Rh9jVVrFFmmkPuhr
 Fxy8fO8qZsOYAxBmH5wC4su5
X-IronPort-AV: E=Sophos;i="5.87,282,1631602800"; 
   d="scan'208";a="78291244"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Dec 2021 08:58:41 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 2 Dec 2021 08:58:41 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14 via Frontend Transport; Thu, 2 Dec 2021 08:58:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e+UE4fmC6vzh0+NqssPFK1ABZuCKzQezJhFz5xMmWU7KmV5zbBxru0gd7BLLC1EBzaHzJ03LdVsc1Z1F6wosDoLpXQgYMmFuNucgPQKw0NF40RXTUYnZxIMq4eC6+sB2NccXbYFkk0WP2+CJ9AruHBwtpa5AV/NLUsCqXM/QP5ISvQ5l/gnOjM/ENlQHPfZ2nt7d4ttt6VFQ4uULusypYozYyUFqk60fIFDSSHowY3vLxolZes0BNI7rkR6hOJ3G4/2vk/DQ2WvEpuMbOD14Q28a0VpIz0r/4P89jCddkE6FAH+j5PZTcOrhOiTA3QRe2eSEI6ZnyPiyK7AR6VzwcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=znNNwo4a5FOcoF30/x31/TE/POoFET880DnSFl7pxrQ=;
 b=fWJeIWZRcCvTKElk0cbsu+xmYbnT4enjCoc8ZTjGUMGQCVJYvkdtcnlnDGn3ZbBrlFs3Ct1pU15fywawI8TxWJQPbA1AYmtILokQBoKqWkykvAZmj07I/1XksNHwI3vT+2hMP5IlmD5sepf5qDhTNxhMUhDA/CRqtSJxm+DmTM9tQoSw3QMy2v2CE9vveTCTKAv3U/Zqmw9lWRY+6P2AcE2to/y3EY+PL/QF+KNbV6kZNWIkKZk/4nBLSrqN/JQSHmwfYf6j8xrh8eQYYN5HuXSHQSq14uUTwPTPL53u99lMn2+i0rQM8xzNxGI2nLk8sJgasMO32XlarsSr9UVSmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=znNNwo4a5FOcoF30/x31/TE/POoFET880DnSFl7pxrQ=;
 b=h8fyBsBE9BkP4aHEMRDIbFI67lLI4mEw1cuQM71YjBanXQecsH2OMR7YrhrmqzUDeFtLAMuSXcLQu4d5puhTbuGpWP2l1By5sgP2YGGIIA6ULssqZrXkBuR20Oq8l4lEtuaqSKN/4ijHwidMawwVL1lDo2SinQTcvnPIYUxBdbQ=
Received: from SJ0PR11MB4943.namprd11.prod.outlook.com (2603:10b6:a03:2ad::17)
 by SJ0PR11MB4912.namprd11.prod.outlook.com (2603:10b6:a03:2ae::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.24; Thu, 2 Dec
 2021 15:58:27 +0000
Received: from SJ0PR11MB4943.namprd11.prod.outlook.com
 ([fe80::b481:2fde:536c:20a0]) by SJ0PR11MB4943.namprd11.prod.outlook.com
 ([fe80::b481:2fde:536c:20a0%5]) with mapi id 15.20.4734.028; Thu, 2 Dec 2021
 15:58:27 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <davidm@egauge.net>, <kvalo@codeaurora.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <Claudiu.Beznea@microchip.com>, <adham.abozaeid@microchip.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] wilc1000: Add reset/enable GPIO support to SPI driver
Thread-Topic: [PATCH] wilc1000: Add reset/enable GPIO support to SPI driver
Thread-Index: AQHX5zB3Q+6UfrvgnkmXj6/HIhoj8qwfXIAA
Date:   Thu, 2 Dec 2021 15:58:27 +0000
Message-ID: <3dc58b44-98c4-c733-1170-e587a9ad7efc@microchip.com>
References: <20211202034348.2901092-1-davidm@egauge.net>
In-Reply-To: <20211202034348.2901092-1-davidm@egauge.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fbb9d884-1249-4023-8fba-08d9b5ac942b
x-ms-traffictypediagnostic: SJ0PR11MB4912:
x-microsoft-antispam-prvs: <SJ0PR11MB49122C8FD795F3A855C54646E3699@SJ0PR11MB4912.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: osZIk/O8p7QIKTCfx0EEbZs4tcOqFfvXgeN0NScMNmIZ4H6FJXDTiwcY0FDmur8wfT7CJgxgfOQqBwKFSuDwnQU4KZ2ARhgNJZqwIB+GwaPDnsMoa07N0KS8umBlsnaJpQ+nko0S4u6QPHTtcyRF2iA3wQq89N9by2Ptiwbr0nY+xwA6S95mRq9m0X8hNAqgADiyVfgm+Q6pA6niiMZgagL5jVMOgtYjmEW4aUvXXN6OtKBeBQ/y/+o/KQflzTG6sBDxybaW5P02MmiQDqdY6QqbvQ7LSmedZwe30s4P+tcodmsRC2pm7Q65pwxdhGnqfxOQzdp+NT7zADQ/bbY7yKzQ3paLsZnbDod/WnHYyES+2TU6mpyR9QUyt8i5VvEI2HvOdr2d2SmLEk8ePMqYhaUmfYL8zZ7Jb6HYnHgWH2nQ1Kxdqv5LM4CaaFZmSrlr6vsDFHHz9CgIbrswdHgRqWJ96I5I0tcqboo033MWrqXUZY6w4oSvHTIuk9EI2h2xrJ3UYrSewKX8EYMnotyvNZQsWHQyt0ViAAY4hzrPCCAoWqsNGhGEgDfSrKD4/uUS2H/4LT4SeORJuUWKporfL7nvgSNLquTkmSpADUK87xbHzAc11EdR3y0bTGtpqEM2mfpbvhAEhn0ixPIxFVo0UP/0vgdpfbBtXzn2Qrz9M9n5i1wKMlvx5NrnBJORO2LTpuqn4xejY/jA5/eMi6g5blDHUCLFTYPrJuWD688NINaxbC1f9cL1KsITUGY2oz/sgKzK1niXsG3nTNXxO2oYng==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB4943.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6512007)(5660300002)(4326008)(76116006)(31686004)(508600001)(55236004)(86362001)(316002)(53546011)(8936002)(6506007)(31696002)(54906003)(71200400001)(110136005)(91956017)(186003)(4744005)(66946007)(66556008)(64756008)(2906002)(66446008)(66476007)(38070700005)(26005)(83380400001)(2616005)(6486002)(36756003)(8676002)(38100700002)(122000001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MlZjRkJZZFd4cEJUSHc1YjZRUzM5RzRDWlV1QUNXdGROZmtxQWx0emdSTnB2?=
 =?utf-8?B?NVAyQWVqWWpYLzc5c24vOTNJSHhVYjIzTzhxZnFEenNncXpVSzRacjZWdTQy?=
 =?utf-8?B?UXd0dWovZ0JHODFuZ1pnTFRLSmJPZzlQZzRrZi8rVTlhTFZVeHJvVytSZEpP?=
 =?utf-8?B?Sys3b0lTd3Zyd09KUGRrSzFIaGNLRzgweVRvcUZqVnBTMWVQSjl2bldlRWZI?=
 =?utf-8?B?Y2FISlNwUWlINEtmVzBESUx2eWdoZWVNL3B5UXBRSzhFcUNUUTRLd0Fvekwr?=
 =?utf-8?B?V0N0WXc1NmRlRk9za0xVQkI2Z0RoOTBlZWJGQzRJcXFPaDJzMVIyay9yNmxS?=
 =?utf-8?B?a1liTlRaOHFoWUZKRWpMaHU2cHFDWHJoZTNGWnUzaVNLTGtyM09xWlZZWnlz?=
 =?utf-8?B?ME9uUFVxN0NvdUlINEFHdGFqR2xSWWIvZlFBVEI5LzBvVC9IbnZsT2NqNUdV?=
 =?utf-8?B?bzliWTdJUmJ1NTJlQjRtcE93ak51ZitoYW0vZm9uZ1dpVlhMdU5meWMwYVpT?=
 =?utf-8?B?RzVkOEZKL1cra3NqY1lGbzBDVXlaS1N3bFdnRXZBN0t4cGlrZTNLYmU1MTJ5?=
 =?utf-8?B?eEk0YnFJcTJ6eXZlS3FlT2d6QWFVYmkrRFZCSFYxRU9WT2Y2ekxjTmxXSldz?=
 =?utf-8?B?Z3psemhVMHFXcnNYVHJ6KzZQTERmTW9YZ2NLOVE4MXNiTkpjUzU0TjkzOXJt?=
 =?utf-8?B?TDUrV25aMnRIZ2hZRkQ5ckNuNnNlak1FSG54QjNPZmZoclh3OEtUN3hoQkJ1?=
 =?utf-8?B?UFE5NUY0cFhUL0ZybUxycWV1UDFrMGd3elE1cUF0R3pJMXdROTNpZGpyVzZj?=
 =?utf-8?B?MkxpZmpkdTRrMG9GRlErOTRlaFI1cEtJaW5DaW5PckVVZExuYzNNcnlVTTRQ?=
 =?utf-8?B?dHlkdUNhK2RFSkJXYytHYytzMHpMQXc1NHNJUVB0TGJBdXBvd3NqSldocE5O?=
 =?utf-8?B?bnA1eGlpdFNqSDg5cHU2dkVQM01STHFiWVVpS1F0R1JSSWwydlByeG1ZdWVq?=
 =?utf-8?B?WHRxQUh5dmVVVUhiQ3JvTW1VWmovbmVLNmt3cks5QWtUdWtWSFZrUVdvckhU?=
 =?utf-8?B?SGJydE13RGNlT1ZvNGQzdDNLQXZEYzRmbmZ5dkJsU2xJSVZaYTgzR2MyWFNE?=
 =?utf-8?B?WVNsNzNaRk51VUw3cU5VOGUvejc0SUxXUE1URjhxcGRIQThxbEhXUGN3TjB1?=
 =?utf-8?B?d1hYb1g3WXloVlJrVGxnUGovYzVKLzZoLzRMOGVCVHdJVDByMXJlNzJlNnJK?=
 =?utf-8?B?cC9oR245RTI5MlZuRklaTDBmWU5PTWhOOVV0YVNNenJ6b2ZrNFM5K1ZtLzY1?=
 =?utf-8?B?eDMrUXI1WEw5OTZmQWdGTlUxVzNKVlhYeVRkL3VrMzNNRCtQQktody9uby95?=
 =?utf-8?B?eUhjRXdTTGFVV1g5Q1A1SWZkN21tc3dNNURPV09nTmZDUDVicUlMZlJFUGVZ?=
 =?utf-8?B?a3hyZG95QnBTbGdiUVFmbkNVaXpZS1YyampDQ29zYWRwdEhnV0ltcXFLY2Mx?=
 =?utf-8?B?cGxJTjUzYVlWZDUrOEp1VTVPSklvMEJ0WElPMTh5VGllWFlHU3cxRENiNFBZ?=
 =?utf-8?B?RHBzM0k2RHhZQnpreEV6NzlzVTZvOXJvTUdkK0F4VmdiVzR6aFNKaDZVQVI3?=
 =?utf-8?B?M2U5aVVTREVFQy8zMm1BWDNWbXd4UjE4QU1HUzd1Z0h2YytJdVI1VDFmNUFi?=
 =?utf-8?B?VndLd0plZ0RKUk5vVW1hdnBwTXJZL0Y0d1NYRlVVbUVBaVJZam5zNjEzcktI?=
 =?utf-8?B?b2lXWnI1eTRPK0ZPK2htakUxYWZEeHlzRTZiZWtyWlZoMkZIYmVYSVdrNXA2?=
 =?utf-8?B?cmpFczdsU3JnZkh6UG80cXJiUTZGZjBydlU0Z3dHc1F0THRLL2lHS2d4VU1q?=
 =?utf-8?B?cG5ZMWpibk94SjhCWHFtQk5Dd3FtTlhPcE9KdlNhZkttWVMzWS9PbmlZSXBl?=
 =?utf-8?B?SW0wcnNXUjhxMXBoV2hFM2tKcWhrdVBVaWF6bGVadEVaM3loSFp2Vk9BZmZ6?=
 =?utf-8?B?WmhaSFpidEs0S2h4bTVKYmsyamNmTk9Rd3ZieURUT1puU21MRWtoUnhlUVdG?=
 =?utf-8?B?N2d3TytoUFYyN0libzlZYUQyUGt1RC8vNjZvL1ZCYjZGQWdLZHg4RUNjK1RP?=
 =?utf-8?B?MWRaQ2JQTUlVZnlCdFdPbWdGSjd2THNneW5iY1o4eHlXZ29MU0ZsbVB1cHpW?=
 =?utf-8?B?SmlWOTV5S2NHYklaSWYzemNJNDFZbzlGWkw2akhoZW5obGhlT0lPN3p0ci96?=
 =?utf-8?B?VDhHOUV5cTZ2QTRrZVJ0OW5hdFpnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F31F3FAF40CF274389D070132A754D8D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB4943.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbb9d884-1249-4023-8fba-08d9b5ac942b
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2021 15:58:27.3186
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6ZSt0O33TJS6ElL/L1D2YQ0OskQ3PlGWMVeE7sEGZfI49W3Mm9+QDLDMIFzbsWAn+V4qNUGg9y9et4gu4Q4oDSfEAMK3/5BQNSsTrGgrTxM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4912
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMDIvMTIvMjEgMDk6MjUsIERhdmlkIE1vc2Jlcmdlci1UYW5nIHdyb3RlOg0KPiBFWFRFUk5B
TCBFTUFJTDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNzIHlv
dSBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUNCj4NCj4gVGhpcyBwYXRjaCBpcyBiYXNlZCBvbiBz
aW1pbGFyIGNvZGUgZnJvbSB0aGUgbGludXg0c2FtL2xpbnV4LWF0OTEgR0lUDQo+IHJlcG9zaXRv
cnkuDQo+DQo+IEZvciB0aGUgU0RJTyBkcml2ZXIsIHRoZSBSRVNFVC9FTkFCTEUgcGlucyBvZiBX
SUxDMTAwMCBtYXkgYmUNCj4gY29udHJvbGxlZCB0aHJvdWdoIHRoZSBTRElPIHBvd2VyIHNlcXVl
bmNlIGRyaXZlci4gIFRoaXMgY29tbWl0IGFkZHMNCj4gYW5hbG9nb3VzIHN1cHBvcnQgZm9yIHRo
ZSBTUEkgZHJpdmVyLiAgU3BlY2lmaWNhbGx5LCBkdXJpbmcgYnVzDQo+IHByb2JpbmcsIHRoZSBj
aGlwIHdpbGwgYmUgcmVzZXQtY3ljbGVkIGFuZCBkdXJpbmcgdW5sb2FkaW5nLCB0aGUgY2hpcA0K
PiB3aWxsIGJlIHBsYWNlZCBpbnRvIHJlc2V0IGFuZCBkaXNhYmxlZCAoYm90aCB0byByZWR1Y2Ug
cG93ZXINCj4gY29uc3VtcHRpb24gYW5kIHRvIGVuc3VyZSB0aGUgV2lGaSByYWRpbyBpcyBvZmYp
Lg0KPg0KPiBCb3RoIFJFU0VUIGFuZCBFTkFCTEUgR1BJT3MgYXJlIG9wdGlvbmFsLiAgSG93ZXZl
ciwgaWYgdGhlIEVOQUJMRSBHUElPDQo+IGlzIHNwZWNpZmllZCwgdGhlbiB0aGUgUkVTRVQgR1BJ
TyBhbHNvIG11c3QgYmUgc3BlY2lmaWVkIGFzIG90aGVyd2lzZQ0KPiB0aGVyZSBpcyBubyB3YXkg
dG8gZW5zdXJlIHByb3BlciB0aW1pbmcgb2YgdGhlIEVOQUJMRS9SRVNFVCBzZXF1ZW5jZS4NCj4N
Cj4gU2lnbmVkLW9mZi1ieTogRGF2aWQgTW9zYmVyZ2VyLVRhbmcgPGRhdmlkbUBlZ2F1Z2UubmV0
Pg0KDQoNClRoYW5rcyENCg0KDQpBY2tlZC1ieTogQWpheSBTaW5naCA8YWpheS5rYXRoYXRAbWlj
cm9jaGlwLmNvbT4NCg0KDQo=
