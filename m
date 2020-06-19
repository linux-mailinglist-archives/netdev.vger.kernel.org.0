Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27EDC1FFF55
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 02:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729211AbgFSAg0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 20:36:26 -0400
Received: from mga03.intel.com ([134.134.136.65]:56645 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728627AbgFSAgZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 20:36:25 -0400
IronPort-SDR: T7PjnCbbMVDQYXoMq5WZJkskNa2qJcpfhsY4ZgIsbupxo5DT+VOuIsv1ADZgJ/0Yra3O/QyWHk
 L2QkOGBDSusg==
X-IronPort-AV: E=McAfee;i="6000,8403,9656"; a="142713500"
X-IronPort-AV: E=Sophos;i="5.75,253,1589266800"; 
   d="scan'208";a="142713500"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2020 17:36:24 -0700
IronPort-SDR: RlpGUU2NyQRgWIzz4Ua1P4iJCDcC34L+OIhKl/+WHuN6kRQvnSZ3caoucWebw6LMYnTxEGeLIQ
 a09Il0o0awdA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,253,1589266800"; 
   d="scan'208";a="262166448"
Received: from orsmsx101.amr.corp.intel.com ([10.22.225.128])
  by fmsmga007.fm.intel.com with ESMTP; 18 Jun 2020 17:36:23 -0700
Received: from orsmsx154.amr.corp.intel.com (10.22.226.12) by
 ORSMSX101.amr.corp.intel.com (10.22.225.128) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 18 Jun 2020 17:36:23 -0700
Received: from ORSEDG002.ED.cps.intel.com (10.7.248.5) by
 ORSMSX154.amr.corp.intel.com (10.22.226.12) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 18 Jun 2020 17:36:23 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.103)
 by edgegateway.intel.com (134.134.137.101) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 18 Jun 2020 17:36:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZsSNFCIH5AkXmUZakMbCcIIrdj/vHkrjvTXK0dL811Jll7Kc0eDC/V5MMsQkkwKh4r1Nij5gFS5IQ+0+HX6DARVw2ytIsZLTYmfoa3OfzUJCVwkx2sm33I+pFDTVd+XpIgyBXnv++sNHy5v4RcBCU2yhjQp9BZt4/eafprlUzOjnxH2ab3BxIuUKf9n2Wnm310gYk+Ws6Roov9lcplTcD99ffIIEcdeV2lvPRXI0YY//IdEERyl4YzO/ydZFbPzaZD9nW5PnCjt5mDnLmzY/FraboZtIIpIJ4a0txiPoMzZ+3QBC+Go9YJgvlyAOE4z6htSA70yri2cRbAWQfGCRgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T6zHuO/E+cHHJeYadzciVVt1ME6iRxD562diBhiIX6A=;
 b=d28FIXM6MonJxo8Og09pR5iFPOgWliDmONo+GUFf5vfGhFcJD/xIrfSqgCBqA1WGIZSbQkRP1udgKwiY1YGFvf5OTjrHiGBNcvIV2ehonOL1Eiw++i+wIAX7ACvQeAIx/loA56XAMitkojpSbPRfGpwbIL/NJhl1B6UM2Ikpm9EuNmDD645skJ066iqs6pI98HoaXCA6N1a4oqU8xfL5Gsa5q4QmEzzcwCtHcAw4sgGytnkBDBYsAV+CctlWl7qxJsVm4OrLo7GlbV8hxm9eWDrR/sNj4UhEQKYltsfwNcIHjcesg/C2TaeH5zpLrIxGmdd6sthTxCUY/cmnAIOmMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T6zHuO/E+cHHJeYadzciVVt1ME6iRxD562diBhiIX6A=;
 b=iMrc5AcZdB6USBbc+jGHFxH7G5opFDuXNmrkqHQbj8zVw2BKFhf6t9pU6AKXXhkNpZOSE43sXKsKl+4QUrZB0TxxYKyfYsOa3TiMp67MOrlkY8Y3lvm1JCXavlsw9V4Wp4RuhHGLM4+5c82532Ru07grPoNwRPWPVYHbhDXXvwg=
Received: from MW3PR11MB4522.namprd11.prod.outlook.com (2603:10b6:303:2d::8)
 by MW3PR11MB4667.namprd11.prod.outlook.com (2603:10b6:303:53::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Fri, 19 Jun
 2020 00:36:21 +0000
Received: from MW3PR11MB4522.namprd11.prod.outlook.com
 ([fe80::4021:b214:94b3:3c50]) by MW3PR11MB4522.namprd11.prod.outlook.com
 ([fe80::4021:b214:94b3:3c50%7]) with mapi id 15.20.3109.021; Fri, 19 Jun 2020
 00:36:21 +0000
From:   "Brady, Alan" <alan.brady@intel.com>
To:     Michal Kubecek <mkubecek@suse.cz>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Michael, Alice" <alice.michael@intel.com>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Burra, Phani R" <phani.r.burra@intel.com>,
        "Hay, Joshua A" <joshua.a.hay@intel.com>,
        "Chittim, Madhu" <madhu.chittim@intel.com>,
        "Linga, Pavan Kumar" <pavan.kumar.linga@intel.com>,
        "Skidmore, Donald C" <donald.c.skidmore@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Subject: RE: [net-next 13/15] iecm: Add ethtool
Thread-Topic: [net-next 13/15] iecm: Add ethtool
Thread-Index: AQHWRS9L4yFt912xxEGh5OQAtUlWrKje4VwAgAA0hBA=
Date:   Fri, 19 Jun 2020 00:36:21 +0000
Message-ID: <MW3PR11MB4522EDBA35498230F418F96F8F980@MW3PR11MB4522.namprd11.prod.outlook.com>
References: <20200618051344.516587-1-jeffrey.t.kirsher@intel.com>
 <20200618051344.516587-14-jeffrey.t.kirsher@intel.com>
 <20200618211726.ijsafmx52ha3lamz@lion.mk-sys.cz>
In-Reply-To: <20200618211726.ijsafmx52ha3lamz@lion.mk-sys.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.2.0.6
authentication-results: suse.cz; dkim=none (message not signed)
 header.d=none;suse.cz; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.55.52.212]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 77c2d54e-dfa2-40dc-fbcd-08d813e8ca40
x-ms-traffictypediagnostic: MW3PR11MB4667:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR11MB46679FD482D639B74946546D8F980@MW3PR11MB4667.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0439571D1D
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rkJlvM9oP6V53Ub8wSWVYAyawiCn1Eibhx/TBeNMRees4NXWr+wD/q4/HOcfb5c7CHgXZMfGTBxk8bJOFkIY32m6kb3qubzxM72LkRGK2n4RGO22YA1y4jHaJT+p/1HW0/Op5VrtItwNHM4dEV9m09sDKRb3doiM5wjpyJbLzGiCOQbSspYhn8DZih3C5aoULyKlHl3dYrKCPMBj2Lo+H2wybw/eAQSmP/Vy1Xhww7FzQC2aE5in2sQSuRavHOf5RsTd+0Fv4aW9ZYIFuLKWidKJ+WI/NQjhjzPgaCVImIrfnQzI/rx7wV9ksz2VhV2d
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(366004)(396003)(346002)(136003)(376002)(8676002)(7696005)(33656002)(52536014)(9686003)(8936002)(71200400001)(107886003)(55016002)(4326008)(6506007)(5660300002)(53546011)(83380400001)(478600001)(66556008)(64756008)(316002)(66476007)(66446008)(2906002)(86362001)(186003)(76116006)(110136005)(26005)(66946007)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 3DEJH2ZQbqtNBjlH292ZnkGEjraSxeoto6qmU5sJ0lbjIKmfdBw+Og5SW/5/tnu7fJsnsoaYkAgez7IJ5osv8ytngXTLk9wWOb+gCxe0xWl9syeo12JdGF1Eb1qBebh2NS0RiSwTjFnl6R5aWaKNEO3XsYcRIoTX1TAUbGn7TA0ZWkxFlcUxVJ6igNA1MWP9DIWxmRZsI6Sod5msZOA/p0A3whrwPEVyf36w0FwK1JJJysJWTadIoRychSW/YPpy5DLEN8aTeoWDjHO2q78//4NhlgXPLZczhPrUZzmkFRGv62Ti+8euoKbbnhF4YTMgCjMYBhsupwciVDcUUM578v4GkbV2jy91mYu0aLfk2Dqq6pGBaF5LYRdbtkKSyiHQByEkUe/dirquKELWjRP5YkJLNOyV8+uFfl6ZSu3kBCYRgLXj5Tx2imnYMIUnw5hIh9teDrzf6a+gvOIO0lrxEQqBFWKqpxDQZkhFNsrDPFo=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 77c2d54e-dfa2-40dc-fbcd-08d813e8ca40
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2020 00:36:21.7938
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kOXMBVisG3Y+yKtCLHKVoPP6jrJkec5NRr/scHv9qDsh5qqRl2JZ4II9I6ozaZ0PmDLFRl4LOSduRtzYQK7oHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4667
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Michal Kubecek <mkubecek@suse.cz>
> Sent: Thursday, June 18, 2020 2:17 PM
> To: netdev@vger.kernel.org
> Cc: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>; davem@davemloft.net=
;
> Michael, Alice <alice.michael@intel.com>; nhorman@redhat.com;
> sassmann@redhat.com; Brady, Alan <alan.brady@intel.com>; Burra, Phani R
> <phani.r.burra@intel.com>; Hay, Joshua A <joshua.a.hay@intel.com>; Chitti=
m,
> Madhu <madhu.chittim@intel.com>; Linga, Pavan Kumar
> <pavan.kumar.linga@intel.com>; Skidmore, Donald C
> <donald.c.skidmore@intel.com>; Brandeburg, Jesse
> <jesse.brandeburg@intel.com>; Samudrala, Sridhar
> <sridhar.samudrala@intel.com>
> Subject: Re: [net-next 13/15] iecm: Add ethtool
>=20
> On Wed, Jun 17, 2020 at 10:13:42PM -0700, Jeff Kirsher wrote:
> > From: Alice Michael <alice.michael@intel.com>
> >
> > Implement ethtool interface for the common module.
> >
> > Signed-off-by: Alice Michael <alice.michael@intel.com>
> > Signed-off-by: Alan Brady <alan.brady@intel.com>
> > Signed-off-by: Phani Burra <phani.r.burra@intel.com>
> > Signed-off-by: Joshua Hay <joshua.a.hay@intel.com>
> > Signed-off-by: Madhu Chittim <madhu.chittim@intel.com>
> > Signed-off-by: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
> > Reviewed-by: Donald Skidmore <donald.c.skidmore@intel.com>
> > Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> > Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
> > Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> > ---
> [...]
> > +static int iecm_set_channels(struct net_device *netdev,
> > +			     struct ethtool_channels *ch)
> > +{
> > +	struct iecm_vport *vport =3D iecm_netdev_to_vport(netdev);
> > +	int num_req_q =3D ch->combined_count;
> > +
> > +	if (num_req_q =3D=3D max(vport->num_txq, vport->num_rxq))
> > +		return 0;
> > +
> > +	/* All of these should have already been checked by ethtool before th=
is
> > +	 * even gets to us, but just to be sure.
> > +	 */
> > +	if (num_req_q <=3D 0 || num_req_q > IECM_MAX_Q)
> > +		return -EINVAL;
> > +
> > +	if (ch->rx_count || ch->tx_count || ch->other_count !=3D
> IECM_MAX_NONQ)
> > +		return -EINVAL;
>=20
> I don't see much sense in duplicating the checks. Having the checks in co=
mmon
> code allows us to simplify driver callbacks.
>=20

You're right it's better to remove these.  Will fix.

> > +	vport->adapter->config_data.num_req_qs =3D num_req_q;
> > +
> > +	return iecm_initiate_soft_reset(vport, __IECM_SR_Q_CHANGE); }
> [...]
> > +static int iecm_set_ringparam(struct net_device *netdev,
> > +			      struct ethtool_ringparam *ring) {
> > +	struct iecm_vport *vport =3D iecm_netdev_to_vport(netdev);
> > +	u32 new_rx_count, new_tx_count;
> > +
> > +	if (ring->rx_mini_pending || ring->rx_jumbo_pending)
> > +		return -EINVAL;
> > +
> > +	new_tx_count =3D clamp_t(u32, ring->tx_pending,
> > +			       IECM_MIN_TXQ_DESC,
> > +			       IECM_MAX_TXQ_DESC);
> > +	new_tx_count =3D ALIGN(new_tx_count, IECM_REQ_DESC_MULTIPLE);
> > +
> > +	new_rx_count =3D clamp_t(u32, ring->rx_pending,
> > +			       IECM_MIN_RXQ_DESC,
> > +			       IECM_MAX_RXQ_DESC);
> > +	new_rx_count =3D ALIGN(new_rx_count, IECM_REQ_DESC_MULTIPLE);
>=20
> Same here. This is actually a bit misleading as it seems that count excee=
ding
> maximum would be silently clamped to it but such value would be rejected =
by
> common code.
>=20

Also agreed, will fix in next version.

> > +	/* if nothing to do return success */
> > +	if (new_tx_count =3D=3D vport->txq_desc_count &&
> > +	    new_rx_count =3D=3D vport->rxq_desc_count)
> > +		return 0;
> > +
> > +	vport->adapter->config_data.num_req_txq_desc =3D new_tx_count;
> > +	vport->adapter->config_data.num_req_rxq_desc =3D new_rx_count;
> > +
> > +	return iecm_initiate_soft_reset(vport, __IECM_SR_Q_DESC_CHANGE); }
> [...]
> > +/* For now we have one and only one private flag and it is only
> > +defined
> > + * when we have support for the SKIP_CPU_SYNC DMA attribute.  Instead
> > + * of leaving all this code sitting around empty we will strip it
> > +unless
> > + * our one private flag is actually available.
> > + */
>=20
> The code below will always return 1 for ETH_SS_PRIV_FLAGS in
> iecm_get_sset_count() and an array of one string in iecm_get_strings().
> This would e.g. result in "ethtool -i" saying "supports-priv-flags: yes"
> but then "ethtool --show-priv-flags" failing with -EOPNOTSUPP. IMHO you
> should not return bogus string set if private flags are not implemented.
>=20
> Michal
>=20

I'm embarrassed we added a nice comment about stripping this because it doe=
sn't do anything and then failed to do just that.  Agreed the priv flag stu=
ff should not be here without any private flags existing, will fix.  Thanks=
 for the review.

Alan
