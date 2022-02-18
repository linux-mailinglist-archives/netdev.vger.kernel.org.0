Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82CFE4BB139
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 06:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230300AbiBRFUf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 00:20:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230299AbiBRFUe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 00:20:34 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B8EB3BA7F;
        Thu, 17 Feb 2022 21:20:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645161619; x=1676697619;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CS+Doj+J6dyzBtC3fj6FPBUyoDyD3csFdcJilv/7kkE=;
  b=HA0eAIjwJUiloIPEptnwn8WBT2ersRQz2oUXPgKPZJNRX86aakRx2GzT
   LNDLu/0Vcg0ChYRXCyfnNdXB97zVdW/wnkNZYZgcZCrnbgIkcvi/kTQKL
   tR2xkR07d0YisHN6UjcJ6u4zHBTbqLtipJ5pe6OMyv338Pxge2ywUPB4C
   R8LT1oPQERH/Aqs3vpeRWdkIZmsH+tYG8xLj+FZTNtEpe4ZnyDQ/H9Bxq
   Zq4WPIP6t89zYNcl6Q/fTE+vj1E5aaJYlkN40OBmxvCdE/7Im9dEPbZgZ
   fXQmzh3m7eZBhlzPCFqK47XRDM4QOwODsFm5/6X47wMoozhaNQrQWjsmk
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10261"; a="251253729"
X-IronPort-AV: E=Sophos;i="5.88,377,1635231600"; 
   d="scan'208";a="251253729"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 21:20:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,377,1635231600"; 
   d="scan'208";a="605445468"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga004.fm.intel.com with ESMTP; 17 Feb 2022 21:20:12 -0800
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 17 Feb 2022 21:20:12 -0800
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 17 Feb 2022 21:20:12 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Thu, 17 Feb 2022 21:20:12 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.45) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Thu, 17 Feb 2022 21:20:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i7HiCv0l1dUBmZbFYNgDcFzefiGN6fRBYqbOy3qfEkdZJ0lV+iU3/QWdoIDh+Leu9eRCYI0ifvx4T3tAXobnrbEZAukPvsDjFpYguKSdgJlLOSQvhQUrwGoQmUXoINM6eCkiSYtnwzg8p8PSJrZosjSfM96O8afH0HPO7C+GlqVvE5DcvseuUvLTp8DCB7rKWlgk7itwm84V8V2GoUSpwfKNCydkEr/H/wNo7n5Hotj9xYAL2zpQZMzJi+rMJ2H7YcMfrO1aNHmrIHry1wdu8z8U3XXp4lpa1asQ9TjsRXQLI6QWLwlnYNQcMYytQQbLi75jmW4x4GkEvHh8UO5uog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CS+Doj+J6dyzBtC3fj6FPBUyoDyD3csFdcJilv/7kkE=;
 b=TzQO9xnTyGHngmRdwWsfLX4vHBZSmMg1rsL+SnClh0vbnBieaR+OWMbvd9+Ug6xpXMzJVbSLj3TJbOL+C1F3epTkrvuIfgP3utqMIDgtqhYRTOCUVwJVwnGJKFwLokNSHzJTwfuTUGGyf0oMHN5h4xYqQyfDgTbmm0jw6BVgWLt+FMeeUZNMWjN1LT+92+WrKKPqKcLJflD5BKXoteykioATSwInokiOKAIQV7JFguNi3CA3Z9mEPdO6coPPCj6k9dxoyJYH80nzQTrmRPZX59ZKK93JVU/UaD38I8wz+tuO6HZlMcic+Gt+yePnRburWsNXINUfi9PWwFL2EiHotg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW3PR11MB4554.namprd11.prod.outlook.com (2603:10b6:303:5d::7)
 by MN2PR11MB3568.namprd11.prod.outlook.com (2603:10b6:208:ee::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Fri, 18 Feb
 2022 05:20:09 +0000
Received: from MW3PR11MB4554.namprd11.prod.outlook.com
 ([fe80::88f4:40a1:ffe1:905a]) by MW3PR11MB4554.namprd11.prod.outlook.com
 ([fe80::88f4:40a1:ffe1:905a%4]) with mapi id 15.20.4975.019; Fri, 18 Feb 2022
 05:20:09 +0000
From:   "Penigalapati, Sandeep" <sandeep.penigalapati@intel.com>
To:     "Lobakin, Alexandr" <alexandr.lobakin@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "Szapar-Mudlaw, Martyna" <martyna.szapar-mudlaw@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: RE: [Intel-wired-lan] [PATCH v2 net-next 4/4] ice: switch: use
 convenience macros to declare dummy pkt templates
Thread-Topic: [Intel-wired-lan] [PATCH v2 net-next 4/4] ice: switch: use
 convenience macros to declare dummy pkt templates
Thread-Index: AQHYE5SZAEW9sUDLUEmd/hyCNawUbayY5yPw
Date:   Fri, 18 Feb 2022 05:20:09 +0000
Message-ID: <MW3PR11MB4554334A9DC2D9C504A657C79C379@MW3PR11MB4554.namprd11.prod.outlook.com>
References: <20220127154009.623304-1-alexandr.lobakin@intel.com>
 <20220127154009.623304-5-alexandr.lobakin@intel.com>
In-Reply-To: <20220127154009.623304-5-alexandr.lobakin@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 26c11742-c02e-40ca-0f3a-08d9f29e54d6
x-ms-traffictypediagnostic: MN2PR11MB3568:EE_
x-microsoft-antispam-prvs: <MN2PR11MB35680D5E3D3248F8EA77310F9C379@MN2PR11MB3568.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2399;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: egYxYqL7LsCdA4LsweYXjN+mFKJiYclD67T0G6dadGKiWfI8loMoN5ACbeaPFh5ZyYfkDSUkSBLL+3Sz0/Y9OsXYjjx1QGjiEkZo97bAqM56KEa8eVog2eK405nPzSGOLVpe95mZwQsbPI8JmiwjBNuQWDBEw3OcAs8/TNh2tIGy8eBIVGta3uoFJYtJHIMF7DffCo4S7mmzUDYSOEPDO00yIm2AyD4GsgzI5iq2i4oDYEjs+JJdOkji2GLwtpFdAUrZhXGyH8MI9kZ8KfWA03z/6JmUo72QAXt9QXmw5kVYiWeVQgP+tyuOOWWlFtYFUbyXSblgqFqtEljZlhKESX5U/Vvdz7bQvUOJYcohLCKHne4xkw2/KGl1Mpu37cfRYtBMS6Kg7YYBbWfjvhWk1go1YSc7n5fQjO4LwMpDv36Cy+iNRY3OuXKaMsxFqjF8eelIZanVR+AZryve5W83u6C4Bl/J2wKiNUt2PYx7LUF0CIYttFZpe7DeWASA6KsaqzZsJsRRTvBQiA2JJVSYrqhNpaJ0JcLj/y7TDK4hSeV7hiloyJzb+6hoTiqNNt6X3xt3DlfVqkzyEDMbX3bqdpgClkmiuj1/FhRibFHAcG+shFfHuzfvvqTIHfeILCFwK+LXsjGi65f14LVjTOUnVolu8pvgxyLaEeyCWUaSbllTXWOx5K1eoMIH4YCxaZxspVMB45R7x7SD3/mlKWibCw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4554.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66476007)(4744005)(66946007)(4326008)(8676002)(52536014)(38100700002)(76116006)(66556008)(6506007)(7696005)(64756008)(2906002)(8936002)(55016003)(71200400001)(66446008)(26005)(186003)(86362001)(38070700005)(316002)(122000001)(83380400001)(82960400001)(508600001)(9686003)(33656002)(110136005)(5660300002)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?4r5wtM2i4oFNlOvsI99WHPuhyPRoaZr4e2bkFF8HAbX6flWEpsaXQTY1ALn8?=
 =?us-ascii?Q?mmCVDPVQv9QRyB12qwwNYivpU8Lz0BkTb0wl7ysUbuhGg3AxlFYoOxYiEQBi?=
 =?us-ascii?Q?0I1PvCi9wiKpCpNIKpGn7Qivb1B7GOp+OpNlHHl2QSUaQm4JMIX9mmqBslyj?=
 =?us-ascii?Q?wUUdiuGwvOJNEfhO5g3HgNyR9y14qRZqBPaX0sTnxRQPpur0ICPu/69QU8ak?=
 =?us-ascii?Q?dBvbOvDeqEtsBUpV8Ie8oXwv9GS00V7Wwqs9K3SCPRpDaWJOJscoeCTqG1Lz?=
 =?us-ascii?Q?GXbJZjKgQVRGccQ40uNxFRXOHuyLifHy42YeMjp/Mov/suddwTjGAtoaRj2s?=
 =?us-ascii?Q?XMq0lQJJL4drNdB3cWqLswuXpQ/GoefFUoYTskRqo3K0ekRiiuUajR18yWPu?=
 =?us-ascii?Q?RN9pgoN8lO+SuEiPNKi3rWlvjfEKiO38Wox1PnQjhU6l/bEEvnOMIxJ+c3m8?=
 =?us-ascii?Q?77Ig+nkdYg4F5e6xNjNDjCCghYJuPbp+SABVMDcaGV9kaTO5a89T3DKG2IA6?=
 =?us-ascii?Q?7lSzz/2B+/DFzkYHfwLz0VKxX4+jFCniuB0xbf09yVRdxuckrESYnlAdY8Ov?=
 =?us-ascii?Q?2y5sSssY7yX6tbk2aPnBilBjgB4dxLYQFMgcEYmw4UO9J2tMWoKkFY5XqheJ?=
 =?us-ascii?Q?9mH63AxNySt8o52q87xv/Dq5sZM0Rd4OLFSBzzkv2PP30AZs5Rka/b7m2xcV?=
 =?us-ascii?Q?QtddqgVI7oaqF0xJa/ejd0hQZLygBHOdGbm245Is8vIv0yL5RItILf1Rm6b9?=
 =?us-ascii?Q?0Dqet60khgwEU91o8D2mgJnz5Ny0aepnI8taRTzaWK7q8w2CAMjzejCTAbM3?=
 =?us-ascii?Q?kcjxoCMxResG4VBBWPCarMBZaQeRrwpcP76uc8HLFm4udCtQwhvGBuAxjP9b?=
 =?us-ascii?Q?la0kwZE+DlGbrPOjSa6Z9CUmcP84GZJ5spsgjOgGKzm4eOIuD+qtXjVu6/bD?=
 =?us-ascii?Q?JoQUiYRBB6jA/IwsD3ZY/iEa3oGvj/tsvR0uSivTqFXug4G/mG58aOA8kRe9?=
 =?us-ascii?Q?iT2a0gUFFbsW5mVElDZI6uFgaTNHc+TrIsCGBTTTnPO40RxeS4RRW4Nl2AuO?=
 =?us-ascii?Q?XluO0wO/I09p8N6+PeSCQbLnpeL0c8FAwcWQjgMhsjU/MXR0h4ptY41pQyOD?=
 =?us-ascii?Q?ZW6os5GhNVPzWQNyD7JxWhvtItVaE6iK6LVe5ryJK3yQDCYIHcb9WoVEQw0g?=
 =?us-ascii?Q?HwZu0hOhp1cIRapK4fl+7UJIwbSJRJNgSEexqu24sNCRiwerhAIOsw2CfvSZ?=
 =?us-ascii?Q?GmmxTy06gepe1RU7KCdCpTqARII779v20lmfShdLOEUngMXC/m40Xe/TZTJX?=
 =?us-ascii?Q?LRYE9TltGA6LMETk5ckDwx8jlV8VdrZuHJOWpUAQfdyJ/GDxz2+V9S5zpvVQ?=
 =?us-ascii?Q?A1u2fHth/kdTlEO1AIb9QmORpbM1Rd3+mbTkdE81LqLdUxG+4rn5mY/FsAEm?=
 =?us-ascii?Q?y1M694+0ZBvMlo4v3uW35/+ooc5Rt2vOrTtWLCpS92LALMhYVrBAzIIoqJwy?=
 =?us-ascii?Q?uEE4OMsXyxHu30srkwGC92YeK+TmXV1KnBBLcxCUY05wYVW6mbRP9+J9WC4L?=
 =?us-ascii?Q?pPyY3BozySJ/BC0MSXx2LdtS2xhNEc6XSBgpnCj76v5LwCHVUdrrNxVBsAS9?=
 =?us-ascii?Q?U2R7KHrU1m1mrpuCOfGQwf1+O9ciJKHYEx6EdA6kyyNYT5moye20RfFJBcG+?=
 =?us-ascii?Q?fWcc1w=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4554.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26c11742-c02e-40ca-0f3a-08d9f29e54d6
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Feb 2022 05:20:09.0455
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2l2bmvybdNRmLczC/FneqlzCJvI4ec3nEZ+6ubDF62u3K0uGZh7IqTzxZy0dMcNgrN1bGbH93/ib7zTATqsej/hSPeNIh7IxRUKUw5KqfhM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3568
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>-----Original Message-----
>From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
>Alexander Lobakin
>Sent: Thursday, January 27, 2022 9:10 PM
>To: intel-wired-lan@lists.osuosl.org
>Cc: Szapar-Mudlaw, Martyna <martyna.szapar-mudlaw@intel.com>;
>netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Jakub Kicinski
><kuba@kernel.org>; David S. Miller <davem@davemloft.net>
>Subject: [Intel-wired-lan] [PATCH v2 net-next 4/4] ice: switch: use conven=
ience
>macros to declare dummy pkt templates
>
>Declarations of dummy/template packet headers and offsets can be minified
>to improve readability and simplify adding new templates.
>Move all the repetitive constructions into two macros and let them do the
>name and type expansions.
>Linewrap removal is yet another positive side effect.
>
>Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
>---
> drivers/net/ethernet/intel/ice/ice_switch.c | 83 +++++++++++----------
> 1 file changed, 42 insertions(+), 41 deletions(-)
>
Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
