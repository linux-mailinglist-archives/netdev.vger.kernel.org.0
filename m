Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46682270B67
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 09:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbgISHYJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 03:24:09 -0400
Received: from mga05.intel.com ([192.55.52.43]:10522 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726157AbgISHYI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 19 Sep 2020 03:24:08 -0400
IronPort-SDR: KcN3sJDuKsSUikCWSbTUNqlVnWtqbVDQm52shaB0W/tj8yDrjjBKnNVEKrOu7I+GuSU2EYK1X7
 p5y9AqPxlOyA==
X-IronPort-AV: E=McAfee;i="6000,8403,9748"; a="244936545"
X-IronPort-AV: E=Sophos;i="5.77,278,1596524400"; 
   d="scan'208";a="244936545"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2020 00:24:02 -0700
IronPort-SDR: uZlcLpLxgp6oL9UjKBNCQTkY+yq/SC3Rg/79A9gbihMLLND5tNRnovVxtcT7fsR52JFteI9ID8
 KMvcp5rduI8Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,278,1596524400"; 
   d="scan'208";a="410580016"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga001.fm.intel.com with ESMTP; 19 Sep 2020 00:24:01 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sat, 19 Sep 2020 00:24:01 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Sat, 19 Sep 2020 00:24:01 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.104)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Sat, 19 Sep 2020 00:24:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z9c6HclJvhWoZbONv8l3SWTZFzHbowDOnpaaqGb27mvOo5nh5ZmOGSGJoczDTlg06HGhFa9kSFb4pqJBNR+qlmQ5l9nvmJ7ncGGbLbeYAEsITqx/yVofbtu+I2NXmEz3kWGYoNBaZPdA4Log5Zyhxxyl+ybYhPDErpCuDp69VfVg9PVF1LjXT1roHcfkkLDsUD1KQQZINdyRbjl/3arOTqHNttzvpr5n4q7uwi0aQFFr0cUE5oCaXQ57+qy8Yfl0DU4YuY1rS1B8DPkkeRqRjvtNXXDCQzcSMECluJLWf0DLTYBPi9uul900Prgfn4Rio8j4uWYTbkq6bRYP65w6qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uRmIFddQneAYTdjdqyyDFXUqraaNn+rhzCneTPTjakE=;
 b=HkLQ74R0FNEhmxF33TOAjms70urB1Bfw0TzpbMR5yHLpDvx5QpE7LPuufvyJBGn6FrrDsTxkRgb1kPHhwnmMtSmZD6C0pp7aXEB6DPkyLogyflI/Aa4/gIF4iZ3V2lqKVfEbf9jIFUwelce9uZ8eMNN2drMvwiqLlKRoffZUGVY3bnjxOlxsdVnHAb6lC6VuPAEKw7zlLDGZfuS+PQq8gMRq0foGrk867ua8dgoCFexy5zVmsbPfYiwGCB7Sz/ew2yz+EQB1A8Qy4e3D51sYMe1TzZGSkHd0bZKTn7o+2nBKS87sfW9KeaCcus9sOZY5VNqcPRE69KXXyNCw3u4tQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uRmIFddQneAYTdjdqyyDFXUqraaNn+rhzCneTPTjakE=;
 b=NcHuGcar+HHl9omxMdsNPVJLGpmD83P2vvcvgO3qw2O+jrRTnhF00I7DMeBfKk81AzSMSvwxH7O/MRoCVdAR8124CjwTalnMsn6pfrP3HU3unPuHpOipHmBwiSceWrBz8k/pVSFEJABM75chj4oyXZ6JeVzi2FjzQdkA//Tcmh0=
Received: from SN6PR11MB2896.namprd11.prod.outlook.com (2603:10b6:805:d9::20)
 by SN6PR11MB3504.namprd11.prod.outlook.com (2603:10b6:805:d0::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15; Sat, 19 Sep
 2020 07:23:58 +0000
Received: from SN6PR11MB2896.namprd11.prod.outlook.com
 ([fe80::c9a8:3bb2:d3cd:a5fc]) by SN6PR11MB2896.namprd11.prod.outlook.com
 ([fe80::c9a8:3bb2:d3cd:a5fc%7]) with mapi id 15.20.3348.019; Sat, 19 Sep 2020
 07:23:58 +0000
From:   "Brown, Aaron F" <aaron.f.brown@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: RE: [Intel-wired-lan] [PATCH net-next v1 4/7] selftests: net: add a
 test for shared UDP tunnel info tables
Thread-Topic: [Intel-wired-lan] [PATCH net-next v1 4/7] selftests: net: add a
 test for shared UDP tunnel info tables
Thread-Index: AQHWX8dOZ4BbyTdTwkWG90FktRFZ7Klv5vUw
Date:   Sat, 19 Sep 2020 07:23:58 +0000
Message-ID: <SN6PR11MB2896F5ACC5A59F7F330183FFBC3C0@SN6PR11MB2896.namprd11.prod.outlook.com>
References: <20200722012716.2814777-1-kuba@kernel.org>
 <20200722012716.2814777-5-kuba@kernel.org>
In-Reply-To: <20200722012716.2814777-5-kuba@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [97.120.208.31]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1a4df27a-b47c-4c6d-cf30-08d85c6cf9be
x-ms-traffictypediagnostic: SN6PR11MB3504:
x-microsoft-antispam-prvs: <SN6PR11MB3504F786B457B1FCCBDA0EBFBC3C0@SN6PR11MB3504.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oQYftaUwGlYzfc99S194AFfB2NNgwNCdqN6c6+jnEQZStEPz41n0cSSV1LrpbtHcm6CwmsgwT9YUbSTN1SxToBjmL2/M6iO3bO2P80Ql2HwA/YeQC+Jci4KwNygxaAxEslshDhmIt2w8IFR2YtkpBelRdLsIyHSBWPA0+EWRBPiwTClpu50hg96pKjgLiyIEJU29TUqrM+VXpqYnUOJ9C4JgaKjVwCdJwPrn/XfnJ72gj0+Opg695IUCtO9R2NOqvF1Y9QhokSpMBzUt8CjO1vKQMWf0C9Ro/jjL3FAzrEnfRFkeB9/GFkGK/Zily8kK18emHV1PBhRqDDlfcTBXqw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2896.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(376002)(366004)(136003)(396003)(52536014)(71200400001)(86362001)(316002)(66556008)(54906003)(33656002)(66446008)(66476007)(6506007)(53546011)(26005)(478600001)(186003)(4326008)(55016002)(76116006)(9686003)(2906002)(8676002)(110136005)(66946007)(7696005)(83380400001)(8936002)(5660300002)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: etmChiqd0/g2Q211gpdGAHGCJEtIqP9dS4ojSxrnjKF9Lio5BWXwCKj2iJANGcZKLAtDPPS0MihrFP21b43rk+EjJGj3c3oPlXMTRlHQM1H5sC5ze0kdDv5YFi2VnXTz3zU+CnANuaEjBCPoutgI+FowEI7AfYY966P26u4kjPzvP777cN6ylecddY5Rbo4PPmVzsEb6vw4VmoAofkCEoqVhdiLs9+gbtciy9B087Hmp9rgKDlTEJFKYBLbBt1vscGkHr+4IAwxV0kRMrt2hlxaOMtEVEI/aYsGHe0U9MQyLR+6a2Ha3I8CqTN/B8HKPfEFDwGWBKHNUohG8pFlkhMtl4BoJCdiK1uOgqmHM5xtlBuVdb+REzFe+H8EwyEQ3xKVkB/eTR5QxOqxlACHbqck9tpaZxGPmlsAVBU0WzLAZdGiAyQdGHOfxNvSuoCI4r/NSr3k6GX9rCIEeYFbxZZ2V1wWSU1fjVRFlZF8cf9nwLvcHMNiRVFOGkeBa/43fq3JnvlM+YQs/GrsRrLZBrKAIF9eneZdri8QhLOeHKysU4tyHZkELhcuvw/pQjqgBO9IfBgJfjY6bI6KpJSj8l4EbabcBWBAElQhAsZthROvNcOxDjgCDjzrWhJp6vQJA6YCREbsEuYUM4O+LsqA2ZQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2896.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a4df27a-b47c-4c6d-cf30-08d85c6cf9be
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Sep 2020 07:23:58.7741
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oNPCQZIAJObRXY7hvhYfbDBp06yok5Z19/pBfdvPvAjz8jTRNZKmwanSEAtVghXQ1V2YZFGc86LCIA56Ziwc5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3504
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of J=
akub
> Kicinski
> Sent: Tuesday, July 21, 2020 6:27 PM
> To: davem@davemloft.net
> Cc: netdev@vger.kernel.org; intel-wired-lan@lists.osuosl.org; Jakub Kicin=
ski
> <kuba@kernel.org>
> Subject: [Intel-wired-lan] [PATCH net-next v1 4/7] selftests: net: add a =
test for
> shared UDP tunnel info tables
>=20
> Add a test run of checks validating the shared UDP tunnel port
> tables function as we expect.
>=20
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  .../drivers/net/netdevsim/udp_tunnel_nic.sh   | 109 ++++++++++++++++++
>  1 file changed, 109 insertions(+)
>=20
I ran into two things while running this script.
1. The script as it exists in the git tree (Jeff Kirshers next-queue) is no=
t executable.  I don't know if that's a patch issue or translation into the=
 tree.  Easy enough to get around, but should probably be executable to sta=
rt.

2. The script runs into a handful of errors,7 to be precise.  I'm not sure =
if they are real failures, incorrect expectations or maybe something in my =
kernel .config (I have been using a minimal .config and enabling modules as=
 needed.)

The output I get from it is:
---------------------------------------------------------------------------=
-------------------------
u1518:[0]/usr/src/kernels/next-queue> cat ~/udp_tunnel-sh-outut.txt        =
                                                            =20
ERROR: table 0 on port 1: basic - VxLAN v4 devices
       check_table: wrong entry 0
       expected: port: 4789     type: 1
       have:     port: 0        type: 0
ERROR: table 0 on port 1: basic - VxLAN v4 devices
       check_table: wrong entry 0
       expected: port: 4789     type: 1
       have:     port: 0        type: 0
ERROR: table 0 on port 1: basic - VxLAN v6 devices
       check_table: wrong entry 0
       expected: port: 4789     type: 1
       have:     port: 0        type: 0
ERROR: table 0 on port 1: basic - VxLAN v6 devices
       check_table: wrong entry 0
       expected: port: 4789     type: 1
       have:     port: 0        type: 0
ERROR: table 0 on port 1: basic - another VxLAN v6 devices
       check_table: wrong entry 0
       expected: port: 4789     type: 1
       have:     port: 0        type: 0
ERROR: table 0 on port 1: basic - Geneve device
       check_table: wrong entry 0
       expected: port: 4789     type: 1
       have:     port: 0        type: 0
ERROR: table 1 on port 1: basic - Geneve device
       check_table: wrong entry 0
       expected: port: 6081     type: 2
       have:     port: 0        type: 0
FAILED 7/435 checks
u1518:[0]/usr/src/kernels/next-queue>
---------------------------------------------------------------------------=
-------------------------
The script sends messages to dmesg, most look to be informative "set" and "=
unset" messages, but I do get a handful of failed messages.  The dmesg queu=
e was cleared before the run so only contains the udp_tunnel-sh messages:
---------------------------------------------------------------------------=
-------------------------
u1518:[0]/usr/src/kernels/next-queue> dmesg|grep -i fail
[ 8909.179462] netdevsim netdevsim386 eth4: UDP tunnel port sync failed por=
t 10000 type vxlan: -110
[ 8909.328763] netdevsim netdevsim386 eth4: UDP tunnel port sync failed por=
t 20000 type geneve: -2
[ 8909.444028] netdevsim netdevsim386 eth4: UDP tunnel port sync failed por=
t 10000 type vxlan: -110
[ 8909.592049] netdevsim netdevsim386 eth4: UDP tunnel port sync failed por=
t 20000 type geneve: -2
u1518:[0]/usr/src/kernels/next-queue>
