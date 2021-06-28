Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 600463B5A22
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 09:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232401AbhF1H47 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 03:56:59 -0400
Received: from mga01.intel.com ([192.55.52.88]:10572 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231725AbhF1H46 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Jun 2021 03:56:58 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10028"; a="229521737"
X-IronPort-AV: E=Sophos;i="5.83,305,1616482800"; 
   d="scan'208";a="229521737"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2021 00:54:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,305,1616482800"; 
   d="scan'208";a="557480093"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by orsmga004.jf.intel.com with ESMTP; 28 Jun 2021 00:54:17 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Mon, 28 Jun 2021 00:54:17 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Mon, 28 Jun 2021 00:54:17 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.46) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Mon, 28 Jun 2021 00:54:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=InTOTMLmV75VA8S8nBVOo2G5Tj7bsOuPcn8q0fhQ2fHeN+zRV5IF5DFsFN3Tog1SfSXvRXByCbTriQTF3VokgCDVsFoQzq2nTwTeL22yQqTti1+raVej9ShQf6A7gToyLGCXvkcXEU2hxiOTZWE847+fwSwWYlOuY25m6zMuThScSQbcjfD3YsDRhRhG60FEaWu8h7zMJ5SJIUcatzhP6+HFNpbtrVnQstfUPQ8CUtPBOpha3pK0FjNKA7C7TrC1ZDgmSP7x1qBzKLbpvDcCrl4kgYcpYBAMUqF43309jXY99Zo10XShQ62MwCPOaSyKFP9xNifFJAA9pL6ibu4OpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=81JVFUHjyloEyZ2Mwl/YMQxLYnONDqyrLU7rd5H56Hk=;
 b=Trxx3sWLbK12xuu8EMmahYFBTFSPPIMxGuuVgqmvmfyxfq/wKCAPAYvP88IICUxI4Tz0GIfYkzMNTaA3BrRN9W5yY5RFuf+Y8g52I2JfVQO6y5Oz9xv5HOGEvhzWiqpCorM5NejhQd0uIv9MkVFaMX80G5shZ6lHh1QVxyelv6vv19EPaesUkjhlgV5E62d6Wp6FmkVO/FLsR6j61kpMPDOIvivdRJDJxQ+bT2STrm/+DpsYDMSqDril+0wxnzE0YD2Cyg9Fu0DvVifdX7QpJ3cJ0vU16btlGFE9JbLodMhynfbhf/sejP4LqlXdKIhw1jCHKXFjXdnQAouyh+EvCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=81JVFUHjyloEyZ2Mwl/YMQxLYnONDqyrLU7rd5H56Hk=;
 b=LJmH9cFZKke2c7LIOvM0x4zyktZGfkbVybvQDI6yJcCvlD8765XDqcWlCnEE3PO/yjRxnu0ji//108jGfBWNZhFdP/Nfy3rtdTPJdi/aU0d25uA2Tci249dYLD4RP3PHx5KVMHsax6IF0Aec8urz6zQJc82gahuuuWTgBellk+Q=
Received: from CH0PR11MB5380.namprd11.prod.outlook.com (2603:10b6:610:bb::5)
 by CH2PR11MB4472.namprd11.prod.outlook.com (2603:10b6:610:49::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.20; Mon, 28 Jun
 2021 07:54:14 +0000
Received: from CH0PR11MB5380.namprd11.prod.outlook.com
 ([fe80::d52:3043:fef4:ebcd]) by CH0PR11MB5380.namprd11.prod.outlook.com
 ([fe80::d52:3043:fef4:ebcd%4]) with mapi id 15.20.4264.026; Mon, 28 Jun 2021
 07:54:14 +0000
From:   "Voon, Weifeng" <weifeng.voon@intel.com>
To:     Russell King <linux@armlinux.org.uk>
CC:     Andrew Lunn <andrew@lunn.ch>,
        "Ling, Pei Lee" <pei.lee.ling@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Maxime Coquelin" <mcoquelin.stm32@gmail.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        "Wong, Vee Khee" <vee.khee.wong@intel.com>,
        "Tan, Tee Min" <tee.min.tan@intel.com>,
        "Sit, Michael Wei Hong" <michael.wei.hong.sit@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next V1 3/4] net: stmmac: Reconfigure the PHY WOL
 settings in stmmac_resume()
Thread-Topic: [PATCH net-next V1 3/4] net: stmmac: Reconfigure the PHY WOL
 settings in stmmac_resume()
Thread-Index: AQHXZoJFBtZ0uXgSn0S7qboFjm+Joqseb0UAgALh+bCAAK/dgIAA5rbAgABIGwCAAagL0IAAHuMAgAQZSbA=
Date:   Mon, 28 Jun 2021 07:54:14 +0000
Message-ID: <CH0PR11MB538027559DDF40B3AC322FE288039@CH0PR11MB5380.namprd11.prod.outlook.com>
References: <20210621094536.387442-1-pei.lee.ling@intel.com>
 <20210621094536.387442-4-pei.lee.ling@intel.com> <YNCOqGCDgSOy/yTP@lunn.ch>
 <CH0PR11MB53806E2DC74B2B9BE8F84D7088089@CH0PR11MB5380.namprd11.prod.outlook.com>
 <YNONPZAfmdyBMoL5@lunn.ch>
 <CH0PR11MB538084AFEA548F4B453C624F88079@CH0PR11MB5380.namprd11.prod.outlook.com>
 <YNSLQpNsNhLkK8an@lunn.ch>
 <CH0PR11MB53806D16AF301F16A298C70C88069@CH0PR11MB5380.namprd11.prod.outlook.com>
 <20210625164834.GY22278@shell.armlinux.org.uk>
In-Reply-To: <20210625164834.GY22278@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none header.from=intel.com;
x-originating-ip: [161.142.208.90]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3e9a922c-42db-4485-2e8d-08d93a09ec94
x-ms-traffictypediagnostic: CH2PR11MB4472:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH2PR11MB4472D7BFDF2F667F455E83D688039@CH2PR11MB4472.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tBunHTdWULOK+D1vaOwrb/0yka0czxthTIcTuO9TdyV+DFDMMH9SuL9dxWHXgZdL8ZWygC72yLTVXZPd8YbWq0LSS4gNRiEaRgVr8QCLz1uX9uewFxlRvDuno40C51bTkgxWc7WTTDpqdKDJwwO7UawbonkwMs+Dzl+PeY1AAuRs3HEdroS8okAhjh/ZYxJHWqD5Z0I1NjaMu1O0q1UkGz4HJwMbMMdvDDdvH1fzPvsdQ79JGcHlPjHiFMNvdSCu1Imard9iLX8OQlBESCtNw5JPVeotFd+EJBIzy/CAgQplhBfr8SUWt+MRgGPm8dkozMAxG72lOIg5CNuQw6eS/j+9anbT1Z4aFl+WTdMHRrtsZ8XVrBDfDBJmee4W8smEaiAN8wWyYRVAnNJXrqbLTCYIrHcJcsUBp7tJ8Y6BAky3GSYVl8qyWRRljR5ckjT/QCOwwvD7nq7BtbqJ/vGsw1qenJlvRmatSNk2n0jBl0OSlb3DbLtlA9gUu0GaCsiHWxPFlyyjVNyBFzKmnUZpkqfmI8lBZKCAXBZYWKdbKhVUDlYG4/soRlTrXCwwZ0xMM5FcZ5gk98BaWnp4l0EuCwEc9YJm5eLAZ2T6OI5qlYE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5380.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(376002)(136003)(366004)(346002)(186003)(8676002)(83380400001)(86362001)(5660300002)(54906003)(9686003)(33656002)(55016002)(7416002)(6916009)(66476007)(71200400001)(6506007)(52536014)(66446008)(64756008)(66556008)(26005)(66946007)(8936002)(478600001)(4326008)(2906002)(122000001)(38100700002)(316002)(7696005)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Scs+9Vttx0usQitsHPlmCaixxtXOaSms6cwaGDkzi7uH/DUParMdNA5xloFO?=
 =?us-ascii?Q?zo9jWjlEKRyXF8DmI2apqms+BdpLZcakd/hG4LQR7dM44La6zxEqa0kLwXJZ?=
 =?us-ascii?Q?T0tWDAP28CCfmja4c2lUszfWINa7xGtB8WMdOOMioCChznZApxHh4/IyXphh?=
 =?us-ascii?Q?aV1bz+5s9UWroTlfsq+ejeiNhYTa1zxAjBS3vATTKcvK6QL6mJAedJJVw01a?=
 =?us-ascii?Q?zNDihjk0HFT7VnB2BAIHHTzoLdhz0Cwx/30b8AY8n3qAHtHSOoKqFczS7GlY?=
 =?us-ascii?Q?Auz66QSUCbjhJNPp9niIm6WnVoJGQxCWdXSx8oz8vRE3dlRT4+1ih/YSOIHj?=
 =?us-ascii?Q?dsOorR9wDI3+Z9S3ZqhZdycu8Zg+FOKvVR2IbjFvgnLb3rrshdFepNXZajNm?=
 =?us-ascii?Q?jJR0rMxAeiOF5/u3ZJrWslSPvMYT5cDNBmm23NlquV2wIHGDyxe284G0Q3y5?=
 =?us-ascii?Q?MWjAbtmI5OtLlMYCIFWtvlAAkh0t5zf23eQWgij2D4M3GEIMngaH1TpmaZ/A?=
 =?us-ascii?Q?UPjRc1Pd3Xd0DZ6n8+R6zU8xFizQbOplOWSP0XKpIE6cdQA+GLQ+tf8EcyH7?=
 =?us-ascii?Q?gYIXNaGm23NqQ/r3OWYDbF+E4Z8kHnpZgS30HGDc35s30Z2dqsLAXQ8G7p6h?=
 =?us-ascii?Q?TPSfTvpGIRiQENGuDcriAvdg68jjSWCz63B2nSo61TBkHT6OkrjnCKKmEOeY?=
 =?us-ascii?Q?UxF4kRRA3mm7PwCZDFDgJZcYL7RhU1SWMrkSx5sU6Qo5t7fk8xva+wRk5/D7?=
 =?us-ascii?Q?VuFslHJFTI4D4e/LFOdF4V7g8/2Y+5NW55mW42/UsG97QCnMAPT+MpUZtGFx?=
 =?us-ascii?Q?D5HfdrFrfMFYSw+wGcBpY4SSE8iqCu36ZusPMbfa1D9gqBoaC1DUch4CJCPO?=
 =?us-ascii?Q?XFyt8f1f+JY8IGWzff4mUiH1HSAvhpe/cIUrxDcVKoAmlJ6kMbfYdejps54r?=
 =?us-ascii?Q?QlCodQ5gNAMUhulnL2Va7ky8rznUcDnI65T6t6eLIjm8pP7XIDYBYuuKRySD?=
 =?us-ascii?Q?Zwl2td08pEPksgtXyqVVAoafscdA9ALfrKPDfJlGWBf/tavS5OxIEceq/14g?=
 =?us-ascii?Q?+BuBdhocbvmrhtx4SfZX9pW0nXJVoqIC1akoTn8nx20+I+YMLRRAZXyVkuEp?=
 =?us-ascii?Q?NYVYushzMnwY8BMghI9IakGj3MI9aEBcfnh7JTJFFgp9GtlGtVExvbI73koG?=
 =?us-ascii?Q?UCEClKxfJqazD+QKtpfwgPLlDwXX74TYVO7nOYL1YIJ/Aauzr7JjYNzuKYNS?=
 =?us-ascii?Q?EBefHkW747+R03g/DFRLgz6zbGKrkFzBk3Z0D54XuX0AEYt49G95VPurLN8r?=
 =?us-ascii?Q?FaPsA2ghrFfr5+mg5OVu98dD?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5380.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e9a922c-42db-4485-2e8d-08d93a09ec94
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2021 07:54:14.6353
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0lvQd89vQovFTjMcS0Uzc7uYlWsxWG4xA8QczRdvOZxLSCurpw3817dn6mkS0mq28MaFAdi93/hIMJnIU/PZlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR11MB4472
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > > No, the interrupt will not be discarded. If the PHY is in
> > > > interrupt mode, the interrupt handler will triggers and ISR will
> > > > clear the WOL
> > > status bit.
> > > > The condition here is when the PHY is in polling mode, the PHY
> > > > driver does not have any other mechanism to clear the WOL interrupt
> status bit.
> > > > Hence, we need to go through the PHY set_wol() again.
> > >
> > > I would say you have a broken setup. If you are explicitly using the
> > > interrupt as a wakeup source, you need to be servicing the
> > > interrupt. You cannot use polled mode.
> >
> > Sorry for the confusion. But I would like to clarify the I should use
> > the term of "WOL event status" rather than "WOL interrupt status".
> > For interrupt mode, clearing the "WOL interrupt status" register will
> > auto clear the "WOL event status".
> > For polling mode, the phy driver can manually clear the "WOL event
> > status" by setting 1 to "Clear WOL Status" bit.
>=20
> If WOL raises an interrupt signal from the PHY, but the PHY interrupt
> signal is not wired, how does the wakeup happen? What is the PHY interrup=
t
> wired to?

The PHY WOL event signal is wired directly to the PMC. The PMC will detect=
=20
the triggered WOL event signal and wakeup the system.

Weifeng
