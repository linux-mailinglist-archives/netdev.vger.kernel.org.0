Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC3932D2B64
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 13:51:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729128AbgLHMvU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 07:51:20 -0500
Received: from mga02.intel.com ([134.134.136.20]:62963 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726931AbgLHMvT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 07:51:19 -0500
IronPort-SDR: HGFcIDm8Tpxnrw4vOcjZyE4GGU0VEfRLEH9Fn/N7NbKzWUWeYEiaTJ32Y6ySc3wAA2UHaLGsH+
 v9UMQyyBNsZQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9828"; a="160930660"
X-IronPort-AV: E=Sophos;i="5.78,402,1599548400"; 
   d="scan'208";a="160930660"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2020 04:50:38 -0800
IronPort-SDR: GX2ukqcuEO7jTw8DH47trB7sE/1Y0irnlmXGAe23pny1Uqgi4RnNzzGcsgpZAxgO3yryw1vNCk
 jCXVei2XILGA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,402,1599548400"; 
   d="scan'208";a="552216652"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga005.jf.intel.com with ESMTP; 08 Dec 2020 04:50:37 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 8 Dec 2020 04:50:37 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 8 Dec 2020 04:50:37 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Tue, 8 Dec 2020 04:50:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GkwJLlS6kLUNBGoXeaAXJxZ7ZZw/F+b5cePLbs3QB4pQQggCIBwYVLtMhm+NqZuOiCeoeJ4d9z3D9CRuviXS1du7je8b629NamEAz23Mj+TYt3B2SiPIDLh360d5pBC33Ip1tp+Jiqh+JZk/KFBrswmExw/VpvXI4cCgQb3+nqXzCUJzIaTIvAqAtjjl8eV6MSR+YztuifI8rhllTqant14f41CPPTpxdrzFMr7OswFpqThFd0OukJxaNFyVxjNr/Xbg2eoFOaZwqEB6pecEKRnSITjBkGqeILGMhU3QTnTwytKAfzL5UBE3g0pP4YiiZhZwkWAKBjSN+x757x7I9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L1j2fIUe2JgZM1CrmfD7arWxVvgCz9KbHkR3LIgkK5Y=;
 b=WO9mUn0BpFZXxdHR6KZUo4scOB3J4SXu48mgFgqLlcNnsYpy320Gj/TlO9zLZAqulvRIGxS9nLEs7uPkM3MloKGoM8afdRE7jTvu2lSxiU4I0WrCEULLvPXOQDQ37FGXwPxcNfcNiT5Do/i4ZL3tvJbyCkkPHoNBGV/uehZVOpsV5M+fzXsSd8S5yxPOFnVM/Ai2hOYLXueZ+YWEGwF86VWXbfTeKxBjWXlrwCSakBGWCVY6b0vlmKRsLxiZZGs2K4OBmCpQx0u7qJAMhd7nmW5oa7wUARbUe6PIY/AD9MjUusRb5yvGoXSCQ1i6syWp4azDRhI9f/buLV6wE1bgng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L1j2fIUe2JgZM1CrmfD7arWxVvgCz9KbHkR3LIgkK5Y=;
 b=QgcszFO0TYyDwDFxSBh/ZTGBGuw7USrigFImH67zsBXlX1JDQiCKxooMQ2ZKItLo5BxymMgU24O3KT8Iyk+dqbqSOulxS+xThVB0Qm/iw0OsIGzT6H1TZQ0g2K4nugWN7aCF2Tqct3b0vALCsEHVei1B25u/SfyBYYQkzTdV6VY=
Received: from MW3PR11MB4554.namprd11.prod.outlook.com (2603:10b6:303:5d::7)
 by MWHPR11MB0079.namprd11.prod.outlook.com (2603:10b6:301:6b::38) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.23; Tue, 8 Dec
 2020 12:50:34 +0000
Received: from MW3PR11MB4554.namprd11.prod.outlook.com
 ([fe80::7dc3:6311:ac6:7393]) by MW3PR11MB4554.namprd11.prod.outlook.com
 ([fe80::7dc3:6311:ac6:7393%8]) with mapi id 15.20.3654.012; Tue, 8 Dec 2020
 12:50:34 +0000
From:   "Penigalapati, Sandeep" <sandeep.penigalapati@intel.com>
To:     "sven.auhagen@voleatech.de" <sven.auhagen@voleatech.de>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "pmenzel@molgen.mpg.de" <pmenzel@molgen.mpg.de>
Subject: RE: [PATCH v4 4/6] igb: skb add metasize for xdp
Thread-Topic: [PATCH v4 4/6] igb: skb add metasize for xdp
Thread-Index: AQHWuEzVsiikPu0ldUSVLge7mIb8mKntUI9A
Date:   Tue, 8 Dec 2020 12:50:34 +0000
Message-ID: <MW3PR11MB4554EEA037B3E5AACC9E42E39CCD0@MW3PR11MB4554.namprd11.prod.outlook.com>
References: <20201111170453.32693-1-sven.auhagen@voleatech.de>
 <20201111170453.32693-5-sven.auhagen@voleatech.de>
In-Reply-To: <20201111170453.32693-5-sven.auhagen@voleatech.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
authentication-results: voleatech.de; dkim=none (message not signed)
 header.d=none;voleatech.de; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.55.79.100]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a895bc08-4e48-4595-108d-08d89b77dade
x-ms-traffictypediagnostic: MWHPR11MB0079:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB00799AF228988E97FC7DFBFD9CCD0@MWHPR11MB0079.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2733;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hrRSHiDxQTcfqooio8A3u5Kj+p3dzfK7xm5yMiCkIhovq5C54ykB+OUt2361KhSaDimZNS9mzPl2JmcZ9yIR1k01jEuHXfvFj+dS1fgdWGPpS1i4FUUxnjBnC9rLafrNK5JPR78sAsm+iQqsPzFfiesfle1+K+AwiFxF9yIdBbDHvYaMnY8RcTbs56nUzll1BcfIeAdnMt6ZCelQSHrUR7uDsmbIYRByNKU9S6eVwirCcf6lPNcrbjAN+/FbGVdaEmDev0J3kT5VHOAaUdrF1jBsllOtQWtE65AvM2IsokNzyLUO5i0y/l8lJMXqNYUP3D9W6Av2pjlTDKVJLKZkFw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4554.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(39860400002)(136003)(346002)(376002)(86362001)(9686003)(6506007)(8676002)(186003)(55016002)(53546011)(478600001)(4744005)(66476007)(316002)(66946007)(66556008)(52536014)(71200400001)(5660300002)(26005)(4326008)(2906002)(66446008)(8936002)(110136005)(54906003)(64756008)(33656002)(7696005)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?jabsGkdDoW3n6MUuLwJr4gKOLSM2PT0vHK80EkT5ahCpoM1N98Gro5ch/kAE?=
 =?us-ascii?Q?w4ikeMo9iCpm59hwX1zl7PAjT7YgZqS1p83QoRhueTg00H7Bu/VufBOo5FnO?=
 =?us-ascii?Q?3P9D+v5Kfo+2HvN5SiugRN0n97u/nhR9dizcnIC6xqsmp8qivjJkwwiZ7xrS?=
 =?us-ascii?Q?lwg/sDeFI9vclGWCeT2YVBsrSYAhlkCo6lqNLI5wH5WyVcqAkEiUSZyS6LRE?=
 =?us-ascii?Q?bi60cTFBBCTGtJ1HeemgL31nwxlI0UJcNDpXeN/wcZP8z5QUT3Nq/CMKXJux?=
 =?us-ascii?Q?4S5ZRgoEqGNcziGIkg3N0tjTmQy5nO3bRHLMltfh5z1Rklt5H9Poism9BpY2?=
 =?us-ascii?Q?km983exj/a05qteq7BeX2tdjYfiHgLzRNpWEcqkaA+NlIYPkVzyElZZQot7P?=
 =?us-ascii?Q?i8AOejZcHvj1aVxo5xwWICvB3hXWNvizagqvCKX6NPklfN6zaAk2f8ih/8Bf?=
 =?us-ascii?Q?mvlGdtemPHvCdy/601AV1wfLxjTuqsV7HbZMMP1+exrDDBn813zt8QW7quu+?=
 =?us-ascii?Q?rIHrRQ6vtzmnzDezFNzSYjIZ9ErVFKX3gxYLGyAeovAdikef+6n5gZgdBHQ+?=
 =?us-ascii?Q?4rcmgJDFI6rEdf9GOrhXEHiRBW6oYhMus7jTH6Fw5VgphvkCLNVGyicivREz?=
 =?us-ascii?Q?Ejs6hmpitSwOp/fi2NnDmRXzkk9bVIJZPzX1QPSzaQg8EeALfjGYNI7uDiGx?=
 =?us-ascii?Q?V2p7VS61qMj3h81snoxgxAQd5Q13/GP/qk9n1Jo4MEL3u3m9Ocrg4U1A/t7s?=
 =?us-ascii?Q?IqcieIwP3jXzkirWL/WiBR2DvyPqEFYxerMfgHiJqWHZ9UjiVnb7kfxxn+QQ?=
 =?us-ascii?Q?msxPL3TbXV3UEak42cUl1r7qkIRSmuciStNBPA+zIsiwvR3H+opPOmNRPfaB?=
 =?us-ascii?Q?zN6VKBbZnUNKrPRavHZC0nq7qglhaFYq3ja7C6t4b2zoReP5Gpyo5y7qnCPn?=
 =?us-ascii?Q?OXXKSA/xKoJIxtq+j5uwx5RK59nTl2LIXUoDK70OYug=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4554.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a895bc08-4e48-4595-108d-08d89b77dade
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Dec 2020 12:50:34.7364
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LMLc/AgojccJOhHH4sILW7qgic2YCb3Fxo7ZdMlDJBU/ivCi6ZZ2PpKKYVTRqX6OfAEZbF2LTnt+uiPcg1Sqoa323UNRGASn16rREGWeQIQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB0079
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: sven.auhagen@voleatech.de <sven.auhagen@voleatech.de>
> Sent: Wednesday, November 11, 2020 10:35 PM
> To: Nguyen, Anthony L <anthony.l.nguyen@intel.com>; Fijalkowski, Maciej
> <maciej.fijalkowski@intel.com>; kuba@kernel.org
> Cc: davem@davemloft.net; intel-wired-lan@lists.osuosl.org;
> netdev@vger.kernel.org; nhorman@redhat.com; sassmann@redhat.com;
> Penigalapati, Sandeep <sandeep.penigalapati@intel.com>;
> brouer@redhat.com; pmenzel@molgen.mpg.de
> Subject: [PATCH v4 4/6] igb: skb add metasize for xdp
>=20
> From: Sven Auhagen <sven.auhagen@voleatech.de>
>=20
> add metasize if it is set in xdp
>=20
> Suggested-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
> ---
>  drivers/net/ethernet/intel/igb/igb_main.c | 4 ++++
>  1 file changed, 4 insertions(+)
>=20
Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
