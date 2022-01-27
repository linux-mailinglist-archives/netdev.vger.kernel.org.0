Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D01049EB5F
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 20:52:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245759AbiA0Twb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 14:52:31 -0500
Received: from mga06.intel.com ([134.134.136.31]:27315 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234826AbiA0Twa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jan 2022 14:52:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643313150; x=1674849150;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=yzq39cCTANCkv91dxb2I4Vd6KX+Xr09hlxJXn8o8u1Q=;
  b=cmA6DOHyKfpPbwV4gLa9Nuo7FG/ymWOMKznuyfKmsYsBU5/OIrWOjpC6
   nVwEXTaBY8CgPk6TqUz5qkxJ1g1NIAVSbYAj0Ge0tGINyglE9pMA/B3Q+
   9ZzVKl+bUbVnyLqNdOS09NG+DlEXXASGCo7D+pTWw3BpKvPQDtDKzGSwS
   o6f0ozuM5aHoLnpTYIlf0Akqm9tegOXpPNq+rUQgHzG1dbQ2xGQJV8jNu
   Q4QDuokaGEiyJb/bLEzV1oVL3SQtHRw3AzEWwiJAS6ybaOnvkBFx/QcF/
   bGvhGvWv96klR5lxJD/d7eR6mK3L+GCaGSs1/6kh3ntNsLWa3wu9Jfjbl
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10239"; a="307663770"
X-IronPort-AV: E=Sophos;i="5.88,321,1635231600"; 
   d="scan'208";a="307663770"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2022 11:52:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,321,1635231600"; 
   d="scan'208";a="674831964"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP; 27 Jan 2022 11:52:29 -0800
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 27 Jan 2022 11:52:28 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Thu, 27 Jan 2022 11:52:28 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.171)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Thu, 27 Jan 2022 11:52:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nCHCwyRljic4s/5k1YkXVlGsMDBA7G5BYanCDcqO6uW1gPJVXZpS42SVBwKgzzqItVJlaTTEv49h+HLecX26YvureMP8YV1ABLVURtLU6y6YCdyHyliswZ0qYFaRqVwEf5aiuWBjVr1BQpWTk4LtXqJw+AAha5JD0xoPID3nMJ1GliFJNgZN3YluoDhqjWRzgGXWLhNgut60VRKu9lTYK3yI8LVMYt1RAkNtAotfQpkidldY0EXE1U4oEvoisriCc5T0KIIhJtLaGu4yTWUHUQPBheCTYcFe6XtWcliqk9lqNu6UQj55HBGwq21rdRwRC8O+rt1tb38FeAZp1lZrQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2QdYLzSWWJ3b9pr+ctGcjjFgWeMTbpKtHrJaYwm8RQE=;
 b=fXzljASg9pX6yucb3PbCOznNpGlitxbz1/Z5LY6+jE0JeHXD+M5zuiP9i8leqMn5kUkcZN2gdI8kaoQN7bI2A0RHSv4LP0tzgjx18MlC0gBGJQRu8YCKmFaaW9upvgnzlSbaM9PSy/b04Q30VxSgFybYO7S+usO/bbJJCvFuXOwmJz4ByCXmwoJpzR7BBelrCVUIUsYAldmOm5UQhqH7Xa9hliskhdR8aUvcimM2FwWBxWSjb/VkBtTs3ozVzBpl2ziEKafxGykE1jCvdKJ8pWdsP3NNeYU3dRHEVKzZgg0KnQRxCH36smghxBBRkQyW8Hg5PXuXkV5a4Y27npHzWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from MW4PR11MB5776.namprd11.prod.outlook.com (2603:10b6:303:183::9)
 by CY4PR1101MB2295.namprd11.prod.outlook.com (2603:10b6:910:19::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.12; Thu, 27 Jan
 2022 19:52:26 +0000
Received: from MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::6cb5:fdfd:71be:ce6e]) by MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::6cb5:fdfd:71be:ce6e%3]) with mapi id 15.20.4930.018; Thu, 27 Jan 2022
 19:52:26 +0000
From:   "Drewek, Wojciech" <wojciech.drewek@intel.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        "michal.swiatkowski@linux.intel.com" 
        <michal.swiatkowski@linux.intel.com>,
        "marcin.szycik@linux.intel.com" <marcin.szycik@linux.intel.com>
Subject: RE: [PATCH iproute2-next 1/2] ip: GTP support in ip link
Thread-Topic: [PATCH iproute2-next 1/2] ip: GTP support in ip link
Thread-Index: AQHYE6E3uNj6Jhw6KEmyyxEfdx06VKx3Rm/A
Date:   Thu, 27 Jan 2022 19:52:26 +0000
Message-ID: <MW4PR11MB5776166C06742503C765BA2FFD219@MW4PR11MB5776.namprd11.prod.outlook.com>
References: <20220127131355.126824-1-wojciech.drewek@intel.com>
        <20220127131355.126824-2-wojciech.drewek@intel.com>
 <20220127091335.410d9edd@hermes.local>
In-Reply-To: <20220127091335.410d9edd@hermes.local>
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
x-ms-office365-filtering-correlation-id: 0afd8cd4-bfe8-4de5-96db-08d9e1ce8b65
x-ms-traffictypediagnostic: CY4PR1101MB2295:EE_
x-microsoft-antispam-prvs: <CY4PR1101MB2295E4D1AF7AEDB2EF2B3BBFFD219@CY4PR1101MB2295.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:421;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4sCCOryxmnpZIpsnp9vXBgIYsl5GJyZGAxK+VrnxcAHm71dUyk2WitXGAEF/X4CGW0BQwbOaYSo07JnD6i1IAkYHKD8HeyaZYHXo9zDte564y1LTGMsobzcrbvz+7p66mfChzcxaolLHKmcx4NPJ7y4ob5TGB8j9srSGx5HivfQRs0tuLKobGrreGCva+WJoBHbTHj015gdpBhweJc/ZGLOwikNHXD4+fXEEVZqjbF4uKeEhG83LB0zy5r+7jTVGL572ZwbtLXPHlsqCY1w08WC7DFM7fN+mP9YGF4P8k0wtXAjbJ7X2em2EAXq+xVD/8mNaozI2ypzsuzISpsV+W/bAilMHX1EOj7fU1YFjBSctu5u/ANt/3IDtW/virxD6GweFXHG59GPjNJ6TY43aB4shkEeUa7Eh/+0knGZ8gMQz46NbVo1BZslbe+tTHJXsfUn/pk0gjQMv/oZbbTCDGAyfO/wDXdHahkudG1mKhfB04UpY2INp7NjWJ3jeAIDlZ0DkfnWt01oY8cmQxyLhlu072DxTVniPgZwciYN4bdwp1zPsQ0P8KGY9aOpmd6TOITseYOroEberwpo+0d3qobipL7aYFeysJj1cIOTpCbCCamDEHkcgjzODy5ezRw2SnqLHMidoQvLHPMGe5dAVWIidAzHMHYB9uk3ip5EXyYtvb4mr4S2/u6qRpf+TIz0BGAGpHRdy96ODlicbb9lhyw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5776.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(86362001)(9686003)(66556008)(53546011)(186003)(64756008)(8936002)(7696005)(8676002)(38100700002)(6506007)(52536014)(66446008)(54906003)(4326008)(71200400001)(76116006)(6916009)(508600001)(82960400001)(122000001)(2906002)(83380400001)(316002)(66946007)(66476007)(4744005)(33656002)(55016003)(38070700005)(26005)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?9NyUQ047qnzLY0PcLE97frG3Q837DSsJMHukrJUvBSfsDql9S5LdDN7hZlj/?=
 =?us-ascii?Q?XDg4/1LCCR0bbtMrVarJsvFhn+QtOB4OgBDxjOAETrt52cNvgrjPGiJ0TAO8?=
 =?us-ascii?Q?Cq3ayxeRU43cb9Ymcp1/o7Jji5Qe8e9goRbv8XT4hni0Cpf4KxzteW2ncnDC?=
 =?us-ascii?Q?vDg6e78ou6fFUlCi2tw9/RZOGlQjYzcJrZ0kq8i5FJd7JVIBS1f27mruPwMc?=
 =?us-ascii?Q?aXQijqvazVDtGttteCRas2kSBRPS2ErjCDI8bE+7v6XoUAc7MRpTQt8N0u7L?=
 =?us-ascii?Q?BaF7kQgPI/+k/TJyAGQfxWPLx6DdEU8DPoEVw0HmakrBK9YNQi2eyavaO6Qm?=
 =?us-ascii?Q?J0awoUxBJVr8VTPX2c1o+RcOUL4OxRiWDqECwJ0QQaSwIs+W+MwGmbuo87s9?=
 =?us-ascii?Q?xW41i5OObOwP2UEfcw2y31m1mTTgA+wK5xkn3t50fJuyLekfbry3KopNJL1E?=
 =?us-ascii?Q?l0GMFR51BDJy2arC0jJMkfoj9OAnTSXBoAW0oHNcy+sEc2cmJq/3M+4Fp9gZ?=
 =?us-ascii?Q?/im2e4d408rsvoKtY6xDSFIL7kYpK++PO5DTejoYRMEIqV0sKMzEpEmot8K3?=
 =?us-ascii?Q?aq/HPoi0PiZy22ndTWRVVcljDYWMpJ7KNgSEJPejI30VTDlkQCBSvcT/MtVt?=
 =?us-ascii?Q?/P1CtaHzqHFNUJJVM1hlmogJ3qL2h3W1X522xC/M0vNurO/KeNEM3iM3sU//?=
 =?us-ascii?Q?K1aWjxkjutS5ZHD0UGxtC8R+Em3ASjig6iu/sm2RzXQpTIp/5MCSOmcW5sP2?=
 =?us-ascii?Q?ZiEpBe4in50+bnb02WonA47NXh4QX+73/oyZ3UwWpz06EVqX70Xo2i3qjRGG?=
 =?us-ascii?Q?L/uC2m84HDdAXf4VQMKKLumAv1RIs9OVow+O27tpbusljK5HhOqvOGIT+l0t?=
 =?us-ascii?Q?XQAKmFiyNKHut8b/JDa2/Wzy7nFV2ylGT9Ze47AW41KI5VVV03/5A7O5pltX?=
 =?us-ascii?Q?ZdFCvWH8ARfaqu1YIzGU18d7xsDJ0hKDmbLqVW7M5c0mluDZR+96PC3O8HG+?=
 =?us-ascii?Q?1y5ALurEnMdLRJiVRdLFViGT2u6UXjVdvr/2ibltFeauGZz0NNdVyZKtB/dK?=
 =?us-ascii?Q?rB6GJzH9r09Q7lAqgaUUlSlyfgNk9IXNXFNHvmGuBjL7SLspvTfLsReVLKjz?=
 =?us-ascii?Q?yVKng0e8jkV9m/kmEIzzpBFrEBE58TTLeAJwX0KpZ8ioaNkOp5Ie32AOhN8k?=
 =?us-ascii?Q?9RqPttS6Cd/CH/39jMP2x3wB+wHetFZK4I4uPINaBoOhocXvFNLvs7aRNHy5?=
 =?us-ascii?Q?WNHDvIJQ9HwXSK8RH82E+EpIgtFEPoCnrl1YsL2NOhM5TJSHNskLU5Fp96CD?=
 =?us-ascii?Q?owyvGUabLxCOMlDQKNgwtu5RBOUBvRrxCAAeIGdSkrgy21rxEa5LIdfJeIqE?=
 =?us-ascii?Q?kvxvqJuIzpjYkWd99HvU9S9+U6tb3C0IbBvT8jOQ17SUn+e7/mvjazgnKw3i?=
 =?us-ascii?Q?TOp9IZ2ZNem94eupbMqTTsllZOFjLzTxTjggRmuzgn58i5dPfn/hCDNhEvhl?=
 =?us-ascii?Q?iq6+/yKxOS3sdquzTZ0V15HBKVlBnVtoTKPQkxgr+zDM6dfPbMKwhf3dpqsd?=
 =?us-ascii?Q?j41tJVgeZAycwlgwTyguSQonp6ygo0YZ+Z5uzY9oqNW646Dzeja8ZwCzX7fb?=
 =?us-ascii?Q?f3u1rkxghZFWu/sRqZUKfwngs/KbZSmUCtI0h34kPqfXFUSZEXdHX8WG+TXP?=
 =?us-ascii?Q?tOHVow=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5776.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0afd8cd4-bfe8-4de5-96db-08d9e1ce8b65
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jan 2022 19:52:26.7526
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 56PMLJeoZ0aDRLebbdRzbFS/rmi6k7u2Ic6TYxebML7sovYfJRxOv5vnTFlr7cfElOl86XQMoYVC1BfrUBYlYlKbV26QjoCqJ+E6SVo7AdI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1101MB2295
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Stephen Hemminger <stephen@networkplumber.org>
> Sent: czwartek, 27 stycznia 2022 18:14
> To: Drewek, Wojciech <wojciech.drewek@intel.com>
> Cc: netdev@vger.kernel.org; dsahern@gmail.com; michal.swiatkowski@linux.i=
ntel.com; marcin.szycik@linux.intel.com
> Subject: Re: [PATCH iproute2-next 1/2] ip: GTP support in ip link
>=20
> On Thu, 27 Jan 2022 14:13:54 +0100
> Wojciech Drewek <wojciech.drewek@intel.com> wrote:
>=20
> > +		if (role =3D=3D GTP_ROLE_SGSN)
> > +			print_string(PRINT_ANY, "role", "role %s ", "sgsn");
> > +		else
> > +			print_string(PRINT_ANY, "role", "role %s ", "ggsn");
>=20
> Why not us trigraph?
> 		print_string(PRINT_ANY, "role", "role %s ",
> 				role =3D=3D GTP_ROLE_SGSN ? "sgsn" : "ggsn");
Just not a big fan of it, I'm not used to using it. It might look smooth he=
re though.
