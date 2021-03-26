Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36F2634B330
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 00:54:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231195AbhCZXx3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 19:53:29 -0400
Received: from mga03.intel.com ([134.134.136.65]:46565 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231217AbhCZXxW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 19:53:22 -0400
IronPort-SDR: s4Y3tU34cdcW+xWvPhlPriFRZ7Q3qOHRKEDwDDsXAQ59OoaYTqEvE5ldHxzeZzcZDaeyYl7i59
 SkBmItJoERPA==
X-IronPort-AV: E=McAfee;i="6000,8403,9935"; a="191270783"
X-IronPort-AV: E=Sophos;i="5.81,281,1610438400"; 
   d="scan'208";a="191270783"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2021 16:53:21 -0700
IronPort-SDR: 2K304jHe4SMm0DWBUoFl1kFh0+BQ9E0gR+ECog+G9CfjNTqN9NjELIwzTeLrm5vyrLQFJNbmbE
 XlrZSlmmCOCA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,281,1610438400"; 
   d="scan'208";a="526205123"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga004.jf.intel.com with ESMTP; 26 Mar 2021 16:53:21 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Fri, 26 Mar 2021 16:53:20 -0700
Received: from fmsmsx605.amr.corp.intel.com (10.18.126.85) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Fri, 26 Mar 2021 16:53:20 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Fri, 26 Mar 2021 16:53:20 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Fri, 26 Mar 2021 16:53:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lRojzCH12nVLYuTNTKw8hT8xgitKNB7+MCw3zYWy7DeiVDiSSjCLmy8XE7KJJUyG/4cTJ+lEVizxAofenhbfv+CDOJJwxH6cTmrpRV6nzbczH92C6eYRj2zKb9yZK9zB3nSB9PqMhLGLh6cgAMBwjdFMvjfXOShr4irVQAdsK7T6AbdCjgjmvsl//aymBy2VLQ3a2O5o/9jB8jmZNktk5vSWvM0cpouGee+ypDGcRqVlsKHry3VvACJ7yxo3o/hi2w9aOKkQgBaoqgGlTyBinMiILYd8sYMImXzw6Lt92+HHu4bfX+HWKsIVGTeXsbzKgiWEZMqciTs31e/lwOoytg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qhkVFhENtf4jFWpeKQsbmZCZt3Vw5qABNQbnh/NLZKo=;
 b=IcREeYHrvbdWYHVS4oqR4rqkTpdBALulQiLqotahQb/rCGbasNdzAxz9E2DW/vtPYG9hXBNz/lmqvRbTgIXPcGFCNloNPAGm7P/kLarKegAVbG9wD1nULnC4td+L7ARYb7cgjtoQcwgueAX2DTCYyhBRB6S3mnWxB9zTa7APq7Z4rFlVZONk7Kzuv+SvJiVaftlNa4zaQzak8vQarJ1rMWlcOAWTTkq/2u85AKaCYJlb/ptEMCo0VgxeAb2CI9gwkcOveNnWAcPC72o9RwKNtT0oIkbSp+eZAGCB3ZRwiDPKWqh6+Ka5Tmq7n4Yyvr5g7rjunmxwqWO8+zzC3zDE7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qhkVFhENtf4jFWpeKQsbmZCZt3Vw5qABNQbnh/NLZKo=;
 b=K1+6WWT0oRcdxKpEQeS2vspMO3R3wlOcEyiXt/kJMC7zoXmZaFEGbaTuqcvQd+9UW0g406G7qvduZryWAQGTvUJdNvGE8ITLhTe5LSHT2t68v3nhonv6W2hkOPwnuTsejt55sCuerZ9dc/ctm0WBvAbNU7W8k06XaEydLmqfSOc=
Received: from MW3PR11MB4748.namprd11.prod.outlook.com (2603:10b6:303:2e::9)
 by MW3PR11MB4764.namprd11.prod.outlook.com (2603:10b6:303:5a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Fri, 26 Mar
 2021 23:53:19 +0000
Received: from MW3PR11MB4748.namprd11.prod.outlook.com
 ([fe80::a995:ea7a:29cf:d212]) by MW3PR11MB4748.namprd11.prod.outlook.com
 ([fe80::a995:ea7a:29cf:d212%5]) with mapi id 15.20.3977.030; Fri, 26 Mar 2021
 23:53:19 +0000
From:   "Switzer, David" <david.switzer@intel.com>
To:     Chen Lin <chen45464546@163.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chen Lin <chen.lin5@zte.com.cn>
Subject: RE: [PATCH] net: intel: Remove unused function pointer typedef
 ixgbe_mc_addr_itr
Thread-Topic: [PATCH] net: intel: Remove unused function pointer typedef
 ixgbe_mc_addr_itr
Thread-Index: AQHXA5L40aNuxmRNDkizZVine2FEXKqXLqiA
Date:   Fri, 26 Mar 2021 23:53:18 +0000
Message-ID: <MW3PR11MB4748E41F960FFD9288486D53EB619@MW3PR11MB4748.namprd11.prod.outlook.com>
References: <1613390698-3637-1-git-send-email-chen45464546@163.com>
In-Reply-To: <1613390698-3637-1-git-send-email-chen45464546@163.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: 163.com; dkim=none (message not signed)
 header.d=none;163.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [71.193.239.129]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 90ea1779-5f36-4aa0-260f-08d8f0b254d5
x-ms-traffictypediagnostic: MW3PR11MB4764:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR11MB47644646DEEFF2F7B721DA1BEB619@MW3PR11MB4764.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:381;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Y1Prw147U/voVQ/ESgIidA0uyjdCsz/cisoVldrE1s31/Bg6hmzXtzqX9Q7bCow+2s6+EcNZ9dBn9s0FOjcN8ZURrDmTMTTHv238sdZl+Tig3Sy7TA0MeMTCntDPUQCO8tKRrDtVDFi5Udgzx1EJff0BNzLiKntsanjtIrDnna4RG/CeoNyjKdCbuSm2FvPTiw7WAPXdlvLydBgZlQkKnCWU8nBdurvJqQL6/eMP+H2B7DBFMA4zkanfKMsJfJJc6B2hoCxHczp1XmEczOLBxcveq+gCfCnpnIX6qPd/qRieoFevcFgqpihq4yiTCoh5bnYwQ8DJkjj/u1VaK61u6kx9mAM+J9/uu6lhk4lxzc8noG90tosHgyjetiGX9FyKRkau04uQKW6EvIb8b5RZWZlE2sXmhqVUtBa6xiHmzLVRiYhDBvrf8iYg8PYK7/gqd9TgqyxmuCXETw3oTaol+8bXfcr8iZnZIPnFj6ZKFwbSsjijLzwv/1fejdLFoQbv1mekg/XQvkP6pbZWWNvR6j3R1kXV08I7kyR/JM52B8bZek50F4DAVSNyy/m3MrfcgDBua7+kSYUoDVcUw8Wj8uamIZiMq7Ib1s4hJI+GywN7uegVwcPXDaL7vo9aHEmVVdXbgDslqxyFV0T1ax5un0lf8EpCp6IlpF1gYCNMSr4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4748.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(376002)(346002)(366004)(136003)(4326008)(186003)(38100700001)(26005)(478600001)(316002)(54906003)(33656002)(55016002)(9686003)(110136005)(86362001)(83380400001)(7696005)(2906002)(5660300002)(4744005)(76116006)(8936002)(6506007)(52536014)(64756008)(8676002)(66446008)(66476007)(66556008)(71200400001)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?PBqirQX5dQpeMSE3rlhCv+fq9a3+eoxkF3EiRQWMStmus5tZvdZXmaBgZYPZ?=
 =?us-ascii?Q?0ODlQhYembANvQA9F3PPO85srbQ9K2IMLJFuTJ1vhVVXNjvoVnlwBhoXJ0la?=
 =?us-ascii?Q?ttZ92hj6NDezZiyk86zmdYEZ2AreMr3lxZpnQtPYaSwFrg0RKSTqIZ7IBDCj?=
 =?us-ascii?Q?EAKreTe4kqfUilptLK0VT5/mTIU5UFT6TYsf2WrLNUTKj69wimQ9a6PyLFZx?=
 =?us-ascii?Q?zD61N41pJ4n4tiCmY+OEpj1rmOCVxBfoqX+ar1PquEXT+a8M3ARtLJfoYihL?=
 =?us-ascii?Q?VcYVP3vJaIukAPo6DJ5FQ2tSZRToUnv08/BmTAFrnEfHeaAHkohWxMijT6LA?=
 =?us-ascii?Q?ClQlXbPEZkgQf1nAWmpI+0K/YkQqT81UrvFd5fDvowRfUNLqfmJx/5R12sAh?=
 =?us-ascii?Q?UIry4s05aWfQKxm3xUaQzhsVI/Kkn/GXAGyPlm7TXmeW4yEvDNR0xEGYUdwC?=
 =?us-ascii?Q?Fg5ZUkYUKEzZPaCpRJAJDkD4R8sIFb+P1JzttQbB6mgCgrcUJLKMfi6ujx0b?=
 =?us-ascii?Q?oed3pUUEQnEdlYAk0R3i8YaY6Fdc/Ns8w1Q2q/OxvnhOdR26Veqg2N+eGp+f?=
 =?us-ascii?Q?gwIpXAvEbBv3IMQr1zWcLYiYA9vomd3Xt3RWDT5/Dp0LlBiJLzs7Y/G4sFa7?=
 =?us-ascii?Q?0XjgLpdcEf2eNFV3FSuRsIdY85vWc9MXOQ+LosMfRalFsk2yCNEoBOlSjbSw?=
 =?us-ascii?Q?6GCdZidAo5CuH0WUc7He6gKjUOIgcexjvz8dYXfUNNsStBLHz8XKo3aO4Vet?=
 =?us-ascii?Q?xfLuHFa8oSvXr0o8TLx3s3toogWgtjzR1oxm36hF5ubjeJJ2WCYQ/buLyPEy?=
 =?us-ascii?Q?BTGggbNo8xgOu/OR+MviQEqHdXsk1v57T81E/feiY34Ffm9DIiR/xh0E8Fmp?=
 =?us-ascii?Q?8l3Ryntic1EoBieLu6pMn9lLPoqTllh2eggIDkKNz0hzgv2D6QkB3fvmbDDC?=
 =?us-ascii?Q?GXZBM2HtEFl4X6tZ3If+GGRTHzopyqy0X+jnENeXaZV1k4rfqoHYiI4GnnVh?=
 =?us-ascii?Q?12kuNyX9lxjleDDglSwkL3g6m37Ag5sn2TduqphMitlPaAo7d2+wLZDb8a+Q?=
 =?us-ascii?Q?csQcJ4tManOZrp5WvSVUe0pfrIp8fYq98Rwtux1eaHtSsu97S/EKj1Fw/Q0E?=
 =?us-ascii?Q?6f7kY8BSMD3as0iIMLGtq35XlO0NDKZAVEM8/1NAV2mA+Dn0rSuTHEdSKBZA?=
 =?us-ascii?Q?Jbb9r5B6AlvbN+NMr8piXOK16+GGfd6cd6jbQX6u0WXUTVdEQ1JK8cr7uJDO?=
 =?us-ascii?Q?N4JpbTjZ+HzhvIl69HwCFdQrkbGz/5sZL9GQKeW/MqfSCXIt1m35GFq+kj0H?=
 =?us-ascii?Q?KGqtQQh0pc/XfqlPoaqYXpbC?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4748.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90ea1779-5f36-4aa0-260f-08d8f0b254d5
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Mar 2021 23:53:19.0437
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pM2FA2red+7VbJuNIWFUHVsehK3zNkJ5FhAGfoSThRv/D9U851nRkkj3XqerD2FaPZ3a+shOQNsodX3umhkNvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4764
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



>-----Original Message-----
>From: Chen Lin <chen45464546@163.com>
>Sent: Monday, February 15, 2021 4:05 AM
>To: davem@davemloft.net; kuba@kernel.org
>Cc: Brandeburg, Jesse <jesse.brandeburg@intel.com>; Nguyen, Anthony L
><anthony.l.nguyen@intel.com>; intel-wired-lan@lists.osuosl.org;
>netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Chen Lin
><chen.lin5@zte.com.cn>
>Subject: [PATCH] net: intel: Remove unused function pointer typedef
>ixgbe_mc_addr_itr
>
>From: Chen Lin <chen.lin5@zte.com.cn>
>
>Remove the 'ixgbe_mc_addr_itr' typedef as it is not used.
>
>Signed-off-by: Chen Lin <chen.lin5@zte.com.cn>
>---
> drivers/net/ethernet/intel/ixgbe/ixgbe_type.h |    4 ----
> drivers/net/ethernet/intel/ixgbevf/vf.h       |    3 ---
> 2 files changed, 7 deletions(-)
>
Tested-by: Dave Switzer <david.switzer@intel.com>
