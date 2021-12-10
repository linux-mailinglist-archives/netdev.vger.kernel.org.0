Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 989E4470F17
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 00:57:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240509AbhLKABb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 19:01:31 -0500
Received: from mga05.intel.com ([192.55.52.43]:61307 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230472AbhLKAB3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Dec 2021 19:01:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639180674; x=1670716674;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2GfPkgsU4M83+XQL971N+Cr5qNq9AMg9VNjkiQvt9ik=;
  b=B1GCpd1rwTDg9hPdKzIoLc2I11tAZBlSIkDBJ25u02C2LHclQnTOwfFD
   w7iBIxsbXego/i1/2aGp04zn3JhfYZTmw5UatZBa6av+BGnt3IdlJG4uW
   SyzakzItgn9CGhQb5K8SgLzA7E2TCmZ2UlMIgYPfFMxz+WMl26uDVcZM1
   EB89mkwfjNZF2OrXb3e41g57QWY/pJik0dlZk1hsYusoRykXU1w1Sp40u
   gC6r+j0qobzQu5tZUiGqpdr0IbXfwPn9qrnEIBUcI0tvBEa83AOE99n8P
   SanmWZxlkgZGCSk5SK0qVlyTpS/XqpxU7YEiPMQz702s0yuRpWGreuQ5Y
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10194"; a="324751201"
X-IronPort-AV: E=Sophos;i="5.88,197,1635231600"; 
   d="scan'208";a="324751201"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2021 15:57:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,197,1635231600"; 
   d="scan'208";a="463874648"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga006.jf.intel.com with ESMTP; 10 Dec 2021 15:57:53 -0800
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 10 Dec 2021 15:57:53 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Fri, 10 Dec 2021 15:57:53 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.44) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Fri, 10 Dec 2021 15:57:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WY280OeRs+btAPpe+d7G55Sg8CxINPclWrzVx+aFitqFlVv9Yn8oAg7MmdlCNbH5CyOC35AKzyN+dduk/sUUGMuymzUREW0qX/deQxBvAXCp4/VsUphj2BKb+uwIKCxGAlIWwRoFELZlhfqdtjZtwW3dyWSM9vc6/ICHnzk9lA6W6LULkUBh+ZV0ZYIP7N83vupx0k7IP2FgYmhPT8/G4QR2t3dwpuZFTZJO2AWn03IyNI/VelgWGokJBCH5ylIrUUdI0wn+G4UkEKdQd93s5RrBL+aDylcBfql1g+KFaXe8TRm+d3F8tE4qUHFXAAQuxkU5AvIhBEL0MEXG3hfUrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2GfPkgsU4M83+XQL971N+Cr5qNq9AMg9VNjkiQvt9ik=;
 b=KV4pyu8ZmhF2N97mTQNjcbuwSXkvdKCuzG1ZZm0p8NUwCLcK6jKGolt1rXR0zgTeyqCCFhiRyWPEQySKh5iqjCthgDZ5AcA1By81EiCsFRkJ/oVqqlnkCMaCtIJGLtTeg31LdwdnhhjBMu9Tb2qVy1rMqQkdj+R9LveA8OR3OD73K4XrLS/fQb4IXQkMxu5+PDMVhJvjhnk6uszofmYjvVzBRt7j5iFOEiS982BDoQPKhCgCb+sl51YZlq5q4bnajdMSD8RbGNG5TSlLCGxZYPJ4WaKyJNdfQqP5kjtJI9mjaE6JBXp7fN/zt0O7X/u4F05rNgdFijwvbVA/XDjLVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2GfPkgsU4M83+XQL971N+Cr5qNq9AMg9VNjkiQvt9ik=;
 b=X21+kwpKSOoTRwKx1cZ+Suw/sCocEStnwQq8epnKiYyBPqLjYLggkhTAyDkmks9oTE446uDkGfa6l3z5C4CNowcA28ghOV5uGKaoY2stAg9fm9lxx+As9P+/khQKuy4FHNAmmLmZpeBnrjpbMaxcSLX8YsZvoM9FWky6RaWIpq0=
Received: from MWHPR11MB1293.namprd11.prod.outlook.com (2603:10b6:300:1e::8)
 by MWHPR11MB2048.namprd11.prod.outlook.com (2603:10b6:300:27::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.22; Fri, 10 Dec
 2021 23:57:50 +0000
Received: from MWHPR11MB1293.namprd11.prod.outlook.com
 ([fe80::d0b1:12c0:62d3:7c9b]) by MWHPR11MB1293.namprd11.prod.outlook.com
 ([fe80::d0b1:12c0:62d3:7c9b%7]) with mapi id 15.20.4755.027; Fri, 10 Dec 2021
 23:57:50 +0000
From:   "Nambiar, Amritha" <amritha.nambiar@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>
CC:     "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "Kanzenbach, Kurt" <kurt.kanzenbach@linutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Subject: RE: [PATCH net-next 0/2] net: stmmac: add EthType Rx Frame steering
Thread-Topic: [PATCH net-next 0/2] net: stmmac: add EthType Rx Frame steering
Thread-Index: AQHX7RBf8jboHl+820enr5wfqhDOc6wroBYAgACAw4CAAEMQ4A==
Date:   Fri, 10 Dec 2021 23:57:50 +0000
Message-ID: <MWHPR11MB1293030F02EDACD0A7C25425F1719@MWHPR11MB1293.namprd11.prod.outlook.com>
References: <20211209151631.138326-1-boon.leong.ong@intel.com>
        <20211210115730.bcdh7jvwt24u5em3@skbuf>
 <20211210113821.522b7c00@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211210113821.522b7c00@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.200.16
dlp-reaction: no-action
dlp-product: dlpe-windows
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9c4093a0-6306-447d-40b3-08d9bc38dfd3
x-ms-traffictypediagnostic: MWHPR11MB2048:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <MWHPR11MB2048AF08421699DB2F5786E0F1719@MWHPR11MB2048.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cCNtbMyT69S204lMC0ykuo8pp/uElwIuExa+RweGToJ0BJB3u5+lLi1KOZ5SalU3hcn29t+zI33gDuSw2FTs/HlonX7fzIXJ5qPwu0CvxenH7vPVXriDGvhZ296jGfB74sOZ4UZTF8EvPnV1dC24PDyeTaoGNf7tzu7JzDwEDbsayqH6yP8nTb+zuy+jagucAi7jwZH4fq6PKMxjsIYuECOA19CGBaoE5QOVjVbrIy1pnCm4/8cgmGdTD6zel5mpVa2c+1xAOD3PzVoh8J1nO0BmduHega97IjFABEqfvPoqbfM9pz6Xqz7OKBEbeD/nOw4bqIjMCNC99k9YsrNwOFVc3q/6Pq+QTsqGlEaCeJVVNO6MWtGizAYON1W8bJUmg+h4HfsMvRFOt/iUHPwHedVaZARKJif8JeKZM8kbjNwLAbgdZXDPv7Sbo+3O2txSMmc3SA4RosmJCBBJ8rgef0+bdUm6xDNI1qKLqX6Xi2CxvHbwQ2KB81BSEGBwPPYhOjPFMuRmayHHTMmQzDUaoZCNTi6kfJpofz7NCoFfPTQJWiwb6h4iH6nZ6Rgs5VcgxpSAcpB3nGzVBTZirg2RuJBdfH+Qdq4pwVOrvierDkLwnSbCr+Xo9ZD4lLUfvtVDg3h1iLg+FtXb2PBQnPpqs2o3vbMMQUmGNV8nqM8HwFZd7WUDx+V9S6KgjzvvhU0MsV51iCVPH7r+XmG7ddsMNqqiZUE+KsQ+02BGTlr5SQhOsPQ9MAeDhIl3+J6gMUEh0/fvcELwlMAdVL+CrgZZWjtTNpmyg9UyCYUi7mUisqE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1293.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(107886003)(66446008)(9686003)(2906002)(54906003)(64756008)(66556008)(7416002)(186003)(4326008)(110136005)(76116006)(66946007)(122000001)(66476007)(7696005)(8676002)(38100700002)(8936002)(38070700005)(6506007)(316002)(33656002)(86362001)(52536014)(53546011)(508600001)(83380400001)(55016003)(82960400001)(5660300002)(71200400001)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?2zyYC/uVnT55WCckmqmm2g99y182uoutGddj9+R35B1i3OlFNU1m6j8AG7sm?=
 =?us-ascii?Q?UDKMQ7hCnct2B71N+QLVjVhGewHsjIliBC6Im6oEXHQFOShpvLWXEFaJM0pq?=
 =?us-ascii?Q?iElTOeG9xxrky0bv+tS9WJQfg46qlA7mChHfUgCX0IqSXI3nNEoMedDxhZEK?=
 =?us-ascii?Q?2PEp5Hs+fOM6eMwu9KmuJ598FN4zUYPxNz+zABr9YFOsDZ9cwx31NHv2XAQl?=
 =?us-ascii?Q?KLY+3PQLdRxX04m0EKg5z2FFwt6k5GriI05UBZoFWLiY1qzZ4/IkZX70c3lS?=
 =?us-ascii?Q?4zkFLc+8z6ZSJWq6gxwopdbwh21HHRrfeejFwIj3OrdGcxGWCtiVLtkBfE96?=
 =?us-ascii?Q?/oeCx6k8k+MS+v8u2mT7xau4bpz5bYmYjRwEh9B0GOb9aLuZmsSrmKIVZPJf?=
 =?us-ascii?Q?u9a6ZFQV8kc0mnezl3m74FrjMLyXkxz/Bg0PLXjkhErzbcPQx5A6Q/dP3Fvm?=
 =?us-ascii?Q?dLNCE9QFampoqV64RcX7LVrsggYqdA6nbVI9TPYEGuM5eHPYOJBxPuH3wDyO?=
 =?us-ascii?Q?u+9zduAhVttms8r/xMPPssayag7lSQhYYPpc6/tXJv/kOXemjWu9rxGqvmqT?=
 =?us-ascii?Q?pBP6zFMOT3VAIIrQ6vN6Gles5D6WJOhv3pN8pGXKqLO6LqtBem+s/DES8QXl?=
 =?us-ascii?Q?gVrbyd8ACK9c8mF+tcxCR0T5w56vmm3TBads6oL4jTJFGU0IG0JkxIfhEGn3?=
 =?us-ascii?Q?8WZoqZ9u/54G0lnqDNQrnydpVtuhpdm/VuO6upULL/PlqdB/FPH895Navtj4?=
 =?us-ascii?Q?OXs2QUg/p530cxHsdHCmlJXl0Mpctr+l2lafG3HrdG00eFMipvMRo+nhK/RP?=
 =?us-ascii?Q?Gk0to3FSU87LFOOGS61nFGJ+0Ha3ZViGb3VrNvynUJPGNK4QGXgOCjELCutk?=
 =?us-ascii?Q?HG+R2VFUA1LKpGvl+Yp6+5hsKYapIaWknJqyGTaddm6C1tFAKEjU65wn8ZtR?=
 =?us-ascii?Q?N/cdPMH/WgZ6lrcndwodwKy3SdHOZbdq5h/HXn6rFKXknImXmjizaoD4+6M4?=
 =?us-ascii?Q?/e4vOXZTk0gcdTOtfvTtuAmNucGLeh+fzp+EtBafUDBN2kLYGDvrAyd/mO5J?=
 =?us-ascii?Q?fpv8yFtcluGE3dpQ1zpDdA77wcTdhU508jdJvCHmf1rwAJr1ZicrdtMpPPlj?=
 =?us-ascii?Q?jxduGCJjMVEVQOTztR65MLTY/BSflNk55oOQfjVOMOfJeT6MHwLZIWO8076X?=
 =?us-ascii?Q?ayEnMHrhL2Oa1AQhH17Czu7dE4CnuSW82R8WFgZsXD4SV457vCk00VmHX+NH?=
 =?us-ascii?Q?Id5+Q2vMVu6Qk9z7tJ+uHd4BkUHPVLpB3oXQ5cjSdKI1jD6I0TbLS2/6Q5Bu?=
 =?us-ascii?Q?Oefh2iOiGB7Q1nF47E5ldqY2SjlOQkIxGYJbHl2J5uBO5LI8mHN5ODNFP8Jx?=
 =?us-ascii?Q?/KKbtB4W/EHcQixLPWvoc5PVuHekcR8TXIQK4T5MFcW3dZUnpTWrQOabXqK6?=
 =?us-ascii?Q?LUNmc8/SeYvjwh+4iy1nE3GxjGkDfANtnzarzUiAa7lMOg7Ab0QYDnzl0cbX?=
 =?us-ascii?Q?NlFAsABgKY9Wyo6gxV2FRnknSUd1NmQhD+qdi0hxRDarRGH7kMJfaK6jAOc2?=
 =?us-ascii?Q?MXuS+yZmhq6gHEwuPshBE0l+xVbVk9W9A6hAHZgXTetLPvUgBFdQwlENXMRx?=
 =?us-ascii?Q?4XHtnqnJl0yIcUZT+lM9KLkDnkz1Pzs0FMFuTxRvFg7PZNcqxWRUMe1drcaj?=
 =?us-ascii?Q?98ISYw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1293.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c4093a0-6306-447d-40b3-08d9bc38dfd3
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2021 23:57:50.7860
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZAqWtPl5AfSG0+S961k6Y+Mn8HuSb4mb1QEP1UGuNWSISnFmqdszIk+NR48bOgijnPAyDl58TJK/Ez69M8XO11nL+JzDrBRHEbsTvND4FAc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB2048
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Friday, December 10, 2021 11:38 AM
> To: Vladimir Oltean <olteanv@gmail.com>
> Cc: Ong, Boon Leong <boon.leong.ong@intel.com>; David S . Miller
> <davem@davemloft.net>; Giuseppe Cavallaro <peppe.cavallaro@st.com>;
> Alexandre Torgue <alexandre.torgue@st.com>; Jose Abreu
> <joabreu@synopsys.com>; Maxime Coquelin
> <mcoquelin.stm32@gmail.com>; alexandre.torgue@foss.st.com;
> Kanzenbach, Kurt <kurt.kanzenbach@linutronix.de>;
> netdev@vger.kernel.org; linux-stm32@st-md-mailman.stormreply.com;
> linux-arm-kernel@lists.infradead.org; Nambiar, Amritha
> <amritha.nambiar@intel.com>
> Subject: Re: [PATCH net-next 0/2] net: stmmac: add EthType Rx Frame
> steering
>=20
> On Fri, 10 Dec 2021 13:57:30 +0200 Vladimir Oltean wrote:
> > Is it the canonical approach to perform flow steering via tc-flower hw_=
tc,
> > as opposed to ethtool --config-nfc? My understanding from reading the
> > documentation is that tc-flower hw_tc only selects the hardware traffic
> > class for a packet, and that this has to do with prioritization
> > (although the concept in itself is a bit ill-defined as far as I
> > understand it, how does it relate to things like offloaded skbedit prio=
rity?).
> > But selecting a traffic class, in itself, doesn't (directly or
> > necessarily) select a ring per se, as ethtool does? Just like ethtool
> > doesn't select packet priority, just RX queue. When the RX queue
> > priority is configurable (see the "snps,priority" device tree property
> > in stmmac_mtl_setup) and more RX queues have the same priority, I'm not
> > sure what hw_tc is supposed to do in terms of RX queue selection?
>=20
> You didn't mention the mqprio, but I think that's the piece that maps
> TCs to queue pairs. You can have multiple queues in a TC.
>=20
> Obviously that's still pretty weird what the flow rules should select
> is an RSS context. mqprio is a qdisc, which means Tx, not Rx.
>=20
> Adding Amritha who I believe added the concept of selecting Rx queues
> via hw_tc. Can you comment?

So tc-mpqrio is the piece that is needed to set up the queue-groups. The of=
fload
mode "hw 2" in mqprio will offload the TCs, the queue configurations and
bandwidth rate limits. The prio-tc map in mqprio will map a user priority t=
o the
TC/queue-group. The priority to traffic class mapping and the user specifie=
d
queue ranges are used to configure the traffic class when the 'hw' option i=
s set to 2.
Drivers can then configure queue-pairs based on the offsets and queue range=
s
in mqprio.

The hw_tc option in tc-flower for ingress filter is used to direct Rx traff=
ic to the
queue-group (configured via mqprio). Queue selection within the queue group=
 can
be achieved using RSS.

I agree mqprio qdisc should be used to set up Tx queues only, but the limit=
ation was the
absence of a single interface that could configure both Tx and Rx queue-gro=
ups/queue-sets
(ethtool did not support directing flows to a queue-group, but only a speci=
fic individual
queue, TC does not support Rx queue-group configuration either). The hw_tc =
in mqprio is a
range of class ids reserved to identify hardware traffic classes normally r=
eported
via dev->num_tc. For Rx queue-group configuration, the gap is that the ingr=
ess/clsact qdisc
does not expose a set of virtual qdiscs similar to HW traffic classes in mq=
prio.
This was discussed in Slide 20 from Netdev 0x14=20
(https://legacy.netdevconf.info/0x14/pub/slides/28/Application%20Device%20Q=
ueues%20for%20system-level%20network%20IO%20performance%20improvements.pdf)

-Amritha
