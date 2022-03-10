Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB21F4D4CEA
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 16:43:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242826AbiCJPZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 10:25:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232981AbiCJPZO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 10:25:14 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B780158792
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 07:24:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646925851; x=1678461851;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Ho6UurSzZZhqegS1YIlDbZmg/qDlB+TYAFQIlF5iZ4E=;
  b=UrqlesVAyreKfxkqRCkaySP52CaOCFn7njBKBWcg6ZkwdUC3+N2V1F06
   nzZC9WkUHipXMAK7LbPtBwaFQuCQRcJJgm1IAaUunh6/ivXvGhOCyvbDu
   PhXgyif7IepI3VeLblg/wcu6ocKzIX8R3/Ym1fOzlf1B8xrS/PdBdEs+8
   HNSUEyIw1qBeM+PMv4JnzXE99nPG74GffXen5Tz0x0A2Az6ju65h3SxJH
   T4mFnCsLgBm8pW+mcAEo3l1Lp42+ZOwFdQYB74Isp+qh4yb4IAk4EAfFs
   W0tEAoCZy5ThNbAfCQzOXSgERYfXtrZHL7sXgN5VTt+qnao3fSrexgCkq
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10281"; a="242722335"
X-IronPort-AV: E=Sophos;i="5.90,171,1643702400"; 
   d="scan'208";a="242722335"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2022 07:24:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,171,1643702400"; 
   d="scan'208";a="538494192"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga007.jf.intel.com with ESMTP; 10 Mar 2022 07:24:10 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 10 Mar 2022 07:24:09 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21 via Frontend Transport; Thu, 10 Mar 2022 07:24:09 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Thu, 10 Mar 2022 07:24:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CCOoESI5YZcQDZXS1/SiknQBE4RrHd6Hf1xLLBYwbBmpvUTzpO3zjYpMgk0MwX7eNzDT21ewDWDVBu8ROr0IhWaf14h+XG+snOBsGbbuz9nyRynIe5iXie25OOjptPrKJC+6k8QEpNiYjotQYJhTxnbMfCNPOH2ZhjlBhcAg0Kx3b4bEsV9zLGf2PXzNOD91RluRnA1uJSqgaJiyucJlxfsp2FstuZKk8Qjp1IBt1i9qYWu3w0WdXYuEIHUEuMwi4e/8y5kKKmrsFGTmufglrST6qDsAEMODIU86rs7TK5Ojx4ZM805LdTV0nsHbU7jhgdmHpbe6vVyPV7KE+zr77Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5j9Hf64Ufnatdg/qszpVW8Sa6a25GnoF+sQ5sEIHG7w=;
 b=LJI+8YdtcesZo7i55fcYpLNqohf/qlC5AHeqUWfinare7w/8yEHeBvXqAjPADNXv9yW6kARFRhZeAIkqEanxSdwzZlL07xqanLGAgKgng5uGnMKsjGAnEXvMFOs+JdDMME+SJ97YpURFcIopiX1L47+uEa9ie1UhTLcAFqCJPqcZGERjQ+wUUNsCcFvQVlpVI7Zybon/DfaDIUs90LKphhzBEQ6Byserdt8afYZP3ScMaCevGnusoyqFzLO72KQUqXPu64Wd+w5ZXOvUsAH1tNWu/lbncuJ2j2eC7ms36gtj3EpRHi1iGfEA6b/IHpdM34SVIP8nM/cBJpi3FmsDLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB5776.namprd11.prod.outlook.com (2603:10b6:303:183::9)
 by DM6PR11MB4427.namprd11.prod.outlook.com (2603:10b6:5:1db::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.17; Thu, 10 Mar
 2022 15:24:07 +0000
Received: from MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::79bd:61ad:6fb6:b739]) by MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::79bd:61ad:6fb6:b739%6]) with mapi id 15.20.5038.026; Thu, 10 Mar 2022
 15:24:07 +0000
From:   "Drewek, Wojciech" <wojciech.drewek@intel.com>
To:     Harald Welte <laforge@gnumonks.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "michal.swiatkowski@linux.intel.com" 
        <michal.swiatkowski@linux.intel.com>,
        Marcin Szycik <marcin.szycik@linux.intel.com>
Subject: RE: PFCP support in kernel
Thread-Topic: PFCP support in kernel
Thread-Index: Adgzonf8LBvYss0DRt2kM5s+Tem75AAP01oAACqSnwA=
Date:   Thu, 10 Mar 2022 15:24:07 +0000
Message-ID: <MW4PR11MB5776AB46BC5702BD0120A7C3FD0B9@MW4PR11MB5776.namprd11.prod.outlook.com>
References: <MW4PR11MB577600AC075530F7C3D2F06DFD0A9@MW4PR11MB5776.namprd11.prod.outlook.com>
 <Yiju8kbN87kROucg@nataraja>
In-Reply-To: <Yiju8kbN87kROucg@nataraja>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.401.20
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 39e054c8-bb7c-4857-7ed5-08da02aa04a0
x-ms-traffictypediagnostic: DM6PR11MB4427:EE_
x-microsoft-antispam-prvs: <DM6PR11MB4427BE085E8F010AEB7B16B8FD0B9@DM6PR11MB4427.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4cum6Cazgc1c6ehuFkVABA0r+pGaOTl8eFlBcdDho92eoTHW6F6L8UT133DstsMU3J1EdHCoy07wkAR+ex/ntZRBG3uRxTqJ5xwEE7IWJvY1Gy6T1a8R617rUrzZnhKww1n9D1dLDKa429+W8wJ4Y5t93bKKHzaAvXyi9awH+7fwmz2gSWwwgB/rlseEPb+JZCD6UuTahYga7QCCK9TgesSMZgrfos+pTxVqHCRieHy4KSrRs8tJOIfM0GCV3YHf3iHt55Hglkz3gqSRl+p6QtnQMh2AFFEuXPQFSuu0DKBlzF77UdEhK+Ug0NzkqU2JrM15nxdNnHD/wQ2W2EJLuqibP7titXyL4Xevt6EFLvCp4Zv2QCVrLm5KgBXghF5E+emtxns4nt92a0X4xO48e2pSXTkfLaCdgXgYkXf1TaaTcjY2CIYVLT6c9gzDpl0iwEAlwrq8LeyQVBo8uDMsxF4h3WdfSYcZ1NWRX4xzZt6wlH15GEzLG7qQa2zG0UPEv/051XEh3aOP2PK6jmB9Z99W7pR/fq1n1/Pf0Su2iSrnKaQwJu9kMHSGLcx0oTGwYkWn91wFt7T+EMsdNBzjORupxU+5deUMT9XExgcRJDQejfUq7Ga7oaqzeWxGewO0p6haIOpiE0dcS4J5v/Tde6u3yl/U56he89Rn95SutGwXAa7mabMyIYbW+sFVWHDWbytvZgx++sAXbB/ceHDoF2NxncRH/mVEdZgOvystCYqaSGCbcQE4LlCQ7azaisAW+gPLlHx26lxEkwJVQ7REbwOpwmhs9XFoS20mGPZoB54=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5776.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(76116006)(64756008)(55016003)(38070700005)(186003)(54906003)(4326008)(86362001)(6916009)(82960400001)(316002)(8676002)(52536014)(9686003)(122000001)(5660300002)(83380400001)(66946007)(966005)(6506007)(53546011)(7696005)(33656002)(26005)(38100700002)(3480700007)(508600001)(8936002)(66476007)(66446008)(66556008)(2906002)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-2?Q?KHWCkFv8WgbEO6DAJyzBli+REN2daCEXgiuuIOXlZVoexH6fmYCnBolF/n?=
 =?iso-8859-2?Q?khh8MEF5vSAuHMxoS/C2yWXLmcIkWURjYTPbHJYZd3jzIRzBvp6VD0foeU?=
 =?iso-8859-2?Q?Z63hxIIgxCoMbqkbB4hq/I9BD61250WWM/im/uKM1/w4VmEEkedOh9xlPs?=
 =?iso-8859-2?Q?GHH2spsPXIySaNHP/l/ctnlTkzWrEpU8qrcxcRmoCV6pctCZDGt413P039?=
 =?iso-8859-2?Q?JMWe2ZDWocDv502YnYHaMbchfE9/3oYqH3b9MAYk9t4wWHI7NHKfCLJSIo?=
 =?iso-8859-2?Q?0mqux8aW5YsMN6vnStwwmCGSfQ49m6fyOKCfq/Ykdw6mBPYpvxCxcxzNrb?=
 =?iso-8859-2?Q?7TCjFavBiYHn02+NJ3z+S731VYRKxmh/fbdW73V6ex4SlkdbGruvkYwe1G?=
 =?iso-8859-2?Q?ElpmZ/bHMKhTjp6ujAJGvCJa8clI00vijXx//LeoiiXG57IVCLraxCOeVB?=
 =?iso-8859-2?Q?WkuT5wqkQtVjv1sMMf0r6GDQMBVopW1QPRzJ499F7V8Udsv7t1oklYQ2+7?=
 =?iso-8859-2?Q?Uh+2Z2RqBIjketqMh4ouidHLejt0go5So7DpYOOBIzKY2hN1Xkybjtas03?=
 =?iso-8859-2?Q?l55NZj0P/LU57rBXWKxinYdtceMbNZMq7FZaO+/yPMQA5KSI/m4J3OD3v8?=
 =?iso-8859-2?Q?tBkwE+M5SLatbCg2GIprESPhmny9ZJzJUtsXfnoUCBqCqQGBD5i47KCWV+?=
 =?iso-8859-2?Q?mxn5thvPM56/qYg8+cmnWvJmN900RHuPDEkvFLG/ZmZUA6kXf7JhH8qifL?=
 =?iso-8859-2?Q?rdcJ6kJXv98Y0aWq11mFXA9EiUZCObpmSql+rZYXpti9te+Zc1lRRMpZCJ?=
 =?iso-8859-2?Q?QzeJGH2RTli/o28sBt0ykD0rAQMAAt4hES30X3aNEtzXGS1jbgcKUke+F1?=
 =?iso-8859-2?Q?lwbB3BHfNaJBZZrP5eKO/+fy1o1CukkgYtyFDUdgsZO+GV7UHf3O9KBAzc?=
 =?iso-8859-2?Q?Ib3Bm2RHQalJWUPuybLDYTFn/BDMWNMCjFR2hBI/E1TF8wOWTGxLhd6Bbj?=
 =?iso-8859-2?Q?qhG3fWd85MEKbcYe5dwQydiV9/ygooU791le1qFQbrzjVkvAWMTxq6rDL9?=
 =?iso-8859-2?Q?ueKmqzkrmMNUFj9xjDi+qKDY6MP3cn14Eh2w60UHvbttgfWlzHJR2WFkeg?=
 =?iso-8859-2?Q?xqKuCLY3uqQDqdU1FAfHnj9E0ihrdej0g9Wopl2ISQ65y8vqySekCMFPIn?=
 =?iso-8859-2?Q?vU+sgGo6mapdP/ulXx+dg1SaP9bQxaIRyGpRoNj0ghdkzHCYXkIIVi3+n9?=
 =?iso-8859-2?Q?TxHb18fgt2VpADYv/Mrann8HzIPkr4/Yn9PyJd0/+N6S5Xkf+Ir4KJCXDV?=
 =?iso-8859-2?Q?f2VA3NeqaDpIBaRMR7k2B4P2hkevfVTsl8rVQRGviL1UxtuPLZ2h061o7J?=
 =?iso-8859-2?Q?gyt4ZZe7684T5Gv9rOLayUthG9ZyF+7gFmt+Ar/tAxelKdd+tx/KQ4dtSw?=
 =?iso-8859-2?Q?AGFawttSBahnamF6M3850HozXIpRbTLvqa68xNtIDpjDPzZum1m+l9D8KQ?=
 =?iso-8859-2?Q?j2d3Or7EoNV+WsiNIGreDDhN2qe2YRAg1mChFthErN3XAVvNT2hz3P0kR4?=
 =?iso-8859-2?Q?9w4PntHuLo3AxWocT2fc/RXiGIjqBtkTZJdhJwWS1lQdAwjxhl2sgbJoaj?=
 =?iso-8859-2?Q?BDTZnsMwJYu+uCH0dZe3zsIJpJQcgAN82IivW9c2nFop1hy5PDhUvd4aPV?=
 =?iso-8859-2?Q?MNE8Qy5y3Ldo27sPTbAgPJPlaTsJ/KflhKdqJ/TVcrT2q/feKRm+H3/ZYs?=
 =?iso-8859-2?Q?7Ugw=3D=3D?=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5776.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39e054c8-bb7c-4857-7ed5-08da02aa04a0
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2022 15:24:07.1044
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: b8HT6/SyStE3upV9Kc/alPJZeC+KyAeBjHo9QEjMfZGZB7CVK/sMcPU6HdmzPCfKBvBMf0Q6UkLw6A9To5GuA8YpjLQUMRKlOInB9jctMYk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4427
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Harald,

Thx for your reply!

> -----Original Message-----
> From: Harald Welte <laforge@gnumonks.org>
> Sent: =B6roda, 9 marca 2022 19:16
> To: Drewek, Wojciech <wojciech.drewek@intel.com>
> Cc: netdev@vger.kernel.org; michal.swiatkowski@linux.intel.com; Marcin Sz=
ycik <marcin.szycik@linux.intel.com>
> Subject: Re: PFCP support in kernel
>=20
> Hi Wojciech,
>=20
> On Wed, Mar 09, 2022 at 12:27:01PM +0000, Drewek, Wojciech wrote:
> > First of all I want to thank you for your revision of our GTP changes,
> > we've learned a lot from your comments.
>=20
> Happy to help!
>=20
> > So, as you may know our changes were focused around implementing offloa=
d of GTP traffic.
>=20
> Of course, that was what the kernel GTP driver always was about.
> Unfortunately it didn't receive a lot of love from the telecom industry,
> and hence it is stuck in "2G/3G land", i.e. at a time before the EPS
> with its dedicated bearers.  So you cannot use it for IMS/VoLTE, for
> example, as it can only match on the source IP address and doesn't have
> the capability of using packet classification to put packets in
> different tunnels based on [inner IP] port numbers, etc.
>=20
> > We wanted to introduce a consistent solution so we followed the approac=
h used for geneve/vxlan.
> > In general this approach looks like that:
> > - create tunnel device (geneve/vxlan/GTP)
> > - use that device in tc filter command
> > - based on the type of the device used in tc filter, our driver knows w=
hat traffic should be offloaded
>=20
> I'm sorry, I have very limited insight into geneve/vxlan.  It may
> be of interest to you that within Osmocom we are currently implementing
> a UPF that uses nftables as the backend.  The UPF runs in userspace,
> handles a minimal subset of PFCP (no qos/shaping, for example), and then
> installs rules into nftables to perform packet matching and
> manipulation.  Contrary to the old kernel GTP driver, this approach is
> more flexible as it can also cover the TEID mapping case which you find
> at SGSN/S-GW or in roaming hubs.  We currently are just about to
> complete a prof-of-concept of that.

That's interesting, I have two questions:
- is it going to be possible to math packets based on SEID?
- any options for offloading this nftables  filters to the hardware?
>=20
> > Going to the point, now we want to do the same with PFCP.
> > The question is: does it even make sense to create PFCP device and
> > parse PFCP messages in kernel space?
>=20
> I don't think so.  IMHO, PFCP is a rather complex prootocol and it
> should be handled in a userspace program, and that userspace program can
> then install whatever kernel configuration - whether you want to use
> nftables, or tc, or ebpf, or whatever other old or new subsystem in the
> kernel network stack.

Ok, we will then rethink our approach in this matter.
>=20
> > My understanding is that PFCP is some kind of equivalent of GTP-C and s=
ince GTP-C was purposely not
> > implemented in the kernel I feel like PFCP wouldn't fit there either.
>=20
> I'm sorry, but PFCP is not a replacement of GTP-C.  It serves a rather
> different purpose, i.e. to act as protocol between control and user
> plane.  GTP-C is control plane, GTP-U is user plane.  PFCP is used in
> between the control and user plane entities to configure the user plane.
> It's purpose is primarily to be able to mix and match control plane
> implementations with user plane implementations. - and to be able to
> reuse the same user plane implementation from multiple different network
> elements,  like SGW, PGW, HNBGW, roaming hubs, ...

Sorry for my lack of knowledge and thanks for explanation.
>=20
> On an abstract / architectural level, PFCP can be compared a bit to
> NETLINK:  A protocol between the control plane (linux userspace, routing
> daemons, etc.) and the data plane (kernel network stack).
>=20
> Not sure if there is anything new in it for you, but a while ago in the
> osmocom developer call covered CUPS, see the following video recording:
> https://media.ccc.de/v/osmodevcall-20211125-laforge-cups-pfcp
>=20
> > Lastly, if you are wrong person to ask such question then I'm sorry.
> > Maybe you know someone else who could help us?
>=20
> I'm a bit overloaded, but happy to help as far as time permits.
>=20
> Regards,
> 	Harald
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

Regards,
Wojtek
