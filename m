Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD425F1047
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 18:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231705AbiI3Qvb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 12:51:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230053AbiI3Qv3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 12:51:29 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DA38198698
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 09:51:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664556688; x=1696092688;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=bDcva/hLO2VF2KDBun08RQz65IEf32x3BA2/JF5Kzhw=;
  b=gAshMlWJYJ8veDIkZzc/HtJZOhbZCKmjd0hkJI9AqaeAT5jMsdXnzGUJ
   vbDQwxDuI4O/EvtLMq1/BzqRVvMpQmpLQhZlempAGeniy9QKaP1dhMw2Y
   /rXLEMTsDfGr+Jd46irC7MfLFWwWmjd2wCCZh1FgDurw/apiH35WVj4Vg
   z1O1OdN3bhPbyqnOCI8snkHLRPGHVc1tzRrB5hAgytW4iVLpdstc2g/hx
   OxDi9aomgCx9L+RrzILULuycXZFA6OFCedAwe/XBIhBEuVwTtoHfCAhyI
   bQ+QMK5UdZSCuazltAa7XjMPFac/fFleE4lUXUeLwKx6zh/RqnTI2tXTA
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10486"; a="302210579"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="302210579"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 09:50:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10486"; a="711861771"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="711861771"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by FMSMGA003.fm.intel.com with ESMTP; 30 Sep 2022 09:50:11 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 30 Sep 2022 09:50:11 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Fri, 30 Sep 2022 09:50:11 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.172)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 30 Sep 2022 09:49:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RmDyWmSfm21/3EDt31upuhTP+atF4Mt/ea+vcOcFUCRyIdS8lUscKeVvp54NI0b40/E+Ecap9oAYh9CoGFE/lDOQhBoSMXi7YjVooNMLJ/UiVQaUuGFI0BdiwNEuhH6mkzLFr3VvycYhwD5J0M0IFPB031LYQaomF4ExXZ5uwfV3HOyU1WrN8pjirJrBysJgxBil80P6sQ/lsRj583KXNB11dIKxCHudma5vAqO+Eo4Hln4H5CwXgGXePXeUvAYoC5V9xQ5pVTNA5cRTYQn5ZWuhIpovTM66mQ1YU5iK1qJvyeI99Orn8K7tKMswYmHb15jEf/HavW9JgZPX40pQRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P9UjASfONNr6bVgdW6QnJ8Dzqv6mSCxUcZDNheH66MI=;
 b=Hj/HlCbnq6uRYwG9+4+oUjxWkyIrJ0Kag6MfS5NGuz+ek6EEm96vvEXssAX7yrRwGQ5uVTLgTW9rsmkTTCXI4paHXhNvOxqYtb/+eseDL73bNfDv6Nhrei8Rmpv0WyVgMcNV8R+00CUkv1Zl5Gi1WlhYkDB5jjnbhTh7lqmc+yFCeUM6NsnJb3eDzISIOvDf386LAuFSA1+KJpr8rXtIXXzbmRuxECUqQg4xDD1+08YyGl0U/wUzDhOU7yaziKUnwVazF09oXtzjhdKgLraFaBfTtOTkzk3gtm1ZFPe75zgl/67KTbVCZ6icIaM3XGQatk7P//t1Vw5C3tQDVEztOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by MW3PR11MB4523.namprd11.prod.outlook.com (2603:10b6:303:5b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.19; Fri, 30 Sep
 2022 16:49:44 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::47f1:9875:725a:9150]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::47f1:9875:725a:9150%8]) with mapi id 15.20.5676.023; Fri, 30 Sep 2022
 16:49:44 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>
CC:     Jiri Pirko <jiri@resnulli.us>, Michael Walle <michael@walle.cc>,
        "Heiner Kallweit" <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: PHY firmware update method
Thread-Topic: PHY firmware update method
Thread-Index: AQHY0y1TlZftc25x0kaRSZx+auW9oa30xUOAgAE3t4CAAFqNgIAAHQqAgAALd4CAASXhgIAARliAgAAkCgCAACD6cA==
Date:   Fri, 30 Sep 2022 16:49:44 +0000
Message-ID: <CO1PR11MB508991C08616EC6AF8CC236CD6569@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <bf53b9b3660f992d53fe8d68ea29124a@walle.cc>
        <YzQ96z73MneBIfvZ@lunn.ch>      <YzVDZ4qrBnANEUpm@nanopsycho>
        <YzWPXcf8kXrd73PC@lunn.ch>      <20220929071209.77b9d6ce@kernel.org>
        <YzWxV/eqD2UF8GHt@lunn.ch>      <Yzan3ZgAw3ImHfeK@nanopsycho>
        <Yzbi335GQGbGLL4k@lunn.ch> <20220930074546.0873af1d@kernel.org>
In-Reply-To: <20220930074546.0873af1d@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB5089:EE_|MW3PR11MB4523:EE_
x-ms-office365-filtering-correlation-id: 072621bc-dc72-4e29-be94-08daa303c6d9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sd0SiGv8h+HUdGHbYb4aONPM6k1QPDz6sMdrKiSFlpYLQKz68nclSQiEzin/rv9QGf79pudtoOH3CLblzE1TFFNVrmKHEmo0Yb51acWc6RviA8ffHQuGs4Er8yPJqI6JcemDFc6iG+RowTlhSW5dT2HdtUpKTBGpm+T6SPjYTWbIDjtOMpBtFwMiKv+df8svq9KVAAgG6sRVc5o6Au597/6OBbqrnXxYbFKgLWfFbcFlcMWHF06F80//LSdHU15v7nPjDNmT5AYjsEWhQkpZ2p4og/kL3HI9ebn4gqQoXKlaxt0+uroYJ8RVykfMF3sAFK9v6aokFz9GTw7ecjMTjSSE4egN/Gs9To1JR4K2fgj7x6CturX39t8LU9jGNctyvq7VP+ho9DJ5osnPWO20FEV4C5zkE21BGII87CEAadf+/urK1NF9/BBVtgSalPVS2UJgx5So3eus+JSkSrkkBHE29pmfhZdIYL3NjxzV7w5vF1TMvZowPE+uOgPzoARRwLMMkHnZlyC7SFRdfddFDFPzeBW9sSumOu6ptzRm8sG3fqClpKsb2J8ajfPCu5brgXTf5XgEyE31wOoQk2uxcwl2dubreDwj0vDOEE+Dsjr0ngwPpPLiFQYPA/wkPYWmBDsm+90xuh5AsjhOnaQTC8x4XIhGKCTkKLpSibnguHXtBIQKa1fG1IAB72XWrlnw1aXtRVcjQmkSXriwwqXiag6WswKq96B4OTaUAQmykH8s4vAN4tppPEcwYTfWNWIOrEJAlffAn0KIIjwYiyQRc0rGphPhFb/FqUl8jZ5wZuQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(346002)(396003)(376002)(39860400002)(451199015)(26005)(122000001)(9686003)(966005)(55016003)(38070700005)(38100700002)(71200400001)(478600001)(316002)(7696005)(86362001)(52536014)(41300700001)(3480700007)(8936002)(110136005)(54906003)(2906002)(8676002)(6506007)(53546011)(5660300002)(66446008)(66946007)(15650500001)(33656002)(186003)(76116006)(4326008)(83380400001)(66476007)(66556008)(64756008)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?OtlrF85UFs8TCxA/VZFr+z6O/GshV/aZ6PVz+cdy/qt1VfuUBllxRJsRLjAu?=
 =?us-ascii?Q?bsXezwrlWPsphP8uczSRGoj2Uo11SkaNs/Rct65k2z/bZBE54iBXu97Z6NlE?=
 =?us-ascii?Q?sXkrvLfPRcnuV9epSbO3+ihN1FDn1IjVVkL4WVSGSY47Mc8xxpgS7eg49r+9?=
 =?us-ascii?Q?+Z2xNY/9ubyYD87fXabBsHJ2aEfnUFVv2LfT90aq71xpm7SXk14V2CTBcraI?=
 =?us-ascii?Q?A8zRozvSq35rLS8bN00PPj73Cc+tnYoDrbDYIrAQn9UZ2Y6McoVuFGzbRk7+?=
 =?us-ascii?Q?bDX5K8RaShXNSQ/gDb7RWrz06Z5EkJx5PQWBt1aAFnljOJ+Wl9TTf3+hEeTZ?=
 =?us-ascii?Q?gzHqBDwftbV8WhsFyBybX51JiIRnf/g6rvn9MsclGa7RFYO7X3L2Z7WocS5F?=
 =?us-ascii?Q?pm//cFyz3b9UI3VMtZImEEszxKKmTP6QkT33amOH5VoOMM3Fbrn4QNB/5++i?=
 =?us-ascii?Q?J3DjylxkCbXfl0xMw/Y/RSfOBu4PtFtUFg9/LcAx7UG3h2Eh+CQHqT+yAS1L?=
 =?us-ascii?Q?FfOJI21mP53eCdUkiT2L6v362cDul3v4wH4G70w6nRIgqDvagveSdIQopsfT?=
 =?us-ascii?Q?OZpFv/wFv/pSlFD1aG2Kvf8cC0dgSq2ZuEcAh+LD1LbjFdNY+suSIM8I4KAk?=
 =?us-ascii?Q?bYexbTSR3JVhMAWr3kFbE/zAzlZsQ1wAMFt+XUKDWwJliyz6+m01A3fGdaTX?=
 =?us-ascii?Q?3RoTgbR4RCs0x9ykIu4s2ZHz2uhCVB4uoSirNPGS0qGRbc6/Ci7h5okjVsWj?=
 =?us-ascii?Q?SOKsBOIEuAUZR6YDyMFwvV/CRHeAm8IIcpNwbDdzj9GT/S1MTZsyKlapsfKX?=
 =?us-ascii?Q?tKAGKx4OH1oFQSA94uP4uVQWAREqKg30w8cO5/1HgwJSyKRsxIcXwGMFNNKX?=
 =?us-ascii?Q?VYvwmmbxSIehYOrDSe966O+aRvTOQrryEQx2cTR5lmJGB1S28PQ3nW9Jc092?=
 =?us-ascii?Q?C2UfkKIgUzalzga054R/szLfYJzgnE0T8hGR16qOMk2fbxjI9aLO8x0yRCOa?=
 =?us-ascii?Q?vCEB79AiZZhKJcwH2NWNtvIC/uWzZ+KeHG0ZtxrjOn3i29TsyCNJIhNiDhpo?=
 =?us-ascii?Q?qbeAvFLA55owkZUOnEzyzl3HBVuKYw91GaJ4DWIZrHrVFuLww1hjE5KtIxOj?=
 =?us-ascii?Q?J1akFqUtwF15VRytRSCMqzvGfcZz782J2wPnKYdkiavyC3il2X62MtdR/YMr?=
 =?us-ascii?Q?PCbEBJxhM7PE1VlY3Lq55pB+kTUjl05wbHRSr1rJXCFfzY7CkH1ZfMftf60q?=
 =?us-ascii?Q?flOU1FO/6JgYJDJV1bvYciZ877YJOBQLNfCzyIbmRodCuQIHNR8m6E758rqU?=
 =?us-ascii?Q?ocxyijgZLP8LOE8TEO0FedvqxmVoTIO75NY9f2BlGnRAL4271SoMpI0PT04T?=
 =?us-ascii?Q?gwJ+LNvQKT7WMOuOukKHQGiRH2E55qwXEUOB54NjwyISVxYBGVMhnXImwYEN?=
 =?us-ascii?Q?UE+jhDkT0oM3WvvkZfbt1gdIefGfRYZi/Wbr48BKpMGzTGFfKqN4HIrFlneS?=
 =?us-ascii?Q?UMxnvSj0eKzAOxY5y7UTKL+mICGsxTUF8Oew+xEJ1gcEQJYvIPLD/StcgxwM?=
 =?us-ascii?Q?9GcvUUBc68faEzpipKSWHi1Nx6wMFxVDs+wVDUm8?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 072621bc-dc72-4e29-be94-08daa303c6d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2022 16:49:44.2422
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zuupLLWuFMU2tmYW9VB8iz27oVLjppVRwqNYcn0hs2hur0kS7QQamya1mJ6gyTkcuy70E9R4z4o4ZsWFy0FW1EdqjnSF2RReaj8KKLXQ5QU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4523
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Friday, September 30, 2022 7:46 AM
> To: Andrew Lunn <andrew@lunn.ch>; Keller, Jacob E <jacob.e.keller@intel.c=
om>
> Cc: Jiri Pirko <jiri@resnulli.us>; Michael Walle <michael@walle.cc>; Hein=
er
> Kallweit <hkallweit1@gmail.com>; Russell King <linux@armlinux.org.uk>;
> netdev@vger.kernel.org
> Subject: Re: PHY firmware update method
>=20
> On Fri, 30 Sep 2022 14:36:47 +0200 Andrew Lunn wrote:
> > > Yeah, I tend to agree here. I believe that phylib should probably fin=
d a
> > > separate way to to the flash.
> > >
> > > But perhaps it could be a non-user-facing flash. I mean, what if phyl=
ib
> > > has internal routine to:
> > > 1) do query phy fw version
> > > 2) load a fw bin related for this phy (easy phy driver may provide th=
e
> > > 				       path/name of the file)
> > > 3) flash if there is a newer version available
> >
> > That was my first suggestion. One problem is getting the version from
> > the binary blob firmware. But this seems like a generic problem for
> > linux-firmware, so maybe somebody has worked on a standardised header
> > which can be preppended with this meta data?
>=20
> Not that I know, perhaps the folks that do laptop FW upgrade have some
> thoughts https://fwupd.org/
>=20
> Actually maybe there's something in DMTF, does PLDM have standard image
> format? Adding Jake. Not sure if PHYs would use it tho :S
>=20

PLDM for Firmware does indeed specify a standardized header for binary imag=
es and could be used for PHY firmware. The PLDM header itself describes thi=
ngs as components, where each component gets a record which indicates the v=
ersion of that component and where in the binary that component exists. The=
n there are a series of records which determine which sets of components go=
 together and for which devices. I don't think the ice firmware files use t=
he full standard as they always have only a single device record, though th=
e lib/pldmfw codes does try to allow the more expressive ability to support=
 multiple device types from a single binary. Specifying a PHY component wou=
ld be possible, and you could fairly easily prepend a PLDM firmware header =
on top of an arbitrary binary.

Thanks,
Jake

> What's the interface that the PHY FW exposes? Ben H was of the opinion
> that we should just expose the raw mtd devices.. just saying..
