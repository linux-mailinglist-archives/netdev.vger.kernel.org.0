Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF6273DD68A
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 15:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233715AbhHBNK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 09:10:26 -0400
Received: from mga01.intel.com ([192.55.52.88]:24899 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233645AbhHBNKV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 09:10:21 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10063"; a="235378910"
X-IronPort-AV: E=Sophos;i="5.84,289,1620716400"; 
   d="scan'208";a="235378910"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2021 06:07:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,289,1620716400"; 
   d="scan'208";a="510150852"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by FMSMGA003.fm.intel.com with ESMTP; 02 Aug 2021 06:07:13 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Mon, 2 Aug 2021 06:07:13 -0700
Received: from orsmsx606.amr.corp.intel.com (10.22.229.19) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Mon, 2 Aug 2021 06:07:13 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Mon, 2 Aug 2021 06:07:13 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Mon, 2 Aug 2021 06:07:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=glEDCUNxTkneNxvMNRZtCLFkTQUAJl8vDKEHVr+9JlJ6BZohsT4uF1KeXAPmxhvZx8hPXQYElr0s4P4xWs5BtL36C0if3gj4bKCrWduKDVjvd7Pmw2WGq/5NGaCu8XFdoqqx2ClonkbczvA/srjOYAisO0ueK04vSQygv8Ud1CEs8HPYw9C4bf1QBs9EmqhvO3Bja2Zhj9+dTjunII0S9xHvFSHX/fq1oPiIA1xYc81mSGXXKBOpgJIHx71C0tO+hSdtKnRfS096NR7Zo7dtIh5rJ6rB4bxVZi4QOUjbgx1zSbm6ZmkURpwIvWopvEPYqu51oUD4leo13wHJgV13fQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+S8EuRRx2L+Kph/AmusR+Z6RTbE1qMugeBn2Ck0ko4o=;
 b=dz78vuLu8aNGweCg6Da5o3lZ5RwdXZzRwHC9hchwAJZ1/8F1A6Clvzd3up6ZSDEi5F1rvBDLqSL31WNRtk3wmlp+FxgJCWqQY1KwmfCkdO+IiEVMANUywK/wzxTvSA9KdLq03YOrjj6obufaow2G8T7Rj5DN3mQ/r4vTmgJzgAAkqmNHPqDyn3NhUnFqJygwVRKfhaOLqEdTGzmjzSf4/fo/eKKYfKU2uBa4A3Jqqod2WHMQHkiITzUB7q3aPeCjqIdZndMWZKOp3WYG6Vx/lNfX99MQHp1GpCiaGpW6sUgTCFseCa9Ek0jQHy0BzStB5vX7TzHtehURSTYwAg132g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+S8EuRRx2L+Kph/AmusR+Z6RTbE1qMugeBn2Ck0ko4o=;
 b=jgrZayfIgFOGddJ6kxYqbr9JcyC1mk5m9euFBzcvF53QpA050VznGALDbosj8QDgUMBBIn2dmUtyB+WvLBGTHa3uuki+n1OdMVrFl8GuKQCknDNUiPYPTnkbTi8EupSwHIuG2XNAatGCgRzx6/a0I0PaBaAd0xOrLGyAUrJUTts=
Received: from BYAPR11MB3367.namprd11.prod.outlook.com (2603:10b6:a03:79::29)
 by SJ0PR11MB5151.namprd11.prod.outlook.com (2603:10b6:a03:2ac::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18; Mon, 2 Aug
 2021 13:07:11 +0000
Received: from BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::4d0f:77de:b513:595d]) by BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::4d0f:77de:b513:595d%5]) with mapi id 15.20.4373.022; Mon, 2 Aug 2021
 13:07:11 +0000
From:   "G, GurucharanX" <gurucharanx.g@intel.com>
To:     Arnd Bergmann <arnd@kernel.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Keller, Jacob E" <jacob.e.keller@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     Arnd Bergmann <arnd@arndb.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "intel-wired-lan-bounces@osuosl.org" 
        <intel-wired-lan-bounces@osuosl.org>
Subject: RE: [Intel-wired-lan] [PATCH] ethernet/intel: fix PTP_1588_CLOCK
 dependencies
Thread-Topic: [Intel-wired-lan] [PATCH] ethernet/intel: fix PTP_1588_CLOCK
 dependencies
Thread-Index: AQHXgiMw8RcSz1WqMk2A4/Ocf/AkqqtgOf5A
Date:   Mon, 2 Aug 2021 13:07:10 +0000
Message-ID: <BYAPR11MB336781A3C6B41DFFFD838157FCEF9@BYAPR11MB3367.namprd11.prod.outlook.com>
References: <20210726084540.3282344-1-arnd@kernel.org>
In-Reply-To: <20210726084540.3282344-1-arnd@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1bcc53fa-1746-4f1f-cbce-08d955b670a6
x-ms-traffictypediagnostic: SJ0PR11MB5151:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR11MB5151E29C9506344CCA56A937FCEF9@SJ0PR11MB5151.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 16Ga8t6G5OxBnMsRL1HHj36PfUoX4UMCmNy16NGFF8tUjjMX3sX+Q7bVWr/OGqfnrfbCRZdN3O4jWnItI7JQLk80r+MD2AUas0FErbdklV7t8Hz5MDxvROFPl26oxZFuufdd09+NklAHs44l6TlqAcDKQdUTH+7KWGrfpP0tzE8TV/RomTgtPGAiJACYf9CDmhTKGPBcpw1xg36VUua43YNolH3P5Ci49bobXlHFUWX+xCWQV7dPxvPKh1dicnHhTYmNrmOu2okc9afZbnrB6ilsGEXi6mbbpnbeL43vTlJ03m5o5aUTW/itgd+VE+zwfl3KyGyO9g8BJgGjYrin5VD5A+RToWE7Py3koFAn/X/77YXmqe8mTyHGJK+wDBo8W2WuQFdI5kFmPnwO82TDTqTwCl3z8bX6Ix2Gj3L/9stOb4h+lqNP1gvbFLsPtDq1BTORaCjmkU+mg6yRthOjv0eygLFZRSGuWt3/6aawJx8RXlnzp8QP/ZjRP47E4f73vGp/XTHcX02H5zAYHHYLxxUdS7tBvXJ/g7DtOK7mSr1QBz5O1PfTrMPBcF5Y/BvxwSDBY+62QDsTBNQ9zE2U+hZEuyPsKnB+d2PCmqkmoQeDnR4qQ4eTiDSM5IFmu06laVZPXjvopsWaUsI1T6pTlSUpGPjl8SZz/64RiKpM/zDzdv4qMPy4k9eZPMi9h9uJfTog0dKS0dvZYBK983EB4FrXWUcx4C1y2QlU5LmujLY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3367.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38070700005)(66946007)(55016002)(122000001)(66476007)(83380400001)(64756008)(76116006)(66446008)(38100700002)(86362001)(33656002)(186003)(7696005)(66556008)(5660300002)(9686003)(26005)(2906002)(921005)(6506007)(8936002)(508600001)(53546011)(52536014)(110136005)(4326008)(316002)(54906003)(71200400001)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?os+dUpXjdh50yI/JcqS1a+PPzJR5oFW7WvEG2m8ATEpx8r3MsNQ2YfIdTVky?=
 =?us-ascii?Q?EjbHae8EIUiiX2lVIy4tHTzpQtvEnU3yi0OgZ8n6JMzezMgbMNV9Ls8AhxnC?=
 =?us-ascii?Q?fMiAl/nNMftCAy62MLoZqrNICnR+S14ruBLN5qZ4hsPXDLTibey0GibeuFdU?=
 =?us-ascii?Q?Bz+4HxQPVz4gyO7R9n6Mp/fWh8tr5nQ0MPe5BKH0sHkiQf68bU0CEUNs0wdg?=
 =?us-ascii?Q?PeR9osaN3N+ECvwSfvxIj8EZqA8CHiozr7sZCOtK0o0LpAPNe6I4YneApKel?=
 =?us-ascii?Q?VX3tIinpDkKJQ7vu2Bu98pLXZaEWW9kH+32yXWC9EaKMDdd9yfnnNFSH7Axq?=
 =?us-ascii?Q?JzkTEhQHrlsz6qycPrzuKlCzrZ73IiGqIZcXAPdEG3MTgWplS8qv4KVSVO9a?=
 =?us-ascii?Q?Fn73jve7+1kAuCvh7G4ctajSplxdvjWJTHaiSBwuVGizjGNwlaiao+bi2n1S?=
 =?us-ascii?Q?nTUVSl7yF0jHyVFynNKB4IuAnkwFHqC7lnN+Wi82G4DLPViuArY4/vuC+tMA?=
 =?us-ascii?Q?8aJwycc51uPVFn8bH5o7dT9oSGxXqnKc2Oz0SmTtY/r/wkqFK0h7GmObHg7f?=
 =?us-ascii?Q?ozeUT2TPcrk2G3jeYudndogTjTKDwRX/THpzMyCVhIcgwaL2xCOYIGLDnSmz?=
 =?us-ascii?Q?cyFRvzHDJGoaAOED9kovgqpcXCKsZUtLjgaUoItuqCedh67pFeAGNyZk+UDU?=
 =?us-ascii?Q?/t16c3y4tDlJQTMWkNLtxMO7musKKvjh+0JQAeXGpES39b5uaaLyGttGSet+?=
 =?us-ascii?Q?TSzHxCKCqspqXgmanFFXRyF1aorDZ0wnz3FSJBYei7s7pBWtg5hGc9lPzpTR?=
 =?us-ascii?Q?I6h1vjp5LYzpw0xbSOmMIDU9/nkfDPwrcMsNwDjwOteCkDhtWaAjxQshaltd?=
 =?us-ascii?Q?cvmQ9Q2tXHvOxj82JnykgsmId178pI/j9wJ7TiMfg5opPRP8qvZNjLdS7srC?=
 =?us-ascii?Q?JXMs1m2az9B9Ig7XjHu+oid7aW8sQPHvU3+XnFRppWO5xsy5/0jsu4qu3Sut?=
 =?us-ascii?Q?iyd01IOj4MI7CDWIXQGt56cw++GKQCnZjJF4k81MqP1n1M1GivTLWtnYlbrr?=
 =?us-ascii?Q?SmChpnGoTQW8mj1+iTjYiDpdKDQ2BWjsB18y8JYQvn5IjT2pp4UEPWgQSOiZ?=
 =?us-ascii?Q?1hHnHuCIK+h7KEgDM7yLe9QUnZP8iHkLcBWyK4BxGN/Q4zlaC6xTCJSUz92R?=
 =?us-ascii?Q?yS4UZdmSSIh5NMBFBI7mqKrnh6ziAcCQcW9OpmfPRY8dJfvhfUbo0E0jJeI3?=
 =?us-ascii?Q?ut8u/35WoZD6EaO4kxyrM8LwseLiAsXnpRJtbT0H15LBFa+XDaEv8iT7jYHd?=
 =?us-ascii?Q?SE0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3367.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bcc53fa-1746-4f1f-cbce-08d955b670a6
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Aug 2021 13:07:10.9725
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7XQl+ZwHCiIJEbKv/g0PSUQN03EwjzpQKKNMEX0tvhO5G2Nz/NOXF8bnzYxT8WKqKY/KSRVcaBDe1o+gYuMiDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5151
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Arnd Bergmann
> Sent: Monday, July 26, 2021 2:15 PM
> To: Brandeburg, Jesse <jesse.brandeburg@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; David S. Miller <davem@davemloft.net>;
> Jakub Kicinski <kuba@kernel.org>; Keller, Jacob E
> <jacob.e.keller@intel.com>
> Cc: Arnd Bergmann <arnd@arndb.de>; netdev@vger.kernel.org; Kurt
> Kanzenbach <kurt@linutronix.de>; linux-kernel@vger.kernel.org; intel-
> wired-lan@lists.osuosl.org; Saleem, Shiraz <shiraz.saleem@intel.com>
> Subject: [Intel-wired-lan] [PATCH] ethernet/intel: fix PTP_1588_CLOCK
> dependencies
>=20
> From: Arnd Bergmann <arnd@arndb.de>
>=20
> The 'imply' keyword does not do what most people think it does, it only
> politely asks Kconfig to turn on another symbol, but does not prevent it =
from
> being disabled manually or built as a loadable module when the user is bu=
ilt-
> in. In the ICE driver, the latter now causes a link failure:
>=20
> aarch64-linux-ld: drivers/net/ethernet/intel/ice/ice_main.o: in function
> `ice_eth_ioctl':
> ice_main.c:(.text+0x13b0): undefined reference to `ice_ptp_get_ts_config'
> ice_main.c:(.text+0x13b0): relocation truncated to fit: R_AARCH64_CALL26
> against undefined symbol `ice_ptp_get_ts_config'
> aarch64-linux-ld: ice_main.c:(.text+0x13bc): undefined reference to
> `ice_ptp_set_ts_config'
> ice_main.c:(.text+0x13bc): relocation truncated to fit: R_AARCH64_CALL26
> against undefined symbol `ice_ptp_set_ts_config'
> aarch64-linux-ld: drivers/net/ethernet/intel/ice/ice_main.o: in function
> `ice_prepare_for_reset':
> ice_main.c:(.text+0x31fc): undefined reference to `ice_ptp_release'
> ice_main.c:(.text+0x31fc): relocation truncated to fit: R_AARCH64_CALL26
> against undefined symbol `ice_ptp_release'
> aarch64-linux-ld: drivers/net/ethernet/intel/ice/ice_main.o: in function
> `ice_rebuild':
>=20
> For the other Intel network drivers, there is no link error when the driv=
ers
> are built-in and PTP is a loadable module, because linux/ptp_clock_kernel=
.h
> contains an IS_REACHABLE() check, but this just changes the compile-time
> failure to a runtime failure, which is arguably worse.
>=20
> Change all the Intel drivers to use the 'depends on PTP_1588_CLOCK ||
> !PTP_1588_CLOCK' trick to prevent the broken configuration, as we already
> do for several other drivers. To avoid circular dependencies, this also r=
equires
> changing the IGB driver back to using the normal 'depends on I2C' instead=
 of
> 'select I2C'.
>=20
> Fixes: 06c16d89d2cb ("ice: register 1588 PTP clock device object for E810
> devices")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/net/ethernet/intel/Kconfig | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>=20

Tested-by: Gurucharan  G <Gurucharanx.g@intel.com> (A Contingent Worker at =
Intel)
