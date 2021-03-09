Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DEB0332BFA
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 17:28:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbhCIQ2L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 11:28:11 -0500
Received: from mga03.intel.com ([134.134.136.65]:11822 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230495AbhCIQ17 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Mar 2021 11:27:59 -0500
IronPort-SDR: 41z6RP9gaWkj0MlRFDb2Apa4YGIwqf5XJBngAuDYdmRwjz8FeYOR0DsBZqaGYtUrG/qezutEKU
 hfWtdF28vaSw==
X-IronPort-AV: E=McAfee;i="6000,8403,9917"; a="188314609"
X-IronPort-AV: E=Sophos;i="5.81,234,1610438400"; 
   d="scan'208";a="188314609"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2021 08:27:58 -0800
IronPort-SDR: c9SUnPNOMNuYlPTmE+9CrTABN2CV82VdDj8pxwzBdBCj1fIElbcH/GQkjbcp7S18+1mczLN2Rv
 zcjk/bz8Y4ag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,234,1610438400"; 
   d="scan'208";a="437964531"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by FMSMGA003.fm.intel.com with ESMTP; 09 Mar 2021 08:27:57 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 9 Mar 2021 08:27:57 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 9 Mar 2021 08:27:56 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Tue, 9 Mar 2021 08:27:56 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Tue, 9 Mar 2021 08:27:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QUOEQ1DtGysMzxnulWkwNOAYkKTxSCfmNUqSUocvrAQQd8Jrpl2Mh3373mIDCh52oQfy9dDHLP44M0sn/XXmGtuqGGwZneVO6zFza2p65cOCnAU7shVgWElsqJ8GSObs3lEHOOhg0meNFHpA1J+28XZRSLqeYoMbAGSD7UOMD6Lgxq6f1zj85aoPIYwLxXNi4Ocr7+DCesSfcpJHOcw7nVopksKg6fENEj7T9+5GzsF+ll1IFUR1zHkwO/yI1D6aA4PwLnMN7xUwcQCXHFWOSfB67JYJOU1ljXwxxKsPGDfVEoG/eSK8u2PCFN2X1QK/lytPjRY9rlXDJWP9nG27NA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X7P6zxPoNVY3Lw1wRvBSkqxdyUqxL+n7cxWycbcrsU4=;
 b=Gt353SE5YHa0BsEu1Edfg5rGJJFXqXbGnAln3/ifkczngsLzknKpg/UG0+jIzSpLo7PtnAzZaDPM8VxkBH+HQakD6PciYeXfTOdeuqwdxJaLNLggqqNqU39fiEpZd8DtG3e/g3irGWpUmIUlZ+M7b732omgTAVOW9Zi+tmrU3Sh0Qcn5esE5+6OTw2bL2RSHogvlYXoQGXZHepzHFoIt1NBX/64DQOsvzAfYNDdUJYcj1SLQ9vcmsSrFoHp2pEBNKVoDcZbiW/PKEujeC8s84ujX1ezasTKx75v3Ri6dW7LHE1Fx9IKb2rBudoA8FhGiCStaB2TS3qQQ25256whk1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X7P6zxPoNVY3Lw1wRvBSkqxdyUqxL+n7cxWycbcrsU4=;
 b=bWZbfHsMc3ZT2wc54D3EpIkPZ6hjOOh0SV/53hXxMnzwBfxhDpHCYYNcoBrN8Y/jk6G30HsKAfnEUD6nvX5BwPRA+/5MeKwsIo6KnQ1j5MYfqEPLReMAlJCLh3fzRUy04HUWfr8lyT9JA5XV0NtaiSiLY6QbfvtuvbCFjXRd6Mk=
Received: from SA2PR11MB4940.namprd11.prod.outlook.com (2603:10b6:806:fa::13)
 by SA2PR11MB4986.namprd11.prod.outlook.com (2603:10b6:806:114::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.19; Tue, 9 Mar
 2021 16:27:50 +0000
Received: from SA2PR11MB4940.namprd11.prod.outlook.com
 ([fe80::c5d3:e5b4:55f7:e4e7]) by SA2PR11MB4940.namprd11.prod.outlook.com
 ([fe80::c5d3:e5b4:55f7:e4e7%6]) with mapi id 15.20.3912.027; Tue, 9 Mar 2021
 16:27:50 +0000
From:   "Jambekar, Vishakha" <vishakha.jambekar@intel.com>
To:     "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "Topel, Bjorn" <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Subject: RE: [Intel-wired-lan] [PATCH intel-net 3/3] ixgbe: move headroom
 initialization to ixgbe_configure_rx_ring
Thread-Topic: [Intel-wired-lan] [PATCH intel-net 3/3] ixgbe: move headroom
 initialization to ixgbe_configure_rx_ring
Thread-Index: AQHXEEUH8Nc9g3xIYU6gxcaam7uqB6p732Xw
Date:   Tue, 9 Mar 2021 16:27:50 +0000
Message-ID: <SA2PR11MB4940862C67B9242DB23C4B86FF929@SA2PR11MB4940.namprd11.prod.outlook.com>
References: <20210303153928.11764-1-maciej.fijalkowski@intel.com>
 <20210303153928.11764-4-maciej.fijalkowski@intel.com>
In-Reply-To: <20210303153928.11764-4-maciej.fijalkowski@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [103.228.147.111]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 215bbd74-21da-4cec-26de-08d8e3184843
x-ms-traffictypediagnostic: SA2PR11MB4986:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR11MB4986E3C767E2792287705D1FFF929@SA2PR11MB4986.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QvoZAjQNzFazy1CyzwTrD1rwUw24n1e4hXb/kt+Vq9yZp9q8Zy+Xw/zaO3k2ZSUJka3lXx/BGRHhR6qZN+gI8QCvJwjes7zgSV4AM4ZEzw+bIinWVcwo4m9+ujH8rYt69Q3AMAmc/xlGOk8JZJ+Ll8s6MG8AajxyBCgvaW0dat+1dSeKazS6mYeKVGs1EWLM15HpeAyg8BOzpNP/58F+FXoTf3rPYY7S1CcGhZfI9dXeotqSSqX+0oVtPZ3sonrh44O1aQBKjvVXGEi/h41J82nlRC5Fud/TT7sZzIlCQwVOTO7NRcmYC0QTuvB3TYY7s9SAXKkwWtLwiCwV+OqXSgmC8kWmq8or2r5LNSzznLBp2wWRmuYDj+fRez1r8NK0e08HfYTGlYbPlA5iy22XaeZuDRZ8cs08wq1Ujmyw+tHkDEnOSdX/3k+06spHpZGazydBOW5BNCbNH2+uHVJ0DxqEnN3Hi7QGDBVQUoGFRHza3+klUlBhn0WMRkbZYKpNpbWXt2lNDjxfU1FjUAUXSQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR11MB4940.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(376002)(346002)(39860400002)(396003)(52536014)(26005)(316002)(66946007)(9686003)(107886003)(5660300002)(66476007)(83380400001)(186003)(478600001)(55016002)(110136005)(54906003)(8936002)(66556008)(66446008)(8676002)(33656002)(86362001)(7696005)(71200400001)(53546011)(6506007)(76116006)(4326008)(2906002)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?oXAt4FFEg8cjKdJfIOk2qlaFuI1KrfVPGAMFkwjFQQwqRlvRpROTs5YwnySf?=
 =?us-ascii?Q?jb33ROa7R3Hio5vHnii4z2Ym3iILwwpdzUEv2dv5YOVNXjb6QZHo2prnnwZb?=
 =?us-ascii?Q?f+46otzgitQ3v6NgTUszFIULtqsLY6q50NGKEPYe19+cCQ7wVAUgUvshN/ih?=
 =?us-ascii?Q?l9T0v7SPNXB1ehC1n1eXh5a6iMkER1i9S8VJpXaZHkPwydrriOQ+2aZ0r2Gb?=
 =?us-ascii?Q?zLaifhEgaV0/yX0Jk3yGzBGh87U3+4+u6Yzi7RXF1XXZxi3W3xhB56eZpsJu?=
 =?us-ascii?Q?95L3q/JvXZEDSYMsVwwUAG1EyHUDoRL176NwPyZLSHwNWBfXoacrabiN9Jc3?=
 =?us-ascii?Q?g3KH5SBUixTvZdVHC+XtOlW8s9dyjmoT00AKYdPBpCm3gn0zknGnqRvQIdKc?=
 =?us-ascii?Q?U0d+x3j5c9S/Iaut0NAf0T41OqV+y7oM4OdUM6WTYceSRTC+H8pr/2ZEleo7?=
 =?us-ascii?Q?Ecvt3618DZfbKegofxC1Ijbbvc2fdbpb9ZL5nmTzyQvnHkX0w2pIL0Dm/Zra?=
 =?us-ascii?Q?D8NITV/6KKq5v79dt4a6/rrdOirWD2ES99uDHXuYs3p61uUMsWGYFS0elV8w?=
 =?us-ascii?Q?a2+yfBvhiFVgCeQerstZ3QSs4fxpCIy32XkG4wivrjid98slwuX6sNI5OiIE?=
 =?us-ascii?Q?dIEr3BJUnd/qTrw7k7uJMEHwcF5ZqklA7laBoN88po+pXGI8KMm5oZr5AM7d?=
 =?us-ascii?Q?Ik6BpngocOlAAxeYs/Lp9/Z/B6rV+0WJh/R6uSr3lCTrs9hn3vg+E4gKVQ3R?=
 =?us-ascii?Q?8qrvQkBaJLIWIzyS4NQGtw6448t8aSD1c7HYcndDNDCVQk6RdqvYUvydNfxb?=
 =?us-ascii?Q?iZzFDRpcXD7zVGdD/C7teqUBIOUJKdipL8FB4Ape0eDgL1TEB0H400IVoLk2?=
 =?us-ascii?Q?r/fStmx2bz/LTdzR0NO4Eh4BWw5L07Tfk3lNtptYj79JmAHX7hkTsEoic2jr?=
 =?us-ascii?Q?iOsa7ZxmxBfzDIUsp7CMWy8tlN9Dmy4DjCUJ9SirMzsTdw5ZeBH8RGSTo+AL?=
 =?us-ascii?Q?ebBOMILbzpocraeeS2D8Q1ka8klhTC4+n7NtTLbPsNkstHCCVV93BKggQts9?=
 =?us-ascii?Q?YjoBV9OuUXMLzEEAQJhSu2X1fUqwuNkHB1+TAGXjSWuDQp24jZslqCbHyGuo?=
 =?us-ascii?Q?PA4D9Oko6iCGEp3Gr2NwAFpojQNffMwTWJdsU+z80qbjrMxeLvBH9IsYl/Ve?=
 =?us-ascii?Q?WtUo7sL0Qq0SoBFsBjzmawrkg9CGIAWltI120veKZyCrIcW22pT5jSDtDr6a?=
 =?us-ascii?Q?+NICh0gooDjCaf2n33Eu6P0NlUXYRzRv3pJ+rV2cJMRUaXmcovTjssbK1tdv?=
 =?us-ascii?Q?VQrSiy3pgelssqIpgm6YGQFm?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR11MB4940.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 215bbd74-21da-4cec-26de-08d8e3184843
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2021 16:27:50.2452
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Fod1DguLw5x9jt6vBjyAA4PEi4JJdm11nYhnVHJm++09CYjcV6Yp9Kx6oOWmQPX/cbDNPksDjtJjqt8xPp3Stc6auBgu0hTaKcv+2+FlKEc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4986
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Maciej Fijalkowski
> Sent: Wednesday, March 3, 2021 9:09 PM
> To: intel-wired-lan@lists.osuosl.org
> Cc: netdev@vger.kernel.org; brouer@redhat.com; kuba@kernel.org;
> bpf@vger.kernel.org; Topel, Bjorn <bjorn.topel@intel.com>; Karlsson,
> Magnus <magnus.karlsson@intel.com>
> Subject: [Intel-wired-lan] [PATCH intel-net 3/3] ixgbe: move headroom
> initialization to ixgbe_configure_rx_ring
>=20
> ixgbe_rx_offset(), that is supposed to initialize the Rx buffer headroom,=
 relies
> on __IXGBE_RX_BUILD_SKB_ENABLED flag.
>=20
> Currently, the callsite of mentioned function is placed incorrectly withi=
n
> ixgbe_setup_rx_resources() where Rx ring's build skb flag is not set yet.=
 This
> causes the XDP_REDIRECT to be partially broken due to inability to create
> xdp_frame in the headroom space, as the headroom is 0.
>=20
> Fix this by moving ixgbe_rx_offset() to ixgbe_configure_rx_ring() after t=
he
> flag setting, which happens to be set in ixgbe_set_rx_buffer_len.
>=20
> Fixes: c0d4e9d223c5 ("ixgbe: store the result of ixgbe_rx_offset() onto
> ixgbe_ring")
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
Tested-by: Vishakha Jambekar <vishakha.jambekar@intel.com>
