Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCA6A23E873
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 10:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbgHGIAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 04:00:23 -0400
Received: from mga12.intel.com ([192.55.52.136]:42845 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726180AbgHGIAW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Aug 2020 04:00:22 -0400
IronPort-SDR: JjKhTN/h+JuPdk2ZWQPboQM8yz1o9R54Zzmcj2/0fCEneA4rasjcodTeAfM7f83qI7m8K4PPoV
 XAcjtjskPHSQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9705"; a="132584801"
X-IronPort-AV: E=Sophos;i="5.75,444,1589266800"; 
   d="scan'208";a="132584801"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2020 01:00:19 -0700
IronPort-SDR: +C3Z9pz0fRky7yCNjnEdHNu/WvAqzU/aGe8Hn1qgCxbgl0sJD3Xy43tBK40JXqa2ThRzd63OaN
 XCbIwri0VMSQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,444,1589266800"; 
   d="scan'208";a="333475866"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga007.jf.intel.com with ESMTP; 07 Aug 2020 01:00:18 -0700
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 7 Aug 2020 01:00:18 -0700
Received: from FMSEDG002.ED.cps.intel.com (10.1.192.134) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 7 Aug 2020 01:00:18 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.107)
 by edgegateway.intel.com (192.55.55.69) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Fri, 7 Aug 2020 01:00:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HhW3huxDV6oyZmYfpO6mSiraCYbnW/mvrHIxKuX+RO7F51Uh3urXuamGt6o+qP2MmDeIGvApPC1hrcuhQUbHeDADdN5TFth1wxAmOkDcIRnvU/CzGpsqclnnWFQrZdvI5fULYoFBI8ILM5YEEMeihDF7IHsd17mLYl9FdnYQhI9OZLDwidbzQulGAN2KYuY2R0X82DtvJnbqwSKiwXLad50dIGDq3CmePX8cILZZZr0dGPMYxYRwdlM2PhuWCp8SUOBw1+74uySwUCRE+K8utkevwL2+OZVeHsW5ppdsDO2J7GTDEs7MTXRIqdLkLKY1BIiwB47oEEpT+8kd9HSUfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mS7QqmhWzuxVJj0yhPlC7ICFbKEL9gcLoqtS6GZDvjs=;
 b=IJG8nMrTK9qFL8780RenkPu5juDtrxdtXBbO/miHcgWEXs+tYus3ofW2Tr917N4qZf0cNmP2qM1WVcOoTC+uKrNaQ+EQb6mFN0+OZlNgFdKKxAsgwNUmmEYf9COOmmGJCPFLMCF/CtVAlI3FctqVl0Z2mY4D92zlyFNvZwFUMy7BNT1JTnTzEaNUX06zxTewSvKFfD7h6eofLfTYtEfeDxOFfZ+CzrH+MgQe11vY73CvSDnRizY7F7e7Q/BmXyy3zMO2Nb0xqvPJpC/wgP0idglAU/oTSHH8+Ji84bQ7XYGy7yJ7YheK7GXW67FBm6uSvODezcHt8dQp+7Cp+2OhWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mS7QqmhWzuxVJj0yhPlC7ICFbKEL9gcLoqtS6GZDvjs=;
 b=OdQywAl1VwEjEZuyT7IW/IBAkYoDCujiV1qpjzYPxh+nirkRqQqmqGrQdXOiVJ6fxe62mAVLfhiyO+QMwyDrC8kMDQ43NLH5gkTsLhSygrE+8GAuONPNmtn85d6k2YGF4yBROzU1P74QTgN17NJMCCnYbOAObbwHIJyVr4TtpJs=
Received: from BN6PR11MB1250.namprd11.prod.outlook.com (2603:10b6:404:49::19)
 by BN6PR11MB0020.namprd11.prod.outlook.com (2603:10b6:405:6b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.17; Fri, 7 Aug
 2020 08:00:13 +0000
Received: from BN6PR11MB1250.namprd11.prod.outlook.com
 ([fe80::3d35:f08e:484:1808]) by BN6PR11MB1250.namprd11.prod.outlook.com
 ([fe80::3d35:f08e:484:1808%6]) with mapi id 15.20.3261.020; Fri, 7 Aug 2020
 08:00:13 +0000
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
Subject: RE: [PATCH v5 08/10] net: eth: altera: add support for ptp and
 timestamping
Thread-Topic: [PATCH v5 08/10] net: eth: altera: add support for ptp and
 timestamping
Thread-Index: AQHWY/e4YIJGgs2mJEi89yZpMyL1/6kbfLeAgBDcXzA=
Date:   Fri, 7 Aug 2020 08:00:13 +0000
Message-ID: <BN6PR11MB1250796D57A7F596F57EC0A3F2490@BN6PR11MB1250.namprd11.prod.outlook.com>
References: <20200727092157.115937-1-joyce.ooi@intel.com>
 <20200727092157.115937-9-joyce.ooi@intel.com> <20200727142925.GB16836@hoboy>
In-Reply-To: <20200727142925.GB16836@hoboy>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [42.189.168.206]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a2bad049-9531-4a86-e75a-08d83aa7ea5c
x-ms-traffictypediagnostic: BN6PR11MB0020:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR11MB0020DC6AAB6A630F1A455552F2490@BN6PR11MB0020.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: j3K1wt5k03RZ7jl6h9FLH3Xco7NTyjREI65OO/1ys30bxfTfAXflicFM9jmfj3x68OJFLwFwFlydX97ibkAefxjmN+ANDpqQO5XWM6lB9ryps5Wuz7Mkt5BSz4M5ZNh7F7A3B3oYqS9foGWkrB640QLdjzf4BVJSXMQmzL8vqW+7h+1lFlNWk/DqhtV4K+TS8PIyTm048VtHq4djzLjVcT9uApNbC0G0v0WKkzyBF9sQLdEvLQ0hR9yd6mhGub36Kanyu4W8kFzB1l7uY48iVEtB12YWnvKuyaGZncCe47mEeq8+W16gIW854rnTsoJs6e5zoDSh8+D4wini7kO39w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB1250.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(39860400002)(346002)(366004)(396003)(136003)(54906003)(316002)(8936002)(7696005)(86362001)(55016002)(478600001)(66446008)(76116006)(66476007)(66556008)(64756008)(66946007)(5660300002)(4326008)(83380400001)(9686003)(6506007)(6916009)(53546011)(2906002)(33656002)(186003)(71200400001)(8676002)(52536014)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: bYjEWuiimJK7TAs7+hYJ3Vd8prJLLL0v3GrHyz6FRUCG2dtZn6H3NwMKueKGMr7EKxi3nqNpcGy4OiLTet1MkVfFLfmEVfTotwkHbGvNQdjR16sGILpOnap+sv2OJbxc2UIClZDX7tHACv/56imtN6AQSi+C7GOyHjfn5KOS8Qse65HVj5oH3uWpRQNIzYZxxLRnoxWNAlImPTjypj9AF62OwA+G9smv0FrznB1fhPOYP5F/xieIoCeBKgbpXYLC7CYFRl5CIyjqwzssvDd1lhSsuUtAEfHbX/lZxBOKc7R3P3lnydc/poDHHiE7tJHluU3Ve6X2capVjlmPT9FrKEr9biHIPBRYsCNGJjDFSvjt081PnKELZ+7tpRHnr6SzsQLJfGGm9OtBBUh7TDLERRQ4MTR3UZJWB3c0fVqrK2ca+SSzCLWKgrHr7jSHeVavoTqmyhUTkZZC7vERYO/ShzvEyResauZiXRwLxrJobWRRUATSMtCB5+fxFuaFAqVoqud3+SSt1oCBC54c9gbWPOontGYajaMHoz1nL9PQse/hz2l924/KZPMmMZurNkeEuBtvZMtHPr927b+Rg2fBJXa9cvs2jVCJI5s52SLpkJ4z27ibqheEaX96bdJpfirM7VPVliHgvynJmyrqu4BNpw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB1250.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2bad049-9531-4a86-e75a-08d83aa7ea5c
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Aug 2020 08:00:13.8281
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KwuUVHMkuyvXPQeE3T6XhcwghTrerlLsPjL0nI8jS8ZceAfSrNXYfVom7/7BnTk0DPlvamxssgXxcTEaTs4kSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB0020
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Richard Cochran <richardcochran@gmail.com>
> Sent: Monday, July 27, 2020 10:29 PM
> To: Ooi, Joyce <joyce.ooi@intel.com>
> Cc: Thor Thayer <thor.thayer@linux.intel.com>; David S . Miller
> <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Dalon Westergreen
> <dalon.westergreen@linux.intel.com>; Tan, Ley Foon
> <ley.foon.tan@intel.com>; See, Chin Liang <chin.liang.see@intel.com>;
> Nguyen, Dinh <dinh.nguyen@intel.com>; Westergreen, Dalon
> <dalon.westergreen@intel.com>
> Subject: Re: [PATCH v5 08/10] net: eth: altera: add support for ptp and
> timestamping
>=20
> On Mon, Jul 27, 2020 at 05:21:55PM +0800, Ooi, Joyce wrote:
>=20
> > +/* ioctl to configure timestamping */ static int tse_do_ioctl(struct
> > +net_device *dev, struct ifreq *ifr, int cmd) {
> > +	struct altera_tse_private *priv =3D netdev_priv(dev);
> > +	struct hwtstamp_config config;
> > +
> > +	if (!netif_running(dev))
> > +		return -EINVAL;
> > +
> > +	if (!priv->has_ptp) {
> > +		netdev_alert(priv->dev, "Timestamping not supported");
> > +		return -EOPNOTSUPP;
> > +	}
>=20
> The user might well have a PHY that supports time stamping.  The code mus=
t
> pass the ioctl through to the PHY even when !priv->has_ptp.
Ok, I'll remove 'return -EOPNOTSUPP;' to allow those that have PHY with tim=
estamping support to go pass through ioctl.

>
> > +
> > +	if (!dev->phydev)
> > +		return -EINVAL;
> > +
> > +	if (!phy_has_hwtstamp(dev->phydev)) {
> > +		if (cmd =3D=3D SIOCSHWTSTAMP) {
> > +			if (copy_from_user(&config, ifr->ifr_data,
> > +					   sizeof(struct hwtstamp_config)))
> > +				return -EFAULT;
> > +
> > +			if (config.flags)
> > +				return -EINVAL;
> > +
> > +			switch (config.tx_type) {
> > +			case HWTSTAMP_TX_OFF:
> > +				priv->hwts_tx_en =3D 0;
> > +				break;
> > +			case HWTSTAMP_TX_ON:
> > +				priv->hwts_tx_en =3D 1;
> > +				break;
> > +			default:
> > +				return -ERANGE;
> > +			}
> > +
> > +			switch (config.rx_filter) {
> > +			case HWTSTAMP_FILTER_NONE:
> > +				priv->hwts_rx_en =3D 0;
> > +				config.rx_filter =3D HWTSTAMP_FILTER_NONE;
> > +				break;
> > +			default:
> > +				priv->hwts_rx_en =3D 1;
> > +				config.rx_filter =3D HWTSTAMP_FILTER_ALL;
> > +				break;
> > +			}
> > +
> > +			if (copy_to_user(ifr->ifr_data, &config,
> > +					 sizeof(struct hwtstamp_config)))
> > +				return -EFAULT;
> > +			else
> > +				return 0;
> > +		}
> > +
> > +		if (cmd =3D=3D SIOCGHWTSTAMP) {
> > +			config.flags =3D 0;
> > +
> > +			if (priv->hwts_tx_en)
> > +				config.tx_type =3D HWTSTAMP_TX_ON;
> > +			else
> > +				config.tx_type =3D HWTSTAMP_TX_OFF;
> > +
> > +			if (priv->hwts_rx_en)
> > +				config.rx_filter =3D HWTSTAMP_FILTER_ALL;
> > +			else
> > +				config.rx_filter =3D HWTSTAMP_FILTER_NONE;
> > +
> > +			if (copy_to_user(ifr->ifr_data, &config,
> > +					 sizeof(struct hwtstamp_config)))
> > +				return -EFAULT;
> > +			else
> > +				return 0;
> > +		}
> > +	}
> > +
> > +	return phy_mii_ioctl(dev->phydev, ifr, cmd); }
>=20
> Thanks,
> Richard
