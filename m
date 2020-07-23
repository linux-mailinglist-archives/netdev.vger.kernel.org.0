Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9A9422A3C6
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 02:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729486AbgGWAnO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 20:43:14 -0400
Received: from mga04.intel.com ([192.55.52.120]:46859 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726685AbgGWAnN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jul 2020 20:43:13 -0400
IronPort-SDR: XK8r/i+amaIgf8JE3JelKi/Y4HRqHGGXrl1De3K6jsRvTj06X0dDsFR88BG1Yd7JodbjcK7ho9
 6K0l193ABsqQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9690"; a="147938532"
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="147938532"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2020 17:43:10 -0700
IronPort-SDR: upClQmK4/kFpMBlipOeOGFKQxxAMeW4mQIokEr6MmvyAS/208+PFiFNV6vNguUA9/xWDhzJz76
 hpG3xS/aF3dw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="310830970"
Received: from orsmsx107.amr.corp.intel.com ([10.22.240.5])
  by fmsmga004.fm.intel.com with ESMTP; 22 Jul 2020 17:43:10 -0700
Received: from orsmsx152.amr.corp.intel.com (10.22.226.39) by
 ORSMSX107.amr.corp.intel.com (10.22.240.5) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 22 Jul 2020 17:43:10 -0700
Received: from ORSEDG001.ED.cps.intel.com (10.7.248.4) by
 ORSMSX152.amr.corp.intel.com (10.22.226.39) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 22 Jul 2020 17:43:10 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.172)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 22 Jul 2020 17:43:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c1eVkvtlTmosyz3NJ7oS4Q4VCgmhFAlUU2AH1mDibWTxEcTqmNHEDuujLIfz2Ebt/QJAZEcv2Ty3k/zxpMTy9sAHkY27PaRBBhW+xwrj3TjWZzYePNDahxwOObGKs9kq0Z+Ew2vR5xt5gpWTcgTIMj1TWBFwAxdz/N9JzgJcnKxd5auOwYy4/enqbwPi3E4VX2RT5CKY5OsP0Hrbj1wk53zkMtBnk1cYQpqpCyu61ILHb+Uq0FWk/qryyq7jehkVbtNusyzJQKsDg9IEfnmHiUqCcy3KdV2uSQNN089xvw1S9jDrGCHWKCh6OexI1pVDYK+RHXhu45ipRx04TPjDxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MTD97rE0dN3t4CzEyWqlWP0PnoIS9nyItlgjrG4YN9k=;
 b=Yl1GSqW6GwR9DXGeyQPk3q2fqgwrdClHyxV6EjDqlLbeeK+/4x5FeHJ3twrUp+1haXYX8Hmer61Q78QQgWRgt1TABNULF6IFhZp4BmN75AO+NeQCcVm2MbhrLMBRU6BY4CWnPiylIX307Ap9Le8UTIIPTNfhI92GjywKQ5qXDtGWy0ukZ5aMneg9wHNCP4MQeuo3XHusSxvBcTgVUSxXjeXB2q1E8w9E2iZqZAYJp37SdqlE5sb4Xvdna068XBdalkL4kHN1bdj7GtyQfbJ5cxWnT5RRTLE+p5Fs96iz78lf7k921Y9bzWwSnCQzO3228zjxt9vi94z+pBWgJkM5mA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MTD97rE0dN3t4CzEyWqlWP0PnoIS9nyItlgjrG4YN9k=;
 b=KTKOmupRk3602O6aOZScx3++cf0R2+sJZlgp5sC+Q36ARLsGZLmSs72kxRwPitBer8e0GKD7l4VomFNU+V8Vli6jW4yLtCc4a3ucEj50VWOtQawkXTRWXP/gizPAXeB/dnYnIFRj28+TMP8e95dzy2QgX7ooxNSDd7ybs6ZVi0Y=
Received: from MW3PR11MB4522.namprd11.prod.outlook.com (2603:10b6:303:2d::8)
 by MW3PR11MB4748.namprd11.prod.outlook.com (2603:10b6:303:2e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.20; Thu, 23 Jul
 2020 00:43:06 +0000
Received: from MW3PR11MB4522.namprd11.prod.outlook.com
 ([fe80::a43e:b4a1:3c31:aecd]) by MW3PR11MB4522.namprd11.prod.outlook.com
 ([fe80::a43e:b4a1:3c31:aecd%9]) with mapi id 15.20.3216.020; Thu, 23 Jul 2020
 00:43:06 +0000
From:   "Brady, Alan" <alan.brady@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
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
Subject: RE: [net-next v4 13/15] iecm: Add ethtool
Thread-Topic: [net-next v4 13/15] iecm: Add ethtool
Thread-Index: AQHWXvdWH2JuJsJKxESeUPdqD+YajakSW2GAgAH3COA=
Date:   Thu, 23 Jul 2020 00:43:06 +0000
Message-ID: <MW3PR11MB45222CCF2D02C1975B836BE08F760@MW3PR11MB4522.namprd11.prod.outlook.com>
References: <20200721003810.2770559-1-anthony.l.nguyen@intel.com>
        <20200721003810.2770559-14-anthony.l.nguyen@intel.com>
 <20200721112757.4c38ea8b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200721112757.4c38ea8b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.2.0.6
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [174.127.217.60]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e3fa40fa-173e-4baf-e684-08d82ea15d8d
x-ms-traffictypediagnostic: MW3PR11MB4748:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR11MB4748F8C866CC46ADEA969BF88F760@MW3PR11MB4748.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: n43oeHhYURmzfQV7hNeWLzicLnaxgUb5UWOQagfuQhg7ZQWfkmFG8Nbgz2uwEzv24wB1abJsqDuALZ1+PUA4gnfK4Xslo6XDxLLrvmuFaf87T/ndgLXhd9LqmFaQg/g7YcKGDCRaOi272DZJ1666ThfY+WG4egngtCsNNjpNOraH9/NhW4Zt+sl/b+Urzx8xXo3OfDomGHXwwp03dpEsVfSW6lp8d0lQbYVenTv/eRQoNKx+JTpFojAVgmj1j/oACdNsUbk9lvlxwJ3SOhiwRPxYq3iB8uXtp6P4YTBr6vwNWvN7vf095pozYwkRZ1bp
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(396003)(376002)(136003)(346002)(107886003)(54906003)(33656002)(26005)(316002)(110136005)(71200400001)(8936002)(86362001)(2906002)(5660300002)(4326008)(66446008)(66556008)(64756008)(7696005)(52536014)(478600001)(55016002)(6636002)(9686003)(8676002)(186003)(76116006)(66946007)(83380400001)(66476007)(6506007)(53546011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: /Oq0N224UJirAp79vgmA7d84v9cjEekuPNw10ZcVqelNAARzK7kQl3aN7ogI/+mfvSh1vGXns+7lM5/khR8jXl4vBQfhc+97EDKOLZv8D0FDnmd17NrU10OjJe1pyjnyQi9jbRi3nelk5IyM7c73RS+fR6ZZ9/NFSnKftIBbRzgxJKDB8M1WJi9xfG2C9AsNjsDg6xnEmoOJSJDY+fEqPHri8lrQf2Gk8TfefUvyvM9EikI4/y75fyFq3n/kVFVv+OXmLy0H/OiFOzi4p6BCpvPI7hv/x/YBr5uXjfm2ZlessbaNbM80bfM2kyZdiE6R/NDjMtaisllTR/tpUnCYVD8SfSfoJmBmqKws/z2Km0i/TO2lFztaPJjPFJKpWCoOGNLf9H26FUZUyIWngFG81jOXEPgz5YvfgqUiZA88gG17qaF13F97PphhI7IpG42sSsuOklHF1rcjJCk/MZ9tPub5hQBLdDZYaUzRosMJDxMy3+IAIobrCtLFJhLEKaSJ
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3fa40fa-173e-4baf-e684-08d82ea15d8d
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2020 00:43:06.4818
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EExt650ZOHUC+EOD8AeZ7tMe/ntMpKAJIDyqnROhgnAGNEYRlD0rvalRGLidO+rCVfrEiZNgxzos5m8P2m0ApQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4748
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Tuesday, July 21, 2020 11:28 AM
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
> Subject: Re: [net-next v4 13/15] iecm: Add ethtool
>=20
> On Mon, 20 Jul 2020 17:38:08 -0700 Tony Nguyen wrote:
> > +/**
> > + * iecm_set_rxfh - set the Rx flow hash indirection table
> > + * @netdev: network interface device structure
> > + * @indir: indirection table
> > + * @key: hash key
> > + * @hfunc: hash function to use
> > + *
> > + * Returns -EINVAL if the table specifies an invalid queue id,
> > +otherwise
> > + * returns 0 after programming the table.
> > + */
> > +static int iecm_set_rxfh(struct net_device *netdev, const u32 *indir,
> > +			 const u8 *key, const u8 hfunc)
> > +{
> > +	struct iecm_vport *vport =3D iecm_netdev_to_vport(netdev);
> > +	struct iecm_adapter *adapter;
> > +	u16 *qid_list;
> > +	u16 lut;
> > +
> > +	adapter =3D vport->adapter;
> > +
> > +	if (!iecm_is_cap_ena(adapter, VIRTCHNL_CAP_RSS)) {
> > +		dev_info(&adapter->pdev->dev, "RSS is not supported on this
> device\n");
> > +		return 0;
> > +	}
> > +	if (adapter->state !=3D __IECM_UP)
> > +		return 0;
> > +
> > +	if (hfunc !=3D ETH_RSS_HASH_NO_CHANGE && hfunc !=3D
> ETH_RSS_HASH_TOP)
> > +		return -EOPNOTSUPP;
> > +
> > +	if (key)
> > +		memcpy(adapter->rss_data.rss_key, key,
> > +		       adapter->rss_data.rss_key_size);
> > +
> > +	qid_list =3D kcalloc(vport->num_rxq, sizeof(u16), GFP_KERNEL);
> > +	if (!qid_list)
> > +		return -ENOMEM;
> > +
> > +	iecm_get_rx_qid_list(vport, qid_list);
> > +
> > +	if (indir) {
> > +		for (lut =3D 0; lut < adapter->rss_data.rss_lut_size; lut++) {
> > +			int index =3D indir[lut];
> > +
> > +			if (index >=3D vport->num_rxq) {
> > +				kfree(qid_list);
> > +				return -EINVAL;
> > +			}
>=20
> Core checks this already.

Will fix.

>=20
> > +			adapter->rss_data.rss_lut[lut] =3D qid_list[index];
> > +		}
> > +	} else {
> > +		iecm_fill_dflt_rss_lut(vport, qid_list);
>=20
> indir =3D=3D NULL means no change, not reset.
>=20

Yes this is wrong, will fix.

> > +	}
> > +
> > +	kfree(qid_list);
> > +
> > +	return iecm_config_rss(vport);
> > +}
> > +
> > +/**
> > + * iecm_get_channels: get the number of channels supported by the
> > +device
> > + * @netdev: network interface device structure
> > + * @ch: channel information structure
> > + *
> > + * Report maximum of TX and RX. Report one extra channel to match our
> > +mailbox
> > + * Queue.
> > + */
> > +static void iecm_get_channels(struct net_device *netdev,
> > +			      struct ethtool_channels *ch) {
> > +	struct iecm_vport *vport =3D iecm_netdev_to_vport(netdev);
> > +
> > +	/* Report maximum channels */
> > +	ch->max_combined =3D IECM_MAX_Q;
> > +
> > +	ch->max_other =3D IECM_MAX_NONQ;
> > +	ch->other_count =3D IECM_MAX_NONQ;
> > +
> > +	ch->combined_count =3D max(vport->num_txq, vport->num_rxq);
>=20
> If you allow different counts of rxq and txq - the calculation is
>=20
> combined =3D min(rxq, txq)
> rx =3D rxq - combined
> tx =3D txq - combined
>=20
> not very intuitive, but that's my interpretation of the API.
>=20
> Can rxq !=3D txq?
>=20

Ultimately yes.  We're still missing some of the finer details required to =
manage buffers in this new split queue model so we're not quite ready to en=
able that in set_channels, but yes I we should certainly fix the reporting =
in get_channels to be accurate.  Will fix.

> > +}
>=20
> > +static void iecm_get_drvinfo(struct net_device *netdev,
> > +			     struct ethtool_drvinfo *drvinfo) {
> > +	struct iecm_adapter *adapter =3D iecm_netdev_to_adapter(netdev);
> > +
> > +	strlcpy(drvinfo->driver, iecm_drv_name, 32);
> > +	strlcpy(drvinfo->fw_version, "N/A", 4);
>=20
> I think we agreed to remove this, what happened?
>=20

My sincere apologies, not intentional.  This will be gone in the next versi=
on.

-Alan
