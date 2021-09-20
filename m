Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02704411083
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 09:52:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235231AbhITHwZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 03:52:25 -0400
Received: from mga17.intel.com ([192.55.52.151]:58982 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235254AbhITHt6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Sep 2021 03:49:58 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10112"; a="203239134"
X-IronPort-AV: E=Sophos;i="5.85,307,1624345200"; 
   d="scan'208";a="203239134"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2021 00:48:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,307,1624345200"; 
   d="scan'208";a="517766445"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga001.jf.intel.com with ESMTP; 20 Sep 2021 00:48:24 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Mon, 20 Sep 2021 00:48:23 -0700
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Mon, 20 Sep 2021 00:48:23 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Mon, 20 Sep 2021 00:48:23 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.40) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Mon, 20 Sep 2021 00:48:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cX9pMMkaQ6Kdr/NVH3jRJvMZulirWzwVI68osaBpaK0Sakk4RH+pOIiQ3sWGmMPq+Z9ZJflHobnMrUnOvt3pgqkSzWMReN0aAFV0CEoofT+TdhZ6QYiUoJO2/CrfChyAruifCejS71EgWeTCPB/h+aHA0SEGpeZB1hgKgikaVFT3LSXTgX7ynYku3LKqiPIOxTaqqflgFjU5XHfd/TdboF0bTVVmZcT4VY/JUsl7ZL4eW5wf31YlP7JS4jHC5u2mjC0eF0/a703dbkQkYmOF/ZvZbace3El9gKkgEAgpHbkis1PNUoD+57C4ptPtxgs5Ho5o0hSII+ork1cp/xvpAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=JXh0+LtwF4nNsuCKmzOeNT7yL7NBDx1G059pdQOhd5Q=;
 b=mdLINA4JkF35cCvqs4idH0E9k4/D1gCJEuKR/agExsxI/XgCDkUea/BuYyX7XP/UhbFCOxJm/6QpiRQSxO9xhXE4zd3Gtdz2avpdeNrKDY3SMvepQ6Rq3+3D7BOsTanVGSUS5jDee748MfMN58N7/jN3C+hlINDiykGMHQp103A1PPUL2Ru4XeBTcsQepgvJd7+M1TkNtGLrYCZuRcRCdJW6WVPF+Px/bAL93fPnzQsXm30f6SHFLY4Q4F/+2edl//VH674bkR90nE5b/sKRX/3hPo+pqmlbM/fBRBMiHbD5KAO4e4Fus/abI8Ycg17i2TYmYrirgfVSN0pe5mhXAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JXh0+LtwF4nNsuCKmzOeNT7yL7NBDx1G059pdQOhd5Q=;
 b=c2DkUu9mjhCyYDbNcV3LsFWiWuTOIfRjHOHkZoGmP1uUVUt5v2Hp1buSGtBft6u7rRuOsqpuScONp5/GTqlA6r3N8N6BQhjv3+Z6zI/xGi60Y7FEpuvcuW+1DQ0+RWDdSnXKiMaO0yV7Lugbgtm5Q0Z3lcSh1WzbLmnYp/pAerM=
Received: from DM6PR11MB3371.namprd11.prod.outlook.com (2603:10b6:5:e::22) by
 DM6PR11MB3369.namprd11.prod.outlook.com (2603:10b6:5:b::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4523.16; Mon, 20 Sep 2021 07:48:20 +0000
Received: from DM6PR11MB3371.namprd11.prod.outlook.com
 ([fe80::ade9:932c:827d:895]) by DM6PR11MB3371.namprd11.prod.outlook.com
 ([fe80::ade9:932c:827d:895%5]) with mapi id 15.20.4523.018; Mon, 20 Sep 2021
 07:48:20 +0000
From:   "Dziedziuch, SylwesterX" <sylwesterx.dziedziuch@intel.com>
To:     PJ Waskiewicz <pwaskiewicz@jumptrading.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "pjwaskiewicz@gmail.com" <pjwaskiewicz@gmail.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "Loktionov, Aleksandr" <aleksandr.loktionov@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Machnikowski, Maciej" <maciej.machnikowski@intel.com>
Subject: RE: [PATCH 1/1] i40e: Avoid double IRQ free on error path in probe()
Thread-Topic: [PATCH 1/1] i40e: Avoid double IRQ free on error path in probe()
Thread-Index: AQHXmsiBRJTk/bztnkiJewAWaKSBqquMjXAAgAGS54CAFFexAIAAD6UAgADBxBCAAONggIAAyeVAgAQ1+oCAA4C90A==
Date:   Mon, 20 Sep 2021 07:48:20 +0000
Message-ID: <DM6PR11MB3371A285032A583A73BA62E0E6A09@DM6PR11MB3371.namprd11.prod.outlook.com>
References: <20210826221916.127243-1-pwaskiewicz@jumptrading.com>
         <50c21a769633c8efa07f49fc8b20fdfb544cf3c5.camel@intel.com>
         <20210831205831.GA115243@chidv-pwl1.w2k.jumptrading.com>
         <MW4PR14MB4796AE05A868B47FE4F6E12AA1D99@MW4PR14MB4796.namprd14.prod.outlook.com>
 <bebb58f34ed68025e95f8bc060af58a24333374b.camel@intel.com>
 <DM6PR11MB3371A3D1F314F3B8541FAF03E6DA9@DM6PR11MB3371.namprd11.prod.outlook.com>
 <MW4PR14MB47960CC778789EEE8E8A54EDA1DA9@MW4PR14MB4796.namprd14.prod.outlook.com>
 <DM6PR11MB3371B4431AD7C46672C7E439E6DB9@DM6PR11MB3371.namprd11.prod.outlook.com>
 <MW4PR14MB4796F279908B7E4D11622C66A1DE9@MW4PR14MB4796.namprd14.prod.outlook.com>
In-Reply-To: <MW4PR14MB4796F279908B7E4D11622C66A1DE9@MW4PR14MB4796.namprd14.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
authentication-results: jumptrading.com; dkim=none (message not signed)
 header.d=none;jumptrading.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e0528d3c-2e8a-4a4c-5877-08d97c0b0444
x-ms-traffictypediagnostic: DM6PR11MB3369:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB3369F6C2B660B6D7FF2ECB72E6A09@DM6PR11MB3369.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jCOeXrqg2tdl8bkKYf9B8vrDeFJEklbILgow6HfM4rS5tXnHp7zTJgK5aRBKaEueMoaOZO8Wpu3i/sQTy9VowkVSDpXGYjUtprOnVskHfcJVtPXDeg5ryspRG6rdr0vaN+e7vKiKp/75HPMlBtRbDfrb/QTHm+czr5elfpUbN8QJFHOoYhlq1pk4Y1pm7z5Q3xsu88CNTOsWL8cvRuTysJjgb53HGx2LuqzS2R2rDOD1zs0BCht8K21n92uvcOtdShFYXabkdRaI+Rz19S1yKr0G2w9LlGVs6Pzp9Zs8Mk+TSTsMTcOfLJk2DiDJAyUVBd0OzwY7rTzD7cxDRUmhEOMrb5gUzL5XKhfjNUIL09It3J+S3Qx4MI+eynBW3F4Yrq90XZiiPvwPfPE8fFuBRAgos2qi+kr793epiRrnwxRlP5Bc6+3tWS8uGs+tp5SuBZ9rOEL/lW0WaIVdcu1GCpAl5ttTqZOCyKBMdvyzTZ7Kio9DCwMU5fDNOm3vSfBA6a60l3e863CZmRmujpKsZMCLKN+h6YgOx2737lzSrBQIH3qc3osgi8y24mxLepnrW2b1FEIIINpdWdQvaiEE+si7RvLeNUE9eNvUGTqHYqxUgKqL+qTFDJcP0bisgWQQYS8fjdS2FIUthRJ9TmLbygkfF61hE1X/pyw78HafSrZW+mfjBPBq2KSwT6jmck4ToKBWVUlfurfMGrImX4sjaw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3371.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(346002)(376002)(136003)(39860400002)(66946007)(54906003)(122000001)(2906002)(76116006)(55016002)(110136005)(107886003)(38100700002)(316002)(71200400001)(83380400001)(7696005)(8936002)(5660300002)(66476007)(86362001)(66556008)(53546011)(52536014)(38070700005)(33656002)(8676002)(6506007)(4326008)(26005)(9686003)(478600001)(6636002)(186003)(66446008)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UzZzcy9ORnE0ZHNFejY1L0NxUVhmSWFSTjFzT0xlcWV6VXc3WG1qSzFiS1Er?=
 =?utf-8?B?Q3VjMnNQOHlCc3U5c285bWVmL2ljVWlvU3l6a3QreFpVSjBGSnJ6SEN1QUxq?=
 =?utf-8?B?TTI4ZDArV21Ha042TWl5YmlYV09Sc2I2ZjVNT2dNNFkxeVFTcFFneXcyOEZS?=
 =?utf-8?B?NTc0WmRVTXVSeWVia3Y5VlcydDVHdEp5NSt0VFhVQTVOK0dQSVlGWXNoUDNH?=
 =?utf-8?B?U3o1azRDZGlvWWRDSmdOSThCS0Y1eHMydHJyb2MvdDI2UktZREJqZ1Z1cm8z?=
 =?utf-8?B?OGM3bm51Z1dNS25vTk85VkdZUjZyUE9NNlgvandxSlNKeGlpb0ppTERMaUxr?=
 =?utf-8?B?d1RzL20xblB1QlRTUUJQbUdBZVA1Y3RiSUpZaTBRaHpMeTRnUlBxQkZqL1oz?=
 =?utf-8?B?bE1NcDZ2MFFRNjNENkJWb01HRy9FcVBrYnZxQnljQlBFNW1FSXRuc3E4WUZF?=
 =?utf-8?B?enhXaVI5V2U1K3RON1ExZXd6aC9sZnFibUllTlZhWThkeWR1M3k5YlBUekN3?=
 =?utf-8?B?ZllnbmF1VHplTjVrNnlwOXJsbTZXN0phYk1CbGcrNnJoVExJd3BHVlhkTFFh?=
 =?utf-8?B?RlRsekJYK01wVU1vbE1xa3MweHhINWpmYnZQREgyc2JBVWpmbCthcDAxZDlL?=
 =?utf-8?B?aHd0MHdOaTRUcHcvZ2tDMHdXbUtWRjl1dmJKMjlMUFRQWUk5U3VLRWxJaTQ4?=
 =?utf-8?B?YjBad3F5Y2FnRzh5ZW91OTR1MGNDVkM4bTFMQWZMTFBDanVJbGppd0FxaDJp?=
 =?utf-8?B?WWsxOUovTmN1anM5UFUrQnhrSDlsbWxyaVdHRUNVM1N2VUhRaDlPdUxhT0Q1?=
 =?utf-8?B?bDZYZTNobjZDejVLN2FxWHk2Rzd1MEtrejVmaW1sK0NMRFJJS2hCcXp4ejhs?=
 =?utf-8?B?YWhBY2R5NHRENElaa2l6RDIrWFFlbjQrWUVrNkthTXJNd2EzQlBZL3JnWFVw?=
 =?utf-8?B?ZHFFVWwrZGxzSk0vaW94R01KY09vMHZqeHhFRXNnekNIR3pjK0R4ZFJXYnlX?=
 =?utf-8?B?b1hmeXVXVzlsVjhqR0pXNFB2SFNFWkxQNnYwQU84a2tHYXpia1BSK1o3bmh5?=
 =?utf-8?B?UnM0TEJydUF1NndtS2hBbFZzclRvbkhwSFJIbHo4Z1htWms0Z05YUm8yMmZ6?=
 =?utf-8?B?MG1LYWhYOFZhWm5tbUl4UzlrMkZES3hFa3MwSCtzejJqRnBCNStIYVo5ZTlU?=
 =?utf-8?B?N0JvSE5Zcmw3eFdGVVVsTWRyeTVFRnpEOU91T2czRndKRzJJdnQwc21KMmdw?=
 =?utf-8?B?d2lYdUN2RVBZTFRCaEQzQmFpL1ljcTZUbGhkM095ZWlRYUYxVnNVbjNIVDhs?=
 =?utf-8?B?ZGtmUDNWay92WGZ5cVB1YkZXelVvSVdxdEgva3k2aW95ODZGZk5CNW9ZUTdU?=
 =?utf-8?B?N250WFJqY3J3dlFCUTlzVDAvWFpBSjZ4L0FLeWtySXMrWDZEZGRoODl4NDhr?=
 =?utf-8?B?YXFVS2FZNURTemNrKzFxUkNFL3N1bGVsMys2OHFHY1pNcy8yaGNnenY0UEd0?=
 =?utf-8?B?UEp1anlWNHo5ODdhWXIwQzM2dExlbDhoQ3JSRHY5ZWh4Yi9wUGpCYmRab1dD?=
 =?utf-8?B?Kzc1NU9IZFI5a0JVSHNhU1NlblVya1BIelM5MGFEaWx0RHpHczNiTzJDRm1q?=
 =?utf-8?B?aXF0RkEzT1J1ODhaTjdZZzJ4WG1pODl0Yi9iQis1eUVSN0s0MUQ1d3hqaVlv?=
 =?utf-8?B?amM4KzYzN0I4Tjg0bXJoWHFXaFBZSnlZMFRFMkQ2L1ZLdnpUbHNQQmt1cjEz?=
 =?utf-8?Q?gG/316uK++1WPqWt7Q=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3371.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0528d3c-2e8a-4a4c-5877-08d97c0b0444
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Sep 2021 07:48:20.5899
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Uu+OTgaTccRHBj1HF6oSl034mzAJKvzJaymnzyMI1Z44hwao237RuNxDa9I1TKLBX3Q1axhhsT7NaiPJOJbOVgY179aGS4+9iAMEVAv2Vek=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3369
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8gUEosDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogUEogV2Fz
a2lld2ljeiA8cHdhc2tpZXdpY3pAanVtcHRyYWRpbmcuY29tPg0KPiBTZW50OiBTYXR1cmRheSwg
U2VwdGVtYmVyIDE4LCAyMDIxIDQ6MDIgQU0NCj4gVG86IER6aWVkeml1Y2gsIFN5bHdlc3Rlclgg
PHN5bHdlc3RlcnguZHppZWR6aXVjaEBpbnRlbC5jb20+OyBOZ3V5ZW4sDQo+IEFudGhvbnkgTCA8
YW50aG9ueS5sLm5ndXllbkBpbnRlbC5jb20+DQo+IENjOiBkYXZlbUBkYXZlbWxvZnQubmV0OyBw
andhc2tpZXdpY3pAZ21haWwuY29tOyBGaWphbGtvd3NraSwgTWFjaWVqDQo+IDxtYWNpZWouZmlq
YWxrb3dza2lAaW50ZWwuY29tPjsgTG9rdGlvbm92LCBBbGVrc2FuZHINCj4gPGFsZWtzYW5kci5s
b2t0aW9ub3ZAaW50ZWwuY29tPjsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgQnJhbmRlYnVyZywg
SmVzc2UNCj4gPGplc3NlLmJyYW5kZWJ1cmdAaW50ZWwuY29tPjsgaW50ZWwtd2lyZWQtbGFuQGxp
c3RzLm9zdW9zbC5vcmc7DQo+IE1hY2huaWtvd3NraSwgTWFjaWVqIDxtYWNpZWoubWFjaG5pa293
c2tpQGludGVsLmNvbT4NCj4gU3ViamVjdDogUkU6IFtQQVRDSCAxLzFdIGk0MGU6IEF2b2lkIGRv
dWJsZSBJUlEgZnJlZSBvbiBlcnJvciBwYXRoIGluIHByb2JlKCkNCj4gDQo+IEhpIFN5bHdlc3Rl
ciwNCj4gDQo+ID4NCj4gPiBZb3UgYXJlIHJpZ2h0IHRoZSBwcm9ibGVtIGlzIHdpdGggbWlzYyBJ
UlEgdmVjdG9yIGJ1dCBhcyBmYXIgYXMgSSBjYW4NCj4gPiBzZWUgdGhpcyBwYXRjaCBvbmx5IG1v
dmVzIGk0MGVfcmVzZXRfaW50ZXJydXB0X2NhcGFiaWxpdHkoKSBvdXRzaWRlIG9mDQo+ID4gaTQw
ZV9jbGVhcl9pbnRlcnJ1cHRfc2NoZW1lKCkuIEl0IGRvZXMgbm90IGZpeCB0aGUgcHJvYmxlbSBv
Zg0KPiA+IGk0MGVfZnJlZV9taXNjX3ZlY3RvcigpIG9uIHVuYWxsb2NhdGVkIHZlY3RvciBpbiBl
cnJvciBwYXRoLiBXZSBoYXZlIGENCj4gPiBwcm9wZXIgZml4IGZvciB0aGlzIHRoYXQgYWRkcyBh
ZGRpdGlvbmFsIGNoZWNrIGZvcg0KPiA+IF9fSTQwRV9NSVNDX0lSUV9SRVFVRVNURUQgYml0IHRv
IGk0MGVfZnJlZV9taXNjX3ZlY3RvcigpOg0KPiANCj4gSXQgZG9lcyBmaXggdGhlIHByb2JsZW0g
aWYgeW91IGNhbGwgdGhlIGZ1bmN0aW9uIHdoZW4gdGhlIE1JU0MgdmVjdG9yIGhhc24ndA0KPiBi
ZWVuIGFsbG9jYXRlZC4gIFllcywgSSBtb3ZlZCByZXNldF9pbnRlcnJ1cHRfY2FwYWJpbGl0eSgp
IG91dCBzbyBpdCBjb3VsZCBiZQ0KPiBzZXBhcmF0ZWx5IGNhbGxlZCBpbiB0aGUgcHJvYmUoKSBl
cnJvciBjbGVhbnVwIHBhdGguDQo+IA0KPiA+ICAgICAgICAgaWYgKHBmLT5mbGFncyAmIEk0MEVf
RkxBR19NU0lYX0VOQUJMRUQgJiYgcGYtPm1zaXhfZW50cmllcyAmJg0KPiA+ICAgICAgICAgICAg
IHRlc3RfYml0KF9fSTQwRV9NSVNDX0lSUV9SRVFVRVNURUQsIHBmLT5zdGF0ZSkpIHsNCj4gPg0K
PiA+IFRoaXMgYml0IGlzIHNldCBvbmx5IGlmIG1pc2MgdmVjdG9yIHdhcyBwcm9wZXJseSBhbGxv
Y2F0ZWQuIFRoZSBwYXRjaA0KPiA+IHdpbGwgYmUgb24gaW50ZWwtd2lyZWQgc29vbi4NCj4gDQo+
IFRoaXMgaXNuJ3QgZXZlbiBpbiB0aGUgT09UIGRyaXZlciBmcm9tIFNvdXJjZUZvcmdlLiAgQW5k
IGV2ZW4gaWYgeW91IHVzZWQgdGhhdA0KPiB0byBndWFyZCBmcmVlaW5nIHRoZSB2ZWN0b3Igb3Ig
bm90LCB0aGUgZmlyc3QgYml0IG9mIHRoYXQgZnVuY3Rpb24gaXMgc3RpbGwgd3JpdGluZyB0bw0K
PiBhIHJlZ2lzdGVyIHRvIGRpc2FibGUgdGhhdCBjYXVzZSBpbiB0aGUgaGFyZHdhcmU6DQo+IA0K
PiBzdGF0aWMgdm9pZCBpNDBlX2ZyZWVfbWlzY192ZWN0b3Ioc3RydWN0IGk0MGVfcGYgKnBmKSB7
DQo+ICAgICAgICAgLyogRGlzYWJsZSBJQ1IgMCAqLw0KPiAgICAgICAgIHdyMzIoJnBmLT5odywg
STQwRV9QRklOVF9JQ1IwX0VOQSwgMCk7DQo+ICAgICAgICAgaTQwZV9mbHVzaCgmcGYtPmh3KTsN
Cj4gDQo+IFdvdWxkIHlvdSBzdGlsbCB3YW50IHRvIGRvIHRoYXQgYmxpbmRseSBpZiB0aGUgdmVj
dG9yIHdhc24ndCBhbGxvY2F0ZWQgaW4gdGhlIGZpcnN0DQo+IHBsYWNlPyAgU2VlbXMgZXhjZXNz
aXZlLCBidXQgaXQnZCBiZSBoYXJtbGVzcy4gIFNlZW1zIGxpa2Ugbm90IGNhbGxpbmcgdGhpcw0K
PiBmdW5jdGlvbiBhbHRvZ2V0aGVyIHdvdWxkIGJlIGNsZWFuZXIgYW5kIGdlbmVyYXRlIGxlc3Mg
TU1JTyBhY3Rpdml0eSBpZiB0aGUNCj4gTUlTQyB2ZWN0b3Igd2Fzbid0IGFsbG9jYXRlZCBhdCBh
bGwgYW5kIHdlJ3JlIGZhbGxpbmcgb3V0IG9mIGFuIGVycm9yIHBhdGguLi4NCj4gDQo+IEkgYW0g
cmVhbGx5IGF0IGEgbG9zcyBoZXJlLiAgVGhpcyBpcyBjbGVhcmx5IGJyb2tlbi4gIFdlIGhhdmUg
YW4gT29wcy4gIFdlIGdldA0KPiB0aGVzZSBvY2Nhc2lvbmFsbHkgb24gYm9vdCwgYW5kIGl0J3Mg
cmVhbGx5IGFubm95aW5nIHRvIGRlYWwgd2l0aCBvbiBwcm9kdWN0aW9uDQo+IG1hY2hpbmVzLiAg
V2hhdCBpcyB0aGUgZGVmaW5pdGlvbiBvZiAic29vbiIgaGVyZSBmb3IgdGhpcyBuZXcgcGF0Y2gg
dG8gc2hvdw0KPiB1cD8gIE15IGRpc3RybyB2ZW5kb3Igd291bGQgbG92ZSB0byBwdWxsIHNvbWUg
c29ydCBvZiBmaXggaW4gc28gd2UgY2FuIGdldCBpdA0KPiBpbnRvIG91ciBidWlsZCBpbWFnZXMs
IGFuZCBzdG9wIGhhdmluZyB0aGlzIHByb2JsZW0uICBNeSBwYXRjaCBmaXhlcyB0aGUNCj4gaW1t
ZWRpYXRlIHByb2JsZW0uICBJZiB5b3UgZG9uJ3QgbGlrZSB0aGUgcGF0Y2ggKHdoaWNoIGl0IGFw
cGVhcnMgeW91IGRvbid0Ow0KPiB0aGF0J3MgZmluZSksIHRoZW4gc3RhbGxpbmcgb3Igc2F5aW5n
IGEgZGlmZmVyZW50IGZpeCBpcyBjb21pbmcgInNvb24iIGlzIHJlYWxseSBub3QgYQ0KPiBncmVh
dCBzdXBwb3J0IG1vZGVsLiAgVGhpcyB3b3VsZCBiZSBncmVhdCB0byBtZXJnZSwgYW5kIHRoZW4g
aWYgeW91IHdhbnQgdG8NCj4gbWFrZSBpdCAiYmV0dGVyIiBvbiB5b3VyIHNjaGVkdWxlLCBpdCdz
IG9wZW4gc291cmNlLCBhbmQgeW91IGNhbiBzdWJtaXQgYQ0KPiBwYXRjaC4gIE9yIEknbGwgYmUg
aGFwcHkgdG8gcmVzcGluIHRoZSBwYXRjaCwgYnV0IHN0aWxsIGNhbGxpbmcgZnJlZV9taXNjX3Zl
Y3RvcigpDQo+IGluIGFuIGVycm9yIHBhdGggd2hlbiB0aGUgTUlTQyB2ZWN0b3Igd2FzIG5ldmVy
IGFsbG9jYXRlZCBzZWVtcyBsaWtlIGEgYmFkDQo+IGRlc2lnbiBkZWNpc2lvbiB0byBtZS4NCj4g
DQo+IC1QSg0KDQpJIHRvdGFsbHkgYWdyZWUgdGhhdCB3ZSBzaG91bGRu4oCZdCBjYWxsIGZyZWVf
bWlzY192ZWN0b3IgaWYgbWlzYyB2ZWN0b3Igd2Fzbid0IGFsbG9jYXRlZCB5ZXQgYnV0IHRvIG1l
IHRoaXMgaXMgbm90IHdoYXQgeW91ciBwYXRjaCBpcyBkb2luZy4gZnJlZV9taXNjX3ZlY3Rvcigp
IGlzIGNhbGxlZCBpbiBjbGVhcl9pbnRlcnJ1cHRfc2NoZW1lIG5vdCByZXNldF9pbnRlcnJ1cHRf
Y2FwYWJpbGl0eSgpLiBJbiB5b3VyIHBhdGNoIGNsZWFyX2ludGVycnVwdF9zY2hlbWUoKSB3aWxs
IHN0aWxsIGJlIGNhbGxlZCB3aGVuIHBmIHN3aXRjaCBzZXR1cCBmYWlscyBpbiBpNDBlX3Byb2Jl
KCkgYW5kIGl0IHdpbGwgc3RpbGwgY2FsbCBmcmVlX21pc2NfdmVjdG9yIG9uIHVuYWxsb2NhdGVk
IG1pc2MgSVJRLiBPdGhlciBwcm9wZXIgd2F5IHRvIGZpeCB0aGlzIHdvdWxkIGJlIG1vdmluZyBm
cmVlX21pc2NfdmVjdG9yKCkgb3V0IG9mIGNsZWFyX2ludGVycnVwdF9zY2hlbWUoKSBhbmQgY2Fs
bGluZyBpdCBzZXBhcmF0ZWx5IHdoZW4gbWlzYyB2ZWN0b3Igd2FzIHJlYWxseSBhbGxvY2F0ZWQu
IEFzIGZvciB0aGUgaHcgcmVnaXN0ZXIgYmVpbmcgd3JpdHRlbiBpbiBvdXIgcGF0Y2ggYXMgeW91
IHNhaWQgaXQncyBoYXJtbGVzcy4gVGhlIHBhdGNoIHdlJ3ZlIHByZXBhcmVkIHNob3VsZCBiZSBv
biBpd2wgdG9kYXkuDQoNCkJSDQpTeWx3ZXN0ZXIgRHppZWR6aXVjaA0KDQo+IA0KPiBfX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fXw0KPiANCj4gTm90ZTogVGhpcyBlbWFpbCBpcyBmb3Ig
dGhlIGNvbmZpZGVudGlhbCB1c2Ugb2YgdGhlIG5hbWVkIGFkZHJlc3NlZShzKSBvbmx5IGFuZA0K
PiBtYXkgY29udGFpbiBwcm9wcmlldGFyeSwgY29uZmlkZW50aWFsLCBvciBwcml2aWxlZ2VkIGlu
Zm9ybWF0aW9uIGFuZC9vcg0KPiBwZXJzb25hbCBkYXRhLiBJZiB5b3UgYXJlIG5vdCB0aGUgaW50
ZW5kZWQgcmVjaXBpZW50LCB5b3UgYXJlIGhlcmVieSBub3RpZmllZA0KPiB0aGF0IGFueSByZXZp
ZXcsIGRpc3NlbWluYXRpb24sIG9yIGNvcHlpbmcgb2YgdGhpcyBlbWFpbCBpcyBzdHJpY3RseSBw
cm9oaWJpdGVkLA0KPiBhbmQgcmVxdWVzdGVkIHRvIG5vdGlmeSB0aGUgc2VuZGVyIGltbWVkaWF0
ZWx5IGFuZCBkZXN0cm95IHRoaXMgZW1haWwgYW5kDQo+IGFueSBhdHRhY2htZW50cy4gRW1haWwg
dHJhbnNtaXNzaW9uIGNhbm5vdCBiZSBndWFyYW50ZWVkIHRvIGJlIHNlY3VyZSBvcg0KPiBlcnJv
ci1mcmVlLiBUaGUgQ29tcGFueSwgdGhlcmVmb3JlLCBkb2VzIG5vdCBtYWtlIGFueSBndWFyYW50
ZWVzIGFzIHRvIHRoZQ0KPiBjb21wbGV0ZW5lc3Mgb3IgYWNjdXJhY3kgb2YgdGhpcyBlbWFpbCBv
ciBhbnkgYXR0YWNobWVudHMuIFRoaXMgZW1haWwgaXMgZm9yDQo+IGluZm9ybWF0aW9uYWwgcHVy
cG9zZXMgb25seSBhbmQgZG9lcyBub3QgY29uc3RpdHV0ZSBhIHJlY29tbWVuZGF0aW9uLCBvZmZl
ciwNCj4gcmVxdWVzdCwgb3Igc29saWNpdGF0aW9uIG9mIGFueSBraW5kIHRvIGJ1eSwgc2VsbCwg
c3Vic2NyaWJlLCByZWRlZW0sIG9yIHBlcmZvcm0NCj4gYW55IHR5cGUgb2YgdHJhbnNhY3Rpb24g
b2YgYSBmaW5hbmNpYWwgcHJvZHVjdC4gUGVyc29uYWwgZGF0YSwgYXMgZGVmaW5lZCBieQ0KPiBh
cHBsaWNhYmxlIGRhdGEgcHJvdGVjdGlvbiBhbmQgcHJpdmFjeSBsYXdzLCBjb250YWluZWQgaW4g
dGhpcyBlbWFpbCBtYXkgYmUNCj4gcHJvY2Vzc2VkIGJ5IHRoZSBDb21wYW55LCBhbmQgYW55IG9m
IGl0cyBhZmZpbGlhdGVkIG9yIHJlbGF0ZWQgY29tcGFuaWVzLCBmb3INCj4gbGVnYWwsIGNvbXBs
aWFuY2UsIGFuZC9vciBidXNpbmVzcy1yZWxhdGVkIHB1cnBvc2VzLiBZb3UgbWF5IGhhdmUgcmln
aHRzDQo+IHJlZ2FyZGluZyB5b3VyIHBlcnNvbmFsIGRhdGE7IGZvciBpbmZvcm1hdGlvbiBvbiBl
eGVyY2lzaW5nIHRoZXNlIHJpZ2h0cyBvciB0aGUNCj4gQ29tcGFueeKAmXMgdHJlYXRtZW50IG9m
IHBlcnNvbmFsIGRhdGEsIHBsZWFzZSBlbWFpbA0KPiBkYXRhcmVxdWVzdHNAanVtcHRyYWRpbmcu
Y29tLg0K
