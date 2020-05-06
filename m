Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD4801C665A
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 05:31:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726660AbgEFDbR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 23:31:17 -0400
Received: from mga07.intel.com ([134.134.136.100]:40252 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725900AbgEFDbQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 23:31:16 -0400
IronPort-SDR: hQnNVMOt3y5qUQJDaMWSDmq3lYfl8c28nwsWcW0pE/E3MeGMZXt4SNusjwJujjZES21mFkRh6e
 sgzHxFdJWjfA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2020 20:31:13 -0700
IronPort-SDR: JB32Q4wMnIBLi+4AWjdE2T4xpp1OBGveR9G2gmu/9Jzyw2aMgONqrARLWMEK+zeDxueXXsDABT
 hOqI5pi39D3w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,357,1583222400"; 
   d="scan'208";a="278090403"
Received: from fmsmsx107.amr.corp.intel.com ([10.18.124.205])
  by orsmga002.jf.intel.com with ESMTP; 05 May 2020 20:31:12 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx107.amr.corp.intel.com (10.18.124.205) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 5 May 2020 20:31:12 -0700
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 5 May 2020 20:31:10 -0700
Received: from FMSEDG002.ED.cps.intel.com (10.1.192.134) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 5 May 2020 20:31:09 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.171)
 by edgegateway.intel.com (192.55.55.69) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Tue, 5 May 2020 20:31:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kkjA0c3623OTrTOUCMAz05774OP3DQK/fhtcC0M6OFcojm0Tk++u6THYEVUoIpLbMLmZ+mOiMbBS+TUTpDNEXfCgh2tPsZmH5Kt+ihMmQ/imMFHgi3Wx97AAVzU16zh5UW9/ABrwxwoUDYp1Ph1u0g9DB/Tw2cc2k7vKK1b7MgiCuH5mBLUrg7YYSx+jGDOSL/HlPqDp8FyqIb4eRCGd5DuBVbEeWLpHMBexb+rSfbJ7j8VqYcO8q/ikDoe4bTfm310T/OuYE3R40jGXPlW/uyIpn1YdLEpdUAj8U969MdjbNoLiQVugeRUM6bzx7T8hvflQe7bcryDGMWo+FUr0pQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ScBWiconMMRoToYSAUT2it+XZJPPcplODaIZn/D2E7c=;
 b=eZdgSnk0zifeFCwA6RhEJlBF+WqClpRUXkmJuY+jMmSKyjF4LFp4afHzGYOl+Cg0+pIvK5ZbliRQXE5t10rAVCrKwGzZeU7+MWYHLdjihcaGjjQEndrJ5vycNa3aZG2VfQuFVOGTO//Ha2LIbo17g0ZoVSrsc84pIPSlPmk0eAukYKYQGIXg5DSnTQMfHj6M+7OGVA5SieEBDpy+mW4a0++DNooxqoX2elHFEpL0LrWERbgCpcInJUKFSRuG4J90OwTpfw6nnapnrsb0+RNvaz63SGWlRtMNAklw9jdozkmXhlM193awIJK45c0a7nLvIxwnZgHAhTnLCIg1OwjHxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ScBWiconMMRoToYSAUT2it+XZJPPcplODaIZn/D2E7c=;
 b=lxhITJte4lP2u6ObnRJzWVPYG8cIytd8Ec/u0Fc4IPChrkgKmCGAQXrGcdMlb7Ve8j5gpCsGrrGapJ72zpm+DUeM7qgdyemKCoFVnkwlDY7Um+gH3GUePbLXNRc8GZV1ZAun9df+P3xdF7XIEqCkQhOD/PmnMmQeOUvOZt4zv1I=
Received: from BYAPR11MB2870.namprd11.prod.outlook.com (2603:10b6:a02:cb::12)
 by BYAPR11MB3302.namprd11.prod.outlook.com (2603:10b6:a03:7b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.29; Wed, 6 May
 2020 03:31:00 +0000
Received: from BYAPR11MB2870.namprd11.prod.outlook.com
 ([fe80::75e4:ee66:1e4d:a413]) by BYAPR11MB2870.namprd11.prod.outlook.com
 ([fe80::75e4:ee66:1e4d:a413%4]) with mapi id 15.20.2958.030; Wed, 6 May 2020
 03:31:00 +0000
From:   "Wong, Vee Khee" <vee.khee.wong@intel.com>
To:     David Miller <davem@davemloft.net>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>
CC:     "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "Voon, Weifeng" <weifeng.voon@intel.com>
Subject: RE: [PATCH net-next 1/1] net: stmmac: Add option for VLAN filter fail
 queue enable
Thread-Topic: [PATCH net-next 1/1] net: stmmac: Add option for VLAN filter
 fail queue enable
Thread-Index: AQHWGTyVW2FLQsiP2Eedqaoj0MNIyqiHUYmAgBMntQA=
Date:   Wed, 6 May 2020 03:31:00 +0000
Message-ID: <BYAPR11MB28704CA53250D824BA7422B0ABA40@BYAPR11MB2870.namprd11.prod.outlook.com>
References: <20200423070026.26200-1-vee.khee.wong@intel.com>
 <20200423.155329.1710757370582804428.davem@davemloft.net>
In-Reply-To: <20200423.155329.1710757370582804428.davem@davemloft.net>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.2.0.6
dlp-product: dlpe-windows
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.201]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 13b83a13-dc30-4043-897d-08d7f16de5fa
x-ms-traffictypediagnostic: BYAPR11MB3302:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB33022869FE92AB6A5BB46261ABA40@BYAPR11MB3302.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:206;
x-forefront-prvs: 03950F25EC
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TT0Rb0vhllZXOOw4xClXqueA+uiZ2KtSP75P81HDOQFpYphvCmliRFJp3zFGSeJOannf7IlNoEPKhZDkx/7+VtI8MtON4o1lC3eBRC/lZmVIaSnEQrTm3kXawvypuDSboNviNnKj8d5Rl/f5tC0gRrSQlW/oGNYLBHMKPIzbXusAMgrfj19SN2sDycQwqU2RGgMzY8P8fpmx3dvZHgD8TgEls5fLSGBIGJAJ3ZHLkM3P8r6jHqNovru9hmhQYIRFJQY6cca1C8ALJt9RQvu6cpTylK3nce/lUmxXw1Y28IzSamtX65/Mnj7t9fzDVh4pRRcfRvsoSmofi537EJ/LyN8rlJBUPIG+MfWtByvMADdbfGJXmmMO278NTswNxKcUhn+qIKJHQn7YsQxnxMharEcOG0tV0ekHkfiVZNyxv6TJkT/guzWcDHSXyoqWDCBEnMmTNEoj8RjMcpmfmng1iUqXEwSaU6eS2URAtZJnWjqRCRI5tq1/ADlrofuCnHpEBO5sw35VJg/YbDQbOEwp6Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB2870.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(39860400002)(346002)(396003)(366004)(376002)(33430700001)(26005)(66556008)(8936002)(66446008)(316002)(2906002)(66946007)(52536014)(33440700001)(66476007)(64756008)(76116006)(33656002)(478600001)(86362001)(107886003)(4326008)(186003)(55016002)(8676002)(9686003)(53546011)(6506007)(54906003)(71200400001)(7696005)(110136005)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: Z3brmon97AjM9euBD92NslKtDxw8m57PPRFV2WxfyoJAvGx+TIgPgfO6dvM2jJa4XK6QoN0C08wcF8+EKbj8DKeyHCoN4FEspI2v1Bc7WKmnlvx3Ndhtl3R5LdS6FiJ4SFBOgpRDwUzy95Jv6brji5wQcOxsih3em2BFwCamT96RJgxIk+fDhxIJnPcb6i0wdyDz2SSyoavKzdrF94V4zUvC9YwZWJZbYYk8f4zgqQte5V+1oQGHWNsn0xIURCkgk+tqEiTiNUHltdZHNt0IoFAcZnCT7B8Qu+3+PqHu1vvYeqmQfwNzeXvbyh3+UInceZY4ISCE/NwAmkknB9jVN6l7bZzbd9M88L/FYa6xABcmP/KK3SbJQiY/q7hV9IgL3gqQnO4s0GjtJJHcgHeiP6ji/7o8CVuLhAtWf6gi1qgXm0GUwxoZ5pE+WQonk8ljkGG27j9cJ5qac+3VfB1vt6tCGRKcI0g//sbAlPAtlXD6ccbelpJhJ453299In4e3SZgMIMChqEBssOS8tSraEr9Qon+Lv6t3uoaf4Lppf6mn8vY00XQoIx9YmO0N/6j9t/pGTM8ix0GbmZsqkMVErYbXtZ5kZ2EojJ009uFb1F6CO1HHQ7yliD6TAWoQmNOLt7Z1zaHhyNvnjMSixPftLilNAZr+hgRZnTnMjA6/eg99KiutTr7VsoEPzBRKpAKaLaT3XYg605RYeUoefnyiaL7fI9MQTZh+9QtKEUemedoRz3rWgl/5VDog2UZ8shWg6a+UdLiW8BpcWADUqoOUOrtf1IEmRXZKvNpjGKqnjGWepgmEAreYvcvR08JoBuyB
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 13b83a13-dc30-4043-897d-08d7f16de5fa
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 May 2020 03:31:00.7246
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +/RGKORFg3m1DOhaDC4C3bhSKb3GNHNR6O1uf/+V7Eq5E2I4qfeGvPUF8h+yFfYmhy4corXXxJgFtYflW9ClKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3302
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org> On
> Behalf Of David Miller
> Sent: Friday, April 24, 2020 6:53 AM
> To: Wong, Vee Khee <vee.khee.wong@intel.com>
> Cc: peppe.cavallaro@st.com; alexandre.torgue@st.com;
> joabreu@synopsys.com; mcoquelin.stm32@gmail.com;
> netdev@vger.kernel.org; linux-stm32@st-md-mailman.stormreply.com;
> linux-arm-kernel@lists.infradead.org; linux-kernel@vger.kernel.org; Ong,
> Boon Leong <boon.leong.ong@intel.com>; Voon, Weifeng
> <weifeng.voon@intel.com>
> Subject: Re: [PATCH net-next 1/1] net: stmmac: Add option for VLAN filter=
 fail
> queue enable
>=20
> From: Wong Vee Khee <vee.khee.wong@intel.com>
> Date: Thu, 23 Apr 2020 15:00:26 +0800
>=20
> > From: "Chuah, Kim Tatt" <kim.tatt.chuah@intel.com>
> >
> > Add option in plat_stmmacenet_data struct to enable VLAN Filter Fail
> > Queuing. This option allows packets that fail VLAN filter to be routed
> > to a specific Rx queue when Receive All is also set.
> >
> > When this option is enabled:
> > - Enable VFFQ only when entering promiscuous mode, because Receive All
> >   will pass up all rx packets that failed address filtering (similar to
> >   promiscuous mode).
> > - VLAN-promiscuous mode is never entered to allow rx packet to fail VLA=
N
> >   filters and get routed to selected VFFQ Rx queue.
> >
> > Reviewed-by: Voon Weifeng <weifeng.voon@intel.com>
> > Reviewed-by: Ong Boon Leong <boon.leong.ong@intel.com>
> > Signed-off-by: Chuah, Kim Tatt <kim.tatt.chuah@intel.com>
> > Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
>=20
> Why would you be setting this with a platform attribute?  Even if the
> capability exists, wouldn't you want the user to be able to choose to opt=
 out?

Hi Jose/David Miller,

1/ In current implementation, TSN uses VLAN filter that can either accept/r=
eject VLAN-tagged network packets. In some situation, we do not want to dro=
p failed packets, but instead steer the packet to a VLAN Failed Queue Chann=
el.

2/ VLAN Fail Queue Channel will be set to use the RxQ with higheset index a=
s per HW IP configuration because that is the least priority channel.

3/ The way user will enable this feature is through promiscuous mode settin=
gs using ifconfig. (e.g. ifconfig enp0s30f4 promisc)

4/ VLAN Filter Fail Packets Queue feature is IP version specific (only appl=
icable to DWMAC5). I would propose we add this under platform data (e.g. dw=
mac-intel), so that it can be built in according to hardware on a separate =
patch.

Any thoughts?

