Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D097A49F50D
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 09:21:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347251AbiA1IV6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 03:21:58 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:28595 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232172AbiA1IVz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 03:21:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1643358115; x=1674894115;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=heO18YubTjiSPjRpOHhgdml/tKlaZqEWnk2D4yr/Rkg=;
  b=oZA/pGgoOCGZJLS7XN2FfQvZuUhVNSddUDdMfuzz84BZTgqZsGf5AaZ1
   T7XhlZ3mG874HrY6s0w8A2xEDgPW0sKDCpQ551HNToQX946PQqpjKywMm
   3kW8Lk05K1zJWFOXdNhqAPwlso9SHOypEaImuV6uKQZgTzzS4DvGVruc7
   upEA8CxLgEUrkxZvMTeToWtPUELbjFNtxEm8ieCCvfsmR16WxPYy2JcVg
   7qjZBG3xsE80HLKCfBB6l2hPXFHJKNNxWbHhpAMEg1smWvXryvRVjkRM+
   wlZWko5QMvbLafioQeEz7seMuFJ9cdkIawN/90Zn+WTsNcoZrk0XimgHS
   g==;
IronPort-SDR: S5oEnpLiRt4VWsKHPCNtp1WiJVuV9hVKODt5Ss07Ey6iwIl8TUpTdqGoBm9jASbF6B6jXcgcPr
 zRNo0RRXsM4ZuoVH/Ewd3HMMOKvMMPVop08dzLoH2QhsEl9fGsIMqEqcA601vIEm9SozGK4+Ys
 MqvFuD+XPfeDiwzFhMRnTG3oUNPlE6Wfyre3xOnEabEFb/j6FLiH9mPQNGujDxvGRtw4izKsQ2
 P/WwngKAaGFWA7DrMXF0ZYvYjLLoNA6EVGui00y5tVoCDBtJF3Pd0Q64uUfNQs/IiL3prkpCbA
 KMWt7v2swSgHHXCRU0Crb5Uq
X-IronPort-AV: E=Sophos;i="5.88,323,1635231600"; 
   d="scan'208";a="160316018"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Jan 2022 01:21:55 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 28 Jan 2022 01:21:54 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Fri, 28 Jan 2022 01:21:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QZo6uF4GVDRWC8EVp89bQVz18pG0d6DvHwz2ANbLxOd5Hq1C3a4CMIW3Pt0EBavVZIhEaBhA7sIGJV07SydbMp4qnIqY2afu0iNWuVTc3xZdafbshHJYGrz1KxC6dvjBT9f2FkZzdJQVWKeZsNXcIqK55FCNlR+1Ru9Ijg9A9DNa5NeZ6YTX/NNRHBSOhLGvwpbA9me1RaoY14vdjQw4YQLJmzbcgB74H1ggz3DVdQHUNRZKbdBMY1dx6Q/Z2g0WeYXpBSELlL5gbUJT0mfi1qzdRN1gSVhLihbjfkggSm2vs/kqEnd3WjprncxCBs9yAKqIYVyXduZ36flbW5bq+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=heO18YubTjiSPjRpOHhgdml/tKlaZqEWnk2D4yr/Rkg=;
 b=DEwHKGBHYFt20Csx2F8eV8oVR/JKm9SMaORAEtUqkKS5z0xCxpVU1Aos6rcoRQxFWpT0TJ/gf4PN7YcrX6+TfhneGhrcl5zf8dbkKAf6A0++OljviFxqyZWu3nhPOgRFkvPrQvjLlmmRlA/YcXsBYAAD9WQbdBDEzvE367J/8ZDCeyHwiMfoxOn9O1Kyssi/b9y3vluViYNjDyqXrR6kw2kqMjt2UqLBJGPNGRBhV439TrfiifQxZZKius0Ig05uBt8HIRMa8JeR6aZLcfR6aZlwLaqlSVo56vcuXqAwA83bGpadVwEAmAT2Ka+DyJxUS2T43RwghY4fFqWDcVhXNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=heO18YubTjiSPjRpOHhgdml/tKlaZqEWnk2D4yr/Rkg=;
 b=SYuUrEdhXb/sDDiiSB8u2WqYhU0irZ2mkHvo9MdNClC154G39J7QmXreBys3dHem3WLVb0PHUgK5/Tlmj4JeY8D//Oukjh+l1PJKMaPU8X9oPEu+jOAwk8lSYPxaEqKGnoXR9AMmfH0YqoAzBMKpRXk/ib7adgImXJcZa1MN5QI=
Received: from CO1PR11MB4769.namprd11.prod.outlook.com (2603:10b6:303:91::21)
 by PH0PR11MB5125.namprd11.prod.outlook.com (2603:10b6:510:3e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11; Fri, 28 Jan
 2022 08:21:48 +0000
Received: from CO1PR11MB4769.namprd11.prod.outlook.com
 ([fe80::5cae:e802:4a48:bd0f]) by CO1PR11MB4769.namprd11.prod.outlook.com
 ([fe80::5cae:e802:4a48:bd0f%6]) with mapi id 15.20.4930.019; Fri, 28 Jan 2022
 08:21:48 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <robert.hancock@calian.com>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <michal.simek@xilinx.com>, <Nicolas.Ferre@microchip.com>,
        <devicetree@vger.kernel.org>, <linux@armlinux.org.uk>,
        <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH net-next v4 2/3] net: macb: Added ZynqMP-specific
 initialization
Thread-Topic: [PATCH net-next v4 2/3] net: macb: Added ZynqMP-specific
 initialization
Thread-Index: AQHYFCAY+7R29WN3AEmMoCGuzJDu6Q==
Date:   Fri, 28 Jan 2022 08:21:48 +0000
Message-ID: <becfe55d-5379-7944-b380-6bbc7128b4ba@microchip.com>
References: <20220127163736.3677478-1-robert.hancock@calian.com>
 <20220127163736.3677478-3-robert.hancock@calian.com>
In-Reply-To: <20220127163736.3677478-3-robert.hancock@calian.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d1966d16-1028-42f8-f9e8-08d9e2373acf
x-ms-traffictypediagnostic: PH0PR11MB5125:EE_
x-microsoft-antispam-prvs: <PH0PR11MB512571BCCDE052964190A8DD87229@PH0PR11MB5125.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jCbRrHfWd9HLV5FeI0mqGcT4+Qjn9XQKDxVbPuoU50BWWUkfk8EIr+UQz+xoUQrilwtm7WvzTi6v++/ePSARHiJw5tDTjvwsvcyTeh4sf3KG8UQ7ObXeLpmBwex4vRN5EQIaPOlsOAvnT2Jc8UVDzkAC4/hG4pmkroEQgH78WwbVP6CV7TWQoatb5iwwnn2duTDx4ywOSQvH5uFbw21sk+709tGs4WM786llbjkUMLPfLXJk0Kwjsw0pq2hjLGFAbpUs+tk3gPKLsr+SBENB5wBu5MgRtzwKPUlB4eIcaVM4FjANhtU1etXgJz/8GUFZrl98aOJEPXf4Vzf4H1ROYKl9LG6KimJlC+XAgvMVAfFuGu4yzBvhieOsJQbQUMXzaOaFRoFG61g4V4QgweU3huFzSda1mX6LxthZxnQ5STeQg7E0LQwI9TnXk20B77QxIzAJ/5MhPN7a5WZpzga1jX6gQMF5TTAEsrTDgHAg3Kdy8yKiF9cgvY3111gspN/5imitPSTF3pGxvfLKDDaMNP+kVDij7/sYLNhMMfFeprwO5O4hyrWL+QB+XWTbuxbXDwPgOUBpafDPSQIFkIr1/W9vEI7gTwO1z+tn/JaTWkT4ne3EQGJkvmspIgfbgXTdaRLSG393RTdoMRPaHcr47mEK8w/twzpQFp7cyv7MteW42nSc8d2Aez4AQCWD9XyxmaT0kzY0kiJQrUnuQzlzl7XLMuoP0u3ip3SCaeFs0+J4vJHXNx0MlzeetjWECUgl3e6DLI+IHkIIz9q+AwsLDQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4769.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(71200400001)(38100700002)(110136005)(66556008)(36756003)(86362001)(76116006)(6512007)(38070700005)(64756008)(316002)(66946007)(6486002)(2616005)(66446008)(66476007)(4326008)(91956017)(31686004)(54906003)(508600001)(5660300002)(2906002)(8676002)(122000001)(6506007)(31696002)(8936002)(186003)(26005)(83380400001)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VlVaTXdpaEZyZGZUN09aSkJyQ3hKZ0wydVNOaHhJdDdDdmFhLzZ1ak43VHFO?=
 =?utf-8?B?b2VlRWRORU1oMm5TbmZhalhpeGlRc09qb1BTSkpiRmxpWmYwM0JCVzFNeitO?=
 =?utf-8?B?b1E0MlF0TytVV1ZDbExLRUIydW1FU2hHWnlEMFVUaUZXTUYyWFBKcVRIMXFZ?=
 =?utf-8?B?QndHcFNoaXhBUEdWSU5mN0p0SnNXQi9hanN3SUZsWElNU1YzZjZITTdLbWRI?=
 =?utf-8?B?R2NiUjB5ZWx4SWVmMkR5VkgzV1dnYXZROURQWHJYaHF5dUpMNXMxdFRIVjRG?=
 =?utf-8?B?UkIvcmxHYktIODl3MWRZZWxLSExZMWpMNzhPVlJRYWNXV3FWUFJrTm9jOU9V?=
 =?utf-8?B?QzFLNXdjSVZBYS9wbDFpYkRvRGZNbWxFcE11cE1TWEY2SEVpQStpdVlRR2NY?=
 =?utf-8?B?YU5mZm8yWkxmYTNoWGxqbmE2SVNISGQ4RmlVY2RCeTJPdEpOOGNBckxyL05u?=
 =?utf-8?B?NU5UOFRyM083YUNSMWh3K0l4TCsraE9WRUYvN2ozekJOVzRzaDZxd295Nmdo?=
 =?utf-8?B?cG42bndJZzltK2V3bzB6WDhNVFlpSWJrT2VGNGVObCtaeFo3ZGF2YzJKRW5O?=
 =?utf-8?B?SmhhTmQxaDJhL0o0M0l4NmhUU2V0TGVrKzdaeU44NXI5cnR4QlE1LzhUR3Qv?=
 =?utf-8?B?d09QOUJaeEpBdTc1SUhRTmRWbWRIaFoxUjJxOFBKNEg0L2tCRjgza1B1eDRB?=
 =?utf-8?B?S1IvbVJmNGJDZTJ1TEthaGkybTh1cGVGaitqL3hFWnI0NHR3ejgvTXZUZFJs?=
 =?utf-8?B?MHE5OElCdXRJYWdLK3luT2VlbTRycDI2dzZmckRNSmhvM1NocFVLQVltKzRl?=
 =?utf-8?B?cVFtbVdFR2QyTFdiU0VrSG03VnYxdTJLZ3Rab0dlOGZTS1ZnMkxzb0tJUVR6?=
 =?utf-8?B?S3BkSXZqRVJBTEp4d2syZXk3NlNKM3dreXMrMlpWRnR3ZGtwRHdWblZYbFRT?=
 =?utf-8?B?T3JBdXJhbzlWdTlmZUN6c2xIN053eW1CVWVITi9EQU9tSzYzeDdEUjRzQ1lX?=
 =?utf-8?B?YUo5Z2h2azBoU3pXMmRIV3BSUzhVL1FtN0c0S243Mm5CUzA4TXBmR1dKVWJv?=
 =?utf-8?B?SnhiZW9TbUNrNDdHQ2lVMVp3bHNnU2RTZG5WQTBKalZWSHZnZm4vNjYzcFh6?=
 =?utf-8?B?eWlDQnd1cDI5eHFZb3NQSlFUbWxiM3NYRGxjKzdtSVpleDQ0azYyendDUER0?=
 =?utf-8?B?Y3VwN0RqVGs3THU2MHRtRHMxVHhvSVRPdkIvLy9tU0JwOGJxcmoxL05hU3Bh?=
 =?utf-8?B?M3hJdGtGeERzQTdzLy84ai9aTUk2aC94NFBZMlNGL1M2ZnFQd2xNMlhSTXdT?=
 =?utf-8?B?c3NQT2FvL1JlT0JXQTVIeVNDMURVUVJZc21nSUFUM0pKU1pWRjZhTjBuWC9N?=
 =?utf-8?B?cUFDb0g1bTI3dTFLUU1MZVdXY3ZtT25PLzIvY3N4T0IwUmpmZWNVSHZoUXpP?=
 =?utf-8?B?SXVOcXE5TEtHaGhWVitMTVZkMXBFd2NjRkZlVXJzcWtyN0UxZGhTYWpEdlQv?=
 =?utf-8?B?RkZFaWRMaUtMU1Y4NkFpREpuOVpjZFNZWEg3dUhUYXVNdE5NV1piSVVQa1Nn?=
 =?utf-8?B?eU4wRTJCa01qakxsTityZXY3YnJHYnRuakkrNVRIZUt2a1F4clJCWDZRV3lU?=
 =?utf-8?B?M0tvaVhqQjZ2L3BkOWMyZ0I3RlF3RUJZSXR6UlY0NGhuOVpDRmxsZ3EveUkw?=
 =?utf-8?B?eHU1STBZSzhCa2tlVHVJblJQMm9vNDd6eHp2NWxWY244aTFUYWZFSks5VnFU?=
 =?utf-8?B?ay9ZVEtaNGpuTUE3ci9YMStxZVFoNlIwckhjOENkc25CZUJDQjdPN29hdmNL?=
 =?utf-8?B?bCt3TytKYmo4cktDVXpxL3I5YURxeDA2eTZ5K3FLaUdQVEQ1R1ozSndYQUpP?=
 =?utf-8?B?QlhNRzgyQWxvYzUyNjE1YTFWcHdBaFBmcEZoZW8yRWtQb2h3SmtuUGZuNlo4?=
 =?utf-8?B?MXRRVWVSSlV3ZkZaRTc3ZS84cjlZdmFKSjQ5dzVRSjlnL1U2d0kzeTlXU1Np?=
 =?utf-8?B?bUwyR05FTUs2Q0p6QThuNk1HSlBsUEErR082OFA1ektYWmp4bnJBSTVyRENW?=
 =?utf-8?B?Vnk3MFRwYWQ4K0hmdlN0amNzSlFqSi8yMWpwa3l2b3E0cEViS1dMdTBlaGRX?=
 =?utf-8?B?R0p2ZGdWLyt5N3pEYmFHeUlhbjRIWDk4dE9JTjkvNEVzYWFVa2VaYnJnM0g5?=
 =?utf-8?B?dDdpQUh3WExzNGVHTDFrZmZlYWhuVU91aW9qN2QwOW4zNjQ2ZmpvNHFhdjVL?=
 =?utf-8?B?aFd3NnRQMElTVEhBdzlaSUk2V1d3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FA9F0F0A3BC8CE40B972DAA15171A2B9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4769.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1966d16-1028-42f8-f9e8-08d9e2373acf
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jan 2022 08:21:48.6016
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jF57+yf9h7NANCN2zauFtojw3YTJMLqAvufqxL7h6ISUw1ZTeDAxLm6kDBFsiX8yGzAHalJvF+OSimy9CResqR0kGTxgJvkaNDMNV+WOqBM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5125
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjcuMDEuMjAyMiAxODozNywgUm9iZXJ0IEhhbmNvY2sgd3JvdGU6DQo+IEVYVEVSTkFMIEVN
QUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91IGtu
b3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4gVGhlIEdFTSBjb250cm9sbGVycyBvbiBaeW5x
TVAgd2VyZSBtaXNzaW5nIHNvbWUgaW5pdGlhbGl6YXRpb24gc3RlcHMgd2hpY2gNCj4gYXJlIHJl
cXVpcmVkIGluIHNvbWUgY2FzZXMgd2hlbiB1c2luZyBTR01JSSBtb2RlLCB3aGljaCB1c2VzIHRo
ZSBQUy1HVFINCj4gdHJhbnNjZWl2ZXJzIG1hbmFnZWQgYnkgdGhlIHBoeS16eW5xbXAgZHJpdmVy
Lg0KPiANCj4gVGhlIEdFTSBjb3JlIGFwcGVhcnMgdG8gbmVlZCBhIGhhcmR3YXJlLWxldmVsIHJl
c2V0IGluIG9yZGVyIHRvIHdvcmsNCj4gcHJvcGVybHkgaW4gU0dNSUkgbW9kZSBpbiBjYXNlcyB3
aGVyZSB0aGUgR1QgcmVmZXJlbmNlIGNsb2NrIHdhcyBub3QNCj4gcHJlc2VudCBhdCBpbml0aWFs
IHBvd2VyLW9uLiBUaGlzIGNhbiBiZSBkb25lIHVzaW5nIGEgcmVzZXQgbWFwcGVkIHRvDQo+IHRo
ZSB6eW5xbXAtcmVzZXQgZHJpdmVyIGluIHRoZSBkZXZpY2UgdHJlZS4NCj4gDQo+IEFsc28sIHdo
ZW4gaW4gU0dNSUkgbW9kZSwgdGhlIEdFTSBkcml2ZXIgbmVlZHMgdG8gZW5zdXJlIHRoZSBQSFkg
aXMNCj4gaW5pdGlhbGl6ZWQgYW5kIHBvd2VyZWQgb24uDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBS
b2JlcnQgSGFuY29jayA8cm9iZXJ0LmhhbmNvY2tAY2FsaWFuLmNvbT4NCg0KUmV2aWV3ZWQtYnk6
IENsYXVkaXUgQmV6bmVhIDxjbGF1ZGl1LmJlem5lYUBtaWNyb2NoaXAuY29tPg0KDQoNCj4gLS0t
DQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNlL21hY2IuaCAgICAgIHwgIDQgKysNCj4g
IGRyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvbWFjYl9tYWluLmMgfCA2MyArKysrKysrKysr
KysrKysrKysrKysrLS0NCj4gIDIgZmlsZXMgY2hhbmdlZCwgNjQgaW5zZXJ0aW9ucygrKSwgMyBk
ZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRl
bmNlL21hY2IuaCBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvbWFjYi5oDQo+IGluZGV4
IDlkZGJlZTdkZTcyYi4uZjBhN2Q4Mzk2YTRhIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9l
dGhlcm5ldC9jYWRlbmNlL21hY2IuaA0KPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRl
bmNlL21hY2IuaA0KPiBAQCAtMTIsNiArMTIsNyBAQA0KPiAgI2luY2x1ZGUgPGxpbnV4L3B0cF9j
bG9ja19rZXJuZWwuaD4NCj4gICNpbmNsdWRlIDxsaW51eC9uZXRfdHN0YW1wLmg+DQo+ICAjaW5j
bHVkZSA8bGludXgvaW50ZXJydXB0Lmg+DQo+ICsjaW5jbHVkZSA8bGludXgvcGh5L3BoeS5oPg0K
PiANCj4gICNpZiBkZWZpbmVkKENPTkZJR19BUkNIX0RNQV9BRERSX1RfNjRCSVQpIHx8IGRlZmlu
ZWQoQ09ORklHX01BQ0JfVVNFX0hXU1RBTVApDQo+ICAjZGVmaW5lIE1BQ0JfRVhUX0RFU0MNCj4g
QEAgLTEyOTEsNiArMTI5Miw5IEBAIHN0cnVjdCBtYWNiIHsNCj4gICAgICAgICB1MzIgICAgICAg
ICAgICAgICAgICAgICB3b2w7DQo+IA0KPiAgICAgICAgIHN0cnVjdCBtYWNiX3B0cF9pbmZvICAg
ICpwdHBfaW5mbzsgICAgICAvKiBtYWNiLXB0cCBpbnRlcmZhY2UgKi8NCj4gKw0KPiArICAgICAg
IHN0cnVjdCBwaHkgICAgICAgICAgICAgICpzZ21paV9waHk7ICAgICAvKiBmb3IgWnlucU1QIFNH
TUlJIG1vZGUgKi8NCj4gKw0KPiAgI2lmZGVmIE1BQ0JfRVhUX0RFU0MNCj4gICAgICAgICB1aW50
OF90IGh3X2RtYV9jYXA7DQo+ICAjZW5kaWYNCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0
aGVybmV0L2NhZGVuY2UvbWFjYl9tYWluLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNl
L21hY2JfbWFpbi5jDQo+IGluZGV4IGEzNjNkYTkyOGU4Yi4uMWNlMjBiZjUyZjcyIDEwMDY0NA0K
PiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNlL21hY2JfbWFpbi5jDQo+ICsrKyBi
L2RyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvbWFjYl9tYWluLmMNCj4gQEAgLTM0LDcgKzM0
LDkgQEANCj4gICNpbmNsdWRlIDxsaW51eC91ZHAuaD4NCj4gICNpbmNsdWRlIDxsaW51eC90Y3Au
aD4NCj4gICNpbmNsdWRlIDxsaW51eC9pb3BvbGwuaD4NCj4gKyNpbmNsdWRlIDxsaW51eC9waHkv
cGh5Lmg+DQo+ICAjaW5jbHVkZSA8bGludXgvcG1fcnVudGltZS5oPg0KPiArI2luY2x1ZGUgPGxp
bnV4L3Jlc2V0Lmg+DQo+ICAjaW5jbHVkZSAibWFjYi5oIg0KPiANCj4gIC8qIFRoaXMgc3RydWN0
dXJlIGlzIG9ubHkgdXNlZCBmb3IgTUFDQiBvbiBTaUZpdmUgRlU1NDAgZGV2aWNlcyAqLw0KPiBA
QCAtMjczOSwxMCArMjc0MSwxNCBAQCBzdGF0aWMgaW50IG1hY2Jfb3BlbihzdHJ1Y3QgbmV0X2Rl
dmljZSAqZGV2KQ0KPiANCj4gICAgICAgICBtYWNiX2luaXRfaHcoYnApOw0KPiANCj4gLSAgICAg
ICBlcnIgPSBtYWNiX3BoeWxpbmtfY29ubmVjdChicCk7DQo+ICsgICAgICAgZXJyID0gcGh5X3Bv
d2VyX29uKGJwLT5zZ21paV9waHkpOw0KPiAgICAgICAgIGlmIChlcnIpDQo+ICAgICAgICAgICAg
ICAgICBnb3RvIHJlc2V0X2h3Ow0KPiANCj4gKyAgICAgICBlcnIgPSBtYWNiX3BoeWxpbmtfY29u
bmVjdChicCk7DQo+ICsgICAgICAgaWYgKGVycikNCj4gKyAgICAgICAgICAgICAgIGdvdG8gcGh5
X29mZjsNCj4gKw0KPiAgICAgICAgIG5ldGlmX3R4X3N0YXJ0X2FsbF9xdWV1ZXMoZGV2KTsNCj4g
DQo+ICAgICAgICAgaWYgKGJwLT5wdHBfaW5mbykNCj4gQEAgLTI3NTAsNiArMjc1Niw5IEBAIHN0
YXRpYyBpbnQgbWFjYl9vcGVuKHN0cnVjdCBuZXRfZGV2aWNlICpkZXYpDQo+IA0KPiAgICAgICAg
IHJldHVybiAwOw0KPiANCj4gK3BoeV9vZmY6DQo+ICsgICAgICAgcGh5X3Bvd2VyX29mZihicC0+
c2dtaWlfcGh5KTsNCj4gKw0KPiAgcmVzZXRfaHc6DQo+ICAgICAgICAgbWFjYl9yZXNldF9odyhi
cCk7DQo+ICAgICAgICAgZm9yIChxID0gMCwgcXVldWUgPSBicC0+cXVldWVzOyBxIDwgYnAtPm51
bV9xdWV1ZXM7ICsrcSwgKytxdWV1ZSkNCj4gQEAgLTI3NzUsNiArMjc4NCw4IEBAIHN0YXRpYyBp
bnQgbWFjYl9jbG9zZShzdHJ1Y3QgbmV0X2RldmljZSAqZGV2KQ0KPiAgICAgICAgIHBoeWxpbmtf
c3RvcChicC0+cGh5bGluayk7DQo+ICAgICAgICAgcGh5bGlua19kaXNjb25uZWN0X3BoeShicC0+
cGh5bGluayk7DQo+IA0KPiArICAgICAgIHBoeV9wb3dlcl9vZmYoYnAtPnNnbWlpX3BoeSk7DQo+
ICsNCj4gICAgICAgICBzcGluX2xvY2tfaXJxc2F2ZSgmYnAtPmxvY2ssIGZsYWdzKTsNCj4gICAg
ICAgICBtYWNiX3Jlc2V0X2h3KGJwKTsNCj4gICAgICAgICBuZXRpZl9jYXJyaWVyX29mZihkZXYp
Ow0KPiBAQCAtNDU0NCwxMyArNDU1NSw1NSBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IG1hY2JfY29u
ZmlnIG5wNF9jb25maWcgPSB7DQo+ICAgICAgICAgLnVzcmlvID0gJm1hY2JfZGVmYXVsdF91c3Jp
bywNCj4gIH07DQo+IA0KPiArc3RhdGljIGludCB6eW5xbXBfaW5pdChzdHJ1Y3QgcGxhdGZvcm1f
ZGV2aWNlICpwZGV2KQ0KPiArew0KPiArICAgICAgIHN0cnVjdCBuZXRfZGV2aWNlICpkZXYgPSBw
bGF0Zm9ybV9nZXRfZHJ2ZGF0YShwZGV2KTsNCj4gKyAgICAgICBzdHJ1Y3QgbWFjYiAqYnAgPSBu
ZXRkZXZfcHJpdihkZXYpOw0KPiArICAgICAgIGludCByZXQ7DQo+ICsNCj4gKyAgICAgICBpZiAo
YnAtPnBoeV9pbnRlcmZhY2UgPT0gUEhZX0lOVEVSRkFDRV9NT0RFX1NHTUlJKSB7DQo+ICsgICAg
ICAgICAgICAgICAvKiBFbnN1cmUgUFMtR1RSIFBIWSBkZXZpY2UgdXNlZCBpbiBTR01JSSBtb2Rl
IGlzIHJlYWR5ICovDQo+ICsgICAgICAgICAgICAgICBicC0+c2dtaWlfcGh5ID0gZGV2bV9waHlf
Z2V0KCZwZGV2LT5kZXYsICJzZ21paS1waHkiKTsNCj4gKw0KPiArICAgICAgICAgICAgICAgaWYg
KElTX0VSUihicC0+c2dtaWlfcGh5KSkgew0KPiArICAgICAgICAgICAgICAgICAgICAgICByZXQg
PSBQVFJfRVJSKGJwLT5zZ21paV9waHkpOw0KPiArICAgICAgICAgICAgICAgICAgICAgICBkZXZf
ZXJyX3Byb2JlKCZwZGV2LT5kZXYsIHJldCwNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAiZmFpbGVkIHRvIGdldCBQUy1HVFIgUEhZXG4iKTsNCj4gKyAgICAgICAgICAg
ICAgICAgICAgICAgcmV0dXJuIHJldDsNCj4gKyAgICAgICAgICAgICAgIH0NCj4gKw0KPiArICAg
ICAgICAgICAgICAgcmV0ID0gcGh5X2luaXQoYnAtPnNnbWlpX3BoeSk7DQo+ICsgICAgICAgICAg
ICAgICBpZiAocmV0KSB7DQo+ICsgICAgICAgICAgICAgICAgICAgICAgIGRldl9lcnIoJnBkZXYt
PmRldiwgImZhaWxlZCB0byBpbml0IFBTLUdUUiBQSFk6ICVkXG4iLA0KPiArICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIHJldCk7DQo+ICsgICAgICAgICAgICAgICAgICAgICAgIHJldHVy
biByZXQ7DQo+ICsgICAgICAgICAgICAgICB9DQo+ICsgICAgICAgfQ0KPiArDQo+ICsgICAgICAg
LyogRnVsbHkgcmVzZXQgR0VNIGNvbnRyb2xsZXIgYXQgaGFyZHdhcmUgbGV2ZWwgdXNpbmcgenlu
cW1wLXJlc2V0IGRyaXZlciwNCj4gKyAgICAgICAgKiBpZiBtYXBwZWQgaW4gZGV2aWNlIHRyZWUu
DQo+ICsgICAgICAgICovDQo+ICsgICAgICAgcmV0ID0gZGV2aWNlX3Jlc2V0X29wdGlvbmFsKCZw
ZGV2LT5kZXYpOw0KPiArICAgICAgIGlmIChyZXQpIHsNCj4gKyAgICAgICAgICAgICAgIGRldl9l
cnJfcHJvYmUoJnBkZXYtPmRldiwgcmV0LCAiZmFpbGVkIHRvIHJlc2V0IGNvbnRyb2xsZXIiKTsN
Cj4gKyAgICAgICAgICAgICAgIHBoeV9leGl0KGJwLT5zZ21paV9waHkpOw0KPiArICAgICAgICAg
ICAgICAgcmV0dXJuIHJldDsNCj4gKyAgICAgICB9DQo+ICsNCj4gKyAgICAgICByZXQgPSBtYWNi
X2luaXQocGRldik7DQo+ICsgICAgICAgaWYgKHJldCkNCj4gKyAgICAgICAgICAgICAgIHBoeV9l
eGl0KGJwLT5zZ21paV9waHkpOw0KPiArDQo+ICsgICAgICAgcmV0dXJuIHJldDsNCj4gK30NCj4g
Kw0KPiAgc3RhdGljIGNvbnN0IHN0cnVjdCBtYWNiX2NvbmZpZyB6eW5xbXBfY29uZmlnID0gew0K
PiAgICAgICAgIC5jYXBzID0gTUFDQl9DQVBTX0dJR0FCSVRfTU9ERV9BVkFJTEFCTEUgfA0KPiAg
ICAgICAgICAgICAgICAgICAgICAgICBNQUNCX0NBUFNfSlVNQk8gfA0KPiAgICAgICAgICAgICAg
ICAgICAgICAgICBNQUNCX0NBUFNfR0VNX0hBU19QVFAgfCBNQUNCX0NBUFNfQkRfUkRfUFJFRkVU
Q0gsDQo+ICAgICAgICAgLmRtYV9idXJzdF9sZW5ndGggPSAxNiwNCj4gICAgICAgICAuY2xrX2lu
aXQgPSBtYWNiX2Nsa19pbml0LA0KPiAtICAgICAgIC5pbml0ID0gbWFjYl9pbml0LA0KPiArICAg
ICAgIC5pbml0ID0genlucW1wX2luaXQsDQo+ICAgICAgICAgLmp1bWJvX21heF9sZW4gPSAxMDI0
MCwNCj4gICAgICAgICAudXNyaW8gPSAmbWFjYl9kZWZhdWx0X3VzcmlvLA0KPiAgfTsNCj4gQEAg
LTQ3NjcsNyArNDgyMCw3IEBAIHN0YXRpYyBpbnQgbWFjYl9wcm9iZShzdHJ1Y3QgcGxhdGZvcm1f
ZGV2aWNlICpwZGV2KQ0KPiANCj4gICAgICAgICBlcnIgPSBtYWNiX21paV9pbml0KGJwKTsNCj4g
ICAgICAgICBpZiAoZXJyKQ0KPiAtICAgICAgICAgICAgICAgZ290byBlcnJfb3V0X2ZyZWVfbmV0
ZGV2Ow0KPiArICAgICAgICAgICAgICAgZ290byBlcnJfb3V0X3BoeV9leGl0Ow0KPiANCj4gICAg
ICAgICBuZXRpZl9jYXJyaWVyX29mZihkZXYpOw0KPiANCj4gQEAgLTQ3OTIsNiArNDg0NSw5IEBA
IHN0YXRpYyBpbnQgbWFjYl9wcm9iZShzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2KQ0KPiAg
ICAgICAgIG1kaW9idXNfdW5yZWdpc3RlcihicC0+bWlpX2J1cyk7DQo+ICAgICAgICAgbWRpb2J1
c19mcmVlKGJwLT5taWlfYnVzKTsNCj4gDQo+ICtlcnJfb3V0X3BoeV9leGl0Og0KPiArICAgICAg
IHBoeV9leGl0KGJwLT5zZ21paV9waHkpOw0KPiArDQo+ICBlcnJfb3V0X2ZyZWVfbmV0ZGV2Og0K
PiAgICAgICAgIGZyZWVfbmV0ZGV2KGRldik7DQo+IA0KPiBAQCAtNDgxMyw2ICs0ODY5LDcgQEAg
c3RhdGljIGludCBtYWNiX3JlbW92ZShzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2KQ0KPiAN
Cj4gICAgICAgICBpZiAoZGV2KSB7DQo+ICAgICAgICAgICAgICAgICBicCA9IG5ldGRldl9wcml2
KGRldik7DQo+ICsgICAgICAgICAgICAgICBwaHlfZXhpdChicC0+c2dtaWlfcGh5KTsNCj4gICAg
ICAgICAgICAgICAgIG1kaW9idXNfdW5yZWdpc3RlcihicC0+bWlpX2J1cyk7DQo+ICAgICAgICAg
ICAgICAgICBtZGlvYnVzX2ZyZWUoYnAtPm1paV9idXMpOw0KPiANCj4gLS0NCj4gMi4zMS4xDQo+
IA0KDQo=
