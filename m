Return-Path: <netdev+bounces-10709-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3041572FE6C
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 14:24:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DEAEA2813FC
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 12:24:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09183A93B;
	Wed, 14 Jun 2023 12:23:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFAFF7476
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 12:23:58 +0000 (UTC)
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C38E11FD0;
	Wed, 14 Jun 2023 05:23:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686745435; x=1718281435;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=C0ayvqJ+qaQ9M+hOnb1IclkTZ1bBtGhj0VlVEFtFQGM=;
  b=RWPytqFdfIB4e1eMpUzUDihHWmxBPFk5dxzQliPoIDGjos0fa7P9Hs0K
   I12RQ6NP8Te/bp+U58+famYebR3HI7WH4tz//IgqYjfeQD1DjkyVUUbk/
   fpeAMjVHek03d8yERkmxkFNGq8cWlYQGv8HQ5UbAFe1MU/FBrIrwqwZnT
   47gMGy9vPvklDt9MUCB5h7aaWU0ssXnO4PJAu0NQMDYTjPufG8Vpfx8xR
   7s60wOkfpXqZA7TUqdbtIvf8jnqzeoIn5OAN1HRECuVVnwb/cBX4yeaQh
   kwBST+LHmwQEtLrRHD/JRacl5aLW9umT/B+VBIUiRJs96zr5ct/x+Qg2C
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="422198355"
X-IronPort-AV: E=Sophos;i="6.00,242,1681196400"; 
   d="scan'208";a="422198355"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2023 05:23:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="706196497"
X-IronPort-AV: E=Sophos;i="6.00,242,1681196400"; 
   d="scan'208";a="706196497"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga007.jf.intel.com with ESMTP; 14 Jun 2023 05:23:53 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 14 Jun 2023 05:23:53 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 14 Jun 2023 05:23:53 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.43) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 14 Jun 2023 05:23:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eJ02uM3/QsYpe7lOaBOCLfHBvtnfMwhsgdHVt3hT5cRDf9Ovx6eUqkD7mvE/M2J1Jd0Z6ENIJ9mg26vxD+hmYnYZWU7sNLzc/GI9TEYO6pofd9IbcssX+G2pO4DEUTCHpOfnqOYHzBW8sCsF9JwZyJpcjSXB4OVPDyMzVIn24dTTOaFZPbG2llcwpO9j6u4yyKzQko3xeGVODJzKI3L8NouKfMET0HfmxizvImIOs+nNZpbiIm6/kJRP11CYwBoLoH5xXD/P6eRBki9fzm/rlfO/Ax6ISbhifF7NTStWw7PbHXqbfDVjZkS3FICpDw/0sRBEtemlUCBNLvL3EdxO8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E87pI0mk0xPpd9hkougNPTwVX9PuFRmzfeQgW2QsBfY=;
 b=fx41NFg08aalUlP4+ZTjvPRpTZEZQCh+x0lP4ImAzrgY3InIsQ/uC0SfLZvtYV5xjMVhHFD11Vwlyjx7cgugDRvXfS+45oQUknWH4eMfrIsjlgcCa0S0n3Rd19OPYtorfj5uNWiRewM0QGM4yLdgdgtu65AwquIMyzcQ1ulM+NEzVRcH2o4aLJaEOTcBPq1wsffXGXb1I5sJ/GwBJoplk/h1NmOiPc4ve4GwZFdIjN7/FEodtY00QwZKnSUXV3PW/KLia0/5yCASGDOYPhbqfZ1mGWF7uyEn+/puD+2wpdC2bmO3OxivQBFi4DjlzcSH0pMHu4/7bC/yi7BW2lzZLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 PH8PR11MB8258.namprd11.prod.outlook.com (2603:10b6:510:1c1::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.44; Wed, 14 Jun 2023 12:23:50 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::24bd:974b:5c01:83d6]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::24bd:974b:5c01:83d6%3]) with mapi id 15.20.6455.045; Wed, 14 Jun 2023
 12:23:50 +0000
From: "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To: Jakub Kicinski <kuba@kernel.org>
CC: "jiri@resnulli.us" <jiri@resnulli.us>, "vadfed@meta.com"
	<vadfed@meta.com>, "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>,
	"pabeni@redhat.com" <pabeni@redhat.com>, "corbet@lwn.net" <corbet@lwn.net>,
	"davem@davemloft.net" <davem@davemloft.net>, "edumazet@google.com"
	<edumazet@google.com>, "vadfed@fb.com" <vadfed@fb.com>, "Brandeburg, Jesse"
	<jesse.brandeburg@intel.com>, "Nguyen, Anthony L"
	<anthony.l.nguyen@intel.com>, "M, Saeed" <saeedm@nvidia.com>,
	"leon@kernel.org" <leon@kernel.org>, "richardcochran@gmail.com"
	<richardcochran@gmail.com>, "sj@kernel.org" <sj@kernel.org>,
	"javierm@redhat.com" <javierm@redhat.com>, "ricardo.canuelo@collabora.com"
	<ricardo.canuelo@collabora.com>, "mst@redhat.com" <mst@redhat.com>,
	"tzimmermann@suse.de" <tzimmermann@suse.de>, "Michalik, Michal"
	<michal.michalik@intel.com>, "gregkh@linuxfoundation.org"
	<gregkh@linuxfoundation.org>, "jacek.lawrynowicz@linux.intel.com"
	<jacek.lawrynowicz@linux.intel.com>, "airlied@redhat.com"
	<airlied@redhat.com>, "ogabbay@kernel.org" <ogabbay@kernel.org>,
	"arnd@arndb.de" <arnd@arndb.de>, "nipun.gupta@amd.com" <nipun.gupta@amd.com>,
	"axboe@kernel.dk" <axboe@kernel.dk>, "linux@zary.sk" <linux@zary.sk>,
	"masahiroy@kernel.org" <masahiroy@kernel.org>,
	"benjamin.tissoires@redhat.com" <benjamin.tissoires@redhat.com>,
	"geert+renesas@glider.be" <geert+renesas@glider.be>, "Olech, Milena"
	<milena.olech@intel.com>, "kuniyu@amazon.com" <kuniyu@amazon.com>,
	"liuhangbin@gmail.com" <liuhangbin@gmail.com>, "hkallweit1@gmail.com"
	<hkallweit1@gmail.com>, "andy.ren@getcruise.com" <andy.ren@getcruise.com>,
	"razor@blackwall.org" <razor@blackwall.org>, "idosch@nvidia.com"
	<idosch@nvidia.com>, "lucien.xin@gmail.com" <lucien.xin@gmail.com>,
	"nicolas.dichtel@6wind.com" <nicolas.dichtel@6wind.com>, "phil@nwl.cc"
	<phil@nwl.cc>, "claudiajkang@gmail.com" <claudiajkang@gmail.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, poros <poros@redhat.com>, mschmidt
	<mschmidt@redhat.com>, "linux-clk@vger.kernel.org"
	<linux-clk@vger.kernel.org>, "vadim.fedorenko@linux.dev"
	<vadim.fedorenko@linux.dev>
Subject: RE: [RFC PATCH v8 01/10] dpll: documentation on DPLL subsystem
 interface
Thread-Topic: [RFC PATCH v8 01/10] dpll: documentation on DPLL subsystem
 interface
Thread-Index: AQHZmszoYeH83BxaW02EVqODRhjpgq+H21MAgAJlGSA=
Date: Wed, 14 Jun 2023 12:23:50 +0000
Message-ID: <DM6PR11MB465706EDA878CF8E10DFFF1A9B5AA@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20230609121853.3607724-1-arkadiusz.kubalewski@intel.com>
	<20230609121853.3607724-2-arkadiusz.kubalewski@intel.com>
 <20230612164902.073544e2@kernel.org>
In-Reply-To: <20230612164902.073544e2@kernel.org>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4657:EE_|PH8PR11MB8258:EE_
x-ms-office365-filtering-correlation-id: d2d8ef32-00cf-47f2-1296-08db6cd235fb
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HgiqRbNH0YJBq0g+o93NEf04FOlRZyHsJpnJLCt6ncT6xaqGgoIy08ZlZ4vurUudC6OiazgCrveWg1hMrHNQ1xqTbouvuS8Eo+q8gSaTYEVku6l1i01VqWxdOod/Ue8uJbIKSQpcGOao0toTqJbPaxBnMTTraF+oK8uMtXTC5KjO6npkx4bVhJuDVXY3Wbtb4evW8XF63qKZWUl0RGOhUkH8DFKCPQIRttyCLKq8hlntT5ytAqTE1/JaC7p1mZANOCav6JTXTRzBIF4BC72I5lXHpw9pGp0TTpgNhG6++L1OOqsmHsTS4F0zTGzdMwlWwaHrQ3XxCwVtnLk57xxBpv8KvotrpIQH/ILu7Djk0ioHRhWqE+iTgu/WSjwZtZrbJ7nhnCfbxH6CdTJM5op2oJSq7MLFfUeOqLT4mKmmbnxYs/B49RddJwpd1t5C+N2WciBGLySS9pD8eHJGNqqNEjrDWqNiLaTwzUN5JoAnKxOTEK+aby6VjTrLiedAdnGOSOdIdJyXVlRy61ZRwUW/Tmx/0EXDeLP1wUtAmKD8tTaIC0l8LdJMfeHdwU/jqV6c11xoHS8rXrffU/9mAmg0Upu0kONeXJiCjj5syBmXygfp5BdiqB37YjDkvqA90Rp/
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(136003)(376002)(346002)(39860400002)(396003)(451199021)(66556008)(66446008)(66476007)(66946007)(64756008)(316002)(76116006)(71200400001)(54906003)(4326008)(6916009)(478600001)(33656002)(86362001)(38070700005)(6506007)(9686003)(26005)(186003)(41300700001)(8676002)(8936002)(7416002)(5660300002)(4744005)(2906002)(52536014)(7406005)(7696005)(55016003)(82960400001)(122000001)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?o7A1GjyPRpTZAXbMuqGNSaIGGQ8scOCYRXY/asLVQVhXtkL0xvDJZODOG+k5?=
 =?us-ascii?Q?vkbAQ8kt2Q6ouUfEFqnOg/bun1nupk9p0ePEHL/U5TQkMiKWieNYNQYO3GPD?=
 =?us-ascii?Q?wNt2O7b5w/OPP6rXOLFo9vlrN44K6PlheViFf9V0gC2+Pz7ss+perQqMolSg?=
 =?us-ascii?Q?9LECAONyaNW/3iupshjb9/A4ADTaO0MgHleQx64D7Oh3IicfU3A/1dI29wUf?=
 =?us-ascii?Q?J7HViUcJLX4qRHzTMASzdm1/id1P1OgLKZhBHO1Hv/OGwsuXbD/Hn9+JWLam?=
 =?us-ascii?Q?Nz4JtAXmkKHZsduqAGh7t1/tddc1kr38myymXjPViFrXIoaI5DtguXFszBRY?=
 =?us-ascii?Q?AoEdklzo7Hh7xUfpygVvywBW1Q+hSp16svkDGAaUK4JGyK2fSJFw9pjxm1sW?=
 =?us-ascii?Q?onGUpRMj30hsJZjqsRl99fCd+K6IJzZugaO9i0ZJnzitm1X3LlWlr9o71Yqa?=
 =?us-ascii?Q?0f16iEenG5ZVz8SN+LuOFVymMwwkVBJs5OrGyHEpk+uSTAlhglmmbQTLwyZk?=
 =?us-ascii?Q?0P3jBVAtiL15OAwMNJ+Os3WmGwry0HTUUPUuJW4nTxKxTyUqkr+z5OhOqBCI?=
 =?us-ascii?Q?IJRRn1NM8+9GuePKAnHVN5dUlLJI4Yh05HGQgm7oWym++JHfutj3KvBVBYvK?=
 =?us-ascii?Q?4atHVIMcr6n5AnLdwmFxs2792gKalubkZjWPlRL/ZT0opebbGf5RKeIJAthM?=
 =?us-ascii?Q?wk/edX9H+bXWGvr1qSfV6Km+joTHfuXNjokFJrl9Bs00fbNOyLSI/03GL6O5?=
 =?us-ascii?Q?7RvgHeqirH9zFupNsio9X3k9Yd9FBWIcQKt0taaNp7DR9ZpPltw9GtGXEFjP?=
 =?us-ascii?Q?nIzUj+3DcmR4D7EjMGPhYCwSP7FffeOGcaFEkme3EM5/eTK5K0+zSsThShGb?=
 =?us-ascii?Q?+QXL7XXQR1CG3YyWLY++7Juwzax6glRg5D3M7TRW2W7zVPo3kGNlAkuCmqJO?=
 =?us-ascii?Q?Ax5i4r5fepbDaUaGMyBWpbvFaIFRPWElvns1yfhso81bQPb+NRmv4m0yq5rY?=
 =?us-ascii?Q?6/VYtUom/7IjnDkEmGKktscpPWJUYD61QkseqSrxV5CL1DoAmd1Ja+psv1Z5?=
 =?us-ascii?Q?RmvV9DF+adHr9Wtpi6jxfpIkZ792aWPqK42YG1y0SwmfT7LRk0Lhe3Q8f7F4?=
 =?us-ascii?Q?0K9Rh9KNUrRBQWWspbp6BeOUeMdZFdrx1CL2rd8Us05PHDr+D9Z+hxQYezTN?=
 =?us-ascii?Q?7cTnl2x+gOaAKG8kVCNswI+QV30d6AE8hJllTd2ZXci7dhfvr9a1z7U6sWvm?=
 =?us-ascii?Q?P82+eY0Mzl2vbhY6d3Y0ib6vqC619dRk2fdvfY4b19QgNyzpM62fgN1q78Xg?=
 =?us-ascii?Q?2CeK+kRsYOASySCbW+tRHAo4yi1OJgHWEmE9DUrxhqC+aQj7xDkPNsCTJla+?=
 =?us-ascii?Q?jU0GDyohaSv3Jd5KlgdhpCV6fQ3AKwwvSkm2iD39z7VP+QrW4KD8Hw0qRUNK?=
 =?us-ascii?Q?XVhauKNdcl50sSYCZ/C3DRPM6QMpUBoVtQ1lEh50iyeq2Y6ARbXRQCdKX04O?=
 =?us-ascii?Q?6MNu6Jjt5jehpZYBNN99KzggtPbpsyeaCos2VMpJ09MTXJS7RG9lOkeP2ASG?=
 =?us-ascii?Q?LVENfuTAbd+hatL7cde9IkPbdktAbAVte+Ex2x8JaGEX4wt5qo1O327xHgEh?=
 =?us-ascii?Q?kQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2d8ef32-00cf-47f2-1296-08db6cd235fb
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2023 12:23:50.7488
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ChYbEmvCogW7AP8/WTa+HhUWFHX2eBaKipWNSDVgoiosZ+0jaSDRjezwpAQtGrANSST54yGNoCk1O06T9M9trdu97hKUmeQvpKdPxRGvwdc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB8258
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

>From: Jakub Kicinski <kuba@kernel.org>
>Sent: Tuesday, June 13, 2023 1:49 AM
>
>On Fri,  9 Jun 2023 14:18:44 +0200 Arkadiusz Kubalewski wrote:
>> +Every other operation handler is checked for existence and
>> +``-ENOTSUPP`` is returned in case of absence of specific handler.
>
>EOPNOTSUPP

Sure, will fix.

Thank you!
Arkadiusz

