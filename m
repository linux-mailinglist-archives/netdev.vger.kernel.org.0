Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2E13F2320
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 00:32:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229532AbhHSWdW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 18:33:22 -0400
Received: from mga17.intel.com ([192.55.52.151]:34929 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236067AbhHSWdW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 18:33:22 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10081"; a="196920949"
X-IronPort-AV: E=Sophos;i="5.84,335,1620716400"; 
   d="scan'208";a="196920949"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2021 15:32:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,335,1620716400"; 
   d="scan'208";a="442410260"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga002.jf.intel.com with ESMTP; 19 Aug 2021 15:32:33 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Thu, 19 Aug 2021 15:32:32 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Thu, 19 Aug 2021 15:32:32 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Thu, 19 Aug 2021 15:32:32 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Thu, 19 Aug 2021 15:32:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MoxkY92mgSHh4ERmnOHsZVu9t/Q0UsmxFiyWuBlA4l+7rvqlhD0Q/s/sqX3cTUzjlBbkltvW9nuTK/aGumsNWKtaY470PDHPJw9HUkpObOzgLXC/jpUl8zeBi6j5gm0ZN/7j+Rb4yR5i92LfC/dObOxFFqWr4VeY9MqmUAZC5r+5zNCovrYc6taBLmIFoC9CxlmRj15azpSUlPK4n5Ktikl9rfpm7yw4W3efBytvFn8c9jzOp2W3v9XqCFQXceIEtZs6Wf53SFhGU87MZHh6NbZONa+KRFKrn+UcviMeHUF0ju1j6yya5VipAfSEPYgDkStPsKKWePFkBU6Ht1ibeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lKHRa9cpBr/+ZMS/yfmOcbXno+YWP0diahWZZWxZlmw=;
 b=RAVkZK+AyQ1nPyjjwAOfRcnCDRoSbFmxm7DPA7JesSTLyhTSeianEH0zu+cVVRt1xKLBMySEF1WyFv2HXRfwEzZpn8hVboNbEXFCF1f99LZIl5FYUh9xtnVdOzRe7/I1hY/szbYk/O+m5L0VZGxn04rXnJcVo7R5PM8kzlaKglyGQWK/G6TNO9Xh+jca1g7Uod4cwbtSyfQ1xnEFLtiCNOn7kgX1ae9txrR/IgwQ5msdGHFmaNgzwAfFhYqlZjXZZHrAYSK1sa7QOcYtNEBhOuMkRmQWe9mib5HUfPC/fuNtyKrkcYhLIEmWVnxbrN0U/KHFtPXoxr2vQyJT8aDIpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lKHRa9cpBr/+ZMS/yfmOcbXno+YWP0diahWZZWxZlmw=;
 b=Nuc6Qo3rVTNo57XryLuywGIocMeNVbBn15Exewns2m4Xli+3o7xHxngVctnieMbXIukTqb24Mz95f3DpLNvFcSMAk9FguL+Z1UZGkdwKnGcJi3aPtjP1mf81Qm737Cq6dx4aHsV9ELeelP/1xczEHSKjSxSwCLQ0O6c0/lw7ZCc=
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by MWHPR11MB1407.namprd11.prod.outlook.com (2603:10b6:300:26::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Thu, 19 Aug
 2021 22:32:30 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::adef:da48:ea32:5960]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::adef:da48:ea32:5960%4]) with mapi id 15.20.4415.025; Thu, 19 Aug 2021
 22:32:30 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Brelinski, TonyX" <tonyx.brelinski@intel.com>
Subject: RE: [PATCH net v2 1/1] ice: do not abort devlink info if board
 identifier can't be found
Thread-Topic: [PATCH net v2 1/1] ice: do not abort devlink info if board
 identifier can't be found
Thread-Index: AQHXlUnvm3v5S9sdJEKD/awg6y4gZat7aVcQ
Date:   Thu, 19 Aug 2021 22:32:30 +0000
Message-ID: <CO1PR11MB5089BD51EC67B855D93D26A0D6C09@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20210819223451.245613-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20210819223451.245613-1-anthony.l.nguyen@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8c031262-faac-4e0c-de9e-08d963613b2e
x-ms-traffictypediagnostic: MWHPR11MB1407:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB14074A2D6BF5399B7F3F980ED6C09@MWHPR11MB1407.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uvh/2E9xfpFiEIpKMmqlSzR8b48T27otMXpUK8F3LlwIcDEd8l4x/HVGQAnbGlF0g6pCac02L+Yqtvl3ikTdZJrVAYk4ZxzqTG6nvYKbqmN1rT9c+aZ8DJ+1aH+LI7AuAMRqTk308YzmMevnF8/yGkVnjyYPj7N5resieqQiEwT8XpdFy7VuZzoDmvxxAnfHVHlHpmtMh8cAARPuCff/6/+0YqbVB/8jw9CHrmk9y8PEzUnexeTCVrFPi23mwQ6u0FvJc6y/5Km5c2kKGAnFyJ/BltZH9Aaj/fwGJPPJmfudk7Rzrn0RvjYMld/6dgS6j9r+8MZQSJc8xo8sXZUbesaM+5Ac6YzARQQ+DsXQKjgvT6uBfJyhGO2JJORIuiUoL63/Yfb9zmNR5djg3V6GQjVqR+MfIri6J+VSAaoW8NF8xY/80iBSFMLO52WbddNZx/ZICgj0+Gfp8cwLeYfNhAU3V4qc7NDeBbeutCPVynXZNm+7aVhOaiz9QntMofu9r2hYPvsBum/4VW0Ku+7Bm4IAYf7t4YRg5U1QkK4I6oaR0O62K0ndqPP8BsCP9IAtJ6ESWjrPSjHYAzj99B9hTbGBksQ5s2XfIxyR4tJxXNJI+URmArh4/TYnok4ExHawk2z9wWfYmSKfEX4FEg4H+fcEkRaRuekKeVoRVKaQiUwcq25CRveAbQ9fg1NSGGtKEgqaMcI01HDBMsKCsgpv9g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(366004)(396003)(136003)(38070700005)(83380400001)(4326008)(186003)(8936002)(7696005)(107886003)(26005)(71200400001)(33656002)(5660300002)(66946007)(66446008)(53546011)(6506007)(478600001)(66476007)(54906003)(316002)(76116006)(64756008)(66556008)(55016002)(86362001)(2906002)(38100700002)(52536014)(8676002)(122000001)(9686003)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Q5igfT3gLcUHgfRJVwQ99os+Zl2EeRn/TdAFW+UA7IyhVCV5xtmNI9yWHBtF?=
 =?us-ascii?Q?jmuIZYgbTZMJEm8OsxjwUDcSQejOZmhoRm+SgVu4S321g7s8ZcssQ31003d4?=
 =?us-ascii?Q?ZoZlEagjELUv4hS71M7Ijs8jZ6WVUFSLfShkXV83z7HXYjKqZfAjMXZhr/OU?=
 =?us-ascii?Q?rkURPf/xv6+C3t97d5ef/ixzoqex18Lx5W1bPvUQWezKwagFjQjjzq9DK2ym?=
 =?us-ascii?Q?I/OXx9+b2KqnBFpakpiHfF/1EI7s4x6QZfFXeDnqhckj57mon7T3BoVcj4wq?=
 =?us-ascii?Q?zoDf98viEWpe0ZFyXGYgElr9UQfEObN7CxovZgaZ0eiMsrCR95U4da1u1Pn3?=
 =?us-ascii?Q?ZFS3jZCoOq2s0+/HAajnqvRnvhBh+5QMZrWuUxMXOXezXQ17aCSFLneq/Aek?=
 =?us-ascii?Q?Cy0IVSEaGXvb6Mdad6jLOLDiOi64tLk+KYy6fDUAy74vDhzB3uISFx22nKWx?=
 =?us-ascii?Q?eE/w4kg7jzfds1kBZQFv/CK8N/CWuk0wlterVmkFfRTRl3LL8JAo9gap+y5p?=
 =?us-ascii?Q?6aTkpYVX8lsIz9WGadvSaA467Y5is52zQPSrjL59KbvuVkgroqL+MroLD7ui?=
 =?us-ascii?Q?TLSsNsGQUIe3120XQDkFW28cmA2VgUDDMlsJFXFaK0TU+044d3E4dKNsjduo?=
 =?us-ascii?Q?rNij4cMI+MvkSPNn/9qXUFsknrg8wZ6krTWMwS5VtVZzPf2FXqpOoTbOtzd7?=
 =?us-ascii?Q?8Jt7qNYaVk2yt7IewRIvT3eJNvKs/jA8PQAm5pKmTm4oMIsp4SqohZ/7Pkv4?=
 =?us-ascii?Q?UAgn0h6HCbrZQO1dNQQ3Oibdmb1/G7M1VQZe5OhaDtF6sAEedgOwnlAbVN1F?=
 =?us-ascii?Q?SFAkyCpnkAjk7pynxZjIxq+qRC6/XssR/qDUDo6bx8DaKVQb+G54RXKoWqHw?=
 =?us-ascii?Q?hAmjoVIFVctun0Tfs/1ryU9B+aylo2TxhSHrPAztAqolXq0mIvVn7Sq2pO6F?=
 =?us-ascii?Q?S5NPGBqa5U/r4nbfc5Ob38I0SuHCSdnO9uTh7upPP6PP8N9grzh4x6sGjkec?=
 =?us-ascii?Q?Ult0Z+e71GJc6AeJJl+chtk0HCwOCPHFNaUx6AI7yYm0jAGsXllHniXNPeAv?=
 =?us-ascii?Q?Gw2lMBXUNGJP3i9GnxpHhVioq5ugxnytLvtglpCGtalJHeAdzq5Pobix0juE?=
 =?us-ascii?Q?TvZVKkr/g5FL8huV+1CUbgn069+OuRsvxRgokVQJdTPplIGwv4mWSKIoielj?=
 =?us-ascii?Q?t7JoZPpnUCxy9QuizMNSyOcCaWjxAQrrqSe1oEp5lg2YUu+CAvaJlyl+zPGU?=
 =?us-ascii?Q?JyQXIIqHTcssNfqOJNsPX0NRdpKPpJ1DEL9Ad/TW5ejq3Ti8G+QVErIb9zR0?=
 =?us-ascii?Q?OnE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c031262-faac-4e0c-de9e-08d963613b2e
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2021 22:32:30.4395
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xmQaBwsM04qn7jiuvY2PS3OBnal4dBT3QCmziUrKlm4S1R/IGS3h9pGGNrjLh24MYw+Ua7vy4aRi5YFSYHxTWXetw/Nh1/YN2j/nP6w4UoM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1407
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Nguyen, Anthony L <anthony.l.nguyen@intel.com>
> Sent: Thursday, August 19, 2021 3:35 PM
> To: davem@davemloft.net; kuba@kernel.org
> Cc: Keller, Jacob E <jacob.e.keller@intel.com>; netdev@vger.kernel.org; N=
guyen,
> Anthony L <anthony.l.nguyen@intel.com>; Brelinski, TonyX
> <tonyx.brelinski@intel.com>
> Subject: [PATCH net v2 1/1] ice: do not abort devlink info if board ident=
ifier can't
> be found
>=20
> From: Jacob Keller <jacob.e.keller@intel.com>
>=20
> The devlink dev info command reports version information about the
> device and firmware running on the board. This includes the "board.id"
> field which is supposed to represent an identifier of the board design.
> The ice driver uses the Product Board Assembly identifier for this.
>=20
> In some cases, the PBA is not present in the NVM. If this happens,
> devlink dev info will fail with an error. Instead, modify the
> ice_info_pba function to just exit without filling in the context
> buffer. This will cause the board.id field to be skipped. Log a dev_dbg
> message in case someone wants to confirm why board.id is not showing up
> for them.
>=20
> Fixes: e961b679fb0b ("ice: add board identifier info to devlink .info_get=
")
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---

Ack! Thanks for taking up the work to split this, Tony! I really appreciate=
 it.

(Thanks also Kuba for helping make a clean net-fix, this is definitely the =
better approach!)

Regards,
Jake

> v2:
> - Removed refactors - to be submitted later as separate patch through net=
-next
> - Changed 'PBA' to 'board identifier' in title
>=20
>  drivers/net/ethernet/intel/ice/ice_devlink.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c
> b/drivers/net/ethernet/intel/ice/ice_devlink.c
> index 91b545ab8b8f..7fe6e8ea39f0 100644
> --- a/drivers/net/ethernet/intel/ice/ice_devlink.c
> +++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
> @@ -42,7 +42,9 @@ static int ice_info_pba(struct ice_pf *pf, struct ice_i=
nfo_ctx
> *ctx)
>=20
>  	status =3D ice_read_pba_string(hw, (u8 *)ctx->buf, sizeof(ctx->buf));
>  	if (status)
> -		return -EIO;
> +		/* We failed to locate the PBA, so just skip this entry */
> +		dev_dbg(ice_pf_to_dev(pf), "Failed to read Product Board
> Assembly string, status %s\n",
> +			ice_stat_str(status));
>=20
>  	return 0;
>  }
> --
> 2.26.2

