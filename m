Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E27B5F06DF
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 10:52:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbiI3Iwr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 04:52:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbiI3Iwo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 04:52:44 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAB89166F2F
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 01:52:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664527963; x=1696063963;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=P98jsfE4nr6h8EdI+4xbGPy7gs6+gvJhFsqOJKcyrxE=;
  b=kDolbLYvvLJ8NgL4I2PYM/eB58O9q/GB/hCacvyrUoYCLqWZMttsdX03
   u2+0jum1dPObyfiOKCpmIQXUmDjKAFKOQiU2JlwVGXdQef2lfmYKiSsyj
   hzBkc/IGwbrKMil0xymVY/CSa/pqpH4CieAGh/oGreguKgxyUPItA9R0F
   LbTNtcB7Ykv7RIIyXICZ0E7aeIvO2i2LbYHNpb7UFxOIRZSdTKCE2tNp3
   BiAFfT9BknKhNtGDd1JCW97CTmR1iop6UvRStpkU1eRWY5w7XBy652qfR
   zq1Hs2NSSn5Hza8S3Ho3YPKSb5jbQ8lJxD5FhEwrwptfeAmeMncKLMl2B
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="289306001"
X-IronPort-AV: E=Sophos;i="5.93,357,1654585200"; 
   d="scan'208";a="289306001"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 01:52:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="726783861"
X-IronPort-AV: E=Sophos;i="5.93,357,1654585200"; 
   d="scan'208";a="726783861"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga002.fm.intel.com with ESMTP; 30 Sep 2022 01:52:41 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 30 Sep 2022 01:52:40 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Fri, 30 Sep 2022 01:52:40 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.170)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 30 Sep 2022 01:52:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mw7Hkn902tVjEpxWzKM83/no6mxsRA0l0MtjphWUyTcloP8DiIfHujrmtxFysABMNG7WUlNPNBYlSWajoosgnvSS/XDWe/tI7VCuXEtr7eDCt4JWWkg5hKEhykBTtaMLWZXMoOJh388mOwb03jBWD+zPHjmJG41M0HW/Cd/fM/FP+EXz5jWGYrywaFtm82CbPUX1Sxsjdg72BXqEcxVd+qwmi2gA3f4L8I2IDnRRghNNAbjocjzPQ0jhECCxsTG5R61na2teqagCWE09suTEtpAaM28DR996KotPx96dJM3EqIOG1AxMJ/ic8547OTgS6VodGtToDah7fxOvh++8Nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P98jsfE4nr6h8EdI+4xbGPy7gs6+gvJhFsqOJKcyrxE=;
 b=E7KPF8Phd3+YLzzurpiDI2/l/pK8BuzJkYZQOlOqve6YdyRRUujsCqYtrFMZgiVcvjo1/9CMIsgWEtkzw2IBhpM7uDDWJvJOAuyjGQbVAmg+LJcwvklP/gLrC0KVtBBhB65NqMy/2Q2sYQxls+E4cWO7BGzMpg9rBoOGSsbVUlku1MLEmS+iTBggLnkkPG6Zxnjf0EsN0h7NaNnz7tHNNepUNKbhTJVS9IoGtPeWkEMrn8YVjukSYCSKSuCtTRlGsXQe3zaO3Rn//ugWhBzHmwWwnUcB4VDPi84txLs0ZGVnURVGSCsy4Kww18TmVERff51yDBWEA7FZ53jUBlFmFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6180.namprd11.prod.outlook.com (2603:10b6:a03:459::14)
 by IA1PR11MB6396.namprd11.prod.outlook.com (2603:10b6:208:3ab::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25; Fri, 30 Sep
 2022 08:52:38 +0000
Received: from SJ1PR11MB6180.namprd11.prod.outlook.com
 ([fe80::7c03:1c40:3ea3:7b42]) by SJ1PR11MB6180.namprd11.prod.outlook.com
 ([fe80::7c03:1c40:3ea3:7b42%5]) with mapi id 15.20.5676.020; Fri, 30 Sep 2022
 08:52:38 +0000
From:   "Zulkifli, Muhammad Husaini" <muhammad.husaini.zulkifli@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "intel-wired-lan@osuosl.org" <intel-wired-lan@osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "Gunasekaran, Aravindhan" <aravindhan.gunasekaran@intel.com>,
        "Ahmad Tarmizi, Noor Azura" <noor.azura.ahmad.tarmizi@intel.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "leon@kernel.org" <leon@kernel.org>,
        Michael Chan <michael.chan@broadcom.com>,
        Andy Gospodarek <andy@greyhouse.net>
Subject: RE: [PATCH v1 0/4] Add support for DMA timestamp for non-PTP packets
Thread-Topic: [PATCH v1 0/4] Add support for DMA timestamp for non-PTP packets
Thread-Index: AQHY0nIwdgyUAXnuBEqr/9DPT40VFK3z+DeAgAG3sRCAAMGugIABJtcA
Date:   Fri, 30 Sep 2022 08:52:38 +0000
Message-ID: <SJ1PR11MB61808A055419C257F6B653CCB8569@SJ1PR11MB6180.namprd11.prod.outlook.com>
References: <20220927130656.32567-1-muhammad.husaini.zulkifli@intel.com>
        <20220927170919.3a1dbcc3@kernel.org>
        <SJ1PR11MB6180CAE122C465AB7CB58B1BB8579@SJ1PR11MB6180.namprd11.prod.outlook.com>
 <20220929065615.0a717655@kernel.org>
In-Reply-To: <20220929065615.0a717655@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.500.17
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6180:EE_|IA1PR11MB6396:EE_
x-ms-office365-filtering-correlation-id: c8036c4f-5b29-4a99-1f94-08daa2c120ad
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /HuJ7ym489hckhqjlDVRGjrSh+7rjP2LTkbJhHflQiOp5UgDR+QBYwOrVY5oFwvsqTEpPjd3vi0eOnwTXYLsJESNY3dSF6WR/Tbt2k/Ywa4h5xYXtaR6PDYqj0BhhmimFx04cGp1QOAUqjoC+GMz59z51K7x1RYxMqugKB29NQmofGw9nN1EyVoNKtti4RT8uBjAscWDsOcf0xumD44BxlYdW3q6VxXJAG6bFLn+Yz6ErJnaaip9zVATzM5Ec0UEej1Kqkg7LybXe1Qm+r40yNX5vGsXVom7INWaf+jnsiIR1LEEmUY0lnfIy9bTQt7MxAFxRP5EYVCa1VUl8KPbcUkTJxgniY0kE6hTSYGpbJT6iNftElyIfsJiR1hxDZgWR98fnGVmwlIn+5vfZqPWMif7McYkugbqkmuhKqQJmhhjCSxpnRDV9Xvuo8Jr/MrOQSS2IDbtR2aY7clv0c+EWZvevHvRS4gP4rmYbhALClmBPM7x7zYIY+KfxuPuj9sPyCEwMitVfKMwPEMaGs2yUHYwnvsHV8cqKhdLYAK8vh/L2pfnpedb/8eVe3zKtoQEWA5UtcY0xNlzh4K2RxVqdrTyLjXBGSxv7llTrpPn1vTby4lRwq5bONFvpLyv08MyITPqOcn9UUe7IozE0YH0/Ta0T43ijIORyjqfG8IOdSKIu9fwNUF4Z1z2XPPBfvAxryva0uyDGw1LW2xfURlij/XuM2p8Qb63JJPl5LlQcbCW20r3DzyjIbOkktvsc/3ivOeAaXDPcUn/y7NKaM9J23LSSg7AGlammk688I0r8Jk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6180.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(366004)(396003)(39860400002)(136003)(376002)(451199015)(33656002)(7696005)(64756008)(66446008)(8676002)(66556008)(4326008)(5660300002)(8936002)(66946007)(38100700002)(86362001)(38070700005)(82960400001)(2906002)(66476007)(9686003)(186003)(26005)(52536014)(71200400001)(41300700001)(478600001)(54906003)(53546011)(122000001)(6506007)(76116006)(6916009)(316002)(7416002)(83380400001)(55016003)(60764002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Z6iIPMBM40awQ5noYA8ycY+Y9cRbwycGFMxW3tC2H0RjpPEUXtRCON7ETGYA?=
 =?us-ascii?Q?MrZZMiaMyr4n0etLqtrASnensMgeGlqRD5J6uoJ1eBmP1PTiIONiSWemVAUK?=
 =?us-ascii?Q?urNVkwiv4nM4wJQRWMWaq0Odj1AJVzGr4EELpsMtNxiuVZjDbgo+80AMjLaR?=
 =?us-ascii?Q?90/VplTJjesRLl+CwQgJKrkyctcXTx62lO2+/Guw8wFsjn4hT/ZPIYFYtyEt?=
 =?us-ascii?Q?g073PE06tMT4vbGiXhtA+pzB9EaC8lG30crlhMsKXG5zMTo59oljOMU3cFG+?=
 =?us-ascii?Q?8P0TfUQLYo7PuY6wpoZcA0csgzRh6D+/te42zZ5eHwEoWO2WdMbzamaLMO5V?=
 =?us-ascii?Q?5MDa5sAcC8lNlUvQLYGVNjlccBEv5TbXEF9IYlTxXGv1siph5AejY04uZ088?=
 =?us-ascii?Q?ntVMNLIOukMi1QJeDHZ1iHslunrdmwcaHr4N5bwl04gfcnV4ctpzKPayJ5Za?=
 =?us-ascii?Q?3UqjyqH6yDaGigvcc3kbU6yBqMhAyAPdOGvi0hike7JFXj7/1pqtlcn7yh0M?=
 =?us-ascii?Q?wxtSksY9BvYcvCeEdDDvmy3EahBP6n0p2ByWNiYw/T4eVI9nqAvBpX2scPP1?=
 =?us-ascii?Q?n+cLl+vhrhXhscTMOSavHuKXkbCSxnXlQSAd/mYjtHLL+TJjqs8h4jWVZv1T?=
 =?us-ascii?Q?ZCfJ+YYk/LlsIj9MHKSg3KxrtKzNX3CTHQcNmJvfF70Fu4mRJURT+42ZYSuI?=
 =?us-ascii?Q?RGmB8xgPSnDYT6p6hTFbNXDrJ8ZT1fK1mjvdoacpUGENWxnfXHTBWCSWNWJL?=
 =?us-ascii?Q?09lkJWPYtemwH9yfqFJnIY78rhr5aeTfvd70s9e4Bow0F0AjWitGo1FBiWJR?=
 =?us-ascii?Q?uqaEgqS5Lrc1k5e4hvx970uOVs5ptA8kjhaz4e61HbzjyrpoQLG8Ajgf9EI5?=
 =?us-ascii?Q?DFXZ2DkG3YvZiI0p9f1TVlzxR8+7wMg9GF73HJscjrcKrkhrAF5DG3TkmwS6?=
 =?us-ascii?Q?i6yIpKEBuRWXHj8hupZB9SXJorWdPQLFIHW1tgpz4G+WmCzcoEdD6gHLyZRq?=
 =?us-ascii?Q?RNIAzlE/VhxICPbl3AAz5ti+tUzRBGQjx3anEcp+N8wnM4xNw6UuuP737imV?=
 =?us-ascii?Q?mCqFHBMMKbe3duK/AsfqBvwKGa558OgZ5bbGvqpaZZnxSW1MWxq64xtYjVIq?=
 =?us-ascii?Q?wauHQGbpFDU/LtVU1cDaBNtirE/ffZ5KGuR7fkHdt/wbQ8XASq8dII6Bg6CT?=
 =?us-ascii?Q?wKNbf0Du/Yz60oHjtS64Iq7h4uJrmjw2r7oCri+pX8a/PcL2+Z5aISlm5s27?=
 =?us-ascii?Q?/dtq8tc8GtwjP4SzZKkubu213CW0vYvtJOrLg1Shqdpan7UyNb3Nr3f3wLoA?=
 =?us-ascii?Q?cS04MNogO1KUwFevI8fsU4Ep0ddxVI9eoJQTItyEBAMPRcRg+ON1oTZQvT42?=
 =?us-ascii?Q?ursINm2uQ8EFmCR6CwCzvcdZXrPKI4188UrJhDf2pu3ieZwf5qDFadPe+Qaj?=
 =?us-ascii?Q?77eXw6vlQ9Gb226UUB5lmF2zsOxGe9EvLPnRIweedjuVjxcjNi+o1UPKpjP+?=
 =?us-ascii?Q?fTX7veh8FEeKQepVTWJ/7ivwdKg5X6Bda3qVlsK179X9PItOa3xoi5Lu0kv1?=
 =?us-ascii?Q?WZEppf7aK0lyufJQmkBVgwtNXouNaigUpg1wRjRJU2xrNuGAE/c/1ISugnEM?=
 =?us-ascii?Q?o6qHmoYREJMRJIb2zaaAfH8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6180.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8036c4f-5b29-4a99-1f94-08daa2c120ad
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2022 08:52:38.6482
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NxmlNTQyRWnBGZtqe6Q8uTD2lTZDCF4aSVNTAcVX9RCKwIah/4VbspQ7gdVR0RJft9JA+UWFJVB1Du83U89GGYrAayHNJVAwRosyeYb/cosY5Gk3cI0SayOy93d5byPc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6396
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Thursday, 29 September, 2022 9:56 PM
> To: Zulkifli, Muhammad Husaini <muhammad.husaini.zulkifli@intel.com>
> Cc: intel-wired-lan@osuosl.org; netdev@vger.kernel.org;
> davem@davemloft.net; edumazet@google.com; Gomes, Vinicius
> <vinicius.gomes@intel.com>; Gunasekaran, Aravindhan
> <aravindhan.gunasekaran@intel.com>; Ahmad Tarmizi, Noor Azura
> <noor.azura.ahmad.tarmizi@intel.com>; Richard Cochran
> <richardcochran@gmail.com>; Gal Pressman <gal@nvidia.com>; Saeed
> Mahameed <saeed@kernel.org>; leon@kernel.org; Michael Chan
> <michael.chan@broadcom.com>; Andy Gospodarek <andy@greyhouse.net>
> Subject: Re: [PATCH v1 0/4] Add support for DMA timestamp for non-PTP
> packets
>=20
> On Thu, 29 Sep 2022 02:35:29 +0000 Zulkifli, Muhammad Husaini wrote:
> > > High level tho, are we assuming that the existing HW timestamps are
> > > always PTP-quality, i.e. captured when SFD crosses the RS layer, or
> > > whatnot? I'm afraid some NICs already report PCI stamps as the HW
> ones.
> >
> > Yes. HW timestamps always can be assume equivalent to PTP quality.
> > Could you provide additional information regarding SFD crosses the RS
> layer?
>=20
> I mean true PTP timestamps, rather than captured somewhere in the NIC
> pipeline or at the DMA engine.

When SOF_TIMESTAMPING_TX_HARDWARE is been used, we guaranteed a PTP quality
Timestamps (timestamp capture when packet leave the wire upon sensing the S=
FD).
As of SOF_TIMESTAMPING_TX_HARDWARE_DMA_FETCH, it is not a PTP quality becau=
se
the HW timestamp reported in this case, is a time when the data is DMA'ed i=
nto the NIC packet buffer.

>=20
> > According to what I observed, The HW Timestamps will be requested if
> > the application side specifies tx type =3D HWTSTAMP TX ON and
> timestamping flags =3D SOF TIMESTAMPING TX HARDWARE.
> > So it depends on how the application used it.
> >
> > > So the existing HW stamps are conceptually of "any" type, if we want
> > > to be 100% sure NIC actually stamps at the PHY we'd need another
> > > tx_type to express that.
> >
> > Yes, you're right. Are you suggesting that we add a new tx_type to
> > specify Only MAC/PHY timestamp ? Ex. HWTSTAMP_TX_PHY/MAC_ON.
>=20
> Perhaps we can call them HWTSTAMP_TX_PTP_* ? Was the general time
> stamping requirement specified in IEEE 1588 or 802.1 (AS?)?
>=20
> Both MAC and PHY can provide the time stamps IIUC, so picking one of thos=
e
> will not be entirely fortunate. In fact perhaps embedded folks will use t=
his
> opportunity to disambiguate the two..

With the help of SOF_TIMESTAMPING_TX_HARDWARE, we will get the=20
PHY level timestamp(PTP quality) while using SOF_TIMESTAMPING_TX_HARDWARE_D=
MA_FETCH,
we will get the timestamp at a point in the NIC pipeline.

Linuxptp application uses SOF_TIMESTAMPING_TX_HARDWARE for their socket opt=
ion.
And this can guarantee a PTP quality timestamp.=20

Can we just use a SOF_TIMESTAMPING to identify which timestamp that we want=
 rather=20
than creating a new tx_type?

>=20
> > Sorry about the naming here. Just so you know, the DMA timestamp does
> > not quite match the PTP's level timestamping. The DMA timestamp will
> > be capture when DMA request to fetch the data from the memory.
> >
> > >
> > > Same story on the Rx - what do you plan to do there? We'll need to
> > > configure the filters per type, but that's likely to mean two new
> > > filters, because the current one gives no guarantee.
> >
> > Current I225 HW only allow to retrieve the dma time for TX packets only=
.
> > So as of now based on our HW, on RX side we just requesting rx filter t=
o
> timestamps any incoming packets.
> > We always allocating additional bytes in the packet buffer for the rece=
ive
> packets for timestamp.
> > It is a 1588 PTP level kind of timestamping accuracy here.
>=20
> I see. I think datacenter NICs can provide DMA stamps for Rx as well.
> Intel, Mellanox, Broadcom folks, could you confirm if your NIC can do Rx
> DMA stamps?
