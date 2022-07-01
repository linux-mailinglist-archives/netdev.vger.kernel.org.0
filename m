Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E94AF562AFC
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 07:45:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234131AbiGAFpB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 01:45:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230464AbiGAFpA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 01:45:00 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6152A65D43;
        Thu, 30 Jun 2022 22:44:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1656654299; x=1688190299;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=fm9UK0gAzACKhTsjLsUZ1UzjtgTA3sJ7WUcg6UhMXCI=;
  b=Le7zgkqfNvN5rn73wFOm3NQvaa4IH2T6rSi2E1fZfJzHnjO+GSVzDpEU
   M3ay7YXMJ8gJC8StCAE6TOu762ITLnbXN9TV7mGbQeMxwY0UepeR6QGpJ
   1YTIYarJfw4YZdFgzIK1IzD2/LBgJ0/1XTVtzEy37RlIF7Pa3KY+dszJv
   fStCoeVuIJ4MHPj3VHYDIgFWQMQ6TbWl1HuLlfwp0AYBFwc9NisYcywRj
   RJoz7fa0ao7xxbJxoVcJ9nc+hU7QDYJenWNyFTKrHA/X6wMtHUcYny+L5
   My8YEIa7c3ZycW2qO4o3MGlFZq0l5k8FzXQsI4PI9doRjKQ8H5wXVHUhH
   w==;
X-IronPort-AV: E=Sophos;i="5.92,236,1650956400"; 
   d="scan'208";a="180315462"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Jun 2022 22:44:58 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 30 Jun 2022 22:44:57 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Thu, 30 Jun 2022 22:44:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UMFwWt0Vc61zNlke+vv7R+pfEiyqzrWi4YKBE6di4ySKDKb50psq/Q+V0KDxAYY9xXv6UFXl44dq0M1O87thE4mMjkYijGY9RvMyCEjr7gRBxMVy12wdtrntfOUC5Z2DSFomAsLv8WpI0t0KFzzNNDDlCvztHiEj2BTAFYYSvT4E4VOacLe8yMgmwO/Ayf2aQ7yJ7SbjJ2ERr4Lols+/kB+PuluY86xV0VPU881vr1Fv3J9qfI8IJ8R9/Q9yLqeXrp/DVDnL6qnAsuYW4Rqm7z0coZM9rSytKKrrRc7OThRMaEXY0I+1SLQt8QVExxGIFQo7cSNf9FjTfJQ1u18YJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fm9UK0gAzACKhTsjLsUZ1UzjtgTA3sJ7WUcg6UhMXCI=;
 b=bwYZXrul3ypMOKjip4P0qXxhGxkFrG4QFWhOahvNU20u2IcZ5BdRo5tE+hcXqHgZv3W9hAH8bvw97A5J68IxwnyrNRjCzZnnu8/8iTS47XHhHfieCg0oJf30JmjRtKaRErt9VWkBpjUPL8Enlwf4hH6TKr3JKFkIvGwJaseXcLdXXHNXW50Teij66nbEcyBWDhX2fOmAvFr4lppCwfWX1lkA168HrpqviUos2wYmyL+4cA5Wr+NDt6EVZoq72JKlYGJJFj75L0/MVl3nMqI3UudUivuKv3S8HkY8Qxkf9ZqOYpPmijpsJS/4Mr5zKUYkJXJF0zr8LxahFkK53zMDgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fm9UK0gAzACKhTsjLsUZ1UzjtgTA3sJ7WUcg6UhMXCI=;
 b=ByG3TMmqzMIMlRNWg9/NKZSb/Tii6yxYqbbkGYWK1V92WSrRM3ycavowrfaRsO+yF7mzD1TLyrGx0F47sD16F84WwiK7XzI49UIcjMEEnhluxC3OFqLkC/2v84veNnOFZKMgbSz8ea4Wyg2fRiAUV575JUnUaPkLNqrwg/LifCE=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 MW5PR11MB5763.namprd11.prod.outlook.com (2603:10b6:303:19a::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5395.14; Fri, 1 Jul 2022 05:44:52 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::a4d9:eecb:f93e:7df0]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::a4d9:eecb:f93e:7df0%6]) with mapi id 15.20.5395.014; Fri, 1 Jul 2022
 05:44:52 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <linux@armlinux.org.uk>
CC:     <andrew@lunn.ch>, <linux-kernel@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <vivien.didelot@gmail.com>,
        <ast@kernel.org>, <bpf@vger.kernel.org>, <olteanv@gmail.com>,
        <devicetree@vger.kernel.org>, <robh+dt@kernel.org>,
        <andrii@kernel.org>, <songliubraving@fb.com>,
        <f.fainelli@gmail.com>, <daniel@iogearbox.net>,
        <john.fastabend@gmail.com>, <kuba@kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>, <kpsingh@kernel.org>,
        <netdev@vger.kernel.org>, <Woojung.Huh@microchip.com>,
        <krzysztof.kozlowski+dt@linaro.org>, <yhs@fb.com>,
        <davem@davemloft.net>, <kafai@fb.com>
Subject: Re: [Patch net-next v14 11/13] net: dsa: microchip: lan937x: add
 phylink_mac_link_up support
Thread-Topic: [Patch net-next v14 11/13] net: dsa: microchip: lan937x: add
 phylink_mac_link_up support
Thread-Index: AQHYjGts28diLMF8Q0Gthl9SV7zL4K1n1BkAgAEubYA=
Date:   Fri, 1 Jul 2022 05:44:52 +0000
Message-ID: <3ef3e69289552f93ee94151a68c0ff3cf1226963.camel@microchip.com>
References: <20220630102041.25555-1-arun.ramadoss@microchip.com>
         <20220630102041.25555-12-arun.ramadoss@microchip.com>
         <Yr2MImcS9lzr3yx9@shell.armlinux.org.uk>
In-Reply-To: <Yr2MImcS9lzr3yx9@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b7794f80-5b68-409f-4282-08da5b24d1bc
x-ms-traffictypediagnostic: MW5PR11MB5763:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: y6eA3YuGb2bdWdw+fTrCwivuoAXX0p7nMuT+/RDUyUKTysfkIW41vxOCmgczokJRGsuQbyqYIJMxMh8o2JcgNDcShXHdKbnwbh7/fM2jzdnspkqxjuPlEnRCDipqMQlr09c+UsB1/h9rqwK9MNGkg9Tx0zfPvUs7Xfaf8E9mPrA1dUO5ZQv9Nv6injMCXvgXibHmkmPDB9quchv63mxMOuFXqFZWeQartRy1iow8Nn1MG+df6ptiFE+w12tUWqM4Impv9szQdkDcpZ9hUSDalmQ0MVlZhFvxwaQHWl6ln7AxeqcMzyO8FNnUp+SUfa6bWcx8BaqvmMIu3y4dK8g6/7QtKp1w5nNflHvusBzdujXHqAPuvLIGXYvkBMKM9skceciaw4IKZWXD3NCFD8SPXamRUB42s65YsD00IVdfuJLGnybLuIkXo4NXRA84lPT4yf/C0mz0/B7r0YnDuphT4cYWPW4gcpPfd5KhlHJ19RmBR0F8gsSotvk7X8jRQNsGVOG9vwWWSzNZI4kgU97lAxuenu2abu6TYPTqD2cylJ/+vIaEfoSFcS2jNVZ0Tw5RSV8i05GDEFydCO088lweFuehnkO55JnFZjmHe5jhciiPCf/NkrArOhowtr7z/e+tpQD3Ao55J1ZdaEVZhtJn3TkYn691WSrCtHCdE6UiB3KvtsYP2ekNBVGs2QhOBK3r96oYK1dH+WeTfY9Njg1ToiJc31OAJvzTskA0mK0mtfDF9LYQ8jPutbrX8t2nx1Pf3j3FaRphS9naAykfMhmqF34dMda5a27MtfYyhJHfvfdJGfv1bPHrPAHULvFY0peIsKnwyE220mpq9CSsaTLCbMp4Ikwcm2+aC+0WkBg/pppvfyH3u8UxWhPX8YmNUPZy
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(136003)(346002)(39860400002)(376002)(396003)(122000001)(2616005)(66556008)(6512007)(83380400001)(91956017)(66476007)(66946007)(5660300002)(186003)(36756003)(6916009)(316002)(7416002)(26005)(478600001)(6506007)(54906003)(86362001)(6486002)(71200400001)(66446008)(8676002)(38070700005)(966005)(4326008)(64756008)(8936002)(2906002)(76116006)(38100700002)(41300700001)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OWNDNytjNVpiQWN3aEk2SzlDNmpDRUwyd2lVSkpNazlrdHMySVpyeWwzdXEy?=
 =?utf-8?B?SEc2VHRhYzIyUlJGbEREaTgvZGh4SEtZa20xMGNiWHlIbGhaTDFZZWNxNTZY?=
 =?utf-8?B?QnpyQjN1Ykc0ZDBnaWhhczFXQVVIYU9CTDFKc2o3UmZ0L0pzY0JwNm9IeDN2?=
 =?utf-8?B?Yi8zRzcramFOU25haXVWZmtLVlhPN2VFMTV4U0NWVkQrSWlRa2loVzk5cEVQ?=
 =?utf-8?B?L0tObXBNQkdsaEY5TCtTRXJ5QzlQTnU1Vkg5WmVmMnQwd1NVdXJ3Mmd1cWNj?=
 =?utf-8?B?VkRpT1ozZkZSMFp2QUxBcHB3Nm9zZFZobDhmejBLRXZQK1VSVm4yMzVqR0d1?=
 =?utf-8?B?b0EybW01UHZsMy9Qam9WOFlObW0yVVRGeUlaSXEwV3R1TUJTanAzUUlzN0hk?=
 =?utf-8?B?aTFsanhDS3dMWU9EVGo4WWk1ZGYvcnpMOUJNcXZ2eFNjSnNReGxPdllsUDh0?=
 =?utf-8?B?bXBFOW9xRDlRSjN1akE2am9jNzlwS2lRRlVJblVmN1ZNY1hPUjNQbnNWZzcy?=
 =?utf-8?B?eFhGc0Y1dUxDSFNJZ0VlcmxDbWdQQm9DcmRiTy95NndXN0ZZWGNRVVVXTFBi?=
 =?utf-8?B?NEtpdXBiT3VvOERIZzQxdFFJSjQwMG1sdWpJYUtublROTXZyWTNqMm9aSDd2?=
 =?utf-8?B?WlhhTGFqMUtRUmhxR1YyU3ppWXd2Y3BoczNHR1A5R0F1enBmYnhXSy81RHc4?=
 =?utf-8?B?RE1MNGJIM0gvd04wMXdLOGxpSXN1U2RFdHdURU9lYllqdnpxemZKV0wzZEpY?=
 =?utf-8?B?dE4zSU1vL3k3K21KZEE2Ti9sSzFkUjdKNnRHakc0cGlQTTBrVk1zN2xqbTdP?=
 =?utf-8?B?aUlqek93MEJHbEpIOTFqSEg2aXUrZG1Jd0JzS0pHSEMxdlYzWFZDZVVjN3hG?=
 =?utf-8?B?ZGtEbmwxRVM2WU1VNmtWZHJXMVZVdVFBMU9vaDYwQ05kc0YvNEYwajNFeXZl?=
 =?utf-8?B?amRpaWt2dzFISnJGbzhPdFZyVCtWSk9nQ3Q5RFpHTXdYbVdpOGZ2U3FJVXRL?=
 =?utf-8?B?T3EzclZnMjBFQTVMQ3RSZE1sbWZSYkhaUXFEMFdwcnVRMXpsTExSREViQ2xH?=
 =?utf-8?B?aVAyQ1hYZWFnclVneE1DMzBUV3hSSjl6VFJ6MnN6S1hGSjVKanJDdGpUQ253?=
 =?utf-8?B?bTlhaU9XZVRRS1VzOFdmYVhUM1dzUGFPUlpGbk5uWmhLMTh1ZkNJS1lSVW5H?=
 =?utf-8?B?SXo3VGJRMTdPRGFXSU9zY3R4SXVvU1dhSFF1UXRSaWQrMStIcGFiTWlyK25Y?=
 =?utf-8?B?Rk94QUVCaytFenArdlk2cC9DS04wOFoxbHRTc2pqU29sV3ZnWEV2Sk04ZEcz?=
 =?utf-8?B?L2dsRFNPMmFTalVqdnZlenJscmg3RFdhSlZJeFUzYmhZb3Eyb2JidUxwT21V?=
 =?utf-8?B?ckt5eHJVV09QM1k2NW04dTFXRUJxT1I3TTJzV3ovWFd0YUQyRk1pbEx3bUQ0?=
 =?utf-8?B?M0p3RlJCQjJYcDlZaUhXUFZQNUJnaDZBcFdOVDFrSisrejEwS3d6Wko3TENB?=
 =?utf-8?B?eE90anBSTmZBZ1Mwdkc1SkFGZmZheWdmeG9qMWtUZ0MzbWt1TS81VFFndll1?=
 =?utf-8?B?RmUzQVRpNEJZTGpkWUZUaGF6VVN1aGhvcmpaYzVYRDlwMmZySGVtK3o1aWZm?=
 =?utf-8?B?eGgxZmVORndLeHdWeHpONGZwUEgrQysyeExRdVd1bWUwT0V4ZmVwK2N6M3Ri?=
 =?utf-8?B?SUxFMVBXbFJTTWxBVG40SmNRRDh3RERiV3BRT0F0dXJnU0IwR0JDbVpDYnQx?=
 =?utf-8?B?SktRdG02ZTNiVFRERjdEamRjY1RTc0JJNWFwVGdkNzNubEFxQWJqY3hXOXpv?=
 =?utf-8?B?VDlCWS9FUVlPUW1VMHBSOWRhV3V0a3ZidUhxeDBGN3Zic2huYkdjVlhRV25o?=
 =?utf-8?B?NS9rd3J0bXZJME51U1lIQ09jQ21wWlNOWHdldE1tVUxjUlllU2pjOUJxUElr?=
 =?utf-8?B?QzRzYkNuRWd6MlpzMnByWnlsOGRlMmljdVRQdFRuR0x5K0pzTGRBVUpwMTZD?=
 =?utf-8?B?dkdVcUFyQWluYm1ndEc4SnhzTkd4VlFtbkJjLzEvaHlocGRSenRtd1IvKzlF?=
 =?utf-8?B?TEFtZk1aSXpKNVp3ekN3VXVXalpwb29VV2VkdVcwNG0yVmFYZHlpVUZJMXpY?=
 =?utf-8?B?VkZtWlZYWjBaNTNwbVN5UkJndXpmWC94QmlDZjdGdmQ0eldORjNUajM3Q1VG?=
 =?utf-8?Q?a1SHu1fruNpyYA+cGts6OOY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <95A12CB710829C45844814A91C01227D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7794f80-5b68-409f-4282-08da5b24d1bc
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jul 2022 05:44:52.1760
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DhV4+6Z2zqMdcKHEB4E9tJSWSGJU7W0rbWwr7fu8ykPOBxRVBvUn/9cRfFxWpD5Ua6VIxxw81IwyXvEs01E2QGeUXPnyuho+0rULTJmhGTY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5763
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgUnVzc2VsbCwNClRoYW5rcyBmb3IgdGhlIHJldmlldyBjb21tZW50Lg0KDQpPbiBUaHUsIDIw
MjItMDYtMzAgYXQgMTI6NDIgKzAxMDAsIFJ1c3NlbGwgS2luZyAoT3JhY2xlKSB3cm90ZToNCj4g
RVhURVJOQUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVu
bGVzcyB5b3UNCj4ga25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo+IA0KPiBPbiBUaHUsIEp1biAz
MCwgMjAyMiBhdCAwMzo1MDozOVBNICswNTMwLCBBcnVuIFJhbWFkb3NzIHdyb3RlOg0KPiA+ICtz
dGF0aWMgdm9pZCBsYW45Mzd4X2NvbmZpZ19nYml0KHN0cnVjdCBrc3pfZGV2aWNlICpkZXYsIGJv
b2wgZ2JpdCwNCj4gPiB1OCAqZGF0YSkNCj4gPiArew0KPiA+ICsgICAgIGlmIChnYml0KQ0KPiA+
ICsgICAgICAgICAgICAgKmRhdGEgJj0gflBPUlRfTUlJX05PVF8xR0JJVDsNCj4gPiArICAgICBl
bHNlDQo+ID4gKyAgICAgICAgICAgICAqZGF0YSB8PSBQT1JUX01JSV9OT1RfMUdCSVQ7DQo+ID4g
K30NCj4gPiArDQo+ID4gK3N0YXRpYyB2b2lkIGxhbjkzN3hfY29uZmlnX2ludGVyZmFjZShzdHJ1
Y3Qga3N6X2RldmljZSAqZGV2LCBpbnQNCj4gPiBwb3J0LA0KPiA+ICsgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgaW50IHNwZWVkLCBpbnQgZHVwbGV4LA0KPiA+ICsgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgYm9vbCB0eF9wYXVzZSwgYm9vbCByeF9wYXVzZSkNCj4g
PiArew0KPiA+ICsgICAgIHU4IHhtaWlfY3RybDAsIHhtaWlfY3RybDE7DQo+ID4gKw0KPiA+ICsg
ICAgIGtzel9wcmVhZDgoZGV2LCBwb3J0LCBSRUdfUE9SVF9YTUlJX0NUUkxfMCwgJnhtaWlfY3Ry
bDApOw0KPiA+ICsgICAgIGtzel9wcmVhZDgoZGV2LCBwb3J0LCBSRUdfUE9SVF9YTUlJX0NUUkxf
MSwgJnhtaWlfY3RybDEpOw0KPiA+ICsNCj4gPiArICAgICBzd2l0Y2ggKHNwZWVkKSB7DQo+ID4g
KyAgICAgY2FzZSBTUEVFRF8xMDAwOg0KPiA+ICsgICAgICAgICAgICAgbGFuOTM3eF9jb25maWdf
Z2JpdChkZXYsIHRydWUsICZ4bWlpX2N0cmwxKTsNCj4gPiArICAgICAgICAgICAgIGJyZWFrOw0K
PiA+ICsgICAgIGNhc2UgU1BFRURfMTAwOg0KPiA+ICsgICAgICAgICAgICAgbGFuOTM3eF9jb25m
aWdfZ2JpdChkZXYsIGZhbHNlLCAmeG1paV9jdHJsMSk7DQo+ID4gKyAgICAgICAgICAgICB4bWlp
X2N0cmwwIHw9IFBPUlRfTUlJXzEwME1CSVQ7DQo+ID4gKyAgICAgICAgICAgICBicmVhazsNCj4g
PiArICAgICBjYXNlIFNQRUVEXzEwOg0KPiA+ICsgICAgICAgICAgICAgbGFuOTM3eF9jb25maWdf
Z2JpdChkZXYsIGZhbHNlLCAmeG1paV9jdHJsMSk7DQo+ID4gKyAgICAgICAgICAgICB4bWlpX2N0
cmwwICY9IH5QT1JUX01JSV8xMDBNQklUOw0KPiA+ICsgICAgICAgICAgICAgYnJlYWs7DQo+ID4g
KyAgICAgZGVmYXVsdDoNCj4gPiArICAgICAgICAgICAgIGRldl9lcnIoZGV2LT5kZXYsICJVbnN1
cHBvcnRlZCBzcGVlZCBvbiBwb3J0ICVkOg0KPiA+ICVkXG4iLA0KPiA+ICsgICAgICAgICAgICAg
ICAgICAgICBwb3J0LCBzcGVlZCk7DQo+ID4gKyAgICAgICAgICAgICByZXR1cm47DQo+ID4gKyAg
ICAgfQ0KPiANCj4gSXNuJ3QgdGhpczoNCj4gDQo+ICAgICAgICAgaWYgKHNwZWVkID09IFNQRUVE
XzEwMDApDQo+ICAgICAgICAgICAgICAgICB4bWlpX2N0cmwxICY9IH5QT1JUX01JSV9OT1RfMUdC
SVQ7DQo+ICAgICAgICAgZWxzZQ0KPiAgICAgICAgICAgICAgICAgeG1paV9jdHJsMSB8PSBQT1JU
X01JSV9OT1RfMUdCSVQ7DQo+IA0KPiAgICAgICAgIGlmIChzcGVlZCA9PSBTUEVFRF8xMDApDQo+
ICAgICAgICAgICAgICAgICB4bWlpX2N0cmwwIHw9IFBPUlRfTUlJXzEwME1CSVQ7DQo+ICAgICAg
ICAgZWxzZQ0KPiAgICAgICAgICAgICAgICAgeG1paV9jdHJsMCAmPSB+UE9SVF9NSUlfMTAwTUJJ
VDsNCj4gDQo+IFRoZXJlIGlzbid0IG11Y2ggbmVlZCB0byB2YWxpZGF0ZSB0aGF0ICJzcGVlZCIg
aXMgY29ycmVjdCwgeW91J3ZlDQo+IGFscmVhZHkgdG9sZCBwaHlsaW5rIHRoYXQgeW91IG9ubHkg
c3VwcG9ydCAxRywgMTAwTSBhbmQgMTBNIHNvIHlvdSdyZQ0KPiBub3QgZ29pbmcgdG8gZ2V0IGNh
bGxlZCB3aXRoIGFueXRoaW5nIGV4Y2VwdCBvbmUgb2YgdGhvc2UuDQoNCk9rLCBJIHdpbGwgdXBk
YXRlIHRoZSBjb2RlLg0KDQo+IA0KPiA+ICsNCj4gPiArICAgICBpZiAoZHVwbGV4KQ0KPiA+ICsg
ICAgICAgICAgICAgeG1paV9jdHJsMCB8PSBQT1JUX01JSV9GVUxMX0RVUExFWDsNCj4gPiArICAg
ICBlbHNlDQo+ID4gKyAgICAgICAgICAgICB4bWlpX2N0cmwwICY9IH5QT1JUX01JSV9GVUxMX0RV
UExFWDsNCj4gPiArDQo+ID4gKyAgICAgaWYgKHR4X3BhdXNlKQ0KPiA+ICsgICAgICAgICAgICAg
eG1paV9jdHJsMCB8PSBQT1JUX01JSV9UWF9GTE9XX0NUUkw7DQo+ID4gKyAgICAgZWxzZQ0KPiA+
ICsgICAgICAgICAgICAgeG1paV9jdHJsMSAmPSB+UE9SVF9NSUlfVFhfRkxPV19DVFJMOw0KPiAN
Cj4gSXQgc2VlbXMgd2VpcmQgdG8gc2V0IGEgYml0IGluIG9uZSByZWdpc3RlciBhbmQgY2xlYXIg
aXQgaW4gYQ0KPiBkaWZmZXJlbnQNCj4gcmVnaXN0ZXIuIEkgc3VzcGVjdCB5b3UgbWVhbiB4bWlp
X2N0cmwwIGhlcmUuDQoNClNvcnJ5LCBpdHMgYSB0eXBvIG1pc3Rha2UuIEkgd2lsbCB1cGRhdGUg
dGhlIHJlZ2lzdGVyLg0KDQo+IA0KPiA+ICsNCj4gPiArICAgICBpZiAocnhfcGF1c2UpDQo+ID4g
KyAgICAgICAgICAgICB4bWlpX2N0cmwwIHw9IFBPUlRfTUlJX1JYX0ZMT1dfQ1RSTDsNCj4gPiAr
ICAgICBlbHNlDQo+ID4gKyAgICAgICAgICAgICB4bWlpX2N0cmwwICY9IH5QT1JUX01JSV9SWF9G
TE9XX0NUUkw7DQo+ID4gKw0KPiA+ICsgICAgIGtzel9wd3JpdGU4KGRldiwgcG9ydCwgUkVHX1BP
UlRfWE1JSV9DVFJMXzAsIHhtaWlfY3RybDApOw0KPiA+ICsgICAgIGtzel9wd3JpdGU4KGRldiwg
cG9ydCwgUkVHX1BPUlRfWE1JSV9DVFJMXzEsIHhtaWlfY3RybDEpOw0KPiA+ICt9DQo+ID4gKw0K
PiANCj4gVGhhbmtzIQ0KPiANCj4gLS0NCj4gUk1LJ3MgUGF0Y2ggc3lzdGVtOiBodHRwczovL3d3
dy5hcm1saW51eC5vcmcudWsvZGV2ZWxvcGVyL3BhdGNoZXMvDQo+IEZUVFAgaXMgaGVyZSEgNDBN
YnBzIGRvd24gMTBNYnBzIHVwLiBEZWNlbnQgY29ubmVjdGl2aXR5IGF0IGxhc3QhDQo=
