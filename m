Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B027020B797
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 19:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbgFZRxZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 13:53:25 -0400
Received: from mga09.intel.com ([134.134.136.24]:20030 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726002AbgFZRxY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jun 2020 13:53:24 -0400
IronPort-SDR: us4Ma9gOs3qS0qSUl4Cjof8C6M6NKQPuKIRRCaOGopO2T/JvAJicvrpZ1VaFJgZkr2WfVIy4wO
 tr4FqbC/woZg==
X-IronPort-AV: E=McAfee;i="6000,8403,9664"; a="146931007"
X-IronPort-AV: E=Sophos;i="5.75,284,1589266800"; 
   d="scan'208";a="146931007"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2020 10:53:22 -0700
IronPort-SDR: IEN9Arr0qWDFFOKeVWICKhISzg0lDYQ6cwNig/WVle1HzaREhmfN41+epj16k6NprhrOvU+5UU
 GkYFgpEIZhog==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,284,1589266800"; 
   d="scan'208";a="385830357"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by fmsmga001.fm.intel.com with ESMTP; 26 Jun 2020 10:53:22 -0700
Received: from fmsmsx122.amr.corp.intel.com (10.18.125.37) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 26 Jun 2020 10:51:37 -0700
Received: from FMSEDG002.ED.cps.intel.com (10.1.192.134) by
 fmsmsx122.amr.corp.intel.com (10.18.125.37) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 26 Jun 2020 10:51:37 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (192.55.55.69) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Fri, 26 Jun 2020 10:51:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GisFcHltBJWOzCtYYHH6a2lhUHcVQhe1vyvAl4eTAiYNpFlYCyPjRokcVgg6hNvZgSXsUJewk6tSgw5M+pr0ZUEvIA73qzMHRKTE0gw+/1AJRmEon8PXlei1djzbHkotJw2+4oH3K6NLRg3EssmR6lNVEZHR1RG95kbgelvGK+jBUom953comOqayAIr9t1Lkf2ALly6XYm43mh/Nw5azk8XdPT/MllhfHK8Q18quxEFk+AJUTQsL1csGYInNkopCTEeJKkY7ZZiJDxD56MUuAQnBAKFjQolbfviqCiXdjAs08FHIBlpfhm8CkgZvvclMQ6/PiY3BGeC5WXAmfDO7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J8NXtjoDoCNo1sSJ8gLaoXzBVj8JYIXViWEbzOvLKjw=;
 b=m8t0Z7elp5bTtvHh9v3dXh3Ls7Tn2TJJTziWsIJyoK072X6++i8xnLeJ6iSFuNkDRKNh9obn4G7HoncnUW8OcG0NPlO4shFkEKkee5upPSkeKJAgo0IA/5y1x01oFNk9a3npCmnFRxHVCDChhWtWE0k3d+EKDFaDS10i/WdR5kddfoZHilPwUMLtnAxLlyO5a2Ym7K3MU5q+OeWx+ATc7EojpYEfyjrP56wmTdpukjLAh8Yob3qC4z5Fc1yaKa6EEeYEuhtSrFqn5nE6aD2ow51pjlCKadbqVX/Vs2qfO6XTf+8PQjSNDEv/0p+1ykQzr+9dMh2k/Px5MVNwcPCPQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J8NXtjoDoCNo1sSJ8gLaoXzBVj8JYIXViWEbzOvLKjw=;
 b=QF3FmjJEW9IZR2gJ0idESz2uNUKsXdfrvfz9KixLY8Vo28Ce4GnNUuZbBJyJ4dLOABxqz8n6+LEpOT4B7Ns3gDF2bdOGLjl6785Ut0RVbmqXvB2kbbMt+qiY3h02MSlda/FSGOh9fVC6roDnzS1bzit/e8ZW5M0oDTXDgFbx7Dg=
Received: from MW3PR11MB4522.namprd11.prod.outlook.com (2603:10b6:303:2d::8)
 by MWHPR11MB1294.namprd11.prod.outlook.com (2603:10b6:300:2a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21; Fri, 26 Jun
 2020 17:51:34 +0000
Received: from MW3PR11MB4522.namprd11.prod.outlook.com
 ([fe80::4021:b214:94b3:3c50]) by MW3PR11MB4522.namprd11.prod.outlook.com
 ([fe80::4021:b214:94b3:3c50%6]) with mapi id 15.20.3131.023; Fri, 26 Jun 2020
 17:51:34 +0000
From:   "Brady, Alan" <alan.brady@intel.com>
To:     Joe Perches <joe@perches.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "Michael, Alice" <alice.michael@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Burra, Phani R" <phani.r.burra@intel.com>,
        "Hay, Joshua A" <joshua.a.hay@intel.com>,
        "Chittim, Madhu" <madhu.chittim@intel.com>,
        "Linga, Pavan Kumar" <pavan.kumar.linga@intel.com>,
        "Skidmore, Donald C" <donald.c.skidmore@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Subject: RE: [net-next v3 07/15] iecm: Implement virtchnl commands
Thread-Topic: [net-next v3 07/15] iecm: Implement virtchnl commands
Thread-Index: AQHWS16Xb+2hctpgK0mcIg1ypDYPRqjqNr+AgAD2zKA=
Date:   Fri, 26 Jun 2020 17:51:34 +0000
Message-ID: <MW3PR11MB4522C47BA782EA0DDFB6399E8F930@MW3PR11MB4522.namprd11.prod.outlook.com>
References: <20200626020737.775377-1-jeffrey.t.kirsher@intel.com>
         <20200626020737.775377-8-jeffrey.t.kirsher@intel.com>
 <de3e14d355f42ed2322483bc1a3448ace46fd6fb.camel@perches.com>
In-Reply-To: <de3e14d355f42ed2322483bc1a3448ace46fd6fb.camel@perches.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.2.0.6
authentication-results: perches.com; dkim=none (message not signed)
 header.d=none;perches.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [174.127.217.60]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7a7c1e08-c193-4c88-0b16-08d819f99102
x-ms-traffictypediagnostic: MWHPR11MB1294:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB1294A462E3BCE97DC0BCD5148F930@MWHPR11MB1294.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1824;
x-forefront-prvs: 0446F0FCE1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: E7/UhU8zN4GRAzZXJHOf5bGBGNpZtScPuEae2izIaxc+kGNi67CSRM9BQDOjMwQB3JL96iB6EsYUryBagZ91DlvUeO2iqYmrhXWRbOmEfbBJVQWwhssMXzDZzGzhXgr2K+OGzIg7Ld8i/lGAl++ruWcfvrXAyOFFfgekYq/cNEg4rEbjvRTl2T2KECtMj6fLLm+o4GtimdSn8z8S3V4C6buNSByQ9vej+owh8Bz595+5NiU4KReIagGh9QyTn1VID9JKOFcPzZAMp7E4mrNr1wvTjXPVCPb0Y6UXFl3FBNkaxg52ut4UoU3gUJorljzN
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(366004)(376002)(346002)(136003)(396003)(52536014)(6506007)(53546011)(107886003)(316002)(4326008)(26005)(71200400001)(54906003)(110136005)(478600001)(2906002)(7696005)(186003)(83380400001)(55016002)(9686003)(33656002)(86362001)(66446008)(64756008)(76116006)(8936002)(66556008)(5660300002)(8676002)(66946007)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: GThOSBVrSb01/Ix7G9bqOEfaKa4tOZKlyKy4Y8iUZMtkVvtbhRF0jz8WrG3v57J/BBbqGWqy+abMHhlsjG/wqqJPzRl0tnrY71JCxPbzZxm6Fo7fVqZGmt7Fn7ivbxkcAlLSmjDFHOlbPvahmmxef6SQ3O/UoNDt+di/c/A4E5DXb8sNENBA3304eoOxK5jCHt0/yslxKNPPdhfD/oEEHiqGnow7nELn8UfCDWU5dxfzfG2cpSfXLDaJN8kCjizFdeXkE+Utz4dv2eHWj20xcmHaBybXsLsP5Ln8GDupYY1qUesWGMz9ruUAj/26oUBrhOxsTLcpXVuO69xPxyHY6vrcOsvBGuIwA3R+Pnl8rVqGbAqg6RQLThH2Y1YclNdixEyHWiiATxdMo+0uDzb5VYAvd5NFygMgC3O0zux2dBEMjTG8CAzV7TAodZqF5GZCq7CGWzv7cIeBW88HljkpVpWp9EnV8bBO6Ota809aXA/r1/zyT5vt3VLD3cnpxXKs
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a7c1e08-c193-4c88-0b16-08d819f99102
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2020 17:51:34.1046
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2lO7nS2DgSd6GZL6RnxRy5WlCld0hNoLsKPsj28w9UkOiUcNVPSG8KiURpHYkW/F/+0aOkr1Q/2MfT3m/7DkYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1294
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Joe Perches <joe@perches.com>
> Sent: Thursday, June 25, 2020 8:06 PM
> To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>; davem@davemloft.net
> Cc: Michael, Alice <alice.michael@intel.com>; netdev@vger.kernel.org;
> nhorman@redhat.com; sassmann@redhat.com; Brady, Alan
> <alan.brady@intel.com>; Burra, Phani R <phani.r.burra@intel.com>; Hay,
> Joshua A <joshua.a.hay@intel.com>; Chittim, Madhu
> <madhu.chittim@intel.com>; Linga, Pavan Kumar
> <pavan.kumar.linga@intel.com>; Skidmore, Donald C
> <donald.c.skidmore@intel.com>; Brandeburg, Jesse
> <jesse.brandeburg@intel.com>; Samudrala, Sridhar
> <sridhar.samudrala@intel.com>
> Subject: Re: [net-next v3 07/15] iecm: Implement virtchnl commands
>=20
> On Thu, 2020-06-25 at 19:07 -0700, Jeff Kirsher wrote:
> > From: Alice Michael <alice.michael@intel.com>
> >
> > Implement various virtchnl commands that enable communication with
> > hardware.
> []
> > diff --git a/drivers/net/ethernet/intel/iecm/iecm_virtchnl.c
> > b/drivers/net/ethernet/intel/iecm/iecm_virtchnl.c
> []
> > @@ -751,7 +1422,44 @@ iecm_send_add_queues_msg(struct iecm_vport
> > *vport, u16 num_tx_q,  enum iecm_status
> > iecm_send_get_stats_msg(struct iecm_vport *vport)  {
> > -	/* stub */
> > +	struct iecm_adapter *adapter =3D vport->adapter;
> > +	struct virtchnl_queue_select vqs;
> > +	enum iecm_status err;
> > +
> > +	/* Don't send get_stats message if one is pending or the
> > +	 * link is down
> > +	 */
> > +	if (test_bit(IECM_VC_GET_STATS, adapter->vc_state) ||
> > +	    adapter->state <=3D __IECM_DOWN)
> > +		return 0;
> > +
> > +	vqs.vsi_id =3D vport->vport_id;
> > +
> > +	err =3D iecm_send_mb_msg(adapter, VIRTCHNL_OP_GET_STATS,
> > +			       sizeof(vqs), (u8 *)&vqs);
>=20
> rather clearer to just test and return err
>=20
> 	if (err)
> 		return err;

Agreed, will fix.

> > +
> > +	if (!err)
> > +		err =3D iecm_wait_for_event(adapter, IECM_VC_GET_STATS,
> > +					  IECM_VC_GET_STATS_ERR);
>=20
> unindent and add
>=20
> 	if (err)
> 		return err;
>=20
> so all the below is also unindented.
> It might also be clearer to use another temporary for vport->netstats
>=20

Agreed will fix indent and add temp var.

> > +
> > +	if (!err) {
> > +		struct virtchnl_eth_stats *stats =3D
> > +			(struct virtchnl_eth_stats *)adapter->vc_msg;
> > +		vport->netstats.rx_packets =3D stats->rx_unicast +
> > +						 stats->rx_multicast +
> > +						 stats->rx_broadcast;
> > +		vport->netstats.tx_packets =3D stats->tx_unicast +
> > +						 stats->tx_multicast +
> > +						 stats->tx_broadcast;
> > +		vport->netstats.rx_bytes =3D stats->rx_bytes;
> > +		vport->netstats.tx_bytes =3D stats->tx_bytes;
> > +		vport->netstats.tx_errors =3D stats->tx_errors;
> > +		vport->netstats.rx_dropped =3D stats->rx_discards;
> > +		vport->netstats.tx_dropped =3D stats->tx_discards;
> > +		mutex_unlock(&adapter->vc_msg_lock);
> > +	}
> > +
> > +	return err;
> >  }
>=20
> []
>=20
> > @@ -801,7 +1670,24 @@ iecm_send_get_set_rss_key_msg(struct iecm_vport
> *vport, bool get)
> >   */
> >  enum iecm_status iecm_send_get_rx_ptype_msg(struct iecm_vport *vport)
> > {
> > -	/* stub */
> > +	struct iecm_rx_ptype_decoded *rx_ptype_lkup =3D vport->rx_ptype_lkup;
> > +	int ptype_list[IECM_RX_SUPP_PTYPE] =3D { 0, 1, 11, 12, 22, 23, 24, 25=
, 26,
> > +					      27, 28, 88, 89, 90, 91, 92, 93,
> > +					      94 };
>=20
> static const?

Will fix.

Alan
