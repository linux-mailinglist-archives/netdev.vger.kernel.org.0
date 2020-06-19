Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A5FD1FFF68
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 02:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728271AbgFSAqe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 20:46:34 -0400
Received: from mga06.intel.com ([134.134.136.31]:58990 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727109AbgFSAqc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 20:46:32 -0400
IronPort-SDR: OcxzMKztqwAJvskyH7kJaZdZgUbqLNwhvmJYBa7k8Fsb1A45Bn4+YqjKBYjtLlI0dw4Tms8D8f
 ucD7kkJf1tTw==
X-IronPort-AV: E=McAfee;i="6000,8403,9656"; a="204268241"
X-IronPort-AV: E=Sophos;i="5.75,253,1589266800"; 
   d="scan'208";a="204268241"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2020 17:46:31 -0700
IronPort-SDR: Ypb2GUq1k9i9aYEyF61ob6+/YGG3UCa5tISq8M1dbffggk/eJS6o0LsH5VecyK2nFdxSS+XFUd
 mM49ZKmyhL9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,253,1589266800"; 
   d="scan'208";a="263094934"
Received: from orsmsx105.amr.corp.intel.com ([10.22.225.132])
  by orsmga007.jf.intel.com with ESMTP; 18 Jun 2020 17:46:31 -0700
Received: from ORSEDG001.ED.cps.intel.com (10.7.248.4) by
 ORSMSX105.amr.corp.intel.com (10.22.225.132) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 18 Jun 2020 17:46:31 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 18 Jun 2020 17:46:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hW+O1CGsGirgnbwZ31QheSoB6QzSonwHqPg26+QM3KlL+c3bmBXI+mgjDXYDVhNGYFFblosxT5Gcfz3uVU0z2k2hS6mtJK4H1nlZSxWMcVnPGqv+rz8MduvBrAIjimND/M6ijYR0ySlX3fMCI0/+561AsnhObIC2sirQLgrks9e69Q8UC0Ijhmpgodnuhs4fRiWGrpWl5Yn7P/4la9SwJ+SH6+LvbIgT2yC3sQ0Ao/FXjmjthcRRlH+D2qe3r2qN6Kku0TwlJAWPb4VTVrQ4LCC4Ut0oTyhtAtmgNPOFA9jZrk44KDw0mZuTGjxOma0QtdXQnylQLrs6vE3BynusNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kww/HMMJ0NvY+0UilAPY+7ROeI/4L98TBfNBI88JsXk=;
 b=fe5YzvhEyObWOyojh2eqC2vZ3TiFT5E9Nn36BRSLwVgE/dzmDj06++AqndQGgjGCrVgYmZLgbtEM3kbwYNlkr19imXYs4Dlx36OxUtnXIup/wugDP+rTs+ts29zwkwMtHJrFyKpxL3zdDP5Plqdp5vXmwkbp0FPU01KvXkJ0S7A70mrONvFJ35zvi2AqpYY+cnh1rNgprmRMMCM0Sdk09ZZDSNLAkbMaqDqkoLfUhSzQcs/ZrZCxcU4Vk+TkPk1vpGd9TD7hihqHvzMRLt20XcuWyp4OkoNBBQNcKI54y+BFdNkYZz8nYWgb9v4O+08NVxyBt9NjqCk76/WvYJ/YNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kww/HMMJ0NvY+0UilAPY+7ROeI/4L98TBfNBI88JsXk=;
 b=cbf9ImVtAimvvGO7EduqIQMBxr2aTuUi/qaMBz0sRNf6DuWN3hbocIv5Hqc5PmTtWOT7TmH406T1HJ4Uz0tyKnVTYdwHejgDRATd+6Q5i3AC0CDts6oP4F100ueq9lVbHsbus6CPuMZjF3o2ajyGlfjtki5L92FIH37uyulI5oA=
Received: from MW3PR11MB4683.namprd11.prod.outlook.com (2603:10b6:303:5c::24)
 by MWHPR11MB1263.namprd11.prod.outlook.com (2603:10b6:300:2a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Fri, 19 Jun
 2020 00:46:27 +0000
Received: from MW3PR11MB4683.namprd11.prod.outlook.com
 ([fe80::498f:e5ca:221d:3eac]) by MW3PR11MB4683.namprd11.prod.outlook.com
 ([fe80::498f:e5ca:221d:3eac%7]) with mapi id 15.20.3109.021; Fri, 19 Jun 2020
 00:46:27 +0000
From:   "Michael, Alice" <alice.michael@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Brady, Alan" <alan.brady@intel.com>,
        "Burra, Phani R" <phani.r.burra@intel.com>,
        "Hay, Joshua A" <joshua.a.hay@intel.com>,
        "Chittim, Madhu" <madhu.chittim@intel.com>,
        "Linga, Pavan Kumar" <pavan.kumar.linga@intel.com>,
        "Skidmore, Donald C" <donald.c.skidmore@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Subject: RE: [net-next 13/15] iecm: Add ethtool
Thread-Topic: [net-next 13/15] iecm: Add ethtool
Thread-Index: AQHWRS9LnG+5lGKiiUSVXC8EUexVy6jfDAYAgAAJ1tA=
Date:   Fri, 19 Jun 2020 00:46:27 +0000
Message-ID: <MW3PR11MB4683D406C049305B51DA2B6CE4980@MW3PR11MB4683.namprd11.prod.outlook.com>
References: <20200618051344.516587-1-jeffrey.t.kirsher@intel.com>
        <20200618051344.516587-14-jeffrey.t.kirsher@intel.com>
 <20200618165008.4d475087@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200618165008.4d475087@kicinski-fedora-PC1C0HJN>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.2.0.6
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [67.189.98.221]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 91c1c780-44ec-4b34-2683-08d813ea3366
x-ms-traffictypediagnostic: MWHPR11MB1263:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB1263C62BE9BEC83258A06AA0E4980@MWHPR11MB1263.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0439571D1D
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tSDtbARZdaKdSrpgVidHwo/jGGVgRKgEXq9jQcLbsM4/Fzu+d5ZpCNxmoxx+DHy1czsgKohtnDakON9loPFYHjKTdmiqHnOJwdCdJ+0m06V1osEHiQlhuT/Vly4xNGQ5+JimdQbhiVhdpixOkLivp7o+VroYH/WsXeXEjQNOB4Ll7aKtEobQyBPNeBSFNAVrMjm/u5EWrOkQNKANvEt6DtJP12OTsNYGNfbs774mdwcxJJmHYqx0Geca8PD2L6A/0NNcVGLuDhNDuMfNwQ2qA7Y4WvFHWn/ai4sMrriOiKStyuT+Yq64IY44LGpIYO7G
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4683.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(376002)(396003)(136003)(346002)(26005)(2906002)(5660300002)(76116006)(66946007)(66446008)(66476007)(7696005)(55016002)(186003)(110136005)(107886003)(54906003)(66556008)(64756008)(33656002)(316002)(4326008)(9686003)(83380400001)(6506007)(53546011)(478600001)(52536014)(8936002)(8676002)(6636002)(86362001)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: JYXJpEswbMOAU3328wAbT9CMHa/Ob8j/YgeQ3Bwz8Wh4YnIjDlAZ+PTXLfguU+mesWq6hQelKjaYl1L4ucAot6Zr2ZU1l17j+G2uR7GvxGBfNDIgDJhdRn3yyLM8kkYOPd2SAI0w9fQKx84VREtiQb4THdWore26dJRt1SV3OBN9nZ24YJik2WLShjLOOWSKZm+lFCjhfZYYBxT0WCpDP4SHEf9VOZyfdSdN5sgCxrwnvbHzzaohkjYSapnuqtH/wmGHLjIPyyc359IlFoHJJsXui/EtcIaUkqtVfnMWHNG5Qy5H3omFYJrQhJxL4Z5GkrNbo8tex5jk7AT6xJjraWK2FIMEphiEike5d2z8RLCyMb67oXpD94+TJIyfLjdzT2ZejCnqXpW9onEKaOzQ/afwokHNbWApcnv/JaJpMFzy8iwMkA5+qzNp5/fYwQ2bBmRlRKWoxbayFIxWgGbS+yqwakA8iyjQcCNEFw8c0CR+nxUbn5iZRwYzgPIlanxy
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 91c1c780-44ec-4b34-2683-08d813ea3366
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2020 00:46:27.7198
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BrHfrwNb2gmhntxaeyv9n5JE6fDvJFThV29DQb6KwxiiJl43NZkoq//q0Eo+5yAhEf+kfUYFiZ2/tqiM8kODIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1263
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Thursday, June 18, 2020 4:50 PM
> To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>
> Cc: davem@davemloft.net; Michael, Alice <alice.michael@intel.com>;
> netdev@vger.kernel.org; nhorman@redhat.com; sassmann@redhat.com;
> Brady, Alan <alan.brady@intel.com>; Burra, Phani R <phani.r.burra@intel.c=
om>;
> Hay, Joshua A <joshua.a.hay@intel.com>; Chittim, Madhu
> <madhu.chittim@intel.com>; Linga, Pavan Kumar
> <pavan.kumar.linga@intel.com>; Skidmore, Donald C
> <donald.c.skidmore@intel.com>; Brandeburg, Jesse
> <jesse.brandeburg@intel.com>; Samudrala, Sridhar
> <sridhar.samudrala@intel.com>
> Subject: Re: [net-next 13/15] iecm: Add ethtool
>=20
> On Wed, 17 Jun 2020 22:13:42 -0700 Jeff Kirsher wrote:
> > +static const struct ethtool_ops iecm_ethtool_ops =3D {
> > +	.get_drvinfo		=3D iecm_get_drvinfo,
> > +	.get_msglevel		=3D iecm_get_msglevel,
> > +	.set_msglevel		=3D iecm_set_msglevel,
> > +	.get_coalesce		=3D iecm_get_coalesce,
> > +	.set_coalesce		=3D iecm_set_coalesce,
> > +	.get_per_queue_coalesce	=3D iecm_get_per_q_coalesce,
> > +	.set_per_queue_coalesce	=3D iecm_set_per_q_coalesce,
> > +	.get_ethtool_stats	=3D iecm_get_ethtool_stats,
> > +	.get_strings		=3D iecm_get_strings,
> > +	.get_sset_count		=3D iecm_get_sset_count,
> > +	.get_rxnfc		=3D iecm_get_rxnfc,
> > +	.get_rxfh_key_size	=3D iecm_get_rxfh_key_size,
> > +	.get_rxfh_indir_size	=3D iecm_get_rxfh_indir_size,
> > +	.get_rxfh		=3D iecm_get_rxfh,
> > +	.set_rxfh		=3D iecm_set_rxfh,
> > +	.get_channels		=3D iecm_get_channels,
> > +	.set_channels		=3D iecm_set_channels,
> > +	.get_ringparam		=3D iecm_get_ringparam,
> > +	.set_ringparam		=3D iecm_set_ringparam,
> > +	.get_link_ksettings	=3D iecm_get_link_ksettings,
> > +};
>=20
> Oh wow. So you're upstreaming this driver based on at least a 3 month old=
 tree?
> This:
>=20
> commit 9000edb71ab29d184aa33f5a77fa6e52d8812bb9
> Author: Jakub Kicinski <kuba@kernel.org>
> Date:   Mon Mar 16 13:47:12 2020 -0700
>=20
> +int ethtool_check_ops(const struct ethtool_ops *ops) {
> +       if (WARN_ON(ops->set_coalesce && !ops->supported_coalesce_params)=
)
> +               return -EINVAL;
>=20
> would have otherwise triggered.

I hadn't gotten any errors from a regular compile while I was preparing pat=
ches, and yes that got merged while we were doing final internal reviews an=
d therefore missed in this first version.

I'm adding in the flags and they'll appear in the V3 that I'm preparing add=
ressing all the comments that we have gotten thus far.  It looks straightfo=
rward, thanks for pointing it out.

Alice
