Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8022068232F
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 05:21:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbjAaEUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 23:20:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjAaEUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 23:20:18 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34FA436699;
        Mon, 30 Jan 2023 20:20:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675138817; x=1706674817;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qksYwYgybgNEjTcvWa81oPElxDjuTTlXjtPEOIa7e+U=;
  b=D5MSpsSJKzfy3LGwEHtorK4Xhc4Z7K62+HjtjtlpRNTX20IgKN67iXam
   17UUMPpnN8Cw4e8jRIHNbaEBv8SBG9qUeFuuCz9hWSbVocYAjwVZskLG7
   i3wJiQzknYA80ejwuc/Z5ME2jaxEAUonhcCH499o4tguuxlZF4Xhqhk17
   K7v9Xx87uimxe7f0Pw3YiW6meUKs5b+L+XetG8xRqYtL5knKRvHZ5Zv66
   bcA5GShJRcTkir1W05macFLu9km9KqKHFv+mLeD7jgVohIQ4TkVThCPqb
   /o1mEG9iRlGRfDYLOc33FOMb00YaTcaOAyLpXJafeT+nKrzPsi8aZlSZN
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10606"; a="355070261"
X-IronPort-AV: E=Sophos;i="5.97,259,1669104000"; 
   d="scan'208";a="355070261"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2023 20:20:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10606"; a="641813027"
X-IronPort-AV: E=Sophos;i="5.97,259,1669104000"; 
   d="scan'208";a="641813027"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga006.jf.intel.com with ESMTP; 30 Jan 2023 20:20:11 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 30 Jan 2023 20:20:11 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 30 Jan 2023 20:20:09 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 30 Jan 2023 20:20:09 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 30 Jan 2023 20:20:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X0Dv7G0HRrJ19CPr0WWQJoqMnuN5iEmg4zPOwzA1ByI/9/IkU9Sd51a1j/sjQ8Qytne/zXfAwn7J5Dmn7a/GhEUGea9K0IWjXLyzF/9eJJpG/lHnZpvPmAIgNoUsEFmPx3gsEYlVUwoqBBscbhbEuzvjX2xDh7M5QXOI41Rb2IJ8Nx4UQz4w4NnvQlzU1CqHqbrQNjdEXjg+3YKmyDczwDNk4Q84KJ9TJ7cs3fwbkZ6i/4VQCBqJ58Vy9DSTwWsHS+C465qYoPnobKSbLN5lVBbWm2QcO2QFiqgrx86/89k0aONNZGVFXNe5pBvF8e5gAf5EJ7gTx/0dALxtEtWf5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rheg4jaNeBGjWAGWgqlEoTkgXSUta52lN4CFKoS1d+c=;
 b=SJV8bQCSjfcyXrUwViFz6DRLxfrLuG237b82tAGZEG7gB5f4mJKOrtSayDloFacmL2hGvIf3AsQXfvmwy++6PcHfCfaeGMUrVWmIVdaj5gtMd51i6Yd5a8ET58C3Gn7XNnDPlF0JM7iqxPGju0jf2s135cFhnxwLMfiD1jI7cakyf50iukdnuc49kS15czpFG1wSZ19H6e4FfpS667H3L6/GtSEgv9/MG8gtqwYZv8zHsdHKdRXu0WOPR8+XXPABTd4eDGvh4SzLb1T+MurQ+xSN2ao1lLjEsS8SfgqsZD386M9kfWAogQjv9aig2lMF3ZHK7CdLciybN053ftvmJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BYAPR11MB3367.namprd11.prod.outlook.com (2603:10b6:a03:79::29)
 by SA2PR11MB4875.namprd11.prod.outlook.com (2603:10b6:806:11a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Tue, 31 Jan
 2023 04:20:03 +0000
Received: from BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::86b7:ffac:438a:5f44]) by BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::86b7:ffac:438a:5f44%4]) with mapi id 15.20.6043.038; Tue, 31 Jan 2023
 04:20:02 +0000
From:   "G, GurucharanX" <gurucharanx.g@intel.com>
To:     Daniel Vacek <neelx@redhat.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH v3] ice/ptp: fix the PTP worker retrying
 indefinitely if the link went down
Thread-Topic: [Intel-wired-lan] [PATCH v3] ice/ptp: fix the PTP worker
 retrying indefinitely if the link went down
Thread-Index: AQHZLEqNzb+bO6iWF0af7DRt8fYlYq63/dcA
Date:   Tue, 31 Jan 2023 04:20:02 +0000
Message-ID: <BYAPR11MB3367C4727A544546409E8403FCD09@BYAPR11MB3367.namprd11.prod.outlook.com>
References: <20230117181533.2350335-1-neelx@redhat.com>
 <20230119202317.2741092-1-neelx@redhat.com>
In-Reply-To: <20230119202317.2741092-1-neelx@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR11MB3367:EE_|SA2PR11MB4875:EE_
x-ms-office365-filtering-correlation-id: b79e72b9-495c-48b2-4020-08db03426ca2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 66i0dSB5FF1KGCUjKyURPJWNYVZ90TYhw+JhLc1A5LwhO1o1xPkrG2muDPOhNSBum0crF8iIjshbj1efrc863JbefPU8wxpvZPZm/rxiElu07doW9zZvxxq44CNPyGQcEcuh5NFRTFrKVxnwwv3qLYvHjtmETGYD5XW+OcTi5yH1eBkIk3l0r89yrerotxPz5PXru6mQ7gzlex1LQFMSxmq0ZbR8myrS05J1twEtvX3Sq81/iq5J+m1o+R4JYpwC4lrfaIL+zFcbxGMjFnrOLTvtsKyDMvrLNEcbawucXmC+H4otGkmiR3GEQWkX3UZ42QPhst3FBM4IYWSzFT9Xrd/BoGt8meYKs0fPta5PpK0m04OWn1LUxOq7DgbwjJn/I6wXfBGgNCv0qCIhx2Xa2oLW6FH/K1Tztr5ssZa12A2ZuQNCO3BrZgBApwQ7xSneK7tw/NdfG5yTarHDyl2ok1XmRwv8wQjA2qKeaqBh/Cc7wuXAs88H2ZKgD2MI9lwPxiwxy6TYYdZPrPAvpvT8jCVt08GEg7x/FpTolxQr+vJGAWzUrAfiKuZcqR9LgKUZEyO+6Bl7HcOkYs6PE5djjBXexCX3ZNrJSuRNbq7wxzoDJtOCz68cWPdzOtHI7DC2ftTpANMNya7f3d6aIfs+bwR1sLCm8+kYGiUU+WjgHSqJDRc3tdiLZDC5cit+/4wSAc/9n3nCyXubbpr8FdNIZQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3367.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(346002)(136003)(376002)(366004)(39860400002)(451199018)(2906002)(52536014)(5660300002)(38070700005)(921005)(86362001)(4744005)(82960400001)(83380400001)(8936002)(41300700001)(478600001)(71200400001)(26005)(9686003)(7696005)(186003)(6506007)(55236004)(53546011)(33656002)(110136005)(54906003)(4326008)(66476007)(66446008)(38100700002)(8676002)(66946007)(76116006)(66556008)(64756008)(122000001)(316002)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?zuum+lhwCrzJTsvVNVPwwC8oDY/b/9vtDMJF2m+wl3qbcziAIrseWrbPpovY?=
 =?us-ascii?Q?9TlecKzSp5tMX2S8Yvuiszxi8J44SUZv4e3UHk/Yo5iIebpy3mXZs2GsbEyZ?=
 =?us-ascii?Q?dUnpHcRBp2NMLZI5bUbSk0G5sgN7Mj9NJWEZfkDIH2ZKXDUDbPk4Ws7TDmCQ?=
 =?us-ascii?Q?L2nRyvayq6bp19x7GwiVY2EN3UWB1ukTsggjX5lqaB6cwSkCTAcvC3EKZLtl?=
 =?us-ascii?Q?XJaNvl1JOnqX7wKzkI8xJFTKZj0EIcHF+0HV2pdhMV+Sqe0CTvig24rNCjbN?=
 =?us-ascii?Q?VrskE3Ogiw9cepojZpLDWWYBHLoRQI7As9CB73TAmxUNfDns3eZ1DIntpO3l?=
 =?us-ascii?Q?47Syx0wD0axSYNjfb9zo64Zuy9aAgsQSoeRXuNuyh3vC0SFb/nN20rkkpC0A?=
 =?us-ascii?Q?V2a8JjDkh10aGZ32c+fTr8coI69BVJ40BGV+X1TNnfaGf2g5VNzW/FHxZ+yY?=
 =?us-ascii?Q?1a1p214xO8uY6v86E6stq5wOKeG7InKRwgN3tsBtU2QbEJcbU8u2hdSTTDXj?=
 =?us-ascii?Q?vSIH2ItenN5dHLV9flQZh4zNlf8HU973Z5QUjRVSOiFXKjFnrh3P+Mcy9qTY?=
 =?us-ascii?Q?W6tWar5++UQF2/t9WW/+WgF+Z/pnM/+yVhuo+zl6YdzTGGYKEV+4/bHuH5vR?=
 =?us-ascii?Q?RMFZ+bFYpbViomk6oigK4upfeOoB8D5q3OUa6VyOEurS+hZfX2r54CCle6Ow?=
 =?us-ascii?Q?wQqb0djcrwkHE4xqAyRImTTN7RFPdjYFgu5lymn2i5jXE6Eocm5F/L3PNntc?=
 =?us-ascii?Q?AbTuD+Lrm1dJN5ra4nH/M3xxkHu1Oj1pdKDhio6uogT+GAIiNTthTWcWaEER?=
 =?us-ascii?Q?+NBSLZb3gMInw13KEbviwz0jvi1OrH3tAtyuUCI07fSgZl+kRM5hVIbuk9NE?=
 =?us-ascii?Q?SFSpGV85pTZAd2wKi/3BrgcvWJTEvU1Ellh4Nx3dCdjufi5dcXqGzNTanK1Q?=
 =?us-ascii?Q?wTPg1mDYjsmLGBN9TgRNuT6DI9XpXGxGSIDhQuwE40+WCCLF3pNy78gXouZu?=
 =?us-ascii?Q?YCEHMRl6NsjHjfe3vMKTOaR4V6piBRf3x4Diko53ttjAmQmipxBZvnUtVwuy?=
 =?us-ascii?Q?4miuYrTFaHGjaxHD8WVLzoYafOTp2pvZGCPC0njc4xcQkDMkPTYHateoaj+U?=
 =?us-ascii?Q?VeTz2g+RA9uMTH6oFtF5C1xL+jwLuyqVHpk1LubbtDGJg8Qklu7xSZkkCuQH?=
 =?us-ascii?Q?bCwPrf5f0NHqeqMADEX4A2UlGvJR7Av5XALZAACO+h7R+BkY/nagfN06H0Az?=
 =?us-ascii?Q?hF+HkgSezqEX+5ITzGhZHq0DMVIKZ2MkZXJ76oIcWi4sx9RZ9Ju7t0mdSU/n?=
 =?us-ascii?Q?hQcS7D910Ej/trRdv2DatnWAZonUmK16d4hue7AVNgeONiWaTjGWwEjIZJ5f?=
 =?us-ascii?Q?oIUb7RINvwGtSt0hvqjWjoLhFcbm2I9I0Op9b/R7ePmiwAWcK9yFrHYQdJB5?=
 =?us-ascii?Q?3HMpVR0SVBBQ7C2gotZyjAZki6dpxQkYfDxmydZmo7XFzjAJ5o/he3DIVxYL?=
 =?us-ascii?Q?VBGRGrG57FcQ4YjKNoWi1dGiG+2x6qwH92Om0wq/niuabeluufEumr5rXl9E?=
 =?us-ascii?Q?Gtd3rWst1hEf/vUxFgBlVogmKt6sY621LzTXf2i6?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3367.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b79e72b9-495c-48b2-4020-08db03426ca2
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2023 04:20:02.8042
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uc97JgE+UVRQsaBYyA9LMvm/eCccH1WzJu1Y/66kA/Zb0tTWkwGvHWB72V4g2NQc86JPuyMaUb1kkl56JY0NPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4875
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Daniel Vacek
> Sent: Friday, January 20, 2023 1:53 AM
> To: Brandeburg, Jesse <jesse.brandeburg@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; David S. Miller <davem@davemloft.net>;
> Eric Dumazet <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>;
> Paolo Abeni <pabeni@redhat.com>; Richard Cochran
> <richardcochran@gmail.com>
> Cc: netdev@vger.kernel.org; intel-wired-lan@lists.osuosl.org; Daniel Vace=
k
> <neelx@redhat.com>; linux-kernel@vger.kernel.org
> Subject: [Intel-wired-lan] [PATCH v3] ice/ptp: fix the PTP worker retryin=
g
> indefinitely if the link went down
>=20
> When the link goes down the ice_ptp_tx_tstamp() may loop re-trying to
> process the packets till the 2 seconds timeout finally drops them.
> In such a case it makes sense to just drop them right away.
>=20
> Signed-off-by: Daniel Vacek <neelx@redhat.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_ptp.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>=20

Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at I=
ntel)
