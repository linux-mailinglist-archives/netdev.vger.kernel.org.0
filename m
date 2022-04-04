Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D33564F0E2B
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 06:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377119AbiDDEgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 00:36:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233038AbiDDEgV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 00:36:21 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BB6E3193A;
        Sun,  3 Apr 2022 21:34:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649046866; x=1680582866;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=J+9/VACJriMm9l1J/6Hp7wWQOXCr5rIeEVKxroBaykY=;
  b=ehekU/BUXTOCdZVdC63xzd6NfzGGbpmz9RWtF+5ITlaX5QQZPB9DpRjA
   HtkkIOc4x282tTihP2eQkQ6gdXCtXW5U6CxLBJk4Zs+OUj+DXSClSe96Z
   thq7FRCKsUeHvprwzLpKs4IdZjo7VaVYhEsTke74D5DWynE86poKgl7kw
   r0ZAisF/bxjQnc5T5lt184DnyrYsX3IDO01SKRli1pZkmK3soI9w0j+z4
   Lvtv3EC9m0pMQzIU22qLslbCNW/m0nCyD2nIffI8IUNtS9pCxNc3PreVO
   65CeW4HLSSuN4TLqquzFYhD1D2Qn7lFt/DclLrZSWerQzrGMcwgX8aCdL
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10306"; a="241023318"
X-IronPort-AV: E=Sophos;i="5.90,233,1643702400"; 
   d="scan'208";a="241023318"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2022 21:34:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,233,1643702400"; 
   d="scan'208";a="548516264"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga007.jf.intel.com with ESMTP; 03 Apr 2022 21:34:25 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Sun, 3 Apr 2022 21:34:25 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Sun, 3 Apr 2022 21:34:25 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Sun, 3 Apr 2022 21:34:25 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.171)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Sun, 3 Apr 2022 21:34:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IO6Iq2+vYh12xmviwDj7mATJYMgu+GjQjyZd2HhGjJwR1GkrxRmD2ET5gx+YwfRa9i5iC5FZ4bUn+CXEVkioLVDB5IHLTEOHfvmZprub3eNneCRYZnJf1BEh5WUBq+bpjHVoZdnquNDVtsu11bTNbW51o6h0nLJGImJ9sPtPnIDGisUpEs06IuUbC4nzbQDdnZ4N+TeIabGtPPv058AAjYkIoRrgn08E7OY3dFZr6OQu0P0JhicVQb6326Z0n1iAhKMETHc1GsgzrDafmIdTP4CC9Aw7fAUYuDsr5WpAMGPKDOfFAoWrfWN4X3bbP3EH+WpCHT5lsdguXEtyRNnZ9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bAr9lRYl+t3J7DKFXXXNv6+gV004td+AFv7sp8zWiuc=;
 b=iLgR7gZ4opqP7H0bLb64eAdj5w5IpzsgoVa4HI+2HqEcVwPQoozrpCJhxdOvpmmABhiVuOyIZ/z2CvKbElkfbIKUJ7CSzFYOFYYqyJFe0mSZN4WorEq2pqDeSn8USSV9hRkXPr1nDA0pFVjelfwrSKGgtIDCnVUQSsqwvn9w+TGXhlVv6tHB0QL3pevcpheChnGlWMdsZkNop7aALG9nvwSjOo3nLRyVuog9r1Z2mE79QdVQq/VKzK9AxX/nJpzw4CO1HCGxtRu0lPiS7IiXhNR2vJGOojZqklYpGQ2uJT0qrDpO2y8efU/3+jcwmQlCgJXnP8G1t8xfkt2kAIusjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB5822.namprd11.prod.outlook.com (2603:10b6:303:185::9)
 by BYAPR11MB2902.namprd11.prod.outlook.com (2603:10b6:a03:83::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Mon, 4 Apr
 2022 04:34:21 +0000
Received: from MW4PR11MB5822.namprd11.prod.outlook.com
 ([fe80::64c7:fef2:3781:92ca]) by MW4PR11MB5822.namprd11.prod.outlook.com
 ([fe80::64c7:fef2:3781:92ca%7]) with mapi id 15.20.5123.031; Mon, 4 Apr 2022
 04:34:21 +0000
From:   "Nagaraju, Shwetha" <shwetha.nagaraju@intel.com>
To:     "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Subject: RE: [Intel-wired-lan] [PATCH intel-net 3/3] ice: clear
 cmd_type_offset_bsz for TX rings
Thread-Topic: [Intel-wired-lan] [PATCH intel-net 3/3] ice: clear
 cmd_type_offset_bsz for TX rings
Thread-Index: AQHYOi4l8egKbiWBiUmSf3JXHzLjoKzfRdVg
Date:   Mon, 4 Apr 2022 04:34:21 +0000
Message-ID: <MW4PR11MB582222B135FDD63795ED3C8E90E59@MW4PR11MB5822.namprd11.prod.outlook.com>
References: <20220317183629.340350-1-maciej.fijalkowski@intel.com>
 <20220317183629.340350-4-maciej.fijalkowski@intel.com>
In-Reply-To: <20220317183629.340350-4-maciej.fijalkowski@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.6.401.20
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 30d3f2bd-d132-4d06-e3d4-08da15f463de
x-ms-traffictypediagnostic: BYAPR11MB2902:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BYAPR11MB2902D677972345EB4854DEA790E59@BYAPR11MB2902.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DBFziifzMhA/wkBOT6a04e0XPRdpcE2n12IbxDq0+LDwvP//jwu+ymlBBjapCLYqQhdd/n1FWpiqZ9aNUh4bjhDs5G6aoip8T23Poq991ThVww2ptvgyIseciw1HUatMl2ACMU5kvqQm/B2+GjgE4GU+uyKog2ZozG6SQPeqxpxx0YWLnpxdanUzMClNC2K3t/k4+J1JvS3Ke/nNmAVPmsZZi5kHd1JbqfEi57g4Ss1WpOv/+y2i75kXp7VJg3pepVHCa9FlPY3RgPehn3DoU6cPTivcyp929Fi6XvUeqSUjPBqCNvxkia46SuV+gDuZbjXMrcaE63a2Uj1TbfgTltN0ayJ6n2BP+lbmq4ic1kkd9S75bVBoP6Fb4CY9fg2CM7lBfW6D/tdfYMOBFKVe+EYNSeaniwt6469MRyqL2lYHKlmKVdsrf2PmF8mVPVUf9cOmfDbA7srfY5r9rxav2SruAcVs8z6/gaMoxcisQUDbtpqEcQW2RET7Rs4Dtw7pSGUVMdv68NXgZHRmLoHlxNNGpEF51D6hQGq3nWth5bCGTflcxSWydt34M0eEnhLD2OYHx8Jk6VE9FNQy6cOZa2ko1vG/gl4D4LkV6WB7NQPuhAph9GVia1SwXfn33Nk15aH2IxG4siaoW1Da2vbXN2qzk2q4wlSX7ORv8rKYnp7mYONxmcPxDtAzWTZrjk1DHUlxOGDscPjqBNoMStm7Ew==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5822.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(83380400001)(9686003)(7696005)(55236004)(53546011)(38100700002)(6506007)(122000001)(2906002)(5660300002)(71200400001)(55016003)(186003)(8936002)(508600001)(38070700005)(82960400001)(52536014)(76116006)(33656002)(316002)(66446008)(64756008)(26005)(66946007)(66476007)(66556008)(107886003)(54906003)(8676002)(4326008)(86362001)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?5Xu7hxO/pvzALD/9P4XdKy77jTVMI4pz3AL2uyyRSsj7ek4vvhkhf+LnE6kr?=
 =?us-ascii?Q?l5DkEHhkJvQ4AGYtRPpRbHGhDjQSKFoKsSZK+FCtN5sA2KqDsOG9enlTn3Yr?=
 =?us-ascii?Q?V8ZrFJR4A3E1+fbqZH7qEenL4zi59NWqNh2raHqBuN+ZEiefalfbk+vvU5jr?=
 =?us-ascii?Q?zBkBgWPkEdHSJvV6Ve9aCSbiwHjKidoC1hqqjP7EYyoBS+OsXUbXlCJi0gDX?=
 =?us-ascii?Q?oHwr30kchED4bLQ9B0S2Am93vDqkMi6Bd9BXPNj+0CSJVlFbktyzKLh9t0Mr?=
 =?us-ascii?Q?4807JqWQ3TZkhOkqrOSjIyO0WfLPAp7i928Ryw+Vq1iYZaXWUEGZumvYnPV7?=
 =?us-ascii?Q?wlCMNelDP8ndUtzNkkkB0Xt4efntYe+BOPFQTtrBn+AThQCB+4slhGMndgFf?=
 =?us-ascii?Q?swxHdIcMRzinlW9A3ZqRDqgosjf/wbDpjSzMfKw3A3ImNi0BIw+dXk4tzX/Z?=
 =?us-ascii?Q?TRErGmisswMjQIg+Gii9eV2Vlq2PMdYqSxjK0HB47oZWQC+o2HTn54mF6OiX?=
 =?us-ascii?Q?IVatOiZpfctvB/i1kB5fDIzi3BL4z492tujXnhNK5GJuM4cmK/cAhAwkMBlq?=
 =?us-ascii?Q?7OTjyYWJmPA6hPJ4WqKuM7X65Z/M9hsdrDBZyBEh1DAEw2uDeIs1B6OuNEHc?=
 =?us-ascii?Q?f9h0/YBhVHvZXIfECBj/gA+z+ZJ2mmBUsy5aoxOAFhOXTv/CK3tYX0mFZ/EL?=
 =?us-ascii?Q?ro5qI7GNOffK4StJMP/dD6M6lhpIQLfC+0p7UbrPKDuFgXU7bIOPXhAfPLcF?=
 =?us-ascii?Q?nyShAeTjYGybe2PYKAfURue8l1+pzdmLr5DIT0IPT2dXf0BCC0uagd0AOf8M?=
 =?us-ascii?Q?NMMu5zjWjZnAYp1ZZx8MMq6Y4fVEYalk9HLK2nY7QoLoInuB7eLIHty+KM3m?=
 =?us-ascii?Q?gUdCdKg2Gv62/ZVwxhxfY3AhH8I/z3tNEkTBH86FUPnTe6vAKHWTEACXhLTB?=
 =?us-ascii?Q?0SRykxcVP3rS4YPLxN6S3Ed5zode1Vi8Xg7I3Te7kGI4zt8XpA6gMKOe4YRW?=
 =?us-ascii?Q?YUbMBZOp0Eik7MW3LC6sQCHq4eO6elBuDjKfiQXZY3ivWjghGWn55ZSsC9q3?=
 =?us-ascii?Q?ksE0ezMplUtsdsWYi60i+4t2lnaGfAEchZFk/Ik5Da8F6wFvN3y/vMpPGzY7?=
 =?us-ascii?Q?tsK66RDRZp7YyGUd+B8H8Wi1gqPw4+0v6qHQZxssyqmlM3MuVJ6X6VogcrrU?=
 =?us-ascii?Q?5BvCXHBcGpQy6uTLtJX+OaX0WEDG8W7QRiXSQcjfaqKMWPWKZNJ2s3Ct/0UM?=
 =?us-ascii?Q?y3onQ+Vce4dfJMHJgvSOIT5EaS7rdTprOC5UDb+8uIhGloaGQjOEDZJpbkDE?=
 =?us-ascii?Q?H8E8LgqlJm+yOxcAXXlnqOHDHdMxP/aXwkHE/x0gUpbDVqG3wKgFJqorSOuq?=
 =?us-ascii?Q?dXWOiMmdSqa6prF2dJ6HHqd/CNR/iUFtNN+2GNmR9kv1dow4zNc8fv4G49IV?=
 =?us-ascii?Q?qzOawhekKVy+2+emYRvU++aNFimibjlWHydfufBOP+VjSYaOKqh+47nNRAip?=
 =?us-ascii?Q?4OzCmcnB11pLcnsbv9JLXRk5EmTcsEuepFffXDYh7okM4P1pCeRYCuryT4/1?=
 =?us-ascii?Q?S5r3zKJZLHcCQGRxzZj8+XJvp9LUNxZjTk/W3768PAp153769EP7whgl6Klr?=
 =?us-ascii?Q?oXH0O5XS58ZXg8P/6rVV2rUtUQnCbO6B/sWq6jUV9Sv8y6gGl1rLp6QB8ERe?=
 =?us-ascii?Q?R4d+rLkJIIFwjpy+2o21Qxsrhnk/kU/KEKdZpFKj+C5Wr7i4WIxW2EqGZBIK?=
 =?us-ascii?Q?/MAaO7lcskA8HT/KafXcguphaH1z70w=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5822.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30d3f2bd-d132-4d06-e3d4-08da15f463de
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Apr 2022 04:34:21.7321
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kGyK7+2rcvgJSnDBULgNcwsDEBRBZ8gYLqw6W1EQ+OTyJW5VPPT14Do1Ly88/HiXF5Q4Blm5ctGlOh/0RkYbafL15Gzl3BeJglIRh3TL1dU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2902
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Maciej Fijalkowski
> Sent: Friday, March 18, 2022 12:06 AM
> To: intel-wired-lan@lists.osuosl.org
> Cc: netdev@vger.kernel.org; kuba@kernel.org; bpf@vger.kernel.org;
> davem@davemloft.net; Karlsson, Magnus <magnus.karlsson@intel.com>
> Subject: [Intel-wired-lan] [PATCH intel-net 3/3] ice: clear
> cmd_type_offset_bsz for TX rings
>=20
> Currently when XDP rings are created, each descriptor gets its DD bit set=
,
> which turns out to be the wrong approach as it can lead to a situation wh=
ere
> more descriptors get cleaned than it was supposed to, e.g. when AF_XDP
> busy poll is run with a large batch size. In this situation, the driver w=
ould
> request for more buffers than it is able to handle.
>=20
> Fix this by not setting the DD bits in ice_xdp_alloc_setup_rings(). They =
should
> be initialized to zero instead.
>=20
> Fixes: 9610bd988df9 ("ice: optimize XDP_TX workloads")
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
Tested-by: Shwetha Nagaraju <Shwetha.nagaraju@intel.com>

