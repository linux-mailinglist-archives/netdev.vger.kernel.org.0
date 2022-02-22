Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44ADD4C0413
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 22:49:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234206AbiBVVuD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 16:50:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230274AbiBVVuC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 16:50:02 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D89EE41FB0
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 13:49:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645566572; x=1677102572;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gus4+4g1Tz2m3RyJxr4p7JDM7QMINDftxCRKMSNCY1c=;
  b=UFPSbWL2z7wTEyePLojLgv0PWd+EdoEZkeKFE3L04zXZ6YoKjv15/lFj
   +8aLYeTUCHJ0mPybx8EY3Cx2a5aKDMsVrYmR/+r0zrkP3Ez5uYNjIX+ww
   zFEz3a9RLj8cCr8TiOYPQ9qYpuEAqkh6BQDoj++7np6scZHJtzvWQpIGa
   4ipV4yNdoozQCwuTA79C1QEB7Jl8UuJnLA/pnPC+z9KH82+NRzhJQgFNl
   F8+x4RlJdWbz7kgDac8Gs+XdCsWMR+hA2gDbVtTvB9NnlaIM3hdzl7U9N
   YVrJbwbt7rMJZy2eNhOujiXn69LDiA3khIGZIND2bMJQBsTIY4eQJvape
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10266"; a="252011055"
X-IronPort-AV: E=Sophos;i="5.88,389,1635231600"; 
   d="scan'208";a="252011055"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2022 13:49:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,389,1635231600"; 
   d="scan'208";a="779705239"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by fmsmga005.fm.intel.com with ESMTP; 22 Feb 2022 13:49:32 -0800
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 22 Feb 2022 13:49:31 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 22 Feb 2022 13:49:31 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21 via Frontend Transport; Tue, 22 Feb 2022 13:49:31 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.170)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Tue, 22 Feb 2022 13:49:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QyJI6uC2vMaPEzXH6L01TQ2d0gqeMm1qlixAHiYZpVl2ZZlL3j/qqpuZ374IRUACJMBEhyKO50KM55Qjv3EsCzFE/KQ4Fi/5bqOD/FtVj3lxBEjlMnTmWqGug9QP+9DKOhy3SnQi1c8+hh+PN80t4/fvvOi6Q2q4yJAXgcWgzPrwlLfO7uZw8D2AonWCqN6PLax/IzSOYYrfH3eQVWuJLjEz7U5SqlPocRfIU9tnscDVJ28VUIGxZuCy5WLlzaKPAFmv8s1Yp/xMU8Ym3jEzZsXOlxHPCXNJ78oTj+Ejn+MHFh+Uoo7UGvKz17gDA1k3HTjUs+u0VUrMGWAqTODt6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ubQctGCrpiV36HBCEYv1C+MBF/T2VNH1zL+lFKFlT1A=;
 b=MbIXdW7W0yokHbWLu5LZ3RfIgCe4XuJ2/vBqmIXRHFgfCXBM1A8LlzfoN0NFvdCt1kNxKnWEg5MFzS0CWvC1A0BqINf3CmImVsw4irfBIfqrVUxjG39jgxccNvJwL7hv70j8Lwf+XaMiVmdVlTsf17OxmrZZQNHDYSr4vNd6GEh1QTLidQNJaS8mekUatogX+brTb9fanXdMkPJLNEUtdLe8fTTGXg32XpT6LzoMTqmRjylxOjR5BhpXA0m2LyUtYB3D+gTAw4nupJoQXHMFADzGLHKJ5+XNvg4uD+Y7p8EyP9NEyCNBjBfZNQqKn8D2F/a9IEZlS6/nh0u/cm2itw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB5776.namprd11.prod.outlook.com (2603:10b6:303:183::9)
 by MN0PR11MB6011.namprd11.prod.outlook.com (2603:10b6:208:372::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.24; Tue, 22 Feb
 2022 21:49:29 +0000
Received: from MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::79bd:61ad:6fb6:b739]) by MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::79bd:61ad:6fb6:b739%5]) with mapi id 15.20.4995.027; Tue, 22 Feb 2022
 21:49:29 +0000
From:   "Drewek, Wojciech" <wojciech.drewek@intel.com>
To:     Harald Welte <laforge@gnumonks.org>
CC:     Marcin Szycik <marcin.szycik@linux.intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "michal.swiatkowski@linux.intel.com" 
        <michal.swiatkowski@linux.intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "osmocom-net-gprs@lists.osmocom.org" 
        <osmocom-net-gprs@lists.osmocom.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: RE: [PATCH net-next v7 3/7] gtp: Implement GTP echo request
Thread-Topic: [PATCH net-next v7 3/7] gtp: Implement GTP echo request
Thread-Index: AQHYJ0c0x8wgPYhfJE2Ej/qOlKqz9qyfHWAAgAAxdFCAALtjgIAADYIw
Date:   Tue, 22 Feb 2022 21:49:29 +0000
Message-ID: <MW4PR11MB57761DD076EA744C52C49FD5FD3B9@MW4PR11MB5776.namprd11.prod.outlook.com>
References: <20220221101425.19776-1-marcin.szycik@linux.intel.com>
 <20220221101425.19776-4-marcin.szycik@linux.intel.com>
 <YhSDfvQoNDyoAaV9@nataraja>
 <MW4PR11MB5776AA2256C00293FAC07C16FD3B9@MW4PR11MB5776.namprd11.prod.outlook.com>
 <YhVKK16JRo3THp7h@nataraja>
In-Reply-To: <YhVKK16JRo3THp7h@nataraja>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2d7d73bf-f294-4896-655c-08d9f64d33e7
x-ms-traffictypediagnostic: MN0PR11MB6011:EE_
x-microsoft-antispam-prvs: <MN0PR11MB6011A4D51B17E1753FDB3CC3FD3B9@MN0PR11MB6011.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VBX+kURd7MDSvz976YKJf7CG86JHRdAgOWD+YDKpDWXfjilQ0Cj9qtGnsIdIbcxxCUWkPDK/uxkQqv4SDmavQi1gtSBTwREDaXKj6J2bl25LyVLAZXlF9PT6pndhXd0g/qrs5tK6i3zVsFXq0OH0FEMfnVX/IUTWS9NsGW4XgnuB0lVF5d7sLO/dm02j733yCHOP3m++mM2PrZ1KGpvp+PuXzwEMyd6CC+Gkrt60Ii+Xqt2azDJJOxBHWVyOtuBqe7eo/7z5YeRmuJGiSloqhdaAczS5pPpFiET3H2FH8xiFLES5e0VqsxlR2Xplyx+CHFW3FeZ+ZvGrrfBHuiJfWv/kYcp0O0SErSGVXaQ6QjK3ld7eCyTreK25Sl6qZ3Q6jAAgdic/6jNP3esRoa2UaFGm5ARgVeYDOIetozN7g5CPFPn/uMOrREM6l2fkGMtqCTns1B1neyG6OzxDy6mALh7nWKp07tw+sGCPQFRW/1AZR02cYY1+YnMnMgJeIkHRKmG+WhSXExORCI14PVwfeOugUDFxqILGJMODxBXu8wfM7JMNqafH9ecM3+H7KfEHg0y/tujh3HLdjfJcsspOLcfgEc3HZT6WvhTjQxa0ASQUjn5bcrd92Rrgtk2je63yN1AFcWaGpLh+YUTiMtuJ9dZFzZH5ZxuKWvp+C+khnU22OFN6Y0b7lyHl5ZEhjTdxWXTFogE3tK3ZpZZMBRvbJQyzf1vQ1uAfT6VgDfD97IfkMkpObZZ5wcQq0lQSl0trUOCq0ZqM9VnDzO2xMn91eixTaUv7jf9qRBv3SM+frss=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5776.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(71200400001)(508600001)(7696005)(6506007)(9686003)(966005)(66556008)(66946007)(66446008)(64756008)(76116006)(82960400001)(66476007)(53546011)(6916009)(316002)(54906003)(86362001)(122000001)(38100700002)(38070700005)(2906002)(55016003)(8676002)(52536014)(83380400001)(26005)(186003)(4326008)(8936002)(33656002)(7416002)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?gk6E2F37c/bnInS4SY/iAdnbkir5DpBYorKEu0+W/lSAwTv3CoeomDlv61XD?=
 =?us-ascii?Q?80F1tMNsuvFd/T0CQm73t/SeqTidlepDwtysCGIPwRXEC/IJi9a23sQzPA2C?=
 =?us-ascii?Q?JquxydVQ8SjaoNOXyS3YFfTHHtZLE//N1yj8pytO46IlgfoN56isnhXllDZh?=
 =?us-ascii?Q?LVmKhr+UuFk7CLUYWpsFk3y+NQDKCy+NQSvKN3ly/kxLu7w9JKNpYzgVPr0c?=
 =?us-ascii?Q?ZrN76KX1DGdvQmY0XxmoeWODxHdRlnMPtppSFjH/Yxc3LZZ6Iij7rvVtNmuw?=
 =?us-ascii?Q?9ijsq8VrFJVLw1VNtXhyVE+9Jo/mqa5W3DEkBCBMF5ThFRTbuD5Z6H6q5y9P?=
 =?us-ascii?Q?+qykw5bpapF4/lQjkfiUAIvVWLbVFOrbwSIrqgd552UkbXXUw1sKrbk2KvE/?=
 =?us-ascii?Q?8x+ibOGGiC8AzL9a5Gj9cfWCfxpOtotokmCZWw24WcBRZXJ5tNW2GCfVJdNT?=
 =?us-ascii?Q?9+huWPK7SsJZuUxeehri+//oq8wT5e5OZyBS6FKHW4NvnbCxirGbCXGgy4XU?=
 =?us-ascii?Q?I8hVqT+Z/glexLey10wmx6qWa8Tq/BjyeekceIDDIumAKjddQ1qYm59B53op?=
 =?us-ascii?Q?QfYg+ZMC0J+3h3TgNCfSrekfQ8Jak9v4qWkMgoHgseP5VHSNHeYAajZv73Dc?=
 =?us-ascii?Q?oX6snBkGVkRtnKcvGXl5Ut5Xv3Wbw/N0odneM4GqMz10d7KNY3c+sXIymOtL?=
 =?us-ascii?Q?GJYrh2B6tOSAYCPDGvs3OJdEKpbs2pA4A85JtzTXwyP5BXdEAdTcfkKDb9Pa?=
 =?us-ascii?Q?9yGIwQ9sDUzOCXumPNqHwuB8tQ8xhyQ1Or17+08GgGXzK1jO11NgNpCavPrR?=
 =?us-ascii?Q?SW8kdjseUpIA1H/CU9/WiUusKUDaSKxVwXOqtiOLSEmWUy5GqVyRWPt4XrQr?=
 =?us-ascii?Q?MeQkb9SNSZMkXGIRVm/sxrv8J7Wyfw+1ycZcy25iiy1QPvGU7fmsKcmQBszz?=
 =?us-ascii?Q?f8emNAMgtLyUpNWe9SslVhWvGgnc4+wc5OF38cM4yGCoCskvVa/bCJcjoZqs?=
 =?us-ascii?Q?uHzAisLcBArmTJDdRPG8lm+JoJsLq0HyU/mfHlTu+o4k1FpwfYPgHjCbPUlj?=
 =?us-ascii?Q?pCGoLoJLLHd9ayhYiFaPJwylRoaIcPcCq/r3zZys8kPkFqzwdYfl3h0MjvEo?=
 =?us-ascii?Q?NrJ1YIV7/LQpuxypgkY7Wm9mLxLbB4kG29fH0FxllUo/St4ThAtShX3xgrE6?=
 =?us-ascii?Q?69tyQht17iFKPuTuAG1zhOJp1dhP9T+s65OM2KoOTrU+1wO1R0qb2NaXY2o1?=
 =?us-ascii?Q?Tr9Z7TaHKc40S0tUtQUZlYK/Okvnhha3Pxfy6uqS5pMeEZGPEIv3MjNJzPop?=
 =?us-ascii?Q?Gn5pTVypQuYmJI4WIi0qOpmMPCmS0GH+WMdfDSzZF+I/+MLzpS8qM4LEAOVE?=
 =?us-ascii?Q?Qhq0xDkLdiFx04JGR+DWB17XuW5Ma7VR3RtXwQWnIX8TZvVZON/V5Rmw0Z8h?=
 =?us-ascii?Q?Vz4euwHNl0IpKN22jA0vPGCjvFfy7qkXDEY+JW/EpuHMg+FhWj3I2uaMy2K8?=
 =?us-ascii?Q?XRvYv5AcbwPq39YxKVezXfxd17QMdcqCbIkHYExmGJYpKGh+upPxZYiiid0e?=
 =?us-ascii?Q?5856UE8p1Yw1VXteAZEOjEW1sXKo1BkJeDRLuPg3DNdxh3FjKnQ83HS7yrOy?=
 =?us-ascii?Q?Tp4+E770m6MX9/dDt/SoaG1vHNN8py0Rt8iGq7nVxHU4vPq3TwzNc7Ewl1Ui?=
 =?us-ascii?Q?GygKjA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5776.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d7d73bf-f294-4896-655c-08d9f64d33e7
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Feb 2022 21:49:29.2103
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KNVHJCYchKJGiyGC92jX9RrgoB3fpow7AKyhEvOyUq0kIvG2j9f2W/ej7mmbrOblI6GMZ8VGAKpiYdjJdNrl3AFjgSjrQrw4SPzFDjuOsj8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6011
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Harald,

> -----Original Message-----
> From: Harald Welte <laforge@gnumonks.org>
> Sent: wtorek, 22 lutego 2022 21:40
> To: Drewek, Wojciech <wojciech.drewek@intel.com>
> Cc: Marcin Szycik <marcin.szycik@linux.intel.com>; netdev@vger.kernel.org=
; michal.swiatkowski@linux.intel.com;
> davem@davemloft.net; kuba@kernel.org; pablo@netfilter.org; jiri@resnulli.=
us; osmocom-net-gprs@lists.osmocom.org; intel-wired-
> lan@lists.osuosl.org
> Subject: Re: [PATCH net-next v7 3/7] gtp: Implement GTP echo request
>=20
> Hi Wojciech,
>=20
> On Tue, Feb 22, 2022 at 09:38:08AM +0000, Drewek, Wojciech wrote:
>=20
> > > I think either the Tx and the Rx ard triggered by / notified to users=
pace,
> > > or you would also do periodic triggering of Tx in the kernel autonomo=
usly,
> > > and process the responses.  But at that point then you also need to t=
hink
> > > about further consequences, such as counting the number of missed ECH=
O RESP,
> > > and then notify userspace if that condition "N out of M last response=
s missed".
> > >
> >
> > I thought that with the GTP device created from ip link, userspace
> > would be unable to receive Echo Response (similar to Echo Request).
> > If it's not the case than I will get rid of handling Echo Response in t=
he
> > next version.
>=20
> Well, userspace cannot 'receive' the ECHO response through the UDP socket=
 as
> the UDP socket is hidden in the kernel.  I was thinking of the same mecha=
nism
> you introduce for transmit:  You can trigger the Tx of GTP ECHO REQ via n=
etlink,
> so why shouldn't you receive a notifiation about its completion also via =
netlink?

How can we notify the userspace that the echo response was received? I thou=
ght
that I implemented it with the dumpit callback. Is there a way to send msg =
to the
userspace using generic netlink interface?
>=20
> Just don't think of it as sending an ECHO REQ via netlink, but triggering=
 the tx
> and acknowledging the completion/reception of a related response.
>=20
> One of the advantages of the existing mechanism via 'socket is held in us=
erspace'
> is that we don't have to jump through any such hoops or invent strange in=
terfaces:
> The process can just send and receive the messages as usual via UDP socke=
t related
> syscalls.
>=20
> --
> - Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.o=
rg/
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> "Privacy in residential applications is a desirable marketing option."
>                                                   (ETSI EN 300 175-7 Ch. =
A6)
