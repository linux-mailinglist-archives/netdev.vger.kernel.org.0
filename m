Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C08333114DE
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 23:23:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbhBEWRU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 17:17:20 -0500
Received: from mga14.intel.com ([192.55.52.115]:5670 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232660AbhBEOcQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 09:32:16 -0500
IronPort-SDR: H5vdRrsGa+w0JxyWpNwaT+qTmyR7OFd43f0BVaUlLvRrBxCef+mFKJpCREUhhSBrw9OMPAwhEl
 4m+5s0arihYA==
X-IronPort-AV: E=McAfee;i="6000,8403,9885"; a="180675951"
X-IronPort-AV: E=Sophos;i="5.81,155,1610438400"; 
   d="scan'208";a="180675951"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2021 08:08:40 -0800
IronPort-SDR: qiv2rwkjSseH8TYMNYg2WPeDlqf+g6NvHx+Qxibg58JR3FqgzlfZJyPb6na3HK9FhDF/EiD/Qj
 MeeABYGKacDg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,155,1610438400"; 
   d="scan'208";a="576744452"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga005.jf.intel.com with ESMTP; 05 Feb 2021 08:08:39 -0800
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Fri, 5 Feb 2021 08:08:39 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Fri, 5 Feb 2021 08:08:39 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Fri, 5 Feb 2021 08:08:39 -0800
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (104.47.46.51) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Fri, 5 Feb 2021 08:08:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K0/+3rW0skfKrMMu+ZXmLaaoVoFPaHF3RuV/ol3XhlHmZBFd1OhWDnsGocuGs5FqHNN77zzZmtPWEtu7+NKwNPTeAXtpzQPwUpDGxU3iS9GFUTVcNCTF1oG6iLxvH6fAZWgoKSD49FP5fxbS2vNdPzbzX+ZsXTJ4MVG1tvMP4hDqJzZblKWxrbguvEcr6dyGBBU0HZMyopT/28Krb2t4+WZnUkczu+Vjfc8ONyrhxMYUEVN4YMzfQOMBE+RNRaJMhCfG/qK3HxAAhXuoeG1NnRFeGUWefGu1LQS9Xug+CiAeRCJwKB9M2ePE7xwuPsCnB8vDR9qGcvJogrFBsBrOEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Ob6yr3sJjx3ZA9xssfIBKKkhXq3AFkMlchy8aC6qAg=;
 b=iP+Se35ELKOyq3Kj9olRlG0x9ihIlfKA390Hv8NB1TBhKC8Ip4t6zU9JaF5IryLuznV12lOAAbk7JkPuBZikutoTvoZvhdxZ7/UjfGO2tKCbtJFTgE60pMVfw+EsN4nFy0RYOomyqFDUig8LCHgUFVQslMgaweHLLhcykq6aqx2a6O74lqyg0dXG0HmzCjdqXsDfZJpvXaRXB4jki6OrcmtSrciLlJXET4b4CM1LmC/J4wQoQ1wWqTculZIPcfX/0I/uPqk3sNp6kcOmcLtyPS4aW1B8V3hN3nufydGovZSjlfFfniQH7q+ovLExZFMa2cE20uwlA+9OsYve+Uh/VQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Ob6yr3sJjx3ZA9xssfIBKKkhXq3AFkMlchy8aC6qAg=;
 b=xvIvp1YBn/sJkdWaNoS3zo9Ih6LXnnR1lwzSMo9/P904UKK6Dcxu5XmyDOp/bJeVZ4gN0mFxHtEu9RkwW3XmAMgWchlxnL68zAIBnKpcpg24xmroKpuhIxIHJCwpjLxtjKeDmpwni1WwObF3AXvBc/6UOCPit21XcG1nlyqfKLw=
Received: from SN6PR11MB3008.namprd11.prod.outlook.com (2603:10b6:805:cf::18)
 by SA0PR11MB4528.namprd11.prod.outlook.com (2603:10b6:806:99::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.20; Fri, 5 Feb
 2021 16:08:32 +0000
Received: from SN6PR11MB3008.namprd11.prod.outlook.com
 ([fe80::611e:f342:6f85:db95]) by SN6PR11MB3008.namprd11.prod.outlook.com
 ([fe80::611e:f342:6f85:db95%6]) with mapi id 15.20.3825.020; Fri, 5 Feb 2021
 16:08:32 +0000
From:   "Kuruvinakunnel, George" <george.kuruvinakunnel@intel.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "Topel, Bjorn" <bjorn.topel@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "maciejromanfijalkowski@gmail.com" <maciejromanfijalkowski@gmail.com>
Subject: RE: [Intel-wired-lan] [PATCH net-next 1/3] i40: optimize for
 XDP_REDIRECT in xsk path
Thread-Topic: [Intel-wired-lan] [PATCH net-next 1/3] i40: optimize for
 XDP_REDIRECT in xsk path
Thread-Index: AQHWyLz15gTR9TXEl0eaK2pF+GVjdapKGkww
Date:   Fri, 5 Feb 2021 16:08:31 +0000
Message-ID: <SN6PR11MB30083E9D31D4C018C4283DDAE2B29@SN6PR11MB3008.namprd11.prod.outlook.com>
References: <20201202150724.31439-1-magnus.karlsson@gmail.com>
 <20201202150724.31439-2-magnus.karlsson@gmail.com>
In-Reply-To: <20201202150724.31439-2-magnus.karlsson@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [27.61.31.119]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 61ca1718-d73a-4702-fc18-08d8c9f048cd
x-ms-traffictypediagnostic: SA0PR11MB4528:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA0PR11MB4528CECA3C0AF7045E21A5C2E2B29@SA0PR11MB4528.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JTzjabuVmGJ5pMmfQ1F+BksZ5Q9UW8kMRXFoIGry5nsjPNgHrHix4CfFybDBR9ZKST+ZLFjB0/BTb06n66Ufc11Mjqe8O6iNlcVuoSHNtYHZE8nxjBDbTwOPONehIugn+xclI4ZTpzipJm3p0Wjj0m8CCxAgC2gzvLmV67PocJZsg8CbgakCHJ5qkUT7ZdtemVOUautkdtm4qIog9oWAIUy8u7iKuGFPSTmA1TWTXD4LH7pE72Bey7ndrx76CO9jLgzLQ075dRCPorQ/XcKxK1Ebwfl/ParDKOiWy0sMCmZI3ozgu9Bd4IKJVZvJksLfCj58K2YSzYWHKEGn7Qg6Ic77QJ6vXylYK30eLnT6WyN/Ngpn+midugGooffxBolPyLCvPhkJvXRJvq4Q9zKUTQPkSXE+ESmYR1Ayn9RC/BwLH3wwRNgA0ZyU1vgVcajDYragWilnhCo6mgfpCSnsfa0IZtt/UBZErnlSnHVRFC8m7i/J9uQFz3nJj8wUv5KR0qtgGUgeiqg+5k3gZwfQRg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3008.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(39860400002)(366004)(346002)(376002)(8936002)(83380400001)(5660300002)(6636002)(8676002)(33656002)(76116006)(4326008)(4744005)(478600001)(66446008)(64756008)(66556008)(6506007)(7696005)(2906002)(53546011)(26005)(71200400001)(66946007)(86362001)(52536014)(316002)(9686003)(66476007)(55016002)(54906003)(186003)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?TBGAR4Ck/yAB2Y8sl2jqIcP57P0T5jeVdMeSX/7Etr8FAtcvx+A3J5B2e/4F?=
 =?us-ascii?Q?YzGgl6oXjNvr/irfuZlpVftx4Gwmea+2AjpzSg7qfVWBAfp+vycGQlG1QjIl?=
 =?us-ascii?Q?BUKhzVN7ORAW9x3j40yQes01ZofT12wxBKZPfjxujvy1ki2YnGz1BfM0JQ2+?=
 =?us-ascii?Q?bEIwhhguENYdG5h5c8GizyqmMwSb/3YijYzlnaHp12tZtX+62zonzv+8zae0?=
 =?us-ascii?Q?r131GPTLTwVMSFTISgjzXkSmzDzyM2vgIke4MzetgoANZSZygr056LjTUHW/?=
 =?us-ascii?Q?7gvY4lKt6up0cHjVDuMpNsEpIF4EWlGl6xoinDXpEvUplKDxgEU+5PHf3xSl?=
 =?us-ascii?Q?5Vh4E/3xJwSkn44ATLnftp8UxSYc1cNVv5TRbg3RfnpjmopfFvts4mryPiN8?=
 =?us-ascii?Q?u3p5FThFi20hNZtDYJqvKXX/Dzw4DQvLrU5ZW009OGcXpUzKHveTR75SIX3B?=
 =?us-ascii?Q?0TydhxF2birnlIHpHe2AXrLVwSiktivfUFWrgI4+CjDlb8A9xdxMZmlRWo48?=
 =?us-ascii?Q?grryBIj4ATQvw8O11Cc3rvJMM6YS/cI/WSIPcUqHT2Lfj0JfY5Yw4T3qdO2d?=
 =?us-ascii?Q?kajYS8sxSukfCv9drm/addI3Fec4PN96uyZzVC7JF+c9E7/48czSKYyHIhQJ?=
 =?us-ascii?Q?sP2xPoyfJlcQw5ZxViK89Gj+VZDo6/tDTUjzXMfZF5qDg0P1V1Af3Mw9dMnr?=
 =?us-ascii?Q?EZnJdsPPQDDacQ18Bsgav0MKKiDEvAOPIcCZvb7gQ4ROBwZFNUatjhxjKYRL?=
 =?us-ascii?Q?bNgSDTLJg6RaFU+QLerOMs8B6pS5HX5A2C2THBQEKeJQI1pNMVsweg+o/isW?=
 =?us-ascii?Q?0yxFF4FdFPe+xbhPLiNo4jmsR3nyBucLfqePlpwytwVwJWhFEeBCwEbXuT8P?=
 =?us-ascii?Q?XZme1WjCTzck/PF9pIk/R9/b9lDzVGFI6KXkrr/O75DbCt4VGkB0XsYvTCkX?=
 =?us-ascii?Q?AYQJgwCWmy87I8+shW2/Rnk8S03c3HcB4u55XVo5r4/byjkuhw218p5p/hej?=
 =?us-ascii?Q?fQG5LzBy5CFZkKGr7YDvRiT2FN+fYtuyG1s7zQkBoocCD3ORKEgmvCPZLoN1?=
 =?us-ascii?Q?ndEmtJy5Qdx10o2HzE/9R9H+mNReXJD09XllMEIeoix1Xn2zIiGgoUh6FPQP?=
 =?us-ascii?Q?/kwteu6HuXTmN4fdSr3PTFj3ooH713UWJGCAeCi0r4nSNGee0yNdQQWaVEOL?=
 =?us-ascii?Q?4z7sY6achP4ItWruggTQfZYXdjmufzD9WoUVGkECJ9WP6dNZjIfWFENNnE8w?=
 =?us-ascii?Q?Ebjbo37gewlSSi6YqH8DciDp8ISZ/6jJY+5b1pWsDIHD9row4u4b0XpsUASf?=
 =?us-ascii?Q?3lvJpMCJ3m7/ccE7XzLXoIOX?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3008.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61ca1718-d73a-4702-fc18-08d8c9f048cd
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Feb 2021 16:08:32.2089
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1aBT9Fxki+TaYqpI5yQvuy7yD1HdzvqBMdP+EMRWCWnxrqbzx2rQCTKQnnIwX8xR5vYg4yM5mRbEYZ9cx0JTVEXSpzdmqfy41ovg1cFCV30=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4528
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of M=
agnus
> Karlsson
> Sent: Wednesday, December 2, 2020 8:37 PM
> To: Karlsson, Magnus <magnus.karlsson@intel.com>; Topel, Bjorn
> <bjorn.topel@intel.com>; intel-wired-lan@lists.osuosl.org; Nguyen, Anthon=
y L
> <anthony.l.nguyen@intel.com>
> Cc: netdev@vger.kernel.org; maciejromanfijalkowski@gmail.com
> Subject: [Intel-wired-lan] [PATCH net-next 1/3] i40: optimize for XDP_RED=
IRECT
> in xsk path
>=20
> From: Magnus Karlsson <magnus.karlsson@intel.com>
>=20
> Optimize i40e_run_xdp_zc() for the XDP program verdict being XDP_REDIRECT
> in the zsk zero-copy path. This path is only used when having AF_XDP zero=
-copy
> on and in that case most packets will be directed to user space. This pro=
vides a
> little over 100k extra packets in throughput on my server when running l2=
fwd in
> xdpsock.
>=20
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> ---
>  drivers/net/ethernet/intel/i40e/i40e_xsk.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
>=20

Tested-by: George Kuruvinakunnel <george.kuruvinakunnel@intel.com>

