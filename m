Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB70E30DCA3
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 15:25:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232805AbhBCOYo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 09:24:44 -0500
Received: from mga01.intel.com ([192.55.52.88]:40990 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232630AbhBCOYW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 09:24:22 -0500
IronPort-SDR: S/RHToSjoS47HYey3EZ9aSo19Jo0qnaQpNykd7xD1fPyjpWqts0kHNAYRw45Cf82Foowo4YgLh
 tMfwlWbmB5iQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9883"; a="200006805"
X-IronPort-AV: E=Sophos;i="5.79,398,1602572400"; 
   d="scan'208";a="200006805"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2021 06:23:37 -0800
IronPort-SDR: UoYSR6SI29ViMl7/dJYOkqbVzHetjGMZVmx8BuzUWIOguvlUD6SSzonqa8xT98wVIx3i7qkHhk
 rLd8PAT62Jtg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,398,1602572400"; 
   d="scan'208";a="356044804"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by fmsmga007.fm.intel.com with ESMTP; 03 Feb 2021 06:23:37 -0800
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 3 Feb 2021 06:23:37 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Wed, 3 Feb 2021 06:23:37 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.48) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Wed, 3 Feb 2021 06:23:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U2B7LIDSkfg3XkfAf88wqN/Z0w4z+A2Ssi1PDhQ4r+559Es9Var9uLiUmewMUGiDGVdnOVklKchOZuUm2pN9d/8LiwuJ5legXg8BBvWx3fZFUNY6ThHfLx514Tbp3MYmdpVAR++8wuluptyiaA6rHJ8OcqZDgXA7cgRv6QnmiN9ofAPOlPAfIbIV93vUHEoK9TqCAev0YVxfW6bJBmIg6zBspqM+agcrFSmdkuGgFbOn3l+q3wUYYfsjI3plQlEUmidcDcgSAbXnhXSFV/oSRUtx2Q5E28afW3zgBKBkH7lxQvWNxjdCCES2vvRGXpTYcpBqIDGAmzfCaufBfN5Lkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GzSGXbfqDtidsCMeotmKvNsQUuHpUY0D7NW6mzsCS88=;
 b=DxYPqQ/8qfxrNvK9Ie2cU19ZXCaFrZcF7umOz5O7xnD502ofSWDeZRyiAnOUsz1/ai5ERD5FzAD+kXU5InxhQKbB0HtrnjypATAUP80I0wUZf3zWWJDP2E0QMbHtqv+2lB0L46Tiag1N6tUVyqdQSlpGhyMFmDHj42RrQKTdgkWhJI1/dYiq6oJ3WuDwYt074nrKtDY6tfXTzYy+yS5eOnJ7Yw+0edeDfBGaJskc7ZqBtzEBmtN1eSXeh+LCF+A49vaLJzTalktw49GDv/4k0RgAYUE7BGl1VGhRxhQw/XrxhGtduMRiFS+Wj0AFWjLTJ/+KfyOIE0axGVWS9ND0Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GzSGXbfqDtidsCMeotmKvNsQUuHpUY0D7NW6mzsCS88=;
 b=a9hZUfhsEVwMF9RdEAnguKdwlul9v1wZPkW/C0csx2lrfIms5nc5IahH06HxnNJPlUsJ9GnrGk1VQLihn3GCwQfPKijhBT4vBrR+opFAieqRwikMQfnjS7yRvB1/tvbuCaZFrlBVTOcifF+j84D2+ib5zYLgMlvVDQSQYbL7k3w=
Received: from DM5PR11MB1705.namprd11.prod.outlook.com (2603:10b6:3:e::23) by
 DM5PR11MB1801.namprd11.prod.outlook.com (2603:10b6:3:106::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3805.23; Wed, 3 Feb 2021 14:23:35 +0000
Received: from DM5PR11MB1705.namprd11.prod.outlook.com
 ([fe80::107f:2c5c:9306:60dc]) by DM5PR11MB1705.namprd11.prod.outlook.com
 ([fe80::107f:2c5c:9306:60dc%8]) with mapi id 15.20.3805.028; Wed, 3 Feb 2021
 14:23:35 +0000
From:   "Sokolowski, Jan" <jan.sokolowski@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Pierre Cheynier <p.cheynier@criteo.com>
CC:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [5.10] i40e/udp_tunnel: RTNL: assertion failed
 at net/ipv4/udp_tunnel_nic.c
Thread-Topic: [Intel-wired-lan] [5.10] i40e/udp_tunnel: RTNL: assertion failed
 at net/ipv4/udp_tunnel_nic.c
Thread-Index: AQHW+Uqdc/IE4u4j8EOiyAzwHoyhlapFDuGAgAFmtOA=
Date:   Wed, 3 Feb 2021 14:23:35 +0000
Message-ID: <DM5PR11MB1705DDAEC74CA8918438EBA599B49@DM5PR11MB1705.namprd11.prod.outlook.com>
References: <DB8PR04MB6460F61AE67E17CC9189D067EAB99@DB8PR04MB6460.eurprd04.prod.outlook.com>
 <20210129192750.7b2d8b25@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <DB8PR04MB6460DD3585CE95CB77A2B650EAB59@DB8PR04MB6460.eurprd04.prod.outlook.com>
 <20210202083035.3d54f97c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210202083035.3d54f97c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [109.241.79.187]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 39a70258-b5d2-4b58-6800-08d8c84f4adc
x-ms-traffictypediagnostic: DM5PR11MB1801:
x-microsoft-antispam-prvs: <DM5PR11MB180131FC020FD6D3F902295599B49@DM5PR11MB1801.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OG7khll4ahJciyK9oSvDOzE76jcvvJbBuxpvzwEtzNO5t4Dv8Zx/eElZ68FA0tfyE46uPkMuD0F/G9X6fyXBZrJ4X28aiUsQGi1bP14TVyvwozsOhKeGKpILpdqEivNpeuW0ipfUPPTNun92Gudkkcr6e+se1VbYOcL+0JpPpZHLYa5+8QPAqlN7u3gIh4qcbqGBfTGLgGmhNGPF0mFcx+4GT8UJ7+Z0RpDFMgFw6dyOcvr2tqMQmU61NrK8KSadS/TApWmSI5k/AiWjeNWHy4b3VWXnAEKdAFWdjgJJH8zWHcpYy3a/3bZqaBKpikuXoFputDv/6N9R2jEBf9loMPvDEEuSCKZ6Ll50Tf0E+U4wLxdLMXA2eOYQZB4rpQ149/NrDhrBpneYcUZ2QjlphrcEb1JtZDvM5aaWYaLc+0vMklIIQTcbyVeDuwx8N3P1oYKohnV7gpfrwi0EjpTm23aqDssStNBrqp+3jU1bAVj2H5JFDHrIsxzGw9WYAzJ46PhgD/dQKd0hqkF2bX0WqopmZH43HS2Qz5WsFrPadGtTNmcBVRNp8G1SlLindqLRdptEVkmxLyDX5FYhhvTXzMxzTbHdxldI413IpHnU0IE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1705.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(39860400002)(136003)(346002)(366004)(5660300002)(52536014)(83380400001)(76116006)(26005)(7696005)(9686003)(66476007)(66446008)(64756008)(66556008)(66946007)(8936002)(110136005)(8676002)(55016002)(4326008)(53546011)(6506007)(86362001)(316002)(54906003)(478600001)(33656002)(966005)(71200400001)(2906002)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?HXW6N7lW7r+PtXq5k4OflWKqy/bJOFGmSOEK6RprKZfglybo3i4in3AJy39l?=
 =?us-ascii?Q?VWWWNZwehONw94bhVVm/YLL6O3tra7FvBtUoJeY7/A32sQN3YTT3kBKNrRj3?=
 =?us-ascii?Q?+U2zW1f/ru9nZySie36C9fEsWlAGbtMKKmmhPJlL5AzNumIEX7qAkOyS2EYT?=
 =?us-ascii?Q?iGtiEILLg1xyeqcEU2LqaFoQ+IO3UgDT4fdIJSNmO0S9py06p4GQ5Jkh5e2T?=
 =?us-ascii?Q?rCET9qWoYZ9qVR19seyfoxXP1MdvYwihG7QgXk1I5MN/MbzS0FYyUuxmQDff?=
 =?us-ascii?Q?NI/p6QzoFSoyokda3vcsSZYzbFpXNrvhxoXVVCYLQebGYRgAU0MlUFddYUTm?=
 =?us-ascii?Q?BjusClNEwQh+Co60KWAmNHB1x2c+o4eIYLbMBiGZSuwNrYvIe7yndmiAZK7/?=
 =?us-ascii?Q?fldR/sTKrPd0Juc6VTJvQAysUcNLSELplwu6ma2WHy9cS1+9H2yAYwIN7ab9?=
 =?us-ascii?Q?oPldtu+lX36SdXe13jLQPeYODkLA4+iUBvbiBHVPd3o3bl/Ih0deCp2nBjZ8?=
 =?us-ascii?Q?K5RwnTIXtyEroKBYghT6JFU2z4GAG6GtrKO7UN2v6y3zpLRJye/gD0XLCWXn?=
 =?us-ascii?Q?78u7Fnvu6Zbs2b6Apxkyv0C47bDCyoePVpke/PF9bpSRbv3+2fXI/fyC/eBz?=
 =?us-ascii?Q?OylCQf1uZMANSiWxYZFRJTkqeAcmP1HNmW6V49RxPmIRD6JvpWTEjEnqRury?=
 =?us-ascii?Q?vQ8cZK18WBrG1rl8yO7sU/8bqsksyRTTXuWpckCe0E9qlI6Kmt5Aaft3D3s8?=
 =?us-ascii?Q?Y/AkxVR/GitpDCWtK4UZitvjRJYllIK02TXOi1WlX8RvHmajOpU5u4p3Bdr4?=
 =?us-ascii?Q?3UCq7nVJezHLGM8PshAcHXlH7Kl9pN2pgKncmiyrp3Y4mU/+NPopYxWNvdBm?=
 =?us-ascii?Q?CKlANmEOUJt1nZ7RvERcM7BXEB2pWHsYjEphWx0pIMjH3JhgfNR9qAtSYAMI?=
 =?us-ascii?Q?w/FwyqRtM3lhQ+RFfUxPk358SoE8HO5ogtDJPFMVvti748/76vHdUqZWCXB8?=
 =?us-ascii?Q?3OR8p4tCyHlIp6iYJMuBFPh15vLwo0Yvg90FDkwFhMl7a7bF5nf0VsyqiZNp?=
 =?us-ascii?Q?NmOgBUhCeSyVsifvH83mO+fDXLD7V4vBVT1oaANSSurVa6ohi9PK9yicwZ4m?=
 =?us-ascii?Q?8Gpi+WhPAYOyO0g0GtEDH2mQaKt0m426teO7egBsNNAZRMXS+cSRiEzxwGrJ?=
 =?us-ascii?Q?qlU52l8GDMO1Dbd/a7V8x8v2mBWaL2sfiVoOtZaSQriuMAusFJWWJ3XA02UH?=
 =?us-ascii?Q?RBTbzuMfccC0rZ6tOyObJoXzw4RiZCMUOFfeUagAcrq21TKIazGhnpFLK1j9?=
 =?us-ascii?Q?2lZY1e5SvFLLpLY+jgkiN9sM?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB1705.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39a70258-b5d2-4b58-6800-08d8c84f4adc
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2021 14:23:35.1387
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tmuhFdRKWFfHGcPOydtc2KxMvsaFYSKIUhSkuWPjNfL2WAlMDwRJsmki06KG7WVJC4leAIBVvM+6IkCL85cmC3cJnLjpA4WjpnmlhwTnmMU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1801
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It has been mentioned that the error only appeared recently, after upgrade =
to 5.10.X. What's the last known working configuration it was tested on? A =
bisection could help us investigate.
Jan


-----Original Message-----
From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of Jak=
ub Kicinski
Sent: Tuesday, February 2, 2021 5:31 PM
To: Pierre Cheynier <p.cheynier@criteo.com>
Cc: intel-wired-lan@lists.osuosl.org; netdev@vger.kernel.org
Subject: Re: [Intel-wired-lan] [5.10] i40e/udp_tunnel: RTNL: assertion fail=
ed at net/ipv4/udp_tunnel_nic.c

On Tue, 2 Feb 2021 09:59:56 +0000 Pierre Cheynier wrote:
> On Sat, 30 Jan 2021 04:27:00 +0100 Jakub Kicinski wrote:
>=20
> > I must have missed that i40e_setup_pf_switch() is called from the probe
> > path. =20
>=20
> Do you want me to apply these patches, rebuild and tell you what's the
> outcome?

I was hoping someone from Intel would step in and help.
_______________________________________________
Intel-wired-lan mailing list
Intel-wired-lan@osuosl.org
https://lists.osuosl.org/mailman/listinfo/intel-wired-lan
