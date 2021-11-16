Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DCFA45347F
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 15:41:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237670AbhKPOn4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 09:43:56 -0500
Received: from mga18.intel.com ([134.134.136.126]:6234 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237671AbhKPOnr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 09:43:47 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10169"; a="220589602"
X-IronPort-AV: E=Sophos;i="5.87,239,1631602800"; 
   d="scan'208";a="220589602"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2021 06:40:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,239,1631602800"; 
   d="scan'208";a="592708374"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by fmsmga002.fm.intel.com with ESMTP; 16 Nov 2021 06:40:49 -0800
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 16 Nov 2021 06:40:48 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 16 Nov 2021 06:40:48 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Tue, 16 Nov 2021 06:40:48 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.103)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Tue, 16 Nov 2021 06:40:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HoL4buNdsyVnHAPRQtlVVQ8rPVjV3Ai2GzDIaGkPiGF43XYBSS6Q0gBM4bxhQNJpxwdFQ4X/dI1C70QXxtXkn7o+eCUQNlmNsqROY9zVMWTqybTLPxPSec2u4WXR5yUZNHqlC2zSmisdLFXKAnlr674ziMRx/KDVV+DAPa4X80VmhsuRPZnbonOGWH+l6Xa6mwtu6NttPT2ufKneEdmUPAzNIlE2nxwYxA/A+dty1t0tGIZSxRbctDBWAzEVO6S7bEKrETelijbkMvLMbGF6rzs8ef28tAa/p6WmfyUxUgbHKF5hwF3cCFzPB/83K3Y6eLqMVwe+Loe76Pg/NE+fxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9pQccVerEaa90LKwQKGWZoVfYH3nVTjkyYwuRZ9LRrY=;
 b=AKd0XXhs7OJYV+CCXVW6oOyKnuHw2VBrQ1PfebGgBH7PTdlkEuugptCTVBxA/R2WqGA7CG94lpg0KWJ5cT1mf+EwS8Ua9x9udkfWmiiofY3xxpha7L4xTndMAvF1un4Aiqu4Hlx7uGD07NA0Cc5rRla66+Rn910U9bFNLRgFFzO+H/eeURSukb3dFdHh06KEcBHECj+IqY6e4H9Gp2o9C3NnGgeGrfvyvpNOfvjz7aRznJ/XJfkxMlNypFd46b99EhJrk+Pct+uDhLhdRqW/vVAhP4jbVoRJqIPpsUet0XzPzghc9IbFaZcWpEVCbWhOmw/jsv6ug23ju9kqwHeSmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9pQccVerEaa90LKwQKGWZoVfYH3nVTjkyYwuRZ9LRrY=;
 b=NSKycHS28nOX+7ZpNtTPfPBrjxEEwekTUURvXYmMrXFjcYqEcrWvUEbjqbREJjtxk6PwpHp/x4mvMa2l7twYMAnrljCB9WeTPLWit7mWSrUHjsvRTJl0+RbZp49GMk1dibRq4VTRHg2KcyDjuYLyx0PBCEa/W2GpZWypvOwvfso=
Received: from MW5PR11MB5812.namprd11.prod.outlook.com (2603:10b6:303:193::14)
 by MW3PR11MB4748.namprd11.prod.outlook.com (2603:10b6:303:2e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26; Tue, 16 Nov
 2021 14:40:46 +0000
Received: from MW5PR11MB5812.namprd11.prod.outlook.com
 ([fe80::1127:5635:26df:eca9]) by MW5PR11MB5812.namprd11.prod.outlook.com
 ([fe80::1127:5635:26df:eca9%7]) with mapi id 15.20.4690.027; Tue, 16 Nov 2021
 14:40:46 +0000
From:   "Machnikowski, Maciej" <maciej.machnikowski@intel.com>
To:     Florian Westphal <fw@strlen.de>,
        Sabrina Dubroca <sd@queasysnail.net>
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
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "petrm@nvidia.com" <petrm@nvidia.com>
Subject: RE: [PATCH v3 net-next 2/6] rtnetlink: Add new RTM_GETEECSTATE
 message to get SyncE status
Thread-Topic: [PATCH v3 net-next 2/6] rtnetlink: Add new RTM_GETEECSTATE
 message to get SyncE status
Thread-Index: AQHX1iqA5RlGiTEzKkqK25dIf+5Hpav+flEAgAAGGQCAB74pYA==
Date:   Tue, 16 Nov 2021 14:40:46 +0000
Message-ID: <MW5PR11MB58124A70268058505368A5C8EA999@MW5PR11MB5812.namprd11.prod.outlook.com>
References: <20211110114448.2792314-1-maciej.machnikowski@intel.com>
 <20211110114448.2792314-3-maciej.machnikowski@intel.com>
 <YY0+PmNU4MSGfgqA@hog> <20211111162252.GJ16363@breakpoint.cc>
In-Reply-To: <20211111162252.GJ16363@breakpoint.cc>
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
x-ms-office365-filtering-correlation-id: 48892044-601a-4673-e408-08d9a90f137d
x-ms-traffictypediagnostic: MW3PR11MB4748:
x-microsoft-antispam-prvs: <MW3PR11MB47487C06E0A2EED3475978E1EA999@MW3PR11MB4748.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ks8y8sLdLU4nGXTUevwQbOlR1fcKBxkHo5X0MB2+TPBXHWrig2+tNAMDWBDAmT32Yf8xqn+FCGdbGBZAiH8s28lZGotztKhVfDD+6atfY1ozKEHE8PmMTONCdYnEW4Cep2tF2Cz1xT9Lzbq56gosNU2GyCENPzOhzzk2YopovYwbzggGp/RiNE7fnn3Yar/zmWGViDMyo1srVnEgmA8EvBS7NPhrOWQOH7ngN4pFt7kRQE8a9bBqx/cLe7J9ge8XE6ctvTVhJLZ51Y1uuFX0q1gUrhTVqLsxccdgCLKdHgCkdpXiEpko1Wp0QaPGTrW8EoHfOm0MXL8rL4WqWR71qIdSTJUhnCXMAzGlvxhBNKNMPrNb0CvSuooVWk3M0AJADAnU2qMA5fVZwQa8LjsNLYPox2FwaMaf+EfN+9AsTqT8G71UQZ1q5dVk6C2FI/yU32ePFLkHvjD9R5VPbHToiklek3M+BzzHqY6KKQTw7E0G5tYsmQNE41pFtoi/RIapq0sxaS4SxlUqeEG5Cj6ObIljhg/+c0SC528U8+cmD0j25qup93bEvmkt9ysAC8hDGXyAk6hQ7eq9shzxFKCPmFKo0EVO54494cdbZN16Yo4LYutri81ecjClkX5VaLpGpT2jLr5AHCKJdMlXyen68p37OqsPtbUsHkGkn6jTtIb4SrjxSeKaRFRieTYESgk9HYCS+z9DXnL+FAglIIvzUg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR11MB5812.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(64756008)(83380400001)(26005)(186003)(52536014)(86362001)(8936002)(76116006)(66446008)(66476007)(66556008)(8676002)(82960400001)(2906002)(7416002)(15650500001)(508600001)(122000001)(316002)(5660300002)(9686003)(54906003)(110136005)(38070700005)(66946007)(71200400001)(53546011)(38100700002)(7696005)(33656002)(6506007)(4326008)(55016002)(4001150100001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?DOximY6wXvo6EZ/MDptAuO76xzxUpkqqJ2ry4yA15172baae3qK0HPaUTYIr?=
 =?us-ascii?Q?K7pn2rzwN+JKQZWpTjwuwIYUnAWsEw65uR5I758+ddVgrZTyWACm2i4o81kI?=
 =?us-ascii?Q?vaMZvg0tXX/pf2d/vDtvix68kBc9fQLmcpoZP+/TvfAmIxRmPihZfs8q9MUT?=
 =?us-ascii?Q?niJVAQ65ESBe7eAWmnzAcYydCABFlYctHrtJVybugmnJ6MMwsevvsCBHW3Ou?=
 =?us-ascii?Q?9wN/XLigJp+VZJvp1KloFyXYvNC16l3k83gUZL2tlo5vhQiHabVa3DV2j1kZ?=
 =?us-ascii?Q?aDQDj/3sGsucKso1OjnkrkQhq652RxXPNcbOHI0XZQMkh1qr2szESPN9eAp2?=
 =?us-ascii?Q?33VRUwzy8vToTjnMEDBx9TX/q7UCXXTXalk+K619JDeiCvBmENeusQivx6Yf?=
 =?us-ascii?Q?oknHTTiW+MZvOZclssKMyA9e943Gcf4XNjhBJZfAF4GW3U0OfJ8ynMn/8txX?=
 =?us-ascii?Q?lkc4UjFbnQlzN2i1DDb9kKogaqE+wJ4AiMHXQ8hMBbQ2nakC73RjS6xhgy4S?=
 =?us-ascii?Q?CVP84KVz0EfWTRJMyrJlLCeCr6m/Qg2dDbGb7xY4OKuXdXqvDV115VWk3agX?=
 =?us-ascii?Q?nlmBjlAjnfdoLfI7BWVuOnfTjgCEJfouz48HDscUfWjqcTfbJCaZWeFBPEX/?=
 =?us-ascii?Q?+pJ1wsyio4yh6wA/afy1RDo6MjaxlOsAyiNGtecD+CJfGjrWl8TH+pHirLAq?=
 =?us-ascii?Q?nKXjnn44y+30Ko3nZ3gJLOwvijJ81L3+F533dDwr0Wsdww8OsayE8grkapdL?=
 =?us-ascii?Q?6TZiSAmpQA67PRzNV47tt5vB3ADbw+TtjfgF6qQAuLsXYuvm14ystZSKIJWr?=
 =?us-ascii?Q?yyeH3MqMCF4GhHhy19A5PV6XeGgTFBcm2C8lVScRQUVTv2FFPmBZ8W3bPpl4?=
 =?us-ascii?Q?OMYyPTF9xF1R81HnUQWurvSSCW3+GRjui4jN94UyjIqQ+8hRusulrceJ6UDn?=
 =?us-ascii?Q?yQcv8vvrXnsmBY0trR3JFmoK694RqnbXTYfXZZfQuof18jM1AjMXGzTBVXaD?=
 =?us-ascii?Q?BrxuZrkO8yxvhLH1xRzbbCPfUDm2GDaE4NMcM7vGO3q+70fTbqkZPMeWeSXC?=
 =?us-ascii?Q?O9cLBuneKSPFQsRFeJMr495bs9JhWHWoLoXtZo94+ZRJHEDeEa2kHXLexVLw?=
 =?us-ascii?Q?cLCPNLRfJgChoWadCvme5iiQoq/GwelATHw1cbsM7WtRiCRNFHccM3WhbNSS?=
 =?us-ascii?Q?lIDgCtftdfg50bqyGowkuByHEsvJNJp02o9Sc7cZRgsZpoMFp82MkS9eooP/?=
 =?us-ascii?Q?D/U/FFMDRgit29vQPP0OcbgFscZ/nYsIcnO/LKkdnURUGVlzto8qrbP6vofH?=
 =?us-ascii?Q?CppZqC9mxdXmGDQOSrs5Uc+j+AtOVYeqA30Z21jisWj3rqir4nT7uYKd1gGX?=
 =?us-ascii?Q?1Vour2iyb+RDIMJaWplj2pYH5wkFIOAQKfu10VN7++hfxqeXlBVcPDK+JZwI?=
 =?us-ascii?Q?Wx+3IlAMbK5Z6yHtrQIcBMz2RSyOwWbSQ7do9QnXm8Xsd88GTYYKzN3Hr5Bv?=
 =?us-ascii?Q?Oce0oc6vRSKPEdmDKPjPvH+6hVPfMa6vtbxXBfm5EJ8+pUxGpIFoUUcPwwrr?=
 =?us-ascii?Q?TEFl3K38nAXoQvNsQ8WPWRwZIUARY4Yxd9ICzGEsn7ImNUpgaBOml+SrBx8Y?=
 =?us-ascii?Q?OECgRjq3armCiTmilN85swH2OCAKIufp/agDfXDJWAfpUq55I57ikBG0g+9l?=
 =?us-ascii?Q?8CdVvw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR11MB5812.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48892044-601a-4673-e408-08d9a90f137d
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Nov 2021 14:40:46.4414
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qioho7TM30HIgmvHvEeOuU2tPv+F/7cjhfxFlDT/5SesmRVLF6hf0IFVuEQWp36fRBwGEdeijqsnSU1Ub63WHS2vjicasdM3kZMeQ1w8Qto=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4748
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Florian Westphal <fw@strlen.de>
> Sent: Thursday, November 11, 2021 5:23 PM
> To: Sabrina Dubroca <sd@queasysnail.net>
> Subject: Re: [PATCH v3 net-next 2/6] rtnetlink: Add new RTM_GETEECSTATE
> message to get SyncE status
>=20
> Sabrina Dubroca <sd@queasysnail.net> wrote:
> > Hello Maciej,
> >
> > 2021-11-10, 12:44:44 +0100, Maciej Machnikowski wrote:
> > > diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtne=
tlink.h
> > > index 5888492a5257..1d8662afd6bd 100644
> > > --- a/include/uapi/linux/rtnetlink.h
> > > +++ b/include/uapi/linux/rtnetlink.h
> > > @@ -185,6 +185,9 @@ enum {
> > >  	RTM_GETNEXTHOPBUCKET,
> > >  #define RTM_GETNEXTHOPBUCKET	RTM_GETNEXTHOPBUCKET
> > >
> > > +	RTM_GETEECSTATE =3D 124,
> > > +#define RTM_GETEECSTATE	RTM_GETEECSTATE
> >
> > I'm not sure about this. All the other RTM_GETxxx are such that
> > RTM_GETxxx % 4 =3D=3D 2. Following the current pattern, 124 should be
> > reserved for RTM_NEWxxx, and RTM_GETEECSTATE would be 126.
>=20
> More importantly, why is this added to rtnetlink (routing sockets)?
> It appears to be unrelated?
>=20
> Looks like this should be in ethtool (it has netlink api nowadays) or
> devlink.

We identified it as a generic place in previous RFCs. Ethtool calls are not
available in non-ethernet packet networks and the concept of that functiona=
lity
is - any packet network can implement it - SONET, GPON or even wireless.
