Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2312254C30
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 19:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726321AbgH0Rbe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 13:31:34 -0400
Received: from mga09.intel.com ([134.134.136.24]:45604 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726232AbgH0Rbd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Aug 2020 13:31:33 -0400
IronPort-SDR: V6CqO0/6zA6OCz+gPQQSLE34IXTjoHeS7MnzQTYlBlGiD4zZdWazIy5tqaJwgl1OWPv4TSCz0N
 FqHMCLcLuMrg==
X-IronPort-AV: E=McAfee;i="6000,8403,9726"; a="157560586"
X-IronPort-AV: E=Sophos;i="5.76,360,1592895600"; 
   d="scan'208";a="157560586"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2020 10:31:32 -0700
IronPort-SDR: K2wiuCxm9gv4ymGjGp8dQV8nPOyzOQhlRG+HhRqMZIeshK234lef11OJJ3goqkm9aQC79vZqxi
 AOjXr00h3VrA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,360,1592895600"; 
   d="scan'208";a="444524103"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga004.jf.intel.com with ESMTP; 27 Aug 2020 10:31:32 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 27 Aug 2020 10:31:28 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 27 Aug 2020 10:31:28 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.36.53) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Thu, 27 Aug 2020 10:30:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KiP6nJj9tKdI3jILn11X8I+gboTlREknbJ56IDj6XnNTFiPYDqRRx9e1A1uCDuB1lD5ttG58E1YE4SClPcmCIr4y9PLNqTldmeSErxgpQXo5eod9kton2EegbD7F54yMRh4V9NOlVuaJRGkoOQX0k02Kd5YFpM+JeDb9Yvavw8n8TYYHiADJujpdV4KrrMrjKqQeq9W3LSud/hFtjleRfianc9hIf9DBidChvCmvfUdq8O8E+EH1z//n5Z4EFW5905P70gWTXiYPFxUKVOMOOKgcZG+6Rmn5F1UCzEAhhGDLA2yt6hZvzqactS7egH/mo6I1tD/w/lkTRE7brt1+Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mh4bRkUSfKt4qxHvzeKjNBPZXBs7/dDGEcbeiPXFwO0=;
 b=AUK75YuPKkYDFMwnvx+uSV0I7lCVhMFHR8tCUJgHlHvWEGgsASMtB0bi7kNsDsVZPN3xSCfmQeI31WSF9zI70kJgKuLTKf7ZxbAEJtbv4HGD4wdgY7nFEjECuN0bBvIiPL0l2aA+Iln1CBkWYaRuOagY1V4T2a0kZN4ZRxLmsJ8G8VWj37UsVYoldxf61TvpwYREzmKASWNcUKEpCSkFfb/ja3uWyCSirJFQnMWOiVeVbA82HjqBnbOd+Vhm75MQl9ZkQlMYToSGbjkwJJVHOIq/ppqdLw1SQrydS0IOIlNrVX6ZknpU6/jKpQI2pCCn+rtlQzTPs+8IEnPR5J9sFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mh4bRkUSfKt4qxHvzeKjNBPZXBs7/dDGEcbeiPXFwO0=;
 b=gnLaSgKZ6bgbauAzmGp8Sh2v10ldVZ2LwE+gChNWuti0RViyz8zhcDCXoay+EnCQz9F8nlhByPYBZfuyOOcnKjSoxyl+7HhMpi51GkB/DpiL1DH1Qq3fvLVNEM0cVAZvGtr23rlIty5+jzxsAmAHnvpsje+RIriSHHbccZWSHJ8=
Received: from MW3PR11MB4522.namprd11.prod.outlook.com (2603:10b6:303:2d::8)
 by MWHPR1101MB2206.namprd11.prod.outlook.com (2603:10b6:301:51::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.26; Thu, 27 Aug
 2020 17:29:56 +0000
Received: from MW3PR11MB4522.namprd11.prod.outlook.com
 ([fe80::a43e:b4a1:3c31:aecd]) by MW3PR11MB4522.namprd11.prod.outlook.com
 ([fe80::a43e:b4a1:3c31:aecd%9]) with mapi id 15.20.3305.032; Thu, 27 Aug 2020
 17:29:56 +0000
From:   "Brady, Alan" <alan.brady@intel.com>
To:     Michal Kubecek <mkubecek@suse.cz>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "Michael, Alice" <alice.michael@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "Burra, Phani R" <phani.r.burra@intel.com>,
        "Hay, Joshua A" <joshua.a.hay@intel.com>,
        "Chittim, Madhu" <madhu.chittim@intel.com>,
        "Linga, Pavan Kumar" <pavan.kumar.linga@intel.com>,
        "Skidmore, Donald C" <donald.c.skidmore@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Subject: RE: [net-next v5 13/15] iecm: Add ethtool
Thread-Topic: [net-next v5 13/15] iecm: Add ethtool
Thread-Index: AQHWejy3TPFoHzKuPESb9TzmTcVdKalHyyMAgARvZaA=
Date:   Thu, 27 Aug 2020 17:29:56 +0000
Message-ID: <MW3PR11MB45229C6454CD4F0E68EAAE358F550@MW3PR11MB4522.namprd11.prod.outlook.com>
References: <20200824173306.3178343-1-anthony.l.nguyen@intel.com>
 <20200824173306.3178343-14-anthony.l.nguyen@intel.com>
 <20200824214456.go72ij4wfqpse7qj@lion.mk-sys.cz>
In-Reply-To: <20200824214456.go72ij4wfqpse7qj@lion.mk-sys.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: suse.cz; dkim=none (message not signed)
 header.d=none;suse.cz; dmarc=none action=none header.from=intel.com;
x-originating-ip: [174.127.217.60]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 850cca25-ff92-4249-3092-08d84aaed146
x-ms-traffictypediagnostic: MWHPR1101MB2206:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR1101MB2206306B9AFB14FE172E44108F550@MWHPR1101MB2206.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OpUpz7GUqBIsNhEqwOErByki0MddvAwC1Yw7IeeuJMkbXMkguW3K9mCk5Wq5UOYp4voiQ6dx1rDVOk7m0Esm97adTXqXlryEerD5AhFBkM6U+w1Sv5wJ9izrgh2Cs8QtJF8JgLONTBm7WpqEFlFuSyHHfHS6eXxz8QW728rUVLWC2olkJLBKQsiY4DvAjOq9ary1Iv9bBNyJpxeX7mwRWz6P3Q7pHOfA7Sz3yvlCdeeilx408Dv5yrI259zzD0M3dfeTB22pdgejVtVEMPEdflaJgLRRJkd4ZkNslKVlla8RLM/prrTR5UefmtcxS6Dgv5Fgmim9j/8JffQwhk+DzQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(396003)(136003)(376002)(39860400002)(7696005)(86362001)(26005)(316002)(83380400001)(33656002)(6506007)(53546011)(71200400001)(64756008)(66446008)(55016002)(66476007)(66556008)(76116006)(9686003)(110136005)(4326008)(6636002)(54906003)(8936002)(186003)(2906002)(8676002)(52536014)(107886003)(66946007)(478600001)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: uyBfn7beG6/T6W9rO7aUNSpLc9MjIGtrN2eWAsP2zjo5l4XXorgNmeISc1FtqwBSa6C7EKrH9jt0qKMIo3IwOKWlUW1hXxTMTz104Z0e71tVNEueVPkCaabfDrxows2JybvjstHHik9LHf6cWgBdEUBkz7MLla/WpQ5B6UFWwsw1Y7PnKDRsCP2bIeld0SgwmR5iOpqquCvLjRUOBohMuFyynpXqNm7NmfYhssv28lHOG9YBCVrOTtXP51m87Nk7lIMW4r6DkLBw75A0674ueOQZFrybeiS3TD8KnezV5qeBhqs+R7bbNG+/WN+Nh5nofu76N52E6jk8Pyx8Cr9DK9dXDWJIV6gNww+Kh+y5uctUWnCdHoxDsCGguk3vNKqaQyLD1VKDV3mwdJryUZpvuZapDRaJYk18iawOn7XmZQt4Q3OCOaWNE3miAqrIaz/x8dDzV5mMIT5kHNWUxPLaPJRyf3E/yQIaMbRNB/QyX0qXl2+asY/h6Uj6bOIFGu2pWb+RS1rHcgHqBU4wSlr8FtE+vYlBeRIm2JBJrpWxBStvS8MSSAaCYe/RuxodLNRiHJ3ruWz6hSqjT/3/4hcB9vzdj+nYG/n6xv/5FqqF8MM3W5SNo32QlLMdu5H6Sfqj0vZtkznALcAfdSxekT1dXA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 850cca25-ff92-4249-3092-08d84aaed146
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Aug 2020 17:29:56.5870
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xOKVaPO/z9kYOX+Xet3tC1RKgcLzAsvi1CRNFP7x5/Zppx5ZNQjRVJgqlWSvvKoMOAiKd/ifgFDaC7K8snnOYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2206
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Michal Kubecek <mkubecek@suse.cz>
> Sent: Monday, August 24, 2020 2:45 PM
> To: Nguyen, Anthony L <anthony.l.nguyen@intel.com>
> Cc: davem@davemloft.net; Michael, Alice <alice.michael@intel.com>;
> netdev@vger.kernel.org; nhorman@redhat.com; sassmann@redhat.com;
> Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>; Brady, Alan
> <alan.brady@intel.com>; Burra, Phani R <phani.r.burra@intel.com>; Hay,
> Joshua A <joshua.a.hay@intel.com>; Chittim, Madhu
> <madhu.chittim@intel.com>; Linga, Pavan Kumar
> <pavan.kumar.linga@intel.com>; Skidmore, Donald C
> <donald.c.skidmore@intel.com>; Brandeburg, Jesse
> <jesse.brandeburg@intel.com>; Samudrala, Sridhar
> <sridhar.samudrala@intel.com>
> Subject: Re: [net-next v5 13/15] iecm: Add ethtool
>=20
> On Mon, Aug 24, 2020 at 10:33:04AM -0700, Tony Nguyen wrote:
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
> > Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> > ---
> [...]
> > +static void iecm_get_channels(struct net_device *netdev,
> > +			      struct ethtool_channels *ch) {
> > +	struct iecm_vport *vport =3D iecm_netdev_to_vport(netdev);
> > +	unsigned int combined;
> > +
> > +	combined =3D min(vport->num_txq, vport->num_rxq);
> > +
> > +	/* Report maximum channels */
> > +	ch->max_combined =3D IECM_MAX_Q;
> > +
> > +	ch->max_other =3D IECM_MAX_NONQ;
> > +	ch->other_count =3D IECM_MAX_NONQ;
> > +
> > +	ch->combined_count =3D combined;
> > +	ch->rx_count =3D vport->num_rxq - combined;
> > +	ch->tx_count =3D vport->num_txq - combined; }
>=20
> You don't set max_rx and max_tx so that they will be always reported as 0=
. If
> vport->num_rxq !=3D vport->num_txq, one of rx_count, tx_count will be hig=
her
> than corresponding maximum so that any "set channels"
> request not touching that value will fail the sanity check in
> ethnl_set_channels() or ethtool_set_channels().

Will fix.

> > +
> > +/**
> > + * iecm_set_channels: set the new channel count
> > + * @netdev: network interface device structure
> > + * @ch: channel information structure
> > + *
> > + * Negotiate a new number of channels with CP. Returns 0 on success,
> > +negative
> > + * on failure.
> > + */
> > +static int iecm_set_channels(struct net_device *netdev,
> > +			     struct ethtool_channels *ch)
> > +{
> > +	struct iecm_vport *vport =3D iecm_netdev_to_vport(netdev);
> > +	int num_req_q =3D ch->combined_count;
> > +
> > +	if (num_req_q =3D=3D max(vport->num_txq, vport->num_rxq))
> > +		return 0;
> > +
> > +	vport->adapter->config_data.num_req_qs =3D num_req_q;
> > +
> > +	return iecm_initiate_soft_reset(vport, __IECM_SR_Q_CHANGE); }
>=20
> In iecm_get_channels() you set combined_count to minimum of num_rxq and
> num_txq but here you expect it to be the maximum. And you also completely
> ignore everything else than combined_count. Can this ever work correctly =
if
> num_rxq !=3D num_txq?
>=20

We will refactor this to make more sense.

> > +static int iecm_set_ringparam(struct net_device *netdev,
> > +			      struct ethtool_ringparam *ring) {
> > +	struct iecm_vport *vport =3D iecm_netdev_to_vport(netdev);
> > +	u32 new_rx_count, new_tx_count;
> > +
> > +	if (ring->rx_mini_pending || ring->rx_jumbo_pending)
> > +		return -EINVAL;
>=20
> This will be caught by the generic sanity check in ethnl_set_rings() or
> ethtool_set_ringparam().
>=20
> Michal
>=20

Will fix, thanks

-Alan


