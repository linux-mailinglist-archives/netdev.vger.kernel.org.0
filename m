Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ECFF5A8747
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 22:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232187AbiHaUJv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 16:09:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232194AbiHaUJl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 16:09:41 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72000EE6A4;
        Wed, 31 Aug 2022 13:09:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661976570; x=1693512570;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=J+oHj258BvEFo3Hgudi6m8yyaVCBa1y6Q8ShWbl1LHw=;
  b=m/LWOgrs1fq1Oq6+zj8kpZfJHLpdxM+SgHy69DkpdBrGe5ubsEXISsAp
   4/6acutb5eaVRsBszuXC/c93CTL4J5OosBx79QFHlQLW9O/9DXKDU9PZH
   yt6gSJY7LM8QnB76EXRF8pEqUdoYP5sYIcBHgj6s/PyRz6pXDlXT6l+0G
   0cWTegW4E32e8qMlkI5HKcOo0BNbyUEMk1uQ09jZ+h46m2SsgBbeiikO5
   rrYrkBGBQV98u0E7gwXfD/CljapCkmzYIe3PwV3G1P0Ba2rIHLBBbyT97
   dMtKpMQnqjKx3+knYZOR/sMDl7D0AyBRgEk83hfEMrB1RwTbUMGzBheO/
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10456"; a="381830794"
X-IronPort-AV: E=Sophos;i="5.93,279,1654585200"; 
   d="scan'208";a="381830794"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2022 13:09:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,279,1654585200"; 
   d="scan'208";a="787975520"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga005.jf.intel.com with ESMTP; 31 Aug 2022 13:09:15 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 31 Aug 2022 13:09:14 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 31 Aug 2022 13:09:14 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 31 Aug 2022 13:09:14 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.107)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 31 Aug 2022 13:09:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WZf01X5HH39okMBJp/WQGcYaIBRKaz2BLLAE0kgMI8S4DJ0mLQtsaKwBXeb6ppkONrwpbpbbfXYAe9QQkZVy+c5DizTFkQf/LiZjYytH9f3ahoSZ9/1BHyCbhbabp3jHxsa3IEpcZmTH3up8Aw5c6Nrb/nepl4OedVHUFHB88Vjy7ZEMxDG24taWa7qlu5Qw81AaBwkxrvR8BoTcKj5+vj9nm1zxjZnwtZRqbb4dubB5AMDUa2nPhqAUHVrvtGXRw9m2IY9B4hxy5Brvk0TC4hokUW975sA7QkQi5h37d52oF31G8SBq9Vz/cdx3O84dIz9UkTF+gc5n2dqMF+bznw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GrMQtLBoI6awj8GGIRsZnIrgHQ/fa0Ex6P9BBu1E8xY=;
 b=Ki09EH/iS/98iUDL0h5KODn8I4Wx2jhVCK7iEjBFZ4ths0B9Iy3eE5zrJTUpxu11xrBOybxzMB411oIUiDVFfZGjGZHMqSNBoqRCHGwfJCNYtDmgac2wWvQo7AxXy6DtuBmoWJybm34XxSurVXSjMR8lL2/3NoluMWwjHJX4qGFIAInSQ3PY/mnmPP24fSL51siKG7l55VLMCp81WUYhVmXpjuhBw0B8jWk4PEsaO3uc6vy7idd83OaHerEXY4fxBN8o3FZE+dZWjg2Dxiu3mok6lEMfNCW2nDtImQTm4NKJ+HVaLn8Cwf+kybuqX+2r4FyLDsa4UNeBSLWqqRi7iA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by PH8PR11MB6951.namprd11.prod.outlook.com (2603:10b6:510:225::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.16; Wed, 31 Aug
 2022 20:09:12 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::295a:f0fd:ffeb:2115]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::295a:f0fd:ffeb:2115%4]) with mapi id 15.20.5588.010; Wed, 31 Aug 2022
 20:09:11 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     ivecera <ivecera@redhat.com>,
        "Laba, SlawomirX" <slawomirx.laba@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Piotrowski, Patryk" <patryk.piotrowski@intel.com>,
        Vitaly Grinberg <vgrinber@redhat.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net v2] iavf: Detach device during reset task
Thread-Topic: [PATCH net v2] iavf: Detach device during reset task
Thread-Index: AQHYvEjk1CGq6TaBGUCRbbEbTVSolK3H64sAgACsCwCAANrVMA==
Date:   Wed, 31 Aug 2022 20:09:11 +0000
Message-ID: <CO1PR11MB508906BBD9F721E08C79CA8DD6789@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20220830081627.1205872-1-ivecera@redhat.com>
        <DM6PR11MB31134AD7D5D1CB5382A5052887799@DM6PR11MB3113.namprd11.prod.outlook.com>
 <20220831090540.53e324af@p1.luc.cera.cz>
In-Reply-To: <20220831090540.53e324af@p1.luc.cera.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ac5e1f9a-c76b-481c-5972-08da8b8cab72
x-ms-traffictypediagnostic: PH8PR11MB6951:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xuXhTCUGXPTiMJkm5qH5FCQ+g4YJbHe4zKnfzkNfMftiFEO/i92fymm8rI9Z2iKEOl3FhqpIisO++D5NZmKXvtFlKKyVyR18xzR21BEHbU21vq3XZMvb210GCmr9+psQvAFAB7fFGBErJzMUEgEka/ERl+oAs8JuJWnKT/P31nvQ6lya1XAi1PRz5gtT9qMTQF2X3c4cB6MJyZVhHuaQ5aQ2xjLKvRQs9WXNdUpg6SitJGfI/TPhy8tLlrVXUPq+2XzUSyOeHfI91yezP5HS40tZ1f5zQwKAa2untmZbC5k5LWfMiL6UTtcw0F/k3eIkDpRFn2C9tC9AbQr9sBjjWpH0GjvbPQglu3YqAnHyNMqxWX740zaypLh/OCwk+4INeF7J8gIudPcYb16HMqhS0mdXxdZuP3l+BWw05Lb9VR3aZzj8ZX2CBc1KtgFYwNBBhOoxXHm8I1QgjuiWqhkiSOu6D4A/Y0bpITZSO51/il91L1uCwy7RFi7oKKUCq7TqERh/cEaMOpBttx6yQVZ85jL2mgFtBNAl0iuVmBKbXf68hJX/6OvY4o63X9PwOokgHli4Ge5UUof69TsnkEE0Zn86/z4XksHQvvrrDIKuPI28k0HT3ybYJO+H6J8fZbuquBr7CqAXwHv5sCRHbR7QmNmN4v8j97FawWgRlFPJX+cAaXiRYNQT+sJN/urifmBUF+CtbYF1HWRv0WqOX5muuCPj4xxiB6Iao4BDFgw8PtdRQx59YzyGRL4ufgw8ZQtYno++EjVqc7CA1dHt+7IlcA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(366004)(39860400002)(136003)(346002)(396003)(71200400001)(41300700001)(7696005)(9686003)(53546011)(6506007)(478600001)(38070700005)(86362001)(8936002)(33656002)(82960400001)(38100700002)(26005)(2906002)(83380400001)(186003)(122000001)(52536014)(8676002)(66476007)(66446008)(4326008)(110136005)(66946007)(55016003)(66556008)(76116006)(64756008)(5660300002)(54906003)(6636002)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?bi7kPp1N/Wtkj5NJjMfYcVWWfn6U/+orimyJaz4U/faq+0GCk2f9LylSh5Ye?=
 =?us-ascii?Q?u6EX0xwziR+nDDVhhMF6997BeLi8jY1TEpL0JYf1ur3Qe1+7FcTa5EfqlFlo?=
 =?us-ascii?Q?J0SmpcgbpaAc4n8Fl1AtaxfBan0ukyN8+PzhSINizD6kPjnB0F/8bSG4eWxr?=
 =?us-ascii?Q?+Fce6xw9cBKKlkmUnc7tyLa7ewoNOZ+ntfcTnStuGlx+p/4Sux3R5t0zFpRO?=
 =?us-ascii?Q?8N/59eOCQEuKmfi+gPUhjUcR8TqTVappbeBJQmPBbHTEi0xgV5I+xg2HlJ6B?=
 =?us-ascii?Q?zYLjvlqIEJ+FlEZCkfNCZhmwT9NOm2NPeMk81l3YTsB1IvSCeynglhqgmLNZ?=
 =?us-ascii?Q?lwQhrrWCCam5ArrT2VZJ8Mdtem7vutTdqBP92N36sCWIeUPY1eUfF6FyXgS5?=
 =?us-ascii?Q?IDGX9sAaTOfnTETSa8fhc9oAGEUaN3UJZLWOPO4uRqRo5K+PFXrPqfv6ulzt?=
 =?us-ascii?Q?pzT4kvdUtuveqhDKChbHN8R3zadUpK95X0BPydFIfyVD0izj23v7btSyAwEt?=
 =?us-ascii?Q?hu5vCDqu8/d8Fih7xTGRU/cOQSK+Zp/nP3kmgVw7/LuBX0OL9beDiMJs5OZm?=
 =?us-ascii?Q?Sjb8/jcWRqgfgZVJI7bbJ72kD2Qm/QlFNV5JEjwQQmzhnwSi5mgJsqDTBonC?=
 =?us-ascii?Q?zqv7FoK4+JXBjUTuHlSBxG2oVp649L9cyu5ni74EGNxdzA2eRuh3SoSgJFK0?=
 =?us-ascii?Q?HdRMRKCzkdfsVofutPBwFYHlqnm74qKmTsbbv6OokFNlS3DM/N0DPOgElsLy?=
 =?us-ascii?Q?h7FrjssmH3HhDE1vU3l1mnBpxYCym1FmUf7DKdy2uTvrK+JpIFxuV01YZwnE?=
 =?us-ascii?Q?XCUW14YmROJLS/RheiUHPjwuHhEKJRU9LYPM+e2ZQ1zZpcP+n8zKPLc2kqnH?=
 =?us-ascii?Q?zn9wuRKVdDCE71jOGRsvRAlJwuGRNLie17nxYZtDltkmYcFK/qHYO/OHcySH?=
 =?us-ascii?Q?jPGGqmJqlSGVbuFWEyH1Eh41f0GnW4wLa7LO+ZAWgjwGgWfV4IjB/GSinYLX?=
 =?us-ascii?Q?6gYsYldapwtQWtzRBn/fRedLy857icREgMtMHVpYsMAYysJ7snwi6WNWhD40?=
 =?us-ascii?Q?PZrWjJ0P7upa9fozcXB9JhcA55n52iNFuqaapMsT/JPLFtyfSYEU5ngTv+Ff?=
 =?us-ascii?Q?QLE3+M2WMLoi51Q7Q/Q1zac6JE75qRVGX4sqpsjCAdsUG4FI+GYbM/uKolci?=
 =?us-ascii?Q?zwkIfksd2iKaHWRXYL09m2grHR1waBi9a9TW/gLzZeBEuEwXF0Hamm4RgH9T?=
 =?us-ascii?Q?qbFq7R91m0A96Xa86lyyJLl+vdz1LRylDngX04N6y7/lwy1x+IxBhPQSebQN?=
 =?us-ascii?Q?0/6ay3dlgrhPBHXp62lPLOEQQmpTX3TZiZbRY/57oGz2R/wSTQI0Xw1gxw+O?=
 =?us-ascii?Q?t9U4F7X5NGAOeDxzqkvGMXSv+/ua57DPygi4wv7OeCd5AzafUvfJ1gsRQ+5e?=
 =?us-ascii?Q?mExsQ7kBpaFtPtUdk4Z38Gyr9feFgWj2LrTrtDc5mbo6ERQOcNoc5dBpckjO?=
 =?us-ascii?Q?Dvs1DpJl+ciRUBwklGeeEBEgBcxoqVa74c42x/0ffdBLtGNU5dcy1HYsliVc?=
 =?us-ascii?Q?ssoM8f8u9ugwfrBH+SB90N09qOccbsOhMIcvLykM?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac5e1f9a-c76b-481c-5972-08da8b8cab72
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Aug 2022 20:09:11.4113
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: e433GESpcDQwEeRMdzAcLGkI64xFsjblIb78VMUjrkRJz8jHUaqOoUtZn24M9LBS8DHVSambCCOtybbDlRXVq/laacvqmSY0MMLs729fFiA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6951
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
> From: Ivan Vecera <ivecera@redhat.com>
> Sent: Wednesday, August 31, 2022 12:06 AM
> To: Laba, SlawomirX <slawomirx.laba@intel.com>
> Cc: netdev@vger.kernel.org; Keller, Jacob E <jacob.e.keller@intel.com>;
> Piotrowski, Patryk <patryk.piotrowski@intel.com>; Vitaly Grinberg
> <vgrinber@redhat.com>; Brandeburg, Jesse <jesse.brandeburg@intel.com>;
> Nguyen, Anthony L <anthony.l.nguyen@intel.com>; David S. Miller
> <davem@davemloft.net>; Eric Dumazet <edumazet@google.com>; Jakub Kicinski
> <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>; Jeff Kirsher
> <jeffrey.t.kirsher@intel.com>; moderated list:INTEL ETHERNET DRIVERS <int=
el-
> wired-lan@lists.osuosl.org>; open list <linux-kernel@vger.kernel.org>
> Subject: Re: [PATCH net v2] iavf: Detach device during reset task
>=20
> On Tue, 30 Aug 2022 20:49:54 +0000
> "Laba, SlawomirX" <slawomirx.laba@intel.com> wrote:
>=20
> > Ivan, what do you think about this flow [1]? Shouldn't it also goto res=
et_finish
> label?
> >
> > 	if (i =3D=3D IAVF_RESET_WAIT_COMPLETE_COUNT) {
> > 		dev_err(&adapter->pdev->dev, "Reset never finished (%x)\n",
> > 			reg_val);
> > 		iavf_disable_vf(adapter);
> > 		mutex_unlock(&adapter->client_lock);
> > 		mutex_unlock(&adapter->crit_lock);
> > 		return; /* Do not attempt to reinit. It's dead, Jim. */
> > 	}
> >
> > I am concerned that if the reset never finishes and iavf goes into disa=
bled state,
> and then for example if driver reload operation is performed, bad things =
can
> happen.
>=20
> I think we should not re-attach device back as the VF is disabled. Detach=
ed device
> causes that userspace (user) won't be able to configure associated interf=
ace
> that is correct. Driver reload won't cause anything special in this situa=
tion
> because during module removal the interface is unregistered.
>=20
> Thanks,
> Ivan

I agree. It's safe to remove a detached device.

Thanks,
Jake
