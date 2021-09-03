Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 211823FFA82
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 08:41:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346764AbhICGlr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 02:41:47 -0400
Received: from mga12.intel.com ([192.55.52.136]:2929 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343902AbhICGlq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Sep 2021 02:41:46 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10095"; a="198889329"
X-IronPort-AV: E=Sophos;i="5.85,264,1624345200"; 
   d="scan'208";a="198889329"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2021 23:40:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,264,1624345200"; 
   d="scan'208";a="511356511"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga001.jf.intel.com with ESMTP; 02 Sep 2021 23:40:45 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 2 Sep 2021 23:40:44 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Thu, 2 Sep 2021 23:40:44 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.106)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Thu, 2 Sep 2021 23:40:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XG7+LPrvzStT1xmqsrXRuxNMzl7dcMlDGP5KZBlC5xGkTi/3PlG19eXuVhLyHy6dFb188z3cYg6sp0Pty5NZvZ/gpi+IVZ4s0bc0eILf++PcjipbgEsmPixg6jkyBtUZocyN9FgH7f9wYxXRgyFkeOxvuR37FD73jYKAvw7fpgYNmQieDoEP67ialFWbMnT0fGactehYWx1lr443Kr1qfk6BGi6nNQT0hhR90bNYJDv6HQnrmx4jFLbzZ2Ox0kkmW36wfvqrdvRTISz+7DduTbx/3YZ+gHC6wTockc1M7ctsfapuEHFXA2BC/nkAa58fU6D3/OQbQd0F22GdhrGauA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=azJniJsenDJ0Lwf23u2Cr9RKMOKja4Uf7BbORKDuNYk=;
 b=eo2EiO201uRsPjejg9aVVSy+AjWoFeoM7jF+1DfbBTwA2CvqAZaA0omJTubO3WX6k5I+0jjsuU0d8ykpK7mEfpx6FwesH/JcfEf1gRWR2v9U3kL1CM9/nF8vfNrkuW7VdqgXov4H6cbeZSDHQFK9jP1bcynyaZcexlzKsyvuaLY2lBifLhZRgp9WWgEgEGV1UpkPLsPqCt1blhRztmEGvTb1n04B6JrrEb3beMOvDtynGYgYpInpDe8eIsPK+dcwbDO3xYFoFnFb+Dt6+IvftFpZ0YN7UW3HcLIllG7ipmm6+9wL74S1UTQgmOi3YD6MYlpYu1J5p5y9KlE0q0PJZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=azJniJsenDJ0Lwf23u2Cr9RKMOKja4Uf7BbORKDuNYk=;
 b=Va4uuV+zg6RnYHKth0YZlJHeqSjjywBv3a0BnZxUqSU/Ap07slFfBA4YWwXXhn+ImWmouAR3VgxRlVZrnPoBQKpErPJFs7dDXtks0FJvKNR9BDRnH3mp/troSxGsFLyJIpqpwuxR6rYD0+xYZtSKBekDOEEv6jP5QZC50Jnq7xM=
Received: from PH0PR11MB5144.namprd11.prod.outlook.com (2603:10b6:510:3e::20)
 by PH0PR11MB5029.namprd11.prod.outlook.com (2603:10b6:510:30::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.23; Fri, 3 Sep
 2021 06:40:42 +0000
Received: from PH0PR11MB5144.namprd11.prod.outlook.com
 ([fe80::105f:b75f:c95e:f885]) by PH0PR11MB5144.namprd11.prod.outlook.com
 ([fe80::105f:b75f:c95e:f885%3]) with mapi id 15.20.4478.022; Fri, 3 Sep 2021
 06:40:42 +0000
From:   "Kuruvinakunnel, George" <george.kuruvinakunnel@intel.com>
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
Subject: RE: [Intel-wired-lan] [PATCH v7 intel-next 5/9] ice: do not create
 xdp_frame on XDP_TX
Thread-Topic: [Intel-wired-lan] [PATCH v7 intel-next 5/9] ice: do not create
 xdp_frame on XDP_TX
Thread-Index: AQHXlPP/JxNxggnlKUiwpNy2u162IKuR8yMw
Date:   Fri, 3 Sep 2021 06:40:42 +0000
Message-ID: <PH0PR11MB5144474F59154C5DC3CAC56AE2CF9@PH0PR11MB5144.namprd11.prod.outlook.com>
References: <20210819120004.34392-1-maciej.fijalkowski@intel.com>
 <20210819120004.34392-6-maciej.fijalkowski@intel.com>
In-Reply-To: <20210819120004.34392-6-maciej.fijalkowski@intel.com>
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
x-ms-office365-filtering-correlation-id: 028138b0-9205-4016-6f50-08d96ea5c040
x-ms-traffictypediagnostic: PH0PR11MB5029:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR11MB5029B9EC23E15121E1D748F2E2CF9@PH0PR11MB5029.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vpgMN0ZjMh3OIoquCUis8vrM1j0vWwQpiCAllMC47bsxhnec85ETG7FMMXs2uyOj1rIggkhQ9hJksKxLKljBo6aC7T/t4xcGd1/iMenXjztnCzyMhZ5A5I9bbdwVi2l+ozBJQn8O00ZrUdCFWfa3tTFZhumD7xQOyb1nz3PIYOCC1qKqcRMnwZIqOSDJVpOoQBdMcxC6Cr3HlueV0kK3J6f05XGtBQJ71iKS4vioSCC9uDQTEHeARWKmcw6u6mcxOoqTbD7DUl0DC3nxq10M4cJ9PYeaXP/kpoYbaf5w3EBSfRmGvu66zY7336F4Pd6Et0Z7VeSgzUBbAwq2zlPhES+myHjWoAEBYd52eRmeyXDUKNZu70S20cnvbLqAIPdYafDp9YW/lA8aHaecpFmHGYD5/FhG1WqghScFnsd54TwAz9Ftc0G2p1P8DE6m8BSDoYkFhnR3uaIs8AjkvxpyPO2gy+xIfakHCMQc9RJIEfaMqwDWq02SqElQLYouzoTFPSCEwei2OuORG7gDzXlP9BAolwjzdxTo5L/OD9+8V0TU2c7Bb9mstHgMAzF4ZtEBb8nyXI5vr2Ql3T/1OuBq7djab69lftQtVZxV7Fu1PdLTLWrE/BjFO/GRj5x+DQa7KhETNnXo4BiCmIAwDH2y+puScm4j6GA/ADiShSWvR76EK8W3VbaDGd3y+NRbOH1cDTHlGCi+tFtIIpSH6YbogA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5144.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(55016002)(122000001)(53546011)(71200400001)(107886003)(26005)(8936002)(508600001)(38070700005)(83380400001)(52536014)(33656002)(6506007)(9686003)(54906003)(4744005)(7696005)(186003)(2906002)(110136005)(8676002)(316002)(76116006)(66446008)(66556008)(64756008)(66946007)(66476007)(5660300002)(86362001)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?NcM3OVQUSUZ/vqzeCwf1F7anig5Kxuz9FvkR4Al+yiEijgmpk2PrhAKlx6HR?=
 =?us-ascii?Q?UZ1xSaLLizxxWIbR5nFAiOP2mUDVhvnqUyOOyWKT4cwAo3KErgyJNUwFX0sW?=
 =?us-ascii?Q?UOgHhS+LrnXAsAbUthwZklEEBFsq5z548vPlzb554a0i/kmp5qlNq6krKzpz?=
 =?us-ascii?Q?cVDaFouQxl778cMGnubPrLYhiewZuji+TNyRThkX4GaZk7pY1S8s+WkgS1w6?=
 =?us-ascii?Q?CYRuf2NeLuTSIFY/guxg4KxansiZEKuDZPh5eso9cp5t3RSVXiuNhYkUqQds?=
 =?us-ascii?Q?77isN20MLopHIV5djQWYtSS8uI+42fXiRqopovlo5DYHYNlZ5rme8KcQcm4d?=
 =?us-ascii?Q?8qmRVqxGbYXk+CjZDp1xhRF1L6E0UxnVDxoUpWPWDCA3ljsYF0HJQrqcuB3G?=
 =?us-ascii?Q?yi6aLZ3/QlzswUwMRH7PRlRQm7OmRHvc9miCCII+c4Y3yxhDz6KD/1/NbpqE?=
 =?us-ascii?Q?ezLLJd6/eXcIKscu1cp/rk55GWL0TZt7FewYQNHV67qIq5QaeQjEHH6vso8B?=
 =?us-ascii?Q?4B41/uSYywuwWZctcTy4JaZgOVJ4IHF1oqVVE/V2IwVkh22FwdJNHHFge8Rs?=
 =?us-ascii?Q?LmenWaRu85ForTVlp2wlOWVYnNisTkFeQ1R+sKR3lumMP8lD3tq8zLdXrs3B?=
 =?us-ascii?Q?7lQavgbaZjoVdWU1tUs6EgfhParX6sHuOTcY/YKw0GfgihkK0slSWUXbNUHl?=
 =?us-ascii?Q?c986z9UGUlEBQG74f1fdbc84nL4SiNuEAJ/lGpd+SjAvu8RteF/1txXNG8fk?=
 =?us-ascii?Q?N6y05EIC6JViBakXu1Nu/uh9aTFPSyvgRBK/g1Tgubl/jrVCqP03HwlYxKG8?=
 =?us-ascii?Q?s0aBolDDYHQQBi0t2zAw2tuN4hc26GHKUd3GT+YEdtrIMGUo3CsNeRNRTQ4j?=
 =?us-ascii?Q?u83WK869OQ+3lddOWtNrXoyvUG2h8BliJY+qdcjnAfsXqSpRxN51Ee12Ro2r?=
 =?us-ascii?Q?1MFP3jOByauyiRYJRYaKIcbSkxHA3o924feimkswZ77B27Y+eBKuYKtOIK1s?=
 =?us-ascii?Q?3gHPposJA3AHHSeQcMpYEXEOy8wZMPam+L3+/ML4v+oF7ASCca/TAqMKYbXn?=
 =?us-ascii?Q?3mVv78eGlcRkm141s7Q16vuoyxfTWZ3KkxlcfZO/0s+nmGtBLrFMau0EwxhC?=
 =?us-ascii?Q?IccRZct2c5Q+GTEDP9+k8oadfX9ujruf3Fz9rO4DSXM7daANPkMPCsQ5Ea7W?=
 =?us-ascii?Q?YwPk2r8x1jALTIEQC1rCe1/gJBRRCRVXn3Lo1oFnDDwmUg6/zikhEbnf7X8T?=
 =?us-ascii?Q?dvJJ7sDDOsjW/4YA+he0OGKkU1I8fx4qmDcHauZPt36YYhzDrMr08wrPfY4l?=
 =?us-ascii?Q?IWE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5144.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 028138b0-9205-4016-6f50-08d96ea5c040
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Sep 2021 06:40:42.2697
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eGSrKNM3P2VTdhgyjK6e+/6LT/hX5S5XRnSn8B65sGk6Hq3/NtCZbLpZB1WI7oXuGNHXQssBj7J9JpJa1CSCBy7j/et6OvoiaZ6lmIguQw4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5029
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of M=
aciej
> Fijalkowski
> Sent: Thursday, August 19, 2021 5:30 PM
> To: intel-wired-lan@lists.osuosl.org
> Cc: joamaki@gmail.com; Lobakin, Alexandr <alexandr.lobakin@intel.com>;
> netdev@vger.kernel.org; toke@redhat.com; bjorn@kernel.org; kuba@kernel.or=
g;
> bpf@vger.kernel.org; davem@davemloft.net; Karlsson, Magnus
> <magnus.karlsson@intel.com>
> Subject: [Intel-wired-lan] [PATCH v7 intel-next 5/9] ice: do not create x=
dp_frame on
> XDP_TX
>=20
> xdp_frame is not needed for XDP_TX data path in ice driver case.
> For this data path cleaning of sent descriptor will not happen anywhere o=
utside of
> the driver, which means that carrying the information about the underlyin=
g memory
> model via xdp_frame will not be used. Therefore, this conversion can be s=
imply
> dropped, which would relieve CPU a bit.
>=20
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_txrx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20

Tested-by: George Kuruvinakunnel <george.kuruvinakunnel@intel.com>
