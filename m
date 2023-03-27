Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67EA66C9C4F
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 09:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232650AbjC0Hhg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 03:37:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232635AbjC0Hhd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 03:37:33 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24A67559D
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 00:36:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679902604; x=1711438604;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=E1YGz9Gbxc+OoK0eGjxUT/VUsVKA8zjwNHWyCG+EQTk=;
  b=VMSklO5KwkDPlUytbQ52KaBt6uW4/2mCD1z/cV/GZ/0plwt0GBvapGdZ
   bJOIy+QViRUfuh65+ZAyRU6tA92tRUtcexdTA9UvIl8sG5kDhti9vzSLt
   n0Dc6aQVoZtY+h4pLTnLIKGmu7ux5nYbvXq0Wz3UQ104ZVsaRFPuaV34q
   gPEay5xnLq3e5+yO7pYpJ3MOnBS6cAS6YQY2FF0bP6IhGwxh5rMQRNwwB
   4dKVKXX3mHUMujcxa+9o36XoDbiEv44vUa3EdD30e6Q0c/fYUszaBa8EO
   l+zlC2Br94VhS+r93YGShgTxOBL8YyC9RpSrEX/tCQKstfdJl9blOHVaJ
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10661"; a="340227614"
X-IronPort-AV: E=Sophos;i="5.98,294,1673942400"; 
   d="scan'208";a="340227614"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2023 00:36:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10661"; a="747896267"
X-IronPort-AV: E=Sophos;i="5.98,294,1673942400"; 
   d="scan'208";a="747896267"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga008.fm.intel.com with ESMTP; 27 Mar 2023 00:36:34 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 27 Mar 2023 00:36:33 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 27 Mar 2023 00:36:33 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 27 Mar 2023 00:36:33 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 27 Mar 2023 00:36:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oBTqNTQ1uLyXeqN+C21ySIMXtogFS9BqBLl9tYkaWRTRJqg971Bjiy43HE65YJ9kdMsxxYK//nMzqSRNF74SSHa4pR5LUVR+wc5RYxpA1XGgbq/GohFliwhpPni0HEO61hq/13Tc+Ht7FafevI8kNZ2YAcgURSiBRWDlREe2QHbSUSnmfF2lY9PXOKNbF27Ch6h8bycZ4W+NBXfP88s2LmISpLkkgx+VWX3laJhQmY4d/OrDsBwYOBNujOYhwzx0rBijnkHHF9OQUkuy64ASodgdTg0qlt9BJyWYZxoexwrtaKZYSXOIPROTGd4TL+1LaqghRM61+stdMrC3oLLNQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=01G9hyLARPB9ylgISWqV9uOJIk+g2b11wVWo4pZuNJc=;
 b=KAnQV4kjVLLBdA0vC3mhWdiNMkqrGgAk8jFk6dKdPBsPq1otMD17EINqGsWf/PDYImIKnhK1gzrsLmg8pDRhDArW8qqCaEG3MAIdceu/tnQ5LoJppc3ORYQGqewxB1Oaa8/bdIw36eAy7cksbaQvpQZt/IEWAlBJA67yTAypd2hGNWEDVV1+uI7Yn0QTl8+GLwrTJZXl6MfjjiheWfWB8w8aTPL8FzEBqgIf1u5W4qXwb9IpnAsnVMxvpbuAmH6MCmgjVbzLEC0heh7xawGE46wwOAIOCPItjSdK4DHn7aZI8az7udcnvZ8YXSkk2+Fg9dRfOJKWfMD1uxsKyvnHvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN7PR11MB2788.namprd11.prod.outlook.com (2603:10b6:406:b2::30)
 by SA0PR11MB4717.namprd11.prod.outlook.com (2603:10b6:806:9f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.30; Mon, 27 Mar
 2023 07:36:29 +0000
Received: from BN7PR11MB2788.namprd11.prod.outlook.com
 ([fe80::f6e5:f2a2:d699:1fd9]) by BN7PR11MB2788.namprd11.prod.outlook.com
 ([fe80::f6e5:f2a2:d699:1fd9%4]) with mapi id 15.20.6178.041; Mon, 27 Mar 2023
 07:36:29 +0000
From:   "Andrysiak, Jakub" <jakub.andrysiak@intel.com>
To:     "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Brett Creeley <brett.creeley@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Malz, RobertX" <robertx.malz@intel.com>
Subject: RE: [Intel-wired-lan] [PATCH net v1 2/2] ice: Fix ice_cfg_rdma_fltr()
 to only update relevant fields
Thread-Topic: [Intel-wired-lan] [PATCH net v1 2/2] ice: Fix
 ice_cfg_rdma_fltr() to only update relevant fields
Thread-Index: AQHZVeuS9qOFEADZeU+9ILMGmVG45a8OUVLQ
Date:   Mon, 27 Mar 2023 07:36:28 +0000
Message-ID: <BN7PR11MB278865C2B8733887FBEF645BE68B9@BN7PR11MB2788.namprd11.prod.outlook.com>
References: <20230313203608.1680781-1-jesse.brandeburg@intel.com>
 <20230313203608.1680781-3-jesse.brandeburg@intel.com>
In-Reply-To: <20230313203608.1680781-3-jesse.brandeburg@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN7PR11MB2788:EE_|SA0PR11MB4717:EE_
x-ms-office365-filtering-correlation-id: d9a1545c-7114-48d7-d60f-08db2e95fa4e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Mx5ynheDNiYKtMXdqYtjnhZGbEGreBHPH/unbkBgf3dSMTq/aw1ItiGkb+d6LqDMFhRRWeDVJesO+ERBdMrU4QkVe7IKhFzNKSFiQ9WhsSbYS3YdwZufhyPWoE6Hq9rnn8V3TusaRKF/X8wgs86G5A6/ox8/75KnNPvMRe55ifh7ZCCA0e8dYbyBm8QJRrkHzNBUjnkXu4SAhVCHhA6/1M5LEYffpzIz529YhtHtiCHDRog2YTn08TXJNIuSWkG1yYG2L547axoxXOPewYKaY+bOQasFBQRgKVd5RYPzSgosa0y83H+UICVF8CbYK/TaqGxJg68vzzH0TO4uAURj25cOf2pICQ0rIiNN2UOwlP+82HXjF2KFkSeF5uompIoNeYSb49jH/5xs62qOZpN3jyb1mt3yQAYtudSAd7v0mEXiknJ0a8PIJAdPFfpOXuGaxk/xDta8SCru13cPmMvJMcFh6C109hJd59GkzrUOo3u1xHil9LUYwUFijDL8pVLwu+2+s9YzbtssW6hAxUu+gYgJ2UswRdlPV17dclveHYNRv1Pualz8dwXqRRxYPhpCGBqQs9EPCOGLGhW5P25yxmxK9vaLTy5jshb3ZNVGgO4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN7PR11MB2788.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(136003)(346002)(376002)(39860400002)(396003)(451199021)(9686003)(6506007)(26005)(53546011)(41300700001)(186003)(55016003)(107886003)(966005)(7696005)(71200400001)(83380400001)(478600001)(54906003)(316002)(110136005)(15650500001)(4326008)(38100700002)(33656002)(2906002)(66476007)(66446008)(64756008)(8676002)(66556008)(76116006)(66946007)(52536014)(82960400001)(38070700005)(86362001)(5660300002)(8936002)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?m9z/HTANkhwH5HR0pYHNEi4m5bojcjNE2P5U8qXpM/oOUF+MsYea3YeHHNxQ?=
 =?us-ascii?Q?CVe7o150vKdO26o1Uf/9D1j5EkDQeWORdZ6MbH1xGs7FRHfZL14pf8mjAQVu?=
 =?us-ascii?Q?mZWGs93f5j8bb7jBmJ/ll8uPy9t224BASlSYISKkXYRTTgKl/FgvE12gcItS?=
 =?us-ascii?Q?nsG1X8V9tuz5QbVy3W2SE/rjTaY082bOBiEvPm+2ndEA135aPqz9joZ4KRbT?=
 =?us-ascii?Q?fMF2L0WfQgL+V0hqr1YF3CLu/XWaIoKQbJyGYijA8aBZL2Imp9B+0hblGiKN?=
 =?us-ascii?Q?X4yF/TDOVxzzUs4Ia1rSYWWqK/ohzsh4rcX6+i6JTOw0jQFDSS4vPbJeCzfg?=
 =?us-ascii?Q?tqz3UcnPnPqSw1Tv4qMKsP53eZ8XsEMVQlXmL4mJY4/KQi4ozzZpERb/Hoip?=
 =?us-ascii?Q?j+9bHTunlQgJIdoTG8rytbtfb5U9GIjEzFspD+pHE6AKkr9Dzn6YaypFUfqU?=
 =?us-ascii?Q?JJygnbZ4Nt1ScX3gaUjjdKh5JSezAwNLVPgmRs6iyeQtaSu2JmdtCNDyq3u0?=
 =?us-ascii?Q?FpWVjIsLXS+61q0/O9UIJtFL92btJym8MFMV7o2N+zXLJIEyROzHHlyxpxRz?=
 =?us-ascii?Q?W4i7uYhHOwrEgrGonEb192irIR4u/sModSto+/7YwgDIT4b5yL0TbEp09fTl?=
 =?us-ascii?Q?DSE/k5B+s0IDHuRL5OQBmDaTa+Mson0Pb3q9zBWVugw19ZzT2mY7crJLhI3s?=
 =?us-ascii?Q?1GTV5+kYZJa6Fi1vGU7JtSK8t9JBGxdjX5ofbo0e1JVAmry4rWxwPtxwS6Ee?=
 =?us-ascii?Q?utD69NYP7YPJoKvhPxf1/9QPIm8hUybQ/bRRxj2JsAGkQ02mQRX9s1AwSftP?=
 =?us-ascii?Q?0fX3mlDHgqjlT0p8IFAuoAFWzYNiB2XsLUmVCUp2oL+XsWKEf18sPu/9n077?=
 =?us-ascii?Q?R9HpyQu6W5cHhIpSb1Ii5v1mKK1z/4XD9gyoEIkAYRVEaF7NNp4JMKitR7An?=
 =?us-ascii?Q?YYIsddoIIvAiu2EKdrYtXxbB6/Q9Zz4E2K8Mq29MogdgvG93DROBN9m36qEH?=
 =?us-ascii?Q?NZ4DvcUc4Q2RhaGXrGaMQLcwEGqiXAm8B1oyUY4zn5N67b5JJ8LoXut30NHM?=
 =?us-ascii?Q?Q7VzpkLlTXTH2u7fg0jXQcESxykPR24WaJ9JDMJ5XWqEGHrfvVcfRbO1DbmM?=
 =?us-ascii?Q?nf26wV0RqnMEdH4nss2XtuXs3apYLL8IjfXrLJufjaF+l3XZ9b5iOi7rtvKJ?=
 =?us-ascii?Q?zJq2j02O6AhQXlnXYmh+I936/vqYO9nSoKVChuRuK9Act4TAGW6JkUFrkeN2?=
 =?us-ascii?Q?InzldDKLqV2Qz78L6Qkeb8kKOrwW63AlvERYs5MgOIdDDTd1AbDeiby8GtH6?=
 =?us-ascii?Q?5xt88PIr6Ed9oYeONrw0NlDyrdztOjchNwveycogsqDCjadQ9IVmga1cwPae?=
 =?us-ascii?Q?lVT9edibSaIe7qmE8iuM+xEcKl2o+z45Rg1fDrRLFcPrJZLCVRQLgFKiAriK?=
 =?us-ascii?Q?kbUDtRtEfYb+Jy7bNEDLMzTndGyhYM6zTuAySf16+d1FpGACqhx7nsUk72Qd?=
 =?us-ascii?Q?US3/XT882T3k3MKdu6w7u/glCyTpovK1o9TKmbDoMC1VaKNZ5B4j9eRvLwMk?=
 =?us-ascii?Q?MutOMXPh1zR4WPu71B/LIvlbLdWDFjXCmB/hXldP?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN7PR11MB2788.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9a1545c-7114-48d7-d60f-08db2e95fa4e
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Mar 2023 07:36:28.6907
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RDqTuN/ngS/qJo9sMCdbsxsbG+wOJUvUkXNPjB/XL85qAToUz2GsqOa2XfwNi5pBVPv2dAzCJiVvD5PuI4mp6EotYvVyWBFhdWAYRDUp9fU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4717
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of J=
esse
> Brandeburg
> Sent: Monday, March 13, 2023 9:36 PM
> To: intel-wired-lan@lists.osuosl.org
> Cc: netdev@vger.kernel.org; Brett Creeley <brett.creeley@intel.com>;
> Brandeburg, Jesse <jesse.brandeburg@intel.com>; Malz, RobertX
> <robertx.malz@intel.com>
> Subject: [Intel-wired-lan] [PATCH net v1 2/2] ice: Fix ice_cfg_rdma_fltr(=
) to only
> update relevant fields
>=20
> From: Brett Creeley <brett.creeley@intel.com>
>=20
> The current implementation causes ice_vsi_update() to update all VSI fiel=
ds
> based on the cached VSI context. This also assumes that the
> ICE_AQ_VSI_PROP_Q_OPT_VALID bit is set. This can cause problems if the VS=
I
> context is not correctly synced by the driver. Fix this by only updating =
the fields
> that correspond to ICE_AQ_VSI_PROP_Q_OPT_VALID.
> Also, make sure to save the updated result in the cached VSI context on s=
uccess.
>=20
> Fixes: 348048e724a0 ("ice: Implement iidc operations")
> Co-developed-by: Robert Malz <robertx.malz@intel.com>
> Signed-off-by: Robert Malz <robertx.malz@intel.com>
> Signed-off-by: Brett Creeley <brett.creeley@intel.com>
> Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> Reviewed-by: Piotr Raczynski <piotr.raczynski@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_switch.c | 26 +++++++++++++++++----
>  1 file changed, 22 insertions(+), 4 deletions(-)
> =20
Tested-by: Jakub Andrysiak <jakub.andrysiak@intel.com>
_______________________________________________
 Intel-wired-lan mailing list
 Intel-wired-lan@osuosl.org
 https://lists.osuosl.org/mailman/listinfo/intel-wired-lan
