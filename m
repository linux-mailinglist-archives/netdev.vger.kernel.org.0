Return-Path: <netdev+bounces-4631-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C011970DA02
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 12:09:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 48E9C1C20D3D
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 10:09:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A6F51EA60;
	Tue, 23 May 2023 10:09:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB3201E501
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 10:09:13 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08ABFFD
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 03:09:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684836551; x=1716372551;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=mXI0n7DZZo9gKpFxtYLmj+pEtd6CldvxnqDgWBDIa68=;
  b=jPlNWQqfR7m9McqPjb3dYpSLFwQUryAMK/VQYcrfISBfgixRv7L58e1f
   KiHKVgZUIfl0503zCzK0QKZbIq4AMjcRZd+4Yr7HZblaPUriq3tl18LCy
   32T8ZagL6jtRrDqOmmJRkMgweapkzSRYMXIsj33W5Q0L4O2q7snY+dPeG
   +GL7TeFvU2Lx5Wq5blVsNeVdaXovqVmdNakUVicNv02qDEyvoVsrRdYYO
   qsURETDUdZPdviylaeueBkROA3CoKFHQl86H91cyulm9GFblDbIHWNLRR
   fccvuEP/Fl9bbaMvK6Y6e1OjN9DdYu04Dx+BEJ5mw8vHYGUhxtPUAqjur
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="381437225"
X-IronPort-AV: E=Sophos;i="6.00,185,1681196400"; 
   d="scan'208";a="381437225"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2023 03:09:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="768947176"
X-IronPort-AV: E=Sophos;i="6.00,185,1681196400"; 
   d="scan'208";a="768947176"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga008.fm.intel.com with ESMTP; 23 May 2023 03:09:08 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 23 May 2023 03:09:08 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 23 May 2023 03:09:08 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.102)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 23 May 2023 03:09:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PdJyO5BsbKeacBp3PK/5Gg2pzPrtQl5YjWRz6GTeTNhAFwzj3W6zM6dsvfgysPgNN8AcuLxVjxQFOrxg0W60ZzZ5iX0Qu1Yhr0eqxdPvcpTBUJGkVRbt4fbe/84MqVt2w/s9H67sYZ9EMto+R+zMqt2i5A9UPUh6+wRifxkRUFlZjndAIo7QlIUEndgZVi0NP6pKRAlEYP00X/jc096S1xoLVRpZLR37pkU+/2rTAeY1p6NYnKfL3JLm6+f6zK5sIwHLoIpSLlG/mzUOFilX/d808RtqRT2h9R8rZhe8POSmlVRYOssPxGKEjqkhxgcWphgpdErVRb7dEKAJSoSfOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wvVcW3XKzknmrKCqxbA4J8T0UspVm5AMnAKpibEiSpA=;
 b=UK5YZd3LoW6wfov2Koo8tA20HUmCH6r3sS6fpP2Cmxy6UPdo7WZpm2A6Yu7Q9B/QIOeAiNpRyAoD+FwQx5+9eXseA0wli8buxIqkGBLAezIXtfgAM5yVxQpCcCR+GAupNEJ7fGpAcgFfIKEqZ1IJfI2XZO2pQfTYbVNW+rsqoy+evQa0M1J9zmCozEXLFdwCZ9QAWc24W1bWyeYK25U6+MWXfNlb1q8D2vtg8Oys9JvaDzenFkCwOlsqqWCayo3uqzridDB2BSPMr1JpR8eCZME4uC4v8JG74jXh8/WCEOEoAE9Ic25nmQqMoFCiBfcwV4Snqu+m2LEb3CLCnObV5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB5776.namprd11.prod.outlook.com (2603:10b6:303:183::9)
 by BL1PR11MB5287.namprd11.prod.outlook.com (2603:10b6:208:31b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.29; Tue, 23 May
 2023 10:09:06 +0000
Received: from MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::936d:24c4:86d0:f2a0]) by MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::936d:24c4:86d0:f2a0%7]) with mapi id 15.20.6411.028; Tue, 23 May 2023
 10:09:06 +0000
From: "Drewek, Wojciech" <wojciech.drewek@intel.com>
To: Simon Horman <simon.horman@corigine.com>
CC: "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, "Lobakin, Aleksander"
	<aleksander.lobakin@intel.com>, "Ertman, David M" <david.m.ertman@intel.com>,
	"michal.swiatkowski@linux.intel.com" <michal.swiatkowski@linux.intel.com>,
	"marcin.szycik@linux.intel.com" <marcin.szycik@linux.intel.com>,
	"Chmielewski, Pawel" <pawel.chmielewski@intel.com>, "Samudrala, Sridhar"
	<sridhar.samudrala@intel.com>, Dan Carpenter <dan.carpenter@linaro.org>
Subject: RE: [PATCH iwl-next v3 03/10] ice: Implement basic eswitch bridge
 setup
Thread-Topic: [PATCH iwl-next v3 03/10] ice: Implement basic eswitch bridge
 setup
Thread-Index: AQHZjJ/O3Pefledqc0ihupcB1dp0gK9nokiQ
Date: Tue, 23 May 2023 10:09:06 +0000
Message-ID: <MW4PR11MB5776FA062B557DDA67402D4CFD409@MW4PR11MB5776.namprd11.prod.outlook.com>
References: <20230522090542.45679-1-wojciech.drewek@intel.com>
 <20230522090542.45679-4-wojciech.drewek@intel.com>
 <ZGtQffLjYdt14Lpg@corigine.com>
In-Reply-To: <ZGtQffLjYdt14Lpg@corigine.com>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB5776:EE_|BL1PR11MB5287:EE_
x-ms-office365-filtering-correlation-id: a0485fc4-058e-467c-54d2-08db5b75be1c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0WCzOQIDowQoFz3dodvAmZY09SuWuitxoX9sar43bkB4wxO3mFpEOCxsKOUxve+kRdArRlG37PbjQSbKquFvnnBdD7ZxeYvb7hyD8NXjjhep4pxxxJ6DAw1jSniaT+M8T/OxQFMJ19APuV3cS9DvTyMJJ+KPVRmOgLETZVvQ/slH0EfVfBTG79YEDtioe9F+NoJIyOdUR2O31tcVoqCGQIUzIXmfSsUX5DDmWWjL1aqSGiXHthhueoZD/NDvhSPAWV+4FiEp8PcRXRy/QQOCQkApn82w46ptYZ5fbcYCI0Of0LKOxvNey61TUU65S/MQTS74g6F1/VQjN74Kh4VGQFECqMKp5YYA7XEDDxBbTYkuH5bUutkBkDRkcaKwWbtRVR2VZ3y5xcnOx7LmR1pEQ/e33yaTKzMSzhA349hin6cCv4v+19QQpYd8390XyRkiPOMggis3A/52nGxZXmQ9vN1419ImFKyAaXebsjjhnpjIb6RxoJueutaCu9Da4PoIrU5KxkfbRBH4S5E08Gqv4fCkX7lTtbINatLE0xWONElIBobSwWdz5HVDqpoFsIkStOO8SGxCp0OunzQAsaw7cxoAGw+1mzThwIx9ZxnCmfOjfHPDuHPs+u45xFfjh8n2
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5776.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(346002)(136003)(376002)(396003)(451199021)(186003)(82960400001)(53546011)(122000001)(33656002)(6506007)(26005)(9686003)(38100700002)(66574015)(83380400001)(2906002)(55016003)(54906003)(7696005)(71200400001)(316002)(41300700001)(478600001)(86362001)(6916009)(4326008)(64756008)(66946007)(66556008)(66476007)(66446008)(76116006)(38070700005)(8936002)(8676002)(52536014)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-2?Q?KBgCFtDIFTfQIkyfXR44LZJmSamjvsv7Q5qt+8rswbDMLe9c1SW0vnhzjP?=
 =?iso-8859-2?Q?jxoFle3d/jmQbXZT53d8qh/DmNTmLbERTzwJPM/xHsyTXhUahCLiPLMLQn?=
 =?iso-8859-2?Q?M/HeskU0j+LarXlBLtLCb2MzUqJGYdnGolAGcSoI7lTkOEU7654g/lFUZR?=
 =?iso-8859-2?Q?tQDAVKIvdeQ0OwGxBnkabTsgnwUcXNt4/XctF0V+bCnkKHwFFI8CeQFCOF?=
 =?iso-8859-2?Q?eOj/yiHxBRsZLYdTRWdOMkSP+Citu125+W5gj2JE2cfPRfUQYxcZb2OzSq?=
 =?iso-8859-2?Q?FNsakGhvVyjlz6Kd7iECYuhSXBGuq1ZU1Maj4zSB144EqViDdrqohfFAgO?=
 =?iso-8859-2?Q?xg2v98NVZn/OJgQoJfHdlfT198lvEOfwbuQ/LJiK4hFXVAL8KWFH3aeFzP?=
 =?iso-8859-2?Q?F1qM4JSYszLGV48BhExUFDoJIQ7BUPPU7wo4wCUNFvOeZWkXUV+P/2OAzC?=
 =?iso-8859-2?Q?Dkz+bOyviQBXkgTNYgfXsZLtSd/Wz2XGHpDVC5lwse1JZ2DLHCx8lEc7Gd?=
 =?iso-8859-2?Q?9RuvjnFZsouGkzR2PM4Yz04RIwPUuUrV7ONAPt7OkNELsumu86H/rhG4Mu?=
 =?iso-8859-2?Q?NVWEIj1QhPR+grUZnB0X7juanDbnrpsAmHOX8uUg7S9rwOFgHm7YWBI0vt?=
 =?iso-8859-2?Q?APmvzimd98Q8wnQ1uxeV8ajCHDnJEaS7/9vBb9guAvirl5CfNjyfooQjWq?=
 =?iso-8859-2?Q?aJpVunz33thxSYeyybcJgALqS3leXB27KCZoJ+3fyJHnpOYyUk1I0xOAqY?=
 =?iso-8859-2?Q?7nuIa8RM61MTLsa7I3zndDraFzHB8mqkVGf2S8FVp3vBlUPScQ6z4iQct8?=
 =?iso-8859-2?Q?kmKcohgz+nK7R1k9a31NrWcPzT1Gc7QXEKPxANCzyvk0bm8s+de3x0ujXR?=
 =?iso-8859-2?Q?fg5Ts/BQTBLRGdBxhJBloPQzGqdBgyr6kRUTmtkD7IeN30OuvJzaDyeen9?=
 =?iso-8859-2?Q?SuQnd9CJqrY+faRgK00dzxMV3kbM1MF2mJ86Nwc6Lrn54yfS7FR+Usl6cO?=
 =?iso-8859-2?Q?TaB4k0Bx4P8BWWhriTwy9C2TRalaFZaRV5pWGdrM5KfApxJ157rZkWaM95?=
 =?iso-8859-2?Q?Fp4aqfmTM/+gNhIcL0/t9Jqy4cJcjITmBjSrTU57zMUAQDCqXQi6X4qQIn?=
 =?iso-8859-2?Q?DdBjdk5QJwWwQ2ifZiCaxhWU6KvKfyzAd69qAQkeaz2Ht3aLPVkJwJZKDm?=
 =?iso-8859-2?Q?MMcwmiqUiVjGmfARWnai5hzPLHZkSF+pAQAx8HO+dk/9Y2h9R4cGC7ZfoB?=
 =?iso-8859-2?Q?Hh0p3SU5Mr9mvuFU+68iNP+dAOup2pRNV6PT/m7x3U1DHymQo1S82IXavj?=
 =?iso-8859-2?Q?sFmNsi5jd5Br+KhyaHCVUECWtLfQRBfNWqngF3JcxBSP58EoAnPfOAgi7w?=
 =?iso-8859-2?Q?dKnhjfNF275oYsp43KRo41st2jPJRtZdc0i5ifwOFbYgEUO5el8hphZSsy?=
 =?iso-8859-2?Q?Zoulk3CoTUCLh2Slzk1JSgogkibamPcOEY3ZQZhlVV094biKucBR4ChNwQ?=
 =?iso-8859-2?Q?p19Xo7i3JCPjVRlD+iEKMrxX7RjDHYMf998TESZzVcs6f28MMZyx60UiHG?=
 =?iso-8859-2?Q?mlcBE/znj/EPQd540pw5fCITJk6tC+O/EVdi+uAAI+HS7Hc+im1U/NKdW5?=
 =?iso-8859-2?Q?/UbnsVynL4LOxv5dgFG3xI3OYl8g3dGB6Z?=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5776.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0485fc4-058e-467c-54d2-08db5b75be1c
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2023 10:09:06.1519
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: u30wfihrtaJORCzfVmcHi7tPgOIW74uZvqNKJQ2vg3p7bW15HqcIVJHcUNqDj0scsIJJ7YCqqpak9dL268UJWS11J3nWoCNKdaz1fkfbhjE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5287
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> -----Original Message-----
> From: Simon Horman <simon.horman@corigine.com>
> Sent: poniedzia=B3ek, 22 maja 2023 13:23
> To: Drewek, Wojciech <wojciech.drewek@intel.com>
> Cc: intel-wired-lan@lists.osuosl.org; netdev@vger.kernel.org; Lobakin, Al=
eksander <aleksander.lobakin@intel.com>; Ertman, David M
> <david.m.ertman@intel.com>; michal.swiatkowski@linux.intel.com; marcin.sz=
ycik@linux.intel.com; Chmielewski, Pawel
> <pawel.chmielewski@intel.com>; Samudrala, Sridhar <sridhar.samudrala@inte=
l.com>; Dan Carpenter <dan.carpenter@linaro.org>
> Subject: Re: [PATCH iwl-next v3 03/10] ice: Implement basic eswitch bridg=
e setup
>=20
> +Dan Carpenter
>=20
> On Mon, May 22, 2023 at 11:05:35AM +0200, Wojciech Drewek wrote:
> > With this patch, ice driver is able to track if the port
> > representors or uplink port were added to the linux bridge in
> > switchdev mode. Listen for NETDEV_CHANGEUPPER events in order to
> > detect this. ice_esw_br data structure reflects the linux bridge
> > and stores all the ports of the bridge (ice_esw_br_port) in
> > xarray, it's created when the first port is added to the bridge and
> > freed once the last port is removed. Note that only one bridge is
> > supported per eswitch.
> >
> > Bridge port (ice_esw_br_port) can be either a VF port representor
> > port or uplink port (ice_esw_br_port_type). In both cases bridge port
> > holds a reference to the VSI, VF's VSI in case of the PR and uplink
> > VSI in case of the uplink. VSI's index is used as an index to the
> > xarray in which ports are stored.
> >
> > Add a check which prevents configuring switchdev mode if uplink is
> > already added to any bridge. This is needed because we need to listen
> > for NETDEV_CHANGEUPPER events to record if the uplink was added to
> > the bridge. Netdevice notifier is registered after eswitch mode
> > is changed top switchdev.
> >
> > Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
>=20
> ...
>=20
> > +static void
> > +ice_eswitch_br_port_deinit(struct ice_esw_br *bridge,
> > +			   struct ice_esw_br_port *br_port)
> > +{
> > +	struct ice_vsi *vsi =3D br_port->vsi;
> > +
> > +	if (br_port->type =3D=3D ICE_ESWITCH_BR_UPLINK_PORT && vsi->back)
> > +		vsi->back->br_port =3D NULL;
> > +	else if (vsi->vf)
> > +		vsi->vf->repr->br_port =3D NULL;
> > +
> > +	xa_erase(&bridge->ports, br_port->vsi_idx);
> > +	kfree(br_port);
> > +}
>=20
> ...
>=20
> > +static int
> > +ice_eswitch_br_port_unlink(struct ice_esw_br_offloads *br_offloads,
> > +			   struct net_device *dev, int ifindex,
> > +			   struct netlink_ext_ack *extack)
> > +{
> > +	struct ice_esw_br_port *br_port =3D ice_eswitch_br_netdev_to_port(dev=
);
> > +
> > +	if (!br_port) {
> > +		NL_SET_ERR_MSG_MOD(extack,
> > +				   "Port representor is not attached to any bridge");
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (br_port->bridge->ifindex !=3D ifindex) {
> > +		NL_SET_ERR_MSG_MOD(extack,
> > +				   "Port representor is attached to another bridge");
> > +		return -EINVAL;
> > +	}
> > +
> > +	ice_eswitch_br_port_deinit(br_port->bridge, br_port);
>=20
> Hi Wojciech,
>=20
> According to Smatch, ice_eswitch_br_port_deinit() will free br_port.
>=20
> > +	ice_eswitch_br_verify_deinit(br_offloads, br_port->bridge);
>=20
> But br_port is dereferenced here.
>=20
> .../ice_eswitch_br.c:207 ice_eswitch_br_port_unlink() error: dereferencin=
g freed memory 'br_port'
>=20
> > +
> > +	return 0;
> > +}

Thanks Simon,
I'll fix that in v4

>=20
> ...
>=20
> --
> pw-bot: cr


