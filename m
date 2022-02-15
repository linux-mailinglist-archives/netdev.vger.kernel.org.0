Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D3534B62DE
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 06:34:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbiBOFe0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 00:34:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbiBOFeX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 00:34:23 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26A75299;
        Mon, 14 Feb 2022 21:34:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644903254; x=1676439254;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=di5UDjTmmTbeW/shlQHkvPP75ndr4b+qb+aDoA04Wbo=;
  b=M06tGnZ78G9SV0rvEh8YPDJZGevyb+8YAE57QYHtBSbmqvN4phNrhA8r
   XSGQ665mAmopGg0N7l04YMDHzbniyJNyCTujS2kfqgzFu8yY/M1sWUnBU
   8+ExAgrxaOrBqRO4bOJ7MMaDpz33aLOA0CziohENy8myZnB6msAxWafnB
   SJPqV7yAXl/roSZ6X3TMqv8DhUdlhTDdHC8sS6nfMPdyUuyZX4N4+AFRe
   pouAR1aBz1a1gu6+AOnNuCgOQuPartNaU7xQRII7Ql43ISZDqG0PF/LhX
   WpFFuN4aT09sCVmU28EYUJoB+Hj2XBj0ndmtNE2qvVV7/BfwAYTaiBzfX
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10258"; a="230216440"
X-IronPort-AV: E=Sophos;i="5.88,369,1635231600"; 
   d="scan'208";a="230216440"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2022 21:34:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,369,1635231600"; 
   d="scan'208";a="703443537"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga005.jf.intel.com with ESMTP; 14 Feb 2022 21:34:06 -0800
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 14 Feb 2022 21:34:05 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Mon, 14 Feb 2022 21:34:05 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.171)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Mon, 14 Feb 2022 21:34:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i/juNCEeew8tBszjidhPqDawPq5QyC2haZ4LvBliExWGdxV97/DiHbvty4WpbtVGng9PTYU0p3hIXbygNVBsw/1ThWK2DMp5U4HB4PdqNImq/AX4x5IJdtgxRQxMhI3DzsWZ6d1xGg3OsY+C9xDZWZ6nBmaLYoTs3smUDahFNUnCORZ0jnDmZo0cdsoQeBsjhQRdZqbUyhaYqiIdmJ2ARKoZ2im7ssucq9CnGI+O2/kjwPmWDjXPF2jzXPihS+OLxN7rLMglslVJX/0rjRk0dCusjsjlNMZUA7QEZH1NCgENUzsqxBIvmLPK5IP1FQXL8i66KvPvOdS01CFtnpNQ8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=di5UDjTmmTbeW/shlQHkvPP75ndr4b+qb+aDoA04Wbo=;
 b=NUqFIASZPrauw0yMml6G7kPzcDx/RfGJzRqb3NdlEp8rlLRj207LzLZTklrR3VJm8xfvW6+CxA7kRPxWc0lcBHapXSoc3dxv6rY+RJNqVVkCaJRmEe+PPQkOxqOHrP0VGgQUMVSvYQ+NjKTEYgVzhvQWw8N0LiYlao/ff6Yb0uwScqHopq5iuQFngOaqt1nLU27Bkxs2jSyGVf82e+fUJy4XzfnSFfAVUlNStUu96ZXyrriFvSzgqE24j7Dr751NpSz8gyqDCMwiFpgtUn2dGIqC/0bZJcLwsBkxf55iU3ZaCr+fsTjpvtt2394bUByuJsl8SI7rP0+IiMnYAHBfAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from BYAPR11MB3495.namprd11.prod.outlook.com (2603:10b6:a03:8a::14)
 by DM6PR11MB2905.namprd11.prod.outlook.com (2603:10b6:5:62::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Tue, 15 Feb
 2022 05:34:02 +0000
Received: from BYAPR11MB3495.namprd11.prod.outlook.com
 ([fe80::714b:35f9:5767:b39b]) by BYAPR11MB3495.namprd11.prod.outlook.com
 ([fe80::714b:35f9:5767:b39b%6]) with mapi id 15.20.4975.018; Tue, 15 Feb 2022
 05:34:02 +0000
From:   "Wang, Haiyue" <haiyue.wang@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jeroen de Borst <jeroendb@google.com>,
        Catherine Sullivan <csully@google.com>,
        "David Awogbemila" <awogbemila@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>,
        "Forrest, Bailey" <bcf@google.com>, Tao Liu <xliutaox@google.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        John Fraker <jfraker@google.com>,
        "Yangchun Fu" <yangchun@google.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v1] gve: fix zero size queue page list allocation
Thread-Topic: [PATCH v1] gve: fix zero size queue page list allocation
Thread-Index: AQHYIVEt5rY3o3cDa06/TofCdTpoOKyUFSsAgAAAT1CAAAJxgIAAAFRQ
Date:   Tue, 15 Feb 2022 05:34:02 +0000
Message-ID: <BYAPR11MB34953364C58C489DCF901C2DF7349@BYAPR11MB3495.namprd11.prod.outlook.com>
References: <20220214024134.223939-1-haiyue.wang@intel.com>
        <20220214212136.71e5b4c6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BYAPR11MB34959983354A8C81B065AB5EF7349@BYAPR11MB3495.namprd11.prod.outlook.com>
 <20220214213127.3aa9ea5b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220214213127.3aa9ea5b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.200.16
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b1390169-2242-4371-b2c4-08d9f044c654
x-ms-traffictypediagnostic: DM6PR11MB2905:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <DM6PR11MB2905936BCF0E52944DFA75BEF7349@DM6PR11MB2905.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vrqLx68RoHXCEqWFWeAS+0L+AYELPUpFCGCfrlsrdRZrgRS0+k2C8KG1g3LsF7ka++m2CmbtuEA/0wRiRJHensfCZvoRp/Y9sE1/vtonLobPhlf/AAzVPwWMObpLoTRV+9LwNrzFVtM/5NnhX0SLy+DrHIeSt1Slc/Z59FIKiwVYDQc3ZMsK3wF239nyVYhhdsBD+1n+d4jt+T620z3smHcbrxysRoF3mqo0VOPZNFehv1bsNiJGhr7hpSilh648hUgPk8KUldW3+jYzlTou46mbAsoZfCH7FQW8HhF9/gccSGXNapoAKgFfzlBOXFevA25U/YNC6V9OSZ+qG+aChqsuOEvixOt3UQjQlGePR9HwtVWl1tY4qQ9MhXmP1URmYSRLCThhk+TxfH3V7BnU+yxsc+Uge/J+gSTY/5N4Lj+ncMfPe50vvVRVHIzjeAFN/+P7iise0+VKA+R3YjcViYjQwpM9x39V7jLS1D2qQ2qs95qM0lHTpvGYdEm0sQAfm2iBiYk7Pw24I3VpncaBFlgQX9F6hYPck1Uwy01eiQvnFcjTpipePNP0Pt3fCtsILE1+7dCuR4Sg4JsXOKRSA/02AI3ZrFsAblFExYz+CmdyZGrr6+OsZ2mVD5LS9CKORMURc/g3LZUgBVq3qkAyBGbc7IgbaL7kpJ0GON5oxIt28spYtWDI/b4Ub6cIGsi0LLnCwdTNVTK2IUpTx++9/g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3495.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(82960400001)(55016003)(508600001)(6506007)(122000001)(7696005)(316002)(9686003)(38100700002)(71200400001)(5660300002)(52536014)(7416002)(38070700005)(4326008)(26005)(8936002)(76116006)(86362001)(6916009)(83380400001)(53546011)(186003)(54906003)(2906002)(66946007)(64756008)(66446008)(66476007)(66556008)(33656002)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3SwQYjK/ZxG681YNX+Es4XP0N+uR4rMBFosD6hr249KSXT6vQfT61aBeA6G+?=
 =?us-ascii?Q?70Ft+3RM7TMD/y5N/dyX40XTXfcozAcpdEybLvOS305Fhob1dWiy+4CzMa7p?=
 =?us-ascii?Q?Ico0PzOg4mTKE9OzQ8AiTvl7b1QsEZmH/pLQda6PNrg7pMkQ1XSWi1ReCUqt?=
 =?us-ascii?Q?/zYoKQUoSaer3cW54vhFBg7uBG2JNq3ey3jvPlkTH+haQ6ANlcN/66gPK75X?=
 =?us-ascii?Q?7uV/Qt6oTPSRDMclvx4hFcwS+U1bp+21wShx+1F+5QtXD7pys8JhRGipAO7R?=
 =?us-ascii?Q?yRAsDN1dOeLRZp8hdDpuQXP2WPcy5FIwiXk3tWxRboHXmOwvDG8kMwQofdGt?=
 =?us-ascii?Q?OyefpDsnwWgT5zDUII4YWvQE/y9UkeFlaGTWi6iTlTRuJDd9JbJvvzI6NdUe?=
 =?us-ascii?Q?jrmi6dPGh9S8/4TjkuafY6fcY7uVM7Zs9AGJV/h0AH+50EtNNryEDicRDAbj?=
 =?us-ascii?Q?PQ9lC8PcAv63zCQprjuUuRkSGXqHCVNDHpf+GR6wX7YzwH08qJRt1PIqki+i?=
 =?us-ascii?Q?nOA2W10McLXRfOan5lHLgxhc8Bpjs4V9XJ4u0IFqZWFYGsh6Z/foEoWtL4Qg?=
 =?us-ascii?Q?SVG3f7UI/dfPjE5geFRJHhhw3DA2bg4t5n3TrXGVCOywI+ndpMFs017lCeEY?=
 =?us-ascii?Q?Q9dUUrR88/WDKv7hpISjNcVKm6KmMNCYwZHoYKQHJvgy3wheTrmAXHh6dHSW?=
 =?us-ascii?Q?XO75g61rDbwHIRYGzVbGdKjdnhHMYNSThsKt2B55X6E3BcYOZ6hqsXRpiy76?=
 =?us-ascii?Q?Vxsyl1drvI/H8aeKB00y6paPkmg5uu+SqIgPRTplSPcfFn0eREHKXV2IQD9E?=
 =?us-ascii?Q?vvpFXgf+N305WaZqKV2dqffHlqfWp8DY/Lb+Zd7vd+A+IMIbRCPqCwmg/yXk?=
 =?us-ascii?Q?PXTWs6vv1Rp+PEtlDWYOz0A600JAfsA/m8BDQrenN5d06+5r+9ZskChwRbj0?=
 =?us-ascii?Q?m9HX4AMkS99tk0hd0TeGD80E845GcII4DYsneP4Rx9jn9pJs07uPCuziD4uL?=
 =?us-ascii?Q?rET6MkZw7BPw+6I/7HJYkTfEJ15vxKMMNlh1JKoU6dkgU/mL7EzIT02jaWem?=
 =?us-ascii?Q?PN16aFcVYS9qpe+3ik+lmn1PivCl1V7LBtZ8Qj0ezm98BZSGDM9ykzWDO38u?=
 =?us-ascii?Q?3fl6w/C5G8NHUX2f5efW0E7nlyEHQaAav6s7jBihjtzpIqUKcp50Yn9u1axq?=
 =?us-ascii?Q?+sJO2zg9POyWnkvLrRf7G2WUwOpYxNurjYNr9zpNjHBtYhkvGZFHcOQ1rrXa?=
 =?us-ascii?Q?Vw4Qjpdfbc45Cq1kTY6dvPpxuH2bwmFusM1RkA9ZPDNX/gQ1p1VkremMWUSF?=
 =?us-ascii?Q?0RmlZGKUp6uwq2f4eR17ABn+KzaINO07I92KFYahCMkCdVbaB5k1mxymZ+Z1?=
 =?us-ascii?Q?WPD3sbDbLL76s8bLPn0lkrwVN1lyzRBkucfeiBTjLN47wiIV3UKU1wLp1bd6?=
 =?us-ascii?Q?r96DAr5WTCy89B6v+X7FpQQdJxIzjfCEnhTYUvTpc1bPzchYkvNhAA/hTZJf?=
 =?us-ascii?Q?s6KXLq3f9h0VbWfmQ2TLkR7BViwLdvMK5f37hpr49kKle3M3awMKSVZroPdb?=
 =?us-ascii?Q?74W9jam4xaxweEK18NdKz3b7ZVBxDqHAHjZfjueLrOjDPxosuxZysXa22JfP?=
 =?us-ascii?Q?ng=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3495.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1390169-2242-4371-b2c4-08d9f044c654
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Feb 2022 05:34:02.4267
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dhub9b+IEezZFUFr8B+1l7Kjh3uNE22FpkmCYzoRzN/h97aE4MGRTvQD3QbhOa0n04SbQUnkoHkYnCT5eJmmxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2905
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Tuesday, February 15, 2022 13:31
> To: Wang, Haiyue <haiyue.wang@intel.com>
> Cc: netdev@vger.kernel.org; Jeroen de Borst <jeroendb@google.com>; Cather=
ine Sullivan
> <csully@google.com>; David Awogbemila <awogbemila@google.com>; David S. M=
iller <davem@davemloft.net>;
> Willem de Bruijn <willemb@google.com>; Forrest, Bailey <bcf@google.com>; =
Tao Liu <xliutaox@google.com>;
> Christophe JAILLET <christophe.jaillet@wanadoo.fr>; John Fraker <jfraker@=
google.com>; Yangchun Fu
> <yangchun@google.com>; open list <linux-kernel@vger.kernel.org>
> Subject: Re: [PATCH v1] gve: fix zero size queue page list allocation
>=20
> On Tue, 15 Feb 2022 05:25:49 +0000 Wang, Haiyue wrote:
> > > On Mon, 14 Feb 2022 10:41:29 +0800 Haiyue Wang wrote:
> > > > According to the two functions 'gve_num_tx/rx_qpls', only the queue=
 with
> > > > GVE_GQI_QPL_FORMAT format has queue page list.
> > > >
> > > > The 'queue_format =3D=3D GVE_GQI_RDA_FORMAT' may lead to request ze=
ro sized
> > > > memory allocation, like if the queue format is GVE_DQO_RDA_FORMAT.
> > > >
> > > > The kernel memory subsystem will return ZERO_SIZE_PTR, which is not=
 NULL
> > > > address, so the driver can run successfully. Also the code still ch=
ecks
> > > > the queue page list number firstly, then accesses the allocated mem=
ory,
> > > > so zero number queue page list allocation will not lead to access f=
ault.
> > > >
> > > > Use the queue page list number to detect no QPLs, it can avoid zero=
 size
> > > > queue page list memory allocation.
> > >
> > > There's no bug here, strictly speaking, the driver will function
> > > correctly? In that case please repost without the Fixes tag and
> >
> > Code design bug, the 'queue_format =3D=3D GVE_GQI_RDA_FORMAT' is not co=
rrect. But,
> > yes, it works. So still need to remove the tag ?
>=20
> A bug is something that users can notice. If there are conditions under
> which this may lead to user-visible mis-behavior then we should keep
> the tag and send the patch to stable as well.
>=20
> If there is no user-visible problem here, then the patch is just
> future-proofing / refactoring and we should not risk introducing real
> bugs by making people backport it (which is what adding a Fixes will
> do).

OK. Will remove the tag in v2.
