Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7AC25B94F2
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 08:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbiIOG6h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 02:58:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229883AbiIOG54 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 02:57:56 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 110A08F96D;
        Wed, 14 Sep 2022 23:57:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663225041; x=1694761041;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=pcuBA04pMa+w0kvtxkfNnWWdPOgAe6w6ZWPrwimj9Zk=;
  b=IA+pYdzKbUPqxcIjb1fNeJucr89b7xj+ObccwLioeVMx8mcRIqskG1Qn
   e8o8wTg7wpVJg1kQxQ280QmsY+at823MduT0oWF2/HzTAoVV4IZsGPXnR
   4o74FsbIGKcCPUIxx+q0W1Yfnnsw0LXhiYHAkayAf2qVsdGbOGNXVdEAm
   rlCfRcOIH2yhtSViUH8CgnhiEcz6KTHfLpJOwHvNLjdKtUDK0PPQ/ea1G
   0WWOvAivtxc3TfeeeChXkI1BvEBkgD54aFMIS8ykfspKHf9SaamIgR3Af
   BH/1B0OZIL8JiEZSqfx89woR2TRXQM03PTMKhlleKkDvIAZwEaARAk7Hp
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10470"; a="384924026"
X-IronPort-AV: E=Sophos;i="5.93,317,1654585200"; 
   d="scan'208";a="384924026"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2022 23:57:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,317,1654585200"; 
   d="scan'208";a="679384001"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga008.fm.intel.com with ESMTP; 14 Sep 2022 23:57:20 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 14 Sep 2022 23:57:19 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 14 Sep 2022 23:57:18 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 14 Sep 2022 23:57:18 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 14 Sep 2022 23:57:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YsW0qevao8xYRclgD5HR/oWi8bXeLfpgaHObemgs8gyEr2XvNXY0caFINCu4vu8im7hCJ8JOKJt8UsyVVuq+7B5oOsNWXmPfrMsnIBScBPKleQJij1Z2iguhIk2oef0v64gb18oLBhCIcoS2rcnyRcXVo7R7FAYj5Y0tVvRotBbLKlkC7V5g+2oE1QCCQ3CsbAj2n4O45LeZRYdBnn/tgk6b7E2BQmpSWz7auZtAuEJClVxbusbNiBTZuBQeCgfjOKCzrOk/uTm7a5f0C6ZL+mwtHGSqc4fHX/8CDt/C48wzvs6bG2I9CmvWu4iUh+8aKW12hxx2UFNv/7dozaKMWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p8pHCvB5l+y3r1QuRwQnNFvMRP038CerPREq/6k1KyU=;
 b=QjQBfJtmwV/vwDIhmzZa9eMKpdjMRrf6VBnz1xmcOU9XxMcqc+mJGCZ+Nabo+ow6B5S+B7sHAzKyuxk7qxm8L/zLMyn/Lh2YmKiD4XDcuXL67sh7RftdsOplbN9R4ihdQeojRjzA5m4DJCssHkHDg8KKbexnt8Xr7FcOE69Jl2xJgwYSCxZ9xk3yyHEfwZCFO5gJ7O/fLHnMR2idpovh6p0cjBq/U08vwsiQL9nV48qMhva1sy9B+C8U0N8DTql/lvnUebcvzB8bUW15ncM72pOM3sLSjyQjfcGYqyFOhXThUtQLuZmT35hgXSztBWhB3U4/EYyvV09rtD3laq4gXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4348.namprd11.prod.outlook.com (2603:10b6:5:1db::18)
 by IA1PR11MB6372.namprd11.prod.outlook.com (2603:10b6:208:3ac::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Thu, 15 Sep
 2022 06:57:16 +0000
Received: from DM6PR11MB4348.namprd11.prod.outlook.com
 ([fe80::48:7f55:58c5:3343]) by DM6PR11MB4348.namprd11.prod.outlook.com
 ([fe80::48:7f55:58c5:3343%6]) with mapi id 15.20.5612.022; Thu, 15 Sep 2022
 06:57:16 +0000
From:   "Jamaluddin, Aminuddin" <aminuddin.jamaluddin@intel.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Ismail, Mohammad Athari" <mohammad.athari.ismail@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Tan, Tee Min" <tee.min.tan@intel.com>,
        "Zulkifli, Muhammad Husaini" <muhammad.husaini.zulkifli@intel.com>
Subject: RE: [PATCH net 1/1] net: phy: marvell: add link status check before
 enabling phy loopback
Thread-Topic: [PATCH net 1/1] net: phy: marvell: add link status check before
 enabling phy loopback
Thread-Index: AQHYuFxMKg+SoAedC0ayqAwz26yoSq2/m/mAgAd8s1CAAEtqAIAYyijg
Date:   Thu, 15 Sep 2022 06:57:16 +0000
Message-ID: <DM6PR11MB43489B7C27B0A3F3EA18909B81499@DM6PR11MB4348.namprd11.prod.outlook.com>
References: <20220825082238.11056-1-aminuddin.jamaluddin@intel.com>
 <Ywd4oUPEssQ+/OBE@lunn.ch>
 <DM6PR11MB43480C1D3526031F79592A7F81799@DM6PR11MB4348.namprd11.prod.outlook.com>
 <Yw3/vIDAr9W7zZwv@lunn.ch>
In-Reply-To: <Yw3/vIDAr9W7zZwv@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.6.500.17
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4348:EE_|IA1PR11MB6372:EE_
x-ms-office365-filtering-correlation-id: 656df1cb-2de5-432e-539f-08da96e7867b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jwwGt5TWb4ujBuwz8yzG+kObF3S0gu4ktC0d4ZlAmqNIoeWlzze8o78mmBzZ9lWho1nEkKVDmGbZudIW99UsSekAPx9Nk+qUAMojpbaZq58rGciPesaKI69wn2hFZaP4du6fGfyabdlwPOHISQj4vbUkVipz/iR+zPBUuN66MoM3s5HwX6LFbFQJJIoNKug/mmdjGjTboTAB+Qm6lHLDIonux47cWntyokFuyclveXxVu1qskjrq19KtwddavqdqDQ55WbQK9hY+ngKnxFEK5O0WOrxBhsKGTIFjZbyoM7FQulfVe/cIsAqv/VHFN2C18YBXNeup9CEGy12b/6YCGJNjZ5FfG9HXYxpqtFxhb2grPWBJo9PrX/939qNxvGHj7ywCaRzZk/oEVfV2JMQs21dMF6/Nk2zK+3z+JxXYUzy27LSYp2TKPDqDXYIjtzn7czf78bglaT//d+j+K7aaKGnRDN6VrMF0ZQXttED4NVTQqueGbodvfjO2OkBhue93UQiC4B1Exd12vZF++JpYzZuDSaU/ReeoDNfAW5q1KLFKbn5yIvIOEmwa8opzlkpg1FmQLEH6fel1DqGRn1Fwp/0tSsXtXf4JNw8qXNFKShzcNaQB2k+D2miCVudbxzONGUtBlk5U7vML6BwxA4NRCSlNFwgH2ZAv6BG4zsA39D/TXXlxkKHuk0pNncb8Y+gzcP9w2k46p+DYe4oqNH1FwJTQ9vxU80LXmNEbiao4WDD/mJJQbnAKgq98E6SiZ0IOgcsoFzHK9+h3NH8bulXAf2WBLkX6Ff4ZVQsqPtiYZZx4d8NTOzH0ZTfNWcrqMnn4e7Wio7wFmeWjWIfADj1Sfw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4348.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(346002)(396003)(136003)(376002)(451199015)(52536014)(478600001)(186003)(8676002)(66446008)(107886003)(83380400001)(6506007)(38070700005)(86362001)(64756008)(66556008)(38100700002)(55016003)(53546011)(6916009)(7696005)(2906002)(26005)(9686003)(82960400001)(7416002)(966005)(316002)(76116006)(66946007)(8936002)(54906003)(33656002)(122000001)(71200400001)(5660300002)(41300700001)(66476007)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ITeqO4F8PgSN0EjI2wg9dty2dOYHN81GHSvdztVKiQ/Kvj9VRzQNKpQ9maon?=
 =?us-ascii?Q?pqNw+YI6JtR4EbjC4I7hIA9vx/Bgnel/wuNnU5iS19hfNFzoDk8dRWNTGOyS?=
 =?us-ascii?Q?YI7fsPVR+EFHqW3m0Ear7bUhEmj8xTR7fEIUiwEbzjTW5yF7+jjto+Et+hH2?=
 =?us-ascii?Q?qHZfGKutCpJK1fe4T6rTzKjEOR5qi5QiXcD72zJjRpmPCtBeY1B459Q3Voin?=
 =?us-ascii?Q?PmbavQIHcZvc8Tn015dwKj+dSSA8A3BeJWnCUaTfxUjS+TVbYq6QjrWWGldD?=
 =?us-ascii?Q?WoaIpnLe5EfLGnEENXLL83jZCI/BbuLBO6TPwjcW5yEJ6Tkw0wYEVYWyRSqT?=
 =?us-ascii?Q?k3ahF6uN+M2SMeJ3PtBrqr7wjOH8I0MFOHg2uZYHeB0rH1hdJcAK8F0mGU4B?=
 =?us-ascii?Q?5ccz6joP3E0olpYoUPv4w8Z49PVw8SzstzwpdUDAMX3QFi05rASG1HVm7WWl?=
 =?us-ascii?Q?D85783cDPTTcBSbWTPxaVOsJFOZH0bXDaNKDA+O6AoEUul870NhZmw/9urNX?=
 =?us-ascii?Q?mKNpKefrmBm7tFQ5VedrojQZjaF4KKlUVh4Ya7ompnvVZMiJJNxe4Vjp+Iee?=
 =?us-ascii?Q?f4XrjSqa3dGZ66CijeoN6MDGvv2JNV8g00N5MPybpmgkKLNd+Eq5U1T81Bpj?=
 =?us-ascii?Q?WBu1cJpFKfPZOlRAGHYOaCyuPFs024Yow1xmVm4edOcv5YKIgNyigbrwY5m7?=
 =?us-ascii?Q?qZgKflr+O/Zc/Q9vtngefr3lvIWUfTSw2Wo/qw0+1AFej4BAi15xNNo2h572?=
 =?us-ascii?Q?8yfhDQIMpYPuqgEzkIDyF36EAlYCDObSgO+p6MoIXf/ivQpUGTD9I5h2S5tt?=
 =?us-ascii?Q?jDHumcb2Ptp8R/JQ57TbP/MAEGyLUmSFnlb8Xg6vqkLTjVi2AWnesFXIVZT+?=
 =?us-ascii?Q?OmpPaTqK6HT8vc5008EtMj5d1OcPGa63qvrbrKGqMaJ1btdcDkhMYn/PJ1TI?=
 =?us-ascii?Q?5oMCHIvrlUyEBTypAbtZ1hBZVGsymPzLrA1V+oE2MU+vviA6LwOcXzoQb9Ig?=
 =?us-ascii?Q?Ce1jr+3OtfuQ//sDNm9ypUwBtkbnhEmM6Ae3AH3C7VC7zvS6glkTIHl8u41u?=
 =?us-ascii?Q?URVDCFK/8FhWFpjXwq4Bzu29QPcZXPqUc0AjiCTh/M48AXC3nXs27PJctyTy?=
 =?us-ascii?Q?sKjBn2/XZY2QW8Q2G4/sCp7IU2S6D87tJ6/4+dlpae+7m61hC0nvnMgcL/za?=
 =?us-ascii?Q?/XGxQAS+ThgYhlf4w2cWJ7QuwU75Ux6qG33WhEEq5anZ/FSy4lt8HZhfgsmT?=
 =?us-ascii?Q?daoMopAb1uz18RdTfz005hJbAFyQDiLHX1lzJqRnJcc3gcx3ZhAf4STYNDXu?=
 =?us-ascii?Q?GSMBUkLz8T9JvCN57Y49J5wjdjc7L5A+9FdfVIN35qVn29N3vLe2/0k25hkA?=
 =?us-ascii?Q?9BBTpTlsXYu8rx2ql+B7u8LmQKupM6j8XQyrOLcqgCyWySKEbp06rECvGbSF?=
 =?us-ascii?Q?tdZMnHw6/apYniZSNifpxED4gq9jtqihMioePGX/LTzoLMvzqgmKeySj8z7U?=
 =?us-ascii?Q?oGfZwwkeHMVDHJjlhXsYCsdqSSh7Taa2ZGLDhplp5C/X33VYrsDoWSqh2rxX?=
 =?us-ascii?Q?ky34RHIvSurNPr5wvwiXFwtBFV5l1+qRb3l4fyBIpcKbEChOVjg/+jmxfYxK?=
 =?us-ascii?Q?Sg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4348.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 656df1cb-2de5-432e-539f-08da96e7867b
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Sep 2022 06:57:16.4031
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: e4fgZxUVKoGNgmnVfwV55HUvif5KLRjoIJiGe+FKDXWBOe4iKJ50j4QyLgZlB8rENDErBiHcP+2ttir9SlNEcreDLs5pB+GSrbEyuHCzPzM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6372
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

> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Tuesday, 30 August, 2022 8:17 PM
> To: Jamaluddin, Aminuddin <aminuddin.jamaluddin@intel.com>
> Cc: Heiner Kallweit <hkallweit1@gmail.com>; Russell King
> <linux@armlinux.org.uk>; David S . Miller <davem@davemloft.net>; Eric
> Dumazet <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>;
> Paolo Abeni <pabeni@redhat.com>; Ismail, Mohammad Athari
> <mohammad.athari.ismail@intel.com>; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; stable@vger.kernel.org; Tan, Tee Min
> <tee.min.tan@intel.com>; Zulkifli, Muhammad Husaini
> <muhammad.husaini.zulkifli@intel.com>
> Subject: Re: [PATCH net 1/1] net: phy: marvell: add link status check bef=
ore
> enabling phy loopback
>=20
> > > > @@ -2015,14 +2016,23 @@ static int m88e1510_loopback(struct
> > > phy_device *phydev, bool enable)
> > > >  		if (err < 0)
> > > >  			return err;
> > > >
> > > > -		/* FIXME: Based on trial and error test, it seem 1G need to
> > > have
> > > > -		 * delay between soft reset and loopback enablement.
> > > > -		 */
> > > > -		if (phydev->speed =3D=3D SPEED_1000)
> > > > -			msleep(1000);
> > > > +		if (phydev->speed =3D=3D SPEED_1000) {
> > > > +			err =3D phy_read_poll_timeout(phydev, MII_BMSR,
> > > val, val & BMSR_LSTATUS,
> > > > +						    PHY_LOOP_BACK_SLEEP,
> > > > +
> > > PHY_LOOP_BACK_TIMEOUT, true);
> > >
> > > Is this link with itself?
> >
> > Its required cabled plug in, back to back connection.
>=20
> Loopback should not require that. The whole point of loopback in the PHY =
is
> you can do it without needing a cable.
>=20
> > >
> > > Have you tested this with the cable unplugged?
> >
> > Yes we have and its expected to have the timeout. But the self-test
> > required the link to be up first before it can be run.
>=20
> So you get an ETIMEDOUT, and then skip the code which actually sets the
> LOOPBACK bit?

If cable unplugged, test result will be displayed as 1. See comments below.

>=20
> Please look at this again, and make it work without a cable.

Related to this the flow without cable, what we see in the codes during deb=
ugging.
After the phy loopback bit was set.
The test will be run through this __stmmac_test_loopback()
https://elixir.bootlin.com/linux/v5.19.8/source/drivers/net/ethernet/stmicr=
o/stmmac/stmmac_selftests.c#L320
Here, it will have another set of checking in dev_direct_xmit(), __dev_dire=
ct_xmit().
returning value 1(NET_XMIT_DROP)
https://elixir.bootlin.com/linux/v5.19.8/source/net/core/dev.c#L4288
Which means the interface is not available or the interface link status is =
not up.
For this case the interface link status is not up.=20
Thus failing the phy loopback test.
https://elixir.bootlin.com/linux/v5.19.8/source/net/core/dev.c#L4296
Since we don't own this __stmmac_test_loopback(), we conclude the behaviour=
 was as expected.

>=20
> Maybe you are addressing the wrong issue? Is the PHY actually performing
> loopback, but reporting the link is down? Maybe you need to fake a link u=
p?
> Maybe you need the self test to not care about the link state, all it rea=
lly
> needs is that packets get looped?

When bit 14 was set, the link will be broken.=20
But before the self-test was triggered it requires link to be up as stated =
above comments.

>=20
Amin
