Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 817B74F8657
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 19:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346455AbiDGRi3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 13:38:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiDGRiX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 13:38:23 -0400
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53B3D171EF9;
        Thu,  7 Apr 2022 10:36:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649352982; x=1680888982;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6r1k0d+fJquF14UXBewpmE326cNSVSaifSIL27K83g8=;
  b=aRia1ruaAN5K2A8tM4Pv2N1dq9tQKJ0u0h1k4j6MJGMAyVPruGjwWIGz
   Zq63P1HrNqVmPMmalk20gs1qcS3KezwF5x8fDJY0xyCa8bZli4VGk80PE
   YKWfNt0tFqtxEmE7W/urjfwbWyc9JsGZSU/CJu0L3/ix7C/2IKDRoRu7j
   JwDlCVyTR2Qvyuqdpgn82rg/ceLDS20iixofjFs21gIDGrwbLnVajOX45
   +IcXrx3Lzd/WVbzyirnyee9apNHLPK3rt16LkQ1I2k2CdM87grye5W7ei
   kt9fafv6yb4Vpi2/SMFLYhcKYv/UVSKb3Xh48/RW71+vROBa8cKYe68jZ
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10310"; a="322083229"
X-IronPort-AV: E=Sophos;i="5.90,242,1643702400"; 
   d="scan'208";a="322083229"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2022 10:35:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,242,1643702400"; 
   d="scan'208";a="571153394"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga008.jf.intel.com with ESMTP; 07 Apr 2022 10:35:55 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 7 Apr 2022 10:35:54 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 7 Apr 2022 10:35:53 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 7 Apr 2022 10:35:53 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 7 Apr 2022 10:35:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lvcqOUVMjnnVLa+D8n1wyS+7ULkgBPUH6kerMhrpX9c5+Q1pehjL4++bdOaeqPafjznuoV/QhPHg4EomoubxcFv2IRGN2LlGfuuGIhmsZ3Npi9MGCL5bii3RBJlGGLExayy2VvGY/QdOzzoPrvomKdaXkSGCxrP2n+23+62MgF9huy1R0FshwbYVaT+w/5oE56GbQQ1IL+Dx28iyKud8hzfB2+NlEyBafQM/osBnF6Xqb/MwMx1JXBCUzAv33XzqZxfT4R8SjT+w2o0MnBiXNbltL+AySu3xKVbx+0KPXHcaptEZA+AKlAJgEDxFYKr2YmBCadIVlPJCSqQQ8MexAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6r1k0d+fJquF14UXBewpmE326cNSVSaifSIL27K83g8=;
 b=Mpx3K612spOIyLE+7CwOI1DY136dzeUrAAfOW87rupEyfFy3vNu/j/IHKIBgx42as6Zb2yEKkC58RFPlwSBJpfPOIXPdLYYLSdfZBt50BGCNiC8uyeTDHcQVu5Wxf2K4q+hsFvbFSZVHV2JaV2McoNwUwEuw0qTHIA4B/7QVn7rcDTc8Ev46+HgVipg1eNSX3MVCTFk1KuOP2BuQlj5zaxey7UMkNvFMtYNgVJEUNndE4h5mG2d6E7SAAzf+WCki1ZT1zUW/jfX1M2DwjNnqdl0VvB7r8AED30ZTTqVozY9Qzn4T+iOIy/xyflqEQ5uyWbLyKW347rGr85d+TCPdnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MWHPR11MB0029.namprd11.prod.outlook.com (2603:10b6:301:67::25)
 by BN6PR1101MB2257.namprd11.prod.outlook.com (2603:10b6:405:5a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.22; Thu, 7 Apr
 2022 17:35:48 +0000
Received: from MWHPR11MB0029.namprd11.prod.outlook.com
 ([fe80::ac0c:4806:934a:636c]) by MWHPR11MB0029.namprd11.prod.outlook.com
 ([fe80::ac0c:4806:934a:636c%6]) with mapi id 15.20.5123.025; Thu, 7 Apr 2022
 17:35:47 +0000
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     "duoming@zju.edu.cn" <duoming@zju.edu.cn>,
        Jason Gunthorpe <jgg@ziepe.ca>
CC:     Dan Carpenter <dan.carpenter@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "chris@zankel.net" <chris@zankel.net>,
        "jcmvbkbc@gmail.com" <jcmvbkbc@gmail.com>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "wg@grandegger.com" <wg@grandegger.com>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "jes@trained-monkey.org" <jes@trained-monkey.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jirislaby@kernel.org" <jirislaby@kernel.org>,
        "alexander.deucher@amd.com" <alexander.deucher@amd.com>,
        "linux-xtensa@linux-xtensa.org" <linux-xtensa@linux-xtensa.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-hippi@sunsite.dk" <linux-hippi@sunsite.dk>,
        "linux-staging@lists.linux.dev" <linux-staging@lists.linux.dev>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: RE: Re: Re: [PATCH 09/11] drivers: infiniband: hw: Fix deadlock in
 irdma_cleanup_cm_core()
Thread-Topic: Re: Re: [PATCH 09/11] drivers: infiniband: hw: Fix deadlock in
 irdma_cleanup_cm_core()
Thread-Index: AQHYSkn4HJrzWeSt/0qrCBQuiFUlDqzkT6MAgAAY8oCAABkQgIAAA/+AgAAwVIA=
Date:   Thu, 7 Apr 2022 17:35:47 +0000
Message-ID: <MWHPR11MB002901B734D3974439D9C34DE9E69@MWHPR11MB0029.namprd11.prod.outlook.com>
References: <cover.1649310812.git.duoming@zju.edu.cn>
 <4069b99042d28c8e51b941d9e698b99d1656ed33.1649310812.git.duoming@zju.edu.cn>
 <20220407112455.GK3293@kadam>
 <1be0c02d.3f701.1800416ef60.Coremail.duoming@zju.edu.cn>
 <20220407142355.GV64706@ziepe.ca>
 <403bbe08.3fc24.18004762739.Coremail.duoming@zju.edu.cn>
In-Reply-To: <403bbe08.3fc24.18004762739.Coremail.duoming@zju.edu.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.401.20
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1731c270-4f88-49c2-4314-08da18bd0d6e
x-ms-traffictypediagnostic: BN6PR1101MB2257:EE_
x-microsoft-antispam-prvs: <BN6PR1101MB22576CC08A32AC6989B82937E9E69@BN6PR1101MB2257.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pW8zg2aCcoOwLVIFozk/O0iBCLipHBHZBRHQCsvzzLjunsC7947PHi7dFKeqdShizibeGc+TRb3DdSE/ZFlnP/0oESUYIrz+fSPviqhQBrK/dl+is4w+hV72F/RRNn6QS/95xsljA9NqrLUAL+yUw8fKgm5RkZhXiGqOSS9TB1MYRynelT76O2k/BTZf30qpF66ntT0LOIMjfMl8e4YW07e/7B4GeCvVgMYPm6B1XIVJ4Lv1PBRqezrdh6Fjuc4BBICwioNR6b8Nj1o8kE4S/TEhZcn7A+pjHuBNu1ZkalEBZhOrcX0dM9QYy7a6M2WTrZ+2d6yS8TCVZn7PBIjWMSL/JO1Gm+wFD6EKCoMD6jjZA+9JCR0mzzRaEZUP8wz0Pi+J3JdOnV4SQWzrZX9Dp21ClDr9Ch94R5t/ASsvPYeQq5I/gBwc7qScXfBEZoAKqHTiiNK2GtCweiDoRy3grG37MFemj/oiyQg8p21rGsqBO9iXZGW9a5gFcrpImzX7poZ/IwMgqNjR+pKcvjN8usc6ViveqUhB/KPM2ErXC6K7kHYGaOjFyJzDPff3M1Uhis1zEW9NqtYSR93Wymu9+2jx/4nOMwA3ZphOwP+uRthVYUP5LdkqA/YCLg87N8KDv0s7f1SAsyAoq06msL6kB1mQv9hBJ1x/xZnI2Ir6ezLSf59lgqg6viW1x46yOkjIlIIvKTLjXG+aF3NhXPqHTA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB0029.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(76116006)(83380400001)(26005)(8676002)(186003)(66476007)(66446008)(64756008)(4326008)(66946007)(86362001)(38070700005)(66556008)(82960400001)(122000001)(52536014)(55016003)(7416002)(2906002)(38100700002)(5660300002)(8936002)(33656002)(6506007)(9686003)(7696005)(110136005)(54906003)(508600001)(316002)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UE0vaVZ3LzVobWprOVk5dHoyMHdVSkMvNVdub0thT3VMVmpWWVRSQnU1L1JF?=
 =?utf-8?B?cWZ6SXdDTkJHQ0JGWnY4ZmJrRVpCTXpPR1dsc2hnS2ExbUplU3A2M0N3Nm1l?=
 =?utf-8?B?OUtKQ3JqSW1KNkRoM1pnVjhlRGNhUkJDdmtuSDQ2K2dUcGgvNUJzNHRTU3Bh?=
 =?utf-8?B?NnJ5VUFFd015UThHNndpc2VsSFZUak5JanNQaEY4RkhrV3FOYXEwZXRQYXBi?=
 =?utf-8?B?SU9BcWgya3VqeXVuelFtdXJmMU00cmRvTGgvT3I2NkVmZ1hWdkQ4UDZkeUI3?=
 =?utf-8?B?RWdhWXU3L3EwakUwY1I5OExGRjNORGpVNjB4MXhTZkJ3WG83RzlBaEVvVDN6?=
 =?utf-8?B?R1ZlZDJSS3UzUm8ySVlEdzEwM1BqS0NpWW9EUzE4V3laOE5xMW55TGJXdlZT?=
 =?utf-8?B?bjNpSk1vbzdQTTFHQkd3TXR3dmZCTzl3UEJIdGtrZ3pNR1JDSjRWbldwSU1B?=
 =?utf-8?B?cFc0ZzA2ZVhmYWRIRFp6RUdpMVBSRGx5WXdLcmJTcDV5S3FpN2l1czhuTlVi?=
 =?utf-8?B?Y2lUVzdYUmFHUkpEZExlT1F2dmFFOHF1a1VtOTVTblRhZTRNSEZQYWhodTQ1?=
 =?utf-8?B?WDJTTFBXaDRaQ1U5dTVOYlh4ZjlXTU9HMnNSYWxTRGNEQXVqdGhQQ1NHcmp6?=
 =?utf-8?B?Q1RGb1lWNXQxLzNZQnB4eVpjK0VpWjJwUXFuL3VWZEVZQXVqamVDeFBlL215?=
 =?utf-8?B?cFlOSTB1cWp0OWxXWkxLUFVaY3lrUlc2bUo5a3VGYWNFdi9XTlllSW42TmNE?=
 =?utf-8?B?dHVGQmZnVWFBYi8vbEdPV0p5MVI4SSswcXVlcWsrUXpLOTQ4TzMvWUl1Znht?=
 =?utf-8?B?SFdOa254c0lRWFM1L2dvWndTd0NZaGVvdFZLbm41N0pKWW11WE9MeVJ1RW9x?=
 =?utf-8?B?WEY5c1RqdGFoTkFJR2VLd3pVM2dzR0JDTWkzeExjQUkzc2wydEVhOUpmVDFo?=
 =?utf-8?B?Rk80bTlobnNwZnV6MDEwZHAxWDdvNVhkbEVOYllzRlBSZ2ZuK0tyaGVyYW9Q?=
 =?utf-8?B?dWw4cnRXT2hZaXNWTWFJRFg4RUtpU3lSZks0RGE0clFBaVBHdmIwY2ZxV2Jz?=
 =?utf-8?B?OTAzWnRURno3aUxvMXJpc0kxQ0IreWkwSHV2U1ErbTUxUVNFQlY1WE45VlBT?=
 =?utf-8?B?ZUd5SXNTOW1JQ3lJNjgzTVlpSHRxdEEyNmlMN1h3K1VUZmJlbkdqaVd3Rnhj?=
 =?utf-8?B?L3d0c2ZWREY1Y0RQLzV3ckpweUJ6cjJqUEpBc1kvQlJDc2RLbkg3L0M5Uld4?=
 =?utf-8?B?NklBVkVaWnNkdDMrRSt1d2hheFRQdTVydFdHMWNsL0hEMVdmanZ3VzRBTE1p?=
 =?utf-8?B?MVJXUkpLbjQzclNFWXNLU1cvNHh6R2M3WTh6aXkvN05LQmEvakczZHdReW0y?=
 =?utf-8?B?c200Sno5YWVtSHJ0Z0x1RVJKcXRPRTJlZk52UHZhNmVuOWZJNkYwZjFVUi9i?=
 =?utf-8?B?NElWc05iS3JNZ3dYb1ZiMWxGWTNaMUE2bjhNZkV5U1JnTGxQaFJLVDhsck9x?=
 =?utf-8?B?NEFpU1FXTEoxY2hpTXg1VWYyV2FqRmxudWhONVdnWXMxVXR2dkswd1dUK2lF?=
 =?utf-8?B?eHAxWWNpRzUwbEZlRVMycnBjaFU2d2w1cG1QVkhRY0l2REd5NHlyQVZuRGNJ?=
 =?utf-8?B?cHRjQ0RaMnRRc0tLdGdvaWJveHU5OTRYN216c1Z1eWpIVTNET2JkNG1HcG9p?=
 =?utf-8?B?VUxuWWduYUtCamVhbUlmd1g2RnV4TGJTNzhTVm5Eb3huWjN4elFiT1JzQnc2?=
 =?utf-8?B?TGJNN2NJbU9zNGRwUDcxa1N2QjkrZTJ5M1BWMXJxZWtrRFM0U0lXK3BsSHhk?=
 =?utf-8?B?NE5GZzBGV3h1WThDMXAvSWg5M1JhNWFYc2YwL3lvS2VTUDhGZllyeXcwOXI5?=
 =?utf-8?B?U3M0QUFzWWg5WmJiTzlCREw1S3pHZ3pnRUpsYTJkaDdRNm00SkJVOFNFQXBJ?=
 =?utf-8?B?Q0dnRFIvN3haOFV2T2dQM2RnMzllZndOSjM0QXBvdXpSVWZ3cFYzcGNPTjNp?=
 =?utf-8?B?SWUwbVJyRlpIQ2JxQmFZc001VWhyRmpMaExJYVJscDFVSjdpNjJKak9VcnRS?=
 =?utf-8?B?ck1XMXhtdVlNdnJhd294NlE1bnN3cXQyblNBUFBHUEd3VFFFR3F2a0JHdGMv?=
 =?utf-8?B?d1pLYnBWRjNheDB2RnBzVzBmM21jMGpKbkxab0JjYVJHUmFWcEtRcFBaUW5W?=
 =?utf-8?B?d3czdGlhTUdlT0lzSzdUT0haOWlEYUV6Nml2M1lkK3dEd1dqRHJNaXMvNXI2?=
 =?utf-8?B?OWV5cEcwZU0zYTJINGx1Nno5UHE4Y1NEVG42YTBzbThZSXFrazZzbDJkemUv?=
 =?utf-8?B?aFRUa2R1Y0xydUNQUW56ZEtKS1l2TDhheFBUbjYrcmlCUTF2MHFBUT09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB0029.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1731c270-4f88-49c2-4314-08da18bd0d6e
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Apr 2022 17:35:47.8468
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kou6XvPzj1mrRc8NTJn/RY13vQOqZVFmIPYy68bIs1Q2Pqq/S44wTw1rp2K/Bb4nu4KsCR0sUfymKZcFe6zm2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1101MB2257
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBTdWJqZWN0OiBSZTogUmU6IFJlOiBbUEFUQ0ggMDkvMTFdIGRyaXZlcnM6IGluZmluaWJhbmQ6
IGh3OiBGaXggZGVhZGxvY2sgaW4NCj4gaXJkbWFfY2xlYW51cF9jbV9jb3JlKCkNCj4gDQo+IEhl
bGxvLA0KPiANCj4gT24gVGh1LCA3IEFwciAyMDIyIDExOjIzOjU1IC0wMzAwIEphc29uIEd1bnRo
b3JwZSB3cm90ZToNCj4gDQo+ID4gPiA+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvaW5maW5pYmFu
ZC9ody9pcmRtYS9jbS5jDQo+ID4gPiA+ID4gYi9kcml2ZXJzL2luZmluaWJhbmQvaHcvaXJkbWEv
Y20uYw0KPiA+ID4gPiA+IGluZGV4IGRlZGIzYjdlZGQ4Li4wMTlkZDhiZmUwOCAxMDA2NDQNCj4g
PiA+ID4gPiArKysgYi9kcml2ZXJzL2luZmluaWJhbmQvaHcvaXJkbWEvY20uYw0KPiA+ID4gPiA+
IEBAIC0zMjUyLDggKzMyNTIsMTEgQEAgdm9pZCBpcmRtYV9jbGVhbnVwX2NtX2NvcmUoc3RydWN0
DQo+IGlyZG1hX2NtX2NvcmUgKmNtX2NvcmUpDQo+ID4gPiA+ID4gIAkJcmV0dXJuOw0KPiA+ID4g
PiA+DQo+ID4gPiA+ID4gIAlzcGluX2xvY2tfaXJxc2F2ZSgmY21fY29yZS0+aHRfbG9jaywgZmxh
Z3MpOw0KPiA+ID4gPiA+IC0JaWYgKHRpbWVyX3BlbmRpbmcoJmNtX2NvcmUtPnRjcF90aW1lcikp
DQo+ID4gPiA+ID4gKwlpZiAodGltZXJfcGVuZGluZygmY21fY29yZS0+dGNwX3RpbWVyKSkgew0K
PiA+ID4gPiA+ICsJCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJmNtX2NvcmUtPmh0X2xvY2ssIGZs
YWdzKTsNCj4gPiA+ID4gPiAgCQlkZWxfdGltZXJfc3luYygmY21fY29yZS0+dGNwX3RpbWVyKTsN
Cj4gPiA+ID4gPiArCQlzcGluX2xvY2tfaXJxc2F2ZSgmY21fY29yZS0+aHRfbG9jaywgZmxhZ3Mp
Ow0KPiA+ID4gPiA+ICsJfQ0KPiA+ID4gPiA+ICAJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmY21f
Y29yZS0+aHRfbG9jaywgZmxhZ3MpOw0KPiA+ID4gPg0KPiA+ID4gPiBUaGlzIGxvY2sgZG9lc24n
dCBzZWVtIHRvIGJlIHByb3RlY3RpbmcgYW55dGhpbmcuICBBbHNvIGRvIHdlIG5lZWQNCj4gPiA+
ID4gdG8gY2hlY2sgdGltZXJfcGVuZGluZygpPyAgSSB0aGluayB0aGUgZGVsX3RpbWVyX3N5bmMo
KSBmdW5jdGlvbg0KPiA+ID4gPiB3aWxsIGp1c3QgcmV0dXJuIGRpcmVjdGx5IGlmIHRoZXJlIGlz
bid0IGEgcGVuZGluZyBsb2NrPw0KPiA+ID4NCj4gPiA+IFRoYW5rcyBhIGxvdCBmb3IgeW91ciBh
ZHZpY2UsIEkgd2lsbCByZW1vdmUgdGhlIHRpbWVyX3BlbmRpbmcoKSBhbmQNCj4gPiA+IHRoZSBy
ZWR1bmRhbnQgbG9jay4NCj4gPg0KPiA+IERvZXMgZGVsX3RpbWVyX3N5bmMgd29yayB3aXRoIGEg
c2VsZi1yZXNjaGVkdWxpbmcgdGltZXIgbGlrZSB0aGlzIGhhcz8NCj4gDQo+IFRoZSBkZWxfdGlt
ZXJfc3luYygpIHdpbGwga2lsbCB0aGUgdGltZXIgYWx0aG91Z2ggaXQgaXMgc2VsZi1yZXNjaGVk
dWxpbmcuDQo+IFdlIGNvdWxkIHVzZSBvdGhlciBmdW5jdGlvbnMgdG8gYXJvdXNlIHRpbWVyIGFn
YWluIGJlc2lkZXMgdGltZXIgaGFuZGxlciBpdHNlbGYuDQo+IA0KDQpCeSB0aGUgdGltZSB3ZSBl
eGVjdXRlLCBpcmRtYV9jbGVhbnVwX2NtX2NvcmUgYWxsIGNtX25vZGVzIHNob3VsZCBiZSBjdWxs
ZWQgYW5kIHRoZXJlIHdpbGwgYmUgbm8gdGltZXIgYWRkIGZyb20gdGhlIHRpbWVyIGhhbmRsZXIu
DQoNCkFuZCB0aGUgc2Vjb25kYXJ5IHBhdGggdG8gYWRkIHRpbWVyLCBpcmRtYV9zY2hlZHVsZV90
aW1lciBpcyBndWFyYW50ZWVkIHRvIG5vdCBydW4uDQoNCg==
