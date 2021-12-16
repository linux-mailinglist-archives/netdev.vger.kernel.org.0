Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F8C8476B5C
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 09:04:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234668AbhLPIDe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 03:03:34 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:58218 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232160AbhLPIDe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 03:03:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1639641813; x=1671177813;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=2YMG3azsKrVTuiJEF+fm3RJob+wbI/9vVhAE6wD2sLA=;
  b=Akj+6aV/V9YZv0+mnqDp3eRSVQ8x/M++xOX6eNHwCndlC8z1zaALdEVm
   KXKtYEhYvCHs7yFIZvgnx3Ot18Z42ikg19a8Uqbxr9i0ZhoYlNFlIrk5K
   aDG+lwdsoIPR88BAmoh1H2nCvVgtO7vRUQt8YT2DvJYYKK94RS8DAqgLz
   S111+UThICO4vUJgNxaqFe4A3dbGLtda9iyH9RKnZqtxbaoe+Lmwdxzxj
   jxMGMSC1bb6VoHrCgKXLWW93oxdn0QhQs0/XCl4fYro6EKDpcHYiN36hk
   hW0kGcjOiDEkT6kZ1o3Rtw+x92oNWyxlV15oPOOqjtmk+n1i8o8H7Pjih
   Q==;
IronPort-SDR: OBWISRKHEkSiPZqEf4tpjl+amNgRqp/43c/wUcaS29T/lrGxTFomiIKt+riHFSPXRvZHLUNhz3
 RTqCg5PWHxwF/QxDaWJvPoZdv9zmgq5Wj4R43+HiamBXDi4GWVaIu3KIewlEUT+E9/M0Wfr100
 R/2D+BtrHnTz49FrnCKzNratFE3xE0Dch10ojd3SHh3SuCFpL1fo/m0sPjmckqc9Oc+f4E+gbG
 4Tvl3R8+9CM5cNtuU7r40ozEd9ZAYCqrBb7sfv2uqTCbDIbg5+5JXTx8LfgnZK8350ed0v/Z3Y
 CZuxTyGphoz7C0ODoh4IO17a
X-IronPort-AV: E=Sophos;i="5.88,210,1635231600"; 
   d="scan'208";a="155698236"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Dec 2021 01:03:32 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 16 Dec 2021 01:03:32 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Thu, 16 Dec 2021 01:03:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CHJTYgaUaH9VDmcobeznipv7XEUCdqPrEPJgI1Fjsm1tSICdDiKlQPEG4b/RZpS5URZ9AmR7gZDxX437KkzEOGEDEqdraRXUhkuNG5/rLBpeGwerwJceH1JOFw58Em1iyzfvYBgY0HO99/fPSbFtdOlM3PwE8IxrMJiG0Fffx3AeyvjEycqAwZAL4tt2d72zi59X8p4x8XU9Fu2A3LtZ/9tlsRyPuQ82qYumJb9H/Tq4P1ozxQD3JUDR/LfD0OaK4rjkASCM0VeDmO58TUkQyDtE2iL/8QdP12D7eumYNoiRVbW/vlYJ1cxBvf1bn8R/Cu4CmTQOYxh785oZQsU3wA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2YMG3azsKrVTuiJEF+fm3RJob+wbI/9vVhAE6wD2sLA=;
 b=PnqFIFcpFTpyrWtSvroYZKQbcpk0ZnDcsv+EaQo4MpUhkv1A5X38muVvLblXpRW30ahfuDHgdeyo/jFZ+tS5+s/I9cNMU8sCblu9mUZup5vdsmPNSbIzcUqAOxTYgYm7I5o9uClm4ZFQOcfFE3NoiTp3dvs9zGrHl9scNXmtHASRZi0jbrHFpczegJABkvV0I5smV2iS2ATgWyUWaImeu2qOmwHTOubkqv6a2y/aR7490TxJSjKWJYrkOWh0hsLq4jnucx+fAFAQyxOwUHpxd7+iwgUVlHf82Hx1uM0IDUG0w/nQowRsfyd8Pj0mWNqqrvO2LyzAKgDlRj+c+0yUUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2YMG3azsKrVTuiJEF+fm3RJob+wbI/9vVhAE6wD2sLA=;
 b=RNg/cz4tkL3C54CA0V4aW/GJeogX5Il3oJvyF8OV2+8SQ3PyIHE00qUNXGWjKXV7yAHhJxGS0wv0JdXfzdGZO94Suf9eB2g7mm4hITW5zlKUn94MCi7VUQfSh4Ps2FRe7+ytOXPwTlTt9bmSxSfVA0A82EqrsWraLSebwCMBCu0=
Received: from CO1PR11MB4769.namprd11.prod.outlook.com (2603:10b6:303:91::21)
 by MWHPR11MB0080.namprd11.prod.outlook.com (2603:10b6:301:68::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Thu, 16 Dec
 2021 08:03:30 +0000
Received: from CO1PR11MB4769.namprd11.prod.outlook.com
 ([fe80::bd93:cf07:ea77:3b50]) by CO1PR11MB4769.namprd11.prod.outlook.com
 ([fe80::bd93:cf07:ea77:3b50%7]) with mapi id 15.20.4778.018; Thu, 16 Dec 2021
 08:03:30 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <davidm@egauge.net>, <Ajay.Kathat@microchip.com>
CC:     <adham.abozaeid@microchip.com>, <davem@davemloft.net>,
        <devicetree@vger.kernel.org>, <kuba@kernel.org>,
        <kvalo@codeaurora.org>, <linux-kernel@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <robh+dt@kernel.org>
Subject: Re: [PATCH v5 0/2] wilc1000: Add reset/enable GPIO support to SPI
 driver
Thread-Topic: [PATCH v5 0/2] wilc1000: Add reset/enable GPIO support to SPI
 driver
Thread-Index: AQHX8lNptAFIKJMeMECxZ9XnkZfRHg==
Date:   Thu, 16 Dec 2021 08:03:30 +0000
Message-ID: <7e133bbd-df1d-6252-3f81-ed70ef91ef90@microchip.com>
References: <20211215030501.3779911-1-davidm@egauge.net>
In-Reply-To: <20211215030501.3779911-1-davidm@egauge.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: da22d4e8-d303-414b-75f5-08d9c06a8ca5
x-ms-traffictypediagnostic: MWHPR11MB0080:EE_
x-microsoft-antispam-prvs: <MWHPR11MB00806714E0D350FD0835910687779@MWHPR11MB0080.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TVTVerbTptwl4eywo2GCyfRl4HNVukEy3+PNVq+WUZXy1f0R4vFyxvP9WY9CaJ6q69ANgPVd8eTGgAv9dWTif8SiemLkGh0IDO11fp14tDrHAS5UjAy/cmHtDrzW3ukvuNN5qal8j9ejbswKRVlR67zju25rWbHHFARj1ZriYAX+j7i/462T3C4uXeVhdkLF8KZE6Io3mlJYRxd6nu3EVgxvmjBWuWsYLYndMUC3i9ZS427y97Thp5FMmrKdDVlwAcar92vv0wy7vthxL/72+fygjeO1U12q7855uv6ZRppuf4jy8jldgwDqtjalNx/S1Z8F+1vK1JI6VMDHkCPI9M2B4F8A1tjFR/qWfZDg1a5ZYFRhBT2u6YYJfGJv01/HLbjlTxt2q6+dHdb5VyfBQs4vRs5oJ61sBaBel8RAiBZrg0hMSURangalv3K9gd55AgcsHIp2ACvBAxFjGY9uXqQEIxEFMVwPYGLYVBvRwRTAztnVO83jQIFxBGCd5iq13plg3m/BNzGnZYfkKXfOsQdgTxGkjJqxT8HZJihmftIujDPaMR8mwm5hzKW/tj4+wyaR6Hbso5bmVHIarvyYTQb+e8VTaKmwgZxIq15DA8jmiwUAE+eBFPIgoC0/vjlIlUCUvQBXrXxuYmx2O+dC21/XIyYIX2ww5irxADLPvguCes3JbADR1LQATKpDF/dW3XGaig6qGDnFfC03y9ckDiBtDUVPGJNacGBruBdOJnbCANCSoO/CFa4USeTb51MliLEv4N0dfnpvTjnFl82YmQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4769.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(110136005)(508600001)(122000001)(36756003)(6506007)(2616005)(8936002)(64756008)(6486002)(54906003)(53546011)(6512007)(71200400001)(8676002)(38100700002)(316002)(66556008)(66946007)(66476007)(26005)(6636002)(86362001)(38070700005)(83380400001)(31696002)(76116006)(5660300002)(66446008)(91956017)(186003)(4326008)(4744005)(31686004)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L1laVG5IcXFjR2hDVS9SNm83ZFRHeUpYekRUQUc2U0F0MWpqaXRLUkxXb1JL?=
 =?utf-8?B?Wi93djBaKzQvRk9SMER3anY5SFlyZGU4RlRnK2VzbmdSbzFhVG9aOUtvNzBj?=
 =?utf-8?B?ejlQb3ZURzQzZzV6VktqdFRZbDJKNnBRbi9USjJYRGlFUEVDaDJjcnZqL05n?=
 =?utf-8?B?VlZyU2h5V0tFVkNDNUNZUGl1UXpLTTg3eEN5bUVnL2NVb0pkRHdqNHpZczN0?=
 =?utf-8?B?elllcU1TRXN6c2k2am5VMHVhNUZaSHpzSUIrWURZcUp5b0hZaHV5aVJxd1R6?=
 =?utf-8?B?VG1lYVNEaWFJSUJBZUFsdTBKei9mS2RMRXM3UXZmbDZUYVZtQ1RlVGdxRnJq?=
 =?utf-8?B?MWxpeFltVjJQbVNtaXVvM1pMTVZ2Y3drYXZubmZhL2NyRDAzOGUveGhldFVq?=
 =?utf-8?B?NFlFdnN4Y09pem5EOUtMOG9ick9vVW1YVTJrcW9HY0N0QTZjZmYvWjIxRVMw?=
 =?utf-8?B?Y2N4S0dpbkliYXhLQ09zWFlkOHo0TzgvKzcyT09OYnVSdlppc1hONjJEanhY?=
 =?utf-8?B?N0FvZ0FaSGJKbVovcGk0QkhpZG1lRzdzUmMxWWFiUjV4YVp5bC9jUDMwOG5r?=
 =?utf-8?B?Wkx6TlVUbHc0SG5MODEwSXREeFhkQ2IrZ2FWcHY1M0JVS3RkdUNhc1gzOFUw?=
 =?utf-8?B?Sm9ZUm0wK1hSVVQ2VHZlTnV1R0k0NHNZSHcyN3VwSU5CaXBSSXhkMDRRdXZ4?=
 =?utf-8?B?djVZaUJadExxaVpPOE5qTnZTUisvU1Q0MHpGV3pUSy9KK3NnVHE1NWZHU3Q0?=
 =?utf-8?B?WHczMWlGL0F2OHpqcUNtZit6QXBoZzB2K3dwdm44MC9YRExVaVdwYUx4R2ho?=
 =?utf-8?B?cHN6elJLUWhJSkJBOVJCNGtRSmgwbFRvd0t5YzZxb2ZHMFpVbWliY1U5ZXhY?=
 =?utf-8?B?MFB6c0lJT05WWDhLTklNOXRxR1V1cXRpS3p0b01WSHovMWhsTmt5ZjlsWXBh?=
 =?utf-8?B?OEdDMUd6bkxmWDdtUmUvK056cjZ0QjlPM3RyMnh1WTJFZFpxWXBkaGpEeTIy?=
 =?utf-8?B?dTFBeS96TXlKaGpBRndWemsyRGx0Z0duT25FQmZESzVDS2RxQk85YUJZVkRD?=
 =?utf-8?B?c3FUNU1sTVhrMXJhY3NxVUVESHl3eit0UWU2OEdUejdYOFZHbVZscHlieDRI?=
 =?utf-8?B?TUpOZ0liL2x2S0lYNC90RXA4T0N3Y3V6aUN3RzJXbWYrZVIvNVh6SWQwbk91?=
 =?utf-8?B?bHpITUZYTnFnMDBvM2EvZFY3aVRJTmNkZHRmQ0twTkd2Q1kvSndYc3BhWU1s?=
 =?utf-8?B?TUVGSUgzUDBnVkV2amlHTllwWGE5WlY1Qk9wVzV5MTFPY2NhVDhsYzdaQ2tt?=
 =?utf-8?B?NlJJL2dmWXlCRTBhWVNzMnI3N2grNTEwT2JUWUlyMzFzQkJWYnYreTF0Y1U4?=
 =?utf-8?B?a1RnR3FvZUNlQlkybEJhWUZUZmtuVXVTNURDNy85aTZKRFo1Z2dUMGZZeUEw?=
 =?utf-8?B?OGZMbnYwanhKNkdlakZHSElzaWFtWGxPdzJWcktNRGlHWXBvdTQ5M3Arek1I?=
 =?utf-8?B?S1dQWWhDOWdCQWJRMTdhZ3h5Y2lnZDhXQlZzQ3ZhcjB0SW9BTE1vcXZHR0w5?=
 =?utf-8?B?NmY1dFA3dmdLVDFDR3BDSjF1UlZlNy9jRUVSeHFva3lwZ29YYnkvWTNsbzk5?=
 =?utf-8?B?TlZYdjBDVE8zSTVUQ2F0b1ltblFCSURZYWZmdHF0WElHd1MrcEpudDc0MEt4?=
 =?utf-8?B?TzdtTHFoQUk4OVJzRHRmV3NIcDlKaWJLeFRYVG1NdEZjNTJwWUxkc2VQWHVM?=
 =?utf-8?B?Wlo4dFRudG9sNm1lZkgyVHpBbVJ2VmlleVU1YXcxMUpKSDBoaTFjS1V3Vjlw?=
 =?utf-8?B?QldLS2wxalIweGdoTEk0S3ZBWnFhaU80czdlVWRiZlZ1VU51UjUvUlpNWDlJ?=
 =?utf-8?B?RlRTd1pjQTVWbjQwTFNQOU9iSHllbU9YTnhETUtWTjllWGxrQS9qNElGQ0Qx?=
 =?utf-8?B?T0poOXNnZ0VXOVVtL1N6OGRmV0VBR09TTEFrOHcySTRGYlJrMms1RHpyZ0Nl?=
 =?utf-8?B?emRjNjBidHpORmI4YmJobU5ZT0wwcnlUSEIrbXZwMXBlMUp1TU02dkw3WUIr?=
 =?utf-8?B?ek9Fb2grMGEwajFEZ01KbzMzY2dsdmczaGR6Q1VOS1paVUplaEpsRnpDUEkw?=
 =?utf-8?B?TCtiRmhqcHR0Y3BHeTdPem1JOXo1ZGZUVWFib3F6L1E3Z3JDSjRWc2lqQU5M?=
 =?utf-8?B?bGpUemowVTFHbCs0VlV4elF0K2ZPNWU4cHpmMVcyQVFpZGFrdkU3WVFhY0tI?=
 =?utf-8?B?dUs3RUZ4UWhwVVlTblAyVzA4Wlp3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <716A1A1A46FBB542AD3E26EEEA14D501@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4769.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da22d4e8-d303-414b-75f5-08d9c06a8ca5
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2021 08:03:30.6812
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vDk/TsXgw9mJX6Ninwv1F4qqvQ0Ft+nfcs9aoSGQg9iXp34QfHdoGLkA6db/9IccsmhoLV6K7ict77y9QXXOebz1vcb2k325xGE+5YRiF7o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB0080
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTUuMTIuMjAyMSAwNTowNSwgRGF2aWQgTW9zYmVyZ2VyLVRhbmcgd3JvdGU6DQo+IEVYVEVS
TkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3Mg
eW91IGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4gVGhlIG9ubHkgY2hhbmdlIGluIHRo
aXMgdmVyc2lvbiBpcyB0byBmaXggYSBkdF9iaW5kaW5nX2NoZWNrIGVycm9yIGJ5DQo+IGluY2x1
ZGluZyA8ZHQtYmluZGluZ3MvZ3Bpby9ncGlvLmg+IGluIG1pY3JvY2hpcCx3aWxjMTAwMC55YW1s
Lg0KPiANCj4gRGF2aWQgTW9zYmVyZ2VyLVRhbmcgKDIpOg0KPiAgIHdpbGMxMDAwOiBBZGQgcmVz
ZXQvZW5hYmxlIEdQSU8gc3VwcG9ydCB0byBTUEkgZHJpdmVyDQo+ICAgd2lsYzEwMDA6IERvY3Vt
ZW50IGVuYWJsZS1ncGlvcyBhbmQgcmVzZXQtZ3Bpb3MgcHJvcGVydGllcw0KPiANCj4gIC4uLi9u
ZXQvd2lyZWxlc3MvbWljcm9jaGlwLHdpbGMxMDAwLnlhbWwgICAgICB8IDE5ICsrKysrKw0KPiAg
ZHJpdmVycy9uZXQvd2lyZWxlc3MvbWljcm9jaGlwL3dpbGMxMDAwL3NwaS5jIHwgNTggKysrKysr
KysrKysrKysrKysrLQ0KPiAgLi4uL25ldC93aXJlbGVzcy9taWNyb2NoaXAvd2lsYzEwMDAvd2xh
bi5jICAgIHwgIDIgKy0NCj4gIDMgZmlsZXMgY2hhbmdlZCwgNzUgaW5zZXJ0aW9ucygrKSwgNCBk
ZWxldGlvbnMoLSkNCj4gDQo+IC0tDQo+IDIuMjUuMQ0KPiANCg0KQ29tbWVudHMgYXJlIGNsYXJp
ZmllZCwgeW91IGNhbiBhZGQgbXk6DQoNClJldmlld2VkLWJ5OiBDbGF1ZGl1IEJlem5lYSA8Y2xh
dWRpdS5iZXpuZWFAbWljcm9jaGlwLmNvbT4NCg==
