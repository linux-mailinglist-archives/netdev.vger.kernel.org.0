Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC91768973A
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 11:48:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232422AbjBCKsJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 05:48:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231614AbjBCKsH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 05:48:07 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A9E61286C;
        Fri,  3 Feb 2023 02:48:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1675421284; x=1706957284;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=YjPoPK+G6SRFgGkI643+YWgxAEs6YRis/ZnYBCdFd3s=;
  b=cWwDOXNwNF4pYt7g3UBsixYW6Mx5krt5DE+7i318/hj0yepYMKye5k+Z
   C7c22RxClQHq+UJmp7DdyudOX99eKqSB1pWyiOJ4gHbwtRWHg3ulwW7Pr
   WL52jYhP+FZmg3PrfGQCaETlo9iv2gRVN2yXF6CX7Hf4RRtZ37fhQdnjr
   NdZbwqylT4Lomd+UrC9n8/E6ekEmSjTYF9BsqpXvOlQh3az+teRaeGGM9
   cuiGtKgi/PMJPJLoz4gKxsMq1xAZhtoFAfU3m4B+9/SkAHRrK83u+Kyew
   tHxu7cV/EDYS4rM9BxEV5eqlRlovJ+fwF7sb7qmcTDzBX1CgiLNuu2Y0N
   g==;
X-IronPort-AV: E=Sophos;i="5.97,270,1669100400"; 
   d="scan'208";a="199203751"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 03 Feb 2023 03:48:04 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 3 Feb 2023 03:48:04 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 3 Feb 2023 03:48:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AoFIKL3YMrUBB3AF65frDuIZHtnO1gp9dKfVT0pLh9Jovn8ZUhbgXo78p3uoqzkmyIx3Gm6pa9JYMFvcxSONIzz1rtkYgG7T+e0k08VI01Whlpg1jCAgV+DR0+KoGWHa4g7WtnYQdNXxsadjMU02LeFU9Cj8eqTx1XG+HG4ilx6pTaVRLKg8xQDhRgxXaICmkQwSwE/0TejnGjxRq3ZSr/ptJJB+4EKgsa30HRk7qVwyT2w0g9BY51ehqXZrRdzABKvEITHA0k1geQyxm+Ve3ruZfFRQoZaGNUiT36X6iGNVfkcaZg0MY98XbvZZ+tO9G73K40uOf540Moprk63weQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YjPoPK+G6SRFgGkI643+YWgxAEs6YRis/ZnYBCdFd3s=;
 b=JbhXNDkc/7aNbhk14vFFUDLhUKYVU6O87e03KEr9p+ii/F87Q5eoIofotfiRwkqYLLf+neqXTMM9HnNNwyyW+8DnkGdkjACurMtWvBZgqLylvQem5oB1pIHHwkmfnfakDzHHKOxy2ga8J8tuj8pLfd04rmFXdex04teJPiYpJRB8pz13JZx1n+LAsKe3Ker3Pqy7qKKVh2sfEBb0BVKME4pUKxEkS3xXCbXFjwqBoOqowdbT1z2L2EXECT4TcXtbTtKNmZfinAwNRNbk9BFR8e/eH9HHtYvPFx7qlSwckHIw+pGh0fzrnygDAv51waAX2uW67q/ObkRmQ9BHNFbLJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YjPoPK+G6SRFgGkI643+YWgxAEs6YRis/ZnYBCdFd3s=;
 b=d87YbbADxUq2bAL7Gzr3SbUQIH5QnoZQSDLHnSpv2SKvPH3IT+hUt1/suvUoXkuafgU9qLL3Km+ijwioNghLz8yDwv4fk0Sah9aV+C/DZn7D3+6Fd1cRGTFS8KSMTwDdjT9PW1yPQB1vPBMvwSiw/a6kLdOU4e1uTubiYItdAbA=
Received: from MN0PR11MB6088.namprd11.prod.outlook.com (2603:10b6:208:3cc::9)
 by PH7PR11MB7596.namprd11.prod.outlook.com (2603:10b6:510:27e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27; Fri, 3 Feb
 2023 10:48:02 +0000
Received: from MN0PR11MB6088.namprd11.prod.outlook.com
 ([fe80::8ac6:8219:4489:7891]) by MN0PR11MB6088.namprd11.prod.outlook.com
 ([fe80::8ac6:8219:4489:7891%4]) with mapi id 15.20.6064.031; Fri, 3 Feb 2023
 10:48:02 +0000
From:   <Rakesh.Sankaranarayanan@microchip.com>
To:     <andrew@lunn.ch>
CC:     <olteanv@gmail.com>, <davem@davemloft.net>,
        <linux@armlinux.org.uk>, <Woojung.Huh@microchip.com>,
        <linux-kernel@vger.kernel.org>, <pabeni@redhat.com>,
        <kuba@kernel.org>, <edumazet@google.com>, <netdev@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <f.fainelli@gmail.com>
Subject: Re: [RFC PATCH net-next 07/11] net: dsa: microchip: lan937x: update
 switch register
Thread-Topic: [RFC PATCH net-next 07/11] net: dsa: microchip: lan937x: update
 switch register
Thread-Index: AQHZNwYi/F78bUjhjUCh9IOmatoFU667y1YAgAFA54A=
Date:   Fri, 3 Feb 2023 10:48:02 +0000
Message-ID: <2d6f98b01fdce3247b8f93f0467e7f1cdb6e080e.camel@microchip.com>
References: <20230202125930.271740-1-rakesh.sankaranarayanan@microchip.com>
         <20230202125930.271740-8-rakesh.sankaranarayanan@microchip.com>
         <Y9vZdMQgqhaGIcdf@lunn.ch>
In-Reply-To: <Y9vZdMQgqhaGIcdf@lunn.ch>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB6088:EE_|PH7PR11MB7596:EE_
x-ms-office365-filtering-correlation-id: 968869f3-8786-4d45-bbfc-08db05d41fac
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hakZ+OWbGWEKB9cbCl7TgPRTNbaiiAXZ2mS3lPcss84NDwTQhNnMaVUeq9OE5A6idSthmMHdM6tniiN4CdYPRBT4uGO1fpXKAln2VqkTAEAzMPefMM42XiPUN2X8UaAc+rQ3ENtbXrV3Ekv8OytH4OZ8UPpD8ubChWvXGrQyo/cRGWiX1OhE5uvwJZbDS/yiFENxAwP4JMmh6i4ZaeOXV6nP5BBbvpxnJIuflPlVMAk09ZDhZPTe+Etv3oy0L4krSwjEdljUiTCzi1y06hptGxrXp8Jw+BQUAfKYVBZqVHqcruvVX/iGYAaaNYxkAqnnRLELok5kTbsvIZJcVzuww3H4BVn4qe+k+Vh03WUQUsNBGqKYedOmR8ctPXmzeS3gdg2Xlf2xcSM0VDOEmO4+x07h+9INZwm/l7wmog1k79iUBzvNH6i3CCPf+WANx1wI1AgFHzAJmQ3PdF4iKLaSVsKdjiUHxqjWQVWfOf71+m2L+RSgMpguKbSM/EfHOP+21GL9uXHvDYfvNbS9ef+lpQnAbG68KyeCLVEFGb35+ll7UBiVFINqSIROopdOq8O5lk2Ntzx158v3/Tei30MAEiLemLxSN0pxp2iuova36rVUiiq/k1RRDZTN3co9dO7xflUxdy+sbx9BbK7Xxp7yUAu3lin6FTD2hsr9vS6AyNSYtuAv9QMhUIRILZBcL2fP0NtzAOps8OiUNBLv4qjuTQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB6088.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(39860400002)(376002)(366004)(346002)(136003)(451199018)(38070700005)(2616005)(83380400001)(122000001)(38100700002)(76116006)(8676002)(66946007)(91956017)(6916009)(66476007)(8936002)(64756008)(66556008)(41300700001)(7416002)(5660300002)(15650500001)(86362001)(2906002)(66446008)(4326008)(71200400001)(478600001)(6486002)(6506007)(54906003)(316002)(186003)(26005)(36756003)(6512007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Um5PZk5zTDN2NENFWlNGZ2lUOVFQd2Eydjk3YzRqMGp0K01iVzNkSUFoYndq?=
 =?utf-8?B?bFlYaHowdTlCdnRrbU9JZExCeUpsRnhDL1B4NzBwdkRzQTdkU29ZcllReG1W?=
 =?utf-8?B?ME5zOWNkNGJRUzFJempJd2dpaEk4UWpVVTJMK0NyZENBZjFEQ3I3cEowTzJr?=
 =?utf-8?B?SHRzL3dsdXRaL3FtV2tSd3NRd0QxamQ0QktzeUpuNGNyeHV3UzV6NW05UFc3?=
 =?utf-8?B?VUhJWngrMVc0SFgyOGtSUXVrcWxhb3hubGxLaHpuRWpVU3BFTDFZS0JtQnFZ?=
 =?utf-8?B?NjBjM1dzTmJPbG1jTEtVeXpheGJTU2Y0bUY1RXk3bG1BYjZDNHFOMXROUkxu?=
 =?utf-8?B?RTRWdEZrc2NvM3M1MkJieHQ2QkZKN3RPVjJJa3JBakw0ZEtCTHlGUEpPK0ZO?=
 =?utf-8?B?c2ZxMm9zTFNOVEUyNWc2cmRtdDByaVJ0UFpFSC93ZG9yRTgyUTBFeklnUlV2?=
 =?utf-8?B?Z1FxNWNEUklySnpHRU93MGxmWWxQQjZFQjZxdjNNallCcElhS1o0YmlqRHpH?=
 =?utf-8?B?UDBpRTErMmJ3UXJ6ZlEvNlZBR3Fyb252V0tEU3N4azRSWWoyZmJReXRtd2pz?=
 =?utf-8?B?TWJTNmh2ekh6KzN0OFA1ZS9jUGtIT0xVNGpzWTlROWo2U3RPR3dzamw1M29p?=
 =?utf-8?B?SUc5K25aSzZQekw5dDltNGVsQjUyRXk3QnVML3Z1SXRob1hsRDE5aHh0b0pz?=
 =?utf-8?B?NE1QQWR1c0NwejBya0E1QThtVDZjMEY1NmNUWWJTZFYrc2xxVjQ1aU9SdTVI?=
 =?utf-8?B?OVlZdnZldmNkMjdBVlRrVWsyc2FDU3JxQjdwSHNDNmhYUFhRSzhKYktuR2Vk?=
 =?utf-8?B?ajlSVHEyNjZEVEZtMXorSFVObnU3eFZTaWxFZWhXTDg1c0xCMkJJNlJFOFU0?=
 =?utf-8?B?aFNGb3dUbDh6UWR3ZTRpbmljbmJpRmwxVHBBRjdNNEE0TlU2RkhBTVQzL3I1?=
 =?utf-8?B?bXI5STl4Q2hVTGJDMElJYjVUK3g1b0s2NFZUa0ZEVm14ZmowenFzemJNK2I5?=
 =?utf-8?B?QTh2MG85b2YraGorVmZqSkJTcjhMdkkzZXhGN1lRVHNIbmVLUWlBc0diUXYz?=
 =?utf-8?B?emZjc0QrNVkzOFFFV3lMZmJVMkYrYnphUTBnMElPNnVOVUxYZnc1WEMyRkdR?=
 =?utf-8?B?eEs5Z2J6R0xSQWZrb0xwZDV0QTJRMld1UWRDMFBUSkxIbmNrRzdCRVp1ZStx?=
 =?utf-8?B?QytzeUJvdjJhblBVSnZIUmo0QnE0eUhIUlRzTFNwc1k2VjBpZGpyZTN0VEVw?=
 =?utf-8?B?UmErRVQvYUUrazVBT2hqYzhJOHlOL3hWb2c0WlpGUENSYXFFWFpyNWdtUVpS?=
 =?utf-8?B?M28zQTBpWG5EbU1xT002N3FCNEF3NEo3cmJLRE80Q0hWc1JBSWJZSkVqa0pI?=
 =?utf-8?B?QkJNTmNGTjFFaEZhaEVTSU01WkovRUN3UDZSVytEYmE3bzRqbUxzZ0xlVjBs?=
 =?utf-8?B?dEppdGNQdkk5M0w4RFJkZlpuT3RxODQyM0VQb25nNUNZUlpIL0RFemE0OXZw?=
 =?utf-8?B?MTFFN2tWazJrYk90OCtOelhzZFYzUWFNclhyZ3JCZ3pOdHV6TWIyVzJxRytG?=
 =?utf-8?B?a29VTWVlVy9kRkp1UnJveGIxV21iOVp4ZHJkREJld2JBOGxxMDFtN3BndGNx?=
 =?utf-8?B?UnJJTHFhbWpIc1JrQnpITVc1ai9rSXpzRmtHdTB2dUNBWnEzVWRRemk1bmNw?=
 =?utf-8?B?R2Z2WHU0akFDTmUyRDNjZW5aajlDQzk5V09TWWlPTjIwZFJqQUFlNHdTbjZK?=
 =?utf-8?B?dTZ5d1R6NEZMQ1hKakZ5T3NXVmdqMWxuM3FhSlV1LzFPVlRsVVErUlRpWmly?=
 =?utf-8?B?ejJFaHVDZjA3T04yRFQzSWVNNFhKUCtkUUVjRUVvZmRMNkhGcDl4amNJTGJK?=
 =?utf-8?B?VGJ2NlB1MXdkYTA5ajlGYzBqVzRPL0IxdXY1WWlzQ0wyV3UvVEVMaGY0NWJM?=
 =?utf-8?B?R1J2VHR5MEQ0VHFpYzhsSE5vQnF1L3ZSWWR3WEVxMEx0MEphYkxPMC9iMTRk?=
 =?utf-8?B?N3VoSmw3bjJoeTM1L0k1M0J2NWkvNFZiSnFQWnpXWG50dmlxeHM1K2krRWE1?=
 =?utf-8?B?VlFRUWhRdW1kOWxOTWpLR29KYnR0LzhEOEFqS2ZKS3BmR1BPZHovUjFFQVZm?=
 =?utf-8?B?S0Nkd1N3c3U2UUJYN2trd2ZwQ3ZZMEJSNFhOdk9xRzFkRGo4clZ5RjI5L1dQ?=
 =?utf-8?Q?cL/uU/hIuIZ5G54975NIJSLIJZVpEObJR+IHd/dywPxJ?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D45479985936C347984BA9556CFDD020@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB6088.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 968869f3-8786-4d45-bbfc-08db05d41fac
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2023 10:48:02.5208
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oW+jNa4XQMJ0tmGiWWhvkBuVRPsg7JrYIT8gXpb+o1oi13YVErLU1lQwkwHcHiRGLnWseKQ7qiWg9EmitKxdA9DSSlOD7SM/KEGvs8RHNOLHJB/bKnnV/KzcXoCElbIL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7596
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQW5kcmV3LA0KDQpUaGFua3MgZm9yIHRoZSBjb21tZW50LCBJIHdpbGwgY2hhbmdlIGFuZCB0
ZXN0IHRoZSBjb2RlIGFzIHlvdQ0KZXhwbGFpbmVkIGFuZCB1cGRhdGUgdGhlIHBhdGNoIGluIG5l
eHQgcmV2aXNpb24uDQoNClRoYW5rcywNClJha2VzaCBTLg0KDQpPbiBUaHUsIDIwMjMtMDItMDIg
YXQgMTY6NDAgKzAxMDAsIEFuZHJldyBMdW5uIHdyb3RlOg0KPiBFWFRFUk5BTCBFTUFJTDogRG8g
bm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNzIHlvdQ0KPiBrbm93IHRo
ZSBjb250ZW50IGlzIHNhZmUNCj4gDQo+IE9uIFRodSwgRmViIDAyLCAyMDIzIGF0IDA2OjI5OjI2
UE0gKzA1MzAsIFJha2VzaCBTYW5rYXJhbmFyYXlhbmFuDQo+IHdyb3RlOg0KPiA+IFNlY29uZCBz
d2l0Y2ggaW4gY2FzY2FkZWQgY29ubmVjdGlvbiBkb2Vzbid0IGhhdmUgcG9ydCB3aXRoIG1hY2IN
Cj4gPiBpbnRlcmZhY2UuIGRzYV9zd2l0Y2hfcmVnaXN0ZXIgcmV0dXJucyBlcnJvciBpZiBtYWNi
IGludGVyZmFjZSBpcw0KPiA+IG5vdCB1cC4gRHVlIHRvIHRoaXMgcmVhc29uLCBzZWNvbmQgc3dp
dGNoIGluIGNhc2NhZGVkIGNvbm5lY3Rpb24NCj4gPiB3aWxsDQo+ID4gbm90IHJlcG9ydCBlcnJv
ciBkdXJpbmcgZHNhX3N3aXRjaF9yZWdpc3RlciBhbmQgbWliIHRocmVhZCB3b3JrDQo+ID4gd2ls
bCBiZQ0KPiA+IGludm9rZWQgZXZlbiBpZiBhY3R1YWwgc3dpdGNoIHJlZ2lzdGVyIGlzIG5vdCBk
b25lLiBUaGlzIHdpbGwgbGVhZA0KPiA+IHRvDQo+ID4ga2VybmVsIHdhcm5pbmcgYW5kIGl0IGNh
biBiZSBhdm9pZGVkIGJ5IGNoZWNraW5nIGRldmljZSB0cmVlIHNldHVwDQo+ID4gc3RhdHVzLiBU
aGlzIHdpbGwgcmV0dXJuIHRydWUgb25seSBhZnRlciBhY3R1YWwgc3dpdGNoIHJlZ2lzdGVyIGlz
DQo+ID4gZG9uZS4NCj4gDQo+IFdoYXQgaSB0aGluayB5b3UgbmVlZCB0byBkbyBpcyBtb3ZlIHRo
ZSBjb2RlIGludG8ga3N6X3NldHVwKCkuDQo+IA0KPiBXaXRoIGEgRCBpbiBEU0Egc2V0dXAsIGRz
YV9zd2l0Y2hfcmVnaXN0ZXIoKSBhZGRzIHRoZSBzd2l0Y2ggdG8gdGhlDQo+IGxpc3Qgb2Ygc3dp
dGNoZXMsIGFuZCB0aGVuIGEgY2hlY2sgaXMgcGVyZm9ybWVkIHRvIHNlZSBpZiBhbGwNCj4gc3dp
dGNoZXMNCj4gaW4gdGhlIGNsdXN0ZXIgaGF2ZSBiZWVuIHJlZ2lzdGVyZWQuIElmIG5vdCwgaXQg
anVzdCByZXR1cm5zLiBJZiBhbGwNCj4gc3dpdGNoZXMgaGF2ZSBiZWVuIHJlZ2lzdGVyZWQsIGl0
IHRoZW4gaXRlcmF0ZXMgb3ZlciBhbGwgdGhlIHN3aXRjaGVzDQo+IGNhbiBjYWxscyBkc2Ffc3dp
dGNoX29wcy5zZXR1cCgpLg0KPiANCj4gQnkgbW92aW5nIHRoZSBzdGFydCBvZiB0aGUgTUlCIGNv
dW50ZXIgaW50byBzZXR1cCgpLCBpdCB3aWxsIG9ubHkgYmUNCj4gc3RhcnRlZCBvbmNlIGFsbCB0
aGUgc3dpdGNoZXMgYXJlIHByZXNlbnQsIGFuZCBpdCBtZWFucyB5b3UgZG9uJ3QNCj4gbmVlZA0K
PiB0byBsb29rIGF0IERTQSBjb3JlIGludGVybmFsIHN0YXRlLg0KPiANCj4gwqDCoMKgwqDCoMKg
wqAgQW5kcmV3DQoNCg==
