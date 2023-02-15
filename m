Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C5A2697577
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 05:38:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232714AbjBOEiD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 23:38:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbjBOEiB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 23:38:01 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D5364C27;
        Tue, 14 Feb 2023 20:37:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676435873; x=1707971873;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=pMjZB9bxX8ZZUzH+uEhA9+3SxGuP4o+Uu0xOjXM7ji0=;
  b=W9hDZjlGA+t+uyJ/AEtBdtX6AUUzCnSB71EGZZNjfWeu2/l2n1YfCqg4
   iJCzrDJLzfhEu/1h8SctSmzMtJAHpe/zG6ov72ClghL2AuNQt/a7vG6Lv
   Wjw6/wDgWkQ4EV6veT9nqJaK3qI1KsVsBO2DOw0f/4JGFAqJ0DfKfltt/
   nqEBBZHfSyL7ZUVeej3eNQJ7YLG/t7EMLYYjvL41ZNJpvLP1VmUQ5ACZ+
   sVZHZ9sqj0mCTlj8I5J4lCR0YL+kvoL1ydYi2PNpKsshIyB30rvdKF4Z1
   X1BS8TzwQ5B9qKVSf7Gh/QBwUUYacYHO2XBIefpTXu4peT4+v9bHB+7yH
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="310974248"
X-IronPort-AV: E=Sophos;i="5.97,298,1669104000"; 
   d="scan'208";a="310974248"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 20:37:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="662795444"
X-IronPort-AV: E=Sophos;i="5.97,298,1669104000"; 
   d="scan'208";a="662795444"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga007.jf.intel.com with ESMTP; 14 Feb 2023 20:37:49 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 20:37:49 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 14 Feb 2023 20:37:49 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.48) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 14 Feb 2023 20:37:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OGlMlFYGO9W+QjvxPizAUUgE6XNIoH0xP3bNLEbrN/sHS38Y9M23Mc85MGycPYaUxCFnwJ4zaq8HpSOEygxb7gv9joTrht1qH+Tz8WiK+Cfqx0Kqg7Vo3h/JPHF9KKa0zagBFpkIvfgY6UecUciYjnMhOh2xpZjJlZUjSa5FFubjRACSSyHayTTNsej2OTdUUYpu678f3VjfnHguuU7AtWdLtnsUFtb0bxvYhl7sB06zxIjD99f13w9FIhJK0Zgq4vg1QlMcC3WC0RUKm60+Go2gKLgd9LJXRa9CBHSIGxNUB/oR7zQ1y/F1K7Z5uweqWbyxAQbQi/loAZDlcpKH6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fueHtQzM1RD7+PGsi8PELFA3IrIBQzB+phZOztcBtGc=;
 b=g1GaUIl2lBINWEbboxy8UPrn+AuSBglBGFrYOrpOft/1LCgBM13Quqp5TiT7zHTdzjPRPPw8zqV4GgS+q75G+fbQ2LW0lbl2/BIi3Ec8eHpRX11Ckc33CN0fv5e9pbd6tzseBdYMFkPa/g+xajjvfn6tiVicm8FZ54xTUvMM2Lm3NqCFW9s7EIpgdm7uSEEEv2wdmwkboLOM6EkgtB8UcAzt4cACSDZN23L0O+6lIvxxvlyIEcuP8K9s8U+K5FHrX7IvLRINr5SjeFOm/l3ot5gjbiseDZX2htzKVBbUZjg7zd7G1OSbaPvAa1YOvuc/bJzAWMT7xOQh/6vvLYEVGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CY4PR1101MB2360.namprd11.prod.outlook.com (2603:10b6:903:b9::9)
 by MW4PR11MB7008.namprd11.prod.outlook.com (2603:10b6:303:227::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Wed, 15 Feb
 2023 04:37:47 +0000
Received: from CY4PR1101MB2360.namprd11.prod.outlook.com
 ([fe80::ca4b:b3ce:b8a0:f0da]) by CY4PR1101MB2360.namprd11.prod.outlook.com
 ([fe80::ca4b:b3ce:b8a0:f0da%11]) with mapi id 15.20.6086.026; Wed, 15 Feb
 2023 04:37:47 +0000
From:   "Sarkar, Tirthendu" <tirthendu.sarkar@intel.com>
To:     "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>
CC:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Subject: RE: [PATCH intel-next v3 8/8] i40e: add support for XDP multi-buffer
 Rx
Thread-Topic: [PATCH intel-next v3 8/8] i40e: add support for XDP multi-buffer
 Rx
Thread-Index: AQHZQHImdH8aDiB8C0qjnCvdyK/ZYK7OqxGAgADAfzA=
Date:   Wed, 15 Feb 2023 04:37:47 +0000
Message-ID: <CY4PR1101MB2360B76C18FDEECAFE3169EE90A39@CY4PR1101MB2360.namprd11.prod.outlook.com>
References: <20230214123018.54386-1-tirthendu.sarkar@intel.com>
 <20230214123018.54386-9-tirthendu.sarkar@intel.com> <Y+u+aUJJ2EQYEdJB@boxer>
In-Reply-To: <Y+u+aUJJ2EQYEdJB@boxer>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CY4PR1101MB2360:EE_|MW4PR11MB7008:EE_
x-ms-office365-filtering-correlation-id: 11033951-9887-4d43-24cb-08db0f0e6370
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IeqYSdxG/Xfn4WBZ5kJvNlFRLL6NTpQFNOMuTS4yECKPTSJYXXAsQfggtz2wLf8XGkUmxzQ1ALXGABjfnZzUHZSO0ZaeYGAs4iH/52QHv6Wta1/lLGS9iO+R2MhbAKnXbL2Y5Bq8+CFxhjF8my/xL9QDihcbtm6vnQYNT8gZRwXbfUxW3yXpFspO7qA+/BV7z1mFckD7vXkYvMsDv4dRZAxeveAybPuwXztDiNwBZk9JXcqqERiNTWDNGhHJ+MkpkwSA66h8w6556Uab/+eoKmIB1w4K6169zfk1yEmoRfBmeKxA85S2rLn45sAG6n5YzllhGf+0d0yZcjVtwXIUOFmEF/Uj+v0pAcra3tMgAmneApYJa8PkI5dyfxYAWGu/PMKgtaAkPuFdrTS7zAuT74cpQm1Jc0vpwDcU7UVFMwN8UxEwoE88W91V5o4JFeznZKotS6vWHLcuAgVU6XZIQwBM0TAsKgmEeSCDKgFw7odVApvPFRh5CkrB7TBMn10MIK+0nLeIt4Zz5r0cdxvrQjz/OCb9GM4REZAShp932L5oDDpUZqiayd0W2bQ6CAIWAJN4cRgc8ybD3G2bbT17syiL5rNEczQqJpNw/hN2bvo8Vdn1IBZPDR4F15Iwy8BiUIJKLLiAmMCvpXuZrNn2AK3SBN3iQo9dwMAfOkBa3Gx8axY/K6XCCo0QpE5Az+apXd7H4p3RFlpKoViY+ZWWcPp2ahTZnWVnhH74aggMBb8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1101MB2360.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(136003)(366004)(376002)(396003)(346002)(451199018)(82960400001)(66946007)(38100700002)(76116006)(5660300002)(66476007)(4326008)(33656002)(107886003)(6862004)(38070700005)(7696005)(55016003)(41300700001)(71200400001)(66556008)(8936002)(8676002)(64756008)(478600001)(2906002)(6636002)(54906003)(66446008)(316002)(83380400001)(26005)(186003)(9686003)(52536014)(86362001)(122000001)(6506007)(83323001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ZGuvk7RMa4BztddTw9yIyT3EJoLfrRauujGtS5BKSubcMabTJkh9pGYeuEpS?=
 =?us-ascii?Q?pNy8CN1dfe4G1gYe3zIX6fD+YjOLt6OXG1UwsA1Tc6jMgyEO48f3INJMTv0E?=
 =?us-ascii?Q?S0ZBVvgQq5Lvzw+7gKdL/LXlNcKURXn1iTs5MnotwDqUDUAz24Nw9oHzLvBH?=
 =?us-ascii?Q?4MuNg+WIITu4N1pCdpyFt88QyMyUMiryworCF0ap4/pz075jfhD44p5nTty0?=
 =?us-ascii?Q?pklZgTow2j/fsADve1MmWD/JKDu1+GrpRlqwECWZJBEFick57/4Q9VowLoh9?=
 =?us-ascii?Q?NRoC5i9Uplr+7oCAobXTiUFVfPx+XWXifN+lSRIUb+DPdAsfmWA8amIdhZ+j?=
 =?us-ascii?Q?ipazqYbxK33Fu1e7nOLYZY6kKSWHZ8PDBEmpJGkbsQsGqxRXEA+Y4XJ6mQwT?=
 =?us-ascii?Q?rb1FfjTo8J+rNMQdjVOlAdx8P+6auRLHmmm6feP1+8ejFGNyJOAGnGyb9rFe?=
 =?us-ascii?Q?e1Gdq64H6+bbZR2g7BHlstXrqRgM+ZRtmz+WK9iv5G4fasK5sHFZHL3DEKsv?=
 =?us-ascii?Q?yIucAvUTdNEPhGUP5RE+iUh9Thn7yUb5Yzo/YBM2MuYWbNxnvebVEYKMeEue?=
 =?us-ascii?Q?xnOqNwwIM1o2B7m8SmT/L/RRpzU1fzdQ/+dXcNXupeRcj9XK9THi+omoAkLW?=
 =?us-ascii?Q?avh/uDGTA/+BR2V+aAPazY2PLe66CAUiWaGb9tyF858v25OToTEQQ3i9+M2I?=
 =?us-ascii?Q?TqGRvoCe8e0oQtHBBADgbpPiHaPCHn9ZzsgD9POn9wqx2aznmv2B2wePReEj?=
 =?us-ascii?Q?Bh/lhCxQDr5TPSlk5gfn7rf1ILzdPgcBNGLd6CGQEmHpp100kuuf8hiDfVv3?=
 =?us-ascii?Q?QJN/CcZyVJsvQnDjw9AUgk4E+bUNckW1d7hkEzwMWy8HL/93tLTpy7jYtE0Y?=
 =?us-ascii?Q?JqgGBMoqz1StIl3CqApdGXHJw/xKjVnX61Znu8Lfz/X+ALcPfyTCh0CaReh9?=
 =?us-ascii?Q?Tt57AseYbPYal5WulOEbd+mBZWaa3ubAXkO+rwxDsnm2Um09lzVvHu/M//nP?=
 =?us-ascii?Q?WmizMXczDo+ravmCPi1VtrSUArc611BCPzCh51GyJeaRzm/JLiTu8ipaZ6pa?=
 =?us-ascii?Q?AKSt+xKD1G0dY/hFC9nGaPgoOF6Y/pgPMF9o6YQHhoEtF0LEYdl15COTXAJ5?=
 =?us-ascii?Q?aWuP8IqnyuqlNd1mQQ3+dotRNoJKNzo5+YQZWLJsnoAPiotN0h18QcZYBp0c?=
 =?us-ascii?Q?6P76w/AMBGtKyuLF9j7CGXXLVml/dBZEr8U5nhkC/apTQpzcb6vvmZf2s74L?=
 =?us-ascii?Q?as+1JFBi+yXJhJULeuzyfZkwTVq/AZy3YEZOToxSADqxp8J3NUBwWi0unt5R?=
 =?us-ascii?Q?9S7s4/xofKlb9vNORWzOqWScF3x+TpcaNGlSdRjpEh8mDjHDBQSsNJYlWXPh?=
 =?us-ascii?Q?wuen9q8SEhbiTeafjdjEtQ7X/YfznHzdKCg6rPZ6c0bdUj2AmCQd34Gsir9b?=
 =?us-ascii?Q?dEAi/eSqr+emZkpOw3dUQZs6PJxAC2TVoqkxeVVimK7Yjj3tLJaRZx2qxz/b?=
 =?us-ascii?Q?hDiLCgWcR+kDM7wzpWXabNljpU477YReLceskUqxx6gCssrAEYaUq4fdB/Ga?=
 =?us-ascii?Q?Wt/n76CtWScf+45646W9nOsiQve0umbTSR2/yAIP+Gdq0qsPyx0w9sTM1Bd2?=
 =?us-ascii?Q?5g=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1101MB2360.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11033951-9887-4d43-24cb-08db0f0e6370
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Feb 2023 04:37:47.5153
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qTiiHKapuG1BwdEgotNYl3XkVXMlxRJyEvXiV5YcuegJwjwdZcQdi3w0Iwds/h78fN/wSKScumN/T4bMni/b03gFT6Bg955GI3cNxqT0ZfA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7008
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Fijalkowski, Maciej <maciej.fijalkowski@intel.com>

[...]
> > Previously i40e_alloc_rx_buffers() was called for every 32 cleaned
> > buffers. For multi-buffers this may not be optimal as there may be more
> > cleaned buffers in each i40e_clean_rx_irq() call. So this is now called
> > when at least half of the ring size has been cleaned.
>=20
> Please align this patch with xdp_features update
>

ACK
=20
> >
> > Signed-off-by: Tirthendu Sarkar <tirthendu.sarkar@intel.com>
> > ---
> >  drivers/net/ethernet/intel/i40e/i40e_main.c |   4 +-
> >  drivers/net/ethernet/intel/i40e/i40e_txrx.c | 314 +++++++++++++-------
> >  drivers/net/ethernet/intel/i40e/i40e_txrx.h |   8 -
> >  3 files changed, 209 insertions(+), 117 deletions(-)
> >
>=20
> (...)
>=20
> >  }
> >
> > +/**
> > + * i40e_add_xdp_frag: Add a frag to xdp_buff
> > + * @xdp: xdp_buff pointing to the data
> > + * @nr_frags: return number of buffers for the packet
> > + * @rx_buffer: rx_buffer holding data of the current frag
> > + * @size: size of data of current frag
> > + */
> > +static int i40e_add_xdp_frag(struct xdp_buff *xdp, u32 *nr_frags,
> > +			     struct i40e_rx_buffer *rx_buffer, u32 size)
> > +{
> > +	struct skb_shared_info *sinfo =3D
> xdp_get_shared_info_from_buff(xdp);
> > +
> > +	if (!xdp_buff_has_frags(xdp)) {
> > +		sinfo->nr_frags =3D 0;
> > +		sinfo->xdp_frags_size =3D 0;
> > +		xdp_buff_set_frags_flag(xdp);
> > +	} else if (unlikely(sinfo->nr_frags >=3D MAX_SKB_FRAGS)) {
> > +		/* Overflowing packet: All frags need to be dropped */
> > +		return  -ENOMEM;
>=20
> nit: double space
>=20

ACK

[...]
> > +		xdp_res =3D i40e_run_xdp(rx_ring, xdp, xdp_prog);
> > +
> >  		if (xdp_res) {
> > -			if (xdp_res & (I40E_XDP_TX | I40E_XDP_REDIR)) {
> > -				xdp_xmit |=3D xdp_res;
> > +			xdp_xmit |=3D xdp_res & (I40E_XDP_TX |
> I40E_XDP_REDIR);
>=20
> what was wrong with having above included in the
>=20
> 	} else if (xdp_res & (I40E_XDP_TX | I40E_XDP_REDIR)) {
>=20
> branch?
>=20

For multi-buffer packets, only the first 'if' branch will be executed. We n=
eed to set
xdp_xmit for both single and multi-buffer packets.

[...]
> > diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.h
> b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
> > index e86abc25bb5e..14ad074639ab 100644
> > --- a/drivers/net/ethernet/intel/i40e/i40e_txrx.h
> > +++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
> > @@ -393,14 +393,6 @@ struct i40e_ring {
> >
> >  	struct rcu_head rcu;		/* to avoid race on free */
> >  	u16 next_to_alloc;
> > -	struct sk_buff *skb;		/* When i40e_clean_rx_ring_irq()
> must
> > -					 * return before it sees the EOP for
> > -					 * the current packet, we save that
> skb
> > -					 * here and resume receiving this
> > -					 * packet the next time
> > -					 * i40e_clean_rx_ring_irq() is called
> > -					 * for this ring.
> > -					 */
>=20
> this comment was valuable to me back when i was getting started with i40e=
,
> so maybe we could have something equivalent around xdp_buff now?
>=20

We have a similar comment for xdp_buff in patch #7 where it was introduced.

> >
> >  	struct i40e_channel *ch;
> >  	u16 rx_offset;
> > --
> > 2.34.1
> >
