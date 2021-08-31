Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C6C83FC696
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 13:34:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240000AbhHaLe3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 07:34:29 -0400
Received: from mga05.intel.com ([192.55.52.43]:45803 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229566AbhHaLe2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Aug 2021 07:34:28 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10092"; a="304028737"
X-IronPort-AV: E=Sophos;i="5.84,366,1620716400"; 
   d="scan'208";a="304028737"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2021 04:33:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,366,1620716400"; 
   d="scan'208";a="531061833"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by FMSMGA003.fm.intel.com with ESMTP; 31 Aug 2021 04:33:27 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Tue, 31 Aug 2021 04:33:26 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Tue, 31 Aug 2021 04:33:26 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Tue, 31 Aug 2021 04:33:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jLMVz4wy+nU8mvFJTPD6hk0cm0dlNE+3AeUTv7M2Hxo41++KJEM9ZVn1e65tb4pI+Vos6F2JfwXTUdA1KRsLiFvhnSc3Jj319Bw8I2mwkqCy5iF6IeL6mg/tjrejCBQp6na70Oaw0pDO93TSBAi3xNWrkvo/XtSQeRbajnWbHFyOedHOxyHGAOcyR2sOA0LjD/2uQc7Jix9ArlREgbcFA1G7E6ofp+gnP0s0esGVdZTEeDDks80W5cuGdK0lvzfLcvZI6+eFVQmBMWmBtIsrZZFAiqryyORO7LwFcAu/o32WcaFaPD2RnbrNeSobUQIlTH+FE657HwOocbvCLQzyaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5aUoZ7vgJ8jKF+1dw+X/wTqdLiVmZFsVi7URc1LUYSs=;
 b=dtbd+KyTkZSI/Q7Lqpy3su3Sr/+Z54PouHj8GXtknFAW7IrKTM4gLECdRexjWm3jfCBl4BGnCaWSAeTlC/2RRGtgeHXYqdsmvF+dOgMPwv/u+/592gm7pWcYC/9SYoxw79Zb7dQHl0XUGjL4rpx7Z/oIWeqFST4QvTxajTf9yTJiyNeCwYf7lYcEeLh/CJ3yOawpFl+filntFJLp5rpK9PL8FBdfColdgw1xN41ps50vIcKV4e5LtBiouQj7QuyBK0/66nWja/NuGAa6eWyK+UVCFwZyBVb2yR2uaTCKDUM3cMB6M7QzUIihylb4ki09Aybh6/Wr3FStytnuh1MCzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5aUoZ7vgJ8jKF+1dw+X/wTqdLiVmZFsVi7URc1LUYSs=;
 b=CEohaXzlsnpHmPlVsM9q2dzrOUL2vKqLxzamKdZvImNoqO8G8QthdsaDO+sXx2KQfQmtQLdsWAryNKdiUcsxCDku9Kpt4KvpLnwk/81SONpjvgXfJOLHsUlB/nwW4AYodQKdzgxi4qywvit+mrToPwHgCcbkXGex+LVWdPXUo1M=
Received: from SJ0PR11MB4958.namprd11.prod.outlook.com (2603:10b6:a03:2ae::24)
 by BYAPR11MB3045.namprd11.prod.outlook.com (2603:10b6:a03:88::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.23; Tue, 31 Aug
 2021 11:33:25 +0000
Received: from SJ0PR11MB4958.namprd11.prod.outlook.com
 ([fe80::7865:f66:4ed9:5062]) by SJ0PR11MB4958.namprd11.prod.outlook.com
 ([fe80::7865:f66:4ed9:5062%7]) with mapi id 15.20.4373.031; Tue, 31 Aug 2021
 11:33:25 +0000
From:   "Machnikowski, Maciej" <maciej.machnikowski@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "abyagowi@fb.com" <abyagowi@fb.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>
Subject: RE: [RFC v3 net-next 1/2] rtnetlink: Add new RTM_GETEECSTATE message
 to get SyncE status
Thread-Topic: [RFC v3 net-next 1/2] rtnetlink: Add new RTM_GETEECSTATE message
 to get SyncE status
Thread-Index: AQHXnP8G0rXtbOmRxkCrNLlOsBrAhKuMW7EAgAEBqeA=
Date:   Tue, 31 Aug 2021 11:33:25 +0000
Message-ID: <SJ0PR11MB495871A89632732B0028404EEACC9@SJ0PR11MB4958.namprd11.prod.outlook.com>
References: <20210829173934.3683561-1-maciej.machnikowski@intel.com>
        <20210829173934.3683561-2-maciej.machnikowski@intel.com>
 <20210830111416.34a8362d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210830111416.34a8362d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0d980634-9030-4a76-6bb3-08d96c732549
x-ms-traffictypediagnostic: BYAPR11MB3045:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB304554FFDD1FCD19225DDC1CEACC9@BYAPR11MB3045.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: J7sIqF0fA0ND6Zk/szC1nSTsEfDR1blOwz6PYj0nTwKsZ6b1BXuZ4vs4Zd2QCYfR7erEE8rg17RoFkzbTd1dM+W7MekE1hbWq+4FaKuNjiTR/gD2+IIOfkeJmCTuFLgoLKc+doAw+szeVNm6lhqdemKZbrUP5/2zf2wcblrVdkYay43v6RuLMAIguBsf6pv4fbc5NNjfJWQ9K88oPFCuOgGpgHalylvRslylSLMAztwaiNuhLX4lQw5fuFWQbVQg4kM7D+2WBDLiXaEvWXvFRBsTW4tcBrC2hS3HV4M8XXciyHqZlH6Mx8R4kPzMuihvKfPpoPT1eHyX32fHpxaiX98HACbKcB542nfqM15n/Zb0z2tmecD7XcLPuv56KscbX/saXYF+ah7/6jG3WPrF1O+9Sft+nfvr+tqINSkf2q2N5QIKi6PZ22Fr7hO5Pg0RqkbeU0wcaiHJMYcj1echv0obB56edylC36pB2kg8HQF02pkwZjkEcIiR+9TvKc1USpcTL5qyXPvs7SipLZECAEl45uef2uCJWrl+PBkOcs5wBteqHbwJKaprGLmMl+KPL1Y6LSvJburP4GdLC1FOBJRuvB3IvTwdvFkkdp9GhNCkxKzQs0oSgWJkM8IWqD99LtS+aABPZhuvjcPngxBsDoZsYvVc8NHJ0XxH5TeYYvzUfWy8mIh7a4lZQYo+jEIzVyP2FQ/zQP5DOGrVFaOegw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB4958.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(366004)(396003)(376002)(136003)(7696005)(4744005)(6506007)(66946007)(66556008)(83380400001)(8676002)(186003)(76116006)(8936002)(2906002)(38070700005)(64756008)(478600001)(5660300002)(9686003)(6916009)(53546011)(15650500001)(66476007)(54906003)(55016002)(38100700002)(26005)(52536014)(122000001)(4326008)(71200400001)(33656002)(316002)(86362001)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?0ddnniKkhDHkhElkq7hTLNLBag//vrrTT1js3hO3Jkf+J2Zrr0WCvb1jhVKe?=
 =?us-ascii?Q?7J+V3jHjvZ7hP8TWyStFIPV7hamBhp3xMFWqW1AunpG1F1mUijetx0+tSdDw?=
 =?us-ascii?Q?TbEkgab2NM/LnrP6LJDknwXK2C7jkQTM3mQovqo87OpgFRq39+N5apHJQvuZ?=
 =?us-ascii?Q?ECKOb2twvTYlKoMXEnjSCArr0n3bpX1k9HnRVQ2InauyGTD8PTnvDiTuN2Ii?=
 =?us-ascii?Q?MSEOrv/0G5GpsKFixW5U3Wnf6Rvtj3b4yU3k9Bt6HMyfyk0PTFD9XIg4YZpR?=
 =?us-ascii?Q?0yOuVZ+nkmnA+E1Tv+XSKKJpI+AL7uLn8ocgqpI6Ejb14OvyLYxueMRQPYvU?=
 =?us-ascii?Q?JdiyX3TEKP5Qd9HYX6nePHl3jv80RGa9bf5gRU4+lJ7wu8ORs9QKKElAkuRS?=
 =?us-ascii?Q?gfSBl1Q1HnvkD0lUr0DiXJo85uSp3STjlXa0hfgnBMWEqZTYhlT+jttMHHjV?=
 =?us-ascii?Q?hL+fdsFkcc9f9Xl8hHvGtme/tm8nitpfHfuxOsJu+1MdJ2FdCki0HfABFlub?=
 =?us-ascii?Q?xcwWxB2fPe21pMh7RvTGo6EQGP3db5VL7LQNHx2zt4Lulgue3shbZJTOKvoW?=
 =?us-ascii?Q?kvKiHX/fxzlRQ+6PFVtEKH0kGk6Dul8M7D3wvge//Yt7WYwp77N+qSBd4L5U?=
 =?us-ascii?Q?4epbDHrZMyMUg1fRaFsg7Ak7ChdOnl2HnGHZLGhC9orXIRd7lCOfv5P0RpFX?=
 =?us-ascii?Q?dmv00j1VnzirE4BgAPYeflF0rj7ZW+yODff6zsjb+B0H6GvZypdK7u7t03d1?=
 =?us-ascii?Q?X/lfFPu4/0YW3GkjplyPcTwSoY+YL1zIKZZ1XEarTCx5h7ggOF2UsasI9zZV?=
 =?us-ascii?Q?UGPf337dIzAeT52pb4oCvwA9Ec2cHe5AdhGpy1lFaeW/oYLbFPHL4mNSqfc0?=
 =?us-ascii?Q?cyW8dqp+EogYJ1iJ85pwQrc4G1S559+IRaWvbxMwPAOceNA1XbP5Y9F6JxJT?=
 =?us-ascii?Q?GW9xYKfQAEmWUMz9wrz7X61LZcxutAdIa2aKuR+gZZNL9eXsIqT5zPKO+Ptj?=
 =?us-ascii?Q?TcDm+zmc9RsOH2RcasPLkVUe16cHhJ+v6WDkfaxTG6mQ40GgPGsvsqeJLrdL?=
 =?us-ascii?Q?ywtQfya6MJqCfELCdghKnHD9Ovh9Z+bNKm6B6IyOqN65AuL80JtYILNvMReH?=
 =?us-ascii?Q?aGceSxrE/2wrBJ3lzgS/rq9+sypDwpwdd5cWJtBymwnkytiu/jLP11xpWqzX?=
 =?us-ascii?Q?8gWfaKZd+on6wPgcDdybm9syKZZh015zZ/9qn2DnZkQ/38jYblCB2Y6ylZjJ?=
 =?us-ascii?Q?dlkR/55mNNP8DQz9tHgavLhqBB5gk00U7kha6NT/HZWZrdlPOJDHx8syXL2h?=
 =?us-ascii?Q?h30=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB4958.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d980634-9030-4a76-6bb3-08d96c732549
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Aug 2021 11:33:25.1267
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KvoOL9O/p34XkjnC7j8LYQtg+M4EiMvpBmIw3kHxlUWBtw0shk3PEOCF2lH0He6hxKPDIpz2XrMXMg8o6I6EP0SIjvJjf0deaX6+AAY2MkM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3045
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Monday, August 30, 2021 8:14 PM
> To: Machnikowski, Maciej <maciej.machnikowski@intel.com>
> Subject: Re: [RFC v3 net-next 1/2] rtnetlink: Add new RTM_GETEECSTATE

> > +#define IF_EEC_PIN_UNKNOWN	0xFF
> > +
> > +struct if_eec_state_msg {
> > +	__u32 ifindex;
> > +	__u8 state;
> > +	__u8 src;
> > +	__u8 pin;
> > +	__u8 pad;
> > +};
>=20
> Please break this structure up into individual attributes.
>=20
> This way you won't have to expose the special PIN_UNKNOWN value to user
> space (skip the invalid attrs instead).

Addressed all other comments.=20
For this one - I'll add flags which will indicate validity of all values. S=
ince=20
this structure is self-contained and addresses the generic need for state=20
report.

Will resubmit as a patch.

Thanks!
Maciek

