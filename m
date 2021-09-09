Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 992F0404700
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 10:26:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231380AbhIII2E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 04:28:04 -0400
Received: from mga18.intel.com ([134.134.136.126]:61508 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230509AbhIII2C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 04:28:02 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10101"; a="207834134"
X-IronPort-AV: E=Sophos;i="5.85,279,1624345200"; 
   d="scan'208";a="207834134"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2021 01:26:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,279,1624345200"; 
   d="scan'208";a="580759727"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga004.jf.intel.com with ESMTP; 09 Sep 2021 01:26:52 -0700
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 9 Sep 2021 01:26:52 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Thu, 9 Sep 2021 01:26:52 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.45) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Thu, 9 Sep 2021 01:26:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IvMYO4UbiCY+vHnxzAeto0BU/HskQHp8IK9HiClEvptVXpA94Srmhi0gEFFPmz5OOkr6NhzpDs0iNOWtCwnl9kH7N419g4gPpGPh8gZqIp+SNA30YByn/ZH8pvtFiIjvRea/aWiI6aFw3Fwq5crMAtfo78ZjlGtuSu66mvppZTOlZmwHIExgZvO8CPsEL+CW8rSYJFW5Ozr0X3upx+1c9aKNo6fidru/gNtIVC0TxkKXZTcmQoLsX1peFnQ17vscmsCNXHpajyq9q0FluSXv+PqdcyFL6aq2Fl+Bim2/u5aJ0Ls1iweo8ofixmCnRw5AFg8xIOoTcWGpJmPdJyXvAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=yHsVQ7Ml59XryoOEDlfuc5MpQlv2wXFxIXC5C4O4SK8=;
 b=Jy8FBWEDkKmwa33fp+5tWFNjEnJkwPbzk6wlYESKIMoWqlT1hK8o2LANhTHzRQKY3BOOQQ7mU0EBtNluYmsNwamfMTQm1+Pai0IcCG5bN0RcnNynxA4RJxsFGPa0Z/V/lcLNpSoSkHV18g4zP0Ny9Xa0IhdDOz7AzEp0k4q+sBoCUB/P4FtNt41iKlvxq1mcYvxBoT+GarYdXOegCk257JGkCv/aHO1u3eCPoKaHy4l10k5GafdWy7ICdrPfrRisLgy44haj5AwtVcUTttofWj6faz6puwISXiQ9mlhSMtFU6X9bQz6xcLy0a6Nt/YGiu99pnU/mWcdps8cS/IBiLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yHsVQ7Ml59XryoOEDlfuc5MpQlv2wXFxIXC5C4O4SK8=;
 b=lTg3PD+P1VUz0reMFzwUBn21SsMKuJjV6cCVB1z5D7vRApjASVrysiGa5KJyT+CCvtJoZPIpNDQ40sfHjnETmisHT8Xu02zmjZ7SbR6Ms6ROJPrU4fRZFo8dcCSFG97jtl01ZCUt/WM/UL8Ch1YWkFP4KXk6Lw9ofgrL4MGOq1g=
Received: from PH0PR11MB4951.namprd11.prod.outlook.com (2603:10b6:510:43::5)
 by PH0PR11MB4967.namprd11.prod.outlook.com (2603:10b6:510:41::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Thu, 9 Sep
 2021 08:26:51 +0000
Received: from PH0PR11MB4951.namprd11.prod.outlook.com
 ([fe80::58cd:3e24:745c:e221]) by PH0PR11MB4951.namprd11.prod.outlook.com
 ([fe80::58cd:3e24:745c:e221%7]) with mapi id 15.20.4415.029; Thu, 9 Sep 2021
 08:26:51 +0000
From:   "Machnikowski, Maciej" <maciej.machnikowski@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "abyagowi@fb.com" <abyagowi@fb.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "Michal Kubecek" <mkubecek@suse.cz>,
        Saeed Mahameed <saeed@kernel.org>,
        Michael Chan <michael.chan@broadcom.com>
Subject: RE: [PATCH net-next 1/2] rtnetlink: Add new RTM_GETEECSTATE message
 to get SyncE status
Thread-Topic: [PATCH net-next 1/2] rtnetlink: Add new RTM_GETEECSTATE message
 to get SyncE status
Thread-Index: AQHXoNimVzUXkjuVtUCdGyBU/1Tj8auS4GqAgARwniCAAApOgIAAAHuggABqPwCAAH2kEIAAa06AgAADpCCAAE4LAIAAxVmQgACTXICAAAjlIIAAWwUAgAAPkwCAAAwiAIAAi8Mg
Date:   Thu, 9 Sep 2021 08:26:51 +0000
Message-ID: <PH0PR11MB49516BE62562735F017470A4EAD59@PH0PR11MB4951.namprd11.prod.outlook.com>
References: <PH0PR11MB49511F2017F48BBAAB2A065CEAD29@PH0PR11MB4951.namprd11.prod.outlook.com>
        <20210906180124.33ff49ef@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <PH0PR11MB495152B03F32A5A17EDB2F6CEAD39@PH0PR11MB4951.namprd11.prod.outlook.com>
        <20210907075509.0b3cb353@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <PH0PR11MB49512C265E090FC8741D8510EAD39@PH0PR11MB4951.namprd11.prod.outlook.com>
        <20210907124730.33852895@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <PH0PR11MB495169997552152891A69B57EAD49@PH0PR11MB4951.namprd11.prod.outlook.com>
        <20210908092115.191fdc28@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <PH0PR11MB4951AA3C65DD8E7612F5F396EAD49@PH0PR11MB4951.namprd11.prod.outlook.com>
        <20210908151852.7ad8a0f1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YTlD3Gok7w/MF+g2@lunn.ch>
 <20210908165802.1d5c952d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210908165802.1d5c952d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 100b68e6-a343-4223-9269-08d9736b92d9
x-ms-traffictypediagnostic: PH0PR11MB4967:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR11MB4967E64CFC7F1B3FC60F72BDEAD59@PH0PR11MB4967.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tLTp3TmWg+N0dQ2Uv0a3FHy7W1qap+auB89VVob3Ms283GdEgk/2sNk7rdLyVcUdfPWUF0nCKgRBPrnyEJFK1FsRSL/rokMHFtQJ2CSEJfBduVP9DoT7hheZeeL9GfzV9zsgFYBG0HjpPJDcn+JHjREbOiatFYjBTuXMiSAurO5dbKqjfN+IzrcZXyJwRGAVyn5AqLD1B3ePvgIG0XxE5BT2Nwx+8GmjMm+ePAct2HD1QACXrGgI08RW81DnTAHl7+z82wvM6oKoCOAHDJD2KpUndNDJHarQIiwrtmMfa5EVRsEl2NJycECiQyP2uHbefRT1H3jzJJ1XEluSrMyteER157MbcpS5TwoySwDzcujkLbvMrv3uWFk0OWJbgOdUHtULGT/3d+1di9mXRL1qWwkKszcETekoEVLFrCiYbhXlloIEu3V1xg1M0oYmXDzhzwdaJdUTHIU7WeEyl0Q/4CZo69uL4wBKTgk9VZmoCQ5ZXrE1g6d7K/Bf/sgjXXGvPRGPnE3YBk1m87LQ03tB9vLA7FXdG8rFSqq0qm7YvPHUIquaqdvFqHMXOloXDv8Bl8wWJG7pL74f+2pWtn/5ffkST/6zxtp0+TqbCkd/2lxdVNRKrlEfwNABBbUBsnibkquLl7iJUDFwqtv7ZOHcbmnX7thatGUYuCDz3EO5YjtozsF8HS32AanBZrhNNMEnndpeK2bLLOfVU/ZiuLOlakyEG66/Ocxr13KI1/H4pk3KXfzOn4p2ooRtoCS2rm9wNw42GYWD7S8HYAGjQJLa5/DmSwaLyv0/cULQQtVSsNoGMXHvvSAXv1BnDcJW67Harwm5oHMvMahxth+6wCGR7Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4951.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(136003)(39860400002)(366004)(346002)(53546011)(52536014)(66446008)(5660300002)(7696005)(66556008)(33656002)(64756008)(15650500001)(66946007)(7416002)(38070700005)(66476007)(478600001)(76116006)(122000001)(71200400001)(9686003)(8676002)(186003)(26005)(83380400001)(316002)(54906003)(38100700002)(86362001)(966005)(6506007)(110136005)(4326008)(2906002)(8936002)(55016002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?DQXPL8p0s7FfwSroc4BFfG23xgxVJuRj2aKlyO9IDgGRnuaQmXc29jAodAOT?=
 =?us-ascii?Q?Y2WNa9I7rXPBCRETT+mq+YHWMPZIGOxn+xKQzd9TpYkJjDqywVDiG6mBiMLg?=
 =?us-ascii?Q?JKJ0m5XCpoFywXUf/n/+IpOzHUSxDyv14FB9gXAronlIpWRUbA95n9TEkm1Q?=
 =?us-ascii?Q?P5IYFguKXJ0uwXJlRGjUmBot0i9ChgESxnz3JnF0AURd0XhnzJVYNeb3mxDm?=
 =?us-ascii?Q?gGDiS5l2CNojKwSSSFNel9pCBYFcnxFdZjeaRHYFxQ+9YI/TEyXAbYtb6ikk?=
 =?us-ascii?Q?PTlkhxfcpq/IsXxiB4rYSIuITARiHEFarg3xuwzBZpU5hVtUcFpSvLx/xWIq?=
 =?us-ascii?Q?rZ8KEzY1N530eF+vuXL0f64/bST/1eN5DO6Qo/HkcNl39/RNMqwSDdAqVP0y?=
 =?us-ascii?Q?3ec9nqNdsqWi2gN+3EJYTH/on+ZStTcBX0vhF9lASR84tD9jNF9soWkdQXNh?=
 =?us-ascii?Q?vR8wM7c9HBzN5ltjwAeZTpDrjovzq4ZHr3s/Xfu6RezYUbt0wsSPyxc+ve26?=
 =?us-ascii?Q?BVvO16O7De0yr69bBqiT3jkBdPpgzxuT/njrKPg81C5IkCcfQ4YWazsXJXL8?=
 =?us-ascii?Q?DjpFY3CTAoy+zlYVlIJ42VJOL3NNfqWWBpfkz1SW1Iz5lVIwZPRveEYpDmwU?=
 =?us-ascii?Q?t9ux0gXIWpZRrexpocT69leRb8vUjz5m0H0GEdn4DWloyPYh1VcGZi73VGFD?=
 =?us-ascii?Q?IxA1X30+H5Twx3y0BSKOHPVbOu1AojPaBZ7FCwn4QxOVAMPzrU78vv1jbhge?=
 =?us-ascii?Q?H05adrF+miHaDxWP9szqDkeaZQnwmCjIeKXO59mTeZzljz20GSwbODcC+l6p?=
 =?us-ascii?Q?5RQH6FtnMPoDuuKleTDNpFKCCQGtxUcoaNgfhdjf+57dtkM67Q1nRVc/8bXh?=
 =?us-ascii?Q?6h4QPBludzoVcUEvExsh7gG9u/ZdEI1c+v2aILfeoWHLQYu5F2a1vca9t/px?=
 =?us-ascii?Q?acWLCMpa1VHR4IXkyz6PCycMLtwV61jfrIQdeTohsQlHiS13rA1UZzGGG1BC?=
 =?us-ascii?Q?yVJUQj6Z2ZTOKzWZX70yaUQ6jpFPviuSofdq7PdQOSTLrtsoGWDzte0OapEM?=
 =?us-ascii?Q?36jk+fn+yBzdW+m2wz0qhAjcrEHL33iKkLDr4+C+rOw4XwkaNEd1oy0wMw1M?=
 =?us-ascii?Q?ZPRbM12oECkSrW5lQRr0paBN6sSuAQPCA+IsVOQJyOqWHe6VuQaEtVMdW8+S?=
 =?us-ascii?Q?VSn0KDphEG7iSfRHeXMhEMFrOmK9bdZqroi3S/kdnf/QcG5iyhm2ZK2qBW25?=
 =?us-ascii?Q?xFJL8OMYFWuY9z05DtVI7yun1frD6V1gPbMSJR68KExLiEWjsndn8oCmrLhw?=
 =?us-ascii?Q?X3s=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4951.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 100b68e6-a343-4223-9269-08d9736b92d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2021 08:26:51.1176
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Wntu+L5NwDNtaYRyDo3CRc27qniaj0lLJLctExTSwqbWZnoqQWBlD1uwyXhk2DC8TGtEwMx2EwFS5+9so60+IkC5Pk0SepkdRaS79DSd6DA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4967
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Thursday, September 9, 2021 1:58 AM
> To: Andrew Lunn <andrew@lunn.ch>
> Cc: Machnikowski, Maciej <maciej.machnikowski@intel.com>;
> netdev@vger.kernel.org; intel-wired-lan@lists.osuosl.org;
> richardcochran@gmail.com; abyagowi@fb.com; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; davem@davemloft.net; linux-
> kselftest@vger.kernel.org; Michal Kubecek <mkubecek@suse.cz>; Saeed
> Mahameed <saeed@kernel.org>; Michael Chan
> <michael.chan@broadcom.com>
> Subject: Re: [PATCH net-next 1/2] rtnetlink: Add new RTM_GETEECSTATE
> message to get SyncE status
>=20
> On Thu, 9 Sep 2021 01:14:36 +0200 Andrew Lunn wrote:
> > > As you said, pin -> ref mapping is board specific, so the API should
> > > not assume knowledge of routing between Port and ECC.
> >
> > That information will probably end up in device tree. And X different
> > implementations of ACPI, unless somebody puts there foot down and
> > stops the snow flakes.
> >
> > > Imagine a system with two cascaded switch ASICs and a bunch of PHYs.
> > > How do you express that by pure extensions to the proposed API?
> >
> > Device tree is good at that. ACPI might eventually catch up.
>=20
> I could well be wrong but some of those connectors could well be just
> SMAs on the back plate, no? User could cable those up to their heart
> content.
>=20
> https://engineering.fb.com/2021/08/11/open-source/time-appliance/

Yep! We should base on the abstract indexes, rather than the device tree.
The user needs to make sense of the indexes, just like with PTP pins.
=20
> > How complex a setup do we actually expect? Can there be multiple
> > disjoint SyncE trees within an Ethernet switch cluster? Or would it be
> > reasonable to say all you need to configure is the clock source, and
> > all other ports of the switches are slaves if SyncE is enabled for the
> > port? I've never see any SOHO switch hardware which allows you to have
> > disjoint PTP trees, so it does not sound too unreasonable to only
> > allow a single SyncE tree per switch cluster.
>=20
> Not sure. I get the (perhaps unfounded) feeling that just forwarding
> the clock from one port to the rest is simpler. Maciej cares primarily
> about exposing the clock to other non-Ethernet things, the device would
> be an endpoint here, using the clock for LTE or whatnot.

Also multiple PTP domain switches starts appearing on the market.
I know Cisco makes them:
https://www.cisco.com/c/en/us/td/docs/switches/datacenter/nexus3548/sw/syst=
em_mgmt/602/b_N3548_System_Management_Config_602A11/b_N3548_Sysetm_Manageme=
nt_Config_602A11_chapter_011.html
Disjoint SyncE trees will be harder to implement due to the physical nature
of it.

> > Also, if you are cascading switches, you generally don't put PHYs in
> > the middle, you just connect the SERDES lanes together.
>=20
> My concern was a case where PHY connected to one switch exposes the
> refclock on an aux pin which is then muxed to more than one switch ASIC.
> IOW the "source port" is not actually under the same switch.
>=20
> Again, IDK if that's realistic.

It can be done, but the userspace app should make sense out of this config.
Coding all scenarios in kernel would make 1000000 different possible
configurations in the driver - which probably no one wants to keep/maintain=
.
We can return info about hardwired pins (like GNSS, PHY recovered clks,
PTP clock and so on) but should also give some generic ones.
