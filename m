Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA1291F471A
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 21:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389235AbgFITa4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 15:30:56 -0400
Received: from mga12.intel.com ([192.55.52.136]:45308 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728679AbgFITay (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jun 2020 15:30:54 -0400
IronPort-SDR: R4lIrMH1fjl2sLDc77VuumpJBtAgYRZpGcwOASqctkdx62sS4jZFu99zt1b/DdtadFjGTGKjLG
 2uMf+MwXcrfw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2020 12:30:53 -0700
IronPort-SDR: XcHdzAUjgcIQHtmmTnIckvf2Q4YfKoAJFpFpP8BjN2dTqIlFjNike9eDRf227ItDY9yyi8fkBx
 +Cjkgupf1Phw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,493,1583222400"; 
   d="scan'208";a="306358535"
Received: from orsmsx101.amr.corp.intel.com ([10.22.225.128])
  by orsmga008.jf.intel.com with ESMTP; 09 Jun 2020 12:30:53 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX101.amr.corp.intel.com (10.22.225.128) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 9 Jun 2020 12:30:53 -0700
Received: from orsmsx606.amr.corp.intel.com (10.22.229.19) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 9 Jun 2020 12:30:52 -0700
Received: from ORSEDG002.ED.cps.intel.com (10.7.248.5) by
 orsmsx606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 9 Jun 2020 12:30:52 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by edgegateway.intel.com (134.134.137.101) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 9 Jun 2020 12:30:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M5MjZlRx2bWhCbidonPMnvh0DcjQ/jXo0N+oJE7w026M1TawbV+pvf42Kajlbc5jh3GDBpMmDbyyfFa495QjyDiT7bicTBCVHVySnEBoY3BI6By2ahJG+6U8JhvjJnGOFmfNqgMY7rvQPS4dwTeICZ6O1Q/PrtaO5EVfnR5P8u9pMHS1G7+9kEEy3CWSXKDJPaNxABc6nCmhKOtCbALSiTqxu/2lOAtfPWjgreSMoKfggM3h0XqqE24oCEfvlJk633glQ3rbkX9FHLXFUNiGxyA8AcifZuB4Dv9EyLULv4+EEyRZSd3HQU3ypPvKVYMrKqcv6bec+XKwvUbYc8UD+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ng8j319KTrrE0Q6HLwN1cowq+HE3YxJ1Km6XHWvIpKw=;
 b=ncKRl/Vblw/Qm9HRpcJGre4y1DUWonAdw6gkfivNLxPCSmQ+JG2fY9O+kSI4sYHaZFTHuQ7et5VcT5fdtpZKkSxrVGn9QthtgtXyvX0syz8kFmN6tum6RqZcf6jNcTeN1pdZhtxGAd72H+NAYD9I+fwzUOytuBvmtwenAg3byuyZtmXW6mXpczf+IBw9UUtsAIJmXs1bOFZfqZ44ljnPCtUR4mHsvMXA/ntgFMa7ZgfqJew24DQwNyXSflFrrWYhBIDIABDvS1DujkxCu5eggyH0yBxuY096etAa+VXHv2j29PpnNXvqRTdqkf1zYU9M7mDL87/R2BkHCIJKz+IXWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ng8j319KTrrE0Q6HLwN1cowq+HE3YxJ1Km6XHWvIpKw=;
 b=nXivb8BGZaM1KhueGxdUZBv/ObSCVaXV89CEd0iT6oNguUtn+/1OGbNPt4dx21fe5R6T5Cukulzh+Rhufvb8AH1PN/cbJq2HTfr6vyTeuaX4N7MixQqLvknffDIabAS1XsxCghK8wCKHLMcCSB5aO7CYEUbyLWV4jnWW5KDZB5M=
Received: from BN6PR11MB4132.namprd11.prod.outlook.com (2603:10b6:405:81::10)
 by BN6PR11MB1938.namprd11.prod.outlook.com (2603:10b6:404:105::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.20; Tue, 9 Jun
 2020 19:30:51 +0000
Received: from BN6PR11MB4132.namprd11.prod.outlook.com
 ([fe80::2d67:42cc:d74f:6e4f]) by BN6PR11MB4132.namprd11.prod.outlook.com
 ([fe80::2d67:42cc:d74f:6e4f%7]) with mapi id 15.20.3066.023; Tue, 9 Jun 2020
 19:30:51 +0000
From:   "Williams, Dan J" <dan.j.williams@intel.com>
To:     "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "corbet@lwn.net" <corbet@lwn.net>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "amitc@mellanox.com" <amitc@mellanox.com>,
        "david@protonic.nl" <david@protonic.nl>,
        "linville@tuxdriver.com" <linville@tuxdriver.com>,
        "marex@denx.de" <marex@denx.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "petrm@mellanox.com" <petrm@mellanox.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "christian.herber@nxp.com" <christian.herber@nxp.com>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "o.rempel@pengutronix.de" <o.rempel@pengutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>
Subject: Re: [PATCH ethtool v1] netlink: add master/slave configuration
 support
Thread-Topic: [PATCH ethtool v1] netlink: add master/slave configuration
 support
Thread-Index: AQHWPpR7OD1wKnaFXUKDw1wTopujAQ==
Date:   Tue, 9 Jun 2020 19:30:50 +0000
Message-ID: <4d664ff641dbf3aeab1ecd5eacda220dab9d7d17.camel@intel.com>
References: <20200607153019.3c8d6650@hermes.lan>
         <20200607.164532.964293508393444353.davem@davemloft.net>
         <20200609101935.5716b3bd@hermes.lan>
         <20200609.113633.1866761141966326637.davem@davemloft.net>
In-Reply-To: <20200609.113633.1866761141966326637.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.5 (3.32.5-1.fc30) 
authentication-results: networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=none action=none
 header.from=intel.com;
x-originating-ip: [192.55.52.218]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1887d585-c6d2-45fc-864d-08d80cab9e79
x-ms-traffictypediagnostic: BN6PR11MB1938:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR11MB1938B42FE5BA6BE550CADE4DC6820@BN6PR11MB1938.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 042957ACD7
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EM+HKH/vRt80C+h146MPTOGi0JACaa8v4QYqswBqLJS1a+YZUTgbdAEo14ihEVHvWxw8m6hyoNNFQKuCtTvWarS59VF8WQiheFCo+2Xp+H1gccWJyF1N6FBM4gQNaq7NJ9jj8hyOo+gqTGdPWN1WVIpb1UR5aDp+Jg367yGuNwFoATl2JWlZ85AlV091yhB6d2mWtnegOCEGepbiG2IeU0Q6vuDOLeTxltyd4WTzeN2P49gMMrUybGEz8EpU9k3hzHjwFxCuJZ6p5OZOfHaSPy2NKCfag0j12Lgrmy6jHehxZukrGqG1unYhZA5GHLZ4tz584z+oXVpilAFb8LHVzg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB4132.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(136003)(396003)(39850400004)(366004)(346002)(316002)(36756003)(83380400001)(6486002)(2906002)(5660300002)(8936002)(76116006)(91956017)(4326008)(8676002)(186003)(6506007)(66946007)(7416002)(66446008)(66556008)(478600001)(110136005)(6512007)(64756008)(26005)(54906003)(66476007)(86362001)(71200400001)(2616005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: OAEaRBRZz5inXH/1iAX39vcU+ddX7vVSnaZ/SaBp3WIVvlVKLIwc9Djxbd5U8SfbZ//HDoA490yxYC9XkU2QkssWfLrSbS0ipBL+WeV+IWSU70oHgiXYG3IMN5EN7Tds7ahKUB5eQA8MTRekgT1kx4j2tDkAsqJvONq5VRUIXVPcGdEd2WG0YhMVlOEoIF/lJlebWQt8lFLltrGAo2iiE8prz004hYq3qJYYH0o/gXD0D1sUg07DzyjIYneARM+9obKS0/1HvUyNp+95M2WqQLdKFdCGZ4Q636tVL2pXQUFbt4QI+ILcFg+B2mv9XXeAXPasWbOl+77sK4k2UWmIr7d+KuHXYuhkE0S6V4Iomr6R9ifTx52q799yeQpZSVq6ppgkj70/rNl5QjNkB3IhL3JdICc0uwGqY97fHh1nS4ebhL6GEXcnhv1BucvaXEs2p9r0XLClUJo7l3UsZdpkeOlmj4o9fVvyQQhz97D8QYo=
Content-Type: text/plain; charset="utf-7"
Content-ID: <0360B25E816BA441BAFD0F63CF3D4BA5@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 1887d585-c6d2-45fc-864d-08d80cab9e79
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jun 2020 19:30:50.8231
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UfFnADy84izWNmZ5Z3jDFhjgTvSYk3PWwF5qcAvg/cWJGKuIeWXBmVYPNersvc8siv1fF7/RNImwqp4GbEw1aHBknW3gjSSl93MoZsDpr8s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1938
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-06-09 at 11:36 -0700, David Miller wrote:
+AD4- From: Stephen Hemminger +ADw-stephen+AEA-networkplumber.org+AD4-
+AD4- Date: Tue, 9 Jun 2020 10:19:35 -0700
+AD4-=20
+AD4- +AD4- Yes, words do matter and convey a lot of implied connotation an=
d
+AD4- +AD4- meaning.
+AD4-=20
+AD4- What is your long term plan?  Will you change all of the UAPI for
+AD4- bonding for example?

The long term plan in my view includes talking with standards bodies to
move new content to, for example, master/subordinate. In other words,
practical forward steps, not retroactively changing interfaces.

+AD4- Or will we have a partial solution to the problem?

Partial steps toward better inclusion are meaningful.

The root problem is of course much larger than a few changes to
technical terminology could ever solve, but solving +ACo-that+ACo- problem =
is
not the goal. The goal is to make the kernel community as productive as
possible and if the antropomorphic association of +ACI-slave+ACI- can be
replaced with a term that maintains technical meaning it makes kernel-
work that much more approachable.

I recall one of Ingo's explanations of how broken whitespace can make
patches that much harder to read and take him out of the +ACI-zone+ACI- of
reviewing code. +ACI-Slave+ACI- is already having that speed bump affect on=
 the
community. If we can replace it without losing meaning and improving
the effectiveness of contributors I think the Linux kernel project is
better for it.
