Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23D7D30D616
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 10:18:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233329AbhBCJRp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 04:17:45 -0500
Received: from mga17.intel.com ([192.55.52.151]:37335 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233326AbhBCJRG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 04:17:06 -0500
IronPort-SDR: J1tPIfSPPAmPm255Ug3gevFOBcOabUrzcDDSlprgIONJ1Pn/vsW/xl5Y7LdOpfAzxObu3ei9zT
 7IM6Kc+lvyHQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9883"; a="160772436"
X-IronPort-AV: E=Sophos;i="5.79,398,1602572400"; 
   d="scan'208";a="160772436"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2021 01:14:30 -0800
IronPort-SDR: IrawAjugApM00GeXpCFppq2NGcqq3bMiXyIPuFHfyG6ZsCC0ZrzDi653gomZxoNM8sfzwauZh+
 eC2IpnkPP4Cg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,398,1602572400"; 
   d="scan'208";a="359367955"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga006.jf.intel.com with ESMTP; 03 Feb 2021 01:14:29 -0800
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 3 Feb 2021 01:14:29 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 3 Feb 2021 01:14:28 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Wed, 3 Feb 2021 01:14:28 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.106)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Wed, 3 Feb 2021 01:14:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gIJloT9XzlYWNei9w4te53HfGOrzoBHAZouz+Y3q9gDV1g9p3B+SKQ7lf80cf0SBhfSgLKh5pY3rk4XWSOrRfy+KZ68pu5/odUuqKi7l63gLuqFmJ6GqEs9+bKeDNtqrAvyupNcxj1WL1oDbLVHyDoeew49gIYZYFwUnsjCuBDdO52BRJ2STFIIl91mNi8GRp81Nvqh9xxKFc19aioWe4zT8wKVy+v2BOKctnENslTuU7wi/evRRbHv7g8emgwGJ5i5M8KtOqga+cMbryuQdR2HabgJMhGHu7eMiL+bz2dgx4pEp8vihXQAtGmEVq/JDG03yeht0Taq6rfCI+Ku9cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h34ghAy+U0NqoL4Bulcb1EkedsYU4Rh+BgSg0ENmvRU=;
 b=i69L4/YKkHo8MGZqZfLSZ47oNBBxZE3qutw6U9TfBRNCJmXt7iE4aQoQtR1OcjO+yv6WMtpNlZ+qc7kKpWMzr0jh+K8PyEELGpp49qjGJS337Na6WV/G3mpmVsFI48lsmSy8MJUpo7rE7FbqIZvS4xiQCsAEhF+wJYYU9kw+FDDbsNiuFn73Bf+VW4ITTNpFUlhuoLpPJxjA9ofpGm1E8mxKBsYnWmS7xLDLWkOTcH6BW6KVu8xbActbTBmnZczr+BP0E68JN6hD6cvlksrrRtw0E7TeYj4KswnGaktM3Yw/G7jZqD5FRIdRIU0m3tP8IGSP9TPlgmyF3oUVnf+a7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h34ghAy+U0NqoL4Bulcb1EkedsYU4Rh+BgSg0ENmvRU=;
 b=afa9wtcz/HnkSoaYv3rnx44LXB51aezvyp/1W2FnuIOVqjrafZjekeC0fTGb13SifAGBqemnPvvkrhPP39tQCdrae1RPe/x6is3GLB//mcI/y55rTP+XAz7qr5RmQWV/xPq59E6hcbHuYrc1I2BFO2Vb18YqlBBpvxMXELN0W5A=
Received: from DM6PR11MB2876.namprd11.prod.outlook.com (2603:10b6:5:c1::16) by
 DM6PR11MB2745.namprd11.prod.outlook.com (2603:10b6:5:c7::31) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3825.17; Wed, 3 Feb 2021 09:14:25 +0000
Received: from DM6PR11MB2876.namprd11.prod.outlook.com
 ([fe80::9504:fbb9:b745:7839]) by DM6PR11MB2876.namprd11.prod.outlook.com
 ([fe80::9504:fbb9:b745:7839%3]) with mapi id 15.20.3805.024; Wed, 3 Feb 2021
 09:14:25 +0000
From:   "Loktionov, Aleksandr" <aleksandr.loktionov@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "Rybak, Eryk Roch" <eryk.roch.rybak@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Topel, Bjorn" <bjorn.topel@intel.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "Bhandare, KiranX" <kiranx.bhandare@intel.com>
Subject: RE: [PATCH net-next 6/6] i40e: Log error for oversized MTU on device
Thread-Topic: [PATCH net-next 6/6] i40e: Log error for oversized MTU on device
Thread-Index: AQHW+Qpx07qV5rgDC0aCRtZdBz8+qqpFuDIAgABt5WA=
Date:   Wed, 3 Feb 2021 09:14:24 +0000
Message-ID: <DM6PR11MB28761B036F7DDDFBE7D53CB5E5B49@DM6PR11MB2876.namprd11.prod.outlook.com>
References: <20210202022420.1328397-1-anthony.l.nguyen@intel.com>
        <20210202022420.1328397-7-anthony.l.nguyen@intel.com>
 <20210202183448.060eeabe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210202183448.060eeabe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.6.0.76
dlp-reaction: no-action
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [109.233.88.110]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 023db70c-8c20-4371-c64a-08d8c82419d5
x-ms-traffictypediagnostic: DM6PR11MB2745:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB27453E136EDF8015F5D9427FE5B49@DM6PR11MB2745.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mx9dUqIMzH7LooOSyE3zfHYtUFYt6J0PTZr/tx4mEtaDDx/0xfriGcO3szZxy2bMlBbdlOM7Ip7vsXK3EH5FrK5rTnqKbBYs3IZedRCOnZoKKYzPRKQF/ifY4ZVZs4gLtQU3h2IGLO/ylZ8wk3kQMFKEVuN+pT5FcE8V6+N8H9v11kf0X2imE9wifsNri7cP3WEugqpNy4fqsURgxg7cK+9OaEFYq1+2lCJhv2w/s5bO8/ir1xqTDxXZLPITMG1hRZLE2EFdn3wk1CZU+0lXrmYtT58no48AyoUZ/gu+y64H0AqZYh0TUkeYlkZFXExATqMaSoeDEMf/v4XyNzJ4GjhNiKiKpe8oSuiKf3Z3OHiDJsqv1PlpBBslOozttm8FJ6EiBBVQzHHoUmlcM185xOrixuEbQuVjbbizLXbNg7Mm/j0f9WuAPcNcw1OvOkSAMbpPWvr1ynRY/avAxeiyVu6HKq3sz9VBJCzxyrpjJPanP6xR6FPWlslJQmyxiqvqDsPJy8DcNqJ4tDRFmarL5A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2876.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(376002)(346002)(396003)(136003)(26005)(6506007)(53546011)(8676002)(66446008)(2906002)(107886003)(110136005)(83380400001)(33656002)(186003)(6636002)(66556008)(316002)(478600001)(5660300002)(76116006)(4326008)(86362001)(66476007)(64756008)(52536014)(54906003)(9686003)(8936002)(7696005)(71200400001)(66946007)(55016002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?glG/SYNlCZ2kuAHLc4mXMPwqhXLRp05Oc5UsOkMm0oSToeaaV16ji/V/x7Wy?=
 =?us-ascii?Q?7X1MNBcJkCno6hy0xtR+GOERoyFWRgydrC5db7GpMCBWkI4E68MWM+lc3dEt?=
 =?us-ascii?Q?TsfyGTdRKwVaxurJ+Y/sL1CYPT0c2FGDyZyfs12cXhEEupnln8nLNxqjBrVc?=
 =?us-ascii?Q?ZKi8xaqeFxLyQxNxgb868beVo3ah0uLKo7q1Hn5amv84ruZRszjZcI4WM57R?=
 =?us-ascii?Q?JJN3Vlqs37U+TH0u+0YRRx1Ch1/vSeK3ba+gXYnzCSj95AF9/GVg2AqD3oir?=
 =?us-ascii?Q?U8joOcjQ1/4E05rV/6FQjIv8TAO+YlcejzjBx8RC8klfNsfL7GfdcXrdidw7?=
 =?us-ascii?Q?BYbf/SSKZYvUIyTnDlBgQG8ut5HBMBtbdkQwp34kW2TXvofBp3HGItVR8Lyu?=
 =?us-ascii?Q?hrl5xmT5JjYW1fB/lj0GThWbSiq1at12+vHtuf3p9MAtqzklGUv18rINSsIM?=
 =?us-ascii?Q?MnfqzFJeguf0YrvZV/RCgNBTpefrzP3mvUQNgdEmmu2xIiD5y4CjPaYG872b?=
 =?us-ascii?Q?4DUHkhWD6pciwQQmKv3dx7SX3tfquTT6P0z5CKwC3FXPdidQ5Avix75r3Q4Z?=
 =?us-ascii?Q?GmNnVu+w9a8CTiust8++UUUP5YKLnmaXzjyt2JaywUqOb8QDHj8TWI4mqdqi?=
 =?us-ascii?Q?AWv2icLxoaESUTfBThTHpOPuX7ek4ua+zGld08OmARSuFE72793momCRRzs8?=
 =?us-ascii?Q?dH9fEMouNmEB3Er5N4qnpoLapF+Xuo0/jK856WyLmyl3be9aO2FvzD4s1rHy?=
 =?us-ascii?Q?gAbJdeaUoKLv8i/KtW40ikm9Rjb2zOHej6iePUdwaakXHwGl75MRFAdSoPtu?=
 =?us-ascii?Q?h1A4e3s+TiczxkW4o+S4E1pcH2k0kY2W7GDK6+MKAnRzLBURM2kn6Y0qbB0P?=
 =?us-ascii?Q?WCCoWtAtQhm4DFGh1KDzwYGou97SmsoEhkpqOB1E6u4Tde5AKNGQcN8qKgZy?=
 =?us-ascii?Q?lcwTTeC0/5+xYOpU4vs4E6sdL9Afe32Jvx3qULCMF/ElOi9QmymMMNfKlJMX?=
 =?us-ascii?Q?zP9QHYbvtrI5K8JkvAohniAyAOjBgKU0XGXgMGLDVdMFTH8aHuwfQm214S+T?=
 =?us-ascii?Q?b2RaLgIk?=
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2876.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 023db70c-8c20-4371-c64a-08d8c82419d5
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2021 09:14:24.7765
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: I5nJStVzdXKn6WfyG00X1TY1E5I2xpau4xVPYOCsLYoa5NU7tCkZxGUDyfs7WGs8rIdn4O7WWNKV3S7kwpMVMgO30sqj8BsdpWVSM28Qke0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2745
X-OriginatorOrg: intel.com
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Good day Jakub

We want to be user friendly to help users troubleshoot faster.
Only dmesg message can have template parameters so we can provide exact acc=
eptable maximum bytes.
Can you could you take this into account?

Thank you


-----Original Message-----
From: Jakub Kicinski <kuba@kernel.org> =

Sent: Wednesday, February 3, 2021 3:35 AM
To: Nguyen, Anthony L <anthony.l.nguyen@intel.com>
Cc: davem@davemloft.net; Rybak, Eryk Roch <eryk.roch.rybak@intel.com>; netd=
ev@vger.kernel.org; sassmann@redhat.com; Topel, Bjorn <bjorn.topel@intel.co=
m>; Fijalkowski, Maciej <maciej.fijalkowski@intel.com>; Karlsson, Magnus <m=
agnus.karlsson@intel.com>; Loktionov, Aleksandr <aleksandr.loktionov@intel.=
com>; Bhandare, KiranX <kiranx.bhandare@intel.com>
Subject: Re: [PATCH net-next 6/6] i40e: Log error for oversized MTU on devi=
ce

On Mon,  1 Feb 2021 18:24:20 -0800 Tony Nguyen wrote:
> From: Eryk Rybak <eryk.roch.rybak@intel.com>
> =

> When attempting to link XDP prog with MTU larger than supported, user =

> is not informed why XDP linking fails. Adding proper error message: =

> "MTU too large to enable XDP".
> Due to the lack of support for non-static variables in netlinks =

> extended ACK feature, additional information has been added to dmesg =

> to better inform about invalid MTU setting.
> =

> Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
> Signed-off-by: Eryk Rybak <eryk.roch.rybak@intel.com>
> Tested-by: Kiran Bhandare <kiranx.bhandare@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>

> @@ -12459,8 +12460,13 @@ static int i40e_xdp_setup(struct i40e_vsi *vsi,
>  	int i;
>  =

>  	/* Don't allow frames that span over multiple buffers */
> -	if (frame_size > vsi->rx_buf_len)
> +	if (frame_size > vsi->rx_buf_len) {
> +		NL_SET_ERR_MSG_MOD(extack, "MTU too large to enable XDP");
> +		dev_info(&pf->pdev->dev,
> +			 "MTU of %u bytes is too large to enable XDP (maximum: %u bytes)\n",
> +			 vsi->netdev->mtu, vsi->rx_buf_len);

Extack should be enough.
---------------------------------------------------------------------
Intel Technology Poland sp. z o.o.
ul. Sowackiego 173 | 80-298 Gdask | Sd Rejonowy Gdask Pnoc | VII Wydzia Gos=
podarczy Krajowego Rejestru Sdowego - KRS 101882 | NIP 957-07-52-316 | Kapi=
ta zakadowy 200.000 PLN.
Ta wiadomo wraz z zacznikami jest przeznaczona dla okrelonego adresata i mo=
e zawiera informacje poufne. W razie przypadkowego otrzymania tej wiadomoci=
, prosimy o powiadomienie nadawcy oraz trwae jej usunicie; jakiekolwiek prz=
egldanie lub rozpowszechnianie jest zabronione.
This e-mail and any attachments may contain confidential material for the s=
ole use of the intended recipient(s). If you are not the intended recipient=
, please contact the sender and delete all copies; any review or distributi=
on by others is strictly prohibited.
=20

