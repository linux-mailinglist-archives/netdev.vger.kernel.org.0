Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A61175EEC7E
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 05:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232519AbiI2Dk2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 23:40:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232494AbiI2Dk0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 23:40:26 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D1F6814FB
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 20:40:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664422823; x=1695958823;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5YAWmFsHr5f+2lHFxI405SXFJJLAi79ugReYA1b4SzQ=;
  b=Naal688e5mJ4tcN7Z1k6a7QWcsUnWHND/u1PMzlwQk0xp4KquJwL18Pb
   ClLbo4zwMwCoocfREr4DtgEqgat+cSg/HwzsXBRW1YGJd1Y35YSZa6+KA
   CBznSFXXH7TY47jWpgtt3bWPxbv6kzE2318LEJeyUIHhAhoHTgddTUwcJ
   1hxrHans1npIuaOnXhvz/KoOlgqnP2JJktOWqmqWyBqPRMPPw3F2Kanq5
   tKqdvG0+IMX/nZSHm0S9cwRYls0Zybe4qvK+lRwblwBbB8FPahA6BOFFK
   uzFJCQhZhHGeEd7R9W0L3pmDirUPcfmfv2LIhpp8WFkgXzzZTi+zeIdm4
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10484"; a="303269952"
X-IronPort-AV: E=Sophos;i="5.93,353,1654585200"; 
   d="scan'208";a="303269952"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2022 20:40:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10484"; a="950957917"
X-IronPort-AV: E=Sophos;i="5.93,354,1654585200"; 
   d="scan'208";a="950957917"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP; 28 Sep 2022 20:40:22 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 28 Sep 2022 20:40:21 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 28 Sep 2022 20:40:21 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 28 Sep 2022 20:40:21 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 28 Sep 2022 20:40:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aUZ6dDAoFo3zRu1cab5oSaycHaZ1L9Dxc/tDE/oEsU8ujjwj0VRYuYPzxWmfRATQZFBfFGPRCI3Kh+iDv+CXmeb5oaMNj2MNVlYDc4D277taRFbaTrZfSVFmH/Q7PEBFqmJNmN1+fVh8Tm5SW2DMP8S/N/bz+Sll+xVmDXDIQiUS5yUaYft1RFEg8qADZtliEVoFrHFwRlzvZInwp/d1GOr2tSHnzsmvpkJvT4uAzeSVxn/5N3/H45YiSC2dOpvcDlP2j/MrHixpoYiawrQzwbx1oj8j1Rm2wkMtGUZr8lXWYejHmhWwapaVvG/r0IjC2QhEut519lXhzq2FOluZLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ChyLLKwVtQ4sfXWVAwB8m+BsEA9K7+XKSnd82rBTnYw=;
 b=e0ajAyQRHwzvMdbcTcKAPr1huwLLmDvMSlUDDBqAqOyzX+nM0rS369ihenqNkwGGcOCJDHdDZT6yfYAcBr2Jhuv1lrPeAokUDWSUJkEr50kh768WEpZuVrl1IJ2qIWdtModEDHTZMDjVy0TzqIkXcZH99xwk2Gi2+OQu3DUwjKRHPLiV5Imm8/CE4FPZ7UtHCbk8KS2GG4qyMtZy6Jl7DX2aDZ1Rs42Vp8PZ4LNUKkMXDG88m0To4UiajNhvF4NWN4Cyz7InLKdXpgnV5geDvqD0vcTaVLn1+NkEQcij+HFxi+TMo0mVYZro0OSrNin7Iunh3v5biqq+Q77jDA7sgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6180.namprd11.prod.outlook.com (2603:10b6:a03:459::14)
 by SA1PR11MB7040.namprd11.prod.outlook.com (2603:10b6:806:2b7::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.24; Thu, 29 Sep
 2022 03:40:14 +0000
Received: from SJ1PR11MB6180.namprd11.prod.outlook.com
 ([fe80::7c03:1c40:3ea3:7b42]) by SJ1PR11MB6180.namprd11.prod.outlook.com
 ([fe80::7c03:1c40:3ea3:7b42%5]) with mapi id 15.20.5654.026; Thu, 29 Sep 2022
 03:40:14 +0000
From:   "Zulkifli, Muhammad Husaini" <muhammad.husaini.zulkifli@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "intel-wired-lan@osuosl.org" <intel-wired-lan@osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "Gunasekaran, Aravindhan" <aravindhan.gunasekaran@intel.com>,
        "Ahmad Tarmizi, Noor Azura" <noor.azura.ahmad.tarmizi@intel.com>
Subject: RE: [PATCH v1 1/4] ethtool: Add new hwtstamp flag
Thread-Topic: [PATCH v1 1/4] ethtool: Add new hwtstamp flag
Thread-Index: AQHY0nIwRurWk6W5b0qB8INzciakAa3z+NUAgAHMLCA=
Date:   Thu, 29 Sep 2022 03:40:13 +0000
Message-ID: <SJ1PR11MB6180E0A4856B4003DB546058B8579@SJ1PR11MB6180.namprd11.prod.outlook.com>
References: <20220927130656.32567-1-muhammad.husaini.zulkifli@intel.com>
        <20220927130656.32567-2-muhammad.husaini.zulkifli@intel.com>
 <20220927171132.2b3ca71a@kernel.org>
In-Reply-To: <20220927171132.2b3ca71a@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.500.17
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6180:EE_|SA1PR11MB7040:EE_
x-ms-office365-filtering-correlation-id: c28c7e51-5152-4737-da3b-08daa1cc5186
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ils21xVAKUZ/hTzMibnEdTYFGE1mvl7O52GaFLlv2CWl2EbuG3PgJv5wxHdZmIQW2lbu0LisdVjislZEB+Z3kkaIQU/Ui74b/bNxenH2BhDHnJS3DuPmNQr99gvEuB3tIWOovAbYFK56LfO7390g8gpTAvMabpH+VAjOV15MwPv12D0zq7eBaSKVOl7tCrMuEDq24EfC6xgpaQBFdCeRnvklQNV0VyXTjCcDJ9YlOb+SJFNSSwPpvPXPi0HHkqc058i/Db5HpyRiZnLi6Hj5n8Gidd/wIGSmhHS5RPpN+IczwHZDyrqtHek7hGJ1klhQ0Oyb3zSSXL1CHzWgINkQbZycB4iQ1u0dTfq5BzNabzHjsNljO5IHPUTahua1jF6EUKp7Qzp3tKGzD+tXNvch2jO/I/uLuuhgEPRLkTuMWFCo7OMisUgWE7MOI85yhrnPB8UTdFdoElKYhin3xAtNApdYy14OHMHAy6LvCGT5Gc9hyq/3+AeVp3ysn5s6To2cjVexnRcaq7haBXhePk3atQwFNL6xl/GGO9B9IH/DfgzmgXhBKR8XxPNHqlV52+YcEkbdHO8CkMslX2nerkN4Fgv9puC7zi5+OviqkqnFG5jEoflUOPWgmPHusohVrZXgQWpEj++3u+KjINaHNJpSLA5MlATal0XSc7Ju/D9nAMBMcsUnrotX6gI3NiNusuDSbt2jess0LbPWuMWHsqQVIlXIikZH69TLwTzy/ZV7jjHzQnxk8BzG4aU2PONRmAMR52yg3dXnyA1JL84fXVL2Fg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6180.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(136003)(39860400002)(376002)(366004)(451199015)(66946007)(86362001)(38100700002)(82960400001)(2906002)(107886003)(9686003)(7696005)(122000001)(71200400001)(478600001)(66446008)(55016003)(6916009)(38070700005)(52536014)(8936002)(26005)(54906003)(5660300002)(41300700001)(66476007)(64756008)(83380400001)(76116006)(33656002)(53546011)(6506007)(8676002)(66556008)(186003)(4326008)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?baV0fqS1bTEgCw04/gejU0XUaR/QXLcen7+ZSe6Ojlak+D12xuaMF5e8xzkD?=
 =?us-ascii?Q?tECtfOiTFL2WKlp6GVz54qK9WxB2wGdm09mR/uLrNaCG4L42SEkiBw2cboFM?=
 =?us-ascii?Q?wE2M/J76Cp2LckxTvRnqyEfjeu8xl5/8xHhpwEO8rYsvdk57uSfDj1O4pl6e?=
 =?us-ascii?Q?u6h1jBQnsuKWcq/xLnUFDOdolT8pSZf0hWM/gSkef5aOvUfI3hqM/BVEs7av?=
 =?us-ascii?Q?MDgcRoXlxq1qv7gvocQczmHs1src+mtBtDBoV1pHb7X4klHqNLGeLeo7Hj20?=
 =?us-ascii?Q?HYvAt9yI807lswUftf4Pfzaw4JVO6MHDfmnv7uZCvjptWGBvtx4N1X1Moimt?=
 =?us-ascii?Q?xRobjSIR6Fvh37CTlu350sa0CinQAsVFz0PnL8vBqpJ439Jrxqf+LUNCsF0o?=
 =?us-ascii?Q?q9gxiMVs5oKXdUv/ToLITHbuxOyLupZ/WWeLV4MjjPgPvh+nB5fg9lYAuxbq?=
 =?us-ascii?Q?ciYIVtirWAA7eiJB/wie1olTuaRC8SuypsYSolUl9BmoQGSRG9LYyfnyAQCg?=
 =?us-ascii?Q?Xxnex5XtCIZAes0QMYWp+/sUQ8I97qVF03rXCErWRqtfx2MOy7dnJJck6Xxp?=
 =?us-ascii?Q?a92mVrATHrVqnLtanMCWvRTaauduSG7cHZJ8X0i599T2nAhBSWDAWWesE+vA?=
 =?us-ascii?Q?BSn9HmbTnUnYuYKUC4iNOCp2jlaT4pghzrCSihcBkvnh5AtcbWdBSgWRv/+4?=
 =?us-ascii?Q?hHFa4AZJps2F/coxfXMcxf0vqgRfkwNgMZ/jjhiqzbuHyBzr4HzhjqV4M25n?=
 =?us-ascii?Q?s9yP28JL4Fsb4j7ujajKorUpd+lbxhnC1rGsMPBPIFVfUzz4DUzI1YOJ+dWt?=
 =?us-ascii?Q?Fd4QcWgEernrCJFWa7sryoGdBU5mpiasnZDo0zk7dkSCkLlHB1oxGIHKZlxa?=
 =?us-ascii?Q?eeAoJ1p3XCvF7iHt+tbYYRYp4lZctHqoFQm82i5x0V0tOtf1YBcjQeh8k9dm?=
 =?us-ascii?Q?3fCPrbFuULFhlyKfYh/NxH7QR18nKVdC+EjhH7rg2fJFiAD/VLsSSHBQwqEA?=
 =?us-ascii?Q?BCiMi5TeNteSpoy485iHRfXmGQRM2zj+99A95IU8IVYfhvNp6gatw7NtW0Cg?=
 =?us-ascii?Q?fxcb0nHWrNtIRJbkM5InZ0uO6yT2hJHGW1Qrd52I2pZaxfkMnU5BrCXT971c?=
 =?us-ascii?Q?eP2IUuNgEac5eqeRxV4EqKB2QEysqQN6k07fEEH/deBLcQkpjMx1C9UUCycB?=
 =?us-ascii?Q?r7+2KRjUYZkCcpa3NDVWWAmidMnA6ma8P1tZY/StFoFCGQt357dAVmp1kUss?=
 =?us-ascii?Q?UPKR5eKe6Wce8Na2qy3DkUuG1S1VpGVVVeC2zxqPzSTKH/1FzUkIv3+4CxaK?=
 =?us-ascii?Q?Njh4JtKDKAQnZj+dWZBHB7+rKb6K+zb8oyQhCt8yD+E5w8HWUwrWQIM2QeDP?=
 =?us-ascii?Q?34hHL3cfOUy2LBpbXwrbP/6TcN/c7HSxlaGN3GXZVE5EC+SZQgEFR2nYMgqK?=
 =?us-ascii?Q?fRi1I+ckmmBFiNyEm/6I982sL2+0nE15K6GLRBZ7QCqep60MyjzbsVhm7I7q?=
 =?us-ascii?Q?EgcFbJEs4MTwCOV5jyTN3PWfKkMuNzGkJxZaBBOhnwn4tEjUuwXDWzDMCvLI?=
 =?us-ascii?Q?r3GPJmB1bvTAIlRLX6oRoenxu/V+GSTKlpgOGPaiBdjoMx4Mf+PMS6eMTqOZ?=
 =?us-ascii?Q?GFWc0DXYNfmoKRAfGYCzbSg=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6180.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c28c7e51-5152-4737-da3b-08daa1cc5186
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Sep 2022 03:40:13.8914
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EsRaDWPT0sr+JSajsX22b4PHlVhWmr+pujcX6xWvnM2Ju4oipEvlmb+/9IeEk7OiXkr3oBudHzcvbJTpd+0eCthDnKfgMXFmr7wj2tKGtvQVIT3RoP9/cvR7wmJdDKOG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB7040
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Wednesday, 28 September, 2022 8:12 AM
> To: Zulkifli, Muhammad Husaini <muhammad.husaini.zulkifli@intel.com>
> Cc: intel-wired-lan@osuosl.org; netdev@vger.kernel.org;
> davem@davemloft.net; edumazet@google.com; Gomes, Vinicius
> <vinicius.gomes@intel.com>; Gunasekaran, Aravindhan
> <aravindhan.gunasekaran@intel.com>; Ahmad Tarmizi, Noor Azura
> <noor.azura.ahmad.tarmizi@intel.com>
> Subject: Re: [PATCH v1 1/4] ethtool: Add new hwtstamp flag
>=20
> On Tue, 27 Sep 2022 21:06:53 +0800 Muhammad Husaini Zulkifli wrote:
> > --- a/include/uapi/linux/ethtool.h
> > +++ b/include/uapi/linux/ethtool.h
> > @@ -675,6 +675,7 @@ enum ethtool_link_ext_substate_module {
> >   * @ETH_SS_MSG_CLASSES: debug message class names
> >   * @ETH_SS_WOL_MODES: wake-on-lan modes
> >   * @ETH_SS_SOF_TIMESTAMPING: SOF_TIMESTAMPING_* flags
> > + * @ETH_SS_HWTSTAMP_FLAG: timestamping flags
> >   * @ETH_SS_TS_TX_TYPES: timestamping Tx types
> >   * @ETH_SS_TS_RX_FILTERS: timestamping Rx filters
> >   * @ETH_SS_UDP_TUNNEL_TYPES: UDP tunnel types @@ -700,6 +701,7
> @@
> > enum ethtool_stringset {
> >  	ETH_SS_MSG_CLASSES,
> >  	ETH_SS_WOL_MODES,
> >  	ETH_SS_SOF_TIMESTAMPING,
> > +	ETH_SS_HWTSTAMP_FLAG,
> >  	ETH_SS_TS_TX_TYPES,
> >  	ETH_SS_TS_RX_FILTERS,
> >  	ETH_SS_UDP_TUNNEL_TYPES,
> > @@ -1367,6 +1369,7 @@ struct ethtool_ts_info {
> >  	__u32	cmd;
> >  	__u32	so_timestamping;
> >  	__s32	phc_index;
> > +	__u32	flag;
> >  	__u32	tx_types;
> >  	__u32	tx_reserved[3];
> >  	__u32	rx_filters;
> > diff --git a/include/uapi/linux/ethtool_netlink.h
> > b/include/uapi/linux/ethtool_netlink.h
> > index 408a664fad59..58d073b5a6d2 100644
> > --- a/include/uapi/linux/ethtool_netlink.h
> > +++ b/include/uapi/linux/ethtool_netlink.h
> > @@ -452,6 +452,7 @@ enum {
> >  	ETHTOOL_A_TSINFO_UNSPEC,
> >  	ETHTOOL_A_TSINFO_HEADER,			/* nest -
> _A_HEADER_* */
> >  	ETHTOOL_A_TSINFO_TIMESTAMPING,			/* bitset */
> > +	ETHTOOL_A_TSINFO_FLAG,				/* bitset */
> >  	ETHTOOL_A_TSINFO_TX_TYPES,			/* bitset */
> >  	ETHTOOL_A_TSINFO_RX_FILTERS,			/* bitset */
> >  	ETHTOOL_A_TSINFO_PHC_INDEX,			/* u32 */
>=20
> You can't add stuff into the middle of an enum or a struct in uAPI.
> What's worse for the struct ethtool_ts_info you can't actually add anythi=
ng
> in, period. You can reuse reserved fields but even that requires extra
> legwork. If the fields were not previously validated on input to the kern=
el (ie.
> kernel didn't check they are zero) the ioctl path can't use them, because
> some application may had been passing in garbage.

Noted. Will make the changes in V2 to move to the end.

Thanks!=20
