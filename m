Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FEC14B62A2
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 06:26:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233972AbiBOF0D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 00:26:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231970AbiBOF0C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 00:26:02 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17A051160E9;
        Mon, 14 Feb 2022 21:25:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644902753; x=1676438753;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Xm1B8nuIHGcJp2gkK2FA1txN3e3LMJyP5hC+uqgdgMk=;
  b=NrdPKTCOf7F9odB2HddD+sAnGQF4DynPtXw/KMvJffwFqhzNPk5yP2UO
   WUupSMMYBS7olOp0xKlHUo9Ds1Ro6FXByU91qPsXnKEFe7X40EsgsOlYK
   CfgxNC9tNA4Hs3ljkz3OfB8nXgouAClY4CXSpkrT/cdU7tke34R7BbiJj
   Zq6iV0hIiNRhYLO7HAkci3M1H1/2G+Pf2t6qb/Uwpd89AlaonjpEJzfvd
   VhymM1YXDccnNTIPpsf8l4WSxYLMDxUbXqSHDSGSbU29h45leTMMyEMQH
   b4d+tKnXqWh27xEQ35hChQdQqB4ZA7FKy7YxPptQT/l5F2OcPAwuzC01L
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10258"; a="233799199"
X-IronPort-AV: E=Sophos;i="5.88,369,1635231600"; 
   d="scan'208";a="233799199"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2022 21:25:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,369,1635231600"; 
   d="scan'208";a="773363528"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by fmsmga006.fm.intel.com with ESMTP; 14 Feb 2022 21:25:52 -0800
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 14 Feb 2022 21:25:52 -0800
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 14 Feb 2022 21:25:51 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Mon, 14 Feb 2022 21:25:51 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.40) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Mon, 14 Feb 2022 21:25:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c/Ae+8+/uQwDe/t7y+Z/H9GqWpll4ukeWGVNHweZPBIPvWzurJEfIpIodQdNjavam9gOfzvPM5XQpXpy1LUimJ7Gj7lGOGkHMSKRBW4yCrQGphRPM+7dkHlEY6BpnCm7XUsMX0xKcfSAFrNNTWTZuWBfhn5kJ0c0KrZ4kZZ1yAfcz63xCf7mnurxE6jsMjZZcwNYPS38zApBYZpNILU4iXKjehIrLzVb0a66JeM3KTGbxG9QMl7GLrF2p2XnXLOsdYpbXRtuRnD24fV4qZbx5edXDgUbK+xtOnWU8+nofe34zpewn9orVg1/5glLdOToYmECDeGK6/1fiWAJvxUBDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xm1B8nuIHGcJp2gkK2FA1txN3e3LMJyP5hC+uqgdgMk=;
 b=ZCmZcmDVRngS6ZTKlgotYHVj7V5JBiYLvCvxoT2sUeqvv/l/jL+lJcbs2a2bdCDnZlvcOToYmy0FPPdLk5d9KSstp2Rco64dcZJT2W6V4+CsWrGhuoVEx8/hBrlIVU6GYMt8DFWdukzfG+hH0X/rR0kDEWy6EYmmVqA2sT2HAg0LiCmpJBoBzYdEMmSEBp4wMpmfi/DSuz85+QpsHl267S0kr2MkklLoN1tbeM5hKYVq6VbCnsqjKI/L1N1vOD8ooPtMfOSfo1HxAJf2VcgHC7018Ow0BVy5AHZx7jRe9h34L4rnWdwcHyoIgNo5n79A9MeGv4LpD9IILG1RJkWGGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from BYAPR11MB3495.namprd11.prod.outlook.com (2603:10b6:a03:8a::14)
 by BYAPR11MB2998.namprd11.prod.outlook.com (2603:10b6:a03:84::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Tue, 15 Feb
 2022 05:25:50 +0000
Received: from BYAPR11MB3495.namprd11.prod.outlook.com
 ([fe80::714b:35f9:5767:b39b]) by BYAPR11MB3495.namprd11.prod.outlook.com
 ([fe80::714b:35f9:5767:b39b%6]) with mapi id 15.20.4975.018; Tue, 15 Feb 2022
 05:25:49 +0000
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
Thread-Index: AQHYIVEt5rY3o3cDa06/TofCdTpoOKyUFSsAgAAAT1A=
Date:   Tue, 15 Feb 2022 05:25:49 +0000
Message-ID: <BYAPR11MB34959983354A8C81B065AB5EF7349@BYAPR11MB3495.namprd11.prod.outlook.com>
References: <20220214024134.223939-1-haiyue.wang@intel.com>
 <20220214212136.71e5b4c6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220214212136.71e5b4c6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
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
x-ms-office365-filtering-correlation-id: 6b18702c-2c8e-47aa-6538-08d9f043a0be
x-ms-traffictypediagnostic: BYAPR11MB2998:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BYAPR11MB2998C670BB9B74A0B5DF488DF7349@BYAPR11MB2998.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vuPzhrc1h3y9p/tgsZymiPqquwY/2zfS84N9xOdOA506DaoYgakjnF/d7u/dnlkJciDYiK1KUo5S8TdYXF6cF40ZNDqJyGTmy8swSgSvDpHyQKh3mH/3hQJuNlAeF0BHKNjhY39nZ6HuIqAtExoEVHxr9nW8BmBID6hjBAUg1ToyM0+jgkIdMMLGP8csdmoYQSyK56WEtBJ2v94fNRD6yN6FYuEfr2tj5QZoXRtc6XPsfbifh5w6v0+dLOaQNxEPOSEDIAk2OqY2oPQ3Hb+iMeabPN4+ZzrGDm0zrkrPmEOM2nop2B/XxladmWvbFa+vCT7pXGPGvY6wxt3vY51Nl0ega7jNZCNJnENm73wYXnXZZfjfFdop0zqABhfFxiAMQGacHEvVnzWFAEfZE6mSSwzkba2PfEhGAVjn6cAP5nvyL8uIvLygolWZJU0Aecw5sM576c0YzvYhq6hT9qFR3W0eMuQmv9r5fT50PXiouwZQCt51ja6K5tWtxrrjF43csefIECa6JtT/UpNi6aypmFhet+NBAa5RO3/ja9bVfZsnuvKXclqxf7UT1r72yAQftuA6JeSk4AbmsXVbcQGS0plBeq1SQ0LfqFGxCjIn0N4AkR1Y8wwi+NxeJgSgpSBx7viHBrBCtacgrqbjJhBtAxk1dQvBXa+saMy0aGLSDhL+sRhul54nrAmbbuNNmtIhOY2/Qvx/Yf229wauBy7Gag==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3495.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(8936002)(7696005)(7416002)(6506007)(122000001)(54906003)(53546011)(38070700005)(82960400001)(6916009)(316002)(5660300002)(55016003)(86362001)(83380400001)(4326008)(52536014)(66446008)(2906002)(8676002)(66946007)(71200400001)(64756008)(76116006)(508600001)(33656002)(66476007)(186003)(9686003)(26005)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?XthrZzAdSSPy26seX6oRtbQYxiby3FbvHD5oBT3eA4eW5waVudMudL2VFmtA?=
 =?us-ascii?Q?AqqyriyzfM4xty4Ec47qJi+bqQ2B/LWA1HkzYTyMfCSzd7yRe5lxS06ktms8?=
 =?us-ascii?Q?w/XDqNsvtu94R6hy0GthIu0Psf+DMxIghdD0i9IdkJjPVFcW8Y6oKDS88d3i?=
 =?us-ascii?Q?FI4NTD7dkJCd2kF0mQofLo3iInPWEEfTBDCeSG7TTWSG7AzkCf6oHhrUiCFE?=
 =?us-ascii?Q?Y//RxQDltN6zqkTx4Qc67uMXjJcsWoDd4hhYdMzvVJCwQUPIBGr1TGJmazr3?=
 =?us-ascii?Q?IYeL1OE/KclelXs1Y/zYKPIUIBSVC0ZY9sUED1fOKldeOwLRmcCbmLFKJAz+?=
 =?us-ascii?Q?yaopb+9VAybG5XKhnC9o6SiIxoITCrCUaFBu1oeO2OR61bAjlGwEz+U+8TUU?=
 =?us-ascii?Q?LxHGS17hrRoa2aVWaPDhiMh/Vsm43IId1K9osniZLa2uX+Z1LohVc+Ogq7qE?=
 =?us-ascii?Q?bERm5KFovVDtElqAjbrTbHU9Jh6v1+FjSq4GcSDi4AEzN/ZIwybko7HYMs5l?=
 =?us-ascii?Q?P0Y1ACdFy10WtagnPM+H2pFCDtxhpseJSyLNaHtUYO7WHOVU/Dp01WXmZFQW?=
 =?us-ascii?Q?Pq92R9p1lKMvlpfDq6Vys/DF9m4Dud74+g/z0Rx29TXnMTR+MBiNbAMfGX87?=
 =?us-ascii?Q?iEdSohiJtonvdu1qCxpfK+FRpqdbNvLYtYo7nW+SYpbtiywE3URS+OOhIpT+?=
 =?us-ascii?Q?fCqB/+wgDoaKayBJZQ7naC7nfrmDTKVz3Uc5pIBh0It6b0ejuF0qkocjVlzk?=
 =?us-ascii?Q?fWF7hfL/6XX1es3zoOgwVur2palG8jEwHPEawaPukvNutv7qjFdSd9DKpeKB?=
 =?us-ascii?Q?oOdf231cawdQ9pfpIl0NjCrkOsXQ7oWcMe6tgejs2ExPlVyuyLS06GR6+eGk?=
 =?us-ascii?Q?iQWHRA3DvfrkZSR/q70r9pdXHTjgXjueHTQ99WXndqpwA/TdWwEhWyZTHyut?=
 =?us-ascii?Q?pUzvy/ihFuAh8V6zuT0stvxYJw6IRBdylW8hQCOB6e/j2hzYBXvWnQCQpWHq?=
 =?us-ascii?Q?sZMwpS1VVaeWNZbx5q/RIdvbzLB2VgIPjz1qPE9/mH/ALzuh3RZIlkvzdFmP?=
 =?us-ascii?Q?Orlgjg+Mq2IkZYXfM2qA+tKhaNNbJ5hgjmY9rmzdt7h1kJDZeO3jsZiTbfuL?=
 =?us-ascii?Q?gGnLB5zWuYvj0fbpkv+g1TtUM7/urG9ZZPaoLlRnuUi4grfaQ6IZwzntQMe9?=
 =?us-ascii?Q?rI6GkIfPEHA+ki/ueC15ko8vCe1wR5s5DTZIYvnK2Cv3oJwISGSjsBDPv+50?=
 =?us-ascii?Q?VRP10ifzn4LWPWzbNSO0hfxx7hcnt+kfwYphDSo6mXDGGKoRf3BW6d4kxXo/?=
 =?us-ascii?Q?4ljhb0CdDCEada7mrQKlr/2A6QZf7Kwbm8BMv88PE2cEQRTpXwwL7IRPN1Up?=
 =?us-ascii?Q?eOGOL9+uO5fguSpw6GekVIsii1pBz+rMEl+fM4D0EKy+wyzcPJmGLODvB3IV?=
 =?us-ascii?Q?BvDynbSysoRf1JoxexZiIy5yLH6CnQ6ghGGLNXRgu68kRmLXIRGskXhfAoIU?=
 =?us-ascii?Q?g1x6fzWj4KOadcVEZuzt0KIqQKd/Nl/On7MMtqEkdmX6dLwQvdPgGWlu8e7w?=
 =?us-ascii?Q?pyxyqJN81oVzNAU17UDPYqesN7ZT0v9aHGUR7X1FmCJcQ7kjkHO0DIawI2Y5?=
 =?us-ascii?Q?GQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3495.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b18702c-2c8e-47aa-6538-08d9f043a0be
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Feb 2022 05:25:49.9162
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UNv+N7g4FjhmWagFyCwRGr1CH0MMi9NqSvvfbKjvBl+StO2hREllncA58Cq0yhR0ttqpyJeLnNZKaiTmzG1HYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2998
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-0.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Tuesday, February 15, 2022 13:22
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
> On Mon, 14 Feb 2022 10:41:29 +0800 Haiyue Wang wrote:
> > According to the two functions 'gve_num_tx/rx_qpls', only the queue wit=
h
> > GVE_GQI_QPL_FORMAT format has queue page list.
> >
> > The 'queue_format =3D=3D GVE_GQI_RDA_FORMAT' may lead to request zero s=
ized
> > memory allocation, like if the queue format is GVE_DQO_RDA_FORMAT.
> >
> > The kernel memory subsystem will return ZERO_SIZE_PTR, which is not NUL=
L
> > address, so the driver can run successfully. Also the code still checks
> > the queue page list number firstly, then accesses the allocated memory,
> > so zero number queue page list allocation will not lead to access fault=
.
> >
> > Use the queue page list number to detect no QPLs, it can avoid zero siz=
e
> > queue page list memory allocation.
>=20
> There's no bug here, strictly speaking, the driver will function
> correctly? In that case please repost without the Fixes tag and

Code design bug, the 'queue_format =3D=3D GVE_GQI_RDA_FORMAT' is not correc=
t. But,
yes, it works. So still need to remove the tag ?

> with [PATCH net-next] in the subject.
>=20
> > Fixes: a5886ef4f4bf ("gve: Introduce per netdev `enum gve_queue_format`=
")
> > Signed-off-by: Haiyue Wang <haiyue.wang@intel.com>
