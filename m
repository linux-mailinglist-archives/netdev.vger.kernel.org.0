Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82D3427F9DB
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 09:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730415AbgJAHDK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 03:03:10 -0400
Received: from mga11.intel.com ([192.55.52.93]:51969 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725878AbgJAHDI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 03:03:08 -0400
IronPort-SDR: wbkqjiEQkIgpZoxcWN2c8RgfVi2DKYRtZeKffTxvYuDRDrjC+30/FxyxrQm9qb5H9Cqdtk0oFH
 13qq3d7WLcmA==
X-IronPort-AV: E=McAfee;i="6000,8403,9760"; a="159970844"
X-IronPort-AV: E=Sophos;i="5.77,323,1596524400"; 
   d="scan'208";a="159970844"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2020 00:03:07 -0700
IronPort-SDR: NznTBKtR/XBr4xUZJtZnCqCOEOb6eti80F+NyWHbpI0uZ43OKa0f7dqmxL0ZVH5E6XDkkrGWBL
 80k67rAZq97w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,323,1596524400"; 
   d="scan'208";a="351002516"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by FMSMGA003.fm.intel.com with ESMTP; 01 Oct 2020 00:03:07 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 1 Oct 2020 00:03:06 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 1 Oct 2020 00:03:06 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.40) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Thu, 1 Oct 2020 00:03:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UYVlQgif78vdOL/HbkWNbAJ54ygeWZ9TZmEaIyknDK6D9CyfqKq8yKLrcSlz2in+GmhjNEp1Q5yv8Ie0ejClSL8/AchRBumrgzDTbaKkkU1n4aCKY3dRj9k8SYyvhOzkrSvKJt4Ni9mhUJwC38sqwABLVrC2mW/u9DTgPBuhCXZy/j53FYDorwVHyliiy3DX45mLs1s1bufVxhcH2phLQU+JroQRknEsH4Z/4KfYGgO/sEK+RzJmdDA3je/4H1BY42yRMnMTJb4mhqUri7aw0CYxKOOlgAMpY5WwP3MDWZHyPbGFhKbizs4Fu5jbfVUhhZ2s5t4KcbLhRi3ZN9vyeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BuEQ8Ul38qkmXxvLGJRCP094Tz0nbQBTSrt46rmV5To=;
 b=dQtdf9VvlOISlFHS+4i1ADQxwSVopUi7HfKP9M5uN4ySboMJ1gw+Tm6XVWlr6U4Wp8hz3Oyd8MFBRV6kCpExN4EpstGvGznwWKwqXiqYXS0JUcRIOcL6wztrSza7DmPRUhVeRbah1K9skLISqpE1Q8GAznMTXCu5x3FofP7LfdVuzhSHS32unjwXOCStY3jqqgQzFNqpzUg04oTVVkiOv1nFRjnkCuqqNn5LBO2xYVUg3fj0HZ+i8DonxBV5qKN9mgmS3W0IERlMPFl10RZEieqgpoH6tPexhRnvgMNKBPm5c0JI83ywVHsCdPxHGkUJUac7Wo4ymQIstcP+euohtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BuEQ8Ul38qkmXxvLGJRCP094Tz0nbQBTSrt46rmV5To=;
 b=vR6SRQZyrJb6f8eaA0bD3WDmc9+tS1KFhOFGCMwXDQl+aREMk/V/4yUi40+n+EBu9l2789rhdsd0SjUby20kGd+Nb4V0yzcK5tZNRlP+U559u3K+c6RCtxmxYrZKob3xURlSA093/Nm0DZKSyb3Vb1AshcmVFHOw/ZACqAwYy2U=
Received: from DM6PR11MB2890.namprd11.prod.outlook.com (2603:10b6:5:63::20) by
 DM6PR11MB2891.namprd11.prod.outlook.com (2603:10b6:5:71::28) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3412.25; Thu, 1 Oct 2020 07:03:04 +0000
Received: from DM6PR11MB2890.namprd11.prod.outlook.com
 ([fe80::8c79:e56f:7f8b:ebe4]) by DM6PR11MB2890.namprd11.prod.outlook.com
 ([fe80::8c79:e56f:7f8b:ebe4%7]) with mapi id 15.20.3412.028; Thu, 1 Oct 2020
 07:03:04 +0000
From:   "Brown, Aaron F" <aaron.f.brown@intel.com>
To:     Tong Zhang <ztong0001@gmail.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH] e1000: do not panic on malformed
 rx_desc
Thread-Topic: [Intel-wired-lan] [PATCH] e1000: do not panic on malformed
 rx_desc
Thread-Index: AQHWhfynZPHLUfowgUSbCO3qc22yBamCdVeg
Date:   Thu, 1 Oct 2020 07:03:04 +0000
Message-ID: <DM6PR11MB28906E70A61ADFD7A3BF1AE7BC300@DM6PR11MB2890.namprd11.prod.outlook.com>
References: <20200908162231.4592-1-ztong0001@gmail.com>
In-Reply-To: <20200908162231.4592-1-ztong0001@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [97.120.130.218]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9a27224b-1399-43e5-19cc-08d865d80b2c
x-ms-traffictypediagnostic: DM6PR11MB2891:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB289158F0010973CFC6562EC0BC300@DM6PR11MB2891.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2733;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9NzcWC1GN1xNJ0LcJb7OXdIXEe3iwamXEPmtAKxtvhiQsLUfGRPFccR7LZ7446PfiAfvz3Mc/JAVY6UXQjcuW2prxYmFgHrfw8qU4PQKOt95A5zsinumKCgMANlBi4/d/mkITMLVtVZK9g6zr53NoaeNMlAyWkY2UFnlRW5dmM8pBV2wXGqFs2U0VxpErIWHF05uw0XYL4WFbOjy9JxispROtq0Q/7U3Ujsn7xref8SZRUzzAhuM0JjIQMR7Mt5h3n4MMLIm5CtMhKahFGb6huTTYhjDi9wg5SZ6LROhM1YqrYVfrZlCm9k8G2TzjTTuiUeqMbwT7ExcbWlVWdA3oSdwmO/MA1YIsfIldcptrQCo6ssW6/Oz57ShyudCC9zJ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2890.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(136003)(366004)(376002)(396003)(8676002)(83380400001)(6506007)(53546011)(186003)(26005)(7696005)(9686003)(55016002)(66556008)(110136005)(316002)(8936002)(33656002)(71200400001)(5660300002)(52536014)(66446008)(86362001)(64756008)(66946007)(478600001)(2906002)(66476007)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: R7iOC3gVJOLL9qfsY2gDaDJb94Rypwt7+Nhs5PnXLj8FYkPYZy/pTgcHnfx3651PpwBtv5I/RBRhbZI+9ZmyjlTkK3oepc03NBP55cg15hwzFpqMYDfy622ECnPjwH1wfFS/5Gx/qdeU67bcXP2ScaWf3mV3aDDFS1hGv9fJAhkemCnhxadzAPY99jj87gAZmGWeI+o35nwNs5EEEEQXyvspMx1o/91MB0VIWcSjr5d/LOWTOYcmmp4waRFSJjnqsuSApy6z7rVIY2bv0gSSxqexEhH4NTqhCcGivPMB5q68tzTUv2gq8clidXae0rEHlBAOKqPzXAezfdyNUs+LKd9YbFufhzB3naqrSNfSKs8KnNknkHsE6oadGQO+LIfChpdqWSTi65yyOw/JObo7C9kdHVzBMFehZAPQJjc1npj+1JVZ76A1iU2H8SncN1c3pD3JvvL9Gy4TBaoN/IvHVEA1hP1zDk4Ht0pp8o/vyFN6rNdlIwyGvQr5kvikVoGLqTO/YRz4Si1YlNcJpTCusPw1k+qq3hVPY0HAkn/JGUmjGGYUVa6hYVgsUgh8tnVzP9W5Mx5Py4xgUkrDRiyE1tsnjS2uYvHemmuzfL/YRI1XHYc6lo+50QVyFqfh3UfW3M6xl/6vk3gzQw2S+CcYSA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2890.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a27224b-1399-43e5-19cc-08d865d80b2c
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Oct 2020 07:03:04.5827
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oU9tSEN3sBCjedgJbJC8+lTqMPUQlly+igNchurigN+MGNOOLcBHT79+XBfBawO93InaIPohTtvcUiA6EXecpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2891
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of T=
ong
> Zhang
> Sent: Tuesday, September 8, 2020 9:23 AM
> To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>; David S. Miller
> <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>; intel-wired-
> lan@lists.osuosl.org; netdev@vger.kernel.org; linux-kernel@vger.kernel.or=
g
> Cc: ztong0001@gmail.com
> Subject: [Intel-wired-lan] [PATCH] e1000: do not panic on malformed rx_de=
sc
>=20
> length may be corrupted in rx_desc and lead to panic, so check the
> sanity before passing it to skb_put
>=20
> [  167.667701] skbuff: skb_over_panic: text:ffffffffb1e32cc1 len:60224
> put:60224 head:ffff888055ac5000 data:ffff888055ac5040 tail:0xeb80 end:0x6=
c0
> dev:e
> th0
> [  167.668429] ------------[ cut here ]------------
> [  167.668661] kernel BUG at net/core/skbuff.c:109!
> [  167.668910] invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC KASAN PTI
> [  167.669220] CPU: 1 PID: 170 Comm: sd-resolve Tainted: G        W      =
   5.8.0+
> #1
> [  167.670161] RIP: 0010:skb_panic+0xc4/0xc6
> [  167.670363] Code: 89 f0 48 c7 c7 60 f2 de b2 55 48 8b 74 24 18 4d 89 f=
9 56 48
> 8b 54 24 18 4c 89 e6 52 48 8b 44 24 18 4c 89 ea 50 e8 31 c5 2a ff <0f>
> 0b 4c 8b 64 24 18 e8 f1 b4 48 ff 48 c7 c1 00 fc de b2 44 89 ee
> [  167.671272] RSP: 0018:ffff88806d109c68 EFLAGS: 00010286
> [  167.671527] RAX: 000000000000008c RBX: ffff888065e9af40 RCX:
> 0000000000000000
> [  167.671878] RDX: 1ffff1100da24c91 RSI: 0000000000000008 RDI:
> ffffed100da21380
> [  167.672227] RBP: ffff88806bde4000 R08: 000000000000008c R09:
> ffffed100da25cfb
> [  167.672583] R10: ffff88806d12e7d7 R11: ffffed100da25cfa R12:
> ffffffffb2defc40
> [  167.672931] R13: ffffffffb1e32cc1 R14: 000000000000eb40 R15:
> ffff888055ac5000
> [  167.673286] FS:  00007fc5f5375700(0000) GS:ffff88806d100000(0000)
> knlGS:0000000000000000
> [  167.673681] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  167.673973] CR2: 0000000000cb3008 CR3: 0000000063d36000 CR4:
> 00000000000006e0
> [  167.674330] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> [  167.674677] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
> 0000000000000400
> [  167.675035] Call Trace:
> [  167.675168]  <IRQ>
> [  167.675315]  ? e1000_clean_rx_irq+0x311/0x630
> [  167.687459]  skb_put.cold+0x1f/0x1f
> [  167.687637]  e1000_clean_rx_irq+0x311/0x630
> [  167.687852]  e1000e_poll+0x19a/0x4d0
> [  167.688038]  ? e1000_watchdog_task+0x9d0/0x9d0
> [  167.688262]  ? credit_entropy_bits.constprop.0+0x6f/0x1c0
> [  167.688527]  net_rx_action+0x26e/0x650
>=20
> Signed-off-by: Tong Zhang <ztong0001@gmail.com>
> ---
>  drivers/net/ethernet/intel/e1000/e1000_main.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)

Tested-by: Aaron Brown <aaron.f.brown@intel.com>

Again, regression tested.  I was not able to trigger the panic with or with=
out patch.
