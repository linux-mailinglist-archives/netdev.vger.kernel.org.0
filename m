Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4C1D22030F
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 05:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728663AbgGODs7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 23:48:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:58325 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726893AbgGODs6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jul 2020 23:48:58 -0400
IronPort-SDR: 7b3x+ftJpeEDpBhz/o0zFc0xJ+IcGsj5V86y4tO0lM1tGYF6iQCAn4ndDltEKuZmumnXSMn7Ul
 i4ahx/KjiJCA==
X-IronPort-AV: E=McAfee;i="6000,8403,9682"; a="137205626"
X-IronPort-AV: E=Sophos;i="5.75,353,1589266800"; 
   d="scan'208";a="137205626"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2020 20:48:57 -0700
IronPort-SDR: 8fVfawAozvvHwEYzVFCCg67mXvc79ipvk7holK4MDK6+OzYuLhkAra6wFuyjFPy7CilNg0bBbo
 o4NZ+hlVtYLg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,353,1589266800"; 
   d="scan'208";a="360581282"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by orsmga001.jf.intel.com with ESMTP; 14 Jul 2020 20:48:57 -0700
Received: from FMSEDG001.ED.cps.intel.com (10.1.192.133) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 14 Jul 2020 20:48:57 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Tue, 14 Jul 2020 20:48:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kKsI99gvQz7WvRuq8pyJ3Penw93loAxvadbF4hVZfPSBC6nqVdKe1E2cYdIJGifgJrBs+Kcq/3zDUSprntLMCx7BvBZ7TD/vk06MLNyksCshjXz347R5WpEm4RKl3I3HnEvhghtiGgm0F1Zk8jezKUON8f5O6csyUpxNz84IeQvIoCJutjdsYx5RXJ489fx+IxKo5uzNDCctFU2Pa0AbxgR9cGaHu/9OVng9RH5f4TDnAzIEJB1em5XUJRoCkPNq0m4HtwjUEOSHOGgIRUgRU9r+0E5PBpnE/ssmeWuN/ZfXxd1bTVWW2deyn/3fqZPcRtZvhU/kW42K5GyV8DXP2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zjzzDqlbPGsP0rxkN0BlVBbBeGCK66+4iIaJ4FbARww=;
 b=mAuwFAb5UhBGcvgfxOTEc0/xnb3hVj9w0gVXjrnXmIp+IKXO3Zq2So067EIZ0IY6CTK3kZINaVnstUrFLKSvSUnMrB7AcLHcW7hGzdLznOIgttabbHvXGf/wLKHJw4F3lEcm42zLHj4TRPc5TNGlygAotn/e/IYmumhixhciZz89tDlPTXOalyWuvhQY43vnDwypN/NGOAIWJvqPQjDjdtcus3z6AcoBTXTwst6Nfysec1UMfnXRfLtxRJPWq0CgcscMapbVdQNe5D54+6eHikzdBLPasmPS2gejJIQMcjjxZwTIRe6XOuG03d1goy0BnxzYJ2Dp9PR9x6M8tzWSsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zjzzDqlbPGsP0rxkN0BlVBbBeGCK66+4iIaJ4FbARww=;
 b=sA+2cy/trfn8V2JHzNQeY8Jr6dxdQu6npn1Tn283WxPaZ/W1O9xnet64IhyMQ6/uaCy8TdImBta3BhMBXIa6nlvVAFG9oHhNzLeiSF+g/YwQKy8a/4tXoZsUAo/0avAFk6ryUCGHlEP9Ar4kiyRzLL6jQUh1fuVzVbDumVcI39I=
Received: from BN6PR11MB1250.namprd11.prod.outlook.com (2603:10b6:404:49::19)
 by BN6PR11MB0019.namprd11.prod.outlook.com (2603:10b6:405:69::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21; Wed, 15 Jul
 2020 03:48:55 +0000
Received: from BN6PR11MB1250.namprd11.prod.outlook.com
 ([fe80::3d35:f08e:484:1808]) by BN6PR11MB1250.namprd11.prod.outlook.com
 ([fe80::3d35:f08e:484:1808%6]) with mapi id 15.20.3195.017; Wed, 15 Jul 2020
 03:48:55 +0000
From:   "Ooi, Joyce" <joyce.ooi@intel.com>
To:     Richard Cochran <richardcochran@gmail.com>
CC:     Thor Thayer <thor.thayer@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Dalon Westergreen" <dalon.westergreen@linux.intel.com>,
        "Tan, Ley Foon" <ley.foon.tan@intel.com>,
        "See, Chin Liang" <chin.liang.see@intel.com>,
        "Nguyen, Dinh" <dinh.nguyen@intel.com>,
        "Westergreen, Dalon" <dalon.westergreen@intel.com>
Subject: RE: [PATCH v4 08/10] net: eth: altera: add support for ptp and
 timestamping
Thread-Topic: [PATCH v4 08/10] net: eth: altera: add support for ptp and
 timestamping
Thread-Index: AQHWVPkJhwESHu7l8k201R4O3olQz6j/HwQAgAjo3OA=
Date:   Wed, 15 Jul 2020 03:48:55 +0000
Message-ID: <BN6PR11MB1250550070D2670315283F6DF27E0@BN6PR11MB1250.namprd11.prod.outlook.com>
References: <20200708072401.169150-1-joyce.ooi@intel.com>
 <20200708072401.169150-9-joyce.ooi@intel.com> <20200709113126.GA776@hoboy>
In-Reply-To: <20200709113126.GA776@hoboy>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.2.0.6
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [1.9.122.68]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ca2f1d59-567a-4970-7da7-08d82871ff57
x-ms-traffictypediagnostic: BN6PR11MB0019:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR11MB001989FD463DAAC7BC5F24B8F27E0@BN6PR11MB0019.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6MfPoFJdskZ1UMCp3FlRWdcGqoCofQR+kBSUdUipjESumMzE72PeL7phNVE+P5w8D7w2FMEmPTdNmPf5FpKGoMbTf2l/uZQQJLNjmbJuwm2W18CcxqMiKDN6k1DTbNT/k20aRNejS3FmJCEdaHqXVV+NqXpIL3JWv4+xzqzgDJ1oeBzQXRhsAkFsaQQ3V2AsHHNSr6eV0U2L71ms9U7zBD1Sfe/HWcTQzTVnboCRasHaqjfG4nVpNLaDZtBTu9BviCPldxL4zv+9DuaxdotH1xzYlnyQ69t23/JzqDqobw3MZ2gJEbA4PiSY2HUNNwL9w3KluK2KLDG8nSrrUlj6Uw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB1250.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(346002)(39860400002)(366004)(376002)(136003)(2906002)(6916009)(316002)(33656002)(4326008)(54906003)(55016002)(9686003)(83380400001)(76116006)(478600001)(52536014)(66946007)(5660300002)(64756008)(66476007)(66556008)(8676002)(8936002)(86362001)(7696005)(6506007)(53546011)(66446008)(71200400001)(186003)(55236004)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: kdmfuObMtBYrL07d78uL+2sOatsqm14cFLxm3FDGgexe3bD9asgBQBxL/qgTOTiDLFK24QaxjYoxDeh/xRM1MoDTpxxXdDvSgQjLtMug9xdR53RRDiL2iPG9HLrhhhRZaz3u2lorAvuYJzkdWF5jzCVFgm6FVF5YDIBRTKwvhTgJ0BMAwdREtL30u6EPYsma8jUsKRtoG/ud47t92oRkZjKbaBKgfAz5f7rfNDDFecvnw7g18CMCRl31OLQIqgfXNomn7BpWEfLV/xL54Mn05MAyYoXxU/7KBU2AZmhlFH/Ck3SFAK++0WVmTndXnOvfLO3y+WCpa59efHDhBsX5AjA6xzrBl+HjD2MDx2KMcIrIKnlwSEQVnK/rUCwRw1qMFSzm7vhFz2s4nC/9mMgf/mkytXhc6qh3g+6ufltiXQ/s3vznSpyQuHw5Y/Y800AJ2ZbGxO59mg34rafs3/RkFPRY905r9i76uMBgOzk0r8I=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB1250.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca2f1d59-567a-4970-7da7-08d82871ff57
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2020 03:48:55.0715
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iCMABtntKprSiwsAiHWOwesRhTDbR6/czFcapVbseCh6aFb5cwlLMmwNqWqQCqh2N0Uh9/vuWHDz2L/A2xa8Qw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB0019
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Richard Cochran <richardcochran@gmail.com>
> Sent: Thursday, July 9, 2020 7:31 PM
> To: Ooi, Joyce <joyce.ooi@intel.com>
> Cc: Thor Thayer <thor.thayer@linux.intel.com>; David S . Miller
> <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Dalon Westergreen
> <dalon.westergreen@linux.intel.com>; Tan, Ley Foon
> <ley.foon.tan@intel.com>; See, Chin Liang <chin.liang.see@intel.com>;
> Nguyen, Dinh <dinh.nguyen@intel.com>; Westergreen, Dalon
> <dalon.westergreen@intel.com>
> Subject: Re: [PATCH v4 08/10] net: eth: altera: add support for ptp and
> timestamping
>=20
> On Wed, Jul 08, 2020 at 03:23:59PM +0800, Ooi, Joyce wrote:
>=20
> > @@ -222,6 +223,32 @@ static void tse_get_regs(struct net_device *dev,
> struct ethtool_regs *regs,
> >  		buf[i] =3D csrrd32(priv->mac_dev, i * 4);  }
> >
> > +static int tse_get_ts_info(struct net_device *dev,
> > +			   struct ethtool_ts_info *info)
> > +{
> > +	struct altera_tse_private *priv =3D netdev_priv(dev);
> > +
> > +	if (priv->ptp_enable) {
> > +		if (priv->ptp_priv.ptp_clock)
> > +			info->phc_index =3D
> > +				ptp_clock_index(priv->ptp_priv.ptp_clock);
>=20
> Need to handle case where priv->ptp_priv.ptp_clock =3D=3D NULL.

Ok, will add a checking if priv->ptp_priv.ptp_clock =3D=3D NULL, it'll retu=
rn error.

>=20
> > +		info->so_timestamping =3D
> SOF_TIMESTAMPING_TX_HARDWARE |
> > +
> 	SOF_TIMESTAMPING_RX_HARDWARE |
> > +
> 	SOF_TIMESTAMPING_RAW_HARDWARE;
> > +
> > +		info->tx_types =3D (1 << HWTSTAMP_TX_OFF) |
> > +						 (1 << HWTSTAMP_TX_ON);
>=20
> No need to break statement.  This fits nicely on one line.
>=20
> > +
> > +		info->rx_filters =3D (1 << HWTSTAMP_FILTER_NONE) |
> > +						   (1 <<
> HWTSTAMP_FILTER_ALL);
> > +
> > +		return 0;
> > +	} else {
>=20
> No need for else block.

Noted, will make the changes.
>=20
> > +		return ethtool_op_get_ts_info(dev, info);
> > +	}
> > +}
> > +
> >  static const struct ethtool_ops tse_ethtool_ops =3D {
> >  	.get_drvinfo =3D tse_get_drvinfo,
> >  	.get_regs_len =3D tse_reglen,
>=20
>=20
> > @@ -1309,6 +1324,83 @@ static int tse_shutdown(struct net_device *dev)
> >  	return 0;
> >  }
> >
> > +/* ioctl to configure timestamping */ static int tse_do_ioctl(struct
> > +net_device *dev, struct ifreq *ifr, int cmd) {
> > +	struct altera_tse_private *priv =3D netdev_priv(dev);
> > +	struct hwtstamp_config config;
>=20
> Need to check here for phy_has_hwtstamp() and pass through to PHY layer
> if true.

Ok, will add a phy_has_hwtstamp checking before if (cmd =3D=3D SIOCSHWTSTAM=
P) and if (cmd =3D=3D SIOCGHWTSTAMP) are called.
>=20
> > +
> > +	if (!netif_running(dev))
> > +		return -EINVAL;
> > +
> > +	if (!priv->ptp_enable)	{
> > +		netdev_alert(priv->dev, "Timestamping not supported");
> > +		return -EOPNOTSUPP;
> > +	}
> > +
> > +	if (cmd =3D=3D SIOCSHWTSTAMP) {
> > +		if (copy_from_user(&config, ifr->ifr_data,
> > +				   sizeof(struct hwtstamp_config)))
> > +			return -EFAULT;
> > +
> > +		if (config.flags)
> > +			return -EINVAL;
> > +
> > +		switch (config.tx_type) {
> > +		case HWTSTAMP_TX_OFF:
> > +			priv->hwts_tx_en =3D 0;
> > +			break;
> > +		case HWTSTAMP_TX_ON:
> > +			priv->hwts_tx_en =3D 1;
> > +			break;
> > +		default:
> > +			return -ERANGE;
> > +		}
> > +
> > +		switch (config.rx_filter) {
> > +		case HWTSTAMP_FILTER_NONE:
> > +			priv->hwts_rx_en =3D 0;
> > +			config.rx_filter =3D HWTSTAMP_FILTER_NONE;
> > +			break;
> > +		default:
> > +			priv->hwts_rx_en =3D 1;
> > +			config.rx_filter =3D HWTSTAMP_FILTER_ALL;
> > +			break;
> > +		}
> > +
> > +		if (copy_to_user(ifr->ifr_data, &config,
> > +				 sizeof(struct hwtstamp_config)))
> > +			return -EFAULT;
> > +		else
> > +			return 0;
> > +	}
> > +
> > +	if (cmd =3D=3D SIOCGHWTSTAMP) {
> > +		config.flags =3D 0;
> > +
> > +		if (priv->hwts_tx_en)
> > +			config.tx_type =3D HWTSTAMP_TX_ON;
> > +		else
> > +			config.tx_type =3D HWTSTAMP_TX_OFF;
> > +
> > +		if (priv->hwts_rx_en)
> > +			config.rx_filter =3D HWTSTAMP_FILTER_ALL;
> > +		else
> > +			config.rx_filter =3D HWTSTAMP_FILTER_NONE;
> > +
> > +		if (copy_to_user(ifr->ifr_data, &config,
> > +				 sizeof(struct hwtstamp_config)))
> > +			return -EFAULT;
> > +		else
> > +			return 0;
> > +	}
> > +
> > +	if (!dev->phydev)
> > +		return -EINVAL;
> > +
> > +	return phy_mii_ioctl(dev->phydev, ifr, cmd); }
> > +
> >  static struct net_device_ops altera_tse_netdev_ops =3D {
> >  	.ndo_open		=3D tse_open,
> >  	.ndo_stop		=3D tse_shutdown,
>=20
>=20
> > @@ -1568,6 +1661,27 @@ static int altera_tse_probe(struct
> platform_device *pdev)
> >  		netdev_err(ndev, "Cannot attach to PHY (error: %d)\n", ret);
> >  		goto err_init_phy;
> >  	}
> > +
> > +	priv->ptp_enable =3D of_property_read_bool(pdev->dev.of_node,
> > +						 "altr,has-ptp");
>=20
> The name "ptp_enable" is a poor choice.  It sounds like something that ca=
n
> be enabled at run time.  Suggest "has_ptp" instead.

Ok, will rename to 'has_ptp'.
>=20
> > +	dev_info(&pdev->dev, "PTP Enable: %d\n", priv->ptp_enable);
> > +
> > +	if (priv->ptp_enable) {
> > +		/* MAP PTP */
> > +		ret =3D intel_fpga_tod_probe(pdev, &priv->ptp_priv);
> > +		if (ret) {
> > +			dev_err(&pdev->dev, "cannot map PTP\n");
> > +			goto err_init_phy;
> > +		}
> > +		ret =3D intel_fpga_tod_register(&priv->ptp_priv,
> > +					      priv->device);
> > +		if (ret) {
> > +			dev_err(&pdev->dev, "Failed to register PTP
> clock\n");
> > +			ret =3D -ENXIO;
> > +			goto err_init_phy;
> > +		}
> > +	}
> > +
> >  	return 0;
> >
> >  err_init_phy:
>=20
>=20
> > +/* Initialize PTP control block registers */ int
> > +intel_fpga_tod_init(struct intel_fpga_tod_private *priv) {
> > +	struct timespec64 now;
> > +	int ret =3D 0;
> > +
> > +	ret =3D intel_fpga_tod_adjust_fine(&priv->ptp_clock_ops, 0l);
>=20
> Why clobber a learned frequency offset here?  If user space closes then r=
e-
> opens, then it expects the old frequency to be preserved.
>=20
> It is fine to set this to zero when the driver loads, but not after.

I'll remove this adjust_fine() during init as it'll be called whenever the =
callback function is called.
>=20
> > +	if (ret !=3D 0)
> > +		goto out;
> > +
> > +	/* Initialize the hardware clock to the system time */
> > +	ktime_get_real_ts64(&now);
>=20
> Please initialize to zero instead, as some people prefer it that way.
>=20
> (But only the first time when the driver loads!)

Ok sure, I'll initialize the hardware clock to 0.
>=20
> > +	intel_fpga_tod_set_time(&priv->ptp_clock_ops, &now);
> > +
> > +	spin_lock_init(&priv->tod_lock);
> > +
> > +out:
> > +	return ret;
> > +}
>=20
> Thanks,
> Richard
