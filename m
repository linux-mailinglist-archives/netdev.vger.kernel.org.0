Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1945469567F
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 03:14:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231225AbjBNCO3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 21:14:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbjBNCO2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 21:14:28 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B874BAA;
        Mon, 13 Feb 2023 18:14:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676340867; x=1707876867;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Z0ag8EiYRkQE8qs2i/co1VNTrgYho1QxGacHRelBDq0=;
  b=FTDvBKYpOc25gDbvjZa7Z9084JAZ+A1nIXEJAckeqIETxn+EdBMwNvdz
   Vug65ztO6PJR4jiAnst73ORokmcL9uCoV+s2PCcr2VWF9T8Mwd0BSa4Z+
   L75Ag5dcnxLaKPZUE6UW7VWQzXlcQRdN5xkZK4v95+leCufu555I4kSdM
   OZtUtOrHI2/OhTIOqDniHCNk5IGOBDuawjCQrokqyKCYYr4RFnqPOh+GG
   RuxNViNYdksA5jzR6sApIjdzLt3ruuNHfJL/MFPGTK268yN+uESR9D5bq
   iv4bD2z6iHego+lk7S2uq4qF04ekgFiTOOCPPJJaX+/j6yfD9WKc+Q6F+
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="310690795"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="310690795"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 18:14:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="662399536"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="662399536"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga007.jf.intel.com with ESMTP; 13 Feb 2023 18:14:08 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 13 Feb 2023 18:13:58 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 13 Feb 2023 18:13:58 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 13 Feb 2023 18:13:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g7sishsr5Ec2fmA8TUIvV585fkEt1W4sKxAYcu9G+eyRzotzZExdM0n7OXJHVnYtXiILLLoDniyxXCdWsoaxyZE6of2+CvLVxoPIUEE2GwPYP3xlVQwWG3j0BOkI5gq8K8m/Q6RTYk8pfcZavDsFk6JxkkX0wMMC7YmD84pbT2vKMK2KXAKFBLa572Z4AD3KT0q5HrY3jTFKCAyKau61kgzb0vztCgFu45XGnJA+dqZDON2f7u9gWe3OqX0nqtPL3wo+IrvzGFUGoQq56ve4sjvwWgVesjHAEKa0fuKQ4GckENxVE1tlCkh8IlRu9tlk0edbj4PKp4Ef/Syfqff5ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z0ag8EiYRkQE8qs2i/co1VNTrgYho1QxGacHRelBDq0=;
 b=Ug6pd1VNd3Gu4FYwnr72nJkPAe27vztgJ3qxdmtD8mrq3PVh0/+Yiq32Q4dzbMoys2MDlR+aFT3OxBteis6KpdlVeyJ++2raeZUvA2KCZ9S7KZiZhKfd9zX35HMPVVG5wns3s8pKtIIiEe/nWbx7SYSaJIN82QR20vMKlsQaulZGxXCNfAhdMmqE/hpevVUZilrd7hRvVQx1Y4qYQZ1p33WQEJRzxUBXNYGbpJsG2sv6PstMPOXsNQUe8J/6daQR4xRX8I63KMrT2ATODORncfexjCTuVRLyPxtuYItr/lTb3N/W+JaRU29EhogYRN22F9R4ogK79TyMVAsA6b4ZHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB4045.namprd11.prod.outlook.com (2603:10b6:208:135::27)
 by MN0PR11MB5985.namprd11.prod.outlook.com (2603:10b6:208:370::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.23; Tue, 14 Feb
 2023 02:13:51 +0000
Received: from MN2PR11MB4045.namprd11.prod.outlook.com
 ([fe80::6b67:1c73:161e:9444]) by MN2PR11MB4045.namprd11.prod.outlook.com
 ([fe80::6b67:1c73:161e:9444%7]) with mapi id 15.20.6086.024; Tue, 14 Feb 2023
 02:13:51 +0000
From:   "Rout, ChandanX" <chandanx.rout@intel.com>
To:     Jason Xing <kerneljasonxing@gmail.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "Lobakin, Alexandr" <alexandr.lobakin@intel.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Jason Xing <kernelxing@tencent.com>,
        "Kuruvinakunnel, George" <george.kuruvinakunnel@intel.com>,
        "Nagaraju, Shwetha" <shwetha.nagaraju@intel.com>,
        "Nagraj, Shravan" <shravan.nagraj@intel.com>
Subject: RE: [Intel-wired-lan] [PATCH net v2 2/3] i40e: add double of VLAN
 header when computing the max MTU
Thread-Topic: [Intel-wired-lan] [PATCH net v2 2/3] i40e: add double of VLAN
 header when computing the max MTU
Thread-Index: AQHZO2dXF3vsNzyKmkWYiSXcSfkRfq7Nu2Qg
Date:   Tue, 14 Feb 2023 02:13:50 +0000
Message-ID: <MN2PR11MB40457D2433C5155AE212F48FEAA29@MN2PR11MB4045.namprd11.prod.outlook.com>
References: <20230208024333.10465-1-kerneljasonxing@gmail.com>
 <20230208024333.10465-2-kerneljasonxing@gmail.com>
In-Reply-To: <20230208024333.10465-2-kerneljasonxing@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR11MB4045:EE_|MN0PR11MB5985:EE_
x-ms-office365-filtering-correlation-id: 5686a2e1-2efe-486c-ca6c-08db0e311d17
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jy9TJDn8h+X6Pm5vPJ8zv3swRoB9YThNVNCcwfaaXLHBZXnA0gt1cDYBiy3MolHGIKkeg3IjDtKVBqcsVm342TbIrqGBcWeWIN7Vuu2ud2TX2jjoaTaThHZqhrtjc1mhGmbLeuG87mnBco9MUC5ngfWVTtW455OIobbBd6ViK/h/q4JLUST4JnG4kDS4CDnERIf0Kmrb+/TUTk6Lr37nzPV/7y5W3fAQ7QKeJaV/QEURo1DDSTE+EDkSBXBBnbLU5lv0+Te9d3h8vGy9CMdhGE3fbNQysdk54cg1alTnhlotDp/c2mvwAbjrSs30M47IdZUmh3D8/KzZhK8qLYF8+S9grz5334Q/qh9GSKXmCZ0W4qSU6TV5g18H/L/Fr7riKuHY3r0V0cRPgzaOZnhilDr4GfOnoAYOAnNdpYslctrhUjru8PKWik3EoXa1mtq05hnbMI4smvwYLin0xGW4kMmm+kYifRH73Hc+/nJSaI8t9oR37d/WGq7I9dm6RkGM1b0tqs0AKXEY2mEax/asPfAXPUcwBFU4SicrBoeIPlvEIDzTSp+NOlrfr5ElQTUku9UHNoJiQYDjf7b+vSM0HIt57odraIKQYzcNc24WNkHErruSypXp1TrymYJGjMSg1mx1OJ+U27WNjkL9FpZ1fNgXUeTpyDOyhJ0M3GzvgH0FkPOYJHL0ljFEeoW29QGIFvVgyOx1w2YctDDa68jnXj3i3C6FxNdVZm0pQBGv5SM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4045.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(376002)(396003)(136003)(346002)(366004)(451199018)(7416002)(38100700002)(8936002)(2906002)(82960400001)(921005)(52536014)(71200400001)(5660300002)(66556008)(66476007)(66946007)(4326008)(122000001)(64756008)(8676002)(76116006)(66446008)(26005)(41300700001)(38070700005)(107886003)(110136005)(6636002)(55236004)(86362001)(478600001)(33656002)(54906003)(7696005)(186003)(9686003)(6506007)(55016003)(83380400001)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?B5beHWyNnWaOMJo36Gr5FWqQE3YAuVmbmOCtqZMXDQv7XNjV8yL+rvMGyUd3?=
 =?us-ascii?Q?r/tbOL8AuOcP95fNIZMXUpycWJbR3qvWJmSHHSlqR+x/9193GYQib6w1IrA/?=
 =?us-ascii?Q?ZJ0CjO5kUbaqDRbTBkTw0u8AzHW89FqUOpI9NtA84A6uiBiKteQdsZUkFiNA?=
 =?us-ascii?Q?NBaXypPMIwsY/3YiGXEaZ8llsbfshzR0r0WkxUcmUuM1LijcfRSFEUME4T1F?=
 =?us-ascii?Q?xnqW1EymkZ8pa5NyKBnQ6DqRj4JVt45VSK5pV/v3iAhRYqEAyBA1WBJN+oEJ?=
 =?us-ascii?Q?QBdEYRMjOSuHqw59/CoqJuzKQ5N/bCNQFakxtch9EMjvXYBVazfyL/OyVNOc?=
 =?us-ascii?Q?+UMiGi8sLAECgAccIKAJDdApXxs9nS5n5UOyN60spS8VhWnAULsRq74OW1iw?=
 =?us-ascii?Q?KvSprTQopy8oHAxOdJ4YbDDjp2t4y6Is+y9FH4zZm4PaEn9Q5P6aGeJzW2o+?=
 =?us-ascii?Q?cy/DoIW9GQ9/X8IjPll85jc/SlFI129xd4z9KsLT1Z7GPeUA1+3r9dY+IiQ8?=
 =?us-ascii?Q?ftIhjmlKmCqJ4OALBb56lqI0hwd7AW29nH7vtdgeWDP/6VEAx38CWCgc9Utf?=
 =?us-ascii?Q?csu+iNYegoo5YSNqXk4P6mocIHWAmk2fTAM0RKb+JVvOtY14QPNpkKODV5BN?=
 =?us-ascii?Q?QR6NwzrASC5CKqNkjI1FZpTFuVihKemMNdtVEfp3bfuyfGsLbNkcs/ZW6ljJ?=
 =?us-ascii?Q?niG0Ci4P7epGevrrpfcPav9AdB1iQkK3uUIFg3CALUhmsR64niF8Tdf9i/ak?=
 =?us-ascii?Q?W3OYlLceHm34fUu5CjBZCtKHrbeagC986yRwQ/vnYwHEPfYRpV/h0eGInqPI?=
 =?us-ascii?Q?JBeOTNQZZZ7YR4BMQSWBUGGrpt8kY9xWbJP1INFPip8lWTTe1O8HaE9RarrJ?=
 =?us-ascii?Q?cz9bClIcZVFD8AYVyGNjPpp0Hs4Ywl4uPOniOlsPn9x2VQ8439Q4VItKCZyb?=
 =?us-ascii?Q?e34SBrF0eS/afAadeg9VHm6ka5/guMqUre+SAanTKmtKlLYJXzlghLQ7j9sV?=
 =?us-ascii?Q?l7bHHTm/bXi9m8jEszDJECsJvgZRcytlEL2vRPRQtRsm8G6k1H6I+LHA+YdP?=
 =?us-ascii?Q?oLNXvR98hJKoyEHK89qyMYdSVgsrpYRIQMZgrVWKi4v3NKt/E6ArRlOWp6jm?=
 =?us-ascii?Q?PT7EuLDbEHA0T+HiBdUlgPjQyZeRhFrMf6KP8Zcs3q8tukzeZhjeO+fxxSPt?=
 =?us-ascii?Q?JYajEZULXEWfmn/rWTE2YNpvTDdIYmtt1Wi/mNZnZDG9JYH/gKQvXFkHz6/0?=
 =?us-ascii?Q?mfcSawJIqDpZ7WSVKN2FRpyHW+Xlwj8lVxwnjaspHVegw7I+bIJiXRGDUHQA?=
 =?us-ascii?Q?DOk9vcDFQVuz+rNjeS5uFnHDyI0r8nMn28xSFiPO8WngCN2Qtmdc//XYbzqG?=
 =?us-ascii?Q?5RepV7De/1Gkdprr/6rU5g+Hgry7D6G65Pa9R8FV8+EW+yLYaSjjB3Xa/xdA?=
 =?us-ascii?Q?wFVefXSotfg2gSNC6QMZFmarZB88EhUOlVUjbAL21xSbbAUHVJjKXfyvs5Tx?=
 =?us-ascii?Q?Imupk6JBA3gLXRRq3fFvp2gllAeTwKHP49brsx2WzNPajS4GH//3uRoH9VjZ?=
 =?us-ascii?Q?zjqgyXejaDvT6Ajfuye5emCeqlhxMfaWFEoyLW3x?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB4045.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5686a2e1-2efe-486c-ca6c-08db0e311d17
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2023 02:13:50.7185
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /D9+8ZPaqxUfU4sPI4r02eUJIVUPRd1/1pv2uqSB59eL2ADVImVBsXl4pH9uXcobsMp5FcHm1x8SiFO4ynqQ/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB5985
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



>-----Original Message-----
>From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
>Jason Xing
>Sent: 08 February 2023 08:14
>To: Brandeburg, Jesse <jesse.brandeburg@intel.com>; Nguyen, Anthony L
><anthony.l.nguyen@intel.com>; davem@davemloft.net;
>edumazet@google.com; kuba@kernel.org; pabeni@redhat.com;
>richardcochran@gmail.com; ast@kernel.org; daniel@iogearbox.net;
>hawk@kernel.org; john.fastabend@gmail.com; Lobakin, Alexandr
><alexandr.lobakin@intel.com>; Fijalkowski, Maciej
><maciej.fijalkowski@intel.com>
>Cc: kerneljasonxing@gmail.com; netdev@vger.kernel.org; linux-
>kernel@vger.kernel.org; intel-wired-lan@lists.osuosl.org;
>bpf@vger.kernel.org; Jason Xing <kernelxing@tencent.com>
>Subject: [Intel-wired-lan] [PATCH net v2 2/3] i40e: add double of VLAN hea=
der
>when computing the max MTU
>
>From: Jason Xing <kernelxing@tencent.com>
>
>Include the second VLAN HLEN into account when computing the maximum
>MTU size as other drivers do.
>
>Fixes: 0c8493d90b6b ("i40e: add XDP support for pass and drop actions")
>Signed-off-by: Jason Xing <kernelxing@tencent.com>
>---
>v2: drop the duplicate definition
>---
> drivers/net/ethernet/intel/i40e/i40e_main.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>

Tested-by: Chandan Kumar Rout <chandanx.rout@intel.com> (A Contingent Worke=
r at Intel)
