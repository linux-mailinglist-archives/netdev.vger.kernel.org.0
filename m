Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6119C4ADAE1
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 15:12:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377169AbiBHOMk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 09:12:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233766AbiBHOMj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 09:12:39 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10725C03FED1
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 06:12:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644329558; x=1675865558;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gRMvYIzkqrLjGYShYCrkN3+D1PIWOHgOo/4mmgwt8Xo=;
  b=Q64g/q6Ca44AoGf89k+yPHT42/fqNiJgnMxHTrQwkBZj2QbjoS1Er+s5
   KxrWznQWUss8/Da/Qjb+K6fOr49jzsJGtNA8xTM/YxL1cdCylX8WzpEcx
   gmrTzEGrB0t6M003b9L5yHu3LtU57b7URY2X1/e6JRnyRqQI+PodoUvzJ
   hJ0nWJtzJSLbp7E28PEDBy2Pun+JOThs+6z38U6H3W5ZMKl7Gu+Fgyt3V
   Nq4ZnYw6/4Zm9vznspJGvvgWdkz5PB4DSAi/oF6EUnPBoDtL9hV9YJddQ
   h0knTuvCjRxHcRzptQEFNkMjqVXM5wsgPK9X+jpXu8cPH242EpvH8DU1O
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10252"; a="229604127"
X-IronPort-AV: E=Sophos;i="5.88,352,1635231600"; 
   d="scan'208";a="229604127"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2022 06:12:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,352,1635231600"; 
   d="scan'208";a="678114452"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by fmsmga001.fm.intel.com with ESMTP; 08 Feb 2022 06:12:37 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 8 Feb 2022 06:12:36 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Tue, 8 Feb 2022 06:12:36 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Tue, 8 Feb 2022 06:12:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q5EK4615yD7rkCBQjzmftnaNf7l6ll1Vmx1tnPdNuR/n97sfndq7fpY3Ne1Ai70sO9nlnRuuiUNlG3PBwxVqUQ/4AUh42dydCs7k2UHYSfyww3Y/1yblgBFudJlRfAUWBclUdlLog3tXnTzoEcDk+rWu0XukBdUZLqmeztb6k6Oaf2ZEVs3UVbcwlhrRTmfI2OYW1cbZ77rvMxB3/UdUWu3vvXBVsuPV8wz+7xPFwSQCsHEdIqb1w+95EIIWO6zUlNCucyp/f/bwGbc9c+1Jl/duvbb5WgazAlXnyjYfEZFWUx3xlQraQmAaF7OyMPI3IVwW8jKavoDIb3oKK9NZQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0p5Gvr+JTF/1N5z0sNa4zfCJ96ylRmjVpMkhfEHzTTw=;
 b=Cr17mpnSdpJnl+Nb5CXm7xeAlTPgak8VQNIfw2tOuX6gcLLOs6ykkhLJYObkMuTVmKJbziDpqbniWTS03W+S2PaIy+Oflo3sOfk33Jqkf4tf35MRsgnqSh0Yo4qRQuFdO21vpuj/kle9AUWrF3GUQFZQv2ltCZebuhNodYtE86fhupu8mN++A/TdLB+Rg7FB5VsuQjOba3I6Bxqme1T3G0W+rhFrblNRdGizP6IhMXCAKL1AQRnh1FBY3HcIz6RVDucVTpof4kDQiSS0T5DBsf22OPyqCQ/YmeCddzBCmnnpmpQ39HaXMCMGg7qEJDdEcJEq+tNaksCNX0Mw/3X3oQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from MW4PR11MB5776.namprd11.prod.outlook.com (2603:10b6:303:183::9)
 by SN6PR11MB3151.namprd11.prod.outlook.com (2603:10b6:805:d2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.14; Tue, 8 Feb
 2022 14:12:34 +0000
Received: from MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::6cb5:fdfd:71be:ce6e]) by MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::6cb5:fdfd:71be:ce6e%3]) with mapi id 15.20.4951.019; Tue, 8 Feb 2022
 14:12:34 +0000
From:   "Drewek, Wojciech" <wojciech.drewek@intel.com>
To:     Harald Welte <laforge@osmocom.org>,
        Marcin Szycik <marcin.szycik@linux.intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "michal.swiatkowski@linux.intel.com" 
        <michal.swiatkowski@linux.intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "osmocom-net-gprs@lists.osmocom.org" 
        <osmocom-net-gprs@lists.osmocom.org>
Subject: RE: [RFC PATCH net-next v4 4/6] gtp: Implement GTP echo response
Thread-Topic: [RFC PATCH net-next v4 4/6] gtp: Implement GTP echo response
Thread-Index: AQHYGefbqRcNOb4NqUCQWYuxV/hGwqyFLYqAgAR+yXA=
Date:   Tue, 8 Feb 2022 14:12:33 +0000
Message-ID: <MW4PR11MB5776D18B1DA527575987CB1DFD2D9@MW4PR11MB5776.namprd11.prod.outlook.com>
References: <20220204164929.10356-1-marcin.szycik@linux.intel.com>
 <20220204165101.10673-1-marcin.szycik@linux.intel.com>
 <Yf6rKbkyzCnZE/10@nataraja>
In-Reply-To: <Yf6rKbkyzCnZE/10@nataraja>
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
x-ms-office365-filtering-correlation-id: 8fb2d0af-5af6-4016-38e5-08d9eb0d0d51
x-ms-traffictypediagnostic: SN6PR11MB3151:EE_
x-microsoft-antispam-prvs: <SN6PR11MB31519706A38612D1DB5F9DF9FD2D9@SN6PR11MB3151.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SwOfRZGcjxAFREEw7hwBjvRKg6jUIM2om55PYgD8d8ERDpt2JwNRTjNjzeTSBj2cza6c/aOdvw4WiJwRBqIW5ZwPWmkoMOhTgfUmH1D+iDzXsxFJ7w6A2tFUP1QBpvsSnjSt+3glJA2NAZ3oEiFH0f4d450ifcR/gILolmxD0LDCrBGgZo2pKOsD9auwR2DvjmrN7ZIcMaraoRcif7RDcukw3mzS+6GaW5WUWHwa5GcgN75GiEqFe42IppJJSovQkX9pogNJFrqQums6rPPaWMQ6HtbZhY2eaVLcOAOBC9QNMuFZ6J81FggvVQ65ygRNLPE6vOL6V97uysJRQHJIDqeiW6uyYSDSwdW49fa89Fperz5Wb2eiQTJ1RS38bRCWXu2j2t+++xV+SczhIeZrKXRxRiqHs4WYeQ42YcqA3GTXUN3NlIRlFkYX164V+QcmpFpMKLscbireZgY1yR+zjGuNqXcAZAV7gN48gD+V7KWMx2isHCxP8lUc/TUjQA8y8LxW4a7y43UPLcZlE4+dv5JfYjB7drYMbAfkTV8I+b5M2343Eu892ht0EhBch6KMf7ypXBEsdCKasTE5Gl63vHqxIwFVmzZOEjRNJCv7fwxwrAhQlSYZOL+iS/VOL/AjBgSHe+Ye6OAvYC9yLInu1ka0a8FrvUEHKYp7grDfjzUpeHwdd6u9macuHBpYVoalfHKTpOTATxA793omiT1d6wLuSj/JMjpINFdDY2zc4eB9uEijrvM8Kmut4ilbmTRKJSysr/nXBSuJzNaQysOeQcyvJZ/hx0ve5OmYGDbtKDE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5776.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2906002)(8676002)(4326008)(7696005)(71200400001)(9686003)(508600001)(53546011)(38100700002)(66946007)(122000001)(64756008)(6506007)(66446008)(86362001)(66556008)(26005)(76116006)(5660300002)(38070700005)(55016003)(110136005)(52536014)(8936002)(82960400001)(66476007)(186003)(316002)(83380400001)(966005)(33656002)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?JjcvzzsbOZKVKhRGbrnBXY6DaIRvz6CTJMoNzU2sLsYaQgp6GI5j3U7xkMcS?=
 =?us-ascii?Q?z1+bmQa1RNnHQa9yUCoJBk69r7PCv6Yy1BNhd49xXkTYjIfXCIii6N8RE+aM?=
 =?us-ascii?Q?o9CoOIF5f5DS9xaf8sy5IwRbZGk3uSUq3Tm8y/hY7F8tB3VMovMXRiFmwWK3?=
 =?us-ascii?Q?g3p2uQ926GSWKJzh/JFnShub+vDDM+UZM/N7zbjWUP/WvpzvTr8qPQ0vCZsN?=
 =?us-ascii?Q?lgZ8Nf1pWfmMHC0XfEByouxCd1gQJEC7GuVeNpiMrPBy78lnNi3lQ9vv5795?=
 =?us-ascii?Q?pGSSyrOPe8HBonToJ+D0eI2IPnbo2bzdQK5deReEprjtkxOhJrR28+LttX+Y?=
 =?us-ascii?Q?hKlPCfAj9NugjdaCjoL02VHmxEwkKOUBF4tJ8UXaz/XjY265sd/QVHm8DrqT?=
 =?us-ascii?Q?MvEIvOYUw+npfzPBUW8PyNWZ4IR2mMWj6jSVx4jGL0r8v4bSsVSIVLUEc+9n?=
 =?us-ascii?Q?IOtDAd4xyXw6TcaMGfrr17bWNNfI37mrU5bBvQhOZYaVFHYlz2uP/cuZuxrZ?=
 =?us-ascii?Q?s2sDJZFDtq/ILKUEI0GgIp04ESd+fBeUjcOGDWaRYhhECR7S0Sumo4hrd5ol?=
 =?us-ascii?Q?iUA+g6fcN1btz7T3BGH2btNCMlHKaWw3Q/is08oytP0aguHa1OGiRHPlrSOM?=
 =?us-ascii?Q?GNv6E8M8xBNwLLuDoDfh6LidLqFJahCF/FbOaC916fV2hfb/1Uio29WgAYi4?=
 =?us-ascii?Q?c3JG07QmdzQqMbSO1AVvZRMJeC92aZc5UOYI253fTZ4/tBxkAuD686fS6RIZ?=
 =?us-ascii?Q?N+/HfsCHuSQCW1jH3OWLn74AQkI4Gsb+W91N/srQy7Dmxm2sMBXt+SEKaoNL?=
 =?us-ascii?Q?w0CZbvvDxtd+OzFWy+Pxec3hDK3Ho6Tt2mjijB90asFmEZ1lqaH6iFWX4Cy+?=
 =?us-ascii?Q?YdRgQC4CEcR8OS8NxtTKSlPrqXoxEQlavBHwJN7Gs1ppmlV3h/uvom/Klo0j?=
 =?us-ascii?Q?rBcjkMiPUYvIXGJSV8UHDiVIt2lMeh3xboqO3emT18G2ffGUt4Z9S+9enl+o?=
 =?us-ascii?Q?5IvdZ/D3y1vRT+h+RGbaIHeXgu0wIE725bZasnUyu+jqEMcjbqeAU0YBtPXv?=
 =?us-ascii?Q?cWib7hydwCtuHbR9HGcY9dv9zIiYHlsnapZcIjgO0yB9a+lARQz6smfXYX5K?=
 =?us-ascii?Q?7436bcOGf6R59OdTjXpskb45m9ycyVC0dCdLoTALBMvjwvbR1XlpLKJcyYSn?=
 =?us-ascii?Q?8NvaxtQGuZgA9D7czXvEC1vEtPCgd3Pe7/9JrI9heXprjPxuYG+yrwQgk+Ar?=
 =?us-ascii?Q?nOKuoqcFwki3xEAPqt8fNCDGRZU4M1sn0jJphosV9zIGrxl+eLA1Fsog7EH6?=
 =?us-ascii?Q?8zNYxkZ/nH9kMRfipO4DzFZw+e7uEjiAWKS+omDC9L2EWflvXTQz5jRTtyaw?=
 =?us-ascii?Q?gILoDOGUPo7IgvflqqArsvwoHp2SK3GmqtoIeMAJnVj351Lp+TCiur+0j0Hi?=
 =?us-ascii?Q?h22q9DcDO9ZbcsCwWEStU2GUyHM80t7xWVkS2RxRWj7OHnxUW6asqJu49gDf?=
 =?us-ascii?Q?UJ6LoYBVjOSOVpI9xRZ9nit+ghgsLHSpIWD1TcoIqq4fMVq09EeHriI5Duj0?=
 =?us-ascii?Q?DxWrsF23YPRO7vDja9DNTPQxqcLTDQsrcNt2tnWkOwUd54I8muDPm6CPcdD1?=
 =?us-ascii?Q?l45hKNchhXmOzjiTYnzUTUqDSuctC0zMHculSLhwt2LN?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5776.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fb2d0af-5af6-4016-38e5-08d9eb0d0d51
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Feb 2022 14:12:33.8758
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JOKTK79ks/6gSd2A7X/zD/iVDRLxLonx6d6ofXBYpzBtRCq2w0orhViOuiQLtVxyFy3EcdUR110dCwRaN2vbHMLt43rcPawnrZHmPyfoOyY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3151
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Harald

> -----Original Message-----
> From: Harald Welte <laforge@osmocom.org>
> Sent: sobota, 5 lutego 2022 17:52
> To: Marcin Szycik <marcin.szycik@linux.intel.com>
> Cc: netdev@vger.kernel.org; michal.swiatkowski@linux.intel.com; Drewek, W=
ojciech <wojciech.drewek@intel.com>;
> davem@davemloft.net; kuba@kernel.org; pablo@netfilter.org; osmocom-net-gp=
rs@lists.osmocom.org
> Subject: Re: [RFC PATCH net-next v4 4/6] gtp: Implement GTP echo response
>=20
> Hi Marcin, Wojciech,
>=20
> I would prefer to move this patch to right after introducing the
> kernel-socket mode, as the former makes no sense without this patch.
Sure thing

>=20
> Now that this patch implements responding to the GTP ECHO procedure,
> one interesting question that comes to mind is how you would foresee
> outbound GTP echo procedures to be used in this new use pattern.
>=20
> With the existing (userspace creates the socket) pattern, the userspace
> instance can at any point send GTP ECHO request packets to any of the
> peers, while I don't really see how this would work if the socket is in
> the kernel.
>=20
> The use of the outbound ECHO procedure is not required for GTP-U by TS
> 29.060, so spec-wise it is fine to not support it.  It just means
> that any higher-layer applications using this 'socketless' use pattern
> will be deprived of being able to check for GTP-U path failure.
>=20
> IMHO, this is non-negligable, as there are no other rqeust-response
> message pairs on the GTP-U plane,  so transmitting and receiving ECHO
> is the only way a control plane / management instance has to detect
> GTP-U path failure.
>=20
> So without being able to trigger GTP-ECHO, things could look prefectly
> fine on the GPT-C side of things, but GTP-U may not be working at all.
>=20
> Remember, GTP-U uses different IP addresses and also typically completely
> different hosts/systems, so having GTP-C connectivity between two GSN
> doesn't say anything about the GTP-U path.
Two  approaches come to mind.
The first one assumes that peers are stored in kernel as PDP contexts in
gtp_dev (tid_hash and addr_hash). Then we could enable a watchdog
that could in regular intervals (defined by the user) send echo requests
to all peers.
In the second one user could trigger echo request from userspace
(using new genl cmd) at any time. However this approach would require that
some userspace daemon would implement triggering this command.
What do you think?

Regards,
Wojtek

>=20
> Regards,
> 	Harald
>=20
> --
> - Harald Welte <laforge@osmocom.org>            http://laforge.gnumonks.o=
rg/
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> "Privacy in residential applications is a desirable marketing option."
>                                                   (ETSI EN 300 175-7 Ch. =
A6)
