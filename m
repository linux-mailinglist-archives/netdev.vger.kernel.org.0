Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBFCA4ED7B6
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 12:22:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232616AbiCaKXy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 06:23:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232384AbiCaKXw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 06:23:52 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC3D714866C;
        Thu, 31 Mar 2022 03:22:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648722124; x=1680258124;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tTIE9mJkVxwK8PQEbU8YTReJktB3ypz9SsOPvXWFoTQ=;
  b=huqxxwpNDpaMu0ULQFWaC8oXmwAjQKm85nRJiIyeZsBgVE46lrM+VlwI
   ugwRpoRxncuYkbo2gs3KxyoN4wGabQi9q0sF89ZZJBw19SoRwqJfi9f8q
   jUc8DR53D2XLLCwO/BXEj4lWgKxAbRnIwEQ2Bexj3HlDhdvZUKXJ0UsIg
   WOtTY6LOsT+3GtSQHXWBGRFLoIsDBkRNgd6qZcRYP2uI/9FQJCqYTm1Yo
   Ios0M04F7RldL/IHO/SP2Lh8LIMhhN/KUVdJqYBC8S8N4F8/jRGCI94jL
   y4/uncedJlL6P/x/gPRjQXu8o3hEaOnvVcJr/+oVSOJL10g4dRpl81CkI
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10302"; a="241938461"
X-IronPort-AV: E=Sophos;i="5.90,225,1643702400"; 
   d="scan'208";a="241938461"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2022 03:22:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,225,1643702400"; 
   d="scan'208";a="788359773"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga006.fm.intel.com with ESMTP; 31 Mar 2022 03:22:03 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 31 Mar 2022 03:22:03 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 31 Mar 2022 03:22:02 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 31 Mar 2022 03:22:02 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.107)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 31 Mar 2022 03:22:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IcvgPnXL8DYQBY+N31rjJ+8Bv2i07zspmWm3QEOo/N5F0X2bYnxdhwoa7TChV5lGACHsXLwyOCjcccnsxh0p2cjhnO0RrerFocNu9bZ+o+gKvzIJte6g8noyjCY8T3gmMHaMGaME9x6kq7MRwFbGw1hM+QKdEIbCvWtzKdPIHKtZhWdUgqHgHL0iRz4zdk6Na3r12taV0Wk2d3dtryVSyoIGSn37b0RkDxo1yyaOWKNG3DM3b8csUvp2SlsM0CITVl3dSDvacZfLY4DpZQNEj0LHOMYxWIOYAqyGcFV9rrVwPqMrAzgoIAMf0Y+tujZ9uYluOWmrH/y1yGWPxDg2Uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AU7M8Wz6TY3G/kpYfCUZfhtMcaPHqMAgwIh+rV6AbVY=;
 b=cQgtAtoWNPdzwOXqzcPwQiGXr1dfTVsD6F7NmoKaZXRTvhLPPUvzdxC8VQs0ZCJqYS+e5LrjYNnoxE1KI6HtLGBURHqdFiXzfyFJwkn8mUmj+0wFbr9yJyZYDLCZ1dWlfQ/jktgtmuEevI3zlBXFSZG4g79aQuMNh53vHM5bL/+JiIl62hYnUtJxP89TlFtVajg0ga9iVuRZHkfNknmJnSZD/VqGfAjf/kzQKMeYDHAs/95mJawO1Ke5JnNjDqZWaDJBbRQ2uxZ5FAGaP1UKrQyX8OziJ/W1pzJjObqZywrABuhGkFxTwWEDmV5sLUmE328cZPkf/CAN/4RCd7BMLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB5822.namprd11.prod.outlook.com (2603:10b6:303:185::9)
 by BN9PR11MB5386.namprd11.prod.outlook.com (2603:10b6:408:11b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.21; Thu, 31 Mar
 2022 10:21:57 +0000
Received: from MW4PR11MB5822.namprd11.prod.outlook.com
 ([fe80::f40d:5cd8:1ecf:4b95]) by MW4PR11MB5822.namprd11.prod.outlook.com
 ([fe80::f40d:5cd8:1ecf:4b95%7]) with mapi id 15.20.5102.022; Thu, 31 Mar 2022
 10:21:57 +0000
From:   "Nagaraju, Shwetha" <shwetha.nagaraju@intel.com>
To:     "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Subject: RE: [Intel-wired-lan] [PATCH intel-next] ice: xsk: check if Rx ring
 was filled up to the end
Thread-Topic: [Intel-wired-lan] [PATCH intel-next] ice: xsk: check if Rx ring
 was filled up to the end
Thread-Index: AQHYOiiOjYwEsOJntkmtQ8AbjXr5rKzZXZaQ
Date:   Thu, 31 Mar 2022 10:21:57 +0000
Message-ID: <MW4PR11MB582268F689B8EC10514112B090E19@MW4PR11MB5822.namprd11.prod.outlook.com>
References: <20220317175727.340251-1-maciej.fijalkowski@intel.com>
In-Reply-To: <20220317175727.340251-1-maciej.fijalkowski@intel.com>
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
x-ms-office365-filtering-correlation-id: fa21ff34-833b-474d-16de-08da1300495b
x-ms-traffictypediagnostic: BN9PR11MB5386:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BN9PR11MB53860B378767B56DED4B2C6990E19@BN9PR11MB5386.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 81KgcE4lARQofnJBw46DDcXi0ky5l/s2dAnGwqaSibMZ4RLpQRSztC7Ove5/CVzv13mDlaaR4QtPHN5AZVewpgm41biRft+fRS1IaJFaXUx2+apUx4ub5IHPBSDQI714Pf+7kT00ZS1mbTNIhy2w5jUN2VVP0zYG/+klNsQ4TWxlIre0X/nEV4CLTXwcOzBhw0FTDQKCsh0D5XWxltU5sSrPd3L14Goa2/v0NeBuHatkkdCD+ia+IRZ1fSIUIzcnN47ABauekpCH6OHhnXNv6Wci4tAyzg3zkdfoGOuhHNLvjjwyG1B05Lzh679pdrq3LNLB7k8P1tP/mCu/iUw8cHM+ZxH110gtI0eZVWVq7rW5tWsSooquh/FBO0Nt3A8Y1n61RE9x/T9Zp5cUbgvKC1e67IY8UDQIOye0YhzBr884LCMZ6z7O4ZF1bRd39dgWGwAocuqXiRgsnAWk/cixYCfsID6+Zzcwk9jNe+Ix0GCCDrhO+FF27w52A9+2GxhRKynF4gkxhdk8Gs0w0FDuAHDNjSBt6XC66qiDnMzoGqh/GszG5i8g3ZJjvoK+zIwRoX/ptklYcTM2fsu0YGvQgWUee8c62ZcVP0zQ3sRphMtzYRRojoisFvBoxfClg4iOYKc6qCBTBlcyebxrSozvGFJLvMx2GQcE9oZsshfYmTJodOJQbqeZIZ0o+zVcGRntV4flJCa+IKplML7tLVXUkA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5822.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(71200400001)(110136005)(107886003)(54906003)(122000001)(316002)(53546011)(186003)(26005)(55236004)(76116006)(6506007)(7696005)(38100700002)(86362001)(4326008)(8676002)(64756008)(66446008)(66476007)(66556008)(66946007)(2906002)(83380400001)(33656002)(82960400001)(55016003)(508600001)(5660300002)(52536014)(38070700005)(8936002)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?4jZYnyzrjjJKW0Eq+SPTHJHcLWAddSJ8IsOvsMDhf3fLvNoV2LT2rwqb8RJ+?=
 =?us-ascii?Q?ch7Ihfw0+hvOEVmwmuIrsE1db9N52jq6l/0naan51lg5M9hmDVTguNMBU0vd?=
 =?us-ascii?Q?oiSkzx7Fe4pGYcCcXTv+KEzsbyFNRHRRCDYvO+UMfjtIdW9KAcPrfEzJR7Ee?=
 =?us-ascii?Q?RW14Xzim7FSn0KWiUhRogrLloPCzySr1iNoyhVQPFeyy8RbxhPhjIn/i6Nu4?=
 =?us-ascii?Q?TDU+j2IgCgpjsFDakUITTdrZKR8ORZeXq3VLudvw8t2xkDz0aWoEJYL27UVL?=
 =?us-ascii?Q?J6TyjZhRBABs6CIf0POq8yaKarRcPRQJ2B0xmnaxw38HM3yw6gSRcedOCZnZ?=
 =?us-ascii?Q?Rwwax+xJTjkM3btgT/8UogupXG671hopkKDrLpEAA+QW7GeSRpqvtjeNttPR?=
 =?us-ascii?Q?kcdcw3G6SE3AH5b7M7YKlg+qM/Rd63eXIDpHS+xh698P5f1wtEBfOcb2cX3s?=
 =?us-ascii?Q?RbDn1ZbO4wlzgupcRdyDN5zniUDIMJyFRGFY0lYcs4ZyNwBBfQZ2zqXIpAT8?=
 =?us-ascii?Q?hRbKn9UkdYLdO2bq3+qJI2rEBxE4Gb3RAbgJC9TcNBNYZHWOMMjaa3nvIwuo?=
 =?us-ascii?Q?SXbEqQkP0Hr5L7nzttMAvkW7AsP0BxY/xq54kH0fKaAm2zDN6TWR+oMMjbaS?=
 =?us-ascii?Q?5O9wte4Q+xz8A0ODYXTeM1+aJhpyMZspjE6ekPtOiYwJYBnPMn1nHnEso9nE?=
 =?us-ascii?Q?Tpy3QCu5U5ELvxtX6B3jL2tarxV9/1wvtmj66LqKlWDwG7T3zlCN7/F/4ze5?=
 =?us-ascii?Q?L6HNczEVpnrlMP7S3r+ShfVzAoffPeCI05VjBqfImXZL8uCWZ/GAUtXV17WU?=
 =?us-ascii?Q?0++W6rphJbltBPExE331FdoIL1IkFwIKWQiyHlHJBBDSOvwO8woBme0h8toy?=
 =?us-ascii?Q?HsteHHF77xCoqQL20LM+BcBkQWQpAG86BRP78rzQSgxWnyL602ANB5CDtWbl?=
 =?us-ascii?Q?TE3f+3aVWBfACCLSz0Vq98Xg3IAf42UGNACcVWMg83tB/2Rk5R5NMPl9LUa2?=
 =?us-ascii?Q?RtNsYU0t3K5/ezdKq75kVMCYjQbl3H1yfjAThTRLu1zMuAYjg9Yv+eHaBve+?=
 =?us-ascii?Q?kxnwI0bpV8MMthlyUDvMhOF/1UEDDhPqgZ75CdAiu35XDoUvV6tpvfsYCybk?=
 =?us-ascii?Q?9HZu4YD5/xyTuS4F9R5xK2ynRSbRRX/Vev+TTJBzpnkpDZvQu31kJljuYfqc?=
 =?us-ascii?Q?O03SbQiVXHr87c80A3aJ6vHnCWzdHi/9G0LVQj3OPtJAeTp2TAEJkeiR1Apl?=
 =?us-ascii?Q?3/fj4a15HMniF47JL+laCk7Qq/HYZtcAkxoTVZ5YFZfKIQ32sfhwGmWWWUMO?=
 =?us-ascii?Q?9pioCdF/9UFvnQFf2Go4q5yXLlnwY0Fu22Z1gQdQT4YGcCKzws2a0n6uz4rb?=
 =?us-ascii?Q?FqqY4W6oYses9UgB8dt5jp+Z+405LFysBdWQMF48T3/s/cg8Lixz/2gVq0+6?=
 =?us-ascii?Q?WdrXU7QC069gPM2D9dVIH/ynL9+T3n/olPJUQGNAaZ0tymVuo9GhdV/D+Wsi?=
 =?us-ascii?Q?8b0szQ7Ah1y2BVuzOljEZ1WTfG929awk2vHA3GwNBn6y9vSvskzP5/q9k/YM?=
 =?us-ascii?Q?u/UNcXaTyXl6xpaQcaTPBGZzqxAHfAwMzFVW+6TzUghkaPR0RdjMQnwF17VS?=
 =?us-ascii?Q?7OAWURpiD01cdsH4HuGw8T53hG2co1Uf1K9CsBMv3UAGnjx+UfL70hkO9Gk9?=
 =?us-ascii?Q?qRc855rdmrpFgDaeu7rtXtnvKgpj8dxtipOquOCaAWyVMMUhMXnEOpC+apgB?=
 =?us-ascii?Q?gC4eiH8U6dTr4o8z2fKVFVVRyJ/VA8o=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5822.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa21ff34-833b-474d-16de-08da1300495b
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2022 10:21:57.7199
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1KREfvL7E7mRL3Gq/M3Mfiq9i9BYkTMqNmwhA8Rv4GEf8IGY4iZmZH6ZkmgK7LN8gUb9FlmXNuasq8fAecJzwbjYQ/hPWPBGv2k3Fh/ybls=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5386
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Maciej Fijalkowski
> Sent: Thursday, March 17, 2022 11:27 PM
> To: intel-wired-lan@lists.osuosl.org
> Cc: netdev@vger.kernel.org; kuba@kernel.org; bpf@vger.kernel.org;
> davem@davemloft.net; Karlsson, Magnus <magnus.karlsson@intel.com>
> Subject: [Intel-wired-lan] [PATCH intel-next] ice: xsk: check if Rx ring =
was
> filled up to the end
>=20
> __ice_alloc_rx_bufs_zc() checks if a number of the descriptors to be
> allocated would cause the ring wrap. In that case, driver will issue two =
calls to
> xsk_buff_alloc_batch() - one that will fill the ring up to the end and th=
e
> second one that will start with filling descriptors from the beginning of=
 the
> ring.
>=20
> ice_fill_rx_descs() is a wrapper for taking care of what
> xsk_buff_alloc_batch() gave back to the driver. It works in a best effort
> approach, so for example when driver asks for 64 buffers,
> ice_fill_rx_descs() could assign only 32. Such case needs to be checked w=
hen
> ring is being filled up to the end, because in that situation ntu might n=
ot
> reached the end of the ring.
>=20
> Fix the ring wrap by checking if nb_buffs_extra has the expected value.
> If not, bump ntu and go directly to tail update.
>=20
> Fixes: 3876ff525de7 ("ice: xsk: Handle SW XDP ring wrap and bump tail mor=
e
> often")
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_xsk.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>=20
Tested-by: Shwetha Nagaraju <Shwetha.nagaraju@intel.com>
