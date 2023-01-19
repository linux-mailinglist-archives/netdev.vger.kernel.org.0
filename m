Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBE49673701
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 12:35:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230431AbjASLfk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 06:35:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230403AbjASLei (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 06:34:38 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEAD337F25;
        Thu, 19 Jan 2023 03:34:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1674128057; x=1705664057;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=BfMXFZJKPBvslkCghCQ7jgahvcuyY9Il0Jlch63hu3Q=;
  b=OqXQObAxDGxUj1iIq6aDP2HE0IrSx+MmEwtF9LQr1X1G9igsLn+yPIMs
   L6UTugplRq4XGqANxqWPb20LdYaso82j3w8YqbRmxDmj9kKKphMpTwZ7M
   GL5YLhpgGBlx7TjctJmiTZXe+IY1hm3wvly2S7rtpJ6AIhPlMAgdCOc7N
   F9m9v2vFXwNEZrT766BOIg1Tu3x41SBuH4a2Rzu61qBQKYHV7OJMOLuc5
   wrvBHQLggSM8RdSu8lbfZV5/vwEpq2a/bWRdwdv4kwqM+vPG9n1U8J7Di
   Zw0OVxfQ5ykrTd+HxEgMa67JHXkmS2MegxpL8dMXTV7sZKySvWWYJkcKl
   w==;
X-IronPort-AV: E=Sophos;i="5.97,229,1669100400"; 
   d="scan'208";a="133098210"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 19 Jan 2023 04:34:02 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 19 Jan 2023 04:34:01 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 19 Jan 2023 04:34:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TO/E+UWbbiQh37TpipSBZq/HZjV45xvlpa41qXpqH7T8J/ccmiMWI6cY+JquJoXsaSh6uEiuygjMKTyC+JDwufCHY7e7oPbRr+ssigORG6fnSInaYh4trnFRgPLHdSH5nO9+57PZkHg1xd+9YBPm5jhh32Yr93u1hs27CEr9pd497hWnJRshZbOVzumaGKcscON4VEGMSuAsyxTHbSqd7rtnNRkUOMKQ5jagL5XHvEi2c4o8ZDtPkRGkvNn2tZ/drN55Se8Y7JCxNYGsUHTWrO9TcziSogAWp8Jn9Km1q2ylvzt+BGhJcXbicpkCKmScuCn12OL1O7sOqJvaTeTbkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BfMXFZJKPBvslkCghCQ7jgahvcuyY9Il0Jlch63hu3Q=;
 b=hPHupqzGPYE+KTUcMpDgR0FHgPHhWYjRCTFnOWtY4SUe9+f2s2vHSN5wjou0RcBSzhF63TtBLYgQNyTpKrCuYT1xi1UxaFFNCWJwzJNb9m0zNPsmR729dtg/TwMJf0LHmaS0p9WR4X+gStTFjYOe7TaS9w0elVO0wq0kVXwCtoIF0tLGbw+nEzoTgEaYshcqstTjeb/uAo+RTHNLImjzrm7DKlLXYz52PaO4C/IxIRqQUKR4ChyyqNkfchRAlC5eGxo2o2bcU7QHWcErgkX8pPM/aMj0ud+m3pJrbrZh5lPtxSvdYKZKZ/jiFAvvyDQ4Wb4CiCa0TE8Y+ib2DlPfsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BfMXFZJKPBvslkCghCQ7jgahvcuyY9Il0Jlch63hu3Q=;
 b=bi8F32dE4RqgBV3gytUZDNRqFW0M2IgsMjCIjHWEcGqGO4Jm8JghVry8U0SttVW+nbb2FWoMrYm41auYF+TrpDi4q9TrHQz80oXYBKADZQif/Lciek96qd0Ze83ycheK3CUPSLYt4YY/LDJiradf3Gxrx7yjqdulyiISbslWDbY=
Received: from MN0PR11MB6088.namprd11.prod.outlook.com (2603:10b6:208:3cc::9)
 by BN9PR11MB5484.namprd11.prod.outlook.com (2603:10b6:408:105::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.26; Thu, 19 Jan
 2023 11:34:00 +0000
Received: from MN0PR11MB6088.namprd11.prod.outlook.com
 ([fe80::8ac6:8219:4489:7891]) by MN0PR11MB6088.namprd11.prod.outlook.com
 ([fe80::8ac6:8219:4489:7891%8]) with mapi id 15.20.6002.025; Thu, 19 Jan 2023
 11:34:00 +0000
From:   <Rakesh.Sankaranarayanan@microchip.com>
To:     <olteanv@gmail.com>, <andrew@lunn.ch>
CC:     <davem@davemloft.net>, <pabeni@redhat.com>, <hkallweit1@gmail.com>,
        <Arun.Ramadoss@microchip.com>, <Woojung.Huh@microchip.com>,
        <linux-kernel@vger.kernel.org>, <linux@armlinux.org.uk>,
        <f.fainelli@gmail.com>, <kuba@kernel.org>, <edumazet@google.com>,
        <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net 2/2] net: dsa: microchip: lan937x: run phy
 initialization during each link update
Thread-Topic: [PATCH net 2/2] net: dsa: microchip: lan937x: run phy
 initialization during each link update
Thread-Index: AQHZKZH7WZopBqu86kymmreIhwsr3q6hn/+8gAQA9AA=
Date:   Thu, 19 Jan 2023 11:34:00 +0000
Message-ID: <7d72bc330d0ce9e57cc862bec39388b7def8782a.camel@microchip.com>
References: <20230116100500.614444-1-rakesh.sankaranarayanan@microchip.com>
         <20230116100500.614444-1-rakesh.sankaranarayanan@microchip.com>
         <20230116100500.614444-3-rakesh.sankaranarayanan@microchip.com>
         <20230116100500.614444-3-rakesh.sankaranarayanan@microchip.com>
         <20230116222602.oswnt4ecoucpb2km@skbuf>
In-Reply-To: <20230116222602.oswnt4ecoucpb2km@skbuf>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB6088:EE_|BN9PR11MB5484:EE_
x-ms-office365-filtering-correlation-id: 5ef68658-7785-4cd1-c640-08dafa110f1a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GmSmgpok8O+j4fGLW78MhxUZ3DMXBFTq5QbRIoCjdchficUCCfaN6l26EMFF2ql9ruQ/EPS8np3Vxada832f79nOoixde/YAnLFRdB/94jdUblfd5/QHOjq53YVZrPDDJSTGr05UQLZ7vy2iecfLjjMFd44tRkOyO9qc5H8pILhkPGWIwBpCIK0WrADiDand5dd6rW26Q0fXuKq/oyrjDeQGBPIpUwOXKSIzvH0KpK493WlZ+Z7kQeVf1kEjOWsxAh/UXL1iiwiIvjK2T7alTM+nCv9PFygkxyHVi+gB1jYEpS15C7dKlkya8hjLeq+BFtx/OcG516f734k5augwBVIHIEjpjyp/qmwWJh5B/SCGupMmMa9xNsCCPHQ8+ZfOA9KABzxY9DbrdtX7RXv1+p7G+QPzNMXPlus/XXlfsnEYmFylF2xXeD3IMS9bYzWe44JLaoXvrsaPQuq0kouCmQwY7eDXSix2PqeWI3xYqQqtrzjIhfsenJgbJZ3FYzourqX9/YkETv6i5KEMP5lkCEaO0fhvlFEO1z9yVyLPiG1M4KTD7N5bmg6Vc5p84IzrsYHy2eZWuprBWAtp3LDmEUKRPnBolznhYVyVqUUIiuOtkhAekBWCUnC/pzEEgq6/YlxYxeA/Nvnzz9I3AvAezVP70mz0fYX4kKbJ2UvYx1VNbjPIBwnZvk744cvmfrvL
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB6088.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39860400002)(396003)(346002)(366004)(136003)(451199015)(316002)(54906003)(110136005)(15650500001)(122000001)(2616005)(7416002)(4326008)(5660300002)(38100700002)(8936002)(41300700001)(186003)(6512007)(36756003)(26005)(83380400001)(64756008)(76116006)(66946007)(66556008)(66476007)(66446008)(8676002)(91956017)(38070700005)(86362001)(2906002)(6486002)(6506007)(478600001)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aHo0aDcwSGd0YmppQmtVazJoWnpxTzdVUGxFak1Jd21jMCtkK3JTOHdkbGd6?=
 =?utf-8?B?UnZSczcvVS9CMmdvRXZxd3RZb0pRWjRzVC9YcnF0VHNNYzVmNG5RTm80Unlh?=
 =?utf-8?B?d1NMcWJycUttWWtDMFo4Z2kyVnZHaWNDL092NHBTTjhuQ1BMaXpVeW02Nzk5?=
 =?utf-8?B?ZEt2YisrbnJ0RFl5cUZyVFdZUTd3T243aGxDYWRISjZTbk9jbzR3OE1yOUJm?=
 =?utf-8?B?Q3dEbVVOL21qd2xxZWkwek83TitJb1dPdnpFZFRqS050NmNOMmo4SnBVb29R?=
 =?utf-8?B?Q0ZHMmtXbGI3YWh6RkRNOHpNYVBiUlBhcEF5bTZIZ1lBMFd4K2tlZFdYcGRF?=
 =?utf-8?B?d3p5TEJncUl2WFN2ZGhOMXZFZmdRcDhheEUzQ1Brd2ZCQmhHelV5SnlSTk55?=
 =?utf-8?B?ZmpRRmh3bzBaOXNzZVVKNm9XSEwrL2Q4WkdMWUdMZklFeHoxM0tJZlZON3FV?=
 =?utf-8?B?OHlIelc1dkpxeGRZS1pKTmdscVQzS1ViM0Zxa3hNRk9GZ0tLSkNtWUpyTTE3?=
 =?utf-8?B?UEhEbk5FOFV0VDRpOEdRWTZhWVNpU1pEM3RZYW1HbTFRZld4VG5kMytzMi9k?=
 =?utf-8?B?QTJUOERZMnNVQmtjSDNNR3NtV0JHQ2gyMllUby9hV2lqY3U5N1NabXNMVWM4?=
 =?utf-8?B?Q2V4NDN0SHpZdk4zN1ZSZ2RLdFc5MTZibSs3cnI4My9GUzFBOHI1OTU1Ri83?=
 =?utf-8?B?U0xKYjQxSy9WTWVOTmNCbWJQdkZCblRCSWJRVENsOFp1ZXJPdGhoVHlaZkl3?=
 =?utf-8?B?MXFGNW12NStzMkxGc204Uy9KZnh5WlBXVFhsempjRmJqOURrRkdsd3BKeHJ6?=
 =?utf-8?B?YzcxbnM3ZzI0OFRqT2h5cERNZ0pTRmZEVmdqclJBQjFXSGFSbUt5Uk81N3lF?=
 =?utf-8?B?SnpXcDdpcldhazk2K3NLcUR5cml5WkNpKzRUUlo5SDRvK2ZVdnliRnhTRnBI?=
 =?utf-8?B?T0JEWXpzb0thVUpFWk42d3B1UFRheEFiWVU5Z2tJNEVKL20vZHpGVFgyay9F?=
 =?utf-8?B?MDFadjd2UXNOdVU5Z2M1NlVWZzRLVm80SkQ3VjFDMTJQQjVYUUx3Q056U1Bz?=
 =?utf-8?B?cUt0d1hZS29xV2Y2UzlFcllaMXI4OTJOVnBuMUI5Y2YyN25rNDVtaG93ZVZX?=
 =?utf-8?B?NVFFZHJNOUpLcXI1ZlJibkczaDZicXFBdThqbXFXSHFPNTNmOVB5b0Q3aGdq?=
 =?utf-8?B?TndyVzZOZU40anRDSFU3dXRtVis1dFRBL0RuNGdEemxVb0dQcHpVY3VOaG5S?=
 =?utf-8?B?THJlVlUzMVgwM29NOXh6Y2JxaXM2OCtGbEYzeEwvOCthNlRnSUp1bytHQmxV?=
 =?utf-8?B?aXJBa0N4aWNIWHdrVzdxTWZCT2tZZmNtK0JIREY2L0xZWnEyd2Z3QXFldSsx?=
 =?utf-8?B?RXI2aFVHRzI5WGtoY3JGMlNOQm9uSEdDWGk2SmJxV3huLzU3NkVUcFBYeHFQ?=
 =?utf-8?B?NDBwRG42cUpwMGNjb3gvNnZ3Y3VsWlFnbDlsVVU1Y0xGaURNNmhCY2s3cFBT?=
 =?utf-8?B?MGxHM2pPZVRoTXEydDVIT2M1am92Z1RUQ0c0dTNGemFQTzREdHB0d3Bob0Vo?=
 =?utf-8?B?VzNtWDlLSzhxUFcxV2dVWXNqQUcxcyttcFFoRGZnRlN1TFhtdVo1a0ZkZGZO?=
 =?utf-8?B?N2JhaGVIa3A5dFRUUU9pM3B6YWFCb3pwTlczYmVQeFk4Y0JBTDhrL2k4OWg4?=
 =?utf-8?B?dm1SaktLWm01aFQ1VGpEYW02UjdzejA3TDkraGkvazlSVmNOT1c1NEQzRXlx?=
 =?utf-8?B?ZVJsWEdTK3VoeER3Y1FXUlltQWVDZUplQ3NCVkIwc052bDhWdG1uZ0xFMkow?=
 =?utf-8?B?bi9xeXFmcXV4cmdIZ1k3UnVERnRqTCtFTDk3Z0V2ZHNaQnpsZkl4VVYyYjdU?=
 =?utf-8?B?QmRWK0JMb2JqcEtWZ2NUQWkvSlZmblZOS3pDb0svWkR0Sk05VWk1SnhNM1ZP?=
 =?utf-8?B?MkV4bWdYSFRJNEJHOW1CQ0VOQml4WU93ZXJQS0xOemI0TGZaa3M1Rkx4Q2Jt?=
 =?utf-8?B?SjNaWnN1V3NhTU9UblBFNjU5V1diNEN2WWloMHRGVDBObVJZcVQycWoxd25V?=
 =?utf-8?B?c1RxdWZqS3p1dHJIT1dwSXp6Si9ZY2VkeDBSSFlvRzI2Ky81clRsdjJVNkdF?=
 =?utf-8?B?SE9kTjhsbVZJWklhc1hwWDZTVDR3N21ObUpiRVpiTnA5Sm1GMVFGWU03ZS9v?=
 =?utf-8?Q?8LnSDi6oh14xeT/+oaLsS/xiHFsowlPjOTZr3OtCkqz9?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3C49197932AA6041A9AFECD3E4F0658D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB6088.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ef68658-7785-4cd1-c640-08dafa110f1a
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2023 11:34:00.0991
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Vzk+oBHzl7jyHxevkt56zVmBmCsXE9Lc9hZX4Rk6oG1bFd/AY2LnGkNGTFmXZawb78WbQrvZPHgxtUySv0ZSaP2GueagXueCGM9WYUf+7IvYYFv3gNtSszfjF7zKU8x+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5484
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgVmxhZGltaXIsDQpUaGFua3MgZm9yIHRoZSBjb21tZW50cy4NCg0KPiAxLiBEb24ndCBwcmVm
aXggYSBwYXRjaCB3aXRoICJuZXQ6IGRzYTogbWljcm9jaGlwOiAiIHVubGVzcyBpdA0KPiB0b3Vj
aGVzDQo+IMKgwqAgdGhlIGRyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAvIGZvbGRlci4NCj4gDQo+
IDIuIERvbid0IG1ha2UgdW5yZWxhdGVkIHBhdGNoZXMgb24gZGlmZmVyZW50IGRyaXZlcnMgcGFy
dCBvZiB0aGUgc2FtZQ0KPiDCoMKgIHBhdGNoIHNldC4NCj4gDQpJIHdpbGwgdXBkYXRlIHRoZSBw
YXRjaCBpbiBuZXh0IHJldmlzaW9uLg0KDQo+IDMuIEFGQUlVLCB0aGlzIGlzIHRoZSBzZWNvbmQg
Zml4dXAgb2YgYSBmZWF0dXJlIHdoaWNoIG5ldmVyIHdvcmtlZA0KPiB3ZWxsDQo+IMKgwqAgKGNo
YW5naW5nIG1hc3Rlci9zbGF2ZSBzZXR0aW5nIHRocm91Z2ggZXRodG9vbCkuIE5vdCBzdXJlIGV4
YWN0bHkNCj4gwqDCoCB3aGF0IGFyZSB0aGUgcnVsZXMsIGJ1dCBhdCBzb21lIHBvaW50LCBtYWlu
dGFpbmVycyBtaWdodCBzYXkNCj4gwqDCoCAiaGV5LCBsZXQgZ28sIHRoaXMgbmV2ZXIgd29ya2Vk
LCBqdXN0IHNlbmQgeW91ciBmaXhlcyB0byBuZXQtDQo+IG5leHQiLg0KPiDCoMKgIEkgbWVhbjog
KDEpIGZpeGVzIG9mIGZpeGVzIG9mIHNtdGggdGhhdCBuZXZlciB3b3JrZWQgY2FuJ3QgYmUgc2Vu
dA0KPiBhZA0KPiDCoMKgIGluZmluaXR1bSwgZXNwZWNpYWxseSBpZiBub3Qgc21hbGwgYW5kICgy
KSB0aGVyZSBuZWVkcyB0byBiZSBzb21lDQo+IMKgwqAgaW5jZW50aXZlIHRvIHN1Ym1pdCBjb2Rl
IHRoYXQgYWN0dWFsbHkgd29ya3MgYW5kIHdhcyB0ZXN0ZWQsDQo+IHJhdGhlcg0KPiDCoMKgIHRo
YW4gYSBwbGFjZWhvbGRlciB3aGljaCBjYW4gYmUgZml4ZWQgdXAgbGF0ZXIsIHJpZ2h0PyBJbiB0
aGlzDQo+IGNhc2UsDQo+IMKgwqAgSSdtIG5vdCBzdXJlLCB0aGlzIHNlZW1zIGJvcmRlcmxpbmUg
bmV0LW5leHQuIExldCdzIHNlZSB3aGF0IHRoZQ0KPiBQSFkNCj4gwqDCoCBsaWJyYXJ5IG1haW50
YWluZXJzIHRoaW5rLg0KPiANCg0KVGhhbmtzIGZvciBwb2ludGluZyB0aGlzIG91dC4gRG8geW91
IHRoaW5rIHN1Ym1pdHRpbmcgdGhpcyBwYXRjaCBpbg0KbmV0LW5leHQgaXMgdGhlIHJpZ2h0IHdh
eT8NCg0KQGFuZHJldywNCkRvIHlvdSBoYXZlIGFueSB0aG91Z2h0cyBvbiB0aGlzPw0KDQpUaGFu
a3MsDQpSYWtlc2ggUy4NCg==
