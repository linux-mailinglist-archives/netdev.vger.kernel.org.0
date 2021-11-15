Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6C3C450224
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 11:12:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237647AbhKOKPm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 05:15:42 -0500
Received: from mga09.intel.com ([134.134.136.24]:7040 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237323AbhKOKPZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 05:15:25 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10168"; a="233253292"
X-IronPort-AV: E=Sophos;i="5.87,236,1631602800"; 
   d="scan'208";a="233253292"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2021 02:12:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,236,1631602800"; 
   d="scan'208";a="535459558"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga001.jf.intel.com with ESMTP; 15 Nov 2021 02:12:27 -0800
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Mon, 15 Nov 2021 02:12:26 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Mon, 15 Nov 2021 02:12:26 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Mon, 15 Nov 2021 02:12:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bNLvW6URAAIG8/k4fYRuLiuUutoW2Le/xasL86zmkkzQUhLjHId+rQTC3EiKWA7sMqyJgURCSl/SMbUYXwG2u2jS9OAxkO/SzvDGCoO+vkvjdzpPONFjMVj6EmsbU9nQQzd8g49OWLmUDuuYbFtxnaMkM7+zGoI6qXHsFREkzMnHrRGXB8uB2seTlwDPbACt1+HkrtR14fv0n+cdWIl6sUXYM3kXb92DftypmE1qHaQHL9zYEmQuQE4IAyIB96ro6gpQXK3LVnTCDy5RnXbLokw7dD5vT8anIHCqTG2bIm6sdQpvB9+2zFXmcgSDlVAchNFT9JWQqbZw5TU6xtweyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kdZnU1GXlahdS7/ohujjFzM1mUv8tcACB0c6uH7JwfM=;
 b=Nx/ltfCFgcfVcFHjvA3m2iTXyVXmI4nhirA7p+GHn/hupefRSe1Xd2lMZzjEyHMVevvZG2AH3JtlnSOzPZooR5UQgBEIY2QT5JhrIrIAq/Xhp7hub+h4Hk8tZhGhgWugcHDMttK/qJhSb2UR2o5bwEv432t7DEdGmjKuoIo3uM2BQUED5kWzufMNf1WfwkVH3yb+aiXJZrBnawsU5DClxN46Faai0whClXrg+KuUIbj35aTLIlsnCwpN7z63Pi6vdGiqeV4kaYbFeDtk2lbzDfnjUgDoMWfbrAWpsMIQ45GM+PzqLo+vUKXfRvgB96tiofNE6WkhnrE20211qmtu/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kdZnU1GXlahdS7/ohujjFzM1mUv8tcACB0c6uH7JwfM=;
 b=nkYs4H8texbzJUwDezgpa1zI9gqTHPeW4U/BEGUIMpSLpj8BJzPziHiRlLoRxvGmCaAxqlUFsW5A03ypbGQ7Z9mZzLUJgNpnZeNgeyuYFMoSBHGMqsT9dUA0xUphq/9RQl9n9M2iv5tRRVlpLeB8LlbE6XqTNWzdVoYJNstS0XM=
Received: from MW5PR11MB5812.namprd11.prod.outlook.com (2603:10b6:303:193::14)
 by MW3PR11MB4619.namprd11.prod.outlook.com (2603:10b6:303:5b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.19; Mon, 15 Nov
 2021 10:12:25 +0000
Received: from MW5PR11MB5812.namprd11.prod.outlook.com
 ([fe80::1127:5635:26df:eca9]) by MW5PR11MB5812.namprd11.prod.outlook.com
 ([fe80::1127:5635:26df:eca9%7]) with mapi id 15.20.4690.027; Mon, 15 Nov 2021
 10:12:25 +0000
From:   "Machnikowski, Maciej" <maciej.machnikowski@intel.com>
To:     Petr Machata <petrm@nvidia.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "abyagowi@fb.com" <abyagowi@fb.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "idosch@idosch.org" <idosch@idosch.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "saeed@kernel.org" <saeed@kernel.org>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>
Subject: RE: [PATCH v2 net-next 6/6] docs: net: Add description of SyncE
 interfaces
Thread-Topic: [PATCH v2 net-next 6/6] docs: net: Add description of SyncE
 interfaces
Thread-Index: AQHX0oli6labJUcox0OLXoT9uSo8Gqv57+iAgAEU4LCAAEj/gIAAAf9ggAFGKoCAAAPsIIAATJIAgAACLYCAAF/RAIAHHWvg
Date:   Mon, 15 Nov 2021 10:12:25 +0000
Message-ID: <MW5PR11MB58121DC2755B9AADA3516E75EA989@MW5PR11MB5812.namprd11.prod.outlook.com>
References: <20211105205331.2024623-1-maciej.machnikowski@intel.com>
 <20211105205331.2024623-7-maciej.machnikowski@intel.com>
 <87r1bqcyto.fsf@nvidia.com>
 <MW5PR11MB5812B0A4E6227C6896AC12B5EA929@MW5PR11MB5812.namprd11.prod.outlook.com>
 <87mtmdcrf2.fsf@nvidia.com>
 <MW5PR11MB5812D4A8419C37FE9C890D3AEA929@MW5PR11MB5812.namprd11.prod.outlook.com>
 <87bl2scnly.fsf@nvidia.com>
 <MW5PR11MB5812034EA5FC331FA5A2D37CEA939@MW5PR11MB5812.namprd11.prod.outlook.com>
 <874k8kca9t.fsf@nvidia.com>
 <MW5PR11MB5812757CFF0ACED1D9CFC5A2EA939@MW5PR11MB5812.namprd11.prod.outlook.com>
 <87y25vbu19.fsf@nvidia.com>
In-Reply-To: <87y25vbu19.fsf@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5f535ee6-d533-442e-5cb1-08d9a8206bf9
x-ms-traffictypediagnostic: MW3PR11MB4619:
x-microsoft-antispam-prvs: <MW3PR11MB461927244C44091DF2DEE09EEA989@MW3PR11MB4619.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: krq0O/fF0oKl7v8OmGMCU/kq4DDgxKj2jmPRBcBpFTlMqOQBGYrfRr/mgmE6eLqIbmkU8awLBPOBCofOKHxaJX7xBlEwSxSWPXIvlVSj+VMVySzQQ13JYBZMG1CIaNIDzsOd7xgV9PTS3Upo6AzNOGz+Wt6IWLzIeMX6opbP0VrGrSyFXiF+fXYUAoaeA8pUH3MfP5y7bBmCI/AvX0OcieVpwhATqUcO4Ned5TDVHBZ0sSxgN42QkaZIQtwLOzabUekUpkT8Rs/PyXo0in4FCOuYM0RptZ118gMT07xgYtnGYtUCZdFg4X2iPiD0jF/ZXpnl2d07+m5GG0GYJJeHRc7A+y/OFDR2SsThBaQYUfTdGu6fHoU6CqgFzUW0jbFxhwEfLRji6QsksOd6TQJy4I9o3Efwrwj+cvkyF1iBWMsEf0PNb2Nf9g0pKBJ7omsbHm2lkSfX4r7Tpz7VfugEhsqrPGgRONViXWvTK6sMr+tSsrcy1A0NBKBw5zzs3LbJUiId1B6QuGE+N+obgqDnFax8ParFNFprsf90SfSTB+TZUIM0yoapi7aeKotjjBW2oO3S1D32dqDOvCgjY4ADnJtxB0sHwIlsXILk+OPkRJmIBycORVNpyVL3YbgLRdF/vRflzA0vB7nHP2NhUWZKnhrASq9lzo4PRP5p/tSKg7JTv3PsxVxgrPsxL0CiXVottJU2xE46zWBY2NpQkZVysA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR11MB5812.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(38070700005)(26005)(66946007)(7696005)(7416002)(6506007)(8676002)(76116006)(6916009)(316002)(54906003)(4326008)(508600001)(53546011)(8936002)(33656002)(9686003)(55016002)(86362001)(71200400001)(186003)(66446008)(66476007)(83380400001)(82960400001)(122000001)(38100700002)(64756008)(5660300002)(66556008)(52536014)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?dXTYRMYE7q/wybLUJflPz3EdESvI3Y4SrPjBI2b8WcenjAdwflrWX3J6+H3F?=
 =?us-ascii?Q?ou2XrWwwAxj3lNHphT8I4EMSZe+sNW55EvGfXDDYISggikyoHqxp4HEhKsfW?=
 =?us-ascii?Q?821sHnRu+H9wIlYmsPy/aGQTeLXgDtl2o4WuBRkshss6mGVWcieN8dP9qgjS?=
 =?us-ascii?Q?qMoxSzWaAeJkUEGkLSb3UJGrd6B47IxbaPDRtg53HCCXOeRwxfsK6ItaAbht?=
 =?us-ascii?Q?ZfKCiFk39OfX68KM0mJJsGRPYhrA8/WnFJ10z6UzhRIuHF5yp3f7l2Yye05N?=
 =?us-ascii?Q?IFlYsaXuobNbn1Wf2IE58Wr/m+L9YvMfCjciSCkQbogYw1lCXa6DXCQVm6F2?=
 =?us-ascii?Q?uGRA6kPWybrnTpBHuYGtVVwt5WqPdQYZKrA5SIoWpcKEBYXvPuBH8Q416EI8?=
 =?us-ascii?Q?htaNDU0CyQxJ+MuKjygP1/0sD8h17WA7R/4y4ZS//zo/pYVIxtoNCBb3MaTf?=
 =?us-ascii?Q?ec5Pemga6rSXFTMFMbtrCLXI/kWqgjTFNcqoHn++rt60L5XPEfUPNHyOX/qN?=
 =?us-ascii?Q?k1JwgKN0SYhKOip3vcoE5Dw5hwrhw6lQFRX8HXMgKqNISvPqs37GWeny9bYS?=
 =?us-ascii?Q?IYsmtfy008EssDiDazOqchi4bswmcOY64q4U3D5AGZhfqiiCLJHOKG2rvSFg?=
 =?us-ascii?Q?EH9baTrj6nzzwDTZCI5OZjUQhQM7SKE9zeURIgidHHhS6AxX15J/huuZMuM9?=
 =?us-ascii?Q?v8sXpcROXvH8AfFPSCbCYTfyCXVFbFoNVJune2X+4qIjFy6C/JzMl8PqMfMW?=
 =?us-ascii?Q?lFTu2ez52FHntWVqCuJN4XKfukpARKMmBix1vA/8z/sSTrgt1snfTD04LDn7?=
 =?us-ascii?Q?z5wILwB+L/3O0FD6NHpxHo8GUeyf5BejEexnMkyujGzWfVtCtL3volFDXk6d?=
 =?us-ascii?Q?bzuhpBwGBiNWsz9TVbxLn8ds0vY9FfcJ3iJRNCmfUiyrCV6OFQgpraYOP3nD?=
 =?us-ascii?Q?ZzRqfF3pOOOACQy2udPWb6M7FhKglFEaZmHp2zI8Lz3O10EMyL3MXmm5XZDU?=
 =?us-ascii?Q?h/LJSupAgABH09cK5T4POBIbxYf9zJDAgckhGAQKkYF6YEixX6OlMdmJs1uX?=
 =?us-ascii?Q?Qe8j/hHA5mybcGg/9s9OlQ7D2o/lt7nEz26tpunuMprixpabuLvW31P0m4HV?=
 =?us-ascii?Q?R2gGrHjO2vA8gWr64kZ67tFOSHjvrfUKUWjSbvtN26oEu1/eWuIRmFnKR66F?=
 =?us-ascii?Q?+5roSeJ8Nwktwn8HDfZf08fu/6PpnFr7qJMvyWIpYNPc5p4XEJDJcOkR4DqM?=
 =?us-ascii?Q?RoMGgCumemvS6JRmER9INpvFlkzAc8D5zcVsg1xSZTq7XHVHebiea4gyh4BC?=
 =?us-ascii?Q?kqmXXS+7pwZjKIlutBvGlOEphN7srNrUO48KN/tjr/VivA05dNO/OsExDpXR?=
 =?us-ascii?Q?Q8KgX4y63OZolj7U6m1x3dRnKlCu469lY78+DC3qMHG5PrIbQEwwal7cdmoD?=
 =?us-ascii?Q?AGdQ7rSJSvkXmU7cKWL5+o/arNOA7ABwuLaBinpJGAvuh8u4vEgrwObYHaa7?=
 =?us-ascii?Q?r8BUCe+RJcRnHcVKjOw8aX6JI5dE66oFPkkbyQOGhk9mwQxFCZ6itgffslgd?=
 =?us-ascii?Q?KW6sRYew+IGFlEPkv9BtyAXUviMWfENHPg7FLwSFneWBSH8zvarCM7jv3FE9?=
 =?us-ascii?Q?2q/Q8OIZjRXvDxBiR6T2nOpcDZPCzmBHOMr+Es4Av1O76M9gvVN15YnhkHL0?=
 =?us-ascii?Q?Hs2sJQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR11MB5812.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f535ee6-d533-442e-5cb1-08d9a8206bf9
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Nov 2021 10:12:25.2624
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iNbN+IQ/LH5FfTwrb1SA926Dm6cWBIElPT7aoKvvdyDOfqFGePQhhTfLMSaFa4fXmXOoSx/NsWjoct28KMHmjKRt+/jHFmAjUjZmTKvPB6Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4619
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Petr Machata <petrm@nvidia.com>
> Sent: Wednesday, November 10, 2021 10:06 PM
> To: Machnikowski, Maciej <maciej.machnikowski@intel.com>
> Cc: Petr Machata <petrm@nvidia.com>; netdev@vger.kernel.org; intel-
> wired-lan@lists.osuosl.org; richardcochran@gmail.com; abyagowi@fb.com;
> Nguyen, Anthony L <anthony.l.nguyen@intel.com>; davem@davemloft.net;
> kuba@kernel.org; linux-kselftest@vger.kernel.org; idosch@idosch.org;
> mkubecek@suse.cz; saeed@kernel.org; michael.chan@broadcom.com
> Subject: Re: [PATCH v2 net-next 6/6] docs: net: Add description of SyncE
> interfaces
>=20
>=20
> Machnikowski, Maciej <maciej.machnikowski@intel.com> writes:
>=20
> >> >> Wait, so how do I do failover? Which of the set pins in primary and
> >> >> which is backup? Should the backup be sticky, i.e. do primary and
> backup
> >> >> switch roles after primary goes into holdover? It looks like there =
are a
> >> >> number of policy decisions that would be best served by a userspace
> >> >> tool.
> >> >
> >> > The clock priority is configured in the SEC/EEC/DPLL. Recovered cloc=
k API
> >> > only configures the redirections (aka. Which clocks will be availabl=
e to
> the
> >> > DPLL as references). In some DPLLs the fallback is automatic as long=
 as
> >> > secondary clock is available when the primary goes away. Userspace
> tool
> >> > can preconfigure that before the failure occurs.
> >>
> >> OK, I see. It looks like this priority list implies which pins need to
> >> be enabled. That makes the netdev interface redundant.
> >
> > Netdev owns the PHY, so it needs to enable/disable clock from a given
> > port/lane - other than that it's EECs task. Technically - those subsyst=
ems
> > are separate.
>=20
> So why is the UAPI conflating the two?

Because EEC can be a separate external device, but also can be integrated
inside the netdev. In the second case it makes more sense to just return
the state from a netdev=20
=20
> >> As a user, say I know the signal coming from swp1 is freqency-locked.
> >> How can I instruct the switch ASIC to propagate that signal to the oth=
er
> >> ports? Well, I go through swp2..swpN, and issue RTM_SETRCLKSTATE or
> >> whatever, with flags indicating I set up tracking, and pin number...
> >> what exactly? How do I know which pin carries clock recovered from
> swp1?
> >
> > You send the RTM_SETRCLKSTATE to the port that has the best reference
> > clock available.
> > If you want to know which pin carries the clock you simply send the
> > RTM_GETRCLKSTATE and it'll return the list of possible outputs with the
> flags
> > saying which of them are enabled (see the newer revision)
>=20
> As a user I would really prefer to have a pin reference reported
> somewhere at the netdev / phy / somewhere. Similarly to how a netdev can
> reference a PHC. But whatever, I won't split hairs over this, this is
> acutally one aspect that is easy to add later.

I believe the best way would be to use sysfs entry for that (and provide a =
basic
control using it as well). But first we need the UAPI defined.
=20
> >> >> > More advanced functionality will be grown organically, as I also =
have
> >> >> > a limited view of SyncE and am not expert on switches.
> >> >>
> >> >> We are growing it organically _right now_. I am strongly advocating=
 an
> >> >> organic growth in the direction of a first-class DPLL object.
> >> >
> >> > If it helps - I can separate the PHY RCLK control patches and leave =
EEC
> state
> >> > under review
> >>
> >> Not sure what you mean by that.
> >
> > Commit RTM_GETRCLKSTATE and RTM_SETRCLKSTATE now, wait with
> > RTM_GETEECSTATE  till we clarify further direction of the DPLL subsyste=
m
>=20
> It's not just state though. There is another oddity that I am not sure
> is intentional. The proposed UAPI allows me to set up fairly general
> frequency bridging. In a device with a bunch of ports, it would allow me
> to set up, say, swp1 to track RCLK from swp2, then swp3 from swp4, etc.
> But what will be the EEC state in that case?

Yes. GET/SET UAPI is exactly there to configure that bridging. All it does
is to set up the recovered frequency on physical frequency output pins
of the phy/integrated device. In case DPLL is embedded the pins may be=20
internal to the device and not exposed externally. It doesn't allow creatio=
n
of the tracking maps, as that's usually not a case in SyncE appliances.
In typical ones you recover the clock from a single port and then use that=
=20
clock on all other ports.
The EEC state will depend on the signal quality and the configuration.
When the clock is enabled and is valid the EEC will tune its internal frequ=
ency
and report locked/Locked HO Acquired state.

Can remove word STATE from name and change to RTM_{GET,SET}RCLK=20
if state is confusing there.

