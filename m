Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D661500644
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 08:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239042AbiDNGoU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 02:44:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234478AbiDNGoT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 02:44:19 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 867A03B2B6;
        Wed, 13 Apr 2022 23:41:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649918515; x=1681454515;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=nXF+pZdAt7v3TwIDTmHwLaGWf75vmwfzScwxX3+KNE4=;
  b=cW0CioG5KCdQ74/vvn0DWNf1MASNWB8xdpnZWKvypoGbj0xY+nLQ2nAg
   X2tHuegDro2A4jUPJRxHOogrf1NUpeJScDfJz/852b54pNBxM0ALftRjP
   6UzQR2686mHAlacX6CsS5TJQ4nbh1w1Hy8jJX8HxQ4WCbpXPsLG+YvCiY
   o6o0/kuz0wtvvgtvtaxladT/MBha5ppVYYFcPmIIr4lV7rVDNy+1E0Nw0
   e97zBb+JOs3nC/7TK7T7VwfUl7NJxJ1fJ8O1vs0b8wOTPUXz/vrt9lybX
   YMOBrhCjHCvDNvSxhBSAQqXmJ/Wu51QMDR5tP5+RLCh1xnPyimKtNSIeJ
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10316"; a="250152151"
X-IronPort-AV: E=Sophos;i="5.90,259,1643702400"; 
   d="scan'208";a="250152151"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2022 23:41:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,259,1643702400"; 
   d="scan'208";a="591071865"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by orsmga001.jf.intel.com with ESMTP; 13 Apr 2022 23:41:54 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 13 Apr 2022 23:41:54 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 13 Apr 2022 23:41:54 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 13 Apr 2022 23:41:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oaOZuOS+3r/ezFlM950uTcKDb9VlabnUn1MS+2pwGLUO50+8fUz7GkUAHWVb6QryiprSz26qyeyA3DLSdCOAZlgLB/hiMs7VV467K0ze4svfuzHNDus4dbegLk6t9f9FVMSsdkxynfI2wccYGt0csZ3vLgWIbcvKOVkvGTDfqE+HqMUN1gZ6K3RbNrBYZSoqIOyKXXTxi/NtY44WA41UfOL/PD4s6YP87R08S7ahR9hHxvvvp6QcUi+WIEz8xaDJgy28yL+eocbg3EhP2qjWdxRFBsHOXB3p93wtONUl0TkiUsQbjxB4GkOySWDdV9Cxob5AH73w3N14xUwW2QQjWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZHH4cX989dKwuRp99Zu+WqVq8GGW9yRUFVHaZRwQ2j4=;
 b=fyAUCP2r2A2CXjkzrIxgJ/fFeYFmQREvWyNMx1FXXXyQj9HxIXFLxjf7PJUsiMVyN0faOboOEUFjopmJ4l9tIJeliS0P4LI6L2yMULWyE08bpXgnAKkFMscKGeJ7O6BpmCYbi++RaEQ4m4X80xlEhMbRXTdUDuvOxKkjNqMB0/bKdkjnlVyaV1rMa6pBCujVJ0VJXPapHEvgH3cRv5PxNjXm+vXbeEUL7MDIP8kFVzIkkpBUrRYVIfPgjrn4sZfCI5jT3gw0VvM/IDE5awnabV/LD8SnLZuWhIkaMoO7sUoS7zkEF9YXPxg0KPz/q5/zyj/VztOU5jRpHGyAXkfFmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BYAPR11MB3367.namprd11.prod.outlook.com (2603:10b6:a03:79::29)
 by SJ0PR11MB4816.namprd11.prod.outlook.com (2603:10b6:a03:2ad::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Thu, 14 Apr
 2022 06:41:53 +0000
Received: from BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::c8d9:8c9:f41:8106]) by BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::c8d9:8c9:f41:8106%6]) with mapi id 15.20.5164.018; Thu, 14 Apr 2022
 06:41:53 +0000
From:   "G, GurucharanX" <gurucharanx.g@intel.com>
To:     Jianglei Nie <niejianglei2021@163.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH] ice: Fix memory leak in
 ice_get_orom_civd_data()
Thread-Topic: [Intel-wired-lan] [PATCH] ice: Fix memory leak in
 ice_get_orom_civd_data()
Thread-Index: AQHYRdCcBpO6yZ8+Y0ehAJFIE980MqzvCaig
Date:   Thu, 14 Apr 2022 06:41:52 +0000
Message-ID: <BYAPR11MB3367D0896E6DD74BE81196FCFCEF9@BYAPR11MB3367.namprd11.prod.outlook.com>
References: <20220401080051.16846-1-niejianglei2021@163.com>
In-Reply-To: <20220401080051.16846-1-niejianglei2021@163.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9e932d43-25cb-41b3-3b87-08da1de1dc82
x-ms-traffictypediagnostic: SJ0PR11MB4816:EE_
x-microsoft-antispam-prvs: <SJ0PR11MB48162720A1928BDA9D2747A2FCEF9@SJ0PR11MB4816.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kDT5Jdk1e1diXcvWPki5X05blgUbtVp3Yb3v1tZthPjfnu9hPScLXUgvY3g5DPp73JuyCQh+F4cB3E7+nVMiZOvlB/foC6epwO1M7MJb2z1A4EYgkDdl6x5NhRVVgDsGAxcKomWhX48fJjif+VEC5bqMel/jhsVaXioKY9/RsHdemLRa85sJSC4QpOffNoO/3lJydyxBdGhJNCeq+TETRdQHzVizxbj4F/kQ9q5tKGuCOvaV/mWpo/2CH/3JWxmrQz62d7jZHG71hUJkAqtMJMuQkHdKSU0fgPIGcqYarYBN1C4mlZD4qfjTLXczkhRyTxSvA+rok9kufO1UQ1b6ZBbyRT0KvC+nn3X6CpVfKVL5D5bxSJRpfuugpnSxQvXOUoBl7sBucVG7TBk6x/tmwjpP9OLA86Y1wRAK5R6VhqE3ntSPs7dGciSeT0IxQBmx9LBB/CWhAYXkCBa6WjVspR18ooxKDElOMCV0GftZQoP58sm0/9/iRu4x70eeIU9tfPepaqIzjh92RV4Bvj8bOPsWzf9X1P7p4VP2jV7Qd4074DOSW+kvOotQJCqTo9fvcOKvQQH35Zkt72TDxBFqg60cLht25UrcQk12ORFbmCQVswyUPE4fgiL2npjqjaJx5C3yNuLLcc48a2gaXfNCVK4BoRve3Yk1/Ri1+z/UguTWv83ro4/HlavTcXZC9rGgIC+/Ckambf9RyMeTSYRU3Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3367.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(66476007)(64756008)(66556008)(6506007)(83380400001)(55236004)(55016003)(53546011)(7696005)(52536014)(4326008)(9686003)(26005)(186003)(33656002)(71200400001)(5660300002)(86362001)(8676002)(82960400001)(8936002)(4744005)(2906002)(66446008)(76116006)(66946007)(54906003)(110136005)(38070700005)(38100700002)(316002)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ixopFbUITuzZTn+ZqKOorszaa+t88WBNPPN7wkqlkviEb1bDhG3S7xlS9V4C?=
 =?us-ascii?Q?+Ms31gSp6HY52OeZV+sb1Wjuy/ir3ey6w/kkSBuTVqQOq4cnR8TcBKCBEkxT?=
 =?us-ascii?Q?2IbJ7CB8PVPyIU7cjKtQUxKE3cMVXCUTl52Ca7fRWIzK1PqWMvt7boF7S7SW?=
 =?us-ascii?Q?Zj8gyZ/fke92Gl16N9ilJIz00W2gz9fA1MJ75NVdbr09vxgpYDey68ipYwJ+?=
 =?us-ascii?Q?X8rRgwGqgXz8Q2VxZeoVQe94ARDXgrTdboEJRypj9AxAQkK3/M6AuYOq8YM7?=
 =?us-ascii?Q?omxj62mz3wk3Y2ZdUachsNoIczzkCyiP67MNF1g5I9Wu9e48/LxmPl1B8oWr?=
 =?us-ascii?Q?fDYLjltDQH2upPBrt6gKRzuTgmQn3rTUAXBpWfUN+5h8G0OJsPnP5VNgeRSM?=
 =?us-ascii?Q?WTTaDclo0kWBCmdPIboG1OPsMZ2tEJ7KGZKtGuUn3H7kLbZudI/VSuLXsEZT?=
 =?us-ascii?Q?jdXneFPpeLewmPA9waHOyOL8pkXpozfNrAIn8axYR/EPWPGHX6w1LenBJXeX?=
 =?us-ascii?Q?l5srcR8IW7L8h5/9h6FCgNygG8L4xXakL2nOz3V68hnTJY+YcRhzt3woQrV1?=
 =?us-ascii?Q?GIGY8LuU5RIVuGYbuA02IjuXxuUmsMar7sO+nKshpUXYk1cTurN8mXbxrAKk?=
 =?us-ascii?Q?lY8fGYaEV30TNSU/KqG3V5uhR2iG2RjT0vxO5TIkTlVqKm/B+KhC5uJ5/07U?=
 =?us-ascii?Q?p2i3tcVvNrxLPCwnX/mBh8SlCGjFkoyewWUWC6y+zk9GtRmT3mq0rNT6v2oG?=
 =?us-ascii?Q?T8IZGbxvmhvSHlYsBYRYp7aSrSO04u4+vmiCsNckc0qZBnGYqnZEjaAam3WZ?=
 =?us-ascii?Q?At3fBBMwTg0XSx3pP8cuDwiRaxgBUOFZGYZZm9yK0G1ML8gxytIpShLidCjI?=
 =?us-ascii?Q?cZ+nPDs+8N6UMQWRvrMeY7MuG6PWznxhn9VsrTkU9v1tR/opZC8mo2jibZm9?=
 =?us-ascii?Q?1mvYm4tjCOApVS6vQo+Cn43ERzcD8qxROv1dtQb1HZK9vSkTjk2TO9/XHGzo?=
 =?us-ascii?Q?PMgpXI29NZAPqTT87Ty93BT0e2j34oVHww/tSCNp+otS7rMBU0h1eDHtexay?=
 =?us-ascii?Q?uzI5GnqmmCbCydcGJzqdYPTUWRca1SYyv3nuiEANm2bCkMWRSpnTNUKJJppj?=
 =?us-ascii?Q?s96/iDQAP9r5bvtuK1NCB5r9OVABxiBEsYYa3rRcn0wJELjUsg11spYFbn7/?=
 =?us-ascii?Q?8DZYazgrgVTu8H4983+YErP4DZ8GF6KELO+fgveBdFPNlCrgYTcrEUF4paRZ?=
 =?us-ascii?Q?v3qqt9lTEOKl/zOOk166gsXXlWMx4TIBRS4KxxVsJsOTUkgAJ9bFGr26pTsX?=
 =?us-ascii?Q?4luaIrc2/JtkfGSu4CvmTGbAqub0VRN0JXrV1BIUFUS1kpyNLvWrNxn4cbsz?=
 =?us-ascii?Q?XBFjWw4GcKV6f2O9q0ChNkISJLuj2fyG5BJzd8+cocvXIGrOAFF7O2DpKOVg?=
 =?us-ascii?Q?X4BVgeq2WaKNlQOPmV1KdTmKprz/X/CcHYFwe4K3ZRbF6uxQsFPjVbFsHEIY?=
 =?us-ascii?Q?ykaKR2FGA6b8JIVliqN1pU4qW+0zhwdwblUMgQyQUJSbncTZDItTyNhKimE+?=
 =?us-ascii?Q?7KwEwpxENkq1EN6MxpI3dkT2X30Bsgqc2I8STVlfNG54uRzpssVJb7lRy879?=
 =?us-ascii?Q?obTfMlz7PC3f6v5vQMmLv9ulvDJGqQPDZjlUFRo6MYAi/dDb985qNYlRQTCq?=
 =?us-ascii?Q?myv5VY8kUVHx3lii6FHsR04qiDGK05F3TJmEoXMqHQZruvzfquCMtShY1AqB?=
 =?us-ascii?Q?n9brZI6u9w=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3367.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e932d43-25cb-41b3-3b87-08da1de1dc82
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2022 06:41:52.9466
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g5EF7Z5Xtzsd/LQv2/Ngn9gOfUmrEIJIM0blTI0gaoqpDIOPEcd27vaIN6H2/UamisDxnT+tCO4jGNWF8/lklw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4816
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Jianglei Nie
> Sent: Friday, April 1, 2022 1:31 PM
> To: Brandeburg, Jesse <jesse.brandeburg@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; davem@davemloft.net; kuba@kernel.org
> Cc: netdev@vger.kernel.org; intel-wired-lan@lists.osuosl.org; linux-
> kernel@vger.kernel.org; Jianglei Nie <niejianglei2021@163.com>
> Subject: [Intel-wired-lan] [PATCH] ice: Fix memory leak in
> ice_get_orom_civd_data()
>=20
> Line 637 allocates a memory chunk for orom_data by vzmalloc(). But when
> ice_read_flash_module() fails, the allocated memory is not freed, which w=
ill
> lead to a memory leak.
>=20
> We can fix it by freeing the orom_data when ce_read_flash_module() fails.
>=20
> Signed-off-by: Jianglei Nie <niejianglei2021@163.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_nvm.c | 1 +
>  1 file changed, 1 insertion(+)
>=20

Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Int=
el)
