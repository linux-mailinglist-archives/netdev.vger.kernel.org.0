Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF84D5B959C
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 09:43:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbiIOHno (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 03:43:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230051AbiIOHnc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 03:43:32 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 537F192F4D;
        Thu, 15 Sep 2022 00:43:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1663227811; x=1694763811;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=PtfyQIbBlvYz9nfZi05MxhoYV3CXIAISqXxBR1uvmfo=;
  b=S9s/nsO7FHwPHng07uN/Xzm8prI0qvKXddvoYso2VLVN/wc0d9GlAGiQ
   DD/4YrxfiybsNpyqYb5U5j5Sm+K6vHaBXXsX4JOFyp4vmc65kTAQbRvgY
   cKMYE3sjxaQZON0HeSxkHNXMnHMY9o2XkacGcXx5vhEqbSJ995X1T5iwV
   kBLz1NlJR9mAU7UJ01QIVMFi74JX68vlwrjwE3EhY32pWdurY0exuBg/e
   5gH46g3p4PZN4IrP4eeNNjl+7rYFZzkaHDj6J5UXgoQrWiTGNJtdLmNnZ
   cLVjhIGt31wZKB7mDurJEWXUOsYZh0ehnMBeZHxj+tdtANtCGcLiBkOaj
   w==;
X-IronPort-AV: E=Sophos;i="5.93,317,1654585200"; 
   d="scan'208";a="113783318"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Sep 2022 00:43:30 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Thu, 15 Sep 2022 00:43:30 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12 via Frontend Transport; Thu, 15 Sep 2022 00:43:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cRzI6v98BYPlbrl1LehwzqvjkwykzdC2cVFnd65P2HrAWOJETx1tRXx+3t1UBRmYxcSfLhmoerZH5RkRwNVM0ZMBxUj6KuU0utpKKjSTxah07bugGTL3BwjuSO/+OgXD5Nw7ap9s2K7kGfPb6L81Ys1d3xCl/aRqgotfNZW1ng7QnJl5YEt5mrnQaAmOjzYPM6985IELUBat+hlYCuoZxL/DKNTeHVPF0M404khpAJfT6jslTO63V+bPPCdChquJY1fmUA3qhsu84CF7X4AOHT5rAyk2FeYi1y+vi1C8UxUJJMS5xmMLlOuR5LrLSoQfCKdvWR6xPSH6SIk9iSuY6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PtfyQIbBlvYz9nfZi05MxhoYV3CXIAISqXxBR1uvmfo=;
 b=RA5ntXWiJaNiCZRopEAzbTVCbrsLktBBYaB+kM36tkit4uM2GE+PQnBaDlvKP8R/IRIhl0zRtIvu3CULPvHLL2rV7e2mncBtPs5pmwhQxghrcaBC3cnjJG0ztVPHhVHZLFr2Kx2H7tZreM7C2T4Y0TUlmCHnIkorW519TNAOw7LpGdMEv3+q+MH6BQpc5T9mZfkCZ/NFT5tMi4aMIN9g7b9SK50sGCJCNUu+R9oZYe07O3b0ULeV146qZW1cik3hN1AX7X1I66IDuKKWxFiQRampggJH5LSvwuSz37SwnN1h0jw+nryMghZ2chwHw2xe/3PWsL5JcBK5QTSwB8LE3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PtfyQIbBlvYz9nfZi05MxhoYV3CXIAISqXxBR1uvmfo=;
 b=MVbpzWC19jRw7g9p4J63ket7b04VLxx2Qww9ngeoPBSn/m1auicDZEwyfVg26midnCCBHao8rtfWC2FSpFaXr2iRDhGz6ew1PNdbzIsPk0GkLi2qSXb0TJOFY3tEl8TNDf0jSJQMzBxYiUqYh/nH8OjC/eVHP8U2BjmPifyoiDI=
Received: from BN6PR11MB1953.namprd11.prod.outlook.com (2603:10b6:404:105::14)
 by MW4PR11MB6761.namprd11.prod.outlook.com (2603:10b6:303:20d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.15; Thu, 15 Sep
 2022 07:43:25 +0000
Received: from BN6PR11MB1953.namprd11.prod.outlook.com
 ([fe80::a159:97ec:24bc:6610]) by BN6PR11MB1953.namprd11.prod.outlook.com
 ([fe80::a159:97ec:24bc:6610%11]) with mapi id 15.20.5632.015; Thu, 15 Sep
 2022 07:43:25 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <radhey.shyam.pandey@amd.com>, <michal.simek@xilinx.com>,
        <Nicolas.Ferre@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <gregkh@linuxfoundation.org>, <andrew@lunn.ch>,
        <Conor.Dooley@microchip.com>
CC:     <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <git@amd.com>
Subject: Re: [PATCH v3 net-next 2/2] net: macb: Add zynqmp SGMII dynamic
 configuration support
Thread-Topic: [PATCH v3 net-next 2/2] net: macb: Add zynqmp SGMII dynamic
 configuration support
Thread-Index: AQHYyNbWMoIakjyKG0+2ssdBYhgBJA==
Date:   Thu, 15 Sep 2022 07:43:25 +0000
Message-ID: <13e57528-0bcc-feba-8363-773a374572e4@microchip.com>
References: <1663158796-14869-1-git-send-email-radhey.shyam.pandey@amd.com>
 <1663158796-14869-3-git-send-email-radhey.shyam.pandey@amd.com>
In-Reply-To: <1663158796-14869-3-git-send-email-radhey.shyam.pandey@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN6PR11MB1953:EE_|MW4PR11MB6761:EE_
x-ms-office365-filtering-correlation-id: 96503d91-1d1a-4039-ea3e-08da96edf8fe
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iqI6okwO6Y1ypLj2hKxwk/B49kb5vz5pB89hDirT18+M9+Y2qc61H06z8GSHb3AkpGeMLT6+uVrIXMa1ym+sfKq+F2XjO6ZKqsDAYiZHQ9KYe3SrlcURG8Ai0Jd0YjWUXvbTC8p5NfJ2qKkF/yvbnEDaBOeCOj0tJCeYPoK4n2Bd0woN2XhPdU5xDmIjj20XEe6sjUVvlqzjVkbjmkO7j/maXC6TiGbv7EtubGvR0z6Ynnd27aIOs27dZiuKIVgMpCDivxHRGR/99brWxfBs31h2IVx2ZanC3ksLVDtXXixinDFQ3tfs4OmuUq81jwUGiSw5R5l1q5fPOKrtfSImaxtJmTlNqgKYrNqfSH83yfUhzaXO60FQCh74p6uMRsKh8XlYcnZEQ+V7EulU4lH9kyLL1kaq2HyLdcnR4OrbCoZeHrpoqV8unqNFzPYYzrc1vU5DxZeSjVmW9+Zqm0A+3e5Bh0eT+Ct/fOkIg/58cbbyVn0qZ2BO+FEK1cSND+m0fX4M/JPwa5480nulgPCITcm8V7sgGUAHpdDsZw8/QVil10P0Oem6G4cXqyY2GAhaCXP7UaE5rd+3QRmOyPzKDbhkZxwhQ/c6JAVh0+C0bcvVBz/DYP6PY2RFunUzjSiY8FPMv/7lGcFLI8LsNQMlpNTRjHhJnskzsEnXu79fPa0gBHhd5VxQWc+3p3N1DT4MfuRPANLmIX99ipAPRs9MuV8HiedRByvXDpTT0YIFEu9fFb353SMKqEKkLa2pFPy4VL40wnXrFEzpYrrBDZiIUvVg7edvccwFg3lodKkcG3PrFpRAWu63oL2SkHEJzg1jGj7AJzO8/EqlD/F1Z3e3eDaOI2HTWV9c2Wuxa258Wmo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB1953.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(346002)(396003)(376002)(39860400002)(451199015)(53546011)(110136005)(186003)(86362001)(54906003)(7416002)(6512007)(31696002)(478600001)(122000001)(921005)(26005)(6636002)(41300700001)(36756003)(5660300002)(2616005)(6486002)(8936002)(316002)(71200400001)(38070700005)(6506007)(76116006)(91956017)(8676002)(64756008)(66476007)(66556008)(66446008)(4326008)(38100700002)(66946007)(31686004)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K3hVSDJvV3RScm9nazJiaEU2RGJnRm1UME1RbWhWRVFxaDN1VFVmTnNOZjVF?=
 =?utf-8?B?NnJFTm5US2xSOEROR1pLQ21uSU1YNS9jSkZES0xvWEhqRUdkZXorWEl2UXNP?=
 =?utf-8?B?Ny9PdFlkK1N6ZWZpSjZMaUc5Zm5JeEtRS0JQV2xQTEFMM1p5L0p6Q05KcGFN?=
 =?utf-8?B?UFROMnRCem1QeVZIZDk2bHBGQnFYOFQ5SC9jUG93NVkyUVg0QWRBV1dTeE1k?=
 =?utf-8?B?VXRhemVOK3lTMmNRMHpwSE5TVmJuT3BTS2hueWtZcURzSGQ3YjlmYWU1RkJa?=
 =?utf-8?B?MnhCYXhCV2VsSnpPczA1NGpTcFNmV04yejJDUytTSnhtTmVIYTIvd1FLd1JE?=
 =?utf-8?B?RkxWUk1iREk5empPVU1IZFpuWHZYUitIcmc2WDRsSHlSSldXT01mci94Qklm?=
 =?utf-8?B?bFBaTFljN2lCWUZMODVXSHl4dzN4M1FiODJKSHh0LzRYYzZqR0NkajBzWC82?=
 =?utf-8?B?NnhwbHNPUDRPRll5clVkUlFNM243dHZ0SjAxbCt0Y0JxbTJLZUY1WW16UEc0?=
 =?utf-8?B?V0ZtekZaWXRsOFdCS1IxVjVWOWQ1VVJCSVhxS2FrZDhhdTdFWk8zN3g2Yjgx?=
 =?utf-8?B?L0VNOFUzY1ZIQ2dNc1dDL2NmQTFGYzByc0xUK2J1VERXZXpoTmQxT0NtM09W?=
 =?utf-8?B?VEhUdFlwMkV1YnBLREl5V0ZySVNrTk83dTR5WGJKNnFCNDRRNG82SWNISG96?=
 =?utf-8?B?UUNIQ09sYVQwRG5HRWQ2c2ZIQWdsYndJRzFvRk1Bd2MxUGZPZmt0WDk0c0xE?=
 =?utf-8?B?TkVnclZ1V3pNRDNycXRFR0NKVWJBRTdLVklWQ2VvSFNQTUtRbmliRmZZUDYv?=
 =?utf-8?B?RGUyRFdaSkIwUzVSbjBFWlpaVWMzZ2M1Ui9wdlZib2hLajhJTldNdzIzQ0Iy?=
 =?utf-8?B?bFJhbVpuNlV3bzkyR3R2WUgrSEVNM1RoK1QxY0oyRUI5d2F3OTZNd1pHSDBh?=
 =?utf-8?B?dkUyclNLYkxqRXMzNEpNVStkUldiZFZiY2FUaHZldzdEU295TEEvMDcycjNZ?=
 =?utf-8?B?T2EwZmpFNVZ6SURNNjFkVjRrZEFBZ1RGNEZqVGI2a3cxQUR2UERZN3dNWEVO?=
 =?utf-8?B?aUJseEdzc1kzU3ZsTWRxUXZnZGMwRUVYcUJNOVNvOWRWbk9pN3AxdFRsbHVY?=
 =?utf-8?B?TmpIQ0JiMVoxVHM2S2M2WklqOERudTVTWUJqU0d3UnFaU3h2TkdDdWFXWjNK?=
 =?utf-8?B?Y1VnS1VTaFhIRThVTThMYmg2cjR1ZHVGNUU1TkorZnhRVlEvc084aElhaEFy?=
 =?utf-8?B?bU53dm5BMTV3b0VJRkpnRlIvVFM0RDJVR0JNZDVacUlsSDl4aURGQzc0akhs?=
 =?utf-8?B?cU9QNE9xcWIwTDl1T0FHbmZibFd1RXhMVDZ5VHFvTmxzM1RBaU80a0RSR2ha?=
 =?utf-8?B?Tm9mSTBYNXBIZmZGVHdEYzRxV2V1TEx5MmRTL0RXTG1Hcm1KSzJDYWFMTGVp?=
 =?utf-8?B?bHNkZ1FRZ01nTmxrdEcyNXRxS1BpR1ZxRUhWS0t2SWgzWjYwY3NHUGE0Tm5t?=
 =?utf-8?B?ZkRiblZaQklEWldVVW9YMmV1V1Azd1p5YXMxbm84Y3UwTURHcVc0MDJ6d1Zy?=
 =?utf-8?B?V3cwVDhVLytlWUF6VE1ZNjJHcWtzWTBPeXpsdzdtRm1zc3FjN0N1Z3ZBSzJO?=
 =?utf-8?B?NEZ2VnpZbXR5RGtHZkF2RlJMNFAydEpjYldsVkozR1BHQ2ZkUEpLVkp4Qlpo?=
 =?utf-8?B?Sm0vY21vWFdaeFMzUU5NaC9XZTFaVDg0NzRqcjk5UTBpSkcyVmU0b25nU2kz?=
 =?utf-8?B?aUNvTUNpazFjTzJBYjcyN2JrMk0rV0FFR3pQOTR2ZVRwcWorc1UxM29zenRK?=
 =?utf-8?B?R3pWckQzYlF0L0lSeTVGYXJzVzNLVGpzbVpJSE81dEtjK1dFL3ZwRk0razBh?=
 =?utf-8?B?WUR3OUVJSkVCYUpTRmk1alJhWFFOSjJBdEt2dytwT1J3Ync0VWd0YTk3b0tk?=
 =?utf-8?B?cCtXQUR2alpONkVjTUZaQ1JYUEpOUWlMT0l6VE56Kzk3QzAxTHBodzNIdUtk?=
 =?utf-8?B?OUFJcVRTRFBhZjdwUE0zMzBCVk02NWtmelNlV2IveTBieEpyMEUzeEhTSDNp?=
 =?utf-8?B?ckxEenVJaGJwcHBGcnIycDEzSytBMkVmTFBZS2xIRzZjUHl5NGVXcnBueVVV?=
 =?utf-8?B?cit2bTAxRGV6RVNZdmQrY3k3cHRwU3VOVVFqOXd1OHdtMnhwZFl2WWFNdFFG?=
 =?utf-8?B?eWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D703837A9BC2FE47A410851FC5A62299@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB1953.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96503d91-1d1a-4039-ea3e-08da96edf8fe
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Sep 2022 07:43:25.5061
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7kcOV6vyhwkAwzOtVrjT9qeugOqyxFNtCCT0kU+TH1pvsugvHulrUBO7iH9VrRl9ZjCazN/NNlZFDwlUwOyvSbPl8L0DQCmlSJoEPXhf4mE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6761
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTQuMDkuMjAyMiAxNTozMywgUmFkaGV5IFNoeWFtIFBhbmRleSB3cm90ZToNCj4gRVhURVJO
QUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5
b3Uga25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo+IA0KPiBBZGQgc3VwcG9ydCBmb3IgdGhlIGR5
bmFtaWMgY29uZmlndXJhdGlvbiB3aGljaCB0YWtlcyBjYXJlIG9mDQo+IGNvbmZpZ3VyaW5nIHRo
ZSBHRU0gc2VjdXJlIHNwYWNlIGNvbmZpZ3VyYXRpb24gcmVnaXN0ZXJzDQo+IHVzaW5nIEVFTUkg
QVBJcy4NCj4gSGlnaCBsZXZlbCBzZXF1ZW5jZSBpcyB0bzoNCj4gLSBDaGVjayBmb3IgdGhlIFBN
IGR5bmFtaWMgY29uZmlndXJhdGlvbiBzdXBwb3J0LCBpZiBubyBlcnJvciBwcm9jZWVkIHdpdGgN
Cj4gICBHRU0gZHluYW1pYyBjb25maWd1cmF0aW9ucyhuZXh0IHN0ZXBzKSBvdGhlcndpc2Ugc2tp
cCB0aGUgZHluYW1pYw0KPiAgIGNvbmZpZ3VyYXRpb24uDQo+IC0gQ29uZmlndXJlIEdFTSBGaXhl
ZCBjb25maWd1cmF0aW9ucy4NCj4gLSBDb25maWd1cmUgR0VNX0NMS19DVFJMIChnZW1YX3NnbWlp
X21vZGUpLg0KPiAtIFRyaWdnZXIgR0VNIHJlc2V0Lg0KPiANCj4gU2lnbmVkLW9mZi1ieTogUmFk
aGV5IFNoeWFtIFBhbmRleSA8cmFkaGV5LnNoeWFtLnBhbmRleUBhbWQuY29tPg0KPiBSZXZpZXdl
ZC1ieTogQW5kcmV3IEx1bm4gPGFuZHJld0BsdW5uLmNoPg0KPiBUZXN0ZWQtYnk6IENvbm9yIERv
b2xleSA8Y29ub3IuZG9vbGV5QG1pY3JvY2hpcC5jb20+IChmb3IgTVBGUykNCg0KUmV2aWV3ZWQt
Ynk6IENsYXVkaXUgQmV6bmVhIDxjbGF1ZGl1LmJlem5lYUBtaWNyb2NoaXAuY29tPg0KDQoNCj4g
LS0tDQo+IENoYW5nZXMgZm9yIHYzOg0KPiAtIEludHJvZHVjZSBnb3RvIGZvciBjb21tb24gcGh5
X2V4aXQgcmV0dXJuIHBhdGguDQo+IC0gQ2hhbmdlIHJldHVybiBjaGVjayB0byBpZihyZXQpIGZv
ciBvZl9wcm9wZXJ0eV9yZWFkX3UzMl9hcnJheQ0KPiAgIGFuZCB6eW5xbXBfcG1fc2V0X2dlbV9j
b25maWcgQVBJcy4NCj4gDQo+IENoYW5nZXMgZm9yIHYyOg0KPiAtIEFkZCBwaHlfZXhpdCgpIGlu
IGVycm9yIHJldHVybiBwYXRocy4NCj4gLS0tDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRl
bmNlL21hY2JfbWFpbi5jIHwgMjIgKysrKysrKysrKysrKysrKysrKysrKw0KPiAgMSBmaWxlIGNo
YW5nZWQsIDIyIGluc2VydGlvbnMoKykNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9l
dGhlcm5ldC9jYWRlbmNlL21hY2JfbWFpbi5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvY2FkZW5j
ZS9tYWNiX21haW4uYw0KPiBpbmRleCA2NmM3ZDA4ZDM3NmEuLjQ3NjljOGEwYzczYSAxMDA2NDQN
Cj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvY2FkZW5jZS9tYWNiX21haW4uYw0KPiArKysg
Yi9kcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNlL21hY2JfbWFpbi5jDQo+IEBAIC0zOCw2ICsz
OCw3IEBADQo+ICAjaW5jbHVkZSA8bGludXgvcG1fcnVudGltZS5oPg0KPiAgI2luY2x1ZGUgPGxp
bnV4L3B0cF9jbGFzc2lmeS5oPg0KPiAgI2luY2x1ZGUgPGxpbnV4L3Jlc2V0Lmg+DQo+ICsjaW5j
bHVkZSA8bGludXgvZmlybXdhcmUveGxueC16eW5xbXAuaD4NCj4gICNpbmNsdWRlICJtYWNiLmgi
DQo+IA0KPiAgLyogVGhpcyBzdHJ1Y3R1cmUgaXMgb25seSB1c2VkIGZvciBNQUNCIG9uIFNpRml2
ZSBGVTU0MCBkZXZpY2VzICovDQo+IEBAIC00NjIxLDYgKzQ2MjIsMjUgQEAgc3RhdGljIGludCBp
bml0X3Jlc2V0X29wdGlvbmFsKHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYpDQo+ICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICJmYWlsZWQgdG8gaW5pdCBT
R01JSSBQSFlcbiIpOw0KPiAgICAgICAgIH0NCj4gDQo+ICsgICAgICAgcmV0ID0genlucW1wX3Bt
X2lzX2Z1bmN0aW9uX3N1cHBvcnRlZChQTV9JT0NUTCwgSU9DVExfU0VUX0dFTV9DT05GSUcpOw0K
PiArICAgICAgIGlmICghcmV0KSB7DQo+ICsgICAgICAgICAgICAgICB1MzIgcG1faW5mb1syXTsN
Cj4gKw0KPiArICAgICAgICAgICAgICAgcmV0ID0gb2ZfcHJvcGVydHlfcmVhZF91MzJfYXJyYXko
cGRldi0+ZGV2Lm9mX25vZGUsICJwb3dlci1kb21haW5zIiwNCj4gKyAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHBtX2luZm8sIEFSUkFZX1NJWkUocG1faW5m
bykpOw0KPiArICAgICAgICAgICAgICAgaWYgKHJldCkgew0KPiArICAgICAgICAgICAgICAgICAg
ICAgICBkZXZfZXJyKCZwZGV2LT5kZXYsICJGYWlsZWQgdG8gcmVhZCBwb3dlciBtYW5hZ2VtZW50
IGluZm9ybWF0aW9uXG4iKTsNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgZ290byBlcnJfb3V0
X3BoeV9leGl0Ow0KPiArICAgICAgICAgICAgICAgfQ0KPiArICAgICAgICAgICAgICAgcmV0ID0g
enlucW1wX3BtX3NldF9nZW1fY29uZmlnKHBtX2luZm9bMV0sIEdFTV9DT05GSUdfRklYRUQsIDAp
Ow0KPiArICAgICAgICAgICAgICAgaWYgKHJldCkNCj4gKyAgICAgICAgICAgICAgICAgICAgICAg
Z290byBlcnJfb3V0X3BoeV9leGl0Ow0KPiArDQo+ICsgICAgICAgICAgICAgICByZXQgPSB6eW5x
bXBfcG1fc2V0X2dlbV9jb25maWcocG1faW5mb1sxXSwgR0VNX0NPTkZJR19TR01JSV9NT0RFLCAx
KTsNCj4gKyAgICAgICAgICAgICAgIGlmIChyZXQpDQo+ICsgICAgICAgICAgICAgICAgICAgICAg
IGdvdG8gZXJyX291dF9waHlfZXhpdDsNCj4gKyAgICAgICB9DQo+ICsNCj4gICAgICAgICAvKiBG
dWxseSByZXNldCBjb250cm9sbGVyIGF0IGhhcmR3YXJlIGxldmVsIGlmIG1hcHBlZCBpbiBkZXZp
Y2UgdHJlZSAqLw0KPiAgICAgICAgIHJldCA9IGRldmljZV9yZXNldF9vcHRpb25hbCgmcGRldi0+
ZGV2KTsNCj4gICAgICAgICBpZiAocmV0KSB7DQo+IEBAIC00NjI5LDYgKzQ2NDksOCBAQCBzdGF0
aWMgaW50IGluaXRfcmVzZXRfb3B0aW9uYWwoc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldikN
Cj4gICAgICAgICB9DQo+IA0KPiAgICAgICAgIHJldCA9IG1hY2JfaW5pdChwZGV2KTsNCj4gKw0K
PiArZXJyX291dF9waHlfZXhpdDoNCj4gICAgICAgICBpZiAocmV0KQ0KPiAgICAgICAgICAgICAg
ICAgcGh5X2V4aXQoYnAtPnNnbWlpX3BoeSk7DQo+IA0KPiAtLQ0KPiAyLjI1LjENCj4gDQoNCg==
