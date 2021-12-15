Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2AA147530B
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 07:41:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235869AbhLOGl1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 01:41:27 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:65486 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233763AbhLOGl0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 01:41:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1639550487; x=1671086487;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=kuuTj+VukXBBJGex5LBU4ZYroGC+TcmfBl/rOVsMLrE=;
  b=1bbzvJnqwX84hbwrHP67RBdcXwkOgcd5QbIRxxi6W14t12Yvk/bU5CgM
   kfW6ihWx3qKOQATekccQQBDYw/i42Fu681l3171PZtW3TFqcG55gkTe3j
   uW3P8wzF5w8jI3XzM6p03HP0FZMy4qVbXg2tfI+bB3Y7E+UewPRTMs/QB
   8h/4ohG0wlt35F73eNJFbI7EXkA9YR4dNHVB/WrGf/Wb81YcZgwzpde2Z
   xRmjYl2tKVplimZsdV699skgzrMWEmKvqtTrxhhr4lRA14VJ7FYp9xs3l
   GHLqO42XWYoxNpLR11PVh+YFM3gJixUQWhoMWn0BKnNiuXUWxFa0jpglG
   A==;
IronPort-SDR: OlSCx5j+HU492xPFZ9rtGflnetsx7uL0TX6ZOA4f771w+uJaGA6xeMDxA0C75T02xmG//aJ69P
 6VM3NKDNx+a2nHN6Jyq/v9Tip57S7SRdzKE35YZYIr/0TGUrl005SghoMzAdHGpFJsWoSGVGm5
 qxnEEYzk1EHJJKMt5LotXSQT+4sa7bqkKulWddk//J+/DVaeljo0BuXPLFIed20Bw3ANfjZK6k
 kO/SQFi4PvS3oQpExLJdpHSHiJWYNmloy9kBdOSGySLTy68OFLyWEQx/8w8YwmQhn0Yypv2hUp
 EnFBApjQemJ2m8ox3UgCbaF+
X-IronPort-AV: E=Sophos;i="5.88,207,1635231600"; 
   d="scan'208";a="146712778"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Dec 2021 23:41:26 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 14 Dec 2021 23:41:25 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17 via Frontend Transport; Tue, 14 Dec 2021 23:41:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dgj+jbucLLXRRBI0ueLlbzUyhrjrfwEWgQY9yd45wX9/9ERNSe0OQRS40sgt5frRT4SnlzMi4ZX4dNwaDK3E4aCvaICTTwsUB3jBqtPJWn2kBcAw0lJMM2KZaA9ktk+PStCRlIYGvakYbs83cO0fLotqQlmU/mO/yWi9bYzihbj/sNOmM3u2iW58mcn4Z+NV3oYzs4he/F12DBOCy6aOmrsjtC+CAgxBHUPrBqb17G1VFywxO55nzxLN1lf1Puy2lg/aNLWgyNL31MKjUxgRVTuJn6QdIK65/EG2LuXPteIrHQTbXAggkl13WGNUnGZKZD39VZ/ouxlRN1L21cvD2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kuuTj+VukXBBJGex5LBU4ZYroGC+TcmfBl/rOVsMLrE=;
 b=EogK8N1fr/UtwayhPx1FOKbeegfyUlTXsgoVrPlyOZG1Nckg5jVbspuCouSzvn4sfG/t4ErRDKeImOGlCB9QVZiMymOQt82OkwECiXVQarXbm+Ki4kB0icsASPUQb+8VU9nkqlwEJ74JdDasyAYkswwdxMtzFXEjo3bxhCWBq5vLkpAFHMWhoA9y3LHk5u/WEukCLpOy05dBMsXGU5BtRlW21xyoSKM7WQXfEZuKCwabLYBCYtBNIJNXrJ58GR4MH40qQ68ZwfLBqvLybtGNPXKfn8ff4gioGI9A2dRoo2HMngBty07shktiXkqZC2Lv8NlXI14aQca5gkq+wpqz9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kuuTj+VukXBBJGex5LBU4ZYroGC+TcmfBl/rOVsMLrE=;
 b=QIQkts2Jc3iKlc8uaru8uMp+3lco+MnNkf+gOkYDcIvMV4q4OPYK/yxGJk9JPmJJijBU+9eMz6+DsJcIJnFV3PmNuCErz94HDyHsfPZHJdCGQkQ9bO1jVm8gXksN2/wImuVtEOc8/iQ6f8BxNg0CGc4iZbWDFh3IjX8WSbRoZJ8=
Received: from CO1PR11MB4769.namprd11.prod.outlook.com (2603:10b6:303:91::21)
 by MWHPR11MB1486.namprd11.prod.outlook.com (2603:10b6:301:e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Wed, 15 Dec
 2021 06:41:22 +0000
Received: from CO1PR11MB4769.namprd11.prod.outlook.com
 ([fe80::bd93:cf07:ea77:3b50]) by CO1PR11MB4769.namprd11.prod.outlook.com
 ([fe80::bd93:cf07:ea77:3b50%7]) with mapi id 15.20.4778.018; Wed, 15 Dec 2021
 06:41:22 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <davidm@egauge.net>, <Ajay.Kathat@microchip.com>
CC:     <adham.abozaeid@microchip.com>, <davem@davemloft.net>,
        <devicetree@vger.kernel.org>, <kuba@kernel.org>,
        <kvalo@codeaurora.org>, <linux-kernel@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <robh+dt@kernel.org>
Subject: Re: [PATCH v5 1/2] wilc1000: Add reset/enable GPIO support to SPI
 driver
Thread-Topic: [PATCH v5 1/2] wilc1000: Add reset/enable GPIO support to SPI
 driver
Thread-Index: AQHX8X7Fz1JXQBD6wEiVBWL5VPrTzg==
Date:   Wed, 15 Dec 2021 06:41:22 +0000
Message-ID: <d55a2558-b05d-5995-b0f0-f234cb3b50aa@microchip.com>
References: <20211215030501.3779911-1-davidm@egauge.net>
 <20211215030501.3779911-2-davidm@egauge.net>
In-Reply-To: <20211215030501.3779911-2-davidm@egauge.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6aef63f4-9817-4c49-c449-08d9bf95e8d3
x-ms-traffictypediagnostic: MWHPR11MB1486:EE_
x-microsoft-antispam-prvs: <MWHPR11MB14860EFF7449B20F76C01D3F87769@MWHPR11MB1486.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:298;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JeVk+I0aH0sXu7F2upnZ6NTOweEHx9yendIJoFJlU0zIn7j8U/CMGfCkwixGZkPQUQI1lhpNOAy4czFUakh8nubHvVITwrIkgUIqCa5ncChB5y9LVeaEWpwl1+WB4O8ZYg/kS9h+UPHIfac4u483nbhbEdjFhyPIyTmjHvIkDC7sXERX14A2nBEkhmsGM+vL1gRUT/AwLYxLga5CXKcnTyhvmv/oEaJuUpewNueKIQf9SkDzoqPw6gAMKReuyDzJPCeSD2ULUgTmg64gvGLan23x+Dl+mG0+7WYg3B/IM1jGV6zF6zHBF1cplCCz3+dxnBeGDrRwO8entYHAqg0ZYz0s8TnZ5HfxFXZV6rmL7Ucg6MwtlRi/xM+Nug4QeDOc/gGN1aTcrjRyjx68d3YxYRXpA7EZDCLSC7x0ITGr5nbzp/JLr1HAm1r0/NOey8g7Z6z/tlAxobB+3jaIq0QAS6GN8HlcYyXRGQhO1sFMs7Ft6MzuLfw/pf4PGtE2WCeFK/fkgbHQP9QE1kek8U0paL3vlIR2sgQ0UEjn66KDfqB4gLZXgfDOWcRYaw4TLrA0Z/JncYlgHxvKCGrmS5rJgbtcocHvWMzTmtaR0zkjQGkhLbCRlsIttgUbDgqsBImU/Q8B64oFkn1pEXjOj65Y/NpmhI4sM6l9S7Y/FdyT6fbQ/Y7la2wuf+E84I7KlXCXCtifFUWMjItvUnUNGluqt04VwJfvVB8q7883czcVVAA3Z5BF0wLITMf1x3P96C0svKdRbkn3JxZSygTd3YWOOg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4769.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6506007)(4326008)(71200400001)(6512007)(31696002)(8676002)(8936002)(186003)(110136005)(54906003)(2906002)(26005)(66476007)(6636002)(66446008)(83380400001)(508600001)(76116006)(86362001)(66556008)(91956017)(66946007)(64756008)(5660300002)(53546011)(122000001)(6486002)(36756003)(2616005)(38100700002)(316002)(31686004)(38070700005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bTdYTHNVSnNaMU9HekIydXdyWmdlY2RVWG5NS2MyRkd3YnhFMmtOcGgyTllk?=
 =?utf-8?B?MDM3d1liQzdKTTJRVFJRVTIzZG5za25FZzhSam5TZUJDNzlNYW9SRERiNWI4?=
 =?utf-8?B?ckcwdWI5TnpFTEJ3N0Q3cTF1MERwT0hmNjJLNEdUVkJYY0JOSStNellxVVlU?=
 =?utf-8?B?QzJPcldKVkw2RG5YVndNWEE4M0JaaHZWMTZDVklFN2dUTDhUbjFIR0tzREI1?=
 =?utf-8?B?eDlySStPWk9Pd2k3TkR2bmtheGlWVG5zOWNnMDJxZ1NkZXBZS2V1OW1YTXFT?=
 =?utf-8?B?UzdFZEhjdWthdGRTTTRRNWhCcGtVU1UxaE9OZnE2VVZxS0xBVkxDcUdOU3JZ?=
 =?utf-8?B?ZlBWSFlsZWs0UHN2d3VyRmZpeXZ1ajNZWVdqTEp5VFJKckxnQVYyTzJsMW1D?=
 =?utf-8?B?QXBPRWh4YVEzNzZzYWlFK2hUaWttckZZZEhGd2tFeVMwUTdNYmtFSGJsbVJQ?=
 =?utf-8?B?T0gxQmR3NXNsbmNYY0FBUHErN294b2FYRmhjVTBxNDduanl1T29RTVhWdU5Z?=
 =?utf-8?B?dnZnbU1iWFZ0T2pjeW5rWkw5M3N2M2FuaE8wL2MzZlV2NkI2elIyU2FHOEUx?=
 =?utf-8?B?Z2JOdDZscTBXUUQ1a0NhLzRBRm0xeU9vNlhVUjRxdWRGSTVRU0NjOEdxRkox?=
 =?utf-8?B?SnA4aFBaOUF0dUxFMlY0Z3hrZUhyUktlaUtOSWFWUDJqeDBmeVRWeXZVY0xw?=
 =?utf-8?B?UzYzRnlHMjZxdVByUmZqLzllUXc4S3E2NXhySStGWGFHM0hUenJUbGJDTXJu?=
 =?utf-8?B?QUdpNE5Sbll2ZnA4UXE4M1pOUFdjUUErRU83RVVBWWhsZFJNM01kdnErVGdF?=
 =?utf-8?B?aU5rS1dOYVU2bzNDcGpSMWJkNHJ0M0NORHVSaVlEUWJjR2o4cnpCNVpNeWF0?=
 =?utf-8?B?L0NpNC9DL0lQSlN4Z2xtRDRNOHlVdXMyYWV5MFR3US91YU1ZYUxZa3pUb3l3?=
 =?utf-8?B?eTdxamY5NWJCWjBudEJEQzloQTZnZnBaQnBHWDhXN2k1SDRGcDRtYjhRaW9n?=
 =?utf-8?B?NWRhZExKNFpVM09SUW1TQ3RzV0xQT3NRUCt3MStHS2pLeC95bkVESWhZSjVP?=
 =?utf-8?B?cG10bVY4ZDlKMFdINUhlWGJ0VjFwSyt6Sms2NzhnVElwMVcyRmxPU2liV2hF?=
 =?utf-8?B?aEVxdEY0blFmRGxaeVMzZkUxRERpZWEyc0pPa2pRdE01OXRJODV6MGJsKzF4?=
 =?utf-8?B?MnZmRks5WU5pRktzeUpyYk5jNU1TYldLeVowNU1zSnpyckJYbVp3NFpEVTFj?=
 =?utf-8?B?a200eUJzeTlXZXlqR2p0WmM1MmpKNVBvVVFiVGFPRjhOL3RYV3NjUDB4dXNF?=
 =?utf-8?B?SEppeEwxKzBzNHNOVENNaC9Oelh6RXlFUURCRFNLK2RRQXZrOXlWQlRaV0R4?=
 =?utf-8?B?eUZWSTg3bDhZcW5OUGJndGNrclpIaWlMSjlVREwxam9WWFNCS09HbnFPelRD?=
 =?utf-8?B?WGltQW9qbmxBKzlrcVUvS25vUkcxUnVwMUQweDJ2bjNTcjJxSExrOFpxSThx?=
 =?utf-8?B?WExmdkJkcDBMRVB6WHI4UEJxSEEwcjlpT09nTEVDYVZWaWdERnUraXMycUFY?=
 =?utf-8?B?VU43b29NdUNLVlBOZXovMFNuSnJ5eW1yWUEzN0J4Tko0cHRrR1RGN0U0Mkgw?=
 =?utf-8?B?TTFmVi9DTkdOMlUxY2xlbVJMZVg3UEp4ZzRhQ3p4YzFheTJoVE5oN09DNTNI?=
 =?utf-8?B?aUJGcWUzUHRFaGtiQ3dZbGUvWjA2ZG50U3JWTjBsQjc5SnRPdVRWN1lXaUJz?=
 =?utf-8?B?eEFKc21taVZ5K3ErZGI5R0VqRStHOHZ2WDV2cnExRU8vSENKQjl5L0xDb25F?=
 =?utf-8?B?YjVEN2tGRzg3NklUQlh6Y0FOb095d2dKbUwrb0k5Y2FOR3RHc1U1YjY0eVFK?=
 =?utf-8?B?Mjk3cWEvRzhrdkEzYUhyL0VtWXJCRERJdXFBOG9kSE9zV01haHkrdzlWRDFT?=
 =?utf-8?B?MHBxVVpsVzNoZFZQU013UUFGdXlUVUFyTmtJYldJNGRseEhrMEZ3dVhmamV5?=
 =?utf-8?B?dGlldm5xdWU1NVQrNXhlb2Qra0tMRlZUb2Z0Y3BPWk9vK1U3V1NGK3A3WTVi?=
 =?utf-8?B?aGtHNTQvbmtrRDc4WFFxZTFJNWlRakRPN2JIdzdTbkVhZXQvcTdFU0dNMWpi?=
 =?utf-8?B?RGNuMnlDN25VRVhxajFnYit5RHd2UVdzTitRbHZtdkc5K1lYYm9ROWF0SWcw?=
 =?utf-8?B?VW13dE9MbTMzNi9vYTV0azc2UUpUWDN5UWRMaGozVmRzNzVjaTAzUWRJUVQv?=
 =?utf-8?B?RVE0TzVQaHk0RENCcjJTR2gzSXNnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AF70B567262CEE4C9CE096ECBA9D66E7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4769.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6aef63f4-9817-4c49-c449-08d9bf95e8d3
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2021 06:41:22.5626
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zk+ebFJCWk91gOFPovr2TUHHYZIiaPjrPEPUyfTG37t0fhOEkiPWVF5Yn6XG7AP0TexwY1YtwoQlJMqJYMSgTdMldpUsTTbZVFY6MBFVdmM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1486
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTUuMTIuMjAyMSAwNTowNSwgRGF2aWQgTW9zYmVyZ2VyLVRhbmcgd3JvdGU6DQo+IEVYVEVS
TkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3Mg
eW91IGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4gRm9yIHRoZSBTRElPIGRyaXZlciwg
dGhlIFJFU0VUL0VOQUJMRSBwaW5zIG9mIFdJTEMxMDAwIGFyZSBjb250cm9sbGVkDQo+IHRocm91
Z2ggdGhlIFNESU8gcG93ZXIgc2VxdWVuY2UgZHJpdmVyLiAgVGhpcyBjb21taXQgYWRkcyBhbmFs
b2dvdXMNCj4gc3VwcG9ydCBmb3IgdGhlIFNQSSBkcml2ZXIuICBTcGVjaWZpY2FsbHksIGR1cmlu
ZyBpbml0aWFsaXphdGlvbiwgdGhlDQo+IGNoaXAgd2lsbCBiZSBFTkFCTEVkIGFuZCB0YWtlbiBv
dXQgb2YgUkVTRVQgYW5kIGR1cmluZw0KPiBkZWluaXRpYWxpemF0aW9uLCB0aGUgY2hpcCB3aWxs
IGJlIHBsYWNlZCBiYWNrIGludG8gUkVTRVQgYW5kIGRpc2FibGVkDQo+IChib3RoIHRvIHJlZHVj
ZSBwb3dlciBjb25zdW1wdGlvbiBhbmQgdG8gZW5zdXJlIHRoZSBXaUZpIHJhZGlvIGlzDQo+IG9m
ZikuDQo+IA0KPiBCb3RoIFJFU0VUIGFuZCBFTkFCTEUgR1BJT3MgYXJlIG9wdGlvbmFsLiAgSG93
ZXZlciwgaWYgdGhlIEVOQUJMRSBHUElPDQo+IGlzIHNwZWNpZmllZCwgdGhlbiB0aGUgUkVTRVQg
R1BJTyBzaG91bGQgbm9ybWFsbHkgYWxzbyBiZSBzcGVjaWZpZWQgYXMNCj4gb3RoZXJ3aXNlIHRo
ZXJlIGlzIG5vIHdheSB0byBlbnN1cmUgcHJvcGVyIHRpbWluZyBvZiB0aGUgRU5BQkxFL1JFU0VU
DQo+IHNlcXVlbmNlLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogRGF2aWQgTW9zYmVyZ2VyLVRhbmcg
PGRhdmlkbUBlZ2F1Z2UubmV0Pg0KPiAtLS0NCj4gIGRyaXZlcnMvbmV0L3dpcmVsZXNzL21pY3Jv
Y2hpcC93aWxjMTAwMC9zcGkuYyB8IDU4ICsrKysrKysrKysrKysrKysrKy0NCj4gIC4uLi9uZXQv
d2lyZWxlc3MvbWljcm9jaGlwL3dpbGMxMDAwL3dsYW4uYyAgICB8ICAyICstDQo+ICAyIGZpbGVz
IGNoYW5nZWQsIDU2IGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0t
Z2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvbWljcm9jaGlwL3dpbGMxMDAwL3NwaS5jIGIvZHJp
dmVycy9uZXQvd2lyZWxlc3MvbWljcm9jaGlwL3dpbGMxMDAwL3NwaS5jDQo+IGluZGV4IDZlN2Zk
MThjMTRlNy4uMGI0NDI1ZTU2YmZhIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC93aXJlbGVz
cy9taWNyb2NoaXAvd2lsYzEwMDAvc3BpLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3Mv
bWljcm9jaGlwL3dpbGMxMDAwL3NwaS5jDQo+IEBAIC04LDYgKzgsNyBAQA0KPiAgI2luY2x1ZGUg
PGxpbnV4L3NwaS9zcGkuaD4NCj4gICNpbmNsdWRlIDxsaW51eC9jcmM3Lmg+DQo+ICAjaW5jbHVk
ZSA8bGludXgvY3JjLWl0dS10Lmg+DQo+ICsjaW5jbHVkZSA8bGludXgvZ3Bpby9jb25zdW1lci5o
Pg0KPiANCj4gICNpbmNsdWRlICJuZXRkZXYuaCINCj4gICNpbmNsdWRlICJjZmc4MDIxMS5oIg0K
PiBAQCAtNDMsNiArNDQsMTAgQEAgc3RydWN0IHdpbGNfc3BpIHsNCj4gICAgICAgICBib29sIHBy
b2JpbmdfY3JjOyAgICAgICAvKiB0cnVlIGlmIHdlJ3JlIHByb2JpbmcgY2hpcCdzIENSQyBjb25m
aWcgKi8NCj4gICAgICAgICBib29sIGNyYzdfZW5hYmxlZDsgICAgICAvKiB0cnVlIGlmIGNyYzcg
aXMgY3VycmVudGx5IGVuYWJsZWQgKi8NCj4gICAgICAgICBib29sIGNyYzE2X2VuYWJsZWQ7ICAg
ICAvKiB0cnVlIGlmIGNyYzE2IGlzIGN1cnJlbnRseSBlbmFibGVkICovDQo+ICsgICAgICAgc3Ry
dWN0IHdpbGNfZ3Bpb3Mgew0KPiArICAgICAgICAgICAgICAgc3RydWN0IGdwaW9fZGVzYyAqZW5h
YmxlOyAgICAgICAvKiBFTkFCTEUgR1BJTyBvciBOVUxMICovDQo+ICsgICAgICAgICAgICAgICBz
dHJ1Y3QgZ3Bpb19kZXNjICpyZXNldDsgICAgICAgIC8qIFJFU0VUIEdQSU8gb3IgTlVMTCAqLw0K
PiArICAgICAgIH0gZ3Bpb3M7DQo+ICB9Ow0KPiANCj4gIHN0YXRpYyBjb25zdCBzdHJ1Y3Qgd2ls
Y19oaWZfZnVuYyB3aWxjX2hpZl9zcGk7DQo+IEBAIC0xNTIsNiArMTU3LDQ2IEBAIHN0cnVjdCB3
aWxjX3NwaV9zcGVjaWFsX2NtZF9yc3Agew0KPiAgICAgICAgIHU4IHN0YXR1czsNCj4gIH0gX19w
YWNrZWQ7DQo+IA0KPiArc3RhdGljIGludCB3aWxjX3BhcnNlX2dwaW9zKHN0cnVjdCB3aWxjICp3
aWxjKQ0KPiArew0KPiArICAgICAgIHN0cnVjdCBzcGlfZGV2aWNlICpzcGkgPSB0b19zcGlfZGV2
aWNlKHdpbGMtPmRldik7DQo+ICsgICAgICAgc3RydWN0IHdpbGNfc3BpICpzcGlfcHJpdiA9IHdp
bGMtPmJ1c19kYXRhOw0KPiArICAgICAgIHN0cnVjdCB3aWxjX2dwaW9zICpncGlvcyA9ICZzcGlf
cHJpdi0+Z3Bpb3M7DQo+ICsNCj4gKyAgICAgICAvKiBnZXQgRU5BQkxFIHBpbiBhbmQgZGVhc3Nl
cnQgaXQgKGlmIGl0IGlzIGRlZmluZWQpOiAqLw0KPiArICAgICAgIGdwaW9zLT5lbmFibGUgPSBk
ZXZtX2dwaW9kX2dldF9vcHRpb25hbCgmc3BpLT5kZXYsDQo+ICsgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICJlbmFibGUiLCBHUElPRF9PVVRfTE9XKTsNCj4g
KyAgICAgICAvKiBnZXQgUkVTRVQgcGluIGFuZCBhc3NlcnQgaXQgKGlmIGl0IGlzIGRlZmluZWQp
OiAqLw0KPiArICAgICAgIGlmIChncGlvcy0+ZW5hYmxlKSB7DQo+ICsgICAgICAgICAgICAgICAv
KiBpZiBlbmFibGUgcGluIGV4aXN0cywgcmVzZXQgbXVzdCBleGlzdCBhcyB3ZWxsICovDQo+ICsg
ICAgICAgICAgICAgICBncGlvcy0+cmVzZXQgPSBkZXZtX2dwaW9kX2dldCgmc3BpLT5kZXYsDQo+
ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAicmVzZXQiLCBH
UElPRF9PVVRfSElHSCk7DQoNCkFzIGZhciBhcyBJIGNhbiB0ZWxsIGZvcm0gZ3Bpb2xpYiBjb2Rl
IHRoZSBkaWZmZXJlbmNlIGIvdyBHUElPRF9PVVRfSElHSA0KYW5kIEdQSU9EX09VVF9MT1cgaW4g
Z3Bpb2xpYiBpcyByZWxhdGVkIHRvIHRoZSBpbml0aWFsIHZhbHVlIGZvciB0aGUgR1BJTy4NCkRp
ZCB5b3UgdXNlZCBHUElPRF9PVVRfSElHSCBmb3IgcmVzZXQgdG8gaGF2ZSB0aGUgY2hpcCBvdXQg
b2YgcmVzZXQgYXQgdGhpcw0KcG9pbnQ/DQoNCj4gKyAgICAgICAgICAgICAgIGlmIChJU19FUlIo
Z3Bpb3MtPnJlc2V0KSkgew0KPiArICAgICAgICAgICAgICAgICAgICAgICBkZXZfZXJyKCZzcGkt
PmRldiwgIm1pc3NpbmcgcmVzZXQgZ3Bpby5cbiIpOw0KPiArICAgICAgICAgICAgICAgICAgICAg
ICByZXR1cm4gUFRSX0VSUihncGlvcy0+cmVzZXQpOw0KPiArICAgICAgICAgICAgICAgfQ0KPiAr
ICAgICAgIH0gZWxzZSB7DQo+ICsgICAgICAgICAgICAgICBncGlvcy0+cmVzZXQgPSBkZXZtX2dw
aW9kX2dldF9vcHRpb25hbCgmc3BpLT5kZXYsDQo+ICsgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAicmVzZXQiLCBHUElPRF9PVVRfSElHSCk7DQo+
ICsgICAgICAgfQ0KPiArICAgICAgIHJldHVybiAwOw0KPiArfQ0KPiArDQo+ICtzdGF0aWMgdm9p
ZCB3aWxjX3dsYW5fcG93ZXIoc3RydWN0IHdpbGMgKndpbGMsIGJvb2wgb24pDQo+ICt7DQo+ICsg
ICAgICAgc3RydWN0IHdpbGNfc3BpICpzcGlfcHJpdiA9IHdpbGMtPmJ1c19kYXRhOw0KPiArICAg
ICAgIHN0cnVjdCB3aWxjX2dwaW9zICpncGlvcyA9ICZzcGlfcHJpdi0+Z3Bpb3M7DQo+ICsNCj4g
KyAgICAgICBpZiAob24pIHsNCj4gKyAgICAgICAgICAgICAgIGdwaW9kX3NldF92YWx1ZShncGlv
cy0+ZW5hYmxlLCAxKTsgICAgICAvKiBhc3NlcnQgRU5BQkxFICovDQo+ICsgICAgICAgICAgICAg
ICBtZGVsYXkoNSk7DQo+ICsgICAgICAgICAgICAgICBncGlvZF9zZXRfdmFsdWUoZ3Bpb3MtPnJl
c2V0LCAwKTsgICAgICAgLyogZGVhc3NlcnQgUkVTRVQgKi8NCg0KRnJvbSB3aGF0IEkgY2FuIHRl
bGwgZnJvbSBncGlvbGliIGNvZGUsIHJlcXVlc3RpbmcgdGhlIHBpbiBmcm9tIGRldmljZSB0cmVl
DQp3aXRoOg0KDQorICAgICAgICByZXNldC1ncGlvcyA9IDwmcGlvQSA2IEdQSU9fQUNUSVZFX0xP
Vz47DQoNCm1ha2VzIHRoZSB2YWx1ZSB3cml0dGVuIHdpdGggZ3Bpb2Rfc2V0X3ZhbHVlKCkgdG8g
YmUgbmVnYXRlZCwgdGh1cyB0aGUgMA0Kd3JpdHRlbiBoZXJlIGlzIHRyYW5zbGF0ZWQgdG8gYSAx
IG9uIHRoZSBwaW4uIElzIHRoZXJlIGEgcmVhc29uIHlvdSBkaWQgaXQNCmxpa2UgdGhpcz8gV291
bGQgaXQgaGF2ZSBiZWVuIHNpbXBsZXIgdG8gaGF2ZSBib3RoIHBpbnMgcmVxdWVzdGVkIHdpdGgN
CkdQSU9fQUNUSVZFX0hJR0ggYW5kIGhlcmUgdG8gZG8gZ3Bpb2Rfc2V0X3ZhbHVlKGdwaW8sIDEp
IGZvciBib3RoIG9mIHRoZQ0KcGluLiBJbiB0aGlzIHdheSwgYXQgdGhlIGZpcnN0IHJlYWQgb2Yg
dGhlIGNvZGUgb25lIG9uZSB3b3VsZCBoYXZlIGJlZW4NCnRlbGxpbmcgdGhhdCBpdCBkb2VzIHdo
YXQgZGF0YXNoZWV0IHNwZWNpZmllczogZm9yIHBvd2VyIG9uIHRvZ2dsZSBlbmFibGUNCmFuZCBy
ZXNldCBncGlvcyBmcm9tIDAgdG8gMSB3aXRoIGEgZGVsYXkgaW4gYmV0d2Vlbi4NCg0KDQoNCj4g
KyAgICAgICB9IGVsc2Ugew0KPiArICAgICAgICAgICAgICAgZ3Bpb2Rfc2V0X3ZhbHVlKGdwaW9z
LT5yZXNldCwgMSk7ICAgICAgIC8qIGFzc2VydCBSRVNFVCAqLw0KPiArICAgICAgICAgICAgICAg
Z3Bpb2Rfc2V0X3ZhbHVlKGdwaW9zLT5lbmFibGUsIDApOyAgICAgIC8qIGRlYXNzZXJ0IEVOQUJM
RSAqLw0KDQpJIGRvbid0IHVzdWFsbHkgc2VlIGNvbW1lbnRzIG5lYXIgdGhlIGNvZGUgbGluZSBp
biBrZXJuZWwuIE1heWJlIG1vdmUgdGhlbQ0KYmVmb3JlIHRoZSBhY3R1YWwgY29kZSBsaW5lIG9y
IHJlbW92ZSB0aGVtIGF0IGFsbCBhcyB0aGUgY29kZSBpcyBpbXBsZXIgZW5vdWdoPw0KDQo+ICsg
ICAgICAgfQ0KPiArfQ0KPiArDQo+ICBzdGF0aWMgaW50IHdpbGNfYnVzX3Byb2JlKHN0cnVjdCBz
cGlfZGV2aWNlICpzcGkpDQo+ICB7DQo+ICAgICAgICAgaW50IHJldDsNCj4gQEAgLTE3MSw2ICsy
MTYsMTAgQEAgc3RhdGljIGludCB3aWxjX2J1c19wcm9iZShzdHJ1Y3Qgc3BpX2RldmljZSAqc3Bp
KQ0KPiAgICAgICAgIHdpbGMtPmJ1c19kYXRhID0gc3BpX3ByaXY7DQo+ICAgICAgICAgd2lsYy0+
ZGV2X2lycV9udW0gPSBzcGktPmlycTsNCj4gDQo+ICsgICAgICAgcmV0ID0gd2lsY19wYXJzZV9n
cGlvcyh3aWxjKTsNCj4gKyAgICAgICBpZiAocmV0IDwgMCkNCj4gKyAgICAgICAgICAgICAgIGdv
dG8gbmV0ZGV2X2NsZWFudXA7DQo+ICsNCj4gICAgICAgICB3aWxjLT5ydGNfY2xrID0gZGV2bV9j
bGtfZ2V0X29wdGlvbmFsKCZzcGktPmRldiwgInJ0YyIpOw0KPiAgICAgICAgIGlmIChJU19FUlIo
d2lsYy0+cnRjX2NsaykpIHsNCj4gICAgICAgICAgICAgICAgIHJldCA9IFBUUl9FUlIod2lsYy0+
cnRjX2Nsayk7DQo+IEBAIC05ODQsOSArMTAzMywxMCBAQCBzdGF0aWMgaW50IHdpbGNfc3BpX3Jl
c2V0KHN0cnVjdCB3aWxjICp3aWxjKQ0KPiANCj4gIHN0YXRpYyBpbnQgd2lsY19zcGlfZGVpbml0
KHN0cnVjdCB3aWxjICp3aWxjKQ0KPiAgew0KPiAtICAgICAgIC8qDQo+IC0gICAgICAgICogVE9E
TzoNCj4gLSAgICAgICAgKi8NCj4gKyAgICAgICBzdHJ1Y3Qgd2lsY19zcGkgKnNwaV9wcml2ID0g
d2lsYy0+YnVzX2RhdGE7DQo+ICsNCj4gKyAgICAgICBzcGlfcHJpdi0+aXNpbml0ID0gZmFsc2U7
DQo+ICsgICAgICAgd2lsY193bGFuX3Bvd2VyKHdpbGMsIGZhbHNlKTsNCj4gICAgICAgICByZXR1
cm4gMDsNCj4gIH0NCj4gDQo+IEBAIC0xMDA3LDYgKzEwNTcsOCBAQCBzdGF0aWMgaW50IHdpbGNf
c3BpX2luaXQoc3RydWN0IHdpbGMgKndpbGMsIGJvb2wgcmVzdW1lKQ0KPiAgICAgICAgICAgICAg
ICAgZGV2X2Vycigmc3BpLT5kZXYsICJGYWlsIGNtZCByZWFkIGNoaXAgaWQuLi5cbiIpOw0KPiAg
ICAgICAgIH0NCj4gDQo+ICsgICAgICAgd2lsY193bGFuX3Bvd2VyKHdpbGMsIHRydWUpOw0KPiAr
DQo+ICAgICAgICAgLyoNCj4gICAgICAgICAgKiBjb25maWd1cmUgcHJvdG9jb2wNCj4gICAgICAg
ICAgKi8NCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL21pY3JvY2hpcC93aWxj
MTAwMC93bGFuLmMgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9taWNyb2NoaXAvd2lsYzEwMDAvd2xh
bi5jDQo+IGluZGV4IDgyNTY2NTQ0NDE5YS4uZjFlNGFjM2EyYWQ1IDEwMDY0NA0KPiAtLS0gYS9k
cml2ZXJzL25ldC93aXJlbGVzcy9taWNyb2NoaXAvd2lsYzEwMDAvd2xhbi5jDQo+ICsrKyBiL2Ry
aXZlcnMvbmV0L3dpcmVsZXNzL21pY3JvY2hpcC93aWxjMTAwMC93bGFuLmMNCj4gQEAgLTEyNTMs
NyArMTI1Myw3IEBAIHZvaWQgd2lsY193bGFuX2NsZWFudXAoc3RydWN0IG5ldF9kZXZpY2UgKmRl
dikNCj4gICAgICAgICB3aWxjLT5yeF9idWZmZXIgPSBOVUxMOw0KPiAgICAgICAgIGtmcmVlKHdp
bGMtPnR4X2J1ZmZlcik7DQo+ICAgICAgICAgd2lsYy0+dHhfYnVmZmVyID0gTlVMTDsNCj4gLSAg
ICAgICB3aWxjLT5oaWZfZnVuYy0+aGlmX2RlaW5pdChOVUxMKTsNCj4gKyAgICAgICB3aWxjLT5o
aWZfZnVuYy0+aGlmX2RlaW5pdCh3aWxjKTsNCj4gIH0NCj4gDQo+ICBzdGF0aWMgaW50IHdpbGNf
d2xhbl9jZmdfY29tbWl0KHN0cnVjdCB3aWxjX3ZpZiAqdmlmLCBpbnQgdHlwZSwNCj4gLS0NCj4g
Mi4yNS4xDQo+IA0KDQo=
