Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8F0B31D1BE
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 21:52:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbhBPUvZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 15:51:25 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:5905 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbhBPUvV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 15:51:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1613508681; x=1645044681;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1F4APEiOpJ1DOcV7cJeKKkZhvxCSb/Qx/q2evz0c8R8=;
  b=qmfK9ixSzPF6SuxxE3iwdtoNW4VhXBGuqWX5GdDCDHv5WoRAF/TpPVpX
   5c32ab2Io59GZ5Vd3F1eeupQ1BbbHVXUNw+nXbSMbU06v4wlWbIbwiJAd
   sLlvGGi02Ld04Oqejt1XdSVO6DCYBViKqqAW4hq3uyD0zbK43NXavEmtY
   OTB3cd4cX9JPWQIbxdoON5gT+6es01hwFZA6YIcmNaEigNo0V6nQw9bW7
   SImozsj/BQXTmOAIYt/jHtR3FefVZKvli5I/lB7+PxNg+FsHDtgQmzc1X
   GYYF9fIMIRo6FzuCy//Kc9c4X33FAEdtEEqcrWttUUw+FyPCellGDb0dm
   w==;
IronPort-SDR: BdOJz3IaaG1eIGh64qFuIUpRUTdNV6+QXaU8mm0Ut9ZxqzmcA1k7905WKZfoX38uiNxAgA/Zol
 mGh0LrOipjvDzbSgpxnB9YZlgwZMK59/L7Fnt3slcesvE0FTMpRtH3hrWpBEjjYJl5CEewiD1R
 eSbedNjWI/bCR0y5krAC4jyFhIpl5oAnGM0pIdfS/xjSj9pqeyppZYxPOiZkHjnuxkZmCy6GXL
 D51AZwuNyDg2/RzS5+rULs3DYPp4Rr1ZnLKGw6tDXWdyLnhauSiwwG4CPXc+Iz95je1HP8x+Mz
 e7E=
X-IronPort-AV: E=Sophos;i="5.81,184,1610434800"; 
   d="scan'208";a="44313689"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Feb 2021 13:50:05 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 16 Feb 2021 13:50:04 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3 via Frontend
 Transport; Tue, 16 Feb 2021 13:50:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dp1eJv20Pt7jN/3h0OIMYVqLlF+W0duroqhMtAUHQYTJkNWuecpHjwNtHHPoDXR3S1C34PXRpJ0PNoNGW7m+F0rmHQZkkKlpr2YjblDV51uXOiCKQexpJPnKovBsuMJSl00ZjPll9/Rc+nPnpyuIJyFMwo0/4GVpOsXna/9n1Zj4nFVHOyBOp6ZPqvqzYB63g3fybceBpXwT6WUrJE/tKfbrWmJm4zC1b8OBUxM193nS0fSDVKRcD9SllxQdeq6vN5XN3uWUrOywoQFkXMv89f/ssPHAbrWDSbBJTk8RWTyxz2MinotT/R4GrHyMOepXLbU2D6ZGbOglI7ELXixnaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1F4APEiOpJ1DOcV7cJeKKkZhvxCSb/Qx/q2evz0c8R8=;
 b=SSHjbRuwVd3t7HgX8xKmM/UfqcY5BA5ngFfMtQ2oOKFeSDS2uYsj2LsDF6UZqsJqaafGGSfUi9X3FTkQzCPh67j9slhwovX2gKBCMdy6lwitJNlCo2vkp3yb0ZPffVO562ZDFExjB83bimg0Wr3sZAs9jAGWYrrz/EYmHN8bkHkIUOqNSIPKYxKxxg7+BQeUvJ4ikKoHugs1IuF9ZGoZg0gmLDr0wa4X2RYHeurLkBsgzwyH1kowh8CSWMUwtpanGX1jvas0vuMfGAq+yb58JSyx3CBeuYerQ2LI9VzrYEIkKPr5ZCtGtxoHOfFbTLu0EBxDDAwNGbOr8u37wvtg+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1F4APEiOpJ1DOcV7cJeKKkZhvxCSb/Qx/q2evz0c8R8=;
 b=idYcU6ELYBxJXTwS3se6gIZFW+858ZAG5bdHTFkyAnfMxAR7072dd1h5YD56djdRpcSxau7Zt3nDi+4G5vjIKHgdIPvxU7VJ/psR8bDZ2dHwc77a1drF6OLCr5My3bN1SPpRsiIfXFKkYbUqEx2fl12u9v/ChqALHSXVbYEUm9E=
Received: from BN8PR11MB3651.namprd11.prod.outlook.com (2603:10b6:408:81::10)
 by BN8PR11MB3570.namprd11.prod.outlook.com (2603:10b6:408:90::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Tue, 16 Feb
 2021 20:03:41 +0000
Received: from BN8PR11MB3651.namprd11.prod.outlook.com
 ([fe80::497c:4025:42f7:979b]) by BN8PR11MB3651.namprd11.prod.outlook.com
 ([fe80::497c:4025:42f7:979b%6]) with mapi id 15.20.3846.038; Tue, 16 Feb 2021
 20:03:41 +0000
From:   <Bryan.Whitehead@microchip.com>
To:     <thesven73@gmail.com>, <UNGLinuxDriver@microchip.com>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <andrew@lunn.ch>, <rtgbnm@gmail.com>, <sbauer@blackbox.su>,
        <tharvey@gateworks.com>, <anders@ronningen.priv.no>,
        <hdanton@sina.com>, <hch@lst.de>,
        <willemdebruijn.kernel@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next v3 2/5] lan743x: sync only the received area of
 an rx ring buffer
Thread-Topic: [PATCH net-next v3 2/5] lan743x: sync only the received area of
 an rx ring buffer
Thread-Index: AQHXBAA3zpO4glf08k+QgrH43CopMqpbNaLQ
Date:   Tue, 16 Feb 2021 20:03:40 +0000
Message-ID: <BN8PR11MB36518045F806DAAC37BBD659FA879@BN8PR11MB3651.namprd11.prod.outlook.com>
References: <20210216010806.31948-1-TheSven73@gmail.com>
 <20210216010806.31948-3-TheSven73@gmail.com>
In-Reply-To: <20210216010806.31948-3-TheSven73@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [47.19.18.123]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 12d2a1a6-31cb-4365-9f8c-08d8d2b5f4e0
x-ms-traffictypediagnostic: BN8PR11MB3570:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR11MB3570E7226D54A018842BA8E2FA879@BN8PR11MB3570.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2MWeUwxw6uX1TCR2ijU1YdoEO0JzJC4MyBmirwbwmiXKsPFgFjlShGG7eTwzI/RJZ/WIDVeVd8WVeJTV6GA7IH4llg/Tqn0HH6jGPKtConI9QmCyUmyWPzH/WzISqDc6tvZQMhDJjuZ91WWB+hF0ydpzjuVnHXZ5wZRH3E5ERi42YHiz0RHxDqyjkPkowHy2AeIa2kiDtBmeBO1SxC684g6fPmLhLV0PnIvpMUGWqffX4QAlZexO7agm7C64r/zj63cUDl4jcVwHCyWxiSrBwYGEoKUKJ44QLQOhE+AlwnPmdHKEKOyAn1RcBRVEq6sE1OhT6hoMEoKb7BhOdgmiOX7GWorVoYNrmq03cXnb1yVFjsEZBkPn2Qw5XsKEbA2WxtXTmQFkwCPB261jHo9g9J0FWnmczEgOCnRMXq6TXmt+/0w3FIZSACDvUnld7hb9kiIZks2TodO/6/QIAbUGTCX2zH1PWj3vOJ60KWpKBBTvRivA7m/dB748JRe4j6i4xUuXxYmg7jmcE49RpJ7qSA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR11MB3651.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(396003)(376002)(39850400004)(346002)(110136005)(9686003)(6506007)(8676002)(66476007)(4326008)(478600001)(52536014)(71200400001)(54906003)(316002)(55016002)(26005)(83380400001)(64756008)(86362001)(7416002)(186003)(8936002)(4744005)(7696005)(2906002)(66946007)(66446008)(76116006)(66556008)(5660300002)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?REhmQmd3cEtWbWdvT3RzMVdnWVRSeVJKNUVwbmU0Slc0VTBMR3NEYkhCRzZG?=
 =?utf-8?B?MHN2S0ZGNm1nM0V5QWFFVWpDNDFqTkdvVnRwbldONCtJcGRHRTAvNUluaXNZ?=
 =?utf-8?B?VWNleDdCb1VYOUNyNWdSM3pYdDd3ZUIxWVVXV2RFR2xXRFl4aG81QnRlUWIv?=
 =?utf-8?B?OWJVYXpjMXJqNDdpdjNvdEkxNmV2N3pUbGdDYlZ0VVhkdlhIZ0pxNFBmOUxt?=
 =?utf-8?B?b2xPOG1naWZFbVhIZGhDQURZZThjclJMU1lPZnlOU3lhd1BTUTBuKy9aV3lW?=
 =?utf-8?B?Z2Rta2hTVmlhTXVzeWErQUlEOVJZdDRxRGpZTjVUNnBHYWZjWUN3MzlvTEd3?=
 =?utf-8?B?akNlTFEvb09veEE2eGxYWHNlUzVCQVdwbjBSSnpBWFJ1ZXlpelFMOE54MlBO?=
 =?utf-8?B?Y1pqQ3ZHdUZXWVlTdnU4UUtiWmdySE5hbSszVzAzMmx5czM0bUU2QmZRek16?=
 =?utf-8?B?ZFo3Tjl6RlVSaUlqZ211ZHlZajhjdnVVYU1uS2NZWTlRcWM1THA4Z3ViTFBR?=
 =?utf-8?B?Znh2clZFN1Rwd1lTbHVoZ0VqczhvZ3pkR09xUzZSdmV2UTZJbkI1bVp0UTVF?=
 =?utf-8?B?UzhPdC9SVHdWWXpjaEM4NlhzMU9KUWR4T2NPUU1uWG81SjR2U0dSMEFPblBU?=
 =?utf-8?B?cmZ1aE9vaEV3WjBEZUNUVHBYbHZNeVY4UzZtMksrOGZYMmlIUUZBd2IxQ01U?=
 =?utf-8?B?VHZBWGNTS01aVzd6ZmZGc29Da3BLK0JaR2JSQjJ0T0x3K1NVYkRpbVRRRzJO?=
 =?utf-8?B?bG1GQVN3SkxrVEhma0plTnJKZ1l6ZnlaZmFONmlGRVFvNk9GTjZTOThSL21D?=
 =?utf-8?B?WEg4aWRSUm0zcUt6c3B5Szk5a2JIaHMwZG45dWVqNnM3Z3EwbkFkM1VERVpH?=
 =?utf-8?B?ampnNk1JY0cxR1haMDJEN1h3UmFONVA0bWsxSVR0ekh2REljbm4yQWlWeHpy?=
 =?utf-8?B?Mm8ydTRVSzdBQkVaZlAvVUFYN3FUYVVBZVhLQ1ZZeFJ6R0tzcEV5cmQzcnB0?=
 =?utf-8?B?eUZEcVcyVUdEejZxR1FWOFhPRSt2eEJUK1JuZThUV0MvTzdRN2dWbzIzU3Qr?=
 =?utf-8?B?K0RUOEozTk5SVFo3Ti9hb29sTHlHNG5Fa3lySzdYMk13YmZBbmdoKzJOMVJk?=
 =?utf-8?B?QnhvTkZqQ0xIbTluUVdmaml3VjN1YjBJNE5FMXVHcjVac2grODBJTmIydjlK?=
 =?utf-8?B?Z2lKRjBpZHlqT1BFL2syd0VNUXZsd0g0RXpvdDM0ZS9GdjUzZENxTlB3VkFi?=
 =?utf-8?B?QVk5dSszelNUTzJGSXJPM3Bpb005NURPN2NZSHNyK0sxYWZFNmNoU3FuWFVG?=
 =?utf-8?B?Z2ttbS96RmF5dkNxWmN1eWlCamwzVW1tN1pvbjF0WHh4V0lOM09wZHhZM0FE?=
 =?utf-8?B?bzBTNGlQNVd2VGpWakh3YkxqN2Ivc2tDdDFiSGNicnhqRittQnA0RmZ6aSth?=
 =?utf-8?B?R21CaU1tZkUzZy9IbjBuOTBhYVpNRnRBNjB2YWk1QllPdzIwV1ZJamtZQU9l?=
 =?utf-8?B?RU8vNVBNZVNCR2M0WFNOc3lUY3N6TUI4aDFjbFRPUllCMkxEVHVPeWduMmg4?=
 =?utf-8?B?R2h2alcvV0hGVHkrbUVUU3kxMis5SW5ERkdqZjNQZ1FRL3FNOXJsWFV1ejBD?=
 =?utf-8?B?Q3F0OFNKbzYrR2EydDFhaWgzODQrdVcxVCtyc3Q4Q3h4WjhWSkwxT3l1dGZK?=
 =?utf-8?B?MlViNkc4RmMxWVdCWnVmUUh5aXB4clZhYitZbDNBT1EySVhsU2JaeFE1T0dI?=
 =?utf-8?Q?cKVIhYYT+WxXMxIpor8tcbmrdSEj78PD6tkCvYx?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN8PR11MB3651.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12d2a1a6-31cb-4365-9f8c-08d8d2b5f4e0
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Feb 2021 20:03:41.0411
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tyWBOE0S1lCSOIQkU/cEho2SBxpEtbj0PbXkW5NxrcyaImiU6TuL02iy6d8XPts8Xgkq1BzUoPzS7oiaZywaDFKZr0MjCNG3jbQ9c5mVFMk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3570
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBGcm9tOiBTdmVuIFZhbiBBc2Jyb2VjayA8dGhlc3ZlbjczQGdtYWlsLmNvbT4NCj4gDQo+IE9u
IGNwdSBhcmNoaXRlY3R1cmVzIHcvbyBkbWEgY2FjaGUgc25vb3BpbmcsIGRtYV91bm1hcCgpIGlz
IGEgaXMgYSB2ZXJ5DQo+IGV4cGVuc2l2ZSBvcGVyYXRpb24sIGJlY2F1c2UgaXRzIHJlc3VsdGlu
ZyBzeW5jIG5lZWRzIHRvIGludmFsaWRhdGUgY3B1DQo+IGNhY2hlcy4NCj4gDQo+IEluY3JlYXNl
IGVmZmljaWVuY3kvcGVyZm9ybWFuY2UgYnkgc3luY2luZyBvbmx5IHRob3NlIHNlY3Rpb25zIG9m
IHRoZQ0KPiBsYW43NDN4J3MgcnggcmluZyBidWZmZXJzIHRoYXQgYXJlIGFjdHVhbGx5IGluIHVz
ZS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFN2ZW4gVmFuIEFzYnJvZWNrIDx0aGVzdmVuNzNAZ21h
aWwuY29tPg0KPiAtLS0NCg0KTG9va3MgR29vZCwgVGhhbmtzIFN2ZW4NCk91ciB0ZXN0aW5nIGlz
IGluIHByb2dyZXNzLCBXZSB3aWxsIGxldCB5b3Uga25vdyBvdXIgcmVzdWx0cyBzb29uLg0KDQpS
ZXZpZXdlZC1ieTogQnJ5YW4gV2hpdGVoZWFkIDxCcnlhbi5XaGl0ZWhlYWRAbWljcm9jaGlwLmNv
bT4NCg0K
