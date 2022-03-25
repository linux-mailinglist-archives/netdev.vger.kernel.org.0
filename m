Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B02604E6FB2
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 09:57:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352959AbiCYI6y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 04:58:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbiCYI6x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 04:58:53 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B36F0CD321
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 01:57:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1648198638; x=1679734638;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=C/ed8lct5sPkLNaoH98wiq7R0hnvoIIWNpxLs56j0P0=;
  b=1SuP50K6ziHZ9Sq5fEiGUmFWJqr8BjvRff08csBLnExNaDOjD7KoA+gy
   DUgpkksapV32FIxfALbd4LvmtOJ2Q4LM7Q2OhXRiN4np/1VFg/+8Riv0O
   6ooPVAoRdaPBNOFrBuO9sYF6lFwh+eWK5hHgC57KgFX/MWbl9xwz07WfK
   2RH/2+vxT8dVWtc7aVXVoU5p/iMWyUG3y+scbWQVVLVB/m+pIndak/rPo
   Xe67kLCJ5HdgSIkjmIATkH76mA3nVhMZBCykjK9DWD08xgkfv/YcajO+u
   LhZ7AWgC91UebgG8JnW4Py2/jUIMa4V2brgmPtX4uRj0QlvmjwUuHl4ou
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,209,1643698800"; 
   d="scan'208";a="90131921"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Mar 2022 01:57:17 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 25 Mar 2022 01:57:17 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17 via Frontend Transport; Fri, 25 Mar 2022 01:57:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OQM6iIbiwk4UMpVp3Hm8UUNWGqdsZ/dL/ZtefhqzST4mU8qoUW5n5KgA9ie2Q1qz+/j+3VsaHjXr9GJr7nGOPjoPnBocJpeGrZca6Uv5zpUq8Lfq6yr62lvl7e9Ccs5mQYe0GZ6rIWFReIzeTSLsBP4f2ZSvmo+A4tONsFonBruva0qAWcy//E9JJxksFMff/oCJTur8fhcmShenkLuz7DJUG9OYJiMBfPbCxwx75SwaLdt7koYZhqPNdGs9q7SsI2qMahkURqEa93wUnPqG0wMylo7fVcgF2LT4j4QeilorcwrVozlTcQQ8TSNWcG9LalolrUBPZmFPwJ1+2ozlcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C/ed8lct5sPkLNaoH98wiq7R0hnvoIIWNpxLs56j0P0=;
 b=eZ6gIzas9jRfMimqG0RkusAm0r/pNEo5Jxm2AvGX5p6slQSrWz2a6ziWm8y/sgkh+G6QuX/5qn0XXVQL/8tYXESTwViEEBkovXT9MvSVrJ4ALAfOXISGzujxWDjk4LJXVbjDzudIgVtM0gatEeJTHYxxRFCS6Tr/Ojy/cAW7mC9yIInTi8jlpJoGwRP6EFeuJttgM3R7w49g0ORhR/e940Zo6uZXAkTo9bAapBmoWzgYKLILw62EFlOaamvqaoYwRcGvxiayYO1cVRRe3OHxjQL6HoB3YDPxWeY9TEhy1BjSp3dAcjkSRNyNMbctEELucgw1XRDdgSpYoXRlOeaeAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C/ed8lct5sPkLNaoH98wiq7R0hnvoIIWNpxLs56j0P0=;
 b=fj1Z7bZOcyuatxamnDsrt6KbVQuvbjMdek7a5nXXZz/VhX5vjwRxAg9Q49EF6o4+aBd8Wf0aVbCDBA9bxbLxNrB1gLKhtK2CZ317/SfeDMZZEzRfA4xyTjgZr8p1EVY86uQy1rs36DexMiGxePqkSDLDMWAABlMGXH2Q7hC2N4M=
Received: from CO1PR11MB4769.namprd11.prod.outlook.com (2603:10b6:303:91::21)
 by DM6PR11MB2588.namprd11.prod.outlook.com (2603:10b6:5:c6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.19; Fri, 25 Mar
 2022 08:57:13 +0000
Received: from CO1PR11MB4769.namprd11.prod.outlook.com
 ([fe80::6d66:3f1d:7b05:660b]) by CO1PR11MB4769.namprd11.prod.outlook.com
 ([fe80::6d66:3f1d:7b05:660b%6]) with mapi id 15.20.5102.019; Fri, 25 Mar 2022
 08:57:12 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <tomas.melin@vaisala.com>, <netdev@vger.kernel.org>
CC:     <Nicolas.Ferre@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <pabeni@redhat.com>
Subject: Re: [PATCH] net: macb: Restart tx only if queue pointer is lagging
Thread-Topic: [PATCH] net: macb: Restart tx only if queue pointer is lagging
Thread-Index: AQHYQCZQfBYaRO5M1UGfluJdpjZcjQ==
Date:   Fri, 25 Mar 2022 08:57:12 +0000
Message-ID: <64feeb9e-0e28-0441-4d42-20e3f5ec7a7a@microchip.com>
References: <20220325065012.279642-1-tomas.melin@vaisala.com>
In-Reply-To: <20220325065012.279642-1-tomas.melin@vaisala.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 050db0d4-1947-4155-ebe0-08da0e3d73bc
x-ms-traffictypediagnostic: DM6PR11MB2588:EE_
x-microsoft-antispam-prvs: <DM6PR11MB25889B19FF0C5FADB9E4AAE2871A9@DM6PR11MB2588.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aiYQe4wBhBF67lsuDlfuGjoCMXHIy6hxr96sONsEUQ/XU36NlCWBpdLT8xZnxYvf2q2So1Dlf4t9rxssdywL8LBVEni7/pHNJoSqvD+ckcEfPijHwTJFFYz/R5La5saCG6r3DkHyJJnN5SM4Xvph6oi9qhjG5MVzEljjndxm3h59LGaDoeEEBRBsS1hyGcyeQ/A1uLILV8d9D+RnPl9wdmNskkDxv+0lqhDINJrTRHFOKbP4RC4sxeDBETSuHcwgprCZc7OZUFI1trl3ASdOoz1MutSC/VL104rfUykrHbTnRzKc9YnPWxbs5KPmkDVCa4gN0Tm9iQJL1wzSWtSmRGddC+cv9nB5pv8arWDBc+m9bVZo9G9uegt/pb/7jqBlj8cJ9mTE5g62H0hw2pH3pPxNl57TShL6SIS6xuL5AS8MxF0ZrJx1jcZSXzdvzyICwSHwWEPjRH2MOhMh57E7PKNXNE+cU+C439hsV6NOSMmVXM/uaEjImaheVQxPiPkQs0x7b91YSgnBbPMsLjk1QzsMyuGexyQAMCjNigagXtOObvJl6dkT7h1uu/raNhsTwIU+t5g5EZvaDMvoIVFJesTF4qJPWpzsCJeetPrsQ48A/eH2xLlGmgWjDgdrkp3bnp+DlY1ESGNfgn1R0MkMQrApa17CSw5VcN25inrgyEZoQ55e3qSRzNvDeUQdY7TmN61xcK+Ckn8YBNKOHA4icKFZSYq5L6DOv8ZCZ5jGDOhgkLkyxImXBt2uEAqXaGoSIynez+sC7Ux5af5YyCOfZ0xqxZu/0JMmtjZE+aVu+EO/F85aqR67Kv8OIeDJo7BzUHH48z0Qbvgt3ZEN0YkzIP1cKG5htvPywrJJVPm2pqJfS2JmGFCy8/2oeLhC5G/N
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4769.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(83380400001)(53546011)(316002)(4326008)(8676002)(36756003)(31686004)(2906002)(86362001)(31696002)(76116006)(91956017)(66556008)(66446008)(66476007)(66946007)(64756008)(38070700005)(38100700002)(122000001)(6506007)(8936002)(5660300002)(71200400001)(508600001)(966005)(6486002)(6512007)(2616005)(54906003)(26005)(110136005)(186003)(43740500002)(45980500001)(10090945011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MmlnbzZMMUdiU2lLd3FKbVNNMVNIQU5ZN3UwMlFrMTN4ejIybHhwTEV0K2gv?=
 =?utf-8?B?STBwVjZVMjUxRldQOTlmTElTZ2cvemZLZmF6dFRxWmJWblhjNWVqQmM5ZDhU?=
 =?utf-8?B?VERocnBEbTJMZWJPbzE1UHlScVRMV0laelZ6T2FwT2dGU0l1QnJ2WFRYaUpp?=
 =?utf-8?B?VE5tV21iaXVGUVhFRFNlK1M3TnRjSTVKbWNVaW5Ja0dmUlRacFhSUGRJeXU0?=
 =?utf-8?B?bGVwSjY3WW5CdEg3clltOVdoYXVuc2V0WWY2d2xQU3ROdFJxeGh0YXJqQmYy?=
 =?utf-8?B?MEc2WWg3T0FXNllxeHpYVEMvMHBmZ0JKeHZxaXp3OS90d21ha1VUMTlBcVRx?=
 =?utf-8?B?emNJKzRjWjZTK0wwU1dSUkZsR2gzTG9zNXUyaEVUV3ZEMXliL21zdVBPSzdr?=
 =?utf-8?B?cU1kL2JsMkdqcDl1MHliaUNmWTNuU2x4Sm5BcWtybHVpMnhHN0k0SmhPYlpH?=
 =?utf-8?B?N0RZODVYSFNLWFNoSmM4eUpSb2dIVmR4MVl1SnZYTld3WEorcDVxM01vR09T?=
 =?utf-8?B?a1BXR1JTR3ovUDdMTmhxeUlvWnBWU1h2WEswbWp4aitpaVNoTXhoU3lLbGJq?=
 =?utf-8?B?Y2hReUJxc3JnSjNXT1E0RVpBeUJqbDNseHNzZE55T3RkU2hQTEtvcEUzVVg2?=
 =?utf-8?B?R2pBTVZqd3NIU0RIeWluN1NTOEcwMmx5TCsvUEpuSXA0aklCZGlrMFBlSEVJ?=
 =?utf-8?B?b21zdk5lRHUyZy8yUk5NM0RwcWEyeGlRVURZWGJYUDZlRTVzcEttWW9Tb3Fs?=
 =?utf-8?B?K2ovbTE5MFNVOG92bVhHYVdjREhZSmVzWm5YcFdsdjZTQk1PbENrdXQ4TGdD?=
 =?utf-8?B?cTA1Y1dpeEVRTG9BZWNUaHNMdFRtMmNKUW41TXFBOHNwQU5ncXczNGxXcmJR?=
 =?utf-8?B?cWxGRkxjWDVXWjZwMkpIKysreS9zK0tlSGtkeCtLamFmUUpBMlFyeTBsZFVI?=
 =?utf-8?B?azFMNnQ4aWVSaExkSm1nT0hwd3daMHZEMlROdVdDYzRMM3NMMXZaSkVjRitx?=
 =?utf-8?B?WlJnMHcrZEx2bytVTTJFSFdpcFgxN1FxamFyaGtTbFhLcFhoTkV6NnpQeHNJ?=
 =?utf-8?B?cUpSbExadXBLcUNoZzlTZk80ZDlmNmdvQ2taS09YdTBIQVFvT3M0Tjd1Nkh0?=
 =?utf-8?B?SG92SUMzemw1L1pKU3BFWkZhaHkyK0ZPbkh3RHdHdnJSZkRLTk83bE85aHRj?=
 =?utf-8?B?a0xacWhCUHVJMHE4VVNNb3hTUWhCNkFZWUwzZEhrR1pXRHhNNU1kVzUwTUhP?=
 =?utf-8?B?cW9BU3A3dkx6d24yeEIxUU1nOFBHRXhITSt0bEVkOGpPRGdVSnhMZkx2VUg0?=
 =?utf-8?B?MmFqN0hpNldKN1hldXJlTnlTL05iMW81Qys4R3ZpRGx5MVJ4a1lEMGJFQS9D?=
 =?utf-8?B?L29EYnUwN0JVRXNYMFZyNjlzdWJXYm1FeDk4MGVFUHRqcHh5SzFkNXFVdXNL?=
 =?utf-8?B?WVBoTHYrcW5zeVEySlQzbmhiUll3MytIdDZlWXJOL3owdWtuWjNpL1o0Qm1K?=
 =?utf-8?B?a002TWEvRmExRjhLNEs0YW1SYmFPcGdvRW5UL1pKeENhdmJZV1ZBUi80SzBw?=
 =?utf-8?B?eUd2TXZYeDZDTDJlOG5PRHFzSWdEN3k4dU1sUjhHSmVWMzM3bVFpV2ZuWTZp?=
 =?utf-8?B?c2JBWXRhVXNUUXYvN1ZXMGEwZlF1dDZLYmptKzlnWDlOcGlGOTAvcUFUNktP?=
 =?utf-8?B?bFdvb0pZWDJlVkhsRmY1dXVnQzIxK0d1M3hUMmdPUHFaNHVtSmcycVEwVEN1?=
 =?utf-8?B?MjM5eWplRGtuYmNEVS95SE5FK0xvbDg1MXkwdnhSY3o2ek1WSWlrSFNRbmJ1?=
 =?utf-8?B?bzdYVFQ1OXBzM0dCTTdhc05TalRHdTMwVUg5ekRFcjRCZlZnQmtCdElOaWxY?=
 =?utf-8?B?SURhVmFxcjU1eTBxMDNWWTlrVXBLVjdYd3ZLR0ZYQ2h0RVMrTUtoZWhBZW1R?=
 =?utf-8?B?MUV0MlhkV280U3I5U25MemVIMmlKeE0vK0xGR2xQTzJlMGVOdzIrTjk4aEdO?=
 =?utf-8?B?SGVjNFB6cUVQN1kxN0FsQTZhNmRyQ0RBQVhINEhUU1NTKzJSdFlTTExyelF2?=
 =?utf-8?B?d1YwbUJEZkZGdFJrTEpPNW92b1NHSlBJV3RPT1E0VVZRUnJycGtzd1AyR1Vv?=
 =?utf-8?B?Zk4zaktNd0lNRnAxbGxKa0syV09Qa1REaXI2Y2p3VTFONXZnRDl6MHM1ZHBx?=
 =?utf-8?B?SlRheGJRZ0QvVnc2MHNHZ0Vtalp3bDVBSUtwbW05d1pyQzJ6RTRUb2V5c3dI?=
 =?utf-8?B?TmlFbmFScnJGc1lWZXp1MGRMRysvelFwalNTQWxUWWNiYVBxRitvU0tyYkwz?=
 =?utf-8?B?V0RQMjNjSkZZYzBLSnB4cTUwc3lkTE5WZGYxRUVIVUZMYnhYWXRWOHUyM0FY?=
 =?utf-8?Q?MvxdPwT6AmIxr5P8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <59F62B350D6AC14FAE43A1F9054C1F31@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4769.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 050db0d4-1947-4155-ebe0-08da0e3d73bc
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Mar 2022 08:57:12.2495
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lzqMWQas7yy/7BUVesaQShORTM7RZsOQzlIE2cpSKRLUMaTFliIFYsScgA6vyapK5y/DN6ET/0qs4wAXkDUN4y+YmY7P2c0gWWh8qJbepM8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2588
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjUuMDMuMjAyMiAwODo1MCwgVG9tYXMgTWVsaW4gd3JvdGU6DQo+IFtTb21lIHBlb3BsZSB3
aG8gcmVjZWl2ZWQgdGhpcyBtZXNzYWdlIGRvbid0IG9mdGVuIGdldCBlbWFpbCBmcm9tIHRvbWFz
Lm1lbGluQHZhaXNhbGEuY29tLiBMZWFybiB3aHkgdGhpcyBpcyBpbXBvcnRhbnQgYXQgaHR0cDov
L2FrYS5tcy9MZWFybkFib3V0U2VuZGVySWRlbnRpZmljYXRpb24uXQ0KPiANCj4gRVhURVJOQUwg
RU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3Ug
a25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo+IA0KPiBjb21taXQgNWVhOWMwOGE4NjkyICgibmV0
OiBtYWNiOiByZXN0YXJ0IHR4IGFmdGVyIHR4IHVzZWQgYml0IHJlYWQiKQ0KPiBhZGRlZCBzdXBw
b3J0IGZvciByZXN0YXJ0aW5nIHRyYW5zbWlzc2lvbi4gUmVzdGFydGluZyB0eCBkb2VzIG5vdCB3
b3JrDQo+IGluIGNhc2UgY29udHJvbGxlciBhc3NlcnRzIFRYVUJSIGludGVycnVwdCBhbmQgVFFC
UCBpcyBhbHJlYWR5IGF0IHRoZSBlbmQNCj4gb2YgdGhlIHR4IHF1ZXVlLiBJbiB0aGF0IHNpdHVh
dGlvbiwgcmVzdGFydGluZyB0eCB3aWxsIGltbWVkaWF0ZWx5IGNhdXNlDQo+IGFzc2VydGlvbiBv
ZiBhbm90aGVyIFRYVUJSIGludGVycnVwdC4gVGhlIGRyaXZlciB3aWxsIGVuZCB1cCBpbiBhbiBp
bmZpbml0ZQ0KPiBpbnRlcnJ1cHQgbG9vcCB3aGljaCBpdCBjYW5ub3QgYnJlYWsgb3V0IG9mLg0K
PiANCj4gRm9yIGNhc2VzIHdoZXJlIFRRQlAgaXMgYXQgdGhlIGVuZCBvZiB0aGUgdHggcXVldWUs
IGluc3RlYWQNCj4gb25seSBjbGVhciBUWFVCUiBpbnRlcnJ1cHQuIEFzIG1vcmUgZGF0YSBnZXRz
IHB1c2hlZCB0byB0aGUgcXVldWUsDQo+IHRyYW5zbWlzc2lvbiB3aWxsIHJlc3VtZS4NCj4gDQo+
IFRoaXMgaXNzdWUgd2FzIG9ic2VydmVkIG9uIGEgWGlsaW54IFp5bnEgYmFzZWQgYm9hcmQuIER1
cmluZyBzdHJlc3MgdGVzdCBvZg0KPiB0aGUgbmV0d29yayBpbnRlcmZhY2UsIGRyaXZlciB3b3Vs
ZCBnZXQgc3R1Y2sgb24gaW50ZXJydXB0IGxvb3ANCj4gd2l0aGluIHNlY29uZHMgb3IgbWludXRl
cyBjYXVzaW5nIENQVSB0byBzdGFsbC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFRvbWFzIE1lbGlu
IDx0b21hcy5tZWxpbkB2YWlzYWxhLmNvbT4NCj4gLS0tDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5l
dC9jYWRlbmNlL21hY2JfbWFpbi5jIHwgOCArKysrKysrKw0KPiAgMSBmaWxlIGNoYW5nZWQsIDgg
aW5zZXJ0aW9ucygrKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2Nh
ZGVuY2UvbWFjYl9tYWluLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNlL21hY2JfbWFp
bi5jDQo+IGluZGV4IDgwMGQ1Y2VkNTgwMC4uZTQ3NWJlMjk4NDVjIDEwMDY0NA0KPiAtLS0gYS9k
cml2ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNlL21hY2JfbWFpbi5jDQo+ICsrKyBiL2RyaXZlcnMv
bmV0L2V0aGVybmV0L2NhZGVuY2UvbWFjYl9tYWluLmMNCj4gQEAgLTE2NTgsNiArMTY1OCw3IEBA
IHN0YXRpYyB2b2lkIG1hY2JfdHhfcmVzdGFydChzdHJ1Y3QgbWFjYl9xdWV1ZSAqcXVldWUpDQo+
ICAgICAgICAgdW5zaWduZWQgaW50IGhlYWQgPSBxdWV1ZS0+dHhfaGVhZDsNCj4gICAgICAgICB1
bnNpZ25lZCBpbnQgdGFpbCA9IHF1ZXVlLT50eF90YWlsOw0KPiAgICAgICAgIHN0cnVjdCBtYWNi
ICpicCA9IHF1ZXVlLT5icDsNCj4gKyAgICAgICB1bnNpZ25lZCBpbnQgaGVhZF9pZHgsIHRicXA7
DQo+IA0KPiAgICAgICAgIGlmIChicC0+Y2FwcyAmIE1BQ0JfQ0FQU19JU1JfQ0xFQVJfT05fV1JJ
VEUpDQo+ICAgICAgICAgICAgICAgICBxdWV1ZV93cml0ZWwocXVldWUsIElTUiwgTUFDQl9CSVQo
VFhVQlIpKTsNCj4gQEAgLTE2NjUsNiArMTY2NiwxMyBAQCBzdGF0aWMgdm9pZCBtYWNiX3R4X3Jl
c3RhcnQoc3RydWN0IG1hY2JfcXVldWUgKnF1ZXVlKQ0KPiAgICAgICAgIGlmIChoZWFkID09IHRh
aWwpDQo+ICAgICAgICAgICAgICAgICByZXR1cm47DQo+IA0KPiArICAgICAgIHRicXAgPSBxdWV1
ZV9yZWFkbChxdWV1ZSwgVEJRUCkgLyBtYWNiX2RtYV9kZXNjX2dldF9zaXplKGJwKTsNCj4gKyAg
ICAgICB0YnFwID0gbWFjYl9hZGpfZG1hX2Rlc2NfaWR4KGJwLCBtYWNiX3R4X3Jpbmdfd3JhcChi
cCwgdGJxcCkpOw0KPiArICAgICAgIGhlYWRfaWR4ID0gbWFjYl9hZGpfZG1hX2Rlc2NfaWR4KGJw
LCBtYWNiX3R4X3Jpbmdfd3JhcChicCwgaGVhZCkpOw0KPiArDQo+ICsgICAgICAgaWYgKHRicXAg
PT0gaGVhZF9pZHgpDQo+ICsgICAgICAgICAgICAgICByZXR1cm47DQo+ICsNCg0KVGhpcyBsb29r
cyBsaWtlIFRCUVAgaXMgbm90IGFkdmFuY2luZyB0aG91Z2ggdGhlcmUgYXJlIHBhY2tldHMgaW4g
dGhlDQpzb2Z0d2FyZSBxdWV1ZXMgKGhlYWQgIT0gdGFpbCkuIFBhY2tldHMgYXJlIGFkZGVkIGlu
IHRoZSBzb2Z0d2FyZSBxdWV1ZXMgb24NClRYIHBhdGggYW5kIHJlbW92ZWQgd2hlbiBUWCB3YXMg
ZG9uZSBmb3IgdGhlbS4NCg0KTWF5YmUgVFhfV1JBUCBpcyBtaXNzaW5nIG9uIG9uZSBUWCBkZXNj
cmlwdG9yPyBGZXcgbW9udGhzIGFnbyB3aGlsZQ0KaW52ZXN0aWdhdGluZyBzb21lIG90aGVyIGlz
c3VlcyBvbiB0aGlzIEkgZm91bmQgdGhhdCB0aGlzIG1pZ2h0IGJlIG1pc3NlZA0Kb24gb25lIGRl
c2NyaXB0b3IgWzFdIGJ1dCBoYXZlbid0IG1hbmFnZWQgdG8gbWFrZSBpdCBicmVhayBhdCB0aGF0
IHBvaW50DQphbnlob3cuDQoNCkNvdWxkIHlvdSBjaGVjayBvbiB5b3VyIHNpZGUgaWYgdGhpcyBp
cyBzb2x2aW5nIHlvdXIgaXNzdWU/DQoNCgkvKiBTZXQgJ1RYX1VTRUQnIGJpdCBpbiBidWZmZXIg
ZGVzY3JpcHRvciBhdCB0eF9oZWFkIHBvc2l0aW9uDQoJICogdG8gc2V0IHRoZSBlbmQgb2YgVFgg
cXVldWUNCgkgKi8NCglpID0gdHhfaGVhZDsNCgllbnRyeSA9IG1hY2JfdHhfcmluZ193cmFwKGJw
LCBpKTsNCgljdHJsID0gTUFDQl9CSVQoVFhfVVNFRCk7DQorCWlmIChlbnRyeSA9PSBicC0+dHhf
cmluZ19zaXplIC0gMSkNCisJCWN0cmwgfD0gTUFDQl9CSVQoVFhfV1JBUCk7DQoJZGVzYyA9IG1h
Y2JfdHhfZGVzYyhxdWV1ZSwgZW50cnkpOw0KCWRlc2MtPmN0cmwgPSBjdHJsOw0KDQpbMV0NCmh0
dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3RvcnZhbGRzL2xp
bnV4LmdpdC90cmVlL2RyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvbWFjYl9tYWluLmMjbjE5
NTgNCg0KPiAgICAgICAgIG1hY2Jfd3JpdGVsKGJwLCBOQ1IsIG1hY2JfcmVhZGwoYnAsIE5DUikg
fCBNQUNCX0JJVChUU1RBUlQpKTsNCj4gIH0NCj4gDQo+IC0tDQo+IDIuMzUuMQ0KPiANCg0K
