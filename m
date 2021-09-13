Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69D334084F1
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 08:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237470AbhIMGvv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 02:51:51 -0400
Received: from mga18.intel.com ([134.134.136.126]:33644 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237490AbhIMGvu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 02:51:50 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10105"; a="208693760"
X-IronPort-AV: E=Sophos;i="5.85,288,1624345200"; 
   d="scan'208";a="208693760"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2021 23:50:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,288,1624345200"; 
   d="scan'208";a="506977046"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by fmsmga008.fm.intel.com with ESMTP; 12 Sep 2021 23:50:32 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Sun, 12 Sep 2021 23:50:32 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Sun, 12 Sep 2021 23:50:31 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Sun, 12 Sep 2021 23:50:31 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Sun, 12 Sep 2021 23:50:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q2HYLuMwwRH7Mbk00AT7kR750Ybd8Nxetxe3EyQXV+4xGYnAL5Snnx/U7NDfBqsR+x2fnI54efNuXROv71DhvQIiCSwPfGipa4J103Qj+mos2aeh1R94mB64rpVaXFV2Ays4jrVKRweb3751Lm/ADS8RfC6hcoIwhQyF/Hoi+yQdQJ+eWweb/GCc/wovaVW91EgDY502QPdat/SacePIvlRlq1oJIJaucVzHTv6m7cFA1LzjzXqtcs/rQm6QsBH0frR+vBfL61ifktn90G+tx8BSViywnGT8B71Vn99XtncmGgFm2OYyRaXAj3SPSYYuuwLpugvCnDOozF07kAFg6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=wumHhr5OOXu3nQ+bERsXJB3MtGi54hWY++GeVsUaB2g=;
 b=aTukJKKuEUtNXr3mUU9PY20NaIRqN+Uu4Ml25A2lRprF4+XTmqiavh0xn/yBJmEi0XBxrJYV0vvt+YozkekjaoGi2LdS1U/MeE2t92Tb6O8MIPHbq/B5ImOWgd96jWmH9c+ieM7Q+3ISlWQ3OaELlhFEbTtZtHWAghy7JIOV65eWW0Ih7gUr9yH1OaIa/zMUb1f/X1Q9Zow4usTwMryIVqXBBiwaXKDaW3LFpEDZWJeO8lsKrUcdwYMBYN0kfd5cI4NevYCoGIEQIgoMJhu4gv2VpL/ByGt3n+LHubJhGD/1sMVND6hhjRWlLWhiJK5DOdJapJ0hadcMdJDcIiMu8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wumHhr5OOXu3nQ+bERsXJB3MtGi54hWY++GeVsUaB2g=;
 b=y4mNIdEHvHjfZgqUE+HQ4ocWDd6BNB8oR+ABwHnwN7bDXP/f2/2LrDCZzd1ZoEIivu7ooomEGhYVjNsCL2c+mFr0hAJDEFXRf3u7lzBozGAygpK3zihNfso7QA1DXcxv6OzJcOoVvQlV8mOZ/j3VLDelooxKf84/HrcVqf66wIE=
Received: from BYAPR11MB3367.namprd11.prod.outlook.com (2603:10b6:a03:79::29)
 by BY5PR11MB3960.namprd11.prod.outlook.com (2603:10b6:a03:185::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Mon, 13 Sep
 2021 06:50:25 +0000
Received: from BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::472:1876:61ac:f739]) by BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::472:1876:61ac:f739%7]) with mapi id 15.20.4500.018; Mon, 13 Sep 2021
 06:50:25 +0000
From:   "G, GurucharanX" <gurucharanx.g@intel.com>
To:     "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "joamaki@gmail.com" <joamaki@gmail.com>,
        "Lobakin, Alexandr" <alexandr.lobakin@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "toke@redhat.com" <toke@redhat.com>,
        "bjorn@kernel.org" <bjorn@kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Subject: RE: [Intel-wired-lan] [PATCH v7 intel-next 2/9] ice: move
 ice_container_type onto ice_ring_container
Thread-Topic: [Intel-wired-lan] [PATCH v7 intel-next 2/9] ice: move
 ice_container_type onto ice_ring_container
Thread-Index: AQHXlPPtSrzzfNXE7UWWRuatF1GMI6uhrTcA
Date:   Mon, 13 Sep 2021 06:50:25 +0000
Message-ID: <BYAPR11MB3367F482C33461F1861A189DFCD99@BYAPR11MB3367.namprd11.prod.outlook.com>
References: <20210819120004.34392-1-maciej.fijalkowski@intel.com>
 <20210819120004.34392-3-maciej.fijalkowski@intel.com>
In-Reply-To: <20210819120004.34392-3-maciej.fijalkowski@intel.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 87ee722b-a245-45a5-8b41-08d97682c3ed
x-ms-traffictypediagnostic: BY5PR11MB3960:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR11MB3960A58DE12D21A079F1C6C2FCD99@BY5PR11MB3960.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:883;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qDTifa+bjitlwmCE/MHLT7+LebrN72p7Ow3PWvvhMtKhleYsOJ8OCrFkvSnlZtrr2NoKpNd5FxNIMSB06TyNviGdwyLKXY6Y5Ey6mA16kP0KU8PTqFYlpRSleNs0+Aw2ysh3EgKDyoZzv9eLgQsN/Ozv+6dYtKNxo8KPKhq46T21C6GYrsCNNosGG11LwfMVcZVne7JXKqjqt5DN/A78DnFTv7Dkt4h10RewOctndcbRsFvpJjGF4lN7SiR9OoEBq2wfDoX1I7EivExKiTRwSdfmZofiNXl3g0+Z4qda+zQQzTgzbDPSCSNPuflNXFMdCvSDsjrRyVuygfUqk2FLnSU3WyWEO//o2zd8F3KDyLHIiqqGbaQ9azhkHdpFX+8rRSEyVXgyZxGFpK9XHyQw+OOIvikTVVcQjUgfj3c2DwmN9jWHrL5qZ52xkdmNamso0fer1yiutwbqOR+RG64a8H+sNoUqmG2wsXR9SK/lJwNTR5FCrd9uaHZjnOWW/LRta6CzLlRzyXuam5XiU7QLes5ZTkU3SFi/6CqDEqOkSKiyWyNAaPozOkoac32uQ2F5eJy0jgLq4hd85p+q0vNvfN7FDUDwvIGwMvLhM3D1a25ipXVg5vO4gU6/sCoRE/c4iUJoLpwqkKpbsrEDfWHpYkNiNeB+A56vx5PLAS2dwFfktGzKw6TnSrcwKykAt/aQMwzBHm8OSOE3NkWfQOJMBw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3367.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(376002)(39860400002)(346002)(396003)(2906002)(54906003)(110136005)(55016002)(478600001)(316002)(66556008)(64756008)(66446008)(66476007)(5660300002)(76116006)(8676002)(8936002)(66946007)(38100700002)(52536014)(9686003)(122000001)(86362001)(186003)(107886003)(83380400001)(53546011)(4326008)(33656002)(71200400001)(7696005)(26005)(6506007)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?GrumgvsEXi/1zqwRM8W21v/un8MxR/2KZqoXptmrfWSPeUHE++VMSMMtP65a?=
 =?us-ascii?Q?G6jiX8RdmqSRTapje1HyXd7YUSfgCBuGOhe/56BsdE+vou/1FqKK2ulkaKiI?=
 =?us-ascii?Q?GOj51S05ClHvkNI1x+FHWMEAqq+TdpCcXLOE0fn+k8RFQ9D4+RhN3ploOfg7?=
 =?us-ascii?Q?Mm+5eApGhKUtAkRRFmrj7Vnm7/KEl1igWOwChMKiLElkKqJlspcBzlekCUZq?=
 =?us-ascii?Q?e8lk/bEg+Huy6nDm3SUZU1BjAQfgqE9Ha3MsefbvCxDjJb9t3kF2TfVM0oUj?=
 =?us-ascii?Q?ODOo6AptiRIUaHRTZU5q1PtM6/M7TCiXM+Q6d7J6VDROdC6GPvX16Ga4tRTz?=
 =?us-ascii?Q?8zp5LSxrHIyoQOX/JuNCmvAEgCDGoXAZPPxUhbJGMYjT8r1GH7mYWwVMJghK?=
 =?us-ascii?Q?eRFZQzq2dkSV8Q0Wk99iK1kX38Q7t+IQwZ0owS2IOfUIws5+vqSRjr6tk9mb?=
 =?us-ascii?Q?oj4t8m34PwXrstFy4aZQGMBGr0IVeVbK0SOl9K2g99OB6SifurQaoZQHGxT9?=
 =?us-ascii?Q?lo/QlRVpSW1XOtS5Af6ZBB6kZghInrBW6DuVkkNL8D4+yO4Iz/2GpzP6Zpa9?=
 =?us-ascii?Q?byjpvSjBTXJ4yKY2fSdOPt+2jD+r9lAtmUQWIW2+rW1aSoaUs3w9NNngNjE9?=
 =?us-ascii?Q?74PIXAWNRIGYV/Ona9MUnqQWXufmZGzXMOCYUcCT6y2y8N4UWy+BScxTozDK?=
 =?us-ascii?Q?dNsQnca9obT34MLdS1GqebCayP/ka4Xtqu+x/MjdZOFPXDzteOBvvxkll6Ts?=
 =?us-ascii?Q?B0rhuSnBSMxZ5lm4bzn+Oqg7ieAfdS+SQbAk2dxUa3w+qRS5zH8IoWFf2aPt?=
 =?us-ascii?Q?6MPQkvAAz4xPgdKj5nN+IsfEptNs+CVbI/G0+oiQHnmnUuio2uDPzN8jbZGf?=
 =?us-ascii?Q?TMf8hpqxGEsluBaevsVYtVuHcplZHH+o3bwH+t1TscAiGUNGPQNA1MqUg9m4?=
 =?us-ascii?Q?Xjo+BJ+EzTnQnqg4yIaOtRZkzPrTWqEmDp9XlzGL6rFzFeN82nc9KNDvBKoF?=
 =?us-ascii?Q?SXxJfG6Cxh2wwBqwvpwzBsDOIl++n5cu7WVh+cf+qLkXcuDvNLrzKDm2OyWt?=
 =?us-ascii?Q?hOFD3cZ/7eYbtMpbdDgV1VG586WK3TTB+kL6dcKDffwwa0rpCTCvW3SWaXj0?=
 =?us-ascii?Q?2MByyQCmrwPxv5y4Lop0IQRDuSWI2ZjNgNlAUOcDvNEMfiKr/Pz+Jv2ZgTMr?=
 =?us-ascii?Q?NRJ3WoKOuzFEDkHQz5g5c/7OpOxLdy8IvBWysAc8ELjKgCu+UURARnSeuWmh?=
 =?us-ascii?Q?q5bn9ho/amV7TaWDgL0/Z3kkA7mDXgvYCEqxmMSNX+hBh77PuK9ZqhHSnN3Y?=
 =?us-ascii?Q?usxrGwx3xDElFekTxCj82VOC?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3367.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87ee722b-a245-45a5-8b41-08d97682c3ed
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2021 06:50:25.3227
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wLqp14LMd2cBVT9w6Qc+bPFS3/0Qhdu3G9Mej2WJzSzafr2fQkQHJ8O8bUymwzGHlnqAkS3EPmuHt656nT3SIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB3960
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Maciej Fijalkowski
> Sent: Thursday, August 19, 2021 5:30 PM
> To: intel-wired-lan@lists.osuosl.org
> Cc: joamaki@gmail.com; Lobakin, Alexandr <alexandr.lobakin@intel.com>;
> netdev@vger.kernel.org; toke@redhat.com; bjorn@kernel.org;
> kuba@kernel.org; bpf@vger.kernel.org; davem@davemloft.net; Karlsson,
> Magnus <magnus.karlsson@intel.com>
> Subject: [Intel-wired-lan] [PATCH v7 intel-next 2/9] ice: move
> ice_container_type onto ice_ring_container
>=20
> Currently ice_container_type is scoped only for ice_ethtool.c. Next commi=
t
> that will split the ice_ring struct onto Rx/Tx specific ring structs is g=
oing to also
> modify the type of linked list of rings that is within ice_ring_container=
.
> Therefore, the functions that are taking the ice_ring_container as an inp=
ut
> argument will need to be aware of a ring type that will be looked up.
>=20
> Embed ice_container_type within ice_ring_container and initialize it prop=
erly
> when allocating the q_vectors.
>=20
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_base.c    |  2 ++
>  drivers/net/ethernet/intel/ice/ice_ethtool.c | 38 ++++++++------------
>  drivers/net/ethernet/intel/ice/ice_txrx.h    |  6 ++++
>  3 files changed, 23 insertions(+), 23 deletions(-)
>=20

Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at I=
ntel)
