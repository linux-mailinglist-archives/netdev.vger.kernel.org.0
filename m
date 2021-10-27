Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E680143C558
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 10:38:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239407AbhJ0IlU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 04:41:20 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:27958 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232025AbhJ0IlT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 04:41:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1635323934; x=1666859934;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=/7d2e0nAWUnF35RrUCzQRkF1q9VDMphUYRO4ZErePrU=;
  b=IwQ0jPsIPk1pSxHrGyJq4jG8puIrT12uQ5Y3Y5CkO8IZ6Xxa/Z125mpy
   9LGCq9RuT9YTWMBoe6Bb0VJ0NzEeATxMb6JryQ8oQH3pYGgxfMPt9Oqj9
   jyyMPuNNcMR0zKQS2ypJciQIdvJVxO8t+uu4dNQexvlTNKvRocz8pqrqs
   sVQN7ujfB7AyUs/TqEjV/aJ4oVcA1TWeg0JgE5fRNT6VIFhp5IWoX04H8
   fDWITOn5RVGfvMtxW1BdOi09R9tA3zjuHO4D/F62y2AW99ViSi6HBaK8m
   yrbH2beHLu36FuxhgIkNmi8oYa5/JB0Wv748M3OckHocFJ6O4V/iiD1ok
   Q==;
IronPort-SDR: d+vJY5KslRVNxJrhb+SSA09BcvgzSIrMK1CsGxLnLHMWDLVPNKsco3E++52/7ML/X7q/HFMfRF
 UnRiN6JtoD/YYKlfhRKeI0PnnI81FnW3XYarmvm6pmrP5mkl0yVS230zeP3+uiDmd2xtPfYiEr
 hoNtJf8ST7N1gu5q8WaJpiem+7i+JOptSqGAViUZhP7rjmakam8xtpuNwneFb3CRF+rxdvcR7G
 OWxGB7vxm3ncvk2ymkskCC0IaUwsvoo8YoZUKDApXZV9gMAH6jvlTqgOoMSONs1aBEO3CI2RAK
 Cel6R1IF2NS7Irvvv0SZ0bxJ
X-IronPort-AV: E=Sophos;i="5.87,186,1631602800"; 
   d="scan'208";a="149688544"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Oct 2021 01:38:53 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 27 Oct 2021 01:38:53 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14 via Frontend Transport; Wed, 27 Oct 2021 01:38:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JDEpNgb+k//DxD5eo52h+m8gvGfxyguXLJVRO8TtCU/5JfXPxzOZjPUz7g+xmpu20wLq0gtnVvao+JBQCuGrAShwUaIoxU7AM6spk5q0c7YBjvCk9KhIxVvh1xxBQwQCplo67955Zc4v9Hvy4Nm4fM0gHVz7Lq0QfL3CS1O50TBxscoWOS9+AFiMhVdZMUI5n97zivvt5ated9hcjQZZmMsoov7PQOhy4fvN/WNXAKnTi4uLWLfYLN5AGWt3+QJWvLbkji1E/bH6l4p5QCx21VQhFAoKBAST3BiQvGxgY3UxM728I+rmfuDmXR5bXT/+ZJj32dEkiDJjXnW5Kjb15Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/7d2e0nAWUnF35RrUCzQRkF1q9VDMphUYRO4ZErePrU=;
 b=JFRmIhp5hQ/61OoYk8WIt90myQDpWamVKYl3mRvjxIBOJOTnQHi2KVqyKpP9bcFjAhC/ux3v+/54PKJMzO1QLLxjFzN1ArD8WsDhaeiKslUXj/rJw30bWnWKHfZxVu6plUIe7sqv4e3tvtAgBQTJDvYKEL6m+/xAQ7N4h2MOg/vR5eqaYfubxm+Fzle5Oidf4/ZWkbAm758jWPWpip71zC44K0/OhOq4Gqj9vIAB8JCZ+5sJCSmtkjbFKrCQLWc1Zu/WTiJ6aMEi/0NT3a+UnUm82u7qpgaeFuGMwjE0IDPmxdejp6M9Y2bKjta9L5UqJNCqLeXTmBaqaYizptLDZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/7d2e0nAWUnF35RrUCzQRkF1q9VDMphUYRO4ZErePrU=;
 b=lpk/hTlPrw7gL9lUcGGPDb0JpYuJJWD7oeJWKcvhFojFxr/EXNVmG6FxzXj8pbqH69xA4r4OLSILxuzg91O6ccjeOUTmsIpHVrlMnSSkCxUf60xw6AypCCa13xvZY9xPTXTmjewbMlis4f+Yap4ONEActgi/wpQMk2It7CnvgKM=
Received: from CO1PR11MB4769.namprd11.prod.outlook.com (2603:10b6:303:91::21)
 by MWHPR11MB1981.namprd11.prod.outlook.com (2603:10b6:300:111::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Wed, 27 Oct
 2021 08:38:49 +0000
Received: from CO1PR11MB4769.namprd11.prod.outlook.com
 ([fe80::bd93:cf07:ea77:3b50]) by CO1PR11MB4769.namprd11.prod.outlook.com
 ([fe80::bd93:cf07:ea77:3b50%7]) with mapi id 15.20.4628.020; Wed, 27 Oct 2021
 08:38:49 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <linux@roeck-us.net>, <Nicolas.Ferre@microchip.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <sean.anderson@seco.com>,
        <andrew@lunn.ch>
Subject: Re: [PATCH] net: macb: Fix mdio child node detection
Thread-Topic: [PATCH] net: macb: Fix mdio child node detection
Thread-Index: AQHXyw4QkJbTV46gTkiuO/5IBQi/1A==
Date:   Wed, 27 Oct 2021 08:38:49 +0000
Message-ID: <c6a5361b-5199-766a-c85a-f802ca77670e@microchip.com>
References: <20211026173950.353636-1-linux@roeck-us.net>
In-Reply-To: <20211026173950.353636-1-linux@roeck-us.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
authentication-results: roeck-us.net; dkim=none (message not signed)
 header.d=none;roeck-us.net; dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2d839600-265e-4d36-34e3-08d9992532a4
x-ms-traffictypediagnostic: MWHPR11MB1981:
x-microsoft-antispam-prvs: <MWHPR11MB1981686BFDFBCE1AF4E8A2FB87859@MWHPR11MB1981.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3t1wMMdcV4bX2jkJIb4lyl2Iy84CWR81WClUpSI+k+HL7i54MRre0JK1/FjA168CYnsrsEPJlx0PD8ZQCgDjNWNuE4V7yMRg/3r+0gzwQ0swhmPec/GPkA1v57wdCXwU1kPS6lI/KOrLJdqzahOChMFIAfBdtYVmoTYqL3mF9qOUucDwFkEoQiZSUtogvkc0TBkQME2RYVN1PWQDcuBpt4H8FbB/dtr3A4JBFxVba5oGR468CTSKOv9TV/ZA8vEiI75stQKGEUOP1tY2P/4pWam13Rkw0qwDEuTU3S6LhpvGfBbZxJCYYpCb6eRgclwFCS2nNfrzse233tm41iUQPIUUKKMSVG56pClJDB/MRN8+OlY2ySkDJPEgI9YWrPPzqg2Sixh9elmjmk2zolWkXrR7Bl4u0e2QoLpB16YRc1OWHm3MB/nR8RfJNnYb/s8pcrZXZ9wxAITWVnwgpakh7GueeCN5casfHg/Csj+MFmligNPUvCE14ICVMZMut7Mb41S9lSfyMRFRaCAXzaGoDWDnX9ZJ5hmw2nvsvjqOWgDs/4v6swFMPjtS9pMiaC3ZC/T5NwjkYtE1YO4l2MoBXB81gTFAiQjLQQH4kVvngDbhEf3arYLSWz3RswEGKN9TSPRMfRtjFaHBuX4nc8p9kf4tuYsBbhhOH2GwxNE66/0zysMMzN+ipyLznFixf2xuBYvtAZfmt3pUjBVj28f8/f1jeABSqI07sQq6cnOdTA/V/VilYza0LhlDi8bHJoTz+gCSyVK+04nEPbDqD/lA8Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4769.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(36756003)(122000001)(6506007)(54906003)(8676002)(6486002)(316002)(508600001)(2906002)(83380400001)(186003)(38070700005)(76116006)(66946007)(4326008)(26005)(71200400001)(2616005)(64756008)(66446008)(91956017)(8936002)(110136005)(66556008)(6636002)(5660300002)(38100700002)(66476007)(31686004)(53546011)(31696002)(6512007)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N0I3TFBvUE94SjcyL214RHlTeGZVUUhhTmtNU09wazRNVGc1L0dTVzFDM2RN?=
 =?utf-8?B?ZE1tVE0yMVVzL1RGQVZWNmE0MzgxOWEwWTUyNjRTMlR5bFhoWTZmMGVkVWp3?=
 =?utf-8?B?SUtwTjBibVhsWGVIYXMzN0ZXRW5GaldIaDl4RTljc21BaEo2WWEyVDlxczhW?=
 =?utf-8?B?bno3ZFNjNGI3aHN4NkRXa0hQZFFvOGVOMjhHWXRaV29yQVZFNnVVdzJzQVQy?=
 =?utf-8?B?algzUElTek02bUVNYVFCTkMzbVA3OVRKU1k2eHhBR04rY05HS29MUjFuM1U4?=
 =?utf-8?B?blEwTUVxeE9qNDF2dWI0UThoaU5ybVMrSkFTSEg3ckxmSGx3UUdua2prSlFK?=
 =?utf-8?B?cHd5bkEyYVRRanljaVBoNGgrcGpTQmJSREoxU29HRk85RFMvdmRyVlVNM01I?=
 =?utf-8?B?VXNIYmVMVUFDWURFRVVYMm1ybVFNUWN6OUlTVjdETlNXVjR5cEloeHI1Q2hB?=
 =?utf-8?B?WnRTazhXeENBS3NGRzMrR1ZpNVZ4RWtyTDR6bzIwa2FHcTFqTElkZnZpM1hj?=
 =?utf-8?B?eFBHd1A4RDFYUUlCSitMZWxicFRwK3VlOVlsRHh5Yit0azFCVkdqTmpGZXZj?=
 =?utf-8?B?OHNwVFRKNkhDamJNaXFJZ05kdWw4Z1dHWE91QTREVXNwQzVad0p1ZVR6WE05?=
 =?utf-8?B?YTFVRVpITnNnREZsOE9icW11eUtvVEVTOFFDL3BieHgvMkFuZGplbGNjNWNu?=
 =?utf-8?B?anJwcFJlWXU5aW9EdDlnNElySVBpZWZsM2dIZHBBb1hzc0NIRDZBcE5acm9u?=
 =?utf-8?B?dFRDWGFONWNUOUJmdWlKeHg5VndNeExpNit4UEdJL25VRTFUWG4zUzZXQ3JE?=
 =?utf-8?B?UjRSOC9kaU1Sa1YwaUZXUUtPR2d0cndXZXVlQldDdjNiMnIxVzZmRzhLMlB1?=
 =?utf-8?B?VEJ5VFlKY2FXRHo5VFZCMk9DaDNjYWtqdTR0Z3VheEY1VXhMSXNSV1VDNEVm?=
 =?utf-8?B?RE15b01mK0lXZ0RoSHVqbFJrWU9aQVJ2M1B6UXVCcW9nL2t2aXBvMUNCbjAv?=
 =?utf-8?B?cW05djlKN2Q3dmgrUlJqUHZkeHNVRjVSeHlyLzVvWk14c09xeFp4bmlMU1V4?=
 =?utf-8?B?SHFLcmdzUVBmZVRRSkRpOUNqVDRTY3QzNUZpdFcwZ093bW1RMTFINm03Wk9j?=
 =?utf-8?B?Z0Z3eG54dWxHOThQVTNRRWZUcWxiNys4QkVVZWhaeVVjUm1JU0JBb3A3Y3hv?=
 =?utf-8?B?ajAyRlM2T05SeGZzY29vdWMyREQ0QXY0cEpQRCtjNzZ3Q3BDQWY2WkpMZkNy?=
 =?utf-8?B?aXVkTlhPZjU1YlcwaHNydzkwUmRwSTBlWStvbk15WFpWSE1lN3RPZlNWNmVE?=
 =?utf-8?B?VlhNTi8xeGp2QS9NOWZJd0JuK2hkY29FWStYelJ3b0NGZzh4czdIYUdXNGpK?=
 =?utf-8?B?bnVBQS9GaHN4dzRHaGhBM0l0dExTZjZOY1duZnI3R0pTajFnRWpGMFlUVnYz?=
 =?utf-8?B?N1VCQWs2UzR3U2g2cjBIb3d1NHZnVXdGaWNUbUFtREhSdEg5eHFGcGNGOE9P?=
 =?utf-8?B?OUNsNUVNWnZ0amVuamhzV0tUK0M1ckx5NnVkMVVkMThzZGp3aXVTMjhxZlF4?=
 =?utf-8?B?UXd6RGt3U2RQWC95Vi9XS1FMbVNUQUpwSjdlMjMxZnIxR085QVdiZVAvOFgy?=
 =?utf-8?B?ZzRwOEg4RHM5VDZiRnBhc2NleE5ra3FVeklpUVJIZThaOEdHWmpnTmEzTzFY?=
 =?utf-8?B?ODA4enY5S2RNV3N0WGhZZlhxa1V6R29jdnN0Mlp5YTQ5M3lWOTdLTEl5cVE4?=
 =?utf-8?B?dUN0Q2R5cnY4cElLV0ZlaFlGUksrN3dBdGVtTXcvcUt6RDR6cGs4QW51RitJ?=
 =?utf-8?B?UmpiSXFQeUp5WVh0a1BwdTlJRmlPNzV3T1dxMDBLWjlvM2hFZHVyY0JDWFBP?=
 =?utf-8?B?T0I5cjZmMmJOdEMvWDBvanBDdVdQNWtabHR0cXhEMy9WRzB1Q04xa1Yrem0z?=
 =?utf-8?B?OXRZbDQ4WVJCZUVvdnNMSWcvdDBlM25DN1FHZmdnSkpHd29oamJyY1Ywd1lw?=
 =?utf-8?B?bmpaWGQ3QWxnejdROUZvaTM0REZrMWVwYVJUSU1TenZ2UEhrdzRuenZuMXJv?=
 =?utf-8?B?aTNFN1pBYWd0bE5TS3VxRDNPOE1yV3dUMDRkQXV6SkRjeEdMSkxCaXpFOHRH?=
 =?utf-8?B?UzFHaHVhTnVwUW1xNGd2TE9haTBaZFpBREoySXVlZUZvNENxZmVnd282TkZS?=
 =?utf-8?B?N0FHRmh5MTFFMFBXVUFjWHRNaWFyQmVFcG4zYnR4Q3ZObzVKS1FObjdwUzhO?=
 =?utf-8?B?ZnlpRzR5TjI2NGFsNXhzdEszaGxBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C7B0AB34CCFF0A4ABA4D05F360B3C123@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4769.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d839600-265e-4d36-34e3-08d9992532a4
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2021 08:38:49.1122
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YqP9XdPR+a+pQjH2Bw8Y1qbSClwX3SaIaflwHJ6ZlSkIZoNuNtnJBuh9gDngJ6K6+KHe38V4t4wp6o1I1F/lINgBIQv3rOuqcDRSyAcLoYE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1981
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjYuMTAuMjAyMSAyMDozOSwgR3VlbnRlciBSb2VjayB3cm90ZToNCj4gRVhURVJOQUwgRU1B
SUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3Uga25v
dyB0aGUgY29udGVudCBpcyBzYWZlDQo+IA0KPiBDb21taXQgNGQ5OGJiMGQ3ZWMyICgibmV0OiBt
YWNiOiBVc2UgbWRpbyBjaGlsZCBub2RlIGZvciBNRElPIGJ1cyBpZiBpdA0KPiBleGlzdHMiKSBh
ZGRlZCBjb2RlIHRvIGRldGVjdCBpZiBhICdtZGlvJyBjaGlsZCBub2RlIGV4aXN0cyB0byB0aGUg
bWFjYg0KPiBkcml2ZXIuIFRocyBhZGRlZCBjb2RlIGRvZXMsIGhvd2V2ZXIsIG5vdCBhY3R1YWxs
eSBjaGVjayBpZiB0aGUgY2hpbGQgbm9kZQ0KPiBleGlzdHMsIGJ1dCBpZiB0aGUgcGFyZW50IG5v
ZGUgZXhpc3RzLiBUaGlzIHJlc3VsdHMgaW4gZXJyb3JzIHN1Y2ggYXMNCj4gDQo+IG1hY2IgMTAw
OTAwMDAuZXRoZXJuZXQgZXRoMDogQ291bGQgbm90IGF0dGFjaCBQSFkgKC0xOSkNCj4gDQo+IGlm
IHRoZXJlIGlzIG5vICdtZGlvJyBjaGlsZCBub2RlLiBGaXggdGhlIGNvZGUgdG8gYWN0dWFsbHkg
Y2hlY2sgZm9yDQo+IHRoZSBjaGlsZCBub2RlLg0KPiANCj4gRml4ZXM6IDRkOThiYjBkN2VjMiAo
Im5ldDogbWFjYjogVXNlIG1kaW8gY2hpbGQgbm9kZSBmb3IgTURJTyBidXMgaWYgaXQgZXhpc3Rz
IikNCj4gQ2M6IFNlYW4gQW5kZXJzb24gPHNlYW4uYW5kZXJzb25Ac2Vjby5jb20+DQo+IENjOiBB
bmRyZXcgTHVubiA8YW5kcmV3QGx1bm4uY2g+DQo+IFNpZ25lZC1vZmYtYnk6IEd1ZW50ZXIgUm9l
Y2sgPGxpbnV4QHJvZWNrLXVzLm5ldD4+IC0tLQ0KDQpQYXRjaCBzb2x2ZXMgdGhlIGZhaWx1cmUg
YWxzbyBvbiBzYW1hNWQyX3hwbGFpbmVkLiBZb3UgY2FuIGFkZDoNCg0KVGVzdGVkLWJ5OiBDbGF1
ZGl1IEJlem5lYSA8Y2xhdWRpdS5iZXpuZWFAbWljcm9jaGlwLmNvbT4NCg0KVGhhbmsgeW91LA0K
Q2xhdWRpdSBCZXpuZWENCg0KPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvY2FkZW5jZS9tYWNiX21h
aW4uYyB8IDIgKy0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlv
bigtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvbWFj
Yl9tYWluLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNlL21hY2JfbWFpbi5jDQo+IGlu
ZGV4IDMwOTM3MWFiZmUyMy4uZmZjZTUyOGFhMDBlIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25l
dC9ldGhlcm5ldC9jYWRlbmNlL21hY2JfbWFpbi5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L2NhZGVuY2UvbWFjYl9tYWluLmMNCj4gQEAgLTkwMSw3ICs5MDEsNyBAQCBzdGF0aWMgaW50
IG1hY2JfbWRpb2J1c19yZWdpc3RlcihzdHJ1Y3QgbWFjYiAqYnApDQo+ICAgICAgICAgICogZGly
ZWN0bHkgdW5kZXIgdGhlIE1BQyBub2RlDQo+ICAgICAgICAgICovDQo+ICAgICAgICAgY2hpbGQg
PSBvZl9nZXRfY2hpbGRfYnlfbmFtZShucCwgIm1kaW8iKTsNCj4gLSAgICAgICBpZiAobnApIHsN
Cj4gKyAgICAgICBpZiAoY2hpbGQpIHsNCj4gICAgICAgICAgICAgICAgIGludCByZXQgPSBvZl9t
ZGlvYnVzX3JlZ2lzdGVyKGJwLT5taWlfYnVzLCBjaGlsZCk7DQo+IA0KPiAgICAgICAgICAgICAg
ICAgb2Zfbm9kZV9wdXQoY2hpbGQpOw0KPiAtLQ0KPiAyLjMzLjANCj4gDQoNCg==
