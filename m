Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9C196F1374
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 10:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345400AbjD1Ird (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 04:47:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345225AbjD1Irc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 04:47:32 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CC7B1FD0
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 01:47:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1682671647; x=1714207647;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=FxrA27waeiDPs/QWEtwFv98hnVw7oQDr9RkFFTrmef0=;
  b=l4/LiKrnsALi8b3lSYJI/Vq1BQM3Td9BnLRLq2B0AwBIM7qnx+U6rnhW
   8+Bos+vp4yw6nLRo94QkJKfZCgqzUOKI18CUvawNrusTHF0O84oP2K4aJ
   yIxBcxbGRhz1BL4QTWArEiDaloUi9Yz0Qc9Aw58hxXAYtU9EFIwoN7ODG
   kkrzbhZQHJ/jipDJC+I9VzrhqDF+pHxrvBoMdrhvbqZ65IyerQO7ExQ7V
   0V+obYMOKFAwLHBPD3ZNkV7MwjDuXEaDxG2KAHtxPN3YSTfd64g90rknO
   W6gFKjXF65797yXpwzbpjkD96gLxT+gFCPrk/XQwRoSsMzI5piF3ZVG4h
   A==;
X-IronPort-AV: E=Sophos;i="5.99,234,1677567600"; 
   d="scan'208";a="211106302"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Apr 2023 01:47:27 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 28 Apr 2023 01:47:26 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 28 Apr 2023 01:47:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GE3G/0rEmPCQuhrt11N2hwHya+LlfgNHqkqMmdyGe+FOmWVB0PJy8Q4jEIOT8XwAkOn72XPRBO4w7ykO5w23ppZBT3eIBty9GwyFtrZUkqt1gfDsfj6Wn4BELlJaUysDPOhqLpzo4eWhUCpWsrUc3iOa4EGuSPK7FKNJbAvrf1UagIV7iLGrLLUyUdrc7ZXt/wJcvsTGzbFeXTGTLl19KtD84FvnK7zCgIqujkxEeyvt5OzGS8hxG4oIBFwcZBaxoosGLHekfBnffW2tRX3iVrLa3Yr59k++AFQ4fxrKm3WbdP4n9DdDyfDUAiiPS36m/v2YDh+Vc6zlkFLkP7oy8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8GovfLcgpbUU6NVduX2YF4Jbo/GqQjcb/aXADTrbJCA=;
 b=ErJQMKBuHPlzpQhB/kQ7JahagyicvlNJE8hkHaOTAc+hc12SqAsvm7uHQ0l0/Tat6+5yMo1PRwucKPk1lOWtlW8sdSVrWPkagWi0CweOrXsF26itqvyK6AQgAYmJ1wrIpTMEL1S8+lbJ3rws2FJE6fsE9UsODseKCpXKcDf2rQqklrrXtmnNVqkdnlAPqXlEvymWIlCRgcDoqsL1XIwGpodw37AHOJOCnAoIY0zbSPJsOTHc75HEaYp4outALfXu03xztIZyT7lpx9eyP+sfw4VnXUn9jesWzCMAKaYkzDB+IkwtWTqWuTCYktplFXBbYr3kegCxuT8Ymmh4IPjCjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8GovfLcgpbUU6NVduX2YF4Jbo/GqQjcb/aXADTrbJCA=;
 b=KGntycFNgdXXNsf2ZcaxAw5qhI/qFx0cUABHMtCgaU2JtG1IL3w95e27ewIJ8b6UyO7JJqCNqZlVyuF5N0vuDJYZW856XBA2DurkeQxGm3V0JF5HhmhFJnXqCeEAW/PkOYAFjoutl4AU4BSiZyrTKf9Pq8HSkCXafmXcuCDQCys=
Received: from CO6PR11MB5569.namprd11.prod.outlook.com (2603:10b6:303:139::20)
 by MW3PR11MB4524.namprd11.prod.outlook.com (2603:10b6:303:2c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.21; Fri, 28 Apr
 2023 08:47:22 +0000
Received: from CO6PR11MB5569.namprd11.prod.outlook.com
 ([fe80::4b7f:179e:442c:ddf1]) by CO6PR11MB5569.namprd11.prod.outlook.com
 ([fe80::4b7f:179e:442c:ddf1%6]) with mapi id 15.20.6340.023; Fri, 28 Apr 2023
 08:47:22 +0000
From:   <Daniel.Machon@microchip.com>
To:     <kuba@kernel.org>
CC:     <chris.chenfeiyang@gmail.com>, <peppe.cavallaro@st.com>,
        <alexandre.torgue@foss.st.com>, <joabreu@synopsys.com>,
        <netdev@vger.kernel.org>
Subject: Re: Help needed: supporting new device with unique register bitfields
Thread-Topic: Help needed: supporting new device with unique register
 bitfields
Thread-Index: AQHZea4LvTFt8Pl8xU+Bnj5RA3eqzA==
Date:   Fri, 28 Apr 2023 08:47:22 +0000
Message-ID: <ZEuIGbUz3x4r8KTj@DEN-LT-70577>
References: <CACWXhKnjyA8S56idVhSFgH1FLo-qBbpxU_ZBpdnrbvv9_kEY7A@mail.gmail.com>
 <20230424125357.55b50cba@kernel.org>
In-Reply-To: <20230424125357.55b50cba@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO6PR11MB5569:EE_|MW3PR11MB4524:EE_
x-ms-office365-filtering-correlation-id: ddb3d628-7a29-407d-66a5-08db47c52f20
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2/DEXEa7kDLwpH7PX8fPmdgBnpmc94BjBwb+LMNVjV6P3x+L72PtNSraExFxpgAw795LSxXa4JJZJxLpegjjN92mPuaKDXohHAKI6371pYamDnrY+Fie7Zj4Y2pFfhBeRKzK88tqr7ylmf1Ow6E4sLpiKvF49FkteQzDekMuNzqhKV9Qxk2Tq50ztRVXiVd9J9Q0Fe2lnF1ATreiYyUeCnLGOT+jNNmb26Hu8dA5CoM9PAnnWqA3Hw7u9P+Cnk/+H58qyTStd5dc6PCBmclkqxgm9cYAVGb+dzYmxbh4kbdfKQI5pdbI2iIIIxbVBfbsSyd+UtEttnLvggw4UqTBJhmgMrGwkfIoySUitqawjDd5h8KwdPVrGA0+Vcf4DTGovzl8IOPwBYd6KX+tGn2z7EvBOLUtBJ2nGAJU6xSzQnhhoKFmAIWS3Dow+ZJKRuN1vAKKw6VDJpspKIu9zfm3qrP7Z4wHWlT8B6oo0aXOSLS9+6ZQbWFUZbk2mLdrI0rVLsMx3PhgSni7ch/zfNZ6nvlr5uKUVIN5QjrtQh0swHIiuRi7s5REOYrAF+R8VVzs0zatswRlRcdYYG4kPxKq0kfM0l66PaUBbUYmO64JSTd84SnCWNRzaI56r9vEgfXN
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5569.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(136003)(376002)(366004)(39860400002)(396003)(346002)(451199021)(4326008)(316002)(66556008)(91956017)(6916009)(64756008)(66476007)(186003)(83380400001)(66946007)(76116006)(6486002)(478600001)(54906003)(71200400001)(8676002)(66446008)(122000001)(41300700001)(8936002)(38100700002)(6512007)(5660300002)(26005)(9686003)(38070700005)(6506007)(2906002)(33716001)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?QLdPR1Y7nXQEJKLqLqXVF+f3S8QE6GIFIiftfZFO/SQBmsZJe+5r8onsAeE2?=
 =?us-ascii?Q?7EGgaicXPxicJDZ7aEJT3LRABWA/ygOKFzQAF5HEB2PQ3PAHU7vcGqLZGcIC?=
 =?us-ascii?Q?+fRxhRt0jnYQY/6j2c5N2VdicMsVDo0kUiESccqHUm+Cd96VLernNqVWD6ff?=
 =?us-ascii?Q?vFTtn+RlDduCf4RuBDjCHCYIfZ/e/dOz3+BY43+D9NJGwRPZtrvWlMSHILNb?=
 =?us-ascii?Q?9E/j4txoJkVnuQ3mprllemUFeYPZS94dpLjEhusnhLW+7w7iio557tbp4FWv?=
 =?us-ascii?Q?TsXCKmOVTQDPwuEU9HGszhFOWfgJZGLuO1++0zAsmUC1Ibs1VQtlP2mw8yjg?=
 =?us-ascii?Q?M2H2ax3pi9MvFdh+s1bb+0EzvGGP7x1bGv73nncCwA0ey6t3DuZ/LhClyHEy?=
 =?us-ascii?Q?i8mfGaUF0B6qey5BdkDBOyFH0Z3k3RxiYTjo36W7mTXsmuXKM2nsDZ9buDO4?=
 =?us-ascii?Q?LGcC1zmDi+B1xQYhuDfY19yW/RAPpm8PQgwxwI7arTidNp6SgKHWPxd3UNn1?=
 =?us-ascii?Q?mOup/hUgbn3gd8x6JdbjFAUaF3PjrU8+1bl3Czw6ErxF4FDJqs+DVfISl0TN?=
 =?us-ascii?Q?3K8ZPP8NYXHJ9IKr7h6Zs6ZvFEv0pvPacLvv+79BWtJC8rgF/LN3LSqWLqi5?=
 =?us-ascii?Q?Bs1MA8y7v60x72TBZ5z3vBQqTzChe5SbhynSVqX1Rk8VvzcbGpXlehVykdwW?=
 =?us-ascii?Q?H+T1aIFIbjUFltLoKAMgatAzk1PofRyt0YLYYMhKfR39+F0vngAvRwSAFA1j?=
 =?us-ascii?Q?z+fNshhv6f10waBW+K9I2071YsxhysVYkWag2adqdTLb2vK98BvDGrO2mnep?=
 =?us-ascii?Q?uYbgxIDNZSdkM2R2vDEg2HAVtpO+/DQdFox/o/AxcPhdZefDOSJTSNhbhpLI?=
 =?us-ascii?Q?beLDqSoEEpCAXGsJAeTwZSZ3ARxmOyWhLaHs3dVCfeCB8nPiECv453II5/pZ?=
 =?us-ascii?Q?omORqYJ7OWesIL40PHUdffwdQi5FAgh3ccMjl2AqZp0DLpBF8XLlhvv46nJm?=
 =?us-ascii?Q?8hx3/Ji1tYGtmrqUSjeDSBRKqz1Z5yF1y18bQW/dd0tMNONV1VU1kvu6N4Xg?=
 =?us-ascii?Q?cj+isCkH5qY4RFHn/gk3gT94h++bwISuUmaj7ZNnoWOWlx4zSaSfUlitCfSM?=
 =?us-ascii?Q?Yp0/EbMITz/sv7uF1eoY1rEZo6HcLFa2qYHGc/Rf6p/0rsmNNJoOWZY1l81p?=
 =?us-ascii?Q?3NTm1yhVd7HMF9KYyk9MiaHk8IFzkv/DCou8NhXswSLIAe9pEyaHxs3PmFXx?=
 =?us-ascii?Q?0y6ls1oqbRq/KLwREscumi8wMofVnXxD1mwYseivFDNTzfCTzeZ1gWEAla0j?=
 =?us-ascii?Q?3NEPsKhFS7e2xcHlgEhxXFXM1HdFYAwStmhIobz2BfYoOQHGN8ckopW1NFW9?=
 =?us-ascii?Q?DV/ylvOV8yrDqbnb8ysHIZebNpccfAL4weLq0HHyaURrCf9FDI6Jg94vTVr7?=
 =?us-ascii?Q?lb/8tUk09cAjiZy/CGqIlVo1et+HHFdBiGulKYJcT4HQTWL7gUKeumzlsyki?=
 =?us-ascii?Q?J3z8A+ge+TWAuJ2YM3Fohp+htC39xvz6bLo0eNfU5rxdtH+ZNL8aQFXpAsLT?=
 =?us-ascii?Q?B5ozT74mtD6/4MJMt5oELVM4M0CMwTt2XqGuIDbaeJNTlRds/ZJzVrKN1QvZ?=
 =?us-ascii?Q?7w=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <899FAECB22F20343B67B775FE6074221@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5569.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ddb3d628-7a29-407d-66a5-08db47c52f20
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Apr 2023 08:47:22.7497
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: baVQUuZWmaBBlYQAf95lKQbedjlOs7nHHMzA5QRtcA0s+ksFdGUwlg0jAUzMTvPU7JDMVw2m78K+yurMfBrTyBXs0e13ux4lxySCVPDOY3A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4524
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Den Mon, Apr 24, 2023 at 12:53:57PM -0700 skrev Jakub Kicinski:
> On Sun, 23 Apr 2023 16:19:11 +0800 Feiyang Chen wrote:
> > We are hoping to add support for a new device which shares almost
> > identical logic with dwmac1000 (dwmac_lib.c, dwmac1000_core.c, and
> > dwmac1000_dma.c), but with significant differences in the register
> > bitfields (dwmac_dma.h and dwmac1000.h).
> >=20
> > We are seeking guidance on the best approach to support this new
> > device. Any advice on how to proceed would be greatly appreciated.
> >=20
> > Thank you for your time and expertise.
>=20
> There's no recipe on how to support devices with different register
> layout :(  You'll need to find the right balance of (1) indirect calls,
> (2) if conditions and (3) static description data that's right for you.
>=20
> Static description data (e.g. putting register addresses in a struct
> and using the members of that struct rather than #defines) is probably
> the best but the least flexible.
>=20
> Adding the stmmac maintainers.

Hi,

I thought I would chip in, as we are facing a similar case as described
here.

I am working on adding support for a new chip, that shares most of the
same logic as Sparx5, yet with differences in register layout. Our
approach has basically been what Jakub describes.

- We use a macro-based approach for accessing registers (see
  sparx5_main_regs.h). We have added a layer of indirection, so that any
  _differences_ between the two chips (offset, count, width etc.) have
  been moved into respective structs, which is then consulted when
  accessing registers. This allows us to reuse most of the Sparx5 code.

- Any unique chip features or similar are ops'ed out. In a few cases
  handled by if's.

- Additionally, chip-specific constants like port count, buffer sizes
  etc.  are statically described for the driver.

I think this has worked out pretty well so far. But again, this is
balance, as Jakub said. If the differences are too great, it might not
be the best solution for you.

/Daniel
