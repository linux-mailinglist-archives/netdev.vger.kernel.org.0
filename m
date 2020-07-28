Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A972E231411
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 22:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728874AbgG1Uis (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 16:38:48 -0400
Received: from mga12.intel.com ([192.55.52.136]:24657 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728535AbgG1Uir (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 16:38:47 -0400
IronPort-SDR: ona8i2rk05VjRWu/6GPOJWdT9iJ6pgFv27kDUdKSBgrGBG+3AmX33ZCgV1qEAhkIUo2Z6P4QRO
 goj6j64RSqog==
X-IronPort-AV: E=McAfee;i="6000,8403,9696"; a="130869273"
X-IronPort-AV: E=Sophos;i="5.75,407,1589266800"; 
   d="scan'208";a="130869273"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2020 13:38:47 -0700
IronPort-SDR: n5Kxk3KTjFf+arkBjDAdDi0GOlemXS45JYSaWRModxtYnj3AiWkUqlwQQUgvM/ySGUMxCw+KAw
 Vc+94dSnMtVw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,407,1589266800"; 
   d="scan'208";a="286287882"
Received: from orsmsx103.amr.corp.intel.com ([10.22.225.130])
  by orsmga003.jf.intel.com with ESMTP; 28 Jul 2020 13:38:47 -0700
Received: from ORSEDG001.ED.cps.intel.com (10.7.248.4) by
 ORSMSX103.amr.corp.intel.com (10.22.225.130) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 28 Jul 2020 13:38:46 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (104.47.45.56) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Tue, 28 Jul 2020 13:38:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h5EX1ueZbUX0xshb+jUm48sAIeRRJR3VA2jTJUf3sJnDpvSrl/HQgVIsf2jkMP3RFi7rPl7I0iq85/kfZ9xKwcnA/WLg6ifdseGc5o1etuY1QooQKnmteHsCaiWKfGaWztsVAHd64hs9xlJV2ZdjgLMuNg+fZyfKMGVQmDxDUME3xfyrB4tHkXUpxaQ0D0R7y+3b/VqgcaT3NULyG5oLSqf0frksTydagJDFvDcPz0i9sTZimQzFuZXiwrtkQxUr566sh8ay819SQJTdMpxsriz9IyKvX+bB4jfVE8kSj2A8G9bzxD2qPgoSC68CtQtBBXIb40GGpsUQqjLmdjm/1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PKn/dNVdFHMCkMxw+n1e+bX07077nJw6AQ70ek6bjdc=;
 b=Hxhm9zMXSZUyUuPrMcq9OKZaJteAlOWFjXbxyM6Y5wXJ5xtkS+tlBsoIZw7qlujyJHg8ZQS2RFOPW+gwOmLBj0qz0gbBIwUx/4lcMz15uZ7UKpll1UfLhY2JG24d5kSICelPzMr0yVUDxf76Qmb++jxVxFoaS7wPBsOls+O7s7gF23cktXtj8NLMhhU157obPr0UZocl3d/NTvq1xvz+yA4fOvLkbULzdu9uat7dwyifxfpw1wia69wHH2P/qB89YyrSb+6kZMfx+laHPSllKQ0e7JH8YxyoPgll/UjESQwn0dSvLRcABUvNzkRaOQ/RPJIyfheoebABJydGNMDZdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PKn/dNVdFHMCkMxw+n1e+bX07077nJw6AQ70ek6bjdc=;
 b=rG4yc56k0zzKekv23mgFdKjmhE3SzsQD5oVHhX9OwnULUR2ElY0eoNiDQtKmAngAWsMeWjdhV8LSa1wN7zGYkwMCnFNRFHlhKIDHEM1kVo6JtDItyW7NE3Zrl+7wPICbi5qMCzPo1itHirByb6/ZQCcUNrKQXjnsbNlOm+lKqxg=
Received: from DM6PR11MB2890.namprd11.prod.outlook.com (2603:10b6:5:63::20) by
 DM6PR11MB4377.namprd11.prod.outlook.com (2603:10b6:5:1dc::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3216.23; Tue, 28 Jul 2020 20:37:36 +0000
Received: from DM6PR11MB2890.namprd11.prod.outlook.com
 ([fe80::65c2:9ac9:2c52:82bd]) by DM6PR11MB2890.namprd11.prod.outlook.com
 ([fe80::65c2:9ac9:2c52:82bd%6]) with mapi id 15.20.3216.033; Tue, 28 Jul 2020
 20:37:36 +0000
From:   "Brown, Aaron F" <aaron.f.brown@intel.com>
To:     Francesco Ruggeri <fruggeri@arista.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
Subject: RE: [Intel-wired-lan] [PATCH v2] igb: reinit_locked() should be
 called with rtnl_lock
Thread-Topic: [Intel-wired-lan] [PATCH v2] igb: reinit_locked() should be
 called with rtnl_lock
Thread-Index: AQHWUMGiXDSOO3SbG0KRyfqBaSbfrKkdnC3Q
Date:   Tue, 28 Jul 2020 20:37:36 +0000
Message-ID: <DM6PR11MB28903B2C52C7DE21578C17B4BC730@DM6PR11MB2890.namprd11.prod.outlook.com>
References: <20200702223906.42B6C95C0494@us180.sjc.aristanetworks.com>
In-Reply-To: <20200702223906.42B6C95C0494@us180.sjc.aristanetworks.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: arista.com; dkim=none (message not signed)
 header.d=none;arista.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [97.120.173.209]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a02842b5-b90e-48f4-2420-08d833360ff9
x-ms-traffictypediagnostic: DM6PR11MB4377:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB4377103F6E5D32673998B0D8BC730@DM6PR11MB4377.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:792;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CE6+6DAOzQ3GEwnTsHJDEjp4TDKYvdPIxw5jajXBtdQe78t6eTfUwaBUftiSm/pZ/8K0w5nXG7TwvZp+sH0lxtui/ir45ZYLTZM0L4PgtOi69CiVgJT3/iRt9XoDR6S+vuw4hO8DIcyR5+EUBit1yEToN8AHHd2zuFGsd1rRvE24/H1eQTDbuKAX9Mn7DWNiSIHJa5I3PTuaJ/EeafDJdVRTOe6d7Zt3X0k+Fnc1rttec/awlMgVbyI18R9AOoh+qYscSQTen4KKIiNX13nxcwcfR4Ic1AZrru0lXJDhDMNkq5Hshc/k5EjpJRXEo7Sq
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2890.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(346002)(376002)(366004)(396003)(136003)(66556008)(66476007)(66946007)(71200400001)(83380400001)(478600001)(66446008)(26005)(64756008)(186003)(53546011)(5660300002)(33656002)(55016002)(7696005)(76116006)(8936002)(86362001)(6636002)(8676002)(9686003)(316002)(110136005)(6506007)(2906002)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: bMWwM1wu7StROu2JAPffLtlrmsv725a/i81g9p4EDPuvsbXCjJQzGCD4HwvWOrnppOTAv8WuMbmZVaKjGlp/qz3nDQ3my6eccANqzDD+S9F/woV3J3VgS6zqMVgF45f13M8a6nppiqMjbLipozyTTVvLHXgECFBFNZaHILKo+FrSrc/AAUJjJ9oWsG0MEjqY3mgzLgcA+DHsGaxAjxBunfM2aF3qt3IV2DzupfL0lYkUILWM4h1NqSNWPq15UiSqU/C6W5rCgeHODrbXlVLnzBt2hnHi4Z5jWvOUFrNi+5Ea+mY+hRvUx0ma3OJUOnE6FK9w/D48+leNne4W0hjHbnVn88kR472gGxtKSzg52m8SUOL0+Erue6MH/blPTEakTRV0c+JGO2cT6ucbPyzPmaoB06ZvMmyMgUA/0k7YTYMZAHy58e3SbGUC2W/tAAzLJe2P2xLazkLRHyPn4K0deFbKeNpjHzUwsLsNYG4VTTLakjow6nJq1D54f41PSMIs
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2890.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a02842b5-b90e-48f4-2420-08d833360ff9
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jul 2020 20:37:36.1402
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DK6nVgWnkFB90OFc8RrkKp6MwoM5neakvRTIvaZ2qsvf1hbaV3z6fIlsLFMFgKS2JvnYdaQHyA7nVmpwvvmQEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4377
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Francesco Ruggeri
> Sent: Thursday, July 2, 2020 3:39 PM
> To: linux-kernel@vger.kernel.org; netdev@vger.kernel.org; intel-wired-
> lan@lists.osuosl.org; kuba@kernel.org; davem@davemloft.net; Kirsher, Jeff=
rey
> T <jeffrey.t.kirsher@intel.com>; fruggeri@arista.com
> Subject: [Intel-wired-lan] [PATCH v2] igb: reinit_locked() should be call=
ed with
> rtnl_lock
>=20
> We observed two panics involving races with igb_reset_task.
> The first panic is caused by this race condition:
>=20
> 	kworker			reboot -f
>=20
> 	igb_reset_task
> 	igb_reinit_locked
> 	igb_down
> 	napi_synchronize
> 				__igb_shutdown
> 				igb_clear_interrupt_scheme
> 				igb_free_q_vectors
> 				igb_free_q_vector
> 				adapter->q_vector[v_idx] =3D NULL;
> 	napi_disable
> 	Panics trying to access
> 	adapter->q_vector[v_idx].napi_state
>=20
> The second panic (a divide error) is caused by this race:
>=20
> kworker		reboot -f	tx packet
>=20
> igb_reset_task
> 		__igb_shutdown
> 		rtnl_lock()
> 		...
> 		igb_clear_interrupt_scheme
> 		igb_free_q_vectors
> 		adapter->num_tx_queues =3D 0
> 		...
> 		rtnl_unlock()
> rtnl_lock()
> igb_reinit_locked
> igb_down
> igb_up
> netif_tx_start_all_queues
> 				dev_hard_start_xmit
> 				igb_xmit_frame
> 				igb_tx_queue_mapping
> 				Panics on
> 				r_idx % adapter->num_tx_queues
>=20
> This commit applies to igb_reset_task the same changes that
> were applied to ixgbe in commit 2f90b8657ec9 ("ixgbe: this patch
> adds support for DCB to the kernel and ixgbe driver"),
> commit 8f4c5c9fb87a ("ixgbe: reinit_locked() should be called with
> rtnl_lock") and commit 88adce4ea8f9 ("ixgbe: fix possible race in
> reset subtask").
>=20
> v2: add fix for second race condition above.
>=20
> Signed-off-by: Francesco Ruggeri <fruggeri@arista.com>
>=20
> ---
>  drivers/net/ethernet/intel/igb/igb_main.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
