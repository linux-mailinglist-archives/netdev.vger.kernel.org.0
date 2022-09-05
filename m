Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CC195AD9A8
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 21:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232296AbiIETcu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 15:32:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbiIETcs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 15:32:48 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDD6F19287
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 12:32:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662406367; x=1693942367;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZVdIv4wwmmAmXMaFVNG/nhGVbmbBrrBhNTCoho1XyQY=;
  b=O91eLSWO7Mv1tkUTppG6b+Qe9Hg4f5QwLkBMC9olA5uODkV0qRiHJfw1
   PdO0RuB2dZyUHif/o2pPlFkuU8YpZB6eOsUyu37Ehw+X3w+/giIhX579s
   fp/6aHKGiGihJd87rVbyycGm7ZN7XjYocLr+1RwRIlPa3ubj3SmgyhHpq
   jS4fQgZMwT7anm0DWwxKdUxOYk6KTIemcdC88FyTIRoLeDyop+W+xFrUF
   7k5SYTiImSOjlMAbw7jKzwM1+AOq8/ozXCffXLY5mxZU3HiFdvOvZ7gUj
   bMlTZ8se303zzohCYtSUlYLy1p19lqHhtlAYhsYdy8ewDYlnzhBB5O/hv
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10461"; a="279459260"
X-IronPort-AV: E=Sophos;i="5.93,292,1654585200"; 
   d="scan'208";a="279459260"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2022 12:32:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,292,1654585200"; 
   d="scan'208";a="591011152"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga006.jf.intel.com with ESMTP; 05 Sep 2022 12:32:47 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 5 Sep 2022 12:32:46 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 5 Sep 2022 12:32:46 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.175)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 5 Sep 2022 12:32:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OZm+cDmGcV5X5aZhmL+UFg7lRlSTDmhUljupSF0cPJfF06vx6g4ZvPuQU6B0kuiBzU88YpaN5Pkj3aC+ANU2obuHKQQIbio9Tbdh/aHJQXvLVxXaf1TUl4M+6og2TZv+3QWR+pk3E/HyojoaZWOg1Pjm1trzCcHYrXf9C+x4jhVq1w3AS9PaGk8mhdgZwpdTgweRW16+CSnTjI/wR0cDKI+0UjKnxwLYJUvjHoWgnlaX9geoRzKfYj5K2ewD65DxdPZUOTHwX02Or7WmWCfG6Q56LU82ykj0GW74+GVyoP5/V5ETD4CVvTWlGSeIfK5drSayH1C1c0657cUQUbC4GA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EHRTnDi/8rD1J+Y9U/8F9xeEFNDwi+4D1RaiWaO18Fg=;
 b=kXaEQ6XkdS9O75dBpINrxocpdjyCTxltq0bNf99KreMc1meCCd8zIQ7mfkS7lWPlzSSxaLecXZrjY0OSIidPCoNbvd63+3XUWKx0aaPCtogai4fIjvnHrivmsu3IQrcd1e5kJ1zyv+j2eNc3PyquCgsvB0gWVUbJgvWPjUx4DUs3c4utAmg6We7uPNbmJy7u3tl+GUaEvCgfiL09rqFLNKaJ32BhFJdy2WZ/mnygKcVHhBMTtTakkKHnchUDIsF0F6LEqR/G5d1EKDblgz5EN4eOldD80nvDBJwZEzDeY7uExyxY79MwXYuK0L1dmUFrvncWKBEOgk6CANUNP9wj6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN6PR11MB4177.namprd11.prod.outlook.com (2603:10b6:405:83::31)
 by BL3PR11MB6434.namprd11.prod.outlook.com (2603:10b6:208:3ba::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Mon, 5 Sep
 2022 19:32:44 +0000
Received: from BN6PR11MB4177.namprd11.prod.outlook.com
 ([fe80::40b5:32b6:ab73:3b8b]) by BN6PR11MB4177.namprd11.prod.outlook.com
 ([fe80::40b5:32b6:ab73:3b8b%7]) with mapi id 15.20.5588.015; Mon, 5 Sep 2022
 19:32:44 +0000
From:   "Michalik, Michal" <michal.michalik@intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "G, GurucharanX" <gurucharanx.g@intel.com>,
        "Jiri Slaby" <jirislaby@kernel.org>,
        Johan Hovold <johan@kernel.org>
Subject: RE: [PATCH net 3/3] ice: Add set_termios tty operations handle to
 GNSS
Thread-Topic: [PATCH net 3/3] ice: Add set_termios tty operations handle to
 GNSS
Thread-Index: AQHYu/L55I/9qMiXWE+dtrk9hjKUpa3JkKOAgACDzYCABy4K0A==
Date:   Mon, 5 Sep 2022 19:32:44 +0000
Message-ID: <BN6PR11MB417756CED7AE9DF7C3FA88DCE37F9@BN6PR11MB4177.namprd11.prod.outlook.com>
References: <20220829220049.333434-1-anthony.l.nguyen@intel.com>
 <20220829220049.333434-4-anthony.l.nguyen@intel.com>
 <20220831145439.2f268c34@kernel.org> <YxBHL6YzF2dAWf3q@kroah.com>
In-Reply-To: <YxBHL6YzF2dAWf3q@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.500.17
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b2479798-09fd-4394-aa68-08da8f75682d
x-ms-traffictypediagnostic: BL3PR11MB6434:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 97dFy/u97UEEQJ/BtdTfaueTUDcU+Awxftr21MZpFLr5UD6nUpVIw20XwzUT+FBuqqHJLzbLrgnwPE7rWzFqOqTJ1QTPbxK3CyKHPlRSM+KCoP1/UMNl1Jiun/JXxo3SKePMDWVUg5gKIIARNiqo4oNpLwTHEsshGG+0P3S3oymPxbY7+3WfAxCGidaqPV/DQikJNpvW+1jJjvH7lytsr2kwMpKS4KIhkpWIfpydTqXqkr7gGO6R7j5wkDgVvGSR9xWG0w7dN2J+WNawFZN+E8347TtVKJ2ID84gDEf4Q+csrnBm+RbKgwZUY62T/0+hp/gTF3k78aIqXxj0FG25pWZ/kQGZHt57jEkTNy86qO/xrLdZC6nC/4lfWRMkmQylbywJmE7zTY5dyf4R4sbtSI2A0Tmb+CRvdviNnK+Z+hCEyKrJ8C9O/Y6bpngT48cvfMbyq+vwni0wOMUjIX4UE9DfsWWoQ1k+obixo5waFclHjxIDXLsdP1n86FmlhJF5ujXlPpaf0LKDYDW61/4mOq1MHMW2qNUFWC9Gg0F44ZrTpgVTBrseXmOr2gQIZYdjMTS3ZXUCI1Dzb3aqUEMyDJXWeuLXVDWmXoeuXpl9EURYXFEZ7JUOmBnmJ9BZevh5ctu1hl7wXQfVG1xPnJzLTSPx7vcWS/nUb3Lxp9LsesGLs5FZRNJ0i4hhLtf+MgKKwwVEE3ATT62U7wlSN5XHFiPhoWsr5gK0cZTnY8qCqKohdnvTtzAJLqd4BYy9W6OWCUNOUjVgnr4Yy5lh5dtv7g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB4177.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(39860400002)(136003)(396003)(346002)(376002)(66556008)(66446008)(86362001)(66476007)(122000001)(7696005)(38070700005)(8676002)(8936002)(76116006)(26005)(52536014)(64756008)(4326008)(53546011)(316002)(71200400001)(6506007)(110136005)(55016003)(478600001)(82960400001)(38100700002)(54906003)(41300700001)(186003)(2906002)(66946007)(9686003)(83380400001)(5660300002)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?pPolGU01kqV3roubyb3zL1GDgniDInfHoe83UzMJ6k4w3ucDFEuFqPCbY7z5?=
 =?us-ascii?Q?2/fZTo0SQPKsvd2eQ3tfFK7vW5Q6XUJxYMUREIA58PRpfxHhD6d3znoYfG7q?=
 =?us-ascii?Q?AZEFQxYKBmYEn2HvriBf3q1VcEUrNaLSuBWP6N6TnK1UHtgOonEb3XZV33aV?=
 =?us-ascii?Q?YePLLEaXEBly3v5193Vlj1YnweJSeJWyj6cyM78YTZ4Q1F1DVQL9++bjloWV?=
 =?us-ascii?Q?87hZ6yPKHqXKnadfDRjXG4b0esLV6a6+iulLpd0WC0R6uq0+vQmbE8hUGkg7?=
 =?us-ascii?Q?o3p4L7z+/oYePxub+CbDLs6jtvCV83klVQips64l3rOjmq2B7yLl5p9iz+LO?=
 =?us-ascii?Q?g/unBm/zk0esThBXgBNrhT8Na32WaHqqxfeWRehgOD79AGsPS4+NdYwTufDR?=
 =?us-ascii?Q?J8XZ5MO0vCStdt/vFKeVlVYK1o7bnl1/ds9vfRSFkobtHpPbkCUovpDK1ZRA?=
 =?us-ascii?Q?PMLmRA7jiy6Wy9fSc3/cFlELKZ3urM1htS9nX3gzwKIHIaUEh6gQk0SD29CH?=
 =?us-ascii?Q?dFN4DfRkXkgAzoVqYkkS6lIhlTvyObO8T+j19OWjzaAnNfUef1Y60wQvN/xr?=
 =?us-ascii?Q?wsS2Yi02ZaSvS12c3hbuS6LR5aTRRUCdrJPxQOMApN72Ny1UJyylQx/B2fpG?=
 =?us-ascii?Q?T2GDw7W2HPQaIndj7z6BFn67KvbJLKsnfMzWNGQ38Quv5C+sY60AJK6a4/zm?=
 =?us-ascii?Q?ML7dIaMUHz4EwdeCym++CHIITGRrAkyfYAy9aI3pBcOcYrrvhIr5y9jwazQF?=
 =?us-ascii?Q?qtFuKXxjov0rEpbmPtSazRpDbS4MdEGFvCMoQ1cn2/NqC+1qqV0bMU3qmMzW?=
 =?us-ascii?Q?4YqojW1cKG2noYP0YpZwqIdoVAlEceiR3gGCiEDybPTXOjccZBh8VL4mwmJs?=
 =?us-ascii?Q?M0uaMqcx2nKDneBY5B8rtdmrEUR8bdkSIvPbzqBe+xwJfRzUSFA9bXqjIWmC?=
 =?us-ascii?Q?ZXTR7JufeL3LOt61sOoLTZFP85Qi+5pwoIpSahN0jH9L4/A4Yu7Fei3F0Zuq?=
 =?us-ascii?Q?8m+LK/lckewrNbYqWOHibvr62xpurvlbSsCHBxofFZGKFVzPcf49aC13iqPN?=
 =?us-ascii?Q?/l8JEnfccdYh880Hz5cUSsk5amlFSAe99eJ6kMFOr6l9+ABVczI1vaknN+5i?=
 =?us-ascii?Q?FqAq+9HJ7DwXioUR4zsE2lQQs830Ftiprme4CD/66qfp4XzqaAFgIXPtFe7s?=
 =?us-ascii?Q?axvhPgBJHf57mZOc7RZ/L4q8vwfl/xvz61f5zbIigfU6eaIDxvMIRAsgfsBY?=
 =?us-ascii?Q?fO0LCzIfFxiOE9/6SiGiwrH1RiOvn9NdA/gN3hYZwctli15fxNINJBKw/luM?=
 =?us-ascii?Q?HMh7P4jPYhqlFhqIt6riWW0gx6CWcJF8rOi6PuHiGbo6zXiwEOaqp9yNXD+A?=
 =?us-ascii?Q?reto4AGXn5WgTtNnQgp+gsf2oP8XX95YizEpj7AM2mQBVcJAz7zHUDbDdZi2?=
 =?us-ascii?Q?V4K4PbDypBpu4Jwa4MWo0sS1Q4a4NQ+VRsxGnKlAbOAvFS4gwUWUUg0dwY9D?=
 =?us-ascii?Q?1JyosjFb1eH3dqdvIgvldfLvo2c9iDRnB/8bM0PnnlTxToeV0pZopFJ2aUWG?=
 =?us-ascii?Q?1dZdd+wJvnFxsUCkqyBMzGDMK5trk/B0JbjAV+z2Ll2q60F+sofanjmaUgbi?=
 =?us-ascii?Q?eQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB4177.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2479798-09fd-4394-aa68-08da8f75682d
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Sep 2022 19:32:44.7646
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: A7lSqYyTl0U6yICXncyA6qELaF3QQdSxf6DNSXOETevNL/lZkfDNJc/5HBE1IEwHFm/tdf3b0ZSRFRgajq1FvyHDWUilKlCqjy8RwdnbNBs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6434
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

Hello Greg,

Much thanks for a feedback. Please excuse me for delayed answer, we tried t=
o collect all
the required information before returning to you - but we are still working=
 on it.

Best regards,
M^2

>=20
> -----Original Message-----
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>=20
> Sent: Thursday, September 1, 2022 7:46 AM
> To: Jakub Kicinski <kuba@kernel.org>
> Cc: Nguyen, Anthony L <anthony.l.nguyen@intel.com>; davem@davemloft.net; =
pabeni@redhat.com; edumazet@google.com; Michalik, Michal <michal.michalik@i=
ntel.com>; netdev@vger.kernel.org; richardcochran@gmail.com; G, GurucharanX=
 <gurucharanx.g@intel.com>; Jiri Slaby <jirislaby@kernel.org>; Johan Hovold=
 <johan@kernel.org>
> Subject: Re: [PATCH net 3/3] ice: Add set_termios tty operations handle t=
o GNSS
>=20
> On Wed, Aug 31, 2022 at 02:54:39PM -0700, Jakub Kicinski wrote:
> > On Mon, 29 Aug 2022 15:00:49 -0700 Tony Nguyen wrote:
> > > From: Michal Michalik <michal.michalik@intel.com>
> > >=20
> > > Some third party tools (ex. ubxtool) try to change GNSS TTY parameter=
s
> > > (ex. speed). While being optional implementation, without set_termios
> > > handle this operation fails and prevents those third party tools from
> > > working.
>=20
> What tools are "blocked" by this?  And what is the problem they have
> with just the default happening here?  You are now doing nothing, while
> if you do not have the callback, at least a basic "yes, we accepted
> these values" happens which was intended for userspace to not know that
> there was a problem here.
>=20

As I stated in the commit message, the example tool is ubxtool - while tryi=
ng to
connect to the GPS module the error appreared:
Traceback (most recent call last):

	  File "/usr/local/bin/ubxtool", line 378, in <module>
		io_handle =3D gps.gps_io(
	  File "/usr/local/lib/python3.9/site-packages/gps/gps.py", line 309, in _=
_init__
		self.ser =3D Serial.Serial(
	  File "/usr/local/lib/python3.9/site-packages/serial/serialutil.py", line=
 244, in __init__
		self.open()
	  File "/usr/local/lib/python3.9/site-packages/serial/serialposix.py", lin=
e 332, in open
		self._reconfigure_port(force_update=3DTrue)
	  File "/usr/local/lib/python3.9/site-packages/serial/serialposix.py", lin=
e 517, in _reconfigure_port
		termios.tcsetattr(
	termios.error: (22, 'Invalid argument')
=09
Adding this empty function solved the problem.

> > TTY interface in ice driver is virtual and doesn't need any change
> > > on set_termios, so is left empty. Add this mock to support all Linux =
TTY
> > > APIs.
>=20
> "mock"?

Please excuse me if I used the wrong terminology. What I meant by "mock" wa=
s
this empty function, which did nothing but satisfied API requirements.

>=20
> > >=20
> > > Fixes: 43113ff73453 ("ice: add TTY for GNSS module for E810T device")
> > > Signed-off-by: Michal Michalik <michal.michalik@intel.com>
> > > Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker =
at Intel)
> > > Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> >=20
> > Please CC GNSS and TTY maintainers on the patches relating to=20
> > the TTY/GNSS channel going forward.
> >=20
> > CC: Greg, Jiri, Johan
> >=20
> > We'll pull in a day or two if there are no objections.
>=20
> Please see above, I'd like to know what is really failing here and why
> as forcing drivers to have "empty" functions like this is not good and
> never the goal.

If I should elaborate more on the reproduction, please leave me a note.

>=20
> thanks,
>=20
> greg k-h
>
