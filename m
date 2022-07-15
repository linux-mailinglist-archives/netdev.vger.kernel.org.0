Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65984575E6B
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 11:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231917AbiGOJX3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 05:23:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231776AbiGOJXZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 05:23:25 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED37066AD1
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 02:23:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1657877004; x=1689413004;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=C/PfSjXYrB7Qpzzqm5TmMCwFXXxY2SmQdcSWVdqvu+E=;
  b=MehN4wZQCaTZwlq1YymZWxmvOfbOBETSKc6To/clZwhu725ma2gJS8TQ
   8jcvRvmjKS8bqySAnuv1h3qJVbgGG9DWQF1P+M1rNi5y4xlTAXUeKVMVB
   UICxRevDCQ4I6hqvdiak+/aT6SNW1TRodW+Uvt0QquRpQxxlciCk1dtwL
   Do0nifR4bUdLVrPdoTHQPIyKSe0F9fIqYidBm1MUbZiAVI89XI6FfTNw7
   Oj95FPfw5h3PC/VysBCRgrf5BrO3kBK7aOPETP0Mnr8+DFFegPqjUVwR4
   sPWhcydnWsBw2t6YueRgFeanOMaKJ7a8hukyNH1bUw99T+w3SjEOgDKAa
   A==;
X-IronPort-AV: E=Sophos;i="5.92,273,1650956400"; 
   d="scan'208";a="164883608"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Jul 2022 02:23:23 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 15 Jul 2022 02:23:22 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17 via Frontend Transport; Fri, 15 Jul 2022 02:23:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Oc1gXQHsXYFJDRuK3ZUa8ufuBwKVXln1Oy1Q3yYt+izLIw30QbqRuSGbkEFe3Ye6mVWmhphUP4U6EfCXbndmT563DTtwuyPxZt+Buzjp3jHCBUPWlFYJWvZsbsW0GB5l6hnmbmP16vEytoXTnRwHxZg8lAQjAiqpKgY8wSFcHfvpT4zhgRCHoYROflABYl221QfmxhI53xj2c4lPRhunaWGilF7L3G98DDIHksLpWQ8EvgxQPjYFtlMU2kc0l4p1+5A93MGC+tiaLSjmbmgVW1KCril0QVMLN9nnGp9oYetH2MeFrXRjcsM/PON+2Yecm7Fk8fscZmX7LtG4EdWI9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C/PfSjXYrB7Qpzzqm5TmMCwFXXxY2SmQdcSWVdqvu+E=;
 b=ck69oAQRzC4bhKfnbMa8H6EpkW2Ukfk6gFfgXlEogBdBqgFFCRd9kX6bbdBtXF9l4Lg6jaPv9V4TTKUrDYmPOCW0e1HO8CvRyfKSRim4+fjROWPguCSFuDb3Xg7ty/1/vTqgF35OA/IoJ0yAdkJDjcpA0HHPsj4Owm2aZvl/7Ddzde1YlZQsrmnTiaa32/IFdl8mvemb5UQCyLCXZD2jMEt1AdDhQFBHhZGe+FNR5arPDYxyg+AKjDSfqza+e1sAATtPT6sYSJfyIYxKBlm2TLBi62MLC1Q01+7PUir6LsMRZm0qlNCOc3Xra9RvufU1Q2sfUZybk9x/jZNJGzTnAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C/PfSjXYrB7Qpzzqm5TmMCwFXXxY2SmQdcSWVdqvu+E=;
 b=miE3nLqPm2L+BTjCYNF0/CoBSvQewc+Nx8SsbFKzqk3jCihBb08GBtvFGpTTCNj5Z4/48tLeI6bEwNFj63223W/tZiRr2ASw33bDm08/0bM0P+9dbBmuixV+c2QXkktQCMjfuC84YHcHYipU30vPzclM+NnMFGavFg/LqVS8HFI=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 DM5PR11MB2060.namprd11.prod.outlook.com (2603:10b6:3:13::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5438.12; Fri, 15 Jul 2022 09:23:20 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::a4d9:eecb:f93e:7df0]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::a4d9:eecb:f93e:7df0%6]) with mapi id 15.20.5438.014; Fri, 15 Jul 2022
 09:23:20 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <vladimir.oltean@nxp.com>
CC:     <claudiu.manoil@nxp.com>, <UNGLinuxDriver@microchip.com>,
        <alexandre.belloni@bootlin.com>, <vivien.didelot@gmail.com>,
        <andrew@lunn.ch>, <idosch@nvidia.com>, <linux@rempel-privat.de>,
        <petrm@nvidia.com>, <f.fainelli@gmail.com>, <hauke@hauke-m.de>,
        <martin.blumenstingl@googlemail.com>, <xiaoliang.yang_1@nxp.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@google.com>,
        <netdev@vger.kernel.org>, <Woojung.Huh@microchip.com>,
        <davem@davemloft.net>
Subject: Re: [RFC PATCH net-next 3/3] net: dsa: never skip VLAN configuration
Thread-Topic: [RFC PATCH net-next 3/3] net: dsa: never skip VLAN configuration
Thread-Index: AQHYkJVA+iLppAy/uE2cW1NrBQONVa1xiwcAgAADhICAADWVAIABvUGAgADAlICAACQggIAArH6AgAiqEgCAAEpdAIABMNoA
Date:   Fri, 15 Jul 2022 09:23:19 +0000
Message-ID: <3527f7f04f97ff21f6243e14a97b342004600c06.camel@microchip.com>
References: <20220705173114.2004386-1-vladimir.oltean@nxp.com>
         <20220705173114.2004386-4-vladimir.oltean@nxp.com>
         <CAFBinCC6qzJamGp=kNbvd8VBbMY2aqSj_uCEOLiUTdbnwxouxg@mail.gmail.com>
         <20220706164552.odxhoyupwbmgvtv3@skbuf>
         <CAFBinCBnYD59W3C+u_B6Y2GtLY1yS17711HAf049mstMF9_5eg@mail.gmail.com>
         <20220707223116.xc2ua4sznjhe6yqz@skbuf>
         <CAFBinCB74dYJOni8-vZ+hNH6Q6E4rmr5EHR_o5KQSGogJzBhFA@mail.gmail.com>
         <20220708120950.54ga22nvy3ge5lio@skbuf>
         <CAFBinCCnn-DTBYh-vBGpGBCfnsQ-kSGPM2brwpN3G4RZQKO-Ug@mail.gmail.com>
         <f19a09b67d503fa149bd5a607a7fc880a980dccb.camel@microchip.com>
         <20220714151210.himfkljfrho57v6e@skbuf>
In-Reply-To: <20220714151210.himfkljfrho57v6e@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2b55e343-0177-4620-da29-08da6643a870
x-ms-traffictypediagnostic: DM5PR11MB2060:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Qzll97JhYz199o+dxFWt27gvq006dnDCtEePkZX+WVIZI1B/FXnXIgaiiwWU5+1cHS93PcIhA8+yd1u1ZFJVPlvhDB9OCS1zQ6aLVk61bQ+yV0P+TKNCTIhEvmHN+cWKyp2gc0ovcppnGSDpiZFsRchnAvo3VN1pyN5Enu83HALrISPdMtOUjFHAdSVOX5aZv9SKq0R1B0G1xd795LMuGdi1zogIPuDxGwpUMKjfGPMyLI/eIOLCmfho58oGxYUkDG17oo8uA7Hh1JaSh4AWMWhCwbCl2iIEjrWi5eDZ+jrIx94rPz783vN5Yta5VJp21drNZhFOrXTaR7XohsfVOGuGn2cER1rtHGbRf+rUijpqtsDCYGrHV2voVljLnqJlnxHlTAggup/nF9xjYkn4vCkOatnAkV7BiFeeaehNocThO7yliKyoJRt+DztNLEkVJ4HlvBSaGO3Aw5tEekPXCWr6XE/SzlKak9v1IvAxm7D4c6G6rygziQFetqE0pwYHSxrQyKf3/j9QH/vZYPEhzLH5QcVda2bfTK0Jhmv77MdLutGxx2A4Cw0sDcVajZDFB8OKP1v8XqxXlBIWno6FDrJKHiH3g3OPmLayfko78wc+Qa2FAlccXi6ewoE7gsePajkumOZvJ/32KIhfGm/juUSF8RD+P0efvqMytQue2hH3GkN+2vlCtJ6gLECTyNZoZbUQ6ThRK0Tk3KUm05C0Ssma/EQZjavGGd2090LY2D12Dfe7Z5dmkeDfwxwy3yV1RFgRj/F6L5d/YOIbvbPdGbpbGzIlnxtW72BFFXh5vjBSEnfefv7zpR8Ftqx8dpLcjOKFWo8gei5QZePIg/eD6I0aT9eI8ZyEpSOfsEdtrj02FXi7b5qnYR0B2TlYxaZM
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(39860400002)(396003)(376002)(136003)(346002)(26005)(6916009)(66476007)(66946007)(966005)(6512007)(478600001)(91956017)(316002)(6486002)(66556008)(76116006)(41300700001)(64756008)(8676002)(6506007)(71200400001)(122000001)(86362001)(4326008)(54906003)(83380400001)(2616005)(38070700005)(7416002)(186003)(36756003)(66446008)(8936002)(38100700002)(5660300002)(2906002)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U1JRaGt4RnpkKy9SSWVJZ2FKRVMwTXRLOWgvbEZvUDFONEYxd3p2cXBSaU1G?=
 =?utf-8?B?TW9LVWRlY0VyajhXRDBHemtUV0labXNVMGJub2lYenp0N1dORjdMZituMWpi?=
 =?utf-8?B?K1RxQVdvenBwUk0rVTRqYzZQZkhTeTlObFoxSFB0KzN0dmtMUGRkazdwNEg5?=
 =?utf-8?B?Q3NMUjIzNHZQVXBKbXdCeElJQ1VFV1Nydm5Tbm9BOGVMeDBCQ1NWQVNsWXU2?=
 =?utf-8?B?U3dVUytwNkdwYjR1ck1kaHZZSzJ0bkxOelpMNlNpMGM4YzRaTzJwZWs1U0NC?=
 =?utf-8?B?V3VKWmxLUitRZmJkc1ZNRm1CZGYzWllnWTduVGxMSVZ5dFFaNTR1SUtYdW92?=
 =?utf-8?B?RjU1eDlpYVBoUy96K1M2QjUvWU16MlFPbEczVG4yeUllRENtM3B6MXFTdnR6?=
 =?utf-8?B?MWpZcFpNZmJGd3BZY0RmdTR3KzFUZU5iREI5VGVkWGpYRDdKS2ZiT09aWTkr?=
 =?utf-8?B?ZzhRVi9tU3JXenBVTjYrVVBTN29TckM0b25uZ1F2a3RVZUR6L3p3L0VxT2Z3?=
 =?utf-8?B?a1lWMi9rcnd0YzRMNGl0TTN5Unl4UkVpc0lyOWMvVC9nNkZIMW04YklscEYx?=
 =?utf-8?B?QnpCOUtOWTlWMjNmdU1seFAxOVNmY1Fua1F3S3hlME1ZOVZUZEd4SWJFR292?=
 =?utf-8?B?OTFiUVVKTkJTdTQvVWZwZlE1NVVyMGh3RjVFYVI3VmpYdisvQmMxNVloN1E4?=
 =?utf-8?B?UERmL3VBakJZOUlHUDhNcTFBcktLc2RjdnUyTHNrYStnZk9rZ09YbzdHTkpp?=
 =?utf-8?B?aTFhM3NEVW5taHl2U3Ivb1Axb0lEa0VCUFlZSlUrdG5pWWUxYm9GWlVqNVhL?=
 =?utf-8?B?VHlSL093ZW1SRVhuR1JyQlhLdW9EMWpLOW1tVDhRUHl2dlVERDJHU0EvYkxZ?=
 =?utf-8?B?ZkFLdXRrN3B3dFlGSEpEb1hiSTVDQWx2OVo1VUI2VU1LcUN5Z0FZUnR3NE4x?=
 =?utf-8?B?Q0lHWHl2aTVSTVZNeUdZREN4SlkzSWZnSlVFTm1ESUJQbEZ4OU00bTJPR3JG?=
 =?utf-8?B?U1ducDl3RjdCYXQrb0NRTVEwVU00ZlV0bEwvMko2ZVUyQXBlL1pJYW91UUdN?=
 =?utf-8?B?WE95cWRPNnVNdEhQbmo5WVpvT1JFT2pHaHBIRnBiWU1KSmhDVUJDUmFqZmlF?=
 =?utf-8?B?QjVXSnEvY0VoTlZrdXIwQkxKRnNIaGVyUTNmRmRwQlhxV2RmdGk0TWtlaFlS?=
 =?utf-8?B?QTF6QVdjb1kwcERIMys4Y2FWMmlMSEFzQlRIeEZrcGtXdlY0amdvSiszRi9B?=
 =?utf-8?B?ODIxUGlRb2dwcnRXYklxdUtSWSs2aC9ScHdkZ0NDMmhYcTFTT0MrUlpVYzQr?=
 =?utf-8?B?OEZHM1VpWTZxcDBqSXRrOVBWeTFnLzJpUXZrTExLWnpKaE1Qamk5dVdGU1Vr?=
 =?utf-8?B?NGNpaHdFT3RjMy94TVlvQ3pWb0JhblVpMTlNQ2p6NTdMOEVCRjN5NkRCdUp4?=
 =?utf-8?B?N05jaHV2ZDduYXFQdEdEWi9mQVI1azlpRkxPN3VCK3BqSURpenhMSzhJQjEz?=
 =?utf-8?B?UDBEK01KMUtoSFZrdE9xa1N0YThvNG1sckZYdHNTZFFENFFwUEZVT1ByZGhk?=
 =?utf-8?B?dUJhQmhQSFoyeFo3alVkcDFqaWNvQWhoQXNJOE91Ump3RVg0YlZsazJacTZY?=
 =?utf-8?B?ZVR2VTVTSW9SMTNKVzYxeVRIdlBHNHNOYU1yNkEwSW5PK0Ewb3ZnaG1pYmZJ?=
 =?utf-8?B?ZWlyT3dQR1k3dTBEbWhVN2RiYU5La3k3bE9OeVZOcmxwU08xQkYvUkMrUXp0?=
 =?utf-8?B?eHI4bDNMbkRhWm5zSFNyUmpCcjZzRjFQWEJ4SktUc2c1cjlxeG1EMVUwRjcw?=
 =?utf-8?B?RzdNUmU5WG85NE1NNXdUM094cjdSZmxBR3l1VUVnNy9QektZamJNUmhPVW04?=
 =?utf-8?B?VUVRZTRLd1JtazErZmdDTTZwbmNWUmkrQ1RWZW1Hd1dBUlcvZ0tPbXRJb2cr?=
 =?utf-8?B?R2docmJJUkRXcXQvUlVyM1Jndjg3c1J3RG1DdGZDMTB6NkN4NTNOTzZxc2Nz?=
 =?utf-8?B?QmhTRjFxbjhDVkp3MTB3bDVrMk9iYnFlZW9ZUXk5cERLUkMzOWNJdmRwaVpL?=
 =?utf-8?B?M28vZmFTUW5IZjlCdGR5cFpMSzdlbjBQNnlXTmZraVF5RHA2YnZKRzdQTXJK?=
 =?utf-8?B?SXZFeUZqRHVDaW1yM1RXSUExWEI2WndBZjN5a3M3elNnR1JaU0FQT0o0NkZy?=
 =?utf-8?Q?0Hd5JxCr9TFCgDct2aZXotc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DD96EC13AAF8A24BA4F93137936D1949@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b55e343-0177-4620-da29-08da6643a870
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2022 09:23:20.0844
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZWh8O4J/GL7KbKHOMq7jP2mibAc99a1PtXXBE6k6zKbNHxjuRWeNQvCMi7TRV88o8uvtQIw46JkEvpA8jh/q0lSE/P1l1Fns/Hxf0IpuSok=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB2060
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgVmxhZGltaXIsDQoNCk9uIFRodSwgMjAyMi0wNy0xNCBhdCAxNToxMiArMDAwMCwgVmxhZGlt
aXIgT2x0ZWFuIHdyb3RlOg0KPiBFWFRFUk5BTCBFTUFJTDogRG8gbm90IGNsaWNrIGxpbmtzIG9y
IG9wZW4gYXR0YWNobWVudHMgdW5sZXNzIHlvdQ0KPiBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUN
Cj4gDQo+IEhpIEFydW4sDQo+IA0KPiBPbiBUaHUsIEp1bCAxNCwgMjAyMiBhdCAxMDo0NjowMkFN
ICswMDAwLCBBcnVuLlJhbWFkb3NzQG1pY3JvY2hpcC5jb20NCj4gIHdyb3RlOg0KPiA+IEhpIFZs
YWRpbWlyLA0KPiA+IFdlIGNvdWxkbid0IGFibGUgdG8gc2V0dXAgdGhlIHNlbGZ0ZXN0cyBhbmQg
ZmFpbGVkIGR1cmluZw0KPiA+IGluc3RhbGxhdGlvbg0KPiA+IG9mIHBhY2thZ2VzLiBJbiB0aGUg
bWVhbiB0aW1lLCBXZSB0cmllZCB0aGUgZm9sbG93aW5nIHRoaW5ncw0KPiA+IA0KPiA+IFNldHVw
IC0gSG9zdDEgLS0+IGxhbjEgLS0+IGxhbjIgLS0+IEhvc3QyLiBQYWNrZXQgdHJhbnNtaXR0ZWQg
ZnJvbQ0KPiA+IEhvc3QxIGFuZCByZWNlaXZlZCBieSBIb3N0Mi4NCj4gPiANCj4gPiBTY2VuYXJp
by0xOiBWbGFuIGF3YXJlIHN5c3RlbSBhbmQgYm90aCBsYW4xICYgbGFuMiBhcmUgaW4gc2FtZSB2
aWQNCj4gPiBpcCBsaW5rIHNldCBkZXYgYnIwIHR5cGUgYnJpZGdlIHZsYW5fZmlsdGVyaW5nIDEN
Cj4gPiBicmlkZ2UgdmxhbiBhZGQgZGV2IGxhbjIgdmlkIDEwIHB2aWQgdW50YWdnZWQNCj4gPiBi
cmlkZ2UgdmxhbiBhZGQgZGV2IGxhbjEgdmlkIDEwIHB2aWQgdW50YWdnZWQNCj4gPiANCj4gPiBQ
YWNrZXQgdHJhbnNtaXR0ZWQgZnJvbSBIb3N0MSB3aXRoIHZpZCAxMCBpcyByZWNlaXZlZCBieSB0
aGUgSG9zdDIuDQo+ID4gUGFja2V0IHRyYW5zbWl0dGVkIGZyb20gSG9zdDEgd2l0aCB2aWQgNSBp
cyBub3QgcmVjZWl2ZWQgYnkgdGhlDQo+ID4gSG9zdDIuDQo+ID4gDQo+ID4gU2NlbmFyaW8tMjog
VmxhbiB1bmF3YXJlIHN5c3RlbQ0KPiA+IGlwIGxpbmsgc2V0IGRldiBicjAgdHlwZSBicmlkZ2Ug
dmxhbl9maWx0ZXJpbmcgMA0KPiA+IA0KPiA+IE5vdywgaXJyZXNwZWN0aXZlIG9mIHRoZSB2aWQs
IHRoZSBwYWNrZXRzIGFyZSByZWNlaXZlZCBieSBIb3N0Mg0KPiA+IFBhY2tldCB0cmFuc21pdHRl
ZCBmcm9tIEhvc3QxIHdpdGggdmlkIDEwIGlzIHJlY2VpdmVkIGJ5IHRoZSBIb3N0Mi4NCj4gPiBQ
YWNrZXQgdHJhbnNtaXR0ZWQgZnJvbSBIb3N0MSB3aXRoIHZpZCA1IGlzICByZWNlaXZlZCBieSB0
aGUgSG9zdDIuDQo+ID4gDQo+ID4gV2hldGhlciB0aGUgYWJvdmUgYXBwcm9hY2ggaXMgY29ycmVj
dCBvciBkbyB3ZSBuZWVkIHRvIHRlc3QNCj4gPiBhbnl0aGluZw0KPiA+IGZ1cnRoZXIuDQo+ID4g
DQo+ID4gVGhhbmtzDQo+ID4gQXJ1bg0KPiANCj4gVGhlIGFib3ZlIGlzIGNvcnJlY3QgdG8gdGhl
IGV4dGVudCB0aGF0IGl0IGlzIGEgdmFsaWQgY29uZmlndXJhdGlvbiwNCj4gYnV0IGlzbid0IHdo
YXQgbXkgcHZpZF9jaGFuZ2UoKSBzZWxmdGVzdCB3YXMgaW50ZW5kZWQgdG8gY2FwdHVyZS4NCj4g
DQo+IFRoZSBwdmlkX2NoYW5nZSgpIHNlbGZ0ZXN0IGZyb20gcGF0Y2ggMS8zDQo+IA0KaHR0cHM6
Ly9wYXRjaHdvcmsua2VybmVsLm9yZy9wcm9qZWN0L25ldGRldmJwZi9wYXRjaC8yMDIyMDcwNTE3
MzExNC4yMDA0Mzg2LTItdmxhZGltaXIub2x0ZWFuQG54cC5jb20vDQo+IGNoZWNrcyB0aGF0IFZM
QU4tdW5hd2FyZSBmb3J3YXJkaW5nIHN0aWxsIHRha2VzIHBsYWNlIGFmdGVyIHRoaXMNCj4gYXJy
YXkNCj4gb2Ygb3BlcmF0aW9uczoNCj4gDQo+IGlwIGxpbmsgYWRkIGJyMCB0eXBlIGJyaWRnZSB2
bGFuX2ZpbHRlcmluZyAwICMgbm90aWNlIHRoZSAwIGluc3RlYWQNCj4gb2YgMQ0KPiBpcCBsaW5r
IHNldCAkc3dwMSBtYXN0ZXIgYnIwDQo+IGlwIGxpbmsgc2V0ICRzd3AyIG1hc3RlciBicjANCj4g
YnJpZGdlIHZsYW4gYWRkIHZpZCAzIGRldiAkc3dwMSBwdmlkIHVudGFnZ2VkICMgbm90aWNlIGhv
dyBWSUQgMyBpcw0KPiBhYnNlbnQgb24gJHN3cDINCj4gDQo+IElmIHlvdSBsZXQgbWUga25vdyBp
ZiB0aGlzIHdvcmtzLCBJIGNhbiBjb250aW51ZSBhbmQgcmVzZW5kIHRoaXMNCj4gcGF0Y2gNCj4g
c2V0IHdoaWxlIHlvdSBmaWd1cmUgb3V0IHRoZSBrc2VsZnRlc3Qgc2V0dXAgaXNzdWVzLg0KV2Ug
dHJpZWQgdGhlIGZvbGxvd2luZyB0ZXN0DQoNCmlwIGxpbmsgc2V0IGRldiBicjAgdHlwZSBicmlk
Z2Ugdmxhbl9maWx0ZXJpbmcgMA0KDQppcCBsaW5rIHNldCBsYW4xIG1hc3RlciBicjANCmlwIGxp
bmsgc2V0IGxhbjIgbWFzdGVyIGJyMA0KDQpicmlkZ2UgdmxhbiBhZGQgdmlkIDEwIGRldiBsYW4x
IHB2aWQgdW50YWdnZWQNCg0KPT0+DQpQYWNrZXQgdHJhbnNtaXR0ZWQgZnJvbSBIb3N0MSB3aXRo
IHZpZCA1IGlzIG5vdCByZWNlaXZlZCBieSB0aGUgSG9zdDIgDQpQYWNrZXQgdHJhbnNtaXR0ZWQg
ZnJvbSBIb3N0MSB3aXRoIHZpZCAxMCBpcyBub3QgcmVjZWl2ZWQgYnkgdGhlIEhvc3QyDQo9PT4g
DQoNCmJyaWRnZSB2bGFuIGFkZCB2aWQgMTAgZGV2IGxhbjIgcHZpZCB1bnRhZ2dlZA0KDQo9PT4N
ClBhY2tldCB0cmFuc21pdHRlZCBmcm9tIEhvc3QxIHdpdGggdmlkIDUgaXMgcmVjZWl2ZWQgYnkg
dGhlIEhvc3QyIA0KUGENCmNrZXQgdHJhbnNtaXR0ZWQgZnJvbSBIb3N0MSB3aXRoIHZpZCAxMCBp
cyByZWNlaXZlZCBieSB0aGUgSG9zdDINCj09PiANCg0KYnJpZGdlIHZsYW4gZGVsIHZpZCAxMCBk
ZXYgbGFuMg0KDQo9PT4NClBhY2tldCB0cmFuc21pdHRlZCBmcm9tIEhvc3QxIHdpdGggdmlkIDUg
aXMgbm90IHJlY2VpdmVkIGJ5IHRoZSBIb3N0MiANClBhY2tldCB0cmFuc21pdHRlZCBmcm9tIEhv
c3QxIHdpdGggdmlkIDEwIGlzIG5vdCByZWNlaXZlZCBieSB0aGUgSG9zdDINCj09PiANCg0KVHJp
ZWQgdGhpcyB0ZXN0IGJlZm9yZSBhbmQgYWZ0ZXIgYXBwbHlpbmcgdGhpcyBwYXRjaCBzZXJpZXMu
IEFuZCBnb3QNCnRoZSBzYW1lIHJlc3VsdC4NCg0KSW4gc3VtbWFyeSwgcGFja2V0cyBhcmUgZHJv
cHBlZCB3aGVuIHB2aWQgaXMgYWRkZWQgdG8gdmxhbiB1bmF3YXJlDQpicmlkZ2UuIExldCBtZSBr
bm93IGlmIGFueXRoaW5nIG5lZWQgdG8gcGVyZm9ybWVkIG9uIHRoaXMuDQoNClRoYW5rcw0KQXJ1
biANCg==
