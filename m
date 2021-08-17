Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A3243EEA22
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 11:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239185AbhHQJmZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 05:42:25 -0400
Received: from mga03.intel.com ([134.134.136.65]:51886 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234593AbhHQJmY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Aug 2021 05:42:24 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10078"; a="216064541"
X-IronPort-AV: E=Sophos;i="5.84,328,1620716400"; 
   d="scan'208";a="216064541"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2021 02:41:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,328,1620716400"; 
   d="scan'208";a="676417550"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga006.fm.intel.com with ESMTP; 17 Aug 2021 02:41:50 -0700
Received: from fmsmsx605.amr.corp.intel.com (10.18.126.85) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Tue, 17 Aug 2021 02:41:50 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Tue, 17 Aug 2021 02:41:50 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.49) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Tue, 17 Aug 2021 02:41:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gTYB72Uk7EheqTKEPAenK2GlOsffc0kS8J3iGNLDlwHEk5QAbd0RlOf3HDEFbHGj55G431LQLBNW+xJ5HDbIhNhx2Av/CyPI2wFuoNXx7CeU5jHuJjvB8vOpliE7FWVgntLbIBYUiTrc8lENvzWAiJDmbM8MNYWIm6ScHtYOWJPpEquOwmWHdsPOYEW9vlo19wwNiuu3h6orlpxhYUWvvwKcVTe0EnfVJiBU48mhX1DtPMqwfzkgKHpjHyAzvwF0X8YgOWbMuBgTg0VssB9CKwzq6a5rPEWguY2vM/AYn3X77PtZt1uCAyQe2ZQcjuzqLEY7LbsYAMCLqXU/yGlqeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mloQqeISMyIi3QWpGOP+d1N/T7FomygTInDKv/whBzM=;
 b=H/aWJonkn0MqvvUhvfb2onI/Lfsldne9IeJcbjYb3ZwZbfhLU0RPtcdS1A3H7T19p8eRrtrNhEKu/FXYZlTdHK7POxMLm1v3KHLlUMQDpK1yEaCZ76cSNNbawenbzLNjSdZK5sPFWUMl/YdbqEocNbyqCWWI3e7IcriRYmKtrW9IzzZP/+zanxv9Vbx1iD0uob1wcT378m94F58fxDkiMg28InZcl6FHfyUlJx268ra17HL2QmZbnmNZtCg2VrXL98YtguHpRwe/PflEv7B/layqFnHlWKYqtX0WfSbZO4p/kGfTCJOYhiFYUoBuOin7FlAlzzhAqAohg9cYlZuqdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mloQqeISMyIi3QWpGOP+d1N/T7FomygTInDKv/whBzM=;
 b=B2AQ6j553jMX9c1KDrXVGT0SVYkT/O3ArS7LOi687xqbohf6awe2n7A1d6UH+NbrjoVXWTRpStgQpUJVCPnPWB5w6KL+uG+4CyPQ+JmU5jN/dFLoRuCXXAteI/SCor49YwuYZJ9ol64WzLSwR2UG7dChzxwVfwKK/evftmm/Ixw=
Received: from PH0PR11MB4951.namprd11.prod.outlook.com (2603:10b6:510:43::5)
 by PH0PR11MB4871.namprd11.prod.outlook.com (2603:10b6:510:30::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.18; Tue, 17 Aug
 2021 09:41:49 +0000
Received: from PH0PR11MB4951.namprd11.prod.outlook.com
 ([fe80::58cd:3e24:745c:e221]) by PH0PR11MB4951.namprd11.prod.outlook.com
 ([fe80::58cd:3e24:745c:e221%7]) with mapi id 15.20.4415.019; Tue, 17 Aug 2021
 09:41:49 +0000
From:   "Machnikowski, Maciej" <maciej.machnikowski@intel.com>
To:     Richard Cochran <richardcochran@gmail.com>,
        "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "nikolay@nvidia.com" <nikolay@nvidia.com>,
        "cong.wang@bytedance.com" <cong.wang@bytedance.com>,
        "colin.king@canonical.com" <colin.king@canonical.com>,
        "gustavoars@kernel.org" <gustavoars@kernel.org>
Subject: RE: [RFC net-next 1/7] ptp: Add interface for acquiring DPLL state
Thread-Topic: [RFC net-next 1/7] ptp: Add interface for acquiring DPLL state
Thread-Index: AQHXkrpDE4/97678+kqD5jc+QEB2qKt2zoSAgACcQzA=
Date:   Tue, 17 Aug 2021 09:41:49 +0000
Message-ID: <PH0PR11MB4951762ECB04D90D634E905DEAFE9@PH0PR11MB4951.namprd11.prod.outlook.com>
References: <20210816160717.31285-1-arkadiusz.kubalewski@intel.com>
 <20210816160717.31285-2-arkadiusz.kubalewski@intel.com>
 <20210816235400.GA24680@hoboy.vegasvil.org>
In-Reply-To: <20210816235400.GA24680@hoboy.vegasvil.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 775e8d8f-7768-4ec6-a7ef-08d961633c77
x-ms-traffictypediagnostic: PH0PR11MB4871:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR11MB48710B7098AC147EA4534602EAFE9@PH0PR11MB4871.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jdkq5WOFuSO05YlAosMAO2dsyoDzvxIWdoy/PU1vjTyEZ/w1JBg3fWtpOV0gnGRjT8SyhZ7ULf+muK0Kz6vKpn6mb0GPpoGfdFsWGZ7RWaZJexlALLjvr3RSRfmN3BUoMdJVq/O32tQwXORadZdEfV21xBuCQWWtmBrTEDbeO4aSj6cS2bYIqIc3Pl0XboCtBRvtwRPWwncTGH8FvxR/1uG5SUf2FrrrpDrhzHcPoHvdKUsw3JiemGQWCYdOriLCfniijAyE2/oFhN7b/jS4VQLm9EpkJ4zJN+7BPR//rGEwwA4HM/LtS/1I0peVIzxddXlBYkZ7lLplls7IXGNXTdSYulNDy5avEJB1XQ7DpD2dcYFJbxFw/iRDrXEfVNySbDzgq3as6sziVcAjF8BDs8qKe8xY+pxp0A0Hj63/kHxHimZk64DmJNVl6ynsESxVVlMxxpnwJmdgrUf5y3Snq81d/+fR6pk+ZVQzDrYKqJEt8P2WYSRydGeWe1bPt2m2Sw61KWz/D4rMmm1WckKtRNUNHxN+TExUtMcE+gBENlCRjKeGKwG0pE9/bh7VMy+qT2JzmaOVIP5XJBR9sEENPf7tXdqem35AJxFAlbBW6fcbqMRRWvdgkLoo2k2bSs1dGONoZqNZ3bgmvXUAHZhha7XDVE8W3ly7yUaK/MFKuAL8ohs6aiI6IIJ6Eeg+GD65+SyukZVFBdggJ3WLmHQ8BQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4951.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(346002)(376002)(396003)(39860400002)(26005)(6506007)(33656002)(86362001)(186003)(2906002)(316002)(71200400001)(38100700002)(122000001)(6636002)(7696005)(110136005)(54906003)(7416002)(478600001)(52536014)(5660300002)(38070700005)(9686003)(55016002)(66476007)(66946007)(76116006)(8936002)(8676002)(4326008)(64756008)(66556008)(66446008)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?co3Ul0emSzqiI8WIU5XfSUmyEoUjR/vzL5IznLJre1O0HUYYM2cbd+hTL460?=
 =?us-ascii?Q?T4XrHkXaVMQuhdOHAZ2B9lyf6y22EAu7r7suh7ApB4X4fHvGOizaEmToOgK0?=
 =?us-ascii?Q?yYf25c8kpSfQIsiCBvF7H4qlt9/tYY1BwFQZguC/6lc3DE/fUZbXtil7mi7H?=
 =?us-ascii?Q?dv/9snDkTQaLf40uLpaHHn6DnEuX904DZn/DmcIvzPjR2Pgd8EFQOI0tes8L?=
 =?us-ascii?Q?+6of/nQbWf6caAPokAAC+Ir00oy2+bKhN3YTdDkPKgXpPNRgoOGp3sf10S0s?=
 =?us-ascii?Q?5hNOgzLvAbwcafIn6VZPZva4AgkDMDwYxokQ91laiFc89ljsQ9LXkXk2IZj1?=
 =?us-ascii?Q?ieY/wn4xzyhi/xYeQtUnmnJ2p+TnMpBVvbpOQhny7dbe4gTF7ZaACsxfT7Z0?=
 =?us-ascii?Q?xYblL7rF641jks3PA7EBt8+soDRWLjJd1Dt+iLUXW5eXtcrYtAa4B34WM/d3?=
 =?us-ascii?Q?hMAq0BKgBzf1twZl54lbL0XyCMCvhsUrJX4yGF9/qbaIh5W8VphxB81u/JG4?=
 =?us-ascii?Q?IkgWM18dAe1HU+Yx1k1a9ouHw13vyN9f3p/acQHREG6nUzgUuDStGTSsD1kr?=
 =?us-ascii?Q?tPC3zVfAINkWPQJbdL3CK0fL1u9U5bUQ9EOkVt9hTRiJopKFFnr7oKm+fpmI?=
 =?us-ascii?Q?gp+mfTAHGKByKPcWt9ILUg4iWK0qfA9CLkTw+M12QDI+J6rNFsddV7Zivc4m?=
 =?us-ascii?Q?SRjpyz+BO5bkkGy1+l6bYd0V8XzIfXV1kPX60RMjYmcv/h96pJuBcedJ5V+w?=
 =?us-ascii?Q?je8xHFH3DwZivniABexKngPQWKWDLroh9ty6SD6zU135S9/TUh93slaW2tUp?=
 =?us-ascii?Q?Yw6s5tFKtLgbRzCoLfGAtbZnLWMsvHD2LV7wSW01D40tJWEnqNh+dniBeGok?=
 =?us-ascii?Q?i8gAj6jf/zX1Evn0duX0q/OAu7iFntqop9x1amixdIIteUbpUyqU9UxmuGdO?=
 =?us-ascii?Q?NYmosfeqqO/42QHR6jISHosA+YvulCFwZwwV/EpqKBuBkcVGCTOUZ+ZEoA42?=
 =?us-ascii?Q?5dMO3CEdcZn6Hn+807/vckB/JYu2G+YrZ6uTrmV0T3zcLyicrBfkQpX0dOkW?=
 =?us-ascii?Q?iB+BrjZSn++ncuHnwKvkdk19MqRqYuHkRxC0f/MdSfbQSOujVXtGEQwZnDp6?=
 =?us-ascii?Q?5/VyOjzPM360AJncjyhNmWVCRnRHejKpyhJAQhcJrFN7oiA2Mlhuk2yZKqUK?=
 =?us-ascii?Q?DTNKmRy01XbQxVXZrbqLaScgzt6cb5EHvUzZyei/IjlhxezFnv64Tuy2AoqS?=
 =?us-ascii?Q?PFiM6MrkOrh+ZvfV/lDhvymzHTj+h/m4/xT2O+HLRLjK2JwpOxmJW65I1iYC?=
 =?us-ascii?Q?qFU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4951.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 775e8d8f-7768-4ec6-a7ef-08d961633c77
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Aug 2021 09:41:49.2741
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9qevwDose/OFCQCgZYxCCCos4yyQJ6YHOiiajYigJ55V07YDimPgikSeQbVhPmxq51wGzEp5NgEGVUe2fKMqlpC5iImwX/9wyZELY/LXV1U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4871
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Previously there was no common interface for monitoring
> > synchronization state of Digital Phase Locked Loop.
> >
> > Add interface through PTP ioctl subsystem for tools, as well as sysfs
> > human-friendly part of the interface.
> >
> > enum dpll_state moved to uapi definition, it is required to have
> > common definition of DPLL states in uapi.
>=20
> This has nothing to do with PTP, right?
>=20
> So why isn't it a RTNL feature instead?
>=20
> Thanks,
> Richard


The logic behind adding the DPLL state to the PTP subsystem is that SyncE D=
PLL on Network adapters, in most cases, drive the PTP timer.
Having access to it in the PTP subsystem is beneficial, as Telco standards,=
 like G.8275.1/2, require a different behavior depending on the SyncE avail=
ability and state.
Multiport adapters use a single PLL to drive all ports. If we add the PLL i=
nterface to the PTP device - a tool that would implement support for Telco =
standards would have a single source of information about the presence and =
state of physical sync.

Moreover, it'll open the path for implementing PLL state-aware ext_ts that =
would generate events only when the PLL device is locked to the incoming si=
gnals improving the quality of external TS events. I.e. an external PLL can=
 be used to monitor incoming 1PPS signal and disable event generation when =
its frequency drifts off 1Hz by preset margins.
=20
If we bind it to the Network port, a tool would need to find the port that =
owns the PLL and read the state from a different place, which sounds subopt=
imal. Additionally we'll lose ability to rely on external HW to monitor ext=
ernal TS events.
=20
Regards
Maciek
