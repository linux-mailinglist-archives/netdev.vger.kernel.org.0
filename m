Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AE836A9CFE
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 18:17:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231482AbjCCRRt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 12:17:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231559AbjCCRRs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 12:17:48 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91E7D193F7;
        Fri,  3 Mar 2023 09:17:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677863867; x=1709399867;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dRSi0iivJHSGmJbwVNzdyl/XAYa+RL5c3bSm5WqBGwQ=;
  b=lRRzAaeQSyFkbOYVTSjqZEYSCVIflZwHihhWsCoJjykTm+czbk+ngLrR
   tEFynGxNjEGoShrgX+R8rWEmI/HSFm2GWLbCSKgLnGfGDYaOBzLGwNOUI
   /fpxtLhA/X49Ocev8+2OyzOm9143Imp4KjPx0FqK5TXrG31a6yBFdlauP
   arjeuBs28vZ2GmaRsTlyRxnee8uXYcuJoNkKh6nGu6kK0GQW3TyX/Xirx
   Cw9l50Dz6cPw+f2JaH2GkrROjQTV6uG3ocVjxMRTYxSadlFgZHBhneUnh
   tJX+V73dKvC6x0Hiqqminfaey7GUDUL0cjO4rFG2BwOfSiiElRlLz/409
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10638"; a="318922211"
X-IronPort-AV: E=Sophos;i="5.98,231,1673942400"; 
   d="scan'208";a="318922211"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2023 09:17:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10638"; a="785327662"
X-IronPort-AV: E=Sophos;i="5.98,231,1673942400"; 
   d="scan'208";a="785327662"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga002.fm.intel.com with ESMTP; 03 Mar 2023 09:17:46 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 3 Mar 2023 09:17:45 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 3 Mar 2023 09:17:44 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 3 Mar 2023 09:17:44 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 3 Mar 2023 09:17:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GnWb3C9nTNj/b+bBEdbjn9GZE04ek8TOoYwrj/xRpsgGCpAyZIJno3M0L8b8M19smuGQWnR/DKQIYkDEePVoBG9lwSoKH2Sr7c1CAiZRRbDT0i+GamTrlmm49v6AT9VbW1eyLgpyvuLz3PoRJQsPH/y0RTWUtDkYVDHJOwz/HH0g8eliYqUMUtPZhGpCsyPtR0Xnee0XMn1uWnBhWPoPmF4aMQGRdYn++JcFgruXP+lfPZQpjWIEikxbN+E3gQjch3eZ/CB/XdVzrNpeiAesWmHrHlSDv13PK1c6u9jwysQ5UaapPqhJFo8pTq/yv3zM+qB3DIhc4aU+/z/tB5i+Xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dRSi0iivJHSGmJbwVNzdyl/XAYa+RL5c3bSm5WqBGwQ=;
 b=kAUD0A3qgzO0gCw3e8BDCiCVBEacy58RI3Rg3r2DBTuEnJMYK73PskEPYSrxUoLGkw72pV28afYrxfgjxhBhzk5shUG9aVjjQEqZtzog7MdzC1/KvDB2gk4FXf/eFzVTtwnMr7dm2Rto+1xRAZgFY/izC0QQv/LhMSiLgvba7qmjv1B0UmZFG0z5il0rZ+Z9/vXA9g/W4U/NfH5IyW1gcvSpkl2/SDWh9Z0JNP2ScEC73oqvfeEeiTmnlAK8Ib2nrXQdeodoCaP6E6LYcPkxAlkCXDBgcsxBhdMJ1wubTW1a9hPyavCkmqa0ACfjByIaYIYNeUOv4PKBVM8DR63M4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB4045.namprd11.prod.outlook.com (2603:10b6:208:135::27)
 by IA0PR11MB7883.namprd11.prod.outlook.com (2603:10b6:208:3de::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.22; Fri, 3 Mar
 2023 17:17:43 +0000
Received: from MN2PR11MB4045.namprd11.prod.outlook.com
 ([fe80::6b67:1c73:161e:9444]) by MN2PR11MB4045.namprd11.prod.outlook.com
 ([fe80::6b67:1c73:161e:9444%7]) with mapi id 15.20.6156.018; Fri, 3 Mar 2023
 17:17:42 +0000
From:   "Rout, ChandanX" <chandanx.rout@intel.com>
To:     "Sarkar, Tirthendu" <tirthendu.sarkar@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "Kuruvinakunnel, George" <george.kuruvinakunnel@intel.com>,
        "Nagaraju, Shwetha" <shwetha.nagaraju@intel.com>,
        "Nagraj, Shravan" <shravan.nagraj@intel.com>
Subject: RE: [Intel-wired-lan] [PATCH intel-next v6 5/8] i40e: use frame_sz
 instead of recalculating truesize for building skb
Thread-Topic: [Intel-wired-lan] [PATCH intel-next v6 5/8] i40e: use frame_sz
 instead of recalculating truesize for building skb
Thread-Index: AQHZQwnulhaxSmcJfUGtl5tBvFMe767pYcmw
Date:   Fri, 3 Mar 2023 17:17:42 +0000
Message-ID: <MN2PR11MB404501CDB64CBA3A7F1BFCB7EAB39@MN2PR11MB4045.namprd11.prod.outlook.com>
References: <20230217191515.166819-1-tirthendu.sarkar@intel.com>
 <20230217191515.166819-6-tirthendu.sarkar@intel.com>
In-Reply-To: <20230217191515.166819-6-tirthendu.sarkar@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR11MB4045:EE_|IA0PR11MB7883:EE_
x-ms-office365-filtering-correlation-id: f8fab60a-4d21-4ddd-2b00-08db1c0b32ea
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZNxz+hqdXE1wsUEdkrtfBTUVgceAMNDCVi8wXjqJklx+6vjhYPCfFakkkkfU4p3V5WI0LRI2E2uTI4MuRrGXXZgIgdl6zyP6GSdG+xnD5trnJAcKugtkGArQs7PJ3hBs/F3WraHKok+6V6FuFnCkOfiCq7PhL1WdamwJBmx4Te5SFNciyqMXNtktOQuY5Hy9MKQYnlbNMKhTBbsH1qT0Cbkzc6FIgUGxVnT+JJJIiL2ce8p/nJqf/jlJyvl2MjGbVVOb4BqDwC4sk7HYkyr+sTOIsl7lOKxLhiiCJUQJj9+6s6JJz/wPDrIFcmkJvhEtAuk7z3IIINSW+C7qW6gWRZB1hxQZfabBSDXKFknph4b5OtW1IETFKHxHRsoX9YNQiiOFJLtp9LTUgY4IIbcMFsgHMc/u5J8/Hz1qXoMCvIkpase6LjSbrvXp+p3/w523Blzsr36fHj8/ynFzWMfdZDiKs3T+LZzFFsMD5srGJ4lb1afKA0B/gOcTbYsMRy/LdHdJ2LYARSMTyScLkQWb8h7o0idPdaxXBmGbNMDm3+IKT60+3r4xW8hHYEXNzY/nuSj6qM+NsMUUtwJlsZoTjDxLNeAyGclek+YcQh555h7tRET6YCJQdOF/IVHluNlFqwstaLR8uKagPASd0/AR+rP82Ox2GNh7LDhRmHOYV2Pd4ddsq8spBqk3ENAC/Kr5CYnlpQUPMUm9Xgc9QuwiVw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4045.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(396003)(376002)(366004)(136003)(346002)(451199018)(7696005)(186003)(26005)(71200400001)(9686003)(478600001)(8676002)(4326008)(64756008)(54906003)(66946007)(76116006)(66476007)(66556008)(66446008)(55236004)(107886003)(110136005)(6506007)(83380400001)(316002)(41300700001)(52536014)(8936002)(5660300002)(4744005)(122000001)(82960400001)(38100700002)(2906002)(55016003)(86362001)(38070700005)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?KqfXEm14MR2w8UnejQIbXHDOPU+1XxT9twdh+/xvwcyPHdqE6C9013jeTI6m?=
 =?us-ascii?Q?KYZG5MjV/9Pd9G/XGujIolOG/KBgc3h9s+C9cOQJkTDh8NUCmDikVKDVrRu4?=
 =?us-ascii?Q?G76CqJMldLDQomi5P4xAWuJ8eg0o6f81j9/tM3LlQi+068ySTmGBToHN74jx?=
 =?us-ascii?Q?HlZHuoWlrk4iZIVHQqx2IzOtEWu9l7NxoERPIUNP94syBiTcD/BnzKpgPfao?=
 =?us-ascii?Q?cs1Vm4PZJrHOt5qbrzak723Gcqki6FsAesgpnQhuqiE1jCMmQCtx+0LHhLgB?=
 =?us-ascii?Q?7CdPFgtDTshiX2Yhz6ObLeTW2LpBCFMQbsw/m5AzbPrZPMxu1chgvu2QiJzR?=
 =?us-ascii?Q?ZbfrxftMurUO7IfQgbmJxStqRsFWYFZGCHGp4D9GMTMygBenudNp4SdpKpUN?=
 =?us-ascii?Q?YDrtqFPSY3D3QvAv4mJ7ipd2yY5WqEFFBIue2hBtW3G/X3z82nO9zJ4Uazjg?=
 =?us-ascii?Q?MrlF86zilC4wcQ2nwjnYNzAi8Coi7jy7Gy/eFjYJsavoxiu5kg+e2oUhPcq9?=
 =?us-ascii?Q?C990pQcGrJh94VfyVSCrWfEUknUHx+mkcSo5gfK70UAyvX6uTIsfiime4ujh?=
 =?us-ascii?Q?GiWe6I7xWUMT6yMz8wBBA9j4G4Bb+7YgIpVlMA5qM8lQvoblyOJM0ReX6wB8?=
 =?us-ascii?Q?6FoWBb7rRh8gyOzpvONDQivjO6jdpdqJTLYv9unzAYZ2nTsaG0eN3PydhxJr?=
 =?us-ascii?Q?klvylWsDsssCanu7eJt+xPXG6nam4IunfLR/W+Wl6zsm77AGjGMq8nd/KQri?=
 =?us-ascii?Q?lFi1eOo0BXsKzyohAwOcarVAue94j5w5UToeK4yK2Mq00insWhBcz/4mujx9?=
 =?us-ascii?Q?dmMyVur4jLaJ7R88uwMU8xjD63wuqpcqBNKpAegauf9OmNQQ6ohrWmNCWtgg?=
 =?us-ascii?Q?2YBIgq6+MdEo+2Bdv9GyY+PQwsjpWMg9oUhUQwDC+Z62PE58O/CT0iTP+Mi3?=
 =?us-ascii?Q?CsXbLqNAncBNWWwDfcIbk+zis44BDTUn7OQIxBz53aV5qtDKKfJutNVjTxAi?=
 =?us-ascii?Q?aCLzRmDzUNzEwb1F6OwtTkt+y96i3yqx+hS8eZ1U+FhW6D9asaLcbTo7tKIh?=
 =?us-ascii?Q?1Zybw18N+O/EIh6m6dcIwtuWVbhK60vEOTeXi7HF53a/Qt3cF0S3maYGx0Tg?=
 =?us-ascii?Q?0A3nu9wPCa9BlxXsBy2R768T6ORIZBZgVTwyG34EGfnovEIwEb50/7umKXVz?=
 =?us-ascii?Q?EtJST6G9cOkhr87qVdJQRT2uBWeIGLqkjV/aS6DEQqg8YFOmskJBiF8VUz1P?=
 =?us-ascii?Q?WeiBe2/fyxr65X5CjhC7+ipkOqOk30oTYgr6Q0nMyj8FB8NgjnE3mTfc8eWl?=
 =?us-ascii?Q?MaDNh+/4PYn2nPyZ1gtQLcU5o0drzdISfMd1VGH4iZ730KKJkK0ZPXVMaKdO?=
 =?us-ascii?Q?x2tk7vnniym9U8/8cdTZ/Vdj+W9RkO432Lg6Kujswx7OFPnw9eIDL8PAGtSr?=
 =?us-ascii?Q?XVH3YLq8PhLoMFErSIpj5FFWljzB1qLGpqrM9JMEhYfyqc0UEB0Ap+bDetWf?=
 =?us-ascii?Q?g19K52N49sGFauj5UnIY+2snhAEGDmVYYU5J9gNhjh134GaOwcOUuWyRHyu7?=
 =?us-ascii?Q?SEc5LFJ9iVEH+d3N3EQAgKwIsBS2B/N4xbtUZDYs?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB4045.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8fab60a-4d21-4ddd-2b00-08db1c0b32ea
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Mar 2023 17:17:42.7013
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: knjnn5f0i/IYjnkEXrgY9DoxOPCQyIXIJiA12krE0LINhjiCm5hepXrsn10dvk//R6cYtPAoI2SMcfkkY0X+Pg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7883
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



>-----Original Message-----
>From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
>Sarkar, Tirthendu
>Sent: 18 February 2023 00:45
>To: intel-wired-lan@lists.osuosl.org
>Cc: Sarkar, Tirthendu <tirthendu.sarkar@intel.com>; netdev@vger.kernel.org=
;
>Brandeburg, Jesse <jesse.brandeburg@intel.com>; Nguyen, Anthony L
><anthony.l.nguyen@intel.com>; bpf@vger.kernel.org; Karlsson, Magnus
><magnus.karlsson@intel.com>
>Subject: [Intel-wired-lan] [PATCH intel-next v6 5/8] i40e: use frame_sz in=
stead
>of recalculating truesize for building skb
>
>In skb path truesize is calculated while building skb. This is now avoided=
 and
>xdp->frame_is used instead for both i40e_build_skb() and
>i40e_construct_skb().
>
>Signed-off-by: Tirthendu Sarkar <tirthendu.sarkar@intel.com>
>---
> drivers/net/ethernet/intel/i40e/i40e_txrx.c | 20 ++++----------------
> 1 file changed, 4 insertions(+), 16 deletions(-)
>

Tested-by: Chandan Kumar Rout <chandanx.rout@intel.com> (A Contingent Worke=
r at Intel)
